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
let cordic_n = 25 in
let sqrt_n = 50 in
let pi = 3.14159265358979 in
let pi2 = 6.28318530717958 in
let pih = 1.570796326794895 in
let r = 0.607252935008881778 in
let rec cordic_sin a =
  let rec cordic_rec i x y z p =
    if i = cordic_n then y
    else
      if a > z then
	cordic_rec (i + 1) (x -. p *. y) (y +. p *. x) (z +. atan_table.(i)) (p *. 0.5)
      else
	cordic_rec (i + 1) (x +. p *. y) (y -. p *. x) (z -. atan_table.(i)) (p *. 0.5)
  in cordic_rec 0 r 0.0 0.0 1.0
in
let rec cordic_cos a =
  let rec cordic_rec i x y z p =
    if i = cordic_n then x
    else
      if a > z then
	cordic_rec (i + 1) (x -. p *. y) (y +. p *. x) (z +. atan_table.(i)) (p *. 0.5)
      else
	cordic_rec (i + 1) (x +. p *. y) (y -. p *. x) (z -. atan_table.(i)) (p *. 0.5)
  in cordic_rec 0 r 0.0 0.0 1.0
in
let rec cordic_atan a =
  let rec cordic_rec i x y z p =
    if i = cordic_n then z
    else
      if y > 0.0 then
	cordic_rec (i + 1) (x +. p *. y) (y -. p *. x) (z +. atan_table.(i)) (p *. 0.5)
      else
	cordic_rec (i + 1) (x -. p *. y) (y +. p *. x) (z -. atan_table.(i)) (p *. 0.5)
  in cordic_rec 0 1.0 a 0.0 1.0
in
let rec sin a =
  if a < 0.0 then -. sin (-. a)
  else if a < pih then cordic_sin a
  else if a < pi then cordic_sin (pi -. a)
  else if a < pi2 then -. sin (pi2 -. a)
  else sin (a -. pi2)
in
let rec cos a =
  if a < 0.0 then cos (-. a)
  else if a < pih then cordic_cos a
  else if a < pi then -. cordic_cos (pi -. a)
  else if a < pi2 then cos (pi2 -. a)
  else cos (a -. pi2)
in
(*
let rec sin a =
  if a < 0.0 then sin (a -. (floor (a /. pi2)) *. pi2)
  else if a < pih then cordic_sin a
  else if a < pi then cordic_sin (pi -. a)
  else if a < pi2 then -. sin (pi2 -. a)
  else sin (a -. (floor (a /. pi2)) *. pi2)
in
let rec cos a =
  if a < 0.0 then cos (a -. (floor (a /. pi2)) *. pi2)
  else if a < pih then cordic_cos a
  else if a < pi then -. cordic_cos (pi -. a)
  else if a < pi2 then cos (pi2 -. a)
  else cos (a -. (floor (a /. pi2)) *. pi2)
in
*)

let rec atan a =
  cordic_atan a
in
let rec get_sqrt_init a =
  let rec get_sqrt_init_rec a m =
	if m = sqrt_n - 1 then rsqrt_table.(m)
	else if a < 2.0 then rsqrt_table.(m)
    else get_sqrt_init_rec (a /. 2.0) (m + 1)
  in get_sqrt_init_rec a 0
in
let rec sqrt a =
  if a < 1.0 then
    let x = a in
      let x = 0.5 *. (x +. a /. x) in
      let x = 0.5 *. (x +. a /. x) in
      let x = 0.5 *. (x +. a /. x) in
      let x = 0.5 *. (x +. a /. x) in
      let x = 0.5 *. (x +. a /. x) in
      let x = 0.5 *. (x +. a /. x) in
      let x = 0.5 *. (x +. a /. x) in
      let x = 0.5 *. (x +. a /. x) in
      let x = 0.5 *. (x +. a /. x) in
      let x = 0.5 *. (x +. a /. x) in
	x
  else
    let x = get_sqrt_init a in
    let x = 0.5 *. x *. (3.0 -. a *. x *. x) in
    let x = 0.5 *. x *. (3.0 -. a *. x *. x) in
    let x = 0.5 *. x *. (3.0 -. a *. x *. x) in
    let x = 0.5 *. x *. (3.0 -. a *. x *. x) in
    let x = 0.5 *. x *. (3.0 -. a *. x *. x) in
    let x = 0.5 *. x *. (3.0 -. a *. x *. x) in
    let x = 0.5 *. x *. (3.0 -. a *. x *. x) in
    let x = 0.5 *. x *. (3.0 -. a *. x *. x) in
    let x = 0.5 *. x *. (3.0 -. a *. x *. x) in
    let x = 0.5 *. x *. (3.0 -. a *. x *. x) in
      x *. a
in

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
