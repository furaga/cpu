.init_heap_size	576
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
l.466:	! 1.570796
	.long	0x3fc90fda
l.464:	! 0.500000
	.long	0x3f000000
l.460:	! 3.141593
	.long	0x40490fda
l.457:	! 6.283185
	.long	0x40c90fda
l.454:	! 9.000000
	.long	0x41100000
l.452:	! 1.000000
	.long	0x3f800000
l.450:	! 2.000000
	.long	0x40000000
l.448:	! 2.500000
	.long	0x40200000
l.446:	! 0.000000
	.long	0x0
l.438:	! 48.300300
	.long	0x42413381
l.436:	! 4.500000
	.long	0x40900000
l.434:	! -12.300000
	.long	0xc144ccc4
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
	subi	%g1, %g1, 32
	addi	%g28, %g0, 1
	addi	%g29, %g0, -1
	setL %g27, l.446
	fldi	%f16, %g27, 0
	setL %g27, l.466
	fldi	%f17, %g27, 0
	setL %g27, l.457
	fldi	%f18, %g27, 0
	setL %g27, l.452
	fldi	%f19, %g27, 0
	setL %g27, l.450
	fldi	%f20, %g27, 0
	setL %g27, l.464
	fldi	%f21, %g27, 0
	setL %g27, l.460
	fldi	%f22, %g27, 0
	setL %g27, l.454
	fldi	%f23, %g27, 0
	setL %g27, l.448
	fldi	%f24, %g27, 0
	setL %g27, l.438
	fldi	%f25, %g27, 0
	setL %g27, l.436
	fldi	%f26, %g27, 0
	setL %g27, l.434
	fldi	%f27, %g27, 0
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 28
	subi	%g2, %g31, 4
	subi	%g1, %g1, 4
	call	min_caml_create_array
	ldi	%g2, %g31, 28
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 28
	subi	%g2, %g31, 8
	call	min_caml_create_array
	ldi	%g2, %g31, 28
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 28
	subi	%g2, %g31, 12
	call	min_caml_create_array
	ldi	%g2, %g31, 28
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 28
	subi	%g2, %g31, 16
	call	min_caml_create_array
	ldi	%g2, %g31, 28
	addi	%g3, %g0, 1
	addi	%g4, %g0, 1
	sti	%g2, %g31, 28
	subi	%g2, %g31, 20
	call	min_caml_create_array
	ldi	%g2, %g31, 28
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 28
	subi	%g2, %g31, 24
	call	min_caml_create_array
	ldi	%g2, %g31, 28
	fmov	%f1, %f27
	call	abs_float.201
	fsqrt	%f0, %f0
	call	cos.224
	fmov	%f2, %f0
	call	sin.222
	fadd	%f0, %f0, %f26
	fsub	%f3, %f0, %f25
	mvhi	%g3, 15
	mvlo	%g3, 16960
	call	min_caml_float_of_int
	fmul	%f0, %f3, %f0
	call	min_caml_int_of_float
	addi	%g1, %g1, 4
	outputw	%g3
	halt

!==============================
! args = []
! fargs = [%f1]
! use_regs = [%g27, %f16, %f15, %f1, %f0]
! ret type = Float
!================================
fabs.199:
	fjlt	%f1, %f16, fjge_else.476
	fmov	%f0, %f1
	return
fjge_else.476:
	fneg	%f0, %f1
	return

!==============================
! args = []
! fargs = [%f1]
! use_regs = [%g27, %f16, %f15, %f1, %f0]
! ret type = Float
!================================
abs_float.201:
	jmp	fabs.199

!==============================
! args = []
! fargs = [%f0]
! use_regs = [%g27, %f15, %f0]
! ret type = Float
!================================
fneg.203:
	fneg	%f0, %f0
	return

!==============================
! args = []
! fargs = [%f2, %f3, %f1]
! use_regs = [%g27, %f3, %f24, %f20, %f2, %f15, %f1, %f0]
! ret type = Float
!================================
tan_sub.385:
	fjlt	%f2, %f24, fjge_else.477
	fsub	%f0, %f2, %f20
	fsub	%f1, %f2, %f1
	fdiv	%f1, %f3, %f1
	fmov	%f2, %f0
	jmp	tan_sub.385
fjge_else.477:
	fmov	%f0, %f1
	return

!==============================
! args = []
! fargs = [%f0]
! use_regs = [%g27, %f3, %f24, %f23, %f20, %f2, %f19, %f16, %f15, %f1, %f0]
! ret type = Float
!================================
tan.218:
	fmul	%f3, %f0, %f0
	fsti	%f0, %g1, 0
	fmov	%f1, %f16
	fmov	%f2, %f23
	subi	%g1, %g1, 8
	call	tan_sub.385
	addi	%g1, %g1, 8
	fmov	%f1, %f0
	fsub	%f1, %f19, %f1
	fldi	%f0, %g1, 0
	fdiv	%f0, %f0, %f1
	return

!==============================
! args = []
! fargs = [%f1]
! use_regs = [%g27, %f18, %f16, %f15, %f1, %f0]
! ret type = Float
!================================
sin_sub.220:
	fjlt	%f18, %f1, fjge_else.478
	fjlt	%f1, %f16, fjge_else.479
	fmov	%f0, %f1
	return
fjge_else.479:
	fadd	%f1, %f1, %f18
	jmp	sin_sub.220
fjge_else.478:
	fsub	%f1, %f1, %f18
	jmp	sin_sub.220

!==============================
! args = []
! fargs = [%f2]
! use_regs = [%g3, %g27, %f3, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f1, %f0]
! ret type = Float
!================================
sin.222:
	fmov	%f1, %f2
	call	fabs.199
	fmov	%f1, %f0
	subi	%g1, %g1, 4
	call	sin_sub.220
	addi	%g1, %g1, 4
	fjlt	%f22, %f0, fjge_else.480
	fjlt	%f16, %f2, fjge_else.482
	addi	%g3, %g0, 0
	jmp	fjge_cont.483
fjge_else.482:
	addi	%g3, %g0, 1
fjge_cont.483:
	jmp	fjge_cont.481
fjge_else.480:
	fjlt	%f16, %f2, fjge_else.484
	addi	%g3, %g0, 1
	jmp	fjge_cont.485
fjge_else.484:
	addi	%g3, %g0, 0
fjge_cont.485:
fjge_cont.481:
	fjlt	%f22, %f0, fjge_else.486
	fmov	%f1, %f0
	jmp	fjge_cont.487
fjge_else.486:
	fsub	%f1, %f18, %f0
fjge_cont.487:
	fjlt	%f17, %f1, fjge_else.488
	fmov	%f0, %f1
	jmp	fjge_cont.489
fjge_else.488:
	fsub	%f0, %f22, %f1
fjge_cont.489:
	fmul	%f0, %f0, %f21
	subi	%g1, %g1, 4
	call	tan.218
	addi	%g1, %g1, 4
	fmul	%f1, %f20, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f19, %f0
	fdiv	%f1, %f1, %f0
	jne	%g3, %g0, jeq_else.490
	fmov	%f0, %f1
	jmp	fneg.203
jeq_else.490:
	fmov	%f0, %f1
	return

!==============================
! args = []
! fargs = [%f0]
! use_regs = [%g3, %g27, %f3, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f1, %f0]
! ret type = Float
!================================
cos.224:
	fsub	%f2, %f17, %f0
	jmp	sin.222
