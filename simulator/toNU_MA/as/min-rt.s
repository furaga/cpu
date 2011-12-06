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
l.37377:	! 150.000000
	.long	0x43160000
l.37258:	! -150.000000
	.long	0xc3160000
l.37124:	! -2.000000
	.long	0xc0000000
l.37102:	! 0.003906
	.long	0x3b800000
l.36922:	! 100000000.000000
	.long	0x4cbebc20
l.36901:	! 20.000000
	.long	0x41a00000
l.36899:	! 0.050000
	.long	0x3d4cccc4
l.36879:	! 0.250000
	.long	0x3e800000
l.36860:	! 10.000000
	.long	0x41200000
l.36849:	! 0.300000
	.long	0x3e999999
l.36845:	! 0.150000
	.long	0x3e199999
l.36810:	! 3.141593
	.long	0x40490fda
l.36808:	! 30.000000
	.long	0x41f00000
l.36806:	! -1.570796
	.long	0xbfc90fda
l.36801:	! 4.000000
	.long	0x40800000
l.36797:	! 16.000000
	.long	0x41800000
l.36795:	! 11.000000
	.long	0x41300000
l.36793:	! 25.000000
	.long	0x41c80000
l.36791:	! 13.000000
	.long	0x41500000
l.36789:	! 36.000000
	.long	0x42100000
l.36786:	! 49.000000
	.long	0x42440000
l.36784:	! 17.000000
	.long	0x41880000
l.36782:	! 64.000000
	.long	0x42800000
l.36780:	! 19.000000
	.long	0x41980000
l.36778:	! 81.000000
	.long	0x42a20000
l.36776:	! 21.000000
	.long	0x41a80000
l.36774:	! 100.000000
	.long	0x42c80000
l.36772:	! 23.000000
	.long	0x41b80000
l.36770:	! 121.000000
	.long	0x42f20000
l.36766:	! 15.000000
	.long	0x41700000
l.36764:	! 0.000100
	.long	0x38d1b70f
l.36086:	! -0.100000
	.long	0xbdccccc4
l.35938:	! 0.010000
	.long	0x3c23d70a
l.35936:	! -0.200000
	.long	0xbe4cccc4
l.35516:	! -1.000000
	.long	0xbf800000
l.34587:	! 0.100000
	.long	0x3dccccc4
l.34585:	! 0.900000
	.long	0x3f66665e
l.34583:	! 0.200000
	.long	0x3e4cccc4
l.34413:	! -200.000000
	.long	0xc3480000
l.34410:	! 200.000000
	.long	0x43480000
l.34382:	! 3.000000
	.long	0x40400000
l.34380:	! 5.000000
	.long	0x40a00000
l.34378:	! 9.000000
	.long	0x41100000
l.34376:	! 7.000000
	.long	0x40e00000
l.34374:	! 1.000000
	.long	0x3f800000
l.34372:	! 0.017453
	.long	0x3c8efa2d
l.34175:	! 128.000000
	.long	0x43000000
l.34156:	! 1000000000.000000
	.long	0x4e6e6b28
l.34152:	! 255.000000
	.long	0x437f0000
l.34138:	! 0.000000
	.long	0x0
l.34136:	! 1.570796
	.long	0x3fc90fda
l.34134:	! 0.500000
	.long	0x3f000000
l.34132:	! 6.283185
	.long	0x40c90fda
l.34130:	! 2.000000
	.long	0x40000000
l.34128:	! 3.141593
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
	jeq %g4, %g2, CREATE_FLOAT_ARRAY_END
	fst %f0, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_FLOAT_ARRAY_LOOP
CREATE_FLOAT_ARRAY_END:
	return

! * floor		%f0 + MAGICF - MAGICF
min_caml_floor:
	fmov %f1, %f0
	! %f4 = 0.0
	setL %g3, FLOAT_ZERO
	fld %f4, %g3, 0
	fjlt %f4, %f0, FLOOR_POSITIVE	! if (%f4 <= %f0) goto FLOOR_PISITIVE
	fjeq %f4, %f0, FLOOR_POSITIVE
FLOOR_NEGATIVE:
	fneg %f0, %f0
	setL %g3, FLOAT_MAGICF
	! %f2 = FLOAT_MAGICF
	fld %f2, %g3, 0
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
	fld %f3, %g3, 0
	fadd %f0, %f0, %f3
	fsub %f0, %f0, %f2
	fneg %f0, %f0
	return
FLOOR_POSITIVE:
	setL %g3, FLOAT_MAGICF
	fld %f2, %g3, 0
	fjlt %f0, %f2, FLOOR_POSITIVE_MAIN
	fjeq %f0, %f2, FLOOR_POSITIVE_MAIN
	return
FLOOR_POSITIVE_MAIN:
	fmov %f1, %f0
	fadd %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g4, %g1, 0
	fsub %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g4, %g1, 0
	fjlt %f0, %f1, FLOOR_RET
	fjeq %f0, %f1, FLOOR_RET
	setL %g3, FLOAT_ONE
	fld %f3, %g3, 0
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
	fld %f1, %g5, 0
	setL %g5, FLOAT_MAGICFHX
	ld %g4, %g5, 0
	setL %g5, FLOAT_MAGICI
	ld %g5, %g5, 0
	jlt %g5, %g3, ITOF_BIG
	jeq %g5, %g3, ITOF_BIG
	add %g3, %g3, %g4
	st %g3, %g1, 0
	fld %f0, %g1, 0
	fsub %f0, %f0, %f1
	return
ITOF_BIG:
	setL %g4, FLOAT_ZERO
	fld %f2, %g4, 0
ITOF_LOOP:
	sub %g3, %g3, %g5
	fadd %f2, %f2, %f1
	jlt %g5, %g3, ITOF_LOOP
	jeq %g5, %g3, ITOF_LOOP
	add %g3, %g3, %g4
	st %g3, %g1, 0
	fld %f0, %g1, 0
	fsub %f0, %f0, %f1
	fadd %f0, %f0, %f2
	return

! * int_of_float
min_caml_int_of_float:
	! %f1 <= 0.0
	setL %g3, FLOAT_ZERO
	fld %f1, %g3, 0
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
	fld %f2, %g4, 0
	setL %g4, FLOAT_MAGICFHX
	ld %g4, %g4, 0
	fjlt %f2, %f0, FTOI_BIG		! if (MAGICF <= %f0) goto FTOI_BIG
	fjeq %f2, %f0, FTOI_BIG
	fadd %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g3, %g1, 0
	sub %g3, %g3, %g4
	return
FTOI_BIG:
	setL %g5, FLOAT_MAGICI
	ld %g5, %g5, 0
	mov %g3, %g0
FTOI_LOOP:
	fsub %f0, %f0, %f2
	add %g3, %g3, %g5
	fjlt %f2, %f0, FTOI_LOOP
	fjeq %f2, %f0, FTOI_LOOP
	fadd %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g5, %g1, 0
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
	subi	%g1, %g1, 872
	addi	%g28, %g0, 1
	addi	%g29, %g0, -1
	setL %g26, l.34138
	fld	%f16, %g26, 0
	setL %g26, l.34374
	fld	%f17, %g26, 0
	setL %g26, l.35516
	fld	%f18, %g26, 0
	setL %g26, l.34134
	fld	%f19, %g26, 0
	setL %g26, l.34136
	fld	%f20, %g26, 0
	setL %g26, l.34382
	fld	%f21, %g26, 0
	setL %g26, l.34380
	fld	%f22, %g26, 0
	setL %g26, l.34378
	fld	%f23, %g26, 0
	setL %g26, l.34376
	fld	%f24, %g26, 0
	setL %g26, l.34152
	fld	%f25, %g26, 0
	setL %g26, l.36766
	fld	%f26, %g26, 0
	setL %g26, l.36086
	fld	%f27, %g26, 0
	setL %g26, l.34587
	fld	%f28, %g26, 0
	setL %g26, l.34156
	fld	%f29, %g26, 0
	setL %g26, l.34132
	fld	%f30, %g26, 0
	setL %g3, l.34128
	fld	%f0, %g3, 0
	fst	%f0, %g31, 864
	setL %g3, l.34130
	fld	%f1, %g3, 0
	fmov	%f10, %f30
	fst	%f10, %g31, 860
	fmov	%f11, %f19
	fmov	%f12, %f20
	fst	%f12, %g31, 856
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 4
	call	min_caml_create_array
	addi	%g1, %g1, 4
	st	%g3, %g31, 852
	addi	%g4, %g0, 1
	addi	%g10, %g0, 0
	st	%g3, %g1, 0
	mov	%g3, %g4
	mov	%g4, %g10
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	st	%g3, %g31, 848
	addi	%g4, %g0, 1
	addi	%g10, %g0, 0
	st	%g3, %g1, 4
	mov	%g3, %g4
	mov	%g4, %g10
	subi	%g1, %g1, 12
	call	min_caml_create_array
	addi	%g1, %g1, 12
	st	%g3, %g31, 844
	addi	%g4, %g0, 1
	addi	%g10, %g0, 0
	st	%g3, %g1, 8
	mov	%g3, %g4
	mov	%g4, %g10
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	st	%g3, %g31, 840
	addi	%g4, %g0, 1
	addi	%g10, %g0, 1
	st	%g3, %g1, 12
	mov	%g3, %g4
	mov	%g4, %g10
	subi	%g1, %g1, 20
	call	min_caml_create_array
	addi	%g1, %g1, 20
	st	%g3, %g31, 836
	addi	%g4, %g0, 1
	addi	%g10, %g0, 0
	st	%g3, %g1, 16
	mov	%g3, %g4
	mov	%g4, %g10
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	st	%g3, %g31, 832
	addi	%g4, %g0, 1
	addi	%g10, %g0, 0
	st	%g3, %g1, 20
	mov	%g3, %g4
	mov	%g4, %g10
	subi	%g1, %g1, 28
	call	min_caml_create_array
	addi	%g1, %g1, 28
	st	%g3, %g31, 828
	addi	%g10, %g0, 0
	fmov	%f13, %f16
	st	%g3, %g1, 24
	fst	%f0, %g1, 28
	mov	%g3, %g10
	fmov	%f0, %f13
	subi	%g1, %g1, 36
	call	min_caml_create_float_array
	addi	%g1, %g1, 36
	st	%g3, %g31, 824
	addi	%g4, %g0, 60
	addi	%g10, %g0, 0
	addi	%g11, %g0, 0
	addi	%g12, %g0, 0
	addi	%g13, %g0, 0
	addi	%g14, %g0, 0
	mov	%g15, %g2
	addi	%g2, %g2, 44
	st	%g3, %g15, -40
	st	%g3, %g15, -36
	st	%g3, %g15, -32
	st	%g3, %g15, -28
	st	%g14, %g15, -24
	st	%g3, %g15, -20
	st	%g3, %g15, -16
	st	%g13, %g15, -12
	st	%g12, %g15, -8
	st	%g11, %g15, -4
	st	%g10, %g15, 0
	mov	%g3, %g15
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 36
	call	min_caml_create_array
	addi	%g1, %g1, 36
	st	%g3, %g31, 820
	addi	%g10, %g0, 3
	st	%g3, %g1, 32
	mov	%g3, %g10
	fmov	%f0, %f13
	subi	%g1, %g1, 40
	call	min_caml_create_float_array
	addi	%g1, %g1, 40
	st	%g3, %g31, 816
	addi	%g10, %g0, 3
	st	%g3, %g1, 36
	mov	%g3, %g10
	fmov	%f0, %f13
	subi	%g1, %g1, 44
	call	min_caml_create_float_array
	addi	%g1, %g1, 44
	st	%g3, %g31, 812
	addi	%g10, %g0, 3
	st	%g3, %g1, 40
	mov	%g3, %g10
	fmov	%f0, %f13
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	st	%g3, %g31, 808
	addi	%g10, %g0, 1
	fmov	%f0, %f25
	st	%g3, %g1, 44
	mov	%g3, %g10
	subi	%g1, %g1, 52
	call	min_caml_create_float_array
	addi	%g1, %g1, 52
	st	%g3, %g31, 804
	addi	%g4, %g0, 50
	addi	%g10, %g0, 1
	addi	%g11, %g0, -1
	st	%g3, %g1, 48
	st	%g4, %g1, 52
	mov	%g4, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 60
	call	min_caml_create_array
	addi	%g1, %g1, 60
	ld	%g4, %g1, 52
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 60
	call	min_caml_create_array
	addi	%g1, %g1, 60
	st	%g3, %g31, 800
	addi	%g4, %g0, 1
	addi	%g10, %g0, 1
	ld	%g11, %g3, 0
	st	%g3, %g1, 56
	st	%g4, %g1, 60
	mov	%g4, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 68
	call	min_caml_create_array
	addi	%g1, %g1, 68
	ld	%g4, %g1, 60
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 68
	call	min_caml_create_array
	addi	%g1, %g1, 68
	st	%g3, %g31, 796
	addi	%g10, %g0, 1
	st	%g3, %g1, 64
	mov	%g3, %g10
	fmov	%f0, %f13
	subi	%g1, %g1, 72
	call	min_caml_create_float_array
	addi	%g1, %g1, 72
	st	%g3, %g31, 792
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 72
	call	min_caml_create_array
	addi	%g1, %g1, 72
	st	%g3, %g31, 788
	addi	%g3, %g0, 1
	fmov	%f0, %f29
	subi	%g1, %g1, 72
	call	min_caml_create_float_array
	addi	%g1, %g1, 72
	st	%g3, %g31, 784
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 72
	call	min_caml_create_float_array
	addi	%g1, %g1, 72
	st	%g3, %g31, 780
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 72
	call	min_caml_create_array
	addi	%g1, %g1, 72
	st	%g3, %g31, 776
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 72
	call	min_caml_create_float_array
	addi	%g1, %g1, 72
	st	%g3, %g31, 772
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 72
	call	min_caml_create_float_array
	addi	%g1, %g1, 72
	st	%g3, %g31, 768
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 72
	call	min_caml_create_float_array
	addi	%g1, %g1, 72
	st	%g3, %g31, 764
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 72
	call	min_caml_create_float_array
	addi	%g1, %g1, 72
	st	%g3, %g31, 760
	addi	%g3, %g0, 2
	addi	%g4, %g0, 0
	subi	%g1, %g1, 72
	call	min_caml_create_array
	addi	%g1, %g1, 72
	st	%g3, %g31, 756
	addi	%g4, %g0, 2
	addi	%g10, %g0, 0
	st	%g3, %g1, 68
	mov	%g3, %g4
	mov	%g4, %g10
	subi	%g1, %g1, 76
	call	min_caml_create_array
	addi	%g1, %g1, 76
	st	%g3, %g31, 752
	addi	%g10, %g0, 1
	st	%g3, %g1, 72
	mov	%g3, %g10
	fmov	%f0, %f13
	subi	%g1, %g1, 80
	call	min_caml_create_float_array
	addi	%g1, %g1, 80
	st	%g3, %g31, 748
	addi	%g10, %g0, 3
	st	%g3, %g1, 76
	mov	%g3, %g10
	fmov	%f0, %f13
	subi	%g1, %g1, 84
	call	min_caml_create_float_array
	addi	%g1, %g1, 84
	st	%g3, %g31, 744
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 84
	call	min_caml_create_float_array
	addi	%g1, %g1, 84
	st	%g3, %g31, 740
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 84
	call	min_caml_create_float_array
	addi	%g1, %g1, 84
	st	%g3, %g31, 736
	addi	%g10, %g0, 3
	st	%g3, %g1, 80
	mov	%g3, %g10
	fmov	%f0, %f13
	subi	%g1, %g1, 88
	call	min_caml_create_float_array
	addi	%g1, %g1, 88
	st	%g3, %g31, 732
	addi	%g10, %g0, 3
	st	%g3, %g1, 84
	mov	%g3, %g10
	fmov	%f0, %f13
	subi	%g1, %g1, 92
	call	min_caml_create_float_array
	addi	%g1, %g1, 92
	st	%g3, %g31, 728
	addi	%g10, %g0, 3
	st	%g3, %g1, 88
	mov	%g3, %g10
	fmov	%f0, %f13
	subi	%g1, %g1, 96
	call	min_caml_create_float_array
	addi	%g1, %g1, 96
	st	%g3, %g31, 724
	addi	%g3, %g0, 0
	fmov	%f0, %f13
	subi	%g1, %g1, 96
	call	min_caml_create_float_array
	addi	%g1, %g1, 96
	st	%g3, %g31, 720
	addi	%g4, %g0, 0
	st	%g3, %g1, 92
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 100
	call	min_caml_create_array
	addi	%g1, %g1, 100
	st	%g3, %g31, 716
	addi	%g4, %g0, 0
	mov	%g10, %g2
	addi	%g2, %g2, 8
	st	%g3, %g10, -4
	ld	%g3, %g1, 92
	st	%g3, %g10, 0
	mov	%g3, %g10
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 100
	call	min_caml_create_array
	addi	%g1, %g1, 100
	st	%g3, %g31, 712
	addi	%g4, %g0, 5
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 100
	call	min_caml_create_array
	addi	%g1, %g1, 100
	st	%g3, %g31, 708
	addi	%g10, %g0, 0
	st	%g3, %g1, 96
	mov	%g3, %g10
	fmov	%f0, %f13
	subi	%g1, %g1, 104
	call	min_caml_create_float_array
	addi	%g1, %g1, 104
	st	%g3, %g31, 704
	addi	%g10, %g0, 3
	st	%g3, %g1, 100
	mov	%g3, %g10
	fmov	%f0, %f13
	subi	%g1, %g1, 108
	call	min_caml_create_float_array
	addi	%g1, %g1, 108
	st	%g3, %g31, 700
	addi	%g4, %g0, 60
	ld	%g10, %g1, 100
	st	%g3, %g1, 104
	mov	%g3, %g4
	mov	%g4, %g10
	subi	%g1, %g1, 112
	call	min_caml_create_array
	addi	%g1, %g1, 112
	st	%g3, %g31, 696
	mov	%g10, %g2
	addi	%g2, %g2, 8
	st	%g3, %g10, -4
	ld	%g3, %g1, 104
	st	%g3, %g10, 0
	st	%g10, %g31, 692
	addi	%g11, %g0, 0
	mov	%g3, %g11
	fmov	%f0, %f13
	subi	%g1, %g1, 112
	call	min_caml_create_float_array
	addi	%g1, %g1, 112
	st	%g3, %g31, 688
	addi	%g4, %g0, 0
	st	%g3, %g1, 108
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 116
	call	min_caml_create_array
	addi	%g1, %g1, 116
	st	%g3, %g31, 684
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 108
	st	%g3, %g4, 0
	mov	%g3, %g4
	st	%g3, %g31, 680
	addi	%g4, %g0, 180
	addi	%g11, %g0, 0
	mov	%g12, %g2
	addi	%g2, %g2, 12
	fst	%f13, %g12, -8
	st	%g3, %g12, -4
	st	%g11, %g12, 0
	mov	%g3, %g12
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 116
	call	min_caml_create_array
	addi	%g1, %g1, 116
	st	%g3, %g31, 676
	addi	%g4, %g0, 1
	addi	%g11, %g0, 0
	st	%g3, %g1, 112
	mov	%g3, %g4
	mov	%g4, %g11
	subi	%g1, %g1, 120
	call	min_caml_create_array
	addi	%g1, %g1, 120
	st	%g3, %g31, 672
	addi	%g11, %g0, 128
	addi	%g12, %g0, 128
	ld	%g13, %g1, 68
	st	%g11, %g13, 0
	st	%g12, %g13, -4
	addi	%g12, %g0, 64
	ld	%g14, %g1, 72
	st	%g12, %g14, 0
	addi	%g12, %g0, 64
	st	%g12, %g14, -4
	setL %g12, l.34175
	fld	%f14, %g12, 0
	st	%g3, %g1, 116
	fst	%f1, %g1, 120
	mov	%g3, %g11
	subi	%g1, %g1, 128
	call	min_caml_float_of_int
	addi	%g1, %g1, 128
	fdiv	%f0, %f14, %f0
	ld	%g3, %g1, 76
	fst	%f0, %g3, 0
	ld	%g11, %g13, 0
	addi	%g12, %g0, 3
	mov	%g3, %g12
	fmov	%f0, %f13
	subi	%g1, %g1, 128
	call	min_caml_create_float_array
	addi	%g1, %g1, 128
	st	%g3, %g31, 668
	addi	%g12, %g0, 3
	st	%g3, %g1, 124
	mov	%g3, %g12
	fmov	%f0, %f13
	subi	%g1, %g1, 132
	call	min_caml_create_float_array
	addi	%g1, %g1, 132
	st	%g3, %g31, 664
	addi	%g4, %g0, 5
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 132
	call	min_caml_create_array
	addi	%g1, %g1, 132
	st	%g3, %g31, 660
	addi	%g12, %g0, 3
	st	%g3, %g1, 128
	mov	%g3, %g12
	fmov	%f0, %f13
	subi	%g1, %g1, 136
	call	min_caml_create_float_array
	addi	%g1, %g1, 136
	ld	%g12, %g1, 128
	st	%g3, %g12, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 136
	call	min_caml_create_float_array
	addi	%g1, %g1, 136
	st	%g3, %g12, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 136
	call	min_caml_create_float_array
	addi	%g1, %g1, 136
	st	%g3, %g12, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 136
	call	min_caml_create_float_array
	addi	%g1, %g1, 136
	st	%g3, %g12, -16
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	subi	%g1, %g1, 136
	call	min_caml_create_array
	addi	%g1, %g1, 136
	st	%g3, %g31, 656
	addi	%g4, %g0, 5
	addi	%g15, %g0, 0
	st	%g3, %g1, 132
	mov	%g3, %g4
	mov	%g4, %g15
	subi	%g1, %g1, 140
	call	min_caml_create_array
	addi	%g1, %g1, 140
	st	%g3, %g31, 652
	addi	%g15, %g0, 3
	st	%g3, %g1, 136
	mov	%g3, %g15
	fmov	%f0, %f13
	subi	%g1, %g1, 144
	call	min_caml_create_float_array
	addi	%g1, %g1, 144
	st	%g3, %g31, 648
	addi	%g4, %g0, 5
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 144
	call	min_caml_create_array
	addi	%g1, %g1, 144
	st	%g3, %g31, 644
	addi	%g15, %g0, 3
	st	%g3, %g1, 140
	mov	%g3, %g15
	fmov	%f0, %f13
	subi	%g1, %g1, 148
	call	min_caml_create_float_array
	addi	%g1, %g1, 148
	ld	%g15, %g1, 140
	st	%g3, %g15, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 148
	call	min_caml_create_float_array
	addi	%g1, %g1, 148
	st	%g3, %g15, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 148
	call	min_caml_create_float_array
	addi	%g1, %g1, 148
	st	%g3, %g15, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 148
	call	min_caml_create_float_array
	addi	%g1, %g1, 148
	st	%g3, %g15, -16
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 148
	call	min_caml_create_float_array
	addi	%g1, %g1, 148
	st	%g3, %g31, 640
	addi	%g4, %g0, 5
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 148
	call	min_caml_create_array
	addi	%g1, %g1, 148
	st	%g3, %g31, 636
	addi	%g16, %g0, 3
	st	%g3, %g1, 144
	mov	%g3, %g16
	fmov	%f0, %f13
	subi	%g1, %g1, 152
	call	min_caml_create_float_array
	addi	%g1, %g1, 152
	ld	%g16, %g1, 144
	st	%g3, %g16, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 152
	call	min_caml_create_float_array
	addi	%g1, %g1, 152
	st	%g3, %g16, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 152
	call	min_caml_create_float_array
	addi	%g1, %g1, 152
	st	%g3, %g16, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 152
	call	min_caml_create_float_array
	addi	%g1, %g1, 152
	st	%g3, %g16, -16
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 152
	call	min_caml_create_array
	addi	%g1, %g1, 152
	st	%g3, %g31, 632
	addi	%g17, %g0, 3
	st	%g3, %g1, 148
	mov	%g3, %g17
	fmov	%f0, %f13
	subi	%g1, %g1, 156
	call	min_caml_create_float_array
	addi	%g1, %g1, 156
	st	%g3, %g31, 628
	addi	%g4, %g0, 5
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 156
	call	min_caml_create_array
	addi	%g1, %g1, 156
	st	%g3, %g31, 624
	addi	%g17, %g0, 3
	st	%g3, %g1, 152
	mov	%g3, %g17
	fmov	%f0, %f13
	subi	%g1, %g1, 160
	call	min_caml_create_float_array
	addi	%g1, %g1, 160
	ld	%g17, %g1, 152
	st	%g3, %g17, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 160
	call	min_caml_create_float_array
	addi	%g1, %g1, 160
	st	%g3, %g17, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 160
	call	min_caml_create_float_array
	addi	%g1, %g1, 160
	st	%g3, %g17, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 160
	call	min_caml_create_float_array
	addi	%g1, %g1, 160
	st	%g3, %g17, -16
	mov	%g3, %g2
	addi	%g2, %g2, 32
	st	%g17, %g3, -28
	ld	%g4, %g1, 148
	st	%g4, %g3, -24
	st	%g16, %g3, -20
	st	%g15, %g3, -16
	ld	%g4, %g1, 136
	st	%g4, %g3, -12
	ld	%g4, %g1, 132
	st	%g4, %g3, -8
	st	%g12, %g3, -4
	ld	%g4, %g1, 124
	st	%g4, %g3, 0
	mov	%g4, %g3
	mov	%g3, %g11
	subi	%g1, %g1, 160
	call	min_caml_create_array
	addi	%g1, %g1, 160
	st	%g3, %g31, 620
	ld	%g4, %g13, 0
	subi	%g4, %g4, 2
	st	%g10, %g1, 156
	subi	%g1, %g1, 164
	call	init_line_elements.2985
	addi	%g1, %g1, 164
	st	%g3, %g31, 616
	ld	%g10, %g1, 68
	ld	%g11, %g10, 0
	addi	%g12, %g0, 3
	st	%g3, %g1, 160
	mov	%g3, %g12
	fmov	%f0, %f13
	subi	%g1, %g1, 168
	call	min_caml_create_float_array
	addi	%g1, %g1, 168
	st	%g3, %g31, 612
	addi	%g12, %g0, 3
	st	%g3, %g1, 164
	mov	%g3, %g12
	fmov	%f0, %f13
	subi	%g1, %g1, 172
	call	min_caml_create_float_array
	addi	%g1, %g1, 172
	st	%g3, %g31, 608
	addi	%g4, %g0, 5
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 172
	call	min_caml_create_array
	addi	%g1, %g1, 172
	st	%g3, %g31, 604
	addi	%g12, %g0, 3
	st	%g3, %g1, 168
	mov	%g3, %g12
	fmov	%f0, %f13
	subi	%g1, %g1, 176
	call	min_caml_create_float_array
	addi	%g1, %g1, 176
	ld	%g12, %g1, 168
	st	%g3, %g12, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 176
	call	min_caml_create_float_array
	addi	%g1, %g1, 176
	st	%g3, %g12, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 176
	call	min_caml_create_float_array
	addi	%g1, %g1, 176
	st	%g3, %g12, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 176
	call	min_caml_create_float_array
	addi	%g1, %g1, 176
	st	%g3, %g12, -16
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	subi	%g1, %g1, 176
	call	min_caml_create_array
	addi	%g1, %g1, 176
	st	%g3, %g31, 600
	addi	%g4, %g0, 5
	addi	%g13, %g0, 0
	st	%g3, %g1, 172
	mov	%g3, %g4
	mov	%g4, %g13
	subi	%g1, %g1, 180
	call	min_caml_create_array
	addi	%g1, %g1, 180
	st	%g3, %g31, 596
	addi	%g13, %g0, 3
	st	%g3, %g1, 176
	mov	%g3, %g13
	fmov	%f0, %f13
	subi	%g1, %g1, 184
	call	min_caml_create_float_array
	addi	%g1, %g1, 184
	st	%g3, %g31, 592
	addi	%g4, %g0, 5
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 184
	call	min_caml_create_array
	addi	%g1, %g1, 184
	st	%g3, %g31, 588
	addi	%g13, %g0, 3
	st	%g3, %g1, 180
	mov	%g3, %g13
	fmov	%f0, %f13
	subi	%g1, %g1, 188
	call	min_caml_create_float_array
	addi	%g1, %g1, 188
	ld	%g13, %g1, 180
	st	%g3, %g13, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 188
	call	min_caml_create_float_array
	addi	%g1, %g1, 188
	st	%g3, %g13, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 188
	call	min_caml_create_float_array
	addi	%g1, %g1, 188
	st	%g3, %g13, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 188
	call	min_caml_create_float_array
	addi	%g1, %g1, 188
	st	%g3, %g13, -16
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 188
	call	min_caml_create_float_array
	addi	%g1, %g1, 188
	st	%g3, %g31, 584
	addi	%g4, %g0, 5
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 188
	call	min_caml_create_array
	addi	%g1, %g1, 188
	st	%g3, %g31, 580
	addi	%g15, %g0, 3
	st	%g3, %g1, 184
	mov	%g3, %g15
	fmov	%f0, %f13
	subi	%g1, %g1, 192
	call	min_caml_create_float_array
	addi	%g1, %g1, 192
	ld	%g15, %g1, 184
	st	%g3, %g15, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 192
	call	min_caml_create_float_array
	addi	%g1, %g1, 192
	st	%g3, %g15, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 192
	call	min_caml_create_float_array
	addi	%g1, %g1, 192
	st	%g3, %g15, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 192
	call	min_caml_create_float_array
	addi	%g1, %g1, 192
	st	%g3, %g15, -16
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 192
	call	min_caml_create_array
	addi	%g1, %g1, 192
	st	%g3, %g31, 576
	addi	%g16, %g0, 3
	st	%g3, %g1, 188
	mov	%g3, %g16
	fmov	%f0, %f13
	subi	%g1, %g1, 196
	call	min_caml_create_float_array
	addi	%g1, %g1, 196
	st	%g3, %g31, 572
	addi	%g4, %g0, 5
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 196
	call	min_caml_create_array
	addi	%g1, %g1, 196
	st	%g3, %g31, 568
	addi	%g16, %g0, 3
	st	%g3, %g1, 192
	mov	%g3, %g16
	fmov	%f0, %f13
	subi	%g1, %g1, 200
	call	min_caml_create_float_array
	addi	%g1, %g1, 200
	ld	%g16, %g1, 192
	st	%g3, %g16, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 200
	call	min_caml_create_float_array
	addi	%g1, %g1, 200
	st	%g3, %g16, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 200
	call	min_caml_create_float_array
	addi	%g1, %g1, 200
	st	%g3, %g16, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 200
	call	min_caml_create_float_array
	addi	%g1, %g1, 200
	st	%g3, %g16, -16
	mov	%g3, %g2
	addi	%g2, %g2, 32
	st	%g16, %g3, -28
	ld	%g4, %g1, 188
	st	%g4, %g3, -24
	st	%g15, %g3, -20
	st	%g13, %g3, -16
	ld	%g4, %g1, 176
	st	%g4, %g3, -12
	ld	%g4, %g1, 172
	st	%g4, %g3, -8
	st	%g12, %g3, -4
	ld	%g4, %g1, 164
	st	%g4, %g3, 0
	mov	%g4, %g3
	mov	%g3, %g11
	subi	%g1, %g1, 200
	call	min_caml_create_array
	addi	%g1, %g1, 200
	st	%g3, %g31, 564
	ld	%g4, %g10, 0
	subi	%g4, %g4, 2
	subi	%g1, %g1, 200
	call	init_line_elements.2985
	addi	%g1, %g1, 200
	st	%g3, %g31, 560
	ld	%g10, %g1, 68
	ld	%g11, %g10, 0
	addi	%g12, %g0, 3
	st	%g3, %g1, 196
	mov	%g3, %g12
	fmov	%f0, %f13
	subi	%g1, %g1, 204
	call	min_caml_create_float_array
	addi	%g1, %g1, 204
	st	%g3, %g31, 556
	addi	%g12, %g0, 3
	st	%g3, %g1, 200
	mov	%g3, %g12
	fmov	%f0, %f13
	subi	%g1, %g1, 208
	call	min_caml_create_float_array
	addi	%g1, %g1, 208
	st	%g3, %g31, 552
	addi	%g4, %g0, 5
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 208
	call	min_caml_create_array
	addi	%g1, %g1, 208
	st	%g3, %g31, 548
	addi	%g12, %g0, 3
	st	%g3, %g1, 204
	mov	%g3, %g12
	fmov	%f0, %f13
	subi	%g1, %g1, 212
	call	min_caml_create_float_array
	addi	%g1, %g1, 212
	ld	%g12, %g1, 204
	st	%g3, %g12, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 212
	call	min_caml_create_float_array
	addi	%g1, %g1, 212
	st	%g3, %g12, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 212
	call	min_caml_create_float_array
	addi	%g1, %g1, 212
	st	%g3, %g12, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 212
	call	min_caml_create_float_array
	addi	%g1, %g1, 212
	st	%g3, %g12, -16
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	subi	%g1, %g1, 212
	call	min_caml_create_array
	addi	%g1, %g1, 212
	st	%g3, %g31, 544
	addi	%g4, %g0, 5
	addi	%g13, %g0, 0
	st	%g3, %g1, 208
	mov	%g3, %g4
	mov	%g4, %g13
	subi	%g1, %g1, 216
	call	min_caml_create_array
	addi	%g1, %g1, 216
	st	%g3, %g31, 540
	addi	%g13, %g0, 3
	st	%g3, %g1, 212
	mov	%g3, %g13
	fmov	%f0, %f13
	subi	%g1, %g1, 220
	call	min_caml_create_float_array
	addi	%g1, %g1, 220
	st	%g3, %g31, 536
	addi	%g4, %g0, 5
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 220
	call	min_caml_create_array
	addi	%g1, %g1, 220
	st	%g3, %g31, 532
	addi	%g13, %g0, 3
	st	%g3, %g1, 216
	mov	%g3, %g13
	fmov	%f0, %f13
	subi	%g1, %g1, 224
	call	min_caml_create_float_array
	addi	%g1, %g1, 224
	ld	%g13, %g1, 216
	st	%g3, %g13, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 224
	call	min_caml_create_float_array
	addi	%g1, %g1, 224
	st	%g3, %g13, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 224
	call	min_caml_create_float_array
	addi	%g1, %g1, 224
	st	%g3, %g13, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 224
	call	min_caml_create_float_array
	addi	%g1, %g1, 224
	st	%g3, %g13, -16
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 224
	call	min_caml_create_float_array
	addi	%g1, %g1, 224
	st	%g3, %g31, 528
	addi	%g4, %g0, 5
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 224
	call	min_caml_create_array
	addi	%g1, %g1, 224
	st	%g3, %g31, 524
	addi	%g15, %g0, 3
	st	%g3, %g1, 220
	mov	%g3, %g15
	fmov	%f0, %f13
	subi	%g1, %g1, 228
	call	min_caml_create_float_array
	addi	%g1, %g1, 228
	ld	%g15, %g1, 220
	st	%g3, %g15, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 228
	call	min_caml_create_float_array
	addi	%g1, %g1, 228
	st	%g3, %g15, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 228
	call	min_caml_create_float_array
	addi	%g1, %g1, 228
	st	%g3, %g15, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 228
	call	min_caml_create_float_array
	addi	%g1, %g1, 228
	st	%g3, %g15, -16
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 228
	call	min_caml_create_array
	addi	%g1, %g1, 228
	st	%g3, %g31, 520
	addi	%g16, %g0, 3
	st	%g3, %g1, 224
	mov	%g3, %g16
	fmov	%f0, %f13
	subi	%g1, %g1, 232
	call	min_caml_create_float_array
	addi	%g1, %g1, 232
	st	%g3, %g31, 516
	addi	%g4, %g0, 5
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 232
	call	min_caml_create_array
	addi	%g1, %g1, 232
	st	%g3, %g31, 512
	addi	%g16, %g0, 3
	st	%g3, %g1, 228
	mov	%g3, %g16
	fmov	%f0, %f13
	subi	%g1, %g1, 236
	call	min_caml_create_float_array
	addi	%g1, %g1, 236
	ld	%g16, %g1, 228
	st	%g3, %g16, -4
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 236
	call	min_caml_create_float_array
	addi	%g1, %g1, 236
	st	%g3, %g16, -8
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 236
	call	min_caml_create_float_array
	addi	%g1, %g1, 236
	st	%g3, %g16, -12
	addi	%g3, %g0, 3
	fmov	%f0, %f13
	subi	%g1, %g1, 236
	call	min_caml_create_float_array
	addi	%g1, %g1, 236
	st	%g3, %g16, -16
	mov	%g3, %g2
	addi	%g2, %g2, 32
	st	%g16, %g3, -28
	ld	%g4, %g1, 224
	st	%g4, %g3, -24
	st	%g15, %g3, -20
	st	%g13, %g3, -16
	ld	%g4, %g1, 212
	st	%g4, %g3, -12
	ld	%g4, %g1, 208
	st	%g4, %g3, -8
	st	%g12, %g3, -4
	ld	%g4, %g1, 200
	st	%g4, %g3, 0
	mov	%g4, %g3
	mov	%g3, %g11
	subi	%g1, %g1, 236
	call	min_caml_create_array
	addi	%g1, %g1, 236
	st	%g3, %g31, 508
	ld	%g4, %g10, 0
	subi	%g4, %g4, 2
	subi	%g1, %g1, 236
	call	init_line_elements.2985
	addi	%g1, %g1, 236
	mov	%g10, %g3
	st	%g10, %g31, 504
	addi	%g11, %g0, 0
	ld	%g12, %g1, 8
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 12
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	ld	%g15, %g1, 16
	st	%g11, %g15, 0
	addi	%g11, %g0, 0
	ld	%g16, %g1, 20
	st	%g11, %g16, 0
	input	%g3
	st	%g3, %g31, 500
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40197
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40199
	addi	%g4, %g0, 0
	jmp	jle_cont.40200
jle_else.40199:
	addi	%g4, %g0, 1
jle_cont.40200:
	jmp	jle_cont.40198
jle_else.40197:
	addi	%g4, %g0, 1
jle_cont.40198:
	st	%g4, %g31, 496
	st	%g10, %g1, 232
	jne	%g4, %g0, jeq_else.40201
	ld	%g4, %g16, 0
	jne	%g4, %g0, jeq_else.40203
	addi	%g4, %g0, 1
	st	%g4, %g16, 0
	jmp	jeq_cont.40204
jeq_else.40203:
jeq_cont.40204:
	ld	%g4, %g12, 0
	slli	%g17, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g17, %g4
	subi	%g17, %g3, 48
	add	%g4, %g4, %g17
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 240
	call	read_float_token1.2516
	addi	%g1, %g1, 240
	mov	%g10, %g3
	jmp	jeq_cont.40202
jeq_else.40201:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 240
	call	read_float_token1.2516
	addi	%g1, %g1, 240
	mov	%g10, %g3
jeq_cont.40202:
	st	%g10, %g31, 492
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.40205
	input	%g3
	addi	%g17, %g0, 48
	jlt	%g3, %g17, jle_else.40207
	addi	%g17, %g0, 57
	jlt	%g17, %g3, jle_else.40209
	addi	%g17, %g0, 0
	jmp	jle_cont.40210
jle_else.40209:
	addi	%g17, %g0, 1
jle_cont.40210:
	jmp	jle_cont.40208
jle_else.40207:
	addi	%g17, %g0, 1
jle_cont.40208:
	jne	%g17, %g0, jeq_else.40211
	ld	%g17, %g1, 12
	ld	%g18, %g17, 0
	slli	%g19, %g18, 3
	slli	%g18, %g18, 1
	add	%g18, %g19, %g18
	subi	%g3, %g3, 48
	add	%g3, %g18, %g3
	st	%g3, %g17, 0
	ld	%g3, %g15, 0
	slli	%g18, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g18, %g3
	st	%g3, %g15, 0
	addi	%g3, %g0, 1
	subi	%g1, %g1, 240
	call	read_float_token2.2519
	addi	%g1, %g1, 240
	jmp	jeq_cont.40212
jeq_else.40211:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 240
	call	read_float_token2.2519
	addi	%g1, %g1, 240
jeq_cont.40212:
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
	fmov	%f14, %f0, 0
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
	fmov	%f15, %f0, 0
	ld	%g3, %g15, 0
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
	fdiv	%f0, %f15, %f0
	fadd	%f0, %f14, %f0
	jmp	jeq_cont.40206
jeq_else.40205:
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
jeq_cont.40206:
	fst	%f0, %g31, 488
	ld	%g10, %g16, 0
	jne	%g10, %g28, jeq_else.40213
	jmp	jeq_cont.40214
jeq_else.40213:
	fneg	%f0, %f0
jeq_cont.40214:
	ld	%g10, %g1, 36
	fst	%f0, %g10, 0
	addi	%g11, %g0, 0
	ld	%g12, %g1, 8
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 12
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	st	%g11, %g15, 0
	addi	%g11, %g0, 0
	st	%g11, %g16, 0
	input	%g3
	st	%g3, %g31, 484
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40215
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40217
	addi	%g4, %g0, 0
	jmp	jle_cont.40218
jle_else.40217:
	addi	%g4, %g0, 1
jle_cont.40218:
	jmp	jle_cont.40216
jle_else.40215:
	addi	%g4, %g0, 1
jle_cont.40216:
	st	%g4, %g31, 480
	jne	%g4, %g0, jeq_else.40219
	ld	%g4, %g16, 0
	jne	%g4, %g0, jeq_else.40221
	addi	%g4, %g0, 1
	st	%g4, %g16, 0
	jmp	jeq_cont.40222
jeq_else.40221:
jeq_cont.40222:
	ld	%g4, %g12, 0
	slli	%g17, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g17, %g4
	subi	%g17, %g3, 48
	add	%g4, %g4, %g17
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 240
	call	read_float_token1.2516
	addi	%g1, %g1, 240
	mov	%g10, %g3
	jmp	jeq_cont.40220
jeq_else.40219:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 240
	call	read_float_token1.2516
	addi	%g1, %g1, 240
	mov	%g10, %g3
jeq_cont.40220:
	st	%g10, %g31, 476
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.40223
	input	%g3
	addi	%g17, %g0, 48
	jlt	%g3, %g17, jle_else.40225
	addi	%g17, %g0, 57
	jlt	%g17, %g3, jle_else.40227
	addi	%g17, %g0, 0
	jmp	jle_cont.40228
jle_else.40227:
	addi	%g17, %g0, 1
jle_cont.40228:
	jmp	jle_cont.40226
jle_else.40225:
	addi	%g17, %g0, 1
jle_cont.40226:
	jne	%g17, %g0, jeq_else.40229
	ld	%g17, %g1, 12
	ld	%g18, %g17, 0
	slli	%g19, %g18, 3
	slli	%g18, %g18, 1
	add	%g18, %g19, %g18
	subi	%g3, %g3, 48
	add	%g3, %g18, %g3
	st	%g3, %g17, 0
	ld	%g3, %g15, 0
	slli	%g18, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g18, %g3
	st	%g3, %g15, 0
	addi	%g3, %g0, 1
	subi	%g1, %g1, 240
	call	read_float_token2.2519
	addi	%g1, %g1, 240
	jmp	jeq_cont.40230
jeq_else.40229:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 240
	call	read_float_token2.2519
	addi	%g1, %g1, 240
jeq_cont.40230:
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
	fmov	%f14, %f0, 0
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
	fmov	%f15, %f0, 0
	ld	%g3, %g15, 0
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
	fdiv	%f0, %f15, %f0
	fadd	%f0, %f14, %f0
	jmp	jeq_cont.40224
jeq_else.40223:
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
jeq_cont.40224:
	fst	%f0, %g31, 472
	ld	%g10, %g16, 0
	jne	%g10, %g28, jeq_else.40231
	jmp	jeq_cont.40232
jeq_else.40231:
	fneg	%f0, %f0
jeq_cont.40232:
	ld	%g10, %g1, 36
	fst	%f0, %g10, -4
	addi	%g11, %g0, 0
	ld	%g12, %g1, 8
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 12
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	st	%g11, %g15, 0
	addi	%g11, %g0, 0
	st	%g11, %g16, 0
	input	%g3
	st	%g3, %g31, 468
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40233
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40235
	addi	%g4, %g0, 0
	jmp	jle_cont.40236
jle_else.40235:
	addi	%g4, %g0, 1
jle_cont.40236:
	jmp	jle_cont.40234
jle_else.40233:
	addi	%g4, %g0, 1
jle_cont.40234:
	st	%g4, %g31, 464
	jne	%g4, %g0, jeq_else.40237
	ld	%g4, %g16, 0
	jne	%g4, %g0, jeq_else.40239
	addi	%g4, %g0, 1
	st	%g4, %g16, 0
	jmp	jeq_cont.40240
jeq_else.40239:
jeq_cont.40240:
	ld	%g4, %g12, 0
	slli	%g17, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g17, %g4
	subi	%g17, %g3, 48
	add	%g4, %g4, %g17
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 240
	call	read_float_token1.2516
	addi	%g1, %g1, 240
	mov	%g10, %g3
	jmp	jeq_cont.40238
jeq_else.40237:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 240
	call	read_float_token1.2516
	addi	%g1, %g1, 240
	mov	%g10, %g3
jeq_cont.40238:
	st	%g10, %g31, 460
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.40241
	input	%g3
	addi	%g17, %g0, 48
	jlt	%g3, %g17, jle_else.40243
	addi	%g17, %g0, 57
	jlt	%g17, %g3, jle_else.40245
	addi	%g17, %g0, 0
	jmp	jle_cont.40246
jle_else.40245:
	addi	%g17, %g0, 1
jle_cont.40246:
	jmp	jle_cont.40244
jle_else.40243:
	addi	%g17, %g0, 1
jle_cont.40244:
	jne	%g17, %g0, jeq_else.40247
	ld	%g17, %g1, 12
	ld	%g18, %g17, 0
	slli	%g19, %g18, 3
	slli	%g18, %g18, 1
	add	%g18, %g19, %g18
	subi	%g3, %g3, 48
	add	%g3, %g18, %g3
	st	%g3, %g17, 0
	ld	%g3, %g15, 0
	slli	%g18, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g18, %g3
	st	%g3, %g15, 0
	addi	%g3, %g0, 1
	subi	%g1, %g1, 240
	call	read_float_token2.2519
	addi	%g1, %g1, 240
	jmp	jeq_cont.40248
jeq_else.40247:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 240
	call	read_float_token2.2519
	addi	%g1, %g1, 240
jeq_cont.40248:
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
	fmov	%f14, %f0, 0
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
	fmov	%f15, %f0, 0
	ld	%g3, %g15, 0
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
	fdiv	%f0, %f15, %f0
	fadd	%f0, %f14, %f0
	jmp	jeq_cont.40242
jeq_else.40241:
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
jeq_cont.40242:
	fst	%f0, %g31, 456
	ld	%g10, %g16, 0
	jne	%g10, %g28, jeq_else.40249
	jmp	jeq_cont.40250
jeq_else.40249:
	fneg	%f0, %f0
jeq_cont.40250:
	ld	%g10, %g1, 36
	fst	%f0, %g10, -8
	addi	%g11, %g0, 0
	ld	%g12, %g1, 8
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 12
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	st	%g11, %g15, 0
	addi	%g11, %g0, 0
	st	%g11, %g16, 0
	input	%g3
	st	%g3, %g31, 452
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40251
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40253
	addi	%g4, %g0, 0
	jmp	jle_cont.40254
jle_else.40253:
	addi	%g4, %g0, 1
jle_cont.40254:
	jmp	jle_cont.40252
jle_else.40251:
	addi	%g4, %g0, 1
jle_cont.40252:
	st	%g4, %g31, 448
	jne	%g4, %g0, jeq_else.40255
	ld	%g4, %g16, 0
	jne	%g4, %g0, jeq_else.40257
	addi	%g4, %g0, 1
	st	%g4, %g16, 0
	jmp	jeq_cont.40258
jeq_else.40257:
jeq_cont.40258:
	ld	%g4, %g12, 0
	slli	%g17, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g17, %g4
	subi	%g17, %g3, 48
	add	%g4, %g4, %g17
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 240
	call	read_float_token1.2516
	addi	%g1, %g1, 240
	mov	%g10, %g3
	jmp	jeq_cont.40256
jeq_else.40255:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 240
	call	read_float_token1.2516
	addi	%g1, %g1, 240
	mov	%g10, %g3
jeq_cont.40256:
	st	%g10, %g31, 444
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.40259
	input	%g3
	addi	%g17, %g0, 48
	jlt	%g3, %g17, jle_else.40261
	addi	%g17, %g0, 57
	jlt	%g17, %g3, jle_else.40263
	addi	%g17, %g0, 0
	jmp	jle_cont.40264
jle_else.40263:
	addi	%g17, %g0, 1
jle_cont.40264:
	jmp	jle_cont.40262
jle_else.40261:
	addi	%g17, %g0, 1
jle_cont.40262:
	jne	%g17, %g0, jeq_else.40265
	ld	%g17, %g1, 12
	ld	%g18, %g17, 0
	slli	%g19, %g18, 3
	slli	%g18, %g18, 1
	add	%g18, %g19, %g18
	subi	%g3, %g3, 48
	add	%g3, %g18, %g3
	st	%g3, %g17, 0
	ld	%g3, %g15, 0
	slli	%g18, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g18, %g3
	st	%g3, %g15, 0
	addi	%g3, %g0, 1
	subi	%g1, %g1, 240
	call	read_float_token2.2519
	addi	%g1, %g1, 240
	jmp	jeq_cont.40266
jeq_else.40265:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 240
	call	read_float_token2.2519
	addi	%g1, %g1, 240
jeq_cont.40266:
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
	fmov	%f14, %f0, 0
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
	fmov	%f15, %f0, 0
	ld	%g3, %g15, 0
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
	fdiv	%f0, %f15, %f0
	fadd	%f0, %f14, %f0
	jmp	jeq_cont.40260
jeq_else.40259:
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 240
	call	min_caml_float_of_int
	addi	%g1, %g1, 240
jeq_cont.40260:
	fst	%f0, %g31, 440
	ld	%g10, %g16, 0
	jne	%g10, %g28, jeq_else.40267
	jmp	jeq_cont.40268
jeq_else.40267:
	fneg	%f0, %f0
jeq_cont.40268:
	setL %g10, l.34372
	fld	%f14, %g10, 0
	fmul	%f0, %f0, %f14
	fst	%f0, %g31, 436
	fsub	%f3, %f12, %f0
	fjlt	%f3, %f13, fjge_else.40269
	fmov	%f4, %f3
	jmp	fjge_cont.40270
fjge_else.40269:
	fneg	%f4, %f3
fjge_cont.40270:
	fst	%f4, %g31, 432
	fst	%f0, %g1, 236
	fjlt	%f10, %f4, fjge_else.40271
	fjlt	%f4, %f13, fjge_else.40273
	fmov	%f0, %f4
	jmp	fjge_cont.40274
fjge_else.40273:
	fadd	%f4, %f4, %f10
	fjlt	%f10, %f4, fjge_else.40275
	fjlt	%f4, %f13, fjge_else.40277
	fmov	%f0, %f4
	jmp	fjge_cont.40278
fjge_else.40277:
	fadd	%f4, %f4, %f10
	fjlt	%f10, %f4, fjge_else.40279
	fjlt	%f4, %f13, fjge_else.40281
	fmov	%f0, %f4
	jmp	fjge_cont.40282
fjge_else.40281:
	fadd	%f4, %f4, %f10
	fmov	%f0, %f4
	subi	%g1, %g1, 244
	call	sin_sub.2497
	addi	%g1, %g1, 244
fjge_cont.40282:
	jmp	fjge_cont.40280
fjge_else.40279:
	fsub	%f4, %f4, %f10
	fmov	%f0, %f4
	subi	%g1, %g1, 244
	call	sin_sub.2497
	addi	%g1, %g1, 244
fjge_cont.40280:
fjge_cont.40278:
	jmp	fjge_cont.40276
fjge_else.40275:
	fsub	%f4, %f4, %f10
	fjlt	%f10, %f4, fjge_else.40283
	fjlt	%f4, %f13, fjge_else.40285
	fmov	%f0, %f4
	jmp	fjge_cont.40286
fjge_else.40285:
	fadd	%f4, %f4, %f10
	fmov	%f0, %f4
	subi	%g1, %g1, 244
	call	sin_sub.2497
	addi	%g1, %g1, 244
fjge_cont.40286:
	jmp	fjge_cont.40284
fjge_else.40283:
	fsub	%f4, %f4, %f10
	fmov	%f0, %f4
	subi	%g1, %g1, 244
	call	sin_sub.2497
	addi	%g1, %g1, 244
fjge_cont.40284:
fjge_cont.40276:
fjge_cont.40274:
	jmp	fjge_cont.40272
fjge_else.40271:
	fsub	%f4, %f4, %f10
	fjlt	%f10, %f4, fjge_else.40287
	fjlt	%f4, %f13, fjge_else.40289
	fmov	%f0, %f4
	jmp	fjge_cont.40290
fjge_else.40289:
	fadd	%f4, %f4, %f10
	fjlt	%f10, %f4, fjge_else.40291
	fjlt	%f4, %f13, fjge_else.40293
	fmov	%f0, %f4
	jmp	fjge_cont.40294
fjge_else.40293:
	fadd	%f4, %f4, %f10
	fmov	%f0, %f4
	subi	%g1, %g1, 244
	call	sin_sub.2497
	addi	%g1, %g1, 244
fjge_cont.40294:
	jmp	fjge_cont.40292
fjge_else.40291:
	fsub	%f4, %f4, %f10
	fmov	%f0, %f4
	subi	%g1, %g1, 244
	call	sin_sub.2497
	addi	%g1, %g1, 244
fjge_cont.40292:
fjge_cont.40290:
	jmp	fjge_cont.40288
fjge_else.40287:
	fsub	%f4, %f4, %f10
	fjlt	%f10, %f4, fjge_else.40295
	fjlt	%f4, %f13, fjge_else.40297
	fmov	%f0, %f4
	jmp	fjge_cont.40298
fjge_else.40297:
	fadd	%f4, %f4, %f10
	fmov	%f0, %f4
	subi	%g1, %g1, 244
	call	sin_sub.2497
	addi	%g1, %g1, 244
fjge_cont.40298:
	jmp	fjge_cont.40296
fjge_else.40295:
	fsub	%f4, %f4, %f10
	fmov	%f0, %f4
	subi	%g1, %g1, 244
	call	sin_sub.2497
	addi	%g1, %g1, 244
fjge_cont.40296:
fjge_cont.40288:
fjge_cont.40272:
	fst	%f0, %g31, 428
	fld	%f4, %g1, 28
	fjlt	%f4, %f0, fjge_else.40299
	fjlt	%f13, %f3, fjge_else.40301
	addi	%g10, %g0, 0
	jmp	fjge_cont.40302
fjge_else.40301:
	addi	%g10, %g0, 1
fjge_cont.40302:
	jmp	fjge_cont.40300
fjge_else.40299:
	fjlt	%f13, %f3, fjge_else.40303
	addi	%g10, %g0, 1
	jmp	fjge_cont.40304
fjge_else.40303:
	addi	%g10, %g0, 0
fjge_cont.40304:
fjge_cont.40300:
	st	%g10, %g31, 424
	fjlt	%f4, %f0, fjge_else.40305
	jmp	fjge_cont.40306
fjge_else.40305:
	fsub	%f0, %f10, %f0
fjge_cont.40306:
	fst	%f0, %g31, 420
	fjlt	%f12, %f0, fjge_else.40307
	jmp	fjge_cont.40308
fjge_else.40307:
	fsub	%f0, %f4, %f0
fjge_cont.40308:
	fst	%f0, %g31, 416
	fmul	%f0, %f0, %f11
	fmov	%f3, %f17
	fmul	%f5, %f0, %f0
	fmov	%f6, %f24
	fmov	%f7, %f23
	fdiv	%f8, %f5, %f7
	fmov	%f9, %f22
	fsub	%f8, %f6, %f8
	fdiv	%f8, %f5, %f8
	fmov	%f1, %f21
	fsub	%f8, %f9, %f8
	fdiv	%f8, %f5, %f8
	fsub	%f8, %f1, %f8
	fdiv	%f5, %f5, %f8
	fsub	%f5, %f3, %f5
	fdiv	%f0, %f0, %f5
	fst	%f0, %g31, 412
	fld	%f5, %g1, 120
	fmul	%f8, %f5, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f3, %f0
	fdiv	%f0, %f8, %f0
	fst	%f0, %g31, 408
	jne	%g10, %g0, jeq_else.40309
	fneg	%f0, %f0
	jmp	jeq_cont.40310
jeq_else.40309:
jeq_cont.40310:
	fst	%f0, %g31, 404
	fld	%f8, %g1, 236
	fjlt	%f8, %f13, fjge_else.40311
	fmov	%f15, %f8
	jmp	fjge_cont.40312
fjge_else.40311:
	fneg	%f15, %f8
fjge_cont.40312:
	fst	%f15, %g31, 400
	fst	%f0, %g1, 240
	fst	%f1, %g1, 244
	fjlt	%f10, %f15, fjge_else.40313
	fjlt	%f15, %f13, fjge_else.40315
	fmov	%f0, %f15
	jmp	fjge_cont.40316
fjge_else.40315:
	fadd	%f15, %f15, %f10
	fjlt	%f10, %f15, fjge_else.40317
	fjlt	%f15, %f13, fjge_else.40319
	fmov	%f0, %f15
	jmp	fjge_cont.40320
fjge_else.40319:
	fadd	%f15, %f15, %f10
	fjlt	%f10, %f15, fjge_else.40321
	fjlt	%f15, %f13, fjge_else.40323
	fmov	%f0, %f15
	jmp	fjge_cont.40324
fjge_else.40323:
	fadd	%f2, %f15, %f10
	fmov	%f0, %f2
	subi	%g1, %g1, 252
	call	sin_sub.2497
	addi	%g1, %g1, 252
fjge_cont.40324:
	jmp	fjge_cont.40322
fjge_else.40321:
	fsub	%f2, %f15, %f10
	fmov	%f0, %f2
	subi	%g1, %g1, 252
	call	sin_sub.2497
	addi	%g1, %g1, 252
fjge_cont.40322:
fjge_cont.40320:
	jmp	fjge_cont.40318
fjge_else.40317:
	fsub	%f15, %f15, %f10
	fjlt	%f10, %f15, fjge_else.40325
	fjlt	%f15, %f13, fjge_else.40327
	fmov	%f0, %f15
	jmp	fjge_cont.40328
fjge_else.40327:
	fadd	%f2, %f15, %f10
	fmov	%f0, %f2
	subi	%g1, %g1, 252
	call	sin_sub.2497
	addi	%g1, %g1, 252
fjge_cont.40328:
	jmp	fjge_cont.40326
fjge_else.40325:
	fsub	%f2, %f15, %f10
	fmov	%f0, %f2
	subi	%g1, %g1, 252
	call	sin_sub.2497
	addi	%g1, %g1, 252
fjge_cont.40326:
fjge_cont.40318:
fjge_cont.40316:
	jmp	fjge_cont.40314
fjge_else.40313:
	fsub	%f15, %f15, %f10
	fjlt	%f10, %f15, fjge_else.40329
	fjlt	%f15, %f13, fjge_else.40331
	fmov	%f0, %f15
	jmp	fjge_cont.40332
fjge_else.40331:
	fadd	%f15, %f15, %f10
	fjlt	%f10, %f15, fjge_else.40333
	fjlt	%f15, %f13, fjge_else.40335
	fmov	%f0, %f15
	jmp	fjge_cont.40336
fjge_else.40335:
	fadd	%f2, %f15, %f10
	fmov	%f0, %f2
	subi	%g1, %g1, 252
	call	sin_sub.2497
	addi	%g1, %g1, 252
fjge_cont.40336:
	jmp	fjge_cont.40334
fjge_else.40333:
	fsub	%f2, %f15, %f10
	fmov	%f0, %f2
	subi	%g1, %g1, 252
	call	sin_sub.2497
	addi	%g1, %g1, 252
fjge_cont.40334:
fjge_cont.40332:
	jmp	fjge_cont.40330
fjge_else.40329:
	fsub	%f15, %f15, %f10
	fjlt	%f10, %f15, fjge_else.40337
	fjlt	%f15, %f13, fjge_else.40339
	fmov	%f0, %f15
	jmp	fjge_cont.40340
fjge_else.40339:
	fadd	%f2, %f15, %f10
	fmov	%f0, %f2
	subi	%g1, %g1, 252
	call	sin_sub.2497
	addi	%g1, %g1, 252
fjge_cont.40340:
	jmp	fjge_cont.40338
fjge_else.40337:
	fsub	%f2, %f15, %f10
	fmov	%f0, %f2
	subi	%g1, %g1, 252
	call	sin_sub.2497
	addi	%g1, %g1, 252
fjge_cont.40338:
fjge_cont.40330:
fjge_cont.40314:
	fst	%f0, %g31, 396
	fjlt	%f4, %f0, fjge_else.40341
	fjlt	%f13, %f8, fjge_else.40343
	addi	%g10, %g0, 0
	jmp	fjge_cont.40344
fjge_else.40343:
	addi	%g10, %g0, 1
fjge_cont.40344:
	jmp	fjge_cont.40342
fjge_else.40341:
	fjlt	%f13, %f8, fjge_else.40345
	addi	%g10, %g0, 1
	jmp	fjge_cont.40346
fjge_else.40345:
	addi	%g10, %g0, 0
fjge_cont.40346:
fjge_cont.40342:
	st	%g10, %g31, 392
	fjlt	%f4, %f0, fjge_else.40347
	jmp	fjge_cont.40348
fjge_else.40347:
	fsub	%f0, %f10, %f0
fjge_cont.40348:
	fst	%f0, %g31, 388
	fjlt	%f12, %f0, fjge_else.40349
	jmp	fjge_cont.40350
fjge_else.40349:
	fsub	%f0, %f4, %f0
fjge_cont.40350:
	fst	%f0, %g31, 384
	fmul	%f0, %f0, %f11
	fmul	%f1, %f0, %f0
	fdiv	%f15, %f1, %f7
	fsub	%f15, %f6, %f15
	fdiv	%f15, %f1, %f15
	fsub	%f15, %f9, %f15
	fdiv	%f15, %f1, %f15
	fld	%f2, %g1, 244
	fsub	%f15, %f2, %f15
	fdiv	%f1, %f1, %f15
	fsub	%f1, %f3, %f1
	fdiv	%f0, %f0, %f1
	fst	%f0, %g31, 380
	fmul	%f1, %f5, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f3, %f0
	fdiv	%f0, %f1, %f0
	fst	%f0, %g31, 376
	jne	%g10, %g0, jeq_else.40351
	fneg	%f0, %f0
	jmp	jeq_cont.40352
jeq_else.40351:
jeq_cont.40352:
	fst	%f0, %g31, 372
	addi	%g10, %g0, 0
	ld	%g11, %g1, 8
	st	%g10, %g11, 0
	addi	%g10, %g0, 0
	ld	%g12, %g1, 12
	st	%g10, %g12, 0
	addi	%g10, %g0, 1
	st	%g10, %g15, 0
	addi	%g10, %g0, 0
	st	%g10, %g16, 0
	input	%g3
	st	%g3, %g31, 368
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40353
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40355
	addi	%g4, %g0, 0
	jmp	jle_cont.40356
jle_else.40355:
	addi	%g4, %g0, 1
jle_cont.40356:
	jmp	jle_cont.40354
jle_else.40353:
	addi	%g4, %g0, 1
jle_cont.40354:
	st	%g4, %g31, 364
	jne	%g4, %g0, jeq_else.40357
	ld	%g4, %g16, 0
	jne	%g4, %g0, jeq_else.40359
	addi	%g4, %g0, 1
	st	%g4, %g16, 0
	jmp	jeq_cont.40360
jeq_else.40359:
jeq_cont.40360:
	ld	%g4, %g11, 0
	slli	%g17, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g17, %g4
	subi	%g17, %g3, 48
	add	%g4, %g4, %g17
	st	%g4, %g11, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 252
	call	read_float_token1.2516
	addi	%g1, %g1, 252
	mov	%g10, %g3
	jmp	jeq_cont.40358
jeq_else.40357:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 252
	call	read_float_token1.2516
	addi	%g1, %g1, 252
	mov	%g10, %g3
jeq_cont.40358:
	st	%g10, %g31, 360
	addi	%g11, %g0, 46
	fst	%f0, %g1, 248
	jne	%g10, %g11, jeq_else.40361
	input	%g3
	addi	%g17, %g0, 48
	jlt	%g3, %g17, jle_else.40363
	addi	%g17, %g0, 57
	jlt	%g17, %g3, jle_else.40365
	addi	%g17, %g0, 0
	jmp	jle_cont.40366
jle_else.40365:
	addi	%g17, %g0, 1
jle_cont.40366:
	jmp	jle_cont.40364
jle_else.40363:
	addi	%g17, %g0, 1
jle_cont.40364:
	jne	%g17, %g0, jeq_else.40367
	ld	%g17, %g1, 12
	ld	%g18, %g17, 0
	slli	%g19, %g18, 3
	slli	%g18, %g18, 1
	add	%g18, %g19, %g18
	subi	%g3, %g3, 48
	add	%g3, %g18, %g3
	st	%g3, %g17, 0
	ld	%g3, %g15, 0
	slli	%g18, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g18, %g3
	st	%g3, %g15, 0
	addi	%g3, %g0, 1
	subi	%g1, %g1, 256
	call	read_float_token2.2519
	addi	%g1, %g1, 256
	jmp	jeq_cont.40368
jeq_else.40367:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 256
	call	read_float_token2.2519
	addi	%g1, %g1, 256
jeq_cont.40368:
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 256
	call	min_caml_float_of_int
	addi	%g1, %g1, 256
	fmov	%f15, %f0, 0
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 256
	call	min_caml_float_of_int
	addi	%g1, %g1, 256
	fmov	%f8, %f0, 0
	ld	%g3, %g15, 0
	subi	%g1, %g1, 256
	call	min_caml_float_of_int
	addi	%g1, %g1, 256
	fdiv	%f0, %f8, %f0
	fadd	%f0, %f15, %f0
	jmp	jeq_cont.40362
jeq_else.40361:
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 256
	call	min_caml_float_of_int
	addi	%g1, %g1, 256
jeq_cont.40362:
	fst	%f0, %g31, 356
	ld	%g10, %g16, 0
	jne	%g10, %g28, jeq_else.40369
	jmp	jeq_cont.40370
jeq_else.40369:
	fneg	%f0, %f0
jeq_cont.40370:
	fmul	%f0, %f0, %f14
	fst	%f0, %g31, 352
	fsub	%f8, %f12, %f0
	fjlt	%f8, %f13, fjge_else.40371
	fmov	%f1, %f8
	jmp	fjge_cont.40372
fjge_else.40371:
	fneg	%f1, %f8
fjge_cont.40372:
	fst	%f1, %g31, 348
	fst	%f0, %g1, 252
	fjlt	%f10, %f1, fjge_else.40373
	fjlt	%f1, %f13, fjge_else.40375
	fmov	%f0, %f1
	jmp	fjge_cont.40376
fjge_else.40375:
	fadd	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40377
	fjlt	%f1, %f13, fjge_else.40379
	fmov	%f0, %f1
	jmp	fjge_cont.40380
fjge_else.40379:
	fadd	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40381
	fjlt	%f1, %f13, fjge_else.40383
	fmov	%f0, %f1
	jmp	fjge_cont.40384
fjge_else.40383:
	fadd	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 260
	call	sin_sub.2497
	addi	%g1, %g1, 260
fjge_cont.40384:
	jmp	fjge_cont.40382
fjge_else.40381:
	fsub	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 260
	call	sin_sub.2497
	addi	%g1, %g1, 260
fjge_cont.40382:
fjge_cont.40380:
	jmp	fjge_cont.40378
fjge_else.40377:
	fsub	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40385
	fjlt	%f1, %f13, fjge_else.40387
	fmov	%f0, %f1
	jmp	fjge_cont.40388
fjge_else.40387:
	fadd	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 260
	call	sin_sub.2497
	addi	%g1, %g1, 260
fjge_cont.40388:
	jmp	fjge_cont.40386
fjge_else.40385:
	fsub	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 260
	call	sin_sub.2497
	addi	%g1, %g1, 260
fjge_cont.40386:
fjge_cont.40378:
fjge_cont.40376:
	jmp	fjge_cont.40374
fjge_else.40373:
	fsub	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40389
	fjlt	%f1, %f13, fjge_else.40391
	fmov	%f0, %f1
	jmp	fjge_cont.40392
fjge_else.40391:
	fadd	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40393
	fjlt	%f1, %f13, fjge_else.40395
	fmov	%f0, %f1
	jmp	fjge_cont.40396
fjge_else.40395:
	fadd	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 260
	call	sin_sub.2497
	addi	%g1, %g1, 260
fjge_cont.40396:
	jmp	fjge_cont.40394
fjge_else.40393:
	fsub	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 260
	call	sin_sub.2497
	addi	%g1, %g1, 260
fjge_cont.40394:
fjge_cont.40392:
	jmp	fjge_cont.40390
fjge_else.40389:
	fsub	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40397
	fjlt	%f1, %f13, fjge_else.40399
	fmov	%f0, %f1
	jmp	fjge_cont.40400
fjge_else.40399:
	fadd	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 260
	call	sin_sub.2497
	addi	%g1, %g1, 260
fjge_cont.40400:
	jmp	fjge_cont.40398
fjge_else.40397:
	fsub	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 260
	call	sin_sub.2497
	addi	%g1, %g1, 260
fjge_cont.40398:
fjge_cont.40390:
fjge_cont.40374:
	fst	%f0, %g31, 344
	fjlt	%f4, %f0, fjge_else.40401
	fjlt	%f13, %f8, fjge_else.40403
	addi	%g10, %g0, 0
	jmp	fjge_cont.40404
fjge_else.40403:
	addi	%g10, %g0, 1
fjge_cont.40404:
	jmp	fjge_cont.40402
fjge_else.40401:
	fjlt	%f13, %f8, fjge_else.40405
	addi	%g10, %g0, 1
	jmp	fjge_cont.40406
fjge_else.40405:
	addi	%g10, %g0, 0
fjge_cont.40406:
fjge_cont.40402:
	st	%g10, %g31, 340
	fjlt	%f4, %f0, fjge_else.40407
	jmp	fjge_cont.40408
fjge_else.40407:
	fsub	%f0, %f10, %f0
fjge_cont.40408:
	fst	%f0, %g31, 336
	fjlt	%f12, %f0, fjge_else.40409
	jmp	fjge_cont.40410
fjge_else.40409:
	fsub	%f0, %f4, %f0
fjge_cont.40410:
	fst	%f0, %g31, 332
	fmul	%f0, %f0, %f11
	fmul	%f8, %f0, %f0
	fdiv	%f1, %f8, %f7
	fsub	%f1, %f6, %f1
	fdiv	%f1, %f8, %f1
	fsub	%f1, %f9, %f1
	fdiv	%f1, %f8, %f1
	fld	%f15, %g1, 244
	fsub	%f1, %f15, %f1
	fdiv	%f8, %f8, %f1
	fsub	%f8, %f3, %f8
	fdiv	%f0, %f0, %f8
	fst	%f0, %g31, 328
	fmul	%f8, %f5, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f3, %f0
	fdiv	%f0, %f8, %f0
	fst	%f0, %g31, 324
	jne	%g10, %g0, jeq_else.40411
	fneg	%f0, %f0
	jmp	jeq_cont.40412
jeq_else.40411:
jeq_cont.40412:
	fst	%f0, %g31, 320
	fld	%f8, %g1, 252
	fjlt	%f8, %f13, fjge_else.40413
	fmov	%f1, %f8
	jmp	fjge_cont.40414
fjge_else.40413:
	fneg	%f1, %f8
fjge_cont.40414:
	fst	%f1, %g31, 316
	fst	%f0, %g1, 256
	fjlt	%f10, %f1, fjge_else.40415
	fjlt	%f1, %f13, fjge_else.40417
	fmov	%f0, %f1
	jmp	fjge_cont.40418
fjge_else.40417:
	fadd	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40419
	fjlt	%f1, %f13, fjge_else.40421
	fmov	%f0, %f1
	jmp	fjge_cont.40422
fjge_else.40421:
	fadd	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40423
	fjlt	%f1, %f13, fjge_else.40425
	fmov	%f0, %f1
	jmp	fjge_cont.40426
fjge_else.40425:
	fadd	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 264
	call	sin_sub.2497
	addi	%g1, %g1, 264
fjge_cont.40426:
	jmp	fjge_cont.40424
fjge_else.40423:
	fsub	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 264
	call	sin_sub.2497
	addi	%g1, %g1, 264
fjge_cont.40424:
fjge_cont.40422:
	jmp	fjge_cont.40420
fjge_else.40419:
	fsub	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40427
	fjlt	%f1, %f13, fjge_else.40429
	fmov	%f0, %f1
	jmp	fjge_cont.40430
fjge_else.40429:
	fadd	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 264
	call	sin_sub.2497
	addi	%g1, %g1, 264
fjge_cont.40430:
	jmp	fjge_cont.40428
fjge_else.40427:
	fsub	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 264
	call	sin_sub.2497
	addi	%g1, %g1, 264
fjge_cont.40428:
fjge_cont.40420:
fjge_cont.40418:
	jmp	fjge_cont.40416
fjge_else.40415:
	fsub	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40431
	fjlt	%f1, %f13, fjge_else.40433
	fmov	%f0, %f1
	jmp	fjge_cont.40434
fjge_else.40433:
	fadd	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40435
	fjlt	%f1, %f13, fjge_else.40437
	fmov	%f0, %f1
	jmp	fjge_cont.40438
fjge_else.40437:
	fadd	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 264
	call	sin_sub.2497
	addi	%g1, %g1, 264
fjge_cont.40438:
	jmp	fjge_cont.40436
fjge_else.40435:
	fsub	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 264
	call	sin_sub.2497
	addi	%g1, %g1, 264
fjge_cont.40436:
fjge_cont.40434:
	jmp	fjge_cont.40432
fjge_else.40431:
	fsub	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40439
	fjlt	%f1, %f13, fjge_else.40441
	fmov	%f0, %f1
	jmp	fjge_cont.40442
fjge_else.40441:
	fadd	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 264
	call	sin_sub.2497
	addi	%g1, %g1, 264
fjge_cont.40442:
	jmp	fjge_cont.40440
fjge_else.40439:
	fsub	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 264
	call	sin_sub.2497
	addi	%g1, %g1, 264
fjge_cont.40440:
fjge_cont.40432:
fjge_cont.40416:
	fst	%f0, %g31, 312
	fjlt	%f4, %f0, fjge_else.40443
	fjlt	%f13, %f8, fjge_else.40445
	addi	%g10, %g0, 0
	jmp	fjge_cont.40446
fjge_else.40445:
	addi	%g10, %g0, 1
fjge_cont.40446:
	jmp	fjge_cont.40444
fjge_else.40443:
	fjlt	%f13, %f8, fjge_else.40447
	addi	%g10, %g0, 1
	jmp	fjge_cont.40448
fjge_else.40447:
	addi	%g10, %g0, 0
fjge_cont.40448:
fjge_cont.40444:
	st	%g10, %g31, 308
	fjlt	%f4, %f0, fjge_else.40449
	jmp	fjge_cont.40450
fjge_else.40449:
	fsub	%f0, %f10, %f0
fjge_cont.40450:
	fst	%f0, %g31, 304
	fjlt	%f12, %f0, fjge_else.40451
	jmp	fjge_cont.40452
fjge_else.40451:
	fsub	%f0, %f4, %f0
fjge_cont.40452:
	fst	%f0, %g31, 300
	fmul	%f0, %f0, %f11
	fmul	%f1, %f0, %f0
	fdiv	%f15, %f1, %f7
	fsub	%f15, %f6, %f15
	fdiv	%f15, %f1, %f15
	fsub	%f15, %f9, %f15
	fdiv	%f15, %f1, %f15
	fld	%f2, %g1, 244
	fsub	%f15, %f2, %f15
	fdiv	%f1, %f1, %f15
	fsub	%f1, %f3, %f1
	fdiv	%f0, %f0, %f1
	fst	%f0, %g31, 296
	fmul	%f1, %f5, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f3, %f0
	fdiv	%f0, %f1, %f0
	fst	%f0, %g31, 292
	jne	%g10, %g0, jeq_else.40453
	fneg	%f0, %f0
	jmp	jeq_cont.40454
jeq_else.40453:
jeq_cont.40454:
	fst	%f0, %g31, 288
	fld	%f1, %g1, 240
	fmul	%f15, %f1, %f0
	setL %g10, l.34410
	fld	%f8, %g10, 0
	fmul	%f15, %f15, %f8
	ld	%g10, %g1, 88
	fst	%f15, %g10, 0
	setL %g11, l.34413
	fld	%f15, %g11, 0
	fld	%f5, %g1, 248
	fmul	%f15, %f5, %f15
	fst	%f15, %g10, -4
	fst	%f3, %g1, 260
	fld	%f15, %g1, 256
	fmul	%f3, %f1, %f15
	fmul	%f3, %f3, %f8
	fst	%f3, %g10, -8
	ld	%g11, %g1, 80
	fst	%f15, %g11, 0
	fst	%f13, %g11, -4
	fneg	%f3, %f0
	fst	%f3, %g11, -8
	fneg	%f3, %f5
	fmul	%f0, %f3, %f0
	ld	%g11, %g1, 84
	fst	%f0, %g11, 0
	fneg	%f0, %f1
	fst	%f0, %g11, -4
	fmul	%f0, %f3, %f15
	fst	%f0, %g11, -8
	ld	%g12, %g1, 36
	fld	%f0, %g12, 0
	fld	%f1, %g10, 0
	fsub	%f0, %f0, %f1
	ld	%g13, %g1, 40
	fst	%f0, %g13, 0
	fld	%f0, %g12, -4
	fld	%f1, %g10, -4
	fsub	%f0, %f0, %f1
	fst	%f0, %g13, -4
	fld	%f0, %g12, -8
	fld	%f1, %g10, -8
	fsub	%f0, %f0, %f1
	fst	%f0, %g13, -8
	addi	%g12, %g0, 0
	ld	%g13, %g1, 0
	st	%g12, %g13, 0
	addi	%g12, %g0, 0
	ld	%g14, %g1, 4
	st	%g12, %g14, 0
	input	%g3
	st	%g3, %g31, 284
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40455
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40457
	addi	%g4, %g0, 0
	jmp	jle_cont.40458
jle_else.40457:
	addi	%g4, %g0, 1
jle_cont.40458:
	jmp	jle_cont.40456
jle_else.40455:
	addi	%g4, %g0, 1
jle_cont.40456:
	st	%g4, %g31, 280
	jne	%g4, %g0, jeq_else.40459
	ld	%g4, %g14, 0
	jne	%g4, %g0, jeq_else.40461
	addi	%g4, %g0, 1
	st	%g4, %g14, 0
	jmp	jeq_cont.40462
jeq_else.40461:
jeq_cont.40462:
	ld	%g4, %g13, 0
	slli	%g17, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g17, %g4
	subi	%g17, %g3, 48
	add	%g4, %g4, %g17
	st	%g4, %g13, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 268
	call	read_int_token.2507
	addi	%g1, %g1, 268
	mov	%g10, %g3
	jmp	jeq_cont.40460
jeq_else.40459:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 268
	call	read_int_token.2507
	addi	%g1, %g1, 268
	mov	%g10, %g3
jeq_cont.40460:
	st	%g10, %g31, 276
	addi	%g10, %g0, 0
	ld	%g11, %g1, 8
	st	%g10, %g11, 0
	addi	%g10, %g0, 0
	ld	%g12, %g1, 12
	st	%g10, %g12, 0
	addi	%g10, %g0, 1
	st	%g10, %g15, 0
	addi	%g10, %g0, 0
	st	%g10, %g16, 0
	input	%g3
	st	%g3, %g31, 272
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40463
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40465
	addi	%g4, %g0, 0
	jmp	jle_cont.40466
jle_else.40465:
	addi	%g4, %g0, 1
jle_cont.40466:
	jmp	jle_cont.40464
jle_else.40463:
	addi	%g4, %g0, 1
jle_cont.40464:
	st	%g4, %g31, 268
	jne	%g4, %g0, jeq_else.40467
	ld	%g4, %g16, 0
	jne	%g4, %g0, jeq_else.40469
	addi	%g4, %g0, 1
	st	%g4, %g16, 0
	jmp	jeq_cont.40470
jeq_else.40469:
jeq_cont.40470:
	ld	%g4, %g11, 0
	slli	%g17, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g17, %g4
	subi	%g17, %g3, 48
	add	%g4, %g4, %g17
	st	%g4, %g11, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 268
	call	read_float_token1.2516
	addi	%g1, %g1, 268
	mov	%g10, %g3
	jmp	jeq_cont.40468
jeq_else.40467:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 268
	call	read_float_token1.2516
	addi	%g1, %g1, 268
	mov	%g10, %g3
jeq_cont.40468:
	st	%g10, %g31, 264
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.40471
	input	%g3
	addi	%g17, %g0, 48
	jlt	%g3, %g17, jle_else.40473
	addi	%g17, %g0, 57
	jlt	%g17, %g3, jle_else.40475
	addi	%g17, %g0, 0
	jmp	jle_cont.40476
jle_else.40475:
	addi	%g17, %g0, 1
jle_cont.40476:
	jmp	jle_cont.40474
jle_else.40473:
	addi	%g17, %g0, 1
jle_cont.40474:
	jne	%g17, %g0, jeq_else.40477
	ld	%g17, %g1, 12
	ld	%g18, %g17, 0
	slli	%g19, %g18, 3
	slli	%g18, %g18, 1
	add	%g18, %g19, %g18
	subi	%g3, %g3, 48
	add	%g3, %g18, %g3
	st	%g3, %g17, 0
	ld	%g3, %g15, 0
	slli	%g18, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g18, %g3
	st	%g3, %g15, 0
	addi	%g3, %g0, 1
	subi	%g1, %g1, 268
	call	read_float_token2.2519
	addi	%g1, %g1, 268
	jmp	jeq_cont.40478
jeq_else.40477:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 268
	call	read_float_token2.2519
	addi	%g1, %g1, 268
jeq_cont.40478:
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 268
	call	min_caml_float_of_int
	addi	%g1, %g1, 268
	fmov	%f15, %f0, 0
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 268
	call	min_caml_float_of_int
	addi	%g1, %g1, 268
	fmov	%f3, %f0, 0
	ld	%g3, %g15, 0
	subi	%g1, %g1, 268
	call	min_caml_float_of_int
	addi	%g1, %g1, 268
	fdiv	%f0, %f3, %f0
	fadd	%f0, %f15, %f0
	jmp	jeq_cont.40472
jeq_else.40471:
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 268
	call	min_caml_float_of_int
	addi	%g1, %g1, 268
jeq_cont.40472:
	fst	%f0, %g31, 260
	ld	%g10, %g16, 0
	jne	%g10, %g28, jeq_else.40479
	jmp	jeq_cont.40480
jeq_else.40479:
	fneg	%f0, %f0
jeq_cont.40480:
	fmul	%f0, %f0, %f14
	fst	%f0, %g31, 256
	fjlt	%f0, %f13, fjge_else.40481
	fmov	%f3, %f0
	jmp	fjge_cont.40482
fjge_else.40481:
	fneg	%f3, %f0
fjge_cont.40482:
	fst	%f3, %g31, 252
	fst	%f0, %g1, 264
	fjlt	%f10, %f3, fjge_else.40483
	fjlt	%f3, %f13, fjge_else.40485
	fmov	%f0, %f3
	jmp	fjge_cont.40486
fjge_else.40485:
	fadd	%f3, %f3, %f10
	fjlt	%f10, %f3, fjge_else.40487
	fjlt	%f3, %f13, fjge_else.40489
	fmov	%f0, %f3
	jmp	fjge_cont.40490
fjge_else.40489:
	fadd	%f3, %f3, %f10
	fjlt	%f10, %f3, fjge_else.40491
	fjlt	%f3, %f13, fjge_else.40493
	fmov	%f0, %f3
	jmp	fjge_cont.40494
fjge_else.40493:
	fadd	%f3, %f3, %f10
	fmov	%f0, %f3
	subi	%g1, %g1, 272
	call	sin_sub.2497
	addi	%g1, %g1, 272
fjge_cont.40494:
	jmp	fjge_cont.40492
fjge_else.40491:
	fsub	%f3, %f3, %f10
	fmov	%f0, %f3
	subi	%g1, %g1, 272
	call	sin_sub.2497
	addi	%g1, %g1, 272
fjge_cont.40492:
fjge_cont.40490:
	jmp	fjge_cont.40488
fjge_else.40487:
	fsub	%f3, %f3, %f10
	fjlt	%f10, %f3, fjge_else.40495
	fjlt	%f3, %f13, fjge_else.40497
	fmov	%f0, %f3
	jmp	fjge_cont.40498
fjge_else.40497:
	fadd	%f3, %f3, %f10
	fmov	%f0, %f3
	subi	%g1, %g1, 272
	call	sin_sub.2497
	addi	%g1, %g1, 272
fjge_cont.40498:
	jmp	fjge_cont.40496
fjge_else.40495:
	fsub	%f3, %f3, %f10
	fmov	%f0, %f3
	subi	%g1, %g1, 272
	call	sin_sub.2497
	addi	%g1, %g1, 272
fjge_cont.40496:
fjge_cont.40488:
fjge_cont.40486:
	jmp	fjge_cont.40484
fjge_else.40483:
	fsub	%f3, %f3, %f10
	fjlt	%f10, %f3, fjge_else.40499
	fjlt	%f3, %f13, fjge_else.40501
	fmov	%f0, %f3
	jmp	fjge_cont.40502
fjge_else.40501:
	fadd	%f3, %f3, %f10
	fjlt	%f10, %f3, fjge_else.40503
	fjlt	%f3, %f13, fjge_else.40505
	fmov	%f0, %f3
	jmp	fjge_cont.40506
fjge_else.40505:
	fadd	%f3, %f3, %f10
	fmov	%f0, %f3
	subi	%g1, %g1, 272
	call	sin_sub.2497
	addi	%g1, %g1, 272
fjge_cont.40506:
	jmp	fjge_cont.40504
fjge_else.40503:
	fsub	%f3, %f3, %f10
	fmov	%f0, %f3
	subi	%g1, %g1, 272
	call	sin_sub.2497
	addi	%g1, %g1, 272
fjge_cont.40504:
fjge_cont.40502:
	jmp	fjge_cont.40500
fjge_else.40499:
	fsub	%f3, %f3, %f10
	fjlt	%f10, %f3, fjge_else.40507
	fjlt	%f3, %f13, fjge_else.40509
	fmov	%f0, %f3
	jmp	fjge_cont.40510
fjge_else.40509:
	fadd	%f3, %f3, %f10
	fmov	%f0, %f3
	subi	%g1, %g1, 272
	call	sin_sub.2497
	addi	%g1, %g1, 272
fjge_cont.40510:
	jmp	fjge_cont.40508
fjge_else.40507:
	fsub	%f3, %f3, %f10
	fmov	%f0, %f3
	subi	%g1, %g1, 272
	call	sin_sub.2497
	addi	%g1, %g1, 272
fjge_cont.40508:
fjge_cont.40500:
fjge_cont.40484:
	fst	%f0, %g31, 248
	fjlt	%f4, %f0, fjge_else.40511
	fld	%f1, %g1, 264
	fjlt	%f13, %f1, fjge_else.40513
	addi	%g10, %g0, 0
	jmp	fjge_cont.40514
fjge_else.40513:
	addi	%g10, %g0, 1
fjge_cont.40514:
	jmp	fjge_cont.40512
fjge_else.40511:
	fld	%f1, %g1, 264
	fjlt	%f13, %f1, fjge_else.40515
	addi	%g10, %g0, 1
	jmp	fjge_cont.40516
fjge_else.40515:
	addi	%g10, %g0, 0
fjge_cont.40516:
fjge_cont.40512:
	st	%g10, %g31, 244
	fjlt	%f4, %f0, fjge_else.40517
	jmp	fjge_cont.40518
fjge_else.40517:
	fsub	%f0, %f10, %f0
fjge_cont.40518:
	fst	%f0, %g31, 240
	fjlt	%f12, %f0, fjge_else.40519
	jmp	fjge_cont.40520
fjge_else.40519:
	fsub	%f0, %f4, %f0
fjge_cont.40520:
	fst	%f0, %g31, 236
	fmul	%f0, %f0, %f11
	fmul	%f15, %f0, %f0
	fdiv	%f2, %f15, %f7
	fsub	%f2, %f6, %f2
	fdiv	%f2, %f15, %f2
	fsub	%f2, %f9, %f2
	fdiv	%f2, %f15, %f2
	fld	%f3, %g1, 244
	fsub	%f2, %f3, %f2
	fdiv	%f15, %f15, %f2
	fld	%f2, %g1, 260
	fsub	%f15, %f2, %f15
	fdiv	%f0, %f0, %f15
	fst	%f0, %g31, 232
	fld	%f15, %g1, 120
	fmul	%f5, %f15, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f2, %f0
	fdiv	%f0, %f5, %f0
	fst	%f0, %g31, 228
	jne	%g10, %g0, jeq_else.40521
	fneg	%f0, %f0
	jmp	jeq_cont.40522
jeq_else.40521:
jeq_cont.40522:
	fst	%f0, %g31, 224
	fneg	%f0, %f0
	ld	%g10, %g1, 44
	fst	%f0, %g10, -4
	addi	%g11, %g0, 0
	ld	%g12, %g1, 8
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 12
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	st	%g11, %g15, 0
	addi	%g11, %g0, 0
	st	%g11, %g16, 0
	input	%g3
	st	%g3, %g31, 220
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40523
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40525
	addi	%g4, %g0, 0
	jmp	jle_cont.40526
jle_else.40525:
	addi	%g4, %g0, 1
jle_cont.40526:
	jmp	jle_cont.40524
jle_else.40523:
	addi	%g4, %g0, 1
jle_cont.40524:
	st	%g4, %g31, 216
	jne	%g4, %g0, jeq_else.40527
	ld	%g4, %g16, 0
	jne	%g4, %g0, jeq_else.40529
	addi	%g4, %g0, 1
	st	%g4, %g16, 0
	jmp	jeq_cont.40530
jeq_else.40529:
jeq_cont.40530:
	ld	%g4, %g12, 0
	slli	%g17, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g17, %g4
	subi	%g17, %g3, 48
	add	%g4, %g4, %g17
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 272
	call	read_float_token1.2516
	addi	%g1, %g1, 272
	mov	%g10, %g3
	jmp	jeq_cont.40528
jeq_else.40527:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 272
	call	read_float_token1.2516
	addi	%g1, %g1, 272
	mov	%g10, %g3
jeq_cont.40528:
	st	%g10, %g31, 212
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.40531
	input	%g3
	addi	%g17, %g0, 48
	jlt	%g3, %g17, jle_else.40533
	addi	%g17, %g0, 57
	jlt	%g17, %g3, jle_else.40535
	addi	%g17, %g0, 0
	jmp	jle_cont.40536
jle_else.40535:
	addi	%g17, %g0, 1
jle_cont.40536:
	jmp	jle_cont.40534
jle_else.40533:
	addi	%g17, %g0, 1
jle_cont.40534:
	jne	%g17, %g0, jeq_else.40537
	ld	%g17, %g1, 12
	ld	%g18, %g17, 0
	slli	%g19, %g18, 3
	slli	%g18, %g18, 1
	add	%g18, %g19, %g18
	subi	%g3, %g3, 48
	add	%g3, %g18, %g3
	st	%g3, %g17, 0
	ld	%g3, %g15, 0
	slli	%g18, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g18, %g3
	st	%g3, %g15, 0
	addi	%g3, %g0, 1
	subi	%g1, %g1, 272
	call	read_float_token2.2519
	addi	%g1, %g1, 272
	jmp	jeq_cont.40538
jeq_else.40537:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 272
	call	read_float_token2.2519
	addi	%g1, %g1, 272
jeq_cont.40538:
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 272
	call	min_caml_float_of_int
	addi	%g1, %g1, 272
	fmov	%f15, %f0, 0
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 272
	call	min_caml_float_of_int
	addi	%g1, %g1, 272
	fmov	%f5, %f0, 0
	ld	%g3, %g15, 0
	subi	%g1, %g1, 272
	call	min_caml_float_of_int
	addi	%g1, %g1, 272
	fdiv	%f0, %f5, %f0
	fadd	%f0, %f15, %f0
	jmp	jeq_cont.40532
jeq_else.40531:
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 272
	call	min_caml_float_of_int
	addi	%g1, %g1, 272
jeq_cont.40532:
	fst	%f0, %g31, 208
	ld	%g10, %g16, 0
	jne	%g10, %g28, jeq_else.40539
	jmp	jeq_cont.40540
jeq_else.40539:
	fneg	%f0, %f0
jeq_cont.40540:
	fmul	%f0, %f0, %f14
	fst	%f0, %g31, 204
	fld	%f14, %g1, 264
	fsub	%f14, %f12, %f14
	fjlt	%f14, %f13, fjge_else.40541
	fmov	%f5, %f14
	jmp	fjge_cont.40542
fjge_else.40541:
	fneg	%f5, %f14
fjge_cont.40542:
	fst	%f5, %g31, 200
	fst	%f0, %g1, 268
	fjlt	%f10, %f5, fjge_else.40543
	fjlt	%f5, %f13, fjge_else.40545
	fmov	%f0, %f5
	jmp	fjge_cont.40546
fjge_else.40545:
	fadd	%f5, %f5, %f10
	fjlt	%f10, %f5, fjge_else.40547
	fjlt	%f5, %f13, fjge_else.40549
	fmov	%f0, %f5
	jmp	fjge_cont.40550
fjge_else.40549:
	fadd	%f5, %f5, %f10
	fjlt	%f10, %f5, fjge_else.40551
	fjlt	%f5, %f13, fjge_else.40553
	fmov	%f0, %f5
	jmp	fjge_cont.40554
fjge_else.40553:
	fadd	%f5, %f5, %f10
	fmov	%f0, %f5
	subi	%g1, %g1, 276
	call	sin_sub.2497
	addi	%g1, %g1, 276
fjge_cont.40554:
	jmp	fjge_cont.40552
fjge_else.40551:
	fsub	%f5, %f5, %f10
	fmov	%f0, %f5
	subi	%g1, %g1, 276
	call	sin_sub.2497
	addi	%g1, %g1, 276
fjge_cont.40552:
fjge_cont.40550:
	jmp	fjge_cont.40548
fjge_else.40547:
	fsub	%f5, %f5, %f10
	fjlt	%f10, %f5, fjge_else.40555
	fjlt	%f5, %f13, fjge_else.40557
	fmov	%f0, %f5
	jmp	fjge_cont.40558
fjge_else.40557:
	fadd	%f5, %f5, %f10
	fmov	%f0, %f5
	subi	%g1, %g1, 276
	call	sin_sub.2497
	addi	%g1, %g1, 276
fjge_cont.40558:
	jmp	fjge_cont.40556
fjge_else.40555:
	fsub	%f5, %f5, %f10
	fmov	%f0, %f5
	subi	%g1, %g1, 276
	call	sin_sub.2497
	addi	%g1, %g1, 276
fjge_cont.40556:
fjge_cont.40548:
fjge_cont.40546:
	jmp	fjge_cont.40544
fjge_else.40543:
	fsub	%f5, %f5, %f10
	fjlt	%f10, %f5, fjge_else.40559
	fjlt	%f5, %f13, fjge_else.40561
	fmov	%f0, %f5
	jmp	fjge_cont.40562
fjge_else.40561:
	fadd	%f5, %f5, %f10
	fjlt	%f10, %f5, fjge_else.40563
	fjlt	%f5, %f13, fjge_else.40565
	fmov	%f0, %f5
	jmp	fjge_cont.40566
fjge_else.40565:
	fadd	%f5, %f5, %f10
	fmov	%f0, %f5
	subi	%g1, %g1, 276
	call	sin_sub.2497
	addi	%g1, %g1, 276
fjge_cont.40566:
	jmp	fjge_cont.40564
fjge_else.40563:
	fsub	%f5, %f5, %f10
	fmov	%f0, %f5
	subi	%g1, %g1, 276
	call	sin_sub.2497
	addi	%g1, %g1, 276
fjge_cont.40564:
fjge_cont.40562:
	jmp	fjge_cont.40560
fjge_else.40559:
	fsub	%f5, %f5, %f10
	fjlt	%f10, %f5, fjge_else.40567
	fjlt	%f5, %f13, fjge_else.40569
	fmov	%f0, %f5
	jmp	fjge_cont.40570
fjge_else.40569:
	fadd	%f5, %f5, %f10
	fmov	%f0, %f5
	subi	%g1, %g1, 276
	call	sin_sub.2497
	addi	%g1, %g1, 276
fjge_cont.40570:
	jmp	fjge_cont.40568
fjge_else.40567:
	fsub	%f5, %f5, %f10
	fmov	%f0, %f5
	subi	%g1, %g1, 276
	call	sin_sub.2497
	addi	%g1, %g1, 276
fjge_cont.40568:
fjge_cont.40560:
fjge_cont.40544:
	fst	%f0, %g31, 196
	fjlt	%f4, %f0, fjge_else.40571
	fjlt	%f13, %f14, fjge_else.40573
	addi	%g10, %g0, 0
	jmp	fjge_cont.40574
fjge_else.40573:
	addi	%g10, %g0, 1
fjge_cont.40574:
	jmp	fjge_cont.40572
fjge_else.40571:
	fjlt	%f13, %f14, fjge_else.40575
	addi	%g10, %g0, 1
	jmp	fjge_cont.40576
fjge_else.40575:
	addi	%g10, %g0, 0
fjge_cont.40576:
fjge_cont.40572:
	st	%g10, %g31, 192
	fjlt	%f4, %f0, fjge_else.40577
	jmp	fjge_cont.40578
fjge_else.40577:
	fsub	%f0, %f10, %f0
fjge_cont.40578:
	fst	%f0, %g31, 188
	fjlt	%f12, %f0, fjge_else.40579
	jmp	fjge_cont.40580
fjge_else.40579:
	fsub	%f0, %f4, %f0
fjge_cont.40580:
	fst	%f0, %g31, 184
	fmul	%f0, %f0, %f11
	fmul	%f14, %f0, %f0
	fdiv	%f5, %f14, %f7
	fsub	%f5, %f6, %f5
	fdiv	%f5, %f14, %f5
	fsub	%f5, %f9, %f5
	fdiv	%f5, %f14, %f5
	fsub	%f5, %f3, %f5
	fdiv	%f14, %f14, %f5
	fld	%f5, %g1, 260
	fsub	%f14, %f5, %f14
	fdiv	%f0, %f0, %f14
	fst	%f0, %g31, 180
	fld	%f14, %g1, 120
	fmul	%f8, %f14, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f5, %f0
	fdiv	%f0, %f8, %f0
	fst	%f0, %g31, 176
	jne	%g10, %g0, jeq_else.40581
	fneg	%f0, %f0
	jmp	jeq_cont.40582
jeq_else.40581:
jeq_cont.40582:
	fst	%f0, %g31, 172
	fld	%f8, %g1, 268
	fjlt	%f8, %f13, fjge_else.40583
	fmov	%f1, %f8
	jmp	fjge_cont.40584
fjge_else.40583:
	fneg	%f1, %f8
fjge_cont.40584:
	fst	%f1, %g31, 168
	fst	%f0, %g1, 272
	fjlt	%f10, %f1, fjge_else.40585
	fjlt	%f1, %f13, fjge_else.40587
	fmov	%f0, %f1
	jmp	fjge_cont.40588
fjge_else.40587:
	fadd	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40589
	fjlt	%f1, %f13, fjge_else.40591
	fmov	%f0, %f1
	jmp	fjge_cont.40592
fjge_else.40591:
	fadd	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40593
	fjlt	%f1, %f13, fjge_else.40595
	fmov	%f0, %f1
	jmp	fjge_cont.40596
fjge_else.40595:
	fadd	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 280
	call	sin_sub.2497
	addi	%g1, %g1, 280
fjge_cont.40596:
	jmp	fjge_cont.40594
fjge_else.40593:
	fsub	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 280
	call	sin_sub.2497
	addi	%g1, %g1, 280
fjge_cont.40594:
fjge_cont.40592:
	jmp	fjge_cont.40590
fjge_else.40589:
	fsub	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40597
	fjlt	%f1, %f13, fjge_else.40599
	fmov	%f0, %f1
	jmp	fjge_cont.40600
fjge_else.40599:
	fadd	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 280
	call	sin_sub.2497
	addi	%g1, %g1, 280
fjge_cont.40600:
	jmp	fjge_cont.40598
fjge_else.40597:
	fsub	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 280
	call	sin_sub.2497
	addi	%g1, %g1, 280
fjge_cont.40598:
fjge_cont.40590:
fjge_cont.40588:
	jmp	fjge_cont.40586
fjge_else.40585:
	fsub	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40601
	fjlt	%f1, %f13, fjge_else.40603
	fmov	%f0, %f1
	jmp	fjge_cont.40604
fjge_else.40603:
	fadd	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40605
	fjlt	%f1, %f13, fjge_else.40607
	fmov	%f0, %f1
	jmp	fjge_cont.40608
fjge_else.40607:
	fadd	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 280
	call	sin_sub.2497
	addi	%g1, %g1, 280
fjge_cont.40608:
	jmp	fjge_cont.40606
fjge_else.40605:
	fsub	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 280
	call	sin_sub.2497
	addi	%g1, %g1, 280
fjge_cont.40606:
fjge_cont.40604:
	jmp	fjge_cont.40602
fjge_else.40601:
	fsub	%f1, %f1, %f10
	fjlt	%f10, %f1, fjge_else.40609
	fjlt	%f1, %f13, fjge_else.40611
	fmov	%f0, %f1
	jmp	fjge_cont.40612
fjge_else.40611:
	fadd	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 280
	call	sin_sub.2497
	addi	%g1, %g1, 280
fjge_cont.40612:
	jmp	fjge_cont.40610
fjge_else.40609:
	fsub	%f1, %f1, %f10
	fmov	%f0, %f1
	subi	%g1, %g1, 280
	call	sin_sub.2497
	addi	%g1, %g1, 280
fjge_cont.40610:
fjge_cont.40602:
fjge_cont.40586:
	fst	%f0, %g31, 164
	fjlt	%f4, %f0, fjge_else.40613
	fjlt	%f13, %f8, fjge_else.40615
	addi	%g10, %g0, 0
	jmp	fjge_cont.40616
fjge_else.40615:
	addi	%g10, %g0, 1
fjge_cont.40616:
	jmp	fjge_cont.40614
fjge_else.40613:
	fjlt	%f13, %f8, fjge_else.40617
	addi	%g10, %g0, 1
	jmp	fjge_cont.40618
fjge_else.40617:
	addi	%g10, %g0, 0
fjge_cont.40618:
fjge_cont.40614:
	st	%g10, %g31, 160
	fjlt	%f4, %f0, fjge_else.40619
	jmp	fjge_cont.40620
fjge_else.40619:
	fsub	%f0, %f10, %f0
fjge_cont.40620:
	fst	%f0, %g31, 156
	fjlt	%f12, %f0, fjge_else.40621
	jmp	fjge_cont.40622
fjge_else.40621:
	fsub	%f0, %f4, %f0
fjge_cont.40622:
	fst	%f0, %g31, 152
	fmul	%f0, %f0, %f11
	fmul	%f1, %f0, %f0
	fdiv	%f15, %f1, %f7
	fsub	%f15, %f6, %f15
	fdiv	%f15, %f1, %f15
	fsub	%f15, %f9, %f15
	fdiv	%f15, %f1, %f15
	fsub	%f15, %f3, %f15
	fdiv	%f1, %f1, %f15
	fsub	%f1, %f5, %f1
	fdiv	%f0, %f0, %f1
	fst	%f0, %g31, 148
	fmul	%f1, %f14, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f5, %f0
	fdiv	%f0, %f1, %f0
	fst	%f0, %g31, 144
	jne	%g10, %g0, jeq_else.40623
	fneg	%f0, %f0
	jmp	jeq_cont.40624
jeq_else.40623:
jeq_cont.40624:
	fst	%f0, %g31, 140
	fld	%f1, %g1, 272
	fmul	%f0, %f1, %f0
	ld	%g10, %g1, 44
	fst	%f0, %g10, 0
	fsub	%f0, %f12, %f8
	fjlt	%f0, %f13, fjge_else.40625
	fmov	%f8, %f0
	jmp	fjge_cont.40626
fjge_else.40625:
	fneg	%f8, %f0
fjge_cont.40626:
	fst	%f8, %g31, 136
	fst	%f0, %g1, 276
	fjlt	%f10, %f8, fjge_else.40627
	fjlt	%f8, %f13, fjge_else.40629
	fmov	%f0, %f8
	jmp	fjge_cont.40630
fjge_else.40629:
	fadd	%f8, %f8, %f10
	fjlt	%f10, %f8, fjge_else.40631
	fjlt	%f8, %f13, fjge_else.40633
	fmov	%f0, %f8
	jmp	fjge_cont.40634
fjge_else.40633:
	fadd	%f8, %f8, %f10
	fjlt	%f10, %f8, fjge_else.40635
	fjlt	%f8, %f13, fjge_else.40637
	fmov	%f0, %f8
	jmp	fjge_cont.40638
fjge_else.40637:
	fadd	%f8, %f8, %f10
	fmov	%f0, %f8
	subi	%g1, %g1, 284
	call	sin_sub.2497
	addi	%g1, %g1, 284
fjge_cont.40638:
	jmp	fjge_cont.40636
fjge_else.40635:
	fsub	%f8, %f8, %f10
	fmov	%f0, %f8
	subi	%g1, %g1, 284
	call	sin_sub.2497
	addi	%g1, %g1, 284
fjge_cont.40636:
fjge_cont.40634:
	jmp	fjge_cont.40632
fjge_else.40631:
	fsub	%f8, %f8, %f10
	fjlt	%f10, %f8, fjge_else.40639
	fjlt	%f8, %f13, fjge_else.40641
	fmov	%f0, %f8
	jmp	fjge_cont.40642
fjge_else.40641:
	fadd	%f8, %f8, %f10
	fmov	%f0, %f8
	subi	%g1, %g1, 284
	call	sin_sub.2497
	addi	%g1, %g1, 284
fjge_cont.40642:
	jmp	fjge_cont.40640
fjge_else.40639:
	fsub	%f8, %f8, %f10
	fmov	%f0, %f8
	subi	%g1, %g1, 284
	call	sin_sub.2497
	addi	%g1, %g1, 284
fjge_cont.40640:
fjge_cont.40632:
fjge_cont.40630:
	jmp	fjge_cont.40628
fjge_else.40627:
	fsub	%f8, %f8, %f10
	fjlt	%f10, %f8, fjge_else.40643
	fjlt	%f8, %f13, fjge_else.40645
	fmov	%f0, %f8
	jmp	fjge_cont.40646
fjge_else.40645:
	fadd	%f8, %f8, %f10
	fjlt	%f10, %f8, fjge_else.40647
	fjlt	%f8, %f13, fjge_else.40649
	fmov	%f0, %f8
	jmp	fjge_cont.40650
fjge_else.40649:
	fadd	%f8, %f8, %f10
	fmov	%f0, %f8
	subi	%g1, %g1, 284
	call	sin_sub.2497
	addi	%g1, %g1, 284
fjge_cont.40650:
	jmp	fjge_cont.40648
fjge_else.40647:
	fsub	%f8, %f8, %f10
	fmov	%f0, %f8
	subi	%g1, %g1, 284
	call	sin_sub.2497
	addi	%g1, %g1, 284
fjge_cont.40648:
fjge_cont.40646:
	jmp	fjge_cont.40644
fjge_else.40643:
	fsub	%f8, %f8, %f10
	fjlt	%f10, %f8, fjge_else.40651
	fjlt	%f8, %f13, fjge_else.40653
	fmov	%f0, %f8
	jmp	fjge_cont.40654
fjge_else.40653:
	fadd	%f8, %f8, %f10
	fmov	%f0, %f8
	subi	%g1, %g1, 284
	call	sin_sub.2497
	addi	%g1, %g1, 284
fjge_cont.40654:
	jmp	fjge_cont.40652
fjge_else.40651:
	fsub	%f8, %f8, %f10
	fmov	%f0, %f8
	subi	%g1, %g1, 284
	call	sin_sub.2497
	addi	%g1, %g1, 284
fjge_cont.40652:
fjge_cont.40644:
fjge_cont.40628:
	fst	%f0, %g31, 132
	fjlt	%f4, %f0, fjge_else.40655
	fld	%f1, %g1, 276
	fjlt	%f13, %f1, fjge_else.40657
	addi	%g11, %g0, 0
	jmp	fjge_cont.40658
fjge_else.40657:
	addi	%g11, %g0, 1
fjge_cont.40658:
	jmp	fjge_cont.40656
fjge_else.40655:
	fld	%f1, %g1, 276
	fjlt	%f13, %f1, fjge_else.40659
	addi	%g11, %g0, 1
	jmp	fjge_cont.40660
fjge_else.40659:
	addi	%g11, %g0, 0
fjge_cont.40660:
fjge_cont.40656:
	st	%g11, %g31, 128
	fjlt	%f4, %f0, fjge_else.40661
	jmp	fjge_cont.40662
fjge_else.40661:
	fsub	%f0, %f10, %f0
fjge_cont.40662:
	fst	%f0, %g31, 124
	fjlt	%f12, %f0, fjge_else.40663
	jmp	fjge_cont.40664
fjge_else.40663:
	fsub	%f0, %f4, %f0
fjge_cont.40664:
	fst	%f0, %g31, 120
	fmul	%f0, %f0, %f11
	fmul	%f1, %f0, %f0
	fdiv	%f10, %f1, %f7
	fsub	%f10, %f6, %f10
	fdiv	%f10, %f1, %f10
	fsub	%f10, %f9, %f10
	fdiv	%f10, %f1, %f10
	fsub	%f10, %f3, %f10
	fdiv	%f1, %f1, %f10
	fsub	%f1, %f5, %f1
	fdiv	%f0, %f0, %f1
	fst	%f0, %g31, 116
	fmul	%f1, %f14, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f5, %f0
	fdiv	%f0, %f1, %f0
	fst	%f0, %g31, 112
	jne	%g11, %g0, jeq_else.40665
	fneg	%f0, %f0
	jmp	jeq_cont.40666
jeq_else.40665:
jeq_cont.40666:
	fst	%f0, %g31, 108
	fld	%f1, %g1, 272
	fmul	%f0, %f1, %f0
	fst	%f0, %g10, -8
	addi	%g11, %g0, 0
	ld	%g12, %g1, 8
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 12
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	st	%g11, %g15, 0
	addi	%g11, %g0, 0
	st	%g11, %g16, 0
	input	%g3
	st	%g3, %g31, 104
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40667
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40669
	addi	%g4, %g0, 0
	jmp	jle_cont.40670
jle_else.40669:
	addi	%g4, %g0, 1
jle_cont.40670:
	jmp	jle_cont.40668
jle_else.40667:
	addi	%g4, %g0, 1
jle_cont.40668:
	st	%g4, %g31, 100
	jne	%g4, %g0, jeq_else.40671
	ld	%g4, %g16, 0
	jne	%g4, %g0, jeq_else.40673
	addi	%g4, %g0, 1
	st	%g4, %g16, 0
	jmp	jeq_cont.40674
jeq_else.40673:
jeq_cont.40674:
	ld	%g4, %g12, 0
	slli	%g17, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g17, %g4
	subi	%g17, %g3, 48
	add	%g4, %g4, %g17
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 284
	call	read_float_token1.2516
	addi	%g1, %g1, 284
	mov	%g10, %g3
	jmp	jeq_cont.40672
jeq_else.40671:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 284
	call	read_float_token1.2516
	addi	%g1, %g1, 284
	mov	%g10, %g3
jeq_cont.40672:
	st	%g10, %g31, 96
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.40675
	input	%g3
	addi	%g17, %g0, 48
	jlt	%g3, %g17, jle_else.40677
	addi	%g17, %g0, 57
	jlt	%g17, %g3, jle_else.40679
	addi	%g17, %g0, 0
	jmp	jle_cont.40680
jle_else.40679:
	addi	%g17, %g0, 1
jle_cont.40680:
	jmp	jle_cont.40678
jle_else.40677:
	addi	%g17, %g0, 1
jle_cont.40678:
	jne	%g17, %g0, jeq_else.40681
	ld	%g17, %g1, 12
	ld	%g18, %g17, 0
	slli	%g19, %g18, 3
	slli	%g18, %g18, 1
	add	%g18, %g19, %g18
	subi	%g3, %g3, 48
	add	%g3, %g18, %g3
	st	%g3, %g17, 0
	ld	%g3, %g15, 0
	slli	%g18, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g18, %g3
	st	%g3, %g15, 0
	addi	%g3, %g0, 1
	subi	%g1, %g1, 284
	call	read_float_token2.2519
	addi	%g1, %g1, 284
	jmp	jeq_cont.40682
jeq_else.40681:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 284
	call	read_float_token2.2519
	addi	%g1, %g1, 284
jeq_cont.40682:
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	subi	%g1, %g1, 284
	call	min_caml_float_of_int
	addi	%g1, %g1, 284
	fmov	%f10, %f0, 0
	ld	%g3, %g1, 12
	ld	%g3, %g3, 0
	subi	%g1, %g1, 284
	call	min_caml_float_of_int
	addi	%g1, %g1, 284
	fmov	%f11, %f0, 0
	ld	%g3, %g15, 0
	subi	%g1, %g1, 284
	call	min_caml_float_of_int
	addi	%g1, %g1, 284
	fdiv	%f0, %f11, %f0
	fadd	%f0, %f10, %f0
	jmp	jeq_cont.40676
jeq_else.40675:
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	subi	%g1, %g1, 284
	call	min_caml_float_of_int
	addi	%g1, %g1, 284
jeq_cont.40676:
	fst	%f0, %g31, 92
	ld	%g3, %g16, 0
	jne	%g3, %g28, jeq_else.40683
	jmp	jeq_cont.40684
jeq_else.40683:
	fneg	%f0, %f0
jeq_cont.40684:
	ld	%g3, %g1, 48
	fst	%f0, %g3, 0
	addi	%g3, %g0, 0
	fst	%f13, %g1, 280
	subi	%g1, %g1, 288
	call	read_object.2696
	addi	%g1, %g1, 288
	addi	%g10, %g0, 0
	ld	%g11, %g1, 0
	st	%g10, %g11, 0
	addi	%g10, %g0, 0
	ld	%g12, %g1, 4
	st	%g10, %g12, 0
	input	%g3
	st	%g3, %g31, 88
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40685
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40687
	addi	%g4, %g0, 0
	jmp	jle_cont.40688
jle_else.40687:
	addi	%g4, %g0, 1
jle_cont.40688:
	jmp	jle_cont.40686
jle_else.40685:
	addi	%g4, %g0, 1
jle_cont.40686:
	st	%g4, %g31, 84
	jne	%g4, %g0, jeq_else.40689
	ld	%g4, %g12, 0
	jne	%g4, %g0, jeq_else.40691
	addi	%g4, %g0, 1
	st	%g4, %g12, 0
	jmp	jeq_cont.40692
jeq_else.40691:
jeq_cont.40692:
	ld	%g4, %g11, 0
	slli	%g15, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g15, %g4
	subi	%g15, %g3, 48
	add	%g4, %g4, %g15
	st	%g4, %g11, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 288
	call	read_int_token.2507
	addi	%g1, %g1, 288
	jmp	jeq_cont.40690
jeq_else.40689:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 288
	call	read_int_token.2507
	addi	%g1, %g1, 288
jeq_cont.40690:
	st	%g3, %g31, 80
	jne	%g3, %g29, jeq_else.40693
	addi	%g3, %g0, 1
	addi	%g4, %g0, -1
	subi	%g1, %g1, 288
	call	min_caml_create_array
	addi	%g1, %g1, 288
	jmp	jeq_cont.40694
jeq_else.40693:
	addi	%g16, %g0, 1
	st	%g3, %g1, 284
	mov	%g3, %g16
	subi	%g1, %g1, 292
	call	read_net_item.2700
	addi	%g1, %g1, 292
	ld	%g17, %g1, 284
	st	%g17, %g3, 0
jeq_cont.40694:
	st	%g3, %g31, 76
	ld	%g17, %g3, 0
	jne	%g17, %g29, jeq_else.40695
	jmp	jeq_cont.40696
jeq_else.40695:
	ld	%g17, %g1, 56
	st	%g3, %g17, 0
	addi	%g3, %g0, 1
	subi	%g1, %g1, 292
	call	read_and_network.2704
	addi	%g1, %g1, 292
jeq_cont.40696:
	addi	%g10, %g0, 0
	ld	%g11, %g1, 0
	st	%g10, %g11, 0
	addi	%g10, %g0, 0
	ld	%g12, %g1, 4
	st	%g10, %g12, 0
	input	%g3
	st	%g3, %g31, 72
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40697
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40699
	addi	%g4, %g0, 0
	jmp	jle_cont.40700
jle_else.40699:
	addi	%g4, %g0, 1
jle_cont.40700:
	jmp	jle_cont.40698
jle_else.40697:
	addi	%g4, %g0, 1
jle_cont.40698:
	st	%g4, %g31, 68
	jne	%g4, %g0, jeq_else.40701
	ld	%g4, %g12, 0
	jne	%g4, %g0, jeq_else.40703
	addi	%g4, %g0, 1
	st	%g4, %g12, 0
	jmp	jeq_cont.40704
jeq_else.40703:
jeq_cont.40704:
	ld	%g4, %g11, 0
	slli	%g15, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g15, %g4
	subi	%g15, %g3, 48
	add	%g4, %g4, %g15
	st	%g4, %g11, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 292
	call	read_int_token.2507
	addi	%g1, %g1, 292
	jmp	jeq_cont.40702
jeq_else.40701:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 292
	call	read_int_token.2507
	addi	%g1, %g1, 292
jeq_cont.40702:
	st	%g3, %g31, 64
	jne	%g3, %g29, jeq_else.40705
	addi	%g3, %g0, 1
	addi	%g4, %g0, -1
	subi	%g1, %g1, 292
	call	min_caml_create_array
	addi	%g1, %g1, 292
	jmp	jeq_cont.40706
jeq_else.40705:
	addi	%g16, %g0, 1
	st	%g3, %g1, 288
	mov	%g3, %g16
	subi	%g1, %g1, 296
	call	read_net_item.2700
	addi	%g1, %g1, 296
	ld	%g4, %g1, 288
	st	%g4, %g3, 0
jeq_cont.40706:
	st	%g3, %g31, 60
	ld	%g4, %g3, 0
	jne	%g4, %g29, jeq_else.40707
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 296
	call	min_caml_create_array
	addi	%g1, %g1, 296
	jmp	jeq_cont.40708
jeq_else.40707:
	addi	%g17, %g0, 1
	st	%g3, %g1, 292
	mov	%g3, %g17
	subi	%g1, %g1, 300
	call	read_or_network.2702
	addi	%g1, %g1, 300
	ld	%g10, %g1, 292
	st	%g10, %g3, 0
jeq_cont.40708:
	ld	%g10, %g1, 64
	st	%g3, %g10, 0
	addi	%g3, %g0, 80
	output	%g3
	addi	%g3, %g0, 51
	output	%g3
	addi	%g3, %g0, 10
	output	%g3
	ld	%g3, %g1, 68
	ld	%g13, %g3, 0
	mov	%g3, %g13
	subi	%g1, %g1, 300
	call	print_int.2528
	addi	%g1, %g1, 300
	addi	%g3, %g0, 32
	output	%g3
	ld	%g3, %g1, 68
	ld	%g13, %g3, -4
	mov	%g3, %g13
	subi	%g1, %g1, 300
	call	print_int.2528
	addi	%g1, %g1, 300
	addi	%g3, %g0, 32
	output	%g3
	addi	%g3, %g0, 255
	subi	%g1, %g1, 300
	call	print_int.2528
	addi	%g1, %g1, 300
	addi	%g3, %g0, 10
	output	%g3
	addi	%g3, %g0, 120
	addi	%g10, %g0, 3
	fld	%f0, %g1, 280
	st	%g3, %g1, 296
	mov	%g3, %g10
	subi	%g1, %g1, 304
	call	min_caml_create_float_array
	addi	%g1, %g1, 304
	st	%g3, %g31, 56
	ld	%g4, %g1, 24
	ld	%g10, %g4, 0
	st	%g3, %g1, 300
	mov	%g4, %g3
	mov	%g3, %g10
	subi	%g1, %g1, 308
	call	min_caml_create_array
	addi	%g1, %g1, 308
	st	%g3, %g31, 52
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 300
	st	%g3, %g4, 0
	mov	%g3, %g4
	ld	%g4, %g1, 296
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 308
	call	min_caml_create_array
	addi	%g1, %g1, 308
	ld	%g10, %g1, 96
	st	%g3, %g10, -16
	ld	%g3, %g10, -16
	addi	%g11, %g0, 3
	fld	%f0, %g1, 280
	st	%g3, %g1, 304
	mov	%g3, %g11
	subi	%g1, %g1, 312
	call	min_caml_create_float_array
	addi	%g1, %g1, 312
	st	%g3, %g31, 48
	ld	%g4, %g1, 24
	ld	%g11, %g4, 0
	st	%g3, %g1, 308
	mov	%g4, %g3
	mov	%g3, %g11
	subi	%g1, %g1, 316
	call	min_caml_create_array
	addi	%g1, %g1, 316
	st	%g3, %g31, 44
	mov	%g11, %g2
	addi	%g2, %g2, 8
	st	%g3, %g11, -4
	ld	%g3, %g1, 308
	st	%g3, %g11, 0
	mov	%g3, %g11
	ld	%g11, %g1, 304
	st	%g3, %g11, -472
	addi	%g3, %g0, 3
	fld	%f0, %g1, 280
	subi	%g1, %g1, 316
	call	min_caml_create_float_array
	addi	%g1, %g1, 316
	st	%g3, %g31, 40
	ld	%g4, %g1, 24
	ld	%g12, %g4, 0
	st	%g3, %g1, 312
	mov	%g4, %g3
	mov	%g3, %g12
	subi	%g1, %g1, 320
	call	min_caml_create_array
	addi	%g1, %g1, 320
	st	%g3, %g31, 36
	mov	%g12, %g2
	addi	%g2, %g2, 8
	st	%g3, %g12, -4
	ld	%g3, %g1, 312
	st	%g3, %g12, 0
	mov	%g3, %g12
	st	%g3, %g11, -468
	addi	%g3, %g0, 3
	fld	%f0, %g1, 280
	subi	%g1, %g1, 320
	call	min_caml_create_float_array
	addi	%g1, %g1, 320
	st	%g3, %g31, 32
	ld	%g4, %g1, 24
	ld	%g12, %g4, 0
	st	%g3, %g1, 316
	mov	%g4, %g3
	mov	%g3, %g12
	subi	%g1, %g1, 324
	call	min_caml_create_array
	addi	%g1, %g1, 324
	st	%g3, %g31, 28
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 316
	st	%g3, %g4, 0
	mov	%g3, %g4
	st	%g3, %g11, -464
	addi	%g3, %g0, 115
	mov	%g4, %g3
	mov	%g3, %g11
	subi	%g1, %g1, 324
	call	create_dirvec_elements.3012
	addi	%g1, %g1, 324
	addi	%g3, %g0, 3
	subi	%g1, %g1, 324
	call	create_dirvecs.3015
	addi	%g1, %g1, 324
	addi	%g3, %g0, 9
	addi	%g10, %g0, 0
	addi	%g11, %g0, 0
	subi	%g1, %g1, 324
	call	min_caml_float_of_int
	addi	%g1, %g1, 324
	fmov	%f10, %f0, 0
	setL %g3, l.34583
	fld	%f11, %g3, 0
	fmul	%f10, %f10, %f11
	setL %g3, l.34585
	fld	%f12, %g3, 0
	fsub	%f10, %f10, %f12
	fst	%f10, %g31, 24
	addi	%g3, %g0, 4
	subi	%g1, %g1, 324
	call	min_caml_float_of_int
	addi	%g1, %g1, 324
	fmul	%f0, %f0, %f11
	fsub	%f1, %f0, %f12
	fst	%f1, %g31, 20
	addi	%g3, %g0, 0
	fld	%f2, %g1, 280
	st	%g11, %g1, 320
	fst	%f10, %g1, 324
	st	%g10, %g1, 328
	fst	%f0, %g1, 332
	mov	%g5, %g11
	mov	%g4, %g10
	fmov	%f3, %f10
	fmov	%f0, %f2
	fmov	%f15, %f2
	fmov	%f2, %f1
	fmov	%f1, %f15
	subi	%g1, %g1, 340
	call	calc_dirvec.2993
	addi	%g1, %g1, 340
	fmov	%f0, %f28
	fld	%f1, %g1, 332
	fadd	%f0, %f1, %f0
	fst	%f0, %g31, 16
	addi	%g3, %g0, 0
	addi	%g4, %g0, 2
	fld	%f1, %g1, 280
	fld	%f2, %g1, 324
	ld	%g5, %g1, 328
	mov	%g26, %g5
	mov	%g5, %g4
	mov	%g4, %g26
	fmov	%f3, %f2
	fmov	%f2, %f0
	fmov	%f0, %f1
	subi	%g1, %g1, 340
	call	calc_dirvec.2993
	addi	%g1, %g1, 340
	addi	%g3, %g0, 3
	addi	%g4, %g0, 1
	fld	%f0, %g1, 324
	ld	%g5, %g1, 320
	subi	%g1, %g1, 340
	call	calc_dirvecs.3001
	addi	%g1, %g1, 340
	addi	%g3, %g0, 8
	addi	%g4, %g0, 2
	addi	%g5, %g0, 4
	subi	%g1, %g1, 340
	call	calc_dirvec_rows.3006
	addi	%g1, %g1, 340
	ld	%g3, %g1, 96
	ld	%g3, %g3, -16
	ld	%g4, %g3, -476
	ld	%g15, %g1, 24
	ld	%g16, %g15, 0
	subi	%g16, %g16, 1
	st	%g3, %g1, 336
	mov	%g3, %g4
	mov	%g4, %g16
	subi	%g1, %g1, 344
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 344
	ld	%g3, %g1, 336
	ld	%g4, %g3, -472
	ld	%g16, %g15, 0
	subi	%g16, %g16, 1
	mov	%g3, %g4
	mov	%g4, %g16
	subi	%g1, %g1, 344
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 344
	ld	%g3, %g1, 336
	ld	%g4, %g3, -468
	ld	%g16, %g15, 0
	subi	%g16, %g16, 1
	mov	%g3, %g4
	mov	%g4, %g16
	subi	%g1, %g1, 344
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 344
	ld	%g3, %g1, 336
	ld	%g4, %g3, -464
	ld	%g16, %g15, 0
	subi	%g16, %g16, 1
	mov	%g3, %g4
	mov	%g4, %g16
	subi	%g1, %g1, 344
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 344
	ld	%g3, %g1, 336
	ld	%g4, %g3, -460
	ld	%g16, %g15, 0
	subi	%g16, %g16, 1
	mov	%g3, %g4
	mov	%g4, %g16
	subi	%g1, %g1, 344
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 344
	ld	%g3, %g1, 336
	ld	%g4, %g3, -456
	ld	%g16, %g15, 0
	subi	%g16, %g16, 1
	mov	%g3, %g4
	mov	%g4, %g16
	subi	%g1, %g1, 344
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 344
	ld	%g3, %g1, 336
	ld	%g4, %g3, -452
	ld	%g16, %g15, 0
	subi	%g16, %g16, 1
	mov	%g3, %g4
	mov	%g4, %g16
	subi	%g1, %g1, 344
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 344
	addi	%g3, %g0, 112
	ld	%g4, %g1, 336
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 344
	call	init_dirvec_constants.3017
	addi	%g1, %g1, 344
	addi	%g3, %g0, 3
	subi	%g1, %g1, 344
	call	init_vecset_constants.3020
	addi	%g1, %g1, 344
	ld	%g3, %g1, 44
	fld	%f10, %g3, 0
	ld	%g4, %g1, 104
	fst	%f10, %g4, 0
	fld	%f10, %g3, -4
	fst	%f10, %g4, -4
	fld	%f10, %g3, -8
	fst	%f10, %g4, -8
	ld	%g4, %g1, 24
	ld	%g15, %g4, 0
	subi	%g15, %g15, 1
	ld	%g16, %g1, 156
	mov	%g4, %g15
	mov	%g3, %g16
	subi	%g1, %g1, 344
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 344
	ld	%g3, %g1, 24
	ld	%g10, %g3, 0
	subi	%g10, %g10, 1
	jlt	%g10, %g0, jge_else.40709
	slli	%g11, %g10, 2
	ld	%g12, %g1, 32
	add	%g26, %g12, %g11
	ld	%g11, %g26, 0
	ld	%g12, %g11, -8
	addi	%g13, %g0, 2
	jne	%g12, %g13, jeq_else.40711
	ld	%g12, %g11, -28
	fld	%f0, %g12, 0
	fld	%f1, %g1, 260
	fjlt	%f0, %f1, fjge_else.40713
	jmp	fjge_cont.40714
fjge_else.40713:
	ld	%g13, %g11, -4
	jne	%g13, %g28, jeq_else.40715
	slli	%g10, %g10, 2
	ld	%g11, %g1, 116
	ld	%g13, %g11, 0
	fld	%f0, %g12, 0
	fsub	%f0, %f1, %f0
	ld	%g12, %g1, 44
	fld	%f1, %g12, 0
	fneg	%f10, %f1
	fld	%f11, %g12, -4
	fneg	%f11, %f11
	fld	%f12, %g12, -8
	fneg	%f12, %f12
	addi	%g14, %g10, 1
	addi	%g15, %g0, 3
	fld	%f13, %g1, 280
	fst	%f0, %g1, 340
	mov	%g3, %g15
	fmov	%f0, %f13
	subi	%g1, %g1, 348
	call	min_caml_create_float_array
	addi	%g1, %g1, 348
	ld	%g4, %g1, 24
	ld	%g15, %g4, 0
	st	%g3, %g1, 344
	mov	%g4, %g3
	mov	%g3, %g15
	subi	%g1, %g1, 352
	call	min_caml_create_array
	addi	%g1, %g1, 352
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 344
	st	%g3, %g4, 0
	fst	%f1, %g3, 0
	fst	%f11, %g3, -4
	fst	%f12, %g3, -8
	ld	%g3, %g1, 24
	ld	%g15, %g3, 0
	subi	%g15, %g15, 1
	st	%g10, %g1, 348
	st	%g13, %g1, 352
	st	%g14, %g1, 356
	st	%g4, %g1, 360
	mov	%g3, %g4
	mov	%g4, %g15
	subi	%g1, %g1, 368
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 368
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fld	%f0, %g1, 340
	fst	%f0, %g3, -8
	ld	%g10, %g1, 360
	st	%g10, %g3, -4
	ld	%g10, %g1, 356
	st	%g10, %g3, 0
	ld	%g10, %g1, 352
	slli	%g11, %g10, 2
	ld	%g12, %g1, 112
	add	%g26, %g12, %g11
	st	%g3, %g26, 0
	addi	%g3, %g10, 1
	ld	%g11, %g1, 348
	addi	%g13, %g11, 2
	ld	%g14, %g1, 44
	fld	%f1, %g14, -4
	addi	%g15, %g0, 3
	st	%g3, %g1, 364
	mov	%g3, %g15
	fmov	%f0, %f13
	subi	%g1, %g1, 372
	call	min_caml_create_float_array
	addi	%g1, %g1, 372
	ld	%g4, %g1, 24
	ld	%g15, %g4, 0
	st	%g3, %g1, 368
	mov	%g4, %g3
	mov	%g3, %g15
	subi	%g1, %g1, 376
	call	min_caml_create_array
	addi	%g1, %g1, 376
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 368
	st	%g3, %g4, 0
	fst	%f10, %g3, 0
	fst	%f1, %g3, -4
	fst	%f12, %g3, -8
	ld	%g3, %g1, 24
	ld	%g15, %g3, 0
	subi	%g15, %g15, 1
	st	%g13, %g1, 372
	st	%g4, %g1, 376
	mov	%g3, %g4
	mov	%g4, %g15
	subi	%g1, %g1, 384
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 384
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fld	%f0, %g1, 340
	fst	%f0, %g3, -8
	ld	%g10, %g1, 376
	st	%g10, %g3, -4
	ld	%g10, %g1, 372
	st	%g10, %g3, 0
	ld	%g10, %g1, 364
	slli	%g10, %g10, 2
	ld	%g11, %g1, 112
	add	%g26, %g11, %g10
	st	%g3, %g26, 0
	ld	%g3, %g1, 352
	addi	%g10, %g3, 2
	ld	%g12, %g1, 348
	addi	%g12, %g12, 3
	ld	%g13, %g1, 44
	fld	%f1, %g13, -8
	addi	%g13, %g0, 3
	mov	%g3, %g13
	fmov	%f0, %f13
	subi	%g1, %g1, 384
	call	min_caml_create_float_array
	addi	%g1, %g1, 384
	ld	%g4, %g1, 24
	ld	%g13, %g4, 0
	st	%g3, %g1, 380
	mov	%g4, %g3
	mov	%g3, %g13
	subi	%g1, %g1, 388
	call	min_caml_create_array
	addi	%g1, %g1, 388
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 380
	st	%g3, %g4, 0
	fst	%f10, %g3, 0
	fst	%f11, %g3, -4
	fst	%f1, %g3, -8
	ld	%g3, %g1, 24
	ld	%g3, %g3, 0
	subi	%g3, %g3, 1
	st	%g10, %g1, 384
	st	%g12, %g1, 388
	st	%g4, %g1, 392
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 400
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 400
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fld	%f10, %g1, 340
	fst	%f10, %g3, -8
	ld	%g10, %g1, 392
	st	%g10, %g3, -4
	ld	%g10, %g1, 388
	st	%g10, %g3, 0
	ld	%g10, %g1, 384
	slli	%g10, %g10, 2
	ld	%g11, %g1, 112
	add	%g26, %g11, %g10
	st	%g3, %g26, 0
	ld	%g3, %g1, 352
	addi	%g3, %g3, 3
	ld	%g10, %g1, 116
	st	%g3, %g10, 0
	jmp	jeq_cont.40716
jeq_else.40715:
	addi	%g12, %g0, 2
	jne	%g13, %g12, jeq_else.40717
	slli	%g10, %g10, 2
	addi	%g10, %g10, 1
	ld	%g12, %g1, 116
	ld	%g13, %g12, 0
	fsub	%f0, %f1, %f0
	ld	%g11, %g11, -16
	ld	%g14, %g1, 44
	fld	%f1, %g14, 0
	fld	%f10, %g11, 0
	fmul	%f11, %f1, %f10
	fld	%f12, %g14, -4
	fld	%f13, %g11, -4
	fmul	%f14, %f12, %f13
	fadd	%f11, %f11, %f14
	fld	%f14, %g14, -8
	fld	%f15, %g11, -8
	fmul	%f2, %f14, %f15
	fadd	%f11, %f11, %f2
	fld	%f2, %g1, 120
	fmul	%f10, %f2, %f10
	fmul	%f10, %f10, %f11
	fsub	%f1, %f10, %f1
	fmul	%f10, %f2, %f13
	fmul	%f10, %f10, %f11
	fsub	%f10, %f10, %f12
	fmul	%f12, %f2, %f15
	fmul	%f11, %f12, %f11
	fsub	%f11, %f11, %f14
	addi	%g11, %g0, 3
	fld	%f12, %g1, 280
	fst	%f0, %g1, 396
	mov	%g3, %g11
	fmov	%f0, %f12
	subi	%g1, %g1, 404
	call	min_caml_create_float_array
	addi	%g1, %g1, 404
	ld	%g4, %g1, 24
	ld	%g11, %g4, 0
	st	%g3, %g1, 400
	mov	%g4, %g3
	mov	%g3, %g11
	subi	%g1, %g1, 408
	call	min_caml_create_array
	addi	%g1, %g1, 408
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 400
	st	%g3, %g4, 0
	fst	%f1, %g3, 0
	fst	%f10, %g3, -4
	fst	%f11, %g3, -8
	ld	%g3, %g1, 24
	ld	%g3, %g3, 0
	subi	%g3, %g3, 1
	st	%g13, %g1, 404
	st	%g10, %g1, 408
	st	%g4, %g1, 412
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 420
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 420
	mov	%g3, %g2
	addi	%g2, %g2, 12
	fld	%f10, %g1, 396
	fst	%f10, %g3, -8
	ld	%g10, %g1, 412
	st	%g10, %g3, -4
	ld	%g10, %g1, 408
	st	%g10, %g3, 0
	ld	%g10, %g1, 404
	slli	%g11, %g10, 2
	ld	%g12, %g1, 112
	add	%g26, %g12, %g11
	st	%g3, %g26, 0
	addi	%g3, %g10, 1
	ld	%g10, %g1, 116
	st	%g3, %g10, 0
	jmp	jeq_cont.40718
jeq_else.40717:
jeq_cont.40718:
jeq_cont.40716:
fjge_cont.40714:
	jmp	jeq_cont.40712
jeq_else.40711:
jeq_cont.40712:
	jmp	jge_cont.40710
jge_else.40709:
jge_cont.40710:
	addi	%g3, %g0, 0
	ld	%g10, %g1, 76
	fld	%f10, %g10, 0
	ld	%g11, %g1, 72
	ld	%g12, %g11, -4
	sub	%g12, %g0, %g12
	st	%g3, %g1, 416
	mov	%g3, %g12
	subi	%g1, %g1, 424
	call	min_caml_float_of_int
	addi	%g1, %g1, 424
	fmul	%f0, %f10, %f0
	fst	%f0, %g31, 12
	ld	%g3, %g1, 84
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	ld	%g4, %g1, 88
	fld	%f2, %g4, 0
	fadd	%f1, %f1, %f2
	fst	%f1, %g31, 8
	fld	%f2, %g3, -4
	fmul	%f2, %f0, %f2
	fld	%f3, %g4, -4
	fadd	%f2, %f2, %f3
	fst	%f2, %g31, 4
	fld	%f3, %g3, -8
	fmul	%f0, %f0, %f3
	fld	%f3, %g4, -8
	fadd	%f0, %f0, %f3
	fst	%f0, %g31, 0
	ld	%g5, %g1, 68
	ld	%g6, %g5, 0
	subi	%g6, %g6, 1
	ld	%g7, %g1, 196
	ld	%g8, %g1, 416
	mov	%g5, %g8
	mov	%g4, %g6
	mov	%g3, %g7
	fmov	%f15, %f2
	fmov	%f2, %f0
	fmov	%f0, %f1
	fmov	%f1, %f15
	subi	%g1, %g1, 424
	call	pretrace_pixels.2958
	addi	%g1, %g1, 424
	addi	%g3, %g0, 0
	addi	%g10, %g0, 2
	ld	%g11, %g1, 68
	ld	%g12, %g11, -4
	jlt	%g3, %g12, jle_else.40719
	jmp	jle_cont.40720
jle_else.40719:
	subi	%g12, %g12, 1
	st	%g3, %g1, 420
	jlt	%g3, %g12, jle_else.40721
	jmp	jle_cont.40722
jle_else.40721:
	addi	%g12, %g0, 1
	ld	%g13, %g1, 76
	fld	%f10, %g13, 0
	ld	%g13, %g1, 72
	ld	%g13, %g13, -4
	sub	%g12, %g12, %g13
	mov	%g3, %g12
	subi	%g1, %g1, 428
	call	min_caml_float_of_int
	addi	%g1, %g1, 428
	fmul	%f0, %f10, %f0
	ld	%g3, %g1, 84
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	ld	%g4, %g1, 88
	fld	%f2, %g4, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g3, -4
	fmul	%f2, %f0, %f2
	fld	%f3, %g4, -4
	fadd	%f2, %f2, %f3
	fld	%f3, %g3, -8
	fmul	%f0, %f0, %f3
	fld	%f3, %g4, -8
	fadd	%f0, %f0, %f3
	ld	%g3, %g11, 0
	subi	%g3, %g3, 1
	ld	%g4, %g1, 232
	mov	%g5, %g10
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	fmov	%f15, %f2
	fmov	%f2, %f0
	fmov	%f0, %f1
	fmov	%f1, %f15
	subi	%g1, %g1, 428
	call	pretrace_pixels.2958
	addi	%g1, %g1, 428
jle_cont.40722:
	addi	%g3, %g0, 0
	ld	%g4, %g1, 420
	ld	%g5, %g1, 160
	ld	%g6, %g1, 196
	ld	%g7, %g1, 232
	subi	%g1, %g1, 428
	call	scan_pixel.2969
	addi	%g1, %g1, 428
	addi	%g3, %g0, 1
	addi	%g4, %g0, 4
	ld	%g5, %g1, 196
	ld	%g6, %g1, 232
	ld	%g7, %g1, 160
	mov	%g26, %g7
	mov	%g7, %g4
	mov	%g4, %g5
	mov	%g5, %g6
	mov	%g6, %g26
	subi	%g1, %g1, 428
	call	scan_line.2975
	addi	%g1, %g1, 428
jle_cont.40720:
	addi	%g0, %g0, 0
	halt
sin_sub.2497:
	fmov	%f1, %f30
	fjlt	%f1, %f0, fjge_else.40723
	fmov	%f2, %f16
	fjlt	%f0, %f2, fjge_else.40724
	return
fjge_else.40724:
	fadd	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.40725
	fjlt	%f0, %f2, fjge_else.40726
	return
fjge_else.40726:
	fadd	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.40727
	fjlt	%f0, %f2, fjge_else.40728
	return
fjge_else.40728:
	fadd	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.40729
	fjlt	%f0, %f2, fjge_else.40730
	return
fjge_else.40730:
	fadd	%f0, %f0, %f1
	jmp	sin_sub.2497
fjge_else.40729:
	fsub	%f0, %f0, %f1
	jmp	sin_sub.2497
fjge_else.40727:
	fsub	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.40731
	fjlt	%f0, %f2, fjge_else.40732
	return
fjge_else.40732:
	fadd	%f0, %f0, %f1
	jmp	sin_sub.2497
fjge_else.40731:
	fsub	%f0, %f0, %f1
	jmp	sin_sub.2497
fjge_else.40725:
	fsub	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.40733
	fjlt	%f0, %f2, fjge_else.40734
	return
fjge_else.40734:
	fadd	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.40735
	fjlt	%f0, %f2, fjge_else.40736
	return
fjge_else.40736:
	fadd	%f0, %f0, %f1
	jmp	sin_sub.2497
fjge_else.40735:
	fsub	%f0, %f0, %f1
	jmp	sin_sub.2497
fjge_else.40733:
	fsub	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.40737
	fjlt	%f0, %f2, fjge_else.40738
	return
fjge_else.40738:
	fadd	%f0, %f0, %f1
	jmp	sin_sub.2497
fjge_else.40737:
	fsub	%f0, %f0, %f1
	jmp	sin_sub.2497
fjge_else.40723:
	fsub	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.40739
	fmov	%f2, %f16
	fjlt	%f0, %f2, fjge_else.40740
	return
fjge_else.40740:
	fadd	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.40741
	fjlt	%f0, %f2, fjge_else.40742
	return
fjge_else.40742:
	fadd	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.40743
	fjlt	%f0, %f2, fjge_else.40744
	return
fjge_else.40744:
	fadd	%f0, %f0, %f1
	jmp	sin_sub.2497
fjge_else.40743:
	fsub	%f0, %f0, %f1
	jmp	sin_sub.2497
fjge_else.40741:
	fsub	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.40745
	fjlt	%f0, %f2, fjge_else.40746
	return
fjge_else.40746:
	fadd	%f0, %f0, %f1
	jmp	sin_sub.2497
fjge_else.40745:
	fsub	%f0, %f0, %f1
	jmp	sin_sub.2497
fjge_else.40739:
	fsub	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.40747
	fmov	%f2, %f16
	fjlt	%f0, %f2, fjge_else.40748
	return
fjge_else.40748:
	fadd	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.40749
	fjlt	%f0, %f2, fjge_else.40750
	return
fjge_else.40750:
	fadd	%f0, %f0, %f1
	jmp	sin_sub.2497
fjge_else.40749:
	fsub	%f0, %f0, %f1
	jmp	sin_sub.2497
fjge_else.40747:
	fsub	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.40751
	fmov	%f2, %f16
	fjlt	%f0, %f2, fjge_else.40752
	return
fjge_else.40752:
	fadd	%f0, %f0, %f1
	jmp	sin_sub.2497
fjge_else.40751:
	fsub	%f0, %f0, %f1
	jmp	sin_sub.2497
read_int_token.2507:
	ld	%g10, %g31, 848
	ld	%g11, %g31, 852
	st	%g3, %g1, 0
	input	%g12
	addi	%g13, %g0, 48
	jlt	%g12, %g13, jle_else.40753
	addi	%g13, %g0, 57
	jlt	%g13, %g12, jle_else.40755
	addi	%g13, %g0, 0
	jmp	jle_cont.40756
jle_else.40755:
	addi	%g13, %g0, 1
jle_cont.40756:
	jmp	jle_cont.40754
jle_else.40753:
	addi	%g13, %g0, 1
jle_cont.40754:
	jne	%g13, %g0, jeq_else.40757
	ld	%g13, %g10, 0
	jne	%g13, %g0, jeq_else.40758
	addi	%g13, %g0, 45
	jne	%g4, %g13, jeq_else.40760
	addi	%g13, %g0, -1
	st	%g13, %g10, 0
	jmp	jeq_cont.40761
jeq_else.40760:
	addi	%g13, %g0, 1
	st	%g13, %g10, 0
jeq_cont.40761:
	jmp	jeq_cont.40759
jeq_else.40758:
jeq_cont.40759:
	ld	%g13, %g11, 0
	slli	%g14, %g13, 3
	slli	%g13, %g13, 1
	add	%g13, %g14, %g13
	subi	%g14, %g12, 48
	add	%g13, %g13, %g14
	st	%g13, %g11, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40762
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40764
	addi	%g4, %g0, 0
	jmp	jle_cont.40765
jle_else.40764:
	addi	%g4, %g0, 1
jle_cont.40765:
	jmp	jle_cont.40763
jle_else.40762:
	addi	%g4, %g0, 1
jle_cont.40763:
	jne	%g4, %g0, jeq_else.40766
	ld	%g4, %g10, 0
	jne	%g4, %g0, jeq_else.40767
	addi	%g4, %g0, 45
	jne	%g12, %g4, jeq_else.40769
	addi	%g4, %g0, -1
	st	%g4, %g10, 0
	jmp	jeq_cont.40770
jeq_else.40769:
	addi	%g4, %g0, 1
	st	%g4, %g10, 0
jeq_cont.40770:
	jmp	jeq_cont.40768
jeq_else.40767:
jeq_cont.40768:
	ld	%g4, %g11, 0
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g5, %g3, 48
	add	%g4, %g4, %g5
	st	%g4, %g11, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	jmp	read_int_token.2507
jeq_else.40766:
	ld	%g3, %g10, 0
	jne	%g3, %g28, jeq_else.40771
	ld	%g3, %g11, 0
	return
jeq_else.40771:
	ld	%g3, %g11, 0
	sub	%g3, %g0, %g3
	return
jeq_else.40757:
	ld	%g13, %g1, 0
	jne	%g13, %g0, jeq_else.40772
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40773
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40775
	addi	%g4, %g0, 0
	jmp	jle_cont.40776
jle_else.40775:
	addi	%g4, %g0, 1
jle_cont.40776:
	jmp	jle_cont.40774
jle_else.40773:
	addi	%g4, %g0, 1
jle_cont.40774:
	jne	%g4, %g0, jeq_else.40777
	ld	%g4, %g10, 0
	jne	%g4, %g0, jeq_else.40778
	addi	%g4, %g0, 45
	jne	%g12, %g4, jeq_else.40780
	addi	%g4, %g0, -1
	st	%g4, %g10, 0
	jmp	jeq_cont.40781
jeq_else.40780:
	addi	%g4, %g0, 1
	st	%g4, %g10, 0
jeq_cont.40781:
	jmp	jeq_cont.40779
jeq_else.40778:
jeq_cont.40779:
	ld	%g4, %g11, 0
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g5, %g3, 48
	add	%g4, %g4, %g5
	st	%g4, %g11, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	jmp	read_int_token.2507
jeq_else.40777:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	jmp	read_int_token.2507
jeq_else.40772:
	ld	%g3, %g10, 0
	jne	%g3, %g28, jeq_else.40782
	ld	%g3, %g11, 0
	return
jeq_else.40782:
	ld	%g3, %g11, 0
	sub	%g3, %g0, %g3
	return
read_float_token1.2516:
	ld	%g10, %g31, 832
	ld	%g11, %g31, 844
	st	%g3, %g1, 0
	input	%g12
	addi	%g13, %g0, 48
	jlt	%g12, %g13, jle_else.40783
	addi	%g13, %g0, 57
	jlt	%g13, %g12, jle_else.40785
	addi	%g13, %g0, 0
	jmp	jle_cont.40786
jle_else.40785:
	addi	%g13, %g0, 1
jle_cont.40786:
	jmp	jle_cont.40784
jle_else.40783:
	addi	%g13, %g0, 1
jle_cont.40784:
	jne	%g13, %g0, jeq_else.40787
	ld	%g13, %g10, 0
	jne	%g13, %g0, jeq_else.40788
	addi	%g13, %g0, 45
	jne	%g4, %g13, jeq_else.40790
	addi	%g13, %g0, -1
	st	%g13, %g10, 0
	jmp	jeq_cont.40791
jeq_else.40790:
	addi	%g13, %g0, 1
	st	%g13, %g10, 0
jeq_cont.40791:
	jmp	jeq_cont.40789
jeq_else.40788:
jeq_cont.40789:
	ld	%g13, %g11, 0
	slli	%g14, %g13, 3
	slli	%g13, %g13, 1
	add	%g13, %g14, %g13
	subi	%g14, %g12, 48
	add	%g13, %g13, %g14
	st	%g13, %g11, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40792
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40794
	addi	%g4, %g0, 0
	jmp	jle_cont.40795
jle_else.40794:
	addi	%g4, %g0, 1
jle_cont.40795:
	jmp	jle_cont.40793
jle_else.40792:
	addi	%g4, %g0, 1
jle_cont.40793:
	jne	%g4, %g0, jeq_else.40796
	ld	%g4, %g10, 0
	jne	%g4, %g0, jeq_else.40797
	addi	%g4, %g0, 45
	jne	%g12, %g4, jeq_else.40799
	addi	%g4, %g0, -1
	st	%g4, %g10, 0
	jmp	jeq_cont.40800
jeq_else.40799:
	addi	%g4, %g0, 1
	st	%g4, %g10, 0
jeq_cont.40800:
	jmp	jeq_cont.40798
jeq_else.40797:
jeq_cont.40798:
	ld	%g4, %g11, 0
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g5, %g3, 48
	add	%g4, %g4, %g5
	st	%g4, %g11, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	jmp	read_float_token1.2516
jeq_else.40796:
	return
jeq_else.40787:
	ld	%g13, %g1, 0
	jne	%g13, %g0, jeq_else.40801
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40802
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40804
	addi	%g4, %g0, 0
	jmp	jle_cont.40805
jle_else.40804:
	addi	%g4, %g0, 1
jle_cont.40805:
	jmp	jle_cont.40803
jle_else.40802:
	addi	%g4, %g0, 1
jle_cont.40803:
	jne	%g4, %g0, jeq_else.40806
	ld	%g4, %g10, 0
	jne	%g4, %g0, jeq_else.40807
	addi	%g4, %g0, 45
	jne	%g12, %g4, jeq_else.40809
	addi	%g4, %g0, -1
	st	%g4, %g10, 0
	jmp	jeq_cont.40810
jeq_else.40809:
	addi	%g4, %g0, 1
	st	%g4, %g10, 0
jeq_cont.40810:
	jmp	jeq_cont.40808
jeq_else.40807:
jeq_cont.40808:
	ld	%g4, %g11, 0
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g5, %g3, 48
	add	%g4, %g4, %g5
	st	%g4, %g11, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	jmp	read_float_token1.2516
jeq_else.40806:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	jmp	read_float_token1.2516
jeq_else.40801:
	mov	%g3, %g12
	return
read_float_token2.2519:
	ld	%g10, %g31, 840
	ld	%g11, %g31, 836
	st	%g3, %g1, 0
	input	%g12
	addi	%g13, %g0, 48
	jlt	%g12, %g13, jle_else.40811
	addi	%g13, %g0, 57
	jlt	%g13, %g12, jle_else.40813
	addi	%g13, %g0, 0
	jmp	jle_cont.40814
jle_else.40813:
	addi	%g13, %g0, 1
jle_cont.40814:
	jmp	jle_cont.40812
jle_else.40811:
	addi	%g13, %g0, 1
jle_cont.40812:
	jne	%g13, %g0, jeq_else.40815
	ld	%g13, %g10, 0
	slli	%g14, %g13, 3
	slli	%g13, %g13, 1
	add	%g13, %g14, %g13
	subi	%g12, %g12, 48
	add	%g12, %g13, %g12
	st	%g12, %g10, 0
	ld	%g12, %g11, 0
	slli	%g13, %g12, 3
	slli	%g12, %g12, 1
	add	%g12, %g13, %g12
	st	%g12, %g11, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40816
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40818
	addi	%g4, %g0, 0
	jmp	jle_cont.40819
jle_else.40818:
	addi	%g4, %g0, 1
jle_cont.40819:
	jmp	jle_cont.40817
jle_else.40816:
	addi	%g4, %g0, 1
jle_cont.40817:
	jne	%g4, %g0, jeq_else.40820
	ld	%g4, %g10, 0
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	st	%g3, %g10, 0
	ld	%g3, %g11, 0
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	st	%g3, %g11, 0
	addi	%g3, %g0, 1
	jmp	read_float_token2.2519
jeq_else.40820:
	return
jeq_else.40815:
	ld	%g12, %g1, 0
	jne	%g12, %g0, jeq_else.40822
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40823
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40825
	addi	%g4, %g0, 0
	jmp	jle_cont.40826
jle_else.40825:
	addi	%g4, %g0, 1
jle_cont.40826:
	jmp	jle_cont.40824
jle_else.40823:
	addi	%g4, %g0, 1
jle_cont.40824:
	jne	%g4, %g0, jeq_else.40827
	ld	%g4, %g10, 0
	slli	%g5, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g5, %g4
	subi	%g3, %g3, 48
	add	%g3, %g4, %g3
	st	%g3, %g10, 0
	ld	%g3, %g11, 0
	slli	%g4, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g4, %g3
	st	%g3, %g11, 0
	addi	%g3, %g0, 1
	jmp	read_float_token2.2519
jeq_else.40827:
	addi	%g3, %g0, 0
	jmp	read_float_token2.2519
jeq_else.40822:
	return
div_binary_search.2523:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.40829
	mov	%g3, %g5
	return
jle_else.40829:
	jlt	%g8, %g3, jle_else.40830
	jne	%g8, %g3, jeq_else.40831
	mov	%g3, %g7
	return
jeq_else.40831:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.40832
	mov	%g3, %g5
	return
jle_else.40832:
	jlt	%g8, %g3, jle_else.40833
	jne	%g8, %g3, jeq_else.40834
	mov	%g3, %g6
	return
jeq_else.40834:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.40835
	mov	%g3, %g5
	return
jle_else.40835:
	jlt	%g8, %g3, jle_else.40836
	jne	%g8, %g3, jeq_else.40837
	mov	%g3, %g7
	return
jeq_else.40837:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.40838
	mov	%g3, %g5
	return
jle_else.40838:
	jlt	%g8, %g3, jle_else.40839
	jne	%g8, %g3, jeq_else.40840
	mov	%g3, %g6
	return
jeq_else.40840:
	jmp	div_binary_search.2523
jle_else.40839:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.2523
jle_else.40836:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.40841
	mov	%g3, %g7
	return
jle_else.40841:
	jlt	%g8, %g3, jle_else.40842
	jne	%g8, %g3, jeq_else.40843
	mov	%g3, %g5
	return
jeq_else.40843:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.2523
jle_else.40842:
	jmp	div_binary_search.2523
jle_else.40833:
	add	%g5, %g6, %g7
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g7, %g6
	jlt	%g28, %g9, jle_else.40844
	mov	%g3, %g6
	return
jle_else.40844:
	jlt	%g8, %g3, jle_else.40845
	jne	%g8, %g3, jeq_else.40846
	mov	%g3, %g5
	return
jeq_else.40846:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.40847
	mov	%g3, %g6
	return
jle_else.40847:
	jlt	%g8, %g3, jle_else.40848
	jne	%g8, %g3, jeq_else.40849
	mov	%g3, %g7
	return
jeq_else.40849:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.2523
jle_else.40848:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.2523
jle_else.40845:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.40850
	mov	%g3, %g5
	return
jle_else.40850:
	jlt	%g8, %g3, jle_else.40851
	jne	%g8, %g3, jeq_else.40852
	mov	%g3, %g6
	return
jeq_else.40852:
	jmp	div_binary_search.2523
jle_else.40851:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.2523
jle_else.40830:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.40853
	mov	%g3, %g7
	return
jle_else.40853:
	jlt	%g8, %g3, jle_else.40854
	jne	%g8, %g3, jeq_else.40855
	mov	%g3, %g5
	return
jeq_else.40855:
	add	%g6, %g7, %g5
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g5, %g7
	jlt	%g28, %g9, jle_else.40856
	mov	%g3, %g7
	return
jle_else.40856:
	jlt	%g8, %g3, jle_else.40857
	jne	%g8, %g3, jeq_else.40858
	mov	%g3, %g6
	return
jeq_else.40858:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.40859
	mov	%g3, %g7
	return
jle_else.40859:
	jlt	%g8, %g3, jle_else.40860
	jne	%g8, %g3, jeq_else.40861
	mov	%g3, %g5
	return
jeq_else.40861:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.2523
jle_else.40860:
	jmp	div_binary_search.2523
jle_else.40857:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.40862
	mov	%g3, %g6
	return
jle_else.40862:
	jlt	%g8, %g3, jle_else.40863
	jne	%g8, %g3, jeq_else.40864
	mov	%g3, %g7
	return
jeq_else.40864:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.2523
jle_else.40863:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.2523
jle_else.40854:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.40865
	mov	%g3, %g5
	return
jle_else.40865:
	jlt	%g8, %g3, jle_else.40866
	jne	%g8, %g3, jeq_else.40867
	mov	%g3, %g7
	return
jeq_else.40867:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.40868
	mov	%g3, %g5
	return
jle_else.40868:
	jlt	%g8, %g3, jle_else.40869
	jne	%g8, %g3, jeq_else.40870
	mov	%g3, %g6
	return
jeq_else.40870:
	jmp	div_binary_search.2523
jle_else.40869:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.2523
jle_else.40866:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.40871
	mov	%g3, %g7
	return
jle_else.40871:
	jlt	%g8, %g3, jle_else.40872
	jne	%g8, %g3, jeq_else.40873
	mov	%g3, %g5
	return
jeq_else.40873:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.2523
jle_else.40872:
	jmp	div_binary_search.2523
print_int.2528:
	addi	%g4, %g0, 1000
	jlt	%g3, %g4, jle_else.40874
	return
jle_else.40874:
	jlt	%g3, %g0, jge_else.40876
	addi	%g4, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g10, %g0, 5
	addi	%g11, %g0, 500
	st	%g3, %g1, 0
	jlt	%g11, %g3, jle_else.40877
	jne	%g11, %g3, jeq_else.40879
	addi	%g3, %g0, 5
	jmp	jeq_cont.40880
jeq_else.40879:
	addi	%g6, %g0, 2
	addi	%g11, %g0, 200
	jlt	%g11, %g3, jle_else.40881
	jne	%g11, %g3, jeq_else.40883
	addi	%g3, %g0, 2
	jmp	jeq_cont.40884
jeq_else.40883:
	addi	%g10, %g0, 1
	addi	%g11, %g0, 100
	jlt	%g11, %g3, jle_else.40885
	jne	%g11, %g3, jeq_else.40887
	addi	%g3, %g0, 1
	jmp	jeq_cont.40888
jeq_else.40887:
	mov	%g6, %g10
	subi	%g1, %g1, 8
	call	div_binary_search.2523
	addi	%g1, %g1, 8
jeq_cont.40888:
	jmp	jle_cont.40886
jle_else.40885:
	mov	%g5, %g10
	subi	%g1, %g1, 8
	call	div_binary_search.2523
	addi	%g1, %g1, 8
jle_cont.40886:
jeq_cont.40884:
	jmp	jle_cont.40882
jle_else.40881:
	addi	%g5, %g0, 3
	addi	%g11, %g0, 300
	jlt	%g11, %g3, jle_else.40889
	jne	%g11, %g3, jeq_else.40891
	addi	%g3, %g0, 3
	jmp	jeq_cont.40892
jeq_else.40891:
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 8
	call	div_binary_search.2523
	addi	%g1, %g1, 8
jeq_cont.40892:
	jmp	jle_cont.40890
jle_else.40889:
	mov	%g6, %g10
	subi	%g1, %g1, 8
	call	div_binary_search.2523
	addi	%g1, %g1, 8
jle_cont.40890:
jle_cont.40882:
jeq_cont.40880:
	jmp	jle_cont.40878
jle_else.40877:
	addi	%g5, %g0, 7
	addi	%g11, %g0, 700
	jlt	%g11, %g3, jle_else.40893
	jne	%g11, %g3, jeq_else.40895
	addi	%g3, %g0, 7
	jmp	jeq_cont.40896
jeq_else.40895:
	addi	%g6, %g0, 6
	addi	%g11, %g0, 600
	jlt	%g11, %g3, jle_else.40897
	jne	%g11, %g3, jeq_else.40899
	addi	%g3, %g0, 6
	jmp	jeq_cont.40900
jeq_else.40899:
	mov	%g5, %g10
	subi	%g1, %g1, 8
	call	div_binary_search.2523
	addi	%g1, %g1, 8
jeq_cont.40900:
	jmp	jle_cont.40898
jle_else.40897:
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 8
	call	div_binary_search.2523
	addi	%g1, %g1, 8
jle_cont.40898:
jeq_cont.40896:
	jmp	jle_cont.40894
jle_else.40893:
	addi	%g10, %g0, 8
	addi	%g11, %g0, 800
	jlt	%g11, %g3, jle_else.40901
	jne	%g11, %g3, jeq_else.40903
	addi	%g3, %g0, 8
	jmp	jeq_cont.40904
jeq_else.40903:
	mov	%g6, %g10
	subi	%g1, %g1, 8
	call	div_binary_search.2523
	addi	%g1, %g1, 8
jeq_cont.40904:
	jmp	jle_cont.40902
jle_else.40901:
	mov	%g5, %g10
	subi	%g1, %g1, 8
	call	div_binary_search.2523
	addi	%g1, %g1, 8
jle_cont.40902:
jle_cont.40894:
jle_cont.40878:
	muli	%g10, %g3, 100
	ld	%g11, %g1, 0
	sub	%g10, %g11, %g10
	jlt	%g0, %g3, jle_else.40905
	addi	%g3, %g0, 0
	jmp	jle_cont.40906
jle_else.40905:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.40906:
	addi	%g4, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 50
	st	%g3, %g1, 4
	jlt	%g12, %g10, jle_else.40907
	jne	%g12, %g10, jeq_else.40909
	addi	%g3, %g0, 5
	jmp	jeq_cont.40910
jeq_else.40909:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20
	jlt	%g12, %g10, jle_else.40911
	jne	%g12, %g10, jeq_else.40913
	addi	%g3, %g0, 2
	jmp	jeq_cont.40914
jeq_else.40913:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10
	jlt	%g12, %g10, jle_else.40915
	jne	%g12, %g10, jeq_else.40917
	addi	%g3, %g0, 1
	jmp	jeq_cont.40918
jeq_else.40917:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 12
	call	div_binary_search.2523
	addi	%g1, %g1, 12
jeq_cont.40918:
	jmp	jle_cont.40916
jle_else.40915:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 12
	call	div_binary_search.2523
	addi	%g1, %g1, 12
jle_cont.40916:
jeq_cont.40914:
	jmp	jle_cont.40912
jle_else.40911:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30
	jlt	%g12, %g10, jle_else.40919
	jne	%g12, %g10, jeq_else.40921
	addi	%g3, %g0, 3
	jmp	jeq_cont.40922
jeq_else.40921:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 12
	call	div_binary_search.2523
	addi	%g1, %g1, 12
jeq_cont.40922:
	jmp	jle_cont.40920
jle_else.40919:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 12
	call	div_binary_search.2523
	addi	%g1, %g1, 12
jle_cont.40920:
jle_cont.40912:
jeq_cont.40910:
	jmp	jle_cont.40908
jle_else.40907:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 70
	jlt	%g12, %g10, jle_else.40923
	jne	%g12, %g10, jeq_else.40925
	addi	%g3, %g0, 7
	jmp	jeq_cont.40926
jeq_else.40925:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 60
	jlt	%g12, %g10, jle_else.40927
	jne	%g12, %g10, jeq_else.40929
	addi	%g3, %g0, 6
	jmp	jeq_cont.40930
jeq_else.40929:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 12
	call	div_binary_search.2523
	addi	%g1, %g1, 12
jeq_cont.40930:
	jmp	jle_cont.40928
jle_else.40927:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 12
	call	div_binary_search.2523
	addi	%g1, %g1, 12
jle_cont.40928:
jeq_cont.40926:
	jmp	jle_cont.40924
jle_else.40923:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 80
	jlt	%g12, %g10, jle_else.40931
	jne	%g12, %g10, jeq_else.40933
	addi	%g3, %g0, 8
	jmp	jeq_cont.40934
jeq_else.40933:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 12
	call	div_binary_search.2523
	addi	%g1, %g1, 12
jeq_cont.40934:
	jmp	jle_cont.40932
jle_else.40931:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 12
	call	div_binary_search.2523
	addi	%g1, %g1, 12
jle_cont.40932:
jle_cont.40924:
jle_cont.40908:
	muli	%g11, %g3, 10
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.40935
	ld	%g11, %g1, 4
	jne	%g11, %g0, jeq_else.40937
	addi	%g3, %g0, 0
	jmp	jeq_cont.40938
jeq_else.40937:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.40938:
	jmp	jle_cont.40936
jle_else.40935:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.40936:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g10
	output	%g3
	return
jge_else.40876:
	addi	%g10, %g0, 45
	st	%g3, %g1, 0
	output	%g10
	ld	%g3, %g1, 0
	sub	%g3, %g0, %g3
	jmp	print_int.2528
read_object.2696:
	ld	%g10, %g31, 852
	ld	%g11, %g31, 848
	ld	%g12, %g31, 844
	ld	%g13, %g31, 840
	ld	%g14, %g31, 836
	ld	%g15, %g31, 832
	ld	%g16, %g31, 820
	ld	%g17, %g31, 828
	addi	%g18, %g0, 60
	jlt	%g3, %g18, jle_else.40939
	return
jle_else.40939:
	addi	%g18, %g0, 0
	st	%g18, %g10, 0
	addi	%g18, %g0, 0
	st	%g18, %g11, 0
	st	%g3, %g1, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40941
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40943
	addi	%g4, %g0, 0
	jmp	jle_cont.40944
jle_else.40943:
	addi	%g4, %g0, 1
jle_cont.40944:
	jmp	jle_cont.40942
jle_else.40941:
	addi	%g4, %g0, 1
jle_cont.40942:
	st	%g14, %g1, 4
	st	%g13, %g1, 8
	st	%g12, %g1, 12
	st	%g11, %g1, 16
	st	%g10, %g1, 20
	jne	%g4, %g0, jeq_else.40945
	ld	%g4, %g11, 0
	jne	%g4, %g0, jeq_else.40947
	addi	%g4, %g0, 1
	st	%g4, %g11, 0
	jmp	jeq_cont.40948
jeq_else.40947:
jeq_cont.40948:
	ld	%g4, %g10, 0
	slli	%g18, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g18, %g4
	subi	%g18, %g3, 48
	add	%g4, %g4, %g18
	st	%g4, %g10, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 28
	call	read_int_token.2507
	addi	%g1, %g1, 28
	mov	%g10, %g3
	jmp	jeq_cont.40946
jeq_else.40945:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 28
	call	read_int_token.2507
	addi	%g1, %g1, 28
	mov	%g10, %g3
jeq_cont.40946:
	jne	%g10, %g29, jeq_else.40949
	addi	%g3, %g0, 0
	jmp	jeq_cont.40950
jeq_else.40949:
	addi	%g11, %g0, 0
	ld	%g12, %g1, 20
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 16
	st	%g11, %g13, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40951
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40953
	addi	%g4, %g0, 0
	jmp	jle_cont.40954
jle_else.40953:
	addi	%g4, %g0, 1
jle_cont.40954:
	jmp	jle_cont.40952
jle_else.40951:
	addi	%g4, %g0, 1
jle_cont.40952:
	st	%g10, %g1, 24
	jne	%g4, %g0, jeq_else.40955
	ld	%g4, %g13, 0
	jne	%g4, %g0, jeq_else.40957
	addi	%g4, %g0, 1
	st	%g4, %g13, 0
	jmp	jeq_cont.40958
jeq_else.40957:
jeq_cont.40958:
	ld	%g4, %g12, 0
	slli	%g18, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g18, %g4
	subi	%g18, %g3, 48
	add	%g4, %g4, %g18
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 32
	call	read_int_token.2507
	addi	%g1, %g1, 32
	mov	%g10, %g3
	jmp	jeq_cont.40956
jeq_else.40955:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 32
	call	read_int_token.2507
	addi	%g1, %g1, 32
	mov	%g10, %g3
jeq_cont.40956:
	addi	%g11, %g0, 0
	ld	%g12, %g1, 20
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 16
	st	%g11, %g13, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40959
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40961
	addi	%g4, %g0, 0
	jmp	jle_cont.40962
jle_else.40961:
	addi	%g4, %g0, 1
jle_cont.40962:
	jmp	jle_cont.40960
jle_else.40959:
	addi	%g4, %g0, 1
jle_cont.40960:
	st	%g10, %g1, 28
	jne	%g4, %g0, jeq_else.40963
	ld	%g4, %g13, 0
	jne	%g4, %g0, jeq_else.40965
	addi	%g4, %g0, 1
	st	%g4, %g13, 0
	jmp	jeq_cont.40966
jeq_else.40965:
jeq_cont.40966:
	ld	%g4, %g12, 0
	slli	%g18, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g18, %g4
	subi	%g18, %g3, 48
	add	%g4, %g4, %g18
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 36
	call	read_int_token.2507
	addi	%g1, %g1, 36
	mov	%g10, %g3
	jmp	jeq_cont.40964
jeq_else.40963:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 36
	call	read_int_token.2507
	addi	%g1, %g1, 36
	mov	%g10, %g3
jeq_cont.40964:
	addi	%g11, %g0, 0
	ld	%g12, %g1, 20
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 16
	st	%g11, %g13, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40967
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40969
	addi	%g4, %g0, 0
	jmp	jle_cont.40970
jle_else.40969:
	addi	%g4, %g0, 1
jle_cont.40970:
	jmp	jle_cont.40968
jle_else.40967:
	addi	%g4, %g0, 1
jle_cont.40968:
	st	%g10, %g1, 32
	jne	%g4, %g0, jeq_else.40971
	ld	%g4, %g13, 0
	jne	%g4, %g0, jeq_else.40973
	addi	%g4, %g0, 1
	st	%g4, %g13, 0
	jmp	jeq_cont.40974
jeq_else.40973:
jeq_cont.40974:
	ld	%g4, %g12, 0
	slli	%g18, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g18, %g4
	subi	%g18, %g3, 48
	add	%g4, %g4, %g18
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 40
	call	read_int_token.2507
	addi	%g1, %g1, 40
	jmp	jeq_cont.40972
jeq_else.40971:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 40
	call	read_int_token.2507
	addi	%g1, %g1, 40
jeq_cont.40972:
	addi	%g10, %g0, 3
	fmov	%f0, %f16
	st	%g3, %g1, 36
	fst	%f0, %g1, 40
	mov	%g3, %g10
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	mov	%g10, %g3
	addi	%g11, %g0, 0
	ld	%g12, %g1, 12
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 8
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	ld	%g14, %g1, 4
	st	%g11, %g14, 0
	addi	%g11, %g0, 0
	st	%g11, %g15, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40975
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40977
	addi	%g4, %g0, 0
	jmp	jle_cont.40978
jle_else.40977:
	addi	%g4, %g0, 1
jle_cont.40978:
	jmp	jle_cont.40976
jle_else.40975:
	addi	%g4, %g0, 1
jle_cont.40976:
	st	%g10, %g1, 44
	jne	%g4, %g0, jeq_else.40979
	ld	%g4, %g15, 0
	jne	%g4, %g0, jeq_else.40981
	addi	%g4, %g0, 1
	st	%g4, %g15, 0
	jmp	jeq_cont.40982
jeq_else.40981:
jeq_cont.40982:
	ld	%g4, %g12, 0
	slli	%g18, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g18, %g4
	subi	%g18, %g3, 48
	add	%g4, %g4, %g18
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 52
	call	read_float_token1.2516
	addi	%g1, %g1, 52
	mov	%g10, %g3
	jmp	jeq_cont.40980
jeq_else.40979:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 52
	call	read_float_token1.2516
	addi	%g1, %g1, 52
	mov	%g10, %g3
jeq_cont.40980:
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.40983
	input	%g3
	addi	%g18, %g0, 48
	jlt	%g3, %g18, jle_else.40985
	addi	%g18, %g0, 57
	jlt	%g18, %g3, jle_else.40987
	addi	%g18, %g0, 0
	jmp	jle_cont.40988
jle_else.40987:
	addi	%g18, %g0, 1
jle_cont.40988:
	jmp	jle_cont.40986
jle_else.40985:
	addi	%g18, %g0, 1
jle_cont.40986:
	jne	%g18, %g0, jeq_else.40989
	ld	%g18, %g1, 8
	ld	%g19, %g18, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	subi	%g3, %g3, 48
	add	%g3, %g19, %g3
	st	%g3, %g18, 0
	ld	%g3, %g1, 4
	ld	%g19, %g3, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	st	%g19, %g3, 0
	addi	%g19, %g0, 1
	mov	%g3, %g19
	subi	%g1, %g1, 52
	call	read_float_token2.2519
	addi	%g1, %g1, 52
	jmp	jeq_cont.40990
jeq_else.40989:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 52
	call	read_float_token2.2519
	addi	%g1, %g1, 52
jeq_cont.40990:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 52
	call	min_caml_float_of_int
	addi	%g1, %g1, 52
	fmov	%f10, %f0, 0
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 52
	call	min_caml_float_of_int
	addi	%g1, %g1, 52
	fmov	%f11, %f0, 0
	ld	%g3, %g1, 4
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 52
	call	min_caml_float_of_int
	addi	%g1, %g1, 52
	fdiv	%f0, %f11, %f0
	fadd	%f0, %f10, %f0
	jmp	jeq_cont.40984
jeq_else.40983:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 52
	call	min_caml_float_of_int
	addi	%g1, %g1, 52
jeq_cont.40984:
	ld	%g10, %g15, 0
	jne	%g10, %g28, jeq_else.40991
	jmp	jeq_cont.40992
jeq_else.40991:
	fneg	%f0, %f0
jeq_cont.40992:
	ld	%g10, %g1, 44
	fst	%f0, %g10, 0
	addi	%g11, %g0, 0
	ld	%g12, %g1, 12
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 8
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	ld	%g14, %g1, 4
	st	%g11, %g14, 0
	addi	%g11, %g0, 0
	st	%g11, %g15, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.40993
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.40995
	addi	%g4, %g0, 0
	jmp	jle_cont.40996
jle_else.40995:
	addi	%g4, %g0, 1
jle_cont.40996:
	jmp	jle_cont.40994
jle_else.40993:
	addi	%g4, %g0, 1
jle_cont.40994:
	jne	%g4, %g0, jeq_else.40997
	ld	%g4, %g15, 0
	jne	%g4, %g0, jeq_else.40999
	addi	%g4, %g0, 1
	st	%g4, %g15, 0
	jmp	jeq_cont.41000
jeq_else.40999:
jeq_cont.41000:
	ld	%g4, %g12, 0
	slli	%g18, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g18, %g4
	subi	%g18, %g3, 48
	add	%g4, %g4, %g18
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 52
	call	read_float_token1.2516
	addi	%g1, %g1, 52
	mov	%g10, %g3
	jmp	jeq_cont.40998
jeq_else.40997:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 52
	call	read_float_token1.2516
	addi	%g1, %g1, 52
	mov	%g10, %g3
jeq_cont.40998:
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.41001
	input	%g3
	addi	%g18, %g0, 48
	jlt	%g3, %g18, jle_else.41003
	addi	%g18, %g0, 57
	jlt	%g18, %g3, jle_else.41005
	addi	%g18, %g0, 0
	jmp	jle_cont.41006
jle_else.41005:
	addi	%g18, %g0, 1
jle_cont.41006:
	jmp	jle_cont.41004
jle_else.41003:
	addi	%g18, %g0, 1
jle_cont.41004:
	jne	%g18, %g0, jeq_else.41007
	ld	%g18, %g1, 8
	ld	%g19, %g18, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	subi	%g3, %g3, 48
	add	%g3, %g19, %g3
	st	%g3, %g18, 0
	ld	%g3, %g1, 4
	ld	%g19, %g3, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	st	%g19, %g3, 0
	addi	%g19, %g0, 1
	mov	%g3, %g19
	subi	%g1, %g1, 52
	call	read_float_token2.2519
	addi	%g1, %g1, 52
	jmp	jeq_cont.41008
jeq_else.41007:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 52
	call	read_float_token2.2519
	addi	%g1, %g1, 52
jeq_cont.41008:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 52
	call	min_caml_float_of_int
	addi	%g1, %g1, 52
	fmov	%f10, %f0, 0
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 52
	call	min_caml_float_of_int
	addi	%g1, %g1, 52
	fmov	%f11, %f0, 0
	ld	%g3, %g1, 4
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 52
	call	min_caml_float_of_int
	addi	%g1, %g1, 52
	fdiv	%f0, %f11, %f0
	fadd	%f0, %f10, %f0
	jmp	jeq_cont.41002
jeq_else.41001:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 52
	call	min_caml_float_of_int
	addi	%g1, %g1, 52
jeq_cont.41002:
	ld	%g10, %g15, 0
	jne	%g10, %g28, jeq_else.41009
	jmp	jeq_cont.41010
jeq_else.41009:
	fneg	%f0, %f0
jeq_cont.41010:
	ld	%g10, %g1, 44
	fst	%f0, %g10, -4
	addi	%g11, %g0, 0
	ld	%g12, %g1, 12
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 8
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	ld	%g14, %g1, 4
	st	%g11, %g14, 0
	addi	%g11, %g0, 0
	st	%g11, %g15, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41011
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41013
	addi	%g4, %g0, 0
	jmp	jle_cont.41014
jle_else.41013:
	addi	%g4, %g0, 1
jle_cont.41014:
	jmp	jle_cont.41012
jle_else.41011:
	addi	%g4, %g0, 1
jle_cont.41012:
	jne	%g4, %g0, jeq_else.41015
	ld	%g4, %g15, 0
	jne	%g4, %g0, jeq_else.41017
	addi	%g4, %g0, 1
	st	%g4, %g15, 0
	jmp	jeq_cont.41018
jeq_else.41017:
jeq_cont.41018:
	ld	%g4, %g12, 0
	slli	%g18, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g18, %g4
	subi	%g18, %g3, 48
	add	%g4, %g4, %g18
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 52
	call	read_float_token1.2516
	addi	%g1, %g1, 52
	mov	%g10, %g3
	jmp	jeq_cont.41016
jeq_else.41015:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 52
	call	read_float_token1.2516
	addi	%g1, %g1, 52
	mov	%g10, %g3
jeq_cont.41016:
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.41019
	input	%g3
	addi	%g18, %g0, 48
	jlt	%g3, %g18, jle_else.41021
	addi	%g18, %g0, 57
	jlt	%g18, %g3, jle_else.41023
	addi	%g18, %g0, 0
	jmp	jle_cont.41024
jle_else.41023:
	addi	%g18, %g0, 1
jle_cont.41024:
	jmp	jle_cont.41022
jle_else.41021:
	addi	%g18, %g0, 1
jle_cont.41022:
	jne	%g18, %g0, jeq_else.41025
	ld	%g18, %g1, 8
	ld	%g19, %g18, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	subi	%g3, %g3, 48
	add	%g3, %g19, %g3
	st	%g3, %g18, 0
	ld	%g3, %g1, 4
	ld	%g19, %g3, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	st	%g19, %g3, 0
	addi	%g19, %g0, 1
	mov	%g3, %g19
	subi	%g1, %g1, 52
	call	read_float_token2.2519
	addi	%g1, %g1, 52
	jmp	jeq_cont.41026
jeq_else.41025:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 52
	call	read_float_token2.2519
	addi	%g1, %g1, 52
jeq_cont.41026:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 52
	call	min_caml_float_of_int
	addi	%g1, %g1, 52
	fmov	%f10, %f0, 0
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 52
	call	min_caml_float_of_int
	addi	%g1, %g1, 52
	fmov	%f11, %f0, 0
	ld	%g3, %g1, 4
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 52
	call	min_caml_float_of_int
	addi	%g1, %g1, 52
	fdiv	%f0, %f11, %f0
	fadd	%f0, %f10, %f0
	jmp	jeq_cont.41020
jeq_else.41019:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 52
	call	min_caml_float_of_int
	addi	%g1, %g1, 52
jeq_cont.41020:
	ld	%g3, %g15, 0
	jne	%g3, %g28, jeq_else.41027
	jmp	jeq_cont.41028
jeq_else.41027:
	fneg	%f0, %f0
jeq_cont.41028:
	ld	%g3, %g1, 44
	fst	%f0, %g3, -8
	addi	%g10, %g0, 3
	fld	%f0, %g1, 40
	mov	%g3, %g10
	subi	%g1, %g1, 52
	call	min_caml_create_float_array
	addi	%g1, %g1, 52
	mov	%g10, %g3
	addi	%g11, %g0, 0
	ld	%g12, %g1, 12
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 8
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	ld	%g14, %g1, 4
	st	%g11, %g14, 0
	addi	%g11, %g0, 0
	st	%g11, %g15, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41029
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41031
	addi	%g4, %g0, 0
	jmp	jle_cont.41032
jle_else.41031:
	addi	%g4, %g0, 1
jle_cont.41032:
	jmp	jle_cont.41030
jle_else.41029:
	addi	%g4, %g0, 1
jle_cont.41030:
	st	%g10, %g1, 48
	jne	%g4, %g0, jeq_else.41033
	ld	%g4, %g15, 0
	jne	%g4, %g0, jeq_else.41035
	addi	%g4, %g0, 1
	st	%g4, %g15, 0
	jmp	jeq_cont.41036
jeq_else.41035:
jeq_cont.41036:
	ld	%g4, %g12, 0
	slli	%g18, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g18, %g4
	subi	%g18, %g3, 48
	add	%g4, %g4, %g18
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 56
	call	read_float_token1.2516
	addi	%g1, %g1, 56
	mov	%g10, %g3
	jmp	jeq_cont.41034
jeq_else.41033:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 56
	call	read_float_token1.2516
	addi	%g1, %g1, 56
	mov	%g10, %g3
jeq_cont.41034:
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.41037
	input	%g3
	addi	%g18, %g0, 48
	jlt	%g3, %g18, jle_else.41039
	addi	%g18, %g0, 57
	jlt	%g18, %g3, jle_else.41041
	addi	%g18, %g0, 0
	jmp	jle_cont.41042
jle_else.41041:
	addi	%g18, %g0, 1
jle_cont.41042:
	jmp	jle_cont.41040
jle_else.41039:
	addi	%g18, %g0, 1
jle_cont.41040:
	jne	%g18, %g0, jeq_else.41043
	ld	%g18, %g1, 8
	ld	%g19, %g18, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	subi	%g3, %g3, 48
	add	%g3, %g19, %g3
	st	%g3, %g18, 0
	ld	%g3, %g1, 4
	ld	%g19, %g3, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	st	%g19, %g3, 0
	addi	%g19, %g0, 1
	mov	%g3, %g19
	subi	%g1, %g1, 56
	call	read_float_token2.2519
	addi	%g1, %g1, 56
	jmp	jeq_cont.41044
jeq_else.41043:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 56
	call	read_float_token2.2519
	addi	%g1, %g1, 56
jeq_cont.41044:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
	fmov	%f10, %f0, 0
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
	fmov	%f11, %f0, 0
	ld	%g3, %g1, 4
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
	fdiv	%f0, %f11, %f0
	fadd	%f0, %f10, %f0
	jmp	jeq_cont.41038
jeq_else.41037:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
jeq_cont.41038:
	ld	%g10, %g15, 0
	jne	%g10, %g28, jeq_else.41045
	jmp	jeq_cont.41046
jeq_else.41045:
	fneg	%f0, %f0
jeq_cont.41046:
	ld	%g10, %g1, 48
	fst	%f0, %g10, 0
	addi	%g11, %g0, 0
	ld	%g12, %g1, 12
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 8
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	ld	%g14, %g1, 4
	st	%g11, %g14, 0
	addi	%g11, %g0, 0
	st	%g11, %g15, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41047
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41049
	addi	%g4, %g0, 0
	jmp	jle_cont.41050
jle_else.41049:
	addi	%g4, %g0, 1
jle_cont.41050:
	jmp	jle_cont.41048
jle_else.41047:
	addi	%g4, %g0, 1
jle_cont.41048:
	jne	%g4, %g0, jeq_else.41051
	ld	%g4, %g15, 0
	jne	%g4, %g0, jeq_else.41053
	addi	%g4, %g0, 1
	st	%g4, %g15, 0
	jmp	jeq_cont.41054
jeq_else.41053:
jeq_cont.41054:
	ld	%g4, %g12, 0
	slli	%g18, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g18, %g4
	subi	%g18, %g3, 48
	add	%g4, %g4, %g18
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 56
	call	read_float_token1.2516
	addi	%g1, %g1, 56
	mov	%g10, %g3
	jmp	jeq_cont.41052
jeq_else.41051:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 56
	call	read_float_token1.2516
	addi	%g1, %g1, 56
	mov	%g10, %g3
jeq_cont.41052:
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.41055
	input	%g3
	addi	%g18, %g0, 48
	jlt	%g3, %g18, jle_else.41057
	addi	%g18, %g0, 57
	jlt	%g18, %g3, jle_else.41059
	addi	%g18, %g0, 0
	jmp	jle_cont.41060
jle_else.41059:
	addi	%g18, %g0, 1
jle_cont.41060:
	jmp	jle_cont.41058
jle_else.41057:
	addi	%g18, %g0, 1
jle_cont.41058:
	jne	%g18, %g0, jeq_else.41061
	ld	%g18, %g1, 8
	ld	%g19, %g18, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	subi	%g3, %g3, 48
	add	%g3, %g19, %g3
	st	%g3, %g18, 0
	ld	%g3, %g1, 4
	ld	%g19, %g3, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	st	%g19, %g3, 0
	addi	%g19, %g0, 1
	mov	%g3, %g19
	subi	%g1, %g1, 56
	call	read_float_token2.2519
	addi	%g1, %g1, 56
	jmp	jeq_cont.41062
jeq_else.41061:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 56
	call	read_float_token2.2519
	addi	%g1, %g1, 56
jeq_cont.41062:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
	fmov	%f10, %f0, 0
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
	fmov	%f11, %f0, 0
	ld	%g3, %g1, 4
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
	fdiv	%f0, %f11, %f0
	fadd	%f0, %f10, %f0
	jmp	jeq_cont.41056
jeq_else.41055:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
jeq_cont.41056:
	ld	%g10, %g15, 0
	jne	%g10, %g28, jeq_else.41063
	jmp	jeq_cont.41064
jeq_else.41063:
	fneg	%f0, %f0
jeq_cont.41064:
	ld	%g10, %g1, 48
	fst	%f0, %g10, -4
	addi	%g11, %g0, 0
	ld	%g12, %g1, 12
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 8
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	ld	%g14, %g1, 4
	st	%g11, %g14, 0
	addi	%g11, %g0, 0
	st	%g11, %g15, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41065
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41067
	addi	%g4, %g0, 0
	jmp	jle_cont.41068
jle_else.41067:
	addi	%g4, %g0, 1
jle_cont.41068:
	jmp	jle_cont.41066
jle_else.41065:
	addi	%g4, %g0, 1
jle_cont.41066:
	jne	%g4, %g0, jeq_else.41069
	ld	%g4, %g15, 0
	jne	%g4, %g0, jeq_else.41071
	addi	%g4, %g0, 1
	st	%g4, %g15, 0
	jmp	jeq_cont.41072
jeq_else.41071:
jeq_cont.41072:
	ld	%g4, %g12, 0
	slli	%g18, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g18, %g4
	subi	%g18, %g3, 48
	add	%g4, %g4, %g18
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 56
	call	read_float_token1.2516
	addi	%g1, %g1, 56
	mov	%g10, %g3
	jmp	jeq_cont.41070
jeq_else.41069:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 56
	call	read_float_token1.2516
	addi	%g1, %g1, 56
	mov	%g10, %g3
jeq_cont.41070:
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.41073
	input	%g3
	addi	%g18, %g0, 48
	jlt	%g3, %g18, jle_else.41075
	addi	%g18, %g0, 57
	jlt	%g18, %g3, jle_else.41077
	addi	%g18, %g0, 0
	jmp	jle_cont.41078
jle_else.41077:
	addi	%g18, %g0, 1
jle_cont.41078:
	jmp	jle_cont.41076
jle_else.41075:
	addi	%g18, %g0, 1
jle_cont.41076:
	jne	%g18, %g0, jeq_else.41079
	ld	%g18, %g1, 8
	ld	%g19, %g18, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	subi	%g3, %g3, 48
	add	%g3, %g19, %g3
	st	%g3, %g18, 0
	ld	%g3, %g1, 4
	ld	%g19, %g3, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	st	%g19, %g3, 0
	addi	%g19, %g0, 1
	mov	%g3, %g19
	subi	%g1, %g1, 56
	call	read_float_token2.2519
	addi	%g1, %g1, 56
	jmp	jeq_cont.41080
jeq_else.41079:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 56
	call	read_float_token2.2519
	addi	%g1, %g1, 56
jeq_cont.41080:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
	fmov	%f10, %f0, 0
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
	fmov	%f11, %f0, 0
	ld	%g3, %g1, 4
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
	fdiv	%f0, %f11, %f0
	fadd	%f0, %f10, %f0
	jmp	jeq_cont.41074
jeq_else.41073:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
jeq_cont.41074:
	ld	%g10, %g15, 0
	jne	%g10, %g28, jeq_else.41081
	jmp	jeq_cont.41082
jeq_else.41081:
	fneg	%f0, %f0
jeq_cont.41082:
	ld	%g10, %g1, 48
	fst	%f0, %g10, -8
	addi	%g11, %g0, 0
	ld	%g12, %g1, 12
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 8
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	ld	%g14, %g1, 4
	st	%g11, %g14, 0
	addi	%g11, %g0, 0
	st	%g11, %g15, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41083
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41085
	addi	%g4, %g0, 0
	jmp	jle_cont.41086
jle_else.41085:
	addi	%g4, %g0, 1
jle_cont.41086:
	jmp	jle_cont.41084
jle_else.41083:
	addi	%g4, %g0, 1
jle_cont.41084:
	jne	%g4, %g0, jeq_else.41087
	ld	%g4, %g15, 0
	jne	%g4, %g0, jeq_else.41089
	addi	%g4, %g0, 1
	st	%g4, %g15, 0
	jmp	jeq_cont.41090
jeq_else.41089:
jeq_cont.41090:
	ld	%g4, %g12, 0
	slli	%g18, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g18, %g4
	subi	%g18, %g3, 48
	add	%g4, %g4, %g18
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 56
	call	read_float_token1.2516
	addi	%g1, %g1, 56
	mov	%g10, %g3
	jmp	jeq_cont.41088
jeq_else.41087:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 56
	call	read_float_token1.2516
	addi	%g1, %g1, 56
	mov	%g10, %g3
jeq_cont.41088:
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.41091
	input	%g3
	addi	%g18, %g0, 48
	jlt	%g3, %g18, jle_else.41093
	addi	%g18, %g0, 57
	jlt	%g18, %g3, jle_else.41095
	addi	%g18, %g0, 0
	jmp	jle_cont.41096
jle_else.41095:
	addi	%g18, %g0, 1
jle_cont.41096:
	jmp	jle_cont.41094
jle_else.41093:
	addi	%g18, %g0, 1
jle_cont.41094:
	jne	%g18, %g0, jeq_else.41097
	ld	%g18, %g1, 8
	ld	%g19, %g18, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	subi	%g3, %g3, 48
	add	%g3, %g19, %g3
	st	%g3, %g18, 0
	ld	%g3, %g1, 4
	ld	%g19, %g3, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	st	%g19, %g3, 0
	addi	%g19, %g0, 1
	mov	%g3, %g19
	subi	%g1, %g1, 56
	call	read_float_token2.2519
	addi	%g1, %g1, 56
	jmp	jeq_cont.41098
jeq_else.41097:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 56
	call	read_float_token2.2519
	addi	%g1, %g1, 56
jeq_cont.41098:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
	fmov	%f10, %f0, 0
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
	fmov	%f11, %f0, 0
	ld	%g3, %g1, 4
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
	fdiv	%f0, %f11, %f0
	fadd	%f0, %f10, %f0
	jmp	jeq_cont.41092
jeq_else.41091:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 56
	call	min_caml_float_of_int
	addi	%g1, %g1, 56
jeq_cont.41092:
	ld	%g3, %g15, 0
	jne	%g3, %g28, jeq_else.41099
	jmp	jeq_cont.41100
jeq_else.41099:
	fneg	%f0, %f0
jeq_cont.41100:
	addi	%g3, %g0, 2
	fld	%f1, %g1, 40
	fst	%f0, %g1, 52
	fmov	%f0, %f1
	subi	%g1, %g1, 60
	call	min_caml_create_float_array
	addi	%g1, %g1, 60
	mov	%g10, %g3
	addi	%g11, %g0, 0
	ld	%g12, %g1, 12
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 8
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	ld	%g14, %g1, 4
	st	%g11, %g14, 0
	addi	%g11, %g0, 0
	st	%g11, %g15, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41101
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41103
	addi	%g4, %g0, 0
	jmp	jle_cont.41104
jle_else.41103:
	addi	%g4, %g0, 1
jle_cont.41104:
	jmp	jle_cont.41102
jle_else.41101:
	addi	%g4, %g0, 1
jle_cont.41102:
	st	%g10, %g1, 56
	jne	%g4, %g0, jeq_else.41105
	ld	%g4, %g15, 0
	jne	%g4, %g0, jeq_else.41107
	addi	%g4, %g0, 1
	st	%g4, %g15, 0
	jmp	jeq_cont.41108
jeq_else.41107:
jeq_cont.41108:
	ld	%g4, %g12, 0
	slli	%g18, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g18, %g4
	subi	%g18, %g3, 48
	add	%g4, %g4, %g18
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 64
	call	read_float_token1.2516
	addi	%g1, %g1, 64
	mov	%g10, %g3
	jmp	jeq_cont.41106
jeq_else.41105:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 64
	call	read_float_token1.2516
	addi	%g1, %g1, 64
	mov	%g10, %g3
jeq_cont.41106:
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.41109
	input	%g3
	addi	%g18, %g0, 48
	jlt	%g3, %g18, jle_else.41111
	addi	%g18, %g0, 57
	jlt	%g18, %g3, jle_else.41113
	addi	%g18, %g0, 0
	jmp	jle_cont.41114
jle_else.41113:
	addi	%g18, %g0, 1
jle_cont.41114:
	jmp	jle_cont.41112
jle_else.41111:
	addi	%g18, %g0, 1
jle_cont.41112:
	jne	%g18, %g0, jeq_else.41115
	ld	%g18, %g1, 8
	ld	%g19, %g18, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	subi	%g3, %g3, 48
	add	%g3, %g19, %g3
	st	%g3, %g18, 0
	ld	%g3, %g1, 4
	ld	%g19, %g3, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	st	%g19, %g3, 0
	addi	%g19, %g0, 1
	mov	%g3, %g19
	subi	%g1, %g1, 64
	call	read_float_token2.2519
	addi	%g1, %g1, 64
	jmp	jeq_cont.41116
jeq_else.41115:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 64
	call	read_float_token2.2519
	addi	%g1, %g1, 64
jeq_cont.41116:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 64
	call	min_caml_float_of_int
	addi	%g1, %g1, 64
	fmov	%f10, %f0, 0
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 64
	call	min_caml_float_of_int
	addi	%g1, %g1, 64
	fmov	%f11, %f0, 0
	ld	%g3, %g1, 4
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 64
	call	min_caml_float_of_int
	addi	%g1, %g1, 64
	fdiv	%f0, %f11, %f0
	fadd	%f0, %f10, %f0
	jmp	jeq_cont.41110
jeq_else.41109:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 64
	call	min_caml_float_of_int
	addi	%g1, %g1, 64
jeq_cont.41110:
	ld	%g10, %g15, 0
	jne	%g10, %g28, jeq_else.41117
	jmp	jeq_cont.41118
jeq_else.41117:
	fneg	%f0, %f0
jeq_cont.41118:
	ld	%g10, %g1, 56
	fst	%f0, %g10, 0
	addi	%g11, %g0, 0
	ld	%g12, %g1, 12
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 8
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	ld	%g14, %g1, 4
	st	%g11, %g14, 0
	addi	%g11, %g0, 0
	st	%g11, %g15, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41119
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41121
	addi	%g4, %g0, 0
	jmp	jle_cont.41122
jle_else.41121:
	addi	%g4, %g0, 1
jle_cont.41122:
	jmp	jle_cont.41120
jle_else.41119:
	addi	%g4, %g0, 1
jle_cont.41120:
	jne	%g4, %g0, jeq_else.41123
	ld	%g4, %g15, 0
	jne	%g4, %g0, jeq_else.41125
	addi	%g4, %g0, 1
	st	%g4, %g15, 0
	jmp	jeq_cont.41126
jeq_else.41125:
jeq_cont.41126:
	ld	%g4, %g12, 0
	slli	%g18, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g18, %g4
	subi	%g18, %g3, 48
	add	%g4, %g4, %g18
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 64
	call	read_float_token1.2516
	addi	%g1, %g1, 64
	mov	%g10, %g3
	jmp	jeq_cont.41124
jeq_else.41123:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 64
	call	read_float_token1.2516
	addi	%g1, %g1, 64
	mov	%g10, %g3
jeq_cont.41124:
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.41127
	input	%g3
	addi	%g18, %g0, 48
	jlt	%g3, %g18, jle_else.41129
	addi	%g18, %g0, 57
	jlt	%g18, %g3, jle_else.41131
	addi	%g18, %g0, 0
	jmp	jle_cont.41132
jle_else.41131:
	addi	%g18, %g0, 1
jle_cont.41132:
	jmp	jle_cont.41130
jle_else.41129:
	addi	%g18, %g0, 1
jle_cont.41130:
	jne	%g18, %g0, jeq_else.41133
	ld	%g18, %g1, 8
	ld	%g19, %g18, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	subi	%g3, %g3, 48
	add	%g3, %g19, %g3
	st	%g3, %g18, 0
	ld	%g3, %g1, 4
	ld	%g19, %g3, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	st	%g19, %g3, 0
	addi	%g19, %g0, 1
	mov	%g3, %g19
	subi	%g1, %g1, 64
	call	read_float_token2.2519
	addi	%g1, %g1, 64
	jmp	jeq_cont.41134
jeq_else.41133:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 64
	call	read_float_token2.2519
	addi	%g1, %g1, 64
jeq_cont.41134:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 64
	call	min_caml_float_of_int
	addi	%g1, %g1, 64
	fmov	%f10, %f0, 0
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 64
	call	min_caml_float_of_int
	addi	%g1, %g1, 64
	fmov	%f11, %f0, 0
	ld	%g3, %g1, 4
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 64
	call	min_caml_float_of_int
	addi	%g1, %g1, 64
	fdiv	%f0, %f11, %f0
	fadd	%f0, %f10, %f0
	jmp	jeq_cont.41128
jeq_else.41127:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 64
	call	min_caml_float_of_int
	addi	%g1, %g1, 64
jeq_cont.41128:
	ld	%g3, %g15, 0
	jne	%g3, %g28, jeq_else.41135
	jmp	jeq_cont.41136
jeq_else.41135:
	fneg	%f0, %f0
jeq_cont.41136:
	ld	%g3, %g1, 56
	fst	%f0, %g3, -4
	addi	%g10, %g0, 3
	fld	%f0, %g1, 40
	mov	%g3, %g10
	subi	%g1, %g1, 64
	call	min_caml_create_float_array
	addi	%g1, %g1, 64
	mov	%g10, %g3
	addi	%g11, %g0, 0
	ld	%g12, %g1, 12
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 8
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	ld	%g14, %g1, 4
	st	%g11, %g14, 0
	addi	%g11, %g0, 0
	st	%g11, %g15, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41137
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41139
	addi	%g4, %g0, 0
	jmp	jle_cont.41140
jle_else.41139:
	addi	%g4, %g0, 1
jle_cont.41140:
	jmp	jle_cont.41138
jle_else.41137:
	addi	%g4, %g0, 1
jle_cont.41138:
	st	%g10, %g1, 60
	jne	%g4, %g0, jeq_else.41141
	ld	%g4, %g15, 0
	jne	%g4, %g0, jeq_else.41143
	addi	%g4, %g0, 1
	st	%g4, %g15, 0
	jmp	jeq_cont.41144
jeq_else.41143:
jeq_cont.41144:
	ld	%g4, %g12, 0
	slli	%g18, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g18, %g4
	subi	%g18, %g3, 48
	add	%g4, %g4, %g18
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 68
	call	read_float_token1.2516
	addi	%g1, %g1, 68
	mov	%g10, %g3
	jmp	jeq_cont.41142
jeq_else.41141:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 68
	call	read_float_token1.2516
	addi	%g1, %g1, 68
	mov	%g10, %g3
jeq_cont.41142:
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.41145
	input	%g3
	addi	%g18, %g0, 48
	jlt	%g3, %g18, jle_else.41147
	addi	%g18, %g0, 57
	jlt	%g18, %g3, jle_else.41149
	addi	%g18, %g0, 0
	jmp	jle_cont.41150
jle_else.41149:
	addi	%g18, %g0, 1
jle_cont.41150:
	jmp	jle_cont.41148
jle_else.41147:
	addi	%g18, %g0, 1
jle_cont.41148:
	jne	%g18, %g0, jeq_else.41151
	ld	%g18, %g1, 8
	ld	%g19, %g18, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	subi	%g3, %g3, 48
	add	%g3, %g19, %g3
	st	%g3, %g18, 0
	ld	%g3, %g1, 4
	ld	%g19, %g3, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	st	%g19, %g3, 0
	addi	%g19, %g0, 1
	mov	%g3, %g19
	subi	%g1, %g1, 68
	call	read_float_token2.2519
	addi	%g1, %g1, 68
	jmp	jeq_cont.41152
jeq_else.41151:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 68
	call	read_float_token2.2519
	addi	%g1, %g1, 68
jeq_cont.41152:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 68
	call	min_caml_float_of_int
	addi	%g1, %g1, 68
	fmov	%f10, %f0, 0
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 68
	call	min_caml_float_of_int
	addi	%g1, %g1, 68
	fmov	%f11, %f0, 0
	ld	%g3, %g1, 4
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 68
	call	min_caml_float_of_int
	addi	%g1, %g1, 68
	fdiv	%f0, %f11, %f0
	fadd	%f0, %f10, %f0
	jmp	jeq_cont.41146
jeq_else.41145:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 68
	call	min_caml_float_of_int
	addi	%g1, %g1, 68
jeq_cont.41146:
	ld	%g10, %g15, 0
	jne	%g10, %g28, jeq_else.41153
	jmp	jeq_cont.41154
jeq_else.41153:
	fneg	%f0, %f0
jeq_cont.41154:
	ld	%g10, %g1, 60
	fst	%f0, %g10, 0
	addi	%g11, %g0, 0
	ld	%g12, %g1, 12
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 8
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	ld	%g14, %g1, 4
	st	%g11, %g14, 0
	addi	%g11, %g0, 0
	st	%g11, %g15, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41155
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41157
	addi	%g4, %g0, 0
	jmp	jle_cont.41158
jle_else.41157:
	addi	%g4, %g0, 1
jle_cont.41158:
	jmp	jle_cont.41156
jle_else.41155:
	addi	%g4, %g0, 1
jle_cont.41156:
	jne	%g4, %g0, jeq_else.41159
	ld	%g4, %g15, 0
	jne	%g4, %g0, jeq_else.41161
	addi	%g4, %g0, 1
	st	%g4, %g15, 0
	jmp	jeq_cont.41162
jeq_else.41161:
jeq_cont.41162:
	ld	%g4, %g12, 0
	slli	%g18, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g18, %g4
	subi	%g18, %g3, 48
	add	%g4, %g4, %g18
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 68
	call	read_float_token1.2516
	addi	%g1, %g1, 68
	mov	%g10, %g3
	jmp	jeq_cont.41160
jeq_else.41159:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 68
	call	read_float_token1.2516
	addi	%g1, %g1, 68
	mov	%g10, %g3
jeq_cont.41160:
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.41163
	input	%g3
	addi	%g18, %g0, 48
	jlt	%g3, %g18, jle_else.41165
	addi	%g18, %g0, 57
	jlt	%g18, %g3, jle_else.41167
	addi	%g18, %g0, 0
	jmp	jle_cont.41168
jle_else.41167:
	addi	%g18, %g0, 1
jle_cont.41168:
	jmp	jle_cont.41166
jle_else.41165:
	addi	%g18, %g0, 1
jle_cont.41166:
	jne	%g18, %g0, jeq_else.41169
	ld	%g18, %g1, 8
	ld	%g19, %g18, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	subi	%g3, %g3, 48
	add	%g3, %g19, %g3
	st	%g3, %g18, 0
	ld	%g3, %g1, 4
	ld	%g19, %g3, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	st	%g19, %g3, 0
	addi	%g19, %g0, 1
	mov	%g3, %g19
	subi	%g1, %g1, 68
	call	read_float_token2.2519
	addi	%g1, %g1, 68
	jmp	jeq_cont.41170
jeq_else.41169:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 68
	call	read_float_token2.2519
	addi	%g1, %g1, 68
jeq_cont.41170:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 68
	call	min_caml_float_of_int
	addi	%g1, %g1, 68
	fmov	%f10, %f0, 0
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 68
	call	min_caml_float_of_int
	addi	%g1, %g1, 68
	fmov	%f11, %f0, 0
	ld	%g3, %g1, 4
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 68
	call	min_caml_float_of_int
	addi	%g1, %g1, 68
	fdiv	%f0, %f11, %f0
	fadd	%f0, %f10, %f0
	jmp	jeq_cont.41164
jeq_else.41163:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 68
	call	min_caml_float_of_int
	addi	%g1, %g1, 68
jeq_cont.41164:
	ld	%g10, %g15, 0
	jne	%g10, %g28, jeq_else.41171
	jmp	jeq_cont.41172
jeq_else.41171:
	fneg	%f0, %f0
jeq_cont.41172:
	ld	%g10, %g1, 60
	fst	%f0, %g10, -4
	addi	%g11, %g0, 0
	ld	%g12, %g1, 12
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 8
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	ld	%g14, %g1, 4
	st	%g11, %g14, 0
	addi	%g11, %g0, 0
	st	%g11, %g15, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41173
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41175
	addi	%g4, %g0, 0
	jmp	jle_cont.41176
jle_else.41175:
	addi	%g4, %g0, 1
jle_cont.41176:
	jmp	jle_cont.41174
jle_else.41173:
	addi	%g4, %g0, 1
jle_cont.41174:
	jne	%g4, %g0, jeq_else.41177
	ld	%g4, %g15, 0
	jne	%g4, %g0, jeq_else.41179
	addi	%g4, %g0, 1
	st	%g4, %g15, 0
	jmp	jeq_cont.41180
jeq_else.41179:
jeq_cont.41180:
	ld	%g4, %g12, 0
	slli	%g18, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g18, %g4
	subi	%g18, %g3, 48
	add	%g4, %g4, %g18
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 68
	call	read_float_token1.2516
	addi	%g1, %g1, 68
	mov	%g10, %g3
	jmp	jeq_cont.41178
jeq_else.41177:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 68
	call	read_float_token1.2516
	addi	%g1, %g1, 68
	mov	%g10, %g3
jeq_cont.41178:
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.41181
	input	%g3
	addi	%g18, %g0, 48
	jlt	%g3, %g18, jle_else.41183
	addi	%g18, %g0, 57
	jlt	%g18, %g3, jle_else.41185
	addi	%g18, %g0, 0
	jmp	jle_cont.41186
jle_else.41185:
	addi	%g18, %g0, 1
jle_cont.41186:
	jmp	jle_cont.41184
jle_else.41183:
	addi	%g18, %g0, 1
jle_cont.41184:
	jne	%g18, %g0, jeq_else.41187
	ld	%g18, %g1, 8
	ld	%g19, %g18, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	subi	%g3, %g3, 48
	add	%g3, %g19, %g3
	st	%g3, %g18, 0
	ld	%g3, %g1, 4
	ld	%g19, %g3, 0
	slli	%g20, %g19, 3
	slli	%g19, %g19, 1
	add	%g19, %g20, %g19
	st	%g19, %g3, 0
	addi	%g19, %g0, 1
	mov	%g3, %g19
	subi	%g1, %g1, 68
	call	read_float_token2.2519
	addi	%g1, %g1, 68
	jmp	jeq_cont.41188
jeq_else.41187:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 68
	call	read_float_token2.2519
	addi	%g1, %g1, 68
jeq_cont.41188:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 68
	call	min_caml_float_of_int
	addi	%g1, %g1, 68
	fmov	%f10, %f0, 0
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 68
	call	min_caml_float_of_int
	addi	%g1, %g1, 68
	fmov	%f11, %f0, 0
	ld	%g3, %g1, 4
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 68
	call	min_caml_float_of_int
	addi	%g1, %g1, 68
	fdiv	%f0, %f11, %f0
	fadd	%f0, %f10, %f0
	jmp	jeq_cont.41182
jeq_else.41181:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 68
	call	min_caml_float_of_int
	addi	%g1, %g1, 68
jeq_cont.41182:
	ld	%g3, %g15, 0
	jne	%g3, %g28, jeq_else.41189
	jmp	jeq_cont.41190
jeq_else.41189:
	fneg	%f0, %f0
jeq_cont.41190:
	ld	%g3, %g1, 60
	fst	%f0, %g3, -8
	addi	%g10, %g0, 3
	fld	%f0, %g1, 40
	mov	%g3, %g10
	subi	%g1, %g1, 68
	call	min_caml_create_float_array
	addi	%g1, %g1, 68
	mov	%g10, %g3
	ld	%g11, %g1, 36
	st	%g10, %g1, 64
	jne	%g11, %g0, jeq_else.41191
	jmp	jeq_cont.41192
jeq_else.41191:
	addi	%g12, %g0, 0
	ld	%g13, %g1, 12
	st	%g12, %g13, 0
	addi	%g12, %g0, 0
	ld	%g14, %g1, 8
	st	%g12, %g14, 0
	addi	%g12, %g0, 1
	ld	%g18, %g1, 4
	st	%g12, %g18, 0
	addi	%g12, %g0, 0
	st	%g12, %g15, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41193
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41195
	addi	%g4, %g0, 0
	jmp	jle_cont.41196
jle_else.41195:
	addi	%g4, %g0, 1
jle_cont.41196:
	jmp	jle_cont.41194
jle_else.41193:
	addi	%g4, %g0, 1
jle_cont.41194:
	jne	%g4, %g0, jeq_else.41197
	ld	%g4, %g15, 0
	jne	%g4, %g0, jeq_else.41199
	addi	%g4, %g0, 1
	st	%g4, %g15, 0
	jmp	jeq_cont.41200
jeq_else.41199:
jeq_cont.41200:
	ld	%g4, %g13, 0
	slli	%g19, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g19, %g4
	subi	%g19, %g3, 48
	add	%g4, %g4, %g19
	st	%g4, %g13, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 72
	call	read_float_token1.2516
	addi	%g1, %g1, 72
	mov	%g10, %g3
	jmp	jeq_cont.41198
jeq_else.41197:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 72
	call	read_float_token1.2516
	addi	%g1, %g1, 72
	mov	%g10, %g3
jeq_cont.41198:
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.41201
	input	%g3
	addi	%g19, %g0, 48
	jlt	%g3, %g19, jle_else.41203
	addi	%g19, %g0, 57
	jlt	%g19, %g3, jle_else.41205
	addi	%g19, %g0, 0
	jmp	jle_cont.41206
jle_else.41205:
	addi	%g19, %g0, 1
jle_cont.41206:
	jmp	jle_cont.41204
jle_else.41203:
	addi	%g19, %g0, 1
jle_cont.41204:
	jne	%g19, %g0, jeq_else.41207
	ld	%g19, %g1, 8
	ld	%g20, %g19, 0
	slli	%g21, %g20, 3
	slli	%g20, %g20, 1
	add	%g20, %g21, %g20
	subi	%g3, %g3, 48
	add	%g3, %g20, %g3
	st	%g3, %g19, 0
	ld	%g3, %g18, 0
	slli	%g20, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g20, %g3
	st	%g3, %g18, 0
	addi	%g3, %g0, 1
	subi	%g1, %g1, 72
	call	read_float_token2.2519
	addi	%g1, %g1, 72
	jmp	jeq_cont.41208
jeq_else.41207:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 72
	call	read_float_token2.2519
	addi	%g1, %g1, 72
jeq_cont.41208:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 72
	call	min_caml_float_of_int
	addi	%g1, %g1, 72
	fmov	%f10, %f0, 0
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 72
	call	min_caml_float_of_int
	addi	%g1, %g1, 72
	fmov	%f11, %f0, 0
	ld	%g3, %g18, 0
	subi	%g1, %g1, 72
	call	min_caml_float_of_int
	addi	%g1, %g1, 72
	fdiv	%f0, %f11, %f0
	fadd	%f0, %f10, %f0
	jmp	jeq_cont.41202
jeq_else.41201:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 72
	call	min_caml_float_of_int
	addi	%g1, %g1, 72
jeq_cont.41202:
	ld	%g10, %g15, 0
	jne	%g10, %g28, jeq_else.41209
	jmp	jeq_cont.41210
jeq_else.41209:
	fneg	%f0, %f0
jeq_cont.41210:
	setL %g10, l.34372
	fld	%f1, %g10, 0
	fmul	%f0, %f0, %f1
	ld	%g10, %g1, 64
	fst	%f0, %g10, 0
	addi	%g11, %g0, 0
	ld	%g12, %g1, 12
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 8
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	st	%g11, %g18, 0
	addi	%g11, %g0, 0
	st	%g11, %g15, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41211
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41213
	addi	%g4, %g0, 0
	jmp	jle_cont.41214
jle_else.41213:
	addi	%g4, %g0, 1
jle_cont.41214:
	jmp	jle_cont.41212
jle_else.41211:
	addi	%g4, %g0, 1
jle_cont.41212:
	jne	%g4, %g0, jeq_else.41215
	ld	%g4, %g15, 0
	jne	%g4, %g0, jeq_else.41217
	addi	%g4, %g0, 1
	st	%g4, %g15, 0
	jmp	jeq_cont.41218
jeq_else.41217:
jeq_cont.41218:
	ld	%g4, %g12, 0
	slli	%g19, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g19, %g4
	subi	%g19, %g3, 48
	add	%g4, %g4, %g19
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 72
	call	read_float_token1.2516
	addi	%g1, %g1, 72
	mov	%g10, %g3
	jmp	jeq_cont.41216
jeq_else.41215:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 72
	call	read_float_token1.2516
	addi	%g1, %g1, 72
	mov	%g10, %g3
jeq_cont.41216:
	addi	%g11, %g0, 46
	fst	%f1, %g1, 68
	jne	%g10, %g11, jeq_else.41219
	input	%g3
	addi	%g19, %g0, 48
	jlt	%g3, %g19, jle_else.41221
	addi	%g19, %g0, 57
	jlt	%g19, %g3, jle_else.41223
	addi	%g19, %g0, 0
	jmp	jle_cont.41224
jle_else.41223:
	addi	%g19, %g0, 1
jle_cont.41224:
	jmp	jle_cont.41222
jle_else.41221:
	addi	%g19, %g0, 1
jle_cont.41222:
	jne	%g19, %g0, jeq_else.41225
	ld	%g19, %g1, 8
	ld	%g20, %g19, 0
	slli	%g21, %g20, 3
	slli	%g20, %g20, 1
	add	%g20, %g21, %g20
	subi	%g3, %g3, 48
	add	%g3, %g20, %g3
	st	%g3, %g19, 0
	ld	%g3, %g18, 0
	slli	%g20, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g20, %g3
	st	%g3, %g18, 0
	addi	%g3, %g0, 1
	subi	%g1, %g1, 76
	call	read_float_token2.2519
	addi	%g1, %g1, 76
	jmp	jeq_cont.41226
jeq_else.41225:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 76
	call	read_float_token2.2519
	addi	%g1, %g1, 76
jeq_cont.41226:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 76
	call	min_caml_float_of_int
	addi	%g1, %g1, 76
	fmov	%f10, %f0, 0
	ld	%g3, %g1, 8
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 76
	call	min_caml_float_of_int
	addi	%g1, %g1, 76
	fmov	%f11, %f0, 0
	ld	%g3, %g18, 0
	subi	%g1, %g1, 76
	call	min_caml_float_of_int
	addi	%g1, %g1, 76
	fdiv	%f0, %f11, %f0
	fadd	%f0, %f10, %f0
	jmp	jeq_cont.41220
jeq_else.41219:
	ld	%g3, %g1, 12
	ld	%g10, %g3, 0
	mov	%g3, %g10
	subi	%g1, %g1, 76
	call	min_caml_float_of_int
	addi	%g1, %g1, 76
jeq_cont.41220:
	ld	%g10, %g15, 0
	jne	%g10, %g28, jeq_else.41227
	jmp	jeq_cont.41228
jeq_else.41227:
	fneg	%f0, %f0
jeq_cont.41228:
	fld	%f1, %g1, 68
	fmul	%f0, %f0, %f1
	ld	%g10, %g1, 64
	fst	%f0, %g10, -4
	addi	%g11, %g0, 0
	ld	%g12, %g1, 12
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g13, %g1, 8
	st	%g11, %g13, 0
	addi	%g11, %g0, 1
	st	%g11, %g18, 0
	addi	%g11, %g0, 0
	st	%g11, %g15, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41229
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41231
	addi	%g4, %g0, 0
	jmp	jle_cont.41232
jle_else.41231:
	addi	%g4, %g0, 1
jle_cont.41232:
	jmp	jle_cont.41230
jle_else.41229:
	addi	%g4, %g0, 1
jle_cont.41230:
	jne	%g4, %g0, jeq_else.41233
	ld	%g4, %g15, 0
	jne	%g4, %g0, jeq_else.41235
	addi	%g4, %g0, 1
	st	%g4, %g15, 0
	jmp	jeq_cont.41236
jeq_else.41235:
jeq_cont.41236:
	ld	%g4, %g12, 0
	slli	%g19, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g19, %g4
	subi	%g19, %g3, 48
	add	%g4, %g4, %g19
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 76
	call	read_float_token1.2516
	addi	%g1, %g1, 76
	mov	%g10, %g3
	jmp	jeq_cont.41234
jeq_else.41233:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 76
	call	read_float_token1.2516
	addi	%g1, %g1, 76
	mov	%g10, %g3
jeq_cont.41234:
	addi	%g11, %g0, 46
	jne	%g10, %g11, jeq_else.41237
	input	%g3
	addi	%g19, %g0, 48
	jlt	%g3, %g19, jle_else.41239
	addi	%g19, %g0, 57
	jlt	%g19, %g3, jle_else.41241
	addi	%g19, %g0, 0
	jmp	jle_cont.41242
jle_else.41241:
	addi	%g19, %g0, 1
jle_cont.41242:
	jmp	jle_cont.41240
jle_else.41239:
	addi	%g19, %g0, 1
jle_cont.41240:
	jne	%g19, %g0, jeq_else.41243
	ld	%g19, %g1, 8
	ld	%g20, %g19, 0
	slli	%g21, %g20, 3
	slli	%g20, %g20, 1
	add	%g20, %g21, %g20
	subi	%g3, %g3, 48
	add	%g3, %g20, %g3
	st	%g3, %g19, 0
	ld	%g3, %g18, 0
	slli	%g20, %g3, 3
	slli	%g3, %g3, 1
	add	%g3, %g20, %g3
	st	%g3, %g18, 0
	addi	%g3, %g0, 1
	subi	%g1, %g1, 76
	call	read_float_token2.2519
	addi	%g1, %g1, 76
	jmp	jeq_cont.41244
jeq_else.41243:
	addi	%g3, %g0, 0
	subi	%g1, %g1, 76
	call	read_float_token2.2519
	addi	%g1, %g1, 76
jeq_cont.41244:
	ld	%g3, %g1, 12
	ld	%g3, %g3, 0
	subi	%g1, %g1, 76
	call	min_caml_float_of_int
	addi	%g1, %g1, 76
	fmov	%f10, %f0, 0
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	subi	%g1, %g1, 76
	call	min_caml_float_of_int
	addi	%g1, %g1, 76
	fmov	%f11, %f0, 0
	ld	%g3, %g18, 0
	subi	%g1, %g1, 76
	call	min_caml_float_of_int
	addi	%g1, %g1, 76
	fdiv	%f0, %f11, %f0
	fadd	%f0, %f10, %f0
	jmp	jeq_cont.41238
jeq_else.41237:
	ld	%g3, %g1, 12
	ld	%g3, %g3, 0
	subi	%g1, %g1, 76
	call	min_caml_float_of_int
	addi	%g1, %g1, 76
jeq_cont.41238:
	ld	%g3, %g15, 0
	jne	%g3, %g28, jeq_else.41245
	jmp	jeq_cont.41246
jeq_else.41245:
	fneg	%f0, %f0
jeq_cont.41246:
	fld	%f1, %g1, 68
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 64
	fst	%f0, %g3, -8
jeq_cont.41192:
	addi	%g3, %g0, 2
	ld	%g10, %g1, 28
	jne	%g10, %g3, jeq_else.41247
	addi	%g3, %g0, 1
	jmp	jeq_cont.41248
jeq_else.41247:
	fld	%f0, %g1, 52
	fld	%f1, %g1, 40
	fjlt	%f0, %f1, fjge_else.41249
	addi	%g3, %g0, 0
	jmp	fjge_cont.41250
fjge_else.41249:
	addi	%g3, %g0, 1
fjge_cont.41250:
jeq_cont.41248:
	addi	%g11, %g0, 4
	fld	%f0, %g1, 40
	st	%g3, %g1, 72
	mov	%g3, %g11
	subi	%g1, %g1, 80
	call	min_caml_create_float_array
	addi	%g1, %g1, 80
	mov	%g11, %g3
	mov	%g12, %g2
	addi	%g2, %g2, 44
	st	%g11, %g12, -40
	ld	%g11, %g1, 64
	st	%g11, %g12, -36
	ld	%g13, %g1, 60
	st	%g13, %g12, -32
	ld	%g13, %g1, 56
	st	%g13, %g12, -28
	ld	%g13, %g1, 72
	st	%g13, %g12, -24
	ld	%g13, %g1, 48
	st	%g13, %g12, -20
	ld	%g13, %g1, 44
	st	%g13, %g12, -16
	ld	%g14, %g1, 36
	st	%g14, %g12, -12
	ld	%g15, %g1, 32
	st	%g15, %g12, -8
	st	%g10, %g12, -4
	ld	%g15, %g1, 24
	st	%g15, %g12, 0
	ld	%g15, %g1, 0
	slli	%g18, %g15, 2
	add	%g26, %g16, %g18
	st	%g12, %g26, 0
	addi	%g12, %g0, 3
	jne	%g10, %g12, jeq_else.41251
	fld	%f0, %g13, 0
	fld	%f10, %g1, 40
	fjeq	%f0, %f10, fjne_else.41253
	fjeq	%f0, %f10, fjne_else.41255
	fjlt	%f10, %f0, fjge_else.41257
	setL %g10, l.35516
	fld	%f11, %g10, 0
	jmp	fjge_cont.41258
fjge_else.41257:
	setL %g10, l.34374
	fld	%f11, %g10, 0
fjge_cont.41258:
	jmp	fjne_cont.41256
fjne_else.41255:
	fmov	%f11, %f10
fjne_cont.41256:
	fmul	%f0, %f0, %f0
	fdiv	%f0, %f11, %f0
	jmp	fjne_cont.41254
fjne_else.41253:
	fmov	%f0, %f10
fjne_cont.41254:
	fst	%f0, %g13, 0
	fld	%f0, %g13, -4
	fjeq	%f0, %f10, fjne_else.41259
	fjeq	%f0, %f10, fjne_else.41261
	fjlt	%f10, %f0, fjge_else.41263
	setL %g10, l.35516
	fld	%f11, %g10, 0
	jmp	fjge_cont.41264
fjge_else.41263:
	setL %g10, l.34374
	fld	%f11, %g10, 0
fjge_cont.41264:
	jmp	fjne_cont.41262
fjne_else.41261:
	fmov	%f11, %f10
fjne_cont.41262:
	fmul	%f0, %f0, %f0
	fdiv	%f0, %f11, %f0
	jmp	fjne_cont.41260
fjne_else.41259:
	fmov	%f0, %f10
fjne_cont.41260:
	fst	%f0, %g13, -4
	fld	%f0, %g13, -8
	fjeq	%f0, %f10, fjne_else.41265
	fjeq	%f0, %f10, fjne_else.41267
	fjlt	%f10, %f0, fjge_else.41269
	setL %g10, l.35516
	fld	%f11, %g10, 0
	jmp	fjge_cont.41270
fjge_else.41269:
	setL %g10, l.34374
	fld	%f11, %g10, 0
fjge_cont.41270:
	jmp	fjne_cont.41268
fjne_else.41267:
	fmov	%f11, %f10
fjne_cont.41268:
	fmul	%f0, %f0, %f0
	fdiv	%f0, %f11, %f0
	jmp	fjne_cont.41266
fjne_else.41265:
	fmov	%f0, %f10
fjne_cont.41266:
	fst	%f0, %g13, -8
	jmp	jeq_cont.41252
jeq_else.41251:
	addi	%g12, %g0, 2
	jne	%g10, %g12, jeq_else.41271
	fld	%f0, %g13, 0
	fmul	%f1, %f0, %f0
	fld	%f10, %g13, -4
	fmul	%f10, %f10, %f10
	fadd	%f1, %f1, %f10
	fld	%f10, %g13, -8
	fmul	%f10, %f10, %f10
	fadd	%f1, %f1, %f10
	fst	%f0, %g1, 76
	fsqrt	%f0, %f1
	fld	%f10, %g1, 40
	fjeq	%f0, %f10, fjne_else.41273
	fld	%f11, %g1, 52
	fjlt	%f11, %f10, fjge_else.41275
	fmov	%f11, %f18
	fdiv	%f0, %f11, %f0
	jmp	fjge_cont.41276
fjge_else.41275:
	fmov	%f11, %f17
	fdiv	%f0, %f11, %f0
fjge_cont.41276:
	jmp	fjne_cont.41274
fjne_else.41273:
	setL %g10, l.34374
	fld	%f0, %g10, 0
fjne_cont.41274:
	fld	%f11, %g1, 76
	fmul	%f11, %f11, %f0
	fst	%f11, %g13, 0
	fld	%f11, %g13, -4
	fmul	%f11, %f11, %f0
	fst	%f11, %g13, -4
	fld	%f11, %g13, -8
	fmul	%f0, %f11, %f0
	fst	%f0, %g13, -8
	jmp	jeq_cont.41272
jeq_else.41271:
jeq_cont.41272:
jeq_cont.41252:
	jne	%g14, %g0, jeq_else.41277
	jmp	jeq_cont.41278
jeq_else.41277:
	fld	%f0, %g11, 0
	fmov	%f10, %f19
	fmov	%f11, %f20
	fsub	%f12, %f11, %f0
	setL %g10, l.34128
	fld	%f13, %g10, 0
	setL %g10, l.34130
	fld	%f14, %g10, 0
	fmov	%f3, %f30
	fld	%f4, %g1, 40
	fjlt	%f12, %f4, fjge_else.41279
	fmov	%f5, %f12
	jmp	fjge_cont.41280
fjge_else.41279:
	fneg	%f5, %f12
fjge_cont.41280:
	fst	%f0, %g1, 80
	fjlt	%f3, %f5, fjge_else.41281
	fjlt	%f5, %f4, fjge_else.41283
	fmov	%f0, %f5
	jmp	fjge_cont.41284
fjge_else.41283:
	fadd	%f5, %f5, %f3
	fjlt	%f3, %f5, fjge_else.41285
	fjlt	%f5, %f4, fjge_else.41287
	fmov	%f0, %f5
	jmp	fjge_cont.41288
fjge_else.41287:
	fadd	%f5, %f5, %f3
	fjlt	%f3, %f5, fjge_else.41289
	fjlt	%f5, %f4, fjge_else.41291
	fmov	%f0, %f5
	jmp	fjge_cont.41292
fjge_else.41291:
	fadd	%f5, %f5, %f3
	fmov	%f0, %f5
	subi	%g1, %g1, 88
	call	sin_sub.2497
	addi	%g1, %g1, 88
fjge_cont.41292:
	jmp	fjge_cont.41290
fjge_else.41289:
	fsub	%f5, %f5, %f3
	fmov	%f0, %f5
	subi	%g1, %g1, 88
	call	sin_sub.2497
	addi	%g1, %g1, 88
fjge_cont.41290:
fjge_cont.41288:
	jmp	fjge_cont.41286
fjge_else.41285:
	fsub	%f5, %f5, %f3
	fjlt	%f3, %f5, fjge_else.41293
	fjlt	%f5, %f4, fjge_else.41295
	fmov	%f0, %f5
	jmp	fjge_cont.41296
fjge_else.41295:
	fadd	%f5, %f5, %f3
	fmov	%f0, %f5
	subi	%g1, %g1, 88
	call	sin_sub.2497
	addi	%g1, %g1, 88
fjge_cont.41296:
	jmp	fjge_cont.41294
fjge_else.41293:
	fsub	%f5, %f5, %f3
	fmov	%f0, %f5
	subi	%g1, %g1, 88
	call	sin_sub.2497
	addi	%g1, %g1, 88
fjge_cont.41294:
fjge_cont.41286:
fjge_cont.41284:
	jmp	fjge_cont.41282
fjge_else.41281:
	fsub	%f5, %f5, %f3
	fjlt	%f3, %f5, fjge_else.41297
	fjlt	%f5, %f4, fjge_else.41299
	fmov	%f0, %f5
	jmp	fjge_cont.41300
fjge_else.41299:
	fadd	%f5, %f5, %f3
	fjlt	%f3, %f5, fjge_else.41301
	fjlt	%f5, %f4, fjge_else.41303
	fmov	%f0, %f5
	jmp	fjge_cont.41304
fjge_else.41303:
	fadd	%f5, %f5, %f3
	fmov	%f0, %f5
	subi	%g1, %g1, 88
	call	sin_sub.2497
	addi	%g1, %g1, 88
fjge_cont.41304:
	jmp	fjge_cont.41302
fjge_else.41301:
	fsub	%f5, %f5, %f3
	fmov	%f0, %f5
	subi	%g1, %g1, 88
	call	sin_sub.2497
	addi	%g1, %g1, 88
fjge_cont.41302:
fjge_cont.41300:
	jmp	fjge_cont.41298
fjge_else.41297:
	fsub	%f5, %f5, %f3
	fjlt	%f3, %f5, fjge_else.41305
	fjlt	%f5, %f4, fjge_else.41307
	fmov	%f0, %f5
	jmp	fjge_cont.41308
fjge_else.41307:
	fadd	%f5, %f5, %f3
	fmov	%f0, %f5
	subi	%g1, %g1, 88
	call	sin_sub.2497
	addi	%g1, %g1, 88
fjge_cont.41308:
	jmp	fjge_cont.41306
fjge_else.41305:
	fsub	%f5, %f5, %f3
	fmov	%f0, %f5
	subi	%g1, %g1, 88
	call	sin_sub.2497
	addi	%g1, %g1, 88
fjge_cont.41306:
fjge_cont.41298:
fjge_cont.41282:
	fjlt	%f13, %f0, fjge_else.41309
	fjlt	%f4, %f12, fjge_else.41311
	addi	%g10, %g0, 0
	jmp	fjge_cont.41312
fjge_else.41311:
	addi	%g10, %g0, 1
fjge_cont.41312:
	jmp	fjge_cont.41310
fjge_else.41309:
	fjlt	%f4, %f12, fjge_else.41313
	addi	%g10, %g0, 1
	jmp	fjge_cont.41314
fjge_else.41313:
	addi	%g10, %g0, 0
fjge_cont.41314:
fjge_cont.41310:
	fjlt	%f13, %f0, fjge_else.41315
	jmp	fjge_cont.41316
fjge_else.41315:
	fsub	%f0, %f3, %f0
fjge_cont.41316:
	fjlt	%f11, %f0, fjge_else.41317
	jmp	fjge_cont.41318
fjge_else.41317:
	fsub	%f0, %f13, %f0
fjge_cont.41318:
	fmul	%f0, %f0, %f10
	fmov	%f12, %f17
	fmul	%f5, %f0, %f0
	fmov	%f6, %f24
	fmov	%f7, %f23
	fdiv	%f8, %f5, %f7
	fmov	%f9, %f22
	fsub	%f8, %f6, %f8
	fdiv	%f8, %f5, %f8
	fmov	%f1, %f21
	fsub	%f8, %f9, %f8
	fdiv	%f8, %f5, %f8
	fsub	%f8, %f1, %f8
	fdiv	%f5, %f5, %f8
	fsub	%f5, %f12, %f5
	fdiv	%f0, %f0, %f5
	fmul	%f5, %f14, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f12, %f0
	fdiv	%f0, %f5, %f0
	jne	%g10, %g0, jeq_else.41319
	fneg	%f0, %f0
	jmp	jeq_cont.41320
jeq_else.41319:
jeq_cont.41320:
	fld	%f5, %g1, 80
	fjlt	%f5, %f4, fjge_else.41321
	fmov	%f8, %f5
	jmp	fjge_cont.41322
fjge_else.41321:
	fneg	%f8, %f5
fjge_cont.41322:
	fst	%f0, %g1, 84
	fst	%f1, %g1, 88
	fjlt	%f3, %f8, fjge_else.41323
	fjlt	%f8, %f4, fjge_else.41325
	fmov	%f0, %f8
	jmp	fjge_cont.41326
fjge_else.41325:
	fadd	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41327
	fjlt	%f8, %f4, fjge_else.41329
	fmov	%f0, %f8
	jmp	fjge_cont.41330
fjge_else.41329:
	fadd	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41331
	fjlt	%f8, %f4, fjge_else.41333
	fmov	%f0, %f8
	jmp	fjge_cont.41334
fjge_else.41333:
	fadd	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 96
	call	sin_sub.2497
	addi	%g1, %g1, 96
fjge_cont.41334:
	jmp	fjge_cont.41332
fjge_else.41331:
	fsub	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 96
	call	sin_sub.2497
	addi	%g1, %g1, 96
fjge_cont.41332:
fjge_cont.41330:
	jmp	fjge_cont.41328
fjge_else.41327:
	fsub	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41335
	fjlt	%f8, %f4, fjge_else.41337
	fmov	%f0, %f8
	jmp	fjge_cont.41338
fjge_else.41337:
	fadd	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 96
	call	sin_sub.2497
	addi	%g1, %g1, 96
fjge_cont.41338:
	jmp	fjge_cont.41336
fjge_else.41335:
	fsub	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 96
	call	sin_sub.2497
	addi	%g1, %g1, 96
fjge_cont.41336:
fjge_cont.41328:
fjge_cont.41326:
	jmp	fjge_cont.41324
fjge_else.41323:
	fsub	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41339
	fjlt	%f8, %f4, fjge_else.41341
	fmov	%f0, %f8
	jmp	fjge_cont.41342
fjge_else.41341:
	fadd	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41343
	fjlt	%f8, %f4, fjge_else.41345
	fmov	%f0, %f8
	jmp	fjge_cont.41346
fjge_else.41345:
	fadd	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 96
	call	sin_sub.2497
	addi	%g1, %g1, 96
fjge_cont.41346:
	jmp	fjge_cont.41344
fjge_else.41343:
	fsub	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 96
	call	sin_sub.2497
	addi	%g1, %g1, 96
fjge_cont.41344:
fjge_cont.41342:
	jmp	fjge_cont.41340
fjge_else.41339:
	fsub	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41347
	fjlt	%f8, %f4, fjge_else.41349
	fmov	%f0, %f8
	jmp	fjge_cont.41350
fjge_else.41349:
	fadd	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 96
	call	sin_sub.2497
	addi	%g1, %g1, 96
fjge_cont.41350:
	jmp	fjge_cont.41348
fjge_else.41347:
	fsub	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 96
	call	sin_sub.2497
	addi	%g1, %g1, 96
fjge_cont.41348:
fjge_cont.41340:
fjge_cont.41324:
	fjlt	%f13, %f0, fjge_else.41351
	fjlt	%f4, %f5, fjge_else.41353
	addi	%g10, %g0, 0
	jmp	fjge_cont.41354
fjge_else.41353:
	addi	%g10, %g0, 1
fjge_cont.41354:
	jmp	fjge_cont.41352
fjge_else.41351:
	fjlt	%f4, %f5, fjge_else.41355
	addi	%g10, %g0, 1
	jmp	fjge_cont.41356
fjge_else.41355:
	addi	%g10, %g0, 0
fjge_cont.41356:
fjge_cont.41352:
	fjlt	%f13, %f0, fjge_else.41357
	jmp	fjge_cont.41358
fjge_else.41357:
	fsub	%f0, %f3, %f0
fjge_cont.41358:
	fjlt	%f11, %f0, fjge_else.41359
	jmp	fjge_cont.41360
fjge_else.41359:
	fsub	%f0, %f13, %f0
fjge_cont.41360:
	fmul	%f0, %f0, %f10
	fmul	%f5, %f0, %f0
	fdiv	%f8, %f5, %f7
	fsub	%f8, %f6, %f8
	fdiv	%f8, %f5, %f8
	fsub	%f8, %f9, %f8
	fdiv	%f8, %f5, %f8
	fld	%f1, %g1, 88
	fsub	%f8, %f1, %f8
	fdiv	%f5, %f5, %f8
	fsub	%f5, %f12, %f5
	fdiv	%f0, %f0, %f5
	fmul	%f5, %f14, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f12, %f0
	fdiv	%f0, %f5, %f0
	jne	%g10, %g0, jeq_else.41361
	fneg	%f0, %f0
	jmp	jeq_cont.41362
jeq_else.41361:
jeq_cont.41362:
	fld	%f5, %g11, -4
	fsub	%f8, %f11, %f5
	fjlt	%f8, %f4, fjge_else.41363
	fmov	%f2, %f8
	jmp	fjge_cont.41364
fjge_else.41363:
	fneg	%f2, %f8
fjge_cont.41364:
	fst	%f0, %g1, 92
	fjlt	%f3, %f2, fjge_else.41365
	fjlt	%f2, %f4, fjge_else.41367
	fmov	%f0, %f2
	jmp	fjge_cont.41368
fjge_else.41367:
	fadd	%f2, %f2, %f3
	fjlt	%f3, %f2, fjge_else.41369
	fjlt	%f2, %f4, fjge_else.41371
	fmov	%f0, %f2
	jmp	fjge_cont.41372
fjge_else.41371:
	fadd	%f2, %f2, %f3
	fjlt	%f3, %f2, fjge_else.41373
	fjlt	%f2, %f4, fjge_else.41375
	fmov	%f0, %f2
	jmp	fjge_cont.41376
fjge_else.41375:
	fadd	%f2, %f2, %f3
	fmov	%f0, %f2
	subi	%g1, %g1, 100
	call	sin_sub.2497
	addi	%g1, %g1, 100
fjge_cont.41376:
	jmp	fjge_cont.41374
fjge_else.41373:
	fsub	%f2, %f2, %f3
	fmov	%f0, %f2
	subi	%g1, %g1, 100
	call	sin_sub.2497
	addi	%g1, %g1, 100
fjge_cont.41374:
fjge_cont.41372:
	jmp	fjge_cont.41370
fjge_else.41369:
	fsub	%f2, %f2, %f3
	fjlt	%f3, %f2, fjge_else.41377
	fjlt	%f2, %f4, fjge_else.41379
	fmov	%f0, %f2
	jmp	fjge_cont.41380
fjge_else.41379:
	fadd	%f2, %f2, %f3
	fmov	%f0, %f2
	subi	%g1, %g1, 100
	call	sin_sub.2497
	addi	%g1, %g1, 100
fjge_cont.41380:
	jmp	fjge_cont.41378
fjge_else.41377:
	fsub	%f2, %f2, %f3
	fmov	%f0, %f2
	subi	%g1, %g1, 100
	call	sin_sub.2497
	addi	%g1, %g1, 100
fjge_cont.41378:
fjge_cont.41370:
fjge_cont.41368:
	jmp	fjge_cont.41366
fjge_else.41365:
	fsub	%f2, %f2, %f3
	fjlt	%f3, %f2, fjge_else.41381
	fjlt	%f2, %f4, fjge_else.41383
	fmov	%f0, %f2
	jmp	fjge_cont.41384
fjge_else.41383:
	fadd	%f2, %f2, %f3
	fjlt	%f3, %f2, fjge_else.41385
	fjlt	%f2, %f4, fjge_else.41387
	fmov	%f0, %f2
	jmp	fjge_cont.41388
fjge_else.41387:
	fadd	%f2, %f2, %f3
	fmov	%f0, %f2
	subi	%g1, %g1, 100
	call	sin_sub.2497
	addi	%g1, %g1, 100
fjge_cont.41388:
	jmp	fjge_cont.41386
fjge_else.41385:
	fsub	%f2, %f2, %f3
	fmov	%f0, %f2
	subi	%g1, %g1, 100
	call	sin_sub.2497
	addi	%g1, %g1, 100
fjge_cont.41386:
fjge_cont.41384:
	jmp	fjge_cont.41382
fjge_else.41381:
	fsub	%f2, %f2, %f3
	fjlt	%f3, %f2, fjge_else.41389
	fjlt	%f2, %f4, fjge_else.41391
	fmov	%f0, %f2
	jmp	fjge_cont.41392
fjge_else.41391:
	fadd	%f2, %f2, %f3
	fmov	%f0, %f2
	subi	%g1, %g1, 100
	call	sin_sub.2497
	addi	%g1, %g1, 100
fjge_cont.41392:
	jmp	fjge_cont.41390
fjge_else.41389:
	fsub	%f2, %f2, %f3
	fmov	%f0, %f2
	subi	%g1, %g1, 100
	call	sin_sub.2497
	addi	%g1, %g1, 100
fjge_cont.41390:
fjge_cont.41382:
fjge_cont.41366:
	fjlt	%f13, %f0, fjge_else.41393
	fjlt	%f4, %f8, fjge_else.41395
	addi	%g10, %g0, 0
	jmp	fjge_cont.41396
fjge_else.41395:
	addi	%g10, %g0, 1
fjge_cont.41396:
	jmp	fjge_cont.41394
fjge_else.41393:
	fjlt	%f4, %f8, fjge_else.41397
	addi	%g10, %g0, 1
	jmp	fjge_cont.41398
fjge_else.41397:
	addi	%g10, %g0, 0
fjge_cont.41398:
fjge_cont.41394:
	fjlt	%f13, %f0, fjge_else.41399
	jmp	fjge_cont.41400
fjge_else.41399:
	fsub	%f0, %f3, %f0
fjge_cont.41400:
	fjlt	%f11, %f0, fjge_else.41401
	jmp	fjge_cont.41402
fjge_else.41401:
	fsub	%f0, %f13, %f0
fjge_cont.41402:
	fmul	%f0, %f0, %f10
	fmul	%f8, %f0, %f0
	fdiv	%f1, %f8, %f7
	fsub	%f1, %f6, %f1
	fdiv	%f1, %f8, %f1
	fsub	%f1, %f9, %f1
	fdiv	%f1, %f8, %f1
	fld	%f2, %g1, 88
	fsub	%f1, %f2, %f1
	fdiv	%f8, %f8, %f1
	fsub	%f8, %f12, %f8
	fdiv	%f0, %f0, %f8
	fmul	%f8, %f14, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f12, %f0
	fdiv	%f0, %f8, %f0
	jne	%g10, %g0, jeq_else.41403
	fneg	%f0, %f0
	jmp	jeq_cont.41404
jeq_else.41403:
jeq_cont.41404:
	fjlt	%f5, %f4, fjge_else.41405
	fmov	%f8, %f5
	jmp	fjge_cont.41406
fjge_else.41405:
	fneg	%f8, %f5
fjge_cont.41406:
	fst	%f0, %g1, 96
	fjlt	%f3, %f8, fjge_else.41407
	fjlt	%f8, %f4, fjge_else.41409
	fmov	%f0, %f8
	jmp	fjge_cont.41410
fjge_else.41409:
	fadd	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41411
	fjlt	%f8, %f4, fjge_else.41413
	fmov	%f0, %f8
	jmp	fjge_cont.41414
fjge_else.41413:
	fadd	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41415
	fjlt	%f8, %f4, fjge_else.41417
	fmov	%f0, %f8
	jmp	fjge_cont.41418
fjge_else.41417:
	fadd	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 104
	call	sin_sub.2497
	addi	%g1, %g1, 104
fjge_cont.41418:
	jmp	fjge_cont.41416
fjge_else.41415:
	fsub	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 104
	call	sin_sub.2497
	addi	%g1, %g1, 104
fjge_cont.41416:
fjge_cont.41414:
	jmp	fjge_cont.41412
fjge_else.41411:
	fsub	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41419
	fjlt	%f8, %f4, fjge_else.41421
	fmov	%f0, %f8
	jmp	fjge_cont.41422
fjge_else.41421:
	fadd	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 104
	call	sin_sub.2497
	addi	%g1, %g1, 104
fjge_cont.41422:
	jmp	fjge_cont.41420
fjge_else.41419:
	fsub	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 104
	call	sin_sub.2497
	addi	%g1, %g1, 104
fjge_cont.41420:
fjge_cont.41412:
fjge_cont.41410:
	jmp	fjge_cont.41408
fjge_else.41407:
	fsub	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41423
	fjlt	%f8, %f4, fjge_else.41425
	fmov	%f0, %f8
	jmp	fjge_cont.41426
fjge_else.41425:
	fadd	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41427
	fjlt	%f8, %f4, fjge_else.41429
	fmov	%f0, %f8
	jmp	fjge_cont.41430
fjge_else.41429:
	fadd	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 104
	call	sin_sub.2497
	addi	%g1, %g1, 104
fjge_cont.41430:
	jmp	fjge_cont.41428
fjge_else.41427:
	fsub	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 104
	call	sin_sub.2497
	addi	%g1, %g1, 104
fjge_cont.41428:
fjge_cont.41426:
	jmp	fjge_cont.41424
fjge_else.41423:
	fsub	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41431
	fjlt	%f8, %f4, fjge_else.41433
	fmov	%f0, %f8
	jmp	fjge_cont.41434
fjge_else.41433:
	fadd	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 104
	call	sin_sub.2497
	addi	%g1, %g1, 104
fjge_cont.41434:
	jmp	fjge_cont.41432
fjge_else.41431:
	fsub	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 104
	call	sin_sub.2497
	addi	%g1, %g1, 104
fjge_cont.41432:
fjge_cont.41424:
fjge_cont.41408:
	fjlt	%f13, %f0, fjge_else.41435
	fjlt	%f4, %f5, fjge_else.41437
	addi	%g10, %g0, 0
	jmp	fjge_cont.41438
fjge_else.41437:
	addi	%g10, %g0, 1
fjge_cont.41438:
	jmp	fjge_cont.41436
fjge_else.41435:
	fjlt	%f4, %f5, fjge_else.41439
	addi	%g10, %g0, 1
	jmp	fjge_cont.41440
fjge_else.41439:
	addi	%g10, %g0, 0
fjge_cont.41440:
fjge_cont.41436:
	fjlt	%f13, %f0, fjge_else.41441
	jmp	fjge_cont.41442
fjge_else.41441:
	fsub	%f0, %f3, %f0
fjge_cont.41442:
	fjlt	%f11, %f0, fjge_else.41443
	jmp	fjge_cont.41444
fjge_else.41443:
	fsub	%f0, %f13, %f0
fjge_cont.41444:
	fmul	%f0, %f0, %f10
	fmul	%f5, %f0, %f0
	fdiv	%f8, %f5, %f7
	fsub	%f8, %f6, %f8
	fdiv	%f8, %f5, %f8
	fsub	%f8, %f9, %f8
	fdiv	%f8, %f5, %f8
	fld	%f1, %g1, 88
	fsub	%f8, %f1, %f8
	fdiv	%f5, %f5, %f8
	fsub	%f5, %f12, %f5
	fdiv	%f0, %f0, %f5
	fmul	%f5, %f14, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f12, %f0
	fdiv	%f0, %f5, %f0
	jne	%g10, %g0, jeq_else.41445
	fneg	%f0, %f0
	jmp	jeq_cont.41446
jeq_else.41445:
jeq_cont.41446:
	fld	%f5, %g11, -8
	fsub	%f8, %f11, %f5
	fjlt	%f8, %f4, fjge_else.41447
	fmov	%f2, %f8
	jmp	fjge_cont.41448
fjge_else.41447:
	fneg	%f2, %f8
fjge_cont.41448:
	fst	%f0, %g1, 100
	fjlt	%f3, %f2, fjge_else.41449
	fjlt	%f2, %f4, fjge_else.41451
	fmov	%f0, %f2
	jmp	fjge_cont.41452
fjge_else.41451:
	fadd	%f2, %f2, %f3
	fjlt	%f3, %f2, fjge_else.41453
	fjlt	%f2, %f4, fjge_else.41455
	fmov	%f0, %f2
	jmp	fjge_cont.41456
fjge_else.41455:
	fadd	%f2, %f2, %f3
	fjlt	%f3, %f2, fjge_else.41457
	fjlt	%f2, %f4, fjge_else.41459
	fmov	%f0, %f2
	jmp	fjge_cont.41460
fjge_else.41459:
	fadd	%f2, %f2, %f3
	fmov	%f0, %f2
	subi	%g1, %g1, 108
	call	sin_sub.2497
	addi	%g1, %g1, 108
fjge_cont.41460:
	jmp	fjge_cont.41458
fjge_else.41457:
	fsub	%f2, %f2, %f3
	fmov	%f0, %f2
	subi	%g1, %g1, 108
	call	sin_sub.2497
	addi	%g1, %g1, 108
fjge_cont.41458:
fjge_cont.41456:
	jmp	fjge_cont.41454
fjge_else.41453:
	fsub	%f2, %f2, %f3
	fjlt	%f3, %f2, fjge_else.41461
	fjlt	%f2, %f4, fjge_else.41463
	fmov	%f0, %f2
	jmp	fjge_cont.41464
fjge_else.41463:
	fadd	%f2, %f2, %f3
	fmov	%f0, %f2
	subi	%g1, %g1, 108
	call	sin_sub.2497
	addi	%g1, %g1, 108
fjge_cont.41464:
	jmp	fjge_cont.41462
fjge_else.41461:
	fsub	%f2, %f2, %f3
	fmov	%f0, %f2
	subi	%g1, %g1, 108
	call	sin_sub.2497
	addi	%g1, %g1, 108
fjge_cont.41462:
fjge_cont.41454:
fjge_cont.41452:
	jmp	fjge_cont.41450
fjge_else.41449:
	fsub	%f2, %f2, %f3
	fjlt	%f3, %f2, fjge_else.41465
	fjlt	%f2, %f4, fjge_else.41467
	fmov	%f0, %f2
	jmp	fjge_cont.41468
fjge_else.41467:
	fadd	%f2, %f2, %f3
	fjlt	%f3, %f2, fjge_else.41469
	fjlt	%f2, %f4, fjge_else.41471
	fmov	%f0, %f2
	jmp	fjge_cont.41472
fjge_else.41471:
	fadd	%f2, %f2, %f3
	fmov	%f0, %f2
	subi	%g1, %g1, 108
	call	sin_sub.2497
	addi	%g1, %g1, 108
fjge_cont.41472:
	jmp	fjge_cont.41470
fjge_else.41469:
	fsub	%f2, %f2, %f3
	fmov	%f0, %f2
	subi	%g1, %g1, 108
	call	sin_sub.2497
	addi	%g1, %g1, 108
fjge_cont.41470:
fjge_cont.41468:
	jmp	fjge_cont.41466
fjge_else.41465:
	fsub	%f2, %f2, %f3
	fjlt	%f3, %f2, fjge_else.41473
	fjlt	%f2, %f4, fjge_else.41475
	fmov	%f0, %f2
	jmp	fjge_cont.41476
fjge_else.41475:
	fadd	%f2, %f2, %f3
	fmov	%f0, %f2
	subi	%g1, %g1, 108
	call	sin_sub.2497
	addi	%g1, %g1, 108
fjge_cont.41476:
	jmp	fjge_cont.41474
fjge_else.41473:
	fsub	%f2, %f2, %f3
	fmov	%f0, %f2
	subi	%g1, %g1, 108
	call	sin_sub.2497
	addi	%g1, %g1, 108
fjge_cont.41474:
fjge_cont.41466:
fjge_cont.41450:
	fjlt	%f13, %f0, fjge_else.41477
	fjlt	%f4, %f8, fjge_else.41479
	addi	%g10, %g0, 0
	jmp	fjge_cont.41480
fjge_else.41479:
	addi	%g10, %g0, 1
fjge_cont.41480:
	jmp	fjge_cont.41478
fjge_else.41477:
	fjlt	%f4, %f8, fjge_else.41481
	addi	%g10, %g0, 1
	jmp	fjge_cont.41482
fjge_else.41481:
	addi	%g10, %g0, 0
fjge_cont.41482:
fjge_cont.41478:
	fjlt	%f13, %f0, fjge_else.41483
	jmp	fjge_cont.41484
fjge_else.41483:
	fsub	%f0, %f3, %f0
fjge_cont.41484:
	fjlt	%f11, %f0, fjge_else.41485
	jmp	fjge_cont.41486
fjge_else.41485:
	fsub	%f0, %f13, %f0
fjge_cont.41486:
	fmul	%f0, %f0, %f10
	fmul	%f8, %f0, %f0
	fdiv	%f1, %f8, %f7
	fsub	%f1, %f6, %f1
	fdiv	%f1, %f8, %f1
	fsub	%f1, %f9, %f1
	fdiv	%f1, %f8, %f1
	fld	%f2, %g1, 88
	fsub	%f1, %f2, %f1
	fdiv	%f8, %f8, %f1
	fsub	%f8, %f12, %f8
	fdiv	%f0, %f0, %f8
	fmul	%f8, %f14, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f12, %f0
	fdiv	%f0, %f8, %f0
	jne	%g10, %g0, jeq_else.41487
	fneg	%f0, %f0
	jmp	jeq_cont.41488
jeq_else.41487:
jeq_cont.41488:
	fjlt	%f5, %f4, fjge_else.41489
	fmov	%f8, %f5
	jmp	fjge_cont.41490
fjge_else.41489:
	fneg	%f8, %f5
fjge_cont.41490:
	fst	%f0, %g1, 104
	fjlt	%f3, %f8, fjge_else.41491
	fjlt	%f8, %f4, fjge_else.41493
	fmov	%f0, %f8
	jmp	fjge_cont.41494
fjge_else.41493:
	fadd	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41495
	fjlt	%f8, %f4, fjge_else.41497
	fmov	%f0, %f8
	jmp	fjge_cont.41498
fjge_else.41497:
	fadd	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41499
	fjlt	%f8, %f4, fjge_else.41501
	fmov	%f0, %f8
	jmp	fjge_cont.41502
fjge_else.41501:
	fadd	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 112
	call	sin_sub.2497
	addi	%g1, %g1, 112
fjge_cont.41502:
	jmp	fjge_cont.41500
fjge_else.41499:
	fsub	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 112
	call	sin_sub.2497
	addi	%g1, %g1, 112
fjge_cont.41500:
fjge_cont.41498:
	jmp	fjge_cont.41496
fjge_else.41495:
	fsub	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41503
	fjlt	%f8, %f4, fjge_else.41505
	fmov	%f0, %f8
	jmp	fjge_cont.41506
fjge_else.41505:
	fadd	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 112
	call	sin_sub.2497
	addi	%g1, %g1, 112
fjge_cont.41506:
	jmp	fjge_cont.41504
fjge_else.41503:
	fsub	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 112
	call	sin_sub.2497
	addi	%g1, %g1, 112
fjge_cont.41504:
fjge_cont.41496:
fjge_cont.41494:
	jmp	fjge_cont.41492
fjge_else.41491:
	fsub	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41507
	fjlt	%f8, %f4, fjge_else.41509
	fmov	%f0, %f8
	jmp	fjge_cont.41510
fjge_else.41509:
	fadd	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41511
	fjlt	%f8, %f4, fjge_else.41513
	fmov	%f0, %f8
	jmp	fjge_cont.41514
fjge_else.41513:
	fadd	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 112
	call	sin_sub.2497
	addi	%g1, %g1, 112
fjge_cont.41514:
	jmp	fjge_cont.41512
fjge_else.41511:
	fsub	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 112
	call	sin_sub.2497
	addi	%g1, %g1, 112
fjge_cont.41512:
fjge_cont.41510:
	jmp	fjge_cont.41508
fjge_else.41507:
	fsub	%f8, %f8, %f3
	fjlt	%f3, %f8, fjge_else.41515
	fjlt	%f8, %f4, fjge_else.41517
	fmov	%f0, %f8
	jmp	fjge_cont.41518
fjge_else.41517:
	fadd	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 112
	call	sin_sub.2497
	addi	%g1, %g1, 112
fjge_cont.41518:
	jmp	fjge_cont.41516
fjge_else.41515:
	fsub	%f8, %f8, %f3
	fmov	%f0, %f8
	subi	%g1, %g1, 112
	call	sin_sub.2497
	addi	%g1, %g1, 112
fjge_cont.41516:
fjge_cont.41508:
fjge_cont.41492:
	fjlt	%f13, %f0, fjge_else.41519
	fjlt	%f4, %f5, fjge_else.41521
	addi	%g3, %g0, 0
	jmp	fjge_cont.41522
fjge_else.41521:
	addi	%g3, %g0, 1
fjge_cont.41522:
	jmp	fjge_cont.41520
fjge_else.41519:
	fjlt	%f4, %f5, fjge_else.41523
	addi	%g3, %g0, 1
	jmp	fjge_cont.41524
fjge_else.41523:
	addi	%g3, %g0, 0
fjge_cont.41524:
fjge_cont.41520:
	fjlt	%f13, %f0, fjge_else.41525
	jmp	fjge_cont.41526
fjge_else.41525:
	fsub	%f0, %f3, %f0
fjge_cont.41526:
	fjlt	%f11, %f0, fjge_else.41527
	jmp	fjge_cont.41528
fjge_else.41527:
	fsub	%f0, %f13, %f0
fjge_cont.41528:
	fmul	%f0, %f0, %f10
	fmul	%f1, %f0, %f0
	fdiv	%f2, %f1, %f7
	fsub	%f2, %f6, %f2
	fdiv	%f2, %f1, %f2
	fsub	%f2, %f9, %f2
	fdiv	%f2, %f1, %f2
	fld	%f3, %g1, 88
	fsub	%f2, %f3, %f2
	fdiv	%f1, %f1, %f2
	fsub	%f1, %f12, %f1
	fdiv	%f0, %f0, %f1
	fmul	%f1, %f14, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f12, %f0
	fdiv	%f0, %f1, %f0
	jne	%g3, %g0, jeq_else.41529
	fneg	%f0, %f0
	jmp	jeq_cont.41530
jeq_else.41529:
jeq_cont.41530:
	fld	%f1, %g1, 104
	fld	%f2, %g1, 96
	fmul	%f3, %f2, %f1
	fld	%f4, %g1, 100
	fld	%f5, %g1, 92
	fmul	%f6, %f5, %f4
	fmul	%f7, %f6, %f1
	fld	%f8, %g1, 84
	fmul	%f9, %f8, %f0
	fsub	%f7, %f7, %f9
	fmul	%f9, %f8, %f4
	fmul	%f10, %f9, %f1
	fmul	%f11, %f5, %f0
	fadd	%f10, %f10, %f11
	fmul	%f11, %f2, %f0
	fmul	%f6, %f6, %f0
	fmul	%f12, %f8, %f1
	fadd	%f6, %f6, %f12
	fmul	%f0, %f9, %f0
	fmul	%f1, %f5, %f1
	fsub	%f0, %f0, %f1
	fneg	%f1, %f4
	fmul	%f4, %f5, %f2
	fmul	%f2, %f8, %f2
	fld	%f5, %g13, 0
	fld	%f8, %g13, -4
	fld	%f9, %g13, -8
	fmul	%f12, %f3, %f3
	fmul	%f12, %f5, %f12
	fmul	%f13, %f11, %f11
	fmul	%f13, %f8, %f13
	fadd	%f12, %f12, %f13
	fmul	%f13, %f1, %f1
	fmul	%f13, %f9, %f13
	fadd	%f12, %f12, %f13
	fst	%f12, %g13, 0
	fmul	%f12, %f7, %f7
	fmul	%f12, %f5, %f12
	fmul	%f13, %f6, %f6
	fmul	%f13, %f8, %f13
	fadd	%f12, %f12, %f13
	fmul	%f13, %f4, %f4
	fmul	%f13, %f9, %f13
	fadd	%f12, %f12, %f13
	fst	%f12, %g13, -4
	fmul	%f12, %f10, %f10
	fmul	%f12, %f5, %f12
	fmul	%f13, %f0, %f0
	fmul	%f13, %f8, %f13
	fadd	%f12, %f12, %f13
	fmul	%f13, %f2, %f2
	fmul	%f13, %f9, %f13
	fadd	%f12, %f12, %f13
	fst	%f12, %g13, -8
	fmul	%f12, %f5, %f7
	fmul	%f12, %f12, %f10
	fmul	%f13, %f8, %f6
	fmul	%f13, %f13, %f0
	fadd	%f12, %f12, %f13
	fmul	%f13, %f9, %f4
	fmul	%f13, %f13, %f2
	fadd	%f12, %f12, %f13
	fmul	%f12, %f14, %f12
	fst	%f12, %g11, 0
	fmul	%f3, %f5, %f3
	fmul	%f5, %f3, %f10
	fmul	%f8, %f8, %f11
	fmul	%f0, %f8, %f0
	fadd	%f0, %f5, %f0
	fmul	%f1, %f9, %f1
	fmul	%f2, %f1, %f2
	fadd	%f0, %f0, %f2
	fmul	%f0, %f14, %f0
	fst	%f0, %g11, -4
	fmul	%f0, %f3, %f7
	fmul	%f2, %f8, %f6
	fadd	%f0, %f0, %f2
	fmul	%f1, %f1, %f4
	fadd	%f0, %f0, %f1
	fmul	%f0, %f14, %f0
	fst	%f0, %g11, -8
jeq_cont.41278:
	addi	%g3, %g0, 1
jeq_cont.40950:
	jne	%g3, %g0, jeq_else.41531
	ld	%g3, %g1, 0
	st	%g3, %g17, 0
	return
jeq_else.41531:
	ld	%g3, %g1, 0
	addi	%g3, %g3, 1
	jmp	read_object.2696
read_net_item.2700:
	ld	%g10, %g31, 852
	ld	%g11, %g31, 848
	addi	%g12, %g0, 0
	st	%g12, %g10, 0
	addi	%g12, %g0, 0
	st	%g12, %g11, 0
	st	%g3, %g1, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41533
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41535
	addi	%g4, %g0, 0
	jmp	jle_cont.41536
jle_else.41535:
	addi	%g4, %g0, 1
jle_cont.41536:
	jmp	jle_cont.41534
jle_else.41533:
	addi	%g4, %g0, 1
jle_cont.41534:
	st	%g11, %g1, 4
	st	%g10, %g1, 8
	jne	%g4, %g0, jeq_else.41537
	ld	%g4, %g11, 0
	jne	%g4, %g0, jeq_else.41539
	addi	%g4, %g0, 1
	st	%g4, %g11, 0
	jmp	jeq_cont.41540
jeq_else.41539:
jeq_cont.41540:
	ld	%g4, %g10, 0
	slli	%g15, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g15, %g4
	subi	%g15, %g3, 48
	add	%g4, %g4, %g15
	st	%g4, %g10, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	read_int_token.2507
	addi	%g1, %g1, 16
	jmp	jeq_cont.41538
jeq_else.41537:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	read_int_token.2507
	addi	%g1, %g1, 16
jeq_cont.41538:
	jne	%g3, %g29, jeq_else.41541
	ld	%g3, %g1, 0
	addi	%g3, %g3, 1
	addi	%g4, %g0, -1
	jmp	min_caml_create_array
jeq_else.41541:
	ld	%g10, %g1, 0
	addi	%g11, %g10, 1
	addi	%g12, %g0, 0
	ld	%g13, %g1, 8
	st	%g12, %g13, 0
	addi	%g12, %g0, 0
	ld	%g14, %g1, 4
	st	%g12, %g14, 0
	st	%g3, %g1, 12
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41542
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41544
	addi	%g4, %g0, 0
	jmp	jle_cont.41545
jle_else.41544:
	addi	%g4, %g0, 1
jle_cont.41545:
	jmp	jle_cont.41543
jle_else.41542:
	addi	%g4, %g0, 1
jle_cont.41543:
	st	%g11, %g1, 16
	jne	%g4, %g0, jeq_else.41546
	ld	%g4, %g14, 0
	jne	%g4, %g0, jeq_else.41548
	addi	%g4, %g0, 1
	st	%g4, %g14, 0
	jmp	jeq_cont.41549
jeq_else.41548:
jeq_cont.41549:
	ld	%g4, %g13, 0
	slli	%g15, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g15, %g4
	subi	%g15, %g3, 48
	add	%g4, %g4, %g15
	st	%g4, %g13, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 24
	call	read_int_token.2507
	addi	%g1, %g1, 24
	jmp	jeq_cont.41547
jeq_else.41546:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 24
	call	read_int_token.2507
	addi	%g1, %g1, 24
jeq_cont.41547:
	jne	%g3, %g29, jeq_else.41550
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	addi	%g4, %g0, -1
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	jmp	jeq_cont.41551
jeq_else.41550:
	ld	%g4, %g1, 16
	addi	%g5, %g4, 1
	st	%g3, %g1, 20
	mov	%g3, %g5
	subi	%g1, %g1, 28
	call	read_net_item.2700
	addi	%g1, %g1, 28
	ld	%g4, %g1, 16
	slli	%g4, %g4, 2
	ld	%g5, %g1, 20
	add	%g26, %g3, %g4
	st	%g5, %g26, 0
jeq_cont.41551:
	ld	%g4, %g1, 0
	slli	%g4, %g4, 2
	ld	%g5, %g1, 12
	add	%g26, %g3, %g4
	st	%g5, %g26, 0
	return
read_or_network.2702:
	ld	%g10, %g31, 852
	ld	%g11, %g31, 848
	addi	%g12, %g0, 0
	st	%g12, %g10, 0
	addi	%g12, %g0, 0
	st	%g12, %g11, 0
	st	%g3, %g1, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41552
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41554
	addi	%g4, %g0, 0
	jmp	jle_cont.41555
jle_else.41554:
	addi	%g4, %g0, 1
jle_cont.41555:
	jmp	jle_cont.41553
jle_else.41552:
	addi	%g4, %g0, 1
jle_cont.41553:
	st	%g11, %g1, 4
	st	%g10, %g1, 8
	jne	%g4, %g0, jeq_else.41556
	ld	%g4, %g11, 0
	jne	%g4, %g0, jeq_else.41558
	addi	%g4, %g0, 1
	st	%g4, %g11, 0
	jmp	jeq_cont.41559
jeq_else.41558:
jeq_cont.41559:
	ld	%g4, %g10, 0
	slli	%g15, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g15, %g4
	subi	%g15, %g3, 48
	add	%g4, %g4, %g15
	st	%g4, %g10, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	read_int_token.2507
	addi	%g1, %g1, 16
	jmp	jeq_cont.41557
jeq_else.41556:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	read_int_token.2507
	addi	%g1, %g1, 16
jeq_cont.41557:
	jne	%g3, %g29, jeq_else.41560
	addi	%g3, %g0, 1
	addi	%g4, %g0, -1
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	jmp	jeq_cont.41561
jeq_else.41560:
	addi	%g16, %g0, 1
	st	%g3, %g1, 12
	mov	%g3, %g16
	subi	%g1, %g1, 20
	call	read_net_item.2700
	addi	%g1, %g1, 20
	ld	%g4, %g1, 12
	st	%g4, %g3, 0
jeq_cont.41561:
	ld	%g4, %g3, 0
	jne	%g4, %g29, jeq_else.41562
	ld	%g4, %g1, 0
	addi	%g4, %g4, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	jmp	min_caml_create_array
jeq_else.41562:
	ld	%g10, %g1, 0
	addi	%g11, %g10, 1
	addi	%g12, %g0, 0
	ld	%g13, %g1, 8
	st	%g12, %g13, 0
	addi	%g12, %g0, 0
	ld	%g14, %g1, 4
	st	%g12, %g14, 0
	st	%g3, %g1, 16
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41563
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41565
	addi	%g4, %g0, 0
	jmp	jle_cont.41566
jle_else.41565:
	addi	%g4, %g0, 1
jle_cont.41566:
	jmp	jle_cont.41564
jle_else.41563:
	addi	%g4, %g0, 1
jle_cont.41564:
	st	%g11, %g1, 20
	jne	%g4, %g0, jeq_else.41567
	ld	%g4, %g14, 0
	jne	%g4, %g0, jeq_else.41569
	addi	%g4, %g0, 1
	st	%g4, %g14, 0
	jmp	jeq_cont.41570
jeq_else.41569:
jeq_cont.41570:
	ld	%g4, %g13, 0
	slli	%g15, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g15, %g4
	subi	%g15, %g3, 48
	add	%g4, %g4, %g15
	st	%g4, %g13, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 28
	call	read_int_token.2507
	addi	%g1, %g1, 28
	jmp	jeq_cont.41568
jeq_else.41567:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 28
	call	read_int_token.2507
	addi	%g1, %g1, 28
jeq_cont.41568:
	jne	%g3, %g29, jeq_else.41571
	addi	%g3, %g0, 1
	addi	%g4, %g0, -1
	subi	%g1, %g1, 28
	call	min_caml_create_array
	addi	%g1, %g1, 28
	jmp	jeq_cont.41572
jeq_else.41571:
	addi	%g16, %g0, 1
	st	%g3, %g1, 24
	mov	%g3, %g16
	subi	%g1, %g1, 32
	call	read_net_item.2700
	addi	%g1, %g1, 32
	ld	%g4, %g1, 24
	st	%g4, %g3, 0
jeq_cont.41572:
	ld	%g4, %g3, 0
	jne	%g4, %g29, jeq_else.41573
	ld	%g4, %g1, 20
	addi	%g4, %g4, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 32
	call	min_caml_create_array
	addi	%g1, %g1, 32
	jmp	jeq_cont.41574
jeq_else.41573:
	ld	%g4, %g1, 20
	addi	%g5, %g4, 1
	st	%g3, %g1, 28
	mov	%g3, %g5
	subi	%g1, %g1, 36
	call	read_or_network.2702
	addi	%g1, %g1, 36
	ld	%g4, %g1, 20
	slli	%g4, %g4, 2
	ld	%g5, %g1, 28
	add	%g26, %g3, %g4
	st	%g5, %g26, 0
jeq_cont.41574:
	ld	%g4, %g1, 0
	slli	%g4, %g4, 2
	ld	%g5, %g1, 16
	add	%g26, %g3, %g4
	st	%g5, %g26, 0
	return
read_and_network.2704:
	ld	%g10, %g31, 852
	ld	%g11, %g31, 848
	ld	%g12, %g31, 800
	addi	%g13, %g0, 0
	st	%g13, %g10, 0
	addi	%g13, %g0, 0
	st	%g13, %g11, 0
	st	%g3, %g1, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41575
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41577
	addi	%g4, %g0, 0
	jmp	jle_cont.41578
jle_else.41577:
	addi	%g4, %g0, 1
jle_cont.41578:
	jmp	jle_cont.41576
jle_else.41575:
	addi	%g4, %g0, 1
jle_cont.41576:
	st	%g11, %g1, 4
	st	%g10, %g1, 8
	st	%g12, %g1, 12
	jne	%g4, %g0, jeq_else.41579
	ld	%g4, %g11, 0
	jne	%g4, %g0, jeq_else.41581
	addi	%g4, %g0, 1
	st	%g4, %g11, 0
	jmp	jeq_cont.41582
jeq_else.41581:
jeq_cont.41582:
	ld	%g4, %g10, 0
	slli	%g15, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g15, %g4
	subi	%g15, %g3, 48
	add	%g4, %g4, %g15
	st	%g4, %g10, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 20
	call	read_int_token.2507
	addi	%g1, %g1, 20
	jmp	jeq_cont.41580
jeq_else.41579:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 20
	call	read_int_token.2507
	addi	%g1, %g1, 20
jeq_cont.41580:
	jne	%g3, %g29, jeq_else.41583
	addi	%g3, %g0, 1
	addi	%g4, %g0, -1
	subi	%g1, %g1, 20
	call	min_caml_create_array
	addi	%g1, %g1, 20
	mov	%g10, %g3
	jmp	jeq_cont.41584
jeq_else.41583:
	addi	%g16, %g0, 1
	st	%g3, %g1, 16
	mov	%g3, %g16
	subi	%g1, %g1, 24
	call	read_net_item.2700
	addi	%g1, %g1, 24
	mov	%g10, %g3
	ld	%g11, %g1, 16
	st	%g11, %g10, 0
jeq_cont.41584:
	ld	%g11, %g10, 0
	jne	%g11, %g29, jeq_else.41585
	return
jeq_else.41585:
	ld	%g11, %g1, 0
	slli	%g12, %g11, 2
	ld	%g13, %g1, 12
	add	%g26, %g13, %g12
	st	%g10, %g26, 0
	addi	%g10, %g11, 1
	addi	%g11, %g0, 0
	ld	%g12, %g1, 8
	st	%g11, %g12, 0
	addi	%g11, %g0, 0
	ld	%g14, %g1, 4
	st	%g11, %g14, 0
	input	%g3
	addi	%g4, %g0, 48
	jlt	%g3, %g4, jle_else.41587
	addi	%g4, %g0, 57
	jlt	%g4, %g3, jle_else.41589
	addi	%g4, %g0, 0
	jmp	jle_cont.41590
jle_else.41589:
	addi	%g4, %g0, 1
jle_cont.41590:
	jmp	jle_cont.41588
jle_else.41587:
	addi	%g4, %g0, 1
jle_cont.41588:
	st	%g10, %g1, 20
	jne	%g4, %g0, jeq_else.41591
	ld	%g4, %g14, 0
	jne	%g4, %g0, jeq_else.41593
	addi	%g4, %g0, 1
	st	%g4, %g14, 0
	jmp	jeq_cont.41594
jeq_else.41593:
jeq_cont.41594:
	ld	%g4, %g12, 0
	slli	%g15, %g4, 3
	slli	%g4, %g4, 1
	add	%g4, %g15, %g4
	subi	%g15, %g3, 48
	add	%g4, %g4, %g15
	st	%g4, %g12, 0
	addi	%g4, %g0, 1
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 28
	call	read_int_token.2507
	addi	%g1, %g1, 28
	jmp	jeq_cont.41592
jeq_else.41591:
	addi	%g4, %g0, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 28
	call	read_int_token.2507
	addi	%g1, %g1, 28
jeq_cont.41592:
	jne	%g3, %g29, jeq_else.41595
	addi	%g3, %g0, 1
	addi	%g4, %g0, -1
	subi	%g1, %g1, 28
	call	min_caml_create_array
	addi	%g1, %g1, 28
	jmp	jeq_cont.41596
jeq_else.41595:
	addi	%g16, %g0, 1
	st	%g3, %g1, 24
	mov	%g3, %g16
	subi	%g1, %g1, 32
	call	read_net_item.2700
	addi	%g1, %g1, 32
	ld	%g4, %g1, 24
	st	%g4, %g3, 0
jeq_cont.41596:
	ld	%g4, %g3, 0
	jne	%g4, %g29, jeq_else.41597
	return
jeq_else.41597:
	ld	%g4, %g1, 20
	slli	%g5, %g4, 2
	ld	%g6, %g1, 12
	add	%g26, %g6, %g5
	st	%g3, %g26, 0
	addi	%g3, %g4, 1
	jmp	read_and_network.2704
iter_setup_dirvec_constants.2801:
	ld	%g10, %g31, 820
	jlt	%g4, %g0, jge_else.41599
	slli	%g11, %g4, 2
	add	%g26, %g10, %g11
	ld	%g10, %g26, 0
	ld	%g11, %g3, -4
	ld	%g12, %g3, 0
	ld	%g13, %g10, -4
	st	%g3, %g1, 0
	jne	%g13, %g28, jeq_else.41600
	addi	%g13, %g0, 6
	fmov	%f0, %f16
	st	%g4, %g1, 4
	fst	%f0, %g1, 8
	mov	%g3, %g13
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	fld	%f0, %g12, 0
	fld	%f1, %g1, 8
	fjeq	%f0, %f1, fjne_else.41602
	ld	%g4, %g10, -24
	fjlt	%f0, %f1, fjge_else.41604
	addi	%g5, %g0, 0
	jmp	fjge_cont.41605
fjge_else.41604:
	addi	%g5, %g0, 1
fjge_cont.41605:
	ld	%g6, %g10, -16
	fld	%f0, %g6, 0
	jne	%g4, %g5, jeq_else.41606
	fneg	%f0, %f0
	jmp	jeq_cont.41607
jeq_else.41606:
jeq_cont.41607:
	fst	%f0, %g3, 0
	fmov	%f0, %f17
	fld	%f2, %g12, 0
	fdiv	%f0, %f0, %f2
	fst	%f0, %g3, -4
	jmp	fjne_cont.41603
fjne_else.41602:
	fst	%f1, %g3, -4
fjne_cont.41603:
	fld	%f0, %g12, -4
	fjeq	%f0, %f1, fjne_else.41608
	ld	%g4, %g10, -24
	fjlt	%f0, %f1, fjge_else.41610
	addi	%g5, %g0, 0
	jmp	fjge_cont.41611
fjge_else.41610:
	addi	%g5, %g0, 1
fjge_cont.41611:
	ld	%g6, %g10, -16
	fld	%f0, %g6, -4
	jne	%g4, %g5, jeq_else.41612
	fneg	%f0, %f0
	jmp	jeq_cont.41613
jeq_else.41612:
jeq_cont.41613:
	fst	%f0, %g3, -8
	fmov	%f0, %f17
	fld	%f2, %g12, -4
	fdiv	%f0, %f0, %f2
	fst	%f0, %g3, -12
	jmp	fjne_cont.41609
fjne_else.41608:
	fst	%f1, %g3, -12
fjne_cont.41609:
	fld	%f0, %g12, -8
	fjeq	%f0, %f1, fjne_else.41614
	ld	%g4, %g10, -24
	fjlt	%f0, %f1, fjge_else.41616
	addi	%g5, %g0, 0
	jmp	fjge_cont.41617
fjge_else.41616:
	addi	%g5, %g0, 1
fjge_cont.41617:
	ld	%g6, %g10, -16
	fld	%f0, %g6, -8
	jne	%g4, %g5, jeq_else.41618
	fneg	%f0, %f0
	jmp	jeq_cont.41619
jeq_else.41618:
jeq_cont.41619:
	fst	%f0, %g3, -16
	fmov	%f0, %f17
	fld	%f1, %g12, -8
	fdiv	%f0, %f0, %f1
	fst	%f0, %g3, -20
	jmp	fjne_cont.41615
fjne_else.41614:
	fst	%f1, %g3, -20
fjne_cont.41615:
	ld	%g4, %g1, 4
	slli	%g5, %g4, 2
	add	%g26, %g11, %g5
	st	%g3, %g26, 0
	jmp	jeq_cont.41601
jeq_else.41600:
	addi	%g14, %g0, 2
	jne	%g13, %g14, jeq_else.41620
	addi	%g13, %g0, 4
	fmov	%f0, %f16
	st	%g4, %g1, 4
	fst	%f0, %g1, 12
	mov	%g3, %g13
	subi	%g1, %g1, 20
	call	min_caml_create_float_array
	addi	%g1, %g1, 20
	fld	%f0, %g12, 0
	ld	%g4, %g10, -16
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g12, -4
	fld	%f2, %g4, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g12, -8
	fld	%f2, %g4, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g1, 12
	fjlt	%f1, %f0, fjge_else.41622
	fst	%f1, %g3, 0
	jmp	fjge_cont.41623
fjge_else.41622:
	fmov	%f1, %f18
	fdiv	%f1, %f1, %f0
	fst	%f1, %g3, 0
	fld	%f1, %g4, 0
	fdiv	%f1, %f1, %f0
	fneg	%f1, %f1
	fst	%f1, %g3, -4
	fld	%f1, %g4, -4
	fdiv	%f1, %f1, %f0
	fneg	%f1, %f1
	fst	%f1, %g3, -8
	fld	%f1, %g4, -8
	fdiv	%f0, %f1, %f0
	fneg	%f0, %f0
	fst	%f0, %g3, -12
fjge_cont.41623:
	ld	%g4, %g1, 4
	slli	%g5, %g4, 2
	add	%g26, %g11, %g5
	st	%g3, %g26, 0
	jmp	jeq_cont.41621
jeq_else.41620:
	addi	%g13, %g0, 5
	fmov	%f0, %f16
	st	%g4, %g1, 4
	fst	%f0, %g1, 16
	mov	%g3, %g13
	subi	%g1, %g1, 24
	call	min_caml_create_float_array
	addi	%g1, %g1, 24
	fld	%f0, %g12, 0
	fld	%f1, %g12, -4
	fld	%f2, %g12, -8
	fmul	%f3, %f0, %f0
	ld	%g4, %g10, -16
	fld	%f4, %g4, 0
	fmul	%f3, %f3, %f4
	fmul	%f5, %f1, %f1
	fld	%f6, %g4, -4
	fmul	%f5, %f5, %f6
	fadd	%f3, %f3, %f5
	fmul	%f5, %f2, %f2
	fld	%f7, %g4, -8
	fmul	%f5, %f5, %f7
	fadd	%f3, %f3, %f5
	ld	%g4, %g10, -12
	jne	%g4, %g0, jeq_else.41624
	jmp	jeq_cont.41625
jeq_else.41624:
	fmul	%f5, %f1, %f2
	ld	%g5, %g10, -36
	fld	%f8, %g5, 0
	fmul	%f5, %f5, %f8
	fadd	%f3, %f3, %f5
	fmul	%f5, %f2, %f0
	fld	%f8, %g5, -4
	fmul	%f5, %f5, %f8
	fadd	%f3, %f3, %f5
	fmul	%f5, %f0, %f1
	fld	%f8, %g5, -8
	fmul	%f5, %f5, %f8
	fadd	%f3, %f3, %f5
jeq_cont.41625:
	fmul	%f0, %f0, %f4
	fneg	%f0, %f0
	fmul	%f1, %f1, %f6
	fneg	%f1, %f1
	fmul	%f2, %f2, %f7
	fneg	%f2, %f2
	fst	%f3, %g3, 0
	jne	%g4, %g0, jeq_else.41626
	fst	%f0, %g3, -4
	fst	%f1, %g3, -8
	fst	%f2, %g3, -12
	jmp	jeq_cont.41627
jeq_else.41626:
	fld	%f4, %g12, -8
	ld	%g4, %g10, -36
	fld	%f5, %g4, -4
	fmul	%f4, %f4, %f5
	fld	%f5, %g12, -4
	fld	%f6, %g4, -8
	fmul	%f5, %f5, %f6
	fadd	%f4, %f4, %f5
	fmov	%f5, %f19
	fmul	%f4, %f4, %f5
	fsub	%f0, %f0, %f4
	fst	%f0, %g3, -4
	fld	%f0, %g12, -8
	fld	%f4, %g4, 0
	fmul	%f0, %f0, %f4
	fld	%f4, %g12, 0
	fld	%f6, %g4, -8
	fmul	%f4, %f4, %f6
	fadd	%f0, %f0, %f4
	fmul	%f0, %f0, %f5
	fsub	%f0, %f1, %f0
	fst	%f0, %g3, -8
	fld	%f0, %g12, -4
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g12, 0
	fld	%f4, %g4, -4
	fmul	%f1, %f1, %f4
	fadd	%f0, %f0, %f1
	fmul	%f0, %f0, %f5
	fsub	%f0, %f2, %f0
	fst	%f0, %g3, -12
jeq_cont.41627:
	fld	%f0, %g1, 16
	fjeq	%f3, %f0, fjne_else.41628
	fmov	%f0, %f17
	fdiv	%f0, %f0, %f3
	fst	%f0, %g3, -16
	jmp	fjne_cont.41629
fjne_else.41628:
fjne_cont.41629:
	ld	%g4, %g1, 4
	slli	%g5, %g4, 2
	add	%g26, %g11, %g5
	st	%g3, %g26, 0
jeq_cont.41621:
jeq_cont.41601:
	subi	%g3, %g4, 1
	ld	%g4, %g1, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	jmp	iter_setup_dirvec_constants.2801
jge_else.41599:
	return
setup_startp_constants.2806:
	ld	%g5, %g31, 820
	jlt	%g4, %g0, jge_else.41631
	slli	%g6, %g4, 2
	add	%g26, %g5, %g6
	ld	%g5, %g26, 0
	ld	%g6, %g5, -40
	ld	%g7, %g5, -4
	fld	%f0, %g3, 0
	ld	%g8, %g5, -20
	fld	%f1, %g8, 0
	fsub	%f0, %f0, %f1
	fst	%f0, %g6, 0
	fld	%f0, %g3, -4
	fld	%f1, %g8, -4
	fsub	%f0, %f0, %f1
	fst	%f0, %g6, -4
	fld	%f0, %g3, -8
	fld	%f1, %g8, -8
	fsub	%f0, %f0, %f1
	fst	%f0, %g6, -8
	addi	%g8, %g0, 2
	jne	%g7, %g8, jeq_else.41632
	ld	%g5, %g5, -16
	fld	%f0, %g6, 0
	fld	%f1, %g6, -4
	fld	%f2, %g6, -8
	fld	%f3, %g5, 0
	fmul	%f0, %f3, %f0
	fld	%f3, %g5, -4
	fmul	%f1, %f3, %f1
	fadd	%f0, %f0, %f1
	fld	%f1, %g5, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g6, -12
	jmp	jeq_cont.41633
jeq_else.41632:
	addi	%g8, %g0, 2
	jlt	%g8, %g7, jle_else.41634
	jmp	jle_cont.41635
jle_else.41634:
	fld	%f0, %g6, 0
	fld	%f1, %g6, -4
	fld	%f2, %g6, -8
	fmul	%f3, %f0, %f0
	ld	%g8, %g5, -16
	fld	%f4, %g8, 0
	fmul	%f3, %f3, %f4
	fmul	%f4, %f1, %f1
	fld	%f5, %g8, -4
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	fmul	%f4, %f2, %f2
	fld	%f5, %g8, -8
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	ld	%g8, %g5, -12
	jne	%g8, %g0, jeq_else.41636
	fmov	%f0, %f3
	jmp	jeq_cont.41637
jeq_else.41636:
	fmul	%f4, %f1, %f2
	ld	%g5, %g5, -36
	fld	%f5, %g5, 0
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	fmul	%f2, %f2, %f0
	fld	%f4, %g5, -4
	fmul	%f2, %f2, %f4
	fadd	%f2, %f3, %f2
	fmul	%f0, %f0, %f1
	fld	%f1, %g5, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
jeq_cont.41637:
	addi	%g5, %g0, 3
	jne	%g7, %g5, jeq_else.41638
	fmov	%f1, %f17
	fsub	%f0, %f0, %f1
	jmp	jeq_cont.41639
jeq_else.41638:
jeq_cont.41639:
	fst	%f0, %g6, -12
jle_cont.41635:
jeq_cont.41633:
	subi	%g4, %g4, 1
	jmp	setup_startp_constants.2806
jge_else.41631:
	return
check_all_inside.2831:
	ld	%g5, %g31, 820
	slli	%g6, %g3, 2
	add	%g26, %g4, %g6
	ld	%g6, %g26, 0
	jne	%g6, %g29, jeq_else.41641
	addi	%g3, %g0, 1
	return
jeq_else.41641:
	slli	%g6, %g6, 2
	add	%g26, %g5, %g6
	ld	%g5, %g26, 0
	ld	%g6, %g5, -20
	fld	%f3, %g6, 0
	fsub	%f3, %f0, %f3
	fld	%f4, %g6, -4
	fsub	%f4, %f1, %f4
	fld	%f5, %g6, -8
	fsub	%f5, %f2, %f5
	ld	%g6, %g5, -4
	jne	%g6, %g28, jeq_else.41642
	fmov	%f6, %f16
	fjlt	%f3, %f6, fjge_else.41644
	jmp	fjge_cont.41645
fjge_else.41644:
	fneg	%f3, %f3
fjge_cont.41645:
	ld	%g6, %g5, -16
	fld	%f7, %g6, 0
	fjlt	%f3, %f7, fjge_else.41646
	addi	%g6, %g0, 0
	jmp	fjge_cont.41647
fjge_else.41646:
	fjlt	%f4, %f6, fjge_else.41648
	fmov	%f3, %f4
	jmp	fjge_cont.41649
fjge_else.41648:
	fneg	%f3, %f4
fjge_cont.41649:
	fld	%f4, %g6, -4
	fjlt	%f3, %f4, fjge_else.41650
	addi	%g6, %g0, 0
	jmp	fjge_cont.41651
fjge_else.41650:
	fjlt	%f5, %f6, fjge_else.41652
	fmov	%f3, %f5
	jmp	fjge_cont.41653
fjge_else.41652:
	fneg	%f3, %f5
fjge_cont.41653:
	fld	%f4, %g6, -8
	fjlt	%f3, %f4, fjge_else.41654
	addi	%g6, %g0, 0
	jmp	fjge_cont.41655
fjge_else.41654:
	addi	%g6, %g0, 1
fjge_cont.41655:
fjge_cont.41651:
fjge_cont.41647:
	jne	%g6, %g0, jeq_else.41656
	ld	%g5, %g5, -24
	jne	%g5, %g0, jeq_else.41658
	addi	%g5, %g0, 1
	jmp	jeq_cont.41659
jeq_else.41658:
	addi	%g5, %g0, 0
jeq_cont.41659:
	jmp	jeq_cont.41657
jeq_else.41656:
	ld	%g5, %g5, -24
jeq_cont.41657:
	jmp	jeq_cont.41643
jeq_else.41642:
	addi	%g7, %g0, 2
	jne	%g6, %g7, jeq_else.41660
	ld	%g6, %g5, -16
	fld	%f6, %g6, 0
	fmul	%f3, %f6, %f3
	fld	%f6, %g6, -4
	fmul	%f4, %f6, %f4
	fadd	%f3, %f3, %f4
	fld	%f4, %g6, -8
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	ld	%g5, %g5, -24
	fmov	%f4, %f16
	fjlt	%f3, %f4, fjge_else.41662
	addi	%g6, %g0, 0
	jmp	fjge_cont.41663
fjge_else.41662:
	addi	%g6, %g0, 1
fjge_cont.41663:
	jne	%g5, %g6, jeq_else.41664
	addi	%g5, %g0, 1
	jmp	jeq_cont.41665
jeq_else.41664:
	addi	%g5, %g0, 0
jeq_cont.41665:
	jmp	jeq_cont.41661
jeq_else.41660:
	fmul	%f6, %f3, %f3
	ld	%g7, %g5, -16
	fld	%f7, %g7, 0
	fmul	%f6, %f6, %f7
	fmul	%f7, %f4, %f4
	fld	%f8, %g7, -4
	fmul	%f7, %f7, %f8
	fadd	%f6, %f6, %f7
	fmul	%f7, %f5, %f5
	fld	%f8, %g7, -8
	fmul	%f7, %f7, %f8
	fadd	%f6, %f6, %f7
	ld	%g7, %g5, -12
	jne	%g7, %g0, jeq_else.41666
	fmov	%f3, %f6
	jmp	jeq_cont.41667
jeq_else.41666:
	fmul	%f7, %f4, %f5
	ld	%g7, %g5, -36
	fld	%f8, %g7, 0
	fmul	%f7, %f7, %f8
	fadd	%f6, %f6, %f7
	fmul	%f5, %f5, %f3
	fld	%f7, %g7, -4
	fmul	%f5, %f5, %f7
	fadd	%f5, %f6, %f5
	fmul	%f3, %f3, %f4
	fld	%f4, %g7, -8
	fmul	%f3, %f3, %f4
	fadd	%f3, %f5, %f3
jeq_cont.41667:
	addi	%g7, %g0, 3
	jne	%g6, %g7, jeq_else.41668
	fmov	%f4, %f17
	fsub	%f3, %f3, %f4
	jmp	jeq_cont.41669
jeq_else.41668:
jeq_cont.41669:
	ld	%g5, %g5, -24
	fmov	%f4, %f16
	fjlt	%f3, %f4, fjge_else.41670
	addi	%g6, %g0, 0
	jmp	fjge_cont.41671
fjge_else.41670:
	addi	%g6, %g0, 1
fjge_cont.41671:
	jne	%g5, %g6, jeq_else.41672
	addi	%g5, %g0, 1
	jmp	jeq_cont.41673
jeq_else.41672:
	addi	%g5, %g0, 0
jeq_cont.41673:
jeq_cont.41661:
jeq_cont.41643:
	jne	%g5, %g0, jeq_else.41674
	addi	%g3, %g3, 1
	jmp	check_all_inside.2831
jeq_else.41674:
	addi	%g3, %g0, 0
	return
shadow_check_and_group.2837:
	ld	%g10, %g31, 820
	ld	%g11, %g31, 780
	ld	%g12, %g31, 696
	ld	%g13, %g31, 700
	ld	%g14, %g31, 792
	ld	%g15, %g31, 808
	slli	%g16, %g3, 2
	add	%g26, %g4, %g16
	ld	%g16, %g26, 0
	jne	%g16, %g29, jeq_else.41675
	addi	%g3, %g0, 0
	return
jeq_else.41675:
	slli	%g17, %g16, 2
	add	%g26, %g10, %g17
	ld	%g17, %g26, 0
	fld	%f0, %g11, 0
	ld	%g18, %g17, -20
	fld	%f1, %g18, 0
	fsub	%f0, %f0, %f1
	fld	%f1, %g11, -4
	fld	%f10, %g18, -4
	fsub	%f1, %f1, %f10
	fld	%f10, %g11, -8
	fld	%f11, %g18, -8
	fsub	%f10, %f10, %f11
	slli	%g18, %g16, 2
	add	%g26, %g12, %g18
	ld	%g12, %g26, 0
	ld	%g18, %g17, -4
	jne	%g18, %g28, jeq_else.41676
	fld	%f2, %g12, 0
	fsub	%f2, %f2, %f0
	fld	%f11, %g12, -4
	fmul	%f2, %f2, %f11
	fld	%f12, %g13, -4
	fmul	%f12, %f2, %f12
	fadd	%f12, %f12, %f1
	fmov	%f13, %f16
	fjlt	%f12, %f13, fjge_else.41678
	jmp	fjge_cont.41679
fjge_else.41678:
	fneg	%f12, %f12
fjge_cont.41679:
	ld	%g17, %g17, -16
	fld	%f14, %g17, -4
	fjlt	%f12, %f14, fjge_else.41680
	addi	%g18, %g0, 0
	jmp	fjge_cont.41681
fjge_else.41680:
	fld	%f12, %g13, -8
	fmul	%f12, %f2, %f12
	fadd	%f12, %f12, %f10
	fjlt	%f12, %f13, fjge_else.41682
	jmp	fjge_cont.41683
fjge_else.41682:
	fneg	%f12, %f12
fjge_cont.41683:
	fld	%f14, %g17, -8
	fjlt	%f12, %f14, fjge_else.41684
	addi	%g18, %g0, 0
	jmp	fjge_cont.41685
fjge_else.41684:
	fjeq	%f11, %f13, fjne_else.41686
	addi	%g18, %g0, 1
	jmp	fjne_cont.41687
fjne_else.41686:
	addi	%g18, %g0, 0
fjne_cont.41687:
fjge_cont.41685:
fjge_cont.41681:
	jne	%g18, %g0, jeq_else.41688
	fld	%f2, %g12, -8
	fsub	%f2, %f2, %f1
	fld	%f11, %g12, -12
	fmul	%f2, %f2, %f11
	fld	%f12, %g13, 0
	fmul	%f12, %f2, %f12
	fadd	%f12, %f12, %f0
	fjlt	%f12, %f13, fjge_else.41690
	jmp	fjge_cont.41691
fjge_else.41690:
	fneg	%f12, %f12
fjge_cont.41691:
	fld	%f14, %g17, 0
	fjlt	%f12, %f14, fjge_else.41692
	addi	%g18, %g0, 0
	jmp	fjge_cont.41693
fjge_else.41692:
	fld	%f12, %g13, -8
	fmul	%f12, %f2, %f12
	fadd	%f12, %f12, %f10
	fjlt	%f12, %f13, fjge_else.41694
	jmp	fjge_cont.41695
fjge_else.41694:
	fneg	%f12, %f12
fjge_cont.41695:
	fld	%f14, %g17, -8
	fjlt	%f12, %f14, fjge_else.41696
	addi	%g18, %g0, 0
	jmp	fjge_cont.41697
fjge_else.41696:
	fjeq	%f11, %f13, fjne_else.41698
	addi	%g18, %g0, 1
	jmp	fjne_cont.41699
fjne_else.41698:
	addi	%g18, %g0, 0
fjne_cont.41699:
fjge_cont.41697:
fjge_cont.41693:
	jne	%g18, %g0, jeq_else.41700
	fld	%f2, %g12, -16
	fsub	%f2, %f2, %f10
	fld	%f10, %g12, -20
	fmul	%f2, %f2, %f10
	fld	%f11, %g13, 0
	fmul	%f11, %f2, %f11
	fadd	%f0, %f11, %f0
	fjlt	%f0, %f13, fjge_else.41702
	jmp	fjge_cont.41703
fjge_else.41702:
	fneg	%f0, %f0
fjge_cont.41703:
	fld	%f11, %g17, 0
	fjlt	%f0, %f11, fjge_else.41704
	addi	%g12, %g0, 0
	jmp	fjge_cont.41705
fjge_else.41704:
	fld	%f0, %g13, -4
	fmul	%f0, %f2, %f0
	fadd	%f0, %f0, %f1
	fjlt	%f0, %f13, fjge_else.41706
	jmp	fjge_cont.41707
fjge_else.41706:
	fneg	%f0, %f0
fjge_cont.41707:
	fld	%f1, %g17, -4
	fjlt	%f0, %f1, fjge_else.41708
	addi	%g12, %g0, 0
	jmp	fjge_cont.41709
fjge_else.41708:
	fjeq	%f10, %f13, fjne_else.41710
	addi	%g12, %g0, 1
	jmp	fjne_cont.41711
fjne_else.41710:
	addi	%g12, %g0, 0
fjne_cont.41711:
fjge_cont.41709:
fjge_cont.41705:
	jne	%g12, %g0, jeq_else.41712
	addi	%g12, %g0, 0
	jmp	jeq_cont.41713
jeq_else.41712:
	fst	%f2, %g14, 0
	addi	%g12, %g0, 3
jeq_cont.41713:
	jmp	jeq_cont.41701
jeq_else.41700:
	fst	%f2, %g14, 0
	addi	%g12, %g0, 2
jeq_cont.41701:
	jmp	jeq_cont.41689
jeq_else.41688:
	fst	%f2, %g14, 0
	addi	%g12, %g0, 1
jeq_cont.41689:
	jmp	jeq_cont.41677
jeq_else.41676:
	addi	%g13, %g0, 2
	jne	%g18, %g13, jeq_else.41714
	fld	%f2, %g12, 0
	fmov	%f11, %f16
	fjlt	%f2, %f11, fjge_else.41716
	addi	%g12, %g0, 0
	jmp	fjge_cont.41717
fjge_else.41716:
	fld	%f2, %g12, -4
	fmul	%f0, %f2, %f0
	fld	%f2, %g12, -8
	fmul	%f1, %f2, %f1
	fadd	%f0, %f0, %f1
	fld	%f1, %g12, -12
	fmul	%f1, %f1, %f10
	fadd	%f0, %f0, %f1
	fst	%f0, %g14, 0
	addi	%g12, %g0, 1
fjge_cont.41717:
	jmp	jeq_cont.41715
jeq_else.41714:
	fld	%f11, %g12, 0
	fmov	%f12, %f16
	fjeq	%f11, %f12, fjne_else.41718
	fld	%f13, %g12, -4
	fmul	%f13, %f13, %f0
	fld	%f14, %g12, -8
	fmul	%f14, %f14, %f1
	fadd	%f13, %f13, %f14
	fld	%f14, %g12, -12
	fmul	%f14, %f14, %f10
	fadd	%f13, %f13, %f14
	fmul	%f14, %f0, %f0
	ld	%g13, %g17, -16
	fld	%f15, %g13, 0
	fmul	%f14, %f14, %f15
	fmul	%f15, %f1, %f1
	fld	%f2, %g13, -4
	fmul	%f15, %f15, %f2
	fadd	%f14, %f14, %f15
	fmul	%f15, %f10, %f10
	fld	%f2, %g13, -8
	fmul	%f15, %f15, %f2
	fadd	%f14, %f14, %f15
	ld	%g13, %g17, -12
	jne	%g13, %g0, jeq_else.41720
	fmov	%f0, %f14
	jmp	jeq_cont.41721
jeq_else.41720:
	fmul	%f15, %f1, %f10
	ld	%g13, %g17, -36
	fld	%f2, %g13, 0
	fmul	%f15, %f15, %f2
	fadd	%f14, %f14, %f15
	fmul	%f10, %f10, %f0
	fld	%f15, %g13, -4
	fmul	%f10, %f10, %f15
	fadd	%f10, %f14, %f10
	fmul	%f0, %f0, %f1
	fld	%f1, %g13, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f10, %f0
jeq_cont.41721:
	addi	%g13, %g0, 3
	jne	%g18, %g13, jeq_else.41722
	fmov	%f1, %f17
	fsub	%f0, %f0, %f1
	jmp	jeq_cont.41723
jeq_else.41722:
jeq_cont.41723:
	fmul	%f1, %f13, %f13
	fmul	%f0, %f11, %f0
	fsub	%f0, %f1, %f0
	fjlt	%f12, %f0, fjge_else.41724
	addi	%g12, %g0, 0
	jmp	fjge_cont.41725
fjge_else.41724:
	ld	%g13, %g17, -24
	jne	%g13, %g0, jeq_else.41726
	fsqrt	%f0, %f0
	fsub	%f0, %f13, %f0
	fld	%f1, %g12, -16
	fmul	%f0, %f0, %f1
	fst	%f0, %g14, 0
	jmp	jeq_cont.41727
jeq_else.41726:
	fsqrt	%f0, %f0
	fadd	%f0, %f13, %f0
	fld	%f1, %g12, -16
	fmul	%f0, %f0, %f1
	fst	%f0, %g14, 0
jeq_cont.41727:
	addi	%g12, %g0, 1
fjge_cont.41725:
	jmp	fjne_cont.41719
fjne_else.41718:
	addi	%g12, %g0, 0
fjne_cont.41719:
jeq_cont.41715:
jeq_cont.41677:
	fld	%f0, %g14, 0
	jne	%g12, %g0, jeq_else.41728
	addi	%g12, %g0, 0
	jmp	jeq_cont.41729
jeq_else.41728:
	setL %g12, l.35936
	fld	%f1, %g12, 0
	fjlt	%f0, %f1, fjge_else.41730
	addi	%g12, %g0, 0
	jmp	fjge_cont.41731
fjge_else.41730:
	addi	%g12, %g0, 1
fjge_cont.41731:
jeq_cont.41729:
	jne	%g12, %g0, jeq_else.41732
	slli	%g5, %g16, 2
	add	%g26, %g10, %g5
	ld	%g5, %g26, 0
	ld	%g5, %g5, -24
	jne	%g5, %g0, jeq_else.41733
	addi	%g3, %g0, 0
	return
jeq_else.41733:
	addi	%g3, %g3, 1
	jmp	shadow_check_and_group.2837
jeq_else.41732:
	setL %g10, l.35938
	fld	%f1, %g10, 0
	fadd	%f0, %f0, %f1
	fld	%f1, %g15, 0
	fmul	%f1, %f1, %f0
	fld	%f2, %g11, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g15, -4
	fmul	%f2, %f2, %f0
	fld	%f10, %g11, -4
	fadd	%f2, %f2, %f10
	fld	%f10, %g15, -8
	fmul	%f0, %f10, %f0
	fld	%f10, %g11, -8
	fadd	%f0, %f0, %f10
	addi	%g10, %g0, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g10
	fmov	%f15, %f2
	fmov	%f2, %f0
	fmov	%f0, %f1
	fmov	%f1, %f15
	subi	%g1, %g1, 12
	call	check_all_inside.2831
	addi	%g1, %g1, 12
	jne	%g3, %g0, jeq_else.41734
	ld	%g3, %g1, 4
	addi	%g3, %g3, 1
	ld	%g4, %g1, 0
	jmp	shadow_check_and_group.2837
jeq_else.41734:
	addi	%g3, %g0, 1
	return
shadow_check_one_or_group.2840:
	ld	%g19, %g31, 800
	slli	%g20, %g3, 2
	add	%g26, %g4, %g20
	ld	%g20, %g26, 0
	jne	%g20, %g29, jeq_else.41735
	addi	%g3, %g0, 0
	return
jeq_else.41735:
	slli	%g20, %g20, 2
	add	%g26, %g19, %g20
	ld	%g20, %g26, 0
	addi	%g21, %g0, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	mov	%g4, %g20
	mov	%g3, %g21
	subi	%g1, %g1, 12
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 12
	jne	%g3, %g0, jeq_else.41736
	ld	%g3, %g1, 4
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g20, %g1, 0
	add	%g26, %g20, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.41737
	addi	%g3, %g0, 0
	return
jeq_else.41737:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g21, %g0, 0
	st	%g3, %g1, 8
	mov	%g3, %g21
	subi	%g1, %g1, 16
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 16
	jne	%g3, %g0, jeq_else.41738
	ld	%g3, %g1, 8
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	add	%g26, %g20, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.41739
	addi	%g3, %g0, 0
	return
jeq_else.41739:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g21, %g0, 0
	st	%g3, %g1, 12
	mov	%g3, %g21
	subi	%g1, %g1, 20
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 20
	jne	%g3, %g0, jeq_else.41740
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	add	%g26, %g20, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.41741
	addi	%g3, %g0, 0
	return
jeq_else.41741:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g21, %g0, 0
	st	%g3, %g1, 16
	mov	%g3, %g21
	subi	%g1, %g1, 24
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 24
	jne	%g3, %g0, jeq_else.41742
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	add	%g26, %g20, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.41743
	addi	%g3, %g0, 0
	return
jeq_else.41743:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g21, %g0, 0
	st	%g3, %g1, 20
	mov	%g3, %g21
	subi	%g1, %g1, 28
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 28
	jne	%g3, %g0, jeq_else.41744
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	add	%g26, %g20, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.41745
	addi	%g3, %g0, 0
	return
jeq_else.41745:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g21, %g0, 0
	st	%g3, %g1, 24
	mov	%g3, %g21
	subi	%g1, %g1, 32
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 32
	jne	%g3, %g0, jeq_else.41746
	ld	%g3, %g1, 24
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	add	%g26, %g20, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.41747
	addi	%g3, %g0, 0
	return
jeq_else.41747:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g21, %g0, 0
	st	%g3, %g1, 28
	mov	%g3, %g21
	subi	%g1, %g1, 36
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 36
	jne	%g3, %g0, jeq_else.41748
	ld	%g3, %g1, 28
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	add	%g26, %g20, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.41749
	addi	%g3, %g0, 0
	return
jeq_else.41749:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g19, %g0, 0
	st	%g3, %g1, 32
	mov	%g3, %g19
	subi	%g1, %g1, 40
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 40
	jne	%g3, %g0, jeq_else.41750
	ld	%g3, %g1, 32
	addi	%g3, %g3, 1
	mov	%g4, %g20
	jmp	shadow_check_one_or_group.2840
jeq_else.41750:
	addi	%g3, %g0, 1
	return
jeq_else.41748:
	addi	%g3, %g0, 1
	return
jeq_else.41746:
	addi	%g3, %g0, 1
	return
jeq_else.41744:
	addi	%g3, %g0, 1
	return
jeq_else.41742:
	addi	%g3, %g0, 1
	return
jeq_else.41740:
	addi	%g3, %g0, 1
	return
jeq_else.41738:
	addi	%g3, %g0, 1
	return
jeq_else.41736:
	addi	%g3, %g0, 1
	return
shadow_check_one_or_matrix.2843:
	ld	%g10, %g31, 820
	ld	%g11, %g31, 780
	ld	%g12, %g31, 696
	ld	%g13, %g31, 700
	ld	%g14, %g31, 792
	ld	%g15, %g31, 800
	slli	%g16, %g3, 2
	add	%g26, %g4, %g16
	ld	%g16, %g26, 0
	ld	%g17, %g16, 0
	jne	%g17, %g29, jeq_else.41751
	addi	%g3, %g0, 0
	return
jeq_else.41751:
	addi	%g18, %g0, 99
	st	%g15, %g1, 0
	st	%g16, %g1, 4
	st	%g4, %g1, 8
	st	%g3, %g1, 12
	jne	%g17, %g18, jeq_else.41752
	addi	%g3, %g0, 1
	jmp	jeq_cont.41753
jeq_else.41752:
	slli	%g18, %g17, 2
	add	%g26, %g10, %g18
	ld	%g10, %g26, 0
	fld	%f0, %g11, 0
	ld	%g18, %g10, -20
	fld	%f1, %g18, 0
	fsub	%f0, %f0, %f1
	fld	%f1, %g11, -4
	fld	%f10, %g18, -4
	fsub	%f1, %f1, %f10
	fld	%f10, %g11, -8
	fld	%f11, %g18, -8
	fsub	%f10, %f10, %f11
	slli	%g11, %g17, 2
	add	%g26, %g12, %g11
	ld	%g11, %g26, 0
	ld	%g12, %g10, -4
	jne	%g12, %g28, jeq_else.41754
	fld	%f9, %g11, 0
	fsub	%f9, %f9, %f0
	fld	%f2, %g11, -4
	fmul	%f9, %f9, %f2
	fld	%f3, %g13, -4
	fmul	%f3, %f9, %f3
	fadd	%f3, %f3, %f1
	fmov	%f4, %f16
	fjlt	%f3, %f4, fjge_else.41756
	jmp	fjge_cont.41757
fjge_else.41756:
	fneg	%f3, %f3
fjge_cont.41757:
	ld	%g19, %g10, -16
	fld	%f5, %g19, -4
	fjlt	%f3, %f5, fjge_else.41758
	addi	%g20, %g0, 0
	jmp	fjge_cont.41759
fjge_else.41758:
	fld	%f3, %g13, -8
	fmul	%f3, %f9, %f3
	fadd	%f3, %f3, %f10
	fjlt	%f3, %f4, fjge_else.41760
	jmp	fjge_cont.41761
fjge_else.41760:
	fneg	%f3, %f3
fjge_cont.41761:
	fld	%f5, %g19, -8
	fjlt	%f3, %f5, fjge_else.41762
	addi	%g20, %g0, 0
	jmp	fjge_cont.41763
fjge_else.41762:
	fjeq	%f2, %f4, fjne_else.41764
	addi	%g20, %g0, 1
	jmp	fjne_cont.41765
fjne_else.41764:
	addi	%g20, %g0, 0
fjne_cont.41765:
fjge_cont.41763:
fjge_cont.41759:
	jne	%g20, %g0, jeq_else.41766
	fld	%f9, %g11, -8
	fsub	%f9, %f9, %f1
	fld	%f2, %g11, -12
	fmul	%f9, %f9, %f2
	fld	%f3, %g13, 0
	fmul	%f3, %f9, %f3
	fadd	%f3, %f3, %f0
	fjlt	%f3, %f4, fjge_else.41768
	jmp	fjge_cont.41769
fjge_else.41768:
	fneg	%f3, %f3
fjge_cont.41769:
	fld	%f5, %g19, 0
	fjlt	%f3, %f5, fjge_else.41770
	addi	%g20, %g0, 0
	jmp	fjge_cont.41771
fjge_else.41770:
	fld	%f3, %g13, -8
	fmul	%f3, %f9, %f3
	fadd	%f3, %f3, %f10
	fjlt	%f3, %f4, fjge_else.41772
	jmp	fjge_cont.41773
fjge_else.41772:
	fneg	%f3, %f3
fjge_cont.41773:
	fld	%f5, %g19, -8
	fjlt	%f3, %f5, fjge_else.41774
	addi	%g20, %g0, 0
	jmp	fjge_cont.41775
fjge_else.41774:
	fjeq	%f2, %f4, fjne_else.41776
	addi	%g20, %g0, 1
	jmp	fjne_cont.41777
fjne_else.41776:
	addi	%g20, %g0, 0
fjne_cont.41777:
fjge_cont.41775:
fjge_cont.41771:
	jne	%g20, %g0, jeq_else.41778
	fld	%f9, %g11, -16
	fsub	%f9, %f9, %f10
	fld	%f2, %g11, -20
	fmul	%f9, %f9, %f2
	fld	%f3, %g13, 0
	fmul	%f3, %f9, %f3
	fadd	%f0, %f3, %f0
	fjlt	%f0, %f4, fjge_else.41780
	jmp	fjge_cont.41781
fjge_else.41780:
	fneg	%f0, %f0
fjge_cont.41781:
	fld	%f3, %g19, 0
	fjlt	%f0, %f3, fjge_else.41782
	addi	%g19, %g0, 0
	jmp	fjge_cont.41783
fjge_else.41782:
	fld	%f0, %g13, -4
	fmul	%f0, %f9, %f0
	fadd	%f0, %f0, %f1
	fjlt	%f0, %f4, fjge_else.41784
	jmp	fjge_cont.41785
fjge_else.41784:
	fneg	%f0, %f0
fjge_cont.41785:
	fld	%f1, %g19, -4
	fjlt	%f0, %f1, fjge_else.41786
	addi	%g19, %g0, 0
	jmp	fjge_cont.41787
fjge_else.41786:
	fjeq	%f2, %f4, fjne_else.41788
	addi	%g19, %g0, 1
	jmp	fjne_cont.41789
fjne_else.41788:
	addi	%g19, %g0, 0
fjne_cont.41789:
fjge_cont.41787:
fjge_cont.41783:
	jne	%g19, %g0, jeq_else.41790
	addi	%g19, %g0, 0
	jmp	jeq_cont.41791
jeq_else.41790:
	fst	%f9, %g14, 0
	addi	%g19, %g0, 3
jeq_cont.41791:
	jmp	jeq_cont.41779
jeq_else.41778:
	fst	%f9, %g14, 0
	addi	%g19, %g0, 2
jeq_cont.41779:
	jmp	jeq_cont.41767
jeq_else.41766:
	fst	%f9, %g14, 0
	addi	%g19, %g0, 1
jeq_cont.41767:
	jmp	jeq_cont.41755
jeq_else.41754:
	addi	%g13, %g0, 2
	jne	%g12, %g13, jeq_else.41792
	fld	%f9, %g11, 0
	fmov	%f2, %f16
	fjlt	%f9, %f2, fjge_else.41794
	addi	%g19, %g0, 0
	jmp	fjge_cont.41795
fjge_else.41794:
	fld	%f9, %g11, -4
	fmul	%f9, %f9, %f0
	fld	%f0, %g11, -8
	fmul	%f0, %f0, %f1
	fadd	%f9, %f9, %f0
	fld	%f0, %g11, -12
	fmul	%f0, %f0, %f10
	fadd	%f9, %f9, %f0
	fst	%f9, %g14, 0
	addi	%g19, %g0, 1
fjge_cont.41795:
	jmp	jeq_cont.41793
jeq_else.41792:
	fld	%f11, %g11, 0
	fmov	%f12, %f16
	fjeq	%f11, %f12, fjne_else.41796
	fld	%f13, %g11, -4
	fmul	%f13, %f13, %f0
	fld	%f14, %g11, -8
	fmul	%f14, %f14, %f1
	fadd	%f13, %f13, %f14
	fld	%f14, %g11, -12
	fmul	%f14, %f14, %f10
	fadd	%f13, %f13, %f14
	fmul	%f14, %f0, %f0
	ld	%g13, %g10, -16
	fld	%f15, %g13, 0
	fmul	%f14, %f14, %f15
	fmul	%f15, %f1, %f1
	fld	%f2, %g13, -4
	fmul	%f15, %f15, %f2
	fadd	%f14, %f14, %f15
	fmul	%f15, %f10, %f10
	fld	%f2, %g13, -8
	fmul	%f15, %f15, %f2
	fadd	%f14, %f14, %f15
	ld	%g13, %g10, -12
	jne	%g13, %g0, jeq_else.41798
	fmov	%f0, %f14
	jmp	jeq_cont.41799
jeq_else.41798:
	fmul	%f15, %f1, %f10
	ld	%g13, %g10, -36
	fld	%f2, %g13, 0
	fmul	%f15, %f15, %f2
	fadd	%f14, %f14, %f15
	fmul	%f10, %f10, %f0
	fld	%f15, %g13, -4
	fmul	%f10, %f10, %f15
	fadd	%f10, %f14, %f10
	fmul	%f0, %f0, %f1
	fld	%f1, %g13, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f10, %f0
jeq_cont.41799:
	addi	%g13, %g0, 3
	jne	%g12, %g13, jeq_else.41800
	fmov	%f1, %f17
	fsub	%f0, %f0, %f1
	jmp	jeq_cont.41801
jeq_else.41800:
jeq_cont.41801:
	fmul	%f1, %f13, %f13
	fmul	%f0, %f11, %f0
	fsub	%f0, %f1, %f0
	fjlt	%f12, %f0, fjge_else.41802
	addi	%g19, %g0, 0
	jmp	fjge_cont.41803
fjge_else.41802:
	ld	%g10, %g10, -24
	jne	%g10, %g0, jeq_else.41804
	fsqrt	%f9, %f0
	fsub	%f9, %f13, %f9
	fld	%f0, %g11, -16
	fmul	%f9, %f9, %f0
	fst	%f9, %g14, 0
	jmp	jeq_cont.41805
jeq_else.41804:
	fsqrt	%f9, %f0
	fadd	%f9, %f13, %f9
	fld	%f0, %g11, -16
	fmul	%f9, %f9, %f0
	fst	%f9, %g14, 0
jeq_cont.41805:
	addi	%g19, %g0, 1
fjge_cont.41803:
	jmp	fjne_cont.41797
fjne_else.41796:
	addi	%g19, %g0, 0
fjne_cont.41797:
jeq_cont.41793:
jeq_cont.41755:
	jne	%g19, %g0, jeq_else.41806
	addi	%g3, %g0, 0
	jmp	jeq_cont.41807
jeq_else.41806:
	fld	%f9, %g14, 0
	fmov	%f0, %f27
	fjlt	%f9, %f0, fjge_else.41808
	addi	%g3, %g0, 0
	jmp	fjge_cont.41809
fjge_else.41808:
	ld	%g19, %g16, -4
	jne	%g19, %g29, jeq_else.41810
	addi	%g3, %g0, 0
	jmp	jeq_cont.41811
jeq_else.41810:
	slli	%g19, %g19, 2
	add	%g26, %g15, %g19
	ld	%g19, %g26, 0
	addi	%g20, %g0, 0
	mov	%g4, %g19
	mov	%g3, %g20
	subi	%g1, %g1, 20
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 20
	jne	%g3, %g0, jeq_else.41812
	ld	%g3, %g1, 4
	ld	%g4, %g3, -8
	jne	%g4, %g29, jeq_else.41814
	addi	%g3, %g0, 0
	jmp	jeq_cont.41815
jeq_else.41814:
	slli	%g4, %g4, 2
	ld	%g19, %g1, 0
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g20, %g0, 0
	mov	%g3, %g20
	subi	%g1, %g1, 20
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 20
	jne	%g3, %g0, jeq_else.41816
	ld	%g3, %g1, 4
	ld	%g4, %g3, -12
	jne	%g4, %g29, jeq_else.41818
	addi	%g3, %g0, 0
	jmp	jeq_cont.41819
jeq_else.41818:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g20, %g0, 0
	mov	%g3, %g20
	subi	%g1, %g1, 20
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 20
	jne	%g3, %g0, jeq_else.41820
	ld	%g3, %g1, 4
	ld	%g4, %g3, -16
	jne	%g4, %g29, jeq_else.41822
	addi	%g3, %g0, 0
	jmp	jeq_cont.41823
jeq_else.41822:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g20, %g0, 0
	mov	%g3, %g20
	subi	%g1, %g1, 20
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 20
	jne	%g3, %g0, jeq_else.41824
	ld	%g3, %g1, 4
	ld	%g4, %g3, -20
	jne	%g4, %g29, jeq_else.41826
	addi	%g3, %g0, 0
	jmp	jeq_cont.41827
jeq_else.41826:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g20, %g0, 0
	mov	%g3, %g20
	subi	%g1, %g1, 20
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 20
	jne	%g3, %g0, jeq_else.41828
	ld	%g3, %g1, 4
	ld	%g4, %g3, -24
	jne	%g4, %g29, jeq_else.41830
	addi	%g3, %g0, 0
	jmp	jeq_cont.41831
jeq_else.41830:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g20, %g0, 0
	mov	%g3, %g20
	subi	%g1, %g1, 20
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 20
	jne	%g3, %g0, jeq_else.41832
	ld	%g3, %g1, 4
	ld	%g4, %g3, -28
	jne	%g4, %g29, jeq_else.41834
	addi	%g3, %g0, 0
	jmp	jeq_cont.41835
jeq_else.41834:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g20, %g0, 0
	mov	%g3, %g20
	subi	%g1, %g1, 20
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 20
	jne	%g3, %g0, jeq_else.41836
	addi	%g3, %g0, 8
	ld	%g4, %g1, 4
	subi	%g1, %g1, 20
	call	shadow_check_one_or_group.2840
	addi	%g1, %g1, 20
	jmp	jeq_cont.41837
jeq_else.41836:
	addi	%g3, %g0, 1
jeq_cont.41837:
jeq_cont.41835:
	jmp	jeq_cont.41833
jeq_else.41832:
	addi	%g3, %g0, 1
jeq_cont.41833:
jeq_cont.41831:
	jmp	jeq_cont.41829
jeq_else.41828:
	addi	%g3, %g0, 1
jeq_cont.41829:
jeq_cont.41827:
	jmp	jeq_cont.41825
jeq_else.41824:
	addi	%g3, %g0, 1
jeq_cont.41825:
jeq_cont.41823:
	jmp	jeq_cont.41821
jeq_else.41820:
	addi	%g3, %g0, 1
jeq_cont.41821:
jeq_cont.41819:
	jmp	jeq_cont.41817
jeq_else.41816:
	addi	%g3, %g0, 1
jeq_cont.41817:
jeq_cont.41815:
	jmp	jeq_cont.41813
jeq_else.41812:
	addi	%g3, %g0, 1
jeq_cont.41813:
jeq_cont.41811:
	jne	%g3, %g0, jeq_else.41838
	addi	%g3, %g0, 0
	jmp	jeq_cont.41839
jeq_else.41838:
	addi	%g3, %g0, 1
jeq_cont.41839:
fjge_cont.41809:
jeq_cont.41807:
jeq_cont.41753:
	jne	%g3, %g0, jeq_else.41840
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	ld	%g4, %g1, 8
	jmp	shadow_check_one_or_matrix.2843
jeq_else.41840:
	ld	%g3, %g1, 4
	ld	%g4, %g3, -4
	jne	%g4, %g29, jeq_else.41841
	addi	%g3, %g0, 0
	jmp	jeq_cont.41842
jeq_else.41841:
	slli	%g4, %g4, 2
	ld	%g19, %g1, 0
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g20, %g0, 0
	mov	%g3, %g20
	subi	%g1, %g1, 20
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 20
	jne	%g3, %g0, jeq_else.41843
	ld	%g3, %g1, 4
	ld	%g4, %g3, -8
	jne	%g4, %g29, jeq_else.41845
	addi	%g3, %g0, 0
	jmp	jeq_cont.41846
jeq_else.41845:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g20, %g0, 0
	mov	%g3, %g20
	subi	%g1, %g1, 20
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 20
	jne	%g3, %g0, jeq_else.41847
	ld	%g3, %g1, 4
	ld	%g4, %g3, -12
	jne	%g4, %g29, jeq_else.41849
	addi	%g3, %g0, 0
	jmp	jeq_cont.41850
jeq_else.41849:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g20, %g0, 0
	mov	%g3, %g20
	subi	%g1, %g1, 20
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 20
	jne	%g3, %g0, jeq_else.41851
	ld	%g3, %g1, 4
	ld	%g4, %g3, -16
	jne	%g4, %g29, jeq_else.41853
	addi	%g3, %g0, 0
	jmp	jeq_cont.41854
jeq_else.41853:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g20, %g0, 0
	mov	%g3, %g20
	subi	%g1, %g1, 20
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 20
	jne	%g3, %g0, jeq_else.41855
	ld	%g3, %g1, 4
	ld	%g4, %g3, -20
	jne	%g4, %g29, jeq_else.41857
	addi	%g3, %g0, 0
	jmp	jeq_cont.41858
jeq_else.41857:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g20, %g0, 0
	mov	%g3, %g20
	subi	%g1, %g1, 20
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 20
	jne	%g3, %g0, jeq_else.41859
	ld	%g3, %g1, 4
	ld	%g4, %g3, -24
	jne	%g4, %g29, jeq_else.41861
	addi	%g3, %g0, 0
	jmp	jeq_cont.41862
jeq_else.41861:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g20, %g0, 0
	mov	%g3, %g20
	subi	%g1, %g1, 20
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 20
	jne	%g3, %g0, jeq_else.41863
	ld	%g3, %g1, 4
	ld	%g4, %g3, -28
	jne	%g4, %g29, jeq_else.41865
	addi	%g3, %g0, 0
	jmp	jeq_cont.41866
jeq_else.41865:
	slli	%g4, %g4, 2
	add	%g26, %g19, %g4
	ld	%g4, %g26, 0
	addi	%g19, %g0, 0
	mov	%g3, %g19
	subi	%g1, %g1, 20
	call	shadow_check_and_group.2837
	addi	%g1, %g1, 20
	jne	%g3, %g0, jeq_else.41867
	addi	%g3, %g0, 8
	ld	%g4, %g1, 4
	subi	%g1, %g1, 20
	call	shadow_check_one_or_group.2840
	addi	%g1, %g1, 20
	jmp	jeq_cont.41868
jeq_else.41867:
	addi	%g3, %g0, 1
jeq_cont.41868:
jeq_cont.41866:
	jmp	jeq_cont.41864
jeq_else.41863:
	addi	%g3, %g0, 1
jeq_cont.41864:
jeq_cont.41862:
	jmp	jeq_cont.41860
jeq_else.41859:
	addi	%g3, %g0, 1
jeq_cont.41860:
jeq_cont.41858:
	jmp	jeq_cont.41856
jeq_else.41855:
	addi	%g3, %g0, 1
jeq_cont.41856:
jeq_cont.41854:
	jmp	jeq_cont.41852
jeq_else.41851:
	addi	%g3, %g0, 1
jeq_cont.41852:
jeq_cont.41850:
	jmp	jeq_cont.41848
jeq_else.41847:
	addi	%g3, %g0, 1
jeq_cont.41848:
jeq_cont.41846:
	jmp	jeq_cont.41844
jeq_else.41843:
	addi	%g3, %g0, 1
jeq_cont.41844:
jeq_cont.41842:
	jne	%g3, %g0, jeq_else.41869
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	ld	%g4, %g1, 8
	jmp	shadow_check_one_or_matrix.2843
jeq_else.41869:
	addi	%g3, %g0, 1
	return
solve_each_element.2846:
	ld	%g10, %g31, 820
	ld	%g11, %g31, 744
	ld	%g12, %g31, 792
	ld	%g13, %g31, 784
	ld	%g14, %g31, 780
	ld	%g15, %g31, 776
	ld	%g16, %g31, 788
	slli	%g17, %g3, 2
	add	%g26, %g4, %g17
	ld	%g17, %g26, 0
	jne	%g17, %g29, jeq_else.41870
	return
jeq_else.41870:
	slli	%g18, %g17, 2
	add	%g26, %g10, %g18
	ld	%g18, %g26, 0
	fld	%f0, %g11, 0
	ld	%g19, %g18, -20
	fld	%f1, %g19, 0
	fsub	%f0, %f0, %f1
	fld	%f1, %g11, -4
	fld	%f10, %g19, -4
	fsub	%f1, %f1, %f10
	fld	%f10, %g11, -8
	fld	%f11, %g19, -8
	fsub	%f10, %f10, %f11
	ld	%g19, %g18, -4
	jne	%g19, %g28, jeq_else.41872
	fld	%f2, %g5, 0
	fmov	%f11, %f16
	fjeq	%f2, %f11, fjne_else.41874
	ld	%g19, %g18, -16
	ld	%g20, %g18, -24
	fjlt	%f2, %f11, fjge_else.41876
	addi	%g21, %g0, 0
	jmp	fjge_cont.41877
fjge_else.41876:
	addi	%g21, %g0, 1
fjge_cont.41877:
	fld	%f12, %g19, 0
	jne	%g20, %g21, jeq_else.41878
	fneg	%f12, %f12
	jmp	jeq_cont.41879
jeq_else.41878:
jeq_cont.41879:
	fsub	%f12, %f12, %f0
	fdiv	%f2, %f12, %f2
	fld	%f12, %g5, -4
	fmul	%f12, %f2, %f12
	fadd	%f12, %f12, %f1
	fjlt	%f12, %f11, fjge_else.41880
	jmp	fjge_cont.41881
fjge_else.41880:
	fneg	%f12, %f12
fjge_cont.41881:
	fld	%f13, %g19, -4
	fjlt	%f12, %f13, fjge_else.41882
	addi	%g19, %g0, 0
	jmp	fjge_cont.41883
fjge_else.41882:
	fld	%f12, %g5, -8
	fmul	%f12, %f2, %f12
	fadd	%f12, %f12, %f10
	fjlt	%f12, %f11, fjge_else.41884
	jmp	fjge_cont.41885
fjge_else.41884:
	fneg	%f12, %f12
fjge_cont.41885:
	fld	%f13, %g19, -8
	fjlt	%f12, %f13, fjge_else.41886
	addi	%g19, %g0, 0
	jmp	fjge_cont.41887
fjge_else.41886:
	fst	%f2, %g12, 0
	addi	%g19, %g0, 1
fjge_cont.41887:
fjge_cont.41883:
	jmp	fjne_cont.41875
fjne_else.41874:
	addi	%g19, %g0, 0
fjne_cont.41875:
	jne	%g19, %g0, jeq_else.41888
	fld	%f2, %g5, -4
	fjeq	%f2, %f11, fjne_else.41890
	ld	%g19, %g18, -16
	ld	%g20, %g18, -24
	fjlt	%f2, %f11, fjge_else.41892
	addi	%g21, %g0, 0
	jmp	fjge_cont.41893
fjge_else.41892:
	addi	%g21, %g0, 1
fjge_cont.41893:
	fld	%f12, %g19, -4
	jne	%g20, %g21, jeq_else.41894
	fneg	%f12, %f12
	jmp	jeq_cont.41895
jeq_else.41894:
jeq_cont.41895:
	fsub	%f12, %f12, %f1
	fdiv	%f2, %f12, %f2
	fld	%f12, %g5, -8
	fmul	%f12, %f2, %f12
	fadd	%f12, %f12, %f10
	fjlt	%f12, %f11, fjge_else.41896
	jmp	fjge_cont.41897
fjge_else.41896:
	fneg	%f12, %f12
fjge_cont.41897:
	fld	%f13, %g19, -8
	fjlt	%f12, %f13, fjge_else.41898
	addi	%g19, %g0, 0
	jmp	fjge_cont.41899
fjge_else.41898:
	fld	%f12, %g5, 0
	fmul	%f12, %f2, %f12
	fadd	%f12, %f12, %f0
	fjlt	%f12, %f11, fjge_else.41900
	jmp	fjge_cont.41901
fjge_else.41900:
	fneg	%f12, %f12
fjge_cont.41901:
	fld	%f13, %g19, 0
	fjlt	%f12, %f13, fjge_else.41902
	addi	%g19, %g0, 0
	jmp	fjge_cont.41903
fjge_else.41902:
	fst	%f2, %g12, 0
	addi	%g19, %g0, 1
fjge_cont.41903:
fjge_cont.41899:
	jmp	fjne_cont.41891
fjne_else.41890:
	addi	%g19, %g0, 0
fjne_cont.41891:
	jne	%g19, %g0, jeq_else.41904
	fld	%f2, %g5, -8
	fjeq	%f2, %f11, fjne_else.41906
	ld	%g19, %g18, -16
	ld	%g18, %g18, -24
	fjlt	%f2, %f11, fjge_else.41908
	addi	%g20, %g0, 0
	jmp	fjge_cont.41909
fjge_else.41908:
	addi	%g20, %g0, 1
fjge_cont.41909:
	fld	%f12, %g19, -8
	jne	%g18, %g20, jeq_else.41910
	fneg	%f12, %f12
	jmp	jeq_cont.41911
jeq_else.41910:
jeq_cont.41911:
	fsub	%f10, %f12, %f10
	fdiv	%f2, %f10, %f2
	fld	%f10, %g5, 0
	fmul	%f10, %f2, %f10
	fadd	%f0, %f10, %f0
	fjlt	%f0, %f11, fjge_else.41912
	jmp	fjge_cont.41913
fjge_else.41912:
	fneg	%f0, %f0
fjge_cont.41913:
	fld	%f10, %g19, 0
	fjlt	%f0, %f10, fjge_else.41914
	addi	%g18, %g0, 0
	jmp	fjge_cont.41915
fjge_else.41914:
	fld	%f0, %g5, -4
	fmul	%f0, %f2, %f0
	fadd	%f0, %f0, %f1
	fjlt	%f0, %f11, fjge_else.41916
	jmp	fjge_cont.41917
fjge_else.41916:
	fneg	%f0, %f0
fjge_cont.41917:
	fld	%f1, %g19, -4
	fjlt	%f0, %f1, fjge_else.41918
	addi	%g18, %g0, 0
	jmp	fjge_cont.41919
fjge_else.41918:
	fst	%f2, %g12, 0
	addi	%g18, %g0, 1
fjge_cont.41919:
fjge_cont.41915:
	jmp	fjne_cont.41907
fjne_else.41906:
	addi	%g18, %g0, 0
fjne_cont.41907:
	jne	%g18, %g0, jeq_else.41920
	addi	%g18, %g0, 0
	jmp	jeq_cont.41921
jeq_else.41920:
	addi	%g18, %g0, 3
jeq_cont.41921:
	jmp	jeq_cont.41905
jeq_else.41904:
	addi	%g18, %g0, 2
jeq_cont.41905:
	jmp	jeq_cont.41889
jeq_else.41888:
	addi	%g18, %g0, 1
jeq_cont.41889:
	jmp	jeq_cont.41873
jeq_else.41872:
	addi	%g20, %g0, 2
	jne	%g19, %g20, jeq_else.41922
	ld	%g18, %g18, -16
	fld	%f2, %g5, 0
	fld	%f11, %g18, 0
	fmul	%f2, %f2, %f11
	fld	%f12, %g5, -4
	fld	%f13, %g18, -4
	fmul	%f12, %f12, %f13
	fadd	%f2, %f2, %f12
	fld	%f12, %g5, -8
	fld	%f14, %g18, -8
	fmul	%f12, %f12, %f14
	fadd	%f2, %f2, %f12
	fmov	%f12, %f16
	fjlt	%f12, %f2, fjge_else.41924
	addi	%g18, %g0, 0
	jmp	fjge_cont.41925
fjge_else.41924:
	fmul	%f0, %f11, %f0
	fmul	%f1, %f13, %f1
	fadd	%f0, %f0, %f1
	fmul	%f1, %f14, %f10
	fadd	%f0, %f0, %f1
	fneg	%f0, %f0
	fdiv	%f0, %f0, %f2
	fst	%f0, %g12, 0
	addi	%g18, %g0, 1
fjge_cont.41925:
	jmp	jeq_cont.41923
jeq_else.41922:
	fld	%f11, %g5, 0
	fld	%f12, %g5, -4
	fld	%f13, %g5, -8
	fmul	%f14, %f11, %f11
	ld	%g20, %g18, -16
	fld	%f15, %g20, 0
	fmul	%f14, %f14, %f15
	fmul	%f2, %f12, %f12
	fld	%f3, %g20, -4
	fmul	%f2, %f2, %f3
	fadd	%f14, %f14, %f2
	fmul	%f2, %f13, %f13
	fld	%f4, %g20, -8
	fmul	%f2, %f2, %f4
	fadd	%f14, %f14, %f2
	ld	%g20, %g18, -12
	jne	%g20, %g0, jeq_else.41926
	jmp	jeq_cont.41927
jeq_else.41926:
	fmul	%f2, %f12, %f13
	ld	%g21, %g18, -36
	fld	%f5, %g21, 0
	fmul	%f2, %f2, %f5
	fadd	%f14, %f14, %f2
	fmul	%f2, %f13, %f11
	fld	%f5, %g21, -4
	fmul	%f2, %f2, %f5
	fadd	%f14, %f14, %f2
	fmul	%f2, %f11, %f12
	fld	%f5, %g21, -8
	fmul	%f2, %f2, %f5
	fadd	%f14, %f14, %f2
jeq_cont.41927:
	fmov	%f2, %f16
	fjeq	%f14, %f2, fjne_else.41928
	fmul	%f5, %f11, %f0
	fmul	%f5, %f5, %f15
	fmul	%f6, %f12, %f1
	fmul	%f6, %f6, %f3
	fadd	%f5, %f5, %f6
	fmul	%f6, %f13, %f10
	fmul	%f6, %f6, %f4
	fadd	%f5, %f5, %f6
	jne	%g20, %g0, jeq_else.41930
	fmov	%f11, %f5
	jmp	jeq_cont.41931
jeq_else.41930:
	fmul	%f6, %f13, %f1
	fmul	%f7, %f12, %f10
	fadd	%f6, %f6, %f7
	ld	%g21, %g18, -36
	fld	%f7, %g21, 0
	fmul	%f6, %f6, %f7
	fmul	%f7, %f11, %f10
	fmul	%f13, %f13, %f0
	fadd	%f13, %f7, %f13
	fld	%f7, %g21, -4
	fmul	%f13, %f13, %f7
	fadd	%f13, %f6, %f13
	fmul	%f11, %f11, %f1
	fmul	%f12, %f12, %f0
	fadd	%f11, %f11, %f12
	fld	%f12, %g21, -8
	fmul	%f11, %f11, %f12
	fadd	%f11, %f13, %f11
	fmov	%f12, %f19
	fmul	%f11, %f11, %f12
	fadd	%f11, %f5, %f11
jeq_cont.41931:
	fmul	%f12, %f0, %f0
	fmul	%f12, %f12, %f15
	fmul	%f13, %f1, %f1
	fmul	%f13, %f13, %f3
	fadd	%f12, %f12, %f13
	fmul	%f13, %f10, %f10
	fmul	%f13, %f13, %f4
	fadd	%f12, %f12, %f13
	jne	%g20, %g0, jeq_else.41932
	fmov	%f0, %f12
	jmp	jeq_cont.41933
jeq_else.41932:
	fmul	%f13, %f1, %f10
	ld	%g20, %g18, -36
	fld	%f15, %g20, 0
	fmul	%f13, %f13, %f15
	fadd	%f12, %f12, %f13
	fmul	%f10, %f10, %f0
	fld	%f13, %g20, -4
	fmul	%f10, %f10, %f13
	fadd	%f10, %f12, %f10
	fmul	%f0, %f0, %f1
	fld	%f1, %g20, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f10, %f0
jeq_cont.41933:
	addi	%g20, %g0, 3
	jne	%g19, %g20, jeq_else.41934
	fmov	%f1, %f17
	fsub	%f0, %f0, %f1
	jmp	jeq_cont.41935
jeq_else.41934:
jeq_cont.41935:
	fmul	%f1, %f11, %f11
	fmul	%f0, %f14, %f0
	fsub	%f0, %f1, %f0
	fjlt	%f2, %f0, fjge_else.41936
	addi	%g18, %g0, 0
	jmp	fjge_cont.41937
fjge_else.41936:
	fsqrt	%f0, %f0
	ld	%g18, %g18, -24
	jne	%g18, %g0, jeq_else.41938
	fneg	%f0, %f0
	jmp	jeq_cont.41939
jeq_else.41938:
jeq_cont.41939:
	fsub	%f0, %f0, %f11
	fdiv	%f0, %f0, %f14
	fst	%f0, %g12, 0
	addi	%g18, %g0, 1
fjge_cont.41937:
	jmp	fjne_cont.41929
fjne_else.41928:
	addi	%g18, %g0, 0
fjne_cont.41929:
jeq_cont.41923:
jeq_cont.41873:
	jne	%g18, %g0, jeq_else.41940
	slli	%g6, %g17, 2
	add	%g26, %g10, %g6
	ld	%g6, %g26, 0
	ld	%g6, %g6, -24
	jne	%g6, %g0, jeq_else.41941
	return
jeq_else.41941:
	addi	%g3, %g3, 1
	jmp	solve_each_element.2846
jeq_else.41940:
	fld	%f0, %g12, 0
	fmov	%f1, %f16
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g3, %g1, 8
	fjlt	%f1, %f0, fjge_else.41943
	jmp	fjge_cont.41944
fjge_else.41943:
	fld	%f1, %g13, 0
	fjlt	%f0, %f1, fjge_else.41945
	jmp	fjge_cont.41946
fjge_else.41945:
	setL %g10, l.35938
	fld	%f1, %g10, 0
	fadd	%f0, %f0, %f1
	fld	%f1, %g5, 0
	fmul	%f1, %f1, %f0
	fld	%f2, %g11, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g5, -4
	fmul	%f2, %f2, %f0
	fld	%f10, %g11, -4
	fadd	%f2, %f2, %f10
	fld	%f10, %g5, -8
	fmul	%f10, %f10, %f0
	fld	%f11, %g11, -8
	fadd	%f10, %f10, %f11
	addi	%g10, %g0, 0
	fst	%f2, %g1, 12
	fst	%f1, %g1, 16
	fst	%f0, %g1, 20
	mov	%g3, %g10
	fmov	%f0, %f1
	fmov	%f1, %f2
	fmov	%f2, %f10
	subi	%g1, %g1, 28
	call	check_all_inside.2831
	addi	%g1, %g1, 28
	jne	%g3, %g0, jeq_else.41947
	jmp	jeq_cont.41948
jeq_else.41947:
	fld	%f0, %g1, 20
	fst	%f0, %g13, 0
	fld	%f0, %g1, 16
	fst	%f0, %g14, 0
	fld	%f0, %g1, 12
	fst	%f0, %g14, -4
	fst	%f10, %g14, -8
	st	%g17, %g15, 0
	st	%g18, %g16, 0
jeq_cont.41948:
fjge_cont.41946:
fjge_cont.41944:
	ld	%g3, %g1, 8
	addi	%g3, %g3, 1
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	jmp	solve_each_element.2846
solve_one_or_network.2850:
	ld	%g22, %g31, 800
	slli	%g23, %g3, 2
	add	%g26, %g4, %g23
	ld	%g23, %g26, 0
	jne	%g23, %g29, jeq_else.41949
	return
jeq_else.41949:
	slli	%g23, %g23, 2
	add	%g26, %g22, %g23
	ld	%g23, %g26, 0
	addi	%g24, %g0, 0
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g3, %g1, 8
	mov	%g4, %g23
	mov	%g3, %g24
	subi	%g1, %g1, 16
	call	solve_each_element.2846
	addi	%g1, %g1, 16
	ld	%g3, %g1, 8
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 4
	add	%g26, %g5, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.41951
	return
jeq_else.41951:
	slli	%g4, %g4, 2
	add	%g26, %g22, %g4
	ld	%g4, %g26, 0
	addi	%g23, %g0, 0
	ld	%g24, %g1, 0
	st	%g3, %g1, 12
	mov	%g5, %g24
	mov	%g3, %g23
	subi	%g1, %g1, 20
	call	solve_each_element.2846
	addi	%g1, %g1, 20
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 4
	add	%g26, %g5, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.41953
	return
jeq_else.41953:
	slli	%g4, %g4, 2
	add	%g26, %g22, %g4
	ld	%g4, %g26, 0
	addi	%g23, %g0, 0
	st	%g3, %g1, 16
	mov	%g5, %g24
	mov	%g3, %g23
	subi	%g1, %g1, 24
	call	solve_each_element.2846
	addi	%g1, %g1, 24
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 4
	add	%g26, %g5, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.41955
	return
jeq_else.41955:
	slli	%g4, %g4, 2
	add	%g26, %g22, %g4
	ld	%g4, %g26, 0
	addi	%g23, %g0, 0
	st	%g3, %g1, 20
	mov	%g5, %g24
	mov	%g3, %g23
	subi	%g1, %g1, 28
	call	solve_each_element.2846
	addi	%g1, %g1, 28
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 4
	add	%g26, %g5, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.41957
	return
jeq_else.41957:
	slli	%g4, %g4, 2
	add	%g26, %g22, %g4
	ld	%g4, %g26, 0
	addi	%g23, %g0, 0
	st	%g3, %g1, 24
	mov	%g5, %g24
	mov	%g3, %g23
	subi	%g1, %g1, 32
	call	solve_each_element.2846
	addi	%g1, %g1, 32
	ld	%g3, %g1, 24
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 4
	add	%g26, %g5, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.41959
	return
jeq_else.41959:
	slli	%g4, %g4, 2
	add	%g26, %g22, %g4
	ld	%g4, %g26, 0
	addi	%g23, %g0, 0
	st	%g3, %g1, 28
	mov	%g5, %g24
	mov	%g3, %g23
	subi	%g1, %g1, 36
	call	solve_each_element.2846
	addi	%g1, %g1, 36
	ld	%g3, %g1, 28
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 4
	add	%g26, %g5, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.41961
	return
jeq_else.41961:
	slli	%g4, %g4, 2
	add	%g26, %g22, %g4
	ld	%g4, %g26, 0
	addi	%g23, %g0, 0
	st	%g3, %g1, 32
	mov	%g5, %g24
	mov	%g3, %g23
	subi	%g1, %g1, 40
	call	solve_each_element.2846
	addi	%g1, %g1, 40
	ld	%g3, %g1, 32
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 4
	add	%g26, %g5, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.41963
	return
jeq_else.41963:
	slli	%g4, %g4, 2
	add	%g26, %g22, %g4
	ld	%g4, %g26, 0
	addi	%g22, %g0, 0
	st	%g3, %g1, 36
	mov	%g5, %g24
	mov	%g3, %g22
	subi	%g1, %g1, 44
	call	solve_each_element.2846
	addi	%g1, %g1, 44
	ld	%g3, %g1, 36
	addi	%g3, %g3, 1
	ld	%g4, %g1, 4
	mov	%g5, %g24
	jmp	solve_one_or_network.2850
trace_or_matrix.2854:
	ld	%g22, %g31, 800
	ld	%g23, %g31, 820
	ld	%g24, %g31, 744
	ld	%g25, %g31, 792
	ld	%g8, %g31, 784
	slli	%g9, %g3, 2
	add	%g26, %g4, %g9
	ld	%g9, %g26, 0
	ld	%g10, %g9, 0
	jne	%g10, %g29, jeq_else.41965
	return
jeq_else.41965:
	addi	%g11, %g0, 99
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g3, %g1, 8
	jne	%g10, %g11, jeq_else.41967
	ld	%g23, %g9, -4
	jne	%g23, %g29, jeq_else.41969
	jmp	jeq_cont.41970
jeq_else.41969:
	slli	%g23, %g23, 2
	add	%g26, %g22, %g23
	ld	%g23, %g26, 0
	addi	%g24, %g0, 0
	mov	%g4, %g23
	mov	%g3, %g24
	subi	%g1, %g1, 16
	call	solve_each_element.2846
	addi	%g1, %g1, 16
	ld	%g3, %g9, -8
	jne	%g3, %g29, jeq_else.41971
	jmp	jeq_cont.41972
jeq_else.41971:
	slli	%g3, %g3, 2
	add	%g26, %g22, %g3
	ld	%g3, %g26, 0
	addi	%g4, %g0, 0
	ld	%g5, %g1, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	solve_each_element.2846
	addi	%g1, %g1, 16
	ld	%g3, %g9, -12
	jne	%g3, %g29, jeq_else.41973
	jmp	jeq_cont.41974
jeq_else.41973:
	slli	%g3, %g3, 2
	add	%g26, %g22, %g3
	ld	%g3, %g26, 0
	addi	%g4, %g0, 0
	ld	%g5, %g1, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	solve_each_element.2846
	addi	%g1, %g1, 16
	ld	%g3, %g9, -16
	jne	%g3, %g29, jeq_else.41975
	jmp	jeq_cont.41976
jeq_else.41975:
	slli	%g3, %g3, 2
	add	%g26, %g22, %g3
	ld	%g3, %g26, 0
	addi	%g4, %g0, 0
	ld	%g5, %g1, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	solve_each_element.2846
	addi	%g1, %g1, 16
	ld	%g3, %g9, -20
	jne	%g3, %g29, jeq_else.41977
	jmp	jeq_cont.41978
jeq_else.41977:
	slli	%g3, %g3, 2
	add	%g26, %g22, %g3
	ld	%g3, %g26, 0
	addi	%g4, %g0, 0
	ld	%g5, %g1, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	solve_each_element.2846
	addi	%g1, %g1, 16
	ld	%g3, %g9, -24
	jne	%g3, %g29, jeq_else.41979
	jmp	jeq_cont.41980
jeq_else.41979:
	slli	%g3, %g3, 2
	add	%g26, %g22, %g3
	ld	%g3, %g26, 0
	addi	%g4, %g0, 0
	ld	%g5, %g1, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	solve_each_element.2846
	addi	%g1, %g1, 16
	ld	%g3, %g9, -28
	jne	%g3, %g29, jeq_else.41981
	jmp	jeq_cont.41982
jeq_else.41981:
	slli	%g3, %g3, 2
	add	%g26, %g22, %g3
	ld	%g3, %g26, 0
	addi	%g4, %g0, 0
	ld	%g5, %g1, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	solve_each_element.2846
	addi	%g1, %g1, 16
	addi	%g3, %g0, 8
	ld	%g4, %g1, 0
	mov	%g5, %g4
	mov	%g4, %g9
	subi	%g1, %g1, 16
	call	solve_one_or_network.2850
	addi	%g1, %g1, 16
jeq_cont.41982:
jeq_cont.41980:
jeq_cont.41978:
jeq_cont.41976:
jeq_cont.41974:
jeq_cont.41972:
jeq_cont.41970:
	jmp	jeq_cont.41968
jeq_else.41967:
	slli	%g10, %g10, 2
	add	%g26, %g23, %g10
	ld	%g10, %g26, 0
	fld	%f0, %g24, 0
	ld	%g11, %g10, -20
	fld	%f1, %g11, 0
	fsub	%f0, %f0, %f1
	fld	%f1, %g24, -4
	fld	%f10, %g11, -4
	fsub	%f1, %f1, %f10
	fld	%f10, %g24, -8
	fld	%f11, %g11, -8
	fsub	%f10, %f10, %f11
	ld	%g11, %g10, -4
	jne	%g11, %g28, jeq_else.41983
	fld	%f9, %g5, 0
	fmov	%f2, %f16
	fjeq	%f9, %f2, fjne_else.41985
	ld	%g23, %g10, -16
	ld	%g24, %g10, -24
	fjlt	%f9, %f2, fjge_else.41987
	addi	%g6, %g0, 0
	jmp	fjge_cont.41988
fjge_else.41987:
	addi	%g6, %g0, 1
fjge_cont.41988:
	fld	%f3, %g23, 0
	jne	%g24, %g6, jeq_else.41989
	fneg	%f3, %f3
	jmp	jeq_cont.41990
jeq_else.41989:
jeq_cont.41990:
	fsub	%f3, %f3, %f0
	fdiv	%f9, %f3, %f9
	fld	%f3, %g5, -4
	fmul	%f3, %f9, %f3
	fadd	%f3, %f3, %f1
	fjlt	%f3, %f2, fjge_else.41991
	jmp	fjge_cont.41992
fjge_else.41991:
	fneg	%f3, %f3
fjge_cont.41992:
	fld	%f4, %g23, -4
	fjlt	%f3, %f4, fjge_else.41993
	addi	%g23, %g0, 0
	jmp	fjge_cont.41994
fjge_else.41993:
	fld	%f3, %g5, -8
	fmul	%f3, %f9, %f3
	fadd	%f3, %f3, %f10
	fjlt	%f3, %f2, fjge_else.41995
	jmp	fjge_cont.41996
fjge_else.41995:
	fneg	%f3, %f3
fjge_cont.41996:
	fld	%f4, %g23, -8
	fjlt	%f3, %f4, fjge_else.41997
	addi	%g23, %g0, 0
	jmp	fjge_cont.41998
fjge_else.41997:
	fst	%f9, %g25, 0
	addi	%g23, %g0, 1
fjge_cont.41998:
fjge_cont.41994:
	jmp	fjne_cont.41986
fjne_else.41985:
	addi	%g23, %g0, 0
fjne_cont.41986:
	jne	%g23, %g0, jeq_else.41999
	fld	%f9, %g5, -4
	fjeq	%f9, %f2, fjne_else.42001
	ld	%g23, %g10, -16
	ld	%g24, %g10, -24
	fjlt	%f9, %f2, fjge_else.42003
	addi	%g6, %g0, 0
	jmp	fjge_cont.42004
fjge_else.42003:
	addi	%g6, %g0, 1
fjge_cont.42004:
	fld	%f3, %g23, -4
	jne	%g24, %g6, jeq_else.42005
	fneg	%f3, %f3
	jmp	jeq_cont.42006
jeq_else.42005:
jeq_cont.42006:
	fsub	%f3, %f3, %f1
	fdiv	%f9, %f3, %f9
	fld	%f3, %g5, -8
	fmul	%f3, %f9, %f3
	fadd	%f3, %f3, %f10
	fjlt	%f3, %f2, fjge_else.42007
	jmp	fjge_cont.42008
fjge_else.42007:
	fneg	%f3, %f3
fjge_cont.42008:
	fld	%f4, %g23, -8
	fjlt	%f3, %f4, fjge_else.42009
	addi	%g23, %g0, 0
	jmp	fjge_cont.42010
fjge_else.42009:
	fld	%f3, %g5, 0
	fmul	%f3, %f9, %f3
	fadd	%f3, %f3, %f0
	fjlt	%f3, %f2, fjge_else.42011
	jmp	fjge_cont.42012
fjge_else.42011:
	fneg	%f3, %f3
fjge_cont.42012:
	fld	%f4, %g23, 0
	fjlt	%f3, %f4, fjge_else.42013
	addi	%g23, %g0, 0
	jmp	fjge_cont.42014
fjge_else.42013:
	fst	%f9, %g25, 0
	addi	%g23, %g0, 1
fjge_cont.42014:
fjge_cont.42010:
	jmp	fjne_cont.42002
fjne_else.42001:
	addi	%g23, %g0, 0
fjne_cont.42002:
	jne	%g23, %g0, jeq_else.42015
	fld	%f9, %g5, -8
	fjeq	%f9, %f2, fjne_else.42017
	ld	%g23, %g10, -16
	ld	%g24, %g10, -24
	fjlt	%f9, %f2, fjge_else.42019
	addi	%g6, %g0, 0
	jmp	fjge_cont.42020
fjge_else.42019:
	addi	%g6, %g0, 1
fjge_cont.42020:
	fld	%f3, %g23, -8
	jne	%g24, %g6, jeq_else.42021
	fneg	%f3, %f3
	jmp	jeq_cont.42022
jeq_else.42021:
jeq_cont.42022:
	fsub	%f3, %f3, %f10
	fdiv	%f9, %f3, %f9
	fld	%f3, %g5, 0
	fmul	%f3, %f9, %f3
	fadd	%f0, %f3, %f0
	fjlt	%f0, %f2, fjge_else.42023
	jmp	fjge_cont.42024
fjge_else.42023:
	fneg	%f0, %f0
fjge_cont.42024:
	fld	%f3, %g23, 0
	fjlt	%f0, %f3, fjge_else.42025
	addi	%g23, %g0, 0
	jmp	fjge_cont.42026
fjge_else.42025:
	fld	%f0, %g5, -4
	fmul	%f0, %f9, %f0
	fadd	%f0, %f0, %f1
	fjlt	%f0, %f2, fjge_else.42027
	jmp	fjge_cont.42028
fjge_else.42027:
	fneg	%f0, %f0
fjge_cont.42028:
	fld	%f1, %g23, -4
	fjlt	%f0, %f1, fjge_else.42029
	addi	%g23, %g0, 0
	jmp	fjge_cont.42030
fjge_else.42029:
	fst	%f9, %g25, 0
	addi	%g23, %g0, 1
fjge_cont.42030:
fjge_cont.42026:
	jmp	fjne_cont.42018
fjne_else.42017:
	addi	%g23, %g0, 0
fjne_cont.42018:
	jne	%g23, %g0, jeq_else.42031
	addi	%g23, %g0, 0
	jmp	jeq_cont.42032
jeq_else.42031:
	addi	%g23, %g0, 3
jeq_cont.42032:
	jmp	jeq_cont.42016
jeq_else.42015:
	addi	%g23, %g0, 2
jeq_cont.42016:
	jmp	jeq_cont.42000
jeq_else.41999:
	addi	%g23, %g0, 1
jeq_cont.42000:
	jmp	jeq_cont.41984
jeq_else.41983:
	addi	%g12, %g0, 2
	jne	%g11, %g12, jeq_else.42033
	ld	%g23, %g10, -16
	fld	%f9, %g5, 0
	fld	%f2, %g23, 0
	fmul	%f9, %f9, %f2
	fld	%f3, %g5, -4
	fld	%f4, %g23, -4
	fmul	%f3, %f3, %f4
	fadd	%f9, %f9, %f3
	fld	%f3, %g5, -8
	fld	%f5, %g23, -8
	fmul	%f3, %f3, %f5
	fadd	%f9, %f9, %f3
	fmov	%f3, %f16
	fjlt	%f3, %f9, fjge_else.42035
	addi	%g23, %g0, 0
	jmp	fjge_cont.42036
fjge_else.42035:
	fmul	%f0, %f2, %f0
	fmul	%f1, %f4, %f1
	fadd	%f0, %f0, %f1
	fmul	%f1, %f5, %f10
	fadd	%f0, %f0, %f1
	fneg	%f0, %f0
	fdiv	%f9, %f0, %f9
	fst	%f9, %g25, 0
	addi	%g23, %g0, 1
fjge_cont.42036:
	jmp	jeq_cont.42034
jeq_else.42033:
	fld	%f11, %g5, 0
	fld	%f12, %g5, -4
	fld	%f13, %g5, -8
	fmul	%f14, %f11, %f11
	ld	%g12, %g10, -16
	fld	%f15, %g12, 0
	fmul	%f14, %f14, %f15
	fmul	%f2, %f12, %f12
	fld	%f3, %g12, -4
	fmul	%f2, %f2, %f3
	fadd	%f14, %f14, %f2
	fmul	%f2, %f13, %f13
	fld	%f4, %g12, -8
	fmul	%f2, %f2, %f4
	fadd	%f14, %f14, %f2
	ld	%g12, %g10, -12
	jne	%g12, %g0, jeq_else.42037
	jmp	jeq_cont.42038
jeq_else.42037:
	fmul	%f2, %f12, %f13
	ld	%g13, %g10, -36
	fld	%f5, %g13, 0
	fmul	%f2, %f2, %f5
	fadd	%f14, %f14, %f2
	fmul	%f2, %f13, %f11
	fld	%f5, %g13, -4
	fmul	%f2, %f2, %f5
	fadd	%f14, %f14, %f2
	fmul	%f2, %f11, %f12
	fld	%f5, %g13, -8
	fmul	%f2, %f2, %f5
	fadd	%f14, %f14, %f2
jeq_cont.42038:
	fmov	%f2, %f16
	fjeq	%f14, %f2, fjne_else.42039
	fmul	%f5, %f11, %f0
	fmul	%f5, %f5, %f15
	fmul	%f6, %f12, %f1
	fmul	%f6, %f6, %f3
	fadd	%f5, %f5, %f6
	fmul	%f6, %f13, %f10
	fmul	%f6, %f6, %f4
	fadd	%f5, %f5, %f6
	jne	%g12, %g0, jeq_else.42041
	fmov	%f11, %f5
	jmp	jeq_cont.42042
jeq_else.42041:
	fmul	%f6, %f13, %f1
	fmul	%f7, %f12, %f10
	fadd	%f6, %f6, %f7
	ld	%g13, %g10, -36
	fld	%f7, %g13, 0
	fmul	%f6, %f6, %f7
	fmul	%f7, %f11, %f10
	fmul	%f13, %f13, %f0
	fadd	%f13, %f7, %f13
	fld	%f7, %g13, -4
	fmul	%f13, %f13, %f7
	fadd	%f13, %f6, %f13
	fmul	%f11, %f11, %f1
	fmul	%f12, %f12, %f0
	fadd	%f11, %f11, %f12
	fld	%f12, %g13, -8
	fmul	%f11, %f11, %f12
	fadd	%f11, %f13, %f11
	fmov	%f12, %f19
	fmul	%f11, %f11, %f12
	fadd	%f11, %f5, %f11
jeq_cont.42042:
	fmul	%f12, %f0, %f0
	fmul	%f12, %f12, %f15
	fmul	%f13, %f1, %f1
	fmul	%f13, %f13, %f3
	fadd	%f12, %f12, %f13
	fmul	%f13, %f10, %f10
	fmul	%f13, %f13, %f4
	fadd	%f12, %f12, %f13
	jne	%g12, %g0, jeq_else.42043
	fmov	%f0, %f12
	jmp	jeq_cont.42044
jeq_else.42043:
	fmul	%f13, %f1, %f10
	ld	%g12, %g10, -36
	fld	%f15, %g12, 0
	fmul	%f13, %f13, %f15
	fadd	%f12, %f12, %f13
	fmul	%f10, %f10, %f0
	fld	%f13, %g12, -4
	fmul	%f10, %f10, %f13
	fadd	%f10, %f12, %f10
	fmul	%f0, %f0, %f1
	fld	%f1, %g12, -8
	fmul	%f0, %f0, %f1
	fadd	%f0, %f10, %f0
jeq_cont.42044:
	addi	%g12, %g0, 3
	jne	%g11, %g12, jeq_else.42045
	fmov	%f1, %f17
	fsub	%f0, %f0, %f1
	jmp	jeq_cont.42046
jeq_else.42045:
jeq_cont.42046:
	fmul	%f1, %f11, %f11
	fmul	%f0, %f14, %f0
	fsub	%f0, %f1, %f0
	fjlt	%f2, %f0, fjge_else.42047
	addi	%g23, %g0, 0
	jmp	fjge_cont.42048
fjge_else.42047:
	fsqrt	%f9, %f0
	ld	%g23, %g10, -24
	jne	%g23, %g0, jeq_else.42049
	fneg	%f9, %f9
	jmp	jeq_cont.42050
jeq_else.42049:
jeq_cont.42050:
	fsub	%f9, %f9, %f11
	fdiv	%f9, %f9, %f14
	fst	%f9, %g25, 0
	addi	%g23, %g0, 1
fjge_cont.42048:
	jmp	fjne_cont.42040
fjne_else.42039:
	addi	%g23, %g0, 0
fjne_cont.42040:
jeq_cont.42034:
jeq_cont.41984:
	jne	%g23, %g0, jeq_else.42051
	jmp	jeq_cont.42052
jeq_else.42051:
	fld	%f9, %g25, 0
	fld	%f0, %g8, 0
	fjlt	%f9, %f0, fjge_else.42053
	jmp	fjge_cont.42054
fjge_else.42053:
	ld	%g23, %g9, -4
	jne	%g23, %g29, jeq_else.42055
	jmp	jeq_cont.42056
jeq_else.42055:
	slli	%g23, %g23, 2
	add	%g26, %g22, %g23
	ld	%g23, %g26, 0
	addi	%g24, %g0, 0
	mov	%g4, %g23
	mov	%g3, %g24
	subi	%g1, %g1, 16
	call	solve_each_element.2846
	addi	%g1, %g1, 16
	ld	%g3, %g9, -8
	jne	%g3, %g29, jeq_else.42057
	jmp	jeq_cont.42058
jeq_else.42057:
	slli	%g3, %g3, 2
	add	%g26, %g22, %g3
	ld	%g3, %g26, 0
	addi	%g4, %g0, 0
	ld	%g5, %g1, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	solve_each_element.2846
	addi	%g1, %g1, 16
	ld	%g3, %g9, -12
	jne	%g3, %g29, jeq_else.42059
	jmp	jeq_cont.42060
jeq_else.42059:
	slli	%g3, %g3, 2
	add	%g26, %g22, %g3
	ld	%g3, %g26, 0
	addi	%g4, %g0, 0
	ld	%g5, %g1, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	solve_each_element.2846
	addi	%g1, %g1, 16
	ld	%g3, %g9, -16
	jne	%g3, %g29, jeq_else.42061
	jmp	jeq_cont.42062
jeq_else.42061:
	slli	%g3, %g3, 2
	add	%g26, %g22, %g3
	ld	%g3, %g26, 0
	addi	%g4, %g0, 0
	ld	%g5, %g1, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	solve_each_element.2846
	addi	%g1, %g1, 16
	ld	%g3, %g9, -20
	jne	%g3, %g29, jeq_else.42063
	jmp	jeq_cont.42064
jeq_else.42063:
	slli	%g3, %g3, 2
	add	%g26, %g22, %g3
	ld	%g3, %g26, 0
	addi	%g4, %g0, 0
	ld	%g5, %g1, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	solve_each_element.2846
	addi	%g1, %g1, 16
	ld	%g3, %g9, -24
	jne	%g3, %g29, jeq_else.42065
	jmp	jeq_cont.42066
jeq_else.42065:
	slli	%g3, %g3, 2
	add	%g26, %g22, %g3
	ld	%g3, %g26, 0
	addi	%g4, %g0, 0
	ld	%g5, %g1, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	solve_each_element.2846
	addi	%g1, %g1, 16
	ld	%g3, %g9, -28
	jne	%g3, %g29, jeq_else.42067
	jmp	jeq_cont.42068
jeq_else.42067:
	slli	%g3, %g3, 2
	add	%g26, %g22, %g3
	ld	%g3, %g26, 0
	addi	%g4, %g0, 0
	ld	%g5, %g1, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	solve_each_element.2846
	addi	%g1, %g1, 16
	addi	%g3, %g0, 8
	ld	%g4, %g1, 0
	mov	%g5, %g4
	mov	%g4, %g9
	subi	%g1, %g1, 16
	call	solve_one_or_network.2850
	addi	%g1, %g1, 16
jeq_cont.42068:
jeq_cont.42066:
jeq_cont.42064:
jeq_cont.42062:
jeq_cont.42060:
jeq_cont.42058:
jeq_cont.42056:
fjge_cont.42054:
jeq_cont.42052:
jeq_cont.41968:
	ld	%g3, %g1, 8
	addi	%g3, %g3, 1
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	jmp	trace_or_matrix.2854
solve_each_element_fast.2860:
	ld	%g10, %g31, 820
	ld	%g11, %g31, 792
	ld	%g12, %g31, 784
	ld	%g13, %g31, 740
	ld	%g14, %g31, 780
	ld	%g15, %g31, 776
	ld	%g16, %g31, 788
	ld	%g17, %g5, 0
	slli	%g18, %g3, 2
	add	%g26, %g4, %g18
	ld	%g18, %g26, 0
	jne	%g18, %g29, jeq_else.42069
	return
jeq_else.42069:
	slli	%g19, %g18, 2
	add	%g26, %g10, %g19
	ld	%g19, %g26, 0
	ld	%g20, %g19, -40
	fld	%f0, %g20, 0
	fld	%f1, %g20, -4
	fld	%f10, %g20, -8
	ld	%g21, %g5, -4
	slli	%g22, %g18, 2
	add	%g26, %g21, %g22
	ld	%g21, %g26, 0
	ld	%g22, %g19, -4
	jne	%g22, %g28, jeq_else.42071
	fld	%f2, %g21, 0
	fsub	%f2, %f2, %f0
	fld	%f11, %g21, -4
	fmul	%f2, %f2, %f11
	fld	%f12, %g17, -4
	fmul	%f12, %f2, %f12
	fadd	%f12, %f12, %f1
	fmov	%f13, %f16
	fjlt	%f12, %f13, fjge_else.42073
	jmp	fjge_cont.42074
fjge_else.42073:
	fneg	%f12, %f12
fjge_cont.42074:
	ld	%g19, %g19, -16
	fld	%f14, %g19, -4
	fjlt	%f12, %f14, fjge_else.42075
	addi	%g20, %g0, 0
	jmp	fjge_cont.42076
fjge_else.42075:
	fld	%f12, %g17, -8
	fmul	%f12, %f2, %f12
	fadd	%f12, %f12, %f10
	fjlt	%f12, %f13, fjge_else.42077
	jmp	fjge_cont.42078
fjge_else.42077:
	fneg	%f12, %f12
fjge_cont.42078:
	fld	%f14, %g19, -8
	fjlt	%f12, %f14, fjge_else.42079
	addi	%g20, %g0, 0
	jmp	fjge_cont.42080
fjge_else.42079:
	fjeq	%f11, %f13, fjne_else.42081
	addi	%g20, %g0, 1
	jmp	fjne_cont.42082
fjne_else.42081:
	addi	%g20, %g0, 0
fjne_cont.42082:
fjge_cont.42080:
fjge_cont.42076:
	jne	%g20, %g0, jeq_else.42083
	fld	%f2, %g21, -8
	fsub	%f2, %f2, %f1
	fld	%f11, %g21, -12
	fmul	%f2, %f2, %f11
	fld	%f12, %g17, 0
	fmul	%f12, %f2, %f12
	fadd	%f12, %f12, %f0
	fjlt	%f12, %f13, fjge_else.42085
	jmp	fjge_cont.42086
fjge_else.42085:
	fneg	%f12, %f12
fjge_cont.42086:
	fld	%f14, %g19, 0
	fjlt	%f12, %f14, fjge_else.42087
	addi	%g20, %g0, 0
	jmp	fjge_cont.42088
fjge_else.42087:
	fld	%f12, %g17, -8
	fmul	%f12, %f2, %f12
	fadd	%f12, %f12, %f10
	fjlt	%f12, %f13, fjge_else.42089
	jmp	fjge_cont.42090
fjge_else.42089:
	fneg	%f12, %f12
fjge_cont.42090:
	fld	%f14, %g19, -8
	fjlt	%f12, %f14, fjge_else.42091
	addi	%g20, %g0, 0
	jmp	fjge_cont.42092
fjge_else.42091:
	fjeq	%f11, %f13, fjne_else.42093
	addi	%g20, %g0, 1
	jmp	fjne_cont.42094
fjne_else.42093:
	addi	%g20, %g0, 0
fjne_cont.42094:
fjge_cont.42092:
fjge_cont.42088:
	jne	%g20, %g0, jeq_else.42095
	fld	%f2, %g21, -16
	fsub	%f2, %f2, %f10
	fld	%f10, %g21, -20
	fmul	%f2, %f2, %f10
	fld	%f11, %g17, 0
	fmul	%f11, %f2, %f11
	fadd	%f0, %f11, %f0
	fjlt	%f0, %f13, fjge_else.42097
	jmp	fjge_cont.42098
fjge_else.42097:
	fneg	%f0, %f0
fjge_cont.42098:
	fld	%f11, %g19, 0
	fjlt	%f0, %f11, fjge_else.42099
	addi	%g19, %g0, 0
	jmp	fjge_cont.42100
fjge_else.42099:
	fld	%f0, %g17, -4
	fmul	%f0, %f2, %f0
	fadd	%f0, %f0, %f1
	fjlt	%f0, %f13, fjge_else.42101
	jmp	fjge_cont.42102
fjge_else.42101:
	fneg	%f0, %f0
fjge_cont.42102:
	fld	%f1, %g19, -4
	fjlt	%f0, %f1, fjge_else.42103
	addi	%g19, %g0, 0
	jmp	fjge_cont.42104
fjge_else.42103:
	fjeq	%f10, %f13, fjne_else.42105
	addi	%g19, %g0, 1
	jmp	fjne_cont.42106
fjne_else.42105:
	addi	%g19, %g0, 0
fjne_cont.42106:
fjge_cont.42104:
fjge_cont.42100:
	jne	%g19, %g0, jeq_else.42107
	addi	%g19, %g0, 0
	jmp	jeq_cont.42108
jeq_else.42107:
	fst	%f2, %g11, 0
	addi	%g19, %g0, 3
jeq_cont.42108:
	jmp	jeq_cont.42096
jeq_else.42095:
	fst	%f2, %g11, 0
	addi	%g19, %g0, 2
jeq_cont.42096:
	jmp	jeq_cont.42084
jeq_else.42083:
	fst	%f2, %g11, 0
	addi	%g19, %g0, 1
jeq_cont.42084:
	jmp	jeq_cont.42072
jeq_else.42071:
	addi	%g23, %g0, 2
	jne	%g22, %g23, jeq_else.42109
	fld	%f0, %g21, 0
	fmov	%f1, %f16
	fjlt	%f0, %f1, fjge_else.42111
	addi	%g19, %g0, 0
	jmp	fjge_cont.42112
fjge_else.42111:
	fld	%f1, %g20, -12
	fmul	%f0, %f0, %f1
	fst	%f0, %g11, 0
	addi	%g19, %g0, 1
fjge_cont.42112:
	jmp	jeq_cont.42110
jeq_else.42109:
	fld	%f11, %g21, 0
	fmov	%f12, %f16
	fjeq	%f11, %f12, fjne_else.42113
	fld	%f13, %g21, -4
	fmul	%f0, %f13, %f0
	fld	%f13, %g21, -8
	fmul	%f1, %f13, %f1
	fadd	%f0, %f0, %f1
	fld	%f1, %g21, -12
	fmul	%f1, %f1, %f10
	fadd	%f0, %f0, %f1
	fld	%f1, %g20, -12
	fmul	%f10, %f0, %f0
	fmul	%f1, %f11, %f1
	fsub	%f1, %f10, %f1
	fjlt	%f12, %f1, fjge_else.42115
	addi	%g19, %g0, 0
	jmp	fjge_cont.42116
fjge_else.42115:
	ld	%g19, %g19, -24
	jne	%g19, %g0, jeq_else.42117
	fst	%f0, %g1, 0
	fsqrt	%f0, %f1
	fld	%f1, %g1, 0
	fsub	%f0, %f1, %f0
	fld	%f1, %g21, -16
	fmul	%f0, %f0, %f1
	fst	%f0, %g11, 0
	jmp	jeq_cont.42118
jeq_else.42117:
	fst	%f0, %g1, 0
	fsqrt	%f0, %f1
	fld	%f1, %g1, 0
	fadd	%f0, %f1, %f0
	fld	%f1, %g21, -16
	fmul	%f0, %f0, %f1
	fst	%f0, %g11, 0
jeq_cont.42118:
	addi	%g19, %g0, 1
fjge_cont.42116:
	jmp	fjne_cont.42114
fjne_else.42113:
	addi	%g19, %g0, 0
fjne_cont.42114:
jeq_cont.42110:
jeq_cont.42072:
	jne	%g19, %g0, jeq_else.42119
	slli	%g6, %g18, 2
	add	%g26, %g10, %g6
	ld	%g6, %g26, 0
	ld	%g6, %g6, -24
	jne	%g6, %g0, jeq_else.42120
	return
jeq_else.42120:
	addi	%g3, %g3, 1
	jmp	solve_each_element_fast.2860
jeq_else.42119:
	fld	%f0, %g11, 0
	fmov	%f1, %f16
	st	%g5, %g1, 4
	st	%g4, %g1, 8
	st	%g3, %g1, 12
	fjlt	%f1, %f0, fjge_else.42122
	jmp	fjge_cont.42123
fjge_else.42122:
	fld	%f1, %g12, 0
	fjlt	%f0, %f1, fjge_else.42124
	jmp	fjge_cont.42125
fjge_else.42124:
	setL %g10, l.35938
	fld	%f1, %g10, 0
	fadd	%f0, %f0, %f1
	fld	%f1, %g17, 0
	fmul	%f1, %f1, %f0
	fld	%f2, %g13, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g17, -4
	fmul	%f2, %f2, %f0
	fld	%f10, %g13, -4
	fadd	%f2, %f2, %f10
	fld	%f10, %g17, -8
	fmul	%f10, %f10, %f0
	fld	%f11, %g13, -8
	fadd	%f10, %f10, %f11
	addi	%g10, %g0, 0
	fst	%f2, %g1, 16
	fst	%f1, %g1, 20
	fst	%f0, %g1, 24
	mov	%g3, %g10
	fmov	%f0, %f1
	fmov	%f1, %f2
	fmov	%f2, %f10
	subi	%g1, %g1, 32
	call	check_all_inside.2831
	addi	%g1, %g1, 32
	jne	%g3, %g0, jeq_else.42126
	jmp	jeq_cont.42127
jeq_else.42126:
	fld	%f0, %g1, 24
	fst	%f0, %g12, 0
	fld	%f0, %g1, 20
	fst	%f0, %g14, 0
	fld	%f0, %g1, 16
	fst	%f0, %g14, -4
	fst	%f10, %g14, -8
	st	%g18, %g15, 0
	st	%g19, %g16, 0
jeq_cont.42127:
fjge_cont.42125:
fjge_cont.42123:
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	ld	%g4, %g1, 8
	ld	%g5, %g1, 4
	jmp	solve_each_element_fast.2860
solve_one_or_network_fast.2864:
	ld	%g24, %g31, 800
	slli	%g25, %g3, 2
	add	%g26, %g4, %g25
	ld	%g25, %g26, 0
	jne	%g25, %g29, jeq_else.42128
	return
jeq_else.42128:
	slli	%g25, %g25, 2
	add	%g26, %g24, %g25
	ld	%g25, %g26, 0
	addi	%g8, %g0, 0
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g3, %g1, 8
	mov	%g4, %g25
	mov	%g3, %g8
	subi	%g1, %g1, 16
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 16
	ld	%g3, %g1, 8
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 4
	add	%g26, %g5, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.42130
	return
jeq_else.42130:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g25, %g0, 0
	ld	%g8, %g1, 0
	st	%g3, %g1, 12
	mov	%g5, %g8
	mov	%g3, %g25
	subi	%g1, %g1, 20
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 20
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 4
	add	%g26, %g5, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.42132
	return
jeq_else.42132:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g25, %g0, 0
	st	%g3, %g1, 16
	mov	%g5, %g8
	mov	%g3, %g25
	subi	%g1, %g1, 24
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 24
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 4
	add	%g26, %g5, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.42134
	return
jeq_else.42134:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g25, %g0, 0
	st	%g3, %g1, 20
	mov	%g5, %g8
	mov	%g3, %g25
	subi	%g1, %g1, 28
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 28
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 4
	add	%g26, %g5, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.42136
	return
jeq_else.42136:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g25, %g0, 0
	st	%g3, %g1, 24
	mov	%g5, %g8
	mov	%g3, %g25
	subi	%g1, %g1, 32
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 32
	ld	%g3, %g1, 24
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 4
	add	%g26, %g5, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.42138
	return
jeq_else.42138:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g25, %g0, 0
	st	%g3, %g1, 28
	mov	%g5, %g8
	mov	%g3, %g25
	subi	%g1, %g1, 36
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 36
	ld	%g3, %g1, 28
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 4
	add	%g26, %g5, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.42140
	return
jeq_else.42140:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g25, %g0, 0
	st	%g3, %g1, 32
	mov	%g5, %g8
	mov	%g3, %g25
	subi	%g1, %g1, 40
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 40
	ld	%g3, %g1, 32
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 4
	add	%g26, %g5, %g4
	ld	%g4, %g26, 0
	jne	%g4, %g29, jeq_else.42142
	return
jeq_else.42142:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g24, %g0, 0
	st	%g3, %g1, 36
	mov	%g5, %g8
	mov	%g3, %g24
	subi	%g1, %g1, 44
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 44
	ld	%g3, %g1, 36
	addi	%g3, %g3, 1
	ld	%g4, %g1, 4
	mov	%g5, %g8
	jmp	solve_one_or_network_fast.2864
trace_or_matrix_fast.2868:
	ld	%g24, %g31, 800
	ld	%g25, %g31, 820
	ld	%g8, %g31, 792
	ld	%g9, %g31, 784
	slli	%g10, %g3, 2
	add	%g26, %g4, %g10
	ld	%g10, %g26, 0
	ld	%g11, %g10, 0
	jne	%g11, %g29, jeq_else.42144
	return
jeq_else.42144:
	addi	%g12, %g0, 99
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g3, %g1, 8
	jne	%g11, %g12, jeq_else.42146
	ld	%g25, %g10, -4
	jne	%g25, %g29, jeq_else.42148
	jmp	jeq_cont.42149
jeq_else.42148:
	slli	%g25, %g25, 2
	add	%g26, %g24, %g25
	ld	%g25, %g26, 0
	addi	%g8, %g0, 0
	st	%g10, %g1, 12
	mov	%g4, %g25
	mov	%g3, %g8
	subi	%g1, %g1, 20
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 20
	ld	%g3, %g1, 12
	ld	%g4, %g3, -8
	jne	%g4, %g29, jeq_else.42150
	jmp	jeq_cont.42151
jeq_else.42150:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g5, %g0, 0
	ld	%g25, %g1, 0
	mov	%g3, %g5
	mov	%g5, %g25
	subi	%g1, %g1, 20
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 20
	ld	%g3, %g1, 12
	ld	%g4, %g3, -12
	jne	%g4, %g29, jeq_else.42152
	jmp	jeq_cont.42153
jeq_else.42152:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g5, %g0, 0
	mov	%g3, %g5
	mov	%g5, %g25
	subi	%g1, %g1, 20
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 20
	ld	%g3, %g1, 12
	ld	%g4, %g3, -16
	jne	%g4, %g29, jeq_else.42154
	jmp	jeq_cont.42155
jeq_else.42154:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g5, %g0, 0
	mov	%g3, %g5
	mov	%g5, %g25
	subi	%g1, %g1, 20
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 20
	ld	%g3, %g1, 12
	ld	%g4, %g3, -20
	jne	%g4, %g29, jeq_else.42156
	jmp	jeq_cont.42157
jeq_else.42156:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g5, %g0, 0
	mov	%g3, %g5
	mov	%g5, %g25
	subi	%g1, %g1, 20
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 20
	ld	%g3, %g1, 12
	ld	%g4, %g3, -24
	jne	%g4, %g29, jeq_else.42158
	jmp	jeq_cont.42159
jeq_else.42158:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g5, %g0, 0
	mov	%g3, %g5
	mov	%g5, %g25
	subi	%g1, %g1, 20
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 20
	ld	%g3, %g1, 12
	ld	%g4, %g3, -28
	jne	%g4, %g29, jeq_else.42160
	jmp	jeq_cont.42161
jeq_else.42160:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g5, %g0, 0
	mov	%g3, %g5
	mov	%g5, %g25
	subi	%g1, %g1, 20
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 20
	addi	%g3, %g0, 8
	ld	%g4, %g1, 12
	mov	%g5, %g25
	subi	%g1, %g1, 20
	call	solve_one_or_network_fast.2864
	addi	%g1, %g1, 20
jeq_cont.42161:
jeq_cont.42159:
jeq_cont.42157:
jeq_cont.42155:
jeq_cont.42153:
jeq_cont.42151:
jeq_cont.42149:
	jmp	jeq_cont.42147
jeq_else.42146:
	slli	%g12, %g11, 2
	add	%g26, %g25, %g12
	ld	%g12, %g26, 0
	ld	%g13, %g12, -40
	fld	%f0, %g13, 0
	fld	%f1, %g13, -4
	fld	%f10, %g13, -8
	ld	%g14, %g5, -4
	slli	%g11, %g11, 2
	add	%g26, %g14, %g11
	ld	%g11, %g26, 0
	ld	%g14, %g12, -4
	jne	%g14, %g28, jeq_else.42162
	ld	%g25, %g5, 0
	fld	%f9, %g11, 0
	fsub	%f9, %f9, %f0
	fld	%f2, %g11, -4
	fmul	%f9, %f9, %f2
	fld	%f3, %g25, -4
	fmul	%f3, %f9, %f3
	fadd	%f3, %f3, %f1
	fmov	%f4, %f16
	fjlt	%f3, %f4, fjge_else.42164
	jmp	fjge_cont.42165
fjge_else.42164:
	fneg	%f3, %f3
fjge_cont.42165:
	ld	%g6, %g12, -16
	fld	%f5, %g6, -4
	fjlt	%f3, %f5, fjge_else.42166
	addi	%g7, %g0, 0
	jmp	fjge_cont.42167
fjge_else.42166:
	fld	%f3, %g25, -8
	fmul	%f3, %f9, %f3
	fadd	%f3, %f3, %f10
	fjlt	%f3, %f4, fjge_else.42168
	jmp	fjge_cont.42169
fjge_else.42168:
	fneg	%f3, %f3
fjge_cont.42169:
	fld	%f5, %g6, -8
	fjlt	%f3, %f5, fjge_else.42170
	addi	%g7, %g0, 0
	jmp	fjge_cont.42171
fjge_else.42170:
	fjeq	%f2, %f4, fjne_else.42172
	addi	%g7, %g0, 1
	jmp	fjne_cont.42173
fjne_else.42172:
	addi	%g7, %g0, 0
fjne_cont.42173:
fjge_cont.42171:
fjge_cont.42167:
	jne	%g7, %g0, jeq_else.42174
	fld	%f9, %g11, -8
	fsub	%f9, %f9, %f1
	fld	%f2, %g11, -12
	fmul	%f9, %f9, %f2
	fld	%f3, %g25, 0
	fmul	%f3, %f9, %f3
	fadd	%f3, %f3, %f0
	fjlt	%f3, %f4, fjge_else.42176
	jmp	fjge_cont.42177
fjge_else.42176:
	fneg	%f3, %f3
fjge_cont.42177:
	fld	%f5, %g6, 0
	fjlt	%f3, %f5, fjge_else.42178
	addi	%g7, %g0, 0
	jmp	fjge_cont.42179
fjge_else.42178:
	fld	%f3, %g25, -8
	fmul	%f3, %f9, %f3
	fadd	%f3, %f3, %f10
	fjlt	%f3, %f4, fjge_else.42180
	jmp	fjge_cont.42181
fjge_else.42180:
	fneg	%f3, %f3
fjge_cont.42181:
	fld	%f5, %g6, -8
	fjlt	%f3, %f5, fjge_else.42182
	addi	%g7, %g0, 0
	jmp	fjge_cont.42183
fjge_else.42182:
	fjeq	%f2, %f4, fjne_else.42184
	addi	%g7, %g0, 1
	jmp	fjne_cont.42185
fjne_else.42184:
	addi	%g7, %g0, 0
fjne_cont.42185:
fjge_cont.42183:
fjge_cont.42179:
	jne	%g7, %g0, jeq_else.42186
	fld	%f9, %g11, -16
	fsub	%f9, %f9, %f10
	fld	%f2, %g11, -20
	fmul	%f9, %f9, %f2
	fld	%f3, %g25, 0
	fmul	%f3, %f9, %f3
	fadd	%f0, %f3, %f0
	fjlt	%f0, %f4, fjge_else.42188
	jmp	fjge_cont.42189
fjge_else.42188:
	fneg	%f0, %f0
fjge_cont.42189:
	fld	%f3, %g6, 0
	fjlt	%f0, %f3, fjge_else.42190
	addi	%g25, %g0, 0
	jmp	fjge_cont.42191
fjge_else.42190:
	fld	%f0, %g25, -4
	fmul	%f0, %f9, %f0
	fadd	%f0, %f0, %f1
	fjlt	%f0, %f4, fjge_else.42192
	jmp	fjge_cont.42193
fjge_else.42192:
	fneg	%f0, %f0
fjge_cont.42193:
	fld	%f1, %g6, -4
	fjlt	%f0, %f1, fjge_else.42194
	addi	%g25, %g0, 0
	jmp	fjge_cont.42195
fjge_else.42194:
	fjeq	%f2, %f4, fjne_else.42196
	addi	%g25, %g0, 1
	jmp	fjne_cont.42197
fjne_else.42196:
	addi	%g25, %g0, 0
fjne_cont.42197:
fjge_cont.42195:
fjge_cont.42191:
	jne	%g25, %g0, jeq_else.42198
	addi	%g25, %g0, 0
	jmp	jeq_cont.42199
jeq_else.42198:
	fst	%f9, %g8, 0
	addi	%g25, %g0, 3
jeq_cont.42199:
	jmp	jeq_cont.42187
jeq_else.42186:
	fst	%f9, %g8, 0
	addi	%g25, %g0, 2
jeq_cont.42187:
	jmp	jeq_cont.42175
jeq_else.42174:
	fst	%f9, %g8, 0
	addi	%g25, %g0, 1
jeq_cont.42175:
	jmp	jeq_cont.42163
jeq_else.42162:
	addi	%g15, %g0, 2
	jne	%g14, %g15, jeq_else.42200
	fld	%f9, %g11, 0
	fmov	%f0, %f16
	fjlt	%f9, %f0, fjge_else.42202
	addi	%g25, %g0, 0
	jmp	fjge_cont.42203
fjge_else.42202:
	fld	%f0, %g13, -12
	fmul	%f9, %f9, %f0
	fst	%f9, %g8, 0
	addi	%g25, %g0, 1
fjge_cont.42203:
	jmp	jeq_cont.42201
jeq_else.42200:
	fld	%f11, %g11, 0
	fmov	%f12, %f16
	fjeq	%f11, %f12, fjne_else.42204
	fld	%f13, %g11, -4
	fmul	%f0, %f13, %f0
	fld	%f13, %g11, -8
	fmul	%f1, %f13, %f1
	fadd	%f0, %f0, %f1
	fld	%f1, %g11, -12
	fmul	%f1, %f1, %f10
	fadd	%f0, %f0, %f1
	fld	%f1, %g13, -12
	fmul	%f10, %f0, %f0
	fmul	%f1, %f11, %f1
	fsub	%f1, %f10, %f1
	fjlt	%f12, %f1, fjge_else.42206
	addi	%g25, %g0, 0
	jmp	fjge_cont.42207
fjge_else.42206:
	ld	%g12, %g12, -24
	jne	%g12, %g0, jeq_else.42208
	fst	%f0, %g1, 16
	fsqrt	%f9, %f1
	fld	%f0, %g1, 16
	fsub	%f9, %f0, %f9
	fld	%f0, %g11, -16
	fmul	%f9, %f9, %f0
	fst	%f9, %g8, 0
	jmp	jeq_cont.42209
jeq_else.42208:
	fst	%f0, %g1, 16
	fsqrt	%f9, %f1
	fld	%f0, %g1, 16
	fadd	%f9, %f0, %f9
	fld	%f0, %g11, -16
	fmul	%f9, %f9, %f0
	fst	%f9, %g8, 0
jeq_cont.42209:
	addi	%g25, %g0, 1
fjge_cont.42207:
	jmp	fjne_cont.42205
fjne_else.42204:
	addi	%g25, %g0, 0
fjne_cont.42205:
jeq_cont.42201:
jeq_cont.42163:
	jne	%g25, %g0, jeq_else.42210
	jmp	jeq_cont.42211
jeq_else.42210:
	fld	%f9, %g8, 0
	fld	%f0, %g9, 0
	fjlt	%f9, %f0, fjge_else.42212
	jmp	fjge_cont.42213
fjge_else.42212:
	ld	%g25, %g10, -4
	jne	%g25, %g29, jeq_else.42214
	jmp	jeq_cont.42215
jeq_else.42214:
	slli	%g25, %g25, 2
	add	%g26, %g24, %g25
	ld	%g25, %g26, 0
	addi	%g8, %g0, 0
	st	%g10, %g1, 12
	mov	%g4, %g25
	mov	%g3, %g8
	subi	%g1, %g1, 24
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 24
	ld	%g3, %g1, 12
	ld	%g4, %g3, -8
	jne	%g4, %g29, jeq_else.42216
	jmp	jeq_cont.42217
jeq_else.42216:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g5, %g0, 0
	ld	%g25, %g1, 0
	mov	%g3, %g5
	mov	%g5, %g25
	subi	%g1, %g1, 24
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 24
	ld	%g3, %g1, 12
	ld	%g4, %g3, -12
	jne	%g4, %g29, jeq_else.42218
	jmp	jeq_cont.42219
jeq_else.42218:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g5, %g0, 0
	mov	%g3, %g5
	mov	%g5, %g25
	subi	%g1, %g1, 24
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 24
	ld	%g3, %g1, 12
	ld	%g4, %g3, -16
	jne	%g4, %g29, jeq_else.42220
	jmp	jeq_cont.42221
jeq_else.42220:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g5, %g0, 0
	mov	%g3, %g5
	mov	%g5, %g25
	subi	%g1, %g1, 24
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 24
	ld	%g3, %g1, 12
	ld	%g4, %g3, -20
	jne	%g4, %g29, jeq_else.42222
	jmp	jeq_cont.42223
jeq_else.42222:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g5, %g0, 0
	mov	%g3, %g5
	mov	%g5, %g25
	subi	%g1, %g1, 24
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 24
	ld	%g3, %g1, 12
	ld	%g4, %g3, -24
	jne	%g4, %g29, jeq_else.42224
	jmp	jeq_cont.42225
jeq_else.42224:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g5, %g0, 0
	mov	%g3, %g5
	mov	%g5, %g25
	subi	%g1, %g1, 24
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 24
	ld	%g3, %g1, 12
	ld	%g4, %g3, -28
	jne	%g4, %g29, jeq_else.42226
	jmp	jeq_cont.42227
jeq_else.42226:
	slli	%g4, %g4, 2
	add	%g26, %g24, %g4
	ld	%g4, %g26, 0
	addi	%g5, %g0, 0
	mov	%g3, %g5
	mov	%g5, %g25
	subi	%g1, %g1, 24
	call	solve_each_element_fast.2860
	addi	%g1, %g1, 24
	addi	%g3, %g0, 8
	ld	%g4, %g1, 12
	mov	%g5, %g25
	subi	%g1, %g1, 24
	call	solve_one_or_network_fast.2864
	addi	%g1, %g1, 24
jeq_cont.42227:
jeq_cont.42225:
jeq_cont.42223:
jeq_cont.42221:
jeq_cont.42219:
jeq_cont.42217:
jeq_cont.42215:
fjge_cont.42213:
jeq_cont.42211:
jeq_cont.42147:
	ld	%g3, %g1, 8
	addi	%g3, %g3, 1
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	jmp	trace_or_matrix_fast.2868
utexture.2883:
	ld	%g10, %g31, 768
	ld	%g11, %g3, 0
	ld	%g12, %g3, -32
	fld	%f0, %g12, 0
	fst	%f0, %g10, 0
	fld	%f0, %g12, -4
	fst	%f0, %g10, -4
	fld	%f0, %g12, -8
	fst	%f0, %g10, -8
	jne	%g11, %g28, jeq_else.42228
	fld	%f0, %g4, 0
	ld	%g11, %g3, -20
	fld	%f10, %g11, 0
	fsub	%f0, %f0, %f10
	setL %g12, l.36899
	fld	%f10, %g12, 0
	fmul	%f11, %f0, %f10
	st	%g4, %g1, 0
	fst	%f0, %g1, 4
	fmov	%f0, %f11
	subi	%g1, %g1, 12
	call	min_caml_floor
	addi	%g1, %g1, 12
	setL %g12, l.36901
	fld	%f11, %g12, 0
	fmul	%f0, %f0, %f11
	fld	%f12, %g1, 4
	fsub	%f0, %f12, %f0
	setL %g12, l.36860
	fld	%f12, %g12, 0
	ld	%g12, %g1, 0
	fld	%f13, %g12, -8
	fld	%f14, %g11, -8
	fsub	%f13, %f13, %f14
	fmul	%f10, %f13, %f10
	fst	%f0, %g1, 8
	fmov	%f0, %f10
	subi	%g1, %g1, 16
	call	min_caml_floor
	addi	%g1, %g1, 16
	fmul	%f0, %f0, %f11
	fsub	%f0, %f13, %f0
	fld	%f1, %g1, 8
	fjlt	%f1, %f12, fjge_else.42229
	fjlt	%f0, %f12, fjge_else.42231
	setL %g3, l.34152
	fld	%f0, %g3, 0
	jmp	fjge_cont.42232
fjge_else.42231:
	setL %g3, l.34138
	fld	%f0, %g3, 0
fjge_cont.42232:
	jmp	fjge_cont.42230
fjge_else.42229:
	fjlt	%f0, %f12, fjge_else.42233
	setL %g3, l.34138
	fld	%f0, %g3, 0
	jmp	fjge_cont.42234
fjge_else.42233:
	setL %g3, l.34152
	fld	%f0, %g3, 0
fjge_cont.42234:
fjge_cont.42230:
	fst	%f0, %g10, -4
	return
jeq_else.42228:
	addi	%g12, %g0, 2
	jne	%g11, %g12, jeq_else.42236
	fld	%f0, %g4, -4
	setL %g11, l.36879
	fld	%f10, %g11, 0
	fmul	%f0, %f0, %f10
	setL %g11, l.34128
	fld	%f10, %g11, 0
	setL %g11, l.34130
	fld	%f11, %g11, 0
	fmov	%f12, %f30
	fmov	%f13, %f19
	fmov	%f14, %f20
	fmov	%f3, %f16
	fjlt	%f0, %f3, fjge_else.42237
	fmov	%f4, %f0
	jmp	fjge_cont.42238
fjge_else.42237:
	fneg	%f4, %f0
fjge_cont.42238:
	fst	%f0, %g1, 12
	fjlt	%f12, %f4, fjge_else.42239
	fjlt	%f4, %f3, fjge_else.42241
	fmov	%f0, %f4
	jmp	fjge_cont.42242
fjge_else.42241:
	fadd	%f4, %f4, %f12
	fjlt	%f12, %f4, fjge_else.42243
	fjlt	%f4, %f3, fjge_else.42245
	fmov	%f0, %f4
	jmp	fjge_cont.42246
fjge_else.42245:
	fadd	%f4, %f4, %f12
	fjlt	%f12, %f4, fjge_else.42247
	fjlt	%f4, %f3, fjge_else.42249
	fmov	%f0, %f4
	jmp	fjge_cont.42250
fjge_else.42249:
	fadd	%f4, %f4, %f12
	fmov	%f0, %f4
	subi	%g1, %g1, 20
	call	sin_sub.2497
	addi	%g1, %g1, 20
fjge_cont.42250:
	jmp	fjge_cont.42248
fjge_else.42247:
	fsub	%f4, %f4, %f12
	fmov	%f0, %f4
	subi	%g1, %g1, 20
	call	sin_sub.2497
	addi	%g1, %g1, 20
fjge_cont.42248:
fjge_cont.42246:
	jmp	fjge_cont.42244
fjge_else.42243:
	fsub	%f4, %f4, %f12
	fjlt	%f12, %f4, fjge_else.42251
	fjlt	%f4, %f3, fjge_else.42253
	fmov	%f0, %f4
	jmp	fjge_cont.42254
fjge_else.42253:
	fadd	%f4, %f4, %f12
	fmov	%f0, %f4
	subi	%g1, %g1, 20
	call	sin_sub.2497
	addi	%g1, %g1, 20
fjge_cont.42254:
	jmp	fjge_cont.42252
fjge_else.42251:
	fsub	%f4, %f4, %f12
	fmov	%f0, %f4
	subi	%g1, %g1, 20
	call	sin_sub.2497
	addi	%g1, %g1, 20
fjge_cont.42252:
fjge_cont.42244:
fjge_cont.42242:
	jmp	fjge_cont.42240
fjge_else.42239:
	fsub	%f4, %f4, %f12
	fjlt	%f12, %f4, fjge_else.42255
	fjlt	%f4, %f3, fjge_else.42257
	fmov	%f0, %f4
	jmp	fjge_cont.42258
fjge_else.42257:
	fadd	%f4, %f4, %f12
	fjlt	%f12, %f4, fjge_else.42259
	fjlt	%f4, %f3, fjge_else.42261
	fmov	%f0, %f4
	jmp	fjge_cont.42262
fjge_else.42261:
	fadd	%f4, %f4, %f12
	fmov	%f0, %f4
	subi	%g1, %g1, 20
	call	sin_sub.2497
	addi	%g1, %g1, 20
fjge_cont.42262:
	jmp	fjge_cont.42260
fjge_else.42259:
	fsub	%f4, %f4, %f12
	fmov	%f0, %f4
	subi	%g1, %g1, 20
	call	sin_sub.2497
	addi	%g1, %g1, 20
fjge_cont.42260:
fjge_cont.42258:
	jmp	fjge_cont.42256
fjge_else.42255:
	fsub	%f4, %f4, %f12
	fjlt	%f12, %f4, fjge_else.42263
	fjlt	%f4, %f3, fjge_else.42265
	fmov	%f0, %f4
	jmp	fjge_cont.42266
fjge_else.42265:
	fadd	%f4, %f4, %f12
	fmov	%f0, %f4
	subi	%g1, %g1, 20
	call	sin_sub.2497
	addi	%g1, %g1, 20
fjge_cont.42266:
	jmp	fjge_cont.42264
fjge_else.42263:
	fsub	%f4, %f4, %f12
	fmov	%f0, %f4
	subi	%g1, %g1, 20
	call	sin_sub.2497
	addi	%g1, %g1, 20
fjge_cont.42264:
fjge_cont.42256:
fjge_cont.42240:
	fjlt	%f10, %f0, fjge_else.42267
	fld	%f1, %g1, 12
	fjlt	%f3, %f1, fjge_else.42269
	addi	%g3, %g0, 0
	jmp	fjge_cont.42270
fjge_else.42269:
	addi	%g3, %g0, 1
fjge_cont.42270:
	jmp	fjge_cont.42268
fjge_else.42267:
	fld	%f1, %g1, 12
	fjlt	%f3, %f1, fjge_else.42271
	addi	%g3, %g0, 1
	jmp	fjge_cont.42272
fjge_else.42271:
	addi	%g3, %g0, 0
fjge_cont.42272:
fjge_cont.42268:
	fjlt	%f10, %f0, fjge_else.42273
	jmp	fjge_cont.42274
fjge_else.42273:
	fsub	%f0, %f12, %f0
fjge_cont.42274:
	fjlt	%f14, %f0, fjge_else.42275
	jmp	fjge_cont.42276
fjge_else.42275:
	fsub	%f0, %f10, %f0
fjge_cont.42276:
	fmul	%f0, %f0, %f13
	fmov	%f1, %f17
	fmul	%f2, %f0, %f0
	fmov	%f3, %f24
	fmov	%f4, %f23
	fdiv	%f4, %f2, %f4
	fmov	%f5, %f22
	fsub	%f3, %f3, %f4
	fdiv	%f3, %f2, %f3
	fmov	%f4, %f21
	fsub	%f3, %f5, %f3
	fdiv	%f3, %f2, %f3
	fsub	%f3, %f4, %f3
	fdiv	%f2, %f2, %f3
	fsub	%f2, %f1, %f2
	fdiv	%f0, %f0, %f2
	fmul	%f2, %f11, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f1, %f0
	fdiv	%f0, %f2, %f0
	jne	%g3, %g0, jeq_else.42277
	fneg	%f0, %f0
	jmp	jeq_cont.42278
jeq_else.42277:
jeq_cont.42278:
	fmul	%f0, %f0, %f0
	fmov	%f2, %f25
	fmul	%f3, %f2, %f0
	fst	%f3, %g10, 0
	fsub	%f0, %f1, %f0
	fmul	%f0, %f2, %f0
	fst	%f0, %g10, -4
	return
jeq_else.42236:
	addi	%g12, %g0, 3
	jne	%g11, %g12, jeq_else.42280
	fld	%f0, %g4, 0
	ld	%g11, %g3, -20
	fld	%f1, %g11, 0
	fsub	%f0, %f0, %f1
	fld	%f1, %g4, -8
	fld	%f10, %g11, -8
	fsub	%f1, %f1, %f10
	fmul	%f0, %f0, %f0
	fmul	%f1, %f1, %f1
	fadd	%f0, %f0, %f1
	fsqrt	%f0, %f0
	setL %g11, l.36860
	fld	%f10, %g11, 0
	fdiv	%f0, %f0, %f10
	fst	%f0, %g1, 16
	subi	%g1, %g1, 24
	call	min_caml_floor
	addi	%g1, %g1, 24
	fld	%f10, %g1, 16
	fsub	%f0, %f10, %f0
	setL %g11, l.36810
	fld	%f10, %g11, 0
	fmul	%f0, %f0, %f10
	fmov	%f10, %f19
	fmov	%f11, %f20
	fsub	%f0, %f11, %f0
	setL %g11, l.34128
	fld	%f12, %g11, 0
	setL %g11, l.34130
	fld	%f13, %g11, 0
	fmov	%f14, %f30
	fmov	%f3, %f16
	fjlt	%f0, %f3, fjge_else.42281
	fmov	%f4, %f0
	jmp	fjge_cont.42282
fjge_else.42281:
	fneg	%f4, %f0
fjge_cont.42282:
	fst	%f0, %g1, 20
	fjlt	%f14, %f4, fjge_else.42283
	fjlt	%f4, %f3, fjge_else.42285
	fmov	%f0, %f4
	jmp	fjge_cont.42286
fjge_else.42285:
	fadd	%f4, %f4, %f14
	fjlt	%f14, %f4, fjge_else.42287
	fjlt	%f4, %f3, fjge_else.42289
	fmov	%f0, %f4
	jmp	fjge_cont.42290
fjge_else.42289:
	fadd	%f4, %f4, %f14
	fjlt	%f14, %f4, fjge_else.42291
	fjlt	%f4, %f3, fjge_else.42293
	fmov	%f0, %f4
	jmp	fjge_cont.42294
fjge_else.42293:
	fadd	%f4, %f4, %f14
	fmov	%f0, %f4
	subi	%g1, %g1, 28
	call	sin_sub.2497
	addi	%g1, %g1, 28
fjge_cont.42294:
	jmp	fjge_cont.42292
fjge_else.42291:
	fsub	%f4, %f4, %f14
	fmov	%f0, %f4
	subi	%g1, %g1, 28
	call	sin_sub.2497
	addi	%g1, %g1, 28
fjge_cont.42292:
fjge_cont.42290:
	jmp	fjge_cont.42288
fjge_else.42287:
	fsub	%f4, %f4, %f14
	fjlt	%f14, %f4, fjge_else.42295
	fjlt	%f4, %f3, fjge_else.42297
	fmov	%f0, %f4
	jmp	fjge_cont.42298
fjge_else.42297:
	fadd	%f4, %f4, %f14
	fmov	%f0, %f4
	subi	%g1, %g1, 28
	call	sin_sub.2497
	addi	%g1, %g1, 28
fjge_cont.42298:
	jmp	fjge_cont.42296
fjge_else.42295:
	fsub	%f4, %f4, %f14
	fmov	%f0, %f4
	subi	%g1, %g1, 28
	call	sin_sub.2497
	addi	%g1, %g1, 28
fjge_cont.42296:
fjge_cont.42288:
fjge_cont.42286:
	jmp	fjge_cont.42284
fjge_else.42283:
	fsub	%f4, %f4, %f14
	fjlt	%f14, %f4, fjge_else.42299
	fjlt	%f4, %f3, fjge_else.42301
	fmov	%f0, %f4
	jmp	fjge_cont.42302
fjge_else.42301:
	fadd	%f4, %f4, %f14
	fjlt	%f14, %f4, fjge_else.42303
	fjlt	%f4, %f3, fjge_else.42305
	fmov	%f0, %f4
	jmp	fjge_cont.42306
fjge_else.42305:
	fadd	%f4, %f4, %f14
	fmov	%f0, %f4
	subi	%g1, %g1, 28
	call	sin_sub.2497
	addi	%g1, %g1, 28
fjge_cont.42306:
	jmp	fjge_cont.42304
fjge_else.42303:
	fsub	%f4, %f4, %f14
	fmov	%f0, %f4
	subi	%g1, %g1, 28
	call	sin_sub.2497
	addi	%g1, %g1, 28
fjge_cont.42304:
fjge_cont.42302:
	jmp	fjge_cont.42300
fjge_else.42299:
	fsub	%f4, %f4, %f14
	fjlt	%f14, %f4, fjge_else.42307
	fjlt	%f4, %f3, fjge_else.42309
	fmov	%f0, %f4
	jmp	fjge_cont.42310
fjge_else.42309:
	fadd	%f4, %f4, %f14
	fmov	%f0, %f4
	subi	%g1, %g1, 28
	call	sin_sub.2497
	addi	%g1, %g1, 28
fjge_cont.42310:
	jmp	fjge_cont.42308
fjge_else.42307:
	fsub	%f4, %f4, %f14
	fmov	%f0, %f4
	subi	%g1, %g1, 28
	call	sin_sub.2497
	addi	%g1, %g1, 28
fjge_cont.42308:
fjge_cont.42300:
fjge_cont.42284:
	fjlt	%f12, %f0, fjge_else.42311
	fld	%f1, %g1, 20
	fjlt	%f3, %f1, fjge_else.42313
	addi	%g3, %g0, 0
	jmp	fjge_cont.42314
fjge_else.42313:
	addi	%g3, %g0, 1
fjge_cont.42314:
	jmp	fjge_cont.42312
fjge_else.42311:
	fld	%f1, %g1, 20
	fjlt	%f3, %f1, fjge_else.42315
	addi	%g3, %g0, 1
	jmp	fjge_cont.42316
fjge_else.42315:
	addi	%g3, %g0, 0
fjge_cont.42316:
fjge_cont.42312:
	fjlt	%f12, %f0, fjge_else.42317
	jmp	fjge_cont.42318
fjge_else.42317:
	fsub	%f0, %f14, %f0
fjge_cont.42318:
	fjlt	%f11, %f0, fjge_else.42319
	jmp	fjge_cont.42320
fjge_else.42319:
	fsub	%f0, %f12, %f0
fjge_cont.42320:
	fmul	%f0, %f0, %f10
	fmov	%f1, %f17
	fmul	%f2, %f0, %f0
	fmov	%f3, %f24
	fmov	%f4, %f23
	fdiv	%f4, %f2, %f4
	fmov	%f5, %f22
	fsub	%f3, %f3, %f4
	fdiv	%f3, %f2, %f3
	fmov	%f4, %f21
	fsub	%f3, %f5, %f3
	fdiv	%f3, %f2, %f3
	fsub	%f3, %f4, %f3
	fdiv	%f2, %f2, %f3
	fsub	%f2, %f1, %f2
	fdiv	%f0, %f0, %f2
	fmul	%f2, %f13, %f0
	fmul	%f0, %f0, %f0
	fadd	%f0, %f1, %f0
	fdiv	%f0, %f2, %f0
	jne	%g3, %g0, jeq_else.42321
	fneg	%f0, %f0
	jmp	jeq_cont.42322
jeq_else.42321:
jeq_cont.42322:
	fmul	%f0, %f0, %f0
	fmov	%f2, %f25
	fmul	%f3, %f0, %f2
	fst	%f3, %g10, -4
	fsub	%f0, %f1, %f0
	fmul	%f0, %f0, %f2
	fst	%f0, %g10, -8
	return
jeq_else.42280:
	addi	%g12, %g0, 4
	jne	%g11, %g12, jeq_else.42324
	fld	%f0, %g4, 0
	ld	%g11, %g3, -20
	fld	%f1, %g11, 0
	fsub	%f0, %f0, %f1
	ld	%g12, %g3, -16
	fld	%f1, %g12, 0
	fst	%f0, %g1, 24
	fsqrt	%f0, %f1
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	fld	%f1, %g4, -8
	fld	%f10, %g11, -8
	fsub	%f1, %f1, %f10
	fld	%f10, %g12, -8
	fst	%f0, %g1, 28
	fsqrt	%f0, %f10
	fmul	%f0, %f1, %f0
	fld	%f10, %g1, 28
	fmul	%f11, %f10, %f10
	fmul	%f12, %f0, %f0
	fadd	%f11, %f11, %f12
	fmov	%f12, %f16
	fjlt	%f10, %f12, fjge_else.42325
	fmov	%f13, %f10
	jmp	fjge_cont.42326
fjge_else.42325:
	fneg	%f13, %f10
fjge_cont.42326:
	setL %g13, l.36764
	fld	%f14, %g13, 0
	fjlt	%f13, %f14, fjge_else.42327
	fdiv	%f0, %f0, %f10
	fjlt	%f0, %f12, fjge_else.42329
	jmp	fjge_cont.42330
fjge_else.42329:
	fneg	%f0, %f0
fjge_cont.42330:
	fmov	%f10, %f17
	fjlt	%f10, %f0, fjge_else.42331
	fmov	%f13, %f18
	fjlt	%f0, %f13, fjge_else.42333
	addi	%g13, %g0, 0
	jmp	fjge_cont.42334
fjge_else.42333:
	addi	%g13, %g0, -1
fjge_cont.42334:
	jmp	fjge_cont.42332
fjge_else.42331:
	addi	%g13, %g0, 1
fjge_cont.42332:
	jne	%g13, %g0, jeq_else.42335
	jmp	jeq_cont.42336
jeq_else.42335:
	fdiv	%f0, %f10, %f0
jeq_cont.42336:
	fmul	%f13, %f0, %f0
	setL %g14, l.36770
	fld	%f15, %g14, 0
	fmul	%f15, %f15, %f13
	setL %g14, l.36772
	fld	%f5, %g14, 0
	fdiv	%f15, %f15, %f5
	setL %g14, l.36774
	fld	%f5, %g14, 0
	fmul	%f5, %f5, %f13
	setL %g14, l.36776
	fld	%f6, %g14, 0
	fadd	%f15, %f6, %f15
	fdiv	%f15, %f5, %f15
	setL %g14, l.36778
	fld	%f5, %g14, 0
	fmul	%f5, %f5, %f13
	setL %g14, l.36780
	fld	%f6, %g14, 0
	fadd	%f15, %f6, %f15
	fdiv	%f15, %f5, %f15
	setL %g14, l.36782
	fld	%f5, %g14, 0
	fmul	%f5, %f5, %f13
	setL %g14, l.36784
	fld	%f6, %g14, 0
	fadd	%f15, %f6, %f15
	fdiv	%f15, %f5, %f15
	setL %g14, l.36786
	fld	%f5, %g14, 0
	fmul	%f5, %f5, %f13
	fmov	%f6, %f26
	fadd	%f15, %f6, %f15
	fdiv	%f15, %f5, %f15
	setL %g14, l.36789
	fld	%f5, %g14, 0
	fmul	%f5, %f5, %f13
	setL %g14, l.36791
	fld	%f6, %g14, 0
	fadd	%f15, %f6, %f15
	fdiv	%f15, %f5, %f15
	setL %g14, l.36793
	fld	%f5, %g14, 0
	fmul	%f5, %f5, %f13
	setL %g14, l.36795
	fld	%f6, %g14, 0
	fadd	%f15, %f6, %f15
	fdiv	%f15, %f5, %f15
	setL %g14, l.36797
	fld	%f5, %g14, 0
	fmul	%f5, %f5, %f13
	fmov	%f6, %f23
	fadd	%f15, %f6, %f15
	fdiv	%f15, %f5, %f15
	fmul	%f5, %f6, %f13
	fmov	%f6, %f24
	fadd	%f15, %f6, %f15
	fdiv	%f15, %f5, %f15
	setL %g14, l.36801
	fld	%f5, %g14, 0
	fmul	%f5, %f5, %f13
	fmov	%f6, %f22
	fadd	%f15, %f6, %f15
	fdiv	%f15, %f5, %f15
	fmov	%f5, %f21
	fadd	%f15, %f5, %f15
	fdiv	%f13, %f13, %f15
	fadd	%f10, %f10, %f13
	fdiv	%f0, %f0, %f10
	jlt	%g0, %g13, jle_else.42337
	jlt	%g13, %g0, jge_else.42339
	jmp	jge_cont.42340
jge_else.42339:
	setL %g13, l.36806
	fld	%f10, %g13, 0
	fsub	%f0, %f10, %f0
jge_cont.42340:
	jmp	jle_cont.42338
jle_else.42337:
	fmov	%f10, %f20
	fsub	%f0, %f10, %f0
jle_cont.42338:
	setL %g13, l.36808
	fld	%f10, %g13, 0
	fmul	%f0, %f0, %f10
	setL %g13, l.36810
	fld	%f10, %g13, 0
	fdiv	%f0, %f0, %f10
	jmp	fjge_cont.42328
fjge_else.42327:
	setL %g13, l.36766
	fld	%f0, %g13, 0
fjge_cont.42328:
	st	%g4, %g1, 0
	fst	%f0, %g1, 32
	subi	%g1, %g1, 40
	call	min_caml_floor
	addi	%g1, %g1, 40
	fld	%f1, %g1, 32
	fsub	%f0, %f1, %f0
	ld	%g13, %g1, 0
	fld	%f1, %g13, -4
	fld	%f10, %g11, -4
	fsub	%f1, %f1, %f10
	fld	%f10, %g12, -4
	fst	%f0, %g1, 36
	fsqrt	%f0, %f10
	fmul	%f0, %f1, %f0
	fjlt	%f11, %f12, fjge_else.42341
	fmov	%f10, %f11
	jmp	fjge_cont.42342
fjge_else.42341:
	fneg	%f10, %f11
fjge_cont.42342:
	fjlt	%f10, %f14, fjge_else.42343
	fdiv	%f0, %f0, %f11
	fjlt	%f0, %f12, fjge_else.42345
	jmp	fjge_cont.42346
fjge_else.42345:
	fneg	%f0, %f0
fjge_cont.42346:
	fmov	%f10, %f17
	fjlt	%f10, %f0, fjge_else.42347
	fmov	%f11, %f18
	fjlt	%f0, %f11, fjge_else.42349
	addi	%g11, %g0, 0
	jmp	fjge_cont.42350
fjge_else.42349:
	addi	%g11, %g0, -1
fjge_cont.42350:
	jmp	fjge_cont.42348
fjge_else.42347:
	addi	%g11, %g0, 1
fjge_cont.42348:
	jne	%g11, %g0, jeq_else.42351
	jmp	jeq_cont.42352
jeq_else.42351:
	fdiv	%f0, %f10, %f0
jeq_cont.42352:
	fmul	%f11, %f0, %f0
	setL %g12, l.36770
	fld	%f13, %g12, 0
	fmul	%f13, %f13, %f11
	setL %g12, l.36772
	fld	%f14, %g12, 0
	fdiv	%f13, %f13, %f14
	setL %g12, l.36774
	fld	%f14, %g12, 0
	fmul	%f14, %f14, %f11
	setL %g12, l.36776
	fld	%f15, %g12, 0
	fadd	%f13, %f15, %f13
	fdiv	%f13, %f14, %f13
	setL %g12, l.36778
	fld	%f14, %g12, 0
	fmul	%f14, %f14, %f11
	setL %g12, l.36780
	fld	%f15, %g12, 0
	fadd	%f13, %f15, %f13
	fdiv	%f13, %f14, %f13
	setL %g12, l.36782
	fld	%f14, %g12, 0
	fmul	%f14, %f14, %f11
	setL %g12, l.36784
	fld	%f15, %g12, 0
	fadd	%f13, %f15, %f13
	fdiv	%f13, %f14, %f13
	setL %g12, l.36786
	fld	%f14, %g12, 0
	fmul	%f14, %f14, %f11
	fmov	%f15, %f26
	fadd	%f13, %f15, %f13
	fdiv	%f13, %f14, %f13
	setL %g12, l.36789
	fld	%f14, %g12, 0
	fmul	%f14, %f14, %f11
	setL %g12, l.36791
	fld	%f15, %g12, 0
	fadd	%f13, %f15, %f13
	fdiv	%f13, %f14, %f13
	setL %g12, l.36793
	fld	%f14, %g12, 0
	fmul	%f14, %f14, %f11
	setL %g12, l.36795
	fld	%f15, %g12, 0
	fadd	%f13, %f15, %f13
	fdiv	%f13, %f14, %f13
	setL %g12, l.36797
	fld	%f14, %g12, 0
	fmul	%f14, %f14, %f11
	fmov	%f15, %f23
	fadd	%f13, %f15, %f13
	fdiv	%f13, %f14, %f13
	fmul	%f14, %f15, %f11
	fmov	%f15, %f24
	fadd	%f13, %f15, %f13
	fdiv	%f13, %f14, %f13
	setL %g12, l.36801
	fld	%f14, %g12, 0
	fmul	%f14, %f14, %f11
	fmov	%f15, %f22
	fadd	%f13, %f15, %f13
	fdiv	%f13, %f14, %f13
	fmov	%f14, %f21
	fadd	%f13, %f14, %f13
	fdiv	%f11, %f11, %f13
	fadd	%f10, %f10, %f11
	fdiv	%f0, %f0, %f10
	jlt	%g0, %g11, jle_else.42353
	jlt	%g11, %g0, jge_else.42355
	jmp	jge_cont.42356
jge_else.42355:
	setL %g11, l.36806
	fld	%f10, %g11, 0
	fsub	%f0, %f10, %f0
jge_cont.42356:
	jmp	jle_cont.42354
jle_else.42353:
	fmov	%f10, %f20
	fsub	%f0, %f10, %f0
jle_cont.42354:
	setL %g11, l.36808
	fld	%f10, %g11, 0
	fmul	%f0, %f0, %f10
	setL %g11, l.36810
	fld	%f10, %g11, 0
	fdiv	%f0, %f0, %f10
	jmp	fjge_cont.42344
fjge_else.42343:
	setL %g11, l.36766
	fld	%f0, %g11, 0
fjge_cont.42344:
	fst	%f0, %g1, 40
	subi	%g1, %g1, 48
	call	min_caml_floor
	addi	%g1, %g1, 48
	fld	%f1, %g1, 40
	fsub	%f0, %f1, %f0
	setL %g3, l.36845
	fld	%f1, %g3, 0
	fmov	%f2, %f19
	fld	%f3, %g1, 36
	fsub	%f3, %f2, %f3
	fmul	%f3, %f3, %f3
	fsub	%f1, %f1, %f3
	fsub	%f0, %f2, %f0
	fmul	%f0, %f0, %f0
	fsub	%f0, %f1, %f0
	fjlt	%f0, %f12, fjge_else.42357
	jmp	fjge_cont.42358
fjge_else.42357:
	fmov	%f0, %f12
fjge_cont.42358:
	fmov	%f1, %f25
	fmul	%f0, %f1, %f0
	setL %g3, l.36849
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	fst	%f0, %g10, -8
	return
jeq_else.42324:
	return
trace_reflections.2890:
	ld	%g5, %g31, 676
	ld	%g6, %g31, 784
	ld	%g7, %g31, 796
	ld	%g8, %g31, 776
	ld	%g9, %g31, 788
	ld	%g10, %g31, 772
	ld	%g11, %g31, 760
	ld	%g12, %g31, 768
	jlt	%g3, %g0, jge_else.42361
	slli	%g13, %g3, 2
	add	%g26, %g5, %g13
	ld	%g5, %g26, 0
	ld	%g13, %g5, -4
	fmov	%f2, %f29
	fst	%f2, %g6, 0
	addi	%g14, %g0, 0
	ld	%g15, %g7, 0
	st	%g3, %g1, 0
	fst	%f1, %g1, 4
	st	%g12, %g1, 8
	st	%g11, %g1, 12
	st	%g4, %g1, 16
	fst	%f0, %g1, 20
	st	%g10, %g1, 24
	st	%g13, %g1, 28
	st	%g7, %g1, 32
	st	%g5, %g1, 36
	st	%g9, %g1, 40
	st	%g8, %g1, 44
	st	%g6, %g1, 48
	mov	%g5, %g13
	mov	%g4, %g15
	mov	%g3, %g14
	subi	%g1, %g1, 56
	call	trace_or_matrix_fast.2868
	addi	%g1, %g1, 56
	ld	%g3, %g1, 48
	fld	%f0, %g3, 0
	fmov	%f1, %f27
	fjlt	%f1, %f0, fjge_else.42362
	addi	%g3, %g0, 0
	jmp	fjge_cont.42363
fjge_else.42362:
	setL %g3, l.36922
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.42364
	addi	%g3, %g0, 0
	jmp	fjge_cont.42365
fjge_else.42364:
	addi	%g3, %g0, 1
fjge_cont.42365:
fjge_cont.42363:
	jne	%g3, %g0, jeq_else.42366
	jmp	jeq_cont.42367
jeq_else.42366:
	ld	%g3, %g1, 44
	ld	%g3, %g3, 0
	slli	%g3, %g3, 2
	ld	%g4, %g1, 40
	ld	%g4, %g4, 0
	add	%g3, %g3, %g4
	ld	%g4, %g1, 36
	ld	%g22, %g4, 0
	jne	%g3, %g22, jeq_else.42368
	addi	%g3, %g0, 0
	ld	%g22, %g1, 32
	ld	%g22, %g22, 0
	mov	%g4, %g22
	subi	%g1, %g1, 56
	call	shadow_check_one_or_matrix.2843
	addi	%g1, %g1, 56
	jne	%g3, %g0, jeq_else.42370
	ld	%g3, %g1, 28
	ld	%g3, %g3, 0
	ld	%g4, %g1, 24
	fld	%f0, %g4, 0
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fld	%f2, %g4, -4
	fld	%f3, %g3, -4
	fmul	%f2, %f2, %f3
	fadd	%f0, %f0, %f2
	fld	%f2, %g4, -8
	fld	%f4, %g3, -8
	fmul	%f2, %f2, %f4
	fadd	%f0, %f0, %f2
	ld	%g3, %g1, 36
	fld	%f2, %g3, -8
	fld	%f5, %g1, 20
	fmul	%f6, %f2, %f5
	fmul	%f0, %f6, %f0
	ld	%g3, %g1, 16
	fld	%f6, %g3, 0
	fmul	%f1, %f6, %f1
	fld	%f6, %g3, -4
	fmul	%f3, %f6, %f3
	fadd	%f1, %f1, %f3
	fld	%f3, %g3, -8
	fmul	%f3, %f3, %f4
	fadd	%f1, %f1, %f3
	fmul	%f1, %f2, %f1
	fmov	%f2, %f16
	fjlt	%f2, %f0, fjge_else.42372
	jmp	fjge_cont.42373
fjge_else.42372:
	ld	%g4, %g1, 12
	fld	%f3, %g4, 0
	ld	%g5, %g1, 8
	fld	%f4, %g5, 0
	fmul	%f4, %f0, %f4
	fadd	%f3, %f3, %f4
	fst	%f3, %g4, 0
	fld	%f3, %g4, -4
	fld	%f4, %g5, -4
	fmul	%f4, %f0, %f4
	fadd	%f3, %f3, %f4
	fst	%f3, %g4, -4
	fld	%f3, %g4, -8
	fld	%f4, %g5, -8
	fmul	%f0, %f0, %f4
	fadd	%f0, %f3, %f0
	fst	%f0, %g4, -8
fjge_cont.42373:
	fjlt	%f2, %f1, fjge_else.42374
	jmp	fjge_cont.42375
fjge_else.42374:
	fmul	%f0, %f1, %f1
	fmul	%f0, %f0, %f0
	fld	%f1, %g1, 4
	fmul	%f0, %f0, %f1
	ld	%g4, %g1, 12
	fld	%f2, %g4, 0
	fadd	%f2, %f2, %f0
	fst	%f2, %g4, 0
	fld	%f2, %g4, -4
	fadd	%f2, %f2, %f0
	fst	%f2, %g4, -4
	fld	%f2, %g4, -8
	fadd	%f0, %f2, %f0
	fst	%f0, %g4, -8
fjge_cont.42375:
	jmp	jeq_cont.42371
jeq_else.42370:
jeq_cont.42371:
	jmp	jeq_cont.42369
jeq_else.42368:
jeq_cont.42369:
jeq_cont.42367:
	ld	%g3, %g1, 0
	subi	%g3, %g3, 1
	fld	%f0, %g1, 20
	fld	%f1, %g1, 4
	ld	%g4, %g1, 16
	jmp	trace_reflections.2890
jge_else.42361:
	return
trace_ray.2895:
	ld	%g6, %g31, 784
	ld	%g7, %g31, 796
	ld	%g8, %g31, 808
	ld	%g9, %g31, 804
	ld	%g10, %g31, 760
	ld	%g11, %g31, 776
	ld	%g12, %g31, 820
	ld	%g13, %g31, 788
	ld	%g14, %g31, 772
	ld	%g15, %g31, 780
	ld	%g16, %g31, 744
	ld	%g17, %g31, 768
	ld	%g18, %g31, 740
	ld	%g19, %g31, 828
	ld	%g20, %g31, 672
	addi	%g21, %g0, 4
	jlt	%g21, %g3, jle_else.42377
	ld	%g21, %g5, -8
	fmov	%f2, %f29
	fst	%f2, %g6, 0
	addi	%g22, %g0, 0
	ld	%g23, %g7, 0
	fst	%f1, %g1, 0
	st	%g20, %g1, 4
	st	%g19, %g1, 8
	st	%g18, %g1, 12
	st	%g7, %g1, 16
	st	%g17, %g1, 20
	st	%g5, %g1, 24
	st	%g16, %g1, 28
	st	%g15, %g1, 32
	st	%g14, %g1, 36
	st	%g13, %g1, 40
	st	%g12, %g1, 44
	st	%g11, %g1, 48
	st	%g10, %g1, 52
	st	%g9, %g1, 56
	fst	%f0, %g1, 60
	st	%g8, %g1, 64
	st	%g4, %g1, 68
	st	%g21, %g1, 72
	st	%g3, %g1, 76
	st	%g6, %g1, 80
	mov	%g5, %g4
	mov	%g3, %g22
	mov	%g4, %g23
	subi	%g1, %g1, 88
	call	trace_or_matrix.2854
	addi	%g1, %g1, 88
	ld	%g10, %g1, 80
	fld	%f0, %g10, 0
	fmov	%f1, %f27
	fjlt	%f1, %f0, fjge_else.42378
	addi	%g11, %g0, 0
	jmp	fjge_cont.42379
fjge_else.42378:
	setL %g11, l.36922
	fld	%f1, %g11, 0
	fjlt	%f0, %f1, fjge_else.42380
	addi	%g11, %g0, 0
	jmp	fjge_cont.42381
fjge_else.42380:
	addi	%g11, %g0, 1
fjge_cont.42381:
fjge_cont.42379:
	jne	%g11, %g0, jeq_else.42382
	addi	%g3, %g0, -1
	ld	%g4, %g1, 76
	slli	%g5, %g4, 2
	ld	%g6, %g1, 72
	add	%g26, %g6, %g5
	st	%g3, %g26, 0
	jne	%g4, %g0, jeq_else.42383
	return
jeq_else.42383:
	ld	%g3, %g1, 68
	fld	%f0, %g3, 0
	ld	%g4, %g1, 64
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g3, -4
	fld	%f2, %g4, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, -8
	fld	%f2, %g4, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fneg	%f0, %f0
	fmov	%f1, %f16
	fjlt	%f1, %f0, fjge_else.42385
	return
fjge_else.42385:
	fmul	%f1, %f0, %f0
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 60
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 56
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 52
	fld	%f1, %g3, 0
	fadd	%f1, %f1, %f0
	fst	%f1, %g3, 0
	fld	%f1, %g3, -4
	fadd	%f1, %f1, %f0
	fst	%f1, %g3, -4
	fld	%f1, %g3, -8
	fadd	%f0, %f1, %f0
	fst	%f0, %g3, -8
	return
jeq_else.42382:
	ld	%g11, %g1, 48
	ld	%g11, %g11, 0
	slli	%g12, %g11, 2
	ld	%g13, %g1, 44
	add	%g26, %g13, %g12
	ld	%g12, %g26, 0
	ld	%g13, %g12, -8
	ld	%g14, %g12, -28
	fld	%f0, %g14, 0
	fld	%f1, %g1, 60
	fmul	%f0, %f0, %f1
	ld	%g15, %g12, -4
	fst	%f0, %g1, 84
	jne	%g15, %g28, jeq_else.42388
	ld	%g3, %g1, 40
	ld	%g4, %g3, 0
	fmov	%f7, %f16
	ld	%g15, %g1, 36
	fst	%f7, %g15, 0
	fst	%f7, %g15, -4
	fst	%f7, %g15, -8
	subi	%g4, %g4, 1
	slli	%g16, %g4, 2
	ld	%g17, %g1, 68
	add	%g26, %g17, %g16
	fld	%f8, %g26, 0
	fjeq	%f8, %f7, fjne_else.42390
	fjlt	%f7, %f8, fjge_else.42392
	setL %g16, l.35516
	fld	%f7, %g16, 0
	jmp	fjge_cont.42393
fjge_else.42392:
	setL %g16, l.34374
	fld	%f7, %g16, 0
fjge_cont.42393:
	jmp	fjne_cont.42391
fjne_else.42390:
fjne_cont.42391:
	fneg	%f7, %f7
	slli	%g4, %g4, 2
	add	%g26, %g15, %g4
	fst	%f7, %g26, 0
	jmp	jeq_cont.42389
jeq_else.42388:
	addi	%g16, %g0, 2
	jne	%g15, %g16, jeq_else.42394
	ld	%g3, %g12, -16
	fld	%f7, %g3, 0
	fneg	%f7, %f7
	ld	%g4, %g1, 36
	fst	%f7, %g4, 0
	fld	%f7, %g3, -4
	fneg	%f7, %f7
	fst	%f7, %g4, -4
	fld	%f7, %g3, -8
	fneg	%f7, %f7
	fst	%f7, %g4, -8
	jmp	jeq_cont.42395
jeq_else.42394:
	ld	%g15, %g1, 32
	fld	%f10, %g15, 0
	ld	%g16, %g12, -20
	fld	%f11, %g16, 0
	fsub	%f10, %f10, %f11
	fld	%f11, %g15, -4
	fld	%f12, %g16, -4
	fsub	%f11, %f11, %f12
	fld	%f12, %g15, -8
	fld	%f13, %g16, -8
	fsub	%f12, %f12, %f13
	ld	%g16, %g12, -16
	fld	%f13, %g16, 0
	fmul	%f13, %f10, %f13
	fld	%f14, %g16, -4
	fmul	%f14, %f11, %f14
	fld	%f15, %g16, -8
	fmul	%f15, %f12, %f15
	ld	%g16, %g12, -12
	jne	%g16, %g0, jeq_else.42396
	ld	%g16, %g1, 36
	fst	%f13, %g16, 0
	fst	%f14, %g16, -4
	fst	%f15, %g16, -8
	jmp	jeq_cont.42397
jeq_else.42396:
	ld	%g16, %g12, -36
	fld	%f2, %g16, -8
	fmul	%f2, %f11, %f2
	fld	%f3, %g16, -4
	fmul	%f3, %f12, %f3
	fadd	%f2, %f2, %f3
	fmov	%f3, %f19
	fmul	%f2, %f2, %f3
	fadd	%f13, %f13, %f2
	ld	%g17, %g1, 36
	fst	%f13, %g17, 0
	fld	%f13, %g16, -8
	fmul	%f13, %f10, %f13
	fld	%f2, %g16, 0
	fmul	%f12, %f12, %f2
	fadd	%f12, %f13, %f12
	fmul	%f12, %f12, %f3
	fadd	%f12, %f14, %f12
	fst	%f12, %g17, -4
	fld	%f12, %g16, -4
	fmul	%f10, %f10, %f12
	fld	%f12, %g16, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	fmul	%f10, %f10, %f3
	fadd	%f10, %f15, %f10
	fst	%f10, %g17, -8
jeq_cont.42397:
	ld	%g16, %g12, -24
	ld	%g17, %g1, 36
	fld	%f10, %g17, 0
	fmul	%f11, %f10, %f10
	fld	%f12, %g17, -4
	fmul	%f12, %f12, %f12
	fadd	%f11, %f11, %f12
	fld	%f12, %g17, -8
	fmul	%f12, %f12, %f12
	fadd	%f11, %f11, %f12
	fsqrt	%f7, %f11
	fmov	%f8, %f16
	fjeq	%f7, %f8, fjne_else.42398
	jne	%g16, %g0, jeq_else.42400
	fmov	%f8, %f17
	fdiv	%f7, %f8, %f7
	jmp	jeq_cont.42401
jeq_else.42400:
	fmov	%f8, %f18
	fdiv	%f7, %f8, %f7
jeq_cont.42401:
	jmp	fjne_cont.42399
fjne_else.42398:
	setL %g3, l.34374
	fld	%f7, %g3, 0
fjne_cont.42399:
	fmul	%f8, %f10, %f7
	fst	%f8, %g17, 0
	fld	%f8, %g17, -4
	fmul	%f8, %f8, %f7
	fst	%f8, %g17, -4
	fld	%f8, %g17, -8
	fmul	%f7, %f8, %f7
	fst	%f7, %g17, -8
jeq_cont.42395:
jeq_cont.42389:
	ld	%g3, %g1, 32
	fld	%f7, %g3, 0
	ld	%g4, %g1, 28
	fst	%f7, %g4, 0
	fld	%f7, %g3, -4
	fst	%f7, %g4, -4
	fld	%f7, %g3, -8
	fst	%f7, %g4, -8
	st	%g13, %g1, 88
	st	%g14, %g1, 92
	st	%g11, %g1, 96
	mov	%g4, %g3
	mov	%g3, %g12
	subi	%g1, %g1, 104
	call	utexture.2883
	addi	%g1, %g1, 104
	ld	%g3, %g1, 96
	slli	%g3, %g3, 2
	ld	%g4, %g1, 40
	ld	%g4, %g4, 0
	add	%g3, %g3, %g4
	ld	%g4, %g1, 76
	slli	%g22, %g4, 2
	ld	%g23, %g1, 72
	add	%g26, %g23, %g22
	st	%g3, %g26, 0
	ld	%g3, %g1, 24
	ld	%g22, %g3, -4
	slli	%g24, %g4, 2
	add	%g26, %g22, %g24
	ld	%g22, %g26, 0
	ld	%g24, %g1, 32
	fld	%f0, %g24, 0
	fst	%f0, %g22, 0
	fld	%f0, %g24, -4
	fst	%f0, %g22, -4
	fld	%f0, %g24, -8
	fst	%f0, %g22, -8
	ld	%g22, %g3, -12
	ld	%g25, %g1, 92
	fld	%f0, %g25, 0
	fmov	%f1, %f19
	fjlt	%f0, %f1, fjge_else.42402
	addi	%g8, %g0, 1
	slli	%g9, %g4, 2
	add	%g26, %g22, %g9
	st	%g8, %g26, 0
	ld	%g22, %g3, -16
	slli	%g8, %g4, 2
	add	%g26, %g22, %g8
	ld	%g8, %g26, 0
	ld	%g9, %g1, 20
	fld	%f0, %g9, 0
	fst	%f0, %g8, 0
	fld	%f0, %g9, -4
	fst	%f0, %g8, -4
	fld	%f0, %g9, -8
	fst	%f0, %g8, -8
	slli	%g8, %g4, 2
	add	%g26, %g22, %g8
	ld	%g22, %g26, 0
	setL %g8, l.37102
	fld	%f0, %g8, 0
	fld	%f1, %g1, 84
	fmul	%f0, %f0, %f1
	fld	%f2, %g22, 0
	fmul	%f2, %f2, %f0
	fst	%f2, %g22, 0
	fld	%f2, %g22, -4
	fmul	%f2, %f2, %f0
	fst	%f2, %g22, -4
	fld	%f2, %g22, -8
	fmul	%f0, %f2, %f0
	fst	%f0, %g22, -8
	ld	%g22, %g3, -28
	slli	%g8, %g4, 2
	add	%g26, %g22, %g8
	ld	%g22, %g26, 0
	ld	%g8, %g1, 36
	fld	%f0, %g8, 0
	fst	%f0, %g22, 0
	fld	%f0, %g8, -4
	fst	%f0, %g22, -4
	fld	%f0, %g8, -8
	fst	%f0, %g22, -8
	jmp	fjge_cont.42403
fjge_else.42402:
	addi	%g8, %g0, 0
	slli	%g9, %g4, 2
	add	%g26, %g22, %g9
	st	%g8, %g26, 0
fjge_cont.42403:
	setL %g22, l.37124
	fld	%f0, %g22, 0
	ld	%g22, %g1, 68
	fld	%f1, %g22, 0
	ld	%g8, %g1, 36
	fld	%f2, %g8, 0
	fmul	%f3, %f1, %f2
	fld	%f4, %g22, -4
	fld	%f5, %g8, -4
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	fld	%f4, %g22, -8
	fld	%f5, %g8, -8
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	fmul	%f0, %f0, %f3
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g22, 0
	fld	%f1, %g22, -4
	fld	%f2, %g8, -4
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g22, -4
	fld	%f1, %g22, -8
	fld	%f2, %g8, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fst	%f0, %g22, -8
	fld	%f0, %g25, -4
	fld	%f1, %g1, 60
	fmul	%f0, %f1, %f0
	addi	%g9, %g0, 0
	ld	%g5, %g1, 16
	ld	%g5, %g5, 0
	fst	%f0, %g1, 100
	mov	%g4, %g5
	mov	%g3, %g9
	subi	%g1, %g1, 108
	call	shadow_check_one_or_matrix.2843
	addi	%g1, %g1, 108
	jne	%g3, %g0, jeq_else.42404
	fld	%f10, %g8, 0
	ld	%g3, %g1, 64
	fld	%f11, %g3, 0
	fmul	%f10, %f10, %f11
	fld	%f12, %g8, -4
	fld	%f13, %g3, -4
	fmul	%f12, %f12, %f13
	fadd	%f10, %f10, %f12
	fld	%f12, %g8, -8
	fld	%f14, %g3, -8
	fmul	%f12, %f12, %f14
	fadd	%f10, %f10, %f12
	fneg	%f10, %f10
	fld	%f12, %g1, 84
	fmul	%f10, %f10, %f12
	fld	%f6, %g22, 0
	fmul	%f11, %f6, %f11
	fld	%f6, %g22, -4
	fmul	%f13, %f6, %f13
	fadd	%f11, %f11, %f13
	fld	%f13, %g22, -8
	fmul	%f13, %f13, %f14
	fadd	%f11, %f11, %f13
	fneg	%f11, %f11
	fmov	%f13, %f16
	fjlt	%f13, %f10, fjge_else.42406
	jmp	fjge_cont.42407
fjge_else.42406:
	ld	%g3, %g1, 52
	fld	%f14, %g3, 0
	ld	%g4, %g1, 20
	fld	%f6, %g4, 0
	fmul	%f6, %f10, %f6
	fadd	%f14, %f14, %f6
	fst	%f14, %g3, 0
	fld	%f14, %g3, -4
	fld	%f6, %g4, -4
	fmul	%f6, %f10, %f6
	fadd	%f14, %f14, %f6
	fst	%f14, %g3, -4
	fld	%f14, %g3, -8
	fld	%f6, %g4, -8
	fmul	%f10, %f10, %f6
	fadd	%f10, %f14, %f10
	fst	%f10, %g3, -8
fjge_cont.42407:
	fjlt	%f13, %f11, fjge_else.42408
	jmp	fjge_cont.42409
fjge_else.42408:
	fmul	%f10, %f11, %f11
	fmul	%f10, %f10, %f10
	fld	%f11, %g1, 100
	fmul	%f10, %f10, %f11
	ld	%g3, %g1, 52
	fld	%f13, %g3, 0
	fadd	%f13, %f13, %f10
	fst	%f13, %g3, 0
	fld	%f13, %g3, -4
	fadd	%f13, %f13, %f10
	fst	%f13, %g3, -4
	fld	%f13, %g3, -8
	fadd	%f10, %f13, %f10
	fst	%f10, %g3, -8
fjge_cont.42409:
	jmp	jeq_cont.42405
jeq_else.42404:
jeq_cont.42405:
	fld	%f10, %g24, 0
	ld	%g3, %g1, 12
	fst	%f10, %g3, 0
	fld	%f10, %g24, -4
	fst	%f10, %g3, -4
	fld	%f10, %g24, -8
	fst	%f10, %g3, -8
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	subi	%g3, %g3, 1
	mov	%g4, %g3
	mov	%g3, %g24
	subi	%g1, %g1, 108
	call	setup_startp_constants.2806
	addi	%g1, %g1, 108
	ld	%g3, %g1, 4
	ld	%g3, %g3, 0
	subi	%g3, %g3, 1
	fld	%f0, %g1, 84
	fld	%f1, %g1, 100
	mov	%g4, %g22
	subi	%g1, %g1, 108
	call	trace_reflections.2890
	addi	%g1, %g1, 108
	fmov	%f0, %f28
	fld	%f1, %g1, 60
	fjlt	%f0, %f1, fjge_else.42410
	return
fjge_else.42410:
	addi	%g3, %g0, 4
	ld	%g4, %g1, 76
	jlt	%g4, %g3, jle_else.42412
	jmp	jle_cont.42413
jle_else.42412:
	addi	%g3, %g4, 1
	addi	%g5, %g0, -1
	slli	%g3, %g3, 2
	ld	%g6, %g1, 72
	add	%g26, %g6, %g3
	st	%g5, %g26, 0
jle_cont.42413:
	addi	%g3, %g0, 2
	ld	%g5, %g1, 88
	jne	%g5, %g3, jeq_else.42414
	fmov	%f0, %f17
	ld	%g3, %g1, 92
	fld	%f2, %g3, 0
	fsub	%f0, %f0, %f2
	fmul	%f0, %f1, %f0
	addi	%g3, %g4, 1
	ld	%g4, %g1, 80
	fld	%f1, %g4, 0
	fld	%f2, %g1, 0
	fadd	%f1, %f2, %f1
	ld	%g4, %g1, 68
	ld	%g5, %g1, 24
	jmp	trace_ray.2895
jeq_else.42414:
	return
jle_else.42377:
	return
iter_trace_diffuse_rays.2904:
	ld	%g7, %g31, 784
	ld	%g8, %g31, 796
	ld	%g9, %g31, 776
	ld	%g10, %g31, 820
	ld	%g11, %g31, 788
	ld	%g12, %g31, 772
	ld	%g13, %g31, 780
	ld	%g14, %g31, 808
	ld	%g15, %g31, 764
	ld	%g16, %g31, 768
	jlt	%g6, %g0, jge_else.42417
	slli	%g17, %g6, 2
	add	%g26, %g3, %g17
	ld	%g17, %g26, 0
	ld	%g17, %g17, 0
	fld	%f0, %g17, 0
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g17, -4
	fld	%f2, %g4, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g17, -8
	fld	%f2, %g4, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fmov	%f1, %f16
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g3, %g1, 8
	st	%g6, %g1, 12
	fjlt	%f0, %f1, fjge_else.42418
	slli	%g17, %g6, 2
	add	%g26, %g3, %g17
	ld	%g17, %g26, 0
	setL %g18, l.37377
	fld	%f2, %g18, 0
	fdiv	%f0, %f0, %f2
	fmov	%f2, %f29
	fst	%f2, %g7, 0
	addi	%g18, %g0, 0
	ld	%g19, %g8, 0
	st	%g16, %g1, 16
	st	%g15, %g1, 20
	fst	%f0, %g1, 24
	st	%g14, %g1, 28
	st	%g8, %g1, 32
	st	%g13, %g1, 36
	st	%g12, %g1, 40
	fst	%f1, %g1, 44
	st	%g11, %g1, 48
	st	%g17, %g1, 52
	st	%g10, %g1, 56
	st	%g9, %g1, 60
	st	%g7, %g1, 64
	mov	%g5, %g17
	mov	%g4, %g19
	mov	%g3, %g18
	subi	%g1, %g1, 72
	call	trace_or_matrix_fast.2868
	addi	%g1, %g1, 72
	ld	%g10, %g1, 64
	fld	%f0, %g10, 0
	fmov	%f1, %f27
	fjlt	%f1, %f0, fjge_else.42420
	addi	%g10, %g0, 0
	jmp	fjge_cont.42421
fjge_else.42420:
	setL %g10, l.36922
	fld	%f1, %g10, 0
	fjlt	%f0, %f1, fjge_else.42422
	addi	%g10, %g0, 0
	jmp	fjge_cont.42423
fjge_else.42422:
	addi	%g10, %g0, 1
fjge_cont.42423:
fjge_cont.42421:
	jne	%g10, %g0, jeq_else.42424
	jmp	jeq_cont.42425
jeq_else.42424:
	ld	%g10, %g1, 60
	ld	%g10, %g10, 0
	slli	%g10, %g10, 2
	ld	%g11, %g1, 56
	add	%g26, %g11, %g10
	ld	%g10, %g26, 0
	ld	%g11, %g1, 52
	ld	%g11, %g11, 0
	ld	%g12, %g10, -4
	jne	%g12, %g28, jeq_else.42426
	ld	%g3, %g1, 48
	ld	%g3, %g3, 0
	ld	%g4, %g1, 40
	fld	%f7, %g1, 44
	fst	%f7, %g4, 0
	fst	%f7, %g4, -4
	fst	%f7, %g4, -8
	subi	%g3, %g3, 1
	slli	%g15, %g3, 2
	add	%g26, %g11, %g15
	fld	%f8, %g26, 0
	fjeq	%f8, %f7, fjne_else.42428
	fjlt	%f7, %f8, fjge_else.42430
	setL %g15, l.35516
	fld	%f8, %g15, 0
	jmp	fjge_cont.42431
fjge_else.42430:
	setL %g15, l.34374
	fld	%f8, %g15, 0
fjge_cont.42431:
	jmp	fjne_cont.42429
fjne_else.42428:
	fmov	%f8, %f7
fjne_cont.42429:
	fneg	%f8, %f8
	slli	%g3, %g3, 2
	add	%g26, %g4, %g3
	fst	%f8, %g26, 0
	jmp	jeq_cont.42427
jeq_else.42426:
	addi	%g11, %g0, 2
	jne	%g12, %g11, jeq_else.42432
	ld	%g3, %g10, -16
	fld	%f7, %g3, 0
	fneg	%f7, %f7
	ld	%g4, %g1, 40
	fst	%f7, %g4, 0
	fld	%f7, %g3, -4
	fneg	%f7, %f7
	fst	%f7, %g4, -4
	fld	%f7, %g3, -8
	fneg	%f7, %f7
	fst	%f7, %g4, -8
	jmp	jeq_cont.42433
jeq_else.42432:
	ld	%g11, %g1, 36
	fld	%f0, %g11, 0
	ld	%g12, %g10, -20
	fld	%f1, %g12, 0
	fsub	%f0, %f0, %f1
	fld	%f1, %g11, -4
	fld	%f10, %g12, -4
	fsub	%f1, %f1, %f10
	fld	%f10, %g11, -8
	fld	%f11, %g12, -8
	fsub	%f10, %f10, %f11
	ld	%g12, %g10, -16
	fld	%f11, %g12, 0
	fmul	%f11, %f0, %f11
	fld	%f12, %g12, -4
	fmul	%f12, %f1, %f12
	fld	%f13, %g12, -8
	fmul	%f13, %f10, %f13
	ld	%g12, %g10, -12
	jne	%g12, %g0, jeq_else.42434
	ld	%g12, %g1, 40
	fst	%f11, %g12, 0
	fst	%f12, %g12, -4
	fst	%f13, %g12, -8
	jmp	jeq_cont.42435
jeq_else.42434:
	ld	%g12, %g10, -36
	fld	%f14, %g12, -8
	fmul	%f14, %f1, %f14
	fld	%f15, %g12, -4
	fmul	%f15, %f10, %f15
	fadd	%f14, %f14, %f15
	fmov	%f15, %f19
	fmul	%f14, %f14, %f15
	fadd	%f11, %f11, %f14
	ld	%g13, %g1, 40
	fst	%f11, %g13, 0
	fld	%f11, %g12, -8
	fmul	%f11, %f0, %f11
	fld	%f14, %g12, 0
	fmul	%f10, %f10, %f14
	fadd	%f10, %f11, %f10
	fmul	%f10, %f10, %f15
	fadd	%f10, %f12, %f10
	fst	%f10, %g13, -4
	fld	%f10, %g12, -4
	fmul	%f0, %f0, %f10
	fld	%f10, %g12, 0
	fmul	%f1, %f1, %f10
	fadd	%f0, %f0, %f1
	fmul	%f0, %f0, %f15
	fadd	%f0, %f13, %f0
	fst	%f0, %g13, -8
jeq_cont.42435:
	ld	%g12, %g10, -24
	ld	%g13, %g1, 40
	fld	%f0, %g13, 0
	fmul	%f1, %f0, %f0
	fld	%f10, %g13, -4
	fmul	%f10, %f10, %f10
	fadd	%f1, %f1, %f10
	fld	%f10, %g13, -8
	fmul	%f10, %f10, %f10
	fadd	%f1, %f1, %f10
	fst	%f0, %g1, 68
	fsqrt	%f7, %f1
	fld	%f8, %g1, 44
	fjeq	%f7, %f8, fjne_else.42436
	jne	%g12, %g0, jeq_else.42438
	fmov	%f9, %f17
	fdiv	%f7, %f9, %f7
	jmp	jeq_cont.42439
jeq_else.42438:
	fmov	%f9, %f18
	fdiv	%f7, %f9, %f7
jeq_cont.42439:
	jmp	fjne_cont.42437
fjne_else.42436:
	setL %g3, l.34374
	fld	%f7, %g3, 0
fjne_cont.42437:
	fld	%f9, %g1, 68
	fmul	%f9, %f9, %f7
	fst	%f9, %g13, 0
	fld	%f9, %g13, -4
	fmul	%f9, %f9, %f7
	fst	%f9, %g13, -4
	fld	%f9, %g13, -8
	fmul	%f7, %f9, %f7
	fst	%f7, %g13, -8
jeq_cont.42433:
jeq_cont.42427:
	ld	%g3, %g1, 36
	st	%g10, %g1, 72
	mov	%g4, %g3
	mov	%g3, %g10
	subi	%g1, %g1, 80
	call	utexture.2883
	addi	%g1, %g1, 80
	addi	%g3, %g0, 0
	ld	%g4, %g1, 32
	ld	%g4, %g4, 0
	subi	%g1, %g1, 80
	call	shadow_check_one_or_matrix.2843
	addi	%g1, %g1, 80
	jne	%g3, %g0, jeq_else.42440
	ld	%g3, %g1, 40
	fld	%f0, %g3, 0
	ld	%g4, %g1, 28
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g3, -4
	fld	%f2, %g4, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, -8
	fld	%f2, %g4, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fneg	%f0, %f0
	fld	%f1, %g1, 44
	fjlt	%f1, %f0, fjge_else.42442
	fmov	%f0, %f1
	jmp	fjge_cont.42443
fjge_else.42442:
fjge_cont.42443:
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 72
	ld	%g3, %g3, -28
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 20
	fld	%f1, %g3, 0
	ld	%g4, %g1, 16
	fld	%f2, %g4, 0
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g3, 0
	fld	%f1, %g3, -4
	fld	%f2, %g4, -4
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g3, -4
	fld	%f1, %g3, -8
	fld	%f2, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fst	%f0, %g3, -8
	jmp	jeq_cont.42441
jeq_else.42440:
jeq_cont.42441:
jeq_cont.42425:
	jmp	fjge_cont.42419
fjge_else.42418:
	addi	%g17, %g6, 1
	slli	%g17, %g17, 2
	add	%g26, %g3, %g17
	ld	%g17, %g26, 0
	setL %g18, l.37258
	fld	%f2, %g18, 0
	fdiv	%f0, %f0, %f2
	fmov	%f2, %f29
	fst	%f2, %g7, 0
	addi	%g18, %g0, 0
	ld	%g19, %g8, 0
	st	%g16, %g1, 16
	st	%g15, %g1, 20
	fst	%f0, %g1, 76
	st	%g14, %g1, 28
	st	%g8, %g1, 32
	st	%g13, %g1, 36
	st	%g12, %g1, 40
	fst	%f1, %g1, 44
	st	%g11, %g1, 48
	st	%g17, %g1, 80
	st	%g10, %g1, 56
	st	%g9, %g1, 60
	st	%g7, %g1, 64
	mov	%g5, %g17
	mov	%g4, %g19
	mov	%g3, %g18
	subi	%g1, %g1, 88
	call	trace_or_matrix_fast.2868
	addi	%g1, %g1, 88
	ld	%g10, %g1, 64
	fld	%f0, %g10, 0
	fmov	%f1, %f27
	fjlt	%f1, %f0, fjge_else.42444
	addi	%g10, %g0, 0
	jmp	fjge_cont.42445
fjge_else.42444:
	setL %g10, l.36922
	fld	%f1, %g10, 0
	fjlt	%f0, %f1, fjge_else.42446
	addi	%g10, %g0, 0
	jmp	fjge_cont.42447
fjge_else.42446:
	addi	%g10, %g0, 1
fjge_cont.42447:
fjge_cont.42445:
	jne	%g10, %g0, jeq_else.42448
	jmp	jeq_cont.42449
jeq_else.42448:
	ld	%g10, %g1, 60
	ld	%g10, %g10, 0
	slli	%g10, %g10, 2
	ld	%g11, %g1, 56
	add	%g26, %g11, %g10
	ld	%g10, %g26, 0
	ld	%g11, %g1, 80
	ld	%g11, %g11, 0
	ld	%g12, %g10, -4
	jne	%g12, %g28, jeq_else.42450
	ld	%g3, %g1, 48
	ld	%g3, %g3, 0
	ld	%g4, %g1, 40
	fld	%f7, %g1, 44
	fst	%f7, %g4, 0
	fst	%f7, %g4, -4
	fst	%f7, %g4, -8
	subi	%g3, %g3, 1
	slli	%g15, %g3, 2
	add	%g26, %g11, %g15
	fld	%f8, %g26, 0
	fjeq	%f8, %f7, fjne_else.42452
	fjlt	%f7, %f8, fjge_else.42454
	setL %g15, l.35516
	fld	%f8, %g15, 0
	jmp	fjge_cont.42455
fjge_else.42454:
	setL %g15, l.34374
	fld	%f8, %g15, 0
fjge_cont.42455:
	jmp	fjne_cont.42453
fjne_else.42452:
	fmov	%f8, %f7
fjne_cont.42453:
	fneg	%f8, %f8
	slli	%g3, %g3, 2
	add	%g26, %g4, %g3
	fst	%f8, %g26, 0
	jmp	jeq_cont.42451
jeq_else.42450:
	addi	%g11, %g0, 2
	jne	%g12, %g11, jeq_else.42456
	ld	%g3, %g10, -16
	fld	%f7, %g3, 0
	fneg	%f7, %f7
	ld	%g4, %g1, 40
	fst	%f7, %g4, 0
	fld	%f7, %g3, -4
	fneg	%f7, %f7
	fst	%f7, %g4, -4
	fld	%f7, %g3, -8
	fneg	%f7, %f7
	fst	%f7, %g4, -8
	jmp	jeq_cont.42457
jeq_else.42456:
	ld	%g11, %g1, 36
	fld	%f0, %g11, 0
	ld	%g12, %g10, -20
	fld	%f1, %g12, 0
	fsub	%f0, %f0, %f1
	fld	%f1, %g11, -4
	fld	%f10, %g12, -4
	fsub	%f1, %f1, %f10
	fld	%f10, %g11, -8
	fld	%f11, %g12, -8
	fsub	%f10, %f10, %f11
	ld	%g12, %g10, -16
	fld	%f11, %g12, 0
	fmul	%f11, %f0, %f11
	fld	%f12, %g12, -4
	fmul	%f12, %f1, %f12
	fld	%f13, %g12, -8
	fmul	%f13, %f10, %f13
	ld	%g12, %g10, -12
	jne	%g12, %g0, jeq_else.42458
	ld	%g12, %g1, 40
	fst	%f11, %g12, 0
	fst	%f12, %g12, -4
	fst	%f13, %g12, -8
	jmp	jeq_cont.42459
jeq_else.42458:
	ld	%g12, %g10, -36
	fld	%f14, %g12, -8
	fmul	%f14, %f1, %f14
	fld	%f15, %g12, -4
	fmul	%f15, %f10, %f15
	fadd	%f14, %f14, %f15
	fmov	%f15, %f19
	fmul	%f14, %f14, %f15
	fadd	%f11, %f11, %f14
	ld	%g13, %g1, 40
	fst	%f11, %g13, 0
	fld	%f11, %g12, -8
	fmul	%f11, %f0, %f11
	fld	%f14, %g12, 0
	fmul	%f10, %f10, %f14
	fadd	%f10, %f11, %f10
	fmul	%f10, %f10, %f15
	fadd	%f10, %f12, %f10
	fst	%f10, %g13, -4
	fld	%f10, %g12, -4
	fmul	%f0, %f0, %f10
	fld	%f10, %g12, 0
	fmul	%f1, %f1, %f10
	fadd	%f0, %f0, %f1
	fmul	%f0, %f0, %f15
	fadd	%f0, %f13, %f0
	fst	%f0, %g13, -8
jeq_cont.42459:
	ld	%g12, %g10, -24
	ld	%g13, %g1, 40
	fld	%f0, %g13, 0
	fmul	%f1, %f0, %f0
	fld	%f10, %g13, -4
	fmul	%f10, %f10, %f10
	fadd	%f1, %f1, %f10
	fld	%f10, %g13, -8
	fmul	%f10, %f10, %f10
	fadd	%f1, %f1, %f10
	fst	%f0, %g1, 84
	fsqrt	%f7, %f1
	fld	%f8, %g1, 44
	fjeq	%f7, %f8, fjne_else.42460
	jne	%g12, %g0, jeq_else.42462
	fmov	%f9, %f17
	fdiv	%f7, %f9, %f7
	jmp	jeq_cont.42463
jeq_else.42462:
	fmov	%f9, %f18
	fdiv	%f7, %f9, %f7
jeq_cont.42463:
	jmp	fjne_cont.42461
fjne_else.42460:
	setL %g3, l.34374
	fld	%f7, %g3, 0
fjne_cont.42461:
	fld	%f9, %g1, 84
	fmul	%f9, %f9, %f7
	fst	%f9, %g13, 0
	fld	%f9, %g13, -4
	fmul	%f9, %f9, %f7
	fst	%f9, %g13, -4
	fld	%f9, %g13, -8
	fmul	%f7, %f9, %f7
	fst	%f7, %g13, -8
jeq_cont.42457:
jeq_cont.42451:
	ld	%g3, %g1, 36
	st	%g10, %g1, 88
	mov	%g4, %g3
	mov	%g3, %g10
	subi	%g1, %g1, 96
	call	utexture.2883
	addi	%g1, %g1, 96
	addi	%g3, %g0, 0
	ld	%g4, %g1, 32
	ld	%g4, %g4, 0
	subi	%g1, %g1, 96
	call	shadow_check_one_or_matrix.2843
	addi	%g1, %g1, 96
	jne	%g3, %g0, jeq_else.42464
	ld	%g3, %g1, 40
	fld	%f0, %g3, 0
	ld	%g4, %g1, 28
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g3, -4
	fld	%f2, %g4, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, -8
	fld	%f2, %g4, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fneg	%f0, %f0
	fld	%f1, %g1, 44
	fjlt	%f1, %f0, fjge_else.42466
	fmov	%f0, %f1
	jmp	fjge_cont.42467
fjge_else.42466:
fjge_cont.42467:
	fld	%f1, %g1, 76
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 88
	ld	%g3, %g3, -28
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 20
	fld	%f1, %g3, 0
	ld	%g4, %g1, 16
	fld	%f2, %g4, 0
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g3, 0
	fld	%f1, %g3, -4
	fld	%f2, %g4, -4
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g3, -4
	fld	%f1, %g3, -8
	fld	%f2, %g4, -8
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fst	%f0, %g3, -8
	jmp	jeq_cont.42465
jeq_else.42464:
jeq_cont.42465:
jeq_cont.42449:
fjge_cont.42419:
	ld	%g3, %g1, 12
	subi	%g3, %g3, 2
	ld	%g4, %g1, 8
	ld	%g5, %g1, 4
	ld	%g6, %g1, 0
	mov	%g26, %g6
	mov	%g6, %g3
	mov	%g3, %g4
	mov	%g4, %g5
	mov	%g5, %g26
	jmp	iter_trace_diffuse_rays.2904
jge_else.42417:
	return
do_without_neighbors.2926:
	ld	%g10, %g31, 764
	ld	%g11, %g31, 708
	ld	%g12, %g31, 740
	ld	%g13, %g31, 828
	ld	%g14, %g31, 760
	addi	%g15, %g0, 4
	jlt	%g15, %g4, jle_else.42469
	ld	%g15, %g3, -8
	slli	%g16, %g4, 2
	add	%g26, %g15, %g16
	ld	%g15, %g26, 0
	jlt	%g15, %g0, jge_else.42470
	ld	%g15, %g3, -12
	slli	%g16, %g4, 2
	add	%g26, %g15, %g16
	ld	%g15, %g26, 0
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	jne	%g15, %g0, jeq_else.42471
	jmp	jeq_cont.42472
jeq_else.42471:
	ld	%g15, %g3, -20
	ld	%g16, %g3, -28
	ld	%g17, %g3, -4
	ld	%g18, %g3, -16
	slli	%g19, %g4, 2
	add	%g26, %g15, %g19
	ld	%g15, %g26, 0
	fld	%f10, %g15, 0
	fst	%f10, %g10, 0
	fld	%f10, %g15, -4
	fst	%f10, %g10, -4
	fld	%f10, %g15, -8
	fst	%f10, %g10, -8
	ld	%g15, %g3, -24
	ld	%g15, %g15, 0
	slli	%g19, %g4, 2
	add	%g26, %g16, %g19
	ld	%g16, %g26, 0
	slli	%g19, %g4, 2
	add	%g26, %g17, %g19
	ld	%g17, %g26, 0
	st	%g10, %g1, 8
	st	%g14, %g1, 12
	st	%g18, %g1, 16
	st	%g16, %g1, 20
	st	%g13, %g1, 24
	st	%g12, %g1, 28
	st	%g17, %g1, 32
	st	%g11, %g1, 36
	st	%g15, %g1, 40
	jne	%g15, %g0, jeq_else.42473
	jmp	jeq_cont.42474
jeq_else.42473:
	ld	%g19, %g11, 0
	fld	%f10, %g17, 0
	fst	%f10, %g12, 0
	fld	%f10, %g17, -4
	fst	%f10, %g12, -4
	fld	%f10, %g17, -8
	fst	%f10, %g12, -8
	ld	%g20, %g13, 0
	subi	%g20, %g20, 1
	mov	%g4, %g20
	mov	%g3, %g17
	subi	%g1, %g1, 48
	call	setup_startp_constants.2806
	addi	%g1, %g1, 48
	addi	%g3, %g0, 118
	mov	%g6, %g3
	mov	%g5, %g17
	mov	%g4, %g16
	mov	%g3, %g19
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2904
	addi	%g1, %g1, 48
jeq_cont.42474:
	ld	%g3, %g1, 40
	jne	%g3, %g28, jeq_else.42475
	jmp	jeq_cont.42476
jeq_else.42475:
	ld	%g4, %g1, 36
	ld	%g10, %g4, -4
	ld	%g11, %g1, 32
	fld	%f10, %g11, 0
	ld	%g12, %g1, 28
	fst	%f10, %g12, 0
	fld	%f10, %g11, -4
	fst	%f10, %g12, -4
	fld	%f10, %g11, -8
	fst	%f10, %g12, -8
	ld	%g13, %g1, 24
	ld	%g14, %g13, 0
	subi	%g14, %g14, 1
	mov	%g4, %g14
	mov	%g3, %g11
	subi	%g1, %g1, 48
	call	setup_startp_constants.2806
	addi	%g1, %g1, 48
	addi	%g3, %g0, 118
	ld	%g4, %g1, 20
	mov	%g6, %g3
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2904
	addi	%g1, %g1, 48
jeq_cont.42476:
	addi	%g3, %g0, 2
	ld	%g4, %g1, 40
	jne	%g4, %g3, jeq_else.42477
	jmp	jeq_cont.42478
jeq_else.42477:
	ld	%g3, %g1, 36
	ld	%g10, %g3, -8
	ld	%g11, %g1, 32
	fld	%f10, %g11, 0
	ld	%g12, %g1, 28
	fst	%f10, %g12, 0
	fld	%f10, %g11, -4
	fst	%f10, %g12, -4
	fld	%f10, %g11, -8
	fst	%f10, %g12, -8
	ld	%g13, %g1, 24
	ld	%g14, %g13, 0
	subi	%g14, %g14, 1
	mov	%g4, %g14
	mov	%g3, %g11
	subi	%g1, %g1, 48
	call	setup_startp_constants.2806
	addi	%g1, %g1, 48
	addi	%g3, %g0, 118
	ld	%g4, %g1, 20
	mov	%g6, %g3
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2904
	addi	%g1, %g1, 48
jeq_cont.42478:
	addi	%g3, %g0, 3
	ld	%g4, %g1, 40
	jne	%g4, %g3, jeq_else.42479
	jmp	jeq_cont.42480
jeq_else.42479:
	ld	%g3, %g1, 36
	ld	%g10, %g3, -12
	ld	%g11, %g1, 32
	fld	%f10, %g11, 0
	ld	%g12, %g1, 28
	fst	%f10, %g12, 0
	fld	%f10, %g11, -4
	fst	%f10, %g12, -4
	fld	%f10, %g11, -8
	fst	%f10, %g12, -8
	ld	%g13, %g1, 24
	ld	%g14, %g13, 0
	subi	%g14, %g14, 1
	mov	%g4, %g14
	mov	%g3, %g11
	subi	%g1, %g1, 48
	call	setup_startp_constants.2806
	addi	%g1, %g1, 48
	addi	%g3, %g0, 118
	ld	%g4, %g1, 20
	mov	%g6, %g3
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 48
	call	iter_trace_diffuse_rays.2904
	addi	%g1, %g1, 48
jeq_cont.42480:
	addi	%g3, %g0, 4
	ld	%g4, %g1, 40
	jne	%g4, %g3, jeq_else.42481
	jmp	jeq_cont.42482
jeq_else.42481:
	ld	%g3, %g1, 36
	ld	%g3, %g3, -16
	ld	%g4, %g1, 32
	fld	%f10, %g4, 0
	ld	%g10, %g1, 28
	fst	%f10, %g10, 0
	fld	%f10, %g4, -4
	fst	%f10, %g10, -4
	fld	%f10, %g4, -8
	fst	%f10, %g10, -8
	ld	%g10, %g1, 24
	ld	%g10, %g10, 0
	subi	%g10, %g10, 1
	st	%g3, %g1, 44
	mov	%g3, %g4
	mov	%g4, %g10
	subi	%g1, %g1, 52
	call	setup_startp_constants.2806
	addi	%g1, %g1, 52
	addi	%g3, %g0, 118
	ld	%g4, %g1, 44
	ld	%g5, %g1, 20
	ld	%g6, %g1, 32
	mov	%g26, %g6
	mov	%g6, %g3
	mov	%g3, %g4
	mov	%g4, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 52
	call	iter_trace_diffuse_rays.2904
	addi	%g1, %g1, 52
jeq_cont.42482:
	ld	%g3, %g1, 4
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	add	%g26, %g5, %g4
	ld	%g4, %g26, 0
	ld	%g5, %g1, 12
	fld	%f0, %g5, 0
	fld	%f1, %g4, 0
	ld	%g6, %g1, 8
	fld	%f2, %g6, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g5, 0
	fld	%f0, %g5, -4
	fld	%f1, %g4, -4
	fld	%f2, %g6, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g5, -4
	fld	%f0, %g5, -8
	fld	%f1, %g4, -8
	fld	%f2, %g6, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g5, -8
jeq_cont.42472:
	ld	%g3, %g1, 4
	addi	%g3, %g3, 1
	ld	%g4, %g1, 0
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	jmp	do_without_neighbors.2926
jge_else.42470:
	return
jle_else.42469:
	return
try_exploit_neighbors.2942:
	ld	%g9, %g31, 764
	ld	%g10, %g31, 760
	slli	%g11, %g3, 2
	add	%g26, %g6, %g11
	ld	%g11, %g26, 0
	addi	%g12, %g0, 4
	jlt	%g12, %g8, jle_else.42485
	ld	%g12, %g11, -8
	slli	%g13, %g8, 2
	add	%g26, %g12, %g13
	ld	%g12, %g26, 0
	jlt	%g12, %g0, jge_else.42486
	slli	%g13, %g3, 2
	add	%g26, %g5, %g13
	ld	%g13, %g26, 0
	ld	%g14, %g13, -8
	slli	%g15, %g8, 2
	add	%g26, %g14, %g15
	ld	%g14, %g26, 0
	jne	%g14, %g12, jeq_else.42487
	slli	%g14, %g3, 2
	add	%g26, %g7, %g14
	ld	%g14, %g26, 0
	ld	%g14, %g14, -8
	slli	%g15, %g8, 2
	add	%g26, %g14, %g15
	ld	%g14, %g26, 0
	jne	%g14, %g12, jeq_else.42489
	subi	%g14, %g3, 1
	slli	%g14, %g14, 2
	add	%g26, %g6, %g14
	ld	%g14, %g26, 0
	ld	%g14, %g14, -8
	slli	%g15, %g8, 2
	add	%g26, %g14, %g15
	ld	%g14, %g26, 0
	jne	%g14, %g12, jeq_else.42491
	addi	%g14, %g3, 1
	slli	%g14, %g14, 2
	add	%g26, %g6, %g14
	ld	%g14, %g26, 0
	ld	%g14, %g14, -8
	slli	%g15, %g8, 2
	add	%g26, %g14, %g15
	ld	%g14, %g26, 0
	jne	%g14, %g12, jeq_else.42493
	addi	%g12, %g0, 1
	jmp	jeq_cont.42494
jeq_else.42493:
	addi	%g12, %g0, 0
jeq_cont.42494:
	jmp	jeq_cont.42492
jeq_else.42491:
	addi	%g12, %g0, 0
jeq_cont.42492:
	jmp	jeq_cont.42490
jeq_else.42489:
	addi	%g12, %g0, 0
jeq_cont.42490:
	jmp	jeq_cont.42488
jeq_else.42487:
	addi	%g12, %g0, 0
jeq_cont.42488:
	jne	%g12, %g0, jeq_else.42495
	slli	%g3, %g3, 2
	add	%g26, %g6, %g3
	ld	%g3, %g26, 0
	mov	%g4, %g8
	jmp	do_without_neighbors.2926
jeq_else.42495:
	ld	%g12, %g11, -12
	slli	%g14, %g8, 2
	add	%g26, %g12, %g14
	ld	%g12, %g26, 0
	jne	%g12, %g0, jeq_else.42496
	jmp	jeq_cont.42497
jeq_else.42496:
	ld	%g12, %g13, -20
	subi	%g13, %g3, 1
	slli	%g13, %g13, 2
	add	%g26, %g6, %g13
	ld	%g13, %g26, 0
	ld	%g13, %g13, -20
	ld	%g11, %g11, -20
	addi	%g14, %g3, 1
	slli	%g14, %g14, 2
	add	%g26, %g6, %g14
	ld	%g14, %g26, 0
	ld	%g14, %g14, -20
	slli	%g15, %g3, 2
	add	%g26, %g7, %g15
	ld	%g15, %g26, 0
	ld	%g15, %g15, -20
	slli	%g16, %g8, 2
	add	%g26, %g12, %g16
	ld	%g12, %g26, 0
	fld	%f0, %g12, 0
	fst	%f0, %g9, 0
	fld	%f0, %g12, -4
	fst	%f0, %g9, -4
	fld	%f0, %g12, -8
	fst	%f0, %g9, -8
	slli	%g12, %g8, 2
	add	%g26, %g13, %g12
	ld	%g12, %g26, 0
	fld	%f0, %g9, 0
	fld	%f1, %g12, 0
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, 0
	fld	%f0, %g9, -4
	fld	%f1, %g12, -4
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, -4
	fld	%f0, %g9, -8
	fld	%f1, %g12, -8
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, -8
	slli	%g12, %g8, 2
	add	%g26, %g11, %g12
	ld	%g11, %g26, 0
	fld	%f0, %g9, 0
	fld	%f1, %g11, 0
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, 0
	fld	%f0, %g9, -4
	fld	%f1, %g11, -4
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, -4
	fld	%f0, %g9, -8
	fld	%f1, %g11, -8
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, -8
	slli	%g11, %g8, 2
	add	%g26, %g14, %g11
	ld	%g11, %g26, 0
	fld	%f0, %g9, 0
	fld	%f1, %g11, 0
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, 0
	fld	%f0, %g9, -4
	fld	%f1, %g11, -4
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, -4
	fld	%f0, %g9, -8
	fld	%f1, %g11, -8
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, -8
	slli	%g11, %g8, 2
	add	%g26, %g15, %g11
	ld	%g11, %g26, 0
	fld	%f0, %g9, 0
	fld	%f1, %g11, 0
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, 0
	fld	%f0, %g9, -4
	fld	%f1, %g11, -4
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, -4
	fld	%f0, %g9, -8
	fld	%f1, %g11, -8
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, -8
	slli	%g11, %g3, 2
	add	%g26, %g6, %g11
	ld	%g11, %g26, 0
	ld	%g11, %g11, -16
	slli	%g12, %g8, 2
	add	%g26, %g11, %g12
	ld	%g11, %g26, 0
	fld	%f0, %g10, 0
	fld	%f1, %g11, 0
	fld	%f2, %g9, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g10, 0
	fld	%f0, %g10, -4
	fld	%f1, %g11, -4
	fld	%f2, %g9, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g10, -4
	fld	%f0, %g10, -8
	fld	%f1, %g11, -8
	fld	%f2, %g9, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g10, -8
jeq_cont.42497:
	addi	%g8, %g8, 1
	jmp	try_exploit_neighbors.2942
jge_else.42486:
	return
jle_else.42485:
	return
pretrace_diffuse_rays.2955:
	ld	%g10, %g31, 764
	ld	%g11, %g31, 708
	ld	%g12, %g31, 740
	ld	%g13, %g31, 828
	addi	%g14, %g0, 4
	jlt	%g14, %g4, jle_else.42500
	ld	%g14, %g3, -8
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	ld	%g15, %g26, 0
	jlt	%g15, %g0, jge_else.42501
	ld	%g15, %g3, -12
	slli	%g16, %g4, 2
	add	%g26, %g15, %g16
	ld	%g16, %g26, 0
	st	%g13, %g1, 0
	st	%g12, %g1, 4
	st	%g11, %g1, 8
	st	%g10, %g1, 12
	st	%g15, %g1, 16
	st	%g14, %g1, 20
	st	%g4, %g1, 24
	jne	%g16, %g0, jeq_else.42502
	jmp	jeq_cont.42503
jeq_else.42502:
	ld	%g16, %g3, -24
	ld	%g16, %g16, 0
	fmov	%f10, %f16
	fst	%f10, %g10, 0
	fst	%f10, %g10, -4
	fst	%f10, %g10, -8
	ld	%g17, %g3, -28
	ld	%g18, %g3, -4
	slli	%g16, %g16, 2
	add	%g26, %g11, %g16
	ld	%g16, %g26, 0
	slli	%g19, %g4, 2
	add	%g26, %g17, %g19
	ld	%g17, %g26, 0
	slli	%g19, %g4, 2
	add	%g26, %g18, %g19
	ld	%g18, %g26, 0
	fld	%f10, %g18, 0
	fst	%f10, %g12, 0
	fld	%f10, %g18, -4
	fst	%f10, %g12, -4
	fld	%f10, %g18, -8
	fst	%f10, %g12, -8
	ld	%g19, %g13, 0
	subi	%g19, %g19, 1
	st	%g3, %g1, 28
	mov	%g4, %g19
	mov	%g3, %g18
	subi	%g1, %g1, 36
	call	setup_startp_constants.2806
	addi	%g1, %g1, 36
	addi	%g3, %g0, 118
	mov	%g6, %g3
	mov	%g5, %g18
	mov	%g4, %g17
	mov	%g3, %g16
	subi	%g1, %g1, 36
	call	iter_trace_diffuse_rays.2904
	addi	%g1, %g1, 36
	ld	%g3, %g1, 28
	ld	%g4, %g3, -20
	ld	%g10, %g1, 24
	slli	%g11, %g10, 2
	add	%g26, %g4, %g11
	ld	%g4, %g26, 0
	ld	%g11, %g1, 12
	fld	%f10, %g11, 0
	fst	%f10, %g4, 0
	fld	%f10, %g11, -4
	fst	%f10, %g4, -4
	fld	%f10, %g11, -8
	fst	%f10, %g4, -8
jeq_cont.42503:
	ld	%g4, %g1, 24
	addi	%g4, %g4, 1
	addi	%g10, %g0, 4
	jlt	%g10, %g4, jle_else.42504
	slli	%g10, %g4, 2
	ld	%g11, %g1, 20
	add	%g26, %g11, %g10
	ld	%g10, %g26, 0
	jlt	%g10, %g0, jge_else.42505
	slli	%g10, %g4, 2
	ld	%g11, %g1, 16
	add	%g26, %g11, %g10
	ld	%g10, %g26, 0
	st	%g4, %g1, 32
	jne	%g10, %g0, jeq_else.42506
	jmp	jeq_cont.42507
jeq_else.42506:
	ld	%g10, %g3, -24
	ld	%g10, %g10, 0
	fmov	%f10, %f16
	ld	%g11, %g1, 12
	fst	%f10, %g11, 0
	fst	%f10, %g11, -4
	fst	%f10, %g11, -8
	ld	%g12, %g3, -28
	ld	%g13, %g3, -4
	slli	%g10, %g10, 2
	ld	%g14, %g1, 8
	add	%g26, %g14, %g10
	ld	%g10, %g26, 0
	slli	%g14, %g4, 2
	add	%g26, %g12, %g14
	ld	%g12, %g26, 0
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	ld	%g13, %g26, 0
	fld	%f10, %g13, 0
	ld	%g14, %g1, 4
	fst	%f10, %g14, 0
	fld	%f10, %g13, -4
	fst	%f10, %g14, -4
	fld	%f10, %g13, -8
	fst	%f10, %g14, -8
	ld	%g14, %g1, 0
	ld	%g14, %g14, 0
	subi	%g14, %g14, 1
	st	%g3, %g1, 28
	mov	%g4, %g14
	mov	%g3, %g13
	subi	%g1, %g1, 40
	call	setup_startp_constants.2806
	addi	%g1, %g1, 40
	addi	%g3, %g0, 118
	mov	%g6, %g3
	mov	%g5, %g13
	mov	%g4, %g12
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	iter_trace_diffuse_rays.2904
	addi	%g1, %g1, 40
	ld	%g3, %g1, 28
	ld	%g4, %g3, -20
	ld	%g5, %g1, 32
	slli	%g6, %g5, 2
	add	%g26, %g4, %g6
	ld	%g4, %g26, 0
	ld	%g6, %g1, 12
	fld	%f0, %g6, 0
	fst	%f0, %g4, 0
	fld	%f0, %g6, -4
	fst	%f0, %g4, -4
	fld	%f0, %g6, -8
	fst	%f0, %g4, -8
jeq_cont.42507:
	ld	%g4, %g1, 32
	addi	%g4, %g4, 1
	jmp	pretrace_diffuse_rays.2955
jge_else.42505:
	return
jle_else.42504:
	return
jge_else.42501:
	return
jle_else.42500:
	return
pretrace_pixels.2958:
	ld	%g10, %g31, 748
	ld	%g11, %g31, 752
	ld	%g12, %g31, 736
	ld	%g13, %g31, 724
	ld	%g14, %g31, 760
	ld	%g15, %g31, 812
	ld	%g16, %g31, 744
	ld	%g17, %g31, 764
	ld	%g18, %g31, 708
	ld	%g19, %g31, 740
	ld	%g20, %g31, 828
	jlt	%g4, %g0, jge_else.42512
	fld	%f10, %g10, 0
	ld	%g10, %g11, 0
	sub	%g10, %g4, %g10
	st	%g5, %g1, 0
	st	%g3, %g1, 4
	st	%g4, %g1, 8
	fst	%f2, %g1, 12
	fst	%f1, %g1, 16
	fst	%f0, %g1, 20
	mov	%g3, %g10
	subi	%g1, %g1, 28
	call	min_caml_float_of_int
	addi	%g1, %g1, 28
	fmul	%f0, %f10, %f0
	fld	%f1, %g12, 0
	fmul	%f1, %f0, %f1
	fld	%f10, %g1, 20
	fadd	%f1, %f1, %f10
	fst	%f1, %g13, 0
	fld	%f1, %g12, -4
	fmul	%f1, %f0, %f1
	fld	%f11, %g1, 16
	fadd	%f1, %f1, %f11
	fst	%f1, %g13, -4
	fld	%f1, %g12, -8
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 12
	fadd	%f0, %f0, %f1
	fst	%f0, %g13, -8
	fld	%f0, %g13, 0
	fmul	%f12, %f0, %f0
	fld	%f13, %g13, -4
	fmul	%f13, %f13, %f13
	fadd	%f12, %f12, %f13
	fld	%f13, %g13, -8
	fmul	%f13, %f13, %f13
	fadd	%f12, %f12, %f13
	fst	%f0, %g1, 24
	fsqrt	%f0, %f12
	fmov	%f2, %f16
	fjeq	%f0, %f2, fjne_else.42513
	fmov	%f3, %f17
	fdiv	%f0, %f3, %f0
	jmp	fjne_cont.42514
fjne_else.42513:
	setL %g3, l.34374
	fld	%f0, %g3, 0
fjne_cont.42514:
	fld	%f3, %g1, 24
	fmul	%f3, %f3, %f0
	fst	%f3, %g13, 0
	fld	%f3, %g13, -4
	fmul	%f3, %f3, %f0
	fst	%f3, %g13, -4
	fld	%f3, %g13, -8
	fmul	%f0, %f3, %f0
	fst	%f0, %g13, -8
	fst	%f2, %g14, 0
	fst	%f2, %g14, -4
	fst	%f2, %g14, -8
	fld	%f0, %g15, 0
	fst	%f0, %g16, 0
	fld	%f0, %g15, -4
	fst	%f0, %g16, -4
	fld	%f0, %g15, -8
	fst	%f0, %g16, -8
	addi	%g3, %g0, 0
	fmov	%f0, %f17
	ld	%g4, %g1, 8
	slli	%g5, %g4, 2
	ld	%g6, %g1, 4
	add	%g26, %g6, %g5
	ld	%g5, %g26, 0
	st	%g20, %g1, 28
	st	%g19, %g1, 32
	st	%g18, %g1, 36
	st	%g17, %g1, 40
	fst	%f2, %g1, 44
	st	%g14, %g1, 48
	mov	%g4, %g13
	fmov	%f1, %f2
	subi	%g1, %g1, 56
	call	trace_ray.2895
	addi	%g1, %g1, 56
	ld	%g3, %g1, 8
	slli	%g4, %g3, 2
	ld	%g10, %g1, 4
	add	%g26, %g10, %g4
	ld	%g4, %g26, 0
	ld	%g4, %g4, 0
	ld	%g11, %g1, 48
	fld	%f10, %g11, 0
	fst	%f10, %g4, 0
	fld	%f10, %g11, -4
	fst	%f10, %g4, -4
	fld	%f10, %g11, -8
	fst	%f10, %g4, -8
	slli	%g4, %g3, 2
	add	%g26, %g10, %g4
	ld	%g4, %g26, 0
	ld	%g4, %g4, -24
	ld	%g11, %g1, 0
	st	%g11, %g4, 0
	slli	%g4, %g3, 2
	add	%g26, %g10, %g4
	ld	%g4, %g26, 0
	ld	%g12, %g4, -8
	ld	%g12, %g12, 0
	jlt	%g12, %g0, jge_else.42515
	ld	%g12, %g4, -12
	ld	%g12, %g12, 0
	st	%g4, %g1, 52
	jne	%g12, %g0, jeq_else.42517
	jmp	jeq_cont.42518
jeq_else.42517:
	ld	%g12, %g4, -24
	ld	%g12, %g12, 0
	ld	%g13, %g1, 40
	fld	%f10, %g1, 44
	fst	%f10, %g13, 0
	fst	%f10, %g13, -4
	fst	%f10, %g13, -8
	ld	%g14, %g4, -28
	ld	%g15, %g4, -4
	slli	%g12, %g12, 2
	ld	%g16, %g1, 36
	add	%g26, %g16, %g12
	ld	%g12, %g26, 0
	ld	%g14, %g14, 0
	ld	%g15, %g15, 0
	fld	%f10, %g15, 0
	ld	%g16, %g1, 32
	fst	%f10, %g16, 0
	fld	%f10, %g15, -4
	fst	%f10, %g16, -4
	fld	%f10, %g15, -8
	fst	%f10, %g16, -8
	ld	%g16, %g1, 28
	ld	%g16, %g16, 0
	subi	%g16, %g16, 1
	mov	%g4, %g16
	mov	%g3, %g15
	subi	%g1, %g1, 60
	call	setup_startp_constants.2806
	addi	%g1, %g1, 60
	addi	%g3, %g0, 118
	mov	%g6, %g3
	mov	%g5, %g15
	mov	%g4, %g14
	mov	%g3, %g12
	subi	%g1, %g1, 60
	call	iter_trace_diffuse_rays.2904
	addi	%g1, %g1, 60
	ld	%g3, %g1, 52
	ld	%g4, %g3, -20
	ld	%g4, %g4, 0
	ld	%g5, %g1, 40
	fld	%f0, %g5, 0
	fst	%f0, %g4, 0
	fld	%f0, %g5, -4
	fst	%f0, %g4, -4
	fld	%f0, %g5, -8
	fst	%f0, %g4, -8
jeq_cont.42518:
	addi	%g3, %g0, 1
	ld	%g4, %g1, 52
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 60
	call	pretrace_diffuse_rays.2955
	addi	%g1, %g1, 60
	jmp	jge_cont.42516
jge_else.42515:
jge_cont.42516:
	ld	%g3, %g1, 8
	subi	%g3, %g3, 1
	ld	%g4, %g1, 0
	addi	%g4, %g4, 1
	addi	%g5, %g0, 5
	jlt	%g4, %g5, jle_else.42519
	subi	%g4, %g4, 5
	jmp	jle_cont.42520
jle_else.42519:
jle_cont.42520:
	fld	%f0, %g1, 20
	fld	%f1, %g1, 16
	fld	%f2, %g1, 12
	ld	%g5, %g1, 4
	mov	%g26, %g5
	mov	%g5, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	jmp	pretrace_pixels.2958
jge_else.42512:
	return
scan_pixel.2969:
	ld	%g8, %g31, 756
	ld	%g9, %g31, 760
	ld	%g10, %g8, 0
	jlt	%g3, %g10, jle_else.42522
	return
jle_else.42522:
	slli	%g10, %g3, 2
	add	%g26, %g6, %g10
	ld	%g10, %g26, 0
	ld	%g10, %g10, 0
	fld	%f0, %g10, 0
	fst	%f0, %g9, 0
	fld	%f0, %g10, -4
	fst	%f0, %g9, -4
	fld	%f0, %g10, -8
	fst	%f0, %g9, -8
	ld	%g10, %g8, -4
	addi	%g11, %g4, 1
	jlt	%g11, %g10, jle_else.42524
	addi	%g8, %g0, 0
	jmp	jle_cont.42525
jle_else.42524:
	jlt	%g0, %g4, jle_else.42526
	addi	%g8, %g0, 0
	jmp	jle_cont.42527
jle_else.42526:
	ld	%g8, %g8, 0
	addi	%g10, %g3, 1
	jlt	%g10, %g8, jle_else.42528
	addi	%g8, %g0, 0
	jmp	jle_cont.42529
jle_else.42528:
	jlt	%g0, %g3, jle_else.42530
	addi	%g8, %g0, 0
	jmp	jle_cont.42531
jle_else.42530:
	addi	%g8, %g0, 1
jle_cont.42531:
jle_cont.42529:
jle_cont.42527:
jle_cont.42525:
	st	%g7, %g1, 0
	st	%g6, %g1, 4
	st	%g5, %g1, 8
	st	%g4, %g1, 12
	st	%g3, %g1, 16
	st	%g9, %g1, 20
	jne	%g8, %g0, jeq_else.42532
	slli	%g8, %g3, 2
	add	%g26, %g6, %g8
	ld	%g8, %g26, 0
	addi	%g10, %g0, 0
	mov	%g4, %g10
	mov	%g3, %g8
	subi	%g1, %g1, 28
	call	do_without_neighbors.2926
	addi	%g1, %g1, 28
	jmp	jeq_cont.42533
jeq_else.42532:
	addi	%g8, %g0, 0
	subi	%g1, %g1, 28
	call	try_exploit_neighbors.2942
	addi	%g1, %g1, 28
jeq_cont.42533:
	ld	%g10, %g1, 20
	fld	%f0, %g10, 0
	subi	%g1, %g1, 28
	call	min_caml_int_of_float
	addi	%g1, %g1, 28
	addi	%g13, %g0, 255
	jlt	%g13, %g3, jle_else.42534
	jlt	%g3, %g0, jge_else.42536
	jmp	jge_cont.42537
jge_else.42536:
	addi	%g3, %g0, 0
jge_cont.42537:
	jmp	jle_cont.42535
jle_else.42534:
	addi	%g3, %g0, 255
jle_cont.42535:
	subi	%g1, %g1, 28
	call	print_int.2528
	addi	%g1, %g1, 28
	addi	%g3, %g0, 32
	output	%g3
	ld	%g10, %g1, 20
	fld	%f0, %g10, -4
	subi	%g1, %g1, 28
	call	min_caml_int_of_float
	addi	%g1, %g1, 28
	addi	%g13, %g0, 255
	jlt	%g13, %g3, jle_else.42538
	jlt	%g3, %g0, jge_else.42540
	jmp	jge_cont.42541
jge_else.42540:
	addi	%g3, %g0, 0
jge_cont.42541:
	jmp	jle_cont.42539
jle_else.42538:
	addi	%g3, %g0, 255
jle_cont.42539:
	subi	%g1, %g1, 28
	call	print_int.2528
	addi	%g1, %g1, 28
	addi	%g3, %g0, 32
	output	%g3
	ld	%g10, %g1, 20
	fld	%f0, %g10, -8
	subi	%g1, %g1, 28
	call	min_caml_int_of_float
	addi	%g1, %g1, 28
	addi	%g13, %g0, 255
	jlt	%g13, %g3, jle_else.42542
	jlt	%g3, %g0, jge_else.42544
	jmp	jge_cont.42545
jge_else.42544:
	addi	%g3, %g0, 0
jge_cont.42545:
	jmp	jle_cont.42543
jle_else.42542:
	addi	%g3, %g0, 255
jle_cont.42543:
	subi	%g1, %g1, 28
	call	print_int.2528
	addi	%g1, %g1, 28
	addi	%g3, %g0, 10
	output	%g3
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	ld	%g4, %g1, 12
	ld	%g5, %g1, 8
	ld	%g6, %g1, 4
	ld	%g7, %g1, 0
	jmp	scan_pixel.2969
scan_line.2975:
	ld	%g10, %g31, 756
	ld	%g11, %g31, 748
	ld	%g12, %g31, 752
	ld	%g13, %g31, 732
	ld	%g14, %g31, 728
	ld	%g15, %g10, -4
	jlt	%g3, %g15, jle_else.42546
	return
jle_else.42546:
	subi	%g15, %g15, 1
	st	%g14, %g1, 0
	st	%g13, %g1, 4
	st	%g12, %g1, 8
	st	%g11, %g1, 12
	st	%g10, %g1, 16
	st	%g7, %g1, 20
	st	%g6, %g1, 24
	st	%g5, %g1, 28
	st	%g4, %g1, 32
	st	%g3, %g1, 36
	jlt	%g3, %g15, jle_else.42548
	jmp	jle_cont.42549
jle_else.42548:
	addi	%g15, %g3, 1
	fld	%f10, %g11, 0
	ld	%g16, %g12, -4
	sub	%g15, %g15, %g16
	mov	%g3, %g15
	subi	%g1, %g1, 44
	call	min_caml_float_of_int
	addi	%g1, %g1, 44
	fmul	%f0, %f10, %f0
	fld	%f1, %g13, 0
	fmul	%f1, %f0, %f1
	fld	%f2, %g14, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g13, -4
	fmul	%f2, %f0, %f2
	fld	%f3, %g14, -4
	fadd	%f2, %f2, %f3
	fld	%f3, %g13, -8
	fmul	%f0, %f0, %f3
	fld	%f3, %g14, -8
	fadd	%f0, %f0, %f3
	ld	%g3, %g10, 0
	subi	%g3, %g3, 1
	mov	%g5, %g7
	mov	%g4, %g3
	mov	%g3, %g6
	fmov	%f15, %f2
	fmov	%f2, %f0
	fmov	%f0, %f1
	fmov	%f1, %f15
	subi	%g1, %g1, 44
	call	pretrace_pixels.2958
	addi	%g1, %g1, 44
jle_cont.42549:
	addi	%g3, %g0, 0
	ld	%g4, %g1, 36
	ld	%g5, %g1, 32
	ld	%g6, %g1, 28
	ld	%g7, %g1, 24
	subi	%g1, %g1, 44
	call	scan_pixel.2969
	addi	%g1, %g1, 44
	ld	%g3, %g1, 36
	addi	%g3, %g3, 1
	ld	%g10, %g1, 20
	addi	%g10, %g10, 2
	addi	%g11, %g0, 5
	jlt	%g10, %g11, jle_else.42550
	subi	%g10, %g10, 5
	jmp	jle_cont.42551
jle_else.42550:
jle_cont.42551:
	ld	%g11, %g1, 16
	ld	%g12, %g11, -4
	jlt	%g3, %g12, jle_else.42552
	return
jle_else.42552:
	subi	%g12, %g12, 1
	st	%g10, %g1, 40
	st	%g3, %g1, 44
	jlt	%g3, %g12, jle_else.42554
	jmp	jle_cont.42555
jle_else.42554:
	addi	%g12, %g3, 1
	ld	%g13, %g1, 12
	fld	%f10, %g13, 0
	ld	%g13, %g1, 8
	ld	%g13, %g13, -4
	sub	%g12, %g12, %g13
	mov	%g3, %g12
	subi	%g1, %g1, 52
	call	min_caml_float_of_int
	addi	%g1, %g1, 52
	fmul	%f0, %f10, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	ld	%g4, %g1, 0
	fld	%f2, %g4, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g3, -4
	fmul	%f2, %f0, %f2
	fld	%f3, %g4, -4
	fadd	%f2, %f2, %f3
	fld	%f3, %g3, -8
	fmul	%f0, %f0, %f3
	fld	%f3, %g4, -8
	fadd	%f0, %f0, %f3
	ld	%g3, %g11, 0
	subi	%g3, %g3, 1
	ld	%g4, %g1, 32
	mov	%g5, %g10
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	fmov	%f15, %f2
	fmov	%f2, %f0
	fmov	%f0, %f1
	fmov	%f1, %f15
	subi	%g1, %g1, 52
	call	pretrace_pixels.2958
	addi	%g1, %g1, 52
jle_cont.42555:
	addi	%g3, %g0, 0
	ld	%g4, %g1, 44
	ld	%g5, %g1, 28
	ld	%g6, %g1, 24
	ld	%g7, %g1, 32
	subi	%g1, %g1, 52
	call	scan_pixel.2969
	addi	%g1, %g1, 52
	ld	%g3, %g1, 44
	addi	%g3, %g3, 1
	ld	%g4, %g1, 40
	addi	%g4, %g4, 2
	addi	%g5, %g0, 5
	jlt	%g4, %g5, jle_else.42556
	subi	%g4, %g4, 5
	jmp	jle_cont.42557
jle_else.42556:
jle_cont.42557:
	ld	%g5, %g1, 24
	ld	%g6, %g1, 32
	ld	%g7, %g1, 28
	mov	%g26, %g7
	mov	%g7, %g4
	mov	%g4, %g5
	mov	%g5, %g6
	mov	%g6, %g26
	jmp	scan_line.2975
init_line_elements.2985:
	jlt	%g4, %g0, jge_else.42558
	addi	%g10, %g0, 3
	fmov	%f0, %f16
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	fst	%f0, %g1, 8
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	addi	%g10, %g0, 3
	fld	%f0, %g1, 8
	st	%g3, %g1, 12
	mov	%g3, %g10
	subi	%g1, %g1, 20
	call	min_caml_create_float_array
	addi	%g1, %g1, 20
	addi	%g4, %g0, 5
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 20
	call	min_caml_create_array
	addi	%g1, %g1, 20
	addi	%g10, %g0, 3
	fld	%f0, %g1, 8
	st	%g3, %g1, 16
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	min_caml_create_float_array
	addi	%g1, %g1, 24
	ld	%g10, %g1, 16
	st	%g3, %g10, -4
	addi	%g3, %g0, 3
	fld	%f0, %g1, 8
	subi	%g1, %g1, 24
	call	min_caml_create_float_array
	addi	%g1, %g1, 24
	st	%g3, %g10, -8
	addi	%g3, %g0, 3
	fld	%f0, %g1, 8
	subi	%g1, %g1, 24
	call	min_caml_create_float_array
	addi	%g1, %g1, 24
	st	%g3, %g10, -12
	addi	%g3, %g0, 3
	fld	%f0, %g1, 8
	subi	%g1, %g1, 24
	call	min_caml_create_float_array
	addi	%g1, %g1, 24
	st	%g3, %g10, -16
	addi	%g3, %g0, 5
	addi	%g4, %g0, 0
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	addi	%g4, %g0, 5
	addi	%g11, %g0, 0
	st	%g3, %g1, 20
	mov	%g3, %g4
	mov	%g4, %g11
	subi	%g1, %g1, 28
	call	min_caml_create_array
	addi	%g1, %g1, 28
	addi	%g11, %g0, 3
	fld	%f0, %g1, 8
	st	%g3, %g1, 24
	mov	%g3, %g11
	subi	%g1, %g1, 32
	call	min_caml_create_float_array
	addi	%g1, %g1, 32
	addi	%g4, %g0, 5
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 32
	call	min_caml_create_array
	addi	%g1, %g1, 32
	addi	%g11, %g0, 3
	fld	%f0, %g1, 8
	st	%g3, %g1, 28
	mov	%g3, %g11
	subi	%g1, %g1, 36
	call	min_caml_create_float_array
	addi	%g1, %g1, 36
	ld	%g11, %g1, 28
	st	%g3, %g11, -4
	addi	%g3, %g0, 3
	fld	%f0, %g1, 8
	subi	%g1, %g1, 36
	call	min_caml_create_float_array
	addi	%g1, %g1, 36
	st	%g3, %g11, -8
	addi	%g3, %g0, 3
	fld	%f0, %g1, 8
	subi	%g1, %g1, 36
	call	min_caml_create_float_array
	addi	%g1, %g1, 36
	st	%g3, %g11, -12
	addi	%g3, %g0, 3
	fld	%f0, %g1, 8
	subi	%g1, %g1, 36
	call	min_caml_create_float_array
	addi	%g1, %g1, 36
	st	%g3, %g11, -16
	addi	%g3, %g0, 3
	fld	%f0, %g1, 8
	subi	%g1, %g1, 36
	call	min_caml_create_float_array
	addi	%g1, %g1, 36
	addi	%g4, %g0, 5
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 36
	call	min_caml_create_array
	addi	%g1, %g1, 36
	addi	%g12, %g0, 3
	fld	%f0, %g1, 8
	st	%g3, %g1, 32
	mov	%g3, %g12
	subi	%g1, %g1, 40
	call	min_caml_create_float_array
	addi	%g1, %g1, 40
	ld	%g12, %g1, 32
	st	%g3, %g12, -4
	addi	%g3, %g0, 3
	fld	%f0, %g1, 8
	subi	%g1, %g1, 40
	call	min_caml_create_float_array
	addi	%g1, %g1, 40
	st	%g3, %g12, -8
	addi	%g3, %g0, 3
	fld	%f0, %g1, 8
	subi	%g1, %g1, 40
	call	min_caml_create_float_array
	addi	%g1, %g1, 40
	st	%g3, %g12, -12
	addi	%g3, %g0, 3
	fld	%f0, %g1, 8
	subi	%g1, %g1, 40
	call	min_caml_create_float_array
	addi	%g1, %g1, 40
	st	%g3, %g12, -16
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 40
	call	min_caml_create_array
	addi	%g1, %g1, 40
	addi	%g13, %g0, 3
	fld	%f0, %g1, 8
	st	%g3, %g1, 36
	mov	%g3, %g13
	subi	%g1, %g1, 44
	call	min_caml_create_float_array
	addi	%g1, %g1, 44
	addi	%g4, %g0, 5
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 44
	call	min_caml_create_array
	addi	%g1, %g1, 44
	addi	%g13, %g0, 3
	fld	%f0, %g1, 8
	st	%g3, %g1, 40
	mov	%g3, %g13
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g13, %g1, 40
	st	%g3, %g13, -4
	addi	%g3, %g0, 3
	fld	%f0, %g1, 8
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	st	%g3, %g13, -8
	addi	%g3, %g0, 3
	fld	%f0, %g1, 8
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	st	%g3, %g13, -12
	addi	%g3, %g0, 3
	fld	%f0, %g1, 8
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	st	%g3, %g13, -16
	mov	%g3, %g2
	addi	%g2, %g2, 32
	st	%g13, %g3, -28
	ld	%g4, %g1, 36
	st	%g4, %g3, -24
	st	%g12, %g3, -20
	st	%g11, %g3, -16
	ld	%g4, %g1, 24
	st	%g4, %g3, -12
	ld	%g4, %g1, 20
	st	%g4, %g3, -8
	st	%g10, %g3, -4
	ld	%g4, %g1, 12
	st	%g4, %g3, 0
	ld	%g4, %g1, 4
	slli	%g5, %g4, 2
	ld	%g6, %g1, 0
	add	%g26, %g6, %g5
	st	%g3, %g26, 0
	subi	%g3, %g4, 1
	mov	%g4, %g3
	mov	%g3, %g6
	jmp	init_line_elements.2985
jge_else.42558:
	return
calc_dirvec.2993:
	ld	%g10, %g31, 708
	addi	%g11, %g0, 5
	jlt	%g3, %g11, jle_else.42559
	fmul	%f10, %f0, %f0
	fmul	%f11, %f1, %f1
	fadd	%f10, %f10, %f11
	fmov	%f11, %f17
	fadd	%f10, %f10, %f11
	fst	%f0, %g1, 0
	fsqrt	%f0, %f10
	fld	%f2, %g1, 0
	fdiv	%f2, %f2, %f0
	fdiv	%f1, %f1, %f0
	fdiv	%f0, %f11, %f0
	slli	%g3, %g4, 2
	add	%g26, %g10, %g3
	ld	%g3, %g26, 0
	slli	%g4, %g5, 2
	add	%g26, %g3, %g4
	ld	%g4, %g26, 0
	ld	%g4, %g4, 0
	fst	%f2, %g4, 0
	fst	%f1, %g4, -4
	fst	%f0, %g4, -8
	addi	%g4, %g5, 40
	slli	%g4, %g4, 2
	add	%g26, %g3, %g4
	ld	%g4, %g26, 0
	ld	%g4, %g4, 0
	fneg	%f3, %f1
	fst	%f2, %g4, 0
	fst	%f0, %g4, -4
	fst	%f3, %g4, -8
	addi	%g4, %g5, 80
	slli	%g4, %g4, 2
	add	%g26, %g3, %g4
	ld	%g4, %g26, 0
	ld	%g4, %g4, 0
	fneg	%f4, %f2
	fst	%f0, %g4, 0
	fst	%f4, %g4, -4
	fst	%f3, %g4, -8
	addi	%g4, %g5, 1
	slli	%g4, %g4, 2
	add	%g26, %g3, %g4
	ld	%g4, %g26, 0
	ld	%g4, %g4, 0
	fneg	%f0, %f0
	fst	%f4, %g4, 0
	fst	%f3, %g4, -4
	fst	%f0, %g4, -8
	addi	%g4, %g5, 41
	slli	%g4, %g4, 2
	add	%g26, %g3, %g4
	ld	%g4, %g26, 0
	ld	%g4, %g4, 0
	fst	%f4, %g4, 0
	fst	%f0, %g4, -4
	fst	%f1, %g4, -8
	addi	%g4, %g5, 81
	slli	%g4, %g4, 2
	add	%g26, %g3, %g4
	ld	%g3, %g26, 0
	ld	%g3, %g3, 0
	fst	%f0, %g3, 0
	fst	%f2, %g3, -4
	fst	%f1, %g3, -8
	return
jle_else.42559:
	fmul	%f0, %f1, %f1
	fmov	%f1, %f28
	fadd	%f0, %f0, %f1
	fsqrt	%f0, %f0
	fmov	%f10, %f17
	fdiv	%f11, %f10, %f0
	fjlt	%f10, %f11, fjge_else.42561
	fmov	%f12, %f18
	fjlt	%f11, %f12, fjge_else.42563
	addi	%g10, %g0, 0
	jmp	fjge_cont.42564
fjge_else.42563:
	addi	%g10, %g0, -1
fjge_cont.42564:
	jmp	fjge_cont.42562
fjge_else.42561:
	addi	%g10, %g0, 1
fjge_cont.42562:
	jne	%g10, %g0, jeq_else.42565
	jmp	jeq_cont.42566
jeq_else.42565:
	fdiv	%f11, %f10, %f11
jeq_cont.42566:
	fmul	%f12, %f11, %f11
	setL %g11, l.36770
	fld	%f13, %g11, 0
	fmul	%f14, %f13, %f12
	setL %g11, l.36772
	fld	%f15, %g11, 0
	fdiv	%f14, %f14, %f15
	fmov	%f4, %f23
	setL %g11, l.36774
	fld	%f5, %g11, 0
	fmul	%f6, %f5, %f12
	setL %g11, l.36776
	fld	%f7, %g11, 0
	fadd	%f14, %f7, %f14
	fdiv	%f14, %f6, %f14
	setL %g11, l.36778
	fld	%f6, %g11, 0
	fmul	%f8, %f6, %f12
	setL %g11, l.36780
	fld	%f9, %g11, 0
	fadd	%f14, %f9, %f14
	fdiv	%f14, %f8, %f14
	setL %g11, l.36782
	fld	%f8, %g11, 0
	fst	%f3, %g1, 4
	fmul	%f3, %f8, %f12
	setL %g11, l.36784
	fst	%f8, %g1, 8
	fld	%f8, %g11, 0
	fadd	%f14, %f8, %f14
	fdiv	%f14, %f3, %f14
	setL %g11, l.36786
	fld	%f3, %g11, 0
	fst	%f3, %g1, 12
	fmul	%f3, %f3, %f12
	fst	%f8, %g1, 16
	fmov	%f8, %f26
	fadd	%f14, %f8, %f14
	fdiv	%f14, %f3, %f14
	setL %g11, l.36789
	fld	%f3, %g11, 0
	fst	%f3, %g1, 20
	fmul	%f3, %f3, %f12
	setL %g11, l.36791
	fst	%f8, %g1, 24
	fld	%f8, %g11, 0
	fadd	%f14, %f8, %f14
	fdiv	%f14, %f3, %f14
	setL %g11, l.36801
	fld	%f3, %g11, 0
	setL %g11, l.36793
	fst	%f8, %g1, 28
	fld	%f8, %g11, 0
	fst	%f8, %g1, 32
	fmul	%f8, %f8, %f12
	setL %g11, l.36795
	fst	%f9, %g1, 36
	fld	%f9, %g11, 0
	fadd	%f14, %f9, %f14
	fdiv	%f14, %f8, %f14
	setL %g11, l.36797
	fld	%f8, %g11, 0
	fst	%f8, %g1, 40
	fmul	%f8, %f8, %f12
	fadd	%f14, %f4, %f14
	fdiv	%f14, %f8, %f14
	fmul	%f8, %f4, %f12
	fst	%f9, %g1, 44
	fmov	%f9, %f24
	fadd	%f14, %f9, %f14
	fdiv	%f14, %f8, %f14
	fmul	%f8, %f3, %f12
	fst	%f3, %g1, 48
	fmov	%f3, %f22
	fadd	%f14, %f3, %f14
	fdiv	%f14, %f8, %f14
	fmov	%f8, %f21
	fadd	%f14, %f8, %f14
	fdiv	%f12, %f12, %f14
	fadd	%f12, %f10, %f12
	fdiv	%f11, %f11, %f12
	jlt	%g0, %g10, jle_else.42567
	jlt	%g10, %g0, jge_else.42569
	jmp	jge_cont.42570
jge_else.42569:
	setL %g10, l.36806
	fld	%f12, %g10, 0
	fsub	%f11, %f12, %f11
jge_cont.42570:
	jmp	jle_cont.42568
jle_else.42567:
	fmov	%f12, %f20
	fsub	%f11, %f12, %f11
jle_cont.42568:
	fmul	%f11, %f11, %f2
	fmul	%f12, %f11, %f11
	fdiv	%f14, %f12, %f4
	fsub	%f14, %f9, %f14
	fdiv	%f14, %f12, %f14
	fsub	%f14, %f3, %f14
	fdiv	%f14, %f12, %f14
	fsub	%f14, %f8, %f14
	fdiv	%f12, %f12, %f14
	fsub	%f12, %f10, %f12
	fdiv	%f11, %f11, %f12
	fmul	%f0, %f11, %f0
	addi	%g10, %g3, 1
	fmul	%f11, %f0, %f0
	fadd	%f1, %f11, %f1
	fst	%f0, %g1, 52
	fsqrt	%f0, %f1
	fdiv	%f1, %f10, %f0
	fjlt	%f10, %f1, fjge_else.42571
	fmov	%f11, %f18
	fjlt	%f1, %f11, fjge_else.42573
	addi	%g3, %g0, 0
	jmp	fjge_cont.42574
fjge_else.42573:
	addi	%g3, %g0, -1
fjge_cont.42574:
	jmp	fjge_cont.42572
fjge_else.42571:
	addi	%g3, %g0, 1
fjge_cont.42572:
	jne	%g3, %g0, jeq_else.42575
	jmp	jeq_cont.42576
jeq_else.42575:
	fdiv	%f1, %f10, %f1
jeq_cont.42576:
	fmul	%f11, %f1, %f1
	fmul	%f12, %f13, %f11
	fdiv	%f12, %f12, %f15
	fmul	%f5, %f5, %f11
	fadd	%f7, %f7, %f12
	fdiv	%f5, %f5, %f7
	fmul	%f6, %f6, %f11
	fld	%f7, %g1, 36
	fadd	%f5, %f7, %f5
	fdiv	%f5, %f6, %f5
	fld	%f6, %g1, 8
	fmul	%f6, %f6, %f11
	fld	%f7, %g1, 16
	fadd	%f5, %f7, %f5
	fdiv	%f5, %f6, %f5
	fld	%f6, %g1, 12
	fmul	%f6, %f6, %f11
	fld	%f7, %g1, 24
	fadd	%f5, %f7, %f5
	fdiv	%f5, %f6, %f5
	fld	%f6, %g1, 20
	fmul	%f6, %f6, %f11
	fld	%f7, %g1, 28
	fadd	%f5, %f7, %f5
	fdiv	%f5, %f6, %f5
	fld	%f6, %g1, 32
	fmul	%f6, %f6, %f11
	fld	%f7, %g1, 44
	fadd	%f5, %f7, %f5
	fdiv	%f5, %f6, %f5
	fld	%f6, %g1, 40
	fmul	%f6, %f6, %f11
	fadd	%f5, %f4, %f5
	fdiv	%f5, %f6, %f5
	fmul	%f6, %f4, %f11
	fadd	%f5, %f9, %f5
	fdiv	%f5, %f6, %f5
	fld	%f6, %g1, 48
	fmul	%f6, %f6, %f11
	fadd	%f5, %f3, %f5
	fdiv	%f5, %f6, %f5
	fadd	%f5, %f8, %f5
	fdiv	%f5, %f11, %f5
	fadd	%f5, %f10, %f5
	fdiv	%f1, %f1, %f5
	jlt	%g0, %g3, jle_else.42577
	jlt	%g3, %g0, jge_else.42579
	jmp	jge_cont.42580
jge_else.42579:
	setL %g3, l.36806
	fld	%f5, %g3, 0
	fsub	%f1, %f5, %f1
jge_cont.42580:
	jmp	jle_cont.42578
jle_else.42577:
	fmov	%f5, %f20
	fsub	%f1, %f5, %f1
jle_cont.42578:
	fld	%f5, %g1, 4
	fmul	%f1, %f1, %f5
	fmul	%f6, %f1, %f1
	fdiv	%f4, %f6, %f4
	fsub	%f4, %f9, %f4
	fdiv	%f4, %f6, %f4
	fsub	%f3, %f3, %f4
	fdiv	%f3, %f6, %f3
	fsub	%f3, %f8, %f3
	fdiv	%f3, %f6, %f3
	fsub	%f3, %f10, %f3
	fdiv	%f1, %f1, %f3
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 52
	mov	%g3, %g10
	fmov	%f3, %f5
	fmov	%f15, %f1
	fmov	%f1, %f0
	fmov	%f0, %f15
	jmp	calc_dirvec.2993
calc_dirvecs.3001:
	jlt	%g3, %g0, jge_else.42581
	st	%g3, %g1, 0
	fst	%f0, %g1, 4
	st	%g5, %g1, 8
	st	%g4, %g1, 12
	subi	%g1, %g1, 20
	call	min_caml_float_of_int
	addi	%g1, %g1, 20
	setL %g3, l.34583
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.34585
	fld	%f2, %g3, 0
	fsub	%f3, %f0, %f2
	addi	%g3, %g0, 0
	fmov	%f4, %f16
	fld	%f5, %g1, 4
	ld	%g4, %g1, 12
	ld	%g5, %g1, 8
	fst	%f2, %g1, 16
	fst	%f1, %g1, 20
	fst	%f4, %g1, 24
	fst	%f0, %g1, 28
	fmov	%f2, %f3
	fmov	%f1, %f4
	fmov	%f0, %f4
	fmov	%f3, %f5
	subi	%g1, %g1, 36
	call	calc_dirvec.2993
	addi	%g1, %g1, 36
	fmov	%f0, %f28
	fld	%f1, %g1, 28
	fadd	%f1, %f1, %f0
	addi	%g3, %g0, 0
	ld	%g4, %g1, 8
	addi	%g5, %g4, 2
	fld	%f2, %g1, 24
	fld	%f3, %g1, 4
	ld	%g12, %g1, 12
	st	%g5, %g1, 32
	fst	%f0, %g1, 36
	mov	%g4, %g12
	fmov	%f0, %f2
	fmov	%f15, %f2
	fmov	%f2, %f1
	fmov	%f1, %f15
	subi	%g1, %g1, 44
	call	calc_dirvec.2993
	addi	%g1, %g1, 44
	ld	%g3, %g1, 0
	subi	%g3, %g3, 1
	addi	%g10, %g12, 1
	addi	%g11, %g0, 5
	jlt	%g10, %g11, jle_else.42582
	subi	%g10, %g10, 5
	jmp	jle_cont.42583
jle_else.42582:
jle_cont.42583:
	jlt	%g3, %g0, jge_else.42584
	st	%g3, %g1, 40
	subi	%g1, %g1, 48
	call	min_caml_float_of_int
	addi	%g1, %g1, 48
	fld	%f1, %g1, 20
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 16
	fsub	%f1, %f0, %f1
	addi	%g3, %g0, 0
	fld	%f2, %g1, 24
	fld	%f3, %g1, 4
	ld	%g4, %g1, 8
	st	%g10, %g1, 44
	fst	%f0, %g1, 48
	mov	%g5, %g4
	mov	%g4, %g10
	fmov	%f0, %f2
	fmov	%f15, %f2
	fmov	%f2, %f1
	fmov	%f1, %f15
	subi	%g1, %g1, 56
	call	calc_dirvec.2993
	addi	%g1, %g1, 56
	fld	%f0, %g1, 36
	fld	%f1, %g1, 48
	fadd	%f0, %f1, %f0
	addi	%g3, %g0, 0
	fld	%f1, %g1, 24
	fld	%f2, %g1, 4
	ld	%g4, %g1, 44
	ld	%g5, %g1, 32
	fmov	%f3, %f2
	fmov	%f2, %f0
	fmov	%f0, %f1
	subi	%g1, %g1, 56
	call	calc_dirvec.2993
	addi	%g1, %g1, 56
	ld	%g3, %g1, 40
	subi	%g3, %g3, 1
	ld	%g4, %g1, 44
	addi	%g4, %g4, 1
	addi	%g5, %g0, 5
	jlt	%g4, %g5, jle_else.42585
	subi	%g4, %g4, 5
	jmp	jle_cont.42586
jle_else.42585:
jle_cont.42586:
	fld	%f0, %g1, 4
	ld	%g5, %g1, 8
	jmp	calc_dirvecs.3001
jge_else.42584:
	return
jge_else.42581:
	return
calc_dirvec_rows.3006:
	jlt	%g3, %g0, jge_else.42589
	st	%g3, %g1, 0
	st	%g5, %g1, 4
	st	%g4, %g1, 8
	subi	%g1, %g1, 16
	call	min_caml_float_of_int
	addi	%g1, %g1, 16
	fmov	%f10, %f0, 0
	setL %g3, l.34583
	fld	%f11, %g3, 0
	fmul	%f10, %f10, %f11
	setL %g3, l.34585
	fld	%f12, %g3, 0
	fsub	%f10, %f10, %f12
	addi	%g3, %g0, 4
	subi	%g1, %g1, 16
	call	min_caml_float_of_int
	addi	%g1, %g1, 16
	fmul	%f0, %f0, %f11
	fsub	%f1, %f0, %f12
	addi	%g3, %g0, 0
	fmov	%f2, %f16
	ld	%g4, %g1, 8
	ld	%g5, %g1, 4
	fst	%f1, %g1, 12
	fst	%f12, %g1, 16
	fst	%f11, %g1, 20
	fst	%f10, %g1, 24
	fst	%f2, %g1, 28
	fst	%f0, %g1, 32
	fmov	%f3, %f10
	fmov	%f0, %f2
	fmov	%f15, %f2
	fmov	%f2, %f1
	fmov	%f1, %f15
	subi	%g1, %g1, 40
	call	calc_dirvec.2993
	addi	%g1, %g1, 40
	fmov	%f0, %f28
	fld	%f1, %g1, 32
	fadd	%f0, %f1, %f0
	addi	%g3, %g0, 0
	ld	%g4, %g1, 4
	addi	%g5, %g4, 2
	fld	%f1, %g1, 28
	fld	%f2, %g1, 24
	ld	%g12, %g1, 8
	fst	%f0, %g1, 36
	mov	%g4, %g12
	fmov	%f3, %f2
	fmov	%f2, %f0
	fmov	%f0, %f1
	subi	%g1, %g1, 44
	call	calc_dirvec.2993
	addi	%g1, %g1, 44
	addi	%g3, %g0, 3
	addi	%g4, %g12, 1
	addi	%g5, %g0, 5
	jlt	%g4, %g5, jle_else.42590
	subi	%g4, %g4, 5
	jmp	jle_cont.42591
jle_else.42590:
jle_cont.42591:
	fld	%f0, %g1, 24
	ld	%g5, %g1, 4
	subi	%g1, %g1, 44
	call	calc_dirvecs.3001
	addi	%g1, %g1, 44
	ld	%g3, %g1, 0
	subi	%g3, %g3, 1
	ld	%g10, %g1, 8
	addi	%g10, %g10, 2
	addi	%g11, %g0, 5
	jlt	%g10, %g11, jle_else.42592
	subi	%g10, %g10, 5
	jmp	jle_cont.42593
jle_else.42592:
jle_cont.42593:
	ld	%g11, %g1, 4
	addi	%g11, %g11, 4
	jlt	%g3, %g0, jge_else.42594
	st	%g3, %g1, 40
	subi	%g1, %g1, 48
	call	min_caml_float_of_int
	addi	%g1, %g1, 48
	fld	%f1, %g1, 20
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 16
	fsub	%f0, %f0, %f1
	addi	%g3, %g0, 0
	fld	%f1, %g1, 28
	fld	%f2, %g1, 12
	fst	%f0, %g1, 44
	st	%g10, %g1, 48
	st	%g11, %g1, 52
	mov	%g5, %g11
	mov	%g4, %g10
	fmov	%f3, %f0
	fmov	%f0, %f1
	subi	%g1, %g1, 60
	call	calc_dirvec.2993
	addi	%g1, %g1, 60
	addi	%g3, %g0, 0
	ld	%g4, %g1, 52
	addi	%g5, %g4, 2
	fld	%f0, %g1, 28
	fld	%f1, %g1, 36
	fld	%f2, %g1, 44
	ld	%g12, %g1, 48
	mov	%g4, %g12
	fmov	%f3, %f2
	fmov	%f2, %f1
	fmov	%f1, %f0
	subi	%g1, %g1, 60
	call	calc_dirvec.2993
	addi	%g1, %g1, 60
	addi	%g3, %g0, 3
	addi	%g4, %g12, 1
	addi	%g5, %g0, 5
	jlt	%g4, %g5, jle_else.42595
	subi	%g4, %g4, 5
	jmp	jle_cont.42596
jle_else.42595:
jle_cont.42596:
	fld	%f0, %g1, 44
	ld	%g5, %g1, 52
	subi	%g1, %g1, 60
	call	calc_dirvecs.3001
	addi	%g1, %g1, 60
	ld	%g3, %g1, 40
	subi	%g3, %g3, 1
	ld	%g4, %g1, 48
	addi	%g4, %g4, 2
	addi	%g5, %g0, 5
	jlt	%g4, %g5, jle_else.42597
	subi	%g4, %g4, 5
	jmp	jle_cont.42598
jle_else.42597:
jle_cont.42598:
	ld	%g5, %g1, 52
	addi	%g5, %g5, 4
	jmp	calc_dirvec_rows.3006
jge_else.42594:
	return
jge_else.42589:
	return
create_dirvec_elements.3012:
	ld	%g10, %g31, 828
	jlt	%g4, %g0, jge_else.42601
	addi	%g11, %g0, 3
	fmov	%f0, %f16
	fst	%f0, %g1, 0
	st	%g3, %g1, 4
	st	%g4, %g1, 8
	mov	%g3, %g11
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	ld	%g4, %g10, 0
	st	%g3, %g1, 12
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 20
	call	min_caml_create_array
	addi	%g1, %g1, 20
	mov	%g11, %g2
	addi	%g2, %g2, 8
	st	%g3, %g11, -4
	ld	%g3, %g1, 12
	st	%g3, %g11, 0
	mov	%g3, %g11
	ld	%g11, %g1, 8
	slli	%g12, %g11, 2
	ld	%g13, %g1, 4
	add	%g26, %g13, %g12
	st	%g3, %g26, 0
	subi	%g3, %g11, 1
	jlt	%g3, %g0, jge_else.42602
	addi	%g11, %g0, 3
	fld	%f0, %g1, 0
	st	%g3, %g1, 16
	mov	%g3, %g11
	subi	%g1, %g1, 24
	call	min_caml_create_float_array
	addi	%g1, %g1, 24
	ld	%g4, %g10, 0
	st	%g3, %g1, 20
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 28
	call	min_caml_create_array
	addi	%g1, %g1, 28
	mov	%g11, %g2
	addi	%g2, %g2, 8
	st	%g3, %g11, -4
	ld	%g3, %g1, 20
	st	%g3, %g11, 0
	mov	%g3, %g11
	ld	%g11, %g1, 16
	slli	%g12, %g11, 2
	add	%g26, %g13, %g12
	st	%g3, %g26, 0
	subi	%g3, %g11, 1
	jlt	%g3, %g0, jge_else.42603
	addi	%g11, %g0, 3
	fld	%f0, %g1, 0
	st	%g3, %g1, 24
	mov	%g3, %g11
	subi	%g1, %g1, 32
	call	min_caml_create_float_array
	addi	%g1, %g1, 32
	ld	%g4, %g10, 0
	st	%g3, %g1, 28
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 36
	call	min_caml_create_array
	addi	%g1, %g1, 36
	mov	%g11, %g2
	addi	%g2, %g2, 8
	st	%g3, %g11, -4
	ld	%g3, %g1, 28
	st	%g3, %g11, 0
	mov	%g3, %g11
	ld	%g11, %g1, 24
	slli	%g12, %g11, 2
	add	%g26, %g13, %g12
	st	%g3, %g26, 0
	subi	%g3, %g11, 1
	jlt	%g3, %g0, jge_else.42604
	addi	%g11, %g0, 3
	fld	%f0, %g1, 0
	st	%g3, %g1, 32
	mov	%g3, %g11
	subi	%g1, %g1, 40
	call	min_caml_create_float_array
	addi	%g1, %g1, 40
	ld	%g4, %g10, 0
	st	%g3, %g1, 36
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 44
	call	min_caml_create_array
	addi	%g1, %g1, 44
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 36
	st	%g3, %g4, 0
	mov	%g3, %g4
	ld	%g4, %g1, 32
	slli	%g5, %g4, 2
	add	%g26, %g13, %g5
	st	%g3, %g26, 0
	subi	%g3, %g4, 1
	mov	%g4, %g3
	mov	%g3, %g13
	jmp	create_dirvec_elements.3012
jge_else.42604:
	return
jge_else.42603:
	return
jge_else.42602:
	return
jge_else.42601:
	return
create_dirvecs.3015:
	ld	%g10, %g31, 828
	ld	%g11, %g31, 708
	jlt	%g3, %g0, jge_else.42609
	addi	%g12, %g0, 120
	addi	%g13, %g0, 3
	fmov	%f0, %f16
	fst	%f0, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g13
	subi	%g1, %g1, 12
	call	min_caml_create_float_array
	addi	%g1, %g1, 12
	ld	%g4, %g10, 0
	st	%g3, %g1, 8
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 8
	st	%g3, %g4, 0
	mov	%g3, %g4
	mov	%g4, %g3
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g12, %g1, 4
	slli	%g13, %g12, 2
	add	%g26, %g11, %g13
	st	%g3, %g26, 0
	slli	%g3, %g12, 2
	add	%g26, %g11, %g3
	ld	%g3, %g26, 0
	addi	%g13, %g0, 3
	fld	%f0, %g1, 0
	st	%g3, %g1, 12
	mov	%g3, %g13
	subi	%g1, %g1, 20
	call	min_caml_create_float_array
	addi	%g1, %g1, 20
	ld	%g4, %g10, 0
	st	%g3, %g1, 16
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	mov	%g13, %g2
	addi	%g2, %g2, 8
	st	%g3, %g13, -4
	ld	%g3, %g1, 16
	st	%g3, %g13, 0
	mov	%g3, %g13
	ld	%g13, %g1, 12
	st	%g3, %g13, -472
	addi	%g3, %g0, 3
	fld	%f0, %g1, 0
	subi	%g1, %g1, 24
	call	min_caml_create_float_array
	addi	%g1, %g1, 24
	ld	%g4, %g10, 0
	st	%g3, %g1, 20
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 28
	call	min_caml_create_array
	addi	%g1, %g1, 28
	mov	%g14, %g2
	addi	%g2, %g2, 8
	st	%g3, %g14, -4
	ld	%g3, %g1, 20
	st	%g3, %g14, 0
	mov	%g3, %g14
	st	%g3, %g13, -468
	addi	%g3, %g0, 3
	fld	%f0, %g1, 0
	subi	%g1, %g1, 28
	call	min_caml_create_float_array
	addi	%g1, %g1, 28
	ld	%g4, %g10, 0
	st	%g3, %g1, 24
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 32
	call	min_caml_create_array
	addi	%g1, %g1, 32
	mov	%g14, %g2
	addi	%g2, %g2, 8
	st	%g3, %g14, -4
	ld	%g3, %g1, 24
	st	%g3, %g14, 0
	mov	%g3, %g14
	st	%g3, %g13, -464
	addi	%g3, %g0, 3
	fld	%f0, %g1, 0
	subi	%g1, %g1, 32
	call	min_caml_create_float_array
	addi	%g1, %g1, 32
	ld	%g4, %g10, 0
	st	%g3, %g1, 28
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 36
	call	min_caml_create_array
	addi	%g1, %g1, 36
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 28
	st	%g3, %g4, 0
	mov	%g3, %g4
	st	%g3, %g13, -460
	addi	%g3, %g0, 114
	st	%g11, %g1, 32
	st	%g10, %g1, 36
	mov	%g4, %g3
	mov	%g3, %g13
	subi	%g1, %g1, 44
	call	create_dirvec_elements.3012
	addi	%g1, %g1, 44
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.42610
	addi	%g10, %g0, 120
	addi	%g11, %g0, 3
	fld	%f0, %g1, 0
	st	%g3, %g1, 40
	mov	%g3, %g11
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g4, %g1, 36
	ld	%g11, %g4, 0
	st	%g3, %g1, 44
	mov	%g4, %g3
	mov	%g3, %g11
	subi	%g1, %g1, 52
	call	min_caml_create_array
	addi	%g1, %g1, 52
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 44
	st	%g3, %g4, 0
	mov	%g3, %g4
	mov	%g4, %g3
	mov	%g3, %g10
	subi	%g1, %g1, 52
	call	min_caml_create_array
	addi	%g1, %g1, 52
	ld	%g10, %g1, 40
	slli	%g11, %g10, 2
	ld	%g12, %g1, 32
	add	%g26, %g12, %g11
	st	%g3, %g26, 0
	slli	%g3, %g10, 2
	add	%g26, %g12, %g3
	ld	%g3, %g26, 0
	addi	%g11, %g0, 3
	fld	%f0, %g1, 0
	st	%g3, %g1, 48
	mov	%g3, %g11
	subi	%g1, %g1, 56
	call	min_caml_create_float_array
	addi	%g1, %g1, 56
	ld	%g4, %g1, 36
	ld	%g11, %g4, 0
	st	%g3, %g1, 52
	mov	%g4, %g3
	mov	%g3, %g11
	subi	%g1, %g1, 60
	call	min_caml_create_array
	addi	%g1, %g1, 60
	mov	%g11, %g2
	addi	%g2, %g2, 8
	st	%g3, %g11, -4
	ld	%g3, %g1, 52
	st	%g3, %g11, 0
	mov	%g3, %g11
	ld	%g11, %g1, 48
	st	%g3, %g11, -472
	addi	%g3, %g0, 3
	fld	%f0, %g1, 0
	subi	%g1, %g1, 60
	call	min_caml_create_float_array
	addi	%g1, %g1, 60
	ld	%g4, %g1, 36
	ld	%g12, %g4, 0
	st	%g3, %g1, 56
	mov	%g4, %g3
	mov	%g3, %g12
	subi	%g1, %g1, 64
	call	min_caml_create_array
	addi	%g1, %g1, 64
	mov	%g12, %g2
	addi	%g2, %g2, 8
	st	%g3, %g12, -4
	ld	%g3, %g1, 56
	st	%g3, %g12, 0
	mov	%g3, %g12
	st	%g3, %g11, -468
	addi	%g3, %g0, 3
	fld	%f0, %g1, 0
	subi	%g1, %g1, 64
	call	min_caml_create_float_array
	addi	%g1, %g1, 64
	ld	%g4, %g1, 36
	ld	%g4, %g4, 0
	st	%g3, %g1, 60
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 68
	call	min_caml_create_array
	addi	%g1, %g1, 68
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 60
	st	%g3, %g4, 0
	mov	%g3, %g4
	st	%g3, %g11, -464
	addi	%g3, %g0, 115
	mov	%g4, %g3
	mov	%g3, %g11
	subi	%g1, %g1, 68
	call	create_dirvec_elements.3012
	addi	%g1, %g1, 68
	ld	%g3, %g1, 40
	subi	%g3, %g3, 1
	jmp	create_dirvecs.3015
jge_else.42610:
	return
jge_else.42609:
	return
init_dirvec_constants.3017:
	ld	%g15, %g31, 828
	jlt	%g4, %g0, jge_else.42613
	slli	%g16, %g4, 2
	add	%g26, %g3, %g16
	ld	%g16, %g26, 0
	ld	%g17, %g15, 0
	subi	%g17, %g17, 1
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	mov	%g4, %g17
	mov	%g3, %g16
	subi	%g1, %g1, 12
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 12
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.42614
	slli	%g4, %g3, 2
	ld	%g16, %g1, 0
	add	%g26, %g16, %g4
	ld	%g4, %g26, 0
	ld	%g17, %g15, 0
	subi	%g17, %g17, 1
	st	%g3, %g1, 8
	mov	%g3, %g4
	mov	%g4, %g17
	subi	%g1, %g1, 16
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 16
	ld	%g3, %g1, 8
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.42615
	slli	%g4, %g3, 2
	add	%g26, %g16, %g4
	ld	%g4, %g26, 0
	ld	%g17, %g15, 0
	subi	%g17, %g17, 1
	st	%g3, %g1, 12
	mov	%g3, %g4
	mov	%g4, %g17
	subi	%g1, %g1, 20
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 20
	ld	%g3, %g1, 12
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.42616
	slli	%g4, %g3, 2
	add	%g26, %g16, %g4
	ld	%g4, %g26, 0
	ld	%g17, %g15, 0
	subi	%g17, %g17, 1
	st	%g3, %g1, 16
	mov	%g3, %g4
	mov	%g4, %g17
	subi	%g1, %g1, 24
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 24
	ld	%g3, %g1, 16
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.42617
	slli	%g4, %g3, 2
	add	%g26, %g16, %g4
	ld	%g4, %g26, 0
	ld	%g17, %g15, 0
	subi	%g17, %g17, 1
	st	%g3, %g1, 20
	mov	%g3, %g4
	mov	%g4, %g17
	subi	%g1, %g1, 28
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 28
	ld	%g3, %g1, 20
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.42618
	slli	%g4, %g3, 2
	add	%g26, %g16, %g4
	ld	%g4, %g26, 0
	ld	%g17, %g15, 0
	subi	%g17, %g17, 1
	st	%g3, %g1, 24
	mov	%g3, %g4
	mov	%g4, %g17
	subi	%g1, %g1, 32
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 32
	ld	%g3, %g1, 24
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.42619
	slli	%g4, %g3, 2
	add	%g26, %g16, %g4
	ld	%g4, %g26, 0
	ld	%g17, %g15, 0
	subi	%g17, %g17, 1
	st	%g3, %g1, 28
	mov	%g3, %g4
	mov	%g4, %g17
	subi	%g1, %g1, 36
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 36
	ld	%g3, %g1, 28
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.42620
	slli	%g4, %g3, 2
	add	%g26, %g16, %g4
	ld	%g4, %g26, 0
	ld	%g15, %g15, 0
	subi	%g15, %g15, 1
	st	%g3, %g1, 32
	mov	%g3, %g4
	mov	%g4, %g15
	subi	%g1, %g1, 40
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 40
	ld	%g3, %g1, 32
	subi	%g3, %g3, 1
	mov	%g4, %g3
	mov	%g3, %g16
	jmp	init_dirvec_constants.3017
jge_else.42620:
	return
jge_else.42619:
	return
jge_else.42618:
	return
jge_else.42617:
	return
jge_else.42616:
	return
jge_else.42615:
	return
jge_else.42614:
	return
jge_else.42613:
	return
init_vecset_constants.3020:
	ld	%g4, %g31, 708
	ld	%g15, %g31, 828
	jlt	%g3, %g0, jge_else.42629
	slli	%g16, %g3, 2
	add	%g26, %g4, %g16
	ld	%g16, %g26, 0
	ld	%g17, %g16, -476
	ld	%g18, %g15, 0
	subi	%g18, %g18, 1
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	mov	%g4, %g18
	mov	%g3, %g17
	subi	%g1, %g1, 12
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 12
	ld	%g3, %g16, -472
	ld	%g4, %g15, 0
	subi	%g4, %g4, 1
	subi	%g1, %g1, 12
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 12
	ld	%g3, %g16, -468
	ld	%g4, %g15, 0
	subi	%g4, %g4, 1
	subi	%g1, %g1, 12
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 12
	ld	%g3, %g16, -464
	ld	%g4, %g15, 0
	subi	%g4, %g4, 1
	subi	%g1, %g1, 12
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 12
	ld	%g3, %g16, -460
	ld	%g4, %g15, 0
	subi	%g4, %g4, 1
	subi	%g1, %g1, 12
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 12
	ld	%g3, %g16, -456
	ld	%g4, %g15, 0
	subi	%g4, %g4, 1
	subi	%g1, %g1, 12
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 12
	ld	%g3, %g16, -452
	ld	%g4, %g15, 0
	subi	%g4, %g4, 1
	subi	%g1, %g1, 12
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 12
	ld	%g3, %g16, -448
	ld	%g4, %g15, 0
	subi	%g4, %g4, 1
	subi	%g1, %g1, 12
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 12
	addi	%g3, %g0, 111
	st	%g15, %g1, 8
	mov	%g4, %g3
	mov	%g3, %g16
	subi	%g1, %g1, 16
	call	init_dirvec_constants.3017
	addi	%g1, %g1, 16
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.42630
	slli	%g4, %g3, 2
	ld	%g15, %g1, 0
	add	%g26, %g15, %g4
	ld	%g4, %g26, 0
	ld	%g15, %g4, -476
	ld	%g16, %g1, 8
	ld	%g17, %g16, 0
	subi	%g17, %g17, 1
	st	%g3, %g1, 12
	st	%g4, %g1, 16
	mov	%g4, %g17
	mov	%g3, %g15
	subi	%g1, %g1, 24
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 24
	ld	%g3, %g1, 16
	ld	%g4, %g3, -472
	ld	%g15, %g16, 0
	subi	%g15, %g15, 1
	mov	%g3, %g4
	mov	%g4, %g15
	subi	%g1, %g1, 24
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 24
	ld	%g3, %g1, 16
	ld	%g4, %g3, -468
	ld	%g15, %g16, 0
	subi	%g15, %g15, 1
	mov	%g3, %g4
	mov	%g4, %g15
	subi	%g1, %g1, 24
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 24
	ld	%g3, %g1, 16
	ld	%g4, %g3, -464
	ld	%g15, %g16, 0
	subi	%g15, %g15, 1
	mov	%g3, %g4
	mov	%g4, %g15
	subi	%g1, %g1, 24
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 24
	ld	%g3, %g1, 16
	ld	%g4, %g3, -460
	ld	%g15, %g16, 0
	subi	%g15, %g15, 1
	mov	%g3, %g4
	mov	%g4, %g15
	subi	%g1, %g1, 24
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 24
	ld	%g3, %g1, 16
	ld	%g4, %g3, -456
	ld	%g15, %g16, 0
	subi	%g15, %g15, 1
	mov	%g3, %g4
	mov	%g4, %g15
	subi	%g1, %g1, 24
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 24
	ld	%g3, %g1, 16
	ld	%g4, %g3, -452
	ld	%g15, %g16, 0
	subi	%g15, %g15, 1
	mov	%g3, %g4
	mov	%g4, %g15
	subi	%g1, %g1, 24
	call	iter_setup_dirvec_constants.2801
	addi	%g1, %g1, 24
	addi	%g3, %g0, 112
	ld	%g4, %g1, 16
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 24
	call	init_dirvec_constants.3017
	addi	%g1, %g1, 24
	ld	%g3, %g1, 12
	subi	%g3, %g3, 1
	jmp	init_vecset_constants.3020
jge_else.42630:
	return
jge_else.42629:
	return
