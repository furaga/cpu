(* 浮動小数基本演算1 *)
let rec fequal a b = a = b in
let rec fless a b = (a < b) in

let rec fispos a = (a > 0.0) in
let rec fisneg a = (a < 0.0) in
let rec fiszero a = (a = 0.0) in

(* bool系 *)
let rec xor a b = a <> b in

(* 浮動小数基本演算2 *)
let rec fabs a =
	if a < 0.0 then -. a
	else a
in
let rec fneg a = -. a in
let rec fhalf a = a /. 2.0 in
let rec fsqr a = a *. a in

(* sqrt, floor, int_of_float, float_of_int はlib_asm.sで定義 *)

(* 算術関数 *)
let pi = 3.14159265358979323846264 in
let pi2 = pi *. 2.0 in
let pih = pi *. 0.5 in

(* atan *)
let rec atan x =
	let sgn =
		if x > 1.0 then 1
		else if x < -1.0 then -1
		else 0
	in
	let x =
		if (fabs x) > 1.0 then 1.0 /. x
		else x
	in
	let rec atan_sub i xx y =
		if i < 0.5 then y
		else atan_sub (i -. 1.0) xx ((i *. i *. xx) /. (2.0 *. i +. 1.0 +. y))
	in
	let a = atan_sub 11.0 (x *. x) 0.0 in
	let b = x /. (1.0 +. a) in
	if sgn > 0 then pi /. 2.0 -. b
	else if sgn < 0 then -. pi /. 2.0 -. b
	else b
	in


(* sin *)
let rec sin x =
	(* tan *)
	let rec tan x = (* -pi/4 <= x <= pi/4 *)
		let rec tan_sub i xx y =
			if i < 2.5 then y
				else tan_sub (i -. 2.) xx (xx /. (i -. y))
		in
		x /. (1. -. (tan_sub 9. (x *. x) 0.0))
	in
	let s1 = if x > 0.0 then true else false in
	let x0 = fabs x in
	let rec tmp x = 
		if x > pi2 then tmp (x -. pi2)
		else if x < 0.0 then tmp (x +. pi2)
		else x in
	let x1 = tmp x0 in
	let s2 = if x1 > pi then not s1 else s1 in
	let x2 = if x1 > pi then pi2 -. x1 else x1 in
	let x3 = if x2 > pih then pi -. x2 else x2 in
	let t = tan (x3 *. 0.5) in
	let ans = 2. *. t /. (1. +. t *. t) in
	if s2 then ans else fneg ans
	in

(* cos *)
let rec cos x = sin (1.570796326794895 -. x) in

(* create_array系はコンパイル時にコードを生成。compiler/emit.ml参照 *)

let rec read_int _ =
	let ans = 0 in
	let rec read_token in_token =
		let c = read_char () in
		let flg = 
			if c = 9 then true		(* \t *)
			else if c = 10 then true			(* \n *)
			else if c = 13 then true			(* \r *)
			else if c = 32 then true			(* ' ' *)
			else false in
		if flg then
			(if in_token then () else read_token false)
		else
			
	
(*
let rec read_token in_token =
  try
    let c = input_char stdin (* chan *) in
    match c with
      ' ' | '\t' | '\r' | '\n' ->
	if in_token then ()
	else read_token false
    | _ ->
	Buffer.add_char buf c;
	read_token true
  with
    End_of_file ->
      if in_token then () else raise End_of_file

let read_float () = 
  Buffer.clear buf;
  read_token false;
  try
    float_of_string (Buffer.contents buf)
  with
    Failure _ -> failwith ((Buffer.contents buf) ^ ": float conversion failed.")

let read_int () = 
  Buffer.clear buf;
  read_token false;
  try
    int_of_string (Buffer.contents buf)
  with
    Failure _ -> failwith ((Buffer.contents buf) ^ ": int conversion failed.")


*)

(* read_float, read_int はib_asm.sで定義 *)
(*

val print_char : int -> unit
val print_int : int -> unit

*)
