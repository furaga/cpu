let rec fhalf a = a /. 2.0 in
let rec fsqr a = a *. a in
let rec fabs a =
	if a < 0.0 then -. a
	else a
in
let rec fneg a = -. a in

(* test fhalf *)
let x = 2.0 in
let y = -1.01 in
let z = 0.0 in
let w = 118.625 in
let w2 = -118.625 in
print_float w;
print_float w2;
print_float x;
print_float (fhalf x);
print_float y;
print_float (fhalf y);
print_float z;
print_float (fhalf z);

(* test fsqr *)
let x = 2.0 in
let y = -0.1 in
let z = 0.0 in
print_float x;
print_float (fsqr x);
print_float y;
print_float (fsqr y);
print_float z;
print_float (fsqr z);

(* test fabs *)
let x = 2.0 in
let y = -0.1 in
let z = 0.0 in
print_float x;
print_float (fabs x);
print_float y;
print_float (fabs y);
print_float z;
print_float (fabs z);

(* test fneg *)
let x = 2.0 in
let y = -0.1 in
let z = 0.0 in
print_float x;
print_float (fneg x);
print_float y;
print_float (fneg y);
print_float z;
print_float (fneg z)
