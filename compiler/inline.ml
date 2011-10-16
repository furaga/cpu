(*open KNormal

(* インライン展開する関数の最大サイズ (caml2html: inline_threshold) *)
let threshold = ref 0 (* Mainで-inlineオプションによりセットされる *)

let rec size = function
  | IfEq(_, _, e1, e2) | IfLE(_, _, e1, e2)
  | Let(_, e1, e2) | LetRec({ body = e1 }, e2) -> 1 + size e1 + size e2
  | LetTuple(_, _, e) -> 1 + size e
  | _ -> 1

let rec g env = function (* インライン展開ルーチン本体 (caml2html: inline_g) *)
  | IfEq(x, y, e1, e2) -> IfEq(x, y, g env e1, g env e2)
  | IfLE(x, y, e1, e2) -> IfLE(x, y, g env e1, g env e2)
  | Let(xt, e1, e2) -> Let(xt, g env e1, g env e2)
  | LetRec({ name = (x, t); args = yts; body = e1 }, e2) -> (* 関数定義の場合 (caml2html: inline_letrec) *)
      let env = if size e1 > !threshold then env else M.add x (yts, e1) env in
      LetRec({ name = (x, t); args = yts; body = g env e1}, g env e2)
  | App(x, ys) when M.mem x env -> (* 関数適用の場合 (caml2html: inline_app) *)
      let (zs, e) = M.find x env in
      Format.eprintf "inlining %s@." x;
      let env' =
	List.fold_left2
	  (fun env' (z, t) y -> M.add z y env')
	  M.empty
	  zs
	  ys in
      Alpha.g env' e
  | LetTuple(xts, y, e) -> LetTuple(xts, y, g env e)
  | e -> e

let f e = g M.empty e
*)

open KNormal

let threshold = ref 0

let noInline = ["write"; "read_int"; "read_float"; "create_array_int"; "create_array_float"]

let counts = ref M.empty

let rec count = function
  | IfEq(_, _, e1, e2) | IfLE(_, _, e1, e2) | Let(_, e1, e2) ->
      count e1;
      count e2
  | LetRec({ body = e1 }, e2) ->
     	count e1;
      count e2
  | LetTuple(_, _, e) ->
      count e
  | App(x, _) ->
      let n = try M.find x !counts with Not_found -> 0 in
      counts := M.add x (n + 1) !counts
  | _ -> ()

let rec size = function
  | IfEq(_, _, e1, e2) | IfLE(_, _, e1, e2) | Let(_, e1, e2) | LetRec({ body = e1 }, e2) ->
      1 + size e1 + size e2
  | LetTuple(_, _, e) -> 1 + size e
  | ExtFunApp(x, _) when x = "sqrt" || x = "fabs" -> 1
  | App _ | ExtFunApp _ -> 30
  | _ -> 1

let rec hasIO io = function
  | IfEq(_, _, e1, e2) | IfLE(_, _, e1, e2) | Let(_, e1, e2) | LetRec({ body = e1 }, e2) ->
      hasIO io e1 || hasIO io e2
  | LetTuple(_, _, e) -> hasIO io e
  | ExtFunApp(x, _) when List.mem x noInline -> true
  | App(x, _) -> S.mem x io
  | _ -> false

let rec seq dest e1 e2 =
  match e1 with
    | Let(xt, e1', e2') -> Let(xt, e1', seq dest e2' e2)
    | LetRec(f, e2') -> LetRec(f, seq dest e2' e2)
    | LetTuple(xts, y, e2') -> LetTuple(xts, y, seq dest e2' e2)
    | e -> Let(dest, e, e2)

let rec g io env = function
  | IfEq(x, y, e1, e2) -> IfEq(x, y, g io env e1, g io env e2)
  | IfLE(x, y, e1, e2) -> IfLE(x, y, g io env e1, g io env e2)
  | Let(xt, e1, e2) -> Let(xt, g io env e1, g io env e2)
  | LetRec({ name = (x, t); args = yts; body = e1 }, e2) ->
      let io = if hasIO io e1 then S.add x io else io in
      let e1 = g io env e1 in
      let count = try M.find x !counts with Not_found -> 100 in
      let inline =
        if !threshold = 0 then false
        else if count = 1 then true
        else (not (hasIO io e1)) && size e1 < !threshold * (if S.mem x (fv e1) then 1 else 5) in
      let env =
        if inline then M.add x (yts, e1) env
        else env in
      let e1 = if S.mem x (fv e1) && inline then g io env e1 else e1 in
      LetRec({ name = (x, t); args = yts; body = e1}, g io env e2)
  | App(x, ys) when M.mem x env ->
      let (zs, e) = M.find x env in
(*      Format.eprintf "inlining %s@." x;*)
      let env' = List.fold_left2
        (fun env' (z, t) y -> M.add z y env'
        ) M.empty zs ys in
      Alpha.g env' e
  | LetTuple(xts, y, e) -> LetTuple(xts, y, g io env e)
  | e -> e

let f e =
  (
	  Format.eprintf "Before: %d@." (size e);
	  counts := M.empty;
	  count e;
	  let e = g S.empty M.empty e in
	  Format.eprintf "After : %d@." (size e);
	  e
  )
