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
l.45841:	! 150.000000
	.long	0x43160000
l.45837:	! -150.000000
	.long	0xc3160000
l.45389:	! -2.000000
	.long	0xc0000000
l.45367:	! 0.003906
	.long	0x3b800000
l.45323:	! 20.000000
	.long	0x41a00000
l.45321:	! 0.050000
	.long	0x3d4cccc4
l.45301:	! 0.250000
	.long	0x3e800000
l.45282:	! 10.000000
	.long	0x41200000
l.45271:	! 0.300000
	.long	0x3e999999
l.45267:	! 0.150000
	.long	0x3e199999
l.45232:	! 3.141593
	.long	0x40490fda
l.45230:	! 30.000000
	.long	0x41f00000
l.45228:	! -1.570796
	.long	0xbfc90fda
l.45223:	! 4.000000
	.long	0x40800000
l.45219:	! 16.000000
	.long	0x41800000
l.45217:	! 11.000000
	.long	0x41300000
l.45215:	! 25.000000
	.long	0x41c80000
l.45213:	! 13.000000
	.long	0x41500000
l.45211:	! 36.000000
	.long	0x42100000
l.45208:	! 49.000000
	.long	0x42440000
l.45206:	! 17.000000
	.long	0x41880000
l.45204:	! 64.000000
	.long	0x42800000
l.45202:	! 19.000000
	.long	0x41980000
l.45200:	! 81.000000
	.long	0x42a20000
l.45198:	! 21.000000
	.long	0x41a80000
l.45196:	! 100.000000
	.long	0x42c80000
l.45194:	! 23.000000
	.long	0x41b80000
l.45192:	! 121.000000
	.long	0x42f20000
l.45188:	! 15.000000
	.long	0x41700000
l.45186:	! 0.000100
	.long	0x38d1b70f
l.45016:	! 100000000.000000
	.long	0x4cbebc20
l.44281:	! -0.100000
	.long	0xbdccccc4
l.44095:	! 0.010000
	.long	0x3c23d70a
l.44093:	! -0.200000
	.long	0xbe4cccc4
l.43536:	! -1.000000
	.long	0xbf800000
l.42726:	! 0.100000
	.long	0x3dccccc4
l.42724:	! 0.900000
	.long	0x3f66665e
l.42722:	! 0.200000
	.long	0x3e4cccc4
l.42548:	! -200.000000
	.long	0xc3480000
l.42545:	! 200.000000
	.long	0x43480000
l.42517:	! 3.000000
	.long	0x40400000
l.42515:	! 5.000000
	.long	0x40a00000
l.42513:	! 9.000000
	.long	0x41100000
l.42511:	! 7.000000
	.long	0x40e00000
l.42509:	! 1.000000
	.long	0x3f800000
l.42507:	! 0.017453
	.long	0x3c8efa2d
l.42298:	! 128.000000
	.long	0x43000000
l.42275:	! 1000000000.000000
	.long	0x4e6e6b28
l.42271:	! 255.000000
	.long	0x437f0000
l.42257:	! 0.000000
	.long	0x0
l.42255:	! 1.570796
	.long	0x3fc90fda
l.42253:	! 0.500000
	.long	0x3f000000
l.42251:	! 6.283185
	.long	0x40c90fda
l.42249:	! 2.000000
	.long	0x40000000
l.42247:	! 3.141593
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
	subi	%g1, %g1, 2376
	addi	%g28, %g0, 1
	addi	%g29, %g0, -1
	setL %g27, l.42257
	fldi	%f16, %g27, 0
	setL %g27, l.42509
	fldi	%f17, %g27, 0
	setL %g27, l.45841
	fldi	%f18, %g27, 0
	setL %g27, l.45837
	fldi	%f19, %g27, 0
	setL %g27, l.43536
	fldi	%f20, %g27, 0
	setL %g27, l.42253
	fldi	%f21, %g27, 0
	setL %g27, l.42255
	fldi	%f22, %g27, 0
	setL %g27, l.42517
	fldi	%f23, %g27, 0
	setL %g27, l.42515
	fldi	%f24, %g27, 0
	setL %g27, l.42513
	fldi	%f25, %g27, 0
	setL %g27, l.42511
	fldi	%f26, %g27, 0
	setL %g27, l.42271
	fldi	%f27, %g27, 0
	setL %g27, l.45188
	fldi	%f28, %g27, 0
	setL %g27, l.42251
	fldi	%f29, %g27, 0
	setL %g27, l.45232
	fldi	%f30, %g27, 0
	setL %g27, l.45228
	fldi	%f31, %g27, 0
	setL %g3, l.42247
	fldi	%f5, %g3, 0
	setL %g3, l.42249
	fldi	%f10, %g3, 0
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 4
	subi	%g1, %g1, 4
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 8
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 12
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 16
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 1
	addi	%g4, %g0, 1
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 20
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 24
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 28
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 32
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g4, %g3
	ldi	%g2, %g31, 2372
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
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 272
	mov	%g4, %g3
	mov	%g3, %g6
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 284
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 296
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 308
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 1
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 312
	fmov	%f0, %f27
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g6, %g0, 50
	addi	%g3, %g0, 1
	addi	%g4, %g0, -1
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 512
	mov	%g3, %g6
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g6, %g0, 1
	addi	%g3, %g0, 1
	ldi	%g4, %g31, 512
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 516
	mov	%g3, %g6
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 1
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 520
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 524
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 1
	setL %g4, l.42275
	fldi	%f0, %g4, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 528
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 540
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 544
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 556
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 568
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 580
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 592
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 2
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 600
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 2
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 608
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 1
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 612
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 624
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 636
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 648
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 660
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 672
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 684
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 688
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 692
	subi	%g4, %g31, 688
	call	min_caml_create_array
	mov	%g4, %g3
	ldi	%g2, %g31, 2372
	addi	%g6, %g0, 0
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g4, %g3, -4
	sti	%g7, %g3, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 696
	mov	%g4, %g3
	mov	%g3, %g6
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 716
	subi	%g4, %g31, 696
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 720
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 732
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g6, %g3
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 60
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 972
	subi	%g4, %g31, 720
	call	min_caml_create_array
	mov	%g4, %g3
	ldi	%g2, %g31, 2372
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 980
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g4, %g3, -4
	sti	%g6, %g3, 0
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 984
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g6, %g3
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 988
	subi	%g4, %g31, 984
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 996
	mov	%g4, %g2
	addi	%g2, %g2, 8
	sti	%g3, %g4, -4
	sti	%g6, %g4, 0
	ldi	%g2, %g31, 2372
	addi	%g6, %g0, 180
	addi	%g5, %g0, 0
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fsti	%f16, %g3, -8
	sti	%g4, %g3, -4
	sti	%g5, %g3, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1716
	mov	%g4, %g3
	mov	%g3, %g6
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1720
	call	min_caml_create_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 128
	addi	%g4, %g0, 128
	sti	%g3, %g31, 600
	sti	%g4, %g31, 596
	addi	%g4, %g0, 64
	sti	%g4, %g31, 608
	addi	%g4, %g0, 64
	sti	%g4, %g31, 604
	setL %g4, l.42298
	fldi	%f3, %g4, 0
	call	min_caml_float_of_int
	fdiv	%f0, %f3, %f0
	fsti	%f0, %g31, 612
	ldi	%g12, %g31, 600
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1732
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g11, %g3
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1744
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1764
	subi	%g4, %g31, 1744
	call	min_caml_create_array
	mov	%g10, %g3
	ldi	%g2, %g31, 2372
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
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1784
	call	min_caml_create_array
	mov	%g9, %g3
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1804
	call	min_caml_create_array
	mov	%g8, %g3
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1816
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1836
	subi	%g4, %g31, 1816
	call	min_caml_create_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2372
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
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1848
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1868
	subi	%g4, %g31, 1848
	call	min_caml_create_array
	mov	%g6, %g3
	ldi	%g2, %g31, 2372
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
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1872
	call	min_caml_create_array
	mov	%g13, %g3
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1884
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1904
	subi	%g4, %g31, 1884
	call	min_caml_create_array
	mov	%g5, %g3
	ldi	%g2, %g31, 2372
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
	call	init_line_elements.2985
	mov	%g18, %g3
	sti	%g18, %g31, 1912
	ldi	%g12, %g31, 600
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1924
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g11, %g3
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1936
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1956
	subi	%g4, %g31, 1936
	call	min_caml_create_array
	mov	%g10, %g3
	ldi	%g2, %g31, 2372
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
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1976
	call	min_caml_create_array
	mov	%g9, %g3
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 1996
	call	min_caml_create_array
	mov	%g8, %g3
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2008
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2028
	subi	%g4, %g31, 2008
	call	min_caml_create_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2372
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
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2040
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2060
	subi	%g4, %g31, 2040
	call	min_caml_create_array
	mov	%g6, %g3
	ldi	%g2, %g31, 2372
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
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2064
	call	min_caml_create_array
	mov	%g13, %g3
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2076
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2096
	subi	%g4, %g31, 2076
	call	min_caml_create_array
	mov	%g5, %g3
	ldi	%g2, %g31, 2372
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
	call	init_line_elements.2985
	mov	%g16, %g3
	sti	%g16, %g31, 2104
	ldi	%g12, %g31, 600
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2116
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g11, %g3
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2128
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2148
	subi	%g4, %g31, 2128
	call	min_caml_create_array
	mov	%g10, %g3
	ldi	%g2, %g31, 2372
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
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2168
	call	min_caml_create_array
	mov	%g9, %g3
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2188
	call	min_caml_create_array
	mov	%g8, %g3
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2200
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2220
	subi	%g4, %g31, 2200
	call	min_caml_create_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2372
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
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2232
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2252
	subi	%g4, %g31, 2232
	call	min_caml_create_array
	mov	%g6, %g3
	ldi	%g2, %g31, 2372
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
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2256
	call	min_caml_create_array
	mov	%g13, %g3
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2268
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2372
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2288
	subi	%g4, %g31, 2268
	call	min_caml_create_array
	mov	%g5, %g3
	ldi	%g2, %g31, 2372
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
	call	init_line_elements.2985
	addi	%g1, %g1, 4
	mov	%g17, %g3
	sti	%g17, %g31, 2296
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.49182
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.49184
	addi	%g3, %g0, 0
	jmp	jle_cont.49185
jle_else.49184:
	addi	%g3, %g0, 1
jle_cont.49185:
	jmp	jle_cont.49183
jle_else.49182:
	addi	%g3, %g0, 1
jle_cont.49183:
	jne	%g3, %g0, jeq_else.49186
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.49188
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.49189
jeq_else.49188:
jeq_cont.49189:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.49187
jeq_else.49186:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.49187:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.49190
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.49192
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.49194
	addi	%g4, %g0, 0
	jmp	jle_cont.49195
jle_else.49194:
	addi	%g4, %g0, 1
jle_cont.49195:
	jmp	jle_cont.49193
jle_else.49192:
	addi	%g4, %g0, 1
jle_cont.49193:
	jne	%g4, %g0, jeq_else.49196
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.49197
jeq_else.49196:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.49197:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f4, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f4, %f0
	jmp	jeq_cont.49191
jeq_else.49190:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.49191:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.49198
	fmov	%f1, %f0
	jmp	jeq_cont.49199
jeq_else.49198:
	fneg	%f1, %f0
jeq_cont.49199:
	fsti	%f1, %g31, 284
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.49200
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.49202
	addi	%g3, %g0, 0
	jmp	jle_cont.49203
jle_else.49202:
	addi	%g3, %g0, 1
jle_cont.49203:
	jmp	jle_cont.49201
jle_else.49200:
	addi	%g3, %g0, 1
jle_cont.49201:
	jne	%g3, %g0, jeq_else.49204
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.49206
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.49207
jeq_else.49206:
jeq_cont.49207:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.49205
jeq_else.49204:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.49205:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.49208
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.49210
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.49212
	addi	%g4, %g0, 0
	jmp	jle_cont.49213
jle_else.49212:
	addi	%g4, %g0, 1
jle_cont.49213:
	jmp	jle_cont.49211
jle_else.49210:
	addi	%g4, %g0, 1
jle_cont.49211:
	jne	%g4, %g0, jeq_else.49214
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.49215
jeq_else.49214:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.49215:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f4, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f4, %f0
	jmp	jeq_cont.49209
jeq_else.49208:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.49209:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.49216
	fmov	%f1, %f0
	jmp	jeq_cont.49217
jeq_else.49216:
	fneg	%f1, %f0
jeq_cont.49217:
	fsti	%f1, %g31, 280
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.49218
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.49220
	addi	%g3, %g0, 0
	jmp	jle_cont.49221
jle_else.49220:
	addi	%g3, %g0, 1
jle_cont.49221:
	jmp	jle_cont.49219
jle_else.49218:
	addi	%g3, %g0, 1
jle_cont.49219:
	jne	%g3, %g0, jeq_else.49222
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.49224
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.49225
jeq_else.49224:
jeq_cont.49225:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.49223
jeq_else.49222:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.49223:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.49226
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.49228
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.49230
	addi	%g4, %g0, 0
	jmp	jle_cont.49231
jle_else.49230:
	addi	%g4, %g0, 1
jle_cont.49231:
	jmp	jle_cont.49229
jle_else.49228:
	addi	%g4, %g0, 1
jle_cont.49229:
	jne	%g4, %g0, jeq_else.49232
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.49233
jeq_else.49232:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.49233:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f4, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f4, %f0
	jmp	jeq_cont.49227
jeq_else.49226:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.49227:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.49234
	fmov	%f1, %f0
	jmp	jeq_cont.49235
jeq_else.49234:
	fneg	%f1, %f0
jeq_cont.49235:
	fsti	%f1, %g31, 276
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.49236
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.49238
	addi	%g3, %g0, 0
	jmp	jle_cont.49239
jle_else.49238:
	addi	%g3, %g0, 1
jle_cont.49239:
	jmp	jle_cont.49237
jle_else.49236:
	addi	%g3, %g0, 1
jle_cont.49237:
	jne	%g3, %g0, jeq_else.49240
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.49242
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.49243
jeq_else.49242:
jeq_cont.49243:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.49241
jeq_else.49240:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.49241:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.49244
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.49246
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.49248
	addi	%g4, %g0, 0
	jmp	jle_cont.49249
jle_else.49248:
	addi	%g4, %g0, 1
jle_cont.49249:
	jmp	jle_cont.49247
jle_else.49246:
	addi	%g4, %g0, 1
jle_cont.49247:
	jne	%g4, %g0, jeq_else.49250
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.49251
jeq_else.49250:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.49251:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f4, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f4, %f0
	jmp	jeq_cont.49245
jeq_else.49244:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.49245:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.49252
	fmov	%f1, %f0
	jmp	jeq_cont.49253
jeq_else.49252:
	fneg	%f1, %f0
jeq_cont.49253:
	setL %g3, l.42507
	fldi	%f8, %g3, 0
	fmul	%f3, %f1, %f8
	fsub	%f2, %f22, %f3
	fjlt	%f2, %f16, fjge_else.49254
	fmov	%f1, %f2
	jmp	fjge_cont.49255
fjge_else.49254:
	fneg	%f1, %f2
fjge_cont.49255:
	fjlt	%f29, %f1, fjge_else.49256
	fjlt	%f1, %f16, fjge_else.49258
	fmov	%f0, %f1
	jmp	fjge_cont.49259
fjge_else.49258:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49260
	fjlt	%f1, %f16, fjge_else.49262
	fmov	%f0, %f1
	jmp	fjge_cont.49263
fjge_else.49262:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49264
	fjlt	%f1, %f16, fjge_else.49266
	fmov	%f0, %f1
	jmp	fjge_cont.49267
fjge_else.49266:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49267:
	jmp	fjge_cont.49265
fjge_else.49264:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49265:
fjge_cont.49263:
	jmp	fjge_cont.49261
fjge_else.49260:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49268
	fjlt	%f1, %f16, fjge_else.49270
	fmov	%f0, %f1
	jmp	fjge_cont.49271
fjge_else.49270:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49271:
	jmp	fjge_cont.49269
fjge_else.49268:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49269:
fjge_cont.49261:
fjge_cont.49259:
	jmp	fjge_cont.49257
fjge_else.49256:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49272
	fjlt	%f1, %f16, fjge_else.49274
	fmov	%f0, %f1
	jmp	fjge_cont.49275
fjge_else.49274:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49276
	fjlt	%f1, %f16, fjge_else.49278
	fmov	%f0, %f1
	jmp	fjge_cont.49279
fjge_else.49278:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49279:
	jmp	fjge_cont.49277
fjge_else.49276:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49277:
fjge_cont.49275:
	jmp	fjge_cont.49273
fjge_else.49272:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49280
	fjlt	%f1, %f16, fjge_else.49282
	fmov	%f0, %f1
	jmp	fjge_cont.49283
fjge_else.49282:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49283:
	jmp	fjge_cont.49281
fjge_else.49280:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49281:
fjge_cont.49273:
fjge_cont.49257:
	fjlt	%f5, %f0, fjge_else.49284
	fjlt	%f16, %f2, fjge_else.49286
	addi	%g3, %g0, 0
	jmp	fjge_cont.49287
fjge_else.49286:
	addi	%g3, %g0, 1
fjge_cont.49287:
	jmp	fjge_cont.49285
fjge_else.49284:
	fjlt	%f16, %f2, fjge_else.49288
	addi	%g3, %g0, 1
	jmp	fjge_cont.49289
fjge_else.49288:
	addi	%g3, %g0, 0
fjge_cont.49289:
fjge_cont.49285:
	fjlt	%f5, %f0, fjge_else.49290
	fmov	%f1, %f0
	jmp	fjge_cont.49291
fjge_else.49290:
	fsub	%f1, %f29, %f0
fjge_cont.49291:
	fjlt	%f22, %f1, fjge_else.49292
	fmov	%f0, %f1
	jmp	fjge_cont.49293
fjge_else.49292:
	fsub	%f0, %f5, %f1
fjge_cont.49293:
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
	jne	%g3, %g0, jeq_else.49294
	fneg	%f7, %f0
	jmp	jeq_cont.49295
jeq_else.49294:
	fmov	%f7, %f0
jeq_cont.49295:
	fjlt	%f3, %f16, fjge_else.49296
	fmov	%f1, %f3
	jmp	fjge_cont.49297
fjge_else.49296:
	fneg	%f1, %f3
fjge_cont.49297:
	fjlt	%f29, %f1, fjge_else.49298
	fjlt	%f1, %f16, fjge_else.49300
	fmov	%f0, %f1
	jmp	fjge_cont.49301
fjge_else.49300:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49302
	fjlt	%f1, %f16, fjge_else.49304
	fmov	%f0, %f1
	jmp	fjge_cont.49305
fjge_else.49304:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49306
	fjlt	%f1, %f16, fjge_else.49308
	fmov	%f0, %f1
	jmp	fjge_cont.49309
fjge_else.49308:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49309:
	jmp	fjge_cont.49307
fjge_else.49306:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49307:
fjge_cont.49305:
	jmp	fjge_cont.49303
fjge_else.49302:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49310
	fjlt	%f1, %f16, fjge_else.49312
	fmov	%f0, %f1
	jmp	fjge_cont.49313
fjge_else.49312:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49313:
	jmp	fjge_cont.49311
fjge_else.49310:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49311:
fjge_cont.49303:
fjge_cont.49301:
	jmp	fjge_cont.49299
fjge_else.49298:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49314
	fjlt	%f1, %f16, fjge_else.49316
	fmov	%f0, %f1
	jmp	fjge_cont.49317
fjge_else.49316:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49318
	fjlt	%f1, %f16, fjge_else.49320
	fmov	%f0, %f1
	jmp	fjge_cont.49321
fjge_else.49320:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49321:
	jmp	fjge_cont.49319
fjge_else.49318:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49319:
fjge_cont.49317:
	jmp	fjge_cont.49315
fjge_else.49314:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49322
	fjlt	%f1, %f16, fjge_else.49324
	fmov	%f0, %f1
	jmp	fjge_cont.49325
fjge_else.49324:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49325:
	jmp	fjge_cont.49323
fjge_else.49322:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49323:
fjge_cont.49315:
fjge_cont.49299:
	fjlt	%f5, %f0, fjge_else.49326
	fjlt	%f16, %f3, fjge_else.49328
	addi	%g3, %g0, 0
	jmp	fjge_cont.49329
fjge_else.49328:
	addi	%g3, %g0, 1
fjge_cont.49329:
	jmp	fjge_cont.49327
fjge_else.49326:
	fjlt	%f16, %f3, fjge_else.49330
	addi	%g3, %g0, 1
	jmp	fjge_cont.49331
fjge_else.49330:
	addi	%g3, %g0, 0
fjge_cont.49331:
fjge_cont.49327:
	fjlt	%f5, %f0, fjge_else.49332
	fmov	%f1, %f0
	jmp	fjge_cont.49333
fjge_else.49332:
	fsub	%f1, %f29, %f0
fjge_cont.49333:
	fjlt	%f22, %f1, fjge_else.49334
	fmov	%f0, %f1
	jmp	fjge_cont.49335
fjge_else.49334:
	fsub	%f0, %f5, %f1
fjge_cont.49335:
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
	jne	%g3, %g0, jeq_else.49336
	fneg	%f6, %f0
	jmp	jeq_cont.49337
jeq_else.49336:
	fmov	%f6, %f0
jeq_cont.49337:
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.49338
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.49340
	addi	%g3, %g0, 0
	jmp	jle_cont.49341
jle_else.49340:
	addi	%g3, %g0, 1
jle_cont.49341:
	jmp	jle_cont.49339
jle_else.49338:
	addi	%g3, %g0, 1
jle_cont.49339:
	jne	%g3, %g0, jeq_else.49342
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.49344
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.49345
jeq_else.49344:
jeq_cont.49345:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.49343
jeq_else.49342:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.49343:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.49346
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.49348
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.49350
	addi	%g4, %g0, 0
	jmp	jle_cont.49351
jle_else.49350:
	addi	%g4, %g0, 1
jle_cont.49351:
	jmp	jle_cont.49349
jle_else.49348:
	addi	%g4, %g0, 1
jle_cont.49349:
	jne	%g4, %g0, jeq_else.49352
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.49353
jeq_else.49352:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.49353:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f4, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f4, %f0
	jmp	jeq_cont.49347
jeq_else.49346:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.49347:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.49354
	fmov	%f1, %f0
	jmp	jeq_cont.49355
jeq_else.49354:
	fneg	%f1, %f0
jeq_cont.49355:
	fmul	%f3, %f1, %f8
	fsub	%f2, %f22, %f3
	fjlt	%f2, %f16, fjge_else.49356
	fmov	%f1, %f2
	jmp	fjge_cont.49357
fjge_else.49356:
	fneg	%f1, %f2
fjge_cont.49357:
	fjlt	%f29, %f1, fjge_else.49358
	fjlt	%f1, %f16, fjge_else.49360
	fmov	%f0, %f1
	jmp	fjge_cont.49361
fjge_else.49360:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49362
	fjlt	%f1, %f16, fjge_else.49364
	fmov	%f0, %f1
	jmp	fjge_cont.49365
fjge_else.49364:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49366
	fjlt	%f1, %f16, fjge_else.49368
	fmov	%f0, %f1
	jmp	fjge_cont.49369
fjge_else.49368:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49369:
	jmp	fjge_cont.49367
fjge_else.49366:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49367:
fjge_cont.49365:
	jmp	fjge_cont.49363
fjge_else.49362:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49370
	fjlt	%f1, %f16, fjge_else.49372
	fmov	%f0, %f1
	jmp	fjge_cont.49373
fjge_else.49372:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49373:
	jmp	fjge_cont.49371
fjge_else.49370:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49371:
fjge_cont.49363:
fjge_cont.49361:
	jmp	fjge_cont.49359
fjge_else.49358:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49374
	fjlt	%f1, %f16, fjge_else.49376
	fmov	%f0, %f1
	jmp	fjge_cont.49377
fjge_else.49376:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49378
	fjlt	%f1, %f16, fjge_else.49380
	fmov	%f0, %f1
	jmp	fjge_cont.49381
fjge_else.49380:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49381:
	jmp	fjge_cont.49379
fjge_else.49378:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49379:
fjge_cont.49377:
	jmp	fjge_cont.49375
fjge_else.49374:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49382
	fjlt	%f1, %f16, fjge_else.49384
	fmov	%f0, %f1
	jmp	fjge_cont.49385
fjge_else.49384:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49385:
	jmp	fjge_cont.49383
fjge_else.49382:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49383:
fjge_cont.49375:
fjge_cont.49359:
	fjlt	%f5, %f0, fjge_else.49386
	fjlt	%f16, %f2, fjge_else.49388
	addi	%g3, %g0, 0
	jmp	fjge_cont.49389
fjge_else.49388:
	addi	%g3, %g0, 1
fjge_cont.49389:
	jmp	fjge_cont.49387
fjge_else.49386:
	fjlt	%f16, %f2, fjge_else.49390
	addi	%g3, %g0, 1
	jmp	fjge_cont.49391
fjge_else.49390:
	addi	%g3, %g0, 0
fjge_cont.49391:
fjge_cont.49387:
	fjlt	%f5, %f0, fjge_else.49392
	fmov	%f1, %f0
	jmp	fjge_cont.49393
fjge_else.49392:
	fsub	%f1, %f29, %f0
fjge_cont.49393:
	fjlt	%f22, %f1, fjge_else.49394
	fmov	%f0, %f1
	jmp	fjge_cont.49395
fjge_else.49394:
	fsub	%f0, %f5, %f1
fjge_cont.49395:
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
	jne	%g3, %g0, jeq_else.49396
	fneg	%f2, %f0
	jmp	jeq_cont.49397
jeq_else.49396:
	fmov	%f2, %f0
jeq_cont.49397:
	fjlt	%f3, %f16, fjge_else.49398
	fmov	%f1, %f3
	jmp	fjge_cont.49399
fjge_else.49398:
	fneg	%f1, %f3
fjge_cont.49399:
	fjlt	%f29, %f1, fjge_else.49400
	fjlt	%f1, %f16, fjge_else.49402
	fmov	%f0, %f1
	jmp	fjge_cont.49403
fjge_else.49402:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49404
	fjlt	%f1, %f16, fjge_else.49406
	fmov	%f0, %f1
	jmp	fjge_cont.49407
fjge_else.49406:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49408
	fjlt	%f1, %f16, fjge_else.49410
	fmov	%f0, %f1
	jmp	fjge_cont.49411
fjge_else.49410:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49411:
	jmp	fjge_cont.49409
fjge_else.49408:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49409:
fjge_cont.49407:
	jmp	fjge_cont.49405
fjge_else.49404:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49412
	fjlt	%f1, %f16, fjge_else.49414
	fmov	%f0, %f1
	jmp	fjge_cont.49415
fjge_else.49414:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49415:
	jmp	fjge_cont.49413
fjge_else.49412:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49413:
fjge_cont.49405:
fjge_cont.49403:
	jmp	fjge_cont.49401
fjge_else.49400:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49416
	fjlt	%f1, %f16, fjge_else.49418
	fmov	%f0, %f1
	jmp	fjge_cont.49419
fjge_else.49418:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49420
	fjlt	%f1, %f16, fjge_else.49422
	fmov	%f0, %f1
	jmp	fjge_cont.49423
fjge_else.49422:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49423:
	jmp	fjge_cont.49421
fjge_else.49420:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49421:
fjge_cont.49419:
	jmp	fjge_cont.49417
fjge_else.49416:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49424
	fjlt	%f1, %f16, fjge_else.49426
	fmov	%f0, %f1
	jmp	fjge_cont.49427
fjge_else.49426:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49427:
	jmp	fjge_cont.49425
fjge_else.49424:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49425:
fjge_cont.49417:
fjge_cont.49401:
	fjlt	%f5, %f0, fjge_else.49428
	fjlt	%f16, %f3, fjge_else.49430
	addi	%g3, %g0, 0
	jmp	fjge_cont.49431
fjge_else.49430:
	addi	%g3, %g0, 1
fjge_cont.49431:
	jmp	fjge_cont.49429
fjge_else.49428:
	fjlt	%f16, %f3, fjge_else.49432
	addi	%g3, %g0, 1
	jmp	fjge_cont.49433
fjge_else.49432:
	addi	%g3, %g0, 0
fjge_cont.49433:
fjge_cont.49429:
	fjlt	%f5, %f0, fjge_else.49434
	fmov	%f1, %f0
	jmp	fjge_cont.49435
fjge_else.49434:
	fsub	%f1, %f29, %f0
fjge_cont.49435:
	fjlt	%f22, %f1, fjge_else.49436
	fmov	%f0, %f1
	jmp	fjge_cont.49437
fjge_else.49436:
	fsub	%f0, %f5, %f1
fjge_cont.49437:
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
	jne	%g3, %g0, jeq_else.49438
	fneg	%f0, %f1
	jmp	jeq_cont.49439
jeq_else.49438:
	fmov	%f0, %f1
jeq_cont.49439:
	fmul	%f3, %f7, %f0
	setL %g3, l.42545
	fldi	%f1, %g3, 0
	fmul	%f3, %f3, %f1
	fsti	%f3, %g31, 672
	setL %g3, l.42548
	fldi	%f3, %g3, 0
	fmul	%f3, %f6, %f3
	fsti	%f3, %g31, 668
	fmul	%f3, %f7, %f2
	fmul	%f1, %f3, %f1
	fsti	%f1, %g31, 664
	fsti	%f2, %g31, 648
	fsti	%f16, %g31, 644
	fneg	%f1, %f0
	fsti	%f1, %g31, 640
	fneg	%f1, %f6
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 660
	fneg	%f7, %f7
	fsti	%f7, %g31, 656
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
	addi	%g3, %g0, 0
	sti	%g3, %g31, 4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 8
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.49440
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.49442
	addi	%g3, %g0, 0
	jmp	jle_cont.49443
jle_else.49442:
	addi	%g3, %g0, 1
jle_cont.49443:
	jmp	jle_cont.49441
jle_else.49440:
	addi	%g3, %g0, 1
jle_cont.49441:
	jne	%g3, %g0, jeq_else.49444
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.49446
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
	jmp	jeq_cont.49447
jeq_else.49446:
jeq_cont.49447:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	jmp	jeq_cont.49445
jeq_else.49444:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
jeq_cont.49445:
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.49448
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.49450
	addi	%g3, %g0, 0
	jmp	jle_cont.49451
jle_else.49450:
	addi	%g3, %g0, 1
jle_cont.49451:
	jmp	jle_cont.49449
jle_else.49448:
	addi	%g3, %g0, 1
jle_cont.49449:
	jne	%g3, %g0, jeq_else.49452
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.49454
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.49455
jeq_else.49454:
jeq_cont.49455:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.49453
jeq_else.49452:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.49453:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.49456
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.49458
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.49460
	addi	%g4, %g0, 0
	jmp	jle_cont.49461
jle_else.49460:
	addi	%g4, %g0, 1
jle_cont.49461:
	jmp	jle_cont.49459
jle_else.49458:
	addi	%g4, %g0, 1
jle_cont.49459:
	jne	%g4, %g0, jeq_else.49462
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.49463
jeq_else.49462:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.49463:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f4, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f4, %f0
	jmp	jeq_cont.49457
jeq_else.49456:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.49457:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.49464
	fmov	%f1, %f0
	jmp	jeq_cont.49465
jeq_else.49464:
	fneg	%f1, %f0
jeq_cont.49465:
	fmul	%f3, %f1, %f8
	fjlt	%f3, %f16, fjge_else.49466
	fmov	%f1, %f3
	jmp	fjge_cont.49467
fjge_else.49466:
	fneg	%f1, %f3
fjge_cont.49467:
	fjlt	%f29, %f1, fjge_else.49468
	fjlt	%f1, %f16, fjge_else.49470
	fmov	%f0, %f1
	jmp	fjge_cont.49471
fjge_else.49470:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49472
	fjlt	%f1, %f16, fjge_else.49474
	fmov	%f0, %f1
	jmp	fjge_cont.49475
fjge_else.49474:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49476
	fjlt	%f1, %f16, fjge_else.49478
	fmov	%f0, %f1
	jmp	fjge_cont.49479
fjge_else.49478:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49479:
	jmp	fjge_cont.49477
fjge_else.49476:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49477:
fjge_cont.49475:
	jmp	fjge_cont.49473
fjge_else.49472:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49480
	fjlt	%f1, %f16, fjge_else.49482
	fmov	%f0, %f1
	jmp	fjge_cont.49483
fjge_else.49482:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49483:
	jmp	fjge_cont.49481
fjge_else.49480:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49481:
fjge_cont.49473:
fjge_cont.49471:
	jmp	fjge_cont.49469
fjge_else.49468:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49484
	fjlt	%f1, %f16, fjge_else.49486
	fmov	%f0, %f1
	jmp	fjge_cont.49487
fjge_else.49486:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49488
	fjlt	%f1, %f16, fjge_else.49490
	fmov	%f0, %f1
	jmp	fjge_cont.49491
fjge_else.49490:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49491:
	jmp	fjge_cont.49489
fjge_else.49488:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49489:
fjge_cont.49487:
	jmp	fjge_cont.49485
fjge_else.49484:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49492
	fjlt	%f1, %f16, fjge_else.49494
	fmov	%f0, %f1
	jmp	fjge_cont.49495
fjge_else.49494:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49495:
	jmp	fjge_cont.49493
fjge_else.49492:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49493:
fjge_cont.49485:
fjge_cont.49469:
	fjlt	%f5, %f0, fjge_else.49496
	fjlt	%f16, %f3, fjge_else.49498
	addi	%g3, %g0, 0
	jmp	fjge_cont.49499
fjge_else.49498:
	addi	%g3, %g0, 1
fjge_cont.49499:
	jmp	fjge_cont.49497
fjge_else.49496:
	fjlt	%f16, %f3, fjge_else.49500
	addi	%g3, %g0, 1
	jmp	fjge_cont.49501
fjge_else.49500:
	addi	%g3, %g0, 0
fjge_cont.49501:
fjge_cont.49497:
	fjlt	%f5, %f0, fjge_else.49502
	fmov	%f1, %f0
	jmp	fjge_cont.49503
fjge_else.49502:
	fsub	%f1, %f29, %f0
fjge_cont.49503:
	fjlt	%f22, %f1, fjge_else.49504
	fmov	%f0, %f1
	jmp	fjge_cont.49505
fjge_else.49504:
	fsub	%f0, %f5, %f1
fjge_cont.49505:
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
	jne	%g3, %g0, jeq_else.49506
	fneg	%f0, %f1
	jmp	jeq_cont.49507
jeq_else.49506:
	fmov	%f0, %f1
jeq_cont.49507:
	fneg	%f0, %f0
	fsti	%f0, %g31, 304
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.49508
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.49510
	addi	%g3, %g0, 0
	jmp	jle_cont.49511
jle_else.49510:
	addi	%g3, %g0, 1
jle_cont.49511:
	jmp	jle_cont.49509
jle_else.49508:
	addi	%g3, %g0, 1
jle_cont.49509:
	jne	%g3, %g0, jeq_else.49512
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.49514
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.49515
jeq_else.49514:
jeq_cont.49515:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.49513
jeq_else.49512:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.49513:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.49516
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.49518
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.49520
	addi	%g4, %g0, 0
	jmp	jle_cont.49521
jle_else.49520:
	addi	%g4, %g0, 1
jle_cont.49521:
	jmp	jle_cont.49519
jle_else.49518:
	addi	%g4, %g0, 1
jle_cont.49519:
	jne	%g4, %g0, jeq_else.49522
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.49523
jeq_else.49522:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.49523:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f6, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f4, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f4, %f0
	fadd	%f0, %f6, %f0
	jmp	jeq_cont.49517
jeq_else.49516:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.49517:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.49524
	fmov	%f1, %f0
	jmp	jeq_cont.49525
jeq_else.49524:
	fneg	%f1, %f0
jeq_cont.49525:
	fmul	%f4, %f1, %f8
	fsub	%f2, %f22, %f3
	fjlt	%f2, %f16, fjge_else.49526
	fmov	%f1, %f2
	jmp	fjge_cont.49527
fjge_else.49526:
	fneg	%f1, %f2
fjge_cont.49527:
	fjlt	%f29, %f1, fjge_else.49528
	fjlt	%f1, %f16, fjge_else.49530
	fmov	%f0, %f1
	jmp	fjge_cont.49531
fjge_else.49530:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49532
	fjlt	%f1, %f16, fjge_else.49534
	fmov	%f0, %f1
	jmp	fjge_cont.49535
fjge_else.49534:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49536
	fjlt	%f1, %f16, fjge_else.49538
	fmov	%f0, %f1
	jmp	fjge_cont.49539
fjge_else.49538:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49539:
	jmp	fjge_cont.49537
fjge_else.49536:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49537:
fjge_cont.49535:
	jmp	fjge_cont.49533
fjge_else.49532:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49540
	fjlt	%f1, %f16, fjge_else.49542
	fmov	%f0, %f1
	jmp	fjge_cont.49543
fjge_else.49542:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49543:
	jmp	fjge_cont.49541
fjge_else.49540:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49541:
fjge_cont.49533:
fjge_cont.49531:
	jmp	fjge_cont.49529
fjge_else.49528:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49544
	fjlt	%f1, %f16, fjge_else.49546
	fmov	%f0, %f1
	jmp	fjge_cont.49547
fjge_else.49546:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49548
	fjlt	%f1, %f16, fjge_else.49550
	fmov	%f0, %f1
	jmp	fjge_cont.49551
fjge_else.49550:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49551:
	jmp	fjge_cont.49549
fjge_else.49548:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49549:
fjge_cont.49547:
	jmp	fjge_cont.49545
fjge_else.49544:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49552
	fjlt	%f1, %f16, fjge_else.49554
	fmov	%f0, %f1
	jmp	fjge_cont.49555
fjge_else.49554:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49555:
	jmp	fjge_cont.49553
fjge_else.49552:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49553:
fjge_cont.49545:
fjge_cont.49529:
	fjlt	%f5, %f0, fjge_else.49556
	fjlt	%f16, %f2, fjge_else.49558
	addi	%g3, %g0, 0
	jmp	fjge_cont.49559
fjge_else.49558:
	addi	%g3, %g0, 1
fjge_cont.49559:
	jmp	fjge_cont.49557
fjge_else.49556:
	fjlt	%f16, %f2, fjge_else.49560
	addi	%g3, %g0, 1
	jmp	fjge_cont.49561
fjge_else.49560:
	addi	%g3, %g0, 0
fjge_cont.49561:
fjge_cont.49557:
	fjlt	%f5, %f0, fjge_else.49562
	fmov	%f1, %f0
	jmp	fjge_cont.49563
fjge_else.49562:
	fsub	%f1, %f29, %f0
fjge_cont.49563:
	fjlt	%f22, %f1, fjge_else.49564
	fmov	%f0, %f1
	jmp	fjge_cont.49565
fjge_else.49564:
	fsub	%f0, %f5, %f1
fjge_cont.49565:
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
	jne	%g3, %g0, jeq_else.49566
	fneg	%f3, %f0
	jmp	jeq_cont.49567
jeq_else.49566:
	fmov	%f3, %f0
jeq_cont.49567:
	fjlt	%f4, %f16, fjge_else.49568
	fmov	%f1, %f4
	jmp	fjge_cont.49569
fjge_else.49568:
	fneg	%f1, %f4
fjge_cont.49569:
	fjlt	%f29, %f1, fjge_else.49570
	fjlt	%f1, %f16, fjge_else.49572
	fmov	%f0, %f1
	jmp	fjge_cont.49573
fjge_else.49572:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49574
	fjlt	%f1, %f16, fjge_else.49576
	fmov	%f0, %f1
	jmp	fjge_cont.49577
fjge_else.49576:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49578
	fjlt	%f1, %f16, fjge_else.49580
	fmov	%f0, %f1
	jmp	fjge_cont.49581
fjge_else.49580:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49581:
	jmp	fjge_cont.49579
fjge_else.49578:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49579:
fjge_cont.49577:
	jmp	fjge_cont.49575
fjge_else.49574:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49582
	fjlt	%f1, %f16, fjge_else.49584
	fmov	%f0, %f1
	jmp	fjge_cont.49585
fjge_else.49584:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49585:
	jmp	fjge_cont.49583
fjge_else.49582:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49583:
fjge_cont.49575:
fjge_cont.49573:
	jmp	fjge_cont.49571
fjge_else.49570:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49586
	fjlt	%f1, %f16, fjge_else.49588
	fmov	%f0, %f1
	jmp	fjge_cont.49589
fjge_else.49588:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49590
	fjlt	%f1, %f16, fjge_else.49592
	fmov	%f0, %f1
	jmp	fjge_cont.49593
fjge_else.49592:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49593:
	jmp	fjge_cont.49591
fjge_else.49590:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49591:
fjge_cont.49589:
	jmp	fjge_cont.49587
fjge_else.49586:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49594
	fjlt	%f1, %f16, fjge_else.49596
	fmov	%f0, %f1
	jmp	fjge_cont.49597
fjge_else.49596:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49597:
	jmp	fjge_cont.49595
fjge_else.49594:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49595:
fjge_cont.49587:
fjge_cont.49571:
	fjlt	%f5, %f0, fjge_else.49598
	fjlt	%f16, %f4, fjge_else.49600
	addi	%g3, %g0, 0
	jmp	fjge_cont.49601
fjge_else.49600:
	addi	%g3, %g0, 1
fjge_cont.49601:
	jmp	fjge_cont.49599
fjge_else.49598:
	fjlt	%f16, %f4, fjge_else.49602
	addi	%g3, %g0, 1
	jmp	fjge_cont.49603
fjge_else.49602:
	addi	%g3, %g0, 0
fjge_cont.49603:
fjge_cont.49599:
	fjlt	%f5, %f0, fjge_else.49604
	fmov	%f1, %f0
	jmp	fjge_cont.49605
fjge_else.49604:
	fsub	%f1, %f29, %f0
fjge_cont.49605:
	fjlt	%f22, %f1, fjge_else.49606
	fmov	%f0, %f1
	jmp	fjge_cont.49607
fjge_else.49606:
	fsub	%f0, %f5, %f1
fjge_cont.49607:
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
	jne	%g3, %g0, jeq_else.49608
	fneg	%f0, %f1
	jmp	jeq_cont.49609
jeq_else.49608:
	fmov	%f0, %f1
jeq_cont.49609:
	fmul	%f0, %f3, %f0
	fsti	%f0, %g31, 308
	fsub	%f2, %f22, %f4
	fjlt	%f2, %f16, fjge_else.49610
	fmov	%f1, %f2
	jmp	fjge_cont.49611
fjge_else.49610:
	fneg	%f1, %f2
fjge_cont.49611:
	fjlt	%f29, %f1, fjge_else.49612
	fjlt	%f1, %f16, fjge_else.49614
	fmov	%f0, %f1
	jmp	fjge_cont.49615
fjge_else.49614:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49616
	fjlt	%f1, %f16, fjge_else.49618
	fmov	%f0, %f1
	jmp	fjge_cont.49619
fjge_else.49618:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49620
	fjlt	%f1, %f16, fjge_else.49622
	fmov	%f0, %f1
	jmp	fjge_cont.49623
fjge_else.49622:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49623:
	jmp	fjge_cont.49621
fjge_else.49620:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49621:
fjge_cont.49619:
	jmp	fjge_cont.49617
fjge_else.49616:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49624
	fjlt	%f1, %f16, fjge_else.49626
	fmov	%f0, %f1
	jmp	fjge_cont.49627
fjge_else.49626:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49627:
	jmp	fjge_cont.49625
fjge_else.49624:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49625:
fjge_cont.49617:
fjge_cont.49615:
	jmp	fjge_cont.49613
fjge_else.49612:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49628
	fjlt	%f1, %f16, fjge_else.49630
	fmov	%f0, %f1
	jmp	fjge_cont.49631
fjge_else.49630:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49632
	fjlt	%f1, %f16, fjge_else.49634
	fmov	%f0, %f1
	jmp	fjge_cont.49635
fjge_else.49634:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49635:
	jmp	fjge_cont.49633
fjge_else.49632:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49633:
fjge_cont.49631:
	jmp	fjge_cont.49629
fjge_else.49628:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49636
	fjlt	%f1, %f16, fjge_else.49638
	fmov	%f0, %f1
	jmp	fjge_cont.49639
fjge_else.49638:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49639:
	jmp	fjge_cont.49637
fjge_else.49636:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.49637:
fjge_cont.49629:
fjge_cont.49613:
	fjlt	%f5, %f0, fjge_else.49640
	fjlt	%f16, %f2, fjge_else.49642
	addi	%g3, %g0, 0
	jmp	fjge_cont.49643
fjge_else.49642:
	addi	%g3, %g0, 1
fjge_cont.49643:
	jmp	fjge_cont.49641
fjge_else.49640:
	fjlt	%f16, %f2, fjge_else.49644
	addi	%g3, %g0, 1
	jmp	fjge_cont.49645
fjge_else.49644:
	addi	%g3, %g0, 0
fjge_cont.49645:
fjge_cont.49641:
	fjlt	%f5, %f0, fjge_else.49646
	fmov	%f1, %f0
	jmp	fjge_cont.49647
fjge_else.49646:
	fsub	%f1, %f29, %f0
fjge_cont.49647:
	fjlt	%f22, %f1, fjge_else.49648
	fmov	%f0, %f1
	jmp	fjge_cont.49649
fjge_else.49648:
	fsub	%f0, %f5, %f1
fjge_cont.49649:
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
	jne	%g3, %g0, jeq_else.49650
	fneg	%f0, %f1
	jmp	jeq_cont.49651
jeq_else.49650:
	fmov	%f0, %f1
jeq_cont.49651:
	fmul	%f0, %f3, %f0
	fsti	%f0, %g31, 300
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.49652
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.49654
	addi	%g3, %g0, 0
	jmp	jle_cont.49655
jle_else.49654:
	addi	%g3, %g0, 1
jle_cont.49655:
	jmp	jle_cont.49653
jle_else.49652:
	addi	%g3, %g0, 1
jle_cont.49653:
	jne	%g3, %g0, jeq_else.49656
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.49658
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.49659
jeq_else.49658:
jeq_cont.49659:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.49657
jeq_else.49656:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.49657:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.49660
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.49662
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.49664
	addi	%g4, %g0, 0
	jmp	jle_cont.49665
jle_else.49664:
	addi	%g4, %g0, 1
jle_cont.49665:
	jmp	jle_cont.49663
jle_else.49662:
	addi	%g4, %g0, 1
jle_cont.49663:
	jne	%g4, %g0, jeq_else.49666
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.49667
jeq_else.49666:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.49667:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f4, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f4, %f0
	jmp	jeq_cont.49661
jeq_else.49660:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.49661:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.49668
	fmov	%f1, %f0
	jmp	jeq_cont.49669
jeq_else.49668:
	fneg	%f1, %f0
jeq_cont.49669:
	fsti	%f1, %g31, 312
	addi	%g19, %g0, 0
	sti	%g16, %g1, 0
	fsti	%f10, %g1, 4
	mov	%g16, %g19
	subi	%g1, %g1, 12
	call	read_object.2696
	addi	%g1, %g1, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 8
	input	%g5
	addi	%g10, %g0, 48
	jlt	%g5, %g10, jle_else.49670
	addi	%g10, %g0, 57
	jlt	%g10, %g5, jle_else.49672
	addi	%g10, %g0, 0
	jmp	jle_cont.49673
jle_else.49672:
	addi	%g10, %g0, 1
jle_cont.49673:
	jmp	jle_cont.49671
jle_else.49670:
	addi	%g10, %g0, 1
jle_cont.49671:
	jne	%g10, %g0, jeq_else.49674
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.49676
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
	jmp	jeq_cont.49677
jeq_else.49676:
jeq_cont.49677:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	subi	%g1, %g1, 12
	call	read_int_token.2507
	addi	%g1, %g1, 12
	mov	%g10, %g3
	jmp	jeq_cont.49675
jeq_else.49674:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 12
	call	read_int_token.2507
	addi	%g1, %g1, 12
	mov	%g10, %g3
jeq_cont.49675:
	jne	%g10, %g29, jeq_else.49678
	addi	%g3, %g0, 1
	addi	%g4, %g0, -1
	subi	%g1, %g1, 12
	call	min_caml_create_array
	addi	%g1, %g1, 12
	jmp	jeq_cont.49679
jeq_else.49678:
	addi	%g8, %g0, 1
	subi	%g1, %g1, 12
	call	read_net_item.2700
	addi	%g1, %g1, 12
	sti	%g10, %g3, 0
jeq_cont.49679:
	sti	%g3, %g31, 2300
	ldi	%g4, %g3, 0
	jne	%g4, %g29, jeq_else.49680
	jmp	jeq_cont.49681
jeq_else.49680:
	sti	%g3, %g31, 512
	addi	%g11, %g0, 1
	subi	%g1, %g1, 12
	call	read_and_network.2704
	addi	%g1, %g1, 12
jeq_cont.49681:
	addi	%g3, %g0, 0
	sti	%g3, %g31, 4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 8
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.49682
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.49684
	addi	%g3, %g0, 0
	jmp	jle_cont.49685
jle_else.49684:
	addi	%g3, %g0, 1
jle_cont.49685:
	jmp	jle_cont.49683
jle_else.49682:
	addi	%g3, %g0, 1
jle_cont.49683:
	jne	%g3, %g0, jeq_else.49686
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.49688
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
	jmp	jeq_cont.49689
jeq_else.49688:
jeq_cont.49689:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	subi	%g1, %g1, 12
	call	read_int_token.2507
	addi	%g1, %g1, 12
	jmp	jeq_cont.49687
jeq_else.49686:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 12
	call	read_int_token.2507
	addi	%g1, %g1, 12
jeq_cont.49687:
	jne	%g3, %g29, jeq_else.49690
	addi	%g3, %g0, 1
	addi	%g4, %g0, -1
	subi	%g1, %g1, 12
	call	min_caml_create_array
	addi	%g1, %g1, 12
	mov	%g4, %g3
	jmp	jeq_cont.49691
jeq_else.49690:
	addi	%g8, %g0, 1
	sti	%g3, %g1, 8
	subi	%g1, %g1, 16
	call	read_net_item.2700
	addi	%g1, %g1, 16
	mov	%g4, %g3
	ldi	%g3, %g1, 8
	sti	%g3, %g4, 0
jeq_cont.49691:
	sti	%g4, %g31, 2304
	ldi	%g3, %g4, 0
	jne	%g3, %g29, jeq_else.49692
	addi	%g3, %g0, 1
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	jmp	jeq_cont.49693
jeq_else.49692:
	addi	%g11, %g0, 1
	sti	%g4, %g1, 12
	subi	%g1, %g1, 20
	call	read_or_network.2702
	addi	%g1, %g1, 20
	ldi	%g4, %g1, 12
	sti	%g4, %g3, 0
jeq_cont.49693:
	sti	%g3, %g31, 516
	addi	%g3, %g0, 80
	output	%g3
	addi	%g3, %g0, 51
	output	%g3
	addi	%g3, %g0, 10
	output	%g3
	ldi	%g4, %g31, 600
	subi	%g1, %g1, 20
	call	print_int.2528
	addi	%g3, %g0, 32
	output	%g3
	ldi	%g4, %g31, 596
	call	print_int.2528
	addi	%g3, %g0, 32
	output	%g3
	addi	%g4, %g0, 255
	call	print_int.2528
	addi	%g3, %g0, 10
	output	%g3
	addi	%g6, %g0, 120
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2316
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2372
	ldi	%g3, %g31, 28
	subi	%g4, %g31, 2316
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g4, %g31, 2320
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
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2332
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2372
	ldi	%g3, %g31, 28
	subi	%g4, %g31, 2332
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g4, %g31, 2336
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g4, %g3, -4
	sti	%g7, %g3, 0
	sti	%g3, %g6, -472
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2348
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2372
	ldi	%g3, %g31, 28
	subi	%g4, %g31, 2348
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g4, %g31, 2352
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g4, %g3, -4
	sti	%g7, %g3, 0
	sti	%g3, %g6, -468
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2372
	subi	%g2, %g31, 2364
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2372
	ldi	%g3, %g31, 28
	subi	%g4, %g31, 2364
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g4, %g31, 2368
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g4, %g3, -4
	sti	%g7, %g3, 0
	sti	%g3, %g6, -464
	addi	%g7, %g0, 115
	call	create_dirvec_elements.3012
	addi	%g8, %g0, 3
	call	create_dirvecs.3015
	addi	%g3, %g0, 9
	addi	%g8, %g0, 0
	addi	%g12, %g0, 0
	call	min_caml_float_of_int
	addi	%g1, %g1, 20
	setL %g3, l.42722
	fldi	%f4, %g3, 0
	fmul	%f0, %f0, %f4
	setL %g3, l.42724
	fldi	%f3, %g3, 0
	fsub	%f0, %f0, %f3
	addi	%g3, %g0, 4
	fsti	%f0, %g1, 16
	subi	%g1, %g1, 24
	call	min_caml_float_of_int
	addi	%g1, %g1, 24
	fmov	%f1, %f0
	fmul	%f1, %f1, %f4
	fsub	%f2, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 16
	fsti	%f3, %g1, 20
	fsti	%f4, %g1, 24
	fsti	%f1, %g1, 28
	mov	%g3, %g12
	mov	%g5, %g8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 36
	call	calc_dirvec.2993
	addi	%g1, %g1, 36
	setL %g3, l.42726
	fldi	%f5, %g3, 0
	fldi	%f1, %g1, 28
	fadd	%f2, %f1, %f5
	addi	%g4, %g0, 0
	addi	%g3, %g0, 2
	fldi	%f0, %g1, 16
	fsti	%f5, %g1, 32
	mov	%g5, %g8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 40
	call	calc_dirvec.2993
	addi	%g1, %g1, 40
	addi	%g3, %g0, 3
	addi	%g5, %g0, 1
	sti	%g5, %g1, 36
	subi	%g1, %g1, 44
	call	min_caml_float_of_int
	addi	%g1, %g1, 44
	fmov	%f1, %f0
	fldi	%f4, %g1, 24
	fmul	%f1, %f1, %f4
	fldi	%f3, %g1, 20
	fsub	%f2, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 16
	ldi	%g5, %g1, 36
	fsti	%f1, %g1, 40
	mov	%g3, %g12
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 48
	call	calc_dirvec.2993
	addi	%g1, %g1, 48
	fldi	%f5, %g1, 32
	fldi	%f1, %g1, 40
	fadd	%f2, %f1, %f5
	addi	%g4, %g0, 0
	addi	%g8, %g0, 2
	fldi	%f0, %g1, 16
	ldi	%g5, %g1, 36
	mov	%g3, %g8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 48
	call	calc_dirvec.2993
	addi	%g1, %g1, 48
	addi	%g3, %g0, 2
	addi	%g5, %g0, 2
	sti	%g5, %g1, 44
	subi	%g1, %g1, 52
	call	min_caml_float_of_int
	addi	%g1, %g1, 52
	fmov	%f1, %f0
	fldi	%f4, %g1, 24
	fmul	%f1, %f1, %f4
	fldi	%f3, %g1, 20
	fsub	%f2, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 16
	ldi	%g5, %g1, 44
	fsti	%f1, %g1, 48
	mov	%g3, %g12
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 56
	call	calc_dirvec.2993
	addi	%g1, %g1, 56
	fldi	%f5, %g1, 32
	fldi	%f1, %g1, 48
	fadd	%f2, %f1, %f5
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 16
	ldi	%g5, %g1, 44
	mov	%g3, %g8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 56
	call	calc_dirvec.2993
	addi	%g1, %g1, 56
	addi	%g10, %g0, 1
	addi	%g9, %g0, 3
	fldi	%f0, %g1, 16
	mov	%g8, %g12
	subi	%g1, %g1, 56
	call	calc_dirvecs.3001
	addi	%g13, %g0, 8
	addi	%g12, %g0, 2
	addi	%g8, %g0, 4
	call	calc_dirvec_rows.3006
	ldi	%g11, %g31, 700
	ldi	%g3, %g11, -476
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -472
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -468
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -464
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -460
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -456
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -452
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	addi	%g12, %g0, 112
	call	init_dirvec_constants.3017
	addi	%g1, %g1, 56
	addi	%g13, %g0, 3
	sti	%g18, %g1, 52
	sti	%g17, %g1, 56
	subi	%g1, %g1, 64
	call	init_vecset_constants.3020
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
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 64
	ldi	%g3, %g31, 28
	subi	%g6, %g3, 1
	jlt	%g6, %g0, jge_else.49694
	slli	%g3, %g6, 2
	add	%g3, %g31, %g3
	ldi	%g3, %g3, 272
	ldi	%g4, %g3, -8
	addi	%g5, %g0, 2
	jne	%g4, %g5, jeq_else.49696
	ldi	%g4, %g3, -28
	fldi	%f0, %g4, 0
	fjlt	%f0, %f17, fjge_else.49698
	jmp	fjge_cont.49699
fjge_else.49698:
	ldi	%g5, %g3, -4
	jne	%g5, %g28, jeq_else.49700
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
	subi	%g1, %g1, 64
	call	min_caml_create_float_array
	addi	%g1, %g1, 64
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 60
	subi	%g1, %g1, 68
	call	min_caml_create_array
	addi	%g1, %g1, 68
	mov	%g5, %g2
	addi	%g2, %g2, 8
	sti	%g3, %g5, -4
	ldi	%g4, %g1, 60
	sti	%g4, %g5, 0
	fsti	%f1, %g4, 0
	fsti	%f10, %g4, -4
	fsti	%f9, %g4, -8
	ldi	%g6, %g31, 28
	subi	%g13, %g6, 1
	sti	%g5, %g1, 64
	mov	%g5, %g13
	mov	%g6, %g3
	mov	%g7, %g4
	subi	%g1, %g1, 72
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 72
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fsti	%f12, %g3, -8
	ldi	%g5, %g1, 64
	sti	%g5, %g3, -4
	sti	%g14, %g3, 0
	slli	%g4, %g12, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 1716
	addi	%g15, %g12, 1
	addi	%g14, %g11, 2
	fldi	%f1, %g31, 304
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 72
	call	min_caml_create_float_array
	addi	%g1, %g1, 72
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 68
	subi	%g1, %g1, 76
	call	min_caml_create_array
	addi	%g1, %g1, 76
	mov	%g5, %g2
	addi	%g2, %g2, 8
	sti	%g3, %g5, -4
	ldi	%g4, %g1, 68
	sti	%g4, %g5, 0
	fsti	%f11, %g4, 0
	fsti	%f1, %g4, -4
	fsti	%f9, %g4, -8
	ldi	%g6, %g31, 28
	subi	%g13, %g6, 1
	sti	%g5, %g1, 72
	mov	%g5, %g13
	mov	%g6, %g3
	mov	%g7, %g4
	subi	%g1, %g1, 80
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 80
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fsti	%f12, %g3, -8
	ldi	%g5, %g1, 72
	sti	%g5, %g3, -4
	sti	%g14, %g3, 0
	slli	%g4, %g15, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 1716
	addi	%g14, %g12, 2
	addi	%g13, %g11, 3
	fldi	%f1, %g31, 300
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 80
	call	min_caml_create_float_array
	addi	%g1, %g1, 80
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 76
	subi	%g1, %g1, 84
	call	min_caml_create_array
	addi	%g1, %g1, 84
	mov	%g5, %g2
	addi	%g2, %g2, 8
	sti	%g3, %g5, -4
	ldi	%g4, %g1, 76
	sti	%g4, %g5, 0
	fsti	%f11, %g4, 0
	fsti	%f10, %g4, -4
	fsti	%f1, %g4, -8
	ldi	%g6, %g31, 28
	subi	%g11, %g6, 1
	sti	%g5, %g1, 80
	mov	%g5, %g11
	mov	%g6, %g3
	mov	%g7, %g4
	subi	%g1, %g1, 88
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 88
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fsti	%f12, %g3, -8
	ldi	%g5, %g1, 80
	sti	%g5, %g3, -4
	sti	%g13, %g3, 0
	slli	%g4, %g14, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 1716
	addi	%g3, %g12, 3
	sti	%g3, %g31, 1720
	jmp	jeq_cont.49701
jeq_else.49700:
	addi	%g4, %g0, 2
	jne	%g5, %g4, jeq_else.49702
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
	fldi	%f10, %g1, 4
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
	subi	%g1, %g1, 88
	call	min_caml_create_float_array
	addi	%g1, %g1, 88
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 84
	subi	%g1, %g1, 92
	call	min_caml_create_array
	addi	%g1, %g1, 92
	mov	%g5, %g2
	addi	%g2, %g2, 8
	sti	%g3, %g5, -4
	ldi	%g4, %g1, 84
	sti	%g4, %g5, 0
	fsti	%f5, %g4, 0
	fsti	%f4, %g4, -4
	fsti	%f1, %g4, -8
	ldi	%g6, %g31, 28
	subi	%g11, %g6, 1
	sti	%g5, %g1, 88
	mov	%g5, %g11
	mov	%g6, %g3
	mov	%g7, %g4
	subi	%g1, %g1, 96
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 96
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fsti	%f9, %g3, -8
	ldi	%g5, %g1, 88
	sti	%g5, %g3, -4
	sti	%g12, %g3, 0
	slli	%g4, %g13, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 1716
	addi	%g3, %g13, 1
	sti	%g3, %g31, 1720
	jmp	jeq_cont.49703
jeq_else.49702:
jeq_cont.49703:
jeq_cont.49701:
fjge_cont.49699:
	jmp	jeq_cont.49697
jeq_else.49696:
jeq_cont.49697:
	jmp	jge_cont.49695
jge_else.49694:
jge_cont.49695:
	addi	%g8, %g0, 0
	fldi	%f3, %g31, 612
	ldi	%g3, %g31, 604
	sub	%g3, %g0, %g3
	subi	%g1, %g1, 96
	call	min_caml_float_of_int
	addi	%g1, %g1, 96
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
	ldi	%g16, %g1, 0
	mov	%g7, %g16
	subi	%g1, %g1, 96
	call	pretrace_pixels.2958
	addi	%g1, %g1, 96
	addi	%g15, %g0, 0
	addi	%g8, %g0, 2
	ldi	%g3, %g31, 596
	jlt	%g15, %g3, jle_else.49704
	jmp	jle_cont.49705
jle_else.49704:
	subi	%g3, %g3, 1
	sti	%g15, %g1, 92
	jlt	%g15, %g3, jle_else.49706
	jmp	jle_cont.49707
jle_else.49706:
	addi	%g4, %g0, 1
	fldi	%f3, %g31, 612
	ldi	%g3, %g31, 604
	sub	%g3, %g4, %g3
	subi	%g1, %g1, 100
	call	min_caml_float_of_int
	addi	%g1, %g1, 100
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
	ldi	%g17, %g1, 56
	mov	%g7, %g17
	subi	%g1, %g1, 100
	call	pretrace_pixels.2958
	addi	%g1, %g1, 100
jle_cont.49707:
	addi	%g14, %g0, 0
	ldi	%g15, %g1, 92
	ldi	%g18, %g1, 52
	ldi	%g16, %g1, 0
	ldi	%g17, %g1, 56
	mov	%g27, %g18
	mov	%g18, %g17
	mov	%g17, %g27
	subi	%g1, %g1, 100
	call	scan_pixel.2969
	addi	%g1, %g1, 100
	addi	%g15, %g0, 1
	addi	%g8, %g0, 4
	ldi	%g16, %g1, 0
	ldi	%g17, %g1, 56
	ldi	%g18, %g1, 52
	mov	%g7, %g16
	mov	%g16, %g18
	subi	%g1, %g1, 100
	call	scan_line.2975
	addi	%g1, %g1, 100
jle_cont.49705:
	addi	%g0, %g0, 0
	halt

!==============================
! args = []
! fargs = [%f1]
! use_regs = [%g27, %f29, %f16, %f15, %f1, %f0]
! ret type = Float
!================================
sin_sub.2497:
	fjlt	%f29, %f1, fjge_else.49708
	fjlt	%f1, %f16, fjge_else.49709
	fmov	%f0, %f1
	return
fjge_else.49709:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49710
	fjlt	%f1, %f16, fjge_else.49711
	fmov	%f0, %f1
	return
fjge_else.49711:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49712
	fjlt	%f1, %f16, fjge_else.49713
	fmov	%f0, %f1
	return
fjge_else.49713:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49714
	fjlt	%f1, %f16, fjge_else.49715
	fmov	%f0, %f1
	return
fjge_else.49715:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2497
fjge_else.49714:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2497
fjge_else.49712:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49716
	fjlt	%f1, %f16, fjge_else.49717
	fmov	%f0, %f1
	return
fjge_else.49717:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2497
fjge_else.49716:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2497
fjge_else.49710:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49718
	fjlt	%f1, %f16, fjge_else.49719
	fmov	%f0, %f1
	return
fjge_else.49719:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49720
	fjlt	%f1, %f16, fjge_else.49721
	fmov	%f0, %f1
	return
fjge_else.49721:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2497
fjge_else.49720:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2497
fjge_else.49718:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49722
	fjlt	%f1, %f16, fjge_else.49723
	fmov	%f0, %f1
	return
fjge_else.49723:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2497
fjge_else.49722:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2497
fjge_else.49708:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49724
	fjlt	%f1, %f16, fjge_else.49725
	fmov	%f0, %f1
	return
fjge_else.49725:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49726
	fjlt	%f1, %f16, fjge_else.49727
	fmov	%f0, %f1
	return
fjge_else.49727:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49728
	fjlt	%f1, %f16, fjge_else.49729
	fmov	%f0, %f1
	return
fjge_else.49729:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2497
fjge_else.49728:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2497
fjge_else.49726:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49730
	fjlt	%f1, %f16, fjge_else.49731
	fmov	%f0, %f1
	return
fjge_else.49731:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2497
fjge_else.49730:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2497
fjge_else.49724:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49732
	fjlt	%f1, %f16, fjge_else.49733
	fmov	%f0, %f1
	return
fjge_else.49733:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49734
	fjlt	%f1, %f16, fjge_else.49735
	fmov	%f0, %f1
	return
fjge_else.49735:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2497
fjge_else.49734:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2497
fjge_else.49732:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.49736
	fjlt	%f1, %f16, fjge_else.49737
	fmov	%f0, %f1
	return
fjge_else.49737:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2497
fjge_else.49736:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2497

!==============================
! args = [%g6, %g5]
! fargs = []
! use_regs = [%g6, %g5, %g4, %g3, %g27, %f15, %dummy]
! ret type = Int
!================================
read_int_token.2507:
	input	%g4
	addi	%g3, %g0, 48
	jlt	%g4, %g3, jle_else.49738
	addi	%g3, %g0, 57
	jlt	%g3, %g4, jle_else.49740
	addi	%g3, %g0, 0
	jmp	jle_cont.49741
jle_else.49740:
	addi	%g3, %g0, 1
jle_cont.49741:
	jmp	jle_cont.49739
jle_else.49738:
	addi	%g3, %g0, 1
jle_cont.49739:
	jne	%g3, %g0, jeq_else.49742
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.49743
	addi	%g3, %g0, 45
	jne	%g5, %g3, jeq_else.49745
	addi	%g3, %g0, -1
	sti	%g3, %g31, 8
	jmp	jeq_cont.49746
jeq_else.49745:
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
jeq_cont.49746:
	jmp	jeq_cont.49744
jeq_else.49743:
jeq_cont.49744:
	ldi	%g3, %g31, 4
	slli	%g5, %g3, 3
	slli	%g3, %g3, 1
	add	%g5, %g5, %g3
	subi	%g3, %g4, 48
	add	%g3, %g5, %g3
	sti	%g3, %g31, 4
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.49747
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.49749
	addi	%g3, %g0, 0
	jmp	jle_cont.49750
jle_else.49749:
	addi	%g3, %g0, 1
jle_cont.49750:
	jmp	jle_cont.49748
jle_else.49747:
	addi	%g3, %g0, 1
jle_cont.49748:
	jne	%g3, %g0, jeq_else.49751
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.49752
	addi	%g3, %g0, 45
	jne	%g4, %g3, jeq_else.49754
	addi	%g3, %g0, -1
	sti	%g3, %g31, 8
	jmp	jeq_cont.49755
jeq_else.49754:
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
jeq_cont.49755:
	jmp	jeq_cont.49753
jeq_else.49752:
jeq_cont.49753:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	jmp	read_int_token.2507
jeq_else.49751:
	ldi	%g3, %g31, 8
	jne	%g3, %g28, jeq_else.49756
	ldi	%g3, %g31, 4
	return
jeq_else.49756:
	ldi	%g3, %g31, 4
	sub	%g3, %g0, %g3
	return
jeq_else.49742:
	jne	%g6, %g0, jeq_else.49757
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.49758
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.49760
	addi	%g3, %g0, 0
	jmp	jle_cont.49761
jle_else.49760:
	addi	%g3, %g0, 1
jle_cont.49761:
	jmp	jle_cont.49759
jle_else.49758:
	addi	%g3, %g0, 1
jle_cont.49759:
	jne	%g3, %g0, jeq_else.49762
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.49763
	addi	%g3, %g0, 45
	jne	%g4, %g3, jeq_else.49765
	addi	%g3, %g0, -1
	sti	%g3, %g31, 8
	jmp	jeq_cont.49766
jeq_else.49765:
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
jeq_cont.49766:
	jmp	jeq_cont.49764
jeq_else.49763:
jeq_cont.49764:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	jmp	read_int_token.2507
jeq_else.49762:
	addi	%g6, %g0, 0
	jmp	read_int_token.2507
jeq_else.49757:
	ldi	%g3, %g31, 8
	jne	%g3, %g28, jeq_else.49767
	ldi	%g3, %g31, 4
	return
jeq_else.49767:
	ldi	%g3, %g31, 4
	sub	%g3, %g0, %g3
	return

!==============================
! args = [%g6, %g5]
! fargs = []
! use_regs = [%g6, %g5, %g4, %g3, %g27, %f15, %dummy]
! ret type = Int
!================================
read_float_token1.2516:
	input	%g4
	addi	%g3, %g0, 48
	jlt	%g4, %g3, jle_else.49768
	addi	%g3, %g0, 57
	jlt	%g3, %g4, jle_else.49770
	addi	%g3, %g0, 0
	jmp	jle_cont.49771
jle_else.49770:
	addi	%g3, %g0, 1
jle_cont.49771:
	jmp	jle_cont.49769
jle_else.49768:
	addi	%g3, %g0, 1
jle_cont.49769:
	jne	%g3, %g0, jeq_else.49772
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.49773
	addi	%g3, %g0, 45
	jne	%g5, %g3, jeq_else.49775
	addi	%g3, %g0, -1
	sti	%g3, %g31, 24
	jmp	jeq_cont.49776
jeq_else.49775:
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
jeq_cont.49776:
	jmp	jeq_cont.49774
jeq_else.49773:
jeq_cont.49774:
	ldi	%g3, %g31, 12
	slli	%g5, %g3, 3
	slli	%g3, %g3, 1
	add	%g5, %g5, %g3
	subi	%g3, %g4, 48
	add	%g3, %g5, %g3
	sti	%g3, %g31, 12
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.49777
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.49779
	addi	%g3, %g0, 0
	jmp	jle_cont.49780
jle_else.49779:
	addi	%g3, %g0, 1
jle_cont.49780:
	jmp	jle_cont.49778
jle_else.49777:
	addi	%g3, %g0, 1
jle_cont.49778:
	jne	%g3, %g0, jeq_else.49781
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.49782
	addi	%g3, %g0, 45
	jne	%g4, %g3, jeq_else.49784
	addi	%g3, %g0, -1
	sti	%g3, %g31, 24
	jmp	jeq_cont.49785
jeq_else.49784:
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
jeq_cont.49785:
	jmp	jeq_cont.49783
jeq_else.49782:
jeq_cont.49783:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	jmp	read_float_token1.2516
jeq_else.49781:
	mov	%g3, %g5
	return
jeq_else.49772:
	jne	%g6, %g0, jeq_else.49786
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.49787
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.49789
	addi	%g3, %g0, 0
	jmp	jle_cont.49790
jle_else.49789:
	addi	%g3, %g0, 1
jle_cont.49790:
	jmp	jle_cont.49788
jle_else.49787:
	addi	%g3, %g0, 1
jle_cont.49788:
	jne	%g3, %g0, jeq_else.49791
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.49792
	addi	%g3, %g0, 45
	jne	%g4, %g3, jeq_else.49794
	addi	%g3, %g0, -1
	sti	%g3, %g31, 24
	jmp	jeq_cont.49795
jeq_else.49794:
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
jeq_cont.49795:
	jmp	jeq_cont.49793
jeq_else.49792:
jeq_cont.49793:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	jmp	read_float_token1.2516
jeq_else.49791:
	addi	%g6, %g0, 0
	jmp	read_float_token1.2516
jeq_else.49786:
	mov	%g3, %g4
	return

!==============================
! args = [%g4]
! fargs = []
! use_regs = [%g5, %g4, %g3, %g27, %f15, %dummy]
! ret type = Unit
!================================
read_float_token2.2519:
	input	%g3
	addi	%g5, %g0, 48
	jlt	%g3, %g5, jle_else.49796
	addi	%g5, %g0, 57
	jlt	%g5, %g3, jle_else.49798
	addi	%g5, %g0, 0
	jmp	jle_cont.49799
jle_else.49798:
	addi	%g5, %g0, 1
jle_cont.49799:
	jmp	jle_cont.49797
jle_else.49796:
	addi	%g5, %g0, 1
jle_cont.49797:
	jne	%g5, %g0, jeq_else.49800
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.49801
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.49803
	addi	%g4, %g0, 0
	jmp	jle_cont.49804
jle_else.49803:
	addi	%g4, %g0, 1
jle_cont.49804:
	jmp	jle_cont.49802
jle_else.49801:
	addi	%g4, %g0, 1
jle_cont.49802:
	jne	%g4, %g0, jeq_else.49805
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	jmp	read_float_token2.2519
jeq_else.49805:
	return
jeq_else.49800:
	jne	%g4, %g0, jeq_else.49807
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.49808
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.49810
	addi	%g4, %g0, 0
	jmp	jle_cont.49811
jle_else.49810:
	addi	%g4, %g0, 1
jle_cont.49811:
	jmp	jle_cont.49809
jle_else.49808:
	addi	%g4, %g0, 1
jle_cont.49809:
	jne	%g4, %g0, jeq_else.49812
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	jmp	read_float_token2.2519
jeq_else.49812:
	addi	%g4, %g0, 0
	jmp	read_float_token2.2519
jeq_else.49807:
	return

!==============================
! args = [%g4, %g6, %g9, %g10]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g10, %f15]
! ret type = Int
!================================
div_binary_search.2523:
	add	%g3, %g9, %g10
	srli	%g5, %g3, 1
	mul	%g7, %g5, %g6
	sub	%g3, %g10, %g9
	jlt	%g28, %g3, jle_else.49814
	mov	%g3, %g9
	return
jle_else.49814:
	jlt	%g7, %g4, jle_else.49815
	jne	%g7, %g4, jeq_else.49816
	mov	%g3, %g5
	return
jeq_else.49816:
	add	%g3, %g9, %g5
	srli	%g7, %g3, 1
	mul	%g8, %g7, %g6
	sub	%g3, %g5, %g9
	jlt	%g28, %g3, jle_else.49817
	mov	%g3, %g9
	return
jle_else.49817:
	jlt	%g8, %g4, jle_else.49818
	jne	%g8, %g4, jeq_else.49819
	mov	%g3, %g7
	return
jeq_else.49819:
	add	%g3, %g9, %g7
	srli	%g8, %g3, 1
	mul	%g5, %g8, %g6
	sub	%g3, %g7, %g9
	jlt	%g28, %g3, jle_else.49820
	mov	%g3, %g9
	return
jle_else.49820:
	jlt	%g5, %g4, jle_else.49821
	jne	%g5, %g4, jeq_else.49822
	mov	%g3, %g8
	return
jeq_else.49822:
	add	%g3, %g9, %g8
	srli	%g5, %g3, 1
	mul	%g7, %g5, %g6
	sub	%g3, %g8, %g9
	jlt	%g28, %g3, jle_else.49823
	mov	%g3, %g9
	return
jle_else.49823:
	jlt	%g7, %g4, jle_else.49824
	jne	%g7, %g4, jeq_else.49825
	mov	%g3, %g5
	return
jeq_else.49825:
	mov	%g10, %g5
	jmp	div_binary_search.2523
jle_else.49824:
	mov	%g10, %g8
	mov	%g9, %g5
	jmp	div_binary_search.2523
jle_else.49821:
	add	%g3, %g8, %g7
	srli	%g5, %g3, 1
	mul	%g9, %g5, %g6
	sub	%g3, %g7, %g8
	jlt	%g28, %g3, jle_else.49826
	mov	%g3, %g8
	return
jle_else.49826:
	jlt	%g9, %g4, jle_else.49827
	jne	%g9, %g4, jeq_else.49828
	mov	%g3, %g5
	return
jeq_else.49828:
	mov	%g10, %g5
	mov	%g9, %g8
	jmp	div_binary_search.2523
jle_else.49827:
	mov	%g10, %g7
	mov	%g9, %g5
	jmp	div_binary_search.2523
jle_else.49818:
	add	%g3, %g7, %g5
	srli	%g8, %g3, 1
	mul	%g9, %g8, %g6
	sub	%g3, %g5, %g7
	jlt	%g28, %g3, jle_else.49829
	mov	%g3, %g7
	return
jle_else.49829:
	jlt	%g9, %g4, jle_else.49830
	jne	%g9, %g4, jeq_else.49831
	mov	%g3, %g8
	return
jeq_else.49831:
	add	%g3, %g7, %g8
	srli	%g5, %g3, 1
	mul	%g9, %g5, %g6
	sub	%g3, %g8, %g7
	jlt	%g28, %g3, jle_else.49832
	mov	%g3, %g7
	return
jle_else.49832:
	jlt	%g9, %g4, jle_else.49833
	jne	%g9, %g4, jeq_else.49834
	mov	%g3, %g5
	return
jeq_else.49834:
	mov	%g10, %g5
	mov	%g9, %g7
	jmp	div_binary_search.2523
jle_else.49833:
	mov	%g10, %g8
	mov	%g9, %g5
	jmp	div_binary_search.2523
jle_else.49830:
	add	%g3, %g8, %g5
	srli	%g7, %g3, 1
	mul	%g9, %g7, %g6
	sub	%g3, %g5, %g8
	jlt	%g28, %g3, jle_else.49835
	mov	%g3, %g8
	return
jle_else.49835:
	jlt	%g9, %g4, jle_else.49836
	jne	%g9, %g4, jeq_else.49837
	mov	%g3, %g7
	return
jeq_else.49837:
	mov	%g10, %g7
	mov	%g9, %g8
	jmp	div_binary_search.2523
jle_else.49836:
	mov	%g10, %g5
	mov	%g9, %g7
	jmp	div_binary_search.2523
jle_else.49815:
	add	%g3, %g5, %g10
	srli	%g8, %g3, 1
	mul	%g7, %g8, %g6
	sub	%g3, %g10, %g5
	jlt	%g28, %g3, jle_else.49838
	mov	%g3, %g5
	return
jle_else.49838:
	jlt	%g7, %g4, jle_else.49839
	jne	%g7, %g4, jeq_else.49840
	mov	%g3, %g8
	return
jeq_else.49840:
	add	%g3, %g5, %g8
	srli	%g7, %g3, 1
	mul	%g9, %g7, %g6
	sub	%g3, %g8, %g5
	jlt	%g28, %g3, jle_else.49841
	mov	%g3, %g5
	return
jle_else.49841:
	jlt	%g9, %g4, jle_else.49842
	jne	%g9, %g4, jeq_else.49843
	mov	%g3, %g7
	return
jeq_else.49843:
	add	%g3, %g5, %g7
	srli	%g8, %g3, 1
	mul	%g9, %g8, %g6
	sub	%g3, %g7, %g5
	jlt	%g28, %g3, jle_else.49844
	mov	%g3, %g5
	return
jle_else.49844:
	jlt	%g9, %g4, jle_else.49845
	jne	%g9, %g4, jeq_else.49846
	mov	%g3, %g8
	return
jeq_else.49846:
	mov	%g10, %g8
	mov	%g9, %g5
	jmp	div_binary_search.2523
jle_else.49845:
	mov	%g10, %g7
	mov	%g9, %g8
	jmp	div_binary_search.2523
jle_else.49842:
	add	%g3, %g7, %g8
	srli	%g5, %g3, 1
	mul	%g9, %g5, %g6
	sub	%g3, %g8, %g7
	jlt	%g28, %g3, jle_else.49847
	mov	%g3, %g7
	return
jle_else.49847:
	jlt	%g9, %g4, jle_else.49848
	jne	%g9, %g4, jeq_else.49849
	mov	%g3, %g5
	return
jeq_else.49849:
	mov	%g10, %g5
	mov	%g9, %g7
	jmp	div_binary_search.2523
jle_else.49848:
	mov	%g10, %g8
	mov	%g9, %g5
	jmp	div_binary_search.2523
jle_else.49839:
	add	%g3, %g8, %g10
	srli	%g7, %g3, 1
	mul	%g5, %g7, %g6
	sub	%g3, %g10, %g8
	jlt	%g28, %g3, jle_else.49850
	mov	%g3, %g8
	return
jle_else.49850:
	jlt	%g5, %g4, jle_else.49851
	jne	%g5, %g4, jeq_else.49852
	mov	%g3, %g7
	return
jeq_else.49852:
	add	%g3, %g8, %g7
	srli	%g5, %g3, 1
	mul	%g9, %g5, %g6
	sub	%g3, %g7, %g8
	jlt	%g28, %g3, jle_else.49853
	mov	%g3, %g8
	return
jle_else.49853:
	jlt	%g9, %g4, jle_else.49854
	jne	%g9, %g4, jeq_else.49855
	mov	%g3, %g5
	return
jeq_else.49855:
	mov	%g10, %g5
	mov	%g9, %g8
	jmp	div_binary_search.2523
jle_else.49854:
	mov	%g10, %g7
	mov	%g9, %g5
	jmp	div_binary_search.2523
jle_else.49851:
	add	%g3, %g7, %g10
	srli	%g5, %g3, 1
	mul	%g8, %g5, %g6
	sub	%g3, %g10, %g7
	jlt	%g28, %g3, jle_else.49856
	mov	%g3, %g7
	return
jle_else.49856:
	jlt	%g8, %g4, jle_else.49857
	jne	%g8, %g4, jeq_else.49858
	mov	%g3, %g5
	return
jeq_else.49858:
	mov	%g10, %g5
	mov	%g9, %g7
	jmp	div_binary_search.2523
jle_else.49857:
	mov	%g9, %g5
	jmp	div_binary_search.2523

!==============================
! args = [%g4]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g13, %g12, %g11, %g10, %f15, %dummy]
! ret type = Unit
!================================
print_int.2528:
	addi	%g3, %g0, 1000
	jlt	%g4, %g3, jle_else.49859
	return
jle_else.49859:
	jlt	%g4, %g0, jge_else.49861
	addi	%g6, %g0, 100
	addi	%g12, %g0, 0
	addi	%g10, %g0, 10
	addi	%g9, %g0, 5
	addi	%g5, %g0, 500
	sti	%g4, %g1, 0
	jlt	%g5, %g4, jle_else.49862
	jne	%g5, %g4, jeq_else.49864
	addi	%g3, %g0, 5
	jmp	jeq_cont.49865
jeq_else.49864:
	addi	%g11, %g0, 2
	addi	%g5, %g0, 200
	jlt	%g5, %g4, jle_else.49866
	jne	%g5, %g4, jeq_else.49868
	addi	%g3, %g0, 2
	jmp	jeq_cont.49869
jeq_else.49868:
	addi	%g9, %g0, 1
	addi	%g5, %g0, 100
	jlt	%g5, %g4, jle_else.49870
	jne	%g5, %g4, jeq_else.49872
	addi	%g3, %g0, 1
	jmp	jeq_cont.49873
jeq_else.49872:
	mov	%g10, %g9
	mov	%g9, %g12
	subi	%g1, %g1, 8
	call	div_binary_search.2523
	addi	%g1, %g1, 8
jeq_cont.49873:
	jmp	jle_cont.49871
jle_else.49870:
	mov	%g10, %g11
	subi	%g1, %g1, 8
	call	div_binary_search.2523
	addi	%g1, %g1, 8
jle_cont.49871:
jeq_cont.49869:
	jmp	jle_cont.49867
jle_else.49866:
	addi	%g10, %g0, 3
	addi	%g5, %g0, 300
	jlt	%g5, %g4, jle_else.49874
	jne	%g5, %g4, jeq_else.49876
	addi	%g3, %g0, 3
	jmp	jeq_cont.49877
jeq_else.49876:
	mov	%g9, %g11
	subi	%g1, %g1, 8
	call	div_binary_search.2523
	addi	%g1, %g1, 8
jeq_cont.49877:
	jmp	jle_cont.49875
jle_else.49874:
	mov	%g27, %g10
	mov	%g10, %g9
	mov	%g9, %g27
	subi	%g1, %g1, 8
	call	div_binary_search.2523
	addi	%g1, %g1, 8
jle_cont.49875:
jle_cont.49867:
jeq_cont.49865:
	jmp	jle_cont.49863
jle_else.49862:
	addi	%g11, %g0, 7
	addi	%g5, %g0, 700
	jlt	%g5, %g4, jle_else.49878
	jne	%g5, %g4, jeq_else.49880
	addi	%g3, %g0, 7
	jmp	jeq_cont.49881
jeq_else.49880:
	addi	%g10, %g0, 6
	addi	%g5, %g0, 600
	jlt	%g5, %g4, jle_else.49882
	jne	%g5, %g4, jeq_else.49884
	addi	%g3, %g0, 6
	jmp	jeq_cont.49885
jeq_else.49884:
	subi	%g1, %g1, 8
	call	div_binary_search.2523
	addi	%g1, %g1, 8
jeq_cont.49885:
	jmp	jle_cont.49883
jle_else.49882:
	mov	%g9, %g10
	mov	%g10, %g11
	subi	%g1, %g1, 8
	call	div_binary_search.2523
	addi	%g1, %g1, 8
jle_cont.49883:
jeq_cont.49881:
	jmp	jle_cont.49879
jle_else.49878:
	addi	%g9, %g0, 8
	addi	%g5, %g0, 800
	jlt	%g5, %g4, jle_else.49886
	jne	%g5, %g4, jeq_else.49888
	addi	%g3, %g0, 8
	jmp	jeq_cont.49889
jeq_else.49888:
	mov	%g10, %g9
	mov	%g9, %g11
	subi	%g1, %g1, 8
	call	div_binary_search.2523
	addi	%g1, %g1, 8
jeq_cont.49889:
	jmp	jle_cont.49887
jle_else.49886:
	subi	%g1, %g1, 8
	call	div_binary_search.2523
	addi	%g1, %g1, 8
jle_cont.49887:
jle_cont.49879:
jle_cont.49863:
	muli	%g5, %g3, 100
	ldi	%g4, %g1, 0
	sub	%g4, %g4, %g5
	jlt	%g0, %g3, jle_else.49890
	addi	%g13, %g0, 0
	jmp	jle_cont.49891
jle_else.49890:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g13, %g0, 1
jle_cont.49891:
	addi	%g6, %g0, 10
	addi	%g12, %g0, 0
	addi	%g10, %g0, 10
	addi	%g9, %g0, 5
	addi	%g5, %g0, 50
	sti	%g4, %g1, 4
	jlt	%g5, %g4, jle_else.49892
	jne	%g5, %g4, jeq_else.49894
	addi	%g3, %g0, 5
	jmp	jeq_cont.49895
jeq_else.49894:
	addi	%g11, %g0, 2
	addi	%g5, %g0, 20
	jlt	%g5, %g4, jle_else.49896
	jne	%g5, %g4, jeq_else.49898
	addi	%g3, %g0, 2
	jmp	jeq_cont.49899
jeq_else.49898:
	addi	%g9, %g0, 1
	addi	%g5, %g0, 10
	jlt	%g5, %g4, jle_else.49900
	jne	%g5, %g4, jeq_else.49902
	addi	%g3, %g0, 1
	jmp	jeq_cont.49903
jeq_else.49902:
	mov	%g10, %g9
	mov	%g9, %g12
	subi	%g1, %g1, 12
	call	div_binary_search.2523
	addi	%g1, %g1, 12
jeq_cont.49903:
	jmp	jle_cont.49901
jle_else.49900:
	mov	%g10, %g11
	subi	%g1, %g1, 12
	call	div_binary_search.2523
	addi	%g1, %g1, 12
jle_cont.49901:
jeq_cont.49899:
	jmp	jle_cont.49897
jle_else.49896:
	addi	%g10, %g0, 3
	addi	%g5, %g0, 30
	jlt	%g5, %g4, jle_else.49904
	jne	%g5, %g4, jeq_else.49906
	addi	%g3, %g0, 3
	jmp	jeq_cont.49907
jeq_else.49906:
	mov	%g9, %g11
	subi	%g1, %g1, 12
	call	div_binary_search.2523
	addi	%g1, %g1, 12
jeq_cont.49907:
	jmp	jle_cont.49905
jle_else.49904:
	mov	%g27, %g10
	mov	%g10, %g9
	mov	%g9, %g27
	subi	%g1, %g1, 12
	call	div_binary_search.2523
	addi	%g1, %g1, 12
jle_cont.49905:
jle_cont.49897:
jeq_cont.49895:
	jmp	jle_cont.49893
jle_else.49892:
	addi	%g11, %g0, 7
	addi	%g5, %g0, 70
	jlt	%g5, %g4, jle_else.49908
	jne	%g5, %g4, jeq_else.49910
	addi	%g3, %g0, 7
	jmp	jeq_cont.49911
jeq_else.49910:
	addi	%g10, %g0, 6
	addi	%g5, %g0, 60
	jlt	%g5, %g4, jle_else.49912
	jne	%g5, %g4, jeq_else.49914
	addi	%g3, %g0, 6
	jmp	jeq_cont.49915
jeq_else.49914:
	subi	%g1, %g1, 12
	call	div_binary_search.2523
	addi	%g1, %g1, 12
jeq_cont.49915:
	jmp	jle_cont.49913
jle_else.49912:
	mov	%g9, %g10
	mov	%g10, %g11
	subi	%g1, %g1, 12
	call	div_binary_search.2523
	addi	%g1, %g1, 12
jle_cont.49913:
jeq_cont.49911:
	jmp	jle_cont.49909
jle_else.49908:
	addi	%g9, %g0, 8
	addi	%g5, %g0, 80
	jlt	%g5, %g4, jle_else.49916
	jne	%g5, %g4, jeq_else.49918
	addi	%g3, %g0, 8
	jmp	jeq_cont.49919
jeq_else.49918:
	mov	%g10, %g9
	mov	%g9, %g11
	subi	%g1, %g1, 12
	call	div_binary_search.2523
	addi	%g1, %g1, 12
jeq_cont.49919:
	jmp	jle_cont.49917
jle_else.49916:
	subi	%g1, %g1, 12
	call	div_binary_search.2523
	addi	%g1, %g1, 12
jle_cont.49917:
jle_cont.49909:
jle_cont.49893:
	muli	%g5, %g3, 10
	ldi	%g4, %g1, 4
	sub	%g4, %g4, %g5
	jlt	%g0, %g3, jle_else.49920
	jne	%g13, %g0, jeq_else.49922
	addi	%g5, %g0, 0
	jmp	jeq_cont.49923
jeq_else.49922:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g5, %g0, 1
jeq_cont.49923:
	jmp	jle_cont.49921
jle_else.49920:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g5, %g0, 1
jle_cont.49921:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g4
	output	%g3
	return
jge_else.49861:
	addi	%g3, %g0, 45
	output	%g3
	sub	%g4, %g0, %g4
	jmp	print_int.2528

!==============================
! args = [%g16]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g2, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f29, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
read_object.2696:
	addi	%g3, %g0, 60
	jlt	%g16, %g3, jle_else.49924
	return
jle_else.49924:
	addi	%g3, %g0, 0
	sti	%g3, %g31, 4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 8
	input	%g5
	addi	%g14, %g0, 48
	jlt	%g5, %g14, jle_else.49926
	addi	%g14, %g0, 57
	jlt	%g14, %g5, jle_else.49928
	addi	%g14, %g0, 0
	jmp	jle_cont.49929
jle_else.49928:
	addi	%g14, %g0, 1
jle_cont.49929:
	jmp	jle_cont.49927
jle_else.49926:
	addi	%g14, %g0, 1
jle_cont.49927:
	jne	%g14, %g0, jeq_else.49930
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.49932
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
	jmp	jeq_cont.49933
jeq_else.49932:
jeq_cont.49933:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g14, %g3
	jmp	jeq_cont.49931
jeq_else.49930:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g14, %g3
jeq_cont.49931:
	jne	%g14, %g29, jeq_else.49934
	addi	%g3, %g0, 0
	jmp	jeq_cont.49935
jeq_else.49934:
	addi	%g3, %g0, 0
	sti	%g3, %g31, 4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 8
	input	%g5
	addi	%g11, %g0, 48
	jlt	%g5, %g11, jle_else.49936
	addi	%g11, %g0, 57
	jlt	%g11, %g5, jle_else.49938
	addi	%g11, %g0, 0
	jmp	jle_cont.49939
jle_else.49938:
	addi	%g11, %g0, 1
jle_cont.49939:
	jmp	jle_cont.49937
jle_else.49936:
	addi	%g11, %g0, 1
jle_cont.49937:
	jne	%g11, %g0, jeq_else.49940
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.49942
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
	jmp	jeq_cont.49943
jeq_else.49942:
jeq_cont.49943:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g11, %g3
	jmp	jeq_cont.49941
jeq_else.49940:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g11, %g3
jeq_cont.49941:
	addi	%g3, %g0, 0
	sti	%g3, %g31, 4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 8
	input	%g5
	addi	%g15, %g0, 48
	jlt	%g5, %g15, jle_else.49944
	addi	%g15, %g0, 57
	jlt	%g15, %g5, jle_else.49946
	addi	%g15, %g0, 0
	jmp	jle_cont.49947
jle_else.49946:
	addi	%g15, %g0, 1
jle_cont.49947:
	jmp	jle_cont.49945
jle_else.49944:
	addi	%g15, %g0, 1
jle_cont.49945:
	jne	%g15, %g0, jeq_else.49948
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.49950
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
	jmp	jeq_cont.49951
jeq_else.49950:
jeq_cont.49951:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g15, %g3
	jmp	jeq_cont.49949
jeq_else.49948:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g15, %g3
jeq_cont.49949:
	addi	%g3, %g0, 0
	sti	%g3, %g31, 4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 8
	input	%g5
	addi	%g13, %g0, 48
	jlt	%g5, %g13, jle_else.49952
	addi	%g13, %g0, 57
	jlt	%g13, %g5, jle_else.49954
	addi	%g13, %g0, 0
	jmp	jle_cont.49955
jle_else.49954:
	addi	%g13, %g0, 1
jle_cont.49955:
	jmp	jle_cont.49953
jle_else.49952:
	addi	%g13, %g0, 1
jle_cont.49953:
	jne	%g13, %g0, jeq_else.49956
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.49958
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
	jmp	jeq_cont.49959
jeq_else.49958:
jeq_cont.49959:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g13, %g3
	jmp	jeq_cont.49957
jeq_else.49956:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g13, %g3
jeq_cont.49957:
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	mov	%g8, %g3
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.49960
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.49962
	addi	%g3, %g0, 0
	jmp	jle_cont.49963
jle_else.49962:
	addi	%g3, %g0, 1
jle_cont.49963:
	jmp	jle_cont.49961
jle_else.49960:
	addi	%g3, %g0, 1
jle_cont.49961:
	jne	%g3, %g0, jeq_else.49964
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.49966
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.49967
jeq_else.49966:
jeq_cont.49967:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.49965
jeq_else.49964:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.49965:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.49968
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.49970
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.49972
	addi	%g4, %g0, 0
	jmp	jle_cont.49973
jle_else.49972:
	addi	%g4, %g0, 1
jle_cont.49973:
	jmp	jle_cont.49971
jle_else.49970:
	addi	%g4, %g0, 1
jle_cont.49971:
	jne	%g4, %g0, jeq_else.49974
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.49975
jeq_else.49974:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.49975:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f4, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f4, %f0
	jmp	jeq_cont.49969
jeq_else.49968:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.49969:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.49976
	fmov	%f1, %f0
	jmp	jeq_cont.49977
jeq_else.49976:
	fneg	%f1, %f0
jeq_cont.49977:
	fsti	%f1, %g8, 0
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.49978
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.49980
	addi	%g3, %g0, 0
	jmp	jle_cont.49981
jle_else.49980:
	addi	%g3, %g0, 1
jle_cont.49981:
	jmp	jle_cont.49979
jle_else.49978:
	addi	%g3, %g0, 1
jle_cont.49979:
	jne	%g3, %g0, jeq_else.49982
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.49984
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.49985
jeq_else.49984:
jeq_cont.49985:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.49983
jeq_else.49982:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.49983:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.49986
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.49988
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.49990
	addi	%g4, %g0, 0
	jmp	jle_cont.49991
jle_else.49990:
	addi	%g4, %g0, 1
jle_cont.49991:
	jmp	jle_cont.49989
jle_else.49988:
	addi	%g4, %g0, 1
jle_cont.49989:
	jne	%g4, %g0, jeq_else.49992
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.49993
jeq_else.49992:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.49993:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f4, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f4, %f0
	jmp	jeq_cont.49987
jeq_else.49986:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.49987:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.49994
	fmov	%f1, %f0
	jmp	jeq_cont.49995
jeq_else.49994:
	fneg	%f1, %f0
jeq_cont.49995:
	fsti	%f1, %g8, -4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.49996
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.49998
	addi	%g3, %g0, 0
	jmp	jle_cont.49999
jle_else.49998:
	addi	%g3, %g0, 1
jle_cont.49999:
	jmp	jle_cont.49997
jle_else.49996:
	addi	%g3, %g0, 1
jle_cont.49997:
	jne	%g3, %g0, jeq_else.50000
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.50002
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.50003
jeq_else.50002:
jeq_cont.50003:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.50001
jeq_else.50000:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.50001:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.50004
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.50006
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.50008
	addi	%g4, %g0, 0
	jmp	jle_cont.50009
jle_else.50008:
	addi	%g4, %g0, 1
jle_cont.50009:
	jmp	jle_cont.50007
jle_else.50006:
	addi	%g4, %g0, 1
jle_cont.50007:
	jne	%g4, %g0, jeq_else.50010
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.50011
jeq_else.50010:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.50011:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f4, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f4, %f0
	jmp	jeq_cont.50005
jeq_else.50004:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.50005:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.50012
	fmov	%f1, %f0
	jmp	jeq_cont.50013
jeq_else.50012:
	fneg	%f1, %f0
jeq_cont.50013:
	fsti	%f1, %g8, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	mov	%g12, %g3
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.50014
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.50016
	addi	%g3, %g0, 0
	jmp	jle_cont.50017
jle_else.50016:
	addi	%g3, %g0, 1
jle_cont.50017:
	jmp	jle_cont.50015
jle_else.50014:
	addi	%g3, %g0, 1
jle_cont.50015:
	jne	%g3, %g0, jeq_else.50018
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.50020
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.50021
jeq_else.50020:
jeq_cont.50021:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.50019
jeq_else.50018:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.50019:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.50022
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.50024
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.50026
	addi	%g4, %g0, 0
	jmp	jle_cont.50027
jle_else.50026:
	addi	%g4, %g0, 1
jle_cont.50027:
	jmp	jle_cont.50025
jle_else.50024:
	addi	%g4, %g0, 1
jle_cont.50025:
	jne	%g4, %g0, jeq_else.50028
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.50029
jeq_else.50028:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.50029:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f4, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f4, %f0
	jmp	jeq_cont.50023
jeq_else.50022:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.50023:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.50030
	fmov	%f1, %f0
	jmp	jeq_cont.50031
jeq_else.50030:
	fneg	%f1, %f0
jeq_cont.50031:
	fsti	%f1, %g12, 0
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.50032
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.50034
	addi	%g3, %g0, 0
	jmp	jle_cont.50035
jle_else.50034:
	addi	%g3, %g0, 1
jle_cont.50035:
	jmp	jle_cont.50033
jle_else.50032:
	addi	%g3, %g0, 1
jle_cont.50033:
	jne	%g3, %g0, jeq_else.50036
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.50038
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.50039
jeq_else.50038:
jeq_cont.50039:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.50037
jeq_else.50036:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.50037:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.50040
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.50042
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.50044
	addi	%g4, %g0, 0
	jmp	jle_cont.50045
jle_else.50044:
	addi	%g4, %g0, 1
jle_cont.50045:
	jmp	jle_cont.50043
jle_else.50042:
	addi	%g4, %g0, 1
jle_cont.50043:
	jne	%g4, %g0, jeq_else.50046
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.50047
jeq_else.50046:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.50047:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f4, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f4, %f0
	jmp	jeq_cont.50041
jeq_else.50040:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.50041:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.50048
	fmov	%f1, %f0
	jmp	jeq_cont.50049
jeq_else.50048:
	fneg	%f1, %f0
jeq_cont.50049:
	fsti	%f1, %g12, -4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.50050
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.50052
	addi	%g3, %g0, 0
	jmp	jle_cont.50053
jle_else.50052:
	addi	%g3, %g0, 1
jle_cont.50053:
	jmp	jle_cont.50051
jle_else.50050:
	addi	%g3, %g0, 1
jle_cont.50051:
	jne	%g3, %g0, jeq_else.50054
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.50056
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.50057
jeq_else.50056:
jeq_cont.50057:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.50055
jeq_else.50054:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.50055:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.50058
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.50060
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.50062
	addi	%g4, %g0, 0
	jmp	jle_cont.50063
jle_else.50062:
	addi	%g4, %g0, 1
jle_cont.50063:
	jmp	jle_cont.50061
jle_else.50060:
	addi	%g4, %g0, 1
jle_cont.50061:
	jne	%g4, %g0, jeq_else.50064
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.50065
jeq_else.50064:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.50065:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f4, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f4, %f0
	jmp	jeq_cont.50059
jeq_else.50058:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.50059:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.50066
	fmov	%f1, %f0
	jmp	jeq_cont.50067
jeq_else.50066:
	fneg	%f1, %f0
jeq_cont.50067:
	fsti	%f1, %g12, -8
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.50068
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.50070
	addi	%g3, %g0, 0
	jmp	jle_cont.50071
jle_else.50070:
	addi	%g3, %g0, 1
jle_cont.50071:
	jmp	jle_cont.50069
jle_else.50068:
	addi	%g3, %g0, 1
jle_cont.50069:
	jne	%g3, %g0, jeq_else.50072
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.50074
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.50075
jeq_else.50074:
jeq_cont.50075:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.50073
jeq_else.50072:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.50073:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.50076
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.50078
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.50080
	addi	%g4, %g0, 0
	jmp	jle_cont.50081
jle_else.50080:
	addi	%g4, %g0, 1
jle_cont.50081:
	jmp	jle_cont.50079
jle_else.50078:
	addi	%g4, %g0, 1
jle_cont.50079:
	jne	%g4, %g0, jeq_else.50082
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.50083
jeq_else.50082:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.50083:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f4, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f4, %f0
	jmp	jeq_cont.50077
jeq_else.50076:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.50077:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.50084
	fmov	%f4, %f0
	jmp	jeq_cont.50085
jeq_else.50084:
	fneg	%f4, %f0
jeq_cont.50085:
	addi	%g3, %g0, 2
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	mov	%g10, %g3
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.50086
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.50088
	addi	%g3, %g0, 0
	jmp	jle_cont.50089
jle_else.50088:
	addi	%g3, %g0, 1
jle_cont.50089:
	jmp	jle_cont.50087
jle_else.50086:
	addi	%g3, %g0, 1
jle_cont.50087:
	jne	%g3, %g0, jeq_else.50090
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.50092
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.50093
jeq_else.50092:
jeq_cont.50093:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.50091
jeq_else.50090:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.50091:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.50094
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.50096
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.50098
	addi	%g4, %g0, 0
	jmp	jle_cont.50099
jle_else.50098:
	addi	%g4, %g0, 1
jle_cont.50099:
	jmp	jle_cont.50097
jle_else.50096:
	addi	%g4, %g0, 1
jle_cont.50097:
	jne	%g4, %g0, jeq_else.50100
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.50101
jeq_else.50100:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.50101:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f5, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f5, %f0
	jmp	jeq_cont.50095
jeq_else.50094:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.50095:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.50102
	fmov	%f1, %f0
	jmp	jeq_cont.50103
jeq_else.50102:
	fneg	%f1, %f0
jeq_cont.50103:
	fsti	%f1, %g10, 0
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.50104
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.50106
	addi	%g3, %g0, 0
	jmp	jle_cont.50107
jle_else.50106:
	addi	%g3, %g0, 1
jle_cont.50107:
	jmp	jle_cont.50105
jle_else.50104:
	addi	%g3, %g0, 1
jle_cont.50105:
	jne	%g3, %g0, jeq_else.50108
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.50110
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.50111
jeq_else.50110:
jeq_cont.50111:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.50109
jeq_else.50108:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.50109:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.50112
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.50114
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.50116
	addi	%g4, %g0, 0
	jmp	jle_cont.50117
jle_else.50116:
	addi	%g4, %g0, 1
jle_cont.50117:
	jmp	jle_cont.50115
jle_else.50114:
	addi	%g4, %g0, 1
jle_cont.50115:
	jne	%g4, %g0, jeq_else.50118
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.50119
jeq_else.50118:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.50119:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f5, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f5, %f0
	jmp	jeq_cont.50113
jeq_else.50112:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.50113:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.50120
	fmov	%f1, %f0
	jmp	jeq_cont.50121
jeq_else.50120:
	fneg	%f1, %f0
jeq_cont.50121:
	fsti	%f1, %g10, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	mov	%g9, %g3
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.50122
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.50124
	addi	%g3, %g0, 0
	jmp	jle_cont.50125
jle_else.50124:
	addi	%g3, %g0, 1
jle_cont.50125:
	jmp	jle_cont.50123
jle_else.50122:
	addi	%g3, %g0, 1
jle_cont.50123:
	jne	%g3, %g0, jeq_else.50126
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.50128
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.50129
jeq_else.50128:
jeq_cont.50129:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.50127
jeq_else.50126:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.50127:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.50130
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.50132
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.50134
	addi	%g4, %g0, 0
	jmp	jle_cont.50135
jle_else.50134:
	addi	%g4, %g0, 1
jle_cont.50135:
	jmp	jle_cont.50133
jle_else.50132:
	addi	%g4, %g0, 1
jle_cont.50133:
	jne	%g4, %g0, jeq_else.50136
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.50137
jeq_else.50136:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.50137:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f5, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f5, %f0
	jmp	jeq_cont.50131
jeq_else.50130:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.50131:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.50138
	fmov	%f1, %f0
	jmp	jeq_cont.50139
jeq_else.50138:
	fneg	%f1, %f0
jeq_cont.50139:
	fsti	%f1, %g9, 0
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.50140
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.50142
	addi	%g3, %g0, 0
	jmp	jle_cont.50143
jle_else.50142:
	addi	%g3, %g0, 1
jle_cont.50143:
	jmp	jle_cont.50141
jle_else.50140:
	addi	%g3, %g0, 1
jle_cont.50141:
	jne	%g3, %g0, jeq_else.50144
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.50146
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.50147
jeq_else.50146:
jeq_cont.50147:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.50145
jeq_else.50144:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.50145:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.50148
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.50150
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.50152
	addi	%g4, %g0, 0
	jmp	jle_cont.50153
jle_else.50152:
	addi	%g4, %g0, 1
jle_cont.50153:
	jmp	jle_cont.50151
jle_else.50150:
	addi	%g4, %g0, 1
jle_cont.50151:
	jne	%g4, %g0, jeq_else.50154
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.50155
jeq_else.50154:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.50155:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f5, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f5, %f0
	jmp	jeq_cont.50149
jeq_else.50148:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.50149:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.50156
	fmov	%f1, %f0
	jmp	jeq_cont.50157
jeq_else.50156:
	fneg	%f1, %f0
jeq_cont.50157:
	fsti	%f1, %g9, -4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.50158
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.50160
	addi	%g3, %g0, 0
	jmp	jle_cont.50161
jle_else.50160:
	addi	%g3, %g0, 1
jle_cont.50161:
	jmp	jle_cont.50159
jle_else.50158:
	addi	%g3, %g0, 1
jle_cont.50159:
	jne	%g3, %g0, jeq_else.50162
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.50164
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.50165
jeq_else.50164:
jeq_cont.50165:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.50163
jeq_else.50162:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.50163:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.50166
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.50168
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.50170
	addi	%g4, %g0, 0
	jmp	jle_cont.50171
jle_else.50170:
	addi	%g4, %g0, 1
jle_cont.50171:
	jmp	jle_cont.50169
jle_else.50168:
	addi	%g4, %g0, 1
jle_cont.50169:
	jne	%g4, %g0, jeq_else.50172
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.50173
jeq_else.50172:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.50173:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f5, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f5, %f0
	jmp	jeq_cont.50167
jeq_else.50166:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.50167:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.50174
	fmov	%f1, %f0
	jmp	jeq_cont.50175
jeq_else.50174:
	fneg	%f1, %f0
jeq_cont.50175:
	fsti	%f1, %g9, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	mov	%g7, %g3
	jne	%g13, %g0, jeq_else.50176
	jmp	jeq_cont.50177
jeq_else.50176:
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.50178
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.50180
	addi	%g3, %g0, 0
	jmp	jle_cont.50181
jle_else.50180:
	addi	%g3, %g0, 1
jle_cont.50181:
	jmp	jle_cont.50179
jle_else.50178:
	addi	%g3, %g0, 1
jle_cont.50179:
	jne	%g3, %g0, jeq_else.50182
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.50184
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.50185
jeq_else.50184:
jeq_cont.50185:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.50183
jeq_else.50182:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.50183:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.50186
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.50188
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.50190
	addi	%g4, %g0, 0
	jmp	jle_cont.50191
jle_else.50190:
	addi	%g4, %g0, 1
jle_cont.50191:
	jmp	jle_cont.50189
jle_else.50188:
	addi	%g4, %g0, 1
jle_cont.50189:
	jne	%g4, %g0, jeq_else.50192
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.50193
jeq_else.50192:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.50193:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f5, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f3, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f5, %f0
	jmp	jeq_cont.50187
jeq_else.50186:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.50187:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.50194
	fmov	%f1, %f0
	jmp	jeq_cont.50195
jeq_else.50194:
	fneg	%f1, %f0
jeq_cont.50195:
	setL %g3, l.42507
	fldi	%f3, %g3, 0
	fmul	%f0, %f1, %f3
	fsti	%f0, %g7, 0
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.50196
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.50198
	addi	%g3, %g0, 0
	jmp	jle_cont.50199
jle_else.50198:
	addi	%g3, %g0, 1
jle_cont.50199:
	jmp	jle_cont.50197
jle_else.50196:
	addi	%g3, %g0, 1
jle_cont.50197:
	jne	%g3, %g0, jeq_else.50200
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.50202
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.50203
jeq_else.50202:
jeq_cont.50203:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.50201
jeq_else.50200:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.50201:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.50204
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.50206
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.50208
	addi	%g4, %g0, 0
	jmp	jle_cont.50209
jle_else.50208:
	addi	%g4, %g0, 1
jle_cont.50209:
	jmp	jle_cont.50207
jle_else.50206:
	addi	%g4, %g0, 1
jle_cont.50207:
	jne	%g4, %g0, jeq_else.50210
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.50211
jeq_else.50210:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.50211:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f6, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f5, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f5, %f0
	fadd	%f0, %f6, %f0
	jmp	jeq_cont.50205
jeq_else.50204:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.50205:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.50212
	fmov	%f1, %f0
	jmp	jeq_cont.50213
jeq_else.50212:
	fneg	%f1, %f0
jeq_cont.50213:
	fmul	%f0, %f1, %f3
	fsti	%f0, %g7, -4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 12
	addi	%g3, %g0, 0
	sti	%g3, %g31, 16
	addi	%g3, %g0, 1
	sti	%g3, %g31, 20
	addi	%g3, %g0, 0
	sti	%g3, %g31, 24
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.50214
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.50216
	addi	%g3, %g0, 0
	jmp	jle_cont.50217
jle_else.50216:
	addi	%g3, %g0, 1
jle_cont.50217:
	jmp	jle_cont.50215
jle_else.50214:
	addi	%g3, %g0, 1
jle_cont.50215:
	jne	%g3, %g0, jeq_else.50218
	ldi	%g3, %g31, 24
	jne	%g3, %g0, jeq_else.50220
	addi	%g3, %g0, 1
	sti	%g3, %g31, 24
	jmp	jeq_cont.50221
jeq_else.50220:
jeq_cont.50221:
	ldi	%g3, %g31, 12
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 12
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
	jmp	jeq_cont.50219
jeq_else.50218:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token1.2516
	addi	%g1, %g1, 4
jeq_cont.50219:
	addi	%g4, %g0, 46
	jne	%g3, %g4, jeq_else.50222
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.50224
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.50226
	addi	%g4, %g0, 0
	jmp	jle_cont.50227
jle_else.50226:
	addi	%g4, %g0, 1
jle_cont.50227:
	jmp	jle_cont.50225
jle_else.50224:
	addi	%g4, %g0, 1
jle_cont.50225:
	jne	%g4, %g0, jeq_else.50228
	ldi	%g4, %g31, 16
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 16
	ldi	%g3, %g31, 20
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	sti	%g3, %g31, 20
	addi	%g4, %g0, 1
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
	jmp	jeq_cont.50229
jeq_else.50228:
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	read_float_token2.2519
	addi	%g1, %g1, 4
jeq_cont.50229:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	fmov	%f6, %f0
	ldi	%g3, %g31, 16
	call	min_caml_float_of_int
	fmov	%f5, %f0
	ldi	%g3, %g31, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fdiv	%f0, %f5, %f0
	fadd	%f0, %f6, %f0
	jmp	jeq_cont.50223
jeq_else.50222:
	ldi	%g3, %g31, 12
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
jeq_cont.50223:
	ldi	%g3, %g31, 24
	jne	%g3, %g28, jeq_else.50230
	fmov	%f1, %f0
	jmp	jeq_cont.50231
jeq_else.50230:
	fneg	%f1, %f0
jeq_cont.50231:
	fmul	%f0, %f1, %f3
	fsti	%f0, %g7, -8
jeq_cont.50177:
	addi	%g5, %g0, 2
	jne	%g11, %g5, jeq_else.50232
	addi	%g5, %g0, 1
	jmp	jeq_cont.50233
jeq_else.50232:
	fjlt	%f4, %f16, fjge_else.50234
	addi	%g5, %g0, 0
	jmp	fjge_cont.50235
fjge_else.50234:
	addi	%g5, %g0, 1
fjge_cont.50235:
jeq_cont.50233:
	addi	%g3, %g0, 4
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	mov	%g4, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 44
	sti	%g4, %g3, -40
	sti	%g7, %g3, -36
	sti	%g9, %g3, -32
	sti	%g10, %g3, -28
	sti	%g5, %g3, -24
	sti	%g12, %g3, -20
	sti	%g8, %g3, -16
	sti	%g13, %g3, -12
	sti	%g15, %g3, -8
	sti	%g11, %g3, -4
	sti	%g14, %g3, 0
	slli	%g4, %g16, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 272
	addi	%g3, %g0, 3
	jne	%g11, %g3, jeq_else.50236
	fldi	%f1, %g8, 0
	fjeq	%f1, %f16, fjne_else.50238
	fjeq	%f1, %f16, fjne_else.50240
	fjlt	%f16, %f1, fjge_else.50242
	setL %g3, l.43536
	fldi	%f0, %g3, 0
	jmp	fjge_cont.50243
fjge_else.50242:
	setL %g3, l.42509
	fldi	%f0, %g3, 0
fjge_cont.50243:
	jmp	fjne_cont.50241
fjne_else.50240:
	fmov	%f0, %f16
fjne_cont.50241:
	fmul	%f1, %f1, %f1
	fdiv	%f0, %f0, %f1
	jmp	fjne_cont.50239
fjne_else.50238:
	fmov	%f0, %f16
fjne_cont.50239:
	fsti	%f0, %g8, 0
	fldi	%f1, %g8, -4
	fjeq	%f1, %f16, fjne_else.50244
	fjeq	%f1, %f16, fjne_else.50246
	fjlt	%f16, %f1, fjge_else.50248
	setL %g3, l.43536
	fldi	%f0, %g3, 0
	jmp	fjge_cont.50249
fjge_else.50248:
	setL %g3, l.42509
	fldi	%f0, %g3, 0
fjge_cont.50249:
	jmp	fjne_cont.50247
fjne_else.50246:
	fmov	%f0, %f16
fjne_cont.50247:
	fmul	%f1, %f1, %f1
	fdiv	%f0, %f0, %f1
	jmp	fjne_cont.50245
fjne_else.50244:
	fmov	%f0, %f16
fjne_cont.50245:
	fsti	%f0, %g8, -4
	fldi	%f1, %g8, -8
	fjeq	%f1, %f16, fjne_else.50250
	fjeq	%f1, %f16, fjne_else.50252
	fjlt	%f16, %f1, fjge_else.50254
	setL %g3, l.43536
	fldi	%f0, %g3, 0
	jmp	fjge_cont.50255
fjge_else.50254:
	setL %g3, l.42509
	fldi	%f0, %g3, 0
fjge_cont.50255:
	jmp	fjne_cont.50253
fjne_else.50252:
	fmov	%f0, %f16
fjne_cont.50253:
	fmul	%f1, %f1, %f1
	fdiv	%f0, %f0, %f1
	jmp	fjne_cont.50251
fjne_else.50250:
	fmov	%f0, %f16
fjne_cont.50251:
	fsti	%f0, %g8, -8
	jmp	jeq_cont.50237
jeq_else.50236:
	addi	%g3, %g0, 2
	jne	%g11, %g3, jeq_else.50256
	fldi	%f1, %g8, 0
	fmul	%f2, %f1, %f1
	fldi	%f0, %g8, -4
	fmul	%f0, %f0, %f0
	fadd	%f2, %f2, %f0
	fldi	%f0, %g8, -8
	fmul	%f0, %f0, %f0
	fadd	%f0, %f2, %f0
	fsqrt	%f2, %f0
	fjeq	%f2, %f16, fjne_else.50258
	fjlt	%f4, %f16, fjge_else.50260
	fdiv	%f0, %f20, %f2
	jmp	fjge_cont.50261
fjge_else.50260:
	fdiv	%f0, %f17, %f2
fjge_cont.50261:
	jmp	fjne_cont.50259
fjne_else.50258:
	setL %g3, l.42509
	fldi	%f0, %g3, 0
fjne_cont.50259:
	fmul	%f1, %f1, %f0
	fsti	%f1, %g8, 0
	fldi	%f1, %g8, -4
	fmul	%f1, %f1, %f0
	fsti	%f1, %g8, -4
	fldi	%f1, %g8, -8
	fmul	%f0, %f1, %f0
	fsti	%f0, %g8, -8
	jmp	jeq_cont.50257
jeq_else.50256:
jeq_cont.50257:
jeq_cont.50237:
	jne	%g13, %g0, jeq_else.50262
	jmp	jeq_cont.50263
jeq_else.50262:
	fldi	%f3, %g7, 0
	fsub	%f2, %f22, %f3
	setL %g3, l.42247
	fldi	%f4, %g3, 0
	setL %g3, l.42249
	fldi	%f14, %g3, 0
	fjlt	%f2, %f16, fjge_else.50264
	fmov	%f1, %f2
	jmp	fjge_cont.50265
fjge_else.50264:
	fneg	%f1, %f2
fjge_cont.50265:
	fjlt	%f29, %f1, fjge_else.50266
	fjlt	%f1, %f16, fjge_else.50268
	fmov	%f0, %f1
	jmp	fjge_cont.50269
fjge_else.50268:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50270
	fjlt	%f1, %f16, fjge_else.50272
	fmov	%f0, %f1
	jmp	fjge_cont.50273
fjge_else.50272:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50274
	fjlt	%f1, %f16, fjge_else.50276
	fmov	%f0, %f1
	jmp	fjge_cont.50277
fjge_else.50276:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.50277:
	jmp	fjge_cont.50275
fjge_else.50274:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.50275:
fjge_cont.50273:
	jmp	fjge_cont.50271
fjge_else.50270:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50278
	fjlt	%f1, %f16, fjge_else.50280
	fmov	%f0, %f1
	jmp	fjge_cont.50281
fjge_else.50280:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.50281:
	jmp	fjge_cont.50279
fjge_else.50278:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.50279:
fjge_cont.50271:
fjge_cont.50269:
	jmp	fjge_cont.50267
fjge_else.50266:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50282
	fjlt	%f1, %f16, fjge_else.50284
	fmov	%f0, %f1
	jmp	fjge_cont.50285
fjge_else.50284:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50286
	fjlt	%f1, %f16, fjge_else.50288
	fmov	%f0, %f1
	jmp	fjge_cont.50289
fjge_else.50288:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.50289:
	jmp	fjge_cont.50287
fjge_else.50286:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.50287:
fjge_cont.50285:
	jmp	fjge_cont.50283
fjge_else.50282:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50290
	fjlt	%f1, %f16, fjge_else.50292
	fmov	%f0, %f1
	jmp	fjge_cont.50293
fjge_else.50292:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.50293:
	jmp	fjge_cont.50291
fjge_else.50290:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.50291:
fjge_cont.50283:
fjge_cont.50267:
	fjlt	%f4, %f0, fjge_else.50294
	fjlt	%f16, %f2, fjge_else.50296
	addi	%g3, %g0, 0
	jmp	fjge_cont.50297
fjge_else.50296:
	addi	%g3, %g0, 1
fjge_cont.50297:
	jmp	fjge_cont.50295
fjge_else.50294:
	fjlt	%f16, %f2, fjge_else.50298
	addi	%g3, %g0, 1
	jmp	fjge_cont.50299
fjge_else.50298:
	addi	%g3, %g0, 0
fjge_cont.50299:
fjge_cont.50295:
	fjlt	%f4, %f0, fjge_else.50300
	fmov	%f1, %f0
	jmp	fjge_cont.50301
fjge_else.50300:
	fsub	%f1, %f29, %f0
fjge_cont.50301:
	fjlt	%f22, %f1, fjge_else.50302
	fmov	%f0, %f1
	jmp	fjge_cont.50303
fjge_else.50302:
	fsub	%f0, %f4, %f1
fjge_cont.50303:
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
	jne	%g3, %g0, jeq_else.50304
	fneg	%f15, %f0
	jmp	jeq_cont.50305
jeq_else.50304:
	fmov	%f15, %f0
jeq_cont.50305:
	fjlt	%f3, %f16, fjge_else.50306
	fmov	%f1, %f3
	jmp	fjge_cont.50307
fjge_else.50306:
	fneg	%f1, %f3
fjge_cont.50307:
	fsti	%f15, %g1, 0
	fjlt	%f29, %f1, fjge_else.50308
	fjlt	%f1, %f16, fjge_else.50310
	fmov	%f0, %f1
	jmp	fjge_cont.50311
fjge_else.50310:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50312
	fjlt	%f1, %f16, fjge_else.50314
	fmov	%f0, %f1
	jmp	fjge_cont.50315
fjge_else.50314:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50316
	fjlt	%f1, %f16, fjge_else.50318
	fmov	%f0, %f1
	jmp	fjge_cont.50319
fjge_else.50318:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50319:
	jmp	fjge_cont.50317
fjge_else.50316:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50317:
fjge_cont.50315:
	jmp	fjge_cont.50313
fjge_else.50312:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50320
	fjlt	%f1, %f16, fjge_else.50322
	fmov	%f0, %f1
	jmp	fjge_cont.50323
fjge_else.50322:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50323:
	jmp	fjge_cont.50321
fjge_else.50320:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50321:
fjge_cont.50313:
fjge_cont.50311:
	jmp	fjge_cont.50309
fjge_else.50308:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50324
	fjlt	%f1, %f16, fjge_else.50326
	fmov	%f0, %f1
	jmp	fjge_cont.50327
fjge_else.50326:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50328
	fjlt	%f1, %f16, fjge_else.50330
	fmov	%f0, %f1
	jmp	fjge_cont.50331
fjge_else.50330:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50331:
	jmp	fjge_cont.50329
fjge_else.50328:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50329:
fjge_cont.50327:
	jmp	fjge_cont.50325
fjge_else.50324:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50332
	fjlt	%f1, %f16, fjge_else.50334
	fmov	%f0, %f1
	jmp	fjge_cont.50335
fjge_else.50334:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50335:
	jmp	fjge_cont.50333
fjge_else.50332:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50333:
fjge_cont.50325:
fjge_cont.50309:
	fjlt	%f4, %f0, fjge_else.50336
	fjlt	%f16, %f3, fjge_else.50338
	addi	%g3, %g0, 0
	jmp	fjge_cont.50339
fjge_else.50338:
	addi	%g3, %g0, 1
fjge_cont.50339:
	jmp	fjge_cont.50337
fjge_else.50336:
	fjlt	%f16, %f3, fjge_else.50340
	addi	%g3, %g0, 1
	jmp	fjge_cont.50341
fjge_else.50340:
	addi	%g3, %g0, 0
fjge_cont.50341:
fjge_cont.50337:
	fjlt	%f4, %f0, fjge_else.50342
	fmov	%f1, %f0
	jmp	fjge_cont.50343
fjge_else.50342:
	fsub	%f1, %f29, %f0
fjge_cont.50343:
	fjlt	%f22, %f1, fjge_else.50344
	fmov	%f0, %f1
	jmp	fjge_cont.50345
fjge_else.50344:
	fsub	%f0, %f4, %f1
fjge_cont.50345:
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
	jne	%g3, %g0, jeq_else.50346
	fneg	%f7, %f0
	jmp	jeq_cont.50347
jeq_else.50346:
	fmov	%f7, %f0
jeq_cont.50347:
	fldi	%f3, %g7, -4
	fsub	%f2, %f22, %f3
	fjlt	%f2, %f16, fjge_else.50348
	fmov	%f1, %f2
	jmp	fjge_cont.50349
fjge_else.50348:
	fneg	%f1, %f2
fjge_cont.50349:
	fjlt	%f29, %f1, fjge_else.50350
	fjlt	%f1, %f16, fjge_else.50352
	fmov	%f0, %f1
	jmp	fjge_cont.50353
fjge_else.50352:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50354
	fjlt	%f1, %f16, fjge_else.50356
	fmov	%f0, %f1
	jmp	fjge_cont.50357
fjge_else.50356:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50358
	fjlt	%f1, %f16, fjge_else.50360
	fmov	%f0, %f1
	jmp	fjge_cont.50361
fjge_else.50360:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50361:
	jmp	fjge_cont.50359
fjge_else.50358:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50359:
fjge_cont.50357:
	jmp	fjge_cont.50355
fjge_else.50354:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50362
	fjlt	%f1, %f16, fjge_else.50364
	fmov	%f0, %f1
	jmp	fjge_cont.50365
fjge_else.50364:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50365:
	jmp	fjge_cont.50363
fjge_else.50362:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50363:
fjge_cont.50355:
fjge_cont.50353:
	jmp	fjge_cont.50351
fjge_else.50350:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50366
	fjlt	%f1, %f16, fjge_else.50368
	fmov	%f0, %f1
	jmp	fjge_cont.50369
fjge_else.50368:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50370
	fjlt	%f1, %f16, fjge_else.50372
	fmov	%f0, %f1
	jmp	fjge_cont.50373
fjge_else.50372:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50373:
	jmp	fjge_cont.50371
fjge_else.50370:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50371:
fjge_cont.50369:
	jmp	fjge_cont.50367
fjge_else.50366:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50374
	fjlt	%f1, %f16, fjge_else.50376
	fmov	%f0, %f1
	jmp	fjge_cont.50377
fjge_else.50376:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50377:
	jmp	fjge_cont.50375
fjge_else.50374:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50375:
fjge_cont.50367:
fjge_cont.50351:
	fjlt	%f4, %f0, fjge_else.50378
	fjlt	%f16, %f2, fjge_else.50380
	addi	%g3, %g0, 0
	jmp	fjge_cont.50381
fjge_else.50380:
	addi	%g3, %g0, 1
fjge_cont.50381:
	jmp	fjge_cont.50379
fjge_else.50378:
	fjlt	%f16, %f2, fjge_else.50382
	addi	%g3, %g0, 1
	jmp	fjge_cont.50383
fjge_else.50382:
	addi	%g3, %g0, 0
fjge_cont.50383:
fjge_cont.50379:
	fjlt	%f4, %f0, fjge_else.50384
	fmov	%f1, %f0
	jmp	fjge_cont.50385
fjge_else.50384:
	fsub	%f1, %f29, %f0
fjge_cont.50385:
	fjlt	%f22, %f1, fjge_else.50386
	fmov	%f0, %f1
	jmp	fjge_cont.50387
fjge_else.50386:
	fsub	%f0, %f4, %f1
fjge_cont.50387:
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
	jne	%g3, %g0, jeq_else.50388
	fneg	%f13, %f0
	jmp	jeq_cont.50389
jeq_else.50388:
	fmov	%f13, %f0
jeq_cont.50389:
	fjlt	%f3, %f16, fjge_else.50390
	fmov	%f1, %f3
	jmp	fjge_cont.50391
fjge_else.50390:
	fneg	%f1, %f3
fjge_cont.50391:
	fjlt	%f29, %f1, fjge_else.50392
	fjlt	%f1, %f16, fjge_else.50394
	fmov	%f0, %f1
	jmp	fjge_cont.50395
fjge_else.50394:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50396
	fjlt	%f1, %f16, fjge_else.50398
	fmov	%f0, %f1
	jmp	fjge_cont.50399
fjge_else.50398:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50400
	fjlt	%f1, %f16, fjge_else.50402
	fmov	%f0, %f1
	jmp	fjge_cont.50403
fjge_else.50402:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50403:
	jmp	fjge_cont.50401
fjge_else.50400:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50401:
fjge_cont.50399:
	jmp	fjge_cont.50397
fjge_else.50396:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50404
	fjlt	%f1, %f16, fjge_else.50406
	fmov	%f0, %f1
	jmp	fjge_cont.50407
fjge_else.50406:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50407:
	jmp	fjge_cont.50405
fjge_else.50404:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50405:
fjge_cont.50397:
fjge_cont.50395:
	jmp	fjge_cont.50393
fjge_else.50392:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50408
	fjlt	%f1, %f16, fjge_else.50410
	fmov	%f0, %f1
	jmp	fjge_cont.50411
fjge_else.50410:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50412
	fjlt	%f1, %f16, fjge_else.50414
	fmov	%f0, %f1
	jmp	fjge_cont.50415
fjge_else.50414:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50415:
	jmp	fjge_cont.50413
fjge_else.50412:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50413:
fjge_cont.50411:
	jmp	fjge_cont.50409
fjge_else.50408:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50416
	fjlt	%f1, %f16, fjge_else.50418
	fmov	%f0, %f1
	jmp	fjge_cont.50419
fjge_else.50418:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50419:
	jmp	fjge_cont.50417
fjge_else.50416:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50417:
fjge_cont.50409:
fjge_cont.50393:
	fjlt	%f4, %f0, fjge_else.50420
	fjlt	%f16, %f3, fjge_else.50422
	addi	%g3, %g0, 0
	jmp	fjge_cont.50423
fjge_else.50422:
	addi	%g3, %g0, 1
fjge_cont.50423:
	jmp	fjge_cont.50421
fjge_else.50420:
	fjlt	%f16, %f3, fjge_else.50424
	addi	%g3, %g0, 1
	jmp	fjge_cont.50425
fjge_else.50424:
	addi	%g3, %g0, 0
fjge_cont.50425:
fjge_cont.50421:
	fjlt	%f4, %f0, fjge_else.50426
	fmov	%f1, %f0
	jmp	fjge_cont.50427
fjge_else.50426:
	fsub	%f1, %f29, %f0
fjge_cont.50427:
	fjlt	%f22, %f1, fjge_else.50428
	fmov	%f0, %f1
	jmp	fjge_cont.50429
fjge_else.50428:
	fsub	%f0, %f4, %f1
fjge_cont.50429:
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
	jne	%g3, %g0, jeq_else.50430
	fneg	%f9, %f0
	jmp	jeq_cont.50431
jeq_else.50430:
	fmov	%f9, %f0
jeq_cont.50431:
	fldi	%f3, %g7, -8
	fsub	%f2, %f22, %f3
	fjlt	%f2, %f16, fjge_else.50432
	fmov	%f1, %f2
	jmp	fjge_cont.50433
fjge_else.50432:
	fneg	%f1, %f2
fjge_cont.50433:
	fjlt	%f29, %f1, fjge_else.50434
	fjlt	%f1, %f16, fjge_else.50436
	fmov	%f0, %f1
	jmp	fjge_cont.50437
fjge_else.50436:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50438
	fjlt	%f1, %f16, fjge_else.50440
	fmov	%f0, %f1
	jmp	fjge_cont.50441
fjge_else.50440:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50442
	fjlt	%f1, %f16, fjge_else.50444
	fmov	%f0, %f1
	jmp	fjge_cont.50445
fjge_else.50444:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50445:
	jmp	fjge_cont.50443
fjge_else.50442:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50443:
fjge_cont.50441:
	jmp	fjge_cont.50439
fjge_else.50438:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50446
	fjlt	%f1, %f16, fjge_else.50448
	fmov	%f0, %f1
	jmp	fjge_cont.50449
fjge_else.50448:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50449:
	jmp	fjge_cont.50447
fjge_else.50446:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50447:
fjge_cont.50439:
fjge_cont.50437:
	jmp	fjge_cont.50435
fjge_else.50434:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50450
	fjlt	%f1, %f16, fjge_else.50452
	fmov	%f0, %f1
	jmp	fjge_cont.50453
fjge_else.50452:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50454
	fjlt	%f1, %f16, fjge_else.50456
	fmov	%f0, %f1
	jmp	fjge_cont.50457
fjge_else.50456:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50457:
	jmp	fjge_cont.50455
fjge_else.50454:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50455:
fjge_cont.50453:
	jmp	fjge_cont.50451
fjge_else.50450:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50458
	fjlt	%f1, %f16, fjge_else.50460
	fmov	%f0, %f1
	jmp	fjge_cont.50461
fjge_else.50460:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50461:
	jmp	fjge_cont.50459
fjge_else.50458:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50459:
fjge_cont.50451:
fjge_cont.50435:
	fjlt	%f4, %f0, fjge_else.50462
	fjlt	%f16, %f2, fjge_else.50464
	addi	%g3, %g0, 0
	jmp	fjge_cont.50465
fjge_else.50464:
	addi	%g3, %g0, 1
fjge_cont.50465:
	jmp	fjge_cont.50463
fjge_else.50462:
	fjlt	%f16, %f2, fjge_else.50466
	addi	%g3, %g0, 1
	jmp	fjge_cont.50467
fjge_else.50466:
	addi	%g3, %g0, 0
fjge_cont.50467:
fjge_cont.50463:
	fjlt	%f4, %f0, fjge_else.50468
	fmov	%f1, %f0
	jmp	fjge_cont.50469
fjge_else.50468:
	fsub	%f1, %f29, %f0
fjge_cont.50469:
	fjlt	%f22, %f1, fjge_else.50470
	fmov	%f0, %f1
	jmp	fjge_cont.50471
fjge_else.50470:
	fsub	%f0, %f4, %f1
fjge_cont.50471:
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
	jne	%g3, %g0, jeq_else.50472
	fneg	%f2, %f0
	jmp	jeq_cont.50473
jeq_else.50472:
	fmov	%f2, %f0
jeq_cont.50473:
	fjlt	%f3, %f16, fjge_else.50474
	fmov	%f1, %f3
	jmp	fjge_cont.50475
fjge_else.50474:
	fneg	%f1, %f3
fjge_cont.50475:
	fjlt	%f29, %f1, fjge_else.50476
	fjlt	%f1, %f16, fjge_else.50478
	fmov	%f0, %f1
	jmp	fjge_cont.50479
fjge_else.50478:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50480
	fjlt	%f1, %f16, fjge_else.50482
	fmov	%f0, %f1
	jmp	fjge_cont.50483
fjge_else.50482:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50484
	fjlt	%f1, %f16, fjge_else.50486
	fmov	%f0, %f1
	jmp	fjge_cont.50487
fjge_else.50486:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50487:
	jmp	fjge_cont.50485
fjge_else.50484:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50485:
fjge_cont.50483:
	jmp	fjge_cont.50481
fjge_else.50480:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50488
	fjlt	%f1, %f16, fjge_else.50490
	fmov	%f0, %f1
	jmp	fjge_cont.50491
fjge_else.50490:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50491:
	jmp	fjge_cont.50489
fjge_else.50488:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50489:
fjge_cont.50481:
fjge_cont.50479:
	jmp	fjge_cont.50477
fjge_else.50476:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50492
	fjlt	%f1, %f16, fjge_else.50494
	fmov	%f0, %f1
	jmp	fjge_cont.50495
fjge_else.50494:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50496
	fjlt	%f1, %f16, fjge_else.50498
	fmov	%f0, %f1
	jmp	fjge_cont.50499
fjge_else.50498:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50499:
	jmp	fjge_cont.50497
fjge_else.50496:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50497:
fjge_cont.50495:
	jmp	fjge_cont.50493
fjge_else.50492:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.50500
	fjlt	%f1, %f16, fjge_else.50502
	fmov	%f0, %f1
	jmp	fjge_cont.50503
fjge_else.50502:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50503:
	jmp	fjge_cont.50501
fjge_else.50500:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.50501:
fjge_cont.50493:
fjge_cont.50477:
	fjlt	%f4, %f0, fjge_else.50504
	fjlt	%f16, %f3, fjge_else.50506
	addi	%g3, %g0, 0
	jmp	fjge_cont.50507
fjge_else.50506:
	addi	%g3, %g0, 1
fjge_cont.50507:
	jmp	fjge_cont.50505
fjge_else.50504:
	fjlt	%f16, %f3, fjge_else.50508
	addi	%g3, %g0, 1
	jmp	fjge_cont.50509
fjge_else.50508:
	addi	%g3, %g0, 0
fjge_cont.50509:
fjge_cont.50505:
	fjlt	%f4, %f0, fjge_else.50510
	fmov	%f1, %f0
	jmp	fjge_cont.50511
fjge_else.50510:
	fsub	%f1, %f29, %f0
fjge_cont.50511:
	fjlt	%f22, %f1, fjge_else.50512
	fmov	%f0, %f1
	jmp	fjge_cont.50513
fjge_else.50512:
	fsub	%f0, %f4, %f1
fjge_cont.50513:
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
	jne	%g3, %g0, jeq_else.50514
	fneg	%f0, %f1
	jmp	jeq_cont.50515
jeq_else.50514:
	fmov	%f0, %f1
jeq_cont.50515:
	fmul	%f12, %f13, %f2
	fmul	%f5, %f7, %f9
	fmul	%f3, %f5, %f2
	fldi	%f15, %g1, 0
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
	fldi	%f0, %g8, 0
	fldi	%f2, %g8, -4
	fldi	%f3, %g8, -8
	fmul	%f1, %f12, %f12
	fmul	%f13, %f0, %f1
	fmul	%f1, %f11, %f11
	fmul	%f1, %f2, %f1
	fadd	%f13, %f13, %f1
	fmul	%f1, %f9, %f9
	fmul	%f1, %f3, %f1
	fadd	%f1, %f13, %f1
	fsti	%f1, %g8, 0
	fmul	%f1, %f10, %f10
	fmul	%f13, %f0, %f1
	fmul	%f1, %f8, %f8
	fmul	%f1, %f2, %f1
	fadd	%f13, %f13, %f1
	fmul	%f1, %f7, %f7
	fmul	%f1, %f3, %f1
	fadd	%f1, %f13, %f1
	fsti	%f1, %g8, -4
	fmul	%f1, %f6, %f6
	fmul	%f13, %f0, %f1
	fmul	%f1, %f5, %f5
	fmul	%f1, %f2, %f1
	fadd	%f13, %f13, %f1
	fmul	%f1, %f4, %f4
	fmul	%f1, %f3, %f1
	fadd	%f1, %f13, %f1
	fsti	%f1, %g8, -8
	fmul	%f1, %f0, %f10
	fmul	%f13, %f1, %f6
	fmul	%f1, %f2, %f8
	fmul	%f1, %f1, %f5
	fadd	%f13, %f13, %f1
	fmul	%f1, %f3, %f7
	fmul	%f1, %f1, %f4
	fadd	%f1, %f13, %f1
	fmul	%f1, %f14, %f1
	fsti	%f1, %g7, 0
	fmul	%f1, %f0, %f12
	fmul	%f6, %f1, %f6
	fmul	%f0, %f2, %f11
	fmul	%f2, %f0, %f5
	fadd	%f5, %f6, %f2
	fmul	%f3, %f3, %f9
	fmul	%f2, %f3, %f4
	fadd	%f2, %f5, %f2
	fmul	%f2, %f14, %f2
	fsti	%f2, %g7, -4
	fmul	%f1, %f1, %f10
	fmul	%f0, %f0, %f8
	fadd	%f1, %f1, %f0
	fmul	%f0, %f3, %f7
	fadd	%f0, %f1, %f0
	fmul	%f0, %f14, %f0
	fsti	%f0, %g7, -8
jeq_cont.50263:
	addi	%g3, %g0, 1
jeq_cont.49935:
	jne	%g3, %g0, jeq_else.50516
	sti	%g16, %g31, 28
	return
jeq_else.50516:
	addi	%g16, %g16, 1
	jmp	read_object.2696

!==============================
! args = [%g8]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %f15, %dummy]
! ret type = Array(Int)
!================================
read_net_item.2700:
	addi	%g3, %g0, 0
	sti	%g3, %g31, 4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 8
	input	%g4
	addi	%g7, %g0, 48
	jlt	%g4, %g7, jle_else.50518
	addi	%g7, %g0, 57
	jlt	%g7, %g4, jle_else.50520
	addi	%g7, %g0, 0
	jmp	jle_cont.50521
jle_else.50520:
	addi	%g7, %g0, 1
jle_cont.50521:
	jmp	jle_cont.50519
jle_else.50518:
	addi	%g7, %g0, 1
jle_cont.50519:
	jne	%g7, %g0, jeq_else.50522
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.50524
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
	jmp	jeq_cont.50525
jeq_else.50524:
jeq_cont.50525:
	ldi	%g3, %g31, 4
	slli	%g5, %g3, 3
	slli	%g3, %g3, 1
	add	%g5, %g5, %g3
	subi	%g3, %g4, 48
	add	%g3, %g5, %g3
	sti	%g3, %g31, 4
	input	%g5
	addi	%g7, %g0, 48
	jlt	%g5, %g7, jle_else.50526
	addi	%g7, %g0, 57
	jlt	%g7, %g5, jle_else.50528
	addi	%g7, %g0, 0
	jmp	jle_cont.50529
jle_else.50528:
	addi	%g7, %g0, 1
jle_cont.50529:
	jmp	jle_cont.50527
jle_else.50526:
	addi	%g7, %g0, 1
jle_cont.50527:
	jne	%g7, %g0, jeq_else.50530
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.50532
	addi	%g3, %g0, 45
	jne	%g4, %g3, jeq_else.50534
	addi	%g3, %g0, -1
	sti	%g3, %g31, 8
	jmp	jeq_cont.50535
jeq_else.50534:
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
jeq_cont.50535:
	jmp	jeq_cont.50533
jeq_else.50532:
jeq_cont.50533:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g7, %g3
	jmp	jeq_cont.50531
jeq_else.50530:
	ldi	%g7, %g31, 8
	jne	%g7, %g28, jeq_else.50536
	ldi	%g7, %g31, 4
	jmp	jeq_cont.50537
jeq_else.50536:
	ldi	%g7, %g31, 4
	sub	%g7, %g0, %g7
jeq_cont.50537:
jeq_cont.50531:
	jmp	jeq_cont.50523
jeq_else.50522:
	input	%g5
	addi	%g7, %g0, 48
	jlt	%g5, %g7, jle_else.50538
	addi	%g7, %g0, 57
	jlt	%g7, %g5, jle_else.50540
	addi	%g7, %g0, 0
	jmp	jle_cont.50541
jle_else.50540:
	addi	%g7, %g0, 1
jle_cont.50541:
	jmp	jle_cont.50539
jle_else.50538:
	addi	%g7, %g0, 1
jle_cont.50539:
	jne	%g7, %g0, jeq_else.50542
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.50544
	addi	%g3, %g0, 45
	jne	%g4, %g3, jeq_else.50546
	addi	%g3, %g0, -1
	sti	%g3, %g31, 8
	jmp	jeq_cont.50547
jeq_else.50546:
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
jeq_cont.50547:
	jmp	jeq_cont.50545
jeq_else.50544:
jeq_cont.50545:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g7, %g3
	jmp	jeq_cont.50543
jeq_else.50542:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g7, %g3
jeq_cont.50543:
jeq_cont.50523:
	jne	%g7, %g29, jeq_else.50548
	addi	%g3, %g8, 1
	addi	%g4, %g0, -1
	jmp	min_caml_create_array
jeq_else.50548:
	addi	%g9, %g8, 1
	addi	%g3, %g0, 0
	sti	%g3, %g31, 4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 8
	input	%g5
	addi	%g4, %g0, 48
	jlt	%g5, %g4, jle_else.50549
	addi	%g4, %g0, 57
	jlt	%g4, %g5, jle_else.50551
	addi	%g4, %g0, 0
	jmp	jle_cont.50552
jle_else.50551:
	addi	%g4, %g0, 1
jle_cont.50552:
	jmp	jle_cont.50550
jle_else.50549:
	addi	%g4, %g0, 1
jle_cont.50550:
	jne	%g4, %g0, jeq_else.50553
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.50555
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
	jmp	jeq_cont.50556
jeq_else.50555:
jeq_cont.50556:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g4, %g3
	jmp	jeq_cont.50554
jeq_else.50553:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g4, %g3
jeq_cont.50554:
	sti	%g7, %g1, 0
	sti	%g8, %g1, 4
	jne	%g4, %g29, jeq_else.50557
	addi	%g3, %g9, 1
	addi	%g4, %g0, -1
	subi	%g1, %g1, 12
	call	min_caml_create_array
	addi	%g1, %g1, 12
	jmp	jeq_cont.50558
jeq_else.50557:
	addi	%g3, %g9, 1
	sti	%g4, %g1, 8
	sti	%g9, %g1, 12
	mov	%g8, %g3
	subi	%g1, %g1, 20
	call	read_net_item.2700
	addi	%g1, %g1, 20
	ldi	%g9, %g1, 12
	slli	%g5, %g9, 2
	ldi	%g4, %g1, 8
	st	%g4, %g3, %g5
jeq_cont.50558:
	ldi	%g8, %g1, 4
	slli	%g4, %g8, 2
	ldi	%g7, %g1, 0
	st	%g7, %g3, %g4
	return

!==============================
! args = [%g11]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g11, %g10, %f15, %dummy]
! ret type = Array(Array(Int))
!================================
read_or_network.2702:
	addi	%g3, %g0, 0
	sti	%g3, %g31, 4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 8
	input	%g5
	addi	%g3, %g0, 48
	jlt	%g5, %g3, jle_else.50559
	addi	%g3, %g0, 57
	jlt	%g3, %g5, jle_else.50561
	addi	%g3, %g0, 0
	jmp	jle_cont.50562
jle_else.50561:
	addi	%g3, %g0, 1
jle_cont.50562:
	jmp	jle_cont.50560
jle_else.50559:
	addi	%g3, %g0, 1
jle_cont.50560:
	jne	%g3, %g0, jeq_else.50563
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.50565
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
	jmp	jeq_cont.50566
jeq_else.50565:
jeq_cont.50566:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	jmp	jeq_cont.50564
jeq_else.50563:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
jeq_cont.50564:
	jne	%g3, %g29, jeq_else.50567
	addi	%g3, %g0, 1
	addi	%g4, %g0, -1
	subi	%g1, %g1, 4
	call	min_caml_create_array
	addi	%g1, %g1, 4
	mov	%g5, %g3
	jmp	jeq_cont.50568
jeq_else.50567:
	addi	%g8, %g0, 1
	sti	%g3, %g1, 0
	subi	%g1, %g1, 8
	call	read_net_item.2700
	addi	%g1, %g1, 8
	mov	%g5, %g3
	ldi	%g3, %g1, 0
	sti	%g3, %g5, 0
jeq_cont.50568:
	ldi	%g3, %g5, 0
	jne	%g3, %g29, jeq_else.50569
	addi	%g3, %g11, 1
	mov	%g4, %g5
	jmp	min_caml_create_array
jeq_else.50569:
	addi	%g10, %g11, 1
	addi	%g3, %g0, 0
	sti	%g3, %g31, 4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 8
	input	%g7
	addi	%g3, %g0, 48
	jlt	%g7, %g3, jle_else.50570
	addi	%g3, %g0, 57
	jlt	%g3, %g7, jle_else.50572
	addi	%g3, %g0, 0
	jmp	jle_cont.50573
jle_else.50572:
	addi	%g3, %g0, 1
jle_cont.50573:
	jmp	jle_cont.50571
jle_else.50570:
	addi	%g3, %g0, 1
jle_cont.50571:
	sti	%g5, %g1, 4
	jne	%g3, %g0, jeq_else.50574
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.50576
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
	jmp	jeq_cont.50577
jeq_else.50576:
jeq_cont.50577:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g7, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	mov	%g5, %g7
	subi	%g1, %g1, 12
	call	read_int_token.2507
	addi	%g1, %g1, 12
	jmp	jeq_cont.50575
jeq_else.50574:
	addi	%g6, %g0, 0
	mov	%g5, %g7
	subi	%g1, %g1, 12
	call	read_int_token.2507
	addi	%g1, %g1, 12
jeq_cont.50575:
	jne	%g3, %g29, jeq_else.50578
	addi	%g3, %g0, 1
	addi	%g4, %g0, -1
	subi	%g1, %g1, 12
	call	min_caml_create_array
	addi	%g1, %g1, 12
	mov	%g4, %g3
	jmp	jeq_cont.50579
jeq_else.50578:
	addi	%g8, %g0, 1
	sti	%g3, %g1, 8
	subi	%g1, %g1, 16
	call	read_net_item.2700
	addi	%g1, %g1, 16
	mov	%g4, %g3
	ldi	%g3, %g1, 8
	sti	%g3, %g4, 0
jeq_cont.50579:
	ldi	%g3, %g4, 0
	sti	%g11, %g1, 12
	jne	%g3, %g29, jeq_else.50580
	addi	%g3, %g10, 1
	subi	%g1, %g1, 20
	call	min_caml_create_array
	addi	%g1, %g1, 20
	jmp	jeq_cont.50581
jeq_else.50580:
	addi	%g3, %g10, 1
	sti	%g4, %g1, 16
	sti	%g10, %g1, 20
	mov	%g11, %g3
	subi	%g1, %g1, 28
	call	read_or_network.2702
	addi	%g1, %g1, 28
	ldi	%g10, %g1, 20
	slli	%g6, %g10, 2
	ldi	%g4, %g1, 16
	st	%g4, %g3, %g6
jeq_cont.50581:
	ldi	%g11, %g1, 12
	slli	%g4, %g11, 2
	ldi	%g5, %g1, 4
	st	%g5, %g3, %g4
	return

!==============================
! args = [%g11]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g12, %g11, %g10, %f15, %dummy]
! ret type = Unit
!================================
read_and_network.2704:
	addi	%g3, %g0, 0
	sti	%g3, %g31, 4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 8
	input	%g4
	addi	%g10, %g0, 48
	jlt	%g4, %g10, jle_else.50582
	addi	%g10, %g0, 57
	jlt	%g10, %g4, jle_else.50584
	addi	%g10, %g0, 0
	jmp	jle_cont.50585
jle_else.50584:
	addi	%g10, %g0, 1
jle_cont.50585:
	jmp	jle_cont.50583
jle_else.50582:
	addi	%g10, %g0, 1
jle_cont.50583:
	jne	%g10, %g0, jeq_else.50586
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.50588
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
	jmp	jeq_cont.50589
jeq_else.50588:
jeq_cont.50589:
	ldi	%g3, %g31, 4
	slli	%g5, %g3, 3
	slli	%g3, %g3, 1
	add	%g5, %g5, %g3
	subi	%g3, %g4, 48
	add	%g3, %g5, %g3
	sti	%g3, %g31, 4
	input	%g5
	addi	%g10, %g0, 48
	jlt	%g5, %g10, jle_else.50590
	addi	%g10, %g0, 57
	jlt	%g10, %g5, jle_else.50592
	addi	%g10, %g0, 0
	jmp	jle_cont.50593
jle_else.50592:
	addi	%g10, %g0, 1
jle_cont.50593:
	jmp	jle_cont.50591
jle_else.50590:
	addi	%g10, %g0, 1
jle_cont.50591:
	jne	%g10, %g0, jeq_else.50594
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.50596
	addi	%g3, %g0, 45
	jne	%g4, %g3, jeq_else.50598
	addi	%g3, %g0, -1
	sti	%g3, %g31, 8
	jmp	jeq_cont.50599
jeq_else.50598:
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
jeq_cont.50599:
	jmp	jeq_cont.50597
jeq_else.50596:
jeq_cont.50597:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g10, %g3
	jmp	jeq_cont.50595
jeq_else.50594:
	ldi	%g10, %g31, 8
	jne	%g10, %g28, jeq_else.50600
	ldi	%g10, %g31, 4
	jmp	jeq_cont.50601
jeq_else.50600:
	ldi	%g10, %g31, 4
	sub	%g10, %g0, %g10
jeq_cont.50601:
jeq_cont.50595:
	jmp	jeq_cont.50587
jeq_else.50586:
	input	%g5
	addi	%g10, %g0, 48
	jlt	%g5, %g10, jle_else.50602
	addi	%g10, %g0, 57
	jlt	%g10, %g5, jle_else.50604
	addi	%g10, %g0, 0
	jmp	jle_cont.50605
jle_else.50604:
	addi	%g10, %g0, 1
jle_cont.50605:
	jmp	jle_cont.50603
jle_else.50602:
	addi	%g10, %g0, 1
jle_cont.50603:
	jne	%g10, %g0, jeq_else.50606
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.50608
	addi	%g3, %g0, 45
	jne	%g4, %g3, jeq_else.50610
	addi	%g3, %g0, -1
	sti	%g3, %g31, 8
	jmp	jeq_cont.50611
jeq_else.50610:
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
jeq_cont.50611:
	jmp	jeq_cont.50609
jeq_else.50608:
jeq_cont.50609:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g10, %g3
	jmp	jeq_cont.50607
jeq_else.50606:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g10, %g3
jeq_cont.50607:
jeq_cont.50587:
	jne	%g10, %g29, jeq_else.50612
	addi	%g3, %g0, 1
	addi	%g4, %g0, -1
	subi	%g1, %g1, 4
	call	min_caml_create_array
	addi	%g1, %g1, 4
	jmp	jeq_cont.50613
jeq_else.50612:
	addi	%g3, %g0, 0
	sti	%g3, %g31, 4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 8
	input	%g5
	addi	%g12, %g0, 48
	jlt	%g5, %g12, jle_else.50614
	addi	%g12, %g0, 57
	jlt	%g12, %g5, jle_else.50616
	addi	%g12, %g0, 0
	jmp	jle_cont.50617
jle_else.50616:
	addi	%g12, %g0, 1
jle_cont.50617:
	jmp	jle_cont.50615
jle_else.50614:
	addi	%g12, %g0, 1
jle_cont.50615:
	jne	%g12, %g0, jeq_else.50618
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.50620
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
	jmp	jeq_cont.50621
jeq_else.50620:
jeq_cont.50621:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g12, %g3
	jmp	jeq_cont.50619
jeq_else.50618:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g12, %g3
jeq_cont.50619:
	jne	%g12, %g29, jeq_else.50622
	addi	%g3, %g0, 2
	addi	%g4, %g0, -1
	subi	%g1, %g1, 4
	call	min_caml_create_array
	addi	%g1, %g1, 4
	jmp	jeq_cont.50623
jeq_else.50622:
	addi	%g8, %g0, 2
	subi	%g1, %g1, 4
	call	read_net_item.2700
	addi	%g1, %g1, 4
	sti	%g12, %g3, -4
jeq_cont.50623:
	sti	%g10, %g3, 0
jeq_cont.50613:
	ldi	%g4, %g3, 0
	jne	%g4, %g29, jeq_else.50624
	return
jeq_else.50624:
	slli	%g4, %g11, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 512
	addi	%g11, %g11, 1
	addi	%g3, %g0, 0
	sti	%g3, %g31, 4
	addi	%g3, %g0, 0
	sti	%g3, %g31, 8
	input	%g5
	addi	%g10, %g0, 48
	jlt	%g5, %g10, jle_else.50626
	addi	%g10, %g0, 57
	jlt	%g10, %g5, jle_else.50628
	addi	%g10, %g0, 0
	jmp	jle_cont.50629
jle_else.50628:
	addi	%g10, %g0, 1
jle_cont.50629:
	jmp	jle_cont.50627
jle_else.50626:
	addi	%g10, %g0, 1
jle_cont.50627:
	jne	%g10, %g0, jeq_else.50630
	ldi	%g3, %g31, 8
	jne	%g3, %g0, jeq_else.50632
	addi	%g3, %g0, 1
	sti	%g3, %g31, 8
	jmp	jeq_cont.50633
jeq_else.50632:
jeq_cont.50633:
	ldi	%g3, %g31, 4
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g4, %g4, %g3
	subi	%g3, %g5, 48
	add	%g3, %g4, %g3
	sti	%g3, %g31, 4
	addi	%g6, %g0, 1
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g10, %g3
	jmp	jeq_cont.50631
jeq_else.50630:
	addi	%g6, %g0, 0
	subi	%g1, %g1, 4
	call	read_int_token.2507
	addi	%g1, %g1, 4
	mov	%g10, %g3
jeq_cont.50631:
	jne	%g10, %g29, jeq_else.50634
	addi	%g3, %g0, 1
	addi	%g4, %g0, -1
	subi	%g1, %g1, 4
	call	min_caml_create_array
	addi	%g1, %g1, 4
	jmp	jeq_cont.50635
jeq_else.50634:
	addi	%g8, %g0, 1
	subi	%g1, %g1, 4
	call	read_net_item.2700
	addi	%g1, %g1, 4
	sti	%g10, %g3, 0
jeq_cont.50635:
	ldi	%g4, %g3, 0
	jne	%g4, %g29, jeq_else.50636
	return
jeq_else.50636:
	slli	%g4, %g11, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 512
	addi	%g11, %g11, 1
	jmp	read_and_network.2704

!==============================
! args = [%g7, %g6, %g5]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g10, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f20, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
iter_setup_dirvec_constants.2801:
	jlt	%g5, %g0, jge_else.50638
	slli	%g3, %g5, 2
	add	%g3, %g31, %g3
	ldi	%g9, %g3, 272
	ldi	%g3, %g9, -4
	jne	%g3, %g28, jeq_else.50639
	addi	%g3, %g0, 6
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	fldi	%f0, %g7, 0
	fjeq	%f0, %f16, fjne_else.50641
	ldi	%g4, %g9, -24
	fjlt	%f0, %f16, fjge_else.50643
	addi	%g10, %g0, 0
	jmp	fjge_cont.50644
fjge_else.50643:
	addi	%g10, %g0, 1
fjge_cont.50644:
	ldi	%g8, %g9, -16
	fldi	%f1, %g8, 0
	jne	%g4, %g10, jeq_else.50645
	fneg	%f0, %f1
	jmp	jeq_cont.50646
jeq_else.50645:
	fmov	%f0, %f1
jeq_cont.50646:
	fsti	%f0, %g3, 0
	fldi	%f0, %g7, 0
	fdiv	%f0, %f17, %f0
	fsti	%f0, %g3, -4
	jmp	fjne_cont.50642
fjne_else.50641:
	fsti	%f16, %g3, -4
fjne_cont.50642:
	fldi	%f0, %g7, -4
	fjeq	%f0, %f16, fjne_else.50647
	ldi	%g4, %g9, -24
	fjlt	%f0, %f16, fjge_else.50649
	addi	%g10, %g0, 0
	jmp	fjge_cont.50650
fjge_else.50649:
	addi	%g10, %g0, 1
fjge_cont.50650:
	ldi	%g8, %g9, -16
	fldi	%f1, %g8, -4
	jne	%g4, %g10, jeq_else.50651
	fneg	%f0, %f1
	jmp	jeq_cont.50652
jeq_else.50651:
	fmov	%f0, %f1
jeq_cont.50652:
	fsti	%f0, %g3, -8
	fldi	%f0, %g7, -4
	fdiv	%f0, %f17, %f0
	fsti	%f0, %g3, -12
	jmp	fjne_cont.50648
fjne_else.50647:
	fsti	%f16, %g3, -12
fjne_cont.50648:
	fldi	%f0, %g7, -8
	fjeq	%f0, %f16, fjne_else.50653
	ldi	%g4, %g9, -24
	fjlt	%f0, %f16, fjge_else.50655
	addi	%g10, %g0, 0
	jmp	fjge_cont.50656
fjge_else.50655:
	addi	%g10, %g0, 1
fjge_cont.50656:
	ldi	%g8, %g9, -16
	fldi	%f1, %g8, -8
	jne	%g4, %g10, jeq_else.50657
	fneg	%f0, %f1
	jmp	jeq_cont.50658
jeq_else.50657:
	fmov	%f0, %f1
jeq_cont.50658:
	fsti	%f0, %g3, -16
	fldi	%f0, %g7, -8
	fdiv	%f0, %f17, %f0
	fsti	%f0, %g3, -20
	jmp	fjne_cont.50654
fjne_else.50653:
	fsti	%f16, %g3, -20
fjne_cont.50654:
	slli	%g4, %g5, 2
	st	%g3, %g6, %g4
	jmp	jeq_cont.50640
jeq_else.50639:
	addi	%g4, %g0, 2
	jne	%g3, %g4, jeq_else.50659
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
	fjlt	%f16, %f0, fjge_else.50661
	fsti	%f16, %g3, 0
	jmp	fjge_cont.50662
fjge_else.50661:
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
fjge_cont.50662:
	slli	%g4, %g5, 2
	st	%g3, %g6, %g4
	jmp	jeq_cont.50660
jeq_else.50659:
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
	jne	%g8, %g0, jeq_else.50663
	fmov	%f3, %f7
	jmp	jeq_cont.50664
jeq_else.50663:
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
jeq_cont.50664:
	fmul	%f0, %f0, %f5
	fneg	%f0, %f0
	fmul	%f1, %f1, %f6
	fneg	%f1, %f1
	fmul	%f2, %f2, %f4
	fneg	%f2, %f2
	fsti	%f3, %g3, 0
	jne	%g8, %g0, jeq_else.50665
	fsti	%f0, %g3, -4
	fsti	%f1, %g3, -8
	fsti	%f2, %g3, -12
	jmp	jeq_cont.50666
jeq_else.50665:
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
jeq_cont.50666:
	fjeq	%f3, %f16, fjne_else.50667
	fdiv	%f0, %f17, %f3
	fsti	%f0, %g3, -16
	jmp	fjne_cont.50668
fjne_else.50667:
fjne_cont.50668:
	slli	%g4, %g5, 2
	st	%g3, %g6, %g4
jeq_cont.50660:
jeq_cont.50640:
	subi	%g5, %g5, 1
	jmp	iter_setup_dirvec_constants.2801
jge_else.50638:
	return

!==============================
! args = [%g3, %g4]
! fargs = []
! use_regs = [%g8, %g7, %g6, %g5, %g4, %g3, %g27, %f5, %f4, %f3, %f2, %f17, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
setup_startp_constants.2806:
	jlt	%g4, %g0, jge_else.50670
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
	jne	%g7, %g6, jeq_else.50671
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
	jmp	jeq_cont.50672
jeq_else.50671:
	addi	%g6, %g0, 2
	jlt	%g6, %g7, jle_else.50673
	jmp	jle_cont.50674
jle_else.50673:
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
	jne	%g6, %g0, jeq_else.50675
	fmov	%f3, %f4
	jmp	jeq_cont.50676
jeq_else.50675:
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
jeq_cont.50676:
	addi	%g5, %g0, 3
	jne	%g7, %g5, jeq_else.50677
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.50678
jeq_else.50677:
	fmov	%f0, %f3
jeq_cont.50678:
	fsti	%f0, %g8, -12
jle_cont.50674:
jeq_cont.50672:
	subi	%g8, %g4, 1
	jlt	%g8, %g0, jge_else.50679
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
	jne	%g6, %g5, jeq_else.50680
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
	jmp	jeq_cont.50681
jeq_else.50680:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.50682
	jmp	jle_cont.50683
jle_else.50682:
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
	jne	%g5, %g0, jeq_else.50684
	fmov	%f3, %f4
	jmp	jeq_cont.50685
jeq_else.50684:
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
jeq_cont.50685:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.50686
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.50687
jeq_else.50686:
	fmov	%f0, %f3
jeq_cont.50687:
	fsti	%f0, %g7, -12
jle_cont.50683:
jeq_cont.50681:
	subi	%g4, %g8, 1
	jmp	setup_startp_constants.2806
jge_else.50679:
	return
jge_else.50670:
	return

!==============================
! args = [%g5, %g4]
! fargs = [%f5, %f4, %f3]
! use_regs = [%g7, %g6, %g5, %g4, %g3, %g27, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0]
! ret type = Bool
!================================
check_all_inside.2831:
	slli	%g3, %g5, 2
	ld	%g6, %g4, %g3
	jne	%g6, %g29, jeq_else.50690
	addi	%g3, %g0, 1
	return
jeq_else.50690:
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
	jne	%g6, %g28, jeq_else.50691
	fjlt	%f0, %f16, fjge_else.50693
	fmov	%f6, %f0
	jmp	fjge_cont.50694
fjge_else.50693:
	fneg	%f6, %f0
fjge_cont.50694:
	ldi	%g3, %g7, -16
	fldi	%f0, %g3, 0
	fjlt	%f6, %f0, fjge_else.50695
	addi	%g6, %g0, 0
	jmp	fjge_cont.50696
fjge_else.50695:
	fjlt	%f2, %f16, fjge_else.50697
	fmov	%f0, %f2
	jmp	fjge_cont.50698
fjge_else.50697:
	fneg	%f0, %f2
fjge_cont.50698:
	fldi	%f2, %g3, -4
	fjlt	%f0, %f2, fjge_else.50699
	addi	%g6, %g0, 0
	jmp	fjge_cont.50700
fjge_else.50699:
	fjlt	%f1, %f16, fjge_else.50701
	fmov	%f0, %f1
	jmp	fjge_cont.50702
fjge_else.50701:
	fneg	%f0, %f1
fjge_cont.50702:
	fldi	%f1, %g3, -8
	fjlt	%f0, %f1, fjge_else.50703
	addi	%g6, %g0, 0
	jmp	fjge_cont.50704
fjge_else.50703:
	addi	%g6, %g0, 1
fjge_cont.50704:
fjge_cont.50700:
fjge_cont.50696:
	jne	%g6, %g0, jeq_else.50705
	ldi	%g3, %g7, -24
	jne	%g3, %g0, jeq_else.50707
	addi	%g3, %g0, 1
	jmp	jeq_cont.50708
jeq_else.50707:
	addi	%g3, %g0, 0
jeq_cont.50708:
	jmp	jeq_cont.50706
jeq_else.50705:
	ldi	%g3, %g7, -24
jeq_cont.50706:
	jmp	jeq_cont.50692
jeq_else.50691:
	addi	%g3, %g0, 2
	jne	%g6, %g3, jeq_else.50709
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
	fjlt	%f0, %f16, fjge_else.50711
	addi	%g6, %g0, 0
	jmp	fjge_cont.50712
fjge_else.50711:
	addi	%g6, %g0, 1
fjge_cont.50712:
	jne	%g3, %g6, jeq_else.50713
	addi	%g3, %g0, 1
	jmp	jeq_cont.50714
jeq_else.50713:
	addi	%g3, %g0, 0
jeq_cont.50714:
	jmp	jeq_cont.50710
jeq_else.50709:
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
	jne	%g3, %g0, jeq_else.50715
	fmov	%f6, %f7
	jmp	jeq_cont.50716
jeq_else.50715:
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
jeq_cont.50716:
	addi	%g3, %g0, 3
	jne	%g6, %g3, jeq_else.50717
	fsub	%f0, %f6, %f17
	jmp	jeq_cont.50718
jeq_else.50717:
	fmov	%f0, %f6
jeq_cont.50718:
	ldi	%g3, %g7, -24
	fjlt	%f0, %f16, fjge_else.50719
	addi	%g6, %g0, 0
	jmp	fjge_cont.50720
fjge_else.50719:
	addi	%g6, %g0, 1
fjge_cont.50720:
	jne	%g3, %g6, jeq_else.50721
	addi	%g3, %g0, 1
	jmp	jeq_cont.50722
jeq_else.50721:
	addi	%g3, %g0, 0
jeq_cont.50722:
jeq_cont.50710:
jeq_cont.50692:
	jne	%g3, %g0, jeq_else.50723
	addi	%g7, %g5, 1
	slli	%g3, %g7, 2
	ld	%g5, %g4, %g3
	jne	%g5, %g29, jeq_else.50724
	addi	%g3, %g0, 1
	return
jeq_else.50724:
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
	jne	%g5, %g28, jeq_else.50725
	fjlt	%f0, %f16, fjge_else.50727
	fmov	%f6, %f0
	jmp	fjge_cont.50728
fjge_else.50727:
	fneg	%f6, %f0
fjge_cont.50728:
	ldi	%g3, %g6, -16
	fldi	%f0, %g3, 0
	fjlt	%f6, %f0, fjge_else.50729
	addi	%g5, %g0, 0
	jmp	fjge_cont.50730
fjge_else.50729:
	fjlt	%f2, %f16, fjge_else.50731
	fmov	%f0, %f2
	jmp	fjge_cont.50732
fjge_else.50731:
	fneg	%f0, %f2
fjge_cont.50732:
	fldi	%f2, %g3, -4
	fjlt	%f0, %f2, fjge_else.50733
	addi	%g5, %g0, 0
	jmp	fjge_cont.50734
fjge_else.50733:
	fjlt	%f1, %f16, fjge_else.50735
	fmov	%f0, %f1
	jmp	fjge_cont.50736
fjge_else.50735:
	fneg	%f0, %f1
fjge_cont.50736:
	fldi	%f1, %g3, -8
	fjlt	%f0, %f1, fjge_else.50737
	addi	%g5, %g0, 0
	jmp	fjge_cont.50738
fjge_else.50737:
	addi	%g5, %g0, 1
fjge_cont.50738:
fjge_cont.50734:
fjge_cont.50730:
	jne	%g5, %g0, jeq_else.50739
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.50741
	addi	%g3, %g0, 1
	jmp	jeq_cont.50742
jeq_else.50741:
	addi	%g3, %g0, 0
jeq_cont.50742:
	jmp	jeq_cont.50740
jeq_else.50739:
	ldi	%g3, %g6, -24
jeq_cont.50740:
	jmp	jeq_cont.50726
jeq_else.50725:
	addi	%g3, %g0, 2
	jne	%g5, %g3, jeq_else.50743
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
	fjlt	%f0, %f16, fjge_else.50745
	addi	%g5, %g0, 0
	jmp	fjge_cont.50746
fjge_else.50745:
	addi	%g5, %g0, 1
fjge_cont.50746:
	jne	%g3, %g5, jeq_else.50747
	addi	%g3, %g0, 1
	jmp	jeq_cont.50748
jeq_else.50747:
	addi	%g3, %g0, 0
jeq_cont.50748:
	jmp	jeq_cont.50744
jeq_else.50743:
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
	jne	%g3, %g0, jeq_else.50749
	fmov	%f6, %f7
	jmp	jeq_cont.50750
jeq_else.50749:
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
jeq_cont.50750:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.50751
	fsub	%f0, %f6, %f17
	jmp	jeq_cont.50752
jeq_else.50751:
	fmov	%f0, %f6
jeq_cont.50752:
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.50753
	addi	%g5, %g0, 0
	jmp	fjge_cont.50754
fjge_else.50753:
	addi	%g5, %g0, 1
fjge_cont.50754:
	jne	%g3, %g5, jeq_else.50755
	addi	%g3, %g0, 1
	jmp	jeq_cont.50756
jeq_else.50755:
	addi	%g3, %g0, 0
jeq_cont.50756:
jeq_cont.50744:
jeq_cont.50726:
	jne	%g3, %g0, jeq_else.50757
	addi	%g5, %g7, 1
	jmp	check_all_inside.2831
jeq_else.50757:
	addi	%g3, %g0, 0
	return
jeq_else.50723:
	addi	%g3, %g0, 0
	return

!==============================
! args = [%g8, %g4]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Bool
!================================
shadow_check_and_group.2837:
	slli	%g3, %g8, 2
	ld	%g9, %g4, %g3
	jne	%g9, %g29, jeq_else.50758
	addi	%g3, %g0, 0
	return
jeq_else.50758:
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
	jne	%g5, %g28, jeq_else.50759
	fldi	%f0, %g7, 0
	fsub	%f0, %f0, %f3
	fldi	%f1, %g7, -4
	fmul	%f0, %f0, %f1
	fldi	%f5, %g31, 728
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f4
	fjlt	%f6, %f16, fjge_else.50761
	fmov	%f5, %f6
	jmp	fjge_cont.50762
fjge_else.50761:
	fneg	%f5, %f6
fjge_cont.50762:
	ldi	%g5, %g6, -16
	fldi	%f6, %g5, -4
	fjlt	%f5, %f6, fjge_else.50763
	addi	%g3, %g0, 0
	jmp	fjge_cont.50764
fjge_else.50763:
	fldi	%f5, %g31, 724
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f2
	fjlt	%f6, %f16, fjge_else.50765
	fmov	%f5, %f6
	jmp	fjge_cont.50766
fjge_else.50765:
	fneg	%f5, %f6
fjge_cont.50766:
	fldi	%f6, %g5, -8
	fjlt	%f5, %f6, fjge_else.50767
	addi	%g3, %g0, 0
	jmp	fjge_cont.50768
fjge_else.50767:
	fjeq	%f1, %f16, fjne_else.50769
	addi	%g3, %g0, 1
	jmp	fjne_cont.50770
fjne_else.50769:
	addi	%g3, %g0, 0
fjne_cont.50770:
fjge_cont.50768:
fjge_cont.50764:
	jne	%g3, %g0, jeq_else.50771
	fldi	%f0, %g7, -8
	fsub	%f0, %f0, %f4
	fldi	%f1, %g7, -12
	fmul	%f0, %f0, %f1
	fldi	%f5, %g31, 732
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f3
	fjlt	%f6, %f16, fjge_else.50773
	fmov	%f5, %f6
	jmp	fjge_cont.50774
fjge_else.50773:
	fneg	%f5, %f6
fjge_cont.50774:
	fldi	%f6, %g5, 0
	fjlt	%f5, %f6, fjge_else.50775
	addi	%g3, %g0, 0
	jmp	fjge_cont.50776
fjge_else.50775:
	fldi	%f5, %g31, 724
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f2
	fjlt	%f6, %f16, fjge_else.50777
	fmov	%f5, %f6
	jmp	fjge_cont.50778
fjge_else.50777:
	fneg	%f5, %f6
fjge_cont.50778:
	fldi	%f6, %g5, -8
	fjlt	%f5, %f6, fjge_else.50779
	addi	%g3, %g0, 0
	jmp	fjge_cont.50780
fjge_else.50779:
	fjeq	%f1, %f16, fjne_else.50781
	addi	%g3, %g0, 1
	jmp	fjne_cont.50782
fjne_else.50781:
	addi	%g3, %g0, 0
fjne_cont.50782:
fjge_cont.50780:
fjge_cont.50776:
	jne	%g3, %g0, jeq_else.50783
	fldi	%f0, %g7, -16
	fsub	%f1, %f0, %f2
	fldi	%f0, %g7, -20
	fmul	%f5, %f1, %f0
	fldi	%f1, %g31, 732
	fmul	%f1, %f5, %f1
	fadd	%f2, %f1, %f3
	fjlt	%f2, %f16, fjge_else.50785
	fmov	%f1, %f2
	jmp	fjge_cont.50786
fjge_else.50785:
	fneg	%f1, %f2
fjge_cont.50786:
	fldi	%f2, %g5, 0
	fjlt	%f1, %f2, fjge_else.50787
	addi	%g3, %g0, 0
	jmp	fjge_cont.50788
fjge_else.50787:
	fldi	%f1, %g31, 728
	fmul	%f1, %f5, %f1
	fadd	%f2, %f1, %f4
	fjlt	%f2, %f16, fjge_else.50789
	fmov	%f1, %f2
	jmp	fjge_cont.50790
fjge_else.50789:
	fneg	%f1, %f2
fjge_cont.50790:
	fldi	%f2, %g5, -4
	fjlt	%f1, %f2, fjge_else.50791
	addi	%g3, %g0, 0
	jmp	fjge_cont.50792
fjge_else.50791:
	fjeq	%f0, %f16, fjne_else.50793
	addi	%g3, %g0, 1
	jmp	fjne_cont.50794
fjne_else.50793:
	addi	%g3, %g0, 0
fjne_cont.50794:
fjge_cont.50792:
fjge_cont.50788:
	jne	%g3, %g0, jeq_else.50795
	addi	%g3, %g0, 0
	jmp	jeq_cont.50796
jeq_else.50795:
	fsti	%f5, %g31, 520
	addi	%g3, %g0, 3
jeq_cont.50796:
	jmp	jeq_cont.50784
jeq_else.50783:
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 2
jeq_cont.50784:
	jmp	jeq_cont.50772
jeq_else.50771:
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 1
jeq_cont.50772:
	jmp	jeq_cont.50760
jeq_else.50759:
	addi	%g3, %g0, 2
	jne	%g5, %g3, jeq_else.50797
	fldi	%f0, %g7, 0
	fjlt	%f0, %f16, fjge_else.50799
	addi	%g3, %g0, 0
	jmp	fjge_cont.50800
fjge_else.50799:
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
fjge_cont.50800:
	jmp	jeq_cont.50798
jeq_else.50797:
	fldi	%f0, %g7, 0
	fjeq	%f0, %f16, fjne_else.50801
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
	jne	%g3, %g0, jeq_else.50803
	fmov	%f5, %f6
	jmp	jeq_cont.50804
jeq_else.50803:
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
jeq_cont.50804:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.50805
	fsub	%f2, %f5, %f17
	jmp	jeq_cont.50806
jeq_else.50805:
	fmov	%f2, %f5
jeq_cont.50806:
	fmul	%f3, %f1, %f1
	fmul	%f0, %f0, %f2
	fsub	%f0, %f3, %f0
	fjlt	%f16, %f0, fjge_else.50807
	addi	%g3, %g0, 0
	jmp	fjge_cont.50808
fjge_else.50807:
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.50809
	fsqrt	%f0, %f0
	fsub	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	jmp	jeq_cont.50810
jeq_else.50809:
	fsqrt	%f0, %f0
	fadd	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
jeq_cont.50810:
	addi	%g3, %g0, 1
fjge_cont.50808:
	jmp	fjne_cont.50802
fjne_else.50801:
	addi	%g3, %g0, 0
fjne_cont.50802:
jeq_cont.50798:
jeq_cont.50760:
	fldi	%f0, %g31, 520
	jne	%g3, %g0, jeq_else.50811
	addi	%g3, %g0, 0
	jmp	jeq_cont.50812
jeq_else.50811:
	setL %g3, l.44093
	fldi	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.50813
	addi	%g3, %g0, 0
	jmp	fjge_cont.50814
fjge_else.50813:
	addi	%g3, %g0, 1
fjge_cont.50814:
jeq_cont.50812:
	jne	%g3, %g0, jeq_else.50815
	slli	%g3, %g9, 2
	add	%g3, %g31, %g3
	ldi	%g3, %g3, 272
	ldi	%g3, %g3, -24
	jne	%g3, %g0, jeq_else.50816
	addi	%g3, %g0, 0
	return
jeq_else.50816:
	addi	%g8, %g8, 1
	jmp	shadow_check_and_group.2837
jeq_else.50815:
	setL %g3, l.44095
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
	jne	%g5, %g29, jeq_else.50817
	addi	%g3, %g0, 1
	jmp	jeq_cont.50818
jeq_else.50817:
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
	jne	%g5, %g28, jeq_else.50819
	fjlt	%f0, %f16, fjge_else.50821
	fmov	%f6, %f0
	jmp	fjge_cont.50822
fjge_else.50821:
	fneg	%f6, %f0
fjge_cont.50822:
	ldi	%g3, %g6, -16
	fldi	%f0, %g3, 0
	fjlt	%f6, %f0, fjge_else.50823
	addi	%g5, %g0, 0
	jmp	fjge_cont.50824
fjge_else.50823:
	fjlt	%f2, %f16, fjge_else.50825
	fmov	%f0, %f2
	jmp	fjge_cont.50826
fjge_else.50825:
	fneg	%f0, %f2
fjge_cont.50826:
	fldi	%f2, %g3, -4
	fjlt	%f0, %f2, fjge_else.50827
	addi	%g5, %g0, 0
	jmp	fjge_cont.50828
fjge_else.50827:
	fjlt	%f1, %f16, fjge_else.50829
	fmov	%f0, %f1
	jmp	fjge_cont.50830
fjge_else.50829:
	fneg	%f0, %f1
fjge_cont.50830:
	fldi	%f1, %g3, -8
	fjlt	%f0, %f1, fjge_else.50831
	addi	%g5, %g0, 0
	jmp	fjge_cont.50832
fjge_else.50831:
	addi	%g5, %g0, 1
fjge_cont.50832:
fjge_cont.50828:
fjge_cont.50824:
	jne	%g5, %g0, jeq_else.50833
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.50835
	addi	%g3, %g0, 1
	jmp	jeq_cont.50836
jeq_else.50835:
	addi	%g3, %g0, 0
jeq_cont.50836:
	jmp	jeq_cont.50834
jeq_else.50833:
	ldi	%g3, %g6, -24
jeq_cont.50834:
	jmp	jeq_cont.50820
jeq_else.50819:
	addi	%g3, %g0, 2
	jne	%g5, %g3, jeq_else.50837
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
	fjlt	%f0, %f16, fjge_else.50839
	addi	%g5, %g0, 0
	jmp	fjge_cont.50840
fjge_else.50839:
	addi	%g5, %g0, 1
fjge_cont.50840:
	jne	%g3, %g5, jeq_else.50841
	addi	%g3, %g0, 1
	jmp	jeq_cont.50842
jeq_else.50841:
	addi	%g3, %g0, 0
jeq_cont.50842:
	jmp	jeq_cont.50838
jeq_else.50837:
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
	jne	%g3, %g0, jeq_else.50843
	fmov	%f6, %f7
	jmp	jeq_cont.50844
jeq_else.50843:
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
jeq_cont.50844:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.50845
	fsub	%f0, %f6, %f17
	jmp	jeq_cont.50846
jeq_else.50845:
	fmov	%f0, %f6
jeq_cont.50846:
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.50847
	addi	%g5, %g0, 0
	jmp	fjge_cont.50848
fjge_else.50847:
	addi	%g5, %g0, 1
fjge_cont.50848:
	jne	%g3, %g5, jeq_else.50849
	addi	%g3, %g0, 1
	jmp	jeq_cont.50850
jeq_else.50849:
	addi	%g3, %g0, 0
jeq_cont.50850:
jeq_cont.50838:
jeq_cont.50820:
	jne	%g3, %g0, jeq_else.50851
	addi	%g5, %g0, 1
	subi	%g1, %g1, 8
	call	check_all_inside.2831
	addi	%g1, %g1, 8
	jmp	jeq_cont.50852
jeq_else.50851:
	addi	%g3, %g0, 0
jeq_cont.50852:
jeq_cont.50818:
	jne	%g3, %g0, jeq_else.50853
	addi	%g8, %g8, 1
	ldi	%g4, %g1, 0
	jmp	shadow_check_and_group.2837
jeq_else.50853:
	addi	%g3, %g0, 1
	return

!==============================
! args = [%g11, %g10]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g11, %g10, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Bool
!================================
shadow_check_one_or_group.2840:
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.50854
	addi	%g3, %g0, 0
	return
jeq_else.50854:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.50855
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.50856
	addi	%g3, %g0, 0
	return
jeq_else.50856:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.50857
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.50858
	addi	%g3, %g0, 0
	return
jeq_else.50858:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.50859
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.50860
	addi	%g3, %g0, 0
	return
jeq_else.50860:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.50861
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.50862
	addi	%g3, %g0, 0
	return
jeq_else.50862:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.50863
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.50864
	addi	%g3, %g0, 0
	return
jeq_else.50864:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.50865
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.50866
	addi	%g3, %g0, 0
	return
jeq_else.50866:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.50867
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.50868
	addi	%g3, %g0, 0
	return
jeq_else.50868:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.50869
	addi	%g11, %g11, 1
	jmp	shadow_check_one_or_group.2840
jeq_else.50869:
	addi	%g3, %g0, 1
	return
jeq_else.50867:
	addi	%g3, %g0, 1
	return
jeq_else.50865:
	addi	%g3, %g0, 1
	return
jeq_else.50863:
	addi	%g3, %g0, 1
	return
jeq_else.50861:
	addi	%g3, %g0, 1
	return
jeq_else.50859:
	addi	%g3, %g0, 1
	return
jeq_else.50857:
	addi	%g3, %g0, 1
	return
jeq_else.50855:
	addi	%g3, %g0, 1
	return

!==============================
! args = [%g12, %g13]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g13, %g12, %g11, %g10, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Bool
!================================
shadow_check_one_or_matrix.2843:
	slli	%g3, %g12, 2
	ld	%g10, %g13, %g3
	ldi	%g4, %g10, 0
	jne	%g4, %g29, jeq_else.50870
	addi	%g3, %g0, 0
	return
jeq_else.50870:
	addi	%g3, %g0, 99
	sti	%g10, %g1, 0
	jne	%g4, %g3, jeq_else.50871
	addi	%g3, %g0, 1
	jmp	jeq_cont.50872
jeq_else.50871:
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
	jne	%g4, %g28, jeq_else.50873
	fldi	%f0, %g6, 0
	fsub	%f2, %f0, %f3
	fldi	%f0, %g6, -4
	fmul	%f6, %f2, %f0
	fldi	%f2, %g31, 728
	fmul	%f2, %f6, %f2
	fadd	%f5, %f2, %f4
	fjlt	%f5, %f16, fjge_else.50875
	fmov	%f2, %f5
	jmp	fjge_cont.50876
fjge_else.50875:
	fneg	%f2, %f5
fjge_cont.50876:
	ldi	%g4, %g5, -16
	fldi	%f5, %g4, -4
	fjlt	%f2, %f5, fjge_else.50877
	addi	%g3, %g0, 0
	jmp	fjge_cont.50878
fjge_else.50877:
	fldi	%f2, %g31, 724
	fmul	%f2, %f6, %f2
	fadd	%f5, %f2, %f1
	fjlt	%f5, %f16, fjge_else.50879
	fmov	%f2, %f5
	jmp	fjge_cont.50880
fjge_else.50879:
	fneg	%f2, %f5
fjge_cont.50880:
	fldi	%f5, %g4, -8
	fjlt	%f2, %f5, fjge_else.50881
	addi	%g3, %g0, 0
	jmp	fjge_cont.50882
fjge_else.50881:
	fjeq	%f0, %f16, fjne_else.50883
	addi	%g3, %g0, 1
	jmp	fjne_cont.50884
fjne_else.50883:
	addi	%g3, %g0, 0
fjne_cont.50884:
fjge_cont.50882:
fjge_cont.50878:
	jne	%g3, %g0, jeq_else.50885
	fldi	%f0, %g6, -8
	fsub	%f0, %f0, %f4
	fldi	%f6, %g6, -12
	fmul	%f5, %f0, %f6
	fldi	%f0, %g31, 732
	fmul	%f0, %f5, %f0
	fadd	%f2, %f0, %f3
	fjlt	%f2, %f16, fjge_else.50887
	fmov	%f0, %f2
	jmp	fjge_cont.50888
fjge_else.50887:
	fneg	%f0, %f2
fjge_cont.50888:
	fldi	%f2, %g4, 0
	fjlt	%f0, %f2, fjge_else.50889
	addi	%g3, %g0, 0
	jmp	fjge_cont.50890
fjge_else.50889:
	fldi	%f0, %g31, 724
	fmul	%f0, %f5, %f0
	fadd	%f2, %f0, %f1
	fjlt	%f2, %f16, fjge_else.50891
	fmov	%f0, %f2
	jmp	fjge_cont.50892
fjge_else.50891:
	fneg	%f0, %f2
fjge_cont.50892:
	fldi	%f2, %g4, -8
	fjlt	%f0, %f2, fjge_else.50893
	addi	%g3, %g0, 0
	jmp	fjge_cont.50894
fjge_else.50893:
	fjeq	%f6, %f16, fjne_else.50895
	addi	%g3, %g0, 1
	jmp	fjne_cont.50896
fjne_else.50895:
	addi	%g3, %g0, 0
fjne_cont.50896:
fjge_cont.50894:
fjge_cont.50890:
	jne	%g3, %g0, jeq_else.50897
	fldi	%f0, %g6, -16
	fsub	%f0, %f0, %f1
	fldi	%f5, %g6, -20
	fmul	%f2, %f0, %f5
	fldi	%f0, %g31, 732
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f3
	fjlt	%f1, %f16, fjge_else.50899
	fmov	%f0, %f1
	jmp	fjge_cont.50900
fjge_else.50899:
	fneg	%f0, %f1
fjge_cont.50900:
	fldi	%f1, %g4, 0
	fjlt	%f0, %f1, fjge_else.50901
	addi	%g3, %g0, 0
	jmp	fjge_cont.50902
fjge_else.50901:
	fldi	%f0, %g31, 728
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f4
	fjlt	%f1, %f16, fjge_else.50903
	fmov	%f0, %f1
	jmp	fjge_cont.50904
fjge_else.50903:
	fneg	%f0, %f1
fjge_cont.50904:
	fldi	%f1, %g4, -4
	fjlt	%f0, %f1, fjge_else.50905
	addi	%g3, %g0, 0
	jmp	fjge_cont.50906
fjge_else.50905:
	fjeq	%f5, %f16, fjne_else.50907
	addi	%g3, %g0, 1
	jmp	fjne_cont.50908
fjne_else.50907:
	addi	%g3, %g0, 0
fjne_cont.50908:
fjge_cont.50906:
fjge_cont.50902:
	jne	%g3, %g0, jeq_else.50909
	addi	%g3, %g0, 0
	jmp	jeq_cont.50910
jeq_else.50909:
	fsti	%f2, %g31, 520
	addi	%g3, %g0, 3
jeq_cont.50910:
	jmp	jeq_cont.50898
jeq_else.50897:
	fsti	%f5, %g31, 520
	addi	%g3, %g0, 2
jeq_cont.50898:
	jmp	jeq_cont.50886
jeq_else.50885:
	fsti	%f6, %g31, 520
	addi	%g3, %g0, 1
jeq_cont.50886:
	jmp	jeq_cont.50874
jeq_else.50873:
	addi	%g3, %g0, 2
	jne	%g4, %g3, jeq_else.50911
	fldi	%f0, %g6, 0
	fjlt	%f0, %f16, fjge_else.50913
	addi	%g3, %g0, 0
	jmp	fjge_cont.50914
fjge_else.50913:
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
fjge_cont.50914:
	jmp	jeq_cont.50912
jeq_else.50911:
	fldi	%f0, %g6, 0
	fjeq	%f0, %f16, fjne_else.50915
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
	jne	%g3, %g0, jeq_else.50917
	fmov	%f5, %f6
	jmp	jeq_cont.50918
jeq_else.50917:
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
jeq_cont.50918:
	addi	%g3, %g0, 3
	jne	%g4, %g3, jeq_else.50919
	fsub	%f1, %f5, %f17
	jmp	jeq_cont.50920
jeq_else.50919:
	fmov	%f1, %f5
jeq_cont.50920:
	fmul	%f3, %f2, %f2
	fmul	%f0, %f0, %f1
	fsub	%f0, %f3, %f0
	fjlt	%f16, %f0, fjge_else.50921
	addi	%g3, %g0, 0
	jmp	fjge_cont.50922
fjge_else.50921:
	ldi	%g3, %g5, -24
	jne	%g3, %g0, jeq_else.50923
	fsqrt	%f0, %f0
	fsub	%f1, %f2, %f0
	fldi	%f0, %g6, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	jmp	jeq_cont.50924
jeq_else.50923:
	fsqrt	%f0, %f0
	fadd	%f1, %f2, %f0
	fldi	%f0, %g6, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
jeq_cont.50924:
	addi	%g3, %g0, 1
fjge_cont.50922:
	jmp	fjne_cont.50916
fjne_else.50915:
	addi	%g3, %g0, 0
fjne_cont.50916:
jeq_cont.50912:
jeq_cont.50874:
	jne	%g3, %g0, jeq_else.50925
	addi	%g3, %g0, 0
	jmp	jeq_cont.50926
jeq_else.50925:
	fldi	%f1, %g31, 520
	setL %g3, l.44281
	fldi	%f0, %g3, 0
	fjlt	%f1, %f0, fjge_else.50927
	addi	%g3, %g0, 0
	jmp	fjge_cont.50928
fjge_else.50927:
	ldi	%g4, %g10, -4
	jne	%g4, %g29, jeq_else.50929
	addi	%g3, %g0, 0
	jmp	jeq_cont.50930
jeq_else.50929:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.50931
	ldi	%g4, %g10, -8
	jne	%g4, %g29, jeq_else.50933
	addi	%g3, %g0, 0
	jmp	jeq_cont.50934
jeq_else.50933:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.50935
	ldi	%g4, %g10, -12
	jne	%g4, %g29, jeq_else.50937
	addi	%g3, %g0, 0
	jmp	jeq_cont.50938
jeq_else.50937:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.50939
	ldi	%g4, %g10, -16
	jne	%g4, %g29, jeq_else.50941
	addi	%g3, %g0, 0
	jmp	jeq_cont.50942
jeq_else.50941:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.50943
	ldi	%g4, %g10, -20
	jne	%g4, %g29, jeq_else.50945
	addi	%g3, %g0, 0
	jmp	jeq_cont.50946
jeq_else.50945:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.50947
	ldi	%g4, %g10, -24
	jne	%g4, %g29, jeq_else.50949
	addi	%g3, %g0, 0
	jmp	jeq_cont.50950
jeq_else.50949:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.50951
	ldi	%g4, %g10, -28
	jne	%g4, %g29, jeq_else.50953
	addi	%g3, %g0, 0
	jmp	jeq_cont.50954
jeq_else.50953:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.50955
	addi	%g11, %g0, 8
	subi	%g1, %g1, 8
	call	shadow_check_one_or_group.2840
	addi	%g1, %g1, 8
	jmp	jeq_cont.50956
jeq_else.50955:
	addi	%g3, %g0, 1
jeq_cont.50956:
jeq_cont.50954:
	jmp	jeq_cont.50952
jeq_else.50951:
	addi	%g3, %g0, 1
jeq_cont.50952:
jeq_cont.50950:
	jmp	jeq_cont.50948
jeq_else.50947:
	addi	%g3, %g0, 1
jeq_cont.50948:
jeq_cont.50946:
	jmp	jeq_cont.50944
jeq_else.50943:
	addi	%g3, %g0, 1
jeq_cont.50944:
jeq_cont.50942:
	jmp	jeq_cont.50940
jeq_else.50939:
	addi	%g3, %g0, 1
jeq_cont.50940:
jeq_cont.50938:
	jmp	jeq_cont.50936
jeq_else.50935:
	addi	%g3, %g0, 1
jeq_cont.50936:
jeq_cont.50934:
	jmp	jeq_cont.50932
jeq_else.50931:
	addi	%g3, %g0, 1
jeq_cont.50932:
jeq_cont.50930:
	jne	%g3, %g0, jeq_else.50957
	addi	%g3, %g0, 0
	jmp	jeq_cont.50958
jeq_else.50957:
	addi	%g3, %g0, 1
jeq_cont.50958:
fjge_cont.50928:
jeq_cont.50926:
jeq_cont.50872:
	jne	%g3, %g0, jeq_else.50959
	addi	%g12, %g12, 1
	jmp	shadow_check_one_or_matrix.2843
jeq_else.50959:
	ldi	%g10, %g1, 0
	ldi	%g4, %g10, -4
	jne	%g4, %g29, jeq_else.50960
	addi	%g3, %g0, 0
	jmp	jeq_cont.50961
jeq_else.50960:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.50962
	ldi	%g4, %g10, -8
	jne	%g4, %g29, jeq_else.50964
	addi	%g3, %g0, 0
	jmp	jeq_cont.50965
jeq_else.50964:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.50966
	ldi	%g4, %g10, -12
	jne	%g4, %g29, jeq_else.50968
	addi	%g3, %g0, 0
	jmp	jeq_cont.50969
jeq_else.50968:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.50970
	ldi	%g4, %g10, -16
	jne	%g4, %g29, jeq_else.50972
	addi	%g3, %g0, 0
	jmp	jeq_cont.50973
jeq_else.50972:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.50974
	ldi	%g4, %g10, -20
	jne	%g4, %g29, jeq_else.50976
	addi	%g3, %g0, 0
	jmp	jeq_cont.50977
jeq_else.50976:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.50978
	ldi	%g4, %g10, -24
	jne	%g4, %g29, jeq_else.50980
	addi	%g3, %g0, 0
	jmp	jeq_cont.50981
jeq_else.50980:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.50982
	ldi	%g4, %g10, -28
	jne	%g4, %g29, jeq_else.50984
	addi	%g3, %g0, 0
	jmp	jeq_cont.50985
jeq_else.50984:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.50986
	addi	%g11, %g0, 8
	subi	%g1, %g1, 8
	call	shadow_check_one_or_group.2840
	addi	%g1, %g1, 8
	jmp	jeq_cont.50987
jeq_else.50986:
	addi	%g3, %g0, 1
jeq_cont.50987:
jeq_cont.50985:
	jmp	jeq_cont.50983
jeq_else.50982:
	addi	%g3, %g0, 1
jeq_cont.50983:
jeq_cont.50981:
	jmp	jeq_cont.50979
jeq_else.50978:
	addi	%g3, %g0, 1
jeq_cont.50979:
jeq_cont.50977:
	jmp	jeq_cont.50975
jeq_else.50974:
	addi	%g3, %g0, 1
jeq_cont.50975:
jeq_cont.50973:
	jmp	jeq_cont.50971
jeq_else.50970:
	addi	%g3, %g0, 1
jeq_cont.50971:
jeq_cont.50969:
	jmp	jeq_cont.50967
jeq_else.50966:
	addi	%g3, %g0, 1
jeq_cont.50967:
jeq_cont.50965:
	jmp	jeq_cont.50963
jeq_else.50962:
	addi	%g3, %g0, 1
jeq_cont.50963:
jeq_cont.50961:
	jne	%g3, %g0, jeq_else.50988
	addi	%g12, %g12, 1
	jmp	shadow_check_one_or_matrix.2843
jeq_else.50988:
	addi	%g3, %g0, 1
	return

!==============================
! args = [%g11, %g4, %g9]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f2, %f17, %f16, %f15, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
solve_each_element.2846:
	slli	%g3, %g11, 2
	ld	%g10, %g4, %g3
	jne	%g10, %g29, jeq_else.50989
	return
jeq_else.50989:
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
	jne	%g3, %g28, jeq_else.50991
	fldi	%f2, %g9, 0
	fjeq	%f2, %f16, fjne_else.50993
	ldi	%g5, %g7, -16
	ldi	%g3, %g7, -24
	fjlt	%f2, %f16, fjge_else.50995
	addi	%g6, %g0, 0
	jmp	fjge_cont.50996
fjge_else.50995:
	addi	%g6, %g0, 1
fjge_cont.50996:
	fldi	%f1, %g5, 0
	jne	%g3, %g6, jeq_else.50997
	fneg	%f0, %f1
	jmp	jeq_cont.50998
jeq_else.50997:
	fmov	%f0, %f1
jeq_cont.50998:
	fsub	%f0, %f0, %f6
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, -4
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f7
	fjlt	%f1, %f16, fjge_else.50999
	fmov	%f0, %f1
	jmp	fjge_cont.51000
fjge_else.50999:
	fneg	%f0, %f1
fjge_cont.51000:
	fldi	%f1, %g5, -4
	fjlt	%f0, %f1, fjge_else.51001
	addi	%g8, %g0, 0
	jmp	fjge_cont.51002
fjge_else.51001:
	fldi	%f0, %g9, -8
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f5
	fjlt	%f1, %f16, fjge_else.51003
	fmov	%f0, %f1
	jmp	fjge_cont.51004
fjge_else.51003:
	fneg	%f0, %f1
fjge_cont.51004:
	fldi	%f1, %g5, -8
	fjlt	%f0, %f1, fjge_else.51005
	addi	%g8, %g0, 0
	jmp	fjge_cont.51006
fjge_else.51005:
	fsti	%f2, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.51006:
fjge_cont.51002:
	jmp	fjne_cont.50994
fjne_else.50993:
	addi	%g8, %g0, 0
fjne_cont.50994:
	jne	%g8, %g0, jeq_else.51007
	fldi	%f2, %g9, -4
	fjeq	%f2, %f16, fjne_else.51009
	ldi	%g5, %g7, -16
	ldi	%g3, %g7, -24
	fjlt	%f2, %f16, fjge_else.51011
	addi	%g6, %g0, 0
	jmp	fjge_cont.51012
fjge_else.51011:
	addi	%g6, %g0, 1
fjge_cont.51012:
	fldi	%f1, %g5, -4
	jne	%g3, %g6, jeq_else.51013
	fneg	%f0, %f1
	jmp	jeq_cont.51014
jeq_else.51013:
	fmov	%f0, %f1
jeq_cont.51014:
	fsub	%f0, %f0, %f7
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, -8
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f5
	fjlt	%f1, %f16, fjge_else.51015
	fmov	%f0, %f1
	jmp	fjge_cont.51016
fjge_else.51015:
	fneg	%f0, %f1
fjge_cont.51016:
	fldi	%f1, %g5, -8
	fjlt	%f0, %f1, fjge_else.51017
	addi	%g8, %g0, 0
	jmp	fjge_cont.51018
fjge_else.51017:
	fldi	%f0, %g9, 0
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f6
	fjlt	%f1, %f16, fjge_else.51019
	fmov	%f0, %f1
	jmp	fjge_cont.51020
fjge_else.51019:
	fneg	%f0, %f1
fjge_cont.51020:
	fldi	%f1, %g5, 0
	fjlt	%f0, %f1, fjge_else.51021
	addi	%g8, %g0, 0
	jmp	fjge_cont.51022
fjge_else.51021:
	fsti	%f2, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.51022:
fjge_cont.51018:
	jmp	fjne_cont.51010
fjne_else.51009:
	addi	%g8, %g0, 0
fjne_cont.51010:
	jne	%g8, %g0, jeq_else.51023
	fldi	%f2, %g9, -8
	fjeq	%f2, %f16, fjne_else.51025
	ldi	%g5, %g7, -16
	ldi	%g3, %g7, -24
	fjlt	%f2, %f16, fjge_else.51027
	addi	%g6, %g0, 0
	jmp	fjge_cont.51028
fjge_else.51027:
	addi	%g6, %g0, 1
fjge_cont.51028:
	fldi	%f1, %g5, -8
	jne	%g3, %g6, jeq_else.51029
	fneg	%f0, %f1
	jmp	jeq_cont.51030
jeq_else.51029:
	fmov	%f0, %f1
jeq_cont.51030:
	fsub	%f0, %f0, %f5
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, 0
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f6
	fjlt	%f1, %f16, fjge_else.51031
	fmov	%f0, %f1
	jmp	fjge_cont.51032
fjge_else.51031:
	fneg	%f0, %f1
fjge_cont.51032:
	fldi	%f1, %g5, 0
	fjlt	%f0, %f1, fjge_else.51033
	addi	%g8, %g0, 0
	jmp	fjge_cont.51034
fjge_else.51033:
	fldi	%f0, %g9, -4
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f7
	fjlt	%f1, %f16, fjge_else.51035
	fmov	%f0, %f1
	jmp	fjge_cont.51036
fjge_else.51035:
	fneg	%f0, %f1
fjge_cont.51036:
	fldi	%f1, %g5, -4
	fjlt	%f0, %f1, fjge_else.51037
	addi	%g8, %g0, 0
	jmp	fjge_cont.51038
fjge_else.51037:
	fsti	%f2, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.51038:
fjge_cont.51034:
	jmp	fjne_cont.51026
fjne_else.51025:
	addi	%g8, %g0, 0
fjne_cont.51026:
	jne	%g8, %g0, jeq_else.51039
	addi	%g8, %g0, 0
	jmp	jeq_cont.51040
jeq_else.51039:
	addi	%g8, %g0, 3
jeq_cont.51040:
	jmp	jeq_cont.51024
jeq_else.51023:
	addi	%g8, %g0, 2
jeq_cont.51024:
	jmp	jeq_cont.51008
jeq_else.51007:
	addi	%g8, %g0, 1
jeq_cont.51008:
	jmp	jeq_cont.50992
jeq_else.50991:
	addi	%g8, %g0, 2
	jne	%g3, %g8, jeq_else.51041
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
	fjlt	%f16, %f0, fjge_else.51043
	addi	%g8, %g0, 0
	jmp	fjge_cont.51044
fjge_else.51043:
	fmul	%f4, %f4, %f6
	fmul	%f2, %f3, %f7
	fadd	%f2, %f4, %f2
	fmul	%f1, %f1, %f5
	fadd	%f1, %f2, %f1
	fneg	%f1, %f1
	fdiv	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.51044:
	jmp	jeq_cont.51042
jeq_else.51041:
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
	jne	%g6, %g0, jeq_else.51045
	fmov	%f9, %f3
	jmp	jeq_cont.51046
jeq_else.51045:
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
jeq_cont.51046:
	fjeq	%f9, %f16, fjne_else.51047
	fmul	%f3, %f1, %f6
	fmul	%f4, %f3, %f10
	fmul	%f3, %f2, %f7
	fmul	%f3, %f3, %f12
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f5
	fmul	%f3, %f3, %f11
	fadd	%f8, %f4, %f3
	jne	%g6, %g0, jeq_else.51049
	fmov	%f3, %f8
	jmp	jeq_cont.51050
jeq_else.51049:
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
jeq_cont.51050:
	fmul	%f0, %f6, %f6
	fmul	%f1, %f0, %f10
	fmul	%f0, %f7, %f7
	fmul	%f0, %f0, %f12
	fadd	%f1, %f1, %f0
	fmul	%f0, %f5, %f5
	fmul	%f0, %f0, %f11
	fadd	%f1, %f1, %f0
	jne	%g6, %g0, jeq_else.51051
	fmov	%f0, %f1
	jmp	jeq_cont.51052
jeq_else.51051:
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
jeq_cont.51052:
	addi	%g5, %g0, 3
	jne	%g3, %g5, jeq_else.51053
	fsub	%f1, %f0, %f17
	jmp	jeq_cont.51054
jeq_else.51053:
	fmov	%f1, %f0
jeq_cont.51054:
	fmul	%f2, %f3, %f3
	fmul	%f0, %f9, %f1
	fsub	%f0, %f2, %f0
	fjlt	%f16, %f0, fjge_else.51055
	addi	%g8, %g0, 0
	jmp	fjge_cont.51056
fjge_else.51055:
	fsqrt	%f0, %f0
	ldi	%g3, %g7, -24
	jne	%g3, %g0, jeq_else.51057
	fneg	%f1, %f0
	jmp	jeq_cont.51058
jeq_else.51057:
	fmov	%f1, %f0
jeq_cont.51058:
	fsub	%f0, %f1, %f3
	fdiv	%f0, %f0, %f9
	fsti	%f0, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.51056:
	jmp	fjne_cont.51048
fjne_else.51047:
	addi	%g8, %g0, 0
fjne_cont.51048:
jeq_cont.51042:
jeq_cont.50992:
	jne	%g8, %g0, jeq_else.51059
	slli	%g3, %g10, 2
	add	%g3, %g31, %g3
	ldi	%g3, %g3, 272
	ldi	%g3, %g3, -24
	jne	%g3, %g0, jeq_else.51060
	return
jeq_else.51060:
	addi	%g11, %g11, 1
	jmp	solve_each_element.2846
jeq_else.51059:
	fldi	%f0, %g31, 520
	sti	%g4, %g1, 0
	fjlt	%f16, %f0, fjge_else.51062
	jmp	fjge_cont.51063
fjge_else.51062:
	fldi	%f1, %g31, 528
	fjlt	%f0, %f1, fjge_else.51064
	jmp	fjge_cont.51065
fjge_else.51064:
	setL %g3, l.44095
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
	jne	%g5, %g29, jeq_else.51066
	addi	%g3, %g0, 1
	jmp	jeq_cont.51067
jeq_else.51066:
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
	jne	%g5, %g28, jeq_else.51068
	fjlt	%f0, %f16, fjge_else.51070
	fmov	%f6, %f0
	jmp	fjge_cont.51071
fjge_else.51070:
	fneg	%f6, %f0
fjge_cont.51071:
	ldi	%g3, %g6, -16
	fldi	%f0, %g3, 0
	fjlt	%f6, %f0, fjge_else.51072
	addi	%g5, %g0, 0
	jmp	fjge_cont.51073
fjge_else.51072:
	fjlt	%f2, %f16, fjge_else.51074
	fmov	%f0, %f2
	jmp	fjge_cont.51075
fjge_else.51074:
	fneg	%f0, %f2
fjge_cont.51075:
	fldi	%f2, %g3, -4
	fjlt	%f0, %f2, fjge_else.51076
	addi	%g5, %g0, 0
	jmp	fjge_cont.51077
fjge_else.51076:
	fjlt	%f1, %f16, fjge_else.51078
	fmov	%f0, %f1
	jmp	fjge_cont.51079
fjge_else.51078:
	fneg	%f0, %f1
fjge_cont.51079:
	fldi	%f1, %g3, -8
	fjlt	%f0, %f1, fjge_else.51080
	addi	%g5, %g0, 0
	jmp	fjge_cont.51081
fjge_else.51080:
	addi	%g5, %g0, 1
fjge_cont.51081:
fjge_cont.51077:
fjge_cont.51073:
	jne	%g5, %g0, jeq_else.51082
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.51084
	addi	%g3, %g0, 1
	jmp	jeq_cont.51085
jeq_else.51084:
	addi	%g3, %g0, 0
jeq_cont.51085:
	jmp	jeq_cont.51083
jeq_else.51082:
	ldi	%g3, %g6, -24
jeq_cont.51083:
	jmp	jeq_cont.51069
jeq_else.51068:
	addi	%g3, %g0, 2
	jne	%g5, %g3, jeq_else.51086
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
	fjlt	%f0, %f16, fjge_else.51088
	addi	%g5, %g0, 0
	jmp	fjge_cont.51089
fjge_else.51088:
	addi	%g5, %g0, 1
fjge_cont.51089:
	jne	%g3, %g5, jeq_else.51090
	addi	%g3, %g0, 1
	jmp	jeq_cont.51091
jeq_else.51090:
	addi	%g3, %g0, 0
jeq_cont.51091:
	jmp	jeq_cont.51087
jeq_else.51086:
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
	jne	%g3, %g0, jeq_else.51092
	fmov	%f6, %f7
	jmp	jeq_cont.51093
jeq_else.51092:
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
jeq_cont.51093:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.51094
	fsub	%f0, %f6, %f17
	jmp	jeq_cont.51095
jeq_else.51094:
	fmov	%f0, %f6
jeq_cont.51095:
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.51096
	addi	%g5, %g0, 0
	jmp	fjge_cont.51097
fjge_else.51096:
	addi	%g5, %g0, 1
fjge_cont.51097:
	jne	%g3, %g5, jeq_else.51098
	addi	%g3, %g0, 1
	jmp	jeq_cont.51099
jeq_else.51098:
	addi	%g3, %g0, 0
jeq_cont.51099:
jeq_cont.51087:
jeq_cont.51069:
	jne	%g3, %g0, jeq_else.51100
	addi	%g5, %g0, 1
	subi	%g1, %g1, 20
	call	check_all_inside.2831
	addi	%g1, %g1, 20
	jmp	jeq_cont.51101
jeq_else.51100:
	addi	%g3, %g0, 0
jeq_cont.51101:
jeq_cont.51067:
	jne	%g3, %g0, jeq_else.51102
	jmp	jeq_cont.51103
jeq_else.51102:
	fsti	%f9, %g31, 528
	fldi	%f5, %g1, 12
	fsti	%f5, %g31, 540
	fldi	%f4, %g1, 8
	fsti	%f4, %g31, 536
	fldi	%f3, %g1, 4
	fsti	%f3, %g31, 532
	sti	%g10, %g31, 544
	sti	%g8, %g31, 524
jeq_cont.51103:
fjge_cont.51065:
fjge_cont.51063:
	addi	%g11, %g11, 1
	ldi	%g4, %g1, 0
	jmp	solve_each_element.2846

!==============================
! args = [%g13, %g12, %g9]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f2, %f17, %f16, %f15, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
solve_one_or_network.2850:
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.51104
	return
jeq_else.51104:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	sti	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.51106
	return
jeq_else.51106:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.51108
	return
jeq_else.51108:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.51110
	return
jeq_else.51110:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.51112
	return
jeq_else.51112:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.51114
	return
jeq_else.51114:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.51116
	return
jeq_else.51116:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.51118
	return
jeq_else.51118:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	ldi	%g9, %g1, 0
	jmp	solve_one_or_network.2850

!==============================
! args = [%g14, %g15, %g9]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f2, %f17, %f16, %f15, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
trace_or_matrix.2854:
	slli	%g3, %g14, 2
	ld	%g12, %g15, %g3
	ldi	%g3, %g12, 0
	jne	%g3, %g29, jeq_else.51120
	return
jeq_else.51120:
	addi	%g4, %g0, 99
	sti	%g9, %g1, 0
	jne	%g3, %g4, jeq_else.51122
	ldi	%g3, %g12, -4
	jne	%g3, %g29, jeq_else.51124
	jmp	jeq_cont.51125
jeq_else.51124:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -8
	jne	%g3, %g29, jeq_else.51126
	jmp	jeq_cont.51127
jeq_else.51126:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -12
	jne	%g3, %g29, jeq_else.51128
	jmp	jeq_cont.51129
jeq_else.51128:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -16
	jne	%g3, %g29, jeq_else.51130
	jmp	jeq_cont.51131
jeq_else.51130:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -20
	jne	%g3, %g29, jeq_else.51132
	jmp	jeq_cont.51133
jeq_else.51132:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -24
	jne	%g3, %g29, jeq_else.51134
	jmp	jeq_cont.51135
jeq_else.51134:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -28
	jne	%g3, %g29, jeq_else.51136
	jmp	jeq_cont.51137
jeq_else.51136:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	addi	%g13, %g0, 8
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_one_or_network.2850
	addi	%g1, %g1, 8
jeq_cont.51137:
jeq_cont.51135:
jeq_cont.51133:
jeq_cont.51131:
jeq_cont.51129:
jeq_cont.51127:
jeq_cont.51125:
	jmp	jeq_cont.51123
jeq_else.51122:
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
	jne	%g4, %g28, jeq_else.51138
	fldi	%f2, %g9, 0
	fjeq	%f2, %f16, fjne_else.51140
	ldi	%g4, %g6, -16
	ldi	%g3, %g6, -24
	fjlt	%f2, %f16, fjge_else.51142
	addi	%g5, %g0, 0
	jmp	fjge_cont.51143
fjge_else.51142:
	addi	%g5, %g0, 1
fjge_cont.51143:
	fldi	%f1, %g4, 0
	jne	%g3, %g5, jeq_else.51144
	fneg	%f0, %f1
	jmp	jeq_cont.51145
jeq_else.51144:
	fmov	%f0, %f1
jeq_cont.51145:
	fsub	%f0, %f0, %f5
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, -4
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f6
	fjlt	%f1, %f16, fjge_else.51146
	fmov	%f0, %f1
	jmp	fjge_cont.51147
fjge_else.51146:
	fneg	%f0, %f1
fjge_cont.51147:
	fldi	%f1, %g4, -4
	fjlt	%f0, %f1, fjge_else.51148
	addi	%g3, %g0, 0
	jmp	fjge_cont.51149
fjge_else.51148:
	fldi	%f0, %g9, -8
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f4
	fjlt	%f1, %f16, fjge_else.51150
	fmov	%f0, %f1
	jmp	fjge_cont.51151
fjge_else.51150:
	fneg	%f0, %f1
fjge_cont.51151:
	fldi	%f1, %g4, -8
	fjlt	%f0, %f1, fjge_else.51152
	addi	%g3, %g0, 0
	jmp	fjge_cont.51153
fjge_else.51152:
	fsti	%f2, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.51153:
fjge_cont.51149:
	jmp	fjne_cont.51141
fjne_else.51140:
	addi	%g3, %g0, 0
fjne_cont.51141:
	jne	%g3, %g0, jeq_else.51154
	fldi	%f2, %g9, -4
	fjeq	%f2, %f16, fjne_else.51156
	ldi	%g4, %g6, -16
	ldi	%g3, %g6, -24
	fjlt	%f2, %f16, fjge_else.51158
	addi	%g5, %g0, 0
	jmp	fjge_cont.51159
fjge_else.51158:
	addi	%g5, %g0, 1
fjge_cont.51159:
	fldi	%f1, %g4, -4
	jne	%g3, %g5, jeq_else.51160
	fneg	%f0, %f1
	jmp	jeq_cont.51161
jeq_else.51160:
	fmov	%f0, %f1
jeq_cont.51161:
	fsub	%f0, %f0, %f6
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, -8
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f4
	fjlt	%f1, %f16, fjge_else.51162
	fmov	%f0, %f1
	jmp	fjge_cont.51163
fjge_else.51162:
	fneg	%f0, %f1
fjge_cont.51163:
	fldi	%f1, %g4, -8
	fjlt	%f0, %f1, fjge_else.51164
	addi	%g3, %g0, 0
	jmp	fjge_cont.51165
fjge_else.51164:
	fldi	%f0, %g9, 0
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f5
	fjlt	%f1, %f16, fjge_else.51166
	fmov	%f0, %f1
	jmp	fjge_cont.51167
fjge_else.51166:
	fneg	%f0, %f1
fjge_cont.51167:
	fldi	%f1, %g4, 0
	fjlt	%f0, %f1, fjge_else.51168
	addi	%g3, %g0, 0
	jmp	fjge_cont.51169
fjge_else.51168:
	fsti	%f2, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.51169:
fjge_cont.51165:
	jmp	fjne_cont.51157
fjne_else.51156:
	addi	%g3, %g0, 0
fjne_cont.51157:
	jne	%g3, %g0, jeq_else.51170
	fldi	%f2, %g9, -8
	fjeq	%f2, %f16, fjne_else.51172
	ldi	%g4, %g6, -16
	ldi	%g3, %g6, -24
	fjlt	%f2, %f16, fjge_else.51174
	addi	%g5, %g0, 0
	jmp	fjge_cont.51175
fjge_else.51174:
	addi	%g5, %g0, 1
fjge_cont.51175:
	fldi	%f1, %g4, -8
	jne	%g3, %g5, jeq_else.51176
	fneg	%f0, %f1
	jmp	jeq_cont.51177
jeq_else.51176:
	fmov	%f0, %f1
jeq_cont.51177:
	fsub	%f0, %f0, %f4
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, 0
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f5
	fjlt	%f1, %f16, fjge_else.51178
	fmov	%f0, %f1
	jmp	fjge_cont.51179
fjge_else.51178:
	fneg	%f0, %f1
fjge_cont.51179:
	fldi	%f1, %g4, 0
	fjlt	%f0, %f1, fjge_else.51180
	addi	%g3, %g0, 0
	jmp	fjge_cont.51181
fjge_else.51180:
	fldi	%f0, %g9, -4
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f6
	fjlt	%f1, %f16, fjge_else.51182
	fmov	%f0, %f1
	jmp	fjge_cont.51183
fjge_else.51182:
	fneg	%f0, %f1
fjge_cont.51183:
	fldi	%f1, %g4, -4
	fjlt	%f0, %f1, fjge_else.51184
	addi	%g3, %g0, 0
	jmp	fjge_cont.51185
fjge_else.51184:
	fsti	%f2, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.51185:
fjge_cont.51181:
	jmp	fjne_cont.51173
fjne_else.51172:
	addi	%g3, %g0, 0
fjne_cont.51173:
	jne	%g3, %g0, jeq_else.51186
	addi	%g3, %g0, 0
	jmp	jeq_cont.51187
jeq_else.51186:
	addi	%g3, %g0, 3
jeq_cont.51187:
	jmp	jeq_cont.51171
jeq_else.51170:
	addi	%g3, %g0, 2
jeq_cont.51171:
	jmp	jeq_cont.51155
jeq_else.51154:
	addi	%g3, %g0, 1
jeq_cont.51155:
	jmp	jeq_cont.51139
jeq_else.51138:
	addi	%g3, %g0, 2
	jne	%g4, %g3, jeq_else.51188
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
	fjlt	%f16, %f0, fjge_else.51190
	addi	%g3, %g0, 0
	jmp	fjge_cont.51191
fjge_else.51190:
	fmul	%f5, %f7, %f5
	fmul	%f2, %f3, %f6
	fadd	%f2, %f5, %f2
	fmul	%f1, %f1, %f4
	fadd	%f1, %f2, %f1
	fneg	%f1, %f1
	fdiv	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.51191:
	jmp	jeq_cont.51189
jeq_else.51188:
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
	jne	%g5, %g0, jeq_else.51192
	fmov	%f8, %f3
	jmp	jeq_cont.51193
jeq_else.51192:
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
jeq_cont.51193:
	fjeq	%f8, %f16, fjne_else.51194
	fmul	%f3, %f1, %f5
	fmul	%f7, %f3, %f9
	fmul	%f3, %f2, %f6
	fmul	%f3, %f3, %f11
	fadd	%f7, %f7, %f3
	fmul	%f3, %f0, %f4
	fmul	%f3, %f3, %f10
	fadd	%f7, %f7, %f3
	jne	%g5, %g0, jeq_else.51196
	fmov	%f3, %f7
	jmp	jeq_cont.51197
jeq_else.51196:
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
jeq_cont.51197:
	fmul	%f0, %f5, %f5
	fmul	%f1, %f0, %f9
	fmul	%f0, %f6, %f6
	fmul	%f0, %f0, %f11
	fadd	%f1, %f1, %f0
	fmul	%f0, %f4, %f4
	fmul	%f0, %f0, %f10
	fadd	%f1, %f1, %f0
	jne	%g5, %g0, jeq_else.51198
	fmov	%f0, %f1
	jmp	jeq_cont.51199
jeq_else.51198:
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
jeq_cont.51199:
	addi	%g3, %g0, 3
	jne	%g4, %g3, jeq_else.51200
	fsub	%f1, %f0, %f17
	jmp	jeq_cont.51201
jeq_else.51200:
	fmov	%f1, %f0
jeq_cont.51201:
	fmul	%f2, %f3, %f3
	fmul	%f0, %f8, %f1
	fsub	%f0, %f2, %f0
	fjlt	%f16, %f0, fjge_else.51202
	addi	%g3, %g0, 0
	jmp	fjge_cont.51203
fjge_else.51202:
	fsqrt	%f0, %f0
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.51204
	fneg	%f1, %f0
	jmp	jeq_cont.51205
jeq_else.51204:
	fmov	%f1, %f0
jeq_cont.51205:
	fsub	%f0, %f1, %f3
	fdiv	%f0, %f0, %f8
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.51203:
	jmp	fjne_cont.51195
fjne_else.51194:
	addi	%g3, %g0, 0
fjne_cont.51195:
jeq_cont.51189:
jeq_cont.51139:
	jne	%g3, %g0, jeq_else.51206
	jmp	jeq_cont.51207
jeq_else.51206:
	fldi	%f0, %g31, 520
	fldi	%f1, %g31, 528
	fjlt	%f0, %f1, fjge_else.51208
	jmp	fjge_cont.51209
fjge_else.51208:
	ldi	%g3, %g12, -4
	jne	%g3, %g29, jeq_else.51210
	jmp	jeq_cont.51211
jeq_else.51210:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -8
	jne	%g3, %g29, jeq_else.51212
	jmp	jeq_cont.51213
jeq_else.51212:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -12
	jne	%g3, %g29, jeq_else.51214
	jmp	jeq_cont.51215
jeq_else.51214:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -16
	jne	%g3, %g29, jeq_else.51216
	jmp	jeq_cont.51217
jeq_else.51216:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -20
	jne	%g3, %g29, jeq_else.51218
	jmp	jeq_cont.51219
jeq_else.51218:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -24
	jne	%g3, %g29, jeq_else.51220
	jmp	jeq_cont.51221
jeq_else.51220:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -28
	jne	%g3, %g29, jeq_else.51222
	jmp	jeq_cont.51223
jeq_else.51222:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2846
	addi	%g1, %g1, 8
	addi	%g13, %g0, 8
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_one_or_network.2850
	addi	%g1, %g1, 8
jeq_cont.51223:
jeq_cont.51221:
jeq_cont.51219:
jeq_cont.51217:
jeq_cont.51215:
jeq_cont.51213:
jeq_cont.51211:
fjge_cont.51209:
jeq_cont.51207:
jeq_cont.51123:
	addi	%g14, %g14, 1
	ldi	%g9, %g1, 0
	jmp	trace_or_matrix.2854

!==============================
! args = [%g10, %g4, %g12, %g11]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
solve_each_element_fast.2860:
	slli	%g3, %g10, 2
	ld	%g9, %g4, %g3
	jne	%g9, %g29, jeq_else.51224
	return
jeq_else.51224:
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
	jne	%g3, %g28, jeq_else.51226
	fldi	%f0, %g7, 0
	fsub	%f0, %f0, %f3
	fldi	%f1, %g7, -4
	fmul	%f0, %f0, %f1
	fldi	%f5, %g12, -4
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f4
	fjlt	%f6, %f16, fjge_else.51228
	fmov	%f5, %f6
	jmp	fjge_cont.51229
fjge_else.51228:
	fneg	%f5, %f6
fjge_cont.51229:
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, -4
	fjlt	%f5, %f6, fjge_else.51230
	addi	%g8, %g0, 0
	jmp	fjge_cont.51231
fjge_else.51230:
	fldi	%f5, %g12, -8
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f2
	fjlt	%f6, %f16, fjge_else.51232
	fmov	%f5, %f6
	jmp	fjge_cont.51233
fjge_else.51232:
	fneg	%f5, %f6
fjge_cont.51233:
	fldi	%f6, %g3, -8
	fjlt	%f5, %f6, fjge_else.51234
	addi	%g8, %g0, 0
	jmp	fjge_cont.51235
fjge_else.51234:
	fjeq	%f1, %f16, fjne_else.51236
	addi	%g8, %g0, 1
	jmp	fjne_cont.51237
fjne_else.51236:
	addi	%g8, %g0, 0
fjne_cont.51237:
fjge_cont.51235:
fjge_cont.51231:
	jne	%g8, %g0, jeq_else.51238
	fldi	%f0, %g7, -8
	fsub	%f0, %f0, %f4
	fldi	%f1, %g7, -12
	fmul	%f0, %f0, %f1
	fldi	%f5, %g12, 0
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f3
	fjlt	%f6, %f16, fjge_else.51240
	fmov	%f5, %f6
	jmp	fjge_cont.51241
fjge_else.51240:
	fneg	%f5, %f6
fjge_cont.51241:
	fldi	%f6, %g3, 0
	fjlt	%f5, %f6, fjge_else.51242
	addi	%g8, %g0, 0
	jmp	fjge_cont.51243
fjge_else.51242:
	fldi	%f5, %g12, -8
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f2
	fjlt	%f6, %f16, fjge_else.51244
	fmov	%f5, %f6
	jmp	fjge_cont.51245
fjge_else.51244:
	fneg	%f5, %f6
fjge_cont.51245:
	fldi	%f6, %g3, -8
	fjlt	%f5, %f6, fjge_else.51246
	addi	%g8, %g0, 0
	jmp	fjge_cont.51247
fjge_else.51246:
	fjeq	%f1, %f16, fjne_else.51248
	addi	%g8, %g0, 1
	jmp	fjne_cont.51249
fjne_else.51248:
	addi	%g8, %g0, 0
fjne_cont.51249:
fjge_cont.51247:
fjge_cont.51243:
	jne	%g8, %g0, jeq_else.51250
	fldi	%f0, %g7, -16
	fsub	%f1, %f0, %f2
	fldi	%f0, %g7, -20
	fmul	%f5, %f1, %f0
	fldi	%f1, %g12, 0
	fmul	%f1, %f5, %f1
	fadd	%f2, %f1, %f3
	fjlt	%f2, %f16, fjge_else.51252
	fmov	%f1, %f2
	jmp	fjge_cont.51253
fjge_else.51252:
	fneg	%f1, %f2
fjge_cont.51253:
	fldi	%f2, %g3, 0
	fjlt	%f1, %f2, fjge_else.51254
	addi	%g8, %g0, 0
	jmp	fjge_cont.51255
fjge_else.51254:
	fldi	%f1, %g12, -4
	fmul	%f1, %f5, %f1
	fadd	%f2, %f1, %f4
	fjlt	%f2, %f16, fjge_else.51256
	fmov	%f1, %f2
	jmp	fjge_cont.51257
fjge_else.51256:
	fneg	%f1, %f2
fjge_cont.51257:
	fldi	%f2, %g3, -4
	fjlt	%f1, %f2, fjge_else.51258
	addi	%g8, %g0, 0
	jmp	fjge_cont.51259
fjge_else.51258:
	fjeq	%f0, %f16, fjne_else.51260
	addi	%g8, %g0, 1
	jmp	fjne_cont.51261
fjne_else.51260:
	addi	%g8, %g0, 0
fjne_cont.51261:
fjge_cont.51259:
fjge_cont.51255:
	jne	%g8, %g0, jeq_else.51262
	addi	%g8, %g0, 0
	jmp	jeq_cont.51263
jeq_else.51262:
	fsti	%f5, %g31, 520
	addi	%g8, %g0, 3
jeq_cont.51263:
	jmp	jeq_cont.51251
jeq_else.51250:
	fsti	%f0, %g31, 520
	addi	%g8, %g0, 2
jeq_cont.51251:
	jmp	jeq_cont.51239
jeq_else.51238:
	fsti	%f0, %g31, 520
	addi	%g8, %g0, 1
jeq_cont.51239:
	jmp	jeq_cont.51227
jeq_else.51226:
	addi	%g8, %g0, 2
	jne	%g3, %g8, jeq_else.51264
	fldi	%f1, %g7, 0
	fjlt	%f1, %f16, fjge_else.51266
	addi	%g8, %g0, 0
	jmp	fjge_cont.51267
fjge_else.51266:
	fldi	%f0, %g5, -12
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.51267:
	jmp	jeq_cont.51265
jeq_else.51264:
	fldi	%f5, %g7, 0
	fjeq	%f5, %f16, fjne_else.51268
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
	fjlt	%f16, %f0, fjge_else.51270
	addi	%g8, %g0, 0
	jmp	fjge_cont.51271
fjge_else.51270:
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.51272
	fsqrt	%f0, %f0
	fsub	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	jmp	jeq_cont.51273
jeq_else.51272:
	fsqrt	%f0, %f0
	fadd	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
jeq_cont.51273:
	addi	%g8, %g0, 1
fjge_cont.51271:
	jmp	fjne_cont.51269
fjne_else.51268:
	addi	%g8, %g0, 0
fjne_cont.51269:
jeq_cont.51265:
jeq_cont.51227:
	jne	%g8, %g0, jeq_else.51274
	slli	%g3, %g9, 2
	add	%g3, %g31, %g3
	ldi	%g3, %g3, 272
	ldi	%g3, %g3, -24
	jne	%g3, %g0, jeq_else.51275
	return
jeq_else.51275:
	addi	%g10, %g10, 1
	jmp	solve_each_element_fast.2860
jeq_else.51274:
	fldi	%f0, %g31, 520
	sti	%g4, %g1, 0
	fjlt	%f16, %f0, fjge_else.51277
	jmp	fjge_cont.51278
fjge_else.51277:
	fldi	%f1, %g31, 528
	fjlt	%f0, %f1, fjge_else.51279
	jmp	fjge_cont.51280
fjge_else.51279:
	setL %g3, l.44095
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
	jne	%g5, %g29, jeq_else.51281
	addi	%g3, %g0, 1
	jmp	jeq_cont.51282
jeq_else.51281:
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
	jne	%g5, %g28, jeq_else.51283
	fjlt	%f0, %f16, fjge_else.51285
	fmov	%f6, %f0
	jmp	fjge_cont.51286
fjge_else.51285:
	fneg	%f6, %f0
fjge_cont.51286:
	ldi	%g3, %g6, -16
	fldi	%f0, %g3, 0
	fjlt	%f6, %f0, fjge_else.51287
	addi	%g5, %g0, 0
	jmp	fjge_cont.51288
fjge_else.51287:
	fjlt	%f2, %f16, fjge_else.51289
	fmov	%f0, %f2
	jmp	fjge_cont.51290
fjge_else.51289:
	fneg	%f0, %f2
fjge_cont.51290:
	fldi	%f2, %g3, -4
	fjlt	%f0, %f2, fjge_else.51291
	addi	%g5, %g0, 0
	jmp	fjge_cont.51292
fjge_else.51291:
	fjlt	%f1, %f16, fjge_else.51293
	fmov	%f0, %f1
	jmp	fjge_cont.51294
fjge_else.51293:
	fneg	%f0, %f1
fjge_cont.51294:
	fldi	%f1, %g3, -8
	fjlt	%f0, %f1, fjge_else.51295
	addi	%g5, %g0, 0
	jmp	fjge_cont.51296
fjge_else.51295:
	addi	%g5, %g0, 1
fjge_cont.51296:
fjge_cont.51292:
fjge_cont.51288:
	jne	%g5, %g0, jeq_else.51297
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.51299
	addi	%g3, %g0, 1
	jmp	jeq_cont.51300
jeq_else.51299:
	addi	%g3, %g0, 0
jeq_cont.51300:
	jmp	jeq_cont.51298
jeq_else.51297:
	ldi	%g3, %g6, -24
jeq_cont.51298:
	jmp	jeq_cont.51284
jeq_else.51283:
	addi	%g3, %g0, 2
	jne	%g5, %g3, jeq_else.51301
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
	fjlt	%f0, %f16, fjge_else.51303
	addi	%g5, %g0, 0
	jmp	fjge_cont.51304
fjge_else.51303:
	addi	%g5, %g0, 1
fjge_cont.51304:
	jne	%g3, %g5, jeq_else.51305
	addi	%g3, %g0, 1
	jmp	jeq_cont.51306
jeq_else.51305:
	addi	%g3, %g0, 0
jeq_cont.51306:
	jmp	jeq_cont.51302
jeq_else.51301:
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
	jne	%g3, %g0, jeq_else.51307
	fmov	%f6, %f7
	jmp	jeq_cont.51308
jeq_else.51307:
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
jeq_cont.51308:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.51309
	fsub	%f0, %f6, %f17
	jmp	jeq_cont.51310
jeq_else.51309:
	fmov	%f0, %f6
jeq_cont.51310:
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.51311
	addi	%g5, %g0, 0
	jmp	fjge_cont.51312
fjge_else.51311:
	addi	%g5, %g0, 1
fjge_cont.51312:
	jne	%g3, %g5, jeq_else.51313
	addi	%g3, %g0, 1
	jmp	jeq_cont.51314
jeq_else.51313:
	addi	%g3, %g0, 0
jeq_cont.51314:
jeq_cont.51302:
jeq_cont.51284:
	jne	%g3, %g0, jeq_else.51315
	addi	%g5, %g0, 1
	subi	%g1, %g1, 20
	call	check_all_inside.2831
	addi	%g1, %g1, 20
	jmp	jeq_cont.51316
jeq_else.51315:
	addi	%g3, %g0, 0
jeq_cont.51316:
jeq_cont.51282:
	jne	%g3, %g0, jeq_else.51317
	jmp	jeq_cont.51318
jeq_else.51317:
	fsti	%f9, %g31, 528
	fldi	%f5, %g1, 12
	fsti	%f5, %g31, 540
	fldi	%f4, %g1, 8
	fsti	%f4, %g31, 536
	fldi	%f3, %g1, 4
	fsti	%f3, %g31, 532
	sti	%g9, %g31, 544
	sti	%g8, %g31, 524
jeq_cont.51318:
fjge_cont.51280:
fjge_cont.51278:
	addi	%g10, %g10, 1
	ldi	%g4, %g1, 0
	jmp	solve_each_element_fast.2860

!==============================
! args = [%g16, %g15, %g14, %g13]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
solve_one_or_network_fast.2864:
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.51319
	return
jeq_else.51319:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.51321
	return
jeq_else.51321:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.51323
	return
jeq_else.51323:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.51325
	return
jeq_else.51325:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.51327
	return
jeq_else.51327:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.51329
	return
jeq_else.51329:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.51331
	return
jeq_else.51331:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.51333
	return
jeq_else.51333:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	jmp	solve_one_or_network_fast.2864

!==============================
! args = [%g19, %g20, %g18, %g17]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
trace_or_matrix_fast.2868:
	slli	%g3, %g19, 2
	ld	%g15, %g20, %g3
	ldi	%g3, %g15, 0
	jne	%g3, %g29, jeq_else.51335
	return
jeq_else.51335:
	addi	%g4, %g0, 99
	jne	%g3, %g4, jeq_else.51337
	ldi	%g3, %g15, -4
	jne	%g3, %g29, jeq_else.51339
	jmp	jeq_cont.51340
jeq_else.51339:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -8
	jne	%g3, %g29, jeq_else.51341
	jmp	jeq_cont.51342
jeq_else.51341:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -12
	jne	%g3, %g29, jeq_else.51343
	jmp	jeq_cont.51344
jeq_else.51343:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -16
	jne	%g3, %g29, jeq_else.51345
	jmp	jeq_cont.51346
jeq_else.51345:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -20
	jne	%g3, %g29, jeq_else.51347
	jmp	jeq_cont.51348
jeq_else.51347:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -24
	jne	%g3, %g29, jeq_else.51349
	jmp	jeq_cont.51350
jeq_else.51349:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -28
	jne	%g3, %g29, jeq_else.51351
	jmp	jeq_cont.51352
jeq_else.51351:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g16, %g0, 8
	mov	%g13, %g17
	mov	%g14, %g18
	call	solve_one_or_network_fast.2864
	addi	%g1, %g1, 4
jeq_cont.51352:
jeq_cont.51350:
jeq_cont.51348:
jeq_cont.51346:
jeq_cont.51344:
jeq_cont.51342:
jeq_cont.51340:
	jmp	jeq_cont.51338
jeq_else.51337:
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
	jne	%g4, %g28, jeq_else.51353
	fldi	%f0, %g7, 0
	fsub	%f4, %f0, %f2
	fldi	%f0, %g7, -4
	fmul	%f6, %f4, %f0
	fldi	%f4, %g18, -4
	fmul	%f4, %f6, %f4
	fadd	%f5, %f4, %f3
	fjlt	%f5, %f16, fjge_else.51355
	fmov	%f4, %f5
	jmp	fjge_cont.51356
fjge_else.51355:
	fneg	%f4, %f5
fjge_cont.51356:
	ldi	%g4, %g6, -16
	fldi	%f5, %g4, -4
	fjlt	%f4, %f5, fjge_else.51357
	addi	%g3, %g0, 0
	jmp	fjge_cont.51358
fjge_else.51357:
	fldi	%f4, %g18, -8
	fmul	%f4, %f6, %f4
	fadd	%f5, %f4, %f1
	fjlt	%f5, %f16, fjge_else.51359
	fmov	%f4, %f5
	jmp	fjge_cont.51360
fjge_else.51359:
	fneg	%f4, %f5
fjge_cont.51360:
	fldi	%f5, %g4, -8
	fjlt	%f4, %f5, fjge_else.51361
	addi	%g3, %g0, 0
	jmp	fjge_cont.51362
fjge_else.51361:
	fjeq	%f0, %f16, fjne_else.51363
	addi	%g3, %g0, 1
	jmp	fjne_cont.51364
fjne_else.51363:
	addi	%g3, %g0, 0
fjne_cont.51364:
fjge_cont.51362:
fjge_cont.51358:
	jne	%g3, %g0, jeq_else.51365
	fldi	%f0, %g7, -8
	fsub	%f0, %f0, %f3
	fldi	%f6, %g7, -12
	fmul	%f5, %f0, %f6
	fldi	%f0, %g18, 0
	fmul	%f0, %f5, %f0
	fadd	%f4, %f0, %f2
	fjlt	%f4, %f16, fjge_else.51367
	fmov	%f0, %f4
	jmp	fjge_cont.51368
fjge_else.51367:
	fneg	%f0, %f4
fjge_cont.51368:
	fldi	%f4, %g4, 0
	fjlt	%f0, %f4, fjge_else.51369
	addi	%g3, %g0, 0
	jmp	fjge_cont.51370
fjge_else.51369:
	fldi	%f0, %g18, -8
	fmul	%f0, %f5, %f0
	fadd	%f4, %f0, %f1
	fjlt	%f4, %f16, fjge_else.51371
	fmov	%f0, %f4
	jmp	fjge_cont.51372
fjge_else.51371:
	fneg	%f0, %f4
fjge_cont.51372:
	fldi	%f4, %g4, -8
	fjlt	%f0, %f4, fjge_else.51373
	addi	%g3, %g0, 0
	jmp	fjge_cont.51374
fjge_else.51373:
	fjeq	%f6, %f16, fjne_else.51375
	addi	%g3, %g0, 1
	jmp	fjne_cont.51376
fjne_else.51375:
	addi	%g3, %g0, 0
fjne_cont.51376:
fjge_cont.51374:
fjge_cont.51370:
	jne	%g3, %g0, jeq_else.51377
	fldi	%f0, %g7, -16
	fsub	%f0, %f0, %f1
	fldi	%f5, %g7, -20
	fmul	%f4, %f0, %f5
	fldi	%f0, %g18, 0
	fmul	%f0, %f4, %f0
	fadd	%f1, %f0, %f2
	fjlt	%f1, %f16, fjge_else.51379
	fmov	%f0, %f1
	jmp	fjge_cont.51380
fjge_else.51379:
	fneg	%f0, %f1
fjge_cont.51380:
	fldi	%f1, %g4, 0
	fjlt	%f0, %f1, fjge_else.51381
	addi	%g3, %g0, 0
	jmp	fjge_cont.51382
fjge_else.51381:
	fldi	%f0, %g18, -4
	fmul	%f0, %f4, %f0
	fadd	%f1, %f0, %f3
	fjlt	%f1, %f16, fjge_else.51383
	fmov	%f0, %f1
	jmp	fjge_cont.51384
fjge_else.51383:
	fneg	%f0, %f1
fjge_cont.51384:
	fldi	%f1, %g4, -4
	fjlt	%f0, %f1, fjge_else.51385
	addi	%g3, %g0, 0
	jmp	fjge_cont.51386
fjge_else.51385:
	fjeq	%f5, %f16, fjne_else.51387
	addi	%g3, %g0, 1
	jmp	fjne_cont.51388
fjne_else.51387:
	addi	%g3, %g0, 0
fjne_cont.51388:
fjge_cont.51386:
fjge_cont.51382:
	jne	%g3, %g0, jeq_else.51389
	addi	%g3, %g0, 0
	jmp	jeq_cont.51390
jeq_else.51389:
	fsti	%f4, %g31, 520
	addi	%g3, %g0, 3
jeq_cont.51390:
	jmp	jeq_cont.51378
jeq_else.51377:
	fsti	%f5, %g31, 520
	addi	%g3, %g0, 2
jeq_cont.51378:
	jmp	jeq_cont.51366
jeq_else.51365:
	fsti	%f6, %g31, 520
	addi	%g3, %g0, 1
jeq_cont.51366:
	jmp	jeq_cont.51354
jeq_else.51353:
	addi	%g3, %g0, 2
	jne	%g4, %g3, jeq_else.51391
	fldi	%f1, %g7, 0
	fjlt	%f1, %f16, fjge_else.51393
	addi	%g3, %g0, 0
	jmp	fjge_cont.51394
fjge_else.51393:
	fldi	%f0, %g5, -12
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.51394:
	jmp	jeq_cont.51392
jeq_else.51391:
	fldi	%f4, %g7, 0
	fjeq	%f4, %f16, fjne_else.51395
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
	fjlt	%f16, %f0, fjge_else.51397
	addi	%g3, %g0, 0
	jmp	fjge_cont.51398
fjge_else.51397:
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.51399
	fsqrt	%f0, %f0
	fsub	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	jmp	jeq_cont.51400
jeq_else.51399:
	fsqrt	%f0, %f0
	fadd	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
jeq_cont.51400:
	addi	%g3, %g0, 1
fjge_cont.51398:
	jmp	fjne_cont.51396
fjne_else.51395:
	addi	%g3, %g0, 0
fjne_cont.51396:
jeq_cont.51392:
jeq_cont.51354:
	jne	%g3, %g0, jeq_else.51401
	jmp	jeq_cont.51402
jeq_else.51401:
	fldi	%f0, %g31, 520
	fldi	%f1, %g31, 528
	fjlt	%f0, %f1, fjge_else.51403
	jmp	fjge_cont.51404
fjge_else.51403:
	ldi	%g3, %g15, -4
	jne	%g3, %g29, jeq_else.51405
	jmp	jeq_cont.51406
jeq_else.51405:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -8
	jne	%g3, %g29, jeq_else.51407
	jmp	jeq_cont.51408
jeq_else.51407:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -12
	jne	%g3, %g29, jeq_else.51409
	jmp	jeq_cont.51410
jeq_else.51409:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -16
	jne	%g3, %g29, jeq_else.51411
	jmp	jeq_cont.51412
jeq_else.51411:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -20
	jne	%g3, %g29, jeq_else.51413
	jmp	jeq_cont.51414
jeq_else.51413:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -24
	jne	%g3, %g29, jeq_else.51415
	jmp	jeq_cont.51416
jeq_else.51415:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -28
	jne	%g3, %g29, jeq_else.51417
	jmp	jeq_cont.51418
jeq_else.51417:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2860
	addi	%g16, %g0, 8
	mov	%g13, %g17
	mov	%g14, %g18
	call	solve_one_or_network_fast.2864
	addi	%g1, %g1, 4
jeq_cont.51418:
jeq_cont.51416:
jeq_cont.51414:
jeq_cont.51412:
jeq_cont.51410:
jeq_cont.51408:
jeq_cont.51406:
fjge_cont.51404:
jeq_cont.51402:
jeq_cont.51338:
	addi	%g19, %g19, 1
	jmp	trace_or_matrix_fast.2868

!==============================
! args = [%g21, %g22]
! fargs = [%f11, %f10]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
trace_reflections.2890:
	jlt	%g21, %g0, jge_else.51419
	slli	%g3, %g21, 2
	add	%g3, %g31, %g3
	ldi	%g23, %g3, 1716
	ldi	%g24, %g23, -4
	setL %g3, l.42275
	fldi	%f0, %g3, 0
	fsti	%f0, %g31, 528
	addi	%g19, %g0, 0
	ldi	%g20, %g31, 516
	ldi	%g17, %g24, -4
	ldi	%g18, %g24, 0
	subi	%g1, %g1, 4
	call	trace_or_matrix_fast.2868
	addi	%g1, %g1, 4
	fldi	%f0, %g31, 528
	setL %g3, l.44281
	fldi	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.51420
	addi	%g3, %g0, 0
	jmp	fjge_cont.51421
fjge_else.51420:
	setL %g3, l.45016
	fldi	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.51422
	addi	%g3, %g0, 0
	jmp	fjge_cont.51423
fjge_else.51422:
	addi	%g3, %g0, 1
fjge_cont.51423:
fjge_cont.51421:
	jne	%g3, %g0, jeq_else.51424
	jmp	jeq_cont.51425
jeq_else.51424:
	ldi	%g3, %g31, 544
	slli	%g4, %g3, 2
	ldi	%g3, %g31, 524
	add	%g3, %g4, %g3
	ldi	%g4, %g23, 0
	jne	%g3, %g4, jeq_else.51426
	addi	%g12, %g0, 0
	ldi	%g13, %g31, 516
	subi	%g1, %g1, 4
	call	shadow_check_one_or_matrix.2843
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.51428
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
	fjlt	%f16, %f1, fjge_else.51430
	jmp	fjge_cont.51431
fjge_else.51430:
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
fjge_cont.51431:
	fjlt	%f16, %f0, fjge_else.51432
	jmp	fjge_cont.51433
fjge_else.51432:
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
fjge_cont.51433:
	jmp	jeq_cont.51429
jeq_else.51428:
jeq_cont.51429:
	jmp	jeq_cont.51427
jeq_else.51426:
jeq_cont.51427:
jeq_cont.51425:
	subi	%g21, %g21, 1
	jmp	trace_reflections.2890
jge_else.51419:
	return

!==============================
! args = [%g25, %g22, %g24, %g20, %g19, %g18, %g17, %g23, %g21, %g16]
! fargs = [%f13, %f14]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
trace_ray.2895:
	addi	%g3, %g0, 4
	jlt	%g3, %g25, jle_else.51435
	setL %g3, l.42275
	fldi	%f0, %g3, 0
	fsti	%f0, %g31, 528
	addi	%g14, %g0, 0
	ldi	%g15, %g31, 516
	mov	%g9, %g22
	subi	%g1, %g1, 4
	call	trace_or_matrix.2854
	addi	%g1, %g1, 4
	fldi	%f0, %g31, 528
	setL %g3, l.44281
	fldi	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.51436
	addi	%g3, %g0, 0
	jmp	fjge_cont.51437
fjge_else.51436:
	setL %g3, l.45016
	fldi	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.51438
	addi	%g3, %g0, 0
	jmp	fjge_cont.51439
fjge_else.51438:
	addi	%g3, %g0, 1
fjge_cont.51439:
fjge_cont.51437:
	jne	%g3, %g0, jeq_else.51440
	addi	%g4, %g0, -1
	slli	%g3, %g25, 2
	st	%g4, %g19, %g3
	jne	%g25, %g0, jeq_else.51441
	return
jeq_else.51441:
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
	fjlt	%f16, %f0, fjge_else.51443
	return
fjge_else.51443:
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
jeq_else.51440:
	ldi	%g7, %g31, 544
	slli	%g3, %g7, 2
	add	%g3, %g31, %g3
	ldi	%g3, %g3, 272
	ldi	%g30, %g3, -8
	ldi	%g26, %g3, -28
	fldi	%f0, %g26, 0
	fmul	%f11, %f0, %f13
	ldi	%g4, %g3, -4
	jne	%g4, %g28, jeq_else.51446
	ldi	%g4, %g31, 524
	fsti	%f16, %g31, 556
	fsti	%f16, %g31, 552
	fsti	%f16, %g31, 548
	subi	%g5, %g4, 1
	slli	%g4, %g5, 2
	fld	%f1, %g22, %g4
	fjeq	%f1, %f16, fjne_else.51448
	fjlt	%f16, %f1, fjge_else.51450
	setL %g4, l.43536
	fldi	%f0, %g4, 0
	jmp	fjge_cont.51451
fjge_else.51450:
	setL %g4, l.42509
	fldi	%f0, %g4, 0
fjge_cont.51451:
	jmp	fjne_cont.51449
fjne_else.51448:
	fmov	%f0, %f16
fjne_cont.51449:
	fneg	%f0, %f0
	slli	%g4, %g5, 2
	add	%g4, %g31, %g4
	fsti	%f0, %g4, 556
	jmp	jeq_cont.51447
jeq_else.51446:
	addi	%g5, %g0, 2
	jne	%g4, %g5, jeq_else.51452
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
	jmp	jeq_cont.51453
jeq_else.51452:
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
	jne	%g4, %g0, jeq_else.51454
	fsti	%f1, %g31, 556
	fsti	%f5, %g31, 552
	fsti	%f7, %g31, 548
	jmp	jeq_cont.51455
jeq_else.51454:
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
jeq_cont.51455:
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
	fjeq	%f1, %f16, fjne_else.51456
	jne	%g4, %g0, jeq_else.51458
	fdiv	%f0, %f17, %f1
	jmp	jeq_cont.51459
jeq_else.51458:
	fdiv	%f0, %f20, %f1
jeq_cont.51459:
	jmp	fjne_cont.51457
fjne_else.51456:
	setL %g4, l.42509
	fldi	%f0, %g4, 0
fjne_cont.51457:
	fmul	%f1, %f2, %f0
	fsti	%f1, %g31, 556
	fldi	%f1, %g31, 552
	fmul	%f1, %f1, %f0
	fsti	%f1, %g31, 552
	fldi	%f1, %g31, 548
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 548
jeq_cont.51453:
jeq_cont.51447:
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
	jne	%g4, %g28, jeq_else.51460
	fldi	%f1, %g31, 540
	ldi	%g5, %g3, -20
	fldi	%f0, %g5, 0
	fsub	%f5, %f1, %f0
	setL %g3, l.45321
	fldi	%f9, %g3, 0
	fmul	%f0, %f5, %f9
	subi	%g1, %g1, 4
	call	min_caml_floor
	setL %g3, l.45323
	fldi	%f6, %g3, 0
	fmul	%f0, %f0, %f6
	fsub	%f8, %f5, %f0
	setL %g3, l.45282
	fldi	%f5, %g3, 0
	fldi	%f1, %g31, 532
	fldi	%f0, %g5, -8
	fsub	%f7, %f1, %f0
	fmul	%f0, %f7, %f9
	call	min_caml_floor
	addi	%g1, %g1, 4
	fmul	%f0, %f0, %f6
	fsub	%f1, %f7, %f0
	fjlt	%f8, %f5, fjge_else.51462
	fjlt	%f1, %f5, fjge_else.51464
	setL %g3, l.42271
	fldi	%f0, %g3, 0
	jmp	fjge_cont.51465
fjge_else.51464:
	setL %g3, l.42257
	fldi	%f0, %g3, 0
fjge_cont.51465:
	jmp	fjge_cont.51463
fjge_else.51462:
	fjlt	%f1, %f5, fjge_else.51466
	setL %g3, l.42257
	fldi	%f0, %g3, 0
	jmp	fjge_cont.51467
fjge_else.51466:
	setL %g3, l.42271
	fldi	%f0, %g3, 0
fjge_cont.51467:
fjge_cont.51463:
	fsti	%f0, %g31, 564
	jmp	jeq_cont.51461
jeq_else.51460:
	addi	%g5, %g0, 2
	jne	%g4, %g5, jeq_else.51468
	fldi	%f1, %g31, 536
	setL %g3, l.45301
	fldi	%f0, %g3, 0
	fmul	%f2, %f1, %f0
	setL %g3, l.42247
	fldi	%f3, %g3, 0
	setL %g3, l.42249
	fldi	%f4, %g3, 0
	fjlt	%f2, %f16, fjge_else.51470
	fmov	%f1, %f2
	jmp	fjge_cont.51471
fjge_else.51470:
	fneg	%f1, %f2
fjge_cont.51471:
	fjlt	%f29, %f1, fjge_else.51472
	fjlt	%f1, %f16, fjge_else.51474
	fmov	%f0, %f1
	jmp	fjge_cont.51475
fjge_else.51474:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51476
	fjlt	%f1, %f16, fjge_else.51478
	fmov	%f0, %f1
	jmp	fjge_cont.51479
fjge_else.51478:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51480
	fjlt	%f1, %f16, fjge_else.51482
	fmov	%f0, %f1
	jmp	fjge_cont.51483
fjge_else.51482:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.51483:
	jmp	fjge_cont.51481
fjge_else.51480:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.51481:
fjge_cont.51479:
	jmp	fjge_cont.51477
fjge_else.51476:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51484
	fjlt	%f1, %f16, fjge_else.51486
	fmov	%f0, %f1
	jmp	fjge_cont.51487
fjge_else.51486:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.51487:
	jmp	fjge_cont.51485
fjge_else.51484:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.51485:
fjge_cont.51477:
fjge_cont.51475:
	jmp	fjge_cont.51473
fjge_else.51472:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51488
	fjlt	%f1, %f16, fjge_else.51490
	fmov	%f0, %f1
	jmp	fjge_cont.51491
fjge_else.51490:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51492
	fjlt	%f1, %f16, fjge_else.51494
	fmov	%f0, %f1
	jmp	fjge_cont.51495
fjge_else.51494:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.51495:
	jmp	fjge_cont.51493
fjge_else.51492:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.51493:
fjge_cont.51491:
	jmp	fjge_cont.51489
fjge_else.51488:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51496
	fjlt	%f1, %f16, fjge_else.51498
	fmov	%f0, %f1
	jmp	fjge_cont.51499
fjge_else.51498:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.51499:
	jmp	fjge_cont.51497
fjge_else.51496:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.51497:
fjge_cont.51489:
fjge_cont.51473:
	fjlt	%f3, %f0, fjge_else.51500
	fjlt	%f16, %f2, fjge_else.51502
	addi	%g3, %g0, 0
	jmp	fjge_cont.51503
fjge_else.51502:
	addi	%g3, %g0, 1
fjge_cont.51503:
	jmp	fjge_cont.51501
fjge_else.51500:
	fjlt	%f16, %f2, fjge_else.51504
	addi	%g3, %g0, 1
	jmp	fjge_cont.51505
fjge_else.51504:
	addi	%g3, %g0, 0
fjge_cont.51505:
fjge_cont.51501:
	fjlt	%f3, %f0, fjge_else.51506
	fmov	%f1, %f0
	jmp	fjge_cont.51507
fjge_else.51506:
	fsub	%f1, %f29, %f0
fjge_cont.51507:
	fjlt	%f22, %f1, fjge_else.51508
	fmov	%f0, %f1
	jmp	fjge_cont.51509
fjge_else.51508:
	fsub	%f0, %f3, %f1
fjge_cont.51509:
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
	jne	%g3, %g0, jeq_else.51510
	fneg	%f1, %f0
	jmp	jeq_cont.51511
jeq_else.51510:
	fmov	%f1, %f0
jeq_cont.51511:
	fmul	%f0, %f1, %f1
	fmul	%f1, %f27, %f0
	fsti	%f1, %g31, 568
	fsub	%f0, %f17, %f0
	fmul	%f0, %f27, %f0
	fsti	%f0, %g31, 564
	jmp	jeq_cont.51469
jeq_else.51468:
	addi	%g5, %g0, 3
	jne	%g4, %g5, jeq_else.51512
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
	setL %g3, l.45282
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
	setL %g3, l.42247
	fldi	%f3, %g3, 0
	setL %g3, l.42249
	fldi	%f4, %g3, 0
	fjlt	%f2, %f16, fjge_else.51514
	fmov	%f1, %f2
	jmp	fjge_cont.51515
fjge_else.51514:
	fneg	%f1, %f2
fjge_cont.51515:
	fjlt	%f29, %f1, fjge_else.51516
	fjlt	%f1, %f16, fjge_else.51518
	fmov	%f0, %f1
	jmp	fjge_cont.51519
fjge_else.51518:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51520
	fjlt	%f1, %f16, fjge_else.51522
	fmov	%f0, %f1
	jmp	fjge_cont.51523
fjge_else.51522:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51524
	fjlt	%f1, %f16, fjge_else.51526
	fmov	%f0, %f1
	jmp	fjge_cont.51527
fjge_else.51526:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.51527:
	jmp	fjge_cont.51525
fjge_else.51524:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.51525:
fjge_cont.51523:
	jmp	fjge_cont.51521
fjge_else.51520:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51528
	fjlt	%f1, %f16, fjge_else.51530
	fmov	%f0, %f1
	jmp	fjge_cont.51531
fjge_else.51530:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.51531:
	jmp	fjge_cont.51529
fjge_else.51528:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.51529:
fjge_cont.51521:
fjge_cont.51519:
	jmp	fjge_cont.51517
fjge_else.51516:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51532
	fjlt	%f1, %f16, fjge_else.51534
	fmov	%f0, %f1
	jmp	fjge_cont.51535
fjge_else.51534:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51536
	fjlt	%f1, %f16, fjge_else.51538
	fmov	%f0, %f1
	jmp	fjge_cont.51539
fjge_else.51538:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.51539:
	jmp	fjge_cont.51537
fjge_else.51536:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.51537:
fjge_cont.51535:
	jmp	fjge_cont.51533
fjge_else.51532:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51540
	fjlt	%f1, %f16, fjge_else.51542
	fmov	%f0, %f1
	jmp	fjge_cont.51543
fjge_else.51542:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.51543:
	jmp	fjge_cont.51541
fjge_else.51540:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.51541:
fjge_cont.51533:
fjge_cont.51517:
	fjlt	%f3, %f0, fjge_else.51544
	fjlt	%f16, %f2, fjge_else.51546
	addi	%g3, %g0, 0
	jmp	fjge_cont.51547
fjge_else.51546:
	addi	%g3, %g0, 1
fjge_cont.51547:
	jmp	fjge_cont.51545
fjge_else.51544:
	fjlt	%f16, %f2, fjge_else.51548
	addi	%g3, %g0, 1
	jmp	fjge_cont.51549
fjge_else.51548:
	addi	%g3, %g0, 0
fjge_cont.51549:
fjge_cont.51545:
	fjlt	%f3, %f0, fjge_else.51550
	fmov	%f1, %f0
	jmp	fjge_cont.51551
fjge_else.51550:
	fsub	%f1, %f29, %f0
fjge_cont.51551:
	fjlt	%f22, %f1, fjge_else.51552
	fmov	%f0, %f1
	jmp	fjge_cont.51553
fjge_else.51552:
	fsub	%f0, %f3, %f1
fjge_cont.51553:
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
	jne	%g3, %g0, jeq_else.51554
	fneg	%f1, %f0
	jmp	jeq_cont.51555
jeq_else.51554:
	fmov	%f1, %f0
jeq_cont.51555:
	fmul	%f0, %f1, %f1
	fmul	%f1, %f0, %f27
	fsti	%f1, %g31, 564
	fsub	%f0, %f17, %f0
	fmul	%f0, %f0, %f27
	fsti	%f0, %g31, 560
	jmp	jeq_cont.51513
jeq_else.51512:
	addi	%g5, %g0, 4
	jne	%g4, %g5, jeq_else.51556
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
	fjlt	%f1, %f16, fjge_else.51558
	fmov	%f0, %f1
	jmp	fjge_cont.51559
fjge_else.51558:
	fneg	%f0, %f1
fjge_cont.51559:
	setL %g3, l.45186
	fldi	%f6, %g3, 0
	fjlt	%f0, %f6, fjge_else.51560
	fdiv	%f1, %f2, %f1
	fjlt	%f1, %f16, fjge_else.51562
	fmov	%f0, %f1
	jmp	fjge_cont.51563
fjge_else.51562:
	fneg	%f0, %f1
fjge_cont.51563:
	fjlt	%f17, %f0, fjge_else.51564
	fjlt	%f0, %f20, fjge_else.51566
	addi	%g3, %g0, 0
	jmp	fjge_cont.51567
fjge_else.51566:
	addi	%g3, %g0, -1
fjge_cont.51567:
	jmp	fjge_cont.51565
fjge_else.51564:
	addi	%g3, %g0, 1
fjge_cont.51565:
	jne	%g3, %g0, jeq_else.51568
	fmov	%f3, %f0
	jmp	jeq_cont.51569
jeq_else.51568:
	fdiv	%f3, %f17, %f0
jeq_cont.51569:
	fmul	%f0, %f3, %f3
	setL %g4, l.45192
	fldi	%f1, %g4, 0
	fmul	%f2, %f1, %f0
	setL %g4, l.45194
	fldi	%f1, %g4, 0
	fdiv	%f2, %f2, %f1
	setL %g4, l.45196
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	setL %g4, l.45198
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.45200
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	setL %g4, l.45202
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.45204
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	setL %g4, l.45206
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.45208
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	fadd	%f1, %f28, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.45211
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	setL %g4, l.45213
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.45215
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	setL %g4, l.45217
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.45219
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	fadd	%f1, %f25, %f2
	fdiv	%f1, %f4, %f1
	fmul	%f2, %f25, %f0
	fadd	%f1, %f26, %f1
	fdiv	%f2, %f2, %f1
	setL %g4, l.45223
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	fadd	%f1, %f24, %f2
	fdiv	%f1, %f4, %f1
	fadd	%f1, %f23, %f1
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f3, %f0
	jlt	%g0, %g3, jle_else.51570
	jlt	%g3, %g0, jge_else.51572
	fmov	%f0, %f1
	jmp	jge_cont.51573
jge_else.51572:
	fsub	%f0, %f31, %f1
jge_cont.51573:
	jmp	jle_cont.51571
jle_else.51570:
	fsub	%f0, %f22, %f1
jle_cont.51571:
	setL %g3, l.45230
	fldi	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fdiv	%f0, %f0, %f30
	jmp	fjge_cont.51561
fjge_else.51560:
	setL %g3, l.45188
	fldi	%f0, %g3, 0
fjge_cont.51561:
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
	fjlt	%f5, %f16, fjge_else.51574
	fmov	%f0, %f5
	jmp	fjge_cont.51575
fjge_else.51574:
	fneg	%f0, %f5
fjge_cont.51575:
	fjlt	%f0, %f6, fjge_else.51576
	fdiv	%f1, %f1, %f5
	fjlt	%f1, %f16, fjge_else.51578
	fmov	%f0, %f1
	jmp	fjge_cont.51579
fjge_else.51578:
	fneg	%f0, %f1
fjge_cont.51579:
	fjlt	%f17, %f0, fjge_else.51580
	fjlt	%f0, %f20, fjge_else.51582
	addi	%g3, %g0, 0
	jmp	fjge_cont.51583
fjge_else.51582:
	addi	%g3, %g0, -1
fjge_cont.51583:
	jmp	fjge_cont.51581
fjge_else.51580:
	addi	%g3, %g0, 1
fjge_cont.51581:
	jne	%g3, %g0, jeq_else.51584
	fmov	%f4, %f0
	jmp	jeq_cont.51585
jeq_else.51584:
	fdiv	%f4, %f17, %f0
jeq_cont.51585:
	fmul	%f0, %f4, %f4
	setL %g4, l.45192
	fldi	%f1, %g4, 0
	fmul	%f2, %f1, %f0
	setL %g4, l.45194
	fldi	%f1, %g4, 0
	fdiv	%f2, %f2, %f1
	setL %g4, l.45196
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.45198
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45200
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.45202
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45204
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.45206
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45208
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f28, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45211
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.45213
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45215
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.45217
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45219
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f25, %f2
	fdiv	%f1, %f3, %f1
	fmul	%f2, %f25, %f0
	fadd	%f1, %f26, %f1
	fdiv	%f2, %f2, %f1
	setL %g4, l.45223
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f24, %f2
	fdiv	%f1, %f3, %f1
	fadd	%f1, %f23, %f1
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f4, %f0
	jlt	%g0, %g3, jle_else.51586
	jlt	%g3, %g0, jge_else.51588
	fmov	%f1, %f0
	jmp	jge_cont.51589
jge_else.51588:
	fsub	%f1, %f31, %f0
jge_cont.51589:
	jmp	jle_cont.51587
jle_else.51586:
	fsub	%f1, %f22, %f0
jle_cont.51587:
	setL %g3, l.45230
	fldi	%f0, %g3, 0
	fmul	%f0, %f1, %f0
	fdiv	%f0, %f0, %f30
	jmp	fjge_cont.51577
fjge_else.51576:
	setL %g3, l.45188
	fldi	%f0, %g3, 0
fjge_cont.51577:
	fsti	%f0, %g1, 8
	subi	%g1, %g1, 16
	call	min_caml_floor
	addi	%g1, %g1, 16
	fmov	%f1, %f0
	fldi	%f0, %g1, 8
	fsub	%f0, %f0, %f1
	setL %g3, l.45267
	fldi	%f2, %g3, 0
	fsub	%f1, %f21, %f7
	fmul	%f1, %f1, %f1
	fsub	%f1, %f2, %f1
	fsub	%f0, %f21, %f0
	fmul	%f0, %f0, %f0
	fsub	%f1, %f1, %f0
	fjlt	%f1, %f16, fjge_else.51590
	fmov	%f0, %f1
	jmp	fjge_cont.51591
fjge_else.51590:
	fmov	%f0, %f16
fjge_cont.51591:
	fmul	%f1, %f27, %f0
	setL %g3, l.45271
	fldi	%f0, %g3, 0
	fdiv	%f0, %f1, %f0
	fsti	%f0, %g31, 560
	jmp	jeq_cont.51557
jeq_else.51556:
jeq_cont.51557:
jeq_cont.51513:
jeq_cont.51469:
jeq_cont.51461:
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
	fjlt	%f0, %f21, fjge_else.51592
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
	setL %g3, l.45367
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
	jmp	fjge_cont.51593
fjge_else.51592:
	addi	%g4, %g0, 0
	slli	%g3, %g25, 2
	st	%g4, %g18, %g3
fjge_cont.51593:
	setL %g3, l.45389
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
	call	shadow_check_one_or_matrix.2843
	addi	%g1, %g1, 16
	jne	%g3, %g0, jeq_else.51594
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
	fjlt	%f16, %f1, fjge_else.51596
	jmp	fjge_cont.51597
fjge_else.51596:
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
fjge_cont.51597:
	fjlt	%f16, %f0, fjge_else.51598
	jmp	fjge_cont.51599
fjge_else.51598:
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
fjge_cont.51599:
	jmp	jeq_cont.51595
jeq_else.51594:
jeq_cont.51595:
	fldi	%f0, %g31, 540
	fsti	%f0, %g31, 636
	fldi	%f0, %g31, 536
	fsti	%f0, %g31, 632
	fldi	%f0, %g31, 532
	fsti	%f0, %g31, 628
	ldi	%g3, %g31, 28
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.51600
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
	jne	%g6, %g5, jeq_else.51602
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
	jmp	jeq_cont.51603
jeq_else.51602:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.51604
	jmp	jle_cont.51605
jle_else.51604:
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
	jne	%g5, %g0, jeq_else.51606
	fmov	%f3, %f4
	jmp	jeq_cont.51607
jeq_else.51606:
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
jeq_cont.51607:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.51608
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.51609
jeq_else.51608:
	fmov	%f0, %f3
jeq_cont.51609:
	fsti	%f0, %g7, -12
jle_cont.51605:
jeq_cont.51603:
	subi	%g4, %g3, 1
	subi	%g3, %g31, 540
	subi	%g1, %g1, 16
	call	setup_startp_constants.2806
	addi	%g1, %g1, 16
	jmp	jge_cont.51601
jge_else.51600:
jge_cont.51601:
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
	call	trace_reflections.2890
	addi	%g1, %g1, 56
	setL %g3, l.42726
	fldi	%f0, %g3, 0
	fjlt	%f0, %f13, fjge_else.51610
	return
fjge_else.51610:
	addi	%g3, %g0, 4
	jlt	%g25, %g3, jle_else.51612
	jmp	jle_cont.51613
jle_else.51612:
	addi	%g3, %g25, 1
	addi	%g4, %g0, -1
	slli	%g3, %g3, 2
	ldi	%g19, %g1, 48
	st	%g4, %g19, %g3
jle_cont.51613:
	addi	%g3, %g0, 2
	jne	%g30, %g3, jeq_else.51614
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
	jmp	trace_ray.2895
jeq_else.51614:
	return
jle_else.51435:
	return

!==============================
! args = [%g21, %g3]
! fargs = [%f10]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
trace_diffuse_ray.2901:
	setL %g4, l.42275
	fldi	%f0, %g4, 0
	fsti	%f0, %g31, 528
	addi	%g19, %g0, 0
	ldi	%g20, %g31, 516
	mov	%g17, %g3
	mov	%g18, %g21
	subi	%g1, %g1, 4
	call	trace_or_matrix_fast.2868
	addi	%g1, %g1, 4
	fldi	%f0, %g31, 528
	setL %g3, l.44281
	fldi	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.51617
	addi	%g3, %g0, 0
	jmp	fjge_cont.51618
fjge_else.51617:
	setL %g3, l.45016
	fldi	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.51619
	addi	%g3, %g0, 0
	jmp	fjge_cont.51620
fjge_else.51619:
	addi	%g3, %g0, 1
fjge_cont.51620:
fjge_cont.51618:
	jne	%g3, %g0, jeq_else.51621
	return
jeq_else.51621:
	ldi	%g3, %g31, 544
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g14, %g3, 272
	ldi	%g3, %g14, -4
	jne	%g3, %g28, jeq_else.51623
	ldi	%g3, %g31, 524
	fsti	%f16, %g31, 556
	fsti	%f16, %g31, 552
	fsti	%f16, %g31, 548
	subi	%g4, %g3, 1
	slli	%g3, %g4, 2
	fld	%f1, %g21, %g3
	fjeq	%f1, %f16, fjne_else.51625
	fjlt	%f16, %f1, fjge_else.51627
	setL %g3, l.43536
	fldi	%f0, %g3, 0
	jmp	fjge_cont.51628
fjge_else.51627:
	setL %g3, l.42509
	fldi	%f0, %g3, 0
fjge_cont.51628:
	jmp	fjne_cont.51626
fjne_else.51625:
	fmov	%f0, %f16
fjne_cont.51626:
	fneg	%f0, %f0
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	fsti	%f0, %g3, 556
	jmp	jeq_cont.51624
jeq_else.51623:
	addi	%g4, %g0, 2
	jne	%g3, %g4, jeq_else.51629
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
	jmp	jeq_cont.51630
jeq_else.51629:
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
	jne	%g3, %g0, jeq_else.51631
	fsti	%f2, %g31, 556
	fsti	%f6, %g31, 552
	fsti	%f7, %g31, 548
	jmp	jeq_cont.51632
jeq_else.51631:
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
jeq_cont.51632:
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
	fjeq	%f1, %f16, fjne_else.51633
	jne	%g3, %g0, jeq_else.51635
	fdiv	%f0, %f17, %f1
	jmp	jeq_cont.51636
jeq_else.51635:
	fdiv	%f0, %f20, %f1
jeq_cont.51636:
	jmp	fjne_cont.51634
fjne_else.51633:
	setL %g3, l.42509
	fldi	%f0, %g3, 0
fjne_cont.51634:
	fmul	%f1, %f2, %f0
	fsti	%f1, %g31, 556
	fldi	%f1, %g31, 552
	fmul	%f1, %f1, %f0
	fsti	%f1, %g31, 552
	fldi	%f1, %g31, 548
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 548
jeq_cont.51630:
jeq_cont.51624:
	ldi	%g3, %g14, 0
	ldi	%g4, %g14, -32
	fldi	%f0, %g4, 0
	fsti	%f0, %g31, 568
	fldi	%f0, %g4, -4
	fsti	%f0, %g31, 564
	fldi	%f0, %g4, -8
	fsti	%f0, %g31, 560
	jne	%g3, %g28, jeq_else.51637
	fldi	%f1, %g31, 540
	ldi	%g5, %g14, -20
	fldi	%f0, %g5, 0
	fsub	%f5, %f1, %f0
	setL %g3, l.45321
	fldi	%f9, %g3, 0
	fmul	%f0, %f5, %f9
	subi	%g1, %g1, 4
	call	min_caml_floor
	setL %g3, l.45323
	fldi	%f8, %g3, 0
	fmul	%f0, %f0, %f8
	fsub	%f7, %f5, %f0
	setL %g3, l.45282
	fldi	%f6, %g3, 0
	fldi	%f1, %g31, 532
	fldi	%f0, %g5, -8
	fsub	%f5, %f1, %f0
	fmul	%f0, %f5, %f9
	call	min_caml_floor
	addi	%g1, %g1, 4
	fmul	%f0, %f0, %f8
	fsub	%f1, %f5, %f0
	fjlt	%f7, %f6, fjge_else.51639
	fjlt	%f1, %f6, fjge_else.51641
	setL %g3, l.42271
	fldi	%f0, %g3, 0
	jmp	fjge_cont.51642
fjge_else.51641:
	setL %g3, l.42257
	fldi	%f0, %g3, 0
fjge_cont.51642:
	jmp	fjge_cont.51640
fjge_else.51639:
	fjlt	%f1, %f6, fjge_else.51643
	setL %g3, l.42257
	fldi	%f0, %g3, 0
	jmp	fjge_cont.51644
fjge_else.51643:
	setL %g3, l.42271
	fldi	%f0, %g3, 0
fjge_cont.51644:
fjge_cont.51640:
	fsti	%f0, %g31, 564
	jmp	jeq_cont.51638
jeq_else.51637:
	addi	%g4, %g0, 2
	jne	%g3, %g4, jeq_else.51645
	fldi	%f1, %g31, 536
	setL %g3, l.45301
	fldi	%f0, %g3, 0
	fmul	%f2, %f1, %f0
	setL %g3, l.42247
	fldi	%f3, %g3, 0
	setL %g3, l.42249
	fldi	%f4, %g3, 0
	fjlt	%f2, %f16, fjge_else.51647
	fmov	%f1, %f2
	jmp	fjge_cont.51648
fjge_else.51647:
	fneg	%f1, %f2
fjge_cont.51648:
	fjlt	%f29, %f1, fjge_else.51649
	fjlt	%f1, %f16, fjge_else.51651
	fmov	%f0, %f1
	jmp	fjge_cont.51652
fjge_else.51651:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51653
	fjlt	%f1, %f16, fjge_else.51655
	fmov	%f0, %f1
	jmp	fjge_cont.51656
fjge_else.51655:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51657
	fjlt	%f1, %f16, fjge_else.51659
	fmov	%f0, %f1
	jmp	fjge_cont.51660
fjge_else.51659:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.51660:
	jmp	fjge_cont.51658
fjge_else.51657:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.51658:
fjge_cont.51656:
	jmp	fjge_cont.51654
fjge_else.51653:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51661
	fjlt	%f1, %f16, fjge_else.51663
	fmov	%f0, %f1
	jmp	fjge_cont.51664
fjge_else.51663:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.51664:
	jmp	fjge_cont.51662
fjge_else.51661:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.51662:
fjge_cont.51654:
fjge_cont.51652:
	jmp	fjge_cont.51650
fjge_else.51649:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51665
	fjlt	%f1, %f16, fjge_else.51667
	fmov	%f0, %f1
	jmp	fjge_cont.51668
fjge_else.51667:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51669
	fjlt	%f1, %f16, fjge_else.51671
	fmov	%f0, %f1
	jmp	fjge_cont.51672
fjge_else.51671:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.51672:
	jmp	fjge_cont.51670
fjge_else.51669:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.51670:
fjge_cont.51668:
	jmp	fjge_cont.51666
fjge_else.51665:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51673
	fjlt	%f1, %f16, fjge_else.51675
	fmov	%f0, %f1
	jmp	fjge_cont.51676
fjge_else.51675:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.51676:
	jmp	fjge_cont.51674
fjge_else.51673:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2497
	addi	%g1, %g1, 4
fjge_cont.51674:
fjge_cont.51666:
fjge_cont.51650:
	fjlt	%f3, %f0, fjge_else.51677
	fjlt	%f16, %f2, fjge_else.51679
	addi	%g3, %g0, 0
	jmp	fjge_cont.51680
fjge_else.51679:
	addi	%g3, %g0, 1
fjge_cont.51680:
	jmp	fjge_cont.51678
fjge_else.51677:
	fjlt	%f16, %f2, fjge_else.51681
	addi	%g3, %g0, 1
	jmp	fjge_cont.51682
fjge_else.51681:
	addi	%g3, %g0, 0
fjge_cont.51682:
fjge_cont.51678:
	fjlt	%f3, %f0, fjge_else.51683
	fmov	%f1, %f0
	jmp	fjge_cont.51684
fjge_else.51683:
	fsub	%f1, %f29, %f0
fjge_cont.51684:
	fjlt	%f22, %f1, fjge_else.51685
	fmov	%f0, %f1
	jmp	fjge_cont.51686
fjge_else.51685:
	fsub	%f0, %f3, %f1
fjge_cont.51686:
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
	jne	%g3, %g0, jeq_else.51687
	fneg	%f1, %f0
	jmp	jeq_cont.51688
jeq_else.51687:
	fmov	%f1, %f0
jeq_cont.51688:
	fmul	%f0, %f1, %f1
	fmul	%f1, %f27, %f0
	fsti	%f1, %g31, 568
	fsub	%f0, %f17, %f0
	fmul	%f0, %f27, %f0
	fsti	%f0, %g31, 564
	jmp	jeq_cont.51646
jeq_else.51645:
	addi	%g4, %g0, 3
	jne	%g3, %g4, jeq_else.51689
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
	setL %g3, l.45282
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
	setL %g3, l.42247
	fldi	%f3, %g3, 0
	setL %g3, l.42249
	fldi	%f4, %g3, 0
	fjlt	%f2, %f16, fjge_else.51691
	fmov	%f1, %f2
	jmp	fjge_cont.51692
fjge_else.51691:
	fneg	%f1, %f2
fjge_cont.51692:
	fjlt	%f29, %f1, fjge_else.51693
	fjlt	%f1, %f16, fjge_else.51695
	fmov	%f0, %f1
	jmp	fjge_cont.51696
fjge_else.51695:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51697
	fjlt	%f1, %f16, fjge_else.51699
	fmov	%f0, %f1
	jmp	fjge_cont.51700
fjge_else.51699:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51701
	fjlt	%f1, %f16, fjge_else.51703
	fmov	%f0, %f1
	jmp	fjge_cont.51704
fjge_else.51703:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.51704:
	jmp	fjge_cont.51702
fjge_else.51701:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.51702:
fjge_cont.51700:
	jmp	fjge_cont.51698
fjge_else.51697:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51705
	fjlt	%f1, %f16, fjge_else.51707
	fmov	%f0, %f1
	jmp	fjge_cont.51708
fjge_else.51707:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.51708:
	jmp	fjge_cont.51706
fjge_else.51705:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.51706:
fjge_cont.51698:
fjge_cont.51696:
	jmp	fjge_cont.51694
fjge_else.51693:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51709
	fjlt	%f1, %f16, fjge_else.51711
	fmov	%f0, %f1
	jmp	fjge_cont.51712
fjge_else.51711:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51713
	fjlt	%f1, %f16, fjge_else.51715
	fmov	%f0, %f1
	jmp	fjge_cont.51716
fjge_else.51715:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.51716:
	jmp	fjge_cont.51714
fjge_else.51713:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.51714:
fjge_cont.51712:
	jmp	fjge_cont.51710
fjge_else.51709:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.51717
	fjlt	%f1, %f16, fjge_else.51719
	fmov	%f0, %f1
	jmp	fjge_cont.51720
fjge_else.51719:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.51720:
	jmp	fjge_cont.51718
fjge_else.51717:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2497
	addi	%g1, %g1, 8
fjge_cont.51718:
fjge_cont.51710:
fjge_cont.51694:
	fjlt	%f3, %f0, fjge_else.51721
	fjlt	%f16, %f2, fjge_else.51723
	addi	%g3, %g0, 0
	jmp	fjge_cont.51724
fjge_else.51723:
	addi	%g3, %g0, 1
fjge_cont.51724:
	jmp	fjge_cont.51722
fjge_else.51721:
	fjlt	%f16, %f2, fjge_else.51725
	addi	%g3, %g0, 1
	jmp	fjge_cont.51726
fjge_else.51725:
	addi	%g3, %g0, 0
fjge_cont.51726:
fjge_cont.51722:
	fjlt	%f3, %f0, fjge_else.51727
	fmov	%f1, %f0
	jmp	fjge_cont.51728
fjge_else.51727:
	fsub	%f1, %f29, %f0
fjge_cont.51728:
	fjlt	%f22, %f1, fjge_else.51729
	fmov	%f0, %f1
	jmp	fjge_cont.51730
fjge_else.51729:
	fsub	%f0, %f3, %f1
fjge_cont.51730:
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
	jne	%g3, %g0, jeq_else.51731
	fneg	%f1, %f0
	jmp	jeq_cont.51732
jeq_else.51731:
	fmov	%f1, %f0
jeq_cont.51732:
	fmul	%f0, %f1, %f1
	fmul	%f1, %f0, %f27
	fsti	%f1, %g31, 564
	fsub	%f0, %f17, %f0
	fmul	%f0, %f0, %f27
	fsti	%f0, %g31, 560
	jmp	jeq_cont.51690
jeq_else.51689:
	addi	%g4, %g0, 4
	jne	%g3, %g4, jeq_else.51733
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
	fjlt	%f1, %f16, fjge_else.51735
	fmov	%f0, %f1
	jmp	fjge_cont.51736
fjge_else.51735:
	fneg	%f0, %f1
fjge_cont.51736:
	setL %g3, l.45186
	fldi	%f6, %g3, 0
	fjlt	%f0, %f6, fjge_else.51737
	fdiv	%f1, %f2, %f1
	fjlt	%f1, %f16, fjge_else.51739
	fmov	%f0, %f1
	jmp	fjge_cont.51740
fjge_else.51739:
	fneg	%f0, %f1
fjge_cont.51740:
	fjlt	%f17, %f0, fjge_else.51741
	fjlt	%f0, %f20, fjge_else.51743
	addi	%g3, %g0, 0
	jmp	fjge_cont.51744
fjge_else.51743:
	addi	%g3, %g0, -1
fjge_cont.51744:
	jmp	fjge_cont.51742
fjge_else.51741:
	addi	%g3, %g0, 1
fjge_cont.51742:
	jne	%g3, %g0, jeq_else.51745
	fmov	%f4, %f0
	jmp	jeq_cont.51746
jeq_else.51745:
	fdiv	%f4, %f17, %f0
jeq_cont.51746:
	fmul	%f0, %f4, %f4
	setL %g4, l.45192
	fldi	%f1, %g4, 0
	fmul	%f2, %f1, %f0
	setL %g4, l.45194
	fldi	%f1, %g4, 0
	fdiv	%f2, %f2, %f1
	setL %g4, l.45196
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.45198
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45200
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.45202
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45204
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.45206
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45208
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f28, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45211
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.45213
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45215
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.45217
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45219
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f25, %f2
	fdiv	%f1, %f3, %f1
	fmul	%f2, %f25, %f0
	fadd	%f1, %f26, %f1
	fdiv	%f2, %f2, %f1
	setL %g4, l.45223
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f24, %f2
	fdiv	%f1, %f3, %f1
	fadd	%f1, %f23, %f1
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f4, %f0
	jlt	%g0, %g3, jle_else.51747
	jlt	%g3, %g0, jge_else.51749
	fmov	%f0, %f1
	jmp	jge_cont.51750
jge_else.51749:
	fsub	%f0, %f31, %f1
jge_cont.51750:
	jmp	jle_cont.51748
jle_else.51747:
	fsub	%f0, %f22, %f1
jle_cont.51748:
	setL %g3, l.45230
	fldi	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fdiv	%f0, %f0, %f30
	jmp	fjge_cont.51738
fjge_else.51737:
	setL %g3, l.45188
	fldi	%f0, %g3, 0
fjge_cont.51738:
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
	fjlt	%f5, %f16, fjge_else.51751
	fmov	%f0, %f5
	jmp	fjge_cont.51752
fjge_else.51751:
	fneg	%f0, %f5
fjge_cont.51752:
	fjlt	%f0, %f6, fjge_else.51753
	fdiv	%f1, %f1, %f5
	fjlt	%f1, %f16, fjge_else.51755
	fmov	%f0, %f1
	jmp	fjge_cont.51756
fjge_else.51755:
	fneg	%f0, %f1
fjge_cont.51756:
	fjlt	%f17, %f0, fjge_else.51757
	fjlt	%f0, %f20, fjge_else.51759
	addi	%g3, %g0, 0
	jmp	fjge_cont.51760
fjge_else.51759:
	addi	%g3, %g0, -1
fjge_cont.51760:
	jmp	fjge_cont.51758
fjge_else.51757:
	addi	%g3, %g0, 1
fjge_cont.51758:
	jne	%g3, %g0, jeq_else.51761
	fmov	%f4, %f0
	jmp	jeq_cont.51762
jeq_else.51761:
	fdiv	%f4, %f17, %f0
jeq_cont.51762:
	fmul	%f0, %f4, %f4
	setL %g4, l.45192
	fldi	%f1, %g4, 0
	fmul	%f2, %f1, %f0
	setL %g4, l.45194
	fldi	%f1, %g4, 0
	fdiv	%f2, %f2, %f1
	setL %g4, l.45196
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.45198
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45200
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.45202
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45204
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.45206
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45208
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f28, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45211
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.45213
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45215
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.45217
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.45219
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f25, %f2
	fdiv	%f2, %f3, %f1
	fmul	%f1, %f25, %f0
	fadd	%f2, %f26, %f2
	fdiv	%f1, %f1, %f2
	setL %g4, l.45223
	fldi	%f2, %g4, 0
	fmul	%f2, %f2, %f0
	fadd	%f1, %f24, %f1
	fdiv	%f1, %f2, %f1
	fadd	%f1, %f23, %f1
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f4, %f0
	jlt	%g0, %g3, jle_else.51763
	jlt	%g3, %g0, jge_else.51765
	fmov	%f1, %f0
	jmp	jge_cont.51766
jge_else.51765:
	fsub	%f1, %f31, %f0
jge_cont.51766:
	jmp	jle_cont.51764
jle_else.51763:
	fsub	%f1, %f22, %f0
jle_cont.51764:
	setL %g3, l.45230
	fldi	%f0, %g3, 0
	fmul	%f0, %f1, %f0
	fdiv	%f0, %f0, %f30
	jmp	fjge_cont.51754
fjge_else.51753:
	setL %g3, l.45188
	fldi	%f0, %g3, 0
fjge_cont.51754:
	fsti	%f0, %g1, 8
	subi	%g1, %g1, 16
	call	min_caml_floor
	addi	%g1, %g1, 16
	fmov	%f1, %f0
	fldi	%f0, %g1, 8
	fsub	%f0, %f0, %f1
	setL %g3, l.45267
	fldi	%f2, %g3, 0
	fsub	%f1, %f21, %f7
	fmul	%f1, %f1, %f1
	fsub	%f1, %f2, %f1
	fsub	%f0, %f21, %f0
	fmul	%f0, %f0, %f0
	fsub	%f1, %f1, %f0
	fjlt	%f1, %f16, fjge_else.51767
	fmov	%f0, %f1
	jmp	fjge_cont.51768
fjge_else.51767:
	fmov	%f0, %f16
fjge_cont.51768:
	fmul	%f1, %f27, %f0
	setL %g3, l.45271
	fldi	%f0, %g3, 0
	fdiv	%f0, %f1, %f0
	fsti	%f0, %g31, 560
	jmp	jeq_cont.51734
jeq_else.51733:
jeq_cont.51734:
jeq_cont.51690:
jeq_cont.51646:
jeq_cont.51638:
	addi	%g12, %g0, 0
	ldi	%g13, %g31, 516
	subi	%g1, %g1, 16
	call	shadow_check_one_or_matrix.2843
	addi	%g1, %g1, 16
	jne	%g3, %g0, jeq_else.51769
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
	fjlt	%f16, %f1, fjge_else.51770
	fmov	%f0, %f16
	jmp	fjge_cont.51771
fjge_else.51770:
	fmov	%f0, %f1
fjge_cont.51771:
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
jeq_else.51769:
	return

!==============================
! args = [%g23, %g22, %g24, %g25]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
iter_trace_diffuse_rays.2904:
	jlt	%g25, %g0, jge_else.51774
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
	fjlt	%f0, %f16, fjge_else.51775
	slli	%g3, %g25, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 4
	jmp	fjge_cont.51776
fjge_else.51775:
	addi	%g3, %g25, 1
	slli	%g3, %g3, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 4
fjge_cont.51776:
	subi	%g25, %g25, 2
	jlt	%g25, %g0, jge_else.51777
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
	fjlt	%f0, %f16, fjge_else.51778
	slli	%g3, %g25, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 4
	jmp	fjge_cont.51779
fjge_else.51778:
	addi	%g3, %g25, 1
	slli	%g3, %g3, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 4
fjge_cont.51779:
	subi	%g25, %g25, 2
	jlt	%g25, %g0, jge_else.51780
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
	fjlt	%f0, %f16, fjge_else.51781
	slli	%g3, %g25, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 4
	jmp	fjge_cont.51782
fjge_else.51781:
	addi	%g3, %g25, 1
	slli	%g3, %g3, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 4
fjge_cont.51782:
	subi	%g25, %g25, 2
	jlt	%g25, %g0, jge_else.51783
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
	fjlt	%f0, %f16, fjge_else.51784
	slli	%g3, %g25, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 4
	jmp	fjge_cont.51785
fjge_else.51784:
	addi	%g3, %g25, 1
	slli	%g3, %g3, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 4
fjge_cont.51785:
	subi	%g25, %g25, 2
	jmp	iter_trace_diffuse_rays.2904
jge_else.51783:
	return
jge_else.51780:
	return
jge_else.51777:
	return
jge_else.51774:
	return

!==============================
! args = [%g15, %g14, %g13, %g12, %g11, %g10, %g9, %g25, %g26]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
do_without_neighbors.2926:
	addi	%g3, %g0, 4
	jlt	%g3, %g26, jle_else.51790
	slli	%g3, %g26, 2
	ld	%g3, %g13, %g3
	jlt	%g3, %g0, jge_else.51791
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
	jne	%g3, %g0, jeq_else.51792
	jmp	jeq_cont.51793
jeq_else.51792:
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
	jne	%g30, %g0, jeq_else.51794
	jmp	jeq_cont.51795
jeq_else.51794:
	ldi	%g23, %g31, 716
	fldi	%f0, %g24, 0
	fsti	%f0, %g31, 636
	fldi	%f0, %g24, -4
	fsti	%f0, %g31, 632
	fldi	%f0, %g24, -8
	fsti	%f0, %g31, 628
	ldi	%g3, %g31, 28
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.51796
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
	jne	%g6, %g5, jeq_else.51798
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
	jmp	jeq_cont.51799
jeq_else.51798:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.51800
	jmp	jle_cont.51801
jle_else.51800:
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
	jne	%g5, %g0, jeq_else.51802
	fmov	%f3, %f4
	jmp	jeq_cont.51803
jeq_else.51802:
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
jeq_cont.51803:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.51804
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.51805
jeq_else.51804:
	fmov	%f0, %f3
jeq_cont.51805:
	fsti	%f0, %g7, -12
jle_cont.51801:
jeq_cont.51799:
	subi	%g4, %g3, 1
	mov	%g3, %g24
	subi	%g1, %g1, 48
	call	setup_startp_constants.2806
	addi	%g1, %g1, 48
	jmp	jge_cont.51797
jge_else.51796:
jge_cont.51797:
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
	fjlt	%f0, %f16, fjge_else.51806
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
	jmp	fjge_cont.51807
fjge_else.51806:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
fjge_cont.51807:
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
	fjlt	%f0, %f16, fjge_else.51808
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
	jmp	fjge_cont.51809
fjge_else.51808:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
fjge_cont.51809:
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
	fjlt	%f0, %f16, fjge_else.51810
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
	jmp	fjge_cont.51811
fjge_else.51810:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
fjge_cont.51811:
	addi	%g3, %g0, 112
	mov	%g25, %g3
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2904
	addi	%g1, %g1, 48
jeq_cont.51795:
	jne	%g30, %g28, jeq_else.51812
	jmp	jeq_cont.51813
jeq_else.51812:
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
	jlt	%g3, %g0, jge_else.51814
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
	jne	%g6, %g5, jeq_else.51816
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
	jmp	jeq_cont.51817
jeq_else.51816:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.51818
	jmp	jle_cont.51819
jle_else.51818:
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
	jne	%g5, %g0, jeq_else.51820
	fmov	%f3, %f4
	jmp	jeq_cont.51821
jeq_else.51820:
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
jeq_cont.51821:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.51822
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.51823
jeq_else.51822:
	fmov	%f0, %f3
jeq_cont.51823:
	fsti	%f0, %g7, -12
jle_cont.51819:
jeq_cont.51817:
	subi	%g4, %g3, 1
	mov	%g3, %g24
	subi	%g1, %g1, 48
	call	setup_startp_constants.2806
	addi	%g1, %g1, 48
	jmp	jge_cont.51815
jge_else.51814:
jge_cont.51815:
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
	fjlt	%f0, %f16, fjge_else.51824
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
	jmp	fjge_cont.51825
fjge_else.51824:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
fjge_cont.51825:
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
	fjlt	%f0, %f16, fjge_else.51826
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
	jmp	fjge_cont.51827
fjge_else.51826:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
fjge_cont.51827:
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
	fjlt	%f0, %f16, fjge_else.51828
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
	jmp	fjge_cont.51829
fjge_else.51828:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
fjge_cont.51829:
	addi	%g3, %g0, 112
	mov	%g25, %g3
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2904
	addi	%g1, %g1, 48
jeq_cont.51813:
	addi	%g3, %g0, 2
	jne	%g30, %g3, jeq_else.51830
	jmp	jeq_cont.51831
jeq_else.51830:
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
	jlt	%g3, %g0, jge_else.51832
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
	jne	%g6, %g5, jeq_else.51834
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
	jmp	jeq_cont.51835
jeq_else.51834:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.51836
	jmp	jle_cont.51837
jle_else.51836:
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
	jne	%g5, %g0, jeq_else.51838
	fmov	%f3, %f4
	jmp	jeq_cont.51839
jeq_else.51838:
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
jeq_cont.51839:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.51840
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.51841
jeq_else.51840:
	fmov	%f0, %f3
jeq_cont.51841:
	fsti	%f0, %g7, -12
jle_cont.51837:
jeq_cont.51835:
	subi	%g4, %g3, 1
	mov	%g3, %g24
	subi	%g1, %g1, 48
	call	setup_startp_constants.2806
	addi	%g1, %g1, 48
	jmp	jge_cont.51833
jge_else.51832:
jge_cont.51833:
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
	fjlt	%f0, %f16, fjge_else.51842
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
	jmp	fjge_cont.51843
fjge_else.51842:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
fjge_cont.51843:
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
	fjlt	%f0, %f16, fjge_else.51844
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
	jmp	fjge_cont.51845
fjge_else.51844:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
fjge_cont.51845:
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
	fjlt	%f0, %f16, fjge_else.51846
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
	jmp	fjge_cont.51847
fjge_else.51846:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
fjge_cont.51847:
	addi	%g3, %g0, 112
	mov	%g25, %g3
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2904
	addi	%g1, %g1, 48
jeq_cont.51831:
	addi	%g3, %g0, 3
	jne	%g30, %g3, jeq_else.51848
	jmp	jeq_cont.51849
jeq_else.51848:
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
	jlt	%g3, %g0, jge_else.51850
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
	jne	%g6, %g5, jeq_else.51852
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
	jmp	jeq_cont.51853
jeq_else.51852:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.51854
	jmp	jle_cont.51855
jle_else.51854:
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
	jne	%g5, %g0, jeq_else.51856
	fmov	%f3, %f4
	jmp	jeq_cont.51857
jeq_else.51856:
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
jeq_cont.51857:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.51858
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.51859
jeq_else.51858:
	fmov	%f0, %f3
jeq_cont.51859:
	fsti	%f0, %g7, -12
jle_cont.51855:
jeq_cont.51853:
	subi	%g4, %g3, 1
	mov	%g3, %g24
	subi	%g1, %g1, 48
	call	setup_startp_constants.2806
	addi	%g1, %g1, 48
	jmp	jge_cont.51851
jge_else.51850:
jge_cont.51851:
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
	fjlt	%f0, %f16, fjge_else.51860
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
	jmp	fjge_cont.51861
fjge_else.51860:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
fjge_cont.51861:
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
	fjlt	%f0, %f16, fjge_else.51862
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
	jmp	fjge_cont.51863
fjge_else.51862:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
fjge_cont.51863:
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
	fjlt	%f0, %f16, fjge_else.51864
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
	jmp	fjge_cont.51865
fjge_else.51864:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
fjge_cont.51865:
	addi	%g3, %g0, 112
	mov	%g25, %g3
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2904
	addi	%g1, %g1, 48
jeq_cont.51849:
	addi	%g3, %g0, 4
	jne	%g30, %g3, jeq_else.51866
	jmp	jeq_cont.51867
jeq_else.51866:
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
	jlt	%g3, %g0, jge_else.51868
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
	jne	%g6, %g5, jeq_else.51870
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
	jmp	jeq_cont.51871
jeq_else.51870:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.51872
	jmp	jle_cont.51873
jle_else.51872:
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
	jne	%g5, %g0, jeq_else.51874
	fmov	%f3, %f4
	jmp	jeq_cont.51875
jeq_else.51874:
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
jeq_cont.51875:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.51876
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.51877
jeq_else.51876:
	fmov	%f0, %f3
jeq_cont.51877:
	fsti	%f0, %g7, -12
jle_cont.51873:
jeq_cont.51871:
	subi	%g4, %g3, 1
	mov	%g3, %g24
	subi	%g1, %g1, 48
	call	setup_startp_constants.2806
	addi	%g1, %g1, 48
	jmp	jge_cont.51869
jge_else.51868:
jge_cont.51869:
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
	fjlt	%f0, %f16, fjge_else.51878
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
	jmp	fjge_cont.51879
fjge_else.51878:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
fjge_cont.51879:
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
	fjlt	%f0, %f16, fjge_else.51880
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
	jmp	fjge_cont.51881
fjge_else.51880:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
fjge_cont.51881:
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
	fjlt	%f0, %f16, fjge_else.51882
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
	jmp	fjge_cont.51883
fjge_else.51882:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 48
fjge_cont.51883:
	addi	%g30, %g0, 112
	mov	%g25, %g30
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2904
	addi	%g1, %g1, 48
jeq_cont.51867:
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
jeq_cont.51793:
	addi	%g26, %g26, 1
	ldi	%g15, %g1, 28
	ldi	%g14, %g1, 24
	ldi	%g13, %g1, 20
	ldi	%g12, %g1, 16
	ldi	%g11, %g1, 12
	ldi	%g10, %g1, 8
	ldi	%g9, %g1, 4
	ldi	%g25, %g1, 0
	jmp	do_without_neighbors.2926
jge_else.51791:
	return
jle_else.51790:
	return

!==============================
! args = [%g4, %g10, %g9, %g5, %g8, %g26]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
try_exploit_neighbors.2942:
	slli	%g3, %g4, 2
	ld	%g6, %g5, %g3
	addi	%g3, %g0, 4
	jlt	%g3, %g26, jle_else.51886
	ldi	%g7, %g6, -8
	slli	%g3, %g26, 2
	ld	%g3, %g7, %g3
	jlt	%g3, %g0, jge_else.51887
	slli	%g7, %g4, 2
	ld	%g7, %g9, %g7
	ldi	%g12, %g7, -8
	slli	%g11, %g26, 2
	ld	%g11, %g12, %g11
	jne	%g11, %g3, jeq_else.51888
	slli	%g11, %g4, 2
	ld	%g11, %g8, %g11
	ldi	%g12, %g11, -8
	slli	%g11, %g26, 2
	ld	%g11, %g12, %g11
	jne	%g11, %g3, jeq_else.51890
	subi	%g11, %g4, 1
	slli	%g11, %g11, 2
	ld	%g11, %g5, %g11
	ldi	%g12, %g11, -8
	slli	%g11, %g26, 2
	ld	%g11, %g12, %g11
	jne	%g11, %g3, jeq_else.51892
	addi	%g11, %g4, 1
	slli	%g11, %g11, 2
	ld	%g11, %g5, %g11
	ldi	%g12, %g11, -8
	slli	%g11, %g26, 2
	ld	%g11, %g12, %g11
	jne	%g11, %g3, jeq_else.51894
	addi	%g11, %g0, 1
	jmp	jeq_cont.51895
jeq_else.51894:
	addi	%g11, %g0, 0
jeq_cont.51895:
	jmp	jeq_cont.51893
jeq_else.51892:
	addi	%g11, %g0, 0
jeq_cont.51893:
	jmp	jeq_cont.51891
jeq_else.51890:
	addi	%g11, %g0, 0
jeq_cont.51891:
	jmp	jeq_cont.51889
jeq_else.51888:
	addi	%g11, %g0, 0
jeq_cont.51889:
	jne	%g11, %g0, jeq_else.51896
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
	jmp	do_without_neighbors.2926
jeq_else.51896:
	ldi	%g11, %g6, -12
	slli	%g3, %g26, 2
	ld	%g3, %g11, %g3
	jne	%g3, %g0, jeq_else.51897
	jmp	jeq_cont.51898
jeq_else.51897:
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
jeq_cont.51898:
	addi	%g26, %g26, 1
	jmp	try_exploit_neighbors.2942
jge_else.51887:
	return
jle_else.51886:
	return

!==============================
! args = [%g14, %g12, %g11, %g10, %g13, %g9, %g25, %g30, %g26]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
pretrace_diffuse_rays.2955:
	addi	%g3, %g0, 4
	jlt	%g3, %g26, jle_else.51901
	slli	%g3, %g26, 2
	ld	%g3, %g11, %g3
	jlt	%g3, %g0, jge_else.51902
	slli	%g3, %g26, 2
	ld	%g3, %g10, %g3
	sti	%g25, %g1, 0
	sti	%g13, %g1, 4
	sti	%g10, %g1, 8
	sti	%g11, %g1, 12
	sti	%g12, %g1, 16
	sti	%g14, %g1, 20
	jne	%g3, %g0, jeq_else.51903
	jmp	jeq_cont.51904
jeq_else.51903:
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
	jlt	%g7, %g0, jge_else.51905
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
	jne	%g5, %g4, jeq_else.51907
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
	jmp	jeq_cont.51908
jeq_else.51907:
	addi	%g4, %g0, 2
	jlt	%g4, %g5, jle_else.51909
	jmp	jle_cont.51910
jle_else.51909:
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
	jne	%g4, %g0, jeq_else.51911
	fmov	%f3, %f4
	jmp	jeq_cont.51912
jeq_else.51911:
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
jeq_cont.51912:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.51913
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.51914
jeq_else.51913:
	fmov	%f0, %f3
jeq_cont.51914:
	fsti	%f0, %g6, -12
jle_cont.51910:
jeq_cont.51908:
	subi	%g4, %g7, 1
	mov	%g3, %g24
	subi	%g1, %g1, 28
	call	setup_startp_constants.2806
	addi	%g1, %g1, 28
	jmp	jge_cont.51906
jge_else.51905:
jge_cont.51906:
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
	fjlt	%f0, %f16, fjge_else.51915
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 32
	jmp	fjge_cont.51916
fjge_else.51915:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 32
fjge_cont.51916:
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
	fjlt	%f0, %f16, fjge_else.51917
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 32
	jmp	fjge_cont.51918
fjge_else.51917:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 32
fjge_cont.51918:
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
	fjlt	%f0, %f16, fjge_else.51919
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 32
	jmp	fjge_cont.51920
fjge_else.51919:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2901
	addi	%g1, %g1, 32
fjge_cont.51920:
	addi	%g3, %g0, 112
	mov	%g25, %g3
	subi	%g1, %g1, 32
	call	iter_trace_diffuse_rays.2904
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
jeq_cont.51904:
	addi	%g26, %g26, 1
	ldi	%g14, %g1, 20
	ldi	%g12, %g1, 16
	ldi	%g11, %g1, 12
	ldi	%g10, %g1, 8
	ldi	%g13, %g1, 4
	ldi	%g25, %g1, 0
	jmp	pretrace_diffuse_rays.2955
jge_else.51902:
	return
jle_else.51901:
	return

!==============================
! args = [%g7, %g6, %g8]
! fargs = [%f13, %f12, %f11]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
pretrace_pixels.2958:
	jlt	%g6, %g0, jge_else.51923
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
	fjeq	%f0, %f16, fjne_else.51924
	fdiv	%f1, %f17, %f0
	jmp	fjne_cont.51925
fjne_else.51924:
	setL %g3, l.42509
	fldi	%f1, %g3, 0
fjne_cont.51925:
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
	call	trace_ray.2895
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
	call	pretrace_diffuse_rays.2955
	addi	%g1, %g1, 28
	ldi	%g6, %g1, 20
	subi	%g6, %g6, 1
	ldi	%g8, %g1, 12
	addi	%g3, %g8, 1
	addi	%g8, %g0, 5
	jlt	%g3, %g8, jle_else.51926
	subi	%g8, %g3, 5
	jmp	jle_cont.51927
jle_else.51926:
	mov	%g8, %g3
jle_cont.51927:
	fldi	%f13, %g1, 8
	fldi	%f12, %g1, 4
	fldi	%f11, %g1, 0
	ldi	%g7, %g1, 16
	jmp	pretrace_pixels.2958
jge_else.51923:
	return

!==============================
! args = [%g14, %g15, %g17, %g16, %g18]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
scan_pixel.2969:
	ldi	%g3, %g31, 600
	jlt	%g14, %g3, jle_else.51929
	return
jle_else.51929:
	slli	%g3, %g14, 2
	ld	%g3, %g16, %g3
	ldi	%g3, %g3, 0
	fldi	%f0, %g3, 0
	fsti	%f0, %g31, 592
	fldi	%f0, %g3, -4
	fsti	%f0, %g31, 588
	fldi	%f0, %g3, -8
	fsti	%f0, %g31, 584
	ldi	%g4, %g31, 596
	addi	%g3, %g15, 1
	jlt	%g3, %g4, jle_else.51931
	addi	%g3, %g0, 0
	jmp	jle_cont.51932
jle_else.51931:
	jlt	%g0, %g15, jle_else.51933
	addi	%g3, %g0, 0
	jmp	jle_cont.51934
jle_else.51933:
	ldi	%g4, %g31, 600
	addi	%g3, %g14, 1
	jlt	%g3, %g4, jle_else.51935
	addi	%g3, %g0, 0
	jmp	jle_cont.51936
jle_else.51935:
	jlt	%g0, %g14, jle_else.51937
	addi	%g3, %g0, 0
	jmp	jle_cont.51938
jle_else.51937:
	addi	%g3, %g0, 1
jle_cont.51938:
jle_cont.51936:
jle_cont.51934:
jle_cont.51932:
	sti	%g18, %g1, 0
	sti	%g16, %g1, 4
	sti	%g17, %g1, 8
	sti	%g15, %g1, 12
	sti	%g14, %g1, 16
	jne	%g3, %g0, jeq_else.51939
	slli	%g3, %g14, 2
	ld	%g4, %g16, %g3
	addi	%g26, %g0, 0
	ldi	%g25, %g4, -28
	ldi	%g9, %g4, -24
	ldi	%g10, %g4, -20
	ldi	%g11, %g4, -16
	ldi	%g12, %g4, -12
	ldi	%g13, %g4, -8
	ldi	%g3, %g4, -4
	ldi	%g4, %g4, 0
	mov	%g14, %g3
	mov	%g15, %g4
	subi	%g1, %g1, 24
	call	do_without_neighbors.2926
	addi	%g1, %g1, 24
	jmp	jeq_cont.51940
jeq_else.51939:
	addi	%g26, %g0, 0
	mov	%g8, %g18
	mov	%g5, %g16
	mov	%g9, %g17
	mov	%g10, %g15
	mov	%g4, %g14
	subi	%g1, %g1, 24
	call	try_exploit_neighbors.2942
	addi	%g1, %g1, 24
jeq_cont.51940:
	fldi	%f0, %g31, 592
	subi	%g1, %g1, 24
	call	min_caml_int_of_float
	addi	%g1, %g1, 24
	addi	%g4, %g0, 255
	jlt	%g4, %g3, jle_else.51941
	jlt	%g3, %g0, jge_else.51943
	mov	%g4, %g3
	jmp	jge_cont.51944
jge_else.51943:
	addi	%g4, %g0, 0
jge_cont.51944:
	jmp	jle_cont.51942
jle_else.51941:
	addi	%g4, %g0, 255
jle_cont.51942:
	subi	%g1, %g1, 24
	call	print_int.2528
	addi	%g3, %g0, 32
	output	%g3
	fldi	%f0, %g31, 588
	call	min_caml_int_of_float
	addi	%g1, %g1, 24
	addi	%g4, %g0, 255
	jlt	%g4, %g3, jle_else.51945
	jlt	%g3, %g0, jge_else.51947
	mov	%g4, %g3
	jmp	jge_cont.51948
jge_else.51947:
	addi	%g4, %g0, 0
jge_cont.51948:
	jmp	jle_cont.51946
jle_else.51945:
	addi	%g4, %g0, 255
jle_cont.51946:
	subi	%g1, %g1, 24
	call	print_int.2528
	addi	%g3, %g0, 32
	output	%g3
	fldi	%f0, %g31, 584
	call	min_caml_int_of_float
	addi	%g1, %g1, 24
	addi	%g4, %g0, 255
	jlt	%g4, %g3, jle_else.51949
	jlt	%g3, %g0, jge_else.51951
	mov	%g4, %g3
	jmp	jge_cont.51952
jge_else.51951:
	addi	%g4, %g0, 0
jge_cont.51952:
	jmp	jle_cont.51950
jle_else.51949:
	addi	%g4, %g0, 255
jle_cont.51950:
	subi	%g1, %g1, 24
	call	print_int.2528
	addi	%g1, %g1, 24
	addi	%g3, %g0, 10
	output	%g3
	ldi	%g14, %g1, 16
	addi	%g14, %g14, 1
	ldi	%g15, %g1, 12
	ldi	%g17, %g1, 8
	ldi	%g16, %g1, 4
	ldi	%g18, %g1, 0
	jmp	scan_pixel.2969

!==============================
! args = [%g15, %g7, %g17, %g16, %g8]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
scan_line.2975:
	ldi	%g3, %g31, 596
	jlt	%g15, %g3, jle_else.51953
	return
jle_else.51953:
	subi	%g3, %g3, 1
	sti	%g8, %g1, 0
	sti	%g16, %g1, 4
	sti	%g17, %g1, 8
	sti	%g7, %g1, 12
	sti	%g15, %g1, 16
	jlt	%g15, %g3, jle_else.51955
	jmp	jle_cont.51956
jle_else.51955:
	addi	%g4, %g15, 1
	fldi	%f3, %g31, 612
	ldi	%g3, %g31, 604
	sub	%g3, %g4, %g3
	subi	%g1, %g1, 24
	call	min_caml_float_of_int
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
	mov	%g7, %g16
	call	pretrace_pixels.2958
	addi	%g1, %g1, 24
jle_cont.51956:
	addi	%g14, %g0, 0
	ldi	%g15, %g1, 16
	ldi	%g7, %g1, 12
	ldi	%g17, %g1, 8
	ldi	%g16, %g1, 4
	mov	%g18, %g16
	mov	%g16, %g17
	mov	%g17, %g7
	subi	%g1, %g1, 24
	call	scan_pixel.2969
	addi	%g1, %g1, 24
	ldi	%g15, %g1, 16
	addi	%g15, %g15, 1
	ldi	%g8, %g1, 0
	addi	%g3, %g8, 2
	addi	%g8, %g0, 5
	jlt	%g3, %g8, jle_else.51957
	subi	%g8, %g3, 5
	jmp	jle_cont.51958
jle_else.51957:
	mov	%g8, %g3
jle_cont.51958:
	ldi	%g3, %g31, 596
	jlt	%g15, %g3, jle_else.51959
	return
jle_else.51959:
	subi	%g3, %g3, 1
	sti	%g8, %g1, 20
	sti	%g15, %g1, 24
	jlt	%g15, %g3, jle_else.51961
	jmp	jle_cont.51962
jle_else.51961:
	addi	%g4, %g15, 1
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
	subi	%g6, %g3, 1
	ldi	%g7, %g1, 12
	subi	%g1, %g1, 32
	call	pretrace_pixels.2958
	addi	%g1, %g1, 32
jle_cont.51962:
	addi	%g14, %g0, 0
	ldi	%g15, %g1, 24
	ldi	%g17, %g1, 8
	ldi	%g16, %g1, 4
	ldi	%g7, %g1, 12
	mov	%g18, %g7
	subi	%g1, %g1, 32
	call	scan_pixel.2969
	addi	%g1, %g1, 32
	ldi	%g15, %g1, 24
	addi	%g15, %g15, 1
	ldi	%g8, %g1, 20
	addi	%g4, %g8, 2
	addi	%g3, %g0, 5
	jlt	%g4, %g3, jle_else.51963
	subi	%g3, %g4, 5
	jmp	jle_cont.51964
jle_else.51963:
	mov	%g3, %g4
jle_cont.51964:
	ldi	%g16, %g1, 4
	ldi	%g7, %g1, 12
	ldi	%g17, %g1, 8
	mov	%g8, %g3
	mov	%g27, %g16
	mov	%g16, %g17
	mov	%g17, %g7
	mov	%g7, %g27
	jmp	scan_line.2975

!==============================
! args = [%g10, %g9]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g2, %g14, %g13, %g12, %g11, %g10, %f16, %f15, %f0, %dummy]
! ret type = Array((Array(Float) * Array(Array(Float)) * Array(Int) * Array(Bool) * Array(Array(Float)) * Array(Array(Float)) * Array(Int) * Array(Array(Float))))
!================================
init_line_elements.2985:
	jlt	%g9, %g0, jge_else.51965
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
	jmp	init_line_elements.2985
jge_else.51965:
	mov	%g3, %g10
	return

!==============================
! args = [%g4, %g5, %g3]
! fargs = [%f5, %f1, %f2, %f0]
! use_regs = [%g7, %g6, %g5, %g4, %g3, %g27, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f3, %f28, %f26, %f25, %f24, %f23, %f22, %f20, %f2, %f17, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
calc_dirvec.2993:
	fsti	%f0, %g1, 0
	fsti	%f2, %g1, 4
	addi	%g6, %g0, 5
	jlt	%g4, %g6, jle_else.51966
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
jle_else.51966:
	fmul	%f0, %f1, %f1
	setL %g6, l.42726
	fldi	%f6, %g6, 0
	fadd	%f0, %f0, %f6
	fsqrt	%f5, %f0
	fdiv	%f0, %f17, %f5
	fjlt	%f17, %f0, fjge_else.51968
	fjlt	%f0, %f20, fjge_else.51970
	addi	%g6, %g0, 0
	jmp	fjge_cont.51971
fjge_else.51970:
	addi	%g6, %g0, -1
fjge_cont.51971:
	jmp	fjge_cont.51969
fjge_else.51968:
	addi	%g6, %g0, 1
fjge_cont.51969:
	jne	%g6, %g0, jeq_else.51972
	fmov	%f4, %f0
	jmp	jeq_cont.51973
jeq_else.51972:
	fdiv	%f4, %f17, %f0
jeq_cont.51973:
	fmul	%f0, %f4, %f4
	setL %g7, l.45192
	fldi	%f14, %g7, 0
	fmul	%f1, %f14, %f0
	setL %g7, l.45194
	fldi	%f15, %g7, 0
	fdiv	%f3, %f1, %f15
	setL %g7, l.45196
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 8
	fldi	%f1, %g1, 8
	fmul	%f2, %f1, %f0
	setL %g7, l.45198
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 12
	fldi	%f1, %g1, 12
	fadd	%f1, %f1, %f3
	fdiv	%f1, %f2, %f1
	setL %g7, l.45200
	fldi	%f11, %g7, 0
	fmul	%f2, %f11, %f0
	setL %g7, l.45202
	fldi	%f13, %g7, 0
	fadd	%f1, %f13, %f1
	fdiv	%f2, %f2, %f1
	setL %g7, l.45204
	fldi	%f12, %g7, 0
	fmul	%f3, %f12, %f0
	setL %g7, l.45206
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 16
	fldi	%f1, %g1, 16
	fadd	%f1, %f1, %f2
	fdiv	%f1, %f3, %f1
	setL %g7, l.45208
	fldi	%f9, %g7, 0
	fmul	%f2, %f9, %f0
	fadd	%f1, %f28, %f1
	fdiv	%f2, %f2, %f1
	setL %g7, l.45211
	fldi	%f10, %g7, 0
	fmul	%f3, %f10, %f0
	setL %g7, l.45213
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 20
	fldi	%f1, %g1, 20
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g7, l.45223
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 24
	setL %g7, l.45215
	fldi	%f8, %g7, 0
	fmul	%f3, %f8, %f0
	setL %g7, l.45217
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 28
	fldi	%f1, %g1, 28
	fadd	%f1, %f1, %f2
	fdiv	%f1, %f3, %f1
	setL %g7, l.45219
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
	jlt	%g0, %g6, jle_else.51974
	jlt	%g6, %g0, jge_else.51976
	fmov	%f0, %f1
	jmp	jge_cont.51977
jge_else.51976:
	fsub	%f0, %f31, %f1
jge_cont.51977:
	jmp	jle_cont.51975
jle_else.51974:
	fsub	%f0, %f22, %f1
jle_cont.51975:
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
	fjlt	%f17, %f0, fjge_else.51978
	fjlt	%f0, %f20, fjge_else.51980
	addi	%g6, %g0, 0
	jmp	fjge_cont.51981
fjge_else.51980:
	addi	%g6, %g0, -1
fjge_cont.51981:
	jmp	fjge_cont.51979
fjge_else.51978:
	addi	%g6, %g0, 1
fjge_cont.51979:
	jne	%g6, %g0, jeq_else.51982
	fmov	%f1, %f0
	jmp	jeq_cont.51983
jeq_else.51982:
	fdiv	%f1, %f17, %f0
jeq_cont.51983:
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
	jlt	%g0, %g6, jle_else.51984
	jlt	%g6, %g0, jge_else.51986
	fmov	%f0, %f1
	jmp	jge_cont.51987
jge_else.51986:
	fsub	%f0, %f31, %f1
jge_cont.51987:
	jmp	jle_cont.51985
jle_else.51984:
	fsub	%f0, %f22, %f1
jle_cont.51985:
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
	jmp	calc_dirvec.2993

!==============================
! args = [%g10, %g9, %g8]
! fargs = [%f0]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f3, %f28, %f26, %f25, %f24, %f23, %f22, %f20, %f2, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
calc_dirvecs.3001:
	jlt	%g10, %g0, jge_else.51988
	fsti	%f0, %g1, 0
	mov	%g3, %g10
	subi	%g1, %g1, 8
	call	min_caml_float_of_int
	addi	%g1, %g1, 8
	fmov	%f1, %f0
	setL %g3, l.42722
	fldi	%f5, %g3, 0
	fmul	%f1, %f1, %f5
	setL %g3, l.42724
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
	call	calc_dirvec.2993
	addi	%g1, %g1, 20
	setL %g3, l.42726
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
	call	calc_dirvec.2993
	addi	%g1, %g1, 24
	subi	%g10, %g10, 1
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.51989
	subi	%g9, %g3, 5
	jmp	jle_cont.51990
jle_else.51989:
	mov	%g9, %g3
jle_cont.51990:
	jlt	%g10, %g0, jge_else.51991
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
	call	calc_dirvec.2993
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
	call	calc_dirvec.2993
	addi	%g1, %g1, 28
	subi	%g10, %g10, 1
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.51992
	subi	%g9, %g3, 5
	jmp	jle_cont.51993
jle_else.51992:
	mov	%g9, %g3
jle_cont.51993:
	jlt	%g10, %g0, jge_else.51994
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
	call	calc_dirvec.2993
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
	call	calc_dirvec.2993
	addi	%g1, %g1, 32
	subi	%g10, %g10, 1
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.51995
	subi	%g9, %g3, 5
	jmp	jle_cont.51996
jle_else.51995:
	mov	%g9, %g3
jle_cont.51996:
	jlt	%g10, %g0, jge_else.51997
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
	call	calc_dirvec.2993
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
	call	calc_dirvec.2993
	addi	%g1, %g1, 36
	subi	%g10, %g10, 1
	addi	%g4, %g9, 1
	addi	%g3, %g0, 5
	jlt	%g4, %g3, jle_else.51998
	subi	%g3, %g4, 5
	jmp	jle_cont.51999
jle_else.51998:
	mov	%g3, %g4
jle_cont.51999:
	fldi	%f0, %g1, 0
	mov	%g9, %g3
	jmp	calc_dirvecs.3001
jge_else.51997:
	return
jge_else.51994:
	return
jge_else.51991:
	return
jge_else.51988:
	return

!==============================
! args = [%g13, %g12, %g8]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f3, %f28, %f26, %f25, %f24, %f23, %f22, %f20, %f2, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
calc_dirvec_rows.3006:
	jlt	%g13, %g0, jge_else.52004
	mov	%g3, %g13
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	setL %g3, l.42722
	fldi	%f4, %g3, 0
	fmul	%f0, %f0, %f4
	setL %g3, l.42724
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
	call	calc_dirvec.2993
	addi	%g1, %g1, 24
	setL %g3, l.42726
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
	call	calc_dirvec.2993
	addi	%g1, %g1, 32
	addi	%g6, %g0, 3
	addi	%g3, %g12, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.52005
	subi	%g9, %g3, 5
	jmp	jle_cont.52006
jle_else.52005:
	mov	%g9, %g3
jle_cont.52006:
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
	call	calc_dirvec.2993
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
	call	calc_dirvec.2993
	addi	%g1, %g1, 44
	addi	%g6, %g0, 2
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.52007
	subi	%g9, %g3, 5
	jmp	jle_cont.52008
jle_else.52007:
	mov	%g9, %g3
jle_cont.52008:
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
	call	calc_dirvec.2993
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
	call	calc_dirvec.2993
	addi	%g1, %g1, 56
	addi	%g6, %g0, 1
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.52009
	subi	%g9, %g3, 5
	jmp	jle_cont.52010
jle_else.52009:
	mov	%g9, %g3
jle_cont.52010:
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
	call	calc_dirvec.2993
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
	call	calc_dirvec.2993
	addi	%g1, %g1, 60
	addi	%g10, %g0, 0
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.52011
	subi	%g9, %g3, 5
	jmp	jle_cont.52012
jle_else.52011:
	mov	%g9, %g3
jle_cont.52012:
	fldi	%f0, %g1, 0
	sti	%g8, %g1, 56
	subi	%g1, %g1, 64
	call	calc_dirvecs.3001
	addi	%g1, %g1, 64
	subi	%g14, %g13, 1
	addi	%g3, %g12, 2
	addi	%g12, %g0, 5
	jlt	%g3, %g12, jle_else.52013
	subi	%g12, %g3, 5
	jmp	jle_cont.52014
jle_else.52013:
	mov	%g12, %g3
jle_cont.52014:
	ldi	%g8, %g1, 56
	addi	%g13, %g8, 4
	jlt	%g14, %g0, jge_else.52015
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
	call	calc_dirvec.2993
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
	call	calc_dirvec.2993
	addi	%g1, %g1, 68
	addi	%g3, %g12, 1
	addi	%g5, %g0, 5
	jlt	%g3, %g5, jle_else.52016
	subi	%g5, %g3, 5
	jmp	jle_cont.52017
jle_else.52016:
	mov	%g5, %g3
jle_cont.52017:
	addi	%g4, %g0, 0
	fldi	%f8, %g1, 28
	fldi	%f0, %g1, 60
	sti	%g5, %g1, 64
	mov	%g3, %g13
	fmov	%f2, %f8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 72
	call	calc_dirvec.2993
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
	call	calc_dirvec.2993
	addi	%g1, %g1, 72
	ldi	%g5, %g1, 64
	addi	%g3, %g5, 1
	addi	%g5, %g0, 5
	jlt	%g3, %g5, jle_else.52018
	subi	%g5, %g3, 5
	jmp	jle_cont.52019
jle_else.52018:
	mov	%g5, %g3
jle_cont.52019:
	addi	%g4, %g0, 0
	fldi	%f6, %g1, 40
	fldi	%f0, %g1, 60
	sti	%g5, %g1, 68
	mov	%g3, %g13
	fmov	%f2, %f6
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 76
	call	calc_dirvec.2993
	addi	%g1, %g1, 76
	addi	%g4, %g0, 0
	fldi	%f2, %g1, 48
	fldi	%f0, %g1, 60
	ldi	%g5, %g1, 68
	mov	%g3, %g8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 76
	call	calc_dirvec.2993
	addi	%g1, %g1, 76
	addi	%g10, %g0, 1
	ldi	%g5, %g1, 68
	addi	%g3, %g5, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.52020
	subi	%g9, %g3, 5
	jmp	jle_cont.52021
jle_else.52020:
	mov	%g9, %g3
jle_cont.52021:
	fldi	%f0, %g1, 60
	mov	%g8, %g13
	subi	%g1, %g1, 76
	call	calc_dirvecs.3001
	addi	%g1, %g1, 76
	subi	%g4, %g14, 1
	addi	%g3, %g12, 2
	addi	%g12, %g0, 5
	jlt	%g3, %g12, jle_else.52022
	subi	%g12, %g3, 5
	jmp	jle_cont.52023
jle_else.52022:
	mov	%g12, %g3
jle_cont.52023:
	addi	%g8, %g13, 4
	mov	%g13, %g4
	jmp	calc_dirvec_rows.3006
jge_else.52015:
	return
jge_else.52004:
	return

!==============================
! args = [%g6, %g7]
! fargs = []
! use_regs = [%g7, %g6, %g5, %g4, %g3, %g27, %g2, %f16, %f15, %f0, %dummy]
! ret type = Unit
!================================
create_dirvec_elements.3012:
	jlt	%g7, %g0, jge_else.52026
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
	jlt	%g7, %g0, jge_else.52027
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
	jlt	%g7, %g0, jge_else.52028
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
	jlt	%g7, %g0, jge_else.52029
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
	jmp	create_dirvec_elements.3012
jge_else.52029:
	return
jge_else.52028:
	return
jge_else.52027:
	return
jge_else.52026:
	return

!==============================
! args = [%g8]
! fargs = []
! use_regs = [%g8, %g7, %g6, %g5, %g4, %g3, %g27, %g2, %f16, %f15, %f0, %dummy]
! ret type = Unit
!================================
create_dirvecs.3015:
	jlt	%g8, %g0, jge_else.52034
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
	call	create_dirvec_elements.3012
	addi	%g1, %g1, 24
	subi	%g8, %g8, 1
	jlt	%g8, %g0, jge_else.52035
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
	call	create_dirvec_elements.3012
	addi	%g1, %g1, 40
	subi	%g8, %g8, 1
	jmp	create_dirvecs.3015
jge_else.52035:
	return
jge_else.52034:
	return

!==============================
! args = [%g11, %g12]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g12, %g11, %g10, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f20, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
init_dirvec_constants.3017:
	jlt	%g12, %g0, jge_else.52038
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.52039
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.52040
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.52041
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.52042
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.52043
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.52044
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.52045
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jmp	init_dirvec_constants.3017
jge_else.52045:
	return
jge_else.52044:
	return
jge_else.52043:
	return
jge_else.52042:
	return
jge_else.52041:
	return
jge_else.52040:
	return
jge_else.52039:
	return
jge_else.52038:
	return

!==============================
! args = [%g13]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g13, %g12, %g11, %g10, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f20, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
init_vecset_constants.3020:
	jlt	%g13, %g0, jge_else.52054
	slli	%g3, %g13, 2
	add	%g3, %g31, %g3
	ldi	%g11, %g3, 716
	ldi	%g3, %g11, -476
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -472
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -468
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -464
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -460
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -456
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -452
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -448
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	addi	%g12, %g0, 111
	call	init_dirvec_constants.3017
	addi	%g1, %g1, 4
	subi	%g13, %g13, 1
	jlt	%g13, %g0, jge_else.52055
	slli	%g3, %g13, 2
	add	%g3, %g31, %g3
	ldi	%g11, %g3, 716
	ldi	%g3, %g11, -476
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -472
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -468
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -464
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -460
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -456
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	ldi	%g3, %g11, -452
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2801
	addi	%g12, %g0, 112
	call	init_dirvec_constants.3017
	addi	%g1, %g1, 4
	subi	%g13, %g13, 1
	jmp	init_vecset_constants.3020
jge_else.52055:
	return
jge_else.52054:
	return
