.init_heap_size	0

	addi	%g3, %g0, 48
	addi	%g3, %g0, 48
	addi	%g3, %g0, 48
Loop:
	inputw	%g4
	outputw %g4
	inputf	%f0
	outputf %f0
	input	%g4
	output %g4
	output %g3
	addi	%g3, %g3 1
	jmp Loop

