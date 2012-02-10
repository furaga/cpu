.init_heap_size	608
FLOAT_ZERO:		! 0.0
	.long 0x0
FLOAT_ONE:		! 1.0
	.long 0x3f800000
FLOAT_MONE:		! -1.0
	.long 0xbf800000
FLOAT_MAGICI:	! 8388608
	.long 0x800000
FLOAT_MAGICF:	! 8388608.0
	.long 0x4b000000
FLOAT_MAGICFHX:	! 1258291200
	.long 0x4b000000
l.1027:	! 12.000000
	.long	0x41400000
l.1022:	! 11.000000
	.long	0x41300000
l.1017:	! 10.000000
	.long	0x41200000
l.1012:	! 9.000000
	.long	0x41100000
l.1007:	! 8.000000
	.long	0x41000000
l.1002:	! 7.000000
	.long	0x40e00000
l.997:	! 6.000000
	.long	0x40c00000
l.992:	! 5.000000
	.long	0x40a00000
l.987:	! 4.000000
	.long	0x40800000
l.982:	! 3.000000
	.long	0x40400000
l.974:	! 1.000000
	.long	0x3f800000
l.967:	! 0.000000
	.long	0x0
l.965:	! 2.000000
	.long	0x40000000
	jmp	min_caml_start

!#####################################################################
!
! 		↓　ここから lib_asm.s
!
!#####################################################################

! * create_array
min_caml_create_array:
	slli %g3, %g3, 2
	add %g5, %g3, %g2
	mov %g3, %g2
CREATE_ARRAY_LOOP:
	jlt %g5, %g2, CREATE_ARRAY_END
	jeq %g5, %g2, CREATE_ARRAY_END
	sti %g4, %g2, 0
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
	jeq %g4, %g2, CREATE_FLOAT_ARRAY_END
	fsti %f0, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_FLOAT_ARRAY_LOOP
CREATE_FLOAT_ARRAY_END:
	return

! * floor		%f0 + MAGICF - MAGICF
min_caml_floor:
	fmov %f1, %f0
	! %f4 = 0.0
	setL %g3, FLOAT_ZERO
	fldi %f4, %g3, 0
	fjlt %f4, %f0, FLOOR_POSITIVE	! if (%f4 <= %f0) goto FLOOR_PISITIVE
	fjeq %f4, %f0, FLOOR_POSITIVE
FLOOR_NEGATIVE:
	fneg %f0, %f0
	setL %g3, FLOAT_MAGICF
	! %f2 = FLOAT_MAGICF
	fldi %f2, %g3, 0
	fjlt %f0, %f2, FLOOR_NEGATIVE_MAIN
	fjeq %f0, %f2, FLOOR_NEGATIVE_MAIN
	fneg %f0, %f0
	return
FLOOR_NEGATIVE_MAIN:
	fadd %f0, %f0, %f2
	fsub %f0, %f0, %f2
	fneg %f1, %f1
	fjlt %f1, %f0, FLOOR_RET2
	fjeq %f1, %f0, FLOOR_RET2
	fadd %f0, %f0, %f2
	! %f3 = 1.0
	setL %g3, FLOAT_ONE
	fldi %f3, %g3, 0
	fadd %f0, %f0, %f3
	fsub %f0, %f0, %f2
	fneg %f0, %f0
	return
FLOOR_POSITIVE:
	setL %g3, FLOAT_MAGICF
	fldi %f2, %g3, 0
	fjlt %f0, %f2, FLOOR_POSITIVE_MAIN
	fjeq %f0, %f2, FLOOR_POSITIVE_MAIN
	return
FLOOR_POSITIVE_MAIN:
	fmov %f1, %f0
	fadd %f0, %f0, %f2
	fsti %f0, %g1, 0
	ldi %g4, %g1, 0
	fsub %f0, %f0, %f2
	fsti %f0, %g1, 0
	ldi %g4, %g1, 0
	fjlt %f0, %f1, FLOOR_RET
	fjeq %f0, %f1, FLOOR_RET
	setL %g3, FLOAT_ONE
	fldi %f3, %g3, 0
	fsub %f0, %f0, %f3
FLOOR_RET:
	return
FLOOR_RET2:
	fneg %f0, %f0
	return
	
min_caml_ceil:
	fneg %f0, %f0
	call min_caml_floor
	fneg %f0, %f0
	return

! * float_of_int
min_caml_float_of_int:
	jlt %g0, %g3, ITOF_MAIN		! if (%g0 <= %g3) goto ITOF_MAIN
	jeq %g0, %g3, ITOF_MAIN
	sub %g3, %g0, %g3
	call ITOF_MAIN
	fneg %f0, %f0
	return
ITOF_MAIN:

	! %f1 <= FLOAT_MAGICF
	! %g4 <= FLOAT_MAGICFHX
	! %g5 <= FLOAT_MAGICI

	setL %g5, FLOAT_MAGICF
	fldi %f1, %g5, 0
	setL %g5, FLOAT_MAGICFHX
	ldi %g4, %g5, 0
	setL %g5, FLOAT_MAGICI
	ldi %g5, %g5, 0
	jlt %g5, %g3, ITOF_BIG
	jeq %g5, %g3, ITOF_BIG
	add %g3, %g3, %g4
	sti %g3, %g1, 0
	fldi %f0, %g1, 0
	fsub %f0, %f0, %f1
	return
ITOF_BIG:
	setL %g4, FLOAT_ZERO
	fldi %f2, %g4, 0
ITOF_LOOP:
	sub %g3, %g3, %g5
	fadd %f2, %f2, %f1
	jlt %g5, %g3, ITOF_LOOP
	jeq %g5, %g3, ITOF_LOOP
	add %g3, %g3, %g4
	sti %g3, %g1, 0
	fldi %f0, %g1, 0
	fsub %f0, %f0, %f1
	fadd %f0, %f0, %f2
	return

! * int_of_float
min_caml_int_of_float:
	! %f1 <= 0.0
	setL %g3, FLOAT_ZERO
	fldi %f1, %g3, 0
	fjlt %f1, %f0, FTOI_MAIN			! if (0.0 <= %f0) goto FTOI_MAIN
	fjeq %f1, %f0, FTOI_MAIN
	fneg %f0, %f0
	call FTOI_MAIN
	sub %g3, %g0, %g3
	return
FTOI_MAIN:
	call min_caml_floor
	! %f2 <= FLOAT_MAGICF
	! %g4 <= FLOAT_MAGICFHX
	setL %g4, FLOAT_MAGICF
	fldi %f2, %g4, 0
	setL %g4, FLOAT_MAGICFHX
	ldi %g4, %g4, 0
	fjlt %f2, %f0, FTOI_BIG		! if (MAGICF <= %f0) goto FTOI_BIG
	fjeq %f2, %f0, FTOI_BIG
	fadd %f0, %f0, %f2
	fsti %f0, %g1, 0
	ldi %g3, %g1, 0
	sub %g3, %g3, %g4
	return
FTOI_BIG:
	setL %g5, FLOAT_MAGICI
	ldi %g5, %g5, 0
	mov %g3, %g0
FTOI_LOOP:
	fsub %f0, %f0, %f2
	add %g3, %g3, %g5
	fjlt %f2, %f0, FTOI_LOOP
	fjeq %f2, %f0, FTOI_LOOP
	fadd %f0, %f0, %f2
	fsti %f0, %g1, 0
	ldi %g5, %g1, 0
	sub %g5, %g5, %g4
	add %g3, %g5, %g3
	return
	
! * truncate
min_caml_truncate:
	jmp min_caml_int_of_float


!#####################################################################
!
! 		↑　ここまで lib_asm.s
!
!#####################################################################
min_caml_start:
	mov	%g31, %g1
	subi	%g1, %g1, 48
	addi	%g28, %g0, 1
	addi	%g29, %g0, -1
	setL %g27, l.967
	fldi	%f16, %g27, 0
	setL %g27, l.997
	fldi	%f17, %g27, 0
	setL %g27, l.992
	fldi	%f18, %g27, 0
	setL %g27, l.987
	fldi	%f19, %g27, 0
	setL %g27, l.982
	fldi	%f20, %g27, 0
	setL %g27, l.974
	fldi	%f21, %g27, 0
	setL %g27, l.965
	fldi	%f22, %g27, 0
	setL %g27, l.1027
	fldi	%f23, %g27, 0
	setL %g27, l.1022
	fldi	%f24, %g27, 0
	setL %g27, l.1017
	fldi	%f25, %g27, 0
	setL %g27, l.1012
	fldi	%f26, %g27, 0
	setL %g27, l.1007
	fldi	%f27, %g27, 0
	setL %g27, l.1002
	fldi	%f28, %g27, 0
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 44
	subi	%g2, %g31, 4
	subi	%g1, %g1, 4
	call	min_caml_create_array
	ldi	%g2, %g31, 44
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 44
	subi	%g2, %g31, 8
	call	min_caml_create_array
	ldi	%g2, %g31, 44
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 44
	subi	%g2, %g31, 12
	call	min_caml_create_array
	ldi	%g2, %g31, 44
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 44
	subi	%g2, %g31, 16
	call	min_caml_create_array
	ldi	%g2, %g31, 44
	addi	%g3, %g0, 1
	addi	%g4, %g0, 1
	sti	%g2, %g31, 44
	subi	%g2, %g31, 20
	call	min_caml_create_array
	ldi	%g2, %g31, 44
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 44
	subi	%g2, %g31, 24
	call	min_caml_create_array
	ldi	%g2, %g31, 44
	addi	%g3, %g0, 0
	sti	%g2, %g31, 44
	subi	%g2, %g31, 28
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 44
	addi	%g6, %g0, 2
	addi	%g8, %g0, 3
	subi	%g4, %g31, 28
	call	make.502
	addi	%g1, %g1, 4
	mov	%g15, %g3
	sti	%g15, %g31, 32
	addi	%g6, %g0, 3
	addi	%g8, %g0, 2
	subi	%g4, %g31, 28
	sti	%g15, %g1, 0
	subi	%g1, %g1, 8
	call	make.502
	addi	%g1, %g1, 8
	mov	%g7, %g3
	sti	%g7, %g31, 36
	addi	%g6, %g0, 2
	addi	%g8, %g0, 2
	subi	%g4, %g31, 28
	sti	%g7, %g1, 4
	subi	%g1, %g1, 12
	call	make.502
	addi	%g1, %g1, 12
	mov	%g14, %g3
	sti	%g14, %g31, 40
	ldi	%g15, %g1, 0
	ldi	%g3, %g15, 0
	fsti	%f21, %g3, 0
	ldi	%g3, %g15, 0
	fsti	%f22, %g3, -4
	ldi	%g3, %g15, 0
	fsti	%f20, %g3, -8
	ldi	%g3, %g15, -4
	fsti	%f19, %g3, 0
	ldi	%g3, %g15, -4
	fsti	%f18, %g3, -4
	ldi	%g3, %g15, -4
	fsti	%f17, %g3, -8
	ldi	%g7, %g1, 4
	ldi	%g3, %g7, 0
	fsti	%f28, %g3, 0
	ldi	%g3, %g7, 0
	fsti	%f27, %g3, -4
	ldi	%g3, %g7, -4
	fsti	%f26, %g3, 0
	ldi	%g3, %g7, -4
	fsti	%f25, %g3, -4
	ldi	%g3, %g7, -8
	fsti	%f24, %g3, 0
	ldi	%g3, %g7, -8
	fsti	%f23, %g3, -4
	addi	%g3, %g0, 2
	addi	%g12, %g0, 3
	addi	%g13, %g0, 2
	mov	%g6, %g14
	mov	%g8, %g15
	subi	%g1, %g1, 12
	call	mul.490
	ldi	%g3, %g14, 0
	fldi	%f0, %g3, 0
	call	min_caml_truncate
	mov	%g8, %g3
	call	print_int.467
	addi	%g1, %g1, 12
	sti	%g3, %g1, 12
	addi	%g3, %g0, 10
	output	%g3
	ldi	%g3, %g1, 12
	ldi	%g3, %g14, 0
	fldi	%f0, %g3, -4
	subi	%g1, %g1, 12
	call	min_caml_truncate
	mov	%g8, %g3
	call	print_int.467
	addi	%g1, %g1, 12
	sti	%g3, %g1, 12
	addi	%g3, %g0, 10
	output	%g3
	ldi	%g3, %g1, 12
	ldi	%g3, %g14, -4
	fldi	%f0, %g3, 0
	subi	%g1, %g1, 12
	call	min_caml_truncate
	mov	%g8, %g3
	call	print_int.467
	addi	%g1, %g1, 12
	sti	%g3, %g1, 12
	addi	%g3, %g0, 10
	output	%g3
	ldi	%g3, %g1, 12
	ldi	%g3, %g14, -4
	fldi	%f0, %g3, -4
	subi	%g1, %g1, 12
	call	min_caml_truncate
	mov	%g8, %g3
	call	print_int.467
	addi	%g1, %g1, 12
	sti	%g3, %g1, 12
	addi	%g3, %g0, 10
	output	%g3
	ldi	%g3, %g1, 12
	halt

!==============================
! args = [%g8, %g7, %g5, %g6]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %f15]
! ret type = Int
!================================
div_binary_search.462:
	add	%g3, %g5, %g6
	srli	%g4, %g3, 1
	mul	%g9, %g4, %g7
	sub	%g3, %g6, %g5
	jlt	%g28, %g3, jle_else.1095
	mov	%g3, %g5
	return
jle_else.1095:
	jlt	%g9, %g8, jle_else.1096
	jne	%g9, %g8, jeq_else.1097
	mov	%g3, %g4
	return
jeq_else.1097:
	mov	%g6, %g4
	jmp	div_binary_search.462
jle_else.1096:
	mov	%g5, %g4
	jmp	div_binary_search.462

!==============================
! args = [%g8]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g11, %g10, %f15, %dummy]
! ret type = Unit
!================================
print_int.467:
	jlt	%g8, %g0, jge_else.1098
	mvhi	%g7, 1525
	mvlo	%g7, 57600
	addi	%g5, %g0, 0
	addi	%g6, %g0, 3
	sti	%g8, %g1, 0
	subi	%g1, %g1, 8
	call	div_binary_search.462
	addi	%g1, %g1, 8
	mvhi	%g4, 1525
	mvlo	%g4, 57600
	mul	%g4, %g3, %g4
	ldi	%g8, %g1, 0
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.1099
	addi	%g10, %g0, 0
	jmp	jle_cont.1100
jle_else.1099:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jle_cont.1100:
	mvhi	%g7, 152
	mvlo	%g7, 38528
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 4
	subi	%g1, %g1, 12
	call	div_binary_search.462
	addi	%g1, %g1, 12
	mvhi	%g4, 152
	mvlo	%g4, 38528
	mul	%g4, %g3, %g4
	ldi	%g8, %g1, 4
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.1101
	jne	%g10, %g0, jeq_else.1103
	addi	%g11, %g0, 0
	jmp	jeq_cont.1104
jeq_else.1103:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jeq_cont.1104:
	jmp	jle_cont.1102
jle_else.1101:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jle_cont.1102:
	mvhi	%g7, 15
	mvlo	%g7, 16960
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 8
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
	mvhi	%g4, 15
	mvlo	%g4, 16960
	mul	%g4, %g3, %g4
	ldi	%g8, %g1, 8
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.1105
	jne	%g11, %g0, jeq_else.1107
	addi	%g10, %g0, 0
	jmp	jeq_cont.1108
jeq_else.1107:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jeq_cont.1108:
	jmp	jle_cont.1106
jle_else.1105:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jle_cont.1106:
	mvhi	%g7, 1
	mvlo	%g7, 34464
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 12
	subi	%g1, %g1, 20
	call	div_binary_search.462
	addi	%g1, %g1, 20
	mvhi	%g4, 1
	mvlo	%g4, 34464
	mul	%g4, %g3, %g4
	ldi	%g8, %g1, 12
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.1109
	jne	%g10, %g0, jeq_else.1111
	addi	%g11, %g0, 0
	jmp	jeq_cont.1112
jeq_else.1111:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jeq_cont.1112:
	jmp	jle_cont.1110
jle_else.1109:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jle_cont.1110:
	addi	%g7, %g0, 10000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 16
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
	addi	%g4, %g0, 10000
	mul	%g4, %g3, %g4
	ldi	%g8, %g1, 16
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.1113
	jne	%g11, %g0, jeq_else.1115
	addi	%g10, %g0, 0
	jmp	jeq_cont.1116
jeq_else.1115:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jeq_cont.1116:
	jmp	jle_cont.1114
jle_else.1113:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jle_cont.1114:
	addi	%g7, %g0, 1000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 20
	subi	%g1, %g1, 28
	call	div_binary_search.462
	addi	%g1, %g1, 28
	muli	%g4, %g3, 1000
	ldi	%g8, %g1, 20
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.1117
	jne	%g10, %g0, jeq_else.1119
	addi	%g11, %g0, 0
	jmp	jeq_cont.1120
jeq_else.1119:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jeq_cont.1120:
	jmp	jle_cont.1118
jle_else.1117:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g11, %g0, 1
jle_cont.1118:
	addi	%g7, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 24
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
	muli	%g4, %g3, 100
	ldi	%g8, %g1, 24
	sub	%g8, %g8, %g4
	jlt	%g0, %g3, jle_else.1121
	jne	%g11, %g0, jeq_else.1123
	addi	%g10, %g0, 0
	jmp	jeq_cont.1124
jeq_else.1123:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jeq_cont.1124:
	jmp	jle_cont.1122
jle_else.1121:
	addi	%g4, %g0, 48
	add	%g3, %g4, %g3
	output	%g3
	addi	%g10, %g0, 1
jle_cont.1122:
	addi	%g7, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	sti	%g8, %g1, 28
	subi	%g1, %g1, 36
	call	div_binary_search.462
	addi	%g1, %g1, 36
	muli	%g4, %g3, 10
	ldi	%g8, %g1, 28
	sub	%g4, %g8, %g4
	jlt	%g0, %g3, jle_else.1125
	jne	%g10, %g0, jeq_else.1127
	addi	%g5, %g0, 0
	jmp	jeq_cont.1128
jeq_else.1127:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g5, %g0, 1
jeq_cont.1128:
	jmp	jle_cont.1126
jle_else.1125:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g5, %g0, 1
jle_cont.1126:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g4
	output	%g3
	return
jge_else.1098:
	addi	%g3, %g0, 45
	output	%g3
	sub	%g8, %g0, %g8
	jmp	print_int.467

!==============================
! args = [%g5, %g3, %g4, %g8, %g7, %g6]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g11, %g10, %f2, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
loop3.469:
	jlt	%g3, %g0, jge_else.1129
	slli	%g9, %g5, 2
	ld	%g11, %g6, %g9
	slli	%g9, %g4, 2
	fld	%f2, %g11, %g9
	slli	%g9, %g5, 2
	ld	%g10, %g8, %g9
	slli	%g9, %g3, 2
	fld	%f1, %g10, %g9
	slli	%g9, %g3, 2
	ld	%g10, %g7, %g9
	slli	%g9, %g4, 2
	fld	%f0, %g10, %g9
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	slli	%g9, %g4, 2
	fst	%f0, %g11, %g9
	subi	%g3, %g3, 1
	jmp	loop3.469
jge_else.1129:
	return

!==============================
! args = [%g5, %g12, %g4, %g8, %g7, %g6]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g12, %g11, %g10, %f2, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
loop2.476:
	jlt	%g4, %g0, jge_else.1131
	subi	%g3, %g12, 1
	sti	%g6, %g1, 0
	sti	%g7, %g1, 4
	sti	%g8, %g1, 8
	sti	%g5, %g1, 12
	sti	%g4, %g1, 16
	subi	%g1, %g1, 24
	call	loop3.469
	addi	%g1, %g1, 24
	ldi	%g4, %g1, 16
	subi	%g4, %g4, 1
	ldi	%g5, %g1, 12
	ldi	%g8, %g1, 8
	ldi	%g7, %g1, 4
	ldi	%g6, %g1, 0
	jmp	loop2.476
jge_else.1131:
	return

!==============================
! args = [%g5, %g12, %g13, %g8, %g7, %g6]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g13, %g12, %g11, %g10, %f2, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
loop1.483:
	jlt	%g5, %g0, jge_else.1133
	subi	%g4, %g13, 1
	sti	%g6, %g1, 0
	sti	%g7, %g1, 4
	sti	%g8, %g1, 8
	sti	%g12, %g1, 12
	sti	%g5, %g1, 16
	subi	%g1, %g1, 24
	call	loop2.476
	addi	%g1, %g1, 24
	ldi	%g5, %g1, 16
	subi	%g5, %g5, 1
	ldi	%g12, %g1, 12
	ldi	%g8, %g1, 8
	ldi	%g7, %g1, 4
	ldi	%g6, %g1, 0
	jmp	loop1.483
jge_else.1133:
	return

!==============================
! args = [%g3, %g12, %g13, %g8, %g7, %g6]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g13, %g12, %g11, %g10, %f2, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
mul.490:
	subi	%g5, %g3, 1
	jmp	loop1.483

!==============================
! args = [%g5, %g3, %g6]
! fargs = []
! use_regs = [%g7, %g6, %g5, %g4, %g3, %g27, %f16, %f15, %f0, %dummy]
! ret type = Unit
!================================
init.498:
	jlt	%g5, %g0, jge_else.1135
	sti	%g3, %g1, 0
	fmov	%f0, %f16
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	mov	%g4, %g3
	slli	%g7, %g5, 2
	st	%g4, %g6, %g7
	subi	%g5, %g5, 1
	ldi	%g3, %g1, 0
	jmp	init.498
jge_else.1135:
	return

!==============================
! args = [%g6, %g8, %g4]
! fargs = []
! use_regs = [%g8, %g7, %g6, %g5, %g4, %g3, %g27, %f16, %f15, %f0, %dummy]
! ret type = Array(Array(Float))
!================================
make.502:
	mov	%g3, %g6
	subi	%g1, %g1, 4
	call	min_caml_create_array
	addi	%g1, %g1, 4
	subi	%g5, %g6, 1
	sti	%g3, %g1, 0
	mov	%g6, %g3
	mov	%g3, %g8
	subi	%g1, %g1, 8
	call	init.498
	addi	%g1, %g1, 8
	ldi	%g3, %g1, 0
	return
