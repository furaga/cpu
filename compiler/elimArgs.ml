(** 関数の出口でliveinでない引数を除去 **)
open Block

let args_env = ref M.empty
let fargs_env = ref M.empty

(* liveinでない引数を削除 *)
let elim_args fundef =
	let name = Id.get_name fundef.fName in
	let blk = Block.find_assert "ElimArgs.elim_args : " fundef.fHead fundef.fBlocks in
	let args = List.map (fun x -> (x, S.mem x blk.bLivein)) fundef.fArgs in
	let fargs = List.map (fun x -> (x, S.mem x blk.bLivein)) fundef.fFargs in
	if List.exists (fun (_, flg) -> flg = false) (args @ fargs) then (
		args_env := M.add name args !args_env;
		fargs_env := M.add name fargs !fargs_env;
		fundef.fArgs <- List.fold_left (fun env (x, flg) -> if flg then env @ [x] else env) [] args;
		fundef.fFargs <- List.fold_left (fun env (x, flg) -> if flg then env @ [x] else env) [] fargs
	)

let elim_body fundef =
	M.iter (
		fun _ blk ->
			M.iter (
				fun _ stmt ->
					match stmt.sInst with
						| CallDir (dst, Id.L name, args, fargs) when M.mem name !args_env ->
							let arg_flgs = List.map snd (Block.find_assert "ElimArgs.elim_body-1 : " name !args_env) in
							let farg_flgs = List.map snd (Block.find_assert "ElimArgs.elim_body-2 : " name !fargs_env) in
							assert (List.length args = List.length arg_flgs);
							assert (List.length fargs = List.length farg_flgs);
							let new_args = List.fold_left (fun env (x, flg) -> if flg then env @ [x] else env) [] (List.combine args arg_flgs) in
							let new_fargs = List.fold_left (fun env (x, flg) -> if flg then env @ [x] else env) [] (List.combine fargs farg_flgs) in
							stmt.sInst <- CallDir (dst, Id.L name, new_args, new_fargs)
						| _ -> ()
			) blk.bStmts
	) fundef.fBlocks

let h fundef =
	Liveness.analysis fundef;
	elim_args fundef;
	elim_body fundef;
	fundef


let f (Prog (data, fundefs, main_fun) as prog) =
	args_env := M.empty;
	fargs_env := M.empty;
	let fundefs' = List.map h fundefs in
	let ans = Prog (data, fundefs', h main_fun) in
(*	Block.print_prog 3 ans;*)
	ans
