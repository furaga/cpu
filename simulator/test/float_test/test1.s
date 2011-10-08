.init_heap_size	128
l.127:	! -0.001000
	.long	0xba831266
l.123:	! 1.010000
	.long	0x3f8147a6
l.121:	! 1.000000
	.long	0x3f800000
l.119:	! 0.000000
	.long	0x00000000
	jmp	min_caml_start

fless.52:
	fjlt	%f0, %f1, fjle_else.142
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjle_else.142:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fispos.55:
	setL %g3, l.119
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjle_else.143
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjle_else.143:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
min_caml_start:
	setL %g3, l.127
	fld	%f0, %g3, 0
	fjlt	%f0, %f0, fjle_else.143
	setL %g3, l.123
	fld	%f0, %g3, 0
	fjlt	%f0, %f0, fjle_else.143
	setL %g3, l.121
	fld	%f0, %g3, 0
	fjlt	%f0, %f0, fjle_else.143
	setL %g3, l.119
	fld	%f0, %g3, 0
	fjlt	%f0, %f0, fjle_else.143
	setL %g3, l.121
	fld	%f0, %g3, 0
	setL %g3, l.123
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
	jne	%g3, %g4, jeq_else.144
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
	jmp	jeq_cont.145
jeq_else.144:
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
jeq_cont.145:
	fld	%f0, %g1, 16
	fld	%f1, %g1, 8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fless.52
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.146
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.147
jeq_else.146:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.147:
	fld	%f0, %g1, 8
	fmov	%f1, %f0
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
	fld	%f0, %g1, 0
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
	setL %g3, l.121
	fld	%f0, %g3, 0
	setL %g3, l.127
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
	jne	%g3, %g4, jeq_else.152
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
	jmp	jeq_cont.153
jeq_else.152:
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
jeq_cont.153:
	fld	%f0, %g1, 32
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fispos.55
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.154
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.155
jeq_else.154:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.155:
	fld	%f0, %g1, 24
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
	setL %g3, l.121
	fld	%f0, %g3, 0
	setL %g3, l.127
	fld	%f1, %g3, 0
	setL %g3, l.119
	fld	%f2, %g3, 0
	fst	%f2, %g1, 40
	fst	%f1, %g1, 48
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fispos.55
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
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
	fld	%f0, %g1, 48
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fispos.55
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.160
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
	jmp	jeq_cont.161
jeq_else.160:
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
jeq_cont.161:
	fld	%f0, %g1, 40
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fispos.55
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.162
	mvhi	%g3, 0
	mvlo	%g3, 1
	output	%g3
	jmp	jeq_cont.163
jeq_else.162:
	mvhi	%g3, 0
	mvlo	%g3, 0
	output	%g3
jeq_cont.163:
	halt
