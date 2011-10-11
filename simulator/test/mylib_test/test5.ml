(* test floor *)

print_float (floor 0.0);
print_float (floor 0.1);
print_float (floor 0.2);
print_float (floor 0.3);
print_float (floor 0.4);
print_float (floor 0.5);
print_float (floor 0.6);
print_float (floor 0.7);
print_float (floor 0.8);
print_float (floor 0.9);
print_float (floor 1.0);
print_float (floor 1.1);
print_float (floor 1.2);
print_float (floor 1.3);
print_float (floor 1.4);
print_float (floor 1.5);
print_float (floor 1.6);
print_float (floor 1.7);
print_float (floor 1.8);
print_float (floor 1.9);
print_float (floor 2.0);
print_float (floor (-. 0.0));
print_float (floor (-. 0.1));
print_float (floor (-. 0.2));
print_float (floor (-. 0.3));
print_float (floor (-. 0.4));
print_float (floor (-. 0.5));
print_float (floor (-. 0.6));
print_float (floor (-. 0.7));
print_float (floor (-. 0.8));
print_float (floor (-. 0.9));
print_float (floor (-. 1.0));
print_float (floor (-. 1.1));
print_float (floor (-. 1.2));
print_float (floor (-. 1.3));
print_float (floor (-. 1.4));
print_float (floor (-. 1.5));
print_float (floor (-. 1.6));
print_float (floor (-. 1.7));
print_float (floor (-. 1.8));
print_float (floor (-. 1.9));
print_float (floor (-. 2.0));
print_float (floor 8388608.0);

(*
FLOAT_ZERO:
	.float 0.0
FLOAT_ONE:
	.float 1.0
FLOAT_MONE:
	.float -1.0
FLOAT_MAGICI:
	.int 8388608
FLOAT_MAGICF:
	.float 8388608.0
FLOAT_MAGICFHX:
	.int 1258291200			! 0x4b000000
FLOAT_HALF:
	.float 0.5*)
