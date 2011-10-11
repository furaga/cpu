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
l.7640:	! 6.283185
	.long	0x40c90fda
l.7638:	! 3.141593
	.long	0x40490fda
l.7633:	! 128.000000
	.long	0x43000000
l.7568:	! 0.900000
	.long	0x3f66665e
l.7566:	! 0.200000
	.long	0x3e4cccc4
l.7387:	! 150.000000
	.long	0x43160000
l.7383:	! -150.000000
	.long	0xc3160000
l.7354:	! 0.100000
	.long	0x3dccccc4
l.7348:	! -2.000000
	.long	0xc0000000
l.7344:	! 0.003906
	.long	0x3b800000
l.7298:	! 20.000000
	.long	0x41a00000
l.7296:	! 0.050000
	.long	0x3d4cccc4
l.7287:	! 0.250000
	.long	0x3e800000
l.7277:	! 10.000000
	.long	0x41200000
l.7270:	! 0.300000
	.long	0x3e999999
l.7268:	! 255.000000
	.long	0x437f0000
l.7263:	! 0.150000
	.long	0x3e199999
l.7255:	! 3.141593
	.long	0x40490fda
l.7253:	! 30.000000
	.long	0x41f00000
l.7251:	! 15.000000
	.long	0x41700000
l.7249:	! 0.000100
	.long	0x38d1b70f
l.7175:	! 100000000.000000
	.long	0x4cbebc20
l.7167:	! 1000000000.000000
	.long	0x4e6e6b28
l.7128:	! -0.100000
	.long	0xbdccccc4
l.7102:	! 0.010000
	.long	0x3c23d70a
l.7100:	! -0.200000
	.long	0xbe4cccc4
l.6720:	! -200.000000
	.long	0xc3480000
l.6717:	! 200.000000
	.long	0x43480000
l.6712:	! 0.017453
	.long	0x3c8efa2d
l.6516:	! 1.570796
	.long	0x3fc90fda
l.6505:	! 9.000000
	.long	0x41100000
l.6501:	! 2.500000
	.long	0x40200000
l.6499:	! -1.570796
	.long	0xbfc90fda
l.6497:	! 1.570796
	.long	0x3fc90fda
l.6493:	! 11.000000
	.long	0x41300000
l.6489:	! -1.000000
	.long	0xbf800000
l.6484:	! 1.000000
	.long	0x3f800000
l.6482:	! 0.500000
	.long	0x3f000000
l.6480:	! 2.000000
	.long	0x40000000
l.6475:	! 0.000000
	.long	0x0

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

fless.2634:
	fjlt	%f0, %f1, fjge_else.9822
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.9822:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fispos.2637:
	setL %g3, l.6475
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.9823
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.9823:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fisneg.2639:
	setL %g3, l.6475
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.9824
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.9824:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fiszero.2641:
	setL %g3, l.6475
	fld	%f1, %g3, 0
	fjeq	%f0, %f1, fjne_else.9825
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjne_else.9825:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fabs.2646:
	setL %g3, l.6475
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.9826
	return
fjge_else.9826:
	fneg	%f0, %f0
	return
fneg.2648:
	fneg	%f0, %f0
	return
fhalf.2650:
	setL %g3, l.6480
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	return
fsqr.2652:
	fmul	%f0, %f0, %f0
	return
atan_sub.6433:
	setL %g3, l.6482
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.9827
	setL %g3, l.6484
	fld	%f3, %g3, 0
	fsub	%f3, %f0, %f3
	fmul	%f4, %f0, %f0
	fmul	%f4, %f4, %f1
	setL %g3, l.6480
	fld	%f5, %g3, 0
	fmul	%f0, %f5, %f0
	setL %g3, l.6484
	fld	%f5, %g3, 0
	fadd	%f0, %f0, %f5
	fadd	%f0, %f0, %f2
	fdiv	%f2, %f4, %f0
	fmov	%f0, %f3
	jmp	atan_sub.6433
fjge_else.9827:
	fmov	%f0, %f2
	return
atan.2657:
	setL %g3, l.6484
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.9828
	setL %g3, l.6489
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.9830
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	fjge_cont.9831
fjge_else.9830:
	mvhi	%g3, 65535
	mvlo	%g3, -1
fjge_cont.9831:
	jmp	fjge_cont.9829
fjge_else.9828:
	mvhi	%g3, 0
	mvlo	%g3, 1
fjge_cont.9829:
	st	%g3, %g1, 0
	fst	%f0, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fabs.2646
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	setL %g3, l.6484
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.9832
	fld	%f0, %g1, 4
	jmp	fjge_cont.9833
fjge_else.9832:
	setL %g3, l.6484
	fld	%f0, %g3, 0
	fld	%f1, %g1, 4
	fdiv	%f0, %f0, %f1
fjge_cont.9833:
	setL %g3, l.6493
	fld	%f1, %g3, 0
	fmul	%f2, %f0, %f0
	setL %g3, l.6475
	fld	%f3, %g3, 0
	fst	%f0, %g1, 8
	fmov	%f0, %f1
	fmov	%f1, %f2
	fmov	%f2, %f3
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	atan_sub.6433
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	setL %g3, l.6484
	fld	%f1, %g3, 0
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 8
	fdiv	%f0, %f1, %f0
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 0
	jlt	%g3, %g4, jle_else.9834
	mvhi	%g3, 0
	mvlo	%g3, 0
	jlt	%g4, %g3, jle_else.9835
	return
jle_else.9835:
	setL %g3, l.6499
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	return
jle_else.9834:
	setL %g3, l.6497
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	return
tan_sub.6416:
	setL %g3, l.6501
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.9836
	setL %g3, l.6480
	fld	%f3, %g3, 0
	fsub	%f3, %f0, %f3
	fsub	%f0, %f0, %f2
	fdiv	%f2, %f1, %f0
	fmov	%f0, %f3
	jmp	tan_sub.6416
fjge_else.9836:
	fmov	%f0, %f2
	return
tan.6391:
	setL %g3, l.6484
	fld	%f1, %g3, 0
	setL %g3, l.6505
	fld	%f2, %g3, 0
	fmul	%f3, %f0, %f0
	setL %g3, l.6475
	fld	%f4, %g3, 0
	fst	%f0, %g1, 0
	fst	%f1, %g1, 4
	fmov	%f1, %f3
	fmov	%f0, %f2
	fmov	%f2, %f4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	tan_sub.6416
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f1, %g1, 4
	fsub	%f0, %f1, %f0
	fld	%f1, %g1, 0
	fdiv	%f0, %f1, %f0
	return
tmp.6395:
	fld	%f1, %g29, -8
	fjlt	%f1, %f0, fjge_else.9837
	setL %g3, l.6475
	fld	%f2, %g3, 0
	fjlt	%f0, %f2, fjge_else.9838
	return
fjge_else.9838:
	fadd	%f0, %f0, %f1
	ld	%g28, %g29, 0
	b	%g28
fjge_else.9837:
	fsub	%f0, %f0, %f1
	ld	%g28, %g29, 0
	b	%g28
sin.2659:
	fld	%f1, %g29, -24
	fld	%f2, %g29, -16
	fld	%f3, %g29, -8
	setL %g3, l.6475
	fld	%f4, %g3, 0
	fjlt	%f4, %f0, fjge_else.9839
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	fjge_cont.9840
fjge_else.9839:
	mvhi	%g3, 0
	mvlo	%g3, 1
fjge_cont.9840:
	fst	%f1, %g1, 0
	st	%g3, %g1, 4
	fst	%f3, %g1, 8
	fst	%f2, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fabs.2646
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g29, %g2
	addi	%g2, %g2, 16
	setL %g3, tmp.6395
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
	fjlt	%f1, %f0, fjge_else.9841
	ld	%g3, %g1, 4
	jmp	fjge_cont.9842
fjge_else.9841:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 4
	jne	%g4, %g3, jeq_else.9843
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.9844
jeq_else.9843:
	mvhi	%g3, 0
	mvlo	%g3, 0
jeq_cont.9844:
fjge_cont.9842:
	fjlt	%f1, %f0, fjge_else.9845
	jmp	fjge_cont.9846
fjge_else.9845:
	fld	%f2, %g1, 12
	fsub	%f0, %f2, %f0
fjge_cont.9846:
	fld	%f2, %g1, 0
	fjlt	%f2, %f0, fjge_else.9847
	jmp	fjge_cont.9848
fjge_else.9847:
	fsub	%f0, %f1, %f0
fjge_cont.9848:
	setL %g4, l.6482
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	st	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	tan.6391
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	setL %g3, l.6480
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	setL %g3, l.6484
	fld	%f2, %g3, 0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f2, %f0
	fdiv	%f0, %f1, %f0
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 16
	jne	%g4, %g3, jeq_else.9849
	jmp	fneg.2648
jeq_else.9849:
	return
cos.2661:
	ld	%g29, %g29, -4
	setL %g3, l.6516
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	ld	%g28, %g29, 0
	b	%g28
mul10.2663:
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	return
read_token.6343:
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
	jlt	%g4, %g3, jle_else.9850
	mvhi	%g3, 0
	mvlo	%g3, 57
	jlt	%g3, %g4, jle_else.9852
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jle_cont.9853
jle_else.9852:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.9853:
	jmp	jle_cont.9851
jle_else.9850:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.9851:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.9854
	ld	%g3, %g1, 16
	ld	%g5, %g3, 0
	mvhi	%g6, 0
	mvlo	%g6, 0
	jne	%g5, %g6, jeq_else.9855
	mvhi	%g5, 0
	mvlo	%g5, 45
	ld	%g6, %g1, 12
	jne	%g6, %g5, jeq_else.9857
	mvhi	%g5, 65535
	mvlo	%g5, -1
	st	%g5, %g3, 0
	jmp	jeq_cont.9858
jeq_else.9857:
	mvhi	%g5, 0
	mvlo	%g5, 1
	st	%g5, %g3, 0
jeq_cont.9858:
	jmp	jeq_cont.9856
jeq_else.9855:
jeq_cont.9856:
	ld	%g3, %g1, 8
	ld	%g5, %g3, 0
	st	%g4, %g1, 20
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	mul10.2663
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
jeq_else.9854:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g5, %g1, 0
	jne	%g5, %g3, jeq_else.9859
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9859:
	ld	%g3, %g1, 16
	ld	%g3, %g3, 0
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.9860
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	return
jeq_else.9860:
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	muli	%g3, %g3, -1
	return
read_int.2665:
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
	setL %g4, read_token.6343
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
read_token1.6257:
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
	jlt	%g4, %g3, jle_else.9861
	mvhi	%g3, 0
	mvlo	%g3, 57
	jlt	%g3, %g4, jle_else.9863
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jle_cont.9864
jle_else.9863:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.9864:
	jmp	jle_cont.9862
jle_else.9861:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.9862:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.9865
	ld	%g3, %g1, 16
	ld	%g5, %g3, 0
	mvhi	%g6, 0
	mvlo	%g6, 0
	jne	%g5, %g6, jeq_else.9866
	mvhi	%g5, 0
	mvlo	%g5, 45
	ld	%g6, %g1, 12
	jne	%g6, %g5, jeq_else.9868
	mvhi	%g5, 65535
	mvlo	%g5, -1
	st	%g5, %g3, 0
	jmp	jeq_cont.9869
jeq_else.9868:
	mvhi	%g5, 0
	mvlo	%g5, 1
	st	%g5, %g3, 0
jeq_cont.9869:
	jmp	jeq_cont.9867
jeq_else.9866:
jeq_cont.9867:
	ld	%g3, %g1, 8
	ld	%g5, %g3, 0
	st	%g4, %g1, 20
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	mul10.2663
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
jeq_else.9865:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g5, %g1, 0
	jne	%g5, %g3, jeq_else.9870
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9870:
	mov	%g3, %g4
	return
read_token2.6260:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	st	%g3, %g1, 0
	st	%g29, %g1, 4
	st	%g5, %g1, 8
	st	%g4, %g1, 12
	input	%g3
	mvhi	%g4, 0
	mvlo	%g4, 48
	jlt	%g3, %g4, jle_else.9871
	mvhi	%g4, 0
	mvlo	%g4, 57
	jlt	%g4, %g3, jle_else.9873
	mvhi	%g4, 0
	mvlo	%g4, 0
	jmp	jle_cont.9874
jle_else.9873:
	mvhi	%g4, 0
	mvlo	%g4, 1
jle_cont.9874:
	jmp	jle_cont.9872
jle_else.9871:
	mvhi	%g4, 0
	mvlo	%g4, 1
jle_cont.9872:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g4, %g5, jeq_else.9875
	ld	%g4, %g1, 12
	ld	%g5, %g4, 0
	st	%g3, %g1, 16
	mov	%g3, %g5
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	mul10.2663
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
	call	mul10.2663
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	st	%g3, %g4, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9875:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 0
	jne	%g4, %g3, jeq_else.9876
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9876:
	return
read_float.2667:
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
	setL %g4, read_token1.6257
	st	%g4, %g29, 0
	st	%g3, %g29, -8
	ld	%g4, %g1, 0
	st	%g4, %g29, -4
	mov	%g5, %g2
	addi	%g2, %g2, 16
	setL %g6, read_token2.6260
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
	jne	%g3, %g4, jeq_else.9878
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
	jmp	jeq_cont.9879
jeq_else.9878:
	ld	%g3, %g1, 0
	ld	%g3, %g3, 0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
jeq_cont.9879:
	ld	%g3, %g1, 12
	ld	%g3, %g3, 0
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.9880
	return
jeq_else.9880:
	fneg	%f0, %f0
	return
xor.2699:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.9881
	mov	%g3, %g4
	return
jeq_else.9881:
	mvhi	%g3, 0
	mvlo	%g3, 0
	jne	%g4, %g3, jeq_else.9882
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.9882:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
sgn.2702:
	fst	%f0, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	fiszero.2641
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9883
	fld	%f0, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	fispos.2637
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9884
	setL %g3, l.6489
	fld	%f0, %g3, 0
	return
jeq_else.9884:
	setL %g3, l.6484
	fld	%f0, %g3, 0
	return
jeq_else.9883:
	setL %g3, l.6475
	fld	%f0, %g3, 0
	return
fneg_cond.2704:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9885
	jmp	fneg.2648
jeq_else.9885:
	return
add_mod5.2707:
	add	%g3, %g3, %g4
	mvhi	%g4, 0
	mvlo	%g4, 5
	jlt	%g3, %g4, jle_else.9886
	subi	%g3, %g3, 5
	return
jle_else.9886:
	return
vecset.2710:
	fst	%f0, %g3, 0
	fst	%f1, %g3, -4
	fst	%f2, %g3, -8
	return
vecfill.2715:
	fst	%f0, %g3, 0
	fst	%f0, %g3, -4
	fst	%f0, %g3, -8
	return
vecbzero.2718:
	setL %g4, l.6475
	fld	%f0, %g4, 0
	jmp	vecfill.2715
veccpy.2720:
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	fld	%f0, %g4, -4
	fst	%f0, %g3, -4
	fld	%f0, %g4, -8
	fst	%f0, %g3, -8
	return
vecunit_sgn.2728:
	fld	%f0, %g3, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fsqr.2652
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	fld	%f1, %g3, -4
	fst	%f0, %g1, 8
	fmov	%f0, %f1
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fsqr.2652
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
	call	fsqr.2652
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 12
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_sqrt
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fiszero.2641
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9890
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 0
	jne	%g4, %g3, jeq_else.9892
	setL %g3, l.6484
	fld	%f0, %g3, 0
	fld	%f1, %g1, 16
	fdiv	%f0, %f0, %f1
	jmp	jeq_cont.9893
jeq_else.9892:
	setL %g3, l.6489
	fld	%f0, %g3, 0
	fld	%f1, %g1, 16
	fdiv	%f0, %f0, %f1
jeq_cont.9893:
	jmp	jeq_cont.9891
jeq_else.9890:
	setL %g3, l.6484
	fld	%f0, %g3, 0
jeq_cont.9891:
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
veciprod.2731:
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
veciprod2.2734:
	fld	%f3, %g3, 0
	fmul	%f0, %f3, %f0
	fld	%f3, %g3, -4
	fmul	%f1, %f3, %f1
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	return
vecaccum.2739:
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
vecadd.2743:
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
vecscale.2749:
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
vecaccumv.2752:
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
o_texturetype.2756:
	ld	%g3, %g3, 0
	return
o_form.2758:
	ld	%g3, %g3, -4
	return
o_reflectiontype.2760:
	ld	%g3, %g3, -8
	return
o_isinvert.2762:
	ld	%g3, %g3, -24
	return
o_isrot.2764:
	ld	%g3, %g3, -12
	return
o_param_a.2766:
	ld	%g3, %g3, -16
	fld	%f0, %g3, 0
	return
o_param_b.2768:
	ld	%g3, %g3, -16
	fld	%f0, %g3, -4
	return
o_param_c.2770:
	ld	%g3, %g3, -16
	fld	%f0, %g3, -8
	return
o_param_abc.2772:
	ld	%g3, %g3, -16
	return
o_param_x.2774:
	ld	%g3, %g3, -20
	fld	%f0, %g3, 0
	return
o_param_y.2776:
	ld	%g3, %g3, -20
	fld	%f0, %g3, -4
	return
o_param_z.2778:
	ld	%g3, %g3, -20
	fld	%f0, %g3, -8
	return
o_diffuse.2780:
	ld	%g3, %g3, -28
	fld	%f0, %g3, 0
	return
o_hilight.2782:
	ld	%g3, %g3, -28
	fld	%f0, %g3, -4
	return
o_color_red.2784:
	ld	%g3, %g3, -32
	fld	%f0, %g3, 0
	return
o_color_green.2786:
	ld	%g3, %g3, -32
	fld	%f0, %g3, -4
	return
o_color_blue.2788:
	ld	%g3, %g3, -32
	fld	%f0, %g3, -8
	return
o_param_r1.2790:
	ld	%g3, %g3, -36
	fld	%f0, %g3, 0
	return
o_param_r2.2792:
	ld	%g3, %g3, -36
	fld	%f0, %g3, -4
	return
o_param_r3.2794:
	ld	%g3, %g3, -36
	fld	%f0, %g3, -8
	return
o_param_ctbl.2796:
	ld	%g3, %g3, -40
	return
p_rgb.2798:
	ld	%g3, %g3, 0
	return
p_intersection_points.2800:
	ld	%g3, %g3, -4
	return
p_surface_ids.2802:
	ld	%g3, %g3, -8
	return
p_calc_diffuse.2804:
	ld	%g3, %g3, -12
	return
p_energy.2806:
	ld	%g3, %g3, -16
	return
p_received_ray_20percent.2808:
	ld	%g3, %g3, -20
	return
p_group_id.2810:
	ld	%g3, %g3, -24
	ld	%g3, %g3, 0
	return
p_set_group_id.2812:
	ld	%g3, %g3, -24
	st	%g4, %g3, 0
	return
p_nvectors.2815:
	ld	%g3, %g3, -28
	return
d_vec.2817:
	ld	%g3, %g3, 0
	return
d_const.2819:
	ld	%g3, %g3, -4
	return
r_surface_id.2821:
	ld	%g3, %g3, 0
	return
r_dvec.2823:
	ld	%g3, %g3, -4
	return
r_bright.2825:
	fld	%f0, %g3, -8
	return
rad.2827:
	setL %g3, l.6712
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	return
read_screen_settings.2829:
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
	call	read_float.2667
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 24
	fst	%f0, %g3, 0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	read_float.2667
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 24
	fst	%f0, %g3, -4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	read_float.2667
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 24
	fst	%f0, %g3, -8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	read_float.2667
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	rad.2827
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
	call	read_float.2667
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	rad.2827
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
	setL %g3, l.6717
	fld	%f3, %g3, 0
	fmul	%f2, %f2, %f3
	ld	%g3, %g1, 12
	fst	%f2, %g3, 0
	setL %g4, l.6720
	fld	%f2, %g4, 0
	fld	%f3, %g1, 36
	fmul	%f2, %f3, %f2
	fst	%f2, %g3, -4
	fld	%f2, %g1, 44
	fmul	%f4, %f1, %f2
	setL %g4, l.6717
	fld	%f5, %g4, 0
	fmul	%f4, %f4, %f5
	fst	%f4, %g3, -8
	ld	%g4, %g1, 8
	fst	%f2, %g4, 0
	setL %g5, l.6475
	fld	%f4, %g5, 0
	fst	%f4, %g4, -4
	fst	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2648
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 8
	fst	%f0, %g3, -8
	fld	%f0, %g1, 36
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2648
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 48
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 4
	fst	%f0, %g3, 0
	fld	%f0, %g1, 32
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2648
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 4
	fst	%f0, %g3, -4
	fld	%f0, %g1, 36
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2648
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
read_light.2831:
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
	call	read_int.2665
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	read_float.2667
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	rad.2827
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
	call	fneg.2648
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 8
	fst	%f0, %g3, -4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	read_float.2667
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	rad.2827
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
	call	read_float.2667
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	return
rotate_quadratic_matrix.2833:
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
	call	fneg.2648
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
	call	fsqr.2652
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fld	%f1, %g1, 80
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 52
	fst	%f0, %g1, 84
	fmov	%f0, %f2
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	fsqr.2652
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
	call	fsqr.2652
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
	call	fsqr.2652
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	fld	%f1, %g1, 80
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 44
	fst	%f0, %g1, 92
	fmov	%f0, %f2
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	fsqr.2652
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
	call	fsqr.2652
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
	call	fsqr.2652
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	fld	%f1, %g1, 80
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 36
	fst	%f0, %g1, 100
	fmov	%f0, %f2
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	fsqr.2652
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
	call	fsqr.2652
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	fld	%f1, %g1, 68
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 104
	fadd	%f0, %f2, %f0
	ld	%g3, %g1, 0
	fst	%f0, %g3, -8
	setL %g3, l.6480
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
	setL %g4, l.6480
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
	setL %g4, l.6480
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
read_nth_object.2836:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	st	%g4, %g1, 0
	st	%g5, %g1, 4
	st	%g3, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	read_int.2665
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 65535
	mvlo	%g4, -1
	jne	%g3, %g4, jeq_else.9903
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9903:
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	read_int.2665
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	read_int.2665
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	read_int.2665
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6475
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
	call	read_float.2667
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	fst	%f0, %g3, 0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	read_float.2667
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	fst	%f0, %g3, -4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	read_float.2667
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	fst	%f0, %g3, -8
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6475
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
	call	read_float.2667
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	fst	%f0, %g3, 0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	read_float.2667
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	fst	%f0, %g3, -4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	read_float.2667
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	fst	%f0, %g3, -8
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	read_float.2667
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fisneg.2639
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 2
	setL %g5, l.6475
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
	call	read_float.2667
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 40
	fst	%f0, %g3, 0
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	read_float.2667
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 40
	fst	%f0, %g3, -4
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6475
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
	call	read_float.2667
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 44
	fst	%f0, %g3, 0
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	read_float.2667
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 44
	fst	%f0, %g3, -4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	read_float.2667
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 44
	fst	%f0, %g3, -8
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6475
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
	jne	%g5, %g4, jeq_else.9904
	jmp	jeq_cont.9905
jeq_else.9904:
	st	%g3, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	read_float.2667
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	rad.2827
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 48
	fst	%f0, %g3, 0
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	read_float.2667
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	rad.2827
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 48
	fst	%f0, %g3, -4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	read_float.2667
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	rad.2827
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 48
	fst	%f0, %g3, -8
jeq_cont.9905:
	mvhi	%g4, 0
	mvlo	%g4, 2
	ld	%g5, %g1, 16
	jne	%g5, %g4, jeq_else.9906
	mvhi	%g4, 0
	mvlo	%g4, 1
	jmp	jeq_cont.9907
jeq_else.9906:
	ld	%g4, %g1, 36
jeq_cont.9907:
	mvhi	%g6, 0
	mvlo	%g6, 4
	setL %g7, l.6475
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
	sub	%g9, %g9, %g8
	st	%g4, %g9, 0
	mvhi	%g4, 0
	mvlo	%g4, 3
	jne	%g7, %g4, jeq_else.9908
	fld	%f0, %g5, 0
	fst	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fiszero.2641
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9910
	fld	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	sgn.2702
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 56
	fst	%f0, %g1, 60
	fmov	%f0, %f1
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fsqr.2652
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 60
	fdiv	%f0, %f1, %f0
	jmp	jeq_cont.9911
jeq_else.9910:
	setL %g3, l.6475
	fld	%f0, %g3, 0
jeq_cont.9911:
	ld	%g3, %g1, 28
	fst	%f0, %g3, 0
	fld	%f0, %g3, -4
	fst	%f0, %g1, 64
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fiszero.2641
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9912
	fld	%f0, %g1, 64
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	sgn.2702
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 64
	fst	%f0, %g1, 68
	fmov	%f0, %f1
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fsqr.2652
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 68
	fdiv	%f0, %f1, %f0
	jmp	jeq_cont.9913
jeq_else.9912:
	setL %g3, l.6475
	fld	%f0, %g3, 0
jeq_cont.9913:
	ld	%g3, %g1, 28
	fst	%f0, %g3, -4
	fld	%f0, %g3, -8
	fst	%f0, %g1, 72
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fiszero.2641
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9914
	fld	%f0, %g1, 72
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	sgn.2702
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 72
	fst	%f0, %g1, 76
	fmov	%f0, %f1
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	fsqr.2652
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fld	%f1, %g1, 76
	fdiv	%f0, %f1, %f0
	jmp	jeq_cont.9915
jeq_else.9914:
	setL %g3, l.6475
	fld	%f0, %g3, 0
jeq_cont.9915:
	ld	%g3, %g1, 28
	fst	%f0, %g3, -8
	jmp	jeq_cont.9909
jeq_else.9908:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g7, %g4, jeq_else.9916
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g7, %g1, 36
	jne	%g7, %g4, jeq_else.9918
	mvhi	%g4, 0
	mvlo	%g4, 1
	jmp	jeq_cont.9919
jeq_else.9918:
	mvhi	%g4, 0
	mvlo	%g4, 0
jeq_cont.9919:
	mov	%g3, %g5
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	vecunit_sgn.2728
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	jmp	jeq_cont.9917
jeq_else.9916:
jeq_cont.9917:
jeq_cont.9909:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 24
	jne	%g4, %g3, jeq_else.9920
	jmp	jeq_cont.9921
jeq_else.9920:
	ld	%g3, %g1, 28
	ld	%g4, %g1, 48
	ld	%g29, %g1, 0
	st	%g31, %g1, 84
	ld	%g28, %g29, 0
	subi	%g1, %g1, 88
	callR	%g28
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
jeq_cont.9921:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
read_object.2838:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 60
	jlt	%g3, %g6, jle_else.9922
	return
jle_else.9922:
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
	jne	%g3, %g4, jeq_else.9924
	ld	%g3, %g1, 4
	ld	%g4, %g1, 8
	st	%g4, %g3, 0
	return
jeq_else.9924:
	ld	%g3, %g1, 8
	addi	%g3, %g3, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
read_all_object.2840:
	ld	%g29, %g29, -4
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g28, %g29, 0
	b	%g28
read_net_item.2842:
	st	%g3, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	read_int.2665
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 65535
	mvlo	%g4, -1
	jne	%g3, %g4, jeq_else.9926
	ld	%g3, %g1, 0
	addi	%g3, %g3, 1
	mvhi	%g4, 65535
	mvlo	%g4, -1
	jmp	min_caml_create_array
jeq_else.9926:
	ld	%g4, %g1, 0
	addi	%g5, %g4, 1
	st	%g3, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	read_net_item.2842
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 0
	slli	%g4, %g4, 2
	ld	%g5, %g1, 4
	sub	%g3, %g3, %g4
	st	%g5, %g3, 0
	return
read_or_network.2844:
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g3, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	read_net_item.2842
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g4, %g3
	ld	%g3, %g4, 0
	mvhi	%g5, 65535
	mvlo	%g5, -1
	jne	%g3, %g5, jeq_else.9927
	ld	%g3, %g1, 0
	addi	%g3, %g3, 1
	jmp	min_caml_create_array
jeq_else.9927:
	ld	%g3, %g1, 0
	addi	%g5, %g3, 1
	st	%g4, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	read_or_network.2844
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 0
	slli	%g4, %g4, 2
	ld	%g5, %g1, 4
	sub	%g3, %g3, %g4
	st	%g5, %g3, 0
	return
read_and_network.2846:
	ld	%g4, %g29, -4
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g29, %g1, 0
	st	%g4, %g1, 4
	st	%g3, %g1, 8
	mov	%g3, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	read_net_item.2842
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g3, 0
	mvhi	%g5, 65535
	mvlo	%g5, -1
	jne	%g4, %g5, jeq_else.9928
	return
jeq_else.9928:
	ld	%g4, %g1, 8
	slli	%g5, %g4, 2
	ld	%g6, %g1, 4
	sub	%g6, %g6, %g5
	st	%g3, %g6, 0
	addi	%g3, %g4, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
read_parameter.2848:
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
	call	read_or_network.2844
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 0
	st	%g3, %g4, 0
	return
solver_rect_surface.2850:
	ld	%g8, %g29, -4
	slli	%g9, %g5, 2
	sub	%g4, %g4, %g9
	fld	%f3, %g4, 0
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
	call	fiszero.2641
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9931
	ld	%g3, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_abc.2772
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 32
	st	%g3, %g1, 36
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_isinvert.2762
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 28
	slli	%g5, %g4, 2
	ld	%g6, %g1, 24
	sub	%g6, %g6, %g5
	fld	%f0, %g6, 0
	st	%g3, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fisneg.2639
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mov	%g4, %g3
	ld	%g3, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	xor.2699
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 28
	slli	%g5, %g4, 2
	ld	%g6, %g1, 36
	sub	%g6, %g6, %g5
	fld	%f0, %g6, 0
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fneg_cond.2704
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 20
	fsub	%f0, %f0, %f1
	ld	%g3, %g1, 28
	slli	%g3, %g3, 2
	ld	%g4, %g1, 24
	sub	%g4, %g4, %g3
	fld	%f1, %g4, 0
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 16
	slli	%g5, %g3, 2
	sub	%g4, %g4, %g5
	fld	%f1, %g4, 0
	fmul	%f1, %f0, %f1
	fld	%f2, %g1, 12
	fadd	%f1, %f1, %f2
	fst	%f0, %g1, 44
	fmov	%f0, %f1
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fabs.2646
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 16
	slli	%g3, %g3, 2
	ld	%g4, %g1, 36
	sub	%g4, %g4, %g3
	fld	%f1, %g4, 0
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fless.2634
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9932
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9932:
	ld	%g3, %g1, 8
	slli	%g4, %g3, 2
	ld	%g5, %g1, 24
	sub	%g5, %g5, %g4
	fld	%f0, %g5, 0
	fld	%f1, %g1, 44
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 4
	fadd	%f0, %f0, %f2
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fabs.2646
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 8
	slli	%g3, %g3, 2
	ld	%g4, %g1, 36
	sub	%g4, %g4, %g3
	fld	%f1, %g4, 0
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fless.2634
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9933
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9933:
	ld	%g3, %g1, 0
	fld	%f0, %g1, 44
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.9931:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
solver_rect.2859:
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
	jne	%g3, %g4, jeq_else.9934
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
	jne	%g3, %g4, jeq_else.9935
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
	jne	%g3, %g4, jeq_else.9936
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9936:
	mvhi	%g3, 0
	mvlo	%g3, 3
	return
jeq_else.9935:
	mvhi	%g3, 0
	mvlo	%g3, 2
	return
jeq_else.9934:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
solver_surface.2865:
	ld	%g5, %g29, -4
	st	%g5, %g1, 0
	fst	%f2, %g1, 4
	fst	%f1, %g1, 8
	fst	%f0, %g1, 12
	st	%g4, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_abc.2772
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g3
	ld	%g3, %g1, 16
	st	%g4, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	veciprod.2731
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fispos.2637
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9937
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9937:
	fld	%f0, %g1, 12
	fld	%f1, %g1, 8
	fld	%f2, %g1, 4
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	veciprod2.2734
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fneg.2648
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
quadratic.2871:
	fst	%f0, %g1, 0
	fst	%f2, %g1, 4
	fst	%f1, %g1, 8
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fsqr.2652
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_a.2766
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 16
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 8
	fst	%f0, %g1, 20
	fmov	%f0, %f1
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fsqr.2652
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 12
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_b.2768
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
	call	fsqr.2652
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 12
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_c.2770
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
	call	o_isrot.2764
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9938
	fld	%f0, %g1, 36
	return
jeq_else.9938:
	fld	%f0, %g1, 4
	fld	%f1, %g1, 8
	fmul	%f2, %f1, %f0
	ld	%g3, %g1, 12
	fst	%f2, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_r1.2790
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
	call	o_param_r2.2792
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
	call	o_param_r3.2794
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 56
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 52
	fadd	%f0, %f1, %f0
	return
bilinear.2876:
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
	call	o_param_a.2766
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
	call	o_param_b.2768
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
	call	o_param_c.2770
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
	call	o_isrot.2764
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9939
	fld	%f0, %g1, 48
	return
jeq_else.9939:
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
	call	o_param_r1.2790
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
	call	o_param_r2.2792
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
	call	o_param_r3.2794
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 68
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 64
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fhalf.2650
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 48
	fadd	%f0, %f1, %f0
	return
solver_second.2884:
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
	call	quadratic.2871
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fiszero.2641
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9940
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
	call	bilinear.2876
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
	call	quadratic.2871
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 16
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_form.2758
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 3
	jne	%g3, %g4, jeq_else.9941
	setL %g3, l.6484
	fld	%f0, %g3, 0
	fld	%f1, %g1, 32
	fsub	%f0, %f1, %f0
	jmp	jeq_cont.9942
jeq_else.9941:
	fld	%f0, %g1, 32
jeq_cont.9942:
	fld	%f1, %g1, 28
	fst	%f0, %g1, 36
	fmov	%f0, %f1
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fsqr.2652
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fld	%f2, %g1, 24
	fmul	%f1, %f2, %f1
	fsub	%f0, %f0, %f1
	fst	%f0, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fispos.2637
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9943
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9943:
	fld	%f0, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_sqrt
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 16
	fst	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_isinvert.2762
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9944
	fld	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2648
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	jmp	jeq_cont.9945
jeq_else.9944:
	fld	%f0, %g1, 44
jeq_cont.9945:
	fld	%f1, %g1, 28
	fsub	%f0, %f0, %f1
	fld	%f1, %g1, 24
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.9940:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
solver.2890:
	ld	%g6, %g29, -16
	ld	%g7, %g29, -12
	ld	%g8, %g29, -8
	ld	%g9, %g29, -4
	slli	%g3, %g3, 2
	sub	%g9, %g9, %g3
	ld	%g3, %g9, 0
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
	call	o_param_x.2774
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
	call	o_param_y.2776
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
	call	o_param_z.2778
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 40
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_form.2758
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.9946
	fld	%f0, %g1, 28
	fld	%f1, %g1, 36
	fld	%f2, %g1, 44
	ld	%g3, %g1, 16
	ld	%g4, %g1, 8
	ld	%g29, %g1, 12
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9946:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.9947
	fld	%f0, %g1, 28
	fld	%f1, %g1, 36
	fld	%f2, %g1, 44
	ld	%g3, %g1, 16
	ld	%g4, %g1, 8
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9947:
	fld	%f0, %g1, 28
	fld	%f1, %g1, 36
	fld	%f2, %g1, 44
	ld	%g3, %g1, 16
	ld	%g4, %g1, 8
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
solver_rect_fast.2894:
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
	call	fabs.2646
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_b.2768
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fless.2634
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9948
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9949
jeq_else.9948:
	ld	%g3, %g1, 24
	fld	%f0, %g3, -8
	fld	%f1, %g1, 20
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 16
	fadd	%f0, %f0, %f2
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fabs.2646
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	fst	%f0, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_c.2770
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fless.2634
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9950
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9951
jeq_else.9950:
	ld	%g3, %g1, 12
	fld	%f0, %g3, -4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fiszero.2641
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9952
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.9953
jeq_else.9952:
	mvhi	%g3, 0
	mvlo	%g3, 0
jeq_cont.9953:
jeq_cont.9951:
jeq_cont.9949:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9954
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
	call	fabs.2646
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 28
	fst	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_a.2766
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fless.2634
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9955
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9956
jeq_else.9955:
	ld	%g3, %g1, 24
	fld	%f0, %g3, -8
	fld	%f1, %g1, 40
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 16
	fadd	%f0, %f0, %f2
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fabs.2646
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 28
	fst	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_c.2770
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fless.2634
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9957
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9958
jeq_else.9957:
	ld	%g3, %g1, 12
	fld	%f0, %g3, -12
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fiszero.2641
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9959
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.9960
jeq_else.9959:
	mvhi	%g3, 0
	mvlo	%g3, 0
jeq_cont.9960:
jeq_cont.9958:
jeq_cont.9956:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9961
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
	call	fabs.2646
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 28
	fst	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_a.2766
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fless.2634
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9962
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9963
jeq_else.9962:
	ld	%g3, %g1, 24
	fld	%f0, %g3, -4
	fld	%f1, %g1, 52
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 8
	fadd	%f0, %f0, %f2
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fabs.2646
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 28
	fst	%f0, %g1, 60
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	o_param_b.2768
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 60
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fless.2634
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9964
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9965
jeq_else.9964:
	ld	%g3, %g1, 12
	fld	%f0, %g3, -20
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fiszero.2641
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9966
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.9967
jeq_else.9966:
	mvhi	%g3, 0
	mvlo	%g3, 0
jeq_cont.9967:
jeq_cont.9965:
jeq_cont.9963:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9968
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9968:
	ld	%g3, %g1, 0
	fld	%f0, %g1, 52
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 3
	return
jeq_else.9961:
	ld	%g3, %g1, 0
	fld	%f0, %g1, 40
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 2
	return
jeq_else.9954:
	ld	%g3, %g1, 0
	fld	%f0, %g1, 20
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
solver_surface_fast.2901:
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
	call	fisneg.2639
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9969
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9969:
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
solver_second_fast.2907:
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
	call	fiszero.2641
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9970
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
	call	quadratic.2871
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 8
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_form.2758
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 3
	jne	%g3, %g4, jeq_else.9971
	setL %g3, l.6484
	fld	%f0, %g3, 0
	fld	%f1, %g1, 32
	fsub	%f0, %f1, %f0
	jmp	jeq_cont.9972
jeq_else.9971:
	fld	%f0, %g1, 32
jeq_cont.9972:
	fld	%f1, %g1, 28
	fst	%f0, %g1, 36
	fmov	%f0, %f1
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fsqr.2652
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fld	%f2, %g1, 4
	fmul	%f1, %f2, %f1
	fsub	%f0, %f0, %f1
	fst	%f0, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fispos.2637
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9973
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9973:
	ld	%g3, %g1, 8
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_isinvert.2762
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9974
	fld	%f0, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_sqrt
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 28
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 24
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	jmp	jeq_cont.9975
jeq_else.9974:
	fld	%f0, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_sqrt
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 28
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 24
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
jeq_cont.9975:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.9970:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
solver_fast.2913:
	ld	%g6, %g29, -16
	ld	%g7, %g29, -12
	ld	%g8, %g29, -8
	ld	%g9, %g29, -4
	slli	%g10, %g3, 2
	sub	%g9, %g9, %g10
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
	call	o_param_x.2774
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
	call	o_param_y.2776
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
	call	o_param_z.2778
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 44
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	d_const.2819
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g4, %g1, 12
	slli	%g4, %g4, 2
	sub	%g3, %g3, %g4
	ld	%g3, %g3, 0
	ld	%g4, %g1, 20
	st	%g3, %g1, 52
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_form.2758
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.9976
	ld	%g3, %g1, 16
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	d_vec.2817
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
jeq_else.9976:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.9977
	fld	%f0, %g1, 32
	fld	%f1, %g1, 40
	fld	%f2, %g1, 48
	ld	%g3, %g1, 20
	ld	%g4, %g1, 52
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9977:
	fld	%f0, %g1, 32
	fld	%f1, %g1, 40
	fld	%f2, %g1, 48
	ld	%g3, %g1, 20
	ld	%g4, %g1, 52
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
solver_surface_fast2.2917:
	ld	%g3, %g29, -4
	fld	%f0, %g4, 0
	st	%g3, %g1, 0
	st	%g5, %g1, 4
	st	%g4, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fisneg.2639
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9978
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9978:
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
solver_second_fast2.2924:
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
	call	fiszero.2641
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9979
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
	call	fsqr.2652
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fld	%f2, %g1, 8
	fmul	%f1, %f2, %f1
	fsub	%f0, %f0, %f1
	fst	%f0, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fispos.2637
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9980
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9980:
	ld	%g3, %g1, 4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_isinvert.2762
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9981
	fld	%f0, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_sqrt
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 32
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 28
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	jmp	jeq_cont.9982
jeq_else.9981:
	fld	%f0, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_sqrt
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 32
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 28
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
jeq_cont.9982:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.9979:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
solver_fast2.2931:
	ld	%g5, %g29, -16
	ld	%g6, %g29, -12
	ld	%g7, %g29, -8
	ld	%g8, %g29, -4
	slli	%g9, %g3, 2
	sub	%g8, %g8, %g9
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
	call	o_param_ctbl.2796
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
	call	d_const.2819
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 16
	slli	%g4, %g4, 2
	sub	%g3, %g3, %g4
	ld	%g3, %g3, 0
	ld	%g4, %g1, 12
	st	%g3, %g1, 40
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_form.2758
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.9983
	ld	%g3, %g1, 20
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	d_vec.2817
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
jeq_else.9983:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.9984
	fld	%f0, %g1, 36
	fld	%f1, %g1, 32
	fld	%f2, %g1, 28
	ld	%g3, %g1, 12
	ld	%g4, %g1, 40
	ld	%g5, %g1, 24
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9984:
	fld	%f0, %g1, 36
	fld	%f1, %g1, 32
	fld	%f2, %g1, 28
	ld	%g3, %g1, 12
	ld	%g4, %g1, 40
	ld	%g5, %g1, 24
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
setup_rect_table.2934:
	mvhi	%g5, 0
	mvlo	%g5, 6
	setL %g6, l.6475
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
	call	fiszero.2641
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9985
	ld	%g3, %g1, 0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_isinvert.2762
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	fld	%f0, %g4, 0
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fisneg.2639
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g3
	ld	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	xor.2699
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 0
	st	%g3, %g1, 16
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_a.2766
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fneg_cond.2704
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 8
	fst	%f0, %g3, 0
	setL %g4, l.6484
	fld	%f0, %g4, 0
	ld	%g4, %g1, 4
	fld	%f1, %g4, 0
	fdiv	%f0, %f0, %f1
	fst	%f0, %g3, -4
	jmp	jeq_cont.9986
jeq_else.9985:
	setL %g3, l.6475
	fld	%f0, %g3, 0
	ld	%g3, %g1, 8
	fst	%f0, %g3, -4
jeq_cont.9986:
	ld	%g4, %g1, 4
	fld	%f0, %g4, -4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fiszero.2641
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9987
	ld	%g3, %g1, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_isinvert.2762
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 4
	fld	%f0, %g4, -4
	st	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fisneg.2639
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g3
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	xor.2699
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 0
	st	%g3, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_b.2768
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fneg_cond.2704
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 8
	fst	%f0, %g3, -8
	setL %g4, l.6484
	fld	%f0, %g4, 0
	ld	%g4, %g1, 4
	fld	%f1, %g4, -4
	fdiv	%f0, %f0, %f1
	fst	%f0, %g3, -12
	jmp	jeq_cont.9988
jeq_else.9987:
	setL %g3, l.6475
	fld	%f0, %g3, 0
	ld	%g3, %g1, 8
	fst	%f0, %g3, -12
jeq_cont.9988:
	ld	%g4, %g1, 4
	fld	%f0, %g4, -8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fiszero.2641
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9989
	ld	%g3, %g1, 0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_isinvert.2762
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 4
	fld	%f0, %g4, -8
	st	%g3, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fisneg.2639
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g4, %g3
	ld	%g3, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	xor.2699
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 0
	st	%g3, %g1, 32
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_c.2770
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg_cond.2704
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 8
	fst	%f0, %g3, -16
	setL %g4, l.6484
	fld	%f0, %g4, 0
	ld	%g4, %g1, 4
	fld	%f1, %g4, -8
	fdiv	%f0, %f0, %f1
	fst	%f0, %g3, -20
	jmp	jeq_cont.9990
jeq_else.9989:
	setL %g3, l.6475
	fld	%f0, %g3, 0
	ld	%g3, %g1, 8
	fst	%f0, %g3, -20
jeq_cont.9990:
	return
setup_surface_table.2937:
	mvhi	%g5, 0
	mvlo	%g5, 4
	setL %g6, l.6475
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
	call	o_param_a.2766
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
	call	o_param_b.2768
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
	call	o_param_c.2770
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 28
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 24
	fadd	%f0, %f1, %f0
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fispos.2637
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9991
	setL %g3, l.6475
	fld	%f0, %g3, 0
	ld	%g3, %g1, 8
	fst	%f0, %g3, 0
	jmp	jeq_cont.9992
jeq_else.9991:
	setL %g3, l.6489
	fld	%f0, %g3, 0
	fld	%f1, %g1, 32
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 8
	fst	%f0, %g3, 0
	ld	%g4, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_a.2766
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fdiv	%f0, %f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2648
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 8
	fst	%f0, %g3, -4
	ld	%g4, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_b.2768
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fdiv	%f0, %f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2648
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 8
	fst	%f0, %g3, -8
	ld	%g4, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_c.2770
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fdiv	%f0, %f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2648
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 8
	fst	%f0, %g3, -12
jeq_cont.9992:
	return
setup_second_table.2940:
	mvhi	%g5, 0
	mvlo	%g5, 5
	setL %g6, l.6475
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
	call	quadratic.2871
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
	call	o_param_a.2766
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 16
	fmul	%f0, %f1, %f0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fneg.2648
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
	call	o_param_b.2768
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fneg.2648
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
	call	o_param_c.2770
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fmul	%f0, %f1, %f0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2648
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
	call	o_isrot.2764
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9993
	ld	%g3, %g1, 8
	fld	%f0, %g1, 20
	fst	%f0, %g3, -4
	fld	%f0, %g1, 28
	fst	%f0, %g3, -8
	fld	%f0, %g1, 36
	fst	%f0, %g3, -12
	jmp	jeq_cont.9994
jeq_else.9993:
	ld	%g3, %g1, 4
	fld	%f0, %g3, -8
	ld	%g4, %g1, 0
	fst	%f0, %g1, 40
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_r2.2792
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
	call	o_param_r3.2794
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 48
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 44
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fhalf.2650
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
	call	o_param_r1.2790
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
	call	o_param_r3.2794
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 60
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 56
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fhalf.2650
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
	call	o_param_r1.2790
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
	call	o_param_r2.2792
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 72
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 68
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fhalf.2650
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 36
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g3, -12
jeq_cont.9994:
	fld	%f0, %g1, 12
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fiszero.2641
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9995
	setL %g3, l.6484
	fld	%f0, %g3, 0
	fld	%f1, %g1, 12
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 8
	fst	%f0, %g3, -16
	jmp	jeq_cont.9996
jeq_else.9995:
jeq_cont.9996:
	ld	%g3, %g1, 8
	return
iter_setup_dirvec_constants.2943:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g4, %g6, jle_else.9997
	slli	%g6, %g4, 2
	sub	%g5, %g5, %g6
	ld	%g5, %g5, 0
	st	%g29, %g1, 0
	st	%g4, %g1, 4
	st	%g5, %g1, 8
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	d_const.2819
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 12
	st	%g3, %g1, 16
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	d_vec.2817
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	st	%g3, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_form.2758
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.9998
	ld	%g3, %g1, 20
	ld	%g4, %g1, 8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	setup_rect_table.2934
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 4
	slli	%g5, %g4, 2
	ld	%g6, %g1, 16
	sub	%g6, %g6, %g5
	st	%g3, %g6, 0
	jmp	jeq_cont.9999
jeq_else.9998:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.10000
	ld	%g3, %g1, 20
	ld	%g4, %g1, 8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	setup_surface_table.2937
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 4
	slli	%g5, %g4, 2
	ld	%g6, %g1, 16
	sub	%g6, %g6, %g5
	st	%g3, %g6, 0
	jmp	jeq_cont.10001
jeq_else.10000:
	ld	%g3, %g1, 20
	ld	%g4, %g1, 8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	setup_second_table.2940
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 4
	slli	%g5, %g4, 2
	ld	%g6, %g1, 16
	sub	%g6, %g6, %g5
	st	%g3, %g6, 0
jeq_cont.10001:
jeq_cont.9999:
	subi	%g4, %g4, 1
	ld	%g3, %g1, 12
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.9997:
	return
setup_dirvec_constants.2946:
	ld	%g4, %g29, -8
	ld	%g29, %g29, -4
	ld	%g4, %g4, 0
	subi	%g4, %g4, 1
	ld	%g28, %g29, 0
	b	%g28
setup_startp_constants.2948:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g4, %g6, jle_else.10003
	slli	%g6, %g4, 2
	sub	%g5, %g5, %g6
	ld	%g5, %g5, 0
	st	%g29, %g1, 0
	st	%g4, %g1, 4
	st	%g3, %g1, 8
	st	%g5, %g1, 12
	mov	%g3, %g5
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_ctbl.2796
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 12
	st	%g3, %g1, 16
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_form.2758
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
	call	o_param_x.2774
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
	call	o_param_y.2776
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
	call	o_param_z.2778
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g3, -8
	mvhi	%g4, 0
	mvlo	%g4, 2
	ld	%g5, %g1, 20
	jne	%g5, %g4, jeq_else.10004
	ld	%g4, %g1, 12
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_abc.2772
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 16
	fld	%f0, %g4, 0
	fld	%f1, %g4, -4
	fld	%f2, %g4, -8
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	veciprod2.2734
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 16
	fst	%f0, %g3, -12
	jmp	jeq_cont.10005
jeq_else.10004:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jlt	%g4, %g5, jle_else.10006
	jmp	jle_cont.10007
jle_else.10006:
	fld	%f0, %g3, 0
	fld	%f1, %g3, -4
	fld	%f2, %g3, -8
	ld	%g4, %g1, 12
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	quadratic.2871
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g3, 0
	mvlo	%g3, 3
	ld	%g4, %g1, 20
	jne	%g4, %g3, jeq_else.10008
	setL %g3, l.6484
	fld	%f1, %g3, 0
	fsub	%f0, %f0, %f1
	jmp	jeq_cont.10009
jeq_else.10008:
jeq_cont.10009:
	ld	%g3, %g1, 16
	fst	%f0, %g3, -12
jle_cont.10007:
jeq_cont.10005:
	ld	%g3, %g1, 4
	subi	%g4, %g3, 1
	ld	%g3, %g1, 8
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10003:
	return
setup_startp.2951:
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
	call	veccpy.2720
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	subi	%g4, %g3, 1
	ld	%g3, %g1, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
is_rect_outside.2953:
	fst	%f2, %g1, 0
	fst	%f1, %g1, 4
	st	%g3, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fabs.2646
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 8
	fst	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_a.2766
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fless.2634
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10011
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10012
jeq_else.10011:
	fld	%f0, %g1, 4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fabs.2646
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 8
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_b.2768
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fless.2634
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10013
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10014
jeq_else.10013:
	fld	%f0, %g1, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fabs.2646
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 8
	fst	%f0, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_c.2770
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fless.2634
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
jeq_cont.10014:
jeq_cont.10012:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10015
	ld	%g3, %g1, 8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_isinvert.2762
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10016
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.10016:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10015:
	ld	%g3, %g1, 8
	jmp	o_isinvert.2762
is_plane_outside.2958:
	st	%g3, %g1, 0
	fst	%f2, %g1, 4
	fst	%f1, %g1, 8
	fst	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_abc.2772
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f0, %g1, 12
	fld	%f1, %g1, 8
	fld	%f2, %g1, 4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	veciprod2.2734
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 0
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_isinvert.2762
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f0, %g1, 16
	st	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fisneg.2639
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g3
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	xor.2699
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10017
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.10017:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
is_second_outside.2963:
	st	%g3, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	quadratic.2871
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g3, %g1, 0
	fst	%f0, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_form.2758
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 3
	jne	%g3, %g4, jeq_else.10018
	setL %g3, l.6484
	fld	%f0, %g3, 0
	fld	%f1, %g1, 4
	fsub	%f0, %f1, %f0
	jmp	jeq_cont.10019
jeq_else.10018:
	fld	%f0, %g1, 4
jeq_cont.10019:
	ld	%g3, %g1, 0
	fst	%f0, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_isinvert.2762
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f0, %g1, 8
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fisneg.2639
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g3
	ld	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	xor.2699
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10020
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.10020:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
is_outside.2968:
	fst	%f2, %g1, 0
	fst	%f1, %g1, 4
	st	%g3, %g1, 8
	fst	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_x.2774
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 12
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_y.2776
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 4
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_z.2778
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 0
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_form.2758
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.10021
	fld	%f0, %g1, 16
	fld	%f1, %g1, 20
	fld	%f2, %g1, 24
	ld	%g3, %g1, 8
	jmp	is_rect_outside.2953
jeq_else.10021:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.10022
	fld	%f0, %g1, 16
	fld	%f1, %g1, 20
	fld	%f2, %g1, 24
	ld	%g3, %g1, 8
	jmp	is_plane_outside.2958
jeq_else.10022:
	fld	%f0, %g1, 16
	fld	%f1, %g1, 20
	fld	%f2, %g1, 24
	ld	%g3, %g1, 8
	jmp	is_second_outside.2963
check_all_inside.2973:
	ld	%g5, %g29, -4
	slli	%g6, %g3, 2
	sub	%g4, %g4, %g6
	ld	%g6, %g4, 0
	mvhi	%g7, 65535
	mvlo	%g7, -1
	jne	%g6, %g7, jeq_else.10023
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.10023:
	slli	%g6, %g6, 2
	sub	%g5, %g5, %g6
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
	call	is_outside.2968
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10024
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	fld	%f0, %g1, 8
	fld	%f1, %g1, 4
	fld	%f2, %g1, 0
	ld	%g4, %g1, 12
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10024:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
shadow_check_and_group.2979:
	ld	%g5, %g29, -28
	ld	%g6, %g29, -24
	ld	%g7, %g29, -20
	ld	%g8, %g29, -16
	ld	%g9, %g29, -12
	ld	%g10, %g29, -8
	ld	%g11, %g29, -4
	slli	%g12, %g3, 2
	sub	%g4, %g4, %g12
	ld	%g12, %g4, 0
	mvhi	%g13, 65535
	mvlo	%g13, -1
	jne	%g12, %g13, jeq_else.10025
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10025:
	slli	%g12, %g3, 2
	sub	%g4, %g4, %g12
	ld	%g12, %g4, 0
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
	jne	%g3, %g4, jeq_else.10026
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10027
jeq_else.10026:
	setL %g3, l.7100
	fld	%f1, %g3, 0
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fless.2634
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
jeq_cont.10027:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10028
	ld	%g3, %g1, 28
	slli	%g3, %g3, 2
	ld	%g4, %g1, 24
	sub	%g4, %g4, %g3
	ld	%g3, %g4, 0
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_isinvert.2762
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10029
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10029:
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	ld	%g4, %g1, 12
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10028:
	setL %g3, l.7102
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
	jne	%g3, %g4, jeq_else.10030
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	ld	%g4, %g1, 12
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10030:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
shadow_check_one_or_group.2982:
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	slli	%g7, %g3, 2
	sub	%g4, %g4, %g7
	ld	%g7, %g4, 0
	mvhi	%g8, 65535
	mvlo	%g8, -1
	jne	%g7, %g8, jeq_else.10031
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10031:
	slli	%g7, %g7, 2
	sub	%g6, %g6, %g7
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
	jne	%g3, %g4, jeq_else.10032
	ld	%g3, %g1, 8
	addi	%g3, %g3, 1
	ld	%g4, %g1, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10032:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
shadow_check_one_or_matrix.2985:
	ld	%g5, %g29, -20
	ld	%g6, %g29, -16
	ld	%g7, %g29, -12
	ld	%g8, %g29, -8
	ld	%g9, %g29, -4
	slli	%g10, %g3, 2
	sub	%g4, %g4, %g10
	ld	%g10, %g4, 0
	ld	%g11, %g10, 0
	mvhi	%g12, 65535
	mvlo	%g12, -1
	jne	%g11, %g12, jeq_else.10033
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10033:
	mvhi	%g12, 0
	mvlo	%g12, 99
	st	%g10, %g1, 0
	st	%g7, %g1, 4
	st	%g4, %g1, 8
	st	%g29, %g1, 12
	st	%g3, %g1, 16
	jne	%g11, %g12, jeq_else.10034
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.10035
jeq_else.10034:
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
	jne	%g3, %g4, jeq_else.10036
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10037
jeq_else.10036:
	ld	%g3, %g1, 20
	fld	%f0, %g3, 0
	setL %g3, l.7128
	fld	%f1, %g3, 0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fless.2634
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10038
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10039
jeq_else.10038:
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
	jne	%g3, %g4, jeq_else.10040
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.10041
jeq_else.10040:
	mvhi	%g3, 0
	mvlo	%g3, 1
jeq_cont.10041:
jeq_cont.10039:
jeq_cont.10037:
jeq_cont.10035:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10042
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	ld	%g4, %g1, 8
	ld	%g29, %g1, 12
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10042:
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
	jne	%g3, %g4, jeq_else.10043
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	ld	%g4, %g1, 8
	ld	%g29, %g1, 12
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10043:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
solve_each_element.2988:
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
	sub	%g4, %g4, %g15
	ld	%g15, %g4, 0
	mvhi	%g16, 65535
	mvlo	%g16, -1
	jne	%g15, %g16, jeq_else.10044
	return
jeq_else.10044:
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
	jne	%g3, %g4, jeq_else.10046
	ld	%g3, %g1, 48
	slli	%g3, %g3, 2
	ld	%g4, %g1, 44
	sub	%g4, %g4, %g3
	ld	%g3, %g4, 0
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_isinvert.2762
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10047
	return
jeq_else.10047:
	ld	%g3, %g1, 40
	addi	%g3, %g3, 1
	ld	%g4, %g1, 32
	ld	%g5, %g1, 28
	ld	%g29, %g1, 36
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10046:
	ld	%g4, %g1, 24
	fld	%f1, %g4, 0
	setL %g4, l.6475
	fld	%f0, %g4, 0
	st	%g3, %g1, 52
	fst	%f1, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fless.2634
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10049
	jmp	jeq_cont.10050
jeq_else.10049:
	ld	%g3, %g1, 20
	fld	%f1, %g3, 0
	fld	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fless.2634
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10051
	jmp	jeq_cont.10052
jeq_else.10051:
	setL %g3, l.7102
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
	jne	%g3, %g4, jeq_else.10053
	jmp	jeq_cont.10054
jeq_else.10053:
	ld	%g3, %g1, 20
	fld	%f0, %g1, 72
	fst	%f0, %g3, 0
	fld	%f0, %g1, 68
	fld	%f1, %g1, 64
	fld	%f2, %g1, 60
	ld	%g3, %g1, 8
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	vecset.2710
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g3, %g1, 4
	ld	%g4, %g1, 48
	st	%g4, %g3, 0
	ld	%g3, %g1, 0
	ld	%g4, %g1, 52
	st	%g4, %g3, 0
jeq_cont.10054:
jeq_cont.10052:
jeq_cont.10050:
	ld	%g3, %g1, 40
	addi	%g3, %g3, 1
	ld	%g4, %g1, 32
	ld	%g5, %g1, 28
	ld	%g29, %g1, 36
	ld	%g28, %g29, 0
	b	%g28
solve_one_or_network.2992:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	slli	%g8, %g3, 2
	sub	%g4, %g4, %g8
	ld	%g8, %g4, 0
	mvhi	%g9, 65535
	mvlo	%g9, -1
	jne	%g8, %g9, jeq_else.10055
	return
jeq_else.10055:
	slli	%g8, %g8, 2
	sub	%g7, %g7, %g8
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
trace_or_matrix.2996:
	ld	%g6, %g29, -20
	ld	%g7, %g29, -16
	ld	%g8, %g29, -12
	ld	%g9, %g29, -8
	ld	%g10, %g29, -4
	slli	%g11, %g3, 2
	sub	%g4, %g4, %g11
	ld	%g11, %g4, 0
	ld	%g12, %g11, 0
	mvhi	%g13, 65535
	mvlo	%g13, -1
	jne	%g12, %g13, jeq_else.10057
	return
jeq_else.10057:
	mvhi	%g13, 0
	mvlo	%g13, 99
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g29, %g1, 8
	st	%g3, %g1, 12
	jne	%g12, %g13, jeq_else.10059
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
	jmp	jeq_cont.10060
jeq_else.10059:
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
	jne	%g3, %g4, jeq_else.10061
	jmp	jeq_cont.10062
jeq_else.10061:
	ld	%g3, %g1, 28
	fld	%f0, %g3, 0
	ld	%g3, %g1, 24
	fld	%f1, %g3, 0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fless.2634
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10063
	jmp	jeq_cont.10064
jeq_else.10063:
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
jeq_cont.10064:
jeq_cont.10062:
jeq_cont.10060:
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
judge_intersection.3000:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	setL %g7, l.7167
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
	setL %g3, l.7128
	fld	%f0, %g3, 0
	fst	%f1, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fless.2634
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10065
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10065:
	setL %g3, l.7175
	fld	%f1, %g3, 0
	fld	%f0, %g1, 4
	jmp	fless.2634
solve_each_element_fast.3002:
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
	call	d_vec.2817
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g4, %g1, 48
	slli	%g5, %g4, 2
	ld	%g6, %g1, 44
	sub	%g6, %g6, %g5
	ld	%g5, %g6, 0
	mvhi	%g7, 65535
	mvlo	%g7, -1
	jne	%g5, %g7, jeq_else.10066
	return
jeq_else.10066:
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
	jne	%g3, %g4, jeq_else.10068
	ld	%g3, %g1, 56
	slli	%g3, %g3, 2
	ld	%g4, %g1, 32
	sub	%g4, %g4, %g3
	ld	%g3, %g4, 0
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_isinvert.2762
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10069
	return
jeq_else.10069:
	ld	%g3, %g1, 48
	addi	%g3, %g3, 1
	ld	%g4, %g1, 44
	ld	%g5, %g1, 36
	ld	%g29, %g1, 28
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10068:
	ld	%g4, %g1, 24
	fld	%f1, %g4, 0
	setL %g4, l.6475
	fld	%f0, %g4, 0
	st	%g3, %g1, 60
	fst	%f1, %g1, 64
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fless.2634
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10071
	jmp	jeq_cont.10072
jeq_else.10071:
	ld	%g3, %g1, 20
	fld	%f1, %g3, 0
	fld	%f0, %g1, 64
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fless.2634
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10073
	jmp	jeq_cont.10074
jeq_else.10073:
	setL %g3, l.7102
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
	jne	%g3, %g4, jeq_else.10075
	jmp	jeq_cont.10076
jeq_else.10075:
	ld	%g3, %g1, 20
	fld	%f0, %g1, 80
	fst	%f0, %g3, 0
	fld	%f0, %g1, 76
	fld	%f1, %g1, 72
	fld	%f2, %g1, 68
	ld	%g3, %g1, 8
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	vecset.2710
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	ld	%g3, %g1, 4
	ld	%g4, %g1, 56
	st	%g4, %g3, 0
	ld	%g3, %g1, 0
	ld	%g4, %g1, 60
	st	%g4, %g3, 0
jeq_cont.10076:
jeq_cont.10074:
jeq_cont.10072:
	ld	%g3, %g1, 48
	addi	%g3, %g3, 1
	ld	%g4, %g1, 44
	ld	%g5, %g1, 36
	ld	%g29, %g1, 28
	ld	%g28, %g29, 0
	b	%g28
solve_one_or_network_fast.3006:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	slli	%g8, %g3, 2
	sub	%g4, %g4, %g8
	ld	%g8, %g4, 0
	mvhi	%g9, 65535
	mvlo	%g9, -1
	jne	%g8, %g9, jeq_else.10077
	return
jeq_else.10077:
	slli	%g8, %g8, 2
	sub	%g7, %g7, %g8
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
trace_or_matrix_fast.3010:
	ld	%g6, %g29, -16
	ld	%g7, %g29, -12
	ld	%g8, %g29, -8
	ld	%g9, %g29, -4
	slli	%g10, %g3, 2
	sub	%g4, %g4, %g10
	ld	%g10, %g4, 0
	ld	%g11, %g10, 0
	mvhi	%g12, 65535
	mvlo	%g12, -1
	jne	%g11, %g12, jeq_else.10079
	return
jeq_else.10079:
	mvhi	%g12, 0
	mvlo	%g12, 99
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g29, %g1, 8
	st	%g3, %g1, 12
	jne	%g11, %g12, jeq_else.10081
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
	jmp	jeq_cont.10082
jeq_else.10081:
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
	jne	%g3, %g4, jeq_else.10083
	jmp	jeq_cont.10084
jeq_else.10083:
	ld	%g3, %g1, 28
	fld	%f0, %g3, 0
	ld	%g3, %g1, 24
	fld	%f1, %g3, 0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fless.2634
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10085
	jmp	jeq_cont.10086
jeq_else.10085:
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
jeq_cont.10086:
jeq_cont.10084:
jeq_cont.10082:
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
judge_intersection_fast.3014:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	setL %g7, l.7167
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
	setL %g3, l.7128
	fld	%f0, %g3, 0
	fst	%f1, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fless.2634
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10087
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10087:
	setL %g3, l.7175
	fld	%f1, %g3, 0
	fld	%f0, %g1, 4
	jmp	fless.2634
get_nvector_rect.3016:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	ld	%g5, %g5, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	st	%g5, %g1, 8
	mov	%g3, %g4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	vecbzero.2718
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 8
	subi	%g4, %g3, 1
	subi	%g3, %g3, 1
	slli	%g3, %g3, 2
	ld	%g5, %g1, 4
	sub	%g5, %g5, %g3
	fld	%f0, %g5, 0
	st	%g4, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	sgn.2702
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fneg.2648
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	slli	%g3, %g3, 2
	ld	%g4, %g1, 0
	sub	%g4, %g4, %g3
	fst	%f0, %g4, 0
	return
get_nvector_plane.3018:
	ld	%g4, %g29, -4
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_param_a.2766
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fneg.2648
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	fst	%f0, %g3, 0
	ld	%g4, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_param_b.2768
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fneg.2648
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	fst	%f0, %g3, -4
	ld	%g4, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_param_c.2770
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fneg.2648
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	fst	%f0, %g3, -8
	return
get_nvector_second.3020:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	fld	%f0, %g5, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	st	%g5, %g1, 8
	fst	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_x.2774
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
	call	o_param_y.2776
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
	call	o_param_z.2778
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 28
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_a.2766
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 16
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_b.2768
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_c.2770
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 32
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_isrot.2764
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10090
	ld	%g3, %g1, 0
	fld	%f0, %g1, 36
	fst	%f0, %g3, 0
	fld	%f0, %g1, 40
	fst	%f0, %g3, -4
	fld	%f0, %g1, 44
	fst	%f0, %g3, -8
	jmp	jeq_cont.10091
jeq_else.10090:
	ld	%g3, %g1, 4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_r3.2794
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_r2.2792
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 32
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 48
	fadd	%f0, %f2, %f0
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fhalf.2650
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
	call	o_param_r3.2794
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 16
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 52
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_r1.2790
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 32
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 52
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fhalf.2650
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
	call	o_param_r2.2792
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 16
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_r1.2790
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 56
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fhalf.2650
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 44
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 0
	fst	%f0, %g3, -8
jeq_cont.10091:
	ld	%g4, %g1, 4
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_isinvert.2762
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g3
	ld	%g3, %g1, 0
	jmp	vecunit_sgn.2728
get_nvector.3022:
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
	call	o_form.2758
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.10092
	ld	%g3, %g1, 12
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10092:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.10093
	ld	%g3, %g1, 4
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10093:
	ld	%g3, %g1, 4
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
utexture.3025:
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
	call	o_texturetype.2756
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 16
	st	%g3, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_color_red.2784
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 12
	fst	%f0, %g3, 0
	ld	%g4, %g1, 16
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_color_green.2786
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 12
	fst	%f0, %g3, -4
	ld	%g4, %g1, 16
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_color_blue.2788
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 12
	fst	%f0, %g3, -8
	mvhi	%g4, 0
	mvlo	%g4, 1
	ld	%g5, %g1, 20
	jne	%g5, %g4, jeq_else.10094
	ld	%g4, %g1, 8
	fld	%f0, %g4, 0
	ld	%g5, %g1, 16
	fst	%f0, %g1, 24
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_x.2774
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fsub	%f0, %f1, %f0
	setL %g3, l.7296
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	fst	%f0, %g1, 28
	fmov	%f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_floor
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	setL %g3, l.7298
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 28
	fsub	%f0, %f1, %f0
	setL %g3, l.7277
	fld	%f1, %g3, 0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fless.2634
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
	call	o_param_z.2778
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fsub	%f0, %f1, %f0
	setL %g3, l.7296
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	fst	%f0, %g1, 40
	fmov	%f0, %f1
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_floor
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	setL %g3, l.7298
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 40
	fsub	%f0, %f1, %f0
	setL %g3, l.7277
	fld	%f1, %g3, 0
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fless.2634
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g5, %g1, 32
	jne	%g5, %g4, jeq_else.10095
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10097
	setL %g3, l.7268
	fld	%f0, %g3, 0
	jmp	jeq_cont.10098
jeq_else.10097:
	setL %g3, l.6475
	fld	%f0, %g3, 0
jeq_cont.10098:
	jmp	jeq_cont.10096
jeq_else.10095:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10099
	setL %g3, l.6475
	fld	%f0, %g3, 0
	jmp	jeq_cont.10100
jeq_else.10099:
	setL %g3, l.7268
	fld	%f0, %g3, 0
jeq_cont.10100:
jeq_cont.10096:
	ld	%g3, %g1, 12
	fst	%f0, %g3, -4
	return
jeq_else.10094:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g5, %g4, jeq_else.10102
	ld	%g4, %g1, 8
	fld	%f0, %g4, -4
	setL %g4, l.7287
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
	call	fsqr.2652
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	setL %g3, l.7268
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	ld	%g3, %g1, 12
	fst	%f1, %g3, 0
	setL %g4, l.7268
	fld	%f1, %g4, 0
	setL %g4, l.6484
	fld	%f2, %g4, 0
	fsub	%f0, %f2, %f0
	fmul	%f0, %f1, %f0
	fst	%f0, %g3, -4
	return
jeq_else.10102:
	mvhi	%g4, 0
	mvlo	%g4, 3
	jne	%g5, %g4, jeq_else.10104
	ld	%g4, %g1, 8
	fld	%f0, %g4, 0
	ld	%g5, %g1, 16
	fst	%f0, %g1, 44
	mov	%g3, %g5
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_x.2774
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
	call	o_param_z.2778
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 52
	fsub	%f0, %f1, %f0
	fld	%f1, %g1, 48
	fst	%f0, %g1, 56
	fmov	%f0, %f1
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fsqr.2652
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 56
	fst	%f0, %g1, 60
	fmov	%f0, %f1
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fsqr.2652
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 60
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	min_caml_sqrt
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	setL %g3, l.7277
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
	setL %g3, l.7255
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
	call	fsqr.2652
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	setL %g3, l.7268
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	ld	%g3, %g1, 12
	fst	%f1, %g3, -4
	setL %g4, l.6484
	fld	%f1, %g4, 0
	fsub	%f0, %f1, %f0
	setL %g4, l.7268
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fst	%f0, %g3, -8
	return
jeq_else.10104:
	mvhi	%g4, 0
	mvlo	%g4, 4
	jne	%g5, %g4, jeq_else.10106
	ld	%g4, %g1, 8
	fld	%f0, %g4, 0
	ld	%g5, %g1, 16
	fst	%f0, %g1, 68
	mov	%g3, %g5
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	o_param_x.2774
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 68
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g1, 72
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	o_param_a.2766
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	min_caml_sqrt
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
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
	call	o_param_z.2778
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fld	%f1, %g1, 80
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g1, 84
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	o_param_c.2770
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	min_caml_sqrt
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	fld	%f1, %g1, 84
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 76
	fst	%f0, %g1, 88
	fmov	%f0, %f1
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	fsqr.2652
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	fld	%f1, %g1, 88
	fst	%f0, %g1, 92
	fmov	%f0, %f1
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	fsqr.2652
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	fld	%f1, %g1, 92
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 76
	fst	%f0, %g1, 96
	fmov	%f0, %f1
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	fabs.2646
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	setL %g3, l.7249
	fld	%f1, %g3, 0
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	fless.2634
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10107
	fld	%f0, %g1, 76
	fld	%f1, %g1, 88
	fdiv	%f0, %f1, %f0
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	fabs.2646
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	atan.2657
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	setL %g3, l.7253
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.7255
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	jmp	jeq_cont.10108
jeq_else.10107:
	setL %g3, l.7251
	fld	%f0, %g3, 0
jeq_cont.10108:
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
	call	o_param_y.2776
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	fld	%f1, %g1, 108
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g1, 112
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	o_param_b.2768
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	min_caml_sqrt
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	fld	%f1, %g1, 112
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 96
	fst	%f0, %g1, 116
	fmov	%f0, %f1
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	fabs.2646
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	setL %g3, l.7249
	fld	%f1, %g3, 0
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	fless.2634
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10109
	fld	%f0, %g1, 96
	fld	%f1, %g1, 116
	fdiv	%f0, %f1, %f0
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	fabs.2646
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	atan.2657
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	setL %g3, l.7253
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.7255
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	jmp	jeq_cont.10110
jeq_else.10109:
	setL %g3, l.7251
	fld	%f0, %g3, 0
jeq_cont.10110:
	fst	%f0, %g1, 120
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	min_caml_floor
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	fld	%f1, %g1, 120
	fsub	%f0, %f1, %f0
	setL %g3, l.7263
	fld	%f1, %g3, 0
	setL %g3, l.6482
	fld	%f2, %g3, 0
	fld	%f3, %g1, 104
	fsub	%f2, %f2, %f3
	fst	%f0, %g1, 124
	fst	%f1, %g1, 128
	fmov	%f0, %f2
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	fsqr.2652
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	fld	%f1, %g1, 128
	fsub	%f0, %f1, %f0
	setL %g3, l.6482
	fld	%f1, %g3, 0
	fld	%f2, %g1, 124
	fsub	%f1, %f1, %f2
	fst	%f0, %g1, 132
	fmov	%f0, %f1
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	fsqr.2652
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	fld	%f1, %g1, 132
	fsub	%f0, %f1, %f0
	fst	%f0, %g1, 136
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	fisneg.2639
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10111
	fld	%f0, %g1, 136
	jmp	jeq_cont.10112
jeq_else.10111:
	setL %g3, l.6475
	fld	%f0, %g3, 0
jeq_cont.10112:
	setL %g3, l.7268
	fld	%f1, %g3, 0
	fmul	%f0, %f1, %f0
	setL %g3, l.7270
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 12
	fst	%f0, %g3, -8
	return
jeq_else.10106:
	return
add_light.3028:
	ld	%g3, %g29, -8
	ld	%g4, %g29, -4
	fst	%f2, %g1, 0
	fst	%f1, %g1, 4
	fst	%f0, %g1, 8
	st	%g3, %g1, 12
	st	%g4, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fispos.2637
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10115
	jmp	jeq_cont.10116
jeq_else.10115:
	fld	%f0, %g1, 8
	ld	%g3, %g1, 16
	ld	%g4, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	vecaccum.2739
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.10116:
	fld	%f0, %g1, 4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fispos.2637
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10117
	return
jeq_else.10117:
	fld	%f0, %g1, 4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fsqr.2652
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fsqr.2652
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
trace_reflections.3032:
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
	jlt	%g3, %g13, jle_else.10120
	slli	%g13, %g3, 2
	sub	%g6, %g6, %g13
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
	call	r_dvec.2823
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
	jne	%g3, %g4, jeq_else.10121
	jmp	jeq_cont.10122
jeq_else.10121:
	ld	%g3, %g1, 44
	ld	%g3, %g3, 0
	slli	%g3, %g3, 2
	ld	%g4, %g1, 40
	ld	%g4, %g4, 0
	add	%g3, %g3, %g4
	ld	%g4, %g1, 36
	st	%g3, %g1, 56
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	r_surface_id.2821
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g4, %g1, 56
	jne	%g4, %g3, jeq_else.10123
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
	jne	%g3, %g4, jeq_else.10125
	ld	%g3, %g1, 52
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	d_vec.2817
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g3
	ld	%g3, %g1, 24
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	veciprod.2731
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 36
	fst	%f0, %g1, 60
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	r_bright.2825
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
	call	d_vec.2817
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mov	%g4, %g3
	ld	%g3, %g1, 16
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	veciprod.2731
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
	jmp	jeq_cont.10126
jeq_else.10125:
jeq_cont.10126:
	jmp	jeq_cont.10124
jeq_else.10123:
jeq_cont.10124:
jeq_cont.10122:
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	fld	%f0, %g1, 20
	fld	%f1, %g1, 8
	ld	%g4, %g1, 16
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10120:
	return
trace_ray.3037:
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
	jlt	%g26, %g3, jle_else.10128
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
	call	p_surface_ids.2802
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
	jne	%g3, %g4, jeq_else.10129
	mvhi	%g3, 65535
	mvlo	%g3, -1
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	ld	%g6, %g1, 104
	sub	%g6, %g6, %g5
	st	%g3, %g6, 0
	mvhi	%g3, 0
	mvlo	%g3, 0
	jne	%g4, %g3, jeq_else.10130
	return
jeq_else.10130:
	ld	%g3, %g1, 96
	ld	%g4, %g1, 88
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	veciprod.2731
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	fneg.2648
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	fst	%f0, %g1, 108
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	fispos.2637
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10132
	return
jeq_else.10132:
	fld	%f0, %g1, 108
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	fsqr.2652
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
jeq_else.10129:
	ld	%g3, %g1, 72
	ld	%g3, %g3, 0
	slli	%g4, %g3, 2
	ld	%g5, %g1, 68
	sub	%g5, %g5, %g4
	ld	%g4, %g5, 0
	st	%g3, %g1, 112
	st	%g4, %g1, 116
	mov	%g3, %g4
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	o_reflectiontype.2760
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	ld	%g4, %g1, 116
	st	%g3, %g1, 120
	mov	%g3, %g4
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	o_diffuse.2780
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
	call	veccpy.2720
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
	slli	%g3, %g3, 2
	ld	%g4, %g1, 48
	ld	%g4, %g4, 0
	add	%g3, %g3, %g4
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	ld	%g6, %g1, 104
	sub	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g3, %g1, 44
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	p_intersection_points.2800
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	sub	%g3, %g3, %g5
	ld	%g3, %g3, 0
	ld	%g5, %g1, 56
	mov	%g4, %g5
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	veccpy.2720
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g3, %g1, 44
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	p_calc_diffuse.2804
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g4, %g1, 116
	st	%g3, %g1, 128
	mov	%g3, %g4
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	o_diffuse.2780
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	setL %g3, l.6482
	fld	%f1, %g3, 0
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	fless.2634
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10135
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	ld	%g6, %g1, 128
	sub	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g3, %g1, 44
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	p_energy.2806
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	sub	%g3, %g3, %g5
	ld	%g5, %g3, 0
	ld	%g6, %g1, 40
	st	%g3, %g1, 132
	mov	%g4, %g6
	mov	%g3, %g5
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	veccpy.2720
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g3, %g1, 92
	slli	%g4, %g3, 2
	ld	%g5, %g1, 132
	sub	%g5, %g5, %g4
	ld	%g4, %g5, 0
	setL %g5, l.7344
	fld	%f0, %g5, 0
	fld	%f1, %g1, 124
	fmul	%f0, %f0, %f1
	mov	%g3, %g4
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	vecscale.2749
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g3, %g1, 44
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	p_nvectors.2815
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	sub	%g3, %g3, %g5
	ld	%g3, %g3, 0
	ld	%g5, %g1, 36
	mov	%g4, %g5
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	veccpy.2720
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	jmp	jeq_cont.10136
jeq_else.10135:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	ld	%g6, %g1, 128
	sub	%g6, %g6, %g5
	st	%g3, %g6, 0
jeq_cont.10136:
	setL %g3, l.7348
	fld	%f0, %g3, 0
	ld	%g3, %g1, 96
	ld	%g4, %g1, 36
	fst	%f0, %g1, 136
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	veciprod.2731
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	fld	%f1, %g1, 136
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 96
	ld	%g4, %g1, 36
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	vecaccum.2739
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g3, %g1, 116
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	o_hilight.2782
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
	jne	%g3, %g4, jeq_else.10137
	ld	%g3, %g1, 36
	ld	%g4, %g1, 88
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	veciprod.2731
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	fneg.2648
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	fld	%f1, %g1, 124
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 96
	ld	%g4, %g1, 88
	fst	%f0, %g1, 144
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	veciprod.2731
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	fneg.2648
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
	jmp	jeq_cont.10138
jeq_else.10137:
jeq_cont.10138:
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
	setL %g3, l.7354
	fld	%f0, %g3, 0
	fld	%f1, %g1, 84
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	fless.2634
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10139
	return
jeq_else.10139:
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 92
	jlt	%g4, %g3, jle_else.10141
	jmp	jle_cont.10142
jle_else.10141:
	addi	%g3, %g4, 1
	mvhi	%g5, 65535
	mvlo	%g5, -1
	slli	%g3, %g3, 2
	ld	%g6, %g1, 104
	sub	%g6, %g6, %g3
	st	%g5, %g6, 0
jle_cont.10142:
	mvhi	%g3, 0
	mvlo	%g3, 2
	ld	%g5, %g1, 120
	jne	%g5, %g3, jeq_else.10143
	setL %g3, l.6484
	fld	%f0, %g3, 0
	ld	%g3, %g1, 116
	fst	%f0, %g1, 148
	st	%g31, %g1, 156
	subi	%g1, %g1, 160
	call	o_diffuse.2780
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
jeq_else.10143:
	return
jle_else.10128:
	return
trace_diffuse_ray.3043:
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
	jne	%g3, %g4, jeq_else.10146
	return
jeq_else.10146:
	ld	%g3, %g1, 48
	ld	%g3, %g3, 0
	slli	%g3, %g3, 2
	ld	%g4, %g1, 44
	sub	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 40
	st	%g3, %g1, 52
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	d_vec.2817
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
	jne	%g3, %g4, jeq_else.10148
	ld	%g3, %g1, 16
	ld	%g4, %g1, 12
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	veciprod.2731
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fneg.2648
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fst	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fispos.2637
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10149
	setL %g3, l.6475
	fld	%f0, %g3, 0
	jmp	jeq_cont.10150
jeq_else.10149:
	fld	%f0, %g1, 56
jeq_cont.10150:
	fld	%f1, %g1, 8
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 52
	fst	%f0, %g1, 60
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	o_diffuse.2780
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 60
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	ld	%g4, %g1, 0
	jmp	vecaccum.2739
jeq_else.10148:
	return
iter_trace_diffuse_rays.3046:
	ld	%g7, %g29, -4
	mvhi	%g8, 0
	mvlo	%g8, 0
	jlt	%g6, %g8, jle_else.10152
	slli	%g8, %g6, 2
	sub	%g3, %g3, %g8
	ld	%g8, %g3, 0
	st	%g5, %g1, 0
	st	%g29, %g1, 4
	st	%g7, %g1, 8
	st	%g3, %g1, 12
	st	%g6, %g1, 16
	st	%g4, %g1, 20
	mov	%g3, %g8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	d_vec.2817
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	veciprod.2731
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fisneg.2639
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10153
	ld	%g3, %g1, 16
	slli	%g4, %g3, 2
	ld	%g5, %g1, 12
	sub	%g5, %g5, %g4
	ld	%g4, %g5, 0
	setL %g6, l.7387
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
	jmp	jeq_cont.10154
jeq_else.10153:
	ld	%g3, %g1, 16
	addi	%g4, %g3, 1
	slli	%g4, %g4, 2
	ld	%g5, %g1, 12
	sub	%g5, %g5, %g4
	ld	%g4, %g5, 0
	setL %g6, l.7383
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
jeq_cont.10154:
	ld	%g3, %g1, 16
	subi	%g6, %g3, 2
	ld	%g3, %g1, 12
	ld	%g4, %g1, 20
	ld	%g5, %g1, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jle_else.10152:
	return
trace_diffuse_rays.3051:
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
trace_diffuse_ray_80percent.3055:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	mvhi	%g8, 0
	mvlo	%g8, 0
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g6, %g1, 8
	st	%g7, %g1, 12
	st	%g3, %g1, 16
	jne	%g3, %g8, jeq_else.10156
	jmp	jeq_cont.10157
jeq_else.10156:
	ld	%g8, %g7, 0
	mov	%g3, %g8
	mov	%g29, %g6
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.10157:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 16
	jne	%g4, %g3, jeq_else.10158
	jmp	jeq_cont.10159
jeq_else.10158:
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
jeq_cont.10159:
	mvhi	%g3, 0
	mvlo	%g3, 2
	ld	%g4, %g1, 16
	jne	%g4, %g3, jeq_else.10160
	jmp	jeq_cont.10161
jeq_else.10160:
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
jeq_cont.10161:
	mvhi	%g3, 0
	mvlo	%g3, 3
	ld	%g4, %g1, 16
	jne	%g4, %g3, jeq_else.10162
	jmp	jeq_cont.10163
jeq_else.10162:
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
jeq_cont.10163:
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 16
	jne	%g4, %g3, jeq_else.10164
	return
jeq_else.10164:
	ld	%g3, %g1, 12
	ld	%g3, %g3, -16
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
calc_diffuse_using_1point.3059:
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
	call	p_received_ray_20percent.2808
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 16
	st	%g3, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_nvectors.2815
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 16
	st	%g3, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_intersection_points.2800
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 16
	st	%g3, %g1, 28
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	p_energy.2806
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 12
	slli	%g5, %g4, 2
	ld	%g6, %g1, 20
	sub	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 8
	st	%g3, %g1, 32
	mov	%g4, %g5
	mov	%g3, %g6
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	veccpy.2720
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 16
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	p_group_id.2810
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 12
	slli	%g5, %g4, 2
	ld	%g6, %g1, 24
	sub	%g6, %g6, %g5
	ld	%g5, %g6, 0
	slli	%g6, %g4, 2
	ld	%g7, %g1, 28
	sub	%g7, %g7, %g6
	ld	%g6, %g7, 0
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
	sub	%g4, %g4, %g3
	ld	%g4, %g4, 0
	ld	%g3, %g1, 0
	ld	%g5, %g1, 8
	jmp	vecaccumv.2752
calc_diffuse_using_5points.3062:
	ld	%g8, %g29, -8
	ld	%g9, %g29, -4
	slli	%g10, %g3, 2
	sub	%g4, %g4, %g10
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
	call	p_received_ray_20percent.2808
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	subi	%g5, %g4, 1
	slli	%g5, %g5, 2
	ld	%g6, %g1, 16
	sub	%g6, %g6, %g5
	ld	%g5, %g6, 0
	st	%g3, %g1, 24
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_received_ray_20percent.2808
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	slli	%g5, %g4, 2
	ld	%g6, %g1, 16
	sub	%g6, %g6, %g5
	ld	%g5, %g6, 0
	st	%g3, %g1, 28
	mov	%g3, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	p_received_ray_20percent.2808
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 20
	addi	%g5, %g4, 1
	slli	%g5, %g5, 2
	ld	%g6, %g1, 16
	sub	%g6, %g6, %g5
	ld	%g5, %g6, 0
	st	%g3, %g1, 32
	mov	%g3, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	p_received_ray_20percent.2808
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 20
	slli	%g5, %g4, 2
	ld	%g6, %g1, 12
	sub	%g6, %g6, %g5
	ld	%g5, %g6, 0
	st	%g3, %g1, 36
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	p_received_ray_20percent.2808
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 8
	slli	%g5, %g4, 2
	ld	%g6, %g1, 24
	sub	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 4
	st	%g3, %g1, 40
	mov	%g4, %g5
	mov	%g3, %g6
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	veccpy.2720
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 8
	slli	%g4, %g3, 2
	ld	%g5, %g1, 28
	sub	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecadd.2743
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 8
	slli	%g4, %g3, 2
	ld	%g5, %g1, 32
	sub	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecadd.2743
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 8
	slli	%g4, %g3, 2
	ld	%g5, %g1, 36
	sub	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecadd.2743
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 8
	slli	%g4, %g3, 2
	ld	%g5, %g1, 40
	sub	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecadd.2743
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 20
	slli	%g3, %g3, 2
	ld	%g4, %g1, 16
	sub	%g4, %g4, %g3
	ld	%g3, %g4, 0
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	p_energy.2806
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 8
	slli	%g4, %g4, 2
	sub	%g3, %g3, %g4
	ld	%g4, %g3, 0
	ld	%g3, %g1, 0
	ld	%g5, %g1, 4
	jmp	vecaccumv.2752
do_without_neighbors.3068:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 4
	jlt	%g6, %g4, jle_else.10166
	st	%g29, %g1, 0
	st	%g5, %g1, 4
	st	%g3, %g1, 8
	st	%g4, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	p_surface_ids.2802
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g5, %g1, 12
	slli	%g6, %g5, 2
	sub	%g3, %g3, %g6
	ld	%g3, %g3, 0
	jlt	%g3, %g4, jle_else.10167
	ld	%g3, %g1, 8
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	p_calc_diffuse.2804
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 12
	slli	%g5, %g4, 2
	sub	%g3, %g3, %g5
	ld	%g3, %g3, 0
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.10168
	jmp	jeq_cont.10169
jeq_else.10168:
	ld	%g3, %g1, 8
	ld	%g29, %g1, 4
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.10169:
	ld	%g3, %g1, 12
	addi	%g4, %g3, 1
	ld	%g3, %g1, 8
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10167:
	return
jle_else.10166:
	return
neighbors_exist.3071:
	ld	%g5, %g29, -4
	ld	%g6, %g5, -4
	addi	%g7, %g4, 1
	jlt	%g7, %g6, jle_else.10172
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jle_else.10172:
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g6, %g4, jle_else.10173
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jle_else.10173:
	ld	%g4, %g5, 0
	addi	%g5, %g3, 1
	jlt	%g5, %g4, jle_else.10174
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jle_else.10174:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jlt	%g4, %g3, jle_else.10175
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jle_else.10175:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
get_surface_id.3075:
	st	%g4, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	p_surface_ids.2802
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	slli	%g4, %g4, 2
	sub	%g3, %g3, %g4
	ld	%g3, %g3, 0
	return
neighbors_are_available.3078:
	slli	%g8, %g3, 2
	sub	%g5, %g5, %g8
	ld	%g8, %g5, 0
	st	%g5, %g1, 0
	st	%g6, %g1, 4
	st	%g7, %g1, 8
	st	%g4, %g1, 12
	st	%g3, %g1, 16
	mov	%g4, %g7
	mov	%g3, %g8
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	get_surface_id.3075
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 16
	slli	%g5, %g4, 2
	ld	%g6, %g1, 12
	sub	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 8
	st	%g3, %g1, 20
	mov	%g4, %g6
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	get_surface_id.3075
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	jne	%g3, %g4, jeq_else.10176
	ld	%g3, %g1, 16
	slli	%g5, %g3, 2
	ld	%g6, %g1, 4
	sub	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 8
	mov	%g4, %g6
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	get_surface_id.3075
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	jne	%g3, %g4, jeq_else.10177
	ld	%g3, %g1, 16
	subi	%g5, %g3, 1
	slli	%g5, %g5, 2
	ld	%g6, %g1, 0
	sub	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g7, %g1, 8
	mov	%g4, %g7
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	get_surface_id.3075
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	jne	%g3, %g4, jeq_else.10178
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	slli	%g3, %g3, 2
	ld	%g5, %g1, 0
	sub	%g5, %g5, %g3
	ld	%g3, %g5, 0
	ld	%g5, %g1, 8
	mov	%g4, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	get_surface_id.3075
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	jne	%g3, %g4, jeq_else.10179
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.10179:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10178:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10177:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10176:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
try_exploit_neighbors.3084:
	ld	%g9, %g29, -8
	ld	%g10, %g29, -4
	slli	%g11, %g3, 2
	sub	%g6, %g6, %g11
	ld	%g11, %g6, 0
	mvhi	%g12, 0
	mvlo	%g12, 4
	jlt	%g12, %g8, jle_else.10180
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
	call	get_surface_id.3075
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 40
	jlt	%g3, %g4, jle_else.10181
	ld	%g3, %g1, 36
	ld	%g4, %g1, 32
	ld	%g5, %g1, 28
	ld	%g6, %g1, 24
	ld	%g7, %g1, 20
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	neighbors_are_available.3078
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10182
	ld	%g3, %g1, 36
	slli	%g3, %g3, 2
	ld	%g4, %g1, 28
	sub	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 20
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10182:
	ld	%g3, %g1, 12
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	p_calc_diffuse.2804
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g7, %g1, 20
	slli	%g4, %g7, 2
	sub	%g3, %g3, %g4
	ld	%g3, %g3, 0
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10183
	jmp	jeq_cont.10184
jeq_else.10183:
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
jeq_cont.10184:
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
jle_else.10181:
	return
jle_else.10180:
	return
write_ppm_header.3091:
	mvhi	%g3, 0
	mvlo	%g3, 80
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_write
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 54
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_write
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 10
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_write
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 49
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_write
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 50
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_write
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 56
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_write
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 32
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_write
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 49
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_write
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 50
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_write
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 56
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_write
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 32
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_write
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 50
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_write
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 53
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_write
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 53
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_write
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 10
	jmp	min_caml_write
write_rgb_element.3093:
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 255
	jlt	%g4, %g3, jle_else.10187
	mvhi	%g4, 0
	mvlo	%g4, 0
	jlt	%g3, %g4, jle_else.10189
	jmp	jle_cont.10190
jle_else.10189:
	mvhi	%g3, 0
	mvlo	%g3, 0
jle_cont.10190:
	jmp	jle_cont.10188
jle_else.10187:
	mvhi	%g3, 0
	mvlo	%g3, 255
jle_cont.10188:
	jmp	min_caml_write
write_rgb.3095:
	ld	%g3, %g29, -4
	fld	%f0, %g3, 0
	st	%g3, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	write_rgb_element.3093
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g3, %g1, 0
	fld	%f0, %g3, -4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	write_rgb_element.3093
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g3, %g1, 0
	fld	%f0, %g3, -8
	jmp	write_rgb_element.3093
pretrace_diffuse_rays.3097:
	ld	%g5, %g29, -12
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	mvhi	%g8, 0
	mvlo	%g8, 4
	jlt	%g8, %g4, jle_else.10191
	st	%g29, %g1, 0
	st	%g5, %g1, 4
	st	%g6, %g1, 8
	st	%g7, %g1, 12
	st	%g4, %g1, 16
	st	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	get_surface_id.3075
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jlt	%g3, %g4, jle_else.10192
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_calc_diffuse.2804
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 16
	slli	%g5, %g4, 2
	sub	%g3, %g3, %g5
	ld	%g3, %g3, 0
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.10193
	jmp	jeq_cont.10194
jeq_else.10193:
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_group_id.2810
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 12
	st	%g3, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	vecbzero.2718
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_nvectors.2815
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	st	%g3, %g1, 28
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	p_intersection_points.2800
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 24
	slli	%g4, %g4, 2
	ld	%g5, %g1, 8
	sub	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 16
	slli	%g6, %g5, 2
	ld	%g7, %g1, 28
	sub	%g7, %g7, %g6
	ld	%g6, %g7, 0
	slli	%g7, %g5, 2
	sub	%g3, %g3, %g7
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
	call	p_received_ray_20percent.2808
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 16
	slli	%g5, %g4, 2
	sub	%g3, %g3, %g5
	ld	%g3, %g3, 0
	ld	%g5, %g1, 12
	mov	%g4, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	veccpy.2720
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
jeq_cont.10194:
	ld	%g3, %g1, 16
	addi	%g4, %g3, 1
	ld	%g3, %g1, 20
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10192:
	return
jle_else.10191:
	return
pretrace_pixels.3100:
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
	jlt	%g4, %g15, jle_else.10197
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
	call	vecunit_sgn.2728
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 32
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	vecbzero.2718
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 28
	ld	%g4, %g1, 24
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	veccpy.2720
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g3, 0
	mvlo	%g3, 0
	setL %g4, l.6484
	fld	%f0, %g4, 0
	ld	%g4, %g1, 20
	slli	%g5, %g4, 2
	ld	%g6, %g1, 16
	sub	%g6, %g6, %g5
	ld	%g5, %g6, 0
	setL %g7, l.6475
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
	sub	%g5, %g5, %g4
	ld	%g4, %g5, 0
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	p_rgb.2798
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g4, %g1, 32
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	veccpy.2720
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 20
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	sub	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g6, %g1, 8
	mov	%g3, %g4
	mov	%g4, %g6
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	p_set_group_id.2812
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 20
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	sub	%g5, %g5, %g4
	ld	%g4, %g5, 0
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
	call	add_mod5.2707
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
jle_else.10197:
	return
pretrace_line.3107:
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
scan_pixel.3111:
	ld	%g8, %g29, -24
	ld	%g9, %g29, -20
	ld	%g10, %g29, -16
	ld	%g11, %g29, -12
	ld	%g12, %g29, -8
	ld	%g13, %g29, -4
	ld	%g12, %g12, 0
	jlt	%g3, %g12, jle_else.10199
	return
jle_else.10199:
	slli	%g12, %g3, 2
	sub	%g6, %g6, %g12
	ld	%g12, %g6, 0
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
	call	p_rgb.2798
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mov	%g4, %g3
	ld	%g3, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	veccpy.2720
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
	jne	%g3, %g4, jeq_else.10201
	ld	%g3, %g1, 32
	slli	%g4, %g3, 2
	ld	%g5, %g1, 20
	sub	%g5, %g5, %g4
	ld	%g4, %g5, 0
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
	jmp	jeq_cont.10202
jeq_else.10201:
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
jeq_cont.10202:
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
scan_line.3117:
	ld	%g8, %g29, -12
	ld	%g9, %g29, -8
	ld	%g10, %g29, -4
	ld	%g11, %g10, -4
	jlt	%g3, %g11, jle_else.10203
	return
jle_else.10203:
	ld	%g10, %g10, -4
	subi	%g10, %g10, 1
	st	%g29, %g1, 0
	st	%g7, %g1, 4
	st	%g6, %g1, 8
	st	%g5, %g1, 12
	st	%g4, %g1, 16
	st	%g3, %g1, 20
	st	%g8, %g1, 24
	jlt	%g3, %g10, jle_else.10205
	jmp	jle_cont.10206
jle_else.10205:
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
jle_cont.10206:
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
	call	add_mod5.2707
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
create_float5x3array.3123:
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g4, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
create_pixel.3125:
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g4, l.6475
	fld	%f0, %g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	st	%g3, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	create_float5x3array.3123
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
	call	create_float5x3array.3123
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	create_float5x3array.3123
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
	call	create_float5x3array.3123
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
init_line_elements.3127:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jlt	%g4, %g5, jle_else.10207
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	create_pixel.3125
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	slli	%g5, %g4, 2
	ld	%g6, %g1, 0
	sub	%g6, %g6, %g5
	st	%g3, %g6, 0
	subi	%g4, %g4, 1
	mov	%g3, %g6
	jmp	init_line_elements.3127
jle_else.10207:
	return
create_pixelline.3130:
	ld	%g3, %g29, -4
	ld	%g4, %g3, 0
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	create_pixel.3125
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
	jmp	init_line_elements.3127
tan.3132:
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
adjust_position.3134:
	ld	%g3, %g29, -4
	fmul	%f0, %f0, %f0
	setL %g4, l.7354
	fld	%f2, %g4, 0
	fadd	%f0, %f0, %f2
	st	%g3, %g1, 0
	fst	%f1, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_sqrt
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	setL %g3, l.6484
	fld	%f1, %g3, 0
	fdiv	%f1, %f1, %f0
	fst	%f0, %g1, 8
	fmov	%f0, %f1
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	atan.2657
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
calc_dirvec.3137:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	mvhi	%g8, 0
	mvlo	%g8, 5
	jlt	%g3, %g8, jle_else.10208
	st	%g5, %g1, 0
	st	%g6, %g1, 4
	st	%g4, %g1, 8
	fst	%f0, %g1, 12
	fst	%f1, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fsqr.2652
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 16
	fst	%f0, %g1, 20
	fmov	%f0, %f1
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fsqr.2652
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 20
	fadd	%f0, %f1, %f0
	setL %g3, l.6484
	fld	%f1, %g3, 0
	fadd	%f0, %f0, %f1
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_sqrt
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 12
	fdiv	%f1, %f1, %f0
	fld	%f2, %g1, 16
	fdiv	%f2, %f2, %f0
	setL %g3, l.6484
	fld	%f3, %g3, 0
	fdiv	%f0, %f3, %f0
	ld	%g3, %g1, 8
	slli	%g3, %g3, 2
	ld	%g4, %g1, 4
	sub	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 0
	slli	%g5, %g4, 2
	sub	%g3, %g3, %g5
	ld	%g5, %g3, 0
	st	%g3, %g1, 24
	fst	%f0, %g1, 28
	fst	%f2, %g1, 32
	fst	%f1, %g1, 36
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	d_vec.2817
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f0, %g1, 36
	fld	%f1, %g1, 32
	fld	%f2, %g1, 28
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecset.2710
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 0
	addi	%g4, %g3, 40
	slli	%g4, %g4, 2
	ld	%g5, %g1, 24
	sub	%g5, %g5, %g4
	ld	%g4, %g5, 0
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	d_vec.2817
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f0, %g1, 32
	st	%g3, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fneg.2648
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fmov	%f2, %f0, 0
	fld	%f0, %g1, 36
	fld	%f1, %g1, 28
	ld	%g3, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecset.2710
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 0
	addi	%g4, %g3, 80
	slli	%g4, %g4, 2
	ld	%g5, %g1, 24
	sub	%g5, %g5, %g4
	ld	%g4, %g5, 0
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	d_vec.2817
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f0, %g1, 36
	st	%g3, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2648
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 32
	fst	%f0, %g1, 48
	fmov	%f0, %f1
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2648
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fmov	%f2, %f0, 0
	fld	%f0, %g1, 28
	fld	%f1, %g1, 48
	ld	%g3, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	vecset.2710
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 0
	addi	%g4, %g3, 1
	slli	%g4, %g4, 2
	ld	%g5, %g1, 24
	sub	%g5, %g5, %g4
	ld	%g4, %g5, 0
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	d_vec.2817
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f0, %g1, 36
	st	%g3, %g1, 52
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fneg.2648
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 32
	fst	%f0, %g1, 56
	fmov	%f0, %f1
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fneg.2648
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 28
	fst	%f0, %g1, 60
	fmov	%f0, %f1
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fneg.2648
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fmov	%f2, %f0, 0
	fld	%f0, %g1, 56
	fld	%f1, %g1, 60
	ld	%g3, %g1, 52
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	vecset.2710
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 0
	addi	%g4, %g3, 41
	slli	%g4, %g4, 2
	ld	%g5, %g1, 24
	sub	%g5, %g5, %g4
	ld	%g4, %g5, 0
	mov	%g3, %g4
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	d_vec.2817
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f0, %g1, 36
	st	%g3, %g1, 64
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fneg.2648
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 28
	fst	%f0, %g1, 68
	fmov	%f0, %f1
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fneg.2648
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 68
	fld	%f2, %g1, 32
	ld	%g3, %g1, 64
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	vecset.2710
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g3, %g1, 0
	addi	%g3, %g3, 81
	slli	%g3, %g3, 2
	ld	%g4, %g1, 24
	sub	%g4, %g4, %g3
	ld	%g3, %g4, 0
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	d_vec.2817
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f0, %g1, 28
	st	%g3, %g1, 72
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fneg.2648
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 36
	fld	%f2, %g1, 32
	ld	%g3, %g1, 72
	jmp	vecset.2710
jle_else.10208:
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
calc_dirvecs.3145:
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g3, %g7, jle_else.10209
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
	setL %g3, l.7566
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.7568
	fld	%f1, %g3, 0
	fsub	%f2, %f0, %f1
	mvhi	%g3, 0
	mvlo	%g3, 0
	setL %g4, l.6475
	fld	%f0, %g4, 0
	setL %g4, l.6475
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
	setL %g3, l.7566
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.7354
	fld	%f1, %g3, 0
	fadd	%f2, %f0, %f1
	mvhi	%g3, 0
	mvlo	%g3, 0
	setL %g4, l.6475
	fld	%f0, %g4, 0
	setL %g4, l.6475
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
	call	add_mod5.2707
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g3
	fld	%f0, %g1, 8
	ld	%g3, %g1, 24
	ld	%g5, %g1, 12
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10209:
	return
calc_dirvec_rows.3150:
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g3, %g7, jle_else.10211
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
	setL %g3, l.7566
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.7568
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
	call	add_mod5.2707
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g3
	ld	%g3, %g1, 8
	addi	%g5, %g3, 4
	ld	%g3, %g1, 20
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10211:
	return
create_dirvec.3154:
	ld	%g3, %g29, -4
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6475
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
create_dirvec_elements.3156:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g4, %g6, jle_else.10213
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
	sub	%g6, %g6, %g5
	st	%g3, %g6, 0
	subi	%g4, %g4, 1
	ld	%g29, %g1, 0
	mov	%g3, %g6
	ld	%g28, %g29, 0
	b	%g28
jle_else.10213:
	return
create_dirvecs.3159:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g3, %g7, jle_else.10215
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
	sub	%g6, %g6, %g5
	st	%g3, %g6, 0
	slli	%g3, %g4, 2
	sub	%g6, %g6, %g3
	ld	%g3, %g6, 0
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
jle_else.10215:
	return
init_dirvec_constants.3161:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g4, %g6, jle_else.10217
	slli	%g6, %g4, 2
	sub	%g3, %g3, %g6
	ld	%g6, %g3, 0
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
jle_else.10217:
	return
init_vecset_constants.3164:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g3, %g6, jle_else.10219
	slli	%g6, %g3, 2
	sub	%g5, %g5, %g6
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
jle_else.10219:
	return
init_dirvecs.3166:
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
add_reflection.3168:
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
	call	d_vec.2817
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f0, %g1, 28
	fld	%f1, %g1, 24
	fld	%f2, %g1, 20
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	vecset.2710
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
	sub	%g5, %g5, %g4
	st	%g3, %g5, 0
	return
setup_rect_reflection.3175:
	ld	%g5, %g29, -12
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	slli	%g3, %g3, 2
	ld	%g8, %g5, 0
	setL %g9, l.6484
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
	call	o_diffuse.2780
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
	call	fneg.2648
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 16
	fld	%f1, %g3, -4
	fst	%f0, %g1, 28
	fmov	%f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2648
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 16
	fld	%f1, %g3, -8
	fst	%f0, %g1, 32
	fmov	%f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2648
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
setup_surface_reflection.3178:
	ld	%g5, %g29, -12
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	slli	%g3, %g3, 2
	addi	%g3, %g3, 1
	ld	%g8, %g5, 0
	setL %g9, l.6484
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
	call	o_diffuse.2780
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 20
	fst	%f0, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_abc.2772
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g4, %g3
	ld	%g3, %g1, 16
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	veciprod.2731
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	setL %g3, l.6480
	fld	%f1, %g3, 0
	ld	%g3, %g1, 20
	fst	%f0, %g1, 32
	fst	%f1, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_a.2766
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 32
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 16
	fld	%f2, %g3, 0
	fsub	%f0, %f0, %f2
	setL %g4, l.6480
	fld	%f2, %g4, 0
	ld	%g4, %g1, 20
	fst	%f0, %g1, 40
	fst	%f2, %g1, 44
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_b.2768
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 44
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 32
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 16
	fld	%f2, %g3, -4
	fsub	%f0, %f0, %f2
	setL %g4, l.6480
	fld	%f2, %g4, 0
	ld	%g4, %g1, 20
	fst	%f0, %g1, 48
	fst	%f2, %g1, 52
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_c.2770
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
setup_reflections.3181:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g3, %g7, jle_else.10224
	slli	%g7, %g3, 2
	sub	%g6, %g6, %g7
	ld	%g6, %g6, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	st	%g5, %g1, 8
	st	%g6, %g1, 12
	mov	%g3, %g6
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_reflectiontype.2760
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.10225
	ld	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_diffuse.2780
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	setL %g3, l.6484
	fld	%f1, %g3, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fless.2634
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10226
	return
jeq_else.10226:
	ld	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_form.2758
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.10228
	ld	%g3, %g1, 4
	ld	%g4, %g1, 12
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10228:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.10229
	ld	%g3, %g1, 4
	ld	%g4, %g1, 12
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10229:
	return
jeq_else.10225:
	return
jle_else.10224:
	return
rt.3183:
	ld	%g5, %g29, -52
	ld	%g6, %g29, -48
	ld	%g7, %g29, -44
	ld	%g8, %g29, -40
	ld	%g9, %g29, -36
	ld	%g10, %g29, -32
	ld	%g11, %g29, -28
	ld	%g12, %g29, -24
	ld	%g13, %g29, -20
	ld	%g14, %g29, -16
	ld	%g15, %g29, -12
	ld	%g16, %g29, -8
	ld	%g17, %g29, -4
	st	%g3, %g15, 0
	st	%g4, %g15, -4
	slli	%g15, %g3, -1
	st	%g15, %g16, 0
	slli	%g4, %g4, -1
	st	%g4, %g16, -4
	setL %g4, l.7633
	fld	%f0, %g4, 0
	st	%g8, %g1, 0
	st	%g10, %g1, 4
	st	%g5, %g1, 8
	st	%g11, %g1, 12
	st	%g6, %g1, 16
	st	%g13, %g1, 20
	st	%g12, %g1, 24
	st	%g14, %g1, 28
	st	%g9, %g1, 32
	st	%g17, %g1, 36
	st	%g7, %g1, 40
	fst	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 44
	fdiv	%f0, %f1, %f0
	ld	%g3, %g1, 40
	fst	%f0, %g3, 0
	ld	%g29, %g1, 36
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g29, %g1, 36
	st	%g3, %g1, 48
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g29, %g1, 36
	st	%g3, %g1, 52
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g29, %g1, 32
	st	%g3, %g1, 56
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	write_ppm_header.3091
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g29, %g1, 28
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 24
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	d_vec.2817
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g4, %g1, 20
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	veccpy.2720
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 24
	ld	%g29, %g1, 16
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 12
	ld	%g3, %g3, 0
	subi	%g3, %g3, 1
	ld	%g29, %g1, 8
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g3, %g1, 52
	ld	%g29, %g1, 4
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g3, 0
	mvlo	%g3, 0
	mvhi	%g7, 0
	mvlo	%g7, 2
	ld	%g4, %g1, 48
	ld	%g5, %g1, 52
	ld	%g6, %g1, 56
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
min_caml_start:
	setL %g3, l.7638
	fld	%f0, %g3, 0
	setL %g3, l.7640
	fld	%f1, %g3, 0
	setL %g3, l.6497
	fld	%f2, %g3, 0
	mov	%g3, %g2
	addi	%g2, %g2, 32
	setL %g4, sin.2659
	st	%g4, %g3, 0
	fst	%f2, %g3, -24
	fst	%f1, %g3, -16
	fst	%f0, %g3, -8
	mov	%g4, %g2
	addi	%g2, %g2, 8
	setL %g5, cos.2661
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.7268
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
	setL %g5, l.6475
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
	setL %g5, l.7167
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g5, l.6475
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
	setL %g6, l.6475
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
	setL %g5, read_screen_settings.2829
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
	setL %g12, read_light.2831
	st	%g12, %g11, 0
	st	%g6, %g11, -16
	ld	%g12, %g1, 24
	st	%g12, %g11, -12
	st	%g10, %g11, -8
	ld	%g13, %g1, 28
	st	%g13, %g11, -4
	mov	%g14, %g2
	addi	%g2, %g2, 16
	setL %g15, rotate_quadratic_matrix.2833
	st	%g15, %g14, 0
	st	%g6, %g14, -8
	st	%g10, %g14, -4
	mov	%g15, %g2
	addi	%g2, %g2, 16
	setL %g16, read_nth_object.2836
	st	%g16, %g15, 0
	st	%g14, %g15, -8
	ld	%g14, %g1, 12
	st	%g14, %g15, -4
	mov	%g16, %g2
	addi	%g2, %g2, 16
	setL %g17, read_object.2838
	st	%g17, %g16, 0
	st	%g15, %g16, -8
	ld	%g15, %g1, 8
	st	%g15, %g16, -4
	mov	%g17, %g2
	addi	%g2, %g2, 8
	setL %g18, read_all_object.2840
	st	%g18, %g17, 0
	st	%g16, %g17, -4
	mov	%g16, %g2
	addi	%g2, %g2, 8
	setL %g18, read_and_network.2846
	st	%g18, %g16, 0
	ld	%g18, %g1, 36
	st	%g18, %g16, -4
	mov	%g19, %g2
	addi	%g2, %g2, 24
	setL %g20, read_parameter.2848
	st	%g20, %g19, 0
	st	%g4, %g19, -20
	st	%g11, %g19, -16
	st	%g16, %g19, -12
	st	%g17, %g19, -8
	ld	%g4, %g1, 44
	st	%g4, %g19, -4
	mov	%g11, %g2
	addi	%g2, %g2, 8
	setL %g16, solver_rect_surface.2850
	st	%g16, %g11, 0
	ld	%g16, %g1, 48
	st	%g16, %g11, -4
	mov	%g17, %g2
	addi	%g2, %g2, 8
	setL %g20, solver_rect.2859
	st	%g20, %g17, 0
	st	%g11, %g17, -4
	mov	%g11, %g2
	addi	%g2, %g2, 8
	setL %g20, solver_surface.2865
	st	%g20, %g11, 0
	st	%g16, %g11, -4
	mov	%g20, %g2
	addi	%g2, %g2, 8
	setL %g21, solver_second.2884
	st	%g21, %g20, 0
	st	%g16, %g20, -4
	mov	%g21, %g2
	addi	%g2, %g2, 24
	setL %g22, solver.2890
	st	%g22, %g21, 0
	st	%g11, %g21, -16
	st	%g20, %g21, -12
	st	%g17, %g21, -8
	st	%g14, %g21, -4
	mov	%g11, %g2
	addi	%g2, %g2, 8
	setL %g17, solver_rect_fast.2894
	st	%g17, %g11, 0
	st	%g16, %g11, -4
	mov	%g17, %g2
	addi	%g2, %g2, 8
	setL %g20, solver_surface_fast.2901
	st	%g20, %g17, 0
	st	%g16, %g17, -4
	mov	%g20, %g2
	addi	%g2, %g2, 8
	setL %g22, solver_second_fast.2907
	st	%g22, %g20, 0
	st	%g16, %g20, -4
	mov	%g22, %g2
	addi	%g2, %g2, 24
	setL %g23, solver_fast.2913
	st	%g23, %g22, 0
	st	%g17, %g22, -16
	st	%g20, %g22, -12
	st	%g11, %g22, -8
	st	%g14, %g22, -4
	mov	%g17, %g2
	addi	%g2, %g2, 8
	setL %g20, solver_surface_fast2.2917
	st	%g20, %g17, 0
	st	%g16, %g17, -4
	mov	%g20, %g2
	addi	%g2, %g2, 8
	setL %g23, solver_second_fast2.2924
	st	%g23, %g20, 0
	st	%g16, %g20, -4
	mov	%g23, %g2
	addi	%g2, %g2, 24
	setL %g24, solver_fast2.2931
	st	%g24, %g23, 0
	st	%g17, %g23, -16
	st	%g20, %g23, -12
	st	%g11, %g23, -8
	st	%g14, %g23, -4
	mov	%g11, %g2
	addi	%g2, %g2, 8
	setL %g17, iter_setup_dirvec_constants.2943
	st	%g17, %g11, 0
	st	%g14, %g11, -4
	mov	%g17, %g2
	addi	%g2, %g2, 16
	setL %g20, setup_dirvec_constants.2946
	st	%g20, %g17, 0
	st	%g15, %g17, -8
	st	%g11, %g17, -4
	mov	%g11, %g2
	addi	%g2, %g2, 8
	setL %g20, setup_startp_constants.2948
	st	%g20, %g11, 0
	st	%g14, %g11, -4
	mov	%g20, %g2
	addi	%g2, %g2, 16
	setL %g24, setup_startp.2951
	st	%g24, %g20, 0
	ld	%g24, %g1, 100
	st	%g24, %g20, -12
	st	%g11, %g20, -8
	st	%g15, %g20, -4
	mov	%g11, %g2
	addi	%g2, %g2, 8
	setL %g25, check_all_inside.2973
	st	%g25, %g11, 0
	st	%g14, %g11, -4
	mov	%g25, %g2
	addi	%g2, %g2, 32
	setL %g26, shadow_check_and_group.2979
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
	setL %g29, shadow_check_one_or_group.2982
	st	%g29, %g28, 0
	st	%g25, %g28, -8
	st	%g18, %g28, -4
	mov	%g25, %g2
	addi	%g2, %g2, 24
	setL %g29, shadow_check_one_or_matrix.2985
	st	%g29, %g25, 0
	st	%g22, %g25, -20
	st	%g16, %g25, -16
	st	%g28, %g25, -12
	st	%g26, %g25, -8
	st	%g27, %g25, -4
	mov	%g22, %g2
	addi	%g2, %g2, 40
	setL %g28, solve_each_element.2988
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
	setL %g15, solve_one_or_network.2992
	st	%g15, %g17, 0
	st	%g22, %g17, -8
	st	%g18, %g17, -4
	mov	%g15, %g2
	addi	%g2, %g2, 24
	setL %g22, trace_or_matrix.2996
	st	%g22, %g15, 0
	st	%g28, %g15, -20
	st	%g29, %g15, -16
	st	%g16, %g15, -12
	st	%g21, %g15, -8
	st	%g17, %g15, -4
	mov	%g17, %g2
	addi	%g2, %g2, 16
	setL %g21, judge_intersection.3000
	st	%g21, %g17, 0
	st	%g15, %g17, -12
	st	%g28, %g17, -8
	st	%g4, %g17, -4
	mov	%g15, %g2
	addi	%g2, %g2, 40
	setL %g21, solve_each_element_fast.3002
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
	setL %g21, solve_one_or_network_fast.3006
	st	%g21, %g11, 0
	st	%g15, %g11, -8
	st	%g18, %g11, -4
	mov	%g15, %g2
	addi	%g2, %g2, 24
	setL %g18, trace_or_matrix_fast.3010
	st	%g18, %g15, 0
	st	%g28, %g15, -16
	st	%g23, %g15, -12
	st	%g16, %g15, -8
	st	%g11, %g15, -4
	mov	%g11, %g2
	addi	%g2, %g2, 16
	setL %g16, judge_intersection_fast.3014
	st	%g16, %g11, 0
	st	%g15, %g11, -12
	st	%g28, %g11, -8
	st	%g4, %g11, -4
	mov	%g15, %g2
	addi	%g2, %g2, 16
	setL %g16, get_nvector_rect.3016
	st	%g16, %g15, 0
	ld	%g16, %g1, 68
	st	%g16, %g15, -8
	st	%g26, %g15, -4
	mov	%g18, %g2
	addi	%g2, %g2, 8
	setL %g21, get_nvector_plane.3018
	st	%g21, %g18, 0
	st	%g16, %g18, -4
	mov	%g21, %g2
	addi	%g2, %g2, 16
	setL %g22, get_nvector_second.3020
	st	%g22, %g21, 0
	st	%g16, %g21, -8
	st	%g27, %g21, -4
	mov	%g22, %g2
	addi	%g2, %g2, 16
	setL %g23, get_nvector.3022
	st	%g23, %g22, 0
	st	%g21, %g22, -12
	st	%g15, %g22, -8
	st	%g18, %g22, -4
	mov	%g15, %g2
	addi	%g2, %g2, 16
	setL %g18, utexture.3025
	st	%g18, %g15, 0
	ld	%g18, %g1, 72
	st	%g18, %g15, -12
	st	%g6, %g15, -8
	st	%g10, %g15, -4
	mov	%g21, %g2
	addi	%g2, %g2, 16
	setL %g23, add_light.3028
	st	%g23, %g21, 0
	st	%g18, %g21, -8
	ld	%g23, %g1, 80
	st	%g23, %g21, -4
	mov	%g24, %g2
	addi	%g2, %g2, 40
	setL %g10, trace_reflections.3032
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
	setL %g6, trace_ray.3037
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
	setL %g13, trace_diffuse_ray.3043
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
	setL %g13, iter_trace_diffuse_rays.3046
	st	%g13, %g11, 0
	st	%g6, %g11, -4
	mov	%g6, %g2
	addi	%g2, %g2, 16
	setL %g13, trace_diffuse_rays.3051
	st	%g13, %g6, 0
	st	%g20, %g6, -8
	st	%g11, %g6, -4
	mov	%g11, %g2
	addi	%g2, %g2, 16
	setL %g13, trace_diffuse_ray_80percent.3055
	st	%g13, %g11, 0
	st	%g6, %g11, -8
	ld	%g13, %g1, 124
	st	%g13, %g11, -4
	mov	%g15, %g2
	addi	%g2, %g2, 16
	setL %g16, calc_diffuse_using_1point.3059
	st	%g16, %g15, 0
	st	%g11, %g15, -12
	st	%g23, %g15, -8
	st	%g4, %g15, -4
	mov	%g11, %g2
	addi	%g2, %g2, 16
	setL %g16, calc_diffuse_using_5points.3062
	st	%g16, %g11, 0
	st	%g23, %g11, -8
	st	%g4, %g11, -4
	mov	%g16, %g2
	addi	%g2, %g2, 8
	setL %g17, do_without_neighbors.3068
	st	%g17, %g16, 0
	st	%g15, %g16, -4
	mov	%g15, %g2
	addi	%g2, %g2, 8
	setL %g17, neighbors_exist.3071
	st	%g17, %g15, 0
	ld	%g17, %g1, 84
	st	%g17, %g15, -4
	mov	%g18, %g2
	addi	%g2, %g2, 16
	setL %g19, try_exploit_neighbors.3084
	st	%g19, %g18, 0
	st	%g16, %g18, -8
	st	%g11, %g18, -4
	mov	%g11, %g2
	addi	%g2, %g2, 8
	setL %g19, write_rgb.3095
	st	%g19, %g11, 0
	st	%g23, %g11, -4
	mov	%g19, %g2
	addi	%g2, %g2, 16
	setL %g20, pretrace_diffuse_rays.3097
	st	%g20, %g19, 0
	st	%g6, %g19, -12
	st	%g13, %g19, -8
	st	%g4, %g19, -4
	mov	%g4, %g2
	addi	%g2, %g2, 40
	setL %g6, pretrace_pixels.3100
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
	st	%g19, %g4, -8
	ld	%g6, %g1, 88
	st	%g6, %g4, -4
	mov	%g9, %g2
	addi	%g2, %g2, 32
	setL %g10, pretrace_line.3107
	st	%g10, %g9, 0
	st	%g7, %g9, -24
	st	%g8, %g9, -20
	st	%g5, %g9, -16
	st	%g4, %g9, -12
	st	%g17, %g9, -8
	st	%g6, %g9, -4
	mov	%g4, %g2
	addi	%g2, %g2, 32
	setL %g7, scan_pixel.3111
	st	%g7, %g4, 0
	st	%g11, %g4, -24
	st	%g18, %g4, -20
	st	%g23, %g4, -16
	st	%g15, %g4, -12
	st	%g17, %g4, -8
	st	%g16, %g4, -4
	mov	%g7, %g2
	addi	%g2, %g2, 16
	setL %g8, scan_line.3117
	st	%g8, %g7, 0
	st	%g4, %g7, -12
	st	%g9, %g7, -8
	st	%g17, %g7, -4
	mov	%g4, %g2
	addi	%g2, %g2, 8
	setL %g8, create_pixelline.3130
	st	%g8, %g4, 0
	st	%g17, %g4, -4
	mov	%g8, %g2
	addi	%g2, %g2, 16
	setL %g10, tan.3132
	st	%g10, %g8, 0
	ld	%g10, %g1, 4
	st	%g10, %g8, -8
	ld	%g10, %g1, 0
	st	%g10, %g8, -4
	mov	%g10, %g2
	addi	%g2, %g2, 8
	setL %g11, adjust_position.3134
	st	%g11, %g10, 0
	st	%g8, %g10, -4
	mov	%g8, %g2
	addi	%g2, %g2, 16
	setL %g11, calc_dirvec.3137
	st	%g11, %g8, 0
	st	%g13, %g8, -8
	st	%g10, %g8, -4
	mov	%g10, %g2
	addi	%g2, %g2, 8
	setL %g11, calc_dirvecs.3145
	st	%g11, %g10, 0
	st	%g8, %g10, -4
	mov	%g8, %g2
	addi	%g2, %g2, 8
	setL %g11, calc_dirvec_rows.3150
	st	%g11, %g8, 0
	st	%g10, %g8, -4
	mov	%g10, %g2
	addi	%g2, %g2, 8
	setL %g11, create_dirvec.3154
	st	%g11, %g10, 0
	ld	%g11, %g1, 8
	st	%g11, %g10, -4
	mov	%g15, %g2
	addi	%g2, %g2, 8
	setL %g16, create_dirvec_elements.3156
	st	%g16, %g15, 0
	st	%g10, %g15, -4
	mov	%g16, %g2
	addi	%g2, %g2, 16
	setL %g18, create_dirvecs.3159
	st	%g18, %g16, 0
	st	%g13, %g16, -12
	st	%g15, %g16, -8
	st	%g10, %g16, -4
	mov	%g15, %g2
	addi	%g2, %g2, 8
	setL %g18, init_dirvec_constants.3161
	st	%g18, %g15, 0
	ld	%g18, %g1, 152
	st	%g18, %g15, -4
	mov	%g19, %g2
	addi	%g2, %g2, 16
	setL %g20, init_vecset_constants.3164
	st	%g20, %g19, 0
	st	%g15, %g19, -8
	st	%g13, %g19, -4
	mov	%g13, %g2
	addi	%g2, %g2, 16
	setL %g15, init_dirvecs.3166
	st	%g15, %g13, 0
	st	%g19, %g13, -12
	st	%g16, %g13, -8
	st	%g8, %g13, -4
	mov	%g8, %g2
	addi	%g2, %g2, 16
	setL %g15, add_reflection.3168
	st	%g15, %g8, 0
	st	%g18, %g8, -12
	ld	%g15, %g1, 144
	st	%g15, %g8, -8
	st	%g10, %g8, -4
	mov	%g10, %g2
	addi	%g2, %g2, 16
	setL %g15, setup_rect_reflection.3175
	st	%g15, %g10, 0
	st	%g3, %g10, -12
	st	%g12, %g10, -8
	st	%g8, %g10, -4
	mov	%g15, %g2
	addi	%g2, %g2, 16
	setL %g16, setup_surface_reflection.3178
	st	%g16, %g15, 0
	st	%g3, %g15, -12
	st	%g12, %g15, -8
	st	%g8, %g15, -4
	mov	%g3, %g2
	addi	%g2, %g2, 16
	setL %g8, setup_reflections.3181
	st	%g8, %g3, 0
	st	%g15, %g3, -12
	st	%g10, %g3, -8
	st	%g14, %g3, -4
	mov	%g29, %g2
	addi	%g2, %g2, 56
	setL %g8, rt.3183
	st	%g8, %g29, 0
	st	%g3, %g29, -52
	st	%g18, %g29, -48
	st	%g5, %g29, -44
	st	%g7, %g29, -40
	ld	%g3, %g1, 148
	st	%g3, %g29, -36
	st	%g9, %g29, -32
	st	%g11, %g29, -28
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
