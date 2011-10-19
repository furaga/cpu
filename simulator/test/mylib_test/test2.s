.init_heap_size	192
l.113:	! -0.100000
	.long	0xbdccccc4
l.110:	! -1.010000
	.long	0xbf8147a6
l.107:	! -118.625000
	.long	0xc2ed4000
l.105:	! 118.625000
	.long	0x42ed4000
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
	fjlt	%f0, %f1, fjge_else.136
	return
fjge_else.136:
	fneg	%f0, %f0
	return
fneg.46:
	fneg	%f0, %f0
	return
min_caml_start:
	setL %g3, l.105
	fld	%f0, %g3, 0
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.107
	fld	%f0, %g3, 0
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.101
	fld	%f0, %g3, 0
	fst	%f0, %g1, 0
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	fld	%f0, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	fhalf.40
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.110
	fld	%f0, %g3, 0
	fst	%f0, %g1, 4
	fst	%f0, %g1, 12
	st	%g3, %g1, 16
	ld	%g3, %g1, 12
	output	%g3
	ld	%g3, %g1, 16
	fld	%f0, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fhalf.40
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fst	%f0, %g1, 12
	st	%g3, %g1, 16
	ld	%g3, %g1, 12
	output	%g3
	ld	%g3, %g1, 16
	setL %g3, l.103
	fld	%f0, %g3, 0
	fst	%f0, %g1, 8
	fst	%f0, %g1, 12
	st	%g3, %g1, 16
	ld	%g3, %g1, 12
	output	%g3
	ld	%g3, %g1, 16
	fld	%f0, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fhalf.40
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fst	%f0, %g1, 12
	st	%g3, %g1, 16
	ld	%g3, %g1, 12
	output	%g3
	ld	%g3, %g1, 16
	fld	%f0, %g1, 0
	fst	%f0, %g1, 12
	st	%g3, %g1, 16
	ld	%g3, %g1, 12
	output	%g3
	ld	%g3, %g1, 16
	fld	%f0, %g1, 0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fsqr.42
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fst	%f0, %g1, 12
	st	%g3, %g1, 16
	ld	%g3, %g1, 12
	output	%g3
	ld	%g3, %g1, 16
	setL %g3, l.113
	fld	%f0, %g3, 0
	fst	%f0, %g1, 12
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	fld	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fsqr.42
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
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
	call	fsqr.42
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
	call	fabs.44
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
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
	fld	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fabs.44
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
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
	call	fabs.44
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
	call	fneg.46
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
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
	fld	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fneg.46
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
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
	call	fneg.46
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fst	%f0, %g1, 20
	st	%g3, %g1, 24
	ld	%g3, %g1, 20
	output	%g3
	ld	%g3, %g1, 24
	halt
