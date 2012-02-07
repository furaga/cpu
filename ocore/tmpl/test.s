.init_heap_size 64
D:
	.long 0x12345678
D2:
	.long 0x87654321

	jmp start
func:
	output %g3
	return

start:
	mvlo %g3, 1
	mvlo %g4, 1
	mvlo %g5, 0
	mvlo %g6, 6
	mvhi %g3, 10
Loop:
	addi %g5, %g5, 1
	srli %g3, %g3, 1
	jlt %g5, %g6, Loop
L:
	sti %g3, %g2, 0
	call func
	srli %g3, %g3, 1
	call func
	halt
