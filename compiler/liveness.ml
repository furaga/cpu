(* 「最新コンパイラ構成技法」p427参照 *)
open Block

let use_sites = ref M.empty	(* 変数の使用場所の集合 *)
let blkenv = ref S.empty	(* 探索済みの基本ブロック *)
let defenv = ref M.empty	(* 関数内で定義される変数とその。引数は含まない。Coloring.rewrite_programで使用 *)

let find x env = try M.find x env with Not_found -> Printf.printf "not found x = [%s]\n" x; assert false

(* 文sに登場する各変数に対して、文s(のID)を使用場所として追加 *)
let add_use_site fundef s env = 
	let find' x env =  if M.mem x env then M.find x env else [] in
	let add x s env =
		let elem = (s.sParent, s.sId) in 
		let use_sites = find' x env in
		let use_sites = elem :: use_sites in
		M.add x use_sites env in
	match s.sInst with
		| Restore _ | Nop _ | Set _ | SetL _  -> env
		| Save (_, x, _) | VMov (_, x, _) | Mov (_, x) | Neg (_, x) | Add (_, x, Asm.C _) | Sub (_, x, Asm.C _) | Mul (_, x, Asm.C _) | Div (_, x, Asm.C _) | SLL (_, x, Asm.C _) 
		| Ld (_, x, Asm.C _) | LdF (_, x, Asm.C _) | IfEq (_, x, Asm.C _, _, _) | IfLE (_, x, Asm.C _, _, _) | IfGE (_, x, Asm.C _, _, _) | FMov (_, x) | FNeg (_, x) ->
			add x s env
		| Add (_, x, Asm.V y) | Sub (_, x, Asm.V y) | Mul (_, x, Asm.V y) | Div (_, x, Asm.V y) | SLL (_, x, Asm.V y) 
		| Ld (_, x, Asm.V y) | LdF (_, x, Asm.V y) | IfEq (_, x, Asm.V y, _, _) | IfLE (_, x, Asm.V y, _, _) | IfGE (_, x, Asm.V y, _, _)
		| St (_, x, y, Asm.C _) -> 
			add y s (add x s env)
		| FAdd (_, x, y) | FSub (_, x, y) | FMul (_, x, y) | FDiv (_, x, y) | IfFEq (_, x, y, _, _) | IfFLE (_, x, y, _, _) | StF (_, x, y, Asm.C _) ->
			add y s (add x s env)
		| St (_, x, y, Asm.V z) | StF (_, x, y, Asm.V z) ->
			add z s (add y s (add x s env))
		| CallCls _ -> assert false
(*		| CallDir (_, Id.L name, args, fargs) when (Id.L name) = fundef.fName -> (* TODO *)
			env*)
		| CallDir (_, Id.L name, args, fargs)  ->
(*			env*)
(*			List.fold_left (fun env x -> add x s env) env (Asm.get_arg_regs name)*)
			List.fold_left (fun env x -> add x s env) env (args @ fargs)

(* 関数fundef内で使用される各変数の使用場所を求める *)
let rec get_use_sites fundef env =
	M.fold (
		fun _ blk env ->
			M.fold (
				fun _ stmt env -> add_use_site fundef stmt env
			) blk.bStmts env
	) fundef.fBlocks env

(* 文sで定義される変数 *)
let rec get_def_vars s (Id.L fname) = 
	let ans = 
		match s.sInst with
			| VMov (_, _, name) (*when name = fname*) -> M.empty
			| Nop xt | Set (xt, _) | SetL (xt, _) (*| VMov (xt, _, _)*) | Mov (xt, _) | Neg (xt, _) | Add (xt, _, _)
			| Sub (xt, _, _) | Mul (xt, _, _) | Div (xt, _, _) | SLL (xt, _, _) | Ld (xt, _, _) | St (xt, _, _, _) | FMov (xt, _) | FNeg (xt, _)
			| FAdd (xt, _, _) | FSub (xt, _, _) | FMul (xt, _, _) | FDiv (xt, _, _) | LdF (xt, _, _) | StF (xt, _, _, _)
			| IfEq (xt, _, _, _, _) | IfLE (xt, _, _, _, _) | IfGE (xt, _, _, _, _) | IfFEq (xt, _, _, _, _) | IfFLE (xt, _, _, _, _)
			| Save (xt, _, _) | Restore (xt, _) ->
				M.add (fst xt) (snd xt) M.empty
			| CallCls _ -> assert false
(*			| CallDir ((x, t), Id.L name, args, fargs) when name = fname -> (* 自己再帰のとき。まだAsm.fundataに登録されていないので無視 *)
				M.add x t M.empty*)
			| CallDir ((x, t), Id.L name, args, fargs) ->	(* TODO? *)
				M.add x t (
(*					S.fold (
						fun x env -> 
							M.add x (
								if List.mem x Asm.allfregs then Type.Float else Type.Int
							) env
				) (Asm.get_use_regs name)*) M.empty) in
	(* defenvに追加 *)
	M.iter (fun x _ -> defenv := M.add x (s.sParent, s.sId) !defenv) ans;
	ans

(* タイガーブックp427の４関数 *)
let rec liveout_at_block n v fundef =
	(* vがブロックnで出口生存である *)
	n.bLiveout <- S.add (fst v) n.bLiveout;
	if not (S.mem n.bId !blkenv) then
		(* 探索済みでないとき *)
		(blkenv := S.add n.bId !blkenv;
		if M.is_empty n.bStmts then (* 空の基本ブロックだったらその前のブロックで出口生存 *)
			List.iter (fun p -> liveout_at_block (find p fundef.fBlocks) v fundef) n.bPreds
		else
			let s = find n.bTail n.bStmts in
			liveout_at_statement s v fundef)

and livein_at_statement s v fundef =
	(* vが文sで入口生存である *)
	s.sLivein <- S.add (fst v) s.sLivein;
	let n = find s.sParent fundef.fBlocks in
	if s.sPred = "" then
		(* sがブロックの最初の文のとき *)
		(* sはブロックnで入口生存である *)
		(n.bLivein <- S.add (fst v) n.bLivein;
		List.iter (fun p -> liveout_at_block (find p fundef.fBlocks) v fundef) n.bPreds)
	else
		let s' = find s.sPred n.bStmts in
		liveout_at_statement s' v fundef

and liveout_at_statement s v fundef =
	(* vが文sで出口生存である *)
	s.sLiveout <- S.add (fst v) s.sLiveout;
	let w = get_def_vars s fundef.fName in
	if not (M.mem (fst v) w) then	
		livein_at_statement s v fundef

(* 生存解析 *)
let rec liveness_analysis fundef type_env =
	(* 初期化 *)
	M.iter (
		fun _ blk ->
			blk.bLivein <- S.empty;
			blk.bLiveout <- S.empty;
			M.iter (
				fun _ stmt ->
					stmt.sLivein <- S.empty;
					stmt.sLiveout <- S.empty
			) blk.bStmts
	) fundef.fBlocks;
	use_sites := get_use_sites fundef M.empty;
	
	let v = "t.23162" in
	if M.mem v !use_sites then (
		Printf.eprintf "(%s) USE_SITES : " v;
		List.iter (fun (b, s) -> Printf.eprintf "(%s, %s) " b s) (find v !use_sites);
		Printf.eprintf "\n";
	);
(*	let cnt = ref 0 in
	let sum = ref 0 in
	M.iter (fun _ _ -> sum := !sum + 1) !use_sites;
*)
	M.iter (
		(* 変数ごとに生存解析 *)
		fun v use_sites ->
			let t = find v type_env in
(*			cnt := !cnt + 1;
			Printf.printf "analisis %s (%d/%d)\n" v !cnt !sum;*)
			blkenv := S.empty;
			(* 変数vが使用されている場所ごとに *)
			List.iter (
				fun (blk_id, stmt_id) ->
(*					Printf.printf "blk %s, stmt %s\n" blk_id stmt_id; flush stdout;*)
					let blk = find blk_id fundef.fBlocks in
					let site = find stmt_id blk.bStmts in
					livein_at_statement site (v, t) fundef
			) use_sites
	) !use_sites

