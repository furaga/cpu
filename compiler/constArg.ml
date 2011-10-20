(* 読め *)

open KNormal

type arg =
  | First
  | Const of t
  | Many
  | None

let constArgs = ref M.empty

let str = function
  | Int(i) -> string_of_int i
  | Float(f) -> string_of_float f
  | ExtArray(a) -> a
  | _ -> assert false

let mem x env =
  try (match M.find x env with Int(_) | Float(_) | ExtArray(_) -> true | _ -> false)
  with Not_found -> false

let rec checkArgs func i a = function
  | IfEq(x, y, e1, e2) | IfLE(x, y, e1, e2) ->
      x = a || y = a || (checkArgs func i a e1) || (checkArgs func i a e2)
  | Let(_, e1, e2) ->
      (checkArgs func i a e1) || (checkArgs func i a e2)
  | App(x, ys) when x = func ->
      let (_, b) = List.fold_left (fun (j, b) y -> (j + 1, b || (i <> j && y = a))) (0, false) ys in
      b
  | LetTuple(_, y, e) ->
      y = a || (checkArgs func i a e)
  | e -> S.mem a (fv e)

let rec setConstArgs env = function
  | IfEq(_, _, e1, e2) | IfLE(_, _, e1, e2) ->
      setConstArgs env e1;
      setConstArgs env e2
  | Let((x, t), e1, e2) ->
      setConstArgs env e1;
      setConstArgs (M.add x e1 env) e2
  | LetRec({ name = (x, _); args = ys; body = e1 }, e2) ->
      let zs = fv e1 in
      let (_, args) = List.fold_left
        (fun (i, args) (y, _) ->
          (i + 1, if S.mem y zs && checkArgs x i y e1 then args @ [First] else args @ [None]))
          (0, []) ys in
      constArgs := M.add x args !constArgs;
      setConstArgs env e1;
      setConstArgs env e2
  | App(x, ys) ->
      let zs = M.find x !constArgs in
      let zs = List.map2
                 (fun y -> function
                    | None -> None
                    | First when mem y env -> Const(M.find y env)
                    | Const(v) as c when mem y env && v = M.find y env -> c
                    | _ -> Many
                 ) ys zs in
      constArgs := M.add x zs !constArgs
  | LetTuple(_, _, e) ->
      setConstArgs env e
  | _ -> ()

let rec g = function
  | IfEq(x, y, e1, e2) -> IfEq(x, y, g e1, g e2)
  | IfLE(x, y, e1, e2) -> IfLE(x, y, g e1, g e2)
  | Let((x, t), e1, e2) -> Let((x, t), g e1, g e2)
  | LetRec({ name = (x, Type.Fun(ts, t)); args = ys; body = e1 }, e2) ->
      let (ys', e1') = List.fold_right2
                 (fun y z (ys, e) ->
                    match z with
                      | Const(v) -> (Format.eprintf "Const: %s->%s=%s@." x (fst y) (str v); (ys, Let(y, v, e)))
                      | None -> (Format.eprintf "None: %s->%s@." x (fst y); (ys, e))
                      | _ -> (y :: ys, e))
                 ys (M.find x !constArgs) ([], e1) in
      (*if ys' <> ys then Format.eprintf "%s@." (Type.string_of_t (Type.Fun(List.map snd ys', t)));*)
      LetRec({ name = (x, Type.Fun(List.map snd ys', t)); args = ys'; body = g e1' }, g e2)
  | App(x, ys) ->
      App(x, List.fold_right2 (fun y z ys -> match z with Const _ | None -> ys | _ -> y :: ys) ys (M.find x !constArgs) [])
  | LetTuple(xts, y, e) -> LetTuple(xts, y, g e)
  | e -> e

let f flg e =
	(
	  constArgs := M.empty;
	  setConstArgs M.empty e;
	  g e
  )
