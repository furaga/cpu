.init_heap_size	0
	jmp	min_caml_start
sum.8:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jlt	%g5, %g4, jle_else.19
	return
jle_else.19:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jmp	sum.8
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 0
	mvhi	%g4, 0
	mvlo	%g4, 10000
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	sum.8
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	halt
