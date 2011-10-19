.init_heap_size	608
FLOAT_ZERO:		! 0.0
	.long 0x0
FLOAT_ONE:		! 1.0
	.long 0x3f800000
FLOAT_MONE:		! -1.0
	.long 0xbf800000
FLOAT_MAGICI:	! 8388608
	.long 0x800000
FLOAT_MAGICF:	! 8388608.0
	.long 0x4b000000
FLOAT_MAGICFHX:	! 1258291200
	.long 0x4b000000
l.632:	! -12.300000
	.long	0xc144ccc4
l.630:	! 4.500000
	.long	0x40900000
l.628:	! 48.300300
	.long	0x42413381
l.626:	! 3.141593
	.long	0x40490fda
l.624:	! 1.570796
	.long	0x3fc90fda
l.622:	! 6.283185
	.long	0x40c90fda
l.613:	! 1.570796
	.long	0x3fc90fda
l.608:	! 0.500000
	.long	0x3f000000
l.605:	! 1.000000
	.long	0x3f800000
l.603:	! 9.000000
	.long	0x41100000
l.600:	! 2.000000
	.long	0x40000000
l.598:	! 2.500000
	.long	0x40200000
l.596:	! 0.000000
	.long	0x0
	jmp	min_caml_start

!#####################################################################
!
! 		↓　ここから lib_asm.s
!
!#####################################################################

!#####################################################################
! * 算術関数用定数テーブル
!#####################################################################

! * floor		%f0 + MAGICF - MAGICF
min_caml_floor:
	fmov %f1, %f0
	! %f4 = 0.0
	setL %g3, FLOAT_ZERO
	fld %f4, %g3, 0
	fjlt %f4, %f0, FLOOR_POSITIVE	! if (%f4 <= %f0) goto FLOOR_PISITIVE
	fjeq %f4, %f0, FLOOR_POSITIVE
FLOOR_NEGATIVE:
	fneg %f0, %f0
	setL %g3, FLOAT_MAGICF
	! %f2 = FLOAT_MAGICF
	fld %f2, %g3, 0
	fjlt %f0, %f2, FLOOR_NEGATIVE_MAIN
	fjeq %f0, %f2, FLOOR_NEGATIVE_MAIN
	fneg %f0, %f0
	return
FLOOR_NEGATIVE_MAIN:
	fadd %f0, %f0, %f2
	fsub %f0, %f0, %f2
	fneg %f1, %f1
	fjlt %f1, %f0, FLOOR_RET2
	fjeq %f1, %f0, FLOOR_RET2
	fadd %f0, %f0, %f2
	! %f3 = 1.0
	setL %g3, FLOAT_ONE
	fld %f3, %g3, 0
	fadd %f0, %f0, %f3
	fsub %f0, %f0, %f2
	fneg %f0, %f0
	return
FLOOR_POSITIVE:
	setL %g3, FLOAT_MAGICF
	fld %f2, %g3, 0
	fjlt %f0, %f2, FLOOR_POSITIVE_MAIN
	fjeq %f0, %f2, FLOOR_POSITIVE_MAIN
	return
FLOOR_POSITIVE_MAIN:
	fmov %f1, %f0
	fadd %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g4, %g1, 0
	fsub %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g4, %g1, 0
	fjlt %f0, %f1, FLOOR_RET
	fjeq %f0, %f1, FLOOR_RET
	setL %g3, FLOAT_ONE
	fld %f3, %g3, 0
	fsub %f0, %f0, %f3
FLOOR_RET:
	return
FLOOR_RET2:
	fneg %f0, %f0
	return
	
min_caml_ceil:
	fneg %f0, %f0
	call min_caml_floor
	fneg %f0, %f0
	return

! * float_of_int
min_caml_float_of_int:
	jlt %g0, %g3, ITOF_MAIN		! if (%g0 <= %g3) goto ITOF_MAIN
	jeq %g0, %g3, ITOF_MAIN
	sub %g3, %g0, %g3
	call ITOF_MAIN
	fneg %f0, %f0
	return
ITOF_MAIN:

	! %f1 <= FLOAT_MAGICF
	! %g4 <= FLOAT_MAGICFHX
	! %g5 <= FLOAT_MAGICI

	setL %g5, FLOAT_MAGICF
	fld %f1, %g5, 0
	setL %g5, FLOAT_MAGICFHX
	ld %g4, %g5, 0
	setL %g5, FLOAT_MAGICI
	ld %g5, %g5, 0
	jlt %g5, %g3, ITOF_BIG
	jeq %g5, %g3, ITOF_BIG
	add %g3, %g3, %g4
	st %g3, %g1, 0
	fld %f0, %g1, 0
	fsub %f0, %f0, %f1
	return
ITOF_BIG:
	setL %g4, FLOAT_ZERO
	fld %f2, %g4, 0
ITOF_LOOP:
	sub %g3, %g3, %g5
	fadd %f2, %f2, %f1
	jlt %g5, %g3, ITOF_LOOP
	jeq %g5, %g3, ITOF_LOOP
	add %g3, %g3, %g4
	st %g3, %g1, 0
	fld %f0, %g1, 0
	fsub %f0, %f0, %f1
	fadd %f0, %f0, %f2
	return

! * int_of_float
min_caml_int_of_float:
	! %f1 <= 0.0
	setL %g3, FLOAT_ZERO
	fld %f1, %g3, 0
	fjlt %f1, %f0, FTOI_MAIN			! if (0.0 <= %f0) goto FTOI_MAIN
	fjeq %f1, %f0, FTOI_MAIN
	fneg %f0, %f0
	call FTOI_MAIN
	sub %g3, %g0, %g3
	return
FTOI_MAIN:
	call min_caml_floor
	! %f2 <= FLOAT_MAGICF
	! %g4 <= FLOAT_MAGICFHX
	setL %g4, FLOAT_MAGICF
	fld %f2, %g4, 0
	setL %g4, FLOAT_MAGICFHX
	ld %g4, %g4, 0
	fjlt %f2, %f0, FTOI_BIG		! if (MAGICF <= %f0) goto FTOI_BIG
	fjeq %f2, %f0, FTOI_BIG
	fadd %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g3, %g1, 0
	sub %g3, %g3, %g4
	return
FTOI_BIG:
	setL %g5, FLOAT_MAGICI
	ld %g5, %g5, 0
	mov %g3, %g0
FTOI_LOOP:
	fsub %f0, %f0, %f2
	add %g3, %g3, %g5
	fjlt %f2, %f0, FTOI_LOOP
	fjeq %f2, %f0, FTOI_LOOP
	fadd %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g5, %g1, 0
	sub %g5, %g5, %g4
	add %g3, %g5, %g3
	return
	
! * truncate
min_caml_truncate:
	jmp min_caml_int_of_float


!#####################################################################
!
! 		↑　ここまで lib_asm.s
!
!#####################################################################

!#####################################################################
! * ここからライブラリ関数
!#####################################################################

! * create_array
min_caml_create_array:
	slli %g3, %g3, 2
	add %g5, %g3, %g2
	mov %g3, %g2
CREATE_ARRAY_LOOP:
	jlt %g5, %g2, CREATE_ARRAY_END
	jeq %g5, %g2, CREATE_ARRAY_END
	st %g4, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_ARRAY_LOOP
CREATE_ARRAY_END:
	return

! * create_float_array
min_caml_create_float_array:
	slli %g3, %g3, 2
	add %g4, %g3, %g2
	mov %g3, %g2
CREATE_FLOAT_ARRAY_LOOP:
	jlt %g4, %g2, CREATE_FLOAT_ARRAY_END
	jeq %g4, %g2, CREATE_ARRAY_END
	fst %f0, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_FLOAT_ARRAY_LOOP
CREATE_FLOAT_ARRAY_END:
	return

!#####################################################################
! * ここまでライブラリ関数
!#####################################################################

fabs.266:
	setL %g3, l.596
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.699
	return
fjge_else.699:
	fneg	%f0, %f0
	return
abs_float.268:
	jmp	fabs.266
fneg.270:
	fneg	%f0, %f0
	return
tan_sub.541:
	setL %g3, l.598
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.700
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	setL %g3, l.600
	fld	%f3, %g3, 0
	fsub	%f0, %f0, %f3
	jmp	tan_sub.541
fjge_else.700:
	fmov	%f0, %f2
	return
tan.285:
	setL %g3, l.596
	fld	%f2, %g3, 0
	fmul	%f1, %f0, %f0
	setL %g3, l.603
	fld	%f3, %g3, 0
	fst	%f0, %g1, 0
	fmov	%f0, %f3
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	tan_sub.541
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	setL %g3, l.605
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	fld	%f1, %g1, 0
	fdiv	%f0, %f1, %f0
	return
sin_sub.287:
	fld	%f1, %g29, -8
	fjlt	%f1, %f0, fjge_else.701
	setL %g3, l.596
	fld	%f2, %g3, 0
	fjlt	%f0, %f2, fjge_else.702
	return
fjge_else.702:
	fadd	%f0, %f0, %f1
	ld	%g28, %g29, 0
	b	%g28
fjge_else.701:
	fsub	%f0, %f0, %f1
	ld	%g28, %g29, 0
	b	%g28
sin.289:
	ld	%g3, %g29, -32
	fld	%f1, %g29, -24
	fld	%f2, %g29, -16
	fld	%f3, %g29, -8
	fst	%f0, %g1, 0
	fst	%f1, %g1, 4
	fst	%f2, %g1, 8
	fst	%f3, %g1, 12
	st	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fabs.266
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 12
	fjlt	%f1, %f0, fjge_else.703
	fmov	%f2, %f0
	jmp	fjge_cont.704
fjge_else.703:
	fld	%f2, %g1, 8
	fsub	%f2, %f2, %f0
fjge_cont.704:
	fld	%f3, %g1, 4
	fjlt	%f3, %f2, fjge_else.705
	jmp	fjge_cont.706
fjge_else.705:
	fsub	%f2, %f1, %f2
fjge_cont.706:
	setL %g3, l.608
	fld	%f3, %g3, 0
	fmul	%f2, %f2, %f3
	fst	%f0, %g1, 20
	fmov	%f0, %f2
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	tan.285
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	setL %g3, l.596
	fld	%f1, %g3, 0
	fld	%f2, %g1, 0
	fjlt	%f1, %f2, fjge_else.707
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	fjge_cont.708
fjge_else.707:
	mvhi	%g3, 0
	mvlo	%g3, 1
fjge_cont.708:
	fld	%f1, %g1, 12
	fld	%f2, %g1, 20
	fjlt	%f1, %f2, fjge_else.709
	jmp	fjge_cont.710
fjge_else.709:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.711
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.712
jeq_else.711:
	mov	%g3, %g4
jeq_cont.712:
fjge_cont.710:
	fmul	%f1, %f0, %f0
	setL %g4, l.605
	fld	%f2, %g4, 0
	fadd	%f1, %f2, %f1
	setL %g4, l.600
	fld	%f2, %g4, 0
	fmul	%f0, %f2, %f0
	fdiv	%f0, %f0, %f1
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.713
	jmp	fneg.270
jeq_else.713:
	return
cos.291:
	ld	%g29, %g29, -4
	setL %g3, l.613
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	ld	%g28, %g29, 0
	b	%g28
print_int_get_digits.315:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g7, %g4, 0
	jlt	%g6, %g7, jle_else.714
	subi	%g3, %g3, 1
	return
jle_else.714:
	divi	%g6, %g7, 10
	muli	%g8, %g6, 10
	sub	%g7, %g7, %g8
	slli	%g8, %g3, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g8
	st	%g7, %g5, 0
	ld	%g5, %g1, 4
	st	%g6, %g4, 0
	addi	%g3, %g3, 1
	ld	%g28, %g29, 0
	b	%g28
print_int_print_digits.317:
	ld	%g4, %g29, -4
	mvhi	%g5, 0
	mvlo	%g5, 0
	jlt	%g3, %g5, jle_else.715
	slli	%g5, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g5
	ld	%g4, %g4, 0
	addi	%g4, %g4, 48
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g4
	output	%g3
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.715:
	return
print_int.319:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g29, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g3, %g6, jle_else.717
	mov	%g7, %g3
	jmp	jle_cont.718
jle_else.717:
	sub	%g7, %g0, %g3
jle_cont.718:
	st	%g7, %g4, 0
	st	%g5, %g1, 0
	st	%g3, %g1, 4
	st	%g6, %g1, 8
	mov	%g3, %g6
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	ld	%g5, %g1, 8
	st	%g3, %g1, 12
	jlt	%g4, %g5, jle_else.719
	jmp	jle_cont.720
jle_else.719:
	mvhi	%g4, 0
	mvlo	%g4, 45
	mov	%g3, %g4
	output	%g3
jle_cont.720:
	ld	%g3, %g1, 12
	ld	%g4, %g1, 8
	jlt	%g3, %g4, jle_else.721
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.721:
	mvhi	%g3, 0
	mvlo	%g3, 48
	output	%g3
	return
min_caml_start:
	setL %g3, l.622
	fld	%f0, %g3, 0
	mov	%g3, %g2
	addi	%g2, %g2, 16
	setL %g4, sin_sub.287
	st	%g4, %g3, 0
	fst	%f0, %g3, -8
	setL %g4, l.624
	fld	%f1, %g4, 0
	setL %g4, l.626
	fld	%f2, %g4, 0
	mov	%g4, %g2
	addi	%g2, %g2, 40
	setL %g5, sin.289
	st	%g5, %g4, 0
	st	%g3, %g4, -32
	fst	%f1, %g4, -24
	fst	%f0, %g4, -16
	fst	%f2, %g4, -8
	mov	%g3, %g2
	addi	%g2, %g2, 8
	setL %g5, cos.291
	st	%g5, %g3, 0
	st	%g4, %g3, -4
	mvhi	%g5, 0
	mvlo	%g5, 0
	mvhi	%g6, 0
	mvlo	%g6, 1
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	st	%g5, %g1, 8
	st	%g6, %g1, 12
	mov	%g4, %g5
	mov	%g3, %g6
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	ld	%g4, %g1, 8
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	ld	%g4, %g1, 8
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	ld	%g4, %g1, 8
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	mov	%g4, %g3
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	ld	%g4, %g1, 8
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g3, 0
	mvlo	%g3, 10
	ld	%g4, %g1, 8
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 12
	ld	%g5, %g1, 8
	st	%g3, %g1, 16
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g2
	addi	%g2, %g2, 16
	setL %g5, print_int_get_digits.315
	st	%g5, %g4, 0
	st	%g3, %g4, -8
	ld	%g5, %g1, 16
	st	%g5, %g4, -4
	mov	%g6, %g2
	addi	%g2, %g2, 8
	setL %g7, print_int_print_digits.317
	st	%g7, %g6, 0
	st	%g5, %g6, -4
	mov	%g5, %g2
	addi	%g2, %g2, 16
	setL %g7, print_int.319
	st	%g7, %g5, 0
	st	%g3, %g5, -12
	st	%g6, %g5, -8
	st	%g4, %g5, -4
	mvhi	%g3, 15
	mvlo	%g3, 16960
	st	%g5, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	setL %g3, l.628
	fld	%f1, %g3, 0
	setL %g3, l.630
	fld	%f2, %g3, 0
	setL %g3, l.632
	fld	%f3, %g3, 0
	fst	%f0, %g1, 24
	fst	%f1, %g1, 28
	fst	%f2, %g1, 32
	fmov	%f0, %f3
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	abs_float.268
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fsqrt	%f0, %f0
	ld	%g29, %g1, 4
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g29, %g1, 0
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fadd	%f0, %f0, %f1
	fld	%f1, %g1, 28
	fsub	%f0, %f0, %f1
	fld	%f1, %g1, 24
	fmul	%f0, %f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_int_of_float
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g29, %g1, 20
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	halt
