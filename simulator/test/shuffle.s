.init_heap_size	0
	jmp	min_caml_start
foo.12:
	st	%g8, %g1, 0
	st	%g7, %g1, 4
	st	%g6, %g1, 8
	st	%g5, %g1, 12
	st	%g4, %g1, 16
	output	%g3
	ld	%g3, %g1, 16
	output	%g3
	ld	%g3, %g1, 12
	output	%g3
	ld	%g3, %g1, 8
	output	%g3
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 0
	output	%g3
	return
bar.19:
	mov	%g29, %g8
	mov	%g8, %g5
	mov	%g5, %g6
	mov	%g6, %g7
	mov	%g7, %g29
	mov	%g29, %g4
	mov	%g4, %g3
	mov	%g3, %g29
	jmp	foo.12
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 2
	mvhi	%g5, 0
	mvlo	%g5, 3
	mvhi	%g6, 0
	mvlo	%g6, 4
	mvhi	%g7, 0
	mvlo	%g7, 5
	mvhi	%g8, 0
	mvlo	%g8, 6
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	bar.19
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	halt
