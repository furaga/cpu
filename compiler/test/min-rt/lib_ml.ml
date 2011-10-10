(* 浮動小数基本演算 *)
let rec fless a b = (a < b) in
let rec fispos a = (a > 0.0) in
let rec fisneg a = (a < 0.0) in
let rec fiszero a = (a = 0.0) in
let rec fhalf a = a /. 2.0 in
let rec fsqr a = a *. a in
let rec fabs a =
	if a < 0.0 then -. a
	else a
in
let rec fneg a = -. a in

(* 算術関数 *)
let pi = 3.14159265358979323846264 in
let pi2 = pi *. 2.0 in
let pih = pi *. 0.5 in

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

let rec tan x = (* -pi/4 <= x <= pi/4 *)
	let rec tan_sub i xx y =
		if i < 2.5 then y
			else tan_sub (i -. 2.) xx (xx /. (i -. y))
	in
	x /. (1. -. (tan_sub 9. (x *. x) 0.0))
in
let rec sin x =
	let s1 = if x > 0.0 then true else false in
	let x0 = fabs x in
	(* TODO*)
	let rec tmp x = 
		if x > pi2 then tmp (x -. pi2)
		else if x < 0.0 then tmp (x +. pi2)
		else x in
	let x1 = tmp x0 in
(*	let x1 = x0 -. pi2 *. (floor (x0 /. pi2)) in*)
	let s2 = if x1 > pi then not s1 else s1 in
	let x2 = if x1 > pi then pi2 -. x1 else x1 in
	let x3 = if x2 > pih then pi -. x2 else x2 in
	let t = tan (x3 *. 0.5) in
	let ans = 2. *. t /. (1. +. t *. t) in
	if s2 then ans else fneg ans
	in

let rec cos x = sin (1.570796326794895 -. x) in

(* 入出力 *)
(* いらなくなったテキスト形式 *)
let rec read_int_text _ =
	let rec mul_10 n = (n * 8) + (n * 2) in
	let rec skip _ =
		let c = read () in
		if c = 45 then c
		else if c < 48 then skip ()
		else if c >= 58 then skip ()
		else c
	in
	let rec read_rec n =
		let c = (read ()) - 48 in
		if c < 0 then n
		else if c >= 10 then n
		else read_rec ((mul_10 n) + c)
	in
	let c = skip () in
	if c = 45 then -(read_rec 0)
	else read_rec (c - 48)
in
let rec read_float_text _ =
	let rec skip _ =
		let c = read () in
		if c = 45 then c
		else if c < 48 then skip ()
		else if c >= 58 then skip ()
		else c
	in
	let rec read_rec2 mul =
		let c = (read ()) - 48 in
		if c < 0 then 0.0
		else if c >= 10 then 0.0
		else (float_of_int c) *. mul +. (read_rec2 (mul *. 0.1))
	in
	let rec read_rec1 n =
		let c = (read ()) - 48 in
		if c = -2 then n +. (read_rec2 0.1)
		else if c < 0 then n
		else if c >= 10 then n
		else read_rec1 (n *. 10.0 +. (float_of_int c))
	in
	let c = skip () in
	if c = 45 then -.(read_rec1 0.0)
	else read_rec1 (float_of_int (c - 48))
in
