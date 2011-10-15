(* �������� 2011/10/16 0:27 *)
open KNormal

let memi x env =
  try (match M.find x env with Int(_) -> true | _ -> false)
  with Not_found -> false
let memf x env =
  try (match M.find x env with Float(_) -> true | _ -> false)
  with Not_found -> false
let memt x env =
  try (match M.find x env with Tuple(_) -> true | _ -> false)
  with Not_found -> false

let findi x env = (match M.find x env with Int(i) -> i | _ -> raise Not_found)
let findf x env = (match M.find x env with Float(d) -> d | _ -> raise Not_found)
let findt x env = (match M.find x env with Tuple(ys) -> ys | _ -> raise Not_found)

let rec g env = function (* ������߹��ߥ롼�������� (caml2html: constfold_g) *)
	| Var(x) when memi x env -> Int(findi x env)
	(* | Var(x) when memf x env -> Float(findf x env) *)
	(* | Var(x) when memt x env -> Tuple(findt x env) *)
	| Neg(x) when memi x env -> Int(-(findi x env))

	| Add(x, y) when memi x env && memi y env -> Int(findi x env + findi y env) (* ­�����Υ����� (caml2html: constfold_add) *)
	| Add(x, y) when memi x env && M.find x env = Int(0) -> g env (Var (y)) (* �����������ä��餽���ä� *)
	| Add(x, y) when memi y env && M.find y env = Int(0) -> g env (Var (x)) (* �����������ä��餽���ä� *)

	| Sub(x, y) when memi x env && memi y env -> Int(findi x env - findi y env)
	| Sub(x, y) when memi x env && M.find x env = Int(0) -> g env (Var (y)) (* �����������ä��餽���ä� *)
	| Sub(x, y) when memi y env && M.find y env = Int(0) -> g env (Var (x)) (* �����������ä��餽���ä� *)

	| Mul(x, y) when memi x env && memi y env -> Int(findi x env * findi y env)
	| Mul(x, y) when memi x env && M.find x env = Int(1) -> g env (Var (y)) (* ������1���ä��� *)
	| Mul(x, y) when memi y env && M.find y env = Int(1) -> g env (Var (x)) (* ������1���ä��� *)
	| Mul(x, y) when memi x env && M.find x env = Int(-1) -> g env (Neg (y)) (* ������-1���ä��� *)
	| Mul(x, y) when memi y env && M.find y env = Int(-1) -> g env (Neg (x)) (* ������-1���ä��� *)

	| Div(x, y) when memi x env && memi y env -> Int(findi x env / findi y env)
	| Div(x, y) when memi x env && M.find x env = Int(1) -> g env (Var (y)) (* ������1���ä��� *)
	| Div(x, y) when memi y env && M.find y env = Int(1) -> g env (Var (x)) (* ������1���ä��� *)
	| Div(x, y) when memi x env && M.find x env = Int(-1) -> g env (Neg (y)) (* ������-1���ä��� *)
	| Div(x, y) when memi y env && M.find y env = Int(-1) -> g env (Neg (x)) (* ������-1���ä��� *)

	| SLL(x, y) when memi x env && memi y env && findi y env >= 0 -> Int(findi x env lsl findi y env)
	| SLL(x, y) when memi x env && memi y env -> Int(findi x env asr findi y env)
	| SLL(x, y) when memi x env && M.find x env = Int(0) -> Int (0) (* ���������ä��� *)
	| SLL(x, y) when memi y env && M.find y env = Int(0) -> g env (Var (x)) (* ���������ä��� *)

	| FNeg(x) when memf x env -> Float(-.(findf x env))

	| FAdd(x, y) when memf x env && memf y env -> Float(findf x env +. findf y env)
	| FAdd(x, y) when memf x env && M.find x env = Float (0.) -> g env (Var(y))
	| FAdd(x, y) when memf y env && M.find y env = Float (0.) -> g env (Var(x))
	
	| FSub(x, y) when memf x env && memf y env -> Float(findf x env -. findf y env)
	| FSub(x, y) when memf x env && M.find x env = Float (0.) -> g env (Var(y))
	| FSub(x, y) when memf y env && M.find y env = Float (0.) -> g env (Var(x))

	| FMul(x, y) when memf x env && memf y env -> Float(findf x env *. findf y env)
	| FMul(x, y) when memf x env && M.find x env = Float (1.) -> g env (Var (y))
	| FMul(x, y) when memf y env && M.find y env = Float (1.) -> g env (Var (x))
	| FMul(x, y) when memf x env && M.find x env = Float (-1.) -> g env (FNeg (y))
	| FMul(x, y) when memf y env && M.find y env = Float (-1.) -> g env (FNeg (x))
	| FMul(x, y) when memf x env && M.find x env = Float (0.) -> Float (0.)
	| FMul(x, y) when memf y env && M.find y env = Float (0.) -> Float (0.)
	
	| FDiv(x, y) when memf x env && memf y env -> Float(findf x env /. findf y env)
	| FDiv(x, y) when memf y env && M.find y env = Float (1.) -> g env (Var (x))
	| FDiv(x, y) when memf y env && M.find y env = Float (-1.) -> g env (FNeg (x))
	| FDiv(x, y) when memf x env && M.find x env = Float (0.) -> Float (0.)

	| IfEq(x, y, e1, e2) when memi x env && memi y env -> if findi x env = findi y env then g env e1 else g env e2
	| IfEq(x, y, e1, e2) when memf x env && memf y env -> if findf x env = findf y env then g env e1 else g env e2
	| IfEq(x, y, e1, e2) -> IfEq(x, y, g env e1, g env e2)
	| IfLE(x, y, e1, e2) when memi x env && memi y env -> if findi x env <= findi y env then g env e1 else g env e2
	| IfLE(x, y, e1, e2) when memf x env && memf y env -> if findf x env <= findf y env then g env e1 else g env e2
	| IfLE(x, y, e1, e2) -> IfLE(x, y, g env e1, g env e2)
	| Let((x, t), e1, e2) -> (* let�Υ����� (caml2html: constfold_let) *)
		let e1' = g env e1 in
		let e2' = g (M.add x e1' env) e2 in
		Let((x, t), e1', e2')
	| LetRec({ name = x; args = ys; body = e1 }, e2) ->
		LetRec({ name = x; args = ys; body = g env e1 }, g env e2)
	| LetTuple(xts, y, e) when memt y env ->
		List.fold_left2
		(fun e' xt z -> Let(xt, Var(z), e'))
		(g env e)
		xts
		(findt y env)
	| LetTuple(xts, y, e) -> LetTuple(xts, y, g env e)
	| e -> e

let f = g M.empty
