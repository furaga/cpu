.init_heap_size 0

	jmp L1
F:
	mvlo %g3, 51
	output %g3
	return
L1:
	call F
	addi %g3, %g3, 1
	output %g3
	halt
