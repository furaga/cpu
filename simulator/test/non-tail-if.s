.init_heap_size	96
l.32:	! -7.890000
	.long	0xc07c7ae1
l.30:	! 4.560000
	.long	0x4091eb7d
l.28:	! 1.230000
	.long	0x3f9d70a3
min_caml_start:
	setL %g3, l.28
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_truncate
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	setL %g4, l.30
	fld	%f0, %g4, 0
	st	%g3, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_truncate
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	setL %g4, l.32
	fld	%f0, %g4, 0
	st	%g3, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_truncate
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	jlt	%g3, %g4, jle_else.37
	ld	%g4, %g1, 0
	b	jle_cont.38
jle_else.37:
	ld	%g4, %g1, 4
jle_cont.38:
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g6, %g1, 0
	jlt	%g5, %g6, jle_else.39
	ld	%g5, %g1, 4
	b	jle_cont.40
jle_else.39:
	mov	%g5, %g3
jle_cont.40:
	add	%g4, %g4, %g5
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g7, %g1, 4
	jlt	%g7, %g5, jle_else.41
	b	jle_cont.42
jle_else.41:
	mov	%g3, %g6
jle_cont.42:
	add	%g3, %g4, %g3
	output	%g3
	halt
