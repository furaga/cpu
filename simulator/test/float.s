.init_heap_size	96
l.39:	! 48.300300
	.long	0x42413381
l.37:	! 4.500000
	.long	0x40900000
l.35:	! -12.300000
	.long	0xc144ccc4
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
	fst %f0, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_FLOAT_ARRAY_LOOP
CREATE_FLOAT_ARRAY_END:
	return

!#####################################################################
! * ここまでライブラリ関数
!#####################################################################

min_caml_start:
	setL %g3, l.35
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_abs_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_sqrt
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_cos
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_sin
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	setL %g3, l.37
	fld	%f1, %g3, 0
	fadd	%f0, %f0, %f1
	setL %g3, l.39
	fld	%f1, %g3, 0
	fsub	%f0, %f0, %f1
	mvhi	%g3, 15
	mvlo	%g3, 16960
	fst	%f0, %g1, 0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_float_of_int
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f1, %g1, 0
	fmul	%f0, %f1, %f0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_int_of_float
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	output	%g3
	halt
