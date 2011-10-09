.init_heap_size	128
l.128:	! -0.001000
	.long	0xba031266
l.124:	! 1.010000
	.long	0x3f8147a6
l.122:	! 1.000000
	.long	0x3f800000
l.119:	! 0.000000
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

fless.52:
	fjlt	%f0, %f1, fjge_else.143
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.143:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fispos.55:
	setL %g3, l.119
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.144
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.144:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fisneg.57:
	setL %g3, l.119
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.145
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.145:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
min_caml_start:
	setL %g3, l.122
	fld	%f0, %g3, 0
	setL %g3, l.124
	fld	%f1, %g3, 0
	setL %g3, l.119
	fld	%f2, %g3, 0
	fst	%f2, %g1, 0
	fst	%f0, %g1, 8
	fst	%f1, %g1, 16
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fless.52
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.146
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
	jmp	jeq_cont.147
jeq_else.146:
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
jeq_cont.147:
	fld	%f0, %g1, 16
	fld	%f1, %g1, 8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fless.52
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.148
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.149
jeq_else.148:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.149:
	fld	%f0, %g1, 8
	fmov	%f1, %f0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fless.52
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.150
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.151
jeq_else.150:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.151:
	fld	%f0, %g1, 0
	fmov	%f1, %f0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fless.52
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.152
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.153
jeq_else.152:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.153:
	setL %g3, l.122
	fld	%f0, %g3, 0
	setL %g3, l.128
	fld	%f1, %g3, 0
	setL %g3, l.119
	fld	%f2, %g3, 0
	fst	%f2, %g1, 24
	fst	%f1, %g1, 32
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fispos.55
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.154
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
	jmp	jeq_cont.155
jeq_else.154:
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
jeq_cont.155:
	fld	%f0, %g1, 32
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fispos.55
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.156
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.157
jeq_else.156:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.157:
	fld	%f0, %g1, 24
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fispos.55
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.158
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.159
jeq_else.158:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.159:
	setL %g3, l.122
	fld	%f0, %g3, 0
	setL %g3, l.128
	fld	%f1, %g3, 0
	setL %g3, l.119
	fld	%f2, %g3, 0
	fst	%f2, %g1, 40
	fst	%f1, %g1, 48
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fisneg.57
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.160
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.161
jeq_else.160:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.161:
	fld	%f0, %g1, 48
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fisneg.57
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.162
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
	jmp	jeq_cont.163
jeq_else.162:
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
jeq_cont.163:
	fld	%f0, %g1, 40
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fisneg.57
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.164
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.165
jeq_else.164:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.165:
	halt
