.init_heap_size	416
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
l.615:	! 6.000000
	.long	0x40c00000
l.613:	! 5.000000
	.long	0x40a00000
l.611:	! 4.000000
	.long	0x40800000
l.605:	! 3.000000
	.long	0x40400000
l.603:	! 2.000000
	.long	0x40000000
l.601:	! 1.000000
	.long	0x3f800000
l.599:	! 1000000.000000
	.long	0x49742400
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

get_digits.319:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	ld	%g6, %g4, 0
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g7, %g6, jle_else.644
	subi	%g3, %g3, 1
	return
jle_else.644:
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
print_digits.321:
	ld	%g4, %g29, -4
	mvhi	%g5, 0
	mvlo	%g5, 0
	jlt	%g3, %g5, jle_else.645
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
jle_else.645:
	return
print_int.275:
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
	jlt	%g6, %g5, jle_else.647
	mov	%g5, %g6
	jmp	jle_cont.648
jle_else.647:
	sub	%g5, %g0, %g6
jle_cont.648:
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
	setL %g4, get_digits.319
	st	%g4, %g29, 0
	st	%g3, %g29, -8
	ld	%g3, %g1, 4
	st	%g3, %g29, -4
	mov	%g4, %g2
	addi	%g2, %g2, 8
	setL %g5, print_digits.321
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
	jlt	%g5, %g4, jle_else.649
	jmp	jle_cont.650
jle_else.649:
	mvhi	%g4, 0
	mvlo	%g4, 45
	mov	%g3, %g4
	output	%g3
jle_cont.650:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 12
	jlt	%g4, %g3, jle_else.651
	ld	%g29, %g1, 8
	mov	%g3, %g4
	ld	%g28, %g29, 0
	b	%g28
jle_else.651:
	mvhi	%g3, 0
	mvlo	%g3, 48
	output	%g3
	return
getx.277:
	fld	%f0, %g3, 0
	return
gety.279:
	fld	%f0, %g3, -8
	return
getz.281:
	fld	%f0, %g3, -16
	return
inprod.283:
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	getx.277
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	fst	%f0, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	getx.277
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f1, %g1, 8
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 0
	fst	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	gety.279
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 4
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	gety.279
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 16
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 12
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 0
	fst	%f0, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	getz.281
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 4
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	getz.281
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 20
	fadd	%f0, %f1, %f0
	return
min_caml_start:
	setL %g3, l.599
	fld	%f0, %g3, 0
	setL %g3, l.601
	fld	%f1, %g3, 0
	setL %g3, l.603
	fld	%f2, %g3, 0
	setL %g3, l.605
	fld	%f3, %g3, 0
	mov	%g3, %g2
	addi	%g2, %g2, 24
	fst	%f3, %g3, -16
	fst	%f2, %g3, -8
	fst	%f1, %g3, 0
	setL %g4, l.611
	fld	%f1, %g4, 0
	setL %g4, l.613
	fld	%f2, %g4, 0
	setL %g4, l.615
	fld	%f3, %g4, 0
	mov	%g4, %g2
	addi	%g2, %g2, 24
	fst	%f3, %g4, -16
	fst	%f2, %g4, -8
	fst	%f1, %g4, 0
	fst	%f0, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	inprod.283
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fld	%f1, %g1, 0
	fmul	%f0, %f1, %f0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_truncate
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	print_int.275
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	halt
