.init_heap_size	0

	addi	%g6, %g0, 96
	addi	%g7, %g0, 97
	addi	%g8, %g0, 98
Loop:
	input	%g4
	output %g4
	jmp Loop

