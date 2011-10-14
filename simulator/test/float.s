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
l.603:	! 48.300300
	.long	0x42413381
l.601:	! 4.500000
	.long	0x40900000
l.599:	! -12.300000
	.long	0xc144ccc4
l.597:	! 1.570796
	.long	0x3fc90fda
l.595:	! 6.283185
	.long	0x40c90fda
l.593:	! 3.141593
	.long	0x40490fda
l.574:	! 1.570796
	.long	0x3fc90fda
l.567:	! 0.500000
	.long	0x3f000000
l.562:	! 9.000000
	.long	0x41100000
l.560:	! 1.000000
	.long	0x3f800000
l.558:	! 2.000000
	.long	0x40000000
l.556:	! 2.500000
	.long	0x40200000
l.554:	! 0.000000
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
	call min_caml_ceil
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

fabs.245:
	setL %g3, l.554
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.636
	return
fjge_else.636:
	fneg	%f0, %f0
	return
abs_float.247:
	jmp	fabs.245
fneg.249:
	fneg	%f0, %f0
	return
tan_sub.495:
	setL %g3, l.556
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.637
	setL %g3, l.558
	fld	%f3, %g3, 0
	fsub	%f3, %f0, %f3
	fsub	%f0, %f0, %f2
	fdiv	%f2, %f1, %f0
	fmov	%f0, %f3
	jmp	tan_sub.495
fjge_else.637:
	fmov	%f0, %f2
	return
tan.470:
	setL %g3, l.560
	fld	%f1, %g3, 0
	setL %g3, l.562
	fld	%f2, %g3, 0
	fmul	%f3, %f0, %f0
	setL %g3, l.554
	fld	%f4, %g3, 0
	fst	%f0, %g1, 0
	fst	%f1, %g1, 4
	fmov	%f1, %f3
	fmov	%f0, %f2
	fmov	%f2, %f4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	tan_sub.495
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f1, %g1, 4
	fsub	%f0, %f1, %f0
	fld	%f1, %g1, 0
	fdiv	%f0, %f1, %f0
	return
tmp.474:
	fld	%f1, %g29, -8
	fjlt	%f1, %f0, fjge_else.638
	setL %g3, l.554
	fld	%f2, %g3, 0
	fjlt	%f0, %f2, fjge_else.639
	return
fjge_else.639:
	fadd	%f0, %f0, %f1
	ld	%g28, %g29, 0
	b	%g28
fjge_else.638:
	fsub	%f0, %f0, %f1
	ld	%g28, %g29, 0
	b	%g28
sin.260:
	fld	%f1, %g29, -24
	fld	%f2, %g29, -16
	fld	%f3, %g29, -8
	setL %g3, l.554
	fld	%f4, %g3, 0
	fjlt	%f4, %f0, fjge_else.640
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	fjge_cont.641
fjge_else.640:
	mvhi	%g3, 0
	mvlo	%g3, 1
fjge_cont.641:
	fst	%f1, %g1, 0
	st	%g3, %g1, 4
	fst	%f3, %g1, 8
	fst	%f2, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fabs.245
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g29, %g2
	addi	%g2, %g2, 16
	setL %g3, tmp.474
	st	%g3, %g29, 0
	fld	%f1, %g1, 12
	fst	%f1, %g29, -8
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 8
	fjlt	%f1, %f0, fjge_else.642
	ld	%g3, %g1, 4
	jmp	fjge_cont.643
fjge_else.642:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 4
	jne	%g4, %g3, jeq_else.644
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.645
jeq_else.644:
	mvhi	%g3, 0
	mvlo	%g3, 0
jeq_cont.645:
fjge_cont.643:
	fjlt	%f1, %f0, fjge_else.646
	jmp	fjge_cont.647
fjge_else.646:
	fld	%f2, %g1, 12
	fsub	%f0, %f2, %f0
fjge_cont.647:
	fld	%f2, %g1, 0
	fjlt	%f2, %f0, fjge_else.648
	jmp	fjge_cont.649
fjge_else.648:
	fsub	%f0, %f1, %f0
fjge_cont.649:
	setL %g4, l.567
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	st	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	tan.470
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	setL %g3, l.558
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	setL %g3, l.560
	fld	%f2, %g3, 0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f2, %f0
	fdiv	%f0, %f1, %f0
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 16
	jne	%g4, %g3, jeq_else.650
	jmp	fneg.249
jeq_else.650:
	return
cos.262:
	ld	%g29, %g29, -4
	setL %g3, l.574
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	ld	%g28, %g29, 0
	b	%g28
get_digits.291:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	ld	%g6, %g4, 0
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g7, %g6, jle_else.651
	subi	%g3, %g3, 1
	return
jle_else.651:
	ld	%g6, %g4, 0
	divi	%g6, %g6, 10
	ld	%g7, %g4, 0
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
print_digits.293:
	ld	%g4, %g29, -4
	mvhi	%g5, 0
	mvlo	%g5, 0
	jlt	%g3, %g5, jle_else.652
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
jle_else.652:
	return
print_int.270:
	mvhi	%g4, 0
	mvlo	%g4, 10
	mvhi	%g5, 0
	mvlo	%g5, 32
	st	%g3, %g1, 0
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g6, %g1, 0
	jlt	%g6, %g5, jle_else.654
	mov	%g5, %g6
	jmp	jle_cont.655
jle_else.654:
	sub	%g5, %g0, %g6
jle_cont.655:
	st	%g3, %g1, 4
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mov	%g29, %g2
	addi	%g2, %g2, 16
	setL %g4, get_digits.291
	st	%g4, %g29, 0
	st	%g3, %g29, -8
	ld	%g3, %g1, 4
	st	%g3, %g29, -4
	mov	%g4, %g2
	addi	%g2, %g2, 8
	setL %g5, print_digits.293
	st	%g5, %g4, 0
	st	%g3, %g4, -4
	mvhi	%g3, 0
	mvlo	%g3, 0
	st	%g4, %g1, 8
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g5, %g1, 0
	st	%g3, %g1, 12
	jlt	%g5, %g4, jle_else.656
	jmp	jle_cont.657
jle_else.656:
	mvhi	%g4, 0
	mvlo	%g4, 45
	mov	%g3, %g4
	output	%g3
jle_cont.657:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 12
	jlt	%g4, %g3, jle_else.658
	ld	%g29, %g1, 8
	mov	%g3, %g4
	ld	%g28, %g29, 0
	b	%g28
jle_else.658:
	mvhi	%g3, 0
	mvlo	%g3, 48
	output	%g3
	return
min_caml_start:
	setL %g3, l.593
	fld	%f0, %g3, 0
	setL %g3, l.595
	fld	%f1, %g3, 0
	setL %g3, l.597
	fld	%f2, %g3, 0
	mov	%g3, %g2
	addi	%g2, %g2, 32
	setL %g4, sin.260
	st	%g4, %g3, 0
	fst	%f2, %g3, -24
	fst	%f1, %g3, -16
	fst	%f0, %g3, -8
	mov	%g4, %g2
	addi	%g2, %g2, 8
	setL %g5, cos.262
	st	%g5, %g4, 0
	st	%g3, %g4, -4
	setL %g5, l.599
	fld	%f0, %g5, 0
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	abs_float.247
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fsqrt	%f0, %f0
	ld	%g29, %g1, 4
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g29, %g1, 0
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	setL %g3, l.601
	fld	%f1, %g3, 0
	fadd	%f0, %f0, %f1
	setL %g3, l.603
	fld	%f1, %g3, 0
	fsub	%f0, %f0, %f1
	mvhi	%g3, 15
	mvlo	%g3, 16960
	fst	%f0, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_float_of_int
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f1, %g1, 8
	fmul	%f0, %f1, %f0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_int_of_float
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	print_int.270
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	halt
