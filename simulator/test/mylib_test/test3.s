.init_heap_size	832
l.538:	! 5.759587
	.long	0x40b84e88
l.536:	! 5.497787
	.long	0x40afedd7
l.534:	! 5.235988
	.long	0x40a78d2e
l.532:	! 4.712389
	.long	0x4096cbe3
l.530:	! 4.188790
	.long	0x40860a91
l.528:	! 3.926991
	.long	0x407b53d1
l.526:	! 3.665191
	.long	0x406a9277
l.524:	! 2.617994
	.long	0x40278d2e
l.522:	! 2.356194
	.long	0x4016cbe3
l.520:	! 2.094395
	.long	0x40060a91
l.518:	! 1.047198
	.long	0x3f860a91
l.516:	! 0.785398
	.long	0x3f490fda
l.514:	! 0.523599
	.long	0x3f060a91
l.511:	! 3.141593
	.long	0x40490fda
l.509:	! 6.283185
	.long	0x40c90fda
l.504:	! 1.570796
	.long	0x3fc90fda
l.493:	! 9.000000
	.long	0x41100000
l.489:	! 2.500000
	.long	0x40200000
l.487:	! -1.570796
	.long	0xbfc90fda
l.485:	! 1.570796
	.long	0x3fc90fda
l.483:	! 11.000000
	.long	0x41300000
l.480:	! -1.000000
	.long	0xbf800000
l.477:	! 1.000000
	.long	0x3f800000
l.475:	! 2.000000
	.long	0x40000000
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

fabs.217:
	setL %g3, l.471
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.614
	return
fjge_else.614:
	fneg	%f0, %f0
	return
fneg.219:
	fneg	%f0, %f0
	return
atan_sub.435:
	setL %g3, l.473
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.615
	setL %g3, l.475
	fld	%f3, %g3, 0
	fmul	%f3, %f3, %f0
	setL %g3, l.477
	fld	%f4, %g3, 0
	fadd	%f3, %f3, %f4
	fadd	%f2, %f3, %f2
	fmul	%f3, %f0, %f0
	fmul	%f3, %f3, %f1
	fdiv	%f2, %f3, %f2
	fsub	%f0, %f0, %f4
	jmp	atan_sub.435
fjge_else.615:
	fmov	%f0, %f2
	return
atan.221:
	fst	%f0, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	fabs.217
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	setL %g3, l.477
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.616
	fld	%f0, %g1, 0
	fmov	%f2, %f0
	jmp	fjge_cont.617
fjge_else.616:
	fld	%f0, %g1, 0
	fdiv	%f2, %f1, %f0
fjge_cont.617:
	fjlt	%f1, %f0, fjge_else.618
	setL %g3, l.480
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.620
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	fjge_cont.621
fjge_else.620:
	mvhi	%g3, 65535
	mvlo	%g3, -1
fjge_cont.621:
	jmp	fjge_cont.619
fjge_else.618:
	mvhi	%g3, 0
	mvlo	%g3, 1
fjge_cont.619:
	setL %g4, l.471
	fld	%f0, %g4, 0
	fmul	%f3, %f2, %f2
	setL %g4, l.483
	fld	%f4, %g4, 0
	st	%g3, %g1, 4
	fst	%f2, %g1, 8
	fst	%f1, %g1, 12
	fmov	%f2, %f0
	fmov	%f1, %f3
	fmov	%f0, %f4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	atan_sub.435
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 12
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 8
	fdiv	%f0, %f1, %f0
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 4
	jlt	%g3, %g4, jle_else.622
	jlt	%g4, %g3, jle_else.623
	return
jle_else.623:
	setL %g3, l.487
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	return
jle_else.622:
	setL %g3, l.485
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	return
tan_sub.410:
	setL %g3, l.489
	fld	%f3, %g3, 0
	fjlt	%f0, %f3, fjge_else.624
	fsub	%f2, %f0, %f2
	fdiv	%f2, %f1, %f2
	setL %g3, l.475
	fld	%f3, %g3, 0
	fsub	%f0, %f0, %f3
	jmp	tan_sub.410
fjge_else.624:
	fmov	%f0, %f2
	return
tan.228:
	setL %g3, l.471
	fld	%f2, %g3, 0
	fmul	%f1, %f0, %f0
	setL %g3, l.493
	fld	%f3, %g3, 0
	fst	%f0, %g1, 0
	fmov	%f0, %f3
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	tan_sub.410
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	setL %g3, l.477
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	fld	%f1, %g1, 0
	fdiv	%f0, %f1, %f0
	return
tmp.389:
	fld	%f1, %g29, -8
	fjlt	%f1, %f0, fjge_else.625
	setL %g3, l.471
	fld	%f2, %g3, 0
	fjlt	%f0, %f2, fjge_else.626
	return
fjge_else.626:
	fadd	%f0, %f0, %f1
	ld	%g28, %g29, 0
	b	%g28
fjge_else.625:
	fsub	%f0, %f0, %f1
	ld	%g28, %g29, 0
	b	%g28
sin.230:
	fld	%f1, %g29, -24
	fld	%f2, %g29, -16
	fld	%f3, %g29, -8
	mov	%g3, %g2
	addi	%g2, %g2, 16
	setL %g4, tmp.389
	st	%g4, %g3, 0
	fst	%f2, %g3, -8
	fst	%f0, %g1, 0
	fst	%f1, %g1, 4
	fst	%f2, %g1, 8
	fst	%f3, %g1, 12
	st	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fabs.217
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
	fjlt	%f1, %f0, fjge_else.627
	fmov	%f2, %f0
	jmp	fjge_cont.628
fjge_else.627:
	fld	%f2, %g1, 8
	fsub	%f2, %f2, %f0
fjge_cont.628:
	fld	%f3, %g1, 4
	fjlt	%f3, %f2, fjge_else.629
	jmp	fjge_cont.630
fjge_else.629:
	fsub	%f2, %f1, %f2
fjge_cont.630:
	setL %g3, l.473
	fld	%f3, %g3, 0
	fmul	%f2, %f2, %f3
	fst	%f0, %g1, 20
	fmov	%f0, %f2
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	tan.228
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	setL %g3, l.471
	fld	%f1, %g3, 0
	fld	%f2, %g1, 0
	fjlt	%f1, %f2, fjge_else.631
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	fjge_cont.632
fjge_else.631:
	mvhi	%g3, 0
	mvlo	%g3, 1
fjge_cont.632:
	fld	%f1, %g1, 12
	fld	%f2, %g1, 20
	fjlt	%f1, %f2, fjge_else.633
	jmp	fjge_cont.634
fjge_else.633:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.635
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.636
jeq_else.635:
	mov	%g3, %g4
jeq_cont.636:
fjge_cont.634:
	fmul	%f1, %f0, %f0
	setL %g4, l.477
	fld	%f2, %g4, 0
	fadd	%f1, %f2, %f1
	setL %g4, l.475
	fld	%f2, %g4, 0
	fmul	%f0, %f2, %f0
	fdiv	%f0, %f0, %f1
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.637
	jmp	fneg.219
jeq_else.637:
	return
cos.232:
	ld	%g29, %g29, -4
	setL %g3, l.504
	fld	%f1, %g3, 0
	fsub	%f0, %f1, %f0
	ld	%g28, %g29, 0
	b	%g28
min_caml_start:
	setL %g3, l.477
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
	setL %g3, l.480
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
	setL %g3, l.485
	fld	%f0, %g3, 0
	setL %g3, l.509
	fld	%f1, %g3, 0
	setL %g3, l.511
	fld	%f2, %g3, 0
	mov	%g29, %g2
	addi	%g2, %g2, 32
	setL %g3, sin.230
	st	%g3, %g29, 0
	fst	%f0, %g29, -24
	fst	%f1, %g29, -16
	fst	%f2, %g29, -8
	mov	%g3, %g2
	addi	%g2, %g2, 8
	setL %g4, cos.232
	st	%g4, %g3, 0
	st	%g29, %g3, -4
	setL %g4, l.471
	fld	%f3, %g4, 0
	fst	%f3, %g1, 0
	st	%g3, %g1, 4
	fst	%f1, %g1, 8
	fst	%f2, %g1, 12
	fst	%f0, %g1, 16
	st	%g29, %g1, 20
	fmov	%f0, %f3
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 28
	st	%g3, %g1, 32
	ld	%g3, %g1, 28
	output	%g3
	ld	%g3, %g1, 32
	setL %g3, l.514
	fld	%f0, %g3, 0
	ld	%g29, %g1, 20
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 28
	st	%g3, %g1, 32
	ld	%g3, %g1, 28
	output	%g3
	ld	%g3, %g1, 32
	setL %g3, l.516
	fld	%f0, %g3, 0
	ld	%g29, %g1, 20
	fst	%f0, %g1, 28
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fst	%f0, %g1, 36
	st	%g3, %g1, 40
	ld	%g3, %g1, 36
	output	%g3
	ld	%g3, %g1, 40
	setL %g3, l.518
	fld	%f0, %g3, 0
	ld	%g29, %g1, 20
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fst	%f0, %g1, 36
	st	%g3, %g1, 40
	ld	%g3, %g1, 36
	output	%g3
	ld	%g3, %g1, 40
	fld	%f0, %g1, 16
	ld	%g29, %g1, 20
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fst	%f0, %g1, 36
	st	%g3, %g1, 40
	ld	%g3, %g1, 36
	output	%g3
	ld	%g3, %g1, 40
	setL %g3, l.520
	fld	%f0, %g3, 0
	ld	%g29, %g1, 20
	fst	%f0, %g1, 36
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fst	%f0, %g1, 44
	st	%g3, %g1, 48
	ld	%g3, %g1, 44
	output	%g3
	ld	%g3, %g1, 48
	setL %g3, l.522
	fld	%f0, %g3, 0
	ld	%g29, %g1, 20
	fst	%f0, %g1, 40
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fst	%f0, %g1, 44
	st	%g3, %g1, 48
	ld	%g3, %g1, 44
	output	%g3
	ld	%g3, %g1, 48
	setL %g3, l.524
	fld	%f0, %g3, 0
	ld	%g29, %g1, 20
	fst	%f0, %g1, 44
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fst	%f0, %g1, 52
	st	%g3, %g1, 56
	ld	%g3, %g1, 52
	output	%g3
	ld	%g3, %g1, 56
	fld	%f0, %g1, 12
	ld	%g29, %g1, 20
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fst	%f0, %g1, 52
	st	%g3, %g1, 56
	ld	%g3, %g1, 52
	output	%g3
	ld	%g3, %g1, 56
	setL %g3, l.526
	fld	%f0, %g3, 0
	ld	%g29, %g1, 20
	fst	%f0, %g1, 48
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fst	%f0, %g1, 52
	st	%g3, %g1, 56
	ld	%g3, %g1, 52
	output	%g3
	ld	%g3, %g1, 56
	setL %g3, l.528
	fld	%f0, %g3, 0
	ld	%g29, %g1, 20
	fst	%f0, %g1, 52
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fst	%f0, %g1, 60
	st	%g3, %g1, 64
	ld	%g3, %g1, 60
	output	%g3
	ld	%g3, %g1, 64
	setL %g3, l.530
	fld	%f0, %g3, 0
	ld	%g29, %g1, 20
	fst	%f0, %g1, 56
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fst	%f0, %g1, 60
	st	%g3, %g1, 64
	ld	%g3, %g1, 60
	output	%g3
	ld	%g3, %g1, 64
	setL %g3, l.532
	fld	%f0, %g3, 0
	ld	%g29, %g1, 20
	fst	%f0, %g1, 60
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fst	%f0, %g1, 68
	st	%g3, %g1, 72
	ld	%g3, %g1, 68
	output	%g3
	ld	%g3, %g1, 72
	setL %g3, l.534
	fld	%f0, %g3, 0
	ld	%g29, %g1, 20
	fst	%f0, %g1, 64
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fst	%f0, %g1, 68
	st	%g3, %g1, 72
	ld	%g3, %g1, 68
	output	%g3
	ld	%g3, %g1, 72
	setL %g3, l.536
	fld	%f0, %g3, 0
	ld	%g29, %g1, 20
	fst	%f0, %g1, 68
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	setL %g3, l.538
	fld	%f0, %g3, 0
	ld	%g29, %g1, 20
	fst	%f0, %g1, 72
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 8
	ld	%g29, %g1, 20
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 0
	ld	%g29, %g1, 4
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 24
	ld	%g29, %g1, 4
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 28
	ld	%g29, %g1, 4
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 32
	ld	%g29, %g1, 4
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 16
	ld	%g29, %g1, 4
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 36
	ld	%g29, %g1, 4
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 40
	ld	%g29, %g1, 4
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 44
	ld	%g29, %g1, 4
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 12
	ld	%g29, %g1, 4
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 48
	ld	%g29, %g1, 4
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 52
	ld	%g29, %g1, 4
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 56
	ld	%g29, %g1, 4
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 60
	ld	%g29, %g1, 4
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 64
	ld	%g29, %g1, 4
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 68
	ld	%g29, %g1, 4
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 72
	ld	%g29, %g1, 4
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	fld	%f0, %g1, 8
	ld	%g29, %g1, 4
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fst	%f0, %g1, 76
	st	%g3, %g1, 80
	ld	%g3, %g1, 76
	output	%g3
	ld	%g3, %g1, 80
	halt
