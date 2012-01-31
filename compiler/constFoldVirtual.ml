open Asm

let memi x env =
  try (match M.find x env with Set _ -> true | _ -> false)
  with Not_found -> false

let findi x env = (match M.find x env with Set (i) -> i | _ -> raise Not_found)

let rec g env = function (* 命令列の13bit即値最適化 (caml2html: simm13_g) *)
	| Ans(exp) -> Ans(g' env exp)
	| Let((x, t), exp, e) -> 
		let e1' = g' env exp in
		let e2' = g (M.add x e1' env) e in
		Let((x, t), e1', e2')
	| Forget _ -> assert false
and g' env = function (* 各命令の13bit即値最適化 (caml2html: simm13_gprime) *)
	(* Add *)
	| Add(x, C y) when memi x env -> Set (findi x env + y) 
	| Add(x, V y) when memi x env && memi y env -> Set (findi x env + findi y env) 
	| Add(x, V y) when memi x env && findi x env = 0 -> Mov (y) (* 片方が０だったらそれを消す *)
	| Add(x, V y) when memi y env && findi y env = 0 -> Mov (x) (* 片方が０だったらそれを消す *)
	(* Sub *)
	| Sub(x, C y) when memi x env -> Set (findi x env - y) 
	| Sub(x, V y) when memi x env && memi y env -> Set (findi x env - findi y env)
	| Sub(x, V y) when memi x env && findi x env = 0 -> Mov (y) (* 片方が０だったらそれを消す *)
	| Sub(x, V y) when memi y env && findi y env = 0 -> Mov (x) (* 片方が０だったらそれを消す *)
	(* Mul *)
	| Mul(x, C y) when memi x env -> Set (findi x env * y) 
	| Mul(x, C 0) -> Set 0 
	| Mul(x, C 1) -> Mov x
	| Mul(x, C (-1)) -> Neg x
	| Mul(x, C 2) -> Add (x, V x)
	| Mul(x, V y) when memi x env && memi y env -> Set (findi x env * findi y env)
	| Mul(x, V y) when memi x env && findi x env = 0 -> Set (0) (* 片方が0だったら *)
	| Mul(x, V y) when memi y env && findi y env = 0 -> Set (0) (* 片方が0だったら *)
	| Mul(x, V y) when memi x env && findi x env = 1 -> Mov (y) (* 片方が1だったら *)
	| Mul(x, V y) when memi y env && findi y env = 1 -> Mov (x) (* 片方が1だったら *)
	| Mul(x, V y) when memi x env && findi x env = -1 -> Neg (y) (* 片方が-1だったら *)
	| Mul(x, V y) when memi y env && findi y env = -1 -> Neg (x) (* 片方が-1だったら *)
	| Mul(x, V y) when memi x env && findi x env = 2 -> Add (y, V y) (* X * 2 = X + X *)
	| Mul(x, V y) when memi y env && findi y env = 2 -> Add (x, V x) (* X * 2 = X + X *)
	(* Div *)
	| Div(x, C y) when memi x env -> Set (findi x env / y) 
	| Div(x, V y) when memi x env && memi y env -> Set (findi x env / findi y env)
	| Div(x, V y) when memi x env && findi x env = 0 -> Set (0) (* 左が1だったら *)
	| Div(x, V y) when memi y env && findi y env = 1 -> Mov (x) (* 右が1だったら *)
	| Div(x, V y) when memi y env && findi y env = -1 -> Neg (x) (* 右が-1だったら *)
	(* SLL *)
	| SLL(x, C y) when memi x env && y >= 0 -> Set (findi x env lsl y)
	| SLL(x, C y) when memi x env -> Set (findi x env asr (-y))
	| SLL(x, V y) when memi x env && memi y env && findi y env >= 0 -> Set (findi x env lsl findi y env) 
	| SLL(x, V y) when memi x env && memi y env -> Set (findi x env asr findi y env)
	| SLL(x, V y) when memi x env && findi x env = 0 -> Mov (y) (* 片方が０だったらそれを消す *)
	| SLL(x, V y) when memi y env && findi y env = 0 -> Mov (x) (* 片方が０だったらそれを消す *)
	(* Ld, St, LdDF, StDF *)
	| Ld (x, V y) when memi y env -> Ld(x, C (findi y env))
	| Ld (x, V y) when memi x env -> Ld(y, C (findi x env))
	| St (x, y, V z) when memi z env -> St(x, y, C (findi z env))
	| St (x, y, V z) when memi y env -> St(x, z, C (findi y env))
	| LdDF (x, V y) when memi y env -> LdDF(x, C (findi y env))
	| LdDF (x, V y) when memi x env -> LdDF(y, C (findi x env))
	| StDF (x, y, V z) when memi z env -> StDF(x, y, C (findi z env))
	| StDF (x, y, V z) when memi y env -> StDF(x, z, C (findi y env))
	(* IfEq *)
	| IfEq(x, y, e1, e2) -> IfEq(x, y, g env e1, g env e2)
	(* IfLE *)
	| IfLE(x, y, e1, e2) -> IfLE(x, y, g env e1, g env e2)
	(* IfGE *)
	| IfGE(x, y, e1, e2) -> IfGE(x, y, g env e1, g env e2)
	(* IfFEq *)
	| IfFEq(x, y, e1, e2) -> IfFEq(x, y, g env e1, g env e2)
	(* IfFLE *)
	| IfFLE(x, y, e1, e2) -> IfFLE(x, y, g env e1, g env e2)
	| e -> e

let h { name = l; args = xs; fargs = ys; body = e; ret = t } = (* トップレベル関数の13bit即値最適化 *)
  { name = l; args = xs; fargs = ys; body = g M.empty e; ret = t }

let f (Prog(data, fundefs, e)) = (* プログラム全体の13bit即値最適化 *)
  let ans = Prog(data, List.map h fundefs, g M.empty e) in
(*  Asm.print_prog 3 ans;*)
  ans
