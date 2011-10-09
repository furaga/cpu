.init_heap_size	1056
l.533:	! 4.712389
	.long	0x4096cbe3
l.530:	! 0.607253
	.long	0x3f1b74e5
l.528:	! 1.570796
	.long	0x3fc90fda
l.526:	! 6.283185
	.long	0x40c90fda
l.524:	! 3.141593
	.long	0x40490fda
l.521:	! 0.000000
	.long	0x337ffff7
l.518:	! 0.000000
	.long	0x33fffff7
l.515:	! 0.000000
	.long	0x347ffff7
l.512:	! 0.000000
	.long	0x34fffff7
l.509:	! 0.000001
	.long	0x357ffff7
l.506:	! 0.000002
	.long	0x35fffff7
l.503:	! 0.000004
	.long	0x367ffff7
l.500:	! 0.000008
	.long	0x36fffff7
l.497:	! 0.000015
	.long	0x377ffff7
l.494:	! 0.000031
	.long	0x37fffff7
l.491:	! 0.000061
	.long	0x387ffff7
l.488:	! 0.000122
	.long	0x38fffff7
l.485:	! 0.000244
	.long	0x397ffff7
l.482:	! 0.000488
	.long	0x39fffff6
l.479:	! 0.000977
	.long	0x3a7ffffa
l.476:	! 0.001953
	.long	0x3affffea
l.473:	! 0.003906
	.long	0x3b7fffaa
l.470:	! 0.007812
	.long	0x3bfffeaa
l.467:	! 0.015624
	.long	0x3c7ffaaa
l.464:	! 0.031240
	.long	0x3cffeaa5
l.461:	! 0.062419
	.long	0x3d7faad5
l.458:	! 0.124355
	.long	0x3dfeadcc
l.455:	! 0.244979
	.long	0x3e7adba7
l.452:	! 0.463648
	.long	0x3eed6338
l.449:	! 0.785398
	.long	0x3f490fda
l.440:	! 1.000000
	.long	0x3f800000
l.437:	! 0.000000
	.long	0x0
l.432:	! 0.500000
	.long	0x3f000000
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

cordic_rec.326:
	ld	%g4, %g29, -20
	ld	%g5, %g29, -16
	fld	%f4, %g29, -8
	jne	%g3, %g4, jeq_else.554
	fmov	%f0, %f1
	return
jeq_else.554:
	fjlt	%f2, %f4, fjge_else.555
	addi	%g4, %g3, 1
	fmul	%f4, %f3, %f1
	fadd	%f4, %f0, %f4
	fmul	%f0, %f3, %f0
	fsub	%f1, %f1, %f0
	slli	%g3, %g3, 2
	sub	%g5, %g5, %g3
	fld	%f0, %g5, 0
	fsub	%f2, %f2, %f0
	setL %g3, l.432
	fld	%f0, %g3, 0
	fmul	%f3, %f3, %f0
	mov	%g3, %g4
	fmov	%f0, %f4
	ld	%g28, %g29, 0
	b	%g28
fjge_else.555:
	addi	%g4, %g3, 1
	fmul	%f4, %f3, %f1
	fsub	%f4, %f0, %f4
	fmul	%f0, %f3, %f0
	fadd	%f1, %f1, %f0
	slli	%g3, %g3, 2
	sub	%g5, %g5, %g3
	fld	%f0, %g5, 0
	fadd	%f2, %f2, %f0
	setL %g3, l.432
	fld	%f0, %g3, 0
	fmul	%f3, %f3, %f0
	mov	%g3, %g4
	fmov	%f0, %f4
	ld	%g28, %g29, 0
	b	%g28
cordic_sin.230:
	fld	%f1, %g29, -16
	ld	%g3, %g29, -8
	ld	%g4, %g29, -4
	mov	%g29, %g2
	addi	%g2, %g2, 24
	setL %g5, cordic_rec.326
	st	%g5, %g29, 0
	st	%g3, %g29, -20
	st	%g4, %g29, -16
	fst	%f0, %g29, -8
	mvhi	%g3, 0
	mvlo	%g3, 0
	setL %g4, l.437
	fld	%f0, %g4, 0
	setL %g4, l.437
	fld	%f2, %g4, 0
	setL %g4, l.440
	fld	%f3, %g4, 0
	fmov	%f31, %f1
	fmov	%f1, %f0
	fmov	%f0, %f31
	ld	%g28, %g29, 0
	b	%g28
sin.236:
	fld	%f1, %g29, -24
	fld	%f2, %g29, -16
	fld	%f3, %g29, -8
	ld	%g3, %g29, -4
	setL %g4, l.437
	fld	%f4, %g4, 0
	fjlt	%f0, %f4, fjge_else.556
	fjlt	%f0, %f1, fjge_else.557
	fjlt	%f0, %f3, fjge_else.558
	fjlt	%f0, %f2, fjge_else.559
	fsub	%f0, %f0, %f2
	ld	%g28, %g29, 0
	b	%g28
fjge_else.559:
	fsub	%f0, %f2, %f0
	st	%g31, %g1, 4
	ld	%g28, %g29, 0
	subi	%g1, %g1, 8
	callR	%g28
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fneg	%f0, %f0
	return
fjge_else.558:
	fsub	%f0, %f3, %f0
	mov	%g29, %g3
	ld	%g28, %g29, 0
	b	%g28
fjge_else.557:
	mov	%g29, %g3
	ld	%g28, %g29, 0
	b	%g28
fjge_else.556:
	fneg	%f0, %f0
	st	%g31, %g1, 4
	ld	%g28, %g29, 0
	subi	%g1, %g1, 8
	callR	%g28
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fneg	%f0, %f0
	return
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 25
	setL %g4, l.437
	fld	%f0, %g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	setL %g4, l.449
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	setL %g4, l.452
	fld	%f0, %g4, 0
	fst	%f0, %g3, -4
	setL %g4, l.455
	fld	%f0, %g4, 0
	fst	%f0, %g3, -8
	setL %g4, l.458
	fld	%f0, %g4, 0
	fst	%f0, %g3, -12
	setL %g4, l.461
	fld	%f0, %g4, 0
	fst	%f0, %g3, -16
	setL %g4, l.464
	fld	%f0, %g4, 0
	fst	%f0, %g3, -20
	setL %g4, l.467
	fld	%f0, %g4, 0
	fst	%f0, %g3, -24
	setL %g4, l.470
	fld	%f0, %g4, 0
	fst	%f0, %g3, -28
	setL %g4, l.473
	fld	%f0, %g4, 0
	fst	%f0, %g3, -32
	setL %g4, l.476
	fld	%f0, %g4, 0
	fst	%f0, %g3, -36
	setL %g4, l.479
	fld	%f0, %g4, 0
	fst	%f0, %g3, -40
	setL %g4, l.482
	fld	%f0, %g4, 0
	fst	%f0, %g3, -44
	setL %g4, l.485
	fld	%f0, %g4, 0
	fst	%f0, %g3, -48
	setL %g4, l.488
	fld	%f0, %g4, 0
	fst	%f0, %g3, -52
	setL %g4, l.491
	fld	%f0, %g4, 0
	fst	%f0, %g3, -56
	setL %g4, l.494
	fld	%f0, %g4, 0
	fst	%f0, %g3, -60
	setL %g4, l.497
	fld	%f0, %g4, 0
	fst	%f0, %g3, -64
	setL %g4, l.500
	fld	%f0, %g4, 0
	fst	%f0, %g3, -68
	setL %g4, l.503
	fld	%f0, %g4, 0
	fst	%f0, %g3, -72
	setL %g4, l.506
	fld	%f0, %g4, 0
	fst	%f0, %g3, -76
	setL %g4, l.509
	fld	%f0, %g4, 0
	fst	%f0, %g3, -80
	setL %g4, l.512
	fld	%f0, %g4, 0
	fst	%f0, %g3, -84
	setL %g4, l.515
	fld	%f0, %g4, 0
	fst	%f0, %g3, -88
	setL %g4, l.518
	fld	%f0, %g4, 0
	fst	%f0, %g3, -92
	setL %g4, l.521
	fld	%f0, %g4, 0
	fst	%f0, %g3, -96
	mvhi	%g4, 0
	mvlo	%g4, 25
	setL %g5, l.524
	fld	%f0, %g5, 0
	setL %g5, l.526
	fld	%f1, %g5, 0
	setL %g5, l.528
	fld	%f2, %g5, 0
	setL %g5, l.530
	fld	%f3, %g5, 0
	mov	%g5, %g2
	addi	%g2, %g2, 24
	setL %g6, cordic_sin.230
	st	%g6, %g5, 0
	fst	%f3, %g5, -16
	st	%g4, %g5, -8
	st	%g3, %g5, -4
	mov	%g29, %g2
	addi	%g2, %g2, 32
	setL %g3, sin.236
	st	%g3, %g29, 0
	fst	%f2, %g29, -24
	fst	%f1, %g29, -16
	fst	%f0, %g29, -8
	st	%g5, %g29, -4
	setL %g3, l.437
	fld	%f3, %g3, 0
	fst	%f1, %g1, 0
	fst	%f0, %g1, 8
	fst	%f2, %g1, 16
	st	%g29, %g1, 24
	fmov	%f0, %f3
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 28
	st	%g3, %g1, 24
	ld	%g3, %g1, 28
	output	%g3
	ld	%g3, %g1, 24
	fld	%f0, %g1, 16
	ld	%g29, %g1, 24
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 28
	st	%g3, %g1, 24
	ld	%g3, %g1, 28
	output	%g3
	ld	%g3, %g1, 24
	fld	%f0, %g1, 8
	ld	%g29, %g1, 24
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 28
	st	%g3, %g1, 24
	ld	%g3, %g1, 28
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.533
	fld	%f0, %g3, 0
	ld	%g29, %g1, 24
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 28
	st	%g3, %g1, 24
	ld	%g3, %g1, 28
	output	%g3
	ld	%g3, %g1, 24
	fld	%f0, %g1, 0
	ld	%g29, %g1, 24
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 28
	st	%g3, %g1, 24
	ld	%g3, %g1, 28
	output	%g3
	ld	%g3, %g1, 24
	halt
