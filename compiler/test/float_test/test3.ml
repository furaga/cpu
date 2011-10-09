(* 算術関数 *)
let atan_table = create_array 25 0.0 in
atan_table.(0) <- 0.785398163397448279;
atan_table.(1) <- 0.463647609000806094;
atan_table.(2) <- 0.244978663126864143;
atan_table.(3) <- 0.124354994546761438;
atan_table.(4) <- 0.06241880999595735;
atan_table.(5) <- 0.0312398334302682774;
atan_table.(6) <- 0.0156237286204768313;
atan_table.(7) <- 0.00781234106010111114;
atan_table.(8) <- 0.00390623013196697176;
atan_table.(9) <- 0.00195312251647881876;
atan_table.(10) <- 0.000976562189559319459;
atan_table.(11) <- 0.00048828121119489829;
atan_table.(12) <- 0.000244140620149361771;
atan_table.(13) <- 0.000122070311893670208;
atan_table.(14) <- 6.10351561742087726 *. 0.00001;
atan_table.(15) <- 3.05175781155260957 *. 0.00001;
atan_table.(16) <- 1.52587890613157615 *. 0.00001;
atan_table.(17) <- 7.62939453110197 *. 0.000001;
atan_table.(18) <- 3.81469726560649614 *. 0.000001;
atan_table.(19) <- 1.90734863281018696 *. 0.000001;
atan_table.(20) <- 9.53674316405960844 *. 0.0000001;
atan_table.(21) <- 4.76837158203088842 *. 0.0000001;
atan_table.(22) <- 2.38418579101557974 *. 0.0000001;
atan_table.(23) <- 1.19209289550780681 *. 0.0000001;
atan_table.(24) <- 5.96046447753905522 *. 0.00000001;
(*
let rsqrt_table = create_array 50 0.0
rsqrt_table.(1) <- 1.0
rsqrt_table.(2) <- 0.707106781186547462
rsqrt_table.(3) <- 0.5
rsqrt_table.(4) <- 0.353553390593273731
rsqrt_table.(5) <- 0.25
rsqrt_table.(6) <- 0.176776695296636865
rsqrt_table.(7) <- 0.125
rsqrt_table.(8) <- 0.0883883476483184327
rsqrt_table.(9) <- 0.0625
rsqrt_table.(10) <- 0.0441941738241592164
rsqrt_table.(11) <- 0.03125
rsqrt_table.(12) <- 0.0220970869120796082
rsqrt_table.(13) <- 0.015625
rsqrt_table.(14) <- 0.0110485434560398041
rsqrt_table.(15) <- 0.0078125
rsqrt_table.(16) <- 0.00552427172801990204
rsqrt_table.(17) <- 0.00390625
rsqrt_table.(18) <- 0.00276213586400995102
rsqrt_table.(19) <- 0.001953125
rsqrt_table.(20) <- 0.00138106793200497551
rsqrt_table.(21) <- 0.0009765625
rsqrt_table.(22) <- 0.000690533966002487756
rsqrt_table.(23) <- 0.00048828125
rsqrt_table.(24) <- 0.000345266983001243878
rsqrt_table.(25) <- 0.000244140625
rsqrt_table.(26) <- 0.000172633491500621939
rsqrt_table.(27) <- 0.0001220703125
rsqrt_table.(28) <- 8.63167457503109694e-05
rsqrt_table.(29) <- 6.103515625e-05
rsqrt_table.(30) <- 4.31583728751554847e-05
rsqrt_table.(31) <- 3.0517578125e-05
rsqrt_table.(32) <- 2.15791864375777424e-05
rsqrt_table.(33) <- 1.52587890625e-05
rsqrt_table.(34) <- 1.07895932187888712e-05
rsqrt_table.(35) <- 7.62939453125e-06
rsqrt_table.(36) <- 5.39479660939443559e-06
rsqrt_table.(37) <- 3.814697265625e-06
rsqrt_table.(38) <- 2.6973983046972178e-06
rsqrt_table.(39) <- 1.9073486328125e-06
rsqrt_table.(40) <- 1.3486991523486089e-06
rsqrt_table.(41) <- 9.5367431640625e-07
rsqrt_table.(42) <- 6.74349576174304449e-07
rsqrt_table.(43) <- 4.76837158203125e-07
rsqrt_table.(44) <- 3.37174788087152224e-07
rsqrt_table.(45) <- 2.384185791015625e-07
rsqrt_table.(46) <- 1.68587394043576112e-07
rsqrt_table.(47) <- 1.1920928955078125e-07
rsqrt_table.(48) <- 8.42936970217880561e-08
rsqrt_table.(49) <- 5.9604644775390625e-08
rsqrt_table.(50) <- 4.21468485108940281e-08

*)
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

(* test sin *)
print_float (sin (0.0));
print_float (sin (pih));
print_float (sin (pi));
print_float (sin (3.0 *. pih));
print_float (sin (pi2));
(*
(* test cos *)
print_float (cos (0.0));
print_float (cos (pih));
print_float (cos (pi));
print_float (cos (3.0 *. pih));
print_float (cos (pi2))
*)

