open Asm

type t =
	| VMov of (Id.t * Type.t) * Id.t * Id.t	(* 仮想的なMov命令。関数呼び出しの前に並べる。最後は直後に呼び出す関数 *)
	| Nop of (Id.t * Type.t)
	| Set of (Id.t * Type.t) * int
	| SetL of (Id.t * Type.t) * Id.l
	| Mov of (Id.t * Type.t) * Id.t
	| Neg of (Id.t * Type.t) * Id.t
	| Add of (Id.t * Type.t) * Id.t * Asm.id_or_imm
	| Sub of (Id.t * Type.t) * Id.t * Asm.id_or_imm
	| Mul of (Id.t * Type.t) * Id.t * Asm.id_or_imm
	| Div of (Id.t * Type.t) * Id.t * Asm.id_or_imm
	| SLL of (Id.t * Type.t) * Id.t * Asm.id_or_imm
	| Ld of (Id.t * Type.t) * Id.t * Asm.id_or_imm
	| St of (Id.t * Type.t) * Id.t * Id.t * Asm.id_or_imm
	| FMov of (Id.t * Type.t) * Id.t
	| FNeg of (Id.t * Type.t) * Id.t
	| FAdd of (Id.t * Type.t) * Id.t * Id.t
	| FSub of (Id.t * Type.t) * Id.t * Id.t
	| FMul of (Id.t * Type.t) * Id.t * Id.t
	| FDiv of (Id.t * Type.t) * Id.t * Id.t
	| LdF of (Id.t * Type.t) * Id.t * Asm.id_or_imm
	| StF of (Id.t * Type.t) * Id.t * Id.t * Asm.id_or_imm
	| IfEq of (Id.t * Type.t) * Id.t * Asm.id_or_imm * Id.t * Id.t	(* ラスト２つの引数は基本ブロックのthen節・else節のID *)
	| IfLE of (Id.t * Type.t) * Id.t * Asm.id_or_imm * Id.t * Id.t
	| IfGE of (Id.t * Type.t) * Id.t * Asm.id_or_imm * Id.t * Id.t
	| IfFEq of (Id.t * Type.t) * Id.t * Id.t * Id.t * Id.t
	| IfFLE of (Id.t * Type.t) * Id.t * Id.t * Id.t * Id.t
	| CallCls of (Id.t * Type.t) * Id.t * Id.t list * Id.t list
	| CallDir of (Id.t * Type.t) * Id.l * Id.t list * Id.t list
	| Save of (Id.t * Type.t) * Id.t * Id.t (* レジスタ変数の値をスタック変数へ保存 *)
	| Restore of (Id.t * Type.t) * Id.t (* スタック変数から値を復元 *)

(* 命令 *)
type stmt = {
	mutable sId : Id.t;					(* ID *)
	mutable sParent : Id.t;				(* 所属する基本ブロックのID *)
	mutable sInst : t;						(* 命令内容（Block.t） *)
	mutable sPred : Id.t;			(* 先行命令のID *)
	mutable sSucc : Id.t;			(* 後続命令のID *)
	mutable sLivein : S.t;			(* 入口生存の変数名 *)
	mutable sLiveout : S.t;			(* 出口生存の変数名 *)
}

(* 基本ブロック *)
and block = {
	mutable bId : Id.t;
	mutable bParent : Id.l;				(* 所属する関数のID *)
	mutable bStmts : stmt M.t;				(* ブロックに含まれる命令のID *)
	mutable bHead : Id.t;					(* ブロックの最初の式	 *)
	mutable bTail : Id.t;					(* ブロックの最後の式	 *)
	mutable bPreds : Id.t list;			(* 先行ブロックのID *)
	mutable bSuccs : Id.t list;			(* 後続ブロックのID *)
	mutable bLivein : S.t;			(* 入口生存の変数名 *)
	mutable bLiveout : S.t;			(* 出口生存の変数名 *)
}

(* 関数 *)
and fundef = {
	mutable fName : Id.l;					(* 関数名 *)
	mutable fArgs : Id.t list;				(* 整数引数 *)
	mutable fFargs : Id.t list;				(* 浮動小数引数 *)
	mutable fRet : Type.t;					(* 返り値 *)
	mutable fBlocks : block M.t;			(* 関数に含まれるブロックのID *)
	mutable fHead : Id.t;
	mutable fDef_regs : Id.t list;			(* 関数内で殺される(呼び出す前に退避すべき)レジスタ *)
}


(* プログラム全体 *)
type prog = Prog of (Id.l * float) list * fundef list * fundef

let move_list = ref M.empty
let tmp_fundata = ref M.empty

(* 置換 *)
let replace stmt x y =
	let rep a = if a = x then y else a in
	let rep2 (a, t) = (rep a, t) in
	match stmt.sInst with
		| VMov (xt, x, name) -> VMov (rep2 xt, rep x, name)
		| Nop xt -> Nop (rep2 xt)
		| Set (xt, x) -> Set (rep2 xt, x)
		| SetL (xt, Id.L x) -> SetL (rep2 xt, Id.L x)
		| Mov (xt, x) -> Mov (rep2 xt, rep x)
		| Neg (xt, x) -> Neg (rep2 xt, rep x)
		| Add (xt, x, V y) -> Add (rep2 xt, rep x, V (rep y))
		| Sub (xt, x, V y) -> Sub (rep2 xt, rep x, V (rep y))
		| Mul (xt, x, V y) -> Mul (rep2 xt, rep x, V (rep y))
		| Div (xt, x, V y) -> Div (rep2 xt, rep x, V (rep y))
		| SLL (xt, x, V y) -> SLL (rep2 xt, rep x, V (rep y))
		| Add (xt, x, C y) -> Add (rep2 xt, rep x, C y)
		| Sub (xt, x, C y) -> Sub (rep2 xt, rep x, C y)
		| Mul (xt, x, C y) -> Mul (rep2 xt, rep x, C y)
		| Div (xt, x, C y) -> Div (rep2 xt, rep x, C y)
		| SLL (xt, x, C y) -> SLL (rep2 xt, rep x, C y)
		| Ld (xt, x, V y) -> Ld (rep2 xt, rep x, V (rep y))
		| St (xt, x, y, V z) -> St (rep2 xt, rep x, rep y, V (rep z))
		| Ld (xt, x, C y) -> Ld (rep2 xt, rep x, C y)
		| St (xt, x, y, C z) -> St (rep2 xt, rep x, rep y, C z)
		| FMov (xt, x) -> FMov (rep2 xt, rep x)
		| FNeg (xt, x) -> FNeg (rep2 xt, rep x)
		| FAdd (xt, x, y) -> FAdd (rep2 xt, rep x, rep y)
		| FSub (xt, x, y) -> FSub (rep2 xt, rep x, rep y)
		| FMul (xt, x, y) -> FMul (rep2 xt, rep x, rep y)
		| FDiv (xt, x, y) -> FDiv (rep2 xt, rep x, rep y)
		| LdF (xt, x, V y) -> LdF (rep2 xt, rep x, V (rep y))
		| StF (xt, x, y, V z) -> StF (rep2 xt, rep x, rep y, V (rep z))
		| LdF (xt, x, C y) -> LdF (rep2 xt, rep x, C y)
		| StF (xt, x, y, C z) -> StF (rep2 xt, rep x, rep y, C z)
		| IfEq (xt, x, V y, b1, b2) -> IfEq (rep2 xt, rep x, V (rep y), b1, b2)
		| IfLE (xt, x, V y, b1, b2) -> IfLE (rep2 xt, rep x, V (rep y), b1, b2)
		| IfGE (xt, x, V y, b1, b2) -> IfGE (rep2 xt, rep x, V (rep y), b1, b2)
		| IfEq (xt, x, C y, b1, b2) -> IfEq (rep2 xt, rep x, C y, b1, b2)
		| IfLE (xt, x, C y, b1, b2) -> IfLE (rep2 xt, rep x, C y, b1, b2)
		| IfGE (xt, x, C y, b1, b2) -> IfGE (rep2 xt, rep x, C y, b1, b2)
		| IfFEq (xt, x, y, b1, b2) -> IfFEq (rep2 xt, rep x, rep y, b1, b2)
		| IfFLE (xt, x, y, b1, b2) -> IfFLE (rep2 xt, rep x, rep y, b1, b2)
		| CallCls (xt, name, args, fargs) -> assert false (* クロージャが作られるときはregAlloc.mlでレジスタ割り当てが行われる *)
		| CallDir (xt, Id.L name, args, fargs) ->
			CallDir (rep2 xt, Id.L name, List.map rep args, List.map rep fargs)
		| Save (xt, x, y) ->
			Save (rep2 xt, rep x, y)
		| Restore (xt, x) ->
			Restore (rep2 xt, x)
(************************)
(***** Print系関数群 *****)
(************************)
let print_xt (x, t) = Printf.printf "%s:%s" x (Type.string_of_type t)
let rec print indent f = function
	| VMov (xt, x, name) -> Global.indent indent; print_xt xt; Printf.printf " = VMov %s (%s)" x name
	| Nop xt -> Global.indent indent; print_xt xt; print_endline " = Nop"
	| Set (xt, x) -> Global.indent indent; print_xt xt; Printf.printf " = Set %d" x
	| SetL (xt, Id.L x) -> Global.indent indent; print_xt xt; Printf.printf " = SetL %s" x
	| Mov (xt, x) -> Global.indent indent; print_xt xt; Printf.printf " = Mov %s" x
	| Neg (xt, x) -> Global.indent indent; print_xt xt; Printf.printf " = Neg %s" x
	| Add (xt, x, y') -> Global.indent indent; print_xt xt; Printf.printf " = Add %s %s" x (pp_id_or_imm y')
	| Sub (xt, x, y') -> Global.indent indent; print_xt xt; Printf.printf " = Sub %s %s" x (pp_id_or_imm y')
	| Mul (xt, x, y') -> Global.indent indent; print_xt xt; Printf.printf " = Mul %s %s" x (pp_id_or_imm y')
	| Div (xt, x, y') -> Global.indent indent; print_xt xt; Printf.printf " = Div %s %s" x (pp_id_or_imm y')
	| SLL (xt, x, y') -> Global.indent indent; print_xt xt; Printf.printf " = SLL %s %s" x (pp_id_or_imm y')
	| Ld (xt, x, y') -> Global.indent indent; print_xt xt; Printf.printf " = Ld %s %s" x (pp_id_or_imm y')
	| St (xt, x, y, z') -> Global.indent indent; print_xt xt; Printf.printf " = St %s %s %s" x y (pp_id_or_imm z') 
	| FMov (xt, x) -> Global.indent indent; print_xt xt; Printf.printf " = FMov %s" x
	| FNeg (xt, x) -> Global.indent indent; print_xt xt; Printf.printf " = FNeg %s" x
	| FAdd (xt, x, y) -> Global.indent indent; print_xt xt; Printf.printf " = FAdd %s %s" x y
	| FSub (xt, x, y) -> Global.indent indent; print_xt xt; Printf.printf " = FSub %s %s" x y
	| FMul (xt, x, y) -> Global.indent indent; print_xt xt; Printf.printf " = FMul %s %s" x y
	| FDiv (xt, x, y) -> Global.indent indent; print_xt xt; Printf.printf " = FDiv %s %s" x y
	| LdF (xt, x, y') -> Global.indent indent; print_xt xt; Printf.printf " = LdF %s %s" x (pp_id_or_imm y')
	| StF (xt, x, y, z') -> Global.indent indent; print_xt xt; Printf.printf " = StF %s %s %s" x y (pp_id_or_imm z')
	| IfEq (xt, x, y', b1, b2) -> 
		Global.indent indent; print_xt xt; Printf.printf " = IfEq %s %s %s %s" x (pp_id_or_imm y') b1 b2;
	| IfLE (xt, x, y', b1, b2) -> 
		Global.indent indent; print_xt xt; Printf.printf " = IfLE %s %s %s %s" x (pp_id_or_imm y') b1 b2;
	| IfGE (xt, x, y', b1, b2) -> 
		Global.indent indent; print_xt xt; Printf.printf " = IfGE %s %s %s %s" x (pp_id_or_imm y') b1 b2;
	| IfFEq (xt, x, y, b1, b2) -> 
		Global.indent indent; print_xt xt; Printf.printf " = IfFEq %s %s %s %s" x y b1 b2;
	| IfFLE (xt, x, y, b1, b2) ->
		Global.indent indent; print_xt xt; Printf.printf " = IfFLE %s %s %s %s" x y b1 b2;
	| CallCls (xt, name, args, fargs) -> assert false
	| CallDir (xt, Id.L name, args, fargs) ->
		Global.indent indent; print_xt xt;
		Printf.printf " = CallDir(<%s>, " name;
		List.iter (Printf.printf "%s ") args;
		List.iter (Printf.printf "%s ") fargs;
		print_string ")"
	| Save (xt, x, y) -> Global.indent indent; print_xt xt; Printf.printf " = Save %s %s" x y
	| Restore (xt, x) -> Global.indent indent; print_xt xt; Printf.printf " = Restore %s" x

and print_block indent f {bId = id; bParent = Id.L parent; bStmts = stmts; bHead = head; bTail = tail; bPreds = preds; bSuccs = succs; bLivein = livein; bLiveout = liveout} =
	Global.indent indent; Printf.printf "[%s]\n" id;
	Global.indent indent; Printf.printf "Parent = %s\n" parent;
	Global.indent indent; Printf.printf "(Head, Tail) = (%s, %s)\n" head tail;
	Global.indent indent; Printf.printf "Pred Blocks= "; List.iter (Printf.printf "%s ") preds; print_newline (); 
	Global.indent indent; Printf.printf "Succ Blocks= "; List.iter (Printf.printf "%s ") succs; print_newline (); 
	Global.indent indent; Printf.printf "Live in = "; S.iter (fun v -> Printf.printf "%s " v) livein; print_newline (); 
	Global.indent indent; Printf.printf "Live out = "; S.iter (fun v -> Printf.printf "%s " v) liveout; print_newline ();

	(* print stmts *)
	let rec print_stmts stmt =
(*		Global.indent indent;*)
		print indent f stmt.sInst;
		Printf.printf " : %s\n" stmt.sId;
(*		Global.indent (1 + indent); Printf.printf "sLive in = "; S.iter (fun v -> Printf.printf "%s " v) stmt.sLivein; print_newline (); 
		Global.indent (1 + indent); Printf.printf "sLive out = "; S.iter (fun v -> Printf.printf "%s " v) stmt.sLiveout; print_newline ();*)
		
		if stmt.sSucc <> "" then print_stmts (M.find stmt.sSucc stmts) else () in
	(if M.mem head stmts then print_stmts (M.find head stmts));

	(*	M.iter (fun id stmt -> Printf.printf "%s : " id; print indent f stmt.sInst) stmts;*)
	print_newline ()
	
let print_fundef indent ({fName = Id.L name; fArgs = args; fFargs = fargs; fRet = ret; fBlocks = blocks; fHead = head; fDef_regs = def_regs} as f) = 
	Global.indent indent; Printf.printf "<%s>\n" name;
	Global.indent indent; Printf.printf "Args = "; List.iter (Printf.printf "%s ") args; print_newline (); 
	Global.indent indent; Printf.printf "Fargs = "; List.iter (Printf.printf "%s ") fargs; print_newline (); 
	Global.indent indent; Printf.printf "Return type = %s\n" (Type.string_of_type ret);
	Global.indent indent; Printf.printf "def_regs = "; List.iter (Printf.printf "%s ") def_regs; print_newline (); 
	print_newline ();
	M.iter (fun _ blk -> print_block indent f blk) blocks

let print_prog indent (Prog (data, fundefs, main_fun)) =
	List.iter (fun (Id.L x, y) -> Global.indent indent; Printf.printf "%s = %f\n" x y) data;
	print_newline ();
	List.iter (print_fundef indent) fundefs;
	print_fundef indent main_fun

(************************************)
(***** Asm <-> Block 変換系関数群 *****)
(************************************)
let pred_stmt = ref None
let stmt_cnt = ref (-1)
let block_cnt = ref (-1)
let gen_stmt_id  () = stmt_cnt := !stmt_cnt + 1; Printf.sprintf "stmt.%d" !stmt_cnt
let gen_block_id  () = block_cnt := !block_cnt + 1; Printf.sprintf "block.%d" !block_cnt

(* 基本ブロックblkの末尾ににinstという命令文を追加 *)
let add_stmt inst blk =
	(* 命令のID作成 *)
	let id = gen_stmt_id () in

	(match inst with
		| Mov (xt, y) | FMov (xt, y) | VMov (xt, y, _) -> move_list := M.add id (fst xt, y) !move_list
		(* CallDirもMov命令 *)
(*		| CallDir (xt, Id.L name, args, fargs) -> move_list := M.add id (fst xt, Asm.get_ret_reg name) !move_list*)
		| _ -> ());
	
	let stmt = {
		sId = id;
		sParent = blk.bId;
		sInst = inst;
		sPred = "";
		sSucc = "";
		sLivein = S.empty;
		sLiveout = S.empty
	} in
	(if not (M.is_empty blk.bStmts) then
		match !pred_stmt with
			| None -> assert false
			| Some pred ->
				(pred.sSucc <- stmt.sId;
				stmt.sPred <- pred.sId)
	else (* ブロックの最初の文になるならbHeadに登録 *)
		blk.bHead <- id
	);
	pred_stmt := Some stmt;
	blk.bTail <- id;
	blk.bStmts <- M.add id stmt blk.bStmts

(* 新しく基本ブロックを作成 *)
let make_block blk_id pred succ = {
	bId = blk_id;
	bParent = Id.L "";		(* 所属する関数のID *)
	bStmts = M.empty;		(* ブロックに含まれる命令のID *)
	bHead = "";
	bTail = "";
	bPreds = pred;			(* 先行ブロックのID *)
	bSuccs = succ;			(* 後続ブロックのID *)
	bLivein = S.empty;			(* 入口生存の変数名 *)
	bLiveout = S.empty;			(* 出口生存の変数名 *)
}

(* 基本ブロックblkを関数fに追加 *)
let add_block blk f = 
	List.iter
		(fun blk_id ->
			let pred = M.find blk_id f.fBlocks in
			pred.bSuccs <- blk.bId :: pred.bSuccs) blk.bPreds;
	blk.bParent <- f.fName;
	f.fBlocks <- M.add blk.bId blk f.fBlocks

let rec g (f : fundef) (blk : block) dest = function
	| Asm.Forget(id, t) -> assert false	(* こんなん作らん *)
	| Asm.Ans exp ->
		let res_blk = g' f blk dest exp in
		add_block res_blk f;
		res_blk
	| Asm.Let((x, t) as xt, exp, e) ->
		let res_blk = g' f blk xt exp in
		g f res_blk dest e
and g' (f : fundef) (blk : block) xt = function
	| Asm.Nop -> add_stmt (Nop xt) blk; blk
	| Asm.Set x -> add_stmt (Set (xt, x)) blk; blk
	| Asm.SetL x -> add_stmt (SetL (xt, x)) blk; blk
	| Asm.Mov x -> add_stmt (Mov (xt, x)) blk; blk
	| Asm.Neg x -> add_stmt (Neg (xt, x)) blk; blk
	| Asm.Add (x, y') -> add_stmt (Add (xt, x, y')) blk; blk
	| Asm.Sub (x, y') -> add_stmt (Sub (xt, x, y')) blk; blk
	| Asm.Mul (x, y') -> add_stmt (Mul (xt, x, y')) blk; blk
	| Asm.Div (x, y') -> add_stmt (Div (xt, x, y')) blk; blk
	| Asm.SLL (x, y') -> add_stmt (SLL (xt, x, y')) blk; blk
	| Asm.Ld (x, y') -> add_stmt (Ld  (xt, x, y')) blk; blk
	| Asm.St (x, y, z') -> add_stmt (St (xt, x, y, z')) blk; blk
	| Asm.FMovD x -> add_stmt (FMov (xt, x)) blk; blk
	| Asm.FNegD x -> add_stmt (FNeg (xt, x)) blk; blk
	| Asm.FAddD (x, y) -> add_stmt (FAdd (xt, x, y)) blk; blk
	| Asm.FSubD (x, y) -> add_stmt (FSub (xt, x, y)) blk; blk
	| Asm.FMulD (x, y) -> add_stmt (FMul (xt, x, y)) blk; blk
	| Asm.FDivD (x, y) -> add_stmt (FDiv (xt, x, y)) blk; blk
	| Asm.LdDF (x, y') -> add_stmt (LdF (xt, x, y')) blk; blk
	| Asm.StDF (x, y, z') -> add_stmt (StF (xt, x, y, z')) blk; blk
	| Asm.IfEq (x, y', e1, e2) ->
		(* ブロックを2つに分岐 *)
		let b1 = gen_block_id () in
		let b2 = gen_block_id () in
		let next_blk_id = gen_block_id () in
		add_stmt (IfEq (xt, x, y', b1, b2)) blk;
		add_block blk f;
		let blk1 = make_block b1 [blk.bId] [] in
		let res_blk1 = g f blk1 xt e1 in
		let blk2 = make_block b2 [blk.bId] [] in
		let res_blk2 = g f blk2 xt e2 in
		let next_blk = make_block next_blk_id [res_blk1.bId; res_blk2.bId] [] in
		next_blk
	| Asm.IfLE (x, y', e1, e2) ->
		(* ブロックを2つに分岐 *)
		let b1 = gen_block_id () in
		let b2 = gen_block_id () in
		let next_blk_id = gen_block_id () in
		add_stmt (IfLE (xt, x, y', b1, b2)) blk;
		add_block blk f;
		let blk1 = make_block b1 [blk.bId] [] in
		let res_blk1 = g f blk1 xt e1 in
		let blk2 = make_block b2 [blk.bId] [] in
		let res_blk2 = g f blk2 xt e2 in
		let next_blk = make_block next_blk_id [res_blk1.bId; res_blk2.bId] [] in
		next_blk
	| Asm.IfGE (x, y', e1, e2) ->
		(* ブロックを2つに分岐 *)
		let b1 = gen_block_id () in
		let b2 = gen_block_id () in
		let next_blk_id = gen_block_id () in
		add_stmt (IfGE (xt, x, y', b1, b2)) blk;
		add_block blk f;
		let blk1 = make_block b1 [blk.bId] [] in
		let res_blk1 = g f blk1 xt e1 in
		let blk2 = make_block b2 [blk.bId] [] in
		let res_blk2 = g f blk2 xt e2 in
		let next_blk = make_block next_blk_id [res_blk1.bId; res_blk2.bId] [] in
		next_blk
	| Asm.IfFEq (x, y, e1, e2) ->
		(* ブロックを2つに分岐 *)
		let b1 = gen_block_id () in
		let b2 = gen_block_id () in
		let next_blk_id = gen_block_id () in
		add_stmt (IfFEq (xt, x, y, b1, b2)) blk;
		add_block blk f;
		let blk1 = make_block b1 [blk.bId] [] in
		let res_blk1 = g f blk1 xt e1 in
		let blk2 = make_block b2 [blk.bId] [] in
		let res_blk2 = g f blk2 xt e2 in
		let next_blk = make_block next_blk_id [res_blk1.bId; res_blk2.bId] [] in
		next_blk
	| Asm.IfFLE (x, y, e1, e2) as exp ->
		(* ブロックを2つに分岐 *)
		let b1 = gen_block_id () in
		let b2 = gen_block_id () in
		let next_blk_id = gen_block_id () in
		add_stmt (IfFLE (xt, x, y, b1, b2)) blk;
		add_block blk f;
		let blk1 = make_block b1 [blk.bId] [] in
		let res_blk1 = g f blk1 xt e1 in
		let blk2 = make_block b2 [blk.bId] [] in
		let res_blk2 = g f blk2 xt e2 in
		let next_blk = make_block next_blk_id [res_blk1.bId; res_blk2.bId] [] in
		next_blk
	| Asm.CallCls (x, ys, zs) -> assert false
	| Asm.CallDir (Id.L x, ys, zs) ->
		let name = (fun (Id.L x) -> x) f.fName in
		(try
(*			(let data = M.find x !tmp_fundata in
			let iargs = data.Asm.args in
			let fargs = data.Asm.fargs in
			List.iter2 (fun a b -> add_stmt (VMov ((a, Type.Int), b, x)) blk) iargs ys;
			List.iter2 (fun a b -> add_stmt (VMov ((a, Type.Float), b, x)) blk) fargs zs;*)
			add_stmt (CallDir (xt, Id.L x, ys, zs)) blk(*;
			add_stmt (VMov (xt, Asm.get_ret_reg x, x)) blk; blk)*)
		with Not_found ->
			assert false
			(* tmp_fundataにないってことはcreate_arrayなどのライブラリ関数。これらの引数は彩色済み *)
(*			(try
				(let arg_regs = Asm.get_arg_regs x in
				List.iter2 (fun a b -> add_stmt (VMov ((a, if a.[1] = 'f' then Type.Float else Type.Int), b, x)) blk) arg_regs (ys @ zs);
				add_stmt (CallDir (xt, Id.L x, ys, zs)) blk;
				add_stmt (VMov (xt, Asm.get_ret_reg x, x)) blk; blk)
			with
				Not_found -> assert false
			)*)
		); blk
	| Asm.Save(x, y) -> add_stmt (Save (xt, x, y)) blk; blk
	| Asm.Restore x -> add_stmt (Restore (xt, x)) blk; blk
	| Asm.Comment _ -> blk

let make_fundef {Asm.name = Id.L x; Asm.args = ys; Asm.fargs = zs; Asm.body = e; Asm.ret = t} = 
	let blk = make_block (gen_block_id ()) [] [] in
	let f = {
		fName = Id.L x;
		fArgs = ys;
		fFargs = zs;
		fRet = t;
		fBlocks = M.empty;
		fHead = blk.bId;
		fDef_regs = []
	} in
	let ret_reg = try Asm.get_ret_reg x with Not_found -> "%dummy" in
	g f blk (ret_reg, t) e;
	f

let h fundef =
	let name = (fun (Id.L x) -> x) fundef.Asm.name in
	tmp_fundata := M.add name fundef !tmp_fundata;

	let fundef = make_fundef fundef in
	fundef
	
let f (Asm.Prog(data, fundefs, e) as prog) = 
	move_list := M.empty;
	let ans = Prog (data, List.map h fundefs, h {name = Id.L "min_caml_start"; args = []; fargs = []; body = e; ret = Type.Unit}) in
	print_endline "HELLO";
	ans
	
