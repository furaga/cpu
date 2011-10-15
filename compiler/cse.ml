(* 共通部分式除去（Common subexpression elimination, CSE）*)

open KNormal

(* KNormal.tがキーとなるマップ *)
module CM = 
	Map.Make (
		struct
			type t = KNormal.t
			let compare = compare
		end)
include CM
	
let find key env = try CM.find key env with Not_found -> key

let rec g env e =
	match e with
	| Neg _ | Add _ | Sub _ | FNeg _ | FAdd _ | FSub _ | FMul _ | FDiv _ | Var _ | Tuple _ -> find e env
	| IfEq (x, y, e1, e2) -> IfEq (x, y, g env e1, g env e2)
	| IfLE (x, y, e1, e2) -> IfLE (x, y, g env e1, g env e2)
	| Let ((x, t), e1, e2) ->
		let e'1 = g env e1 in
		let new_env = CM.add e'1 (Var x) env in 
		let e'2 = g new_env e2 in
		Let ((x, t), e'1, e'2)
	| LetRec({name = nm; args = ag; body = e1}, e2) ->
		LetRec({name = nm; args = ag; body = g CM.empty e1}, g env e2)
	| _ -> e

let f flg e =
	let ans = g CM.empty e in
	if flg then
		begin
			print_endline "Print KNormal.t (Cse.ml)";
			KNormal.print 1 ans;
			print_newline ();
		end;
	ans
