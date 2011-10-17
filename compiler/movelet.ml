open KNormal
(* let式の位置の最適化（elim.mlを改造） *)
(* A正規化など *)

(* 副作用がないと分かっている関数群 *)
let noeffectfun = S.of_list [
	"fequal"; "fless"; "fispos"; "fisneg"; "fiszero"; 
	"xor"; "not"; 
	"fabs"; "fneg"; 
	"fsqr"; "fhalf"; "floor";
	"float_of_int"; "int_of_float";
	"sin"; "cos"; "atan"; "sqrt"]

(* 副作用があるか *)
let rec effect env = function
	| Let(_, e1, e2) | IfEq(_, _, e1, e2) | IfLE(_, _, e1, e2) -> effect env e1 || effect env e2
	| LetRec({name=(x,_);body=e1}, e2) ->
		if effect_fun x env e1 then effect env e2 else effect (S.add x env) e2
	| LetTuple(_, _, e) -> effect env e
	| App (x,_) -> not (S.mem x env)
	| ExtFunApp (x,_) -> not (S.mem x noeffectfun)
	| Put _  -> true
	| _ -> false
and effect_fun id env exp =
	if effect (S.add id env) exp then
		effect env exp
	else false

(* let x を削除 *)
let rec remove x = function
	| Let ((x',t),e1,e2)  -> if x = x' then e2 else Let ((x',t),remove x e1,remove x e2)
	| IfEq (y,z,e1,e2) -> IfEq (y,z,remove x e1,remove x e2)
	| IfLE (y,z,e1,e2) -> IfLE (y,z,remove x e1,remove x e2)
	| LetRec ({body = e1} as fundef, e2) ->
		LetRec ({fundef with body = remove x e1}, remove x e2)
	| LetTuple (xts, y, e) ->
		if (List.mem x (fst (List.split xts))) then
			e
		else
			LetTuple (xts, y, remove x e)
	| e -> e

(* xのlet式を追加 *)
(* TODO: eにxが含まれないときのみinsert <- ベータ簡約で取り除かれるはずなので必要ない *)
let rec insert env x e =
	try
		let (t, e1) = M.find x env in
		let e1' = Let((x,t), e1, remove x e) in
		S.fold (fun x e -> insert env x e) (fv e1) e1'		(* 各自由変数のlet式をe1'に追加 *)
	with Not_found -> e

(* 定義される変数の集合を返す *)
let rec find = function
	| Let ((x,t),e1,e2)  -> S.add x (S.union (find e1) (find e2))
	| IfEq (_,_,e1,e2) | IfLE (_,_,e1,e2) | LetRec ({body = e1} , e2) -> S.union (find e1) (find e2)
	| LetTuple (_,_, e) -> find e
	| e -> S.empty

let rec g env letenv = function
	| IfEq(x, y, e1, e2) ->
		(* e1', e2'両方で使われている変数だけletを挿入 *)
		let e1' = g env letenv e1 in
		let e2' = g env letenv e2 in
		let xs = S.add x (S.add y (S.inter (find e1') (find e2'))) in
		S.fold (insert letenv) xs (IfEq(x, y, e1', e2'))
	| IfLE(x, y, e1, e2) ->
		(* e1', e2'両方で使われている変数だけletを挿入 *)
		let e1' = g env letenv e1 in
		let e2' = g env letenv e2 in
		let xs = S.add x (S.add y (S.inter (find e1') (find e2'))) in
		S.fold (insert letenv) xs (IfLE(x, y, e1', e2'))
	| Let((x, t), e1, e2) ->
		(* e1'に副作用がなければlet式を削除 *)
		let e1' = (*g env M.empty*)e1 in
		if effect env e1' then
			S.fold (insert letenv) (fv e1') (Let((x,t), e1', g env letenv e2))
		else
			g env (M.add x (t,e1) letenv) e2
	| LetRec({ name = (x, t); args = yts; body = e1 }, e2) ->
		let env' = if effect_fun x env e1 then env	else S.add x env in
		let e1' = g env' M.empty e1 in
		let e2' = g env' letenv e2 in
		let xs = fv e1 in
		if S.mem x (fv e2') then
			let e = LetRec({ name = (x, t); args = yts; body = e1' }, e2') in
				S.fold (insert letenv) xs e
		else
			e2'
	| LetTuple(xts, y, e) ->
		let e' = g env letenv e in
		let live = fv e' in
		let xs = List.map fst xts in
		if List.exists (fun x -> S.mem x live) xs then
			insert letenv y (LetTuple(xts, y, e'))
		else
			S.fold (insert letenv) (fv e') e'
	| e ->
		S.fold (insert letenv) (fv e) e

let f flg e =
	let ans = g S.empty M.empty e in
	if flg then
		begin
			print_endline "Print KNormal_t (Movelet.ml)";
			KNormal.print 1 ans;
			print_newline ()
		end;
	ans
	
