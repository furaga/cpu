.init_heap_size	128
l.166:	! -0.001000
	.long	0xba831266
l.162:	! 1.010000
	.long	0x3f8147a6
l.160:	! 1.000000
	.long	0x3f800000
l.156:	! 0.000000
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
	fst %f0, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_FLOAT_ARRAY_LOOP
CREATE_FLOAT_ARRAY_END:
	return

!#####################################################################
! * ここまでライブラリ関数
!#####################################################################

fless.68:
	fjlt	%f0, %f1, fjge_else.186
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.186:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fispos.71:
	setL %g3, l.156
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.187
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.187:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fisneg.73:
	setL %g3, l.156
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.188
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.188:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fiszero.75:
	setL %g3, l.156
	fld	%f1, %g3, 0
	fjeq	%f0, %f1, fjne_else.189
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjne_else.189:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
min_caml_start:
	setL %g3, l.160
	fld	%f0, %g3, 0
	setL %g3, l.162
	fld	%f1, %g3, 0
	setL %g3, l.156
	fld	%f2, %g3, 0
	fst	%f2, %g1, 0
	fst	%f0, %g1, 8
	fst	%f1, %g1, 16
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fless.68
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.190
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
	jmp	jeq_cont.191
jeq_else.190:
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
jeq_cont.191:
	fld	%f0, %g1, 16
	fld	%f1, %g1, 8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fless.68
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.192
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.193
jeq_else.192:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.193:
	fld	%f0, %g1, 8
	fmov	%f1, %f0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fless.68
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.194
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.195
jeq_else.194:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.195:
	fld	%f0, %g1, 0
	fmov	%f1, %f0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fless.68
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.196
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.197
jeq_else.196:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.197:
	setL %g3, l.160
	fld	%f0, %g3, 0
	setL %g3, l.166
	fld	%f1, %g3, 0
	setL %g3, l.156
	fld	%f2, %g3, 0
	fst	%f2, %g1, 24
	fst	%f1, %g1, 32
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fispos.71
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.198
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
	jmp	jeq_cont.199
jeq_else.198:
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
jeq_cont.199:
	fld	%f0, %g1, 32
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fispos.71
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.200
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.201
jeq_else.200:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.201:
	fld	%f0, %g1, 24
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fispos.71
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.202
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.203
jeq_else.202:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.203:
	setL %g3, l.160
	fld	%f0, %g3, 0
	setL %g3, l.166
	fld	%f1, %g3, 0
	setL %g3, l.156
	fld	%f2, %g3, 0
	fst	%f2, %g1, 40
	fst	%f1, %g1, 48
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fisneg.73
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.204
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.205
jeq_else.204:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.205:
	fld	%f0, %g1, 48
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fisneg.73
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.206
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
	jmp	jeq_cont.207
jeq_else.206:
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
jeq_cont.207:
	fld	%f0, %g1, 40
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fisneg.73
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.208
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.209
jeq_else.208:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.209:
	setL %g3, l.160
	fld	%f0, %g3, 0
	setL %g3, l.166
	fld	%f1, %g3, 0
	setL %g3, l.156
	fld	%f2, %g3, 0
	fst	%f2, %g1, 56
	fst	%f1, %g1, 64
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fiszero.75
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.210
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.211
jeq_else.210:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.211:
	fld	%f0, %g1, 64
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fiszero.75
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.212
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.213
jeq_else.212:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.213:
	fld	%f0, %g1, 56
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fiszero.75
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.214
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
	jmp	jeq_cont.215
jeq_else.214:
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
jeq_cont.215:
	halt
