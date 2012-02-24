.init_heap_size	1952
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
l.38551:	! 150.000000
	.long	0x43160000
l.38547:	! -150.000000
	.long	0xc3160000
l.38099:	! -2.000000
	.long	0xc0000000
l.38077:	! 0.003906
	.long	0x3b800000
l.38033:	! 20.000000
	.long	0x41a00000
l.38031:	! 0.050000
	.long	0x3d4cccc4
l.38011:	! 0.250000
	.long	0x3e800000
l.37992:	! 10.000000
	.long	0x41200000
l.37981:	! 0.300000
	.long	0x3e999999
l.37977:	! 0.150000
	.long	0x3e199999
l.37942:	! 3.141593
	.long	0x40490fda
l.37940:	! 30.000000
	.long	0x41f00000
l.37938:	! -1.570796
	.long	0xbfc90fda
l.37933:	! 4.000000
	.long	0x40800000
l.37929:	! 16.000000
	.long	0x41800000
l.37927:	! 11.000000
	.long	0x41300000
l.37925:	! 25.000000
	.long	0x41c80000
l.37923:	! 13.000000
	.long	0x41500000
l.37921:	! 36.000000
	.long	0x42100000
l.37918:	! 49.000000
	.long	0x42440000
l.37916:	! 17.000000
	.long	0x41880000
l.37914:	! 64.000000
	.long	0x42800000
l.37912:	! 19.000000
	.long	0x41980000
l.37910:	! 81.000000
	.long	0x42a20000
l.37908:	! 21.000000
	.long	0x41a80000
l.37906:	! 100.000000
	.long	0x42c80000
l.37904:	! 23.000000
	.long	0x41b80000
l.37902:	! 121.000000
	.long	0x42f20000
l.37898:	! 15.000000
	.long	0x41700000
l.37896:	! 0.000100
	.long	0x38d1b70f
l.37726:	! 100000000.000000
	.long	0x4cbebc20
l.36991:	! -0.100000
	.long	0xbdccccc4
l.36805:	! 0.010000
	.long	0x3c23d70a
l.36803:	! -0.200000
	.long	0xbe4cccc4
l.36354:	! -1.000000
	.long	0xbf800000
l.36040:	! 0.100000
	.long	0x3dccccc4
l.36038:	! 0.900000
	.long	0x3f66665e
l.36036:	! 0.200000
	.long	0x3e4cccc4
l.35972:	! -200.000000
	.long	0xc3480000
l.35969:	! 200.000000
	.long	0x43480000
l.35967:	! 3.000000
	.long	0x40400000
l.35965:	! 5.000000
	.long	0x40a00000
l.35963:	! 9.000000
	.long	0x41100000
l.35961:	! 7.000000
	.long	0x40e00000
l.35959:	! 1.000000
	.long	0x3f800000
l.35957:	! 0.017453
	.long	0x3c8efa2d
l.35852:	! 128.000000
	.long	0x43000000
l.35829:	! 1000000000.000000
	.long	0x4e6e6b28
l.35825:	! 255.000000
	.long	0x437f0000
l.35811:	! 0.000000
	.long	0x0
l.35809:	! 1.570796
	.long	0x3fc90fda
l.35807:	! 0.500000
	.long	0x3f000000
l.35805:	! 6.283185
	.long	0x40c90fda
l.35803:	! 2.000000
	.long	0x40000000
l.35801:	! 3.141593
	.long	0x40490fda
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
	
min_caml_read_int:
	addi %g3, %g0, 0
	! 24 - 31
	input %g4
	add %g3, %g3, %g4
	slli %g3, %g3, 8
	! 16 - 23
	input %g4
	add %g3, %g3, %g4
	slli %g3, %g3, 8
	! 8 - 15
	input %g4
	add %g3, %g3, %g4
	slli %g3, %g3, 8
	! 0 - 7
	input %g4
	add %g3, %g3, %g4
	return

min_caml_read_float:
	call min_caml_read_int
	sti %g3, %g1, 0
	fldi %f0, %g1, 0
	return

!#####################################################################
!
! 		↑　ここまで lib_asm.s
!
!#####################################################################
min_caml_start:
	mov	%g31, %g1
	subi	%g1, %g1, 2368
	addi	%g28, %g0, 1
	addi	%g29, %g0, -1
	setL %g27, l.35811
	fldi	%f16, %g27, 0
	setL %g27, l.35959
	fldi	%f17, %g27, 0
	setL %g27, l.38551
	fldi	%f18, %g27, 0
	setL %g27, l.38547
	fldi	%f19, %g27, 0
	setL %g27, l.36354
	fldi	%f20, %g27, 0
	setL %g27, l.35807
	fldi	%f21, %g27, 0
	setL %g27, l.35809
	fldi	%f22, %g27, 0
	setL %g27, l.35967
	fldi	%f23, %g27, 0
	setL %g27, l.35965
	fldi	%f24, %g27, 0
	setL %g27, l.35963
	fldi	%f25, %g27, 0
	setL %g27, l.35961
	fldi	%f26, %g27, 0
	setL %g27, l.35825
	fldi	%f27, %g27, 0
	setL %g27, l.37898
	fldi	%f28, %g27, 0
	setL %g27, l.35805
	fldi	%f29, %g27, 0
	setL %g27, l.37942
	fldi	%f30, %g27, 0
	setL %g27, l.37938
	fldi	%f31, %g27, 0
	setL %g3, l.35801
	fldi	%f4, %g3, 0
	setL %g3, l.35803
	fldi	%f10, %g3, 0
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 4
	subi	%g1, %g1, 4
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 8
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 12
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 16
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 1
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 20
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 24
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 28
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 32
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g4, %g3
	ldi	%g2, %g31, 2364
	addi	%g6, %g0, 60
	addi	%g10, %g0, 0
	addi	%g9, %g0, 0
	addi	%g8, %g0, 0
	addi	%g7, %g0, 0
	addi	%g5, %g0, 0
	mov	%g3, %g2
	addi	%g2, %g2, 44
	sti	%g4, %g3, -40
	sti	%g4, %g3, -36
	sti	%g4, %g3, -32
	sti	%g4, %g3, -28
	sti	%g5, %g3, -24
	sti	%g4, %g3, -20
	sti	%g4, %g3, -16
	sti	%g7, %g3, -12
	sti	%g8, %g3, -8
	sti	%g9, %g3, -4
	sti	%g10, %g3, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 272
	mov	%g4, %g3
	mov	%g3, %g6
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 284
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 296
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 308
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 312
	fmov	%f0, %f27
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g6, %g0, 50
	addi	%g3, %g0, 1
	addi	%g4, %g0, -1
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 512
	mov	%g3, %g6
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g6, %g0, 1
	addi	%g3, %g0, 1
	ldi	%g4, %g31, 512
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 516
	mov	%g3, %g6
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 520
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 524
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	setL %g4, l.35829
	fldi	%f0, %g4, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 528
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 540
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 544
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 556
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 568
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 580
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 592
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 2
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 600
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 2
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 608
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 612
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 624
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 636
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 648
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 660
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 672
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 684
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 688
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 692
	subi	%g4, %g31, 688
	call	min_caml_create_array
	mov	%g4, %g3
	ldi	%g2, %g31, 2364
	addi	%g6, %g0, 0
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g4, %g3, -4
	sti	%g7, %g3, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 696
	mov	%g4, %g3
	mov	%g3, %g6
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 716
	subi	%g4, %g31, 696
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 720
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 732
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g6, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 60
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 972
	subi	%g4, %g31, 720
	call	min_caml_create_array
	mov	%g4, %g3
	ldi	%g2, %g31, 2364
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 980
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g4, %g3, -4
	sti	%g6, %g3, 0
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 984
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g6, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 988
	subi	%g4, %g31, 984
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 996
	mov	%g4, %g2
	addi	%g2, %g2, 8
	sti	%g3, %g4, -4
	sti	%g6, %g4, 0
	ldi	%g2, %g31, 2364
	addi	%g6, %g0, 180
	addi	%g5, %g0, 0
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fsti	%f16, %g3, -8
	sti	%g4, %g3, -4
	sti	%g5, %g3, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1716
	mov	%g4, %g3
	mov	%g3, %g6
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1720
	call	min_caml_create_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 128
	addi	%g4, %g0, 128
	sti	%g3, %g31, 600
	sti	%g4, %g31, 596
	addi	%g4, %g0, 64
	sti	%g4, %g31, 608
	addi	%g4, %g0, 64
	sti	%g4, %g31, 604
	setL %g4, l.35852
	fldi	%f3, %g4, 0
	call	min_caml_float_of_int
	fdiv	%f0, %f3, %f0
	fsti	%f0, %g31, 612
	ldi	%g12, %g31, 600
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1732
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g11, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1744
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1764
	subi	%g4, %g31, 1744
	call	min_caml_create_array
	mov	%g10, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1760
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1756
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1752
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1748
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1784
	call	min_caml_create_array
	mov	%g9, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1804
	call	min_caml_create_array
	mov	%g8, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1816
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1836
	subi	%g4, %g31, 1816
	call	min_caml_create_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1832
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1828
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1824
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1820
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1848
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1868
	subi	%g4, %g31, 1848
	call	min_caml_create_array
	mov	%g6, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1864
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1860
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1856
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1852
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1872
	call	min_caml_create_array
	mov	%g13, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1884
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1904
	subi	%g4, %g31, 1884
	call	min_caml_create_array
	mov	%g5, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1900
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1896
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1892
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1888
	mov	%g3, %g2
	addi	%g2, %g2, 32
	sti	%g5, %g3, -28
	sti	%g13, %g3, -24
	sti	%g6, %g3, -20
	sti	%g7, %g3, -16
	sti	%g8, %g3, -12
	sti	%g9, %g3, -8
	sti	%g10, %g3, -4
	sti	%g11, %g3, 0
	mov	%g4, %g3
	mov	%g3, %g12
	call	min_caml_create_array
	mov	%g10, %g3
	sti	%g10, %g31, 1908
	ldi	%g3, %g31, 600
	subi	%g9, %g3, 2
	call	init_line_elements.3002
	mov	%g17, %g3
	sti	%g17, %g31, 1912
	ldi	%g12, %g31, 600
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1924
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g11, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1936
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1956
	subi	%g4, %g31, 1936
	call	min_caml_create_array
	mov	%g10, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1952
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1948
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1944
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 1940
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1976
	call	min_caml_create_array
	mov	%g9, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 1996
	call	min_caml_create_array
	mov	%g8, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2008
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2028
	subi	%g4, %g31, 2008
	call	min_caml_create_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2024
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2020
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2016
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2012
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2040
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2060
	subi	%g4, %g31, 2040
	call	min_caml_create_array
	mov	%g6, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2056
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2052
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2048
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2044
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2064
	call	min_caml_create_array
	mov	%g13, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2076
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2096
	subi	%g4, %g31, 2076
	call	min_caml_create_array
	mov	%g5, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2092
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2088
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2084
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2080
	mov	%g3, %g2
	addi	%g2, %g2, 32
	sti	%g5, %g3, -28
	sti	%g13, %g3, -24
	sti	%g6, %g3, -20
	sti	%g7, %g3, -16
	sti	%g8, %g3, -12
	sti	%g9, %g3, -8
	sti	%g10, %g3, -4
	sti	%g11, %g3, 0
	mov	%g4, %g3
	mov	%g3, %g12
	call	min_caml_create_array
	mov	%g10, %g3
	sti	%g10, %g31, 2100
	ldi	%g3, %g31, 600
	subi	%g9, %g3, 2
	call	init_line_elements.3002
	mov	%g16, %g3
	sti	%g16, %g31, 2104
	ldi	%g12, %g31, 600
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2116
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g11, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2128
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2148
	subi	%g4, %g31, 2128
	call	min_caml_create_array
	mov	%g10, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2144
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2140
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2136
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2132
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2168
	call	min_caml_create_array
	mov	%g9, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2188
	call	min_caml_create_array
	mov	%g8, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2200
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2220
	subi	%g4, %g31, 2200
	call	min_caml_create_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2216
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2212
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2208
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2204
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2232
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2252
	subi	%g4, %g31, 2232
	call	min_caml_create_array
	mov	%g6, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2248
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2244
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2240
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2236
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2256
	call	min_caml_create_array
	mov	%g13, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2268
	fmov	%f0, %f16
	call	min_caml_create_float_array
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 5
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2288
	subi	%g4, %g31, 2268
	call	min_caml_create_array
	mov	%g5, %g3
	ldi	%g2, %g31, 2364
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2284
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2280
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2276
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g31, 2272
	mov	%g3, %g2
	addi	%g2, %g2, 32
	sti	%g5, %g3, -28
	sti	%g13, %g3, -24
	sti	%g6, %g3, -20
	sti	%g7, %g3, -16
	sti	%g8, %g3, -12
	sti	%g9, %g3, -8
	sti	%g10, %g3, -4
	sti	%g11, %g3, 0
	mov	%g4, %g3
	mov	%g3, %g12
	call	min_caml_create_array
	mov	%g10, %g3
	sti	%g10, %g31, 2292
	ldi	%g3, %g31, 600
	subi	%g9, %g3, 2
	call	init_line_elements.3002
	addi	%g1, %g1, 4
	mov	%g15, %g3
	sti	%g15, %g31, 2296
	sti	%g17, %g1, 0
	sti	%g15, %g1, 4
	sti	%g16, %g1, 8
	fsti	%f10, %g1, 12
	fsti	%f4, %g1, 16
	subi	%g1, %g1, 24
	call	min_caml_read_float
	fsti	%f0, %g31, 284
	call	min_caml_read_float
	fsti	%f0, %g31, 280
	call	min_caml_read_float
	fsti	%f0, %g31, 276
	call	min_caml_read_float
	addi	%g1, %g1, 24
	setL %g3, l.35957
	fldi	%f7, %g3, 0
	fmul	%f3, %f0, %f7
	fsub	%f2, %f22, %f3
	fjlt	%f2, %f16, fjge_else.42042
	fmov	%f1, %f2
	jmp	fjge_cont.42043
fjge_else.42042:
	fneg	%f1, %f2
fjge_cont.42043:
	fjlt	%f29, %f1, fjge_else.42044
	fjlt	%f1, %f16, fjge_else.42046
	fmov	%f0, %f1
	jmp	fjge_cont.42047
fjge_else.42046:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42048
	fjlt	%f1, %f16, fjge_else.42050
	fmov	%f0, %f1
	jmp	fjge_cont.42051
fjge_else.42050:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42052
	fjlt	%f1, %f16, fjge_else.42054
	fmov	%f0, %f1
	jmp	fjge_cont.42055
fjge_else.42054:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2518
	addi	%g1, %g1, 24
fjge_cont.42055:
	jmp	fjge_cont.42053
fjge_else.42052:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2518
	addi	%g1, %g1, 24
fjge_cont.42053:
fjge_cont.42051:
	jmp	fjge_cont.42049
fjge_else.42048:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42056
	fjlt	%f1, %f16, fjge_else.42058
	fmov	%f0, %f1
	jmp	fjge_cont.42059
fjge_else.42058:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2518
	addi	%g1, %g1, 24
fjge_cont.42059:
	jmp	fjge_cont.42057
fjge_else.42056:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2518
	addi	%g1, %g1, 24
fjge_cont.42057:
fjge_cont.42049:
fjge_cont.42047:
	jmp	fjge_cont.42045
fjge_else.42044:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42060
	fjlt	%f1, %f16, fjge_else.42062
	fmov	%f0, %f1
	jmp	fjge_cont.42063
fjge_else.42062:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42064
	fjlt	%f1, %f16, fjge_else.42066
	fmov	%f0, %f1
	jmp	fjge_cont.42067
fjge_else.42066:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2518
	addi	%g1, %g1, 24
fjge_cont.42067:
	jmp	fjge_cont.42065
fjge_else.42064:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2518
	addi	%g1, %g1, 24
fjge_cont.42065:
fjge_cont.42063:
	jmp	fjge_cont.42061
fjge_else.42060:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42068
	fjlt	%f1, %f16, fjge_else.42070
	fmov	%f0, %f1
	jmp	fjge_cont.42071
fjge_else.42070:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2518
	addi	%g1, %g1, 24
fjge_cont.42071:
	jmp	fjge_cont.42069
fjge_else.42068:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2518
	addi	%g1, %g1, 24
fjge_cont.42069:
fjge_cont.42061:
fjge_cont.42045:
	fldi	%f4, %g1, 16
	fjlt	%f4, %f0, fjge_else.42072
	fjlt	%f16, %f2, fjge_else.42074
	addi	%g3, %g0, 0
	jmp	fjge_cont.42075
fjge_else.42074:
	addi	%g3, %g0, 1
fjge_cont.42075:
	jmp	fjge_cont.42073
fjge_else.42072:
	fjlt	%f16, %f2, fjge_else.42076
	addi	%g3, %g0, 1
	jmp	fjge_cont.42077
fjge_else.42076:
	addi	%g3, %g0, 0
fjge_cont.42077:
fjge_cont.42073:
	fjlt	%f4, %f0, fjge_else.42078
	fmov	%f1, %f0
	jmp	fjge_cont.42079
fjge_else.42078:
	fsub	%f1, %f29, %f0
fjge_cont.42079:
	fjlt	%f22, %f1, fjge_else.42080
	fmov	%f0, %f1
	jmp	fjge_cont.42081
fjge_else.42080:
	fsub	%f0, %f4, %f1
fjge_cont.42081:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fldi	%f10, %g1, 12
	fmul	%f1, %f10, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g3, %g0, jeq_else.42082
	fneg	%f6, %f0
	jmp	jeq_cont.42083
jeq_else.42082:
	fmov	%f6, %f0
jeq_cont.42083:
	fjlt	%f3, %f16, fjge_else.42084
	fmov	%f1, %f3
	jmp	fjge_cont.42085
fjge_else.42084:
	fneg	%f1, %f3
fjge_cont.42085:
	fjlt	%f29, %f1, fjge_else.42086
	fjlt	%f1, %f16, fjge_else.42088
	fmov	%f0, %f1
	jmp	fjge_cont.42089
fjge_else.42088:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42090
	fjlt	%f1, %f16, fjge_else.42092
	fmov	%f0, %f1
	jmp	fjge_cont.42093
fjge_else.42092:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42094
	fjlt	%f1, %f16, fjge_else.42096
	fmov	%f0, %f1
	jmp	fjge_cont.42097
fjge_else.42096:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2518
	addi	%g1, %g1, 24
fjge_cont.42097:
	jmp	fjge_cont.42095
fjge_else.42094:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2518
	addi	%g1, %g1, 24
fjge_cont.42095:
fjge_cont.42093:
	jmp	fjge_cont.42091
fjge_else.42090:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42098
	fjlt	%f1, %f16, fjge_else.42100
	fmov	%f0, %f1
	jmp	fjge_cont.42101
fjge_else.42100:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2518
	addi	%g1, %g1, 24
fjge_cont.42101:
	jmp	fjge_cont.42099
fjge_else.42098:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2518
	addi	%g1, %g1, 24
fjge_cont.42099:
fjge_cont.42091:
fjge_cont.42089:
	jmp	fjge_cont.42087
fjge_else.42086:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42102
	fjlt	%f1, %f16, fjge_else.42104
	fmov	%f0, %f1
	jmp	fjge_cont.42105
fjge_else.42104:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42106
	fjlt	%f1, %f16, fjge_else.42108
	fmov	%f0, %f1
	jmp	fjge_cont.42109
fjge_else.42108:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2518
	addi	%g1, %g1, 24
fjge_cont.42109:
	jmp	fjge_cont.42107
fjge_else.42106:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2518
	addi	%g1, %g1, 24
fjge_cont.42107:
fjge_cont.42105:
	jmp	fjge_cont.42103
fjge_else.42102:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42110
	fjlt	%f1, %f16, fjge_else.42112
	fmov	%f0, %f1
	jmp	fjge_cont.42113
fjge_else.42112:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2518
	addi	%g1, %g1, 24
fjge_cont.42113:
	jmp	fjge_cont.42111
fjge_else.42110:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 24
	call	sin_sub.2518
	addi	%g1, %g1, 24
fjge_cont.42111:
fjge_cont.42103:
fjge_cont.42087:
	fjlt	%f4, %f0, fjge_else.42114
	fjlt	%f16, %f3, fjge_else.42116
	addi	%g3, %g0, 0
	jmp	fjge_cont.42117
fjge_else.42116:
	addi	%g3, %g0, 1
fjge_cont.42117:
	jmp	fjge_cont.42115
fjge_else.42114:
	fjlt	%f16, %f3, fjge_else.42118
	addi	%g3, %g0, 1
	jmp	fjge_cont.42119
fjge_else.42118:
	addi	%g3, %g0, 0
fjge_cont.42119:
fjge_cont.42115:
	fjlt	%f4, %f0, fjge_else.42120
	fmov	%f1, %f0
	jmp	fjge_cont.42121
fjge_else.42120:
	fsub	%f1, %f29, %f0
fjge_cont.42121:
	fjlt	%f22, %f1, fjge_else.42122
	fmov	%f0, %f1
	jmp	fjge_cont.42123
fjge_else.42122:
	fsub	%f0, %f4, %f1
fjge_cont.42123:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f10, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g3, %g0, jeq_else.42124
	fneg	%f5, %f0
	jmp	jeq_cont.42125
jeq_else.42124:
	fmov	%f5, %f0
jeq_cont.42125:
	fsti	%f5, %g1, 20
	fsti	%f6, %g1, 24
	fsti	%f7, %g1, 28
	subi	%g1, %g1, 36
	call	min_caml_read_float
	addi	%g1, %g1, 36
	fldi	%f7, %g1, 28
	fmul	%f3, %f0, %f7
	fsub	%f2, %f22, %f3
	fjlt	%f2, %f16, fjge_else.42126
	fmov	%f1, %f2
	jmp	fjge_cont.42127
fjge_else.42126:
	fneg	%f1, %f2
fjge_cont.42127:
	fjlt	%f29, %f1, fjge_else.42128
	fjlt	%f1, %f16, fjge_else.42130
	fmov	%f0, %f1
	jmp	fjge_cont.42131
fjge_else.42130:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42132
	fjlt	%f1, %f16, fjge_else.42134
	fmov	%f0, %f1
	jmp	fjge_cont.42135
fjge_else.42134:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42136
	fjlt	%f1, %f16, fjge_else.42138
	fmov	%f0, %f1
	jmp	fjge_cont.42139
fjge_else.42138:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42139:
	jmp	fjge_cont.42137
fjge_else.42136:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42137:
fjge_cont.42135:
	jmp	fjge_cont.42133
fjge_else.42132:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42140
	fjlt	%f1, %f16, fjge_else.42142
	fmov	%f0, %f1
	jmp	fjge_cont.42143
fjge_else.42142:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42143:
	jmp	fjge_cont.42141
fjge_else.42140:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42141:
fjge_cont.42133:
fjge_cont.42131:
	jmp	fjge_cont.42129
fjge_else.42128:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42144
	fjlt	%f1, %f16, fjge_else.42146
	fmov	%f0, %f1
	jmp	fjge_cont.42147
fjge_else.42146:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42148
	fjlt	%f1, %f16, fjge_else.42150
	fmov	%f0, %f1
	jmp	fjge_cont.42151
fjge_else.42150:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42151:
	jmp	fjge_cont.42149
fjge_else.42148:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42149:
fjge_cont.42147:
	jmp	fjge_cont.42145
fjge_else.42144:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42152
	fjlt	%f1, %f16, fjge_else.42154
	fmov	%f0, %f1
	jmp	fjge_cont.42155
fjge_else.42154:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42155:
	jmp	fjge_cont.42153
fjge_else.42152:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42153:
fjge_cont.42145:
fjge_cont.42129:
	fldi	%f4, %g1, 16
	fjlt	%f4, %f0, fjge_else.42156
	fjlt	%f16, %f2, fjge_else.42158
	addi	%g3, %g0, 0
	jmp	fjge_cont.42159
fjge_else.42158:
	addi	%g3, %g0, 1
fjge_cont.42159:
	jmp	fjge_cont.42157
fjge_else.42156:
	fjlt	%f16, %f2, fjge_else.42160
	addi	%g3, %g0, 1
	jmp	fjge_cont.42161
fjge_else.42160:
	addi	%g3, %g0, 0
fjge_cont.42161:
fjge_cont.42157:
	fjlt	%f4, %f0, fjge_else.42162
	fmov	%f1, %f0
	jmp	fjge_cont.42163
fjge_else.42162:
	fsub	%f1, %f29, %f0
fjge_cont.42163:
	fjlt	%f22, %f1, fjge_else.42164
	fmov	%f0, %f1
	jmp	fjge_cont.42165
fjge_else.42164:
	fsub	%f0, %f4, %f1
fjge_cont.42165:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fldi	%f10, %g1, 12
	fmul	%f1, %f10, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g3, %g0, jeq_else.42166
	fneg	%f2, %f0
	jmp	jeq_cont.42167
jeq_else.42166:
	fmov	%f2, %f0
jeq_cont.42167:
	fjlt	%f3, %f16, fjge_else.42168
	fmov	%f1, %f3
	jmp	fjge_cont.42169
fjge_else.42168:
	fneg	%f1, %f3
fjge_cont.42169:
	fjlt	%f29, %f1, fjge_else.42170
	fjlt	%f1, %f16, fjge_else.42172
	fmov	%f0, %f1
	jmp	fjge_cont.42173
fjge_else.42172:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42174
	fjlt	%f1, %f16, fjge_else.42176
	fmov	%f0, %f1
	jmp	fjge_cont.42177
fjge_else.42176:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42178
	fjlt	%f1, %f16, fjge_else.42180
	fmov	%f0, %f1
	jmp	fjge_cont.42181
fjge_else.42180:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42181:
	jmp	fjge_cont.42179
fjge_else.42178:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42179:
fjge_cont.42177:
	jmp	fjge_cont.42175
fjge_else.42174:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42182
	fjlt	%f1, %f16, fjge_else.42184
	fmov	%f0, %f1
	jmp	fjge_cont.42185
fjge_else.42184:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42185:
	jmp	fjge_cont.42183
fjge_else.42182:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42183:
fjge_cont.42175:
fjge_cont.42173:
	jmp	fjge_cont.42171
fjge_else.42170:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42186
	fjlt	%f1, %f16, fjge_else.42188
	fmov	%f0, %f1
	jmp	fjge_cont.42189
fjge_else.42188:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42190
	fjlt	%f1, %f16, fjge_else.42192
	fmov	%f0, %f1
	jmp	fjge_cont.42193
fjge_else.42192:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42193:
	jmp	fjge_cont.42191
fjge_else.42190:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42191:
fjge_cont.42189:
	jmp	fjge_cont.42187
fjge_else.42186:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42194
	fjlt	%f1, %f16, fjge_else.42196
	fmov	%f0, %f1
	jmp	fjge_cont.42197
fjge_else.42196:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42197:
	jmp	fjge_cont.42195
fjge_else.42194:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42195:
fjge_cont.42187:
fjge_cont.42171:
	fjlt	%f4, %f0, fjge_else.42198
	fjlt	%f16, %f3, fjge_else.42200
	addi	%g3, %g0, 0
	jmp	fjge_cont.42201
fjge_else.42200:
	addi	%g3, %g0, 1
fjge_cont.42201:
	jmp	fjge_cont.42199
fjge_else.42198:
	fjlt	%f16, %f3, fjge_else.42202
	addi	%g3, %g0, 1
	jmp	fjge_cont.42203
fjge_else.42202:
	addi	%g3, %g0, 0
fjge_cont.42203:
fjge_cont.42199:
	fjlt	%f4, %f0, fjge_else.42204
	fmov	%f1, %f0
	jmp	fjge_cont.42205
fjge_else.42204:
	fsub	%f1, %f29, %f0
fjge_cont.42205:
	fjlt	%f22, %f1, fjge_else.42206
	fmov	%f0, %f1
	jmp	fjge_cont.42207
fjge_else.42206:
	fsub	%f0, %f4, %f1
fjge_cont.42207:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f3, %f0, %f25
	fsub	%f3, %f26, %f3
	fdiv	%f3, %f0, %f3
	fsub	%f3, %f24, %f3
	fdiv	%f3, %f0, %f3
	fsub	%f3, %f23, %f3
	fdiv	%f0, %f0, %f3
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f10, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f1, %f0
	jne	%g3, %g0, jeq_else.42208
	fneg	%f0, %f1
	jmp	jeq_cont.42209
jeq_else.42208:
	fmov	%f0, %f1
jeq_cont.42209:
	fldi	%f6, %g1, 24
	fmul	%f3, %f6, %f0
	setL %g3, l.35969
	fldi	%f1, %g3, 0
	fmul	%f3, %f3, %f1
	fsti	%f3, %g31, 672
	setL %g3, l.35972
	fldi	%f3, %g3, 0
	fldi	%f5, %g1, 20
	fmul	%f3, %f5, %f3
	fsti	%f3, %g31, 668
	fmul	%f3, %f6, %f2
	fmul	%f1, %f3, %f1
	fsti	%f1, %g31, 664
	fsti	%f2, %g31, 648
	fsti	%f16, %g31, 644
	fneg	%f1, %f0
	fsti	%f1, %g31, 640
	fneg	%f1, %f5
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 660
	fneg	%f6, %f6
	fsti	%f6, %g31, 656
	fmul	%f0, %f1, %f2
	fsti	%f0, %g31, 652
	fldi	%f1, %g31, 284
	fldi	%f0, %g31, 672
	fsub	%f0, %f1, %f0
	fsti	%f0, %g31, 296
	fldi	%f1, %g31, 280
	fldi	%f0, %g31, 668
	fsub	%f0, %f1, %f0
	fsti	%f0, %g31, 292
	fldi	%f1, %g31, 276
	fldi	%f0, %g31, 664
	fsub	%f0, %f1, %f0
	fsti	%f0, %g31, 288
	subi	%g1, %g1, 36
	call	min_caml_read_int
	call	min_caml_read_float
	addi	%g1, %g1, 36
	fldi	%f7, %g1, 28
	fmul	%f2, %f0, %f7
	fjlt	%f2, %f16, fjge_else.42210
	fmov	%f1, %f2
	jmp	fjge_cont.42211
fjge_else.42210:
	fneg	%f1, %f2
fjge_cont.42211:
	fjlt	%f29, %f1, fjge_else.42212
	fjlt	%f1, %f16, fjge_else.42214
	fmov	%f0, %f1
	jmp	fjge_cont.42215
fjge_else.42214:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42216
	fjlt	%f1, %f16, fjge_else.42218
	fmov	%f0, %f1
	jmp	fjge_cont.42219
fjge_else.42218:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42220
	fjlt	%f1, %f16, fjge_else.42222
	fmov	%f0, %f1
	jmp	fjge_cont.42223
fjge_else.42222:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42223:
	jmp	fjge_cont.42221
fjge_else.42220:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42221:
fjge_cont.42219:
	jmp	fjge_cont.42217
fjge_else.42216:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42224
	fjlt	%f1, %f16, fjge_else.42226
	fmov	%f0, %f1
	jmp	fjge_cont.42227
fjge_else.42226:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42227:
	jmp	fjge_cont.42225
fjge_else.42224:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42225:
fjge_cont.42217:
fjge_cont.42215:
	jmp	fjge_cont.42213
fjge_else.42212:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42228
	fjlt	%f1, %f16, fjge_else.42230
	fmov	%f0, %f1
	jmp	fjge_cont.42231
fjge_else.42230:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42232
	fjlt	%f1, %f16, fjge_else.42234
	fmov	%f0, %f1
	jmp	fjge_cont.42235
fjge_else.42234:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42235:
	jmp	fjge_cont.42233
fjge_else.42232:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42233:
fjge_cont.42231:
	jmp	fjge_cont.42229
fjge_else.42228:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42236
	fjlt	%f1, %f16, fjge_else.42238
	fmov	%f0, %f1
	jmp	fjge_cont.42239
fjge_else.42238:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42239:
	jmp	fjge_cont.42237
fjge_else.42236:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 36
	call	sin_sub.2518
	addi	%g1, %g1, 36
fjge_cont.42237:
fjge_cont.42229:
fjge_cont.42213:
	fldi	%f4, %g1, 16
	fjlt	%f4, %f0, fjge_else.42240
	fjlt	%f16, %f2, fjge_else.42242
	addi	%g3, %g0, 0
	jmp	fjge_cont.42243
fjge_else.42242:
	addi	%g3, %g0, 1
fjge_cont.42243:
	jmp	fjge_cont.42241
fjge_else.42240:
	fjlt	%f16, %f2, fjge_else.42244
	addi	%g3, %g0, 1
	jmp	fjge_cont.42245
fjge_else.42244:
	addi	%g3, %g0, 0
fjge_cont.42245:
fjge_cont.42241:
	fjlt	%f4, %f0, fjge_else.42246
	fmov	%f1, %f0
	jmp	fjge_cont.42247
fjge_else.42246:
	fsub	%f1, %f29, %f0
fjge_cont.42247:
	fjlt	%f22, %f1, fjge_else.42248
	fmov	%f0, %f1
	jmp	fjge_cont.42249
fjge_else.42248:
	fsub	%f0, %f4, %f1
fjge_cont.42249:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f3, %f0, %f25
	fsub	%f3, %f26, %f3
	fdiv	%f3, %f0, %f3
	fsub	%f3, %f24, %f3
	fdiv	%f3, %f0, %f3
	fsub	%f3, %f23, %f3
	fdiv	%f0, %f0, %f3
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fldi	%f10, %g1, 12
	fmul	%f1, %f10, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f1, %f0
	jne	%g3, %g0, jeq_else.42250
	fneg	%f0, %f1
	jmp	jeq_cont.42251
jeq_else.42250:
	fmov	%f0, %f1
jeq_cont.42251:
	fneg	%f0, %f0
	fsti	%f0, %g31, 304
	fsti	%f2, %g1, 32
	subi	%g1, %g1, 40
	call	min_caml_read_float
	addi	%g1, %g1, 40
	fldi	%f7, %g1, 28
	fmul	%f3, %f0, %f7
	fldi	%f2, %g1, 32
	fsub	%f2, %f22, %f2
	fjlt	%f2, %f16, fjge_else.42252
	fmov	%f1, %f2
	jmp	fjge_cont.42253
fjge_else.42252:
	fneg	%f1, %f2
fjge_cont.42253:
	fjlt	%f29, %f1, fjge_else.42254
	fjlt	%f1, %f16, fjge_else.42256
	fmov	%f0, %f1
	jmp	fjge_cont.42257
fjge_else.42256:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42258
	fjlt	%f1, %f16, fjge_else.42260
	fmov	%f0, %f1
	jmp	fjge_cont.42261
fjge_else.42260:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42262
	fjlt	%f1, %f16, fjge_else.42264
	fmov	%f0, %f1
	jmp	fjge_cont.42265
fjge_else.42264:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42265:
	jmp	fjge_cont.42263
fjge_else.42262:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42263:
fjge_cont.42261:
	jmp	fjge_cont.42259
fjge_else.42258:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42266
	fjlt	%f1, %f16, fjge_else.42268
	fmov	%f0, %f1
	jmp	fjge_cont.42269
fjge_else.42268:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42269:
	jmp	fjge_cont.42267
fjge_else.42266:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42267:
fjge_cont.42259:
fjge_cont.42257:
	jmp	fjge_cont.42255
fjge_else.42254:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42270
	fjlt	%f1, %f16, fjge_else.42272
	fmov	%f0, %f1
	jmp	fjge_cont.42273
fjge_else.42272:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42274
	fjlt	%f1, %f16, fjge_else.42276
	fmov	%f0, %f1
	jmp	fjge_cont.42277
fjge_else.42276:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42277:
	jmp	fjge_cont.42275
fjge_else.42274:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42275:
fjge_cont.42273:
	jmp	fjge_cont.42271
fjge_else.42270:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42278
	fjlt	%f1, %f16, fjge_else.42280
	fmov	%f0, %f1
	jmp	fjge_cont.42281
fjge_else.42280:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42281:
	jmp	fjge_cont.42279
fjge_else.42278:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42279:
fjge_cont.42271:
fjge_cont.42255:
	fldi	%f4, %g1, 16
	fjlt	%f4, %f0, fjge_else.42282
	fjlt	%f16, %f2, fjge_else.42284
	addi	%g3, %g0, 0
	jmp	fjge_cont.42285
fjge_else.42284:
	addi	%g3, %g0, 1
fjge_cont.42285:
	jmp	fjge_cont.42283
fjge_else.42282:
	fjlt	%f16, %f2, fjge_else.42286
	addi	%g3, %g0, 1
	jmp	fjge_cont.42287
fjge_else.42286:
	addi	%g3, %g0, 0
fjge_cont.42287:
fjge_cont.42283:
	fjlt	%f4, %f0, fjge_else.42288
	fmov	%f1, %f0
	jmp	fjge_cont.42289
fjge_else.42288:
	fsub	%f1, %f29, %f0
fjge_cont.42289:
	fjlt	%f22, %f1, fjge_else.42290
	fmov	%f0, %f1
	jmp	fjge_cont.42291
fjge_else.42290:
	fsub	%f0, %f4, %f1
fjge_cont.42291:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fldi	%f10, %g1, 12
	fmul	%f1, %f10, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g3, %g0, jeq_else.42292
	fneg	%f5, %f0
	jmp	jeq_cont.42293
jeq_else.42292:
	fmov	%f5, %f0
jeq_cont.42293:
	fjlt	%f3, %f16, fjge_else.42294
	fmov	%f1, %f3
	jmp	fjge_cont.42295
fjge_else.42294:
	fneg	%f1, %f3
fjge_cont.42295:
	fjlt	%f29, %f1, fjge_else.42296
	fjlt	%f1, %f16, fjge_else.42298
	fmov	%f0, %f1
	jmp	fjge_cont.42299
fjge_else.42298:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42300
	fjlt	%f1, %f16, fjge_else.42302
	fmov	%f0, %f1
	jmp	fjge_cont.42303
fjge_else.42302:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42304
	fjlt	%f1, %f16, fjge_else.42306
	fmov	%f0, %f1
	jmp	fjge_cont.42307
fjge_else.42306:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42307:
	jmp	fjge_cont.42305
fjge_else.42304:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42305:
fjge_cont.42303:
	jmp	fjge_cont.42301
fjge_else.42300:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42308
	fjlt	%f1, %f16, fjge_else.42310
	fmov	%f0, %f1
	jmp	fjge_cont.42311
fjge_else.42310:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42311:
	jmp	fjge_cont.42309
fjge_else.42308:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42309:
fjge_cont.42301:
fjge_cont.42299:
	jmp	fjge_cont.42297
fjge_else.42296:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42312
	fjlt	%f1, %f16, fjge_else.42314
	fmov	%f0, %f1
	jmp	fjge_cont.42315
fjge_else.42314:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42316
	fjlt	%f1, %f16, fjge_else.42318
	fmov	%f0, %f1
	jmp	fjge_cont.42319
fjge_else.42318:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42319:
	jmp	fjge_cont.42317
fjge_else.42316:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42317:
fjge_cont.42315:
	jmp	fjge_cont.42313
fjge_else.42312:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42320
	fjlt	%f1, %f16, fjge_else.42322
	fmov	%f0, %f1
	jmp	fjge_cont.42323
fjge_else.42322:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42323:
	jmp	fjge_cont.42321
fjge_else.42320:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42321:
fjge_cont.42313:
fjge_cont.42297:
	fjlt	%f4, %f0, fjge_else.42324
	fjlt	%f16, %f3, fjge_else.42326
	addi	%g3, %g0, 0
	jmp	fjge_cont.42327
fjge_else.42326:
	addi	%g3, %g0, 1
fjge_cont.42327:
	jmp	fjge_cont.42325
fjge_else.42324:
	fjlt	%f16, %f3, fjge_else.42328
	addi	%g3, %g0, 1
	jmp	fjge_cont.42329
fjge_else.42328:
	addi	%g3, %g0, 0
fjge_cont.42329:
fjge_cont.42325:
	fjlt	%f4, %f0, fjge_else.42330
	fmov	%f1, %f0
	jmp	fjge_cont.42331
fjge_else.42330:
	fsub	%f1, %f29, %f0
fjge_cont.42331:
	fjlt	%f22, %f1, fjge_else.42332
	fmov	%f0, %f1
	jmp	fjge_cont.42333
fjge_else.42332:
	fsub	%f0, %f4, %f1
fjge_cont.42333:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f10, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f1, %f0
	jne	%g3, %g0, jeq_else.42334
	fneg	%f0, %f1
	jmp	jeq_cont.42335
jeq_else.42334:
	fmov	%f0, %f1
jeq_cont.42335:
	fmul	%f0, %f5, %f0
	fsti	%f0, %g31, 308
	fsub	%f2, %f22, %f3
	fjlt	%f2, %f16, fjge_else.42336
	fmov	%f1, %f2
	jmp	fjge_cont.42337
fjge_else.42336:
	fneg	%f1, %f2
fjge_cont.42337:
	fjlt	%f29, %f1, fjge_else.42338
	fjlt	%f1, %f16, fjge_else.42340
	fmov	%f0, %f1
	jmp	fjge_cont.42341
fjge_else.42340:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42342
	fjlt	%f1, %f16, fjge_else.42344
	fmov	%f0, %f1
	jmp	fjge_cont.42345
fjge_else.42344:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42346
	fjlt	%f1, %f16, fjge_else.42348
	fmov	%f0, %f1
	jmp	fjge_cont.42349
fjge_else.42348:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42349:
	jmp	fjge_cont.42347
fjge_else.42346:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42347:
fjge_cont.42345:
	jmp	fjge_cont.42343
fjge_else.42342:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42350
	fjlt	%f1, %f16, fjge_else.42352
	fmov	%f0, %f1
	jmp	fjge_cont.42353
fjge_else.42352:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42353:
	jmp	fjge_cont.42351
fjge_else.42350:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42351:
fjge_cont.42343:
fjge_cont.42341:
	jmp	fjge_cont.42339
fjge_else.42338:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42354
	fjlt	%f1, %f16, fjge_else.42356
	fmov	%f0, %f1
	jmp	fjge_cont.42357
fjge_else.42356:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42358
	fjlt	%f1, %f16, fjge_else.42360
	fmov	%f0, %f1
	jmp	fjge_cont.42361
fjge_else.42360:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42361:
	jmp	fjge_cont.42359
fjge_else.42358:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42359:
fjge_cont.42357:
	jmp	fjge_cont.42355
fjge_else.42354:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42362
	fjlt	%f1, %f16, fjge_else.42364
	fmov	%f0, %f1
	jmp	fjge_cont.42365
fjge_else.42364:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42365:
	jmp	fjge_cont.42363
fjge_else.42362:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 40
	call	sin_sub.2518
	addi	%g1, %g1, 40
fjge_cont.42363:
fjge_cont.42355:
fjge_cont.42339:
	fjlt	%f4, %f0, fjge_else.42366
	fjlt	%f16, %f2, fjge_else.42368
	addi	%g3, %g0, 0
	jmp	fjge_cont.42369
fjge_else.42368:
	addi	%g3, %g0, 1
fjge_cont.42369:
	jmp	fjge_cont.42367
fjge_else.42366:
	fjlt	%f16, %f2, fjge_else.42370
	addi	%g3, %g0, 1
	jmp	fjge_cont.42371
fjge_else.42370:
	addi	%g3, %g0, 0
fjge_cont.42371:
fjge_cont.42367:
	fjlt	%f4, %f0, fjge_else.42372
	fmov	%f1, %f0
	jmp	fjge_cont.42373
fjge_else.42372:
	fsub	%f1, %f29, %f0
fjge_cont.42373:
	fjlt	%f22, %f1, fjge_else.42374
	fmov	%f0, %f1
	jmp	fjge_cont.42375
fjge_else.42374:
	fsub	%f0, %f4, %f1
fjge_cont.42375:
	fmul	%f0, %f0, %f21
	fmul	%f2, %f0, %f0
	fdiv	%f1, %f2, %f25
	fsub	%f1, %f26, %f1
	fdiv	%f1, %f2, %f1
	fsub	%f1, %f24, %f1
	fdiv	%f1, %f2, %f1
	fsub	%f1, %f23, %f1
	fdiv	%f1, %f2, %f1
	fsub	%f1, %f17, %f1
	fdiv	%f0, %f0, %f1
	fmul	%f1, %f10, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f1, %f0
	jne	%g3, %g0, jeq_else.42376
	fneg	%f0, %f1
	jmp	jeq_cont.42377
jeq_else.42376:
	fmov	%f0, %f1
jeq_cont.42377:
	fmul	%f0, %f5, %f0
	fsti	%f0, %g31, 300
	subi	%g1, %g1, 40
	call	min_caml_read_float
	fsti	%f0, %g31, 312
	addi	%g8, %g0, 0
	call	read_object.2713
	addi	%g3, %g0, 0
	call	read_and_network.2721
	addi	%g4, %g0, 0
	call	read_or_network.2719
	sti	%g3, %g31, 516
	addi	%g3, %g0, 80
	output	%g3
	addi	%g3, %g0, 54
	output	%g3
	addi	%g3, %g0, 10
	output	%g3
	ldi	%g4, %g31, 600
	call	print_int.2545
	addi	%g3, %g0, 32
	output	%g3
	ldi	%g4, %g31, 596
	call	print_int.2545
	addi	%g3, %g0, 32
	output	%g3
	addi	%g4, %g0, 255
	call	print_int.2545
	addi	%g3, %g0, 10
	output	%g3
	addi	%g6, %g0, 120
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2308
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2364
	ldi	%g3, %g31, 28
	subi	%g4, %g31, 2308
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g4, %g31, 2312
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g4, %g3, -4
	sti	%g7, %g3, 0
	mov	%g4, %g3
	mov	%g3, %g6
	call	min_caml_create_array
	sti	%g3, %g31, 700
	ldi	%g6, %g31, 700
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2324
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2364
	ldi	%g3, %g31, 28
	subi	%g4, %g31, 2324
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g4, %g31, 2328
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g4, %g3, -4
	sti	%g7, %g3, 0
	sti	%g3, %g6, -472
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2340
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2364
	ldi	%g3, %g31, 28
	subi	%g4, %g31, 2340
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g4, %g31, 2344
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g4, %g3, -4
	sti	%g7, %g3, 0
	sti	%g3, %g6, -468
	addi	%g3, %g0, 3
	sti	%g2, %g31, 2364
	subi	%g2, %g31, 2356
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g7, %g3
	ldi	%g2, %g31, 2364
	ldi	%g3, %g31, 28
	subi	%g4, %g31, 2356
	call	min_caml_create_array
	mov	%g4, %g3
	sti	%g4, %g31, 2360
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g4, %g3, -4
	sti	%g7, %g3, 0
	sti	%g3, %g6, -464
	addi	%g7, %g0, 115
	call	create_dirvec_elements.3029
	addi	%g8, %g0, 3
	call	create_dirvecs.3032
	addi	%g3, %g0, 9
	addi	%g8, %g0, 0
	addi	%g12, %g0, 0
	call	min_caml_float_of_int
	addi	%g1, %g1, 40
	setL %g3, l.36036
	fldi	%f4, %g3, 0
	fmul	%f0, %f0, %f4
	setL %g3, l.36038
	fldi	%f3, %g3, 0
	fsub	%f0, %f0, %f3
	addi	%g3, %g0, 4
	fsti	%f0, %g1, 36
	subi	%g1, %g1, 44
	call	min_caml_float_of_int
	addi	%g1, %g1, 44
	fmov	%f1, %f0
	fmul	%f1, %f1, %f4
	fsub	%f2, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 36
	fsti	%f3, %g1, 40
	fsti	%f4, %g1, 44
	fsti	%f1, %g1, 48
	mov	%g3, %g12
	mov	%g5, %g8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 56
	call	calc_dirvec.3010
	addi	%g1, %g1, 56
	setL %g3, l.36040
	fldi	%f5, %g3, 0
	fldi	%f1, %g1, 48
	fadd	%f2, %f1, %f5
	addi	%g4, %g0, 0
	addi	%g3, %g0, 2
	fldi	%f0, %g1, 36
	fsti	%f5, %g1, 52
	mov	%g5, %g8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 60
	call	calc_dirvec.3010
	addi	%g1, %g1, 60
	addi	%g3, %g0, 3
	addi	%g5, %g0, 1
	sti	%g5, %g1, 56
	subi	%g1, %g1, 64
	call	min_caml_float_of_int
	addi	%g1, %g1, 64
	fmov	%f1, %f0
	fldi	%f4, %g1, 44
	fmul	%f1, %f1, %f4
	fldi	%f3, %g1, 40
	fsub	%f2, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 36
	ldi	%g5, %g1, 56
	fsti	%f1, %g1, 60
	mov	%g3, %g12
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 68
	call	calc_dirvec.3010
	addi	%g1, %g1, 68
	fldi	%f5, %g1, 52
	fldi	%f1, %g1, 60
	fadd	%f2, %f1, %f5
	addi	%g4, %g0, 0
	addi	%g8, %g0, 2
	fldi	%f0, %g1, 36
	ldi	%g5, %g1, 56
	mov	%g3, %g8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 68
	call	calc_dirvec.3010
	addi	%g1, %g1, 68
	addi	%g3, %g0, 2
	addi	%g5, %g0, 2
	sti	%g5, %g1, 64
	subi	%g1, %g1, 72
	call	min_caml_float_of_int
	addi	%g1, %g1, 72
	fmov	%f1, %f0
	fldi	%f4, %g1, 44
	fmul	%f1, %f1, %f4
	fldi	%f3, %g1, 40
	fsub	%f2, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 36
	ldi	%g5, %g1, 64
	fsti	%f1, %g1, 68
	mov	%g3, %g12
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 76
	call	calc_dirvec.3010
	addi	%g1, %g1, 76
	fldi	%f5, %g1, 52
	fldi	%f1, %g1, 68
	fadd	%f2, %f1, %f5
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 36
	ldi	%g5, %g1, 64
	mov	%g3, %g8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 76
	call	calc_dirvec.3010
	addi	%g1, %g1, 76
	addi	%g10, %g0, 1
	addi	%g9, %g0, 3
	fldi	%f0, %g1, 36
	mov	%g8, %g12
	subi	%g1, %g1, 76
	call	calc_dirvecs.3018
	addi	%g13, %g0, 8
	addi	%g12, %g0, 2
	addi	%g8, %g0, 4
	call	calc_dirvec_rows.3023
	ldi	%g11, %g31, 700
	ldi	%g3, %g11, -476
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -472
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -468
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -464
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -460
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -456
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -452
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	addi	%g12, %g0, 112
	call	init_dirvec_constants.3034
	addi	%g13, %g0, 3
	call	init_vecset_constants.3037
	fldi	%f0, %g31, 308
	fsti	%f0, %g31, 732
	fldi	%f0, %g31, 304
	fsti	%f0, %g31, 728
	fldi	%f0, %g31, 300
	fsti	%f0, %g31, 724
	ldi	%g3, %g31, 28
	subi	%g5, %g3, 1
	subi	%g7, %g31, 732
	subi	%g6, %g31, 972
	call	iter_setup_dirvec_constants.2818
	addi	%g1, %g1, 76
	ldi	%g3, %g31, 28
	subi	%g6, %g3, 1
	jlt	%g6, %g0, jge_else.42378
	slli	%g3, %g6, 2
	add	%g3, %g31, %g3
	ldi	%g3, %g3, 272
	ldi	%g4, %g3, -8
	addi	%g5, %g0, 2
	jne	%g4, %g5, jeq_else.42380
	ldi	%g4, %g3, -28
	fldi	%f0, %g4, 0
	fjlt	%f0, %f17, fjge_else.42382
	jmp	fjge_cont.42383
fjge_else.42382:
	ldi	%g5, %g3, -4
	jne	%g5, %g28, jeq_else.42384
	slli	%g11, %g6, 2
	ldi	%g12, %g31, 1720
	fldi	%f0, %g4, 0
	fsub	%f12, %f17, %f0
	fldi	%f1, %g31, 308
	fneg	%f11, %f1
	fldi	%f10, %g31, 304
	fneg	%f10, %f10
	fldi	%f9, %g31, 300
	fneg	%f9, %f9
	addi	%g14, %g11, 1
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 76
	call	min_caml_create_float_array
	addi	%g1, %g1, 76
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 72
	subi	%g1, %g1, 80
	call	min_caml_create_array
	addi	%g1, %g1, 80
	mov	%g5, %g2
	addi	%g2, %g2, 8
	sti	%g3, %g5, -4
	ldi	%g4, %g1, 72
	sti	%g4, %g5, 0
	fsti	%f1, %g4, 0
	fsti	%f10, %g4, -4
	fsti	%f9, %g4, -8
	ldi	%g6, %g31, 28
	subi	%g13, %g6, 1
	sti	%g5, %g1, 76
	mov	%g5, %g13
	mov	%g6, %g3
	mov	%g7, %g4
	subi	%g1, %g1, 84
	call	iter_setup_dirvec_constants.2818
	addi	%g1, %g1, 84
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fsti	%f12, %g3, -8
	ldi	%g5, %g1, 76
	sti	%g5, %g3, -4
	sti	%g14, %g3, 0
	slli	%g4, %g12, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 1716
	addi	%g18, %g12, 1
	addi	%g14, %g11, 2
	fldi	%f1, %g31, 304
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 84
	call	min_caml_create_float_array
	addi	%g1, %g1, 84
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 80
	subi	%g1, %g1, 88
	call	min_caml_create_array
	addi	%g1, %g1, 88
	mov	%g5, %g2
	addi	%g2, %g2, 8
	sti	%g3, %g5, -4
	ldi	%g4, %g1, 80
	sti	%g4, %g5, 0
	fsti	%f11, %g4, 0
	fsti	%f1, %g4, -4
	fsti	%f9, %g4, -8
	ldi	%g6, %g31, 28
	subi	%g13, %g6, 1
	sti	%g5, %g1, 84
	mov	%g5, %g13
	mov	%g6, %g3
	mov	%g7, %g4
	subi	%g1, %g1, 92
	call	iter_setup_dirvec_constants.2818
	addi	%g1, %g1, 92
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fsti	%f12, %g3, -8
	ldi	%g5, %g1, 84
	sti	%g5, %g3, -4
	sti	%g14, %g3, 0
	slli	%g4, %g18, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 1716
	addi	%g14, %g12, 2
	addi	%g13, %g11, 3
	fldi	%f1, %g31, 300
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 92
	call	min_caml_create_float_array
	addi	%g1, %g1, 92
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 88
	subi	%g1, %g1, 96
	call	min_caml_create_array
	addi	%g1, %g1, 96
	mov	%g5, %g2
	addi	%g2, %g2, 8
	sti	%g3, %g5, -4
	ldi	%g4, %g1, 88
	sti	%g4, %g5, 0
	fsti	%f11, %g4, 0
	fsti	%f10, %g4, -4
	fsti	%f1, %g4, -8
	ldi	%g6, %g31, 28
	subi	%g11, %g6, 1
	sti	%g5, %g1, 92
	mov	%g5, %g11
	mov	%g6, %g3
	mov	%g7, %g4
	subi	%g1, %g1, 100
	call	iter_setup_dirvec_constants.2818
	addi	%g1, %g1, 100
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fsti	%f12, %g3, -8
	ldi	%g5, %g1, 92
	sti	%g5, %g3, -4
	sti	%g13, %g3, 0
	slli	%g4, %g14, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 1716
	addi	%g3, %g12, 3
	sti	%g3, %g31, 1720
	jmp	jeq_cont.42385
jeq_else.42384:
	addi	%g4, %g0, 2
	jne	%g5, %g4, jeq_else.42386
	slli	%g4, %g6, 2
	addi	%g12, %g4, 1
	ldi	%g13, %g31, 1720
	fsub	%f9, %f17, %f0
	ldi	%g3, %g3, -16
	fldi	%f7, %g31, 308
	fldi	%f5, %g3, 0
	fmul	%f2, %f7, %f5
	fldi	%f1, %g31, 304
	fldi	%f6, %g3, -4
	fmul	%f0, %f1, %f6
	fadd	%f4, %f2, %f0
	fldi	%f2, %g31, 300
	fldi	%f0, %g3, -8
	fmul	%f3, %f2, %f0
	fadd	%f3, %f4, %f3
	fldi	%f10, %g1, 12
	fmul	%f4, %f10, %f5
	fmul	%f4, %f4, %f3
	fsub	%f5, %f4, %f7
	fmul	%f4, %f10, %f6
	fmul	%f4, %f4, %f3
	fsub	%f4, %f4, %f1
	fmul	%f0, %f10, %f0
	fmul	%f0, %f0, %f3
	fsub	%f1, %f0, %f2
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 100
	call	min_caml_create_float_array
	addi	%g1, %g1, 100
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 96
	subi	%g1, %g1, 104
	call	min_caml_create_array
	addi	%g1, %g1, 104
	mov	%g5, %g2
	addi	%g2, %g2, 8
	sti	%g3, %g5, -4
	ldi	%g4, %g1, 96
	sti	%g4, %g5, 0
	fsti	%f5, %g4, 0
	fsti	%f4, %g4, -4
	fsti	%f1, %g4, -8
	ldi	%g6, %g31, 28
	subi	%g11, %g6, 1
	sti	%g5, %g1, 100
	mov	%g5, %g11
	mov	%g6, %g3
	mov	%g7, %g4
	subi	%g1, %g1, 108
	call	iter_setup_dirvec_constants.2818
	addi	%g1, %g1, 108
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fsti	%f9, %g3, -8
	ldi	%g5, %g1, 100
	sti	%g5, %g3, -4
	sti	%g12, %g3, 0
	slli	%g4, %g13, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 1716
	addi	%g3, %g13, 1
	sti	%g3, %g31, 1720
	jmp	jeq_cont.42387
jeq_else.42386:
jeq_cont.42387:
jeq_cont.42385:
fjge_cont.42383:
	jmp	jeq_cont.42381
jeq_else.42380:
jeq_cont.42381:
	jmp	jge_cont.42379
jge_else.42378:
jge_cont.42379:
	addi	%g8, %g0, 0
	fldi	%f3, %g31, 612
	ldi	%g3, %g31, 604
	sub	%g3, %g0, %g3
	subi	%g1, %g1, 108
	call	min_caml_float_of_int
	addi	%g1, %g1, 108
	fmul	%f0, %f3, %f0
	fldi	%f1, %g31, 660
	fmul	%f2, %f0, %f1
	fldi	%f1, %g31, 672
	fadd	%f13, %f2, %f1
	fldi	%f1, %g31, 656
	fmul	%f2, %f0, %f1
	fldi	%f1, %g31, 668
	fadd	%f12, %f2, %f1
	fldi	%f1, %g31, 652
	fmul	%f1, %f0, %f1
	fldi	%f0, %g31, 664
	fadd	%f11, %f1, %f0
	ldi	%g3, %g31, 600
	subi	%g6, %g3, 1
	ldi	%g16, %g1, 8
	mov	%g7, %g16
	subi	%g1, %g1, 108
	call	pretrace_pixels.2975
	addi	%g1, %g1, 108
	addi	%g10, %g0, 0
	addi	%g8, %g0, 2
	ldi	%g3, %g31, 596
	jlt	%g10, %g3, jle_else.42388
	jmp	jle_cont.42389
jle_else.42388:
	subi	%g3, %g3, 1
	sti	%g10, %g1, 104
	jlt	%g10, %g3, jle_else.42390
	jmp	jle_cont.42391
jle_else.42390:
	addi	%g4, %g0, 1
	fldi	%f3, %g31, 612
	ldi	%g3, %g31, 604
	sub	%g3, %g4, %g3
	subi	%g1, %g1, 112
	call	min_caml_float_of_int
	addi	%g1, %g1, 112
	fmul	%f0, %f3, %f0
	fldi	%f1, %g31, 660
	fmul	%f2, %f0, %f1
	fldi	%f1, %g31, 672
	fadd	%f13, %f2, %f1
	fldi	%f1, %g31, 656
	fmul	%f2, %f0, %f1
	fldi	%f1, %g31, 668
	fadd	%f12, %f2, %f1
	fldi	%f1, %g31, 652
	fmul	%f1, %f0, %f1
	fldi	%f0, %g31, 664
	fadd	%f11, %f1, %f0
	ldi	%g3, %g31, 600
	subi	%g6, %g3, 1
	ldi	%g15, %g1, 4
	mov	%g7, %g15
	subi	%g1, %g1, 112
	call	pretrace_pixels.2975
	addi	%g1, %g1, 112
jle_cont.42391:
	addi	%g6, %g0, 0
	ldi	%g10, %g1, 104
	ldi	%g17, %g1, 0
	ldi	%g16, %g1, 8
	ldi	%g15, %g1, 4
	mov	%g8, %g15
	mov	%g7, %g16
	mov	%g9, %g17
	subi	%g1, %g1, 112
	call	scan_pixel.2986
	addi	%g1, %g1, 112
	addi	%g10, %g0, 1
	addi	%g3, %g0, 4
	ldi	%g16, %g1, 8
	ldi	%g15, %g1, 4
	ldi	%g17, %g1, 0
	mov	%g8, %g17
	mov	%g9, %g15
	mov	%g7, %g16
	subi	%g1, %g1, 112
	call	scan_line.2992
	addi	%g1, %g1, 112
jle_cont.42389:
	addi	%g0, %g0, 0
	halt

!==============================
! args = []
! fargs = [%f1]
! use_regs = [%g27, %f29, %f16, %f15, %f1, %f0]
! ret type = Float
!================================
sin_sub.2518:
	fjlt	%f29, %f1, fjge_else.42392
	fjlt	%f1, %f16, fjge_else.42393
	fmov	%f0, %f1
	return
fjge_else.42393:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42394
	fjlt	%f1, %f16, fjge_else.42395
	fmov	%f0, %f1
	return
fjge_else.42395:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42396
	fjlt	%f1, %f16, fjge_else.42397
	fmov	%f0, %f1
	return
fjge_else.42397:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42398
	fjlt	%f1, %f16, fjge_else.42399
	fmov	%f0, %f1
	return
fjge_else.42399:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2518
fjge_else.42398:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2518
fjge_else.42396:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42400
	fjlt	%f1, %f16, fjge_else.42401
	fmov	%f0, %f1
	return
fjge_else.42401:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2518
fjge_else.42400:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2518
fjge_else.42394:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42402
	fjlt	%f1, %f16, fjge_else.42403
	fmov	%f0, %f1
	return
fjge_else.42403:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42404
	fjlt	%f1, %f16, fjge_else.42405
	fmov	%f0, %f1
	return
fjge_else.42405:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2518
fjge_else.42404:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2518
fjge_else.42402:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42406
	fjlt	%f1, %f16, fjge_else.42407
	fmov	%f0, %f1
	return
fjge_else.42407:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2518
fjge_else.42406:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2518
fjge_else.42392:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42408
	fjlt	%f1, %f16, fjge_else.42409
	fmov	%f0, %f1
	return
fjge_else.42409:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42410
	fjlt	%f1, %f16, fjge_else.42411
	fmov	%f0, %f1
	return
fjge_else.42411:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42412
	fjlt	%f1, %f16, fjge_else.42413
	fmov	%f0, %f1
	return
fjge_else.42413:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2518
fjge_else.42412:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2518
fjge_else.42410:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42414
	fjlt	%f1, %f16, fjge_else.42415
	fmov	%f0, %f1
	return
fjge_else.42415:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2518
fjge_else.42414:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2518
fjge_else.42408:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42416
	fjlt	%f1, %f16, fjge_else.42417
	fmov	%f0, %f1
	return
fjge_else.42417:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42418
	fjlt	%f1, %f16, fjge_else.42419
	fmov	%f0, %f1
	return
fjge_else.42419:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2518
fjge_else.42418:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2518
fjge_else.42416:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42420
	fjlt	%f1, %f16, fjge_else.42421
	fmov	%f0, %f1
	return
fjge_else.42421:
	fadd	%f1, %f1, %f29
	jmp	sin_sub.2518
fjge_else.42420:
	fsub	%f1, %f1, %f29
	jmp	sin_sub.2518

!==============================
! args = [%g4, %g6, %g9, %g10]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g10, %f15]
! ret type = Int
!================================
div_binary_search.2540:
	add	%g3, %g9, %g10
	srli	%g5, %g3, 1
	mul	%g7, %g5, %g6
	sub	%g3, %g10, %g9
	jlt	%g28, %g3, jle_else.42422
	mov	%g3, %g9
	return
jle_else.42422:
	jlt	%g7, %g4, jle_else.42423
	jne	%g7, %g4, jeq_else.42424
	mov	%g3, %g5
	return
jeq_else.42424:
	add	%g3, %g9, %g5
	srli	%g7, %g3, 1
	mul	%g8, %g7, %g6
	sub	%g3, %g5, %g9
	jlt	%g28, %g3, jle_else.42425
	mov	%g3, %g9
	return
jle_else.42425:
	jlt	%g8, %g4, jle_else.42426
	jne	%g8, %g4, jeq_else.42427
	mov	%g3, %g7
	return
jeq_else.42427:
	add	%g3, %g9, %g7
	srli	%g8, %g3, 1
	mul	%g5, %g8, %g6
	sub	%g3, %g7, %g9
	jlt	%g28, %g3, jle_else.42428
	mov	%g3, %g9
	return
jle_else.42428:
	jlt	%g5, %g4, jle_else.42429
	jne	%g5, %g4, jeq_else.42430
	mov	%g3, %g8
	return
jeq_else.42430:
	add	%g3, %g9, %g8
	srli	%g5, %g3, 1
	mul	%g7, %g5, %g6
	sub	%g3, %g8, %g9
	jlt	%g28, %g3, jle_else.42431
	mov	%g3, %g9
	return
jle_else.42431:
	jlt	%g7, %g4, jle_else.42432
	jne	%g7, %g4, jeq_else.42433
	mov	%g3, %g5
	return
jeq_else.42433:
	mov	%g10, %g5
	jmp	div_binary_search.2540
jle_else.42432:
	mov	%g10, %g8
	mov	%g9, %g5
	jmp	div_binary_search.2540
jle_else.42429:
	add	%g3, %g8, %g7
	srli	%g5, %g3, 1
	mul	%g9, %g5, %g6
	sub	%g3, %g7, %g8
	jlt	%g28, %g3, jle_else.42434
	mov	%g3, %g8
	return
jle_else.42434:
	jlt	%g9, %g4, jle_else.42435
	jne	%g9, %g4, jeq_else.42436
	mov	%g3, %g5
	return
jeq_else.42436:
	mov	%g10, %g5
	mov	%g9, %g8
	jmp	div_binary_search.2540
jle_else.42435:
	mov	%g10, %g7
	mov	%g9, %g5
	jmp	div_binary_search.2540
jle_else.42426:
	add	%g3, %g7, %g5
	srli	%g8, %g3, 1
	mul	%g9, %g8, %g6
	sub	%g3, %g5, %g7
	jlt	%g28, %g3, jle_else.42437
	mov	%g3, %g7
	return
jle_else.42437:
	jlt	%g9, %g4, jle_else.42438
	jne	%g9, %g4, jeq_else.42439
	mov	%g3, %g8
	return
jeq_else.42439:
	add	%g3, %g7, %g8
	srli	%g5, %g3, 1
	mul	%g9, %g5, %g6
	sub	%g3, %g8, %g7
	jlt	%g28, %g3, jle_else.42440
	mov	%g3, %g7
	return
jle_else.42440:
	jlt	%g9, %g4, jle_else.42441
	jne	%g9, %g4, jeq_else.42442
	mov	%g3, %g5
	return
jeq_else.42442:
	mov	%g10, %g5
	mov	%g9, %g7
	jmp	div_binary_search.2540
jle_else.42441:
	mov	%g10, %g8
	mov	%g9, %g5
	jmp	div_binary_search.2540
jle_else.42438:
	add	%g3, %g8, %g5
	srli	%g7, %g3, 1
	mul	%g9, %g7, %g6
	sub	%g3, %g5, %g8
	jlt	%g28, %g3, jle_else.42443
	mov	%g3, %g8
	return
jle_else.42443:
	jlt	%g9, %g4, jle_else.42444
	jne	%g9, %g4, jeq_else.42445
	mov	%g3, %g7
	return
jeq_else.42445:
	mov	%g10, %g7
	mov	%g9, %g8
	jmp	div_binary_search.2540
jle_else.42444:
	mov	%g10, %g5
	mov	%g9, %g7
	jmp	div_binary_search.2540
jle_else.42423:
	add	%g3, %g5, %g10
	srli	%g8, %g3, 1
	mul	%g7, %g8, %g6
	sub	%g3, %g10, %g5
	jlt	%g28, %g3, jle_else.42446
	mov	%g3, %g5
	return
jle_else.42446:
	jlt	%g7, %g4, jle_else.42447
	jne	%g7, %g4, jeq_else.42448
	mov	%g3, %g8
	return
jeq_else.42448:
	add	%g3, %g5, %g8
	srli	%g7, %g3, 1
	mul	%g9, %g7, %g6
	sub	%g3, %g8, %g5
	jlt	%g28, %g3, jle_else.42449
	mov	%g3, %g5
	return
jle_else.42449:
	jlt	%g9, %g4, jle_else.42450
	jne	%g9, %g4, jeq_else.42451
	mov	%g3, %g7
	return
jeq_else.42451:
	add	%g3, %g5, %g7
	srli	%g8, %g3, 1
	mul	%g9, %g8, %g6
	sub	%g3, %g7, %g5
	jlt	%g28, %g3, jle_else.42452
	mov	%g3, %g5
	return
jle_else.42452:
	jlt	%g9, %g4, jle_else.42453
	jne	%g9, %g4, jeq_else.42454
	mov	%g3, %g8
	return
jeq_else.42454:
	mov	%g10, %g8
	mov	%g9, %g5
	jmp	div_binary_search.2540
jle_else.42453:
	mov	%g10, %g7
	mov	%g9, %g8
	jmp	div_binary_search.2540
jle_else.42450:
	add	%g3, %g7, %g8
	srli	%g5, %g3, 1
	mul	%g9, %g5, %g6
	sub	%g3, %g8, %g7
	jlt	%g28, %g3, jle_else.42455
	mov	%g3, %g7
	return
jle_else.42455:
	jlt	%g9, %g4, jle_else.42456
	jne	%g9, %g4, jeq_else.42457
	mov	%g3, %g5
	return
jeq_else.42457:
	mov	%g10, %g5
	mov	%g9, %g7
	jmp	div_binary_search.2540
jle_else.42456:
	mov	%g10, %g8
	mov	%g9, %g5
	jmp	div_binary_search.2540
jle_else.42447:
	add	%g3, %g8, %g10
	srli	%g7, %g3, 1
	mul	%g5, %g7, %g6
	sub	%g3, %g10, %g8
	jlt	%g28, %g3, jle_else.42458
	mov	%g3, %g8
	return
jle_else.42458:
	jlt	%g5, %g4, jle_else.42459
	jne	%g5, %g4, jeq_else.42460
	mov	%g3, %g7
	return
jeq_else.42460:
	add	%g3, %g8, %g7
	srli	%g5, %g3, 1
	mul	%g9, %g5, %g6
	sub	%g3, %g7, %g8
	jlt	%g28, %g3, jle_else.42461
	mov	%g3, %g8
	return
jle_else.42461:
	jlt	%g9, %g4, jle_else.42462
	jne	%g9, %g4, jeq_else.42463
	mov	%g3, %g5
	return
jeq_else.42463:
	mov	%g10, %g5
	mov	%g9, %g8
	jmp	div_binary_search.2540
jle_else.42462:
	mov	%g10, %g7
	mov	%g9, %g5
	jmp	div_binary_search.2540
jle_else.42459:
	add	%g3, %g7, %g10
	srli	%g5, %g3, 1
	mul	%g8, %g5, %g6
	sub	%g3, %g10, %g7
	jlt	%g28, %g3, jle_else.42464
	mov	%g3, %g7
	return
jle_else.42464:
	jlt	%g8, %g4, jle_else.42465
	jne	%g8, %g4, jeq_else.42466
	mov	%g3, %g5
	return
jeq_else.42466:
	mov	%g10, %g5
	mov	%g9, %g7
	jmp	div_binary_search.2540
jle_else.42465:
	mov	%g9, %g5
	jmp	div_binary_search.2540

!==============================
! args = [%g4]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g14, %g13, %g12, %g11, %g10, %f15, %dummy]
! ret type = Unit
!================================
print_int.2545:
	jlt	%g4, %g0, jge_else.42467
	mvhi	%g3, 1525
	mvlo	%g3, 57600
	jlt	%g3, %g4, jle_else.42468
	jne	%g3, %g4, jeq_else.42470
	addi	%g5, %g0, 1
	jmp	jeq_cont.42471
jeq_else.42470:
	addi	%g5, %g0, 0
jeq_cont.42471:
	jmp	jle_cont.42469
jle_else.42468:
	mvhi	%g3, 3051
	mvlo	%g3, 49664
	jlt	%g3, %g4, jle_else.42472
	jne	%g3, %g4, jeq_else.42474
	addi	%g5, %g0, 2
	jmp	jeq_cont.42475
jeq_else.42474:
	addi	%g5, %g0, 1
jeq_cont.42475:
	jmp	jle_cont.42473
jle_else.42472:
	addi	%g5, %g0, 2
jle_cont.42473:
jle_cont.42469:
	mvhi	%g3, 1525
	mvlo	%g3, 57600
	mul	%g3, %g5, %g3
	sub	%g4, %g4, %g3
	jlt	%g0, %g5, jle_else.42476
	addi	%g13, %g0, 0
	jmp	jle_cont.42477
jle_else.42476:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g5
	output	%g3
	addi	%g13, %g0, 1
jle_cont.42477:
	mvhi	%g6, 152
	mvlo	%g6, 38528
	addi	%g12, %g0, 0
	addi	%g10, %g0, 10
	addi	%g9, %g0, 5
	mvhi	%g5, 762
	mvlo	%g5, 61568
	sti	%g4, %g1, 0
	jlt	%g5, %g4, jle_else.42478
	jne	%g5, %g4, jeq_else.42480
	addi	%g3, %g0, 5
	jmp	jeq_cont.42481
jeq_else.42480:
	addi	%g11, %g0, 2
	mvhi	%g5, 305
	mvlo	%g5, 11520
	jlt	%g5, %g4, jle_else.42482
	jne	%g5, %g4, jeq_else.42484
	addi	%g3, %g0, 2
	jmp	jeq_cont.42485
jeq_else.42484:
	addi	%g9, %g0, 1
	mvhi	%g5, 152
	mvlo	%g5, 38528
	jlt	%g5, %g4, jle_else.42486
	jne	%g5, %g4, jeq_else.42488
	addi	%g3, %g0, 1
	jmp	jeq_cont.42489
jeq_else.42488:
	mov	%g10, %g9
	mov	%g9, %g12
	subi	%g1, %g1, 8
	call	div_binary_search.2540
	addi	%g1, %g1, 8
jeq_cont.42489:
	jmp	jle_cont.42487
jle_else.42486:
	mov	%g10, %g11
	subi	%g1, %g1, 8
	call	div_binary_search.2540
	addi	%g1, %g1, 8
jle_cont.42487:
jeq_cont.42485:
	jmp	jle_cont.42483
jle_else.42482:
	addi	%g10, %g0, 3
	mvhi	%g5, 457
	mvlo	%g5, 50048
	jlt	%g5, %g4, jle_else.42490
	jne	%g5, %g4, jeq_else.42492
	addi	%g3, %g0, 3
	jmp	jeq_cont.42493
jeq_else.42492:
	mov	%g9, %g11
	subi	%g1, %g1, 8
	call	div_binary_search.2540
	addi	%g1, %g1, 8
jeq_cont.42493:
	jmp	jle_cont.42491
jle_else.42490:
	mov	%g27, %g10
	mov	%g10, %g9
	mov	%g9, %g27
	subi	%g1, %g1, 8
	call	div_binary_search.2540
	addi	%g1, %g1, 8
jle_cont.42491:
jle_cont.42483:
jeq_cont.42481:
	jmp	jle_cont.42479
jle_else.42478:
	addi	%g11, %g0, 7
	mvhi	%g5, 1068
	mvlo	%g5, 7552
	jlt	%g5, %g4, jle_else.42494
	jne	%g5, %g4, jeq_else.42496
	addi	%g3, %g0, 7
	jmp	jeq_cont.42497
jeq_else.42496:
	addi	%g10, %g0, 6
	mvhi	%g5, 915
	mvlo	%g5, 34560
	jlt	%g5, %g4, jle_else.42498
	jne	%g5, %g4, jeq_else.42500
	addi	%g3, %g0, 6
	jmp	jeq_cont.42501
jeq_else.42500:
	subi	%g1, %g1, 8
	call	div_binary_search.2540
	addi	%g1, %g1, 8
jeq_cont.42501:
	jmp	jle_cont.42499
jle_else.42498:
	mov	%g9, %g10
	mov	%g10, %g11
	subi	%g1, %g1, 8
	call	div_binary_search.2540
	addi	%g1, %g1, 8
jle_cont.42499:
jeq_cont.42497:
	jmp	jle_cont.42495
jle_else.42494:
	addi	%g9, %g0, 8
	mvhi	%g5, 1220
	mvlo	%g5, 46080
	jlt	%g5, %g4, jle_else.42502
	jne	%g5, %g4, jeq_else.42504
	addi	%g3, %g0, 8
	jmp	jeq_cont.42505
jeq_else.42504:
	mov	%g10, %g9
	mov	%g9, %g11
	subi	%g1, %g1, 8
	call	div_binary_search.2540
	addi	%g1, %g1, 8
jeq_cont.42505:
	jmp	jle_cont.42503
jle_else.42502:
	subi	%g1, %g1, 8
	call	div_binary_search.2540
	addi	%g1, %g1, 8
jle_cont.42503:
jle_cont.42495:
jle_cont.42479:
	mvhi	%g5, 152
	mvlo	%g5, 38528
	mul	%g5, %g3, %g5
	ldi	%g4, %g1, 0
	sub	%g4, %g4, %g5
	jlt	%g0, %g3, jle_else.42506
	jne	%g13, %g0, jeq_else.42508
	addi	%g14, %g0, 0
	jmp	jeq_cont.42509
jeq_else.42508:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g14, %g0, 1
jeq_cont.42509:
	jmp	jle_cont.42507
jle_else.42506:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g14, %g0, 1
jle_cont.42507:
	mvhi	%g6, 15
	mvlo	%g6, 16960
	addi	%g12, %g0, 0
	addi	%g10, %g0, 10
	addi	%g9, %g0, 5
	mvhi	%g5, 76
	mvlo	%g5, 19264
	sti	%g4, %g1, 4
	jlt	%g5, %g4, jle_else.42510
	jne	%g5, %g4, jeq_else.42512
	addi	%g3, %g0, 5
	jmp	jeq_cont.42513
jeq_else.42512:
	addi	%g11, %g0, 2
	mvhi	%g5, 30
	mvlo	%g5, 33920
	jlt	%g5, %g4, jle_else.42514
	jne	%g5, %g4, jeq_else.42516
	addi	%g3, %g0, 2
	jmp	jeq_cont.42517
jeq_else.42516:
	addi	%g9, %g0, 1
	mvhi	%g5, 15
	mvlo	%g5, 16960
	jlt	%g5, %g4, jle_else.42518
	jne	%g5, %g4, jeq_else.42520
	addi	%g3, %g0, 1
	jmp	jeq_cont.42521
jeq_else.42520:
	mov	%g10, %g9
	mov	%g9, %g12
	subi	%g1, %g1, 12
	call	div_binary_search.2540
	addi	%g1, %g1, 12
jeq_cont.42521:
	jmp	jle_cont.42519
jle_else.42518:
	mov	%g10, %g11
	subi	%g1, %g1, 12
	call	div_binary_search.2540
	addi	%g1, %g1, 12
jle_cont.42519:
jeq_cont.42517:
	jmp	jle_cont.42515
jle_else.42514:
	addi	%g10, %g0, 3
	mvhi	%g5, 45
	mvlo	%g5, 50880
	jlt	%g5, %g4, jle_else.42522
	jne	%g5, %g4, jeq_else.42524
	addi	%g3, %g0, 3
	jmp	jeq_cont.42525
jeq_else.42524:
	mov	%g9, %g11
	subi	%g1, %g1, 12
	call	div_binary_search.2540
	addi	%g1, %g1, 12
jeq_cont.42525:
	jmp	jle_cont.42523
jle_else.42522:
	mov	%g27, %g10
	mov	%g10, %g9
	mov	%g9, %g27
	subi	%g1, %g1, 12
	call	div_binary_search.2540
	addi	%g1, %g1, 12
jle_cont.42523:
jle_cont.42515:
jeq_cont.42513:
	jmp	jle_cont.42511
jle_else.42510:
	addi	%g11, %g0, 7
	mvhi	%g5, 106
	mvlo	%g5, 53184
	jlt	%g5, %g4, jle_else.42526
	jne	%g5, %g4, jeq_else.42528
	addi	%g3, %g0, 7
	jmp	jeq_cont.42529
jeq_else.42528:
	addi	%g10, %g0, 6
	mvhi	%g5, 91
	mvlo	%g5, 36224
	jlt	%g5, %g4, jle_else.42530
	jne	%g5, %g4, jeq_else.42532
	addi	%g3, %g0, 6
	jmp	jeq_cont.42533
jeq_else.42532:
	subi	%g1, %g1, 12
	call	div_binary_search.2540
	addi	%g1, %g1, 12
jeq_cont.42533:
	jmp	jle_cont.42531
jle_else.42530:
	mov	%g9, %g10
	mov	%g10, %g11
	subi	%g1, %g1, 12
	call	div_binary_search.2540
	addi	%g1, %g1, 12
jle_cont.42531:
jeq_cont.42529:
	jmp	jle_cont.42527
jle_else.42526:
	addi	%g9, %g0, 8
	mvhi	%g5, 122
	mvlo	%g5, 4608
	jlt	%g5, %g4, jle_else.42534
	jne	%g5, %g4, jeq_else.42536
	addi	%g3, %g0, 8
	jmp	jeq_cont.42537
jeq_else.42536:
	mov	%g10, %g9
	mov	%g9, %g11
	subi	%g1, %g1, 12
	call	div_binary_search.2540
	addi	%g1, %g1, 12
jeq_cont.42537:
	jmp	jle_cont.42535
jle_else.42534:
	subi	%g1, %g1, 12
	call	div_binary_search.2540
	addi	%g1, %g1, 12
jle_cont.42535:
jle_cont.42527:
jle_cont.42511:
	mvhi	%g5, 15
	mvlo	%g5, 16960
	mul	%g5, %g3, %g5
	ldi	%g4, %g1, 4
	sub	%g4, %g4, %g5
	jlt	%g0, %g3, jle_else.42538
	jne	%g14, %g0, jeq_else.42540
	addi	%g13, %g0, 0
	jmp	jeq_cont.42541
jeq_else.42540:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g13, %g0, 1
jeq_cont.42541:
	jmp	jle_cont.42539
jle_else.42538:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g13, %g0, 1
jle_cont.42539:
	mvhi	%g6, 1
	mvlo	%g6, 34464
	addi	%g12, %g0, 0
	addi	%g10, %g0, 10
	addi	%g9, %g0, 5
	mvhi	%g5, 7
	mvlo	%g5, 41248
	sti	%g4, %g1, 8
	jlt	%g5, %g4, jle_else.42542
	jne	%g5, %g4, jeq_else.42544
	addi	%g3, %g0, 5
	jmp	jeq_cont.42545
jeq_else.42544:
	addi	%g11, %g0, 2
	mvhi	%g5, 3
	mvlo	%g5, 3392
	jlt	%g5, %g4, jle_else.42546
	jne	%g5, %g4, jeq_else.42548
	addi	%g3, %g0, 2
	jmp	jeq_cont.42549
jeq_else.42548:
	addi	%g9, %g0, 1
	mvhi	%g5, 1
	mvlo	%g5, 34464
	jlt	%g5, %g4, jle_else.42550
	jne	%g5, %g4, jeq_else.42552
	addi	%g3, %g0, 1
	jmp	jeq_cont.42553
jeq_else.42552:
	mov	%g10, %g9
	mov	%g9, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.2540
	addi	%g1, %g1, 16
jeq_cont.42553:
	jmp	jle_cont.42551
jle_else.42550:
	mov	%g10, %g11
	subi	%g1, %g1, 16
	call	div_binary_search.2540
	addi	%g1, %g1, 16
jle_cont.42551:
jeq_cont.42549:
	jmp	jle_cont.42547
jle_else.42546:
	addi	%g10, %g0, 3
	mvhi	%g5, 4
	mvlo	%g5, 37856
	jlt	%g5, %g4, jle_else.42554
	jne	%g5, %g4, jeq_else.42556
	addi	%g3, %g0, 3
	jmp	jeq_cont.42557
jeq_else.42556:
	mov	%g9, %g11
	subi	%g1, %g1, 16
	call	div_binary_search.2540
	addi	%g1, %g1, 16
jeq_cont.42557:
	jmp	jle_cont.42555
jle_else.42554:
	mov	%g27, %g10
	mov	%g10, %g9
	mov	%g9, %g27
	subi	%g1, %g1, 16
	call	div_binary_search.2540
	addi	%g1, %g1, 16
jle_cont.42555:
jle_cont.42547:
jeq_cont.42545:
	jmp	jle_cont.42543
jle_else.42542:
	addi	%g11, %g0, 7
	mvhi	%g5, 10
	mvlo	%g5, 44640
	jlt	%g5, %g4, jle_else.42558
	jne	%g5, %g4, jeq_else.42560
	addi	%g3, %g0, 7
	jmp	jeq_cont.42561
jeq_else.42560:
	addi	%g10, %g0, 6
	mvhi	%g5, 9
	mvlo	%g5, 10176
	jlt	%g5, %g4, jle_else.42562
	jne	%g5, %g4, jeq_else.42564
	addi	%g3, %g0, 6
	jmp	jeq_cont.42565
jeq_else.42564:
	subi	%g1, %g1, 16
	call	div_binary_search.2540
	addi	%g1, %g1, 16
jeq_cont.42565:
	jmp	jle_cont.42563
jle_else.42562:
	mov	%g9, %g10
	mov	%g10, %g11
	subi	%g1, %g1, 16
	call	div_binary_search.2540
	addi	%g1, %g1, 16
jle_cont.42563:
jeq_cont.42561:
	jmp	jle_cont.42559
jle_else.42558:
	addi	%g9, %g0, 8
	mvhi	%g5, 12
	mvlo	%g5, 13568
	jlt	%g5, %g4, jle_else.42566
	jne	%g5, %g4, jeq_else.42568
	addi	%g3, %g0, 8
	jmp	jeq_cont.42569
jeq_else.42568:
	mov	%g10, %g9
	mov	%g9, %g11
	subi	%g1, %g1, 16
	call	div_binary_search.2540
	addi	%g1, %g1, 16
jeq_cont.42569:
	jmp	jle_cont.42567
jle_else.42566:
	subi	%g1, %g1, 16
	call	div_binary_search.2540
	addi	%g1, %g1, 16
jle_cont.42567:
jle_cont.42559:
jle_cont.42543:
	mvhi	%g5, 1
	mvlo	%g5, 34464
	mul	%g5, %g3, %g5
	ldi	%g4, %g1, 8
	sub	%g4, %g4, %g5
	jlt	%g0, %g3, jle_else.42570
	jne	%g13, %g0, jeq_else.42572
	addi	%g14, %g0, 0
	jmp	jeq_cont.42573
jeq_else.42572:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g14, %g0, 1
jeq_cont.42573:
	jmp	jle_cont.42571
jle_else.42570:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g14, %g0, 1
jle_cont.42571:
	addi	%g6, %g0, 10000
	addi	%g12, %g0, 0
	addi	%g10, %g0, 10
	addi	%g9, %g0, 5
	mvhi	%g5, 0
	mvlo	%g5, 50000
	sti	%g4, %g1, 12
	jlt	%g5, %g4, jle_else.42574
	jne	%g5, %g4, jeq_else.42576
	addi	%g3, %g0, 5
	jmp	jeq_cont.42577
jeq_else.42576:
	addi	%g11, %g0, 2
	addi	%g5, %g0, 20000
	jlt	%g5, %g4, jle_else.42578
	jne	%g5, %g4, jeq_else.42580
	addi	%g3, %g0, 2
	jmp	jeq_cont.42581
jeq_else.42580:
	addi	%g9, %g0, 1
	addi	%g5, %g0, 10000
	jlt	%g5, %g4, jle_else.42582
	jne	%g5, %g4, jeq_else.42584
	addi	%g3, %g0, 1
	jmp	jeq_cont.42585
jeq_else.42584:
	mov	%g10, %g9
	mov	%g9, %g12
	subi	%g1, %g1, 20
	call	div_binary_search.2540
	addi	%g1, %g1, 20
jeq_cont.42585:
	jmp	jle_cont.42583
jle_else.42582:
	mov	%g10, %g11
	subi	%g1, %g1, 20
	call	div_binary_search.2540
	addi	%g1, %g1, 20
jle_cont.42583:
jeq_cont.42581:
	jmp	jle_cont.42579
jle_else.42578:
	addi	%g10, %g0, 3
	addi	%g5, %g0, 30000
	jlt	%g5, %g4, jle_else.42586
	jne	%g5, %g4, jeq_else.42588
	addi	%g3, %g0, 3
	jmp	jeq_cont.42589
jeq_else.42588:
	mov	%g9, %g11
	subi	%g1, %g1, 20
	call	div_binary_search.2540
	addi	%g1, %g1, 20
jeq_cont.42589:
	jmp	jle_cont.42587
jle_else.42586:
	mov	%g27, %g10
	mov	%g10, %g9
	mov	%g9, %g27
	subi	%g1, %g1, 20
	call	div_binary_search.2540
	addi	%g1, %g1, 20
jle_cont.42587:
jle_cont.42579:
jeq_cont.42577:
	jmp	jle_cont.42575
jle_else.42574:
	addi	%g11, %g0, 7
	mvhi	%g5, 1
	mvlo	%g5, 4464
	jlt	%g5, %g4, jle_else.42590
	jne	%g5, %g4, jeq_else.42592
	addi	%g3, %g0, 7
	jmp	jeq_cont.42593
jeq_else.42592:
	addi	%g10, %g0, 6
	mvhi	%g5, 0
	mvlo	%g5, 60000
	jlt	%g5, %g4, jle_else.42594
	jne	%g5, %g4, jeq_else.42596
	addi	%g3, %g0, 6
	jmp	jeq_cont.42597
jeq_else.42596:
	subi	%g1, %g1, 20
	call	div_binary_search.2540
	addi	%g1, %g1, 20
jeq_cont.42597:
	jmp	jle_cont.42595
jle_else.42594:
	mov	%g9, %g10
	mov	%g10, %g11
	subi	%g1, %g1, 20
	call	div_binary_search.2540
	addi	%g1, %g1, 20
jle_cont.42595:
jeq_cont.42593:
	jmp	jle_cont.42591
jle_else.42590:
	addi	%g9, %g0, 8
	mvhi	%g5, 1
	mvlo	%g5, 14464
	jlt	%g5, %g4, jle_else.42598
	jne	%g5, %g4, jeq_else.42600
	addi	%g3, %g0, 8
	jmp	jeq_cont.42601
jeq_else.42600:
	mov	%g10, %g9
	mov	%g9, %g11
	subi	%g1, %g1, 20
	call	div_binary_search.2540
	addi	%g1, %g1, 20
jeq_cont.42601:
	jmp	jle_cont.42599
jle_else.42598:
	subi	%g1, %g1, 20
	call	div_binary_search.2540
	addi	%g1, %g1, 20
jle_cont.42599:
jle_cont.42591:
jle_cont.42575:
	addi	%g5, %g0, 10000
	mul	%g5, %g3, %g5
	ldi	%g4, %g1, 12
	sub	%g4, %g4, %g5
	jlt	%g0, %g3, jle_else.42602
	jne	%g14, %g0, jeq_else.42604
	addi	%g13, %g0, 0
	jmp	jeq_cont.42605
jeq_else.42604:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g13, %g0, 1
jeq_cont.42605:
	jmp	jle_cont.42603
jle_else.42602:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g13, %g0, 1
jle_cont.42603:
	addi	%g6, %g0, 1000
	addi	%g12, %g0, 0
	addi	%g10, %g0, 10
	addi	%g9, %g0, 5
	addi	%g5, %g0, 5000
	sti	%g4, %g1, 16
	jlt	%g5, %g4, jle_else.42606
	jne	%g5, %g4, jeq_else.42608
	addi	%g3, %g0, 5
	jmp	jeq_cont.42609
jeq_else.42608:
	addi	%g11, %g0, 2
	addi	%g5, %g0, 2000
	jlt	%g5, %g4, jle_else.42610
	jne	%g5, %g4, jeq_else.42612
	addi	%g3, %g0, 2
	jmp	jeq_cont.42613
jeq_else.42612:
	addi	%g9, %g0, 1
	addi	%g5, %g0, 1000
	jlt	%g5, %g4, jle_else.42614
	jne	%g5, %g4, jeq_else.42616
	addi	%g3, %g0, 1
	jmp	jeq_cont.42617
jeq_else.42616:
	mov	%g10, %g9
	mov	%g9, %g12
	subi	%g1, %g1, 24
	call	div_binary_search.2540
	addi	%g1, %g1, 24
jeq_cont.42617:
	jmp	jle_cont.42615
jle_else.42614:
	mov	%g10, %g11
	subi	%g1, %g1, 24
	call	div_binary_search.2540
	addi	%g1, %g1, 24
jle_cont.42615:
jeq_cont.42613:
	jmp	jle_cont.42611
jle_else.42610:
	addi	%g10, %g0, 3
	addi	%g5, %g0, 3000
	jlt	%g5, %g4, jle_else.42618
	jne	%g5, %g4, jeq_else.42620
	addi	%g3, %g0, 3
	jmp	jeq_cont.42621
jeq_else.42620:
	mov	%g9, %g11
	subi	%g1, %g1, 24
	call	div_binary_search.2540
	addi	%g1, %g1, 24
jeq_cont.42621:
	jmp	jle_cont.42619
jle_else.42618:
	mov	%g27, %g10
	mov	%g10, %g9
	mov	%g9, %g27
	subi	%g1, %g1, 24
	call	div_binary_search.2540
	addi	%g1, %g1, 24
jle_cont.42619:
jle_cont.42611:
jeq_cont.42609:
	jmp	jle_cont.42607
jle_else.42606:
	addi	%g11, %g0, 7
	addi	%g5, %g0, 7000
	jlt	%g5, %g4, jle_else.42622
	jne	%g5, %g4, jeq_else.42624
	addi	%g3, %g0, 7
	jmp	jeq_cont.42625
jeq_else.42624:
	addi	%g10, %g0, 6
	addi	%g5, %g0, 6000
	jlt	%g5, %g4, jle_else.42626
	jne	%g5, %g4, jeq_else.42628
	addi	%g3, %g0, 6
	jmp	jeq_cont.42629
jeq_else.42628:
	subi	%g1, %g1, 24
	call	div_binary_search.2540
	addi	%g1, %g1, 24
jeq_cont.42629:
	jmp	jle_cont.42627
jle_else.42626:
	mov	%g9, %g10
	mov	%g10, %g11
	subi	%g1, %g1, 24
	call	div_binary_search.2540
	addi	%g1, %g1, 24
jle_cont.42627:
jeq_cont.42625:
	jmp	jle_cont.42623
jle_else.42622:
	addi	%g9, %g0, 8
	addi	%g5, %g0, 8000
	jlt	%g5, %g4, jle_else.42630
	jne	%g5, %g4, jeq_else.42632
	addi	%g3, %g0, 8
	jmp	jeq_cont.42633
jeq_else.42632:
	mov	%g10, %g9
	mov	%g9, %g11
	subi	%g1, %g1, 24
	call	div_binary_search.2540
	addi	%g1, %g1, 24
jeq_cont.42633:
	jmp	jle_cont.42631
jle_else.42630:
	subi	%g1, %g1, 24
	call	div_binary_search.2540
	addi	%g1, %g1, 24
jle_cont.42631:
jle_cont.42623:
jle_cont.42607:
	muli	%g5, %g3, 1000
	ldi	%g4, %g1, 16
	sub	%g4, %g4, %g5
	jlt	%g0, %g3, jle_else.42634
	jne	%g13, %g0, jeq_else.42636
	addi	%g14, %g0, 0
	jmp	jeq_cont.42637
jeq_else.42636:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g14, %g0, 1
jeq_cont.42637:
	jmp	jle_cont.42635
jle_else.42634:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g14, %g0, 1
jle_cont.42635:
	addi	%g6, %g0, 100
	addi	%g12, %g0, 0
	addi	%g10, %g0, 10
	addi	%g9, %g0, 5
	addi	%g5, %g0, 500
	sti	%g4, %g1, 20
	jlt	%g5, %g4, jle_else.42638
	jne	%g5, %g4, jeq_else.42640
	addi	%g3, %g0, 5
	jmp	jeq_cont.42641
jeq_else.42640:
	addi	%g11, %g0, 2
	addi	%g5, %g0, 200
	jlt	%g5, %g4, jle_else.42642
	jne	%g5, %g4, jeq_else.42644
	addi	%g3, %g0, 2
	jmp	jeq_cont.42645
jeq_else.42644:
	addi	%g9, %g0, 1
	addi	%g5, %g0, 100
	jlt	%g5, %g4, jle_else.42646
	jne	%g5, %g4, jeq_else.42648
	addi	%g3, %g0, 1
	jmp	jeq_cont.42649
jeq_else.42648:
	mov	%g10, %g9
	mov	%g9, %g12
	subi	%g1, %g1, 28
	call	div_binary_search.2540
	addi	%g1, %g1, 28
jeq_cont.42649:
	jmp	jle_cont.42647
jle_else.42646:
	mov	%g10, %g11
	subi	%g1, %g1, 28
	call	div_binary_search.2540
	addi	%g1, %g1, 28
jle_cont.42647:
jeq_cont.42645:
	jmp	jle_cont.42643
jle_else.42642:
	addi	%g10, %g0, 3
	addi	%g5, %g0, 300
	jlt	%g5, %g4, jle_else.42650
	jne	%g5, %g4, jeq_else.42652
	addi	%g3, %g0, 3
	jmp	jeq_cont.42653
jeq_else.42652:
	mov	%g9, %g11
	subi	%g1, %g1, 28
	call	div_binary_search.2540
	addi	%g1, %g1, 28
jeq_cont.42653:
	jmp	jle_cont.42651
jle_else.42650:
	mov	%g27, %g10
	mov	%g10, %g9
	mov	%g9, %g27
	subi	%g1, %g1, 28
	call	div_binary_search.2540
	addi	%g1, %g1, 28
jle_cont.42651:
jle_cont.42643:
jeq_cont.42641:
	jmp	jle_cont.42639
jle_else.42638:
	addi	%g11, %g0, 7
	addi	%g5, %g0, 700
	jlt	%g5, %g4, jle_else.42654
	jne	%g5, %g4, jeq_else.42656
	addi	%g3, %g0, 7
	jmp	jeq_cont.42657
jeq_else.42656:
	addi	%g10, %g0, 6
	addi	%g5, %g0, 600
	jlt	%g5, %g4, jle_else.42658
	jne	%g5, %g4, jeq_else.42660
	addi	%g3, %g0, 6
	jmp	jeq_cont.42661
jeq_else.42660:
	subi	%g1, %g1, 28
	call	div_binary_search.2540
	addi	%g1, %g1, 28
jeq_cont.42661:
	jmp	jle_cont.42659
jle_else.42658:
	mov	%g9, %g10
	mov	%g10, %g11
	subi	%g1, %g1, 28
	call	div_binary_search.2540
	addi	%g1, %g1, 28
jle_cont.42659:
jeq_cont.42657:
	jmp	jle_cont.42655
jle_else.42654:
	addi	%g9, %g0, 8
	addi	%g5, %g0, 800
	jlt	%g5, %g4, jle_else.42662
	jne	%g5, %g4, jeq_else.42664
	addi	%g3, %g0, 8
	jmp	jeq_cont.42665
jeq_else.42664:
	mov	%g10, %g9
	mov	%g9, %g11
	subi	%g1, %g1, 28
	call	div_binary_search.2540
	addi	%g1, %g1, 28
jeq_cont.42665:
	jmp	jle_cont.42663
jle_else.42662:
	subi	%g1, %g1, 28
	call	div_binary_search.2540
	addi	%g1, %g1, 28
jle_cont.42663:
jle_cont.42655:
jle_cont.42639:
	muli	%g5, %g3, 100
	ldi	%g4, %g1, 20
	sub	%g4, %g4, %g5
	jlt	%g0, %g3, jle_else.42666
	jne	%g14, %g0, jeq_else.42668
	addi	%g13, %g0, 0
	jmp	jeq_cont.42669
jeq_else.42668:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g13, %g0, 1
jeq_cont.42669:
	jmp	jle_cont.42667
jle_else.42666:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g13, %g0, 1
jle_cont.42667:
	addi	%g6, %g0, 10
	addi	%g12, %g0, 0
	addi	%g10, %g0, 10
	addi	%g9, %g0, 5
	addi	%g5, %g0, 50
	sti	%g4, %g1, 24
	jlt	%g5, %g4, jle_else.42670
	jne	%g5, %g4, jeq_else.42672
	addi	%g3, %g0, 5
	jmp	jeq_cont.42673
jeq_else.42672:
	addi	%g11, %g0, 2
	addi	%g5, %g0, 20
	jlt	%g5, %g4, jle_else.42674
	jne	%g5, %g4, jeq_else.42676
	addi	%g3, %g0, 2
	jmp	jeq_cont.42677
jeq_else.42676:
	addi	%g9, %g0, 1
	addi	%g5, %g0, 10
	jlt	%g5, %g4, jle_else.42678
	jne	%g5, %g4, jeq_else.42680
	addi	%g3, %g0, 1
	jmp	jeq_cont.42681
jeq_else.42680:
	mov	%g10, %g9
	mov	%g9, %g12
	subi	%g1, %g1, 32
	call	div_binary_search.2540
	addi	%g1, %g1, 32
jeq_cont.42681:
	jmp	jle_cont.42679
jle_else.42678:
	mov	%g10, %g11
	subi	%g1, %g1, 32
	call	div_binary_search.2540
	addi	%g1, %g1, 32
jle_cont.42679:
jeq_cont.42677:
	jmp	jle_cont.42675
jle_else.42674:
	addi	%g10, %g0, 3
	addi	%g5, %g0, 30
	jlt	%g5, %g4, jle_else.42682
	jne	%g5, %g4, jeq_else.42684
	addi	%g3, %g0, 3
	jmp	jeq_cont.42685
jeq_else.42684:
	mov	%g9, %g11
	subi	%g1, %g1, 32
	call	div_binary_search.2540
	addi	%g1, %g1, 32
jeq_cont.42685:
	jmp	jle_cont.42683
jle_else.42682:
	mov	%g27, %g10
	mov	%g10, %g9
	mov	%g9, %g27
	subi	%g1, %g1, 32
	call	div_binary_search.2540
	addi	%g1, %g1, 32
jle_cont.42683:
jle_cont.42675:
jeq_cont.42673:
	jmp	jle_cont.42671
jle_else.42670:
	addi	%g11, %g0, 7
	addi	%g5, %g0, 70
	jlt	%g5, %g4, jle_else.42686
	jne	%g5, %g4, jeq_else.42688
	addi	%g3, %g0, 7
	jmp	jeq_cont.42689
jeq_else.42688:
	addi	%g10, %g0, 6
	addi	%g5, %g0, 60
	jlt	%g5, %g4, jle_else.42690
	jne	%g5, %g4, jeq_else.42692
	addi	%g3, %g0, 6
	jmp	jeq_cont.42693
jeq_else.42692:
	subi	%g1, %g1, 32
	call	div_binary_search.2540
	addi	%g1, %g1, 32
jeq_cont.42693:
	jmp	jle_cont.42691
jle_else.42690:
	mov	%g9, %g10
	mov	%g10, %g11
	subi	%g1, %g1, 32
	call	div_binary_search.2540
	addi	%g1, %g1, 32
jle_cont.42691:
jeq_cont.42689:
	jmp	jle_cont.42687
jle_else.42686:
	addi	%g9, %g0, 8
	addi	%g5, %g0, 80
	jlt	%g5, %g4, jle_else.42694
	jne	%g5, %g4, jeq_else.42696
	addi	%g3, %g0, 8
	jmp	jeq_cont.42697
jeq_else.42696:
	mov	%g10, %g9
	mov	%g9, %g11
	subi	%g1, %g1, 32
	call	div_binary_search.2540
	addi	%g1, %g1, 32
jeq_cont.42697:
	jmp	jle_cont.42695
jle_else.42694:
	subi	%g1, %g1, 32
	call	div_binary_search.2540
	addi	%g1, %g1, 32
jle_cont.42695:
jle_cont.42687:
jle_cont.42671:
	muli	%g5, %g3, 10
	ldi	%g4, %g1, 24
	sub	%g4, %g4, %g5
	jlt	%g0, %g3, jle_else.42698
	jne	%g13, %g0, jeq_else.42700
	addi	%g5, %g0, 0
	jmp	jeq_cont.42701
jeq_else.42700:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g5, %g0, 1
jeq_cont.42701:
	jmp	jle_cont.42699
jle_else.42698:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g5, %g0, 1
jle_cont.42699:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g4
	output	%g3
	return
jge_else.42467:
	addi	%g3, %g0, 45
	output	%g3
	sub	%g4, %g0, %g4
	jmp	print_int.2545

!==============================
! args = [%g8]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g2, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f29, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
read_object.2713:
	addi	%g3, %g0, 60
	jlt	%g8, %g3, jle_else.42702
	return
jle_else.42702:
	sti	%g8, %g1, 0
	subi	%g1, %g1, 8
	call	min_caml_read_int
	addi	%g1, %g1, 8
	mov	%g11, %g3
	jne	%g11, %g29, jeq_else.42704
	addi	%g3, %g0, 0
	jmp	jeq_cont.42705
jeq_else.42704:
	sti	%g11, %g1, 4
	subi	%g1, %g1, 12
	call	min_caml_read_int
	addi	%g1, %g1, 12
	mov	%g6, %g3
	sti	%g6, %g1, 8
	subi	%g1, %g1, 16
	call	min_caml_read_int
	addi	%g1, %g1, 16
	mov	%g12, %g3
	sti	%g12, %g1, 12
	subi	%g1, %g1, 20
	call	min_caml_read_int
	mov	%g7, %g3
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	addi	%g1, %g1, 20
	mov	%g5, %g3
	sti	%g7, %g1, 16
	sti	%g5, %g1, 20
	subi	%g1, %g1, 28
	call	min_caml_read_float
	addi	%g1, %g1, 28
	ldi	%g5, %g1, 20
	fsti	%f0, %g5, 0
	subi	%g1, %g1, 28
	call	min_caml_read_float
	addi	%g1, %g1, 28
	ldi	%g5, %g1, 20
	fsti	%f0, %g5, -4
	subi	%g1, %g1, 28
	call	min_caml_read_float
	addi	%g1, %g1, 28
	ldi	%g5, %g1, 20
	fsti	%f0, %g5, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 28
	call	min_caml_create_float_array
	addi	%g1, %g1, 28
	mov	%g10, %g3
	sti	%g10, %g1, 24
	subi	%g1, %g1, 32
	call	min_caml_read_float
	addi	%g1, %g1, 32
	ldi	%g10, %g1, 24
	fsti	%f0, %g10, 0
	subi	%g1, %g1, 32
	call	min_caml_read_float
	addi	%g1, %g1, 32
	ldi	%g10, %g1, 24
	fsti	%f0, %g10, -4
	subi	%g1, %g1, 32
	call	min_caml_read_float
	addi	%g1, %g1, 32
	ldi	%g10, %g1, 24
	fsti	%f0, %g10, -8
	subi	%g1, %g1, 32
	call	min_caml_read_float
	fmov	%f2, %f0
	addi	%g3, %g0, 2
	fmov	%f0, %f16
	call	min_caml_create_float_array
	addi	%g1, %g1, 32
	mov	%g13, %g3
	fsti	%f2, %g1, 28
	sti	%g13, %g1, 32
	subi	%g1, %g1, 40
	call	min_caml_read_float
	addi	%g1, %g1, 40
	ldi	%g13, %g1, 32
	fsti	%f0, %g13, 0
	subi	%g1, %g1, 40
	call	min_caml_read_float
	addi	%g1, %g1, 40
	ldi	%g13, %g1, 32
	fsti	%f0, %g13, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 40
	call	min_caml_create_float_array
	addi	%g1, %g1, 40
	mov	%g14, %g3
	sti	%g14, %g1, 36
	subi	%g1, %g1, 44
	call	min_caml_read_float
	addi	%g1, %g1, 44
	ldi	%g14, %g1, 36
	fsti	%f0, %g14, 0
	subi	%g1, %g1, 44
	call	min_caml_read_float
	addi	%g1, %g1, 44
	ldi	%g14, %g1, 36
	fsti	%f0, %g14, -4
	subi	%g1, %g1, 44
	call	min_caml_read_float
	addi	%g1, %g1, 44
	ldi	%g14, %g1, 36
	fsti	%f0, %g14, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 44
	call	min_caml_create_float_array
	addi	%g1, %g1, 44
	ldi	%g7, %g1, 16
	jne	%g7, %g0, jeq_else.42706
	jmp	jeq_cont.42707
jeq_else.42706:
	sti	%g3, %g1, 40
	subi	%g1, %g1, 48
	call	min_caml_read_float
	addi	%g1, %g1, 48
	setL %g4, l.35957
	fldi	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	ldi	%g3, %g1, 40
	fsti	%f0, %g3, 0
	fsti	%f1, %g1, 44
	subi	%g1, %g1, 52
	call	min_caml_read_float
	addi	%g1, %g1, 52
	fldi	%f1, %g1, 44
	fmul	%f0, %f0, %f1
	ldi	%g3, %g1, 40
	fsti	%f0, %g3, -4
	subi	%g1, %g1, 52
	call	min_caml_read_float
	addi	%g1, %g1, 52
	fldi	%f1, %g1, 44
	fmul	%f0, %f0, %f1
	ldi	%g3, %g1, 40
	fsti	%f0, %g3, -8
jeq_cont.42707:
	addi	%g15, %g0, 2
	ldi	%g6, %g1, 8
	jne	%g6, %g15, jeq_else.42708
	addi	%g15, %g0, 1
	jmp	jeq_cont.42709
jeq_else.42708:
	fldi	%f2, %g1, 28
	fjlt	%f2, %f16, fjge_else.42710
	addi	%g15, %g0, 0
	jmp	fjge_cont.42711
fjge_else.42710:
	addi	%g15, %g0, 1
fjge_cont.42711:
jeq_cont.42709:
	addi	%g9, %g0, 4
	sti	%g3, %g1, 40
	mov	%g3, %g9
	fmov	%f0, %f16
	subi	%g1, %g1, 52
	call	min_caml_create_float_array
	addi	%g1, %g1, 52
	mov	%g9, %g3
	mov	%g4, %g2
	addi	%g2, %g2, 44
	sti	%g9, %g4, -40
	ldi	%g3, %g1, 40
	sti	%g3, %g4, -36
	ldi	%g14, %g1, 36
	sti	%g14, %g4, -32
	ldi	%g13, %g1, 32
	sti	%g13, %g4, -28
	sti	%g15, %g4, -24
	ldi	%g10, %g1, 24
	sti	%g10, %g4, -20
	ldi	%g5, %g1, 20
	sti	%g5, %g4, -16
	ldi	%g7, %g1, 16
	sti	%g7, %g4, -12
	ldi	%g12, %g1, 12
	sti	%g12, %g4, -8
	sti	%g6, %g4, -4
	ldi	%g11, %g1, 4
	sti	%g11, %g4, 0
	ldi	%g8, %g1, 0
	slli	%g9, %g8, 2
	add	%g9, %g31, %g9
	sti	%g4, %g9, 272
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.42712
	fldi	%f1, %g5, 0
	fjeq	%f1, %f16, fjne_else.42714
	fjeq	%f1, %f16, fjne_else.42716
	fjlt	%f16, %f1, fjge_else.42718
	setL %g4, l.36354
	fldi	%f0, %g4, 0
	jmp	fjge_cont.42719
fjge_else.42718:
	setL %g4, l.35959
	fldi	%f0, %g4, 0
fjge_cont.42719:
	jmp	fjne_cont.42717
fjne_else.42716:
	fmov	%f0, %f16
fjne_cont.42717:
	fmul	%f1, %f1, %f1
	fdiv	%f0, %f0, %f1
	jmp	fjne_cont.42715
fjne_else.42714:
	fmov	%f0, %f16
fjne_cont.42715:
	fsti	%f0, %g5, 0
	fldi	%f1, %g5, -4
	fjeq	%f1, %f16, fjne_else.42720
	fjeq	%f1, %f16, fjne_else.42722
	fjlt	%f16, %f1, fjge_else.42724
	setL %g4, l.36354
	fldi	%f0, %g4, 0
	jmp	fjge_cont.42725
fjge_else.42724:
	setL %g4, l.35959
	fldi	%f0, %g4, 0
fjge_cont.42725:
	jmp	fjne_cont.42723
fjne_else.42722:
	fmov	%f0, %f16
fjne_cont.42723:
	fmul	%f1, %f1, %f1
	fdiv	%f0, %f0, %f1
	jmp	fjne_cont.42721
fjne_else.42720:
	fmov	%f0, %f16
fjne_cont.42721:
	fsti	%f0, %g5, -4
	fldi	%f1, %g5, -8
	fjeq	%f1, %f16, fjne_else.42726
	fjeq	%f1, %f16, fjne_else.42728
	fjlt	%f16, %f1, fjge_else.42730
	setL %g4, l.36354
	fldi	%f0, %g4, 0
	jmp	fjge_cont.42731
fjge_else.42730:
	setL %g4, l.35959
	fldi	%f0, %g4, 0
fjge_cont.42731:
	jmp	fjne_cont.42729
fjne_else.42728:
	fmov	%f0, %f16
fjne_cont.42729:
	fmul	%f1, %f1, %f1
	fdiv	%f0, %f0, %f1
	jmp	fjne_cont.42727
fjne_else.42726:
	fmov	%f0, %f16
fjne_cont.42727:
	fsti	%f0, %g5, -8
	jmp	jeq_cont.42713
jeq_else.42712:
	addi	%g4, %g0, 2
	jne	%g6, %g4, jeq_else.42732
	fldi	%f1, %g5, 0
	fmul	%f3, %f1, %f1
	fldi	%f0, %g5, -4
	fmul	%f0, %f0, %f0
	fadd	%f3, %f3, %f0
	fldi	%f0, %g5, -8
	fmul	%f0, %f0, %f0
	fadd	%f0, %f3, %f0
	fsqrt	%f3, %f0
	fjeq	%f3, %f16, fjne_else.42734
	fldi	%f2, %g1, 28
	fjlt	%f2, %f16, fjge_else.42736
	fdiv	%f0, %f20, %f3
	jmp	fjge_cont.42737
fjge_else.42736:
	fdiv	%f0, %f17, %f3
fjge_cont.42737:
	jmp	fjne_cont.42735
fjne_else.42734:
	setL %g4, l.35959
	fldi	%f0, %g4, 0
fjne_cont.42735:
	fmul	%f1, %f1, %f0
	fsti	%f1, %g5, 0
	fldi	%f1, %g5, -4
	fmul	%f1, %f1, %f0
	fsti	%f1, %g5, -4
	fldi	%f1, %g5, -8
	fmul	%f0, %f1, %f0
	fsti	%f0, %g5, -8
	jmp	jeq_cont.42733
jeq_else.42732:
jeq_cont.42733:
jeq_cont.42713:
	jne	%g7, %g0, jeq_else.42738
	jmp	jeq_cont.42739
jeq_else.42738:
	fldi	%f3, %g3, 0
	fsub	%f2, %f22, %f3
	setL %g4, l.35801
	fldi	%f4, %g4, 0
	setL %g4, l.35803
	fldi	%f14, %g4, 0
	fjlt	%f2, %f16, fjge_else.42740
	fmov	%f1, %f2
	jmp	fjge_cont.42741
fjge_else.42740:
	fneg	%f1, %f2
fjge_cont.42741:
	fjlt	%f29, %f1, fjge_else.42742
	fjlt	%f1, %f16, fjge_else.42744
	fmov	%f0, %f1
	jmp	fjge_cont.42745
fjge_else.42744:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42746
	fjlt	%f1, %f16, fjge_else.42748
	fmov	%f0, %f1
	jmp	fjge_cont.42749
fjge_else.42748:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42750
	fjlt	%f1, %f16, fjge_else.42752
	fmov	%f0, %f1
	jmp	fjge_cont.42753
fjge_else.42752:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 52
	call	sin_sub.2518
	addi	%g1, %g1, 52
fjge_cont.42753:
	jmp	fjge_cont.42751
fjge_else.42750:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 52
	call	sin_sub.2518
	addi	%g1, %g1, 52
fjge_cont.42751:
fjge_cont.42749:
	jmp	fjge_cont.42747
fjge_else.42746:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42754
	fjlt	%f1, %f16, fjge_else.42756
	fmov	%f0, %f1
	jmp	fjge_cont.42757
fjge_else.42756:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 52
	call	sin_sub.2518
	addi	%g1, %g1, 52
fjge_cont.42757:
	jmp	fjge_cont.42755
fjge_else.42754:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 52
	call	sin_sub.2518
	addi	%g1, %g1, 52
fjge_cont.42755:
fjge_cont.42747:
fjge_cont.42745:
	jmp	fjge_cont.42743
fjge_else.42742:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42758
	fjlt	%f1, %f16, fjge_else.42760
	fmov	%f0, %f1
	jmp	fjge_cont.42761
fjge_else.42760:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42762
	fjlt	%f1, %f16, fjge_else.42764
	fmov	%f0, %f1
	jmp	fjge_cont.42765
fjge_else.42764:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 52
	call	sin_sub.2518
	addi	%g1, %g1, 52
fjge_cont.42765:
	jmp	fjge_cont.42763
fjge_else.42762:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 52
	call	sin_sub.2518
	addi	%g1, %g1, 52
fjge_cont.42763:
fjge_cont.42761:
	jmp	fjge_cont.42759
fjge_else.42758:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42766
	fjlt	%f1, %f16, fjge_else.42768
	fmov	%f0, %f1
	jmp	fjge_cont.42769
fjge_else.42768:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 52
	call	sin_sub.2518
	addi	%g1, %g1, 52
fjge_cont.42769:
	jmp	fjge_cont.42767
fjge_else.42766:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 52
	call	sin_sub.2518
	addi	%g1, %g1, 52
fjge_cont.42767:
fjge_cont.42759:
fjge_cont.42743:
	fjlt	%f4, %f0, fjge_else.42770
	fjlt	%f16, %f2, fjge_else.42772
	addi	%g4, %g0, 0
	jmp	fjge_cont.42773
fjge_else.42772:
	addi	%g4, %g0, 1
fjge_cont.42773:
	jmp	fjge_cont.42771
fjge_else.42770:
	fjlt	%f16, %f2, fjge_else.42774
	addi	%g4, %g0, 1
	jmp	fjge_cont.42775
fjge_else.42774:
	addi	%g4, %g0, 0
fjge_cont.42775:
fjge_cont.42771:
	fjlt	%f4, %f0, fjge_else.42776
	fmov	%f1, %f0
	jmp	fjge_cont.42777
fjge_else.42776:
	fsub	%f1, %f29, %f0
fjge_cont.42777:
	fjlt	%f22, %f1, fjge_else.42778
	fmov	%f0, %f1
	jmp	fjge_cont.42779
fjge_else.42778:
	fsub	%f0, %f4, %f1
fjge_cont.42779:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f14, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g4, %g0, jeq_else.42780
	fneg	%f15, %f0
	jmp	jeq_cont.42781
jeq_else.42780:
	fmov	%f15, %f0
jeq_cont.42781:
	fjlt	%f3, %f16, fjge_else.42782
	fmov	%f1, %f3
	jmp	fjge_cont.42783
fjge_else.42782:
	fneg	%f1, %f3
fjge_cont.42783:
	fsti	%f15, %g1, 48
	fjlt	%f29, %f1, fjge_else.42784
	fjlt	%f1, %f16, fjge_else.42786
	fmov	%f0, %f1
	jmp	fjge_cont.42787
fjge_else.42786:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42788
	fjlt	%f1, %f16, fjge_else.42790
	fmov	%f0, %f1
	jmp	fjge_cont.42791
fjge_else.42790:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42792
	fjlt	%f1, %f16, fjge_else.42794
	fmov	%f0, %f1
	jmp	fjge_cont.42795
fjge_else.42794:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42795:
	jmp	fjge_cont.42793
fjge_else.42792:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42793:
fjge_cont.42791:
	jmp	fjge_cont.42789
fjge_else.42788:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42796
	fjlt	%f1, %f16, fjge_else.42798
	fmov	%f0, %f1
	jmp	fjge_cont.42799
fjge_else.42798:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42799:
	jmp	fjge_cont.42797
fjge_else.42796:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42797:
fjge_cont.42789:
fjge_cont.42787:
	jmp	fjge_cont.42785
fjge_else.42784:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42800
	fjlt	%f1, %f16, fjge_else.42802
	fmov	%f0, %f1
	jmp	fjge_cont.42803
fjge_else.42802:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42804
	fjlt	%f1, %f16, fjge_else.42806
	fmov	%f0, %f1
	jmp	fjge_cont.42807
fjge_else.42806:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42807:
	jmp	fjge_cont.42805
fjge_else.42804:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42805:
fjge_cont.42803:
	jmp	fjge_cont.42801
fjge_else.42800:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42808
	fjlt	%f1, %f16, fjge_else.42810
	fmov	%f0, %f1
	jmp	fjge_cont.42811
fjge_else.42810:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42811:
	jmp	fjge_cont.42809
fjge_else.42808:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42809:
fjge_cont.42801:
fjge_cont.42785:
	fjlt	%f4, %f0, fjge_else.42812
	fjlt	%f16, %f3, fjge_else.42814
	addi	%g4, %g0, 0
	jmp	fjge_cont.42815
fjge_else.42814:
	addi	%g4, %g0, 1
fjge_cont.42815:
	jmp	fjge_cont.42813
fjge_else.42812:
	fjlt	%f16, %f3, fjge_else.42816
	addi	%g4, %g0, 1
	jmp	fjge_cont.42817
fjge_else.42816:
	addi	%g4, %g0, 0
fjge_cont.42817:
fjge_cont.42813:
	fjlt	%f4, %f0, fjge_else.42818
	fmov	%f1, %f0
	jmp	fjge_cont.42819
fjge_else.42818:
	fsub	%f1, %f29, %f0
fjge_cont.42819:
	fjlt	%f22, %f1, fjge_else.42820
	fmov	%f0, %f1
	jmp	fjge_cont.42821
fjge_else.42820:
	fsub	%f0, %f4, %f1
fjge_cont.42821:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f14, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g4, %g0, jeq_else.42822
	fneg	%f7, %f0
	jmp	jeq_cont.42823
jeq_else.42822:
	fmov	%f7, %f0
jeq_cont.42823:
	fldi	%f3, %g3, -4
	fsub	%f2, %f22, %f3
	fjlt	%f2, %f16, fjge_else.42824
	fmov	%f1, %f2
	jmp	fjge_cont.42825
fjge_else.42824:
	fneg	%f1, %f2
fjge_cont.42825:
	fjlt	%f29, %f1, fjge_else.42826
	fjlt	%f1, %f16, fjge_else.42828
	fmov	%f0, %f1
	jmp	fjge_cont.42829
fjge_else.42828:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42830
	fjlt	%f1, %f16, fjge_else.42832
	fmov	%f0, %f1
	jmp	fjge_cont.42833
fjge_else.42832:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42834
	fjlt	%f1, %f16, fjge_else.42836
	fmov	%f0, %f1
	jmp	fjge_cont.42837
fjge_else.42836:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42837:
	jmp	fjge_cont.42835
fjge_else.42834:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42835:
fjge_cont.42833:
	jmp	fjge_cont.42831
fjge_else.42830:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42838
	fjlt	%f1, %f16, fjge_else.42840
	fmov	%f0, %f1
	jmp	fjge_cont.42841
fjge_else.42840:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42841:
	jmp	fjge_cont.42839
fjge_else.42838:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42839:
fjge_cont.42831:
fjge_cont.42829:
	jmp	fjge_cont.42827
fjge_else.42826:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42842
	fjlt	%f1, %f16, fjge_else.42844
	fmov	%f0, %f1
	jmp	fjge_cont.42845
fjge_else.42844:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42846
	fjlt	%f1, %f16, fjge_else.42848
	fmov	%f0, %f1
	jmp	fjge_cont.42849
fjge_else.42848:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42849:
	jmp	fjge_cont.42847
fjge_else.42846:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42847:
fjge_cont.42845:
	jmp	fjge_cont.42843
fjge_else.42842:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42850
	fjlt	%f1, %f16, fjge_else.42852
	fmov	%f0, %f1
	jmp	fjge_cont.42853
fjge_else.42852:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42853:
	jmp	fjge_cont.42851
fjge_else.42850:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42851:
fjge_cont.42843:
fjge_cont.42827:
	fjlt	%f4, %f0, fjge_else.42854
	fjlt	%f16, %f2, fjge_else.42856
	addi	%g4, %g0, 0
	jmp	fjge_cont.42857
fjge_else.42856:
	addi	%g4, %g0, 1
fjge_cont.42857:
	jmp	fjge_cont.42855
fjge_else.42854:
	fjlt	%f16, %f2, fjge_else.42858
	addi	%g4, %g0, 1
	jmp	fjge_cont.42859
fjge_else.42858:
	addi	%g4, %g0, 0
fjge_cont.42859:
fjge_cont.42855:
	fjlt	%f4, %f0, fjge_else.42860
	fmov	%f1, %f0
	jmp	fjge_cont.42861
fjge_else.42860:
	fsub	%f1, %f29, %f0
fjge_cont.42861:
	fjlt	%f22, %f1, fjge_else.42862
	fmov	%f0, %f1
	jmp	fjge_cont.42863
fjge_else.42862:
	fsub	%f0, %f4, %f1
fjge_cont.42863:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f1, %f1, %f0
	fmul	%f0, %f14, %f1
	fmul	%f1, %f1, %f1
	fadd	%f1, %f17, %f1
	fdiv	%f0, %f0, %f1
	jne	%g4, %g0, jeq_else.42864
	fneg	%f13, %f0
	jmp	jeq_cont.42865
jeq_else.42864:
	fmov	%f13, %f0
jeq_cont.42865:
	fjlt	%f3, %f16, fjge_else.42866
	fmov	%f1, %f3
	jmp	fjge_cont.42867
fjge_else.42866:
	fneg	%f1, %f3
fjge_cont.42867:
	fjlt	%f29, %f1, fjge_else.42868
	fjlt	%f1, %f16, fjge_else.42870
	fmov	%f0, %f1
	jmp	fjge_cont.42871
fjge_else.42870:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42872
	fjlt	%f1, %f16, fjge_else.42874
	fmov	%f0, %f1
	jmp	fjge_cont.42875
fjge_else.42874:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42876
	fjlt	%f1, %f16, fjge_else.42878
	fmov	%f0, %f1
	jmp	fjge_cont.42879
fjge_else.42878:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42879:
	jmp	fjge_cont.42877
fjge_else.42876:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42877:
fjge_cont.42875:
	jmp	fjge_cont.42873
fjge_else.42872:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42880
	fjlt	%f1, %f16, fjge_else.42882
	fmov	%f0, %f1
	jmp	fjge_cont.42883
fjge_else.42882:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42883:
	jmp	fjge_cont.42881
fjge_else.42880:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42881:
fjge_cont.42873:
fjge_cont.42871:
	jmp	fjge_cont.42869
fjge_else.42868:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42884
	fjlt	%f1, %f16, fjge_else.42886
	fmov	%f0, %f1
	jmp	fjge_cont.42887
fjge_else.42886:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42888
	fjlt	%f1, %f16, fjge_else.42890
	fmov	%f0, %f1
	jmp	fjge_cont.42891
fjge_else.42890:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42891:
	jmp	fjge_cont.42889
fjge_else.42888:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42889:
fjge_cont.42887:
	jmp	fjge_cont.42885
fjge_else.42884:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42892
	fjlt	%f1, %f16, fjge_else.42894
	fmov	%f0, %f1
	jmp	fjge_cont.42895
fjge_else.42894:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42895:
	jmp	fjge_cont.42893
fjge_else.42892:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42893:
fjge_cont.42885:
fjge_cont.42869:
	fjlt	%f4, %f0, fjge_else.42896
	fjlt	%f16, %f3, fjge_else.42898
	addi	%g4, %g0, 0
	jmp	fjge_cont.42899
fjge_else.42898:
	addi	%g4, %g0, 1
fjge_cont.42899:
	jmp	fjge_cont.42897
fjge_else.42896:
	fjlt	%f16, %f3, fjge_else.42900
	addi	%g4, %g0, 1
	jmp	fjge_cont.42901
fjge_else.42900:
	addi	%g4, %g0, 0
fjge_cont.42901:
fjge_cont.42897:
	fjlt	%f4, %f0, fjge_else.42902
	fmov	%f1, %f0
	jmp	fjge_cont.42903
fjge_else.42902:
	fsub	%f1, %f29, %f0
fjge_cont.42903:
	fjlt	%f22, %f1, fjge_else.42904
	fmov	%f0, %f1
	jmp	fjge_cont.42905
fjge_else.42904:
	fsub	%f0, %f4, %f1
fjge_cont.42905:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f1, %f1, %f0
	fmul	%f0, %f14, %f1
	fmul	%f1, %f1, %f1
	fadd	%f1, %f17, %f1
	fdiv	%f0, %f0, %f1
	jne	%g4, %g0, jeq_else.42906
	fneg	%f9, %f0
	jmp	jeq_cont.42907
jeq_else.42906:
	fmov	%f9, %f0
jeq_cont.42907:
	fldi	%f3, %g3, -8
	fsub	%f2, %f22, %f3
	fjlt	%f2, %f16, fjge_else.42908
	fmov	%f1, %f2
	jmp	fjge_cont.42909
fjge_else.42908:
	fneg	%f1, %f2
fjge_cont.42909:
	fjlt	%f29, %f1, fjge_else.42910
	fjlt	%f1, %f16, fjge_else.42912
	fmov	%f0, %f1
	jmp	fjge_cont.42913
fjge_else.42912:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42914
	fjlt	%f1, %f16, fjge_else.42916
	fmov	%f0, %f1
	jmp	fjge_cont.42917
fjge_else.42916:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42918
	fjlt	%f1, %f16, fjge_else.42920
	fmov	%f0, %f1
	jmp	fjge_cont.42921
fjge_else.42920:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42921:
	jmp	fjge_cont.42919
fjge_else.42918:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42919:
fjge_cont.42917:
	jmp	fjge_cont.42915
fjge_else.42914:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42922
	fjlt	%f1, %f16, fjge_else.42924
	fmov	%f0, %f1
	jmp	fjge_cont.42925
fjge_else.42924:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42925:
	jmp	fjge_cont.42923
fjge_else.42922:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42923:
fjge_cont.42915:
fjge_cont.42913:
	jmp	fjge_cont.42911
fjge_else.42910:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42926
	fjlt	%f1, %f16, fjge_else.42928
	fmov	%f0, %f1
	jmp	fjge_cont.42929
fjge_else.42928:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42930
	fjlt	%f1, %f16, fjge_else.42932
	fmov	%f0, %f1
	jmp	fjge_cont.42933
fjge_else.42932:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42933:
	jmp	fjge_cont.42931
fjge_else.42930:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42931:
fjge_cont.42929:
	jmp	fjge_cont.42927
fjge_else.42926:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42934
	fjlt	%f1, %f16, fjge_else.42936
	fmov	%f0, %f1
	jmp	fjge_cont.42937
fjge_else.42936:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42937:
	jmp	fjge_cont.42935
fjge_else.42934:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42935:
fjge_cont.42927:
fjge_cont.42911:
	fjlt	%f4, %f0, fjge_else.42938
	fjlt	%f16, %f2, fjge_else.42940
	addi	%g4, %g0, 0
	jmp	fjge_cont.42941
fjge_else.42940:
	addi	%g4, %g0, 1
fjge_cont.42941:
	jmp	fjge_cont.42939
fjge_else.42938:
	fjlt	%f16, %f2, fjge_else.42942
	addi	%g4, %g0, 1
	jmp	fjge_cont.42943
fjge_else.42942:
	addi	%g4, %g0, 0
fjge_cont.42943:
fjge_cont.42939:
	fjlt	%f4, %f0, fjge_else.42944
	fmov	%f1, %f0
	jmp	fjge_cont.42945
fjge_else.42944:
	fsub	%f1, %f29, %f0
fjge_cont.42945:
	fjlt	%f22, %f1, fjge_else.42946
	fmov	%f0, %f1
	jmp	fjge_cont.42947
fjge_else.42946:
	fsub	%f0, %f4, %f1
fjge_cont.42947:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f14, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g4, %g0, jeq_else.42948
	fneg	%f2, %f0
	jmp	jeq_cont.42949
jeq_else.42948:
	fmov	%f2, %f0
jeq_cont.42949:
	fjlt	%f3, %f16, fjge_else.42950
	fmov	%f1, %f3
	jmp	fjge_cont.42951
fjge_else.42950:
	fneg	%f1, %f3
fjge_cont.42951:
	fjlt	%f29, %f1, fjge_else.42952
	fjlt	%f1, %f16, fjge_else.42954
	fmov	%f0, %f1
	jmp	fjge_cont.42955
fjge_else.42954:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42956
	fjlt	%f1, %f16, fjge_else.42958
	fmov	%f0, %f1
	jmp	fjge_cont.42959
fjge_else.42958:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42960
	fjlt	%f1, %f16, fjge_else.42962
	fmov	%f0, %f1
	jmp	fjge_cont.42963
fjge_else.42962:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42963:
	jmp	fjge_cont.42961
fjge_else.42960:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42961:
fjge_cont.42959:
	jmp	fjge_cont.42957
fjge_else.42956:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42964
	fjlt	%f1, %f16, fjge_else.42966
	fmov	%f0, %f1
	jmp	fjge_cont.42967
fjge_else.42966:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42967:
	jmp	fjge_cont.42965
fjge_else.42964:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42965:
fjge_cont.42957:
fjge_cont.42955:
	jmp	fjge_cont.42953
fjge_else.42952:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42968
	fjlt	%f1, %f16, fjge_else.42970
	fmov	%f0, %f1
	jmp	fjge_cont.42971
fjge_else.42970:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42972
	fjlt	%f1, %f16, fjge_else.42974
	fmov	%f0, %f1
	jmp	fjge_cont.42975
fjge_else.42974:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42975:
	jmp	fjge_cont.42973
fjge_else.42972:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42973:
fjge_cont.42971:
	jmp	fjge_cont.42969
fjge_else.42968:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.42976
	fjlt	%f1, %f16, fjge_else.42978
	fmov	%f0, %f1
	jmp	fjge_cont.42979
fjge_else.42978:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42979:
	jmp	fjge_cont.42977
fjge_else.42976:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 56
	call	sin_sub.2518
	addi	%g1, %g1, 56
fjge_cont.42977:
fjge_cont.42969:
fjge_cont.42953:
	fjlt	%f4, %f0, fjge_else.42980
	fjlt	%f16, %f3, fjge_else.42982
	addi	%g4, %g0, 0
	jmp	fjge_cont.42983
fjge_else.42982:
	addi	%g4, %g0, 1
fjge_cont.42983:
	jmp	fjge_cont.42981
fjge_else.42980:
	fjlt	%f16, %f3, fjge_else.42984
	addi	%g4, %g0, 1
	jmp	fjge_cont.42985
fjge_else.42984:
	addi	%g4, %g0, 0
fjge_cont.42985:
fjge_cont.42981:
	fjlt	%f4, %f0, fjge_else.42986
	fmov	%f1, %f0
	jmp	fjge_cont.42987
fjge_else.42986:
	fsub	%f1, %f29, %f0
fjge_cont.42987:
	fjlt	%f22, %f1, fjge_else.42988
	fmov	%f0, %f1
	jmp	fjge_cont.42989
fjge_else.42988:
	fsub	%f0, %f4, %f1
fjge_cont.42989:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f3, %f0, %f25
	fsub	%f3, %f26, %f3
	fdiv	%f3, %f0, %f3
	fsub	%f3, %f24, %f3
	fdiv	%f3, %f0, %f3
	fsub	%f3, %f23, %f3
	fdiv	%f0, %f0, %f3
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f14, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f1, %f0
	jne	%g4, %g0, jeq_else.42990
	fneg	%f0, %f1
	jmp	jeq_cont.42991
jeq_else.42990:
	fmov	%f0, %f1
jeq_cont.42991:
	fmul	%f12, %f13, %f2
	fmul	%f5, %f7, %f9
	fmul	%f3, %f5, %f2
	fldi	%f15, %g1, 48
	fmul	%f1, %f15, %f0
	fsub	%f10, %f3, %f1
	fmul	%f1, %f15, %f9
	fmul	%f4, %f1, %f2
	fmul	%f3, %f7, %f0
	fadd	%f6, %f4, %f3
	fmul	%f11, %f13, %f0
	fmul	%f4, %f5, %f0
	fmul	%f3, %f15, %f2
	fadd	%f8, %f4, %f3
	fmul	%f1, %f1, %f0
	fmul	%f0, %f7, %f2
	fsub	%f5, %f1, %f0
	fneg	%f9, %f9
	fmul	%f7, %f7, %f13
	fmul	%f4, %f15, %f13
	fldi	%f0, %g5, 0
	fldi	%f2, %g5, -4
	fldi	%f3, %g5, -8
	fmul	%f1, %f12, %f12
	fmul	%f13, %f0, %f1
	fmul	%f1, %f11, %f11
	fmul	%f1, %f2, %f1
	fadd	%f13, %f13, %f1
	fmul	%f1, %f9, %f9
	fmul	%f1, %f3, %f1
	fadd	%f1, %f13, %f1
	fsti	%f1, %g5, 0
	fmul	%f1, %f10, %f10
	fmul	%f13, %f0, %f1
	fmul	%f1, %f8, %f8
	fmul	%f1, %f2, %f1
	fadd	%f13, %f13, %f1
	fmul	%f1, %f7, %f7
	fmul	%f1, %f3, %f1
	fadd	%f1, %f13, %f1
	fsti	%f1, %g5, -4
	fmul	%f1, %f6, %f6
	fmul	%f13, %f0, %f1
	fmul	%f1, %f5, %f5
	fmul	%f1, %f2, %f1
	fadd	%f13, %f13, %f1
	fmul	%f1, %f4, %f4
	fmul	%f1, %f3, %f1
	fadd	%f1, %f13, %f1
	fsti	%f1, %g5, -8
	fmul	%f1, %f0, %f10
	fmul	%f13, %f1, %f6
	fmul	%f1, %f2, %f8
	fmul	%f1, %f1, %f5
	fadd	%f13, %f13, %f1
	fmul	%f1, %f3, %f7
	fmul	%f1, %f1, %f4
	fadd	%f1, %f13, %f1
	fmul	%f1, %f14, %f1
	fsti	%f1, %g3, 0
	fmul	%f1, %f0, %f12
	fmul	%f6, %f1, %f6
	fmul	%f0, %f2, %f11
	fmul	%f2, %f0, %f5
	fadd	%f5, %f6, %f2
	fmul	%f3, %f3, %f9
	fmul	%f2, %f3, %f4
	fadd	%f2, %f5, %f2
	fmul	%f2, %f14, %f2
	fsti	%f2, %g3, -4
	fmul	%f1, %f1, %f10
	fmul	%f0, %f0, %f8
	fadd	%f1, %f1, %f0
	fmul	%f0, %f3, %f7
	fadd	%f0, %f1, %f0
	fmul	%f0, %f14, %f0
	fsti	%f0, %g3, -8
jeq_cont.42739:
	addi	%g3, %g0, 1
jeq_cont.42705:
	jne	%g3, %g0, jeq_else.42992
	ldi	%g8, %g1, 0
	sti	%g8, %g31, 28
	return
jeq_else.42992:
	ldi	%g8, %g1, 0
	addi	%g8, %g8, 1
	jmp	read_object.2713

!==============================
! args = [%g4]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Array(Int)
!================================
read_net_item.2717:
	sti	%g4, %g1, 0
	subi	%g1, %g1, 8
	call	min_caml_read_int
	addi	%g1, %g1, 8
	mov	%g5, %g3
	jne	%g5, %g29, jeq_else.42994
	ldi	%g4, %g1, 0
	addi	%g3, %g4, 1
	addi	%g4, %g0, -1
	jmp	min_caml_create_array
jeq_else.42994:
	ldi	%g4, %g1, 0
	addi	%g3, %g4, 1
	sti	%g5, %g1, 4
	mov	%g4, %g3
	subi	%g1, %g1, 12
	call	read_net_item.2717
	addi	%g1, %g1, 12
	ldi	%g4, %g1, 0
	slli	%g4, %g4, 2
	ldi	%g5, %g1, 4
	st	%g5, %g3, %g4
	return

!==============================
! args = [%g4]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Array(Array(Int))
!================================
read_or_network.2719:
	addi	%g3, %g0, 0
	sti	%g4, %g1, 0
	mov	%g4, %g3
	subi	%g1, %g1, 8
	call	read_net_item.2717
	addi	%g1, %g1, 8
	mov	%g6, %g3
	ldi	%g3, %g6, 0
	jne	%g3, %g29, jeq_else.42995
	ldi	%g4, %g1, 0
	addi	%g3, %g4, 1
	mov	%g4, %g6
	jmp	min_caml_create_array
jeq_else.42995:
	ldi	%g4, %g1, 0
	addi	%g3, %g4, 1
	sti	%g6, %g1, 4
	mov	%g4, %g3
	subi	%g1, %g1, 12
	call	read_or_network.2719
	addi	%g1, %g1, 12
	ldi	%g4, %g1, 0
	slli	%g4, %g4, 2
	ldi	%g6, %g1, 4
	st	%g6, %g3, %g4
	return

!==============================
! args = [%g3]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
read_and_network.2721:
	addi	%g4, %g0, 0
	sti	%g3, %g1, 0
	subi	%g1, %g1, 8
	call	read_net_item.2717
	addi	%g1, %g1, 8
	mov	%g4, %g3
	ldi	%g5, %g4, 0
	jne	%g5, %g29, jeq_else.42996
	return
jeq_else.42996:
	ldi	%g3, %g1, 0
	slli	%g5, %g3, 2
	add	%g5, %g31, %g5
	sti	%g4, %g5, 512
	addi	%g3, %g3, 1
	jmp	read_and_network.2721

!==============================
! args = [%g7, %g6, %g5]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g10, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f20, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
iter_setup_dirvec_constants.2818:
	jlt	%g5, %g0, jge_else.42998
	slli	%g3, %g5, 2
	add	%g3, %g31, %g3
	ldi	%g9, %g3, 272
	ldi	%g3, %g9, -4
	jne	%g3, %g28, jeq_else.42999
	addi	%g3, %g0, 6
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	fldi	%f0, %g7, 0
	fjeq	%f0, %f16, fjne_else.43001
	ldi	%g4, %g9, -24
	fjlt	%f0, %f16, fjge_else.43003
	addi	%g10, %g0, 0
	jmp	fjge_cont.43004
fjge_else.43003:
	addi	%g10, %g0, 1
fjge_cont.43004:
	ldi	%g8, %g9, -16
	fldi	%f1, %g8, 0
	jne	%g4, %g10, jeq_else.43005
	fneg	%f0, %f1
	jmp	jeq_cont.43006
jeq_else.43005:
	fmov	%f0, %f1
jeq_cont.43006:
	fsti	%f0, %g3, 0
	fldi	%f0, %g7, 0
	fdiv	%f0, %f17, %f0
	fsti	%f0, %g3, -4
	jmp	fjne_cont.43002
fjne_else.43001:
	fsti	%f16, %g3, -4
fjne_cont.43002:
	fldi	%f0, %g7, -4
	fjeq	%f0, %f16, fjne_else.43007
	ldi	%g4, %g9, -24
	fjlt	%f0, %f16, fjge_else.43009
	addi	%g10, %g0, 0
	jmp	fjge_cont.43010
fjge_else.43009:
	addi	%g10, %g0, 1
fjge_cont.43010:
	ldi	%g8, %g9, -16
	fldi	%f1, %g8, -4
	jne	%g4, %g10, jeq_else.43011
	fneg	%f0, %f1
	jmp	jeq_cont.43012
jeq_else.43011:
	fmov	%f0, %f1
jeq_cont.43012:
	fsti	%f0, %g3, -8
	fldi	%f0, %g7, -4
	fdiv	%f0, %f17, %f0
	fsti	%f0, %g3, -12
	jmp	fjne_cont.43008
fjne_else.43007:
	fsti	%f16, %g3, -12
fjne_cont.43008:
	fldi	%f0, %g7, -8
	fjeq	%f0, %f16, fjne_else.43013
	ldi	%g4, %g9, -24
	fjlt	%f0, %f16, fjge_else.43015
	addi	%g10, %g0, 0
	jmp	fjge_cont.43016
fjge_else.43015:
	addi	%g10, %g0, 1
fjge_cont.43016:
	ldi	%g8, %g9, -16
	fldi	%f1, %g8, -8
	jne	%g4, %g10, jeq_else.43017
	fneg	%f0, %f1
	jmp	jeq_cont.43018
jeq_else.43017:
	fmov	%f0, %f1
jeq_cont.43018:
	fsti	%f0, %g3, -16
	fldi	%f0, %g7, -8
	fdiv	%f0, %f17, %f0
	fsti	%f0, %g3, -20
	jmp	fjne_cont.43014
fjne_else.43013:
	fsti	%f16, %g3, -20
fjne_cont.43014:
	slli	%g4, %g5, 2
	st	%g3, %g6, %g4
	jmp	jeq_cont.43000
jeq_else.42999:
	addi	%g4, %g0, 2
	jne	%g3, %g4, jeq_else.43019
	addi	%g3, %g0, 4
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	fldi	%f1, %g7, 0
	ldi	%g4, %g9, -16
	fldi	%f0, %g4, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g7, -4
	fldi	%f0, %g4, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g7, -8
	fldi	%f0, %g4, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f16, %f0, fjge_else.43021
	fsti	%f16, %g3, 0
	jmp	fjge_cont.43022
fjge_else.43021:
	fdiv	%f1, %f20, %f0
	fsti	%f1, %g3, 0
	fldi	%f1, %g4, 0
	fdiv	%f1, %f1, %f0
	fneg	%f1, %f1
	fsti	%f1, %g3, -4
	fldi	%f1, %g4, -4
	fdiv	%f1, %f1, %f0
	fneg	%f1, %f1
	fsti	%f1, %g3, -8
	fldi	%f1, %g4, -8
	fdiv	%f0, %f1, %f0
	fneg	%f0, %f0
	fsti	%f0, %g3, -12
fjge_cont.43022:
	slli	%g4, %g5, 2
	st	%g3, %g6, %g4
	jmp	jeq_cont.43020
jeq_else.43019:
	addi	%g3, %g0, 5
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	fldi	%f0, %g7, 0
	fldi	%f1, %g7, -4
	fldi	%f2, %g7, -8
	fmul	%f3, %f0, %f0
	ldi	%g4, %g9, -16
	fldi	%f5, %g4, 0
	fmul	%f4, %f3, %f5
	fmul	%f3, %f1, %f1
	fldi	%f6, %g4, -4
	fmul	%f3, %f3, %f6
	fadd	%f7, %f4, %f3
	fmul	%f3, %f2, %f2
	fldi	%f4, %g4, -8
	fmul	%f3, %f3, %f4
	fadd	%f7, %f7, %f3
	ldi	%g8, %g9, -12
	jne	%g8, %g0, jeq_else.43023
	fmov	%f3, %f7
	jmp	jeq_cont.43024
jeq_else.43023:
	fmul	%f8, %f1, %f2
	ldi	%g4, %g9, -36
	fldi	%f3, %g4, 0
	fmul	%f3, %f8, %f3
	fadd	%f8, %f7, %f3
	fmul	%f7, %f2, %f0
	fldi	%f3, %g4, -4
	fmul	%f3, %f7, %f3
	fadd	%f8, %f8, %f3
	fmul	%f7, %f0, %f1
	fldi	%f3, %g4, -8
	fmul	%f3, %f7, %f3
	fadd	%f3, %f8, %f3
jeq_cont.43024:
	fmul	%f0, %f0, %f5
	fneg	%f0, %f0
	fmul	%f1, %f1, %f6
	fneg	%f1, %f1
	fmul	%f2, %f2, %f4
	fneg	%f2, %f2
	fsti	%f3, %g3, 0
	jne	%g8, %g0, jeq_else.43025
	fsti	%f0, %g3, -4
	fsti	%f1, %g3, -8
	fsti	%f2, %g3, -12
	jmp	jeq_cont.43026
jeq_else.43025:
	fldi	%f5, %g7, -8
	ldi	%g4, %g9, -36
	fldi	%f4, %g4, -4
	fmul	%f6, %f5, %f4
	fldi	%f5, %g7, -4
	fldi	%f4, %g4, -8
	fmul	%f4, %f5, %f4
	fadd	%f4, %f6, %f4
	fmul	%f4, %f4, %f21
	fsub	%f0, %f0, %f4
	fsti	%f0, %g3, -4
	fldi	%f4, %g7, -8
	fldi	%f0, %g4, 0
	fmul	%f5, %f4, %f0
	fldi	%f4, %g7, 0
	fldi	%f0, %g4, -8
	fmul	%f0, %f4, %f0
	fadd	%f0, %f5, %f0
	fmul	%f0, %f0, %f21
	fsub	%f0, %f1, %f0
	fsti	%f0, %g3, -8
	fldi	%f1, %g7, -4
	fldi	%f0, %g4, 0
	fmul	%f4, %f1, %f0
	fldi	%f1, %g7, 0
	fldi	%f0, %g4, -4
	fmul	%f0, %f1, %f0
	fadd	%f0, %f4, %f0
	fmul	%f0, %f0, %f21
	fsub	%f0, %f2, %f0
	fsti	%f0, %g3, -12
jeq_cont.43026:
	fjeq	%f3, %f16, fjne_else.43027
	fdiv	%f0, %f17, %f3
	fsti	%f0, %g3, -16
	jmp	fjne_cont.43028
fjne_else.43027:
fjne_cont.43028:
	slli	%g4, %g5, 2
	st	%g3, %g6, %g4
jeq_cont.43020:
jeq_cont.43000:
	subi	%g5, %g5, 1
	jmp	iter_setup_dirvec_constants.2818
jge_else.42998:
	return

!==============================
! args = [%g3, %g4]
! fargs = []
! use_regs = [%g8, %g7, %g6, %g5, %g4, %g3, %g27, %f5, %f4, %f3, %f2, %f17, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
setup_startp_constants.2823:
	jlt	%g4, %g0, jge_else.43030
	slli	%g5, %g4, 2
	add	%g5, %g31, %g5
	ldi	%g5, %g5, 272
	ldi	%g8, %g5, -40
	ldi	%g7, %g5, -4
	fldi	%f1, %g3, 0
	ldi	%g6, %g5, -20
	fldi	%f0, %g6, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g8, 0
	fldi	%f1, %g3, -4
	fldi	%f0, %g6, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g8, -4
	fldi	%f1, %g3, -8
	fldi	%f0, %g6, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g8, -8
	addi	%g6, %g0, 2
	jne	%g7, %g6, jeq_else.43031
	ldi	%g5, %g5, -16
	fldi	%f1, %g8, 0
	fldi	%f3, %g8, -4
	fldi	%f2, %g8, -8
	fldi	%f0, %g5, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g5, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g5, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g8, -12
	jmp	jeq_cont.43032
jeq_else.43031:
	addi	%g6, %g0, 2
	jlt	%g6, %g7, jle_else.43033
	jmp	jle_cont.43034
jle_else.43033:
	fldi	%f2, %g8, 0
	fldi	%f1, %g8, -4
	fldi	%f0, %g8, -8
	fmul	%f4, %f2, %f2
	ldi	%g6, %g5, -16
	fldi	%f3, %g6, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g6, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g6, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g6, %g5, -12
	jne	%g6, %g0, jeq_else.43035
	fmov	%f3, %f4
	jmp	jeq_cont.43036
jeq_else.43035:
	fmul	%f5, %f1, %f0
	ldi	%g5, %g5, -36
	fldi	%f3, %g5, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g5, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g5, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.43036:
	addi	%g5, %g0, 3
	jne	%g7, %g5, jeq_else.43037
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.43038
jeq_else.43037:
	fmov	%f0, %f3
jeq_cont.43038:
	fsti	%f0, %g8, -12
jle_cont.43034:
jeq_cont.43032:
	subi	%g8, %g4, 1
	jlt	%g8, %g0, jge_else.43039
	slli	%g4, %g8, 2
	add	%g4, %g31, %g4
	ldi	%g4, %g4, 272
	ldi	%g7, %g4, -40
	ldi	%g6, %g4, -4
	fldi	%f1, %g3, 0
	ldi	%g5, %g4, -20
	fldi	%f0, %g5, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, 0
	fldi	%f1, %g3, -4
	fldi	%f0, %g5, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -4
	fldi	%f1, %g3, -8
	fldi	%f0, %g5, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -8
	addi	%g5, %g0, 2
	jne	%g6, %g5, jeq_else.43040
	ldi	%g4, %g4, -16
	fldi	%f1, %g7, 0
	fldi	%f3, %g7, -4
	fldi	%f2, %g7, -8
	fldi	%f0, %g4, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g4, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g7, -12
	jmp	jeq_cont.43041
jeq_else.43040:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.43042
	jmp	jle_cont.43043
jle_else.43042:
	fldi	%f2, %g7, 0
	fldi	%f1, %g7, -4
	fldi	%f0, %g7, -8
	fmul	%f4, %f2, %f2
	ldi	%g5, %g4, -16
	fldi	%f3, %g5, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g5, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g5, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g5, %g4, -12
	jne	%g5, %g0, jeq_else.43044
	fmov	%f3, %f4
	jmp	jeq_cont.43045
jeq_else.43044:
	fmul	%f5, %f1, %f0
	ldi	%g4, %g4, -36
	fldi	%f3, %g4, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g4, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g4, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.43045:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.43046
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.43047
jeq_else.43046:
	fmov	%f0, %f3
jeq_cont.43047:
	fsti	%f0, %g7, -12
jle_cont.43043:
jeq_cont.43041:
	subi	%g4, %g8, 1
	jmp	setup_startp_constants.2823
jge_else.43039:
	return
jge_else.43030:
	return

!==============================
! args = [%g5, %g4]
! fargs = [%f5, %f4, %f3]
! use_regs = [%g7, %g6, %g5, %g4, %g3, %g27, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0]
! ret type = Bool
!================================
check_all_inside.2848:
	slli	%g3, %g5, 2
	ld	%g6, %g4, %g3
	jne	%g6, %g29, jeq_else.43050
	addi	%g3, %g0, 1
	return
jeq_else.43050:
	slli	%g3, %g6, 2
	add	%g3, %g31, %g3
	ldi	%g7, %g3, 272
	ldi	%g3, %g7, -20
	fldi	%f0, %g3, 0
	fsub	%f0, %f5, %f0
	fldi	%f1, %g3, -4
	fsub	%f2, %f4, %f1
	fldi	%f1, %g3, -8
	fsub	%f1, %f3, %f1
	ldi	%g6, %g7, -4
	jne	%g6, %g28, jeq_else.43051
	fjlt	%f0, %f16, fjge_else.43053
	fmov	%f6, %f0
	jmp	fjge_cont.43054
fjge_else.43053:
	fneg	%f6, %f0
fjge_cont.43054:
	ldi	%g3, %g7, -16
	fldi	%f0, %g3, 0
	fjlt	%f6, %f0, fjge_else.43055
	addi	%g6, %g0, 0
	jmp	fjge_cont.43056
fjge_else.43055:
	fjlt	%f2, %f16, fjge_else.43057
	fmov	%f0, %f2
	jmp	fjge_cont.43058
fjge_else.43057:
	fneg	%f0, %f2
fjge_cont.43058:
	fldi	%f2, %g3, -4
	fjlt	%f0, %f2, fjge_else.43059
	addi	%g6, %g0, 0
	jmp	fjge_cont.43060
fjge_else.43059:
	fjlt	%f1, %f16, fjge_else.43061
	fmov	%f0, %f1
	jmp	fjge_cont.43062
fjge_else.43061:
	fneg	%f0, %f1
fjge_cont.43062:
	fldi	%f1, %g3, -8
	fjlt	%f0, %f1, fjge_else.43063
	addi	%g6, %g0, 0
	jmp	fjge_cont.43064
fjge_else.43063:
	addi	%g6, %g0, 1
fjge_cont.43064:
fjge_cont.43060:
fjge_cont.43056:
	jne	%g6, %g0, jeq_else.43065
	ldi	%g3, %g7, -24
	jne	%g3, %g0, jeq_else.43067
	addi	%g3, %g0, 1
	jmp	jeq_cont.43068
jeq_else.43067:
	addi	%g3, %g0, 0
jeq_cont.43068:
	jmp	jeq_cont.43066
jeq_else.43065:
	ldi	%g3, %g7, -24
jeq_cont.43066:
	jmp	jeq_cont.43052
jeq_else.43051:
	addi	%g3, %g0, 2
	jne	%g6, %g3, jeq_else.43069
	ldi	%g3, %g7, -16
	fldi	%f6, %g3, 0
	fmul	%f6, %f6, %f0
	fldi	%f0, %g3, -4
	fmul	%f0, %f0, %f2
	fadd	%f2, %f6, %f0
	fldi	%f0, %g3, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	ldi	%g3, %g7, -24
	fjlt	%f0, %f16, fjge_else.43071
	addi	%g6, %g0, 0
	jmp	fjge_cont.43072
fjge_else.43071:
	addi	%g6, %g0, 1
fjge_cont.43072:
	jne	%g3, %g6, jeq_else.43073
	addi	%g3, %g0, 1
	jmp	jeq_cont.43074
jeq_else.43073:
	addi	%g3, %g0, 0
jeq_cont.43074:
	jmp	jeq_cont.43070
jeq_else.43069:
	fmul	%f7, %f0, %f0
	ldi	%g3, %g7, -16
	fldi	%f6, %g3, 0
	fmul	%f8, %f7, %f6
	fmul	%f7, %f2, %f2
	fldi	%f6, %g3, -4
	fmul	%f6, %f7, %f6
	fadd	%f8, %f8, %f6
	fmul	%f7, %f1, %f1
	fldi	%f6, %g3, -8
	fmul	%f6, %f7, %f6
	fadd	%f7, %f8, %f6
	ldi	%g3, %g7, -12
	jne	%g3, %g0, jeq_else.43075
	fmov	%f6, %f7
	jmp	jeq_cont.43076
jeq_else.43075:
	fmul	%f8, %f2, %f1
	ldi	%g3, %g7, -36
	fldi	%f6, %g3, 0
	fmul	%f6, %f8, %f6
	fadd	%f7, %f7, %f6
	fmul	%f6, %f1, %f0
	fldi	%f1, %g3, -4
	fmul	%f1, %f6, %f1
	fadd	%f7, %f7, %f1
	fmul	%f1, %f0, %f2
	fldi	%f0, %g3, -8
	fmul	%f6, %f1, %f0
	fadd	%f6, %f7, %f6
jeq_cont.43076:
	addi	%g3, %g0, 3
	jne	%g6, %g3, jeq_else.43077
	fsub	%f0, %f6, %f17
	jmp	jeq_cont.43078
jeq_else.43077:
	fmov	%f0, %f6
jeq_cont.43078:
	ldi	%g3, %g7, -24
	fjlt	%f0, %f16, fjge_else.43079
	addi	%g6, %g0, 0
	jmp	fjge_cont.43080
fjge_else.43079:
	addi	%g6, %g0, 1
fjge_cont.43080:
	jne	%g3, %g6, jeq_else.43081
	addi	%g3, %g0, 1
	jmp	jeq_cont.43082
jeq_else.43081:
	addi	%g3, %g0, 0
jeq_cont.43082:
jeq_cont.43070:
jeq_cont.43052:
	jne	%g3, %g0, jeq_else.43083
	addi	%g7, %g5, 1
	slli	%g3, %g7, 2
	ld	%g5, %g4, %g3
	jne	%g5, %g29, jeq_else.43084
	addi	%g3, %g0, 1
	return
jeq_else.43084:
	slli	%g3, %g5, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 272
	ldi	%g3, %g6, -20
	fldi	%f0, %g3, 0
	fsub	%f0, %f5, %f0
	fldi	%f1, %g3, -4
	fsub	%f2, %f4, %f1
	fldi	%f1, %g3, -8
	fsub	%f1, %f3, %f1
	ldi	%g5, %g6, -4
	jne	%g5, %g28, jeq_else.43085
	fjlt	%f0, %f16, fjge_else.43087
	fmov	%f6, %f0
	jmp	fjge_cont.43088
fjge_else.43087:
	fneg	%f6, %f0
fjge_cont.43088:
	ldi	%g3, %g6, -16
	fldi	%f0, %g3, 0
	fjlt	%f6, %f0, fjge_else.43089
	addi	%g5, %g0, 0
	jmp	fjge_cont.43090
fjge_else.43089:
	fjlt	%f2, %f16, fjge_else.43091
	fmov	%f0, %f2
	jmp	fjge_cont.43092
fjge_else.43091:
	fneg	%f0, %f2
fjge_cont.43092:
	fldi	%f2, %g3, -4
	fjlt	%f0, %f2, fjge_else.43093
	addi	%g5, %g0, 0
	jmp	fjge_cont.43094
fjge_else.43093:
	fjlt	%f1, %f16, fjge_else.43095
	fmov	%f0, %f1
	jmp	fjge_cont.43096
fjge_else.43095:
	fneg	%f0, %f1
fjge_cont.43096:
	fldi	%f1, %g3, -8
	fjlt	%f0, %f1, fjge_else.43097
	addi	%g5, %g0, 0
	jmp	fjge_cont.43098
fjge_else.43097:
	addi	%g5, %g0, 1
fjge_cont.43098:
fjge_cont.43094:
fjge_cont.43090:
	jne	%g5, %g0, jeq_else.43099
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.43101
	addi	%g3, %g0, 1
	jmp	jeq_cont.43102
jeq_else.43101:
	addi	%g3, %g0, 0
jeq_cont.43102:
	jmp	jeq_cont.43100
jeq_else.43099:
	ldi	%g3, %g6, -24
jeq_cont.43100:
	jmp	jeq_cont.43086
jeq_else.43085:
	addi	%g3, %g0, 2
	jne	%g5, %g3, jeq_else.43103
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, 0
	fmul	%f6, %f6, %f0
	fldi	%f0, %g3, -4
	fmul	%f0, %f0, %f2
	fadd	%f2, %f6, %f0
	fldi	%f0, %g3, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.43105
	addi	%g5, %g0, 0
	jmp	fjge_cont.43106
fjge_else.43105:
	addi	%g5, %g0, 1
fjge_cont.43106:
	jne	%g3, %g5, jeq_else.43107
	addi	%g3, %g0, 1
	jmp	jeq_cont.43108
jeq_else.43107:
	addi	%g3, %g0, 0
jeq_cont.43108:
	jmp	jeq_cont.43104
jeq_else.43103:
	fmul	%f7, %f0, %f0
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, 0
	fmul	%f8, %f7, %f6
	fmul	%f7, %f2, %f2
	fldi	%f6, %g3, -4
	fmul	%f6, %f7, %f6
	fadd	%f8, %f8, %f6
	fmul	%f7, %f1, %f1
	fldi	%f6, %g3, -8
	fmul	%f6, %f7, %f6
	fadd	%f7, %f8, %f6
	ldi	%g3, %g6, -12
	jne	%g3, %g0, jeq_else.43109
	fmov	%f6, %f7
	jmp	jeq_cont.43110
jeq_else.43109:
	fmul	%f8, %f2, %f1
	ldi	%g3, %g6, -36
	fldi	%f6, %g3, 0
	fmul	%f6, %f8, %f6
	fadd	%f7, %f7, %f6
	fmul	%f6, %f1, %f0
	fldi	%f1, %g3, -4
	fmul	%f1, %f6, %f1
	fadd	%f7, %f7, %f1
	fmul	%f1, %f0, %f2
	fldi	%f0, %g3, -8
	fmul	%f6, %f1, %f0
	fadd	%f6, %f7, %f6
jeq_cont.43110:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.43111
	fsub	%f0, %f6, %f17
	jmp	jeq_cont.43112
jeq_else.43111:
	fmov	%f0, %f6
jeq_cont.43112:
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.43113
	addi	%g5, %g0, 0
	jmp	fjge_cont.43114
fjge_else.43113:
	addi	%g5, %g0, 1
fjge_cont.43114:
	jne	%g3, %g5, jeq_else.43115
	addi	%g3, %g0, 1
	jmp	jeq_cont.43116
jeq_else.43115:
	addi	%g3, %g0, 0
jeq_cont.43116:
jeq_cont.43104:
jeq_cont.43086:
	jne	%g3, %g0, jeq_else.43117
	addi	%g5, %g7, 1
	jmp	check_all_inside.2848
jeq_else.43117:
	addi	%g3, %g0, 0
	return
jeq_else.43083:
	addi	%g3, %g0, 0
	return

!==============================
! args = [%g8, %g4]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Bool
!================================
shadow_check_and_group.2854:
	slli	%g3, %g8, 2
	ld	%g9, %g4, %g3
	jne	%g9, %g29, jeq_else.43118
	addi	%g3, %g0, 0
	return
jeq_else.43118:
	slli	%g3, %g9, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 272
	fldi	%f1, %g31, 540
	ldi	%g3, %g6, -20
	fldi	%f0, %g3, 0
	fsub	%f3, %f1, %f0
	fldi	%f1, %g31, 536
	fldi	%f0, %g3, -4
	fsub	%f4, %f1, %f0
	fldi	%f1, %g31, 532
	fldi	%f0, %g3, -8
	fsub	%f2, %f1, %f0
	slli	%g3, %g9, 2
	add	%g3, %g31, %g3
	ldi	%g7, %g3, 972
	ldi	%g5, %g6, -4
	jne	%g5, %g28, jeq_else.43119
	fldi	%f0, %g7, 0
	fsub	%f0, %f0, %f3
	fldi	%f1, %g7, -4
	fmul	%f0, %f0, %f1
	fldi	%f5, %g31, 728
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f4
	fjlt	%f6, %f16, fjge_else.43121
	fmov	%f5, %f6
	jmp	fjge_cont.43122
fjge_else.43121:
	fneg	%f5, %f6
fjge_cont.43122:
	ldi	%g5, %g6, -16
	fldi	%f6, %g5, -4
	fjlt	%f5, %f6, fjge_else.43123
	addi	%g3, %g0, 0
	jmp	fjge_cont.43124
fjge_else.43123:
	fldi	%f5, %g31, 724
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f2
	fjlt	%f6, %f16, fjge_else.43125
	fmov	%f5, %f6
	jmp	fjge_cont.43126
fjge_else.43125:
	fneg	%f5, %f6
fjge_cont.43126:
	fldi	%f6, %g5, -8
	fjlt	%f5, %f6, fjge_else.43127
	addi	%g3, %g0, 0
	jmp	fjge_cont.43128
fjge_else.43127:
	fjeq	%f1, %f16, fjne_else.43129
	addi	%g3, %g0, 1
	jmp	fjne_cont.43130
fjne_else.43129:
	addi	%g3, %g0, 0
fjne_cont.43130:
fjge_cont.43128:
fjge_cont.43124:
	jne	%g3, %g0, jeq_else.43131
	fldi	%f0, %g7, -8
	fsub	%f0, %f0, %f4
	fldi	%f1, %g7, -12
	fmul	%f0, %f0, %f1
	fldi	%f5, %g31, 732
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f3
	fjlt	%f6, %f16, fjge_else.43133
	fmov	%f5, %f6
	jmp	fjge_cont.43134
fjge_else.43133:
	fneg	%f5, %f6
fjge_cont.43134:
	fldi	%f6, %g5, 0
	fjlt	%f5, %f6, fjge_else.43135
	addi	%g3, %g0, 0
	jmp	fjge_cont.43136
fjge_else.43135:
	fldi	%f5, %g31, 724
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f2
	fjlt	%f6, %f16, fjge_else.43137
	fmov	%f5, %f6
	jmp	fjge_cont.43138
fjge_else.43137:
	fneg	%f5, %f6
fjge_cont.43138:
	fldi	%f6, %g5, -8
	fjlt	%f5, %f6, fjge_else.43139
	addi	%g3, %g0, 0
	jmp	fjge_cont.43140
fjge_else.43139:
	fjeq	%f1, %f16, fjne_else.43141
	addi	%g3, %g0, 1
	jmp	fjne_cont.43142
fjne_else.43141:
	addi	%g3, %g0, 0
fjne_cont.43142:
fjge_cont.43140:
fjge_cont.43136:
	jne	%g3, %g0, jeq_else.43143
	fldi	%f0, %g7, -16
	fsub	%f1, %f0, %f2
	fldi	%f0, %g7, -20
	fmul	%f5, %f1, %f0
	fldi	%f1, %g31, 732
	fmul	%f1, %f5, %f1
	fadd	%f2, %f1, %f3
	fjlt	%f2, %f16, fjge_else.43145
	fmov	%f1, %f2
	jmp	fjge_cont.43146
fjge_else.43145:
	fneg	%f1, %f2
fjge_cont.43146:
	fldi	%f2, %g5, 0
	fjlt	%f1, %f2, fjge_else.43147
	addi	%g3, %g0, 0
	jmp	fjge_cont.43148
fjge_else.43147:
	fldi	%f1, %g31, 728
	fmul	%f1, %f5, %f1
	fadd	%f2, %f1, %f4
	fjlt	%f2, %f16, fjge_else.43149
	fmov	%f1, %f2
	jmp	fjge_cont.43150
fjge_else.43149:
	fneg	%f1, %f2
fjge_cont.43150:
	fldi	%f2, %g5, -4
	fjlt	%f1, %f2, fjge_else.43151
	addi	%g3, %g0, 0
	jmp	fjge_cont.43152
fjge_else.43151:
	fjeq	%f0, %f16, fjne_else.43153
	addi	%g3, %g0, 1
	jmp	fjne_cont.43154
fjne_else.43153:
	addi	%g3, %g0, 0
fjne_cont.43154:
fjge_cont.43152:
fjge_cont.43148:
	jne	%g3, %g0, jeq_else.43155
	addi	%g3, %g0, 0
	jmp	jeq_cont.43156
jeq_else.43155:
	fsti	%f5, %g31, 520
	addi	%g3, %g0, 3
jeq_cont.43156:
	jmp	jeq_cont.43144
jeq_else.43143:
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 2
jeq_cont.43144:
	jmp	jeq_cont.43132
jeq_else.43131:
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 1
jeq_cont.43132:
	jmp	jeq_cont.43120
jeq_else.43119:
	addi	%g3, %g0, 2
	jne	%g5, %g3, jeq_else.43157
	fldi	%f0, %g7, 0
	fjlt	%f0, %f16, fjge_else.43159
	addi	%g3, %g0, 0
	jmp	fjge_cont.43160
fjge_else.43159:
	fldi	%f0, %g7, -4
	fmul	%f1, %f0, %f3
	fldi	%f0, %g7, -8
	fmul	%f0, %f0, %f4
	fadd	%f1, %f1, %f0
	fldi	%f0, %g7, -12
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.43160:
	jmp	jeq_cont.43158
jeq_else.43157:
	fldi	%f0, %g7, 0
	fjeq	%f0, %f16, fjne_else.43161
	fldi	%f1, %g7, -4
	fmul	%f5, %f1, %f3
	fldi	%f1, %g7, -8
	fmul	%f1, %f1, %f4
	fadd	%f5, %f5, %f1
	fldi	%f1, %g7, -12
	fmul	%f1, %f1, %f2
	fadd	%f1, %f5, %f1
	fmul	%f6, %f3, %f3
	ldi	%g3, %g6, -16
	fldi	%f5, %g3, 0
	fmul	%f7, %f6, %f5
	fmul	%f6, %f4, %f4
	fldi	%f5, %g3, -4
	fmul	%f5, %f6, %f5
	fadd	%f7, %f7, %f5
	fmul	%f6, %f2, %f2
	fldi	%f5, %g3, -8
	fmul	%f5, %f6, %f5
	fadd	%f6, %f7, %f5
	ldi	%g3, %g6, -12
	jne	%g3, %g0, jeq_else.43163
	fmov	%f5, %f6
	jmp	jeq_cont.43164
jeq_else.43163:
	fmul	%f7, %f4, %f2
	ldi	%g3, %g6, -36
	fldi	%f5, %g3, 0
	fmul	%f5, %f7, %f5
	fadd	%f6, %f6, %f5
	fmul	%f5, %f2, %f3
	fldi	%f2, %g3, -4
	fmul	%f2, %f5, %f2
	fadd	%f6, %f6, %f2
	fmul	%f3, %f3, %f4
	fldi	%f2, %g3, -8
	fmul	%f5, %f3, %f2
	fadd	%f5, %f6, %f5
jeq_cont.43164:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.43165
	fsub	%f2, %f5, %f17
	jmp	jeq_cont.43166
jeq_else.43165:
	fmov	%f2, %f5
jeq_cont.43166:
	fmul	%f3, %f1, %f1
	fmul	%f0, %f0, %f2
	fsub	%f0, %f3, %f0
	fjlt	%f16, %f0, fjge_else.43167
	addi	%g3, %g0, 0
	jmp	fjge_cont.43168
fjge_else.43167:
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.43169
	fsqrt	%f0, %f0
	fsub	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	jmp	jeq_cont.43170
jeq_else.43169:
	fsqrt	%f0, %f0
	fadd	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
jeq_cont.43170:
	addi	%g3, %g0, 1
fjge_cont.43168:
	jmp	fjne_cont.43162
fjne_else.43161:
	addi	%g3, %g0, 0
fjne_cont.43162:
jeq_cont.43158:
jeq_cont.43120:
	fldi	%f0, %g31, 520
	jne	%g3, %g0, jeq_else.43171
	addi	%g3, %g0, 0
	jmp	jeq_cont.43172
jeq_else.43171:
	setL %g3, l.36803
	fldi	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.43173
	addi	%g3, %g0, 0
	jmp	fjge_cont.43174
fjge_else.43173:
	addi	%g3, %g0, 1
fjge_cont.43174:
jeq_cont.43172:
	jne	%g3, %g0, jeq_else.43175
	slli	%g3, %g9, 2
	add	%g3, %g31, %g3
	ldi	%g3, %g3, 272
	ldi	%g3, %g3, -24
	jne	%g3, %g0, jeq_else.43176
	addi	%g3, %g0, 0
	return
jeq_else.43176:
	addi	%g8, %g8, 1
	jmp	shadow_check_and_group.2854
jeq_else.43175:
	setL %g3, l.36805
	fldi	%f1, %g3, 0
	fadd	%f0, %f0, %f1
	fldi	%f1, %g31, 308
	fmul	%f2, %f1, %f0
	fldi	%f1, %g31, 540
	fadd	%f5, %f2, %f1
	fldi	%f1, %g31, 304
	fmul	%f2, %f1, %f0
	fldi	%f1, %g31, 536
	fadd	%f4, %f2, %f1
	fldi	%f1, %g31, 300
	fmul	%f1, %f1, %f0
	fldi	%f0, %g31, 532
	fadd	%f3, %f1, %f0
	ldi	%g5, %g4, 0
	sti	%g4, %g1, 0
	jne	%g5, %g29, jeq_else.43177
	addi	%g3, %g0, 1
	jmp	jeq_cont.43178
jeq_else.43177:
	slli	%g3, %g5, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 272
	ldi	%g3, %g6, -20
	fldi	%f0, %g3, 0
	fsub	%f0, %f5, %f0
	fldi	%f1, %g3, -4
	fsub	%f2, %f4, %f1
	fldi	%f1, %g3, -8
	fsub	%f1, %f3, %f1
	ldi	%g5, %g6, -4
	jne	%g5, %g28, jeq_else.43179
	fjlt	%f0, %f16, fjge_else.43181
	fmov	%f6, %f0
	jmp	fjge_cont.43182
fjge_else.43181:
	fneg	%f6, %f0
fjge_cont.43182:
	ldi	%g3, %g6, -16
	fldi	%f0, %g3, 0
	fjlt	%f6, %f0, fjge_else.43183
	addi	%g5, %g0, 0
	jmp	fjge_cont.43184
fjge_else.43183:
	fjlt	%f2, %f16, fjge_else.43185
	fmov	%f0, %f2
	jmp	fjge_cont.43186
fjge_else.43185:
	fneg	%f0, %f2
fjge_cont.43186:
	fldi	%f2, %g3, -4
	fjlt	%f0, %f2, fjge_else.43187
	addi	%g5, %g0, 0
	jmp	fjge_cont.43188
fjge_else.43187:
	fjlt	%f1, %f16, fjge_else.43189
	fmov	%f0, %f1
	jmp	fjge_cont.43190
fjge_else.43189:
	fneg	%f0, %f1
fjge_cont.43190:
	fldi	%f1, %g3, -8
	fjlt	%f0, %f1, fjge_else.43191
	addi	%g5, %g0, 0
	jmp	fjge_cont.43192
fjge_else.43191:
	addi	%g5, %g0, 1
fjge_cont.43192:
fjge_cont.43188:
fjge_cont.43184:
	jne	%g5, %g0, jeq_else.43193
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.43195
	addi	%g3, %g0, 1
	jmp	jeq_cont.43196
jeq_else.43195:
	addi	%g3, %g0, 0
jeq_cont.43196:
	jmp	jeq_cont.43194
jeq_else.43193:
	ldi	%g3, %g6, -24
jeq_cont.43194:
	jmp	jeq_cont.43180
jeq_else.43179:
	addi	%g3, %g0, 2
	jne	%g5, %g3, jeq_else.43197
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, 0
	fmul	%f6, %f6, %f0
	fldi	%f0, %g3, -4
	fmul	%f0, %f0, %f2
	fadd	%f2, %f6, %f0
	fldi	%f0, %g3, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.43199
	addi	%g5, %g0, 0
	jmp	fjge_cont.43200
fjge_else.43199:
	addi	%g5, %g0, 1
fjge_cont.43200:
	jne	%g3, %g5, jeq_else.43201
	addi	%g3, %g0, 1
	jmp	jeq_cont.43202
jeq_else.43201:
	addi	%g3, %g0, 0
jeq_cont.43202:
	jmp	jeq_cont.43198
jeq_else.43197:
	fmul	%f7, %f0, %f0
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, 0
	fmul	%f8, %f7, %f6
	fmul	%f7, %f2, %f2
	fldi	%f6, %g3, -4
	fmul	%f6, %f7, %f6
	fadd	%f8, %f8, %f6
	fmul	%f7, %f1, %f1
	fldi	%f6, %g3, -8
	fmul	%f6, %f7, %f6
	fadd	%f7, %f8, %f6
	ldi	%g3, %g6, -12
	jne	%g3, %g0, jeq_else.43203
	fmov	%f6, %f7
	jmp	jeq_cont.43204
jeq_else.43203:
	fmul	%f8, %f2, %f1
	ldi	%g3, %g6, -36
	fldi	%f6, %g3, 0
	fmul	%f6, %f8, %f6
	fadd	%f7, %f7, %f6
	fmul	%f6, %f1, %f0
	fldi	%f1, %g3, -4
	fmul	%f1, %f6, %f1
	fadd	%f7, %f7, %f1
	fmul	%f1, %f0, %f2
	fldi	%f0, %g3, -8
	fmul	%f6, %f1, %f0
	fadd	%f6, %f7, %f6
jeq_cont.43204:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.43205
	fsub	%f0, %f6, %f17
	jmp	jeq_cont.43206
jeq_else.43205:
	fmov	%f0, %f6
jeq_cont.43206:
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.43207
	addi	%g5, %g0, 0
	jmp	fjge_cont.43208
fjge_else.43207:
	addi	%g5, %g0, 1
fjge_cont.43208:
	jne	%g3, %g5, jeq_else.43209
	addi	%g3, %g0, 1
	jmp	jeq_cont.43210
jeq_else.43209:
	addi	%g3, %g0, 0
jeq_cont.43210:
jeq_cont.43198:
jeq_cont.43180:
	jne	%g3, %g0, jeq_else.43211
	addi	%g5, %g0, 1
	subi	%g1, %g1, 8
	call	check_all_inside.2848
	addi	%g1, %g1, 8
	jmp	jeq_cont.43212
jeq_else.43211:
	addi	%g3, %g0, 0
jeq_cont.43212:
jeq_cont.43178:
	jne	%g3, %g0, jeq_else.43213
	addi	%g8, %g8, 1
	ldi	%g4, %g1, 0
	jmp	shadow_check_and_group.2854
jeq_else.43213:
	addi	%g3, %g0, 1
	return

!==============================
! args = [%g11, %g10]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g11, %g10, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Bool
!================================
shadow_check_one_or_group.2857:
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.43214
	addi	%g3, %g0, 0
	return
jeq_else.43214:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.43215
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.43216
	addi	%g3, %g0, 0
	return
jeq_else.43216:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.43217
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.43218
	addi	%g3, %g0, 0
	return
jeq_else.43218:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.43219
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.43220
	addi	%g3, %g0, 0
	return
jeq_else.43220:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.43221
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.43222
	addi	%g3, %g0, 0
	return
jeq_else.43222:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.43223
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.43224
	addi	%g3, %g0, 0
	return
jeq_else.43224:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.43225
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.43226
	addi	%g3, %g0, 0
	return
jeq_else.43226:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.43227
	addi	%g11, %g11, 1
	slli	%g3, %g11, 2
	ld	%g4, %g10, %g3
	jne	%g4, %g29, jeq_else.43228
	addi	%g3, %g0, 0
	return
jeq_else.43228:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 4
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.43229
	addi	%g11, %g11, 1
	jmp	shadow_check_one_or_group.2857
jeq_else.43229:
	addi	%g3, %g0, 1
	return
jeq_else.43227:
	addi	%g3, %g0, 1
	return
jeq_else.43225:
	addi	%g3, %g0, 1
	return
jeq_else.43223:
	addi	%g3, %g0, 1
	return
jeq_else.43221:
	addi	%g3, %g0, 1
	return
jeq_else.43219:
	addi	%g3, %g0, 1
	return
jeq_else.43217:
	addi	%g3, %g0, 1
	return
jeq_else.43215:
	addi	%g3, %g0, 1
	return

!==============================
! args = [%g12, %g13]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g13, %g12, %g11, %g10, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Bool
!================================
shadow_check_one_or_matrix.2860:
	slli	%g3, %g12, 2
	ld	%g10, %g13, %g3
	ldi	%g4, %g10, 0
	jne	%g4, %g29, jeq_else.43230
	addi	%g3, %g0, 0
	return
jeq_else.43230:
	addi	%g3, %g0, 99
	sti	%g10, %g1, 0
	jne	%g4, %g3, jeq_else.43231
	addi	%g3, %g0, 1
	jmp	jeq_cont.43232
jeq_else.43231:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g5, %g3, 272
	fldi	%f1, %g31, 540
	ldi	%g3, %g5, -20
	fldi	%f0, %g3, 0
	fsub	%f3, %f1, %f0
	fldi	%f1, %g31, 536
	fldi	%f0, %g3, -4
	fsub	%f4, %f1, %f0
	fldi	%f1, %g31, 532
	fldi	%f0, %g3, -8
	fsub	%f1, %f1, %f0
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 972
	ldi	%g4, %g5, -4
	jne	%g4, %g28, jeq_else.43233
	fldi	%f0, %g6, 0
	fsub	%f2, %f0, %f3
	fldi	%f0, %g6, -4
	fmul	%f6, %f2, %f0
	fldi	%f2, %g31, 728
	fmul	%f2, %f6, %f2
	fadd	%f5, %f2, %f4
	fjlt	%f5, %f16, fjge_else.43235
	fmov	%f2, %f5
	jmp	fjge_cont.43236
fjge_else.43235:
	fneg	%f2, %f5
fjge_cont.43236:
	ldi	%g4, %g5, -16
	fldi	%f5, %g4, -4
	fjlt	%f2, %f5, fjge_else.43237
	addi	%g3, %g0, 0
	jmp	fjge_cont.43238
fjge_else.43237:
	fldi	%f2, %g31, 724
	fmul	%f2, %f6, %f2
	fadd	%f5, %f2, %f1
	fjlt	%f5, %f16, fjge_else.43239
	fmov	%f2, %f5
	jmp	fjge_cont.43240
fjge_else.43239:
	fneg	%f2, %f5
fjge_cont.43240:
	fldi	%f5, %g4, -8
	fjlt	%f2, %f5, fjge_else.43241
	addi	%g3, %g0, 0
	jmp	fjge_cont.43242
fjge_else.43241:
	fjeq	%f0, %f16, fjne_else.43243
	addi	%g3, %g0, 1
	jmp	fjne_cont.43244
fjne_else.43243:
	addi	%g3, %g0, 0
fjne_cont.43244:
fjge_cont.43242:
fjge_cont.43238:
	jne	%g3, %g0, jeq_else.43245
	fldi	%f0, %g6, -8
	fsub	%f0, %f0, %f4
	fldi	%f6, %g6, -12
	fmul	%f5, %f0, %f6
	fldi	%f0, %g31, 732
	fmul	%f0, %f5, %f0
	fadd	%f2, %f0, %f3
	fjlt	%f2, %f16, fjge_else.43247
	fmov	%f0, %f2
	jmp	fjge_cont.43248
fjge_else.43247:
	fneg	%f0, %f2
fjge_cont.43248:
	fldi	%f2, %g4, 0
	fjlt	%f0, %f2, fjge_else.43249
	addi	%g3, %g0, 0
	jmp	fjge_cont.43250
fjge_else.43249:
	fldi	%f0, %g31, 724
	fmul	%f0, %f5, %f0
	fadd	%f2, %f0, %f1
	fjlt	%f2, %f16, fjge_else.43251
	fmov	%f0, %f2
	jmp	fjge_cont.43252
fjge_else.43251:
	fneg	%f0, %f2
fjge_cont.43252:
	fldi	%f2, %g4, -8
	fjlt	%f0, %f2, fjge_else.43253
	addi	%g3, %g0, 0
	jmp	fjge_cont.43254
fjge_else.43253:
	fjeq	%f6, %f16, fjne_else.43255
	addi	%g3, %g0, 1
	jmp	fjne_cont.43256
fjne_else.43255:
	addi	%g3, %g0, 0
fjne_cont.43256:
fjge_cont.43254:
fjge_cont.43250:
	jne	%g3, %g0, jeq_else.43257
	fldi	%f0, %g6, -16
	fsub	%f0, %f0, %f1
	fldi	%f5, %g6, -20
	fmul	%f2, %f0, %f5
	fldi	%f0, %g31, 732
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f3
	fjlt	%f1, %f16, fjge_else.43259
	fmov	%f0, %f1
	jmp	fjge_cont.43260
fjge_else.43259:
	fneg	%f0, %f1
fjge_cont.43260:
	fldi	%f1, %g4, 0
	fjlt	%f0, %f1, fjge_else.43261
	addi	%g3, %g0, 0
	jmp	fjge_cont.43262
fjge_else.43261:
	fldi	%f0, %g31, 728
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f4
	fjlt	%f1, %f16, fjge_else.43263
	fmov	%f0, %f1
	jmp	fjge_cont.43264
fjge_else.43263:
	fneg	%f0, %f1
fjge_cont.43264:
	fldi	%f1, %g4, -4
	fjlt	%f0, %f1, fjge_else.43265
	addi	%g3, %g0, 0
	jmp	fjge_cont.43266
fjge_else.43265:
	fjeq	%f5, %f16, fjne_else.43267
	addi	%g3, %g0, 1
	jmp	fjne_cont.43268
fjne_else.43267:
	addi	%g3, %g0, 0
fjne_cont.43268:
fjge_cont.43266:
fjge_cont.43262:
	jne	%g3, %g0, jeq_else.43269
	addi	%g3, %g0, 0
	jmp	jeq_cont.43270
jeq_else.43269:
	fsti	%f2, %g31, 520
	addi	%g3, %g0, 3
jeq_cont.43270:
	jmp	jeq_cont.43258
jeq_else.43257:
	fsti	%f5, %g31, 520
	addi	%g3, %g0, 2
jeq_cont.43258:
	jmp	jeq_cont.43246
jeq_else.43245:
	fsti	%f6, %g31, 520
	addi	%g3, %g0, 1
jeq_cont.43246:
	jmp	jeq_cont.43234
jeq_else.43233:
	addi	%g3, %g0, 2
	jne	%g4, %g3, jeq_else.43271
	fldi	%f0, %g6, 0
	fjlt	%f0, %f16, fjge_else.43273
	addi	%g3, %g0, 0
	jmp	fjge_cont.43274
fjge_else.43273:
	fldi	%f0, %g6, -4
	fmul	%f2, %f0, %f3
	fldi	%f0, %g6, -8
	fmul	%f0, %f0, %f4
	fadd	%f2, %f2, %f0
	fldi	%f0, %g6, -12
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.43274:
	jmp	jeq_cont.43272
jeq_else.43271:
	fldi	%f0, %g6, 0
	fjeq	%f0, %f16, fjne_else.43275
	fldi	%f2, %g6, -4
	fmul	%f5, %f2, %f3
	fldi	%f2, %g6, -8
	fmul	%f2, %f2, %f4
	fadd	%f5, %f5, %f2
	fldi	%f2, %g6, -12
	fmul	%f2, %f2, %f1
	fadd	%f2, %f5, %f2
	fmul	%f6, %f3, %f3
	ldi	%g3, %g5, -16
	fldi	%f5, %g3, 0
	fmul	%f7, %f6, %f5
	fmul	%f6, %f4, %f4
	fldi	%f5, %g3, -4
	fmul	%f5, %f6, %f5
	fadd	%f7, %f7, %f5
	fmul	%f6, %f1, %f1
	fldi	%f5, %g3, -8
	fmul	%f5, %f6, %f5
	fadd	%f6, %f7, %f5
	ldi	%g3, %g5, -12
	jne	%g3, %g0, jeq_else.43277
	fmov	%f5, %f6
	jmp	jeq_cont.43278
jeq_else.43277:
	fmul	%f7, %f4, %f1
	ldi	%g3, %g5, -36
	fldi	%f5, %g3, 0
	fmul	%f5, %f7, %f5
	fadd	%f6, %f6, %f5
	fmul	%f5, %f1, %f3
	fldi	%f1, %g3, -4
	fmul	%f1, %f5, %f1
	fadd	%f6, %f6, %f1
	fmul	%f3, %f3, %f4
	fldi	%f1, %g3, -8
	fmul	%f5, %f3, %f1
	fadd	%f5, %f6, %f5
jeq_cont.43278:
	addi	%g3, %g0, 3
	jne	%g4, %g3, jeq_else.43279
	fsub	%f1, %f5, %f17
	jmp	jeq_cont.43280
jeq_else.43279:
	fmov	%f1, %f5
jeq_cont.43280:
	fmul	%f3, %f2, %f2
	fmul	%f0, %f0, %f1
	fsub	%f0, %f3, %f0
	fjlt	%f16, %f0, fjge_else.43281
	addi	%g3, %g0, 0
	jmp	fjge_cont.43282
fjge_else.43281:
	ldi	%g3, %g5, -24
	jne	%g3, %g0, jeq_else.43283
	fsqrt	%f0, %f0
	fsub	%f1, %f2, %f0
	fldi	%f0, %g6, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	jmp	jeq_cont.43284
jeq_else.43283:
	fsqrt	%f0, %f0
	fadd	%f1, %f2, %f0
	fldi	%f0, %g6, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
jeq_cont.43284:
	addi	%g3, %g0, 1
fjge_cont.43282:
	jmp	fjne_cont.43276
fjne_else.43275:
	addi	%g3, %g0, 0
fjne_cont.43276:
jeq_cont.43272:
jeq_cont.43234:
	jne	%g3, %g0, jeq_else.43285
	addi	%g3, %g0, 0
	jmp	jeq_cont.43286
jeq_else.43285:
	fldi	%f1, %g31, 520
	setL %g3, l.36991
	fldi	%f0, %g3, 0
	fjlt	%f1, %f0, fjge_else.43287
	addi	%g3, %g0, 0
	jmp	fjge_cont.43288
fjge_else.43287:
	ldi	%g4, %g10, -4
	jne	%g4, %g29, jeq_else.43289
	addi	%g3, %g0, 0
	jmp	jeq_cont.43290
jeq_else.43289:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.43291
	ldi	%g4, %g10, -8
	jne	%g4, %g29, jeq_else.43293
	addi	%g3, %g0, 0
	jmp	jeq_cont.43294
jeq_else.43293:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.43295
	ldi	%g4, %g10, -12
	jne	%g4, %g29, jeq_else.43297
	addi	%g3, %g0, 0
	jmp	jeq_cont.43298
jeq_else.43297:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.43299
	ldi	%g4, %g10, -16
	jne	%g4, %g29, jeq_else.43301
	addi	%g3, %g0, 0
	jmp	jeq_cont.43302
jeq_else.43301:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.43303
	ldi	%g4, %g10, -20
	jne	%g4, %g29, jeq_else.43305
	addi	%g3, %g0, 0
	jmp	jeq_cont.43306
jeq_else.43305:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.43307
	ldi	%g4, %g10, -24
	jne	%g4, %g29, jeq_else.43309
	addi	%g3, %g0, 0
	jmp	jeq_cont.43310
jeq_else.43309:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.43311
	ldi	%g4, %g10, -28
	jne	%g4, %g29, jeq_else.43313
	addi	%g3, %g0, 0
	jmp	jeq_cont.43314
jeq_else.43313:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.43315
	addi	%g11, %g0, 8
	subi	%g1, %g1, 8
	call	shadow_check_one_or_group.2857
	addi	%g1, %g1, 8
	jmp	jeq_cont.43316
jeq_else.43315:
	addi	%g3, %g0, 1
jeq_cont.43316:
jeq_cont.43314:
	jmp	jeq_cont.43312
jeq_else.43311:
	addi	%g3, %g0, 1
jeq_cont.43312:
jeq_cont.43310:
	jmp	jeq_cont.43308
jeq_else.43307:
	addi	%g3, %g0, 1
jeq_cont.43308:
jeq_cont.43306:
	jmp	jeq_cont.43304
jeq_else.43303:
	addi	%g3, %g0, 1
jeq_cont.43304:
jeq_cont.43302:
	jmp	jeq_cont.43300
jeq_else.43299:
	addi	%g3, %g0, 1
jeq_cont.43300:
jeq_cont.43298:
	jmp	jeq_cont.43296
jeq_else.43295:
	addi	%g3, %g0, 1
jeq_cont.43296:
jeq_cont.43294:
	jmp	jeq_cont.43292
jeq_else.43291:
	addi	%g3, %g0, 1
jeq_cont.43292:
jeq_cont.43290:
	jne	%g3, %g0, jeq_else.43317
	addi	%g3, %g0, 0
	jmp	jeq_cont.43318
jeq_else.43317:
	addi	%g3, %g0, 1
jeq_cont.43318:
fjge_cont.43288:
jeq_cont.43286:
jeq_cont.43232:
	jne	%g3, %g0, jeq_else.43319
	addi	%g12, %g12, 1
	jmp	shadow_check_one_or_matrix.2860
jeq_else.43319:
	ldi	%g10, %g1, 0
	ldi	%g4, %g10, -4
	jne	%g4, %g29, jeq_else.43320
	addi	%g3, %g0, 0
	jmp	jeq_cont.43321
jeq_else.43320:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.43322
	ldi	%g4, %g10, -8
	jne	%g4, %g29, jeq_else.43324
	addi	%g3, %g0, 0
	jmp	jeq_cont.43325
jeq_else.43324:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.43326
	ldi	%g4, %g10, -12
	jne	%g4, %g29, jeq_else.43328
	addi	%g3, %g0, 0
	jmp	jeq_cont.43329
jeq_else.43328:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.43330
	ldi	%g4, %g10, -16
	jne	%g4, %g29, jeq_else.43332
	addi	%g3, %g0, 0
	jmp	jeq_cont.43333
jeq_else.43332:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.43334
	ldi	%g4, %g10, -20
	jne	%g4, %g29, jeq_else.43336
	addi	%g3, %g0, 0
	jmp	jeq_cont.43337
jeq_else.43336:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.43338
	ldi	%g4, %g10, -24
	jne	%g4, %g29, jeq_else.43340
	addi	%g3, %g0, 0
	jmp	jeq_cont.43341
jeq_else.43340:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.43342
	ldi	%g4, %g10, -28
	jne	%g4, %g29, jeq_else.43344
	addi	%g3, %g0, 0
	jmp	jeq_cont.43345
jeq_else.43344:
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g8, %g0, 0
	subi	%g1, %g1, 8
	call	shadow_check_and_group.2854
	addi	%g1, %g1, 8
	jne	%g3, %g0, jeq_else.43346
	addi	%g11, %g0, 8
	subi	%g1, %g1, 8
	call	shadow_check_one_or_group.2857
	addi	%g1, %g1, 8
	jmp	jeq_cont.43347
jeq_else.43346:
	addi	%g3, %g0, 1
jeq_cont.43347:
jeq_cont.43345:
	jmp	jeq_cont.43343
jeq_else.43342:
	addi	%g3, %g0, 1
jeq_cont.43343:
jeq_cont.43341:
	jmp	jeq_cont.43339
jeq_else.43338:
	addi	%g3, %g0, 1
jeq_cont.43339:
jeq_cont.43337:
	jmp	jeq_cont.43335
jeq_else.43334:
	addi	%g3, %g0, 1
jeq_cont.43335:
jeq_cont.43333:
	jmp	jeq_cont.43331
jeq_else.43330:
	addi	%g3, %g0, 1
jeq_cont.43331:
jeq_cont.43329:
	jmp	jeq_cont.43327
jeq_else.43326:
	addi	%g3, %g0, 1
jeq_cont.43327:
jeq_cont.43325:
	jmp	jeq_cont.43323
jeq_else.43322:
	addi	%g3, %g0, 1
jeq_cont.43323:
jeq_cont.43321:
	jne	%g3, %g0, jeq_else.43348
	addi	%g12, %g12, 1
	jmp	shadow_check_one_or_matrix.2860
jeq_else.43348:
	addi	%g3, %g0, 1
	return

!==============================
! args = [%g11, %g4, %g9]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f2, %f17, %f16, %f15, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
solve_each_element.2863:
	slli	%g3, %g11, 2
	ld	%g10, %g4, %g3
	jne	%g10, %g29, jeq_else.43349
	return
jeq_else.43349:
	slli	%g3, %g10, 2
	add	%g3, %g31, %g3
	ldi	%g7, %g3, 272
	fldi	%f1, %g31, 624
	ldi	%g3, %g7, -20
	fldi	%f0, %g3, 0
	fsub	%f6, %f1, %f0
	fldi	%f1, %g31, 620
	fldi	%f0, %g3, -4
	fsub	%f7, %f1, %f0
	fldi	%f1, %g31, 616
	fldi	%f0, %g3, -8
	fsub	%f5, %f1, %f0
	ldi	%g3, %g7, -4
	jne	%g3, %g28, jeq_else.43351
	fldi	%f2, %g9, 0
	fjeq	%f2, %f16, fjne_else.43353
	ldi	%g5, %g7, -16
	ldi	%g3, %g7, -24
	fjlt	%f2, %f16, fjge_else.43355
	addi	%g6, %g0, 0
	jmp	fjge_cont.43356
fjge_else.43355:
	addi	%g6, %g0, 1
fjge_cont.43356:
	fldi	%f1, %g5, 0
	jne	%g3, %g6, jeq_else.43357
	fneg	%f0, %f1
	jmp	jeq_cont.43358
jeq_else.43357:
	fmov	%f0, %f1
jeq_cont.43358:
	fsub	%f0, %f0, %f6
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, -4
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f7
	fjlt	%f1, %f16, fjge_else.43359
	fmov	%f0, %f1
	jmp	fjge_cont.43360
fjge_else.43359:
	fneg	%f0, %f1
fjge_cont.43360:
	fldi	%f1, %g5, -4
	fjlt	%f0, %f1, fjge_else.43361
	addi	%g8, %g0, 0
	jmp	fjge_cont.43362
fjge_else.43361:
	fldi	%f0, %g9, -8
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f5
	fjlt	%f1, %f16, fjge_else.43363
	fmov	%f0, %f1
	jmp	fjge_cont.43364
fjge_else.43363:
	fneg	%f0, %f1
fjge_cont.43364:
	fldi	%f1, %g5, -8
	fjlt	%f0, %f1, fjge_else.43365
	addi	%g8, %g0, 0
	jmp	fjge_cont.43366
fjge_else.43365:
	fsti	%f2, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.43366:
fjge_cont.43362:
	jmp	fjne_cont.43354
fjne_else.43353:
	addi	%g8, %g0, 0
fjne_cont.43354:
	jne	%g8, %g0, jeq_else.43367
	fldi	%f2, %g9, -4
	fjeq	%f2, %f16, fjne_else.43369
	ldi	%g5, %g7, -16
	ldi	%g3, %g7, -24
	fjlt	%f2, %f16, fjge_else.43371
	addi	%g6, %g0, 0
	jmp	fjge_cont.43372
fjge_else.43371:
	addi	%g6, %g0, 1
fjge_cont.43372:
	fldi	%f1, %g5, -4
	jne	%g3, %g6, jeq_else.43373
	fneg	%f0, %f1
	jmp	jeq_cont.43374
jeq_else.43373:
	fmov	%f0, %f1
jeq_cont.43374:
	fsub	%f0, %f0, %f7
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, -8
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f5
	fjlt	%f1, %f16, fjge_else.43375
	fmov	%f0, %f1
	jmp	fjge_cont.43376
fjge_else.43375:
	fneg	%f0, %f1
fjge_cont.43376:
	fldi	%f1, %g5, -8
	fjlt	%f0, %f1, fjge_else.43377
	addi	%g8, %g0, 0
	jmp	fjge_cont.43378
fjge_else.43377:
	fldi	%f0, %g9, 0
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f6
	fjlt	%f1, %f16, fjge_else.43379
	fmov	%f0, %f1
	jmp	fjge_cont.43380
fjge_else.43379:
	fneg	%f0, %f1
fjge_cont.43380:
	fldi	%f1, %g5, 0
	fjlt	%f0, %f1, fjge_else.43381
	addi	%g8, %g0, 0
	jmp	fjge_cont.43382
fjge_else.43381:
	fsti	%f2, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.43382:
fjge_cont.43378:
	jmp	fjne_cont.43370
fjne_else.43369:
	addi	%g8, %g0, 0
fjne_cont.43370:
	jne	%g8, %g0, jeq_else.43383
	fldi	%f2, %g9, -8
	fjeq	%f2, %f16, fjne_else.43385
	ldi	%g5, %g7, -16
	ldi	%g3, %g7, -24
	fjlt	%f2, %f16, fjge_else.43387
	addi	%g6, %g0, 0
	jmp	fjge_cont.43388
fjge_else.43387:
	addi	%g6, %g0, 1
fjge_cont.43388:
	fldi	%f1, %g5, -8
	jne	%g3, %g6, jeq_else.43389
	fneg	%f0, %f1
	jmp	jeq_cont.43390
jeq_else.43389:
	fmov	%f0, %f1
jeq_cont.43390:
	fsub	%f0, %f0, %f5
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, 0
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f6
	fjlt	%f1, %f16, fjge_else.43391
	fmov	%f0, %f1
	jmp	fjge_cont.43392
fjge_else.43391:
	fneg	%f0, %f1
fjge_cont.43392:
	fldi	%f1, %g5, 0
	fjlt	%f0, %f1, fjge_else.43393
	addi	%g8, %g0, 0
	jmp	fjge_cont.43394
fjge_else.43393:
	fldi	%f0, %g9, -4
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f7
	fjlt	%f1, %f16, fjge_else.43395
	fmov	%f0, %f1
	jmp	fjge_cont.43396
fjge_else.43395:
	fneg	%f0, %f1
fjge_cont.43396:
	fldi	%f1, %g5, -4
	fjlt	%f0, %f1, fjge_else.43397
	addi	%g8, %g0, 0
	jmp	fjge_cont.43398
fjge_else.43397:
	fsti	%f2, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.43398:
fjge_cont.43394:
	jmp	fjne_cont.43386
fjne_else.43385:
	addi	%g8, %g0, 0
fjne_cont.43386:
	jne	%g8, %g0, jeq_else.43399
	addi	%g8, %g0, 0
	jmp	jeq_cont.43400
jeq_else.43399:
	addi	%g8, %g0, 3
jeq_cont.43400:
	jmp	jeq_cont.43384
jeq_else.43383:
	addi	%g8, %g0, 2
jeq_cont.43384:
	jmp	jeq_cont.43368
jeq_else.43367:
	addi	%g8, %g0, 1
jeq_cont.43368:
	jmp	jeq_cont.43352
jeq_else.43351:
	addi	%g8, %g0, 2
	jne	%g3, %g8, jeq_else.43401
	ldi	%g3, %g7, -16
	fldi	%f0, %g9, 0
	fldi	%f4, %g3, 0
	fmul	%f1, %f0, %f4
	fldi	%f0, %g9, -4
	fldi	%f3, %g3, -4
	fmul	%f0, %f0, %f3
	fadd	%f2, %f1, %f0
	fldi	%f0, %g9, -8
	fldi	%f1, %g3, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	fjlt	%f16, %f0, fjge_else.43403
	addi	%g8, %g0, 0
	jmp	fjge_cont.43404
fjge_else.43403:
	fmul	%f4, %f4, %f6
	fmul	%f2, %f3, %f7
	fadd	%f2, %f4, %f2
	fmul	%f1, %f1, %f5
	fadd	%f1, %f2, %f1
	fneg	%f1, %f1
	fdiv	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.43404:
	jmp	jeq_cont.43402
jeq_else.43401:
	fldi	%f1, %g9, 0
	fldi	%f2, %g9, -4
	fldi	%f0, %g9, -8
	fmul	%f3, %f1, %f1
	ldi	%g5, %g7, -16
	fldi	%f10, %g5, 0
	fmul	%f4, %f3, %f10
	fmul	%f3, %f2, %f2
	fldi	%f12, %g5, -4
	fmul	%f3, %f3, %f12
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f0
	fldi	%f11, %g5, -8
	fmul	%f3, %f3, %f11
	fadd	%f3, %f4, %f3
	ldi	%g6, %g7, -12
	jne	%g6, %g0, jeq_else.43405
	fmov	%f9, %f3
	jmp	jeq_cont.43406
jeq_else.43405:
	fmul	%f8, %f2, %f0
	ldi	%g5, %g7, -36
	fldi	%f4, %g5, 0
	fmul	%f4, %f8, %f4
	fadd	%f8, %f3, %f4
	fmul	%f4, %f0, %f1
	fldi	%f3, %g5, -4
	fmul	%f3, %f4, %f3
	fadd	%f8, %f8, %f3
	fmul	%f4, %f1, %f2
	fldi	%f3, %g5, -8
	fmul	%f9, %f4, %f3
	fadd	%f9, %f8, %f9
jeq_cont.43406:
	fjeq	%f9, %f16, fjne_else.43407
	fmul	%f3, %f1, %f6
	fmul	%f4, %f3, %f10
	fmul	%f3, %f2, %f7
	fmul	%f3, %f3, %f12
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f5
	fmul	%f3, %f3, %f11
	fadd	%f8, %f4, %f3
	jne	%g6, %g0, jeq_else.43409
	fmov	%f3, %f8
	jmp	jeq_cont.43410
jeq_else.43409:
	fmul	%f4, %f0, %f7
	fmul	%f3, %f2, %f5
	fadd	%f4, %f4, %f3
	ldi	%g5, %g7, -36
	fldi	%f3, %g5, 0
	fmul	%f4, %f4, %f3
	fmul	%f3, %f1, %f5
	fmul	%f0, %f0, %f6
	fadd	%f3, %f3, %f0
	fldi	%f0, %g5, -4
	fmul	%f0, %f3, %f0
	fadd	%f0, %f4, %f0
	fmul	%f3, %f1, %f7
	fmul	%f1, %f2, %f6
	fadd	%f2, %f3, %f1
	fldi	%f1, %g5, -8
	fmul	%f1, %f2, %f1
	fadd	%f0, %f0, %f1
	fmul	%f3, %f0, %f21
	fadd	%f3, %f8, %f3
jeq_cont.43410:
	fmul	%f0, %f6, %f6
	fmul	%f1, %f0, %f10
	fmul	%f0, %f7, %f7
	fmul	%f0, %f0, %f12
	fadd	%f1, %f1, %f0
	fmul	%f0, %f5, %f5
	fmul	%f0, %f0, %f11
	fadd	%f1, %f1, %f0
	jne	%g6, %g0, jeq_else.43411
	fmov	%f0, %f1
	jmp	jeq_cont.43412
jeq_else.43411:
	fmul	%f2, %f7, %f5
	ldi	%g5, %g7, -36
	fldi	%f0, %g5, 0
	fmul	%f0, %f2, %f0
	fadd	%f2, %f1, %f0
	fmul	%f1, %f5, %f6
	fldi	%f0, %g5, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fmul	%f1, %f6, %f7
	fldi	%f0, %g5, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
jeq_cont.43412:
	addi	%g5, %g0, 3
	jne	%g3, %g5, jeq_else.43413
	fsub	%f1, %f0, %f17
	jmp	jeq_cont.43414
jeq_else.43413:
	fmov	%f1, %f0
jeq_cont.43414:
	fmul	%f2, %f3, %f3
	fmul	%f0, %f9, %f1
	fsub	%f0, %f2, %f0
	fjlt	%f16, %f0, fjge_else.43415
	addi	%g8, %g0, 0
	jmp	fjge_cont.43416
fjge_else.43415:
	fsqrt	%f0, %f0
	ldi	%g3, %g7, -24
	jne	%g3, %g0, jeq_else.43417
	fneg	%f1, %f0
	jmp	jeq_cont.43418
jeq_else.43417:
	fmov	%f1, %f0
jeq_cont.43418:
	fsub	%f0, %f1, %f3
	fdiv	%f0, %f0, %f9
	fsti	%f0, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.43416:
	jmp	fjne_cont.43408
fjne_else.43407:
	addi	%g8, %g0, 0
fjne_cont.43408:
jeq_cont.43402:
jeq_cont.43352:
	jne	%g8, %g0, jeq_else.43419
	slli	%g3, %g10, 2
	add	%g3, %g31, %g3
	ldi	%g3, %g3, 272
	ldi	%g3, %g3, -24
	jne	%g3, %g0, jeq_else.43420
	return
jeq_else.43420:
	addi	%g11, %g11, 1
	jmp	solve_each_element.2863
jeq_else.43419:
	fldi	%f0, %g31, 520
	sti	%g4, %g1, 0
	fjlt	%f16, %f0, fjge_else.43422
	jmp	fjge_cont.43423
fjge_else.43422:
	fldi	%f1, %g31, 528
	fjlt	%f0, %f1, fjge_else.43424
	jmp	fjge_cont.43425
fjge_else.43424:
	setL %g3, l.36805
	fldi	%f1, %g3, 0
	fadd	%f9, %f0, %f1
	fldi	%f0, %g9, 0
	fmul	%f1, %f0, %f9
	fldi	%f0, %g31, 624
	fadd	%f5, %f1, %f0
	fldi	%f0, %g9, -4
	fmul	%f1, %f0, %f9
	fldi	%f0, %g31, 620
	fadd	%f4, %f1, %f0
	fldi	%f0, %g9, -8
	fmul	%f1, %f0, %f9
	fldi	%f0, %g31, 616
	fadd	%f3, %f1, %f0
	ldi	%g5, %g4, 0
	fsti	%f3, %g1, 4
	fsti	%f4, %g1, 8
	fsti	%f5, %g1, 12
	jne	%g5, %g29, jeq_else.43426
	addi	%g3, %g0, 1
	jmp	jeq_cont.43427
jeq_else.43426:
	slli	%g3, %g5, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 272
	ldi	%g3, %g6, -20
	fldi	%f0, %g3, 0
	fsub	%f0, %f5, %f0
	fldi	%f1, %g3, -4
	fsub	%f2, %f4, %f1
	fldi	%f1, %g3, -8
	fsub	%f1, %f3, %f1
	ldi	%g5, %g6, -4
	jne	%g5, %g28, jeq_else.43428
	fjlt	%f0, %f16, fjge_else.43430
	fmov	%f6, %f0
	jmp	fjge_cont.43431
fjge_else.43430:
	fneg	%f6, %f0
fjge_cont.43431:
	ldi	%g3, %g6, -16
	fldi	%f0, %g3, 0
	fjlt	%f6, %f0, fjge_else.43432
	addi	%g5, %g0, 0
	jmp	fjge_cont.43433
fjge_else.43432:
	fjlt	%f2, %f16, fjge_else.43434
	fmov	%f0, %f2
	jmp	fjge_cont.43435
fjge_else.43434:
	fneg	%f0, %f2
fjge_cont.43435:
	fldi	%f2, %g3, -4
	fjlt	%f0, %f2, fjge_else.43436
	addi	%g5, %g0, 0
	jmp	fjge_cont.43437
fjge_else.43436:
	fjlt	%f1, %f16, fjge_else.43438
	fmov	%f0, %f1
	jmp	fjge_cont.43439
fjge_else.43438:
	fneg	%f0, %f1
fjge_cont.43439:
	fldi	%f1, %g3, -8
	fjlt	%f0, %f1, fjge_else.43440
	addi	%g5, %g0, 0
	jmp	fjge_cont.43441
fjge_else.43440:
	addi	%g5, %g0, 1
fjge_cont.43441:
fjge_cont.43437:
fjge_cont.43433:
	jne	%g5, %g0, jeq_else.43442
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.43444
	addi	%g3, %g0, 1
	jmp	jeq_cont.43445
jeq_else.43444:
	addi	%g3, %g0, 0
jeq_cont.43445:
	jmp	jeq_cont.43443
jeq_else.43442:
	ldi	%g3, %g6, -24
jeq_cont.43443:
	jmp	jeq_cont.43429
jeq_else.43428:
	addi	%g3, %g0, 2
	jne	%g5, %g3, jeq_else.43446
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, 0
	fmul	%f6, %f6, %f0
	fldi	%f0, %g3, -4
	fmul	%f0, %f0, %f2
	fadd	%f2, %f6, %f0
	fldi	%f0, %g3, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.43448
	addi	%g5, %g0, 0
	jmp	fjge_cont.43449
fjge_else.43448:
	addi	%g5, %g0, 1
fjge_cont.43449:
	jne	%g3, %g5, jeq_else.43450
	addi	%g3, %g0, 1
	jmp	jeq_cont.43451
jeq_else.43450:
	addi	%g3, %g0, 0
jeq_cont.43451:
	jmp	jeq_cont.43447
jeq_else.43446:
	fmul	%f7, %f0, %f0
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, 0
	fmul	%f8, %f7, %f6
	fmul	%f7, %f2, %f2
	fldi	%f6, %g3, -4
	fmul	%f6, %f7, %f6
	fadd	%f8, %f8, %f6
	fmul	%f7, %f1, %f1
	fldi	%f6, %g3, -8
	fmul	%f6, %f7, %f6
	fadd	%f7, %f8, %f6
	ldi	%g3, %g6, -12
	jne	%g3, %g0, jeq_else.43452
	fmov	%f6, %f7
	jmp	jeq_cont.43453
jeq_else.43452:
	fmul	%f8, %f2, %f1
	ldi	%g3, %g6, -36
	fldi	%f6, %g3, 0
	fmul	%f6, %f8, %f6
	fadd	%f7, %f7, %f6
	fmul	%f6, %f1, %f0
	fldi	%f1, %g3, -4
	fmul	%f1, %f6, %f1
	fadd	%f7, %f7, %f1
	fmul	%f1, %f0, %f2
	fldi	%f0, %g3, -8
	fmul	%f6, %f1, %f0
	fadd	%f6, %f7, %f6
jeq_cont.43453:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.43454
	fsub	%f0, %f6, %f17
	jmp	jeq_cont.43455
jeq_else.43454:
	fmov	%f0, %f6
jeq_cont.43455:
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.43456
	addi	%g5, %g0, 0
	jmp	fjge_cont.43457
fjge_else.43456:
	addi	%g5, %g0, 1
fjge_cont.43457:
	jne	%g3, %g5, jeq_else.43458
	addi	%g3, %g0, 1
	jmp	jeq_cont.43459
jeq_else.43458:
	addi	%g3, %g0, 0
jeq_cont.43459:
jeq_cont.43447:
jeq_cont.43429:
	jne	%g3, %g0, jeq_else.43460
	addi	%g5, %g0, 1
	subi	%g1, %g1, 20
	call	check_all_inside.2848
	addi	%g1, %g1, 20
	jmp	jeq_cont.43461
jeq_else.43460:
	addi	%g3, %g0, 0
jeq_cont.43461:
jeq_cont.43427:
	jne	%g3, %g0, jeq_else.43462
	jmp	jeq_cont.43463
jeq_else.43462:
	fsti	%f9, %g31, 528
	fldi	%f5, %g1, 12
	fsti	%f5, %g31, 540
	fldi	%f4, %g1, 8
	fsti	%f4, %g31, 536
	fldi	%f3, %g1, 4
	fsti	%f3, %g31, 532
	sti	%g10, %g31, 544
	sti	%g8, %g31, 524
jeq_cont.43463:
fjge_cont.43425:
fjge_cont.43423:
	addi	%g11, %g11, 1
	ldi	%g4, %g1, 0
	jmp	solve_each_element.2863

!==============================
! args = [%g13, %g12, %g9]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f2, %f17, %f16, %f15, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
solve_one_or_network.2867:
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.43464
	return
jeq_else.43464:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	sti	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.43466
	return
jeq_else.43466:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.43468
	return
jeq_else.43468:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.43470
	return
jeq_else.43470:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.43472
	return
jeq_else.43472:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.43474
	return
jeq_else.43474:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.43476
	return
jeq_else.43476:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	slli	%g3, %g13, 2
	ld	%g3, %g12, %g3
	jne	%g3, %g29, jeq_else.43478
	return
jeq_else.43478:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	addi	%g13, %g13, 1
	ldi	%g9, %g1, 0
	jmp	solve_one_or_network.2867

!==============================
! args = [%g14, %g15, %g9]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f2, %f17, %f16, %f15, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
trace_or_matrix.2871:
	slli	%g3, %g14, 2
	ld	%g12, %g15, %g3
	ldi	%g3, %g12, 0
	jne	%g3, %g29, jeq_else.43480
	return
jeq_else.43480:
	addi	%g4, %g0, 99
	sti	%g9, %g1, 0
	jne	%g3, %g4, jeq_else.43482
	ldi	%g3, %g12, -4
	jne	%g3, %g29, jeq_else.43484
	jmp	jeq_cont.43485
jeq_else.43484:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -8
	jne	%g3, %g29, jeq_else.43486
	jmp	jeq_cont.43487
jeq_else.43486:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -12
	jne	%g3, %g29, jeq_else.43488
	jmp	jeq_cont.43489
jeq_else.43488:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -16
	jne	%g3, %g29, jeq_else.43490
	jmp	jeq_cont.43491
jeq_else.43490:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -20
	jne	%g3, %g29, jeq_else.43492
	jmp	jeq_cont.43493
jeq_else.43492:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -24
	jne	%g3, %g29, jeq_else.43494
	jmp	jeq_cont.43495
jeq_else.43494:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -28
	jne	%g3, %g29, jeq_else.43496
	jmp	jeq_cont.43497
jeq_else.43496:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	addi	%g13, %g0, 8
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_one_or_network.2867
	addi	%g1, %g1, 8
jeq_cont.43497:
jeq_cont.43495:
jeq_cont.43493:
jeq_cont.43491:
jeq_cont.43489:
jeq_cont.43487:
jeq_cont.43485:
	jmp	jeq_cont.43483
jeq_else.43482:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 272
	fldi	%f1, %g31, 624
	ldi	%g3, %g6, -20
	fldi	%f0, %g3, 0
	fsub	%f5, %f1, %f0
	fldi	%f1, %g31, 620
	fldi	%f0, %g3, -4
	fsub	%f6, %f1, %f0
	fldi	%f1, %g31, 616
	fldi	%f0, %g3, -8
	fsub	%f4, %f1, %f0
	ldi	%g4, %g6, -4
	jne	%g4, %g28, jeq_else.43498
	fldi	%f2, %g9, 0
	fjeq	%f2, %f16, fjne_else.43500
	ldi	%g4, %g6, -16
	ldi	%g3, %g6, -24
	fjlt	%f2, %f16, fjge_else.43502
	addi	%g5, %g0, 0
	jmp	fjge_cont.43503
fjge_else.43502:
	addi	%g5, %g0, 1
fjge_cont.43503:
	fldi	%f1, %g4, 0
	jne	%g3, %g5, jeq_else.43504
	fneg	%f0, %f1
	jmp	jeq_cont.43505
jeq_else.43504:
	fmov	%f0, %f1
jeq_cont.43505:
	fsub	%f0, %f0, %f5
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, -4
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f6
	fjlt	%f1, %f16, fjge_else.43506
	fmov	%f0, %f1
	jmp	fjge_cont.43507
fjge_else.43506:
	fneg	%f0, %f1
fjge_cont.43507:
	fldi	%f1, %g4, -4
	fjlt	%f0, %f1, fjge_else.43508
	addi	%g3, %g0, 0
	jmp	fjge_cont.43509
fjge_else.43508:
	fldi	%f0, %g9, -8
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f4
	fjlt	%f1, %f16, fjge_else.43510
	fmov	%f0, %f1
	jmp	fjge_cont.43511
fjge_else.43510:
	fneg	%f0, %f1
fjge_cont.43511:
	fldi	%f1, %g4, -8
	fjlt	%f0, %f1, fjge_else.43512
	addi	%g3, %g0, 0
	jmp	fjge_cont.43513
fjge_else.43512:
	fsti	%f2, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.43513:
fjge_cont.43509:
	jmp	fjne_cont.43501
fjne_else.43500:
	addi	%g3, %g0, 0
fjne_cont.43501:
	jne	%g3, %g0, jeq_else.43514
	fldi	%f2, %g9, -4
	fjeq	%f2, %f16, fjne_else.43516
	ldi	%g4, %g6, -16
	ldi	%g3, %g6, -24
	fjlt	%f2, %f16, fjge_else.43518
	addi	%g5, %g0, 0
	jmp	fjge_cont.43519
fjge_else.43518:
	addi	%g5, %g0, 1
fjge_cont.43519:
	fldi	%f1, %g4, -4
	jne	%g3, %g5, jeq_else.43520
	fneg	%f0, %f1
	jmp	jeq_cont.43521
jeq_else.43520:
	fmov	%f0, %f1
jeq_cont.43521:
	fsub	%f0, %f0, %f6
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, -8
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f4
	fjlt	%f1, %f16, fjge_else.43522
	fmov	%f0, %f1
	jmp	fjge_cont.43523
fjge_else.43522:
	fneg	%f0, %f1
fjge_cont.43523:
	fldi	%f1, %g4, -8
	fjlt	%f0, %f1, fjge_else.43524
	addi	%g3, %g0, 0
	jmp	fjge_cont.43525
fjge_else.43524:
	fldi	%f0, %g9, 0
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f5
	fjlt	%f1, %f16, fjge_else.43526
	fmov	%f0, %f1
	jmp	fjge_cont.43527
fjge_else.43526:
	fneg	%f0, %f1
fjge_cont.43527:
	fldi	%f1, %g4, 0
	fjlt	%f0, %f1, fjge_else.43528
	addi	%g3, %g0, 0
	jmp	fjge_cont.43529
fjge_else.43528:
	fsti	%f2, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.43529:
fjge_cont.43525:
	jmp	fjne_cont.43517
fjne_else.43516:
	addi	%g3, %g0, 0
fjne_cont.43517:
	jne	%g3, %g0, jeq_else.43530
	fldi	%f2, %g9, -8
	fjeq	%f2, %f16, fjne_else.43532
	ldi	%g4, %g6, -16
	ldi	%g3, %g6, -24
	fjlt	%f2, %f16, fjge_else.43534
	addi	%g5, %g0, 0
	jmp	fjge_cont.43535
fjge_else.43534:
	addi	%g5, %g0, 1
fjge_cont.43535:
	fldi	%f1, %g4, -8
	jne	%g3, %g5, jeq_else.43536
	fneg	%f0, %f1
	jmp	jeq_cont.43537
jeq_else.43536:
	fmov	%f0, %f1
jeq_cont.43537:
	fsub	%f0, %f0, %f4
	fdiv	%f2, %f0, %f2
	fldi	%f0, %g9, 0
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f5
	fjlt	%f1, %f16, fjge_else.43538
	fmov	%f0, %f1
	jmp	fjge_cont.43539
fjge_else.43538:
	fneg	%f0, %f1
fjge_cont.43539:
	fldi	%f1, %g4, 0
	fjlt	%f0, %f1, fjge_else.43540
	addi	%g3, %g0, 0
	jmp	fjge_cont.43541
fjge_else.43540:
	fldi	%f0, %g9, -4
	fmul	%f0, %f2, %f0
	fadd	%f1, %f0, %f6
	fjlt	%f1, %f16, fjge_else.43542
	fmov	%f0, %f1
	jmp	fjge_cont.43543
fjge_else.43542:
	fneg	%f0, %f1
fjge_cont.43543:
	fldi	%f1, %g4, -4
	fjlt	%f0, %f1, fjge_else.43544
	addi	%g3, %g0, 0
	jmp	fjge_cont.43545
fjge_else.43544:
	fsti	%f2, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.43545:
fjge_cont.43541:
	jmp	fjne_cont.43533
fjne_else.43532:
	addi	%g3, %g0, 0
fjne_cont.43533:
	jne	%g3, %g0, jeq_else.43546
	addi	%g3, %g0, 0
	jmp	jeq_cont.43547
jeq_else.43546:
	addi	%g3, %g0, 3
jeq_cont.43547:
	jmp	jeq_cont.43531
jeq_else.43530:
	addi	%g3, %g0, 2
jeq_cont.43531:
	jmp	jeq_cont.43515
jeq_else.43514:
	addi	%g3, %g0, 1
jeq_cont.43515:
	jmp	jeq_cont.43499
jeq_else.43498:
	addi	%g3, %g0, 2
	jne	%g4, %g3, jeq_else.43548
	ldi	%g3, %g6, -16
	fldi	%f0, %g9, 0
	fldi	%f7, %g3, 0
	fmul	%f1, %f0, %f7
	fldi	%f0, %g9, -4
	fldi	%f3, %g3, -4
	fmul	%f0, %f0, %f3
	fadd	%f2, %f1, %f0
	fldi	%f0, %g9, -8
	fldi	%f1, %g3, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	fjlt	%f16, %f0, fjge_else.43550
	addi	%g3, %g0, 0
	jmp	fjge_cont.43551
fjge_else.43550:
	fmul	%f5, %f7, %f5
	fmul	%f2, %f3, %f6
	fadd	%f2, %f5, %f2
	fmul	%f1, %f1, %f4
	fadd	%f1, %f2, %f1
	fneg	%f1, %f1
	fdiv	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.43551:
	jmp	jeq_cont.43549
jeq_else.43548:
	fldi	%f1, %g9, 0
	fldi	%f2, %g9, -4
	fldi	%f0, %g9, -8
	fmul	%f3, %f1, %f1
	ldi	%g3, %g6, -16
	fldi	%f9, %g3, 0
	fmul	%f7, %f3, %f9
	fmul	%f3, %f2, %f2
	fldi	%f11, %g3, -4
	fmul	%f3, %f3, %f11
	fadd	%f7, %f7, %f3
	fmul	%f3, %f0, %f0
	fldi	%f10, %g3, -8
	fmul	%f3, %f3, %f10
	fadd	%f3, %f7, %f3
	ldi	%g5, %g6, -12
	jne	%g5, %g0, jeq_else.43552
	fmov	%f8, %f3
	jmp	jeq_cont.43553
jeq_else.43552:
	fmul	%f8, %f2, %f0
	ldi	%g3, %g6, -36
	fldi	%f7, %g3, 0
	fmul	%f7, %f8, %f7
	fadd	%f8, %f3, %f7
	fmul	%f7, %f0, %f1
	fldi	%f3, %g3, -4
	fmul	%f3, %f7, %f3
	fadd	%f12, %f8, %f3
	fmul	%f7, %f1, %f2
	fldi	%f3, %g3, -8
	fmul	%f8, %f7, %f3
	fadd	%f8, %f12, %f8
jeq_cont.43553:
	fjeq	%f8, %f16, fjne_else.43554
	fmul	%f3, %f1, %f5
	fmul	%f7, %f3, %f9
	fmul	%f3, %f2, %f6
	fmul	%f3, %f3, %f11
	fadd	%f7, %f7, %f3
	fmul	%f3, %f0, %f4
	fmul	%f3, %f3, %f10
	fadd	%f7, %f7, %f3
	jne	%g5, %g0, jeq_else.43556
	fmov	%f3, %f7
	jmp	jeq_cont.43557
jeq_else.43556:
	fmul	%f12, %f0, %f6
	fmul	%f3, %f2, %f4
	fadd	%f12, %f12, %f3
	ldi	%g3, %g6, -36
	fldi	%f3, %g3, 0
	fmul	%f3, %f12, %f3
	fmul	%f12, %f1, %f4
	fmul	%f0, %f0, %f5
	fadd	%f12, %f12, %f0
	fldi	%f0, %g3, -4
	fmul	%f0, %f12, %f0
	fadd	%f0, %f3, %f0
	fmul	%f3, %f1, %f6
	fmul	%f1, %f2, %f5
	fadd	%f2, %f3, %f1
	fldi	%f1, %g3, -8
	fmul	%f1, %f2, %f1
	fadd	%f0, %f0, %f1
	fmul	%f3, %f0, %f21
	fadd	%f3, %f7, %f3
jeq_cont.43557:
	fmul	%f0, %f5, %f5
	fmul	%f1, %f0, %f9
	fmul	%f0, %f6, %f6
	fmul	%f0, %f0, %f11
	fadd	%f1, %f1, %f0
	fmul	%f0, %f4, %f4
	fmul	%f0, %f0, %f10
	fadd	%f1, %f1, %f0
	jne	%g5, %g0, jeq_else.43558
	fmov	%f0, %f1
	jmp	jeq_cont.43559
jeq_else.43558:
	fmul	%f2, %f6, %f4
	ldi	%g3, %g6, -36
	fldi	%f0, %g3, 0
	fmul	%f0, %f2, %f0
	fadd	%f2, %f1, %f0
	fmul	%f1, %f4, %f5
	fldi	%f0, %g3, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fmul	%f1, %f5, %f6
	fldi	%f0, %g3, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
jeq_cont.43559:
	addi	%g3, %g0, 3
	jne	%g4, %g3, jeq_else.43560
	fsub	%f1, %f0, %f17
	jmp	jeq_cont.43561
jeq_else.43560:
	fmov	%f1, %f0
jeq_cont.43561:
	fmul	%f2, %f3, %f3
	fmul	%f0, %f8, %f1
	fsub	%f0, %f2, %f0
	fjlt	%f16, %f0, fjge_else.43562
	addi	%g3, %g0, 0
	jmp	fjge_cont.43563
fjge_else.43562:
	fsqrt	%f0, %f0
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.43564
	fneg	%f1, %f0
	jmp	jeq_cont.43565
jeq_else.43564:
	fmov	%f1, %f0
jeq_cont.43565:
	fsub	%f0, %f1, %f3
	fdiv	%f0, %f0, %f8
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.43563:
	jmp	fjne_cont.43555
fjne_else.43554:
	addi	%g3, %g0, 0
fjne_cont.43555:
jeq_cont.43549:
jeq_cont.43499:
	jne	%g3, %g0, jeq_else.43566
	jmp	jeq_cont.43567
jeq_else.43566:
	fldi	%f0, %g31, 520
	fldi	%f1, %g31, 528
	fjlt	%f0, %f1, fjge_else.43568
	jmp	fjge_cont.43569
fjge_else.43568:
	ldi	%g3, %g12, -4
	jne	%g3, %g29, jeq_else.43570
	jmp	jeq_cont.43571
jeq_else.43570:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -8
	jne	%g3, %g29, jeq_else.43572
	jmp	jeq_cont.43573
jeq_else.43572:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -12
	jne	%g3, %g29, jeq_else.43574
	jmp	jeq_cont.43575
jeq_else.43574:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -16
	jne	%g3, %g29, jeq_else.43576
	jmp	jeq_cont.43577
jeq_else.43576:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -20
	jne	%g3, %g29, jeq_else.43578
	jmp	jeq_cont.43579
jeq_else.43578:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -24
	jne	%g3, %g29, jeq_else.43580
	jmp	jeq_cont.43581
jeq_else.43580:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	ldi	%g3, %g12, -28
	jne	%g3, %g29, jeq_else.43582
	jmp	jeq_cont.43583
jeq_else.43582:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g11, %g0, 0
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_each_element.2863
	addi	%g1, %g1, 8
	addi	%g13, %g0, 8
	ldi	%g9, %g1, 0
	subi	%g1, %g1, 8
	call	solve_one_or_network.2867
	addi	%g1, %g1, 8
jeq_cont.43583:
jeq_cont.43581:
jeq_cont.43579:
jeq_cont.43577:
jeq_cont.43575:
jeq_cont.43573:
jeq_cont.43571:
fjge_cont.43569:
jeq_cont.43567:
jeq_cont.43483:
	addi	%g14, %g14, 1
	ldi	%g9, %g1, 0
	jmp	trace_or_matrix.2871

!==============================
! args = [%g10, %g4, %g12, %g11]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
solve_each_element_fast.2877:
	slli	%g3, %g10, 2
	ld	%g9, %g4, %g3
	jne	%g9, %g29, jeq_else.43584
	return
jeq_else.43584:
	slli	%g3, %g9, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 272
	ldi	%g5, %g6, -40
	fldi	%f3, %g5, 0
	fldi	%f4, %g5, -4
	fldi	%f2, %g5, -8
	slli	%g3, %g9, 2
	ld	%g7, %g11, %g3
	ldi	%g3, %g6, -4
	jne	%g3, %g28, jeq_else.43586
	fldi	%f0, %g7, 0
	fsub	%f0, %f0, %f3
	fldi	%f1, %g7, -4
	fmul	%f0, %f0, %f1
	fldi	%f5, %g12, -4
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f4
	fjlt	%f6, %f16, fjge_else.43588
	fmov	%f5, %f6
	jmp	fjge_cont.43589
fjge_else.43588:
	fneg	%f5, %f6
fjge_cont.43589:
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, -4
	fjlt	%f5, %f6, fjge_else.43590
	addi	%g8, %g0, 0
	jmp	fjge_cont.43591
fjge_else.43590:
	fldi	%f5, %g12, -8
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f2
	fjlt	%f6, %f16, fjge_else.43592
	fmov	%f5, %f6
	jmp	fjge_cont.43593
fjge_else.43592:
	fneg	%f5, %f6
fjge_cont.43593:
	fldi	%f6, %g3, -8
	fjlt	%f5, %f6, fjge_else.43594
	addi	%g8, %g0, 0
	jmp	fjge_cont.43595
fjge_else.43594:
	fjeq	%f1, %f16, fjne_else.43596
	addi	%g8, %g0, 1
	jmp	fjne_cont.43597
fjne_else.43596:
	addi	%g8, %g0, 0
fjne_cont.43597:
fjge_cont.43595:
fjge_cont.43591:
	jne	%g8, %g0, jeq_else.43598
	fldi	%f0, %g7, -8
	fsub	%f0, %f0, %f4
	fldi	%f1, %g7, -12
	fmul	%f0, %f0, %f1
	fldi	%f5, %g12, 0
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f3
	fjlt	%f6, %f16, fjge_else.43600
	fmov	%f5, %f6
	jmp	fjge_cont.43601
fjge_else.43600:
	fneg	%f5, %f6
fjge_cont.43601:
	fldi	%f6, %g3, 0
	fjlt	%f5, %f6, fjge_else.43602
	addi	%g8, %g0, 0
	jmp	fjge_cont.43603
fjge_else.43602:
	fldi	%f5, %g12, -8
	fmul	%f5, %f0, %f5
	fadd	%f6, %f5, %f2
	fjlt	%f6, %f16, fjge_else.43604
	fmov	%f5, %f6
	jmp	fjge_cont.43605
fjge_else.43604:
	fneg	%f5, %f6
fjge_cont.43605:
	fldi	%f6, %g3, -8
	fjlt	%f5, %f6, fjge_else.43606
	addi	%g8, %g0, 0
	jmp	fjge_cont.43607
fjge_else.43606:
	fjeq	%f1, %f16, fjne_else.43608
	addi	%g8, %g0, 1
	jmp	fjne_cont.43609
fjne_else.43608:
	addi	%g8, %g0, 0
fjne_cont.43609:
fjge_cont.43607:
fjge_cont.43603:
	jne	%g8, %g0, jeq_else.43610
	fldi	%f0, %g7, -16
	fsub	%f1, %f0, %f2
	fldi	%f0, %g7, -20
	fmul	%f5, %f1, %f0
	fldi	%f1, %g12, 0
	fmul	%f1, %f5, %f1
	fadd	%f2, %f1, %f3
	fjlt	%f2, %f16, fjge_else.43612
	fmov	%f1, %f2
	jmp	fjge_cont.43613
fjge_else.43612:
	fneg	%f1, %f2
fjge_cont.43613:
	fldi	%f2, %g3, 0
	fjlt	%f1, %f2, fjge_else.43614
	addi	%g8, %g0, 0
	jmp	fjge_cont.43615
fjge_else.43614:
	fldi	%f1, %g12, -4
	fmul	%f1, %f5, %f1
	fadd	%f2, %f1, %f4
	fjlt	%f2, %f16, fjge_else.43616
	fmov	%f1, %f2
	jmp	fjge_cont.43617
fjge_else.43616:
	fneg	%f1, %f2
fjge_cont.43617:
	fldi	%f2, %g3, -4
	fjlt	%f1, %f2, fjge_else.43618
	addi	%g8, %g0, 0
	jmp	fjge_cont.43619
fjge_else.43618:
	fjeq	%f0, %f16, fjne_else.43620
	addi	%g8, %g0, 1
	jmp	fjne_cont.43621
fjne_else.43620:
	addi	%g8, %g0, 0
fjne_cont.43621:
fjge_cont.43619:
fjge_cont.43615:
	jne	%g8, %g0, jeq_else.43622
	addi	%g8, %g0, 0
	jmp	jeq_cont.43623
jeq_else.43622:
	fsti	%f5, %g31, 520
	addi	%g8, %g0, 3
jeq_cont.43623:
	jmp	jeq_cont.43611
jeq_else.43610:
	fsti	%f0, %g31, 520
	addi	%g8, %g0, 2
jeq_cont.43611:
	jmp	jeq_cont.43599
jeq_else.43598:
	fsti	%f0, %g31, 520
	addi	%g8, %g0, 1
jeq_cont.43599:
	jmp	jeq_cont.43587
jeq_else.43586:
	addi	%g8, %g0, 2
	jne	%g3, %g8, jeq_else.43624
	fldi	%f1, %g7, 0
	fjlt	%f1, %f16, fjge_else.43626
	addi	%g8, %g0, 0
	jmp	fjge_cont.43627
fjge_else.43626:
	fldi	%f0, %g5, -12
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	addi	%g8, %g0, 1
fjge_cont.43627:
	jmp	jeq_cont.43625
jeq_else.43624:
	fldi	%f5, %g7, 0
	fjeq	%f5, %f16, fjne_else.43628
	fldi	%f0, %g7, -4
	fmul	%f1, %f0, %f3
	fldi	%f0, %g7, -8
	fmul	%f0, %f0, %f4
	fadd	%f1, %f1, %f0
	fldi	%f0, %g7, -12
	fmul	%f0, %f0, %f2
	fadd	%f1, %f1, %f0
	fldi	%f0, %g5, -12
	fmul	%f2, %f1, %f1
	fmul	%f0, %f5, %f0
	fsub	%f0, %f2, %f0
	fjlt	%f16, %f0, fjge_else.43630
	addi	%g8, %g0, 0
	jmp	fjge_cont.43631
fjge_else.43630:
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.43632
	fsqrt	%f0, %f0
	fsub	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	jmp	jeq_cont.43633
jeq_else.43632:
	fsqrt	%f0, %f0
	fadd	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
jeq_cont.43633:
	addi	%g8, %g0, 1
fjge_cont.43631:
	jmp	fjne_cont.43629
fjne_else.43628:
	addi	%g8, %g0, 0
fjne_cont.43629:
jeq_cont.43625:
jeq_cont.43587:
	jne	%g8, %g0, jeq_else.43634
	slli	%g3, %g9, 2
	add	%g3, %g31, %g3
	ldi	%g3, %g3, 272
	ldi	%g3, %g3, -24
	jne	%g3, %g0, jeq_else.43635
	return
jeq_else.43635:
	addi	%g10, %g10, 1
	jmp	solve_each_element_fast.2877
jeq_else.43634:
	fldi	%f0, %g31, 520
	sti	%g4, %g1, 0
	fjlt	%f16, %f0, fjge_else.43637
	jmp	fjge_cont.43638
fjge_else.43637:
	fldi	%f1, %g31, 528
	fjlt	%f0, %f1, fjge_else.43639
	jmp	fjge_cont.43640
fjge_else.43639:
	setL %g3, l.36805
	fldi	%f1, %g3, 0
	fadd	%f9, %f0, %f1
	fldi	%f0, %g12, 0
	fmul	%f1, %f0, %f9
	fldi	%f0, %g31, 636
	fadd	%f5, %f1, %f0
	fldi	%f0, %g12, -4
	fmul	%f1, %f0, %f9
	fldi	%f0, %g31, 632
	fadd	%f4, %f1, %f0
	fldi	%f0, %g12, -8
	fmul	%f1, %f0, %f9
	fldi	%f0, %g31, 628
	fadd	%f3, %f1, %f0
	ldi	%g5, %g4, 0
	fsti	%f3, %g1, 4
	fsti	%f4, %g1, 8
	fsti	%f5, %g1, 12
	jne	%g5, %g29, jeq_else.43641
	addi	%g3, %g0, 1
	jmp	jeq_cont.43642
jeq_else.43641:
	slli	%g3, %g5, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 272
	ldi	%g3, %g6, -20
	fldi	%f0, %g3, 0
	fsub	%f0, %f5, %f0
	fldi	%f1, %g3, -4
	fsub	%f2, %f4, %f1
	fldi	%f1, %g3, -8
	fsub	%f1, %f3, %f1
	ldi	%g5, %g6, -4
	jne	%g5, %g28, jeq_else.43643
	fjlt	%f0, %f16, fjge_else.43645
	fmov	%f6, %f0
	jmp	fjge_cont.43646
fjge_else.43645:
	fneg	%f6, %f0
fjge_cont.43646:
	ldi	%g3, %g6, -16
	fldi	%f0, %g3, 0
	fjlt	%f6, %f0, fjge_else.43647
	addi	%g5, %g0, 0
	jmp	fjge_cont.43648
fjge_else.43647:
	fjlt	%f2, %f16, fjge_else.43649
	fmov	%f0, %f2
	jmp	fjge_cont.43650
fjge_else.43649:
	fneg	%f0, %f2
fjge_cont.43650:
	fldi	%f2, %g3, -4
	fjlt	%f0, %f2, fjge_else.43651
	addi	%g5, %g0, 0
	jmp	fjge_cont.43652
fjge_else.43651:
	fjlt	%f1, %f16, fjge_else.43653
	fmov	%f0, %f1
	jmp	fjge_cont.43654
fjge_else.43653:
	fneg	%f0, %f1
fjge_cont.43654:
	fldi	%f1, %g3, -8
	fjlt	%f0, %f1, fjge_else.43655
	addi	%g5, %g0, 0
	jmp	fjge_cont.43656
fjge_else.43655:
	addi	%g5, %g0, 1
fjge_cont.43656:
fjge_cont.43652:
fjge_cont.43648:
	jne	%g5, %g0, jeq_else.43657
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.43659
	addi	%g3, %g0, 1
	jmp	jeq_cont.43660
jeq_else.43659:
	addi	%g3, %g0, 0
jeq_cont.43660:
	jmp	jeq_cont.43658
jeq_else.43657:
	ldi	%g3, %g6, -24
jeq_cont.43658:
	jmp	jeq_cont.43644
jeq_else.43643:
	addi	%g3, %g0, 2
	jne	%g5, %g3, jeq_else.43661
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, 0
	fmul	%f6, %f6, %f0
	fldi	%f0, %g3, -4
	fmul	%f0, %f0, %f2
	fadd	%f2, %f6, %f0
	fldi	%f0, %g3, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.43663
	addi	%g5, %g0, 0
	jmp	fjge_cont.43664
fjge_else.43663:
	addi	%g5, %g0, 1
fjge_cont.43664:
	jne	%g3, %g5, jeq_else.43665
	addi	%g3, %g0, 1
	jmp	jeq_cont.43666
jeq_else.43665:
	addi	%g3, %g0, 0
jeq_cont.43666:
	jmp	jeq_cont.43662
jeq_else.43661:
	fmul	%f7, %f0, %f0
	ldi	%g3, %g6, -16
	fldi	%f6, %g3, 0
	fmul	%f8, %f7, %f6
	fmul	%f7, %f2, %f2
	fldi	%f6, %g3, -4
	fmul	%f6, %f7, %f6
	fadd	%f8, %f8, %f6
	fmul	%f7, %f1, %f1
	fldi	%f6, %g3, -8
	fmul	%f6, %f7, %f6
	fadd	%f7, %f8, %f6
	ldi	%g3, %g6, -12
	jne	%g3, %g0, jeq_else.43667
	fmov	%f6, %f7
	jmp	jeq_cont.43668
jeq_else.43667:
	fmul	%f8, %f2, %f1
	ldi	%g3, %g6, -36
	fldi	%f6, %g3, 0
	fmul	%f6, %f8, %f6
	fadd	%f7, %f7, %f6
	fmul	%f6, %f1, %f0
	fldi	%f1, %g3, -4
	fmul	%f1, %f6, %f1
	fadd	%f7, %f7, %f1
	fmul	%f1, %f0, %f2
	fldi	%f0, %g3, -8
	fmul	%f6, %f1, %f0
	fadd	%f6, %f7, %f6
jeq_cont.43668:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.43669
	fsub	%f0, %f6, %f17
	jmp	jeq_cont.43670
jeq_else.43669:
	fmov	%f0, %f6
jeq_cont.43670:
	ldi	%g3, %g6, -24
	fjlt	%f0, %f16, fjge_else.43671
	addi	%g5, %g0, 0
	jmp	fjge_cont.43672
fjge_else.43671:
	addi	%g5, %g0, 1
fjge_cont.43672:
	jne	%g3, %g5, jeq_else.43673
	addi	%g3, %g0, 1
	jmp	jeq_cont.43674
jeq_else.43673:
	addi	%g3, %g0, 0
jeq_cont.43674:
jeq_cont.43662:
jeq_cont.43644:
	jne	%g3, %g0, jeq_else.43675
	addi	%g5, %g0, 1
	subi	%g1, %g1, 20
	call	check_all_inside.2848
	addi	%g1, %g1, 20
	jmp	jeq_cont.43676
jeq_else.43675:
	addi	%g3, %g0, 0
jeq_cont.43676:
jeq_cont.43642:
	jne	%g3, %g0, jeq_else.43677
	jmp	jeq_cont.43678
jeq_else.43677:
	fsti	%f9, %g31, 528
	fldi	%f5, %g1, 12
	fsti	%f5, %g31, 540
	fldi	%f4, %g1, 8
	fsti	%f4, %g31, 536
	fldi	%f3, %g1, 4
	fsti	%f3, %g31, 532
	sti	%g9, %g31, 544
	sti	%g8, %g31, 524
jeq_cont.43678:
fjge_cont.43640:
fjge_cont.43638:
	addi	%g10, %g10, 1
	ldi	%g4, %g1, 0
	jmp	solve_each_element_fast.2877

!==============================
! args = [%g16, %g15, %g14, %g13]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
solve_one_or_network_fast.2881:
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.43679
	return
jeq_else.43679:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.43681
	return
jeq_else.43681:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.43683
	return
jeq_else.43683:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.43685
	return
jeq_else.43685:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.43687
	return
jeq_else.43687:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.43689
	return
jeq_else.43689:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.43691
	return
jeq_else.43691:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	slli	%g3, %g16, 2
	ld	%g3, %g15, %g3
	jne	%g3, %g29, jeq_else.43693
	return
jeq_else.43693:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g13
	mov	%g12, %g14
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	addi	%g16, %g16, 1
	jmp	solve_one_or_network_fast.2881

!==============================
! args = [%g19, %g20, %g18, %g17]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
trace_or_matrix_fast.2885:
	slli	%g3, %g19, 2
	ld	%g15, %g20, %g3
	ldi	%g3, %g15, 0
	jne	%g3, %g29, jeq_else.43695
	return
jeq_else.43695:
	addi	%g4, %g0, 99
	jne	%g3, %g4, jeq_else.43697
	ldi	%g3, %g15, -4
	jne	%g3, %g29, jeq_else.43699
	jmp	jeq_cont.43700
jeq_else.43699:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -8
	jne	%g3, %g29, jeq_else.43701
	jmp	jeq_cont.43702
jeq_else.43701:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -12
	jne	%g3, %g29, jeq_else.43703
	jmp	jeq_cont.43704
jeq_else.43703:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -16
	jne	%g3, %g29, jeq_else.43705
	jmp	jeq_cont.43706
jeq_else.43705:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -20
	jne	%g3, %g29, jeq_else.43707
	jmp	jeq_cont.43708
jeq_else.43707:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -24
	jne	%g3, %g29, jeq_else.43709
	jmp	jeq_cont.43710
jeq_else.43709:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -28
	jne	%g3, %g29, jeq_else.43711
	jmp	jeq_cont.43712
jeq_else.43711:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g16, %g0, 8
	mov	%g13, %g17
	mov	%g14, %g18
	call	solve_one_or_network_fast.2881
	addi	%g1, %g1, 4
jeq_cont.43712:
jeq_cont.43710:
jeq_cont.43708:
jeq_cont.43706:
jeq_cont.43704:
jeq_cont.43702:
jeq_cont.43700:
	jmp	jeq_cont.43698
jeq_else.43697:
	slli	%g4, %g3, 2
	add	%g4, %g31, %g4
	ldi	%g6, %g4, 272
	ldi	%g5, %g6, -40
	fldi	%f2, %g5, 0
	fldi	%f3, %g5, -4
	fldi	%f1, %g5, -8
	slli	%g3, %g3, 2
	ld	%g7, %g17, %g3
	ldi	%g4, %g6, -4
	jne	%g4, %g28, jeq_else.43713
	fldi	%f0, %g7, 0
	fsub	%f4, %f0, %f2
	fldi	%f0, %g7, -4
	fmul	%f6, %f4, %f0
	fldi	%f4, %g18, -4
	fmul	%f4, %f6, %f4
	fadd	%f5, %f4, %f3
	fjlt	%f5, %f16, fjge_else.43715
	fmov	%f4, %f5
	jmp	fjge_cont.43716
fjge_else.43715:
	fneg	%f4, %f5
fjge_cont.43716:
	ldi	%g4, %g6, -16
	fldi	%f5, %g4, -4
	fjlt	%f4, %f5, fjge_else.43717
	addi	%g3, %g0, 0
	jmp	fjge_cont.43718
fjge_else.43717:
	fldi	%f4, %g18, -8
	fmul	%f4, %f6, %f4
	fadd	%f5, %f4, %f1
	fjlt	%f5, %f16, fjge_else.43719
	fmov	%f4, %f5
	jmp	fjge_cont.43720
fjge_else.43719:
	fneg	%f4, %f5
fjge_cont.43720:
	fldi	%f5, %g4, -8
	fjlt	%f4, %f5, fjge_else.43721
	addi	%g3, %g0, 0
	jmp	fjge_cont.43722
fjge_else.43721:
	fjeq	%f0, %f16, fjne_else.43723
	addi	%g3, %g0, 1
	jmp	fjne_cont.43724
fjne_else.43723:
	addi	%g3, %g0, 0
fjne_cont.43724:
fjge_cont.43722:
fjge_cont.43718:
	jne	%g3, %g0, jeq_else.43725
	fldi	%f0, %g7, -8
	fsub	%f0, %f0, %f3
	fldi	%f6, %g7, -12
	fmul	%f5, %f0, %f6
	fldi	%f0, %g18, 0
	fmul	%f0, %f5, %f0
	fadd	%f4, %f0, %f2
	fjlt	%f4, %f16, fjge_else.43727
	fmov	%f0, %f4
	jmp	fjge_cont.43728
fjge_else.43727:
	fneg	%f0, %f4
fjge_cont.43728:
	fldi	%f4, %g4, 0
	fjlt	%f0, %f4, fjge_else.43729
	addi	%g3, %g0, 0
	jmp	fjge_cont.43730
fjge_else.43729:
	fldi	%f0, %g18, -8
	fmul	%f0, %f5, %f0
	fadd	%f4, %f0, %f1
	fjlt	%f4, %f16, fjge_else.43731
	fmov	%f0, %f4
	jmp	fjge_cont.43732
fjge_else.43731:
	fneg	%f0, %f4
fjge_cont.43732:
	fldi	%f4, %g4, -8
	fjlt	%f0, %f4, fjge_else.43733
	addi	%g3, %g0, 0
	jmp	fjge_cont.43734
fjge_else.43733:
	fjeq	%f6, %f16, fjne_else.43735
	addi	%g3, %g0, 1
	jmp	fjne_cont.43736
fjne_else.43735:
	addi	%g3, %g0, 0
fjne_cont.43736:
fjge_cont.43734:
fjge_cont.43730:
	jne	%g3, %g0, jeq_else.43737
	fldi	%f0, %g7, -16
	fsub	%f0, %f0, %f1
	fldi	%f5, %g7, -20
	fmul	%f4, %f0, %f5
	fldi	%f0, %g18, 0
	fmul	%f0, %f4, %f0
	fadd	%f1, %f0, %f2
	fjlt	%f1, %f16, fjge_else.43739
	fmov	%f0, %f1
	jmp	fjge_cont.43740
fjge_else.43739:
	fneg	%f0, %f1
fjge_cont.43740:
	fldi	%f1, %g4, 0
	fjlt	%f0, %f1, fjge_else.43741
	addi	%g3, %g0, 0
	jmp	fjge_cont.43742
fjge_else.43741:
	fldi	%f0, %g18, -4
	fmul	%f0, %f4, %f0
	fadd	%f1, %f0, %f3
	fjlt	%f1, %f16, fjge_else.43743
	fmov	%f0, %f1
	jmp	fjge_cont.43744
fjge_else.43743:
	fneg	%f0, %f1
fjge_cont.43744:
	fldi	%f1, %g4, -4
	fjlt	%f0, %f1, fjge_else.43745
	addi	%g3, %g0, 0
	jmp	fjge_cont.43746
fjge_else.43745:
	fjeq	%f5, %f16, fjne_else.43747
	addi	%g3, %g0, 1
	jmp	fjne_cont.43748
fjne_else.43747:
	addi	%g3, %g0, 0
fjne_cont.43748:
fjge_cont.43746:
fjge_cont.43742:
	jne	%g3, %g0, jeq_else.43749
	addi	%g3, %g0, 0
	jmp	jeq_cont.43750
jeq_else.43749:
	fsti	%f4, %g31, 520
	addi	%g3, %g0, 3
jeq_cont.43750:
	jmp	jeq_cont.43738
jeq_else.43737:
	fsti	%f5, %g31, 520
	addi	%g3, %g0, 2
jeq_cont.43738:
	jmp	jeq_cont.43726
jeq_else.43725:
	fsti	%f6, %g31, 520
	addi	%g3, %g0, 1
jeq_cont.43726:
	jmp	jeq_cont.43714
jeq_else.43713:
	addi	%g3, %g0, 2
	jne	%g4, %g3, jeq_else.43751
	fldi	%f1, %g7, 0
	fjlt	%f1, %f16, fjge_else.43753
	addi	%g3, %g0, 0
	jmp	fjge_cont.43754
fjge_else.43753:
	fldi	%f0, %g5, -12
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	addi	%g3, %g0, 1
fjge_cont.43754:
	jmp	jeq_cont.43752
jeq_else.43751:
	fldi	%f4, %g7, 0
	fjeq	%f4, %f16, fjne_else.43755
	fldi	%f0, %g7, -4
	fmul	%f2, %f0, %f2
	fldi	%f0, %g7, -8
	fmul	%f0, %f0, %f3
	fadd	%f2, %f2, %f0
	fldi	%f0, %g7, -12
	fmul	%f0, %f0, %f1
	fadd	%f1, %f2, %f0
	fldi	%f0, %g5, -12
	fmul	%f2, %f1, %f1
	fmul	%f0, %f4, %f0
	fsub	%f0, %f2, %f0
	fjlt	%f16, %f0, fjge_else.43757
	addi	%g3, %g0, 0
	jmp	fjge_cont.43758
fjge_else.43757:
	ldi	%g3, %g6, -24
	jne	%g3, %g0, jeq_else.43759
	fsqrt	%f0, %f0
	fsub	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
	jmp	jeq_cont.43760
jeq_else.43759:
	fsqrt	%f0, %f0
	fadd	%f1, %f1, %f0
	fldi	%f0, %g7, -16
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 520
jeq_cont.43760:
	addi	%g3, %g0, 1
fjge_cont.43758:
	jmp	fjne_cont.43756
fjne_else.43755:
	addi	%g3, %g0, 0
fjne_cont.43756:
jeq_cont.43752:
jeq_cont.43714:
	jne	%g3, %g0, jeq_else.43761
	jmp	jeq_cont.43762
jeq_else.43761:
	fldi	%f0, %g31, 520
	fldi	%f1, %g31, 528
	fjlt	%f0, %f1, fjge_else.43763
	jmp	fjge_cont.43764
fjge_else.43763:
	ldi	%g3, %g15, -4
	jne	%g3, %g29, jeq_else.43765
	jmp	jeq_cont.43766
jeq_else.43765:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -8
	jne	%g3, %g29, jeq_else.43767
	jmp	jeq_cont.43768
jeq_else.43767:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -12
	jne	%g3, %g29, jeq_else.43769
	jmp	jeq_cont.43770
jeq_else.43769:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -16
	jne	%g3, %g29, jeq_else.43771
	jmp	jeq_cont.43772
jeq_else.43771:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -20
	jne	%g3, %g29, jeq_else.43773
	jmp	jeq_cont.43774
jeq_else.43773:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -24
	jne	%g3, %g29, jeq_else.43775
	jmp	jeq_cont.43776
jeq_else.43775:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g1, %g1, 4
	ldi	%g3, %g15, -28
	jne	%g3, %g29, jeq_else.43777
	jmp	jeq_cont.43778
jeq_else.43777:
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g4, %g3, 512
	addi	%g10, %g0, 0
	mov	%g11, %g17
	mov	%g12, %g18
	subi	%g1, %g1, 4
	call	solve_each_element_fast.2877
	addi	%g16, %g0, 8
	mov	%g13, %g17
	mov	%g14, %g18
	call	solve_one_or_network_fast.2881
	addi	%g1, %g1, 4
jeq_cont.43778:
jeq_cont.43776:
jeq_cont.43774:
jeq_cont.43772:
jeq_cont.43770:
jeq_cont.43768:
jeq_cont.43766:
fjge_cont.43764:
jeq_cont.43762:
jeq_cont.43698:
	addi	%g19, %g19, 1
	jmp	trace_or_matrix_fast.2885

!==============================
! args = [%g21, %g22]
! fargs = [%f11, %f10]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f3, %f2, %f17, %f16, %f15, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
trace_reflections.2907:
	jlt	%g21, %g0, jge_else.43779
	slli	%g3, %g21, 2
	add	%g3, %g31, %g3
	ldi	%g23, %g3, 1716
	ldi	%g24, %g23, -4
	setL %g3, l.35829
	fldi	%f0, %g3, 0
	fsti	%f0, %g31, 528
	addi	%g19, %g0, 0
	ldi	%g20, %g31, 516
	ldi	%g17, %g24, -4
	ldi	%g18, %g24, 0
	subi	%g1, %g1, 4
	call	trace_or_matrix_fast.2885
	addi	%g1, %g1, 4
	fldi	%f0, %g31, 528
	setL %g3, l.36991
	fldi	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.43780
	addi	%g3, %g0, 0
	jmp	fjge_cont.43781
fjge_else.43780:
	setL %g3, l.37726
	fldi	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.43782
	addi	%g3, %g0, 0
	jmp	fjge_cont.43783
fjge_else.43782:
	addi	%g3, %g0, 1
fjge_cont.43783:
fjge_cont.43781:
	jne	%g3, %g0, jeq_else.43784
	jmp	jeq_cont.43785
jeq_else.43784:
	ldi	%g3, %g31, 544
	slli	%g4, %g3, 2
	ldi	%g3, %g31, 524
	add	%g3, %g4, %g3
	ldi	%g4, %g23, 0
	jne	%g3, %g4, jeq_else.43786
	addi	%g12, %g0, 0
	ldi	%g13, %g31, 516
	subi	%g1, %g1, 4
	call	shadow_check_one_or_matrix.2860
	addi	%g1, %g1, 4
	jne	%g3, %g0, jeq_else.43788
	ldi	%g3, %g24, 0
	fldi	%f0, %g31, 556
	fldi	%f2, %g3, 0
	fmul	%f1, %f0, %f2
	fldi	%f0, %g31, 552
	fldi	%f4, %g3, -4
	fmul	%f0, %f0, %f4
	fadd	%f1, %f1, %f0
	fldi	%f0, %g31, 548
	fldi	%f3, %g3, -8
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g23, -8
	fmul	%f5, %f0, %f11
	fmul	%f1, %f5, %f1
	fldi	%f5, %g22, 0
	fmul	%f5, %f5, %f2
	fldi	%f2, %g22, -4
	fmul	%f2, %f2, %f4
	fadd	%f4, %f5, %f2
	fldi	%f2, %g22, -8
	fmul	%f2, %f2, %f3
	fadd	%f2, %f4, %f2
	fmul	%f0, %f0, %f2
	fjlt	%f16, %f1, fjge_else.43790
	jmp	fjge_cont.43791
fjge_else.43790:
	fldi	%f3, %g31, 592
	fldi	%f2, %g31, 568
	fmul	%f2, %f1, %f2
	fadd	%f2, %f3, %f2
	fsti	%f2, %g31, 592
	fldi	%f3, %g31, 588
	fldi	%f2, %g31, 564
	fmul	%f2, %f1, %f2
	fadd	%f2, %f3, %f2
	fsti	%f2, %g31, 588
	fldi	%f3, %g31, 584
	fldi	%f2, %g31, 560
	fmul	%f1, %f1, %f2
	fadd	%f1, %f3, %f1
	fsti	%f1, %g31, 584
fjge_cont.43791:
	fjlt	%f16, %f0, fjge_else.43792
	jmp	fjge_cont.43793
fjge_else.43792:
	fmul	%f0, %f0, %f0
	fmul	%f0, %f0, %f0
	fmul	%f0, %f0, %f10
	fldi	%f1, %g31, 592
	fadd	%f1, %f1, %f0
	fsti	%f1, %g31, 592
	fldi	%f1, %g31, 588
	fadd	%f1, %f1, %f0
	fsti	%f1, %g31, 588
	fldi	%f1, %g31, 584
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 584
fjge_cont.43793:
	jmp	jeq_cont.43789
jeq_else.43788:
jeq_cont.43789:
	jmp	jeq_cont.43787
jeq_else.43786:
jeq_cont.43787:
jeq_cont.43785:
	subi	%g21, %g21, 1
	jmp	trace_reflections.2907
jge_else.43779:
	return

!==============================
! args = [%g25, %g22, %g24, %g20, %g19, %g18, %g17, %g23, %g21, %g16]
! fargs = [%f13, %f14]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
trace_ray.2912:
	addi	%g3, %g0, 4
	jlt	%g3, %g25, jle_else.43795
	setL %g3, l.35829
	fldi	%f0, %g3, 0
	fsti	%f0, %g31, 528
	addi	%g14, %g0, 0
	ldi	%g15, %g31, 516
	mov	%g9, %g22
	subi	%g1, %g1, 4
	call	trace_or_matrix.2871
	addi	%g1, %g1, 4
	fldi	%f0, %g31, 528
	setL %g3, l.36991
	fldi	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.43796
	addi	%g3, %g0, 0
	jmp	fjge_cont.43797
fjge_else.43796:
	setL %g3, l.37726
	fldi	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.43798
	addi	%g3, %g0, 0
	jmp	fjge_cont.43799
fjge_else.43798:
	addi	%g3, %g0, 1
fjge_cont.43799:
fjge_cont.43797:
	jne	%g3, %g0, jeq_else.43800
	addi	%g4, %g0, -1
	slli	%g3, %g25, 2
	st	%g4, %g19, %g3
	jne	%g25, %g0, jeq_else.43801
	return
jeq_else.43801:
	fldi	%f1, %g22, 0
	fldi	%f0, %g31, 308
	fmul	%f2, %f1, %f0
	fldi	%f1, %g22, -4
	fldi	%f0, %g31, 304
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g22, -8
	fldi	%f0, %g31, 300
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fneg	%f0, %f0
	fjlt	%f16, %f0, fjge_else.43803
	return
fjge_else.43803:
	fmul	%f1, %f0, %f0
	fmul	%f0, %f1, %f0
	fmul	%f1, %f0, %f13
	fldi	%f0, %g31, 312
	fmul	%f0, %f1, %f0
	fldi	%f1, %g31, 592
	fadd	%f1, %f1, %f0
	fsti	%f1, %g31, 592
	fldi	%f1, %g31, 588
	fadd	%f1, %f1, %f0
	fsti	%f1, %g31, 588
	fldi	%f1, %g31, 584
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 584
	return
jeq_else.43800:
	ldi	%g7, %g31, 544
	slli	%g3, %g7, 2
	add	%g3, %g31, %g3
	ldi	%g3, %g3, 272
	ldi	%g30, %g3, -8
	ldi	%g26, %g3, -28
	fldi	%f0, %g26, 0
	fmul	%f11, %f0, %f13
	ldi	%g4, %g3, -4
	jne	%g4, %g28, jeq_else.43806
	ldi	%g4, %g31, 524
	fsti	%f16, %g31, 556
	fsti	%f16, %g31, 552
	fsti	%f16, %g31, 548
	subi	%g5, %g4, 1
	slli	%g4, %g5, 2
	fld	%f1, %g22, %g4
	fjeq	%f1, %f16, fjne_else.43808
	fjlt	%f16, %f1, fjge_else.43810
	setL %g4, l.36354
	fldi	%f0, %g4, 0
	jmp	fjge_cont.43811
fjge_else.43810:
	setL %g4, l.35959
	fldi	%f0, %g4, 0
fjge_cont.43811:
	jmp	fjne_cont.43809
fjne_else.43808:
	fmov	%f0, %f16
fjne_cont.43809:
	fneg	%f0, %f0
	slli	%g4, %g5, 2
	add	%g4, %g31, %g4
	fsti	%f0, %g4, 556
	jmp	jeq_cont.43807
jeq_else.43806:
	addi	%g5, %g0, 2
	jne	%g4, %g5, jeq_else.43812
	ldi	%g4, %g3, -16
	fldi	%f0, %g4, 0
	fneg	%f0, %f0
	fsti	%f0, %g31, 556
	fldi	%f0, %g4, -4
	fneg	%f0, %f0
	fsti	%f0, %g31, 552
	fldi	%f0, %g4, -8
	fneg	%f0, %f0
	fsti	%f0, %g31, 548
	jmp	jeq_cont.43813
jeq_else.43812:
	fldi	%f1, %g31, 540
	ldi	%g4, %g3, -20
	fldi	%f0, %g4, 0
	fsub	%f4, %f1, %f0
	fldi	%f1, %g31, 536
	fldi	%f0, %g4, -4
	fsub	%f3, %f1, %f0
	fldi	%f1, %g31, 532
	fldi	%f0, %g4, -8
	fsub	%f0, %f1, %f0
	ldi	%g4, %g3, -16
	fldi	%f1, %g4, 0
	fmul	%f1, %f4, %f1
	fldi	%f2, %g4, -4
	fmul	%f5, %f3, %f2
	fldi	%f2, %g4, -8
	fmul	%f7, %f0, %f2
	ldi	%g4, %g3, -12
	jne	%g4, %g0, jeq_else.43814
	fsti	%f1, %g31, 556
	fsti	%f5, %g31, 552
	fsti	%f7, %g31, 548
	jmp	jeq_cont.43815
jeq_else.43814:
	ldi	%g4, %g3, -36
	fldi	%f2, %g4, -8
	fmul	%f6, %f3, %f2
	fldi	%f2, %g4, -4
	fmul	%f2, %f0, %f2
	fadd	%f2, %f6, %f2
	fmul	%f2, %f2, %f21
	fadd	%f1, %f1, %f2
	fsti	%f1, %g31, 556
	fldi	%f1, %g4, -8
	fmul	%f2, %f4, %f1
	fldi	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	fmul	%f0, %f0, %f21
	fadd	%f0, %f5, %f0
	fsti	%f0, %g31, 552
	fldi	%f0, %g4, -4
	fmul	%f1, %f4, %f0
	fldi	%f0, %g4, 0
	fmul	%f0, %f3, %f0
	fadd	%f0, %f1, %f0
	fmul	%f0, %f0, %f21
	fadd	%f0, %f7, %f0
	fsti	%f0, %g31, 548
jeq_cont.43815:
	ldi	%g4, %g3, -24
	fldi	%f2, %g31, 556
	fmul	%f1, %f2, %f2
	fldi	%f0, %g31, 552
	fmul	%f0, %f0, %f0
	fadd	%f1, %f1, %f0
	fldi	%f0, %g31, 548
	fmul	%f0, %f0, %f0
	fadd	%f0, %f1, %f0
	fsqrt	%f1, %f0
	fjeq	%f1, %f16, fjne_else.43816
	jne	%g4, %g0, jeq_else.43818
	fdiv	%f0, %f17, %f1
	jmp	jeq_cont.43819
jeq_else.43818:
	fdiv	%f0, %f20, %f1
jeq_cont.43819:
	jmp	fjne_cont.43817
fjne_else.43816:
	setL %g4, l.35959
	fldi	%f0, %g4, 0
fjne_cont.43817:
	fmul	%f1, %f2, %f0
	fsti	%f1, %g31, 556
	fldi	%f1, %g31, 552
	fmul	%f1, %f1, %f0
	fsti	%f1, %g31, 552
	fldi	%f1, %g31, 548
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 548
jeq_cont.43813:
jeq_cont.43807:
	fldi	%f0, %g31, 540
	fsti	%f0, %g31, 624
	fldi	%f0, %g31, 536
	fsti	%f0, %g31, 620
	fldi	%f0, %g31, 532
	fsti	%f0, %g31, 616
	ldi	%g4, %g3, 0
	ldi	%g5, %g3, -32
	fldi	%f0, %g5, 0
	fsti	%f0, %g31, 568
	fldi	%f0, %g5, -4
	fsti	%f0, %g31, 564
	fldi	%f0, %g5, -8
	fsti	%f0, %g31, 560
	jne	%g4, %g28, jeq_else.43820
	fldi	%f1, %g31, 540
	ldi	%g5, %g3, -20
	fldi	%f0, %g5, 0
	fsub	%f5, %f1, %f0
	setL %g3, l.38031
	fldi	%f9, %g3, 0
	fmul	%f0, %f5, %f9
	subi	%g1, %g1, 4
	call	min_caml_floor
	setL %g3, l.38033
	fldi	%f6, %g3, 0
	fmul	%f0, %f0, %f6
	fsub	%f8, %f5, %f0
	setL %g3, l.37992
	fldi	%f5, %g3, 0
	fldi	%f1, %g31, 532
	fldi	%f0, %g5, -8
	fsub	%f7, %f1, %f0
	fmul	%f0, %f7, %f9
	call	min_caml_floor
	addi	%g1, %g1, 4
	fmul	%f0, %f0, %f6
	fsub	%f1, %f7, %f0
	fjlt	%f8, %f5, fjge_else.43822
	fjlt	%f1, %f5, fjge_else.43824
	setL %g3, l.35825
	fldi	%f0, %g3, 0
	jmp	fjge_cont.43825
fjge_else.43824:
	setL %g3, l.35811
	fldi	%f0, %g3, 0
fjge_cont.43825:
	jmp	fjge_cont.43823
fjge_else.43822:
	fjlt	%f1, %f5, fjge_else.43826
	setL %g3, l.35811
	fldi	%f0, %g3, 0
	jmp	fjge_cont.43827
fjge_else.43826:
	setL %g3, l.35825
	fldi	%f0, %g3, 0
fjge_cont.43827:
fjge_cont.43823:
	fsti	%f0, %g31, 564
	jmp	jeq_cont.43821
jeq_else.43820:
	addi	%g5, %g0, 2
	jne	%g4, %g5, jeq_else.43828
	fldi	%f1, %g31, 536
	setL %g3, l.38011
	fldi	%f0, %g3, 0
	fmul	%f2, %f1, %f0
	setL %g3, l.35801
	fldi	%f3, %g3, 0
	setL %g3, l.35803
	fldi	%f4, %g3, 0
	fjlt	%f2, %f16, fjge_else.43830
	fmov	%f1, %f2
	jmp	fjge_cont.43831
fjge_else.43830:
	fneg	%f1, %f2
fjge_cont.43831:
	fjlt	%f29, %f1, fjge_else.43832
	fjlt	%f1, %f16, fjge_else.43834
	fmov	%f0, %f1
	jmp	fjge_cont.43835
fjge_else.43834:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43836
	fjlt	%f1, %f16, fjge_else.43838
	fmov	%f0, %f1
	jmp	fjge_cont.43839
fjge_else.43838:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43840
	fjlt	%f1, %f16, fjge_else.43842
	fmov	%f0, %f1
	jmp	fjge_cont.43843
fjge_else.43842:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2518
	addi	%g1, %g1, 4
fjge_cont.43843:
	jmp	fjge_cont.43841
fjge_else.43840:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2518
	addi	%g1, %g1, 4
fjge_cont.43841:
fjge_cont.43839:
	jmp	fjge_cont.43837
fjge_else.43836:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43844
	fjlt	%f1, %f16, fjge_else.43846
	fmov	%f0, %f1
	jmp	fjge_cont.43847
fjge_else.43846:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2518
	addi	%g1, %g1, 4
fjge_cont.43847:
	jmp	fjge_cont.43845
fjge_else.43844:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2518
	addi	%g1, %g1, 4
fjge_cont.43845:
fjge_cont.43837:
fjge_cont.43835:
	jmp	fjge_cont.43833
fjge_else.43832:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43848
	fjlt	%f1, %f16, fjge_else.43850
	fmov	%f0, %f1
	jmp	fjge_cont.43851
fjge_else.43850:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43852
	fjlt	%f1, %f16, fjge_else.43854
	fmov	%f0, %f1
	jmp	fjge_cont.43855
fjge_else.43854:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2518
	addi	%g1, %g1, 4
fjge_cont.43855:
	jmp	fjge_cont.43853
fjge_else.43852:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2518
	addi	%g1, %g1, 4
fjge_cont.43853:
fjge_cont.43851:
	jmp	fjge_cont.43849
fjge_else.43848:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43856
	fjlt	%f1, %f16, fjge_else.43858
	fmov	%f0, %f1
	jmp	fjge_cont.43859
fjge_else.43858:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2518
	addi	%g1, %g1, 4
fjge_cont.43859:
	jmp	fjge_cont.43857
fjge_else.43856:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2518
	addi	%g1, %g1, 4
fjge_cont.43857:
fjge_cont.43849:
fjge_cont.43833:
	fjlt	%f3, %f0, fjge_else.43860
	fjlt	%f16, %f2, fjge_else.43862
	addi	%g3, %g0, 0
	jmp	fjge_cont.43863
fjge_else.43862:
	addi	%g3, %g0, 1
fjge_cont.43863:
	jmp	fjge_cont.43861
fjge_else.43860:
	fjlt	%f16, %f2, fjge_else.43864
	addi	%g3, %g0, 1
	jmp	fjge_cont.43865
fjge_else.43864:
	addi	%g3, %g0, 0
fjge_cont.43865:
fjge_cont.43861:
	fjlt	%f3, %f0, fjge_else.43866
	fmov	%f1, %f0
	jmp	fjge_cont.43867
fjge_else.43866:
	fsub	%f1, %f29, %f0
fjge_cont.43867:
	fjlt	%f22, %f1, fjge_else.43868
	fmov	%f0, %f1
	jmp	fjge_cont.43869
fjge_else.43868:
	fsub	%f0, %f3, %f1
fjge_cont.43869:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f4, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g3, %g0, jeq_else.43870
	fneg	%f1, %f0
	jmp	jeq_cont.43871
jeq_else.43870:
	fmov	%f1, %f0
jeq_cont.43871:
	fmul	%f0, %f1, %f1
	fmul	%f1, %f27, %f0
	fsti	%f1, %g31, 568
	fsub	%f0, %f17, %f0
	fmul	%f0, %f27, %f0
	fsti	%f0, %g31, 564
	jmp	jeq_cont.43829
jeq_else.43828:
	addi	%g5, %g0, 3
	jne	%g4, %g5, jeq_else.43872
	fldi	%f1, %g31, 540
	ldi	%g3, %g3, -20
	fldi	%f0, %g3, 0
	fsub	%f0, %f1, %f0
	fldi	%f2, %g31, 532
	fldi	%f1, %g3, -8
	fsub	%f1, %f2, %f1
	fmul	%f0, %f0, %f0
	fmul	%f1, %f1, %f1
	fadd	%f0, %f0, %f1
	fsqrt	%f0, %f0
	setL %g3, l.37992
	fldi	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	fsti	%f0, %g1, 0
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	fmov	%f1, %f0
	fldi	%f0, %g1, 0
	fsub	%f0, %f0, %f1
	fmul	%f0, %f0, %f30
	fsub	%f2, %f22, %f0
	setL %g3, l.35801
	fldi	%f3, %g3, 0
	setL %g3, l.35803
	fldi	%f4, %g3, 0
	fjlt	%f2, %f16, fjge_else.43874
	fmov	%f1, %f2
	jmp	fjge_cont.43875
fjge_else.43874:
	fneg	%f1, %f2
fjge_cont.43875:
	fjlt	%f29, %f1, fjge_else.43876
	fjlt	%f1, %f16, fjge_else.43878
	fmov	%f0, %f1
	jmp	fjge_cont.43879
fjge_else.43878:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43880
	fjlt	%f1, %f16, fjge_else.43882
	fmov	%f0, %f1
	jmp	fjge_cont.43883
fjge_else.43882:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43884
	fjlt	%f1, %f16, fjge_else.43886
	fmov	%f0, %f1
	jmp	fjge_cont.43887
fjge_else.43886:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2518
	addi	%g1, %g1, 8
fjge_cont.43887:
	jmp	fjge_cont.43885
fjge_else.43884:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2518
	addi	%g1, %g1, 8
fjge_cont.43885:
fjge_cont.43883:
	jmp	fjge_cont.43881
fjge_else.43880:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43888
	fjlt	%f1, %f16, fjge_else.43890
	fmov	%f0, %f1
	jmp	fjge_cont.43891
fjge_else.43890:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2518
	addi	%g1, %g1, 8
fjge_cont.43891:
	jmp	fjge_cont.43889
fjge_else.43888:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2518
	addi	%g1, %g1, 8
fjge_cont.43889:
fjge_cont.43881:
fjge_cont.43879:
	jmp	fjge_cont.43877
fjge_else.43876:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43892
	fjlt	%f1, %f16, fjge_else.43894
	fmov	%f0, %f1
	jmp	fjge_cont.43895
fjge_else.43894:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43896
	fjlt	%f1, %f16, fjge_else.43898
	fmov	%f0, %f1
	jmp	fjge_cont.43899
fjge_else.43898:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2518
	addi	%g1, %g1, 8
fjge_cont.43899:
	jmp	fjge_cont.43897
fjge_else.43896:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2518
	addi	%g1, %g1, 8
fjge_cont.43897:
fjge_cont.43895:
	jmp	fjge_cont.43893
fjge_else.43892:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.43900
	fjlt	%f1, %f16, fjge_else.43902
	fmov	%f0, %f1
	jmp	fjge_cont.43903
fjge_else.43902:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2518
	addi	%g1, %g1, 8
fjge_cont.43903:
	jmp	fjge_cont.43901
fjge_else.43900:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2518
	addi	%g1, %g1, 8
fjge_cont.43901:
fjge_cont.43893:
fjge_cont.43877:
	fjlt	%f3, %f0, fjge_else.43904
	fjlt	%f16, %f2, fjge_else.43906
	addi	%g3, %g0, 0
	jmp	fjge_cont.43907
fjge_else.43906:
	addi	%g3, %g0, 1
fjge_cont.43907:
	jmp	fjge_cont.43905
fjge_else.43904:
	fjlt	%f16, %f2, fjge_else.43908
	addi	%g3, %g0, 1
	jmp	fjge_cont.43909
fjge_else.43908:
	addi	%g3, %g0, 0
fjge_cont.43909:
fjge_cont.43905:
	fjlt	%f3, %f0, fjge_else.43910
	fmov	%f1, %f0
	jmp	fjge_cont.43911
fjge_else.43910:
	fsub	%f1, %f29, %f0
fjge_cont.43911:
	fjlt	%f22, %f1, fjge_else.43912
	fmov	%f0, %f1
	jmp	fjge_cont.43913
fjge_else.43912:
	fsub	%f0, %f3, %f1
fjge_cont.43913:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f4, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g3, %g0, jeq_else.43914
	fneg	%f1, %f0
	jmp	jeq_cont.43915
jeq_else.43914:
	fmov	%f1, %f0
jeq_cont.43915:
	fmul	%f0, %f1, %f1
	fmul	%f1, %f0, %f27
	fsti	%f1, %g31, 564
	fsub	%f0, %f17, %f0
	fmul	%f0, %f0, %f27
	fsti	%f0, %g31, 560
	jmp	jeq_cont.43873
jeq_else.43872:
	addi	%g5, %g0, 4
	jne	%g4, %g5, jeq_else.43916
	fldi	%f1, %g31, 540
	ldi	%g6, %g3, -20
	fldi	%f0, %g6, 0
	fsub	%f1, %f1, %f0
	ldi	%g5, %g3, -16
	fldi	%f0, %g5, 0
	fsqrt	%f0, %f0
	fmul	%f1, %f1, %f0
	fldi	%f2, %g31, 532
	fldi	%f0, %g6, -8
	fsub	%f2, %f2, %f0
	fldi	%f0, %g5, -8
	fsqrt	%f0, %f0
	fmul	%f2, %f2, %f0
	fmul	%f3, %f1, %f1
	fmul	%f0, %f2, %f2
	fadd	%f5, %f3, %f0
	fjlt	%f1, %f16, fjge_else.43918
	fmov	%f0, %f1
	jmp	fjge_cont.43919
fjge_else.43918:
	fneg	%f0, %f1
fjge_cont.43919:
	setL %g3, l.37896
	fldi	%f6, %g3, 0
	fjlt	%f0, %f6, fjge_else.43920
	fdiv	%f1, %f2, %f1
	fjlt	%f1, %f16, fjge_else.43922
	fmov	%f0, %f1
	jmp	fjge_cont.43923
fjge_else.43922:
	fneg	%f0, %f1
fjge_cont.43923:
	fjlt	%f17, %f0, fjge_else.43924
	fjlt	%f0, %f20, fjge_else.43926
	addi	%g3, %g0, 0
	jmp	fjge_cont.43927
fjge_else.43926:
	addi	%g3, %g0, -1
fjge_cont.43927:
	jmp	fjge_cont.43925
fjge_else.43924:
	addi	%g3, %g0, 1
fjge_cont.43925:
	jne	%g3, %g0, jeq_else.43928
	fmov	%f3, %f0
	jmp	jeq_cont.43929
jeq_else.43928:
	fdiv	%f3, %f17, %f0
jeq_cont.43929:
	fmul	%f0, %f3, %f3
	setL %g4, l.37902
	fldi	%f1, %g4, 0
	fmul	%f2, %f1, %f0
	setL %g4, l.37904
	fldi	%f1, %g4, 0
	fdiv	%f2, %f2, %f1
	setL %g4, l.37906
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	setL %g4, l.37908
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.37910
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	setL %g4, l.37912
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.37914
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	setL %g4, l.37916
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.37918
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	fadd	%f1, %f28, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.37921
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	setL %g4, l.37923
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.37925
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	setL %g4, l.37927
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f4, %f1
	setL %g4, l.37929
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	fadd	%f1, %f25, %f2
	fdiv	%f1, %f4, %f1
	fmul	%f2, %f25, %f0
	fadd	%f1, %f26, %f1
	fdiv	%f2, %f2, %f1
	setL %g4, l.37933
	fldi	%f1, %g4, 0
	fmul	%f4, %f1, %f0
	fadd	%f1, %f24, %f2
	fdiv	%f1, %f4, %f1
	fadd	%f1, %f23, %f1
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f3, %f0
	jlt	%g0, %g3, jle_else.43930
	jlt	%g3, %g0, jge_else.43932
	fmov	%f0, %f1
	jmp	jge_cont.43933
jge_else.43932:
	fsub	%f0, %f31, %f1
jge_cont.43933:
	jmp	jle_cont.43931
jle_else.43930:
	fsub	%f0, %f22, %f1
jle_cont.43931:
	setL %g3, l.37940
	fldi	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fdiv	%f0, %f0, %f30
	jmp	fjge_cont.43921
fjge_else.43920:
	setL %g3, l.37898
	fldi	%f0, %g3, 0
fjge_cont.43921:
	fsti	%f0, %g1, 4
	subi	%g1, %g1, 12
	call	min_caml_floor
	addi	%g1, %g1, 12
	fmov	%f1, %f0
	fldi	%f0, %g1, 4
	fsub	%f7, %f0, %f1
	fldi	%f1, %g31, 536
	fldi	%f0, %g6, -4
	fsub	%f1, %f1, %f0
	fldi	%f0, %g5, -4
	fsqrt	%f0, %f0
	fmul	%f1, %f1, %f0
	fjlt	%f5, %f16, fjge_else.43934
	fmov	%f0, %f5
	jmp	fjge_cont.43935
fjge_else.43934:
	fneg	%f0, %f5
fjge_cont.43935:
	fjlt	%f0, %f6, fjge_else.43936
	fdiv	%f1, %f1, %f5
	fjlt	%f1, %f16, fjge_else.43938
	fmov	%f0, %f1
	jmp	fjge_cont.43939
fjge_else.43938:
	fneg	%f0, %f1
fjge_cont.43939:
	fjlt	%f17, %f0, fjge_else.43940
	fjlt	%f0, %f20, fjge_else.43942
	addi	%g3, %g0, 0
	jmp	fjge_cont.43943
fjge_else.43942:
	addi	%g3, %g0, -1
fjge_cont.43943:
	jmp	fjge_cont.43941
fjge_else.43940:
	addi	%g3, %g0, 1
fjge_cont.43941:
	jne	%g3, %g0, jeq_else.43944
	fmov	%f4, %f0
	jmp	jeq_cont.43945
jeq_else.43944:
	fdiv	%f4, %f17, %f0
jeq_cont.43945:
	fmul	%f0, %f4, %f4
	setL %g4, l.37902
	fldi	%f1, %g4, 0
	fmul	%f2, %f1, %f0
	setL %g4, l.37904
	fldi	%f1, %g4, 0
	fdiv	%f2, %f2, %f1
	setL %g4, l.37906
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37908
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37910
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37912
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37914
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37916
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37918
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f28, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37921
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37923
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37925
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37927
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37929
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f25, %f2
	fdiv	%f1, %f3, %f1
	fmul	%f2, %f25, %f0
	fadd	%f1, %f26, %f1
	fdiv	%f2, %f2, %f1
	setL %g4, l.37933
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f24, %f2
	fdiv	%f1, %f3, %f1
	fadd	%f1, %f23, %f1
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f4, %f0
	jlt	%g0, %g3, jle_else.43946
	jlt	%g3, %g0, jge_else.43948
	fmov	%f1, %f0
	jmp	jge_cont.43949
jge_else.43948:
	fsub	%f1, %f31, %f0
jge_cont.43949:
	jmp	jle_cont.43947
jle_else.43946:
	fsub	%f1, %f22, %f0
jle_cont.43947:
	setL %g3, l.37940
	fldi	%f0, %g3, 0
	fmul	%f0, %f1, %f0
	fdiv	%f0, %f0, %f30
	jmp	fjge_cont.43937
fjge_else.43936:
	setL %g3, l.37898
	fldi	%f0, %g3, 0
fjge_cont.43937:
	fsti	%f0, %g1, 8
	subi	%g1, %g1, 16
	call	min_caml_floor
	addi	%g1, %g1, 16
	fmov	%f1, %f0
	fldi	%f0, %g1, 8
	fsub	%f0, %f0, %f1
	setL %g3, l.37977
	fldi	%f2, %g3, 0
	fsub	%f1, %f21, %f7
	fmul	%f1, %f1, %f1
	fsub	%f1, %f2, %f1
	fsub	%f0, %f21, %f0
	fmul	%f0, %f0, %f0
	fsub	%f1, %f1, %f0
	fjlt	%f1, %f16, fjge_else.43950
	fmov	%f0, %f1
	jmp	fjge_cont.43951
fjge_else.43950:
	fmov	%f0, %f16
fjge_cont.43951:
	fmul	%f1, %f27, %f0
	setL %g3, l.37981
	fldi	%f0, %g3, 0
	fdiv	%f0, %f1, %f0
	fsti	%f0, %g31, 560
	jmp	jeq_cont.43917
jeq_else.43916:
jeq_cont.43917:
jeq_cont.43873:
jeq_cont.43829:
jeq_cont.43821:
	slli	%g4, %g7, 2
	ldi	%g3, %g31, 524
	add	%g4, %g4, %g3
	slli	%g3, %g25, 2
	st	%g4, %g19, %g3
	slli	%g3, %g25, 2
	ld	%g3, %g20, %g3
	fldi	%f0, %g31, 540
	fsti	%f0, %g3, 0
	fldi	%f0, %g31, 536
	fsti	%f0, %g3, -4
	fldi	%f0, %g31, 532
	fsti	%f0, %g3, -8
	fldi	%f0, %g26, 0
	fjlt	%f0, %f21, fjge_else.43952
	addi	%g4, %g0, 1
	slli	%g3, %g25, 2
	st	%g4, %g18, %g3
	slli	%g3, %g25, 2
	ld	%g3, %g17, %g3
	fldi	%f0, %g31, 568
	fsti	%f0, %g3, 0
	fldi	%f0, %g31, 564
	fsti	%f0, %g3, -4
	fldi	%f0, %g31, 560
	fsti	%f0, %g3, -8
	slli	%g3, %g25, 2
	ld	%g4, %g17, %g3
	setL %g3, l.38077
	fldi	%f0, %g3, 0
	fmul	%f0, %f0, %f11
	fldi	%f1, %g4, 0
	fmul	%f1, %f1, %f0
	fsti	%f1, %g4, 0
	fldi	%f1, %g4, -4
	fmul	%f1, %f1, %f0
	fsti	%f1, %g4, -4
	fldi	%f1, %g4, -8
	fmul	%f0, %f1, %f0
	fsti	%f0, %g4, -8
	slli	%g3, %g25, 2
	ld	%g3, %g16, %g3
	fldi	%f0, %g31, 556
	fsti	%f0, %g3, 0
	fldi	%f0, %g31, 552
	fsti	%f0, %g3, -4
	fldi	%f0, %g31, 548
	fsti	%f0, %g3, -8
	jmp	fjge_cont.43953
fjge_else.43952:
	addi	%g4, %g0, 0
	slli	%g3, %g25, 2
	st	%g4, %g18, %g3
fjge_cont.43953:
	setL %g3, l.38099
	fldi	%f3, %g3, 0
	fldi	%f1, %g22, 0
	fldi	%f0, %g31, 556
	fmul	%f5, %f1, %f0
	fldi	%f4, %g22, -4
	fldi	%f2, %g31, 552
	fmul	%f2, %f4, %f2
	fadd	%f5, %f5, %f2
	fldi	%f4, %g22, -8
	fldi	%f2, %g31, 548
	fmul	%f2, %f4, %f2
	fadd	%f2, %f5, %f2
	fmul	%f2, %f3, %f2
	fmul	%f0, %f2, %f0
	fadd	%f0, %f1, %f0
	fsti	%f0, %g22, 0
	fldi	%f1, %g22, -4
	fldi	%f0, %g31, 552
	fmul	%f0, %f2, %f0
	fadd	%f0, %f1, %f0
	fsti	%f0, %g22, -4
	fldi	%f1, %g22, -8
	fldi	%f0, %g31, 548
	fmul	%f0, %f2, %f0
	fadd	%f0, %f1, %f0
	fsti	%f0, %g22, -8
	fldi	%f0, %g26, -4
	fmul	%f10, %f13, %f0
	addi	%g12, %g0, 0
	ldi	%g13, %g31, 516
	subi	%g1, %g1, 16
	call	shadow_check_one_or_matrix.2860
	addi	%g1, %g1, 16
	jne	%g3, %g0, jeq_else.43954
	fldi	%f1, %g31, 556
	fldi	%f0, %g31, 308
	fmul	%f2, %f1, %f0
	fldi	%f1, %g31, 552
	fldi	%f3, %g31, 304
	fmul	%f1, %f1, %f3
	fadd	%f4, %f2, %f1
	fldi	%f1, %g31, 548
	fldi	%f2, %g31, 300
	fmul	%f1, %f1, %f2
	fadd	%f1, %f4, %f1
	fneg	%f1, %f1
	fmul	%f1, %f1, %f11
	fldi	%f4, %g22, 0
	fmul	%f4, %f4, %f0
	fldi	%f0, %g22, -4
	fmul	%f0, %f0, %f3
	fadd	%f3, %f4, %f0
	fldi	%f0, %g22, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f3, %f0
	fneg	%f0, %f0
	fjlt	%f16, %f1, fjge_else.43956
	jmp	fjge_cont.43957
fjge_else.43956:
	fldi	%f3, %g31, 592
	fldi	%f2, %g31, 568
	fmul	%f2, %f1, %f2
	fadd	%f2, %f3, %f2
	fsti	%f2, %g31, 592
	fldi	%f3, %g31, 588
	fldi	%f2, %g31, 564
	fmul	%f2, %f1, %f2
	fadd	%f2, %f3, %f2
	fsti	%f2, %g31, 588
	fldi	%f3, %g31, 584
	fldi	%f2, %g31, 560
	fmul	%f1, %f1, %f2
	fadd	%f1, %f3, %f1
	fsti	%f1, %g31, 584
fjge_cont.43957:
	fjlt	%f16, %f0, fjge_else.43958
	jmp	fjge_cont.43959
fjge_else.43958:
	fmul	%f0, %f0, %f0
	fmul	%f0, %f0, %f0
	fmul	%f0, %f0, %f10
	fldi	%f1, %g31, 592
	fadd	%f1, %f1, %f0
	fsti	%f1, %g31, 592
	fldi	%f1, %g31, 588
	fadd	%f1, %f1, %f0
	fsti	%f1, %g31, 588
	fldi	%f1, %g31, 584
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 584
fjge_cont.43959:
	jmp	jeq_cont.43955
jeq_else.43954:
jeq_cont.43955:
	fldi	%f0, %g31, 540
	fsti	%f0, %g31, 636
	fldi	%f0, %g31, 536
	fsti	%f0, %g31, 632
	fldi	%f0, %g31, 532
	fsti	%f0, %g31, 628
	ldi	%g3, %g31, 28
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.43960
	slli	%g4, %g3, 2
	add	%g4, %g31, %g4
	ldi	%g4, %g4, 272
	ldi	%g7, %g4, -40
	ldi	%g6, %g4, -4
	fldi	%f1, %g31, 540
	ldi	%g5, %g4, -20
	fldi	%f0, %g5, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, 0
	fldi	%f1, %g31, 536
	fldi	%f0, %g5, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -4
	fldi	%f1, %g31, 532
	fldi	%f0, %g5, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -8
	addi	%g5, %g0, 2
	jne	%g6, %g5, jeq_else.43962
	ldi	%g4, %g4, -16
	fldi	%f1, %g7, 0
	fldi	%f3, %g7, -4
	fldi	%f2, %g7, -8
	fldi	%f0, %g4, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g4, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g7, -12
	jmp	jeq_cont.43963
jeq_else.43962:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.43964
	jmp	jle_cont.43965
jle_else.43964:
	fldi	%f2, %g7, 0
	fldi	%f1, %g7, -4
	fldi	%f0, %g7, -8
	fmul	%f4, %f2, %f2
	ldi	%g5, %g4, -16
	fldi	%f3, %g5, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g5, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g5, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g5, %g4, -12
	jne	%g5, %g0, jeq_else.43966
	fmov	%f3, %f4
	jmp	jeq_cont.43967
jeq_else.43966:
	fmul	%f5, %f1, %f0
	ldi	%g4, %g4, -36
	fldi	%f3, %g4, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g4, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g4, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.43967:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.43968
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.43969
jeq_else.43968:
	fmov	%f0, %f3
jeq_cont.43969:
	fsti	%f0, %g7, -12
jle_cont.43965:
jeq_cont.43963:
	subi	%g4, %g3, 1
	subi	%g3, %g31, 540
	subi	%g1, %g1, 16
	call	setup_startp_constants.2823
	addi	%g1, %g1, 16
	jmp	jge_cont.43961
jge_else.43960:
jge_cont.43961:
	ldi	%g3, %g31, 1720
	subi	%g3, %g3, 1
	sti	%g22, %g1, 12
	sti	%g16, %g1, 16
	sti	%g21, %g1, 20
	sti	%g23, %g1, 24
	sti	%g17, %g1, 28
	sti	%g18, %g1, 32
	sti	%g19, %g1, 36
	sti	%g20, %g1, 40
	sti	%g24, %g1, 44
	sti	%g19, %g1, 48
	mov	%g21, %g3
	subi	%g1, %g1, 56
	call	trace_reflections.2907
	addi	%g1, %g1, 56
	setL %g3, l.36040
	fldi	%f0, %g3, 0
	fjlt	%f0, %f13, fjge_else.43970
	return
fjge_else.43970:
	addi	%g3, %g0, 4
	jlt	%g25, %g3, jle_else.43972
	jmp	jle_cont.43973
jle_else.43972:
	addi	%g3, %g25, 1
	addi	%g4, %g0, -1
	slli	%g3, %g3, 2
	ldi	%g19, %g1, 48
	st	%g4, %g19, %g3
jle_cont.43973:
	addi	%g3, %g0, 2
	jne	%g30, %g3, jeq_else.43974
	fldi	%f0, %g26, 0
	fsub	%f0, %f17, %f0
	fmul	%f13, %f13, %f0
	addi	%g25, %g25, 1
	fldi	%f0, %g31, 528
	fadd	%f14, %f14, %f0
	ldi	%g24, %g1, 44
	ldi	%g20, %g1, 40
	ldi	%g19, %g1, 36
	ldi	%g18, %g1, 32
	ldi	%g17, %g1, 28
	ldi	%g23, %g1, 24
	ldi	%g21, %g1, 20
	ldi	%g16, %g1, 16
	ldi	%g22, %g1, 12
	jmp	trace_ray.2912
jeq_else.43974:
	return
jle_else.43795:
	return

!==============================
! args = [%g21, %g3]
! fargs = [%f10]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
trace_diffuse_ray.2918:
	setL %g4, l.35829
	fldi	%f0, %g4, 0
	fsti	%f0, %g31, 528
	addi	%g19, %g0, 0
	ldi	%g20, %g31, 516
	mov	%g17, %g3
	mov	%g18, %g21
	subi	%g1, %g1, 4
	call	trace_or_matrix_fast.2885
	addi	%g1, %g1, 4
	fldi	%f0, %g31, 528
	setL %g3, l.36991
	fldi	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.43977
	addi	%g3, %g0, 0
	jmp	fjge_cont.43978
fjge_else.43977:
	setL %g3, l.37726
	fldi	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.43979
	addi	%g3, %g0, 0
	jmp	fjge_cont.43980
fjge_else.43979:
	addi	%g3, %g0, 1
fjge_cont.43980:
fjge_cont.43978:
	jne	%g3, %g0, jeq_else.43981
	return
jeq_else.43981:
	ldi	%g3, %g31, 544
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g14, %g3, 272
	ldi	%g3, %g14, -4
	jne	%g3, %g28, jeq_else.43983
	ldi	%g3, %g31, 524
	fsti	%f16, %g31, 556
	fsti	%f16, %g31, 552
	fsti	%f16, %g31, 548
	subi	%g4, %g3, 1
	slli	%g3, %g4, 2
	fld	%f1, %g21, %g3
	fjeq	%f1, %f16, fjne_else.43985
	fjlt	%f16, %f1, fjge_else.43987
	setL %g3, l.36354
	fldi	%f0, %g3, 0
	jmp	fjge_cont.43988
fjge_else.43987:
	setL %g3, l.35959
	fldi	%f0, %g3, 0
fjge_cont.43988:
	jmp	fjne_cont.43986
fjne_else.43985:
	fmov	%f0, %f16
fjne_cont.43986:
	fneg	%f0, %f0
	slli	%g3, %g4, 2
	add	%g3, %g31, %g3
	fsti	%f0, %g3, 556
	jmp	jeq_cont.43984
jeq_else.43983:
	addi	%g4, %g0, 2
	jne	%g3, %g4, jeq_else.43989
	ldi	%g3, %g14, -16
	fldi	%f0, %g3, 0
	fneg	%f0, %f0
	fsti	%f0, %g31, 556
	fldi	%f0, %g3, -4
	fneg	%f0, %f0
	fsti	%f0, %g31, 552
	fldi	%f0, %g3, -8
	fneg	%f0, %f0
	fsti	%f0, %g31, 548
	jmp	jeq_cont.43990
jeq_else.43989:
	fldi	%f1, %g31, 540
	ldi	%g3, %g14, -20
	fldi	%f0, %g3, 0
	fsub	%f4, %f1, %f0
	fldi	%f1, %g31, 536
	fldi	%f0, %g3, -4
	fsub	%f3, %f1, %f0
	fldi	%f1, %g31, 532
	fldi	%f0, %g3, -8
	fsub	%f0, %f1, %f0
	ldi	%g3, %g14, -16
	fldi	%f1, %g3, 0
	fmul	%f2, %f4, %f1
	fldi	%f1, %g3, -4
	fmul	%f6, %f3, %f1
	fldi	%f1, %g3, -8
	fmul	%f7, %f0, %f1
	ldi	%g3, %g14, -12
	jne	%g3, %g0, jeq_else.43991
	fsti	%f2, %g31, 556
	fsti	%f6, %g31, 552
	fsti	%f7, %g31, 548
	jmp	jeq_cont.43992
jeq_else.43991:
	ldi	%g3, %g14, -36
	fldi	%f1, %g3, -8
	fmul	%f5, %f3, %f1
	fldi	%f1, %g3, -4
	fmul	%f1, %f0, %f1
	fadd	%f1, %f5, %f1
	fmul	%f1, %f1, %f21
	fadd	%f1, %f2, %f1
	fsti	%f1, %g31, 556
	fldi	%f1, %g3, -8
	fmul	%f2, %f4, %f1
	fldi	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	fmul	%f0, %f0, %f21
	fadd	%f0, %f6, %f0
	fsti	%f0, %g31, 552
	fldi	%f0, %g3, -4
	fmul	%f1, %f4, %f0
	fldi	%f0, %g3, 0
	fmul	%f0, %f3, %f0
	fadd	%f0, %f1, %f0
	fmul	%f0, %f0, %f21
	fadd	%f0, %f7, %f0
	fsti	%f0, %g31, 548
jeq_cont.43992:
	ldi	%g3, %g14, -24
	fldi	%f2, %g31, 556
	fmul	%f1, %f2, %f2
	fldi	%f0, %g31, 552
	fmul	%f0, %f0, %f0
	fadd	%f1, %f1, %f0
	fldi	%f0, %g31, 548
	fmul	%f0, %f0, %f0
	fadd	%f0, %f1, %f0
	fsqrt	%f1, %f0
	fjeq	%f1, %f16, fjne_else.43993
	jne	%g3, %g0, jeq_else.43995
	fdiv	%f0, %f17, %f1
	jmp	jeq_cont.43996
jeq_else.43995:
	fdiv	%f0, %f20, %f1
jeq_cont.43996:
	jmp	fjne_cont.43994
fjne_else.43993:
	setL %g3, l.35959
	fldi	%f0, %g3, 0
fjne_cont.43994:
	fmul	%f1, %f2, %f0
	fsti	%f1, %g31, 556
	fldi	%f1, %g31, 552
	fmul	%f1, %f1, %f0
	fsti	%f1, %g31, 552
	fldi	%f1, %g31, 548
	fmul	%f0, %f1, %f0
	fsti	%f0, %g31, 548
jeq_cont.43990:
jeq_cont.43984:
	ldi	%g3, %g14, 0
	ldi	%g4, %g14, -32
	fldi	%f0, %g4, 0
	fsti	%f0, %g31, 568
	fldi	%f0, %g4, -4
	fsti	%f0, %g31, 564
	fldi	%f0, %g4, -8
	fsti	%f0, %g31, 560
	jne	%g3, %g28, jeq_else.43997
	fldi	%f1, %g31, 540
	ldi	%g5, %g14, -20
	fldi	%f0, %g5, 0
	fsub	%f5, %f1, %f0
	setL %g3, l.38031
	fldi	%f9, %g3, 0
	fmul	%f0, %f5, %f9
	subi	%g1, %g1, 4
	call	min_caml_floor
	setL %g3, l.38033
	fldi	%f8, %g3, 0
	fmul	%f0, %f0, %f8
	fsub	%f7, %f5, %f0
	setL %g3, l.37992
	fldi	%f6, %g3, 0
	fldi	%f1, %g31, 532
	fldi	%f0, %g5, -8
	fsub	%f5, %f1, %f0
	fmul	%f0, %f5, %f9
	call	min_caml_floor
	addi	%g1, %g1, 4
	fmul	%f0, %f0, %f8
	fsub	%f1, %f5, %f0
	fjlt	%f7, %f6, fjge_else.43999
	fjlt	%f1, %f6, fjge_else.44001
	setL %g3, l.35825
	fldi	%f0, %g3, 0
	jmp	fjge_cont.44002
fjge_else.44001:
	setL %g3, l.35811
	fldi	%f0, %g3, 0
fjge_cont.44002:
	jmp	fjge_cont.44000
fjge_else.43999:
	fjlt	%f1, %f6, fjge_else.44003
	setL %g3, l.35811
	fldi	%f0, %g3, 0
	jmp	fjge_cont.44004
fjge_else.44003:
	setL %g3, l.35825
	fldi	%f0, %g3, 0
fjge_cont.44004:
fjge_cont.44000:
	fsti	%f0, %g31, 564
	jmp	jeq_cont.43998
jeq_else.43997:
	addi	%g4, %g0, 2
	jne	%g3, %g4, jeq_else.44005
	fldi	%f1, %g31, 536
	setL %g3, l.38011
	fldi	%f0, %g3, 0
	fmul	%f2, %f1, %f0
	setL %g3, l.35801
	fldi	%f3, %g3, 0
	setL %g3, l.35803
	fldi	%f4, %g3, 0
	fjlt	%f2, %f16, fjge_else.44007
	fmov	%f1, %f2
	jmp	fjge_cont.44008
fjge_else.44007:
	fneg	%f1, %f2
fjge_cont.44008:
	fjlt	%f29, %f1, fjge_else.44009
	fjlt	%f1, %f16, fjge_else.44011
	fmov	%f0, %f1
	jmp	fjge_cont.44012
fjge_else.44011:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.44013
	fjlt	%f1, %f16, fjge_else.44015
	fmov	%f0, %f1
	jmp	fjge_cont.44016
fjge_else.44015:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.44017
	fjlt	%f1, %f16, fjge_else.44019
	fmov	%f0, %f1
	jmp	fjge_cont.44020
fjge_else.44019:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2518
	addi	%g1, %g1, 4
fjge_cont.44020:
	jmp	fjge_cont.44018
fjge_else.44017:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2518
	addi	%g1, %g1, 4
fjge_cont.44018:
fjge_cont.44016:
	jmp	fjge_cont.44014
fjge_else.44013:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.44021
	fjlt	%f1, %f16, fjge_else.44023
	fmov	%f0, %f1
	jmp	fjge_cont.44024
fjge_else.44023:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2518
	addi	%g1, %g1, 4
fjge_cont.44024:
	jmp	fjge_cont.44022
fjge_else.44021:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2518
	addi	%g1, %g1, 4
fjge_cont.44022:
fjge_cont.44014:
fjge_cont.44012:
	jmp	fjge_cont.44010
fjge_else.44009:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.44025
	fjlt	%f1, %f16, fjge_else.44027
	fmov	%f0, %f1
	jmp	fjge_cont.44028
fjge_else.44027:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.44029
	fjlt	%f1, %f16, fjge_else.44031
	fmov	%f0, %f1
	jmp	fjge_cont.44032
fjge_else.44031:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2518
	addi	%g1, %g1, 4
fjge_cont.44032:
	jmp	fjge_cont.44030
fjge_else.44029:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2518
	addi	%g1, %g1, 4
fjge_cont.44030:
fjge_cont.44028:
	jmp	fjge_cont.44026
fjge_else.44025:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.44033
	fjlt	%f1, %f16, fjge_else.44035
	fmov	%f0, %f1
	jmp	fjge_cont.44036
fjge_else.44035:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2518
	addi	%g1, %g1, 4
fjge_cont.44036:
	jmp	fjge_cont.44034
fjge_else.44033:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 4
	call	sin_sub.2518
	addi	%g1, %g1, 4
fjge_cont.44034:
fjge_cont.44026:
fjge_cont.44010:
	fjlt	%f3, %f0, fjge_else.44037
	fjlt	%f16, %f2, fjge_else.44039
	addi	%g3, %g0, 0
	jmp	fjge_cont.44040
fjge_else.44039:
	addi	%g3, %g0, 1
fjge_cont.44040:
	jmp	fjge_cont.44038
fjge_else.44037:
	fjlt	%f16, %f2, fjge_else.44041
	addi	%g3, %g0, 1
	jmp	fjge_cont.44042
fjge_else.44041:
	addi	%g3, %g0, 0
fjge_cont.44042:
fjge_cont.44038:
	fjlt	%f3, %f0, fjge_else.44043
	fmov	%f1, %f0
	jmp	fjge_cont.44044
fjge_else.44043:
	fsub	%f1, %f29, %f0
fjge_cont.44044:
	fjlt	%f22, %f1, fjge_else.44045
	fmov	%f0, %f1
	jmp	fjge_cont.44046
fjge_else.44045:
	fsub	%f0, %f3, %f1
fjge_cont.44046:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f4, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g3, %g0, jeq_else.44047
	fneg	%f1, %f0
	jmp	jeq_cont.44048
jeq_else.44047:
	fmov	%f1, %f0
jeq_cont.44048:
	fmul	%f0, %f1, %f1
	fmul	%f1, %f27, %f0
	fsti	%f1, %g31, 568
	fsub	%f0, %f17, %f0
	fmul	%f0, %f27, %f0
	fsti	%f0, %g31, 564
	jmp	jeq_cont.44006
jeq_else.44005:
	addi	%g4, %g0, 3
	jne	%g3, %g4, jeq_else.44049
	fldi	%f1, %g31, 540
	ldi	%g3, %g14, -20
	fldi	%f0, %g3, 0
	fsub	%f1, %f1, %f0
	fldi	%f2, %g31, 532
	fldi	%f0, %g3, -8
	fsub	%f0, %f2, %f0
	fmul	%f1, %f1, %f1
	fmul	%f0, %f0, %f0
	fadd	%f0, %f1, %f0
	fsqrt	%f0, %f0
	setL %g3, l.37992
	fldi	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	fsti	%f0, %g1, 0
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	fmov	%f1, %f0
	fldi	%f0, %g1, 0
	fsub	%f0, %f0, %f1
	fmul	%f0, %f0, %f30
	fsub	%f2, %f22, %f0
	setL %g3, l.35801
	fldi	%f3, %g3, 0
	setL %g3, l.35803
	fldi	%f4, %g3, 0
	fjlt	%f2, %f16, fjge_else.44051
	fmov	%f1, %f2
	jmp	fjge_cont.44052
fjge_else.44051:
	fneg	%f1, %f2
fjge_cont.44052:
	fjlt	%f29, %f1, fjge_else.44053
	fjlt	%f1, %f16, fjge_else.44055
	fmov	%f0, %f1
	jmp	fjge_cont.44056
fjge_else.44055:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.44057
	fjlt	%f1, %f16, fjge_else.44059
	fmov	%f0, %f1
	jmp	fjge_cont.44060
fjge_else.44059:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.44061
	fjlt	%f1, %f16, fjge_else.44063
	fmov	%f0, %f1
	jmp	fjge_cont.44064
fjge_else.44063:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2518
	addi	%g1, %g1, 8
fjge_cont.44064:
	jmp	fjge_cont.44062
fjge_else.44061:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2518
	addi	%g1, %g1, 8
fjge_cont.44062:
fjge_cont.44060:
	jmp	fjge_cont.44058
fjge_else.44057:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.44065
	fjlt	%f1, %f16, fjge_else.44067
	fmov	%f0, %f1
	jmp	fjge_cont.44068
fjge_else.44067:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2518
	addi	%g1, %g1, 8
fjge_cont.44068:
	jmp	fjge_cont.44066
fjge_else.44065:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2518
	addi	%g1, %g1, 8
fjge_cont.44066:
fjge_cont.44058:
fjge_cont.44056:
	jmp	fjge_cont.44054
fjge_else.44053:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.44069
	fjlt	%f1, %f16, fjge_else.44071
	fmov	%f0, %f1
	jmp	fjge_cont.44072
fjge_else.44071:
	fadd	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.44073
	fjlt	%f1, %f16, fjge_else.44075
	fmov	%f0, %f1
	jmp	fjge_cont.44076
fjge_else.44075:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2518
	addi	%g1, %g1, 8
fjge_cont.44076:
	jmp	fjge_cont.44074
fjge_else.44073:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2518
	addi	%g1, %g1, 8
fjge_cont.44074:
fjge_cont.44072:
	jmp	fjge_cont.44070
fjge_else.44069:
	fsub	%f1, %f1, %f29
	fjlt	%f29, %f1, fjge_else.44077
	fjlt	%f1, %f16, fjge_else.44079
	fmov	%f0, %f1
	jmp	fjge_cont.44080
fjge_else.44079:
	fadd	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2518
	addi	%g1, %g1, 8
fjge_cont.44080:
	jmp	fjge_cont.44078
fjge_else.44077:
	fsub	%f1, %f1, %f29
	subi	%g1, %g1, 8
	call	sin_sub.2518
	addi	%g1, %g1, 8
fjge_cont.44078:
fjge_cont.44070:
fjge_cont.44054:
	fjlt	%f3, %f0, fjge_else.44081
	fjlt	%f16, %f2, fjge_else.44083
	addi	%g3, %g0, 0
	jmp	fjge_cont.44084
fjge_else.44083:
	addi	%g3, %g0, 1
fjge_cont.44084:
	jmp	fjge_cont.44082
fjge_else.44081:
	fjlt	%f16, %f2, fjge_else.44085
	addi	%g3, %g0, 1
	jmp	fjge_cont.44086
fjge_else.44085:
	addi	%g3, %g0, 0
fjge_cont.44086:
fjge_cont.44082:
	fjlt	%f3, %f0, fjge_else.44087
	fmov	%f1, %f0
	jmp	fjge_cont.44088
fjge_else.44087:
	fsub	%f1, %f29, %f0
fjge_cont.44088:
	fjlt	%f22, %f1, fjge_else.44089
	fmov	%f0, %f1
	jmp	fjge_cont.44090
fjge_else.44089:
	fsub	%f0, %f3, %f1
fjge_cont.44090:
	fmul	%f1, %f0, %f21
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f1, %f4, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	jne	%g3, %g0, jeq_else.44091
	fneg	%f1, %f0
	jmp	jeq_cont.44092
jeq_else.44091:
	fmov	%f1, %f0
jeq_cont.44092:
	fmul	%f0, %f1, %f1
	fmul	%f1, %f0, %f27
	fsti	%f1, %g31, 564
	fsub	%f0, %f17, %f0
	fmul	%f0, %f0, %f27
	fsti	%f0, %g31, 560
	jmp	jeq_cont.44050
jeq_else.44049:
	addi	%g4, %g0, 4
	jne	%g3, %g4, jeq_else.44093
	fldi	%f1, %g31, 540
	ldi	%g5, %g14, -20
	fldi	%f0, %g5, 0
	fsub	%f1, %f1, %f0
	ldi	%g6, %g14, -16
	fldi	%f0, %g6, 0
	fsqrt	%f0, %f0
	fmul	%f1, %f1, %f0
	fldi	%f2, %g31, 532
	fldi	%f0, %g5, -8
	fsub	%f2, %f2, %f0
	fldi	%f0, %g6, -8
	fsqrt	%f0, %f0
	fmul	%f2, %f2, %f0
	fmul	%f3, %f1, %f1
	fmul	%f0, %f2, %f2
	fadd	%f5, %f3, %f0
	fjlt	%f1, %f16, fjge_else.44095
	fmov	%f0, %f1
	jmp	fjge_cont.44096
fjge_else.44095:
	fneg	%f0, %f1
fjge_cont.44096:
	setL %g3, l.37896
	fldi	%f6, %g3, 0
	fjlt	%f0, %f6, fjge_else.44097
	fdiv	%f1, %f2, %f1
	fjlt	%f1, %f16, fjge_else.44099
	fmov	%f0, %f1
	jmp	fjge_cont.44100
fjge_else.44099:
	fneg	%f0, %f1
fjge_cont.44100:
	fjlt	%f17, %f0, fjge_else.44101
	fjlt	%f0, %f20, fjge_else.44103
	addi	%g3, %g0, 0
	jmp	fjge_cont.44104
fjge_else.44103:
	addi	%g3, %g0, -1
fjge_cont.44104:
	jmp	fjge_cont.44102
fjge_else.44101:
	addi	%g3, %g0, 1
fjge_cont.44102:
	jne	%g3, %g0, jeq_else.44105
	fmov	%f4, %f0
	jmp	jeq_cont.44106
jeq_else.44105:
	fdiv	%f4, %f17, %f0
jeq_cont.44106:
	fmul	%f0, %f4, %f4
	setL %g4, l.37902
	fldi	%f1, %g4, 0
	fmul	%f2, %f1, %f0
	setL %g4, l.37904
	fldi	%f1, %g4, 0
	fdiv	%f2, %f2, %f1
	setL %g4, l.37906
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37908
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37910
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37912
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37914
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37916
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37918
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f28, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37921
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37923
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37925
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37927
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37929
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f25, %f2
	fdiv	%f1, %f3, %f1
	fmul	%f2, %f25, %f0
	fadd	%f1, %f26, %f1
	fdiv	%f2, %f2, %f1
	setL %g4, l.37933
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f24, %f2
	fdiv	%f1, %f3, %f1
	fadd	%f1, %f23, %f1
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f4, %f0
	jlt	%g0, %g3, jle_else.44107
	jlt	%g3, %g0, jge_else.44109
	fmov	%f0, %f1
	jmp	jge_cont.44110
jge_else.44109:
	fsub	%f0, %f31, %f1
jge_cont.44110:
	jmp	jle_cont.44108
jle_else.44107:
	fsub	%f0, %f22, %f1
jle_cont.44108:
	setL %g3, l.37940
	fldi	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fdiv	%f0, %f0, %f30
	jmp	fjge_cont.44098
fjge_else.44097:
	setL %g3, l.37898
	fldi	%f0, %g3, 0
fjge_cont.44098:
	fsti	%f0, %g1, 4
	subi	%g1, %g1, 12
	call	min_caml_floor
	addi	%g1, %g1, 12
	fmov	%f1, %f0
	fldi	%f0, %g1, 4
	fsub	%f7, %f0, %f1
	fldi	%f1, %g31, 536
	fldi	%f0, %g5, -4
	fsub	%f1, %f1, %f0
	fldi	%f0, %g6, -4
	fsqrt	%f0, %f0
	fmul	%f1, %f1, %f0
	fjlt	%f5, %f16, fjge_else.44111
	fmov	%f0, %f5
	jmp	fjge_cont.44112
fjge_else.44111:
	fneg	%f0, %f5
fjge_cont.44112:
	fjlt	%f0, %f6, fjge_else.44113
	fdiv	%f1, %f1, %f5
	fjlt	%f1, %f16, fjge_else.44115
	fmov	%f0, %f1
	jmp	fjge_cont.44116
fjge_else.44115:
	fneg	%f0, %f1
fjge_cont.44116:
	fjlt	%f17, %f0, fjge_else.44117
	fjlt	%f0, %f20, fjge_else.44119
	addi	%g3, %g0, 0
	jmp	fjge_cont.44120
fjge_else.44119:
	addi	%g3, %g0, -1
fjge_cont.44120:
	jmp	fjge_cont.44118
fjge_else.44117:
	addi	%g3, %g0, 1
fjge_cont.44118:
	jne	%g3, %g0, jeq_else.44121
	fmov	%f4, %f0
	jmp	jeq_cont.44122
jeq_else.44121:
	fdiv	%f4, %f17, %f0
jeq_cont.44122:
	fmul	%f0, %f4, %f4
	setL %g4, l.37902
	fldi	%f1, %g4, 0
	fmul	%f2, %f1, %f0
	setL %g4, l.37904
	fldi	%f1, %g4, 0
	fdiv	%f2, %f2, %f1
	setL %g4, l.37906
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37908
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37910
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37912
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37914
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37916
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37918
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f28, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37921
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37923
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37925
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	setL %g4, l.37927
	fldi	%f1, %g4, 0
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g4, l.37929
	fldi	%f1, %g4, 0
	fmul	%f3, %f1, %f0
	fadd	%f1, %f25, %f2
	fdiv	%f2, %f3, %f1
	fmul	%f1, %f25, %f0
	fadd	%f2, %f26, %f2
	fdiv	%f1, %f1, %f2
	setL %g4, l.37933
	fldi	%f2, %g4, 0
	fmul	%f2, %f2, %f0
	fadd	%f1, %f24, %f1
	fdiv	%f1, %f2, %f1
	fadd	%f1, %f23, %f1
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f17, %f0
	fdiv	%f0, %f4, %f0
	jlt	%g0, %g3, jle_else.44123
	jlt	%g3, %g0, jge_else.44125
	fmov	%f1, %f0
	jmp	jge_cont.44126
jge_else.44125:
	fsub	%f1, %f31, %f0
jge_cont.44126:
	jmp	jle_cont.44124
jle_else.44123:
	fsub	%f1, %f22, %f0
jle_cont.44124:
	setL %g3, l.37940
	fldi	%f0, %g3, 0
	fmul	%f0, %f1, %f0
	fdiv	%f0, %f0, %f30
	jmp	fjge_cont.44114
fjge_else.44113:
	setL %g3, l.37898
	fldi	%f0, %g3, 0
fjge_cont.44114:
	fsti	%f0, %g1, 8
	subi	%g1, %g1, 16
	call	min_caml_floor
	addi	%g1, %g1, 16
	fmov	%f1, %f0
	fldi	%f0, %g1, 8
	fsub	%f0, %f0, %f1
	setL %g3, l.37977
	fldi	%f2, %g3, 0
	fsub	%f1, %f21, %f7
	fmul	%f1, %f1, %f1
	fsub	%f1, %f2, %f1
	fsub	%f0, %f21, %f0
	fmul	%f0, %f0, %f0
	fsub	%f1, %f1, %f0
	fjlt	%f1, %f16, fjge_else.44127
	fmov	%f0, %f1
	jmp	fjge_cont.44128
fjge_else.44127:
	fmov	%f0, %f16
fjge_cont.44128:
	fmul	%f1, %f27, %f0
	setL %g3, l.37981
	fldi	%f0, %g3, 0
	fdiv	%f0, %f1, %f0
	fsti	%f0, %g31, 560
	jmp	jeq_cont.44094
jeq_else.44093:
jeq_cont.44094:
jeq_cont.44050:
jeq_cont.44006:
jeq_cont.43998:
	addi	%g12, %g0, 0
	ldi	%g13, %g31, 516
	subi	%g1, %g1, 16
	call	shadow_check_one_or_matrix.2860
	addi	%g1, %g1, 16
	jne	%g3, %g0, jeq_else.44129
	fldi	%f1, %g31, 556
	fldi	%f0, %g31, 308
	fmul	%f2, %f1, %f0
	fldi	%f1, %g31, 552
	fldi	%f0, %g31, 304
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g31, 548
	fldi	%f0, %g31, 300
	fmul	%f0, %f1, %f0
	fadd	%f1, %f2, %f0
	fneg	%f1, %f1
	fjlt	%f16, %f1, fjge_else.44130
	fmov	%f0, %f16
	jmp	fjge_cont.44131
fjge_else.44130:
	fmov	%f0, %f1
fjge_cont.44131:
	fmul	%f1, %f10, %f0
	ldi	%g3, %g14, -28
	fldi	%f0, %g3, 0
	fmul	%f0, %f1, %f0
	fldi	%f2, %g31, 580
	fldi	%f1, %g31, 568
	fmul	%f1, %f0, %f1
	fadd	%f1, %f2, %f1
	fsti	%f1, %g31, 580
	fldi	%f2, %g31, 576
	fldi	%f1, %g31, 564
	fmul	%f1, %f0, %f1
	fadd	%f1, %f2, %f1
	fsti	%f1, %g31, 576
	fldi	%f2, %g31, 572
	fldi	%f1, %g31, 560
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	fsti	%f0, %g31, 572
	return
jeq_else.44129:
	return

!==============================
! args = [%g23, %g22, %g24, %g25]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
iter_trace_diffuse_rays.2921:
	jlt	%g25, %g0, jge_else.44134
	slli	%g3, %g25, 2
	ld	%g3, %g23, %g3
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44135
	slli	%g3, %g25, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 4
	jmp	fjge_cont.44136
fjge_else.44135:
	addi	%g3, %g25, 1
	slli	%g3, %g3, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 4
fjge_cont.44136:
	subi	%g25, %g25, 2
	jlt	%g25, %g0, jge_else.44137
	slli	%g3, %g25, 2
	ld	%g3, %g23, %g3
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44138
	slli	%g3, %g25, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 4
	jmp	fjge_cont.44139
fjge_else.44138:
	addi	%g3, %g25, 1
	slli	%g3, %g3, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 4
fjge_cont.44139:
	subi	%g25, %g25, 2
	jlt	%g25, %g0, jge_else.44140
	slli	%g3, %g25, 2
	ld	%g3, %g23, %g3
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44141
	slli	%g3, %g25, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 4
	jmp	fjge_cont.44142
fjge_else.44141:
	addi	%g3, %g25, 1
	slli	%g3, %g3, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 4
fjge_cont.44142:
	subi	%g25, %g25, 2
	jlt	%g25, %g0, jge_else.44143
	slli	%g3, %g25, 2
	ld	%g3, %g23, %g3
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44144
	slli	%g3, %g25, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 4
	jmp	fjge_cont.44145
fjge_else.44144:
	addi	%g3, %g25, 1
	slli	%g3, %g3, 2
	ld	%g4, %g23, %g3
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 4
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 4
fjge_cont.44145:
	subi	%g25, %g25, 2
	jmp	iter_trace_diffuse_rays.2921
jge_else.44143:
	return
jge_else.44140:
	return
jge_else.44137:
	return
jge_else.44134:
	return

!==============================
! args = [%g15, %g14, %g13, %g12, %g11, %g10, %g9, %g25, %g26]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
do_without_neighbors.2943:
	addi	%g3, %g0, 4
	jlt	%g3, %g26, jle_else.44150
	slli	%g3, %g26, 2
	ld	%g3, %g13, %g3
	jlt	%g3, %g0, jge_else.44151
	slli	%g3, %g26, 2
	ld	%g3, %g12, %g3
	sti	%g25, %g1, 0
	sti	%g9, %g1, 4
	sti	%g10, %g1, 8
	sti	%g11, %g1, 12
	sti	%g12, %g1, 16
	sti	%g13, %g1, 20
	sti	%g14, %g1, 24
	sti	%g15, %g1, 28
	jne	%g3, %g0, jeq_else.44152
	jmp	jeq_cont.44153
jeq_else.44152:
	slli	%g3, %g26, 2
	ld	%g3, %g10, %g3
	fldi	%f0, %g3, 0
	fsti	%f0, %g31, 580
	fldi	%f0, %g3, -4
	fsti	%f0, %g31, 576
	fldi	%f0, %g3, -8
	fsti	%f0, %g31, 572
	ldi	%g30, %g9, 0
	slli	%g3, %g26, 2
	ld	%g22, %g25, %g3
	slli	%g3, %g26, 2
	ld	%g24, %g14, %g3
	sti	%g11, %g1, 32
	sti	%g22, %g1, 36
	sti	%g24, %g1, 40
	jne	%g30, %g0, jeq_else.44154
	jmp	jeq_cont.44155
jeq_else.44154:
	ldi	%g23, %g31, 716
	fldi	%f0, %g24, 0
	fsti	%f0, %g31, 636
	fldi	%f0, %g24, -4
	fsti	%f0, %g31, 632
	fldi	%f0, %g24, -8
	fsti	%f0, %g31, 628
	ldi	%g3, %g31, 28
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.44156
	slli	%g4, %g3, 2
	add	%g4, %g31, %g4
	ldi	%g4, %g4, 272
	ldi	%g7, %g4, -40
	ldi	%g6, %g4, -4
	fldi	%f1, %g24, 0
	ldi	%g5, %g4, -20
	fldi	%f0, %g5, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, 0
	fldi	%f1, %g24, -4
	fldi	%f0, %g5, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -4
	fldi	%f1, %g24, -8
	fldi	%f0, %g5, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -8
	addi	%g5, %g0, 2
	jne	%g6, %g5, jeq_else.44158
	ldi	%g4, %g4, -16
	fldi	%f1, %g7, 0
	fldi	%f3, %g7, -4
	fldi	%f2, %g7, -8
	fldi	%f0, %g4, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g4, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g7, -12
	jmp	jeq_cont.44159
jeq_else.44158:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.44160
	jmp	jle_cont.44161
jle_else.44160:
	fldi	%f2, %g7, 0
	fldi	%f1, %g7, -4
	fldi	%f0, %g7, -8
	fmul	%f4, %f2, %f2
	ldi	%g5, %g4, -16
	fldi	%f3, %g5, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g5, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g5, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g5, %g4, -12
	jne	%g5, %g0, jeq_else.44162
	fmov	%f3, %f4
	jmp	jeq_cont.44163
jeq_else.44162:
	fmul	%f5, %f1, %f0
	ldi	%g4, %g4, -36
	fldi	%f3, %g4, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g4, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g4, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.44163:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.44164
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.44165
jeq_else.44164:
	fmov	%f0, %f3
jeq_cont.44165:
	fsti	%f0, %g7, -12
jle_cont.44161:
jeq_cont.44159:
	subi	%g4, %g3, 1
	mov	%g3, %g24
	subi	%g1, %g1, 48
	call	setup_startp_constants.2823
	addi	%g1, %g1, 48
	jmp	jge_cont.44157
jge_else.44156:
jge_cont.44157:
	ldi	%g3, %g23, -472
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44166
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
	jmp	fjge_cont.44167
fjge_else.44166:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
fjge_cont.44167:
	ldi	%g3, %g23, -464
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44168
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
	jmp	fjge_cont.44169
fjge_else.44168:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
fjge_cont.44169:
	ldi	%g3, %g23, -456
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44170
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
	jmp	fjge_cont.44171
fjge_else.44170:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
fjge_cont.44171:
	addi	%g3, %g0, 112
	mov	%g25, %g3
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2921
	addi	%g1, %g1, 48
jeq_cont.44155:
	jne	%g30, %g28, jeq_else.44172
	jmp	jeq_cont.44173
jeq_else.44172:
	ldi	%g23, %g31, 712
	ldi	%g24, %g1, 40
	fldi	%f0, %g24, 0
	fsti	%f0, %g31, 636
	fldi	%f0, %g24, -4
	fsti	%f0, %g31, 632
	fldi	%f0, %g24, -8
	fsti	%f0, %g31, 628
	ldi	%g3, %g31, 28
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.44174
	slli	%g4, %g3, 2
	add	%g4, %g31, %g4
	ldi	%g4, %g4, 272
	ldi	%g7, %g4, -40
	ldi	%g6, %g4, -4
	fldi	%f1, %g24, 0
	ldi	%g5, %g4, -20
	fldi	%f0, %g5, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, 0
	fldi	%f1, %g24, -4
	fldi	%f0, %g5, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -4
	fldi	%f1, %g24, -8
	fldi	%f0, %g5, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -8
	addi	%g5, %g0, 2
	jne	%g6, %g5, jeq_else.44176
	ldi	%g4, %g4, -16
	fldi	%f1, %g7, 0
	fldi	%f3, %g7, -4
	fldi	%f2, %g7, -8
	fldi	%f0, %g4, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g4, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g7, -12
	jmp	jeq_cont.44177
jeq_else.44176:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.44178
	jmp	jle_cont.44179
jle_else.44178:
	fldi	%f2, %g7, 0
	fldi	%f1, %g7, -4
	fldi	%f0, %g7, -8
	fmul	%f4, %f2, %f2
	ldi	%g5, %g4, -16
	fldi	%f3, %g5, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g5, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g5, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g5, %g4, -12
	jne	%g5, %g0, jeq_else.44180
	fmov	%f3, %f4
	jmp	jeq_cont.44181
jeq_else.44180:
	fmul	%f5, %f1, %f0
	ldi	%g4, %g4, -36
	fldi	%f3, %g4, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g4, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g4, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.44181:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.44182
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.44183
jeq_else.44182:
	fmov	%f0, %f3
jeq_cont.44183:
	fsti	%f0, %g7, -12
jle_cont.44179:
jeq_cont.44177:
	subi	%g4, %g3, 1
	mov	%g3, %g24
	subi	%g1, %g1, 48
	call	setup_startp_constants.2823
	addi	%g1, %g1, 48
	jmp	jge_cont.44175
jge_else.44174:
jge_cont.44175:
	ldi	%g3, %g23, -472
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	ldi	%g22, %g1, 36
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44184
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
	jmp	fjge_cont.44185
fjge_else.44184:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
fjge_cont.44185:
	ldi	%g3, %g23, -464
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44186
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
	jmp	fjge_cont.44187
fjge_else.44186:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
fjge_cont.44187:
	ldi	%g3, %g23, -456
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44188
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
	jmp	fjge_cont.44189
fjge_else.44188:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
fjge_cont.44189:
	addi	%g3, %g0, 112
	mov	%g25, %g3
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2921
	addi	%g1, %g1, 48
jeq_cont.44173:
	addi	%g3, %g0, 2
	jne	%g30, %g3, jeq_else.44190
	jmp	jeq_cont.44191
jeq_else.44190:
	ldi	%g23, %g31, 708
	ldi	%g24, %g1, 40
	fldi	%f0, %g24, 0
	fsti	%f0, %g31, 636
	fldi	%f0, %g24, -4
	fsti	%f0, %g31, 632
	fldi	%f0, %g24, -8
	fsti	%f0, %g31, 628
	ldi	%g3, %g31, 28
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.44192
	slli	%g4, %g3, 2
	add	%g4, %g31, %g4
	ldi	%g4, %g4, 272
	ldi	%g7, %g4, -40
	ldi	%g6, %g4, -4
	fldi	%f1, %g24, 0
	ldi	%g5, %g4, -20
	fldi	%f0, %g5, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, 0
	fldi	%f1, %g24, -4
	fldi	%f0, %g5, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -4
	fldi	%f1, %g24, -8
	fldi	%f0, %g5, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -8
	addi	%g5, %g0, 2
	jne	%g6, %g5, jeq_else.44194
	ldi	%g4, %g4, -16
	fldi	%f1, %g7, 0
	fldi	%f3, %g7, -4
	fldi	%f2, %g7, -8
	fldi	%f0, %g4, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g4, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g7, -12
	jmp	jeq_cont.44195
jeq_else.44194:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.44196
	jmp	jle_cont.44197
jle_else.44196:
	fldi	%f2, %g7, 0
	fldi	%f1, %g7, -4
	fldi	%f0, %g7, -8
	fmul	%f4, %f2, %f2
	ldi	%g5, %g4, -16
	fldi	%f3, %g5, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g5, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g5, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g5, %g4, -12
	jne	%g5, %g0, jeq_else.44198
	fmov	%f3, %f4
	jmp	jeq_cont.44199
jeq_else.44198:
	fmul	%f5, %f1, %f0
	ldi	%g4, %g4, -36
	fldi	%f3, %g4, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g4, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g4, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.44199:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.44200
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.44201
jeq_else.44200:
	fmov	%f0, %f3
jeq_cont.44201:
	fsti	%f0, %g7, -12
jle_cont.44197:
jeq_cont.44195:
	subi	%g4, %g3, 1
	mov	%g3, %g24
	subi	%g1, %g1, 48
	call	setup_startp_constants.2823
	addi	%g1, %g1, 48
	jmp	jge_cont.44193
jge_else.44192:
jge_cont.44193:
	ldi	%g3, %g23, -472
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	ldi	%g22, %g1, 36
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44202
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
	jmp	fjge_cont.44203
fjge_else.44202:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
fjge_cont.44203:
	ldi	%g3, %g23, -464
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44204
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
	jmp	fjge_cont.44205
fjge_else.44204:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
fjge_cont.44205:
	ldi	%g3, %g23, -456
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44206
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
	jmp	fjge_cont.44207
fjge_else.44206:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
fjge_cont.44207:
	addi	%g3, %g0, 112
	mov	%g25, %g3
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2921
	addi	%g1, %g1, 48
jeq_cont.44191:
	addi	%g3, %g0, 3
	jne	%g30, %g3, jeq_else.44208
	jmp	jeq_cont.44209
jeq_else.44208:
	ldi	%g23, %g31, 704
	ldi	%g24, %g1, 40
	fldi	%f0, %g24, 0
	fsti	%f0, %g31, 636
	fldi	%f0, %g24, -4
	fsti	%f0, %g31, 632
	fldi	%f0, %g24, -8
	fsti	%f0, %g31, 628
	ldi	%g3, %g31, 28
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.44210
	slli	%g4, %g3, 2
	add	%g4, %g31, %g4
	ldi	%g4, %g4, 272
	ldi	%g7, %g4, -40
	ldi	%g6, %g4, -4
	fldi	%f1, %g24, 0
	ldi	%g5, %g4, -20
	fldi	%f0, %g5, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, 0
	fldi	%f1, %g24, -4
	fldi	%f0, %g5, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -4
	fldi	%f1, %g24, -8
	fldi	%f0, %g5, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -8
	addi	%g5, %g0, 2
	jne	%g6, %g5, jeq_else.44212
	ldi	%g4, %g4, -16
	fldi	%f1, %g7, 0
	fldi	%f3, %g7, -4
	fldi	%f2, %g7, -8
	fldi	%f0, %g4, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g4, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g7, -12
	jmp	jeq_cont.44213
jeq_else.44212:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.44214
	jmp	jle_cont.44215
jle_else.44214:
	fldi	%f2, %g7, 0
	fldi	%f1, %g7, -4
	fldi	%f0, %g7, -8
	fmul	%f4, %f2, %f2
	ldi	%g5, %g4, -16
	fldi	%f3, %g5, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g5, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g5, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g5, %g4, -12
	jne	%g5, %g0, jeq_else.44216
	fmov	%f3, %f4
	jmp	jeq_cont.44217
jeq_else.44216:
	fmul	%f5, %f1, %f0
	ldi	%g4, %g4, -36
	fldi	%f3, %g4, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g4, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g4, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.44217:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.44218
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.44219
jeq_else.44218:
	fmov	%f0, %f3
jeq_cont.44219:
	fsti	%f0, %g7, -12
jle_cont.44215:
jeq_cont.44213:
	subi	%g4, %g3, 1
	mov	%g3, %g24
	subi	%g1, %g1, 48
	call	setup_startp_constants.2823
	addi	%g1, %g1, 48
	jmp	jge_cont.44211
jge_else.44210:
jge_cont.44211:
	ldi	%g3, %g23, -472
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	ldi	%g22, %g1, 36
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44220
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
	jmp	fjge_cont.44221
fjge_else.44220:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
fjge_cont.44221:
	ldi	%g3, %g23, -464
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44222
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
	jmp	fjge_cont.44223
fjge_else.44222:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
fjge_cont.44223:
	ldi	%g3, %g23, -456
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44224
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
	jmp	fjge_cont.44225
fjge_else.44224:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
fjge_cont.44225:
	addi	%g3, %g0, 112
	mov	%g25, %g3
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2921
	addi	%g1, %g1, 48
jeq_cont.44209:
	addi	%g3, %g0, 4
	jne	%g30, %g3, jeq_else.44226
	jmp	jeq_cont.44227
jeq_else.44226:
	ldi	%g23, %g31, 700
	ldi	%g24, %g1, 40
	fldi	%f0, %g24, 0
	fsti	%f0, %g31, 636
	fldi	%f0, %g24, -4
	fsti	%f0, %g31, 632
	fldi	%f0, %g24, -8
	fsti	%f0, %g31, 628
	ldi	%g3, %g31, 28
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.44228
	slli	%g4, %g3, 2
	add	%g4, %g31, %g4
	ldi	%g4, %g4, 272
	ldi	%g7, %g4, -40
	ldi	%g6, %g4, -4
	fldi	%f1, %g24, 0
	ldi	%g5, %g4, -20
	fldi	%f0, %g5, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, 0
	fldi	%f1, %g24, -4
	fldi	%f0, %g5, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -4
	fldi	%f1, %g24, -8
	fldi	%f0, %g5, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g7, -8
	addi	%g5, %g0, 2
	jne	%g6, %g5, jeq_else.44230
	ldi	%g4, %g4, -16
	fldi	%f1, %g7, 0
	fldi	%f3, %g7, -4
	fldi	%f2, %g7, -8
	fldi	%f0, %g4, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g4, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g7, -12
	jmp	jeq_cont.44231
jeq_else.44230:
	addi	%g5, %g0, 2
	jlt	%g5, %g6, jle_else.44232
	jmp	jle_cont.44233
jle_else.44232:
	fldi	%f2, %g7, 0
	fldi	%f1, %g7, -4
	fldi	%f0, %g7, -8
	fmul	%f4, %f2, %f2
	ldi	%g5, %g4, -16
	fldi	%f3, %g5, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g5, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g5, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g5, %g4, -12
	jne	%g5, %g0, jeq_else.44234
	fmov	%f3, %f4
	jmp	jeq_cont.44235
jeq_else.44234:
	fmul	%f5, %f1, %f0
	ldi	%g4, %g4, -36
	fldi	%f3, %g4, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g4, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g4, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.44235:
	addi	%g4, %g0, 3
	jne	%g6, %g4, jeq_else.44236
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.44237
jeq_else.44236:
	fmov	%f0, %f3
jeq_cont.44237:
	fsti	%f0, %g7, -12
jle_cont.44233:
jeq_cont.44231:
	subi	%g4, %g3, 1
	mov	%g3, %g24
	subi	%g1, %g1, 48
	call	setup_startp_constants.2823
	addi	%g1, %g1, 48
	jmp	jge_cont.44229
jge_else.44228:
jge_cont.44229:
	ldi	%g3, %g23, -472
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	ldi	%g22, %g1, 36
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44238
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
	jmp	fjge_cont.44239
fjge_else.44238:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
fjge_cont.44239:
	ldi	%g3, %g23, -464
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44240
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
	jmp	fjge_cont.44241
fjge_else.44240:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
fjge_cont.44241:
	ldi	%g3, %g23, -456
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44242
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
	jmp	fjge_cont.44243
fjge_else.44242:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 48
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 48
fjge_cont.44243:
	addi	%g30, %g0, 112
	mov	%g25, %g30
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2921
	addi	%g1, %g1, 48
jeq_cont.44227:
	slli	%g3, %g26, 2
	ldi	%g11, %g1, 32
	ld	%g3, %g11, %g3
	fldi	%f2, %g31, 592
	fldi	%f1, %g3, 0
	fldi	%f0, %g31, 580
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fsti	%f0, %g31, 592
	fldi	%f2, %g31, 588
	fldi	%f1, %g3, -4
	fldi	%f0, %g31, 576
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fsti	%f0, %g31, 588
	fldi	%f2, %g31, 584
	fldi	%f1, %g3, -8
	fldi	%f0, %g31, 572
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fsti	%f0, %g31, 584
jeq_cont.44153:
	addi	%g26, %g26, 1
	ldi	%g15, %g1, 28
	ldi	%g14, %g1, 24
	ldi	%g13, %g1, 20
	ldi	%g12, %g1, 16
	ldi	%g11, %g1, 12
	ldi	%g10, %g1, 8
	ldi	%g9, %g1, 4
	ldi	%g25, %g1, 0
	jmp	do_without_neighbors.2943
jge_else.44151:
	return
jle_else.44150:
	return

!==============================
! args = [%g4, %g10, %g9, %g5, %g8, %g26]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
try_exploit_neighbors.2959:
	slli	%g3, %g4, 2
	ld	%g6, %g5, %g3
	addi	%g3, %g0, 4
	jlt	%g3, %g26, jle_else.44246
	ldi	%g7, %g6, -8
	slli	%g3, %g26, 2
	ld	%g3, %g7, %g3
	jlt	%g3, %g0, jge_else.44247
	slli	%g7, %g4, 2
	ld	%g7, %g9, %g7
	ldi	%g12, %g7, -8
	slli	%g11, %g26, 2
	ld	%g11, %g12, %g11
	jne	%g11, %g3, jeq_else.44248
	slli	%g11, %g4, 2
	ld	%g11, %g8, %g11
	ldi	%g12, %g11, -8
	slli	%g11, %g26, 2
	ld	%g11, %g12, %g11
	jne	%g11, %g3, jeq_else.44250
	subi	%g11, %g4, 1
	slli	%g11, %g11, 2
	ld	%g11, %g5, %g11
	ldi	%g12, %g11, -8
	slli	%g11, %g26, 2
	ld	%g11, %g12, %g11
	jne	%g11, %g3, jeq_else.44252
	addi	%g11, %g4, 1
	slli	%g11, %g11, 2
	ld	%g11, %g5, %g11
	ldi	%g12, %g11, -8
	slli	%g11, %g26, 2
	ld	%g11, %g12, %g11
	jne	%g11, %g3, jeq_else.44254
	addi	%g11, %g0, 1
	jmp	jeq_cont.44255
jeq_else.44254:
	addi	%g11, %g0, 0
jeq_cont.44255:
	jmp	jeq_cont.44253
jeq_else.44252:
	addi	%g11, %g0, 0
jeq_cont.44253:
	jmp	jeq_cont.44251
jeq_else.44250:
	addi	%g11, %g0, 0
jeq_cont.44251:
	jmp	jeq_cont.44249
jeq_else.44248:
	addi	%g11, %g0, 0
jeq_cont.44249:
	jne	%g11, %g0, jeq_else.44256
	slli	%g3, %g4, 2
	ld	%g3, %g5, %g3
	ldi	%g25, %g3, -28
	ldi	%g9, %g3, -24
	ldi	%g10, %g3, -20
	ldi	%g11, %g3, -16
	ldi	%g12, %g3, -12
	ldi	%g13, %g3, -8
	ldi	%g14, %g3, -4
	ldi	%g15, %g3, 0
	jmp	do_without_neighbors.2943
jeq_else.44256:
	ldi	%g11, %g6, -12
	slli	%g3, %g26, 2
	ld	%g3, %g11, %g3
	jne	%g3, %g0, jeq_else.44257
	jmp	jeq_cont.44258
jeq_else.44257:
	ldi	%g7, %g7, -20
	subi	%g3, %g4, 1
	slli	%g3, %g3, 2
	ld	%g3, %g5, %g3
	ldi	%g11, %g3, -20
	ldi	%g6, %g6, -20
	addi	%g3, %g4, 1
	slli	%g3, %g3, 2
	ld	%g3, %g5, %g3
	ldi	%g12, %g3, -20
	slli	%g3, %g4, 2
	ld	%g3, %g8, %g3
	ldi	%g13, %g3, -20
	slli	%g3, %g26, 2
	ld	%g3, %g7, %g3
	fldi	%f0, %g3, 0
	fsti	%f0, %g31, 580
	fldi	%f0, %g3, -4
	fsti	%f0, %g31, 576
	fldi	%f0, %g3, -8
	fsti	%f0, %g31, 572
	slli	%g3, %g26, 2
	ld	%g3, %g11, %g3
	fldi	%f1, %g31, 580
	fldi	%f0, %g3, 0
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 580
	fldi	%f1, %g31, 576
	fldi	%f0, %g3, -4
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 576
	fldi	%f1, %g31, 572
	fldi	%f0, %g3, -8
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 572
	slli	%g3, %g26, 2
	ld	%g3, %g6, %g3
	fldi	%f1, %g31, 580
	fldi	%f0, %g3, 0
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 580
	fldi	%f1, %g31, 576
	fldi	%f0, %g3, -4
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 576
	fldi	%f1, %g31, 572
	fldi	%f0, %g3, -8
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 572
	slli	%g3, %g26, 2
	ld	%g3, %g12, %g3
	fldi	%f1, %g31, 580
	fldi	%f0, %g3, 0
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 580
	fldi	%f1, %g31, 576
	fldi	%f0, %g3, -4
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 576
	fldi	%f1, %g31, 572
	fldi	%f0, %g3, -8
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 572
	slli	%g3, %g26, 2
	ld	%g3, %g13, %g3
	fldi	%f1, %g31, 580
	fldi	%f0, %g3, 0
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 580
	fldi	%f1, %g31, 576
	fldi	%f0, %g3, -4
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 576
	fldi	%f1, %g31, 572
	fldi	%f0, %g3, -8
	fadd	%f0, %f1, %f0
	fsti	%f0, %g31, 572
	slli	%g3, %g4, 2
	ld	%g3, %g5, %g3
	ldi	%g6, %g3, -16
	slli	%g3, %g26, 2
	ld	%g3, %g6, %g3
	fldi	%f2, %g31, 592
	fldi	%f1, %g3, 0
	fldi	%f0, %g31, 580
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fsti	%f0, %g31, 592
	fldi	%f2, %g31, 588
	fldi	%f1, %g3, -4
	fldi	%f0, %g31, 576
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fsti	%f0, %g31, 588
	fldi	%f2, %g31, 584
	fldi	%f1, %g3, -8
	fldi	%f0, %g31, 572
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fsti	%f0, %g31, 584
jeq_cont.44258:
	addi	%g26, %g26, 1
	jmp	try_exploit_neighbors.2959
jge_else.44247:
	return
jle_else.44246:
	return

!==============================
! args = [%g14, %g12, %g11, %g10, %g13, %g9, %g25, %g30, %g26]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
pretrace_diffuse_rays.2972:
	addi	%g3, %g0, 4
	jlt	%g3, %g26, jle_else.44261
	slli	%g3, %g26, 2
	ld	%g3, %g11, %g3
	jlt	%g3, %g0, jge_else.44262
	slli	%g3, %g26, 2
	ld	%g3, %g10, %g3
	sti	%g25, %g1, 0
	sti	%g13, %g1, 4
	sti	%g10, %g1, 8
	sti	%g11, %g1, 12
	sti	%g12, %g1, 16
	sti	%g14, %g1, 20
	jne	%g3, %g0, jeq_else.44263
	jmp	jeq_cont.44264
jeq_else.44263:
	ldi	%g3, %g25, 0
	fsti	%f16, %g31, 580
	fsti	%f16, %g31, 576
	fsti	%f16, %g31, 572
	slli	%g3, %g3, 2
	add	%g3, %g31, %g3
	ldi	%g23, %g3, 716
	slli	%g3, %g26, 2
	ld	%g22, %g30, %g3
	slli	%g3, %g26, 2
	ld	%g24, %g12, %g3
	fldi	%f0, %g24, 0
	fsti	%f0, %g31, 636
	fldi	%f0, %g24, -4
	fsti	%f0, %g31, 632
	fldi	%f0, %g24, -8
	fsti	%f0, %g31, 628
	ldi	%g3, %g31, 28
	subi	%g7, %g3, 1
	jlt	%g7, %g0, jge_else.44265
	slli	%g3, %g7, 2
	add	%g3, %g31, %g3
	ldi	%g3, %g3, 272
	ldi	%g6, %g3, -40
	ldi	%g5, %g3, -4
	fldi	%f1, %g24, 0
	ldi	%g4, %g3, -20
	fldi	%f0, %g4, 0
	fsub	%f0, %f1, %f0
	fsti	%f0, %g6, 0
	fldi	%f1, %g24, -4
	fldi	%f0, %g4, -4
	fsub	%f0, %f1, %f0
	fsti	%f0, %g6, -4
	fldi	%f1, %g24, -8
	fldi	%f0, %g4, -8
	fsub	%f0, %f1, %f0
	fsti	%f0, %g6, -8
	addi	%g4, %g0, 2
	jne	%g5, %g4, jeq_else.44267
	ldi	%g3, %g3, -16
	fldi	%f1, %g6, 0
	fldi	%f3, %g6, -4
	fldi	%f2, %g6, -8
	fldi	%f0, %g3, 0
	fmul	%f1, %f0, %f1
	fldi	%f0, %g3, -4
	fmul	%f0, %f0, %f3
	fadd	%f1, %f1, %f0
	fldi	%f0, %g3, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fsti	%f0, %g6, -12
	jmp	jeq_cont.44268
jeq_else.44267:
	addi	%g4, %g0, 2
	jlt	%g4, %g5, jle_else.44269
	jmp	jle_cont.44270
jle_else.44269:
	fldi	%f2, %g6, 0
	fldi	%f1, %g6, -4
	fldi	%f0, %g6, -8
	fmul	%f4, %f2, %f2
	ldi	%g4, %g3, -16
	fldi	%f3, %g4, 0
	fmul	%f5, %f4, %f3
	fmul	%f4, %f1, %f1
	fldi	%f3, %g4, -4
	fmul	%f3, %f4, %f3
	fadd	%f5, %f5, %f3
	fmul	%f4, %f0, %f0
	fldi	%f3, %g4, -8
	fmul	%f3, %f4, %f3
	fadd	%f4, %f5, %f3
	ldi	%g4, %g3, -12
	jne	%g4, %g0, jeq_else.44271
	fmov	%f3, %f4
	jmp	jeq_cont.44272
jeq_else.44271:
	fmul	%f5, %f1, %f0
	ldi	%g3, %g3, -36
	fldi	%f3, %g3, 0
	fmul	%f3, %f5, %f3
	fadd	%f4, %f4, %f3
	fmul	%f3, %f0, %f2
	fldi	%f0, %g3, -4
	fmul	%f0, %f3, %f0
	fadd	%f4, %f4, %f0
	fmul	%f1, %f2, %f1
	fldi	%f0, %g3, -8
	fmul	%f3, %f1, %f0
	fadd	%f3, %f4, %f3
jeq_cont.44272:
	addi	%g3, %g0, 3
	jne	%g5, %g3, jeq_else.44273
	fsub	%f0, %f3, %f17
	jmp	jeq_cont.44274
jeq_else.44273:
	fmov	%f0, %f3
jeq_cont.44274:
	fsti	%f0, %g6, -12
jle_cont.44270:
jeq_cont.44268:
	subi	%g4, %g7, 1
	mov	%g3, %g24
	subi	%g1, %g1, 28
	call	setup_startp_constants.2823
	addi	%g1, %g1, 28
	jmp	jge_cont.44266
jge_else.44265:
jge_cont.44266:
	ldi	%g3, %g23, -472
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	sti	%g9, %g1, 24
	fjlt	%f0, %f16, fjge_else.44275
	ldi	%g4, %g23, -472
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 32
	jmp	fjge_cont.44276
fjge_else.44275:
	ldi	%g4, %g23, -476
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 32
fjge_cont.44276:
	ldi	%g3, %g23, -464
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44277
	ldi	%g4, %g23, -464
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 32
	jmp	fjge_cont.44278
fjge_else.44277:
	ldi	%g4, %g23, -468
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 32
fjge_cont.44278:
	ldi	%g3, %g23, -456
	ldi	%g3, %g3, 0
	fldi	%f1, %g3, 0
	fldi	%f0, %g22, 0
	fmul	%f2, %f1, %f0
	fldi	%f1, %g3, -4
	fldi	%f0, %g22, -4
	fmul	%f0, %f1, %f0
	fadd	%f2, %f2, %f0
	fldi	%f1, %g3, -8
	fldi	%f0, %g22, -8
	fmul	%f0, %f1, %f0
	fadd	%f0, %f2, %f0
	fjlt	%f0, %f16, fjge_else.44279
	ldi	%g4, %g23, -456
	fdiv	%f10, %f0, %f18
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 32
	jmp	fjge_cont.44280
fjge_else.44279:
	ldi	%g4, %g23, -460
	fdiv	%f10, %f0, %f19
	ldi	%g3, %g4, -4
	ldi	%g21, %g4, 0
	subi	%g1, %g1, 32
	call	trace_diffuse_ray.2918
	addi	%g1, %g1, 32
fjge_cont.44280:
	addi	%g3, %g0, 112
	mov	%g25, %g3
	subi	%g1, %g1, 32
	call	iter_trace_diffuse_rays.2921
	addi	%g1, %g1, 32
	ldi	%g9, %g1, 24
	slli	%g3, %g26, 2
	ld	%g3, %g9, %g3
	fldi	%f0, %g31, 580
	fsti	%f0, %g3, 0
	fldi	%f0, %g31, 576
	fsti	%f0, %g3, -4
	fldi	%f0, %g31, 572
	fsti	%f0, %g3, -8
jeq_cont.44264:
	addi	%g26, %g26, 1
	ldi	%g14, %g1, 20
	ldi	%g12, %g1, 16
	ldi	%g11, %g1, 12
	ldi	%g10, %g1, 8
	ldi	%g13, %g1, 4
	ldi	%g25, %g1, 0
	jmp	pretrace_diffuse_rays.2972
jge_else.44262:
	return
jle_else.44261:
	return

!==============================
! args = [%g7, %g6, %g8]
! fargs = [%f13, %f12, %f11]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
pretrace_pixels.2975:
	jlt	%g6, %g0, jge_else.44283
	fldi	%f3, %g31, 612
	ldi	%g3, %g31, 608
	sub	%g3, %g6, %g3
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	fmul	%f0, %f3, %f0
	fldi	%f1, %g31, 648
	fmul	%f1, %f0, %f1
	fadd	%f1, %f1, %f13
	fsti	%f1, %g31, 684
	fldi	%f1, %g31, 644
	fmul	%f1, %f0, %f1
	fadd	%f1, %f1, %f12
	fsti	%f1, %g31, 680
	fldi	%f1, %g31, 640
	fmul	%f0, %f0, %f1
	fadd	%f0, %f0, %f11
	fsti	%f0, %g31, 676
	fldi	%f2, %g31, 684
	fmul	%f1, %f2, %f2
	fldi	%f0, %g31, 680
	fmul	%f0, %f0, %f0
	fadd	%f1, %f1, %f0
	fldi	%f0, %g31, 676
	fmul	%f0, %f0, %f0
	fadd	%f0, %f1, %f0
	fsqrt	%f0, %f0
	fjeq	%f0, %f16, fjne_else.44284
	fdiv	%f1, %f17, %f0
	jmp	fjne_cont.44285
fjne_else.44284:
	setL %g3, l.35959
	fldi	%f1, %g3, 0
fjne_cont.44285:
	fmul	%f0, %f2, %f1
	fsti	%f0, %g31, 684
	fldi	%f0, %g31, 680
	fmul	%f0, %f0, %f1
	fsti	%f0, %g31, 680
	fldi	%f0, %g31, 676
	fmul	%f0, %f0, %f1
	fsti	%f0, %g31, 676
	fsti	%f16, %g31, 592
	fsti	%f16, %g31, 588
	fsti	%f16, %g31, 584
	fldi	%f0, %g31, 296
	fsti	%f0, %g31, 624
	fldi	%f0, %g31, 292
	fsti	%f0, %g31, 620
	fldi	%f0, %g31, 288
	fsti	%f0, %g31, 616
	addi	%g25, %g0, 0
	slli	%g3, %g6, 2
	ld	%g3, %g7, %g3
	ldi	%g16, %g3, -28
	ldi	%g21, %g3, -24
	ldi	%g23, %g3, -20
	ldi	%g17, %g3, -16
	ldi	%g18, %g3, -12
	ldi	%g19, %g3, -8
	ldi	%g20, %g3, -4
	ldi	%g24, %g3, 0
	subi	%g22, %g31, 684
	fsti	%f11, %g1, 0
	fsti	%f12, %g1, 4
	fsti	%f13, %g1, 8
	sti	%g8, %g1, 12
	sti	%g7, %g1, 16
	sti	%g6, %g1, 20
	fmov	%f14, %f16
	fmov	%f13, %f17
	subi	%g1, %g1, 28
	call	trace_ray.2912
	addi	%g1, %g1, 28
	ldi	%g6, %g1, 20
	slli	%g3, %g6, 2
	ldi	%g7, %g1, 16
	ld	%g3, %g7, %g3
	ldi	%g3, %g3, 0
	fldi	%f0, %g31, 592
	fsti	%f0, %g3, 0
	fldi	%f0, %g31, 588
	fsti	%f0, %g3, -4
	fldi	%f0, %g31, 584
	fsti	%f0, %g3, -8
	slli	%g3, %g6, 2
	ld	%g3, %g7, %g3
	ldi	%g3, %g3, -24
	ldi	%g8, %g1, 12
	sti	%g8, %g3, 0
	slli	%g3, %g6, 2
	ld	%g3, %g7, %g3
	addi	%g26, %g0, 0
	ldi	%g30, %g3, -28
	ldi	%g25, %g3, -24
	ldi	%g9, %g3, -20
	ldi	%g13, %g3, -16
	ldi	%g10, %g3, -12
	ldi	%g11, %g3, -8
	ldi	%g12, %g3, -4
	ldi	%g14, %g3, 0
	subi	%g1, %g1, 28
	call	pretrace_diffuse_rays.2972
	addi	%g1, %g1, 28
	ldi	%g6, %g1, 20
	subi	%g6, %g6, 1
	ldi	%g8, %g1, 12
	addi	%g3, %g8, 1
	addi	%g8, %g0, 5
	jlt	%g3, %g8, jle_else.44286
	subi	%g8, %g3, 5
	jmp	jle_cont.44287
jle_else.44286:
	mov	%g8, %g3
jle_cont.44287:
	fldi	%f13, %g1, 8
	fldi	%f12, %g1, 4
	fldi	%f11, %g1, 0
	ldi	%g7, %g1, 16
	jmp	pretrace_pixels.2975
jge_else.44283:
	return

!==============================
! args = [%g6, %g10, %g9, %g7, %g8]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
scan_pixel.2986:
	ldi	%g3, %g31, 600
	jlt	%g6, %g3, jle_else.44289
	return
jle_else.44289:
	slli	%g3, %g6, 2
	ld	%g3, %g7, %g3
	ldi	%g3, %g3, 0
	fldi	%f0, %g3, 0
	fsti	%f0, %g31, 592
	fldi	%f0, %g3, -4
	fsti	%f0, %g31, 588
	fldi	%f0, %g3, -8
	fsti	%f0, %g31, 584
	ldi	%g4, %g31, 596
	addi	%g3, %g10, 1
	jlt	%g3, %g4, jle_else.44291
	addi	%g3, %g0, 0
	jmp	jle_cont.44292
jle_else.44291:
	jlt	%g0, %g10, jle_else.44293
	addi	%g3, %g0, 0
	jmp	jle_cont.44294
jle_else.44293:
	ldi	%g4, %g31, 600
	addi	%g3, %g6, 1
	jlt	%g3, %g4, jle_else.44295
	addi	%g3, %g0, 0
	jmp	jle_cont.44296
jle_else.44295:
	jlt	%g0, %g6, jle_else.44297
	addi	%g3, %g0, 0
	jmp	jle_cont.44298
jle_else.44297:
	addi	%g3, %g0, 1
jle_cont.44298:
jle_cont.44296:
jle_cont.44294:
jle_cont.44292:
	sti	%g8, %g1, 0
	sti	%g7, %g1, 4
	sti	%g9, %g1, 8
	sti	%g10, %g1, 12
	sti	%g6, %g1, 16
	jne	%g3, %g0, jeq_else.44299
	slli	%g3, %g6, 2
	ld	%g5, %g7, %g3
	addi	%g26, %g0, 0
	ldi	%g25, %g5, -28
	ldi	%g3, %g5, -24
	ldi	%g4, %g5, -20
	ldi	%g11, %g5, -16
	ldi	%g12, %g5, -12
	ldi	%g13, %g5, -8
	ldi	%g14, %g5, -4
	ldi	%g15, %g5, 0
	mov	%g9, %g3
	mov	%g10, %g4
	subi	%g1, %g1, 24
	call	do_without_neighbors.2943
	addi	%g1, %g1, 24
	jmp	jeq_cont.44300
jeq_else.44299:
	addi	%g26, %g0, 0
	mov	%g5, %g7
	mov	%g4, %g6
	subi	%g1, %g1, 24
	call	try_exploit_neighbors.2959
	addi	%g1, %g1, 24
jeq_cont.44300:
	fldi	%f0, %g31, 592
	subi	%g1, %g1, 24
	call	min_caml_int_of_float
	addi	%g1, %g1, 24
	mov	%g4, %g3
	addi	%g3, %g0, 255
	jlt	%g3, %g4, jle_else.44301
	jlt	%g4, %g0, jge_else.44303
	mov	%g3, %g4
	jmp	jge_cont.44304
jge_else.44303:
	addi	%g3, %g0, 0
jge_cont.44304:
	jmp	jle_cont.44302
jle_else.44301:
	addi	%g3, %g0, 255
jle_cont.44302:
	output	%g3
	fldi	%f0, %g31, 588
	subi	%g1, %g1, 24
	call	min_caml_int_of_float
	addi	%g1, %g1, 24
	mov	%g4, %g3
	addi	%g3, %g0, 255
	jlt	%g3, %g4, jle_else.44305
	jlt	%g4, %g0, jge_else.44307
	mov	%g3, %g4
	jmp	jge_cont.44308
jge_else.44307:
	addi	%g3, %g0, 0
jge_cont.44308:
	jmp	jle_cont.44306
jle_else.44305:
	addi	%g3, %g0, 255
jle_cont.44306:
	output	%g3
	fldi	%f0, %g31, 584
	subi	%g1, %g1, 24
	call	min_caml_int_of_float
	addi	%g1, %g1, 24
	mov	%g4, %g3
	addi	%g3, %g0, 255
	jlt	%g3, %g4, jle_else.44309
	jlt	%g4, %g0, jge_else.44311
	mov	%g3, %g4
	jmp	jge_cont.44312
jge_else.44311:
	addi	%g3, %g0, 0
jge_cont.44312:
	jmp	jle_cont.44310
jle_else.44309:
	addi	%g3, %g0, 255
jle_cont.44310:
	output	%g3
	ldi	%g6, %g1, 16
	addi	%g6, %g6, 1
	ldi	%g10, %g1, 12
	ldi	%g9, %g1, 8
	ldi	%g7, %g1, 4
	ldi	%g8, %g1, 0
	jmp	scan_pixel.2986

!==============================
! args = [%g10, %g7, %g9, %g8, %g3]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g30, %g3, %g27, %g26, %g25, %g24, %g23, %g22, %g21, %g20, %g19, %g18, %g17, %g16, %g15, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f30, %f3, %f29, %f28, %f27, %f26, %f25, %f24, %f23, %f22, %f21, %f20, %f2, %f19, %f18, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
scan_line.2992:
	ldi	%g4, %g31, 596
	jlt	%g10, %g4, jle_else.44313
	return
jle_else.44313:
	subi	%g4, %g4, 1
	sti	%g3, %g1, 0
	sti	%g8, %g1, 4
	sti	%g9, %g1, 8
	sti	%g7, %g1, 12
	sti	%g10, %g1, 16
	jlt	%g10, %g4, jle_else.44315
	jmp	jle_cont.44316
jle_else.44315:
	addi	%g5, %g10, 1
	fldi	%f3, %g31, 612
	ldi	%g4, %g31, 604
	sub	%g6, %g5, %g4
	mov	%g3, %g6
	subi	%g1, %g1, 24
	call	min_caml_float_of_int
	addi	%g1, %g1, 24
	fmul	%f0, %f3, %f0
	fldi	%f1, %g31, 660
	fmul	%f2, %f0, %f1
	fldi	%f1, %g31, 672
	fadd	%f13, %f2, %f1
	fldi	%f1, %g31, 656
	fmul	%f2, %f0, %f1
	fldi	%f1, %g31, 668
	fadd	%f12, %f2, %f1
	fldi	%f1, %g31, 652
	fmul	%f1, %f0, %f1
	fldi	%f0, %g31, 664
	fadd	%f11, %f1, %f0
	ldi	%g4, %g31, 600
	subi	%g6, %g4, 1
	ldi	%g3, %g1, 0
	mov	%g7, %g8
	mov	%g8, %g3
	subi	%g1, %g1, 24
	call	pretrace_pixels.2975
	addi	%g1, %g1, 24
jle_cont.44316:
	addi	%g6, %g0, 0
	ldi	%g10, %g1, 16
	ldi	%g7, %g1, 12
	ldi	%g9, %g1, 8
	ldi	%g8, %g1, 4
	mov	%g27, %g7
	mov	%g7, %g9
	mov	%g9, %g27
	subi	%g1, %g1, 24
	call	scan_pixel.2986
	addi	%g1, %g1, 24
	ldi	%g10, %g1, 16
	addi	%g10, %g10, 1
	ldi	%g3, %g1, 0
	addi	%g3, %g3, 2
	addi	%g6, %g0, 5
	jlt	%g3, %g6, jle_else.44317
	subi	%g6, %g3, 5
	jmp	jle_cont.44318
jle_else.44317:
	mov	%g6, %g3
jle_cont.44318:
	ldi	%g3, %g31, 596
	jlt	%g10, %g3, jle_else.44319
	return
jle_else.44319:
	subi	%g3, %g3, 1
	sti	%g6, %g1, 20
	sti	%g10, %g1, 24
	jlt	%g10, %g3, jle_else.44321
	jmp	jle_cont.44322
jle_else.44321:
	addi	%g4, %g10, 1
	fldi	%f3, %g31, 612
	ldi	%g3, %g31, 604
	sub	%g3, %g4, %g3
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	fmul	%f0, %f3, %f0
	fldi	%f1, %g31, 660
	fmul	%f2, %f0, %f1
	fldi	%f1, %g31, 672
	fadd	%f13, %f2, %f1
	fldi	%f1, %g31, 656
	fmul	%f2, %f0, %f1
	fldi	%f1, %g31, 668
	fadd	%f12, %f2, %f1
	fldi	%f1, %g31, 652
	fmul	%f1, %f0, %f1
	fldi	%f0, %g31, 664
	fadd	%f11, %f1, %f0
	ldi	%g3, %g31, 600
	subi	%g3, %g3, 1
	ldi	%g7, %g1, 12
	mov	%g8, %g6
	mov	%g6, %g3
	subi	%g1, %g1, 32
	call	pretrace_pixels.2975
	addi	%g1, %g1, 32
jle_cont.44322:
	addi	%g3, %g0, 0
	ldi	%g10, %g1, 24
	ldi	%g9, %g1, 8
	ldi	%g8, %g1, 4
	ldi	%g7, %g1, 12
	mov	%g6, %g3
	mov	%g27, %g8
	mov	%g8, %g7
	mov	%g7, %g27
	subi	%g1, %g1, 32
	call	scan_pixel.2986
	addi	%g1, %g1, 32
	ldi	%g10, %g1, 24
	addi	%g10, %g10, 1
	ldi	%g6, %g1, 20
	addi	%g4, %g6, 2
	addi	%g3, %g0, 5
	jlt	%g4, %g3, jle_else.44323
	subi	%g3, %g4, 5
	jmp	jle_cont.44324
jle_else.44323:
	mov	%g3, %g4
jle_cont.44324:
	ldi	%g8, %g1, 4
	ldi	%g7, %g1, 12
	ldi	%g9, %g1, 8
	mov	%g27, %g8
	mov	%g8, %g9
	mov	%g9, %g7
	mov	%g7, %g27
	jmp	scan_line.2992

!==============================
! args = [%g10, %g9]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g2, %g14, %g13, %g12, %g11, %g10, %f16, %f15, %f0, %dummy]
! ret type = Array((Array(Float) * Array(Array(Float)) * Array(Int) * Array(Bool) * Array(Array(Float)) * Array(Array(Float)) * Array(Int) * Array(Array(Float))))
!================================
init_line_elements.3002:
	jlt	%g9, %g0, jge_else.44325
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	mov	%g13, %g3
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g4, %g3
	addi	%g3, %g0, 5
	call	min_caml_create_array
	mov	%g8, %g3
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g8, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g8, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g8, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g8, -16
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	call	min_caml_create_array
	mov	%g12, %g3
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	call	min_caml_create_array
	mov	%g11, %g3
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g4, %g3
	addi	%g3, %g0, 5
	call	min_caml_create_array
	mov	%g7, %g3
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g7, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g7, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g7, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g7, -16
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g4, %g3
	addi	%g3, %g0, 5
	call	min_caml_create_array
	mov	%g6, %g3
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g6, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g6, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g6, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g6, -16
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	call	min_caml_create_array
	mov	%g14, %g3
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	mov	%g4, %g3
	addi	%g3, %g0, 5
	call	min_caml_create_array
	mov	%g5, %g3
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g5, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g5, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	sti	%g3, %g5, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	sti	%g3, %g5, -16
	mov	%g3, %g2
	addi	%g2, %g2, 32
	sti	%g5, %g3, -28
	sti	%g14, %g3, -24
	sti	%g6, %g3, -20
	sti	%g7, %g3, -16
	sti	%g11, %g3, -12
	sti	%g12, %g3, -8
	sti	%g8, %g3, -4
	sti	%g13, %g3, 0
	slli	%g4, %g9, 2
	st	%g3, %g10, %g4
	subi	%g9, %g9, 1
	jmp	init_line_elements.3002
jge_else.44325:
	mov	%g3, %g10
	return

!==============================
! args = [%g4, %g5, %g3]
! fargs = [%f5, %f1, %f2, %f0]
! use_regs = [%g7, %g6, %g5, %g4, %g3, %g27, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f3, %f28, %f26, %f25, %f24, %f23, %f22, %f20, %f2, %f17, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
calc_dirvec.3010:
	fsti	%f0, %g1, 0
	fsti	%f2, %g1, 4
	addi	%g6, %g0, 5
	jlt	%g4, %g6, jle_else.44326
	fmul	%f2, %f5, %f5
	fmul	%f0, %f1, %f1
	fadd	%f0, %f2, %f0
	fadd	%f0, %f0, %f17
	fsqrt	%f0, %f0
	fdiv	%f2, %f5, %f0
	fdiv	%f1, %f1, %f0
	fdiv	%f0, %f17, %f0
	slli	%g4, %g5, 2
	add	%g4, %g31, %g4
	ldi	%g5, %g4, 716
	slli	%g4, %g3, 2
	ld	%g4, %g5, %g4
	ldi	%g4, %g4, 0
	fsti	%f2, %g4, 0
	fsti	%f1, %g4, -4
	fsti	%f0, %g4, -8
	addi	%g4, %g3, 40
	slli	%g4, %g4, 2
	ld	%g4, %g5, %g4
	ldi	%g4, %g4, 0
	fneg	%f4, %f1
	fsti	%f2, %g4, 0
	fsti	%f0, %g4, -4
	fsti	%f4, %g4, -8
	addi	%g4, %g3, 80
	slli	%g4, %g4, 2
	ld	%g4, %g5, %g4
	ldi	%g4, %g4, 0
	fneg	%f3, %f2
	fsti	%f0, %g4, 0
	fsti	%f3, %g4, -4
	fsti	%f4, %g4, -8
	addi	%g4, %g3, 1
	slli	%g4, %g4, 2
	ld	%g4, %g5, %g4
	ldi	%g4, %g4, 0
	fneg	%f0, %f0
	fsti	%f3, %g4, 0
	fsti	%f4, %g4, -4
	fsti	%f0, %g4, -8
	addi	%g4, %g3, 41
	slli	%g4, %g4, 2
	ld	%g4, %g5, %g4
	ldi	%g4, %g4, 0
	fsti	%f3, %g4, 0
	fsti	%f0, %g4, -4
	fsti	%f1, %g4, -8
	addi	%g3, %g3, 81
	slli	%g3, %g3, 2
	ld	%g3, %g5, %g3
	ldi	%g3, %g3, 0
	fsti	%f0, %g3, 0
	fsti	%f2, %g3, -4
	fsti	%f1, %g3, -8
	return
jle_else.44326:
	fmul	%f0, %f1, %f1
	setL %g6, l.36040
	fldi	%f6, %g6, 0
	fadd	%f0, %f0, %f6
	fsqrt	%f5, %f0
	fdiv	%f0, %f17, %f5
	fjlt	%f17, %f0, fjge_else.44328
	fjlt	%f0, %f20, fjge_else.44330
	addi	%g6, %g0, 0
	jmp	fjge_cont.44331
fjge_else.44330:
	addi	%g6, %g0, -1
fjge_cont.44331:
	jmp	fjge_cont.44329
fjge_else.44328:
	addi	%g6, %g0, 1
fjge_cont.44329:
	jne	%g6, %g0, jeq_else.44332
	fmov	%f4, %f0
	jmp	jeq_cont.44333
jeq_else.44332:
	fdiv	%f4, %f17, %f0
jeq_cont.44333:
	fmul	%f0, %f4, %f4
	setL %g7, l.37902
	fldi	%f14, %g7, 0
	fmul	%f1, %f14, %f0
	setL %g7, l.37904
	fldi	%f15, %g7, 0
	fdiv	%f3, %f1, %f15
	setL %g7, l.37906
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 8
	fldi	%f1, %g1, 8
	fmul	%f2, %f1, %f0
	setL %g7, l.37908
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 12
	fldi	%f1, %g1, 12
	fadd	%f1, %f1, %f3
	fdiv	%f1, %f2, %f1
	setL %g7, l.37910
	fldi	%f11, %g7, 0
	fmul	%f2, %f11, %f0
	setL %g7, l.37912
	fldi	%f13, %g7, 0
	fadd	%f1, %f13, %f1
	fdiv	%f2, %f2, %f1
	setL %g7, l.37914
	fldi	%f12, %g7, 0
	fmul	%f3, %f12, %f0
	setL %g7, l.37916
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 16
	fldi	%f1, %g1, 16
	fadd	%f1, %f1, %f2
	fdiv	%f1, %f3, %f1
	setL %g7, l.37918
	fldi	%f9, %g7, 0
	fmul	%f2, %f9, %f0
	fadd	%f1, %f28, %f1
	fdiv	%f2, %f2, %f1
	setL %g7, l.37921
	fldi	%f10, %g7, 0
	fmul	%f3, %f10, %f0
	setL %g7, l.37923
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 20
	fldi	%f1, %g1, 20
	fadd	%f1, %f1, %f2
	fdiv	%f2, %f3, %f1
	setL %g7, l.37933
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 24
	setL %g7, l.37925
	fldi	%f8, %g7, 0
	fmul	%f3, %f8, %f0
	setL %g7, l.37927
	fldi	%f1, %g7, 0
	fsti	%f1, %g1, 28
	fldi	%f1, %g1, 28
	fadd	%f1, %f1, %f2
	fdiv	%f1, %f3, %f1
	setL %g7, l.37929
	fldi	%f7, %g7, 0
	fmul	%f2, %f7, %f0
	fadd	%f1, %f25, %f1
	fdiv	%f1, %f2, %f1
	fmul	%f2, %f25, %f0
	fadd	%f1, %f26, %f1
	fdiv	%f2, %f2, %f1
	fldi	%f1, %g1, 24
	fmul	%f3, %f1, %f0
	fadd	%f1, %f24, %f2
	fdiv	%f1, %f3, %f1
	fadd	%f1, %f23, %f1
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f4, %f0
	jlt	%g0, %g6, jle_else.44334
	jlt	%g6, %g0, jge_else.44336
	fmov	%f0, %f1
	jmp	jge_cont.44337
jge_else.44336:
	fsub	%f0, %f31, %f1
jge_cont.44337:
	jmp	jle_cont.44335
jle_else.44334:
	fsub	%f0, %f22, %f1
jle_cont.44335:
	fldi	%f1, %g1, 4
	fmul	%f1, %f0, %f1
	fmul	%f0, %f1, %f1
	fdiv	%f2, %f0, %f25
	fsub	%f2, %f26, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f24, %f2
	fdiv	%f2, %f0, %f2
	fsub	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fsub	%f0, %f17, %f0
	fdiv	%f0, %f1, %f0
	fmul	%f5, %f0, %f5
	addi	%g4, %g4, 1
	fmul	%f0, %f5, %f5
	fadd	%f0, %f0, %f6
	fsqrt	%f6, %f0
	fdiv	%f0, %f17, %f6
	fjlt	%f17, %f0, fjge_else.44338
	fjlt	%f0, %f20, fjge_else.44340
	addi	%g6, %g0, 0
	jmp	fjge_cont.44341
fjge_else.44340:
	addi	%g6, %g0, -1
fjge_cont.44341:
	jmp	fjge_cont.44339
fjge_else.44338:
	addi	%g6, %g0, 1
fjge_cont.44339:
	jne	%g6, %g0, jeq_else.44342
	fmov	%f1, %f0
	jmp	jeq_cont.44343
jeq_else.44342:
	fdiv	%f1, %f17, %f0
jeq_cont.44343:
	fmul	%f0, %f1, %f1
	fmul	%f2, %f14, %f0
	fdiv	%f3, %f2, %f15
	fldi	%f2, %g1, 8
	fmul	%f4, %f2, %f0
	fldi	%f2, %g1, 12
	fadd	%f2, %f2, %f3
	fdiv	%f2, %f4, %f2
	fmul	%f3, %f11, %f0
	fadd	%f2, %f13, %f2
	fdiv	%f3, %f3, %f2
	fmul	%f4, %f12, %f0
	fldi	%f2, %g1, 16
	fadd	%f2, %f2, %f3
	fdiv	%f2, %f4, %f2
	fmul	%f3, %f9, %f0
	fadd	%f2, %f28, %f2
	fdiv	%f2, %f3, %f2
	fmul	%f3, %f10, %f0
	fldi	%f4, %g1, 20
	fadd	%f2, %f4, %f2
	fdiv	%f2, %f3, %f2
	fmul	%f4, %f8, %f0
	fldi	%f3, %g1, 28
	fadd	%f2, %f3, %f2
	fdiv	%f2, %f4, %f2
	fmul	%f3, %f7, %f0
	fadd	%f2, %f25, %f2
	fdiv	%f2, %f3, %f2
	fmul	%f3, %f25, %f0
	fadd	%f2, %f26, %f2
	fdiv	%f2, %f3, %f2
	fldi	%f3, %g1, 24
	fmul	%f3, %f3, %f0
	fadd	%f2, %f24, %f2
	fdiv	%f2, %f3, %f2
	fadd	%f2, %f23, %f2
	fdiv	%f0, %f0, %f2
	fadd	%f0, %f17, %f0
	fdiv	%f1, %f1, %f0
	jlt	%g0, %g6, jle_else.44344
	jlt	%g6, %g0, jge_else.44346
	fmov	%f0, %f1
	jmp	jge_cont.44347
jge_else.44346:
	fsub	%f0, %f31, %f1
jge_cont.44347:
	jmp	jle_cont.44345
jle_else.44344:
	fsub	%f0, %f22, %f1
jle_cont.44345:
	fldi	%f1, %g1, 0
	fmul	%f0, %f0, %f1
	fmul	%f2, %f0, %f0
	fdiv	%f1, %f2, %f25
	fsub	%f1, %f26, %f1
	fdiv	%f1, %f2, %f1
	fsub	%f1, %f24, %f1
	fdiv	%f1, %f2, %f1
	fsub	%f1, %f23, %f1
	fdiv	%f1, %f2, %f1
	fsub	%f1, %f17, %f1
	fdiv	%f0, %f0, %f1
	fmul	%f1, %f0, %f6
	fldi	%f2, %g1, 4
	fldi	%f0, %g1, 0
	jmp	calc_dirvec.3010

!==============================
! args = [%g10, %g9, %g8]
! fargs = [%f0]
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f3, %f28, %f26, %f25, %f24, %f23, %f22, %f20, %f2, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
calc_dirvecs.3018:
	jlt	%g10, %g0, jge_else.44348
	fsti	%f0, %g1, 0
	mov	%g3, %g10
	subi	%g1, %g1, 8
	call	min_caml_float_of_int
	addi	%g1, %g1, 8
	fmov	%f1, %f0
	setL %g3, l.36036
	fldi	%f5, %g3, 0
	fmul	%f1, %f1, %f5
	setL %g3, l.36038
	fldi	%f4, %g3, 0
	fsub	%f2, %f1, %f4
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f4, %g1, 4
	fsti	%f5, %g1, 8
	fsti	%f1, %g1, 12
	mov	%g3, %g8
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 20
	call	calc_dirvec.3010
	addi	%g1, %g1, 20
	setL %g3, l.36040
	fldi	%f3, %g3, 0
	fldi	%f1, %g1, 12
	fadd	%f2, %f1, %f3
	addi	%g4, %g0, 0
	addi	%g11, %g8, 2
	fldi	%f0, %g1, 0
	fsti	%f3, %g1, 16
	mov	%g3, %g11
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 24
	call	calc_dirvec.3010
	addi	%g1, %g1, 24
	subi	%g10, %g10, 1
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.44349
	subi	%g9, %g3, 5
	jmp	jle_cont.44350
jle_else.44349:
	mov	%g9, %g3
jle_cont.44350:
	jlt	%g10, %g0, jge_else.44351
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	min_caml_float_of_int
	addi	%g1, %g1, 24
	fmov	%f1, %f0
	fldi	%f5, %g1, 8
	fmul	%f1, %f1, %f5
	fldi	%f4, %g1, 4
	fsub	%f2, %f1, %f4
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f1, %g1, 20
	mov	%g3, %g8
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 28
	call	calc_dirvec.3010
	addi	%g1, %g1, 28
	fldi	%f3, %g1, 16
	fldi	%f1, %g1, 20
	fadd	%f2, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	mov	%g3, %g11
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 28
	call	calc_dirvec.3010
	addi	%g1, %g1, 28
	subi	%g10, %g10, 1
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.44352
	subi	%g9, %g3, 5
	jmp	jle_cont.44353
jle_else.44352:
	mov	%g9, %g3
jle_cont.44353:
	jlt	%g10, %g0, jge_else.44354
	mov	%g3, %g10
	subi	%g1, %g1, 28
	call	min_caml_float_of_int
	addi	%g1, %g1, 28
	fmov	%f1, %f0
	fldi	%f5, %g1, 8
	fmul	%f1, %f1, %f5
	fldi	%f4, %g1, 4
	fsub	%f2, %f1, %f4
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f1, %g1, 24
	mov	%g3, %g8
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 32
	call	calc_dirvec.3010
	addi	%g1, %g1, 32
	fldi	%f3, %g1, 16
	fldi	%f1, %g1, 24
	fadd	%f2, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	mov	%g3, %g11
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 32
	call	calc_dirvec.3010
	addi	%g1, %g1, 32
	subi	%g10, %g10, 1
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.44355
	subi	%g9, %g3, 5
	jmp	jle_cont.44356
jle_else.44355:
	mov	%g9, %g3
jle_cont.44356:
	jlt	%g10, %g0, jge_else.44357
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	fmov	%f1, %f0
	fldi	%f5, %g1, 8
	fmul	%f1, %f1, %f5
	fldi	%f4, %g1, 4
	fsub	%f2, %f1, %f4
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f1, %g1, 28
	mov	%g3, %g8
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 36
	call	calc_dirvec.3010
	addi	%g1, %g1, 36
	fldi	%f3, %g1, 16
	fldi	%f1, %g1, 28
	fadd	%f2, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	mov	%g3, %g11
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 36
	call	calc_dirvec.3010
	addi	%g1, %g1, 36
	subi	%g10, %g10, 1
	addi	%g4, %g9, 1
	addi	%g3, %g0, 5
	jlt	%g4, %g3, jle_else.44358
	subi	%g3, %g4, 5
	jmp	jle_cont.44359
jle_else.44358:
	mov	%g3, %g4
jle_cont.44359:
	fldi	%f0, %g1, 0
	mov	%g9, %g3
	jmp	calc_dirvecs.3018
jge_else.44357:
	return
jge_else.44354:
	return
jge_else.44351:
	return
jge_else.44348:
	return

!==============================
! args = [%g13, %g12, %g8]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g14, %g13, %g12, %g11, %g10, %f9, %f8, %f7, %f6, %f5, %f4, %f31, %f3, %f28, %f26, %f25, %f24, %f23, %f22, %f20, %f2, %f17, %f16, %f15, %f14, %f13, %f12, %f11, %f10, %f1, %f0, %dummy]
! ret type = Unit
!================================
calc_dirvec_rows.3023:
	jlt	%g13, %g0, jge_else.44364
	mov	%g3, %g13
	subi	%g1, %g1, 4
	call	min_caml_float_of_int
	addi	%g1, %g1, 4
	setL %g3, l.36036
	fldi	%f4, %g3, 0
	fmul	%f0, %f0, %f4
	setL %g3, l.36038
	fldi	%f3, %g3, 0
	fsub	%f0, %f0, %f3
	addi	%g3, %g0, 4
	fsti	%f0, %g1, 0
	subi	%g1, %g1, 8
	call	min_caml_float_of_int
	addi	%g1, %g1, 8
	fmov	%f1, %f0
	fmul	%f1, %f1, %f4
	fsub	%f10, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f10, %g1, 4
	fsti	%f3, %g1, 8
	fsti	%f4, %g1, 12
	fsti	%f1, %g1, 16
	mov	%g3, %g8
	mov	%g5, %g12
	fmov	%f2, %f10
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 24
	call	calc_dirvec.3010
	addi	%g1, %g1, 24
	setL %g3, l.36040
	fldi	%f5, %g3, 0
	fldi	%f1, %g1, 16
	fadd	%f9, %f1, %f5
	addi	%g4, %g0, 0
	addi	%g10, %g8, 2
	fldi	%f0, %g1, 0
	fsti	%f9, %g1, 20
	fsti	%f5, %g1, 24
	mov	%g3, %g10
	mov	%g5, %g12
	fmov	%f2, %f9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 32
	call	calc_dirvec.3010
	addi	%g1, %g1, 32
	addi	%g6, %g0, 3
	addi	%g3, %g12, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.44365
	subi	%g9, %g3, 5
	jmp	jle_cont.44366
jle_else.44365:
	mov	%g9, %g3
jle_cont.44366:
	mov	%g3, %g6
	subi	%g1, %g1, 32
	call	min_caml_float_of_int
	addi	%g1, %g1, 32
	fmov	%f1, %f0
	fldi	%f4, %g1, 12
	fmul	%f1, %f1, %f4
	fldi	%f3, %g1, 8
	fsub	%f8, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f8, %g1, 28
	fsti	%f1, %g1, 32
	mov	%g3, %g8
	mov	%g5, %g9
	fmov	%f2, %f8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 40
	call	calc_dirvec.3010
	addi	%g1, %g1, 40
	fldi	%f5, %g1, 24
	fldi	%f1, %g1, 32
	fadd	%f7, %f1, %f5
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f7, %g1, 36
	mov	%g3, %g10
	mov	%g5, %g9
	fmov	%f2, %f7
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 44
	call	calc_dirvec.3010
	addi	%g1, %g1, 44
	addi	%g6, %g0, 2
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.44367
	subi	%g9, %g3, 5
	jmp	jle_cont.44368
jle_else.44367:
	mov	%g9, %g3
jle_cont.44368:
	mov	%g3, %g6
	subi	%g1, %g1, 44
	call	min_caml_float_of_int
	addi	%g1, %g1, 44
	fmov	%f1, %f0
	fldi	%f4, %g1, 12
	fmul	%f1, %f1, %f4
	fldi	%f3, %g1, 8
	fsub	%f6, %f1, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f6, %g1, 40
	fsti	%f1, %g1, 44
	mov	%g3, %g8
	mov	%g5, %g9
	fmov	%f2, %f6
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 52
	call	calc_dirvec.3010
	addi	%g1, %g1, 52
	fldi	%f5, %g1, 24
	fldi	%f1, %g1, 44
	fadd	%f2, %f1, %f5
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f2, %g1, 48
	mov	%g3, %g10
	mov	%g5, %g9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 56
	call	calc_dirvec.3010
	addi	%g1, %g1, 56
	addi	%g6, %g0, 1
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.44369
	subi	%g9, %g3, 5
	jmp	jle_cont.44370
jle_else.44369:
	mov	%g9, %g3
jle_cont.44370:
	mov	%g3, %g6
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
	fmov	%f1, %f0
	fldi	%f4, %g1, 12
	fmul	%f11, %f1, %f4
	fldi	%f3, %g1, 8
	fsub	%f1, %f11, %f3
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	fsti	%f11, %g1, 52
	mov	%g3, %g8
	mov	%g5, %g9
	fmov	%f2, %f1
	fmov	%f5, %f16
	fmov	%f1, %f16
	subi	%g1, %g1, 60
	call	calc_dirvec.3010
	addi	%g1, %g1, 60
	fldi	%f5, %g1, 24
	fldi	%f11, %g1, 52
	fadd	%f1, %f11, %f5
	addi	%g4, %g0, 0
	fldi	%f0, %g1, 0
	mov	%g3, %g10
	mov	%g5, %g9
	fmov	%f2, %f1
	fmov	%f5, %f16
	fmov	%f1, %f16
	subi	%g1, %g1, 60
	call	calc_dirvec.3010
	addi	%g1, %g1, 60
	addi	%g10, %g0, 0
	addi	%g3, %g9, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.44371
	subi	%g9, %g3, 5
	jmp	jle_cont.44372
jle_else.44371:
	mov	%g9, %g3
jle_cont.44372:
	fldi	%f0, %g1, 0
	sti	%g8, %g1, 56
	subi	%g1, %g1, 64
	call	calc_dirvecs.3018
	addi	%g1, %g1, 64
	subi	%g14, %g13, 1
	addi	%g3, %g12, 2
	addi	%g12, %g0, 5
	jlt	%g3, %g12, jle_else.44373
	subi	%g12, %g3, 5
	jmp	jle_cont.44374
jle_else.44373:
	mov	%g12, %g3
jle_cont.44374:
	ldi	%g8, %g1, 56
	addi	%g13, %g8, 4
	jlt	%g14, %g0, jge_else.44375
	mov	%g3, %g14
	subi	%g1, %g1, 64
	call	min_caml_float_of_int
	addi	%g1, %g1, 64
	fldi	%f4, %g1, 12
	fmul	%f0, %f0, %f4
	fldi	%f3, %g1, 8
	fsub	%f0, %f0, %f3
	addi	%g4, %g0, 0
	fldi	%f10, %g1, 4
	fsti	%f0, %g1, 60
	mov	%g3, %g13
	mov	%g5, %g12
	fmov	%f2, %f10
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 68
	call	calc_dirvec.3010
	addi	%g1, %g1, 68
	addi	%g4, %g0, 0
	addi	%g8, %g13, 2
	fldi	%f9, %g1, 20
	fldi	%f0, %g1, 60
	mov	%g3, %g8
	mov	%g5, %g12
	fmov	%f2, %f9
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 68
	call	calc_dirvec.3010
	addi	%g1, %g1, 68
	addi	%g3, %g12, 1
	addi	%g5, %g0, 5
	jlt	%g3, %g5, jle_else.44376
	subi	%g5, %g3, 5
	jmp	jle_cont.44377
jle_else.44376:
	mov	%g5, %g3
jle_cont.44377:
	addi	%g4, %g0, 0
	fldi	%f8, %g1, 28
	fldi	%f0, %g1, 60
	sti	%g5, %g1, 64
	mov	%g3, %g13
	fmov	%f2, %f8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 72
	call	calc_dirvec.3010
	addi	%g1, %g1, 72
	addi	%g4, %g0, 0
	fldi	%f7, %g1, 36
	fldi	%f0, %g1, 60
	ldi	%g5, %g1, 64
	mov	%g3, %g8
	fmov	%f2, %f7
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 72
	call	calc_dirvec.3010
	addi	%g1, %g1, 72
	ldi	%g5, %g1, 64
	addi	%g3, %g5, 1
	addi	%g5, %g0, 5
	jlt	%g3, %g5, jle_else.44378
	subi	%g5, %g3, 5
	jmp	jle_cont.44379
jle_else.44378:
	mov	%g5, %g3
jle_cont.44379:
	addi	%g4, %g0, 0
	fldi	%f6, %g1, 40
	fldi	%f0, %g1, 60
	sti	%g5, %g1, 68
	mov	%g3, %g13
	fmov	%f2, %f6
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 76
	call	calc_dirvec.3010
	addi	%g1, %g1, 76
	addi	%g4, %g0, 0
	fldi	%f2, %g1, 48
	fldi	%f0, %g1, 60
	ldi	%g5, %g1, 68
	mov	%g3, %g8
	fmov	%f1, %f16
	fmov	%f5, %f16
	subi	%g1, %g1, 76
	call	calc_dirvec.3010
	addi	%g1, %g1, 76
	addi	%g10, %g0, 1
	ldi	%g5, %g1, 68
	addi	%g3, %g5, 1
	addi	%g9, %g0, 5
	jlt	%g3, %g9, jle_else.44380
	subi	%g9, %g3, 5
	jmp	jle_cont.44381
jle_else.44380:
	mov	%g9, %g3
jle_cont.44381:
	fldi	%f0, %g1, 60
	mov	%g8, %g13
	subi	%g1, %g1, 76
	call	calc_dirvecs.3018
	addi	%g1, %g1, 76
	subi	%g4, %g14, 1
	addi	%g3, %g12, 2
	addi	%g12, %g0, 5
	jlt	%g3, %g12, jle_else.44382
	subi	%g12, %g3, 5
	jmp	jle_cont.44383
jle_else.44382:
	mov	%g12, %g3
jle_cont.44383:
	addi	%g8, %g13, 4
	mov	%g13, %g4
	jmp	calc_dirvec_rows.3023
jge_else.44375:
	return
jge_else.44364:
	return

!==============================
! args = [%g6, %g7]
! fargs = []
! use_regs = [%g7, %g6, %g5, %g4, %g3, %g27, %g2, %f16, %f15, %f0, %dummy]
! ret type = Unit
!================================
create_dirvec_elements.3029:
	jlt	%g7, %g0, jge_else.44386
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 0
	sti	%g4, %g3, 0
	slli	%g4, %g7, 2
	st	%g3, %g6, %g4
	subi	%g7, %g7, 1
	jlt	%g7, %g0, jge_else.44387
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 4
	subi	%g1, %g1, 12
	call	min_caml_create_array
	addi	%g1, %g1, 12
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 4
	sti	%g4, %g3, 0
	slli	%g4, %g7, 2
	st	%g3, %g6, %g4
	subi	%g7, %g7, 1
	jlt	%g7, %g0, jge_else.44388
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 12
	call	min_caml_create_float_array
	addi	%g1, %g1, 12
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 8
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 8
	sti	%g4, %g3, 0
	slli	%g4, %g7, 2
	st	%g3, %g6, %g4
	subi	%g7, %g7, 1
	jlt	%g7, %g0, jge_else.44389
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 12
	subi	%g1, %g1, 20
	call	min_caml_create_array
	addi	%g1, %g1, 20
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 12
	sti	%g4, %g3, 0
	slli	%g4, %g7, 2
	st	%g3, %g6, %g4
	subi	%g7, %g7, 1
	jmp	create_dirvec_elements.3029
jge_else.44389:
	return
jge_else.44388:
	return
jge_else.44387:
	return
jge_else.44386:
	return

!==============================
! args = [%g8]
! fargs = []
! use_regs = [%g8, %g7, %g6, %g5, %g4, %g3, %g27, %g2, %f16, %f15, %f0, %dummy]
! ret type = Unit
!================================
create_dirvecs.3032:
	jlt	%g8, %g0, jge_else.44394
	addi	%g6, %g0, 120
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 4
	call	min_caml_create_float_array
	addi	%g1, %g1, 4
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 0
	sti	%g4, %g3, 0
	mov	%g4, %g3
	mov	%g3, %g6
	subi	%g1, %g1, 8
	call	min_caml_create_array
	slli	%g4, %g8, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 716
	slli	%g3, %g8, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 716
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 4
	subi	%g1, %g1, 12
	call	min_caml_create_array
	addi	%g1, %g1, 12
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 4
	sti	%g4, %g3, 0
	sti	%g3, %g6, -472
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 12
	call	min_caml_create_float_array
	addi	%g1, %g1, 12
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 8
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 8
	sti	%g4, %g3, 0
	sti	%g3, %g6, -468
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 12
	subi	%g1, %g1, 20
	call	min_caml_create_array
	addi	%g1, %g1, 20
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 12
	sti	%g4, %g3, 0
	sti	%g3, %g6, -464
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 20
	call	min_caml_create_float_array
	addi	%g1, %g1, 20
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 16
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 16
	sti	%g4, %g3, 0
	sti	%g3, %g6, -460
	addi	%g7, %g0, 114
	subi	%g1, %g1, 24
	call	create_dirvec_elements.3029
	addi	%g1, %g1, 24
	subi	%g8, %g8, 1
	jlt	%g8, %g0, jge_else.44395
	addi	%g6, %g0, 120
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 24
	call	min_caml_create_float_array
	addi	%g1, %g1, 24
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 20
	subi	%g1, %g1, 28
	call	min_caml_create_array
	addi	%g1, %g1, 28
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 20
	sti	%g4, %g3, 0
	mov	%g4, %g3
	mov	%g3, %g6
	subi	%g1, %g1, 28
	call	min_caml_create_array
	slli	%g4, %g8, 2
	add	%g4, %g31, %g4
	sti	%g3, %g4, 716
	slli	%g3, %g8, 2
	add	%g3, %g31, %g3
	ldi	%g6, %g3, 716
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	call	min_caml_create_float_array
	addi	%g1, %g1, 28
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 24
	subi	%g1, %g1, 32
	call	min_caml_create_array
	addi	%g1, %g1, 32
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 24
	sti	%g4, %g3, 0
	sti	%g3, %g6, -472
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 32
	call	min_caml_create_float_array
	addi	%g1, %g1, 32
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 28
	subi	%g1, %g1, 36
	call	min_caml_create_array
	addi	%g1, %g1, 36
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 28
	sti	%g4, %g3, 0
	sti	%g3, %g6, -468
	addi	%g3, %g0, 3
	fmov	%f0, %f16
	subi	%g1, %g1, 36
	call	min_caml_create_float_array
	addi	%g1, %g1, 36
	mov	%g4, %g3
	ldi	%g3, %g31, 28
	sti	%g4, %g1, 32
	subi	%g1, %g1, 40
	call	min_caml_create_array
	addi	%g1, %g1, 40
	mov	%g5, %g3
	mov	%g3, %g2
	addi	%g2, %g2, 8
	sti	%g5, %g3, -4
	ldi	%g4, %g1, 32
	sti	%g4, %g3, 0
	sti	%g3, %g6, -464
	addi	%g7, %g0, 115
	subi	%g1, %g1, 40
	call	create_dirvec_elements.3029
	addi	%g1, %g1, 40
	subi	%g8, %g8, 1
	jmp	create_dirvecs.3032
jge_else.44395:
	return
jge_else.44394:
	return

!==============================
! args = [%g11, %g12]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g12, %g11, %g10, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f20, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
init_dirvec_constants.3034:
	jlt	%g12, %g0, jge_else.44398
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2818
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.44399
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2818
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.44400
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2818
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.44401
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2818
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.44402
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2818
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.44403
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2818
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.44404
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2818
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.44405
	slli	%g3, %g12, 2
	ld	%g3, %g11, %g3
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2818
	addi	%g1, %g1, 4
	subi	%g12, %g12, 1
	jmp	init_dirvec_constants.3034
jge_else.44405:
	return
jge_else.44404:
	return
jge_else.44403:
	return
jge_else.44402:
	return
jge_else.44401:
	return
jge_else.44400:
	return
jge_else.44399:
	return
jge_else.44398:
	return

!==============================
! args = [%g13]
! fargs = []
! use_regs = [%g9, %g8, %g7, %g6, %g5, %g4, %g3, %g27, %g13, %g12, %g11, %g10, %f8, %f7, %f6, %f5, %f4, %f3, %f21, %f20, %f2, %f17, %f16, %f15, %f1, %f0, %dummy]
! ret type = Unit
!================================
init_vecset_constants.3037:
	jlt	%g13, %g0, jge_else.44414
	slli	%g3, %g13, 2
	add	%g3, %g31, %g3
	ldi	%g11, %g3, 716
	ldi	%g3, %g11, -476
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -472
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -468
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -464
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -460
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -456
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -452
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -448
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	addi	%g12, %g0, 111
	call	init_dirvec_constants.3034
	addi	%g1, %g1, 4
	subi	%g13, %g13, 1
	jlt	%g13, %g0, jge_else.44415
	slli	%g3, %g13, 2
	add	%g3, %g31, %g3
	ldi	%g11, %g3, 716
	ldi	%g3, %g11, -476
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	subi	%g1, %g1, 4
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -472
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -468
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -464
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -460
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -456
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	ldi	%g3, %g11, -452
	ldi	%g4, %g31, 28
	subi	%g5, %g4, 1
	ldi	%g6, %g3, -4
	ldi	%g7, %g3, 0
	call	iter_setup_dirvec_constants.2818
	addi	%g12, %g0, 112
	call	init_dirvec_constants.3034
	addi	%g1, %g1, 4
	subi	%g13, %g13, 1
	jmp	init_vecset_constants.3037
jge_else.44415:
	return
jge_else.44414:
	return
