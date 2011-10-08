(* 浮動小数基本演算 *)
let rec fless a b = (a < b) in
let rec fispos a = (a > 0.0) in
let rec fisneg a = (a < 0.0) in

(* test fless *)
let x = 1.0 in
let y = 1.01 in
let z = 0.0 in
if fless x y then print_int 1 else print_int 0;
if fless y x then print_int 0 else print_int 1;
if fless x x then print_int 0 else print_int 1;
if fless z z then print_int 0 else print_int 1;

(* test fispos *)
let x = 1.0 in
let y = -0.001 in
let z = 0.0 in
if fispos x then print_int 1 else print_int 0;
if fispos y then print_int 0 else print_int 1;
if fispos z then print_int 0 else print_int 1;

(* test fisneg *)
let x = 1.0 in
let y = -0.001 in
let z = 0.0 in
if fispos x then print_int 0 else print_int 1;
if fispos y then print_int 1 else print_int 0;
if fispos z then print_int 0 else print_int 1
