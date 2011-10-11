.init_heap_size	416
l.403:	! 12.000000
	.long	0x41400000
l.398:	! 11.000000
	.long	0x41300000
l.393:	! 10.000000
	.long	0x41200000
l.388:	! 9.000000
	.long	0x41100000
l.383:	! 8.000000
	.long	0x41000000
l.378:	! 7.000000
	.long	0x40e00000
l.373:	! 6.000000
	.long	0x40c00000
l.368:	! 5.000000
	.long	0x40a00000
l.363:	! 4.000000
	.long	0x40800000
l.358:	! 3.000000
	.long	0x40400000
l.353:	! 2.000000
	.long	0x40000000
l.348:	! 1.000000
	.long	0x3f800000
l.338:	! 0.000000
	.long	0x0
	jmp	min_caml_start

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

loop3.282:
	ld	%g4, %g29, -20
	ld	%g5, %g29, -16
	ld	%g6, %g29, -12
	ld	%g7, %g29, -8
	ld	%g8, %g29, -4
	mvhi	%g9, 0
	mvlo	%g9, 0
	jlt	%g3, %g9, jle_else.449
	slli	%g9, %g5, 2
	sub	%g6, %g6, %g9
	ld	%g9, %g6, 0
	slli	%g10, %g5, 2
	sub	%g6, %g6, %g10
	ld	%g6, %g6, 0
	slli	%g10, %g4, 2
	sub	%g6, %g6, %g10
	fld	%f0, %g6, 0
	slli	%g5, %g5, 2
	sub	%g8, %g8, %g5
	ld	%g5, %g8, 0
	slli	%g6, %g3, 2
	sub	%g5, %g5, %g6
	fld	%f1, %g5, 0
	slli	%g5, %g3, 2
	sub	%g7, %g7, %g5
	ld	%g5, %g7, 0
	slli	%g6, %g4, 2
	sub	%g5, %g5, %g6
	fld	%f2, %g5, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	slli	%g4, %g4, 2
	sub	%g9, %g9, %g4
	fst	%f0, %g9, 0
	subi	%g3, %g3, 1
	ld	%g28, %g29, 0
	b	%g28
jle_else.449:
	return
loop2.274:
	ld	%g4, %g29, -20
	ld	%g5, %g29, -16
	ld	%g6, %g29, -12
	ld	%g7, %g29, -8
	ld	%g8, %g29, -4
	mvhi	%g9, 0
	mvlo	%g9, 0
	jlt	%g3, %g9, jle_else.451
	mov	%g9, %g2
	addi	%g2, %g2, 24
	setL %g10, loop3.282
	st	%g10, %g9, 0
	st	%g3, %g9, -20
	st	%g5, %g9, -16
	st	%g6, %g9, -12
	st	%g7, %g9, -8
	st	%g8, %g9, -4
	subi	%g4, %g4, 1
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g4
	mov	%g29, %g9
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.451:
	return
loop1.269:
	ld	%g4, %g29, -20
	ld	%g5, %g29, -16
	ld	%g6, %g29, -12
	ld	%g7, %g29, -8
	ld	%g8, %g29, -4
	mvhi	%g9, 0
	mvlo	%g9, 0
	jlt	%g3, %g9, jle_else.453
	mov	%g9, %g2
	addi	%g2, %g2, 24
	setL %g10, loop2.274
	st	%g10, %g9, 0
	st	%g5, %g9, -20
	st	%g3, %g9, -16
	st	%g6, %g9, -12
	st	%g7, %g9, -8
	st	%g8, %g9, -4
	subi	%g4, %g4, 1
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g4
	mov	%g29, %g9
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.453:
	return
mul.140:
	mov	%g29, %g2
	addi	%g2, %g2, 24
	setL %g9, loop1.269
	st	%g9, %g29, 0
	st	%g5, %g29, -20
	st	%g4, %g29, -16
	st	%g8, %g29, -12
	st	%g7, %g29, -8
	st	%g6, %g29, -4
	subi	%g3, %g3, 1
	ld	%g28, %g29, 0
	b	%g28
init.256:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g3, %g6, jle_else.455
	setL %g6, l.338
	fld	%f0, %g6, 0
	st	%g29, %g1, 0
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
	sub	%g6, %g6, %g5
	st	%g3, %g6, 0
	subi	%g3, %g4, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.455:
	return
make.148:
	ld	%g5, %g29, -4
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	mov	%g4, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mov	%g29, %g2
	addi	%g2, %g2, 16
	setL %g4, init.256
	st	%g4, %g29, 0
	ld	%g4, %g1, 4
	st	%g4, %g29, -8
	st	%g3, %g29, -4
	ld	%g4, %g1, 0
	subi	%g4, %g4, 1
	st	%g3, %g1, 8
	mov	%g3, %g4
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 8
	return
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 0
	setL %g4, l.338
	fld	%f0, %g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g29, %g2
	addi	%g2, %g2, 8
	setL %g4, make.148
	st	%g4, %g29, 0
	st	%g3, %g29, -4
	mvhi	%g3, 0
	mvlo	%g3, 2
	mvhi	%g4, 0
	mvlo	%g4, 3
	st	%g29, %g1, 0
	st	%g31, %g1, 4
	ld	%g28, %g29, 0
	subi	%g1, %g1, 8
	callR	%g28
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 3
	mvhi	%g5, 0
	mvlo	%g5, 2
	ld	%g29, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 2
	mvhi	%g5, 0
	mvlo	%g5, 2
	ld	%g29, %g1, 0
	st	%g3, %g1, 8
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mov	%g8, %g3
	ld	%g6, %g1, 4
	ld	%g3, %g6, 0
	setL %g4, l.348
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	ld	%g3, %g6, 0
	setL %g4, l.353
	fld	%f0, %g4, 0
	fst	%f0, %g3, -4
	ld	%g3, %g6, 0
	setL %g4, l.358
	fld	%f0, %g4, 0
	fst	%f0, %g3, -8
	ld	%g3, %g6, -4
	setL %g4, l.363
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	ld	%g3, %g6, -4
	setL %g4, l.368
	fld	%f0, %g4, 0
	fst	%f0, %g3, -4
	ld	%g3, %g6, -4
	setL %g4, l.373
	fld	%f0, %g4, 0
	fst	%f0, %g3, -8
	ld	%g7, %g1, 8
	ld	%g3, %g7, 0
	setL %g4, l.378
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	ld	%g3, %g7, 0
	setL %g4, l.383
	fld	%f0, %g4, 0
	fst	%f0, %g3, -4
	ld	%g3, %g7, -4
	setL %g4, l.388
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	ld	%g3, %g7, -4
	setL %g4, l.393
	fld	%f0, %g4, 0
	fst	%f0, %g3, -4
	ld	%g3, %g7, -8
	setL %g4, l.398
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	ld	%g3, %g7, -8
	setL %g4, l.403
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
	call	mul.140
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
	output	%g3
	output	%g3
	ld	%g3, %g1, 12
	ld	%g4, %g3, 0
	fld	%f0, %g4, -4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_truncate
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	output	%g3
	output	%g3
	ld	%g3, %g1, 12
	ld	%g4, %g3, -4
	fld	%f0, %g4, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_truncate
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	output	%g3
	output	%g3
	ld	%g3, %g1, 12
	ld	%g3, %g3, -4
	fld	%f0, %g3, -4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_truncate
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	output	%g3
	output	%g3
	halt
