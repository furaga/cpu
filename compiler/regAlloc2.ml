open Asm

(* グローバル割付を行うか *)
(* このコードだと、クロージャが存在する限り行ってはいけないはず *)
let do_global_allocation = false

(* レジスタ割り当てが済んだ関数群 *)
let fixed = ref S.empty

(* 生存解析のようなことをしてる？ *)
let rec target' src (dest, t) live = function
	| Mov x | FMovD x when is_reg dest ->
		if x = src then ([dest], S.empty)
		else ([], S.singleton dest)		(* S.singleton x はxだけを含んでいる要素を返す？*)
	| IfEq (_, _, e1, e2)
	| IfLE (_, _, e1, e2)
	| IfGE (_, _, e1, e2)
	| IfFEq (_, _, e1, e2)
	| IfFLE (_, _, e1, e2) ->
		let (rs1, use1) = target src (dest, t) live e1 in
		let (rs2, use2) = target src (dest, t) live e2 in
		if not (live || List.mem src (fv e1)) then (rs2, use2)
		else if not (live || List.mem src (fv e2)) then (rs1, use1)
		else (rs1 @ rs2, S.union use1 use2)
	| CallCls(x, ys, zs) -> (* TODO *)
		([reg_cl], S.of_list (allregs @ allfregs))
	| CallDir(Id.L x, ys, zs) ->
		let arg_regs = get_arg_regs x in
		List.fold_left2
			(fun (prefer, use) y r ->
				if y = src then (r :: prefer, use)
				else (prefer, S.add r use)
			) ([], if live then get_use_regs x else S.empty) (ys @ zs) arg_regs
	| _ -> ([], S.empty)
(* srcが生きて？いたらなにかしてるようです＞＜ *)
and target src dest live = function
	| Ans(exp) -> target' src dest live exp
	(* srcがlet文で使用される（live）か、e内で使用されるとき *)
	| Let(xt, exp, e) when live || List.mem src (fv e) ->
		(* exp, e両方のprefer, usedの和集合が答え *)
		let (prefer1, used1) = target' src xt true exp in
		let (prefer2, used2) = target src dest live e in
		(prefer1 @ prefer2, S.union used1 used2)
	(* それ以外 *)
	| Let(xt, exp, e) -> target' src xt false exp
	| Forget(_, e) -> target src dest live e

let rec target_call = function
	| CallCls(x, _, _) -> [List.hd allregs; List.hd allfregs] (* %g3か%f0のどちらかが返り値 *)
	| CallDir(Id.L x, _, _) -> [get_ret_reg x]
	| IfEq (_, _, e1, e2)
	| IfLE (_, _, e1, e2)
	| IfGE (_, _, e1, e2)
	| IfFEq (_, _, e1, e2)
	| IfFLE (_, _, e1, e2) ->
		(target_call' e1) @ (target_call' e2)
	| _ -> []

and target_call' = function
	| Ans(exp) -> target_call exp
	| Let(_, _, e) | Forget(_, e) -> target_call' e

type alloc_result =
	| Alloc of Id.t
	| Spill of Id.t

let rec alloc dest cont exp regenv x t =
	(* regenvからxに対応するレジスタを探す。なければxのまま *)
	let x = if M.mem x regenv then M.find x regenv else x in
	(*  assert (not (M.mem x regenv)); *)
	let all =
		match t with
			| Type.Unit -> []
			| Type.Float -> allfregs
			| _ -> allregs in
	(* xがUnit型だったらダミーレジスタを返す *)
	if all = [] then Alloc "%dummy"
	(* xがレジスタだったらそれを返す *)
	else if is_reg x then Alloc x
	(* xがレジスタでない（まだ割り付けられてないときd） *)
	else
		(* contに現れる自由変数 *)
		let free = fv cont in
		try
			(* preferは優先して割り当てたいレジスタ。usedはcont内で使用されているレジスタ *)
			let (prefer, used) = target x dest false cont in
			let prefer = (target_call exp) @ prefer in (* TODO *)
			(* usedに入ってない（cont式で使われていない）ものだけ残す *)
			let prefer = List.filter
							(fun r -> not (S.mem r used)
							) (prefer @ all) in
			let live = List.fold_left
							(fun live y ->
								if M.mem y regenv then S.add (M.find y regenv) live
								else live
							) S.empty free in
(*			print_string "prefer: "; List.iter (fun x -> print_string (x ^ ", ")) prefer;
			print_string "\nall: "; List.iter (fun x -> print_string (x ^ ", ")) all;
			print_string "\nlive: "; S.iter (fun x -> print_string (x ^ ", ")) live;
			print_newline ();
			flush stdout;*)
			let r = List.find
						(fun r -> List.mem r all && not (S.mem r live)
						) (prefer @ all) in
			Alloc r
		with Not_found ->
			Format.eprintf "register allocation failed for %s@." x;
	let y = List.find
				(fun y -> not (is_reg y) && M.mem y regenv && List.mem (M.find y regenv) all
				) (List.rev free) in
	Format.eprintf "spilling %s from %s@." y (M.find y regenv);
	Spill y

let add x r regenv =
	if is_reg x then (assert (x = r); regenv) else
	M.add x r regenv

type g_result =
	| NoSpill of t * Id.t M.t
	| ToSpill of t * Id.t list

exception NoReg of Id.t * Type.t

let find x t regenv =
	if is_reg x then x else
	try M.find x regenv
	with Not_found -> raise (NoReg (x, t))

let find' x' regenv =
	match x' with
		| V x -> V (find x Type.Int regenv)
		| c -> c

(*
	insert_forget xs exp t で
	let a : t = exp in
		forget (xs.(0),
			forget (xs.(1),
				forget (xs.(2), ・・・,
					ans (Nop / Mov a / FMovD a) ・・・)))
	のような式を作る
	
	Forget(x, e)とは、式eのレジスタ割付において、過去の割付の歴史を無視して変数xレジスタ割付を再びやり直すことを意味する
*)
let forget_list xs e = List.fold_left (fun e x -> Forget(x, e)) e xs
let insert_forget xs exp t =
	Format.eprintf "Stack: %s@." (String.concat ", " xs);
	let a = Id.gentmp t in
	let m = match t with
		| Type.Unit -> Nop
		| Type.Float -> FMovD a
		| _ -> Mov a in
	ToSpill (Let ((a, t), exp, forget_list xs (Ans m)), xs)

let rec g dest cont regenv = function
	| Ans exp -> g'_and_restore dest cont regenv exp
	| Let ((x, t) as xt, exp, e) ->
		(*	  assert (not (M.mem x regenv));*)
		(* concat e dest cont => let dest = e in cont *)
		let cont' = concat e dest cont in
		(match g'_and_restore xt cont' regenv exp with
			| ToSpill (e1, ys) -> ToSpill(concat e1 xt e, ys)
			| NoSpill (e1', regenv1) ->
				(match alloc dest cont' exp regenv1 x t with
					| Spill y -> ToSpill(Let(xt, exp, Forget(y, e)), [y])
					| Alloc r ->
						match g dest cont (add x r regenv1) e with
							| ToSpill(e2, ys) when List.mem x ys ->
								let x_saved = Let(xt, exp, seq(Save(x, x), e2)) in
								(match List.filter (fun y -> y <> x) ys with
									| [] -> g dest cont regenv x_saved
									| ys_left -> ToSpill(x_saved, ys_left))
							| ToSpill(e2, ys) -> ToSpill(Let(xt, exp, e2), ys)
							| NoSpill(e2', regenv2) -> NoSpill(concat e1' (r, t) e2', regenv2)))
	| Forget(x, e) ->
		(* M.add x regenv ではなく M.remove x regenvとなっている。つまりxは無視される *)
		(match g dest cont (M.remove x regenv) e with
			(* ToSpillだったら、e1からxの割付をなかったことにしてもう一回 *)
			| ToSpill(e1, ys) ->
				let x_forgotten = Forget(x, e1) in
				(match List.filter (fun y -> y <> x) ys with
					| [] -> g dest cont regenv x_forgotten
					| ys_left -> ToSpill(x_forgotten, ys_left))
			(* NoSpillだったらそのままが答え*)
			| NoSpill(e1', regenv1) -> NoSpill(e1', regenv1))

and g'_and_restore dest cont regenv exp =
	try g' dest cont regenv exp
	with NoReg(x, t) -> 
    	(Format.eprintf "restoring %s@." x;
		g dest cont regenv (Let ((x, t), Restore x, Ans exp)))

and g' dest cont regenv = function
	| Nop | Set _ | SetL _ | Comment _ | Restore _ as exp -> NoSpill(Ans(exp), regenv)
	| Mov x -> NoSpill (Ans (Mov (find x Type.Int regenv)), regenv)
	| Neg x -> NoSpill (Ans (Neg (find x Type.Int regenv)), regenv)
	| Add (x, y') -> NoSpill (Ans (Add (find x Type.Int regenv, find' y' regenv)), regenv)
	| Sub (x, y') -> NoSpill (Ans (Sub (find x Type.Int regenv, find' y' regenv)), regenv)
	| Mul (x, y') -> NoSpill (Ans (Mul (find x Type.Int regenv, find' y' regenv)), regenv)
	| Div (x, y') -> NoSpill (Ans (Div (find x Type.Int regenv, find' y' regenv)), regenv)
	| SLL (x, y') -> NoSpill (Ans (SLL (find x Type.Int regenv, find' y' regenv)), regenv)
	| Ld (x, y') -> NoSpill (Ans (Ld (find x Type.Int regenv, find' y' regenv)), regenv)
	| St (x, y, z') -> NoSpill (Ans (St (find x Type.Int regenv, find y Type.Int regenv, find' z' regenv)), regenv)
	| FMovD x -> NoSpill (Ans (FMovD (find x Type.Float regenv)), regenv)
	| FNegD x -> NoSpill (Ans (FNegD (find x Type.Float regenv)), regenv)
	| FAddD (x, y) -> NoSpill (Ans (FAddD (find x Type.Float regenv, find y Type.Float regenv)), regenv)
	| FSubD (x, y) -> NoSpill (Ans (FSubD (find x Type.Float regenv, find y Type.Float regenv)), regenv)
	| FMulD (x, y) -> NoSpill (Ans (FMulD (find x Type.Float regenv, find y Type.Float regenv)), regenv)
	| FDivD (x, y) -> NoSpill (Ans (FDivD (find x Type.Float regenv, find y Type.Float regenv)), regenv)

	| LdDF (x, y') -> NoSpill (Ans (LdDF (find x Type.Int regenv, find' y' regenv)), regenv)
	| StDF (x, y, z') -> NoSpill (Ans (StDF (find x Type.Float regenv, find y Type.Int regenv, find' z' regenv)), regenv)

	| IfEq (x, y', e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfEq (find x Type.Int regenv, find' y' regenv, e1', e2')) e1 e2
	| IfLE (x, y', e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfLE (find x Type.Int regenv, find' y' regenv, e1', e2')) e1 e2
	| IfGE (x, y', e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfGE (find x Type.Int regenv, find' y' regenv, e1', e2')) e1 e2
	| IfFEq (x, y, e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfFEq (find x Type.Float regenv, find y Type.Float regenv, e1', e2')) e1 e2
	| IfFLE (x, y, e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfFLE (find x Type.Float regenv, find y Type.Float regenv, e1', e2')) e1 e2

	| CallCls(x, ys, zs) as exp -> g'_call x dest cont regenv exp (fun ys zs -> CallCls(find x Type.Int regenv, ys, zs)) ys zs
	| CallDir (Id.L x, ys, zs) as exp -> g'_call x dest cont regenv exp (fun ys zs -> CallDir(Id.L x, ys, zs)) ys zs

	| Save(x, y) ->
		assert (x = y);
		assert (not (is_reg x));
		try NoSpill (Ans (Save (M.find x regenv, x)), regenv)
		with Not_found -> NoSpill (Ans Nop, regenv)
		
and g'_if dest cont regenv exp constr e1 e2 =
	(* e1に対してレジスタ割付 *)
	let (e1', regenv1) = g_repeat dest cont regenv e1 in
	(* e2に対してレジスタ割付 *)
	let (e2', regenv2) = g_repeat dest cont regenv e2 in
	(* expに続く式contに現れる自由変数のうち、e1, e2の両方でレジスタrとして使われているならx -> rという写像をregenv'に入れる *)
	let regenv' = List.fold_left
					(fun regenv' x ->
						try
							if is_reg x then regenv'
							else
								let r1 = M.find x regenv1 in
								let r2 = M.find x regenv2 in
								if r1 <> r2 then regenv'
								else M.add x r1 regenv'
						with Not_found -> regenv'
					) M.empty (fv cont) in
	(* contに現れる自由変数のうち、レジスタでも返り値でもなく、regenv'に登録されてもいない変数 *)
	(* 要はまだレジスタが割り付けられていない変数の集合 *)
	let xs = List.filter
				(fun x -> not (is_reg x) && x <> fst dest && not (M.mem x regenv')
				) (fv cont) in
	match xs with
		| [] -> NoSpill (Ans (constr e1' e2'), regenv')	(* 全部割り付けられているのでこのままでOK *)
		| xs -> insert_forget xs exp (snd dest)				(*  *)

(*
	CallDir, CallClsに対してレジスタ割り当てをする
		id :		関数名（CallDirのときのみ使用）
		dest :		式expの評価結果の代入先レジスタ
		cont :		expの後に続く式
		regenv :	現時点での変数・関数からレジスタへの写像
		exp :		割り当てたい式
		constr :	割り当て後の式を作るための関数
		ys : 		整数実引数
		zs :		浮動小数点実引数
*)
and g'_call id dest cont regenv exp constr ys zs =
	(* CallDirだったら関数名idをfixedに追加 *)
	(match exp with 
		| CallDir _ -> fixed := S.add id !fixed 
		| CallCls _ -> if do_global_allocation then assert false else () 
		| _ -> assert false);

	(* 関数idの仮引数に使うレジスタを取得 *)
	let args =
		(match exp with
			(* CallDirならget_arg_regsで取得 *)
			| CallDir _ -> get_arg_regs id
			| CallCls _ ->
				(* グローバル割付をするならCallClsが評価されるのはおかしい *)
				if do_global_allocation then assert false 
				(* グローバル割付をしないなら、引数は%g3, %g4, ・・・, %f0, %f1, ・・・となっているはずなので、ys, zsの要素数から仮引数レジスタが推測できる *)
				else
					let (args, _) = List.fold_left (fun (args, iregs) _ -> args @ [List.hd iregs], List.tl iregs) ([], allregs) ys in
					let (args, _) = List.fold_left (fun (args, fregs) _ -> args @ [List.hd fregs], List.tl fregs) (args, allfregs) zs in
					args
			| _ -> assert false) in

	(* contのレジスタ割付をする際、割付なおす変数を選択 *)
	let xs = List.filter
				(fun x -> 
					(* レジスタでも返り値でもないが、regenvに登録はされている変数xで *)
					if not (is_reg x) && x <> fst dest && M.mem x regenv then
						let r = M.find x regenv in
						(* 対応するレジスタrが関数idで使用されるレジスタに入ってるなら変数xの割付をやり直す *)
						if S.mem r (get_use_regs id) then true
						(* レジスタrが関数idの引数xだったら変数xの割付をやり直す *)
						else if List.mem r args && List.assoc r (List.combine args (ys @ zs)) <> x then true
						else false
					else
						false
				) (fv cont) in

	match xs with
		| [] ->
			(* 関数の引数ys, zsにレジスタを割り付ける *)
			let (ys, zs) = List.fold_left2
							(fun (ys, zs) y r ->
								if List.mem r allregs then
									(ys @ [find y Type.Int regenv], zs)
								else if List.mem r allfregs then
									(ys, zs @ [find y Type.Float regenv])
								else assert false
							) ([], []) (ys @ zs) args in
			NoSpill (Ans (constr ys zs), regenv)

		(* Forget式を適宜追加して割付直す変数を明記する *)
		(* insert_forgetの返り値はToSpill _ なのでg_repeat内で再び評価される *)
		| xs -> insert_forget xs exp (snd dest)

(* spillしなくなるまで g -> save -> g -> ・・・というループを繰り返す *)
and g_repeat dest cont regenv e =
	match g dest cont regenv e with
		(* Spillしなければそれが答え *)
		| NoSpill(e', regenv') -> (e', regenv')
		(* SpillするならSave擬似命令をeの前にくっつけ、もう一回チャレンジ *)
		| ToSpill(e, xs) ->
			g_repeat dest cont regenv (List.fold_left
											(fun e x -> seq (Save (x, x), e) (* Save (x, x)と謎なことをしているようだが、g'関数内で適切に処理されている *)
										) e xs)

(* 式の中で適用される各関数で使用されるレジスタの集合を返す。tailは関数の末尾かどうか *)
let rec get_use_regs tail = function
	| Ans e -> get_use_regs' tail e
	| Let ((x, _), e, t) ->
		S.add
			x
			(S.union (get_use_regs' false e) (* eはlet x = e in tのeの部分なので当然末尾ではない *)
			(get_use_regs tail t))
	| Forget (x, e) -> S.add x (get_use_regs tail e)

and get_use_regs' tail = function
	| IfEq(_, _, e1, e2) | IfLE(_, _, e1, e2) | IfGE(_, _, e1, e2) | IfFEq(_, _, e1, e2) | IfLE(_, _, e1, e2) -> S.union (get_use_regs tail e1) (get_use_regs tail e2)
	| CallDir(Id.L x, ys, zs) ->
		(* 関数xが内部で使うレジスタを取得 *)
		let use = Asm.get_use_regs x in
		(* 仮引数と実引数で割り当てられたレジスタが異なれば、仮引数用のレジスタをuseに追加する *)
		(* get_arg_regs x　は Asm.get_use_regs x の部分集合のはずなので不要では？ *)
		let use = List.fold_left2
					(fun use r y ->	(* rは仮引数。yは実引数 *)
						if r = y then use
						else S.add r use
					) use (get_arg_regs x) (ys @ zs) in
		Printf.printf "%s use : " x;
		S.iter (fun x -> Printf.printf "%s " x) use;
		print_newline();
		use
	(* クロージャ呼び出しのときはどんな関数がxに入ってるか分からないのですべてのレジスタを使用するものと仮定 *)
	| CallCls(x, ys, zs) -> 
		if do_global_allocation then assert false
		else
			S.of_list (allregs @ allfregs)
	| _ -> S.empty

(* 関数xに対してレジスタ割り当て。同時にfundataも更新 *)
let h { name = Id.L x; args = xs; fargs = ys; body = e; ret = t } =
	print_endline ("\n\nh : " ^ x);
(* 	(* 仮引数のレジスタへの割り当て（たぶんこれがグローバル割付にあたるもの）*)
	(* クロージャが存在しないときのみ正常に動作する？ *)
	(* 現状では再帰関数はクロージャを作ってしまうのでこの機能は使えないはず *)
	(* 今は切っておく *)
	if do_global_allocation && not (S.mem x !fixed) then (
		(* すべての関数はvirtual.mlでfundataに登録されているはず *)
		let data =
			if M.mem x !fundata then
				M.find x !fundata
			else
				assert false in

		(* 仮引数xs @ ysに対してalloc関数を使ってレジスタを割り当てる *)
		let (new_arg_regs, _) = List.fold_left2
								(fun (arg_regs, regenv) x r ->
									(* レジスタrの型を取得。virtual.mlで決めたdata.arg_regsは結局引数の型を調べるのに利用するだけ *)
									let typ = 
										if List.mem r allregs then
											Type.Int
										else if List.mem r allfregs then
											Type.Float
										else
											assert false in
									(* 引数xに対してレジスタを割り当てる。allocの返り値はAlloc (_)になってるはず *)
									match (alloc (data.ret_reg, t) e Nop regenv x typ) with
										| Alloc r -> (arg_regs @ [r], M.add x r regenv)
										| _ -> assert false
								) ([], M.empty) (xs @ ys) data.arg_regs in
								
		(* dataのarg_regsの値をnew_arg_regsに置き換える *)
		let data = { data with arg_regs = new_arg_regs } in
		(* fundataにdataを再登録 *)
		fundata := M.add x data !fundata
	);*)
	(* すべての関数はvirtual.mlでfundataに登録されているはず *)
	let data =
		if M.mem x !fundata then
			M.find x !fundata
		else
			assert false in
	
	(* regenvは変数・関数からレジスタへの写像 *)
	(* 関数からクロージャ用レジスタへの写像を追加（再帰用） *)
	let regenv = M.add x reg_cl M.empty in
	(* 各仮引数から上で求めたレジスタへの写像を追加 *)
	let regenv = List.fold_left2
					(fun env x r -> M.add x r env
					) regenv (xs @ ys) data.arg_regs in

	(* g_repeatに与えるcont引数を作成 *)
	(* この関数の返り値（レジスタ）は必ず使用されるはずなので、contにMov・FMovD擬似命令を設定する *)
	let cont = Ans (if t = Type.Float then FMovD data.ret_reg else Mov data.ret_reg) in

	(* 関数本体へのレジスタ割り当て *)
	(* g_repeat (eの評価結果の代入先レジスタ) (eの後に続く式) (現時点で作成された変数・関数からレジスタへの写像) (割り当てをしたい式) *)
	let (e', _) = g_repeat (data.ret_reg, t) cont regenv e in

	(* use_regsを正しい値にする。（この時点では allregs @ allfregs がuse_regsに入っている） *)
	(* 正しい値とは、eの中で使用されるレジスタ＋返り値を入れるレジスタ（%g3または%f0） *)
	let data = { data with use_regs = S.add reg_cl S.empty } in
	fundata := M.add x data !fundata;
	let env = S.add data.ret_reg (get_use_regs true e') in
	let data = { data with use_regs = env } in

	(* use_regsの値を更新したのでfundataに再登録 *)
	fundata := M.add x data !fundata;

	(* レジスタ割り当てを済ませたのでその結果をhの返り値とする *)
	print_string "\targs: "; List.iter (fun x -> print_string (x ^ ", ")) (List.filter (fun x -> List.mem x allregs) data.arg_regs); print_newline ();
	print_string "\tfargs: "; List.iter (fun x -> print_string (x ^ ", ")) (List.filter (fun x -> List.mem x allfregs) data.arg_regs); print_newline ();
	print_string "\tuse_regs: "; S.iter (fun x -> print_string (x ^ ", ")) data.use_regs; print_newline (); flush stdout;
	{ 	name = Id.L x;
		args = List.filter (fun x -> List.mem x allregs) data.arg_regs;
		fargs = List.filter (fun x -> List.mem x allfregs) data.arg_regs;
		body = e'; 
		ret = t }

let f (Prog(data, funs, e)) =
	fixed := S.empty;
	(* funsの各関数に対してレジスタ割り当て。同時にfundataも更新 *)
	let funs' = List.map h funs in
	(* e（main関数みたいなもの）に対してレジスタ割り当て *)
	let e', _ = g_repeat ("%dummy", Type.Unit) (Ans Nop) M.empty e in
	Prog(data, funs', e')
