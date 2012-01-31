(** Block.progでの不要コード除去 **)
(* 副作用がなくて、代入先がliveoutでない命令を除去 *)

open Block

let effect_blk env blk_id = Block.find_assert "ElimBlock.effect_blk" blk_id env
let effect stmt =  (* 副作用の有無 (caml2html: elim_effect) *)
	match stmt.sInst with
		| St _
		| StF _
		| Save _
		| CallDir _ -> true
		| IfEq (_, _, _, b1, b2) 
		| IfLE (_, _, _, b1, b2)
		| IfGE (_, _, _, b1, b2)
		| IfFEq (_, _, _, b1, b2)
		| IfFLE (_, _, _, b1, b2) -> true (* めんどい *)
		| CallCls _ -> assert false
		| _ -> false

let rec g fundef = 
	M.iter (
		fun _ blk ->
			let live = ref blk.bLiveout in
			let rec iter stmt_id = 
				let stmt = Block.find_assert "ElimBlock.g : " stmt_id blk.bStmts in
				(* def, useの取得 *)
				let (def, use) = Block.get_def_use stmt in
				let (def, use) = (S.of_list def, S.of_list use) in
				(* 削除するかどうか判定 *)
				stmt.sLiveout <- !live;
				(if stmt.sSucc <> "" && S.is_empty (S.inter def stmt.sLiveout) && not (effect stmt)then (
					(* defがliveoutと共通の要素を持たず、stmtに副作用がない場合除去できる *)
					Block.remove_stmt blk stmt
				)
				else
					(* liveの更新 *)
					live := S.union use (S.diff !live def));
				if stmt.sPred <> "" then iter stmt.sPred in	
			if not (M.is_empty blk.bStmts) then iter blk.bTail		
	) fundef.fBlocks;
	fundef

let h fundef =
	Liveness.analysis fundef;
	g fundef
 
let f (Prog (data, fundefs, main_fun) as prog) =
	let fundefs' = List.map h fundefs in
	let ans = Prog (data, fundefs', main_fun) in
	Block.print_prog 3 ans;
	ans
