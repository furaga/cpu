(* グローバル変数（トップレベルのlet式で定義された変数）の集合を取得してenvに入れる *)

open KNormal

let env = ref M.empty

let rec g = function
  | Let((x, t), _, e2) ->
  	  let ch = int_of_char x.[0] in
  	  (if int_of_char 'a' <= ch && ch <= int_of_char 'z' then env := M.add x t !env);
      g e2
  | LetRec(_, e2) ->
      g e2
  | LetTuple(xts, _, e) ->
      List.iter (fun (x, t) -> env := M.add x t !env) xts;
	  g e
  | _ -> ()

let f e =
	g e;
	print_string "globalEnv.env(globalEnv.ml) = \n\t";
	M.iter (fun x y -> Printf.printf "%s " x) !env;
	print_newline ();
	print_newline ();
	e
