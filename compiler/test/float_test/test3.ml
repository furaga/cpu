(* 浮動小数基本演算 *)
let rec fabs a =
	if a < 0.0 then -. a
	else a
in
let rec fneg a = -. a in

let rec atan x =
	let pi = 3.14159265358979323846264 in
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
	
print_float (atan 1.0);
print_float (atan (-. 1.0));

let pi = 3.14159265358979323846264 in
let pi2 = pi *. 2.0 in
let pih = pi *. 0.5 in
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



print_float (sin 0.0);
print_float (sin (pih /. 3.0));
print_float (sin (pih /. 2.0));
print_float (sin (pi /. 3.0));
print_float (sin pih);
print_float (sin (pih +. pih /. 3.0));
print_float (sin (pih +. pih /. 2.0));
print_float (sin (pih +. pi /. 3.0));
print_float (sin pi);
print_float (sin (pi +. pih /. 3.0));
print_float (sin (pi +. pih /. 2.0));
print_float (sin (pi +. pi /. 3.0));
print_float (sin (3.0 *. pih));
print_float (sin (3.0 *. pih +. pih /. 3.0));
print_float (sin (3.0 *. pih +. pih /. 2.0));
print_float (sin (3.0 *. pih +. pi /. 3.0));
print_float (sin pi2);

print_float (cos 0.0);
print_float (cos (pih /. 3.0));
print_float (cos (pih /. 2.0));
print_float (cos (pi /. 3.0));
print_float (cos pih);
print_float (cos (pih +. pih /. 3.0));
print_float (cos (pih +. pih /. 2.0));
print_float (cos (pih +. pi /. 3.0));
print_float (cos pi);
print_float (cos (pi +. pih /. 3.0));
print_float (cos (pi +. pih /. 2.0));
print_float (cos (pi +. pi /. 3.0));
print_float (cos (3.0 *. pih));
print_float (cos (3.0 *. pih +. pih /. 3.0));
print_float (cos (3.0 *. pih +. pih /. 2.0));
print_float (cos (3.0 *. pih +. pi /. 3.0));
print_float (cos pi2)
