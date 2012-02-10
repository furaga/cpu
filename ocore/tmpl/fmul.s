.init_heap_size	224
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
l.667:	! 16826400.000000
	.long	0x4b806010
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
	setL %g27, l.667
	fldi	%f16, %g27, 0
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
	fmov	%f0, %f16
	call	min_caml_truncate
	mov	%g8, %g3
	call	print_int.337
	addi	%g1, %g1, 4
	halt

!==============================
! args = [%g8, %g7, %g5, %g6]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %f15]
! ret type = Int
!================================
div_binary_search.332:
	add	%g3, %g5, %g6
	srli	%g4, %g3, 1
	mul	%g9, %g4, %g7
	sub	%g3, %g6, %g5
	jlt	%g28, %g3, jle_else.684
	mov	%g3, %g5
	return
jle_else.684:
	jlt	%g9, %g8, jle_else.685
	jne	%g9, %g8, jeq_else.686
	mov	%g3, %g4
	return
jeq_else.686:
	mov	%g6, %g4
	jmp	div_binary_search.332
jle_else.685:
	mov	%g5, %g4
	jmp	div_binary_search.332

!==============================
! args = [%g8]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g11, %g10, %f15, %dummy]
! ret type = Unit
!================================
print_int.337:
	jlt	%g8, %g0, jge_else.687
	mvhi	%g7, 1525
	mvlo	%g7, 57600
	addi	%g5, %g0, 0
	addi	%g6, %g0, 3
	sti	%g8, %g1, 0
	subi	%g1, %g1, 8
	call	div_binary_search.332
	addi	%g1, %g1, 8
	mvhi	%g4, 1525
	mvlo	%g4, 57600
	mul	%g4, %g3, %g4
	ldi	%g8, %g1, 0
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.688
	addi	%g10, %g0, 0
	jmp	jle_cont.689
jle_else.688:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jle_cont.689:
	mvhi	%g7, 152
	mvlo	%g7, 38528
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 4
	subi	%g1, %g1, 12
	call	div_binary_search.332
	addi	%g1, %g1, 12
	mvhi	%g4, 152
	mvlo	%g4, 38528
	mul	%g4, %g3, %g4
	ldi	%g8, %g1, 4
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.690
	jne	%g10, %g0, jeq_else.692
	addi	%g11, %g0, 0
	jmp	jeq_cont.693
jeq_else.692:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jeq_cont.693:
	jmp	jle_cont.691
jle_else.690:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jle_cont.691:
	mvhi	%g7, 15
	mvlo	%g7, 16960
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 8
	subi	%g1, %g1, 16
	call	div_binary_search.332
	addi	%g1, %g1, 16
	mvhi	%g4, 15
	mvlo	%g4, 16960
	mul	%g4, %g3, %g4
	ldi	%g8, %g1, 8
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.694
	jne	%g11, %g0, jeq_else.696
	addi	%g10, %g0, 0
	jmp	jeq_cont.697
jeq_else.696:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jeq_cont.697:
	jmp	jle_cont.695
jle_else.694:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jle_cont.695:
	mvhi	%g7, 1
	mvlo	%g7, 34464
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 12
	subi	%g1, %g1, 20
	call	div_binary_search.332
	addi	%g1, %g1, 20
	mvhi	%g4, 1
	mvlo	%g4, 34464
	mul	%g4, %g3, %g4
	ldi	%g8, %g1, 12
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.698
	jne	%g10, %g0, jeq_else.700
	addi	%g11, %g0, 0
	jmp	jeq_cont.701
jeq_else.700:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jeq_cont.701:
	jmp	jle_cont.699
jle_else.698:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jle_cont.699:
	addi	%g7, %g0, 10000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 16
	subi	%g1, %g1, 24
	call	div_binary_search.332
	addi	%g1, %g1, 24
	addi	%g4, %g0, 10000
	mul	%g4, %g3, %g4
	ldi	%g8, %g1, 16
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.702
	jne	%g11, %g0, jeq_else.704
	addi	%g10, %g0, 0
	jmp	jeq_cont.705
jeq_else.704:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jeq_cont.705:
	jmp	jle_cont.703
jle_else.702:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jle_cont.703:
	addi	%g7, %g0, 1000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 20
	subi	%g1, %g1, 28
	call	div_binary_search.332
	addi	%g1, %g1, 28
	muli	%g4, %g3, 1000
	ldi	%g8, %g1, 20
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.706
	jne	%g10, %g0, jeq_else.708
	addi	%g11, %g0, 0
	jmp	jeq_cont.709
jeq_else.708:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jeq_cont.709:
	jmp	jle_cont.707
jle_else.706:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jle_cont.707:
	addi	%g7, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 24
	subi	%g1, %g1, 32
	call	div_binary_search.332
	addi	%g1, %g1, 32
	muli	%g4, %g3, 100
	ldi	%g8, %g1, 24
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.710
	jne	%g11, %g0, jeq_else.712
	addi	%g10, %g0, 0
	jmp	jeq_cont.713
jeq_else.712:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jeq_cont.713:
	jmp	jle_cont.711
jle_else.710:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jle_cont.711:
	addi	%g7, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 28
	subi	%g1, %g1, 36
	call	div_binary_search.332
	addi	%g1, %g1, 36
	muli	%g4, %g3, 10
	ldi	%g8, %g1, 28
	sub	%g4, %g8, %g4
	jlt	%g0, %g3, jle_else.714
	jne	%g10, %g0, jeq_else.716
	addi	%g5, %g0, 0
	jmp	jeq_cont.717
jeq_else.716:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g5, %g0, 1
jeq_cont.717:
	jmp	jle_cont.715
jle_else.714:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g5, %g0, 1
jle_cont.715:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g4
	output	%g3
	return
jge_else.687:
	addi	%g3, %g0, 45
	output	%g3
	sub	%g8, %g0, %g8
	jmp	print_int.337
