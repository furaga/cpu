(* 干渉グラフの彩色 *)
(* 「最新コンパイラ構成技法」p226 - p231参照 *)
open Block

(******************)
(** グローバル変数 **)
(******************)
(* 関数内で登場する変数とその型 *)
let varenv = ref M.empty 
(* 現在割り当てを行っている関数 *)
let cur_fun = ref (Block.make_fundef {Asm.name = Id.L ""; Asm.args = []; Asm.fargs = []; Asm.body = Asm.Ans Asm.Nop; Asm.ret = Type.Unit})
(* 関数内で定義された変数の集合 *)
let def_vars = ref S.empty
(* %g0 - %g31 *)
let all_regs = Array.to_list (Array.init 32 (Printf.sprintf "%%g%d"))
(* %f0 - %f31 *)
let all_fregs = Array.to_list (Array.init 32 (Printf.sprintf "%%f%d"))
(* 既彩色の変数群。要はレジスタ *)
let precolored = ref S.empty
(* 彩色すべき変数群 *)
let initial = ref S.empty
(* ワークリスト *)
let simplify_worklist = ref S.empty
let freeze_worklist = ref S.empty
let spill_worklist = ref S.empty
(* スピルすべき・合併すべき・彩色済みの・スタックに積まれた変数群（ノード） *)
let spilled_nodes = ref S.empty
let coalesced_nodes = ref S.empty
let colored_nodes = ref S.empty
let select_stack = ref []
(* Mov系命令群 *)
let coalesced_moves = ref S.empty (* 文stmtのIDの集合 *)
let constrained_moves = ref S.empty 
let frozen_moves = ref S.empty 
let worklist_moves = ref S.empty 
let active_moves = ref S.empty 
let move_list = ref M.empty
(* 合併された変数の別名解決用 *)
let alias = ref M.empty
(* 隣接行列。高速化のため3種類の方法で定義 *)
let adj_set = ref S.empty	(* TODO *)
let adj_list = ref M.empty
(* 次数 *)
let degree = ref M.empty (* int M.t *)
(* 彩色結果 *)
let color = ref M.empty (* 作業用テンポラリ *)
let colorenv = ref M.empty (* regAllocWithColoring.mlで使用 *)
(* スピルされたときに作られた新しい変数 *)
let new_temps = ref S.empty
(* スピルされた変数群 *)
let spill_hist = ref S.empty

let args_env = ref M.empty

(******************)
(** デバッグ用出力 **)
(******************)
let print_S comment s =
	print_string comment;
	S.iter (Printf.printf "%s ") s;
	print_newline ()
let eprint_S comment s =
	Printf.eprintf comment;
	S.iter (Printf.eprintf "%s ") s;
	Printf.eprintf "\n"

let print_M comment m f =
	print_string comment;
	print_newline ();
	M.iter (fun x y -> Printf.printf "%s, %s\n" x (f y)) m;
	print_newline ()

let print_states () =
	print_string "PRECOLORED :";
	S.iter (Printf.printf "%s ") !precolored;
	print_newline ();
(*
	print_string "DEGREE :\n";
	M.iter (
		fun x deg -> if deg > 0 then Printf.printf "\td(%s) = %d\n" x deg
	) !degree;
	print_newline ();

	print_string "ADJ_SET :\n";
	List.iter (
		fun (u, v) -> if not (Asm.is_reg u && Asm.is_reg v) then Printf.printf "\t(%s, %s)\n" u v
	) !adj_set;
	print_newline ();
	*)
	print_string "ADJ_LIST :\n";
	M.iter (
		fun x ls ->
			if not (S.is_empty ls) then (
				Printf.printf "\t%s : " x;
				S.iter (Printf.printf "%s ") ls;
				print_newline ()
			)
	) !adj_list;
	print_newline ();
	
	print_string "SIMPLY_WORKLIST : ";
	S.iter (Printf.printf "%s ") !simplify_worklist;
	print_newline ();
	print_string "FREEZE_WORKLIST : ";
	S.iter (Printf.printf "%s ") !freeze_worklist;
	print_newline ();
	print_string "SPILL_WORKLIST : ";
	S.iter (Printf.printf "%s ") !spill_worklist;
	print_newline ();

	print_string "COLOR ENV : \n";
	M.iter (
		fun fName color ->
			M.iter (fun x y -> Printf.printf "\t%s: %s => %s\n" fName x y) color;
			print_newline ();
	) !colorenv


(**********************)
(** 彩色のための関数群 **)
(**********************)
let find x env = try M.find x env with Not_found -> Printf.printf "not found [%s]\n" x; raise Not_found

let add x v env =
	let find x env = 
		if M.mem x env then
			M.find x env
		else
			S.empty in
	let elt = find x env in
	let elt = S.add v elt in 
	M.add x elt env

(* 文stmtで使用される変数と定義される変数 *)
let get_use_def stmt fName =
	let (def, use) =
		match stmt.sInst with
			| Nop (a, t) | Set ((a, t), _) | SetL ((a, t), Id.L _) | Restore ((a, t), _) -> 
				([a], [])
			| VMov ((a, t), x, name) when Id.L name = fName ->
				([], [x])
			| VMov ((a, t), x, _) | Mov ((a, t), x) | Neg ((a, t), x) | FMov ((a, t), x) | FNeg ((a, t), x) | Save ((a, t), x, _)
			| Add ((a, t), x, Asm.C _) | Sub ((a, t), x, Asm.C _) | Mul ((a, t), x, Asm.C _) | Div ((a, t), x, Asm.C _) | SLL ((a, t), x, Asm.C _) | Ld ((a, t), x, Asm.C _) 
			| LdF ((a, t), x, Asm.C _) | IfEq ((a, t), x, Asm.C _, _, _) | IfLE ((a, t), x, Asm.C _, _, _) | IfGE ((a, t), x, Asm.C _, _, _) ->
				([a], [x])
			| Add ((a, t), x, Asm.V y) | Sub ((a, t), x, Asm.V y) | Mul ((a, t), x, Asm.V y) | Div ((a, t), x, Asm.V y) | SLL ((a, t), x, Asm.V y) | Ld ((a, t), x, Asm.V y) 
			| FAdd ((a, t), x, y) | FSub ((a, t), x, y) | FMul ((a, t), x, y) | FDiv ((a, t), x, y) | LdF ((a, t), x, Asm.V y)
			| IfEq ((a, t), x, Asm.V y, _, _) | IfLE ((a, t), x, Asm.V y, _, _) | IfGE ((a, t), x, Asm.V y, _, _) | IfFEq ((a, t), x, y, _, _) | IfFLE ((a, t), x, y, _, _)
			| St ((a, t), x, y, Asm.C _) | StF ((a, t), x, y, Asm.C _) ->
				([a], [x; y])
			| St ((a, t), x, y, Asm.V z) | StF ((a, t), x, y, Asm.V z) ->
				([a], [x; y; z])
			| CallCls ((a, t), name, args, fargs) -> assert false
(*			| CallDir ((a, t), name, args, fargs) when name = fName ->
				([a], [])
(*				([a], args @ fargs)*)*)
			| CallDir ((a, t), Id.L name, args, fargs) -> (* 関数呼び出しのときの生存解析がよくわからぬ *)
				([a], args @ fargs) (*Asm.get_arg_regs name*)
				(*	((*S.fold (fun x ls -> x :: ls) (Asm.get_use_regs name)*) [a], (Asm.get_arg_regs name) @ (args @ fargs))*) in
	(S.of_list use, S.of_list def)

(* Mov系の命令か *)
let is_move_instruction stmt = 
	match stmt.sInst with
		| Mov _ | FMov _ | VMov _ -> true
		| CallDir _ -> true
		| _ -> false

(* xの型を返す *)
let get_type x = 
	try 
		let t = find x !varenv in
		if t <> Type.Float && t <> Type.Unit then Type.Int else t
	with Not_found -> Type.Unit (* varenvに入ってないならType.Unitの変数 *)

(* adj_set用の関数群 *)
(* 変数u, v間に枝があったら、u ^ " " ^ vという文字列がadj_setに登録されている *)
let make_edge u v = u ^ " -- " ^ v ^ ";"
let mem_adj_set u v = S.mem (make_edge u v) !adj_set

(* 枝を追加 *)
let add_edge u v =
	let t1 = get_type u in
	let t1 = if t1 <> Type.Float && t1 <> Type.Unit then Type.Int else t1 in
	let t2 = get_type v in
	let t2 = if t2 <> Type.Float && t2 <> Type.Unit then Type.Int else t2 in
	
	assert (t1 = Type.Float || t1 = Type.Unit || t1 = Type.Int);
	assert (t2 = Type.Float || t2 = Type.Unit || t2 = Type.Int);
	
	(*
		1.u, vの型(Float/Unit以外はIntと見なす)が一緒で
		2.u, vが違う変数で
		3.(u, v)がまだ登録されていなければ
		新しく辺を登録する
	*)
	let uv = make_edge u v in
	let vu = make_edge v u in
	if t1 = t2 && u <> v && not (mem_adj_set u v) then
		(adj_set := S.add vu (S.add uv !adj_set);
		if not (S.mem u !precolored) then
			(adj_list := add u v !adj_list;
			let deg = find u !degree in
			degree := M.add u (1 + deg) !degree; ());
		if not (S.mem v !precolored) then
			(adj_list := add v u !adj_list;
			let deg = find v !degree in
			degree := M.add v (1 + deg) !degree; ()))
	
(* 文stmtに登場する変数とその型を返す *)
let get_vars stmt (Id.L fName) =
	let assign x name =
		let color = find name !colorenv in
		if M.mem x color then M.find x color else x in
	match stmt.sInst with
		| Nop (a, t) | Set ((a, t), _) | SetL ((a, t), Id.L _) | Restore ((a, t), _) -> 
			[(a, t)]
		| Mov ((a, t), x) | Neg ((a, t), x) 
		| Add ((a, t), x, Asm.C _) | Sub ((a, t), x, Asm.C _) | Mul ((a, t), x, Asm.C _) | Div ((a, t), x, Asm.C _) | SLL ((a, t), x, Asm.C _) | Ld ((a, t), x, Asm.C _) 
		| LdF ((a, t), x, Asm.C _) | IfEq ((a, t), x, Asm.C _, _, _) | IfLE ((a, t), x, Asm.C _, _, _) | IfGE ((a, t), x, Asm.C _, _, _) ->
			[(a, t); (x, Type.Int)]
		| VMov ((a, t), x, _) when t = Type.Float ->
			[(a, t)] @ [(x, Type.Float)]
		| VMov ((a, t), x, _) ->
			[(a, t)] @ [(x, Type.Int)]
		| FMov ((a, t), x) | FNeg ((a, t), x) ->
			[(a, t); (x, Type.Float)]
		| Save ((a, t), x, _) when List.mem x !cur_fun.fArgs -> [(a, t); (x, Type.Int)]
		| Save ((a, t), x, _) when List.mem x !cur_fun.fFargs -> [(a, t); (x, Type.Float)]
		| Save ((a, t), x, _) -> [(a, t)] (* xは型が分からないし他にも登場しているはずなので無視 *)
		| Add ((a, t), x, Asm.V y) | Sub ((a, t), x, Asm.V y) | Mul ((a, t), x, Asm.V y) | Div ((a, t), x, Asm.V y) | SLL ((a, t), x, Asm.V y) 
		| Ld ((a, t), x, Asm.V y) | LdF ((a, t), x, Asm.V y)
		| IfEq ((a, t), x, Asm.V y, _, _) | IfLE ((a, t), x, Asm.V y, _, _) | IfGE ((a, t), x, Asm.V y, _, _)
		| St ((a, t), x, y, Asm.C _) ->
			[(a, t); (x, Type.Int); (y, Type.Int)]
		| IfFEq ((a, t), x, y, _, _) | IfFLE ((a, t), x, y, _, _)
		| FAdd ((a, t), x, y) | FSub ((a, t), x, y) | FMul ((a, t), x, y) | FDiv ((a, t), x, y) ->
			[(a, t); (x, Type.Float); (y, Type.Float)]
		| StF ((a, t), x, y, Asm.C _) ->
			[(a, t); (x, Type.Float); (y, Type.Int)]
		| St ((a, t), x, y, Asm.V z) ->
			[(a, t); (x, Type.Int); (y, Type.Int); (z, Type.Int)]
		| StF ((a, t), x, y, Asm.V z) ->
			[(a, t); (x, Type.Float); (y, Type.Int); (z, Type.Int)]
		| CallCls ((a, t), name, args, fargs) -> assert false
		| CallDir ((a, t), Id.L name, args, fargs) ->
			begin
				(* 自分以外の関数を呼び出すなら、その関数で定義されるレジスタ間で完全グラフを作る *)
				(if name <> fName then
					let def_regs = Asm.get_use_regs name in
					S.iter (
						fun x ->
							S.iter (
								fun y -> add_edge x y
							) def_regs
					) (def_regs));
				[(a, t)] @ (List.map (fun x -> (x, Type.Int)) args) @ (List.map (fun x -> (x, Type.Float)) fargs)
			end

(* fundefの各文に現れる変数とその型の集合を返す *)
let get_varenv fundef =
	let env =
		M.fold (
			fun _ blk env ->
				M.fold (
					fun _ stmt env ->
						M.add_list (get_vars stmt fundef.fName) env
				) blk.bStmts env
		) fundef.fBlocks M.empty in
	(* 引数を追加 *)
	let env =
		List.fold_left (
			fun env x -> M.add x Type.Int env
		) env fundef.fArgs in
	let env =
		List.fold_left (
			fun env x -> M.add x Type.Float env
		) env fundef.fFargs in
	(* レジスタを追加 *)
	let env =
		List.fold_left (
			fun env x -> M.add x Type.Int env
		) env all_regs in
	let env =
		List.fold_left (
			fun env x -> M.add x Type.Float env
		) env all_fregs in
	let env = M.add "%dummy" Type.Unit env in
	env

let build fundef =
	let get_some (Some x) = x in
	M.iter (
		fun _ blk ->
			let live = ref (S.union blk.bLiveout S.empty) in
			let rec iter stmt_id = (* ブロックの命令を逆順に辿る *)
				let stmt = if stmt_id = "" then None else Some (find stmt_id blk.bStmts) in
				(* 文stmtで使用・定義される変数を取得 *)
				let (use, def) = 
					if stmt_id = "" then 
						(S.empty, S.of_list (fundef.fArgs @ fundef.fFargs)) 
					else 
						get_use_def (get_some stmt) fundef.fName in
				def_vars := S.union def !def_vars;
				if stmt_id <> "" && is_move_instruction (get_some stmt) then
					(live := S.diff !live use;
					S.iter (
						fun n -> move_list := add n stmt_id !move_list
					) (S.union use def);
					worklist_moves := S.add stmt_id !worklist_moves);
				live := S.union !live def;
				S.iter (
					fun d ->
						S.iter (
							fun l -> 
								Printf.printf "add_edge %s %s\n" l d;
								add_edge l d
						) !live
				) def;
				live := S.union use (S.diff !live def);
				if stmt_id <> "" then iter (get_some stmt).sPred in	
			if not (M.is_empty blk.bStmts) then iter blk.bTail
	) fundef.fBlocks
	
let adjacent n = S.diff (try find n !adj_list with Not_found -> S.empty) (S.union (S.of_list !select_stack) !coalesced_nodes)

let node_moves n = S.inter (try find n !move_list with Not_found -> S.empty) (S.union !active_moves !worklist_moves)

let move_related n = not (S.is_empty (node_moves n))

let freg_len = List.length Asm.allfregs
let reg_len = List.length Asm.allregs
let get_K t = if t = Type.Float then freg_len else reg_len

let make_worklist () =
	spill_worklist := S.empty;
	freeze_worklist := S.empty;
	simplify_worklist := S.empty;
	S.iter (
		fun n ->
			let t = get_type n in
			let k = get_K t in
			initial := S.remove n !initial;
			if find n !degree >= k then
				spill_worklist := S.add n !spill_worklist
			else if move_related n then
				freeze_worklist := S.add n !freeze_worklist
			else
				simplify_worklist := S.add n !simplify_worklist
	) !initial

let enable_moves nodes = 
	S.iter (
		fun n ->
			S.iter (
				fun m ->
					if S.mem m !active_moves then
						(active_moves := S.remove m !active_moves;
						worklist_moves := S.add m !worklist_moves)
			) (node_moves n)
	) nodes

let decrement_degree m =
	let t = get_type m in
	let k = get_K t in
	let d = try find m !degree with Not_found -> Printf.eprintf "D : m = %s\n" m; 0 in

(*		if not (S.mem u !precolored) then
			(adj_list := add u v !adj_list;
			let deg = find u !degree in
			degree := M.add u (1 + deg) !degree; ());*)
(*	assert (d - 1 >= 0);
*)	degree := M.add m (d - 1) !degree;
	if d = k then
		enable_moves (S.add m (adjacent m));
		spill_worklist := S.remove m !spill_worklist;
		if move_related m then
			(if S.mem m !colored_nodes then ()
			else freeze_worklist := S.add m !freeze_worklist)
		else
			simplify_worklist := S.add m !simplify_worklist

let push v stk = v :: stk
let pop stk = if !stk = [] then assert false else (let ans = List.hd !stk in stk := List.tl !stk; ans)

let simplify () =
	(* 次数のもっとも大きいものを選ぶ *)
	let (deg, n) = 
		S.fold (
			fun x (deg, n) ->
				let d = find x !degree in
				if d > deg then (d, x)
				else (deg, n)
		) !simplify_worklist (min_int, "") in
					
	simplify_worklist := S.remove n !simplify_worklist;
	select_stack := push n !select_stack;
	S.iter (
		fun m -> decrement_degree m
	) (adjacent n)

let add_worklist u =
	let t = get_type u in
	let k = get_K t in
	if not (S.mem u !precolored) && not (move_related u) && find u !degree < k then
		(freeze_worklist := S.remove u !freeze_worklist;
		simplify_worklist := S.add u !simplify_worklist)

let ok t r = 
	let typ = find t !varenv in
	let k = get_K typ in
	find t !degree < k || S.mem t !precolored || mem_adj_set t r(*List.mem (t, r) !adj_set*)

(* タイガーブックp215のbriggsの保守的な合併を実現している *)
let conservative u v nodes =
	(* nodesの型は全部同じ *)
	if S.is_empty nodes then
		true
	else begin
		let elt = S.min_elt nodes in
		let typ = get_type elt in
		let k = get_K typ in
		let tk = ref 0 in
		S.iter (
			fun n -> if find n !degree >= k then tk := !tk + 1
		) nodes;
		!tk < k
	end

let rec get_alias n = if S.mem n !coalesced_nodes then get_alias (find n !alias) else n

let combine u v =
	(if S.mem v !freeze_worklist then
		freeze_worklist := S.remove v !freeze_worklist
	else
		spill_worklist := S.remove v !spill_worklist);
	coalesced_nodes := S.add v !coalesced_nodes;
	alias := M.add v u !alias;
	move_list := M.add u (S.union (find u !move_list) (find v !move_list)) !move_list;
	enable_moves (S.add v S.empty); (* タイガーブックじゃ型あわなくねー？ *)
	
	let adj = (adjacent v) in
	S.iter (
		fun t ->
			add_edge t u;
			decrement_degree t
	) adj;
	let typ = get_type u in
	let k = get_K typ in
	if find u !degree >= k && S.mem u !freeze_worklist then
		(freeze_worklist := S.remove u !freeze_worklist;
		spill_worklist := S.add u !spill_worklist)

let coalesce () =
	let m = S.min_elt !worklist_moves in
	let (y, x) = find m !Block.move_list in
	let (x, y) = (get_alias x, get_alias y) in
	let (u, v) = if S.mem y !precolored then (y, x) else (x, y) in
	worklist_moves := S.remove m !worklist_moves;
	if u = v then
		(
		coalesced_moves := S.add m !coalesced_moves;
		add_worklist u)
	else if S.mem v !precolored || mem_adj_set u v then
		(
		constrained_moves := S.add m !constrained_moves;
		add_worklist u;
		add_worklist v)
	else if
			(S.mem u !precolored && S.fold (fun t flg -> flg && ok t u) (adjacent v) true) ||
			(not (S.mem u !precolored) && conservative u v (S.union (adjacent u) (adjacent v))) then
		(
		coalesced_moves := S.add m !coalesced_moves;
		combine u v;
		add_worklist u)
	else
		active_moves := S.add m !active_moves
		
let freeze_moves u =
	S.iter (
		fun m ->
			let (y, x) = find m !Block.move_list in
			let v = 
				if get_alias y = get_alias u then
					get_alias x
				else
					get_alias y in
			active_moves := S.remove m !active_moves;
			frozen_moves := S.add m !frozen_moves;
			let t = get_type v in
			let k = get_K t in
			if S.is_empty (node_moves v) && find v !degree < k then
				(freeze_worklist := S.remove v !freeze_worklist;
				simplify_worklist := S.add v !simplify_worklist)
	) (node_moves u)
		
let freeze () =
	let u = S.min_elt !freeze_worklist in
	freeze_worklist := S.remove u !freeze_worklist;
	simplify_worklist := S.add u !simplify_worklist;
	freeze_moves u

let select_spill () =
	let s = S.diff !spill_worklist !spill_hist in
	let s = if S.is_empty s then !spill_worklist else s in
	let m = S.min_elt s in (* TODO *)
	Printf.eprintf "choose %s\n" m;
	spill_worklist := S.remove m !spill_worklist;
	simplify_worklist := S.add m !simplify_worklist;
	freeze_moves m

let assign_colors () =
	let args_env = M.fold (fun x y env -> M.add (get_alias x) y env) !args_env M.empty in

	while !select_stack <> [] do
		let n = pop select_stack in
		if not (Asm.is_reg n) then begin
			let v = "t.17314" in
			let v_len = String.length v in
			let t = get_type n in
			let ok_colors = ref (if t = Type.Float then Asm.allfregs else Asm.allregs) in
			S.iter (
				fun w ->
					let alias = get_alias w in
					if S.mem alias (S.union !colored_nodes !precolored) then
						try
							begin
								let target = find alias !color in
								ok_colors := List.filter (fun x -> x <> target) !ok_colors
							end
						with Not_found -> ()
			) (find n !adj_list);

			(if String.length n >= v_len && String.sub n 0 v_len = "t.17314" then
				begin
					Printf.eprintf "(%s) OK_COLORS : " n;
					List.iter (Printf.eprintf "%s, ") !ok_colors;
					Printf.eprintf "\n";
					Printf.eprintf "(%s) DEGREE = %d\n" n (S.length (find n !adj_list));
				end
			);
			
			if !ok_colors = [] then
				spilled_nodes := S.add n !spilled_nodes
			else
				(colored_nodes := S.add n !colored_nodes;
				let c = 
					if M.mem n args_env && List.mem (find n args_env) !ok_colors then 
						(let reg = find n args_env in
(*						Printf.eprintf "BIASED n = %s, reg = %s\n" n reg;*)
						reg)
					else List.hd !ok_colors in (* TODO *)
				Printf.printf "(%s) ALLOCATED %s\n" n c;
				color := M.add n c !color)
		end
	done;
	
	print_string "graph adj_set {\n";
	S.iter (Printf.printf "%s \n") !adj_set;
	print_endline "}";
	
	print_endline "DONE_STACK_ALLOCATION";

	(if S.is_empty !spilled_nodes then
		S.iter (
			fun n ->
				let als = get_alias n in
						Printf.printf "%s : %s\n" n als;
				let c = if Asm.is_reg als then als else find als !color in
				if not (M.mem n !color) then 
					color := M.add n c !color
		(*			else if M.find n !color <> c then (* 彩色済みならいじらない？ *)
					(spilled_nodes := S.add n !spilled_nodes)*)
				else
					begin
						Printf.printf "CONFLICT in Coloring!!\n";
						Printf.printf "%s : %s <=> %s\n\n" n (find n !color) c;
						color := M.add n c !color
					end
		) !coalesced_nodes
	else
		eprint_S "SPILLED NODES : " !spilled_nodes)


let insert_restore stmt blk x t nx =
	(* 命令のID作成 *)
	let id = Block.gen_stmt_id () in
	let new_temp = Id.genid x in
	new_temps := S.add new_temp !new_temps;
	let new_stmt = {
		sId = id;
		sParent = blk.bId;
		sInst = Restore ((new_temp, t), nx);
		sPred = stmt.sPred;
		sSucc = stmt.sId;
		sLivein = S.empty;
		sLiveout = S.empty
	} in
	stmt.sPred <- id;
	(if new_stmt.sPred = "" then (* ブロックの先頭だったら *)
		blk.bHead <- id
	else
		let pred = find new_stmt.sPred blk.bStmts in
		pred.sSucc <- id
	);
	blk.bStmts <- M.add id new_stmt blk.bStmts;
	stmt.sInst <- replace stmt x new_temp;
	(if M.mem stmt.sId !Block.move_list then
		let (u, v) = find stmt.sId !Block.move_list in
		let rep a = if a = x then new_temp else a in
		Block.move_list := M.add stmt.sId (rep u, rep v) !Block.move_list)

let insert_save_arg stmt blk x t nx =
	(* 命令のID作成 *)
	let id = Block.gen_stmt_id () in
	let new_stmt = {
		sId = id;
		sParent = blk.bId;
		sInst = Save (("%dummy", Type.Unit), x, nx);
		sPred = "";
		sSucc = stmt.sId;
		sLivein = S.empty;
		sLiveout = S.empty
	} in
	stmt.sPred <- id;
	(if new_stmt.sPred = "" then (* ブロックの先頭だったら *)
		blk.bHead <- id
	);
	blk.bStmts <- M.add id new_stmt blk.bStmts

(* stmtの後にsave命令を入れる *)
let insert_save stmt blk x t nx =
	(* 命令のID作成 *)
	let id = Block.gen_stmt_id () in
	let new_stmt = {
		sId = id;
		sParent = blk.bId;
		sInst = Save (("%dummy", Type.Unit), x, nx);
		sPred = stmt.sId;
		sSucc = stmt.sSucc;
		sLivein = S.empty;
		sLiveout = S.empty
	} in
	stmt.sSucc <- id;
	(if new_stmt.sSucc = "" then (* ブロックの末尾だったら *)
		blk.bTail <- id
	else
		let succ = find new_stmt.sSucc blk.bStmts in
		succ.sPred <- id
	);
	blk.bStmts <- M.add id new_stmt blk.bStmts

let rewrite_program fundef =
	print_endline "\n[REWRITE]";
	print_S "SPILL : " !spilled_nodes;

	new_temps := !spilled_nodes;
	S.iter (
		fun n ->
			let t = get_type n in
			let use_sites = find n !Liveness.use_sites in
			let nx = Id.genid n in
			List.iter (
				fun (blk_id, stmt_id) ->
					Printf.printf "%s RESTORE %s/%s\n" n blk_id stmt_id;
					let blk = find blk_id fundef.fBlocks in
					let stmt = find stmt_id blk.bStmts in
					insert_restore stmt blk n t nx;
			) use_sites;
			try 
				if List.mem n (fundef.fArgs @ fundef.fFargs) then
					(* 引数なら関数の最初にSave文をいれる *)
					let blk = find fundef.fHead fundef.fBlocks in
					let stmt = find blk.bHead blk.bStmts in
					insert_save_arg stmt blk n t nx
				else
					(* 引数でないなら関数内で定義されているはず *)
					let (blk_id, stmt_id) = find n !Liveness.defenv in
					let blk = find blk_id fundef.fBlocks in
					let stmt = find stmt_id blk.bStmts in
					insert_save stmt blk n t nx
			with Not_found -> assert false
	) !spilled_nodes;
	
	spill_hist := S.union !new_temps !spill_hist;
	
	spilled_nodes := S.empty;
	initial := S.union !colored_nodes (S.union !coalesced_nodes !new_temps);
	colored_nodes := S.diff (S.of_list ("%dummy" :: all_regs @ all_fregs)) !precolored;
	coalesced_nodes := S.empty
(*
let update_color fundef =
	let env = ref M.empty in
	M.iter (
		fun _ blk ->
			M.iter (
				fun _ stmt ->
					match stmt.sInst with
						| VMov ((dst, t), src, name) when (Id.L name) <> fundef.fName ->
							(try 
								let color = find name !colorenv in
								let dst' = find dst color in
								stmt.sInst <- VMov ((dst', t), src, name);
								env := M.add dst dst' !env
							with Not_found -> ())
						| _ -> ()
			) blk.bStmts;
			blk.bLiveout <- S.fold (fun x e -> if M.mem x !env then S.add (find x !env) e else S.add x e) blk.bLiveout S.empty
	) fundef.fBlocks;
	
	let rep a = if M.mem a !env then M.find a !env else a in
	Block.move_list := M.map (fun (x, y) -> (rep x, y)) !Block.move_list
*)
let get_args_env fundef = 
	M.iter (
		fun _ blk ->
			M.iter (
				fun _ stmt ->
					match stmt.sInst with
						| CallDir ((x, _), Id.L name, args, fargs) when (Id.L name) <> fundef.fName ->
							(try 
								let data = find name !Block.tmp_fundata in
								let color = find name !colorenv in
								List.iter2 (
									fun x y ->
										let y = find y color in
										args_env := M.add x y !args_env
								) (args @ fargs) (data.Asm.args @ data.Asm.fargs);
								args_env := M.add x (Asm.get_ret_reg name) !args_env
							with Not_found -> ())
						| _ -> ()
			) blk.bStmts;
	) fundef.fBlocks


let rec main init_flg fundef = 
	Block.print_fundef 3 fundef;

	let name = ((fun (Id.L x) -> x) fundef.fName) in
	Format.eprintf "<%s>\n" name; flush stderr;
	
	(* 初期化処理 *)
	adj_set := S.empty;
	cur_fun := fundef;
	def_vars := S.empty;
	varenv := get_varenv fundef;

	let t1 = Sys.time () in

	Liveness.liveness_analysis fundef !varenv;

	Format.eprintf "Liveness : %f 秒 <%s>\n" (Sys.time () -. t1) name;
			
	let t1 = Sys.time () in
	color := S.fold (fun x env -> M.add x x env) !precolored M.empty;
	adj_list := M.fold (fun x _ env -> M.add x S.empty env) !varenv M.empty;
	degree := M.fold (fun x _ env -> M.add x 0 env) !varenv M.empty;
	move_list := M.fold (fun x _ env -> M.add x S.empty env) !varenv M.empty;
	alias := M.empty;

	(* 複数の引数に同じレジスタが割り当てられないように、引数間での完全グラフを作っておく *)
	List.iter (
		fun x ->
			List.iter (
				fun y -> add_edge x y
			) fundef.fArgs
	) fundef.fArgs;
	List.iter (
		fun x ->
			List.iter (
				fun y -> add_edge x y
			) fundef.fFargs
	) fundef.fFargs;

	if init_flg then begin
		spill_hist := S.empty;
	
		(* allregs系にするか、%g0 - %g31とするか *)
		precolored := S.of_list (Asm.allregs @ Asm.allfregs);
			
		(* varenvのうち、レジスタではなく型がUnitでないものに対して割り当てしていく *)
		initial := 
			M.fold (
				fun x t env -> 
					if S.mem x !precolored || t = Type.Unit then 
						env
					else
						S.add x env
			) !varenv S.empty;
		
		colored_nodes := S.diff (S.of_list ("%dummy" :: all_regs @ all_fregs)) !precolored;
		coalesced_nodes := S.empty
	end;
	Format.eprintf "Initialize : %f 秒 <%s>\n" (Sys.time () -. t1) name;

(*	print_endline "VARENV : ";
	M.iter (fun x y -> if not (Asm.is_reg x) then Printf.printf "%s : %s\n" x (Type.string_of_type y)) !varenv;
	print_newline ();*)

(if name = "ack.346" then
	(print_endline "INITIAL : ";
	print_S "INITIAL : " !initial));

	get_args_env fundef;

	(* ここからタイガーブックと同じ *)
let t1 = Sys.time () in
	build fundef;
Format.eprintf "BUILD : %f 秒 <%s>\n" (Sys.time () -. t1) name;
let t1 = Sys.time () in


(if name = "ack.346" then
	(Printf.printf "%s <%s> ADJ_LIST :\n" (if init_flg then "1回目" else "2回目以降") name;
	M.iter (
		fun x ls ->
			if not (S.is_empty ls) then (
				Printf.printf "\t%s : " x;
				S.iter (Printf.printf "%s ") ls;
				print_newline ()
			)
	) !adj_list;
	print_newline ();
	Block.print_fundef 3 fundef));
	
	make_worklist ();
Format.eprintf "MAKE_WORKLIST : %f 秒 <%s>\n" (Sys.time () -. t1) name;

let t1 = Sys.time () in
	while 
		(* 全部空にまるまで続行 *)
		not (
			S.is_empty !simplify_worklist && 
			S.is_empty !worklist_moves && 
			S.is_empty !freeze_worklist && 
			S.is_empty !spill_worklist
		)
	do
(*		if name = "ack.346" then begin
			print_string "SelectStack : ";
			List.iter (fun x -> if x = "t.17314" then Printf.printf "%s " x) !select_stack;
			print_newline ();
			print_string "Simplify_worklist : ";
			S.iter (fun x -> if x = "t.17314" then Printf.printf "%s " x) !simplify_worklist;
			print_newline ();
(*			print_string "Worklist_moves : ";
			S.iter (Printf.printf "%s ") !worklist_moves;
			print_newline ();*)
			print_string "Freeze_worklist : ";
			S.iter (fun x -> if x = "t.17314" then Printf.printf "%s " x) !freeze_worklist;
			print_newline ();
			print_string "Spill_worklist : ";
			S.iter (fun x -> if x = "t.17314" then Printf.printf "%s " x) !spill_worklist;
			print_newline ();
			print_newline ()
		end;
*)
			print_string "Spill_worklist : ";
			S.iter (Printf.printf "%s ") !spill_worklist;
			print_newline ();

		if not (S.is_empty !simplify_worklist) then simplify ()
		else if not (S.is_empty !worklist_moves) then coalesce ()
		else if not (S.is_empty !freeze_worklist) then freeze ()
		else if not (S.is_empty !spill_worklist) then 
			(
			
			select_spill ()
			
			)
	done;
(*Format.eprintf "PROCESS : %f 秒 <%s>\n" (Sys.time () -. t1) name;*)
		
	print_endline (name ^ " before assign_colors");
let t1 = Sys.time () in
	assign_colors ();
(*Format.eprintf "ASSIGN : %f 秒 <%s>\n" (Sys.time () -. t1) name;*)
	print_endline (name ^ " after assign_colors");

	if not (S.is_empty !spilled_nodes) then
		(
let t1 = Sys.time () in
		rewrite_program fundef;
(*Format.eprintf "REWRITE : %f 秒 <%s>\n" (Sys.time () -. t1) name;*)
		main false fundef)
	else begin
		let name = (fun (Id.L x) -> x) fundef.fName in 
		((if name <> "min_caml_start" then
			begin
	   			let data = find name !Asm.fundata in
	   			let args = List.map (fun x -> try find x !color with Not_found -> "%g0") (fundef.fArgs @ fundef.fFargs) in
	   			let data = {data with Asm.arg_regs = args} in
	   			let def_regs = S.fold (fun x env -> if M.mem x !color then S.add (find x !color) env else (Printf.printf "Not Contain %s\n" x; env)) !def_vars S.empty in
	   			let data = {data with Asm.use_regs = def_regs} in
	   			Asm.fundata := M.add name data !Asm.fundata;
	   		end
		);
		colorenv := M.add name !color !colorenv)
	end;

	print_string "COLOR : \n";
	M.iter (fun x y -> if x <> y then Printf.printf "\t%s => %s\n" x y) !color


let rec f (Block.Prog (data, fundefs, main_fun) as prog) =
(*	Block.print_prog 0 prog;*)
	List.iter (
		fun fundef ->
			let name = (fun (Id.L a) -> a) fundef.fName in
(*			update_color fundef;*)
			main true fundef;
	) (fundefs @ [main_fun]);	
(*	print_prog 0 prog;*)
	prog

