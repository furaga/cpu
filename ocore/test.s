.init_heap_size 32
D:
	.long 0x00000000
	
	mvlo %g3, 0
	mvlo %g4, 1
	mvlo %g5, 0
	mvlo %g6, 10
Loop:
	add %g5, %g5, %g4
	add %g3, %g3, %g5
	jeq %g5, %g6, L
	jmp Loop
L:
	subi %g3, %g3, 7
	output %g3
	halt
