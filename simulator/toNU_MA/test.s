.init_heap_size 32
FLOAT_ONE:
	.long 0x3f800000

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
