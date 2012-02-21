.init_heap_size	1952
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
l.38137:	! 150.000000
	.long	0x43160000
l.38133:	! -150.000000
	.long	0xc3160000
l.37685:	! -2.000000
	.long	0xc0000000
l.37663:	! 0.003906
	.long	0x3b800000
l.37619:	! 20.000000
	.long	0x41a00000
l.37617:	! 0.050000
	.long	0x3d4cccc4
l.37597:	! 0.250000
	.long	0x3e800000
l.37578:	! 10.000000
	.long	0x41200000
l.37567:	! 0.300000
	.long	0x3e999999
l.37563:	! 0.150000
	.long	0x3e199999
l.37528:	! 3.141593
	.long	0x40490fda
l.37526:	! 30.000000
	.long	0x41f00000
l.37524:	! -1.570796
	.long	0xbfc90fda
l.37519:	! 4.000000
	.long	0x40800000
l.37515:	! 16.000000
	.long	0x41800000
l.37513:	! 11.000000
	.long	0x41300000
l.37511:	! 25.000000
	.long	0x41c80000
l.37509:	! 13.000000
	.long	0x41500000
l.37507:	! 36.000000
	.long	0x42100000
l.37504:	! 49.000000
	.long	0x42440000
l.37502:	! 17.000000
	.long	0x41880000
l.37500:	! 64.000000
	.long	0x42800000
l.37498:	! 19.000000
	.long	0x41980000
l.37496:	! 81.000000
	.long	0x42a20000
l.37494:	! 21.000000
	.long	0x41a80000
l.37492:	! 100.000000
	.long	0x42c80000
l.37490:	! 23.000000
	.long	0x41b80000
l.37488:	! 121.000000
	.long	0x42f20000
l.37484:	! 15.000000
	.long	0x41700000
l.37482:	! 0.000100
	.long	0x38d1b70f
l.37312:	! 100000000.000000
	.long	0x4cbebc20
l.36577:	! -0.100000
	.long	0xbdccccc4
l.36391:	! 0.010000
	.long	0x3c23d70a
l.36389:	! -0.200000
	.long	0xbe4cccc4
l.35940:	! -1.000000
	.long	0xbf800000
l.35626:	! 0.100000
	.long	0x3dccccc4
l.35624:	! 0.900000
	.long	0x3f66665e
l.35622:	! 0.200000
	.long	0x3e4cccc4
l.35562:	! -200.000000
	.long	0xc3480000
l.35559:	! 200.000000
	.long	0x43480000
l.35557:	! 3.000000
	.long	0x40400000
l.35555:	! 5.000000
	.long	0x40a00000
l.35553:	! 9.000000
	.long	0x41100000
l.35551:	! 7.000000
	.long	0x40e00000
l.35549:	! 1.000000
	.long	0x3f800000
l.35547:	! 0.017453
	.long	0x3c8efa2d
l.35442:	! 128.000000
	.long	0x43000000
l.35419:	! 1000000000.000000
	.long	0x4e6e6b28
l.35415:	! 255.000000
	.long	0x437f0000
l.35401:	! 0.000000
	.long	0x0
l.35399:	! 1.570796
	.long	0x3fc90fda
l.35397:	! 0.500000
	.long	0x3f000000
l.35395:	! 6.283185
	.long	0x40c90fda
l.35393:	! 2.000000
	.long	0x40000000
l.35391:	! 3.141593
	.long	0x40490fda
	jmp	min_caml_start

!#####################################################################
!
! 		↓　ここから lib_asm.s
!
!#####################################################################

! * create_array
min_caml_create_array:
	slli %g3, %g3, 2
	add %g5, %g3, %g2
	mov %g3, %g2
CREATE_ARRAY_LOOP:
	jlt %g5, %g2, CREATE_ARRAY_END
	jeq %g5, %g2, CREATE_ARRAY_END
	sti %g4, %g2, 0
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
	jeq %g4, %g2, CREATE_FLOAT_ARRAY_END
	fsti %f0, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_FLOAT_ARRAY_LOOP
CREATE_FLOAT_ARRAY_END:
	return

! * floor		%f0 + MAGICF - MAGICF
min_caml_floor:
	fmov %f1, %f0
	! %f4 = 0.0
	setL %g3, FLOAT_ZERO
	fldi %f4, %g3, 0
	fjlt %f4, %f0, FLOOR_POSITIVE	! if (%f4 <= %f0) goto FLOOR_PISITIVE
	fjeq %f4, %f0, FLOOR_POSITIVE
FLOOR_NEGATIVE:
	fneg %f0, %f0
	setL %g3, FLOAT_MAGICF
	! %f2 = FLOAT_MAGICF
	fldi %f2, %g3, 0
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
	fldi %f3, %g3, 0
	fadd %f0, %f0, %f3
	fsub %f0, %f0, %f2
	fneg %f0, %f0
	return
FLOOR_POSITIVE:
	setL %g3, FLOAT_MAGICF
	fldi %f2, %g3, 0
	fjlt %f0, %f2, FLOOR_POSITIVE_MAIN
	fjeq %f0, %f2, FLOOR_POSITIVE_MAIN
	return
FLOOR_POSITIVE_MAIN:
	fmov %f1, %f0
	fadd %f0, %f0, %f2
	fsti %f0, %g1, 0
	ldi %g4, %g1, 0
	fsub %f0, %f0, %f2
	fsti %f0, %g1, 0
	ldi %g4, %g1, 0
	fjlt %f0, %f1, FLOOR_RET
	fjeq %f0, %f1, FLOOR_RET
	setL %g3, FLOAT_ONE
	fldi %f3, %g3, 0
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
	fldi %f1, %g5, 0
	setL %g5, FLOAT_MAGICFHX
	ldi %g4, %g5, 0
	setL %g5, FLOAT_MAGICI
	ldi %g5, %g5, 0
	jlt %g5, %g3, ITOF_BIG
	jeq %g5, %g3, ITOF_BIG
	add %g3, %g3, %g4
	sti %g3, %g1, 0
	fldi %f0, %g1, 0
	fsub %f0, %f0, %f1
	return
ITOF_BIG:
	setL %g4, FLOAT_ZERO
	fldi %f2, %g4, 0
ITOF_LOOP:
	sub %g3, %g3, %g5
	fadd %f2, %f2, %f1
	jlt %g5, %g3, ITOF_LOOP
	jeq %g5, %g3, ITOF_LOOP
	add %g3, %g3, %g4
	sti %g3, %g1, 0
	fldi %f0, %g1, 0
	fsub %f0, %f0, %f1
	fadd %f0, %f0, %f2
	return

! * int_of_float
min_caml_int_of_float:
	! %f1 <= 0.0
	setL %g3, FLOAT_ZERO
	fldi %f1, %g3, 0
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
	fldi %f2, %g4, 0
	setL %g4, FLOAT_MAGICFHX
	ldi %g4, %g4, 0
	fjlt %f2, %f0, FTOI_BIG		! if (MAGICF <= %f0) goto FTOI_BIG
	fjeq %f2, %f0, FTOI_BIG
	fadd %f0, %f0, %f2
	fsti %f0, %g1, 0
	ldi %g3, %g1, 0
	sub %g3, %g3, %g4
	return
FTOI_BIG:
	setL %g5, FLOAT_MAGICI
	ldi %g5, %g5, 0
	mov %g3, %g0
FTOI_LOOP:
	fsub %f0, %f0, %f2
	add %g3, %g3, %g5
	fjlt %f2, %f0, FTOI_LOOP
	fjeq %f2, %f0, FTOI_LOOP
	fadd %f0, %f0, %f2
	fsti %f0, %g1, 0
	ldi %g5, %g1, 0
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
min_caml_start:
	mov	%g31, %g1
	subi	%g1, %g1, 2368
	addi	%g28, %g0, 1
	addi	%g29, %g0, -1
	setL %g27, l.35401
	fldi	%f16, %g27, 0
	setL %g27, l.35549
	fldi	%f17, %g27, 0
	setL %g27, l.38137
	fldi	%f18, %g27, 0
	setL %g27, l.38133
	fldi	%f19, %g27, 0
	setL %g27, l.35940
	fldi	%f20, %g27, 0
	setL %g27, l.35397
	fldi	%f21, %g27, 0
	setL %g27, l.35399
	fldi	%f22, %g27, 0
	setL %g27, l.35557
	fldi	%f23, %g27, 0
	setL %g27, l.35555
	fldi	%f24, %g27, 0
	setL %g27, l.35553
	fldi	%f25, %g27, 0
	setL %g27, l.35551
	fldi	%f26, %g27, 0
	setL %g27, l.35415
	fldi	%f27, %g27, 0
	setL %g27, l.37484
	fldi	%f28, %g27, 0
	setL %g27, l.35395
	fldi	%f29, %g27, 0
	setL %g27, l.37528
	fldi	%f30, %g27, 0
	setL %g27, l.37524
	fldi	%f31, %g27, 0
	setL %g3, l.35391
	fldi	%f4, %g3, 0
	setL %g3, l.35393
	fldi	%f10, %g3, 0
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 4
	subi	%g1, %g1, 4
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 8
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 12
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 16
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 1
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 20
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 24
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 28
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 32
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g4, %g3
	ldi	%g2, %g31, 2364
	addi	%g6, %g0, 60
	addi	%g10, %g0, 0
	addi	%g9, %g0, 0
	addi	%g8, %g0, 0
	addi	%g7, %g0, 0
	addi	%g5, %g0, 0
	mov	%g3, %g2
	addi	%g2, %g2, 44
	sti	%g4, %g3, -40
	sti	%g4, %g3, -36
	sti	%g4, %g3, -32
	sti	%g4, %g3, -28
	sti	%g5, %g3, -24
	sti	%g4, %g3, -20
	sti	%g4, %g3, -16
	sti	%g7, %g3, -12
	sti	%g8, %g3, -8
	sti	%g9, %g3, -4
	sti	%g10, %g3, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 272
	mov	%g4, %g3
	mov	%g3, %g6
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 284
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 296
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 308
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 312
	fmov	%f0, %f27
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g6, %g0, 50
	addi	%g3, %g0, 1
	addi	%g4, %g0, -1
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 512
	mov	%g3, %g6
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g6, %g0, 1
	addi	%g3, %g0, 1
	ldi	%g4, %g31, 512
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 516
	mov	%g3, %g6
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 520
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 524
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	setL %g4, l.35419
	fldi	%f0, %g4, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 528
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 540
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 544
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 556
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 568
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 580
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 592
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 2
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 600
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 2
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 608
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 612
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 624
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 636
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 648
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 660
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 672
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 684
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 688
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 692
	subi	%g4, %g31, 688
	call	min_caml_create_array
	mov	%g4, %g3
	ldi	%g2, %g31, 2364
	addi	%g6, %g0, 0
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g4, %g3, -4
	sti	%g7, %g3, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 696
	mov	%g4, %g3
	mov	%g3, %g6
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 716
	subi	%g4, %g31, 696
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 720
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 732
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g6, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 60
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 972
	subi	%g4, %g31, 720
	call	min_caml_create_array
	mov	%g4, %g3
	ldi	%g2, %g31, 2364
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 980
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g4, %g3, -4
	sti	%g6, %g3, 0
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 984
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g6, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 988
	subi	%g4, %g31, 984
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 996
	mov	%g4, %g2
	addi	%g2, %g2, 8
	sti	%g3, %g4, -4
	sti	%g6, %g4, 0
	ldi	%g2, %g31, 2364
	addi	%g6, %g0, 180
	addi	%g5, %g0, 0
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fsti	%f16, %g3, -8
	sti	%g4, %g3, -4
	sti	%g5, %g3, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1716
	mov	%g4, %g3
	mov	%g3, %g6
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1720
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 128
	addi	%g4, %g0, 128
	sti	%g3, %g31, 600
	sti	%g4, %g31, 596
	addi	%g4, %g0, 64
	sti	%g4, %g31, 608
	addi	%g4, %g0, 64
	sti	%g4, %g31, 604
	setL %g4, l.35442
	fldi	%f3, %g4, 0
	call	min_caml_float_of_int
	fdiv	%f0, %f3, %f0
	fsti	%f0, %g31, 612
	ldi	%g12, %g31, 600
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1732
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g11, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1744
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1764
	subi	%g4, %g31, 1744
	call	min_caml_create_array
	mov	%g10, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1760
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1756
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1752
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1748
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1784
	call	min_caml_create_array
	mov	%g9, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1804
	call	min_caml_create_array
	mov	%g8, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1816
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1836
	subi	%g4, %g31, 1816
	call	min_caml_create_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1832
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1828
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1824
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1820
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1848
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1868
	subi	%g4, %g31, 1848
	call	min_caml_create_array
	mov	%g6, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1864
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1860
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1856
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1852
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1872
	call	min_caml_create_array
	mov	%g13, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1884
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1904
	subi	%g4, %g31, 1884
	call	min_caml_create_array
	mov	%g5, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1900
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1896
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1892
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1888
	mov	%g3, %g2
	addi	%g2, %g2, 32
	sti	%g5, %g3, -28
	sti	%g13, %g3, -24
	sti	%g6, %g3, -20
	sti	%g7, %g3, -16
	sti	%g8, %g3, -12
	sti	%g9, %g3, -8
	sti	%g10, %g3, -4
	sti	%g11, %g3, 0
	mov	%g4, %g3
	mov	%g3, %g12
	call	min_caml_create_array
	mov	%g10, %g3
	sti	%g10, %g31, 1908
	ldi	%g3, %g31, 600
	subi	%g9, %g3, 2
	call	init_line_elements.2962
	mov	%g17, %g3
	sti	%g17, %g31, 1912
	ldi	%g12, %g31, 600
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1924
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g11, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1936
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1956
	subi	%g4, %g31, 1936
	call	min_caml_create_array
	mov	%g10, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1952
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1948
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1944
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1940
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1976
	call	min_caml_create_array
	mov	%g9, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1996
	call	min_caml_create_array
	mov	%g8, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2008
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2028
	subi	%g4, %g31, 2008
	call	min_caml_create_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2024
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2020
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2016
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2012
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2040
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2060
	subi	%g4, %g31, 2040
	call	min_caml_create_array
	mov	%g6, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2056
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2052
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2048
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2044
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2064
	call	min_caml_create_array
	mov	%g13, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2076
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2096
	subi	%g4, %g31, 2076
	call	min_caml_create_array
	mov	%g5, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2092
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2088
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2084
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2080
	mov	%g3, %g2
	addi	%g2, %g2, 32
	sti	%g5, %g3, -28
	sti	%g13, %g3, -24
	sti	%g6, %g3, -20
	sti	%g7, %g3, -16
	sti	%g8, %g3, -12
	sti	%g9, %g3, -8
	sti	%g10, %g3, -4
	sti	%g11, %g3, 0
	mov	%g4, %g3
	mov	%g3, %g12
	call	min_caml_create_array
	mov	%g10, %g3
	sti	%g10, %g31, 2100
	ldi	%g3, %g31, 600
	subi	%g9, %g3, 2
	call	init_line_elements.2962
	mov	%g16, %g3
	sti	%g16, %g31, 2104
	ldi	%g12, %g31, 600
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2116
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g11, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2128
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2148
	subi	%g4, %g31, 2128
	call	min_caml_create_array
	mov	%g10, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2144
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2140
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2136
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2132
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2168
	call	min_caml_create_array
	mov	%g9, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2188
	call	min_caml_create_array
	mov	%g8, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2200
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2220
	subi	%g4, %g31, 2200
	call	min_caml_create_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2216
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2212
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2208
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2204
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2232
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2252
	subi	%g4, %g31, 2232
	call	min_caml_create_array
	mov	%g6, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2248
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2244
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2240
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2236
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2256
	call	min_caml_create_array
	mov	%g13, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2268
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2288
	subi	%g4, %g31, 2268
	call	min_caml_create_array
	mov	%g5, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2284
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2280
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2276
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2272
	mov	%g3, %g2
	addi	%g2, %g2, 32
	sti	%g5, %g3, -28
	sti	%g13, %g3, -24
	sti	%g6, %g3, -20
	sti	%g7, %g3, -16
	sti	%g8, %g3, -12
	sti	%g9, %g3, -8
	sti	%g10, %g3, -4
	sti	%g11, %g3, 0
	mov	%g4, %g3
	mov	%g3, %g12
	call	min_caml_create_array
	mov	%g10, %g3
	sti	%g10, %g31, 2292
	ldi	%g3, %g31, 600
	subi	%g9, %g3, 2
	call	init_line_elements.2962
	addi	%g1, %g1, 4
	mov	%g15, %g3
	sti	%g15, %g31, 2296
	sti	%g17, %g1, 0
	sti	%g15, %g1, 4
	sti	%g16, %g1, 8
	fsti	%f10, %g1, 12
	fsti	%f4, %g1, 16
	inputf	%f0
	fsti	%f0, %g31, 284
	inputf	%f0
	fsti	%f0, %g31, 280
	inputf	%f0
	fsti	%f0, %g31, 276
	inputf	%f0
	setL %g3, l.35547
	fldi	%f7, %g3, 0
	fmul	%f3, %f0, %f7
	fsub	%f2, %f22, %f3
	fjlt	%f2, %f16, fjge_else.41474
	fmov	%f1, %f2
	jmp	fjge_cont.41475
fjge_else.41474:
	fneg	%f1, %f2
fjge_cont.41475:
	fjlt	%f29, %f1, fjge_else.41476
	fjlt	%f1, %f16, fjge_else.41478
	fmov	%f0, %f1
	jmp	fjge_cont.41479
fjge_else.41478:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41480
	fjlt	%f1, %f16, fjge_else.41482
	fmov	%f0, %f1
	jmp	fjge_cont.41483
fjge_else.41482:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41484
	fjlt	%f1, %f16, fjge_else.41486
	fmov	%f0, %f1
	jmp	fjge_cont.41487
fjge_else.41486:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2480
	addi	%g1, %g1, 24
fjge_cont.41487:
	jmp	fjge_cont.41485
fjge_else.41484:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2480
	addi	%g1, %g1, 24
fjge_cont.41485:
fjge_cont.41483:
	jmp	fjge_cont.41481
fjge_else.41480:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41488
	fjlt	%f1, %f16, fjge_else.41490
	fmov	%f0, %f1
	jmp	fjge_cont.41491
fjge_else.41490:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2480
	addi	%g1, %g1, 24
fjge_cont.41491:
	jmp	fjge_cont.41489
fjge_else.41488:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2480
	addi	%g1, %g1, 24
fjge_cont.41489:
fjge_cont.41481:
fjge_cont.41479:
	jmp	fjge_cont.41477
fjge_else.41476:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41492
	fjlt	%f1, %f16, fjge_else.41494
	fmov	%f0, %f1
	jmp	fjge_cont.41495
fjge_else.41494:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41496
	fjlt	%f1, %f16, fjge_else.41498
	fmov	%f0, %f1
	jmp	fjge_cont.41499
fjge_else.41498:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2480
	addi	%g1, %g1, 24
fjge_cont.41499:
	jmp	fjge_cont.41497
fjge_else.41496:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2480
	addi	%g1, %g1, 24
fjge_cont.41497:
fjge_cont.41495:
	jmp	fjge_cont.41493
fjge_else.41492:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41500
	fjlt	%f1, %f16, fjge_else.41502
	fmov	%f0, %f1
	jmp	fjge_cont.41503
fjge_else.41502:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2480
	addi	%g1, %g1, 24
fjge_cont.41503:
	jmp	fjge_cont.41501
fjge_else.41500:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2480
	addi	%g1, %g1, 24
fjge_cont.41501:
fjge_cont.41493:
fjge_cont.41477:
	fldi	%f4, %g1, 16
	fjlt	%f4, %f0, fjge_else.41504
	fjlt	%f16, %f2, fjge_else.41506
	addi	%g3, %g0, 0
	jmp	fjge_cont.41507
fjge_else.41506:
	addi	%g3, %g0, 1
fjge_cont.41507:
	jmp	fjge_cont.41505
fjge_else.41504:
	fjlt	%f16, %f2, fjge_else.41508
	addi	%g3, %g0, 1
	jmp	fjge_cont.41509
fjge_else.41508:
	addi	%g3, %g0, 0
fjge_cont.41509:
fjge_cont.41505:
	fjlt	%f4, %f0, fjge_else.41510
	fmov	%f1, %f0
	jmp	fjge_cont.41511
fjge_else.41510:
	fsub	%f1, %f29, %f0
fjge_cont.41511:
	fjlt	%f22, %f1, fjge_else.41512
	fmov	%f0, %f1
	jmp	fjge_cont.41513
fjge_else.41512:
	fsub	%f0, %f4, %f1
fjge_cont.41513:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fldi	%f10, %g1, 12
	fmul	%f1, %f10, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g3, %g0, jeq_else.41514
	fneg	%f6, %f0
	jmp	jeq_cont.41515
jeq_else.41514:
	fmov	%f6, %f0
jeq_cont.41515:
	fjlt	%f3, %f16, fjge_else.41516
	fmov	%f1, %f3
	jmp	fjge_cont.41517
fjge_else.41516:
	fneg	%f1, %f3
fjge_cont.41517:
	fjlt	%f29, %f1, fjge_else.41518
	fjlt	%f1, %f16, fjge_else.41520
	fmov	%f0, %f1
	jmp	fjge_cont.41521
fjge_else.41520:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41522
	fjlt	%f1, %f16, fjge_else.41524
	fmov	%f0, %f1
	jmp	fjge_cont.41525
fjge_else.41524:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41526
	fjlt	%f1, %f16, fjge_else.41528
	fmov	%f0, %f1
	jmp	fjge_cont.41529
fjge_else.41528:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2480
	addi	%g1, %g1, 24
fjge_cont.41529:
	jmp	fjge_cont.41527
fjge_else.41526:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2480
	addi	%g1, %g1, 24
fjge_cont.41527:
fjge_cont.41525:
	jmp	fjge_cont.41523
fjge_else.41522:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41530
	fjlt	%f1, %f16, fjge_else.41532
	fmov	%f0, %f1
	jmp	fjge_cont.41533
fjge_else.41532:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2480
	addi	%g1, %g1, 24
fjge_cont.41533:
	jmp	fjge_cont.41531
fjge_else.41530:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2480
	addi	%g1, %g1, 24
fjge_cont.41531:
fjge_cont.41523:
fjge_cont.41521:
	jmp	fjge_cont.41519
fjge_else.41518:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41534
	fjlt	%f1, %f16, fjge_else.41536
	fmov	%f0, %f1
	jmp	fjge_cont.41537
fjge_else.41536:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41538
	fjlt	%f1, %f16, fjge_else.41540
	fmov	%f0, %f1
	jmp	fjge_cont.41541
fjge_else.41540:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2480
	addi	%g1, %g1, 24
fjge_cont.41541:
	jmp	fjge_cont.41539
fjge_else.41538:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2480
	addi	%g1, %g1, 24
fjge_cont.41539:
fjge_cont.41537:
	jmp	fjge_cont.41535
fjge_else.41534:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41542
	fjlt	%f1, %f16, fjge_else.41544
	fmov	%f0, %f1
	jmp	fjge_cont.41545
fjge_else.41544:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2480
	addi	%g1, %g1, 24
fjge_cont.41545:
	jmp	fjge_cont.41543
fjge_else.41542:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2480
	addi	%g1, %g1, 24
fjge_cont.41543:
fjge_cont.41535:
fjge_cont.41519:
	fjlt	%f4, %f0, fjge_else.41546
	fjlt	%f16, %f3, fjge_else.41548
	addi	%g3, %g0, 0
	jmp	fjge_cont.41549
fjge_else.41548:
	addi	%g3, %g0, 1
fjge_cont.41549:
	jmp	fjge_cont.41547
fjge_else.41546:
	fjlt	%f16, %f3, fjge_else.41550
	addi	%g3, %g0, 1
	jmp	fjge_cont.41551
fjge_else.41550:
	addi	%g3, %g0, 0
fjge_cont.41551:
fjge_cont.41547:
	fjlt	%f4, %f0, fjge_else.41552
	fmov	%f1, %f0
	jmp	fjge_cont.41553
fjge_else.41552:
	fsub	%f1, %f29, %f0
fjge_cont.41553:
	fjlt	%f22, %f1, fjge_else.41554
	fmov	%f0, %f1
	jmp	fjge_cont.41555
fjge_else.41554:
	fsub	%f0, %f4, %f1
fjge_cont.41555:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f10, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g3, %g0, jeq_else.41556
	fneg	%f5, %f0
	jmp	jeq_cont.41557
jeq_else.41556:
	fmov	%f5, %f0
jeq_cont.41557:
	fsti	%f5, %g1, 20
	fsti	%f6, %g1, 24
	fsti	%f7, %g1, 28
	inputf	%f0
	fldi	%f7, %g1, 28
	fmul	%f3, %f0, %f7
	fsub	%f2, %f22, %f3
	fjlt	%f2, %f16, fjge_else.41558
	fmov	%f1, %f2
	jmp	fjge_cont.41559
fjge_else.41558:
	fneg	%f1, %f2
fjge_cont.41559:
	fjlt	%f29, %f1, fjge_else.41560
	fjlt	%f1, %f16, fjge_else.41562
	fmov	%f0, %f1
	jmp	fjge_cont.41563
fjge_else.41562:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41564
	fjlt	%f1, %f16, fjge_else.41566
	fmov	%f0, %f1
	jmp	fjge_cont.41567
fjge_else.41566:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41568
	fjlt	%f1, %f16, fjge_else.41570
	fmov	%f0, %f1
	jmp	fjge_cont.41571
fjge_else.41570:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41571:
	jmp	fjge_cont.41569
fjge_else.41568:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41569:
fjge_cont.41567:
	jmp	fjge_cont.41565
fjge_else.41564:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41572
	fjlt	%f1, %f16, fjge_else.41574
	fmov	%f0, %f1
	jmp	fjge_cont.41575
fjge_else.41574:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41575:
	jmp	fjge_cont.41573
fjge_else.41572:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41573:
fjge_cont.41565:
fjge_cont.41563:
	jmp	fjge_cont.41561
fjge_else.41560:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41576
	fjlt	%f1, %f16, fjge_else.41578
	fmov	%f0, %f1
	jmp	fjge_cont.41579
fjge_else.41578:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41580
	fjlt	%f1, %f16, fjge_else.41582
	fmov	%f0, %f1
	jmp	fjge_cont.41583
fjge_else.41582:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41583:
	jmp	fjge_cont.41581
fjge_else.41580:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41581:
fjge_cont.41579:
	jmp	fjge_cont.41577
fjge_else.41576:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41584
	fjlt	%f1, %f16, fjge_else.41586
	fmov	%f0, %f1
	jmp	fjge_cont.41587
fjge_else.41586:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41587:
	jmp	fjge_cont.41585
fjge_else.41584:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41585:
fjge_cont.41577:
fjge_cont.41561:
	fldi	%f4, %g1, 16
	fjlt	%f4, %f0, fjge_else.41588
	fjlt	%f16, %f2, fjge_else.41590
	addi	%g3, %g0, 0
	jmp	fjge_cont.41591
fjge_else.41590:
	addi	%g3, %g0, 1
fjge_cont.41591:
	jmp	fjge_cont.41589
fjge_else.41588:
	fjlt	%f16, %f2, fjge_else.41592
	addi	%g3, %g0, 1
	jmp	fjge_cont.41593
fjge_else.41592:
	addi	%g3, %g0, 0
fjge_cont.41593:
fjge_cont.41589:
	fjlt	%f4, %f0, fjge_else.41594
	fmov	%f1, %f0
	jmp	fjge_cont.41595
fjge_else.41594:
	fsub	%f1, %f29, %f0
fjge_cont.41595:
	fjlt	%f22, %f1, fjge_else.41596
	fmov	%f0, %f1
	jmp	fjge_cont.41597
fjge_else.41596:
	fsub	%f0, %f4, %f1
fjge_cont.41597:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fldi	%f10, %g1, 12
	fmul	%f1, %f10, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g3, %g0, jeq_else.41598
	fneg	%f2, %f0
	jmp	jeq_cont.41599
jeq_else.41598:
	fmov	%f2, %f0
jeq_cont.41599:
	fjlt	%f3, %f16, fjge_else.41600
	fmov	%f1, %f3
	jmp	fjge_cont.41601
fjge_else.41600:
	fneg	%f1, %f3
fjge_cont.41601:
	fjlt	%f29, %f1, fjge_else.41602
	fjlt	%f1, %f16, fjge_else.41604
	fmov	%f0, %f1
	jmp	fjge_cont.41605
fjge_else.41604:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41606
	fjlt	%f1, %f16, fjge_else.41608
	fmov	%f0, %f1
	jmp	fjge_cont.41609
fjge_else.41608:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41610
	fjlt	%f1, %f16, fjge_else.41612
	fmov	%f0, %f1
	jmp	fjge_cont.41613
fjge_else.41612:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41613:
	jmp	fjge_cont.41611
fjge_else.41610:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41611:
fjge_cont.41609:
	jmp	fjge_cont.41607
fjge_else.41606:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41614
	fjlt	%f1, %f16, fjge_else.41616
	fmov	%f0, %f1
	jmp	fjge_cont.41617
fjge_else.41616:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41617:
	jmp	fjge_cont.41615
fjge_else.41614:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41615:
fjge_cont.41607:
fjge_cont.41605:
	jmp	fjge_cont.41603
fjge_else.41602:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41618
	fjlt	%f1, %f16, fjge_else.41620
	fmov	%f0, %f1
	jmp	fjge_cont.41621
fjge_else.41620:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41622
	fjlt	%f1, %f16, fjge_else.41624
	fmov	%f0, %f1
	jmp	fjge_cont.41625
fjge_else.41624:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41625:
	jmp	fjge_cont.41623
fjge_else.41622:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41623:
fjge_cont.41621:
	jmp	fjge_cont.41619
fjge_else.41618:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41626
	fjlt	%f1, %f16, fjge_else.41628
	fmov	%f0, %f1
	jmp	fjge_cont.41629
fjge_else.41628:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41629:
	jmp	fjge_cont.41627
fjge_else.41626:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41627:
fjge_cont.41619:
fjge_cont.41603:
	fjlt	%f4, %f0, fjge_else.41630
	fjlt	%f16, %f3, fjge_else.41632
	addi	%g3, %g0, 0
	jmp	fjge_cont.41633
fjge_else.41632:
	addi	%g3, %g0, 1
fjge_cont.41633:
	jmp	fjge_cont.41631
fjge_else.41630:
	fjlt	%f16, %f3, fjge_else.41634
	addi	%g3, %g0, 1
	jmp	fjge_cont.41635
fjge_else.41634:
	addi	%g3, %g0, 0
fjge_cont.41635:
fjge_cont.41631:
	fjlt	%f4, %f0, fjge_else.41636
	fmov	%f1, %f0
	jmp	fjge_cont.41637
fjge_else.41636:
	fsub	%f1, %f29, %f0
fjge_cont.41637:
	fjlt	%f22, %f1, fjge_else.41638
	fmov	%f0, %f1
	jmp	fjge_cont.41639
fjge_else.41638:
	fsub	%f0, %f4, %f1
fjge_cont.41639:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f3, %f0, %f25
	fsub	%f3, %f26, %f3
	fdiv	%f3, %f0, %f3
	fsub	%f3, %f24, %f3
	fdiv	%f3, %f0, %f3
	fsub	%f3, %f23, %f3
	fdiv	%f0, %f0, %f3
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f10, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f1, %f0
	jne	%g3, %g0, jeq_else.41640
	fneg	%f0, %f1
	jmp	jeq_cont.41641
jeq_else.41640:
	fmov	%f0, %f1
jeq_cont.41641:
	fldi	%f6, %g1, 24
	fmul	%f3, %f6, %f0
	setL %g3, l.35559
	fldi	%f1, %g3, 0
	fmul	%f3, %f3, %f1
	fsti	%f3, %g31, 672
	setL %g3, l.35562
	fldi	%f3, %g3, 0
	fldi	%f5, %g1, 20
	fmul	%f3, %f5, %f3
	fsti	%f3, %g31, 668
	fmul	%f3, %f6, %f2
	fmul	%f1, %f3, %f1
	fsti	%f1, %g31, 664
	fsti	%f2, %g31, 648
	fsti	%f16, %g31, 644
	fneg	%f1, %f0
	fsti	%f1, %g31, 640
	fneg	%f1, %f5
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 660
	fneg	%f6, %f6
	fsti	%f6, %g31, 656
	fmul	%f0, %f1, %f2
	fsti	%f0, %g31, 652
	fldi	%f1, %g31, 284
	fldi	%f0, %g31, 672
	fsub	%f0, %f1, %f0
	fsti	%f0, %g31, 296
	fldi	%f1, %g31, 280
	fldi	%f0, %g31, 668
	fsub	%f0, %f1, %f0
	fsti	%f0, %g31, 292
	fldi	%f1, %g31, 276
	fldi	%f0, %g31, 664
	fsub	%f0, %f1, %f0
	fsti	%f0, %g31, 288
	inputw	%g3
	inputf	%f0
	fldi	%f7, %g1, 28
	fmul	%f2, %f0, %f7
	fjlt	%f2, %f16, fjge_else.41642
	fmov	%f1, %f2
	jmp	fjge_cont.41643
fjge_else.41642:
	fneg	%f1, %f2
fjge_cont.41643:
	fjlt	%f29, %f1, fjge_else.41644
	fjlt	%f1, %f16, fjge_else.41646
	fmov	%f0, %f1
	jmp	fjge_cont.41647
fjge_else.41646:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41648
	fjlt	%f1, %f16, fjge_else.41650
	fmov	%f0, %f1
	jmp	fjge_cont.41651
fjge_else.41650:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41652
	fjlt	%f1, %f16, fjge_else.41654
	fmov	%f0, %f1
	jmp	fjge_cont.41655
fjge_else.41654:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41655:
	jmp	fjge_cont.41653
fjge_else.41652:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41653:
fjge_cont.41651:
	jmp	fjge_cont.41649
fjge_else.41648:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41656
	fjlt	%f1, %f16, fjge_else.41658
	fmov	%f0, %f1
	jmp	fjge_cont.41659
fjge_else.41658:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41659:
	jmp	fjge_cont.41657
fjge_else.41656:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41657:
fjge_cont.41649:
fjge_cont.41647:
	jmp	fjge_cont.41645
fjge_else.41644:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41660
	fjlt	%f1, %f16, fjge_else.41662
	fmov	%f0, %f1
	jmp	fjge_cont.41663
fjge_else.41662:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41664
	fjlt	%f1, %f16, fjge_else.41666
	fmov	%f0, %f1
	jmp	fjge_cont.41667
fjge_else.41666:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41667:
	jmp	fjge_cont.41665
fjge_else.41664:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41665:
fjge_cont.41663:
	jmp	fjge_cont.41661
fjge_else.41660:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41668
	fjlt	%f1, %f16, fjge_else.41670
	fmov	%f0, %f1
	jmp	fjge_cont.41671
fjge_else.41670:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41671:
	jmp	fjge_cont.41669
fjge_else.41668:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2480
	addi	%g1, %g1, 36
fjge_cont.41669:
fjge_cont.41661:
fjge_cont.41645:
	fldi	%f4, %g1, 16
	fjlt	%f4, %f0, fjge_else.41672
	fjlt	%f16, %f2, fjge_else.41674
	addi	%g3, %g0, 0
	jmp	fjge_cont.41675
fjge_else.41674:
	addi	%g3, %g0, 1
fjge_cont.41675:
	jmp	fjge_cont.41673
fjge_else.41672:
	fjlt	%f16, %f2, fjge_else.41676
	addi	%g3, %g0, 1
	jmp	fjge_cont.41677
fjge_else.41676:
	addi	%g3, %g0, 0
fjge_cont.41677:
fjge_cont.41673:
	fjlt	%f4, %f0, fjge_else.41678
	fmov	%f1, %f0
	jmp	fjge_cont.41679
fjge_else.41678:
	fsub	%f1, %f29, %f0
fjge_cont.41679:
	fjlt	%f22, %f1, fjge_else.41680
	fmov	%f0, %f1
	jmp	fjge_cont.41681
fjge_else.41680:
	fsub	%f0, %f4, %f1
fjge_cont.41681:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f3, %f0, %f25
	fsub	%f3, %f26, %f3
	fdiv	%f3, %f0, %f3
	fsub	%f3, %f24, %f3
	fdiv	%f3, %f0, %f3
	fsub	%f3, %f23, %f3
	fdiv	%f0, %f0, %f3
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fldi	%f10, %g1, 12
	fmul	%f1, %f10, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f1, %f0
	jne	%g3, %g0, jeq_else.41682
	fneg	%f0, %f1
	jmp	jeq_cont.41683
jeq_else.41682:
	fmov	%f0, %f1
jeq_cont.41683:
	fneg	%f0, %f0
	fsti	%f0, %g31, 304
	fsti	%f2, %g1, 32
	inputf	%f0
	fldi	%f7, %g1, 28
	fmul	%f3, %f0, %f7
	fldi	%f2, %g1, 32
	fsub	%f2, %f22, %f2
	fjlt	%f2, %f16, fjge_else.41684
	fmov	%f1, %f2
	jmp	fjge_cont.41685
fjge_else.41684:
	fneg	%f1, %f2
fjge_cont.41685:
	fjlt	%f29, %f1, fjge_else.41686
	fjlt	%f1, %f16, fjge_else.41688
	fmov	%f0, %f1
	jmp	fjge_cont.41689
fjge_else.41688:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41690
	fjlt	%f1, %f16, fjge_else.41692
	fmov	%f0, %f1
	jmp	fjge_cont.41693
fjge_else.41692:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41694
	fjlt	%f1, %f16, fjge_else.41696
	fmov	%f0, %f1
	jmp	fjge_cont.41697
fjge_else.41696:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41697:
	jmp	fjge_cont.41695
fjge_else.41694:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41695:
fjge_cont.41693:
	jmp	fjge_cont.41691
fjge_else.41690:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41698
	fjlt	%f1, %f16, fjge_else.41700
	fmov	%f0, %f1
	jmp	fjge_cont.41701
fjge_else.41700:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41701:
	jmp	fjge_cont.41699
fjge_else.41698:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41699:
fjge_cont.41691:
fjge_cont.41689:
	jmp	fjge_cont.41687
fjge_else.41686:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41702
	fjlt	%f1, %f16, fjge_else.41704
	fmov	%f0, %f1
	jmp	fjge_cont.41705
fjge_else.41704:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41706
	fjlt	%f1, %f16, fjge_else.41708
	fmov	%f0, %f1
	jmp	fjge_cont.41709
fjge_else.41708:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41709:
	jmp	fjge_cont.41707
fjge_else.41706:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41707:
fjge_cont.41705:
	jmp	fjge_cont.41703
fjge_else.41702:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41710
	fjlt	%f1, %f16, fjge_else.41712
	fmov	%f0, %f1
	jmp	fjge_cont.41713
fjge_else.41712:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41713:
	jmp	fjge_cont.41711
fjge_else.41710:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41711:
fjge_cont.41703:
fjge_cont.41687:
	fldi	%f4, %g1, 16
	fjlt	%f4, %f0, fjge_else.41714
	fjlt	%f16, %f2, fjge_else.41716
	addi	%g3, %g0, 0
	jmp	fjge_cont.41717
fjge_else.41716:
	addi	%g3, %g0, 1
fjge_cont.41717:
	jmp	fjge_cont.41715
fjge_else.41714:
	fjlt	%f16, %f2, fjge_else.41718
	addi	%g3, %g0, 1
	jmp	fjge_cont.41719
fjge_else.41718:
	addi	%g3, %g0, 0
fjge_cont.41719:
fjge_cont.41715:
	fjlt	%f4, %f0, fjge_else.41720
	fmov	%f1, %f0
	jmp	fjge_cont.41721
fjge_else.41720:
	fsub	%f1, %f29, %f0
fjge_cont.41721:
	fjlt	%f22, %f1, fjge_else.41722
	fmov	%f0, %f1
	jmp	fjge_cont.41723
fjge_else.41722:
	fsub	%f0, %f4, %f1
fjge_cont.41723:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fldi	%f10, %g1, 12
	fmul	%f1, %f10, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g3, %g0, jeq_else.41724
	fneg	%f5, %f0
	jmp	jeq_cont.41725
jeq_else.41724:
	fmov	%f5, %f0
jeq_cont.41725:
	fjlt	%f3, %f16, fjge_else.41726
	fmov	%f1, %f3
	jmp	fjge_cont.41727
fjge_else.41726:
	fneg	%f1, %f3
fjge_cont.41727:
	fjlt	%f29, %f1, fjge_else.41728
	fjlt	%f1, %f16, fjge_else.41730
	fmov	%f0, %f1
	jmp	fjge_cont.41731
fjge_else.41730:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41732
	fjlt	%f1, %f16, fjge_else.41734
	fmov	%f0, %f1
	jmp	fjge_cont.41735
fjge_else.41734:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41736
	fjlt	%f1, %f16, fjge_else.41738
	fmov	%f0, %f1
	jmp	fjge_cont.41739
fjge_else.41738:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41739:
	jmp	fjge_cont.41737
fjge_else.41736:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41737:
fjge_cont.41735:
	jmp	fjge_cont.41733
fjge_else.41732:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41740
	fjlt	%f1, %f16, fjge_else.41742
	fmov	%f0, %f1
	jmp	fjge_cont.41743
fjge_else.41742:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41743:
	jmp	fjge_cont.41741
fjge_else.41740:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41741:
fjge_cont.41733:
fjge_cont.41731:
	jmp	fjge_cont.41729
fjge_else.41728:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41744
	fjlt	%f1, %f16, fjge_else.41746
	fmov	%f0, %f1
	jmp	fjge_cont.41747
fjge_else.41746:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41748
	fjlt	%f1, %f16, fjge_else.41750
	fmov	%f0, %f1
	jmp	fjge_cont.41751
fjge_else.41750:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41751:
	jmp	fjge_cont.41749
fjge_else.41748:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41749:
fjge_cont.41747:
	jmp	fjge_cont.41745
fjge_else.41744:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41752
	fjlt	%f1, %f16, fjge_else.41754
	fmov	%f0, %f1
	jmp	fjge_cont.41755
fjge_else.41754:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41755:
	jmp	fjge_cont.41753
fjge_else.41752:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41753:
fjge_cont.41745:
fjge_cont.41729:
	fjlt	%f4, %f0, fjge_else.41756
	fjlt	%f16, %f3, fjge_else.41758
	addi	%g3, %g0, 0
	jmp	fjge_cont.41759
fjge_else.41758:
	addi	%g3, %g0, 1
fjge_cont.41759:
	jmp	fjge_cont.41757
fjge_else.41756:
	fjlt	%f16, %f3, fjge_else.41760
	addi	%g3, %g0, 1
	jmp	fjge_cont.41761
fjge_else.41760:
	addi	%g3, %g0, 0
fjge_cont.41761:
fjge_cont.41757:
	fjlt	%f4, %f0, fjge_else.41762
	fmov	%f1, %f0
	jmp	fjge_cont.41763
fjge_else.41762:
	fsub	%f1, %f29, %f0
fjge_cont.41763:
	fjlt	%f22, %f1, fjge_else.41764
	fmov	%f0, %f1
	jmp	fjge_cont.41765
fjge_else.41764:
	fsub	%f0, %f4, %f1
fjge_cont.41765:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f10, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f1, %f0
	jne	%g3, %g0, jeq_else.41766
	fneg	%f0, %f1
	jmp	jeq_cont.41767
jeq_else.41766:
	fmov	%f0, %f1
jeq_cont.41767:
	fmul	%f0, %f5, %f0
	fsti	%f0, %g31, 308
	fsub	%f2, %f22, %f3
	fjlt	%f2, %f16, fjge_else.41768
	fmov	%f1, %f2
	jmp	fjge_cont.41769
fjge_else.41768:
	fneg	%f1, %f2
fjge_cont.41769:
	fjlt	%f29, %f1, fjge_else.41770
	fjlt	%f1, %f16, fjge_else.41772
	fmov	%f0, %f1
	jmp	fjge_cont.41773
fjge_else.41772:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41774
	fjlt	%f1, %f16, fjge_else.41776
	fmov	%f0, %f1
	jmp	fjge_cont.41777
fjge_else.41776:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41778
	fjlt	%f1, %f16, fjge_else.41780
	fmov	%f0, %f1
	jmp	fjge_cont.41781
fjge_else.41780:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41781:
	jmp	fjge_cont.41779
fjge_else.41778:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41779:
fjge_cont.41777:
	jmp	fjge_cont.41775
fjge_else.41774:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41782
	fjlt	%f1, %f16, fjge_else.41784
	fmov	%f0, %f1
	jmp	fjge_cont.41785
fjge_else.41784:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41785:
	jmp	fjge_cont.41783
fjge_else.41782:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41783:
fjge_cont.41775:
fjge_cont.41773:
	jmp	fjge_cont.41771
fjge_else.41770:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41786
	fjlt	%f1, %f16, fjge_else.41788
	fmov	%f0, %f1
	jmp	fjge_cont.41789
fjge_else.41788:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41790
	fjlt	%f1, %f16, fjge_else.41792
	fmov	%f0, %f1
	jmp	fjge_cont.41793
fjge_else.41792:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41793:
	jmp	fjge_cont.41791
fjge_else.41790:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41791:
fjge_cont.41789:
	jmp	fjge_cont.41787
fjge_else.41786:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41794
	fjlt	%f1, %f16, fjge_else.41796
	fmov	%f0, %f1
	jmp	fjge_cont.41797
fjge_else.41796:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41797:
	jmp	fjge_cont.41795
fjge_else.41794:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2480
	addi	%g1, %g1, 40
fjge_cont.41795:
fjge_cont.41787:
fjge_cont.41771:
	fjlt	%f4, %f0, fjge_else.41798
	fjlt	%f16, %f2, fjge_else.41800
	addi	%g3, %g0, 0
	jmp	fjge_cont.41801
fjge_else.41800:
	addi	%g3, %g0, 1
fjge_cont.41801:
	jmp	fjge_cont.41799
fjge_else.41798:
	fjlt	%f16, %f2, fjge_else.41802
	addi	%g3, %g0, 1
	jmp	fjge_cont.41803
fjge_else.41802:
	addi	%g3, %g0, 0
fjge_cont.41803:
fjge_cont.41799:
	fjlt	%f4, %f0, fjge_else.41804
	fmov	%f1, %f0
	jmp	fjge_cont.41805
fjge_else.41804:
	fsub	%f1, %f29, %f0
fjge_cont.41805:
	fjlt	%f22, %f1, fjge_else.41806
	fmov	%f0, %f1
	jmp	fjge_cont.41807
fjge_else.41806:
	fsub	%f0, %f4, %f1
fjge_cont.41807:
	fmul	%f0, %f0, %f21
	fmul	%f2, %f0, %f0
	fdiv	%f1, %f2, %f25
	fsub	%f1, %f26, %f1
	fdiv	%f1, %f2, %f1
	fsub	%f1, %f24, %f1
	fdiv	%f1, %f2, %f1
	fsub	%f1, %f23, %f1
	fdiv	%f1, %f2, %f1
	fsub	%f1, %f17, %f1
	fdiv	%f0, %f0, %f1
	fmul	%f1, %f10, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f1, %f0
	jne	%g3, %g0, jeq_else.41808
	fneg	%f0, %f1
	jmp	jeq_cont.41809
jeq_else.41808:
	fmov	%f0, %f1
jeq_cont.41809:
	fmul	%f0, %f5, %f0
	fsti	%f0, %g31, 300
	inputf	%f0
	fsti	%f0, %g31, 312
	addi	%g8, %g0, 0
	subi	%g1, %g1, 40
	call	read_object.2673
	addi	%g3, %g0, 0
	call	read_and_network.2681
	addi	%g4, %g0, 0
	call	read_or_network.2679
	sti	%g3, %g31, 516
	addi	%g3, %g0, 80
	output	%g3
	addi	%g3, %g0, 54
	output	%g3
	addi	%g3, %g0, 10
	output	%g3
	addi	%g3, %g0, 49
	output	%g3
	addi	%g3, %g0, 50
	output	%g3
	addi	%g3, %g0, 56
	output	%g3
	addi	%g3, %g0, 32
	output	%g3
	addi	%g3, %g0, 49
	output	%g3
	addi	%g3, %g0, 50
	output	%g3
	addi	%g3, %g0, 56
	output	%g3
	addi	%g3, %g0, 32
	output	%g3
	addi	%g3, %g0, 50
	output	%g3
	addi	%g3, %g0, 53
	output	%g3
	addi	%g3, %g0, 53
	output	%g3
	addi	%g3, %g0, 10
	output	%g3
	addi	%g6, %g0, 120
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2308
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2364
	ldi	%g3, %g31, 28
	subi	%g4, %g31, 2308
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g4, %g31, 2312
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g4, %g3, -4
	sti	%g7, %g3, 0
	mov	%g4, %g3
	mov	%g3, %g6
	call	min_caml_create_array
	sti	%g3, %g31, 700
	ldi	%g6, %g31, 700
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2324
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2364
	ldi	%g3, %g31, 28
	subi	%g4, %g31, 2324
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g4, %g31, 2328
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g4, %g3, -4
	sti	%g7, %g3, 0
	sti	%g3, %g6, -472
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2340
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2364
	ldi	%g3, %g31, 28
	subi	%g4, %g31, 2340
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g4, %g31, 2344
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g4, %g3, -4
	sti	%g7, %g3, 0
	sti	%g3, %g6, -468
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2356
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2364
	ldi	%g3, %g31, 28
	subi	%g4, %g31, 2356
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g4, %g31, 2360
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g4, %g3, -4
	sti	%g7, %g3, 0
	sti	%g3, %g6, -464
	addi	%g7, %g0, 115
	call	create_dirvec_elements.2989
	addi	%g8, %g0, 3
	call	create_dirvecs.2992
	addi	%g3, %g0, 9
	addi	%g8, %g0, 0
	addi	%g12, %g0, 0
	call	min_caml_float_of_int
	addi	%g1, %g1, 40
	setL %g3, l.35622
	fldi	%f4, %g3, 0
	fmul	%f0, %f0, %f4
	setL %g3, l.35624
	fldi	%f3, %g3, 0
	fsub	%f0, %f0, %f3
	addi	%g3, %g0, 4
	fsti	%f0, %g1, 36
	subi	%g1, %g1, 44
	call	min_caml_float_of_int
	addi	%g1, %g1, 44
	fmov	%f1, %f0
	fmul	%f1, %f1, %f4
	fsub	%f2, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 36
	fsti	%f3, %g1, 40
	fsti	%f4, %g1, 44
	fsti	%f1, %g1, 48
	mov	%g3, %g12
	mov	%g5, %g8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 56
	call	calc_dirvec.2970
	addi	%g1, %g1, 56
	setL %g3, l.35626
	fldi	%f5, %g3, 0
	fldi	%f1, %g1, 48
	fadd	%f2, %f1, %f5
	addi	%g4, %g0, 0
	addi	%g3, %g0, 2
	fldi	%f0, %g1, 36
	fsti	%f5, %g1, 52
	mov	%g5, %g8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 60
	call	calc_dirvec.2970
	addi	%g1, %g1, 60
	addi	%g3, %g0, 3
	addi	%g5, %g0, 1
	sti	%g5, %g1, 56
	subi	%g1, %g1, 64
	call	min_caml_float_of_int
	addi	%g1, %g1, 64
	fmov	%f1, %f0
	fldi	%f4, %g1, 44
	fmul	%f1, %f1, %f4
	fldi	%f3, %g1, 40
	fsub	%f2, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 36
	ldi	%g5, %g1, 56
	fsti	%f1, %g1, 60
	mov	%g3, %g12
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 68
	call	calc_dirvec.2970
	addi	%g1, %g1, 68
	fldi	%f5, %g1, 52
	fldi	%f1, %g1, 60
	fadd	%f2, %f1, %f5
	addi	%g4, %g0, 0
	addi	%g8, %g0, 2
	fldi	%f0, %g1, 36
	ldi	%g5, %g1, 56
	mov	%g3, %g8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 68
	call	calc_dirvec.2970
	addi	%g1, %g1, 68
	addi	%g3, %g0, 2
	addi	%g5, %g0, 2
	sti	%g5, %g1, 64
	subi	%g1, %g1, 72
	call	min_caml_float_of_int
	addi	%g1, %g1, 72
	fmov	%f1, %f0
	fldi	%f4, %g1, 44
	fmul	%f1, %f1, %f4
	fldi	%f3, %g1, 40
	fsub	%f2, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 36
	ldi	%g5, %g1, 64
	fsti	%f1, %g1, 68
	mov	%g3, %g12
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 76
	call	calc_dirvec.2970
	addi	%g1, %g1, 76
	fldi	%f5, %g1, 52
	fldi	%f1, %g1, 68
	fadd	%f2, %f1, %f5
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 36
	ldi	%g5, %g1, 64
	mov	%g3, %g8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 76
	call	calc_dirvec.2970
	addi	%g1, %g1, 76
	addi	%g10, %g0, 1
	addi	%g9, %g0, 3
	fldi	%f0, %g1, 36
	mov	%g8, %g12
	subi	%g1, %g1, 76
	call	calc_dirvecs.2978
	addi	%g13, %g0, 8
	addi	%g12, %g0, 2
	addi	%g8, %g0, 4
	call	calc_dirvec_rows.2983
	ldi	%g11, %g31, 700
	ldi	%g3, %g11, -476
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -472
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -468
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -464
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -460
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -456
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -452
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	addi	%g12, %g0, 112
	call	init_dirvec_constants.2994
	addi	%g13, %g0, 3
	call	init_vecset_constants.2997
	fldi	%f0, %g31, 308
	fsti	%f0, %g31, 732
	fldi	%f0, %g31, 304
	fsti	%f0, %g31, 728
	fldi	%f0, %g31, 300
	fsti	%f0, %g31, 724
	ldi	%g3, %g31, 28
	subi	%g5, %g3, 1
	subi	%g7, %g31, 732
	subi	%g6, %g31, 972
	call	iter_setup_dirvec_constants.2778
	addi	%g1, %g1, 76
	ldi	%g3, %g31, 28
	subi	%g6, %g3, 1
	jlt	%g6, %g0, jge_else.41810
	slli	%g3, %g6, 2
	add	%g3, %g31, %g3
	ldi	%g3, %g3, 272
	ldi	%g4, %g3, -8
	addi	%g5, %g0, 2
	jne	%g4, %g5, jeq_else.41812
	ldi	%g4, %g3, -28
	fldi	%f0, %g4, 0
	fjlt	%f0, %f17, fjge_else.41814
	jmp	fjge_cont.41815
fjge_else.41814:
	ldi	%g5, %g3, -4
	jne	%g5, %g28, jeq_else.41816
	slli	%g11, %g6, 2
	ldi	%g12, %g31, 1720
	fldi	%f0, %g4, 0
	fsub	%f12, %f17, %f0
	fldi	%f1, %g31, 308
	fneg	%f11, %f1
	fldi	%f10, %g31, 304
	fneg	%f10, %f10
	fldi	%f9, %g31, 300
	fneg	%f9, %f9
	addi	%g14, %g11, 1
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 76
	call	min_caml_create_float_array
	addi	%g1, %g1, 76
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 72
	subi	%g1, %g1, 80
	call	min_caml_create_array
	addi	%g1, %g1, 80
	mov	%g5, %g2
	addi	%g2, %g2, 8
	sti	%g3, %g5, -4
	ldi	%g4, %g1, 72
	sti	%g4, %g5, 0
	fsti	%f1, %g4, 0
	fsti	%f10, %g4, -4
	fsti	%f9, %g4, -8
	ldi	%g6, %g31, 28
	subi	%g13, %g6, 1
	sti	%g5, %g1, 76
	mov	%g5, %g13
	mov	%g6, %g3
	mov	%g7, %g4
	subi	%g1, %g1, 84
	call	iter_setup_dirvec_constants.2778
	addi	%g1, %g1, 84
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fsti	%f12, %g3, -8
	ldi	%g5, %g1, 76
	sti	%g5, %g3, -4
	sti	%g14, %g3, 0
	slli	%g4, %g12, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 1716
	addi	%g18, %g12, 1
	addi	%g14, %g11, 2
	fldi	%f1, %g31, 304
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 84
	call	min_caml_create_float_array
	addi	%g1, %g1, 84
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 80
	subi	%g1, %g1, 88
	call	min_caml_create_array
	addi	%g1, %g1, 88
	mov	%g5, %g2
	addi	%g2, %g2, 8
	sti	%g3, %g5, -4
	ldi	%g4, %g1, 80
	sti	%g4, %g5, 0
	fsti	%f11, %g4, 0
	fsti	%f1, %g4, -4
	fsti	%f9, %g4, -8
	ldi	%g6, %g31, 28
	subi	%g13, %g6, 1
	sti	%g5, %g1, 84
	mov	%g5, %g13
	mov	%g6, %g3
	mov	%g7, %g4
	subi	%g1, %g1, 92
	call	iter_setup_dirvec_constants.2778
	addi	%g1, %g1, 92
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fsti	%f12, %g3, -8
	ldi	%g5, %g1, 84
	sti	%g5, %g3, -4
	sti	%g14, %g3, 0
	slli	%g4, %g18, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 1716
	addi	%g14, %g12, 2
	addi	%g13, %g11, 3
	fldi	%f1, %g31, 300
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 92
	call	min_caml_create_float_array
	addi	%g1, %g1, 92
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 88
	subi	%g1, %g1, 96
	call	min_caml_create_array
	addi	%g1, %g1, 96
	mov	%g5, %g2
	addi	%g2, %g2, 8
	sti	%g3, %g5, -4
	ldi	%g4, %g1, 88
	sti	%g4, %g5, 0
	fsti	%f11, %g4, 0
	fsti	%f10, %g4, -4
	fsti	%f1, %g4, -8
	ldi	%g6, %g31, 28
	subi	%g11, %g6, 1
	sti	%g5, %g1, 92
	mov	%g5, %g11
	mov	%g6, %g3
	mov	%g7, %g4
	subi	%g1, %g1, 100
	call	iter_setup_dirvec_constants.2778
	addi	%g1, %g1, 100
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fsti	%f12, %g3, -8
	ldi	%g5, %g1, 92
	sti	%g5, %g3, -4
	sti	%g13, %g3, 0
	slli	%g4, %g14, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 1716
	addi	%g3, %g12, 3
	sti	%g3, %g31, 1720
	jmp	jeq_cont.41817
jeq_else.41816:
	addi	%g4, %g0, 2
	jne	%g5, %g4, jeq_else.41818
	slli	%g4, %g6, 2
	addi	%g12, %g4, 1
	ldi	%g13, %g31, 1720
	fsub	%f9, %f17, %f0
	ldi	%g3, %g3, -16
	fldi	%f7, %g31, 308
	fldi	%f5, %g3, 0
	fmul	%f2, %f7, %f5
	fldi	%f1, %g31, 304
	fldi	%f6, %g3, -4
	fmul	%f0, %f1, %f6
	fadd	%f4, %f2, %f0
	fldi	%f2, %g31, 300
	fldi	%f0, %g3, -8
	fmul	%f3, %f2, %f0
	fadd	%f3, %f4, %f3
	fldi	%f10, %g1, 12
	fmul	%f4, %f10, %f5
	fmul	%f4, %f4, %f3
	fsub	%f5, %f4, %f7
	fmul	%f4, %f10, %f6
	fmul	%f4, %f4, %f3
	fsub	%f4, %f4, %f1
	fmul	%f0, %f10, %f0
	fmul	%f0, %f0, %f3
	fsub	%f1, %f0, %f2
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 100
	call	min_caml_create_float_array
	addi	%g1, %g1, 100
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 96
	subi	%g1, %g1, 104
	call	min_caml_create_array
	addi	%g1, %g1, 104
	mov	%g5, %g2
	addi	%g2, %g2, 8
	sti	%g3, %g5, -4
	ldi	%g4, %g1, 96
	sti	%g4, %g5, 0
	fsti	%f5, %g4, 0
	fsti	%f4, %g4, -4
	fsti	%f1, %g4, -8
	ldi	%g6, %g31, 28
	subi	%g11, %g6, 1
	sti	%g5, %g1, 100
	mov	%g5, %g11
	mov	%g6, %g3
	mov	%g7, %g4
	subi	%g1, %g1, 108
	call	iter_setup_dirvec_constants.2778
	addi	%g1, %g1, 108
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fsti	%f9, %g3, -8
	ldi	%g5, %g1, 100
	sti	%g5, %g3, -4
	sti	%g12, %g3, 0
	slli	%g4, %g13, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 1716
	addi	%g3, %g13, 1
	sti	%g3, %g31, 1720
	jmp	jeq_cont.41819
jeq_else.41818:
jeq_cont.41819:
jeq_cont.41817:
fjge_cont.41815:
	jmp	jeq_cont.41813
jeq_else.41812:
jeq_cont.41813:
	jmp	jge_cont.41811
jge_else.41810:
jge_cont.41811:
	addi	%g8, %g0, 0
	fldi	%f3, %g31, 612
	ldi	%g3, %g31, 604
	sub	%g3, %g0, %g3
	subi	%g1, %g1, 108
	call	min_caml_float_of_int
	addi	%g1, %g1, 108
	fmul	%f0, %f3, %f0
	fldi	%f1, %g31, 660
	fmul	%f2, %f0, %f1
	fldi	%f1, %g31, 672
	fadd	%f13, %f2, %f1
	fldi	%f1, %g31, 656
	fmul	%f2, %f0, %f1
	fldi	%f1, %g31, 668
	fadd	%f12, %f2, %f1
	fldi	%f1, %g31, 652
	fmul	%f1, %f0, %f1
	fldi	%f0, %g31, 664
	fadd	%f11, %f1, %f0
	ldi	%g3, %g31, 600
	subi	%g6, %g3, 1
	ldi	%g16, %g1, 8
	mov	%g7, %g16
	subi	%g1, %g1, 108
	call	pretrace_pixels.2935
	addi	%g1, %g1, 108
	addi	%g10, %g0, 0
	addi	%g8, %g0, 2
	ldi	%g3, %g31, 596
	jlt	%g10, %g3, jle_else.41820
	jmp	jle_cont.41821
jle_else.41820:
	subi	%g3, %g3, 1
	sti	%g10, %g1, 104
	jlt	%g10, %g3, jle_else.41822
	jmp	jle_cont.41823
jle_else.41822:
	addi	%g4, %g0, 1
	fldi	%f3, %g31, 612
	ldi	%g3, %g31, 604
	sub	%g3, %g4, %g3
	subi	%g1, %g1, 112
	call	min_caml_float_of_int
	addi	%g1, %g1, 112
	fmul	%f0, %f3, %f0
	fldi	%f1, %g31, 660
	fmul	%f2, %f0, %f1
	fldi	%f1, %g31, 672
	fadd	%f13, %f2, %f1
	fldi	%f1, %g31, 656
	fmul	%f2, %f0, %f1
	fldi	%f1, %g31, 668
	fadd	%f12, %f2, %f1
	fldi	%f1, %g31, 652
	fmul	%f1, %f0, %f1
	fldi	%f0, %g31, 664
	fadd	%f11, %f1, %f0
	ldi	%g3, %g31, 600
	subi	%g6, %g3, 1
	ldi	%g15, %g1, 4
	mov	%g7, %g15
	subi	%g1, %g1, 112
	call	pretrace_pixels.2935
	addi	%g1, %g1, 112
jle_cont.41823:
	addi	%g6, %g0, 0
	ldi	%g10, %g1, 104
	ldi	%g17, %g1, 0
	ldi	%g16, %g1, 8
	ldi	%g15, %g1, 4
	mov	%g8, %g15
	mov	%g7, %g16
	mov	%g9, %g17
	subi	%g1, %g1, 112
	call	scan_pixel.2946
	addi	%g1, %g1, 112
	addi	%g10, %g0, 1
	addi	%g3, %g0, 4
	ldi	%g16, %g1, 8
	ldi	%g15, %g1, 4
	ldi	%g17, %g1, 0
	mov	%g8, %g17
	mov	%g9, %g15
	mov	%g7, %g16
	subi	%g1, %g1, 112
	call	scan_line.2952
	addi	%g1, %g1, 112
jle_cont.41821:
	addi	%g0, %g0, 0
	halt

!==============================
! args = []
! fargs = [%f1]
! use_regs = [%g27, %f29, %f16, %f15, %f1, %f0]
! ret type = Float
!================================
sin_sub.2480:
	fjlt	%f29, %f1, fjge_else.41824
	fjlt	%f1, %f16, fjge_else.41825
	fmov	%f0, %f1
	return
fjge_else.41825:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41826
	fjlt	%f1, %f16, fjge_else.41827
	fmov	%f0, %f1
	return
fjge_else.41827:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41828
	fjlt	%f1, %f16, fjge_else.41829
	fmov	%f0, %f1
	return
fjge_else.41829:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41830
	fjlt	%f1, %f16, fjge_else.41831
	fmov	%f0, %f1
	return
fjge_else.41831:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2480
fjge_else.41830:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2480
fjge_else.41828:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41832
	fjlt	%f1, %f16, fjge_else.41833
	fmov	%f0, %f1
	return
fjge_else.41833:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2480
fjge_else.41832:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2480
fjge_else.41826:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41834
	fjlt	%f1, %f16, fjge_else.41835
	fmov	%f0, %f1
	return
fjge_else.41835:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41836
	fjlt	%f1, %f16, fjge_else.41837
	fmov	%f0, %f1
	return
fjge_else.41837:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2480
fjge_else.41836:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2480
fjge_else.41834:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41838
	fjlt	%f1, %f16, fjge_else.41839
	fmov	%f0, %f1
	return
fjge_else.41839:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2480
fjge_else.41838:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2480
fjge_else.41824:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41840
	fjlt	%f1, %f16, fjge_else.41841
	fmov	%f0, %f1
	return
fjge_else.41841:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41842
	fjlt	%f1, %f16, fjge_else.41843
	fmov	%f0, %f1
	return
fjge_else.41843:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41844
	fjlt	%f1, %f16, fjge_else.41845
	fmov	%f0, %f1
	return
fjge_else.41845:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2480
fjge_else.41844:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2480
fjge_else.41842:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41846
	fjlt	%f1, %f16, fjge_else.41847
	fmov	%f0, %f1
	return
fjge_else.41847:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2480
fjge_else.41846:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2480
fjge_else.41840:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41848
	fjlt	%f1, %f16, fjge_else.41849
	fmov	%f0, %f1
	return
fjge_else.41849:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41850
	fjlt	%f1, %f16, fjge_else.41851
	fmov	%f0, %f1
	return
fjge_else.41851:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2480
fjge_else.41850:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2480
fjge_else.41848:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41852
	fjlt	%f1, %f16, fjge_else.41853
	fmov	%f0, %f1
	return
fjge_else.41853:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2480
fjge_else.41852:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2480

!==============================
! args = [%g8]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g2, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f29, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
read_object.2673:
	addi	%g3, %g0, 60
	jlt	%g8, %g3, jle_else.41854
	return
jle_else.41854:
	sti	%g8, %g1, 0
	inputw	%g11
	jne	%g11, %g29, jeq_else.41856
	addi	%g3, %g0, 0
	jmp	jeq_cont.41857
jeq_else.41856:
	sti	%g11, %g1, 4
	inputw	%g6
	sti	%g6, %g1, 8
	inputw	%g12
	sti	%g12, %g1, 12
	inputw	%g7
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 20
	call	min_caml_create_float_array
	addi	%g1, %g1, 20
	mov	%g5, %g3
	sti	%g7, %g1, 16
	sti	%g5, %g1, 20
	inputf	%f0
	ldi	%g5, %g1, 20
	fsti	%f0, %g5, 0
	inputf	%f0
	ldi	%g5, %g1, 20
	fsti	%f0, %g5, -4
	inputf	%f0
	ldi	%g5, %g1, 20
	fsti	%f0, %g5, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 28
	call	min_caml_create_float_array
	addi	%g1, %g1, 28
	mov	%g10, %g3
	sti	%g10, %g1, 24
	inputf	%f0
	ldi	%g10, %g1, 24
	fsti	%f0, %g10, 0
	inputf	%f0
	ldi	%g10, %g1, 24
	fsti	%f0, %g10, -4
	inputf	%f0
	ldi	%g10, %g1, 24
	fsti	%f0, %g10, -8
	inputf	%f2
	addi	%g3, %g0, 2
	fmov	%f0, %f16
	subi	%g1, %g1, 32
	call	min_caml_create_float_array
	addi	%g1, %g1, 32
	mov	%g13, %g3
	fsti	%f2, %g1, 28
	sti	%g13, %g1, 32
	inputf	%f0
	ldi	%g13, %g1, 32
	fsti	%f0, %g13, 0
	inputf	%f0
	ldi	%g13, %g1, 32
	fsti	%f0, %g13, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 40
	call	min_caml_create_float_array
	addi	%g1, %g1, 40
	mov	%g14, %g3
	sti	%g14, %g1, 36
	inputf	%f0
	ldi	%g14, %g1, 36
	fsti	%f0, %g14, 0
	inputf	%f0
	ldi	%g14, %g1, 36
	fsti	%f0, %g14, -4
	inputf	%f0
	ldi	%g14, %g1, 36
	fsti	%f0, %g14, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 44
	call	min_caml_create_float_array
	addi	%g1, %g1, 44
	ldi	%g7, %g1, 16
	jne	%g7, %g0, jeq_else.41858
	jmp	jeq_cont.41859
jeq_else.41858:
	sti	%g3, %g1, 40
	inputf	%f0
	setL %g4, l.35547
	fldi	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	ldi	%g3, %g1, 40
	fsti	%f0, %g3, 0
	fsti	%f1, %g1, 44
	inputf	%f0
	fldi	%f1, %g1, 44
	fmul	%f0, %f0, %f1
	ldi	%g3, %g1, 40
	fsti	%f0, %g3, -4
	inputf	%f0
	fldi	%f1, %g1, 44
	fmul	%f0, %f0, %f1
	ldi	%g3, %g1, 40
	fsti	%f0, %g3, -8
jeq_cont.41859:
	addi	%g15, %g0, 2
	ldi	%g6, %g1, 8
	jne	%g6, %g15, jeq_else.41860
	addi	%g15, %g0, 1
	jmp	jeq_cont.41861
jeq_else.41860:
	fldi	%f2, %g1, 28
	fjlt	%f2, %f16, fjge_else.41862
	addi	%g15, %g0, 0
	jmp	fjge_cont.41863
fjge_else.41862:
	addi	%g15, %g0, 1
fjge_cont.41863:
jeq_cont.41861:
	addi	%g9, %g0, 4
	sti	%g3, %g1, 40
	mov	%g3, %g9
	fmov	%f0, %f16
	subi	%g1, %g1, 52
	call	min_caml_create_float_array
	addi	%g1, %g1, 52
	mov	%g9, %g3
	mov	%g4, %g2
	addi	%g2, %g2, 44
	sti	%g9, %g4, -40
	ldi	%g3, %g1, 40
	sti	%g3, %g4, -36
	ldi	%g14, %g1, 36
	sti	%g14, %g4, -32
	ldi	%g13, %g1, 32
	sti	%g13, %g4, -28
	sti	%g15, %g4, -24
	ldi	%g10, %g1, 24
	sti	%g10, %g4, -20
	ldi	%g5, %g1, 20
	sti	%g5, %g4, -16
	ldi	%g7, %g1, 16
	sti	%g7, %g4, -12
	ldi	%g12, %g1, 12
	sti	%g12, %g4, -8
	sti	%g6, %g4, -4
	ldi	%g11, %g1, 4
	sti	%g11, %g4, 0
	ldi	%g8, %g1, 0
	slli	%g9, %g8, 2
	add	%g9, %g31, %g9
	sti	%g4, %g9, 272
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.41864
	fldi	%f1, %g5, 0
	fjeq	%f1, %f16, fjne_else.41866
	fjeq	%f1, %f16, fjne_else.41868
	fjlt	%f16, %f1, fjge_else.41870
	setL %g4, l.35940
	fldi	%f0, %g4, 0
	jmp	fjge_cont.41871
fjge_else.41870:
	setL %g4, l.35549
	fldi	%f0, %g4, 0
fjge_cont.41871:
	jmp	fjne_cont.41869
fjne_else.41868:
	fmov	%f0, %f16
fjne_cont.41869:
	fmul	%f1, %f1, %f1
	fdiv	%f0, %f0, %f1
	jmp	fjne_cont.41867
fjne_else.41866:
	fmov	%f0, %f16
fjne_cont.41867:
	fsti	%f0, %g5, 0
	fldi	%f1, %g5, -4
	fjeq	%f1, %f16, fjne_else.41872
	fjeq	%f1, %f16, fjne_else.41874
	fjlt	%f16, %f1, fjge_else.41876
	setL %g4, l.35940
	fldi	%f0, %g4, 0
	jmp	fjge_cont.41877
fjge_else.41876:
	setL %g4, l.35549
	fldi	%f0, %g4, 0
fjge_cont.41877:
	jmp	fjne_cont.41875
fjne_else.41874:
	fmov	%f0, %f16
fjne_cont.41875:
	fmul	%f1, %f1, %f1
	fdiv	%f0, %f0, %f1
	jmp	fjne_cont.41873
fjne_else.41872:
	fmov	%f0, %f16
fjne_cont.41873:
	fsti	%f0, %g5, -4
	fldi	%f1, %g5, -8
	fjeq	%f1, %f16, fjne_else.41878
	fjeq	%f1, %f16, fjne_else.41880
	fjlt	%f16, %f1, fjge_else.41882
	setL %g4, l.35940
	fldi	%f0, %g4, 0
	jmp	fjge_cont.41883
fjge_else.41882:
	setL %g4, l.35549
	fldi	%f0, %g4, 0
fjge_cont.41883:
	jmp	fjne_cont.41881
fjne_else.41880:
	fmov	%f0, %f16
fjne_cont.41881:
	fmul	%f1, %f1, %f1
	fdiv	%f0, %f0, %f1
	jmp	fjne_cont.41879
fjne_else.41878:
	fmov	%f0, %f16
fjne_cont.41879:
	fsti	%f0, %g5, -8
	jmp	jeq_cont.41865
jeq_else.41864:
	addi	%g4, %g0, 2
	jne	%g6, %g4, jeq_else.41884
	fldi	%f1, %g5, 0
	fmul	%f3, %f1, %f1
	fldi	%f0, %g5, -4
	fmul	%f0, %f0, %f0
	fadd	%f3, %f3, %f0
	fldi	%f0, %g5, -8
	fmul	%f0, %f0, %f0
	fadd	%f0, %f3, %f0
	fsqrt	%f3, %f0
	fjeq	%f3, %f16, fjne_else.41886
	fldi	%f2, %g1, 28
	fjlt	%f2, %f16, fjge_else.41888
	fdiv	%f0, %f20, %f3
	jmp	fjge_cont.41889
fjge_else.41888:
	fdiv	%f0, %f17, %f3
fjge_cont.41889:
	jmp	fjne_cont.41887
fjne_else.41886:
	setL %g4, l.35549
	fldi	%f0, %g4, 0
fjne_cont.41887:
	fmul	%f1, %f1, %f0
	fsti	%f1, %g5, 0
	fldi	%f1, %g5, -4
	fmul	%f1, %f1, %f0
	fsti	%f1, %g5, -4
	fldi	%f1, %g5, -8
	fmul	%f0, %f1, %f0
	fsti	%f0, %g5, -8
	jmp	jeq_cont.41885
jeq_else.41884:
jeq_cont.41885:
jeq_cont.41865:
	jne	%g7, %g0, jeq_else.41890
	jmp	jeq_cont.41891
jeq_else.41890:
	fldi	%f3, %g3, 0
	fsub	%f2, %f22, %f3
	setL %g4, l.35391
	fldi	%f4, %g4, 0
	setL %g4, l.35393
	fldi	%f14, %g4, 0
	fjlt	%f2, %f16, fjge_else.41892
	fmov	%f1, %f2
	jmp	fjge_cont.41893
fjge_else.41892:
	fneg	%f1, %f2
fjge_cont.41893:
	fjlt	%f29, %f1, fjge_else.41894
	fjlt	%f1, %f16, fjge_else.41896
	fmov	%f0, %f1
	jmp	fjge_cont.41897
fjge_else.41896:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41898
	fjlt	%f1, %f16, fjge_else.41900
	fmov	%f0, %f1
	jmp	fjge_cont.41901
fjge_else.41900:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41902
	fjlt	%f1, %f16, fjge_else.41904
	fmov	%f0, %f1
	jmp	fjge_cont.41905
fjge_else.41904:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 52
	call	sin_sub.2480
	addi	%g1, %g1, 52
fjge_cont.41905:
	jmp	fjge_cont.41903
fjge_else.41902:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 52
	call	sin_sub.2480
	addi	%g1, %g1, 52
fjge_cont.41903:
fjge_cont.41901:
	jmp	fjge_cont.41899
fjge_else.41898:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41906
	fjlt	%f1, %f16, fjge_else.41908
	fmov	%f0, %f1
	jmp	fjge_cont.41909
fjge_else.41908:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 52
	call	sin_sub.2480
	addi	%g1, %g1, 52
fjge_cont.41909:
	jmp	fjge_cont.41907
fjge_else.41906:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 52
	call	sin_sub.2480
	addi	%g1, %g1, 52
fjge_cont.41907:
fjge_cont.41899:
fjge_cont.41897:
	jmp	fjge_cont.41895
fjge_else.41894:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41910
	fjlt	%f1, %f16, fjge_else.41912
	fmov	%f0, %f1
	jmp	fjge_cont.41913
fjge_else.41912:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41914
	fjlt	%f1, %f16, fjge_else.41916
	fmov	%f0, %f1
	jmp	fjge_cont.41917
fjge_else.41916:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 52
	call	sin_sub.2480
	addi	%g1, %g1, 52
fjge_cont.41917:
	jmp	fjge_cont.41915
fjge_else.41914:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 52
	call	sin_sub.2480
	addi	%g1, %g1, 52
fjge_cont.41915:
fjge_cont.41913:
	jmp	fjge_cont.41911
fjge_else.41910:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41918
	fjlt	%f1, %f16, fjge_else.41920
	fmov	%f0, %f1
	jmp	fjge_cont.41921
fjge_else.41920:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 52
	call	sin_sub.2480
	addi	%g1, %g1, 52
fjge_cont.41921:
	jmp	fjge_cont.41919
fjge_else.41918:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 52
	call	sin_sub.2480
	addi	%g1, %g1, 52
fjge_cont.41919:
fjge_cont.41911:
fjge_cont.41895:
	fjlt	%f4, %f0, fjge_else.41922
	fjlt	%f16, %f2, fjge_else.41924
	addi	%g4, %g0, 0
	jmp	fjge_cont.41925
fjge_else.41924:
	addi	%g4, %g0, 1
fjge_cont.41925:
	jmp	fjge_cont.41923
fjge_else.41922:
	fjlt	%f16, %f2, fjge_else.41926
	addi	%g4, %g0, 1
	jmp	fjge_cont.41927
fjge_else.41926:
	addi	%g4, %g0, 0
fjge_cont.41927:
fjge_cont.41923:
	fjlt	%f4, %f0, fjge_else.41928
	fmov	%f1, %f0
	jmp	fjge_cont.41929
fjge_else.41928:
	fsub	%f1, %f29, %f0
fjge_cont.41929:
	fjlt	%f22, %f1, fjge_else.41930
	fmov	%f0, %f1
	jmp	fjge_cont.41931
fjge_else.41930:
	fsub	%f0, %f4, %f1
fjge_cont.41931:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f14, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g4, %g0, jeq_else.41932
	fneg	%f15, %f0
	jmp	jeq_cont.41933
jeq_else.41932:
	fmov	%f15, %f0
jeq_cont.41933:
	fjlt	%f3, %f16, fjge_else.41934
	fmov	%f1, %f3
	jmp	fjge_cont.41935
fjge_else.41934:
	fneg	%f1, %f3
fjge_cont.41935:
	fsti	%f15, %g1, 48
	fjlt	%f29, %f1, fjge_else.41936
	fjlt	%f1, %f16, fjge_else.41938
	fmov	%f0, %f1
	jmp	fjge_cont.41939
fjge_else.41938:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41940
	fjlt	%f1, %f16, fjge_else.41942
	fmov	%f0, %f1
	jmp	fjge_cont.41943
fjge_else.41942:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41944
	fjlt	%f1, %f16, fjge_else.41946
	fmov	%f0, %f1
	jmp	fjge_cont.41947
fjge_else.41946:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.41947:
	jmp	fjge_cont.41945
fjge_else.41944:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.41945:
fjge_cont.41943:
	jmp	fjge_cont.41941
fjge_else.41940:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41948
	fjlt	%f1, %f16, fjge_else.41950
	fmov	%f0, %f1
	jmp	fjge_cont.41951
fjge_else.41950:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.41951:
	jmp	fjge_cont.41949
fjge_else.41948:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.41949:
fjge_cont.41941:
fjge_cont.41939:
	jmp	fjge_cont.41937
fjge_else.41936:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41952
	fjlt	%f1, %f16, fjge_else.41954
	fmov	%f0, %f1
	jmp	fjge_cont.41955
fjge_else.41954:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41956
	fjlt	%f1, %f16, fjge_else.41958
	fmov	%f0, %f1
	jmp	fjge_cont.41959
fjge_else.41958:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.41959:
	jmp	fjge_cont.41957
fjge_else.41956:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.41957:
fjge_cont.41955:
	jmp	fjge_cont.41953
fjge_else.41952:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41960
	fjlt	%f1, %f16, fjge_else.41962
	fmov	%f0, %f1
	jmp	fjge_cont.41963
fjge_else.41962:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.41963:
	jmp	fjge_cont.41961
fjge_else.41960:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.41961:
fjge_cont.41953:
fjge_cont.41937:
	fjlt	%f4, %f0, fjge_else.41964
	fjlt	%f16, %f3, fjge_else.41966
	addi	%g4, %g0, 0
	jmp	fjge_cont.41967
fjge_else.41966:
	addi	%g4, %g0, 1
fjge_cont.41967:
	jmp	fjge_cont.41965
fjge_else.41964:
	fjlt	%f16, %f3, fjge_else.41968
	addi	%g4, %g0, 1
	jmp	fjge_cont.41969
fjge_else.41968:
	addi	%g4, %g0, 0
fjge_cont.41969:
fjge_cont.41965:
	fjlt	%f4, %f0, fjge_else.41970
	fmov	%f1, %f0
	jmp	fjge_cont.41971
fjge_else.41970:
	fsub	%f1, %f29, %f0
fjge_cont.41971:
	fjlt	%f22, %f1, fjge_else.41972
	fmov	%f0, %f1
	jmp	fjge_cont.41973
fjge_else.41972:
	fsub	%f0, %f4, %f1
fjge_cont.41973:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f14, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g4, %g0, jeq_else.41974
	fneg	%f7, %f0
	jmp	jeq_cont.41975
jeq_else.41974:
	fmov	%f7, %f0
jeq_cont.41975:
	fldi	%f3, %g3, -4
	fsub	%f2, %f22, %f3
	fjlt	%f2, %f16, fjge_else.41976
	fmov	%f1, %f2
	jmp	fjge_cont.41977
fjge_else.41976:
	fneg	%f1, %f2
fjge_cont.41977:
	fjlt	%f29, %f1, fjge_else.41978
	fjlt	%f1, %f16, fjge_else.41980
	fmov	%f0, %f1
	jmp	fjge_cont.41981
fjge_else.41980:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41982
	fjlt	%f1, %f16, fjge_else.41984
	fmov	%f0, %f1
	jmp	fjge_cont.41985
fjge_else.41984:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41986
	fjlt	%f1, %f16, fjge_else.41988
	fmov	%f0, %f1
	jmp	fjge_cont.41989
fjge_else.41988:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.41989:
	jmp	fjge_cont.41987
fjge_else.41986:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.41987:
fjge_cont.41985:
	jmp	fjge_cont.41983
fjge_else.41982:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41990
	fjlt	%f1, %f16, fjge_else.41992
	fmov	%f0, %f1
	jmp	fjge_cont.41993
fjge_else.41992:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.41993:
	jmp	fjge_cont.41991
fjge_else.41990:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.41991:
fjge_cont.41983:
fjge_cont.41981:
	jmp	fjge_cont.41979
fjge_else.41978:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41994
	fjlt	%f1, %f16, fjge_else.41996
	fmov	%f0, %f1
	jmp	fjge_cont.41997
fjge_else.41996:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.41998
	fjlt	%f1, %f16, fjge_else.42000
	fmov	%f0, %f1
	jmp	fjge_cont.42001
fjge_else.42000:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42001:
	jmp	fjge_cont.41999
fjge_else.41998:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.41999:
fjge_cont.41997:
	jmp	fjge_cont.41995
fjge_else.41994:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42002
	fjlt	%f1, %f16, fjge_else.42004
	fmov	%f0, %f1
	jmp	fjge_cont.42005
fjge_else.42004:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42005:
	jmp	fjge_cont.42003
fjge_else.42002:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42003:
fjge_cont.41995:
fjge_cont.41979:
	fjlt	%f4, %f0, fjge_else.42006
	fjlt	%f16, %f2, fjge_else.42008
	addi	%g4, %g0, 0
	jmp	fjge_cont.42009
fjge_else.42008:
	addi	%g4, %g0, 1
fjge_cont.42009:
	jmp	fjge_cont.42007
fjge_else.42006:
	fjlt	%f16, %f2, fjge_else.42010
	addi	%g4, %g0, 1
	jmp	fjge_cont.42011
fjge_else.42010:
	addi	%g4, %g0, 0
fjge_cont.42011:
fjge_cont.42007:
	fjlt	%f4, %f0, fjge_else.42012
	fmov	%f1, %f0
	jmp	fjge_cont.42013
fjge_else.42012:
	fsub	%f1, %f29, %f0
fjge_cont.42013:
	fjlt	%f22, %f1, fjge_else.42014
	fmov	%f0, %f1
	jmp	fjge_cont.42015
fjge_else.42014:
	fsub	%f0, %f4, %f1
fjge_cont.42015:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f1, %f1, %f0
	fmul	%f0, %f14, %f1
	fmul	%f1, %f1, %f1
	fadd	%f1, %f17, %f1
	fdiv	%f0, %f0, %f1
	jne	%g4, %g0, jeq_else.42016
	fneg	%f13, %f0
	jmp	jeq_cont.42017
jeq_else.42016:
	fmov	%f13, %f0
jeq_cont.42017:
	fjlt	%f3, %f16, fjge_else.42018
	fmov	%f1, %f3
	jmp	fjge_cont.42019
fjge_else.42018:
	fneg	%f1, %f3
fjge_cont.42019:
	fjlt	%f29, %f1, fjge_else.42020
	fjlt	%f1, %f16, fjge_else.42022
	fmov	%f0, %f1
	jmp	fjge_cont.42023
fjge_else.42022:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42024
	fjlt	%f1, %f16, fjge_else.42026
	fmov	%f0, %f1
	jmp	fjge_cont.42027
fjge_else.42026:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42028
	fjlt	%f1, %f16, fjge_else.42030
	fmov	%f0, %f1
	jmp	fjge_cont.42031
fjge_else.42030:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42031:
	jmp	fjge_cont.42029
fjge_else.42028:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42029:
fjge_cont.42027:
	jmp	fjge_cont.42025
fjge_else.42024:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42032
	fjlt	%f1, %f16, fjge_else.42034
	fmov	%f0, %f1
	jmp	fjge_cont.42035
fjge_else.42034:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42035:
	jmp	fjge_cont.42033
fjge_else.42032:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42033:
fjge_cont.42025:
fjge_cont.42023:
	jmp	fjge_cont.42021
fjge_else.42020:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42036
	fjlt	%f1, %f16, fjge_else.42038
	fmov	%f0, %f1
	jmp	fjge_cont.42039
fjge_else.42038:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42040
	fjlt	%f1, %f16, fjge_else.42042
	fmov	%f0, %f1
	jmp	fjge_cont.42043
fjge_else.42042:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42043:
	jmp	fjge_cont.42041
fjge_else.42040:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42041:
fjge_cont.42039:
	jmp	fjge_cont.42037
fjge_else.42036:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42044
	fjlt	%f1, %f16, fjge_else.42046
	fmov	%f0, %f1
	jmp	fjge_cont.42047
fjge_else.42046:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42047:
	jmp	fjge_cont.42045
fjge_else.42044:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42045:
fjge_cont.42037:
fjge_cont.42021:
	fjlt	%f4, %f0, fjge_else.42048
	fjlt	%f16, %f3, fjge_else.42050
	addi	%g4, %g0, 0
	jmp	fjge_cont.42051
fjge_else.42050:
	addi	%g4, %g0, 1
fjge_cont.42051:
	jmp	fjge_cont.42049
fjge_else.42048:
	fjlt	%f16, %f3, fjge_else.42052
	addi	%g4, %g0, 1
	jmp	fjge_cont.42053
fjge_else.42052:
	addi	%g4, %g0, 0
fjge_cont.42053:
fjge_cont.42049:
	fjlt	%f4, %f0, fjge_else.42054
	fmov	%f1, %f0
	jmp	fjge_cont.42055
fjge_else.42054:
	fsub	%f1, %f29, %f0
fjge_cont.42055:
	fjlt	%f22, %f1, fjge_else.42056
	fmov	%f0, %f1
	jmp	fjge_cont.42057
fjge_else.42056:
	fsub	%f0, %f4, %f1
fjge_cont.42057:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f1, %f1, %f0
	fmul	%f0, %f14, %f1
	fmul	%f1, %f1, %f1
	fadd	%f1, %f17, %f1
	fdiv	%f0, %f0, %f1
	jne	%g4, %g0, jeq_else.42058
	fneg	%f9, %f0
	jmp	jeq_cont.42059
jeq_else.42058:
	fmov	%f9, %f0
jeq_cont.42059:
	fldi	%f3, %g3, -8
	fsub	%f2, %f22, %f3
	fjlt	%f2, %f16, fjge_else.42060
	fmov	%f1, %f2
	jmp	fjge_cont.42061
fjge_else.42060:
	fneg	%f1, %f2
fjge_cont.42061:
	fjlt	%f29, %f1, fjge_else.42062
	fjlt	%f1, %f16, fjge_else.42064
	fmov	%f0, %f1
	jmp	fjge_cont.42065
fjge_else.42064:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42066
	fjlt	%f1, %f16, fjge_else.42068
	fmov	%f0, %f1
	jmp	fjge_cont.42069
fjge_else.42068:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42070
	fjlt	%f1, %f16, fjge_else.42072
	fmov	%f0, %f1
	jmp	fjge_cont.42073
fjge_else.42072:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42073:
	jmp	fjge_cont.42071
fjge_else.42070:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42071:
fjge_cont.42069:
	jmp	fjge_cont.42067
fjge_else.42066:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42074
	fjlt	%f1, %f16, fjge_else.42076
	fmov	%f0, %f1
	jmp	fjge_cont.42077
fjge_else.42076:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42077:
	jmp	fjge_cont.42075
fjge_else.42074:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42075:
fjge_cont.42067:
fjge_cont.42065:
	jmp	fjge_cont.42063
fjge_else.42062:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42078
	fjlt	%f1, %f16, fjge_else.42080
	fmov	%f0, %f1
	jmp	fjge_cont.42081
fjge_else.42080:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42082
	fjlt	%f1, %f16, fjge_else.42084
	fmov	%f0, %f1
	jmp	fjge_cont.42085
fjge_else.42084:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42085:
	jmp	fjge_cont.42083
fjge_else.42082:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42083:
fjge_cont.42081:
	jmp	fjge_cont.42079
fjge_else.42078:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42086
	fjlt	%f1, %f16, fjge_else.42088
	fmov	%f0, %f1
	jmp	fjge_cont.42089
fjge_else.42088:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42089:
	jmp	fjge_cont.42087
fjge_else.42086:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42087:
fjge_cont.42079:
fjge_cont.42063:
	fjlt	%f4, %f0, fjge_else.42090
	fjlt	%f16, %f2, fjge_else.42092
	addi	%g4, %g0, 0
	jmp	fjge_cont.42093
fjge_else.42092:
	addi	%g4, %g0, 1
fjge_cont.42093:
	jmp	fjge_cont.42091
fjge_else.42090:
	fjlt	%f16, %f2, fjge_else.42094
	addi	%g4, %g0, 1
	jmp	fjge_cont.42095
fjge_else.42094:
	addi	%g4, %g0, 0
fjge_cont.42095:
fjge_cont.42091:
	fjlt	%f4, %f0, fjge_else.42096
	fmov	%f1, %f0
	jmp	fjge_cont.42097
fjge_else.42096:
	fsub	%f1, %f29, %f0
fjge_cont.42097:
	fjlt	%f22, %f1, fjge_else.42098
	fmov	%f0, %f1
	jmp	fjge_cont.42099
fjge_else.42098:
	fsub	%f0, %f4, %f1
fjge_cont.42099:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f14, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g4, %g0, jeq_else.42100
	fneg	%f2, %f0
	jmp	jeq_cont.42101
jeq_else.42100:
	fmov	%f2, %f0
jeq_cont.42101:
	fjlt	%f3, %f16, fjge_else.42102
	fmov	%f1, %f3
	jmp	fjge_cont.42103
fjge_else.42102:
	fneg	%f1, %f3
fjge_cont.42103:
	fjlt	%f29, %f1, fjge_else.42104
	fjlt	%f1, %f16, fjge_else.42106
	fmov	%f0, %f1
	jmp	fjge_cont.42107
fjge_else.42106:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42108
	fjlt	%f1, %f16, fjge_else.42110
	fmov	%f0, %f1
	jmp	fjge_cont.42111
fjge_else.42110:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42112
	fjlt	%f1, %f16, fjge_else.42114
	fmov	%f0, %f1
	jmp	fjge_cont.42115
fjge_else.42114:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42115:
	jmp	fjge_cont.42113
fjge_else.42112:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42113:
fjge_cont.42111:
	jmp	fjge_cont.42109
fjge_else.42108:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42116
	fjlt	%f1, %f16, fjge_else.42118
	fmov	%f0, %f1
	jmp	fjge_cont.42119
fjge_else.42118:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42119:
	jmp	fjge_cont.42117
fjge_else.42116:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42117:
fjge_cont.42109:
fjge_cont.42107:
	jmp	fjge_cont.42105
fjge_else.42104:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42120
	fjlt	%f1, %f16, fjge_else.42122
	fmov	%f0, %f1
	jmp	fjge_cont.42123
fjge_else.42122:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42124
	fjlt	%f1, %f16, fjge_else.42126
	fmov	%f0, %f1
	jmp	fjge_cont.42127
fjge_else.42126:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42127:
	jmp	fjge_cont.42125
fjge_else.42124:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42125:
fjge_cont.42123:
	jmp	fjge_cont.42121
fjge_else.42120:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42128
	fjlt	%f1, %f16, fjge_else.42130
	fmov	%f0, %f1
	jmp	fjge_cont.42131
fjge_else.42130:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42131:
	jmp	fjge_cont.42129
fjge_else.42128:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2480
	addi	%g1, %g1, 56
fjge_cont.42129:
fjge_cont.42121:
fjge_cont.42105:
	fjlt	%f4, %f0, fjge_else.42132
	fjlt	%f16, %f3, fjge_else.42134
	addi	%g4, %g0, 0
	jmp	fjge_cont.42135
fjge_else.42134:
	addi	%g4, %g0, 1
fjge_cont.42135:
	jmp	fjge_cont.42133
fjge_else.42132:
	fjlt	%f16, %f3, fjge_else.42136
	addi	%g4, %g0, 1
	jmp	fjge_cont.42137
fjge_else.42136:
	addi	%g4, %g0, 0
fjge_cont.42137:
fjge_cont.42133:
	fjlt	%f4, %f0, fjge_else.42138
	fmov	%f1, %f0
	jmp	fjge_cont.42139
fjge_else.42138:
	fsub	%f1, %f29, %f0
fjge_cont.42139:
	fjlt	%f22, %f1, fjge_else.42140
	fmov	%f0, %f1
	jmp	fjge_cont.42141
fjge_else.42140:
	fsub	%f0, %f4, %f1
fjge_cont.42141:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f3, %f0, %f25
	fsub	%f3, %f26, %f3
	fdiv	%f3, %f0, %f3
	fsub	%f3, %f24, %f3
	fdiv	%f3, %f0, %f3
	fsub	%f3, %f23, %f3
	fdiv	%f0, %f0, %f3
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f14, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f1, %f0
	jne	%g4, %g0, jeq_else.42142
	fneg	%f0, %f1
	jmp	jeq_cont.42143
jeq_else.42142:
	fmov	%f0, %f1
jeq_cont.42143:
	fmul	%f12, %f13, %f2
	fmul	%f5, %f7, %f9
	fmul	%f3, %f5, %f2
	fldi	%f15, %g1, 48
	fmul	%f1, %f15, %f0
	fsub	%f10, %f3, %f1
	fmul	%f1, %f15, %f9
	fmul	%f4, %f1, %f2
	fmul	%f3, %f7, %f0
	fadd	%f6, %f4, %f3
	fmul	%f11, %f13, %f0
	fmul	%f4, %f5, %f0
	fmul	%f3, %f15, %f2
	fadd	%f8, %f4, %f3
	fmul	%f1, %f1, %f0
	fmul	%f0, %f7, %f2
	fsub	%f5, %f1, %f0
	fneg	%f9, %f9
	fmul	%f7, %f7, %f13
	fmul	%f4, %f15, %f13
	fldi	%f0, %g5, 0
	fldi	%f2, %g5, -4
	fldi	%f3, %g5, -8
	fmul	%f1, %f12, %f12
	fmul	%f13, %f0, %f1
	fmul	%f1, %f11, %f11
	fmul	%f1, %f2, %f1
	fadd	%f13, %f13, %f1
	fmul	%f1, %f9, %f9
	fmul	%f1, %f3, %f1
	fadd	%f1, %f13, %f1
	fsti	%f1, %g5, 0
	fmul	%f1, %f10, %f10
	fmul	%f13, %f0, %f1
	fmul	%f1, %f8, %f8
	fmul	%f1, %f2, %f1
	fadd	%f13, %f13, %f1
	fmul	%f1, %f7, %f7
	fmul	%f1, %f3, %f1
	fadd	%f1, %f13, %f1
	fsti	%f1, %g5, -4
	fmul	%f1, %f6, %f6
	fmul	%f13, %f0, %f1
	fmul	%f1, %f5, %f5
	fmul	%f1, %f2, %f1
	fadd	%f13, %f13, %f1
	fmul	%f1, %f4, %f4
	fmul	%f1, %f3, %f1
	fadd	%f1, %f13, %f1
	fsti	%f1, %g5, -8
	fmul	%f1, %f0, %f10
	fmul	%f13, %f1, %f6
	fmul	%f1, %f2, %f8
	fmul	%f1, %f1, %f5
	fadd	%f13, %f13, %f1
	fmul	%f1, %f3, %f7
	fmul	%f1, %f1, %f4
	fadd	%f1, %f13, %f1
	fmul	%f1, %f14, %f1
	fsti	%f1, %g3, 0
	fmul	%f1, %f0, %f12
	fmul	%f6, %f1, %f6
	fmul	%f0, %f2, %f11
	fmul	%f2, %f0, %f5
	fadd	%f5, %f6, %f2
	fmul	%f3, %f3, %f9
	fmul	%f2, %f3, %f4
	fadd	%f2, %f5, %f2
	fmul	%f2, %f14, %f2
	fsti	%f2, %g3, -4
	fmul	%f1, %f1, %f10
	fmul	%f0, %f0, %f8
	fadd	%f1, %f1, %f0
	fmul	%f0, %f3, %f7
	fadd	%f0, %f1, %f0
	fmul	%f0, %f14, %f0
	fsti	%f0, %g3, -8
jeq_cont.41891:
	addi	%g3, %g0, 1
jeq_cont.41857:
	jne	%g3, %g0, jeq_else.42144
	ldi	%g8, %g1, 0
	sti	%g8, %g31, 28
	return
jeq_else.42144:
	ldi	%g8, %g1, 0
	addi	%g8, %g8, 1
	jmp	read_object.2673

!==============================
! args = [%g4]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Array(Int)
!================================
read_net_item.2677:
	sti	%g4, %g1, 0
	inputw	%g5
	jne	%g5, %g29, jeq_else.42146
	ldi	%g4, %g1, 0
	addi	%g3, %g4, 1
	addi	%g4, %g0, -1
	jmp	min_caml_create_array
jeq_else.42146:
	ldi	%g4, %g1, 0
	addi	%g3, %g4, 1
	sti	%g5, %g1, 4
	mov	%g4, %g3
	subi	%g1, %g1, 12
	call	read_net_item.2677
	addi	%g1, %g1, 12
	ldi	%g4, %g1, 0
	slli	%g4, %g4, 2
	ldi	%g5, %g1, 4
	st	%g5, %g3, %g4
	return

!==============================
! args = [%g4]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Array(Array(Int))
!================================
read_or_network.2679:
	addi	%g3, %g0, 0
	sti	%g4, %g1, 0
	mov	%g4, %g3
	subi	%g1, %g1, 8
	call	read_net_item.2677
	addi	%g1, %g1, 8
	mov	%g6, %g3
	ldi	%g3, %g6, 0
	jne	%g3, %g29, jeq_else.42147
	ldi	%g4, %g1, 0
	addi	%g3, %g4, 1
	mov	%g4, %g6
	jmp	min_caml_create_array
jeq_else.42147:
	ldi	%g4, %g1, 0
	addi	%g3, %g4, 1
	sti	%g6, %g1, 4
	mov	%g4, %g3
	subi	%g1, %g1, 12
	call	read_or_network.2679
	addi	%g1, %g1, 12
	ldi	%g4, %g1, 0
	slli	%g4, %g4, 2
	ldi	%g6, %g1, 4
	st	%g6, %g3, %g4
	return

!==============================
! args = [%g3]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
read_and_network.2681:
	addi	%g4, %g0, 0
	sti	%g3, %g1, 0
	subi	%g1, %g1, 8
	call	read_net_item.2677
	addi	%g1, %g1, 8
	mov	%g4, %g3
	ldi	%g5, %g4, 0
	jne	%g5, %g29, jeq_else.42148
	return
jeq_else.42148:
	ldi	%g3, %g1, 0
	slli	%g5, %g3, 2
	add	%g5, %g31, %g5
	sti	%g4, %g5, 512
	addi	%g3, %g3, 1
	jmp	read_and_network.2681

!==============================
! args = [%g7, %g6, %g5]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g10, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f20, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
iter_setup_dirvec_constants.2778:
	jlt	%g5, %g0, jge_else.42150
	slli	%g3, %g5, 2
	add	%g3, %g31, %g3
	ldi	%g9, %g3, 272
	ldi	%g3, %g9, -4
	jne	%g3, %g28, jeq_else.42151
	addi	%g3, %g0, 6
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	fldi	%f0, %g7, 0
	fjeq	%f0, %f16, fjne_else.42153
	ldi	%g4, %g9, -24
	fjlt	%f0, %f16, fjge_else.42155
	addi	%g10, %g0, 0
	jmp	fjge_cont.42156
fjge_else.42155:
	addi	%g10, %g0, 1
fjge_cont.42156:
	ldi	%g8, %g9, -16
	fldi	%f1, %g8, 0
	jne	%g4, %g10, jeq_else.42157
	fneg	%f0, %f1
	jmp	jeq_cont.42158
jeq_else.42157:
	fmov	%f0, %f1
jeq_cont.42158:
	fsti	%f0, %g3, 0
	fldi	%f0, %g7, 0
	fdiv	%f0, %f17, %f0
	fsti	%f0, %g3, -4
	jmp	fjne_cont.42154
fjne_else.42153:
	fsti	%f16, %g3, -4
fjne_cont.42154:
	fldi	%f0, %g7, -4
	fjeq	%f0, %f16, fjne_else.42159
	ldi	%g4, %g9, -24
	fjlt	%f0, %f16, fjge_else.42161
	addi	%g10, %g0, 0
	jmp	fjge_cont.42162
fjge_else.42161:
	addi	%g10, %g0, 1
fjge_cont.42162:
	ldi	%g8, %g9, -16
	fldi	%f1, %g8, -4
	jne	%g4, %g10, jeq_else.42163
	fneg	%f0, %f1
	jmp	jeq_cont.42164
jeq_else.42163:
	fmov	%f0, %f1
jeq_cont.42164:
	fsti	%f0, %g3, -8
	fldi	%f0, %g7, -4
	fdiv	%f0, %f17, %f0
	fsti	%f0, %g3, -12
	jmp	fjne_cont.42160
fjne_else.42159:
	fsti	%f16, %g3, -12
fjne_cont.42160:
	fldi	%f0, %g7, -8
	fjeq	%f0, %f16, fjne_else.42165
	ldi	%g4, %g9, -24
	fjlt	%f0, %f16, fjge_else.42167
	addi	%g10, %g0, 0
	jmp	fjge_cont.42168
fjge_else.42167:
	addi	%g10, %g0, 1
fjge_cont.42168:
	ldi	%g8, %g9, -16
	fldi	%f1, %g8, -8
	jne	%g4, %g10, jeq_else.42169
	fneg	%f0, %f1
	jmp	jeq_cont.42170
jeq_else.42169:
	fmov	%f0, %f1
jeq_cont.42170:
	fsti	%f0, %g3, -16
	fldi	%f0, %g7, -8
	fdiv	%f0, %f17, %f0
	fsti	%f0, %g3, -20
	jmp	fjne_cont.42166
fjne_else.42165:
	fsti	%f16, %g3, -20
fjne_cont.42166:
	slli	%g4, %g5, 2
	st	%g3, %g6, %g4
	jmp	jeq_cont.42152
jeq_else.42151:
	addi	%g4, %g0, 2
	jne	%g3, %g4, jeq_else.42171
	addi	%g3, %g0, 4
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	fldi	%f1, %g7, 0
	ldi	%g4, %g9, -16
	fldi	%f0, %g4, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g7, -4
	fldi	%f0, %g4, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g7, -8
	fldi	%f0, %g4, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f16, %f0, fjge_else.42173
	fsti	%f16, %g3, 0
	jmp	fjge_cont.42174
fjge_else.42173:
	fdiv	%f1, %f20, %f0
	fsti	%f1, %g3, 0
	fldi	%f1, %g4, 0
	fdiv	%f1, %f1, %f0
	fneg	%f1, %f1
	fsti	%f1, %g3, -4
	fldi	%f1, %g4, -4
	fdiv	%f1, %f1, %f0
	fneg	%f1, %f1
	fsti	%f1, %g3, -8
	fldi	%f1, %g4, -8
	fdiv	%f0, %f1, %f0
	fneg	%f0, %f0
	fsti	%f0, %g3, -12
fjge_cont.42174:
	slli	%g4, %g5, 2
	st	%g3, %g6, %g4
	jmp	jeq_cont.42172
jeq_else.42171:
	addi	%g3, %g0, 5
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	fldi	%f0, %g7, 0
	fldi	%f1, %g7, -4
	fldi	%f2, %g7, -8
	fmul	%f3, %f0, %f0
	ldi	%g4, %g9, -16
	fldi	%f5, %g4, 0
	fmul	%f4, %f3, %f5
	fmul	%f3, %f1, %f1
	fldi	%f6, %g4, -4
	fmul	%f3, %f3, %f6
	fadd	%f7, %f4, %f3
	fmul	%f3, %f2, %f2
	fldi	%f4, %g4, -8
	fmul	%f3, %f3, %f4
	fadd	%f7, %f7, %f3
	ldi	%g8, %g9, -12
	jne	%g8, %g0, jeq_else.42175
	fmov	%f3, %f7
	jmp	jeq_cont.42176
jeq_else.42175:
	fmul	%f8, %f1, %f2
	ldi	%g4, %g9, -36
	fldi	%f3, %g4, 0
	fmul	%f3, %f8, %f3
	fadd	%f8, %f7, %f3
	fmul	%f7, %f2, %f0
	fldi	%f3, %g4, -4
	fmul	%f3, %f7, %f3
	fadd	%f8, %f8, %f3
	fmul	%f7, %f0, %f1
	fldi	%f3, %g4, -8
	fmul	%f3, %f7, %f3
	fadd	%f3, %f8, %f3
jeq_cont.42176:
	fmul	%f0, %f0, %f5
	fneg	%f0, %f0
	fmul	%f1, %f1, %f6
	fneg	%f1, %f1
	fmul	%f2, %f2, %f4
	fneg	%f2, %f2
	fsti	%f3, %g3, 0
	jne	%g8, %g0, jeq_else.42177
	fsti	%f0, %g3, -4
	fsti	%f1, %g3, -8
	fsti	%f2, %g3, -12
	jmp	jeq_cont.42178
jeq_else.42177:
	fldi	%f5, %g7, -8
	ldi	%g4, %g9, -36
	fldi	%f4, %g4, -4
	fmul	%f6, %f5, %f4
	fldi	%f5, %g7, -4
	fldi	%f4, %g4, -8
	fmul	%f4, %f5, %f4
	fadd	%f4, %f6, %f4
	fmul	%f4, %f4, %f21
	fsub	%f0, %f0, %f4
	fsti	%f0, %g3, -4
	fldi	%f4, %g7, -8
	fldi	%f0, %g4, 0
	fmul	%f5, %f4, %f0
	fldi	%f4, %g7, 0
	fldi	%f0, %g4, -8
	fmul	%f0, %f4, %f0
	fadd	%f0, %f5, %f0
	fmul	%f0, %f0, %f21
	fsub	%f0, %f1, %f0
	fsti	%f0, %g3, -8
	fldi	%f1, %g7, -4
	fldi	%f0, %g4, 0
	fmul	%f4, %f1, %f0
	fldi	%f1, %g7, 0
	fldi	%f0, %g4, -4
	fmul	%f0, %f1, %f0
	fadd	%f0, %f4, %f0
	fmul	%f0, %f0, %f21
	fsub	%f0, %f2, %f0
	fsti	%f0, %g3, -12
jeq_cont.42178:
	fjeq	%f3, %f16, fjne_else.42179
	fdiv	%f0, %f17, %f3
	fsti	%f0, %g3, -16
	jmp	fjne_cont.42180
fjne_else.42179:
fjne_cont.42180:
	slli	%g4, %g5, 2
	st	%g3, %g6, %g4
jeq_cont.42172:
jeq_cont.42152:
	subi	%g5, %g5, 1
	jmp	iter_setup_dirvec_constants.2778
jge_else.42150:
	return

!==============================
! args = [%g3, %g4]
! fargs = []
! use_regs = [%g8, %g7, %g6, %g5, %g4, %g3, %g27, %f5, %f4, %f3, %f2, %f17, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
setup_startp_constants.2783:
	jlt	%g4, %g0, jge_else.42182
	slli	%g5, %g4, 2
	add	%g5, %g31, %g5
	ldi	%g5, %g5, 272
	ldi	%g8, %g5, -40
	ldi	%g7, %g5, -4
	fldi	%f1, %g3, 0
	ldi	%g6, %g5, -20
	fldi	%f0, %g6, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g8, 0
	fldi	%f1, %g3, -4
	fldi	%f0, %g6, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g8, -4
	fldi	%f1, %g3, -8
	fldi	%f0, %g6, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g8, -8
	addi	%g6, %g0, 2
	jne	%g7, %g6, jeq_else.42183
	ldi	%g5, %g5, -16
	fldi	%f1, %g8, 0
	fldi	%f3, %g8, -4
	fldi	%f2, %g8, -8
	fldi	%f0, %g5, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g5, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g5, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g8, -12
	jmp	jeq_cont.42184
jeq_else.42183:
	addi	%g6, %g0, 2
	jlt	%g6, %g7, jle_else.42185
	jmp	jle_cont.42186
jle_else.42185:
	fldi	%f2, %g8, 0
	fldi	%f1, %g8, -4
	fldi	%f0, %g8, -8
	fmul	%f4, %f2, %f2
	ldi	%g6, %g5, -16
	fldi	%f3, %g6, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g6, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g6, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g6, %g5, -12
	jne	%g6, %g0, jeq_else.42187
	fmov	%f3, %f4
	jmp	jeq_cont.42188
jeq_else.42187:
	fmul	%f5, %f1, %f0
	ldi	%g5, %g5, -36
	fldi	%f3, %g5, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g5, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g5, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.42188:
	addi	%g5, %g0, 3
	jne	%g7, %g5, jeq_else.42189
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.42190
jeq_else.42189:
	fmov	%f0, %f3
jeq_cont.42190:
	fsti	%f0, %g8, -12
jle_cont.42186:
jeq_cont.42184:
	subi	%g8, %g4, 1
	jlt	%g8, %g0, jge_else.42191
	slli	%g4, %g8, 2
	add	%g4, %g31, %g4
	ldi	%g4, %g4, 272
	ldi	%g7, %g4, -40
	ldi	%g6, %g4, -4
	fldi	%f1, %g3, 0
	ldi	%g5, %g4, -20
	fldi	%f0, %g5, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, 0
	fldi	%f1, %g3, -4
	fldi	%f0, %g5, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -4
	fldi	%f1, %g3, -8
	fldi	%f0, %g5, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -8
	addi	%g5, %g0, 2
	jne	%g6, %g5, jeq_else.42192
	ldi	%g4, %g4, -16
	fldi	%f1, %g7, 0
	fldi	%f3, %g7, -4
	fldi	%f2, %g7, -8
	fldi	%f0, %g4, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g4, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g7, -12
	jmp	jeq_cont.42193
jeq_else.42192:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.42194
	jmp	jle_cont.42195
jle_else.42194:
	fldi	%f2, %g7, 0
	fldi	%f1, %g7, -4
	fldi	%f0, %g7, -8
	fmul	%f4, %f2, %f2
	ldi	%g5, %g4, -16
	fldi	%f3, %g5, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g5, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g5, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g5, %g4, -12
	jne	%g5, %g0, jeq_else.42196
	fmov	%f3, %f4
	jmp	jeq_cont.42197
jeq_else.42196:
	fmul	%f5, %f1, %f0
	ldi	%g4, %g4, -36
	fldi	%f3, %g4, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g4, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g4, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.42197:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.42198
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.42199
jeq_else.42198:
	fmov	%f0, %f3
jeq_cont.42199:
	fsti	%f0, %g7, -12
jle_cont.42195:
jeq_cont.42193:
	subi	%g4, %g8, 1
	jmp	setup_startp_constants.2783
jge_else.42191:
	return
jge_else.42182:
	return

!==============================
! args = [%g5, %g4]
! fargs = [%f5, %f4, %f3]
! use_regs = [%g7, %g6, %g5, %g4, %g3, %g27, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0]
! ret type = Bool
!================================
check_all_inside.2808:
	slli	%g3, %g5, 2
	ld	%g6, %g4, %g3
	jne	%g6, %g29, jeq_else.42202
	addi	%g3, %g0, 1
	return
jeq_else.42202:
	slli	%g3, %g6, 2
	add	%g3, %g31, %g3
	ldi	%g7, %g3, 272
	ldi	%g3, %g7, -20
	fldi	%f0, %g3, 0
	fsub	%f0, %f5, %f0
	fldi	%f1, %g3, -4
	fsub	%f2, %f4, %f1
	fldi	%f1, %g3, -8
	fsub	%f1, %f3, %f1
	ldi	%g6, %g7, -4
	jne	%g6, %g28, jeq_else.42203
	fjlt	%f0, %f16, fjge_else.42205
	fmov	%f6, %f0
	jmp	fjge_cont.42206
fjge_else.42205:
	fneg	%f6, %f0
fjge_cont.42206:
	ldi	%g3, %g7, -16
	fldi	%f0, %g3, 0
	fjlt	%f6, %f0, fjge_else.42207
	addi	%g6, %g0, 0
	jmp	fjge_cont.42208
fjge_else.42207:
	fjlt	%f2, %f16, fjge_else.42209
	fmov	%f0, %f2
	jmp	fjge_cont.42210
fjge_else.42209:
	fneg	%f0, %f2
fjge_cont.42210:
	fldi	%f2, %g3, -4
	fjlt	%f0, %f2, fjge_else.42211
	addi	%g6, %g0, 0
	jmp	fjge_cont.42212
fjge_else.42211:
	fjlt	%f1, %f16, fjge_else.42213
	fmov	%f0, %f1
	jmp	fjge_cont.42214
fjge_else.42213:
	fneg	%f0, %f1
fjge_cont.42214:
	fldi	%f1, %g3, -8
	fjlt	%f0, %f1, fjge_else.42215
	addi	%g6, %g0, 0
	jmp	fjge_cont.42216
fjge_else.42215:
	addi	%g6, %g0, 1
fjge_cont.42216:
fjge_cont.42212:
fjge_cont.42208:
	jne	%g6, %g0, jeq_else.42217
	ldi	%g3, %g7, -24
	jne	%g3, %g0, jeq_else.42219
	addi	%g3, %g0, 1
	jmp	jeq_cont.42220
jeq_else.42219:
	addi	%g3, %g0, 0
jeq_cont.42220:
	jmp	jeq_cont.42218
jeq_else.42217:
	ldi	%g3, %g7, -24
jeq_cont.42218:
	jmp	jeq_cont.42204
jeq_else.42203:
	addi	%g3, %g0, 2
	jne	%g6, %g3, jeq_else.42221
	ldi	%g3, %g7, -16
	fldi	%f6, %g3, 0
	fmul	%f6, %f6, %f0
	fldi	%f0, %g3, -4
	fmul	%f0, %f0, %f2
	fadd	%f2, %f6, %f0
	fldi	%f0, %g3, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	ldi	%g3, %g7, -24
	fjlt	%f0, %f16, fjge_else.42223
	addi	%g6, %g0, 0
	jmp	fjge_cont.42224
fjge_else.42223:
	addi	%g6, %g0, 1
fjge_cont.42224:
	jne	%g3, %g6, jeq_else.42225
	addi	%g3, %g0, 1
	jmp	jeq_cont.42226
jeq_else.42225:
	addi	%g3, %g0, 0
jeq_cont.42226:
	jmp	jeq_cont.42222
jeq_else.42221:
	fmul	%f7, %f0, %f0
	ldi	%g3, %g7, -16
	fldi	%f6, %g3, 0
	fmul	%f8, %f7, %f6
	fmul	%f7, %f2, %f2
	fldi	%f6, %g3, -4
	fmul	%f6, %f7, %f6
	fadd	%f8, %f8, %f6
	fmul	%f7, %f1, %f1
	fldi	%f6, %g3, -8
	fmul	%f6, %f7, %f6
	fadd	%f7, %f8, %f6
	ldi	%g3, %g7, -12
	jne	%g3, %g0, jeq_else.42227
	fmov	%f6, %f7
	jmp	jeq_cont.42228
jeq_else.42227:
	fmul	%f8, %f2, %f1
	ldi	%g3, %g7, -36
	fldi	%f6, %g3, 0
	fmul	%f6, %f8, %f6
	fadd	%f7, %f7, %f6
	fmul	%f6, %f1, %f0
	fldi	%f1, %g3, -4
	fmul	%f1, %f6, %f1
	fadd	%f7, %f7, %f1
	fmul	%f1, %f0, %f2
	fldi	%f0, %g3, -8
	fmul	%f6, %f1, %f0
	fadd	%f6, %f7, %f6
jeq_cont.42228:
	addi	%g3, %g0, 3
	jne	%g6, %g3, jeq_else.42229
	fsub	%f0, %f6, %f17
	jmp	jeq_cont.42230
jeq_else.42229:
	fmov	%f0, %f6
jeq_cont.42230:
	ldi	%g3, %g7, -24
	fjlt	%f0, %f16, fjge_else.42231
	addi	%g6, %g0, 0
	jmp	fjge_cont.42232
fjge_else.42231:
	addi	%g6, %g0, 1
fjge_cont.42232:
	jne	%g3, %g6, jeq_else.42233
	addi	%g3, %g0, 1
	jmp	jeq_cont.42234
jeq_else.42233:
	addi	%g3, %g0, 0
jeq_cont.42234:
jeq_cont.42222:
jeq_cont.42204:
	jne	%g3, %g0, jeq_else.42235
	addi	%g7, %g5, 1
	slli	%g3, %g7, 2
	ld	%g5, %g4, %g3
	jne	%g5, %g29, jeq_else.42236
	addi	%g3, %g0, 1
	return
jeq_else.42236:
	slli	%g3, %g5, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 272
	ldi	%g3, %g6, -20
	fldi	%f0, %g3, 0
	fsub	%f0, %f5, %f0
	fldi	%f1, %g3, -4
	fsub	%f2, %f4, %f1
	fldi	%f1, %g3, -8
	fsub	%f1, %f3, %f1
	ldi	%g5, %g6, -4
	jne	%g5, %g28, jeq_else.42237
	fjlt	%f0, %f16, fjge_else.42239
	fmov	%f6, %f0
	jmp	fjge_cont.42240
fjge_else.42239:
	fneg	%f6, %f0
fjge_cont.42240:
	ldi	%g3, %g6, -16
	fldi	%f0, %g3, 0
	fjlt	%f6, %f0, fjge_else.42241
	addi	%g5, %g0, 0
	jmp	fjge_cont.42242
fjge_else.42241:
	fjlt	%f2, %f16, fjge_else.42243
	fmov	%f0, %f2
	jmp	fjge_cont.42244
fjge_else.42243:
	fneg	%f0, %f2
fjge_cont.42244:
	fldi	%f2, %g3, -4
	fjlt	%f0, %f2, fjge_else.42245
	addi	%g5, %g0, 0
	jmp	fjge_cont.42246
fjge_else.42245:
	fjlt	%f1, %f16, fjge_else.42247
	fmov	%f0, %f1
	jmp	fjge_cont.42248
fjge_else.42247:
	fneg	%f0, %f1
fjge_cont.42248:
	fldi	%f1, %g3, -8
	fjlt	%f0, %f1, fjge_else.42249
	addi	%g5, %g0, 0
	jmp	fjge_cont.42250
fjge_else.42249:
	addi	%g5, %g0, 1
fjge_cont.42250:
fjge_cont.42246:
fjge_cont.42242:
	jne	%g5, %g0, jeq_else.42251
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.42253
	addi	%g3, %g0, 1
	jmp	jeq_cont.42254
jeq_else.42253:
	addi	%g3, %g0, 0
jeq_cont.42254:
	jmp	jeq_cont.42252
jeq_else.42251:
	ldi	%g3, %g6, -24
jeq_cont.42252:
	jmp	jeq_cont.42238
jeq_else.42237:
	addi	%g3, %g0, 2
	jne	%g5, %g3, jeq_else.42255
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, 0
	fmul	%f6, %f6, %f0
	fldi	%f0, %g3, -4
	fmul	%f0, %f0, %f2
	fadd	%f2, %f6, %f0
	fldi	%f0, %g3, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.42257
	addi	%g5, %g0, 0
	jmp	fjge_cont.42258
fjge_else.42257:
	addi	%g5, %g0, 1
fjge_cont.42258:
	jne	%g3, %g5, jeq_else.42259
	addi	%g3, %g0, 1
	jmp	jeq_cont.42260
jeq_else.42259:
	addi	%g3, %g0, 0
jeq_cont.42260:
	jmp	jeq_cont.42256
jeq_else.42255:
	fmul	%f7, %f0, %f0
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, 0
	fmul	%f8, %f7, %f6
	fmul	%f7, %f2, %f2
	fldi	%f6, %g3, -4
	fmul	%f6, %f7, %f6
	fadd	%f8, %f8, %f6
	fmul	%f7, %f1, %f1
	fldi	%f6, %g3, -8
	fmul	%f6, %f7, %f6
	fadd	%f7, %f8, %f6
	ldi	%g3, %g6, -12
	jne	%g3, %g0, jeq_else.42261
	fmov	%f6, %f7
	jmp	jeq_cont.42262
jeq_else.42261:
	fmul	%f8, %f2, %f1
	ldi	%g3, %g6, -36
	fldi	%f6, %g3, 0
	fmul	%f6, %f8, %f6
	fadd	%f7, %f7, %f6
	fmul	%f6, %f1, %f0
	fldi	%f1, %g3, -4
	fmul	%f1, %f6, %f1
	fadd	%f7, %f7, %f1
	fmul	%f1, %f0, %f2
	fldi	%f0, %g3, -8
	fmul	%f6, %f1, %f0
	fadd	%f6, %f7, %f6
jeq_cont.42262:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.42263
	fsub	%f0, %f6, %f17
	jmp	jeq_cont.42264
jeq_else.42263:
	fmov	%f0, %f6
jeq_cont.42264:
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.42265
	addi	%g5, %g0, 0
	jmp	fjge_cont.42266
fjge_else.42265:
	addi	%g5, %g0, 1
fjge_cont.42266:
	jne	%g3, %g5, jeq_else.42267
	addi	%g3, %g0, 1
	jmp	jeq_cont.42268
jeq_else.42267:
	addi	%g3, %g0, 0
jeq_cont.42268:
jeq_cont.42256:
jeq_cont.42238:
	jne	%g3, %g0, jeq_else.42269
	addi	%g5, %g7, 1
	jmp	check_all_inside.2808
jeq_else.42269:
	addi	%g3, %g0, 0
	return
jeq_else.42235:
	addi	%g3, %g0, 0
	return

!==============================
! args = [%g8, %g4]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Bool
!================================
shadow_check_and_group.2814:
	slli	%g3, %g8, 2
	ld	%g9, %g4, %g3
	jne	%g9, %g29, jeq_else.42270
	addi	%g3, %g0, 0
	return
jeq_else.42270:
	slli	%g3, %g9, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 272
	fldi	%f1, %g31, 540
	ldi	%g3, %g6, -20
	fldi	%f0, %g3, 0
	fsub	%f3, %f1, %f0
	fldi	%f1, %g31, 536
	fldi	%f0, %g3, -4
	fsub	%f4, %f1, %f0
	fldi	%f1, %g31, 532
	fldi	%f0, %g3, -8
	fsub	%f2, %f1, %f0
	slli	%g3, %g9, 2
	add	%g3, %g31, %g3
	ldi	%g7, %g3, 972
	ldi	%g5, %g6, -4
	jne	%g5, %g28, jeq_else.42271
	fldi	%f0, %g7, 0
	fsub	%f0, %f0, %f3
	fldi	%f1, %g7, -4
	fmul	%f0, %f0, %f1
	fldi	%f5, %g31, 728
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f4
	fjlt	%f6, %f16, fjge_else.42273
	fmov	%f5, %f6
	jmp	fjge_cont.42274
fjge_else.42273:
	fneg	%f5, %f6
fjge_cont.42274:
	ldi	%g5, %g6, -16
	fldi	%f6, %g5, -4
	fjlt	%f5, %f6, fjge_else.42275
	addi	%g3, %g0, 0
	jmp	fjge_cont.42276
fjge_else.42275:
	fldi	%f5, %g31, 724
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f2
	fjlt	%f6, %f16, fjge_else.42277
	fmov	%f5, %f6
	jmp	fjge_cont.42278
fjge_else.42277:
	fneg	%f5, %f6
fjge_cont.42278:
	fldi	%f6, %g5, -8
	fjlt	%f5, %f6, fjge_else.42279
	addi	%g3, %g0, 0
	jmp	fjge_cont.42280
fjge_else.42279:
	fjeq	%f1, %f16, fjne_else.42281
	addi	%g3, %g0, 1
	jmp	fjne_cont.42282
fjne_else.42281:
	addi	%g3, %g0, 0
fjne_cont.42282:
fjge_cont.42280:
fjge_cont.42276:
	jne	%g3, %g0, jeq_else.42283
	fldi	%f0, %g7, -8
	fsub	%f0, %f0, %f4
	fldi	%f1, %g7, -12
	fmul	%f0, %f0, %f1
	fldi	%f5, %g31, 732
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f3
	fjlt	%f6, %f16, fjge_else.42285
	fmov	%f5, %f6
	jmp	fjge_cont.42286
fjge_else.42285:
	fneg	%f5, %f6
fjge_cont.42286:
	fldi	%f6, %g5, 0
	fjlt	%f5, %f6, fjge_else.42287
	addi	%g3, %g0, 0
	jmp	fjge_cont.42288
fjge_else.42287:
	fldi	%f5, %g31, 724
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f2
	fjlt	%f6, %f16, fjge_else.42289
	fmov	%f5, %f6
	jmp	fjge_cont.42290
fjge_else.42289:
	fneg	%f5, %f6
fjge_cont.42290:
	fldi	%f6, %g5, -8
	fjlt	%f5, %f6, fjge_else.42291
	addi	%g3, %g0, 0
	jmp	fjge_cont.42292
fjge_else.42291:
	fjeq	%f1, %f16, fjne_else.42293
	addi	%g3, %g0, 1
	jmp	fjne_cont.42294
fjne_else.42293:
	addi	%g3, %g0, 0
fjne_cont.42294:
fjge_cont.42292:
fjge_cont.42288:
	jne	%g3, %g0, jeq_else.42295
	fldi	%f0, %g7, -16
	fsub	%f1, %f0, %f2
	fldi	%f0, %g7, -20
	fmul	%f5, %f1, %f0
	fldi	%f1, %g31, 732
	fmul	%f1, %f5, %f1
	fadd	%f2, %f1, %f3
	fjlt	%f2, %f16, fjge_else.42297
	fmov	%f1, %f2
	jmp	fjge_cont.42298
fjge_else.42297:
	fneg	%f1, %f2
fjge_cont.42298:
	fldi	%f2, %g5, 0
	fjlt	%f1, %f2, fjge_else.42299
	addi	%g3, %g0, 0
	jmp	fjge_cont.42300
fjge_else.42299:
	fldi	%f1, %g31, 728
	fmul	%f1, %f5, %f1
	fadd	%f2, %f1, %f4
	fjlt	%f2, %f16, fjge_else.42301
	fmov	%f1, %f2
	jmp	fjge_cont.42302
fjge_else.42301:
	fneg	%f1, %f2
fjge_cont.42302:
	fldi	%f2, %g5, -4
	fjlt	%f1, %f2, fjge_else.42303
	addi	%g3, %g0, 0
	jmp	fjge_cont.42304
fjge_else.42303:
	fjeq	%f0, %f16, fjne_else.42305
	addi	%g3, %g0, 1
	jmp	fjne_cont.42306
fjne_else.42305:
	addi	%g3, %g0, 0
fjne_cont.42306:
fjge_cont.42304:
fjge_cont.42300:
	jne	%g3, %g0, jeq_else.42307
	addi	%g3, %g0, 0
	jmp	jeq_cont.42308
jeq_else.42307:
	fsti	%f5, %g31, 520
	addi	%g3, %g0, 3
jeq_cont.42308:
	jmp	jeq_cont.42296
jeq_else.42295:
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 2
jeq_cont.42296:
	jmp	jeq_cont.42284
jeq_else.42283:
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 1
jeq_cont.42284:
	jmp	jeq_cont.42272
jeq_else.42271:
	addi	%g3, %g0, 2
	jne	%g5, %g3, jeq_else.42309
	fldi	%f0, %g7, 0
	fjlt	%f0, %f16, fjge_else.42311
	addi	%g3, %g0, 0
	jmp	fjge_cont.42312
fjge_else.42311:
	fldi	%f0, %g7, -4
	fmul	%f1, %f0, %f3
	fldi	%f0, %g7, -8
	fmul	%f0, %f0, %f4
	fadd	%f1, %f1, %f0
	fldi	%f0, %g7, -12
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.42312:
	jmp	jeq_cont.42310
jeq_else.42309:
	fldi	%f0, %g7, 0
	fjeq	%f0, %f16, fjne_else.42313
	fldi	%f1, %g7, -4
	fmul	%f5, %f1, %f3
	fldi	%f1, %g7, -8
	fmul	%f1, %f1, %f4
	fadd	%f5, %f5, %f1
	fldi	%f1, %g7, -12
	fmul	%f1, %f1, %f2
	fadd	%f1, %f5, %f1
	fmul	%f6, %f3, %f3
	ldi	%g3, %g6, -16
	fldi	%f5, %g3, 0
	fmul	%f7, %f6, %f5
	fmul	%f6, %f4, %f4
	fldi	%f5, %g3, -4
	fmul	%f5, %f6, %f5
	fadd	%f7, %f7, %f5
	fmul	%f6, %f2, %f2
	fldi	%f5, %g3, -8
	fmul	%f5, %f6, %f5
	fadd	%f6, %f7, %f5
	ldi	%g3, %g6, -12
	jne	%g3, %g0, jeq_else.42315
	fmov	%f5, %f6
	jmp	jeq_cont.42316
jeq_else.42315:
	fmul	%f7, %f4, %f2
	ldi	%g3, %g6, -36
	fldi	%f5, %g3, 0
	fmul	%f5, %f7, %f5
	fadd	%f6, %f6, %f5
	fmul	%f5, %f2, %f3
	fldi	%f2, %g3, -4
	fmul	%f2, %f5, %f2
	fadd	%f6, %f6, %f2
	fmul	%f3, %f3, %f4
	fldi	%f2, %g3, -8
	fmul	%f5, %f3, %f2
	fadd	%f5, %f6, %f5
jeq_cont.42316:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.42317
	fsub	%f2, %f5, %f17
	jmp	jeq_cont.42318
jeq_else.42317:
	fmov	%f2, %f5
jeq_cont.42318:
	fmul	%f3, %f1, %f1
	fmul	%f0, %f0, %f2
	fsub	%f0, %f3, %f0
	fjlt	%f16, %f0, fjge_else.42319
	addi	%g3, %g0, 0
	jmp	fjge_cont.42320
fjge_else.42319:
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.42321
	fsqrt	%f0, %f0
	fsub	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	jmp	jeq_cont.42322
jeq_else.42321:
	fsqrt	%f0, %f0
	fadd	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
jeq_cont.42322:
	addi	%g3, %g0, 1
fjge_cont.42320:
	jmp	fjne_cont.42314
fjne_else.42313:
	addi	%g3, %g0, 0
fjne_cont.42314:
jeq_cont.42310:
jeq_cont.42272:
	fldi	%f0, %g31, 520
	jne	%g3, %g0, jeq_else.42323
	addi	%g3, %g0, 0
	jmp	jeq_cont.42324
jeq_else.42323:
	setL %g3, l.36389
	fldi	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.42325
	addi	%g3, %g0, 0
	jmp	fjge_cont.42326
fjge_else.42325:
	addi	%g3, %g0, 1
fjge_cont.42326:
jeq_cont.42324:
	jne	%g3, %g0, jeq_else.42327
	slli	%g3, %g9, 2
	add	%g3, %g31, %g3
	ldi	%g3, %g3, 272
	ldi	%g3, %g3, -24
	jne	%g3, %g0, jeq_else.42328
	addi	%g3, %g0, 0
	return
jeq_else.42328:
	addi	%g8, %g8, 1
	jmp	shadow_check_and_group.2814
jeq_else.42327:
	setL %g3, l.36391
	fldi	%f1, %g3, 0
	fadd	%f0, %f0, %f1
	fldi	%f1, %g31, 308
	fmul	%f2, %f1, %f0
	fldi	%f1, %g31, 540
	fadd	%f5, %f2, %f1
	fldi	%f1, %g31, 304
	fmul	%f2, %f1, %f0
	fldi	%f1, %g31, 536
	fadd	%f4, %f2, %f1
	fldi	%f1, %g31, 300
	fmul	%f1, %f1, %f0
	fldi	%f0, %g31, 532
	fadd	%f3, %f1, %f0
	ldi	%g5, %g4, 0
	sti	%g4, %g1, 0
	jne	%g5, %g29, jeq_else.42329
	addi	%g3, %g0, 1
	jmp	jeq_cont.42330
jeq_else.42329:
	slli	%g3, %g5, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 272
	ldi	%g3, %g6, -20
	fldi	%f0, %g3, 0
	fsub	%f0, %f5, %f0
	fldi	%f1, %g3, -4
	fsub	%f2, %f4, %f1
	fldi	%f1, %g3, -8
	fsub	%f1, %f3, %f1
	ldi	%g5, %g6, -4
	jne	%g5, %g28, jeq_else.42331
	fjlt	%f0, %f16, fjge_else.42333
	fmov	%f6, %f0
	jmp	fjge_cont.42334
fjge_else.42333:
	fneg	%f6, %f0
fjge_cont.42334:
	ldi	%g3, %g6, -16
	fldi	%f0, %g3, 0
	fjlt	%f6, %f0, fjge_else.42335
	addi	%g5, %g0, 0
	jmp	fjge_cont.42336
fjge_else.42335:
	fjlt	%f2, %f16, fjge_else.42337
	fmov	%f0, %f2
	jmp	fjge_cont.42338
fjge_else.42337:
	fneg	%f0, %f2
fjge_cont.42338:
	fldi	%f2, %g3, -4
	fjlt	%f0, %f2, fjge_else.42339
	addi	%g5, %g0, 0
	jmp	fjge_cont.42340
fjge_else.42339:
	fjlt	%f1, %f16, fjge_else.42341
	fmov	%f0, %f1
	jmp	fjge_cont.42342
fjge_else.42341:
	fneg	%f0, %f1
fjge_cont.42342:
	fldi	%f1, %g3, -8
	fjlt	%f0, %f1, fjge_else.42343
	addi	%g5, %g0, 0
	jmp	fjge_cont.42344
fjge_else.42343:
	addi	%g5, %g0, 1
fjge_cont.42344:
fjge_cont.42340:
fjge_cont.42336:
	jne	%g5, %g0, jeq_else.42345
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.42347
	addi	%g3, %g0, 1
	jmp	jeq_cont.42348
jeq_else.42347:
	addi	%g3, %g0, 0
jeq_cont.42348:
	jmp	jeq_cont.42346
jeq_else.42345:
	ldi	%g3, %g6, -24
jeq_cont.42346:
	jmp	jeq_cont.42332
jeq_else.42331:
	addi	%g3, %g0, 2
	jne	%g5, %g3, jeq_else.42349
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, 0
	fmul	%f6, %f6, %f0
	fldi	%f0, %g3, -4
	fmul	%f0, %f0, %f2
	fadd	%f2, %f6, %f0
	fldi	%f0, %g3, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.42351
	addi	%g5, %g0, 0
	jmp	fjge_cont.42352
fjge_else.42351:
	addi	%g5, %g0, 1
fjge_cont.42352:
	jne	%g3, %g5, jeq_else.42353
	addi	%g3, %g0, 1
	jmp	jeq_cont.42354
jeq_else.42353:
	addi	%g3, %g0, 0
jeq_cont.42354:
	jmp	jeq_cont.42350
jeq_else.42349:
	fmul	%f7, %f0, %f0
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, 0
	fmul	%f8, %f7, %f6
	fmul	%f7, %f2, %f2
	fldi	%f6, %g3, -4
	fmul	%f6, %f7, %f6
	fadd	%f8, %f8, %f6
	fmul	%f7, %f1, %f1
	fldi	%f6, %g3, -8
	fmul	%f6, %f7, %f6
	fadd	%f7, %f8, %f6
	ldi	%g3, %g6, -12
	jne	%g3, %g0, jeq_else.42355
	fmov	%f6, %f7
	jmp	jeq_cont.42356
jeq_else.42355:
	fmul	%f8, %f2, %f1
	ldi	%g3, %g6, -36
	fldi	%f6, %g3, 0
	fmul	%f6, %f8, %f6
	fadd	%f7, %f7, %f6
	fmul	%f6, %f1, %f0
	fldi	%f1, %g3, -4
	fmul	%f1, %f6, %f1
	fadd	%f7, %f7, %f1
	fmul	%f1, %f0, %f2
	fldi	%f0, %g3, -8
	fmul	%f6, %f1, %f0
	fadd	%f6, %f7, %f6
jeq_cont.42356:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.42357
	fsub	%f0, %f6, %f17
	jmp	jeq_cont.42358
jeq_else.42357:
	fmov	%f0, %f6
jeq_cont.42358:
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.42359
	addi	%g5, %g0, 0
	jmp	fjge_cont.42360
fjge_else.42359:
	addi	%g5, %g0, 1
fjge_cont.42360:
	jne	%g3, %g5, jeq_else.42361
	addi	%g3, %g0, 1
	jmp	jeq_cont.42362
jeq_else.42361:
	addi	%g3, %g0, 0
jeq_cont.42362:
jeq_cont.42350:
jeq_cont.42332:
	jne	%g3, %g0, jeq_else.42363
	addi	%g5, %g0, 1
	subi	%g1, %g1, 8
	call	check_all_inside.2808
	addi	%g1, %g1, 8
	jmp	jeq_cont.42364
jeq_else.42363:
	addi	%g3, %g0, 0
jeq_cont.42364:
jeq_cont.42330:
	jne	%g3, %g0, jeq_else.42365
	addi	%g8, %g8, 1
	ldi	%g4, %g1, 0
	jmp	shadow_check_and_group.2814
jeq_else.42365:
	addi	%g3, %g0, 1
	return

!==============================
! args = [%g11, %g10]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g11, %g10, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Bool
!================================
shadow_check_one_or_group.2817:
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.42366
	addi	%g3, %g0, 0
	return
jeq_else.42366:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.42367
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.42368
	addi	%g3, %g0, 0
	return
jeq_else.42368:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.42369
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.42370
	addi	%g3, %g0, 0
	return
jeq_else.42370:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.42371
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.42372
	addi	%g3, %g0, 0
	return
jeq_else.42372:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.42373
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.42374
	addi	%g3, %g0, 0
	return
jeq_else.42374:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.42375
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.42376
	addi	%g3, %g0, 0
	return
jeq_else.42376:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.42377
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.42378
	addi	%g3, %g0, 0
	return
jeq_else.42378:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.42379
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.42380
	addi	%g3, %g0, 0
	return
jeq_else.42380:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.42381
	addi	%g11, %g11, 1
	jmp	shadow_check_one_or_group.2817
jeq_else.42381:
	addi	%g3, %g0, 1
	return
jeq_else.42379:
	addi	%g3, %g0, 1
	return
jeq_else.42377:
	addi	%g3, %g0, 1
	return
jeq_else.42375:
	addi	%g3, %g0, 1
	return
jeq_else.42373:
	addi	%g3, %g0, 1
	return
jeq_else.42371:
	addi	%g3, %g0, 1
	return
jeq_else.42369:
	addi	%g3, %g0, 1
	return
jeq_else.42367:
	addi	%g3, %g0, 1
	return

!==============================
! args = [%g12, %g13]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g13, %g12, %g11, %g10, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Bool
!================================
shadow_check_one_or_matrix.2820:
	slli	%g3, %g12, 2
	ld	%g10, %g13, %g3
	ldi	%g4, %g10, 0
	jne	%g4, %g29, jeq_else.42382
	addi	%g3, %g0, 0
	return
jeq_else.42382:
	addi	%g3, %g0, 99
	sti	%g10, %g1, 0
	jne	%g4, %g3, jeq_else.42383
	addi	%g3, %g0, 1
	jmp	jeq_cont.42384
jeq_else.42383:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g5, %g3, 272
	fldi	%f1, %g31, 540
	ldi	%g3, %g5, -20
	fldi	%f0, %g3, 0
	fsub	%f3, %f1, %f0
	fldi	%f1, %g31, 536
	fldi	%f0, %g3, -4
	fsub	%f4, %f1, %f0
	fldi	%f1, %g31, 532
	fldi	%f0, %g3, -8
	fsub	%f1, %f1, %f0
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 972
	ldi	%g4, %g5, -4
	jne	%g4, %g28, jeq_else.42385
	fldi	%f0, %g6, 0
	fsub	%f2, %f0, %f3
	fldi	%f0, %g6, -4
	fmul	%f6, %f2, %f0
	fldi	%f2, %g31, 728
	fmul	%f2, %f6, %f2
	fadd	%f5, %f2, %f4
	fjlt	%f5, %f16, fjge_else.42387
	fmov	%f2, %f5
	jmp	fjge_cont.42388
fjge_else.42387:
	fneg	%f2, %f5
fjge_cont.42388:
	ldi	%g4, %g5, -16
	fldi	%f5, %g4, -4
	fjlt	%f2, %f5, fjge_else.42389
	addi	%g3, %g0, 0
	jmp	fjge_cont.42390
fjge_else.42389:
	fldi	%f2, %g31, 724
	fmul	%f2, %f6, %f2
	fadd	%f5, %f2, %f1
	fjlt	%f5, %f16, fjge_else.42391
	fmov	%f2, %f5
	jmp	fjge_cont.42392
fjge_else.42391:
	fneg	%f2, %f5
fjge_cont.42392:
	fldi	%f5, %g4, -8
	fjlt	%f2, %f5, fjge_else.42393
	addi	%g3, %g0, 0
	jmp	fjge_cont.42394
fjge_else.42393:
	fjeq	%f0, %f16, fjne_else.42395
	addi	%g3, %g0, 1
	jmp	fjne_cont.42396
fjne_else.42395:
	addi	%g3, %g0, 0
fjne_cont.42396:
fjge_cont.42394:
fjge_cont.42390:
	jne	%g3, %g0, jeq_else.42397
	fldi	%f0, %g6, -8
	fsub	%f0, %f0, %f4
	fldi	%f6, %g6, -12
	fmul	%f5, %f0, %f6
	fldi	%f0, %g31, 732
	fmul	%f0, %f5, %f0
	fadd	%f2, %f0, %f3
	fjlt	%f2, %f16, fjge_else.42399
	fmov	%f0, %f2
	jmp	fjge_cont.42400
fjge_else.42399:
	fneg	%f0, %f2
fjge_cont.42400:
	fldi	%f2, %g4, 0
	fjlt	%f0, %f2, fjge_else.42401
	addi	%g3, %g0, 0
	jmp	fjge_cont.42402
fjge_else.42401:
	fldi	%f0, %g31, 724
	fmul	%f0, %f5, %f0
	fadd	%f2, %f0, %f1
	fjlt	%f2, %f16, fjge_else.42403
	fmov	%f0, %f2
	jmp	fjge_cont.42404
fjge_else.42403:
	fneg	%f0, %f2
fjge_cont.42404:
	fldi	%f2, %g4, -8
	fjlt	%f0, %f2, fjge_else.42405
	addi	%g3, %g0, 0
	jmp	fjge_cont.42406
fjge_else.42405:
	fjeq	%f6, %f16, fjne_else.42407
	addi	%g3, %g0, 1
	jmp	fjne_cont.42408
fjne_else.42407:
	addi	%g3, %g0, 0
fjne_cont.42408:
fjge_cont.42406:
fjge_cont.42402:
	jne	%g3, %g0, jeq_else.42409
	fldi	%f0, %g6, -16
	fsub	%f0, %f0, %f1
	fldi	%f5, %g6, -20
	fmul	%f2, %f0, %f5
	fldi	%f0, %g31, 732
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f3
	fjlt	%f1, %f16, fjge_else.42411
	fmov	%f0, %f1
	jmp	fjge_cont.42412
fjge_else.42411:
	fneg	%f0, %f1
fjge_cont.42412:
	fldi	%f1, %g4, 0
	fjlt	%f0, %f1, fjge_else.42413
	addi	%g3, %g0, 0
	jmp	fjge_cont.42414
fjge_else.42413:
	fldi	%f0, %g31, 728
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f4
	fjlt	%f1, %f16, fjge_else.42415
	fmov	%f0, %f1
	jmp	fjge_cont.42416
fjge_else.42415:
	fneg	%f0, %f1
fjge_cont.42416:
	fldi	%f1, %g4, -4
	fjlt	%f0, %f1, fjge_else.42417
	addi	%g3, %g0, 0
	jmp	fjge_cont.42418
fjge_else.42417:
	fjeq	%f5, %f16, fjne_else.42419
	addi	%g3, %g0, 1
	jmp	fjne_cont.42420
fjne_else.42419:
	addi	%g3, %g0, 0
fjne_cont.42420:
fjge_cont.42418:
fjge_cont.42414:
	jne	%g3, %g0, jeq_else.42421
	addi	%g3, %g0, 0
	jmp	jeq_cont.42422
jeq_else.42421:
	fsti	%f2, %g31, 520
	addi	%g3, %g0, 3
jeq_cont.42422:
	jmp	jeq_cont.42410
jeq_else.42409:
	fsti	%f5, %g31, 520
	addi	%g3, %g0, 2
jeq_cont.42410:
	jmp	jeq_cont.42398
jeq_else.42397:
	fsti	%f6, %g31, 520
	addi	%g3, %g0, 1
jeq_cont.42398:
	jmp	jeq_cont.42386
jeq_else.42385:
	addi	%g3, %g0, 2
	jne	%g4, %g3, jeq_else.42423
	fldi	%f0, %g6, 0
	fjlt	%f0, %f16, fjge_else.42425
	addi	%g3, %g0, 0
	jmp	fjge_cont.42426
fjge_else.42425:
	fldi	%f0, %g6, -4
	fmul	%f2, %f0, %f3
	fldi	%f0, %g6, -8
	fmul	%f0, %f0, %f4
	fadd	%f2, %f2, %f0
	fldi	%f0, %g6, -12
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.42426:
	jmp	jeq_cont.42424
jeq_else.42423:
	fldi	%f0, %g6, 0
	fjeq	%f0, %f16, fjne_else.42427
	fldi	%f2, %g6, -4
	fmul	%f5, %f2, %f3
	fldi	%f2, %g6, -8
	fmul	%f2, %f2, %f4
	fadd	%f5, %f5, %f2
	fldi	%f2, %g6, -12
	fmul	%f2, %f2, %f1
	fadd	%f2, %f5, %f2
	fmul	%f6, %f3, %f3
	ldi	%g3, %g5, -16
	fldi	%f5, %g3, 0
	fmul	%f7, %f6, %f5
	fmul	%f6, %f4, %f4
	fldi	%f5, %g3, -4
	fmul	%f5, %f6, %f5
	fadd	%f7, %f7, %f5
	fmul	%f6, %f1, %f1
	fldi	%f5, %g3, -8
	fmul	%f5, %f6, %f5
	fadd	%f6, %f7, %f5
	ldi	%g3, %g5, -12
	jne	%g3, %g0, jeq_else.42429
	fmov	%f5, %f6
	jmp	jeq_cont.42430
jeq_else.42429:
	fmul	%f7, %f4, %f1
	ldi	%g3, %g5, -36
	fldi	%f5, %g3, 0
	fmul	%f5, %f7, %f5
	fadd	%f6, %f6, %f5
	fmul	%f5, %f1, %f3
	fldi	%f1, %g3, -4
	fmul	%f1, %f5, %f1
	fadd	%f6, %f6, %f1
	fmul	%f3, %f3, %f4
	fldi	%f1, %g3, -8
	fmul	%f5, %f3, %f1
	fadd	%f5, %f6, %f5
jeq_cont.42430:
	addi	%g3, %g0, 3
	jne	%g4, %g3, jeq_else.42431
	fsub	%f1, %f5, %f17
	jmp	jeq_cont.42432
jeq_else.42431:
	fmov	%f1, %f5
jeq_cont.42432:
	fmul	%f3, %f2, %f2
	fmul	%f0, %f0, %f1
	fsub	%f0, %f3, %f0
	fjlt	%f16, %f0, fjge_else.42433
	addi	%g3, %g0, 0
	jmp	fjge_cont.42434
fjge_else.42433:
	ldi	%g3, %g5, -24
	jne	%g3, %g0, jeq_else.42435
	fsqrt	%f0, %f0
	fsub	%f1, %f2, %f0
	fldi	%f0, %g6, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	jmp	jeq_cont.42436
jeq_else.42435:
	fsqrt	%f0, %f0
	fadd	%f1, %f2, %f0
	fldi	%f0, %g6, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
jeq_cont.42436:
	addi	%g3, %g0, 1
fjge_cont.42434:
	jmp	fjne_cont.42428
fjne_else.42427:
	addi	%g3, %g0, 0
fjne_cont.42428:
jeq_cont.42424:
jeq_cont.42386:
	jne	%g3, %g0, jeq_else.42437
	addi	%g3, %g0, 0
	jmp	jeq_cont.42438
jeq_else.42437:
	fldi	%f1, %g31, 520
	setL %g3, l.36577
	fldi	%f0, %g3, 0
	fjlt	%f1, %f0, fjge_else.42439
	addi	%g3, %g0, 0
	jmp	fjge_cont.42440
fjge_else.42439:
	ldi	%g4, %g10, -4
	jne	%g4, %g29, jeq_else.42441
	addi	%g3, %g0, 0
	jmp	jeq_cont.42442
jeq_else.42441:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.42443
	ldi	%g4, %g10, -8
	jne	%g4, %g29, jeq_else.42445
	addi	%g3, %g0, 0
	jmp	jeq_cont.42446
jeq_else.42445:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.42447
	ldi	%g4, %g10, -12
	jne	%g4, %g29, jeq_else.42449
	addi	%g3, %g0, 0
	jmp	jeq_cont.42450
jeq_else.42449:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.42451
	ldi	%g4, %g10, -16
	jne	%g4, %g29, jeq_else.42453
	addi	%g3, %g0, 0
	jmp	jeq_cont.42454
jeq_else.42453:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.42455
	ldi	%g4, %g10, -20
	jne	%g4, %g29, jeq_else.42457
	addi	%g3, %g0, 0
	jmp	jeq_cont.42458
jeq_else.42457:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.42459
	ldi	%g4, %g10, -24
	jne	%g4, %g29, jeq_else.42461
	addi	%g3, %g0, 0
	jmp	jeq_cont.42462
jeq_else.42461:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.42463
	ldi	%g4, %g10, -28
	jne	%g4, %g29, jeq_else.42465
	addi	%g3, %g0, 0
	jmp	jeq_cont.42466
jeq_else.42465:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.42467
	addi	%g11, %g0, 8
	subi	%g1, %g1, 8
	call	shadow_check_one_or_group.2817
	addi	%g1, %g1, 8
	jmp	jeq_cont.42468
jeq_else.42467:
	addi	%g3, %g0, 1
jeq_cont.42468:
jeq_cont.42466:
	jmp	jeq_cont.42464
jeq_else.42463:
	addi	%g3, %g0, 1
jeq_cont.42464:
jeq_cont.42462:
	jmp	jeq_cont.42460
jeq_else.42459:
	addi	%g3, %g0, 1
jeq_cont.42460:
jeq_cont.42458:
	jmp	jeq_cont.42456
jeq_else.42455:
	addi	%g3, %g0, 1
jeq_cont.42456:
jeq_cont.42454:
	jmp	jeq_cont.42452
jeq_else.42451:
	addi	%g3, %g0, 1
jeq_cont.42452:
jeq_cont.42450:
	jmp	jeq_cont.42448
jeq_else.42447:
	addi	%g3, %g0, 1
jeq_cont.42448:
jeq_cont.42446:
	jmp	jeq_cont.42444
jeq_else.42443:
	addi	%g3, %g0, 1
jeq_cont.42444:
jeq_cont.42442:
	jne	%g3, %g0, jeq_else.42469
	addi	%g3, %g0, 0
	jmp	jeq_cont.42470
jeq_else.42469:
	addi	%g3, %g0, 1
jeq_cont.42470:
fjge_cont.42440:
jeq_cont.42438:
jeq_cont.42384:
	jne	%g3, %g0, jeq_else.42471
	addi	%g12, %g12, 1
	jmp	shadow_check_one_or_matrix.2820
jeq_else.42471:
	ldi	%g10, %g1, 0
	ldi	%g4, %g10, -4
	jne	%g4, %g29, jeq_else.42472
	addi	%g3, %g0, 0
	jmp	jeq_cont.42473
jeq_else.42472:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.42474
	ldi	%g4, %g10, -8
	jne	%g4, %g29, jeq_else.42476
	addi	%g3, %g0, 0
	jmp	jeq_cont.42477
jeq_else.42476:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.42478
	ldi	%g4, %g10, -12
	jne	%g4, %g29, jeq_else.42480
	addi	%g3, %g0, 0
	jmp	jeq_cont.42481
jeq_else.42480:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.42482
	ldi	%g4, %g10, -16
	jne	%g4, %g29, jeq_else.42484
	addi	%g3, %g0, 0
	jmp	jeq_cont.42485
jeq_else.42484:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.42486
	ldi	%g4, %g10, -20
	jne	%g4, %g29, jeq_else.42488
	addi	%g3, %g0, 0
	jmp	jeq_cont.42489
jeq_else.42488:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.42490
	ldi	%g4, %g10, -24
	jne	%g4, %g29, jeq_else.42492
	addi	%g3, %g0, 0
	jmp	jeq_cont.42493
jeq_else.42492:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.42494
	ldi	%g4, %g10, -28
	jne	%g4, %g29, jeq_else.42496
	addi	%g3, %g0, 0
	jmp	jeq_cont.42497
jeq_else.42496:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2814
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.42498
	addi	%g11, %g0, 8
	subi	%g1, %g1, 8
	call	shadow_check_one_or_group.2817
	addi	%g1, %g1, 8
	jmp	jeq_cont.42499
jeq_else.42498:
	addi	%g3, %g0, 1
jeq_cont.42499:
jeq_cont.42497:
	jmp	jeq_cont.42495
jeq_else.42494:
	addi	%g3, %g0, 1
jeq_cont.42495:
jeq_cont.42493:
	jmp	jeq_cont.42491
jeq_else.42490:
	addi	%g3, %g0, 1
jeq_cont.42491:
jeq_cont.42489:
	jmp	jeq_cont.42487
jeq_else.42486:
	addi	%g3, %g0, 1
jeq_cont.42487:
jeq_cont.42485:
	jmp	jeq_cont.42483
jeq_else.42482:
	addi	%g3, %g0, 1
jeq_cont.42483:
jeq_cont.42481:
	jmp	jeq_cont.42479
jeq_else.42478:
	addi	%g3, %g0, 1
jeq_cont.42479:
jeq_cont.42477:
	jmp	jeq_cont.42475
jeq_else.42474:
	addi	%g3, %g0, 1
jeq_cont.42475:
jeq_cont.42473:
	jne	%g3, %g0, jeq_else.42500
	addi	%g12, %g12, 1
	jmp	shadow_check_one_or_matrix.2820
jeq_else.42500:
	addi	%g3, %g0, 1
	return

!==============================
! args = [%g11, %g4, %g9]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f2, %f17, %f16, %f15, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
solve_each_element.2823:
	slli	%g3, %g11, 2
	ld	%g10, %g4, %g3
	jne	%g10, %g29, jeq_else.42501
	return
jeq_else.42501:
	slli	%g3, %g10, 2
	add	%g3, %g31, %g3
	ldi	%g7, %g3, 272
	fldi	%f1, %g31, 624
	ldi	%g3, %g7, -20
	fldi	%f0, %g3, 0
	fsub	%f6, %f1, %f0
	fldi	%f1, %g31, 620
	fldi	%f0, %g3, -4
	fsub	%f7, %f1, %f0
	fldi	%f1, %g31, 616
	fldi	%f0, %g3, -8
	fsub	%f5, %f1, %f0
	ldi	%g3, %g7, -4
	jne	%g3, %g28, jeq_else.42503
	fldi	%f2, %g9, 0
	fjeq	%f2, %f16, fjne_else.42505
	ldi	%g5, %g7, -16
	ldi	%g3, %g7, -24
	fjlt	%f2, %f16, fjge_else.42507
	addi	%g6, %g0, 0
	jmp	fjge_cont.42508
fjge_else.42507:
	addi	%g6, %g0, 1
fjge_cont.42508:
	fldi	%f1, %g5, 0
	jne	%g3, %g6, jeq_else.42509
	fneg	%f0, %f1
	jmp	jeq_cont.42510
jeq_else.42509:
	fmov	%f0, %f1
jeq_cont.42510:
	fsub	%f0, %f0, %f6
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, -4
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f7
	fjlt	%f1, %f16, fjge_else.42511
	fmov	%f0, %f1
	jmp	fjge_cont.42512
fjge_else.42511:
	fneg	%f0, %f1
fjge_cont.42512:
	fldi	%f1, %g5, -4
	fjlt	%f0, %f1, fjge_else.42513
	addi	%g8, %g0, 0
	jmp	fjge_cont.42514
fjge_else.42513:
	fldi	%f0, %g9, -8
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f5
	fjlt	%f1, %f16, fjge_else.42515
	fmov	%f0, %f1
	jmp	fjge_cont.42516
fjge_else.42515:
	fneg	%f0, %f1
fjge_cont.42516:
	fldi	%f1, %g5, -8
	fjlt	%f0, %f1, fjge_else.42517
	addi	%g8, %g0, 0
	jmp	fjge_cont.42518
fjge_else.42517:
	fsti	%f2, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.42518:
fjge_cont.42514:
	jmp	fjne_cont.42506
fjne_else.42505:
	addi	%g8, %g0, 0
fjne_cont.42506:
	jne	%g8, %g0, jeq_else.42519
	fldi	%f2, %g9, -4
	fjeq	%f2, %f16, fjne_else.42521
	ldi	%g5, %g7, -16
	ldi	%g3, %g7, -24
	fjlt	%f2, %f16, fjge_else.42523
	addi	%g6, %g0, 0
	jmp	fjge_cont.42524
fjge_else.42523:
	addi	%g6, %g0, 1
fjge_cont.42524:
	fldi	%f1, %g5, -4
	jne	%g3, %g6, jeq_else.42525
	fneg	%f0, %f1
	jmp	jeq_cont.42526
jeq_else.42525:
	fmov	%f0, %f1
jeq_cont.42526:
	fsub	%f0, %f0, %f7
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, -8
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f5
	fjlt	%f1, %f16, fjge_else.42527
	fmov	%f0, %f1
	jmp	fjge_cont.42528
fjge_else.42527:
	fneg	%f0, %f1
fjge_cont.42528:
	fldi	%f1, %g5, -8
	fjlt	%f0, %f1, fjge_else.42529
	addi	%g8, %g0, 0
	jmp	fjge_cont.42530
fjge_else.42529:
	fldi	%f0, %g9, 0
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f6
	fjlt	%f1, %f16, fjge_else.42531
	fmov	%f0, %f1
	jmp	fjge_cont.42532
fjge_else.42531:
	fneg	%f0, %f1
fjge_cont.42532:
	fldi	%f1, %g5, 0
	fjlt	%f0, %f1, fjge_else.42533
	addi	%g8, %g0, 0
	jmp	fjge_cont.42534
fjge_else.42533:
	fsti	%f2, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.42534:
fjge_cont.42530:
	jmp	fjne_cont.42522
fjne_else.42521:
	addi	%g8, %g0, 0
fjne_cont.42522:
	jne	%g8, %g0, jeq_else.42535
	fldi	%f2, %g9, -8
	fjeq	%f2, %f16, fjne_else.42537
	ldi	%g5, %g7, -16
	ldi	%g3, %g7, -24
	fjlt	%f2, %f16, fjge_else.42539
	addi	%g6, %g0, 0
	jmp	fjge_cont.42540
fjge_else.42539:
	addi	%g6, %g0, 1
fjge_cont.42540:
	fldi	%f1, %g5, -8
	jne	%g3, %g6, jeq_else.42541
	fneg	%f0, %f1
	jmp	jeq_cont.42542
jeq_else.42541:
	fmov	%f0, %f1
jeq_cont.42542:
	fsub	%f0, %f0, %f5
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, 0
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f6
	fjlt	%f1, %f16, fjge_else.42543
	fmov	%f0, %f1
	jmp	fjge_cont.42544
fjge_else.42543:
	fneg	%f0, %f1
fjge_cont.42544:
	fldi	%f1, %g5, 0
	fjlt	%f0, %f1, fjge_else.42545
	addi	%g8, %g0, 0
	jmp	fjge_cont.42546
fjge_else.42545:
	fldi	%f0, %g9, -4
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f7
	fjlt	%f1, %f16, fjge_else.42547
	fmov	%f0, %f1
	jmp	fjge_cont.42548
fjge_else.42547:
	fneg	%f0, %f1
fjge_cont.42548:
	fldi	%f1, %g5, -4
	fjlt	%f0, %f1, fjge_else.42549
	addi	%g8, %g0, 0
	jmp	fjge_cont.42550
fjge_else.42549:
	fsti	%f2, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.42550:
fjge_cont.42546:
	jmp	fjne_cont.42538
fjne_else.42537:
	addi	%g8, %g0, 0
fjne_cont.42538:
	jne	%g8, %g0, jeq_else.42551
	addi	%g8, %g0, 0
	jmp	jeq_cont.42552
jeq_else.42551:
	addi	%g8, %g0, 3
jeq_cont.42552:
	jmp	jeq_cont.42536
jeq_else.42535:
	addi	%g8, %g0, 2
jeq_cont.42536:
	jmp	jeq_cont.42520
jeq_else.42519:
	addi	%g8, %g0, 1
jeq_cont.42520:
	jmp	jeq_cont.42504
jeq_else.42503:
	addi	%g8, %g0, 2
	jne	%g3, %g8, jeq_else.42553
	ldi	%g3, %g7, -16
	fldi	%f0, %g9, 0
	fldi	%f4, %g3, 0
	fmul	%f1, %f0, %f4
	fldi	%f0, %g9, -4
	fldi	%f3, %g3, -4
	fmul	%f0, %f0, %f3
	fadd	%f2, %f1, %f0
	fldi	%f0, %g9, -8
	fldi	%f1, %g3, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	fjlt	%f16, %f0, fjge_else.42555
	addi	%g8, %g0, 0
	jmp	fjge_cont.42556
fjge_else.42555:
	fmul	%f4, %f4, %f6
	fmul	%f2, %f3, %f7
	fadd	%f2, %f4, %f2
	fmul	%f1, %f1, %f5
	fadd	%f1, %f2, %f1
	fneg	%f1, %f1
	fdiv	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.42556:
	jmp	jeq_cont.42554
jeq_else.42553:
	fldi	%f1, %g9, 0
	fldi	%f2, %g9, -4
	fldi	%f0, %g9, -8
	fmul	%f3, %f1, %f1
	ldi	%g5, %g7, -16
	fldi	%f10, %g5, 0
	fmul	%f4, %f3, %f10
	fmul	%f3, %f2, %f2
	fldi	%f12, %g5, -4
	fmul	%f3, %f3, %f12
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f0
	fldi	%f11, %g5, -8
	fmul	%f3, %f3, %f11
	fadd	%f3, %f4, %f3
	ldi	%g6, %g7, -12
	jne	%g6, %g0, jeq_else.42557
	fmov	%f9, %f3
	jmp	jeq_cont.42558
jeq_else.42557:
	fmul	%f8, %f2, %f0
	ldi	%g5, %g7, -36
	fldi	%f4, %g5, 0
	fmul	%f4, %f8, %f4
	fadd	%f8, %f3, %f4
	fmul	%f4, %f0, %f1
	fldi	%f3, %g5, -4
	fmul	%f3, %f4, %f3
	fadd	%f8, %f8, %f3
	fmul	%f4, %f1, %f2
	fldi	%f3, %g5, -8
	fmul	%f9, %f4, %f3
	fadd	%f9, %f8, %f9
jeq_cont.42558:
	fjeq	%f9, %f16, fjne_else.42559
	fmul	%f3, %f1, %f6
	fmul	%f4, %f3, %f10
	fmul	%f3, %f2, %f7
	fmul	%f3, %f3, %f12
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f5
	fmul	%f3, %f3, %f11
	fadd	%f8, %f4, %f3
	jne	%g6, %g0, jeq_else.42561
	fmov	%f3, %f8
	jmp	jeq_cont.42562
jeq_else.42561:
	fmul	%f4, %f0, %f7
	fmul	%f3, %f2, %f5
	fadd	%f4, %f4, %f3
	ldi	%g5, %g7, -36
	fldi	%f3, %g5, 0
	fmul	%f4, %f4, %f3
	fmul	%f3, %f1, %f5
	fmul	%f0, %f0, %f6
	fadd	%f3, %f3, %f0
	fldi	%f0, %g5, -4
	fmul	%f0, %f3, %f0
	fadd	%f0, %f4, %f0
	fmul	%f3, %f1, %f7
	fmul	%f1, %f2, %f6
	fadd	%f2, %f3, %f1
	fldi	%f1, %g5, -8
	fmul	%f1, %f2, %f1
	fadd	%f0, %f0, %f1
	fmul	%f3, %f0, %f21
	fadd	%f3, %f8, %f3
jeq_cont.42562:
	fmul	%f0, %f6, %f6
	fmul	%f1, %f0, %f10
	fmul	%f0, %f7, %f7
	fmul	%f0, %f0, %f12
	fadd	%f1, %f1, %f0
	fmul	%f0, %f5, %f5
	fmul	%f0, %f0, %f11
	fadd	%f1, %f1, %f0
	jne	%g6, %g0, jeq_else.42563
	fmov	%f0, %f1
	jmp	jeq_cont.42564
jeq_else.42563:
	fmul	%f2, %f7, %f5
	ldi	%g5, %g7, -36
	fldi	%f0, %g5, 0
	fmul	%f0, %f2, %f0
	fadd	%f2, %f1, %f0
	fmul	%f1, %f5, %f6
	fldi	%f0, %g5, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fmul	%f1, %f6, %f7
	fldi	%f0, %g5, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
jeq_cont.42564:
	addi	%g5, %g0, 3
	jne	%g3, %g5, jeq_else.42565
	fsub	%f1, %f0, %f17
	jmp	jeq_cont.42566
jeq_else.42565:
	fmov	%f1, %f0
jeq_cont.42566:
	fmul	%f2, %f3, %f3
	fmul	%f0, %f9, %f1
	fsub	%f0, %f2, %f0
	fjlt	%f16, %f0, fjge_else.42567
	addi	%g8, %g0, 0
	jmp	fjge_cont.42568
fjge_else.42567:
	fsqrt	%f0, %f0
	ldi	%g3, %g7, -24
	jne	%g3, %g0, jeq_else.42569
	fneg	%f1, %f0
	jmp	jeq_cont.42570
jeq_else.42569:
	fmov	%f1, %f0
jeq_cont.42570:
	fsub	%f0, %f1, %f3
	fdiv	%f0, %f0, %f9
	fsti	%f0, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.42568:
	jmp	fjne_cont.42560
fjne_else.42559:
	addi	%g8, %g0, 0
fjne_cont.42560:
jeq_cont.42554:
jeq_cont.42504:
	jne	%g8, %g0, jeq_else.42571
	slli	%g3, %g10, 2
	add	%g3, %g31, %g3
	ldi	%g3, %g3, 272
	ldi	%g3, %g3, -24
	jne	%g3, %g0, jeq_else.42572
	return
jeq_else.42572:
	addi	%g11, %g11, 1
	jmp	solve_each_element.2823
jeq_else.42571:
	fldi	%f0, %g31, 520
	sti	%g4, %g1, 0
	fjlt	%f16, %f0, fjge_else.42574
	jmp	fjge_cont.42575
fjge_else.42574:
	fldi	%f1, %g31, 528
	fjlt	%f0, %f1, fjge_else.42576
	jmp	fjge_cont.42577
fjge_else.42576:
	setL %g3, l.36391
	fldi	%f1, %g3, 0
	fadd	%f9, %f0, %f1
	fldi	%f0, %g9, 0
	fmul	%f1, %f0, %f9
	fldi	%f0, %g31, 624
	fadd	%f5, %f1, %f0
	fldi	%f0, %g9, -4
	fmul	%f1, %f0, %f9
	fldi	%f0, %g31, 620
	fadd	%f4, %f1, %f0
	fldi	%f0, %g9, -8
	fmul	%f1, %f0, %f9
	fldi	%f0, %g31, 616
	fadd	%f3, %f1, %f0
	ldi	%g5, %g4, 0
	fsti	%f3, %g1, 4
	fsti	%f4, %g1, 8
	fsti	%f5, %g1, 12
	jne	%g5, %g29, jeq_else.42578
	addi	%g3, %g0, 1
	jmp	jeq_cont.42579
jeq_else.42578:
	slli	%g3, %g5, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 272
	ldi	%g3, %g6, -20
	fldi	%f0, %g3, 0
	fsub	%f0, %f5, %f0
	fldi	%f1, %g3, -4
	fsub	%f2, %f4, %f1
	fldi	%f1, %g3, -8
	fsub	%f1, %f3, %f1
	ldi	%g5, %g6, -4
	jne	%g5, %g28, jeq_else.42580
	fjlt	%f0, %f16, fjge_else.42582
	fmov	%f6, %f0
	jmp	fjge_cont.42583
fjge_else.42582:
	fneg	%f6, %f0
fjge_cont.42583:
	ldi	%g3, %g6, -16
	fldi	%f0, %g3, 0
	fjlt	%f6, %f0, fjge_else.42584
	addi	%g5, %g0, 0
	jmp	fjge_cont.42585
fjge_else.42584:
	fjlt	%f2, %f16, fjge_else.42586
	fmov	%f0, %f2
	jmp	fjge_cont.42587
fjge_else.42586:
	fneg	%f0, %f2
fjge_cont.42587:
	fldi	%f2, %g3, -4
	fjlt	%f0, %f2, fjge_else.42588
	addi	%g5, %g0, 0
	jmp	fjge_cont.42589
fjge_else.42588:
	fjlt	%f1, %f16, fjge_else.42590
	fmov	%f0, %f1
	jmp	fjge_cont.42591
fjge_else.42590:
	fneg	%f0, %f1
fjge_cont.42591:
	fldi	%f1, %g3, -8
	fjlt	%f0, %f1, fjge_else.42592
	addi	%g5, %g0, 0
	jmp	fjge_cont.42593
fjge_else.42592:
	addi	%g5, %g0, 1
fjge_cont.42593:
fjge_cont.42589:
fjge_cont.42585:
	jne	%g5, %g0, jeq_else.42594
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.42596
	addi	%g3, %g0, 1
	jmp	jeq_cont.42597
jeq_else.42596:
	addi	%g3, %g0, 0
jeq_cont.42597:
	jmp	jeq_cont.42595
jeq_else.42594:
	ldi	%g3, %g6, -24
jeq_cont.42595:
	jmp	jeq_cont.42581
jeq_else.42580:
	addi	%g3, %g0, 2
	jne	%g5, %g3, jeq_else.42598
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, 0
	fmul	%f6, %f6, %f0
	fldi	%f0, %g3, -4
	fmul	%f0, %f0, %f2
	fadd	%f2, %f6, %f0
	fldi	%f0, %g3, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.42600
	addi	%g5, %g0, 0
	jmp	fjge_cont.42601
fjge_else.42600:
	addi	%g5, %g0, 1
fjge_cont.42601:
	jne	%g3, %g5, jeq_else.42602
	addi	%g3, %g0, 1
	jmp	jeq_cont.42603
jeq_else.42602:
	addi	%g3, %g0, 0
jeq_cont.42603:
	jmp	jeq_cont.42599
jeq_else.42598:
	fmul	%f7, %f0, %f0
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, 0
	fmul	%f8, %f7, %f6
	fmul	%f7, %f2, %f2
	fldi	%f6, %g3, -4
	fmul	%f6, %f7, %f6
	fadd	%f8, %f8, %f6
	fmul	%f7, %f1, %f1
	fldi	%f6, %g3, -8
	fmul	%f6, %f7, %f6
	fadd	%f7, %f8, %f6
	ldi	%g3, %g6, -12
	jne	%g3, %g0, jeq_else.42604
	fmov	%f6, %f7
	jmp	jeq_cont.42605
jeq_else.42604:
	fmul	%f8, %f2, %f1
	ldi	%g3, %g6, -36
	fldi	%f6, %g3, 0
	fmul	%f6, %f8, %f6
	fadd	%f7, %f7, %f6
	fmul	%f6, %f1, %f0
	fldi	%f1, %g3, -4
	fmul	%f1, %f6, %f1
	fadd	%f7, %f7, %f1
	fmul	%f1, %f0, %f2
	fldi	%f0, %g3, -8
	fmul	%f6, %f1, %f0
	fadd	%f6, %f7, %f6
jeq_cont.42605:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.42606
	fsub	%f0, %f6, %f17
	jmp	jeq_cont.42607
jeq_else.42606:
	fmov	%f0, %f6
jeq_cont.42607:
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.42608
	addi	%g5, %g0, 0
	jmp	fjge_cont.42609
fjge_else.42608:
	addi	%g5, %g0, 1
fjge_cont.42609:
	jne	%g3, %g5, jeq_else.42610
	addi	%g3, %g0, 1
	jmp	jeq_cont.42611
jeq_else.42610:
	addi	%g3, %g0, 0
jeq_cont.42611:
jeq_cont.42599:
jeq_cont.42581:
	jne	%g3, %g0, jeq_else.42612
	addi	%g5, %g0, 1
	subi	%g1, %g1, 20
	call	check_all_inside.2808
	addi	%g1, %g1, 20
	jmp	jeq_cont.42613
jeq_else.42612:
	addi	%g3, %g0, 0
jeq_cont.42613:
jeq_cont.42579:
	jne	%g3, %g0, jeq_else.42614
	jmp	jeq_cont.42615
jeq_else.42614:
	fsti	%f9, %g31, 528
	fldi	%f5, %g1, 12
	fsti	%f5, %g31, 540
	fldi	%f4, %g1, 8
	fsti	%f4, %g31, 536
	fldi	%f3, %g1, 4
	fsti	%f3, %g31, 532
	sti	%g10, %g31, 544
	sti	%g8, %g31, 524
jeq_cont.42615:
fjge_cont.42577:
fjge_cont.42575:
	addi	%g11, %g11, 1
	ldi	%g4, %g1, 0
	jmp	solve_each_element.2823

!==============================
! args = [%g13, %g12, %g9]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f2, %f17, %f16, %f15, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
solve_one_or_network.2827:
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.42616
	return
jeq_else.42616:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	sti	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.42618
	return
jeq_else.42618:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.42620
	return
jeq_else.42620:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.42622
	return
jeq_else.42622:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.42624
	return
jeq_else.42624:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.42626
	return
jeq_else.42626:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.42628
	return
jeq_else.42628:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.42630
	return
jeq_else.42630:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	ldi	%g9, %g1, 0
	jmp	solve_one_or_network.2827

!==============================
! args = [%g14, %g15, %g9]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f2, %f17, %f16, %f15, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
trace_or_matrix.2831:
	slli	%g3, %g14, 2
	ld	%g12, %g15, %g3
	ldi	%g3, %g12, 0
	jne	%g3, %g29, jeq_else.42632
	return
jeq_else.42632:
	addi	%g4, %g0, 99
	sti	%g9, %g1, 0
	jne	%g3, %g4, jeq_else.42634
	ldi	%g3, %g12, -4
	jne	%g3, %g29, jeq_else.42636
	jmp	jeq_cont.42637
jeq_else.42636:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -8
	jne	%g3, %g29, jeq_else.42638
	jmp	jeq_cont.42639
jeq_else.42638:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -12
	jne	%g3, %g29, jeq_else.42640
	jmp	jeq_cont.42641
jeq_else.42640:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -16
	jne	%g3, %g29, jeq_else.42642
	jmp	jeq_cont.42643
jeq_else.42642:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -20
	jne	%g3, %g29, jeq_else.42644
	jmp	jeq_cont.42645
jeq_else.42644:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -24
	jne	%g3, %g29, jeq_else.42646
	jmp	jeq_cont.42647
jeq_else.42646:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -28
	jne	%g3, %g29, jeq_else.42648
	jmp	jeq_cont.42649
jeq_else.42648:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	addi	%g13, %g0, 8
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_one_or_network.2827
	addi	%g1, %g1, 8
jeq_cont.42649:
jeq_cont.42647:
jeq_cont.42645:
jeq_cont.42643:
jeq_cont.42641:
jeq_cont.42639:
jeq_cont.42637:
	jmp	jeq_cont.42635
jeq_else.42634:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 272
	fldi	%f1, %g31, 624
	ldi	%g3, %g6, -20
	fldi	%f0, %g3, 0
	fsub	%f5, %f1, %f0
	fldi	%f1, %g31, 620
	fldi	%f0, %g3, -4
	fsub	%f6, %f1, %f0
	fldi	%f1, %g31, 616
	fldi	%f0, %g3, -8
	fsub	%f4, %f1, %f0
	ldi	%g4, %g6, -4
	jne	%g4, %g28, jeq_else.42650
	fldi	%f2, %g9, 0
	fjeq	%f2, %f16, fjne_else.42652
	ldi	%g4, %g6, -16
	ldi	%g3, %g6, -24
	fjlt	%f2, %f16, fjge_else.42654
	addi	%g5, %g0, 0
	jmp	fjge_cont.42655
fjge_else.42654:
	addi	%g5, %g0, 1
fjge_cont.42655:
	fldi	%f1, %g4, 0
	jne	%g3, %g5, jeq_else.42656
	fneg	%f0, %f1
	jmp	jeq_cont.42657
jeq_else.42656:
	fmov	%f0, %f1
jeq_cont.42657:
	fsub	%f0, %f0, %f5
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, -4
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f6
	fjlt	%f1, %f16, fjge_else.42658
	fmov	%f0, %f1
	jmp	fjge_cont.42659
fjge_else.42658:
	fneg	%f0, %f1
fjge_cont.42659:
	fldi	%f1, %g4, -4
	fjlt	%f0, %f1, fjge_else.42660
	addi	%g3, %g0, 0
	jmp	fjge_cont.42661
fjge_else.42660:
	fldi	%f0, %g9, -8
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f4
	fjlt	%f1, %f16, fjge_else.42662
	fmov	%f0, %f1
	jmp	fjge_cont.42663
fjge_else.42662:
	fneg	%f0, %f1
fjge_cont.42663:
	fldi	%f1, %g4, -8
	fjlt	%f0, %f1, fjge_else.42664
	addi	%g3, %g0, 0
	jmp	fjge_cont.42665
fjge_else.42664:
	fsti	%f2, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.42665:
fjge_cont.42661:
	jmp	fjne_cont.42653
fjne_else.42652:
	addi	%g3, %g0, 0
fjne_cont.42653:
	jne	%g3, %g0, jeq_else.42666
	fldi	%f2, %g9, -4
	fjeq	%f2, %f16, fjne_else.42668
	ldi	%g4, %g6, -16
	ldi	%g3, %g6, -24
	fjlt	%f2, %f16, fjge_else.42670
	addi	%g5, %g0, 0
	jmp	fjge_cont.42671
fjge_else.42670:
	addi	%g5, %g0, 1
fjge_cont.42671:
	fldi	%f1, %g4, -4
	jne	%g3, %g5, jeq_else.42672
	fneg	%f0, %f1
	jmp	jeq_cont.42673
jeq_else.42672:
	fmov	%f0, %f1
jeq_cont.42673:
	fsub	%f0, %f0, %f6
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, -8
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f4
	fjlt	%f1, %f16, fjge_else.42674
	fmov	%f0, %f1
	jmp	fjge_cont.42675
fjge_else.42674:
	fneg	%f0, %f1
fjge_cont.42675:
	fldi	%f1, %g4, -8
	fjlt	%f0, %f1, fjge_else.42676
	addi	%g3, %g0, 0
	jmp	fjge_cont.42677
fjge_else.42676:
	fldi	%f0, %g9, 0
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f5
	fjlt	%f1, %f16, fjge_else.42678
	fmov	%f0, %f1
	jmp	fjge_cont.42679
fjge_else.42678:
	fneg	%f0, %f1
fjge_cont.42679:
	fldi	%f1, %g4, 0
	fjlt	%f0, %f1, fjge_else.42680
	addi	%g3, %g0, 0
	jmp	fjge_cont.42681
fjge_else.42680:
	fsti	%f2, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.42681:
fjge_cont.42677:
	jmp	fjne_cont.42669
fjne_else.42668:
	addi	%g3, %g0, 0
fjne_cont.42669:
	jne	%g3, %g0, jeq_else.42682
	fldi	%f2, %g9, -8
	fjeq	%f2, %f16, fjne_else.42684
	ldi	%g4, %g6, -16
	ldi	%g3, %g6, -24
	fjlt	%f2, %f16, fjge_else.42686
	addi	%g5, %g0, 0
	jmp	fjge_cont.42687
fjge_else.42686:
	addi	%g5, %g0, 1
fjge_cont.42687:
	fldi	%f1, %g4, -8
	jne	%g3, %g5, jeq_else.42688
	fneg	%f0, %f1
	jmp	jeq_cont.42689
jeq_else.42688:
	fmov	%f0, %f1
jeq_cont.42689:
	fsub	%f0, %f0, %f4
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, 0
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f5
	fjlt	%f1, %f16, fjge_else.42690
	fmov	%f0, %f1
	jmp	fjge_cont.42691
fjge_else.42690:
	fneg	%f0, %f1
fjge_cont.42691:
	fldi	%f1, %g4, 0
	fjlt	%f0, %f1, fjge_else.42692
	addi	%g3, %g0, 0
	jmp	fjge_cont.42693
fjge_else.42692:
	fldi	%f0, %g9, -4
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f6
	fjlt	%f1, %f16, fjge_else.42694
	fmov	%f0, %f1
	jmp	fjge_cont.42695
fjge_else.42694:
	fneg	%f0, %f1
fjge_cont.42695:
	fldi	%f1, %g4, -4
	fjlt	%f0, %f1, fjge_else.42696
	addi	%g3, %g0, 0
	jmp	fjge_cont.42697
fjge_else.42696:
	fsti	%f2, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.42697:
fjge_cont.42693:
	jmp	fjne_cont.42685
fjne_else.42684:
	addi	%g3, %g0, 0
fjne_cont.42685:
	jne	%g3, %g0, jeq_else.42698
	addi	%g3, %g0, 0
	jmp	jeq_cont.42699
jeq_else.42698:
	addi	%g3, %g0, 3
jeq_cont.42699:
	jmp	jeq_cont.42683
jeq_else.42682:
	addi	%g3, %g0, 2
jeq_cont.42683:
	jmp	jeq_cont.42667
jeq_else.42666:
	addi	%g3, %g0, 1
jeq_cont.42667:
	jmp	jeq_cont.42651
jeq_else.42650:
	addi	%g3, %g0, 2
	jne	%g4, %g3, jeq_else.42700
	ldi	%g3, %g6, -16
	fldi	%f0, %g9, 0
	fldi	%f7, %g3, 0
	fmul	%f1, %f0, %f7
	fldi	%f0, %g9, -4
	fldi	%f3, %g3, -4
	fmul	%f0, %f0, %f3
	fadd	%f2, %f1, %f0
	fldi	%f0, %g9, -8
	fldi	%f1, %g3, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	fjlt	%f16, %f0, fjge_else.42702
	addi	%g3, %g0, 0
	jmp	fjge_cont.42703
fjge_else.42702:
	fmul	%f5, %f7, %f5
	fmul	%f2, %f3, %f6
	fadd	%f2, %f5, %f2
	fmul	%f1, %f1, %f4
	fadd	%f1, %f2, %f1
	fneg	%f1, %f1
	fdiv	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.42703:
	jmp	jeq_cont.42701
jeq_else.42700:
	fldi	%f1, %g9, 0
	fldi	%f2, %g9, -4
	fldi	%f0, %g9, -8
	fmul	%f3, %f1, %f1
	ldi	%g3, %g6, -16
	fldi	%f9, %g3, 0
	fmul	%f7, %f3, %f9
	fmul	%f3, %f2, %f2
	fldi	%f11, %g3, -4
	fmul	%f3, %f3, %f11
	fadd	%f7, %f7, %f3
	fmul	%f3, %f0, %f0
	fldi	%f10, %g3, -8
	fmul	%f3, %f3, %f10
	fadd	%f3, %f7, %f3
	ldi	%g5, %g6, -12
	jne	%g5, %g0, jeq_else.42704
	fmov	%f8, %f3
	jmp	jeq_cont.42705
jeq_else.42704:
	fmul	%f8, %f2, %f0
	ldi	%g3, %g6, -36
	fldi	%f7, %g3, 0
	fmul	%f7, %f8, %f7
	fadd	%f8, %f3, %f7
	fmul	%f7, %f0, %f1
	fldi	%f3, %g3, -4
	fmul	%f3, %f7, %f3
	fadd	%f12, %f8, %f3
	fmul	%f7, %f1, %f2
	fldi	%f3, %g3, -8
	fmul	%f8, %f7, %f3
	fadd	%f8, %f12, %f8
jeq_cont.42705:
	fjeq	%f8, %f16, fjne_else.42706
	fmul	%f3, %f1, %f5
	fmul	%f7, %f3, %f9
	fmul	%f3, %f2, %f6
	fmul	%f3, %f3, %f11
	fadd	%f7, %f7, %f3
	fmul	%f3, %f0, %f4
	fmul	%f3, %f3, %f10
	fadd	%f7, %f7, %f3
	jne	%g5, %g0, jeq_else.42708
	fmov	%f3, %f7
	jmp	jeq_cont.42709
jeq_else.42708:
	fmul	%f12, %f0, %f6
	fmul	%f3, %f2, %f4
	fadd	%f12, %f12, %f3
	ldi	%g3, %g6, -36
	fldi	%f3, %g3, 0
	fmul	%f3, %f12, %f3
	fmul	%f12, %f1, %f4
	fmul	%f0, %f0, %f5
	fadd	%f12, %f12, %f0
	fldi	%f0, %g3, -4
	fmul	%f0, %f12, %f0
	fadd	%f0, %f3, %f0
	fmul	%f3, %f1, %f6
	fmul	%f1, %f2, %f5
	fadd	%f2, %f3, %f1
	fldi	%f1, %g3, -8
	fmul	%f1, %f2, %f1
	fadd	%f0, %f0, %f1
	fmul	%f3, %f0, %f21
	fadd	%f3, %f7, %f3
jeq_cont.42709:
	fmul	%f0, %f5, %f5
	fmul	%f1, %f0, %f9
	fmul	%f0, %f6, %f6
	fmul	%f0, %f0, %f11
	fadd	%f1, %f1, %f0
	fmul	%f0, %f4, %f4
	fmul	%f0, %f0, %f10
	fadd	%f1, %f1, %f0
	jne	%g5, %g0, jeq_else.42710
	fmov	%f0, %f1
	jmp	jeq_cont.42711
jeq_else.42710:
	fmul	%f2, %f6, %f4
	ldi	%g3, %g6, -36
	fldi	%f0, %g3, 0
	fmul	%f0, %f2, %f0
	fadd	%f2, %f1, %f0
	fmul	%f1, %f4, %f5
	fldi	%f0, %g3, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fmul	%f1, %f5, %f6
	fldi	%f0, %g3, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
jeq_cont.42711:
	addi	%g3, %g0, 3
	jne	%g4, %g3, jeq_else.42712
	fsub	%f1, %f0, %f17
	jmp	jeq_cont.42713
jeq_else.42712:
	fmov	%f1, %f0
jeq_cont.42713:
	fmul	%f2, %f3, %f3
	fmul	%f0, %f8, %f1
	fsub	%f0, %f2, %f0
	fjlt	%f16, %f0, fjge_else.42714
	addi	%g3, %g0, 0
	jmp	fjge_cont.42715
fjge_else.42714:
	fsqrt	%f0, %f0
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.42716
	fneg	%f1, %f0
	jmp	jeq_cont.42717
jeq_else.42716:
	fmov	%f1, %f0
jeq_cont.42717:
	fsub	%f0, %f1, %f3
	fdiv	%f0, %f0, %f8
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.42715:
	jmp	fjne_cont.42707
fjne_else.42706:
	addi	%g3, %g0, 0
fjne_cont.42707:
jeq_cont.42701:
jeq_cont.42651:
	jne	%g3, %g0, jeq_else.42718
	jmp	jeq_cont.42719
jeq_else.42718:
	fldi	%f0, %g31, 520
	fldi	%f1, %g31, 528
	fjlt	%f0, %f1, fjge_else.42720
	jmp	fjge_cont.42721
fjge_else.42720:
	ldi	%g3, %g12, -4
	jne	%g3, %g29, jeq_else.42722
	jmp	jeq_cont.42723
jeq_else.42722:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -8
	jne	%g3, %g29, jeq_else.42724
	jmp	jeq_cont.42725
jeq_else.42724:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -12
	jne	%g3, %g29, jeq_else.42726
	jmp	jeq_cont.42727
jeq_else.42726:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -16
	jne	%g3, %g29, jeq_else.42728
	jmp	jeq_cont.42729
jeq_else.42728:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -20
	jne	%g3, %g29, jeq_else.42730
	jmp	jeq_cont.42731
jeq_else.42730:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -24
	jne	%g3, %g29, jeq_else.42732
	jmp	jeq_cont.42733
jeq_else.42732:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -28
	jne	%g3, %g29, jeq_else.42734
	jmp	jeq_cont.42735
jeq_else.42734:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2823
	addi	%g1, %g1, 8
	addi	%g13, %g0, 8
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_one_or_network.2827
	addi	%g1, %g1, 8
jeq_cont.42735:
jeq_cont.42733:
jeq_cont.42731:
jeq_cont.42729:
jeq_cont.42727:
jeq_cont.42725:
jeq_cont.42723:
fjge_cont.42721:
jeq_cont.42719:
jeq_cont.42635:
	addi	%g14, %g14, 1
	ldi	%g9, %g1, 0
	jmp	trace_or_matrix.2831

!==============================
! args = [%g10, %g4, %g12, %g11]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
solve_each_element_fast.2837:
	slli	%g3, %g10, 2
	ld	%g9, %g4, %g3
	jne	%g9, %g29, jeq_else.42736
	return
jeq_else.42736:
	slli	%g3, %g9, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 272
	ldi	%g5, %g6, -40
	fldi	%f3, %g5, 0
	fldi	%f4, %g5, -4
	fldi	%f2, %g5, -8
	slli	%g3, %g9, 2
	ld	%g7, %g11, %g3
	ldi	%g3, %g6, -4
	jne	%g3, %g28, jeq_else.42738
	fldi	%f0, %g7, 0
	fsub	%f0, %f0, %f3
	fldi	%f1, %g7, -4
	fmul	%f0, %f0, %f1
	fldi	%f5, %g12, -4
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f4
	fjlt	%f6, %f16, fjge_else.42740
	fmov	%f5, %f6
	jmp	fjge_cont.42741
fjge_else.42740:
	fneg	%f5, %f6
fjge_cont.42741:
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, -4
	fjlt	%f5, %f6, fjge_else.42742
	addi	%g8, %g0, 0
	jmp	fjge_cont.42743
fjge_else.42742:
	fldi	%f5, %g12, -8
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f2
	fjlt	%f6, %f16, fjge_else.42744
	fmov	%f5, %f6
	jmp	fjge_cont.42745
fjge_else.42744:
	fneg	%f5, %f6
fjge_cont.42745:
	fldi	%f6, %g3, -8
	fjlt	%f5, %f6, fjge_else.42746
	addi	%g8, %g0, 0
	jmp	fjge_cont.42747
fjge_else.42746:
	fjeq	%f1, %f16, fjne_else.42748
	addi	%g8, %g0, 1
	jmp	fjne_cont.42749
fjne_else.42748:
	addi	%g8, %g0, 0
fjne_cont.42749:
fjge_cont.42747:
fjge_cont.42743:
	jne	%g8, %g0, jeq_else.42750
	fldi	%f0, %g7, -8
	fsub	%f0, %f0, %f4
	fldi	%f1, %g7, -12
	fmul	%f0, %f0, %f1
	fldi	%f5, %g12, 0
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f3
	fjlt	%f6, %f16, fjge_else.42752
	fmov	%f5, %f6
	jmp	fjge_cont.42753
fjge_else.42752:
	fneg	%f5, %f6
fjge_cont.42753:
	fldi	%f6, %g3, 0
	fjlt	%f5, %f6, fjge_else.42754
	addi	%g8, %g0, 0
	jmp	fjge_cont.42755
fjge_else.42754:
	fldi	%f5, %g12, -8
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f2
	fjlt	%f6, %f16, fjge_else.42756
	fmov	%f5, %f6
	jmp	fjge_cont.42757
fjge_else.42756:
	fneg	%f5, %f6
fjge_cont.42757:
	fldi	%f6, %g3, -8
	fjlt	%f5, %f6, fjge_else.42758
	addi	%g8, %g0, 0
	jmp	fjge_cont.42759
fjge_else.42758:
	fjeq	%f1, %f16, fjne_else.42760
	addi	%g8, %g0, 1
	jmp	fjne_cont.42761
fjne_else.42760:
	addi	%g8, %g0, 0
fjne_cont.42761:
fjge_cont.42759:
fjge_cont.42755:
	jne	%g8, %g0, jeq_else.42762
	fldi	%f0, %g7, -16
	fsub	%f1, %f0, %f2
	fldi	%f0, %g7, -20
	fmul	%f5, %f1, %f0
	fldi	%f1, %g12, 0
	fmul	%f1, %f5, %f1
	fadd	%f2, %f1, %f3
	fjlt	%f2, %f16, fjge_else.42764
	fmov	%f1, %f2
	jmp	fjge_cont.42765
fjge_else.42764:
	fneg	%f1, %f2
fjge_cont.42765:
	fldi	%f2, %g3, 0
	fjlt	%f1, %f2, fjge_else.42766
	addi	%g8, %g0, 0
	jmp	fjge_cont.42767
fjge_else.42766:
	fldi	%f1, %g12, -4
	fmul	%f1, %f5, %f1
	fadd	%f2, %f1, %f4
	fjlt	%f2, %f16, fjge_else.42768
	fmov	%f1, %f2
	jmp	fjge_cont.42769
fjge_else.42768:
	fneg	%f1, %f2
fjge_cont.42769:
	fldi	%f2, %g3, -4
	fjlt	%f1, %f2, fjge_else.42770
	addi	%g8, %g0, 0
	jmp	fjge_cont.42771
fjge_else.42770:
	fjeq	%f0, %f16, fjne_else.42772
	addi	%g8, %g0, 1
	jmp	fjne_cont.42773
fjne_else.42772:
	addi	%g8, %g0, 0
fjne_cont.42773:
fjge_cont.42771:
fjge_cont.42767:
	jne	%g8, %g0, jeq_else.42774
	addi	%g8, %g0, 0
	jmp	jeq_cont.42775
jeq_else.42774:
	fsti	%f5, %g31, 520
	addi	%g8, %g0, 3
jeq_cont.42775:
	jmp	jeq_cont.42763
jeq_else.42762:
	fsti	%f0, %g31, 520
	addi	%g8, %g0, 2
jeq_cont.42763:
	jmp	jeq_cont.42751
jeq_else.42750:
	fsti	%f0, %g31, 520
	addi	%g8, %g0, 1
jeq_cont.42751:
	jmp	jeq_cont.42739
jeq_else.42738:
	addi	%g8, %g0, 2
	jne	%g3, %g8, jeq_else.42776
	fldi	%f1, %g7, 0
	fjlt	%f1, %f16, fjge_else.42778
	addi	%g8, %g0, 0
	jmp	fjge_cont.42779
fjge_else.42778:
	fldi	%f0, %g5, -12
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.42779:
	jmp	jeq_cont.42777
jeq_else.42776:
	fldi	%f5, %g7, 0
	fjeq	%f5, %f16, fjne_else.42780
	fldi	%f0, %g7, -4
	fmul	%f1, %f0, %f3
	fldi	%f0, %g7, -8
	fmul	%f0, %f0, %f4
	fadd	%f1, %f1, %f0
	fldi	%f0, %g7, -12
	fmul	%f0, %f0, %f2
	fadd	%f1, %f1, %f0
	fldi	%f0, %g5, -12
	fmul	%f2, %f1, %f1
	fmul	%f0, %f5, %f0
	fsub	%f0, %f2, %f0
	fjlt	%f16, %f0, fjge_else.42782
	addi	%g8, %g0, 0
	jmp	fjge_cont.42783
fjge_else.42782:
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.42784
	fsqrt	%f0, %f0
	fsub	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	jmp	jeq_cont.42785
jeq_else.42784:
	fsqrt	%f0, %f0
	fadd	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
jeq_cont.42785:
	addi	%g8, %g0, 1
fjge_cont.42783:
	jmp	fjne_cont.42781
fjne_else.42780:
	addi	%g8, %g0, 0
fjne_cont.42781:
jeq_cont.42777:
jeq_cont.42739:
	jne	%g8, %g0, jeq_else.42786
	slli	%g3, %g9, 2
	add	%g3, %g31, %g3
	ldi	%g3, %g3, 272
	ldi	%g3, %g3, -24
	jne	%g3, %g0, jeq_else.42787
	return
jeq_else.42787:
	addi	%g10, %g10, 1
	jmp	solve_each_element_fast.2837
jeq_else.42786:
	fldi	%f0, %g31, 520
	sti	%g4, %g1, 0
	fjlt	%f16, %f0, fjge_else.42789
	jmp	fjge_cont.42790
fjge_else.42789:
	fldi	%f1, %g31, 528
	fjlt	%f0, %f1, fjge_else.42791
	jmp	fjge_cont.42792
fjge_else.42791:
	setL %g3, l.36391
	fldi	%f1, %g3, 0
	fadd	%f9, %f0, %f1
	fldi	%f0, %g12, 0
	fmul	%f1, %f0, %f9
	fldi	%f0, %g31, 636
	fadd	%f5, %f1, %f0
	fldi	%f0, %g12, -4
	fmul	%f1, %f0, %f9
	fldi	%f0, %g31, 632
	fadd	%f4, %f1, %f0
	fldi	%f0, %g12, -8
	fmul	%f1, %f0, %f9
	fldi	%f0, %g31, 628
	fadd	%f3, %f1, %f0
	ldi	%g5, %g4, 0
	fsti	%f3, %g1, 4
	fsti	%f4, %g1, 8
	fsti	%f5, %g1, 12
	jne	%g5, %g29, jeq_else.42793
	addi	%g3, %g0, 1
	jmp	jeq_cont.42794
jeq_else.42793:
	slli	%g3, %g5, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 272
	ldi	%g3, %g6, -20
	fldi	%f0, %g3, 0
	fsub	%f0, %f5, %f0
	fldi	%f1, %g3, -4
	fsub	%f2, %f4, %f1
	fldi	%f1, %g3, -8
	fsub	%f1, %f3, %f1
	ldi	%g5, %g6, -4
	jne	%g5, %g28, jeq_else.42795
	fjlt	%f0, %f16, fjge_else.42797
	fmov	%f6, %f0
	jmp	fjge_cont.42798
fjge_else.42797:
	fneg	%f6, %f0
fjge_cont.42798:
	ldi	%g3, %g6, -16
	fldi	%f0, %g3, 0
	fjlt	%f6, %f0, fjge_else.42799
	addi	%g5, %g0, 0
	jmp	fjge_cont.42800
fjge_else.42799:
	fjlt	%f2, %f16, fjge_else.42801
	fmov	%f0, %f2
	jmp	fjge_cont.42802
fjge_else.42801:
	fneg	%f0, %f2
fjge_cont.42802:
	fldi	%f2, %g3, -4
	fjlt	%f0, %f2, fjge_else.42803
	addi	%g5, %g0, 0
	jmp	fjge_cont.42804
fjge_else.42803:
	fjlt	%f1, %f16, fjge_else.42805
	fmov	%f0, %f1
	jmp	fjge_cont.42806
fjge_else.42805:
	fneg	%f0, %f1
fjge_cont.42806:
	fldi	%f1, %g3, -8
	fjlt	%f0, %f1, fjge_else.42807
	addi	%g5, %g0, 0
	jmp	fjge_cont.42808
fjge_else.42807:
	addi	%g5, %g0, 1
fjge_cont.42808:
fjge_cont.42804:
fjge_cont.42800:
	jne	%g5, %g0, jeq_else.42809
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.42811
	addi	%g3, %g0, 1
	jmp	jeq_cont.42812
jeq_else.42811:
	addi	%g3, %g0, 0
jeq_cont.42812:
	jmp	jeq_cont.42810
jeq_else.42809:
	ldi	%g3, %g6, -24
jeq_cont.42810:
	jmp	jeq_cont.42796
jeq_else.42795:
	addi	%g3, %g0, 2
	jne	%g5, %g3, jeq_else.42813
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, 0
	fmul	%f6, %f6, %f0
	fldi	%f0, %g3, -4
	fmul	%f0, %f0, %f2
	fadd	%f2, %f6, %f0
	fldi	%f0, %g3, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.42815
	addi	%g5, %g0, 0
	jmp	fjge_cont.42816
fjge_else.42815:
	addi	%g5, %g0, 1
fjge_cont.42816:
	jne	%g3, %g5, jeq_else.42817
	addi	%g3, %g0, 1
	jmp	jeq_cont.42818
jeq_else.42817:
	addi	%g3, %g0, 0
jeq_cont.42818:
	jmp	jeq_cont.42814
jeq_else.42813:
	fmul	%f7, %f0, %f0
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, 0
	fmul	%f8, %f7, %f6
	fmul	%f7, %f2, %f2
	fldi	%f6, %g3, -4
	fmul	%f6, %f7, %f6
	fadd	%f8, %f8, %f6
	fmul	%f7, %f1, %f1
	fldi	%f6, %g3, -8
	fmul	%f6, %f7, %f6
	fadd	%f7, %f8, %f6
	ldi	%g3, %g6, -12
	jne	%g3, %g0, jeq_else.42819
	fmov	%f6, %f7
	jmp	jeq_cont.42820
jeq_else.42819:
	fmul	%f8, %f2, %f1
	ldi	%g3, %g6, -36
	fldi	%f6, %g3, 0
	fmul	%f6, %f8, %f6
	fadd	%f7, %f7, %f6
	fmul	%f6, %f1, %f0
	fldi	%f1, %g3, -4
	fmul	%f1, %f6, %f1
	fadd	%f7, %f7, %f1
	fmul	%f1, %f0, %f2
	fldi	%f0, %g3, -8
	fmul	%f6, %f1, %f0
	fadd	%f6, %f7, %f6
jeq_cont.42820:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.42821
	fsub	%f0, %f6, %f17
	jmp	jeq_cont.42822
jeq_else.42821:
	fmov	%f0, %f6
jeq_cont.42822:
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.42823
	addi	%g5, %g0, 0
	jmp	fjge_cont.42824
fjge_else.42823:
	addi	%g5, %g0, 1
fjge_cont.42824:
	jne	%g3, %g5, jeq_else.42825
	addi	%g3, %g0, 1
	jmp	jeq_cont.42826
jeq_else.42825:
	addi	%g3, %g0, 0
jeq_cont.42826:
jeq_cont.42814:
jeq_cont.42796:
	jne	%g3, %g0, jeq_else.42827
	addi	%g5, %g0, 1
	subi	%g1, %g1, 20
	call	check_all_inside.2808
	addi	%g1, %g1, 20
	jmp	jeq_cont.42828
jeq_else.42827:
	addi	%g3, %g0, 0
jeq_cont.42828:
jeq_cont.42794:
	jne	%g3, %g0, jeq_else.42829
	jmp	jeq_cont.42830
jeq_else.42829:
	fsti	%f9, %g31, 528
	fldi	%f5, %g1, 12
	fsti	%f5, %g31, 540
	fldi	%f4, %g1, 8
	fsti	%f4, %g31, 536
	fldi	%f3, %g1, 4
	fsti	%f3, %g31, 532
	sti	%g9, %g31, 544
	sti	%g8, %g31, 524
jeq_cont.42830:
fjge_cont.42792:
fjge_cont.42790:
	addi	%g10, %g10, 1
	ldi	%g4, %g1, 0
	jmp	solve_each_element_fast.2837

!==============================
! args = [%g16, %g15, %g14, %g13]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
solve_one_or_network_fast.2841:
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.42831
	return
jeq_else.42831:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.42833
	return
jeq_else.42833:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.42835
	return
jeq_else.42835:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.42837
	return
jeq_else.42837:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.42839
	return
jeq_else.42839:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.42841
	return
jeq_else.42841:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.42843
	return
jeq_else.42843:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.42845
	return
jeq_else.42845:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	jmp	solve_one_or_network_fast.2841

!==============================
! args = [%g19, %g20, %g18, %g17]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
trace_or_matrix_fast.2845:
	slli	%g3, %g19, 2
	ld	%g15, %g20, %g3
	ldi	%g3, %g15, 0
	jne	%g3, %g29, jeq_else.42847
	return
jeq_else.42847:
	addi	%g4, %g0, 99
	jne	%g3, %g4, jeq_else.42849
	ldi	%g3, %g15, -4
	jne	%g3, %g29, jeq_else.42851
	jmp	jeq_cont.42852
jeq_else.42851:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -8
	jne	%g3, %g29, jeq_else.42853
	jmp	jeq_cont.42854
jeq_else.42853:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -12
	jne	%g3, %g29, jeq_else.42855
	jmp	jeq_cont.42856
jeq_else.42855:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -16
	jne	%g3, %g29, jeq_else.42857
	jmp	jeq_cont.42858
jeq_else.42857:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -20
	jne	%g3, %g29, jeq_else.42859
	jmp	jeq_cont.42860
jeq_else.42859:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -24
	jne	%g3, %g29, jeq_else.42861
	jmp	jeq_cont.42862
jeq_else.42861:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -28
	jne	%g3, %g29, jeq_else.42863
	jmp	jeq_cont.42864
jeq_else.42863:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g16, %g0, 8
	mov	%g13, %g17
	mov	%g14, %g18
	call	solve_one_or_network_fast.2841
	addi	%g1, %g1, 4
jeq_cont.42864:
jeq_cont.42862:
jeq_cont.42860:
jeq_cont.42858:
jeq_cont.42856:
jeq_cont.42854:
jeq_cont.42852:
	jmp	jeq_cont.42850
jeq_else.42849:
	slli	%g4, %g3, 2
	add	%g4, %g31, %g4
	ldi	%g6, %g4, 272
	ldi	%g5, %g6, -40
	fldi	%f2, %g5, 0
	fldi	%f3, %g5, -4
	fldi	%f1, %g5, -8
	slli	%g3, %g3, 2
	ld	%g7, %g17, %g3
	ldi	%g4, %g6, -4
	jne	%g4, %g28, jeq_else.42865
	fldi	%f0, %g7, 0
	fsub	%f4, %f0, %f2
	fldi	%f0, %g7, -4
	fmul	%f6, %f4, %f0
	fldi	%f4, %g18, -4
	fmul	%f4, %f6, %f4
	fadd	%f5, %f4, %f3
	fjlt	%f5, %f16, fjge_else.42867
	fmov	%f4, %f5
	jmp	fjge_cont.42868
fjge_else.42867:
	fneg	%f4, %f5
fjge_cont.42868:
	ldi	%g4, %g6, -16
	fldi	%f5, %g4, -4
	fjlt	%f4, %f5, fjge_else.42869
	addi	%g3, %g0, 0
	jmp	fjge_cont.42870
fjge_else.42869:
	fldi	%f4, %g18, -8
	fmul	%f4, %f6, %f4
	fadd	%f5, %f4, %f1
	fjlt	%f5, %f16, fjge_else.42871
	fmov	%f4, %f5
	jmp	fjge_cont.42872
fjge_else.42871:
	fneg	%f4, %f5
fjge_cont.42872:
	fldi	%f5, %g4, -8
	fjlt	%f4, %f5, fjge_else.42873
	addi	%g3, %g0, 0
	jmp	fjge_cont.42874
fjge_else.42873:
	fjeq	%f0, %f16, fjne_else.42875
	addi	%g3, %g0, 1
	jmp	fjne_cont.42876
fjne_else.42875:
	addi	%g3, %g0, 0
fjne_cont.42876:
fjge_cont.42874:
fjge_cont.42870:
	jne	%g3, %g0, jeq_else.42877
	fldi	%f0, %g7, -8
	fsub	%f0, %f0, %f3
	fldi	%f6, %g7, -12
	fmul	%f5, %f0, %f6
	fldi	%f0, %g18, 0
	fmul	%f0, %f5, %f0
	fadd	%f4, %f0, %f2
	fjlt	%f4, %f16, fjge_else.42879
	fmov	%f0, %f4
	jmp	fjge_cont.42880
fjge_else.42879:
	fneg	%f0, %f4
fjge_cont.42880:
	fldi	%f4, %g4, 0
	fjlt	%f0, %f4, fjge_else.42881
	addi	%g3, %g0, 0
	jmp	fjge_cont.42882
fjge_else.42881:
	fldi	%f0, %g18, -8
	fmul	%f0, %f5, %f0
	fadd	%f4, %f0, %f1
	fjlt	%f4, %f16, fjge_else.42883
	fmov	%f0, %f4
	jmp	fjge_cont.42884
fjge_else.42883:
	fneg	%f0, %f4
fjge_cont.42884:
	fldi	%f4, %g4, -8
	fjlt	%f0, %f4, fjge_else.42885
	addi	%g3, %g0, 0
	jmp	fjge_cont.42886
fjge_else.42885:
	fjeq	%f6, %f16, fjne_else.42887
	addi	%g3, %g0, 1
	jmp	fjne_cont.42888
fjne_else.42887:
	addi	%g3, %g0, 0
fjne_cont.42888:
fjge_cont.42886:
fjge_cont.42882:
	jne	%g3, %g0, jeq_else.42889
	fldi	%f0, %g7, -16
	fsub	%f0, %f0, %f1
	fldi	%f5, %g7, -20
	fmul	%f4, %f0, %f5
	fldi	%f0, %g18, 0
	fmul	%f0, %f4, %f0
	fadd	%f1, %f0, %f2
	fjlt	%f1, %f16, fjge_else.42891
	fmov	%f0, %f1
	jmp	fjge_cont.42892
fjge_else.42891:
	fneg	%f0, %f1
fjge_cont.42892:
	fldi	%f1, %g4, 0
	fjlt	%f0, %f1, fjge_else.42893
	addi	%g3, %g0, 0
	jmp	fjge_cont.42894
fjge_else.42893:
	fldi	%f0, %g18, -4
	fmul	%f0, %f4, %f0
	fadd	%f1, %f0, %f3
	fjlt	%f1, %f16, fjge_else.42895
	fmov	%f0, %f1
	jmp	fjge_cont.42896
fjge_else.42895:
	fneg	%f0, %f1
fjge_cont.42896:
	fldi	%f1, %g4, -4
	fjlt	%f0, %f1, fjge_else.42897
	addi	%g3, %g0, 0
	jmp	fjge_cont.42898
fjge_else.42897:
	fjeq	%f5, %f16, fjne_else.42899
	addi	%g3, %g0, 1
	jmp	fjne_cont.42900
fjne_else.42899:
	addi	%g3, %g0, 0
fjne_cont.42900:
fjge_cont.42898:
fjge_cont.42894:
	jne	%g3, %g0, jeq_else.42901
	addi	%g3, %g0, 0
	jmp	jeq_cont.42902
jeq_else.42901:
	fsti	%f4, %g31, 520
	addi	%g3, %g0, 3
jeq_cont.42902:
	jmp	jeq_cont.42890
jeq_else.42889:
	fsti	%f5, %g31, 520
	addi	%g3, %g0, 2
jeq_cont.42890:
	jmp	jeq_cont.42878
jeq_else.42877:
	fsti	%f6, %g31, 520
	addi	%g3, %g0, 1
jeq_cont.42878:
	jmp	jeq_cont.42866
jeq_else.42865:
	addi	%g3, %g0, 2
	jne	%g4, %g3, jeq_else.42903
	fldi	%f1, %g7, 0
	fjlt	%f1, %f16, fjge_else.42905
	addi	%g3, %g0, 0
	jmp	fjge_cont.42906
fjge_else.42905:
	fldi	%f0, %g5, -12
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.42906:
	jmp	jeq_cont.42904
jeq_else.42903:
	fldi	%f4, %g7, 0
	fjeq	%f4, %f16, fjne_else.42907
	fldi	%f0, %g7, -4
	fmul	%f2, %f0, %f2
	fldi	%f0, %g7, -8
	fmul	%f0, %f0, %f3
	fadd	%f2, %f2, %f0
	fldi	%f0, %g7, -12
	fmul	%f0, %f0, %f1
	fadd	%f1, %f2, %f0
	fldi	%f0, %g5, -12
	fmul	%f2, %f1, %f1
	fmul	%f0, %f4, %f0
	fsub	%f0, %f2, %f0
	fjlt	%f16, %f0, fjge_else.42909
	addi	%g3, %g0, 0
	jmp	fjge_cont.42910
fjge_else.42909:
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.42911
	fsqrt	%f0, %f0
	fsub	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	jmp	jeq_cont.42912
jeq_else.42911:
	fsqrt	%f0, %f0
	fadd	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
jeq_cont.42912:
	addi	%g3, %g0, 1
fjge_cont.42910:
	jmp	fjne_cont.42908
fjne_else.42907:
	addi	%g3, %g0, 0
fjne_cont.42908:
jeq_cont.42904:
jeq_cont.42866:
	jne	%g3, %g0, jeq_else.42913
	jmp	jeq_cont.42914
jeq_else.42913:
	fldi	%f0, %g31, 520
	fldi	%f1, %g31, 528
	fjlt	%f0, %f1, fjge_else.42915
	jmp	fjge_cont.42916
fjge_else.42915:
	ldi	%g3, %g15, -4
	jne	%g3, %g29, jeq_else.42917
	jmp	jeq_cont.42918
jeq_else.42917:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -8
	jne	%g3, %g29, jeq_else.42919
	jmp	jeq_cont.42920
jeq_else.42919:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -12
	jne	%g3, %g29, jeq_else.42921
	jmp	jeq_cont.42922
jeq_else.42921:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -16
	jne	%g3, %g29, jeq_else.42923
	jmp	jeq_cont.42924
jeq_else.42923:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -20
	jne	%g3, %g29, jeq_else.42925
	jmp	jeq_cont.42926
jeq_else.42925:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -24
	jne	%g3, %g29, jeq_else.42927
	jmp	jeq_cont.42928
jeq_else.42927:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -28
	jne	%g3, %g29, jeq_else.42929
	jmp	jeq_cont.42930
jeq_else.42929:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2837
	addi	%g16, %g0, 8
	mov	%g13, %g17
	mov	%g14, %g18
	call	solve_one_or_network_fast.2841
	addi	%g1, %g1, 4
jeq_cont.42930:
jeq_cont.42928:
jeq_cont.42926:
jeq_cont.42924:
jeq_cont.42922:
jeq_cont.42920:
jeq_cont.42918:
fjge_cont.42916:
jeq_cont.42914:
jeq_cont.42850:
	addi	%g19, %g19, 1
	jmp	trace_or_matrix_fast.2845

!==============================
! args = [%g21, %g22]
! fargs = [%f11, %f10]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
trace_reflections.2867:
	jlt	%g21, %g0, jge_else.42931
	slli	%g3, %g21, 2
	add	%g3, %g31, %g3
	ldi	%g23, %g3, 1716
	ldi	%g24, %g23, -4
	setL %g3, l.35419
	fldi	%f0, %g3, 0
	fsti	%f0, %g31, 528
	addi	%g19, %g0, 0
	ldi	%g20, %g31, 516
	ldi	%g17, %g24, -4
	ldi	%g18, %g24, 0
	subi	%g1, %g1, 4
	call	trace_or_matrix_fast.2845
	addi	%g1, %g1, 4
	fldi	%f0, %g31, 528
	setL %g3, l.36577
	fldi	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.42932
	addi	%g3, %g0, 0
	jmp	fjge_cont.42933
fjge_else.42932:
	setL %g3, l.37312
	fldi	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.42934
	addi	%g3, %g0, 0
	jmp	fjge_cont.42935
fjge_else.42934:
	addi	%g3, %g0, 1
fjge_cont.42935:
fjge_cont.42933:
	jne	%g3, %g0, jeq_else.42936
	jmp	jeq_cont.42937
jeq_else.42936:
	ldi	%g3, %g31, 544
	slli	%g4, %g3, 2
	ldi	%g3, %g31, 524
	add	%g3, %g4, %g3
	ldi	%g4, %g23, 0
	jne	%g3, %g4, jeq_else.42938
	addi	%g12, %g0, 0
	ldi	%g13, %g31, 516
	subi	%g1, %g1, 4
	call	shadow_check_one_or_matrix.2820
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.42940
	ldi	%g3, %g24, 0
	fldi	%f0, %g31, 556
	fldi	%f2, %g3, 0
	fmul	%f1, %f0, %f2
	fldi	%f0, %g31, 552
	fldi	%f4, %g3, -4
	fmul	%f0, %f0, %f4
	fadd	%f1, %f1, %f0
	fldi	%f0, %g31, 548
	fldi	%f3, %g3, -8
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g23, -8
	fmul	%f5, %f0, %f11
	fmul	%f1, %f5, %f1
	fldi	%f5, %g22, 0
	fmul	%f5, %f5, %f2
	fldi	%f2, %g22, -4
	fmul	%f2, %f2, %f4
	fadd	%f4, %f5, %f2
	fldi	%f2, %g22, -8
	fmul	%f2, %f2, %f3
	fadd	%f2, %f4, %f2
	fmul	%f0, %f0, %f2
	fjlt	%f16, %f1, fjge_else.42942
	jmp	fjge_cont.42943
fjge_else.42942:
	fldi	%f3, %g31, 592
	fldi	%f2, %g31, 568
	fmul	%f2, %f1, %f2
	fadd	%f2, %f3, %f2
	fsti	%f2, %g31, 592
	fldi	%f3, %g31, 588
	fldi	%f2, %g31, 564
	fmul	%f2, %f1, %f2
	fadd	%f2, %f3, %f2
	fsti	%f2, %g31, 588
	fldi	%f3, %g31, 584
	fldi	%f2, %g31, 560
	fmul	%f1, %f1, %f2
	fadd	%f1, %f3, %f1
	fsti	%f1, %g31, 584
fjge_cont.42943:
	fjlt	%f16, %f0, fjge_else.42944
	jmp	fjge_cont.42945
fjge_else.42944:
	fmul	%f0, %f0, %f0
	fmul	%f0, %f0, %f0
	fmul	%f0, %f0, %f10
	fldi	%f1, %g31, 592
	fadd	%f1, %f1, %f0
	fsti	%f1, %g31, 592
	fldi	%f1, %g31, 588
	fadd	%f1, %f1, %f0
	fsti	%f1, %g31, 588
	fldi	%f1, %g31, 584
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 584
fjge_cont.42945:
	jmp	jeq_cont.42941
jeq_else.42940:
jeq_cont.42941:
	jmp	jeq_cont.42939
jeq_else.42938:
jeq_cont.42939:
jeq_cont.42937:
	subi	%g21, %g21, 1
	jmp	trace_reflections.2867
jge_else.42931:
	return

!==============================
! args = [%g25, %g22, %g24, %g20, %g19, %g18, %g17, %g23, %g21, %g16]
! fargs = [%f13, %f14]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
trace_ray.2872:
	addi	%g3, %g0, 4
	jlt	%g3, %g25, jle_else.42947
	setL %g3, l.35419
	fldi	%f0, %g3, 0
	fsti	%f0, %g31, 528
	addi	%g14, %g0, 0
	ldi	%g15, %g31, 516
	mov	%g9, %g22
	subi	%g1, %g1, 4
	call	trace_or_matrix.2831
	addi	%g1, %g1, 4
	fldi	%f0, %g31, 528
	setL %g3, l.36577
	fldi	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.42948
	addi	%g3, %g0, 0
	jmp	fjge_cont.42949
fjge_else.42948:
	setL %g3, l.37312
	fldi	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.42950
	addi	%g3, %g0, 0
	jmp	fjge_cont.42951
fjge_else.42950:
	addi	%g3, %g0, 1
fjge_cont.42951:
fjge_cont.42949:
	jne	%g3, %g0, jeq_else.42952
	addi	%g4, %g0, -1
	slli	%g3, %g25, 2
	st	%g4, %g19, %g3
	jne	%g25, %g0, jeq_else.42953
	return
jeq_else.42953:
	fldi	%f1, %g22, 0
	fldi	%f0, %g31, 308
	fmul	%f2, %f1, %f0
	fldi	%f1, %g22, -4
	fldi	%f0, %g31, 304
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g22, -8
	fldi	%f0, %g31, 300
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fneg	%f0, %f0
	fjlt	%f16, %f0, fjge_else.42955
	return
fjge_else.42955:
	fmul	%f1, %f0, %f0
	fmul	%f0, %f1, %f0
	fmul	%f1, %f0, %f13
	fldi	%f0, %g31, 312
	fmul	%f0, %f1, %f0
	fldi	%f1, %g31, 592
	fadd	%f1, %f1, %f0
	fsti	%f1, %g31, 592
	fldi	%f1, %g31, 588
	fadd	%f1, %f1, %f0
	fsti	%f1, %g31, 588
	fldi	%f1, %g31, 584
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 584
	return
jeq_else.42952:
	ldi	%g7, %g31, 544
	slli	%g3, %g7, 2
	add	%g3, %g31, %g3
	ldi	%g3, %g3, 272
	ldi	%g30, %g3, -8
	ldi	%g26, %g3, -28
	fldi	%f0, %g26, 0
	fmul	%f11, %f0, %f13
	ldi	%g4, %g3, -4
	jne	%g4, %g28, jeq_else.42958
	ldi	%g4, %g31, 524
	fsti	%f16, %g31, 556
	fsti	%f16, %g31, 552
	fsti	%f16, %g31, 548
	subi	%g5, %g4, 1
	slli	%g4, %g5, 2
	fld	%f1, %g22, %g4
	fjeq	%f1, %f16, fjne_else.42960
	fjlt	%f16, %f1, fjge_else.42962
	setL %g4, l.35940
	fldi	%f0, %g4, 0
	jmp	fjge_cont.42963
fjge_else.42962:
	setL %g4, l.35549
	fldi	%f0, %g4, 0
fjge_cont.42963:
	jmp	fjne_cont.42961
fjne_else.42960:
	fmov	%f0, %f16
fjne_cont.42961:
	fneg	%f0, %f0
	slli	%g4, %g5, 2
	add	%g4, %g31, %g4
	fsti	%f0, %g4, 556
	jmp	jeq_cont.42959
jeq_else.42958:
	addi	%g5, %g0, 2
	jne	%g4, %g5, jeq_else.42964
	ldi	%g4, %g3, -16
	fldi	%f0, %g4, 0
	fneg	%f0, %f0
	fsti	%f0, %g31, 556
	fldi	%f0, %g4, -4
	fneg	%f0, %f0
	fsti	%f0, %g31, 552
	fldi	%f0, %g4, -8
	fneg	%f0, %f0
	fsti	%f0, %g31, 548
	jmp	jeq_cont.42965
jeq_else.42964:
	fldi	%f1, %g31, 540
	ldi	%g4, %g3, -20
	fldi	%f0, %g4, 0
	fsub	%f4, %f1, %f0
	fldi	%f1, %g31, 536
	fldi	%f0, %g4, -4
	fsub	%f3, %f1, %f0
	fldi	%f1, %g31, 532
	fldi	%f0, %g4, -8
	fsub	%f0, %f1, %f0
	ldi	%g4, %g3, -16
	fldi	%f1, %g4, 0
	fmul	%f1, %f4, %f1
	fldi	%f2, %g4, -4
	fmul	%f5, %f3, %f2
	fldi	%f2, %g4, -8
	fmul	%f7, %f0, %f2
	ldi	%g4, %g3, -12
	jne	%g4, %g0, jeq_else.42966
	fsti	%f1, %g31, 556
	fsti	%f5, %g31, 552
	fsti	%f7, %g31, 548
	jmp	jeq_cont.42967
jeq_else.42966:
	ldi	%g4, %g3, -36
	fldi	%f2, %g4, -8
	fmul	%f6, %f3, %f2
	fldi	%f2, %g4, -4
	fmul	%f2, %f0, %f2
	fadd	%f2, %f6, %f2
	fmul	%f2, %f2, %f21
	fadd	%f1, %f1, %f2
	fsti	%f1, %g31, 556
	fldi	%f1, %g4, -8
	fmul	%f2, %f4, %f1
	fldi	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	fmul	%f0, %f0, %f21
	fadd	%f0, %f5, %f0
	fsti	%f0, %g31, 552
	fldi	%f0, %g4, -4
	fmul	%f1, %f4, %f0
	fldi	%f0, %g4, 0
	fmul	%f0, %f3, %f0
	fadd	%f0, %f1, %f0
	fmul	%f0, %f0, %f21
	fadd	%f0, %f7, %f0
	fsti	%f0, %g31, 548
jeq_cont.42967:
	ldi	%g4, %g3, -24
	fldi	%f2, %g31, 556
	fmul	%f1, %f2, %f2
	fldi	%f0, %g31, 552
	fmul	%f0, %f0, %f0
	fadd	%f1, %f1, %f0
	fldi	%f0, %g31, 548
	fmul	%f0, %f0, %f0
	fadd	%f0, %f1, %f0
	fsqrt	%f1, %f0
	fjeq	%f1, %f16, fjne_else.42968
	jne	%g4, %g0, jeq_else.42970
	fdiv	%f0, %f17, %f1
	jmp	jeq_cont.42971
jeq_else.42970:
	fdiv	%f0, %f20, %f1
jeq_cont.42971:
	jmp	fjne_cont.42969
fjne_else.42968:
	setL %g4, l.35549
	fldi	%f0, %g4, 0
fjne_cont.42969:
	fmul	%f1, %f2, %f0
	fsti	%f1, %g31, 556
	fldi	%f1, %g31, 552
	fmul	%f1, %f1, %f0
	fsti	%f1, %g31, 552
	fldi	%f1, %g31, 548
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 548
jeq_cont.42965:
jeq_cont.42959:
	fldi	%f0, %g31, 540
	fsti	%f0, %g31, 624
	fldi	%f0, %g31, 536
	fsti	%f0, %g31, 620
	fldi	%f0, %g31, 532
	fsti	%f0, %g31, 616
	ldi	%g4, %g3, 0
	ldi	%g5, %g3, -32
	fldi	%f0, %g5, 0
	fsti	%f0, %g31, 568
	fldi	%f0, %g5, -4
	fsti	%f0, %g31, 564
	fldi	%f0, %g5, -8
	fsti	%f0, %g31, 560
	jne	%g4, %g28, jeq_else.42972
	fldi	%f1, %g31, 540
	ldi	%g5, %g3, -20
	fldi	%f0, %g5, 0
	fsub	%f5, %f1, %f0
	setL %g3, l.37617
	fldi	%f9, %g3, 0
	fmul	%f0, %f5, %f9
	subi	%g1, %g1, 4
	call	min_caml_floor
	setL %g3, l.37619
	fldi	%f6, %g3, 0
	fmul	%f0, %f0, %f6
	fsub	%f8, %f5, %f0
	setL %g3, l.37578
	fldi	%f5, %g3, 0
	fldi	%f1, %g31, 532
	fldi	%f0, %g5, -8
	fsub	%f7, %f1, %f0
	fmul	%f0, %f7, %f9
	call	min_caml_floor
	addi	%g1, %g1, 4
	fmul	%f0, %f0, %f6
	fsub	%f1, %f7, %f0
	fjlt	%f8, %f5, fjge_else.42974
	fjlt	%f1, %f5, fjge_else.42976
	setL %g3, l.35415
	fldi	%f0, %g3, 0
	jmp	fjge_cont.42977
fjge_else.42976:
	setL %g3, l.35401
	fldi	%f0, %g3, 0
fjge_cont.42977:
	jmp	fjge_cont.42975
fjge_else.42974:
	fjlt	%f1, %f5, fjge_else.42978
	setL %g3, l.35401
	fldi	%f0, %g3, 0
	jmp	fjge_cont.42979
fjge_else.42978:
	setL %g3, l.35415
	fldi	%f0, %g3, 0
fjge_cont.42979:
fjge_cont.42975:
	fsti	%f0, %g31, 564
	jmp	jeq_cont.42973
jeq_else.42972:
	addi	%g5, %g0, 2
	jne	%g4, %g5, jeq_else.42980
	fldi	%f1, %g31, 536
	setL %g3, l.37597
	fldi	%f0, %g3, 0
	fmul	%f2, %f1, %f0
	setL %g3, l.35391
	fldi	%f3, %g3, 0
	setL %g3, l.35393
	fldi	%f4, %g3, 0
	fjlt	%f2, %f16, fjge_else.42982
	fmov	%f1, %f2
	jmp	fjge_cont.42983
fjge_else.42982:
	fneg	%f1, %f2
fjge_cont.42983:
	fjlt	%f29, %f1, fjge_else.42984
	fjlt	%f1, %f16, fjge_else.42986
	fmov	%f0, %f1
	jmp	fjge_cont.42987
fjge_else.42986:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42988
	fjlt	%f1, %f16, fjge_else.42990
	fmov	%f0, %f1
	jmp	fjge_cont.42991
fjge_else.42990:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42992
	fjlt	%f1, %f16, fjge_else.42994
	fmov	%f0, %f1
	jmp	fjge_cont.42995
fjge_else.42994:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2480
	addi	%g1, %g1, 4
fjge_cont.42995:
	jmp	fjge_cont.42993
fjge_else.42992:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2480
	addi	%g1, %g1, 4
fjge_cont.42993:
fjge_cont.42991:
	jmp	fjge_cont.42989
fjge_else.42988:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42996
	fjlt	%f1, %f16, fjge_else.42998
	fmov	%f0, %f1
	jmp	fjge_cont.42999
fjge_else.42998:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2480
	addi	%g1, %g1, 4
fjge_cont.42999:
	jmp	fjge_cont.42997
fjge_else.42996:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2480
	addi	%g1, %g1, 4
fjge_cont.42997:
fjge_cont.42989:
fjge_cont.42987:
	jmp	fjge_cont.42985
fjge_else.42984:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43000
	fjlt	%f1, %f16, fjge_else.43002
	fmov	%f0, %f1
	jmp	fjge_cont.43003
fjge_else.43002:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43004
	fjlt	%f1, %f16, fjge_else.43006
	fmov	%f0, %f1
	jmp	fjge_cont.43007
fjge_else.43006:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2480
	addi	%g1, %g1, 4
fjge_cont.43007:
	jmp	fjge_cont.43005
fjge_else.43004:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2480
	addi	%g1, %g1, 4
fjge_cont.43005:
fjge_cont.43003:
	jmp	fjge_cont.43001
fjge_else.43000:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43008
	fjlt	%f1, %f16, fjge_else.43010
	fmov	%f0, %f1
	jmp	fjge_cont.43011
fjge_else.43010:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2480
	addi	%g1, %g1, 4
fjge_cont.43011:
	jmp	fjge_cont.43009
fjge_else.43008:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2480
	addi	%g1, %g1, 4
fjge_cont.43009:
fjge_cont.43001:
fjge_cont.42985:
	fjlt	%f3, %f0, fjge_else.43012
	fjlt	%f16, %f2, fjge_else.43014
	addi	%g3, %g0, 0
	jmp	fjge_cont.43015
fjge_else.43014:
	addi	%g3, %g0, 1
fjge_cont.43015:
	jmp	fjge_cont.43013
fjge_else.43012:
	fjlt	%f16, %f2, fjge_else.43016
	addi	%g3, %g0, 1
	jmp	fjge_cont.43017
fjge_else.43016:
	addi	%g3, %g0, 0
fjge_cont.43017:
fjge_cont.43013:
	fjlt	%f3, %f0, fjge_else.43018
	fmov	%f1, %f0
	jmp	fjge_cont.43019
fjge_else.43018:
	fsub	%f1, %f29, %f0
fjge_cont.43019:
	fjlt	%f22, %f1, fjge_else.43020
	fmov	%f0, %f1
	jmp	fjge_cont.43021
fjge_else.43020:
	fsub	%f0, %f3, %f1
fjge_cont.43021:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f4, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g3, %g0, jeq_else.43022
	fneg	%f1, %f0
	jmp	jeq_cont.43023
jeq_else.43022:
	fmov	%f1, %f0
jeq_cont.43023:
	fmul	%f0, %f1, %f1
	fmul	%f1, %f27, %f0
	fsti	%f1, %g31, 568
	fsub	%f0, %f17, %f0
	fmul	%f0, %f27, %f0
	fsti	%f0, %g31, 564
	jmp	jeq_cont.42981
jeq_else.42980:
	addi	%g5, %g0, 3
	jne	%g4, %g5, jeq_else.43024
	fldi	%f1, %g31, 540
	ldi	%g3, %g3, -20
	fldi	%f0, %g3, 0
	fsub	%f0, %f1, %f0
	fldi	%f2, %g31, 532
	fldi	%f1, %g3, -8
	fsub	%f1, %f2, %f1
	fmul	%f0, %f0, %f0
	fmul	%f1, %f1, %f1
	fadd	%f0, %f0, %f1
	fsqrt	%f0, %f0
	setL %g3, l.37578
	fldi	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	fsti	%f0, %g1, 0
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	fmov	%f1, %f0
	fldi	%f0, %g1, 0
	fsub	%f0, %f0, %f1
	fmul	%f0, %f0, %f30
	fsub	%f2, %f22, %f0
	setL %g3, l.35391
	fldi	%f3, %g3, 0
	setL %g3, l.35393
	fldi	%f4, %g3, 0
	fjlt	%f2, %f16, fjge_else.43026
	fmov	%f1, %f2
	jmp	fjge_cont.43027
fjge_else.43026:
	fneg	%f1, %f2
fjge_cont.43027:
	fjlt	%f29, %f1, fjge_else.43028
	fjlt	%f1, %f16, fjge_else.43030
	fmov	%f0, %f1
	jmp	fjge_cont.43031
fjge_else.43030:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43032
	fjlt	%f1, %f16, fjge_else.43034
	fmov	%f0, %f1
	jmp	fjge_cont.43035
fjge_else.43034:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43036
	fjlt	%f1, %f16, fjge_else.43038
	fmov	%f0, %f1
	jmp	fjge_cont.43039
fjge_else.43038:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2480
	addi	%g1, %g1, 8
fjge_cont.43039:
	jmp	fjge_cont.43037
fjge_else.43036:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2480
	addi	%g1, %g1, 8
fjge_cont.43037:
fjge_cont.43035:
	jmp	fjge_cont.43033
fjge_else.43032:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43040
	fjlt	%f1, %f16, fjge_else.43042
	fmov	%f0, %f1
	jmp	fjge_cont.43043
fjge_else.43042:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2480
	addi	%g1, %g1, 8
fjge_cont.43043:
	jmp	fjge_cont.43041
fjge_else.43040:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2480
	addi	%g1, %g1, 8
fjge_cont.43041:
fjge_cont.43033:
fjge_cont.43031:
	jmp	fjge_cont.43029
fjge_else.43028:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43044
	fjlt	%f1, %f16, fjge_else.43046
	fmov	%f0, %f1
	jmp	fjge_cont.43047
fjge_else.43046:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43048
	fjlt	%f1, %f16, fjge_else.43050
	fmov	%f0, %f1
	jmp	fjge_cont.43051
fjge_else.43050:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2480
	addi	%g1, %g1, 8
fjge_cont.43051:
	jmp	fjge_cont.43049
fjge_else.43048:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2480
	addi	%g1, %g1, 8
fjge_cont.43049:
fjge_cont.43047:
	jmp	fjge_cont.43045
fjge_else.43044:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43052
	fjlt	%f1, %f16, fjge_else.43054
	fmov	%f0, %f1
	jmp	fjge_cont.43055
fjge_else.43054:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2480
	addi	%g1, %g1, 8
fjge_cont.43055:
	jmp	fjge_cont.43053
fjge_else.43052:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2480
	addi	%g1, %g1, 8
fjge_cont.43053:
fjge_cont.43045:
fjge_cont.43029:
	fjlt	%f3, %f0, fjge_else.43056
	fjlt	%f16, %f2, fjge_else.43058
	addi	%g3, %g0, 0
	jmp	fjge_cont.43059
fjge_else.43058:
	addi	%g3, %g0, 1
fjge_cont.43059:
	jmp	fjge_cont.43057
fjge_else.43056:
	fjlt	%f16, %f2, fjge_else.43060
	addi	%g3, %g0, 1
	jmp	fjge_cont.43061
fjge_else.43060:
	addi	%g3, %g0, 0
fjge_cont.43061:
fjge_cont.43057:
	fjlt	%f3, %f0, fjge_else.43062
	fmov	%f1, %f0
	jmp	fjge_cont.43063
fjge_else.43062:
	fsub	%f1, %f29, %f0
fjge_cont.43063:
	fjlt	%f22, %f1, fjge_else.43064
	fmov	%f0, %f1
	jmp	fjge_cont.43065
fjge_else.43064:
	fsub	%f0, %f3, %f1
fjge_cont.43065:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f4, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g3, %g0, jeq_else.43066
	fneg	%f1, %f0
	jmp	jeq_cont.43067
jeq_else.43066:
	fmov	%f1, %f0
jeq_cont.43067:
	fmul	%f0, %f1, %f1
	fmul	%f1, %f0, %f27
	fsti	%f1, %g31, 564
	fsub	%f0, %f17, %f0
	fmul	%f0, %f0, %f27
	fsti	%f0, %g31, 560
	jmp	jeq_cont.43025
jeq_else.43024:
	addi	%g5, %g0, 4
	jne	%g4, %g5, jeq_else.43068
	fldi	%f1, %g31, 540
	ldi	%g6, %g3, -20
	fldi	%f0, %g6, 0
	fsub	%f1, %f1, %f0
	ldi	%g5, %g3, -16
	fldi	%f0, %g5, 0
	fsqrt	%f0, %f0
	fmul	%f1, %f1, %f0
	fldi	%f2, %g31, 532
	fldi	%f0, %g6, -8
	fsub	%f2, %f2, %f0
	fldi	%f0, %g5, -8
	fsqrt	%f0, %f0
	fmul	%f2, %f2, %f0
	fmul	%f3, %f1, %f1
	fmul	%f0, %f2, %f2
	fadd	%f5, %f3, %f0
	fjlt	%f1, %f16, fjge_else.43070
	fmov	%f0, %f1
	jmp	fjge_cont.43071
fjge_else.43070:
	fneg	%f0, %f1
fjge_cont.43071:
	setL %g3, l.37482
	fldi	%f6, %g3, 0
	fjlt	%f0, %f6, fjge_else.43072
	fdiv	%f1, %f2, %f1
	fjlt	%f1, %f16, fjge_else.43074
	fmov	%f0, %f1
	jmp	fjge_cont.43075
fjge_else.43074:
	fneg	%f0, %f1
fjge_cont.43075:
	fjlt	%f17, %f0, fjge_else.43076
	fjlt	%f0, %f20, fjge_else.43078
	addi	%g3, %g0, 0
	jmp	fjge_cont.43079
fjge_else.43078:
	addi	%g3, %g0, -1
fjge_cont.43079:
	jmp	fjge_cont.43077
fjge_else.43076:
	addi	%g3, %g0, 1
fjge_cont.43077:
	jne	%g3, %g0, jeq_else.43080
	fmov	%f3, %f0
	jmp	jeq_cont.43081
jeq_else.43080:
	fdiv	%f3, %f17, %f0
jeq_cont.43081:
	fmul	%f0, %f3, %f3
	setL %g4, l.37488
	fldi	%f1, %g4, 0
	fmul	%f2, %f1, %f0
	setL %g4, l.37490
	fldi	%f1, %g4, 0
	fdiv	%f2, %f2, %f1
	setL %g4, l.37492
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	setL %g4, l.37494
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.37496
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	setL %g4, l.37498
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.37500
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	setL %g4, l.37502
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.37504
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	fadd	%f1, %f28, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.37507
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	setL %g4, l.37509
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.37511
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	setL %g4, l.37513
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.37515
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	fadd	%f1, %f25, %f2
	fdiv	%f1, %f4, %f1
	fmul	%f2, %f25, %f0
	fadd	%f1, %f26, %f1
	fdiv	%f2, %f2, %f1
	setL %g4, l.37519
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	fadd	%f1, %f24, %f2
	fdiv	%f1, %f4, %f1
	fadd	%f1, %f23, %f1
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f3, %f0
	jlt	%g0, %g3, jle_else.43082
	jlt	%g3, %g0, jge_else.43084
	fmov	%f0, %f1
	jmp	jge_cont.43085
jge_else.43084:
	fsub	%f0, %f31, %f1
jge_cont.43085:
	jmp	jle_cont.43083
jle_else.43082:
	fsub	%f0, %f22, %f1
jle_cont.43083:
	setL %g3, l.37526
	fldi	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fdiv	%f0, %f0, %f30
	jmp	fjge_cont.43073
fjge_else.43072:
	setL %g3, l.37484
	fldi	%f0, %g3, 0
fjge_cont.43073:
	fsti	%f0, %g1, 4
	subi	%g1, %g1, 12
	call	min_caml_floor
	addi	%g1, %g1, 12
	fmov	%f1, %f0
	fldi	%f0, %g1, 4
	fsub	%f7, %f0, %f1
	fldi	%f1, %g31, 536
	fldi	%f0, %g6, -4
	fsub	%f1, %f1, %f0
	fldi	%f0, %g5, -4
	fsqrt	%f0, %f0
	fmul	%f1, %f1, %f0
	fjlt	%f5, %f16, fjge_else.43086
	fmov	%f0, %f5
	jmp	fjge_cont.43087
fjge_else.43086:
	fneg	%f0, %f5
fjge_cont.43087:
	fjlt	%f0, %f6, fjge_else.43088
	fdiv	%f1, %f1, %f5
	fjlt	%f1, %f16, fjge_else.43090
	fmov	%f0, %f1
	jmp	fjge_cont.43091
fjge_else.43090:
	fneg	%f0, %f1
fjge_cont.43091:
	fjlt	%f17, %f0, fjge_else.43092
	fjlt	%f0, %f20, fjge_else.43094
	addi	%g3, %g0, 0
	jmp	fjge_cont.43095
fjge_else.43094:
	addi	%g3, %g0, -1
fjge_cont.43095:
	jmp	fjge_cont.43093
fjge_else.43092:
	addi	%g3, %g0, 1
fjge_cont.43093:
	jne	%g3, %g0, jeq_else.43096
	fmov	%f4, %f0
	jmp	jeq_cont.43097
jeq_else.43096:
	fdiv	%f4, %f17, %f0
jeq_cont.43097:
	fmul	%f0, %f4, %f4
	setL %g4, l.37488
	fldi	%f1, %g4, 0
	fmul	%f2, %f1, %f0
	setL %g4, l.37490
	fldi	%f1, %g4, 0
	fdiv	%f2, %f2, %f1
	setL %g4, l.37492
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37494
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37496
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37498
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37500
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37502
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37504
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f28, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37507
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37509
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37511
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37513
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37515
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f25, %f2
	fdiv	%f1, %f3, %f1
	fmul	%f2, %f25, %f0
	fadd	%f1, %f26, %f1
	fdiv	%f2, %f2, %f1
	setL %g4, l.37519
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f24, %f2
	fdiv	%f1, %f3, %f1
	fadd	%f1, %f23, %f1
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f4, %f0
	jlt	%g0, %g3, jle_else.43098
	jlt	%g3, %g0, jge_else.43100
	fmov	%f1, %f0
	jmp	jge_cont.43101
jge_else.43100:
	fsub	%f1, %f31, %f0
jge_cont.43101:
	jmp	jle_cont.43099
jle_else.43098:
	fsub	%f1, %f22, %f0
jle_cont.43099:
	setL %g3, l.37526
	fldi	%f0, %g3, 0
	fmul	%f0, %f1, %f0
	fdiv	%f0, %f0, %f30
	jmp	fjge_cont.43089
fjge_else.43088:
	setL %g3, l.37484
	fldi	%f0, %g3, 0
fjge_cont.43089:
	fsti	%f0, %g1, 8
	subi	%g1, %g1, 16
	call	min_caml_floor
	addi	%g1, %g1, 16
	fmov	%f1, %f0
	fldi	%f0, %g1, 8
	fsub	%f0, %f0, %f1
	setL %g3, l.37563
	fldi	%f2, %g3, 0
	fsub	%f1, %f21, %f7
	fmul	%f1, %f1, %f1
	fsub	%f1, %f2, %f1
	fsub	%f0, %f21, %f0
	fmul	%f0, %f0, %f0
	fsub	%f1, %f1, %f0
	fjlt	%f1, %f16, fjge_else.43102
	fmov	%f0, %f1
	jmp	fjge_cont.43103
fjge_else.43102:
	fmov	%f0, %f16
fjge_cont.43103:
	fmul	%f1, %f27, %f0
	setL %g3, l.37567
	fldi	%f0, %g3, 0
	fdiv	%f0, %f1, %f0
	fsti	%f0, %g31, 560
	jmp	jeq_cont.43069
jeq_else.43068:
jeq_cont.43069:
jeq_cont.43025:
jeq_cont.42981:
jeq_cont.42973:
	slli	%g4, %g7, 2
	ldi	%g3, %g31, 524
	add	%g4, %g4, %g3
	slli	%g3, %g25, 2
	st	%g4, %g19, %g3
	slli	%g3, %g25, 2
	ld	%g3, %g20, %g3
	fldi	%f0, %g31, 540
	fsti	%f0, %g3, 0
	fldi	%f0, %g31, 536
	fsti	%f0, %g3, -4
	fldi	%f0, %g31, 532
	fsti	%f0, %g3, -8
	fldi	%f0, %g26, 0
	fjlt	%f0, %f21, fjge_else.43104
	addi	%g4, %g0, 1
	slli	%g3, %g25, 2
	st	%g4, %g18, %g3
	slli	%g3, %g25, 2
	ld	%g3, %g17, %g3
	fldi	%f0, %g31, 568
	fsti	%f0, %g3, 0
	fldi	%f0, %g31, 564
	fsti	%f0, %g3, -4
	fldi	%f0, %g31, 560
	fsti	%f0, %g3, -8
	slli	%g3, %g25, 2
	ld	%g4, %g17, %g3
	setL %g3, l.37663
	fldi	%f0, %g3, 0
	fmul	%f0, %f0, %f11
	fldi	%f1, %g4, 0
	fmul	%f1, %f1, %f0
	fsti	%f1, %g4, 0
	fldi	%f1, %g4, -4
	fmul	%f1, %f1, %f0
	fsti	%f1, %g4, -4
	fldi	%f1, %g4, -8
	fmul	%f0, %f1, %f0
	fsti	%f0, %g4, -8
	slli	%g3, %g25, 2
	ld	%g3, %g16, %g3
	fldi	%f0, %g31, 556
	fsti	%f0, %g3, 0
	fldi	%f0, %g31, 552
	fsti	%f0, %g3, -4
	fldi	%f0, %g31, 548
	fsti	%f0, %g3, -8
	jmp	fjge_cont.43105
fjge_else.43104:
	addi	%g4, %g0, 0
	slli	%g3, %g25, 2
	st	%g4, %g18, %g3
fjge_cont.43105:
	setL %g3, l.37685
	fldi	%f3, %g3, 0
	fldi	%f1, %g22, 0
	fldi	%f0, %g31, 556
	fmul	%f5, %f1, %f0
	fldi	%f4, %g22, -4
	fldi	%f2, %g31, 552
	fmul	%f2, %f4, %f2
	fadd	%f5, %f5, %f2
	fldi	%f4, %g22, -8
	fldi	%f2, %g31, 548
	fmul	%f2, %f4, %f2
	fadd	%f2, %f5, %f2
	fmul	%f2, %f3, %f2
	fmul	%f0, %f2, %f0
	fadd	%f0, %f1, %f0
	fsti	%f0, %g22, 0
	fldi	%f1, %g22, -4
	fldi	%f0, %g31, 552
	fmul	%f0, %f2, %f0
	fadd	%f0, %f1, %f0
	fsti	%f0, %g22, -4
	fldi	%f1, %g22, -8
	fldi	%f0, %g31, 548
	fmul	%f0, %f2, %f0
	fadd	%f0, %f1, %f0
	fsti	%f0, %g22, -8
	fldi	%f0, %g26, -4
	fmul	%f10, %f13, %f0
	addi	%g12, %g0, 0
	ldi	%g13, %g31, 516
	subi	%g1, %g1, 16
	call	shadow_check_one_or_matrix.2820
	addi	%g1, %g1, 16
	jne	%g3, %g0, jeq_else.43106
	fldi	%f1, %g31, 556
	fldi	%f0, %g31, 308
	fmul	%f2, %f1, %f0
	fldi	%f1, %g31, 552
	fldi	%f3, %g31, 304
	fmul	%f1, %f1, %f3
	fadd	%f4, %f2, %f1
	fldi	%f1, %g31, 548
	fldi	%f2, %g31, 300
	fmul	%f1, %f1, %f2
	fadd	%f1, %f4, %f1
	fneg	%f1, %f1
	fmul	%f1, %f1, %f11
	fldi	%f4, %g22, 0
	fmul	%f4, %f4, %f0
	fldi	%f0, %g22, -4
	fmul	%f0, %f0, %f3
	fadd	%f3, %f4, %f0
	fldi	%f0, %g22, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f3, %f0
	fneg	%f0, %f0
	fjlt	%f16, %f1, fjge_else.43108
	jmp	fjge_cont.43109
fjge_else.43108:
	fldi	%f3, %g31, 592
	fldi	%f2, %g31, 568
	fmul	%f2, %f1, %f2
	fadd	%f2, %f3, %f2
	fsti	%f2, %g31, 592
	fldi	%f3, %g31, 588
	fldi	%f2, %g31, 564
	fmul	%f2, %f1, %f2
	fadd	%f2, %f3, %f2
	fsti	%f2, %g31, 588
	fldi	%f3, %g31, 584
	fldi	%f2, %g31, 560
	fmul	%f1, %f1, %f2
	fadd	%f1, %f3, %f1
	fsti	%f1, %g31, 584
fjge_cont.43109:
	fjlt	%f16, %f0, fjge_else.43110
	jmp	fjge_cont.43111
fjge_else.43110:
	fmul	%f0, %f0, %f0
	fmul	%f0, %f0, %f0
	fmul	%f0, %f0, %f10
	fldi	%f1, %g31, 592
	fadd	%f1, %f1, %f0
	fsti	%f1, %g31, 592
	fldi	%f1, %g31, 588
	fadd	%f1, %f1, %f0
	fsti	%f1, %g31, 588
	fldi	%f1, %g31, 584
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 584
fjge_cont.43111:
	jmp	jeq_cont.43107
jeq_else.43106:
jeq_cont.43107:
	fldi	%f0, %g31, 540
	fsti	%f0, %g31, 636
	fldi	%f0, %g31, 536
	fsti	%f0, %g31, 632
	fldi	%f0, %g31, 532
	fsti	%f0, %g31, 628
	ldi	%g3, %g31, 28
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.43112
	slli	%g4, %g3, 2
	add	%g4, %g31, %g4
	ldi	%g4, %g4, 272
	ldi	%g7, %g4, -40
	ldi	%g6, %g4, -4
	fldi	%f1, %g31, 540
	ldi	%g5, %g4, -20
	fldi	%f0, %g5, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, 0
	fldi	%f1, %g31, 536
	fldi	%f0, %g5, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -4
	fldi	%f1, %g31, 532
	fldi	%f0, %g5, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -8
	addi	%g5, %g0, 2
	jne	%g6, %g5, jeq_else.43114
	ldi	%g4, %g4, -16
	fldi	%f1, %g7, 0
	fldi	%f3, %g7, -4
	fldi	%f2, %g7, -8
	fldi	%f0, %g4, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g4, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g7, -12
	jmp	jeq_cont.43115
jeq_else.43114:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.43116
	jmp	jle_cont.43117
jle_else.43116:
	fldi	%f2, %g7, 0
	fldi	%f1, %g7, -4
	fldi	%f0, %g7, -8
	fmul	%f4, %f2, %f2
	ldi	%g5, %g4, -16
	fldi	%f3, %g5, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g5, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g5, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g5, %g4, -12
	jne	%g5, %g0, jeq_else.43118
	fmov	%f3, %f4
	jmp	jeq_cont.43119
jeq_else.43118:
	fmul	%f5, %f1, %f0
	ldi	%g4, %g4, -36
	fldi	%f3, %g4, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g4, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g4, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.43119:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.43120
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.43121
jeq_else.43120:
	fmov	%f0, %f3
jeq_cont.43121:
	fsti	%f0, %g7, -12
jle_cont.43117:
jeq_cont.43115:
	subi	%g4, %g3, 1
	subi	%g3, %g31, 540
	subi	%g1, %g1, 16
	call	setup_startp_constants.2783
	addi	%g1, %g1, 16
	jmp	jge_cont.43113
jge_else.43112:
jge_cont.43113:
	ldi	%g3, %g31, 1720
	subi	%g3, %g3, 1
	sti	%g22, %g1, 12
	sti	%g16, %g1, 16
	sti	%g21, %g1, 20
	sti	%g23, %g1, 24
	sti	%g17, %g1, 28
	sti	%g18, %g1, 32
	sti	%g19, %g1, 36
	sti	%g20, %g1, 40
	sti	%g24, %g1, 44
	sti	%g19, %g1, 48
	mov	%g21, %g3
	subi	%g1, %g1, 56
	call	trace_reflections.2867
	addi	%g1, %g1, 56
	setL %g3, l.35626
	fldi	%f0, %g3, 0
	fjlt	%f0, %f13, fjge_else.43122
	return
fjge_else.43122:
	addi	%g3, %g0, 4
	jlt	%g25, %g3, jle_else.43124
	jmp	jle_cont.43125
jle_else.43124:
	addi	%g3, %g25, 1
	addi	%g4, %g0, -1
	slli	%g3, %g3, 2
	ldi	%g19, %g1, 48
	st	%g4, %g19, %g3
jle_cont.43125:
	addi	%g3, %g0, 2
	jne	%g30, %g3, jeq_else.43126
	fldi	%f0, %g26, 0
	fsub	%f0, %f17, %f0
	fmul	%f13, %f13, %f0
	addi	%g25, %g25, 1
	fldi	%f0, %g31, 528
	fadd	%f14, %f14, %f0
	ldi	%g24, %g1, 44
	ldi	%g20, %g1, 40
	ldi	%g19, %g1, 36
	ldi	%g18, %g1, 32
	ldi	%g17, %g1, 28
	ldi	%g23, %g1, 24
	ldi	%g21, %g1, 20
	ldi	%g16, %g1, 16
	ldi	%g22, %g1, 12
	jmp	trace_ray.2872
jeq_else.43126:
	return
jle_else.42947:
	return

!==============================
! args = [%g21, %g3]
! fargs = [%f10]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
trace_diffuse_ray.2878:
	setL %g4, l.35419
	fldi	%f0, %g4, 0
	fsti	%f0, %g31, 528
	addi	%g19, %g0, 0
	ldi	%g20, %g31, 516
	mov	%g17, %g3
	mov	%g18, %g21
	subi	%g1, %g1, 4
	call	trace_or_matrix_fast.2845
	addi	%g1, %g1, 4
	fldi	%f0, %g31, 528
	setL %g3, l.36577
	fldi	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.43129
	addi	%g3, %g0, 0
	jmp	fjge_cont.43130
fjge_else.43129:
	setL %g3, l.37312
	fldi	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.43131
	addi	%g3, %g0, 0
	jmp	fjge_cont.43132
fjge_else.43131:
	addi	%g3, %g0, 1
fjge_cont.43132:
fjge_cont.43130:
	jne	%g3, %g0, jeq_else.43133
	return
jeq_else.43133:
	ldi	%g3, %g31, 544
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g14, %g3, 272
	ldi	%g3, %g14, -4
	jne	%g3, %g28, jeq_else.43135
	ldi	%g3, %g31, 524
	fsti	%f16, %g31, 556
	fsti	%f16, %g31, 552
	fsti	%f16, %g31, 548
	subi	%g4, %g3, 1
	slli	%g3, %g4, 2
	fld	%f1, %g21, %g3
	fjeq	%f1, %f16, fjne_else.43137
	fjlt	%f16, %f1, fjge_else.43139
	setL %g3, l.35940
	fldi	%f0, %g3, 0
	jmp	fjge_cont.43140
fjge_else.43139:
	setL %g3, l.35549
	fldi	%f0, %g3, 0
fjge_cont.43140:
	jmp	fjne_cont.43138
fjne_else.43137:
	fmov	%f0, %f16
fjne_cont.43138:
	fneg	%f0, %f0
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	fsti	%f0, %g3, 556
	jmp	jeq_cont.43136
jeq_else.43135:
	addi	%g4, %g0, 2
	jne	%g3, %g4, jeq_else.43141
	ldi	%g3, %g14, -16
	fldi	%f0, %g3, 0
	fneg	%f0, %f0
	fsti	%f0, %g31, 556
	fldi	%f0, %g3, -4
	fneg	%f0, %f0
	fsti	%f0, %g31, 552
	fldi	%f0, %g3, -8
	fneg	%f0, %f0
	fsti	%f0, %g31, 548
	jmp	jeq_cont.43142
jeq_else.43141:
	fldi	%f1, %g31, 540
	ldi	%g3, %g14, -20
	fldi	%f0, %g3, 0
	fsub	%f4, %f1, %f0
	fldi	%f1, %g31, 536
	fldi	%f0, %g3, -4
	fsub	%f3, %f1, %f0
	fldi	%f1, %g31, 532
	fldi	%f0, %g3, -8
	fsub	%f0, %f1, %f0
	ldi	%g3, %g14, -16
	fldi	%f1, %g3, 0
	fmul	%f2, %f4, %f1
	fldi	%f1, %g3, -4
	fmul	%f6, %f3, %f1
	fldi	%f1, %g3, -8
	fmul	%f7, %f0, %f1
	ldi	%g3, %g14, -12
	jne	%g3, %g0, jeq_else.43143
	fsti	%f2, %g31, 556
	fsti	%f6, %g31, 552
	fsti	%f7, %g31, 548
	jmp	jeq_cont.43144
jeq_else.43143:
	ldi	%g3, %g14, -36
	fldi	%f1, %g3, -8
	fmul	%f5, %f3, %f1
	fldi	%f1, %g3, -4
	fmul	%f1, %f0, %f1
	fadd	%f1, %f5, %f1
	fmul	%f1, %f1, %f21
	fadd	%f1, %f2, %f1
	fsti	%f1, %g31, 556
	fldi	%f1, %g3, -8
	fmul	%f2, %f4, %f1
	fldi	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	fmul	%f0, %f0, %f21
	fadd	%f0, %f6, %f0
	fsti	%f0, %g31, 552
	fldi	%f0, %g3, -4
	fmul	%f1, %f4, %f0
	fldi	%f0, %g3, 0
	fmul	%f0, %f3, %f0
	fadd	%f0, %f1, %f0
	fmul	%f0, %f0, %f21
	fadd	%f0, %f7, %f0
	fsti	%f0, %g31, 548
jeq_cont.43144:
	ldi	%g3, %g14, -24
	fldi	%f2, %g31, 556
	fmul	%f1, %f2, %f2
	fldi	%f0, %g31, 552
	fmul	%f0, %f0, %f0
	fadd	%f1, %f1, %f0
	fldi	%f0, %g31, 548
	fmul	%f0, %f0, %f0
	fadd	%f0, %f1, %f0
	fsqrt	%f1, %f0
	fjeq	%f1, %f16, fjne_else.43145
	jne	%g3, %g0, jeq_else.43147
	fdiv	%f0, %f17, %f1
	jmp	jeq_cont.43148
jeq_else.43147:
	fdiv	%f0, %f20, %f1
jeq_cont.43148:
	jmp	fjne_cont.43146
fjne_else.43145:
	setL %g3, l.35549
	fldi	%f0, %g3, 0
fjne_cont.43146:
	fmul	%f1, %f2, %f0
	fsti	%f1, %g31, 556
	fldi	%f1, %g31, 552
	fmul	%f1, %f1, %f0
	fsti	%f1, %g31, 552
	fldi	%f1, %g31, 548
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 548
jeq_cont.43142:
jeq_cont.43136:
	ldi	%g3, %g14, 0
	ldi	%g4, %g14, -32
	fldi	%f0, %g4, 0
	fsti	%f0, %g31, 568
	fldi	%f0, %g4, -4
	fsti	%f0, %g31, 564
	fldi	%f0, %g4, -8
	fsti	%f0, %g31, 560
	jne	%g3, %g28, jeq_else.43149
	fldi	%f1, %g31, 540
	ldi	%g5, %g14, -20
	fldi	%f0, %g5, 0
	fsub	%f5, %f1, %f0
	setL %g3, l.37617
	fldi	%f9, %g3, 0
	fmul	%f0, %f5, %f9
	subi	%g1, %g1, 4
	call	min_caml_floor
	setL %g3, l.37619
	fldi	%f8, %g3, 0
	fmul	%f0, %f0, %f8
	fsub	%f7, %f5, %f0
	setL %g3, l.37578
	fldi	%f6, %g3, 0
	fldi	%f1, %g31, 532
	fldi	%f0, %g5, -8
	fsub	%f5, %f1, %f0
	fmul	%f0, %f5, %f9
	call	min_caml_floor
	addi	%g1, %g1, 4
	fmul	%f0, %f0, %f8
	fsub	%f1, %f5, %f0
	fjlt	%f7, %f6, fjge_else.43151
	fjlt	%f1, %f6, fjge_else.43153
	setL %g3, l.35415
	fldi	%f0, %g3, 0
	jmp	fjge_cont.43154
fjge_else.43153:
	setL %g3, l.35401
	fldi	%f0, %g3, 0
fjge_cont.43154:
	jmp	fjge_cont.43152
fjge_else.43151:
	fjlt	%f1, %f6, fjge_else.43155
	setL %g3, l.35401
	fldi	%f0, %g3, 0
	jmp	fjge_cont.43156
fjge_else.43155:
	setL %g3, l.35415
	fldi	%f0, %g3, 0
fjge_cont.43156:
fjge_cont.43152:
	fsti	%f0, %g31, 564
	jmp	jeq_cont.43150
jeq_else.43149:
	addi	%g4, %g0, 2
	jne	%g3, %g4, jeq_else.43157
	fldi	%f1, %g31, 536
	setL %g3, l.37597
	fldi	%f0, %g3, 0
	fmul	%f2, %f1, %f0
	setL %g3, l.35391
	fldi	%f3, %g3, 0
	setL %g3, l.35393
	fldi	%f4, %g3, 0
	fjlt	%f2, %f16, fjge_else.43159
	fmov	%f1, %f2
	jmp	fjge_cont.43160
fjge_else.43159:
	fneg	%f1, %f2
fjge_cont.43160:
	fjlt	%f29, %f1, fjge_else.43161
	fjlt	%f1, %f16, fjge_else.43163
	fmov	%f0, %f1
	jmp	fjge_cont.43164
fjge_else.43163:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43165
	fjlt	%f1, %f16, fjge_else.43167
	fmov	%f0, %f1
	jmp	fjge_cont.43168
fjge_else.43167:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43169
	fjlt	%f1, %f16, fjge_else.43171
	fmov	%f0, %f1
	jmp	fjge_cont.43172
fjge_else.43171:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2480
	addi	%g1, %g1, 4
fjge_cont.43172:
	jmp	fjge_cont.43170
fjge_else.43169:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2480
	addi	%g1, %g1, 4
fjge_cont.43170:
fjge_cont.43168:
	jmp	fjge_cont.43166
fjge_else.43165:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43173
	fjlt	%f1, %f16, fjge_else.43175
	fmov	%f0, %f1
	jmp	fjge_cont.43176
fjge_else.43175:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2480
	addi	%g1, %g1, 4
fjge_cont.43176:
	jmp	fjge_cont.43174
fjge_else.43173:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2480
	addi	%g1, %g1, 4
fjge_cont.43174:
fjge_cont.43166:
fjge_cont.43164:
	jmp	fjge_cont.43162
fjge_else.43161:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43177
	fjlt	%f1, %f16, fjge_else.43179
	fmov	%f0, %f1
	jmp	fjge_cont.43180
fjge_else.43179:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43181
	fjlt	%f1, %f16, fjge_else.43183
	fmov	%f0, %f1
	jmp	fjge_cont.43184
fjge_else.43183:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2480
	addi	%g1, %g1, 4
fjge_cont.43184:
	jmp	fjge_cont.43182
fjge_else.43181:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2480
	addi	%g1, %g1, 4
fjge_cont.43182:
fjge_cont.43180:
	jmp	fjge_cont.43178
fjge_else.43177:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43185
	fjlt	%f1, %f16, fjge_else.43187
	fmov	%f0, %f1
	jmp	fjge_cont.43188
fjge_else.43187:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2480
	addi	%g1, %g1, 4
fjge_cont.43188:
	jmp	fjge_cont.43186
fjge_else.43185:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2480
	addi	%g1, %g1, 4
fjge_cont.43186:
fjge_cont.43178:
fjge_cont.43162:
	fjlt	%f3, %f0, fjge_else.43189
	fjlt	%f16, %f2, fjge_else.43191
	addi	%g3, %g0, 0
	jmp	fjge_cont.43192
fjge_else.43191:
	addi	%g3, %g0, 1
fjge_cont.43192:
	jmp	fjge_cont.43190
fjge_else.43189:
	fjlt	%f16, %f2, fjge_else.43193
	addi	%g3, %g0, 1
	jmp	fjge_cont.43194
fjge_else.43193:
	addi	%g3, %g0, 0
fjge_cont.43194:
fjge_cont.43190:
	fjlt	%f3, %f0, fjge_else.43195
	fmov	%f1, %f0
	jmp	fjge_cont.43196
fjge_else.43195:
	fsub	%f1, %f29, %f0
fjge_cont.43196:
	fjlt	%f22, %f1, fjge_else.43197
	fmov	%f0, %f1
	jmp	fjge_cont.43198
fjge_else.43197:
	fsub	%f0, %f3, %f1
fjge_cont.43198:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f4, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g3, %g0, jeq_else.43199
	fneg	%f1, %f0
	jmp	jeq_cont.43200
jeq_else.43199:
	fmov	%f1, %f0
jeq_cont.43200:
	fmul	%f0, %f1, %f1
	fmul	%f1, %f27, %f0
	fsti	%f1, %g31, 568
	fsub	%f0, %f17, %f0
	fmul	%f0, %f27, %f0
	fsti	%f0, %g31, 564
	jmp	jeq_cont.43158
jeq_else.43157:
	addi	%g4, %g0, 3
	jne	%g3, %g4, jeq_else.43201
	fldi	%f1, %g31, 540
	ldi	%g3, %g14, -20
	fldi	%f0, %g3, 0
	fsub	%f1, %f1, %f0
	fldi	%f2, %g31, 532
	fldi	%f0, %g3, -8
	fsub	%f0, %f2, %f0
	fmul	%f1, %f1, %f1
	fmul	%f0, %f0, %f0
	fadd	%f0, %f1, %f0
	fsqrt	%f0, %f0
	setL %g3, l.37578
	fldi	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	fsti	%f0, %g1, 0
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	fmov	%f1, %f0
	fldi	%f0, %g1, 0
	fsub	%f0, %f0, %f1
	fmul	%f0, %f0, %f30
	fsub	%f2, %f22, %f0
	setL %g3, l.35391
	fldi	%f3, %g3, 0
	setL %g3, l.35393
	fldi	%f4, %g3, 0
	fjlt	%f2, %f16, fjge_else.43203
	fmov	%f1, %f2
	jmp	fjge_cont.43204
fjge_else.43203:
	fneg	%f1, %f2
fjge_cont.43204:
	fjlt	%f29, %f1, fjge_else.43205
	fjlt	%f1, %f16, fjge_else.43207
	fmov	%f0, %f1
	jmp	fjge_cont.43208
fjge_else.43207:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43209
	fjlt	%f1, %f16, fjge_else.43211
	fmov	%f0, %f1
	jmp	fjge_cont.43212
fjge_else.43211:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43213
	fjlt	%f1, %f16, fjge_else.43215
	fmov	%f0, %f1
	jmp	fjge_cont.43216
fjge_else.43215:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2480
	addi	%g1, %g1, 8
fjge_cont.43216:
	jmp	fjge_cont.43214
fjge_else.43213:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2480
	addi	%g1, %g1, 8
fjge_cont.43214:
fjge_cont.43212:
	jmp	fjge_cont.43210
fjge_else.43209:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43217
	fjlt	%f1, %f16, fjge_else.43219
	fmov	%f0, %f1
	jmp	fjge_cont.43220
fjge_else.43219:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2480
	addi	%g1, %g1, 8
fjge_cont.43220:
	jmp	fjge_cont.43218
fjge_else.43217:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2480
	addi	%g1, %g1, 8
fjge_cont.43218:
fjge_cont.43210:
fjge_cont.43208:
	jmp	fjge_cont.43206
fjge_else.43205:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43221
	fjlt	%f1, %f16, fjge_else.43223
	fmov	%f0, %f1
	jmp	fjge_cont.43224
fjge_else.43223:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43225
	fjlt	%f1, %f16, fjge_else.43227
	fmov	%f0, %f1
	jmp	fjge_cont.43228
fjge_else.43227:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2480
	addi	%g1, %g1, 8
fjge_cont.43228:
	jmp	fjge_cont.43226
fjge_else.43225:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2480
	addi	%g1, %g1, 8
fjge_cont.43226:
fjge_cont.43224:
	jmp	fjge_cont.43222
fjge_else.43221:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43229
	fjlt	%f1, %f16, fjge_else.43231
	fmov	%f0, %f1
	jmp	fjge_cont.43232
fjge_else.43231:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2480
	addi	%g1, %g1, 8
fjge_cont.43232:
	jmp	fjge_cont.43230
fjge_else.43229:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2480
	addi	%g1, %g1, 8
fjge_cont.43230:
fjge_cont.43222:
fjge_cont.43206:
	fjlt	%f3, %f0, fjge_else.43233
	fjlt	%f16, %f2, fjge_else.43235
	addi	%g3, %g0, 0
	jmp	fjge_cont.43236
fjge_else.43235:
	addi	%g3, %g0, 1
fjge_cont.43236:
	jmp	fjge_cont.43234
fjge_else.43233:
	fjlt	%f16, %f2, fjge_else.43237
	addi	%g3, %g0, 1
	jmp	fjge_cont.43238
fjge_else.43237:
	addi	%g3, %g0, 0
fjge_cont.43238:
fjge_cont.43234:
	fjlt	%f3, %f0, fjge_else.43239
	fmov	%f1, %f0
	jmp	fjge_cont.43240
fjge_else.43239:
	fsub	%f1, %f29, %f0
fjge_cont.43240:
	fjlt	%f22, %f1, fjge_else.43241
	fmov	%f0, %f1
	jmp	fjge_cont.43242
fjge_else.43241:
	fsub	%f0, %f3, %f1
fjge_cont.43242:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f4, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g3, %g0, jeq_else.43243
	fneg	%f1, %f0
	jmp	jeq_cont.43244
jeq_else.43243:
	fmov	%f1, %f0
jeq_cont.43244:
	fmul	%f0, %f1, %f1
	fmul	%f1, %f0, %f27
	fsti	%f1, %g31, 564
	fsub	%f0, %f17, %f0
	fmul	%f0, %f0, %f27
	fsti	%f0, %g31, 560
	jmp	jeq_cont.43202
jeq_else.43201:
	addi	%g4, %g0, 4
	jne	%g3, %g4, jeq_else.43245
	fldi	%f1, %g31, 540
	ldi	%g5, %g14, -20
	fldi	%f0, %g5, 0
	fsub	%f1, %f1, %f0
	ldi	%g6, %g14, -16
	fldi	%f0, %g6, 0
	fsqrt	%f0, %f0
	fmul	%f1, %f1, %f0
	fldi	%f2, %g31, 532
	fldi	%f0, %g5, -8
	fsub	%f2, %f2, %f0
	fldi	%f0, %g6, -8
	fsqrt	%f0, %f0
	fmul	%f2, %f2, %f0
	fmul	%f3, %f1, %f1
	fmul	%f0, %f2, %f2
	fadd	%f5, %f3, %f0
	fjlt	%f1, %f16, fjge_else.43247
	fmov	%f0, %f1
	jmp	fjge_cont.43248
fjge_else.43247:
	fneg	%f0, %f1
fjge_cont.43248:
	setL %g3, l.37482
	fldi	%f6, %g3, 0
	fjlt	%f0, %f6, fjge_else.43249
	fdiv	%f1, %f2, %f1
	fjlt	%f1, %f16, fjge_else.43251
	fmov	%f0, %f1
	jmp	fjge_cont.43252
fjge_else.43251:
	fneg	%f0, %f1
fjge_cont.43252:
	fjlt	%f17, %f0, fjge_else.43253
	fjlt	%f0, %f20, fjge_else.43255
	addi	%g3, %g0, 0
	jmp	fjge_cont.43256
fjge_else.43255:
	addi	%g3, %g0, -1
fjge_cont.43256:
	jmp	fjge_cont.43254
fjge_else.43253:
	addi	%g3, %g0, 1
fjge_cont.43254:
	jne	%g3, %g0, jeq_else.43257
	fmov	%f4, %f0
	jmp	jeq_cont.43258
jeq_else.43257:
	fdiv	%f4, %f17, %f0
jeq_cont.43258:
	fmul	%f0, %f4, %f4
	setL %g4, l.37488
	fldi	%f1, %g4, 0
	fmul	%f2, %f1, %f0
	setL %g4, l.37490
	fldi	%f1, %g4, 0
	fdiv	%f2, %f2, %f1
	setL %g4, l.37492
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37494
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37496
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37498
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37500
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37502
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37504
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f28, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37507
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37509
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37511
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37513
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37515
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f25, %f2
	fdiv	%f1, %f3, %f1
	fmul	%f2, %f25, %f0
	fadd	%f1, %f26, %f1
	fdiv	%f2, %f2, %f1
	setL %g4, l.37519
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f24, %f2
	fdiv	%f1, %f3, %f1
	fadd	%f1, %f23, %f1
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f4, %f0
	jlt	%g0, %g3, jle_else.43259
	jlt	%g3, %g0, jge_else.43261
	fmov	%f0, %f1
	jmp	jge_cont.43262
jge_else.43261:
	fsub	%f0, %f31, %f1
jge_cont.43262:
	jmp	jle_cont.43260
jle_else.43259:
	fsub	%f0, %f22, %f1
jle_cont.43260:
	setL %g3, l.37526
	fldi	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fdiv	%f0, %f0, %f30
	jmp	fjge_cont.43250
fjge_else.43249:
	setL %g3, l.37484
	fldi	%f0, %g3, 0
fjge_cont.43250:
	fsti	%f0, %g1, 4
	subi	%g1, %g1, 12
	call	min_caml_floor
	addi	%g1, %g1, 12
	fmov	%f1, %f0
	fldi	%f0, %g1, 4
	fsub	%f7, %f0, %f1
	fldi	%f1, %g31, 536
	fldi	%f0, %g5, -4
	fsub	%f1, %f1, %f0
	fldi	%f0, %g6, -4
	fsqrt	%f0, %f0
	fmul	%f1, %f1, %f0
	fjlt	%f5, %f16, fjge_else.43263
	fmov	%f0, %f5
	jmp	fjge_cont.43264
fjge_else.43263:
	fneg	%f0, %f5
fjge_cont.43264:
	fjlt	%f0, %f6, fjge_else.43265
	fdiv	%f1, %f1, %f5
	fjlt	%f1, %f16, fjge_else.43267
	fmov	%f0, %f1
	jmp	fjge_cont.43268
fjge_else.43267:
	fneg	%f0, %f1
fjge_cont.43268:
	fjlt	%f17, %f0, fjge_else.43269
	fjlt	%f0, %f20, fjge_else.43271
	addi	%g3, %g0, 0
	jmp	fjge_cont.43272
fjge_else.43271:
	addi	%g3, %g0, -1
fjge_cont.43272:
	jmp	fjge_cont.43270
fjge_else.43269:
	addi	%g3, %g0, 1
fjge_cont.43270:
	jne	%g3, %g0, jeq_else.43273
	fmov	%f4, %f0
	jmp	jeq_cont.43274
jeq_else.43273:
	fdiv	%f4, %f17, %f0
jeq_cont.43274:
	fmul	%f0, %f4, %f4
	setL %g4, l.37488
	fldi	%f1, %g4, 0
	fmul	%f2, %f1, %f0
	setL %g4, l.37490
	fldi	%f1, %g4, 0
	fdiv	%f2, %f2, %f1
	setL %g4, l.37492
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37494
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37496
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37498
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37500
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37502
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37504
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f28, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37507
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37509
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37511
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37513
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37515
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f25, %f2
	fdiv	%f2, %f3, %f1
	fmul	%f1, %f25, %f0
	fadd	%f2, %f26, %f2
	fdiv	%f1, %f1, %f2
	setL %g4, l.37519
	fldi	%f2, %g4, 0
	fmul	%f2, %f2, %f0
	fadd	%f1, %f24, %f1
	fdiv	%f1, %f2, %f1
	fadd	%f1, %f23, %f1
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f4, %f0
	jlt	%g0, %g3, jle_else.43275
	jlt	%g3, %g0, jge_else.43277
	fmov	%f1, %f0
	jmp	jge_cont.43278
jge_else.43277:
	fsub	%f1, %f31, %f0
jge_cont.43278:
	jmp	jle_cont.43276
jle_else.43275:
	fsub	%f1, %f22, %f0
jle_cont.43276:
	setL %g3, l.37526
	fldi	%f0, %g3, 0
	fmul	%f0, %f1, %f0
	fdiv	%f0, %f0, %f30
	jmp	fjge_cont.43266
fjge_else.43265:
	setL %g3, l.37484
	fldi	%f0, %g3, 0
fjge_cont.43266:
	fsti	%f0, %g1, 8
	subi	%g1, %g1, 16
	call	min_caml_floor
	addi	%g1, %g1, 16
	fmov	%f1, %f0
	fldi	%f0, %g1, 8
	fsub	%f0, %f0, %f1
	setL %g3, l.37563
	fldi	%f2, %g3, 0
	fsub	%f1, %f21, %f7
	fmul	%f1, %f1, %f1
	fsub	%f1, %f2, %f1
	fsub	%f0, %f21, %f0
	fmul	%f0, %f0, %f0
	fsub	%f1, %f1, %f0
	fjlt	%f1, %f16, fjge_else.43279
	fmov	%f0, %f1
	jmp	fjge_cont.43280
fjge_else.43279:
	fmov	%f0, %f16
fjge_cont.43280:
	fmul	%f1, %f27, %f0
	setL %g3, l.37567
	fldi	%f0, %g3, 0
	fdiv	%f0, %f1, %f0
	fsti	%f0, %g31, 560
	jmp	jeq_cont.43246
jeq_else.43245:
jeq_cont.43246:
jeq_cont.43202:
jeq_cont.43158:
jeq_cont.43150:
	addi	%g12, %g0, 0
	ldi	%g13, %g31, 516
	subi	%g1, %g1, 16
	call	shadow_check_one_or_matrix.2820
	addi	%g1, %g1, 16
	jne	%g3, %g0, jeq_else.43281
	fldi	%f1, %g31, 556
	fldi	%f0, %g31, 308
	fmul	%f2, %f1, %f0
	fldi	%f1, %g31, 552
	fldi	%f0, %g31, 304
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g31, 548
	fldi	%f0, %g31, 300
	fmul	%f0, %f1, %f0
	fadd	%f1, %f2, %f0
	fneg	%f1, %f1
	fjlt	%f16, %f1, fjge_else.43282
	fmov	%f0, %f16
	jmp	fjge_cont.43283
fjge_else.43282:
	fmov	%f0, %f1
fjge_cont.43283:
	fmul	%f1, %f10, %f0
	ldi	%g3, %g14, -28
	fldi	%f0, %g3, 0
	fmul	%f0, %f1, %f0
	fldi	%f2, %g31, 580
	fldi	%f1, %g31, 568
	fmul	%f1, %f0, %f1
	fadd	%f1, %f2, %f1
	fsti	%f1, %g31, 580
	fldi	%f2, %g31, 576
	fldi	%f1, %g31, 564
	fmul	%f1, %f0, %f1
	fadd	%f1, %f2, %f1
	fsti	%f1, %g31, 576
	fldi	%f2, %g31, 572
	fldi	%f1, %g31, 560
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	fsti	%f0, %g31, 572
	return
jeq_else.43281:
	return

!==============================
! args = [%g23, %g22, %g24, %g25]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
iter_trace_diffuse_rays.2881:
	jlt	%g25, %g0, jge_else.43286
	slli	%g3, %g25, 2
	ld	%g3, %g23, %g3
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43287
	slli	%g3, %g25, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 4
	jmp	fjge_cont.43288
fjge_else.43287:
	addi	%g3, %g25, 1
	slli	%g3, %g3, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 4
fjge_cont.43288:
	subi	%g25, %g25, 2
	jlt	%g25, %g0, jge_else.43289
	slli	%g3, %g25, 2
	ld	%g3, %g23, %g3
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43290
	slli	%g3, %g25, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 4
	jmp	fjge_cont.43291
fjge_else.43290:
	addi	%g3, %g25, 1
	slli	%g3, %g3, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 4
fjge_cont.43291:
	subi	%g25, %g25, 2
	jlt	%g25, %g0, jge_else.43292
	slli	%g3, %g25, 2
	ld	%g3, %g23, %g3
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43293
	slli	%g3, %g25, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 4
	jmp	fjge_cont.43294
fjge_else.43293:
	addi	%g3, %g25, 1
	slli	%g3, %g3, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 4
fjge_cont.43294:
	subi	%g25, %g25, 2
	jlt	%g25, %g0, jge_else.43295
	slli	%g3, %g25, 2
	ld	%g3, %g23, %g3
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43296
	slli	%g3, %g25, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 4
	jmp	fjge_cont.43297
fjge_else.43296:
	addi	%g3, %g25, 1
	slli	%g3, %g3, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 4
fjge_cont.43297:
	subi	%g25, %g25, 2
	jmp	iter_trace_diffuse_rays.2881
jge_else.43295:
	return
jge_else.43292:
	return
jge_else.43289:
	return
jge_else.43286:
	return

!==============================
! args = [%g15, %g14, %g13, %g12, %g11, %g10, %g9, %g25, %g26]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
do_without_neighbors.2903:
	addi	%g3, %g0, 4
	jlt	%g3, %g26, jle_else.43302
	slli	%g3, %g26, 2
	ld	%g3, %g13, %g3
	jlt	%g3, %g0, jge_else.43303
	slli	%g3, %g26, 2
	ld	%g3, %g12, %g3
	sti	%g25, %g1, 0
	sti	%g9, %g1, 4
	sti	%g10, %g1, 8
	sti	%g11, %g1, 12
	sti	%g12, %g1, 16
	sti	%g13, %g1, 20
	sti	%g14, %g1, 24
	sti	%g15, %g1, 28
	jne	%g3, %g0, jeq_else.43304
	jmp	jeq_cont.43305
jeq_else.43304:
	slli	%g3, %g26, 2
	ld	%g3, %g10, %g3
	fldi	%f0, %g3, 0
	fsti	%f0, %g31, 580
	fldi	%f0, %g3, -4
	fsti	%f0, %g31, 576
	fldi	%f0, %g3, -8
	fsti	%f0, %g31, 572
	ldi	%g30, %g9, 0
	slli	%g3, %g26, 2
	ld	%g22, %g25, %g3
	slli	%g3, %g26, 2
	ld	%g24, %g14, %g3
	sti	%g11, %g1, 32
	sti	%g22, %g1, 36
	sti	%g24, %g1, 40
	jne	%g30, %g0, jeq_else.43306
	jmp	jeq_cont.43307
jeq_else.43306:
	ldi	%g23, %g31, 716
	fldi	%f0, %g24, 0
	fsti	%f0, %g31, 636
	fldi	%f0, %g24, -4
	fsti	%f0, %g31, 632
	fldi	%f0, %g24, -8
	fsti	%f0, %g31, 628
	ldi	%g3, %g31, 28
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.43308
	slli	%g4, %g3, 2
	add	%g4, %g31, %g4
	ldi	%g4, %g4, 272
	ldi	%g7, %g4, -40
	ldi	%g6, %g4, -4
	fldi	%f1, %g24, 0
	ldi	%g5, %g4, -20
	fldi	%f0, %g5, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, 0
	fldi	%f1, %g24, -4
	fldi	%f0, %g5, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -4
	fldi	%f1, %g24, -8
	fldi	%f0, %g5, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -8
	addi	%g5, %g0, 2
	jne	%g6, %g5, jeq_else.43310
	ldi	%g4, %g4, -16
	fldi	%f1, %g7, 0
	fldi	%f3, %g7, -4
	fldi	%f2, %g7, -8
	fldi	%f0, %g4, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g4, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g7, -12
	jmp	jeq_cont.43311
jeq_else.43310:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.43312
	jmp	jle_cont.43313
jle_else.43312:
	fldi	%f2, %g7, 0
	fldi	%f1, %g7, -4
	fldi	%f0, %g7, -8
	fmul	%f4, %f2, %f2
	ldi	%g5, %g4, -16
	fldi	%f3, %g5, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g5, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g5, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g5, %g4, -12
	jne	%g5, %g0, jeq_else.43314
	fmov	%f3, %f4
	jmp	jeq_cont.43315
jeq_else.43314:
	fmul	%f5, %f1, %f0
	ldi	%g4, %g4, -36
	fldi	%f3, %g4, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g4, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g4, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.43315:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.43316
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.43317
jeq_else.43316:
	fmov	%f0, %f3
jeq_cont.43317:
	fsti	%f0, %g7, -12
jle_cont.43313:
jeq_cont.43311:
	subi	%g4, %g3, 1
	mov	%g3, %g24
	subi	%g1, %g1, 48
	call	setup_startp_constants.2783
	addi	%g1, %g1, 48
	jmp	jge_cont.43309
jge_else.43308:
jge_cont.43309:
	ldi	%g3, %g23, -472
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43318
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
	jmp	fjge_cont.43319
fjge_else.43318:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
fjge_cont.43319:
	ldi	%g3, %g23, -464
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43320
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
	jmp	fjge_cont.43321
fjge_else.43320:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
fjge_cont.43321:
	ldi	%g3, %g23, -456
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43322
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
	jmp	fjge_cont.43323
fjge_else.43322:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
fjge_cont.43323:
	addi	%g3, %g0, 112
	mov	%g25, %g3
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2881
	addi	%g1, %g1, 48
jeq_cont.43307:
	jne	%g30, %g28, jeq_else.43324
	jmp	jeq_cont.43325
jeq_else.43324:
	ldi	%g23, %g31, 712
	ldi	%g24, %g1, 40
	fldi	%f0, %g24, 0
	fsti	%f0, %g31, 636
	fldi	%f0, %g24, -4
	fsti	%f0, %g31, 632
	fldi	%f0, %g24, -8
	fsti	%f0, %g31, 628
	ldi	%g3, %g31, 28
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.43326
	slli	%g4, %g3, 2
	add	%g4, %g31, %g4
	ldi	%g4, %g4, 272
	ldi	%g7, %g4, -40
	ldi	%g6, %g4, -4
	fldi	%f1, %g24, 0
	ldi	%g5, %g4, -20
	fldi	%f0, %g5, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, 0
	fldi	%f1, %g24, -4
	fldi	%f0, %g5, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -4
	fldi	%f1, %g24, -8
	fldi	%f0, %g5, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -8
	addi	%g5, %g0, 2
	jne	%g6, %g5, jeq_else.43328
	ldi	%g4, %g4, -16
	fldi	%f1, %g7, 0
	fldi	%f3, %g7, -4
	fldi	%f2, %g7, -8
	fldi	%f0, %g4, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g4, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g7, -12
	jmp	jeq_cont.43329
jeq_else.43328:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.43330
	jmp	jle_cont.43331
jle_else.43330:
	fldi	%f2, %g7, 0
	fldi	%f1, %g7, -4
	fldi	%f0, %g7, -8
	fmul	%f4, %f2, %f2
	ldi	%g5, %g4, -16
	fldi	%f3, %g5, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g5, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g5, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g5, %g4, -12
	jne	%g5, %g0, jeq_else.43332
	fmov	%f3, %f4
	jmp	jeq_cont.43333
jeq_else.43332:
	fmul	%f5, %f1, %f0
	ldi	%g4, %g4, -36
	fldi	%f3, %g4, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g4, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g4, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.43333:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.43334
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.43335
jeq_else.43334:
	fmov	%f0, %f3
jeq_cont.43335:
	fsti	%f0, %g7, -12
jle_cont.43331:
jeq_cont.43329:
	subi	%g4, %g3, 1
	mov	%g3, %g24
	subi	%g1, %g1, 48
	call	setup_startp_constants.2783
	addi	%g1, %g1, 48
	jmp	jge_cont.43327
jge_else.43326:
jge_cont.43327:
	ldi	%g3, %g23, -472
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	ldi	%g22, %g1, 36
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43336
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
	jmp	fjge_cont.43337
fjge_else.43336:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
fjge_cont.43337:
	ldi	%g3, %g23, -464
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43338
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
	jmp	fjge_cont.43339
fjge_else.43338:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
fjge_cont.43339:
	ldi	%g3, %g23, -456
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43340
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
	jmp	fjge_cont.43341
fjge_else.43340:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
fjge_cont.43341:
	addi	%g3, %g0, 112
	mov	%g25, %g3
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2881
	addi	%g1, %g1, 48
jeq_cont.43325:
	addi	%g3, %g0, 2
	jne	%g30, %g3, jeq_else.43342
	jmp	jeq_cont.43343
jeq_else.43342:
	ldi	%g23, %g31, 708
	ldi	%g24, %g1, 40
	fldi	%f0, %g24, 0
	fsti	%f0, %g31, 636
	fldi	%f0, %g24, -4
	fsti	%f0, %g31, 632
	fldi	%f0, %g24, -8
	fsti	%f0, %g31, 628
	ldi	%g3, %g31, 28
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.43344
	slli	%g4, %g3, 2
	add	%g4, %g31, %g4
	ldi	%g4, %g4, 272
	ldi	%g7, %g4, -40
	ldi	%g6, %g4, -4
	fldi	%f1, %g24, 0
	ldi	%g5, %g4, -20
	fldi	%f0, %g5, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, 0
	fldi	%f1, %g24, -4
	fldi	%f0, %g5, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -4
	fldi	%f1, %g24, -8
	fldi	%f0, %g5, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -8
	addi	%g5, %g0, 2
	jne	%g6, %g5, jeq_else.43346
	ldi	%g4, %g4, -16
	fldi	%f1, %g7, 0
	fldi	%f3, %g7, -4
	fldi	%f2, %g7, -8
	fldi	%f0, %g4, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g4, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g7, -12
	jmp	jeq_cont.43347
jeq_else.43346:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.43348
	jmp	jle_cont.43349
jle_else.43348:
	fldi	%f2, %g7, 0
	fldi	%f1, %g7, -4
	fldi	%f0, %g7, -8
	fmul	%f4, %f2, %f2
	ldi	%g5, %g4, -16
	fldi	%f3, %g5, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g5, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g5, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g5, %g4, -12
	jne	%g5, %g0, jeq_else.43350
	fmov	%f3, %f4
	jmp	jeq_cont.43351
jeq_else.43350:
	fmul	%f5, %f1, %f0
	ldi	%g4, %g4, -36
	fldi	%f3, %g4, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g4, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g4, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.43351:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.43352
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.43353
jeq_else.43352:
	fmov	%f0, %f3
jeq_cont.43353:
	fsti	%f0, %g7, -12
jle_cont.43349:
jeq_cont.43347:
	subi	%g4, %g3, 1
	mov	%g3, %g24
	subi	%g1, %g1, 48
	call	setup_startp_constants.2783
	addi	%g1, %g1, 48
	jmp	jge_cont.43345
jge_else.43344:
jge_cont.43345:
	ldi	%g3, %g23, -472
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	ldi	%g22, %g1, 36
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43354
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
	jmp	fjge_cont.43355
fjge_else.43354:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
fjge_cont.43355:
	ldi	%g3, %g23, -464
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43356
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
	jmp	fjge_cont.43357
fjge_else.43356:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
fjge_cont.43357:
	ldi	%g3, %g23, -456
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43358
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
	jmp	fjge_cont.43359
fjge_else.43358:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
fjge_cont.43359:
	addi	%g3, %g0, 112
	mov	%g25, %g3
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2881
	addi	%g1, %g1, 48
jeq_cont.43343:
	addi	%g3, %g0, 3
	jne	%g30, %g3, jeq_else.43360
	jmp	jeq_cont.43361
jeq_else.43360:
	ldi	%g23, %g31, 704
	ldi	%g24, %g1, 40
	fldi	%f0, %g24, 0
	fsti	%f0, %g31, 636
	fldi	%f0, %g24, -4
	fsti	%f0, %g31, 632
	fldi	%f0, %g24, -8
	fsti	%f0, %g31, 628
	ldi	%g3, %g31, 28
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.43362
	slli	%g4, %g3, 2
	add	%g4, %g31, %g4
	ldi	%g4, %g4, 272
	ldi	%g7, %g4, -40
	ldi	%g6, %g4, -4
	fldi	%f1, %g24, 0
	ldi	%g5, %g4, -20
	fldi	%f0, %g5, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, 0
	fldi	%f1, %g24, -4
	fldi	%f0, %g5, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -4
	fldi	%f1, %g24, -8
	fldi	%f0, %g5, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -8
	addi	%g5, %g0, 2
	jne	%g6, %g5, jeq_else.43364
	ldi	%g4, %g4, -16
	fldi	%f1, %g7, 0
	fldi	%f3, %g7, -4
	fldi	%f2, %g7, -8
	fldi	%f0, %g4, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g4, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g7, -12
	jmp	jeq_cont.43365
jeq_else.43364:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.43366
	jmp	jle_cont.43367
jle_else.43366:
	fldi	%f2, %g7, 0
	fldi	%f1, %g7, -4
	fldi	%f0, %g7, -8
	fmul	%f4, %f2, %f2
	ldi	%g5, %g4, -16
	fldi	%f3, %g5, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g5, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g5, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g5, %g4, -12
	jne	%g5, %g0, jeq_else.43368
	fmov	%f3, %f4
	jmp	jeq_cont.43369
jeq_else.43368:
	fmul	%f5, %f1, %f0
	ldi	%g4, %g4, -36
	fldi	%f3, %g4, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g4, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g4, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.43369:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.43370
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.43371
jeq_else.43370:
	fmov	%f0, %f3
jeq_cont.43371:
	fsti	%f0, %g7, -12
jle_cont.43367:
jeq_cont.43365:
	subi	%g4, %g3, 1
	mov	%g3, %g24
	subi	%g1, %g1, 48
	call	setup_startp_constants.2783
	addi	%g1, %g1, 48
	jmp	jge_cont.43363
jge_else.43362:
jge_cont.43363:
	ldi	%g3, %g23, -472
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	ldi	%g22, %g1, 36
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43372
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
	jmp	fjge_cont.43373
fjge_else.43372:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
fjge_cont.43373:
	ldi	%g3, %g23, -464
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43374
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
	jmp	fjge_cont.43375
fjge_else.43374:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
fjge_cont.43375:
	ldi	%g3, %g23, -456
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43376
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
	jmp	fjge_cont.43377
fjge_else.43376:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
fjge_cont.43377:
	addi	%g3, %g0, 112
	mov	%g25, %g3
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2881
	addi	%g1, %g1, 48
jeq_cont.43361:
	addi	%g3, %g0, 4
	jne	%g30, %g3, jeq_else.43378
	jmp	jeq_cont.43379
jeq_else.43378:
	ldi	%g23, %g31, 700
	ldi	%g24, %g1, 40
	fldi	%f0, %g24, 0
	fsti	%f0, %g31, 636
	fldi	%f0, %g24, -4
	fsti	%f0, %g31, 632
	fldi	%f0, %g24, -8
	fsti	%f0, %g31, 628
	ldi	%g3, %g31, 28
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.43380
	slli	%g4, %g3, 2
	add	%g4, %g31, %g4
	ldi	%g4, %g4, 272
	ldi	%g7, %g4, -40
	ldi	%g6, %g4, -4
	fldi	%f1, %g24, 0
	ldi	%g5, %g4, -20
	fldi	%f0, %g5, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, 0
	fldi	%f1, %g24, -4
	fldi	%f0, %g5, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -4
	fldi	%f1, %g24, -8
	fldi	%f0, %g5, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -8
	addi	%g5, %g0, 2
	jne	%g6, %g5, jeq_else.43382
	ldi	%g4, %g4, -16
	fldi	%f1, %g7, 0
	fldi	%f3, %g7, -4
	fldi	%f2, %g7, -8
	fldi	%f0, %g4, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g4, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g7, -12
	jmp	jeq_cont.43383
jeq_else.43382:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.43384
	jmp	jle_cont.43385
jle_else.43384:
	fldi	%f2, %g7, 0
	fldi	%f1, %g7, -4
	fldi	%f0, %g7, -8
	fmul	%f4, %f2, %f2
	ldi	%g5, %g4, -16
	fldi	%f3, %g5, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g5, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g5, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g5, %g4, -12
	jne	%g5, %g0, jeq_else.43386
	fmov	%f3, %f4
	jmp	jeq_cont.43387
jeq_else.43386:
	fmul	%f5, %f1, %f0
	ldi	%g4, %g4, -36
	fldi	%f3, %g4, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g4, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g4, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.43387:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.43388
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.43389
jeq_else.43388:
	fmov	%f0, %f3
jeq_cont.43389:
	fsti	%f0, %g7, -12
jle_cont.43385:
jeq_cont.43383:
	subi	%g4, %g3, 1
	mov	%g3, %g24
	subi	%g1, %g1, 48
	call	setup_startp_constants.2783
	addi	%g1, %g1, 48
	jmp	jge_cont.43381
jge_else.43380:
jge_cont.43381:
	ldi	%g3, %g23, -472
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	ldi	%g22, %g1, 36
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43390
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
	jmp	fjge_cont.43391
fjge_else.43390:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
fjge_cont.43391:
	ldi	%g3, %g23, -464
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43392
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
	jmp	fjge_cont.43393
fjge_else.43392:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
fjge_cont.43393:
	ldi	%g3, %g23, -456
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43394
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
	jmp	fjge_cont.43395
fjge_else.43394:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 48
fjge_cont.43395:
	addi	%g30, %g0, 112
	mov	%g25, %g30
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2881
	addi	%g1, %g1, 48
jeq_cont.43379:
	slli	%g3, %g26, 2
	ldi	%g11, %g1, 32
	ld	%g3, %g11, %g3
	fldi	%f2, %g31, 592
	fldi	%f1, %g3, 0
	fldi	%f0, %g31, 580
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fsti	%f0, %g31, 592
	fldi	%f2, %g31, 588
	fldi	%f1, %g3, -4
	fldi	%f0, %g31, 576
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fsti	%f0, %g31, 588
	fldi	%f2, %g31, 584
	fldi	%f1, %g3, -8
	fldi	%f0, %g31, 572
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fsti	%f0, %g31, 584
jeq_cont.43305:
	addi	%g26, %g26, 1
	ldi	%g15, %g1, 28
	ldi	%g14, %g1, 24
	ldi	%g13, %g1, 20
	ldi	%g12, %g1, 16
	ldi	%g11, %g1, 12
	ldi	%g10, %g1, 8
	ldi	%g9, %g1, 4
	ldi	%g25, %g1, 0
	jmp	do_without_neighbors.2903
jge_else.43303:
	return
jle_else.43302:
	return

!==============================
! args = [%g4, %g10, %g9, %g5, %g8, %g26]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
try_exploit_neighbors.2919:
	slli	%g3, %g4, 2
	ld	%g6, %g5, %g3
	addi	%g3, %g0, 4
	jlt	%g3, %g26, jle_else.43398
	ldi	%g7, %g6, -8
	slli	%g3, %g26, 2
	ld	%g3, %g7, %g3
	jlt	%g3, %g0, jge_else.43399
	slli	%g7, %g4, 2
	ld	%g7, %g9, %g7
	ldi	%g12, %g7, -8
	slli	%g11, %g26, 2
	ld	%g11, %g12, %g11
	jne	%g11, %g3, jeq_else.43400
	slli	%g11, %g4, 2
	ld	%g11, %g8, %g11
	ldi	%g12, %g11, -8
	slli	%g11, %g26, 2
	ld	%g11, %g12, %g11
	jne	%g11, %g3, jeq_else.43402
	subi	%g11, %g4, 1
	slli	%g11, %g11, 2
	ld	%g11, %g5, %g11
	ldi	%g12, %g11, -8
	slli	%g11, %g26, 2
	ld	%g11, %g12, %g11
	jne	%g11, %g3, jeq_else.43404
	addi	%g11, %g4, 1
	slli	%g11, %g11, 2
	ld	%g11, %g5, %g11
	ldi	%g12, %g11, -8
	slli	%g11, %g26, 2
	ld	%g11, %g12, %g11
	jne	%g11, %g3, jeq_else.43406
	addi	%g11, %g0, 1
	jmp	jeq_cont.43407
jeq_else.43406:
	addi	%g11, %g0, 0
jeq_cont.43407:
	jmp	jeq_cont.43405
jeq_else.43404:
	addi	%g11, %g0, 0
jeq_cont.43405:
	jmp	jeq_cont.43403
jeq_else.43402:
	addi	%g11, %g0, 0
jeq_cont.43403:
	jmp	jeq_cont.43401
jeq_else.43400:
	addi	%g11, %g0, 0
jeq_cont.43401:
	jne	%g11, %g0, jeq_else.43408
	slli	%g3, %g4, 2
	ld	%g3, %g5, %g3
	ldi	%g25, %g3, -28
	ldi	%g9, %g3, -24
	ldi	%g10, %g3, -20
	ldi	%g11, %g3, -16
	ldi	%g12, %g3, -12
	ldi	%g13, %g3, -8
	ldi	%g14, %g3, -4
	ldi	%g15, %g3, 0
	jmp	do_without_neighbors.2903
jeq_else.43408:
	ldi	%g11, %g6, -12
	slli	%g3, %g26, 2
	ld	%g3, %g11, %g3
	jne	%g3, %g0, jeq_else.43409
	jmp	jeq_cont.43410
jeq_else.43409:
	ldi	%g7, %g7, -20
	subi	%g3, %g4, 1
	slli	%g3, %g3, 2
	ld	%g3, %g5, %g3
	ldi	%g11, %g3, -20
	ldi	%g6, %g6, -20
	addi	%g3, %g4, 1
	slli	%g3, %g3, 2
	ld	%g3, %g5, %g3
	ldi	%g12, %g3, -20
	slli	%g3, %g4, 2
	ld	%g3, %g8, %g3
	ldi	%g13, %g3, -20
	slli	%g3, %g26, 2
	ld	%g3, %g7, %g3
	fldi	%f0, %g3, 0
	fsti	%f0, %g31, 580
	fldi	%f0, %g3, -4
	fsti	%f0, %g31, 576
	fldi	%f0, %g3, -8
	fsti	%f0, %g31, 572
	slli	%g3, %g26, 2
	ld	%g3, %g11, %g3
	fldi	%f1, %g31, 580
	fldi	%f0, %g3, 0
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 580
	fldi	%f1, %g31, 576
	fldi	%f0, %g3, -4
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 576
	fldi	%f1, %g31, 572
	fldi	%f0, %g3, -8
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 572
	slli	%g3, %g26, 2
	ld	%g3, %g6, %g3
	fldi	%f1, %g31, 580
	fldi	%f0, %g3, 0
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 580
	fldi	%f1, %g31, 576
	fldi	%f0, %g3, -4
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 576
	fldi	%f1, %g31, 572
	fldi	%f0, %g3, -8
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 572
	slli	%g3, %g26, 2
	ld	%g3, %g12, %g3
	fldi	%f1, %g31, 580
	fldi	%f0, %g3, 0
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 580
	fldi	%f1, %g31, 576
	fldi	%f0, %g3, -4
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 576
	fldi	%f1, %g31, 572
	fldi	%f0, %g3, -8
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 572
	slli	%g3, %g26, 2
	ld	%g3, %g13, %g3
	fldi	%f1, %g31, 580
	fldi	%f0, %g3, 0
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 580
	fldi	%f1, %g31, 576
	fldi	%f0, %g3, -4
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 576
	fldi	%f1, %g31, 572
	fldi	%f0, %g3, -8
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 572
	slli	%g3, %g4, 2
	ld	%g3, %g5, %g3
	ldi	%g6, %g3, -16
	slli	%g3, %g26, 2
	ld	%g3, %g6, %g3
	fldi	%f2, %g31, 592
	fldi	%f1, %g3, 0
	fldi	%f0, %g31, 580
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fsti	%f0, %g31, 592
	fldi	%f2, %g31, 588
	fldi	%f1, %g3, -4
	fldi	%f0, %g31, 576
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fsti	%f0, %g31, 588
	fldi	%f2, %g31, 584
	fldi	%f1, %g3, -8
	fldi	%f0, %g31, 572
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fsti	%f0, %g31, 584
jeq_cont.43410:
	addi	%g26, %g26, 1
	jmp	try_exploit_neighbors.2919
jge_else.43399:
	return
jle_else.43398:
	return

!==============================
! args = [%g14, %g12, %g11, %g10, %g13, %g9, %g25, %g30, %g26]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
pretrace_diffuse_rays.2932:
	addi	%g3, %g0, 4
	jlt	%g3, %g26, jle_else.43413
	slli	%g3, %g26, 2
	ld	%g3, %g11, %g3
	jlt	%g3, %g0, jge_else.43414
	slli	%g3, %g26, 2
	ld	%g3, %g10, %g3
	sti	%g25, %g1, 0
	sti	%g13, %g1, 4
	sti	%g10, %g1, 8
	sti	%g11, %g1, 12
	sti	%g12, %g1, 16
	sti	%g14, %g1, 20
	jne	%g3, %g0, jeq_else.43415
	jmp	jeq_cont.43416
jeq_else.43415:
	ldi	%g3, %g25, 0
	fsti	%f16, %g31, 580
	fsti	%f16, %g31, 576
	fsti	%f16, %g31, 572
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g23, %g3, 716
	slli	%g3, %g26, 2
	ld	%g22, %g30, %g3
	slli	%g3, %g26, 2
	ld	%g24, %g12, %g3
	fldi	%f0, %g24, 0
	fsti	%f0, %g31, 636
	fldi	%f0, %g24, -4
	fsti	%f0, %g31, 632
	fldi	%f0, %g24, -8
	fsti	%f0, %g31, 628
	ldi	%g3, %g31, 28
	subi	%g7, %g3, 1
	jlt	%g7, %g0, jge_else.43417
	slli	%g3, %g7, 2
	add	%g3, %g31, %g3
	ldi	%g3, %g3, 272
	ldi	%g6, %g3, -40
	ldi	%g5, %g3, -4
	fldi	%f1, %g24, 0
	ldi	%g4, %g3, -20
	fldi	%f0, %g4, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g6, 0
	fldi	%f1, %g24, -4
	fldi	%f0, %g4, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g6, -4
	fldi	%f1, %g24, -8
	fldi	%f0, %g4, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g6, -8
	addi	%g4, %g0, 2
	jne	%g5, %g4, jeq_else.43419
	ldi	%g3, %g3, -16
	fldi	%f1, %g6, 0
	fldi	%f3, %g6, -4
	fldi	%f2, %g6, -8
	fldi	%f0, %g3, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g3, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g3, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g6, -12
	jmp	jeq_cont.43420
jeq_else.43419:
	addi	%g4, %g0, 2
	jlt	%g4, %g5, jle_else.43421
	jmp	jle_cont.43422
jle_else.43421:
	fldi	%f2, %g6, 0
	fldi	%f1, %g6, -4
	fldi	%f0, %g6, -8
	fmul	%f4, %f2, %f2
	ldi	%g4, %g3, -16
	fldi	%f3, %g4, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g4, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g4, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g4, %g3, -12
	jne	%g4, %g0, jeq_else.43423
	fmov	%f3, %f4
	jmp	jeq_cont.43424
jeq_else.43423:
	fmul	%f5, %f1, %f0
	ldi	%g3, %g3, -36
	fldi	%f3, %g3, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g3, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g3, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.43424:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.43425
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.43426
jeq_else.43425:
	fmov	%f0, %f3
jeq_cont.43426:
	fsti	%f0, %g6, -12
jle_cont.43422:
jeq_cont.43420:
	subi	%g4, %g7, 1
	mov	%g3, %g24
	subi	%g1, %g1, 28
	call	setup_startp_constants.2783
	addi	%g1, %g1, 28
	jmp	jge_cont.43418
jge_else.43417:
jge_cont.43418:
	ldi	%g3, %g23, -472
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	sti	%g9, %g1, 24
	fjlt	%f0, %f16, fjge_else.43427
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 32
	jmp	fjge_cont.43428
fjge_else.43427:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 32
fjge_cont.43428:
	ldi	%g3, %g23, -464
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43429
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 32
	jmp	fjge_cont.43430
fjge_else.43429:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 32
fjge_cont.43430:
	ldi	%g3, %g23, -456
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.43431
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 32
	jmp	fjge_cont.43432
fjge_else.43431:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2878
	addi	%g1, %g1, 32
fjge_cont.43432:
	addi	%g3, %g0, 112
	mov	%g25, %g3
	subi	%g1, %g1, 32
	call	iter_trace_diffuse_rays.2881
	addi	%g1, %g1, 32
	ldi	%g9, %g1, 24
	slli	%g3, %g26, 2
	ld	%g3, %g9, %g3
	fldi	%f0, %g31, 580
	fsti	%f0, %g3, 0
	fldi	%f0, %g31, 576
	fsti	%f0, %g3, -4
	fldi	%f0, %g31, 572
	fsti	%f0, %g3, -8
jeq_cont.43416:
	addi	%g26, %g26, 1
	ldi	%g14, %g1, 20
	ldi	%g12, %g1, 16
	ldi	%g11, %g1, 12
	ldi	%g10, %g1, 8
	ldi	%g13, %g1, 4
	ldi	%g25, %g1, 0
	jmp	pretrace_diffuse_rays.2932
jge_else.43414:
	return
jle_else.43413:
	return

!==============================
! args = [%g7, %g6, %g8]
! fargs = [%f13, %f12, %f11]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
pretrace_pixels.2935:
	jlt	%g6, %g0, jge_else.43435
	fldi	%f3, %g31, 612
	ldi	%g3, %g31, 608
	sub	%g3, %g6, %g3
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fmul	%f0, %f3, %f0
	fldi	%f1, %g31, 648
	fmul	%f1, %f0, %f1
	fadd	%f1, %f1, %f13
	fsti	%f1, %g31, 684
	fldi	%f1, %g31, 644
	fmul	%f1, %f0, %f1
	fadd	%f1, %f1, %f12
	fsti	%f1, %g31, 680
	fldi	%f1, %g31, 640
	fmul	%f0, %f0, %f1
	fadd	%f0, %f0, %f11
	fsti	%f0, %g31, 676
	fldi	%f2, %g31, 684
	fmul	%f1, %f2, %f2
	fldi	%f0, %g31, 680
	fmul	%f0, %f0, %f0
	fadd	%f1, %f1, %f0
	fldi	%f0, %g31, 676
	fmul	%f0, %f0, %f0
	fadd	%f0, %f1, %f0
	fsqrt	%f0, %f0
	fjeq	%f0, %f16, fjne_else.43436
	fdiv	%f1, %f17, %f0
	jmp	fjne_cont.43437
fjne_else.43436:
	setL %g3, l.35549
	fldi	%f1, %g3, 0
fjne_cont.43437:
	fmul	%f0, %f2, %f1
	fsti	%f0, %g31, 684
	fldi	%f0, %g31, 680
	fmul	%f0, %f0, %f1
	fsti	%f0, %g31, 680
	fldi	%f0, %g31, 676
	fmul	%f0, %f0, %f1
	fsti	%f0, %g31, 676
	fsti	%f16, %g31, 592
	fsti	%f16, %g31, 588
	fsti	%f16, %g31, 584
	fldi	%f0, %g31, 296
	fsti	%f0, %g31, 624
	fldi	%f0, %g31, 292
	fsti	%f0, %g31, 620
	fldi	%f0, %g31, 288
	fsti	%f0, %g31, 616
	addi	%g25, %g0, 0
	slli	%g3, %g6, 2
	ld	%g3, %g7, %g3
	ldi	%g16, %g3, -28
	ldi	%g21, %g3, -24
	ldi	%g23, %g3, -20
	ldi	%g17, %g3, -16
	ldi	%g18, %g3, -12
	ldi	%g19, %g3, -8
	ldi	%g20, %g3, -4
	ldi	%g24, %g3, 0
	subi	%g22, %g31, 684
	fsti	%f11, %g1, 0
	fsti	%f12, %g1, 4
	fsti	%f13, %g1, 8
	sti	%g8, %g1, 12
	sti	%g7, %g1, 16
	sti	%g6, %g1, 20
	fmov	%f14, %f16
	fmov	%f13, %f17
	subi	%g1, %g1, 28
	call	trace_ray.2872
	addi	%g1, %g1, 28
	ldi	%g6, %g1, 20
	slli	%g3, %g6, 2
	ldi	%g7, %g1, 16
	ld	%g3, %g7, %g3
	ldi	%g3, %g3, 0
	fldi	%f0, %g31, 592
	fsti	%f0, %g3, 0
	fldi	%f0, %g31, 588
	fsti	%f0, %g3, -4
	fldi	%f0, %g31, 584
	fsti	%f0, %g3, -8
	slli	%g3, %g6, 2
	ld	%g3, %g7, %g3
	ldi	%g3, %g3, -24
	ldi	%g8, %g1, 12
	sti	%g8, %g3, 0
	slli	%g3, %g6, 2
	ld	%g3, %g7, %g3
	addi	%g26, %g0, 0
	ldi	%g30, %g3, -28
	ldi	%g25, %g3, -24
	ldi	%g9, %g3, -20
	ldi	%g13, %g3, -16
	ldi	%g10, %g3, -12
	ldi	%g11, %g3, -8
	ldi	%g12, %g3, -4
	ldi	%g14, %g3, 0
	subi	%g1, %g1, 28
	call	pretrace_diffuse_rays.2932
	addi	%g1, %g1, 28
	ldi	%g6, %g1, 20
	subi	%g6, %g6, 1
	ldi	%g8, %g1, 12
	addi	%g3, %g8, 1
	addi	%g8, %g0, 5
	jlt	%g3, %g8, jle_else.43438
	subi	%g8, %g3, 5
	jmp	jle_cont.43439
jle_else.43438:
	mov	%g8, %g3
jle_cont.43439:
	fldi	%f13, %g1, 8
	fldi	%f12, %g1, 4
	fldi	%f11, %g1, 0
	ldi	%g7, %g1, 16
	jmp	pretrace_pixels.2935
jge_else.43435:
	return

!==============================
! args = [%g6, %g10, %g9, %g7, %g8]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
scan_pixel.2946:
	ldi	%g3, %g31, 600
	jlt	%g6, %g3, jle_else.43441
	return
jle_else.43441:
	slli	%g3, %g6, 2
	ld	%g3, %g7, %g3
	ldi	%g3, %g3, 0
	fldi	%f0, %g3, 0
	fsti	%f0, %g31, 592
	fldi	%f0, %g3, -4
	fsti	%f0, %g31, 588
	fldi	%f0, %g3, -8
	fsti	%f0, %g31, 584
	ldi	%g4, %g31, 596
	addi	%g3, %g10, 1
	jlt	%g3, %g4, jle_else.43443
	addi	%g3, %g0, 0
	jmp	jle_cont.43444
jle_else.43443:
	jlt	%g0, %g10, jle_else.43445
	addi	%g3, %g0, 0
	jmp	jle_cont.43446
jle_else.43445:
	ldi	%g4, %g31, 600
	addi	%g3, %g6, 1
	jlt	%g3, %g4, jle_else.43447
	addi	%g3, %g0, 0
	jmp	jle_cont.43448
jle_else.43447:
	jlt	%g0, %g6, jle_else.43449
	addi	%g3, %g0, 0
	jmp	jle_cont.43450
jle_else.43449:
	addi	%g3, %g0, 1
jle_cont.43450:
jle_cont.43448:
jle_cont.43446:
jle_cont.43444:
	sti	%g8, %g1, 0
	sti	%g7, %g1, 4
	sti	%g9, %g1, 8
	sti	%g10, %g1, 12
	sti	%g6, %g1, 16
	jne	%g3, %g0, jeq_else.43451
	slli	%g3, %g6, 2
	ld	%g5, %g7, %g3
	addi	%g26, %g0, 0
	ldi	%g25, %g5, -28
	ldi	%g3, %g5, -24
	ldi	%g4, %g5, -20
	ldi	%g11, %g5, -16
	ldi	%g12, %g5, -12
	ldi	%g13, %g5, -8
	ldi	%g14, %g5, -4
	ldi	%g15, %g5, 0
	mov	%g9, %g3
	mov	%g10, %g4
	subi	%g1, %g1, 24
	call	do_without_neighbors.2903
	addi	%g1, %g1, 24
	jmp	jeq_cont.43452
jeq_else.43451:
	addi	%g26, %g0, 0
	mov	%g5, %g7
	mov	%g4, %g6
	subi	%g1, %g1, 24
	call	try_exploit_neighbors.2919
	addi	%g1, %g1, 24
jeq_cont.43452:
	fldi	%f0, %g31, 592
	subi	%g1, %g1, 24
	call	min_caml_int_of_float
	addi	%g1, %g1, 24
	mov	%g4, %g3
	addi	%g3, %g0, 255
	jlt	%g3, %g4, jle_else.43453
	jlt	%g4, %g0, jge_else.43455
	mov	%g3, %g4
	jmp	jge_cont.43456
jge_else.43455:
	addi	%g3, %g0, 0
jge_cont.43456:
	jmp	jle_cont.43454
jle_else.43453:
	addi	%g3, %g0, 255
jle_cont.43454:
	output	%g3
	fldi	%f0, %g31, 588
	subi	%g1, %g1, 24
	call	min_caml_int_of_float
	addi	%g1, %g1, 24
	mov	%g4, %g3
	addi	%g3, %g0, 255
	jlt	%g3, %g4, jle_else.43457
	jlt	%g4, %g0, jge_else.43459
	mov	%g3, %g4
	jmp	jge_cont.43460
jge_else.43459:
	addi	%g3, %g0, 0
jge_cont.43460:
	jmp	jle_cont.43458
jle_else.43457:
	addi	%g3, %g0, 255
jle_cont.43458:
	output	%g3
	fldi	%f0, %g31, 584
	subi	%g1, %g1, 24
	call	min_caml_int_of_float
	addi	%g1, %g1, 24
	mov	%g4, %g3
	addi	%g3, %g0, 255
	jlt	%g3, %g4, jle_else.43461
	jlt	%g4, %g0, jge_else.43463
	mov	%g3, %g4
	jmp	jge_cont.43464
jge_else.43463:
	addi	%g3, %g0, 0
jge_cont.43464:
	jmp	jle_cont.43462
jle_else.43461:
	addi	%g3, %g0, 255
jle_cont.43462:
	output	%g3
	ldi	%g6, %g1, 16
	addi	%g6, %g6, 1
	ldi	%g10, %g1, 12
	ldi	%g9, %g1, 8
	ldi	%g7, %g1, 4
	ldi	%g8, %g1, 0
	jmp	scan_pixel.2946

!==============================
! args = [%g10, %g7, %g9, %g8, %g3]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
scan_line.2952:
	ldi	%g4, %g31, 596
	jlt	%g10, %g4, jle_else.43465
	return
jle_else.43465:
	subi	%g4, %g4, 1
	sti	%g3, %g1, 0
	sti	%g8, %g1, 4
	sti	%g9, %g1, 8
	sti	%g7, %g1, 12
	sti	%g10, %g1, 16
	jlt	%g10, %g4, jle_else.43467
	jmp	jle_cont.43468
jle_else.43467:
	addi	%g5, %g10, 1
	fldi	%f3, %g31, 612
	ldi	%g4, %g31, 604
	sub	%g6, %g5, %g4
	mov	%g3, %g6
	subi	%g1, %g1, 24
	call	min_caml_float_of_int
	addi	%g1, %g1, 24
	fmul	%f0, %f3, %f0
	fldi	%f1, %g31, 660
	fmul	%f2, %f0, %f1
	fldi	%f1, %g31, 672
	fadd	%f13, %f2, %f1
	fldi	%f1, %g31, 656
	fmul	%f2, %f0, %f1
	fldi	%f1, %g31, 668
	fadd	%f12, %f2, %f1
	fldi	%f1, %g31, 652
	fmul	%f1, %f0, %f1
	fldi	%f0, %g31, 664
	fadd	%f11, %f1, %f0
	ldi	%g4, %g31, 600
	subi	%g6, %g4, 1
	ldi	%g3, %g1, 0
	mov	%g7, %g8
	mov	%g8, %g3
	subi	%g1, %g1, 24
	call	pretrace_pixels.2935
	addi	%g1, %g1, 24
jle_cont.43468:
	addi	%g6, %g0, 0
	ldi	%g10, %g1, 16
	ldi	%g7, %g1, 12
	ldi	%g9, %g1, 8
	ldi	%g8, %g1, 4
	mov	%g27, %g7
	mov	%g7, %g9
	mov	%g9, %g27
	subi	%g1, %g1, 24
	call	scan_pixel.2946
	addi	%g1, %g1, 24
	ldi	%g10, %g1, 16
	addi	%g10, %g10, 1
	ldi	%g3, %g1, 0
	addi	%g3, %g3, 2
	addi	%g6, %g0, 5
	jlt	%g3, %g6, jle_else.43469
	subi	%g6, %g3, 5
	jmp	jle_cont.43470
jle_else.43469:
	mov	%g6, %g3
jle_cont.43470:
	ldi	%g3, %g31, 596
	jlt	%g10, %g3, jle_else.43471
	return
jle_else.43471:
	subi	%g3, %g3, 1
	sti	%g6, %g1, 20
	sti	%g10, %g1, 24
	jlt	%g10, %g3, jle_else.43473
	jmp	jle_cont.43474
jle_else.43473:
	addi	%g4, %g10, 1
	fldi	%f3, %g31, 612
	ldi	%g3, %g31, 604
	sub	%g3, %g4, %g3
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	fmul	%f0, %f3, %f0
	fldi	%f1, %g31, 660
	fmul	%f2, %f0, %f1
	fldi	%f1, %g31, 672
	fadd	%f13, %f2, %f1
	fldi	%f1, %g31, 656
	fmul	%f2, %f0, %f1
	fldi	%f1, %g31, 668
	fadd	%f12, %f2, %f1
	fldi	%f1, %g31, 652
	fmul	%f1, %f0, %f1
	fldi	%f0, %g31, 664
	fadd	%f11, %f1, %f0
	ldi	%g3, %g31, 600
	subi	%g3, %g3, 1
	ldi	%g7, %g1, 12
	mov	%g8, %g6
	mov	%g6, %g3
	subi	%g1, %g1, 32
	call	pretrace_pixels.2935
	addi	%g1, %g1, 32
jle_cont.43474:
	addi	%g3, %g0, 0
	ldi	%g10, %g1, 24
	ldi	%g9, %g1, 8
	ldi	%g8, %g1, 4
	ldi	%g7, %g1, 12
	mov	%g6, %g3
	mov	%g27, %g8
	mov	%g8, %g7
	mov	%g7, %g27
	subi	%g1, %g1, 32
	call	scan_pixel.2946
	addi	%g1, %g1, 32
	ldi	%g10, %g1, 24
	addi	%g10, %g10, 1
	ldi	%g6, %g1, 20
	addi	%g4, %g6, 2
	addi	%g3, %g0, 5
	jlt	%g4, %g3, jle_else.43475
	subi	%g3, %g4, 5
	jmp	jle_cont.43476
jle_else.43475:
	mov	%g3, %g4
jle_cont.43476:
	ldi	%g8, %g1, 4
	ldi	%g7, %g1, 12
	ldi	%g9, %g1, 8
	mov	%g27, %g8
	mov	%g8, %g9
	mov	%g9, %g7
	mov	%g7, %g27
	jmp	scan_line.2952

!==============================
! args = [%g10, %g9]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g2, %g14, %g13, %g12, %g11, %g10, %f16, %f15, %f0, %dummy]
! ret type = Array((Array(Float) * Array(Array(Float)) * Array(Int) * Array(Bool) * Array(Array(Float)) * Array(Array(Float)) * Array(Int) * Array(Array(Float))))
!================================
init_line_elements.2962:
	jlt	%g9, %g0, jge_else.43477
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	mov	%g13, %g3
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g4, %g3
	addi	%g3, %g0, 5
	call	min_caml_create_array
	mov	%g8, %g3
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g8, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g8, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g8, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g8, -16
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	call	min_caml_create_array
	mov	%g12, %g3
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	call	min_caml_create_array
	mov	%g11, %g3
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g4, %g3
	addi	%g3, %g0, 5
	call	min_caml_create_array
	mov	%g7, %g3
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g7, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g7, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g7, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g7, -16
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g4, %g3
	addi	%g3, %g0, 5
	call	min_caml_create_array
	mov	%g6, %g3
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g6, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g6, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g6, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g6, -16
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	call	min_caml_create_array
	mov	%g14, %g3
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g4, %g3
	addi	%g3, %g0, 5
	call	min_caml_create_array
	mov	%g5, %g3
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g5, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g5, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g5, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	sti	%g3, %g5, -16
	mov	%g3, %g2
	addi	%g2, %g2, 32
	sti	%g5, %g3, -28
	sti	%g14, %g3, -24
	sti	%g6, %g3, -20
	sti	%g7, %g3, -16
	sti	%g11, %g3, -12
	sti	%g12, %g3, -8
	sti	%g8, %g3, -4
	sti	%g13, %g3, 0
	slli	%g4, %g9, 2
	st	%g3, %g10, %g4
	subi	%g9, %g9, 1
	jmp	init_line_elements.2962
jge_else.43477:
	mov	%g3, %g10
	return

!==============================
! args = [%g4, %g5, %g3]
! fargs = [%f5, %f1, %f2, %f0]
! use_regs = [%g7, %g6, %g5, %g4, %g3, %g27, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f3, %f28, %f26, %f25, %f24, %f23, %f22, %f20, %f2, %f17, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
calc_dirvec.2970:
	fsti	%f0, %g1, 0
	fsti	%f2, %g1, 4
	addi	%g6, %g0, 5
	jlt	%g4, %g6, jle_else.43478
	fmul	%f2, %f5, %f5
	fmul	%f0, %f1, %f1
	fadd	%f0, %f2, %f0
	fadd	%f0, %f0, %f17
	fsqrt	%f0, %f0
	fdiv	%f2, %f5, %f0
	fdiv	%f1, %f1, %f0
	fdiv	%f0, %f17, %f0
	slli	%g4, %g5, 2
	add	%g4, %g31, %g4
	ldi	%g5, %g4, 716
	slli	%g4, %g3, 2
	ld	%g4, %g5, %g4
	ldi	%g4, %g4, 0
	fsti	%f2, %g4, 0
	fsti	%f1, %g4, -4
	fsti	%f0, %g4, -8
	addi	%g4, %g3, 40
	slli	%g4, %g4, 2
	ld	%g4, %g5, %g4
	ldi	%g4, %g4, 0
	fneg	%f4, %f1
	fsti	%f2, %g4, 0
	fsti	%f0, %g4, -4
	fsti	%f4, %g4, -8
	addi	%g4, %g3, 80
	slli	%g4, %g4, 2
	ld	%g4, %g5, %g4
	ldi	%g4, %g4, 0
	fneg	%f3, %f2
	fsti	%f0, %g4, 0
	fsti	%f3, %g4, -4
	fsti	%f4, %g4, -8
	addi	%g4, %g3, 1
	slli	%g4, %g4, 2
	ld	%g4, %g5, %g4
	ldi	%g4, %g4, 0
	fneg	%f0, %f0
	fsti	%f3, %g4, 0
	fsti	%f4, %g4, -4
	fsti	%f0, %g4, -8
	addi	%g4, %g3, 41
	slli	%g4, %g4, 2
	ld	%g4, %g5, %g4
	ldi	%g4, %g4, 0
	fsti	%f3, %g4, 0
	fsti	%f0, %g4, -4
	fsti	%f1, %g4, -8
	addi	%g3, %g3, 81
	slli	%g3, %g3, 2
	ld	%g3, %g5, %g3
	ldi	%g3, %g3, 0
	fsti	%f0, %g3, 0
	fsti	%f2, %g3, -4
	fsti	%f1, %g3, -8
	return
jle_else.43478:
	fmul	%f0, %f1, %f1
	setL %g6, l.35626
	fldi	%f6, %g6, 0
	fadd	%f0, %f0, %f6
	fsqrt	%f5, %f0
	fdiv	%f0, %f17, %f5
	fjlt	%f17, %f0, fjge_else.43480
	fjlt	%f0, %f20, fjge_else.43482
	addi	%g6, %g0, 0
	jmp	fjge_cont.43483
fjge_else.43482:
	addi	%g6, %g0, -1
fjge_cont.43483:
	jmp	fjge_cont.43481
fjge_else.43480:
	addi	%g6, %g0, 1
fjge_cont.43481:
	jne	%g6, %g0, jeq_else.43484
	fmov	%f4, %f0
	jmp	jeq_cont.43485
jeq_else.43484:
	fdiv	%f4, %f17, %f0
jeq_cont.43485:
	fmul	%f0, %f4, %f4
	setL %g7, l.37488
	fldi	%f14, %g7, 0
	fmul	%f1, %f14, %f0
	setL %g7, l.37490
	fldi	%f15, %g7, 0
	fdiv	%f3, %f1, %f15
	setL %g7, l.37492
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 8
	fldi	%f1, %g1, 8
	fmul	%f2, %f1, %f0
	setL %g7, l.37494
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 12
	fldi	%f1, %g1, 12
	fadd	%f1, %f1, %f3
	fdiv	%f1, %f2, %f1
	setL %g7, l.37496
	fldi	%f11, %g7, 0
	fmul	%f2, %f11, %f0
	setL %g7, l.37498
	fldi	%f13, %g7, 0
	fadd	%f1, %f13, %f1
	fdiv	%f2, %f2, %f1
	setL %g7, l.37500
	fldi	%f12, %g7, 0
	fmul	%f3, %f12, %f0
	setL %g7, l.37502
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 16
	fldi	%f1, %g1, 16
	fadd	%f1, %f1, %f2
	fdiv	%f1, %f3, %f1
	setL %g7, l.37504
	fldi	%f9, %g7, 0
	fmul	%f2, %f9, %f0
	fadd	%f1, %f28, %f1
	fdiv	%f2, %f2, %f1
	setL %g7, l.37507
	fldi	%f10, %g7, 0
	fmul	%f3, %f10, %f0
	setL %g7, l.37509
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 20
	fldi	%f1, %g1, 20
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g7, l.37519
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 24
	setL %g7, l.37511
	fldi	%f8, %g7, 0
	fmul	%f3, %f8, %f0
	setL %g7, l.37513
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 28
	fldi	%f1, %g1, 28
	fadd	%f1, %f1, %f2
	fdiv	%f1, %f3, %f1
	setL %g7, l.37515
	fldi	%f7, %g7, 0
	fmul	%f2, %f7, %f0
	fadd	%f1, %f25, %f1
	fdiv	%f1, %f2, %f1
	fmul	%f2, %f25, %f0
	fadd	%f1, %f26, %f1
	fdiv	%f2, %f2, %f1
	fldi	%f1, %g1, 24
	fmul	%f3, %f1, %f0
	fadd	%f1, %f24, %f2
	fdiv	%f1, %f3, %f1
	fadd	%f1, %f23, %f1
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f4, %f0
	jlt	%g0, %g6, jle_else.43486
	jlt	%g6, %g0, jge_else.43488
	fmov	%f0, %f1
	jmp	jge_cont.43489
jge_else.43488:
	fsub	%f0, %f31, %f1
jge_cont.43489:
	jmp	jle_cont.43487
jle_else.43486:
	fsub	%f0, %f22, %f1
jle_cont.43487:
	fldi	%f1, %g1, 4
	fmul	%f1, %f0, %f1
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f5, %f0, %f5
	addi	%g4, %g4, 1
	fmul	%f0, %f5, %f5
	fadd	%f0, %f0, %f6
	fsqrt	%f6, %f0
	fdiv	%f0, %f17, %f6
	fjlt	%f17, %f0, fjge_else.43490
	fjlt	%f0, %f20, fjge_else.43492
	addi	%g6, %g0, 0
	jmp	fjge_cont.43493
fjge_else.43492:
	addi	%g6, %g0, -1
fjge_cont.43493:
	jmp	fjge_cont.43491
fjge_else.43490:
	addi	%g6, %g0, 1
fjge_cont.43491:
	jne	%g6, %g0, jeq_else.43494
	fmov	%f1, %f0
	jmp	jeq_cont.43495
jeq_else.43494:
	fdiv	%f1, %f17, %f0
jeq_cont.43495:
	fmul	%f0, %f1, %f1
	fmul	%f2, %f14, %f0
	fdiv	%f3, %f2, %f15
	fldi	%f2, %g1, 8
	fmul	%f4, %f2, %f0
	fldi	%f2, %g1, 12
	fadd	%f2, %f2, %f3
	fdiv	%f2, %f4, %f2
	fmul	%f3, %f11, %f0
	fadd	%f2, %f13, %f2
	fdiv	%f3, %f3, %f2
	fmul	%f4, %f12, %f0
	fldi	%f2, %g1, 16
	fadd	%f2, %f2, %f3
	fdiv	%f2, %f4, %f2
	fmul	%f3, %f9, %f0
	fadd	%f2, %f28, %f2
	fdiv	%f2, %f3, %f2
	fmul	%f3, %f10, %f0
	fldi	%f4, %g1, 20
	fadd	%f2, %f4, %f2
	fdiv	%f2, %f3, %f2
	fmul	%f4, %f8, %f0
	fldi	%f3, %g1, 28
	fadd	%f2, %f3, %f2
	fdiv	%f2, %f4, %f2
	fmul	%f3, %f7, %f0
	fadd	%f2, %f25, %f2
	fdiv	%f2, %f3, %f2
	fmul	%f3, %f25, %f0
	fadd	%f2, %f26, %f2
	fdiv	%f2, %f3, %f2
	fldi	%f3, %g1, 24
	fmul	%f3, %f3, %f0
	fadd	%f2, %f24, %f2
	fdiv	%f2, %f3, %f2
	fadd	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f1, %f0
	jlt	%g0, %g6, jle_else.43496
	jlt	%g6, %g0, jge_else.43498
	fmov	%f0, %f1
	jmp	jge_cont.43499
jge_else.43498:
	fsub	%f0, %f31, %f1
jge_cont.43499:
	jmp	jle_cont.43497
jle_else.43496:
	fsub	%f0, %f22, %f1
jle_cont.43497:
	fldi	%f1, %g1, 0
	fmul	%f0, %f0, %f1
	fmul	%f2, %f0, %f0
	fdiv	%f1, %f2, %f25
	fsub	%f1, %f26, %f1
	fdiv	%f1, %f2, %f1
	fsub	%f1, %f24, %f1
	fdiv	%f1, %f2, %f1
	fsub	%f1, %f23, %f1
	fdiv	%f1, %f2, %f1
	fsub	%f1, %f17, %f1
	fdiv	%f0, %f0, %f1
	fmul	%f1, %f0, %f6
	fldi	%f2, %g1, 4
	fldi	%f0, %g1, 0
	jmp	calc_dirvec.2970

!==============================
! args = [%g10, %g9, %g8]
! fargs = [%f0]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f3, %f28, %f26, %f25, %f24, %f23, %f22, %f20, %f2, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
calc_dirvecs.2978:
	jlt	%g10, %g0, jge_else.43500
	fsti	%f0, %g1, 0
	mov	%g3, %g10
	subi	%g1, %g1, 8
	call	min_caml_float_of_int
	addi	%g1, %g1, 8
	fmov	%f1, %f0
	setL %g3, l.35622
	fldi	%f5, %g3, 0
	fmul	%f1, %f1, %f5
	setL %g3, l.35624
	fldi	%f4, %g3, 0
	fsub	%f2, %f1, %f4
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f4, %g1, 4
	fsti	%f5, %g1, 8
	fsti	%f1, %g1, 12
	mov	%g3, %g8
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 20
	call	calc_dirvec.2970
	addi	%g1, %g1, 20
	setL %g3, l.35626
	fldi	%f3, %g3, 0
	fldi	%f1, %g1, 12
	fadd	%f2, %f1, %f3
	addi	%g4, %g0, 0
	addi	%g11, %g8, 2
	fldi	%f0, %g1, 0
	fsti	%f3, %g1, 16
	mov	%g3, %g11
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 24
	call	calc_dirvec.2970
	addi	%g1, %g1, 24
	subi	%g10, %g10, 1
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.43501
	subi	%g9, %g3, 5
	jmp	jle_cont.43502
jle_else.43501:
	mov	%g9, %g3
jle_cont.43502:
	jlt	%g10, %g0, jge_else.43503
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	min_caml_float_of_int
	addi	%g1, %g1, 24
	fmov	%f1, %f0
	fldi	%f5, %g1, 8
	fmul	%f1, %f1, %f5
	fldi	%f4, %g1, 4
	fsub	%f2, %f1, %f4
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f1, %g1, 20
	mov	%g3, %g8
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 28
	call	calc_dirvec.2970
	addi	%g1, %g1, 28
	fldi	%f3, %g1, 16
	fldi	%f1, %g1, 20
	fadd	%f2, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	mov	%g3, %g11
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 28
	call	calc_dirvec.2970
	addi	%g1, %g1, 28
	subi	%g10, %g10, 1
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.43504
	subi	%g9, %g3, 5
	jmp	jle_cont.43505
jle_else.43504:
	mov	%g9, %g3
jle_cont.43505:
	jlt	%g10, %g0, jge_else.43506
	mov	%g3, %g10
	subi	%g1, %g1, 28
	call	min_caml_float_of_int
	addi	%g1, %g1, 28
	fmov	%f1, %f0
	fldi	%f5, %g1, 8
	fmul	%f1, %f1, %f5
	fldi	%f4, %g1, 4
	fsub	%f2, %f1, %f4
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f1, %g1, 24
	mov	%g3, %g8
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 32
	call	calc_dirvec.2970
	addi	%g1, %g1, 32
	fldi	%f3, %g1, 16
	fldi	%f1, %g1, 24
	fadd	%f2, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	mov	%g3, %g11
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 32
	call	calc_dirvec.2970
	addi	%g1, %g1, 32
	subi	%g10, %g10, 1
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.43507
	subi	%g9, %g3, 5
	jmp	jle_cont.43508
jle_else.43507:
	mov	%g9, %g3
jle_cont.43508:
	jlt	%g10, %g0, jge_else.43509
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	fmov	%f1, %f0
	fldi	%f5, %g1, 8
	fmul	%f1, %f1, %f5
	fldi	%f4, %g1, 4
	fsub	%f2, %f1, %f4
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f1, %g1, 28
	mov	%g3, %g8
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 36
	call	calc_dirvec.2970
	addi	%g1, %g1, 36
	fldi	%f3, %g1, 16
	fldi	%f1, %g1, 28
	fadd	%f2, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	mov	%g3, %g11
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 36
	call	calc_dirvec.2970
	addi	%g1, %g1, 36
	subi	%g10, %g10, 1
	addi	%g4, %g9, 1
	addi	%g3, %g0, 5
	jlt	%g4, %g3, jle_else.43510
	subi	%g3, %g4, 5
	jmp	jle_cont.43511
jle_else.43510:
	mov	%g3, %g4
jle_cont.43511:
	fldi	%f0, %g1, 0
	mov	%g9, %g3
	jmp	calc_dirvecs.2978
jge_else.43509:
	return
jge_else.43506:
	return
jge_else.43503:
	return
jge_else.43500:
	return

!==============================
! args = [%g13, %g12, %g8]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f3, %f28, %f26, %f25, %f24, %f23, %f22, %f20, %f2, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
calc_dirvec_rows.2983:
	jlt	%g13, %g0, jge_else.43516
	mov	%g3, %g13
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	setL %g3, l.35622
	fldi	%f4, %g3, 0
	fmul	%f0, %f0, %f4
	setL %g3, l.35624
	fldi	%f3, %g3, 0
	fsub	%f0, %f0, %f3
	addi	%g3, %g0, 4
	fsti	%f0, %g1, 0
	subi	%g1, %g1, 8
	call	min_caml_float_of_int
	addi	%g1, %g1, 8
	fmov	%f1, %f0
	fmul	%f1, %f1, %f4
	fsub	%f10, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f10, %g1, 4
	fsti	%f3, %g1, 8
	fsti	%f4, %g1, 12
	fsti	%f1, %g1, 16
	mov	%g3, %g8
	mov	%g5, %g12
	fmov	%f2, %f10
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 24
	call	calc_dirvec.2970
	addi	%g1, %g1, 24
	setL %g3, l.35626
	fldi	%f5, %g3, 0
	fldi	%f1, %g1, 16
	fadd	%f9, %f1, %f5
	addi	%g4, %g0, 0
	addi	%g10, %g8, 2
	fldi	%f0, %g1, 0
	fsti	%f9, %g1, 20
	fsti	%f5, %g1, 24
	mov	%g3, %g10
	mov	%g5, %g12
	fmov	%f2, %f9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 32
	call	calc_dirvec.2970
	addi	%g1, %g1, 32
	addi	%g6, %g0, 3
	addi	%g3, %g12, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.43517
	subi	%g9, %g3, 5
	jmp	jle_cont.43518
jle_else.43517:
	mov	%g9, %g3
jle_cont.43518:
	mov	%g3, %g6
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	fmov	%f1, %f0
	fldi	%f4, %g1, 12
	fmul	%f1, %f1, %f4
	fldi	%f3, %g1, 8
	fsub	%f8, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f8, %g1, 28
	fsti	%f1, %g1, 32
	mov	%g3, %g8
	mov	%g5, %g9
	fmov	%f2, %f8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 40
	call	calc_dirvec.2970
	addi	%g1, %g1, 40
	fldi	%f5, %g1, 24
	fldi	%f1, %g1, 32
	fadd	%f7, %f1, %f5
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f7, %g1, 36
	mov	%g3, %g10
	mov	%g5, %g9
	fmov	%f2, %f7
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 44
	call	calc_dirvec.2970
	addi	%g1, %g1, 44
	addi	%g6, %g0, 2
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.43519
	subi	%g9, %g3, 5
	jmp	jle_cont.43520
jle_else.43519:
	mov	%g9, %g3
jle_cont.43520:
	mov	%g3, %g6
	subi	%g1, %g1, 44
	call	min_caml_float_of_int
	addi	%g1, %g1, 44
	fmov	%f1, %f0
	fldi	%f4, %g1, 12
	fmul	%f1, %f1, %f4
	fldi	%f3, %g1, 8
	fsub	%f6, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f6, %g1, 40
	fsti	%f1, %g1, 44
	mov	%g3, %g8
	mov	%g5, %g9
	fmov	%f2, %f6
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 52
	call	calc_dirvec.2970
	addi	%g1, %g1, 52
	fldi	%f5, %g1, 24
	fldi	%f1, %g1, 44
	fadd	%f2, %f1, %f5
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f2, %g1, 48
	mov	%g3, %g10
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 56
	call	calc_dirvec.2970
	addi	%g1, %g1, 56
	addi	%g6, %g0, 1
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.43521
	subi	%g9, %g3, 5
	jmp	jle_cont.43522
jle_else.43521:
	mov	%g9, %g3
jle_cont.43522:
	mov	%g3, %g6
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
	fmov	%f1, %f0
	fldi	%f4, %g1, 12
	fmul	%f11, %f1, %f4
	fldi	%f3, %g1, 8
	fsub	%f1, %f11, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f11, %g1, 52
	mov	%g3, %g8
	mov	%g5, %g9
	fmov	%f2, %f1
	fmov	%f5, %f16
	fmov	%f1, %f16
	subi	%g1, %g1, 60
	call	calc_dirvec.2970
	addi	%g1, %g1, 60
	fldi	%f5, %g1, 24
	fldi	%f11, %g1, 52
	fadd	%f1, %f11, %f5
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	mov	%g3, %g10
	mov	%g5, %g9
	fmov	%f2, %f1
	fmov	%f5, %f16
	fmov	%f1, %f16
	subi	%g1, %g1, 60
	call	calc_dirvec.2970
	addi	%g1, %g1, 60
	addi	%g10, %g0, 0
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.43523
	subi	%g9, %g3, 5
	jmp	jle_cont.43524
jle_else.43523:
	mov	%g9, %g3
jle_cont.43524:
	fldi	%f0, %g1, 0
	sti	%g8, %g1, 56
	subi	%g1, %g1, 64
	call	calc_dirvecs.2978
	addi	%g1, %g1, 64
	subi	%g14, %g13, 1
	addi	%g3, %g12, 2
	addi	%g12, %g0, 5
	jlt	%g3, %g12, jle_else.43525
	subi	%g12, %g3, 5
	jmp	jle_cont.43526
jle_else.43525:
	mov	%g12, %g3
jle_cont.43526:
	ldi	%g8, %g1, 56
	addi	%g13, %g8, 4
	jlt	%g14, %g0, jge_else.43527
	mov	%g3, %g14
	subi	%g1, %g1, 64
	call	min_caml_float_of_int
	addi	%g1, %g1, 64
	fldi	%f4, %g1, 12
	fmul	%f0, %f0, %f4
	fldi	%f3, %g1, 8
	fsub	%f0, %f0, %f3
	addi	%g4, %g0, 0
	fldi	%f10, %g1, 4
	fsti	%f0, %g1, 60
	mov	%g3, %g13
	mov	%g5, %g12
	fmov	%f2, %f10
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 68
	call	calc_dirvec.2970
	addi	%g1, %g1, 68
	addi	%g4, %g0, 0
	addi	%g8, %g13, 2
	fldi	%f9, %g1, 20
	fldi	%f0, %g1, 60
	mov	%g3, %g8
	mov	%g5, %g12
	fmov	%f2, %f9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 68
	call	calc_dirvec.2970
	addi	%g1, %g1, 68
	addi	%g3, %g12, 1
	addi	%g5, %g0, 5
	jlt	%g3, %g5, jle_else.43528
	subi	%g5, %g3, 5
	jmp	jle_cont.43529
jle_else.43528:
	mov	%g5, %g3
jle_cont.43529:
	addi	%g4, %g0, 0
	fldi	%f8, %g1, 28
	fldi	%f0, %g1, 60
	sti	%g5, %g1, 64
	mov	%g3, %g13
	fmov	%f2, %f8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 72
	call	calc_dirvec.2970
	addi	%g1, %g1, 72
	addi	%g4, %g0, 0
	fldi	%f7, %g1, 36
	fldi	%f0, %g1, 60
	ldi	%g5, %g1, 64
	mov	%g3, %g8
	fmov	%f2, %f7
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 72
	call	calc_dirvec.2970
	addi	%g1, %g1, 72
	ldi	%g5, %g1, 64
	addi	%g3, %g5, 1
	addi	%g5, %g0, 5
	jlt	%g3, %g5, jle_else.43530
	subi	%g5, %g3, 5
	jmp	jle_cont.43531
jle_else.43530:
	mov	%g5, %g3
jle_cont.43531:
	addi	%g4, %g0, 0
	fldi	%f6, %g1, 40
	fldi	%f0, %g1, 60
	sti	%g5, %g1, 68
	mov	%g3, %g13
	fmov	%f2, %f6
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 76
	call	calc_dirvec.2970
	addi	%g1, %g1, 76
	addi	%g4, %g0, 0
	fldi	%f2, %g1, 48
	fldi	%f0, %g1, 60
	ldi	%g5, %g1, 68
	mov	%g3, %g8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 76
	call	calc_dirvec.2970
	addi	%g1, %g1, 76
	addi	%g10, %g0, 1
	ldi	%g5, %g1, 68
	addi	%g3, %g5, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.43532
	subi	%g9, %g3, 5
	jmp	jle_cont.43533
jle_else.43532:
	mov	%g9, %g3
jle_cont.43533:
	fldi	%f0, %g1, 60
	mov	%g8, %g13
	subi	%g1, %g1, 76
	call	calc_dirvecs.2978
	addi	%g1, %g1, 76
	subi	%g4, %g14, 1
	addi	%g3, %g12, 2
	addi	%g12, %g0, 5
	jlt	%g3, %g12, jle_else.43534
	subi	%g12, %g3, 5
	jmp	jle_cont.43535
jle_else.43534:
	mov	%g12, %g3
jle_cont.43535:
	addi	%g8, %g13, 4
	mov	%g13, %g4
	jmp	calc_dirvec_rows.2983
jge_else.43527:
	return
jge_else.43516:
	return

!==============================
! args = [%g6, %g7]
! fargs = []
! use_regs = [%g7, %g6, %g5, %g4, %g3, %g27, %g2, %f16, %f15, %f0, %dummy]
! ret type = Unit
!================================
create_dirvec_elements.2989:
	jlt	%g7, %g0, jge_else.43538
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 0
	sti	%g4, %g3, 0
	slli	%g4, %g7, 2
	st	%g3, %g6, %g4
	subi	%g7, %g7, 1
	jlt	%g7, %g0, jge_else.43539
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 4
	subi	%g1, %g1, 12
	call	min_caml_create_array
	addi	%g1, %g1, 12
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 4
	sti	%g4, %g3, 0
	slli	%g4, %g7, 2
	st	%g3, %g6, %g4
	subi	%g7, %g7, 1
	jlt	%g7, %g0, jge_else.43540
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 12
	call	min_caml_create_float_array
	addi	%g1, %g1, 12
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 8
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 8
	sti	%g4, %g3, 0
	slli	%g4, %g7, 2
	st	%g3, %g6, %g4
	subi	%g7, %g7, 1
	jlt	%g7, %g0, jge_else.43541
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 12
	subi	%g1, %g1, 20
	call	min_caml_create_array
	addi	%g1, %g1, 20
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 12
	sti	%g4, %g3, 0
	slli	%g4, %g7, 2
	st	%g3, %g6, %g4
	subi	%g7, %g7, 1
	jmp	create_dirvec_elements.2989
jge_else.43541:
	return
jge_else.43540:
	return
jge_else.43539:
	return
jge_else.43538:
	return

!==============================
! args = [%g8]
! fargs = []
! use_regs = [%g8, %g7, %g6, %g5, %g4, %g3, %g27, %g2, %f16, %f15, %f0, %dummy]
! ret type = Unit
!================================
create_dirvecs.2992:
	jlt	%g8, %g0, jge_else.43546
	addi	%g6, %g0, 120
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 0
	sti	%g4, %g3, 0
	mov	%g4, %g3
	mov	%g3, %g6
	subi	%g1, %g1, 8
	call	min_caml_create_array
	slli	%g4, %g8, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 716
	slli	%g3, %g8, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 716
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 4
	subi	%g1, %g1, 12
	call	min_caml_create_array
	addi	%g1, %g1, 12
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 4
	sti	%g4, %g3, 0
	sti	%g3, %g6, -472
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 12
	call	min_caml_create_float_array
	addi	%g1, %g1, 12
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 8
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 8
	sti	%g4, %g3, 0
	sti	%g3, %g6, -468
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 12
	subi	%g1, %g1, 20
	call	min_caml_create_array
	addi	%g1, %g1, 20
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 12
	sti	%g4, %g3, 0
	sti	%g3, %g6, -464
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 20
	call	min_caml_create_float_array
	addi	%g1, %g1, 20
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 16
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 16
	sti	%g4, %g3, 0
	sti	%g3, %g6, -460
	addi	%g7, %g0, 114
	subi	%g1, %g1, 24
	call	create_dirvec_elements.2989
	addi	%g1, %g1, 24
	subi	%g8, %g8, 1
	jlt	%g8, %g0, jge_else.43547
	addi	%g6, %g0, 120
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 24
	call	min_caml_create_float_array
	addi	%g1, %g1, 24
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 20
	subi	%g1, %g1, 28
	call	min_caml_create_array
	addi	%g1, %g1, 28
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 20
	sti	%g4, %g3, 0
	mov	%g4, %g3
	mov	%g3, %g6
	subi	%g1, %g1, 28
	call	min_caml_create_array
	slli	%g4, %g8, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 716
	slli	%g3, %g8, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 716
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	addi	%g1, %g1, 28
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 24
	subi	%g1, %g1, 32
	call	min_caml_create_array
	addi	%g1, %g1, 32
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 24
	sti	%g4, %g3, 0
	sti	%g3, %g6, -472
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 32
	call	min_caml_create_float_array
	addi	%g1, %g1, 32
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 28
	subi	%g1, %g1, 36
	call	min_caml_create_array
	addi	%g1, %g1, 36
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 28
	sti	%g4, %g3, 0
	sti	%g3, %g6, -468
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 36
	call	min_caml_create_float_array
	addi	%g1, %g1, 36
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 32
	subi	%g1, %g1, 40
	call	min_caml_create_array
	addi	%g1, %g1, 40
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 32
	sti	%g4, %g3, 0
	sti	%g3, %g6, -464
	addi	%g7, %g0, 115
	subi	%g1, %g1, 40
	call	create_dirvec_elements.2989
	addi	%g1, %g1, 40
	subi	%g8, %g8, 1
	jmp	create_dirvecs.2992
jge_else.43547:
	return
jge_else.43546:
	return

!==============================
! args = [%g11, %g12]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g12, %g11, %g10, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f20, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
init_dirvec_constants.2994:
	jlt	%g12, %g0, jge_else.43550
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2778
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.43551
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2778
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.43552
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2778
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.43553
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2778
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.43554
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2778
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.43555
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2778
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.43556
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2778
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.43557
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2778
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jmp	init_dirvec_constants.2994
jge_else.43557:
	return
jge_else.43556:
	return
jge_else.43555:
	return
jge_else.43554:
	return
jge_else.43553:
	return
jge_else.43552:
	return
jge_else.43551:
	return
jge_else.43550:
	return

!==============================
! args = [%g13]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g13, %g12, %g11, %g10, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f20, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
init_vecset_constants.2997:
	jlt	%g13, %g0, jge_else.43566
	slli	%g3, %g13, 2
	add	%g3, %g31, %g3
	ldi	%g11, %g3, 716
	ldi	%g3, %g11, -476
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -472
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -468
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -464
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -460
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -456
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -452
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -448
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	addi	%g12, %g0, 111
	call	init_dirvec_constants.2994
	addi	%g1, %g1, 4
	subi	%g13, %g13, 1
	jlt	%g13, %g0, jge_else.43567
	slli	%g3, %g13, 2
	add	%g3, %g31, %g3
	ldi	%g11, %g3, 716
	ldi	%g3, %g11, -476
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -472
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -468
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -464
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -460
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -456
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	ldi	%g3, %g11, -452
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2778
	addi	%g12, %g0, 112
	call	init_dirvec_constants.2994
	addi	%g1, %g1, 4
	subi	%g13, %g13, 1
	jmp	init_vecset_constants.2997
jge_else.43567:
	return
jge_else.43566:
	return
