.init_heap_size	352
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
l.760:	! 10000.000000
	.long	0x461c4000
l.758:	! 0.000000
	.long	0x0
l.746:	! 1000000.000000
	.long	0x49742400
l.744:	! 4.560000
	.long	0x4091eb7d
l.742:	! 1.230000
	.long	0x3f9d70a3
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
	subi	%g1, %g1, 56
	addi	%g28, %g0, 1
	addi	%g29, %g0, -1
	setL %g27, l.760
	fldi	%f16, %g27, 0
	setL %g27, l.758
	fldi	%f17, %g27, 0
	setL %g27, l.746
	fldi	%f18, %g27, 0
	setL %g27, l.744
	fldi	%f19, %g27, 0
	setL %g27, l.742
	fldi	%f20, %g27, 0
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 52
	subi	%g2, %g31, 4
	subi	%g1, %g1, 4
	call	min_caml_create_array
	ldi	%g2, %g31, 52
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 52
	subi	%g2, %g31, 8
	call	min_caml_create_array
	ldi	%g2, %g31, 52
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 52
	subi	%g2, %g31, 12
	call	min_caml_create_array
	ldi	%g2, %g31, 52
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 52
	subi	%g2, %g31, 16
	call	min_caml_create_array
	ldi	%g2, %g31, 52
	addi	%g3, %g0, 1
	addi	%g4, %g0, 1
	sti	%g2, %g31, 52
	subi	%g2, %g31, 20
	call	min_caml_create_array
	ldi	%g2, %g31, 52
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 52
	subi	%g2, %g31, 24
	call	min_caml_create_array
	ldi	%g2, %g31, 52
	addi	%g3, %g0, 3
	sti	%g2, %g31, 52
	subi	%g2, %g31, 36
	fmov	%f0, %f20
	call	min_caml_create_float_array
	ldi	%g2, %g31, 52
	addi	%g3, %g0, 3
	sti	%g2, %g31, 52
	subi	%g2, %g31, 48
	fmov	%f0, %f19
	call	min_caml_create_float_array
	ldi	%g2, %g31, 52
	addi	%g14, %g0, 2
	subi	%g12, %g31, 48
	subi	%g13, %g31, 36
	call	inprod.375
	fmul	%f0, %f18, %f0
	call	min_caml_truncate
	mov	%g8, %g3
	call	print_int.373
	addi	%g1, %g1, 4
	halt

!==============================
! args = [%g8, %g7, %g5, %g6]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %f15]
! ret type = Int
!================================
div_binary_search.368:
	add	%g3, %g5, %g6
	srli	%g4, %g3, 1
	mul	%g9, %g4, %g7
	sub	%g3, %g6, %g5
	jlt	%g28, %g3, jle_else.785
	mov	%g3, %g5
	return
jle_else.785:
	jlt	%g9, %g8, jle_else.786
	jne	%g9, %g8, jeq_else.787
	mov	%g3, %g4
	return
jeq_else.787:
	mov	%g6, %g4
	jmp	div_binary_search.368
jle_else.786:
	mov	%g5, %g4
	jmp	div_binary_search.368

!==============================
! args = [%g8]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g11, %g10, %f15, %dummy]
! ret type = Unit
!================================
print_int.373:
	jlt	%g8, %g0, jge_else.788
	mvhi	%g7, 1525
	mvlo	%g7, 57600
	addi	%g5, %g0, 0
	addi	%g6, %g0, 3
	sti	%g8, %g1, 0
	subi	%g1, %g1, 8
	call	div_binary_search.368
	addi	%g1, %g1, 8
	mvhi	%g4, 1525
	mvlo	%g4, 57600
	mul	%g4, %g3, %g4
	ldi	%g8, %g1, 0
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.789
	addi	%g10, %g0, 0
	jmp	jle_cont.790
jle_else.789:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jle_cont.790:
	mvhi	%g7, 152
	mvlo	%g7, 38528
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 4
	subi	%g1, %g1, 12
	call	div_binary_search.368
	addi	%g1, %g1, 12
	mvhi	%g4, 152
	mvlo	%g4, 38528
	mul	%g4, %g3, %g4
	ldi	%g8, %g1, 4
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.791
	jne	%g10, %g0, jeq_else.793
	addi	%g11, %g0, 0
	jmp	jeq_cont.794
jeq_else.793:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jeq_cont.794:
	jmp	jle_cont.792
jle_else.791:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jle_cont.792:
	mvhi	%g7, 15
	mvlo	%g7, 16960
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 8
	subi	%g1, %g1, 16
	call	div_binary_search.368
	addi	%g1, %g1, 16
	mvhi	%g4, 15
	mvlo	%g4, 16960
	mul	%g4, %g3, %g4
	ldi	%g8, %g1, 8
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.795
	jne	%g11, %g0, jeq_else.797
	addi	%g10, %g0, 0
	jmp	jeq_cont.798
jeq_else.797:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jeq_cont.798:
	jmp	jle_cont.796
jle_else.795:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jle_cont.796:
	mvhi	%g7, 1
	mvlo	%g7, 34464
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 12
	subi	%g1, %g1, 20
	call	div_binary_search.368
	addi	%g1, %g1, 20
	mvhi	%g4, 1
	mvlo	%g4, 34464
	mul	%g4, %g3, %g4
	ldi	%g8, %g1, 12
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.799
	jne	%g10, %g0, jeq_else.801
	addi	%g11, %g0, 0
	jmp	jeq_cont.802
jeq_else.801:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jeq_cont.802:
	jmp	jle_cont.800
jle_else.799:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jle_cont.800:
	addi	%g7, %g0, 10000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 16
	subi	%g1, %g1, 24
	call	div_binary_search.368
	addi	%g1, %g1, 24
	addi	%g4, %g0, 10000
	mul	%g4, %g3, %g4
	ldi	%g8, %g1, 16
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.803
	jne	%g11, %g0, jeq_else.805
	addi	%g10, %g0, 0
	jmp	jeq_cont.806
jeq_else.805:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jeq_cont.806:
	jmp	jle_cont.804
jle_else.803:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jle_cont.804:
	addi	%g7, %g0, 1000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 20
	subi	%g1, %g1, 28
	call	div_binary_search.368
	addi	%g1, %g1, 28
	muli	%g4, %g3, 1000
	ldi	%g8, %g1, 20
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.807
	jne	%g10, %g0, jeq_else.809
	addi	%g11, %g0, 0
	jmp	jeq_cont.810
jeq_else.809:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jeq_cont.810:
	jmp	jle_cont.808
jle_else.807:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jle_cont.808:
	addi	%g7, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 24
	subi	%g1, %g1, 32
	call	div_binary_search.368
	addi	%g1, %g1, 32
	muli	%g4, %g3, 100
	ldi	%g8, %g1, 24
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.811
	jne	%g11, %g0, jeq_else.813
	addi	%g10, %g0, 0
	jmp	jeq_cont.814
jeq_else.813:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jeq_cont.814:
	jmp	jle_cont.812
jle_else.811:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jle_cont.812:
	addi	%g7, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 28
	subi	%g1, %g1, 36
	call	div_binary_search.368
	addi	%g1, %g1, 36
	muli	%g4, %g3, 10
	ldi	%g8, %g1, 28
	sub	%g4, %g8, %g4
	jlt	%g0, %g3, jle_else.815
	jne	%g10, %g0, jeq_else.817
	addi	%g5, %g0, 0
	jmp	jeq_cont.818
jeq_else.817:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g5, %g0, 1
jeq_cont.818:
	jmp	jle_cont.816
jle_else.815:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g5, %g0, 1
jle_cont.816:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g4
	output	%g3
	return
jge_else.788:
	addi	%g3, %g0, 45
	output	%g3
	sub	%g8, %g0, %g8
	jmp	print_int.373

!==============================
! args = [%g13, %g12, %g14]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g14, %g13, %g12, %g11, %g10, %f4, %f3, %f2, %f16, %f15, %f1, %f0, %dummy]
! ret type = Float
!================================
inprod.375:
	jlt	%g14, %g0, jge_else.819
	mov	%g8, %g14
	subi	%g1, %g1, 4
	call	print_int.373
	addi	%g1, %g1, 4
	sti	%g3, %g1, 4
	addi	%g3, %g0, 10
	output	%g3
	ldi	%g3, %g1, 4
	slli	%g3, %g14, 2
	fld	%f0, %g13, %g3
	fmul	%f0, %f16, %f0
	subi	%g1, %g1, 4
	call	min_caml_truncate
	mov	%g8, %g3
	call	print_int.373
	addi	%g1, %g1, 4
	sti	%g3, %g1, 4
	addi	%g3, %g0, 10
	output	%g3
	ldi	%g3, %g1, 4
	slli	%g3, %g14, 2
	fld	%f0, %g12, %g3
	fmul	%f0, %f16, %f0
	subi	%g1, %g1, 4
	call	min_caml_truncate
	mov	%g8, %g3
	call	print_int.373
	addi	%g1, %g1, 4
	sti	%g3, %g1, 4
	addi	%g3, %g0, 10
	output	%g3
	ldi	%g3, %g1, 4
	slli	%g3, %g14, 2
	fld	%f0, %g13, %g3
	fmul	%f1, %f16, %f0
	slli	%g3, %g14, 2
	fld	%f0, %g12, %g3
	fmul	%f0, %f1, %f0
	subi	%g1, %g1, 4
	call	min_caml_truncate
	mov	%g8, %g3
	call	print_int.373
	addi	%g1, %g1, 4
	sti	%g3, %g1, 4
	addi	%g3, %g0, 10
	output	%g3
	ldi	%g3, %g1, 4
	slli	%g3, %g14, 2
	fld	%f1, %g13, %g3
	slli	%g3, %g14, 2
	fld	%f0, %g12, %g3
	fmul	%f1, %f1, %f0
	subi	%g14, %g14, 1
	fsti	%f1, %g1, 0
	subi	%g1, %g1, 8
	call	inprod.375
	addi	%g1, %g1, 8
	fldi	%f1, %g1, 0
	fadd	%f0, %f1, %f0
	return
jge_else.819:
	setL %g3, l.758
	fldi	%f0, %g3, 0
	return
