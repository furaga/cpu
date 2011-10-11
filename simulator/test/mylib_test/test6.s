.init_heap_size	544
l.187:	! 2.000000
	.long	0x40000000
l.185:	! 1.500000
	.long	0x3fc00000
l.183:	! 1.000000
	.long	0x3f800000
l.181:	! 0.900000
	.long	0x3f66665e
l.179:	! 0.800000
	.long	0x3f4cccc4
l.177:	! 0.700000
	.long	0x3f333333
l.175:	! 0.600000
	.long	0x3f199999
l.173:	! 0.500000
	.long	0x3f000000
l.171:	! 0.400000
	.long	0x3eccccc4
l.169:	! 0.300000
	.long	0x3e999999
l.167:	! 0.200000
	.long	0x3e4cccc4
l.165:	! 0.100000
	.long	0x3dccccc4
l.163:	! 0.000000
	.long	0x0
l.161:	! -0.500000
	.long	0xbf000000
l.159:	! -1.000000
	.long	0xbf800000
l.157:	! -1.500000
	.long	0xbfc00000
l.155:	! -2.000000
	.long	0xc0000000
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

min_caml_start:
	mvhi	%g3, 65535
	mvlo	%g3, -2
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_float_of_int
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	mvhi	%g3, 65535
	mvlo	%g3, -1
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_float_of_int
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	mvhi	%g3, 0
	mvlo	%g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_float_of_int
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	mvhi	%g3, 0
	mvlo	%g3, 1
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_float_of_int
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	mvhi	%g3, 0
	mvlo	%g3, 2
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_float_of_int
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	mvhi	%g3, 0
	mvlo	%g3, 12
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_float_of_int
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	mvhi	%g3, 0
	mvlo	%g3, 10
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_float_of_int
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.155
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	setL %g3, l.157
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	setL %g3, l.159
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	setL %g3, l.161
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	setL %g3, l.163
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	setL %g3, l.165
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	setL %g3, l.167
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	setL %g3, l.169
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	setL %g3, l.171
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	setL %g3, l.173
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	setL %g3, l.175
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	setL %g3, l.177
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	setL %g3, l.179
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	setL %g3, l.181
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	setL %g3, l.183
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	setL %g3, l.185
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	setL %g3, l.187
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_int_of_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	halt
