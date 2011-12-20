.init_heap_size	192
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
	addi	%g3, %g0, 3
	call	make_adder.338
	mov	%g30, %g3
	addi	%g3, %g0, 7
	ldi	%g27, %g30, 0
	callR	%g27
	call	print_int.336
	addi	%g1, %g1, 4
	halt

!==============================
! args = [%g3, %g4, %g5, %g6]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0]
! ret type = Int
!================================
div_binary_search.331:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.730
	mov	%g3, %g5
	return
jle_else.730:
	jlt	%g8, %g3, jle_else.731
	jne	%g8, %g3, jeq_else.732
	mov	%g3, %g7
	return
jeq_else.732:
	mov	%g6, %g7
	jmp	div_binary_search.331
jle_else.731:
	mov	%g5, %g7
	jmp	div_binary_search.331

!==============================
! args = [%g3]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0]
! ret type = Unit
!================================
print_int.336:
	jlt	%g3, %g0, jge_else.733
	mvhi	%g4, 1525
	mvlo	%g4, 57600
	addi	%g5, %g0, 0
	addi	%g6, %g0, 3
	sti	%g3, %g1, 0
	subi	%g1, %g1, 8
	call	div_binary_search.331
	addi	%g1, %g1, 8
	mvhi	%g4, 1525
	mvlo	%g4, 57600
	mul	%g4, %g3, %g4
	ldi	%g5, %g1, 0
	sub	%g4, %g5, %g4
	sti	%g4, %g1, 4
	jlt	%g0, %g3, jle_else.734
	addi	%g3, %g0, 0
	jmp	jle_cont.735
jle_else.734:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.735:
	mvhi	%g4, 152
	mvlo	%g4, 38528
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ldi	%g7, %g1, 4
	sti	%g3, %g1, 8
	mov	%g3, %g7
	subi	%g1, %g1, 16
	call	div_binary_search.331
	addi	%g1, %g1, 16
	mvhi	%g4, 152
	mvlo	%g4, 38528
	mul	%g4, %g3, %g4
	ldi	%g5, %g1, 4
	sub	%g4, %g5, %g4
	sti	%g4, %g1, 12
	jlt	%g0, %g3, jle_else.736
	ldi	%g5, %g1, 8
	jne	%g5, %g0, jeq_else.738
	addi	%g3, %g0, 0
	jmp	jeq_cont.739
jeq_else.738:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.739:
	jmp	jle_cont.737
jle_else.736:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.737:
	mvhi	%g4, 15
	mvlo	%g4, 16960
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ldi	%g7, %g1, 12
	sti	%g3, %g1, 16
	mov	%g3, %g7
	subi	%g1, %g1, 24
	call	div_binary_search.331
	addi	%g1, %g1, 24
	mvhi	%g4, 15
	mvlo	%g4, 16960
	mul	%g4, %g3, %g4
	ldi	%g5, %g1, 12
	sub	%g4, %g5, %g4
	sti	%g4, %g1, 20
	jlt	%g0, %g3, jle_else.740
	ldi	%g5, %g1, 16
	jne	%g5, %g0, jeq_else.742
	addi	%g3, %g0, 0
	jmp	jeq_cont.743
jeq_else.742:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.743:
	jmp	jle_cont.741
jle_else.740:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.741:
	mvhi	%g4, 1
	mvlo	%g4, 34464
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ldi	%g7, %g1, 20
	sti	%g3, %g1, 24
	mov	%g3, %g7
	subi	%g1, %g1, 32
	call	div_binary_search.331
	addi	%g1, %g1, 32
	mvhi	%g4, 1
	mvlo	%g4, 34464
	mul	%g4, %g3, %g4
	ldi	%g5, %g1, 20
	sub	%g4, %g5, %g4
	sti	%g4, %g1, 28
	jlt	%g0, %g3, jle_else.744
	ldi	%g5, %g1, 24
	jne	%g5, %g0, jeq_else.746
	addi	%g3, %g0, 0
	jmp	jeq_cont.747
jeq_else.746:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.747:
	jmp	jle_cont.745
jle_else.744:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.745:
	addi	%g4, %g0, 10000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ldi	%g7, %g1, 28
	sti	%g3, %g1, 32
	mov	%g3, %g7
	subi	%g1, %g1, 40
	call	div_binary_search.331
	addi	%g1, %g1, 40
	addi	%g4, %g0, 10000
	mul	%g4, %g3, %g4
	ldi	%g5, %g1, 28
	sub	%g4, %g5, %g4
	sti	%g4, %g1, 36
	jlt	%g0, %g3, jle_else.748
	ldi	%g5, %g1, 32
	jne	%g5, %g0, jeq_else.750
	addi	%g3, %g0, 0
	jmp	jeq_cont.751
jeq_else.750:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.751:
	jmp	jle_cont.749
jle_else.748:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.749:
	addi	%g4, %g0, 1000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ldi	%g7, %g1, 36
	sti	%g3, %g1, 40
	mov	%g3, %g7
	subi	%g1, %g1, 48
	call	div_binary_search.331
	addi	%g1, %g1, 48
	muli	%g4, %g3, 1000
	ldi	%g5, %g1, 36
	sub	%g4, %g5, %g4
	sti	%g4, %g1, 44
	jlt	%g0, %g3, jle_else.752
	ldi	%g5, %g1, 40
	jne	%g5, %g0, jeq_else.754
	addi	%g3, %g0, 0
	jmp	jeq_cont.755
jeq_else.754:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.755:
	jmp	jle_cont.753
jle_else.752:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.753:
	addi	%g4, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ldi	%g7, %g1, 44
	sti	%g3, %g1, 48
	mov	%g3, %g7
	subi	%g1, %g1, 56
	call	div_binary_search.331
	addi	%g1, %g1, 56
	muli	%g4, %g3, 100
	ldi	%g5, %g1, 44
	sub	%g4, %g5, %g4
	sti	%g4, %g1, 52
	jlt	%g0, %g3, jle_else.756
	ldi	%g5, %g1, 48
	jne	%g5, %g0, jeq_else.758
	addi	%g3, %g0, 0
	jmp	jeq_cont.759
jeq_else.758:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.759:
	jmp	jle_cont.757
jle_else.756:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.757:
	addi	%g4, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ldi	%g7, %g1, 52
	sti	%g3, %g1, 56
	mov	%g3, %g7
	subi	%g1, %g1, 64
	call	div_binary_search.331
	addi	%g1, %g1, 64
	muli	%g4, %g3, 10
	ldi	%g5, %g1, 52
	sub	%g4, %g5, %g4
	sti	%g4, %g1, 60
	jlt	%g0, %g3, jle_else.760
	ldi	%g5, %g1, 56
	jne	%g5, %g0, jeq_else.762
	addi	%g3, %g0, 0
	jmp	jeq_cont.763
jeq_else.762:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.763:
	jmp	jle_cont.761
jle_else.760:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.761:
	addi	%g3, %g0, 48
	ldi	%g4, %g1, 60
	add	%g3, %g3, %g4
	output	%g3
	return
jge_else.733:
	addi	%g4, %g0, 45
	sti	%g3, %g1, 0
	output	%g4
	ldi	%g3, %g1, 0
	sub	%g3, %g0, %g3
	jmp	print_int.336

!==============================
! args = [%g3]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0]
! ret type = Int
!================================
adder.344:
	ldi	%g4, %g30, -4
	add	%g3, %g4, %g3
	return

!==============================
! args = [%g3]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0]
! ret type = Int -> Int
!================================
make_adder.338:
	mov	%g4, %g2
	addi	%g2, %g2, 8
	setL %g5, adder.344
	sti	%g5, %g4, 0
	sti	%g3, %g4, -4
	mov	%g3, %g4
	return
