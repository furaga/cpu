open Closure

(*
タプル展開。ネストしたタプルがない場合のみ有効

	let t = (a, b, c) in
	let (d, e, f) = t in
	・・・

	->	let d = a in
		let e = b in
		let f = c in
		・・・

	let rec f t =
		let (d, e, f) = t in
		・・・ in
	let t = (a, b, c)
	f t
	
	->	let rec f a b c =
			let t = (a, b, c) in
			let (d, e, f) = t in
			・・・ in
		let t = (a, b, c) in
		let (a', b', c') = t in
		f a' b' c'
	
		->	let rec f a b c =
				let d = a in
				let e = b in
				let f = c in
				・・・ in
			let a' = a in
			let b' = b in
			let c' = c in
			f a' b' c'
*)

let fundata = ref M.empty

let get_arg_types f = try List.map snd (M.find f !fundata).args with Not_found -> (*Printf.eprintf "Not found in TupleExpand.get_arg_types : %s\n" f;*) []

(** ネストしたタプル型か **)
let rec is_nesting_type toplevel typ = 
	match typ with
		| Type.Tuple _ when toplevel = false -> true
		| Type.Tuple ls -> List.exists (is_nesting_type false) ls
		| _ -> false

let rec is_flat_type toplevel typ = 
	match typ with
		| Type.Tuple _ when toplevel = false -> false
		| Type.Tuple ls -> List.for_all (is_flat_type false) ls
		| _ when toplevel = false -> true
		| _ -> false

(** ネストしたタプルが存在するか **)
let rec exist_nesting_tuple = function
	| IfEq (id, v, e1, e2)
	| IfLE (id, v, e1, e2) -> exist_nesting_tuple e1 || exist_nesting_tuple e2
	| Let ((id, typ), e1, e2) ->
		is_nesting_type true typ || exist_nesting_tuple e1 || exist_nesting_tuple e2
	| LetTuple (elems, _, e) ->
		let types = List.map snd elems in
		List.exists (is_nesting_type true) types || exist_nesting_tuple e
	| _ -> false

(** タプルの中身がどうなってるか辿れるか **)
let rec can_get_tuple_elems env x = 
	if M.mem x env then (
		match M.find x env with
			| (Tuple _, _) -> true
			| (Var x, _) -> can_get_tuple_elems env x
			| _ -> false
	)
	else false

(** タプルの中身を返す **)
let rec get_tuple_elems env x = 
	try
		match M.find x env with
			| (Tuple xs, _) -> xs
			| (Var x, _) -> get_tuple_elems env x
			| _ -> raise Not_found
	with Not_found -> Printf.eprintf "Not found in TupleExpand.get_tuple_elems : %s\n" x; assert false


let rec get_alias x env = 
	if M.mem x env then 
		(match M.find x env with
			| (Var y, _) -> get_alias y env 
			| _ -> x)
	else x

(** 関数のはじめにlet dst = src in という文言を追加**)
let add_let dst src e = Let (dst, src, e)

(** 関数のはじめにlet dst = src in という文言を追加**)
let add_let_tuple dsts src e = LetTuple (dsts, src, e)


(** let rec f (a, (b, c)) = ・・・ を let rec f a (b, c) = let t = (a, (b, c)) in ・・・ にする **)
let expand_args fundef =
	let tuple_env = ref [] in
	let new_args = 
		List.fold_left (
			fun env (id, typ) ->
				match typ with
					| Type.Tuple ts ->
						(* タプルを一回分開く *)
						let args = List.fold_left (
							fun args t -> args @ [(Id.gentmp t, t)]
						) [] ts in
						tuple_env := !tuple_env @ [((id, typ), args)];
						env @ args
					| _ -> env @ [(id, typ)]
		) [] fundef.args in
	let new_body = List.fold_left (
		fun env (dst, xs) -> add_let dst (Tuple (List.map fst xs)) env
	) fundef.body !tuple_env in
	{fundef with args = new_args; body = new_body}

(** 関数本体に登場するタプルを展開 **)
(** 関数呼び出しのとき、タプルの中身をばらしてから入れる **)
let rec expand_tuples env = function
	| IfEq (id, v, e1, e2) -> IfEq (id, v, expand_tuples env e1, expand_tuples env e2)
	| IfLE (id, v, e1, e2) -> IfLE (id, v, expand_tuples env e1, expand_tuples env e2)
	| Let ((id, typ), e1, e2) ->
		let e1' = expand_tuples env e1 in
		Let ((id, typ), e1', expand_tuples (M.add id (e1', typ) env) e2)
	| MakeCls _
	| AppCls _ -> assert false
	| AppDir (Id.L f, args) as e ->
		(* f t => let (a, (b, c)) = t in f a (b, c) *)
		let tuple_env = ref [] in
		let arg_types = get_arg_types f in
		(*　引数の型情報が空だったらなにもしない *)
		(*  fが外部関数だったら引数にタプルは存在しないと考えている <= TODO *)
		if List.length arg_types <> List.length args then AppDir (Id.L f, args)
		else (
			let new_args = List.fold_left (
				fun new_args (x, t) ->
					(* 展開 *)
					match t with
						| Type.Tuple ts ->
							let expands = List.fold_left (fun e t -> e @ [(Id.gentmp t, t)]) [] ts in
							tuple_env := (x, expands) :: !tuple_env;
							new_args @ expands
						| _ -> new_args @ [(x, t)]
			) [] (List.combine args arg_types) in
			if List.length args = List.length new_args then
				(* 展開されないならそのまま *)
				e
			else (
				(* 展開されるならlet式を追加してももう一回 *)
				let e' = 
					List.fold_left (
						fun env (src, dsts) -> add_let_tuple dsts src env
					) (AppDir (Id.L f, List.map fst new_args)) !tuple_env in
				expand_tuples env e'
			)
		)
	| LetTuple (dsts, value, e) ->
		if can_get_tuple_elems env value then (
			let srcs = get_tuple_elems env value in
			let (env', e') =
				List.fold_left (
					fun (env', e') (dst, src) -> 
						(M.add (fst dst) (Var src, snd dst) env', add_let dst (Var src) e')
				) (env, e) (List.rev (List.combine dsts srcs)) in
			expand_tuples env' e'
		)
		else 
			let alias = get_alias value env in
			LetTuple (dsts, alias, expand_tuples env e)
	| e -> e

let h fundef =
	Printf.eprintf "TupleExpand.h <%s>\n" (Id.get_name (fst fundef.name));
	fundata := M.add (Id.get_name (fst fundef.name)) fundef !fundata;
	let fundef = expand_args fundef in
	let ans = {fundef with body = expand_tuples M.empty fundef.body} in
	ans

let f (Prog (fundefs, e) as prog) =
	if !Inline.threshold <= 150 || !Closure.exist_cls then prog
	else (
		fundata := M.empty;
		let fundefs = List.map h fundefs in
		let ans = Prog (fundefs, expand_tuples M.empty e) in
(*		Closure.print_prog 0 ans;*)
		ans
	)
