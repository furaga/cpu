.init_heap_size	1728
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
l.25245:	! -200.000000
	.long	0xc3480000
l.25231:	! 200.000000
	.long	0x43480000
l.25147:	! 128.000000
	.long	0x43000000
l.25138:	! 3.141593
	.long	0x40490fda
l.25108:	! 6.283185
	.long	0x40c90fda
l.25064:	! 0.200000
	.long	0x3e4cccc4
l.25062:	! 0.900000
	.long	0x3f66665e
l.24463:	! 150.000000
	.long	0x43160000
l.24344:	! -150.000000
	.long	0xc3160000
l.24294:	! 0.100000
	.long	0x3dccccc4
l.24221:	! -2.000000
	.long	0xc0000000
l.24187:	! 0.003906
	.long	0x3b800000
l.24185:	! 256.000000
	.long	0x43800000
l.24006:	! 100000000.000000
	.long	0x4cbebc20
l.23998:	! 1000000000.000000
	.long	0x4e6e6b28
l.23985:	! 20.000000
	.long	0x41a00000
l.23983:	! 0.050000
	.long	0x3d4cccc4
l.23964:	! 0.250000
	.long	0x3e800000
l.23938:	! 255.000000
	.long	0x437f0000
l.23936:	! 0.150000
	.long	0x3e199999
l.23919:	! 3.141593
	.long	0x40490fda
l.23917:	! 30.000000
	.long	0x41f00000
l.23915:	! -1.570796
	.long	0xbfc90fda
l.23913:	! -3.141593
	.long	0xc0490fda
l.23911:	! 1.570796
	.long	0x3fc90fda
l.23909:	! 23.000000
	.long	0x41b80000
l.23907:	! 22.000000
	.long	0x41b00000
l.23904:	! 121.000000
	.long	0x42f20000
l.23902:	! 10.000000
	.long	0x41200000
l.23899:	! 11.000000
	.long	0x41300000
l.23895:	! 15.000000
	.long	0x41700000
l.23893:	! 0.000100
	.long	0x38d1b70f
l.23872:	! 0.300000
	.long	0x3e999999
l.23631:	! -0.100000
	.long	0xbdccccc4
l.23607:	! 0.010000
	.long	0x3c23d70a
l.23603:	! -0.200000
	.long	0xbe4cccc4
l.23167:	! 3.000000
	.long	0x40400000
l.23165:	! 5.000000
	.long	0x40a00000
l.23163:	! 7.000000
	.long	0x40e00000
l.23159:	! 9.000000
	.long	0x41100000
l.23155:	! 1.570796
	.long	0x3fc90fda
l.23128:	! -1.000000
	.long	0xbf800000
l.23075:	! 0.017453
	.long	0x3c8efa2d
l.22860:	! 2.500000
	.long	0x40200000
l.22821:	! 0.000000
	.long	0x0
l.22819:	! 1.000000
	.long	0x3f800000
l.22817:	! 2.000000
	.long	0x40000000
l.22815:	! 0.500000
	.long	0x3f000000
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

atan_sub.2692:
	setL %g3, l.22815
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.30670
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fmul	%f5, %f4, %f0
	setL %g3, l.22819
	fld	%f6, %g3, 0
	fadd	%f5, %f5, %f6
	fadd	%f2, %f5, %f2
	fmul	%f5, %f0, %f0
	fmul	%f5, %f5, %f1
	fdiv	%f2, %f5, %f2
	fsub	%f0, %f0, %f6
	fjlt	%f0, %f3, fjge_else.30671
	fmul	%f3, %f4, %f0
	fadd	%f3, %f3, %f6
	fadd	%f2, %f3, %f2
	fmul	%f3, %f0, %f0
	fmul	%f3, %f3, %f1
	fdiv	%f2, %f3, %f2
	fsub	%f0, %f0, %f6
	jmp	atan_sub.2692
fjge_else.30671:
	fmov	%f0, %f2
	return
fjge_else.30670:
	fmov	%f0, %f2
	return
sin_sub.2700:
	fld	%f1, %g29, -8
	fjlt	%f1, %f0, fjge_else.30672
	setL %g3, l.22821
	fld	%f2, %g3, 0
	fjlt	%f0, %f2, fjge_else.30673
	return
fjge_else.30673:
	fadd	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.30674
	fjlt	%f0, %f2, fjge_else.30675
	return
fjge_else.30675:
	fadd	%f0, %f0, %f1
	ld	%g28, %g29, 0
	b	%g28
fjge_else.30674:
	fsub	%f0, %f0, %f1
	ld	%g28, %g29, 0
	b	%g28
fjge_else.30672:
	fsub	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.30676
	setL %g3, l.22821
	fld	%f2, %g3, 0
	fjlt	%f0, %f2, fjge_else.30677
	return
fjge_else.30677:
	fadd	%f0, %f0, %f1
	ld	%g28, %g29, 0
	b	%g28
fjge_else.30676:
	fsub	%f0, %f0, %f1
	ld	%g28, %g29, 0
	b	%g28
read_int_token.2710:
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	st	%g3, %g1, 0
	st	%g29, %g1, 4
	st	%g6, %g1, 8
	st	%g4, %g1, 12
	st	%g5, %g1, 16
	input	%g3
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 48
	jlt	%g4, %g3, jle_else.30678
	mvhi	%g3, 0
	mvlo	%g3, 57
	jlt	%g3, %g4, jle_else.30680
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jle_cont.30681
jle_else.30680:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.30681:
	jmp	jle_cont.30679
jle_else.30678:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.30679:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.30682
	ld	%g3, %g1, 16
	ld	%g6, %g3, 0
	jne	%g6, %g5, jeq_else.30683
	mvhi	%g5, 0
	mvlo	%g5, 45
	ld	%g6, %g1, 12
	jne	%g6, %g5, jeq_else.30685
	mvhi	%g5, 65535
	mvlo	%g5, -1
	st	%g5, %g3, 0
	jmp	jeq_cont.30686
jeq_else.30685:
	mvhi	%g5, 0
	mvlo	%g5, 1
	st	%g5, %g3, 0
jeq_cont.30686:
	jmp	jeq_cont.30684
jeq_else.30683:
jeq_cont.30684:
	subi	%g3, %g4, 48
	ld	%g5, %g1, 8
	ld	%g6, %g5, 0
	muli	%g7, %g6, 2
	muli	%g6, %g6, 8
	add	%g6, %g6, %g7
	add	%g3, %g6, %g3
	st	%g3, %g5, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.30682:
	ld	%g3, %g1, 0
	jne	%g3, %g5, jeq_else.30687
	ld	%g29, %g1, 4
	mov	%g3, %g5
	ld	%g28, %g29, 0
	b	%g28
jeq_else.30687:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 16
	ld	%g4, %g4, 0
	jne	%g4, %g3, jeq_else.30688
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	return
jeq_else.30688:
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	sub	%g3, %g0, %g3
	return
read_float_token1.2719:
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	st	%g3, %g1, 0
	st	%g29, %g1, 4
	st	%g6, %g1, 8
	st	%g4, %g1, 12
	st	%g5, %g1, 16
	input	%g3
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 48
	jlt	%g4, %g3, jle_else.30689
	mvhi	%g3, 0
	mvlo	%g3, 57
	jlt	%g3, %g4, jle_else.30691
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jle_cont.30692
jle_else.30691:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.30692:
	jmp	jle_cont.30690
jle_else.30689:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.30690:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.30693
	ld	%g3, %g1, 16
	ld	%g6, %g3, 0
	jne	%g6, %g5, jeq_else.30694
	mvhi	%g5, 0
	mvlo	%g5, 45
	ld	%g6, %g1, 12
	jne	%g6, %g5, jeq_else.30696
	mvhi	%g5, 65535
	mvlo	%g5, -1
	st	%g5, %g3, 0
	jmp	jeq_cont.30697
jeq_else.30696:
	mvhi	%g5, 0
	mvlo	%g5, 1
	st	%g5, %g3, 0
jeq_cont.30697:
	jmp	jeq_cont.30695
jeq_else.30694:
jeq_cont.30695:
	subi	%g3, %g4, 48
	ld	%g5, %g1, 8
	ld	%g6, %g5, 0
	muli	%g7, %g6, 2
	muli	%g6, %g6, 8
	add	%g6, %g6, %g7
	add	%g3, %g6, %g3
	st	%g3, %g5, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.30693:
	ld	%g3, %g1, 0
	jne	%g3, %g5, jeq_else.30698
	ld	%g29, %g1, 4
	mov	%g3, %g5
	ld	%g28, %g29, 0
	b	%g28
jeq_else.30698:
	mov	%g3, %g4
	return
read_float_token2.2722:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	st	%g3, %g1, 0
	st	%g29, %g1, 4
	st	%g5, %g1, 8
	st	%g4, %g1, 12
	input	%g3
	mvhi	%g4, 0
	mvlo	%g4, 48
	jlt	%g3, %g4, jle_else.30699
	mvhi	%g4, 0
	mvlo	%g4, 57
	jlt	%g4, %g3, jle_else.30701
	mvhi	%g4, 0
	mvlo	%g4, 0
	jmp	jle_cont.30702
jle_else.30701:
	mvhi	%g4, 0
	mvlo	%g4, 1
jle_cont.30702:
	jmp	jle_cont.30700
jle_else.30699:
	mvhi	%g4, 0
	mvlo	%g4, 1
jle_cont.30700:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g4, %g5, jeq_else.30703
	subi	%g3, %g3, 48
	ld	%g4, %g1, 12
	ld	%g5, %g4, 0
	muli	%g6, %g5, 2
	muli	%g5, %g5, 8
	add	%g5, %g5, %g6
	add	%g3, %g5, %g3
	st	%g3, %g4, 0
	ld	%g3, %g1, 8
	ld	%g4, %g3, 0
	muli	%g5, %g4, 2
	muli	%g4, %g4, 8
	add	%g4, %g4, %g5
	st	%g4, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.30703:
	ld	%g3, %g1, 0
	jne	%g3, %g5, jeq_else.30704
	ld	%g29, %g1, 4
	mov	%g3, %g5
	ld	%g28, %g29, 0
	b	%g28
jeq_else.30704:
	return
print_int_get_digits.2728:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g7, %g4, 0
	jlt	%g6, %g7, jle_else.30706
	subi	%g3, %g3, 1
	return
jle_else.30706:
	divi	%g8, %g7, 10
	muli	%g9, %g8, 10
	sub	%g7, %g7, %g9
	slli	%g9, %g3, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g9
	st	%g7, %g5, 0
	ld	%g5, %g1, 4
	st	%g8, %g4, 0
	addi	%g3, %g3, 1
	ld	%g7, %g4, 0
	jlt	%g6, %g7, jle_else.30707
	subi	%g3, %g3, 1
	return
jle_else.30707:
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
print_int_print_digits.2730:
	ld	%g4, %g29, -4
	mvhi	%g5, 0
	mvlo	%g5, 0
	jlt	%g3, %g5, jle_else.30708
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
jle_else.30708:
	return
tan_sub.6499.6594.6640.7620.8018.9101:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.30710
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f5, %f0, %f4
	fsub	%f0, %f0, %f2
	fdiv	%f0, %f1, %f0
	fjlt	%f5, %f3, fjge_else.30711
	fsub	%f2, %f5, %f4
	fsub	%f0, %f5, %f0
	fdiv	%f0, %f1, %f0
	fjlt	%f2, %f3, fjge_else.30712
	fsub	%f5, %f2, %f4
	fsub	%f0, %f2, %f0
	fdiv	%f0, %f1, %f0
	fjlt	%f5, %f3, fjge_else.30713
	fsub	%f2, %f5, %f4
	fsub	%f0, %f5, %f0
	fdiv	%f0, %f1, %f0
	fmov	%f31, %f2
	fmov	%f2, %f0
	fmov	%f0, %f31
	jmp	tan_sub.6499.6594.6640.7620.8018.9101
fjge_else.30713:
	return
fjge_else.30712:
	return
fjge_else.30711:
	return
fjge_else.30710:
	fmov	%f0, %f2
	return
tan_sub.6499.6594.7571.7969.9052:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.30714
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f5, %f0, %f4
	fsub	%f0, %f0, %f2
	fdiv	%f0, %f1, %f0
	fjlt	%f5, %f3, fjge_else.30715
	fsub	%f2, %f5, %f4
	fsub	%f0, %f5, %f0
	fdiv	%f0, %f1, %f0
	fjlt	%f2, %f3, fjge_else.30716
	fsub	%f5, %f2, %f4
	fsub	%f0, %f2, %f0
	fdiv	%f0, %f1, %f0
	fjlt	%f5, %f3, fjge_else.30717
	fsub	%f2, %f5, %f4
	fsub	%f0, %f5, %f0
	fdiv	%f0, %f1, %f0
	fmov	%f31, %f2
	fmov	%f2, %f0
	fmov	%f0, %f31
	jmp	tan_sub.6499.6594.7571.7969.9052
fjge_else.30717:
	return
fjge_else.30716:
	return
fjge_else.30715:
	return
fjge_else.30714:
	fmov	%f0, %f2
	return
tan_sub.6499.6594.6640.7524.7922.9005:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.30718
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f5, %f0, %f4
	fsub	%f0, %f0, %f2
	fdiv	%f0, %f1, %f0
	fjlt	%f5, %f3, fjge_else.30719
	fsub	%f2, %f5, %f4
	fsub	%f0, %f5, %f0
	fdiv	%f0, %f1, %f0
	fjlt	%f2, %f3, fjge_else.30720
	fsub	%f5, %f2, %f4
	fsub	%f0, %f2, %f0
	fdiv	%f0, %f1, %f0
	fjlt	%f5, %f3, fjge_else.30721
	fsub	%f2, %f5, %f4
	fsub	%f0, %f5, %f0
	fdiv	%f0, %f1, %f0
	fmov	%f31, %f2
	fmov	%f2, %f0
	fmov	%f0, %f31
	jmp	tan_sub.6499.6594.6640.7524.7922.9005
fjge_else.30721:
	return
fjge_else.30720:
	return
fjge_else.30719:
	return
fjge_else.30718:
	fmov	%f0, %f2
	return
tan_sub.6499.6594.7475.7873.8956:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.30722
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f5, %f0, %f4
	fsub	%f0, %f0, %f2
	fdiv	%f0, %f1, %f0
	fjlt	%f5, %f3, fjge_else.30723
	fsub	%f2, %f5, %f4
	fsub	%f0, %f5, %f0
	fdiv	%f0, %f1, %f0
	fjlt	%f2, %f3, fjge_else.30724
	fsub	%f5, %f2, %f4
	fsub	%f0, %f2, %f0
	fdiv	%f0, %f1, %f0
	fjlt	%f5, %f3, fjge_else.30725
	fsub	%f2, %f5, %f4
	fsub	%f0, %f5, %f0
	fdiv	%f0, %f1, %f0
	fmov	%f31, %f2
	fmov	%f2, %f0
	fmov	%f0, %f31
	jmp	tan_sub.6499.6594.7475.7873.8956
fjge_else.30725:
	return
fjge_else.30724:
	return
fjge_else.30723:
	return
fjge_else.30722:
	fmov	%f0, %f2
	return
tan_sub.6499.6594.6640.7428.7826.8909:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.30726
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f5, %f0, %f4
	fsub	%f0, %f0, %f2
	fdiv	%f0, %f1, %f0
	fjlt	%f5, %f3, fjge_else.30727
	fsub	%f2, %f5, %f4
	fsub	%f0, %f5, %f0
	fdiv	%f0, %f1, %f0
	fjlt	%f2, %f3, fjge_else.30728
	fsub	%f5, %f2, %f4
	fsub	%f0, %f2, %f0
	fdiv	%f0, %f1, %f0
	fjlt	%f5, %f3, fjge_else.30729
	fsub	%f2, %f5, %f4
	fsub	%f0, %f5, %f0
	fdiv	%f0, %f1, %f0
	fmov	%f31, %f2
	fmov	%f2, %f0
	fmov	%f0, %f31
	jmp	tan_sub.6499.6594.6640.7428.7826.8909
fjge_else.30729:
	return
fjge_else.30728:
	return
fjge_else.30727:
	return
fjge_else.30726:
	fmov	%f0, %f2
	return
tan_sub.6499.6594.7379.7777.8860:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.30730
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f5, %f0, %f4
	fsub	%f0, %f0, %f2
	fdiv	%f0, %f1, %f0
	fjlt	%f5, %f3, fjge_else.30731
	fsub	%f2, %f5, %f4
	fsub	%f0, %f5, %f0
	fdiv	%f0, %f1, %f0
	fjlt	%f2, %f3, fjge_else.30732
	fsub	%f5, %f2, %f4
	fsub	%f0, %f2, %f0
	fdiv	%f0, %f1, %f0
	fjlt	%f5, %f3, fjge_else.30733
	fsub	%f2, %f5, %f4
	fsub	%f0, %f5, %f0
	fdiv	%f0, %f1, %f0
	fmov	%f31, %f2
	fmov	%f2, %f0
	fmov	%f0, %f31
	jmp	tan_sub.6499.6594.7379.7777.8860
fjge_else.30733:
	return
fjge_else.30732:
	return
fjge_else.30731:
	return
fjge_else.30730:
	fmov	%f0, %f2
	return
read_object.2903:
	ld	%g4, %g29, -76
	ld	%g5, %g29, -72
	ld	%g6, %g29, -68
	ld	%g7, %g29, -64
	ld	%g8, %g29, -60
	ld	%g9, %g29, -56
	ld	%g10, %g29, -52
	ld	%g11, %g29, -48
	ld	%g12, %g29, -44
	ld	%g13, %g29, -40
	fld	%f0, %g29, -32
	fld	%f1, %g29, -24
	fld	%f2, %g29, -16
	ld	%g14, %g29, -8
	ld	%g15, %g29, -4
	mvhi	%g16, 0
	mvlo	%g16, 60
	jlt	%g3, %g16, jle_else.30734
	return
jle_else.30734:
	mvhi	%g16, 0
	mvlo	%g16, 0
	st	%g16, %g7, 0
	st	%g16, %g6, 0
	mvhi	%g17, 0
	mvlo	%g17, 32
	st	%g29, %g1, 0
	st	%g15, %g1, 4
	fst	%f0, %g1, 8
	fst	%f2, %g1, 12
	st	%g4, %g1, 16
	fst	%f1, %g1, 20
	st	%g14, %g1, 24
	st	%g3, %g1, 28
	st	%g8, %g1, 32
	st	%g9, %g1, 36
	st	%g10, %g1, 40
	st	%g13, %g1, 44
	st	%g12, %g1, 48
	st	%g11, %g1, 52
	st	%g17, %g1, 56
	st	%g5, %g1, 60
	st	%g6, %g1, 64
	st	%g7, %g1, 68
	st	%g16, %g1, 72
	mov	%g4, %g17
	mov	%g3, %g16
	mov	%g29, %g5
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 65535
	mvlo	%g4, -1
	mvhi	%g5, 0
	mvlo	%g5, 1
	jne	%g3, %g4, jeq_else.30736
	ld	%g3, %g1, 72
	mov	%g4, %g3
	jmp	jeq_cont.30737
jeq_else.30736:
	ld	%g4, %g1, 68
	ld	%g6, %g1, 72
	st	%g6, %g4, 0
	ld	%g7, %g1, 64
	st	%g6, %g7, 0
	ld	%g8, %g1, 56
	ld	%g29, %g1, 60
	st	%g3, %g1, 76
	st	%g5, %g1, 80
	mov	%g4, %g8
	mov	%g3, %g6
	st	%g31, %g1, 84
	ld	%g28, %g29, 0
	subi	%g1, %g1, 88
	callR	%g28
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	ld	%g4, %g1, 68
	ld	%g5, %g1, 72
	st	%g5, %g4, 0
	ld	%g6, %g1, 64
	st	%g5, %g6, 0
	ld	%g7, %g1, 56
	ld	%g29, %g1, 60
	st	%g3, %g1, 84
	mov	%g4, %g7
	mov	%g3, %g5
	st	%g31, %g1, 92
	ld	%g28, %g29, 0
	subi	%g1, %g1, 96
	callR	%g28
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	ld	%g4, %g1, 68
	ld	%g5, %g1, 72
	st	%g5, %g4, 0
	ld	%g4, %g1, 64
	st	%g5, %g4, 0
	ld	%g4, %g1, 56
	ld	%g29, %g1, 60
	st	%g3, %g1, 88
	mov	%g3, %g5
	st	%g31, %g1, 92
	ld	%g28, %g29, 0
	subi	%g1, %g1, 96
	callR	%g28
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.22821
	fld	%f0, %g5, 0
	st	%g3, %g1, 92
	fst	%f0, %g1, 96
	st	%g4, %g1, 100
	mov	%g3, %g4
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	min_caml_create_float_array
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	ld	%g4, %g1, 52
	ld	%g5, %g1, 72
	st	%g5, %g4, 0
	ld	%g6, %g1, 48
	st	%g5, %g6, 0
	ld	%g7, %g1, 44
	ld	%g8, %g1, 80
	st	%g8, %g7, 0
	ld	%g9, %g1, 40
	st	%g5, %g9, 0
	ld	%g10, %g1, 56
	ld	%g29, %g1, 36
	st	%g3, %g1, 104
	mov	%g4, %g10
	mov	%g3, %g5
	st	%g31, %g1, 108
	ld	%g28, %g29, 0
	subi	%g1, %g1, 112
	callR	%g28
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	mvhi	%g4, 0
	mvlo	%g4, 46
	st	%g4, %g1, 108
	jne	%g3, %g4, jeq_else.30738
	ld	%g3, %g1, 72
	ld	%g29, %g1, 32
	st	%g31, %g1, 116
	ld	%g28, %g29, 0
	subi	%g1, %g1, 120
	callR	%g28
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	ld	%g3, %g1, 52
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	min_caml_float_of_int
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	ld	%g3, %g1, 48
	ld	%g4, %g3, 0
	fst	%f0, %g1, 112
	mov	%g3, %g4
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	min_caml_float_of_int
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	fst	%f0, %g1, 116
	mov	%g3, %g4
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	min_caml_float_of_int
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	fld	%f1, %g1, 116
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 112
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.30739
jeq_else.30738:
	ld	%g3, %g1, 52
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	min_caml_float_of_int
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
jeq_cont.30739:
	ld	%g3, %g1, 40
	ld	%g4, %g3, 0
	ld	%g5, %g1, 80
	jne	%g4, %g5, jeq_else.30740
	jmp	jeq_cont.30741
jeq_else.30740:
	fneg	%f0, %f0
jeq_cont.30741:
	ld	%g4, %g1, 104
	fst	%f0, %g4, 0
	ld	%g6, %g1, 52
	ld	%g7, %g1, 72
	st	%g7, %g6, 0
	ld	%g8, %g1, 48
	st	%g7, %g8, 0
	ld	%g9, %g1, 44
	st	%g5, %g9, 0
	st	%g7, %g3, 0
	ld	%g10, %g1, 56
	ld	%g29, %g1, 36
	mov	%g4, %g10
	mov	%g3, %g7
	st	%g31, %g1, 124
	ld	%g28, %g29, 0
	subi	%g1, %g1, 128
	callR	%g28
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	ld	%g4, %g1, 108
	jne	%g3, %g4, jeq_else.30742
	ld	%g3, %g1, 72
	ld	%g29, %g1, 32
	st	%g31, %g1, 124
	ld	%g28, %g29, 0
	subi	%g1, %g1, 128
	callR	%g28
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	ld	%g3, %g1, 52
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	min_caml_float_of_int
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	ld	%g3, %g1, 48
	ld	%g4, %g3, 0
	fst	%f0, %g1, 120
	mov	%g3, %g4
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	min_caml_float_of_int
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	fst	%f0, %g1, 124
	mov	%g3, %g4
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	min_caml_float_of_int
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	fld	%f1, %g1, 124
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 120
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.30743
jeq_else.30742:
	ld	%g3, %g1, 52
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	min_caml_float_of_int
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
jeq_cont.30743:
	ld	%g3, %g1, 40
	ld	%g4, %g3, 0
	ld	%g5, %g1, 80
	jne	%g4, %g5, jeq_else.30744
	jmp	jeq_cont.30745
jeq_else.30744:
	fneg	%f0, %f0
jeq_cont.30745:
	ld	%g4, %g1, 104
	fst	%f0, %g4, -4
	mvhi	%g6, 0
	mvlo	%g6, 2
	ld	%g7, %g1, 52
	ld	%g8, %g1, 72
	st	%g8, %g7, 0
	ld	%g9, %g1, 48
	st	%g8, %g9, 0
	ld	%g10, %g1, 44
	st	%g5, %g10, 0
	st	%g8, %g3, 0
	ld	%g11, %g1, 56
	ld	%g29, %g1, 36
	st	%g6, %g1, 128
	mov	%g4, %g11
	mov	%g3, %g8
	st	%g31, %g1, 132
	ld	%g28, %g29, 0
	subi	%g1, %g1, 136
	callR	%g28
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g4, %g1, 108
	jne	%g3, %g4, jeq_else.30746
	ld	%g3, %g1, 72
	ld	%g29, %g1, 32
	st	%g31, %g1, 132
	ld	%g28, %g29, 0
	subi	%g1, %g1, 136
	callR	%g28
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g3, %g1, 52
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	min_caml_float_of_int
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g3, %g1, 48
	ld	%g4, %g3, 0
	fst	%f0, %g1, 132
	mov	%g3, %g4
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	min_caml_float_of_int
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	fst	%f0, %g1, 136
	mov	%g3, %g4
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	min_caml_float_of_int
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	fld	%f1, %g1, 136
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 132
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.30747
jeq_else.30746:
	ld	%g3, %g1, 52
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	min_caml_float_of_int
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
jeq_cont.30747:
	ld	%g3, %g1, 40
	ld	%g4, %g3, 0
	ld	%g5, %g1, 80
	jne	%g4, %g5, jeq_else.30748
	jmp	jeq_cont.30749
jeq_else.30748:
	fneg	%f0, %f0
jeq_cont.30749:
	ld	%g4, %g1, 104
	fst	%f0, %g4, -8
	fld	%f0, %g1, 96
	ld	%g6, %g1, 100
	mov	%g3, %g6
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	min_caml_create_float_array
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g4, %g1, 52
	ld	%g5, %g1, 72
	st	%g5, %g4, 0
	ld	%g6, %g1, 48
	st	%g5, %g6, 0
	ld	%g7, %g1, 44
	ld	%g8, %g1, 80
	st	%g8, %g7, 0
	ld	%g9, %g1, 40
	st	%g5, %g9, 0
	ld	%g10, %g1, 56
	ld	%g29, %g1, 36
	st	%g3, %g1, 140
	mov	%g4, %g10
	mov	%g3, %g5
	st	%g31, %g1, 148
	ld	%g28, %g29, 0
	subi	%g1, %g1, 152
	callR	%g28
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	ld	%g4, %g1, 108
	jne	%g3, %g4, jeq_else.30750
	ld	%g3, %g1, 72
	ld	%g29, %g1, 32
	st	%g31, %g1, 148
	ld	%g28, %g29, 0
	subi	%g1, %g1, 152
	callR	%g28
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	ld	%g3, %g1, 52
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	min_caml_float_of_int
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	ld	%g3, %g1, 48
	ld	%g4, %g3, 0
	fst	%f0, %g1, 144
	mov	%g3, %g4
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	min_caml_float_of_int
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	fst	%f0, %g1, 148
	mov	%g3, %g4
	st	%g31, %g1, 156
	subi	%g1, %g1, 160
	call	min_caml_float_of_int
	addi	%g1, %g1, 160
	ld	%g31, %g1, 156
	fld	%f1, %g1, 148
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 144
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.30751
jeq_else.30750:
	ld	%g3, %g1, 52
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 156
	subi	%g1, %g1, 160
	call	min_caml_float_of_int
	addi	%g1, %g1, 160
	ld	%g31, %g1, 156
jeq_cont.30751:
	ld	%g3, %g1, 40
	ld	%g4, %g3, 0
	ld	%g5, %g1, 80
	jne	%g4, %g5, jeq_else.30752
	jmp	jeq_cont.30753
jeq_else.30752:
	fneg	%f0, %f0
jeq_cont.30753:
	ld	%g4, %g1, 140
	fst	%f0, %g4, 0
	ld	%g6, %g1, 52
	ld	%g7, %g1, 72
	st	%g7, %g6, 0
	ld	%g8, %g1, 48
	st	%g7, %g8, 0
	ld	%g9, %g1, 44
	st	%g5, %g9, 0
	st	%g7, %g3, 0
	ld	%g10, %g1, 56
	ld	%g29, %g1, 36
	mov	%g4, %g10
	mov	%g3, %g7
	st	%g31, %g1, 156
	ld	%g28, %g29, 0
	subi	%g1, %g1, 160
	callR	%g28
	addi	%g1, %g1, 160
	ld	%g31, %g1, 156
	ld	%g4, %g1, 108
	jne	%g3, %g4, jeq_else.30754
	ld	%g3, %g1, 72
	ld	%g29, %g1, 32
	st	%g31, %g1, 156
	ld	%g28, %g29, 0
	subi	%g1, %g1, 160
	callR	%g28
	addi	%g1, %g1, 160
	ld	%g31, %g1, 156
	ld	%g3, %g1, 52
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 156
	subi	%g1, %g1, 160
	call	min_caml_float_of_int
	addi	%g1, %g1, 160
	ld	%g31, %g1, 156
	ld	%g3, %g1, 48
	ld	%g4, %g3, 0
	fst	%f0, %g1, 152
	mov	%g3, %g4
	st	%g31, %g1, 156
	subi	%g1, %g1, 160
	call	min_caml_float_of_int
	addi	%g1, %g1, 160
	ld	%g31, %g1, 156
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	fst	%f0, %g1, 156
	mov	%g3, %g4
	st	%g31, %g1, 164
	subi	%g1, %g1, 168
	call	min_caml_float_of_int
	addi	%g1, %g1, 168
	ld	%g31, %g1, 164
	fld	%f1, %g1, 156
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 152
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.30755
jeq_else.30754:
	ld	%g3, %g1, 52
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 164
	subi	%g1, %g1, 168
	call	min_caml_float_of_int
	addi	%g1, %g1, 168
	ld	%g31, %g1, 164
jeq_cont.30755:
	ld	%g3, %g1, 40
	ld	%g4, %g3, 0
	ld	%g5, %g1, 80
	jne	%g4, %g5, jeq_else.30756
	jmp	jeq_cont.30757
jeq_else.30756:
	fneg	%f0, %f0
jeq_cont.30757:
	ld	%g4, %g1, 140
	fst	%f0, %g4, -4
	ld	%g6, %g1, 52
	ld	%g7, %g1, 72
	st	%g7, %g6, 0
	ld	%g8, %g1, 48
	st	%g7, %g8, 0
	ld	%g9, %g1, 44
	st	%g5, %g9, 0
	st	%g7, %g3, 0
	ld	%g10, %g1, 56
	ld	%g29, %g1, 36
	mov	%g4, %g10
	mov	%g3, %g7
	st	%g31, %g1, 164
	ld	%g28, %g29, 0
	subi	%g1, %g1, 168
	callR	%g28
	addi	%g1, %g1, 168
	ld	%g31, %g1, 164
	ld	%g4, %g1, 108
	jne	%g3, %g4, jeq_else.30758
	ld	%g3, %g1, 72
	ld	%g29, %g1, 32
	st	%g31, %g1, 164
	ld	%g28, %g29, 0
	subi	%g1, %g1, 168
	callR	%g28
	addi	%g1, %g1, 168
	ld	%g31, %g1, 164
	ld	%g3, %g1, 52
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 164
	subi	%g1, %g1, 168
	call	min_caml_float_of_int
	addi	%g1, %g1, 168
	ld	%g31, %g1, 164
	ld	%g3, %g1, 48
	ld	%g4, %g3, 0
	fst	%f0, %g1, 160
	mov	%g3, %g4
	st	%g31, %g1, 164
	subi	%g1, %g1, 168
	call	min_caml_float_of_int
	addi	%g1, %g1, 168
	ld	%g31, %g1, 164
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	fst	%f0, %g1, 164
	mov	%g3, %g4
	st	%g31, %g1, 172
	subi	%g1, %g1, 176
	call	min_caml_float_of_int
	addi	%g1, %g1, 176
	ld	%g31, %g1, 172
	fld	%f1, %g1, 164
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 160
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.30759
jeq_else.30758:
	ld	%g3, %g1, 52
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 172
	subi	%g1, %g1, 176
	call	min_caml_float_of_int
	addi	%g1, %g1, 176
	ld	%g31, %g1, 172
jeq_cont.30759:
	ld	%g3, %g1, 40
	ld	%g4, %g3, 0
	ld	%g5, %g1, 80
	jne	%g4, %g5, jeq_else.30760
	jmp	jeq_cont.30761
jeq_else.30760:
	fneg	%f0, %f0
jeq_cont.30761:
	ld	%g4, %g1, 140
	fst	%f0, %g4, -8
	ld	%g6, %g1, 52
	ld	%g7, %g1, 72
	st	%g7, %g6, 0
	ld	%g8, %g1, 48
	st	%g7, %g8, 0
	ld	%g9, %g1, 44
	st	%g5, %g9, 0
	st	%g7, %g3, 0
	ld	%g10, %g1, 56
	ld	%g29, %g1, 36
	mov	%g4, %g10
	mov	%g3, %g7
	st	%g31, %g1, 172
	ld	%g28, %g29, 0
	subi	%g1, %g1, 176
	callR	%g28
	addi	%g1, %g1, 176
	ld	%g31, %g1, 172
	ld	%g4, %g1, 108
	jne	%g3, %g4, jeq_else.30762
	ld	%g3, %g1, 72
	ld	%g29, %g1, 32
	st	%g31, %g1, 172
	ld	%g28, %g29, 0
	subi	%g1, %g1, 176
	callR	%g28
	addi	%g1, %g1, 176
	ld	%g31, %g1, 172
	ld	%g3, %g1, 52
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 172
	subi	%g1, %g1, 176
	call	min_caml_float_of_int
	addi	%g1, %g1, 176
	ld	%g31, %g1, 172
	ld	%g3, %g1, 48
	ld	%g4, %g3, 0
	fst	%f0, %g1, 168
	mov	%g3, %g4
	st	%g31, %g1, 172
	subi	%g1, %g1, 176
	call	min_caml_float_of_int
	addi	%g1, %g1, 176
	ld	%g31, %g1, 172
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	fst	%f0, %g1, 172
	mov	%g3, %g4
	st	%g31, %g1, 180
	subi	%g1, %g1, 184
	call	min_caml_float_of_int
	addi	%g1, %g1, 184
	ld	%g31, %g1, 180
	fld	%f1, %g1, 172
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 168
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.30763
jeq_else.30762:
	ld	%g3, %g1, 52
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 180
	subi	%g1, %g1, 184
	call	min_caml_float_of_int
	addi	%g1, %g1, 184
	ld	%g31, %g1, 180
jeq_cont.30763:
	ld	%g3, %g1, 40
	ld	%g4, %g3, 0
	ld	%g5, %g1, 80
	jne	%g4, %g5, jeq_else.30764
	jmp	jeq_cont.30765
jeq_else.30764:
	fneg	%f0, %f0
jeq_cont.30765:
	fld	%f1, %g1, 96
	fjlt	%f0, %f1, fjge_else.30766
	ld	%g4, %g1, 72
	jmp	fjge_cont.30767
fjge_else.30766:
	mov	%g4, %g5
fjge_cont.30767:
	ld	%g6, %g1, 128
	st	%g4, %g1, 176
	mov	%g3, %g6
	fmov	%f0, %f1
	st	%g31, %g1, 180
	subi	%g1, %g1, 184
	call	min_caml_create_float_array
	addi	%g1, %g1, 184
	ld	%g31, %g1, 180
	ld	%g4, %g1, 52
	ld	%g5, %g1, 72
	st	%g5, %g4, 0
	ld	%g6, %g1, 48
	st	%g5, %g6, 0
	ld	%g7, %g1, 44
	ld	%g8, %g1, 80
	st	%g8, %g7, 0
	ld	%g9, %g1, 40
	st	%g5, %g9, 0
	ld	%g10, %g1, 56
	ld	%g29, %g1, 36
	st	%g3, %g1, 180
	mov	%g4, %g10
	mov	%g3, %g5
	st	%g31, %g1, 188
	ld	%g28, %g29, 0
	subi	%g1, %g1, 192
	callR	%g28
	addi	%g1, %g1, 192
	ld	%g31, %g1, 188
	ld	%g4, %g1, 108
	jne	%g3, %g4, jeq_else.30768
	ld	%g3, %g1, 72
	ld	%g29, %g1, 32
	st	%g31, %g1, 188
	ld	%g28, %g29, 0
	subi	%g1, %g1, 192
	callR	%g28
	addi	%g1, %g1, 192
	ld	%g31, %g1, 188
	ld	%g3, %g1, 52
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 188
	subi	%g1, %g1, 192
	call	min_caml_float_of_int
	addi	%g1, %g1, 192
	ld	%g31, %g1, 188
	ld	%g3, %g1, 48
	ld	%g4, %g3, 0
	fst	%f0, %g1, 184
	mov	%g3, %g4
	st	%g31, %g1, 188
	subi	%g1, %g1, 192
	call	min_caml_float_of_int
	addi	%g1, %g1, 192
	ld	%g31, %g1, 188
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	fst	%f0, %g1, 188
	mov	%g3, %g4
	st	%g31, %g1, 196
	subi	%g1, %g1, 200
	call	min_caml_float_of_int
	addi	%g1, %g1, 200
	ld	%g31, %g1, 196
	fld	%f1, %g1, 188
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 184
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.30769
jeq_else.30768:
	ld	%g3, %g1, 52
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 196
	subi	%g1, %g1, 200
	call	min_caml_float_of_int
	addi	%g1, %g1, 200
	ld	%g31, %g1, 196
jeq_cont.30769:
	ld	%g3, %g1, 40
	ld	%g4, %g3, 0
	ld	%g5, %g1, 80
	jne	%g4, %g5, jeq_else.30770
	jmp	jeq_cont.30771
jeq_else.30770:
	fneg	%f0, %f0
jeq_cont.30771:
	ld	%g4, %g1, 180
	fst	%f0, %g4, 0
	ld	%g6, %g1, 52
	ld	%g7, %g1, 72
	st	%g7, %g6, 0
	ld	%g8, %g1, 48
	st	%g7, %g8, 0
	ld	%g9, %g1, 44
	st	%g5, %g9, 0
	st	%g7, %g3, 0
	ld	%g10, %g1, 56
	ld	%g29, %g1, 36
	mov	%g4, %g10
	mov	%g3, %g7
	st	%g31, %g1, 196
	ld	%g28, %g29, 0
	subi	%g1, %g1, 200
	callR	%g28
	addi	%g1, %g1, 200
	ld	%g31, %g1, 196
	ld	%g4, %g1, 108
	jne	%g3, %g4, jeq_else.30772
	ld	%g3, %g1, 72
	ld	%g29, %g1, 32
	st	%g31, %g1, 196
	ld	%g28, %g29, 0
	subi	%g1, %g1, 200
	callR	%g28
	addi	%g1, %g1, 200
	ld	%g31, %g1, 196
	ld	%g3, %g1, 52
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 196
	subi	%g1, %g1, 200
	call	min_caml_float_of_int
	addi	%g1, %g1, 200
	ld	%g31, %g1, 196
	ld	%g3, %g1, 48
	ld	%g4, %g3, 0
	fst	%f0, %g1, 192
	mov	%g3, %g4
	st	%g31, %g1, 196
	subi	%g1, %g1, 200
	call	min_caml_float_of_int
	addi	%g1, %g1, 200
	ld	%g31, %g1, 196
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	fst	%f0, %g1, 196
	mov	%g3, %g4
	st	%g31, %g1, 204
	subi	%g1, %g1, 208
	call	min_caml_float_of_int
	addi	%g1, %g1, 208
	ld	%g31, %g1, 204
	fld	%f1, %g1, 196
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 192
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.30773
jeq_else.30772:
	ld	%g3, %g1, 52
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 204
	subi	%g1, %g1, 208
	call	min_caml_float_of_int
	addi	%g1, %g1, 208
	ld	%g31, %g1, 204
jeq_cont.30773:
	ld	%g3, %g1, 40
	ld	%g4, %g3, 0
	ld	%g5, %g1, 80
	jne	%g4, %g5, jeq_else.30774
	jmp	jeq_cont.30775
jeq_else.30774:
	fneg	%f0, %f0
jeq_cont.30775:
	ld	%g4, %g1, 180
	fst	%f0, %g4, -4
	fld	%f0, %g1, 96
	ld	%g6, %g1, 100
	mov	%g3, %g6
	st	%g31, %g1, 204
	subi	%g1, %g1, 208
	call	min_caml_create_float_array
	addi	%g1, %g1, 208
	ld	%g31, %g1, 204
	ld	%g4, %g1, 52
	ld	%g5, %g1, 72
	st	%g5, %g4, 0
	ld	%g6, %g1, 48
	st	%g5, %g6, 0
	ld	%g7, %g1, 44
	ld	%g8, %g1, 80
	st	%g8, %g7, 0
	ld	%g9, %g1, 40
	st	%g5, %g9, 0
	ld	%g10, %g1, 56
	ld	%g29, %g1, 36
	st	%g3, %g1, 200
	mov	%g4, %g10
	mov	%g3, %g5
	st	%g31, %g1, 204
	ld	%g28, %g29, 0
	subi	%g1, %g1, 208
	callR	%g28
	addi	%g1, %g1, 208
	ld	%g31, %g1, 204
	ld	%g4, %g1, 108
	jne	%g3, %g4, jeq_else.30776
	ld	%g3, %g1, 72
	ld	%g29, %g1, 32
	st	%g31, %g1, 204
	ld	%g28, %g29, 0
	subi	%g1, %g1, 208
	callR	%g28
	addi	%g1, %g1, 208
	ld	%g31, %g1, 204
	ld	%g3, %g1, 52
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 204
	subi	%g1, %g1, 208
	call	min_caml_float_of_int
	addi	%g1, %g1, 208
	ld	%g31, %g1, 204
	ld	%g3, %g1, 48
	ld	%g4, %g3, 0
	fst	%f0, %g1, 204
	mov	%g3, %g4
	st	%g31, %g1, 212
	subi	%g1, %g1, 216
	call	min_caml_float_of_int
	addi	%g1, %g1, 216
	ld	%g31, %g1, 212
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	fst	%f0, %g1, 208
	mov	%g3, %g4
	st	%g31, %g1, 212
	subi	%g1, %g1, 216
	call	min_caml_float_of_int
	addi	%g1, %g1, 216
	ld	%g31, %g1, 212
	fld	%f1, %g1, 208
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 204
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.30777
jeq_else.30776:
	ld	%g3, %g1, 52
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 212
	subi	%g1, %g1, 216
	call	min_caml_float_of_int
	addi	%g1, %g1, 216
	ld	%g31, %g1, 212
jeq_cont.30777:
	ld	%g3, %g1, 40
	ld	%g4, %g3, 0
	ld	%g5, %g1, 80
	jne	%g4, %g5, jeq_else.30778
	jmp	jeq_cont.30779
jeq_else.30778:
	fneg	%f0, %f0
jeq_cont.30779:
	ld	%g4, %g1, 200
	fst	%f0, %g4, 0
	ld	%g6, %g1, 52
	ld	%g7, %g1, 72
	st	%g7, %g6, 0
	ld	%g8, %g1, 48
	st	%g7, %g8, 0
	ld	%g9, %g1, 44
	st	%g5, %g9, 0
	st	%g7, %g3, 0
	ld	%g10, %g1, 56
	ld	%g29, %g1, 36
	mov	%g4, %g10
	mov	%g3, %g7
	st	%g31, %g1, 212
	ld	%g28, %g29, 0
	subi	%g1, %g1, 216
	callR	%g28
	addi	%g1, %g1, 216
	ld	%g31, %g1, 212
	ld	%g4, %g1, 108
	jne	%g3, %g4, jeq_else.30780
	ld	%g3, %g1, 72
	ld	%g29, %g1, 32
	st	%g31, %g1, 212
	ld	%g28, %g29, 0
	subi	%g1, %g1, 216
	callR	%g28
	addi	%g1, %g1, 216
	ld	%g31, %g1, 212
	ld	%g3, %g1, 52
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 212
	subi	%g1, %g1, 216
	call	min_caml_float_of_int
	addi	%g1, %g1, 216
	ld	%g31, %g1, 212
	ld	%g3, %g1, 48
	ld	%g4, %g3, 0
	fst	%f0, %g1, 212
	mov	%g3, %g4
	st	%g31, %g1, 220
	subi	%g1, %g1, 224
	call	min_caml_float_of_int
	addi	%g1, %g1, 224
	ld	%g31, %g1, 220
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	fst	%f0, %g1, 216
	mov	%g3, %g4
	st	%g31, %g1, 220
	subi	%g1, %g1, 224
	call	min_caml_float_of_int
	addi	%g1, %g1, 224
	ld	%g31, %g1, 220
	fld	%f1, %g1, 216
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 212
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.30781
jeq_else.30780:
	ld	%g3, %g1, 52
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 220
	subi	%g1, %g1, 224
	call	min_caml_float_of_int
	addi	%g1, %g1, 224
	ld	%g31, %g1, 220
jeq_cont.30781:
	ld	%g3, %g1, 40
	ld	%g4, %g3, 0
	ld	%g5, %g1, 80
	jne	%g4, %g5, jeq_else.30782
	jmp	jeq_cont.30783
jeq_else.30782:
	fneg	%f0, %f0
jeq_cont.30783:
	ld	%g4, %g1, 200
	fst	%f0, %g4, -4
	ld	%g6, %g1, 52
	ld	%g7, %g1, 72
	st	%g7, %g6, 0
	ld	%g8, %g1, 48
	st	%g7, %g8, 0
	ld	%g9, %g1, 44
	st	%g5, %g9, 0
	st	%g7, %g3, 0
	ld	%g10, %g1, 56
	ld	%g29, %g1, 36
	mov	%g4, %g10
	mov	%g3, %g7
	st	%g31, %g1, 220
	ld	%g28, %g29, 0
	subi	%g1, %g1, 224
	callR	%g28
	addi	%g1, %g1, 224
	ld	%g31, %g1, 220
	ld	%g4, %g1, 108
	jne	%g3, %g4, jeq_else.30784
	ld	%g3, %g1, 72
	ld	%g29, %g1, 32
	st	%g31, %g1, 220
	ld	%g28, %g29, 0
	subi	%g1, %g1, 224
	callR	%g28
	addi	%g1, %g1, 224
	ld	%g31, %g1, 220
	ld	%g3, %g1, 52
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 220
	subi	%g1, %g1, 224
	call	min_caml_float_of_int
	addi	%g1, %g1, 224
	ld	%g31, %g1, 220
	ld	%g3, %g1, 48
	ld	%g4, %g3, 0
	fst	%f0, %g1, 220
	mov	%g3, %g4
	st	%g31, %g1, 228
	subi	%g1, %g1, 232
	call	min_caml_float_of_int
	addi	%g1, %g1, 232
	ld	%g31, %g1, 228
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	fst	%f0, %g1, 224
	mov	%g3, %g4
	st	%g31, %g1, 228
	subi	%g1, %g1, 232
	call	min_caml_float_of_int
	addi	%g1, %g1, 232
	ld	%g31, %g1, 228
	fld	%f1, %g1, 224
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 220
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.30785
jeq_else.30784:
	ld	%g3, %g1, 52
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 228
	subi	%g1, %g1, 232
	call	min_caml_float_of_int
	addi	%g1, %g1, 232
	ld	%g31, %g1, 228
jeq_cont.30785:
	ld	%g3, %g1, 40
	ld	%g4, %g3, 0
	ld	%g5, %g1, 80
	jne	%g4, %g5, jeq_else.30786
	jmp	jeq_cont.30787
jeq_else.30786:
	fneg	%f0, %f0
jeq_cont.30787:
	ld	%g4, %g1, 200
	fst	%f0, %g4, -8
	fld	%f0, %g1, 96
	ld	%g6, %g1, 100
	mov	%g3, %g6
	st	%g31, %g1, 228
	subi	%g1, %g1, 232
	call	min_caml_create_float_array
	addi	%g1, %g1, 232
	ld	%g31, %g1, 228
	ld	%g4, %g1, 72
	ld	%g5, %g1, 92
	jne	%g5, %g4, jeq_else.30788
	jmp	jeq_cont.30789
jeq_else.30788:
	ld	%g6, %g1, 52
	st	%g4, %g6, 0
	ld	%g7, %g1, 48
	st	%g4, %g7, 0
	ld	%g8, %g1, 44
	ld	%g9, %g1, 80
	st	%g9, %g8, 0
	ld	%g10, %g1, 40
	st	%g4, %g10, 0
	ld	%g11, %g1, 56
	ld	%g29, %g1, 36
	st	%g3, %g1, 228
	mov	%g3, %g4
	mov	%g4, %g11
	st	%g31, %g1, 236
	ld	%g28, %g29, 0
	subi	%g1, %g1, 240
	callR	%g28
	addi	%g1, %g1, 240
	ld	%g31, %g1, 236
	ld	%g4, %g1, 108
	jne	%g3, %g4, jeq_else.30790
	ld	%g3, %g1, 72
	ld	%g29, %g1, 32
	st	%g31, %g1, 236
	ld	%g28, %g29, 0
	subi	%g1, %g1, 240
	callR	%g28
	addi	%g1, %g1, 240
	ld	%g31, %g1, 236
	ld	%g3, %g1, 52
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 236
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
	ld	%g31, %g1, 236
	ld	%g3, %g1, 48
	ld	%g4, %g3, 0
	fst	%f0, %g1, 232
	mov	%g3, %g4
	st	%g31, %g1, 236
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
	ld	%g31, %g1, 236
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	fst	%f0, %g1, 236
	mov	%g3, %g4
	st	%g31, %g1, 244
	subi	%g1, %g1, 248
	call	min_caml_float_of_int
	addi	%g1, %g1, 248
	ld	%g31, %g1, 244
	fld	%f1, %g1, 236
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 232
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.30791
jeq_else.30790:
	ld	%g3, %g1, 52
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 244
	subi	%g1, %g1, 248
	call	min_caml_float_of_int
	addi	%g1, %g1, 248
	ld	%g31, %g1, 244
jeq_cont.30791:
	ld	%g3, %g1, 40
	ld	%g4, %g3, 0
	ld	%g5, %g1, 80
	jne	%g4, %g5, jeq_else.30792
	jmp	jeq_cont.30793
jeq_else.30792:
	fneg	%f0, %f0
jeq_cont.30793:
	setL %g4, l.23075
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	ld	%g4, %g1, 228
	fst	%f0, %g4, 0
	ld	%g6, %g1, 52
	ld	%g7, %g1, 72
	st	%g7, %g6, 0
	ld	%g8, %g1, 48
	st	%g7, %g8, 0
	ld	%g9, %g1, 44
	st	%g5, %g9, 0
	st	%g7, %g3, 0
	ld	%g10, %g1, 56
	ld	%g29, %g1, 36
	fst	%f1, %g1, 240
	mov	%g4, %g10
	mov	%g3, %g7
	st	%g31, %g1, 244
	ld	%g28, %g29, 0
	subi	%g1, %g1, 248
	callR	%g28
	addi	%g1, %g1, 248
	ld	%g31, %g1, 244
	ld	%g4, %g1, 108
	jne	%g3, %g4, jeq_else.30794
	ld	%g3, %g1, 72
	ld	%g29, %g1, 32
	st	%g31, %g1, 244
	ld	%g28, %g29, 0
	subi	%g1, %g1, 248
	callR	%g28
	addi	%g1, %g1, 248
	ld	%g31, %g1, 244
	ld	%g3, %g1, 52
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 244
	subi	%g1, %g1, 248
	call	min_caml_float_of_int
	addi	%g1, %g1, 248
	ld	%g31, %g1, 244
	ld	%g3, %g1, 48
	ld	%g4, %g3, 0
	fst	%f0, %g1, 244
	mov	%g3, %g4
	st	%g31, %g1, 252
	subi	%g1, %g1, 256
	call	min_caml_float_of_int
	addi	%g1, %g1, 256
	ld	%g31, %g1, 252
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	fst	%f0, %g1, 248
	mov	%g3, %g4
	st	%g31, %g1, 252
	subi	%g1, %g1, 256
	call	min_caml_float_of_int
	addi	%g1, %g1, 256
	ld	%g31, %g1, 252
	fld	%f1, %g1, 248
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 244
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.30795
jeq_else.30794:
	ld	%g3, %g1, 52
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 252
	subi	%g1, %g1, 256
	call	min_caml_float_of_int
	addi	%g1, %g1, 256
	ld	%g31, %g1, 252
jeq_cont.30795:
	ld	%g3, %g1, 40
	ld	%g4, %g3, 0
	ld	%g5, %g1, 80
	jne	%g4, %g5, jeq_else.30796
	jmp	jeq_cont.30797
jeq_else.30796:
	fneg	%f0, %f0
jeq_cont.30797:
	fld	%f1, %g1, 240
	fmul	%f0, %f0, %f1
	ld	%g4, %g1, 228
	fst	%f0, %g4, -4
	ld	%g6, %g1, 52
	ld	%g7, %g1, 72
	st	%g7, %g6, 0
	ld	%g8, %g1, 48
	st	%g7, %g8, 0
	ld	%g9, %g1, 44
	st	%g5, %g9, 0
	st	%g7, %g3, 0
	ld	%g10, %g1, 56
	ld	%g29, %g1, 36
	mov	%g4, %g10
	mov	%g3, %g7
	st	%g31, %g1, 252
	ld	%g28, %g29, 0
	subi	%g1, %g1, 256
	callR	%g28
	addi	%g1, %g1, 256
	ld	%g31, %g1, 252
	ld	%g4, %g1, 108
	jne	%g3, %g4, jeq_else.30798
	ld	%g3, %g1, 72
	ld	%g29, %g1, 32
	st	%g31, %g1, 252
	ld	%g28, %g29, 0
	subi	%g1, %g1, 256
	callR	%g28
	addi	%g1, %g1, 256
	ld	%g31, %g1, 252
	ld	%g3, %g1, 52
	ld	%g3, %g3, 0
	st	%g31, %g1, 252
	subi	%g1, %g1, 256
	call	min_caml_float_of_int
	addi	%g1, %g1, 256
	ld	%g31, %g1, 252
	ld	%g3, %g1, 48
	ld	%g3, %g3, 0
	fst	%f0, %g1, 252
	st	%g31, %g1, 260
	subi	%g1, %g1, 264
	call	min_caml_float_of_int
	addi	%g1, %g1, 264
	ld	%g31, %g1, 260
	ld	%g3, %g1, 44
	ld	%g3, %g3, 0
	fst	%f0, %g1, 256
	st	%g31, %g1, 260
	subi	%g1, %g1, 264
	call	min_caml_float_of_int
	addi	%g1, %g1, 264
	ld	%g31, %g1, 260
	fld	%f1, %g1, 256
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 252
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.30799
jeq_else.30798:
	ld	%g3, %g1, 52
	ld	%g3, %g3, 0
	st	%g31, %g1, 260
	subi	%g1, %g1, 264
	call	min_caml_float_of_int
	addi	%g1, %g1, 264
	ld	%g31, %g1, 260
jeq_cont.30799:
	ld	%g3, %g1, 40
	ld	%g3, %g3, 0
	ld	%g4, %g1, 80
	jne	%g3, %g4, jeq_else.30800
	jmp	jeq_cont.30801
jeq_else.30800:
	fneg	%f0, %f0
jeq_cont.30801:
	fld	%f1, %g1, 240
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 228
	fst	%f0, %g3, -8
jeq_cont.30789:
	ld	%g4, %g1, 128
	ld	%g5, %g1, 84
	jne	%g5, %g4, jeq_else.30802
	ld	%g6, %g1, 80
	jmp	jeq_cont.30803
jeq_else.30802:
	ld	%g6, %g1, 176
jeq_cont.30803:
	mvhi	%g7, 0
	mvlo	%g7, 4
	fld	%f0, %g1, 96
	st	%g6, %g1, 260
	st	%g3, %g1, 228
	mov	%g3, %g7
	st	%g31, %g1, 268
	subi	%g1, %g1, 272
	call	min_caml_create_float_array
	addi	%g1, %g1, 272
	ld	%g31, %g1, 268
	mov	%g4, %g2
	addi	%g2, %g2, 48
	st	%g3, %g4, -40
	ld	%g3, %g1, 228
	st	%g3, %g4, -36
	ld	%g5, %g1, 200
	st	%g5, %g4, -32
	ld	%g5, %g1, 180
	st	%g5, %g4, -28
	ld	%g5, %g1, 260
	st	%g5, %g4, -24
	ld	%g5, %g1, 140
	st	%g5, %g4, -20
	ld	%g5, %g1, 104
	st	%g5, %g4, -16
	ld	%g6, %g1, 92
	st	%g6, %g4, -12
	ld	%g7, %g1, 88
	st	%g7, %g4, -8
	ld	%g7, %g1, 84
	st	%g7, %g4, -4
	ld	%g8, %g1, 76
	st	%g8, %g4, 0
	ld	%g8, %g1, 28
	slli	%g9, %g8, 2
	ld	%g10, %g1, 24
	st	%g10, %g1, 268
	add	%g10, %g10, %g9
	st	%g4, %g10, 0
	ld	%g10, %g1, 268
	ld	%g4, %g1, 100
	jne	%g7, %g4, jeq_else.30804
	fld	%f0, %g5, 0
	fld	%f1, %g1, 96
	fjeq	%f0, %f1, fjne_else.30806
	ld	%g4, %g1, 72
	jmp	fjne_cont.30807
fjne_else.30806:
	ld	%g4, %g1, 80
fjne_cont.30807:
	ld	%g7, %g1, 72
	jne	%g4, %g7, jeq_else.30808
	fjeq	%f0, %f1, fjne_else.30810
	mov	%g4, %g7
	jmp	fjne_cont.30811
fjne_else.30810:
	ld	%g4, %g1, 80
fjne_cont.30811:
	jne	%g4, %g7, jeq_else.30812
	fjlt	%f1, %f0, fjge_else.30814
	mov	%g4, %g7
	jmp	fjge_cont.30815
fjge_else.30814:
	ld	%g4, %g1, 80
fjge_cont.30815:
	jne	%g4, %g7, jeq_else.30816
	setL %g4, l.23128
	fld	%f2, %g4, 0
	jmp	jeq_cont.30817
jeq_else.30816:
	setL %g4, l.22819
	fld	%f2, %g4, 0
jeq_cont.30817:
	jmp	jeq_cont.30813
jeq_else.30812:
	fmov	%f2, %f1
jeq_cont.30813:
	fmul	%f0, %f0, %f0
	fdiv	%f0, %f2, %f0
	jmp	jeq_cont.30809
jeq_else.30808:
	fmov	%f0, %f1
jeq_cont.30809:
	fst	%f0, %g5, 0
	fld	%f0, %g5, -4
	fjeq	%f0, %f1, fjne_else.30818
	mov	%g4, %g7
	jmp	fjne_cont.30819
fjne_else.30818:
	ld	%g4, %g1, 80
fjne_cont.30819:
	jne	%g4, %g7, jeq_else.30820
	fjeq	%f0, %f1, fjne_else.30822
	mov	%g4, %g7
	jmp	fjne_cont.30823
fjne_else.30822:
	ld	%g4, %g1, 80
fjne_cont.30823:
	jne	%g4, %g7, jeq_else.30824
	fjlt	%f1, %f0, fjge_else.30826
	mov	%g4, %g7
	jmp	fjge_cont.30827
fjge_else.30826:
	ld	%g4, %g1, 80
fjge_cont.30827:
	jne	%g4, %g7, jeq_else.30828
	setL %g4, l.23128
	fld	%f2, %g4, 0
	jmp	jeq_cont.30829
jeq_else.30828:
	setL %g4, l.22819
	fld	%f2, %g4, 0
jeq_cont.30829:
	jmp	jeq_cont.30825
jeq_else.30824:
	fmov	%f2, %f1
jeq_cont.30825:
	fmul	%f0, %f0, %f0
	fdiv	%f0, %f2, %f0
	jmp	jeq_cont.30821
jeq_else.30820:
	fmov	%f0, %f1
jeq_cont.30821:
	fst	%f0, %g5, -4
	fld	%f0, %g5, -8
	fjeq	%f0, %f1, fjne_else.30830
	mov	%g4, %g7
	jmp	fjne_cont.30831
fjne_else.30830:
	ld	%g4, %g1, 80
fjne_cont.30831:
	jne	%g4, %g7, jeq_else.30832
	fjeq	%f0, %f1, fjne_else.30834
	mov	%g4, %g7
	jmp	fjne_cont.30835
fjne_else.30834:
	ld	%g4, %g1, 80
fjne_cont.30835:
	jne	%g4, %g7, jeq_else.30836
	fjlt	%f1, %f0, fjge_else.30838
	mov	%g4, %g7
	jmp	fjge_cont.30839
fjge_else.30838:
	ld	%g4, %g1, 80
fjge_cont.30839:
	jne	%g4, %g7, jeq_else.30840
	setL %g4, l.23128
	fld	%f2, %g4, 0
	jmp	jeq_cont.30841
jeq_else.30840:
	setL %g4, l.22819
	fld	%f2, %g4, 0
jeq_cont.30841:
	jmp	jeq_cont.30837
jeq_else.30836:
	fmov	%f2, %f1
jeq_cont.30837:
	fmul	%f0, %f0, %f0
	fdiv	%f0, %f2, %f0
	jmp	jeq_cont.30833
jeq_else.30832:
	fmov	%f0, %f1
jeq_cont.30833:
	fst	%f0, %g5, -8
	jmp	jeq_cont.30805
jeq_else.30804:
	ld	%g4, %g1, 128
	jne	%g7, %g4, jeq_else.30842
	ld	%g4, %g1, 72
	ld	%g7, %g1, 176
	jne	%g7, %g4, jeq_else.30844
	ld	%g7, %g1, 80
	jmp	jeq_cont.30845
jeq_else.30844:
	mov	%g7, %g4
jeq_cont.30845:
	fld	%f0, %g5, 0
	fmul	%f1, %f0, %f0
	fld	%f2, %g5, -4
	fmul	%f2, %f2, %f2
	fadd	%f1, %f1, %f2
	fld	%f2, %g5, -8
	fmul	%f2, %f2, %f2
	fadd	%f1, %f1, %f2
	fst	%f0, %g1, 264
	st	%g7, %g1, 268
	fmov	%f0, %f1
	fsqrt	%f0, %f0
	fld	%f1, %g1, 96
	fjeq	%f0, %f1, fjne_else.30846
	ld	%g3, %g1, 72
	jmp	fjne_cont.30847
fjne_else.30846:
	ld	%g3, %g1, 80
fjne_cont.30847:
	ld	%g4, %g1, 72
	jne	%g3, %g4, jeq_else.30848
	ld	%g3, %g1, 268
	jne	%g3, %g4, jeq_else.30850
	setL %g3, l.22819
	fld	%f2, %g3, 0
	fdiv	%f0, %f2, %f0
	jmp	jeq_cont.30851
jeq_else.30850:
	setL %g3, l.23128
	fld	%f2, %g3, 0
	fdiv	%f0, %f2, %f0
jeq_cont.30851:
	jmp	jeq_cont.30849
jeq_else.30848:
	setL %g3, l.22819
	fld	%f0, %g3, 0
jeq_cont.30849:
	fld	%f2, %g1, 264
	fmul	%f2, %f2, %f0
	ld	%g3, %g1, 104
	fst	%f2, %g3, 0
	fld	%f2, %g3, -4
	fmul	%f2, %f2, %f0
	fst	%f2, %g3, -4
	fld	%f2, %g3, -8
	fmul	%f0, %f2, %f0
	fst	%f0, %g3, -8
	jmp	jeq_cont.30843
jeq_else.30842:
jeq_cont.30843:
jeq_cont.30805:
	ld	%g3, %g1, 72
	ld	%g4, %g1, 92
	jne	%g4, %g3, jeq_else.30852
	jmp	jeq_cont.30853
jeq_else.30852:
	ld	%g4, %g1, 228
	fld	%f0, %g4, 0
	setL %g5, l.23155
	fld	%f1, %g5, 0
	fsub	%f2, %f1, %f0
	fld	%f3, %g1, 96
	fjlt	%f3, %f2, fjge_else.30854
	mov	%g5, %g3
	jmp	fjge_cont.30855
fjge_else.30854:
	ld	%g5, %g1, 80
fjge_cont.30855:
	fjlt	%f2, %f3, fjge_else.30856
	jmp	fjge_cont.30857
fjge_else.30856:
	fneg	%f2, %f2
fjge_cont.30857:
	fld	%f4, %g1, 20
	fst	%f1, %g1, 272
	fst	%f0, %g1, 276
	st	%g5, %g1, 280
	fjlt	%f4, %f2, fjge_else.30858
	fjlt	%f2, %f3, fjge_else.30860
	fmov	%f0, %f2
	jmp	fjge_cont.30861
fjge_else.30860:
	fadd	%f2, %f2, %f4
	ld	%g29, %g1, 16
	fmov	%f0, %f2
	st	%g31, %g1, 284
	ld	%g28, %g29, 0
	subi	%g1, %g1, 288
	callR	%g28
	addi	%g1, %g1, 288
	ld	%g31, %g1, 284
fjge_cont.30861:
	jmp	fjge_cont.30859
fjge_else.30858:
	fsub	%f2, %f2, %f4
	ld	%g29, %g1, 16
	fmov	%f0, %f2
	st	%g31, %g1, 284
	ld	%g28, %g29, 0
	subi	%g1, %g1, 288
	callR	%g28
	addi	%g1, %g1, 288
	ld	%g31, %g1, 284
fjge_cont.30859:
	fld	%f1, %g1, 12
	fjlt	%f1, %f0, fjge_else.30862
	ld	%g3, %g1, 280
	jmp	fjge_cont.30863
fjge_else.30862:
	ld	%g3, %g1, 72
	ld	%g4, %g1, 280
	jne	%g4, %g3, jeq_else.30864
	ld	%g4, %g1, 80
	mov	%g3, %g4
	jmp	jeq_cont.30865
jeq_else.30864:
jeq_cont.30865:
fjge_cont.30863:
	fjlt	%f1, %f0, fjge_else.30866
	jmp	fjge_cont.30867
fjge_else.30866:
	fld	%f2, %g1, 20
	fsub	%f0, %f2, %f0
fjge_cont.30867:
	fld	%f2, %g1, 8
	fjlt	%f2, %f0, fjge_else.30868
	jmp	fjge_cont.30869
fjge_else.30868:
	fsub	%f0, %f1, %f0
fjge_cont.30869:
	setL %g4, l.22815
	fld	%f3, %g4, 0
	fmul	%f0, %f0, %f3
	setL %g4, l.22819
	fld	%f4, %g4, 0
	setL %g4, l.23159
	fld	%f5, %g4, 0
	fmul	%f6, %f0, %f0
	setL %g4, l.22860
	fld	%f7, %g4, 0
	setL %g4, l.22817
	fld	%f7, %g4, 0
	setL %g4, l.23163
	fld	%f8, %g4, 0
	fdiv	%f9, %f6, %f5
	setL %g4, l.23165
	fld	%f10, %g4, 0
	fsub	%f9, %f8, %f9
	fdiv	%f9, %f6, %f9
	setL %g4, l.23167
	fld	%f11, %g4, 0
	fsub	%f9, %f10, %f9
	fdiv	%f9, %f6, %f9
	fst	%f11, %g1, 284
	fst	%f10, %g1, 288
	fst	%f8, %g1, 292
	fst	%f5, %g1, 296
	fst	%f3, %g1, 300
	st	%g3, %g1, 304
	fst	%f7, %g1, 308
	fst	%f0, %g1, 312
	fst	%f4, %g1, 316
	fmov	%f2, %f9
	fmov	%f1, %f6
	fmov	%f0, %f11
	st	%g31, %g1, 324
	subi	%g1, %g1, 328
	call	tan_sub.6499.6594.6640.7620.8018.9101
	addi	%g1, %g1, 328
	ld	%g31, %g1, 324
	fld	%f1, %g1, 316
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 312
	fdiv	%f0, %f2, %f0
	fld	%f2, %g1, 308
	fmul	%f3, %f2, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f1, %f0
	fdiv	%f0, %f3, %f0
	ld	%g3, %g1, 72
	ld	%g4, %g1, 304
	jne	%g4, %g3, jeq_else.30870
	fneg	%f0, %f0
	jmp	jeq_cont.30871
jeq_else.30870:
jeq_cont.30871:
	fld	%f3, %g1, 96
	fld	%f4, %g1, 276
	fjlt	%f3, %f4, fjge_else.30872
	mov	%g4, %g3
	jmp	fjge_cont.30873
fjge_else.30872:
	ld	%g4, %g1, 80
fjge_cont.30873:
	fjlt	%f4, %f3, fjge_else.30874
	jmp	fjge_cont.30875
fjge_else.30874:
	fneg	%f4, %f4
fjge_cont.30875:
	fld	%f5, %g1, 20
	fst	%f0, %g1, 320
	st	%g4, %g1, 324
	fjlt	%f5, %f4, fjge_else.30876
	fjlt	%f4, %f3, fjge_else.30878
	fmov	%f0, %f4
	jmp	fjge_cont.30879
fjge_else.30878:
	fadd	%f4, %f4, %f5
	ld	%g29, %g1, 16
	fmov	%f0, %f4
	st	%g31, %g1, 332
	ld	%g28, %g29, 0
	subi	%g1, %g1, 336
	callR	%g28
	addi	%g1, %g1, 336
	ld	%g31, %g1, 332
fjge_cont.30879:
	jmp	fjge_cont.30877
fjge_else.30876:
	fsub	%f4, %f4, %f5
	ld	%g29, %g1, 16
	fmov	%f0, %f4
	st	%g31, %g1, 332
	ld	%g28, %g29, 0
	subi	%g1, %g1, 336
	callR	%g28
	addi	%g1, %g1, 336
	ld	%g31, %g1, 332
fjge_cont.30877:
	fld	%f1, %g1, 12
	fjlt	%f1, %f0, fjge_else.30880
	ld	%g3, %g1, 324
	jmp	fjge_cont.30881
fjge_else.30880:
	ld	%g3, %g1, 72
	ld	%g4, %g1, 324
	jne	%g4, %g3, jeq_else.30882
	ld	%g4, %g1, 80
	mov	%g3, %g4
	jmp	jeq_cont.30883
jeq_else.30882:
jeq_cont.30883:
fjge_cont.30881:
	fjlt	%f1, %f0, fjge_else.30884
	jmp	fjge_cont.30885
fjge_else.30884:
	fld	%f2, %g1, 20
	fsub	%f0, %f2, %f0
fjge_cont.30885:
	fld	%f2, %g1, 8
	fjlt	%f2, %f0, fjge_else.30886
	jmp	fjge_cont.30887
fjge_else.30886:
	fsub	%f0, %f1, %f0
fjge_cont.30887:
	fld	%f3, %g1, 300
	fmul	%f0, %f0, %f3
	fmul	%f4, %f0, %f0
	fld	%f5, %g1, 296
	fdiv	%f6, %f4, %f5
	fld	%f7, %g1, 292
	fsub	%f6, %f7, %f6
	fdiv	%f6, %f4, %f6
	fld	%f8, %g1, 288
	fsub	%f6, %f8, %f6
	fdiv	%f6, %f4, %f6
	fld	%f9, %g1, 284
	st	%g3, %g1, 328
	fst	%f0, %g1, 332
	fmov	%f2, %f6
	fmov	%f1, %f4
	fmov	%f0, %f9
	st	%g31, %g1, 340
	subi	%g1, %g1, 344
	call	tan_sub.6499.6594.7571.7969.9052
	addi	%g1, %g1, 344
	ld	%g31, %g1, 340
	fld	%f1, %g1, 316
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 332
	fdiv	%f0, %f2, %f0
	fld	%f2, %g1, 308
	fmul	%f3, %f2, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f1, %f0
	fdiv	%f0, %f3, %f0
	ld	%g3, %g1, 72
	ld	%g4, %g1, 328
	jne	%g4, %g3, jeq_else.30888
	fneg	%f0, %f0
	jmp	jeq_cont.30889
jeq_else.30888:
jeq_cont.30889:
	ld	%g4, %g1, 228
	fld	%f3, %g4, -4
	fld	%f4, %g1, 272
	fsub	%f5, %f4, %f3
	fld	%f6, %g1, 96
	fjlt	%f6, %f5, fjge_else.30890
	mov	%g5, %g3
	jmp	fjge_cont.30891
fjge_else.30890:
	ld	%g5, %g1, 80
fjge_cont.30891:
	fjlt	%f5, %f6, fjge_else.30892
	jmp	fjge_cont.30893
fjge_else.30892:
	fneg	%f5, %f5
fjge_cont.30893:
	fld	%f7, %g1, 20
	fst	%f0, %g1, 336
	fst	%f3, %g1, 340
	st	%g5, %g1, 344
	fjlt	%f7, %f5, fjge_else.30894
	fjlt	%f5, %f6, fjge_else.30896
	fmov	%f0, %f5
	jmp	fjge_cont.30897
fjge_else.30896:
	fadd	%f5, %f5, %f7
	ld	%g29, %g1, 16
	fmov	%f0, %f5
	st	%g31, %g1, 348
	ld	%g28, %g29, 0
	subi	%g1, %g1, 352
	callR	%g28
	addi	%g1, %g1, 352
	ld	%g31, %g1, 348
fjge_cont.30897:
	jmp	fjge_cont.30895
fjge_else.30894:
	fsub	%f5, %f5, %f7
	ld	%g29, %g1, 16
	fmov	%f0, %f5
	st	%g31, %g1, 348
	ld	%g28, %g29, 0
	subi	%g1, %g1, 352
	callR	%g28
	addi	%g1, %g1, 352
	ld	%g31, %g1, 348
fjge_cont.30895:
	fld	%f1, %g1, 12
	fjlt	%f1, %f0, fjge_else.30898
	ld	%g3, %g1, 344
	jmp	fjge_cont.30899
fjge_else.30898:
	ld	%g3, %g1, 72
	ld	%g4, %g1, 344
	jne	%g4, %g3, jeq_else.30900
	ld	%g4, %g1, 80
	mov	%g3, %g4
	jmp	jeq_cont.30901
jeq_else.30900:
jeq_cont.30901:
fjge_cont.30899:
	fjlt	%f1, %f0, fjge_else.30902
	jmp	fjge_cont.30903
fjge_else.30902:
	fld	%f2, %g1, 20
	fsub	%f0, %f2, %f0
fjge_cont.30903:
	fld	%f2, %g1, 8
	fjlt	%f2, %f0, fjge_else.30904
	jmp	fjge_cont.30905
fjge_else.30904:
	fsub	%f0, %f1, %f0
fjge_cont.30905:
	fld	%f3, %g1, 300
	fmul	%f0, %f0, %f3
	fmul	%f4, %f0, %f0
	fld	%f5, %g1, 296
	fdiv	%f6, %f4, %f5
	fld	%f7, %g1, 292
	fsub	%f6, %f7, %f6
	fdiv	%f6, %f4, %f6
	fld	%f8, %g1, 288
	fsub	%f6, %f8, %f6
	fdiv	%f6, %f4, %f6
	fld	%f9, %g1, 284
	st	%g3, %g1, 348
	fst	%f0, %g1, 352
	fmov	%f2, %f6
	fmov	%f1, %f4
	fmov	%f0, %f9
	st	%g31, %g1, 356
	subi	%g1, %g1, 360
	call	tan_sub.6499.6594.6640.7524.7922.9005
	addi	%g1, %g1, 360
	ld	%g31, %g1, 356
	fld	%f1, %g1, 316
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 352
	fdiv	%f0, %f2, %f0
	fld	%f2, %g1, 308
	fmul	%f3, %f2, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f1, %f0
	fdiv	%f0, %f3, %f0
	ld	%g3, %g1, 72
	ld	%g4, %g1, 348
	jne	%g4, %g3, jeq_else.30906
	fneg	%f0, %f0
	jmp	jeq_cont.30907
jeq_else.30906:
jeq_cont.30907:
	fld	%f3, %g1, 96
	fld	%f4, %g1, 340
	fjlt	%f3, %f4, fjge_else.30908
	mov	%g4, %g3
	jmp	fjge_cont.30909
fjge_else.30908:
	ld	%g4, %g1, 80
fjge_cont.30909:
	fjlt	%f4, %f3, fjge_else.30910
	jmp	fjge_cont.30911
fjge_else.30910:
	fneg	%f4, %f4
fjge_cont.30911:
	fld	%f5, %g1, 20
	fst	%f0, %g1, 356
	st	%g4, %g1, 360
	fjlt	%f5, %f4, fjge_else.30912
	fjlt	%f4, %f3, fjge_else.30914
	fmov	%f0, %f4
	jmp	fjge_cont.30915
fjge_else.30914:
	fadd	%f4, %f4, %f5
	ld	%g29, %g1, 16
	fmov	%f0, %f4
	st	%g31, %g1, 364
	ld	%g28, %g29, 0
	subi	%g1, %g1, 368
	callR	%g28
	addi	%g1, %g1, 368
	ld	%g31, %g1, 364
fjge_cont.30915:
	jmp	fjge_cont.30913
fjge_else.30912:
	fsub	%f4, %f4, %f5
	ld	%g29, %g1, 16
	fmov	%f0, %f4
	st	%g31, %g1, 364
	ld	%g28, %g29, 0
	subi	%g1, %g1, 368
	callR	%g28
	addi	%g1, %g1, 368
	ld	%g31, %g1, 364
fjge_cont.30913:
	fld	%f1, %g1, 12
	fjlt	%f1, %f0, fjge_else.30916
	ld	%g3, %g1, 360
	jmp	fjge_cont.30917
fjge_else.30916:
	ld	%g3, %g1, 72
	ld	%g4, %g1, 360
	jne	%g4, %g3, jeq_else.30918
	ld	%g4, %g1, 80
	mov	%g3, %g4
	jmp	jeq_cont.30919
jeq_else.30918:
jeq_cont.30919:
fjge_cont.30917:
	fjlt	%f1, %f0, fjge_else.30920
	jmp	fjge_cont.30921
fjge_else.30920:
	fld	%f2, %g1, 20
	fsub	%f0, %f2, %f0
fjge_cont.30921:
	fld	%f2, %g1, 8
	fjlt	%f2, %f0, fjge_else.30922
	jmp	fjge_cont.30923
fjge_else.30922:
	fsub	%f0, %f1, %f0
fjge_cont.30923:
	fld	%f3, %g1, 300
	fmul	%f0, %f0, %f3
	fmul	%f4, %f0, %f0
	fld	%f5, %g1, 296
	fdiv	%f6, %f4, %f5
	fld	%f7, %g1, 292
	fsub	%f6, %f7, %f6
	fdiv	%f6, %f4, %f6
	fld	%f8, %g1, 288
	fsub	%f6, %f8, %f6
	fdiv	%f6, %f4, %f6
	fld	%f9, %g1, 284
	st	%g3, %g1, 364
	fst	%f0, %g1, 368
	fmov	%f2, %f6
	fmov	%f1, %f4
	fmov	%f0, %f9
	st	%g31, %g1, 372
	subi	%g1, %g1, 376
	call	tan_sub.6499.6594.7475.7873.8956
	addi	%g1, %g1, 376
	ld	%g31, %g1, 372
	fld	%f1, %g1, 316
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 368
	fdiv	%f0, %f2, %f0
	fld	%f2, %g1, 308
	fmul	%f3, %f2, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f1, %f0
	fdiv	%f0, %f3, %f0
	ld	%g3, %g1, 72
	ld	%g4, %g1, 364
	jne	%g4, %g3, jeq_else.30924
	fneg	%f0, %f0
	jmp	jeq_cont.30925
jeq_else.30924:
jeq_cont.30925:
	ld	%g4, %g1, 228
	fld	%f3, %g4, -8
	fld	%f4, %g1, 272
	fsub	%f4, %f4, %f3
	fld	%f5, %g1, 96
	fjlt	%f5, %f4, fjge_else.30926
	mov	%g5, %g3
	jmp	fjge_cont.30927
fjge_else.30926:
	ld	%g5, %g1, 80
fjge_cont.30927:
	fjlt	%f4, %f5, fjge_else.30928
	jmp	fjge_cont.30929
fjge_else.30928:
	fneg	%f4, %f4
fjge_cont.30929:
	fld	%f6, %g1, 20
	fst	%f0, %g1, 372
	fst	%f3, %g1, 376
	st	%g5, %g1, 380
	fjlt	%f6, %f4, fjge_else.30930
	fjlt	%f4, %f5, fjge_else.30932
	fmov	%f0, %f4
	jmp	fjge_cont.30933
fjge_else.30932:
	fadd	%f4, %f4, %f6
	ld	%g29, %g1, 16
	fmov	%f0, %f4
	st	%g31, %g1, 388
	ld	%g28, %g29, 0
	subi	%g1, %g1, 392
	callR	%g28
	addi	%g1, %g1, 392
	ld	%g31, %g1, 388
fjge_cont.30933:
	jmp	fjge_cont.30931
fjge_else.30930:
	fsub	%f4, %f4, %f6
	ld	%g29, %g1, 16
	fmov	%f0, %f4
	st	%g31, %g1, 388
	ld	%g28, %g29, 0
	subi	%g1, %g1, 392
	callR	%g28
	addi	%g1, %g1, 392
	ld	%g31, %g1, 388
fjge_cont.30931:
	fld	%f1, %g1, 12
	fjlt	%f1, %f0, fjge_else.30934
	ld	%g3, %g1, 380
	jmp	fjge_cont.30935
fjge_else.30934:
	ld	%g3, %g1, 72
	ld	%g4, %g1, 380
	jne	%g4, %g3, jeq_else.30936
	ld	%g4, %g1, 80
	mov	%g3, %g4
	jmp	jeq_cont.30937
jeq_else.30936:
jeq_cont.30937:
fjge_cont.30935:
	fjlt	%f1, %f0, fjge_else.30938
	jmp	fjge_cont.30939
fjge_else.30938:
	fld	%f2, %g1, 20
	fsub	%f0, %f2, %f0
fjge_cont.30939:
	fld	%f2, %g1, 8
	fjlt	%f2, %f0, fjge_else.30940
	jmp	fjge_cont.30941
fjge_else.30940:
	fsub	%f0, %f1, %f0
fjge_cont.30941:
	fld	%f3, %g1, 300
	fmul	%f0, %f0, %f3
	fmul	%f4, %f0, %f0
	fld	%f5, %g1, 296
	fdiv	%f6, %f4, %f5
	fld	%f7, %g1, 292
	fsub	%f6, %f7, %f6
	fdiv	%f6, %f4, %f6
	fld	%f8, %g1, 288
	fsub	%f6, %f8, %f6
	fdiv	%f6, %f4, %f6
	fld	%f9, %g1, 284
	st	%g3, %g1, 384
	fst	%f0, %g1, 388
	fmov	%f2, %f6
	fmov	%f1, %f4
	fmov	%f0, %f9
	st	%g31, %g1, 396
	subi	%g1, %g1, 400
	call	tan_sub.6499.6594.6640.7428.7826.8909
	addi	%g1, %g1, 400
	ld	%g31, %g1, 396
	fld	%f1, %g1, 316
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 388
	fdiv	%f0, %f2, %f0
	fld	%f2, %g1, 308
	fmul	%f3, %f2, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f1, %f0
	fdiv	%f0, %f3, %f0
	ld	%g3, %g1, 72
	ld	%g4, %g1, 384
	jne	%g4, %g3, jeq_else.30942
	fneg	%f0, %f0
	jmp	jeq_cont.30943
jeq_else.30942:
jeq_cont.30943:
	fld	%f3, %g1, 96
	fld	%f4, %g1, 376
	fjlt	%f3, %f4, fjge_else.30944
	mov	%g4, %g3
	jmp	fjge_cont.30945
fjge_else.30944:
	ld	%g4, %g1, 80
fjge_cont.30945:
	fjlt	%f4, %f3, fjge_else.30946
	jmp	fjge_cont.30947
fjge_else.30946:
	fneg	%f4, %f4
fjge_cont.30947:
	fld	%f5, %g1, 20
	fst	%f0, %g1, 392
	st	%g4, %g1, 396
	fjlt	%f5, %f4, fjge_else.30948
	fjlt	%f4, %f3, fjge_else.30950
	fmov	%f0, %f4
	jmp	fjge_cont.30951
fjge_else.30950:
	fadd	%f3, %f4, %f5
	ld	%g29, %g1, 16
	fmov	%f0, %f3
	st	%g31, %g1, 404
	ld	%g28, %g29, 0
	subi	%g1, %g1, 408
	callR	%g28
	addi	%g1, %g1, 408
	ld	%g31, %g1, 404
fjge_cont.30951:
	jmp	fjge_cont.30949
fjge_else.30948:
	fsub	%f3, %f4, %f5
	ld	%g29, %g1, 16
	fmov	%f0, %f3
	st	%g31, %g1, 404
	ld	%g28, %g29, 0
	subi	%g1, %g1, 408
	callR	%g28
	addi	%g1, %g1, 408
	ld	%g31, %g1, 404
fjge_cont.30949:
	fld	%f1, %g1, 12
	fjlt	%f1, %f0, fjge_else.30952
	ld	%g3, %g1, 396
	jmp	fjge_cont.30953
fjge_else.30952:
	ld	%g3, %g1, 72
	ld	%g4, %g1, 396
	jne	%g4, %g3, jeq_else.30954
	ld	%g4, %g1, 80
	mov	%g3, %g4
	jmp	jeq_cont.30955
jeq_else.30954:
jeq_cont.30955:
fjge_cont.30953:
	fjlt	%f1, %f0, fjge_else.30956
	jmp	fjge_cont.30957
fjge_else.30956:
	fld	%f2, %g1, 20
	fsub	%f0, %f2, %f0
fjge_cont.30957:
	fld	%f2, %g1, 8
	fjlt	%f2, %f0, fjge_else.30958
	jmp	fjge_cont.30959
fjge_else.30958:
	fsub	%f0, %f1, %f0
fjge_cont.30959:
	fld	%f1, %g1, 300
	fmul	%f0, %f0, %f1
	fmul	%f1, %f0, %f0
	fld	%f2, %g1, 296
	fdiv	%f2, %f1, %f2
	fld	%f3, %g1, 292
	fsub	%f2, %f3, %f2
	fdiv	%f2, %f1, %f2
	fld	%f3, %g1, 288
	fsub	%f2, %f3, %f2
	fdiv	%f2, %f1, %f2
	fld	%f3, %g1, 284
	st	%g3, %g1, 400
	fst	%f0, %g1, 404
	fmov	%f0, %f3
	st	%g31, %g1, 412
	subi	%g1, %g1, 416
	call	tan_sub.6499.6594.7379.7777.8860
	addi	%g1, %g1, 416
	ld	%g31, %g1, 412
	fld	%f1, %g1, 316
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 404
	fdiv	%f0, %f2, %f0
	fld	%f2, %g1, 308
	fmul	%f3, %f2, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f1, %f0
	fdiv	%f0, %f3, %f0
	ld	%g3, %g1, 72
	ld	%g4, %g1, 400
	jne	%g4, %g3, jeq_else.30960
	fneg	%f0, %f0
	jmp	jeq_cont.30961
jeq_else.30960:
jeq_cont.30961:
	fld	%f1, %g1, 392
	fld	%f3, %g1, 356
	fmul	%f4, %f3, %f1
	fld	%f5, %g1, 372
	fld	%f6, %g1, 336
	fmul	%f7, %f6, %f5
	fmul	%f8, %f7, %f1
	fld	%f9, %g1, 320
	fmul	%f10, %f9, %f0
	fsub	%f8, %f8, %f10
	fmul	%f10, %f9, %f5
	fmul	%f11, %f10, %f1
	fmul	%f12, %f6, %f0
	fadd	%f11, %f11, %f12
	fmul	%f12, %f3, %f0
	fmul	%f7, %f7, %f0
	fmul	%f13, %f9, %f1
	fadd	%f7, %f7, %f13
	fmul	%f0, %f10, %f0
	fmul	%f1, %f6, %f1
	fsub	%f0, %f0, %f1
	fneg	%f1, %f5
	fmul	%f5, %f6, %f3
	fmul	%f3, %f9, %f3
	ld	%g4, %g1, 104
	fld	%f6, %g4, 0
	fld	%f9, %g4, -4
	fld	%f10, %g4, -8
	fmul	%f13, %f4, %f4
	fmul	%f13, %f6, %f13
	fmul	%f14, %f12, %f12
	fmul	%f14, %f9, %f14
	fadd	%f13, %f13, %f14
	fmul	%f14, %f1, %f1
	fmul	%f14, %f10, %f14
	fadd	%f13, %f13, %f14
	fst	%f13, %g4, 0
	fmul	%f13, %f8, %f8
	fmul	%f13, %f6, %f13
	fmul	%f14, %f7, %f7
	fmul	%f14, %f9, %f14
	fadd	%f13, %f13, %f14
	fmul	%f14, %f5, %f5
	fmul	%f14, %f10, %f14
	fadd	%f13, %f13, %f14
	fst	%f13, %g4, -4
	fmul	%f13, %f11, %f11
	fmul	%f13, %f6, %f13
	fmul	%f14, %f0, %f0
	fmul	%f14, %f9, %f14
	fadd	%f13, %f13, %f14
	fmul	%f14, %f3, %f3
	fmul	%f14, %f10, %f14
	fadd	%f13, %f13, %f14
	fst	%f13, %g4, -8
	fmul	%f13, %f6, %f8
	fmul	%f13, %f13, %f11
	fmul	%f14, %f9, %f7
	fmul	%f14, %f14, %f0
	fadd	%f13, %f13, %f14
	fmul	%f14, %f10, %f5
	fmul	%f14, %f14, %f3
	fadd	%f13, %f13, %f14
	fmul	%f13, %f2, %f13
	ld	%g4, %g1, 228
	fst	%f13, %g4, 0
	fmul	%f4, %f6, %f4
	fmul	%f6, %f4, %f11
	fmul	%f9, %f9, %f12
	fmul	%f0, %f9, %f0
	fadd	%f0, %f6, %f0
	fmul	%f1, %f10, %f1
	fmul	%f3, %f1, %f3
	fadd	%f0, %f0, %f3
	fmul	%f0, %f2, %f0
	fst	%f0, %g4, -4
	fmul	%f0, %f4, %f8
	fmul	%f3, %f9, %f7
	fadd	%f0, %f0, %f3
	fmul	%f1, %f1, %f5
	fadd	%f0, %f0, %f1
	fmul	%f0, %f2, %f0
	fst	%f0, %g4, -8
jeq_cont.30853:
	ld	%g4, %g1, 80
jeq_cont.30737:
	jne	%g4, %g3, jeq_else.30962
	ld	%g3, %g1, 4
	ld	%g4, %g1, 28
	st	%g4, %g3, 0
	return
jeq_else.30962:
	ld	%g3, %g1, 28
	addi	%g3, %g3, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
read_net_item.2907:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 0
	st	%g7, %g6, 0
	st	%g7, %g5, 0
	mvhi	%g5, 0
	mvlo	%g5, 32
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g7
	mov	%g29, %g4
	mov	%g4, %g5
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 65535
	mvlo	%g4, -1
	jne	%g3, %g4, jeq_else.30964
	ld	%g3, %g1, 4
	addi	%g3, %g3, 1
	jmp	min_caml_create_array
jeq_else.30964:
	ld	%g4, %g1, 4
	addi	%g5, %g4, 1
	ld	%g29, %g1, 0
	st	%g3, %g1, 8
	mov	%g3, %g5
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	slli	%g4, %g4, 2
	ld	%g5, %g1, 8
	st	%g3, %g1, 12
	add	%g3, %g3, %g4
	st	%g5, %g3, 0
	ld	%g3, %g1, 12
	return
read_or_network.2909:
	ld	%g4, %g29, -4
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g5
	mov	%g29, %g4
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mov	%g4, %g3
	mvhi	%g3, 65535
	mvlo	%g3, -1
	ld	%g5, %g4, 0
	jne	%g5, %g3, jeq_else.30965
	ld	%g3, %g1, 4
	addi	%g3, %g3, 1
	jmp	min_caml_create_array
jeq_else.30965:
	ld	%g3, %g1, 4
	addi	%g5, %g3, 1
	ld	%g29, %g1, 0
	st	%g4, %g1, 8
	mov	%g3, %g5
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	slli	%g4, %g4, 2
	ld	%g5, %g1, 8
	st	%g3, %g1, 12
	add	%g3, %g3, %g4
	st	%g5, %g3, 0
	ld	%g3, %g1, 12
	return
read_and_network.2911:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	st	%g29, %g1, 0
	st	%g5, %g1, 4
	st	%g3, %g1, 8
	mov	%g3, %g6
	mov	%g29, %g4
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 65535
	mvlo	%g4, -1
	ld	%g5, %g3, 0
	jne	%g5, %g4, jeq_else.30966
	return
jeq_else.30966:
	ld	%g4, %g1, 8
	slli	%g5, %g4, 2
	ld	%g6, %g1, 4
	st	%g6, %g1, 12
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 12
	addi	%g3, %g4, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
solver.2955:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	slli	%g3, %g3, 2
	st	%g7, %g1, 4
	add	%g7, %g7, %g3
	ld	%g3, %g7, 0
	ld	%g7, %g1, 4
	ld	%g7, %g3, -4
	ld	%g8, %g3, -20
	ld	%g9, %g3, -20
	ld	%g10, %g3, -20
	mvhi	%g11, 0
	mvlo	%g11, 2
	fld	%f0, %g8, -8
	fld	%f1, %g5, -8
	fsub	%f0, %f1, %f0
	mvhi	%g8, 0
	mvlo	%g8, 1
	fld	%f1, %g9, -4
	fld	%f2, %g5, -4
	fsub	%f1, %f2, %f1
	mvhi	%g9, 0
	mvlo	%g9, 0
	fld	%f2, %g10, 0
	fld	%f3, %g5, 0
	fsub	%f2, %f3, %f2
	jne	%g7, %g8, jeq_else.30968
	setL %g5, l.22821
	fld	%f3, %g5, 0
	fld	%f4, %g4, 0
	fjeq	%f4, %f3, fjne_else.30969
	mov	%g5, %g9
	jmp	fjne_cont.30970
fjne_else.30969:
	mov	%g5, %g8
fjne_cont.30970:
	jne	%g5, %g9, jeq_else.30971
	ld	%g5, %g3, -16
	ld	%g7, %g3, -24
	fjlt	%f4, %f3, fjge_else.30973
	mov	%g10, %g9
	jmp	fjge_cont.30974
fjge_else.30973:
	mov	%g10, %g8
fjge_cont.30974:
	jne	%g7, %g9, jeq_else.30975
	mov	%g7, %g10
	jmp	jeq_cont.30976
jeq_else.30975:
	jne	%g10, %g9, jeq_else.30977
	mov	%g7, %g8
	jmp	jeq_cont.30978
jeq_else.30977:
	mov	%g7, %g9
jeq_cont.30978:
jeq_cont.30976:
	fld	%f5, %g5, 0
	jne	%g7, %g9, jeq_else.30979
	fneg	%f5, %f5
	jmp	jeq_cont.30980
jeq_else.30979:
jeq_cont.30980:
	fsub	%f5, %f5, %f2
	fdiv	%f4, %f5, %f4
	fld	%f5, %g4, -4
	fmul	%f5, %f4, %f5
	fadd	%f5, %f5, %f1
	fjlt	%f5, %f3, fjge_else.30981
	jmp	fjge_cont.30982
fjge_else.30981:
	fneg	%f5, %f5
fjge_cont.30982:
	fld	%f6, %g5, -4
	fjlt	%f5, %f6, fjge_else.30983
	mov	%g7, %g9
	jmp	fjge_cont.30984
fjge_else.30983:
	mov	%g7, %g8
fjge_cont.30984:
	jne	%g7, %g9, jeq_else.30985
	mov	%g5, %g9
	jmp	jeq_cont.30986
jeq_else.30985:
	fld	%f5, %g4, -8
	fmul	%f5, %f4, %f5
	fadd	%f5, %f5, %f0
	fjlt	%f5, %f3, fjge_else.30987
	jmp	fjge_cont.30988
fjge_else.30987:
	fneg	%f5, %f5
fjge_cont.30988:
	fld	%f6, %g5, -8
	fjlt	%f5, %f6, fjge_else.30989
	mov	%g5, %g9
	jmp	fjge_cont.30990
fjge_else.30989:
	mov	%g5, %g8
fjge_cont.30990:
	jne	%g5, %g9, jeq_else.30991
	mov	%g5, %g9
	jmp	jeq_cont.30992
jeq_else.30991:
	fst	%f4, %g6, 0
	mov	%g5, %g8
jeq_cont.30992:
jeq_cont.30986:
	jmp	jeq_cont.30972
jeq_else.30971:
	mov	%g5, %g9
jeq_cont.30972:
	jne	%g5, %g9, jeq_else.30993
	fld	%f4, %g4, -4
	fjeq	%f4, %f3, fjne_else.30994
	mov	%g5, %g9
	jmp	fjne_cont.30995
fjne_else.30994:
	mov	%g5, %g8
fjne_cont.30995:
	jne	%g5, %g9, jeq_else.30996
	ld	%g5, %g3, -16
	ld	%g7, %g3, -24
	fjlt	%f4, %f3, fjge_else.30998
	mov	%g10, %g9
	jmp	fjge_cont.30999
fjge_else.30998:
	mov	%g10, %g8
fjge_cont.30999:
	jne	%g7, %g9, jeq_else.31000
	mov	%g7, %g10
	jmp	jeq_cont.31001
jeq_else.31000:
	jne	%g10, %g9, jeq_else.31002
	mov	%g7, %g8
	jmp	jeq_cont.31003
jeq_else.31002:
	mov	%g7, %g9
jeq_cont.31003:
jeq_cont.31001:
	fld	%f5, %g5, -4
	jne	%g7, %g9, jeq_else.31004
	fneg	%f5, %f5
	jmp	jeq_cont.31005
jeq_else.31004:
jeq_cont.31005:
	fsub	%f5, %f5, %f1
	fdiv	%f4, %f5, %f4
	fld	%f5, %g4, -8
	fmul	%f5, %f4, %f5
	fadd	%f5, %f5, %f0
	fjlt	%f5, %f3, fjge_else.31006
	jmp	fjge_cont.31007
fjge_else.31006:
	fneg	%f5, %f5
fjge_cont.31007:
	fld	%f6, %g5, -8
	fjlt	%f5, %f6, fjge_else.31008
	mov	%g7, %g9
	jmp	fjge_cont.31009
fjge_else.31008:
	mov	%g7, %g8
fjge_cont.31009:
	jne	%g7, %g9, jeq_else.31010
	mov	%g5, %g9
	jmp	jeq_cont.31011
jeq_else.31010:
	fld	%f5, %g4, 0
	fmul	%f5, %f4, %f5
	fadd	%f5, %f5, %f2
	fjlt	%f5, %f3, fjge_else.31012
	jmp	fjge_cont.31013
fjge_else.31012:
	fneg	%f5, %f5
fjge_cont.31013:
	fld	%f6, %g5, 0
	fjlt	%f5, %f6, fjge_else.31014
	mov	%g5, %g9
	jmp	fjge_cont.31015
fjge_else.31014:
	mov	%g5, %g8
fjge_cont.31015:
	jne	%g5, %g9, jeq_else.31016
	mov	%g5, %g9
	jmp	jeq_cont.31017
jeq_else.31016:
	fst	%f4, %g6, 0
	mov	%g5, %g8
jeq_cont.31017:
jeq_cont.31011:
	jmp	jeq_cont.30997
jeq_else.30996:
	mov	%g5, %g9
jeq_cont.30997:
	jne	%g5, %g9, jeq_else.31018
	fld	%f4, %g4, -8
	fjeq	%f4, %f3, fjne_else.31019
	mov	%g5, %g9
	jmp	fjne_cont.31020
fjne_else.31019:
	mov	%g5, %g8
fjne_cont.31020:
	jne	%g5, %g9, jeq_else.31021
	ld	%g5, %g3, -16
	ld	%g3, %g3, -24
	fjlt	%f4, %f3, fjge_else.31023
	mov	%g7, %g9
	jmp	fjge_cont.31024
fjge_else.31023:
	mov	%g7, %g8
fjge_cont.31024:
	jne	%g3, %g9, jeq_else.31025
	mov	%g3, %g7
	jmp	jeq_cont.31026
jeq_else.31025:
	jne	%g7, %g9, jeq_else.31027
	mov	%g3, %g8
	jmp	jeq_cont.31028
jeq_else.31027:
	mov	%g3, %g9
jeq_cont.31028:
jeq_cont.31026:
	fld	%f5, %g5, -8
	jne	%g3, %g9, jeq_else.31029
	fneg	%f5, %f5
	jmp	jeq_cont.31030
jeq_else.31029:
jeq_cont.31030:
	fsub	%f0, %f5, %f0
	fdiv	%f0, %f0, %f4
	fld	%f4, %g4, 0
	fmul	%f4, %f0, %f4
	fadd	%f2, %f4, %f2
	fjlt	%f2, %f3, fjge_else.31031
	jmp	fjge_cont.31032
fjge_else.31031:
	fneg	%f2, %f2
fjge_cont.31032:
	fld	%f4, %g5, 0
	fjlt	%f2, %f4, fjge_else.31033
	mov	%g3, %g9
	jmp	fjge_cont.31034
fjge_else.31033:
	mov	%g3, %g8
fjge_cont.31034:
	jne	%g3, %g9, jeq_else.31035
	mov	%g3, %g9
	jmp	jeq_cont.31036
jeq_else.31035:
	fld	%f2, %g4, -4
	fmul	%f2, %f0, %f2
	fadd	%f1, %f2, %f1
	fjlt	%f1, %f3, fjge_else.31037
	jmp	fjge_cont.31038
fjge_else.31037:
	fneg	%f1, %f1
fjge_cont.31038:
	fld	%f2, %g5, -4
	fjlt	%f1, %f2, fjge_else.31039
	mov	%g3, %g9
	jmp	fjge_cont.31040
fjge_else.31039:
	mov	%g3, %g8
fjge_cont.31040:
	jne	%g3, %g9, jeq_else.31041
	mov	%g3, %g9
	jmp	jeq_cont.31042
jeq_else.31041:
	fst	%f0, %g6, 0
	mov	%g3, %g8
jeq_cont.31042:
jeq_cont.31036:
	jmp	jeq_cont.31022
jeq_else.31021:
	mov	%g3, %g9
jeq_cont.31022:
	jne	%g3, %g9, jeq_else.31043
	mov	%g3, %g9
	return
jeq_else.31043:
	mvhi	%g3, 0
	mvlo	%g3, 3
	return
jeq_else.31018:
	mov	%g3, %g11
	return
jeq_else.30993:
	mov	%g3, %g8
	return
jeq_else.30968:
	jne	%g7, %g11, jeq_else.31044
	ld	%g3, %g3, -16
	fld	%f3, %g3, -8
	fld	%f4, %g4, -8
	fmul	%f4, %f4, %f3
	fld	%f5, %g3, -4
	fld	%f6, %g4, -4
	fmul	%f6, %f6, %f5
	fld	%f7, %g3, 0
	fld	%f8, %g4, 0
	fmul	%f8, %f8, %f7
	fadd	%f6, %f8, %f6
	fadd	%f4, %f6, %f4
	setL %g3, l.22821
	fld	%f6, %g3, 0
	fjlt	%f6, %f4, fjge_else.31045
	mov	%g3, %g9
	jmp	fjge_cont.31046
fjge_else.31045:
	mov	%g3, %g8
fjge_cont.31046:
	jne	%g3, %g9, jeq_else.31047
	mov	%g3, %g9
	return
jeq_else.31047:
	fmul	%f0, %f3, %f0
	fmul	%f1, %f5, %f1
	fmul	%f2, %f7, %f2
	fadd	%f1, %f2, %f1
	fadd	%f0, %f1, %f0
	fneg	%f0, %f0
	fdiv	%f0, %f0, %f4
	fst	%f0, %g6, 0
	mov	%g3, %g8
	return
jeq_else.31044:
	ld	%g5, %g3, -16
	ld	%g10, %g3, -16
	ld	%g11, %g3, -16
	ld	%g12, %g3, -12
	fld	%f3, %g11, -8
	fld	%f4, %g4, -8
	fmul	%f5, %f4, %f4
	fmul	%f5, %f5, %f3
	fld	%f6, %g10, -4
	fld	%f7, %g4, -4
	fmul	%f8, %f7, %f7
	fmul	%f8, %f8, %f6
	fld	%f9, %g5, 0
	fld	%f10, %g4, 0
	fmul	%f11, %f10, %f10
	fmul	%f11, %f11, %f9
	fadd	%f8, %f11, %f8
	fadd	%f5, %f8, %f5
	jne	%g12, %g9, jeq_else.31048
	jmp	jeq_cont.31049
jeq_else.31048:
	fmul	%f8, %f7, %f4
	ld	%g4, %g3, -36
	fld	%f11, %g4, 0
	fmul	%f8, %f8, %f11
	fadd	%f5, %f5, %f8
	fmul	%f8, %f4, %f10
	ld	%g4, %g3, -36
	fld	%f11, %g4, -4
	fmul	%f8, %f8, %f11
	fadd	%f5, %f5, %f8
	fmul	%f8, %f10, %f7
	ld	%g4, %g3, -36
	fld	%f11, %g4, -8
	fmul	%f8, %f8, %f11
	fadd	%f5, %f5, %f8
jeq_cont.31049:
	setL %g4, l.22821
	fld	%f8, %g4, 0
	fjeq	%f5, %f8, fjne_else.31050
	mov	%g4, %g9
	jmp	fjne_cont.31051
fjne_else.31050:
	mov	%g4, %g8
fjne_cont.31051:
	jne	%g4, %g9, jeq_else.31052
	fmul	%f11, %f0, %f0
	fmul	%f11, %f11, %f3
	fmul	%f12, %f1, %f1
	fmul	%f12, %f12, %f6
	fmul	%f13, %f2, %f2
	fmul	%f13, %f13, %f9
	fadd	%f12, %f13, %f12
	fadd	%f11, %f12, %f11
	jne	%g12, %g9, jeq_else.31053
	jmp	jeq_cont.31054
jeq_else.31053:
	fmul	%f12, %f1, %f0
	ld	%g4, %g3, -36
	fld	%f13, %g4, 0
	fmul	%f12, %f12, %f13
	fadd	%f11, %f11, %f12
	fmul	%f12, %f0, %f2
	ld	%g4, %g3, -36
	fld	%f13, %g4, -4
	fmul	%f12, %f12, %f13
	fadd	%f11, %f11, %f12
	fmul	%f12, %f2, %f1
	ld	%g4, %g3, -36
	fld	%f13, %g4, -8
	fmul	%f12, %f12, %f13
	fadd	%f11, %f11, %f12
jeq_cont.31054:
	mvhi	%g4, 0
	mvlo	%g4, 3
	jne	%g7, %g4, jeq_else.31055
	setL %g4, l.22819
	fld	%f12, %g4, 0
	fsub	%f11, %f11, %f12
	jmp	jeq_cont.31056
jeq_else.31055:
jeq_cont.31056:
	fmul	%f11, %f5, %f11
	fmul	%f12, %f4, %f0
	fmul	%f3, %f12, %f3
	fmul	%f12, %f7, %f1
	fmul	%f6, %f12, %f6
	fmul	%f12, %f10, %f2
	fmul	%f9, %f12, %f9
	fadd	%f6, %f9, %f6
	fadd	%f3, %f6, %f3
	jne	%g12, %g9, jeq_else.31057
	fmov	%f0, %f3
	jmp	jeq_cont.31058
jeq_else.31057:
	fmul	%f6, %f4, %f1
	fmul	%f9, %f7, %f0
	fadd	%f6, %f6, %f9
	ld	%g4, %g3, -36
	fld	%f9, %g4, 0
	fmul	%f6, %f6, %f9
	fmul	%f0, %f10, %f0
	fmul	%f4, %f4, %f2
	fadd	%f0, %f0, %f4
	ld	%g4, %g3, -36
	fld	%f4, %g4, -4
	fmul	%f0, %f0, %f4
	fadd	%f0, %f6, %f0
	fmul	%f1, %f10, %f1
	fmul	%f2, %f7, %f2
	fadd	%f1, %f1, %f2
	ld	%g4, %g3, -36
	fld	%f2, %g4, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	setL %g4, l.22817
	fld	%f1, %g4, 0
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f3, %f0
jeq_cont.31058:
	fmul	%f1, %f0, %f0
	fsub	%f1, %f1, %f11
	fjlt	%f8, %f1, fjge_else.31059
	mov	%g4, %g9
	jmp	fjge_cont.31060
fjge_else.31059:
	mov	%g4, %g8
fjge_cont.31060:
	jne	%g4, %g9, jeq_else.31061
	mov	%g3, %g9
	return
jeq_else.31061:
	ld	%g3, %g3, -24
	st	%g8, %g1, 0
	st	%g6, %g1, 4
	fst	%f5, %g1, 8
	fst	%f0, %g1, 12
	st	%g9, %g1, 16
	st	%g3, %g1, 20
	fmov	%f0, %f1
	fsqrt	%f0, %f0
	ld	%g3, %g1, 16
	ld	%g4, %g1, 20
	jne	%g4, %g3, jeq_else.31062
	fneg	%f0, %f0
	jmp	jeq_cont.31063
jeq_else.31062:
jeq_cont.31063:
	fld	%f1, %g1, 12
	fsub	%f0, %f0, %f1
	fld	%f1, %g1, 8
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 4
	fst	%f0, %g3, 0
	ld	%g3, %g1, 0
	return
jeq_else.31052:
	mov	%g3, %g9
	return
solver_fast.2978:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	slli	%g8, %g3, 2
	st	%g7, %g1, 4
	add	%g7, %g7, %g8
	ld	%g7, %g7, 0
	ld	%g8, %g7, -4
	ld	%g9, %g4, -4
	ld	%g10, %g7, -20
	ld	%g11, %g7, -20
	ld	%g12, %g7, -20
	slli	%g3, %g3, 2
	st	%g9, %g1, 4
	add	%g9, %g9, %g3
	ld	%g3, %g9, 0
	ld	%g9, %g1, 4
	mvhi	%g9, 0
	mvlo	%g9, 2
	fld	%f0, %g10, -8
	fld	%f1, %g5, -8
	fsub	%f0, %f1, %f0
	mvhi	%g10, 0
	mvlo	%g10, 1
	fld	%f1, %g11, -4
	fld	%f2, %g5, -4
	fsub	%f1, %f2, %f1
	mvhi	%g11, 0
	mvlo	%g11, 0
	fld	%f2, %g12, 0
	fld	%f3, %g5, 0
	fsub	%f2, %f3, %f2
	jne	%g8, %g10, jeq_else.31064
	ld	%g4, %g4, 0
	ld	%g5, %g7, -16
	fld	%f3, %g3, -4
	fld	%f4, %g3, 0
	fsub	%f4, %f4, %f2
	fmul	%f4, %f4, %f3
	setL %g8, l.22821
	fld	%f5, %g8, 0
	fld	%f6, %g5, -4
	fld	%f7, %g4, -4
	fmul	%f7, %f4, %f7
	fadd	%f7, %f7, %f1
	fjlt	%f7, %f5, fjge_else.31065
	jmp	fjge_cont.31066
fjge_else.31065:
	fneg	%f7, %f7
fjge_cont.31066:
	fjlt	%f7, %f6, fjge_else.31067
	mov	%g5, %g11
	jmp	fjge_cont.31068
fjge_else.31067:
	mov	%g5, %g10
fjge_cont.31068:
	jne	%g5, %g11, jeq_else.31069
	mov	%g5, %g11
	jmp	jeq_cont.31070
jeq_else.31069:
	fld	%f6, %g4, -8
	fmul	%f6, %f4, %f6
	fadd	%f6, %f6, %f0
	fjlt	%f6, %f5, fjge_else.31071
	jmp	fjge_cont.31072
fjge_else.31071:
	fneg	%f6, %f6
fjge_cont.31072:
	ld	%g5, %g7, -16
	fld	%f7, %g5, -8
	fjlt	%f6, %f7, fjge_else.31073
	mov	%g5, %g11
	jmp	fjge_cont.31074
fjge_else.31073:
	mov	%g5, %g10
fjge_cont.31074:
	jne	%g5, %g11, jeq_else.31075
	mov	%g5, %g11
	jmp	jeq_cont.31076
jeq_else.31075:
	fjeq	%f3, %f5, fjne_else.31077
	mov	%g5, %g11
	jmp	fjne_cont.31078
fjne_else.31077:
	mov	%g5, %g10
fjne_cont.31078:
	jne	%g5, %g11, jeq_else.31079
	mov	%g5, %g10
	jmp	jeq_cont.31080
jeq_else.31079:
	mov	%g5, %g11
jeq_cont.31080:
jeq_cont.31076:
jeq_cont.31070:
	jne	%g5, %g11, jeq_else.31081
	ld	%g5, %g7, -16
	mvhi	%g8, 0
	mvlo	%g8, 3
	fld	%f3, %g3, -12
	fld	%f4, %g3, -8
	fsub	%f4, %f4, %f1
	fmul	%f4, %f4, %f3
	fld	%f6, %g5, 0
	fld	%f7, %g4, 0
	fmul	%f7, %f4, %f7
	fadd	%f7, %f7, %f2
	fjlt	%f7, %f5, fjge_else.31082
	jmp	fjge_cont.31083
fjge_else.31082:
	fneg	%f7, %f7
fjge_cont.31083:
	fjlt	%f7, %f6, fjge_else.31084
	mov	%g5, %g11
	jmp	fjge_cont.31085
fjge_else.31084:
	mov	%g5, %g10
fjge_cont.31085:
	jne	%g5, %g11, jeq_else.31086
	mov	%g5, %g11
	jmp	jeq_cont.31087
jeq_else.31086:
	fld	%f6, %g4, -8
	fmul	%f6, %f4, %f6
	fadd	%f6, %f6, %f0
	fjlt	%f6, %f5, fjge_else.31088
	jmp	fjge_cont.31089
fjge_else.31088:
	fneg	%f6, %f6
fjge_cont.31089:
	ld	%g5, %g7, -16
	fld	%f7, %g5, -8
	fjlt	%f6, %f7, fjge_else.31090
	mov	%g5, %g11
	jmp	fjge_cont.31091
fjge_else.31090:
	mov	%g5, %g10
fjge_cont.31091:
	jne	%g5, %g11, jeq_else.31092
	mov	%g5, %g11
	jmp	jeq_cont.31093
jeq_else.31092:
	fjeq	%f3, %f5, fjne_else.31094
	mov	%g5, %g11
	jmp	fjne_cont.31095
fjne_else.31094:
	mov	%g5, %g10
fjne_cont.31095:
	jne	%g5, %g11, jeq_else.31096
	mov	%g5, %g10
	jmp	jeq_cont.31097
jeq_else.31096:
	mov	%g5, %g11
jeq_cont.31097:
jeq_cont.31093:
jeq_cont.31087:
	jne	%g5, %g11, jeq_else.31098
	ld	%g5, %g7, -16
	fld	%f3, %g3, -20
	fld	%f4, %g3, -16
	fsub	%f0, %f4, %f0
	fmul	%f0, %f0, %f3
	fld	%f4, %g5, 0
	fld	%f6, %g4, 0
	fmul	%f6, %f0, %f6
	fadd	%f2, %f6, %f2
	fjlt	%f2, %f5, fjge_else.31099
	jmp	fjge_cont.31100
fjge_else.31099:
	fneg	%f2, %f2
fjge_cont.31100:
	fjlt	%f2, %f4, fjge_else.31101
	mov	%g3, %g11
	jmp	fjge_cont.31102
fjge_else.31101:
	mov	%g3, %g10
fjge_cont.31102:
	jne	%g3, %g11, jeq_else.31103
	mov	%g3, %g11
	jmp	jeq_cont.31104
jeq_else.31103:
	fld	%f2, %g4, -4
	fmul	%f2, %f0, %f2
	fadd	%f1, %f2, %f1
	fjlt	%f1, %f5, fjge_else.31105
	jmp	fjge_cont.31106
fjge_else.31105:
	fneg	%f1, %f1
fjge_cont.31106:
	ld	%g3, %g7, -16
	fld	%f2, %g3, -4
	fjlt	%f1, %f2, fjge_else.31107
	mov	%g3, %g11
	jmp	fjge_cont.31108
fjge_else.31107:
	mov	%g3, %g10
fjge_cont.31108:
	jne	%g3, %g11, jeq_else.31109
	mov	%g3, %g11
	jmp	jeq_cont.31110
jeq_else.31109:
	fjeq	%f3, %f5, fjne_else.31111
	mov	%g3, %g11
	jmp	fjne_cont.31112
fjne_else.31111:
	mov	%g3, %g10
fjne_cont.31112:
	jne	%g3, %g11, jeq_else.31113
	mov	%g3, %g10
	jmp	jeq_cont.31114
jeq_else.31113:
	mov	%g3, %g11
jeq_cont.31114:
jeq_cont.31110:
jeq_cont.31104:
	jne	%g3, %g11, jeq_else.31115
	mov	%g3, %g11
	return
jeq_else.31115:
	fst	%f0, %g6, 0
	mov	%g3, %g8
	return
jeq_else.31098:
	fst	%f4, %g6, 0
	mov	%g3, %g9
	return
jeq_else.31081:
	fst	%f4, %g6, 0
	mov	%g3, %g10
	return
jeq_else.31064:
	jne	%g8, %g9, jeq_else.31116
	setL %g4, l.22821
	fld	%f3, %g4, 0
	fld	%f4, %g3, 0
	fjlt	%f4, %f3, fjge_else.31117
	mov	%g4, %g11
	jmp	fjge_cont.31118
fjge_else.31117:
	mov	%g4, %g10
fjge_cont.31118:
	jne	%g4, %g11, jeq_else.31119
	mov	%g3, %g11
	return
jeq_else.31119:
	fld	%f3, %g3, -12
	fmul	%f0, %f3, %f0
	fld	%f3, %g3, -8
	fmul	%f1, %f3, %f1
	fld	%f3, %g3, -4
	fmul	%f2, %f3, %f2
	fadd	%f1, %f2, %f1
	fadd	%f0, %f1, %f0
	fst	%f0, %g6, 0
	mov	%g3, %g10
	return
jeq_else.31116:
	fld	%f3, %g3, 0
	setL %g4, l.22821
	fld	%f4, %g4, 0
	fjeq	%f3, %f4, fjne_else.31120
	mov	%g4, %g11
	jmp	fjne_cont.31121
fjne_else.31120:
	mov	%g4, %g10
fjne_cont.31121:
	jne	%g4, %g11, jeq_else.31122
	ld	%g4, %g7, -16
	ld	%g5, %g7, -16
	ld	%g9, %g7, -16
	ld	%g12, %g7, -12
	fld	%f5, %g9, -8
	fmul	%f6, %f0, %f0
	fmul	%f5, %f6, %f5
	fld	%f6, %g5, -4
	fmul	%f7, %f1, %f1
	fmul	%f6, %f7, %f6
	fld	%f7, %g4, 0
	fmul	%f8, %f2, %f2
	fmul	%f7, %f8, %f7
	fadd	%f6, %f7, %f6
	fadd	%f5, %f6, %f5
	jne	%g12, %g11, jeq_else.31123
	jmp	jeq_cont.31124
jeq_else.31123:
	fmul	%f6, %f1, %f0
	ld	%g4, %g7, -36
	fld	%f7, %g4, 0
	fmul	%f6, %f6, %f7
	fadd	%f5, %f5, %f6
	fmul	%f6, %f0, %f2
	ld	%g4, %g7, -36
	fld	%f7, %g4, -4
	fmul	%f6, %f6, %f7
	fadd	%f5, %f5, %f6
	fmul	%f6, %f2, %f1
	ld	%g4, %g7, -36
	fld	%f7, %g4, -8
	fmul	%f6, %f6, %f7
	fadd	%f5, %f5, %f6
jeq_cont.31124:
	mvhi	%g4, 0
	mvlo	%g4, 3
	jne	%g8, %g4, jeq_else.31125
	setL %g4, l.22819
	fld	%f6, %g4, 0
	fsub	%f5, %f5, %f6
	jmp	jeq_cont.31126
jeq_else.31125:
jeq_cont.31126:
	fmul	%f3, %f3, %f5
	fld	%f5, %g3, -12
	fmul	%f0, %f5, %f0
	fld	%f5, %g3, -8
	fmul	%f1, %f5, %f1
	fld	%f5, %g3, -4
	fmul	%f2, %f5, %f2
	fadd	%f1, %f2, %f1
	fadd	%f0, %f1, %f0
	fmul	%f1, %f0, %f0
	fsub	%f1, %f1, %f3
	fjlt	%f4, %f1, fjge_else.31127
	mov	%g4, %g11
	jmp	fjge_cont.31128
fjge_else.31127:
	mov	%g4, %g10
fjge_cont.31128:
	jne	%g4, %g11, jeq_else.31129
	mov	%g3, %g11
	return
jeq_else.31129:
	ld	%g4, %g7, -24
	st	%g10, %g1, 0
	jne	%g4, %g11, jeq_else.31130
	st	%g6, %g1, 4
	st	%g3, %g1, 8
	fst	%f0, %g1, 12
	fmov	%f0, %f1
	fsqrt	%f0, %f0
	fld	%f1, %g1, 12
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 4
	fst	%f0, %g3, 0
	jmp	jeq_cont.31131
jeq_else.31130:
	st	%g6, %g1, 4
	st	%g3, %g1, 8
	fst	%f0, %g1, 12
	fmov	%f0, %f1
	fsqrt	%f0, %f0
	fld	%f1, %g1, 12
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 4
	fst	%f0, %g3, 0
jeq_cont.31131:
	ld	%g3, %g1, 0
	return
jeq_else.31122:
	mov	%g3, %g11
	return
iter_setup_dirvec_constants.3008:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g4, %g6, jle_else.31132
	ld	%g7, %g3, 0
	slli	%g8, %g4, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g8
	ld	%g5, %g5, 0
	ld	%g8, %g5, -4
	ld	%g9, %g3, -4
	mvhi	%g10, 0
	mvlo	%g10, 1
	st	%g3, %g1, 0
	st	%g29, %g1, 4
	jne	%g8, %g10, jeq_else.31133
	mvhi	%g8, 0
	mvlo	%g8, 6
	setL %g11, l.22821
	fld	%f0, %g11, 0
	st	%g9, %g1, 8
	st	%g4, %g1, 12
	st	%g5, %g1, 16
	st	%g6, %g1, 20
	st	%g10, %g1, 24
	fst	%f0, %g1, 28
	st	%g7, %g1, 32
	mov	%g3, %g8
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_create_float_array
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 32
	fld	%f0, %g4, 0
	fld	%f1, %g1, 28
	fjeq	%f0, %f1, fjne_else.31135
	ld	%g5, %g1, 20
	jmp	fjne_cont.31136
fjne_else.31135:
	ld	%g5, %g1, 24
fjne_cont.31136:
	ld	%g6, %g1, 20
	jne	%g5, %g6, jeq_else.31137
	ld	%g5, %g1, 16
	ld	%g7, %g5, -24
	fld	%f0, %g4, 0
	fjlt	%f0, %f1, fjge_else.31139
	mov	%g8, %g6
	jmp	fjge_cont.31140
fjge_else.31139:
	ld	%g8, %g1, 24
fjge_cont.31140:
	jne	%g7, %g6, jeq_else.31141
	mov	%g7, %g8
	jmp	jeq_cont.31142
jeq_else.31141:
	jne	%g8, %g6, jeq_else.31143
	ld	%g7, %g1, 24
	jmp	jeq_cont.31144
jeq_else.31143:
	mov	%g7, %g6
jeq_cont.31144:
jeq_cont.31142:
	ld	%g8, %g5, -16
	fld	%f0, %g8, 0
	jne	%g7, %g6, jeq_else.31145
	fneg	%f0, %f0
	jmp	jeq_cont.31146
jeq_else.31145:
jeq_cont.31146:
	fst	%f0, %g3, 0
	setL %g7, l.22819
	fld	%f0, %g7, 0
	fld	%f2, %g4, 0
	fdiv	%f0, %f0, %f2
	fst	%f0, %g3, -4
	jmp	jeq_cont.31138
jeq_else.31137:
	fst	%f1, %g3, -4
jeq_cont.31138:
	fld	%f0, %g4, -4
	fjeq	%f0, %f1, fjne_else.31147
	mov	%g5, %g6
	jmp	fjne_cont.31148
fjne_else.31147:
	ld	%g5, %g1, 24
fjne_cont.31148:
	jne	%g5, %g6, jeq_else.31149
	ld	%g5, %g1, 16
	ld	%g7, %g5, -24
	fld	%f0, %g4, -4
	fjlt	%f0, %f1, fjge_else.31151
	mov	%g8, %g6
	jmp	fjge_cont.31152
fjge_else.31151:
	ld	%g8, %g1, 24
fjge_cont.31152:
	jne	%g7, %g6, jeq_else.31153
	mov	%g7, %g8
	jmp	jeq_cont.31154
jeq_else.31153:
	jne	%g8, %g6, jeq_else.31155
	ld	%g7, %g1, 24
	jmp	jeq_cont.31156
jeq_else.31155:
	mov	%g7, %g6
jeq_cont.31156:
jeq_cont.31154:
	ld	%g8, %g5, -16
	fld	%f0, %g8, -4
	jne	%g7, %g6, jeq_else.31157
	fneg	%f0, %f0
	jmp	jeq_cont.31158
jeq_else.31157:
jeq_cont.31158:
	fst	%f0, %g3, -8
	setL %g7, l.22819
	fld	%f0, %g7, 0
	fld	%f2, %g4, -4
	fdiv	%f0, %f0, %f2
	fst	%f0, %g3, -12
	jmp	jeq_cont.31150
jeq_else.31149:
	fst	%f1, %g3, -12
jeq_cont.31150:
	fld	%f0, %g4, -8
	fjeq	%f0, %f1, fjne_else.31159
	mov	%g5, %g6
	jmp	fjne_cont.31160
fjne_else.31159:
	ld	%g5, %g1, 24
fjne_cont.31160:
	jne	%g5, %g6, jeq_else.31161
	ld	%g5, %g1, 16
	ld	%g7, %g5, -24
	fld	%f0, %g4, -8
	fjlt	%f0, %f1, fjge_else.31163
	mov	%g8, %g6
	jmp	fjge_cont.31164
fjge_else.31163:
	ld	%g8, %g1, 24
fjge_cont.31164:
	jne	%g7, %g6, jeq_else.31165
	mov	%g7, %g8
	jmp	jeq_cont.31166
jeq_else.31165:
	jne	%g8, %g6, jeq_else.31167
	ld	%g7, %g1, 24
	jmp	jeq_cont.31168
jeq_else.31167:
	mov	%g7, %g6
jeq_cont.31168:
jeq_cont.31166:
	ld	%g5, %g5, -16
	fld	%f0, %g5, -8
	jne	%g7, %g6, jeq_else.31169
	fneg	%f0, %f0
	jmp	jeq_cont.31170
jeq_else.31169:
jeq_cont.31170:
	fst	%f0, %g3, -16
	setL %g5, l.22819
	fld	%f0, %g5, 0
	fld	%f1, %g4, -8
	fdiv	%f0, %f0, %f1
	fst	%f0, %g3, -20
	jmp	jeq_cont.31162
jeq_else.31161:
	fst	%f1, %g3, -20
jeq_cont.31162:
	ld	%g4, %g1, 12
	slli	%g5, %g4, 2
	ld	%g6, %g1, 8
	st	%g6, %g1, 36
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 36
	jmp	jeq_cont.31134
jeq_else.31133:
	mvhi	%g11, 0
	mvlo	%g11, 2
	jne	%g8, %g11, jeq_else.31171
	mvhi	%g8, 0
	mvlo	%g8, 4
	setL %g11, l.22821
	fld	%f0, %g11, 0
	st	%g9, %g1, 8
	st	%g4, %g1, 12
	st	%g10, %g1, 24
	st	%g6, %g1, 20
	fst	%f0, %g1, 36
	st	%g5, %g1, 16
	st	%g7, %g1, 32
	mov	%g3, %g8
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 32
	fld	%f0, %g4, 0
	ld	%g5, %g1, 16
	ld	%g6, %g5, -16
	fld	%f1, %g6, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g4, -4
	ld	%g6, %g5, -16
	fld	%f2, %g6, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g4, -8
	ld	%g4, %g5, -16
	fld	%f2, %g4, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g1, 36
	fjlt	%f1, %f0, fjge_else.31173
	ld	%g4, %g1, 20
	jmp	fjge_cont.31174
fjge_else.31173:
	ld	%g4, %g1, 24
fjge_cont.31174:
	ld	%g6, %g1, 20
	jne	%g4, %g6, jeq_else.31175
	fst	%f1, %g3, 0
	jmp	jeq_cont.31176
jeq_else.31175:
	setL %g4, l.23128
	fld	%f1, %g4, 0
	fdiv	%f1, %f1, %f0
	fst	%f1, %g3, 0
	ld	%g4, %g5, -16
	fld	%f1, %g4, 0
	fdiv	%f1, %f1, %f0
	fneg	%f1, %f1
	fst	%f1, %g3, -4
	ld	%g4, %g5, -16
	fld	%f1, %g4, -4
	fdiv	%f1, %f1, %f0
	fneg	%f1, %f1
	fst	%f1, %g3, -8
	ld	%g4, %g5, -16
	fld	%f1, %g4, -8
	fdiv	%f0, %f1, %f0
	fneg	%f0, %f0
	fst	%f0, %g3, -12
jeq_cont.31176:
	ld	%g4, %g1, 12
	slli	%g5, %g4, 2
	ld	%g6, %g1, 8
	st	%g6, %g1, 44
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 44
	jmp	jeq_cont.31172
jeq_else.31171:
	mvhi	%g8, 0
	mvlo	%g8, 5
	setL %g11, l.22821
	fld	%f0, %g11, 0
	st	%g9, %g1, 8
	st	%g4, %g1, 12
	st	%g10, %g1, 24
	fst	%f0, %g1, 40
	st	%g6, %g1, 20
	st	%g5, %g1, 16
	st	%g7, %g1, 32
	mov	%g3, %g8
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 32
	fld	%f0, %g4, 0
	fld	%f1, %g4, -4
	fld	%f2, %g4, -8
	fmul	%f3, %f0, %f0
	ld	%g5, %g1, 16
	ld	%g6, %g5, -16
	fld	%f4, %g6, 0
	fmul	%f3, %f3, %f4
	fmul	%f5, %f1, %f1
	ld	%g6, %g5, -16
	fld	%f6, %g6, -4
	fmul	%f5, %f5, %f6
	fadd	%f3, %f3, %f5
	fmul	%f5, %f2, %f2
	ld	%g6, %g5, -16
	fld	%f7, %g6, -8
	fmul	%f5, %f5, %f7
	fadd	%f3, %f3, %f5
	ld	%g6, %g5, -12
	ld	%g7, %g1, 20
	jne	%g6, %g7, jeq_else.31177
	jmp	jeq_cont.31178
jeq_else.31177:
	fmul	%f5, %f1, %f2
	ld	%g8, %g5, -36
	fld	%f8, %g8, 0
	fmul	%f5, %f5, %f8
	fadd	%f3, %f3, %f5
	fmul	%f5, %f2, %f0
	ld	%g8, %g5, -36
	fld	%f8, %g8, -4
	fmul	%f5, %f5, %f8
	fadd	%f3, %f3, %f5
	fmul	%f5, %f0, %f1
	ld	%g8, %g5, -36
	fld	%f8, %g8, -8
	fmul	%f5, %f5, %f8
	fadd	%f3, %f3, %f5
jeq_cont.31178:
	fmul	%f0, %f0, %f4
	fneg	%f0, %f0
	fmul	%f1, %f1, %f6
	fneg	%f1, %f1
	fmul	%f2, %f2, %f7
	fneg	%f2, %f2
	fst	%f3, %g3, 0
	jne	%g6, %g7, jeq_else.31179
	fst	%f0, %g3, -4
	fst	%f1, %g3, -8
	fst	%f2, %g3, -12
	jmp	jeq_cont.31180
jeq_else.31179:
	fld	%f4, %g4, -8
	ld	%g6, %g5, -36
	fld	%f5, %g6, -4
	fmul	%f4, %f4, %f5
	fld	%f5, %g4, -4
	ld	%g6, %g5, -36
	fld	%f6, %g6, -8
	fmul	%f5, %f5, %f6
	fadd	%f4, %f4, %f5
	setL %g6, l.22817
	fld	%f5, %g6, 0
	fdiv	%f4, %f4, %f5
	fsub	%f0, %f0, %f4
	fst	%f0, %g3, -4
	fld	%f0, %g4, -8
	ld	%g6, %g5, -36
	fld	%f4, %g6, 0
	fmul	%f0, %f0, %f4
	fld	%f4, %g4, 0
	ld	%g6, %g5, -36
	fld	%f6, %g6, -8
	fmul	%f4, %f4, %f6
	fadd	%f0, %f0, %f4
	fdiv	%f0, %f0, %f5
	fsub	%f0, %f1, %f0
	fst	%f0, %g3, -8
	fld	%f0, %g4, -4
	ld	%g6, %g5, -36
	fld	%f1, %g6, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g4, 0
	ld	%g4, %g5, -36
	fld	%f4, %g4, -4
	fmul	%f1, %f1, %f4
	fadd	%f0, %f0, %f1
	fdiv	%f0, %f0, %f5
	fsub	%f0, %f2, %f0
	fst	%f0, %g3, -12
jeq_cont.31180:
	fld	%f0, %g1, 40
	fjeq	%f3, %f0, fjne_else.31181
	mov	%g4, %g7
	jmp	fjne_cont.31182
fjne_else.31181:
	ld	%g4, %g1, 24
fjne_cont.31182:
	jne	%g4, %g7, jeq_else.31183
	setL %g4, l.22819
	fld	%f0, %g4, 0
	fdiv	%f0, %f0, %f3
	fst	%f0, %g3, -16
	jmp	jeq_cont.31184
jeq_else.31183:
jeq_cont.31184:
	ld	%g4, %g1, 12
	slli	%g5, %g4, 2
	ld	%g6, %g1, 8
	st	%g6, %g1, 44
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 44
jeq_cont.31172:
jeq_cont.31134:
	subi	%g4, %g4, 1
	ld	%g3, %g1, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jle_else.31132:
	return
setup_startp_constants.3013:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g4, %g6, jle_else.31186
	slli	%g7, %g4, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g7
	ld	%g5, %g5, 0
	ld	%g7, %g5, -40
	ld	%g8, %g5, -20
	fld	%f0, %g8, 0
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	fst	%f0, %g7, 0
	ld	%g8, %g5, -20
	fld	%f0, %g8, -4
	fld	%f1, %g3, -4
	fsub	%f0, %f1, %f0
	fst	%f0, %g7, -4
	ld	%g8, %g5, -20
	mvhi	%g9, 0
	mvlo	%g9, 2
	fld	%f0, %g8, -8
	fld	%f1, %g3, -8
	fsub	%f0, %f1, %f0
	fst	%f0, %g7, -8
	ld	%g8, %g5, -4
	jne	%g8, %g9, jeq_else.31187
	ld	%g5, %g5, -16
	fld	%f0, %g7, 0
	fld	%f1, %g7, -4
	fld	%f2, %g7, -8
	fld	%f3, %g5, 0
	fmul	%f0, %f3, %f0
	fld	%f3, %g5, -4
	fmul	%f1, %f3, %f1
	fadd	%f0, %f0, %f1
	fld	%f1, %g5, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g7, -12
	jmp	jeq_cont.31188
jeq_else.31187:
	jlt	%g9, %g8, jle_else.31189
	jmp	jle_cont.31190
jle_else.31189:
	fld	%f0, %g7, 0
	fld	%f1, %g7, -4
	fld	%f2, %g7, -8
	fmul	%f3, %f0, %f0
	ld	%g9, %g5, -16
	fld	%f4, %g9, 0
	fmul	%f3, %f3, %f4
	fmul	%f4, %f1, %f1
	ld	%g9, %g5, -16
	fld	%f5, %g9, -4
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	fmul	%f4, %f2, %f2
	ld	%g9, %g5, -16
	fld	%f5, %g9, -8
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	ld	%g9, %g5, -12
	jne	%g9, %g6, jeq_else.31191
	fmov	%f0, %f3
	jmp	jeq_cont.31192
jeq_else.31191:
	fmul	%f4, %f1, %f2
	ld	%g6, %g5, -36
	fld	%f5, %g6, 0
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	fmul	%f2, %f2, %f0
	ld	%g6, %g5, -36
	fld	%f4, %g6, -4
	fmul	%f2, %f2, %f4
	fadd	%f2, %f3, %f2
	fmul	%f0, %f0, %f1
	ld	%g5, %g5, -36
	fld	%f1, %g5, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
jeq_cont.31192:
	mvhi	%g5, 0
	mvlo	%g5, 3
	jne	%g8, %g5, jeq_else.31193
	setL %g5, l.22819
	fld	%f1, %g5, 0
	fsub	%f0, %f0, %f1
	jmp	jeq_cont.31194
jeq_else.31193:
jeq_cont.31194:
	fst	%f0, %g7, -12
jle_cont.31190:
jeq_cont.31188:
	subi	%g4, %g4, 1
	ld	%g28, %g29, 0
	b	%g28
jle_else.31186:
	return
check_all_inside.3038:
	ld	%g5, %g29, -4
	slli	%g6, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g6
	ld	%g6, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g7, 65535
	mvlo	%g7, -1
	mvhi	%g8, 0
	mvlo	%g8, 1
	jne	%g6, %g7, jeq_else.31196
	mov	%g3, %g8
	return
jeq_else.31196:
	slli	%g6, %g6, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g6
	ld	%g5, %g5, 0
	ld	%g6, %g5, -20
	ld	%g7, %g5, -20
	ld	%g9, %g5, -20
	ld	%g10, %g5, -4
	mvhi	%g11, 0
	mvlo	%g11, 0
	mvhi	%g12, 0
	mvlo	%g12, 2
	fld	%f3, %g9, -8
	fsub	%f3, %f2, %f3
	fld	%f4, %g7, -4
	fsub	%f4, %f1, %f4
	fld	%f5, %g6, 0
	fsub	%f5, %f0, %f5
	jne	%g10, %g8, jeq_else.31197
	setL %g6, l.22821
	fld	%f6, %g6, 0
	fjlt	%f5, %f6, fjge_else.31199
	jmp	fjge_cont.31200
fjge_else.31199:
	fneg	%f5, %f5
fjge_cont.31200:
	ld	%g6, %g5, -16
	fld	%f7, %g6, 0
	fjlt	%f5, %f7, fjge_else.31201
	mov	%g6, %g11
	jmp	fjge_cont.31202
fjge_else.31201:
	mov	%g6, %g8
fjge_cont.31202:
	jne	%g6, %g11, jeq_else.31203
	mov	%g6, %g11
	jmp	jeq_cont.31204
jeq_else.31203:
	fjlt	%f4, %f6, fjge_else.31205
	jmp	fjge_cont.31206
fjge_else.31205:
	fneg	%f4, %f4
fjge_cont.31206:
	ld	%g6, %g5, -16
	fld	%f5, %g6, -4
	fjlt	%f4, %f5, fjge_else.31207
	mov	%g6, %g11
	jmp	fjge_cont.31208
fjge_else.31207:
	mov	%g6, %g8
fjge_cont.31208:
	jne	%g6, %g11, jeq_else.31209
	mov	%g6, %g11
	jmp	jeq_cont.31210
jeq_else.31209:
	fjlt	%f3, %f6, fjge_else.31211
	jmp	fjge_cont.31212
fjge_else.31211:
	fneg	%f3, %f3
fjge_cont.31212:
	ld	%g6, %g5, -16
	fld	%f4, %g6, -8
	fjlt	%f3, %f4, fjge_else.31213
	mov	%g6, %g11
	jmp	fjge_cont.31214
fjge_else.31213:
	mov	%g6, %g8
fjge_cont.31214:
jeq_cont.31210:
jeq_cont.31204:
	jne	%g6, %g11, jeq_else.31215
	ld	%g5, %g5, -24
	jne	%g5, %g11, jeq_else.31217
	mov	%g5, %g8
	jmp	jeq_cont.31218
jeq_else.31217:
	mov	%g5, %g11
jeq_cont.31218:
	jmp	jeq_cont.31216
jeq_else.31215:
	ld	%g5, %g5, -24
jeq_cont.31216:
	jmp	jeq_cont.31198
jeq_else.31197:
	jne	%g10, %g12, jeq_else.31219
	ld	%g6, %g5, -16
	fld	%f6, %g6, 0
	fmul	%f5, %f6, %f5
	fld	%f6, %g6, -4
	fmul	%f4, %f6, %f4
	fadd	%f4, %f5, %f4
	fld	%f5, %g6, -8
	fmul	%f3, %f5, %f3
	fadd	%f3, %f4, %f3
	ld	%g5, %g5, -24
	setL %g6, l.22821
	fld	%f4, %g6, 0
	fjlt	%f3, %f4, fjge_else.31221
	mov	%g6, %g11
	jmp	fjge_cont.31222
fjge_else.31221:
	mov	%g6, %g8
fjge_cont.31222:
	jne	%g5, %g11, jeq_else.31223
	mov	%g5, %g6
	jmp	jeq_cont.31224
jeq_else.31223:
	jne	%g6, %g11, jeq_else.31225
	mov	%g5, %g8
	jmp	jeq_cont.31226
jeq_else.31225:
	mov	%g5, %g11
jeq_cont.31226:
jeq_cont.31224:
	jne	%g5, %g11, jeq_else.31227
	mov	%g5, %g8
	jmp	jeq_cont.31228
jeq_else.31227:
	mov	%g5, %g11
jeq_cont.31228:
	jmp	jeq_cont.31220
jeq_else.31219:
	fmul	%f6, %f5, %f5
	ld	%g6, %g5, -16
	fld	%f7, %g6, 0
	fmul	%f6, %f6, %f7
	fmul	%f7, %f4, %f4
	ld	%g6, %g5, -16
	fld	%f8, %g6, -4
	fmul	%f7, %f7, %f8
	fadd	%f6, %f6, %f7
	fmul	%f7, %f3, %f3
	ld	%g6, %g5, -16
	fld	%f8, %g6, -8
	fmul	%f7, %f7, %f8
	fadd	%f6, %f6, %f7
	ld	%g6, %g5, -12
	jne	%g6, %g11, jeq_else.31229
	fmov	%f3, %f6
	jmp	jeq_cont.31230
jeq_else.31229:
	fmul	%f7, %f4, %f3
	ld	%g6, %g5, -36
	fld	%f8, %g6, 0
	fmul	%f7, %f7, %f8
	fadd	%f6, %f6, %f7
	fmul	%f3, %f3, %f5
	ld	%g6, %g5, -36
	fld	%f7, %g6, -4
	fmul	%f3, %f3, %f7
	fadd	%f3, %f6, %f3
	fmul	%f4, %f5, %f4
	ld	%g6, %g5, -36
	fld	%f5, %g6, -8
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
jeq_cont.31230:
	mvhi	%g6, 0
	mvlo	%g6, 3
	jne	%g10, %g6, jeq_else.31231
	setL %g6, l.22819
	fld	%f4, %g6, 0
	fsub	%f3, %f3, %f4
	jmp	jeq_cont.31232
jeq_else.31231:
jeq_cont.31232:
	ld	%g5, %g5, -24
	setL %g6, l.22821
	fld	%f4, %g6, 0
	fjlt	%f3, %f4, fjge_else.31233
	mov	%g6, %g11
	jmp	fjge_cont.31234
fjge_else.31233:
	mov	%g6, %g8
fjge_cont.31234:
	jne	%g5, %g11, jeq_else.31235
	mov	%g5, %g6
	jmp	jeq_cont.31236
jeq_else.31235:
	jne	%g6, %g11, jeq_else.31237
	mov	%g5, %g8
	jmp	jeq_cont.31238
jeq_else.31237:
	mov	%g5, %g11
jeq_cont.31238:
jeq_cont.31236:
	jne	%g5, %g11, jeq_else.31239
	mov	%g5, %g8
	jmp	jeq_cont.31240
jeq_else.31239:
	mov	%g5, %g11
jeq_cont.31240:
jeq_cont.31220:
jeq_cont.31198:
	jne	%g5, %g11, jeq_else.31241
	addi	%g3, %g3, 1
	ld	%g28, %g29, 0
	b	%g28
jeq_else.31241:
	mov	%g3, %g11
	return
shadow_check_and_group.3044:
	ld	%g5, %g29, -28
	ld	%g6, %g29, -24
	ld	%g7, %g29, -20
	ld	%g8, %g29, -16
	ld	%g9, %g29, -12
	ld	%g10, %g29, -8
	ld	%g11, %g29, -4
	mvhi	%g12, 65535
	mvlo	%g12, -1
	slli	%g13, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g13
	ld	%g13, %g4, 0
	ld	%g4, %g1, 4
	jne	%g13, %g12, jeq_else.31242
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.31242:
	st	%g11, %g1, 0
	st	%g9, %g1, 4
	st	%g10, %g1, 8
	st	%g4, %g1, 12
	st	%g29, %g1, 16
	st	%g3, %g1, 20
	st	%g7, %g1, 24
	st	%g13, %g1, 28
	st	%g6, %g1, 32
	mov	%g4, %g8
	mov	%g3, %g13
	mov	%g29, %g5
	mov	%g5, %g10
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g5, %g1, 32
	fld	%f0, %g5, 0
	mvhi	%g5, 0
	mvlo	%g5, 1
	jne	%g3, %g4, jeq_else.31243
	mov	%g3, %g4
	jmp	jeq_cont.31244
jeq_else.31243:
	setL %g3, l.23603
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.31245
	mov	%g3, %g4
	jmp	fjge_cont.31246
fjge_else.31245:
	mov	%g3, %g5
fjge_cont.31246:
jeq_cont.31244:
	jne	%g3, %g4, jeq_else.31247
	ld	%g3, %g1, 28
	slli	%g3, %g3, 2
	ld	%g5, %g1, 24
	st	%g5, %g1, 36
	add	%g5, %g5, %g3
	ld	%g3, %g5, 0
	ld	%g5, %g1, 36
	ld	%g3, %g3, -24
	jne	%g3, %g4, jeq_else.31248
	mov	%g3, %g4
	return
jeq_else.31248:
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	ld	%g4, %g1, 12
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.31247:
	ld	%g3, %g1, 8
	fld	%f1, %g3, -8
	setL %g6, l.23607
	fld	%f2, %g6, 0
	fadd	%f0, %f0, %f2
	ld	%g6, %g1, 4
	fld	%f2, %g6, -8
	fmul	%f2, %f2, %f0
	fadd	%f2, %f2, %f1
	fld	%f1, %g3, -4
	fld	%f3, %g6, -4
	fmul	%f3, %f3, %f0
	fadd	%f1, %f3, %f1
	fld	%f3, %g3, 0
	fld	%f4, %g6, 0
	fmul	%f0, %f4, %f0
	fadd	%f0, %f0, %f3
	ld	%g3, %g1, 12
	ld	%g29, %g1, 0
	st	%g5, %g1, 36
	st	%g4, %g1, 40
	mov	%g28, %g4
	mov	%g4, %g3
	mov	%g3, %g28
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 40
	jne	%g3, %g4, jeq_else.31249
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	ld	%g4, %g1, 12
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.31249:
	ld	%g3, %g1, 36
	return
shadow_check_one_or_group.3047:
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	slli	%g7, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g7
	ld	%g7, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g8, 65535
	mvlo	%g8, -1
	jne	%g7, %g8, jeq_else.31250
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.31250:
	slli	%g7, %g7, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g7
	ld	%g6, %g6, 0
	mvhi	%g7, 0
	mvlo	%g7, 0
	st	%g4, %g1, 0
	st	%g29, %g1, 4
	st	%g3, %g1, 8
	st	%g7, %g1, 12
	mov	%g4, %g6
	mov	%g3, %g7
	mov	%g29, %g5
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 1
	ld	%g5, %g1, 12
	jne	%g3, %g5, jeq_else.31251
	ld	%g3, %g1, 8
	addi	%g3, %g3, 1
	ld	%g4, %g1, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.31251:
	mov	%g3, %g4
	return
shadow_check_one_or_matrix.3050:
	ld	%g5, %g29, -20
	ld	%g6, %g29, -16
	ld	%g7, %g29, -12
	ld	%g8, %g29, -8
	ld	%g9, %g29, -4
	slli	%g10, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g10
	ld	%g10, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g11, 0
	mvlo	%g11, 0
	ld	%g12, %g10, 0
	mvhi	%g13, 65535
	mvlo	%g13, -1
	jne	%g12, %g13, jeq_else.31252
	mov	%g3, %g11
	return
jeq_else.31252:
	mvhi	%g13, 0
	mvlo	%g13, 99
	mvhi	%g14, 0
	mvlo	%g14, 1
	st	%g10, %g1, 0
	st	%g14, %g1, 4
	st	%g7, %g1, 8
	st	%g4, %g1, 12
	st	%g29, %g1, 16
	st	%g3, %g1, 20
	st	%g11, %g1, 24
	jne	%g12, %g13, jeq_else.31253
	mov	%g3, %g14
	jmp	jeq_cont.31254
jeq_else.31253:
	st	%g6, %g1, 28
	mov	%g4, %g8
	mov	%g3, %g12
	mov	%g29, %g5
	mov	%g5, %g9
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 24
	jne	%g3, %g4, jeq_else.31255
	mov	%g3, %g4
	jmp	jeq_cont.31256
jeq_else.31255:
	ld	%g3, %g1, 28
	fld	%f0, %g3, 0
	setL %g3, l.23631
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.31257
	mov	%g3, %g4
	jmp	fjge_cont.31258
fjge_else.31257:
	ld	%g3, %g1, 4
fjge_cont.31258:
	jne	%g3, %g4, jeq_else.31259
	mov	%g3, %g4
	jmp	jeq_cont.31260
jeq_else.31259:
	ld	%g3, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	mov	%g4, %g5
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 24
	jne	%g3, %g4, jeq_else.31261
	mov	%g3, %g4
	jmp	jeq_cont.31262
jeq_else.31261:
	ld	%g3, %g1, 4
jeq_cont.31262:
jeq_cont.31260:
jeq_cont.31256:
jeq_cont.31254:
	ld	%g4, %g1, 24
	jne	%g3, %g4, jeq_else.31263
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	ld	%g4, %g1, 12
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.31263:
	ld	%g3, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	mov	%g4, %g5
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 24
	jne	%g3, %g4, jeq_else.31264
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	ld	%g4, %g1, 12
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.31264:
	ld	%g3, %g1, 4
	return
solve_each_element.3053:
	ld	%g6, %g29, -36
	ld	%g7, %g29, -32
	ld	%g8, %g29, -28
	ld	%g9, %g29, -24
	ld	%g10, %g29, -20
	ld	%g11, %g29, -16
	ld	%g12, %g29, -12
	ld	%g13, %g29, -8
	ld	%g14, %g29, -4
	slli	%g15, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g15
	ld	%g15, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g16, 65535
	mvlo	%g16, -1
	jne	%g15, %g16, jeq_else.31265
	return
jeq_else.31265:
	st	%g11, %g1, 0
	st	%g13, %g1, 4
	st	%g12, %g1, 8
	st	%g14, %g1, 12
	st	%g7, %g1, 16
	st	%g6, %g1, 20
	st	%g8, %g1, 24
	st	%g5, %g1, 28
	st	%g4, %g1, 32
	st	%g29, %g1, 36
	st	%g3, %g1, 40
	st	%g10, %g1, 44
	st	%g15, %g1, 48
	mov	%g4, %g5
	mov	%g3, %g15
	mov	%g29, %g9
	mov	%g5, %g7
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	mvhi	%g5, 0
	mvlo	%g5, 1
	jne	%g3, %g4, jeq_else.31267
	ld	%g3, %g1, 48
	slli	%g3, %g3, 2
	ld	%g5, %g1, 44
	st	%g5, %g1, 52
	add	%g5, %g5, %g3
	ld	%g3, %g5, 0
	ld	%g5, %g1, 52
	ld	%g3, %g3, -24
	jne	%g3, %g4, jeq_else.31268
	return
jeq_else.31268:
	ld	%g3, %g1, 40
	addi	%g3, %g3, 1
	ld	%g4, %g1, 32
	ld	%g5, %g1, 28
	ld	%g29, %g1, 36
	ld	%g28, %g29, 0
	b	%g28
jeq_else.31267:
	ld	%g6, %g1, 24
	fld	%f0, %g6, 0
	setL %g6, l.22821
	fld	%f1, %g6, 0
	fjlt	%f1, %f0, fjge_else.31270
	mov	%g6, %g4
	jmp	fjge_cont.31271
fjge_else.31270:
	mov	%g6, %g5
fjge_cont.31271:
	jne	%g6, %g4, jeq_else.31272
	jmp	jeq_cont.31273
jeq_else.31272:
	ld	%g6, %g1, 20
	fld	%f1, %g6, 0
	fjlt	%f0, %f1, fjge_else.31274
	mov	%g5, %g4
	jmp	fjge_cont.31275
fjge_else.31274:
fjge_cont.31275:
	jne	%g5, %g4, jeq_else.31276
	jmp	jeq_cont.31277
jeq_else.31276:
	setL %g5, l.23607
	fld	%f1, %g5, 0
	fadd	%f0, %f0, %f1
	ld	%g5, %g1, 28
	fld	%f1, %g5, 0
	fmul	%f1, %f1, %f0
	ld	%g7, %g1, 16
	fld	%f2, %g7, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g5, -4
	fmul	%f2, %f2, %f0
	fld	%f3, %g7, -4
	fadd	%f2, %f2, %f3
	fld	%f3, %g5, -8
	fmul	%f3, %f3, %f0
	fld	%f4, %g7, -8
	fadd	%f3, %f3, %f4
	ld	%g7, %g1, 32
	ld	%g29, %g1, 12
	st	%g3, %g1, 52
	fst	%f3, %g1, 56
	fst	%f2, %g1, 60
	fst	%f1, %g1, 64
	fst	%f0, %g1, 68
	st	%g4, %g1, 72
	mov	%g3, %g4
	mov	%g4, %g7
	fmov	%f0, %f1
	fmov	%f1, %f2
	fmov	%f2, %f3
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g4, %g1, 72
	jne	%g3, %g4, jeq_else.31278
	jmp	jeq_cont.31279
jeq_else.31278:
	ld	%g3, %g1, 20
	fld	%f0, %g1, 68
	fst	%f0, %g3, 0
	ld	%g3, %g1, 8
	fld	%f0, %g1, 64
	fst	%f0, %g3, 0
	fld	%f0, %g1, 60
	fst	%f0, %g3, -4
	fld	%f0, %g1, 56
	fst	%f0, %g3, -8
	ld	%g3, %g1, 4
	ld	%g4, %g1, 48
	st	%g4, %g3, 0
	ld	%g3, %g1, 0
	ld	%g4, %g1, 52
	st	%g4, %g3, 0
jeq_cont.31279:
jeq_cont.31277:
jeq_cont.31273:
	ld	%g3, %g1, 40
	addi	%g3, %g3, 1
	ld	%g4, %g1, 32
	ld	%g5, %g1, 28
	ld	%g29, %g1, 36
	ld	%g28, %g29, 0
	b	%g28
solve_one_or_network.3057:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	slli	%g8, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g8
	ld	%g8, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g9, 65535
	mvlo	%g9, -1
	jne	%g8, %g9, jeq_else.31280
	return
jeq_else.31280:
	slli	%g8, %g8, 2
	st	%g7, %g1, 4
	add	%g7, %g7, %g8
	ld	%g7, %g7, 0
	mvhi	%g8, 0
	mvlo	%g8, 0
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g29, %g1, 8
	st	%g3, %g1, 12
	mov	%g4, %g7
	mov	%g3, %g8
	mov	%g29, %g6
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
trace_or_matrix.3061:
	ld	%g6, %g29, -20
	ld	%g7, %g29, -16
	ld	%g8, %g29, -12
	ld	%g9, %g29, -8
	ld	%g10, %g29, -4
	slli	%g11, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g11
	ld	%g11, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g12, 0
	mvlo	%g12, 0
	ld	%g13, %g11, 0
	mvhi	%g14, 65535
	mvlo	%g14, -1
	jne	%g13, %g14, jeq_else.31282
	return
jeq_else.31282:
	mvhi	%g14, 0
	mvlo	%g14, 99
	mvhi	%g15, 0
	mvlo	%g15, 1
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g29, %g1, 8
	st	%g3, %g1, 12
	jne	%g13, %g14, jeq_else.31284
	mov	%g4, %g11
	mov	%g3, %g15
	mov	%g29, %g10
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	jmp	jeq_cont.31285
jeq_else.31284:
	st	%g11, %g1, 16
	st	%g10, %g1, 20
	st	%g15, %g1, 24
	st	%g6, %g1, 28
	st	%g8, %g1, 32
	st	%g12, %g1, 36
	mov	%g4, %g5
	mov	%g3, %g13
	mov	%g29, %g9
	mov	%g5, %g7
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 36
	jne	%g3, %g4, jeq_else.31286
	jmp	jeq_cont.31287
jeq_else.31286:
	ld	%g3, %g1, 32
	fld	%f0, %g3, 0
	ld	%g3, %g1, 28
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.31288
	mov	%g3, %g4
	jmp	fjge_cont.31289
fjge_else.31288:
	ld	%g3, %g1, 24
fjge_cont.31289:
	jne	%g3, %g4, jeq_else.31290
	jmp	jeq_cont.31291
jeq_else.31290:
	ld	%g3, %g1, 24
	ld	%g4, %g1, 16
	ld	%g5, %g1, 0
	ld	%g29, %g1, 20
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
jeq_cont.31291:
jeq_cont.31287:
jeq_cont.31285:
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
solve_each_element_fast.3067:
	ld	%g6, %g29, -32
	ld	%g7, %g29, -28
	ld	%g8, %g29, -24
	ld	%g9, %g29, -20
	ld	%g10, %g29, -16
	ld	%g11, %g29, -12
	ld	%g12, %g29, -8
	ld	%g13, %g29, -4
	slli	%g14, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g14
	ld	%g14, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g15, 65535
	mvlo	%g15, -1
	jne	%g14, %g15, jeq_else.31292
	return
jeq_else.31292:
	ld	%g15, %g5, 0
	slli	%g16, %g14, 2
	st	%g9, %g1, 4
	add	%g9, %g9, %g16
	ld	%g16, %g9, 0
	ld	%g9, %g1, 4
	ld	%g17, %g16, -40
	ld	%g18, %g5, -4
	ld	%g19, %g16, -4
	slli	%g20, %g14, 2
	st	%g18, %g1, 4
	add	%g18, %g18, %g20
	ld	%g18, %g18, 0
	mvhi	%g20, 0
	mvlo	%g20, 2
	fld	%f0, %g17, -8
	mvhi	%g21, 0
	mvlo	%g21, 1
	fld	%f1, %g17, -4
	mvhi	%g22, 0
	mvlo	%g22, 0
	fld	%f2, %g17, 0
	st	%g10, %g1, 0
	st	%g12, %g1, 4
	st	%g11, %g1, 8
	st	%g13, %g1, 12
	st	%g7, %g1, 16
	st	%g15, %g1, 20
	st	%g6, %g1, 24
	st	%g21, %g1, 28
	st	%g8, %g1, 32
	st	%g5, %g1, 36
	st	%g4, %g1, 40
	st	%g29, %g1, 44
	st	%g3, %g1, 48
	st	%g9, %g1, 52
	st	%g14, %g1, 56
	st	%g22, %g1, 60
	jne	%g19, %g21, jeq_else.31294
	fld	%f3, %g18, -4
	fld	%f4, %g18, 0
	fsub	%f4, %f4, %f2
	fmul	%f4, %f4, %f3
	ld	%g17, %g16, -16
	fld	%f5, %g17, -4
	fld	%f6, %g15, -4
	fmul	%f6, %f4, %f6
	fadd	%f6, %f6, %f1
	setL %g17, l.22821
	fld	%f7, %g17, 0
	fjlt	%f6, %f7, fjge_else.31296
	jmp	fjge_cont.31297
fjge_else.31296:
	fneg	%f6, %f6
fjge_cont.31297:
	fjlt	%f6, %f5, fjge_else.31298
	mov	%g17, %g22
	jmp	fjge_cont.31299
fjge_else.31298:
	mov	%g17, %g21
fjge_cont.31299:
	jne	%g17, %g22, jeq_else.31300
	mov	%g17, %g22
	jmp	jeq_cont.31301
jeq_else.31300:
	fld	%f5, %g15, -8
	fmul	%f5, %f4, %f5
	fadd	%f5, %f5, %f0
	fjlt	%f5, %f7, fjge_else.31302
	jmp	fjge_cont.31303
fjge_else.31302:
	fneg	%f5, %f5
fjge_cont.31303:
	ld	%g17, %g16, -16
	fld	%f6, %g17, -8
	fjlt	%f5, %f6, fjge_else.31304
	mov	%g17, %g22
	jmp	fjge_cont.31305
fjge_else.31304:
	mov	%g17, %g21
fjge_cont.31305:
	jne	%g17, %g22, jeq_else.31306
	mov	%g17, %g22
	jmp	jeq_cont.31307
jeq_else.31306:
	fjeq	%f3, %f7, fjne_else.31308
	mov	%g17, %g22
	jmp	fjne_cont.31309
fjne_else.31308:
	mov	%g17, %g21
fjne_cont.31309:
	jne	%g17, %g22, jeq_else.31310
	mov	%g17, %g21
	jmp	jeq_cont.31311
jeq_else.31310:
	mov	%g17, %g22
jeq_cont.31311:
jeq_cont.31307:
jeq_cont.31301:
	jne	%g17, %g22, jeq_else.31312
	mvhi	%g17, 0
	mvlo	%g17, 3
	fld	%f3, %g18, -12
	fld	%f4, %g18, -8
	fsub	%f4, %f4, %f1
	fmul	%f4, %f4, %f3
	ld	%g19, %g16, -16
	fld	%f5, %g19, 0
	fld	%f6, %g15, 0
	fmul	%f6, %f4, %f6
	fadd	%f6, %f6, %f2
	fjlt	%f6, %f7, fjge_else.31314
	jmp	fjge_cont.31315
fjge_else.31314:
	fneg	%f6, %f6
fjge_cont.31315:
	fjlt	%f6, %f5, fjge_else.31316
	mov	%g19, %g22
	jmp	fjge_cont.31317
fjge_else.31316:
	mov	%g19, %g21
fjge_cont.31317:
	jne	%g19, %g22, jeq_else.31318
	mov	%g19, %g22
	jmp	jeq_cont.31319
jeq_else.31318:
	fld	%f5, %g15, -8
	fmul	%f5, %f4, %f5
	fadd	%f5, %f5, %f0
	fjlt	%f5, %f7, fjge_else.31320
	jmp	fjge_cont.31321
fjge_else.31320:
	fneg	%f5, %f5
fjge_cont.31321:
	ld	%g19, %g16, -16
	fld	%f6, %g19, -8
	fjlt	%f5, %f6, fjge_else.31322
	mov	%g19, %g22
	jmp	fjge_cont.31323
fjge_else.31322:
	mov	%g19, %g21
fjge_cont.31323:
	jne	%g19, %g22, jeq_else.31324
	mov	%g19, %g22
	jmp	jeq_cont.31325
jeq_else.31324:
	fjeq	%f3, %f7, fjne_else.31326
	mov	%g19, %g22
	jmp	fjne_cont.31327
fjne_else.31326:
	mov	%g19, %g21
fjne_cont.31327:
	jne	%g19, %g22, jeq_else.31328
	mov	%g19, %g21
	jmp	jeq_cont.31329
jeq_else.31328:
	mov	%g19, %g22
jeq_cont.31329:
jeq_cont.31325:
jeq_cont.31319:
	jne	%g19, %g22, jeq_else.31330
	fld	%f3, %g18, -20
	fld	%f4, %g18, -16
	fsub	%f0, %f4, %f0
	fmul	%f0, %f0, %f3
	ld	%g18, %g16, -16
	fld	%f4, %g18, 0
	fld	%f5, %g15, 0
	fmul	%f5, %f0, %f5
	fadd	%f2, %f5, %f2
	fjlt	%f2, %f7, fjge_else.31332
	jmp	fjge_cont.31333
fjge_else.31332:
	fneg	%f2, %f2
fjge_cont.31333:
	fjlt	%f2, %f4, fjge_else.31334
	mov	%g18, %g22
	jmp	fjge_cont.31335
fjge_else.31334:
	mov	%g18, %g21
fjge_cont.31335:
	jne	%g18, %g22, jeq_else.31336
	mov	%g16, %g22
	jmp	jeq_cont.31337
jeq_else.31336:
	fld	%f2, %g15, -4
	fmul	%f2, %f0, %f2
	fadd	%f1, %f2, %f1
	fjlt	%f1, %f7, fjge_else.31338
	jmp	fjge_cont.31339
fjge_else.31338:
	fneg	%f1, %f1
fjge_cont.31339:
	ld	%g16, %g16, -16
	fld	%f2, %g16, -4
	fjlt	%f1, %f2, fjge_else.31340
	mov	%g16, %g22
	jmp	fjge_cont.31341
fjge_else.31340:
	mov	%g16, %g21
fjge_cont.31341:
	jne	%g16, %g22, jeq_else.31342
	mov	%g16, %g22
	jmp	jeq_cont.31343
jeq_else.31342:
	fjeq	%f3, %f7, fjne_else.31344
	mov	%g16, %g22
	jmp	fjne_cont.31345
fjne_else.31344:
	mov	%g16, %g21
fjne_cont.31345:
	jne	%g16, %g22, jeq_else.31346
	mov	%g16, %g21
	jmp	jeq_cont.31347
jeq_else.31346:
	mov	%g16, %g22
jeq_cont.31347:
jeq_cont.31343:
jeq_cont.31337:
	jne	%g16, %g22, jeq_else.31348
	mov	%g3, %g22
	jmp	jeq_cont.31349
jeq_else.31348:
	fst	%f0, %g8, 0
	mov	%g3, %g17
jeq_cont.31349:
	jmp	jeq_cont.31331
jeq_else.31330:
	fst	%f4, %g8, 0
	mov	%g3, %g20
jeq_cont.31331:
	jmp	jeq_cont.31313
jeq_else.31312:
	fst	%f4, %g8, 0
	mov	%g3, %g21
jeq_cont.31313:
	jmp	jeq_cont.31295
jeq_else.31294:
	jne	%g19, %g20, jeq_else.31350
	fld	%f0, %g18, 0
	setL %g16, l.22821
	fld	%f1, %g16, 0
	fjlt	%f0, %f1, fjge_else.31352
	mov	%g16, %g22
	jmp	fjge_cont.31353
fjge_else.31352:
	mov	%g16, %g21
fjge_cont.31353:
	jne	%g16, %g22, jeq_else.31354
	mov	%g3, %g22
	jmp	jeq_cont.31355
jeq_else.31354:
	fld	%f1, %g17, -12
	fmul	%f0, %f0, %f1
	fst	%f0, %g8, 0
	mov	%g3, %g21
jeq_cont.31355:
	jmp	jeq_cont.31351
jeq_else.31350:
	fld	%f3, %g18, 0
	setL %g19, l.22821
	fld	%f4, %g19, 0
	fjeq	%f3, %f4, fjne_else.31356
	mov	%g19, %g22
	jmp	fjne_cont.31357
fjne_else.31356:
	mov	%g19, %g21
fjne_cont.31357:
	jne	%g19, %g22, jeq_else.31358
	fld	%f5, %g18, -4
	fmul	%f2, %f5, %f2
	fld	%f5, %g18, -8
	fmul	%f1, %f5, %f1
	fadd	%f1, %f2, %f1
	fld	%f2, %g18, -12
	fmul	%f0, %f2, %f0
	fadd	%f0, %f1, %f0
	fld	%f1, %g17, -12
	fmul	%f2, %f0, %f0
	fmul	%f1, %f3, %f1
	fsub	%f1, %f2, %f1
	fjlt	%f4, %f1, fjge_else.31360
	mov	%g17, %g22
	jmp	fjge_cont.31361
fjge_else.31360:
	mov	%g17, %g21
fjge_cont.31361:
	jne	%g17, %g22, jeq_else.31362
	mov	%g3, %g22
	jmp	jeq_cont.31363
jeq_else.31362:
	ld	%g16, %g16, -24
	jne	%g16, %g22, jeq_else.31364
	st	%g18, %g1, 64
	fst	%f0, %g1, 68
	fmov	%f0, %f1
	fsqrt	%f0, %f0
	fld	%f1, %g1, 68
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 64
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 32
	fst	%f0, %g3, 0
	jmp	jeq_cont.31365
jeq_else.31364:
	st	%g18, %g1, 64
	fst	%f0, %g1, 68
	fmov	%f0, %f1
	fsqrt	%f0, %f0
	fld	%f1, %g1, 68
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 64
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 32
	fst	%f0, %g3, 0
jeq_cont.31365:
	ld	%g4, %g1, 28
	mov	%g3, %g4
jeq_cont.31363:
	jmp	jeq_cont.31359
jeq_else.31358:
	mov	%g3, %g22
jeq_cont.31359:
jeq_cont.31351:
jeq_cont.31295:
	ld	%g4, %g1, 60
	jne	%g3, %g4, jeq_else.31366
	ld	%g3, %g1, 56
	slli	%g3, %g3, 2
	ld	%g5, %g1, 52
	st	%g5, %g1, 76
	add	%g5, %g5, %g3
	ld	%g3, %g5, 0
	ld	%g5, %g1, 76
	ld	%g3, %g3, -24
	jne	%g3, %g4, jeq_else.31367
	return
jeq_else.31367:
	ld	%g3, %g1, 48
	addi	%g3, %g3, 1
	ld	%g4, %g1, 40
	ld	%g5, %g1, 36
	ld	%g29, %g1, 44
	ld	%g28, %g29, 0
	b	%g28
jeq_else.31366:
	ld	%g5, %g1, 32
	fld	%f0, %g5, 0
	setL %g5, l.22821
	fld	%f1, %g5, 0
	fjlt	%f1, %f0, fjge_else.31369
	mov	%g5, %g4
	jmp	fjge_cont.31370
fjge_else.31369:
	ld	%g5, %g1, 28
fjge_cont.31370:
	jne	%g5, %g4, jeq_else.31371
	jmp	jeq_cont.31372
jeq_else.31371:
	ld	%g5, %g1, 24
	fld	%f1, %g5, 0
	fjlt	%f0, %f1, fjge_else.31373
	mov	%g6, %g4
	jmp	fjge_cont.31374
fjge_else.31373:
	ld	%g6, %g1, 28
fjge_cont.31374:
	jne	%g6, %g4, jeq_else.31375
	jmp	jeq_cont.31376
jeq_else.31375:
	setL %g6, l.23607
	fld	%f1, %g6, 0
	fadd	%f0, %f0, %f1
	ld	%g6, %g1, 20
	fld	%f1, %g6, 0
	fmul	%f1, %f1, %f0
	ld	%g7, %g1, 16
	fld	%f2, %g7, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g6, -4
	fmul	%f2, %f2, %f0
	fld	%f3, %g7, -4
	fadd	%f2, %f2, %f3
	fld	%f3, %g6, -8
	fmul	%f3, %f3, %f0
	fld	%f4, %g7, -8
	fadd	%f3, %f3, %f4
	ld	%g6, %g1, 40
	ld	%g29, %g1, 12
	st	%g3, %g1, 72
	fst	%f3, %g1, 76
	fst	%f2, %g1, 80
	fst	%f1, %g1, 84
	fst	%f0, %g1, 88
	mov	%g3, %g4
	mov	%g4, %g6
	fmov	%f0, %f1
	fmov	%f1, %f2
	fmov	%f2, %f3
	st	%g31, %g1, 92
	ld	%g28, %g29, 0
	subi	%g1, %g1, 96
	callR	%g28
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	ld	%g4, %g1, 60
	jne	%g3, %g4, jeq_else.31377
	jmp	jeq_cont.31378
jeq_else.31377:
	ld	%g3, %g1, 24
	fld	%f0, %g1, 88
	fst	%f0, %g3, 0
	ld	%g3, %g1, 8
	fld	%f0, %g1, 84
	fst	%f0, %g3, 0
	fld	%f0, %g1, 80
	fst	%f0, %g3, -4
	fld	%f0, %g1, 76
	fst	%f0, %g3, -8
	ld	%g3, %g1, 4
	ld	%g4, %g1, 56
	st	%g4, %g3, 0
	ld	%g3, %g1, 0
	ld	%g4, %g1, 72
	st	%g4, %g3, 0
jeq_cont.31378:
jeq_cont.31376:
jeq_cont.31372:
	ld	%g3, %g1, 48
	addi	%g3, %g3, 1
	ld	%g4, %g1, 40
	ld	%g5, %g1, 36
	ld	%g29, %g1, 44
	ld	%g28, %g29, 0
	b	%g28
solve_one_or_network_fast.3071:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	slli	%g8, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g8
	ld	%g8, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g9, 65535
	mvlo	%g9, -1
	jne	%g8, %g9, jeq_else.31379
	return
jeq_else.31379:
	slli	%g8, %g8, 2
	st	%g7, %g1, 4
	add	%g7, %g7, %g8
	ld	%g7, %g7, 0
	mvhi	%g8, 0
	mvlo	%g8, 0
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g29, %g1, 8
	st	%g3, %g1, 12
	mov	%g4, %g7
	mov	%g3, %g8
	mov	%g29, %g6
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
trace_or_matrix_fast.3075:
	ld	%g6, %g29, -16
	ld	%g7, %g29, -12
	ld	%g8, %g29, -8
	ld	%g9, %g29, -4
	slli	%g10, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g10
	ld	%g10, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g11, 0
	mvlo	%g11, 0
	ld	%g12, %g10, 0
	mvhi	%g13, 65535
	mvlo	%g13, -1
	jne	%g12, %g13, jeq_else.31381
	return
jeq_else.31381:
	mvhi	%g13, 0
	mvlo	%g13, 99
	mvhi	%g14, 0
	mvlo	%g14, 1
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g29, %g1, 8
	st	%g3, %g1, 12
	jne	%g12, %g13, jeq_else.31383
	mov	%g4, %g10
	mov	%g3, %g14
	mov	%g29, %g8
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	jmp	jeq_cont.31384
jeq_else.31383:
	slli	%g13, %g12, 2
	st	%g9, %g1, 20
	add	%g9, %g9, %g13
	ld	%g9, %g9, 0
	ld	%g13, %g9, -40
	fld	%f0, %g13, 0
	fld	%f1, %g13, -4
	mvhi	%g15, 0
	mvlo	%g15, 2
	fld	%f2, %g13, -8
	ld	%g16, %g5, -4
	slli	%g12, %g12, 2
	st	%g16, %g1, 20
	add	%g16, %g16, %g12
	ld	%g12, %g16, 0
	ld	%g16, %g1, 20
	ld	%g16, %g9, -4
	st	%g10, %g1, 16
	st	%g8, %g1, 20
	st	%g14, %g1, 24
	st	%g6, %g1, 28
	st	%g7, %g1, 32
	st	%g11, %g1, 36
	jne	%g16, %g14, jeq_else.31385
	ld	%g13, %g5, 0
	fld	%f3, %g12, -4
	fld	%f4, %g12, 0
	fsub	%f4, %f4, %f0
	fmul	%f4, %f4, %f3
	ld	%g16, %g9, -16
	fld	%f5, %g16, -4
	fld	%f6, %g13, -4
	fmul	%f6, %f4, %f6
	fadd	%f6, %f6, %f1
	setL %g16, l.22821
	fld	%f7, %g16, 0
	fjlt	%f6, %f7, fjge_else.31387
	jmp	fjge_cont.31388
fjge_else.31387:
	fneg	%f6, %f6
fjge_cont.31388:
	fjlt	%f6, %f5, fjge_else.31389
	mov	%g16, %g11
	jmp	fjge_cont.31390
fjge_else.31389:
	mov	%g16, %g14
fjge_cont.31390:
	jne	%g16, %g11, jeq_else.31391
	mov	%g16, %g11
	jmp	jeq_cont.31392
jeq_else.31391:
	fld	%f5, %g13, -8
	fmul	%f5, %f4, %f5
	fadd	%f5, %f5, %f2
	fjlt	%f5, %f7, fjge_else.31393
	jmp	fjge_cont.31394
fjge_else.31393:
	fneg	%f5, %f5
fjge_cont.31394:
	ld	%g16, %g9, -16
	fld	%f6, %g16, -8
	fjlt	%f5, %f6, fjge_else.31395
	mov	%g16, %g11
	jmp	fjge_cont.31396
fjge_else.31395:
	mov	%g16, %g14
fjge_cont.31396:
	jne	%g16, %g11, jeq_else.31397
	mov	%g16, %g11
	jmp	jeq_cont.31398
jeq_else.31397:
	fjeq	%f3, %f7, fjne_else.31399
	mov	%g16, %g11
	jmp	fjne_cont.31400
fjne_else.31399:
	mov	%g16, %g14
fjne_cont.31400:
	jne	%g16, %g11, jeq_else.31401
	mov	%g16, %g14
	jmp	jeq_cont.31402
jeq_else.31401:
	mov	%g16, %g11
jeq_cont.31402:
jeq_cont.31398:
jeq_cont.31392:
	jne	%g16, %g11, jeq_else.31403
	mvhi	%g16, 0
	mvlo	%g16, 3
	fld	%f3, %g12, -12
	fld	%f4, %g12, -8
	fsub	%f4, %f4, %f1
	fmul	%f4, %f4, %f3
	ld	%g17, %g9, -16
	fld	%f5, %g17, 0
	fld	%f6, %g13, 0
	fmul	%f6, %f4, %f6
	fadd	%f6, %f6, %f0
	fjlt	%f6, %f7, fjge_else.31405
	jmp	fjge_cont.31406
fjge_else.31405:
	fneg	%f6, %f6
fjge_cont.31406:
	fjlt	%f6, %f5, fjge_else.31407
	mov	%g17, %g11
	jmp	fjge_cont.31408
fjge_else.31407:
	mov	%g17, %g14
fjge_cont.31408:
	jne	%g17, %g11, jeq_else.31409
	mov	%g17, %g11
	jmp	jeq_cont.31410
jeq_else.31409:
	fld	%f5, %g13, -8
	fmul	%f5, %f4, %f5
	fadd	%f5, %f5, %f2
	fjlt	%f5, %f7, fjge_else.31411
	jmp	fjge_cont.31412
fjge_else.31411:
	fneg	%f5, %f5
fjge_cont.31412:
	ld	%g17, %g9, -16
	fld	%f6, %g17, -8
	fjlt	%f5, %f6, fjge_else.31413
	mov	%g17, %g11
	jmp	fjge_cont.31414
fjge_else.31413:
	mov	%g17, %g14
fjge_cont.31414:
	jne	%g17, %g11, jeq_else.31415
	mov	%g17, %g11
	jmp	jeq_cont.31416
jeq_else.31415:
	fjeq	%f3, %f7, fjne_else.31417
	mov	%g17, %g11
	jmp	fjne_cont.31418
fjne_else.31417:
	mov	%g17, %g14
fjne_cont.31418:
	jne	%g17, %g11, jeq_else.31419
	mov	%g17, %g14
	jmp	jeq_cont.31420
jeq_else.31419:
	mov	%g17, %g11
jeq_cont.31420:
jeq_cont.31416:
jeq_cont.31410:
	jne	%g17, %g11, jeq_else.31421
	fld	%f3, %g12, -20
	fld	%f4, %g12, -16
	fsub	%f2, %f4, %f2
	fmul	%f2, %f2, %f3
	ld	%g12, %g9, -16
	fld	%f4, %g12, 0
	fld	%f5, %g13, 0
	fmul	%f5, %f2, %f5
	fadd	%f0, %f5, %f0
	fjlt	%f0, %f7, fjge_else.31423
	jmp	fjge_cont.31424
fjge_else.31423:
	fneg	%f0, %f0
fjge_cont.31424:
	fjlt	%f0, %f4, fjge_else.31425
	mov	%g12, %g11
	jmp	fjge_cont.31426
fjge_else.31425:
	mov	%g12, %g14
fjge_cont.31426:
	jne	%g12, %g11, jeq_else.31427
	mov	%g9, %g11
	jmp	jeq_cont.31428
jeq_else.31427:
	fld	%f0, %g13, -4
	fmul	%f0, %f2, %f0
	fadd	%f0, %f0, %f1
	fjlt	%f0, %f7, fjge_else.31429
	jmp	fjge_cont.31430
fjge_else.31429:
	fneg	%f0, %f0
fjge_cont.31430:
	ld	%g9, %g9, -16
	fld	%f1, %g9, -4
	fjlt	%f0, %f1, fjge_else.31431
	mov	%g9, %g11
	jmp	fjge_cont.31432
fjge_else.31431:
	mov	%g9, %g14
fjge_cont.31432:
	jne	%g9, %g11, jeq_else.31433
	mov	%g9, %g11
	jmp	jeq_cont.31434
jeq_else.31433:
	fjeq	%f3, %f7, fjne_else.31435
	mov	%g9, %g11
	jmp	fjne_cont.31436
fjne_else.31435:
	mov	%g9, %g14
fjne_cont.31436:
	jne	%g9, %g11, jeq_else.31437
	mov	%g9, %g14
	jmp	jeq_cont.31438
jeq_else.31437:
	mov	%g9, %g11
jeq_cont.31438:
jeq_cont.31434:
jeq_cont.31428:
	jne	%g9, %g11, jeq_else.31439
	mov	%g3, %g11
	jmp	jeq_cont.31440
jeq_else.31439:
	fst	%f2, %g7, 0
	mov	%g3, %g16
jeq_cont.31440:
	jmp	jeq_cont.31422
jeq_else.31421:
	fst	%f4, %g7, 0
	mov	%g3, %g15
jeq_cont.31422:
	jmp	jeq_cont.31404
jeq_else.31403:
	fst	%f4, %g7, 0
	mov	%g3, %g14
jeq_cont.31404:
	jmp	jeq_cont.31386
jeq_else.31385:
	jne	%g16, %g15, jeq_else.31441
	fld	%f0, %g12, 0
	setL %g9, l.22821
	fld	%f1, %g9, 0
	fjlt	%f0, %f1, fjge_else.31443
	mov	%g9, %g11
	jmp	fjge_cont.31444
fjge_else.31443:
	mov	%g9, %g14
fjge_cont.31444:
	jne	%g9, %g11, jeq_else.31445
	mov	%g3, %g11
	jmp	jeq_cont.31446
jeq_else.31445:
	fld	%f1, %g13, -12
	fmul	%f0, %f0, %f1
	fst	%f0, %g7, 0
	mov	%g3, %g14
jeq_cont.31446:
	jmp	jeq_cont.31442
jeq_else.31441:
	fld	%f3, %g12, 0
	setL %g15, l.22821
	fld	%f4, %g15, 0
	fjeq	%f3, %f4, fjne_else.31447
	mov	%g15, %g11
	jmp	fjne_cont.31448
fjne_else.31447:
	mov	%g15, %g14
fjne_cont.31448:
	jne	%g15, %g11, jeq_else.31449
	fld	%f5, %g12, -4
	fmul	%f0, %f5, %f0
	fld	%f5, %g12, -8
	fmul	%f1, %f5, %f1
	fadd	%f0, %f0, %f1
	fld	%f1, %g12, -12
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g13, -12
	fmul	%f2, %f0, %f0
	fmul	%f1, %f3, %f1
	fsub	%f1, %f2, %f1
	fjlt	%f4, %f1, fjge_else.31451
	mov	%g13, %g11
	jmp	fjge_cont.31452
fjge_else.31451:
	mov	%g13, %g14
fjge_cont.31452:
	jne	%g13, %g11, jeq_else.31453
	mov	%g3, %g11
	jmp	jeq_cont.31454
jeq_else.31453:
	ld	%g9, %g9, -24
	jne	%g9, %g11, jeq_else.31455
	st	%g12, %g1, 40
	fst	%f0, %g1, 44
	fmov	%f0, %f1
	fsqrt	%f0, %f0
	fld	%f1, %g1, 44
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 40
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 32
	fst	%f0, %g3, 0
	jmp	jeq_cont.31456
jeq_else.31455:
	st	%g12, %g1, 40
	fst	%f0, %g1, 44
	fmov	%f0, %f1
	fsqrt	%f0, %f0
	fld	%f1, %g1, 44
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 40
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 32
	fst	%f0, %g3, 0
jeq_cont.31456:
	ld	%g4, %g1, 24
	mov	%g3, %g4
jeq_cont.31454:
	jmp	jeq_cont.31450
jeq_else.31449:
	mov	%g3, %g11
jeq_cont.31450:
jeq_cont.31442:
jeq_cont.31386:
	ld	%g4, %g1, 36
	jne	%g3, %g4, jeq_else.31457
	jmp	jeq_cont.31458
jeq_else.31457:
	ld	%g3, %g1, 32
	fld	%f0, %g3, 0
	ld	%g3, %g1, 28
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.31459
	mov	%g3, %g4
	jmp	fjge_cont.31460
fjge_else.31459:
	ld	%g3, %g1, 24
fjge_cont.31460:
	jne	%g3, %g4, jeq_else.31461
	jmp	jeq_cont.31462
jeq_else.31461:
	ld	%g3, %g1, 24
	ld	%g4, %g1, 16
	ld	%g5, %g1, 0
	ld	%g29, %g1, 20
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
jeq_cont.31462:
jeq_cont.31458:
jeq_cont.31384:
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
tan_sub.6499.6594.6640.15550:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.31463
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31464
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31465
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31466
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	jmp	tan_sub.6499.6594.6640.15550
fjge_else.31466:
	fmov	%f0, %f2
	return
fjge_else.31465:
	fmov	%f0, %f2
	return
fjge_else.31464:
	fmov	%f0, %f2
	return
fjge_else.31463:
	fmov	%f0, %f2
	return
tan_sub.6499.6594.15621:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.31467
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31468
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31469
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31470
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	jmp	tan_sub.6499.6594.15621
fjge_else.31470:
	fmov	%f0, %f2
	return
fjge_else.31469:
	fmov	%f0, %f2
	return
fjge_else.31468:
	fmov	%f0, %f2
	return
fjge_else.31467:
	fmov	%f0, %f2
	return
utexture.3090:
	ld	%g5, %g29, -36
	ld	%g6, %g29, -32
	fld	%f0, %g29, -24
	fld	%f1, %g29, -16
	fld	%f2, %g29, -8
	ld	%g7, %g3, -32
	mvhi	%g8, 0
	mvlo	%g8, 0
	fld	%f3, %g7, 0
	fst	%f3, %g5, 0
	ld	%g7, %g3, -32
	mvhi	%g9, 0
	mvlo	%g9, 1
	fld	%f3, %g7, -4
	fst	%f3, %g5, -4
	ld	%g7, %g3, -32
	mvhi	%g10, 0
	mvlo	%g10, 2
	fld	%f3, %g7, -8
	fst	%f3, %g5, -8
	ld	%g7, %g3, 0
	jne	%g7, %g9, jeq_else.31471
	ld	%g6, %g3, -20
	ld	%g3, %g3, -20
	setL %g7, l.23902
	fld	%f0, %g7, 0
	fld	%f1, %g6, -8
	fld	%f2, %g4, -8
	fsub	%f1, %f2, %f1
	setL %g6, l.23983
	fld	%f2, %g6, 0
	fmul	%f3, %f1, %f2
	st	%g5, %g1, 0
	fst	%f2, %g1, 4
	st	%g4, %g1, 8
	st	%g3, %g1, 12
	st	%g9, %g1, 16
	st	%g8, %g1, 20
	fst	%f0, %g1, 24
	fst	%f1, %g1, 28
	fmov	%f0, %f3
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_floor
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	setL %g3, l.23985
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fld	%f2, %g1, 28
	fsub	%f0, %f2, %f0
	fld	%f2, %g1, 24
	fjlt	%f0, %f2, fjge_else.31472
	ld	%g3, %g1, 20
	jmp	fjge_cont.31473
fjge_else.31472:
	ld	%g3, %g1, 16
fjge_cont.31473:
	ld	%g4, %g1, 12
	fld	%f0, %g4, 0
	ld	%g4, %g1, 8
	fld	%f3, %g4, 0
	fsub	%f0, %f3, %f0
	fld	%f3, %g1, 4
	fmul	%f3, %f0, %f3
	st	%g3, %g1, 32
	fst	%f0, %g1, 36
	fst	%f1, %g1, 40
	fmov	%f0, %f3
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_floor
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 40
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 36
	fsub	%f0, %f1, %f0
	fld	%f1, %g1, 24
	fjlt	%f0, %f1, fjge_else.31474
	ld	%g3, %g1, 20
	jmp	fjge_cont.31475
fjge_else.31474:
	ld	%g3, %g1, 16
fjge_cont.31475:
	ld	%g4, %g1, 20
	jne	%g3, %g4, jeq_else.31476
	ld	%g3, %g1, 32
	jne	%g3, %g4, jeq_else.31478
	setL %g3, l.23938
	fld	%f0, %g3, 0
	jmp	jeq_cont.31479
jeq_else.31478:
	setL %g3, l.22821
	fld	%f0, %g3, 0
jeq_cont.31479:
	jmp	jeq_cont.31477
jeq_else.31476:
	ld	%g3, %g1, 32
	jne	%g3, %g4, jeq_else.31480
	setL %g3, l.22821
	fld	%f0, %g3, 0
	jmp	jeq_cont.31481
jeq_else.31480:
	setL %g3, l.23938
	fld	%f0, %g3, 0
jeq_cont.31481:
jeq_cont.31477:
	ld	%g3, %g1, 0
	fst	%f0, %g3, -4
	return
jeq_else.31471:
	jne	%g7, %g10, jeq_else.31483
	setL %g3, l.22821
	fld	%f3, %g3, 0
	setL %g3, l.23964
	fld	%f4, %g3, 0
	fld	%f5, %g4, -4
	fmul	%f4, %f5, %f4
	fjlt	%f4, %f3, fjge_else.31484
	fmov	%f5, %f4
	jmp	fjge_cont.31485
fjge_else.31484:
	fneg	%f5, %f4
fjge_cont.31485:
	st	%g5, %g1, 0
	fst	%f0, %g1, 44
	fst	%f1, %g1, 48
	fst	%f2, %g1, 52
	st	%g9, %g1, 16
	st	%g8, %g1, 20
	fst	%f3, %g1, 56
	fst	%f4, %g1, 60
	fjlt	%f1, %f5, fjge_else.31486
	fjlt	%f5, %f3, fjge_else.31488
	fmov	%f0, %f5
	jmp	fjge_cont.31489
fjge_else.31488:
	fadd	%f5, %f5, %f1
	mov	%g29, %g6
	fmov	%f0, %f5
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
fjge_cont.31489:
	jmp	fjge_cont.31487
fjge_else.31486:
	fsub	%f5, %f5, %f1
	mov	%g29, %g6
	fmov	%f0, %f5
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
fjge_cont.31487:
	fld	%f1, %g1, 56
	fld	%f2, %g1, 60
	fjlt	%f1, %f2, fjge_else.31490
	ld	%g3, %g1, 20
	jmp	fjge_cont.31491
fjge_else.31490:
	ld	%g3, %g1, 16
fjge_cont.31491:
	fld	%f1, %g1, 52
	fjlt	%f1, %f0, fjge_else.31492
	jmp	fjge_cont.31493
fjge_else.31492:
	ld	%g4, %g1, 20
	jne	%g3, %g4, jeq_else.31494
	ld	%g3, %g1, 16
	jmp	jeq_cont.31495
jeq_else.31494:
	mov	%g3, %g4
jeq_cont.31495:
fjge_cont.31493:
	setL %g4, l.22819
	fld	%f2, %g4, 0
	fjlt	%f1, %f0, fjge_else.31496
	jmp	fjge_cont.31497
fjge_else.31496:
	fld	%f3, %g1, 48
	fsub	%f0, %f3, %f0
fjge_cont.31497:
	fld	%f3, %g1, 44
	fjlt	%f3, %f0, fjge_else.31498
	jmp	fjge_cont.31499
fjge_else.31498:
	fsub	%f0, %f1, %f0
fjge_cont.31499:
	setL %g4, l.22815
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fmul	%f1, %f0, %f0
	setL %g4, l.23159
	fld	%f3, %g4, 0
	fdiv	%f3, %f1, %f3
	setL %g4, l.23163
	fld	%f4, %g4, 0
	fsub	%f3, %f4, %f3
	fdiv	%f3, %f1, %f3
	setL %g4, l.23165
	fld	%f4, %g4, 0
	fsub	%f3, %f4, %f3
	fdiv	%f3, %f1, %f3
	setL %g4, l.23167
	fld	%f4, %g4, 0
	st	%g3, %g1, 64
	fst	%f0, %g1, 68
	fst	%f2, %g1, 72
	fmov	%f2, %f3
	fmov	%f0, %f4
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	tan_sub.6499.6594.15621
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 72
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 68
	fdiv	%f0, %f2, %f0
	fmul	%f2, %f0, %f0
	fadd	%f2, %f1, %f2
	setL %g3, l.22817
	fld	%f3, %g3, 0
	fmul	%f0, %f3, %f0
	fdiv	%f0, %f0, %f2
	ld	%g3, %g1, 20
	ld	%g4, %g1, 64
	jne	%g4, %g3, jeq_else.31500
	fneg	%f0, %f0
	jmp	jeq_cont.31501
jeq_else.31500:
jeq_cont.31501:
	fmul	%f0, %f0, %f0
	setL %g3, l.23938
	fld	%f2, %g3, 0
	fmul	%f3, %f2, %f0
	ld	%g3, %g1, 0
	fst	%f3, %g3, 0
	fsub	%f0, %f1, %f0
	fmul	%f0, %f2, %f0
	fst	%f0, %g3, -4
	return
jeq_else.31483:
	mvhi	%g10, 0
	mvlo	%g10, 3
	jne	%g7, %g10, jeq_else.31503
	ld	%g7, %g3, -20
	ld	%g3, %g3, -20
	setL %g10, l.22821
	fld	%f3, %g10, 0
	setL %g10, l.23919
	fld	%f4, %g10, 0
	setL %g10, l.23902
	fld	%f5, %g10, 0
	fld	%f6, %g7, -8
	fld	%f7, %g4, -8
	fsub	%f6, %f7, %f6
	fmul	%f6, %f6, %f6
	fld	%f7, %g3, 0
	fld	%f8, %g4, 0
	fsub	%f7, %f8, %f7
	fmul	%f7, %f7, %f7
	fadd	%f6, %f7, %f6
	st	%g5, %g1, 0
	fst	%f0, %g1, 44
	fst	%f2, %g1, 52
	st	%g9, %g1, 16
	st	%g8, %g1, 20
	st	%g6, %g1, 76
	fst	%f1, %g1, 48
	fst	%f3, %g1, 80
	fst	%f4, %g1, 84
	fst	%f5, %g1, 88
	fmov	%f0, %f6
	fsqrt	%f0, %f0
	fld	%f1, %g1, 88
	fdiv	%f0, %f0, %f1
	fst	%f0, %g1, 92
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	min_caml_floor
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	fld	%f1, %g1, 92
	fsub	%f0, %f1, %f0
	fld	%f1, %g1, 84
	fmul	%f0, %f0, %f1
	setL %g3, l.23155
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	fld	%f1, %g1, 80
	fjlt	%f0, %f1, fjge_else.31504
	fmov	%f2, %f0
	jmp	fjge_cont.31505
fjge_else.31504:
	fneg	%f2, %f0
fjge_cont.31505:
	fld	%f3, %g1, 48
	fst	%f0, %g1, 96
	fjlt	%f3, %f2, fjge_else.31506
	fjlt	%f2, %f1, fjge_else.31508
	fmov	%f0, %f2
	jmp	fjge_cont.31509
fjge_else.31508:
	fadd	%f2, %f2, %f3
	ld	%g29, %g1, 76
	fmov	%f0, %f2
	st	%g31, %g1, 100
	ld	%g28, %g29, 0
	subi	%g1, %g1, 104
	callR	%g28
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
fjge_cont.31509:
	jmp	fjge_cont.31507
fjge_else.31506:
	fsub	%f2, %f2, %f3
	ld	%g29, %g1, 76
	fmov	%f0, %f2
	st	%g31, %g1, 100
	ld	%g28, %g29, 0
	subi	%g1, %g1, 104
	callR	%g28
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
fjge_cont.31507:
	fld	%f1, %g1, 80
	fld	%f2, %g1, 96
	fjlt	%f1, %f2, fjge_else.31510
	ld	%g3, %g1, 20
	jmp	fjge_cont.31511
fjge_else.31510:
	ld	%g3, %g1, 16
fjge_cont.31511:
	fld	%f1, %g1, 52
	fjlt	%f1, %f0, fjge_else.31512
	jmp	fjge_cont.31513
fjge_else.31512:
	ld	%g4, %g1, 20
	jne	%g3, %g4, jeq_else.31514
	ld	%g3, %g1, 16
	jmp	jeq_cont.31515
jeq_else.31514:
	mov	%g3, %g4
jeq_cont.31515:
fjge_cont.31513:
	setL %g4, l.22819
	fld	%f2, %g4, 0
	fjlt	%f1, %f0, fjge_else.31516
	jmp	fjge_cont.31517
fjge_else.31516:
	fld	%f3, %g1, 48
	fsub	%f0, %f3, %f0
fjge_cont.31517:
	fld	%f3, %g1, 44
	fjlt	%f3, %f0, fjge_else.31518
	jmp	fjge_cont.31519
fjge_else.31518:
	fsub	%f0, %f1, %f0
fjge_cont.31519:
	setL %g4, l.22815
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fmul	%f1, %f0, %f0
	setL %g4, l.23159
	fld	%f3, %g4, 0
	fdiv	%f3, %f1, %f3
	setL %g4, l.23163
	fld	%f4, %g4, 0
	fsub	%f3, %f4, %f3
	fdiv	%f3, %f1, %f3
	setL %g4, l.23165
	fld	%f4, %g4, 0
	fsub	%f3, %f4, %f3
	fdiv	%f3, %f1, %f3
	setL %g4, l.23167
	fld	%f4, %g4, 0
	st	%g3, %g1, 100
	fst	%f0, %g1, 104
	fst	%f2, %g1, 108
	fmov	%f2, %f3
	fmov	%f0, %f4
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	tan_sub.6499.6594.6640.15550
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	fld	%f1, %g1, 108
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 104
	fdiv	%f0, %f2, %f0
	fmul	%f2, %f0, %f0
	fadd	%f2, %f1, %f2
	setL %g3, l.22817
	fld	%f3, %g3, 0
	fmul	%f0, %f3, %f0
	fdiv	%f0, %f0, %f2
	ld	%g3, %g1, 20
	ld	%g4, %g1, 100
	jne	%g4, %g3, jeq_else.31520
	fneg	%f0, %f0
	jmp	jeq_cont.31521
jeq_else.31520:
jeq_cont.31521:
	fmul	%f0, %f0, %f0
	setL %g3, l.23938
	fld	%f2, %g3, 0
	fmul	%f3, %f0, %f2
	ld	%g3, %g1, 0
	fst	%f3, %g3, -4
	fsub	%f0, %f1, %f0
	fmul	%f0, %f0, %f2
	fst	%f0, %g3, -8
	return
jeq_else.31503:
	mvhi	%g6, 0
	mvlo	%g6, 4
	jne	%g7, %g6, jeq_else.31523
	ld	%g6, %g3, -16
	ld	%g7, %g3, -20
	ld	%g10, %g3, -16
	ld	%g11, %g3, -20
	ld	%g12, %g3, -16
	ld	%g3, %g3, -20
	setL %g13, l.23872
	fld	%f0, %g13, 0
	fld	%f1, %g6, -8
	st	%g5, %g1, 0
	fst	%f0, %g1, 112
	st	%g9, %g1, 16
	st	%g8, %g1, 20
	st	%g3, %g1, 116
	st	%g12, %g1, 120
	st	%g11, %g1, 124
	st	%g10, %g1, 128
	st	%g4, %g1, 8
	st	%g7, %g1, 132
	fmov	%f0, %f1
	fsqrt	%f0, %f0
	ld	%g3, %g1, 132
	fld	%f1, %g3, -8
	ld	%g3, %g1, 8
	fld	%f2, %g3, -8
	fsub	%f1, %f2, %f1
	fmul	%f0, %f1, %f0
	fmul	%f1, %f0, %f0
	ld	%g4, %g1, 128
	fld	%f2, %g4, 0
	fst	%f0, %g1, 136
	fst	%f1, %g1, 140
	fmov	%f0, %f2
	fsqrt	%f0, %f0
	ld	%g3, %g1, 124
	fld	%f1, %g3, 0
	ld	%g3, %g1, 8
	fld	%f2, %g3, 0
	fsub	%f1, %f2, %f1
	fmul	%f0, %f1, %f0
	fmul	%f1, %f0, %f0
	fld	%f2, %g1, 140
	fadd	%f1, %f1, %f2
	ld	%g4, %g1, 120
	fld	%f2, %g4, -4
	fst	%f0, %g1, 144
	fst	%f1, %g1, 148
	fmov	%f0, %f2
	fsqrt	%f0, %f0
	ld	%g3, %g1, 116
	fld	%f1, %g3, -4
	ld	%g3, %g1, 8
	fld	%f2, %g3, -4
	fsub	%f1, %f2, %f1
	fmul	%f0, %f1, %f0
	setL %g3, l.22821
	fld	%f1, %g3, 0
	fld	%f2, %g1, 148
	fjlt	%f2, %f1, fjge_else.31524
	fmov	%f3, %f2
	jmp	fjge_cont.31525
fjge_else.31524:
	fneg	%f3, %f2
fjge_cont.31525:
	setL %g3, l.23893
	fld	%f4, %g3, 0
	fjlt	%f3, %f4, fjge_else.31526
	ld	%g3, %g1, 20
	jmp	fjge_cont.31527
fjge_else.31526:
	ld	%g3, %g1, 16
fjge_cont.31527:
	ld	%g4, %g1, 20
	fst	%f4, %g1, 152
	fst	%f1, %g1, 156
	jne	%g3, %g4, jeq_else.31528
	fdiv	%f0, %f0, %f2
	fjlt	%f0, %f1, fjge_else.31530
	jmp	fjge_cont.31531
fjge_else.31530:
	fneg	%f0, %f0
fjge_cont.31531:
	setL %g3, l.22819
	fld	%f2, %g3, 0
	fjlt	%f2, %f0, fjge_else.31532
	setL %g3, l.23128
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.31534
	mov	%g3, %g4
	jmp	fjge_cont.31535
fjge_else.31534:
	mvhi	%g3, 65535
	mvlo	%g3, -1
fjge_cont.31535:
	jmp	fjge_cont.31533
fjge_else.31532:
	ld	%g3, %g1, 16
fjge_cont.31533:
	fjlt	%f0, %f1, fjge_else.31536
	fmov	%f3, %f0
	jmp	fjge_cont.31537
fjge_else.31536:
	fneg	%f3, %f0
fjge_cont.31537:
	fjlt	%f2, %f3, fjge_else.31538
	jmp	fjge_cont.31539
fjge_else.31538:
	fdiv	%f0, %f2, %f0
fjge_cont.31539:
	setL %g5, l.23899
	fld	%f3, %g5, 0
	fmul	%f3, %f0, %f0
	setL %g5, l.22815
	fld	%f5, %g5, 0
	setL %g5, l.23902
	fld	%f5, %g5, 0
	setL %g5, l.23904
	fld	%f6, %g5, 0
	fmul	%f6, %f6, %f3
	setL %g5, l.22817
	fld	%f7, %g5, 0
	setL %g5, l.23907
	fld	%f7, %g5, 0
	setL %g5, l.23909
	fld	%f7, %g5, 0
	fdiv	%f6, %f6, %f7
	st	%g3, %g1, 160
	fst	%f0, %g1, 164
	fst	%f2, %g1, 168
	fmov	%f2, %f6
	fmov	%f1, %f3
	fmov	%f0, %f5
	st	%g31, %g1, 172
	subi	%g1, %g1, 176
	call	atan_sub.2692
	addi	%g1, %g1, 176
	ld	%g31, %g1, 172
	fld	%f1, %g1, 168
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 164
	fdiv	%f0, %f1, %f0
	ld	%g3, %g1, 20
	ld	%g4, %g1, 160
	jlt	%g3, %g4, jle_else.31540
	jlt	%g4, %g3, jle_else.31542
	jmp	jle_cont.31543
jle_else.31542:
	setL %g4, l.23913
	fld	%f1, %g4, 0
	setL %g4, l.23915
	fld	%f1, %g4, 0
	fsub	%f0, %f1, %f0
jle_cont.31543:
	jmp	jle_cont.31541
jle_else.31540:
	setL %g4, l.23911
	fld	%f1, %g4, 0
	fsub	%f0, %f1, %f0
jle_cont.31541:
	setL %g4, l.23917
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	setL %g4, l.23919
	fld	%f1, %g4, 0
	fdiv	%f0, %f0, %f1
	jmp	jeq_cont.31529
jeq_else.31528:
	setL %g3, l.23895
	fld	%f0, %g3, 0
jeq_cont.31529:
	fst	%f0, %g1, 172
	st	%g31, %g1, 180
	subi	%g1, %g1, 184
	call	min_caml_floor
	addi	%g1, %g1, 184
	ld	%g31, %g1, 180
	fld	%f1, %g1, 172
	fsub	%f0, %f1, %f0
	setL %g3, l.22815
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	fmul	%f0, %f0, %f0
	fld	%f2, %g1, 144
	fld	%f3, %g1, 156
	fjlt	%f2, %f3, fjge_else.31544
	fmov	%f4, %f2
	jmp	fjge_cont.31545
fjge_else.31544:
	fneg	%f4, %f2
fjge_cont.31545:
	fld	%f5, %g1, 152
	fjlt	%f4, %f5, fjge_else.31546
	ld	%g3, %g1, 20
	jmp	fjge_cont.31547
fjge_else.31546:
	ld	%g3, %g1, 16
fjge_cont.31547:
	ld	%g4, %g1, 20
	fst	%f0, %g1, 176
	fst	%f1, %g1, 180
	jne	%g3, %g4, jeq_else.31548
	fld	%f4, %g1, 136
	fdiv	%f2, %f4, %f2
	fjlt	%f2, %f3, fjge_else.31550
	jmp	fjge_cont.31551
fjge_else.31550:
	fneg	%f2, %f2
fjge_cont.31551:
	setL %g3, l.22819
	fld	%f4, %g3, 0
	fjlt	%f4, %f2, fjge_else.31552
	setL %g3, l.23128
	fld	%f5, %g3, 0
	fjlt	%f2, %f5, fjge_else.31554
	mov	%g3, %g4
	jmp	fjge_cont.31555
fjge_else.31554:
	mvhi	%g3, 65535
	mvlo	%g3, -1
fjge_cont.31555:
	jmp	fjge_cont.31553
fjge_else.31552:
	ld	%g3, %g1, 16
fjge_cont.31553:
	fjlt	%f2, %f3, fjge_else.31556
	fmov	%f5, %f2
	jmp	fjge_cont.31557
fjge_else.31556:
	fneg	%f5, %f2
fjge_cont.31557:
	fjlt	%f4, %f5, fjge_else.31558
	jmp	fjge_cont.31559
fjge_else.31558:
	fdiv	%f2, %f4, %f2
fjge_cont.31559:
	setL %g5, l.23899
	fld	%f5, %g5, 0
	fmul	%f5, %f2, %f2
	setL %g5, l.23902
	fld	%f6, %g5, 0
	setL %g5, l.23904
	fld	%f7, %g5, 0
	fmul	%f7, %f7, %f5
	setL %g5, l.22817
	fld	%f8, %g5, 0
	setL %g5, l.23907
	fld	%f8, %g5, 0
	setL %g5, l.23909
	fld	%f8, %g5, 0
	fdiv	%f7, %f7, %f8
	st	%g3, %g1, 184
	fst	%f2, %g1, 188
	fst	%f4, %g1, 192
	fmov	%f2, %f7
	fmov	%f1, %f5
	fmov	%f0, %f6
	st	%g31, %g1, 196
	subi	%g1, %g1, 200
	call	atan_sub.2692
	addi	%g1, %g1, 200
	ld	%g31, %g1, 196
	fld	%f1, %g1, 192
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 188
	fdiv	%f0, %f1, %f0
	ld	%g3, %g1, 20
	ld	%g4, %g1, 184
	jlt	%g3, %g4, jle_else.31560
	jlt	%g4, %g3, jle_else.31562
	jmp	jle_cont.31563
jle_else.31562:
	setL %g4, l.23913
	fld	%f1, %g4, 0
	setL %g4, l.23915
	fld	%f1, %g4, 0
	fsub	%f0, %f1, %f0
jle_cont.31563:
	jmp	jle_cont.31561
jle_else.31560:
	setL %g4, l.23911
	fld	%f1, %g4, 0
	fsub	%f0, %f1, %f0
jle_cont.31561:
	setL %g4, l.23917
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	setL %g4, l.23919
	fld	%f1, %g4, 0
	fdiv	%f0, %f0, %f1
	jmp	jeq_cont.31549
jeq_else.31548:
	setL %g3, l.23895
	fld	%f0, %g3, 0
jeq_cont.31549:
	fst	%f0, %g1, 196
	st	%g31, %g1, 204
	subi	%g1, %g1, 208
	call	min_caml_floor
	addi	%g1, %g1, 208
	ld	%g31, %g1, 204
	fld	%f1, %g1, 196
	fsub	%f0, %f1, %f0
	fld	%f1, %g1, 180
	fsub	%f0, %f1, %f0
	fmul	%f0, %f0, %f0
	setL %g3, l.23936
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	fld	%f1, %g1, 176
	fsub	%f0, %f0, %f1
	fld	%f1, %g1, 156
	fjlt	%f0, %f1, fjge_else.31564
	ld	%g3, %g1, 20
	jmp	fjge_cont.31565
fjge_else.31564:
	ld	%g3, %g1, 16
fjge_cont.31565:
	ld	%g4, %g1, 20
	jne	%g3, %g4, jeq_else.31566
	jmp	jeq_cont.31567
jeq_else.31566:
	fmov	%f0, %f1
jeq_cont.31567:
	setL %g3, l.23938
	fld	%f1, %g3, 0
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 112
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, -8
	return
jeq_else.31523:
	return
trace_reflections.3097:
	ld	%g5, %g29, -40
	ld	%g6, %g29, -36
	ld	%g7, %g29, -32
	ld	%g8, %g29, -28
	ld	%g9, %g29, -24
	ld	%g10, %g29, -20
	ld	%g11, %g29, -16
	ld	%g12, %g29, -12
	ld	%g13, %g29, -8
	ld	%g14, %g29, -4
	mvhi	%g15, 0
	mvlo	%g15, 0
	jlt	%g3, %g15, jle_else.31570
	slli	%g16, %g3, 2
	st	%g10, %g1, 4
	add	%g10, %g10, %g16
	ld	%g10, %g10, 0
	ld	%g16, %g10, -4
	setL %g17, l.23998
	fld	%f2, %g17, 0
	fst	%f2, %g6, 0
	ld	%g17, %g11, 0
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	fst	%f1, %g1, 8
	st	%g7, %g1, 12
	st	%g9, %g1, 16
	st	%g4, %g1, 20
	fst	%f0, %g1, 24
	st	%g12, %g1, 28
	st	%g16, %g1, 32
	st	%g8, %g1, 36
	st	%g11, %g1, 40
	st	%g10, %g1, 44
	st	%g13, %g1, 48
	st	%g14, %g1, 52
	st	%g15, %g1, 56
	st	%g6, %g1, 60
	mov	%g4, %g17
	mov	%g3, %g15
	mov	%g29, %g5
	mov	%g5, %g16
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 60
	fld	%f0, %g3, 0
	setL %g3, l.23631
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.31571
	ld	%g3, %g1, 56
	jmp	fjge_cont.31572
fjge_else.31571:
	mvhi	%g3, 0
	mvlo	%g3, 1
fjge_cont.31572:
	ld	%g4, %g1, 56
	jne	%g3, %g4, jeq_else.31573
	mov	%g3, %g4
	jmp	jeq_cont.31574
jeq_else.31573:
	setL %g3, l.24006
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.31575
	mov	%g3, %g4
	jmp	fjge_cont.31576
fjge_else.31575:
	mvhi	%g3, 0
	mvlo	%g3, 1
fjge_cont.31576:
jeq_cont.31574:
	jne	%g3, %g4, jeq_else.31577
	jmp	jeq_cont.31578
jeq_else.31577:
	ld	%g3, %g1, 52
	ld	%g3, %g3, 0
	muli	%g3, %g3, 4
	ld	%g5, %g1, 48
	ld	%g5, %g5, 0
	add	%g3, %g3, %g5
	ld	%g5, %g1, 44
	ld	%g6, %g5, 0
	jne	%g3, %g6, jeq_else.31579
	ld	%g3, %g1, 40
	ld	%g3, %g3, 0
	ld	%g29, %g1, 36
	mov	%g28, %g4
	mov	%g4, %g3
	mov	%g3, %g28
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g4, %g1, 56
	jne	%g3, %g4, jeq_else.31581
	ld	%g3, %g1, 32
	ld	%g3, %g3, 0
	ld	%g5, %g1, 28
	fld	%f0, %g5, 0
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	mvhi	%g6, 0
	mvlo	%g6, 1
	fld	%f2, %g5, -4
	fld	%f3, %g3, -4
	fmul	%f2, %f2, %f3
	fadd	%f0, %f0, %f2
	fld	%f2, %g5, -8
	fld	%f4, %g3, -8
	fmul	%f2, %f2, %f4
	fadd	%f0, %f0, %f2
	ld	%g3, %g1, 44
	fld	%f2, %g3, -8
	fld	%f5, %g1, 24
	fmul	%f6, %f2, %f5
	fmul	%f0, %f6, %f0
	ld	%g3, %g1, 20
	fld	%f6, %g3, 0
	fmul	%f1, %f6, %f1
	fld	%f6, %g3, -4
	fmul	%f3, %f6, %f3
	fadd	%f1, %f1, %f3
	fld	%f3, %g3, -8
	fmul	%f3, %f3, %f4
	fadd	%f1, %f1, %f3
	fmul	%f1, %f2, %f1
	setL %g5, l.22821
	fld	%f2, %g5, 0
	fjlt	%f2, %f0, fjge_else.31583
	mov	%g5, %g4
	jmp	fjge_cont.31584
fjge_else.31583:
	mov	%g5, %g6
fjge_cont.31584:
	jne	%g5, %g4, jeq_else.31585
	jmp	jeq_cont.31586
jeq_else.31585:
	ld	%g5, %g1, 16
	fld	%f3, %g5, 0
	ld	%g7, %g1, 12
	fld	%f4, %g7, 0
	fmul	%f4, %f0, %f4
	fadd	%f3, %f3, %f4
	fst	%f3, %g5, 0
	fld	%f3, %g5, -4
	fld	%f4, %g7, -4
	fmul	%f4, %f0, %f4
	fadd	%f3, %f3, %f4
	fst	%f3, %g5, -4
	fld	%f3, %g5, -8
	fld	%f4, %g7, -8
	fmul	%f0, %f0, %f4
	fadd	%f0, %f3, %f0
	fst	%f0, %g5, -8
jeq_cont.31586:
	fjlt	%f2, %f1, fjge_else.31587
	mov	%g5, %g4
	jmp	fjge_cont.31588
fjge_else.31587:
	mov	%g5, %g6
fjge_cont.31588:
	jne	%g5, %g4, jeq_else.31589
	jmp	jeq_cont.31590
jeq_else.31589:
	fmul	%f0, %f1, %f1
	fmul	%f0, %f0, %f0
	fld	%f1, %g1, 8
	fmul	%f0, %f0, %f1
	ld	%g4, %g1, 16
	fld	%f2, %g4, 0
	fadd	%f2, %f2, %f0
	fst	%f2, %g4, 0
	fld	%f2, %g4, -4
	fadd	%f2, %f2, %f0
	fst	%f2, %g4, -4
	fld	%f2, %g4, -8
	fadd	%f0, %f2, %f0
	fst	%f0, %g4, -8
jeq_cont.31590:
	jmp	jeq_cont.31582
jeq_else.31581:
jeq_cont.31582:
	jmp	jeq_cont.31580
jeq_else.31579:
jeq_cont.31580:
jeq_cont.31578:
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	fld	%f0, %g1, 24
	fld	%f1, %g1, 8
	ld	%g4, %g1, 20
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.31570:
	return
trace_ray.3102:
	ld	%g6, %g29, -80
	ld	%g7, %g29, -76
	ld	%g8, %g29, -72
	ld	%g9, %g29, -68
	ld	%g10, %g29, -64
	ld	%g11, %g29, -60
	ld	%g12, %g29, -56
	ld	%g13, %g29, -52
	ld	%g14, %g29, -48
	ld	%g15, %g29, -44
	ld	%g16, %g29, -40
	ld	%g17, %g29, -36
	ld	%g18, %g29, -32
	ld	%g19, %g29, -28
	ld	%g20, %g29, -24
	ld	%g21, %g29, -20
	ld	%g22, %g29, -16
	ld	%g23, %g29, -12
	ld	%g24, %g29, -8
	ld	%g25, %g29, -4
	mvhi	%g26, 0
	mvlo	%g26, 4
	jlt	%g26, %g3, jle_else.31592
	mvhi	%g27, 0
	mvlo	%g27, 0
	setL %g28, l.23998
	fld	%f2, %g28, 0
	fst	%f2, %g9, 0
	ld	%g28, %g16, 0
	st	%g29, %g1, 0
	fst	%f1, %g1, 4
	st	%g26, %g1, 8
	st	%g7, %g1, 12
	st	%g19, %g1, 16
	st	%g14, %g1, 20
	st	%g20, %g1, 24
	st	%g11, %g1, 28
	st	%g13, %g1, 32
	st	%g16, %g1, 36
	st	%g10, %g1, 40
	st	%g6, %g1, 44
	st	%g12, %g1, 48
	st	%g23, %g1, 52
	st	%g22, %g1, 56
	st	%g18, %g1, 60
	st	%g17, %g1, 64
	st	%g24, %g1, 68
	st	%g15, %g1, 72
	fst	%f0, %g1, 76
	st	%g25, %g1, 80
	st	%g4, %g1, 84
	st	%g21, %g1, 88
	st	%g3, %g1, 92
	st	%g27, %g1, 96
	st	%g9, %g1, 100
	st	%g5, %g1, 104
	mov	%g5, %g4
	mov	%g3, %g27
	mov	%g29, %g8
	mov	%g4, %g28
	st	%g31, %g1, 108
	ld	%g28, %g29, 0
	subi	%g1, %g1, 112
	callR	%g28
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	ld	%g3, %g1, 104
	ld	%g4, %g3, -8
	ld	%g5, %g1, 100
	fld	%f0, %g5, 0
	setL %g6, l.23631
	fld	%f1, %g6, 0
	fjlt	%f1, %f0, fjge_else.31593
	ld	%g6, %g1, 96
	jmp	fjge_cont.31594
fjge_else.31593:
	mvhi	%g6, 0
	mvlo	%g6, 1
fjge_cont.31594:
	ld	%g7, %g1, 96
	jne	%g6, %g7, jeq_else.31595
	mov	%g6, %g7
	jmp	jeq_cont.31596
jeq_else.31595:
	setL %g6, l.24006
	fld	%f1, %g6, 0
	fjlt	%f0, %f1, fjge_else.31597
	mov	%g6, %g7
	jmp	fjge_cont.31598
fjge_else.31597:
	mvhi	%g6, 0
	mvlo	%g6, 1
fjge_cont.31598:
jeq_cont.31596:
	jne	%g6, %g7, jeq_else.31599
	mvhi	%g3, 65535
	mvlo	%g3, -1
	ld	%g5, %g1, 92
	slli	%g6, %g5, 2
	st	%g4, %g1, 108
	add	%g4, %g4, %g6
	st	%g3, %g4, 0
	ld	%g4, %g1, 108
	jne	%g5, %g7, jeq_else.31600
	return
jeq_else.31600:
	ld	%g3, %g1, 88
	fld	%f0, %g3, -8
	ld	%g4, %g1, 84
	fld	%f1, %g4, -8
	fmul	%f0, %f1, %f0
	mvhi	%g5, 0
	mvlo	%g5, 1
	fld	%f1, %g3, -4
	fld	%f2, %g4, -4
	fmul	%f1, %f2, %f1
	fld	%f2, %g3, 0
	fld	%f3, %g4, 0
	fmul	%f2, %f3, %f2
	fadd	%f1, %f2, %f1
	fadd	%f0, %f1, %f0
	fneg	%f0, %f0
	setL %g3, l.22821
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.31602
	mov	%g3, %g7
	jmp	fjge_cont.31603
fjge_else.31602:
	mov	%g3, %g5
fjge_cont.31603:
	jne	%g3, %g7, jeq_else.31604
	return
jeq_else.31604:
	ld	%g3, %g1, 80
	fld	%f1, %g3, 0
	fmul	%f2, %f0, %f0
	fmul	%f0, %f2, %f0
	fld	%f2, %g1, 76
	fmul	%f0, %f0, %f2
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 72
	fld	%f1, %g3, 0
	fadd	%f1, %f1, %f0
	fst	%f1, %g3, 0
	fld	%f1, %g3, -4
	fadd	%f1, %f1, %f0
	fst	%f1, %g3, -4
	fld	%f1, %g3, -8
	fadd	%f0, %f1, %f0
	fst	%f0, %g3, -8
	return
jeq_else.31599:
	ld	%g6, %g1, 68
	ld	%g6, %g6, 0
	slli	%g8, %g6, 2
	ld	%g9, %g1, 64
	st	%g9, %g1, 108
	add	%g9, %g9, %g8
	ld	%g8, %g9, 0
	ld	%g9, %g1, 108
	ld	%g9, %g8, -4
	mvhi	%g10, 0
	mvlo	%g10, 1
	st	%g10, %g1, 108
	st	%g4, %g1, 112
	st	%g6, %g1, 116
	st	%g8, %g1, 120
	jne	%g9, %g10, jeq_else.31607
	setL %g9, l.22821
	fld	%f0, %g9, 0
	ld	%g9, %g1, 60
	fst	%f0, %g9, 0
	fst	%f0, %g9, -4
	fst	%f0, %g9, -8
	ld	%g11, %g1, 56
	ld	%g12, %g11, 0
	subi	%g12, %g12, 1
	slli	%g13, %g12, 2
	ld	%g14, %g1, 84
	st	%g14, %g1, 124
	add	%g14, %g14, %g13
	fld	%f1, %g14, 0
	ld	%g14, %g1, 124
	fjeq	%f1, %f0, fjne_else.31609
	mov	%g13, %g7
	jmp	fjne_cont.31610
fjne_else.31609:
	mov	%g13, %g10
fjne_cont.31610:
	jne	%g13, %g7, jeq_else.31611
	fjlt	%f0, %f1, fjge_else.31613
	mov	%g13, %g7
	jmp	fjge_cont.31614
fjge_else.31613:
	mov	%g13, %g10
fjge_cont.31614:
	jne	%g13, %g7, jeq_else.31615
	setL %g13, l.23128
	fld	%f0, %g13, 0
	jmp	jeq_cont.31616
jeq_else.31615:
	setL %g13, l.22819
	fld	%f0, %g13, 0
jeq_cont.31616:
	jmp	jeq_cont.31612
jeq_else.31611:
jeq_cont.31612:
	fneg	%f0, %f0
	slli	%g12, %g12, 2
	st	%g9, %g1, 124
	add	%g9, %g9, %g12
	fst	%f0, %g9, 0
	ld	%g9, %g1, 124
	jmp	jeq_cont.31608
jeq_else.31607:
	mvhi	%g11, 0
	mvlo	%g11, 2
	jne	%g9, %g11, jeq_else.31617
	ld	%g9, %g8, -16
	fld	%f0, %g9, 0
	fneg	%f0, %f0
	ld	%g9, %g1, 60
	fst	%f0, %g9, 0
	ld	%g11, %g8, -16
	fld	%f0, %g11, -4
	fneg	%f0, %f0
	fst	%f0, %g9, -4
	ld	%g11, %g8, -16
	fld	%f0, %g11, -8
	fneg	%f0, %f0
	fst	%f0, %g9, -8
	jmp	jeq_cont.31618
jeq_else.31617:
	ld	%g9, %g8, -20
	fld	%f0, %g9, -8
	ld	%g9, %g1, 52
	fld	%f1, %g9, -8
	fsub	%f0, %f1, %f0
	ld	%g11, %g8, -20
	fld	%f1, %g11, -4
	fld	%f2, %g9, -4
	fsub	%f1, %f2, %f1
	ld	%g11, %g8, -20
	fld	%f2, %g11, 0
	fld	%f3, %g9, 0
	fsub	%f2, %f3, %f2
	ld	%g11, %g8, -16
	fld	%f3, %g11, -8
	fmul	%f3, %f0, %f3
	ld	%g11, %g8, -16
	fld	%f4, %g11, -4
	fmul	%f4, %f1, %f4
	ld	%g11, %g8, -16
	fld	%f5, %g11, 0
	fmul	%f5, %f2, %f5
	ld	%g11, %g8, -12
	jne	%g11, %g7, jeq_else.31619
	ld	%g11, %g1, 60
	fst	%f5, %g11, 0
	fst	%f4, %g11, -4
	fst	%f3, %g11, -8
	jmp	jeq_cont.31620
jeq_else.31619:
	ld	%g11, %g8, -36
	fld	%f6, %g11, -8
	fmul	%f6, %f1, %f6
	ld	%g11, %g8, -36
	fld	%f7, %g11, -4
	fmul	%f7, %f0, %f7
	fadd	%f6, %f6, %f7
	setL %g11, l.22817
	fld	%f7, %g11, 0
	fdiv	%f6, %f6, %f7
	fadd	%f5, %f5, %f6
	ld	%g11, %g1, 60
	fst	%f5, %g11, 0
	ld	%g12, %g8, -36
	fld	%f5, %g12, -8
	fmul	%f5, %f2, %f5
	ld	%g12, %g8, -36
	fld	%f6, %g12, 0
	fmul	%f0, %f0, %f6
	fadd	%f0, %f5, %f0
	fdiv	%f0, %f0, %f7
	fadd	%f0, %f4, %f0
	fst	%f0, %g11, -4
	ld	%g12, %g8, -36
	fld	%f0, %g12, -4
	fmul	%f0, %f2, %f0
	ld	%g12, %g8, -36
	fld	%f2, %g12, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fdiv	%f0, %f0, %f7
	fadd	%f0, %f3, %f0
	fst	%f0, %g11, -8
jeq_cont.31620:
	fld	%f0, %g11, -8
	fmul	%f0, %f0, %f0
	fld	%f1, %g11, -4
	fmul	%f1, %f1, %f1
	fld	%f2, %g11, 0
	fmul	%f3, %f2, %f2
	fadd	%f1, %f3, %f1
	fadd	%f0, %f1, %f0
	fst	%f2, %g1, 124
	fsqrt	%f0, %f0
	setL %g3, l.22821
	fld	%f1, %g3, 0
	fjeq	%f0, %f1, fjne_else.31621
	ld	%g3, %g1, 96
	jmp	fjne_cont.31622
fjne_else.31621:
	ld	%g3, %g1, 108
fjne_cont.31622:
	ld	%g4, %g1, 120
	ld	%g5, %g4, -24
	ld	%g6, %g1, 96
	jne	%g3, %g6, jeq_else.31623
	jne	%g5, %g6, jeq_else.31625
	setL %g3, l.22819
	fld	%f1, %g3, 0
	fdiv	%f0, %f1, %f0
	jmp	jeq_cont.31626
jeq_else.31625:
	setL %g3, l.23128
	fld	%f1, %g3, 0
	fdiv	%f0, %f1, %f0
jeq_cont.31626:
	jmp	jeq_cont.31624
jeq_else.31623:
	setL %g3, l.22819
	fld	%f0, %g3, 0
jeq_cont.31624:
	fld	%f1, %g1, 124
	fmul	%f1, %f1, %f0
	ld	%g3, %g1, 60
	fst	%f1, %g3, 0
	fld	%f1, %g3, -4
	fmul	%f1, %f1, %f0
	fst	%f1, %g3, -4
	fld	%f1, %g3, -8
	fmul	%f0, %f1, %f0
	fst	%f0, %g3, -8
jeq_cont.31618:
jeq_cont.31608:
	ld	%g4, %g1, 52
	fld	%f0, %g4, 0
	ld	%g3, %g1, 48
	fst	%f0, %g3, 0
	fld	%f0, %g4, -4
	fst	%f0, %g3, -4
	mvhi	%g5, 0
	mvlo	%g5, 2
	fld	%f0, %g4, -8
	fst	%f0, %g3, -8
	ld	%g3, %g1, 120
	ld	%g29, %g1, 44
	st	%g5, %g1, 128
	st	%g31, %g1, 132
	ld	%g28, %g29, 0
	subi	%g1, %g1, 136
	callR	%g28
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g3, %g1, 56
	ld	%g3, %g3, 0
	ld	%g4, %g1, 116
	muli	%g4, %g4, 4
	add	%g3, %g4, %g3
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	ld	%g6, %g1, 112
	st	%g6, %g1, 132
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 132
	ld	%g3, %g1, 104
	ld	%g5, %g3, -4
	ld	%g7, %g1, 52
	fld	%f0, %g7, 0
	slli	%g8, %g4, 2
	st	%g5, %g1, 132
	add	%g5, %g5, %g8
	ld	%g5, %g5, 0
	fst	%f0, %g5, 0
	fld	%f0, %g7, -4
	fst	%f0, %g5, -4
	fld	%f0, %g7, -8
	fst	%f0, %g5, -8
	ld	%g5, %g1, 120
	ld	%g8, %g5, -28
	ld	%g9, %g3, -12
	fld	%f0, %g8, 0
	fld	%f1, %g1, 76
	fmul	%f2, %f0, %f1
	setL %g8, l.22815
	fld	%f3, %g8, 0
	fjlt	%f0, %f3, fjge_else.31627
	ld	%g8, %g1, 96
	jmp	fjge_cont.31628
fjge_else.31627:
	ld	%g8, %g1, 108
fjge_cont.31628:
	ld	%g10, %g1, 96
	jne	%g8, %g10, jeq_else.31629
	slli	%g8, %g4, 2
	ld	%g11, %g1, 108
	st	%g9, %g1, 132
	add	%g9, %g9, %g8
	st	%g11, %g9, 0
	ld	%g9, %g1, 132
	ld	%g8, %g3, -16
	slli	%g9, %g4, 2
	st	%g8, %g1, 132
	add	%g8, %g8, %g9
	ld	%g9, %g8, 0
	ld	%g8, %g1, 132
	ld	%g12, %g1, 40
	fld	%f0, %g12, 0
	fst	%f0, %g9, 0
	fld	%f0, %g12, -4
	fst	%f0, %g9, -4
	fld	%f0, %g12, -8
	fst	%f0, %g9, -8
	slli	%g9, %g4, 2
	st	%g8, %g1, 132
	add	%g8, %g8, %g9
	ld	%g8, %g8, 0
	setL %g9, l.22819
	fld	%f0, %g9, 0
	setL %g9, l.24185
	fld	%f0, %g9, 0
	setL %g9, l.24187
	fld	%f0, %g9, 0
	fmul	%f0, %f0, %f2
	fld	%f3, %g8, 0
	fmul	%f3, %f3, %f0
	fst	%f3, %g8, 0
	fld	%f3, %g8, -4
	fmul	%f3, %f3, %f0
	fst	%f3, %g8, -4
	fld	%f3, %g8, -8
	fmul	%f0, %f3, %f0
	fst	%f0, %g8, -8
	ld	%g8, %g3, -28
	slli	%g9, %g4, 2
	st	%g8, %g1, 132
	add	%g8, %g8, %g9
	ld	%g8, %g8, 0
	ld	%g9, %g1, 60
	fld	%f0, %g9, 0
	fst	%f0, %g8, 0
	fld	%f0, %g9, -4
	fst	%f0, %g8, -4
	fld	%f0, %g9, -8
	fst	%f0, %g8, -8
	jmp	jeq_cont.31630
jeq_else.31629:
	slli	%g8, %g4, 2
	st	%g9, %g1, 132
	add	%g9, %g9, %g8
	st	%g10, %g9, 0
	ld	%g9, %g1, 132
jeq_cont.31630:
	ld	%g8, %g1, 84
	fld	%f0, %g8, 0
	ld	%g9, %g1, 60
	fld	%f3, %g9, -8
	fld	%f4, %g8, -8
	fmul	%f3, %f4, %f3
	fld	%f4, %g9, -4
	fld	%f5, %g8, -4
	fmul	%f4, %f5, %f4
	fld	%f5, %g9, 0
	fmul	%f6, %f0, %f5
	fadd	%f4, %f6, %f4
	fadd	%f3, %f4, %f3
	setL %g11, l.24221
	fld	%f4, %g11, 0
	fmul	%f3, %f4, %f3
	fmul	%f4, %f3, %f5
	fadd	%f0, %f0, %f4
	fst	%f0, %g8, 0
	fld	%f0, %g9, -4
	fmul	%f0, %f3, %f0
	fld	%f4, %g8, -4
	fadd	%f0, %f4, %f0
	fst	%f0, %g8, -4
	fld	%f0, %g9, -8
	fmul	%f0, %f3, %f0
	fld	%f3, %g8, -8
	fadd	%f0, %f3, %f0
	fst	%f0, %g8, -8
	ld	%g11, %g1, 36
	ld	%g11, %g11, 0
	ld	%g29, %g1, 32
	fst	%f2, %g1, 132
	mov	%g4, %g11
	mov	%g3, %g10
	st	%g31, %g1, 140
	ld	%g28, %g29, 0
	subi	%g1, %g1, 144
	callR	%g28
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g4, %g1, 120
	ld	%g5, %g4, -28
	fld	%f0, %g5, -4
	fld	%f1, %g1, 76
	fmul	%f0, %f1, %f0
	ld	%g5, %g1, 96
	jne	%g3, %g5, jeq_else.31631
	ld	%g3, %g1, 60
	fld	%f2, %g3, 0
	ld	%g6, %g1, 88
	fld	%f3, %g6, 0
	fmul	%f2, %f2, %f3
	fld	%f4, %g3, -4
	fld	%f5, %g6, -4
	fmul	%f4, %f4, %f5
	fadd	%f2, %f2, %f4
	fld	%f4, %g3, -8
	fld	%f6, %g6, -8
	fmul	%f4, %f4, %f6
	fadd	%f2, %f2, %f4
	fneg	%f2, %f2
	fld	%f4, %g1, 132
	fmul	%f2, %f2, %f4
	ld	%g3, %g1, 84
	fld	%f7, %g3, 0
	fmul	%f3, %f7, %f3
	fld	%f7, %g3, -4
	fmul	%f5, %f7, %f5
	fadd	%f3, %f3, %f5
	fld	%f5, %g3, -8
	fmul	%f5, %f5, %f6
	fadd	%f3, %f3, %f5
	fneg	%f3, %f3
	setL %g6, l.22821
	fld	%f5, %g6, 0
	fjlt	%f5, %f2, fjge_else.31633
	mov	%g6, %g5
	jmp	fjge_cont.31634
fjge_else.31633:
	ld	%g6, %g1, 108
fjge_cont.31634:
	jne	%g6, %g5, jeq_else.31635
	jmp	jeq_cont.31636
jeq_else.31635:
	ld	%g6, %g1, 72
	fld	%f6, %g6, 0
	ld	%g7, %g1, 40
	fld	%f7, %g7, 0
	fmul	%f7, %f2, %f7
	fadd	%f6, %f6, %f7
	fst	%f6, %g6, 0
	fld	%f6, %g6, -4
	fld	%f7, %g7, -4
	fmul	%f7, %f2, %f7
	fadd	%f6, %f6, %f7
	fst	%f6, %g6, -4
	fld	%f6, %g6, -8
	fld	%f7, %g7, -8
	fmul	%f2, %f2, %f7
	fadd	%f2, %f6, %f2
	fst	%f2, %g6, -8
jeq_cont.31636:
	fjlt	%f5, %f3, fjge_else.31637
	mov	%g6, %g5
	jmp	fjge_cont.31638
fjge_else.31637:
	ld	%g6, %g1, 108
fjge_cont.31638:
	jne	%g6, %g5, jeq_else.31639
	jmp	jeq_cont.31640
jeq_else.31639:
	fmul	%f2, %f3, %f3
	fmul	%f2, %f2, %f2
	fmul	%f2, %f2, %f0
	ld	%g6, %g1, 72
	fld	%f3, %g6, 0
	fadd	%f3, %f3, %f2
	fst	%f3, %g6, 0
	fld	%f3, %g6, -4
	fadd	%f3, %f3, %f2
	fst	%f3, %g6, -4
	fld	%f3, %g6, -8
	fadd	%f2, %f3, %f2
	fst	%f2, %g6, -8
jeq_cont.31640:
	jmp	jeq_cont.31632
jeq_else.31631:
jeq_cont.31632:
	ld	%g3, %g1, 52
	fld	%f2, %g3, 0
	ld	%g6, %g1, 28
	fst	%f2, %g6, 0
	fld	%f2, %g3, -4
	fst	%f2, %g6, -4
	fld	%f2, %g3, -8
	fst	%f2, %g6, -8
	ld	%g6, %g1, 24
	ld	%g6, %g6, 0
	subi	%g6, %g6, 1
	ld	%g29, %g1, 20
	fst	%f0, %g1, 136
	mov	%g4, %g6
	st	%g31, %g1, 140
	ld	%g28, %g29, 0
	subi	%g1, %g1, 144
	callR	%g28
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g3, %g1, 16
	ld	%g3, %g3, 0
	subi	%g3, %g3, 1
	fld	%f0, %g1, 132
	fld	%f1, %g1, 136
	ld	%g4, %g1, 84
	ld	%g29, %g1, 12
	st	%g31, %g1, 140
	ld	%g28, %g29, 0
	subi	%g1, %g1, 144
	callR	%g28
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	setL %g3, l.24294
	fld	%f0, %g3, 0
	fld	%f1, %g1, 76
	fjlt	%f0, %f1, fjge_else.31641
	ld	%g3, %g1, 96
	jmp	fjge_cont.31642
fjge_else.31641:
	ld	%g3, %g1, 108
fjge_cont.31642:
	ld	%g4, %g1, 96
	jne	%g3, %g4, jeq_else.31643
	return
jeq_else.31643:
	ld	%g3, %g1, 92
	ld	%g4, %g1, 8
	jlt	%g3, %g4, jle_else.31645
	jmp	jle_cont.31646
jle_else.31645:
	addi	%g4, %g3, 1
	mvhi	%g5, 65535
	mvlo	%g5, -1
	slli	%g4, %g4, 2
	ld	%g6, %g1, 112
	st	%g6, %g1, 140
	add	%g6, %g6, %g4
	st	%g5, %g6, 0
	ld	%g6, %g1, 140
jle_cont.31646:
	ld	%g4, %g1, 120
	ld	%g5, %g4, -8
	ld	%g6, %g1, 128
	jne	%g5, %g6, jeq_else.31647
	ld	%g4, %g4, -28
	fld	%f0, %g4, 0
	setL %g4, l.22819
	fld	%f2, %g4, 0
	fsub	%f0, %f2, %f0
	fmul	%f0, %f1, %f0
	addi	%g3, %g3, 1
	ld	%g4, %g1, 100
	fld	%f1, %g4, 0
	fld	%f2, %g1, 4
	fadd	%f1, %f2, %f1
	ld	%g4, %g1, 84
	ld	%g5, %g1, 104
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jeq_else.31647:
	return
jle_else.31592:
	return
iter_trace_diffuse_rays.3111:
	ld	%g7, %g29, -52
	ld	%g8, %g29, -48
	ld	%g9, %g29, -44
	ld	%g10, %g29, -40
	ld	%g11, %g29, -36
	ld	%g12, %g29, -32
	ld	%g13, %g29, -28
	ld	%g14, %g29, -24
	ld	%g15, %g29, -20
	ld	%g16, %g29, -16
	ld	%g17, %g29, -12
	ld	%g18, %g29, -8
	ld	%g19, %g29, -4
	mvhi	%g20, 0
	mvlo	%g20, 0
	jlt	%g6, %g20, jle_else.31650
	slli	%g21, %g6, 2
	st	%g3, %g1, 4
	add	%g3, %g3, %g21
	ld	%g21, %g3, 0
	ld	%g3, %g1, 4
	ld	%g21, %g21, 0
	mvhi	%g22, 0
	mvlo	%g22, 2
	fld	%f0, %g4, -8
	fld	%f1, %g21, -8
	fmul	%f0, %f1, %f0
	mvhi	%g23, 0
	mvlo	%g23, 1
	fld	%f1, %g4, -4
	fld	%f2, %g21, -4
	fmul	%f1, %f2, %f1
	fld	%f2, %g4, 0
	fld	%f3, %g21, 0
	fmul	%f2, %f3, %f2
	fadd	%f1, %f2, %f1
	fadd	%f0, %f1, %f0
	setL %g21, l.22821
	fld	%f1, %g21, 0
	fjlt	%f0, %f1, fjge_else.31651
	mov	%g21, %g20
	jmp	fjge_cont.31652
fjge_else.31651:
	mov	%g21, %g23
fjge_cont.31652:
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g3, %g1, 8
	st	%g29, %g1, 12
	st	%g6, %g1, 16
	jne	%g21, %g20, jeq_else.31653
	slli	%g21, %g6, 2
	st	%g3, %g1, 20
	add	%g3, %g3, %g21
	ld	%g21, %g3, 0
	ld	%g3, %g1, 20
	setL %g24, l.24463
	fld	%f2, %g24, 0
	fdiv	%f0, %f0, %f2
	setL %g24, l.23998
	fld	%f2, %g24, 0
	fst	%f2, %g9, 0
	ld	%g24, %g12, 0
	st	%g10, %g1, 20
	st	%g19, %g1, 24
	fst	%f0, %g1, 28
	st	%g15, %g1, 32
	st	%g11, %g1, 36
	st	%g12, %g1, 40
	st	%g7, %g1, 44
	st	%g17, %g1, 48
	st	%g22, %g1, 52
	st	%g16, %g1, 56
	st	%g14, %g1, 60
	fst	%f1, %g1, 64
	st	%g21, %g1, 68
	st	%g13, %g1, 72
	st	%g18, %g1, 76
	st	%g23, %g1, 80
	st	%g20, %g1, 84
	st	%g9, %g1, 88
	mov	%g5, %g21
	mov	%g4, %g24
	mov	%g3, %g20
	mov	%g29, %g8
	st	%g31, %g1, 92
	ld	%g28, %g29, 0
	subi	%g1, %g1, 96
	callR	%g28
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	ld	%g3, %g1, 88
	fld	%f0, %g3, 0
	setL %g3, l.23631
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.31655
	ld	%g3, %g1, 84
	jmp	fjge_cont.31656
fjge_else.31655:
	ld	%g3, %g1, 80
fjge_cont.31656:
	ld	%g4, %g1, 84
	jne	%g3, %g4, jeq_else.31657
	mov	%g3, %g4
	jmp	jeq_cont.31658
jeq_else.31657:
	setL %g3, l.24006
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.31659
	mov	%g3, %g4
	jmp	fjge_cont.31660
fjge_else.31659:
	ld	%g3, %g1, 80
fjge_cont.31660:
jeq_cont.31658:
	jne	%g3, %g4, jeq_else.31661
	jmp	jeq_cont.31662
jeq_else.31661:
	ld	%g3, %g1, 76
	ld	%g3, %g3, 0
	slli	%g3, %g3, 2
	ld	%g5, %g1, 72
	st	%g5, %g1, 92
	add	%g5, %g5, %g3
	ld	%g3, %g5, 0
	ld	%g5, %g1, 92
	ld	%g5, %g1, 68
	ld	%g5, %g5, 0
	ld	%g6, %g3, -4
	ld	%g7, %g1, 80
	st	%g3, %g1, 92
	jne	%g6, %g7, jeq_else.31663
	ld	%g6, %g1, 60
	fld	%f0, %g1, 64
	fst	%f0, %g6, 0
	fst	%f0, %g6, -4
	fst	%f0, %g6, -8
	ld	%g8, %g1, 56
	ld	%g8, %g8, 0
	subi	%g8, %g8, 1
	slli	%g9, %g8, 2
	st	%g5, %g1, 100
	add	%g5, %g5, %g9
	fld	%f1, %g5, 0
	ld	%g5, %g1, 100
	fjeq	%f1, %f0, fjne_else.31665
	mov	%g5, %g4
	jmp	fjne_cont.31666
fjne_else.31665:
	mov	%g5, %g7
fjne_cont.31666:
	jne	%g5, %g4, jeq_else.31667
	fjlt	%f0, %f1, fjge_else.31669
	mov	%g5, %g4
	jmp	fjge_cont.31670
fjge_else.31669:
	mov	%g5, %g7
fjge_cont.31670:
	jne	%g5, %g4, jeq_else.31671
	setL %g5, l.23128
	fld	%f1, %g5, 0
	jmp	jeq_cont.31672
jeq_else.31671:
	setL %g5, l.22819
	fld	%f1, %g5, 0
jeq_cont.31672:
	jmp	jeq_cont.31668
jeq_else.31667:
	fmov	%f1, %f0
jeq_cont.31668:
	fneg	%f1, %f1
	slli	%g5, %g8, 2
	st	%g6, %g1, 100
	add	%g6, %g6, %g5
	fst	%f1, %g6, 0
	ld	%g6, %g1, 100
	jmp	jeq_cont.31664
jeq_else.31663:
	ld	%g5, %g1, 52
	jne	%g6, %g5, jeq_else.31673
	ld	%g5, %g3, -16
	fld	%f0, %g5, 0
	fneg	%f0, %f0
	ld	%g5, %g1, 60
	fst	%f0, %g5, 0
	ld	%g6, %g3, -16
	fld	%f0, %g6, -4
	fneg	%f0, %f0
	fst	%f0, %g5, -4
	ld	%g6, %g3, -16
	fld	%f0, %g6, -8
	fneg	%f0, %f0
	fst	%f0, %g5, -8
	jmp	jeq_cont.31674
jeq_else.31673:
	ld	%g5, %g3, -20
	fld	%f0, %g5, -8
	ld	%g5, %g1, 48
	fld	%f1, %g5, -8
	fsub	%f0, %f1, %f0
	ld	%g6, %g3, -20
	fld	%f1, %g6, -4
	fld	%f2, %g5, -4
	fsub	%f1, %f2, %f1
	ld	%g6, %g3, -20
	fld	%f2, %g6, 0
	fld	%f3, %g5, 0
	fsub	%f2, %f3, %f2
	ld	%g6, %g3, -16
	fld	%f3, %g6, -8
	fmul	%f3, %f0, %f3
	ld	%g6, %g3, -16
	fld	%f4, %g6, -4
	fmul	%f4, %f1, %f4
	ld	%g6, %g3, -16
	fld	%f5, %g6, 0
	fmul	%f5, %f2, %f5
	ld	%g6, %g3, -12
	jne	%g6, %g4, jeq_else.31675
	ld	%g6, %g1, 60
	fst	%f5, %g6, 0
	fst	%f4, %g6, -4
	fst	%f3, %g6, -8
	jmp	jeq_cont.31676
jeq_else.31675:
	ld	%g6, %g3, -36
	fld	%f6, %g6, -8
	fmul	%f6, %f1, %f6
	ld	%g6, %g3, -36
	fld	%f7, %g6, -4
	fmul	%f7, %f0, %f7
	fadd	%f6, %f6, %f7
	setL %g6, l.22817
	fld	%f7, %g6, 0
	fdiv	%f6, %f6, %f7
	fadd	%f5, %f5, %f6
	ld	%g6, %g1, 60
	fst	%f5, %g6, 0
	ld	%g8, %g3, -36
	fld	%f5, %g8, -8
	fmul	%f5, %f2, %f5
	ld	%g8, %g3, -36
	fld	%f6, %g8, 0
	fmul	%f0, %f0, %f6
	fadd	%f0, %f5, %f0
	fdiv	%f0, %f0, %f7
	fadd	%f0, %f4, %f0
	fst	%f0, %g6, -4
	ld	%g8, %g3, -36
	fld	%f0, %g8, -4
	fmul	%f0, %f2, %f0
	ld	%g8, %g3, -36
	fld	%f2, %g8, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fdiv	%f0, %f0, %f7
	fadd	%f0, %f3, %f0
	fst	%f0, %g6, -8
jeq_cont.31676:
	fld	%f0, %g6, -8
	fmul	%f0, %f0, %f0
	fld	%f1, %g6, -4
	fmul	%f1, %f1, %f1
	fld	%f2, %g6, 0
	fmul	%f3, %f2, %f2
	fadd	%f1, %f3, %f1
	fadd	%f0, %f1, %f0
	fst	%f2, %g1, 96
	fsqrt	%f0, %f0
	fld	%f1, %g1, 64
	fjeq	%f0, %f1, fjne_else.31677
	ld	%g3, %g1, 84
	jmp	fjne_cont.31678
fjne_else.31677:
	ld	%g3, %g1, 80
fjne_cont.31678:
	ld	%g4, %g1, 92
	ld	%g5, %g4, -24
	ld	%g6, %g1, 84
	jne	%g3, %g6, jeq_else.31679
	jne	%g5, %g6, jeq_else.31681
	setL %g3, l.22819
	fld	%f2, %g3, 0
	fdiv	%f0, %f2, %f0
	jmp	jeq_cont.31682
jeq_else.31681:
	setL %g3, l.23128
	fld	%f2, %g3, 0
	fdiv	%f0, %f2, %f0
jeq_cont.31682:
	jmp	jeq_cont.31680
jeq_else.31679:
	setL %g3, l.22819
	fld	%f0, %g3, 0
jeq_cont.31680:
	fld	%f2, %g1, 96
	fmul	%f2, %f2, %f0
	ld	%g3, %g1, 60
	fst	%f2, %g3, 0
	fld	%f2, %g3, -4
	fmul	%f2, %f2, %f0
	fst	%f2, %g3, -4
	fld	%f2, %g3, -8
	fmul	%f0, %f2, %f0
	fst	%f0, %g3, -8
jeq_cont.31674:
jeq_cont.31664:
	ld	%g3, %g1, 92
	ld	%g4, %g1, 48
	ld	%g29, %g1, 44
	st	%g31, %g1, 100
	ld	%g28, %g29, 0
	subi	%g1, %g1, 104
	callR	%g28
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	ld	%g3, %g1, 40
	ld	%g4, %g3, 0
	ld	%g3, %g1, 84
	ld	%g29, %g1, 36
	st	%g31, %g1, 100
	ld	%g28, %g29, 0
	subi	%g1, %g1, 104
	callR	%g28
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	ld	%g4, %g1, 84
	jne	%g3, %g4, jeq_else.31683
	ld	%g3, %g1, 60
	fld	%f0, %g3, 0
	ld	%g5, %g1, 32
	fld	%f1, %g5, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g3, -4
	fld	%f2, %g5, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, -8
	fld	%f2, %g5, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fneg	%f0, %f0
	fld	%f1, %g1, 64
	fjlt	%f1, %f0, fjge_else.31685
	mov	%g3, %g4
	jmp	fjge_cont.31686
fjge_else.31685:
	ld	%g3, %g1, 80
fjge_cont.31686:
	jne	%g3, %g4, jeq_else.31687
	fmov	%f0, %f1
	jmp	jeq_cont.31688
jeq_else.31687:
jeq_cont.31688:
	fld	%f1, %g1, 28
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 92
	ld	%g3, %g3, -28
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 24
	fld	%f1, %g3, 0
	ld	%g4, %g1, 20
	fld	%f2, %g4, 0
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g3, 0
	fld	%f1, %g3, -4
	fld	%f2, %g4, -4
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g3, -4
	fld	%f1, %g3, -8
	fld	%f2, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fst	%f0, %g3, -8
	jmp	jeq_cont.31684
jeq_else.31683:
jeq_cont.31684:
jeq_cont.31662:
	jmp	jeq_cont.31654
jeq_else.31653:
	addi	%g21, %g6, 1
	slli	%g21, %g21, 2
	st	%g3, %g1, 100
	add	%g3, %g3, %g21
	ld	%g21, %g3, 0
	ld	%g3, %g1, 100
	setL %g24, l.24344
	fld	%f2, %g24, 0
	fdiv	%f0, %f0, %f2
	setL %g24, l.23998
	fld	%f2, %g24, 0
	fst	%f2, %g9, 0
	ld	%g24, %g12, 0
	st	%g10, %g1, 20
	st	%g19, %g1, 24
	fst	%f0, %g1, 100
	st	%g15, %g1, 32
	st	%g11, %g1, 36
	st	%g12, %g1, 40
	st	%g7, %g1, 44
	st	%g17, %g1, 48
	st	%g22, %g1, 52
	st	%g16, %g1, 56
	st	%g14, %g1, 60
	fst	%f1, %g1, 64
	st	%g21, %g1, 104
	st	%g13, %g1, 72
	st	%g18, %g1, 76
	st	%g23, %g1, 80
	st	%g20, %g1, 84
	st	%g9, %g1, 88
	mov	%g5, %g21
	mov	%g4, %g24
	mov	%g3, %g20
	mov	%g29, %g8
	st	%g31, %g1, 108
	ld	%g28, %g29, 0
	subi	%g1, %g1, 112
	callR	%g28
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	ld	%g3, %g1, 88
	fld	%f0, %g3, 0
	setL %g3, l.23631
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.31689
	ld	%g3, %g1, 84
	jmp	fjge_cont.31690
fjge_else.31689:
	ld	%g3, %g1, 80
fjge_cont.31690:
	ld	%g4, %g1, 84
	jne	%g3, %g4, jeq_else.31691
	mov	%g3, %g4
	jmp	jeq_cont.31692
jeq_else.31691:
	setL %g3, l.24006
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.31693
	mov	%g3, %g4
	jmp	fjge_cont.31694
fjge_else.31693:
	ld	%g3, %g1, 80
fjge_cont.31694:
jeq_cont.31692:
	jne	%g3, %g4, jeq_else.31695
	jmp	jeq_cont.31696
jeq_else.31695:
	ld	%g3, %g1, 76
	ld	%g3, %g3, 0
	slli	%g3, %g3, 2
	ld	%g5, %g1, 72
	st	%g5, %g1, 108
	add	%g5, %g5, %g3
	ld	%g3, %g5, 0
	ld	%g5, %g1, 108
	ld	%g5, %g1, 104
	ld	%g5, %g5, 0
	ld	%g6, %g3, -4
	ld	%g7, %g1, 80
	st	%g3, %g1, 108
	jne	%g6, %g7, jeq_else.31697
	ld	%g6, %g1, 60
	fld	%f0, %g1, 64
	fst	%f0, %g6, 0
	fst	%f0, %g6, -4
	fst	%f0, %g6, -8
	ld	%g8, %g1, 56
	ld	%g8, %g8, 0
	subi	%g8, %g8, 1
	slli	%g9, %g8, 2
	st	%g5, %g1, 116
	add	%g5, %g5, %g9
	fld	%f1, %g5, 0
	ld	%g5, %g1, 116
	fjeq	%f1, %f0, fjne_else.31699
	mov	%g5, %g4
	jmp	fjne_cont.31700
fjne_else.31699:
	mov	%g5, %g7
fjne_cont.31700:
	jne	%g5, %g4, jeq_else.31701
	fjlt	%f0, %f1, fjge_else.31703
	mov	%g5, %g4
	jmp	fjge_cont.31704
fjge_else.31703:
	mov	%g5, %g7
fjge_cont.31704:
	jne	%g5, %g4, jeq_else.31705
	setL %g5, l.23128
	fld	%f1, %g5, 0
	jmp	jeq_cont.31706
jeq_else.31705:
	setL %g5, l.22819
	fld	%f1, %g5, 0
jeq_cont.31706:
	jmp	jeq_cont.31702
jeq_else.31701:
	fmov	%f1, %f0
jeq_cont.31702:
	fneg	%f1, %f1
	slli	%g5, %g8, 2
	st	%g6, %g1, 116
	add	%g6, %g6, %g5
	fst	%f1, %g6, 0
	ld	%g6, %g1, 116
	jmp	jeq_cont.31698
jeq_else.31697:
	ld	%g5, %g1, 52
	jne	%g6, %g5, jeq_else.31707
	ld	%g5, %g3, -16
	fld	%f0, %g5, 0
	fneg	%f0, %f0
	ld	%g5, %g1, 60
	fst	%f0, %g5, 0
	ld	%g6, %g3, -16
	fld	%f0, %g6, -4
	fneg	%f0, %f0
	fst	%f0, %g5, -4
	ld	%g6, %g3, -16
	fld	%f0, %g6, -8
	fneg	%f0, %f0
	fst	%f0, %g5, -8
	jmp	jeq_cont.31708
jeq_else.31707:
	ld	%g5, %g3, -20
	fld	%f0, %g5, -8
	ld	%g5, %g1, 48
	fld	%f1, %g5, -8
	fsub	%f0, %f1, %f0
	ld	%g6, %g3, -20
	fld	%f1, %g6, -4
	fld	%f2, %g5, -4
	fsub	%f1, %f2, %f1
	ld	%g6, %g3, -20
	fld	%f2, %g6, 0
	fld	%f3, %g5, 0
	fsub	%f2, %f3, %f2
	ld	%g6, %g3, -16
	fld	%f3, %g6, -8
	fmul	%f3, %f0, %f3
	ld	%g6, %g3, -16
	fld	%f4, %g6, -4
	fmul	%f4, %f1, %f4
	ld	%g6, %g3, -16
	fld	%f5, %g6, 0
	fmul	%f5, %f2, %f5
	ld	%g6, %g3, -12
	jne	%g6, %g4, jeq_else.31709
	ld	%g6, %g1, 60
	fst	%f5, %g6, 0
	fst	%f4, %g6, -4
	fst	%f3, %g6, -8
	jmp	jeq_cont.31710
jeq_else.31709:
	ld	%g6, %g3, -36
	fld	%f6, %g6, -8
	fmul	%f6, %f1, %f6
	ld	%g6, %g3, -36
	fld	%f7, %g6, -4
	fmul	%f7, %f0, %f7
	fadd	%f6, %f6, %f7
	setL %g6, l.22817
	fld	%f7, %g6, 0
	fdiv	%f6, %f6, %f7
	fadd	%f5, %f5, %f6
	ld	%g6, %g1, 60
	fst	%f5, %g6, 0
	ld	%g8, %g3, -36
	fld	%f5, %g8, -8
	fmul	%f5, %f2, %f5
	ld	%g8, %g3, -36
	fld	%f6, %g8, 0
	fmul	%f0, %f0, %f6
	fadd	%f0, %f5, %f0
	fdiv	%f0, %f0, %f7
	fadd	%f0, %f4, %f0
	fst	%f0, %g6, -4
	ld	%g8, %g3, -36
	fld	%f0, %g8, -4
	fmul	%f0, %f2, %f0
	ld	%g8, %g3, -36
	fld	%f2, %g8, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fdiv	%f0, %f0, %f7
	fadd	%f0, %f3, %f0
	fst	%f0, %g6, -8
jeq_cont.31710:
	fld	%f0, %g6, -8
	fmul	%f0, %f0, %f0
	fld	%f1, %g6, -4
	fmul	%f1, %f1, %f1
	fld	%f2, %g6, 0
	fmul	%f3, %f2, %f2
	fadd	%f1, %f3, %f1
	fadd	%f0, %f1, %f0
	fst	%f2, %g1, 112
	fsqrt	%f0, %f0
	fld	%f1, %g1, 64
	fjeq	%f0, %f1, fjne_else.31711
	ld	%g3, %g1, 84
	jmp	fjne_cont.31712
fjne_else.31711:
	ld	%g3, %g1, 80
fjne_cont.31712:
	ld	%g4, %g1, 108
	ld	%g5, %g4, -24
	ld	%g6, %g1, 84
	jne	%g3, %g6, jeq_else.31713
	jne	%g5, %g6, jeq_else.31715
	setL %g3, l.22819
	fld	%f2, %g3, 0
	fdiv	%f0, %f2, %f0
	jmp	jeq_cont.31716
jeq_else.31715:
	setL %g3, l.23128
	fld	%f2, %g3, 0
	fdiv	%f0, %f2, %f0
jeq_cont.31716:
	jmp	jeq_cont.31714
jeq_else.31713:
	setL %g3, l.22819
	fld	%f0, %g3, 0
jeq_cont.31714:
	fld	%f2, %g1, 112
	fmul	%f2, %f2, %f0
	ld	%g3, %g1, 60
	fst	%f2, %g3, 0
	fld	%f2, %g3, -4
	fmul	%f2, %f2, %f0
	fst	%f2, %g3, -4
	fld	%f2, %g3, -8
	fmul	%f0, %f2, %f0
	fst	%f0, %g3, -8
jeq_cont.31708:
jeq_cont.31698:
	ld	%g3, %g1, 108
	ld	%g4, %g1, 48
	ld	%g29, %g1, 44
	st	%g31, %g1, 116
	ld	%g28, %g29, 0
	subi	%g1, %g1, 120
	callR	%g28
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	ld	%g3, %g1, 40
	ld	%g4, %g3, 0
	ld	%g3, %g1, 84
	ld	%g29, %g1, 36
	st	%g31, %g1, 116
	ld	%g28, %g29, 0
	subi	%g1, %g1, 120
	callR	%g28
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	ld	%g4, %g1, 84
	jne	%g3, %g4, jeq_else.31717
	ld	%g3, %g1, 60
	fld	%f0, %g3, 0
	ld	%g5, %g1, 32
	fld	%f1, %g5, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g3, -4
	fld	%f2, %g5, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, -8
	fld	%f2, %g5, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fneg	%f0, %f0
	fld	%f1, %g1, 64
	fjlt	%f1, %f0, fjge_else.31719
	mov	%g3, %g4
	jmp	fjge_cont.31720
fjge_else.31719:
	ld	%g3, %g1, 80
fjge_cont.31720:
	jne	%g3, %g4, jeq_else.31721
	fmov	%f0, %f1
	jmp	jeq_cont.31722
jeq_else.31721:
jeq_cont.31722:
	fld	%f1, %g1, 100
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 108
	ld	%g3, %g3, -28
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 24
	fld	%f1, %g3, 0
	ld	%g4, %g1, 20
	fld	%f2, %g4, 0
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g3, 0
	fld	%f1, %g3, -4
	fld	%f2, %g4, -4
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g3, -4
	fld	%f1, %g3, -8
	fld	%f2, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fst	%f0, %g3, -8
	jmp	jeq_cont.31718
jeq_else.31717:
jeq_cont.31718:
jeq_cont.31696:
jeq_cont.31654:
	ld	%g3, %g1, 16
	subi	%g6, %g3, 2
	ld	%g3, %g1, 8
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 12
	ld	%g28, %g29, 0
	b	%g28
jle_else.31650:
	return
do_without_neighbors.3133:
	ld	%g5, %g29, -28
	ld	%g6, %g29, -24
	ld	%g7, %g29, -20
	ld	%g8, %g29, -16
	ld	%g9, %g29, -12
	ld	%g10, %g29, -8
	ld	%g11, %g29, -4
	mvhi	%g12, 0
	mvlo	%g12, 4
	jlt	%g12, %g4, jle_else.31724
	ld	%g13, %g3, -8
	slli	%g14, %g4, 2
	st	%g13, %g1, 4
	add	%g13, %g13, %g14
	ld	%g13, %g13, 0
	mvhi	%g14, 0
	mvlo	%g14, 0
	jlt	%g13, %g14, jle_else.31725
	ld	%g13, %g3, -12
	slli	%g15, %g4, 2
	st	%g13, %g1, 4
	add	%g13, %g13, %g15
	ld	%g13, %g13, 0
	st	%g3, %g1, 0
	st	%g29, %g1, 4
	st	%g4, %g1, 8
	jne	%g13, %g14, jeq_else.31726
	jmp	jeq_cont.31727
jeq_else.31726:
	ld	%g13, %g3, -20
	ld	%g15, %g3, -28
	ld	%g16, %g3, -4
	ld	%g17, %g3, -16
	slli	%g18, %g4, 2
	st	%g13, %g1, 12
	add	%g13, %g13, %g18
	ld	%g13, %g13, 0
	fld	%f0, %g13, 0
	fst	%f0, %g11, 0
	mvhi	%g18, 0
	mvlo	%g18, 1
	fld	%f0, %g13, -4
	fst	%f0, %g11, -4
	mvhi	%g19, 0
	mvlo	%g19, 2
	fld	%f0, %g13, -8
	fst	%f0, %g11, -8
	ld	%g13, %g3, -24
	ld	%g13, %g13, 0
	slli	%g20, %g4, 2
	st	%g15, %g1, 12
	add	%g15, %g15, %g20
	ld	%g15, %g15, 0
	slli	%g20, %g4, 2
	st	%g16, %g1, 12
	add	%g16, %g16, %g20
	ld	%g16, %g16, 0
	st	%g11, %g1, 12
	st	%g7, %g1, 16
	st	%g17, %g1, 20
	st	%g12, %g1, 24
	st	%g19, %g1, 28
	st	%g15, %g1, 32
	st	%g9, %g1, 36
	st	%g6, %g1, 40
	st	%g8, %g1, 44
	st	%g5, %g1, 48
	st	%g16, %g1, 52
	st	%g10, %g1, 56
	st	%g18, %g1, 60
	st	%g13, %g1, 64
	jne	%g13, %g14, jeq_else.31728
	jmp	jeq_cont.31729
jeq_else.31728:
	ld	%g14, %g10, 0
	fld	%f0, %g16, 0
	fst	%f0, %g5, 0
	fld	%f0, %g16, -4
	fst	%f0, %g5, -4
	fld	%f0, %g16, -8
	fst	%f0, %g5, -8
	ld	%g20, %g8, 0
	subi	%g20, %g20, 1
	st	%g14, %g1, 68
	mov	%g4, %g20
	mov	%g3, %g16
	mov	%g29, %g6
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g6, 0
	mvlo	%g6, 118
	ld	%g3, %g1, 68
	ld	%g4, %g1, 32
	ld	%g5, %g1, 52
	ld	%g29, %g1, 36
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
jeq_cont.31729:
	ld	%g3, %g1, 60
	ld	%g4, %g1, 64
	jne	%g4, %g3, jeq_else.31730
	jmp	jeq_cont.31731
jeq_else.31730:
	ld	%g3, %g1, 56
	ld	%g5, %g3, -4
	ld	%g6, %g1, 52
	fld	%f0, %g6, 0
	ld	%g7, %g1, 48
	fst	%f0, %g7, 0
	fld	%f0, %g6, -4
	fst	%f0, %g7, -4
	fld	%f0, %g6, -8
	fst	%f0, %g7, -8
	ld	%g8, %g1, 44
	ld	%g9, %g8, 0
	subi	%g9, %g9, 1
	ld	%g29, %g1, 40
	st	%g5, %g1, 72
	mov	%g4, %g9
	mov	%g3, %g6
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g6, 0
	mvlo	%g6, 118
	ld	%g3, %g1, 72
	ld	%g4, %g1, 32
	ld	%g5, %g1, 52
	ld	%g29, %g1, 36
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
jeq_cont.31731:
	ld	%g3, %g1, 28
	ld	%g4, %g1, 64
	jne	%g4, %g3, jeq_else.31732
	jmp	jeq_cont.31733
jeq_else.31732:
	ld	%g3, %g1, 56
	ld	%g5, %g3, -8
	ld	%g6, %g1, 52
	fld	%f0, %g6, 0
	ld	%g7, %g1, 48
	fst	%f0, %g7, 0
	fld	%f0, %g6, -4
	fst	%f0, %g7, -4
	fld	%f0, %g6, -8
	fst	%f0, %g7, -8
	ld	%g8, %g1, 44
	ld	%g9, %g8, 0
	subi	%g9, %g9, 1
	ld	%g29, %g1, 40
	st	%g5, %g1, 76
	mov	%g4, %g9
	mov	%g3, %g6
	st	%g31, %g1, 84
	ld	%g28, %g29, 0
	subi	%g1, %g1, 88
	callR	%g28
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g6, 0
	mvlo	%g6, 118
	ld	%g3, %g1, 76
	ld	%g4, %g1, 32
	ld	%g5, %g1, 52
	ld	%g29, %g1, 36
	st	%g31, %g1, 84
	ld	%g28, %g29, 0
	subi	%g1, %g1, 88
	callR	%g28
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
jeq_cont.31733:
	mvhi	%g3, 0
	mvlo	%g3, 3
	ld	%g4, %g1, 64
	jne	%g4, %g3, jeq_else.31734
	jmp	jeq_cont.31735
jeq_else.31734:
	ld	%g3, %g1, 56
	ld	%g5, %g3, -12
	ld	%g6, %g1, 52
	fld	%f0, %g6, 0
	ld	%g7, %g1, 48
	fst	%f0, %g7, 0
	fld	%f0, %g6, -4
	fst	%f0, %g7, -4
	fld	%f0, %g6, -8
	fst	%f0, %g7, -8
	ld	%g8, %g1, 44
	ld	%g9, %g8, 0
	subi	%g9, %g9, 1
	ld	%g29, %g1, 40
	st	%g5, %g1, 80
	mov	%g4, %g9
	mov	%g3, %g6
	st	%g31, %g1, 84
	ld	%g28, %g29, 0
	subi	%g1, %g1, 88
	callR	%g28
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g6, 0
	mvlo	%g6, 118
	ld	%g3, %g1, 80
	ld	%g4, %g1, 32
	ld	%g5, %g1, 52
	ld	%g29, %g1, 36
	st	%g31, %g1, 84
	ld	%g28, %g29, 0
	subi	%g1, %g1, 88
	callR	%g28
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
jeq_cont.31735:
	ld	%g3, %g1, 24
	ld	%g4, %g1, 64
	jne	%g4, %g3, jeq_else.31736
	jmp	jeq_cont.31737
jeq_else.31736:
	ld	%g3, %g1, 56
	ld	%g3, %g3, -16
	ld	%g4, %g1, 52
	fld	%f0, %g4, 0
	ld	%g5, %g1, 48
	fst	%f0, %g5, 0
	fld	%f0, %g4, -4
	fst	%f0, %g5, -4
	fld	%f0, %g4, -8
	fst	%f0, %g5, -8
	ld	%g5, %g1, 44
	ld	%g5, %g5, 0
	subi	%g5, %g5, 1
	ld	%g29, %g1, 40
	st	%g3, %g1, 84
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 92
	ld	%g28, %g29, 0
	subi	%g1, %g1, 96
	callR	%g28
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	mvhi	%g6, 0
	mvlo	%g6, 118
	ld	%g3, %g1, 84
	ld	%g4, %g1, 32
	ld	%g5, %g1, 52
	ld	%g29, %g1, 36
	st	%g31, %g1, 92
	ld	%g28, %g29, 0
	subi	%g1, %g1, 96
	callR	%g28
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
jeq_cont.31737:
	ld	%g3, %g1, 8
	slli	%g4, %g3, 2
	ld	%g5, %g1, 20
	st	%g5, %g1, 92
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 92
	ld	%g5, %g1, 16
	fld	%f0, %g5, 0
	fld	%f1, %g4, 0
	ld	%g6, %g1, 12
	fld	%f2, %g6, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g5, 0
	fld	%f0, %g5, -4
	fld	%f1, %g4, -4
	fld	%f2, %g6, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g5, -4
	fld	%f0, %g5, -8
	fld	%f1, %g4, -8
	fld	%f2, %g6, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g5, -8
jeq_cont.31727:
	ld	%g3, %g1, 8
	addi	%g4, %g3, 1
	ld	%g3, %g1, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jle_else.31725:
	return
jle_else.31724:
	return
try_exploit_neighbors.3149:
	ld	%g9, %g29, -12
	ld	%g10, %g29, -8
	ld	%g11, %g29, -4
	mvhi	%g12, 0
	mvlo	%g12, 4
	jlt	%g12, %g8, jle_else.31740
	slli	%g12, %g3, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g12
	ld	%g12, %g6, 0
	ld	%g6, %g1, 4
	ld	%g13, %g12, -8
	slli	%g14, %g8, 2
	st	%g13, %g1, 4
	add	%g13, %g13, %g14
	ld	%g13, %g13, 0
	mvhi	%g14, 0
	mvlo	%g14, 0
	jlt	%g13, %g14, jle_else.31741
	slli	%g15, %g3, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g15
	ld	%g15, %g5, 0
	ld	%g5, %g1, 4
	ld	%g16, %g15, -8
	slli	%g17, %g8, 2
	st	%g16, %g1, 4
	add	%g16, %g16, %g17
	ld	%g16, %g16, 0
	jne	%g16, %g13, jeq_else.31742
	slli	%g16, %g3, 2
	st	%g7, %g1, 4
	add	%g7, %g7, %g16
	ld	%g16, %g7, 0
	ld	%g7, %g1, 4
	ld	%g16, %g16, -8
	slli	%g17, %g8, 2
	st	%g16, %g1, 4
	add	%g16, %g16, %g17
	ld	%g16, %g16, 0
	jne	%g16, %g13, jeq_else.31744
	mvhi	%g16, 0
	mvlo	%g16, 1
	subi	%g17, %g3, 1
	slli	%g17, %g17, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g17
	ld	%g17, %g6, 0
	ld	%g6, %g1, 4
	ld	%g17, %g17, -8
	slli	%g18, %g8, 2
	st	%g17, %g1, 4
	add	%g17, %g17, %g18
	ld	%g17, %g17, 0
	jne	%g17, %g13, jeq_else.31746
	addi	%g17, %g3, 1
	slli	%g17, %g17, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g17
	ld	%g17, %g6, 0
	ld	%g6, %g1, 4
	ld	%g17, %g17, -8
	slli	%g18, %g8, 2
	st	%g17, %g1, 4
	add	%g17, %g17, %g18
	ld	%g17, %g17, 0
	jne	%g17, %g13, jeq_else.31748
	mov	%g13, %g16
	jmp	jeq_cont.31749
jeq_else.31748:
	mov	%g13, %g14
jeq_cont.31749:
	jmp	jeq_cont.31747
jeq_else.31746:
	mov	%g13, %g14
jeq_cont.31747:
	jmp	jeq_cont.31745
jeq_else.31744:
	mov	%g13, %g14
jeq_cont.31745:
	jmp	jeq_cont.31743
jeq_else.31742:
	mov	%g13, %g14
jeq_cont.31743:
	jne	%g13, %g14, jeq_else.31750
	slli	%g3, %g3, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g3
	ld	%g3, %g6, 0
	ld	%g6, %g1, 4
	mov	%g4, %g8
	mov	%g29, %g10
	ld	%g28, %g29, 0
	b	%g28
jeq_else.31750:
	ld	%g10, %g12, -12
	slli	%g13, %g8, 2
	st	%g10, %g1, 4
	add	%g10, %g10, %g13
	ld	%g10, %g10, 0
	jne	%g10, %g14, jeq_else.31751
	jmp	jeq_cont.31752
jeq_else.31751:
	ld	%g10, %g15, -20
	subi	%g13, %g3, 1
	slli	%g13, %g13, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g13
	ld	%g13, %g6, 0
	ld	%g6, %g1, 4
	ld	%g13, %g13, -20
	ld	%g12, %g12, -20
	addi	%g14, %g3, 1
	slli	%g14, %g14, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g14
	ld	%g14, %g6, 0
	ld	%g6, %g1, 4
	ld	%g14, %g14, -20
	slli	%g15, %g3, 2
	st	%g7, %g1, 4
	add	%g7, %g7, %g15
	ld	%g15, %g7, 0
	ld	%g7, %g1, 4
	ld	%g15, %g15, -20
	slli	%g16, %g8, 2
	st	%g10, %g1, 4
	add	%g10, %g10, %g16
	ld	%g10, %g10, 0
	fld	%f0, %g10, 0
	fst	%f0, %g11, 0
	fld	%f0, %g10, -4
	fst	%f0, %g11, -4
	fld	%f0, %g10, -8
	fst	%f0, %g11, -8
	slli	%g10, %g8, 2
	st	%g13, %g1, 4
	add	%g13, %g13, %g10
	ld	%g10, %g13, 0
	ld	%g13, %g1, 4
	fld	%f0, %g11, 0
	fld	%f1, %g10, 0
	fadd	%f0, %f0, %f1
	fst	%f0, %g11, 0
	fld	%f0, %g11, -4
	fld	%f1, %g10, -4
	fadd	%f0, %f0, %f1
	fst	%f0, %g11, -4
	fld	%f0, %g11, -8
	fld	%f1, %g10, -8
	fadd	%f0, %f0, %f1
	fst	%f0, %g11, -8
	slli	%g10, %g8, 2
	st	%g12, %g1, 4
	add	%g12, %g12, %g10
	ld	%g10, %g12, 0
	ld	%g12, %g1, 4
	fld	%f0, %g11, 0
	fld	%f1, %g10, 0
	fadd	%f0, %f0, %f1
	fst	%f0, %g11, 0
	fld	%f0, %g11, -4
	fld	%f1, %g10, -4
	fadd	%f0, %f0, %f1
	fst	%f0, %g11, -4
	fld	%f0, %g11, -8
	fld	%f1, %g10, -8
	fadd	%f0, %f0, %f1
	fst	%f0, %g11, -8
	slli	%g10, %g8, 2
	st	%g14, %g1, 4
	add	%g14, %g14, %g10
	ld	%g10, %g14, 0
	ld	%g14, %g1, 4
	fld	%f0, %g11, 0
	fld	%f1, %g10, 0
	fadd	%f0, %f0, %f1
	fst	%f0, %g11, 0
	fld	%f0, %g11, -4
	fld	%f1, %g10, -4
	fadd	%f0, %f0, %f1
	fst	%f0, %g11, -4
	fld	%f0, %g11, -8
	fld	%f1, %g10, -8
	fadd	%f0, %f0, %f1
	fst	%f0, %g11, -8
	slli	%g10, %g8, 2
	st	%g15, %g1, 4
	add	%g15, %g15, %g10
	ld	%g10, %g15, 0
	ld	%g15, %g1, 4
	fld	%f0, %g11, 0
	fld	%f1, %g10, 0
	fadd	%f0, %f0, %f1
	fst	%f0, %g11, 0
	fld	%f0, %g11, -4
	fld	%f1, %g10, -4
	fadd	%f0, %f0, %f1
	fst	%f0, %g11, -4
	fld	%f0, %g11, -8
	fld	%f1, %g10, -8
	fadd	%f0, %f0, %f1
	fst	%f0, %g11, -8
	slli	%g10, %g3, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g10
	ld	%g10, %g6, 0
	ld	%g6, %g1, 4
	ld	%g10, %g10, -16
	slli	%g12, %g8, 2
	st	%g10, %g1, 4
	add	%g10, %g10, %g12
	ld	%g10, %g10, 0
	fld	%f0, %g9, 0
	fld	%f1, %g10, 0
	fld	%f2, %g11, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, 0
	fld	%f0, %g9, -4
	fld	%f1, %g10, -4
	fld	%f2, %g11, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, -4
	fld	%f0, %g9, -8
	fld	%f1, %g10, -8
	fld	%f2, %g11, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, -8
jeq_cont.31752:
	addi	%g8, %g8, 1
	ld	%g28, %g29, 0
	b	%g28
jle_else.31741:
	return
jle_else.31740:
	return
pretrace_diffuse_rays.3162:
	ld	%g5, %g29, -24
	ld	%g6, %g29, -20
	ld	%g7, %g29, -16
	ld	%g8, %g29, -12
	ld	%g9, %g29, -8
	ld	%g10, %g29, -4
	mvhi	%g11, 0
	mvlo	%g11, 4
	jlt	%g11, %g4, jle_else.31755
	ld	%g11, %g3, -8
	slli	%g12, %g4, 2
	st	%g11, %g1, 4
	add	%g11, %g11, %g12
	ld	%g11, %g11, 0
	mvhi	%g12, 0
	mvlo	%g12, 0
	jlt	%g11, %g12, jle_else.31756
	ld	%g11, %g3, -12
	slli	%g13, %g4, 2
	st	%g11, %g1, 4
	add	%g11, %g11, %g13
	ld	%g11, %g11, 0
	st	%g29, %g1, 0
	st	%g4, %g1, 4
	jne	%g11, %g12, jeq_else.31757
	jmp	jeq_cont.31758
jeq_else.31757:
	ld	%g11, %g3, -24
	ld	%g11, %g11, 0
	setL %g12, l.22821
	fld	%f0, %g12, 0
	fst	%f0, %g10, 0
	fst	%f0, %g10, -4
	fst	%f0, %g10, -8
	ld	%g12, %g3, -28
	ld	%g13, %g3, -4
	slli	%g11, %g11, 2
	st	%g9, %g1, 12
	add	%g9, %g9, %g11
	ld	%g9, %g9, 0
	slli	%g11, %g4, 2
	st	%g12, %g1, 12
	add	%g12, %g12, %g11
	ld	%g11, %g12, 0
	ld	%g12, %g1, 12
	slli	%g12, %g4, 2
	st	%g13, %g1, 12
	add	%g13, %g13, %g12
	ld	%g12, %g13, 0
	ld	%g13, %g1, 12
	fld	%f0, %g12, 0
	fst	%f0, %g5, 0
	fld	%f0, %g12, -4
	fst	%f0, %g5, -4
	fld	%f0, %g12, -8
	fst	%f0, %g5, -8
	ld	%g5, %g7, 0
	subi	%g5, %g5, 1
	st	%g10, %g1, 8
	st	%g3, %g1, 12
	st	%g12, %g1, 16
	st	%g11, %g1, 20
	st	%g9, %g1, 24
	st	%g8, %g1, 28
	mov	%g4, %g5
	mov	%g3, %g12
	mov	%g29, %g6
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g6, 0
	mvlo	%g6, 118
	ld	%g3, %g1, 24
	ld	%g4, %g1, 20
	ld	%g5, %g1, 16
	ld	%g29, %g1, 28
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 12
	ld	%g4, %g3, -20
	ld	%g5, %g1, 4
	slli	%g6, %g5, 2
	st	%g4, %g1, 36
	add	%g4, %g4, %g6
	ld	%g4, %g4, 0
	ld	%g6, %g1, 8
	fld	%f0, %g6, 0
	fst	%f0, %g4, 0
	fld	%f0, %g6, -4
	fst	%f0, %g4, -4
	fld	%f0, %g6, -8
	fst	%f0, %g4, -8
jeq_cont.31758:
	ld	%g4, %g1, 4
	addi	%g4, %g4, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.31756:
	return
jle_else.31755:
	return
pretrace_pixels.3165:
	ld	%g6, %g29, -36
	ld	%g7, %g29, -32
	ld	%g8, %g29, -28
	ld	%g9, %g29, -24
	ld	%g10, %g29, -20
	ld	%g11, %g29, -16
	ld	%g12, %g29, -12
	ld	%g13, %g29, -8
	ld	%g14, %g29, -4
	mvhi	%g15, 0
	mvlo	%g15, 0
	jlt	%g4, %g15, jle_else.31761
	ld	%g14, %g14, 0
	sub	%g14, %g4, %g14
	st	%g29, %g1, 0
	st	%g13, %g1, 4
	st	%g5, %g1, 8
	st	%g7, %g1, 12
	st	%g3, %g1, 16
	st	%g4, %g1, 20
	st	%g8, %g1, 24
	st	%g6, %g1, 28
	st	%g11, %g1, 32
	st	%g15, %g1, 36
	fst	%f2, %g1, 40
	fst	%f1, %g1, 44
	st	%g12, %g1, 48
	fst	%f0, %g1, 52
	st	%g9, %g1, 56
	st	%g10, %g1, 60
	mov	%g3, %g14
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	min_caml_float_of_int
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 60
	fld	%f1, %g3, 0
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 56
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	fld	%f2, %g1, 52
	fadd	%f1, %f1, %f2
	ld	%g4, %g1, 48
	fst	%f1, %g4, 0
	mvhi	%g5, 0
	mvlo	%g5, 1
	fld	%f1, %g3, -4
	fmul	%f1, %f0, %f1
	fld	%f3, %g1, 44
	fadd	%f1, %f1, %f3
	fst	%f1, %g4, -4
	fld	%f1, %g3, -8
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 40
	fadd	%f0, %f0, %f1
	fst	%f0, %g4, -8
	fld	%f0, %g4, -8
	fmul	%f0, %f0, %f0
	fld	%f4, %g4, -4
	fmul	%f4, %f4, %f4
	fld	%f5, %g4, 0
	fmul	%f6, %f5, %f5
	fadd	%f4, %f6, %f4
	fadd	%f0, %f4, %f0
	fst	%f5, %g1, 64
	st	%g5, %g1, 68
	fsqrt	%f0, %f0
	setL %g3, l.22821
	fld	%f1, %g3, 0
	fjeq	%f0, %f1, fjne_else.31762
	ld	%g3, %g1, 36
	jmp	fjne_cont.31763
fjne_else.31762:
	ld	%g3, %g1, 68
fjne_cont.31763:
	ld	%g4, %g1, 36
	jne	%g3, %g4, jeq_else.31764
	setL %g3, l.22819
	fld	%f2, %g3, 0
	fdiv	%f0, %f2, %f0
	jmp	jeq_cont.31765
jeq_else.31764:
	setL %g3, l.22819
	fld	%f0, %g3, 0
jeq_cont.31765:
	fld	%f2, %g1, 64
	fmul	%f2, %f2, %f0
	ld	%g3, %g1, 48
	fst	%f2, %g3, 0
	fld	%f2, %g3, -4
	fmul	%f2, %f2, %f0
	fst	%f2, %g3, -4
	fld	%f2, %g3, -8
	fmul	%f0, %f2, %f0
	fst	%f0, %g3, -8
	ld	%g5, %g1, 32
	fst	%f1, %g5, 0
	fst	%f1, %g5, -4
	fst	%f1, %g5, -8
	ld	%g6, %g1, 28
	fld	%f0, %g6, 0
	ld	%g7, %g1, 24
	fst	%f0, %g7, 0
	fld	%f0, %g6, -4
	fst	%f0, %g7, -4
	fld	%f0, %g6, -8
	fst	%f0, %g7, -8
	ld	%g6, %g1, 20
	slli	%g7, %g6, 2
	ld	%g8, %g1, 16
	st	%g8, %g1, 76
	add	%g8, %g8, %g7
	ld	%g7, %g8, 0
	ld	%g8, %g1, 76
	setL %g9, l.22819
	fld	%f0, %g9, 0
	ld	%g29, %g1, 12
	mov	%g5, %g7
	mov	%g28, %g4
	mov	%g4, %g3
	mov	%g3, %g28
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g3, %g1, 20
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	st	%g5, %g1, 76
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 76
	ld	%g4, %g4, 0
	ld	%g6, %g1, 32
	fld	%f0, %g6, 0
	fst	%f0, %g4, 0
	fld	%f0, %g6, -4
	fst	%f0, %g4, -4
	fld	%f0, %g6, -8
	fst	%f0, %g4, -8
	slli	%g4, %g3, 2
	st	%g5, %g1, 76
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 76
	ld	%g4, %g4, -24
	ld	%g6, %g1, 8
	st	%g6, %g4, 0
	slli	%g4, %g3, 2
	st	%g5, %g1, 76
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 76
	ld	%g7, %g1, 36
	ld	%g29, %g1, 4
	mov	%g3, %g4
	mov	%g4, %g7
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g3, %g1, 8
	addi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 5
	jlt	%g3, %g4, jle_else.31766
	subi	%g5, %g3, 5
	jmp	jle_cont.31767
jle_else.31766:
	mov	%g5, %g3
jle_cont.31767:
	ld	%g3, %g1, 20
	subi	%g4, %g3, 1
	fld	%f0, %g1, 52
	fld	%f1, %g1, 44
	fld	%f2, %g1, 40
	ld	%g3, %g1, 16
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.31761:
	return
scan_pixel.3176:
	ld	%g8, %g29, -32
	ld	%g9, %g29, -28
	ld	%g10, %g29, -24
	ld	%g11, %g29, -20
	ld	%g12, %g29, -16
	ld	%g13, %g29, -12
	ld	%g14, %g29, -8
	ld	%g15, %g29, -4
	mvhi	%g16, 0
	mvlo	%g16, 0
	ld	%g17, %g14, 0
	jlt	%g3, %g17, jle_else.31769
	return
jle_else.31769:
	slli	%g17, %g3, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g17
	ld	%g17, %g6, 0
	ld	%g6, %g1, 4
	ld	%g17, %g17, 0
	fld	%f0, %g17, 0
	fst	%f0, %g9, 0
	mvhi	%g18, 0
	mvlo	%g18, 1
	fld	%f0, %g17, -4
	fst	%f0, %g9, -4
	fld	%f0, %g17, -8
	fst	%f0, %g9, -8
	addi	%g17, %g4, 1
	ld	%g19, %g14, -4
	jlt	%g17, %g19, jle_else.31771
	mov	%g14, %g16
	jmp	jle_cont.31772
jle_else.31771:
	jlt	%g16, %g4, jle_else.31773
	mov	%g14, %g16
	jmp	jle_cont.31774
jle_else.31773:
	ld	%g14, %g14, 0
	addi	%g17, %g3, 1
	jlt	%g17, %g14, jle_else.31775
	mov	%g14, %g16
	jmp	jle_cont.31776
jle_else.31775:
	jlt	%g16, %g3, jle_else.31777
	mov	%g14, %g16
	jmp	jle_cont.31778
jle_else.31777:
	mov	%g14, %g18
jle_cont.31778:
jle_cont.31776:
jle_cont.31774:
jle_cont.31772:
	st	%g7, %g1, 0
	st	%g6, %g1, 4
	st	%g5, %g1, 8
	st	%g4, %g1, 12
	st	%g29, %g1, 16
	st	%g3, %g1, 20
	st	%g11, %g1, 24
	st	%g18, %g1, 28
	st	%g12, %g1, 32
	st	%g13, %g1, 36
	st	%g10, %g1, 40
	st	%g16, %g1, 44
	st	%g9, %g1, 48
	jne	%g14, %g16, jeq_else.31779
	slli	%g8, %g3, 2
	st	%g6, %g1, 52
	add	%g6, %g6, %g8
	ld	%g8, %g6, 0
	ld	%g6, %g1, 52
	mov	%g4, %g16
	mov	%g3, %g8
	mov	%g29, %g15
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	jmp	jeq_cont.31780
jeq_else.31779:
	mov	%g29, %g8
	mov	%g8, %g16
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
jeq_cont.31780:
	ld	%g3, %g1, 48
	fld	%f0, %g3, 0
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	min_caml_int_of_float
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 255
	jlt	%g4, %g3, jle_else.31781
	ld	%g5, %g1, 44
	jlt	%g3, %g5, jle_else.31783
	jmp	jle_cont.31784
jle_else.31783:
	mov	%g3, %g5
jle_cont.31784:
	jmp	jle_cont.31782
jle_else.31781:
	mov	%g3, %g4
jle_cont.31782:
	ld	%g5, %g1, 44
	jlt	%g3, %g5, jle_else.31785
	mov	%g6, %g3
	jmp	jle_cont.31786
jle_else.31785:
	sub	%g6, %g0, %g3
jle_cont.31786:
	ld	%g7, %g1, 40
	st	%g6, %g7, 0
	ld	%g6, %g7, 0
	st	%g4, %g1, 52
	st	%g3, %g1, 56
	jlt	%g5, %g6, jle_else.31787
	mvhi	%g3, 65535
	mvlo	%g3, -1
	jmp	jle_cont.31788
jle_else.31787:
	divi	%g8, %g6, 10
	muli	%g9, %g8, 10
	sub	%g6, %g6, %g9
	ld	%g9, %g1, 36
	st	%g6, %g9, 0
	st	%g8, %g7, 0
	ld	%g6, %g1, 28
	ld	%g29, %g1, 32
	mov	%g3, %g6
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
jle_cont.31788:
	ld	%g4, %g1, 56
	ld	%g5, %g1, 44
	st	%g3, %g1, 60
	jlt	%g4, %g5, jle_else.31789
	jmp	jle_cont.31790
jle_else.31789:
	mvhi	%g4, 0
	mvlo	%g4, 45
	mov	%g3, %g4
	output	%g3
jle_cont.31790:
	ld	%g3, %g1, 60
	ld	%g4, %g1, 44
	jlt	%g3, %g4, jle_else.31791
	ld	%g29, %g1, 24
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	jmp	jle_cont.31792
jle_else.31791:
	mvhi	%g3, 0
	mvlo	%g3, 48
	output	%g3
jle_cont.31792:
	mvhi	%g3, 0
	mvlo	%g3, 32
	st	%g3, %g1, 64
	output	%g3
	ld	%g3, %g1, 48
	fld	%f0, %g3, -4
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	min_caml_int_of_float
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g4, %g1, 52
	jlt	%g4, %g3, jle_else.31793
	ld	%g5, %g1, 44
	jlt	%g3, %g5, jle_else.31795
	jmp	jle_cont.31796
jle_else.31795:
	mov	%g3, %g5
jle_cont.31796:
	jmp	jle_cont.31794
jle_else.31793:
	mov	%g3, %g4
jle_cont.31794:
	ld	%g5, %g1, 44
	jlt	%g3, %g5, jle_else.31797
	mov	%g6, %g3
	jmp	jle_cont.31798
jle_else.31797:
	sub	%g6, %g0, %g3
jle_cont.31798:
	ld	%g7, %g1, 40
	st	%g6, %g7, 0
	ld	%g6, %g7, 0
	st	%g3, %g1, 68
	jlt	%g5, %g6, jle_else.31799
	mvhi	%g3, 65535
	mvlo	%g3, -1
	jmp	jle_cont.31800
jle_else.31799:
	divi	%g8, %g6, 10
	muli	%g9, %g8, 10
	sub	%g6, %g6, %g9
	ld	%g9, %g1, 36
	st	%g6, %g9, 0
	st	%g8, %g7, 0
	ld	%g6, %g1, 28
	ld	%g29, %g1, 32
	mov	%g3, %g6
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
jle_cont.31800:
	ld	%g4, %g1, 68
	ld	%g5, %g1, 44
	st	%g3, %g1, 72
	jlt	%g4, %g5, jle_else.31801
	jmp	jle_cont.31802
jle_else.31801:
	mvhi	%g4, 0
	mvlo	%g4, 45
	mov	%g3, %g4
	output	%g3
jle_cont.31802:
	ld	%g3, %g1, 72
	ld	%g4, %g1, 44
	jlt	%g3, %g4, jle_else.31803
	ld	%g29, %g1, 24
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	jmp	jle_cont.31804
jle_else.31803:
	mvhi	%g3, 0
	mvlo	%g3, 48
	output	%g3
jle_cont.31804:
	ld	%g3, %g1, 64
	output	%g3
	ld	%g3, %g1, 48
	fld	%f0, %g3, -8
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	min_caml_int_of_float
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g4, %g1, 52
	jlt	%g4, %g3, jle_else.31805
	ld	%g4, %g1, 44
	jlt	%g3, %g4, jle_else.31807
	jmp	jle_cont.31808
jle_else.31807:
	mov	%g3, %g4
jle_cont.31808:
	jmp	jle_cont.31806
jle_else.31805:
	mov	%g3, %g4
jle_cont.31806:
	ld	%g4, %g1, 44
	jlt	%g3, %g4, jle_else.31809
	mov	%g5, %g3
	jmp	jle_cont.31810
jle_else.31809:
	sub	%g5, %g0, %g3
jle_cont.31810:
	ld	%g6, %g1, 40
	st	%g5, %g6, 0
	ld	%g5, %g6, 0
	st	%g3, %g1, 76
	jlt	%g4, %g5, jle_else.31811
	mvhi	%g3, 65535
	mvlo	%g3, -1
	jmp	jle_cont.31812
jle_else.31811:
	divi	%g7, %g5, 10
	muli	%g8, %g7, 10
	sub	%g5, %g5, %g8
	ld	%g8, %g1, 36
	st	%g5, %g8, 0
	st	%g7, %g6, 0
	ld	%g5, %g1, 28
	ld	%g29, %g1, 32
	mov	%g3, %g5
	st	%g31, %g1, 84
	ld	%g28, %g29, 0
	subi	%g1, %g1, 88
	callR	%g28
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
jle_cont.31812:
	ld	%g4, %g1, 76
	ld	%g5, %g1, 44
	st	%g3, %g1, 80
	jlt	%g4, %g5, jle_else.31813
	jmp	jle_cont.31814
jle_else.31813:
	mvhi	%g4, 0
	mvlo	%g4, 45
	mov	%g3, %g4
	output	%g3
jle_cont.31814:
	ld	%g3, %g1, 80
	ld	%g4, %g1, 44
	jlt	%g3, %g4, jle_else.31815
	ld	%g29, %g1, 24
	st	%g31, %g1, 84
	ld	%g28, %g29, 0
	subi	%g1, %g1, 88
	callR	%g28
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	jmp	jle_cont.31816
jle_else.31815:
	mvhi	%g3, 0
	mvlo	%g3, 48
	output	%g3
jle_cont.31816:
	mvhi	%g3, 0
	mvlo	%g3, 10
	output	%g3
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	ld	%g4, %g1, 12
	ld	%g5, %g1, 8
	ld	%g6, %g1, 4
	ld	%g7, %g1, 0
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
scan_line.3182:
	ld	%g8, %g29, -28
	ld	%g9, %g29, -24
	ld	%g10, %g29, -20
	ld	%g11, %g29, -16
	ld	%g12, %g29, -12
	ld	%g13, %g29, -8
	ld	%g14, %g29, -4
	ld	%g15, %g13, -4
	jlt	%g3, %g15, jle_else.31817
	return
jle_else.31817:
	subi	%g15, %g15, 1
	st	%g29, %g1, 0
	st	%g7, %g1, 4
	st	%g6, %g1, 8
	st	%g5, %g1, 12
	st	%g4, %g1, 16
	st	%g3, %g1, 20
	st	%g10, %g1, 24
	jlt	%g3, %g15, jle_else.31819
	jmp	jle_cont.31820
jle_else.31819:
	addi	%g15, %g3, 1
	fld	%f0, %g11, 0
	ld	%g11, %g14, -4
	sub	%g11, %g15, %g11
	st	%g12, %g1, 28
	st	%g13, %g1, 32
	st	%g8, %g1, 36
	st	%g9, %g1, 40
	fst	%f0, %g1, 44
	mov	%g3, %g11
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 44
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 40
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	ld	%g4, %g1, 36
	fld	%f2, %g4, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g3, -4
	fmul	%f2, %f0, %f2
	fld	%f3, %g4, -4
	fadd	%f2, %f2, %f3
	fld	%f3, %g3, -8
	fmul	%f0, %f0, %f3
	fld	%f3, %g4, -8
	fadd	%f0, %f0, %f3
	ld	%g3, %g1, 32
	ld	%g3, %g3, 0
	subi	%g4, %g3, 1
	ld	%g3, %g1, 8
	ld	%g5, %g1, 4
	ld	%g29, %g1, 28
	fmov	%f31, %f2
	fmov	%f2, %f0
	fmov	%f0, %f1
	fmov	%f1, %f31
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
jle_cont.31820:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 20
	ld	%g5, %g1, 16
	ld	%g6, %g1, 12
	ld	%g7, %g1, 8
	ld	%g29, %g1, 24
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 4
	addi	%g3, %g3, 2
	mvhi	%g4, 0
	mvlo	%g4, 5
	jlt	%g3, %g4, jle_else.31821
	subi	%g7, %g3, 5
	jmp	jle_cont.31822
jle_else.31821:
	mov	%g7, %g3
jle_cont.31822:
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	ld	%g4, %g1, 12
	ld	%g5, %g1, 8
	ld	%g6, %g1, 16
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
create_pixel.3190:
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g4, l.22821
	fld	%f0, %g4, 0
	fst	%f0, %g1, 0
	st	%g3, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f0, %g1, 0
	ld	%g4, %g1, 4
	st	%g3, %g1, 8
	mov	%g3, %g4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 5
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f0, %g1, 0
	ld	%g4, %g1, 4
	st	%g3, %g1, 16
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_float_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 1
	ld	%g5, %g1, 16
	st	%g3, %g5, -4
	fld	%f0, %g1, 0
	ld	%g3, %g1, 4
	st	%g4, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_create_float_array
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 16
	st	%g3, %g4, -8
	fld	%f0, %g1, 0
	ld	%g3, %g1, 4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_create_float_array
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 16
	st	%g3, %g4, -12
	fld	%f0, %g1, 0
	ld	%g3, %g1, 4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_create_float_array
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 16
	st	%g3, %g4, -16
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g5, %g1, 12
	st	%g3, %g1, 24
	mov	%g4, %g3
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_create_array
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 12
	ld	%g5, %g1, 24
	st	%g3, %g1, 28
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_create_array
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f0, %g1, 0
	ld	%g4, %g1, 4
	st	%g3, %g1, 32
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_create_float_array
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g4, %g3
	ld	%g3, %g1, 12
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_create_array
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f0, %g1, 0
	ld	%g4, %g1, 4
	st	%g3, %g1, 36
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 36
	st	%g3, %g4, -4
	fld	%f0, %g1, 0
	ld	%g3, %g1, 4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 36
	st	%g3, %g4, -8
	fld	%f0, %g1, 0
	ld	%g3, %g1, 4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 36
	st	%g3, %g4, -12
	fld	%f0, %g1, 0
	ld	%g3, %g1, 4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 36
	st	%g3, %g4, -16
	fld	%f0, %g1, 0
	ld	%g3, %g1, 4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mov	%g4, %g3
	ld	%g3, %g1, 12
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f0, %g1, 0
	ld	%g4, %g1, 4
	st	%g3, %g1, 40
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 40
	st	%g3, %g4, -4
	fld	%f0, %g1, 0
	ld	%g3, %g1, 4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 40
	st	%g3, %g4, -8
	fld	%f0, %g1, 0
	ld	%g3, %g1, 4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 40
	st	%g3, %g4, -12
	fld	%f0, %g1, 0
	ld	%g3, %g1, 4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 40
	st	%g3, %g4, -16
	ld	%g3, %g1, 20
	ld	%g5, %g1, 24
	mov	%g4, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f0, %g1, 0
	ld	%g4, %g1, 4
	st	%g3, %g1, 44
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	min_caml_create_float_array
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mov	%g4, %g3
	ld	%g3, %g1, 12
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	min_caml_create_array
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f0, %g1, 0
	ld	%g4, %g1, 4
	st	%g3, %g1, 48
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	min_caml_create_float_array
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g4, %g1, 48
	st	%g3, %g4, -4
	fld	%f0, %g1, 0
	ld	%g3, %g1, 4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	min_caml_create_float_array
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g4, %g1, 48
	st	%g3, %g4, -8
	fld	%f0, %g1, 0
	ld	%g3, %g1, 4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	min_caml_create_float_array
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g4, %g1, 48
	st	%g3, %g4, -12
	fld	%f0, %g1, 0
	ld	%g3, %g1, 4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	min_caml_create_float_array
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g4, %g1, 48
	st	%g3, %g4, -16
	mov	%g3, %g2
	addi	%g2, %g2, 32
	st	%g4, %g3, -28
	ld	%g4, %g1, 44
	st	%g4, %g3, -24
	ld	%g4, %g1, 40
	st	%g4, %g3, -20
	ld	%g4, %g1, 36
	st	%g4, %g3, -16
	ld	%g4, %g1, 32
	st	%g4, %g3, -12
	ld	%g4, %g1, 28
	st	%g4, %g3, -8
	ld	%g4, %g1, 16
	st	%g4, %g3, -4
	ld	%g4, %g1, 8
	st	%g4, %g3, 0
	return
init_line_elements.3192:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jlt	%g4, %g5, jle_else.31823
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	create_pixel.3190
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	slli	%g5, %g4, 2
	ld	%g6, %g1, 0
	st	%g6, %g1, 12
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 12
	subi	%g4, %g4, 1
	mov	%g3, %g6
	jmp	init_line_elements.3192
jle_else.31823:
	return
tan_sub.6499.6594.17981.18079:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.31824
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31825
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31826
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31827
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	jmp	tan_sub.6499.6594.17981.18079
fjge_else.31827:
	fmov	%f0, %f2
	return
fjge_else.31826:
	fmov	%f0, %f2
	return
fjge_else.31825:
	fmov	%f0, %f2
	return
fjge_else.31824:
	fmov	%f0, %f2
	return
tan_sub.6499.6594.6640.17934.18032:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.31828
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31829
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31830
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31831
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	jmp	tan_sub.6499.6594.6640.17934.18032
fjge_else.31831:
	fmov	%f0, %f2
	return
fjge_else.31830:
	fmov	%f0, %f2
	return
fjge_else.31829:
	fmov	%f0, %f2
	return
fjge_else.31828:
	fmov	%f0, %f2
	return
adjust_position.3199:
	ld	%g3, %g29, -32
	fld	%f2, %g29, -24
	fld	%f3, %g29, -16
	fld	%f4, %g29, -8
	setL %g4, l.22821
	fld	%f5, %g4, 0
	setL %g4, l.24294
	fld	%f6, %g4, 0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f0, %f6
	fst	%f2, %g1, 0
	fst	%f4, %g1, 4
	st	%g3, %g1, 8
	fst	%f3, %g1, 12
	fst	%f1, %g1, 16
	fst	%f5, %g1, 20
	fsqrt	%f0, %f0
	setL %g3, l.22819
	fld	%f1, %g3, 0
	fdiv	%f2, %f1, %f0
	fjlt	%f1, %f2, fjge_else.31832
	setL %g3, l.23128
	fld	%f3, %g3, 0
	fjlt	%f2, %f3, fjge_else.31834
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	fjge_cont.31835
fjge_else.31834:
	mvhi	%g3, 65535
	mvlo	%g3, -1
fjge_cont.31835:
	jmp	fjge_cont.31833
fjge_else.31832:
	mvhi	%g3, 0
	mvlo	%g3, 1
fjge_cont.31833:
	fld	%f3, %g1, 20
	fjlt	%f2, %f3, fjge_else.31836
	fmov	%f4, %f2
	jmp	fjge_cont.31837
fjge_else.31836:
	fneg	%f4, %f2
fjge_cont.31837:
	fjlt	%f1, %f4, fjge_else.31838
	jmp	fjge_cont.31839
fjge_else.31838:
	fdiv	%f2, %f1, %f2
fjge_cont.31839:
	setL %g4, l.23909
	fld	%f4, %g4, 0
	setL %g4, l.23904
	fld	%f5, %g4, 0
	fmul	%f6, %f2, %f2
	fmul	%f5, %f5, %f6
	fdiv	%f4, %f5, %f4
	setL %g4, l.23902
	fld	%f5, %g4, 0
	fst	%f0, %g1, 24
	st	%g3, %g1, 28
	fst	%f2, %g1, 32
	fst	%f1, %g1, 36
	fmov	%f2, %f4
	fmov	%f1, %f6
	fmov	%f0, %f5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	atan_sub.2692
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fadd	%f0, %f1, %f0
	fld	%f2, %g1, 32
	fdiv	%f0, %f2, %f0
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 28
	jlt	%g3, %g4, jle_else.31840
	jlt	%g4, %g3, jle_else.31842
	jmp	jle_cont.31843
jle_else.31842:
	setL %g4, l.23913
	fld	%f2, %g4, 0
	setL %g4, l.23915
	fld	%f2, %g4, 0
	fsub	%f0, %f2, %f0
jle_cont.31843:
	jmp	jle_cont.31841
jle_else.31840:
	setL %g4, l.23911
	fld	%f2, %g4, 0
	fsub	%f0, %f2, %f0
jle_cont.31841:
	fld	%f2, %g1, 16
	fmul	%f0, %f0, %f2
	setL %g4, l.23155
	fld	%f2, %g4, 0
	fsub	%f2, %f2, %f0
	fld	%f3, %g1, 20
	fjlt	%f2, %f3, fjge_else.31844
	fmov	%f4, %f2
	jmp	fjge_cont.31845
fjge_else.31844:
	fneg	%f4, %f2
fjge_cont.31845:
	fld	%f5, %g1, 12
	fst	%f0, %g1, 40
	st	%g3, %g1, 44
	fst	%f2, %g1, 48
	fjlt	%f5, %f4, fjge_else.31846
	fjlt	%f4, %f3, fjge_else.31848
	fmov	%f0, %f4
	jmp	fjge_cont.31849
fjge_else.31848:
	fadd	%f4, %f4, %f5
	ld	%g29, %g1, 8
	fmov	%f0, %f4
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
fjge_cont.31849:
	jmp	fjge_cont.31847
fjge_else.31846:
	fsub	%f4, %f4, %f5
	ld	%g29, %g1, 8
	fmov	%f0, %f4
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
fjge_cont.31847:
	fld	%f1, %g1, 20
	fld	%f2, %g1, 48
	fjlt	%f1, %f2, fjge_else.31850
	ld	%g3, %g1, 44
	jmp	fjge_cont.31851
fjge_else.31850:
	mvhi	%g3, 0
	mvlo	%g3, 1
fjge_cont.31851:
	fld	%f2, %g1, 4
	fjlt	%f2, %f0, fjge_else.31852
	jmp	fjge_cont.31853
fjge_else.31852:
	ld	%g4, %g1, 44
	jne	%g3, %g4, jeq_else.31854
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.31855
jeq_else.31854:
	mov	%g3, %g4
jeq_cont.31855:
fjge_cont.31853:
	fjlt	%f2, %f0, fjge_else.31856
	jmp	fjge_cont.31857
fjge_else.31856:
	fld	%f3, %g1, 12
	fsub	%f0, %f3, %f0
fjge_cont.31857:
	fld	%f3, %g1, 0
	fjlt	%f3, %f0, fjge_else.31858
	jmp	fjge_cont.31859
fjge_else.31858:
	fsub	%f0, %f2, %f0
fjge_cont.31859:
	setL %g4, l.22815
	fld	%f4, %g4, 0
	fmul	%f0, %f0, %f4
	fmul	%f5, %f0, %f0
	setL %g4, l.23159
	fld	%f6, %g4, 0
	fdiv	%f7, %f5, %f6
	setL %g4, l.23163
	fld	%f8, %g4, 0
	fsub	%f7, %f8, %f7
	fdiv	%f7, %f5, %f7
	setL %g4, l.23165
	fld	%f9, %g4, 0
	fsub	%f7, %f9, %f7
	fdiv	%f7, %f5, %f7
	setL %g4, l.23167
	fld	%f10, %g4, 0
	fst	%f10, %g1, 52
	fst	%f9, %g1, 56
	fst	%f8, %g1, 60
	fst	%f6, %g1, 64
	fst	%f4, %g1, 68
	st	%g3, %g1, 72
	fst	%f0, %g1, 76
	fmov	%f2, %f7
	fmov	%f1, %f5
	fmov	%f0, %f10
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	tan_sub.6499.6594.6640.17934.18032
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fld	%f1, %g1, 36
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 76
	fdiv	%f0, %f2, %f0
	fmul	%f2, %f0, %f0
	fadd	%f2, %f1, %f2
	setL %g3, l.22817
	fld	%f3, %g3, 0
	fmul	%f0, %f3, %f0
	fdiv	%f0, %f0, %f2
	ld	%g3, %g1, 44
	ld	%g4, %g1, 72
	jne	%g4, %g3, jeq_else.31860
	fneg	%f0, %f0
	jmp	jeq_cont.31861
jeq_else.31860:
jeq_cont.31861:
	fld	%f2, %g1, 40
	fld	%f4, %g1, 20
	fjlt	%f2, %f4, fjge_else.31862
	fmov	%f5, %f2
	jmp	fjge_cont.31863
fjge_else.31862:
	fneg	%f5, %f2
fjge_cont.31863:
	fld	%f6, %g1, 12
	fst	%f0, %g1, 80
	fst	%f3, %g1, 84
	fjlt	%f6, %f5, fjge_else.31864
	fjlt	%f5, %f4, fjge_else.31866
	fmov	%f0, %f5
	jmp	fjge_cont.31867
fjge_else.31866:
	fadd	%f5, %f5, %f6
	ld	%g29, %g1, 8
	fmov	%f0, %f5
	st	%g31, %g1, 92
	ld	%g28, %g29, 0
	subi	%g1, %g1, 96
	callR	%g28
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
fjge_cont.31867:
	jmp	fjge_cont.31865
fjge_else.31864:
	fsub	%f5, %f5, %f6
	ld	%g29, %g1, 8
	fmov	%f0, %f5
	st	%g31, %g1, 92
	ld	%g28, %g29, 0
	subi	%g1, %g1, 96
	callR	%g28
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
fjge_cont.31865:
	fld	%f1, %g1, 20
	fld	%f2, %g1, 40
	fjlt	%f1, %f2, fjge_else.31868
	ld	%g3, %g1, 44
	jmp	fjge_cont.31869
fjge_else.31868:
	mvhi	%g3, 0
	mvlo	%g3, 1
fjge_cont.31869:
	fld	%f1, %g1, 4
	fjlt	%f1, %f0, fjge_else.31870
	jmp	fjge_cont.31871
fjge_else.31870:
	ld	%g4, %g1, 44
	jne	%g3, %g4, jeq_else.31872
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.31873
jeq_else.31872:
	mov	%g3, %g4
jeq_cont.31873:
fjge_cont.31871:
	fjlt	%f1, %f0, fjge_else.31874
	jmp	fjge_cont.31875
fjge_else.31874:
	fld	%f2, %g1, 12
	fsub	%f0, %f2, %f0
fjge_cont.31875:
	fld	%f2, %g1, 0
	fjlt	%f2, %f0, fjge_else.31876
	jmp	fjge_cont.31877
fjge_else.31876:
	fsub	%f0, %f1, %f0
fjge_cont.31877:
	fld	%f1, %g1, 68
	fmul	%f0, %f0, %f1
	fmul	%f1, %f0, %f0
	fld	%f2, %g1, 64
	fdiv	%f2, %f1, %f2
	fld	%f3, %g1, 60
	fsub	%f2, %f3, %f2
	fdiv	%f2, %f1, %f2
	fld	%f3, %g1, 56
	fsub	%f2, %f3, %f2
	fdiv	%f2, %f1, %f2
	fld	%f3, %g1, 52
	st	%g3, %g1, 88
	fst	%f0, %g1, 92
	fmov	%f0, %f3
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	tan_sub.6499.6594.17981.18079
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	fld	%f1, %g1, 36
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 92
	fdiv	%f0, %f2, %f0
	fmul	%f2, %f0, %f0
	fadd	%f1, %f1, %f2
	fld	%f2, %g1, 84
	fmul	%f0, %f2, %f0
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 44
	ld	%g4, %g1, 88
	jne	%g4, %g3, jeq_else.31878
	fneg	%f0, %f0
	jmp	jeq_cont.31879
jeq_else.31878:
jeq_cont.31879:
	fld	%f1, %g1, 80
	fdiv	%f0, %f0, %f1
	fld	%f1, %g1, 24
	fmul	%f0, %f0, %f1
	return
calc_dirvec.3202:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	mvhi	%g8, 0
	mvlo	%g8, 5
	jlt	%g3, %g8, jle_else.31880
	slli	%g3, %g4, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g3
	ld	%g3, %g6, 0
	ld	%g6, %g1, 4
	slli	%g4, %g5, 2
	st	%g3, %g1, 4
	add	%g3, %g3, %g4
	ld	%g4, %g3, 0
	ld	%g3, %g1, 4
	ld	%g4, %g4, 0
	setL %g6, l.22819
	fld	%f2, %g6, 0
	fmul	%f3, %f1, %f1
	fmul	%f4, %f0, %f0
	fadd	%f3, %f4, %f3
	fadd	%f3, %f3, %f2
	st	%g3, %g1, 0
	st	%g5, %g1, 4
	fst	%f2, %g1, 8
	fst	%f1, %g1, 12
	st	%g4, %g1, 16
	fst	%f0, %g1, 20
	fmov	%f0, %f3
	fsqrt	%f0, %f0
	fld	%f1, %g1, 20
	fdiv	%f1, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f1, %g3, 0
	fld	%f2, %g1, 12
	fdiv	%f2, %f2, %f0
	fst	%f2, %g3, -4
	fld	%f3, %g1, 8
	fdiv	%f0, %f3, %f0
	fst	%f0, %g3, -8
	ld	%g3, %g1, 4
	addi	%g4, %g3, 40
	slli	%g4, %g4, 2
	ld	%g5, %g1, 0
	st	%g5, %g1, 28
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 28
	ld	%g4, %g4, 0
	fst	%f1, %g4, 0
	fst	%f0, %g4, -4
	fneg	%f3, %f2
	fst	%f3, %g4, -8
	addi	%g4, %g3, 80
	slli	%g4, %g4, 2
	st	%g5, %g1, 28
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 28
	ld	%g4, %g4, 0
	fst	%f0, %g4, 0
	fneg	%f4, %f1
	fst	%f4, %g4, -4
	fst	%f3, %g4, -8
	addi	%g4, %g3, 1
	slli	%g4, %g4, 2
	st	%g5, %g1, 28
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 28
	ld	%g4, %g4, 0
	fst	%f4, %g4, 0
	fst	%f3, %g4, -4
	fneg	%f0, %f0
	fst	%f0, %g4, -8
	addi	%g4, %g3, 41
	slli	%g4, %g4, 2
	st	%g5, %g1, 28
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 28
	ld	%g4, %g4, 0
	fst	%f4, %g4, 0
	fst	%f0, %g4, -4
	fst	%f2, %g4, -8
	addi	%g3, %g3, 81
	slli	%g3, %g3, 2
	st	%g5, %g1, 28
	add	%g5, %g5, %g3
	ld	%g3, %g5, 0
	ld	%g5, %g1, 28
	ld	%g3, %g3, 0
	fst	%f0, %g3, 0
	fst	%f1, %g3, -4
	fst	%f2, %g3, -8
	return
jle_else.31880:
	fst	%f2, %g1, 24
	st	%g5, %g1, 4
	st	%g4, %g1, 28
	st	%g29, %g1, 32
	fst	%f3, %g1, 36
	st	%g7, %g1, 40
	st	%g3, %g1, 44
	mov	%g29, %g7
	fmov	%f0, %f1
	fmov	%f1, %f2
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 44
	addi	%g3, %g3, 1
	fld	%f1, %g1, 36
	ld	%g29, %g1, 40
	fst	%f0, %g1, 48
	st	%g3, %g1, 52
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fmov	%f1, %f0
	fld	%f0, %g1, 48
	fld	%f2, %g1, 24
	fld	%f3, %g1, 36
	ld	%g3, %g1, 52
	ld	%g4, %g1, 28
	ld	%g5, %g1, 4
	ld	%g29, %g1, 32
	ld	%g28, %g29, 0
	b	%g28
calc_dirvecs.3210:
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g3, %g7, jle_else.31882
	setL %g8, l.25062
	fld	%f1, %g8, 0
	setL %g8, l.25064
	fld	%f2, %g8, 0
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	fst	%f0, %g1, 8
	st	%g5, %g1, 12
	st	%g4, %g1, 16
	st	%g7, %g1, 20
	st	%g6, %g1, 24
	fst	%f1, %g1, 28
	fst	%f2, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_float_of_int
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 28
	fsub	%f2, %f0, %f1
	setL %g3, l.22821
	fld	%f1, %g3, 0
	fld	%f3, %g1, 8
	ld	%g3, %g1, 20
	ld	%g4, %g1, 16
	ld	%g5, %g1, 12
	ld	%g29, %g1, 24
	fst	%f1, %g1, 36
	fst	%f0, %g1, 40
	fmov	%f0, %f1
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	setL %g3, l.24294
	fld	%f0, %g3, 0
	fld	%f1, %g1, 40
	fadd	%f2, %f1, %f0
	ld	%g3, %g1, 12
	addi	%g5, %g3, 2
	fld	%f0, %g1, 36
	fld	%f3, %g1, 8
	ld	%g4, %g1, 20
	ld	%g6, %g1, 16
	ld	%g29, %g1, 24
	mov	%g3, %g4
	mov	%g4, %g6
	fmov	%f1, %f0
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 5
	jlt	%g3, %g4, jle_else.31883
	subi	%g4, %g3, 5
	jmp	jle_cont.31884
jle_else.31883:
	mov	%g4, %g3
jle_cont.31884:
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	fld	%f0, %g1, 8
	ld	%g5, %g1, 12
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.31882:
	return
calc_dirvec_rows.3215:
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g3, %g7, jle_else.31886
	setL %g7, l.25062
	fld	%f0, %g7, 0
	setL %g7, l.25064
	fld	%f1, %g7, 0
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	st	%g5, %g1, 8
	st	%g4, %g1, 12
	st	%g6, %g1, 16
	fst	%f0, %g1, 20
	fst	%f1, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 20
	fsub	%f0, %f0, %f1
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 12
	ld	%g5, %g1, 8
	ld	%g29, %g1, 16
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 8
	addi	%g5, %g3, 4
	ld	%g3, %g1, 12
	addi	%g3, %g3, 2
	mvhi	%g4, 0
	mvlo	%g4, 5
	jlt	%g3, %g4, jle_else.31887
	subi	%g4, %g3, 5
	jmp	jle_cont.31888
jle_else.31887:
	mov	%g4, %g3
jle_cont.31888:
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.31886:
	return
create_dirvec_elements.3221:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g4, %g6, jle_else.31890
	mvhi	%g6, 0
	mvlo	%g6, 3
	setL %g7, l.22821
	fld	%f0, %g7, 0
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	st	%g4, %g1, 8
	st	%g5, %g1, 12
	mov	%g3, %g6
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_float_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g3
	ld	%g3, %g1, 12
	ld	%g3, %g3, 0
	st	%g4, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 16
	st	%g3, %g4, 0
	mov	%g3, %g4
	ld	%g4, %g1, 8
	slli	%g5, %g4, 2
	ld	%g6, %g1, 4
	st	%g6, %g1, 20
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 20
	subi	%g4, %g4, 1
	ld	%g29, %g1, 0
	mov	%g3, %g6
	ld	%g28, %g29, 0
	b	%g28
jle_else.31890:
	return
create_dirvecs.3224:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g3, %g7, jle_else.31892
	mvhi	%g7, 0
	mvlo	%g7, 3
	setL %g8, l.22821
	fld	%f0, %g8, 0
	st	%g29, %g1, 0
	st	%g6, %g1, 4
	st	%g5, %g1, 8
	st	%g3, %g1, 12
	st	%g4, %g1, 16
	mov	%g3, %g7
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_float_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g3
	ld	%g3, %g1, 16
	ld	%g3, %g3, 0
	st	%g4, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_create_array
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 20
	st	%g3, %g4, 0
	mvhi	%g3, 0
	mvlo	%g3, 120
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_create_array
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 12
	slli	%g5, %g4, 2
	ld	%g6, %g1, 8
	st	%g6, %g1, 28
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 28
	mvhi	%g3, 0
	mvlo	%g3, 118
	slli	%g5, %g4, 2
	st	%g6, %g1, 28
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 28
	ld	%g29, %g1, 4
	mov	%g4, %g3
	mov	%g3, %g5
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 12
	subi	%g3, %g3, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.31892:
	return
init_dirvec_constants.3226:
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g4, %g7, jle_else.31894
	slli	%g7, %g4, 2
	st	%g3, %g1, 4
	add	%g3, %g3, %g7
	ld	%g7, %g3, 0
	ld	%g3, %g1, 4
	ld	%g5, %g5, 0
	subi	%g5, %g5, 1
	st	%g3, %g1, 0
	st	%g29, %g1, 4
	st	%g4, %g1, 8
	mov	%g4, %g5
	mov	%g3, %g7
	mov	%g29, %g6
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 8
	subi	%g4, %g3, 1
	ld	%g3, %g1, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jle_else.31894:
	return
init_vecset_constants.3229:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g3, %g6, jle_else.31896
	mvhi	%g6, 0
	mvlo	%g6, 119
	slli	%g7, %g3, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g7
	ld	%g5, %g5, 0
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g5
	mov	%g29, %g4
	mov	%g4, %g6
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.31896:
	return
tan_sub.6499.6594.6640.6891.10383.19707.20960:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.31898
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31899
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31900
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31901
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	jmp	tan_sub.6499.6594.6640.6891.10383.19707.20960
fjge_else.31901:
	fmov	%f0, %f2
	return
fjge_else.31900:
	fmov	%f0, %f2
	return
fjge_else.31899:
	fmov	%f0, %f2
	return
fjge_else.31898:
	fmov	%f0, %f2
	return
tan_sub.6499.6594.6842.10334.19658.20911:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.31902
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31903
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31904
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31905
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	jmp	tan_sub.6499.6594.6842.10334.19658.20911
fjge_else.31905:
	fmov	%f0, %f2
	return
fjge_else.31904:
	fmov	%f0, %f2
	return
fjge_else.31903:
	fmov	%f0, %f2
	return
fjge_else.31902:
	fmov	%f0, %f2
	return
tan_sub.6499.6594.6640.6760.10252.19576.20829:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.31906
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31907
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31908
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31909
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	jmp	tan_sub.6499.6594.6640.6760.10252.19576.20829
fjge_else.31909:
	fmov	%f0, %f2
	return
fjge_else.31908:
	fmov	%f0, %f2
	return
fjge_else.31907:
	fmov	%f0, %f2
	return
fjge_else.31906:
	fmov	%f0, %f2
	return
tan_sub.6499.6594.6711.10203.19527.20780:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.31910
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31911
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31912
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31913
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	jmp	tan_sub.6499.6594.6711.10203.19527.20780
fjge_else.31913:
	fmov	%f0, %f2
	return
fjge_else.31912:
	fmov	%f0, %f2
	return
fjge_else.31911:
	fmov	%f0, %f2
	return
fjge_else.31910:
	fmov	%f0, %f2
	return
tan_sub.6499.6594.7289.10038.19362.20615:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.31914
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31915
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31916
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31917
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	jmp	tan_sub.6499.6594.7289.10038.19362.20615
fjge_else.31917:
	fmov	%f0, %f2
	return
fjge_else.31916:
	fmov	%f0, %f2
	return
fjge_else.31915:
	fmov	%f0, %f2
	return
fjge_else.31914:
	fmov	%f0, %f2
	return
tan_sub.6499.6594.6640.7207.9956.19280.20533:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.31918
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31919
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31920
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31921
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	jmp	tan_sub.6499.6594.6640.7207.9956.19280.20533
fjge_else.31921:
	fmov	%f0, %f2
	return
fjge_else.31920:
	fmov	%f0, %f2
	return
fjge_else.31919:
	fmov	%f0, %f2
	return
fjge_else.31918:
	fmov	%f0, %f2
	return
tan_sub.6499.6594.7158.9907.19231.20484:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.31922
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31923
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31924
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31925
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	jmp	tan_sub.6499.6594.7158.9907.19231.20484
fjge_else.31925:
	fmov	%f0, %f2
	return
fjge_else.31924:
	fmov	%f0, %f2
	return
fjge_else.31923:
	fmov	%f0, %f2
	return
fjge_else.31922:
	fmov	%f0, %f2
	return
tan_sub.6499.6594.6640.7111.9860.19184.20437:
	setL %g3, l.22860
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.31926
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	setL %g3, l.22817
	fld	%f4, %g3, 0
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31927
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31928
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	fjlt	%f0, %f3, fjge_else.31929
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f0, %f0, %f4
	jmp	tan_sub.6499.6594.6640.7111.9860.19184.20437
fjge_else.31929:
	fmov	%f0, %f2
	return
fjge_else.31928:
	fmov	%f0, %f2
	return
fjge_else.31927:
	fmov	%f0, %f2
	return
fjge_else.31926:
	fmov	%f0, %f2
	return
min_caml_start:
	setL %g3, l.25108
	fld	%f0, %g3, 0
	mov	%g3, %g2
	addi	%g2, %g2, 16
	setL %g4, sin_sub.2700
	st	%g4, %g3, 0
	fst	%f0, %g3, -8
	mvhi	%g4, 0
	mvlo	%g4, 0
	mvhi	%g5, 0
	mvlo	%g5, 1
	fst	%f0, %g1, 0
	st	%g3, %g1, 4
	st	%g4, %g1, 8
	st	%g5, %g1, 12
	mov	%g3, %g5
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
	setL %g5, read_int_token.2710
	st	%g5, %g4, 0
	st	%g3, %g4, -8
	ld	%g5, %g1, 16
	st	%g5, %g4, -4
	ld	%g6, %g1, 12
	ld	%g7, %g1, 8
	st	%g3, %g1, 20
	st	%g4, %g1, 24
	mov	%g4, %g7
	mov	%g3, %g6
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_create_array
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 12
	ld	%g5, %g1, 8
	st	%g3, %g1, 28
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_create_array
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 12
	st	%g3, %g1, 32
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_create_array
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 12
	ld	%g5, %g1, 8
	st	%g3, %g1, 36
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mov	%g4, %g2
	addi	%g2, %g2, 16
	setL %g5, read_float_token1.2719
	st	%g5, %g4, 0
	st	%g3, %g4, -8
	ld	%g5, %g1, 28
	st	%g5, %g4, -4
	mov	%g6, %g2
	addi	%g2, %g2, 16
	setL %g7, read_float_token2.2722
	st	%g7, %g6, 0
	ld	%g7, %g1, 32
	st	%g7, %g6, -8
	ld	%g8, %g1, 36
	st	%g8, %g6, -4
	mvhi	%g9, 0
	mvlo	%g9, 10
	ld	%g10, %g1, 8
	st	%g9, %g1, 40
	st	%g3, %g1, 44
	st	%g4, %g1, 48
	st	%g6, %g1, 52
	mov	%g4, %g10
	mov	%g3, %g9
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	min_caml_create_array
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g4, %g1, 12
	ld	%g5, %g1, 8
	st	%g3, %g1, 56
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	min_caml_create_array
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g2
	addi	%g2, %g2, 16
	setL %g5, print_int_get_digits.2728
	st	%g5, %g4, 0
	st	%g3, %g4, -8
	ld	%g5, %g1, 56
	st	%g5, %g4, -4
	mov	%g6, %g2
	addi	%g2, %g2, 8
	setL %g7, print_int_print_digits.2730
	st	%g7, %g6, 0
	st	%g5, %g6, -4
	ld	%g7, %g1, 12
	ld	%g8, %g1, 8
	st	%g4, %g1, 60
	st	%g6, %g1, 64
	st	%g3, %g1, 68
	mov	%g4, %g8
	mov	%g3, %g7
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	min_caml_create_array
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	setL %g4, l.22821
	fld	%f0, %g4, 0
	ld	%g4, %g1, 8
	st	%g3, %g1, 72
	fst	%f0, %g1, 76
	mov	%g3, %g4
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	min_caml_create_float_array
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mov	%g4, %g2
	addi	%g2, %g2, 48
	st	%g3, %g4, -40
	st	%g3, %g4, -36
	st	%g3, %g4, -32
	st	%g3, %g4, -28
	ld	%g5, %g1, 8
	st	%g5, %g4, -24
	st	%g3, %g4, -20
	st	%g3, %g4, -16
	st	%g5, %g4, -12
	st	%g5, %g4, -8
	st	%g5, %g4, -4
	st	%g5, %g4, 0
	mvhi	%g3, 0
	mvlo	%g3, 60
	st	%g3, %g1, 80
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	min_caml_create_array
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g4, 0
	mvlo	%g4, 3
	fld	%f0, %g1, 76
	st	%g3, %g1, 84
	st	%g4, %g1, 88
	mov	%g3, %g4
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	min_caml_create_float_array
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	fld	%f0, %g1, 76
	ld	%g4, %g1, 88
	st	%g3, %g1, 92
	mov	%g3, %g4
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	min_caml_create_float_array
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	fld	%f0, %g1, 76
	ld	%g4, %g1, 88
	st	%g3, %g1, 96
	mov	%g3, %g4
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	min_caml_create_float_array
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	setL %g4, l.23938
	fld	%f0, %g4, 0
	ld	%g4, %g1, 12
	st	%g3, %g1, 100
	mov	%g3, %g4
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	min_caml_create_float_array
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	mvhi	%g4, 65535
	mvlo	%g4, -1
	ld	%g5, %g1, 12
	st	%g4, %g1, 104
	st	%g3, %g1, 108
	mov	%g3, %g5
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	min_caml_create_array
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 50
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	min_caml_create_array
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	ld	%g4, %g3, 0
	ld	%g5, %g1, 12
	st	%g3, %g1, 112
	mov	%g3, %g5
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	min_caml_create_array
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	mov	%g4, %g3
	ld	%g3, %g1, 12
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	min_caml_create_array
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	fld	%f0, %g1, 76
	ld	%g4, %g1, 12
	st	%g3, %g1, 116
	mov	%g3, %g4
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	min_caml_create_float_array
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	ld	%g4, %g1, 12
	ld	%g5, %g1, 8
	st	%g3, %g1, 120
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	min_caml_create_array
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	setL %g4, l.23998
	fld	%f0, %g4, 0
	ld	%g4, %g1, 12
	st	%g3, %g1, 124
	mov	%g3, %g4
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	min_caml_create_float_array
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	fld	%f0, %g1, 76
	ld	%g4, %g1, 88
	st	%g3, %g1, 128
	mov	%g3, %g4
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	min_caml_create_float_array
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g4, %g1, 12
	ld	%g5, %g1, 8
	st	%g3, %g1, 132
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	min_caml_create_array
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	fld	%f0, %g1, 76
	ld	%g4, %g1, 88
	st	%g3, %g1, 136
	mov	%g3, %g4
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	min_caml_create_float_array
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	fld	%f0, %g1, 76
	ld	%g4, %g1, 88
	st	%g3, %g1, 140
	mov	%g3, %g4
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	min_caml_create_float_array
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	fld	%f0, %g1, 76
	ld	%g4, %g1, 88
	st	%g3, %g1, 144
	mov	%g3, %g4
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	min_caml_create_float_array
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	fld	%f0, %g1, 76
	ld	%g4, %g1, 88
	st	%g3, %g1, 148
	mov	%g3, %g4
	st	%g31, %g1, 156
	subi	%g1, %g1, 160
	call	min_caml_create_float_array
	addi	%g1, %g1, 160
	ld	%g31, %g1, 156
	mvhi	%g4, 0
	mvlo	%g4, 2
	ld	%g5, %g1, 8
	st	%g3, %g1, 152
	st	%g4, %g1, 156
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 164
	subi	%g1, %g1, 168
	call	min_caml_create_array
	addi	%g1, %g1, 168
	ld	%g31, %g1, 164
	ld	%g4, %g1, 156
	ld	%g5, %g1, 8
	st	%g3, %g1, 160
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 164
	subi	%g1, %g1, 168
	call	min_caml_create_array
	addi	%g1, %g1, 168
	ld	%g31, %g1, 164
	fld	%f0, %g1, 76
	ld	%g4, %g1, 12
	st	%g3, %g1, 164
	mov	%g3, %g4
	st	%g31, %g1, 172
	subi	%g1, %g1, 176
	call	min_caml_create_float_array
	addi	%g1, %g1, 176
	ld	%g31, %g1, 172
	fld	%f0, %g1, 76
	ld	%g4, %g1, 88
	st	%g3, %g1, 168
	mov	%g3, %g4
	st	%g31, %g1, 172
	subi	%g1, %g1, 176
	call	min_caml_create_float_array
	addi	%g1, %g1, 176
	ld	%g31, %g1, 172
	fld	%f0, %g1, 76
	ld	%g4, %g1, 88
	st	%g3, %g1, 172
	mov	%g3, %g4
	st	%g31, %g1, 180
	subi	%g1, %g1, 184
	call	min_caml_create_float_array
	addi	%g1, %g1, 184
	ld	%g31, %g1, 180
	fld	%f0, %g1, 76
	ld	%g4, %g1, 88
	st	%g3, %g1, 176
	mov	%g3, %g4
	st	%g31, %g1, 180
	subi	%g1, %g1, 184
	call	min_caml_create_float_array
	addi	%g1, %g1, 184
	ld	%g31, %g1, 180
	fld	%f0, %g1, 76
	ld	%g4, %g1, 88
	st	%g3, %g1, 180
	mov	%g3, %g4
	st	%g31, %g1, 188
	subi	%g1, %g1, 192
	call	min_caml_create_float_array
	addi	%g1, %g1, 192
	ld	%g31, %g1, 188
	fld	%f0, %g1, 76
	ld	%g4, %g1, 88
	st	%g3, %g1, 184
	mov	%g3, %g4
	st	%g31, %g1, 188
	subi	%g1, %g1, 192
	call	min_caml_create_float_array
	addi	%g1, %g1, 192
	ld	%g31, %g1, 188
	fld	%f0, %g1, 76
	ld	%g4, %g1, 88
	st	%g3, %g1, 188
	mov	%g3, %g4
	st	%g31, %g1, 196
	subi	%g1, %g1, 200
	call	min_caml_create_float_array
	addi	%g1, %g1, 200
	ld	%g31, %g1, 196
	fld	%f0, %g1, 76
	ld	%g4, %g1, 8
	st	%g3, %g1, 192
	mov	%g3, %g4
	st	%g31, %g1, 196
	subi	%g1, %g1, 200
	call	min_caml_create_float_array
	addi	%g1, %g1, 200
	ld	%g31, %g1, 196
	mov	%g4, %g3
	ld	%g3, %g1, 8
	st	%g4, %g1, 196
	st	%g31, %g1, 204
	subi	%g1, %g1, 208
	call	min_caml_create_array
	addi	%g1, %g1, 208
	ld	%g31, %g1, 204
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 196
	st	%g3, %g4, 0
	ld	%g3, %g1, 8
	st	%g31, %g1, 204
	subi	%g1, %g1, 208
	call	min_caml_create_array
	addi	%g1, %g1, 208
	ld	%g31, %g1, 204
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 5
	st	%g31, %g1, 204
	subi	%g1, %g1, 208
	call	min_caml_create_array
	addi	%g1, %g1, 208
	ld	%g31, %g1, 204
	fld	%f0, %g1, 76
	ld	%g4, %g1, 8
	st	%g3, %g1, 200
	mov	%g3, %g4
	st	%g31, %g1, 204
	subi	%g1, %g1, 208
	call	min_caml_create_float_array
	addi	%g1, %g1, 208
	ld	%g31, %g1, 204
	fld	%f0, %g1, 76
	ld	%g4, %g1, 88
	st	%g3, %g1, 204
	mov	%g3, %g4
	st	%g31, %g1, 212
	subi	%g1, %g1, 216
	call	min_caml_create_float_array
	addi	%g1, %g1, 216
	ld	%g31, %g1, 212
	ld	%g4, %g1, 80
	ld	%g5, %g1, 204
	st	%g3, %g1, 208
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 212
	subi	%g1, %g1, 216
	call	min_caml_create_array
	addi	%g1, %g1, 216
	ld	%g31, %g1, 212
	fld	%f0, %g1, 76
	ld	%g4, %g1, 8
	st	%g3, %g1, 212
	mov	%g3, %g4
	st	%g31, %g1, 220
	subi	%g1, %g1, 224
	call	min_caml_create_float_array
	addi	%g1, %g1, 224
	ld	%g31, %g1, 220
	mov	%g4, %g3
	ld	%g3, %g1, 8
	st	%g4, %g1, 216
	st	%g31, %g1, 220
	subi	%g1, %g1, 224
	call	min_caml_create_array
	addi	%g1, %g1, 224
	ld	%g31, %g1, 220
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 216
	st	%g3, %g4, 0
	mov	%g3, %g4
	mov	%g4, %g2
	addi	%g2, %g2, 16
	fld	%f0, %g1, 76
	fst	%f0, %g4, -8
	st	%g3, %g4, -4
	ld	%g3, %g1, 8
	st	%g3, %g4, 0
	mvhi	%g5, 0
	mvlo	%g5, 180
	mov	%g3, %g5
	st	%g31, %g1, 220
	subi	%g1, %g1, 224
	call	min_caml_create_array
	addi	%g1, %g1, 224
	ld	%g31, %g1, 220
	ld	%g4, %g1, 12
	ld	%g5, %g1, 8
	st	%g3, %g1, 220
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 228
	subi	%g1, %g1, 232
	call	min_caml_create_array
	addi	%g1, %g1, 232
	ld	%g31, %g1, 228
	setL %g4, l.23911
	fld	%f0, %g4, 0
	setL %g4, l.25138
	fld	%f1, %g4, 0
	mov	%g4, %g2
	addi	%g2, %g2, 80
	setL %g5, read_object.2903
	st	%g5, %g4, 0
	ld	%g5, %g1, 4
	st	%g5, %g4, -76
	ld	%g6, %g1, 24
	st	%g6, %g4, -72
	ld	%g7, %g1, 20
	st	%g7, %g4, -68
	ld	%g8, %g1, 16
	st	%g8, %g4, -64
	ld	%g9, %g1, 52
	st	%g9, %g4, -60
	ld	%g10, %g1, 48
	st	%g10, %g4, -56
	ld	%g11, %g1, 44
	st	%g11, %g4, -52
	ld	%g12, %g1, 28
	st	%g12, %g4, -48
	ld	%g13, %g1, 32
	st	%g13, %g4, -44
	ld	%g14, %g1, 36
	st	%g14, %g4, -40
	fst	%f0, %g4, -32
	fld	%f2, %g1, 0
	fst	%f2, %g4, -24
	fst	%f1, %g4, -16
	ld	%g15, %g1, 84
	st	%g15, %g4, -8
	ld	%g16, %g1, 72
	st	%g16, %g4, -4
	mov	%g17, %g2
	addi	%g2, %g2, 16
	setL %g18, read_net_item.2907
	st	%g18, %g17, 0
	st	%g6, %g17, -12
	st	%g7, %g17, -8
	st	%g8, %g17, -4
	mov	%g18, %g2
	addi	%g2, %g2, 8
	setL %g19, read_or_network.2909
	st	%g19, %g18, 0
	st	%g17, %g18, -4
	mov	%g19, %g2
	addi	%g2, %g2, 16
	setL %g20, read_and_network.2911
	st	%g20, %g19, 0
	st	%g17, %g19, -8
	ld	%g17, %g1, 112
	st	%g17, %g19, -4
	mov	%g20, %g2
	addi	%g2, %g2, 16
	setL %g21, solver.2955
	st	%g21, %g20, 0
	ld	%g21, %g1, 120
	st	%g21, %g20, -8
	st	%g15, %g20, -4
	mov	%g22, %g2
	addi	%g2, %g2, 16
	setL %g23, solver_fast.2978
	st	%g23, %g22, 0
	st	%g21, %g22, -8
	st	%g15, %g22, -4
	mov	%g23, %g2
	addi	%g2, %g2, 8
	setL %g24, iter_setup_dirvec_constants.3008
	st	%g24, %g23, 0
	st	%g15, %g23, -4
	mov	%g24, %g2
	addi	%g2, %g2, 8
	setL %g25, setup_startp_constants.3013
	st	%g25, %g24, 0
	st	%g15, %g24, -4
	mov	%g25, %g2
	addi	%g2, %g2, 8
	setL %g26, check_all_inside.3038
	st	%g26, %g25, 0
	st	%g15, %g25, -4
	mov	%g26, %g2
	addi	%g2, %g2, 8
	ld	%g27, %g1, 212
	st	%g27, %g26, -4
	ld	%g27, %g1, 208
	st	%g27, %g26, 0
	mov	%g28, %g2
	addi	%g2, %g2, 32
	setL %g29, shadow_check_and_group.3044
	st	%g29, %g28, 0
	st	%g22, %g28, -28
	st	%g21, %g28, -24
	st	%g15, %g28, -20
	st	%g26, %g28, -16
	ld	%g29, %g1, 100
	st	%g29, %g28, -12
	ld	%g27, %g1, 132
	st	%g27, %g28, -8
	st	%g25, %g28, -4
	st	%g18, %g1, 224
	mov	%g18, %g2
	addi	%g2, %g2, 16
	st	%g19, %g1, 228
	setL %g19, shadow_check_one_or_group.3047
	st	%g19, %g18, 0
	st	%g28, %g18, -8
	st	%g17, %g18, -4
	mov	%g19, %g2
	addi	%g2, %g2, 24
	setL %g28, shadow_check_one_or_matrix.3050
	st	%g28, %g19, 0
	st	%g22, %g19, -20
	st	%g21, %g19, -16
	st	%g18, %g19, -12
	st	%g26, %g19, -8
	st	%g27, %g19, -4
	mov	%g18, %g2
	addi	%g2, %g2, 40
	setL %g22, solve_each_element.3053
	st	%g22, %g18, 0
	ld	%g22, %g1, 128
	st	%g22, %g18, -36
	ld	%g28, %g1, 172
	st	%g28, %g18, -32
	st	%g21, %g18, -28
	st	%g20, %g18, -24
	st	%g15, %g18, -20
	st	%g26, %g1, 232
	ld	%g26, %g1, 124
	st	%g26, %g18, -16
	st	%g27, %g18, -12
	st	%g4, %g1, 236
	ld	%g4, %g1, 136
	st	%g4, %g18, -8
	st	%g25, %g18, -4
	mov	%g6, %g2
	addi	%g2, %g2, 16
	setL %g7, solve_one_or_network.3057
	st	%g7, %g6, 0
	st	%g18, %g6, -8
	st	%g17, %g6, -4
	mov	%g7, %g2
	addi	%g2, %g2, 24
	setL %g18, trace_or_matrix.3061
	st	%g18, %g7, 0
	st	%g22, %g7, -20
	st	%g28, %g7, -16
	st	%g21, %g7, -12
	st	%g20, %g7, -8
	st	%g6, %g7, -4
	mov	%g6, %g2
	addi	%g2, %g2, 40
	setL %g18, solve_each_element_fast.3067
	st	%g18, %g6, 0
	st	%g22, %g6, -32
	ld	%g18, %g1, 176
	st	%g18, %g6, -28
	st	%g21, %g6, -24
	st	%g15, %g6, -20
	st	%g26, %g6, -16
	st	%g27, %g6, -12
	st	%g4, %g6, -8
	st	%g25, %g6, -4
	mov	%g20, %g2
	addi	%g2, %g2, 16
	setL %g25, solve_one_or_network_fast.3071
	st	%g25, %g20, 0
	st	%g6, %g20, -8
	st	%g17, %g20, -4
	mov	%g6, %g2
	addi	%g2, %g2, 24
	setL %g17, trace_or_matrix_fast.3075
	st	%g17, %g6, 0
	st	%g22, %g6, -16
	st	%g21, %g6, -12
	st	%g20, %g6, -8
	st	%g15, %g6, -4
	mov	%g17, %g2
	addi	%g2, %g2, 40
	setL %g20, utexture.3090
	st	%g20, %g17, 0
	ld	%g20, %g1, 144
	st	%g20, %g17, -36
	st	%g5, %g17, -32
	fst	%f0, %g17, -24
	fst	%f2, %g17, -16
	fst	%f1, %g17, -8
	mov	%g21, %g2
	addi	%g2, %g2, 48
	setL %g25, trace_reflections.3097
	st	%g25, %g21, 0
	st	%g6, %g21, -40
	st	%g22, %g21, -36
	st	%g20, %g21, -32
	st	%g19, %g21, -28
	ld	%g25, %g1, 152
	st	%g25, %g21, -24
	ld	%g8, %g1, 220
	st	%g8, %g21, -20
	ld	%g8, %g1, 116
	st	%g8, %g21, -16
	ld	%g9, %g1, 140
	st	%g9, %g21, -12
	st	%g26, %g21, -8
	st	%g4, %g21, -4
	mov	%g10, %g2
	addi	%g2, %g2, 88
	setL %g11, trace_ray.3102
	st	%g11, %g10, 0
	st	%g17, %g10, -80
	st	%g21, %g10, -76
	st	%g7, %g10, -72
	st	%g22, %g10, -68
	st	%g20, %g10, -64
	st	%g18, %g10, -60
	st	%g28, %g10, -56
	st	%g19, %g10, -52
	st	%g24, %g10, -48
	st	%g25, %g10, -44
	st	%g8, %g10, -40
	st	%g15, %g10, -36
	st	%g9, %g10, -32
	st	%g3, %g10, -28
	st	%g16, %g10, -24
	st	%g29, %g10, -20
	st	%g26, %g10, -16
	st	%g27, %g10, -12
	st	%g4, %g10, -8
	ld	%g7, %g1, 108
	st	%g7, %g10, -4
	mov	%g11, %g2
	addi	%g2, %g2, 56
	setL %g21, iter_trace_diffuse_rays.3111
	st	%g21, %g11, 0
	st	%g17, %g11, -52
	st	%g6, %g11, -48
	st	%g22, %g11, -44
	st	%g20, %g11, -40
	st	%g19, %g11, -36
	st	%g8, %g11, -32
	st	%g15, %g11, -28
	st	%g9, %g11, -24
	st	%g29, %g11, -20
	st	%g26, %g11, -16
	st	%g27, %g11, -12
	st	%g4, %g11, -8
	ld	%g4, %g1, 148
	st	%g4, %g11, -4
	mov	%g6, %g2
	addi	%g2, %g2, 32
	setL %g9, do_without_neighbors.3133
	st	%g9, %g6, 0
	st	%g18, %g6, -28
	st	%g24, %g6, -24
	st	%g25, %g6, -20
	st	%g16, %g6, -16
	st	%g11, %g6, -12
	ld	%g9, %g1, 200
	st	%g9, %g6, -8
	st	%g4, %g6, -4
	mov	%g17, %g2
	addi	%g2, %g2, 16
	setL %g19, try_exploit_neighbors.3149
	st	%g19, %g17, 0
	st	%g25, %g17, -12
	st	%g6, %g17, -8
	st	%g4, %g17, -4
	mov	%g19, %g2
	addi	%g2, %g2, 32
	setL %g20, pretrace_diffuse_rays.3162
	st	%g20, %g19, 0
	st	%g18, %g19, -24
	st	%g24, %g19, -20
	st	%g16, %g19, -16
	st	%g11, %g19, -12
	st	%g9, %g19, -8
	st	%g4, %g19, -4
	mov	%g4, %g2
	addi	%g2, %g2, 40
	setL %g11, pretrace_pixels.3165
	st	%g11, %g4, 0
	ld	%g11, %g1, 96
	st	%g11, %g4, -36
	st	%g10, %g4, -32
	st	%g28, %g4, -28
	ld	%g10, %g1, 180
	st	%g10, %g4, -24
	ld	%g18, %g1, 168
	st	%g18, %g4, -20
	st	%g25, %g4, -16
	ld	%g20, %g1, 192
	st	%g20, %g4, -12
	st	%g19, %g4, -8
	ld	%g19, %g1, 164
	st	%g19, %g4, -4
	mov	%g20, %g2
	addi	%g2, %g2, 40
	setL %g21, scan_pixel.3176
	st	%g21, %g20, 0
	st	%g17, %g20, -32
	st	%g25, %g20, -28
	ld	%g17, %g1, 68
	st	%g17, %g20, -24
	ld	%g21, %g1, 64
	st	%g21, %g20, -20
	ld	%g22, %g1, 60
	st	%g22, %g20, -16
	ld	%g24, %g1, 56
	st	%g24, %g20, -12
	ld	%g25, %g1, 160
	st	%g25, %g20, -8
	st	%g6, %g20, -4
	mov	%g6, %g2
	addi	%g2, %g2, 32
	setL %g26, scan_line.3182
	st	%g26, %g6, 0
	ld	%g26, %g1, 188
	st	%g26, %g6, -28
	ld	%g27, %g1, 184
	st	%g27, %g6, -24
	st	%g20, %g6, -20
	st	%g18, %g6, -16
	st	%g4, %g6, -12
	st	%g25, %g6, -8
	st	%g19, %g6, -4
	mov	%g20, %g2
	addi	%g2, %g2, 40
	setL %g28, adjust_position.3199
	st	%g28, %g20, 0
	st	%g5, %g20, -32
	fst	%f0, %g20, -24
	fst	%f2, %g20, -16
	fst	%f1, %g20, -8
	mov	%g28, %g2
	addi	%g2, %g2, 16
	st	%g6, %g1, 240
	setL %g6, calc_dirvec.3202
	st	%g6, %g28, 0
	st	%g9, %g28, -8
	st	%g20, %g28, -4
	mov	%g6, %g2
	addi	%g2, %g2, 8
	setL %g20, calc_dirvecs.3210
	st	%g20, %g6, 0
	st	%g28, %g6, -4
	mov	%g20, %g2
	addi	%g2, %g2, 8
	setL %g28, calc_dirvec_rows.3215
	st	%g28, %g20, 0
	st	%g6, %g20, -4
	mov	%g6, %g2
	addi	%g2, %g2, 8
	setL %g28, create_dirvec_elements.3221
	st	%g28, %g6, 0
	st	%g16, %g6, -4
	mov	%g28, %g2
	addi	%g2, %g2, 16
	st	%g4, %g1, 244
	setL %g4, create_dirvecs.3224
	st	%g4, %g28, 0
	st	%g16, %g28, -12
	st	%g9, %g28, -8
	st	%g6, %g28, -4
	mov	%g4, %g2
	addi	%g2, %g2, 16
	setL %g6, init_dirvec_constants.3226
	st	%g6, %g4, 0
	st	%g16, %g4, -8
	st	%g23, %g4, -4
	mov	%g6, %g2
	addi	%g2, %g2, 16
	st	%g3, %g1, 248
	setL %g3, init_vecset_constants.3229
	st	%g3, %g6, 0
	st	%g4, %g6, -8
	st	%g9, %g6, -4
	mvhi	%g3, 0
	mvlo	%g3, 128
	st	%g3, %g25, 0
	st	%g3, %g25, -4
	mvhi	%g4, 0
	mvlo	%g4, 64
	st	%g4, %g19, 0
	st	%g4, %g19, -4
	st	%g23, %g1, 252
	st	%g6, %g1, 256
	st	%g20, %g1, 260
	st	%g28, %g1, 264
	fst	%f0, %g1, 268
	fst	%f1, %g1, 272
	st	%g31, %g1, 276
	subi	%g1, %g1, 280
	call	min_caml_float_of_int
	addi	%g1, %g1, 280
	ld	%g31, %g1, 276
	setL %g3, l.25147
	fld	%f1, %g3, 0
	fdiv	%f0, %f1, %f0
	ld	%g3, %g1, 168
	fst	%f0, %g3, 0
	st	%g31, %g1, 276
	subi	%g1, %g1, 280
	call	create_pixel.3190
	addi	%g1, %g1, 280
	ld	%g31, %g1, 276
	mov	%g4, %g3
	ld	%g3, %g1, 160
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 276
	subi	%g1, %g1, 280
	call	min_caml_create_array
	addi	%g1, %g1, 280
	ld	%g31, %g1, 276
	ld	%g4, %g1, 160
	ld	%g5, %g4, 0
	subi	%g5, %g5, 2
	mov	%g4, %g5
	st	%g31, %g1, 276
	subi	%g1, %g1, 280
	call	init_line_elements.3192
	addi	%g1, %g1, 280
	ld	%g31, %g1, 276
	st	%g3, %g1, 276
	st	%g31, %g1, 284
	subi	%g1, %g1, 288
	call	create_pixel.3190
	addi	%g1, %g1, 288
	ld	%g31, %g1, 284
	mov	%g4, %g3
	ld	%g3, %g1, 160
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 284
	subi	%g1, %g1, 288
	call	min_caml_create_array
	addi	%g1, %g1, 288
	ld	%g31, %g1, 284
	ld	%g4, %g1, 160
	ld	%g5, %g4, 0
	subi	%g5, %g5, 2
	mov	%g4, %g5
	st	%g31, %g1, 284
	subi	%g1, %g1, 288
	call	init_line_elements.3192
	addi	%g1, %g1, 288
	ld	%g31, %g1, 284
	st	%g3, %g1, 280
	st	%g31, %g1, 284
	subi	%g1, %g1, 288
	call	create_pixel.3190
	addi	%g1, %g1, 288
	ld	%g31, %g1, 284
	mov	%g4, %g3
	ld	%g3, %g1, 160
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 284
	subi	%g1, %g1, 288
	call	min_caml_create_array
	addi	%g1, %g1, 288
	ld	%g31, %g1, 284
	ld	%g4, %g1, 160
	ld	%g5, %g4, 0
	subi	%g5, %g5, 2
	mov	%g4, %g5
	st	%g31, %g1, 284
	subi	%g1, %g1, 288
	call	init_line_elements.3192
	addi	%g1, %g1, 288
	ld	%g31, %g1, 284
	ld	%g4, %g1, 28
	ld	%g5, %g1, 8
	st	%g5, %g4, 0
	ld	%g6, %g1, 32
	st	%g5, %g6, 0
	ld	%g7, %g1, 36
	ld	%g8, %g1, 12
	st	%g8, %g7, 0
	ld	%g9, %g1, 44
	st	%g5, %g9, 0
	mvhi	%g10, 0
	mvlo	%g10, 32
	ld	%g29, %g1, 48
	st	%g3, %g1, 284
	st	%g10, %g1, 288
	mov	%g4, %g10
	mov	%g3, %g5
	st	%g31, %g1, 292
	ld	%g28, %g29, 0
	subi	%g1, %g1, 296
	callR	%g28
	addi	%g1, %g1, 296
	ld	%g31, %g1, 292
	mvhi	%g4, 0
	mvlo	%g4, 46
	st	%g4, %g1, 292
	jne	%g3, %g4, jeq_else.31930
	ld	%g3, %g1, 8
	ld	%g29, %g1, 52
	st	%g31, %g1, 300
	ld	%g28, %g29, 0
	subi	%g1, %g1, 304
	callR	%g28
	addi	%g1, %g1, 304
	ld	%g31, %g1, 300
	ld	%g3, %g1, 28
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 300
	subi	%g1, %g1, 304
	call	min_caml_float_of_int
	addi	%g1, %g1, 304
	ld	%g31, %g1, 300
	ld	%g3, %g1, 32
	ld	%g4, %g3, 0
	fst	%f0, %g1, 296
	mov	%g3, %g4
	st	%g31, %g1, 300
	subi	%g1, %g1, 304
	call	min_caml_float_of_int
	addi	%g1, %g1, 304
	ld	%g31, %g1, 300
	ld	%g3, %g1, 36
	ld	%g4, %g3, 0
	fst	%f0, %g1, 300
	mov	%g3, %g4
	st	%g31, %g1, 308
	subi	%g1, %g1, 312
	call	min_caml_float_of_int
	addi	%g1, %g1, 312
	ld	%g31, %g1, 308
	fld	%f1, %g1, 300
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 296
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.31931
jeq_else.31930:
	ld	%g3, %g1, 28
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 308
	subi	%g1, %g1, 312
	call	min_caml_float_of_int
	addi	%g1, %g1, 312
	ld	%g31, %g1, 308
jeq_cont.31931:
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	ld	%g5, %g1, 12
	jne	%g4, %g5, jeq_else.31932
	jmp	jeq_cont.31933
jeq_else.31932:
	fneg	%f0, %f0
jeq_cont.31933:
	ld	%g4, %g1, 92
	fst	%f0, %g4, 0
	ld	%g6, %g1, 28
	ld	%g7, %g1, 8
	st	%g7, %g6, 0
	ld	%g8, %g1, 32
	st	%g7, %g8, 0
	ld	%g9, %g1, 36
	st	%g5, %g9, 0
	st	%g7, %g3, 0
	ld	%g10, %g1, 288
	ld	%g29, %g1, 48
	mov	%g4, %g10
	mov	%g3, %g7
	st	%g31, %g1, 308
	ld	%g28, %g29, 0
	subi	%g1, %g1, 312
	callR	%g28
	addi	%g1, %g1, 312
	ld	%g31, %g1, 308
	ld	%g4, %g1, 292
	jne	%g3, %g4, jeq_else.31934
	ld	%g3, %g1, 8
	ld	%g29, %g1, 52
	st	%g31, %g1, 308
	ld	%g28, %g29, 0
	subi	%g1, %g1, 312
	callR	%g28
	addi	%g1, %g1, 312
	ld	%g31, %g1, 308
	ld	%g3, %g1, 28
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 308
	subi	%g1, %g1, 312
	call	min_caml_float_of_int
	addi	%g1, %g1, 312
	ld	%g31, %g1, 308
	ld	%g3, %g1, 32
	ld	%g4, %g3, 0
	fst	%f0, %g1, 304
	mov	%g3, %g4
	st	%g31, %g1, 308
	subi	%g1, %g1, 312
	call	min_caml_float_of_int
	addi	%g1, %g1, 312
	ld	%g31, %g1, 308
	ld	%g3, %g1, 36
	ld	%g4, %g3, 0
	fst	%f0, %g1, 308
	mov	%g3, %g4
	st	%g31, %g1, 316
	subi	%g1, %g1, 320
	call	min_caml_float_of_int
	addi	%g1, %g1, 320
	ld	%g31, %g1, 316
	fld	%f1, %g1, 308
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 304
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.31935
jeq_else.31934:
	ld	%g3, %g1, 28
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 316
	subi	%g1, %g1, 320
	call	min_caml_float_of_int
	addi	%g1, %g1, 320
	ld	%g31, %g1, 316
jeq_cont.31935:
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	ld	%g5, %g1, 12
	jne	%g4, %g5, jeq_else.31936
	jmp	jeq_cont.31937
jeq_else.31936:
	fneg	%f0, %f0
jeq_cont.31937:
	ld	%g4, %g1, 92
	fst	%f0, %g4, -4
	ld	%g6, %g1, 28
	ld	%g7, %g1, 8
	st	%g7, %g6, 0
	ld	%g8, %g1, 32
	st	%g7, %g8, 0
	ld	%g9, %g1, 36
	st	%g5, %g9, 0
	st	%g7, %g3, 0
	ld	%g10, %g1, 288
	ld	%g29, %g1, 48
	mov	%g4, %g10
	mov	%g3, %g7
	st	%g31, %g1, 316
	ld	%g28, %g29, 0
	subi	%g1, %g1, 320
	callR	%g28
	addi	%g1, %g1, 320
	ld	%g31, %g1, 316
	ld	%g4, %g1, 292
	jne	%g3, %g4, jeq_else.31938
	ld	%g3, %g1, 8
	ld	%g29, %g1, 52
	st	%g31, %g1, 316
	ld	%g28, %g29, 0
	subi	%g1, %g1, 320
	callR	%g28
	addi	%g1, %g1, 320
	ld	%g31, %g1, 316
	ld	%g3, %g1, 28
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 316
	subi	%g1, %g1, 320
	call	min_caml_float_of_int
	addi	%g1, %g1, 320
	ld	%g31, %g1, 316
	ld	%g3, %g1, 32
	ld	%g4, %g3, 0
	fst	%f0, %g1, 312
	mov	%g3, %g4
	st	%g31, %g1, 316
	subi	%g1, %g1, 320
	call	min_caml_float_of_int
	addi	%g1, %g1, 320
	ld	%g31, %g1, 316
	ld	%g3, %g1, 36
	ld	%g4, %g3, 0
	fst	%f0, %g1, 316
	mov	%g3, %g4
	st	%g31, %g1, 324
	subi	%g1, %g1, 328
	call	min_caml_float_of_int
	addi	%g1, %g1, 328
	ld	%g31, %g1, 324
	fld	%f1, %g1, 316
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 312
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.31939
jeq_else.31938:
	ld	%g3, %g1, 28
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 324
	subi	%g1, %g1, 328
	call	min_caml_float_of_int
	addi	%g1, %g1, 328
	ld	%g31, %g1, 324
jeq_cont.31939:
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	ld	%g5, %g1, 12
	jne	%g4, %g5, jeq_else.31940
	jmp	jeq_cont.31941
jeq_else.31940:
	fneg	%f0, %f0
jeq_cont.31941:
	ld	%g4, %g1, 92
	fst	%f0, %g4, -8
	ld	%g6, %g1, 28
	ld	%g7, %g1, 8
	st	%g7, %g6, 0
	ld	%g8, %g1, 32
	st	%g7, %g8, 0
	ld	%g9, %g1, 36
	st	%g5, %g9, 0
	st	%g7, %g3, 0
	ld	%g10, %g1, 288
	ld	%g29, %g1, 48
	mov	%g4, %g10
	mov	%g3, %g7
	st	%g31, %g1, 324
	ld	%g28, %g29, 0
	subi	%g1, %g1, 328
	callR	%g28
	addi	%g1, %g1, 328
	ld	%g31, %g1, 324
	ld	%g4, %g1, 292
	jne	%g3, %g4, jeq_else.31942
	ld	%g3, %g1, 8
	ld	%g29, %g1, 52
	st	%g31, %g1, 324
	ld	%g28, %g29, 0
	subi	%g1, %g1, 328
	callR	%g28
	addi	%g1, %g1, 328
	ld	%g31, %g1, 324
	ld	%g3, %g1, 28
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 324
	subi	%g1, %g1, 328
	call	min_caml_float_of_int
	addi	%g1, %g1, 328
	ld	%g31, %g1, 324
	ld	%g3, %g1, 32
	ld	%g4, %g3, 0
	fst	%f0, %g1, 320
	mov	%g3, %g4
	st	%g31, %g1, 324
	subi	%g1, %g1, 328
	call	min_caml_float_of_int
	addi	%g1, %g1, 328
	ld	%g31, %g1, 324
	ld	%g3, %g1, 36
	ld	%g4, %g3, 0
	fst	%f0, %g1, 324
	mov	%g3, %g4
	st	%g31, %g1, 332
	subi	%g1, %g1, 336
	call	min_caml_float_of_int
	addi	%g1, %g1, 336
	ld	%g31, %g1, 332
	fld	%f1, %g1, 324
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 320
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.31943
jeq_else.31942:
	ld	%g3, %g1, 28
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 332
	subi	%g1, %g1, 336
	call	min_caml_float_of_int
	addi	%g1, %g1, 336
	ld	%g31, %g1, 332
jeq_cont.31943:
	ld	%g3, %g1, 28
	ld	%g4, %g1, 8
	st	%g4, %g3, 0
	ld	%g5, %g1, 32
	st	%g4, %g5, 0
	ld	%g6, %g1, 36
	ld	%g7, %g1, 12
	st	%g7, %g6, 0
	ld	%g8, %g1, 44
	st	%g4, %g8, 0
	ld	%g9, %g1, 288
	ld	%g29, %g1, 48
	fst	%f0, %g1, 328
	mov	%g3, %g4
	mov	%g4, %g9
	st	%g31, %g1, 332
	ld	%g28, %g29, 0
	subi	%g1, %g1, 336
	callR	%g28
	addi	%g1, %g1, 336
	ld	%g31, %g1, 332
	ld	%g4, %g1, 292
	jne	%g3, %g4, jeq_else.31944
	ld	%g3, %g1, 8
	ld	%g29, %g1, 52
	st	%g31, %g1, 332
	ld	%g28, %g29, 0
	subi	%g1, %g1, 336
	callR	%g28
	addi	%g1, %g1, 336
	ld	%g31, %g1, 332
	ld	%g3, %g1, 28
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 332
	subi	%g1, %g1, 336
	call	min_caml_float_of_int
	addi	%g1, %g1, 336
	ld	%g31, %g1, 332
	ld	%g3, %g1, 32
	ld	%g4, %g3, 0
	fst	%f0, %g1, 332
	mov	%g3, %g4
	st	%g31, %g1, 340
	subi	%g1, %g1, 344
	call	min_caml_float_of_int
	addi	%g1, %g1, 344
	ld	%g31, %g1, 340
	ld	%g3, %g1, 36
	ld	%g4, %g3, 0
	fst	%f0, %g1, 336
	mov	%g3, %g4
	st	%g31, %g1, 340
	subi	%g1, %g1, 344
	call	min_caml_float_of_int
	addi	%g1, %g1, 344
	ld	%g31, %g1, 340
	fld	%f1, %g1, 336
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 332
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.31945
jeq_else.31944:
	ld	%g3, %g1, 28
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 340
	subi	%g1, %g1, 344
	call	min_caml_float_of_int
	addi	%g1, %g1, 344
	ld	%g31, %g1, 340
jeq_cont.31945:
	setL %g3, l.25231
	fld	%f1, %g3, 0
	setL %g3, l.23075
	fld	%f2, %g3, 0
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	ld	%g5, %g1, 12
	jne	%g4, %g5, jeq_else.31946
	jmp	jeq_cont.31947
jeq_else.31946:
	fneg	%f0, %f0
jeq_cont.31947:
	fmul	%f0, %f0, %f2
	fld	%f3, %g1, 76
	fjlt	%f0, %f3, fjge_else.31948
	fmov	%f4, %f0
	jmp	fjge_cont.31949
fjge_else.31948:
	fneg	%f4, %f0
fjge_cont.31949:
	fld	%f5, %g1, 0
	fst	%f1, %g1, 340
	fst	%f2, %g1, 344
	st	%g4, %g1, 348
	fst	%f0, %g1, 352
	fjlt	%f5, %f4, fjge_else.31950
	fjlt	%f4, %f3, fjge_else.31952
	fmov	%f0, %f4
	jmp	fjge_cont.31953
fjge_else.31952:
	fadd	%f4, %f4, %f5
	ld	%g29, %g1, 4
	fmov	%f0, %f4
	st	%g31, %g1, 356
	ld	%g28, %g29, 0
	subi	%g1, %g1, 360
	callR	%g28
	addi	%g1, %g1, 360
	ld	%g31, %g1, 356
fjge_cont.31953:
	jmp	fjge_cont.31951
fjge_else.31950:
	fsub	%f4, %f4, %f5
	ld	%g29, %g1, 4
	fmov	%f0, %f4
	st	%g31, %g1, 356
	ld	%g28, %g29, 0
	subi	%g1, %g1, 360
	callR	%g28
	addi	%g1, %g1, 360
	ld	%g31, %g1, 356
fjge_cont.31951:
	fld	%f1, %g1, 76
	fld	%f2, %g1, 352
	fjlt	%f1, %f2, fjge_else.31954
	ld	%g3, %g1, 8
	jmp	fjge_cont.31955
fjge_else.31954:
	ld	%g3, %g1, 12
fjge_cont.31955:
	fld	%f3, %g1, 272
	fjlt	%f3, %f0, fjge_else.31956
	jmp	fjge_cont.31957
fjge_else.31956:
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.31958
	ld	%g3, %g1, 12
	jmp	jeq_cont.31959
jeq_else.31958:
	mov	%g3, %g4
jeq_cont.31959:
fjge_cont.31957:
	setL %g4, l.22819
	fld	%f4, %g4, 0
	fjlt	%f3, %f0, fjge_else.31960
	jmp	fjge_cont.31961
fjge_else.31960:
	fld	%f5, %g1, 0
	fsub	%f0, %f5, %f0
fjge_cont.31961:
	fld	%f5, %g1, 268
	fjlt	%f5, %f0, fjge_else.31962
	jmp	fjge_cont.31963
fjge_else.31962:
	fsub	%f0, %f3, %f0
fjge_cont.31963:
	setL %g4, l.22815
	fld	%f6, %g4, 0
	fmul	%f0, %f0, %f6
	fmul	%f7, %f0, %f0
	setL %g4, l.23159
	fld	%f8, %g4, 0
	fdiv	%f9, %f7, %f8
	setL %g4, l.23163
	fld	%f10, %g4, 0
	fsub	%f9, %f10, %f9
	fdiv	%f9, %f7, %f9
	setL %g4, l.23165
	fld	%f11, %g4, 0
	fsub	%f9, %f11, %f9
	fdiv	%f9, %f7, %f9
	setL %g4, l.23167
	fld	%f12, %g4, 0
	fst	%f12, %g1, 356
	fst	%f11, %g1, 360
	fst	%f10, %g1, 364
	fst	%f8, %g1, 368
	fst	%f6, %g1, 372
	st	%g3, %g1, 376
	fst	%f0, %g1, 380
	fst	%f4, %g1, 384
	fmov	%f2, %f9
	fmov	%f1, %f7
	fmov	%f0, %f12
	st	%g31, %g1, 388
	subi	%g1, %g1, 392
	call	tan_sub.6499.6594.6711.10203.19527.20780
	addi	%g1, %g1, 392
	ld	%g31, %g1, 388
	fld	%f1, %g1, 384
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 380
	fdiv	%f0, %f2, %f0
	fmul	%f2, %f0, %f0
	fadd	%f2, %f1, %f2
	setL %g3, l.22817
	fld	%f3, %g3, 0
	fmul	%f0, %f3, %f0
	fdiv	%f0, %f0, %f2
	ld	%g3, %g1, 8
	ld	%g4, %g1, 376
	jne	%g4, %g3, jeq_else.31964
	fneg	%f0, %f0
	jmp	jeq_cont.31965
jeq_else.31964:
jeq_cont.31965:
	ld	%g4, %g1, 12
	ld	%g5, %g1, 348
	jne	%g5, %g4, jeq_else.31966
	fld	%f2, %g1, 328
	jmp	jeq_cont.31967
jeq_else.31966:
	fld	%f2, %g1, 328
	fneg	%f2, %f2
jeq_cont.31967:
	fld	%f4, %g1, 344
	fmul	%f2, %f2, %f4
	setL %g5, l.23155
	fld	%f5, %g5, 0
	fsub	%f6, %f5, %f2
	fld	%f7, %g1, 76
	fjlt	%f6, %f7, fjge_else.31968
	fmov	%f8, %f6
	jmp	fjge_cont.31969
fjge_else.31968:
	fneg	%f8, %f6
fjge_cont.31969:
	fld	%f9, %g1, 0
	fst	%f5, %g1, 388
	fst	%f2, %g1, 392
	fst	%f0, %g1, 396
	fst	%f3, %g1, 400
	fst	%f6, %g1, 404
	fjlt	%f9, %f8, fjge_else.31970
	fjlt	%f8, %f7, fjge_else.31972
	fmov	%f0, %f8
	jmp	fjge_cont.31973
fjge_else.31972:
	fadd	%f8, %f8, %f9
	ld	%g29, %g1, 4
	fmov	%f0, %f8
	st	%g31, %g1, 412
	ld	%g28, %g29, 0
	subi	%g1, %g1, 416
	callR	%g28
	addi	%g1, %g1, 416
	ld	%g31, %g1, 412
fjge_cont.31973:
	jmp	fjge_cont.31971
fjge_else.31970:
	fsub	%f8, %f8, %f9
	ld	%g29, %g1, 4
	fmov	%f0, %f8
	st	%g31, %g1, 412
	ld	%g28, %g29, 0
	subi	%g1, %g1, 416
	callR	%g28
	addi	%g1, %g1, 416
	ld	%g31, %g1, 412
fjge_cont.31971:
	fld	%f1, %g1, 76
	fld	%f2, %g1, 404
	fjlt	%f1, %f2, fjge_else.31974
	ld	%g3, %g1, 8
	jmp	fjge_cont.31975
fjge_else.31974:
	ld	%g3, %g1, 12
fjge_cont.31975:
	fld	%f2, %g1, 272
	fjlt	%f2, %f0, fjge_else.31976
	jmp	fjge_cont.31977
fjge_else.31976:
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.31978
	ld	%g3, %g1, 12
	jmp	jeq_cont.31979
jeq_else.31978:
	mov	%g3, %g4
jeq_cont.31979:
fjge_cont.31977:
	fjlt	%f2, %f0, fjge_else.31980
	jmp	fjge_cont.31981
fjge_else.31980:
	fld	%f3, %g1, 0
	fsub	%f0, %f3, %f0
fjge_cont.31981:
	fld	%f3, %g1, 268
	fjlt	%f3, %f0, fjge_else.31982
	jmp	fjge_cont.31983
fjge_else.31982:
	fsub	%f0, %f2, %f0
fjge_cont.31983:
	fld	%f4, %g1, 372
	fmul	%f0, %f0, %f4
	fmul	%f5, %f0, %f0
	fld	%f6, %g1, 368
	fdiv	%f7, %f5, %f6
	fld	%f8, %g1, 364
	fsub	%f7, %f8, %f7
	fdiv	%f7, %f5, %f7
	fld	%f9, %g1, 360
	fsub	%f7, %f9, %f7
	fdiv	%f7, %f5, %f7
	fld	%f10, %g1, 356
	st	%g3, %g1, 408
	fst	%f0, %g1, 412
	fmov	%f2, %f7
	fmov	%f1, %f5
	fmov	%f0, %f10
	st	%g31, %g1, 420
	subi	%g1, %g1, 424
	call	tan_sub.6499.6594.6640.6891.10383.19707.20960
	addi	%g1, %g1, 424
	ld	%g31, %g1, 420
	fld	%f1, %g1, 384
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 412
	fdiv	%f0, %f2, %f0
	fmul	%f2, %f0, %f0
	fadd	%f2, %f1, %f2
	fld	%f3, %g1, 400
	fmul	%f0, %f3, %f0
	fdiv	%f0, %f0, %f2
	ld	%g3, %g1, 8
	ld	%g4, %g1, 408
	jne	%g4, %g3, jeq_else.31984
	fneg	%f0, %f0
	jmp	jeq_cont.31985
jeq_else.31984:
jeq_cont.31985:
	fld	%f2, %g1, 396
	fmul	%f4, %f0, %f2
	fld	%f5, %g1, 340
	fmul	%f4, %f4, %f5
	ld	%g4, %g1, 188
	fst	%f4, %g4, 0
	fld	%f4, %g1, 392
	fld	%f6, %g1, 76
	fjlt	%f4, %f6, fjge_else.31986
	fmov	%f7, %f4
	jmp	fjge_cont.31987
fjge_else.31986:
	fneg	%f7, %f4
fjge_cont.31987:
	fld	%f8, %g1, 0
	fst	%f0, %g1, 416
	fjlt	%f8, %f7, fjge_else.31988
	fjlt	%f7, %f6, fjge_else.31990
	fmov	%f0, %f7
	jmp	fjge_cont.31991
fjge_else.31990:
	fadd	%f7, %f7, %f8
	ld	%g29, %g1, 4
	fmov	%f0, %f7
	st	%g31, %g1, 420
	ld	%g28, %g29, 0
	subi	%g1, %g1, 424
	callR	%g28
	addi	%g1, %g1, 424
	ld	%g31, %g1, 420
fjge_cont.31991:
	jmp	fjge_cont.31989
fjge_else.31988:
	fsub	%f7, %f7, %f8
	ld	%g29, %g1, 4
	fmov	%f0, %f7
	st	%g31, %g1, 420
	ld	%g28, %g29, 0
	subi	%g1, %g1, 424
	callR	%g28
	addi	%g1, %g1, 424
	ld	%g31, %g1, 420
fjge_cont.31989:
	fld	%f1, %g1, 76
	fld	%f2, %g1, 392
	fjlt	%f1, %f2, fjge_else.31992
	ld	%g3, %g1, 8
	jmp	fjge_cont.31993
fjge_else.31992:
	ld	%g3, %g1, 12
fjge_cont.31993:
	fld	%f2, %g1, 272
	fjlt	%f2, %f0, fjge_else.31994
	jmp	fjge_cont.31995
fjge_else.31994:
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.31996
	ld	%g3, %g1, 12
	jmp	jeq_cont.31997
jeq_else.31996:
	mov	%g3, %g4
jeq_cont.31997:
fjge_cont.31995:
	fjlt	%f2, %f0, fjge_else.31998
	jmp	fjge_cont.31999
fjge_else.31998:
	fld	%f3, %g1, 0
	fsub	%f0, %f3, %f0
fjge_cont.31999:
	fld	%f3, %g1, 268
	fjlt	%f3, %f0, fjge_else.32000
	jmp	fjge_cont.32001
fjge_else.32000:
	fsub	%f0, %f2, %f0
fjge_cont.32001:
	fld	%f4, %g1, 372
	fmul	%f0, %f0, %f4
	fmul	%f5, %f0, %f0
	fld	%f6, %g1, 368
	fdiv	%f7, %f5, %f6
	fld	%f8, %g1, 364
	fsub	%f7, %f8, %f7
	fdiv	%f7, %f5, %f7
	fld	%f9, %g1, 360
	fsub	%f7, %f9, %f7
	fdiv	%f7, %f5, %f7
	fld	%f10, %g1, 356
	st	%g3, %g1, 420
	fst	%f0, %g1, 424
	fmov	%f2, %f7
	fmov	%f1, %f5
	fmov	%f0, %f10
	st	%g31, %g1, 428
	subi	%g1, %g1, 432
	call	tan_sub.6499.6594.6842.10334.19658.20911
	addi	%g1, %g1, 432
	ld	%g31, %g1, 428
	fld	%f1, %g1, 384
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 424
	fdiv	%f0, %f2, %f0
	fmul	%f2, %f0, %f0
	fadd	%f2, %f1, %f2
	fld	%f3, %g1, 400
	fmul	%f0, %f3, %f0
	fdiv	%f0, %f0, %f2
	ld	%g3, %g1, 8
	ld	%g4, %g1, 420
	jne	%g4, %g3, jeq_else.32002
	fneg	%f0, %f0
	jmp	jeq_cont.32003
jeq_else.32002:
jeq_cont.32003:
	setL %g4, l.25245
	fld	%f2, %g4, 0
	fmul	%f2, %f0, %f2
	ld	%g4, %g1, 188
	fst	%f2, %g4, -4
	fld	%f2, %g1, 352
	fld	%f4, %g1, 388
	fsub	%f2, %f4, %f2
	fld	%f5, %g1, 76
	fjlt	%f2, %f5, fjge_else.32004
	fmov	%f6, %f2
	jmp	fjge_cont.32005
fjge_else.32004:
	fneg	%f6, %f2
fjge_cont.32005:
	fld	%f7, %g1, 0
	fst	%f0, %g1, 428
	fst	%f2, %g1, 432
	fjlt	%f7, %f6, fjge_else.32006
	fjlt	%f6, %f5, fjge_else.32008
	fmov	%f0, %f6
	jmp	fjge_cont.32009
fjge_else.32008:
	fadd	%f6, %f6, %f7
	ld	%g29, %g1, 4
	fmov	%f0, %f6
	st	%g31, %g1, 436
	ld	%g28, %g29, 0
	subi	%g1, %g1, 440
	callR	%g28
	addi	%g1, %g1, 440
	ld	%g31, %g1, 436
fjge_cont.32009:
	jmp	fjge_cont.32007
fjge_else.32006:
	fsub	%f6, %f6, %f7
	ld	%g29, %g1, 4
	fmov	%f0, %f6
	st	%g31, %g1, 436
	ld	%g28, %g29, 0
	subi	%g1, %g1, 440
	callR	%g28
	addi	%g1, %g1, 440
	ld	%g31, %g1, 436
fjge_cont.32007:
	fld	%f1, %g1, 76
	fld	%f2, %g1, 432
	fjlt	%f1, %f2, fjge_else.32010
	ld	%g3, %g1, 8
	jmp	fjge_cont.32011
fjge_else.32010:
	ld	%g3, %g1, 12
fjge_cont.32011:
	fld	%f2, %g1, 272
	fjlt	%f2, %f0, fjge_else.32012
	jmp	fjge_cont.32013
fjge_else.32012:
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.32014
	ld	%g3, %g1, 12
	jmp	jeq_cont.32015
jeq_else.32014:
	mov	%g3, %g4
jeq_cont.32015:
fjge_cont.32013:
	fjlt	%f2, %f0, fjge_else.32016
	jmp	fjge_cont.32017
fjge_else.32016:
	fld	%f3, %g1, 0
	fsub	%f0, %f3, %f0
fjge_cont.32017:
	fld	%f3, %g1, 268
	fjlt	%f3, %f0, fjge_else.32018
	jmp	fjge_cont.32019
fjge_else.32018:
	fsub	%f0, %f2, %f0
fjge_cont.32019:
	fld	%f4, %g1, 372
	fmul	%f0, %f0, %f4
	fmul	%f5, %f0, %f0
	fld	%f6, %g1, 368
	fdiv	%f7, %f5, %f6
	fld	%f8, %g1, 364
	fsub	%f7, %f8, %f7
	fdiv	%f7, %f5, %f7
	fld	%f9, %g1, 360
	fsub	%f7, %f9, %f7
	fdiv	%f7, %f5, %f7
	fld	%f10, %g1, 356
	st	%g3, %g1, 436
	fst	%f0, %g1, 440
	fmov	%f2, %f7
	fmov	%f1, %f5
	fmov	%f0, %f10
	st	%g31, %g1, 444
	subi	%g1, %g1, 448
	call	tan_sub.6499.6594.6640.6760.10252.19576.20829
	addi	%g1, %g1, 448
	ld	%g31, %g1, 444
	fld	%f1, %g1, 384
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 440
	fdiv	%f0, %f2, %f0
	fmul	%f2, %f0, %f0
	fadd	%f2, %f1, %f2
	fld	%f3, %g1, 400
	fmul	%f0, %f3, %f0
	fdiv	%f0, %f0, %f2
	ld	%g3, %g1, 8
	ld	%g4, %g1, 436
	jne	%g4, %g3, jeq_else.32020
	fneg	%f0, %f0
	jmp	jeq_cont.32021
jeq_else.32020:
jeq_cont.32021:
	fld	%f2, %g1, 416
	fmul	%f4, %f2, %f0
	fld	%f5, %g1, 340
	fmul	%f4, %f4, %f5
	ld	%g4, %g1, 188
	fst	%f4, %g4, -8
	ld	%g5, %g1, 180
	fst	%f0, %g5, 0
	fld	%f4, %g1, 76
	fst	%f4, %g5, -4
	fld	%f5, %g1, 396
	fneg	%f6, %f5
	fst	%f6, %g5, -8
	fld	%f6, %g1, 428
	fneg	%f6, %f6
	fmul	%f5, %f6, %f5
	ld	%g5, %g1, 184
	fst	%f5, %g5, 0
	fneg	%f2, %f2
	fst	%f2, %g5, -4
	fmul	%f0, %f6, %f0
	fst	%f0, %g5, -8
	fld	%f0, %g4, 0
	ld	%g6, %g1, 92
	fld	%f2, %g6, 0
	fsub	%f0, %f2, %f0
	ld	%g7, %g1, 96
	fst	%f0, %g7, 0
	fld	%f0, %g4, -4
	fld	%f2, %g6, -4
	fsub	%f0, %f2, %f0
	fst	%f0, %g7, -4
	fld	%f0, %g4, -8
	fld	%f2, %g6, -8
	fsub	%f0, %f2, %f0
	fst	%f0, %g7, -8
	ld	%g6, %g1, 16
	st	%g3, %g6, 0
	ld	%g6, %g1, 20
	st	%g3, %g6, 0
	ld	%g6, %g1, 288
	ld	%g29, %g1, 24
	mov	%g4, %g6
	st	%g31, %g1, 444
	ld	%g28, %g29, 0
	subi	%g1, %g1, 448
	callR	%g28
	addi	%g1, %g1, 448
	ld	%g31, %g1, 444
	ld	%g3, %g1, 28
	ld	%g4, %g1, 8
	st	%g4, %g3, 0
	ld	%g5, %g1, 32
	st	%g4, %g5, 0
	ld	%g6, %g1, 36
	ld	%g7, %g1, 12
	st	%g7, %g6, 0
	ld	%g8, %g1, 44
	st	%g4, %g8, 0
	ld	%g9, %g1, 288
	ld	%g29, %g1, 48
	mov	%g3, %g4
	mov	%g4, %g9
	st	%g31, %g1, 444
	ld	%g28, %g29, 0
	subi	%g1, %g1, 448
	callR	%g28
	addi	%g1, %g1, 448
	ld	%g31, %g1, 444
	ld	%g4, %g1, 292
	jne	%g3, %g4, jeq_else.32022
	ld	%g3, %g1, 8
	ld	%g29, %g1, 52
	st	%g31, %g1, 444
	ld	%g28, %g29, 0
	subi	%g1, %g1, 448
	callR	%g28
	addi	%g1, %g1, 448
	ld	%g31, %g1, 444
	ld	%g3, %g1, 28
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 444
	subi	%g1, %g1, 448
	call	min_caml_float_of_int
	addi	%g1, %g1, 448
	ld	%g31, %g1, 444
	ld	%g3, %g1, 32
	ld	%g4, %g3, 0
	fst	%f0, %g1, 444
	mov	%g3, %g4
	st	%g31, %g1, 452
	subi	%g1, %g1, 456
	call	min_caml_float_of_int
	addi	%g1, %g1, 456
	ld	%g31, %g1, 452
	ld	%g3, %g1, 36
	ld	%g4, %g3, 0
	fst	%f0, %g1, 448
	mov	%g3, %g4
	st	%g31, %g1, 452
	subi	%g1, %g1, 456
	call	min_caml_float_of_int
	addi	%g1, %g1, 456
	ld	%g31, %g1, 452
	fld	%f1, %g1, 448
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 444
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.32023
jeq_else.32022:
	ld	%g3, %g1, 28
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 452
	subi	%g1, %g1, 456
	call	min_caml_float_of_int
	addi	%g1, %g1, 456
	ld	%g31, %g1, 452
jeq_cont.32023:
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	ld	%g5, %g1, 12
	jne	%g4, %g5, jeq_else.32024
	jmp	jeq_cont.32025
jeq_else.32024:
	fneg	%f0, %f0
jeq_cont.32025:
	fld	%f1, %g1, 344
	fmul	%f0, %f0, %f1
	fld	%f2, %g1, 76
	fjlt	%f0, %f2, fjge_else.32026
	fmov	%f3, %f0
	jmp	fjge_cont.32027
fjge_else.32026:
	fneg	%f3, %f0
fjge_cont.32027:
	fld	%f4, %g1, 0
	fst	%f0, %g1, 452
	fjlt	%f4, %f3, fjge_else.32028
	fjlt	%f3, %f2, fjge_else.32030
	fmov	%f0, %f3
	jmp	fjge_cont.32031
fjge_else.32030:
	fadd	%f3, %f3, %f4
	ld	%g29, %g1, 4
	fmov	%f0, %f3
	st	%g31, %g1, 460
	ld	%g28, %g29, 0
	subi	%g1, %g1, 464
	callR	%g28
	addi	%g1, %g1, 464
	ld	%g31, %g1, 460
fjge_cont.32031:
	jmp	fjge_cont.32029
fjge_else.32028:
	fsub	%f3, %f3, %f4
	ld	%g29, %g1, 4
	fmov	%f0, %f3
	st	%g31, %g1, 460
	ld	%g28, %g29, 0
	subi	%g1, %g1, 464
	callR	%g28
	addi	%g1, %g1, 464
	ld	%g31, %g1, 460
fjge_cont.32029:
	fld	%f1, %g1, 76
	fld	%f2, %g1, 452
	fjlt	%f1, %f2, fjge_else.32032
	ld	%g3, %g1, 8
	jmp	fjge_cont.32033
fjge_else.32032:
	ld	%g3, %g1, 12
fjge_cont.32033:
	fld	%f3, %g1, 272
	fjlt	%f3, %f0, fjge_else.32034
	jmp	fjge_cont.32035
fjge_else.32034:
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.32036
	ld	%g3, %g1, 12
	jmp	jeq_cont.32037
jeq_else.32036:
	mov	%g3, %g4
jeq_cont.32037:
fjge_cont.32035:
	fjlt	%f3, %f0, fjge_else.32038
	jmp	fjge_cont.32039
fjge_else.32038:
	fld	%f4, %g1, 0
	fsub	%f0, %f4, %f0
fjge_cont.32039:
	fld	%f4, %g1, 268
	fjlt	%f4, %f0, fjge_else.32040
	jmp	fjge_cont.32041
fjge_else.32040:
	fsub	%f0, %f3, %f0
fjge_cont.32041:
	fld	%f5, %g1, 372
	fmul	%f0, %f0, %f5
	fmul	%f6, %f0, %f0
	fld	%f7, %g1, 368
	fdiv	%f8, %f6, %f7
	fld	%f9, %g1, 364
	fsub	%f8, %f9, %f8
	fdiv	%f8, %f6, %f8
	fld	%f10, %g1, 360
	fsub	%f8, %f10, %f8
	fdiv	%f8, %f6, %f8
	fld	%f11, %g1, 356
	st	%g3, %g1, 456
	fst	%f0, %g1, 460
	fmov	%f2, %f8
	fmov	%f1, %f6
	fmov	%f0, %f11
	st	%g31, %g1, 468
	subi	%g1, %g1, 472
	call	tan_sub.6499.6594.7289.10038.19362.20615
	addi	%g1, %g1, 472
	ld	%g31, %g1, 468
	fld	%f1, %g1, 384
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 460
	fdiv	%f0, %f2, %f0
	fmul	%f2, %f0, %f0
	fadd	%f2, %f1, %f2
	fld	%f3, %g1, 400
	fmul	%f0, %f3, %f0
	fdiv	%f0, %f0, %f2
	ld	%g3, %g1, 8
	ld	%g4, %g1, 456
	jne	%g4, %g3, jeq_else.32042
	fneg	%f0, %f0
	jmp	jeq_cont.32043
jeq_else.32042:
jeq_cont.32043:
	fneg	%f0, %f0
	ld	%g4, %g1, 100
	fst	%f0, %g4, -4
	ld	%g5, %g1, 28
	st	%g3, %g5, 0
	ld	%g6, %g1, 32
	st	%g3, %g6, 0
	ld	%g7, %g1, 36
	ld	%g8, %g1, 12
	st	%g8, %g7, 0
	ld	%g9, %g1, 44
	st	%g3, %g9, 0
	ld	%g10, %g1, 288
	ld	%g29, %g1, 48
	mov	%g4, %g10
	st	%g31, %g1, 468
	ld	%g28, %g29, 0
	subi	%g1, %g1, 472
	callR	%g28
	addi	%g1, %g1, 472
	ld	%g31, %g1, 468
	ld	%g4, %g1, 292
	jne	%g3, %g4, jeq_else.32044
	ld	%g3, %g1, 8
	ld	%g29, %g1, 52
	st	%g31, %g1, 468
	ld	%g28, %g29, 0
	subi	%g1, %g1, 472
	callR	%g28
	addi	%g1, %g1, 472
	ld	%g31, %g1, 468
	ld	%g3, %g1, 28
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 468
	subi	%g1, %g1, 472
	call	min_caml_float_of_int
	addi	%g1, %g1, 472
	ld	%g31, %g1, 468
	ld	%g3, %g1, 32
	ld	%g4, %g3, 0
	fst	%f0, %g1, 464
	mov	%g3, %g4
	st	%g31, %g1, 468
	subi	%g1, %g1, 472
	call	min_caml_float_of_int
	addi	%g1, %g1, 472
	ld	%g31, %g1, 468
	ld	%g3, %g1, 36
	ld	%g4, %g3, 0
	fst	%f0, %g1, 468
	mov	%g3, %g4
	st	%g31, %g1, 476
	subi	%g1, %g1, 480
	call	min_caml_float_of_int
	addi	%g1, %g1, 480
	ld	%g31, %g1, 476
	fld	%f1, %g1, 468
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 464
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.32045
jeq_else.32044:
	ld	%g3, %g1, 28
	ld	%g5, %g3, 0
	mov	%g3, %g5
	st	%g31, %g1, 476
	subi	%g1, %g1, 480
	call	min_caml_float_of_int
	addi	%g1, %g1, 480
	ld	%g31, %g1, 476
jeq_cont.32045:
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	ld	%g5, %g1, 12
	jne	%g4, %g5, jeq_else.32046
	jmp	jeq_cont.32047
jeq_else.32046:
	fneg	%f0, %f0
jeq_cont.32047:
	fld	%f1, %g1, 344
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 76
	fjlt	%f0, %f1, fjge_else.32048
	fmov	%f2, %f0
	jmp	fjge_cont.32049
fjge_else.32048:
	fneg	%f2, %f0
fjge_cont.32049:
	fld	%f3, %g1, 0
	fst	%f0, %g1, 472
	fjlt	%f3, %f2, fjge_else.32050
	fjlt	%f2, %f1, fjge_else.32052
	fmov	%f0, %f2
	jmp	fjge_cont.32053
fjge_else.32052:
	fadd	%f2, %f2, %f3
	ld	%g29, %g1, 4
	fmov	%f0, %f2
	st	%g31, %g1, 476
	ld	%g28, %g29, 0
	subi	%g1, %g1, 480
	callR	%g28
	addi	%g1, %g1, 480
	ld	%g31, %g1, 476
fjge_cont.32053:
	jmp	fjge_cont.32051
fjge_else.32050:
	fsub	%f2, %f2, %f3
	ld	%g29, %g1, 4
	fmov	%f0, %f2
	st	%g31, %g1, 476
	ld	%g28, %g29, 0
	subi	%g1, %g1, 480
	callR	%g28
	addi	%g1, %g1, 480
	ld	%g31, %g1, 476
fjge_cont.32051:
	fld	%f1, %g1, 76
	fld	%f2, %g1, 472
	fjlt	%f1, %f2, fjge_else.32054
	ld	%g3, %g1, 8
	jmp	fjge_cont.32055
fjge_else.32054:
	ld	%g3, %g1, 12
fjge_cont.32055:
	fld	%f3, %g1, 272
	fjlt	%f3, %f0, fjge_else.32056
	jmp	fjge_cont.32057
fjge_else.32056:
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.32058
	ld	%g3, %g1, 12
	jmp	jeq_cont.32059
jeq_else.32058:
	mov	%g3, %g4
jeq_cont.32059:
fjge_cont.32057:
	fjlt	%f3, %f0, fjge_else.32060
	jmp	fjge_cont.32061
fjge_else.32060:
	fld	%f4, %g1, 0
	fsub	%f0, %f4, %f0
fjge_cont.32061:
	fld	%f4, %g1, 268
	fjlt	%f4, %f0, fjge_else.32062
	jmp	fjge_cont.32063
fjge_else.32062:
	fsub	%f0, %f3, %f0
fjge_cont.32063:
	fld	%f5, %g1, 372
	fmul	%f0, %f0, %f5
	fmul	%f6, %f0, %f0
	fld	%f7, %g1, 368
	fdiv	%f8, %f6, %f7
	fld	%f9, %g1, 364
	fsub	%f8, %f9, %f8
	fdiv	%f8, %f6, %f8
	fld	%f10, %g1, 360
	fsub	%f8, %f10, %f8
	fdiv	%f8, %f6, %f8
	fld	%f11, %g1, 356
	st	%g3, %g1, 476
	fst	%f0, %g1, 480
	fmov	%f2, %f8
	fmov	%f1, %f6
	fmov	%f0, %f11
	st	%g31, %g1, 484
	subi	%g1, %g1, 488
	call	tan_sub.6499.6594.7158.9907.19231.20484
	addi	%g1, %g1, 488
	ld	%g31, %g1, 484
	fld	%f1, %g1, 384
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 480
	fdiv	%f0, %f2, %f0
	fmul	%f2, %f0, %f0
	fadd	%f2, %f1, %f2
	fld	%f3, %g1, 400
	fmul	%f0, %f3, %f0
	fdiv	%f0, %f0, %f2
	ld	%g3, %g1, 8
	ld	%g4, %g1, 476
	jne	%g4, %g3, jeq_else.32064
	fneg	%f0, %f0
	jmp	jeq_cont.32065
jeq_else.32064:
jeq_cont.32065:
	fld	%f2, %g1, 452
	fld	%f4, %g1, 388
	fsub	%f2, %f4, %f2
	fld	%f5, %g1, 76
	fjlt	%f2, %f5, fjge_else.32066
	fmov	%f6, %f2
	jmp	fjge_cont.32067
fjge_else.32066:
	fneg	%f6, %f2
fjge_cont.32067:
	fld	%f7, %g1, 0
	fst	%f0, %g1, 484
	fst	%f2, %g1, 488
	fjlt	%f7, %f6, fjge_else.32068
	fjlt	%f6, %f5, fjge_else.32070
	fmov	%f0, %f6
	jmp	fjge_cont.32071
fjge_else.32070:
	fadd	%f6, %f6, %f7
	ld	%g29, %g1, 4
	fmov	%f0, %f6
	st	%g31, %g1, 492
	ld	%g28, %g29, 0
	subi	%g1, %g1, 496
	callR	%g28
	addi	%g1, %g1, 496
	ld	%g31, %g1, 492
fjge_cont.32071:
	jmp	fjge_cont.32069
fjge_else.32068:
	fsub	%f6, %f6, %f7
	ld	%g29, %g1, 4
	fmov	%f0, %f6
	st	%g31, %g1, 492
	ld	%g28, %g29, 0
	subi	%g1, %g1, 496
	callR	%g28
	addi	%g1, %g1, 496
	ld	%g31, %g1, 492
fjge_cont.32069:
	fld	%f1, %g1, 76
	fld	%f2, %g1, 488
	fjlt	%f1, %f2, fjge_else.32072
	ld	%g3, %g1, 8
	jmp	fjge_cont.32073
fjge_else.32072:
	ld	%g3, %g1, 12
fjge_cont.32073:
	fld	%f2, %g1, 272
	fjlt	%f2, %f0, fjge_else.32074
	jmp	fjge_cont.32075
fjge_else.32074:
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.32076
	ld	%g3, %g1, 12
	jmp	jeq_cont.32077
jeq_else.32076:
	mov	%g3, %g4
jeq_cont.32077:
fjge_cont.32075:
	fjlt	%f2, %f0, fjge_else.32078
	jmp	fjge_cont.32079
fjge_else.32078:
	fld	%f3, %g1, 0
	fsub	%f0, %f3, %f0
fjge_cont.32079:
	fld	%f3, %g1, 268
	fjlt	%f3, %f0, fjge_else.32080
	jmp	fjge_cont.32081
fjge_else.32080:
	fsub	%f0, %f2, %f0
fjge_cont.32081:
	fld	%f4, %g1, 372
	fmul	%f0, %f0, %f4
	fmul	%f5, %f0, %f0
	fld	%f6, %g1, 368
	fdiv	%f7, %f5, %f6
	fld	%f8, %g1, 364
	fsub	%f7, %f8, %f7
	fdiv	%f7, %f5, %f7
	fld	%f9, %g1, 360
	fsub	%f7, %f9, %f7
	fdiv	%f7, %f5, %f7
	fld	%f10, %g1, 356
	st	%g3, %g1, 492
	fst	%f0, %g1, 496
	fmov	%f2, %f7
	fmov	%f1, %f5
	fmov	%f0, %f10
	st	%g31, %g1, 500
	subi	%g1, %g1, 504
	call	tan_sub.6499.6594.6640.7207.9956.19280.20533
	addi	%g1, %g1, 504
	ld	%g31, %g1, 500
	fld	%f1, %g1, 384
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 496
	fdiv	%f0, %f2, %f0
	fmul	%f2, %f0, %f0
	fadd	%f2, %f1, %f2
	fld	%f3, %g1, 400
	fmul	%f0, %f3, %f0
	fdiv	%f0, %f0, %f2
	ld	%g3, %g1, 8
	ld	%g4, %g1, 492
	jne	%g4, %g3, jeq_else.32082
	fneg	%f0, %f0
	jmp	jeq_cont.32083
jeq_else.32082:
jeq_cont.32083:
	fld	%f2, %g1, 484
	fmul	%f2, %f0, %f2
	ld	%g4, %g1, 100
	fst	%f2, %g4, 0
	fld	%f2, %g1, 472
	fld	%f4, %g1, 388
	fsub	%f2, %f4, %f2
	fld	%f4, %g1, 76
	fjlt	%f2, %f4, fjge_else.32084
	fmov	%f5, %f2
	jmp	fjge_cont.32085
fjge_else.32084:
	fneg	%f5, %f2
fjge_cont.32085:
	fld	%f6, %g1, 0
	fst	%f0, %g1, 500
	fst	%f2, %g1, 504
	fjlt	%f6, %f5, fjge_else.32086
	fjlt	%f5, %f4, fjge_else.32088
	fmov	%f0, %f5
	jmp	fjge_cont.32089
fjge_else.32088:
	fadd	%f5, %f5, %f6
	ld	%g29, %g1, 4
	fmov	%f0, %f5
	st	%g31, %g1, 508
	ld	%g28, %g29, 0
	subi	%g1, %g1, 512
	callR	%g28
	addi	%g1, %g1, 512
	ld	%g31, %g1, 508
fjge_cont.32089:
	jmp	fjge_cont.32087
fjge_else.32086:
	fsub	%f5, %f5, %f6
	ld	%g29, %g1, 4
	fmov	%f0, %f5
	st	%g31, %g1, 508
	ld	%g28, %g29, 0
	subi	%g1, %g1, 512
	callR	%g28
	addi	%g1, %g1, 512
	ld	%g31, %g1, 508
fjge_cont.32087:
	fld	%f1, %g1, 76
	fld	%f2, %g1, 504
	fjlt	%f1, %f2, fjge_else.32090
	ld	%g3, %g1, 8
	jmp	fjge_cont.32091
fjge_else.32090:
	ld	%g3, %g1, 12
fjge_cont.32091:
	fld	%f2, %g1, 272
	fjlt	%f2, %f0, fjge_else.32092
	jmp	fjge_cont.32093
fjge_else.32092:
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.32094
	ld	%g3, %g1, 12
	jmp	jeq_cont.32095
jeq_else.32094:
	mov	%g3, %g4
jeq_cont.32095:
fjge_cont.32093:
	fjlt	%f2, %f0, fjge_else.32096
	jmp	fjge_cont.32097
fjge_else.32096:
	fld	%f3, %g1, 0
	fsub	%f0, %f3, %f0
fjge_cont.32097:
	fld	%f3, %g1, 268
	fjlt	%f3, %f0, fjge_else.32098
	jmp	fjge_cont.32099
fjge_else.32098:
	fsub	%f0, %f2, %f0
fjge_cont.32099:
	fld	%f2, %g1, 372
	fmul	%f0, %f0, %f2
	fmul	%f2, %f0, %f0
	fld	%f3, %g1, 368
	fdiv	%f3, %f2, %f3
	fld	%f4, %g1, 364
	fsub	%f3, %f4, %f3
	fdiv	%f3, %f2, %f3
	fld	%f4, %g1, 360
	fsub	%f3, %f4, %f3
	fdiv	%f3, %f2, %f3
	fld	%f4, %g1, 356
	st	%g3, %g1, 508
	fst	%f0, %g1, 512
	fmov	%f1, %f2
	fmov	%f0, %f4
	fmov	%f2, %f3
	st	%g31, %g1, 516
	subi	%g1, %g1, 520
	call	tan_sub.6499.6594.6640.7111.9860.19184.20437
	addi	%g1, %g1, 520
	ld	%g31, %g1, 516
	fld	%f1, %g1, 384
	fsub	%f0, %f1, %f0
	fld	%f2, %g1, 512
	fdiv	%f0, %f2, %f0
	fmul	%f2, %f0, %f0
	fadd	%f2, %f1, %f2
	fld	%f3, %g1, 400
	fmul	%f0, %f3, %f0
	fdiv	%f0, %f0, %f2
	ld	%g3, %g1, 8
	ld	%g4, %g1, 508
	jne	%g4, %g3, jeq_else.32100
	fneg	%f0, %f0
	jmp	jeq_cont.32101
jeq_else.32100:
jeq_cont.32101:
	fld	%f2, %g1, 500
	fmul	%f0, %f2, %f0
	ld	%g4, %g1, 100
	fst	%f0, %g4, -8
	ld	%g5, %g1, 28
	st	%g3, %g5, 0
	ld	%g6, %g1, 32
	st	%g3, %g6, 0
	ld	%g7, %g1, 36
	ld	%g8, %g1, 12
	st	%g8, %g7, 0
	ld	%g9, %g1, 44
	st	%g3, %g9, 0
	ld	%g10, %g1, 288
	ld	%g29, %g1, 48
	mov	%g4, %g10
	st	%g31, %g1, 516
	ld	%g28, %g29, 0
	subi	%g1, %g1, 520
	callR	%g28
	addi	%g1, %g1, 520
	ld	%g31, %g1, 516
	ld	%g4, %g1, 292
	jne	%g3, %g4, jeq_else.32102
	ld	%g3, %g1, 8
	ld	%g29, %g1, 52
	st	%g31, %g1, 516
	ld	%g28, %g29, 0
	subi	%g1, %g1, 520
	callR	%g28
	addi	%g1, %g1, 520
	ld	%g31, %g1, 516
	ld	%g3, %g1, 28
	ld	%g3, %g3, 0
	st	%g31, %g1, 516
	subi	%g1, %g1, 520
	call	min_caml_float_of_int
	addi	%g1, %g1, 520
	ld	%g31, %g1, 516
	ld	%g3, %g1, 32
	ld	%g3, %g3, 0
	fst	%f0, %g1, 516
	st	%g31, %g1, 524
	subi	%g1, %g1, 528
	call	min_caml_float_of_int
	addi	%g1, %g1, 528
	ld	%g31, %g1, 524
	ld	%g3, %g1, 36
	ld	%g3, %g3, 0
	fst	%f0, %g1, 520
	st	%g31, %g1, 524
	subi	%g1, %g1, 528
	call	min_caml_float_of_int
	addi	%g1, %g1, 528
	ld	%g31, %g1, 524
	fld	%f1, %g1, 520
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 516
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.32103
jeq_else.32102:
	ld	%g3, %g1, 28
	ld	%g3, %g3, 0
	st	%g31, %g1, 524
	subi	%g1, %g1, 528
	call	min_caml_float_of_int
	addi	%g1, %g1, 528
	ld	%g31, %g1, 524
jeq_cont.32103:
	ld	%g3, %g1, 44
	ld	%g3, %g3, 0
	ld	%g4, %g1, 12
	jne	%g3, %g4, jeq_else.32104
	jmp	jeq_cont.32105
jeq_else.32104:
	fneg	%f0, %f0
jeq_cont.32105:
	ld	%g3, %g1, 108
	fst	%f0, %g3, 0
	ld	%g3, %g1, 8
	ld	%g29, %g1, 236
	st	%g31, %g1, 524
	ld	%g28, %g29, 0
	subi	%g1, %g1, 528
	callR	%g28
	addi	%g1, %g1, 528
	ld	%g31, %g1, 524
	ld	%g3, %g1, 8
	ld	%g29, %g1, 228
	st	%g31, %g1, 524
	ld	%g28, %g29, 0
	subi	%g1, %g1, 528
	callR	%g28
	addi	%g1, %g1, 528
	ld	%g31, %g1, 524
	ld	%g3, %g1, 8
	ld	%g29, %g1, 224
	st	%g31, %g1, 524
	ld	%g28, %g29, 0
	subi	%g1, %g1, 528
	callR	%g28
	addi	%g1, %g1, 528
	ld	%g31, %g1, 524
	ld	%g4, %g1, 116
	st	%g3, %g4, 0
	mvhi	%g3, 0
	mvlo	%g3, 80
	output	%g3
	mvhi	%g3, 0
	mvlo	%g3, 51
	output	%g3
	ld	%g3, %g1, 40
	output	%g3
	ld	%g3, %g1, 160
	ld	%g4, %g3, 0
	ld	%g5, %g1, 8
	jlt	%g4, %g5, jle_else.32106
	mov	%g6, %g4
	jmp	jle_cont.32107
jle_else.32106:
	sub	%g6, %g0, %g4
jle_cont.32107:
	ld	%g7, %g1, 68
	st	%g6, %g7, 0
	ld	%g6, %g7, 0
	st	%g4, %g1, 524
	jlt	%g5, %g6, jle_else.32108
	ld	%g6, %g1, 104
	mov	%g3, %g6
	jmp	jle_cont.32109
jle_else.32108:
	divi	%g8, %g6, 10
	muli	%g9, %g8, 10
	sub	%g6, %g6, %g9
	ld	%g9, %g1, 56
	st	%g6, %g9, 0
	st	%g8, %g7, 0
	ld	%g6, %g1, 12
	ld	%g29, %g1, 60
	mov	%g3, %g6
	st	%g31, %g1, 532
	ld	%g28, %g29, 0
	subi	%g1, %g1, 536
	callR	%g28
	addi	%g1, %g1, 536
	ld	%g31, %g1, 532
jle_cont.32109:
	ld	%g4, %g1, 524
	ld	%g5, %g1, 8
	st	%g3, %g1, 528
	jlt	%g4, %g5, jle_else.32110
	jmp	jle_cont.32111
jle_else.32110:
	mvhi	%g4, 0
	mvlo	%g4, 45
	mov	%g3, %g4
	output	%g3
jle_cont.32111:
	mvhi	%g3, 0
	mvlo	%g3, 48
	ld	%g4, %g1, 528
	ld	%g5, %g1, 8
	st	%g3, %g1, 532
	jlt	%g4, %g5, jle_else.32112
	ld	%g29, %g1, 64
	mov	%g3, %g4
	st	%g31, %g1, 540
	ld	%g28, %g29, 0
	subi	%g1, %g1, 544
	callR	%g28
	addi	%g1, %g1, 544
	ld	%g31, %g1, 540
	jmp	jle_cont.32113
jle_else.32112:
	output	%g3
jle_cont.32113:
	ld	%g3, %g1, 288
	output	%g3
	ld	%g3, %g1, 160
	ld	%g4, %g3, -4
	ld	%g5, %g1, 8
	jlt	%g4, %g5, jle_else.32114
	mov	%g6, %g4
	jmp	jle_cont.32115
jle_else.32114:
	sub	%g6, %g0, %g4
jle_cont.32115:
	ld	%g7, %g1, 68
	st	%g6, %g7, 0
	ld	%g6, %g7, 0
	st	%g4, %g1, 536
	jlt	%g5, %g6, jle_else.32116
	ld	%g6, %g1, 104
	mov	%g3, %g6
	jmp	jle_cont.32117
jle_else.32116:
	divi	%g8, %g6, 10
	muli	%g9, %g8, 10
	sub	%g6, %g6, %g9
	ld	%g9, %g1, 56
	st	%g6, %g9, 0
	st	%g8, %g7, 0
	ld	%g6, %g1, 12
	ld	%g29, %g1, 60
	mov	%g3, %g6
	st	%g31, %g1, 540
	ld	%g28, %g29, 0
	subi	%g1, %g1, 544
	callR	%g28
	addi	%g1, %g1, 544
	ld	%g31, %g1, 540
jle_cont.32117:
	ld	%g4, %g1, 536
	ld	%g5, %g1, 8
	st	%g3, %g1, 540
	jlt	%g4, %g5, jle_else.32118
	jmp	jle_cont.32119
jle_else.32118:
	mvhi	%g4, 0
	mvlo	%g4, 45
	mov	%g3, %g4
	output	%g3
jle_cont.32119:
	ld	%g3, %g1, 540
	ld	%g4, %g1, 8
	jlt	%g3, %g4, jle_else.32120
	ld	%g29, %g1, 64
	st	%g31, %g1, 548
	ld	%g28, %g29, 0
	subi	%g1, %g1, 552
	callR	%g28
	addi	%g1, %g1, 552
	ld	%g31, %g1, 548
	jmp	jle_cont.32121
jle_else.32120:
	ld	%g3, %g1, 532
	output	%g3
jle_cont.32121:
	ld	%g3, %g1, 288
	output	%g3
	mvhi	%g3, 0
	mvlo	%g3, 255
	ld	%g4, %g1, 68
	st	%g3, %g4, 0
	ld	%g3, %g4, 0
	ld	%g5, %g1, 8
	jlt	%g5, %g3, jle_else.32122
	ld	%g3, %g1, 104
	jmp	jle_cont.32123
jle_else.32122:
	divi	%g6, %g3, 10
	muli	%g7, %g6, 10
	sub	%g3, %g3, %g7
	ld	%g7, %g1, 56
	st	%g3, %g7, 0
	st	%g6, %g4, 0
	ld	%g3, %g1, 12
	ld	%g29, %g1, 60
	st	%g31, %g1, 548
	ld	%g28, %g29, 0
	subi	%g1, %g1, 552
	callR	%g28
	addi	%g1, %g1, 552
	ld	%g31, %g1, 548
jle_cont.32123:
	ld	%g4, %g1, 8
	jlt	%g3, %g4, jle_else.32124
	ld	%g29, %g1, 64
	st	%g31, %g1, 548
	ld	%g28, %g29, 0
	subi	%g1, %g1, 552
	callR	%g28
	addi	%g1, %g1, 552
	ld	%g31, %g1, 548
	jmp	jle_cont.32125
jle_else.32124:
	ld	%g3, %g1, 532
	output	%g3
jle_cont.32125:
	ld	%g3, %g1, 40
	output	%g3
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g29, %g1, 264
	st	%g3, %g1, 544
	st	%g31, %g1, 548
	ld	%g28, %g29, 0
	subi	%g1, %g1, 552
	callR	%g28
	addi	%g1, %g1, 552
	ld	%g31, %g1, 548
	mvhi	%g3, 0
	mvlo	%g3, 9
	ld	%g4, %g1, 8
	ld	%g29, %g1, 260
	mov	%g5, %g4
	st	%g31, %g1, 548
	ld	%g28, %g29, 0
	subi	%g1, %g1, 552
	callR	%g28
	addi	%g1, %g1, 552
	ld	%g31, %g1, 548
	ld	%g3, %g1, 544
	ld	%g29, %g1, 256
	st	%g31, %g1, 548
	ld	%g28, %g29, 0
	subi	%g1, %g1, 552
	callR	%g28
	addi	%g1, %g1, 552
	ld	%g31, %g1, 548
	ld	%g3, %g1, 100
	fld	%f0, %g3, 0
	ld	%g4, %g1, 208
	fst	%f0, %g4, 0
	fld	%f0, %g3, -4
	fst	%f0, %g4, -4
	fld	%f0, %g3, -8
	fst	%f0, %g4, -8
	ld	%g4, %g1, 72
	ld	%g5, %g4, 0
	subi	%g5, %g5, 1
	ld	%g6, %g1, 232
	ld	%g29, %g1, 252
	mov	%g4, %g5
	mov	%g3, %g6
	st	%g31, %g1, 548
	ld	%g28, %g29, 0
	subi	%g1, %g1, 552
	callR	%g28
	addi	%g1, %g1, 552
	ld	%g31, %g1, 548
	ld	%g3, %g1, 72
	ld	%g4, %g3, 0
	subi	%g4, %g4, 1
	ld	%g5, %g1, 8
	jlt	%g4, %g5, jle_else.32126
	slli	%g6, %g4, 2
	ld	%g7, %g1, 84
	st	%g7, %g1, 548
	add	%g7, %g7, %g6
	ld	%g6, %g7, 0
	ld	%g7, %g1, 548
	ld	%g7, %g6, -8
	ld	%g8, %g1, 156
	jne	%g7, %g8, jeq_else.32128
	ld	%g7, %g6, -28
	fld	%f0, %g7, 0
	fld	%f1, %g1, 384
	fjlt	%f0, %f1, fjge_else.32130
	mov	%g7, %g5
	jmp	fjge_cont.32131
fjge_else.32130:
	ld	%g7, %g1, 12
fjge_cont.32131:
	jne	%g7, %g5, jeq_else.32132
	jmp	jeq_cont.32133
jeq_else.32132:
	ld	%g7, %g6, -4
	ld	%g9, %g1, 12
	jne	%g7, %g9, jeq_else.32134
	muli	%g4, %g4, 4
	ld	%g7, %g1, 248
	ld	%g9, %g7, 0
	ld	%g6, %g6, -28
	fld	%f0, %g6, 0
	fsub	%f0, %f1, %f0
	ld	%g6, %g1, 100
	fld	%f1, %g6, 0
	fneg	%f2, %f1
	fld	%f3, %g6, -4
	fneg	%f3, %f3
	fld	%f4, %g6, -8
	fneg	%f4, %f4
	addi	%g10, %g4, 1
	fld	%f5, %g1, 76
	ld	%g11, %g1, 88
	fst	%f2, %g1, 548
	st	%g4, %g1, 552
	st	%g9, %g1, 556
	st	%g10, %g1, 560
	fst	%f0, %g1, 564
	fst	%f4, %g1, 568
	fst	%f3, %g1, 572
	fst	%f1, %g1, 576
	mov	%g3, %g11
	fmov	%f0, %f5
	st	%g31, %g1, 580
	subi	%g1, %g1, 584
	call	min_caml_create_float_array
	addi	%g1, %g1, 584
	ld	%g31, %g1, 580
	mov	%g4, %g3
	ld	%g3, %g1, 72
	ld	%g5, %g3, 0
	st	%g4, %g1, 580
	mov	%g3, %g5
	st	%g31, %g1, 588
	subi	%g1, %g1, 592
	call	min_caml_create_array
	addi	%g1, %g1, 592
	ld	%g31, %g1, 588
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 580
	st	%g3, %g4, 0
	fld	%f0, %g1, 576
	fst	%f0, %g3, 0
	fld	%f0, %g1, 572
	fst	%f0, %g3, -4
	fld	%f1, %g1, 568
	fst	%f1, %g3, -8
	ld	%g3, %g1, 72
	ld	%g5, %g3, 0
	subi	%g5, %g5, 1
	ld	%g29, %g1, 252
	st	%g4, %g1, 584
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 588
	ld	%g28, %g29, 0
	subi	%g1, %g1, 592
	callR	%g28
	addi	%g1, %g1, 592
	ld	%g31, %g1, 588
	mov	%g3, %g2
	addi	%g2, %g2, 16
	fld	%f0, %g1, 564
	fst	%f0, %g3, -8
	ld	%g4, %g1, 584
	st	%g4, %g3, -4
	ld	%g4, %g1, 560
	st	%g4, %g3, 0
	ld	%g4, %g1, 556
	slli	%g5, %g4, 2
	ld	%g6, %g1, 220
	st	%g6, %g1, 588
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 588
	addi	%g3, %g4, 1
	ld	%g5, %g1, 552
	addi	%g7, %g5, 2
	ld	%g8, %g1, 100
	fld	%f1, %g8, -4
	fld	%f2, %g1, 76
	ld	%g9, %g1, 88
	st	%g3, %g1, 588
	st	%g7, %g1, 592
	fst	%f1, %g1, 596
	mov	%g3, %g9
	fmov	%f0, %f2
	st	%g31, %g1, 604
	subi	%g1, %g1, 608
	call	min_caml_create_float_array
	addi	%g1, %g1, 608
	ld	%g31, %g1, 604
	mov	%g4, %g3
	ld	%g3, %g1, 72
	ld	%g5, %g3, 0
	st	%g4, %g1, 600
	mov	%g3, %g5
	st	%g31, %g1, 604
	subi	%g1, %g1, 608
	call	min_caml_create_array
	addi	%g1, %g1, 608
	ld	%g31, %g1, 604
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 600
	st	%g3, %g4, 0
	fld	%f0, %g1, 548
	fst	%f0, %g3, 0
	fld	%f1, %g1, 596
	fst	%f1, %g3, -4
	fld	%f1, %g1, 568
	fst	%f1, %g3, -8
	ld	%g3, %g1, 72
	ld	%g5, %g3, 0
	subi	%g5, %g5, 1
	ld	%g29, %g1, 252
	st	%g4, %g1, 604
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 612
	ld	%g28, %g29, 0
	subi	%g1, %g1, 616
	callR	%g28
	addi	%g1, %g1, 616
	ld	%g31, %g1, 612
	mov	%g3, %g2
	addi	%g2, %g2, 16
	fld	%f0, %g1, 564
	fst	%f0, %g3, -8
	ld	%g4, %g1, 604
	st	%g4, %g3, -4
	ld	%g4, %g1, 592
	st	%g4, %g3, 0
	ld	%g4, %g1, 588
	slli	%g4, %g4, 2
	ld	%g5, %g1, 220
	st	%g5, %g1, 612
	add	%g5, %g5, %g4
	st	%g3, %g5, 0
	ld	%g5, %g1, 612
	ld	%g3, %g1, 556
	addi	%g4, %g3, 2
	ld	%g6, %g1, 552
	addi	%g6, %g6, 3
	ld	%g7, %g1, 100
	fld	%f1, %g7, -8
	fld	%f2, %g1, 76
	ld	%g7, %g1, 88
	st	%g4, %g1, 608
	st	%g6, %g1, 612
	fst	%f1, %g1, 616
	mov	%g3, %g7
	fmov	%f0, %f2
	st	%g31, %g1, 620
	subi	%g1, %g1, 624
	call	min_caml_create_float_array
	addi	%g1, %g1, 624
	ld	%g31, %g1, 620
	mov	%g4, %g3
	ld	%g3, %g1, 72
	ld	%g5, %g3, 0
	st	%g4, %g1, 620
	mov	%g3, %g5
	st	%g31, %g1, 628
	subi	%g1, %g1, 632
	call	min_caml_create_array
	addi	%g1, %g1, 632
	ld	%g31, %g1, 628
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 620
	st	%g3, %g4, 0
	fld	%f0, %g1, 548
	fst	%f0, %g3, 0
	fld	%f0, %g1, 572
	fst	%f0, %g3, -4
	fld	%f0, %g1, 616
	fst	%f0, %g3, -8
	ld	%g3, %g1, 72
	ld	%g3, %g3, 0
	subi	%g3, %g3, 1
	ld	%g29, %g1, 252
	st	%g4, %g1, 624
	mov	%g28, %g4
	mov	%g4, %g3
	mov	%g3, %g28
	st	%g31, %g1, 628
	ld	%g28, %g29, 0
	subi	%g1, %g1, 632
	callR	%g28
	addi	%g1, %g1, 632
	ld	%g31, %g1, 628
	mov	%g3, %g2
	addi	%g2, %g2, 16
	fld	%f0, %g1, 564
	fst	%f0, %g3, -8
	ld	%g4, %g1, 624
	st	%g4, %g3, -4
	ld	%g4, %g1, 612
	st	%g4, %g3, 0
	ld	%g4, %g1, 608
	slli	%g4, %g4, 2
	ld	%g5, %g1, 220
	st	%g5, %g1, 628
	add	%g5, %g5, %g4
	st	%g3, %g5, 0
	ld	%g5, %g1, 628
	ld	%g3, %g1, 556
	addi	%g3, %g3, 3
	ld	%g4, %g1, 248
	st	%g3, %g4, 0
	jmp	jeq_cont.32135
jeq_else.32134:
	jne	%g7, %g8, jeq_else.32136
	muli	%g4, %g4, 4
	addi	%g4, %g4, 1
	ld	%g7, %g1, 248
	ld	%g9, %g7, 0
	fsub	%f0, %f1, %f0
	ld	%g6, %g6, -16
	ld	%g10, %g1, 100
	fld	%f1, %g10, 0
	fld	%f2, %g6, 0
	fmul	%f3, %f1, %f2
	fld	%f4, %g10, -4
	fld	%f5, %g6, -4
	fmul	%f6, %f4, %f5
	fadd	%f3, %f3, %f6
	fld	%f6, %g10, -8
	fld	%f7, %g6, -8
	fmul	%f8, %f6, %f7
	fadd	%f3, %f3, %f8
	fld	%f8, %g1, 400
	fmul	%f2, %f8, %f2
	fmul	%f2, %f2, %f3
	fsub	%f1, %f2, %f1
	fmul	%f2, %f8, %f5
	fmul	%f2, %f2, %f3
	fsub	%f2, %f2, %f4
	fmul	%f4, %f8, %f7
	fmul	%f3, %f4, %f3
	fsub	%f3, %f3, %f6
	fld	%f4, %g1, 76
	ld	%g6, %g1, 88
	st	%g9, %g1, 628
	st	%g4, %g1, 632
	fst	%f0, %g1, 636
	fst	%f3, %g1, 640
	fst	%f2, %g1, 644
	fst	%f1, %g1, 648
	mov	%g3, %g6
	fmov	%f0, %f4
	st	%g31, %g1, 652
	subi	%g1, %g1, 656
	call	min_caml_create_float_array
	addi	%g1, %g1, 656
	ld	%g31, %g1, 652
	mov	%g4, %g3
	ld	%g3, %g1, 72
	ld	%g5, %g3, 0
	st	%g4, %g1, 652
	mov	%g3, %g5
	st	%g31, %g1, 660
	subi	%g1, %g1, 664
	call	min_caml_create_array
	addi	%g1, %g1, 664
	ld	%g31, %g1, 660
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 652
	st	%g3, %g4, 0
	fld	%f0, %g1, 648
	fst	%f0, %g3, 0
	fld	%f0, %g1, 644
	fst	%f0, %g3, -4
	fld	%f0, %g1, 640
	fst	%f0, %g3, -8
	ld	%g3, %g1, 72
	ld	%g3, %g3, 0
	subi	%g3, %g3, 1
	ld	%g29, %g1, 252
	st	%g4, %g1, 656
	mov	%g28, %g4
	mov	%g4, %g3
	mov	%g3, %g28
	st	%g31, %g1, 660
	ld	%g28, %g29, 0
	subi	%g1, %g1, 664
	callR	%g28
	addi	%g1, %g1, 664
	ld	%g31, %g1, 660
	mov	%g3, %g2
	addi	%g2, %g2, 16
	fld	%f0, %g1, 636
	fst	%f0, %g3, -8
	ld	%g4, %g1, 656
	st	%g4, %g3, -4
	ld	%g4, %g1, 632
	st	%g4, %g3, 0
	ld	%g4, %g1, 628
	slli	%g5, %g4, 2
	ld	%g6, %g1, 220
	st	%g6, %g1, 660
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 660
	addi	%g3, %g4, 1
	ld	%g4, %g1, 248
	st	%g3, %g4, 0
	jmp	jeq_cont.32137
jeq_else.32136:
jeq_cont.32137:
jeq_cont.32135:
jeq_cont.32133:
	jmp	jeq_cont.32129
jeq_else.32128:
jeq_cont.32129:
	jmp	jle_cont.32127
jle_else.32126:
jle_cont.32127:
	ld	%g3, %g1, 188
	fld	%f0, %g3, -8
	ld	%g4, %g1, 164
	ld	%g4, %g4, -4
	sub	%g4, %g0, %g4
	fst	%f0, %g1, 660
	mov	%g3, %g4
	st	%g31, %g1, 668
	subi	%g1, %g1, 672
	call	min_caml_float_of_int
	addi	%g1, %g1, 672
	ld	%g31, %g1, 668
	ld	%g3, %g1, 168
	fld	%f1, %g3, 0
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 184
	fld	%f1, %g3, -8
	fmul	%f1, %f0, %f1
	fld	%f2, %g1, 660
	fadd	%f2, %f1, %f2
	ld	%g4, %g1, 188
	fld	%f1, %g4, -4
	fld	%f3, %g3, -4
	fmul	%f3, %f0, %f3
	fadd	%f1, %f3, %f1
	fld	%f3, %g4, 0
	fld	%f4, %g3, 0
	fmul	%f0, %f0, %f4
	fadd	%f0, %f0, %f3
	ld	%g3, %g1, 160
	ld	%g3, %g3, 0
	subi	%g4, %g3, 1
	ld	%g3, %g1, 280
	ld	%g5, %g1, 8
	ld	%g29, %g1, 244
	st	%g31, %g1, 668
	ld	%g28, %g29, 0
	subi	%g1, %g1, 672
	callR	%g28
	addi	%g1, %g1, 672
	ld	%g31, %g1, 668
	ld	%g3, %g1, 8
	ld	%g4, %g1, 276
	ld	%g5, %g1, 280
	ld	%g6, %g1, 284
	ld	%g7, %g1, 156
	ld	%g29, %g1, 240
	st	%g31, %g1, 668
	ld	%g28, %g29, 0
	subi	%g1, %g1, 672
	callR	%g28
	addi	%g1, %g1, 672
	ld	%g31, %g1, 668
	ld	%g3, %g1, 8
	mov	%g0, %g3
	halt
