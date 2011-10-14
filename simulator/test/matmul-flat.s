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
l.932:	! 12.000000
	.long	0x41400000
l.927:	! 11.000000
	.long	0x41300000
l.922:	! 10.000000
	.long	0x41200000
l.917:	! 9.000000
	.long	0x41100000
l.912:	! 8.000000
	.long	0x41000000
l.907:	! 7.000000
	.long	0x40e00000
l.902:	! 6.000000
	.long	0x40c00000
l.897:	! 5.000000
	.long	0x40a00000
l.892:	! 4.000000
	.long	0x40800000
l.887:	! 3.000000
	.long	0x40400000
l.882:	! 2.000000
	.long	0x40000000
l.877:	! 1.000000
	.long	0x3f800000
l.871:	! 0.000000
	.long	0x0
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
	call min_caml_ceil
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

get_digits.576:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	ld	%g6, %g4, 0
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g7, %g6, jle_else.994
	subi	%g3, %g3, 1
	return
jle_else.994:
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
print_digits.578:
	ld	%g4, %g29, -4
	mvhi	%g5, 0
	mvlo	%g5, 0
	jlt	%g3, %g5, jle_else.995
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
jle_else.995:
	return
print_int.392:
	mvhi	%g4, 0
	mvlo	%g4, 10
	mvhi	%g5, 0
	mvlo	%g5, 32
	st	%g3, %g1, 0
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g6, %g1, 0
	jlt	%g6, %g5, jle_else.997
	mov	%g5, %g6
	jmp	jle_cont.998
jle_else.997:
	sub	%g5, %g0, %g6
jle_cont.998:
	st	%g3, %g1, 4
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mov	%g29, %g2
	addi	%g2, %g2, 16
	setL %g4, get_digits.576
	st	%g4, %g29, 0
	st	%g3, %g29, -8
	ld	%g3, %g1, 4
	st	%g3, %g29, -4
	mov	%g4, %g2
	addi	%g2, %g2, 8
	setL %g5, print_digits.578
	st	%g5, %g4, 0
	st	%g3, %g4, -4
	mvhi	%g3, 0
	mvlo	%g3, 0
	st	%g4, %g1, 8
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g5, %g1, 0
	st	%g3, %g1, 12
	jlt	%g5, %g4, jle_else.999
	jmp	jle_cont.1000
jle_else.999:
	mvhi	%g4, 0
	mvlo	%g4, 45
	mov	%g3, %g4
	output	%g3
jle_cont.1000:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 12
	jlt	%g4, %g3, jle_else.1001
	ld	%g29, %g1, 8
	mov	%g3, %g4
	ld	%g28, %g29, 0
	b	%g28
jle_else.1001:
	mvhi	%g3, 0
	mvlo	%g3, 48
	output	%g3
	return
loop3.394:
	mvhi	%g9, 0
	mvlo	%g9, 0
	jlt	%g4, %g9, jle_else.1002
	slli	%g9, %g3, 2
	st	%g8, %g1, 4
	add	%g8, %g8, %g9
	ld	%g9, %g8, 0
	ld	%g8, %g1, 4
	slli	%g10, %g3, 2
	st	%g8, %g1, 4
	add	%g8, %g8, %g10
	ld	%g10, %g8, 0
	ld	%g8, %g1, 4
	slli	%g11, %g5, 2
	st	%g10, %g1, 4
	add	%g10, %g10, %g11
	fld	%f0, %g10, 0
	ld	%g10, %g1, 4
	slli	%g10, %g3, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g10
	ld	%g10, %g6, 0
	ld	%g6, %g1, 4
	slli	%g11, %g4, 2
	st	%g10, %g1, 4
	add	%g10, %g10, %g11
	fld	%f1, %g10, 0
	ld	%g10, %g1, 4
	slli	%g10, %g4, 2
	st	%g7, %g1, 4
	add	%g7, %g7, %g10
	ld	%g10, %g7, 0
	ld	%g7, %g1, 4
	slli	%g11, %g5, 2
	st	%g10, %g1, 4
	add	%g10, %g10, %g11
	fld	%f2, %g10, 0
	ld	%g10, %g1, 4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	slli	%g10, %g5, 2
	st	%g9, %g1, 4
	add	%g9, %g9, %g10
	fst	%f0, %g9, 0
	ld	%g9, %g1, 4
	subi	%g4, %g4, 1
	jmp	loop3.394
jle_else.1002:
	return
loop2.401:
	mvhi	%g9, 0
	mvlo	%g9, 0
	jlt	%g5, %g9, jle_else.1004
	subi	%g9, %g4, 1
	st	%g8, %g1, 0
	st	%g7, %g1, 4
	st	%g6, %g1, 8
	st	%g4, %g1, 12
	st	%g3, %g1, 16
	st	%g5, %g1, 20
	mov	%g4, %g9
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	loop3.394
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 20
	subi	%g5, %g3, 1
	ld	%g3, %g1, 16
	ld	%g4, %g1, 12
	ld	%g6, %g1, 8
	ld	%g7, %g1, 4
	ld	%g8, %g1, 0
	jmp	loop2.401
jle_else.1004:
	return
loop1.408:
	mvhi	%g9, 0
	mvlo	%g9, 0
	jlt	%g3, %g9, jle_else.1006
	subi	%g9, %g5, 1
	st	%g8, %g1, 0
	st	%g7, %g1, 4
	st	%g6, %g1, 8
	st	%g5, %g1, 12
	st	%g4, %g1, 16
	st	%g3, %g1, 20
	mov	%g5, %g9
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	loop2.401
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 20
	subi	%g3, %g3, 1
	ld	%g4, %g1, 16
	ld	%g5, %g1, 12
	ld	%g6, %g1, 8
	ld	%g7, %g1, 4
	ld	%g8, %g1, 0
	jmp	loop1.408
jle_else.1006:
	return
mul.415:
	subi	%g3, %g3, 1
	jmp	loop1.408
init.423:
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g3, %g6, jle_else.1008
	setL %g6, l.871
	fld	%f0, %g6, 0
	st	%g4, %g1, 0
	st	%g5, %g1, 4
	st	%g3, %g1, 8
	mov	%g3, %g4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 8
	slli	%g5, %g4, 2
	ld	%g6, %g1, 4
	st	%g6, %g1, 12
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 12
	subi	%g3, %g4, 1
	ld	%g4, %g1, 0
	mov	%g5, %g6
	jmp	init.423
jle_else.1008:
	return
make.427:
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	mov	%g4, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mov	%g5, %g3
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	ld	%g4, %g1, 0
	st	%g5, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	init.423
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 8
	return
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 0
	setL %g4, l.871
	fld	%f0, %g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g5, %g3
	mvhi	%g3, 0
	mvlo	%g3, 2
	mvhi	%g4, 0
	mvlo	%g4, 3
	st	%g5, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	make.427
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 3
	mvhi	%g5, 0
	mvlo	%g5, 2
	ld	%g6, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g4
	mov	%g4, %g5
	mov	%g5, %g6
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	make.427
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 2
	mvhi	%g5, 0
	mvlo	%g5, 2
	ld	%g6, %g1, 0
	st	%g3, %g1, 8
	mov	%g3, %g4
	mov	%g4, %g5
	mov	%g5, %g6
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	make.427
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mov	%g8, %g3
	ld	%g6, %g1, 4
	ld	%g3, %g6, 0
	setL %g4, l.877
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	ld	%g3, %g6, 0
	setL %g4, l.882
	fld	%f0, %g4, 0
	fst	%f0, %g3, -4
	ld	%g3, %g6, 0
	setL %g4, l.887
	fld	%f0, %g4, 0
	fst	%f0, %g3, -8
	ld	%g3, %g6, -4
	setL %g4, l.892
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	ld	%g3, %g6, -4
	setL %g4, l.897
	fld	%f0, %g4, 0
	fst	%f0, %g3, -4
	ld	%g3, %g6, -4
	setL %g4, l.902
	fld	%f0, %g4, 0
	fst	%f0, %g3, -8
	ld	%g7, %g1, 8
	ld	%g3, %g7, 0
	setL %g4, l.907
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	ld	%g3, %g7, 0
	setL %g4, l.912
	fld	%f0, %g4, 0
	fst	%f0, %g3, -4
	ld	%g3, %g7, -4
	setL %g4, l.917
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	ld	%g3, %g7, -4
	setL %g4, l.922
	fld	%f0, %g4, 0
	fst	%f0, %g3, -4
	ld	%g3, %g7, -8
	setL %g4, l.927
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	ld	%g3, %g7, -8
	setL %g4, l.932
	fld	%f0, %g4, 0
	fst	%f0, %g3, -4
	mvhi	%g3, 0
	mvlo	%g3, 2
	mvhi	%g4, 0
	mvlo	%g4, 3
	mvhi	%g5, 0
	mvlo	%g5, 2
	st	%g8, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	mul.415
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	ld	%g4, %g3, 0
	fld	%f0, %g4, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_truncate
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	print_int.392
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g3, %g1, 24
	mvhi	%g3, 0
	mvlo	%g3, 10
	output	%g3
	ld	%g3, %g1, 24
	ld	%g3, %g1, 12
	ld	%g4, %g3, 0
	fld	%f0, %g4, -4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_truncate
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	print_int.392
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g3, %g1, 24
	mvhi	%g3, 0
	mvlo	%g3, 10
	output	%g3
	ld	%g3, %g1, 24
	ld	%g3, %g1, 12
	ld	%g4, %g3, -4
	fld	%f0, %g4, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_truncate
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	print_int.392
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g3, %g1, 24
	mvhi	%g3, 0
	mvlo	%g3, 10
	output	%g3
	ld	%g3, %g1, 24
	ld	%g3, %g1, 12
	ld	%g3, %g3, -4
	fld	%f0, %g3, -4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_truncate
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	print_int.392
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g3, %g1, 24
	mvhi	%g3, 0
	mvlo	%g3, 10
	output	%g3
	ld	%g3, %g1, 24
	halt
