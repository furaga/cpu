(* give names to intermediate values (K-normalization) *)

type id_or_imm = V of Id.t | C of int

let pp_id_or_imm = function
  | V(x) -> x
  | C(i) -> string_of_int i

type t = (* K正規化後の式 (caml2html: knormal_t) *)
  | Unit
  | Int of int
  | Float of float
  | Neg of Id.t
  | Add of Id.t * Id.t
  | Sub of Id.t * Id.t
  | Mul of Id.t * Id.t
  | Div of Id.t * Id.t
  | SLL of Id.t * Id.t
  | FNeg of Id.t
  | FAdd of Id.t * Id.t
  | FSub of Id.t * Id.t
  | FMul of Id.t * Id.t
  | FDiv of Id.t * Id.t
  | IfEq of id_or_imm * id_or_imm * t * t (* 比較 + 分岐 (caml2html: knormal_branch) *)
  | IfLE of id_or_imm * id_or_imm * t * t (* 比較 + 分岐 *)
  | Let of (Id.t * Type.t) * t * t
  | Var of Id.t
  | LetRec of fundef * t
  | App of Id.t * Id.t list
  | Tuple of Id.t list
  | LetTuple of (Id.t * Type.t) list * Id.t * t
  | Get of Id.t * Id.t
  | Put of Id.t * Id.t * Id.t
  | ExtArray of Id.t
  | ExtFunApp of Id.t * Id.t list
and fundef = { name : Id.t * Type.t; args : (Id.t * Type.t) list; body : t }

let rec fv = function (* 式に出現する（自由な）変数 (caml2html: knormal_fv) *)
  | Unit | Int(_) | Float(_) | ExtArray(_) -> S.empty
  | Neg(x) | FNeg(x) -> S.singleton x
  | Add(x, y) | Sub(x, y) | Mul(x, y) | Div(x, y) | SLL(x, y) | FAdd(x, y) | FSub(x, y) | FMul(x, y) | FDiv(x, y) | Get(x, y) -> S.of_list [x; y]
  | IfEq(V x, V y, e1, e2) | IfLE(V x, V y, e1, e2) -> S.add x (S.add y (S.union (fv e1) (fv e2)))
  | IfEq(V x, C y, e1, e2) | IfLE(V x, C y, e1, e2) -> S.add x (S.union (fv e1) (fv e2))
  | IfEq(C x, V y, e1, e2) | IfLE(C x, V y, e1, e2) -> S.add y (S.union (fv e1) (fv e2))
  | IfEq(C x, C y, e1, e2) | IfLE(C x, C y, e1, e2) -> S.union (fv e1) (fv e2)
  | Let((x, t), e1, e2) -> S.union (fv e1) (S.remove x (fv e2))
  | Var(x) -> S.singleton x
  | LetRec({ name = (x, t); args = yts; body = e1 }, e2) ->
      let zs = S.diff (fv e1) (S.of_list (List.map fst yts)) in
      S.diff (S.union zs (fv e2)) (S.singleton x)
  | App(x, ys) -> S.of_list (x :: ys)
  | Tuple(xs) | ExtFunApp(_, xs) -> S.of_list xs
  | Put(x, y, z) -> S.of_list [x; y; z]
  | LetTuple(xs, y, e) -> S.add y (S.diff (fv e) (S.of_list (List.map fst xs)))

let insert_let (e, t) k = (* letを挿入する補助関数 (caml2html: knormal_insert) *)
  match e with
  | Var(x) -> k x
  | _ ->
      let x = Id.gentmp t in
      let e', t' = k x in
      Let((x, t), e, e'), t'

let rec g env e = 
	let line = snd e in
	match fst e with (* K正規化ルーチン本体 (caml2html: knormal_g) *)
  | Syntax.Unit -> Unit, Type.Unit
  | Syntax.Bool(b) -> Int(if b then 1 else 0), Type.Int (* 論理値true, falseを整数1, 0に変換 (caml2html: knormal_bool) *)
  | Syntax.Int(i) -> Int(i), Type.Int
  | Syntax.Float(d) -> Float(d), Type.Float
  | Syntax.Not(e) -> g env (Syntax.If(e, (Syntax.Bool(false), line), (Syntax.Bool(true), line)), line)
  | Syntax.Neg(e) ->
      insert_let (g env e)
	(fun x -> Neg(x), Type.Int)
  | Syntax.Add(e1, e2) -> (* 足し算のK正規化 (caml2html: knormal_add) *)
      insert_let (g env e1)
	(fun x -> insert_let (g env e2)
	    (fun y -> Add(x, y), Type.Int))
  | Syntax.Sub(e1, e2) ->
      insert_let (g env e1)
	(fun x -> insert_let (g env e2)
	    (fun y -> Sub(x, y), Type.Int))
  | Syntax.Mul(e1, e2) ->
      insert_let (g env e1)
	(fun x -> insert_let (g env e2)
	    (fun y -> Mul(x, y), Type.Int))
  | Syntax.Div(e1, e2) ->
      insert_let (g env e1)
	(fun x -> insert_let (g env e2)
	    (fun y -> Div(x, y), Type.Int))
  | Syntax.SLL(e1, e2) ->
      insert_let (g env e1)
	(fun x -> insert_let (g env e2)
	    (fun y -> SLL(x, y), Type.Int))
  | Syntax.FNeg(e) ->
      insert_let (g env e)
	(fun x -> FNeg(x), Type.Float)
  | Syntax.FAdd(e1, e2) ->
      insert_let (g env e1)
	(fun x -> insert_let (g env e2)
	    (fun y -> FAdd(x, y), Type.Float))
  | Syntax.FSub(e1, e2) ->
      insert_let (g env e1)
	(fun x -> insert_let (g env e2)
	    (fun y -> FSub(x, y), Type.Float))
  | Syntax.FMul(e1, e2) ->
      insert_let (g env e1)
	(fun x -> insert_let (g env e2)
	    (fun y -> FMul(x, y), Type.Float))
  | Syntax.FDiv(e1, e2) ->
      insert_let (g env e1)
	(fun x -> insert_let (g env e2)
	    (fun y -> FDiv(x, y), Type.Float))
  | Syntax.Eq _ | Syntax.LE _ as cmp ->
      g env (Syntax.If((cmp, line), (Syntax.Bool(true), line), (Syntax.Bool(false), line)), line)
  | Syntax.If((Syntax.Not(e1), _), e2, e3) -> g env (Syntax.If(e1, e3, e2), line) (* notによる分岐を変換 (caml2html: knormal_not) *)

  | Syntax.If((Syntax.Eq(e1, e2), _), e3, e4) ->
	let e1', t1 = g env e1 in
	let e2', t2 = g env e2 in
	let e3', t3 = g env e3 in
	let e4', t4 = g env e4 in
  	(match e1', e2' with
	| Int m, Int n when -1 <= m && m <= 1 && -1 <= n && n <= 1 -> if m = n then (e3', t3) else (e4', t4)
	| Int m, e2' when -1 <= m && m <= 1 -> insert_let (e2', t2) (fun y -> IfEq (C m, V y, e3', e4'), t3)
	| e1', Int n when -1 <= n && n <= 1 -> insert_let (e1', t1) (fun y -> IfEq (C n, V y, e3', e4'), t3)
	| e1', e2' ->
		insert_let (e1', t1)
			(fun x -> insert_let (e2', t2)
				(fun y -> IfEq(V x, V y, e3', e4'), t3))
	)

  | Syntax.If((Syntax.LE(e1, e2), _), e3, e4) ->
	let e1', t1 = g env e1 in
	let e2', t2 = g env e2 in
	let e3', t3 = g env e3 in
	let e4', t4 = g env e4 in
  	(match e1', e2' with
	| Int m, Int n when -1 <= m && m <= 1 && -1 <= n && n <= 1 -> if m <= n then (e3', t3) else (e4', t4)
	| Int m, e2' when -1 <= m && m <= 1 -> insert_let (e2', t2) (fun y -> IfLE (C m, V y, e3', e4'), t3)
	| e1', Int n when -1 <= n && n <= 1 -> insert_let (e1', t1) (fun x -> IfLE (V x, C n, e3', e4'), t3)
	| e1', e2' ->
		insert_let (e1', t1)
			(fun x -> insert_let (e2', t2)
				(fun y -> IfLE(V x, V y, e3', e4'), t3))
	)
  | Syntax.If(e1, e2, e3) -> g env (Syntax.If((Syntax.Eq(e1, (Syntax.Bool(false), line)), line), e3, e2), line) (* 比較のない分岐を変換 (caml2html: knormal_if) *)
  | Syntax.Let((x, t), e1, e2) ->
      let e1', t1 = g env e1 in
      let e2', t2 = g (M.add x t env) e2 in
      Let((x, t), e1', e2'), t2
  | Syntax.Var(x) when M.mem x env -> Var(x), M.find x env
  | Syntax.Var(x) -> (* 外部配列の参照 (caml2html: knormal_extarray) *)
      (match M.find x !Typing.extenv with
      | Type.Array(_) as t -> ExtArray x, t
      | _ -> failwith (Printf.sprintf "external variable %s does not have an array type" x))
  | Syntax.LetRec({ Syntax.name = (x, t); Syntax.args = yts; Syntax.body = e1 }, e2) ->
      let env' = M.add x t env in
      let e2', t2 = g env' e2 in
      let e1', t1 = g (M.add_list yts env') e1 in
      LetRec({ name = (x, t); args = yts; body = e1' }, e2'), t2
  | Syntax.App((Syntax.Var(f), _), e2s) when not (M.mem f env) -> (* 外部関数の呼び出し (caml2html: knormal_extfunapp) *)
      (match M.find f !Typing.extenv with
      | Type.Fun(_, t) ->
	  let rec bind xs = function (* "xs" are identifiers for the arguments *)
	    | [] -> ExtFunApp(f, xs), t
	    | e2 :: e2s ->
		insert_let (g env e2)
		  (fun x -> bind (xs @ [x]) e2s) in
	  bind [] e2s (* left-to-right evaluation *)
      | _ -> assert false)
  | Syntax.App(e1, e2s) ->
      (match g env e1 with
      | _, Type.Fun(_, t) as g_e1 ->
	  insert_let g_e1
	    (fun f ->
	      let rec bind xs = function (* "xs" are identifiers for the arguments *)
		| [] -> App(f, xs), t
		| e2 :: e2s ->
		    insert_let (g env e2)
		      (fun x -> bind (xs @ [x]) e2s) in
	      bind [] e2s) (* left-to-right evaluation *)
      | _ -> assert false)
  | Syntax.Tuple(es) ->
      let rec bind xs ts = function (* "xs" and "ts" are identifiers and types for the elements *)
	| [] -> Tuple(xs), Type.Tuple(ts)
	| e :: es ->
	    let _, t as g_e = g env e in
	    insert_let g_e
	      (fun x -> bind (xs @ [x]) (ts @ [t]) es) in
      bind [] [] es
  | Syntax.LetTuple(xts, e1, e2) ->
      insert_let (g env e1)
	(fun y ->
	  let e2', t2 = g (M.add_list xts env) e2 in
	  LetTuple(xts, y, e2'), t2)
  | Syntax.Array(e1, e2) ->
      insert_let (g env e1)
	(fun x ->
	  let _, t2 as g_e2 = g env e2 in
	  insert_let g_e2
	    (fun y ->
	      let l =
		match t2 with
		| Type.Float -> "create_float_array"
		| _ -> "create_array" in
	      ExtFunApp(l, [x; y]), Type.Array(t2)))
  | Syntax.Get(e1, e2) ->
      (match g env e1 with
      |	_, Type.Array(t) as g_e1 ->
	  insert_let g_e1
	    (fun x -> insert_let (g env e2)
		(fun y -> Get(x, y), t))
      | _ -> assert false)
  | Syntax.Put(e1, e2, e3) ->
      insert_let (g env e1)
	(fun x -> insert_let (g env e2)
	    (fun y -> insert_let (g env e3)
		(fun z -> Put(x, y, z), Type.Unit)))

(* kNortmal.tをいいかんじに出力 *)
let indent = Global.indent
let rec print n = function
	| Unit ->
		begin
			indent n;
			print_endline "()"
		end
	| Int i ->
		begin
			indent n;
			Printf.printf "%d\n" i
		end
	| Float f ->
		begin
			indent n;
			Printf.printf "%f\n" f
		end
	| Neg id ->
		begin
			indent n;
			Printf.printf "-%s\n" id
		end
	| Add (id1, id2) ->
		begin
			indent n;
			Printf.printf "%s + %s\n" id1 id2
		end
	| Sub (id1, id2) ->
		begin
			indent n;
			Printf.printf "%s - %s\n" id1 id2
		end
	| Mul (id1, id2) ->
		begin
			indent n;
			Printf.printf "%s * %s\n" id1 id2
		end
	| Div (id1, id2) ->
		begin
			indent n;
			Printf.printf "%s / %s\n" id1 id2
		end
	| SLL (id1, id2) ->
		begin
			indent n;
			Printf.printf "%s << %s\n" id1 id2
		end
	| FNeg id ->
		begin
			indent n;
			Printf.printf "-.%s\n" id
		end
	| FAdd (id1, id2) ->
		begin
			indent n;
			Printf.printf "%s +. %s\n" id1 id2
		end
	| FSub (id1, id2) ->
		begin
			indent n;
			Printf.printf "%s -. %s\n" id1 id2
		end
	| FMul (id1, id2) ->
		begin
			indent n;
			Printf.printf "%s *. %s\n" id1 id2
		end
	| FDiv (id1, id2) ->
		begin
			indent n;
			Printf.printf "%s /. %s\n" id1 id2
		end
	| IfEq (id1, id2, then_exp, else_exp) ->
		begin
			indent n;
			let id1 = pp_id_or_imm id1 in
			let id2 = pp_id_or_imm id2 in
			Printf.printf "if %s = %s then\n" id1 id2;
			print (n + 1) then_exp;
			indent n;
			Printf.printf "else\n";
			print (n + 1) else_exp;
		end
	| IfLE (id1, id2, then_exp, else_exp) ->
		begin
			indent n;
			let id1 = pp_id_or_imm id1 in
			let id2 = pp_id_or_imm id2 in
			Printf.printf "if %s <= %s then\n" id1 id2;
			print (n + 1) then_exp;
			indent n;
			Printf.printf "else\n";
			print (n + 1) else_exp;
		end
	| Let ((id, typ), e1, e2) ->
		begin
			indent n;
			Printf.printf "let %s : %s =\n" id (Type.string_of_type typ);
			print (n + 1) e1;
			indent n;
			Printf.printf "in\n";
			print n e2;
		end
	| Var id ->
		begin
			indent n;
			Printf.printf "%s\n" id;
		end
	| LetRec (f, e) ->
		begin
			indent n;
			Printf.printf "let rec %s : %s ( " (fst f.name) (Type.string_of_type (snd f.name));
			List.iter (fun x -> Printf.printf "%s " (fst x)) f.args;
			Printf.printf ") =\n";
			print (n + 1) f.body;
			indent n;
			Printf.printf "in\n";
			print n e;
		end
	| App (fn, args) ->
		begin
			indent n;
			Printf.printf "%s " fn;
			List.iter (fun x -> Printf.printf "%s " x) args;
			Printf.printf "\n";
		end
	| Tuple elems ->
		begin
			indent n;
			Printf.printf "(";
			List.iter (fun x -> Printf.printf "%s, " x) elems;
			Printf.printf ")\n";
		end
	| LetTuple (elems, tpl, e) ->
		begin
			let len = List.length elems in
			let cnt = ref 1 in
			indent n;
			Printf.printf "let (";
			List.iter (fun x -> Printf.printf "%s : %s" (fst x) (Type.string_of_type (snd x)); cnt := !cnt + 1; if !cnt < len then print_string ", ") elems;
			Printf.printf ") = %s\n" tpl;
			indent n;
			Printf.printf "in\n";
			print n e
		end
	| Get (ar, idx) ->
		begin
			indent n;
			Printf.printf "%s.(%s)" ar idx
		end
	| Put (ar, idx, value) ->
		begin
			indent n;
			Printf.printf "%s.(%s) <- %s" ar idx value
		end
	| ExtArray id ->
		begin
			indent n;
			Printf.printf "%s\n" id
		end
	| ExtFunApp (fn, args) ->
		begin
			indent n;
			Printf.printf "%s " fn;
			List.iter (fun x -> Printf.printf "%s " x) args;
			Printf.printf "\n";
		end

(*let f e = fst (g M.empty e)*)

let f flg e = 
	begin
(*		if flg then
			begin
				print_endline "Print Syntax_t(kNormal.ml):";
				Syntax.print 1 e;
				print_newline ();
				flush stdout;
			end;*)
		let ans = fst (g M.empty e) in
		if flg then
			begin
				print_endline "Print KNormal_t(kNormal.ml):";
				print 1 ans;
				print_newline ();
				flush stdout;
			end;
		ans
	end
