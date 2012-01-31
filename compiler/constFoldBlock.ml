(*open Asm
open Block

let memi x env =
  try match M.find x env with Block.Set _ -> true | _ -> false
  with Not_found -> false

let findi x env = match M.find x env with Block.Set (_, i) -> i | _ -> assert false

let replace env fundef stmt = 
	let new_inst =
		match stmt.sInst with
			(* 1変数を使用 *)
			| Block.Mov (xt, x) when memi x env -> Block.Set (xt, findi x env)
			| Block.Neg (xt, x) when memi x env -> Block.Set (xt, -(findi x env))
			| Block.Add (xt, x, C y) when memi x env -> Block.Set (xt, findi x env + y)
			| Block.Sub (xt, x, C y) when memi x env -> Block.Set (xt, findi x env - y)
			| Block.Mul (xt, x, C y) when memi x env -> Block.Set (xt, findi x env * y) 
			| Block.Div (xt, x, C y) when memi x env -> Block.Set (xt, findi x env / y)
			| Block.SLL (xt, x, C y) when memi x env && y >= 0 -> Block.Set (xt, findi x env lsl y) 
			| Block.SLL (xt, x, C y) when memi x env -> Block.Set (xt, findi x env asr (-y)) 

			(* 2変数を使用 *)
			| Block.Add (xt, x, V y) when memi x env && memi y env -> Block.Set (xt, findi x env + findi y env)
			| Block.Add (xt, x, V y) when memi x env && findi x env = 0 -> Block.Mov (xt, y)
			| Block.Add (xt, x, V y) when memi y env && findi y env = 0 -> Block.Mov (xt, x)

			| Block.Sub (xt, x, V y) when memi x env && memi y env -> Block.Set (xt, findi x env - findi y env)
			| Block.Sub (xt, x, V y) when memi x env && findi x env = 0 -> Block.Mov (xt, y)
			| Block.Sub (xt, x, V y) when memi y env && findi y env = 0 -> Block.Mov (xt, x)

			| Block.Mul (xt, x, V y) when memi x env && memi y env -> Block.Set (xt, findi x env * findi y env)
			| Block.Mul (xt, x, V y) when memi x env && findi x env = 0 -> Block.Set (xt, 0)
			| Block.Mul (xt, x, V y) when memi y env && findi y env = 0 -> Block.Set (xt, 0)
			| Block.Mul (xt, x, V y) when memi x env && findi x env = 1 -> Block.Mov (xt, y)
			| Block.Mul (xt, x, V y) when memi y env && findi y env = 1 -> Block.Mov (xt, x)
			| Block.Mul (xt, x, V y) when memi x env && findi x env = -1 -> Block.Neg (xt, y)
			| Block.Mul (xt, x, V y) when memi y env && findi y env = -1 -> Block.Neg (xt, x)
			| Block.Mul (xt, x, V y) when memi x env && findi x env = 2 -> Block.Add (xt, y, V y)
			| Block.Mul (xt, x, V y) when memi y env && findi y env = 2 -> Block.Add (xt, x, V x)
		
			| Block.Div (xt, x, V y) when memi x env && memi y env -> Block.Set (xt, findi x env / findi y env)
			| Block.Div (xt, x, V y) when memi x env && findi x env = 0 -> Block.Set (xt, 0)
			| Block.Div (xt, x, V y) when memi y env && findi y env = 1 -> Block.Mov (xt, x)
			| Block.Div (xt, x, V y) when memi y env && findi y env = -1 -> Block.Neg (xt, x)

			| Block.SLL (xt, x, V y) when memi x env && memi y env && findi y env >= 0 -> Block.Set (xt, findi x env lsl findi y env)
			| Block.SLL (xt, x, V y) when memi x env && memi y env -> Block.Set (xt, findi x env asr (-(findi y env)))
			| Block.SLL (xt, x, V y) when memi x env && findi x env = 0 -> Block.Set (xt, 0)
			| Block.SLL (xt, x, V y) when memi y env && findi y env = 0 -> Block.Mov (xt, x)

			| Block.Ld (xt, x, V y) when memi x env -> Block.Ld (xt, y, C (findi x env))
			| Block.Ld (xt, x, V y) when memi y env -> Block.Ld (xt, x, C (findi y env))

			(* 3変数を使用 *)
			| Block.St (xt, x, y, V z) when memi y env -> Block.St (xt, x, z, C (findi y env))
			| Block.St (xt, x, y, V z) when memi z env -> Block.St (xt, x, y, C (findi z env))

			| Block.LdF (xt, x, V y) when memi x env -> Block.LdF (xt, y, C (findi x env))
			| Block.LdF (xt, x, V y) when memi y env -> Block.LdF (xt, x, C (findi y env))

			| Block.StF (xt, x, y, V z) when memi y env -> Block.StF (xt, x, z, C (findi y env))
			| Block.StF (xt, x, y, V z) when memi z env -> Block.StF (xt, x, y, C (findi z env))

			(* その他 *)
			| e -> e in
	let defs = fst (Block.get_def_use stmt) in
	assert (List.length defs = 1);
	stmt.sInst <- new_inst;
	let def = List.hd defs in
	M.add def new_inst env

let rec iter_stmts env fundef blk stmt_id = 
	Printf.printf "ITER_STMTS %s\n" stmt_id;
	if stmt_id <> "" then (
		let stmt = Block.find_assert "ITER_STMTS : " stmt_id blk.bStmts in
		let env = replace env fundef stmt in
		iter_stmts env fundef blk stmt.sSucc
	)
	else env
	
let rec iter_blocks env fundef blk_id = 
	Printf.printf "ITER_BLOCKS %s\n" blk_id;
	let blk = Block.find_assert "ITER_BLOCKS : " blk_id fundef.fBlocks in
	let env = iter_stmts env fundef blk blk.bHead in
	List.iter (
		fun succ -> iter_blocks env fundef succ
	) blk.bSuccs
	
let h fundef = 
	Printf.printf "h <%s>\n" (Id.get_name fundef.fName);
	iter_blocks M.empty fundef fundef.fHead; fundef

let f (Block.Prog (data, fundefs, main_fun)) =
	Printf.printf "f \n";
	let prog = Block.Prog (data, List.map h fundefs, h main_fun) in
	Block.print_prog 3 prog;
	prog*)
