open Asm

let memi x env = try match M.find x env with Set i -> true | _ -> false with Not_found -> false

let memi_s x env = try match M.find x env with Set i when -128 <= i && i < 127 -> true | _ -> false with Not_found -> false

let meml x env = try match M.find x env with SetL l -> true | _ -> false with Not_found -> false

let memaddi x env = try match M.find x env with Add (y, C i) -> true | _ -> false with Not_found -> false

let memadd x env = try match M.find x env with Add (x, y') -> true | _ -> false with Not_found -> false

let findi x env = match M.find x env with Set i -> i | _ -> raise Not_found
let findl x env = match M.find x env with SetL l -> l | _ -> raise Not_found
let findaddi x env = match M.find x env with Add (y, C i) -> (y, i) | _ -> raise Not_found
let findadd x env = match M.find x env with Add (x, y') -> (x, y') | _ -> raise Not_found

let replace env = function
	| V x when memi x env -> C (findi x env)
	| x' -> x'

let rec g env = function
	| Let ((x, t), exp, e) when (M.mem x env || is_reg x) ->
		Let ((x, t), g' env exp, g env e)
	| Let ((x, t), exp, e) ->	(* xが自由変数やレジスタでないときLet文が消せるときがある *)
		let exp' = g' env exp in
		let e' = g (M.add x exp' env) e in
		let flg = match exp' with St _ | StDF _ | CallDir _ | CallCls _ | IfEq _ | IfLE _ | IfGE _ | IfFEq _ | IfFLE _ -> true | _ -> false in
		if flg || (List.mem x (fv e')) then
			Let ((x, t), exp', e')	(* ラベルを扱う命令のときはコンパイル時に挙動が決まらないのでlet文は消せない *)
		else
			e'
	| e -> e

and g' env = function
	| Mov x when memi x env -> Set (findi x env)
	| Add (x, V y) when memi x env -> Add (y, C (findi x env))
	| Add (x, C y) when memi x env -> Set (findi x env + y)
	| Add (x, C (0)) | Sub (x, C(0)) -> g' env (Mov x)
	| Add (x, y') -> Add (x, replace env y')
	| Sub (x, V y) when memi x env -> Sub (y, C (findi x env))
	| Sub (x, C y) when memi x env -> Set (findi x env - y)
	| Sub (x, y') -> Sub (x, replace env y')
	| Mul (x, V y) when memi x env -> Mul (y, C (findi x env))
	| Mul (x, C y) when memi x env -> Set (findi x env * y)
	| Mul (x, C 1) -> g' env (Mov x)
	| Mul (x, C (-1))  -> g' env (Neg x)
	| Mul (x, C 0) -> Set (0)
	| Mul (x, y') -> Mul (x, replace env y')
	| Div (x, V y) when memi x env -> Div (y, C (findi x env))
	| Div (x, C y) when memi x env -> Set (findi x env / y)
	| Div (x, C 1) -> g' env (Mov x)
	| Div (x, C (-1))  -> g' env (Neg x)
	| Div (x, y') -> Div (x, replace env y')
	| e -> e
	
let h {name = l; args = xs; fargs = fxs; body = e; ret = t} = {name = l; args = xs; fargs = fxs; body = g M.empty e; ret = t}

let f' (Prog (data, fundef, e)) = Prog (data, List.map h fundef, g M.empty e)

let rec f flg e =
	let e' = f' e in
	let ans = if e' = e then e else f flg e' in
	if flg then
		begin
			print_endline "Print Asm_t (ConstFold2.ml)";
			Asm.print_prog 1 ans;
			print_newline ();
			flush stdout;
		end;
	ans


