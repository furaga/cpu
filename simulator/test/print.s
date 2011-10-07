.init_heap_size	0
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 123
	output	%g3
	mvhi	%g3, 65535
	mvlo	%g3, -456
	output	%g3
	mvhi	%g3, 0
	mvlo	%g3, 789
	output	%g3
	halt
