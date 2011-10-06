.init_heap_size	0
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 1
	slli	%g3, %g3, 1
	output	%g3
	mvhi	%g3, 0
	mvlo	%g3, 3
	slli	%g3, %g3, 1
	output	%g3
	mvhi	%g3, 65535
	mvlo	%g3, -4
	slli	%g3, %g3, 2
	output	%g3
	mvhi	%g3, 0
	mvlo	%g3, 5
	slli	%g3, %g3, 3
	output	%g3
	halt
