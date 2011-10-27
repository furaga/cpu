type id_or_imm = V of Id.t | C of int
(*type id_or_imm' = V' of Id.t | C' of Id.t * int*)
type t =
	| Ans of exp
	| Let of (Id.t * Type.t) * exp * t
	| Forget of Id.t * t
and exp =
	| Nop
	| Set of int
	| SetL of Id.l
	| Mov of Id.t
	| Neg of Id.t
	| Add of Id.t * id_or_imm
	| Sub of Id.t * id_or_imm
	| Mul of Id.t * id_or_imm
	| Div of Id.t * id_or_imm
	| SLL of Id.t * id_or_imm
	| Ld of Id.t * id_or_imm
	| St of Id.t * Id.t * id_or_imm
	| FMovD of Id.t
	| FNegD of Id.t
	| FAddD of Id.t * Id.t
	| FSubD of Id.t * Id.t
	| FMulD of Id.t * Id.t
	| FDivD of Id.t * Id.t
	| LdDF of Id.t * id_or_imm
	| StDF of Id.t * Id.t * id_or_imm
	| Comment of string
	(* virtual instructions *)
	| IfEq of Id.t * id_or_imm * t * t
	| IfLE of Id.t * id_or_imm * t * t
	| IfGE of Id.t * id_or_imm * t * t
	| IfFEq of Id.t * Id.t * t * t
	| IfFLE of Id.t * Id.t * t * t
	(* closure address, integer arguments, and float arguments *)
	| CallCls of Id.t * Id.t list * Id.t list
	| CallDir of Id.l * Id.t list * Id.t list
	| Save of Id.t * Id.t (* レジスタ変数の値をスタック変数へ保存 *)
	| Restore of Id.t (* スタック変数から値を復元 *)
type fundef = { name : Id.l; args : Id.t list; fargs : Id.t list; body : t; ret : Type.t }
type prog = Prog of (Id.l * float) list * fundef list * t

(*
	args_regs :引数として使用するレジスタ
	ret_regs : 戻り値が入っているレジスタ
	use_regs : 関数内で使用する（内容を書き換えうる）レジスタ
	need_ra :  リンクレジスタを使用するか（末尾再帰とかなら使用しない？）
*)
type fundata = {arg_regs : Id.t list; ret_reg : Id.t; use_regs : S.t}

val fundata : fundata M.t ref

val get_arg_regs : Id.t -> Id.t list
val get_ret_reg : Id.t -> Id.t
val get_use_regs : Id.t -> S.t
 
val fletd : Id.t * exp * t -> t (* shorthand of Let for float *)
val seq : exp * t -> t (* shorthand of Let for unit *)

val regs : Id.t array
val fregs : Id.t array
val allregs : Id.t list
val allfregs : Id.t list

val reg_0 : Id.t	(* 常に０ *)
val reg_p1 : Id.t	(* 常に１ *)
val reg_m1 : Id.t	(* 常に-１ *)

val reg_cl : Id.t
val reg_sw : Id.t
val reg_fsw : Id.t
val reg_ra : Id.t
val reg_hp : Id.t
val reg_sp : Id.t
val reg_fgs : Id.t list
val is_reg : Id.t -> bool
(*val co_freg : Id.t -> Id.t*)

val fv : t -> Id.t list
val concat : t -> Id.t * Type.t -> t -> t

val align : int -> int

val print : int -> t -> unit
val print_fundef : int -> fundef -> unit
val print_prog : int -> prog -> unit
