.init_heap_size	192
l.114:	! -0.100000
	.long	0xbdccccc4
l.111:	! -118.625000
	.long	0xc2ed4000
l.109:	! 118.625000
	.long	0x42ed4000
l.106:	! -1.010000
	.long	0xbf8147a6
l.103:	! 0.000000
	.long	0x0
l.101:	! 2.000000
	.long	0x40000000
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

fhalf.40:
	setL %g3, l.101
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	return
fsqr.42:
	fmul	%f0, %f0, %f0
	return
fabs.44:
	setL %g3, l.103
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.146
	return
fjge_else.146:
	fneg	%f0, %f0
	return
fneg.46:
	fneg	%f0, %f0
	return
min_caml_start:
	setL %g3, l.101
	fld	%f0, %g3, 0
	setL %g3, l.106
	fld	%f1, %g3, 0
	setL %g3, l.103
	fld	%f2, %g3, 0
	setL %g3, l.109
	fld	%f3, %g3, 0
	setL %g3, l.111
	fld	%f4, %g3, 0
	fst	%f2, %g1, 0
	fst	%f1, %g1, 4
	fst	%f0, %g1, 8
	fst	%f4, %g1, 12
	fmov	%f0, %f3
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	fld	%f0, %g1, 12
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	fld	%f0, %g1, 8
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	fld	%f0, %g1, 8
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fhalf.40
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	fld	%f0, %g1, 4
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	fld	%f0, %g1, 4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fhalf.40
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	fld	%f0, %g1, 0
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	fld	%f0, %g1, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fhalf.40
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	setL %g3, l.101
	fld	%f0, %g3, 0
	setL %g3, l.114
	fld	%f1, %g3, 0
	setL %g3, l.103
	fld	%f2, %g3, 0
	fst	%f2, %g1, 16
	fst	%f1, %g1, 20
	fst	%f0, %g1, 24
	fst	%f0, %g1, 28
	st	%g3, %g1, 32
	ld	%g3, %g1, 28
	output	%g3
	ld	%g3, %g1, 32
	fld	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fsqr.42
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 28
	st	%g3, %g1, 32
	ld	%g3, %g1, 28
	output	%g3
	ld	%g3, %g1, 32
	fld	%f0, %g1, 20
	fst	%f0, %g1, 28
	st	%g3, %g1, 32
	ld	%g3, %g1, 28
	output	%g3
	ld	%g3, %g1, 32
	fld	%f0, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fsqr.42
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 28
	st	%g3, %g1, 32
	ld	%g3, %g1, 28
	output	%g3
	ld	%g3, %g1, 32
	fld	%f0, %g1, 16
	fst	%f0, %g1, 28
	st	%g3, %g1, 32
	ld	%g3, %g1, 28
	output	%g3
	ld	%g3, %g1, 32
	fld	%f0, %g1, 16
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fsqr.42
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 28
	st	%g3, %g1, 32
	ld	%g3, %g1, 28
	output	%g3
	ld	%g3, %g1, 32
	setL %g3, l.101
	fld	%f0, %g3, 0
	setL %g3, l.114
	fld	%f1, %g3, 0
	setL %g3, l.103
	fld	%f2, %g3, 0
	fst	%f2, %g1, 28
	fst	%f1, %g1, 32
	fst	%f0, %g1, 36
	fst	%f0, %g1, 44
	st	%g3, %g1, 48
	ld	%g3, %g1, 44
	output	%g3
	ld	%g3, %g1, 48
	fld	%f0, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fabs.44
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fst	%f0, %g1, 44
	st	%g3, %g1, 48
	ld	%g3, %g1, 44
	output	%g3
	ld	%g3, %g1, 48
	fld	%f0, %g1, 32
	fst	%f0, %g1, 44
	st	%g3, %g1, 48
	ld	%g3, %g1, 44
	output	%g3
	ld	%g3, %g1, 48
	fld	%f0, %g1, 32
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fabs.44
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fst	%f0, %g1, 44
	st	%g3, %g1, 48
	ld	%g3, %g1, 44
	output	%g3
	ld	%g3, %g1, 48
	fld	%f0, %g1, 28
	fst	%f0, %g1, 44
	st	%g3, %g1, 48
	ld	%g3, %g1, 44
	output	%g3
	ld	%g3, %g1, 48
	fld	%f0, %g1, 28
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fabs.44
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fst	%f0, %g1, 44
	st	%g3, %g1, 48
	ld	%g3, %g1, 44
	output	%g3
	ld	%g3, %g1, 48
	setL %g3, l.101
	fld	%f0, %g3, 0
	setL %g3, l.114
	fld	%f1, %g3, 0
	setL %g3, l.103
	fld	%f2, %g3, 0
	fst	%f2, %g1, 40
	fst	%f1, %g1, 44
	fst	%f0, %g1, 48
	fst	%f0, %g1, 52
	st	%g3, %g1, 56
	ld	%g3, %g1, 52
	output	%g3
	ld	%g3, %g1, 56
	fld	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.46
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fst	%f0, %g1, 52
	st	%g3, %g1, 56
	ld	%g3, %g1, 52
	output	%g3
	ld	%g3, %g1, 56
	fld	%f0, %g1, 44
	fst	%f0, %g1, 52
	st	%g3, %g1, 56
	ld	%g3, %g1, 52
	output	%g3
	ld	%g3, %g1, 56
	fld	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.46
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fst	%f0, %g1, 52
	st	%g3, %g1, 56
	ld	%g3, %g1, 52
	output	%g3
	ld	%g3, %g1, 56
	fld	%f0, %g1, 40
	fst	%f0, %g1, 52
	st	%g3, %g1, 56
	ld	%g3, %g1, 52
	output	%g3
	ld	%g3, %g1, 56
	fld	%f0, %g1, 40
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.46
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fst	%f0, %g1, 52
	st	%g3, %g1, 56
	ld	%g3, %g1, 52
	output	%g3
	ld	%g3, %g1, 56
	halt
