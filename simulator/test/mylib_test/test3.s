.init_heap_size	832
l.542:	! 5.759587
	.long	0x40b84e88
l.540:	! 5.497787
	.long	0x40afedd7
l.538:	! 5.235988
	.long	0x40a78d2e
l.536:	! 4.712389
	.long	0x4096cbe3
l.534:	! 4.188790
	.long	0x40860a91
l.532:	! 3.926991
	.long	0x407b53d1
l.530:	! 3.665191
	.long	0x406a9277
l.528:	! 2.617994
	.long	0x40278d2e
l.526:	! 2.356194
	.long	0x4016cbe3
l.524:	! 2.094395
	.long	0x40060a91
l.522:	! 1.047198
	.long	0x3f860a91
l.520:	! 0.785398
	.long	0x3f490fda
l.518:	! 0.523599
	.long	0x3f060a91
l.514:	! 6.283185
	.long	0x40c90fda
l.512:	! 3.141593
	.long	0x40490fda
l.508:	! 1.570796
	.long	0x3fc90fda
l.497:	! 9.000000
	.long	0x41100000
l.493:	! 2.500000
	.long	0x40200000
l.491:	! -1.570796
	.long	0xbfc90fda
l.489:	! 1.570796
	.long	0x3fc90fda
l.485:	! 11.000000
	.long	0x41300000
l.481:	! -1.000000
	.long	0xbf800000
l.477:	! 2.000000
	.long	0x40000000
l.475:	! 1.000000
	.long	0x3f800000
l.473:	! 0.500000
	.long	0x3f000000
l.471:	! 0.000000
	.long	0x0
	jmp	min_caml_start

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
	fst %f0, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_FLOAT_ARRAY_LOOP
CREATE_FLOAT_ARRAY_END:
	return

!#####################################################################
! * ここまでライブラリ関数
!#####################################################################

fabs.217:
	setL %g3, l.471
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.617
	return
fjge_else.617:
	fneg	%f0, %f0
	return
fneg.219:
	fneg	%f0, %f0
	return
atan_sub.435:
	setL %g3, l.473
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.618
	setL %g3, l.475
	fld	%f3, %g3, 0
	fsub	%f3, %f0, %f3
	fmul	%f4, %f0, %f0
	fmul	%f4, %f4, %f1
	setL %g3, l.477
	fld	%f5, %g3, 0
	fmul	%f0, %f5, %f0
	setL %g3, l.475
	fld	%f5, %g3, 0
	fadd	%f0, %f0, %f5
	fadd	%f0, %f0, %f2
	fdiv	%f2, %f4, %f0
	fmov	%f0, %f3
	jmp	atan_sub.435
fjge_else.618:
	fmov	%f0, %f2
	return
atan.221:
	setL %g3, l.475
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.619
	setL %g3, l.481
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.621
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	fjge_cont.622
fjge_else.621:
	mvhi	%g3, 65535
	mvlo	%g3, -1
fjge_cont.622:
	jmp	fjge_cont.620
fjge_else.619:
	mvhi	%g3, 0
	mvlo	%g3, 1
fjge_cont.620:
	st	%g3, %g1, 0
	fst	%f0, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fabs.217
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	setL %g3, l.475
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.623
	fld	%f0, %g1, 4
	jmp	fjge_cont.624
fjge_else.623:
	setL %g3, l.475
	fld	%f0, %g3, 0
	fld	%f1, %g1, 4
	fdiv	%f0, %f0, %f1
fjge_cont.624:
	setL %g3, l.485
	fld	%f1, %g3, 0
	fmul	%f2, %f0, %f0
	setL %g3, l.471
	fld	%f3, %g3, 0
	fst	%f0, %g1, 8
	fmov	%f0, %f1
	fmov	%f1, %f2
	fmov	%f2, %f3
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	atan_sub.435
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	setL %g3, l.475
	fld	%f1, %g3, 0
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 8
	fdiv	%f0, %f1, %f0
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 0
	jlt	%g3, %g4, jle_else.625
	mvhi	%g3, 0
	mvlo	%g3, 0
	jlt	%g4, %g3, jle_else.626
	return
jle_else.626:
	setL %g3, l.491
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	return
jle_else.625:
	setL %g3, l.489
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	return
tan_sub.410:
	setL %g3, l.493
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.627
	setL %g3, l.477
	fld	%f3, %g3, 0
	fsub	%f3, %f0, %f3
	fsub	%f0, %f0, %f2
	fdiv	%f2, %f1, %f0
	fmov	%f0, %f3
	jmp	tan_sub.410
fjge_else.627:
	fmov	%f0, %f2
	return
tan.228:
	setL %g3, l.475
	fld	%f1, %g3, 0
	setL %g3, l.497
	fld	%f2, %g3, 0
	fmul	%f3, %f0, %f0
	setL %g3, l.471
	fld	%f4, %g3, 0
	fst	%f0, %g1, 0
	fst	%f1, %g1, 4
	fmov	%f1, %f3
	fmov	%f0, %f2
	fmov	%f2, %f4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	tan_sub.410
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f1, %g1, 4
	fsub	%f0, %f1, %f0
	fld	%f1, %g1, 0
	fdiv	%f0, %f1, %f0
	return
tmp.389:
	fld	%f1, %g29, -8
	fjlt	%f1, %f0, fjge_else.628
	setL %g3, l.471
	fld	%f2, %g3, 0
	fjlt	%f0, %f2, fjge_else.629
	return
fjge_else.629:
	fadd	%f0, %f0, %f1
	ld	%g28, %g29, 0
	b	%g28
fjge_else.628:
	fsub	%f0, %f0, %f1
	ld	%g28, %g29, 0
	b	%g28
sin.230:
	fld	%f1, %g29, -24
	fld	%f2, %g29, -16
	fld	%f3, %g29, -8
	setL %g3, l.471
	fld	%f4, %g3, 0
	fjlt	%f4, %f0, fjge_else.630
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	fjge_cont.631
fjge_else.630:
	mvhi	%g3, 0
	mvlo	%g3, 1
fjge_cont.631:
	fst	%f1, %g1, 0
	st	%g3, %g1, 4
	fst	%f3, %g1, 8
	fst	%f2, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fabs.217
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g29, %g2
	addi	%g2, %g2, 16
	setL %g3, tmp.389
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
	fjlt	%f1, %f0, fjge_else.632
	ld	%g3, %g1, 4
	jmp	fjge_cont.633
fjge_else.632:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 4
	jne	%g4, %g3, jeq_else.634
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.635
jeq_else.634:
	mvhi	%g3, 0
	mvlo	%g3, 0
jeq_cont.635:
fjge_cont.633:
	fjlt	%f1, %f0, fjge_else.636
	jmp	fjge_cont.637
fjge_else.636:
	fld	%f2, %g1, 12
	fsub	%f0, %f2, %f0
fjge_cont.637:
	fld	%f2, %g1, 0
	fjlt	%f2, %f0, fjge_else.638
	jmp	fjge_cont.639
fjge_else.638:
	fsub	%f0, %f1, %f0
fjge_cont.639:
	setL %g4, l.473
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	st	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	tan.228
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	setL %g3, l.477
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	setL %g3, l.475
	fld	%f2, %g3, 0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f2, %f0
	fdiv	%f0, %f1, %f0
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 16
	jne	%g4, %g3, jeq_else.640
	jmp	fneg.219
jeq_else.640:
	return
cos.232:
	ld	%g29, %g29, -4
	setL %g3, l.508
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	ld	%g28, %g29, 0
	b	%g28
min_caml_start:
	setL %g3, l.475
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	atan.221
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.481
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	atan.221
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.512
	fld	%f0, %g3, 0
	setL %g3, l.514
	fld	%f1, %g3, 0
	setL %g3, l.489
	fld	%f2, %g3, 0
	mov	%g29, %g2
	addi	%g2, %g2, 32
	setL %g3, sin.230
	st	%g3, %g29, 0
	fst	%f2, %g29, -24
	fst	%f1, %g29, -16
	fst	%f0, %g29, -8
	mov	%g3, %g2
	addi	%g2, %g2, 8
	setL %g4, cos.232
	st	%g4, %g3, 0
	st	%g29, %g3, -4
	setL %g4, l.471
	fld	%f3, %g4, 0
	st	%g3, %g1, 0
	fst	%f1, %g1, 4
	fst	%f0, %g1, 8
	fst	%f2, %g1, 12
	st	%g29, %g1, 16
	fmov	%f0, %f3
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.518
	fld	%f0, %g3, 0
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.520
	fld	%f0, %g3, 0
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.522
	fld	%f0, %g3, 0
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	fld	%f0, %g1, 12
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.524
	fld	%f0, %g3, 0
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.526
	fld	%f0, %g3, 0
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.528
	fld	%f0, %g3, 0
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	fld	%f0, %g1, 8
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.530
	fld	%f0, %g3, 0
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.532
	fld	%f0, %g3, 0
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.534
	fld	%f0, %g3, 0
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.536
	fld	%f0, %g3, 0
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.538
	fld	%f0, %g3, 0
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.540
	fld	%f0, %g3, 0
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.542
	fld	%f0, %g3, 0
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	fld	%f0, %g1, 4
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.471
	fld	%f0, %g3, 0
	ld	%g29, %g1, 0
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.518
	fld	%f0, %g3, 0
	ld	%g29, %g1, 0
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.520
	fld	%f0, %g3, 0
	ld	%g29, %g1, 0
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.522
	fld	%f0, %g3, 0
	ld	%g29, %g1, 0
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	fld	%f0, %g1, 12
	ld	%g29, %g1, 0
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.524
	fld	%f0, %g3, 0
	ld	%g29, %g1, 0
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.526
	fld	%f0, %g3, 0
	ld	%g29, %g1, 0
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.528
	fld	%f0, %g3, 0
	ld	%g29, %g1, 0
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	fld	%f0, %g1, 8
	ld	%g29, %g1, 0
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.530
	fld	%f0, %g3, 0
	ld	%g29, %g1, 0
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.532
	fld	%f0, %g3, 0
	ld	%g29, %g1, 0
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.534
	fld	%f0, %g3, 0
	ld	%g29, %g1, 0
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.536
	fld	%f0, %g3, 0
	ld	%g29, %g1, 0
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.538
	fld	%f0, %g3, 0
	ld	%g29, %g1, 0
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.540
	fld	%f0, %g3, 0
	ld	%g29, %g1, 0
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.542
	fld	%f0, %g3, 0
	ld	%g29, %g1, 0
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	fld	%f0, %g1, 4
	ld	%g29, %g1, 0
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	halt
