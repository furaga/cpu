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
let rec mul10 x = x * 8 + x * 2 in

let rec read_int _ =
	let ans = Array.create 1 0 in
	let s = Array.create 1 0 in
	let rec read_token in_token prev =
		let c = input_char () in
		let flg = 
			if c < 48 then true
			else if c > 57 then true
			else false in
		if flg then
			(if in_token then (if s.(0) = 1 then ans.(0) else (-ans.(0))) else read_token false c)
		else
			((if s.(0) = 0 then
				(* prev == '-' *)
				(if prev = 45 then s.(0) <- (-1) else s.(0) <- (1));
			else
				());
			ans.(0) <- mul10 ans.(0) + (c - 48);
			read_token true c) in
	read_token false 32 in

let rec read_float _ =
	let i = Array.create 1 0 in
	let f = Array.create 1 0 in
	let exp = Array.create 1 1 in
	let s = Array.create 1 0 in
	let rec read_token1 in_token prev =
		let c = input_char () in
		let flg =
			if c < 48 then true
			else if c > 57 then true
			else false in
		if flg then
			(if in_token then c else read_token1 false c)
		else
			((if s.(0) = 0 then
				(* prev == '-' *)
				(if prev = 45 then s.(0) <- (-1) else s.(0) <- (1));
			else
				());
			i.(0) <- mul10 i.(0) + (c - 48);
			read_token1 true c) in
	let rec read_token2 in_token =
		let c = input_char () in
		let flg =
			if c < 48 then true
			else if c > 57 then true
			else false in
		if flg then
			(if in_token then () else read_token2 false)
		else
			(f.(0) <- mul10 f.(0) + (c - 48);
			exp.(0) <- mul10 exp.(0);
			read_token2 true) in

	let nextch = read_token1 false 32 in
	let ans =
		if nextch = 46 then (* nextch = '.' *)
			(read_token2 false;
			(float_of_int i.(0)) +. (float_of_int f.(0)) /. (float_of_int exp.(0)))
		else
			float_of_int i.(0) in
	if s.(0) = 1 then 
		ans
	else
		-. ans in

(* read_float, read_int はib_asm.sで定義 *)
(*

val print_char : int -> unit
val print_int : int -> unit

*)
