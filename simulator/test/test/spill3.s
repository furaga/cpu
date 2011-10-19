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

!#####################################################################
! * 算術関数用定数テーブル
!#####################################################################

! * floor		%f0 + MAGICF - MAGICF
min_caml_floor:
	fmov %f1, %f0
	! %f4 = 0.0
	setL %g3, FLOAT_ZERO
	fld %f4, %g3, 0
	fjlt %f4, %f0, FLOOR_POSITIVE	! if (%f4 <= %f0) goto FLOOR_PISITIVE
	fjeq %f4, %f0, FLOOR_POSITIVE
FLOOR_NEGATIVE:
	fneg %f0, %f0
	setL %g3, FLOAT_MAGICF
	! %f2 = FLOAT_MAGICF
	fld %f2, %g3, 0
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
	fld %f3, %g3, 0
	fadd %f0, %f0, %f3
	fsub %f0, %f0, %f2
	fneg %f0, %f0
	return
FLOOR_POSITIVE:
	setL %g3, FLOAT_MAGICF
	fld %f2, %g3, 0
	fjlt %f0, %f2, FLOOR_POSITIVE_MAIN
	fjeq %f0, %f2, FLOOR_POSITIVE_MAIN
	return
FLOOR_POSITIVE_MAIN:
	fmov %f1, %f0
	fadd %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g4, %g1, 0
	fsub %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g4, %g1, 0
	fjlt %f0, %f1, FLOOR_RET
	fjeq %f0, %f1, FLOOR_RET
	setL %g3, FLOAT_ONE
	fld %f3, %g3, 0
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
	fld %f1, %g5, 0
	setL %g5, FLOAT_MAGICFHX
	ld %g4, %g5, 0
	setL %g5, FLOAT_MAGICI
	ld %g5, %g5, 0
	jlt %g5, %g3, ITOF_BIG
	jeq %g5, %g3, ITOF_BIG
	add %g3, %g3, %g4
	st %g3, %g1, 0
	fld %f0, %g1, 0
	fsub %f0, %f0, %f1
	return
ITOF_BIG:
	setL %g4, FLOAT_ZERO
	fld %f2, %g4, 0
ITOF_LOOP:
	sub %g3, %g3, %g5
	fadd %f2, %f2, %f1
	jlt %g5, %g3, ITOF_LOOP
	jeq %g5, %g3, ITOF_LOOP
	add %g3, %g3, %g4
	st %g3, %g1, 0
	fld %f0, %g1, 0
	fsub %f0, %f0, %f1
	fadd %f0, %f0, %f2
	return

! * int_of_float
min_caml_int_of_float:
	! %f1 <= 0.0
	setL %g3, FLOAT_ZERO
	fld %f1, %g3, 0
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
	fld %f2, %g4, 0
	setL %g4, FLOAT_MAGICFHX
	ld %g4, %g4, 0
	fjlt %f2, %f0, FTOI_BIG		! if (MAGICF <= %f0) goto FTOI_BIG
	fjeq %f2, %f0, FTOI_BIG
	fadd %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g3, %g1, 0
	sub %g3, %g3, %g4
	return
FTOI_BIG:
	setL %g5, FLOAT_MAGICI
	ld %g5, %g5, 0
	mov %g3, %g0
FTOI_LOOP:
	fsub %f0, %f0, %f2
	add %g3, %g3, %g5
	fjlt %f2, %f0, FTOI_LOOP
	fjeq %f2, %f0, FTOI_LOOP
	fadd %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g5, %g1, 0
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

print_int_get_digits.353:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	ld	%g6, %g4, 0
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g7, %g6, jle_else.755
	subi	%g3, %g3, 1
	return
jle_else.755:
	ld	%g6, %g4, 0
	divi	%g6, %g6, 10
	ld	%g7, %g4, 0
	muli	%g8, %g6, 10
	sub	%g7, %g7, %g8
	slli	%g8, %g3, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g8
	st	%g7, %g5, 0
	ld	%g5, %g1, 4
	st	%g6, %g4, 0
	addi	%g3, %g3, 1
	ld	%g28, %g29, 0
	b	%g28
print_int_print_digits.355:
	ld	%g4, %g29, -4
	mvhi	%g5, 0
	mvlo	%g5, 0
	jlt	%g3, %g5, jle_else.756
	slli	%g5, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g5
	ld	%g4, %g4, 0
	addi	%g4, %g4, 48
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g4
	output	%g3
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.756:
	return
print_int.357:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g29, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g3, %g6, jle_else.758
	mov	%g6, %g3
	jmp	jle_cont.759
jle_else.758:
	sub	%g6, %g0, %g3
jle_cont.759:
	st	%g6, %g4, 0
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g5, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g4
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g5, %g1, 4
	st	%g3, %g1, 8
	jlt	%g5, %g4, jle_else.760
	jmp	jle_cont.761
jle_else.760:
	mvhi	%g4, 0
	mvlo	%g4, 45
	mov	%g3, %g4
	output	%g3
jle_cont.761:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 8
	jlt	%g4, %g3, jle_else.762
	ld	%g29, %g1, 0
	mov	%g3, %g4
	ld	%g28, %g29, 0
	b	%g28
jle_else.762:
	mvhi	%g3, 0
	mvlo	%g3, 48
	output	%g3
	return
f.359:
	addi	%g4, %g3, 1
	addi	%g5, %g4, 1
	addi	%g6, %g5, 1
	addi	%g7, %g6, 1
	addi	%g8, %g7, 1
	addi	%g9, %g8, 1
	addi	%g10, %g9, 1
	addi	%g11, %g10, 1
	addi	%g12, %g11, 1
	addi	%g13, %g12, 1
	addi	%g14, %g13, 1
	addi	%g15, %g14, 1
	addi	%g16, %g15, 1
	addi	%g17, %g16, 1
	addi	%g18, %g17, 1
	addi	%g19, %g18, 1
	addi	%g20, %g19, 1
	addi	%g21, %g20, 1
	add	%g22, %g21, %g4
	add	%g23, %g22, %g5
	add	%g24, %g23, %g6
	add	%g25, %g24, %g7
	add	%g26, %g25, %g8
	add	%g27, %g26, %g9
	add	%g28, %g27, %g10
	add	%g29, %g28, %g11
	st	%g29, %g1, 0
	add	%g29, %g29, %g12
	st	%g29, %g1, 4
	add	%g29, %g29, %g13
	st	%g29, %g1, 8
	add	%g29, %g29, %g14
	st	%g29, %g1, 12
	add	%g29, %g29, %g15
	st	%g29, %g1, 16
	add	%g29, %g29, %g16
	st	%g29, %g1, 20
	add	%g29, %g29, %g17
	st	%g29, %g1, 24
	add	%g29, %g29, %g18
	st	%g29, %g1, 28
	add	%g29, %g29, %g19
	st	%g29, %g1, 32
	add	%g29, %g29, %g20
	st	%g3, %g1, 36
	add	%g3, %g29, %g3
	add	%g4, %g4, %g5
	add	%g4, %g4, %g6
	add	%g4, %g4, %g7
	add	%g4, %g4, %g8
	add	%g4, %g4, %g9
	add	%g4, %g4, %g10
	add	%g4, %g4, %g11
	add	%g4, %g4, %g12
	add	%g4, %g4, %g13
	add	%g4, %g4, %g14
	add	%g4, %g4, %g15
	add	%g4, %g4, %g16
	add	%g4, %g4, %g17
	add	%g4, %g4, %g18
	add	%g4, %g4, %g19
	add	%g4, %g4, %g20
	add	%g4, %g4, %g21
	add	%g4, %g4, %g22
	add	%g4, %g4, %g23
	add	%g4, %g4, %g24
	add	%g4, %g4, %g25
	add	%g4, %g4, %g26
	add	%g4, %g4, %g27
	add	%g4, %g4, %g28
	ld	%g5, %g1, 0
	add	%g4, %g4, %g5
	ld	%g5, %g1, 4
	add	%g4, %g4, %g5
	ld	%g5, %g1, 8
	add	%g4, %g4, %g5
	ld	%g5, %g1, 12
	add	%g4, %g4, %g5
	ld	%g5, %g1, 16
	add	%g4, %g4, %g5
	ld	%g5, %g1, 20
	add	%g4, %g4, %g5
	ld	%g5, %g1, 24
	add	%g4, %g4, %g5
	ld	%g5, %g1, 28
	add	%g4, %g4, %g5
	ld	%g5, %g1, 32
	add	%g4, %g4, %g5
	add	%g4, %g4, %g29
	add	%g3, %g4, %g3
	ld	%g4, %g1, 36
	add	%g3, %g3, %g4
	return
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 1
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 10
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 0
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g4, %g2
	addi	%g2, %g2, 16
	setL %g5, print_int_get_digits.353
	st	%g5, %g4, 0
	st	%g3, %g4, -8
	ld	%g5, %g1, 0
	st	%g5, %g4, -4
	mov	%g6, %g2
	addi	%g2, %g2, 8
	setL %g7, print_int_print_digits.355
	st	%g7, %g6, 0
	st	%g5, %g6, -4
	mov	%g5, %g2
	addi	%g2, %g2, 16
	setL %g7, print_int.357
	st	%g7, %g5, 0
	st	%g3, %g5, -12
	st	%g6, %g5, -8
	st	%g4, %g5, -4
	mvhi	%g3, 0
	mvlo	%g3, 0
	st	%g5, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	f.359
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g29, %g1, 4
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	halt
