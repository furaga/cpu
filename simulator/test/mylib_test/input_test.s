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
	fst %f0, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_FLOAT_ARRAY_LOOP
CREATE_FLOAT_ARRAY_END:
	return

!#####################################################################
! * ここまでライブラリ関数
!#####################################################################

mul10.134:
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	return
read_token.247:
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	st	%g3, %g1, 0
	st	%g29, %g1, 4
	st	%g6, %g1, 8
	st	%g4, %g1, 12
	st	%g5, %g1, 16
	input	%g3
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 48
	jlt	%g4, %g3, jle_else.375
	mvhi	%g3, 0
	mvlo	%g3, 57
	jlt	%g3, %g4, jle_else.377
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jle_cont.378
jle_else.377:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.378:
	jmp	jle_cont.376
jle_else.375:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.376:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.379
	ld	%g3, %g1, 16
	ld	%g5, %g3, 0
	mvhi	%g6, 0
	mvlo	%g6, 0
	jne	%g5, %g6, jeq_else.380
	mvhi	%g5, 0
	mvlo	%g5, 45
	ld	%g6, %g1, 12
	jne	%g6, %g5, jeq_else.382
	mvhi	%g5, 65535
	mvlo	%g5, -1
	st	%g5, %g3, 0
	jmp	jeq_cont.383
jeq_else.382:
	mvhi	%g5, 0
	mvlo	%g5, 1
	st	%g5, %g3, 0
jeq_cont.383:
	jmp	jeq_cont.381
jeq_else.380:
jeq_cont.381:
	ld	%g3, %g1, 8
	ld	%g5, %g3, 0
	st	%g4, %g1, 20
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	mul10.134
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	subi	%g5, %g4, 48
	add	%g3, %g3, %g5
	ld	%g5, %g1, 8
	st	%g3, %g5, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.379:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g5, %g1, 0
	jne	%g5, %g3, jeq_else.384
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.384:
	ld	%g3, %g1, 16
	ld	%g3, %g3, 0
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.385
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	return
jeq_else.385:
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	muli	%g3, %g3, -1
	return
read_int.136:
	mvhi	%g3, 0
	mvlo	%g3, 1
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
	mov	%g29, %g2
	addi	%g2, %g2, 16
	setL %g4, read_token.247
	st	%g4, %g29, 0
	st	%g3, %g29, -8
	ld	%g3, %g1, 0
	st	%g3, %g29, -4
	mvhi	%g3, 0
	mvlo	%g3, 0
	mvhi	%g4, 0
	mvlo	%g4, 32
	ld	%g28, %g29, 0
	b	%g28
read_token1.161:
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	st	%g3, %g1, 0
	st	%g29, %g1, 4
	st	%g6, %g1, 8
	st	%g4, %g1, 12
	st	%g5, %g1, 16
	input	%g3
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 48
	jlt	%g4, %g3, jle_else.386
	mvhi	%g3, 0
	mvlo	%g3, 57
	jlt	%g3, %g4, jle_else.388
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jle_cont.389
jle_else.388:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.389:
	jmp	jle_cont.387
jle_else.386:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.387:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.390
	ld	%g3, %g1, 16
	ld	%g5, %g3, 0
	mvhi	%g6, 0
	mvlo	%g6, 0
	jne	%g5, %g6, jeq_else.391
	mvhi	%g5, 0
	mvlo	%g5, 45
	ld	%g6, %g1, 12
	jne	%g6, %g5, jeq_else.393
	mvhi	%g5, 65535
	mvlo	%g5, -1
	st	%g5, %g3, 0
	jmp	jeq_cont.394
jeq_else.393:
	mvhi	%g5, 0
	mvlo	%g5, 1
	st	%g5, %g3, 0
jeq_cont.394:
	jmp	jeq_cont.392
jeq_else.391:
jeq_cont.392:
	ld	%g3, %g1, 8
	ld	%g5, %g3, 0
	st	%g4, %g1, 20
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	mul10.134
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	subi	%g5, %g4, 48
	add	%g3, %g3, %g5
	ld	%g5, %g1, 8
	st	%g3, %g5, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.390:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g5, %g1, 0
	jne	%g5, %g3, jeq_else.395
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.395:
	mov	%g3, %g4
	return
read_token2.164:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	st	%g3, %g1, 0
	st	%g29, %g1, 4
	st	%g5, %g1, 8
	st	%g4, %g1, 12
	input	%g3
	mvhi	%g4, 0
	mvlo	%g4, 48
	jlt	%g3, %g4, jle_else.396
	mvhi	%g4, 0
	mvlo	%g4, 57
	jlt	%g4, %g3, jle_else.398
	mvhi	%g4, 0
	mvlo	%g4, 0
	jmp	jle_cont.399
jle_else.398:
	mvhi	%g4, 0
	mvlo	%g4, 1
jle_cont.399:
	jmp	jle_cont.397
jle_else.396:
	mvhi	%g4, 0
	mvlo	%g4, 1
jle_cont.397:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g4, %g5, jeq_else.400
	ld	%g4, %g1, 12
	ld	%g5, %g4, 0
	st	%g3, %g1, 16
	mov	%g3, %g5
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	mul10.134
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 16
	subi	%g4, %g4, 48
	add	%g3, %g3, %g4
	ld	%g4, %g1, 12
	st	%g3, %g4, 0
	ld	%g3, %g1, 8
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	mul10.134
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	st	%g3, %g4, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.400:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 0
	jne	%g4, %g3, jeq_else.401
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.401:
	return
read_float.138:
	mvhi	%g3, 0
	mvlo	%g3, 1
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
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 1
	st	%g3, %g1, 4
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 8
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mov	%g29, %g2
	addi	%g2, %g2, 16
	setL %g4, read_token1.161
	st	%g4, %g29, 0
	st	%g3, %g29, -8
	ld	%g4, %g1, 0
	st	%g4, %g29, -4
	mov	%g5, %g2
	addi	%g2, %g2, 16
	setL %g6, read_token2.164
	st	%g6, %g5, 0
	ld	%g6, %g1, 4
	st	%g6, %g5, -8
	ld	%g7, %g1, 8
	st	%g7, %g5, -4
	mvhi	%g8, 0
	mvlo	%g8, 0
	mvhi	%g9, 0
	mvlo	%g9, 32
	st	%g3, %g1, 12
	st	%g5, %g1, 16
	mov	%g4, %g9
	mov	%g3, %g8
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 46
	jne	%g3, %g4, jeq_else.403
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 0
	ld	%g3, %g3, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_float_of_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 4
	ld	%g3, %g3, 0
	fst	%f0, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 20
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.404
jeq_else.403:
	ld	%g3, %g1, 0
	ld	%g3, %g3, 0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
jeq_cont.404:
	ld	%g3, %g1, 12
	ld	%g3, %g3, 0
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.405
	return
jeq_else.405:
	fneg	%f0, %f0
	return
min_caml_start:
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	read_int.136
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	read_int.136
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	read_int.136
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	read_float.138
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	read_float.138
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	read_float.138
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fsqrt %f0, %f0
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	halt
