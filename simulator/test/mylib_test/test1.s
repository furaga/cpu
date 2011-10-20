.init_heap_size	128
l.165:	! -0.001000
	.long	0xba831266
l.162:	! 1.000000
	.long	0x3f800000
l.160:	! 1.010000
	.long	0x3f8147a6
l.156:	! 0.000000
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

fless.68:
	fjlt	%f0, %f1, fjge_else.228
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.228:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fispos.71:
	setL %g3, l.156
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.229
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.229:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fisneg.73:
	setL %g3, l.156
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.230
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.230:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fiszero.75:
	setL %g3, l.156
	fld	%f1, %g3, 0
	fjeq	%f0, %f1, fjne_else.231
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjne_else.231:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 0
	setL %g4, l.160
	fld	%f1, %g4, 0
	setL %g4, l.162
	fld	%f0, %g4, 0
	fst	%f0, %g1, 0
	fst	%f1, %g1, 4
	st	%g3, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fless.68
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.232
	mov	%g3, %g4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_print_int
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	jmp	jeq_cont.233
jeq_else.232:
	mvhi	%g3, 0
	mvlo	%g3, 1
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_print_int
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
jeq_cont.233:
	fld	%f0, %g1, 4
	fld	%f1, %g1, 0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fless.68
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.234
	mvhi	%g3, 0
	mvlo	%g3, 1
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_print_int
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	jmp	jeq_cont.235
jeq_else.234:
	mov	%g3, %g4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_print_int
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
jeq_cont.235:
	fld	%f0, %g1, 0
	fmov	%f1, %f0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fless.68
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.236
	mvhi	%g3, 0
	mvlo	%g3, 1
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_print_int
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	jmp	jeq_cont.237
jeq_else.236:
	mov	%g3, %g4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_print_int
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
jeq_cont.237:
	setL %g3, l.156
	fld	%f0, %g3, 0
	fst	%f0, %g1, 12
	fmov	%f1, %f0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fless.68
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.238
	mvhi	%g3, 0
	mvlo	%g3, 1
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	jmp	jeq_cont.239
jeq_else.238:
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.239:
	fld	%f0, %g1, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fispos.71
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.240
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	jmp	jeq_cont.241
jeq_else.240:
	mvhi	%g3, 0
	mvlo	%g3, 1
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.241:
	setL %g3, l.165
	fld	%f0, %g3, 0
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fispos.71
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.242
	mvhi	%g3, 0
	mvlo	%g3, 1
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	jmp	jeq_cont.243
jeq_else.242:
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.243:
	fld	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fispos.71
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.244
	mvhi	%g3, 0
	mvlo	%g3, 1
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	jmp	jeq_cont.245
jeq_else.244:
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.245:
	fld	%f0, %g1, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fisneg.73
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.246
	mvhi	%g3, 0
	mvlo	%g3, 1
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	jmp	jeq_cont.247
jeq_else.246:
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.247:
	fld	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fisneg.73
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.248
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	jmp	jeq_cont.249
jeq_else.248:
	mvhi	%g3, 0
	mvlo	%g3, 1
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.249:
	fld	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fisneg.73
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.250
	mvhi	%g3, 0
	mvlo	%g3, 1
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	jmp	jeq_cont.251
jeq_else.250:
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.251:
	fld	%f0, %g1, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fiszero.75
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.252
	mvhi	%g3, 0
	mvlo	%g3, 1
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	jmp	jeq_cont.253
jeq_else.252:
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.253:
	fld	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fiszero.75
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.254
	mvhi	%g3, 0
	mvlo	%g3, 1
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	jmp	jeq_cont.255
jeq_else.254:
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.255:
	fld	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fiszero.75
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	jne	%g3, %g4, jeq_else.256
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	jmp	jeq_cont.257
jeq_else.256:
	mvhi	%g3, 0
	mvlo	%g3, 1
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_print_int
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.257:
	halt
