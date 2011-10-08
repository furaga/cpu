.init_heap_size	96
l.32:	! -7.890000
	.long	0xc07c7ae1
l.30:	! 4.560000
	.long	0x4091eb7d
l.28:	! 1.230000
	.long	0x3f9d70a3
	jmp	min_caml_start

!#####################################################################
! * ここからライブラリ関数
!#####################################################################

! * create_array
min_caml_create_array:
	add %g5, %g3, %g2
	mov %g3, %g2
CREATE_ARRAY_LOOP:
	jlt %g5, %g2, CREATE_ARRAY_END
	st %g4, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_ARRAY_LOOP
CREATE_ARRAY_END:
	return

! * create_float_array
min_caml_create_float_array:
	add %g4, %g3, %g2
	mov %g3, %g2
CREATE_FLOAT_ARRAY_LOOP:
	jlt %g4, %g2, CREATE_FLOAT_ARRAY_END
	st %f0, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_FLOAT_ARRAY_LOOP
CREATE_FLOAT_ARRAY_END:
	return

!#####################################################################
! * ここまでライブラリ関数
!#####################################################################

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
	jmp	jle_cont.38
jle_else.37:
	ld	%g4, %g1, 4
jle_cont.38:
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g6, %g1, 0
	jlt	%g5, %g6, jle_else.39
	ld	%g5, %g1, 4
	jmp	jle_cont.40
jle_else.39:
	mov	%g5, %g3
jle_cont.40:
	add	%g4, %g4, %g5
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g7, %g1, 4
	jlt	%g7, %g5, jle_else.41
	jmp	jle_cont.42
jle_else.41:
	mov	%g3, %g6
jle_cont.42:
	add	%g3, %g4, %g3
	output	%g3
	halt
