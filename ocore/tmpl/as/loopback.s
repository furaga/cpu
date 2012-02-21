.init_heap_size	0

	addi	%g3, %g0, 48
	addi	%g3, %g0, 48
	addi	%g3, %g0, 48
Loop:
	input	%g4
	output %g4
	addi	%g3, %g3 1
	jmp Loop

