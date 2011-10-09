.init_heap_size	416
l.396:	! 12.000000
	.long	0x41400000
l.391:	! 11.000000
	.long	0x41300000
l.386:	! 10.000000
	.long	0x41200000
l.381:	! 9.000000
	.long	0x41100000
l.376:	! 8.000000
	.long	0x41000000
l.371:	! 7.000000
	.long	0x40e00000
l.366:	! 6.000000
	.long	0x40c00000
l.361:	! 5.000000
	.long	0x40a00000
l.356:	! 4.000000
	.long	0x40800000
l.351:	! 3.000000
	.long	0x40400000
l.346:	! 2.000000
	.long	0x40000000
l.341:	! 1.000000
	.long	0x3f800000
l.335:	! 0.000000
	.long	0x0
	jmp	min_caml_start

!#####################################################################
! * ここからライブラリ関数
!#####################################################################

! * create_array
min_caml_create_array:
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
	add %g4, %g3, %g2
	mov %g3, %g2
CREATE_FLOAT_ARRAY_LOOP:
	jlt %g4, %g2, CREATE_FLOAT_ARRAY_END
	st %f0, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_FLOAT_ARRAY_LOOP
CREATE_FLOAT_ARRAY_END:
	return

!#####################################################################
! * ここまでライブラリ関数
!#####################################################################

loop3.140:
	mvhi	%g9, 0
	mvlo	%g9, 0
	jlt	%g4, %g9, jle_else.447
	slli	%g9, %g3, 2
	ld	%g9, %g8, %g9
	slli	%g10, %g3, 2
	ld	%g10, %g8, %g10
	slli	%g11, %g5, 2
	fld	%f0, %g10, %g11
	slli	%g10, %g3, 2
	ld	%g10, %g6, %g10
	slli	%g11, %g4, 2
	fld	%f1, %g10, %g11
	slli	%g10, %g4, 2
	ld	%g10, %g7, %g10
	slli	%g11, %g5, 2
	fld	%f2, %g10, %g11
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	slli	%g10, %g5, 2
	fst	%f0, %g9, %g10
	subi	%g4, %g4, 1
	jmp	loop3.140
jle_else.447:
	return
loop2.147:
	mvhi	%g9, 0
	mvlo	%g9, 0
	jlt	%g5, %g9, jle_else.449
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
	call	loop3.140
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 20
	subi	%g5, %g3, 1
	ld	%g3, %g1, 16
	ld	%g4, %g1, 12
	ld	%g6, %g1, 8
	ld	%g7, %g1, 4
	ld	%g8, %g1, 0
	jmp	loop2.147
jle_else.449:
	return
loop1.154:
	mvhi	%g9, 0
	mvlo	%g9, 0
	jlt	%g3, %g9, jle_else.451
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
	call	loop2.147
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 20
	subi	%g3, %g3, 1
	ld	%g4, %g1, 16
	ld	%g5, %g1, 12
	ld	%g6, %g1, 8
	ld	%g7, %g1, 4
	ld	%g8, %g1, 0
	jmp	loop1.154
jle_else.451:
	return
mul.161:
	subi	%g3, %g3, 1
	jmp	loop1.154
init.169:
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g3, %g6, jle_else.453
	setL %g6, l.335
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
	st	%g3, %g6, %g5
	subi	%g3, %g4, 1
	ld	%g4, %g1, 0
	mov	%g5, %g6
	jmp	init.169
jle_else.453:
	return
make.173:
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
	call	init.169
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 8
	return
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 0
	setL %g4, l.335
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
	call	make.173
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
	call	make.173
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
	call	make.173
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mov	%g8, %g3
	ld	%g6, %g1, 4
	ld	%g3, %g6, 0
	setL %g4, l.341
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	ld	%g3, %g6, 0
	setL %g4, l.346
	fld	%f0, %g4, 0
	fst	%f0, %g3, -4
	ld	%g3, %g6, 0
	setL %g4, l.351
	fld	%f0, %g4, 0
	fst	%f0, %g3, -8
	ld	%g3, %g6, -4
	setL %g4, l.356
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	ld	%g3, %g6, -4
	setL %g4, l.361
	fld	%f0, %g4, 0
	fst	%f0, %g3, -4
	ld	%g3, %g6, -4
	setL %g4, l.366
	fld	%f0, %g4, 0
	fst	%f0, %g3, -8
	ld	%g7, %g1, 8
	ld	%g3, %g7, 0
	setL %g4, l.371
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	ld	%g3, %g7, 0
	setL %g4, l.376
	fld	%f0, %g4, 0
	fst	%f0, %g3, -4
	ld	%g3, %g7, -4
	setL %g4, l.381
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	ld	%g3, %g7, -4
	setL %g4, l.386
	fld	%f0, %g4, 0
	fst	%f0, %g3, -4
	ld	%g3, %g7, -8
	setL %g4, l.391
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	ld	%g3, %g7, -8
	setL %g4, l.396
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
	call	mul.161
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
