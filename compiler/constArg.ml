(* 読め *)

open KNormal

type arg_state =
	| Wait			(* まだ適用されていない *)
	| Const of t		(* 関数適用されるとき、特定の値しか入っていない *)
	| Many			(* 関数適用されるとき、少なくとも2種類以上の値が入りうる *)
	| None			(* 関数内で使われていない *)

let constArgs = ref M.empty

let mem x env =
	try
		(match M.find x env with
			| Int(_) | Float(_) | ExtArray(_) -> true
			| _ -> false)
	with Not_found -> false

(* Appのところで再帰呼び出しをする際の縛りをS.mm y (fv e1)よりも厳しくしている *)
let rec checkArgs func i a = function
	| IfEq(x, y, e1, e2) | IfLE(x, y, e1, e2) ->
		let x = pp_id_or_imm x in
		let y = pp_id_or_imm y in
		x = a || y = a || (checkArgs func i a e1) || (checkArgs func i a e2)
	| Let(_, e1, e2) ->
		(checkArgs func i a e1) || (checkArgs func i a e2)
	| App(x, ys) when x = func ->
		let (_, b) = List.fold_left (fun (j, b) y -> j + 1, b || (i <> j && y = a)) (0, false) ys in
		b
	| LetTuple(_, y, e) ->
		y = a || (checkArgs func i a e)
	| e -> S.mem a (fv e) (*false*)

(* 各関数の引数の情報を得る（定数か・使用されているかなど） *)
let rec setConstArgs env = function
	| IfEq(_, _, e1, e2) | IfLE(_, _, e1, e2) ->
		(setConstArgs env e1;
		setConstArgs env e2)
	| Let((x, t), e1, e2) ->
		(setConstArgs env e1;
		setConstArgs (M.add x e1 env) e2)
	| LetRec({name = (x, _); args = ys; body = e1}, e2) ->
		let zs = fv e1 in
		let (_, args) = List.fold_left
							(fun (i, args) (y, _) ->
								(*  *)
								(* 1. yがe1に現れない＝e1の自由変数の集合にyが含まれない *)
								(* 2.  *)
								(i + 1, if S.mem y zs && checkArgs x i y e1 then args @ [Wait] else args @ [None]))
								(0, []) ys in
		(constArgs := M.add x args !constArgs;
		setConstArgs env e1;
		setConstArgs env e2)
	| App(x, ys) ->
		(* 各引数の状態は、適用されるごとに適宜 Wait -> Const -> Manyと遷移する *)
		if (try (match M.find x !constArgs with _ -> true) with Not_found -> false) then
			let zs = M.find x !constArgs in
			let zs = List.map2
						(fun y -> function
							| None -> None
							| Wait when mem y env -> Const(M.find y env)
							| Const(v) as c when mem y env && v = M.find y env -> c
							| _ -> Many
						) ys zs in
			constArgs := M.add x zs !constArgs
		else
			()
	| LetTuple(_, _, e) ->
		setConstArgs env e
	| _ -> ()

let member x env =
	try (match M.find x env with _ -> true)
	with Not_found -> false

let rec g = function
	| IfEq(x, y, e1, e2) -> IfEq(x, y, g e1, g e2)
	| IfLE(x, y, e1, e2) -> IfLE(x, y, g e1, g e2)
	| Let((x, t), e1, e2) -> Let((x, t), g e1, g e2)
	(* 引数が定数または使用されてなければ関数定義から除去する *)
	| LetRec({name = (x, Type.Fun(ts, t)); args = ys; body = e1}, e2)  when member x !constArgs ->
		let (ys', e1') = List.fold_right2
			(fun y z (ys, e) ->
				match z with
					| Const(v) -> ys, Let(y, v, e)
					| None -> ys, e
					| _ -> y :: ys, e)
			ys (M.find x !constArgs) ([], e1) in
		LetRec({name = (x, Type.Fun (List.map snd ys', t)); args = ys'; body = g e1'}, g e2)
	(* 引数が定数または使用されてないものであれば関数適用から除去する *)
	| App(x, ys) when member x !constArgs ->
		App(x, List.fold_right2 (fun y z ys -> match z with Const _ | None -> ys | _ -> y :: ys) ys (M.find x !constArgs) [])
	| LetTuple(xts, y, e) -> LetTuple(xts, y, g e)
	| e -> e

let f flg e =
	constArgs := M.empty;
	setConstArgs M.empty e;
	let ans = g e in
	if flg then begin
		print_endline "Print KNormal_T (constArg.ml)";
		KNormal.print 1 ans;
		print_newline ()
	end;
	ans
