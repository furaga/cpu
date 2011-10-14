.init_heap_size	1472
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
l.7696:	! 6.283185
	.long	0x40c90fda
l.7694:	! 3.141593
	.long	0x40490fda
l.7689:	! 128.000000
	.long	0x43000000
l.7624:	! 0.900000
	.long	0x3f66665e
l.7622:	! 0.200000
	.long	0x3e4cccc4
l.7439:	! 150.000000
	.long	0x43160000
l.7435:	! -150.000000
	.long	0xc3160000
l.7406:	! 0.100000
	.long	0x3dccccc4
l.7400:	! -2.000000
	.long	0xc0000000
l.7396:	! 0.003906
	.long	0x3b800000
l.7350:	! 20.000000
	.long	0x41a00000
l.7348:	! 0.050000
	.long	0x3d4cccc4
l.7339:	! 0.250000
	.long	0x3e800000
l.7329:	! 10.000000
	.long	0x41200000
l.7322:	! 0.300000
	.long	0x3e999999
l.7320:	! 255.000000
	.long	0x437f0000
l.7315:	! 0.150000
	.long	0x3e199999
l.7307:	! 3.141593
	.long	0x40490fda
l.7305:	! 30.000000
	.long	0x41f00000
l.7303:	! 15.000000
	.long	0x41700000
l.7301:	! 0.000100
	.long	0x38d1b70f
l.7227:	! 100000000.000000
	.long	0x4cbebc20
l.7219:	! 1000000000.000000
	.long	0x4e6e6b28
l.7180:	! -0.100000
	.long	0xbdccccc4
l.7154:	! 0.010000
	.long	0x3c23d70a
l.7152:	! -0.200000
	.long	0xbe4cccc4
l.6772:	! -200.000000
	.long	0xc3480000
l.6769:	! 200.000000
	.long	0x43480000
l.6764:	! 0.017453
	.long	0x3c8efa2d
l.6551:	! 1.570796
	.long	0x3fc90fda
l.6540:	! 9.000000
	.long	0x41100000
l.6536:	! 2.500000
	.long	0x40200000
l.6534:	! -1.570796
	.long	0xbfc90fda
l.6532:	! 1.570796
	.long	0x3fc90fda
l.6528:	! 11.000000
	.long	0x41300000
l.6524:	! -1.000000
	.long	0xbf800000
l.6519:	! 1.000000
	.long	0x3f800000
l.6517:	! 0.500000
	.long	0x3f000000
l.6515:	! 2.000000
	.long	0x40000000
l.6510:	! 0.000000
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

fless.2646:
	fjlt	%f0, %f1, fjge_else.9896
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.9896:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fispos.2649:
	setL %g3, l.6510
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.9897
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.9897:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fisneg.2651:
	setL %g3, l.6510
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.9898
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.9898:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fiszero.2653:
	setL %g3, l.6510
	fld	%f1, %g3, 0
	fjeq	%f0, %f1, fjne_else.9899
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjne_else.9899:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fabs.2658:
	setL %g3, l.6510
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.9900
	return
fjge_else.9900:
	fneg	%f0, %f0
	return
fneg.2660:
	fneg	%f0, %f0
	return
fhalf.2662:
	setL %g3, l.6515
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	return
fsqr.2664:
	fmul	%f0, %f0, %f0
	return
atan_sub.6468:
	setL %g3, l.6517
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.9901
	setL %g3, l.6519
	fld	%f3, %g3, 0
	fsub	%f3, %f0, %f3
	fmul	%f4, %f0, %f0
	fmul	%f4, %f4, %f1
	setL %g3, l.6515
	fld	%f5, %g3, 0
	fmul	%f0, %f5, %f0
	setL %g3, l.6519
	fld	%f5, %g3, 0
	fadd	%f0, %f0, %f5
	fadd	%f0, %f0, %f2
	fdiv	%f2, %f4, %f0
	fmov	%f0, %f3
	jmp	atan_sub.6468
fjge_else.9901:
	fmov	%f0, %f2
	return
atan.2669:
	setL %g3, l.6519
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.9902
	setL %g3, l.6524
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.9904
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	fjge_cont.9905
fjge_else.9904:
	mvhi	%g3, 65535
	mvlo	%g3, -1
fjge_cont.9905:
	jmp	fjge_cont.9903
fjge_else.9902:
	mvhi	%g3, 0
	mvlo	%g3, 1
fjge_cont.9903:
	st	%g3, %g1, 0
	fst	%f0, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fabs.2658
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	setL %g3, l.6519
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.9906
	fld	%f0, %g1, 4
	jmp	fjge_cont.9907
fjge_else.9906:
	setL %g3, l.6519
	fld	%f0, %g3, 0
	fld	%f1, %g1, 4
	fdiv	%f0, %f0, %f1
fjge_cont.9907:
	setL %g3, l.6528
	fld	%f1, %g3, 0
	fmul	%f2, %f0, %f0
	setL %g3, l.6510
	fld	%f3, %g3, 0
	fst	%f0, %g1, 8
	fmov	%f0, %f1
	fmov	%f1, %f2
	fmov	%f2, %f3
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	atan_sub.6468
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	setL %g3, l.6519
	fld	%f1, %g3, 0
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 8
	fdiv	%f0, %f1, %f0
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 0
	jlt	%g3, %g4, jle_else.9908
	mvhi	%g3, 0
	mvlo	%g3, 0
	jlt	%g4, %g3, jle_else.9909
	return
jle_else.9909:
	setL %g3, l.6534
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	return
jle_else.9908:
	setL %g3, l.6532
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	return
tan_sub.6451:
	setL %g3, l.6536
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.9910
	setL %g3, l.6515
	fld	%f3, %g3, 0
	fsub	%f3, %f0, %f3
	fsub	%f0, %f0, %f2
	fdiv	%f2, %f1, %f0
	fmov	%f0, %f3
	jmp	tan_sub.6451
fjge_else.9910:
	fmov	%f0, %f2
	return
tan.6426:
	setL %g3, l.6519
	fld	%f1, %g3, 0
	setL %g3, l.6540
	fld	%f2, %g3, 0
	fmul	%f3, %f0, %f0
	setL %g3, l.6510
	fld	%f4, %g3, 0
	fst	%f0, %g1, 0
	fst	%f1, %g1, 4
	fmov	%f1, %f3
	fmov	%f0, %f2
	fmov	%f2, %f4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	tan_sub.6451
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f1, %g1, 4
	fsub	%f0, %f1, %f0
	fld	%f1, %g1, 0
	fdiv	%f0, %f1, %f0
	return
tmp.6430:
	fld	%f1, %g29, -8
	fjlt	%f1, %f0, fjge_else.9911
	setL %g3, l.6510
	fld	%f2, %g3, 0
	fjlt	%f0, %f2, fjge_else.9912
	return
fjge_else.9912:
	fadd	%f0, %f0, %f1
	ld	%g28, %g29, 0
	b	%g28
fjge_else.9911:
	fsub	%f0, %f0, %f1
	ld	%g28, %g29, 0
	b	%g28
sin.2671:
	fld	%f1, %g29, -24
	fld	%f2, %g29, -16
	fld	%f3, %g29, -8
	setL %g3, l.6510
	fld	%f4, %g3, 0
	fjlt	%f4, %f0, fjge_else.9913
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	fjge_cont.9914
fjge_else.9913:
	mvhi	%g3, 0
	mvlo	%g3, 1
fjge_cont.9914:
	fst	%f1, %g1, 0
	st	%g3, %g1, 4
	fst	%f3, %g1, 8
	fst	%f2, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fabs.2658
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g29, %g2
	addi	%g2, %g2, 16
	setL %g3, tmp.6430
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
	fjlt	%f1, %f0, fjge_else.9915
	ld	%g3, %g1, 4
	jmp	fjge_cont.9916
fjge_else.9915:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 4
	jne	%g4, %g3, jeq_else.9917
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.9918
jeq_else.9917:
	mvhi	%g3, 0
	mvlo	%g3, 0
jeq_cont.9918:
fjge_cont.9916:
	fjlt	%f1, %f0, fjge_else.9919
	jmp	fjge_cont.9920
fjge_else.9919:
	fld	%f2, %g1, 12
	fsub	%f0, %f2, %f0
fjge_cont.9920:
	fld	%f2, %g1, 0
	fjlt	%f2, %f0, fjge_else.9921
	jmp	fjge_cont.9922
fjge_else.9921:
	fsub	%f0, %f1, %f0
fjge_cont.9922:
	setL %g4, l.6517
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	st	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	tan.6426
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	setL %g3, l.6515
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	setL %g3, l.6519
	fld	%f2, %g3, 0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f2, %f0
	fdiv	%f0, %f1, %f0
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 16
	jne	%g4, %g3, jeq_else.9923
	jmp	fneg.2660
jeq_else.9923:
	return
cos.2673:
	ld	%g29, %g29, -4
	setL %g3, l.6551
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	ld	%g28, %g29, 0
	b	%g28
mul10.2675:
	muli	%g4, %g3, 8
	muli	%g3, %g3, 2
	add	%g3, %g4, %g3
	return
read_token.6378:
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
	jlt	%g4, %g3, jle_else.9924
	mvhi	%g3, 0
	mvlo	%g3, 57
	jlt	%g3, %g4, jle_else.9926
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jle_cont.9927
jle_else.9926:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.9927:
	jmp	jle_cont.9925
jle_else.9924:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.9925:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.9928
	ld	%g3, %g1, 16
	ld	%g5, %g3, 0
	mvhi	%g6, 0
	mvlo	%g6, 0
	jne	%g5, %g6, jeq_else.9929
	mvhi	%g5, 0
	mvlo	%g5, 45
	ld	%g6, %g1, 12
	jne	%g6, %g5, jeq_else.9931
	mvhi	%g5, 65535
	mvlo	%g5, -1
	st	%g5, %g3, 0
	jmp	jeq_cont.9932
jeq_else.9931:
	mvhi	%g5, 0
	mvlo	%g5, 1
	st	%g5, %g3, 0
jeq_cont.9932:
	jmp	jeq_cont.9930
jeq_else.9929:
jeq_cont.9930:
	ld	%g3, %g1, 8
	ld	%g5, %g3, 0
	st	%g4, %g1, 20
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	mul10.2675
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	subi	%g5, %g4, 48
	add	%g3, %g3, %g5
	ld	%g5, %g1, 8
	st	%g3, %g5, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9928:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g5, %g1, 0
	jne	%g5, %g3, jeq_else.9933
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9933:
	ld	%g3, %g1, 16
	ld	%g3, %g3, 0
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.9934
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	return
jeq_else.9934:
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	sub	%g3, %g0, %g3
	return
read_int.2677:
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 0
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g29, %g2
	addi	%g2, %g2, 16
	setL %g4, read_token.6378
	st	%g4, %g29, 0
	st	%g3, %g29, -8
	ld	%g3, %g1, 0
	st	%g3, %g29, -4
	mvhi	%g3, 0
	mvlo	%g3, 0
	mvhi	%g4, 0
	mvlo	%g4, 32
	ld	%g28, %g29, 0
	b	%g28
read_token1.6292:
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
	jlt	%g4, %g3, jle_else.9935
	mvhi	%g3, 0
	mvlo	%g3, 57
	jlt	%g3, %g4, jle_else.9937
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jle_cont.9938
jle_else.9937:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.9938:
	jmp	jle_cont.9936
jle_else.9935:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.9936:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.9939
	ld	%g3, %g1, 16
	ld	%g5, %g3, 0
	mvhi	%g6, 0
	mvlo	%g6, 0
	jne	%g5, %g6, jeq_else.9940
	mvhi	%g5, 0
	mvlo	%g5, 45
	ld	%g6, %g1, 12
	jne	%g6, %g5, jeq_else.9942
	mvhi	%g5, 65535
	mvlo	%g5, -1
	st	%g5, %g3, 0
	jmp	jeq_cont.9943
jeq_else.9942:
	mvhi	%g5, 0
	mvlo	%g5, 1
	st	%g5, %g3, 0
jeq_cont.9943:
	jmp	jeq_cont.9941
jeq_else.9940:
jeq_cont.9941:
	ld	%g3, %g1, 8
	ld	%g5, %g3, 0
	st	%g4, %g1, 20
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	mul10.2675
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	subi	%g5, %g4, 48
	add	%g3, %g3, %g5
	ld	%g5, %g1, 8
	st	%g3, %g5, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9939:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g5, %g1, 0
	jne	%g5, %g3, jeq_else.9944
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9944:
	mov	%g3, %g4
	return
read_token2.6295:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	st	%g3, %g1, 0
	st	%g29, %g1, 4
	st	%g5, %g1, 8
	st	%g4, %g1, 12
	input	%g3
	mvhi	%g4, 0
	mvlo	%g4, 48
	jlt	%g3, %g4, jle_else.9945
	mvhi	%g4, 0
	mvlo	%g4, 57
	jlt	%g4, %g3, jle_else.9947
	mvhi	%g4, 0
	mvlo	%g4, 0
	jmp	jle_cont.9948
jle_else.9947:
	mvhi	%g4, 0
	mvlo	%g4, 1
jle_cont.9948:
	jmp	jle_cont.9946
jle_else.9945:
	mvhi	%g4, 0
	mvlo	%g4, 1
jle_cont.9946:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g4, %g5, jeq_else.9949
	ld	%g4, %g1, 12
	ld	%g5, %g4, 0
	st	%g3, %g1, 16
	mov	%g3, %g5
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	mul10.2675
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 16
	subi	%g4, %g4, 48
	add	%g3, %g3, %g4
	ld	%g4, %g1, 12
	st	%g3, %g4, 0
	ld	%g3, %g1, 8
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	mul10.2675
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	st	%g3, %g4, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9949:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 0
	jne	%g4, %g3, jeq_else.9950
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9950:
	return
read_float.2679:
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
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
	mvlo	%g5, 1
	st	%g3, %g1, 4
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 8
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mov	%g29, %g2
	addi	%g2, %g2, 16
	setL %g4, read_token1.6292
	st	%g4, %g29, 0
	st	%g3, %g29, -8
	ld	%g4, %g1, 0
	st	%g4, %g29, -4
	mov	%g5, %g2
	addi	%g2, %g2, 16
	setL %g6, read_token2.6295
	st	%g6, %g5, 0
	ld	%g6, %g1, 4
	st	%g6, %g5, -8
	ld	%g7, %g1, 8
	st	%g7, %g5, -4
	mvhi	%g8, 0
	mvlo	%g8, 0
	mvhi	%g9, 0
	mvlo	%g9, 32
	st	%g3, %g1, 12
	st	%g5, %g1, 16
	mov	%g4, %g9
	mov	%g3, %g8
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 46
	jne	%g3, %g4, jeq_else.9952
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 0
	ld	%g3, %g3, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_float_of_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 4
	ld	%g3, %g3, 0
	fst	%f0, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 20
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.9953
jeq_else.9952:
	ld	%g3, %g1, 0
	ld	%g3, %g3, 0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
jeq_cont.9953:
	ld	%g3, %g1, 12
	ld	%g3, %g3, 0
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.9954
	return
jeq_else.9954:
	fneg	%f0, %f0
	return
get_digits.6247:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	ld	%g6, %g4, 0
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g7, %g6, jle_else.9955
	subi	%g3, %g3, 1
	return
jle_else.9955:
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
print_digits.6249:
	ld	%g4, %g29, -4
	mvhi	%g5, 0
	mvlo	%g5, 0
	jlt	%g3, %g5, jle_else.9956
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
jle_else.9956:
	return
print_int.2681:
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
	jlt	%g6, %g5, jle_else.9958
	mov	%g5, %g6
	jmp	jle_cont.9959
jle_else.9958:
	sub	%g5, %g0, %g6
jle_cont.9959:
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
	setL %g4, get_digits.6247
	st	%g4, %g29, 0
	st	%g3, %g29, -8
	ld	%g3, %g1, 4
	st	%g3, %g29, -4
	mov	%g4, %g2
	addi	%g2, %g2, 8
	setL %g5, print_digits.6249
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
	jlt	%g5, %g4, jle_else.9960
	jmp	jle_cont.9961
jle_else.9960:
	mvhi	%g4, 0
	mvlo	%g4, 45
	mov	%g3, %g4
	output	%g3
jle_cont.9961:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 12
	jlt	%g3, %g4, jle_else.9962
	mvhi	%g3, 0
	mvlo	%g3, 48
	output	%g3
	return
jle_else.9962:
	ld	%g29, %g1, 8
	mov	%g3, %g4
	ld	%g28, %g29, 0
	b	%g28
xor.2713:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.9963
	mov	%g3, %g4
	return
jeq_else.9963:
	mvhi	%g3, 0
	mvlo	%g3, 0
	jne	%g4, %g3, jeq_else.9964
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.9964:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
sgn.2716:
	fst	%f0, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	fiszero.2653
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9965
	fld	%f0, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	fispos.2649
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9966
	setL %g3, l.6524
	fld	%f0, %g3, 0
	return
jeq_else.9966:
	setL %g3, l.6519
	fld	%f0, %g3, 0
	return
jeq_else.9965:
	setL %g3, l.6510
	fld	%f0, %g3, 0
	return
fneg_cond.2718:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9967
	jmp	fneg.2660
jeq_else.9967:
	return
add_mod5.2721:
	add	%g3, %g3, %g4
	mvhi	%g4, 0
	mvlo	%g4, 5
	jlt	%g3, %g4, jle_else.9968
	subi	%g3, %g3, 5
	return
jle_else.9968:
	return
vecset.2724:
	fst	%f0, %g3, 0
	fst	%f1, %g3, -4
	fst	%f2, %g3, -8
	return
vecfill.2729:
	fst	%f0, %g3, 0
	fst	%f0, %g3, -4
	fst	%f0, %g3, -8
	return
vecbzero.2732:
	setL %g4, l.6510
	fld	%f0, %g4, 0
	jmp	vecfill.2729
veccpy.2734:
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	fld	%f0, %g4, -4
	fst	%f0, %g3, -4
	fld	%f0, %g4, -8
	fst	%f0, %g3, -8
	return
vecunit_sgn.2742:
	fld	%f0, %g3, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fsqr.2664
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	fld	%f1, %g3, -4
	fst	%f0, %g1, 8
	fmov	%f0, %f1
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fsqr.2664
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f1, %g1, 8
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, -8
	fst	%f0, %g1, 12
	fmov	%f0, %f1
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fsqr.2664
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 12
	fadd	%f0, %f1, %f0
	fsqrt	%f0, %f0
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fiszero.2653
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9972
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 0
	jne	%g4, %g3, jeq_else.9974
	setL %g3, l.6519
	fld	%f0, %g3, 0
	fld	%f1, %g1, 16
	fdiv	%f0, %f0, %f1
	jmp	jeq_cont.9975
jeq_else.9974:
	setL %g3, l.6524
	fld	%f0, %g3, 0
	fld	%f1, %g1, 16
	fdiv	%f0, %f0, %f1
jeq_cont.9975:
	jmp	jeq_cont.9973
jeq_else.9972:
	setL %g3, l.6519
	fld	%f0, %g3, 0
jeq_cont.9973:
	ld	%g3, %g1, 4
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	fst	%f1, %g3, 0
	fld	%f1, %g3, -4
	fmul	%f1, %f1, %f0
	fst	%f1, %g3, -4
	fld	%f1, %g3, -8
	fmul	%f0, %f1, %f0
	fst	%f0, %g3, -8
	return
veciprod.2745:
	fld	%f0, %g3, 0
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g3, -4
	fld	%f2, %g4, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, -8
	fld	%f2, %g4, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	return
veciprod2.2748:
	fld	%f3, %g3, 0
	fmul	%f0, %f3, %f0
	fld	%f3, %g3, -4
	fmul	%f1, %f3, %f1
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	return
vecaccum.2753:
	fld	%f1, %g3, 0
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
	return
vecadd.2757:
	fld	%f0, %g3, 0
	fld	%f1, %g4, 0
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, 0
	fld	%f0, %g3, -4
	fld	%f1, %g4, -4
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, -4
	fld	%f0, %g3, -8
	fld	%f1, %g4, -8
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, -8
	return
vecscale.2763:
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	fst	%f1, %g3, 0
	fld	%f1, %g3, -4
	fmul	%f1, %f1, %f0
	fst	%f1, %g3, -4
	fld	%f1, %g3, -8
	fmul	%f0, %f1, %f0
	fst	%f0, %g3, -8
	return
vecaccumv.2766:
	fld	%f0, %g3, 0
	fld	%f1, %g4, 0
	fld	%f2, %g5, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, 0
	fld	%f0, %g3, -4
	fld	%f1, %g4, -4
	fld	%f2, %g5, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, -4
	fld	%f0, %g3, -8
	fld	%f1, %g4, -8
	fld	%f2, %g5, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, -8
	return
o_texturetype.2770:
	ld	%g3, %g3, 0
	return
o_form.2772:
	ld	%g3, %g3, -4
	return
o_reflectiontype.2774:
	ld	%g3, %g3, -8
	return
o_isinvert.2776:
	ld	%g3, %g3, -24
	return
o_isrot.2778:
	ld	%g3, %g3, -12
	return
o_param_a.2780:
	ld	%g3, %g3, -16
	fld	%f0, %g3, 0
	return
o_param_b.2782:
	ld	%g3, %g3, -16
	fld	%f0, %g3, -4
	return
o_param_c.2784:
	ld	%g3, %g3, -16
	fld	%f0, %g3, -8
	return
o_param_abc.2786:
	ld	%g3, %g3, -16
	return
o_param_x.2788:
	ld	%g3, %g3, -20
	fld	%f0, %g3, 0
	return
o_param_y.2790:
	ld	%g3, %g3, -20
	fld	%f0, %g3, -4
	return
o_param_z.2792:
	ld	%g3, %g3, -20
	fld	%f0, %g3, -8
	return
o_diffuse.2794:
	ld	%g3, %g3, -28
	fld	%f0, %g3, 0
	return
o_hilight.2796:
	ld	%g3, %g3, -28
	fld	%f0, %g3, -4
	return
o_color_red.2798:
	ld	%g3, %g3, -32
	fld	%f0, %g3, 0
	return
o_color_green.2800:
	ld	%g3, %g3, -32
	fld	%f0, %g3, -4
	return
o_color_blue.2802:
	ld	%g3, %g3, -32
	fld	%f0, %g3, -8
	return
o_param_r1.2804:
	ld	%g3, %g3, -36
	fld	%f0, %g3, 0
	return
o_param_r2.2806:
	ld	%g3, %g3, -36
	fld	%f0, %g3, -4
	return
o_param_r3.2808:
	ld	%g3, %g3, -36
	fld	%f0, %g3, -8
	return
o_param_ctbl.2810:
	ld	%g3, %g3, -40
	return
p_rgb.2812:
	ld	%g3, %g3, 0
	return
p_intersection_points.2814:
	ld	%g3, %g3, -4
	return
p_surface_ids.2816:
	ld	%g3, %g3, -8
	return
p_calc_diffuse.2818:
	ld	%g3, %g3, -12
	return
p_energy.2820:
	ld	%g3, %g3, -16
	return
p_received_ray_20percent.2822:
	ld	%g3, %g3, -20
	return
p_group_id.2824:
	ld	%g3, %g3, -24
	ld	%g3, %g3, 0
	return
p_set_group_id.2826:
	ld	%g3, %g3, -24
	st	%g4, %g3, 0
	return
p_nvectors.2829:
	ld	%g3, %g3, -28
	return
d_vec.2831:
	ld	%g3, %g3, 0
	return
d_const.2833:
	ld	%g3, %g3, -4
	return
r_surface_id.2835:
	ld	%g3, %g3, 0
	return
r_dvec.2837:
	ld	%g3, %g3, -4
	return
r_bright.2839:
	fld	%f0, %g3, -8
	return
rad.2841:
	setL %g3, l.6764
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	return
read_screen_settings.2843:
	ld	%g3, %g29, -28
	ld	%g4, %g29, -24
	ld	%g5, %g29, -20
	ld	%g6, %g29, -16
	ld	%g7, %g29, -12
	ld	%g8, %g29, -8
	ld	%g9, %g29, -4
	st	%g3, %g1, 0
	st	%g6, %g1, 4
	st	%g7, %g1, 8
	st	%g5, %g1, 12
	st	%g4, %g1, 16
	st	%g9, %g1, 20
	st	%g8, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	read_float.2679
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 24
	fst	%f0, %g3, 0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	read_float.2679
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 24
	fst	%f0, %g3, -4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	read_float.2679
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 24
	fst	%f0, %g3, -8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	read_float.2679
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	rad.2841
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g29, %g1, 20
	fst	%f0, %g1, 28
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 28
	ld	%g29, %g1, 16
	fst	%f0, %g1, 32
	fmov	%f0, %f1
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fst	%f0, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	read_float.2679
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	rad.2841
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g29, %g1, 20
	fst	%f0, %g1, 40
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 40
	ld	%g29, %g1, 16
	fst	%f0, %g1, 44
	fmov	%f0, %f1
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 32
	fmul	%f2, %f1, %f0
	setL %g3, l.6769
	fld	%f3, %g3, 0
	fmul	%f2, %f2, %f3
	ld	%g3, %g1, 12
	fst	%f2, %g3, 0
	setL %g4, l.6772
	fld	%f2, %g4, 0
	fld	%f3, %g1, 36
	fmul	%f2, %f3, %f2
	fst	%f2, %g3, -4
	fld	%f2, %g1, 44
	fmul	%f4, %f1, %f2
	setL %g4, l.6769
	fld	%f5, %g4, 0
	fmul	%f4, %f4, %f5
	fst	%f4, %g3, -8
	ld	%g4, %g1, 8
	fst	%f2, %g4, 0
	setL %g5, l.6510
	fld	%f4, %g5, 0
	fst	%f4, %g4, -4
	fst	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2660
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 8
	fst	%f0, %g3, -8
	fld	%f0, %g1, 36
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2660
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 48
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 4
	fst	%f0, %g3, 0
	fld	%f0, %g1, 32
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2660
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 4
	fst	%f0, %g3, -4
	fld	%f0, %g1, 36
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2660
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 44
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 4
	fst	%f0, %g3, -8
	ld	%g3, %g1, 24
	fld	%f0, %g3, 0
	ld	%g4, %g1, 12
	fld	%f1, %g4, 0
	fsub	%f0, %f0, %f1
	ld	%g5, %g1, 0
	fst	%f0, %g5, 0
	fld	%f0, %g3, -4
	fld	%f1, %g4, -4
	fsub	%f0, %f0, %f1
	fst	%f0, %g5, -4
	fld	%f0, %g3, -8
	fld	%f1, %g4, -8
	fsub	%f0, %f0, %f1
	fst	%f0, %g5, -8
	return
read_light.2845:
	ld	%g3, %g29, -16
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	st	%g6, %g1, 0
	st	%g5, %g1, 4
	st	%g4, %g1, 8
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	read_int.2677
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	read_float.2679
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	rad.2841
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g29, %g1, 12
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fneg.2660
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 8
	fst	%f0, %g3, -4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	read_float.2679
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	rad.2841
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 16
	ld	%g29, %g1, 4
	fst	%f0, %g1, 20
	fmov	%f0, %f1
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 20
	ld	%g29, %g1, 12
	fst	%f0, %g1, 24
	fmov	%f0, %f1
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g3, 0
	fld	%f0, %g1, 20
	ld	%g29, %g1, 4
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g3, -8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	read_float.2679
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	return
rotate_quadratic_matrix.2847:
	ld	%g5, %g29, -8
	ld	%g29, %g29, -4
	fld	%f0, %g4, 0
	st	%g3, %g1, 0
	st	%g29, %g1, 4
	st	%g5, %g1, 8
	st	%g4, %g1, 12
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	fld	%f1, %g3, 0
	ld	%g29, %g1, 8
	fst	%f0, %g1, 16
	fmov	%f0, %f1
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	fld	%f1, %g3, -4
	ld	%g29, %g1, 4
	fst	%f0, %g1, 20
	fmov	%f0, %f1
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 12
	fld	%f1, %g3, -4
	ld	%g29, %g1, 8
	fst	%f0, %g1, 24
	fmov	%f0, %f1
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 12
	fld	%f1, %g3, -8
	ld	%g29, %g1, 4
	fst	%f0, %g1, 28
	fmov	%f0, %f1
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 12
	fld	%f1, %g3, -8
	ld	%g29, %g1, 8
	fst	%f0, %g1, 32
	fmov	%f0, %f1
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fld	%f2, %g1, 24
	fmul	%f3, %f2, %f1
	fld	%f4, %g1, 28
	fld	%f5, %g1, 20
	fmul	%f6, %f5, %f4
	fmul	%f6, %f6, %f1
	fld	%f7, %g1, 16
	fmul	%f8, %f7, %f0
	fsub	%f6, %f6, %f8
	fmul	%f8, %f7, %f4
	fmul	%f8, %f8, %f1
	fmul	%f9, %f5, %f0
	fadd	%f8, %f8, %f9
	fmul	%f9, %f2, %f0
	fmul	%f10, %f5, %f4
	fmul	%f10, %f10, %f0
	fmul	%f11, %f7, %f1
	fadd	%f10, %f10, %f11
	fmul	%f11, %f7, %f4
	fmul	%f0, %f11, %f0
	fmul	%f1, %f5, %f1
	fsub	%f0, %f0, %f1
	fst	%f0, %g1, 36
	fst	%f8, %g1, 40
	fst	%f10, %g1, 44
	fst	%f6, %g1, 48
	fst	%f9, %g1, 52
	fst	%f3, %g1, 56
	fmov	%f0, %f4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fneg.2660
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 24
	fld	%f2, %g1, 20
	fmul	%f2, %f2, %f1
	fld	%f3, %g1, 16
	fmul	%f1, %f3, %f1
	ld	%g3, %g1, 0
	fld	%f3, %g3, 0
	fld	%f4, %g3, -4
	fld	%f5, %g3, -8
	fld	%f6, %g1, 56
	fst	%f1, %g1, 60
	fst	%f2, %g1, 64
	fst	%f5, %g1, 68
	fst	%f0, %g1, 72
	fst	%f4, %g1, 76
	fst	%f3, %g1, 80
	fmov	%f0, %f6
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	fsqr.2664
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fld	%f1, %g1, 80
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 52
	fst	%f0, %g1, 84
	fmov	%f0, %f2
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	fsqr.2664
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	fld	%f1, %g1, 76
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 84
	fadd	%f0, %f2, %f0
	fld	%f2, %g1, 72
	fst	%f0, %g1, 88
	fmov	%f0, %f2
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	fsqr.2664
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	fld	%f1, %g1, 68
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 88
	fadd	%f0, %f2, %f0
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	fld	%f0, %g1, 48
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	fsqr.2664
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	fld	%f1, %g1, 80
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 44
	fst	%f0, %g1, 92
	fmov	%f0, %f2
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	fsqr.2664
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	fld	%f1, %g1, 76
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 92
	fadd	%f0, %f2, %f0
	fld	%f2, %g1, 64
	fst	%f0, %g1, 96
	fmov	%f0, %f2
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	fsqr.2664
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	fld	%f1, %g1, 68
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 96
	fadd	%f0, %f2, %f0
	ld	%g3, %g1, 0
	fst	%f0, %g3, -4
	fld	%f0, %g1, 40
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	fsqr.2664
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	fld	%f1, %g1, 80
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 36
	fst	%f0, %g1, 100
	fmov	%f0, %f2
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	fsqr.2664
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	fld	%f1, %g1, 76
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 100
	fadd	%f0, %f2, %f0
	fld	%f2, %g1, 60
	fst	%f0, %g1, 104
	fmov	%f0, %f2
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	fsqr.2664
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	fld	%f1, %g1, 68
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 104
	fadd	%f0, %f2, %f0
	ld	%g3, %g1, 0
	fst	%f0, %g3, -8
	setL %g3, l.6515
	fld	%f0, %g3, 0
	fld	%f2, %g1, 48
	fld	%f3, %g1, 80
	fmul	%f4, %f3, %f2
	fld	%f5, %g1, 40
	fmul	%f4, %f4, %f5
	fld	%f6, %g1, 44
	fld	%f7, %g1, 76
	fmul	%f8, %f7, %f6
	fld	%f9, %g1, 36
	fmul	%f8, %f8, %f9
	fadd	%f4, %f4, %f8
	fld	%f8, %g1, 64
	fmul	%f10, %f1, %f8
	fld	%f11, %g1, 60
	fmul	%f10, %f10, %f11
	fadd	%f4, %f4, %f10
	fmul	%f0, %f0, %f4
	ld	%g3, %g1, 12
	fst	%f0, %g3, 0
	setL %g4, l.6515
	fld	%f0, %g4, 0
	fld	%f4, %g1, 56
	fmul	%f10, %f3, %f4
	fmul	%f5, %f10, %f5
	fld	%f10, %g1, 52
	fmul	%f12, %f7, %f10
	fmul	%f9, %f12, %f9
	fadd	%f5, %f5, %f9
	fld	%f9, %g1, 72
	fmul	%f12, %f1, %f9
	fmul	%f11, %f12, %f11
	fadd	%f5, %f5, %f11
	fmul	%f0, %f0, %f5
	fst	%f0, %g3, -4
	setL %g4, l.6515
	fld	%f0, %g4, 0
	fmul	%f3, %f3, %f4
	fmul	%f2, %f3, %f2
	fmul	%f3, %f7, %f10
	fmul	%f3, %f3, %f6
	fadd	%f2, %f2, %f3
	fmul	%f1, %f1, %f9
	fmul	%f1, %f1, %f8
	fadd	%f1, %f2, %f1
	fmul	%f0, %f0, %f1
	fst	%f0, %g3, -8
	return
read_nth_object.2850:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	st	%g4, %g1, 0
	st	%g5, %g1, 4
	st	%g3, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	read_int.2677
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 65535
	mvlo	%g4, -1
	jne	%g3, %g4, jeq_else.9985
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9985:
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	read_int.2677
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	read_int.2677
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	read_int.2677
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_create_float_array
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	st	%g3, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	read_float.2679
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	fst	%f0, %g3, 0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	read_float.2679
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	fst	%f0, %g3, -4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	read_float.2679
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	fst	%f0, %g3, -8
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_create_float_array
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	st	%g3, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	read_float.2679
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	fst	%f0, %g3, 0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	read_float.2679
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	fst	%f0, %g3, -4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	read_float.2679
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	fst	%f0, %g3, -8
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	read_float.2679
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fisneg.2651
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 2
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 36
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	st	%g3, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	read_float.2679
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 40
	fst	%f0, %g3, 0
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	read_float.2679
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 40
	fst	%f0, %g3, -4
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	st	%g3, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	read_float.2679
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 44
	fst	%f0, %g3, 0
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	read_float.2679
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 44
	fst	%f0, %g3, -4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	read_float.2679
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 44
	fst	%f0, %g3, -8
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	min_caml_create_float_array
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g5, %g1, 24
	jne	%g5, %g4, jeq_else.9986
	jmp	jeq_cont.9987
jeq_else.9986:
	st	%g3, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	read_float.2679
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	rad.2841
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 48
	fst	%f0, %g3, 0
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	read_float.2679
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	rad.2841
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 48
	fst	%f0, %g3, -4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	read_float.2679
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	rad.2841
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 48
	fst	%f0, %g3, -8
jeq_cont.9987:
	mvhi	%g4, 0
	mvlo	%g4, 2
	ld	%g5, %g1, 16
	jne	%g5, %g4, jeq_else.9988
	mvhi	%g4, 0
	mvlo	%g4, 1
	jmp	jeq_cont.9989
jeq_else.9988:
	ld	%g4, %g1, 36
jeq_cont.9989:
	mvhi	%g6, 0
	mvlo	%g6, 4
	setL %g7, l.6510
	fld	%f0, %g7, 0
	st	%g4, %g1, 52
	st	%g3, %g1, 48
	mov	%g3, %g6
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	min_caml_create_float_array
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g2
	addi	%g2, %g2, 48
	st	%g3, %g4, -40
	ld	%g3, %g1, 48
	st	%g3, %g4, -36
	ld	%g5, %g1, 44
	st	%g5, %g4, -32
	ld	%g5, %g1, 40
	st	%g5, %g4, -28
	ld	%g5, %g1, 52
	st	%g5, %g4, -24
	ld	%g5, %g1, 32
	st	%g5, %g4, -20
	ld	%g5, %g1, 28
	st	%g5, %g4, -16
	ld	%g6, %g1, 24
	st	%g6, %g4, -12
	ld	%g7, %g1, 20
	st	%g7, %g4, -8
	ld	%g7, %g1, 16
	st	%g7, %g4, -4
	ld	%g8, %g1, 12
	st	%g8, %g4, 0
	ld	%g8, %g1, 8
	slli	%g8, %g8, 2
	ld	%g9, %g1, 4
	st	%g9, %g1, 60
	add	%g9, %g9, %g8
	st	%g4, %g9, 0
	ld	%g9, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 3
	jne	%g7, %g4, jeq_else.9990
	fld	%f0, %g5, 0
	fst	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fiszero.2653
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9992
	fld	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	sgn.2716
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 56
	fst	%f0, %g1, 60
	fmov	%f0, %f1
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fsqr.2664
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 60
	fdiv	%f0, %f1, %f0
	jmp	jeq_cont.9993
jeq_else.9992:
	setL %g3, l.6510
	fld	%f0, %g3, 0
jeq_cont.9993:
	ld	%g3, %g1, 28
	fst	%f0, %g3, 0
	fld	%f0, %g3, -4
	fst	%f0, %g1, 64
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fiszero.2653
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9994
	fld	%f0, %g1, 64
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	sgn.2716
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 64
	fst	%f0, %g1, 68
	fmov	%f0, %f1
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fsqr.2664
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 68
	fdiv	%f0, %f1, %f0
	jmp	jeq_cont.9995
jeq_else.9994:
	setL %g3, l.6510
	fld	%f0, %g3, 0
jeq_cont.9995:
	ld	%g3, %g1, 28
	fst	%f0, %g3, -4
	fld	%f0, %g3, -8
	fst	%f0, %g1, 72
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fiszero.2653
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9996
	fld	%f0, %g1, 72
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	sgn.2716
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 72
	fst	%f0, %g1, 76
	fmov	%f0, %f1
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	fsqr.2664
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fld	%f1, %g1, 76
	fdiv	%f0, %f1, %f0
	jmp	jeq_cont.9997
jeq_else.9996:
	setL %g3, l.6510
	fld	%f0, %g3, 0
jeq_cont.9997:
	ld	%g3, %g1, 28
	fst	%f0, %g3, -8
	jmp	jeq_cont.9991
jeq_else.9990:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g7, %g4, jeq_else.9998
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g7, %g1, 36
	jne	%g7, %g4, jeq_else.10000
	mvhi	%g4, 0
	mvlo	%g4, 1
	jmp	jeq_cont.10001
jeq_else.10000:
	mvhi	%g4, 0
	mvlo	%g4, 0
jeq_cont.10001:
	mov	%g3, %g5
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	vecunit_sgn.2742
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	jmp	jeq_cont.9999
jeq_else.9998:
jeq_cont.9999:
jeq_cont.9991:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 24
	jne	%g4, %g3, jeq_else.10002
	jmp	jeq_cont.10003
jeq_else.10002:
	ld	%g3, %g1, 28
	ld	%g4, %g1, 48
	ld	%g29, %g1, 0
	st	%g31, %g1, 84
	ld	%g28, %g29, 0
	subi	%g1, %g1, 88
	callR	%g28
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
jeq_cont.10003:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
read_object.2852:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 60
	jlt	%g3, %g6, jle_else.10004
	return
jle_else.10004:
	st	%g29, %g1, 0
	st	%g5, %g1, 4
	st	%g3, %g1, 8
	mov	%g29, %g4
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10006
	ld	%g3, %g1, 4
	ld	%g4, %g1, 8
	st	%g4, %g3, 0
	return
jeq_else.10006:
	ld	%g3, %g1, 8
	addi	%g3, %g3, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
read_all_object.2854:
	ld	%g29, %g29, -4
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g28, %g29, 0
	b	%g28
read_net_item.2856:
	st	%g3, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	read_int.2677
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 65535
	mvlo	%g4, -1
	jne	%g3, %g4, jeq_else.10008
	ld	%g3, %g1, 0
	addi	%g3, %g3, 1
	mvhi	%g4, 65535
	mvlo	%g4, -1
	jmp	min_caml_create_array
jeq_else.10008:
	ld	%g4, %g1, 0
	addi	%g5, %g4, 1
	st	%g3, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	read_net_item.2856
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 0
	slli	%g4, %g4, 2
	ld	%g5, %g1, 4
	st	%g3, %g1, 12
	add	%g3, %g3, %g4
	st	%g5, %g3, 0
	ld	%g3, %g1, 12
	return
read_or_network.2858:
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g3, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	read_net_item.2856
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g4, %g3
	ld	%g3, %g4, 0
	mvhi	%g5, 65535
	mvlo	%g5, -1
	jne	%g3, %g5, jeq_else.10009
	ld	%g3, %g1, 0
	addi	%g3, %g3, 1
	jmp	min_caml_create_array
jeq_else.10009:
	ld	%g3, %g1, 0
	addi	%g5, %g3, 1
	st	%g4, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	read_or_network.2858
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 0
	slli	%g4, %g4, 2
	ld	%g5, %g1, 4
	st	%g3, %g1, 12
	add	%g3, %g3, %g4
	st	%g5, %g3, 0
	ld	%g3, %g1, 12
	return
read_and_network.2860:
	ld	%g4, %g29, -4
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g29, %g1, 0
	st	%g4, %g1, 4
	st	%g3, %g1, 8
	mov	%g3, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	read_net_item.2856
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g3, 0
	mvhi	%g5, 65535
	mvlo	%g5, -1
	jne	%g4, %g5, jeq_else.10010
	return
jeq_else.10010:
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
read_parameter.2862:
	ld	%g3, %g29, -20
	ld	%g4, %g29, -16
	ld	%g5, %g29, -12
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	st	%g7, %g1, 0
	st	%g5, %g1, 4
	st	%g6, %g1, 8
	st	%g4, %g1, 12
	mov	%g29, %g3
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g29, %g1, 12
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g29, %g1, 8
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 4
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g3, 0
	mvlo	%g3, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	read_or_network.2858
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 0
	st	%g3, %g4, 0
	return
solver_rect_surface.2864:
	ld	%g8, %g29, -4
	slli	%g9, %g5, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g9
	fld	%f3, %g4, 0
	ld	%g4, %g1, 4
	st	%g8, %g1, 0
	fst	%f2, %g1, 4
	st	%g7, %g1, 8
	fst	%f1, %g1, 12
	st	%g6, %g1, 16
	fst	%f0, %g1, 20
	st	%g4, %g1, 24
	st	%g5, %g1, 28
	st	%g3, %g1, 32
	fmov	%f0, %f3
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fiszero.2653
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10013
	ld	%g3, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_abc.2786
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 32
	st	%g3, %g1, 36
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_isinvert.2776
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 28
	slli	%g5, %g4, 2
	ld	%g6, %g1, 24
	st	%g6, %g1, 44
	add	%g6, %g6, %g5
	fld	%f0, %g6, 0
	ld	%g6, %g1, 44
	st	%g3, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fisneg.2651
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mov	%g4, %g3
	ld	%g3, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	xor.2713
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 28
	slli	%g5, %g4, 2
	ld	%g6, %g1, 36
	st	%g6, %g1, 44
	add	%g6, %g6, %g5
	fld	%f0, %g6, 0
	ld	%g6, %g1, 44
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fneg_cond.2718
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 20
	fsub	%f0, %f0, %f1
	ld	%g3, %g1, 28
	slli	%g3, %g3, 2
	ld	%g4, %g1, 24
	st	%g4, %g1, 44
	add	%g4, %g4, %g3
	fld	%f1, %g4, 0
	ld	%g4, %g1, 44
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 16
	slli	%g5, %g3, 2
	st	%g4, %g1, 44
	add	%g4, %g4, %g5
	fld	%f1, %g4, 0
	ld	%g4, %g1, 44
	fmul	%f1, %f0, %f1
	fld	%f2, %g1, 12
	fadd	%f1, %f1, %f2
	fst	%f0, %g1, 44
	fmov	%f0, %f1
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fabs.2658
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 16
	slli	%g3, %g3, 2
	ld	%g4, %g1, 36
	st	%g4, %g1, 52
	add	%g4, %g4, %g3
	fld	%f1, %g4, 0
	ld	%g4, %g1, 52
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fless.2646
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10014
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10014:
	ld	%g3, %g1, 8
	slli	%g4, %g3, 2
	ld	%g5, %g1, 24
	st	%g5, %g1, 52
	add	%g5, %g5, %g4
	fld	%f0, %g5, 0
	ld	%g5, %g1, 52
	fld	%f1, %g1, 44
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 4
	fadd	%f0, %f0, %f2
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fabs.2658
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 8
	slli	%g3, %g3, 2
	ld	%g4, %g1, 36
	st	%g4, %g1, 52
	add	%g4, %g4, %g3
	fld	%f1, %g4, 0
	ld	%g4, %g1, 52
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fless.2646
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10015
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10015:
	ld	%g3, %g1, 0
	fld	%f0, %g1, 44
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.10013:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
solver_rect.2873:
	ld	%g29, %g29, -4
	mvhi	%g5, 0
	mvlo	%g5, 0
	mvhi	%g6, 0
	mvlo	%g6, 1
	mvhi	%g7, 0
	mvlo	%g7, 2
	fst	%f0, %g1, 0
	fst	%f2, %g1, 4
	fst	%f1, %g1, 8
	st	%g4, %g1, 12
	st	%g3, %g1, 16
	st	%g29, %g1, 20
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10016
	mvhi	%g5, 0
	mvlo	%g5, 1
	mvhi	%g6, 0
	mvlo	%g6, 2
	mvhi	%g7, 0
	mvlo	%g7, 0
	fld	%f0, %g1, 8
	fld	%f1, %g1, 4
	fld	%f2, %g1, 0
	ld	%g3, %g1, 16
	ld	%g4, %g1, 12
	ld	%g29, %g1, 20
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10017
	mvhi	%g5, 0
	mvlo	%g5, 2
	mvhi	%g6, 0
	mvlo	%g6, 0
	mvhi	%g7, 0
	mvlo	%g7, 1
	fld	%f0, %g1, 4
	fld	%f1, %g1, 0
	fld	%f2, %g1, 8
	ld	%g3, %g1, 16
	ld	%g4, %g1, 12
	ld	%g29, %g1, 20
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10018
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10018:
	mvhi	%g3, 0
	mvlo	%g3, 3
	return
jeq_else.10017:
	mvhi	%g3, 0
	mvlo	%g3, 2
	return
jeq_else.10016:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
solver_surface.2879:
	ld	%g5, %g29, -4
	st	%g5, %g1, 0
	fst	%f2, %g1, 4
	fst	%f1, %g1, 8
	fst	%f0, %g1, 12
	st	%g4, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_abc.2786
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g3
	ld	%g3, %g1, 16
	st	%g4, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	veciprod.2745
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fispos.2649
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10019
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10019:
	fld	%f0, %g1, 12
	fld	%f1, %g1, 8
	fld	%f2, %g1, 4
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	veciprod2.2748
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fneg.2660
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
quadratic.2885:
	fst	%f0, %g1, 0
	fst	%f2, %g1, 4
	fst	%f1, %g1, 8
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fsqr.2664
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_a.2780
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 16
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 8
	fst	%f0, %g1, 20
	fmov	%f0, %f1
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fsqr.2664
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 12
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_b.2782
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 20
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 4
	fst	%f0, %g1, 28
	fmov	%f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fsqr.2664
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 12
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_c.2784
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 28
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 12
	fst	%f0, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_isrot.2778
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10020
	fld	%f0, %g1, 36
	return
jeq_else.10020:
	fld	%f0, %g1, 4
	fld	%f1, %g1, 8
	fmul	%f2, %f1, %f0
	ld	%g3, %g1, 12
	fst	%f2, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_r1.2804
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 40
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 36
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 0
	fld	%f2, %g1, 4
	fmul	%f2, %f2, %f1
	ld	%g3, %g1, 12
	fst	%f0, %g1, 44
	fst	%f2, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_r2.2806
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 48
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 44
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 8
	fld	%f2, %g1, 0
	fmul	%f1, %f2, %f1
	ld	%g3, %g1, 12
	fst	%f0, %g1, 52
	fst	%f1, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_r3.2808
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 56
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 52
	fadd	%f0, %f1, %f0
	return
bilinear.2890:
	fmul	%f6, %f0, %f3
	fst	%f3, %g1, 0
	fst	%f0, %g1, 4
	fst	%f5, %g1, 8
	fst	%f2, %g1, 12
	st	%g3, %g1, 16
	fst	%f4, %g1, 20
	fst	%f1, %g1, 24
	fst	%f6, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_a.2780
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 28
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 20
	fld	%f2, %g1, 24
	fmul	%f3, %f2, %f1
	ld	%g3, %g1, 16
	fst	%f0, %g1, 32
	fst	%f3, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_b.2782
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 32
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 8
	fld	%f2, %g1, 12
	fmul	%f3, %f2, %f1
	ld	%g3, %g1, 16
	fst	%f0, %g1, 40
	fst	%f3, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_c.2784
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 44
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 40
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_isrot.2778
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10021
	fld	%f0, %g1, 48
	return
jeq_else.10021:
	fld	%f0, %g1, 20
	fld	%f1, %g1, 12
	fmul	%f2, %f1, %f0
	fld	%f3, %g1, 8
	fld	%f4, %g1, 24
	fmul	%f5, %f4, %f3
	fadd	%f2, %f2, %f5
	ld	%g3, %g1, 16
	fst	%f2, %g1, 52
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_r1.2804
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 52
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 8
	fld	%f2, %g1, 4
	fmul	%f1, %f2, %f1
	fld	%f3, %g1, 0
	fld	%f4, %g1, 12
	fmul	%f4, %f4, %f3
	fadd	%f1, %f1, %f4
	ld	%g3, %g1, 16
	fst	%f0, %g1, 56
	fst	%f1, %g1, 60
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	o_param_r2.2806
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 60
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 56
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 20
	fld	%f2, %g1, 4
	fmul	%f1, %f2, %f1
	fld	%f2, %g1, 0
	fld	%f3, %g1, 24
	fmul	%f2, %f3, %f2
	fadd	%f1, %f1, %f2
	ld	%g3, %g1, 16
	fst	%f0, %g1, 64
	fst	%f1, %g1, 68
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	o_param_r3.2808
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 68
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 64
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fhalf.2662
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 48
	fadd	%f0, %f1, %f0
	return
solver_second.2898:
	ld	%g5, %g29, -4
	fld	%f3, %g4, 0
	fld	%f4, %g4, -4
	fld	%f5, %g4, -8
	st	%g5, %g1, 0
	fst	%f2, %g1, 4
	fst	%f1, %g1, 8
	fst	%f0, %g1, 12
	st	%g3, %g1, 16
	st	%g4, %g1, 20
	fmov	%f2, %f5
	fmov	%f1, %f4
	fmov	%f0, %f3
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	quadratic.2885
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fiszero.2653
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10022
	ld	%g3, %g1, 20
	fld	%f0, %g3, 0
	fld	%f1, %g3, -4
	fld	%f2, %g3, -8
	fld	%f3, %g1, 12
	fld	%f4, %g1, 8
	fld	%f5, %g1, 4
	ld	%g3, %g1, 16
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	bilinear.2890
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 12
	fld	%f2, %g1, 8
	fld	%f3, %g1, 4
	ld	%g3, %g1, 16
	fst	%f0, %g1, 28
	fmov	%f0, %f1
	fmov	%f1, %f2
	fmov	%f2, %f3
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	quadratic.2885
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 16
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_form.2772
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 3
	jne	%g3, %g4, jeq_else.10023
	setL %g3, l.6519
	fld	%f0, %g3, 0
	fld	%f1, %g1, 32
	fsub	%f0, %f1, %f0
	jmp	jeq_cont.10024
jeq_else.10023:
	fld	%f0, %g1, 32
jeq_cont.10024:
	fld	%f1, %g1, 28
	fst	%f0, %g1, 36
	fmov	%f0, %f1
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fsqr.2664
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fld	%f2, %g1, 24
	fmul	%f1, %f2, %f1
	fsub	%f0, %f0, %f1
	fst	%f0, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fispos.2649
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10025
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10025:
	fld	%f0, %g1, 40
	fsqrt	%f0, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_isinvert.2776
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10026
	fld	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2660
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	jmp	jeq_cont.10027
jeq_else.10026:
	fld	%f0, %g1, 44
jeq_cont.10027:
	fld	%f1, %g1, 28
	fsub	%f0, %f0, %f1
	fld	%f1, %g1, 24
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.10022:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
solver.2904:
	ld	%g6, %g29, -16
	ld	%g7, %g29, -12
	ld	%g8, %g29, -8
	ld	%g9, %g29, -4
	slli	%g3, %g3, 2
	st	%g9, %g1, 4
	add	%g9, %g9, %g3
	ld	%g3, %g9, 0
	ld	%g9, %g1, 4
	fld	%f0, %g5, 0
	st	%g7, %g1, 0
	st	%g6, %g1, 4
	st	%g4, %g1, 8
	st	%g8, %g1, 12
	st	%g3, %g1, 16
	st	%g5, %g1, 20
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_x.2788
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 20
	fld	%f1, %g3, -4
	ld	%g4, %g1, 16
	fst	%f0, %g1, 28
	fst	%f1, %g1, 32
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_y.2790
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 20
	fld	%f1, %g3, -8
	ld	%g3, %g1, 16
	fst	%f0, %g1, 36
	fst	%f1, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_z.2792
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 40
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_form.2772
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.10028
	fld	%f0, %g1, 28
	fld	%f1, %g1, 36
	fld	%f2, %g1, 44
	ld	%g3, %g1, 16
	ld	%g4, %g1, 8
	ld	%g29, %g1, 12
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10028:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.10029
	fld	%f0, %g1, 28
	fld	%f1, %g1, 36
	fld	%f2, %g1, 44
	ld	%g3, %g1, 16
	ld	%g4, %g1, 8
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10029:
	fld	%f0, %g1, 28
	fld	%f1, %g1, 36
	fld	%f2, %g1, 44
	ld	%g3, %g1, 16
	ld	%g4, %g1, 8
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
solver_rect_fast.2908:
	ld	%g6, %g29, -4
	fld	%f3, %g5, 0
	fsub	%f3, %f3, %f0
	fld	%f4, %g5, -4
	fmul	%f3, %f3, %f4
	fld	%f4, %g4, -4
	fmul	%f4, %f3, %f4
	fadd	%f4, %f4, %f1
	st	%g6, %g1, 0
	fst	%f0, %g1, 4
	fst	%f1, %g1, 8
	st	%g5, %g1, 12
	fst	%f2, %g1, 16
	fst	%f3, %g1, 20
	st	%g4, %g1, 24
	st	%g3, %g1, 28
	fmov	%f0, %f4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fabs.2658
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_b.2782
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fless.2646
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10030
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10031
jeq_else.10030:
	ld	%g3, %g1, 24
	fld	%f0, %g3, -8
	fld	%f1, %g1, 20
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 16
	fadd	%f0, %f0, %f2
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fabs.2658
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	fst	%f0, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_c.2784
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fless.2646
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10032
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10033
jeq_else.10032:
	ld	%g3, %g1, 12
	fld	%f0, %g3, -4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fiszero.2653
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10034
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.10035
jeq_else.10034:
	mvhi	%g3, 0
	mvlo	%g3, 0
jeq_cont.10035:
jeq_cont.10033:
jeq_cont.10031:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10036
	ld	%g3, %g1, 12
	fld	%f0, %g3, -8
	fld	%f1, %g1, 8
	fsub	%f0, %f0, %f1
	fld	%f2, %g3, -12
	fmul	%f0, %f0, %f2
	ld	%g4, %g1, 24
	fld	%f2, %g4, 0
	fmul	%f2, %f0, %f2
	fld	%f3, %g1, 4
	fadd	%f2, %f2, %f3
	fst	%f0, %g1, 40
	fmov	%f0, %f2
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fabs.2658
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 28
	fst	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_a.2780
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fless.2646
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10037
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10038
jeq_else.10037:
	ld	%g3, %g1, 24
	fld	%f0, %g3, -8
	fld	%f1, %g1, 40
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 16
	fadd	%f0, %f0, %f2
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fabs.2658
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 28
	fst	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_c.2784
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fless.2646
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10039
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10040
jeq_else.10039:
	ld	%g3, %g1, 12
	fld	%f0, %g3, -12
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fiszero.2653
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10041
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.10042
jeq_else.10041:
	mvhi	%g3, 0
	mvlo	%g3, 0
jeq_cont.10042:
jeq_cont.10040:
jeq_cont.10038:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10043
	ld	%g3, %g1, 12
	fld	%f0, %g3, -16
	fld	%f1, %g1, 16
	fsub	%f0, %f0, %f1
	fld	%f1, %g3, -20
	fmul	%f0, %f0, %f1
	ld	%g4, %g1, 24
	fld	%f1, %g4, 0
	fmul	%f1, %f0, %f1
	fld	%f2, %g1, 4
	fadd	%f1, %f1, %f2
	fst	%f0, %g1, 52
	fmov	%f0, %f1
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fabs.2658
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 28
	fst	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_a.2780
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fless.2646
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10044
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10045
jeq_else.10044:
	ld	%g3, %g1, 24
	fld	%f0, %g3, -4
	fld	%f1, %g1, 52
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 8
	fadd	%f0, %f0, %f2
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fabs.2658
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 28
	fst	%f0, %g1, 60
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	o_param_b.2782
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 60
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fless.2646
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10046
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10047
jeq_else.10046:
	ld	%g3, %g1, 12
	fld	%f0, %g3, -20
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fiszero.2653
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10048
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.10049
jeq_else.10048:
	mvhi	%g3, 0
	mvlo	%g3, 0
jeq_cont.10049:
jeq_cont.10047:
jeq_cont.10045:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10050
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10050:
	ld	%g3, %g1, 0
	fld	%f0, %g1, 52
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 3
	return
jeq_else.10043:
	ld	%g3, %g1, 0
	fld	%f0, %g1, 40
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 2
	return
jeq_else.10036:
	ld	%g3, %g1, 0
	fld	%f0, %g1, 20
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
solver_surface_fast.2915:
	ld	%g3, %g29, -4
	fld	%f3, %g4, 0
	st	%g3, %g1, 0
	fst	%f2, %g1, 4
	fst	%f1, %g1, 8
	fst	%f0, %g1, 12
	st	%g4, %g1, 16
	fmov	%f0, %f3
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fisneg.2651
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10051
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10051:
	ld	%g3, %g1, 16
	fld	%f0, %g3, -4
	fld	%f1, %g1, 12
	fmul	%f0, %f0, %f1
	fld	%f1, %g3, -8
	fld	%f2, %g1, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, -12
	fld	%f2, %g1, 4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
solver_second_fast.2921:
	ld	%g5, %g29, -4
	fld	%f3, %g4, 0
	st	%g5, %g1, 0
	fst	%f3, %g1, 4
	st	%g3, %g1, 8
	fst	%f2, %g1, 12
	fst	%f1, %g1, 16
	fst	%f0, %g1, 20
	st	%g4, %g1, 24
	fmov	%f0, %f3
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fiszero.2653
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10052
	ld	%g3, %g1, 24
	fld	%f0, %g3, -4
	fld	%f1, %g1, 20
	fmul	%f0, %f0, %f1
	fld	%f2, %g3, -8
	fld	%f3, %g1, 16
	fmul	%f2, %f2, %f3
	fadd	%f0, %f0, %f2
	fld	%f2, %g3, -12
	fld	%f4, %g1, 12
	fmul	%f2, %f2, %f4
	fadd	%f0, %f0, %f2
	ld	%g4, %g1, 8
	fst	%f0, %g1, 28
	mov	%g3, %g4
	fmov	%f2, %f4
	fmov	%f0, %f1
	fmov	%f1, %f3
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	quadratic.2885
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 8
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_form.2772
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 3
	jne	%g3, %g4, jeq_else.10053
	setL %g3, l.6519
	fld	%f0, %g3, 0
	fld	%f1, %g1, 32
	fsub	%f0, %f1, %f0
	jmp	jeq_cont.10054
jeq_else.10053:
	fld	%f0, %g1, 32
jeq_cont.10054:
	fld	%f1, %g1, 28
	fst	%f0, %g1, 36
	fmov	%f0, %f1
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fsqr.2664
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fld	%f2, %g1, 4
	fmul	%f1, %f2, %f1
	fsub	%f0, %f0, %f1
	fst	%f0, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fispos.2649
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10055
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10055:
	ld	%g3, %g1, 8
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_isinvert.2776
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10056
	fld	%f0, %g1, 40
	fsqrt	%f0, %f0
	fld	%f1, %g1, 28
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 24
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	jmp	jeq_cont.10057
jeq_else.10056:
	fld	%f0, %g1, 40
	fsqrt	%f0, %f0
	fld	%f1, %g1, 28
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 24
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
jeq_cont.10057:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.10052:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
solver_fast.2927:
	ld	%g6, %g29, -16
	ld	%g7, %g29, -12
	ld	%g8, %g29, -8
	ld	%g9, %g29, -4
	slli	%g10, %g3, 2
	st	%g9, %g1, 4
	add	%g9, %g9, %g10
	ld	%g9, %g9, 0
	fld	%f0, %g5, 0
	st	%g7, %g1, 0
	st	%g6, %g1, 4
	st	%g8, %g1, 8
	st	%g3, %g1, 12
	st	%g4, %g1, 16
	st	%g9, %g1, 20
	st	%g5, %g1, 24
	fst	%f0, %g1, 28
	mov	%g3, %g9
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_x.2788
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 28
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 24
	fld	%f1, %g3, -4
	ld	%g4, %g1, 20
	fst	%f0, %g1, 32
	fst	%f1, %g1, 36
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_y.2790
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 24
	fld	%f1, %g3, -8
	ld	%g3, %g1, 20
	fst	%f0, %g1, 40
	fst	%f1, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_z.2792
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 44
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	d_const.2833
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g4, %g1, 12
	slli	%g4, %g4, 2
	st	%g3, %g1, 52
	add	%g3, %g3, %g4
	ld	%g3, %g3, 0
	ld	%g4, %g1, 20
	st	%g3, %g1, 52
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_form.2772
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.10058
	ld	%g3, %g1, 16
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	d_vec.2831
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g3
	fld	%f0, %g1, 32
	fld	%f1, %g1, 40
	fld	%f2, %g1, 48
	ld	%g3, %g1, 20
	ld	%g5, %g1, 52
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10058:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.10059
	fld	%f0, %g1, 32
	fld	%f1, %g1, 40
	fld	%f2, %g1, 48
	ld	%g3, %g1, 20
	ld	%g4, %g1, 52
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10059:
	fld	%f0, %g1, 32
	fld	%f1, %g1, 40
	fld	%f2, %g1, 48
	ld	%g3, %g1, 20
	ld	%g4, %g1, 52
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
solver_surface_fast2.2931:
	ld	%g3, %g29, -4
	fld	%f0, %g4, 0
	st	%g3, %g1, 0
	st	%g5, %g1, 4
	st	%g4, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fisneg.2651
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10060
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10060:
	ld	%g3, %g1, 8
	fld	%f0, %g3, 0
	ld	%g3, %g1, 4
	fld	%f1, %g3, -12
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
solver_second_fast2.2938:
	ld	%g6, %g29, -4
	fld	%f3, %g4, 0
	st	%g6, %g1, 0
	st	%g3, %g1, 4
	fst	%f3, %g1, 8
	st	%g5, %g1, 12
	fst	%f2, %g1, 16
	fst	%f1, %g1, 20
	fst	%f0, %g1, 24
	st	%g4, %g1, 28
	fmov	%f0, %f3
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fiszero.2653
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10061
	ld	%g3, %g1, 28
	fld	%f0, %g3, -4
	fld	%f1, %g1, 24
	fmul	%f0, %f0, %f1
	fld	%f1, %g3, -8
	fld	%f2, %g1, 20
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, -12
	fld	%f2, %g1, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	ld	%g4, %g1, 12
	fld	%f1, %g4, -12
	fst	%f0, %g1, 32
	fst	%f1, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fsqr.2664
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fld	%f2, %g1, 8
	fmul	%f1, %f2, %f1
	fsub	%f0, %f0, %f1
	fst	%f0, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fispos.2649
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10062
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10062:
	ld	%g3, %g1, 4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_isinvert.2776
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10063
	fld	%f0, %g1, 40
	fsqrt	%f0, %f0
	fld	%f1, %g1, 32
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 28
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	jmp	jeq_cont.10064
jeq_else.10063:
	fld	%f0, %g1, 40
	fsqrt	%f0, %f0
	fld	%f1, %g1, 32
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 28
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
jeq_cont.10064:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.10061:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
solver_fast2.2945:
	ld	%g5, %g29, -16
	ld	%g6, %g29, -12
	ld	%g7, %g29, -8
	ld	%g8, %g29, -4
	slli	%g9, %g3, 2
	st	%g8, %g1, 4
	add	%g8, %g8, %g9
	ld	%g8, %g8, 0
	st	%g6, %g1, 0
	st	%g5, %g1, 4
	st	%g7, %g1, 8
	st	%g8, %g1, 12
	st	%g3, %g1, 16
	st	%g4, %g1, 20
	mov	%g3, %g8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_ctbl.2810
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f0, %g3, 0
	fld	%f1, %g3, -4
	fld	%f2, %g3, -8
	ld	%g4, %g1, 20
	st	%g3, %g1, 24
	fst	%f2, %g1, 28
	fst	%f1, %g1, 32
	fst	%f0, %g1, 36
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	d_const.2833
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 16
	slli	%g4, %g4, 2
	st	%g3, %g1, 44
	add	%g3, %g3, %g4
	ld	%g3, %g3, 0
	ld	%g4, %g1, 12
	st	%g3, %g1, 40
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_form.2772
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.10065
	ld	%g3, %g1, 20
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	d_vec.2831
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mov	%g4, %g3
	fld	%f0, %g1, 36
	fld	%f1, %g1, 32
	fld	%f2, %g1, 28
	ld	%g3, %g1, 12
	ld	%g5, %g1, 40
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10065:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.10066
	fld	%f0, %g1, 36
	fld	%f1, %g1, 32
	fld	%f2, %g1, 28
	ld	%g3, %g1, 12
	ld	%g4, %g1, 40
	ld	%g5, %g1, 24
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10066:
	fld	%f0, %g1, 36
	fld	%f1, %g1, 32
	fld	%f2, %g1, 28
	ld	%g3, %g1, 12
	ld	%g4, %g1, 40
	ld	%g5, %g1, 24
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
setup_rect_table.2948:
	mvhi	%g5, 0
	mvlo	%g5, 6
	setL %g6, l.6510
	fld	%f0, %g6, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	fld	%f0, %g4, 0
	st	%g3, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fiszero.2653
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10067
	ld	%g3, %g1, 0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_isinvert.2776
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	fld	%f0, %g4, 0
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fisneg.2651
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g3
	ld	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	xor.2713
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 0
	st	%g3, %g1, 16
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_a.2780
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fneg_cond.2718
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 8
	fst	%f0, %g3, 0
	setL %g4, l.6519
	fld	%f0, %g4, 0
	ld	%g4, %g1, 4
	fld	%f1, %g4, 0
	fdiv	%f0, %f0, %f1
	fst	%f0, %g3, -4
	jmp	jeq_cont.10068
jeq_else.10067:
	setL %g3, l.6510
	fld	%f0, %g3, 0
	ld	%g3, %g1, 8
	fst	%f0, %g3, -4
jeq_cont.10068:
	ld	%g4, %g1, 4
	fld	%f0, %g4, -4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fiszero.2653
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10069
	ld	%g3, %g1, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_isinvert.2776
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 4
	fld	%f0, %g4, -4
	st	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fisneg.2651
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g3
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	xor.2713
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 0
	st	%g3, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_b.2782
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fneg_cond.2718
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 8
	fst	%f0, %g3, -8
	setL %g4, l.6519
	fld	%f0, %g4, 0
	ld	%g4, %g1, 4
	fld	%f1, %g4, -4
	fdiv	%f0, %f0, %f1
	fst	%f0, %g3, -12
	jmp	jeq_cont.10070
jeq_else.10069:
	setL %g3, l.6510
	fld	%f0, %g3, 0
	ld	%g3, %g1, 8
	fst	%f0, %g3, -12
jeq_cont.10070:
	ld	%g4, %g1, 4
	fld	%f0, %g4, -8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fiszero.2653
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10071
	ld	%g3, %g1, 0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_isinvert.2776
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 4
	fld	%f0, %g4, -8
	st	%g3, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fisneg.2651
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g4, %g3
	ld	%g3, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	xor.2713
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 0
	st	%g3, %g1, 32
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_c.2784
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg_cond.2718
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 8
	fst	%f0, %g3, -16
	setL %g4, l.6519
	fld	%f0, %g4, 0
	ld	%g4, %g1, 4
	fld	%f1, %g4, -8
	fdiv	%f0, %f0, %f1
	fst	%f0, %g3, -20
	jmp	jeq_cont.10072
jeq_else.10071:
	setL %g3, l.6510
	fld	%f0, %g3, 0
	ld	%g3, %g1, 8
	fst	%f0, %g3, -20
jeq_cont.10072:
	return
setup_surface_table.2951:
	mvhi	%g5, 0
	mvlo	%g5, 4
	setL %g6, l.6510
	fld	%f0, %g6, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	fld	%f0, %g4, 0
	ld	%g5, %g1, 0
	st	%g3, %g1, 8
	fst	%f0, %g1, 12
	mov	%g3, %g5
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_a.2780
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 12
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, -4
	ld	%g4, %g1, 0
	fst	%f0, %g1, 16
	fst	%f1, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_b.2782
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 20
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 16
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, -8
	ld	%g3, %g1, 0
	fst	%f0, %g1, 24
	fst	%f1, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_c.2784
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 28
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 24
	fadd	%f0, %f1, %f0
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fispos.2649
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10073
	setL %g3, l.6510
	fld	%f0, %g3, 0
	ld	%g3, %g1, 8
	fst	%f0, %g3, 0
	jmp	jeq_cont.10074
jeq_else.10073:
	setL %g3, l.6524
	fld	%f0, %g3, 0
	fld	%f1, %g1, 32
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 8
	fst	%f0, %g3, 0
	ld	%g4, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_a.2780
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fdiv	%f0, %f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2660
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 8
	fst	%f0, %g3, -4
	ld	%g4, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_b.2782
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fdiv	%f0, %f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2660
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 8
	fst	%f0, %g3, -8
	ld	%g4, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_c.2784
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fdiv	%f0, %f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2660
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 8
	fst	%f0, %g3, -12
jeq_cont.10074:
	return
setup_second_table.2954:
	mvhi	%g5, 0
	mvlo	%g5, 5
	setL %g6, l.6510
	fld	%f0, %g6, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	fld	%f0, %g4, 0
	fld	%f1, %g4, -4
	fld	%f2, %g4, -8
	ld	%g5, %g1, 0
	st	%g3, %g1, 8
	mov	%g3, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	quadratic.2885
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	fld	%f1, %g3, 0
	ld	%g4, %g1, 0
	fst	%f0, %g1, 12
	fst	%f1, %g1, 16
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_a.2780
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 16
	fmul	%f0, %f1, %f0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fneg.2660
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 4
	fld	%f1, %g3, -4
	ld	%g4, %g1, 0
	fst	%f0, %g1, 20
	fst	%f1, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_b.2782
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fneg.2660
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 4
	fld	%f1, %g3, -8
	ld	%g4, %g1, 0
	fst	%f0, %g1, 28
	fst	%f1, %g1, 32
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_c.2784
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fmul	%f0, %f1, %f0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2660
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 8
	fld	%f1, %g1, 12
	fst	%f1, %g3, 0
	ld	%g4, %g1, 0
	fst	%f0, %g1, 36
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_isrot.2778
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10075
	ld	%g3, %g1, 8
	fld	%f0, %g1, 20
	fst	%f0, %g3, -4
	fld	%f0, %g1, 28
	fst	%f0, %g3, -8
	fld	%f0, %g1, 36
	fst	%f0, %g3, -12
	jmp	jeq_cont.10076
jeq_else.10075:
	ld	%g3, %g1, 4
	fld	%f0, %g3, -8
	ld	%g4, %g1, 0
	fst	%f0, %g1, 40
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_r2.2806
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 40
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, -4
	ld	%g4, %g1, 0
	fst	%f0, %g1, 44
	fst	%f1, %g1, 48
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_r3.2808
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 48
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 44
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fhalf.2662
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 20
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g3, -4
	ld	%g4, %g1, 4
	fld	%f0, %g4, -8
	ld	%g5, %g1, 0
	fst	%f0, %g1, 52
	mov	%g3, %g5
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_r1.2804
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 52
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, 0
	ld	%g4, %g1, 0
	fst	%f0, %g1, 56
	fst	%f1, %g1, 60
	mov	%g3, %g4
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	o_param_r3.2808
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 60
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 56
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fhalf.2662
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 28
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g3, -8
	ld	%g4, %g1, 4
	fld	%f0, %g4, -4
	ld	%g5, %g1, 0
	fst	%f0, %g1, 64
	mov	%g3, %g5
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	o_param_r1.2804
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 64
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, 0
	ld	%g3, %g1, 0
	fst	%f0, %g1, 68
	fst	%f1, %g1, 72
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	o_param_r2.2806
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 72
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 68
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fhalf.2662
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 36
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g3, -12
jeq_cont.10076:
	fld	%f0, %g1, 12
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fiszero.2653
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10077
	setL %g3, l.6519
	fld	%f0, %g3, 0
	fld	%f1, %g1, 12
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 8
	fst	%f0, %g3, -16
	jmp	jeq_cont.10078
jeq_else.10077:
jeq_cont.10078:
	ld	%g3, %g1, 8
	return
iter_setup_dirvec_constants.2957:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g4, %g6, jle_else.10079
	slli	%g6, %g4, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g6
	ld	%g5, %g5, 0
	st	%g29, %g1, 0
	st	%g4, %g1, 4
	st	%g5, %g1, 8
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	d_const.2833
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 12
	st	%g3, %g1, 16
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	d_vec.2831
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	st	%g3, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_form.2772
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.10080
	ld	%g3, %g1, 20
	ld	%g4, %g1, 8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	setup_rect_table.2948
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 4
	slli	%g5, %g4, 2
	ld	%g6, %g1, 16
	st	%g6, %g1, 28
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 28
	jmp	jeq_cont.10081
jeq_else.10080:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.10082
	ld	%g3, %g1, 20
	ld	%g4, %g1, 8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	setup_surface_table.2951
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 4
	slli	%g5, %g4, 2
	ld	%g6, %g1, 16
	st	%g6, %g1, 28
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 28
	jmp	jeq_cont.10083
jeq_else.10082:
	ld	%g3, %g1, 20
	ld	%g4, %g1, 8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	setup_second_table.2954
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 4
	slli	%g5, %g4, 2
	ld	%g6, %g1, 16
	st	%g6, %g1, 28
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 28
jeq_cont.10083:
jeq_cont.10081:
	subi	%g4, %g4, 1
	ld	%g3, %g1, 12
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10079:
	return
setup_dirvec_constants.2960:
	ld	%g4, %g29, -8
	ld	%g29, %g29, -4
	ld	%g4, %g4, 0
	subi	%g4, %g4, 1
	ld	%g28, %g29, 0
	b	%g28
setup_startp_constants.2962:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g4, %g6, jle_else.10085
	slli	%g6, %g4, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g6
	ld	%g5, %g5, 0
	st	%g29, %g1, 0
	st	%g4, %g1, 4
	st	%g3, %g1, 8
	st	%g5, %g1, 12
	mov	%g3, %g5
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_ctbl.2810
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 12
	st	%g3, %g1, 16
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_form.2772
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	fld	%f0, %g4, 0
	ld	%g5, %g1, 12
	st	%g3, %g1, 20
	fst	%f0, %g1, 24
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_x.2788
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g3, 0
	ld	%g4, %g1, 8
	fld	%f0, %g4, -4
	ld	%g5, %g1, 12
	fst	%f0, %g1, 28
	mov	%g3, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_y.2790
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 28
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g3, -4
	ld	%g4, %g1, 8
	fld	%f0, %g4, -8
	ld	%g5, %g1, 12
	fst	%f0, %g1, 32
	mov	%g3, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_z.2792
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g3, -8
	mvhi	%g4, 0
	mvlo	%g4, 2
	ld	%g5, %g1, 20
	jne	%g5, %g4, jeq_else.10086
	ld	%g4, %g1, 12
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_abc.2786
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 16
	fld	%f0, %g4, 0
	fld	%f1, %g4, -4
	fld	%f2, %g4, -8
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	veciprod2.2748
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 16
	fst	%f0, %g3, -12
	jmp	jeq_cont.10087
jeq_else.10086:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jlt	%g4, %g5, jle_else.10088
	jmp	jle_cont.10089
jle_else.10088:
	fld	%f0, %g3, 0
	fld	%f1, %g3, -4
	fld	%f2, %g3, -8
	ld	%g4, %g1, 12
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	quadratic.2885
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g3, 0
	mvlo	%g3, 3
	ld	%g4, %g1, 20
	jne	%g4, %g3, jeq_else.10090
	setL %g3, l.6519
	fld	%f1, %g3, 0
	fsub	%f0, %f0, %f1
	jmp	jeq_cont.10091
jeq_else.10090:
jeq_cont.10091:
	ld	%g3, %g1, 16
	fst	%f0, %g3, -12
jle_cont.10089:
jeq_cont.10087:
	ld	%g3, %g1, 4
	subi	%g4, %g3, 1
	ld	%g3, %g1, 8
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10085:
	return
setup_startp.2965:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	st	%g3, %g1, 0
	st	%g5, %g1, 4
	st	%g6, %g1, 8
	mov	%g28, %g4
	mov	%g4, %g3
	mov	%g3, %g28
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	veccpy.2734
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	subi	%g4, %g3, 1
	ld	%g3, %g1, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
is_rect_outside.2967:
	fst	%f2, %g1, 0
	fst	%f1, %g1, 4
	st	%g3, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fabs.2658
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 8
	fst	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_a.2780
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fless.2646
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10093
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10094
jeq_else.10093:
	fld	%f0, %g1, 4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fabs.2658
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 8
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_b.2782
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fless.2646
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10095
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10096
jeq_else.10095:
	fld	%f0, %g1, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fabs.2658
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 8
	fst	%f0, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_c.2784
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fless.2646
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
jeq_cont.10096:
jeq_cont.10094:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10097
	ld	%g3, %g1, 8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_isinvert.2776
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10098
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.10098:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10097:
	ld	%g3, %g1, 8
	jmp	o_isinvert.2776
is_plane_outside.2972:
	st	%g3, %g1, 0
	fst	%f2, %g1, 4
	fst	%f1, %g1, 8
	fst	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_abc.2786
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f0, %g1, 12
	fld	%f1, %g1, 8
	fld	%f2, %g1, 4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	veciprod2.2748
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 0
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_isinvert.2776
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f0, %g1, 16
	st	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fisneg.2651
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g3
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	xor.2713
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10099
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.10099:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
is_second_outside.2977:
	st	%g3, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	quadratic.2885
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g3, %g1, 0
	fst	%f0, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_form.2772
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 3
	jne	%g3, %g4, jeq_else.10100
	setL %g3, l.6519
	fld	%f0, %g3, 0
	fld	%f1, %g1, 4
	fsub	%f0, %f1, %f0
	jmp	jeq_cont.10101
jeq_else.10100:
	fld	%f0, %g1, 4
jeq_cont.10101:
	ld	%g3, %g1, 0
	fst	%f0, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_isinvert.2776
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f0, %g1, 8
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fisneg.2651
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g3
	ld	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	xor.2713
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10102
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.10102:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
is_outside.2982:
	fst	%f2, %g1, 0
	fst	%f1, %g1, 4
	st	%g3, %g1, 8
	fst	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_x.2788
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 12
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_y.2790
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 4
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_z.2792
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 0
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_form.2772
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.10103
	fld	%f0, %g1, 16
	fld	%f1, %g1, 20
	fld	%f2, %g1, 24
	ld	%g3, %g1, 8
	jmp	is_rect_outside.2967
jeq_else.10103:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.10104
	fld	%f0, %g1, 16
	fld	%f1, %g1, 20
	fld	%f2, %g1, 24
	ld	%g3, %g1, 8
	jmp	is_plane_outside.2972
jeq_else.10104:
	fld	%f0, %g1, 16
	fld	%f1, %g1, 20
	fld	%f2, %g1, 24
	ld	%g3, %g1, 8
	jmp	is_second_outside.2977
check_all_inside.2987:
	ld	%g5, %g29, -4
	slli	%g6, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g6
	ld	%g6, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g7, 65535
	mvlo	%g7, -1
	jne	%g6, %g7, jeq_else.10105
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.10105:
	slli	%g6, %g6, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g6
	ld	%g5, %g5, 0
	fst	%f2, %g1, 0
	fst	%f1, %g1, 4
	fst	%f0, %g1, 8
	st	%g4, %g1, 12
	st	%g29, %g1, 16
	st	%g3, %g1, 20
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	is_outside.2982
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10106
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	fld	%f0, %g1, 8
	fld	%f1, %g1, 4
	fld	%f2, %g1, 0
	ld	%g4, %g1, 12
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10106:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
shadow_check_and_group.2993:
	ld	%g5, %g29, -28
	ld	%g6, %g29, -24
	ld	%g7, %g29, -20
	ld	%g8, %g29, -16
	ld	%g9, %g29, -12
	ld	%g10, %g29, -8
	ld	%g11, %g29, -4
	slli	%g12, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g12
	ld	%g12, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g13, 65535
	mvlo	%g13, -1
	jne	%g12, %g13, jeq_else.10107
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10107:
	slli	%g12, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g12
	ld	%g12, %g4, 0
	ld	%g4, %g1, 4
	st	%g11, %g1, 0
	st	%g10, %g1, 4
	st	%g9, %g1, 8
	st	%g4, %g1, 12
	st	%g29, %g1, 16
	st	%g3, %g1, 20
	st	%g7, %g1, 24
	st	%g12, %g1, 28
	st	%g6, %g1, 32
	mov	%g4, %g8
	mov	%g3, %g12
	mov	%g29, %g5
	mov	%g5, %g10
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 32
	fld	%f0, %g4, 0
	mvhi	%g4, 0
	mvlo	%g4, 0
	fst	%f0, %g1, 36
	jne	%g3, %g4, jeq_else.10108
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10109
jeq_else.10108:
	setL %g3, l.7152
	fld	%f1, %g3, 0
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fless.2646
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
jeq_cont.10109:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10110
	ld	%g3, %g1, 28
	slli	%g3, %g3, 2
	ld	%g4, %g1, 24
	st	%g4, %g1, 44
	add	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 44
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_isinvert.2776
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10111
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10111:
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	ld	%g4, %g1, 12
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10110:
	setL %g3, l.7154
	fld	%f0, %g3, 0
	fld	%f1, %g1, 36
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	ld	%g4, %g1, 4
	fld	%f2, %g4, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g3, -4
	fmul	%f2, %f2, %f0
	fld	%f3, %g4, -4
	fadd	%f2, %f2, %f3
	fld	%f3, %g3, -8
	fmul	%f0, %f3, %f0
	fld	%f3, %g4, -8
	fadd	%f0, %f0, %f3
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 12
	ld	%g29, %g1, 0
	fmov	%f31, %f2
	fmov	%f2, %f0
	fmov	%f0, %f1
	fmov	%f1, %f31
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10112
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	ld	%g4, %g1, 12
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10112:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
shadow_check_one_or_group.2996:
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	slli	%g7, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g7
	ld	%g7, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g8, 65535
	mvlo	%g8, -1
	jne	%g7, %g8, jeq_else.10113
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10113:
	slli	%g7, %g7, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g7
	ld	%g6, %g6, 0
	mvhi	%g7, 0
	mvlo	%g7, 0
	st	%g4, %g1, 0
	st	%g29, %g1, 4
	st	%g3, %g1, 8
	mov	%g4, %g6
	mov	%g3, %g7
	mov	%g29, %g5
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10114
	ld	%g3, %g1, 8
	addi	%g3, %g3, 1
	ld	%g4, %g1, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10114:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
shadow_check_one_or_matrix.2999:
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
	ld	%g11, %g10, 0
	mvhi	%g12, 65535
	mvlo	%g12, -1
	jne	%g11, %g12, jeq_else.10115
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10115:
	mvhi	%g12, 0
	mvlo	%g12, 99
	st	%g10, %g1, 0
	st	%g7, %g1, 4
	st	%g4, %g1, 8
	st	%g29, %g1, 12
	st	%g3, %g1, 16
	jne	%g11, %g12, jeq_else.10116
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.10117
jeq_else.10116:
	st	%g6, %g1, 20
	mov	%g4, %g8
	mov	%g3, %g11
	mov	%g29, %g5
	mov	%g5, %g9
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10118
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10119
jeq_else.10118:
	ld	%g3, %g1, 20
	fld	%f0, %g3, 0
	setL %g3, l.7180
	fld	%f1, %g3, 0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fless.2646
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10120
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10121
jeq_else.10120:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 0
	ld	%g29, %g1, 4
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10122
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10123
jeq_else.10122:
	mvhi	%g3, 0
	mvlo	%g3, 1
jeq_cont.10123:
jeq_cont.10121:
jeq_cont.10119:
jeq_cont.10117:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10124
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	ld	%g4, %g1, 8
	ld	%g29, %g1, 12
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10124:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 0
	ld	%g29, %g1, 4
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10125
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	ld	%g4, %g1, 8
	ld	%g29, %g1, 12
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10125:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
solve_each_element.3002:
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
	jne	%g15, %g16, jeq_else.10126
	return
jeq_else.10126:
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
	jne	%g3, %g4, jeq_else.10128
	ld	%g3, %g1, 48
	slli	%g3, %g3, 2
	ld	%g4, %g1, 44
	st	%g4, %g1, 52
	add	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 52
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_isinvert.2776
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10129
	return
jeq_else.10129:
	ld	%g3, %g1, 40
	addi	%g3, %g3, 1
	ld	%g4, %g1, 32
	ld	%g5, %g1, 28
	ld	%g29, %g1, 36
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10128:
	ld	%g4, %g1, 24
	fld	%f1, %g4, 0
	setL %g4, l.6510
	fld	%f0, %g4, 0
	st	%g3, %g1, 52
	fst	%f1, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fless.2646
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10131
	jmp	jeq_cont.10132
jeq_else.10131:
	ld	%g3, %g1, 20
	fld	%f1, %g3, 0
	fld	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fless.2646
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10133
	jmp	jeq_cont.10134
jeq_else.10133:
	setL %g3, l.7154
	fld	%f0, %g3, 0
	fld	%f1, %g1, 56
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 28
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	ld	%g4, %g1, 16
	fld	%f2, %g4, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g3, -4
	fmul	%f2, %f2, %f0
	fld	%f3, %g4, -4
	fadd	%f2, %f2, %f3
	fld	%f3, %g3, -8
	fmul	%f3, %f3, %f0
	fld	%f4, %g4, -8
	fadd	%f3, %f3, %f4
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g5, %g1, 32
	ld	%g29, %g1, 12
	fst	%f3, %g1, 60
	fst	%f2, %g1, 64
	fst	%f1, %g1, 68
	fst	%f0, %g1, 72
	mov	%g3, %g4
	mov	%g4, %g5
	fmov	%f0, %f1
	fmov	%f1, %f2
	fmov	%f2, %f3
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10135
	jmp	jeq_cont.10136
jeq_else.10135:
	ld	%g3, %g1, 20
	fld	%f0, %g1, 72
	fst	%f0, %g3, 0
	fld	%f0, %g1, 68
	fld	%f1, %g1, 64
	fld	%f2, %g1, 60
	ld	%g3, %g1, 8
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	vecset.2724
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g3, %g1, 4
	ld	%g4, %g1, 48
	st	%g4, %g3, 0
	ld	%g3, %g1, 0
	ld	%g4, %g1, 52
	st	%g4, %g3, 0
jeq_cont.10136:
jeq_cont.10134:
jeq_cont.10132:
	ld	%g3, %g1, 40
	addi	%g3, %g3, 1
	ld	%g4, %g1, 32
	ld	%g5, %g1, 28
	ld	%g29, %g1, 36
	ld	%g28, %g29, 0
	b	%g28
solve_one_or_network.3006:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	slli	%g8, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g8
	ld	%g8, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g9, 65535
	mvlo	%g9, -1
	jne	%g8, %g9, jeq_else.10137
	return
jeq_else.10137:
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
trace_or_matrix.3010:
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
	ld	%g12, %g11, 0
	mvhi	%g13, 65535
	mvlo	%g13, -1
	jne	%g12, %g13, jeq_else.10139
	return
jeq_else.10139:
	mvhi	%g13, 0
	mvlo	%g13, 99
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g29, %g1, 8
	st	%g3, %g1, 12
	jne	%g12, %g13, jeq_else.10141
	mvhi	%g6, 0
	mvlo	%g6, 1
	mov	%g4, %g11
	mov	%g3, %g6
	mov	%g29, %g10
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	jmp	jeq_cont.10142
jeq_else.10141:
	st	%g11, %g1, 16
	st	%g10, %g1, 20
	st	%g6, %g1, 24
	st	%g8, %g1, 28
	mov	%g4, %g5
	mov	%g3, %g12
	mov	%g29, %g9
	mov	%g5, %g7
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10143
	jmp	jeq_cont.10144
jeq_else.10143:
	ld	%g3, %g1, 28
	fld	%f0, %g3, 0
	ld	%g3, %g1, 24
	fld	%f1, %g3, 0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fless.2646
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10145
	jmp	jeq_cont.10146
jeq_else.10145:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 16
	ld	%g5, %g1, 0
	ld	%g29, %g1, 20
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
jeq_cont.10146:
jeq_cont.10144:
jeq_cont.10142:
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
judge_intersection.3014:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	setL %g7, l.7219
	fld	%f0, %g7, 0
	fst	%f0, %g5, 0
	mvhi	%g7, 0
	mvlo	%g7, 0
	ld	%g6, %g6, 0
	st	%g5, %g1, 0
	mov	%g5, %g3
	mov	%g29, %g4
	mov	%g4, %g6
	mov	%g3, %g7
	st	%g31, %g1, 4
	ld	%g28, %g29, 0
	subi	%g1, %g1, 8
	callR	%g28
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g3, %g1, 0
	fld	%f1, %g3, 0
	setL %g3, l.7180
	fld	%f0, %g3, 0
	fst	%f1, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fless.2646
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10147
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10147:
	setL %g3, l.7227
	fld	%f1, %g3, 0
	fld	%f0, %g1, 4
	jmp	fless.2646
solve_each_element_fast.3016:
	ld	%g6, %g29, -36
	ld	%g7, %g29, -32
	ld	%g8, %g29, -28
	ld	%g9, %g29, -24
	ld	%g10, %g29, -20
	ld	%g11, %g29, -16
	ld	%g12, %g29, -12
	ld	%g13, %g29, -8
	ld	%g14, %g29, -4
	st	%g11, %g1, 0
	st	%g13, %g1, 4
	st	%g12, %g1, 8
	st	%g14, %g1, 12
	st	%g7, %g1, 16
	st	%g6, %g1, 20
	st	%g9, %g1, 24
	st	%g29, %g1, 28
	st	%g10, %g1, 32
	st	%g5, %g1, 36
	st	%g8, %g1, 40
	st	%g4, %g1, 44
	st	%g3, %g1, 48
	mov	%g3, %g5
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	d_vec.2831
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g4, %g1, 48
	slli	%g5, %g4, 2
	ld	%g6, %g1, 44
	st	%g6, %g1, 52
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 52
	mvhi	%g7, 65535
	mvlo	%g7, -1
	jne	%g5, %g7, jeq_else.10148
	return
jeq_else.10148:
	ld	%g7, %g1, 36
	ld	%g29, %g1, 40
	st	%g3, %g1, 52
	st	%g5, %g1, 56
	mov	%g4, %g7
	mov	%g3, %g5
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10150
	ld	%g3, %g1, 56
	slli	%g3, %g3, 2
	ld	%g4, %g1, 32
	st	%g4, %g1, 60
	add	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 60
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_isinvert.2776
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10151
	return
jeq_else.10151:
	ld	%g3, %g1, 48
	addi	%g3, %g3, 1
	ld	%g4, %g1, 44
	ld	%g5, %g1, 36
	ld	%g29, %g1, 28
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10150:
	ld	%g4, %g1, 24
	fld	%f1, %g4, 0
	setL %g4, l.6510
	fld	%f0, %g4, 0
	st	%g3, %g1, 60
	fst	%f1, %g1, 64
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fless.2646
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10153
	jmp	jeq_cont.10154
jeq_else.10153:
	ld	%g3, %g1, 20
	fld	%f1, %g3, 0
	fld	%f0, %g1, 64
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fless.2646
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10155
	jmp	jeq_cont.10156
jeq_else.10155:
	setL %g3, l.7154
	fld	%f0, %g3, 0
	fld	%f1, %g1, 64
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 52
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	ld	%g4, %g1, 16
	fld	%f2, %g4, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g3, -4
	fmul	%f2, %f2, %f0
	fld	%f3, %g4, -4
	fadd	%f2, %f2, %f3
	fld	%f3, %g3, -8
	fmul	%f3, %f3, %f0
	fld	%f4, %g4, -8
	fadd	%f3, %f3, %f4
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 44
	ld	%g29, %g1, 12
	fst	%f3, %g1, 68
	fst	%f2, %g1, 72
	fst	%f1, %g1, 76
	fst	%f0, %g1, 80
	fmov	%f0, %f1
	fmov	%f1, %f2
	fmov	%f2, %f3
	st	%g31, %g1, 84
	ld	%g28, %g29, 0
	subi	%g1, %g1, 88
	callR	%g28
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10157
	jmp	jeq_cont.10158
jeq_else.10157:
	ld	%g3, %g1, 20
	fld	%f0, %g1, 80
	fst	%f0, %g3, 0
	fld	%f0, %g1, 76
	fld	%f1, %g1, 72
	fld	%f2, %g1, 68
	ld	%g3, %g1, 8
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	vecset.2724
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	ld	%g3, %g1, 4
	ld	%g4, %g1, 56
	st	%g4, %g3, 0
	ld	%g3, %g1, 0
	ld	%g4, %g1, 60
	st	%g4, %g3, 0
jeq_cont.10158:
jeq_cont.10156:
jeq_cont.10154:
	ld	%g3, %g1, 48
	addi	%g3, %g3, 1
	ld	%g4, %g1, 44
	ld	%g5, %g1, 36
	ld	%g29, %g1, 28
	ld	%g28, %g29, 0
	b	%g28
solve_one_or_network_fast.3020:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	slli	%g8, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g8
	ld	%g8, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g9, 65535
	mvlo	%g9, -1
	jne	%g8, %g9, jeq_else.10159
	return
jeq_else.10159:
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
trace_or_matrix_fast.3024:
	ld	%g6, %g29, -16
	ld	%g7, %g29, -12
	ld	%g8, %g29, -8
	ld	%g9, %g29, -4
	slli	%g10, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g10
	ld	%g10, %g4, 0
	ld	%g4, %g1, 4
	ld	%g11, %g10, 0
	mvhi	%g12, 65535
	mvlo	%g12, -1
	jne	%g11, %g12, jeq_else.10161
	return
jeq_else.10161:
	mvhi	%g12, 0
	mvlo	%g12, 99
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g29, %g1, 8
	st	%g3, %g1, 12
	jne	%g11, %g12, jeq_else.10163
	mvhi	%g6, 0
	mvlo	%g6, 1
	mov	%g4, %g10
	mov	%g3, %g6
	mov	%g29, %g9
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	jmp	jeq_cont.10164
jeq_else.10163:
	st	%g10, %g1, 16
	st	%g9, %g1, 20
	st	%g6, %g1, 24
	st	%g8, %g1, 28
	mov	%g4, %g5
	mov	%g3, %g11
	mov	%g29, %g7
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10165
	jmp	jeq_cont.10166
jeq_else.10165:
	ld	%g3, %g1, 28
	fld	%f0, %g3, 0
	ld	%g3, %g1, 24
	fld	%f1, %g3, 0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fless.2646
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10167
	jmp	jeq_cont.10168
jeq_else.10167:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 16
	ld	%g5, %g1, 0
	ld	%g29, %g1, 20
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
jeq_cont.10168:
jeq_cont.10166:
jeq_cont.10164:
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
judge_intersection_fast.3028:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	setL %g7, l.7219
	fld	%f0, %g7, 0
	fst	%f0, %g5, 0
	mvhi	%g7, 0
	mvlo	%g7, 0
	ld	%g6, %g6, 0
	st	%g5, %g1, 0
	mov	%g5, %g3
	mov	%g29, %g4
	mov	%g4, %g6
	mov	%g3, %g7
	st	%g31, %g1, 4
	ld	%g28, %g29, 0
	subi	%g1, %g1, 8
	callR	%g28
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g3, %g1, 0
	fld	%f1, %g3, 0
	setL %g3, l.7180
	fld	%f0, %g3, 0
	fst	%f1, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fless.2646
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10169
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10169:
	setL %g3, l.7227
	fld	%f1, %g3, 0
	fld	%f0, %g1, 4
	jmp	fless.2646
get_nvector_rect.3030:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	ld	%g5, %g5, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	st	%g5, %g1, 8
	mov	%g3, %g4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	vecbzero.2732
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 8
	subi	%g4, %g3, 1
	subi	%g3, %g3, 1
	slli	%g3, %g3, 2
	ld	%g5, %g1, 4
	st	%g5, %g1, 12
	add	%g5, %g5, %g3
	fld	%f0, %g5, 0
	ld	%g5, %g1, 12
	st	%g4, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	sgn.2716
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fneg.2660
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	slli	%g3, %g3, 2
	ld	%g4, %g1, 0
	st	%g4, %g1, 20
	add	%g4, %g4, %g3
	fst	%f0, %g4, 0
	ld	%g4, %g1, 20
	return
get_nvector_plane.3032:
	ld	%g4, %g29, -4
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_param_a.2780
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fneg.2660
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	fst	%f0, %g3, 0
	ld	%g4, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_param_b.2782
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fneg.2660
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	fst	%f0, %g3, -4
	ld	%g4, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_param_c.2784
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fneg.2660
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	fst	%f0, %g3, -8
	return
get_nvector_second.3034:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	fld	%f0, %g5, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	st	%g5, %g1, 8
	fst	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_x.2788
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 12
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fld	%f1, %g3, -4
	ld	%g4, %g1, 4
	fst	%f0, %g1, 16
	fst	%f1, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_y.2790
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 20
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fld	%f1, %g3, -8
	ld	%g3, %g1, 4
	fst	%f0, %g1, 24
	fst	%f1, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_z.2792
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 28
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_a.2780
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 16
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_b.2782
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_c.2784
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 32
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_isrot.2778
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10172
	ld	%g3, %g1, 0
	fld	%f0, %g1, 36
	fst	%f0, %g3, 0
	fld	%f0, %g1, 40
	fst	%f0, %g3, -4
	fld	%f0, %g1, 44
	fst	%f0, %g3, -8
	jmp	jeq_cont.10173
jeq_else.10172:
	ld	%g3, %g1, 4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_r3.2808
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_r2.2806
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 32
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 48
	fadd	%f0, %f2, %f0
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fhalf.2662
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 36
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	ld	%g4, %g1, 4
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_r3.2808
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 16
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 52
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_r1.2804
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 32
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 52
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fhalf.2662
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 40
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 0
	fst	%f0, %g3, -4
	ld	%g4, %g1, 4
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_r2.2806
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 16
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_r1.2804
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 56
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fhalf.2662
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 44
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 0
	fst	%f0, %g3, -8
jeq_cont.10173:
	ld	%g4, %g1, 4
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_isinvert.2776
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g3
	ld	%g3, %g1, 0
	jmp	vecunit_sgn.2742
get_nvector.3036:
	ld	%g5, %g29, -12
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	st	%g5, %g1, 0
	st	%g3, %g1, 4
	st	%g7, %g1, 8
	st	%g4, %g1, 12
	st	%g6, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_form.2772
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.10174
	ld	%g3, %g1, 12
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10174:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.10175
	ld	%g3, %g1, 4
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10175:
	ld	%g3, %g1, 4
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
utexture.3039:
	ld	%g5, %g29, -12
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	st	%g7, %g1, 0
	st	%g6, %g1, 4
	st	%g4, %g1, 8
	st	%g5, %g1, 12
	st	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_texturetype.2770
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 16
	st	%g3, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_color_red.2798
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 12
	fst	%f0, %g3, 0
	ld	%g4, %g1, 16
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_color_green.2800
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 12
	fst	%f0, %g3, -4
	ld	%g4, %g1, 16
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_color_blue.2802
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 12
	fst	%f0, %g3, -8
	mvhi	%g4, 0
	mvlo	%g4, 1
	ld	%g5, %g1, 20
	jne	%g5, %g4, jeq_else.10176
	ld	%g4, %g1, 8
	fld	%f0, %g4, 0
	ld	%g5, %g1, 16
	fst	%f0, %g1, 24
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_x.2788
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fsub	%f0, %f1, %f0
	setL %g3, l.7348
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	fst	%f0, %g1, 28
	fmov	%f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_floor
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	setL %g3, l.7350
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 28
	fsub	%f0, %f1, %f0
	setL %g3, l.7329
	fld	%f1, %g3, 0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fless.2646
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 8
	fld	%f0, %g4, -8
	ld	%g4, %g1, 16
	st	%g3, %g1, 32
	fst	%f0, %g1, 36
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_z.2792
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fsub	%f0, %f1, %f0
	setL %g3, l.7348
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	fst	%f0, %g1, 40
	fmov	%f0, %f1
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_floor
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	setL %g3, l.7350
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 40
	fsub	%f0, %f1, %f0
	setL %g3, l.7329
	fld	%f1, %g3, 0
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fless.2646
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g5, %g1, 32
	jne	%g5, %g4, jeq_else.10177
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10179
	setL %g3, l.7320
	fld	%f0, %g3, 0
	jmp	jeq_cont.10180
jeq_else.10179:
	setL %g3, l.6510
	fld	%f0, %g3, 0
jeq_cont.10180:
	jmp	jeq_cont.10178
jeq_else.10177:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10181
	setL %g3, l.6510
	fld	%f0, %g3, 0
	jmp	jeq_cont.10182
jeq_else.10181:
	setL %g3, l.7320
	fld	%f0, %g3, 0
jeq_cont.10182:
jeq_cont.10178:
	ld	%g3, %g1, 12
	fst	%f0, %g3, -4
	return
jeq_else.10176:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g5, %g4, jeq_else.10184
	ld	%g4, %g1, 8
	fld	%f0, %g4, -4
	setL %g4, l.7339
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	ld	%g29, %g1, 4
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fsqr.2664
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	setL %g3, l.7320
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	ld	%g3, %g1, 12
	fst	%f1, %g3, 0
	setL %g4, l.7320
	fld	%f1, %g4, 0
	setL %g4, l.6519
	fld	%f2, %g4, 0
	fsub	%f0, %f2, %f0
	fmul	%f0, %f1, %f0
	fst	%f0, %g3, -4
	return
jeq_else.10184:
	mvhi	%g4, 0
	mvlo	%g4, 3
	jne	%g5, %g4, jeq_else.10186
	ld	%g4, %g1, 8
	fld	%f0, %g4, 0
	ld	%g5, %g1, 16
	fst	%f0, %g1, 44
	mov	%g3, %g5
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_x.2788
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 44
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fld	%f1, %g3, -8
	ld	%g3, %g1, 16
	fst	%f0, %g1, 48
	fst	%f1, %g1, 52
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_z.2792
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 52
	fsub	%f0, %f1, %f0
	fld	%f1, %g1, 48
	fst	%f0, %g1, 56
	fmov	%f0, %f1
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fsqr.2664
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 56
	fst	%f0, %g1, 60
	fmov	%f0, %f1
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fsqr.2664
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 60
	fadd	%f0, %f1, %f0
	fsqrt	%f0, %f0
	setL %g3, l.7329
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	fst	%f0, %g1, 64
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	min_caml_floor
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 64
	fsub	%f0, %f1, %f0
	setL %g3, l.7307
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	ld	%g29, %g1, 0
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fsqr.2664
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	setL %g3, l.7320
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	ld	%g3, %g1, 12
	fst	%f1, %g3, -4
	setL %g4, l.6519
	fld	%f1, %g4, 0
	fsub	%f0, %f1, %f0
	setL %g4, l.7320
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fst	%f0, %g3, -8
	return
jeq_else.10186:
	mvhi	%g4, 0
	mvlo	%g4, 4
	jne	%g5, %g4, jeq_else.10188
	ld	%g4, %g1, 8
	fld	%f0, %g4, 0
	ld	%g5, %g1, 16
	fst	%f0, %g1, 68
	mov	%g3, %g5
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	o_param_x.2788
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 68
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g1, 72
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	o_param_a.2780
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fsqrt	%f0, %f0
	fld	%f1, %g1, 72
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fld	%f1, %g3, -8
	ld	%g4, %g1, 16
	fst	%f0, %g1, 76
	fst	%f1, %g1, 80
	mov	%g3, %g4
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	o_param_z.2792
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fld	%f1, %g1, 80
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g1, 84
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	o_param_c.2784
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	fsqrt	%f0, %f0
	fld	%f1, %g1, 84
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 76
	fst	%f0, %g1, 88
	fmov	%f0, %f1
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	fsqr.2664
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	fld	%f1, %g1, 88
	fst	%f0, %g1, 92
	fmov	%f0, %f1
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	fsqr.2664
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	fld	%f1, %g1, 92
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 76
	fst	%f0, %g1, 96
	fmov	%f0, %f1
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	fabs.2658
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	setL %g3, l.7301
	fld	%f1, %g3, 0
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	fless.2646
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10189
	fld	%f0, %g1, 76
	fld	%f1, %g1, 88
	fdiv	%f0, %f1, %f0
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	fabs.2658
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	atan.2669
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	setL %g3, l.7305
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.7307
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	jmp	jeq_cont.10190
jeq_else.10189:
	setL %g3, l.7303
	fld	%f0, %g3, 0
jeq_cont.10190:
	fst	%f0, %g1, 100
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	min_caml_floor
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	fld	%f1, %g1, 100
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fld	%f1, %g3, -4
	ld	%g3, %g1, 16
	fst	%f0, %g1, 104
	fst	%f1, %g1, 108
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	o_param_y.2790
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	fld	%f1, %g1, 108
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g1, 112
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	o_param_b.2782
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	fsqrt	%f0, %f0
	fld	%f1, %g1, 112
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 96
	fst	%f0, %g1, 116
	fmov	%f0, %f1
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	fabs.2658
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	setL %g3, l.7301
	fld	%f1, %g3, 0
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	fless.2646
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10191
	fld	%f0, %g1, 96
	fld	%f1, %g1, 116
	fdiv	%f0, %f1, %f0
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	fabs.2658
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	atan.2669
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	setL %g3, l.7305
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.7307
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	jmp	jeq_cont.10192
jeq_else.10191:
	setL %g3, l.7303
	fld	%f0, %g3, 0
jeq_cont.10192:
	fst	%f0, %g1, 120
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	min_caml_floor
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	fld	%f1, %g1, 120
	fsub	%f0, %f1, %f0
	setL %g3, l.7315
	fld	%f1, %g3, 0
	setL %g3, l.6517
	fld	%f2, %g3, 0
	fld	%f3, %g1, 104
	fsub	%f2, %f2, %f3
	fst	%f0, %g1, 124
	fst	%f1, %g1, 128
	fmov	%f0, %f2
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	fsqr.2664
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	fld	%f1, %g1, 128
	fsub	%f0, %f1, %f0
	setL %g3, l.6517
	fld	%f1, %g3, 0
	fld	%f2, %g1, 124
	fsub	%f1, %f1, %f2
	fst	%f0, %g1, 132
	fmov	%f0, %f1
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	fsqr.2664
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	fld	%f1, %g1, 132
	fsub	%f0, %f1, %f0
	fst	%f0, %g1, 136
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	fisneg.2651
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10193
	fld	%f0, %g1, 136
	jmp	jeq_cont.10194
jeq_else.10193:
	setL %g3, l.6510
	fld	%f0, %g3, 0
jeq_cont.10194:
	setL %g3, l.7320
	fld	%f1, %g3, 0
	fmul	%f0, %f1, %f0
	setL %g3, l.7322
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 12
	fst	%f0, %g3, -8
	return
jeq_else.10188:
	return
add_light.3042:
	ld	%g3, %g29, -8
	ld	%g4, %g29, -4
	fst	%f2, %g1, 0
	fst	%f1, %g1, 4
	fst	%f0, %g1, 8
	st	%g3, %g1, 12
	st	%g4, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fispos.2649
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10197
	jmp	jeq_cont.10198
jeq_else.10197:
	fld	%f0, %g1, 8
	ld	%g3, %g1, 16
	ld	%g4, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	vecaccum.2753
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.10198:
	fld	%f0, %g1, 4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fispos.2649
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10199
	return
jeq_else.10199:
	fld	%f0, %g1, 4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fsqr.2664
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fsqr.2664
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 0
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 16
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
trace_reflections.3046:
	ld	%g5, %g29, -32
	ld	%g6, %g29, -28
	ld	%g7, %g29, -24
	ld	%g8, %g29, -20
	ld	%g9, %g29, -16
	ld	%g10, %g29, -12
	ld	%g11, %g29, -8
	ld	%g12, %g29, -4
	mvhi	%g13, 0
	mvlo	%g13, 0
	jlt	%g3, %g13, jle_else.10202
	slli	%g13, %g3, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g13
	ld	%g6, %g6, 0
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	fst	%f1, %g1, 8
	st	%g12, %g1, 12
	st	%g4, %g1, 16
	fst	%f0, %g1, 20
	st	%g8, %g1, 24
	st	%g5, %g1, 28
	st	%g7, %g1, 32
	st	%g6, %g1, 36
	st	%g10, %g1, 40
	st	%g11, %g1, 44
	st	%g9, %g1, 48
	mov	%g3, %g6
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	r_dvec.2837
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g29, %g1, 48
	st	%g3, %g1, 52
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10203
	jmp	jeq_cont.10204
jeq_else.10203:
	ld	%g3, %g1, 44
	ld	%g3, %g3, 0
	muli	%g3, %g3, 4
	ld	%g4, %g1, 40
	ld	%g4, %g4, 0
	add	%g3, %g3, %g4
	ld	%g4, %g1, 36
	st	%g3, %g1, 56
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	r_surface_id.2835
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g4, %g1, 56
	jne	%g4, %g3, jeq_else.10205
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 32
	ld	%g4, %g4, 0
	ld	%g29, %g1, 28
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10207
	ld	%g3, %g1, 52
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	d_vec.2831
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g3
	ld	%g3, %g1, 24
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	veciprod.2745
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 36
	fst	%f0, %g1, 60
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	r_bright.2839
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 20
	fmul	%f2, %f0, %f1
	fld	%f3, %g1, 60
	fmul	%f2, %f2, %f3
	ld	%g3, %g1, 52
	fst	%f2, %g1, 64
	fst	%f0, %g1, 68
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	d_vec.2831
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mov	%g4, %g3
	ld	%g3, %g1, 16
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	veciprod.2745
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 68
	fmul	%f1, %f1, %f0
	fld	%f0, %g1, 64
	fld	%f2, %g1, 8
	ld	%g29, %g1, 12
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	jmp	jeq_cont.10208
jeq_else.10207:
jeq_cont.10208:
	jmp	jeq_cont.10206
jeq_else.10205:
jeq_cont.10206:
jeq_cont.10204:
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	fld	%f0, %g1, 20
	fld	%f1, %g1, 8
	ld	%g4, %g1, 16
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10202:
	return
trace_ray.3051:
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
	jlt	%g26, %g3, jle_else.10210
	st	%g29, %g1, 0
	fst	%f1, %g1, 4
	st	%g8, %g1, 8
	st	%g7, %g1, 12
	st	%g17, %g1, 16
	st	%g12, %g1, 20
	st	%g25, %g1, 24
	st	%g11, %g1, 28
	st	%g14, %g1, 32
	st	%g16, %g1, 36
	st	%g9, %g1, 40
	st	%g5, %g1, 44
	st	%g20, %g1, 48
	st	%g6, %g1, 52
	st	%g21, %g1, 56
	st	%g10, %g1, 60
	st	%g23, %g1, 64
	st	%g15, %g1, 68
	st	%g22, %g1, 72
	st	%g13, %g1, 76
	st	%g24, %g1, 80
	fst	%f0, %g1, 84
	st	%g18, %g1, 88
	st	%g3, %g1, 92
	st	%g4, %g1, 96
	st	%g19, %g1, 100
	mov	%g3, %g5
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	p_surface_ids.2816
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	ld	%g4, %g1, 96
	ld	%g29, %g1, 100
	st	%g3, %g1, 104
	mov	%g3, %g4
	st	%g31, %g1, 108
	ld	%g28, %g29, 0
	subi	%g1, %g1, 112
	callR	%g28
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10211
	mvhi	%g3, 65535
	mvlo	%g3, -1
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	ld	%g6, %g1, 104
	st	%g6, %g1, 108
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 108
	mvhi	%g3, 0
	mvlo	%g3, 0
	jne	%g4, %g3, jeq_else.10212
	return
jeq_else.10212:
	ld	%g3, %g1, 96
	ld	%g4, %g1, 88
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	veciprod.2745
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	fneg.2660
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	fst	%f0, %g1, 108
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	fispos.2649
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10214
	return
jeq_else.10214:
	fld	%f0, %g1, 108
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	fsqr.2664
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	fld	%f1, %g1, 108
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 84
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 80
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 76
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
jeq_else.10211:
	ld	%g3, %g1, 72
	ld	%g3, %g3, 0
	slli	%g4, %g3, 2
	ld	%g5, %g1, 68
	st	%g5, %g1, 116
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 116
	st	%g3, %g1, 112
	st	%g4, %g1, 116
	mov	%g3, %g4
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	o_reflectiontype.2774
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	ld	%g4, %g1, 116
	st	%g3, %g1, 120
	mov	%g3, %g4
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	o_diffuse.2794
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	fld	%f1, %g1, 84
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 116
	ld	%g4, %g1, 96
	ld	%g29, %g1, 64
	fst	%f0, %g1, 124
	st	%g31, %g1, 132
	ld	%g28, %g29, 0
	subi	%g1, %g1, 136
	callR	%g28
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g3, %g1, 60
	ld	%g4, %g1, 56
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	veccpy.2734
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g3, %g1, 116
	ld	%g4, %g1, 56
	ld	%g29, %g1, 52
	st	%g31, %g1, 132
	ld	%g28, %g29, 0
	subi	%g1, %g1, 136
	callR	%g28
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g3, %g1, 112
	muli	%g3, %g3, 4
	ld	%g4, %g1, 48
	ld	%g4, %g4, 0
	add	%g3, %g3, %g4
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	ld	%g6, %g1, 104
	st	%g6, %g1, 132
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 132
	ld	%g3, %g1, 44
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	p_intersection_points.2814
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	st	%g3, %g1, 132
	add	%g3, %g3, %g5
	ld	%g3, %g3, 0
	ld	%g5, %g1, 56
	mov	%g4, %g5
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	veccpy.2734
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g3, %g1, 44
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	p_calc_diffuse.2818
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g4, %g1, 116
	st	%g3, %g1, 128
	mov	%g3, %g4
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	o_diffuse.2794
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	setL %g3, l.6517
	fld	%f1, %g3, 0
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	fless.2646
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10217
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	ld	%g6, %g1, 128
	st	%g6, %g1, 132
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 132
	ld	%g3, %g1, 44
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	p_energy.2820
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	st	%g3, %g1, 132
	add	%g3, %g3, %g5
	ld	%g5, %g3, 0
	ld	%g3, %g1, 132
	ld	%g6, %g1, 40
	st	%g3, %g1, 132
	mov	%g4, %g6
	mov	%g3, %g5
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	veccpy.2734
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g3, %g1, 92
	slli	%g4, %g3, 2
	ld	%g5, %g1, 132
	st	%g5, %g1, 140
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 140
	setL %g5, l.7396
	fld	%f0, %g5, 0
	fld	%f1, %g1, 124
	fmul	%f0, %f0, %f1
	mov	%g3, %g4
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	vecscale.2763
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g3, %g1, 44
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	p_nvectors.2829
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	st	%g3, %g1, 140
	add	%g3, %g3, %g5
	ld	%g3, %g3, 0
	ld	%g5, %g1, 36
	mov	%g4, %g5
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	veccpy.2734
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	jmp	jeq_cont.10218
jeq_else.10217:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	ld	%g6, %g1, 128
	st	%g6, %g1, 140
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 140
jeq_cont.10218:
	setL %g3, l.7400
	fld	%f0, %g3, 0
	ld	%g3, %g1, 96
	ld	%g4, %g1, 36
	fst	%f0, %g1, 136
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	veciprod.2745
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	fld	%f1, %g1, 136
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 96
	ld	%g4, %g1, 36
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	vecaccum.2753
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g3, %g1, 116
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	o_hilight.2796
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	fld	%f1, %g1, 84
	fmul	%f0, %f1, %f0
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 32
	ld	%g4, %g4, 0
	ld	%g29, %g1, 28
	fst	%f0, %g1, 140
	st	%g31, %g1, 148
	ld	%g28, %g29, 0
	subi	%g1, %g1, 152
	callR	%g28
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10219
	ld	%g3, %g1, 36
	ld	%g4, %g1, 88
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	veciprod.2745
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	fneg.2660
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	fld	%f1, %g1, 124
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 96
	ld	%g4, %g1, 88
	fst	%f0, %g1, 144
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	veciprod.2745
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	fneg.2660
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 144
	fld	%f2, %g1, 140
	ld	%g29, %g1, 24
	st	%g31, %g1, 148
	ld	%g28, %g29, 0
	subi	%g1, %g1, 152
	callR	%g28
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	jmp	jeq_cont.10220
jeq_else.10219:
jeq_cont.10220:
	ld	%g3, %g1, 56
	ld	%g29, %g1, 20
	st	%g31, %g1, 148
	ld	%g28, %g29, 0
	subi	%g1, %g1, 152
	callR	%g28
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	ld	%g3, %g1, 16
	ld	%g3, %g3, 0
	subi	%g3, %g3, 1
	fld	%f0, %g1, 124
	fld	%f1, %g1, 140
	ld	%g4, %g1, 96
	ld	%g29, %g1, 12
	st	%g31, %g1, 148
	ld	%g28, %g29, 0
	subi	%g1, %g1, 152
	callR	%g28
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	setL %g3, l.7406
	fld	%f0, %g3, 0
	fld	%f1, %g1, 84
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	fless.2646
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10221
	return
jeq_else.10221:
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 92
	jlt	%g4, %g3, jle_else.10223
	jmp	jle_cont.10224
jle_else.10223:
	addi	%g3, %g4, 1
	mvhi	%g5, 65535
	mvlo	%g5, -1
	slli	%g3, %g3, 2
	ld	%g6, %g1, 104
	st	%g6, %g1, 148
	add	%g6, %g6, %g3
	st	%g5, %g6, 0
	ld	%g6, %g1, 148
jle_cont.10224:
	mvhi	%g3, 0
	mvlo	%g3, 2
	ld	%g5, %g1, 120
	jne	%g5, %g3, jeq_else.10225
	setL %g3, l.6519
	fld	%f0, %g3, 0
	ld	%g3, %g1, 116
	fst	%f0, %g1, 148
	st	%g31, %g1, 156
	subi	%g1, %g1, 160
	call	o_diffuse.2794
	addi	%g1, %g1, 160
	ld	%g31, %g1, 156
	fld	%f1, %g1, 148
	fsub	%f0, %f1, %f0
	fld	%f1, %g1, 84
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 92
	addi	%g3, %g3, 1
	ld	%g4, %g1, 8
	fld	%f1, %g4, 0
	fld	%f2, %g1, 4
	fadd	%f1, %f2, %f1
	ld	%g4, %g1, 96
	ld	%g5, %g1, 44
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10225:
	return
jle_else.10210:
	return
trace_diffuse_ray.3057:
	ld	%g4, %g29, -48
	ld	%g5, %g29, -44
	ld	%g6, %g29, -40
	ld	%g7, %g29, -36
	ld	%g8, %g29, -32
	ld	%g9, %g29, -28
	ld	%g10, %g29, -24
	ld	%g11, %g29, -20
	ld	%g12, %g29, -16
	ld	%g13, %g29, -12
	ld	%g14, %g29, -8
	ld	%g15, %g29, -4
	st	%g5, %g1, 0
	st	%g15, %g1, 4
	fst	%f0, %g1, 8
	st	%g10, %g1, 12
	st	%g9, %g1, 16
	st	%g6, %g1, 20
	st	%g7, %g1, 24
	st	%g12, %g1, 28
	st	%g4, %g1, 32
	st	%g14, %g1, 36
	st	%g3, %g1, 40
	st	%g8, %g1, 44
	st	%g13, %g1, 48
	mov	%g29, %g11
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10228
	return
jeq_else.10228:
	ld	%g3, %g1, 48
	ld	%g3, %g3, 0
	slli	%g3, %g3, 2
	ld	%g4, %g1, 44
	st	%g4, %g1, 52
	add	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 52
	ld	%g4, %g1, 40
	st	%g3, %g1, 52
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	d_vec.2831
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g3
	ld	%g3, %g1, 52
	ld	%g29, %g1, 36
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 52
	ld	%g4, %g1, 28
	ld	%g29, %g1, 32
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 24
	ld	%g4, %g4, 0
	ld	%g29, %g1, 20
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10230
	ld	%g3, %g1, 16
	ld	%g4, %g1, 12
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	veciprod.2745
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fneg.2660
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fst	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fispos.2649
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10231
	setL %g3, l.6510
	fld	%f0, %g3, 0
	jmp	jeq_cont.10232
jeq_else.10231:
	fld	%f0, %g1, 56
jeq_cont.10232:
	fld	%f1, %g1, 8
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 52
	fst	%f0, %g1, 60
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	o_diffuse.2794
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 60
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	ld	%g4, %g1, 0
	jmp	vecaccum.2753
jeq_else.10230:
	return
iter_trace_diffuse_rays.3060:
	ld	%g7, %g29, -4
	mvhi	%g8, 0
	mvlo	%g8, 0
	jlt	%g6, %g8, jle_else.10234
	slli	%g8, %g6, 2
	st	%g3, %g1, 4
	add	%g3, %g3, %g8
	ld	%g8, %g3, 0
	ld	%g3, %g1, 4
	st	%g5, %g1, 0
	st	%g29, %g1, 4
	st	%g7, %g1, 8
	st	%g3, %g1, 12
	st	%g6, %g1, 16
	st	%g4, %g1, 20
	mov	%g3, %g8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	d_vec.2831
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	veciprod.2745
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fisneg.2651
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10235
	ld	%g3, %g1, 16
	slli	%g4, %g3, 2
	ld	%g5, %g1, 12
	st	%g5, %g1, 28
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 28
	setL %g6, l.7439
	fld	%f0, %g6, 0
	fld	%f1, %g1, 24
	fdiv	%f0, %f1, %f0
	ld	%g29, %g1, 8
	mov	%g3, %g4
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	jmp	jeq_cont.10236
jeq_else.10235:
	ld	%g3, %g1, 16
	addi	%g4, %g3, 1
	slli	%g4, %g4, 2
	ld	%g5, %g1, 12
	st	%g5, %g1, 28
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 28
	setL %g6, l.7435
	fld	%f0, %g6, 0
	fld	%f1, %g1, 24
	fdiv	%f0, %f1, %f0
	ld	%g29, %g1, 8
	mov	%g3, %g4
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
jeq_cont.10236:
	ld	%g3, %g1, 16
	subi	%g6, %g3, 2
	ld	%g3, %g1, 12
	ld	%g4, %g1, 20
	ld	%g5, %g1, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jle_else.10234:
	return
trace_diffuse_rays.3065:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g3, %g1, 8
	st	%g7, %g1, 12
	mov	%g3, %g5
	mov	%g29, %g6
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g6, 0
	mvlo	%g6, 118
	ld	%g3, %g1, 8
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 12
	ld	%g28, %g29, 0
	b	%g28
trace_diffuse_ray_80percent.3069:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	mvhi	%g8, 0
	mvlo	%g8, 0
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g6, %g1, 8
	st	%g7, %g1, 12
	st	%g3, %g1, 16
	jne	%g3, %g8, jeq_else.10238
	jmp	jeq_cont.10239
jeq_else.10238:
	ld	%g8, %g7, 0
	mov	%g3, %g8
	mov	%g29, %g6
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.10239:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 16
	jne	%g4, %g3, jeq_else.10240
	jmp	jeq_cont.10241
jeq_else.10240:
	ld	%g3, %g1, 12
	ld	%g5, %g3, -4
	ld	%g6, %g1, 4
	ld	%g7, %g1, 0
	ld	%g29, %g1, 8
	mov	%g4, %g6
	mov	%g3, %g5
	mov	%g5, %g7
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.10241:
	mvhi	%g3, 0
	mvlo	%g3, 2
	ld	%g4, %g1, 16
	jne	%g4, %g3, jeq_else.10242
	jmp	jeq_cont.10243
jeq_else.10242:
	ld	%g3, %g1, 12
	ld	%g5, %g3, -8
	ld	%g6, %g1, 4
	ld	%g7, %g1, 0
	ld	%g29, %g1, 8
	mov	%g4, %g6
	mov	%g3, %g5
	mov	%g5, %g7
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.10243:
	mvhi	%g3, 0
	mvlo	%g3, 3
	ld	%g4, %g1, 16
	jne	%g4, %g3, jeq_else.10244
	jmp	jeq_cont.10245
jeq_else.10244:
	ld	%g3, %g1, 12
	ld	%g5, %g3, -12
	ld	%g6, %g1, 4
	ld	%g7, %g1, 0
	ld	%g29, %g1, 8
	mov	%g4, %g6
	mov	%g3, %g5
	mov	%g5, %g7
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.10245:
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 16
	jne	%g4, %g3, jeq_else.10246
	return
jeq_else.10246:
	ld	%g3, %g1, 12
	ld	%g3, %g3, -16
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
calc_diffuse_using_1point.3073:
	ld	%g5, %g29, -12
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	st	%g6, %g1, 0
	st	%g5, %g1, 4
	st	%g7, %g1, 8
	st	%g4, %g1, 12
	st	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	p_received_ray_20percent.2822
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 16
	st	%g3, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_nvectors.2829
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 16
	st	%g3, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_intersection_points.2814
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 16
	st	%g3, %g1, 28
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	p_energy.2820
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 12
	slli	%g5, %g4, 2
	ld	%g6, %g1, 20
	st	%g6, %g1, 36
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 36
	ld	%g6, %g1, 8
	st	%g3, %g1, 32
	mov	%g4, %g5
	mov	%g3, %g6
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	veccpy.2734
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 16
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	p_group_id.2824
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 12
	slli	%g5, %g4, 2
	ld	%g6, %g1, 24
	st	%g6, %g1, 36
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 36
	slli	%g6, %g4, 2
	ld	%g7, %g1, 28
	st	%g7, %g1, 36
	add	%g7, %g7, %g6
	ld	%g6, %g7, 0
	ld	%g7, %g1, 36
	ld	%g29, %g1, 4
	mov	%g4, %g5
	mov	%g5, %g6
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 12
	slli	%g3, %g3, 2
	ld	%g4, %g1, 32
	st	%g4, %g1, 36
	add	%g4, %g4, %g3
	ld	%g4, %g4, 0
	ld	%g3, %g1, 0
	ld	%g5, %g1, 8
	jmp	vecaccumv.2766
calc_diffuse_using_5points.3076:
	ld	%g8, %g29, -8
	ld	%g9, %g29, -4
	slli	%g10, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g10
	ld	%g4, %g4, 0
	st	%g8, %g1, 0
	st	%g9, %g1, 4
	st	%g7, %g1, 8
	st	%g6, %g1, 12
	st	%g5, %g1, 16
	st	%g3, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_received_ray_20percent.2822
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	subi	%g5, %g4, 1
	slli	%g5, %g5, 2
	ld	%g6, %g1, 16
	st	%g6, %g1, 28
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 28
	st	%g3, %g1, 24
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_received_ray_20percent.2822
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	slli	%g5, %g4, 2
	ld	%g6, %g1, 16
	st	%g6, %g1, 28
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 28
	st	%g3, %g1, 28
	mov	%g3, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	p_received_ray_20percent.2822
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 20
	addi	%g5, %g4, 1
	slli	%g5, %g5, 2
	ld	%g6, %g1, 16
	st	%g6, %g1, 36
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 36
	st	%g3, %g1, 32
	mov	%g3, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	p_received_ray_20percent.2822
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 20
	slli	%g5, %g4, 2
	ld	%g6, %g1, 12
	st	%g6, %g1, 36
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 36
	st	%g3, %g1, 36
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	p_received_ray_20percent.2822
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 8
	slli	%g5, %g4, 2
	ld	%g6, %g1, 24
	st	%g6, %g1, 44
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 44
	ld	%g6, %g1, 4
	st	%g3, %g1, 40
	mov	%g4, %g5
	mov	%g3, %g6
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	veccpy.2734
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 8
	slli	%g4, %g3, 2
	ld	%g5, %g1, 28
	st	%g5, %g1, 44
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 44
	ld	%g5, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecadd.2757
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 8
	slli	%g4, %g3, 2
	ld	%g5, %g1, 32
	st	%g5, %g1, 44
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 44
	ld	%g5, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecadd.2757
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 8
	slli	%g4, %g3, 2
	ld	%g5, %g1, 36
	st	%g5, %g1, 44
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 44
	ld	%g5, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecadd.2757
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 8
	slli	%g4, %g3, 2
	ld	%g5, %g1, 40
	st	%g5, %g1, 44
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 44
	ld	%g5, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecadd.2757
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 20
	slli	%g3, %g3, 2
	ld	%g4, %g1, 16
	st	%g4, %g1, 44
	add	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 44
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	p_energy.2820
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 8
	slli	%g4, %g4, 2
	st	%g3, %g1, 44
	add	%g3, %g3, %g4
	ld	%g4, %g3, 0
	ld	%g3, %g1, 44
	ld	%g3, %g1, 0
	ld	%g5, %g1, 4
	jmp	vecaccumv.2766
do_without_neighbors.3082:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 4
	jlt	%g6, %g4, jle_else.10248
	st	%g29, %g1, 0
	st	%g5, %g1, 4
	st	%g3, %g1, 8
	st	%g4, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	p_surface_ids.2816
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g5, %g1, 12
	slli	%g6, %g5, 2
	st	%g3, %g1, 20
	add	%g3, %g3, %g6
	ld	%g3, %g3, 0
	jlt	%g3, %g4, jle_else.10249
	ld	%g3, %g1, 8
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	p_calc_diffuse.2818
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 12
	slli	%g5, %g4, 2
	st	%g3, %g1, 20
	add	%g3, %g3, %g5
	ld	%g3, %g3, 0
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.10250
	jmp	jeq_cont.10251
jeq_else.10250:
	ld	%g3, %g1, 8
	ld	%g29, %g1, 4
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.10251:
	ld	%g3, %g1, 12
	addi	%g4, %g3, 1
	ld	%g3, %g1, 8
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10249:
	return
jle_else.10248:
	return
neighbors_exist.3085:
	ld	%g5, %g29, -4
	ld	%g6, %g5, -4
	addi	%g7, %g4, 1
	jlt	%g7, %g6, jle_else.10254
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jle_else.10254:
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g6, %g4, jle_else.10255
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jle_else.10255:
	ld	%g4, %g5, 0
	addi	%g5, %g3, 1
	jlt	%g5, %g4, jle_else.10256
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jle_else.10256:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jlt	%g4, %g3, jle_else.10257
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jle_else.10257:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
get_surface_id.3089:
	st	%g4, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	p_surface_ids.2816
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	slli	%g4, %g4, 2
	st	%g3, %g1, 4
	add	%g3, %g3, %g4
	ld	%g3, %g3, 0
	return
neighbors_are_available.3092:
	slli	%g8, %g3, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g8
	ld	%g8, %g5, 0
	ld	%g5, %g1, 4
	st	%g5, %g1, 0
	st	%g6, %g1, 4
	st	%g7, %g1, 8
	st	%g4, %g1, 12
	st	%g3, %g1, 16
	mov	%g4, %g7
	mov	%g3, %g8
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	get_surface_id.3089
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 16
	slli	%g5, %g4, 2
	ld	%g6, %g1, 12
	st	%g6, %g1, 20
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 20
	ld	%g6, %g1, 8
	st	%g3, %g1, 20
	mov	%g4, %g6
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	get_surface_id.3089
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	jne	%g3, %g4, jeq_else.10258
	ld	%g3, %g1, 16
	slli	%g5, %g3, 2
	ld	%g6, %g1, 4
	st	%g6, %g1, 28
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 28
	ld	%g6, %g1, 8
	mov	%g4, %g6
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	get_surface_id.3089
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	jne	%g3, %g4, jeq_else.10259
	ld	%g3, %g1, 16
	subi	%g5, %g3, 1
	slli	%g5, %g5, 2
	ld	%g6, %g1, 0
	st	%g6, %g1, 28
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 28
	ld	%g7, %g1, 8
	mov	%g4, %g7
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	get_surface_id.3089
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	jne	%g3, %g4, jeq_else.10260
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	slli	%g3, %g3, 2
	ld	%g5, %g1, 0
	st	%g5, %g1, 28
	add	%g5, %g5, %g3
	ld	%g3, %g5, 0
	ld	%g5, %g1, 28
	ld	%g5, %g1, 8
	mov	%g4, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	get_surface_id.3089
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	jne	%g3, %g4, jeq_else.10261
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.10261:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10260:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10259:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10258:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
try_exploit_neighbors.3098:
	ld	%g9, %g29, -8
	ld	%g10, %g29, -4
	slli	%g11, %g3, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g11
	ld	%g11, %g6, 0
	ld	%g6, %g1, 4
	mvhi	%g12, 0
	mvlo	%g12, 4
	jlt	%g12, %g8, jle_else.10262
	mvhi	%g12, 0
	mvlo	%g12, 0
	st	%g4, %g1, 0
	st	%g29, %g1, 4
	st	%g10, %g1, 8
	st	%g11, %g1, 12
	st	%g9, %g1, 16
	st	%g8, %g1, 20
	st	%g7, %g1, 24
	st	%g6, %g1, 28
	st	%g5, %g1, 32
	st	%g3, %g1, 36
	st	%g12, %g1, 40
	mov	%g4, %g8
	mov	%g3, %g11
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	get_surface_id.3089
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 40
	jlt	%g3, %g4, jle_else.10263
	ld	%g3, %g1, 36
	ld	%g4, %g1, 32
	ld	%g5, %g1, 28
	ld	%g6, %g1, 24
	ld	%g7, %g1, 20
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	neighbors_are_available.3092
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10264
	ld	%g3, %g1, 36
	slli	%g3, %g3, 2
	ld	%g4, %g1, 28
	st	%g4, %g1, 44
	add	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 44
	ld	%g4, %g1, 20
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10264:
	ld	%g3, %g1, 12
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	p_calc_diffuse.2818
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g7, %g1, 20
	slli	%g4, %g7, 2
	st	%g3, %g1, 44
	add	%g3, %g3, %g4
	ld	%g3, %g3, 0
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10265
	jmp	jeq_cont.10266
jeq_else.10265:
	ld	%g3, %g1, 36
	ld	%g4, %g1, 32
	ld	%g5, %g1, 28
	ld	%g6, %g1, 24
	ld	%g29, %g1, 8
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
jeq_cont.10266:
	ld	%g3, %g1, 20
	addi	%g8, %g3, 1
	ld	%g3, %g1, 36
	ld	%g4, %g1, 0
	ld	%g5, %g1, 32
	ld	%g6, %g1, 28
	ld	%g7, %g1, 24
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jle_else.10263:
	return
jle_else.10262:
	return
write_ppm_header.3105:
	ld	%g3, %g29, -4
	mvhi	%g4, 0
	mvlo	%g4, 80
	st	%g3, %g1, 0
	mov	%g3, %g4
	output	%g3
	mvhi	%g3, 0
	mvlo	%g3, 51
	output	%g3
	mvhi	%g3, 0
	mvlo	%g3, 10
	output	%g3
	ld	%g3, %g1, 0
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	print_int.2681
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 32
	output	%g3
	ld	%g3, %g1, 0
	ld	%g3, %g3, -4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	print_int.2681
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 32
	output	%g3
	mvhi	%g3, 0
	mvlo	%g3, 255
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	print_int.2681
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 10
	output	%g3
	return
write_rgb_element.3107:
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 255
	jlt	%g4, %g3, jle_else.10269
	mvhi	%g4, 0
	mvlo	%g4, 0
	jlt	%g3, %g4, jle_else.10271
	jmp	jle_cont.10272
jle_else.10271:
	mvhi	%g3, 0
	mvlo	%g3, 0
jle_cont.10272:
	jmp	jle_cont.10270
jle_else.10269:
	mvhi	%g3, 0
	mvlo	%g3, 255
jle_cont.10270:
	jmp	print_int.2681
write_rgb.3109:
	ld	%g3, %g29, -4
	fld	%f0, %g3, 0
	st	%g3, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	write_rgb_element.3107
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 32
	output	%g3
	ld	%g3, %g1, 0
	fld	%f0, %g3, -4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	write_rgb_element.3107
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 32
	output	%g3
	ld	%g3, %g1, 0
	fld	%f0, %g3, -8
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	write_rgb_element.3107
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 10
	output	%g3
	return
pretrace_diffuse_rays.3111:
	ld	%g5, %g29, -12
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	mvhi	%g8, 0
	mvlo	%g8, 4
	jlt	%g8, %g4, jle_else.10273
	st	%g29, %g1, 0
	st	%g5, %g1, 4
	st	%g6, %g1, 8
	st	%g7, %g1, 12
	st	%g4, %g1, 16
	st	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	get_surface_id.3089
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jlt	%g3, %g4, jle_else.10274
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_calc_diffuse.2818
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 16
	slli	%g5, %g4, 2
	st	%g3, %g1, 28
	add	%g3, %g3, %g5
	ld	%g3, %g3, 0
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.10275
	jmp	jeq_cont.10276
jeq_else.10275:
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_group_id.2824
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 12
	st	%g3, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	vecbzero.2732
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_nvectors.2829
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	st	%g3, %g1, 28
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	p_intersection_points.2814
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 24
	slli	%g4, %g4, 2
	ld	%g5, %g1, 8
	st	%g5, %g1, 36
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 36
	ld	%g5, %g1, 16
	slli	%g6, %g5, 2
	ld	%g7, %g1, 28
	st	%g7, %g1, 36
	add	%g7, %g7, %g6
	ld	%g6, %g7, 0
	ld	%g7, %g1, 36
	slli	%g7, %g5, 2
	st	%g3, %g1, 36
	add	%g3, %g3, %g7
	ld	%g3, %g3, 0
	ld	%g29, %g1, 4
	mov	%g5, %g3
	mov	%g3, %g4
	mov	%g4, %g6
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 20
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	p_received_ray_20percent.2822
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 16
	slli	%g5, %g4, 2
	st	%g3, %g1, 36
	add	%g3, %g3, %g5
	ld	%g3, %g3, 0
	ld	%g5, %g1, 12
	mov	%g4, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	veccpy.2734
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
jeq_cont.10276:
	ld	%g3, %g1, 16
	addi	%g4, %g3, 1
	ld	%g3, %g1, 20
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10274:
	return
jle_else.10273:
	return
pretrace_pixels.3114:
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
	jlt	%g4, %g15, jle_else.10279
	fld	%f3, %g10, 0
	ld	%g10, %g14, 0
	sub	%g10, %g4, %g10
	st	%g29, %g1, 0
	st	%g13, %g1, 4
	st	%g5, %g1, 8
	st	%g7, %g1, 12
	st	%g3, %g1, 16
	st	%g4, %g1, 20
	st	%g6, %g1, 24
	st	%g8, %g1, 28
	st	%g11, %g1, 32
	fst	%f2, %g1, 36
	fst	%f1, %g1, 40
	st	%g12, %g1, 44
	fst	%f0, %g1, 48
	st	%g9, %g1, 52
	fst	%f3, %g1, 56
	mov	%g3, %g10
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	min_caml_float_of_int
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 56
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 52
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	fld	%f2, %g1, 48
	fadd	%f1, %f1, %f2
	ld	%g4, %g1, 44
	fst	%f1, %g4, 0
	fld	%f1, %g3, -4
	fmul	%f1, %f0, %f1
	fld	%f3, %g1, 40
	fadd	%f1, %f1, %f3
	fst	%f1, %g4, -4
	fld	%f1, %g3, -8
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 36
	fadd	%f0, %f0, %f1
	fst	%f0, %g4, -8
	mvhi	%g3, 0
	mvlo	%g3, 0
	mov	%g28, %g4
	mov	%g4, %g3
	mov	%g3, %g28
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	vecunit_sgn.2742
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 32
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	vecbzero.2732
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 28
	ld	%g4, %g1, 24
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	veccpy.2734
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g3, 0
	mvlo	%g3, 0
	setL %g4, l.6519
	fld	%f0, %g4, 0
	ld	%g4, %g1, 20
	slli	%g5, %g4, 2
	ld	%g6, %g1, 16
	st	%g6, %g1, 60
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 60
	setL %g7, l.6510
	fld	%f1, %g7, 0
	ld	%g7, %g1, 44
	ld	%g29, %g1, 12
	mov	%g4, %g7
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 20
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	st	%g5, %g1, 60
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 60
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	p_rgb.2812
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g4, %g1, 32
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	veccpy.2734
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 20
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	st	%g5, %g1, 60
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 60
	ld	%g6, %g1, 8
	mov	%g3, %g4
	mov	%g4, %g6
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	p_set_group_id.2826
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 20
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	st	%g5, %g1, 60
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 60
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g29, %g1, 4
	mov	%g3, %g4
	mov	%g4, %g6
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 20
	subi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 1
	ld	%g5, %g1, 8
	st	%g3, %g1, 60
	mov	%g3, %g5
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	add_mod5.2721
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mov	%g5, %g3
	fld	%f0, %g1, 48
	fld	%f1, %g1, 40
	fld	%f2, %g1, 36
	ld	%g3, %g1, 16
	ld	%g4, %g1, 60
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10279:
	return
pretrace_line.3121:
	ld	%g6, %g29, -24
	ld	%g7, %g29, -20
	ld	%g8, %g29, -16
	ld	%g9, %g29, -12
	ld	%g10, %g29, -8
	ld	%g11, %g29, -4
	fld	%f0, %g8, 0
	ld	%g8, %g11, -4
	sub	%g4, %g4, %g8
	st	%g5, %g1, 0
	st	%g3, %g1, 4
	st	%g9, %g1, 8
	st	%g10, %g1, 12
	st	%g6, %g1, 16
	st	%g7, %g1, 20
	fst	%f0, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 20
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	ld	%g4, %g1, 16
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
	ld	%g3, %g1, 12
	ld	%g3, %g3, 0
	subi	%g4, %g3, 1
	ld	%g3, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	fmov	%f31, %f2
	fmov	%f2, %f0
	fmov	%f0, %f1
	fmov	%f1, %f31
	ld	%g28, %g29, 0
	b	%g28
scan_pixel.3125:
	ld	%g8, %g29, -24
	ld	%g9, %g29, -20
	ld	%g10, %g29, -16
	ld	%g11, %g29, -12
	ld	%g12, %g29, -8
	ld	%g13, %g29, -4
	ld	%g12, %g12, 0
	jlt	%g3, %g12, jle_else.10281
	return
jle_else.10281:
	slli	%g12, %g3, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g12
	ld	%g12, %g6, 0
	ld	%g6, %g1, 4
	st	%g29, %g1, 0
	st	%g8, %g1, 4
	st	%g5, %g1, 8
	st	%g9, %g1, 12
	st	%g13, %g1, 16
	st	%g6, %g1, 20
	st	%g7, %g1, 24
	st	%g4, %g1, 28
	st	%g3, %g1, 32
	st	%g11, %g1, 36
	st	%g10, %g1, 40
	mov	%g3, %g12
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	p_rgb.2812
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mov	%g4, %g3
	ld	%g3, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	veccpy.2734
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 32
	ld	%g4, %g1, 28
	ld	%g5, %g1, 24
	ld	%g29, %g1, 36
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10283
	ld	%g3, %g1, 32
	slli	%g4, %g3, 2
	ld	%g5, %g1, 20
	st	%g5, %g1, 44
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 44
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g29, %g1, 16
	mov	%g3, %g4
	mov	%g4, %g6
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	jmp	jeq_cont.10284
jeq_else.10283:
	mvhi	%g8, 0
	mvlo	%g8, 0
	ld	%g3, %g1, 32
	ld	%g4, %g1, 28
	ld	%g5, %g1, 8
	ld	%g6, %g1, 20
	ld	%g7, %g1, 24
	ld	%g29, %g1, 12
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
jeq_cont.10284:
	ld	%g29, %g1, 4
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 32
	addi	%g3, %g3, 1
	ld	%g4, %g1, 28
	ld	%g5, %g1, 8
	ld	%g6, %g1, 20
	ld	%g7, %g1, 24
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
scan_line.3131:
	ld	%g8, %g29, -12
	ld	%g9, %g29, -8
	ld	%g10, %g29, -4
	ld	%g11, %g10, -4
	jlt	%g3, %g11, jle_else.10285
	return
jle_else.10285:
	ld	%g10, %g10, -4
	subi	%g10, %g10, 1
	st	%g29, %g1, 0
	st	%g7, %g1, 4
	st	%g6, %g1, 8
	st	%g5, %g1, 12
	st	%g4, %g1, 16
	st	%g3, %g1, 20
	st	%g8, %g1, 24
	jlt	%g3, %g10, jle_else.10287
	jmp	jle_cont.10288
jle_else.10287:
	addi	%g10, %g3, 1
	mov	%g5, %g7
	mov	%g4, %g10
	mov	%g3, %g6
	mov	%g29, %g9
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
jle_cont.10288:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 20
	ld	%g5, %g1, 16
	ld	%g6, %g1, 12
	ld	%g7, %g1, 8
	ld	%g29, %g1, 24
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 2
	ld	%g5, %g1, 4
	st	%g3, %g1, 28
	mov	%g3, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	add_mod5.2721
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g7, %g3
	ld	%g3, %g1, 28
	ld	%g4, %g1, 12
	ld	%g5, %g1, 8
	ld	%g6, %g1, 16
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
create_float5x3array.3137:
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g4, l.6510
	fld	%f0, %g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 5
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	st	%g3, %g4, -4
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	st	%g3, %g4, -8
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	st	%g3, %g4, -12
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	st	%g3, %g4, -16
	mov	%g3, %g4
	return
create_pixel.3139:
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g4, l.6510
	fld	%f0, %g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	st	%g3, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	create_float5x3array.3137
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 5
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 4
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 5
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 8
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	create_float5x3array.3137
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	create_float5x3array.3137
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 20
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_create_array
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	st	%g3, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	create_float5x3array.3137
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g2
	addi	%g2, %g2, 32
	st	%g3, %g4, -28
	ld	%g3, %g1, 24
	st	%g3, %g4, -24
	ld	%g3, %g1, 20
	st	%g3, %g4, -20
	ld	%g3, %g1, 16
	st	%g3, %g4, -16
	ld	%g3, %g1, 12
	st	%g3, %g4, -12
	ld	%g3, %g1, 8
	st	%g3, %g4, -8
	ld	%g3, %g1, 4
	st	%g3, %g4, -4
	ld	%g3, %g1, 0
	st	%g3, %g4, 0
	mov	%g3, %g4
	return
init_line_elements.3141:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jlt	%g4, %g5, jle_else.10289
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	create_pixel.3139
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
	jmp	init_line_elements.3141
jle_else.10289:
	return
create_pixelline.3144:
	ld	%g3, %g29, -4
	ld	%g4, %g3, 0
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	create_pixel.3139
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mov	%g4, %g3
	ld	%g3, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 0
	ld	%g4, %g4, 0
	subi	%g4, %g4, 2
	jmp	init_line_elements.3141
tan.3146:
	ld	%g3, %g29, -8
	ld	%g4, %g29, -4
	fst	%f0, %g1, 0
	st	%g4, %g1, 4
	mov	%g29, %g3
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f1, %g1, 0
	ld	%g29, %g1, 4
	fst	%f0, %g1, 8
	fmov	%f0, %f1
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f1, %g1, 8
	fdiv	%f0, %f1, %f0
	return
adjust_position.3148:
	ld	%g3, %g29, -4
	fmul	%f0, %f0, %f0
	setL %g4, l.7406
	fld	%f2, %g4, 0
	fadd	%f0, %f0, %f2
	st	%g3, %g1, 0
	fst	%f1, %g1, 4
	fsqrt	%f0, %f0
	setL %g3, l.6519
	fld	%f1, %g3, 0
	fdiv	%f1, %f1, %f0
	fst	%f0, %g1, 8
	fmov	%f0, %f1
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	atan.2669
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f1, %g1, 4
	fmul	%f0, %f0, %f1
	ld	%g29, %g1, 0
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f1, %g1, 8
	fmul	%f0, %f0, %f1
	return
calc_dirvec.3151:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	mvhi	%g8, 0
	mvlo	%g8, 5
	jlt	%g3, %g8, jle_else.10290
	st	%g5, %g1, 0
	st	%g6, %g1, 4
	st	%g4, %g1, 8
	fst	%f0, %g1, 12
	fst	%f1, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fsqr.2664
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 16
	fst	%f0, %g1, 20
	fmov	%f0, %f1
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fsqr.2664
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 20
	fadd	%f0, %f1, %f0
	setL %g3, l.6519
	fld	%f1, %g3, 0
	fadd	%f0, %f0, %f1
	fsqrt	%f0, %f0
	fld	%f1, %g1, 12
	fdiv	%f1, %f1, %f0
	fld	%f2, %g1, 16
	fdiv	%f2, %f2, %f0
	setL %g3, l.6519
	fld	%f3, %g3, 0
	fdiv	%f0, %f3, %f0
	ld	%g3, %g1, 8
	slli	%g3, %g3, 2
	ld	%g4, %g1, 4
	st	%g4, %g1, 28
	add	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 28
	ld	%g4, %g1, 0
	slli	%g5, %g4, 2
	st	%g3, %g1, 28
	add	%g3, %g3, %g5
	ld	%g5, %g3, 0
	ld	%g3, %g1, 28
	st	%g3, %g1, 24
	fst	%f0, %g1, 28
	fst	%f2, %g1, 32
	fst	%f1, %g1, 36
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	d_vec.2831
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f0, %g1, 36
	fld	%f1, %g1, 32
	fld	%f2, %g1, 28
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecset.2724
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 0
	addi	%g4, %g3, 40
	slli	%g4, %g4, 2
	ld	%g5, %g1, 24
	st	%g5, %g1, 44
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 44
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	d_vec.2831
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f0, %g1, 32
	st	%g3, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fneg.2660
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fmov	%f2, %f0, 0
	fld	%f0, %g1, 36
	fld	%f1, %g1, 28
	ld	%g3, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecset.2724
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 0
	addi	%g4, %g3, 80
	slli	%g4, %g4, 2
	ld	%g5, %g1, 24
	st	%g5, %g1, 44
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 44
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	d_vec.2831
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f0, %g1, 36
	st	%g3, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2660
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 32
	fst	%f0, %g1, 48
	fmov	%f0, %f1
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2660
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fmov	%f2, %f0, 0
	fld	%f0, %g1, 28
	fld	%f1, %g1, 48
	ld	%g3, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	vecset.2724
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 0
	addi	%g4, %g3, 1
	slli	%g4, %g4, 2
	ld	%g5, %g1, 24
	st	%g5, %g1, 52
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 52
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	d_vec.2831
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f0, %g1, 36
	st	%g3, %g1, 52
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fneg.2660
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 32
	fst	%f0, %g1, 56
	fmov	%f0, %f1
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fneg.2660
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 28
	fst	%f0, %g1, 60
	fmov	%f0, %f1
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fneg.2660
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fmov	%f2, %f0, 0
	fld	%f0, %g1, 56
	fld	%f1, %g1, 60
	ld	%g3, %g1, 52
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	vecset.2724
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 0
	addi	%g4, %g3, 41
	slli	%g4, %g4, 2
	ld	%g5, %g1, 24
	st	%g5, %g1, 68
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 68
	mov	%g3, %g4
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	d_vec.2831
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f0, %g1, 36
	st	%g3, %g1, 64
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fneg.2660
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 28
	fst	%f0, %g1, 68
	fmov	%f0, %f1
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fneg.2660
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 68
	fld	%f2, %g1, 32
	ld	%g3, %g1, 64
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	vecset.2724
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g3, %g1, 0
	addi	%g3, %g3, 81
	slli	%g3, %g3, 2
	ld	%g4, %g1, 24
	st	%g4, %g1, 76
	add	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 76
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	d_vec.2831
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f0, %g1, 28
	st	%g3, %g1, 72
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fneg.2660
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 36
	fld	%f2, %g1, 32
	ld	%g3, %g1, 72
	jmp	vecset.2724
jle_else.10290:
	fst	%f2, %g1, 76
	st	%g5, %g1, 0
	st	%g4, %g1, 8
	st	%g29, %g1, 80
	fst	%f3, %g1, 84
	st	%g7, %g1, 88
	st	%g3, %g1, 92
	mov	%g29, %g7
	fmov	%f0, %f1
	fmov	%f1, %f2
	st	%g31, %g1, 100
	ld	%g28, %g29, 0
	subi	%g1, %g1, 104
	callR	%g28
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	ld	%g3, %g1, 92
	addi	%g3, %g3, 1
	fld	%f1, %g1, 84
	ld	%g29, %g1, 88
	fst	%f0, %g1, 96
	st	%g3, %g1, 100
	st	%g31, %g1, 108
	ld	%g28, %g29, 0
	subi	%g1, %g1, 112
	callR	%g28
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	fmov	%f1, %f0
	fld	%f0, %g1, 96
	fld	%f2, %g1, 76
	fld	%f3, %g1, 84
	ld	%g3, %g1, 100
	ld	%g4, %g1, 8
	ld	%g5, %g1, 0
	ld	%g29, %g1, 80
	ld	%g28, %g29, 0
	b	%g28
calc_dirvecs.3159:
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g3, %g7, jle_else.10291
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	fst	%f0, %g1, 8
	st	%g5, %g1, 12
	st	%g4, %g1, 16
	st	%g6, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	setL %g3, l.7622
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.7624
	fld	%f1, %g3, 0
	fsub	%f2, %f0, %f1
	mvhi	%g3, 0
	mvlo	%g3, 0
	setL %g4, l.6510
	fld	%f0, %g4, 0
	setL %g4, l.6510
	fld	%f1, %g4, 0
	fld	%f3, %g1, 8
	ld	%g4, %g1, 16
	ld	%g5, %g1, 12
	ld	%g29, %g1, 20
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	setL %g3, l.7622
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.7406
	fld	%f1, %g3, 0
	fadd	%f2, %f0, %f1
	mvhi	%g3, 0
	mvlo	%g3, 0
	setL %g4, l.6510
	fld	%f0, %g4, 0
	setL %g4, l.6510
	fld	%f1, %g4, 0
	ld	%g4, %g1, 12
	addi	%g5, %g4, 2
	fld	%f3, %g1, 8
	ld	%g6, %g1, 16
	ld	%g29, %g1, 20
	mov	%g4, %g6
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 1
	ld	%g5, %g1, 16
	st	%g3, %g1, 24
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	add_mod5.2721
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g3
	fld	%f0, %g1, 8
	ld	%g3, %g1, 24
	ld	%g5, %g1, 12
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10291:
	return
calc_dirvec_rows.3164:
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g3, %g7, jle_else.10293
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	st	%g5, %g1, 8
	st	%g4, %g1, 12
	st	%g6, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_float_of_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	setL %g3, l.7622
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.7624
	fld	%f1, %g3, 0
	fsub	%f0, %f0, %f1
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 12
	ld	%g5, %g1, 8
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 2
	ld	%g5, %g1, 12
	st	%g3, %g1, 20
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	add_mod5.2721
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g3
	ld	%g3, %g1, 8
	addi	%g5, %g3, 4
	ld	%g3, %g1, 20
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10293:
	return
create_dirvec.3168:
	ld	%g3, %g29, -4
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g4, %g3
	ld	%g3, %g1, 0
	ld	%g3, %g3, 0
	st	%g4, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 4
	st	%g3, %g4, 0
	mov	%g3, %g4
	return
create_dirvec_elements.3170:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g4, %g6, jle_else.10295
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	st	%g4, %g1, 8
	mov	%g29, %g5
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 8
	slli	%g5, %g4, 2
	ld	%g6, %g1, 4
	st	%g6, %g1, 12
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 12
	subi	%g4, %g4, 1
	ld	%g29, %g1, 0
	mov	%g3, %g6
	ld	%g28, %g29, 0
	b	%g28
jle_else.10295:
	return
create_dirvecs.3173:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g3, %g7, jle_else.10297
	mvhi	%g7, 0
	mvlo	%g7, 120
	st	%g29, %g1, 0
	st	%g5, %g1, 4
	st	%g4, %g1, 8
	st	%g3, %g1, 12
	st	%g7, %g1, 16
	mov	%g29, %g6
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g3
	ld	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 12
	slli	%g5, %g4, 2
	ld	%g6, %g1, 8
	st	%g6, %g1, 20
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 20
	slli	%g3, %g4, 2
	st	%g6, %g1, 20
	add	%g6, %g6, %g3
	ld	%g3, %g6, 0
	ld	%g6, %g1, 20
	mvhi	%g5, 0
	mvlo	%g5, 118
	ld	%g29, %g1, 4
	mov	%g4, %g5
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	subi	%g3, %g3, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10297:
	return
init_dirvec_constants.3175:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g4, %g6, jle_else.10299
	slli	%g6, %g4, 2
	st	%g3, %g1, 4
	add	%g3, %g3, %g6
	ld	%g6, %g3, 0
	ld	%g3, %g1, 4
	st	%g3, %g1, 0
	st	%g29, %g1, 4
	st	%g4, %g1, 8
	mov	%g3, %g6
	mov	%g29, %g5
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
jle_else.10299:
	return
init_vecset_constants.3178:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g3, %g6, jle_else.10301
	slli	%g6, %g3, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g6
	ld	%g5, %g5, 0
	mvhi	%g6, 0
	mvlo	%g6, 119
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
jle_else.10301:
	return
init_dirvecs.3180:
	ld	%g3, %g29, -12
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 4
	st	%g3, %g1, 0
	st	%g5, %g1, 4
	mov	%g3, %g6
	mov	%g29, %g4
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g3, 0
	mvlo	%g3, 9
	mvhi	%g4, 0
	mvlo	%g4, 0
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g29, %g1, 4
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
add_reflection.3182:
	ld	%g5, %g29, -12
	ld	%g6, %g29, -8
	ld	%g29, %g29, -4
	st	%g6, %g1, 0
	st	%g3, %g1, 4
	st	%g4, %g1, 8
	fst	%f0, %g1, 12
	st	%g5, %g1, 16
	fst	%f3, %g1, 20
	fst	%f2, %g1, 24
	fst	%f1, %g1, 28
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	st	%g3, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	d_vec.2831
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f0, %g1, 28
	fld	%f1, %g1, 24
	fld	%f2, %g1, 20
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	vecset.2724
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	ld	%g29, %g1, 16
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g3, %g2
	addi	%g2, %g2, 16
	fld	%f0, %g1, 12
	fst	%f0, %g3, -8
	ld	%g4, %g1, 32
	st	%g4, %g3, -4
	ld	%g4, %g1, 8
	st	%g4, %g3, 0
	ld	%g4, %g1, 4
	slli	%g4, %g4, 2
	ld	%g5, %g1, 0
	st	%g5, %g1, 36
	add	%g5, %g5, %g4
	st	%g3, %g5, 0
	ld	%g5, %g1, 36
	return
setup_rect_reflection.3189:
	ld	%g5, %g29, -12
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	muli	%g3, %g3, 4
	ld	%g8, %g5, 0
	setL %g9, l.6519
	fld	%f0, %g9, 0
	st	%g5, %g1, 0
	st	%g8, %g1, 4
	st	%g7, %g1, 8
	st	%g3, %g1, 12
	st	%g6, %g1, 16
	fst	%f0, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_diffuse.2794
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 20
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fld	%f1, %g3, 0
	fst	%f0, %g1, 24
	fmov	%f0, %f1
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fneg.2660
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 16
	fld	%f1, %g3, -4
	fst	%f0, %g1, 28
	fmov	%f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2660
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 16
	fld	%f1, %g3, -8
	fst	%f0, %g1, 32
	fmov	%f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2660
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fmov	%f3, %f0, 0
	ld	%g3, %g1, 12
	addi	%g4, %g3, 1
	ld	%g5, %g1, 16
	fld	%f1, %g5, 0
	fld	%f0, %g1, 24
	fld	%f2, %g1, 32
	ld	%g6, %g1, 4
	ld	%g29, %g1, 8
	fst	%f3, %g1, 36
	mov	%g3, %g6
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 4
	addi	%g4, %g3, 1
	ld	%g5, %g1, 12
	addi	%g6, %g5, 2
	ld	%g7, %g1, 16
	fld	%f2, %g7, -4
	fld	%f0, %g1, 24
	fld	%f1, %g1, 28
	fld	%f3, %g1, 36
	ld	%g29, %g1, 8
	mov	%g3, %g4
	mov	%g4, %g6
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 4
	addi	%g4, %g3, 2
	ld	%g5, %g1, 12
	addi	%g5, %g5, 3
	ld	%g6, %g1, 16
	fld	%f3, %g6, -8
	fld	%f0, %g1, 24
	fld	%f1, %g1, 28
	fld	%f2, %g1, 32
	ld	%g29, %g1, 8
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 4
	addi	%g3, %g3, 3
	ld	%g4, %g1, 0
	st	%g3, %g4, 0
	return
setup_surface_reflection.3192:
	ld	%g5, %g29, -12
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	muli	%g3, %g3, 4
	addi	%g3, %g3, 1
	ld	%g8, %g5, 0
	setL %g9, l.6519
	fld	%f0, %g9, 0
	st	%g5, %g1, 0
	st	%g3, %g1, 4
	st	%g8, %g1, 8
	st	%g7, %g1, 12
	st	%g6, %g1, 16
	st	%g4, %g1, 20
	fst	%f0, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_diffuse.2794
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 20
	fst	%f0, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_abc.2786
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g4, %g3
	ld	%g3, %g1, 16
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	veciprod.2745
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	setL %g3, l.6515
	fld	%f1, %g3, 0
	ld	%g3, %g1, 20
	fst	%f0, %g1, 32
	fst	%f1, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_a.2780
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 32
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 16
	fld	%f2, %g3, 0
	fsub	%f0, %f0, %f2
	setL %g4, l.6515
	fld	%f2, %g4, 0
	ld	%g4, %g1, 20
	fst	%f0, %g1, 40
	fst	%f2, %g1, 44
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_b.2782
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 44
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 32
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 16
	fld	%f2, %g3, -4
	fsub	%f0, %f0, %f2
	setL %g4, l.6515
	fld	%f2, %g4, 0
	ld	%g4, %g1, 20
	fst	%f0, %g1, 48
	fst	%f2, %g1, 52
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_c.2784
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 52
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 32
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 16
	fld	%f1, %g3, -8
	fsub	%f3, %f0, %f1
	fld	%f0, %g1, 28
	fld	%f1, %g1, 40
	fld	%f2, %g1, 48
	ld	%g3, %g1, 8
	ld	%g4, %g1, 4
	ld	%g29, %g1, 12
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 8
	addi	%g3, %g3, 1
	ld	%g4, %g1, 0
	st	%g3, %g4, 0
	return
setup_reflections.3195:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g3, %g7, jle_else.10306
	slli	%g7, %g3, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g7
	ld	%g6, %g6, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	st	%g5, %g1, 8
	st	%g6, %g1, 12
	mov	%g3, %g6
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_reflectiontype.2774
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.10307
	ld	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_diffuse.2794
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	setL %g3, l.6519
	fld	%f1, %g3, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fless.2646
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10308
	return
jeq_else.10308:
	ld	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_form.2772
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.10310
	ld	%g3, %g1, 4
	ld	%g4, %g1, 12
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10310:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.10311
	ld	%g3, %g1, 4
	ld	%g4, %g1, 12
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10311:
	return
jeq_else.10307:
	return
jle_else.10306:
	return
rt.3197:
	ld	%g5, %g29, -56
	ld	%g6, %g29, -52
	ld	%g7, %g29, -48
	ld	%g8, %g29, -44
	ld	%g9, %g29, -40
	ld	%g10, %g29, -36
	ld	%g11, %g29, -32
	ld	%g12, %g29, -28
	ld	%g13, %g29, -24
	ld	%g14, %g29, -20
	ld	%g15, %g29, -16
	ld	%g16, %g29, -12
	ld	%g17, %g29, -8
	ld	%g18, %g29, -4
	st	%g3, %g16, 0
	st	%g4, %g16, -4
	divi	%g16, %g3, 2
	st	%g16, %g17, 0
	divi	%g4, %g4, 2
	st	%g4, %g17, -4
	setL %g4, l.7689
	fld	%f0, %g4, 0
	st	%g9, %g1, 0
	st	%g11, %g1, 4
	st	%g6, %g1, 8
	st	%g12, %g1, 12
	st	%g7, %g1, 16
	st	%g14, %g1, 20
	st	%g13, %g1, 24
	st	%g15, %g1, 28
	st	%g5, %g1, 32
	st	%g10, %g1, 36
	st	%g18, %g1, 40
	st	%g8, %g1, 44
	fst	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 48
	fdiv	%f0, %f1, %f0
	ld	%g3, %g1, 44
	fst	%f0, %g3, 0
	ld	%g29, %g1, 40
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g29, %g1, 40
	st	%g3, %g1, 52
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g29, %g1, 40
	st	%g3, %g1, 56
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g29, %g1, 36
	st	%g3, %g1, 60
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g29, %g1, 32
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g29, %g1, 28
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 24
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	d_vec.2831
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g4, %g1, 20
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	veccpy.2734
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 24
	ld	%g29, %g1, 16
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 12
	ld	%g3, %g3, 0
	subi	%g3, %g3, 1
	ld	%g29, %g1, 8
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g3, %g1, 56
	ld	%g29, %g1, 4
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g3, 0
	mvlo	%g3, 0
	mvhi	%g7, 0
	mvlo	%g7, 2
	ld	%g4, %g1, 52
	ld	%g5, %g1, 56
	ld	%g6, %g1, 60
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
min_caml_start:
	setL %g3, l.7694
	fld	%f0, %g3, 0
	setL %g3, l.7696
	fld	%f1, %g3, 0
	setL %g3, l.6532
	fld	%f2, %g3, 0
	mov	%g3, %g2
	addi	%g2, %g2, 32
	setL %g4, sin.2671
	st	%g4, %g3, 0
	fst	%f2, %g3, -24
	fst	%f1, %g3, -16
	fst	%f0, %g3, -8
	mov	%g4, %g2
	addi	%g2, %g2, 8
	setL %g5, cos.2673
	st	%g5, %g4, 0
	st	%g3, %g4, -4
	mvhi	%g5, 0
	mvlo	%g5, 1
	mvhi	%g6, 0
	mvlo	%g6, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	mov	%g4, %g6
	mov	%g3, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 8
	mov	%g3, %g4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 60
	mvhi	%g5, 0
	mvlo	%g5, 0
	mvhi	%g6, 0
	mvlo	%g6, 0
	mvhi	%g7, 0
	mvlo	%g7, 0
	mvhi	%g8, 0
	mvlo	%g8, 0
	mvhi	%g9, 0
	mvlo	%g9, 0
	mov	%g10, %g2
	addi	%g2, %g2, 48
	st	%g3, %g10, -40
	st	%g3, %g10, -36
	st	%g3, %g10, -32
	st	%g3, %g10, -28
	st	%g9, %g10, -24
	st	%g3, %g10, -20
	st	%g3, %g10, -16
	st	%g8, %g10, -12
	st	%g7, %g10, -8
	st	%g6, %g10, -4
	st	%g5, %g10, 0
	mov	%g3, %g10
	mov	%g28, %g4
	mov	%g4, %g3
	mov	%g3, %g28
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 12
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_float_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 16
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_float_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_create_float_array
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 1
	setL %g5, l.7320
	fld	%f0, %g5, 0
	st	%g3, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_create_float_array
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 50
	mvhi	%g5, 0
	mvlo	%g5, 1
	mvhi	%g6, 65535
	mvlo	%g6, -1
	st	%g3, %g1, 28
	st	%g4, %g1, 32
	mov	%g4, %g6
	mov	%g3, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_create_array
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g4, %g3
	ld	%g3, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_create_array
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 1
	ld	%g6, %g3, 0
	st	%g3, %g1, 36
	st	%g4, %g1, 40
	mov	%g4, %g6
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mov	%g4, %g3
	ld	%g3, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 1
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 44
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	min_caml_create_float_array
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 48
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	min_caml_create_array
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 1
	setL %g5, l.7219
	fld	%f0, %g5, 0
	st	%g3, %g1, 52
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	min_caml_create_float_array
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 56
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	min_caml_create_float_array
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 60
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	min_caml_create_array
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 64
	mov	%g3, %g4
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	min_caml_create_float_array
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 68
	mov	%g3, %g4
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	min_caml_create_float_array
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 72
	mov	%g3, %g4
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	min_caml_create_float_array
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 76
	mov	%g3, %g4
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	min_caml_create_float_array
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g4, 0
	mvlo	%g4, 2
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 80
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	min_caml_create_array
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g4, 0
	mvlo	%g4, 2
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 84
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	min_caml_create_array
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	mvhi	%g4, 0
	mvlo	%g4, 1
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 88
	mov	%g3, %g4
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	min_caml_create_float_array
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 92
	mov	%g3, %g4
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	min_caml_create_float_array
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 96
	mov	%g3, %g4
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	min_caml_create_float_array
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 100
	mov	%g3, %g4
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	min_caml_create_float_array
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 104
	mov	%g3, %g4
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	min_caml_create_float_array
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 108
	mov	%g3, %g4
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	min_caml_create_float_array
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 112
	mov	%g3, %g4
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	min_caml_create_float_array
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	mvhi	%g4, 0
	mvlo	%g4, 0
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 116
	mov	%g3, %g4
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	min_caml_create_float_array
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 0
	st	%g4, %g1, 120
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	min_caml_create_array
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	mvhi	%g4, 0
	mvlo	%g4, 0
	mov	%g5, %g2
	addi	%g2, %g2, 8
	st	%g3, %g5, -4
	ld	%g3, %g1, 120
	st	%g3, %g5, 0
	mov	%g3, %g5
	mov	%g28, %g4
	mov	%g4, %g3
	mov	%g3, %g28
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	min_caml_create_array
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 5
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	min_caml_create_array
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	mvhi	%g4, 0
	mvlo	%g4, 0
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 124
	mov	%g3, %g4
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	min_caml_create_float_array
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 128
	mov	%g3, %g4
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	min_caml_create_float_array
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	mvhi	%g4, 0
	mvlo	%g4, 60
	ld	%g5, %g1, 128
	st	%g3, %g1, 132
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	min_caml_create_array
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 132
	st	%g3, %g4, 0
	mov	%g3, %g4
	mvhi	%g4, 0
	mvlo	%g4, 0
	setL %g5, l.6510
	fld	%f0, %g5, 0
	st	%g3, %g1, 136
	mov	%g3, %g4
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	min_caml_create_float_array
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 0
	st	%g4, %g1, 140
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	min_caml_create_array
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 140
	st	%g3, %g4, 0
	mov	%g3, %g4
	mvhi	%g4, 0
	mvlo	%g4, 180
	mvhi	%g5, 0
	mvlo	%g5, 0
	setL %g6, l.6510
	fld	%f0, %g6, 0
	mov	%g6, %g2
	addi	%g2, %g2, 16
	fst	%f0, %g6, -8
	st	%g3, %g6, -4
	st	%g5, %g6, 0
	mov	%g3, %g6
	mov	%g28, %g4
	mov	%g4, %g3
	mov	%g3, %g28
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	min_caml_create_array
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 144
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	min_caml_create_array
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	mov	%g4, %g2
	addi	%g2, %g2, 32
	setL %g5, read_screen_settings.2843
	st	%g5, %g4, 0
	ld	%g5, %g1, 20
	st	%g5, %g4, -28
	ld	%g6, %g1, 4
	st	%g6, %g4, -24
	ld	%g7, %g1, 112
	st	%g7, %g4, -20
	ld	%g8, %g1, 108
	st	%g8, %g4, -16
	ld	%g9, %g1, 104
	st	%g9, %g4, -12
	ld	%g10, %g1, 16
	st	%g10, %g4, -8
	ld	%g10, %g1, 0
	st	%g10, %g4, -4
	mov	%g11, %g2
	addi	%g2, %g2, 24
	setL %g12, read_light.2845
	st	%g12, %g11, 0
	st	%g6, %g11, -16
	ld	%g12, %g1, 24
	st	%g12, %g11, -12
	st	%g10, %g11, -8
	ld	%g13, %g1, 28
	st	%g13, %g11, -4
	mov	%g14, %g2
	addi	%g2, %g2, 16
	setL %g15, rotate_quadratic_matrix.2847
	st	%g15, %g14, 0
	st	%g6, %g14, -8
	st	%g10, %g14, -4
	mov	%g15, %g2
	addi	%g2, %g2, 16
	setL %g16, read_nth_object.2850
	st	%g16, %g15, 0
	st	%g14, %g15, -8
	ld	%g14, %g1, 12
	st	%g14, %g15, -4
	mov	%g16, %g2
	addi	%g2, %g2, 16
	setL %g17, read_object.2852
	st	%g17, %g16, 0
	st	%g15, %g16, -8
	ld	%g15, %g1, 8
	st	%g15, %g16, -4
	mov	%g17, %g2
	addi	%g2, %g2, 8
	setL %g18, read_all_object.2854
	st	%g18, %g17, 0
	st	%g16, %g17, -4
	mov	%g16, %g2
	addi	%g2, %g2, 8
	setL %g18, read_and_network.2860
	st	%g18, %g16, 0
	ld	%g18, %g1, 36
	st	%g18, %g16, -4
	mov	%g19, %g2
	addi	%g2, %g2, 24
	setL %g20, read_parameter.2862
	st	%g20, %g19, 0
	st	%g4, %g19, -20
	st	%g11, %g19, -16
	st	%g16, %g19, -12
	st	%g17, %g19, -8
	ld	%g4, %g1, 44
	st	%g4, %g19, -4
	mov	%g11, %g2
	addi	%g2, %g2, 8
	setL %g16, solver_rect_surface.2864
	st	%g16, %g11, 0
	ld	%g16, %g1, 48
	st	%g16, %g11, -4
	mov	%g17, %g2
	addi	%g2, %g2, 8
	setL %g20, solver_rect.2873
	st	%g20, %g17, 0
	st	%g11, %g17, -4
	mov	%g11, %g2
	addi	%g2, %g2, 8
	setL %g20, solver_surface.2879
	st	%g20, %g11, 0
	st	%g16, %g11, -4
	mov	%g20, %g2
	addi	%g2, %g2, 8
	setL %g21, solver_second.2898
	st	%g21, %g20, 0
	st	%g16, %g20, -4
	mov	%g21, %g2
	addi	%g2, %g2, 24
	setL %g22, solver.2904
	st	%g22, %g21, 0
	st	%g11, %g21, -16
	st	%g20, %g21, -12
	st	%g17, %g21, -8
	st	%g14, %g21, -4
	mov	%g11, %g2
	addi	%g2, %g2, 8
	setL %g17, solver_rect_fast.2908
	st	%g17, %g11, 0
	st	%g16, %g11, -4
	mov	%g17, %g2
	addi	%g2, %g2, 8
	setL %g20, solver_surface_fast.2915
	st	%g20, %g17, 0
	st	%g16, %g17, -4
	mov	%g20, %g2
	addi	%g2, %g2, 8
	setL %g22, solver_second_fast.2921
	st	%g22, %g20, 0
	st	%g16, %g20, -4
	mov	%g22, %g2
	addi	%g2, %g2, 24
	setL %g23, solver_fast.2927
	st	%g23, %g22, 0
	st	%g17, %g22, -16
	st	%g20, %g22, -12
	st	%g11, %g22, -8
	st	%g14, %g22, -4
	mov	%g17, %g2
	addi	%g2, %g2, 8
	setL %g20, solver_surface_fast2.2931
	st	%g20, %g17, 0
	st	%g16, %g17, -4
	mov	%g20, %g2
	addi	%g2, %g2, 8
	setL %g23, solver_second_fast2.2938
	st	%g23, %g20, 0
	st	%g16, %g20, -4
	mov	%g23, %g2
	addi	%g2, %g2, 24
	setL %g24, solver_fast2.2945
	st	%g24, %g23, 0
	st	%g17, %g23, -16
	st	%g20, %g23, -12
	st	%g11, %g23, -8
	st	%g14, %g23, -4
	mov	%g11, %g2
	addi	%g2, %g2, 8
	setL %g17, iter_setup_dirvec_constants.2957
	st	%g17, %g11, 0
	st	%g14, %g11, -4
	mov	%g17, %g2
	addi	%g2, %g2, 16
	setL %g20, setup_dirvec_constants.2960
	st	%g20, %g17, 0
	st	%g15, %g17, -8
	st	%g11, %g17, -4
	mov	%g11, %g2
	addi	%g2, %g2, 8
	setL %g20, setup_startp_constants.2962
	st	%g20, %g11, 0
	st	%g14, %g11, -4
	mov	%g20, %g2
	addi	%g2, %g2, 16
	setL %g24, setup_startp.2965
	st	%g24, %g20, 0
	ld	%g24, %g1, 100
	st	%g24, %g20, -12
	st	%g11, %g20, -8
	st	%g15, %g20, -4
	mov	%g11, %g2
	addi	%g2, %g2, 8
	setL %g25, check_all_inside.2987
	st	%g25, %g11, 0
	st	%g14, %g11, -4
	mov	%g25, %g2
	addi	%g2, %g2, 32
	setL %g26, shadow_check_and_group.2993
	st	%g26, %g25, 0
	st	%g22, %g25, -28
	st	%g16, %g25, -24
	st	%g14, %g25, -20
	ld	%g26, %g1, 136
	st	%g26, %g25, -16
	st	%g12, %g25, -12
	ld	%g27, %g1, 60
	st	%g27, %g25, -8
	st	%g11, %g25, -4
	mov	%g28, %g2
	addi	%g2, %g2, 16
	setL %g29, shadow_check_one_or_group.2996
	st	%g29, %g28, 0
	st	%g25, %g28, -8
	st	%g18, %g28, -4
	mov	%g25, %g2
	addi	%g2, %g2, 24
	setL %g29, shadow_check_one_or_matrix.2999
	st	%g29, %g25, 0
	st	%g22, %g25, -20
	st	%g16, %g25, -16
	st	%g28, %g25, -12
	st	%g26, %g25, -8
	st	%g27, %g25, -4
	mov	%g22, %g2
	addi	%g2, %g2, 40
	setL %g28, solve_each_element.3002
	st	%g28, %g22, 0
	ld	%g28, %g1, 56
	st	%g28, %g22, -36
	ld	%g29, %g1, 96
	st	%g29, %g22, -32
	st	%g16, %g22, -28
	st	%g21, %g22, -24
	st	%g14, %g22, -20
	ld	%g26, %g1, 52
	st	%g26, %g22, -16
	st	%g27, %g22, -12
	st	%g19, %g1, 148
	ld	%g19, %g1, 64
	st	%g19, %g22, -8
	st	%g11, %g22, -4
	st	%g17, %g1, 152
	mov	%g17, %g2
	addi	%g2, %g2, 16
	setL %g15, solve_one_or_network.3006
	st	%g15, %g17, 0
	st	%g22, %g17, -8
	st	%g18, %g17, -4
	mov	%g15, %g2
	addi	%g2, %g2, 24
	setL %g22, trace_or_matrix.3010
	st	%g22, %g15, 0
	st	%g28, %g15, -20
	st	%g29, %g15, -16
	st	%g16, %g15, -12
	st	%g21, %g15, -8
	st	%g17, %g15, -4
	mov	%g17, %g2
	addi	%g2, %g2, 16
	setL %g21, judge_intersection.3014
	st	%g21, %g17, 0
	st	%g15, %g17, -12
	st	%g28, %g17, -8
	st	%g4, %g17, -4
	mov	%g15, %g2
	addi	%g2, %g2, 40
	setL %g21, solve_each_element_fast.3016
	st	%g21, %g15, 0
	st	%g28, %g15, -36
	st	%g24, %g15, -32
	st	%g23, %g15, -28
	st	%g16, %g15, -24
	st	%g14, %g15, -20
	st	%g26, %g15, -16
	st	%g27, %g15, -12
	st	%g19, %g15, -8
	st	%g11, %g15, -4
	mov	%g11, %g2
	addi	%g2, %g2, 16
	setL %g21, solve_one_or_network_fast.3020
	st	%g21, %g11, 0
	st	%g15, %g11, -8
	st	%g18, %g11, -4
	mov	%g15, %g2
	addi	%g2, %g2, 24
	setL %g18, trace_or_matrix_fast.3024
	st	%g18, %g15, 0
	st	%g28, %g15, -16
	st	%g23, %g15, -12
	st	%g16, %g15, -8
	st	%g11, %g15, -4
	mov	%g11, %g2
	addi	%g2, %g2, 16
	setL %g16, judge_intersection_fast.3028
	st	%g16, %g11, 0
	st	%g15, %g11, -12
	st	%g28, %g11, -8
	st	%g4, %g11, -4
	mov	%g15, %g2
	addi	%g2, %g2, 16
	setL %g16, get_nvector_rect.3030
	st	%g16, %g15, 0
	ld	%g16, %g1, 68
	st	%g16, %g15, -8
	st	%g26, %g15, -4
	mov	%g18, %g2
	addi	%g2, %g2, 8
	setL %g21, get_nvector_plane.3032
	st	%g21, %g18, 0
	st	%g16, %g18, -4
	mov	%g21, %g2
	addi	%g2, %g2, 16
	setL %g22, get_nvector_second.3034
	st	%g22, %g21, 0
	st	%g16, %g21, -8
	st	%g27, %g21, -4
	mov	%g22, %g2
	addi	%g2, %g2, 16
	setL %g23, get_nvector.3036
	st	%g23, %g22, 0
	st	%g21, %g22, -12
	st	%g15, %g22, -8
	st	%g18, %g22, -4
	mov	%g15, %g2
	addi	%g2, %g2, 16
	setL %g18, utexture.3039
	st	%g18, %g15, 0
	ld	%g18, %g1, 72
	st	%g18, %g15, -12
	st	%g6, %g15, -8
	st	%g10, %g15, -4
	mov	%g21, %g2
	addi	%g2, %g2, 16
	setL %g23, add_light.3042
	st	%g23, %g21, 0
	st	%g18, %g21, -8
	ld	%g23, %g1, 80
	st	%g23, %g21, -4
	mov	%g24, %g2
	addi	%g2, %g2, 40
	setL %g10, trace_reflections.3046
	st	%g10, %g24, 0
	st	%g25, %g24, -32
	ld	%g10, %g1, 144
	st	%g10, %g24, -28
	st	%g4, %g24, -24
	st	%g16, %g24, -20
	st	%g11, %g24, -16
	st	%g26, %g24, -12
	st	%g19, %g24, -8
	st	%g21, %g24, -4
	mov	%g10, %g2
	addi	%g2, %g2, 88
	setL %g6, trace_ray.3051
	st	%g6, %g10, 0
	st	%g15, %g10, -80
	st	%g24, %g10, -76
	st	%g28, %g10, -72
	st	%g18, %g10, -68
	st	%g29, %g10, -64
	st	%g25, %g10, -60
	st	%g20, %g10, -56
	st	%g23, %g10, -52
	st	%g4, %g10, -48
	st	%g14, %g10, -44
	st	%g16, %g10, -40
	st	%g3, %g10, -36
	st	%g12, %g10, -32
	st	%g17, %g10, -28
	st	%g26, %g10, -24
	st	%g27, %g10, -20
	st	%g19, %g10, -16
	st	%g22, %g10, -12
	st	%g13, %g10, -8
	st	%g21, %g10, -4
	mov	%g6, %g2
	addi	%g2, %g2, 56
	setL %g13, trace_diffuse_ray.3057
	st	%g13, %g6, 0
	st	%g15, %g6, -48
	st	%g18, %g6, -44
	st	%g25, %g6, -40
	st	%g4, %g6, -36
	st	%g14, %g6, -32
	st	%g16, %g6, -28
	st	%g12, %g6, -24
	st	%g11, %g6, -20
	st	%g27, %g6, -16
	st	%g19, %g6, -12
	st	%g22, %g6, -8
	ld	%g4, %g1, 76
	st	%g4, %g6, -4
	mov	%g11, %g2
	addi	%g2, %g2, 8
	setL %g13, iter_trace_diffuse_rays.3060
	st	%g13, %g11, 0
	st	%g6, %g11, -4
	mov	%g6, %g2
	addi	%g2, %g2, 16
	setL %g13, trace_diffuse_rays.3065
	st	%g13, %g6, 0
	st	%g20, %g6, -8
	st	%g11, %g6, -4
	mov	%g11, %g2
	addi	%g2, %g2, 16
	setL %g13, trace_diffuse_ray_80percent.3069
	st	%g13, %g11, 0
	st	%g6, %g11, -8
	ld	%g13, %g1, 124
	st	%g13, %g11, -4
	mov	%g15, %g2
	addi	%g2, %g2, 16
	setL %g16, calc_diffuse_using_1point.3073
	st	%g16, %g15, 0
	st	%g11, %g15, -12
	st	%g23, %g15, -8
	st	%g4, %g15, -4
	mov	%g11, %g2
	addi	%g2, %g2, 16
	setL %g16, calc_diffuse_using_5points.3076
	st	%g16, %g11, 0
	st	%g23, %g11, -8
	st	%g4, %g11, -4
	mov	%g16, %g2
	addi	%g2, %g2, 8
	setL %g17, do_without_neighbors.3082
	st	%g17, %g16, 0
	st	%g15, %g16, -4
	mov	%g15, %g2
	addi	%g2, %g2, 8
	setL %g17, neighbors_exist.3085
	st	%g17, %g15, 0
	ld	%g17, %g1, 84
	st	%g17, %g15, -4
	mov	%g18, %g2
	addi	%g2, %g2, 16
	setL %g19, try_exploit_neighbors.3098
	st	%g19, %g18, 0
	st	%g16, %g18, -8
	st	%g11, %g18, -4
	mov	%g11, %g2
	addi	%g2, %g2, 8
	setL %g19, write_ppm_header.3105
	st	%g19, %g11, 0
	st	%g17, %g11, -4
	mov	%g19, %g2
	addi	%g2, %g2, 8
	setL %g20, write_rgb.3109
	st	%g20, %g19, 0
	st	%g23, %g19, -4
	mov	%g20, %g2
	addi	%g2, %g2, 16
	setL %g21, pretrace_diffuse_rays.3111
	st	%g21, %g20, 0
	st	%g6, %g20, -12
	st	%g13, %g20, -8
	st	%g4, %g20, -4
	mov	%g4, %g2
	addi	%g2, %g2, 40
	setL %g6, pretrace_pixels.3114
	st	%g6, %g4, 0
	st	%g5, %g4, -36
	st	%g10, %g4, -32
	st	%g29, %g4, -28
	st	%g9, %g4, -24
	ld	%g5, %g1, 92
	st	%g5, %g4, -20
	st	%g23, %g4, -16
	ld	%g6, %g1, 116
	st	%g6, %g4, -12
	st	%g20, %g4, -8
	ld	%g6, %g1, 88
	st	%g6, %g4, -4
	mov	%g9, %g2
	addi	%g2, %g2, 32
	setL %g10, pretrace_line.3121
	st	%g10, %g9, 0
	st	%g7, %g9, -24
	st	%g8, %g9, -20
	st	%g5, %g9, -16
	st	%g4, %g9, -12
	st	%g17, %g9, -8
	st	%g6, %g9, -4
	mov	%g4, %g2
	addi	%g2, %g2, 32
	setL %g7, scan_pixel.3125
	st	%g7, %g4, 0
	st	%g19, %g4, -24
	st	%g18, %g4, -20
	st	%g23, %g4, -16
	st	%g15, %g4, -12
	st	%g17, %g4, -8
	st	%g16, %g4, -4
	mov	%g7, %g2
	addi	%g2, %g2, 16
	setL %g8, scan_line.3131
	st	%g8, %g7, 0
	st	%g4, %g7, -12
	st	%g9, %g7, -8
	st	%g17, %g7, -4
	mov	%g4, %g2
	addi	%g2, %g2, 8
	setL %g8, create_pixelline.3144
	st	%g8, %g4, 0
	st	%g17, %g4, -4
	mov	%g8, %g2
	addi	%g2, %g2, 16
	setL %g10, tan.3146
	st	%g10, %g8, 0
	ld	%g10, %g1, 4
	st	%g10, %g8, -8
	ld	%g10, %g1, 0
	st	%g10, %g8, -4
	mov	%g10, %g2
	addi	%g2, %g2, 8
	setL %g15, adjust_position.3148
	st	%g15, %g10, 0
	st	%g8, %g10, -4
	mov	%g8, %g2
	addi	%g2, %g2, 16
	setL %g15, calc_dirvec.3151
	st	%g15, %g8, 0
	st	%g13, %g8, -8
	st	%g10, %g8, -4
	mov	%g10, %g2
	addi	%g2, %g2, 8
	setL %g15, calc_dirvecs.3159
	st	%g15, %g10, 0
	st	%g8, %g10, -4
	mov	%g8, %g2
	addi	%g2, %g2, 8
	setL %g15, calc_dirvec_rows.3164
	st	%g15, %g8, 0
	st	%g10, %g8, -4
	mov	%g10, %g2
	addi	%g2, %g2, 8
	setL %g15, create_dirvec.3168
	st	%g15, %g10, 0
	ld	%g15, %g1, 8
	st	%g15, %g10, -4
	mov	%g16, %g2
	addi	%g2, %g2, 8
	setL %g18, create_dirvec_elements.3170
	st	%g18, %g16, 0
	st	%g10, %g16, -4
	mov	%g18, %g2
	addi	%g2, %g2, 16
	setL %g19, create_dirvecs.3173
	st	%g19, %g18, 0
	st	%g13, %g18, -12
	st	%g16, %g18, -8
	st	%g10, %g18, -4
	mov	%g16, %g2
	addi	%g2, %g2, 8
	setL %g19, init_dirvec_constants.3175
	st	%g19, %g16, 0
	ld	%g19, %g1, 152
	st	%g19, %g16, -4
	mov	%g20, %g2
	addi	%g2, %g2, 16
	setL %g21, init_vecset_constants.3178
	st	%g21, %g20, 0
	st	%g16, %g20, -8
	st	%g13, %g20, -4
	mov	%g13, %g2
	addi	%g2, %g2, 16
	setL %g16, init_dirvecs.3180
	st	%g16, %g13, 0
	st	%g20, %g13, -12
	st	%g18, %g13, -8
	st	%g8, %g13, -4
	mov	%g8, %g2
	addi	%g2, %g2, 16
	setL %g16, add_reflection.3182
	st	%g16, %g8, 0
	st	%g19, %g8, -12
	ld	%g16, %g1, 144
	st	%g16, %g8, -8
	st	%g10, %g8, -4
	mov	%g10, %g2
	addi	%g2, %g2, 16
	setL %g16, setup_rect_reflection.3189
	st	%g16, %g10, 0
	st	%g3, %g10, -12
	st	%g12, %g10, -8
	st	%g8, %g10, -4
	mov	%g16, %g2
	addi	%g2, %g2, 16
	setL %g18, setup_surface_reflection.3192
	st	%g18, %g16, 0
	st	%g3, %g16, -12
	st	%g12, %g16, -8
	st	%g8, %g16, -4
	mov	%g3, %g2
	addi	%g2, %g2, 16
	setL %g8, setup_reflections.3195
	st	%g8, %g3, 0
	st	%g16, %g3, -12
	st	%g10, %g3, -8
	st	%g14, %g3, -4
	mov	%g29, %g2
	addi	%g2, %g2, 64
	setL %g8, rt.3197
	st	%g8, %g29, 0
	st	%g11, %g29, -56
	st	%g3, %g29, -52
	st	%g19, %g29, -48
	st	%g5, %g29, -44
	st	%g7, %g29, -40
	ld	%g3, %g1, 148
	st	%g3, %g29, -36
	st	%g9, %g29, -32
	st	%g15, %g29, -28
	ld	%g3, %g1, 136
	st	%g3, %g29, -24
	st	%g12, %g29, -20
	st	%g13, %g29, -16
	st	%g17, %g29, -12
	st	%g6, %g29, -8
	st	%g4, %g29, -4
	mvhi	%g3, 0
	mvlo	%g3, 128
	mvhi	%g4, 0
	mvlo	%g4, 128
	st	%g31, %g1, 156
	ld	%g28, %g29, 0
	subi	%g1, %g1, 160
	callR	%g28
	addi	%g1, %g1, 160
	ld	%g31, %g1, 156
	mvhi	%g0, 0
	mvlo	%g0, 0
	halt
