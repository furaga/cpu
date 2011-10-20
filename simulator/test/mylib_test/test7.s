.init_heap_size	0
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

mul10.134:
	muli	%g4, %g3, 2
	muli	%g3, %g3, 8
	add	%g3, %g3, %g4
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
	jlt	%g4, %g3, jle_else.388
	mvhi	%g3, 0
	mvlo	%g3, 57
	jlt	%g3, %g4, jle_else.390
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jle_cont.391
jle_else.390:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.391:
	jmp	jle_cont.389
jle_else.388:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.389:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.392
	ld	%g3, %g1, 16
	ld	%g6, %g3, 0
	jne	%g6, %g5, jeq_else.393
	mvhi	%g5, 0
	mvlo	%g5, 45
	ld	%g6, %g1, 12
	jne	%g6, %g5, jeq_else.395
	mvhi	%g5, 65535
	mvlo	%g5, -1
	st	%g5, %g3, 0
	jmp	jeq_cont.396
jeq_else.395:
	mvhi	%g5, 0
	mvlo	%g5, 1
	st	%g5, %g3, 0
jeq_cont.396:
	jmp	jeq_cont.394
jeq_else.393:
jeq_cont.394:
	subi	%g3, %g4, 48
	ld	%g5, %g1, 8
	ld	%g6, %g5, 0
	st	%g4, %g1, 20
	st	%g3, %g1, 24
	mov	%g3, %g6
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	mul10.134
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 24
	add	%g3, %g3, %g4
	ld	%g4, %g1, 8
	st	%g3, %g4, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 20
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.392:
	ld	%g3, %g1, 0
	jne	%g3, %g5, jeq_else.397
	ld	%g29, %g1, 4
	mov	%g3, %g5
	ld	%g28, %g29, 0
	b	%g28
jeq_else.397:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 16
	ld	%g4, %g4, 0
	jne	%g4, %g3, jeq_else.398
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	return
jeq_else.398:
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	sub	%g3, %g0, %g3
	return
read_int.136:
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
	mov	%g29, %g2
	addi	%g2, %g2, 16
	setL %g4, read_token.247
	st	%g4, %g29, 0
	st	%g3, %g29, -8
	ld	%g3, %g1, 8
	st	%g3, %g29, -4
	mvhi	%g4, 0
	mvlo	%g4, 32
	ld	%g3, %g1, 0
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
	jlt	%g4, %g3, jle_else.399
	mvhi	%g3, 0
	mvlo	%g3, 57
	jlt	%g3, %g4, jle_else.401
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jle_cont.402
jle_else.401:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.402:
	jmp	jle_cont.400
jle_else.399:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.400:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.403
	ld	%g3, %g1, 16
	ld	%g6, %g3, 0
	jne	%g6, %g5, jeq_else.404
	mvhi	%g5, 0
	mvlo	%g5, 45
	ld	%g6, %g1, 12
	jne	%g6, %g5, jeq_else.406
	mvhi	%g5, 65535
	mvlo	%g5, -1
	st	%g5, %g3, 0
	jmp	jeq_cont.407
jeq_else.406:
	mvhi	%g5, 0
	mvlo	%g5, 1
	st	%g5, %g3, 0
jeq_cont.407:
	jmp	jeq_cont.405
jeq_else.404:
jeq_cont.405:
	subi	%g3, %g4, 48
	ld	%g5, %g1, 8
	ld	%g6, %g5, 0
	st	%g4, %g1, 20
	st	%g3, %g1, 24
	mov	%g3, %g6
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	mul10.134
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 24
	add	%g3, %g3, %g4
	ld	%g4, %g1, 8
	st	%g3, %g4, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 20
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.403:
	ld	%g3, %g1, 0
	jne	%g3, %g5, jeq_else.408
	ld	%g29, %g1, 4
	mov	%g3, %g5
	ld	%g28, %g29, 0
	b	%g28
jeq_else.408:
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
	jlt	%g3, %g4, jle_else.409
	mvhi	%g4, 0
	mvlo	%g4, 57
	jlt	%g4, %g3, jle_else.411
	mvhi	%g4, 0
	mvlo	%g4, 0
	jmp	jle_cont.412
jle_else.411:
	mvhi	%g4, 0
	mvlo	%g4, 1
jle_cont.412:
	jmp	jle_cont.410
jle_else.409:
	mvhi	%g4, 0
	mvlo	%g4, 1
jle_cont.410:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g4, %g5, jeq_else.413
	subi	%g3, %g3, 48
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
jeq_else.413:
	ld	%g3, %g1, 0
	jne	%g3, %g5, jeq_else.414
	ld	%g29, %g1, 4
	mov	%g3, %g5
	ld	%g28, %g29, 0
	b	%g28
jeq_else.414:
	return
read_float.138:
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
	ld	%g4, %g1, 4
	st	%g3, %g1, 12
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	st	%g3, %g1, 16
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g29, %g2
	addi	%g2, %g2, 16
	setL %g4, read_token1.161
	st	%g4, %g29, 0
	st	%g3, %g29, -8
	ld	%g4, %g1, 8
	st	%g4, %g29, -4
	mov	%g5, %g2
	addi	%g2, %g2, 16
	setL %g6, read_token2.164
	st	%g6, %g5, 0
	ld	%g6, %g1, 12
	st	%g6, %g5, -8
	ld	%g7, %g1, 16
	st	%g7, %g5, -4
	mvhi	%g8, 0
	mvlo	%g8, 32
	ld	%g9, %g1, 0
	st	%g3, %g1, 20
	st	%g5, %g1, 24
	mov	%g4, %g8
	mov	%g3, %g9
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 46
	jne	%g3, %g4, jeq_else.416
	ld	%g3, %g1, 0
	ld	%g29, %g1, 24
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 12
	ld	%g3, %g3, 0
	fst	%f0, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_float_of_int
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 16
	ld	%g3, %g3, 0
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_float_of_int
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 28
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.417
jeq_else.416:
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_float_of_int
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
jeq_cont.417:
	ld	%g3, %g1, 20
	ld	%g3, %g3, 0
	ld	%g4, %g1, 4
	jne	%g3, %g4, jeq_else.418
	return
jeq_else.418:
	fneg	%f0, %f0
	return
min_caml_start:
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	read_int.136
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_print_int
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	read_int.136
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_print_int
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	read_int.136
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_print_int
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
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
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	halt
