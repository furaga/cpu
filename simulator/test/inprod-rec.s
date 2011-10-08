.init_heap_size	128
l.49:	! 1000000.000000
	.long	0x49742400
l.47:	! 4.560000
	.long	0x4091eb7d
l.45:	! 1.230000
	.long	0x3f9d70a3
l.39:	! 0.000000
	.long	0x40000000
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

inprod.17:
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g5, %g6, jle_else.55
	slli	%g6, %g5, 2
	fld	%f0, %g3, %g6
	slli	%g6, %g5, 2
	fld	%f1, %g4, %g6
	fmul	%f0, %f0, %f1
	subi	%g5, %g5, 1
	std	%f0, %g1, 0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	inprod.17
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f1, %g1, 0
	fadd	%f0, %f1, %f0
	return
jle_else.55:
	setL %g3, l.39
	fld	%f0, %g3, 0
	return
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g4, l.45
	fld	%f0, %g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.47
	fld	%f0, %g5, 0
	st	%g3, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g4, %g3
	setL %g3, l.49
	fld	%f0, %g3, 0
	mvhi	%g5, 0
	mvlo	%g5, 2
	ld	%g3, %g1, 0
	std	%f0, %g1, 8
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	inprod.17
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 8
	fmul	%f0, %f1, %f0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_truncate
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	output	%g3
	halt
