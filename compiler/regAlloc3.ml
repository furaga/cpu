open Asm

let fixed = ref S.empty

let alls = S.of_list (allregs @ allfregs)

let get_safe_regs x = S.diff alls (get_use_regs x)

(* for register coalescing *)
(* [XXX] Callがあったら、そこから先は無意味というか逆効果なので追わない。
         そのために「Callがあったかどうか」を返り値の第1要素に含める。 *)
let rec target' src (dest, t) = function
  | Mov(x) when x = src && is_reg dest ->
      assert (t <> Type.Unit);
      assert (t <> Type.Float);
      false, [dest]
  | FMovD(x) when x = src && is_reg dest ->
      assert (t = Type.Float);
      false, [dest]
  | IfEq(_, _, e1, e2) | IfLE(_, _, e1, e2) | IfGE(_, _, e1, e2)
  | IfFEq(_, _, e1, e2) | IfFLE(_, _, e1, e2) ->
      let c1, rs1 = target src (dest, t) e1 in
      let c2, rs2 = target src (dest, t) e2 in
      c1 && c2, rs1 @ rs2
  | CallCls(x, ys, zs) ->
      true, (target_args src regs 0 ys @
	     target_args src fregs 0 zs @
             if x = src then [reg_cl] else [] @
	     S.elements (get_safe_regs x))
  | CallDir(Id.L x, ys, zs) ->
      true, (
      	get_arg_regs x @
	     S.elements (get_safe_regs x))
  | _ -> false, []
and target src dest = function (* register targeting (caml2html: regalloc_target) *)
  | Forget(id, e) -> target src dest e
  | Ans(exp) -> target' src dest exp
  | Let(xt, exp, e) ->
      let c1, rs1 = target' src xt exp in
      if c1 then 
      	true, rs1 
      else
      	let c2, rs2 = target src dest e in
      	c2, rs1 @ rs2
and target_args src all n = function (* auxiliary function for Call *)
  | [] -> []
  | y :: ys when src = y -> all.(n) :: target_args src all (n + 1) ys
  | _ :: ys -> target_args src all (n + 1) ys

type alloc_result = (* allocにおいてspillingがあったかどうかを表すデータ型 *)
  | Alloc of Id.t (* allocated register *)
  | Spill of Id.t (* spilled variable *)
let rec alloc dest cont regenv x t =
  (* allocate a register or spill a variable *)
  assert (not (M.mem x regenv));
  let all =
    match t with
    | Type.Unit -> ["%g0"] (* dummy *)
    | Type.Float -> allfregs
    | _ -> allregs in
  if all = ["%g0"] then Alloc("%g0") else (* [XX] ad hoc optimization *)
  if is_reg x then Alloc(x) else
  let free = fv cont in
  try
    let (c, prefer) = target x dest cont in
    let live = (* 生きているレジスタ *)
      List.fold_left
        (fun live y ->
	  if is_reg y then S.add y live else
          try S.add (M.find y regenv) live
          with Not_found -> live)
        S.empty
        free in
    let r = (* そうでないレジスタを探す *)
      List.find
        (fun r -> not (S.mem r live))
        (List.filter (fun x -> List.mem x all) prefer @ all) in
    (* Format.eprintf "allocated %s to %s@." x r; *)
    Alloc(r)
  with Not_found ->
    Format.eprintf "register allocation failed for %s@." x;
    let y = (* 型の合うレジスタ変数を探す *)
      List.find
        (fun y ->
	  not (is_reg y) &&
          try List.mem (M.find y regenv) all
          with Not_found -> false)
        (List.rev free) in
    Format.eprintf "spilling %s from %s@." y (M.find y regenv);
    Spill(y)

(* auxiliary function for g and g'_and_restore *)
let add x r regenv =
  if is_reg x then (assert (x = r); regenv) else
  M.add x r regenv

let a_ch = int_of_char 'a'
let z_ch = int_of_char 'z'
let save_flg = ref false

(* auxiliary functions for g' *)
exception NoReg of Id.t * Type.t
let find x t regenv =
  if is_reg x then x else
  try M.find x regenv
  with Not_found -> raise (NoReg(x, t))
let find' x' regenv =
  match x' with
  | V(x) -> V(find x Type.Int regenv)
  | c -> c

let is_global x exp =
	if not !save_flg then false
	else if int_of_char x.[0] < a_ch then false
	else if int_of_char x.[0] > z_ch then false
	else if not (M.mem x !GlobalEnv.env) then false
	else
		(match exp with
			| Restore y when x = y -> false
			| _ -> true) 

let rec g dest cont regenv = function (* 命令列のレジスタ割り当て (caml2html: regalloc_g) *)
  | Forget(id, t) -> assert false
  | Ans(exp) -> g'_and_restore dest cont regenv exp
  | Let((x, t) as xt, exp, e) ->
(*      print_endline x; flush stdout;*)
      assert (not (M.mem x regenv));
      let cont' = concat e dest cont in
      let (e1', regenv1) = g'_and_restore xt cont' regenv exp in
      (match alloc dest cont' regenv1 x t with
      | Spill(y) ->
		  let r = M.find y regenv1 in
		  let (e2', regenv2) = g dest cont (add x r (M.remove y regenv1)) e in
		  let save =
			try Save(M.find y regenv, y)
			with Not_found -> Nop in	    
		  (seq(save, concat e1' (r, t) e2'), regenv2)
      | Alloc(r) ->
		  let (e2', regenv2) = g dest cont (add x r regenv1) e in
		  (concat e1' (r, t) e2', regenv2))
and g'_and_restore dest cont regenv exp = (* 使用される変数をスタックからレジスタへRestore (caml2html: regalloc_unspill) *)
  try g' dest cont regenv exp
  with NoReg(x, t) ->
    ( (*Format.eprintf "restoring %s@." x;*)
     g dest cont regenv (Let((x, t), Restore(x), Ans(exp))))
and g' dest cont regenv = function (* 各命令のレジスタ割り当て (caml2html: regalloc_gprime) *)
  | Nop | Set _ | SetL _ | Comment _ | Restore _ as exp -> (Ans(exp), regenv)
  | Mov(x) -> (Ans(Mov(find x Type.Int regenv)), regenv)
  | Neg(x) -> (Ans(Neg(find x Type.Int regenv)), regenv)
  | Add(x, y') -> (Ans(Add(find x Type.Int regenv, find' y' regenv)), regenv)
  | Sub(x, y') -> (Ans(Sub(find x Type.Int regenv, find' y' regenv)), regenv)
  | Mul(x, y') -> (Ans(Mul(find x Type.Int regenv, find' y' regenv)), regenv)
  | Div(x, y') -> (Ans(Div(find x Type.Int regenv, find' y' regenv)), regenv)
  | SLL(x, y') -> (Ans(SLL(find x Type.Int regenv, find' y' regenv)), regenv)
  | Ld(x, y') -> (Ans(Ld(find x Type.Int regenv, find' y' regenv)), regenv)
  | St(x, y, z') -> (Ans(St(find x Type.Int regenv, find y Type.Int regenv, find' z' regenv)), regenv)
  | FMovD(x) -> (Ans(FMovD(find x Type.Float regenv)), regenv)
  | FNegD(x) -> (Ans(FNegD(find x Type.Float regenv)), regenv)
  | FAddD(x, y) -> (Ans(FAddD(find x Type.Float regenv, find y Type.Float regenv)), regenv)
  | FSubD(x, y) -> (Ans(FSubD(find x Type.Float regenv, find y Type.Float regenv)), regenv)
  | FMulD(x, y) -> (Ans(FMulD(find x Type.Float regenv, find y Type.Float regenv)), regenv)
  | FDivD(x, y) -> (Ans(FDivD(find x Type.Float regenv, find y Type.Float regenv)), regenv)
  | LdDF(x, y') -> (Ans(LdDF(find x Type.Int regenv, find' y' regenv)), regenv)
  | StDF(x, y, z') -> (Ans(StDF(find x Type.Float regenv, find y Type.Int regenv, find' z' regenv)), regenv)
  | IfEq(x, y', e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfEq(find x Type.Int regenv, find' y' regenv, e1', e2')) e1 e2
  | IfLE(x, y', e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfLE(find x Type.Int regenv, find' y' regenv, e1', e2')) e1 e2
  | IfGE(x, y', e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfGE(find x Type.Int regenv, find' y' regenv, e1', e2')) e1 e2
  | IfFEq(x, y, e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfFEq(find x Type.Float regenv, find y Type.Float regenv, e1', e2')) e1 e2
  | IfFLE(x, y, e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfFLE(find x Type.Float regenv, find y Type.Float regenv, e1', e2')) e1 e2
  | CallCls(x, ys, zs) as exp -> g'_call x dest cont regenv exp (fun ys zs -> CallCls(find x Type.Int regenv, ys, zs)) ys zs
  | CallDir(Id.L x, ys, zs) as exp -> g'_call x dest cont regenv exp (fun ys zs -> CallDir(Id.L x, ys, zs)) ys zs
  | Save(x, y) -> assert false
and g'_if dest cont regenv exp constr e1 e2 = (* ifのレジスタ割り当て (caml2html: regalloc_if) *)
	let (e1', regenv1) = g dest cont regenv e1 in
	let (e2', regenv2) = g dest cont regenv e2 in
	let regenv' = (* 両方に共通のレジスタ変数だけ利用 *)
		List.fold_left
			(fun regenv' x ->
			try
				if is_reg x then regenv' else
					let r1 = M.find x regenv1 in
					let r2 = M.find x regenv2 in
					if r1 <> r2 then regenv' else
						M.add x r1 regenv'
			with Not_found -> regenv')
			M.empty
					(fv cont) in
	(List.fold_left
		(fun e x ->
			if x = fst dest || not (M.mem x regenv) || M.mem x regenv' then e else
			seq(Save(M.find x regenv, x), e)) (* そうでない変数は分岐直前にセーブ *)
		(Ans(constr e1' e2'))
		(fv cont), 
	regenv')
and g'_call id dest cont regenv exp constr ys zs = (* 関数呼び出しのレジスタ割り当て (caml2html: regalloc_call) *)
	(List.fold_left
		(fun (e, env) x ->
		(*	Printf.printf "\t(%s, %s)\n" x (if M.mem x regenv then M.find x regenv else "");
		*)	if x = fst dest || not (M.mem x regenv) then (* 返り値と同じレジスタ/まだ登録されていない変数は退避しない *)
				(e, env)
			else if S.mem (M.find x regenv) (Asm.get_use_regs id) then (* 登録されてはいるが退避しなくてもいいレジスタ *)
				(seq (Save (M.find x regenv, x), e), env)
			else
				(e, M.add x (M.find x regenv) env))
		(Ans (constr
				(List.map (fun y -> find y Type.Int regenv) ys)
				(List.map (fun z -> find z Type.Float regenv) zs)), M.empty)
		(fv cont)
	)

(* 式の中で適用される各関数で使用されるレジスタの集合を返す。tailは関数の末尾かどうか *)
let rec get_use_regs id = function
	| Ans e -> get_use_regs' id e
	| Let ((x, _), e, t) ->
		S.add
			x
			(S.union
				(get_use_regs' id e) (* eはlet x = e in tのeの部分なので当然末尾ではない *)
				(get_use_regs id t))
	| Forget (x, e) -> S.add x (get_use_regs id e)

and get_use_regs' id = function
	| IfEq(_, _, e1, e2) | IfLE(_, _, e1, e2) | IfGE(_, _, e1, e2) | IfFEq(_, _, e1, e2) | IfFLE(_, _, e1, e2) -> S.union (get_use_regs id e1) (get_use_regs id e2)
	| CallDir(Id.L x, ys, zs) when is_reg x -> assert false	(* ラベル名がレジスタとかありえない *)
	| CallDir(Id.L x, ys, zs) when x = id -> S.empty			(* 自分自身なら得られる情報がないのでS.empty *)
	| CallDir(Id.L x, ys, zs) -> Asm.get_use_regs x			(* 登録された情報を参照 *)
	| CallCls(x, ys, zs) when is_reg x && x <> reg_cl -> S.of_list (allregs @ allfregs)	(* 自分以外を指すレジスタなら全部のレジスタを退避すべき *)
	| CallCls(x, ys, zs) when x = reg_cl || x = id -> S.empty	(* 自分自身なら得られる情報がないのでS.empty *)
	| CallCls(x, ys, zs) -> Asm.get_use_regs x					(* 登録された情報を参照 *)
	| SetL (Id.L x) when String.sub x 0 2 = "l." -> S.empty	(* 浮動小数テーブルのラベルなので無視 *)
	| SetL (Id.L x) when x = id -> S.empty						(* 自分自身なら得られる情報がないのでS.empty *)
	| SetL (Id.L x) -> Asm.get_use_regs x						(* 登録された情報を参照 *)
	| _ -> S.empty												(* それ以外の式に現れるレジスタは退避しなくてもいい *)
	
let h { name = Id.L(x); args = ys; fargs = zs; body = e; ret = t } = (* 関数のレジスタ割り当て (caml2html: regalloc_h) *)
	(*Printf.printf "[%s]\n" x;
	*)(* すべての関数はvirtual.mlでfundataに登録されているはず *)
	let data =
		if M.mem x !fundata then
			M.find x !fundata
		else
			assert false in
	(* 関数からクロージャ用レジスタへの写像を追加（再帰用） *)
	let regenv = M.add x reg_cl M.empty in
	(* 各仮引数から上で求めたレジスタへの写像を追加 *)
	let regenv = List.fold_left2
					(fun env x r -> M.add x r env
					) regenv (ys @ zs) data.arg_regs in
	let cont = Ans (if t = Type.Float then FMovD data.ret_reg else Mov data.ret_reg) in

	(* 関数本体へのレジスタ割り当て *)
	let (e', _) = g (data.ret_reg, t) cont regenv e in
	
	(* use_regsを正しい値にする。（この時点では allregs @ allfregs がuse_regsに入っている） *)
	(* 正しい値とは、e'の中で使用されるレジスタ＋返り値+引数（%g3または%f0） *)
	fundata := M.add x data !fundata;
	let env = S.union (S.of_list data.arg_regs) (S.add data.ret_reg (get_use_regs x e')) in
	let env = S.filter is_reg env in
	let env = S.union (S.of_list [reg_sw; reg_fsw; reg_cl]) env in
	
	let data = { data with use_regs = env} in
	fundata := M.add x data !fundata;

	(* レジスタ割り当てを済ませたのでその結果をhの返り値とする *)
(*	print_endline x;
	print_string "\targs: "; List.iter (fun x -> print_string (x ^ ", ")) (List.filter (fun x -> List.mem x allregs) data.arg_regs); print_newline ();
	print_string "\tfargs: "; List.iter (fun x -> print_string (x ^ ", ")) (List.filter (fun x -> List.mem x allfregs) data.arg_regs); print_newline ();
	print_string "\tret: "; print_endline data.ret_reg;
	print_string "\tuse_regs: "; S.iter (fun x -> print_string (x ^ ", ")) data.use_regs; print_newline (); flush stdout;
	Asm.print 0 e';
*)	{ 	name = Id.L x;
		args = List.filter (fun x -> List.mem x allregs) data.arg_regs;
		fargs = List.filter (fun x -> List.mem x allfregs) data.arg_regs;
		body = e'; 
		ret = t }

(* leaf関数か *)
let rec is_leaf env {name = Id.L id; body = t} = is_leaf_t (S.add id env) t
and is_leaf_t env = function
	| Ans e -> is_leaf_exp env e
	| Let (_, e, t) -> is_leaf_exp env e && is_leaf_t env t
	| Forget (_, t) -> is_leaf_t env t
and is_leaf_exp env = function
	| IfEq (_, _, e1, e2) | IfLE (_, _, e1, e2) | IfGE (_, _, e1, e2) | IfFEq (_, _, e1, e2) | IfFLE (_, _, e1, e2) ->
		is_leaf_t env e1 && is_leaf_t env e2
	| CallCls (x, _, _) | CallDir (Id.L x, _, _) ->
		(* 外部関数かenvに登録された（leafであると確認済みの）関数であればtrue *)
		if String.length x > 9 && String.sub x 0 9 = "min_caml_" then true
		else S.mem x env
	| _ -> true

(* 逆トポロジカルソート *)
let rec sort fundefs env =
	let (leafs, fundefs') = List.partition (is_leaf env) fundefs in
	assert (leafs <> []);
	if fundefs' = [] then leafs
	else
		(* envにleafsを追加登録 *)
		let env' = List.fold_left (fun env {name = Id.L x} -> S.add x env) env leafs in
		leafs @ sort fundefs' env'

let f (Prog(data, fundefs, e)) = (* プログラム全体のレジスタ割り当て (caml2html: regalloc_f) *)
	Format.eprintf "register allocation: may take some time (up to a few minutes, depending on the size of functions)@.";
(*	let fundefs' = List.map h (sort fundefs S.empty) in*)
	let fundefs' = List.map h fundefs in
	print_endline "main";
	
	save_flg := true;
(*	Asm.print_prog 1 (Prog(data, fundefs, e));*)
	
	let e', regenv' = g (Id.gentmp Type.Unit, Type.Unit) (Ans(Nop)) M.empty e in
	let ans = Prog (data, fundefs', e') in
(*	Asm.print_prog 1 ans;*)
	ans
