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
l.735:	! 1.570796
	.long	0x3fc90fda
l.731:	! 0.500000
	.long	0x3f000000
l.726:	! 9.000000
	.long	0x41100000
l.724:	! 1.000000
	.long	0x3f800000
l.722:	! 2.000000
	.long	0x40000000
l.720:	! 2.500000
	.long	0x40200000
l.718:	! 0.000000
	.long	0x0
l.698:	! 48.300300
	.long	0x42413381
l.696:	! 4.500000
	.long	0x40900000
l.694:	! -12.300000
	.long	0xc144ccc4
l.692:	! 1.570796
	.long	0x3fc90fda
l.690:	! 6.283185
	.long	0x40c90fda
l.688:	! 3.141593
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
	subi	%g1, %g1, 32
	addi	%g28, %g0, 1
	addi	%g29, %g0, -1
	setL %g27, l.718
	fldi	%f16, %g27, 0
	setL %g27, l.724
	fldi	%f17, %g27, 0
	setL %g27, l.722
	fldi	%f18, %g27, 0
	setL %g27, l.735
	fldi	%f19, %g27, 0
	setL %g27, l.731
	fldi	%f20, %g27, 0
	setL %g27, l.726
	fldi	%f21, %g27, 0
	setL %g27, l.720
	fldi	%f22, %g27, 0
	setL %g27, l.698
	fldi	%f23, %g27, 0
	setL %g27, l.696
	fldi	%f24, %g27, 0
	setL %g27, l.694
	fldi	%f25, %g27, 0
	setL %g27, l.692
	fldi	%f26, %g27, 0
	setL %g27, l.690
	fldi	%f27, %g27, 0
	setL %g27, l.688
	fldi	%f28, %g27, 0
	fmov	%f0, %f28
	fmov	%f1, %f27
	fmov	%f2, %f26
	mov	%g3, %g2
	addi	%g2, %g2, 8
	setL %g4, sin_sub.318
	sti	%g4, %g3, 0
	fsti	%f1, %g3, -4
	mov	%g4, %g2
	addi	%g2, %g2, 20
	setL %g5, sin.320
	sti	%g5, %g4, 0
	sti	%g3, %g4, -16
	fsti	%f2, %g4, -12
	fsti	%f1, %g4, -8
	fsti	%f0, %g4, -4
	mov	%g3, %g2
	addi	%g2, %g2, 8
	setL %g5, cos.322
	sti	%g5, %g3, 0
	sti	%g4, %g3, -4
	addi	%g5, %g0, 1
	addi	%g6, %g0, 0
	sti	%g2, %g31, 28
	subi	%g2, %g31, 4
	sti	%g4, %g1, 0
	sti	%g3, %g1, 4
	mov	%g4, %g6
	mov	%g3, %g5
	subi	%g1, %g1, 12
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
	fmov	%f0, %f25
	call	abs_float.299
	addi	%g1, %g1, 12
	fsqrt	%f0, %f0
	ldi	%g30, %g1, 4
	ldi	%g27, %g30, 0
	subi	%g1, %g1, 12
	callR	%g27
	addi	%g1, %g1, 12
	ldi	%g30, %g1, 0
	ldi	%g27, %g30, 0
	subi	%g1, %g1, 12
	callR	%g27
	addi	%g1, %g1, 12
	fmov	%f1, %f24
	fadd	%f0, %f0, %f1
	fmov	%f1, %f23
	fsub	%f0, %f0, %f1
	mvhi	%g3, 15
	mvlo	%g3, 16960
	fsti	%f0, %g1, 8
	subi	%g1, %g1, 16
	call	min_caml_float_of_int
	addi	%g1, %g1, 16
	fldi	%f1, %g1, 8
	fmul	%f0, %f1, %f0
	subi	%g1, %g1, 16
	call	min_caml_int_of_float
	call	print_int.349
	addi	%g1, %g1, 16
	halt

!==============================
! args = []
! fargs = [%f0]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0]
! ret type = Float
!================================
fabs.297:
	fmov	%f1, %f16
	fjlt	%f0, %f1, fjge_else.804
	return
fjge_else.804:
	fneg	%f0, %f0
	return

!==============================
! args = []
! fargs = [%f0]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0]
! ret type = Float
!================================
abs_float.299:
	jmp	fabs.297

!==============================
! args = []
! fargs = [%f0]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0]
! ret type = Float
!================================
fneg.301:
	fneg	%f0, %f0
	return

!==============================
! args = []
! fargs = [%f0, %f1, %f2]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0]
! ret type = Float
!================================
tan_sub.636:
	fmov	%f3, %f22
	fjlt	%f0, %f3, fjge_else.805
	fmov	%f3, %f18
	fsub	%f3, %f0, %f3
	fsub	%f0, %f0, %f2
	fdiv	%f2, %f1, %f0
	fmov	%f0, %f3
	jmp	tan_sub.636
fjge_else.805:
	fmov	%f0, %f2
	return

!==============================
! args = []
! fargs = [%f0]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0]
! ret type = Float
!================================
tan.316:
	fmov	%f1, %f17
	fmov	%f2, %f21
	fmul	%f3, %f0, %f0
	fmov	%f4, %f16
	fsti	%f0, %g1, 0
	fsti	%f1, %g1, 4
	fmov	%f1, %f3
	fmov	%f0, %f2
	fmov	%f2, %f4
	subi	%g1, %g1, 12
	call	tan_sub.636
	addi	%g1, %g1, 12
	fldi	%f1, %g1, 4
	fsub	%f0, %f1, %f0
	fldi	%f1, %g1, 0
	fdiv	%f0, %f1, %f0
	return

!==============================
! args = []
! fargs = [%f0]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0]
! ret type = Float
!================================
sin_sub.318:
	fldi	%f1, %g30, -4
	fjlt	%f1, %f0, fjge_else.806
	fmov	%f2, %f16
	fjlt	%f0, %f2, fjge_else.807
	return
fjge_else.807:
	fadd	%f0, %f0, %f1
	ldi	%g27, %g30, 0
	b	%g27
fjge_else.806:
	fsub	%f0, %f0, %f1
	ldi	%g27, %g30, 0
	b	%g27

!==============================
! args = []
! fargs = [%f0]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0]
! ret type = Float
!================================
sin.320:
	ldi	%g3, %g30, -16
	fldi	%f1, %g30, -12
	fldi	%f2, %g30, -8
	fldi	%f3, %g30, -4
	fmov	%f4, %f16
	fsti	%f1, %g1, 0
	fsti	%f2, %g1, 4
	fsti	%f4, %g1, 8
	fsti	%f0, %g1, 12
	fsti	%f3, %g1, 16
	sti	%g3, %g1, 20
	call	fabs.297
	ldi	%g30, %g1, 20
	ldi	%g27, %g30, 0
	subi	%g1, %g1, 28
	callR	%g27
	addi	%g1, %g1, 28
	fldi	%f1, %g1, 16
	fjlt	%f1, %f0, fjge_else.808
	fldi	%f2, %g1, 8
	fldi	%f3, %g1, 12
	fjlt	%f2, %f3, fjge_else.810
	addi	%g3, %g0, 0
	jmp	fjge_cont.811
fjge_else.810:
	addi	%g3, %g0, 1
fjge_cont.811:
	jmp	fjge_cont.809
fjge_else.808:
	fldi	%f2, %g1, 8
	fldi	%f3, %g1, 12
	fjlt	%f2, %f3, fjge_else.812
	addi	%g3, %g0, 1
	jmp	fjge_cont.813
fjge_else.812:
	addi	%g3, %g0, 0
fjge_cont.813:
fjge_cont.809:
	fjlt	%f1, %f0, fjge_else.814
	jmp	fjge_cont.815
fjge_else.814:
	fldi	%f2, %g1, 4
	fsub	%f0, %f2, %f0
fjge_cont.815:
	fldi	%f2, %g1, 0
	fjlt	%f2, %f0, fjge_else.816
	jmp	fjge_cont.817
fjge_else.816:
	fsub	%f0, %f1, %f0
fjge_cont.817:
	fmov	%f1, %f20
	fmul	%f0, %f0, %f1
	sti	%g3, %g1, 24
	subi	%g1, %g1, 32
	call	tan.316
	addi	%g1, %g1, 32
	fmov	%f1, %f18
	fmul	%f1, %f1, %f0
	fmov	%f2, %f17
	fmul	%f0, %f0, %f0
	fadd	%f0, %f2, %f0
	fdiv	%f0, %f1, %f0
	ldi	%g3, %g1, 24
	jne	%g3, %g0, jeq_else.818
	jmp	fneg.301
jeq_else.818:
	return

!==============================
! args = []
! fargs = [%f0]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0]
! ret type = Float
!================================
cos.322:
	ldi	%g30, %g30, -4
	fmov	%f1, %f19
	fsub	%f0, %f1, %f0
	ldi	%g27, %g30, 0
	b	%g27

!==============================
! args = [%g3, %g4, %g5, %g6]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0]
! ret type = Int
!================================
div_binary_search.344:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.819
	mov	%g3, %g5
	return
jle_else.819:
	jlt	%g8, %g3, jle_else.820
	jne	%g8, %g3, jeq_else.821
	mov	%g3, %g7
	return
jeq_else.821:
	mov	%g6, %g7
	jmp	div_binary_search.344
jle_else.820:
	mov	%g5, %g7
	jmp	div_binary_search.344

!==============================
! args = [%g3]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0]
! ret type = Unit
!================================
print_int.349:
	jlt	%g3, %g0, jge_else.822
	mvhi	%g4, 1525
	mvlo	%g4, 57600
	addi	%g5, %g0, 0
	addi	%g6, %g0, 3
	sti	%g3, %g1, 0
	subi	%g1, %g1, 8
	call	div_binary_search.344
	addi	%g1, %g1, 8
	mvhi	%g4, 1525
	mvlo	%g4, 57600
	mul	%g4, %g3, %g4
	ldi	%g5, %g1, 0
	sub	%g4, %g5, %g4
	sti	%g4, %g1, 4
	jlt	%g0, %g3, jle_else.823
	addi	%g3, %g0, 0
	jmp	jle_cont.824
jle_else.823:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.824:
	mvhi	%g4, 152
	mvlo	%g4, 38528
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ldi	%g7, %g1, 4
	sti	%g3, %g1, 8
	mov	%g3, %g7
	subi	%g1, %g1, 16
	call	div_binary_search.344
	addi	%g1, %g1, 16
	mvhi	%g4, 152
	mvlo	%g4, 38528
	mul	%g4, %g3, %g4
	ldi	%g5, %g1, 4
	sub	%g4, %g5, %g4
	sti	%g4, %g1, 12
	jlt	%g0, %g3, jle_else.825
	ldi	%g5, %g1, 8
	jne	%g5, %g0, jeq_else.827
	addi	%g3, %g0, 0
	jmp	jeq_cont.828
jeq_else.827:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.828:
	jmp	jle_cont.826
jle_else.825:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.826:
	mvhi	%g4, 15
	mvlo	%g4, 16960
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ldi	%g7, %g1, 12
	sti	%g3, %g1, 16
	mov	%g3, %g7
	subi	%g1, %g1, 24
	call	div_binary_search.344
	addi	%g1, %g1, 24
	mvhi	%g4, 15
	mvlo	%g4, 16960
	mul	%g4, %g3, %g4
	ldi	%g5, %g1, 12
	sub	%g4, %g5, %g4
	sti	%g4, %g1, 20
	jlt	%g0, %g3, jle_else.829
	ldi	%g5, %g1, 16
	jne	%g5, %g0, jeq_else.831
	addi	%g3, %g0, 0
	jmp	jeq_cont.832
jeq_else.831:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.832:
	jmp	jle_cont.830
jle_else.829:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.830:
	mvhi	%g4, 1
	mvlo	%g4, 34464
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ldi	%g7, %g1, 20
	sti	%g3, %g1, 24
	mov	%g3, %g7
	subi	%g1, %g1, 32
	call	div_binary_search.344
	addi	%g1, %g1, 32
	mvhi	%g4, 1
	mvlo	%g4, 34464
	mul	%g4, %g3, %g4
	ldi	%g5, %g1, 20
	sub	%g4, %g5, %g4
	sti	%g4, %g1, 28
	jlt	%g0, %g3, jle_else.833
	ldi	%g5, %g1, 24
	jne	%g5, %g0, jeq_else.835
	addi	%g3, %g0, 0
	jmp	jeq_cont.836
jeq_else.835:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.836:
	jmp	jle_cont.834
jle_else.833:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.834:
	addi	%g4, %g0, 10000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ldi	%g7, %g1, 28
	sti	%g3, %g1, 32
	mov	%g3, %g7
	subi	%g1, %g1, 40
	call	div_binary_search.344
	addi	%g1, %g1, 40
	addi	%g4, %g0, 10000
	mul	%g4, %g3, %g4
	ldi	%g5, %g1, 28
	sub	%g4, %g5, %g4
	sti	%g4, %g1, 36
	jlt	%g0, %g3, jle_else.837
	ldi	%g5, %g1, 32
	jne	%g5, %g0, jeq_else.839
	addi	%g3, %g0, 0
	jmp	jeq_cont.840
jeq_else.839:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.840:
	jmp	jle_cont.838
jle_else.837:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.838:
	addi	%g4, %g0, 1000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ldi	%g7, %g1, 36
	sti	%g3, %g1, 40
	mov	%g3, %g7
	subi	%g1, %g1, 48
	call	div_binary_search.344
	addi	%g1, %g1, 48
	muli	%g4, %g3, 1000
	ldi	%g5, %g1, 36
	sub	%g4, %g5, %g4
	sti	%g4, %g1, 44
	jlt	%g0, %g3, jle_else.841
	ldi	%g5, %g1, 40
	jne	%g5, %g0, jeq_else.843
	addi	%g3, %g0, 0
	jmp	jeq_cont.844
jeq_else.843:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.844:
	jmp	jle_cont.842
jle_else.841:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.842:
	addi	%g4, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ldi	%g7, %g1, 44
	sti	%g3, %g1, 48
	mov	%g3, %g7
	subi	%g1, %g1, 56
	call	div_binary_search.344
	addi	%g1, %g1, 56
	muli	%g4, %g3, 100
	ldi	%g5, %g1, 44
	sub	%g4, %g5, %g4
	sti	%g4, %g1, 52
	jlt	%g0, %g3, jle_else.845
	ldi	%g5, %g1, 48
	jne	%g5, %g0, jeq_else.847
	addi	%g3, %g0, 0
	jmp	jeq_cont.848
jeq_else.847:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.848:
	jmp	jle_cont.846
jle_else.845:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.846:
	addi	%g4, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ldi	%g7, %g1, 52
	sti	%g3, %g1, 56
	mov	%g3, %g7
	subi	%g1, %g1, 64
	call	div_binary_search.344
	addi	%g1, %g1, 64
	muli	%g4, %g3, 10
	ldi	%g5, %g1, 52
	sub	%g4, %g5, %g4
	sti	%g4, %g1, 60
	jlt	%g0, %g3, jle_else.849
	ldi	%g5, %g1, 56
	jne	%g5, %g0, jeq_else.851
	addi	%g3, %g0, 0
	jmp	jeq_cont.852
jeq_else.851:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.852:
	jmp	jle_cont.850
jle_else.849:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.850:
	addi	%g3, %g0, 48
	ldi	%g4, %g1, 60
	add	%g3, %g3, %g4
	output	%g3
	return
jge_else.822:
	addi	%g4, %g0, 45
	sti	%g3, %g1, 0
	output	%g4
	ldi	%g3, %g1, 0
	sub	%g3, %g0, %g3
	jmp	print_int.349
