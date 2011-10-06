.init_heap_size	0
	jmp	min_caml_start
sum.7:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jlt	%g4, %g3, jle_else.17
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jle_else.17:
	subi	%g4, %g3, 1
	st	%g3, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	sum.7
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	add	%g3, %g3, %g4
	return
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 10000
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	sum.7
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	halt
