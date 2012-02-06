.init_heap_size 64
D:
	.long 0x12345678
D2:
	.long 0x87654321
	
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
	output %g3
	halt
