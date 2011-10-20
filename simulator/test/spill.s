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

print_int_get_digits.340:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g7, %g4, 0
	jlt	%g6, %g7, jle_else.745
	subi	%g3, %g3, 1
	return
jle_else.745:
	divi	%g6, %g7, 10
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
print_int_print_digits.342:
	ld	%g4, %g29, -4
	mvhi	%g5, 0
	mvlo	%g5, 0
	jlt	%g3, %g5, jle_else.746
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
jle_else.746:
	return
print_int.344:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g29, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g3, %g6, jle_else.748
	mov	%g7, %g3
	jmp	jle_cont.749
jle_else.748:
	sub	%g7, %g0, %g3
jle_cont.749:
	st	%g7, %g4, 0
	st	%g5, %g1, 0
	st	%g3, %g1, 4
	st	%g6, %g1, 8
	mov	%g3, %g6
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	ld	%g5, %g1, 8
	st	%g3, %g1, 12
	jlt	%g4, %g5, jle_else.750
	jmp	jle_cont.751
jle_else.750:
	mvhi	%g4, 0
	mvlo	%g4, 45
	mov	%g3, %g4
	output	%g3
jle_cont.751:
	ld	%g3, %g1, 12
	ld	%g4, %g1, 8
	jlt	%g3, %g4, jle_else.752
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.752:
	mvhi	%g3, 0
	mvlo	%g3, 48
	output	%g3
	return
f.346:
	add	%g7, %g5, %g6
	add	%g8, %g4, %g6
	add	%g9, %g8, %g7
	add	%g10, %g3, %g5
	add	%g11, %g3, %g4
	add	%g12, %g11, %g10
	add	%g13, %g12, %g9
	add	%g4, %g4, %g5
	add	%g14, %g4, %g7
	add	%g15, %g12, %g14
	add	%g16, %g4, %g8
	add	%g17, %g12, %g16
	add	%g3, %g3, %g6
	add	%g18, %g3, %g7
	add	%g19, %g12, %g18
	add	%g20, %g3, %g8
	add	%g21, %g12, %g20
	add	%g22, %g3, %g4
	add	%g23, %g12, %g22
	add	%g24, %g10, %g7
	add	%g25, %g12, %g24
	add	%g26, %g10, %g8
	add	%g27, %g12, %g26
	add	%g28, %g10, %g4
	add	%g29, %g12, %g28
	st	%g13, %g1, 0
	add	%g13, %g10, %g3
	st	%g15, %g1, 4
	add	%g15, %g12, %g13
	st	%g17, %g1, 8
	add	%g17, %g11, %g7
	st	%g19, %g1, 12
	add	%g19, %g12, %g17
	st	%g21, %g1, 16
	add	%g21, %g11, %g8
	st	%g23, %g1, 20
	add	%g23, %g12, %g21
	st	%g25, %g1, 24
	add	%g25, %g11, %g4
	st	%g27, %g1, 28
	add	%g27, %g12, %g25
	st	%g29, %g1, 32
	add	%g29, %g11, %g3
	st	%g15, %g1, 36
	add	%g15, %g12, %g29
	add	%g5, %g11, %g5
	add	%g5, %g5, %g6
	add	%g5, %g5, %g11
	add	%g5, %g5, %g10
	add	%g3, %g5, %g3
	add	%g3, %g3, %g4
	add	%g3, %g3, %g8
	add	%g3, %g3, %g7
	add	%g3, %g3, %g12
	add	%g3, %g3, %g29
	add	%g3, %g3, %g25
	add	%g3, %g3, %g21
	add	%g3, %g3, %g17
	add	%g3, %g3, %g13
	add	%g3, %g3, %g28
	add	%g3, %g3, %g26
	add	%g3, %g3, %g24
	add	%g3, %g3, %g22
	add	%g3, %g3, %g20
	add	%g3, %g3, %g18
	add	%g3, %g3, %g16
	add	%g3, %g3, %g14
	add	%g3, %g3, %g9
	add	%g3, %g3, %g15
	add	%g3, %g3, %g27
	add	%g3, %g3, %g23
	add	%g3, %g3, %g19
	ld	%g4, %g1, 36
	add	%g3, %g3, %g4
	ld	%g4, %g1, 32
	add	%g3, %g3, %g4
	ld	%g4, %g1, 28
	add	%g3, %g3, %g4
	ld	%g4, %g1, 24
	add	%g3, %g3, %g4
	ld	%g4, %g1, 20
	add	%g3, %g3, %g4
	ld	%g4, %g1, 16
	add	%g3, %g3, %g4
	ld	%g4, %g1, 12
	add	%g3, %g3, %g4
	ld	%g4, %g1, 8
	add	%g3, %g3, %g4
	ld	%g4, %g1, 4
	add	%g3, %g3, %g4
	ld	%g4, %g1, 0
	add	%g3, %g3, %g4
	sub	%g3, %g0, %g3
	return
min_caml_start:
	mvhi	%g4, 0
	mvlo	%g4, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	ld	%g4, %g1, 0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	ld	%g4, %g1, 0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	ld	%g4, %g1, 0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	mov	%g4, %g3
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	ld	%g4, %g1, 0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g3, 0
	mvlo	%g3, 10
	ld	%g4, %g1, 0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	st	%g3, %g1, 8
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mov	%g4, %g2
	addi	%g2, %g2, 16
	setL %g5, print_int_get_digits.340
	st	%g5, %g4, 0
	st	%g3, %g4, -8
	ld	%g5, %g1, 8
	st	%g5, %g4, -4
	mov	%g6, %g2
	addi	%g2, %g2, 8
	setL %g7, print_int_print_digits.342
	st	%g7, %g6, 0
	st	%g5, %g6, -4
	mov	%g5, %g2
	addi	%g2, %g2, 16
	setL %g7, print_int.344
	st	%g7, %g5, 0
	st	%g3, %g5, -12
	st	%g6, %g5, -8
	st	%g4, %g5, -4
	mvhi	%g6, 0
	mvlo	%g6, 4
	mvhi	%g3, 0
	mvlo	%g3, 3
	mvhi	%g4, 0
	mvlo	%g4, 2
	ld	%g7, %g1, 4
	st	%g5, %g1, 12
	mov	%g5, %g3
	mov	%g3, %g7
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	f.346
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g29, %g1, 12
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	halt
