(* test float_of_int *)
print_float (float_of_int (-2));
print_float (float_of_int (-1));
print_float (float_of_int 0);
print_float (float_of_int 1);
print_float (float_of_int 2);

(* test int_of_float *)
print_int (int_of_float (-. 2.0));
print_int (int_of_float (-. 1.5));
print_int (int_of_float (-. 1.0));
print_int (int_of_float (-. 0.5));
print_int (int_of_float (0.0));
print_int (int_of_float (0.1));
print_int (int_of_float (0.2));
print_int (int_of_float (0.3));
print_int (int_of_float (0.4));
print_int (int_of_float (0.5));
print_int (int_of_float (0.6));
print_int (int_of_float (0.7));
print_int (int_of_float (0.8));
print_int (int_of_float (0.9));
print_int (int_of_float (1.0));
print_int (int_of_float (1.5));
print_int (int_of_float (2.0));
