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

val move_list : (Id.t * Id.t) M.t ref

val make_fundef : Asm.fundef -> fundef
val f : Asm.prog -> prog
val print_fundef : int -> fundef -> unit
val print_prog : int -> prog -> unit

val gen_stmt_id : unit -> Id.t
val gen_block_id : unit -> Id.t
val replace : stmt -> Id.t -> Id.t -> t

val tmp_fundata : Asm.fundef M.t ref
