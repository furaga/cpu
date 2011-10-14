.init_heap_size	1216
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
l.7541:	! 128.000000
	.long	0x43000000
l.7476:	! 0.900000
	.long	0x3f66665e
l.7474:	! 0.200000
	.long	0x3e4cccc4
l.7291:	! 150.000000
	.long	0x43160000
l.7287:	! -150.000000
	.long	0xc3160000
l.7258:	! 0.100000
	.long	0x3dccccc4
l.7252:	! -2.000000
	.long	0xc0000000
l.7248:	! 0.003906
	.long	0x3b800000
l.7202:	! 20.000000
	.long	0x41a00000
l.7200:	! 0.050000
	.long	0x3d4cccc4
l.7191:	! 0.250000
	.long	0x3e800000
l.7181:	! 10.000000
	.long	0x41200000
l.7174:	! 0.300000
	.long	0x3e999999
l.7172:	! 255.000000
	.long	0x437f0000
l.7168:	! 0.500000
	.long	0x3f000000
l.7166:	! 0.150000
	.long	0x3e199999
l.7158:	! 3.141593
	.long	0x40490fda
l.7156:	! 30.000000
	.long	0x41f00000
l.7154:	! 15.000000
	.long	0x41700000
l.7152:	! 0.000100
	.long	0x38d1b70f
l.7078:	! 100000000.000000
	.long	0x4cbebc20
l.7070:	! 1000000000.000000
	.long	0x4e6e6b28
l.7031:	! -0.100000
	.long	0xbdccccc4
l.7005:	! 0.010000
	.long	0x3c23d70a
l.7003:	! -0.200000
	.long	0xbe4cccc4
l.6623:	! -200.000000
	.long	0xc3480000
l.6620:	! 200.000000
	.long	0x43480000
l.6615:	! 0.017453
	.long	0x3c8efa2d
l.6470:	! -1.000000
	.long	0xbf800000
l.6468:	! 1.000000
	.long	0x3f800000
l.6412:	! 2.000000
	.long	0x40000000
l.6407:	! 0.000000
	.long	0x0
	jmp	min_caml_start

!#####################################################################
!
! 		↓　ここから lib_asm.s
!
!#####################################################################

!#####################################################################
! * 算術関数用定数テーブル
!#####################################################################

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
	call min_caml_ceil
	fneg %f0, %f0
	return


!#####################################################################
!
! 		↑　ここまで lib_asm.s
!
!#####################################################################

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

fless.2610:
	fjlt	%f0, %f1, fjge_else.9775
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.9775:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fispos.2613:
	setL %g3, l.6407
	fld	%f1, %g3, 0
	fjlt	%f1, %f0, fjge_else.9776
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.9776:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fisneg.2615:
	setL %g3, l.6407
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.9777
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjge_else.9777:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fiszero.2617:
	setL %g3, l.6407
	fld	%f1, %g3, 0
	fjeq	%f0, %f1, fjne_else.9778
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fjne_else.9778:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
fabs.2622:
	setL %g3, l.6407
	fld	%f1, %g3, 0
	fjlt	%f0, %f1, fjge_else.9779
	return
fjge_else.9779:
	fneg	%f0, %f0
	return
fneg.2626:
	fneg	%f0, %f0
	return
fhalf.2628:
	setL %g3, l.6412
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	return
fsqr.2630:
	fmul	%f0, %f0, %f0
	return
mul10.2632:
	muli	%g4, %g3, 8
	muli	%g3, %g3, 2
	add	%g3, %g4, %g3
	return
read_int_token.2636:
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	st	%g3, %g1, 0
	st	%g29, %g1, 4
	st	%g6, %g1, 8
	st	%g4, %g1, 12
	st	%g5, %g1, 16
	input	%g3
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 48
	jlt	%g4, %g3, jle_else.9780
	mvhi	%g3, 0
	mvlo	%g3, 57
	jlt	%g3, %g4, jle_else.9782
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jle_cont.9783
jle_else.9782:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.9783:
	jmp	jle_cont.9781
jle_else.9780:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.9781:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.9784
	ld	%g3, %g1, 16
	ld	%g5, %g3, 0
	mvhi	%g6, 0
	mvlo	%g6, 0
	jne	%g5, %g6, jeq_else.9785
	mvhi	%g5, 0
	mvlo	%g5, 45
	ld	%g6, %g1, 12
	jne	%g6, %g5, jeq_else.9787
	mvhi	%g5, 65535
	mvlo	%g5, -1
	st	%g5, %g3, 0
	jmp	jeq_cont.9788
jeq_else.9787:
	mvhi	%g5, 0
	mvlo	%g5, 1
	st	%g5, %g3, 0
jeq_cont.9788:
	jmp	jeq_cont.9786
jeq_else.9785:
jeq_cont.9786:
	ld	%g3, %g1, 8
	ld	%g5, %g3, 0
	st	%g4, %g1, 20
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	mul10.2632
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	subi	%g5, %g4, 48
	add	%g3, %g3, %g5
	ld	%g5, %g1, 8
	st	%g3, %g5, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9784:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g5, %g1, 0
	jne	%g5, %g3, jeq_else.9789
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9789:
	ld	%g3, %g1, 16
	ld	%g3, %g3, 0
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.9790
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	return
jeq_else.9790:
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	sub	%g3, %g0, %g3
	return
read_int.2639:
	ld	%g3, %g29, -12
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	st	%g6, %g5, 0
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g5, %g4, 0
	mvhi	%g4, 0
	mvlo	%g4, 0
	mvhi	%g5, 0
	mvlo	%g5, 32
	mov	%g29, %g3
	mov	%g3, %g4
	mov	%g4, %g5
	ld	%g28, %g29, 0
	b	%g28
read_float_token1.2645:
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	st	%g3, %g1, 0
	st	%g29, %g1, 4
	st	%g6, %g1, 8
	st	%g4, %g1, 12
	st	%g5, %g1, 16
	input	%g3
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 48
	jlt	%g4, %g3, jle_else.9791
	mvhi	%g3, 0
	mvlo	%g3, 57
	jlt	%g3, %g4, jle_else.9793
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jle_cont.9794
jle_else.9793:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.9794:
	jmp	jle_cont.9792
jle_else.9791:
	mvhi	%g3, 0
	mvlo	%g3, 1
jle_cont.9792:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.9795
	ld	%g3, %g1, 16
	ld	%g5, %g3, 0
	mvhi	%g6, 0
	mvlo	%g6, 0
	jne	%g5, %g6, jeq_else.9796
	mvhi	%g5, 0
	mvlo	%g5, 45
	ld	%g6, %g1, 12
	jne	%g6, %g5, jeq_else.9798
	mvhi	%g5, 65535
	mvlo	%g5, -1
	st	%g5, %g3, 0
	jmp	jeq_cont.9799
jeq_else.9798:
	mvhi	%g5, 0
	mvlo	%g5, 1
	st	%g5, %g3, 0
jeq_cont.9799:
	jmp	jeq_cont.9797
jeq_else.9796:
jeq_cont.9797:
	ld	%g3, %g1, 8
	ld	%g5, %g3, 0
	st	%g4, %g1, 20
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	mul10.2632
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	subi	%g5, %g4, 48
	add	%g3, %g3, %g5
	ld	%g5, %g1, 8
	st	%g3, %g5, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9795:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g5, %g1, 0
	jne	%g5, %g3, jeq_else.9800
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9800:
	mov	%g3, %g4
	return
read_float_token2.2648:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	st	%g3, %g1, 0
	st	%g29, %g1, 4
	st	%g5, %g1, 8
	st	%g4, %g1, 12
	input	%g3
	mvhi	%g4, 0
	mvlo	%g4, 48
	jlt	%g3, %g4, jle_else.9801
	mvhi	%g4, 0
	mvlo	%g4, 57
	jlt	%g4, %g3, jle_else.9803
	mvhi	%g4, 0
	mvlo	%g4, 0
	jmp	jle_cont.9804
jle_else.9803:
	mvhi	%g4, 0
	mvlo	%g4, 1
jle_cont.9804:
	jmp	jle_cont.9802
jle_else.9801:
	mvhi	%g4, 0
	mvlo	%g4, 1
jle_cont.9802:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g4, %g5, jeq_else.9805
	ld	%g4, %g1, 12
	ld	%g5, %g4, 0
	st	%g3, %g1, 16
	mov	%g3, %g5
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	mul10.2632
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 16
	subi	%g4, %g4, 48
	add	%g3, %g3, %g4
	ld	%g4, %g1, 12
	st	%g3, %g4, 0
	ld	%g3, %g1, 8
	ld	%g4, %g3, 0
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	mul10.2632
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	st	%g3, %g4, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9805:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 0
	jne	%g4, %g3, jeq_else.9806
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9806:
	return
read_float.2650:
	ld	%g3, %g29, -24
	ld	%g4, %g29, -20
	ld	%g5, %g29, -16
	ld	%g6, %g29, -12
	ld	%g7, %g29, -8
	ld	%g8, %g29, -4
	mvhi	%g9, 0
	mvlo	%g9, 0
	st	%g9, %g6, 0
	mvhi	%g9, 0
	mvlo	%g9, 0
	st	%g9, %g7, 0
	mvhi	%g9, 0
	mvlo	%g9, 1
	st	%g9, %g8, 0
	mvhi	%g9, 0
	mvlo	%g9, 0
	st	%g9, %g5, 0
	mvhi	%g9, 0
	mvlo	%g9, 0
	mvhi	%g10, 0
	mvlo	%g10, 32
	st	%g5, %g1, 0
	st	%g8, %g1, 4
	st	%g7, %g1, 8
	st	%g6, %g1, 12
	st	%g3, %g1, 16
	mov	%g3, %g9
	mov	%g29, %g4
	mov	%g4, %g10
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 46
	jne	%g3, %g4, jeq_else.9808
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	ld	%g3, %g3, 0
	float_of_int	%f0, %g3
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	fst	%f0, %g1, 20
	float_of_int	%f0, %g3
	ld	%g3, %g1, 4
	ld	%g3, %g3, 0
	fst	%f0, %g1, 24
	float_of_int	%f0, %g3
	fld	%f1, %g1, 24
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 20
	fadd	%f0, %f1, %f0
	jmp	jeq_cont.9809
jeq_else.9808:
	ld	%g3, %g1, 12
	ld	%g3, %g3, 0
	float_of_int	%f0, %g3
jeq_cont.9809:
	ld	%g3, %g1, 0
	ld	%g3, %g3, 0
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.9810
	return
jeq_else.9810:
	fneg	%f0, %f0
	return
print_int_get_digits.2654:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	ld	%g6, %g4, 0
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g7, %g6, jle_else.9811
	subi	%g3, %g3, 1
	return
jle_else.9811:
	ld	%g6, %g4, 0
	divi	%g6, %g6, 10
	ld	%g7, %g4, 0
	muli	%g8, %g6, 10
	sub	%g7, %g7, %g8
	slli	%g8, %g3, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g8
	st	%g7, %g5, 0
	ld	%g5, %g1, 4
	st	%g6, %g4, 0
	addi	%g3, %g3, 1
	ld	%g28, %g29, 0
	b	%g28
print_int_print_digits.2656:
	ld	%g4, %g29, -4
	mvhi	%g5, 0
	mvlo	%g5, 0
	jlt	%g3, %g5, jle_else.9812
	slli	%g5, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g5
	ld	%g4, %g4, 0
	addi	%g4, %g4, 48
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g4
	output	%g3
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.9812:
	return
print_int.2658:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g29, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g3, %g6, jle_else.9814
	mov	%g6, %g3
	jmp	jle_cont.9815
jle_else.9814:
	sub	%g6, %g0, %g3
jle_cont.9815:
	st	%g6, %g4, 0
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g5, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g4
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g5, %g1, 4
	st	%g3, %g1, 8
	jlt	%g5, %g4, jle_else.9816
	jmp	jle_cont.9817
jle_else.9816:
	mvhi	%g4, 0
	mvlo	%g4, 45
	mov	%g3, %g4
	output	%g3
jle_cont.9817:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 8
	jlt	%g4, %g3, jle_else.9818
	ld	%g29, %g1, 0
	mov	%g3, %g4
	ld	%g28, %g29, 0
	b	%g28
jle_else.9818:
	mvhi	%g3, 0
	mvlo	%g3, 48
	output	%g3
	return
xor.2690:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.9819
	mov	%g3, %g4
	return
jeq_else.9819:
	mvhi	%g3, 0
	mvlo	%g3, 0
	jne	%g4, %g3, jeq_else.9820
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.9820:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
sgn.2693:
	fst	%f0, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	fiszero.2617
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9821
	fld	%f0, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	fispos.2613
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9822
	setL %g3, l.6470
	fld	%f0, %g3, 0
	return
jeq_else.9822:
	setL %g3, l.6468
	fld	%f0, %g3, 0
	return
jeq_else.9821:
	setL %g3, l.6407
	fld	%f0, %g3, 0
	return
fneg_cond.2695:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9823
	jmp	fneg.2626
jeq_else.9823:
	return
add_mod5.2698:
	add	%g3, %g3, %g4
	mvhi	%g4, 0
	mvlo	%g4, 5
	jlt	%g3, %g4, jle_else.9824
	subi	%g3, %g3, 5
	return
jle_else.9824:
	return
vecset.2701:
	fst	%f0, %g3, 0
	fst	%f1, %g3, -4
	fst	%f2, %g3, -8
	return
vecfill.2706:
	fst	%f0, %g3, 0
	fst	%f0, %g3, -4
	fst	%f0, %g3, -8
	return
vecbzero.2709:
	setL %g4, l.6407
	fld	%f0, %g4, 0
	jmp	vecfill.2706
veccpy.2711:
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	fld	%f0, %g4, -4
	fst	%f0, %g3, -4
	fld	%f0, %g4, -8
	fst	%f0, %g3, -8
	return
vecunit_sgn.2719:
	fld	%f0, %g3, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fsqr.2630
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	fld	%f1, %g3, -4
	fst	%f0, %g1, 8
	fmov	%f0, %f1
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fsqr.2630
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f1, %g1, 8
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, -8
	fst	%f0, %g1, 12
	fmov	%f0, %f1
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fsqr.2630
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 12
	fadd	%f0, %f1, %f0
	fsqrt	%f0, %f0
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fiszero.2617
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9828
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 0
	jne	%g4, %g3, jeq_else.9830
	setL %g3, l.6468
	fld	%f0, %g3, 0
	fld	%f1, %g1, 16
	fdiv	%f0, %f0, %f1
	jmp	jeq_cont.9831
jeq_else.9830:
	setL %g3, l.6470
	fld	%f0, %g3, 0
	fld	%f1, %g1, 16
	fdiv	%f0, %f0, %f1
jeq_cont.9831:
	jmp	jeq_cont.9829
jeq_else.9828:
	setL %g3, l.6468
	fld	%f0, %g3, 0
jeq_cont.9829:
	ld	%g3, %g1, 4
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	fst	%f1, %g3, 0
	fld	%f1, %g3, -4
	fmul	%f1, %f1, %f0
	fst	%f1, %g3, -4
	fld	%f1, %g3, -8
	fmul	%f0, %f1, %f0
	fst	%f0, %g3, -8
	return
veciprod.2722:
	fld	%f0, %g3, 0
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
	return
veciprod2.2725:
	fld	%f3, %g3, 0
	fmul	%f0, %f3, %f0
	fld	%f3, %g3, -4
	fmul	%f1, %f3, %f1
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	return
vecaccum.2730:
	fld	%f1, %g3, 0
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
	return
vecadd.2734:
	fld	%f0, %g3, 0
	fld	%f1, %g4, 0
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, 0
	fld	%f0, %g3, -4
	fld	%f1, %g4, -4
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, -4
	fld	%f0, %g3, -8
	fld	%f1, %g4, -8
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, -8
	return
vecscale.2740:
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	fst	%f1, %g3, 0
	fld	%f1, %g3, -4
	fmul	%f1, %f1, %f0
	fst	%f1, %g3, -4
	fld	%f1, %g3, -8
	fmul	%f0, %f1, %f0
	fst	%f0, %g3, -8
	return
vecaccumv.2743:
	fld	%f0, %g3, 0
	fld	%f1, %g4, 0
	fld	%f2, %g5, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, 0
	fld	%f0, %g3, -4
	fld	%f1, %g4, -4
	fld	%f2, %g5, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, -4
	fld	%f0, %g3, -8
	fld	%f1, %g4, -8
	fld	%f2, %g5, -8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, -8
	return
o_texturetype.2747:
	ld	%g3, %g3, 0
	return
o_form.2749:
	ld	%g3, %g3, -4
	return
o_reflectiontype.2751:
	ld	%g3, %g3, -8
	return
o_isinvert.2753:
	ld	%g3, %g3, -24
	return
o_isrot.2755:
	ld	%g3, %g3, -12
	return
o_param_a.2757:
	ld	%g3, %g3, -16
	fld	%f0, %g3, 0
	return
o_param_b.2759:
	ld	%g3, %g3, -16
	fld	%f0, %g3, -4
	return
o_param_c.2761:
	ld	%g3, %g3, -16
	fld	%f0, %g3, -8
	return
o_param_abc.2763:
	ld	%g3, %g3, -16
	return
o_param_x.2765:
	ld	%g3, %g3, -20
	fld	%f0, %g3, 0
	return
o_param_y.2767:
	ld	%g3, %g3, -20
	fld	%f0, %g3, -4
	return
o_param_z.2769:
	ld	%g3, %g3, -20
	fld	%f0, %g3, -8
	return
o_diffuse.2771:
	ld	%g3, %g3, -28
	fld	%f0, %g3, 0
	return
o_hilight.2773:
	ld	%g3, %g3, -28
	fld	%f0, %g3, -4
	return
o_color_red.2775:
	ld	%g3, %g3, -32
	fld	%f0, %g3, 0
	return
o_color_green.2777:
	ld	%g3, %g3, -32
	fld	%f0, %g3, -4
	return
o_color_blue.2779:
	ld	%g3, %g3, -32
	fld	%f0, %g3, -8
	return
o_param_r1.2781:
	ld	%g3, %g3, -36
	fld	%f0, %g3, 0
	return
o_param_r2.2783:
	ld	%g3, %g3, -36
	fld	%f0, %g3, -4
	return
o_param_r3.2785:
	ld	%g3, %g3, -36
	fld	%f0, %g3, -8
	return
o_param_ctbl.2787:
	ld	%g3, %g3, -40
	return
p_rgb.2789:
	ld	%g3, %g3, 0
	return
p_intersection_points.2791:
	ld	%g3, %g3, -4
	return
p_surface_ids.2793:
	ld	%g3, %g3, -8
	return
p_calc_diffuse.2795:
	ld	%g3, %g3, -12
	return
p_energy.2797:
	ld	%g3, %g3, -16
	return
p_received_ray_20percent.2799:
	ld	%g3, %g3, -20
	return
p_group_id.2801:
	ld	%g3, %g3, -24
	ld	%g3, %g3, 0
	return
p_set_group_id.2803:
	ld	%g3, %g3, -24
	st	%g4, %g3, 0
	return
p_nvectors.2806:
	ld	%g3, %g3, -28
	return
d_vec.2808:
	ld	%g3, %g3, 0
	return
d_const.2810:
	ld	%g3, %g3, -4
	return
r_surface_id.2812:
	ld	%g3, %g3, 0
	return
r_dvec.2814:
	ld	%g3, %g3, -4
	return
r_bright.2816:
	fld	%f0, %g3, -8
	return
rad.2818:
	setL %g3, l.6615
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	return
read_screen_settings.2820:
	ld	%g3, %g29, -24
	ld	%g4, %g29, -20
	ld	%g5, %g29, -16
	ld	%g6, %g29, -12
	ld	%g7, %g29, -8
	ld	%g29, %g29, -4
	st	%g3, %g1, 0
	st	%g5, %g1, 4
	st	%g6, %g1, 8
	st	%g4, %g1, 12
	st	%g29, %g1, 16
	st	%g7, %g1, 20
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 20
	fst	%f0, %g3, 0
	ld	%g29, %g1, 16
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 20
	fst	%f0, %g3, -4
	ld	%g29, %g1, 16
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 20
	fst	%f0, %g3, -8
	ld	%g29, %g1, 16
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	rad.2818
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 24
	cos	%f0, %f0
	fld	%f1, %g1, 24
	fst	%f0, %g1, 28
	fmov	%f0, %f1
	sin	%f0, %f0
	ld	%g29, %g1, 16
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	rad.2818
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fst	%f0, %g1, 36
	cos	%f0, %f0
	fld	%f1, %g1, 36
	fst	%f0, %g1, 40
	fmov	%f0, %f1
	sin	%f0, %f0
	fld	%f1, %g1, 28
	fmul	%f2, %f1, %f0
	setL %g3, l.6620
	fld	%f3, %g3, 0
	fmul	%f2, %f2, %f3
	ld	%g3, %g1, 12
	fst	%f2, %g3, 0
	setL %g4, l.6623
	fld	%f2, %g4, 0
	fld	%f3, %g1, 32
	fmul	%f2, %f3, %f2
	fst	%f2, %g3, -4
	fld	%f2, %g1, 40
	fmul	%f4, %f1, %f2
	setL %g4, l.6620
	fld	%f5, %g4, 0
	fmul	%f4, %f4, %f5
	fst	%f4, %g3, -8
	ld	%g4, %g1, 8
	fst	%f2, %g4, 0
	setL %g5, l.6407
	fld	%f4, %g5, 0
	fst	%f4, %g4, -4
	fst	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2626
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 8
	fst	%f0, %g3, -8
	fld	%f0, %g1, 32
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2626
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 44
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 4
	fst	%f0, %g3, 0
	fld	%f0, %g1, 28
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2626
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 4
	fst	%f0, %g3, -4
	fld	%f0, %g1, 32
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2626
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 40
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 4
	fst	%f0, %g3, -8
	ld	%g3, %g1, 20
	fld	%f0, %g3, 0
	ld	%g4, %g1, 12
	fld	%f1, %g4, 0
	fsub	%f0, %f0, %f1
	ld	%g5, %g1, 0
	fst	%f0, %g5, 0
	fld	%f0, %g3, -4
	fld	%f1, %g4, -4
	fsub	%f0, %f0, %f1
	fst	%f0, %g5, -4
	fld	%f0, %g3, -8
	fld	%f1, %g4, -8
	fsub	%f0, %f0, %f1
	fst	%f0, %g5, -8
	return
read_light.2822:
	ld	%g3, %g29, -16
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	st	%g6, %g1, 0
	st	%g5, %g1, 4
	st	%g4, %g1, 8
	mov	%g29, %g3
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g29, %g1, 8
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	rad.2818
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fst	%f0, %g1, 12
	sin	%f0, %f0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fneg.2626
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 4
	fst	%f0, %g3, -4
	ld	%g29, %g1, 8
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	rad.2818
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 12
	fst	%f0, %g1, 16
	fmov	%f0, %f1
	cos	%f0, %f0
	fld	%f1, %g1, 16
	fst	%f0, %g1, 20
	fmov	%f0, %f1
	sin	%f0, %f0
	fld	%f1, %g1, 20
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g3, 0
	fld	%f0, %g1, 16
	cos	%f0, %f0
	fld	%f1, %g1, 20
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g3, -8
	ld	%g29, %g1, 8
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	return
rotate_quadratic_matrix.2824:
	fld	%f0, %g4, 0
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	cos	%f0, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, 0
	fst	%f0, %g1, 8
	fmov	%f0, %f1
	sin	%f0, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, -4
	fst	%f0, %g1, 12
	fmov	%f0, %f1
	cos	%f0, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, -4
	fst	%f0, %g1, 16
	fmov	%f0, %f1
	sin	%f0, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, -8
	fst	%f0, %g1, 20
	fmov	%f0, %f1
	cos	%f0, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, -8
	fst	%f0, %g1, 24
	fmov	%f0, %f1
	sin	%f0, %f0
	fld	%f1, %g1, 24
	fld	%f2, %g1, 16
	fmul	%f3, %f2, %f1
	fld	%f4, %g1, 20
	fld	%f5, %g1, 12
	fmul	%f6, %f5, %f4
	fmul	%f6, %f6, %f1
	fld	%f7, %g1, 8
	fmul	%f8, %f7, %f0
	fsub	%f6, %f6, %f8
	fmul	%f8, %f7, %f4
	fmul	%f8, %f8, %f1
	fmul	%f9, %f5, %f0
	fadd	%f8, %f8, %f9
	fmul	%f9, %f2, %f0
	fmul	%f10, %f5, %f4
	fmul	%f10, %f10, %f0
	fmul	%f11, %f7, %f1
	fadd	%f10, %f10, %f11
	fmul	%f11, %f7, %f4
	fmul	%f0, %f11, %f0
	fmul	%f1, %f5, %f1
	fsub	%f0, %f0, %f1
	fst	%f0, %g1, 28
	fst	%f8, %g1, 32
	fst	%f10, %g1, 36
	fst	%f6, %g1, 40
	fst	%f9, %g1, 44
	fst	%f3, %g1, 48
	fmov	%f0, %f4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2626
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 16
	fld	%f2, %g1, 12
	fmul	%f2, %f2, %f1
	fld	%f3, %g1, 8
	fmul	%f1, %f3, %f1
	ld	%g3, %g1, 0
	fld	%f3, %g3, 0
	fld	%f4, %g3, -4
	fld	%f5, %g3, -8
	fld	%f6, %g1, 48
	fst	%f1, %g1, 52
	fst	%f2, %g1, 56
	fst	%f5, %g1, 60
	fst	%f0, %g1, 64
	fst	%f4, %g1, 68
	fst	%f3, %g1, 72
	fmov	%f0, %f6
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fsqr.2630
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 72
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 44
	fst	%f0, %g1, 76
	fmov	%f0, %f2
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	fsqr.2630
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fld	%f1, %g1, 68
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 76
	fadd	%f0, %f2, %f0
	fld	%f2, %g1, 64
	fst	%f0, %g1, 80
	fmov	%f0, %f2
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	fsqr.2630
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fld	%f1, %g1, 60
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 80
	fadd	%f0, %f2, %f0
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	fld	%f0, %g1, 40
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	fsqr.2630
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fld	%f1, %g1, 72
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 36
	fst	%f0, %g1, 84
	fmov	%f0, %f2
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	fsqr.2630
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	fld	%f1, %g1, 68
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 84
	fadd	%f0, %f2, %f0
	fld	%f2, %g1, 56
	fst	%f0, %g1, 88
	fmov	%f0, %f2
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	fsqr.2630
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	fld	%f1, %g1, 60
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 88
	fadd	%f0, %f2, %f0
	ld	%g3, %g1, 0
	fst	%f0, %g3, -4
	fld	%f0, %g1, 32
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	fsqr.2630
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	fld	%f1, %g1, 72
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 28
	fst	%f0, %g1, 92
	fmov	%f0, %f2
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	fsqr.2630
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	fld	%f1, %g1, 68
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 92
	fadd	%f0, %f2, %f0
	fld	%f2, %g1, 52
	fst	%f0, %g1, 96
	fmov	%f0, %f2
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	fsqr.2630
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	fld	%f1, %g1, 60
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 96
	fadd	%f0, %f2, %f0
	ld	%g3, %g1, 0
	fst	%f0, %g3, -8
	setL %g3, l.6412
	fld	%f0, %g3, 0
	fld	%f2, %g1, 40
	fld	%f3, %g1, 72
	fmul	%f4, %f3, %f2
	fld	%f5, %g1, 32
	fmul	%f4, %f4, %f5
	fld	%f6, %g1, 36
	fld	%f7, %g1, 68
	fmul	%f8, %f7, %f6
	fld	%f9, %g1, 28
	fmul	%f8, %f8, %f9
	fadd	%f4, %f4, %f8
	fld	%f8, %g1, 56
	fmul	%f10, %f1, %f8
	fld	%f11, %g1, 52
	fmul	%f10, %f10, %f11
	fadd	%f4, %f4, %f10
	fmul	%f0, %f0, %f4
	ld	%g3, %g1, 4
	fst	%f0, %g3, 0
	setL %g4, l.6412
	fld	%f0, %g4, 0
	fld	%f4, %g1, 48
	fmul	%f10, %f3, %f4
	fmul	%f5, %f10, %f5
	fld	%f10, %g1, 44
	fmul	%f12, %f7, %f10
	fmul	%f9, %f12, %f9
	fadd	%f5, %f5, %f9
	fld	%f9, %g1, 64
	fmul	%f12, %f1, %f9
	fmul	%f11, %f12, %f11
	fadd	%f5, %f5, %f11
	fmul	%f0, %f0, %f5
	fst	%f0, %g3, -4
	setL %g4, l.6412
	fld	%f0, %g4, 0
	fmul	%f3, %f3, %f4
	fmul	%f2, %f3, %f2
	fmul	%f3, %f7, %f10
	fmul	%f3, %f3, %f6
	fadd	%f2, %f2, %f3
	fmul	%f1, %f1, %f9
	fmul	%f1, %f1, %f8
	fadd	%f1, %f2, %f1
	fmul	%f0, %f0, %f1
	fst	%f0, %g3, -8
	return
read_nth_object.2827:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	st	%g6, %g1, 0
	st	%g3, %g1, 4
	st	%g5, %g1, 8
	st	%g4, %g1, 12
	mov	%g29, %g4
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 65535
	mvlo	%g4, -1
	jne	%g3, %g4, jeq_else.9841
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9841:
	ld	%g29, %g1, 12
	st	%g3, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g29, %g1, 12
	st	%g3, %g1, 20
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g29, %g1, 12
	st	%g3, %g1, 24
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 28
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_create_float_array
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g29, %g1, 8
	st	%g3, %g1, 32
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	fst	%f0, %g3, 0
	ld	%g29, %g1, 8
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	fst	%f0, %g3, -4
	ld	%g29, %g1, 8
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	fst	%f0, %g3, -8
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_create_float_array
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g29, %g1, 8
	st	%g3, %g1, 36
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 36
	fst	%f0, %g3, 0
	ld	%g29, %g1, 8
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 36
	fst	%f0, %g3, -4
	ld	%g29, %g1, 8
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 36
	fst	%f0, %g3, -8
	ld	%g29, %g1, 8
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fisneg.2615
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 2
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 40
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g29, %g1, 8
	st	%g3, %g1, 44
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 44
	fst	%f0, %g3, 0
	ld	%g29, %g1, 8
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 44
	fst	%f0, %g3, -4
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	min_caml_create_float_array
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g29, %g1, 8
	st	%g3, %g1, 48
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 48
	fst	%f0, %g3, 0
	ld	%g29, %g1, 8
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 48
	fst	%f0, %g3, -4
	ld	%g29, %g1, 8
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 48
	fst	%f0, %g3, -8
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	min_caml_create_float_array
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g5, %g1, 28
	jne	%g5, %g4, jeq_else.9842
	jmp	jeq_cont.9843
jeq_else.9842:
	ld	%g29, %g1, 8
	st	%g3, %g1, 52
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	rad.2818
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 52
	fst	%f0, %g3, 0
	ld	%g29, %g1, 8
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	rad.2818
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 52
	fst	%f0, %g3, -4
	ld	%g29, %g1, 8
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	rad.2818
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 52
	fst	%f0, %g3, -8
jeq_cont.9843:
	mvhi	%g4, 0
	mvlo	%g4, 2
	ld	%g5, %g1, 20
	jne	%g5, %g4, jeq_else.9844
	mvhi	%g4, 0
	mvlo	%g4, 1
	jmp	jeq_cont.9845
jeq_else.9844:
	ld	%g4, %g1, 40
jeq_cont.9845:
	mvhi	%g6, 0
	mvlo	%g6, 4
	setL %g7, l.6407
	fld	%f0, %g7, 0
	st	%g4, %g1, 56
	st	%g3, %g1, 52
	mov	%g3, %g6
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	min_caml_create_float_array
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g2
	addi	%g2, %g2, 48
	st	%g3, %g4, -40
	ld	%g3, %g1, 52
	st	%g3, %g4, -36
	ld	%g5, %g1, 48
	st	%g5, %g4, -32
	ld	%g5, %g1, 44
	st	%g5, %g4, -28
	ld	%g5, %g1, 56
	st	%g5, %g4, -24
	ld	%g5, %g1, 36
	st	%g5, %g4, -20
	ld	%g5, %g1, 32
	st	%g5, %g4, -16
	ld	%g6, %g1, 28
	st	%g6, %g4, -12
	ld	%g7, %g1, 24
	st	%g7, %g4, -8
	ld	%g7, %g1, 20
	st	%g7, %g4, -4
	ld	%g8, %g1, 16
	st	%g8, %g4, 0
	ld	%g8, %g1, 4
	slli	%g8, %g8, 2
	ld	%g9, %g1, 0
	st	%g9, %g1, 60
	add	%g9, %g9, %g8
	st	%g4, %g9, 0
	ld	%g9, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 3
	jne	%g7, %g4, jeq_else.9846
	fld	%f0, %g5, 0
	fst	%f0, %g1, 60
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fiszero.2617
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9848
	fld	%f0, %g1, 60
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	sgn.2693
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 60
	fst	%f0, %g1, 64
	fmov	%f0, %f1
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fsqr.2630
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 64
	fdiv	%f0, %f1, %f0
	jmp	jeq_cont.9849
jeq_else.9848:
	setL %g3, l.6407
	fld	%f0, %g3, 0
jeq_cont.9849:
	ld	%g3, %g1, 32
	fst	%f0, %g3, 0
	fld	%f0, %g3, -4
	fst	%f0, %g1, 68
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fiszero.2617
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9850
	fld	%f0, %g1, 68
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	sgn.2693
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 68
	fst	%f0, %g1, 72
	fmov	%f0, %f1
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fsqr.2630
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 72
	fdiv	%f0, %f1, %f0
	jmp	jeq_cont.9851
jeq_else.9850:
	setL %g3, l.6407
	fld	%f0, %g3, 0
jeq_cont.9851:
	ld	%g3, %g1, 32
	fst	%f0, %g3, -4
	fld	%f0, %g3, -8
	fst	%f0, %g1, 76
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	fiszero.2617
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9852
	fld	%f0, %g1, 76
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	sgn.2693
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fld	%f1, %g1, 76
	fst	%f0, %g1, 80
	fmov	%f0, %f1
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	fsqr.2630
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fld	%f1, %g1, 80
	fdiv	%f0, %f1, %f0
	jmp	jeq_cont.9853
jeq_else.9852:
	setL %g3, l.6407
	fld	%f0, %g3, 0
jeq_cont.9853:
	ld	%g3, %g1, 32
	fst	%f0, %g3, -8
	jmp	jeq_cont.9847
jeq_else.9846:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g7, %g4, jeq_else.9854
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g7, %g1, 40
	jne	%g7, %g4, jeq_else.9856
	mvhi	%g4, 0
	mvlo	%g4, 1
	jmp	jeq_cont.9857
jeq_else.9856:
	mvhi	%g4, 0
	mvlo	%g4, 0
jeq_cont.9857:
	mov	%g3, %g5
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	vecunit_sgn.2719
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	jmp	jeq_cont.9855
jeq_else.9854:
jeq_cont.9855:
jeq_cont.9847:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 28
	jne	%g4, %g3, jeq_else.9858
	jmp	jeq_cont.9859
jeq_else.9858:
	ld	%g3, %g1, 32
	ld	%g4, %g1, 52
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	rotate_quadratic_matrix.2824
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
jeq_cont.9859:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
read_object.2829:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 60
	jlt	%g3, %g6, jle_else.9860
	return
jle_else.9860:
	st	%g29, %g1, 0
	st	%g5, %g1, 4
	st	%g3, %g1, 8
	mov	%g29, %g4
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9862
	ld	%g3, %g1, 4
	ld	%g4, %g1, 8
	st	%g4, %g3, 0
	return
jeq_else.9862:
	ld	%g3, %g1, 8
	addi	%g3, %g3, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
read_all_object.2831:
	ld	%g29, %g29, -4
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g28, %g29, 0
	b	%g28
read_net_item.2833:
	ld	%g4, %g29, -4
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	mov	%g29, %g4
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 65535
	mvlo	%g4, -1
	jne	%g3, %g4, jeq_else.9864
	ld	%g3, %g1, 4
	addi	%g3, %g3, 1
	mvhi	%g4, 65535
	mvlo	%g4, -1
	jmp	min_caml_create_array
jeq_else.9864:
	ld	%g4, %g1, 4
	addi	%g5, %g4, 1
	ld	%g29, %g1, 0
	st	%g3, %g1, 8
	mov	%g3, %g5
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	slli	%g4, %g4, 2
	ld	%g5, %g1, 8
	st	%g3, %g1, 12
	add	%g3, %g3, %g4
	st	%g5, %g3, 0
	ld	%g3, %g1, 12
	return
read_or_network.2835:
	ld	%g4, %g29, -4
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g5
	mov	%g29, %g4
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mov	%g4, %g3
	ld	%g3, %g4, 0
	mvhi	%g5, 65535
	mvlo	%g5, -1
	jne	%g3, %g5, jeq_else.9865
	ld	%g3, %g1, 4
	addi	%g3, %g3, 1
	jmp	min_caml_create_array
jeq_else.9865:
	ld	%g3, %g1, 4
	addi	%g5, %g3, 1
	ld	%g29, %g1, 0
	st	%g4, %g1, 8
	mov	%g3, %g5
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	slli	%g4, %g4, 2
	ld	%g5, %g1, 8
	st	%g3, %g1, 12
	add	%g3, %g3, %g4
	st	%g5, %g3, 0
	ld	%g3, %g1, 12
	return
read_and_network.2837:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	st	%g29, %g1, 0
	st	%g5, %g1, 4
	st	%g3, %g1, 8
	mov	%g3, %g6
	mov	%g29, %g4
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g3, 0
	mvhi	%g5, 65535
	mvlo	%g5, -1
	jne	%g4, %g5, jeq_else.9866
	return
jeq_else.9866:
	ld	%g4, %g1, 8
	slli	%g5, %g4, 2
	ld	%g6, %g1, 4
	st	%g6, %g1, 12
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 12
	addi	%g3, %g4, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
read_parameter.2839:
	ld	%g3, %g29, -24
	ld	%g4, %g29, -20
	ld	%g5, %g29, -16
	ld	%g6, %g29, -12
	ld	%g7, %g29, -8
	ld	%g8, %g29, -4
	st	%g8, %g1, 0
	st	%g4, %g1, 4
	st	%g6, %g1, 8
	st	%g7, %g1, 12
	st	%g5, %g1, 16
	mov	%g29, %g3
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g29, %g1, 12
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 8
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g29, %g1, 4
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 0
	st	%g3, %g4, 0
	return
solver_rect_surface.2841:
	ld	%g8, %g29, -4
	slli	%g9, %g5, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g9
	fld	%f3, %g4, 0
	ld	%g4, %g1, 4
	st	%g8, %g1, 0
	fst	%f2, %g1, 4
	st	%g7, %g1, 8
	fst	%f1, %g1, 12
	st	%g6, %g1, 16
	fst	%f0, %g1, 20
	st	%g4, %g1, 24
	st	%g5, %g1, 28
	st	%g3, %g1, 32
	fmov	%f0, %f3
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fiszero.2617
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9869
	ld	%g3, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_abc.2763
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 32
	st	%g3, %g1, 36
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_isinvert.2753
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 28
	slli	%g5, %g4, 2
	ld	%g6, %g1, 24
	st	%g6, %g1, 44
	add	%g6, %g6, %g5
	fld	%f0, %g6, 0
	ld	%g6, %g1, 44
	st	%g3, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fisneg.2615
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mov	%g4, %g3
	ld	%g3, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	xor.2690
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 28
	slli	%g5, %g4, 2
	ld	%g6, %g1, 36
	st	%g6, %g1, 44
	add	%g6, %g6, %g5
	fld	%f0, %g6, 0
	ld	%g6, %g1, 44
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fneg_cond.2695
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 20
	fsub	%f0, %f0, %f1
	ld	%g3, %g1, 28
	slli	%g3, %g3, 2
	ld	%g4, %g1, 24
	st	%g4, %g1, 44
	add	%g4, %g4, %g3
	fld	%f1, %g4, 0
	ld	%g4, %g1, 44
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 16
	slli	%g5, %g3, 2
	st	%g4, %g1, 44
	add	%g4, %g4, %g5
	fld	%f1, %g4, 0
	ld	%g4, %g1, 44
	fmul	%f1, %f0, %f1
	fld	%f2, %g1, 12
	fadd	%f1, %f1, %f2
	fst	%f0, %g1, 44
	fmov	%f0, %f1
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fabs.2622
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 16
	slli	%g3, %g3, 2
	ld	%g4, %g1, 36
	st	%g4, %g1, 52
	add	%g4, %g4, %g3
	fld	%f1, %g4, 0
	ld	%g4, %g1, 52
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fless.2610
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9870
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9870:
	ld	%g3, %g1, 8
	slli	%g4, %g3, 2
	ld	%g5, %g1, 24
	st	%g5, %g1, 52
	add	%g5, %g5, %g4
	fld	%f0, %g5, 0
	ld	%g5, %g1, 52
	fld	%f1, %g1, 44
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 4
	fadd	%f0, %f0, %f2
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fabs.2622
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 8
	slli	%g3, %g3, 2
	ld	%g4, %g1, 36
	st	%g4, %g1, 52
	add	%g4, %g4, %g3
	fld	%f1, %g4, 0
	ld	%g4, %g1, 52
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fless.2610
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9871
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9871:
	ld	%g3, %g1, 0
	fld	%f0, %g1, 44
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.9869:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
solver_rect.2850:
	ld	%g29, %g29, -4
	mvhi	%g5, 0
	mvlo	%g5, 0
	mvhi	%g6, 0
	mvlo	%g6, 1
	mvhi	%g7, 0
	mvlo	%g7, 2
	fst	%f0, %g1, 0
	fst	%f2, %g1, 4
	fst	%f1, %g1, 8
	st	%g4, %g1, 12
	st	%g3, %g1, 16
	st	%g29, %g1, 20
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9872
	mvhi	%g5, 0
	mvlo	%g5, 1
	mvhi	%g6, 0
	mvlo	%g6, 2
	mvhi	%g7, 0
	mvlo	%g7, 0
	fld	%f0, %g1, 8
	fld	%f1, %g1, 4
	fld	%f2, %g1, 0
	ld	%g3, %g1, 16
	ld	%g4, %g1, 12
	ld	%g29, %g1, 20
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9873
	mvhi	%g5, 0
	mvlo	%g5, 2
	mvhi	%g6, 0
	mvlo	%g6, 0
	mvhi	%g7, 0
	mvlo	%g7, 1
	fld	%f0, %g1, 4
	fld	%f1, %g1, 0
	fld	%f2, %g1, 8
	ld	%g3, %g1, 16
	ld	%g4, %g1, 12
	ld	%g29, %g1, 20
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9874
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9874:
	mvhi	%g3, 0
	mvlo	%g3, 3
	return
jeq_else.9873:
	mvhi	%g3, 0
	mvlo	%g3, 2
	return
jeq_else.9872:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
solver_surface.2856:
	ld	%g5, %g29, -4
	st	%g5, %g1, 0
	fst	%f2, %g1, 4
	fst	%f1, %g1, 8
	fst	%f0, %g1, 12
	st	%g4, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_abc.2763
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g3
	ld	%g3, %g1, 16
	st	%g4, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	veciprod.2722
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fispos.2613
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9875
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9875:
	fld	%f0, %g1, 12
	fld	%f1, %g1, 8
	fld	%f2, %g1, 4
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	veciprod2.2725
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fneg.2626
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
quadratic.2862:
	fst	%f0, %g1, 0
	fst	%f2, %g1, 4
	fst	%f1, %g1, 8
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fsqr.2630
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_a.2757
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 16
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 8
	fst	%f0, %g1, 20
	fmov	%f0, %f1
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fsqr.2630
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 12
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_b.2759
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 20
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 4
	fst	%f0, %g1, 28
	fmov	%f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fsqr.2630
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 12
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_c.2761
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 28
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 12
	fst	%f0, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_isrot.2755
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9876
	fld	%f0, %g1, 36
	return
jeq_else.9876:
	fld	%f0, %g1, 4
	fld	%f1, %g1, 8
	fmul	%f2, %f1, %f0
	ld	%g3, %g1, 12
	fst	%f2, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_r1.2781
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 40
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 36
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 0
	fld	%f2, %g1, 4
	fmul	%f2, %f2, %f1
	ld	%g3, %g1, 12
	fst	%f0, %g1, 44
	fst	%f2, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_r2.2783
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 48
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 44
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 8
	fld	%f2, %g1, 0
	fmul	%f1, %f2, %f1
	ld	%g3, %g1, 12
	fst	%f0, %g1, 52
	fst	%f1, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_r3.2785
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 56
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 52
	fadd	%f0, %f1, %f0
	return
bilinear.2867:
	fmul	%f6, %f0, %f3
	fst	%f3, %g1, 0
	fst	%f0, %g1, 4
	fst	%f5, %g1, 8
	fst	%f2, %g1, 12
	st	%g3, %g1, 16
	fst	%f4, %g1, 20
	fst	%f1, %g1, 24
	fst	%f6, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_a.2757
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 28
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 20
	fld	%f2, %g1, 24
	fmul	%f3, %f2, %f1
	ld	%g3, %g1, 16
	fst	%f0, %g1, 32
	fst	%f3, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_b.2759
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 32
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 8
	fld	%f2, %g1, 12
	fmul	%f3, %f2, %f1
	ld	%g3, %g1, 16
	fst	%f0, %g1, 40
	fst	%f3, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_c.2761
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 44
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 40
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_isrot.2755
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9877
	fld	%f0, %g1, 48
	return
jeq_else.9877:
	fld	%f0, %g1, 20
	fld	%f1, %g1, 12
	fmul	%f2, %f1, %f0
	fld	%f3, %g1, 8
	fld	%f4, %g1, 24
	fmul	%f5, %f4, %f3
	fadd	%f2, %f2, %f5
	ld	%g3, %g1, 16
	fst	%f2, %g1, 52
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_r1.2781
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 52
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 8
	fld	%f2, %g1, 4
	fmul	%f1, %f2, %f1
	fld	%f3, %g1, 0
	fld	%f4, %g1, 12
	fmul	%f4, %f4, %f3
	fadd	%f1, %f1, %f4
	ld	%g3, %g1, 16
	fst	%f0, %g1, 56
	fst	%f1, %g1, 60
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	o_param_r2.2783
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 60
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 56
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 20
	fld	%f2, %g1, 4
	fmul	%f1, %f2, %f1
	fld	%f2, %g1, 0
	fld	%f3, %g1, 24
	fmul	%f2, %f3, %f2
	fadd	%f1, %f1, %f2
	ld	%g3, %g1, 16
	fst	%f0, %g1, 64
	fst	%f1, %g1, 68
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	o_param_r3.2785
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 68
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 64
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fhalf.2628
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 48
	fadd	%f0, %f1, %f0
	return
solver_second.2875:
	ld	%g5, %g29, -4
	fld	%f3, %g4, 0
	fld	%f4, %g4, -4
	fld	%f5, %g4, -8
	st	%g5, %g1, 0
	fst	%f2, %g1, 4
	fst	%f1, %g1, 8
	fst	%f0, %g1, 12
	st	%g3, %g1, 16
	st	%g4, %g1, 20
	fmov	%f2, %f5
	fmov	%f1, %f4
	fmov	%f0, %f3
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	quadratic.2862
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fiszero.2617
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9878
	ld	%g3, %g1, 20
	fld	%f0, %g3, 0
	fld	%f1, %g3, -4
	fld	%f2, %g3, -8
	fld	%f3, %g1, 12
	fld	%f4, %g1, 8
	fld	%f5, %g1, 4
	ld	%g3, %g1, 16
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	bilinear.2867
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 12
	fld	%f2, %g1, 8
	fld	%f3, %g1, 4
	ld	%g3, %g1, 16
	fst	%f0, %g1, 28
	fmov	%f0, %f1
	fmov	%f1, %f2
	fmov	%f2, %f3
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	quadratic.2862
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 16
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_form.2749
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 3
	jne	%g3, %g4, jeq_else.9879
	setL %g3, l.6468
	fld	%f0, %g3, 0
	fld	%f1, %g1, 32
	fsub	%f0, %f1, %f0
	jmp	jeq_cont.9880
jeq_else.9879:
	fld	%f0, %g1, 32
jeq_cont.9880:
	fld	%f1, %g1, 28
	fst	%f0, %g1, 36
	fmov	%f0, %f1
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fsqr.2630
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fld	%f2, %g1, 24
	fmul	%f1, %f2, %f1
	fsub	%f0, %f0, %f1
	fst	%f0, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fispos.2613
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9881
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9881:
	fld	%f0, %g1, 40
	fsqrt	%f0, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_isinvert.2753
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9882
	fld	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2626
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	jmp	jeq_cont.9883
jeq_else.9882:
	fld	%f0, %g1, 44
jeq_cont.9883:
	fld	%f1, %g1, 28
	fsub	%f0, %f0, %f1
	fld	%f1, %g1, 24
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.9878:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
solver.2881:
	ld	%g6, %g29, -16
	ld	%g7, %g29, -12
	ld	%g8, %g29, -8
	ld	%g9, %g29, -4
	slli	%g3, %g3, 2
	st	%g9, %g1, 4
	add	%g9, %g9, %g3
	ld	%g3, %g9, 0
	ld	%g9, %g1, 4
	fld	%f0, %g5, 0
	st	%g7, %g1, 0
	st	%g6, %g1, 4
	st	%g4, %g1, 8
	st	%g8, %g1, 12
	st	%g3, %g1, 16
	st	%g5, %g1, 20
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_x.2765
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 20
	fld	%f1, %g3, -4
	ld	%g4, %g1, 16
	fst	%f0, %g1, 28
	fst	%f1, %g1, 32
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_y.2767
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 20
	fld	%f1, %g3, -8
	ld	%g3, %g1, 16
	fst	%f0, %g1, 36
	fst	%f1, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_z.2769
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 40
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_form.2749
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.9884
	fld	%f0, %g1, 28
	fld	%f1, %g1, 36
	fld	%f2, %g1, 44
	ld	%g3, %g1, 16
	ld	%g4, %g1, 8
	ld	%g29, %g1, 12
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9884:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.9885
	fld	%f0, %g1, 28
	fld	%f1, %g1, 36
	fld	%f2, %g1, 44
	ld	%g3, %g1, 16
	ld	%g4, %g1, 8
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9885:
	fld	%f0, %g1, 28
	fld	%f1, %g1, 36
	fld	%f2, %g1, 44
	ld	%g3, %g1, 16
	ld	%g4, %g1, 8
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
solver_rect_fast.2885:
	ld	%g6, %g29, -4
	fld	%f3, %g5, 0
	fsub	%f3, %f3, %f0
	fld	%f4, %g5, -4
	fmul	%f3, %f3, %f4
	fld	%f4, %g4, -4
	fmul	%f4, %f3, %f4
	fadd	%f4, %f4, %f1
	st	%g6, %g1, 0
	fst	%f0, %g1, 4
	fst	%f1, %g1, 8
	st	%g5, %g1, 12
	fst	%f2, %g1, 16
	fst	%f3, %g1, 20
	st	%g4, %g1, 24
	st	%g3, %g1, 28
	fmov	%f0, %f4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fabs.2622
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_b.2759
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fless.2610
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9886
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9887
jeq_else.9886:
	ld	%g3, %g1, 24
	fld	%f0, %g3, -8
	fld	%f1, %g1, 20
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 16
	fadd	%f0, %f0, %f2
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fabs.2622
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	fst	%f0, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_c.2761
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fless.2610
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9888
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9889
jeq_else.9888:
	ld	%g3, %g1, 12
	fld	%f0, %g3, -4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fiszero.2617
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9890
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.9891
jeq_else.9890:
	mvhi	%g3, 0
	mvlo	%g3, 0
jeq_cont.9891:
jeq_cont.9889:
jeq_cont.9887:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9892
	ld	%g3, %g1, 12
	fld	%f0, %g3, -8
	fld	%f1, %g1, 8
	fsub	%f0, %f0, %f1
	fld	%f2, %g3, -12
	fmul	%f0, %f0, %f2
	ld	%g4, %g1, 24
	fld	%f2, %g4, 0
	fmul	%f2, %f0, %f2
	fld	%f3, %g1, 4
	fadd	%f2, %f2, %f3
	fst	%f0, %g1, 40
	fmov	%f0, %f2
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fabs.2622
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 28
	fst	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_a.2757
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fless.2610
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9893
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9894
jeq_else.9893:
	ld	%g3, %g1, 24
	fld	%f0, %g3, -8
	fld	%f1, %g1, 40
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 16
	fadd	%f0, %f0, %f2
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fabs.2622
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 28
	fst	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_c.2761
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fless.2610
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9895
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9896
jeq_else.9895:
	ld	%g3, %g1, 12
	fld	%f0, %g3, -12
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fiszero.2617
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9897
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.9898
jeq_else.9897:
	mvhi	%g3, 0
	mvlo	%g3, 0
jeq_cont.9898:
jeq_cont.9896:
jeq_cont.9894:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9899
	ld	%g3, %g1, 12
	fld	%f0, %g3, -16
	fld	%f1, %g1, 16
	fsub	%f0, %f0, %f1
	fld	%f1, %g3, -20
	fmul	%f0, %f0, %f1
	ld	%g4, %g1, 24
	fld	%f1, %g4, 0
	fmul	%f1, %f0, %f1
	fld	%f2, %g1, 4
	fadd	%f1, %f1, %f2
	fst	%f0, %g1, 52
	fmov	%f0, %f1
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fabs.2622
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 28
	fst	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_a.2757
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fless.2610
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9900
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9901
jeq_else.9900:
	ld	%g3, %g1, 24
	fld	%f0, %g3, -4
	fld	%f1, %g1, 52
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 8
	fadd	%f0, %f0, %f2
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fabs.2622
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 28
	fst	%f0, %g1, 60
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	o_param_b.2759
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 60
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fless.2610
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9902
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9903
jeq_else.9902:
	ld	%g3, %g1, 12
	fld	%f0, %g3, -20
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fiszero.2617
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9904
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.9905
jeq_else.9904:
	mvhi	%g3, 0
	mvlo	%g3, 0
jeq_cont.9905:
jeq_cont.9903:
jeq_cont.9901:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9906
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9906:
	ld	%g3, %g1, 0
	fld	%f0, %g1, 52
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 3
	return
jeq_else.9899:
	ld	%g3, %g1, 0
	fld	%f0, %g1, 40
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 2
	return
jeq_else.9892:
	ld	%g3, %g1, 0
	fld	%f0, %g1, 20
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
solver_surface_fast.2892:
	ld	%g3, %g29, -4
	fld	%f3, %g4, 0
	st	%g3, %g1, 0
	fst	%f2, %g1, 4
	fst	%f1, %g1, 8
	fst	%f0, %g1, 12
	st	%g4, %g1, 16
	fmov	%f0, %f3
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fisneg.2615
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9907
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9907:
	ld	%g3, %g1, 16
	fld	%f0, %g3, -4
	fld	%f1, %g1, 12
	fmul	%f0, %f0, %f1
	fld	%f1, %g3, -8
	fld	%f2, %g1, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, -12
	fld	%f2, %g1, 4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
solver_second_fast.2898:
	ld	%g5, %g29, -4
	fld	%f3, %g4, 0
	st	%g5, %g1, 0
	fst	%f3, %g1, 4
	st	%g3, %g1, 8
	fst	%f2, %g1, 12
	fst	%f1, %g1, 16
	fst	%f0, %g1, 20
	st	%g4, %g1, 24
	fmov	%f0, %f3
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fiszero.2617
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9908
	ld	%g3, %g1, 24
	fld	%f0, %g3, -4
	fld	%f1, %g1, 20
	fmul	%f0, %f0, %f1
	fld	%f2, %g3, -8
	fld	%f3, %g1, 16
	fmul	%f2, %f2, %f3
	fadd	%f0, %f0, %f2
	fld	%f2, %g3, -12
	fld	%f4, %g1, 12
	fmul	%f2, %f2, %f4
	fadd	%f0, %f0, %f2
	ld	%g4, %g1, 8
	fst	%f0, %g1, 28
	mov	%g3, %g4
	fmov	%f2, %f4
	fmov	%f0, %f1
	fmov	%f1, %f3
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	quadratic.2862
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 8
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_form.2749
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 3
	jne	%g3, %g4, jeq_else.9909
	setL %g3, l.6468
	fld	%f0, %g3, 0
	fld	%f1, %g1, 32
	fsub	%f0, %f1, %f0
	jmp	jeq_cont.9910
jeq_else.9909:
	fld	%f0, %g1, 32
jeq_cont.9910:
	fld	%f1, %g1, 28
	fst	%f0, %g1, 36
	fmov	%f0, %f1
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fsqr.2630
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fld	%f2, %g1, 4
	fmul	%f1, %f2, %f1
	fsub	%f0, %f0, %f1
	fst	%f0, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fispos.2613
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9911
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9911:
	ld	%g3, %g1, 8
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_isinvert.2753
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9912
	fld	%f0, %g1, 40
	fsqrt	%f0, %f0
	fld	%f1, %g1, 28
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 24
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	jmp	jeq_cont.9913
jeq_else.9912:
	fld	%f0, %g1, 40
	fsqrt	%f0, %f0
	fld	%f1, %g1, 28
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 24
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
jeq_cont.9913:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.9908:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
solver_fast.2904:
	ld	%g6, %g29, -16
	ld	%g7, %g29, -12
	ld	%g8, %g29, -8
	ld	%g9, %g29, -4
	slli	%g10, %g3, 2
	st	%g9, %g1, 4
	add	%g9, %g9, %g10
	ld	%g9, %g9, 0
	fld	%f0, %g5, 0
	st	%g7, %g1, 0
	st	%g6, %g1, 4
	st	%g8, %g1, 8
	st	%g3, %g1, 12
	st	%g4, %g1, 16
	st	%g9, %g1, 20
	st	%g5, %g1, 24
	fst	%f0, %g1, 28
	mov	%g3, %g9
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_x.2765
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 28
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 24
	fld	%f1, %g3, -4
	ld	%g4, %g1, 20
	fst	%f0, %g1, 32
	fst	%f1, %g1, 36
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_y.2767
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 24
	fld	%f1, %g3, -8
	ld	%g3, %g1, 20
	fst	%f0, %g1, 40
	fst	%f1, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_z.2769
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 44
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	d_const.2810
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g4, %g1, 12
	slli	%g4, %g4, 2
	st	%g3, %g1, 52
	add	%g3, %g3, %g4
	ld	%g3, %g3, 0
	ld	%g4, %g1, 20
	st	%g3, %g1, 52
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_form.2749
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.9914
	ld	%g3, %g1, 16
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	d_vec.2808
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g3
	fld	%f0, %g1, 32
	fld	%f1, %g1, 40
	fld	%f2, %g1, 48
	ld	%g3, %g1, 20
	ld	%g5, %g1, 52
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9914:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.9915
	fld	%f0, %g1, 32
	fld	%f1, %g1, 40
	fld	%f2, %g1, 48
	ld	%g3, %g1, 20
	ld	%g4, %g1, 52
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9915:
	fld	%f0, %g1, 32
	fld	%f1, %g1, 40
	fld	%f2, %g1, 48
	ld	%g3, %g1, 20
	ld	%g4, %g1, 52
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
solver_surface_fast2.2908:
	ld	%g3, %g29, -4
	fld	%f0, %g4, 0
	st	%g3, %g1, 0
	st	%g5, %g1, 4
	st	%g4, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fisneg.2615
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9916
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9916:
	ld	%g3, %g1, 8
	fld	%f0, %g3, 0
	ld	%g3, %g1, 4
	fld	%f1, %g3, -12
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
solver_second_fast2.2915:
	ld	%g6, %g29, -4
	fld	%f3, %g4, 0
	st	%g6, %g1, 0
	st	%g3, %g1, 4
	fst	%f3, %g1, 8
	st	%g5, %g1, 12
	fst	%f2, %g1, 16
	fst	%f1, %g1, 20
	fst	%f0, %g1, 24
	st	%g4, %g1, 28
	fmov	%f0, %f3
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fiszero.2617
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9917
	ld	%g3, %g1, 28
	fld	%f0, %g3, -4
	fld	%f1, %g1, 24
	fmul	%f0, %f0, %f1
	fld	%f1, %g3, -8
	fld	%f2, %g1, 20
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, -12
	fld	%f2, %g1, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	ld	%g4, %g1, 12
	fld	%f1, %g4, -12
	fst	%f0, %g1, 32
	fst	%f1, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fsqr.2630
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fld	%f2, %g1, 8
	fmul	%f1, %f2, %f1
	fsub	%f0, %f0, %f1
	fst	%f0, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fispos.2613
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9918
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9918:
	ld	%g3, %g1, 4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_isinvert.2753
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9919
	fld	%f0, %g1, 40
	fsqrt	%f0, %f0
	fld	%f1, %g1, 32
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 28
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	jmp	jeq_cont.9920
jeq_else.9919:
	fld	%f0, %g1, 40
	fsqrt	%f0, %f0
	fld	%f1, %g1, 32
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 28
	fld	%f1, %g3, -16
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
jeq_cont.9920:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.9917:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
solver_fast2.2922:
	ld	%g5, %g29, -16
	ld	%g6, %g29, -12
	ld	%g7, %g29, -8
	ld	%g8, %g29, -4
	slli	%g9, %g3, 2
	st	%g8, %g1, 4
	add	%g8, %g8, %g9
	ld	%g8, %g8, 0
	st	%g6, %g1, 0
	st	%g5, %g1, 4
	st	%g7, %g1, 8
	st	%g8, %g1, 12
	st	%g3, %g1, 16
	st	%g4, %g1, 20
	mov	%g3, %g8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_ctbl.2787
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f0, %g3, 0
	fld	%f1, %g3, -4
	fld	%f2, %g3, -8
	ld	%g4, %g1, 20
	st	%g3, %g1, 24
	fst	%f2, %g1, 28
	fst	%f1, %g1, 32
	fst	%f0, %g1, 36
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	d_const.2810
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 16
	slli	%g4, %g4, 2
	st	%g3, %g1, 44
	add	%g3, %g3, %g4
	ld	%g3, %g3, 0
	ld	%g4, %g1, 12
	st	%g3, %g1, 40
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_form.2749
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.9921
	ld	%g3, %g1, 20
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	d_vec.2808
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mov	%g4, %g3
	fld	%f0, %g1, 36
	fld	%f1, %g1, 32
	fld	%f2, %g1, 28
	ld	%g3, %g1, 12
	ld	%g5, %g1, 40
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9921:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.9922
	fld	%f0, %g1, 36
	fld	%f1, %g1, 32
	fld	%f2, %g1, 28
	ld	%g3, %g1, 12
	ld	%g4, %g1, 40
	ld	%g5, %g1, 24
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9922:
	fld	%f0, %g1, 36
	fld	%f1, %g1, 32
	fld	%f2, %g1, 28
	ld	%g3, %g1, 12
	ld	%g4, %g1, 40
	ld	%g5, %g1, 24
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
setup_rect_table.2925:
	mvhi	%g5, 0
	mvlo	%g5, 6
	setL %g6, l.6407
	fld	%f0, %g6, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	fld	%f0, %g4, 0
	st	%g3, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fiszero.2617
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9923
	ld	%g3, %g1, 0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_isinvert.2753
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	fld	%f0, %g4, 0
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fisneg.2615
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g3
	ld	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	xor.2690
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 0
	st	%g3, %g1, 16
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_a.2757
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fneg_cond.2695
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 8
	fst	%f0, %g3, 0
	setL %g4, l.6468
	fld	%f0, %g4, 0
	ld	%g4, %g1, 4
	fld	%f1, %g4, 0
	fdiv	%f0, %f0, %f1
	fst	%f0, %g3, -4
	jmp	jeq_cont.9924
jeq_else.9923:
	setL %g3, l.6407
	fld	%f0, %g3, 0
	ld	%g3, %g1, 8
	fst	%f0, %g3, -4
jeq_cont.9924:
	ld	%g4, %g1, 4
	fld	%f0, %g4, -4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fiszero.2617
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9925
	ld	%g3, %g1, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_isinvert.2753
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 4
	fld	%f0, %g4, -4
	st	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fisneg.2615
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g3
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	xor.2690
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 0
	st	%g3, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_b.2759
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fneg_cond.2695
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 8
	fst	%f0, %g3, -8
	setL %g4, l.6468
	fld	%f0, %g4, 0
	ld	%g4, %g1, 4
	fld	%f1, %g4, -4
	fdiv	%f0, %f0, %f1
	fst	%f0, %g3, -12
	jmp	jeq_cont.9926
jeq_else.9925:
	setL %g3, l.6407
	fld	%f0, %g3, 0
	ld	%g3, %g1, 8
	fst	%f0, %g3, -12
jeq_cont.9926:
	ld	%g4, %g1, 4
	fld	%f0, %g4, -8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fiszero.2617
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9927
	ld	%g3, %g1, 0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_isinvert.2753
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 4
	fld	%f0, %g4, -8
	st	%g3, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fisneg.2615
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g4, %g3
	ld	%g3, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	xor.2690
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 0
	st	%g3, %g1, 32
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_c.2761
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg_cond.2695
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 8
	fst	%f0, %g3, -16
	setL %g4, l.6468
	fld	%f0, %g4, 0
	ld	%g4, %g1, 4
	fld	%f1, %g4, -8
	fdiv	%f0, %f0, %f1
	fst	%f0, %g3, -20
	jmp	jeq_cont.9928
jeq_else.9927:
	setL %g3, l.6407
	fld	%f0, %g3, 0
	ld	%g3, %g1, 8
	fst	%f0, %g3, -20
jeq_cont.9928:
	return
setup_surface_table.2928:
	mvhi	%g5, 0
	mvlo	%g5, 4
	setL %g6, l.6407
	fld	%f0, %g6, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	fld	%f0, %g4, 0
	ld	%g5, %g1, 0
	st	%g3, %g1, 8
	fst	%f0, %g1, 12
	mov	%g3, %g5
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_a.2757
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 12
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, -4
	ld	%g4, %g1, 0
	fst	%f0, %g1, 16
	fst	%f1, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_b.2759
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 20
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 16
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, -8
	ld	%g3, %g1, 0
	fst	%f0, %g1, 24
	fst	%f1, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_c.2761
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 28
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 24
	fadd	%f0, %f1, %f0
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fispos.2613
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9929
	setL %g3, l.6407
	fld	%f0, %g3, 0
	ld	%g3, %g1, 8
	fst	%f0, %g3, 0
	jmp	jeq_cont.9930
jeq_else.9929:
	setL %g3, l.6470
	fld	%f0, %g3, 0
	fld	%f1, %g1, 32
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 8
	fst	%f0, %g3, 0
	ld	%g4, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_a.2757
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fdiv	%f0, %f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2626
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 8
	fst	%f0, %g3, -4
	ld	%g4, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_b.2759
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fdiv	%f0, %f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2626
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 8
	fst	%f0, %g3, -8
	ld	%g4, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_c.2761
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fdiv	%f0, %f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2626
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 8
	fst	%f0, %g3, -12
jeq_cont.9930:
	return
setup_second_table.2931:
	mvhi	%g5, 0
	mvlo	%g5, 5
	setL %g6, l.6407
	fld	%f0, %g6, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	fld	%f0, %g4, 0
	fld	%f1, %g4, -4
	fld	%f2, %g4, -8
	ld	%g5, %g1, 0
	st	%g3, %g1, 8
	mov	%g3, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	quadratic.2862
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	fld	%f1, %g3, 0
	ld	%g4, %g1, 0
	fst	%f0, %g1, 12
	fst	%f1, %g1, 16
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_a.2757
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 16
	fmul	%f0, %f1, %f0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fneg.2626
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 4
	fld	%f1, %g3, -4
	ld	%g4, %g1, 0
	fst	%f0, %g1, 20
	fst	%f1, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_b.2759
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fneg.2626
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 4
	fld	%f1, %g3, -8
	ld	%g4, %g1, 0
	fst	%f0, %g1, 28
	fst	%f1, %g1, 32
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_c.2761
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fmul	%f0, %f1, %f0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2626
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 8
	fld	%f1, %g1, 12
	fst	%f1, %g3, 0
	ld	%g4, %g1, 0
	fst	%f0, %g1, 36
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_isrot.2755
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9931
	ld	%g3, %g1, 8
	fld	%f0, %g1, 20
	fst	%f0, %g3, -4
	fld	%f0, %g1, 28
	fst	%f0, %g3, -8
	fld	%f0, %g1, 36
	fst	%f0, %g3, -12
	jmp	jeq_cont.9932
jeq_else.9931:
	ld	%g3, %g1, 4
	fld	%f0, %g3, -8
	ld	%g4, %g1, 0
	fst	%f0, %g1, 40
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_r2.2783
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 40
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, -4
	ld	%g4, %g1, 0
	fst	%f0, %g1, 44
	fst	%f1, %g1, 48
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_r3.2785
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 48
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 44
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fhalf.2628
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 20
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g3, -4
	ld	%g4, %g1, 4
	fld	%f0, %g4, -8
	ld	%g5, %g1, 0
	fst	%f0, %g1, 52
	mov	%g3, %g5
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_r1.2781
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 52
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, 0
	ld	%g4, %g1, 0
	fst	%f0, %g1, 56
	fst	%f1, %g1, 60
	mov	%g3, %g4
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	o_param_r3.2785
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 60
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 56
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fhalf.2628
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 28
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g3, -8
	ld	%g4, %g1, 4
	fld	%f0, %g4, -4
	ld	%g5, %g1, 0
	fst	%f0, %g1, 64
	mov	%g3, %g5
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	o_param_r1.2781
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 64
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, 0
	ld	%g3, %g1, 0
	fst	%f0, %g1, 68
	fst	%f1, %g1, 72
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	o_param_r2.2783
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 72
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 68
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fhalf.2628
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 36
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g3, -12
jeq_cont.9932:
	fld	%f0, %g1, 12
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fiszero.2617
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9933
	setL %g3, l.6468
	fld	%f0, %g3, 0
	fld	%f1, %g1, 12
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 8
	fst	%f0, %g3, -16
	jmp	jeq_cont.9934
jeq_else.9933:
jeq_cont.9934:
	ld	%g3, %g1, 8
	return
iter_setup_dirvec_constants.2934:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g4, %g6, jle_else.9935
	slli	%g6, %g4, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g6
	ld	%g5, %g5, 0
	st	%g29, %g1, 0
	st	%g4, %g1, 4
	st	%g5, %g1, 8
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	d_const.2810
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 12
	st	%g3, %g1, 16
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	d_vec.2808
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	st	%g3, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_form.2749
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.9936
	ld	%g3, %g1, 20
	ld	%g4, %g1, 8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	setup_rect_table.2925
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 4
	slli	%g5, %g4, 2
	ld	%g6, %g1, 16
	st	%g6, %g1, 28
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 28
	jmp	jeq_cont.9937
jeq_else.9936:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.9938
	ld	%g3, %g1, 20
	ld	%g4, %g1, 8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	setup_surface_table.2928
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 4
	slli	%g5, %g4, 2
	ld	%g6, %g1, 16
	st	%g6, %g1, 28
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 28
	jmp	jeq_cont.9939
jeq_else.9938:
	ld	%g3, %g1, 20
	ld	%g4, %g1, 8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	setup_second_table.2931
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 4
	slli	%g5, %g4, 2
	ld	%g6, %g1, 16
	st	%g6, %g1, 28
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 28
jeq_cont.9939:
jeq_cont.9937:
	subi	%g4, %g4, 1
	ld	%g3, %g1, 12
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.9935:
	return
setup_dirvec_constants.2937:
	ld	%g4, %g29, -8
	ld	%g29, %g29, -4
	ld	%g4, %g4, 0
	subi	%g4, %g4, 1
	ld	%g28, %g29, 0
	b	%g28
setup_startp_constants.2939:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g4, %g6, jle_else.9941
	slli	%g6, %g4, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g6
	ld	%g5, %g5, 0
	st	%g29, %g1, 0
	st	%g4, %g1, 4
	st	%g3, %g1, 8
	st	%g5, %g1, 12
	mov	%g3, %g5
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_ctbl.2787
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 12
	st	%g3, %g1, 16
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_form.2749
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 8
	fld	%f0, %g4, 0
	ld	%g5, %g1, 12
	st	%g3, %g1, 20
	fst	%f0, %g1, 24
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_x.2765
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g3, 0
	ld	%g4, %g1, 8
	fld	%f0, %g4, -4
	ld	%g5, %g1, 12
	fst	%f0, %g1, 28
	mov	%g3, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_y.2767
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 28
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g3, -4
	ld	%g4, %g1, 8
	fld	%f0, %g4, -8
	ld	%g5, %g1, 12
	fst	%f0, %g1, 32
	mov	%g3, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_z.2769
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 32
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fst	%f0, %g3, -8
	mvhi	%g4, 0
	mvlo	%g4, 2
	ld	%g5, %g1, 20
	jne	%g5, %g4, jeq_else.9942
	ld	%g4, %g1, 12
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_abc.2763
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 16
	fld	%f0, %g4, 0
	fld	%f1, %g4, -4
	fld	%f2, %g4, -8
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	veciprod2.2725
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 16
	fst	%f0, %g3, -12
	jmp	jeq_cont.9943
jeq_else.9942:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jlt	%g4, %g5, jle_else.9944
	jmp	jle_cont.9945
jle_else.9944:
	fld	%f0, %g3, 0
	fld	%f1, %g3, -4
	fld	%f2, %g3, -8
	ld	%g4, %g1, 12
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	quadratic.2862
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g3, 0
	mvlo	%g3, 3
	ld	%g4, %g1, 20
	jne	%g4, %g3, jeq_else.9946
	setL %g3, l.6468
	fld	%f1, %g3, 0
	fsub	%f0, %f0, %f1
	jmp	jeq_cont.9947
jeq_else.9946:
jeq_cont.9947:
	ld	%g3, %g1, 16
	fst	%f0, %g3, -12
jle_cont.9945:
jeq_cont.9943:
	ld	%g3, %g1, 4
	subi	%g4, %g3, 1
	ld	%g3, %g1, 8
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.9941:
	return
setup_startp.2942:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	st	%g3, %g1, 0
	st	%g5, %g1, 4
	st	%g6, %g1, 8
	mov	%g28, %g4
	mov	%g4, %g3
	mov	%g3, %g28
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	veccpy.2711
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 8
	ld	%g3, %g3, 0
	subi	%g4, %g3, 1
	ld	%g3, %g1, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
is_rect_outside.2944:
	fst	%f2, %g1, 0
	fst	%f1, %g1, 4
	st	%g3, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fabs.2622
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 8
	fst	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_a.2757
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fless.2610
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9949
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9950
jeq_else.9949:
	fld	%f0, %g1, 4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fabs.2622
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 8
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_b.2759
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fless.2610
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9951
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9952
jeq_else.9951:
	fld	%f0, %g1, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fabs.2622
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 8
	fst	%f0, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_c.2761
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fless.2610
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
jeq_cont.9952:
jeq_cont.9950:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9953
	ld	%g3, %g1, 8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_isinvert.2753
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9954
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.9954:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9953:
	ld	%g3, %g1, 8
	jmp	o_isinvert.2753
is_plane_outside.2949:
	st	%g3, %g1, 0
	fst	%f2, %g1, 4
	fst	%f1, %g1, 8
	fst	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_abc.2763
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f0, %g1, 12
	fld	%f1, %g1, 8
	fld	%f2, %g1, 4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	veciprod2.2725
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 0
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_isinvert.2753
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f0, %g1, 16
	st	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fisneg.2615
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g3
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	xor.2690
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9955
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.9955:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
is_second_outside.2954:
	st	%g3, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	quadratic.2862
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g3, %g1, 0
	fst	%f0, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_form.2749
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 3
	jne	%g3, %g4, jeq_else.9956
	setL %g3, l.6468
	fld	%f0, %g3, 0
	fld	%f1, %g1, 4
	fsub	%f0, %f1, %f0
	jmp	jeq_cont.9957
jeq_else.9956:
	fld	%f0, %g1, 4
jeq_cont.9957:
	ld	%g3, %g1, 0
	fst	%f0, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_isinvert.2753
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f0, %g1, 8
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fisneg.2615
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g3
	ld	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	xor.2690
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9958
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.9958:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
is_outside.2959:
	fst	%f2, %g1, 0
	fst	%f1, %g1, 4
	st	%g3, %g1, 8
	fst	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_x.2765
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 12
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_y.2767
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 4
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_z.2769
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 0
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_form.2749
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.9959
	fld	%f0, %g1, 16
	fld	%f1, %g1, 20
	fld	%f2, %g1, 24
	ld	%g3, %g1, 8
	jmp	is_rect_outside.2944
jeq_else.9959:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.9960
	fld	%f0, %g1, 16
	fld	%f1, %g1, 20
	fld	%f2, %g1, 24
	ld	%g3, %g1, 8
	jmp	is_plane_outside.2949
jeq_else.9960:
	fld	%f0, %g1, 16
	fld	%f1, %g1, 20
	fld	%f2, %g1, 24
	ld	%g3, %g1, 8
	jmp	is_second_outside.2954
check_all_inside.2964:
	ld	%g5, %g29, -4
	slli	%g6, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g6
	ld	%g6, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g7, 65535
	mvlo	%g7, -1
	jne	%g6, %g7, jeq_else.9961
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.9961:
	slli	%g6, %g6, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g6
	ld	%g5, %g5, 0
	fst	%f2, %g1, 0
	fst	%f1, %g1, 4
	fst	%f0, %g1, 8
	st	%g4, %g1, 12
	st	%g29, %g1, 16
	st	%g3, %g1, 20
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	is_outside.2959
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9962
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	fld	%f0, %g1, 8
	fld	%f1, %g1, 4
	fld	%f2, %g1, 0
	ld	%g4, %g1, 12
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9962:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
shadow_check_and_group.2970:
	ld	%g5, %g29, -28
	ld	%g6, %g29, -24
	ld	%g7, %g29, -20
	ld	%g8, %g29, -16
	ld	%g9, %g29, -12
	ld	%g10, %g29, -8
	ld	%g11, %g29, -4
	slli	%g12, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g12
	ld	%g12, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g13, 65535
	mvlo	%g13, -1
	jne	%g12, %g13, jeq_else.9963
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9963:
	slli	%g12, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g12
	ld	%g12, %g4, 0
	ld	%g4, %g1, 4
	st	%g11, %g1, 0
	st	%g10, %g1, 4
	st	%g9, %g1, 8
	st	%g4, %g1, 12
	st	%g29, %g1, 16
	st	%g3, %g1, 20
	st	%g7, %g1, 24
	st	%g12, %g1, 28
	st	%g6, %g1, 32
	mov	%g4, %g8
	mov	%g3, %g12
	mov	%g29, %g5
	mov	%g5, %g10
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 32
	fld	%f0, %g4, 0
	mvhi	%g4, 0
	mvlo	%g4, 0
	fst	%f0, %g1, 36
	jne	%g3, %g4, jeq_else.9964
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9965
jeq_else.9964:
	setL %g3, l.7003
	fld	%f1, %g3, 0
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fless.2610
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
jeq_cont.9965:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9966
	ld	%g3, %g1, 28
	slli	%g3, %g3, 2
	ld	%g4, %g1, 24
	st	%g4, %g1, 44
	add	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 44
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_isinvert.2753
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9967
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9967:
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	ld	%g4, %g1, 12
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9966:
	setL %g3, l.7005
	fld	%f0, %g3, 0
	fld	%f1, %g1, 36
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	ld	%g4, %g1, 4
	fld	%f2, %g4, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g3, -4
	fmul	%f2, %f2, %f0
	fld	%f3, %g4, -4
	fadd	%f2, %f2, %f3
	fld	%f3, %g3, -8
	fmul	%f0, %f3, %f0
	fld	%f3, %g4, -8
	fadd	%f0, %f0, %f3
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 12
	ld	%g29, %g1, 0
	fmov	%f31, %f2
	fmov	%f2, %f0
	fmov	%f0, %f1
	fmov	%f1, %f31
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9968
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	ld	%g4, %g1, 12
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9968:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
shadow_check_one_or_group.2973:
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	slli	%g7, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g7
	ld	%g7, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g8, 65535
	mvlo	%g8, -1
	jne	%g7, %g8, jeq_else.9969
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9969:
	slli	%g7, %g7, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g7
	ld	%g6, %g6, 0
	mvhi	%g7, 0
	mvlo	%g7, 0
	st	%g4, %g1, 0
	st	%g29, %g1, 4
	st	%g3, %g1, 8
	mov	%g4, %g6
	mov	%g3, %g7
	mov	%g29, %g5
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9970
	ld	%g3, %g1, 8
	addi	%g3, %g3, 1
	ld	%g4, %g1, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9970:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
shadow_check_one_or_matrix.2976:
	ld	%g5, %g29, -20
	ld	%g6, %g29, -16
	ld	%g7, %g29, -12
	ld	%g8, %g29, -8
	ld	%g9, %g29, -4
	slli	%g10, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g10
	ld	%g10, %g4, 0
	ld	%g4, %g1, 4
	ld	%g11, %g10, 0
	mvhi	%g12, 65535
	mvlo	%g12, -1
	jne	%g11, %g12, jeq_else.9971
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.9971:
	mvhi	%g12, 0
	mvlo	%g12, 99
	st	%g10, %g1, 0
	st	%g7, %g1, 4
	st	%g4, %g1, 8
	st	%g29, %g1, 12
	st	%g3, %g1, 16
	jne	%g11, %g12, jeq_else.9972
	mvhi	%g3, 0
	mvlo	%g3, 1
	jmp	jeq_cont.9973
jeq_else.9972:
	st	%g6, %g1, 20
	mov	%g4, %g8
	mov	%g3, %g11
	mov	%g29, %g5
	mov	%g5, %g9
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9974
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9975
jeq_else.9974:
	ld	%g3, %g1, 20
	fld	%f0, %g3, 0
	setL %g3, l.7031
	fld	%f1, %g3, 0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fless.2610
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9976
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9977
jeq_else.9976:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 0
	ld	%g29, %g1, 4
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9978
	mvhi	%g3, 0
	mvlo	%g3, 0
	jmp	jeq_cont.9979
jeq_else.9978:
	mvhi	%g3, 0
	mvlo	%g3, 1
jeq_cont.9979:
jeq_cont.9977:
jeq_cont.9975:
jeq_cont.9973:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9980
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	ld	%g4, %g1, 8
	ld	%g29, %g1, 12
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9980:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 0
	ld	%g29, %g1, 4
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9981
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	ld	%g4, %g1, 8
	ld	%g29, %g1, 12
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9981:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
solve_each_element.2979:
	ld	%g6, %g29, -36
	ld	%g7, %g29, -32
	ld	%g8, %g29, -28
	ld	%g9, %g29, -24
	ld	%g10, %g29, -20
	ld	%g11, %g29, -16
	ld	%g12, %g29, -12
	ld	%g13, %g29, -8
	ld	%g14, %g29, -4
	slli	%g15, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g15
	ld	%g15, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g16, 65535
	mvlo	%g16, -1
	jne	%g15, %g16, jeq_else.9982
	return
jeq_else.9982:
	st	%g11, %g1, 0
	st	%g13, %g1, 4
	st	%g12, %g1, 8
	st	%g14, %g1, 12
	st	%g7, %g1, 16
	st	%g6, %g1, 20
	st	%g8, %g1, 24
	st	%g5, %g1, 28
	st	%g4, %g1, 32
	st	%g29, %g1, 36
	st	%g3, %g1, 40
	st	%g10, %g1, 44
	st	%g15, %g1, 48
	mov	%g4, %g5
	mov	%g3, %g15
	mov	%g29, %g9
	mov	%g5, %g7
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9984
	ld	%g3, %g1, 48
	slli	%g3, %g3, 2
	ld	%g4, %g1, 44
	st	%g4, %g1, 52
	add	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 52
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_isinvert.2753
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9985
	return
jeq_else.9985:
	ld	%g3, %g1, 40
	addi	%g3, %g3, 1
	ld	%g4, %g1, 32
	ld	%g5, %g1, 28
	ld	%g29, %g1, 36
	ld	%g28, %g29, 0
	b	%g28
jeq_else.9984:
	ld	%g4, %g1, 24
	fld	%f1, %g4, 0
	setL %g4, l.6407
	fld	%f0, %g4, 0
	st	%g3, %g1, 52
	fst	%f1, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fless.2610
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9987
	jmp	jeq_cont.9988
jeq_else.9987:
	ld	%g3, %g1, 20
	fld	%f1, %g3, 0
	fld	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fless.2610
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9989
	jmp	jeq_cont.9990
jeq_else.9989:
	setL %g3, l.7005
	fld	%f0, %g3, 0
	fld	%f1, %g1, 56
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 28
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	ld	%g4, %g1, 16
	fld	%f2, %g4, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g3, -4
	fmul	%f2, %f2, %f0
	fld	%f3, %g4, -4
	fadd	%f2, %f2, %f3
	fld	%f3, %g3, -8
	fmul	%f3, %f3, %f0
	fld	%f4, %g4, -8
	fadd	%f3, %f3, %f4
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g5, %g1, 32
	ld	%g29, %g1, 12
	fst	%f3, %g1, 60
	fst	%f2, %g1, 64
	fst	%f1, %g1, 68
	fst	%f0, %g1, 72
	mov	%g3, %g4
	mov	%g4, %g5
	fmov	%f0, %f1
	fmov	%f1, %f2
	fmov	%f2, %f3
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9991
	jmp	jeq_cont.9992
jeq_else.9991:
	ld	%g3, %g1, 20
	fld	%f0, %g1, 72
	fst	%f0, %g3, 0
	fld	%f0, %g1, 68
	fld	%f1, %g1, 64
	fld	%f2, %g1, 60
	ld	%g3, %g1, 8
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	vecset.2701
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g3, %g1, 4
	ld	%g4, %g1, 48
	st	%g4, %g3, 0
	ld	%g3, %g1, 0
	ld	%g4, %g1, 52
	st	%g4, %g3, 0
jeq_cont.9992:
jeq_cont.9990:
jeq_cont.9988:
	ld	%g3, %g1, 40
	addi	%g3, %g3, 1
	ld	%g4, %g1, 32
	ld	%g5, %g1, 28
	ld	%g29, %g1, 36
	ld	%g28, %g29, 0
	b	%g28
solve_one_or_network.2983:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	slli	%g8, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g8
	ld	%g8, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g9, 65535
	mvlo	%g9, -1
	jne	%g8, %g9, jeq_else.9993
	return
jeq_else.9993:
	slli	%g8, %g8, 2
	st	%g7, %g1, 4
	add	%g7, %g7, %g8
	ld	%g7, %g7, 0
	mvhi	%g8, 0
	mvlo	%g8, 0
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g29, %g1, 8
	st	%g3, %g1, 12
	mov	%g4, %g7
	mov	%g3, %g8
	mov	%g29, %g6
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
trace_or_matrix.2987:
	ld	%g6, %g29, -20
	ld	%g7, %g29, -16
	ld	%g8, %g29, -12
	ld	%g9, %g29, -8
	ld	%g10, %g29, -4
	slli	%g11, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g11
	ld	%g11, %g4, 0
	ld	%g4, %g1, 4
	ld	%g12, %g11, 0
	mvhi	%g13, 65535
	mvlo	%g13, -1
	jne	%g12, %g13, jeq_else.9995
	return
jeq_else.9995:
	mvhi	%g13, 0
	mvlo	%g13, 99
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g29, %g1, 8
	st	%g3, %g1, 12
	jne	%g12, %g13, jeq_else.9997
	mvhi	%g6, 0
	mvlo	%g6, 1
	mov	%g4, %g11
	mov	%g3, %g6
	mov	%g29, %g10
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	jmp	jeq_cont.9998
jeq_else.9997:
	st	%g11, %g1, 16
	st	%g10, %g1, 20
	st	%g6, %g1, 24
	st	%g8, %g1, 28
	mov	%g4, %g5
	mov	%g3, %g12
	mov	%g29, %g9
	mov	%g5, %g7
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.9999
	jmp	jeq_cont.10000
jeq_else.9999:
	ld	%g3, %g1, 28
	fld	%f0, %g3, 0
	ld	%g3, %g1, 24
	fld	%f1, %g3, 0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fless.2610
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10001
	jmp	jeq_cont.10002
jeq_else.10001:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 16
	ld	%g5, %g1, 0
	ld	%g29, %g1, 20
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
jeq_cont.10002:
jeq_cont.10000:
jeq_cont.9998:
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
judge_intersection.2991:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	setL %g7, l.7070
	fld	%f0, %g7, 0
	fst	%f0, %g5, 0
	mvhi	%g7, 0
	mvlo	%g7, 0
	ld	%g6, %g6, 0
	st	%g5, %g1, 0
	mov	%g5, %g3
	mov	%g29, %g4
	mov	%g4, %g6
	mov	%g3, %g7
	st	%g31, %g1, 4
	ld	%g28, %g29, 0
	subi	%g1, %g1, 8
	callR	%g28
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g3, %g1, 0
	fld	%f1, %g3, 0
	setL %g3, l.7031
	fld	%f0, %g3, 0
	fst	%f1, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fless.2610
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10003
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10003:
	setL %g3, l.7078
	fld	%f1, %g3, 0
	fld	%f0, %g1, 4
	jmp	fless.2610
solve_each_element_fast.2993:
	ld	%g6, %g29, -36
	ld	%g7, %g29, -32
	ld	%g8, %g29, -28
	ld	%g9, %g29, -24
	ld	%g10, %g29, -20
	ld	%g11, %g29, -16
	ld	%g12, %g29, -12
	ld	%g13, %g29, -8
	ld	%g14, %g29, -4
	st	%g11, %g1, 0
	st	%g13, %g1, 4
	st	%g12, %g1, 8
	st	%g14, %g1, 12
	st	%g7, %g1, 16
	st	%g6, %g1, 20
	st	%g9, %g1, 24
	st	%g29, %g1, 28
	st	%g10, %g1, 32
	st	%g5, %g1, 36
	st	%g8, %g1, 40
	st	%g4, %g1, 44
	st	%g3, %g1, 48
	mov	%g3, %g5
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	d_vec.2808
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g4, %g1, 48
	slli	%g5, %g4, 2
	ld	%g6, %g1, 44
	st	%g6, %g1, 52
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 52
	mvhi	%g7, 65535
	mvlo	%g7, -1
	jne	%g5, %g7, jeq_else.10004
	return
jeq_else.10004:
	ld	%g7, %g1, 36
	ld	%g29, %g1, 40
	st	%g3, %g1, 52
	st	%g5, %g1, 56
	mov	%g4, %g7
	mov	%g3, %g5
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10006
	ld	%g3, %g1, 56
	slli	%g3, %g3, 2
	ld	%g4, %g1, 32
	st	%g4, %g1, 60
	add	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 60
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_isinvert.2753
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10007
	return
jeq_else.10007:
	ld	%g3, %g1, 48
	addi	%g3, %g3, 1
	ld	%g4, %g1, 44
	ld	%g5, %g1, 36
	ld	%g29, %g1, 28
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10006:
	ld	%g4, %g1, 24
	fld	%f1, %g4, 0
	setL %g4, l.6407
	fld	%f0, %g4, 0
	st	%g3, %g1, 60
	fst	%f1, %g1, 64
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fless.2610
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10009
	jmp	jeq_cont.10010
jeq_else.10009:
	ld	%g3, %g1, 20
	fld	%f1, %g3, 0
	fld	%f0, %g1, 64
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fless.2610
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10011
	jmp	jeq_cont.10012
jeq_else.10011:
	setL %g3, l.7005
	fld	%f0, %g3, 0
	fld	%f1, %g1, 64
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 52
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	ld	%g4, %g1, 16
	fld	%f2, %g4, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g3, -4
	fmul	%f2, %f2, %f0
	fld	%f3, %g4, -4
	fadd	%f2, %f2, %f3
	fld	%f3, %g3, -8
	fmul	%f3, %f3, %f0
	fld	%f4, %g4, -8
	fadd	%f3, %f3, %f4
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 44
	ld	%g29, %g1, 12
	fst	%f3, %g1, 68
	fst	%f2, %g1, 72
	fst	%f1, %g1, 76
	fst	%f0, %g1, 80
	fmov	%f0, %f1
	fmov	%f1, %f2
	fmov	%f2, %f3
	st	%g31, %g1, 84
	ld	%g28, %g29, 0
	subi	%g1, %g1, 88
	callR	%g28
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10013
	jmp	jeq_cont.10014
jeq_else.10013:
	ld	%g3, %g1, 20
	fld	%f0, %g1, 80
	fst	%f0, %g3, 0
	fld	%f0, %g1, 76
	fld	%f1, %g1, 72
	fld	%f2, %g1, 68
	ld	%g3, %g1, 8
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	vecset.2701
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	ld	%g3, %g1, 4
	ld	%g4, %g1, 56
	st	%g4, %g3, 0
	ld	%g3, %g1, 0
	ld	%g4, %g1, 60
	st	%g4, %g3, 0
jeq_cont.10014:
jeq_cont.10012:
jeq_cont.10010:
	ld	%g3, %g1, 48
	addi	%g3, %g3, 1
	ld	%g4, %g1, 44
	ld	%g5, %g1, 36
	ld	%g29, %g1, 28
	ld	%g28, %g29, 0
	b	%g28
solve_one_or_network_fast.2997:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	slli	%g8, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g8
	ld	%g8, %g4, 0
	ld	%g4, %g1, 4
	mvhi	%g9, 65535
	mvlo	%g9, -1
	jne	%g8, %g9, jeq_else.10015
	return
jeq_else.10015:
	slli	%g8, %g8, 2
	st	%g7, %g1, 4
	add	%g7, %g7, %g8
	ld	%g7, %g7, 0
	mvhi	%g8, 0
	mvlo	%g8, 0
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g29, %g1, 8
	st	%g3, %g1, 12
	mov	%g4, %g7
	mov	%g3, %g8
	mov	%g29, %g6
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
trace_or_matrix_fast.3001:
	ld	%g6, %g29, -16
	ld	%g7, %g29, -12
	ld	%g8, %g29, -8
	ld	%g9, %g29, -4
	slli	%g10, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g10
	ld	%g10, %g4, 0
	ld	%g4, %g1, 4
	ld	%g11, %g10, 0
	mvhi	%g12, 65535
	mvlo	%g12, -1
	jne	%g11, %g12, jeq_else.10017
	return
jeq_else.10017:
	mvhi	%g12, 0
	mvlo	%g12, 99
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g29, %g1, 8
	st	%g3, %g1, 12
	jne	%g11, %g12, jeq_else.10019
	mvhi	%g6, 0
	mvlo	%g6, 1
	mov	%g4, %g10
	mov	%g3, %g6
	mov	%g29, %g9
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	jmp	jeq_cont.10020
jeq_else.10019:
	st	%g10, %g1, 16
	st	%g9, %g1, 20
	st	%g6, %g1, 24
	st	%g8, %g1, 28
	mov	%g4, %g5
	mov	%g3, %g11
	mov	%g29, %g7
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10021
	jmp	jeq_cont.10022
jeq_else.10021:
	ld	%g3, %g1, 28
	fld	%f0, %g3, 0
	ld	%g3, %g1, 24
	fld	%f1, %g3, 0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fless.2610
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10023
	jmp	jeq_cont.10024
jeq_else.10023:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 16
	ld	%g5, %g1, 0
	ld	%g29, %g1, 20
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
jeq_cont.10024:
jeq_cont.10022:
jeq_cont.10020:
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
judge_intersection_fast.3005:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	setL %g7, l.7070
	fld	%f0, %g7, 0
	fst	%f0, %g5, 0
	mvhi	%g7, 0
	mvlo	%g7, 0
	ld	%g6, %g6, 0
	st	%g5, %g1, 0
	mov	%g5, %g3
	mov	%g29, %g4
	mov	%g4, %g6
	mov	%g3, %g7
	st	%g31, %g1, 4
	ld	%g28, %g29, 0
	subi	%g1, %g1, 8
	callR	%g28
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g3, %g1, 0
	fld	%f1, %g3, 0
	setL %g3, l.7031
	fld	%f0, %g3, 0
	fst	%f1, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fless.2610
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10025
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10025:
	setL %g3, l.7078
	fld	%f1, %g3, 0
	fld	%f0, %g1, 4
	jmp	fless.2610
get_nvector_rect.3007:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	ld	%g5, %g5, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	st	%g5, %g1, 8
	mov	%g3, %g4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	vecbzero.2709
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 8
	subi	%g4, %g3, 1
	subi	%g3, %g3, 1
	slli	%g3, %g3, 2
	ld	%g5, %g1, 4
	st	%g5, %g1, 12
	add	%g5, %g5, %g3
	fld	%f0, %g5, 0
	ld	%g5, %g1, 12
	st	%g4, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	sgn.2693
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fneg.2626
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	slli	%g3, %g3, 2
	ld	%g4, %g1, 0
	st	%g4, %g1, 20
	add	%g4, %g4, %g3
	fst	%f0, %g4, 0
	ld	%g4, %g1, 20
	return
get_nvector_plane.3009:
	ld	%g4, %g29, -4
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_param_a.2757
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fneg.2626
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	fst	%f0, %g3, 0
	ld	%g4, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_param_b.2759
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fneg.2626
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	fst	%f0, %g3, -4
	ld	%g4, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_param_c.2761
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fneg.2626
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	fst	%f0, %g3, -8
	return
get_nvector_second.3011:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	fld	%f0, %g5, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	st	%g5, %g1, 8
	fst	%f0, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_x.2765
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 12
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fld	%f1, %g3, -4
	ld	%g4, %g1, 4
	fst	%f0, %g1, 16
	fst	%f1, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_param_y.2767
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 20
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fld	%f1, %g3, -8
	ld	%g3, %g1, 4
	fst	%f0, %g1, 24
	fst	%f1, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_z.2769
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 28
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_a.2757
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 16
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_b.2759
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_c.2761
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 32
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_isrot.2755
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10028
	ld	%g3, %g1, 0
	fld	%f0, %g1, 36
	fst	%f0, %g3, 0
	fld	%f0, %g1, 40
	fst	%f0, %g3, -4
	fld	%f0, %g1, 44
	fst	%f0, %g3, -8
	jmp	jeq_cont.10029
jeq_else.10028:
	ld	%g3, %g1, 4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_r3.2785
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 48
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_r2.2783
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 32
	fmul	%f0, %f1, %f0
	fld	%f2, %g1, 48
	fadd	%f0, %f2, %f0
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fhalf.2628
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 36
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	ld	%g4, %g1, 4
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_r3.2785
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 16
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 52
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_r1.2781
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 32
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 52
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fhalf.2628
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 40
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 0
	fst	%f0, %g3, -4
	ld	%g4, %g1, 4
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_r2.2783
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 16
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_r1.2781
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 56
	fadd	%f0, %f1, %f0
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fhalf.2628
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 44
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 0
	fst	%f0, %g3, -8
jeq_cont.10029:
	ld	%g4, %g1, 4
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_isinvert.2753
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g3
	ld	%g3, %g1, 0
	jmp	vecunit_sgn.2719
get_nvector.3013:
	ld	%g5, %g29, -12
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	st	%g5, %g1, 0
	st	%g3, %g1, 4
	st	%g7, %g1, 8
	st	%g4, %g1, 12
	st	%g6, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_form.2749
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.10030
	ld	%g3, %g1, 12
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10030:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.10031
	ld	%g3, %g1, 4
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10031:
	ld	%g3, %g1, 4
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
utexture.3016:
	ld	%g5, %g29, -4
	st	%g4, %g1, 0
	st	%g5, %g1, 4
	st	%g3, %g1, 8
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	o_texturetype.2747
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 8
	st	%g3, %g1, 12
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_color_red.2775
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 4
	fst	%f0, %g3, 0
	ld	%g4, %g1, 8
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_color_green.2777
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 4
	fst	%f0, %g3, -4
	ld	%g4, %g1, 8
	mov	%g3, %g4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_color_blue.2779
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 4
	fst	%f0, %g3, -8
	mvhi	%g4, 0
	mvlo	%g4, 1
	ld	%g5, %g1, 12
	jne	%g5, %g4, jeq_else.10032
	ld	%g4, %g1, 0
	fld	%f0, %g4, 0
	ld	%g5, %g1, 8
	fst	%f0, %g1, 16
	mov	%g3, %g5
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_param_x.2765
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 16
	fsub	%f0, %f1, %f0
	setL %g3, l.7200
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	fst	%f0, %g1, 20
	fmov	%f0, %f1
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_floor
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	setL %g3, l.7202
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 20
	fsub	%f0, %f1, %f0
	setL %g3, l.7181
	fld	%f1, %g3, 0
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fless.2610
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 0
	fld	%f0, %g4, -8
	ld	%g4, %g1, 8
	st	%g3, %g1, 24
	fst	%f0, %g1, 28
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_z.2769
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 28
	fsub	%f0, %f1, %f0
	setL %g3, l.7200
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	fst	%f0, %g1, 32
	fmov	%f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_floor
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	setL %g3, l.7202
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 32
	fsub	%f0, %f1, %f0
	setL %g3, l.7181
	fld	%f1, %g3, 0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fless.2610
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g5, %g1, 24
	jne	%g5, %g4, jeq_else.10033
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10035
	setL %g3, l.7172
	fld	%f0, %g3, 0
	jmp	jeq_cont.10036
jeq_else.10035:
	setL %g3, l.6407
	fld	%f0, %g3, 0
jeq_cont.10036:
	jmp	jeq_cont.10034
jeq_else.10033:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10037
	setL %g3, l.6407
	fld	%f0, %g3, 0
	jmp	jeq_cont.10038
jeq_else.10037:
	setL %g3, l.7172
	fld	%f0, %g3, 0
jeq_cont.10038:
jeq_cont.10034:
	ld	%g3, %g1, 4
	fst	%f0, %g3, -4
	return
jeq_else.10032:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g5, %g4, jeq_else.10040
	ld	%g4, %g1, 0
	fld	%f0, %g4, -4
	setL %g4, l.7191
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	sin	%f0, %f0
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fsqr.2630
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	setL %g3, l.7172
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	ld	%g3, %g1, 4
	fst	%f1, %g3, 0
	setL %g4, l.7172
	fld	%f1, %g4, 0
	setL %g4, l.6468
	fld	%f2, %g4, 0
	fsub	%f0, %f2, %f0
	fmul	%f0, %f1, %f0
	fst	%f0, %g3, -4
	return
jeq_else.10040:
	mvhi	%g4, 0
	mvlo	%g4, 3
	jne	%g5, %g4, jeq_else.10042
	ld	%g4, %g1, 0
	fld	%f0, %g4, 0
	ld	%g5, %g1, 8
	fst	%f0, %g1, 36
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_x.2765
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 0
	fld	%f1, %g3, -8
	ld	%g3, %g1, 8
	fst	%f0, %g1, 40
	fst	%f1, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_z.2769
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 44
	fsub	%f0, %f1, %f0
	fld	%f1, %g1, 40
	fst	%f0, %g1, 48
	fmov	%f0, %f1
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fsqr.2630
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 48
	fst	%f0, %g1, 52
	fmov	%f0, %f1
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fsqr.2630
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 52
	fadd	%f0, %f1, %f0
	fsqrt	%f0, %f0
	setL %g3, l.7181
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	fst	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	min_caml_floor
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 56
	fsub	%f0, %f1, %f0
	setL %g3, l.7158
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	cos	%f0, %f0
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fsqr.2630
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	setL %g3, l.7172
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	ld	%g3, %g1, 4
	fst	%f1, %g3, -4
	setL %g4, l.6468
	fld	%f1, %g4, 0
	fsub	%f0, %f1, %f0
	setL %g4, l.7172
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fst	%f0, %g3, -8
	return
jeq_else.10042:
	mvhi	%g4, 0
	mvlo	%g4, 4
	jne	%g5, %g4, jeq_else.10044
	ld	%g4, %g1, 0
	fld	%f0, %g4, 0
	ld	%g5, %g1, 8
	fst	%f0, %g1, 60
	mov	%g3, %g5
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	o_param_x.2765
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 60
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g1, 64
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	o_param_a.2757
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fsqrt	%f0, %f0
	fld	%f1, %g1, 64
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 0
	fld	%f1, %g3, -8
	ld	%g4, %g1, 8
	fst	%f0, %g1, 68
	fst	%f1, %g1, 72
	mov	%g3, %g4
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	o_param_z.2769
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 72
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g1, 76
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	o_param_c.2761
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fsqrt	%f0, %f0
	fld	%f1, %g1, 76
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 68
	fst	%f0, %g1, 80
	fmov	%f0, %f1
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	fsqr.2630
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fld	%f1, %g1, 80
	fst	%f0, %g1, 84
	fmov	%f0, %f1
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	fsqr.2630
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	fld	%f1, %g1, 84
	fadd	%f0, %f1, %f0
	fld	%f1, %g1, 68
	fst	%f0, %g1, 88
	fmov	%f0, %f1
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	fabs.2622
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	setL %g3, l.7152
	fld	%f1, %g3, 0
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	fless.2610
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10045
	fld	%f0, %g1, 68
	fld	%f1, %g1, 80
	fdiv	%f0, %f1, %f0
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	fabs.2622
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	atan	%f0, %f0
	setL %g3, l.7156
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.7158
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	jmp	jeq_cont.10046
jeq_else.10045:
	setL %g3, l.7154
	fld	%f0, %g3, 0
jeq_cont.10046:
	fst	%f0, %g1, 92
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	min_caml_floor
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	fld	%f1, %g1, 92
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 0
	fld	%f1, %g3, -4
	ld	%g3, %g1, 8
	fst	%f0, %g1, 96
	fst	%f1, %g1, 100
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	o_param_y.2767
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	fld	%f1, %g1, 100
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fst	%f0, %g1, 104
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	o_param_b.2759
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	fsqrt	%f0, %f0
	fld	%f1, %g1, 104
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 88
	fst	%f0, %g1, 108
	fmov	%f0, %f1
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	fabs.2622
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	setL %g3, l.7152
	fld	%f1, %g3, 0
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	fless.2610
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10047
	fld	%f0, %g1, 88
	fld	%f1, %g1, 108
	fdiv	%f0, %f1, %f0
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	fabs.2622
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	atan	%f0, %f0
	setL %g3, l.7156
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.7158
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	jmp	jeq_cont.10048
jeq_else.10047:
	setL %g3, l.7154
	fld	%f0, %g3, 0
jeq_cont.10048:
	fst	%f0, %g1, 112
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	min_caml_floor
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	fld	%f1, %g1, 112
	fsub	%f0, %f1, %f0
	setL %g3, l.7166
	fld	%f1, %g3, 0
	setL %g3, l.7168
	fld	%f2, %g3, 0
	fld	%f3, %g1, 96
	fsub	%f2, %f2, %f3
	fst	%f0, %g1, 116
	fst	%f1, %g1, 120
	fmov	%f0, %f2
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	fsqr.2630
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	fld	%f1, %g1, 120
	fsub	%f0, %f1, %f0
	setL %g3, l.7168
	fld	%f1, %g3, 0
	fld	%f2, %g1, 116
	fsub	%f1, %f1, %f2
	fst	%f0, %g1, 124
	fmov	%f0, %f1
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	fsqr.2630
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	fld	%f1, %g1, 124
	fsub	%f0, %f1, %f0
	fst	%f0, %g1, 128
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	fisneg.2615
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10049
	fld	%f0, %g1, 128
	jmp	jeq_cont.10050
jeq_else.10049:
	setL %g3, l.6407
	fld	%f0, %g3, 0
jeq_cont.10050:
	setL %g3, l.7172
	fld	%f1, %g3, 0
	fmul	%f0, %f1, %f0
	setL %g3, l.7174
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 4
	fst	%f0, %g3, -8
	return
jeq_else.10044:
	return
add_light.3019:
	ld	%g3, %g29, -8
	ld	%g4, %g29, -4
	fst	%f2, %g1, 0
	fst	%f1, %g1, 4
	fst	%f0, %g1, 8
	st	%g3, %g1, 12
	st	%g4, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fispos.2613
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10053
	jmp	jeq_cont.10054
jeq_else.10053:
	fld	%f0, %g1, 8
	ld	%g3, %g1, 16
	ld	%g4, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	vecaccum.2730
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.10054:
	fld	%f0, %g1, 4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fispos.2613
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10055
	return
jeq_else.10055:
	fld	%f0, %g1, 4
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fsqr.2630
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fsqr.2630
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 0
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 16
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
trace_reflections.3023:
	ld	%g5, %g29, -32
	ld	%g6, %g29, -28
	ld	%g7, %g29, -24
	ld	%g8, %g29, -20
	ld	%g9, %g29, -16
	ld	%g10, %g29, -12
	ld	%g11, %g29, -8
	ld	%g12, %g29, -4
	mvhi	%g13, 0
	mvlo	%g13, 0
	jlt	%g3, %g13, jle_else.10058
	slli	%g13, %g3, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g13
	ld	%g6, %g6, 0
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	fst	%f1, %g1, 8
	st	%g12, %g1, 12
	st	%g4, %g1, 16
	fst	%f0, %g1, 20
	st	%g8, %g1, 24
	st	%g5, %g1, 28
	st	%g7, %g1, 32
	st	%g6, %g1, 36
	st	%g10, %g1, 40
	st	%g11, %g1, 44
	st	%g9, %g1, 48
	mov	%g3, %g6
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	r_dvec.2814
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g29, %g1, 48
	st	%g3, %g1, 52
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10059
	jmp	jeq_cont.10060
jeq_else.10059:
	ld	%g3, %g1, 44
	ld	%g3, %g3, 0
	muli	%g3, %g3, 4
	ld	%g4, %g1, 40
	ld	%g4, %g4, 0
	add	%g3, %g3, %g4
	ld	%g4, %g1, 36
	st	%g3, %g1, 56
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	r_surface_id.2812
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g4, %g1, 56
	jne	%g4, %g3, jeq_else.10061
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 32
	ld	%g4, %g4, 0
	ld	%g29, %g1, 28
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10063
	ld	%g3, %g1, 52
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	d_vec.2808
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g3
	ld	%g3, %g1, 24
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	veciprod.2722
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 36
	fst	%f0, %g1, 60
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	r_bright.2816
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 20
	fmul	%f2, %f0, %f1
	fld	%f3, %g1, 60
	fmul	%f2, %f2, %f3
	ld	%g3, %g1, 52
	fst	%f2, %g1, 64
	fst	%f0, %g1, 68
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	d_vec.2808
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mov	%g4, %g3
	ld	%g3, %g1, 16
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	veciprod.2722
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 68
	fmul	%f1, %f1, %f0
	fld	%f0, %g1, 64
	fld	%f2, %g1, 8
	ld	%g29, %g1, 12
	st	%g31, %g1, 76
	ld	%g28, %g29, 0
	subi	%g1, %g1, 80
	callR	%g28
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	jmp	jeq_cont.10064
jeq_else.10063:
jeq_cont.10064:
	jmp	jeq_cont.10062
jeq_else.10061:
jeq_cont.10062:
jeq_cont.10060:
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	fld	%f0, %g1, 20
	fld	%f1, %g1, 8
	ld	%g4, %g1, 16
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10058:
	return
trace_ray.3028:
	ld	%g6, %g29, -80
	ld	%g7, %g29, -76
	ld	%g8, %g29, -72
	ld	%g9, %g29, -68
	ld	%g10, %g29, -64
	ld	%g11, %g29, -60
	ld	%g12, %g29, -56
	ld	%g13, %g29, -52
	ld	%g14, %g29, -48
	ld	%g15, %g29, -44
	ld	%g16, %g29, -40
	ld	%g17, %g29, -36
	ld	%g18, %g29, -32
	ld	%g19, %g29, -28
	ld	%g20, %g29, -24
	ld	%g21, %g29, -20
	ld	%g22, %g29, -16
	ld	%g23, %g29, -12
	ld	%g24, %g29, -8
	ld	%g25, %g29, -4
	mvhi	%g26, 0
	mvlo	%g26, 4
	jlt	%g26, %g3, jle_else.10066
	st	%g29, %g1, 0
	fst	%f1, %g1, 4
	st	%g8, %g1, 8
	st	%g7, %g1, 12
	st	%g17, %g1, 16
	st	%g12, %g1, 20
	st	%g25, %g1, 24
	st	%g11, %g1, 28
	st	%g14, %g1, 32
	st	%g16, %g1, 36
	st	%g9, %g1, 40
	st	%g5, %g1, 44
	st	%g20, %g1, 48
	st	%g6, %g1, 52
	st	%g21, %g1, 56
	st	%g10, %g1, 60
	st	%g23, %g1, 64
	st	%g15, %g1, 68
	st	%g22, %g1, 72
	st	%g13, %g1, 76
	st	%g24, %g1, 80
	fst	%f0, %g1, 84
	st	%g18, %g1, 88
	st	%g3, %g1, 92
	st	%g4, %g1, 96
	st	%g19, %g1, 100
	mov	%g3, %g5
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	p_surface_ids.2793
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	ld	%g4, %g1, 96
	ld	%g29, %g1, 100
	st	%g3, %g1, 104
	mov	%g3, %g4
	st	%g31, %g1, 108
	ld	%g28, %g29, 0
	subi	%g1, %g1, 112
	callR	%g28
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10067
	mvhi	%g3, 65535
	mvlo	%g3, -1
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	ld	%g6, %g1, 104
	st	%g6, %g1, 108
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 108
	mvhi	%g3, 0
	mvlo	%g3, 0
	jne	%g4, %g3, jeq_else.10068
	return
jeq_else.10068:
	ld	%g3, %g1, 96
	ld	%g4, %g1, 88
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	veciprod.2722
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	fneg.2626
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	fst	%f0, %g1, 108
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	fispos.2613
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10070
	return
jeq_else.10070:
	fld	%f0, %g1, 108
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	fsqr.2630
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	fld	%f1, %g1, 108
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 84
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 80
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 76
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
jeq_else.10067:
	ld	%g3, %g1, 72
	ld	%g3, %g3, 0
	slli	%g4, %g3, 2
	ld	%g5, %g1, 68
	st	%g5, %g1, 116
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 116
	st	%g3, %g1, 112
	st	%g4, %g1, 116
	mov	%g3, %g4
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	o_reflectiontype.2751
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	ld	%g4, %g1, 116
	st	%g3, %g1, 120
	mov	%g3, %g4
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	o_diffuse.2771
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	fld	%f1, %g1, 84
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 116
	ld	%g4, %g1, 96
	ld	%g29, %g1, 64
	fst	%f0, %g1, 124
	st	%g31, %g1, 132
	ld	%g28, %g29, 0
	subi	%g1, %g1, 136
	callR	%g28
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g3, %g1, 60
	ld	%g4, %g1, 56
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	veccpy.2711
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g3, %g1, 116
	ld	%g4, %g1, 56
	ld	%g29, %g1, 52
	st	%g31, %g1, 132
	ld	%g28, %g29, 0
	subi	%g1, %g1, 136
	callR	%g28
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g3, %g1, 112
	muli	%g3, %g3, 4
	ld	%g4, %g1, 48
	ld	%g4, %g4, 0
	add	%g3, %g3, %g4
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	ld	%g6, %g1, 104
	st	%g6, %g1, 132
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 132
	ld	%g3, %g1, 44
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	p_intersection_points.2791
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	st	%g3, %g1, 132
	add	%g3, %g3, %g5
	ld	%g3, %g3, 0
	ld	%g5, %g1, 56
	mov	%g4, %g5
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	veccpy.2711
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g3, %g1, 44
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	p_calc_diffuse.2795
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g4, %g1, 116
	st	%g3, %g1, 128
	mov	%g3, %g4
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	o_diffuse.2771
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	setL %g3, l.7168
	fld	%f1, %g3, 0
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	fless.2610
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10073
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	ld	%g6, %g1, 128
	st	%g6, %g1, 132
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 132
	ld	%g3, %g1, 44
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	p_energy.2797
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	st	%g3, %g1, 132
	add	%g3, %g3, %g5
	ld	%g5, %g3, 0
	ld	%g3, %g1, 132
	ld	%g6, %g1, 40
	st	%g3, %g1, 132
	mov	%g4, %g6
	mov	%g3, %g5
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	veccpy.2711
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g3, %g1, 92
	slli	%g4, %g3, 2
	ld	%g5, %g1, 132
	st	%g5, %g1, 140
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 140
	setL %g5, l.7248
	fld	%f0, %g5, 0
	fld	%f1, %g1, 124
	fmul	%f0, %f0, %f1
	mov	%g3, %g4
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	vecscale.2740
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g3, %g1, 44
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	p_nvectors.2806
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	st	%g3, %g1, 140
	add	%g3, %g3, %g5
	ld	%g3, %g3, 0
	ld	%g5, %g1, 36
	mov	%g4, %g5
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	veccpy.2711
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	jmp	jeq_cont.10074
jeq_else.10073:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	ld	%g6, %g1, 128
	st	%g6, %g1, 140
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 140
jeq_cont.10074:
	setL %g3, l.7252
	fld	%f0, %g3, 0
	ld	%g3, %g1, 96
	ld	%g4, %g1, 36
	fst	%f0, %g1, 136
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	veciprod.2722
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	fld	%f1, %g1, 136
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 96
	ld	%g4, %g1, 36
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	vecaccum.2730
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g3, %g1, 116
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	o_hilight.2773
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	fld	%f1, %g1, 84
	fmul	%f0, %f1, %f0
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 32
	ld	%g4, %g4, 0
	ld	%g29, %g1, 28
	fst	%f0, %g1, 140
	st	%g31, %g1, 148
	ld	%g28, %g29, 0
	subi	%g1, %g1, 152
	callR	%g28
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10075
	ld	%g3, %g1, 36
	ld	%g4, %g1, 88
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	veciprod.2722
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	fneg.2626
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	fld	%f1, %g1, 124
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 96
	ld	%g4, %g1, 88
	fst	%f0, %g1, 144
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	veciprod.2722
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	fneg.2626
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 144
	fld	%f2, %g1, 140
	ld	%g29, %g1, 24
	st	%g31, %g1, 148
	ld	%g28, %g29, 0
	subi	%g1, %g1, 152
	callR	%g28
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	jmp	jeq_cont.10076
jeq_else.10075:
jeq_cont.10076:
	ld	%g3, %g1, 56
	ld	%g29, %g1, 20
	st	%g31, %g1, 148
	ld	%g28, %g29, 0
	subi	%g1, %g1, 152
	callR	%g28
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	ld	%g3, %g1, 16
	ld	%g3, %g3, 0
	subi	%g3, %g3, 1
	fld	%f0, %g1, 124
	fld	%f1, %g1, 140
	ld	%g4, %g1, 96
	ld	%g29, %g1, 12
	st	%g31, %g1, 148
	ld	%g28, %g29, 0
	subi	%g1, %g1, 152
	callR	%g28
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	setL %g3, l.7258
	fld	%f0, %g3, 0
	fld	%f1, %g1, 84
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	fless.2610
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10077
	return
jeq_else.10077:
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 92
	jlt	%g4, %g3, jle_else.10079
	jmp	jle_cont.10080
jle_else.10079:
	addi	%g3, %g4, 1
	mvhi	%g5, 65535
	mvlo	%g5, -1
	slli	%g3, %g3, 2
	ld	%g6, %g1, 104
	st	%g6, %g1, 148
	add	%g6, %g6, %g3
	st	%g5, %g6, 0
	ld	%g6, %g1, 148
jle_cont.10080:
	mvhi	%g3, 0
	mvlo	%g3, 2
	ld	%g5, %g1, 120
	jne	%g5, %g3, jeq_else.10081
	setL %g3, l.6468
	fld	%f0, %g3, 0
	ld	%g3, %g1, 116
	fst	%f0, %g1, 148
	st	%g31, %g1, 156
	subi	%g1, %g1, 160
	call	o_diffuse.2771
	addi	%g1, %g1, 160
	ld	%g31, %g1, 156
	fld	%f1, %g1, 148
	fsub	%f0, %f1, %f0
	fld	%f1, %g1, 84
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 92
	addi	%g3, %g3, 1
	ld	%g4, %g1, 8
	fld	%f1, %g4, 0
	fld	%f2, %g1, 4
	fadd	%f1, %f2, %f1
	ld	%g4, %g1, 96
	ld	%g5, %g1, 44
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10081:
	return
jle_else.10066:
	return
trace_diffuse_ray.3034:
	ld	%g4, %g29, -48
	ld	%g5, %g29, -44
	ld	%g6, %g29, -40
	ld	%g7, %g29, -36
	ld	%g8, %g29, -32
	ld	%g9, %g29, -28
	ld	%g10, %g29, -24
	ld	%g11, %g29, -20
	ld	%g12, %g29, -16
	ld	%g13, %g29, -12
	ld	%g14, %g29, -8
	ld	%g15, %g29, -4
	st	%g5, %g1, 0
	st	%g15, %g1, 4
	fst	%f0, %g1, 8
	st	%g10, %g1, 12
	st	%g9, %g1, 16
	st	%g6, %g1, 20
	st	%g7, %g1, 24
	st	%g12, %g1, 28
	st	%g4, %g1, 32
	st	%g14, %g1, 36
	st	%g3, %g1, 40
	st	%g8, %g1, 44
	st	%g13, %g1, 48
	mov	%g29, %g11
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10084
	return
jeq_else.10084:
	ld	%g3, %g1, 48
	ld	%g3, %g3, 0
	slli	%g3, %g3, 2
	ld	%g4, %g1, 44
	st	%g4, %g1, 52
	add	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 52
	ld	%g4, %g1, 40
	st	%g3, %g1, 52
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	d_vec.2808
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g3
	ld	%g3, %g1, 52
	ld	%g29, %g1, 36
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 52
	ld	%g4, %g1, 28
	ld	%g29, %g1, 32
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 24
	ld	%g4, %g4, 0
	ld	%g29, %g1, 20
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10086
	ld	%g3, %g1, 16
	ld	%g4, %g1, 12
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	veciprod.2722
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fneg.2626
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fst	%f0, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fispos.2613
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10087
	setL %g3, l.6407
	fld	%f0, %g3, 0
	jmp	jeq_cont.10088
jeq_else.10087:
	fld	%f0, %g1, 56
jeq_cont.10088:
	fld	%f1, %g1, 8
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 52
	fst	%f0, %g1, 60
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	o_diffuse.2771
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 60
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 4
	ld	%g4, %g1, 0
	jmp	vecaccum.2730
jeq_else.10086:
	return
iter_trace_diffuse_rays.3037:
	ld	%g7, %g29, -4
	mvhi	%g8, 0
	mvlo	%g8, 0
	jlt	%g6, %g8, jle_else.10090
	slli	%g8, %g6, 2
	st	%g3, %g1, 4
	add	%g3, %g3, %g8
	ld	%g8, %g3, 0
	ld	%g3, %g1, 4
	st	%g5, %g1, 0
	st	%g29, %g1, 4
	st	%g7, %g1, 8
	st	%g3, %g1, 12
	st	%g6, %g1, 16
	st	%g4, %g1, 20
	mov	%g3, %g8
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	d_vec.2808
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	veciprod.2722
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fst	%f0, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fisneg.2615
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10091
	ld	%g3, %g1, 16
	slli	%g4, %g3, 2
	ld	%g5, %g1, 12
	st	%g5, %g1, 28
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 28
	setL %g6, l.7291
	fld	%f0, %g6, 0
	fld	%f1, %g1, 24
	fdiv	%f0, %f1, %f0
	ld	%g29, %g1, 8
	mov	%g3, %g4
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	jmp	jeq_cont.10092
jeq_else.10091:
	ld	%g3, %g1, 16
	addi	%g4, %g3, 1
	slli	%g4, %g4, 2
	ld	%g5, %g1, 12
	st	%g5, %g1, 28
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 28
	setL %g6, l.7287
	fld	%f0, %g6, 0
	fld	%f1, %g1, 24
	fdiv	%f0, %f1, %f0
	ld	%g29, %g1, 8
	mov	%g3, %g4
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
jeq_cont.10092:
	ld	%g3, %g1, 16
	subi	%g6, %g3, 2
	ld	%g3, %g1, 12
	ld	%g4, %g1, 20
	ld	%g5, %g1, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jle_else.10090:
	return
trace_diffuse_rays.3042:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g3, %g1, 8
	st	%g7, %g1, 12
	mov	%g3, %g5
	mov	%g29, %g6
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g6, 0
	mvlo	%g6, 118
	ld	%g3, %g1, 8
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 12
	ld	%g28, %g29, 0
	b	%g28
trace_diffuse_ray_80percent.3046:
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	mvhi	%g8, 0
	mvlo	%g8, 0
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g6, %g1, 8
	st	%g7, %g1, 12
	st	%g3, %g1, 16
	jne	%g3, %g8, jeq_else.10094
	jmp	jeq_cont.10095
jeq_else.10094:
	ld	%g8, %g7, 0
	mov	%g3, %g8
	mov	%g29, %g6
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.10095:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 16
	jne	%g4, %g3, jeq_else.10096
	jmp	jeq_cont.10097
jeq_else.10096:
	ld	%g3, %g1, 12
	ld	%g5, %g3, -4
	ld	%g6, %g1, 4
	ld	%g7, %g1, 0
	ld	%g29, %g1, 8
	mov	%g4, %g6
	mov	%g3, %g5
	mov	%g5, %g7
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.10097:
	mvhi	%g3, 0
	mvlo	%g3, 2
	ld	%g4, %g1, 16
	jne	%g4, %g3, jeq_else.10098
	jmp	jeq_cont.10099
jeq_else.10098:
	ld	%g3, %g1, 12
	ld	%g5, %g3, -8
	ld	%g6, %g1, 4
	ld	%g7, %g1, 0
	ld	%g29, %g1, 8
	mov	%g4, %g6
	mov	%g3, %g5
	mov	%g5, %g7
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.10099:
	mvhi	%g3, 0
	mvlo	%g3, 3
	ld	%g4, %g1, 16
	jne	%g4, %g3, jeq_else.10100
	jmp	jeq_cont.10101
jeq_else.10100:
	ld	%g3, %g1, 12
	ld	%g5, %g3, -12
	ld	%g6, %g1, 4
	ld	%g7, %g1, 0
	ld	%g29, %g1, 8
	mov	%g4, %g6
	mov	%g3, %g5
	mov	%g5, %g7
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.10101:
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 16
	jne	%g4, %g3, jeq_else.10102
	return
jeq_else.10102:
	ld	%g3, %g1, 12
	ld	%g3, %g3, -16
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
calc_diffuse_using_1point.3050:
	ld	%g5, %g29, -12
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	st	%g6, %g1, 0
	st	%g5, %g1, 4
	st	%g7, %g1, 8
	st	%g4, %g1, 12
	st	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	p_received_ray_20percent.2799
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 16
	st	%g3, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_nvectors.2806
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 16
	st	%g3, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_intersection_points.2791
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 16
	st	%g3, %g1, 28
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	p_energy.2797
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 12
	slli	%g5, %g4, 2
	ld	%g6, %g1, 20
	st	%g6, %g1, 36
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 36
	ld	%g6, %g1, 8
	st	%g3, %g1, 32
	mov	%g4, %g5
	mov	%g3, %g6
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	veccpy.2711
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 16
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	p_group_id.2801
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 12
	slli	%g5, %g4, 2
	ld	%g6, %g1, 24
	st	%g6, %g1, 36
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 36
	slli	%g6, %g4, 2
	ld	%g7, %g1, 28
	st	%g7, %g1, 36
	add	%g7, %g7, %g6
	ld	%g6, %g7, 0
	ld	%g7, %g1, 36
	ld	%g29, %g1, 4
	mov	%g4, %g5
	mov	%g5, %g6
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 12
	slli	%g3, %g3, 2
	ld	%g4, %g1, 32
	st	%g4, %g1, 36
	add	%g4, %g4, %g3
	ld	%g4, %g4, 0
	ld	%g3, %g1, 0
	ld	%g5, %g1, 8
	jmp	vecaccumv.2743
calc_diffuse_using_5points.3053:
	ld	%g8, %g29, -8
	ld	%g9, %g29, -4
	slli	%g10, %g3, 2
	st	%g4, %g1, 4
	add	%g4, %g4, %g10
	ld	%g4, %g4, 0
	st	%g8, %g1, 0
	st	%g9, %g1, 4
	st	%g7, %g1, 8
	st	%g6, %g1, 12
	st	%g5, %g1, 16
	st	%g3, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_received_ray_20percent.2799
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	subi	%g5, %g4, 1
	slli	%g5, %g5, 2
	ld	%g6, %g1, 16
	st	%g6, %g1, 28
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 28
	st	%g3, %g1, 24
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_received_ray_20percent.2799
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	slli	%g5, %g4, 2
	ld	%g6, %g1, 16
	st	%g6, %g1, 28
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 28
	st	%g3, %g1, 28
	mov	%g3, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	p_received_ray_20percent.2799
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 20
	addi	%g5, %g4, 1
	slli	%g5, %g5, 2
	ld	%g6, %g1, 16
	st	%g6, %g1, 36
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 36
	st	%g3, %g1, 32
	mov	%g3, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	p_received_ray_20percent.2799
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 20
	slli	%g5, %g4, 2
	ld	%g6, %g1, 12
	st	%g6, %g1, 36
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 36
	st	%g3, %g1, 36
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	p_received_ray_20percent.2799
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 8
	slli	%g5, %g4, 2
	ld	%g6, %g1, 24
	st	%g6, %g1, 44
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 44
	ld	%g6, %g1, 4
	st	%g3, %g1, 40
	mov	%g4, %g5
	mov	%g3, %g6
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	veccpy.2711
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 8
	slli	%g4, %g3, 2
	ld	%g5, %g1, 28
	st	%g5, %g1, 44
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 44
	ld	%g5, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecadd.2734
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 8
	slli	%g4, %g3, 2
	ld	%g5, %g1, 32
	st	%g5, %g1, 44
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 44
	ld	%g5, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecadd.2734
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 8
	slli	%g4, %g3, 2
	ld	%g5, %g1, 36
	st	%g5, %g1, 44
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 44
	ld	%g5, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecadd.2734
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 8
	slli	%g4, %g3, 2
	ld	%g5, %g1, 40
	st	%g5, %g1, 44
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 44
	ld	%g5, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecadd.2734
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 20
	slli	%g3, %g3, 2
	ld	%g4, %g1, 16
	st	%g4, %g1, 44
	add	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 44
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	p_energy.2797
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 8
	slli	%g4, %g4, 2
	st	%g3, %g1, 44
	add	%g3, %g3, %g4
	ld	%g4, %g3, 0
	ld	%g3, %g1, 44
	ld	%g3, %g1, 0
	ld	%g5, %g1, 4
	jmp	vecaccumv.2743
do_without_neighbors.3059:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 4
	jlt	%g6, %g4, jle_else.10104
	st	%g29, %g1, 0
	st	%g5, %g1, 4
	st	%g3, %g1, 8
	st	%g4, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	p_surface_ids.2793
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g5, %g1, 12
	slli	%g6, %g5, 2
	st	%g3, %g1, 20
	add	%g3, %g3, %g6
	ld	%g3, %g3, 0
	jlt	%g3, %g4, jle_else.10105
	ld	%g3, %g1, 8
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	p_calc_diffuse.2795
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 12
	slli	%g5, %g4, 2
	st	%g3, %g1, 20
	add	%g3, %g3, %g5
	ld	%g3, %g3, 0
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.10106
	jmp	jeq_cont.10107
jeq_else.10106:
	ld	%g3, %g1, 8
	ld	%g29, %g1, 4
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
jeq_cont.10107:
	ld	%g3, %g1, 12
	addi	%g4, %g3, 1
	ld	%g3, %g1, 8
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10105:
	return
jle_else.10104:
	return
neighbors_exist.3062:
	ld	%g5, %g29, -4
	ld	%g6, %g5, -4
	addi	%g7, %g4, 1
	jlt	%g7, %g6, jle_else.10110
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jle_else.10110:
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g6, %g4, jle_else.10111
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jle_else.10111:
	ld	%g4, %g5, 0
	addi	%g5, %g3, 1
	jlt	%g5, %g4, jle_else.10112
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jle_else.10112:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jlt	%g4, %g3, jle_else.10113
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jle_else.10113:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
get_surface_id.3066:
	st	%g4, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	p_surface_ids.2793
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	slli	%g4, %g4, 2
	st	%g3, %g1, 4
	add	%g3, %g3, %g4
	ld	%g3, %g3, 0
	return
neighbors_are_available.3069:
	slli	%g8, %g3, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g8
	ld	%g8, %g5, 0
	ld	%g5, %g1, 4
	st	%g5, %g1, 0
	st	%g6, %g1, 4
	st	%g7, %g1, 8
	st	%g4, %g1, 12
	st	%g3, %g1, 16
	mov	%g4, %g7
	mov	%g3, %g8
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	get_surface_id.3066
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 16
	slli	%g5, %g4, 2
	ld	%g6, %g1, 12
	st	%g6, %g1, 20
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 20
	ld	%g6, %g1, 8
	st	%g3, %g1, 20
	mov	%g4, %g6
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	get_surface_id.3066
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	jne	%g3, %g4, jeq_else.10114
	ld	%g3, %g1, 16
	slli	%g5, %g3, 2
	ld	%g6, %g1, 4
	st	%g6, %g1, 28
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 28
	ld	%g6, %g1, 8
	mov	%g4, %g6
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	get_surface_id.3066
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	jne	%g3, %g4, jeq_else.10115
	ld	%g3, %g1, 16
	subi	%g5, %g3, 1
	slli	%g5, %g5, 2
	ld	%g6, %g1, 0
	st	%g6, %g1, 28
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 28
	ld	%g7, %g1, 8
	mov	%g4, %g7
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	get_surface_id.3066
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	jne	%g3, %g4, jeq_else.10116
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	slli	%g3, %g3, 2
	ld	%g5, %g1, 0
	st	%g5, %g1, 28
	add	%g5, %g5, %g3
	ld	%g3, %g5, 0
	ld	%g5, %g1, 28
	ld	%g5, %g1, 8
	mov	%g4, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	get_surface_id.3066
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	jne	%g3, %g4, jeq_else.10117
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
jeq_else.10117:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10116:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10115:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.10114:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
try_exploit_neighbors.3075:
	ld	%g9, %g29, -8
	ld	%g10, %g29, -4
	slli	%g11, %g3, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g11
	ld	%g11, %g6, 0
	ld	%g6, %g1, 4
	mvhi	%g12, 0
	mvlo	%g12, 4
	jlt	%g12, %g8, jle_else.10118
	mvhi	%g12, 0
	mvlo	%g12, 0
	st	%g4, %g1, 0
	st	%g29, %g1, 4
	st	%g10, %g1, 8
	st	%g11, %g1, 12
	st	%g9, %g1, 16
	st	%g8, %g1, 20
	st	%g7, %g1, 24
	st	%g6, %g1, 28
	st	%g5, %g1, 32
	st	%g3, %g1, 36
	st	%g12, %g1, 40
	mov	%g4, %g8
	mov	%g3, %g11
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	get_surface_id.3066
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 40
	jlt	%g3, %g4, jle_else.10119
	ld	%g3, %g1, 36
	ld	%g4, %g1, 32
	ld	%g5, %g1, 28
	ld	%g6, %g1, 24
	ld	%g7, %g1, 20
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	neighbors_are_available.3069
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10120
	ld	%g3, %g1, 36
	slli	%g3, %g3, 2
	ld	%g4, %g1, 28
	st	%g4, %g1, 44
	add	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 44
	ld	%g4, %g1, 20
	ld	%g29, %g1, 16
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10120:
	ld	%g3, %g1, 12
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	p_calc_diffuse.2795
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g7, %g1, 20
	slli	%g4, %g7, 2
	st	%g3, %g1, 44
	add	%g3, %g3, %g4
	ld	%g3, %g3, 0
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10121
	jmp	jeq_cont.10122
jeq_else.10121:
	ld	%g3, %g1, 36
	ld	%g4, %g1, 32
	ld	%g5, %g1, 28
	ld	%g6, %g1, 24
	ld	%g29, %g1, 8
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
jeq_cont.10122:
	ld	%g3, %g1, 20
	addi	%g8, %g3, 1
	ld	%g3, %g1, 36
	ld	%g4, %g1, 0
	ld	%g5, %g1, 32
	ld	%g6, %g1, 28
	ld	%g7, %g1, 24
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jle_else.10119:
	return
jle_else.10118:
	return
write_ppm_header.3082:
	ld	%g3, %g29, -8
	ld	%g4, %g29, -4
	mvhi	%g5, 0
	mvlo	%g5, 80
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	mov	%g3, %g5
	output	%g3
	mvhi	%g3, 0
	mvlo	%g3, 51
	output	%g3
	mvhi	%g3, 0
	mvlo	%g3, 10
	output	%g3
	ld	%g3, %g1, 4
	ld	%g4, %g3, 0
	ld	%g29, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g3, 0
	mvlo	%g3, 32
	output	%g3
	ld	%g3, %g1, 4
	ld	%g3, %g3, -4
	ld	%g29, %g1, 0
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g3, 0
	mvlo	%g3, 32
	output	%g3
	mvhi	%g3, 0
	mvlo	%g3, 255
	ld	%g29, %g1, 0
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g3, 0
	mvlo	%g3, 10
	output	%g3
	return
write_rgb_element.3084:
	ld	%g3, %g29, -4
	st	%g3, %g1, 0
	int_of_float	%g3, %f0
	mvhi	%g4, 0
	mvlo	%g4, 255
	jlt	%g4, %g3, jle_else.10125
	mvhi	%g4, 0
	mvlo	%g4, 0
	jlt	%g3, %g4, jle_else.10127
	jmp	jle_cont.10128
jle_else.10127:
	mvhi	%g3, 0
	mvlo	%g3, 0
jle_cont.10128:
	jmp	jle_cont.10126
jle_else.10125:
	mvhi	%g3, 0
	mvlo	%g3, 255
jle_cont.10126:
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
write_rgb.3086:
	ld	%g3, %g29, -8
	ld	%g4, %g29, -4
	fld	%f0, %g4, 0
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	mov	%g29, %g3
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g3, 0
	mvlo	%g3, 32
	output	%g3
	ld	%g3, %g1, 4
	fld	%f0, %g3, -4
	ld	%g29, %g1, 0
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g3, 0
	mvlo	%g3, 32
	output	%g3
	ld	%g3, %g1, 4
	fld	%f0, %g3, -8
	ld	%g29, %g1, 0
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g3, 0
	mvlo	%g3, 10
	output	%g3
	return
pretrace_diffuse_rays.3088:
	ld	%g5, %g29, -12
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	mvhi	%g8, 0
	mvlo	%g8, 4
	jlt	%g8, %g4, jle_else.10129
	st	%g29, %g1, 0
	st	%g5, %g1, 4
	st	%g6, %g1, 8
	st	%g7, %g1, 12
	st	%g4, %g1, 16
	st	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	get_surface_id.3066
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	jlt	%g3, %g4, jle_else.10130
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_calc_diffuse.2795
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 16
	slli	%g5, %g4, 2
	st	%g3, %g1, 28
	add	%g3, %g3, %g5
	ld	%g3, %g3, 0
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.10131
	jmp	jeq_cont.10132
jeq_else.10131:
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_group_id.2801
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 12
	st	%g3, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	vecbzero.2709
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	p_nvectors.2806
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	st	%g3, %g1, 28
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	p_intersection_points.2791
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 24
	slli	%g4, %g4, 2
	ld	%g5, %g1, 8
	st	%g5, %g1, 36
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 36
	ld	%g5, %g1, 16
	slli	%g6, %g5, 2
	ld	%g7, %g1, 28
	st	%g7, %g1, 36
	add	%g7, %g7, %g6
	ld	%g6, %g7, 0
	ld	%g7, %g1, 36
	slli	%g7, %g5, 2
	st	%g3, %g1, 36
	add	%g3, %g3, %g7
	ld	%g3, %g3, 0
	ld	%g29, %g1, 4
	mov	%g5, %g3
	mov	%g3, %g4
	mov	%g4, %g6
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 20
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	p_received_ray_20percent.2799
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 16
	slli	%g5, %g4, 2
	st	%g3, %g1, 36
	add	%g3, %g3, %g5
	ld	%g3, %g3, 0
	ld	%g5, %g1, 12
	mov	%g4, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	veccpy.2711
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
jeq_cont.10132:
	ld	%g3, %g1, 16
	addi	%g4, %g3, 1
	ld	%g3, %g1, 20
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10130:
	return
jle_else.10129:
	return
pretrace_pixels.3091:
	ld	%g6, %g29, -36
	ld	%g7, %g29, -32
	ld	%g8, %g29, -28
	ld	%g9, %g29, -24
	ld	%g10, %g29, -20
	ld	%g11, %g29, -16
	ld	%g12, %g29, -12
	ld	%g13, %g29, -8
	ld	%g14, %g29, -4
	mvhi	%g15, 0
	mvlo	%g15, 0
	jlt	%g4, %g15, jle_else.10135
	fld	%f3, %g10, 0
	ld	%g10, %g14, 0
	sub	%g10, %g4, %g10
	st	%g29, %g1, 0
	st	%g13, %g1, 4
	st	%g5, %g1, 8
	st	%g7, %g1, 12
	st	%g3, %g1, 16
	st	%g4, %g1, 20
	st	%g6, %g1, 24
	st	%g8, %g1, 28
	st	%g11, %g1, 32
	fst	%f2, %g1, 36
	fst	%f1, %g1, 40
	st	%g12, %g1, 44
	fst	%f0, %g1, 48
	st	%g9, %g1, 52
	fst	%f3, %g1, 56
	mov	%g3, %g10
	float_of_int	%f0, %g3
	fld	%f1, %g1, 56
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 52
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	fld	%f2, %g1, 48
	fadd	%f1, %f1, %f2
	ld	%g4, %g1, 44
	fst	%f1, %g4, 0
	fld	%f1, %g3, -4
	fmul	%f1, %f0, %f1
	fld	%f3, %g1, 40
	fadd	%f1, %f1, %f3
	fst	%f1, %g4, -4
	fld	%f1, %g3, -8
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 36
	fadd	%f0, %f0, %f1
	fst	%f0, %g4, -8
	mvhi	%g3, 0
	mvlo	%g3, 0
	mov	%g28, %g4
	mov	%g4, %g3
	mov	%g3, %g28
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	vecunit_sgn.2719
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 32
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	vecbzero.2709
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 28
	ld	%g4, %g1, 24
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	veccpy.2711
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g3, 0
	mvlo	%g3, 0
	setL %g4, l.6468
	fld	%f0, %g4, 0
	ld	%g4, %g1, 20
	slli	%g5, %g4, 2
	ld	%g6, %g1, 16
	st	%g6, %g1, 60
	add	%g6, %g6, %g5
	ld	%g5, %g6, 0
	ld	%g6, %g1, 60
	setL %g7, l.6407
	fld	%f1, %g7, 0
	ld	%g7, %g1, 44
	ld	%g29, %g1, 12
	mov	%g4, %g7
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 20
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	st	%g5, %g1, 60
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 60
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	p_rgb.2789
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g4, %g1, 32
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	veccpy.2711
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 20
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	st	%g5, %g1, 60
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 60
	ld	%g6, %g1, 8
	mov	%g3, %g4
	mov	%g4, %g6
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	p_set_group_id.2803
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 20
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	st	%g5, %g1, 60
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 60
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g29, %g1, 4
	mov	%g3, %g4
	mov	%g4, %g6
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 20
	subi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 1
	ld	%g5, %g1, 8
	st	%g3, %g1, 60
	mov	%g3, %g5
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	add_mod5.2698
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mov	%g5, %g3
	fld	%f0, %g1, 48
	fld	%f1, %g1, 40
	fld	%f2, %g1, 36
	ld	%g3, %g1, 16
	ld	%g4, %g1, 60
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10135:
	return
pretrace_line.3098:
	ld	%g6, %g29, -24
	ld	%g7, %g29, -20
	ld	%g8, %g29, -16
	ld	%g9, %g29, -12
	ld	%g10, %g29, -8
	ld	%g11, %g29, -4
	fld	%f0, %g8, 0
	ld	%g8, %g11, -4
	sub	%g4, %g4, %g8
	st	%g5, %g1, 0
	st	%g3, %g1, 4
	st	%g9, %g1, 8
	st	%g10, %g1, 12
	st	%g6, %g1, 16
	st	%g7, %g1, 20
	fst	%f0, %g1, 24
	mov	%g3, %g4
	float_of_int	%f0, %g3
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 20
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	ld	%g4, %g1, 16
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
	ld	%g3, %g1, 12
	ld	%g3, %g3, 0
	subi	%g4, %g3, 1
	ld	%g3, %g1, 4
	ld	%g5, %g1, 0
	ld	%g29, %g1, 8
	fmov	%f31, %f2
	fmov	%f2, %f0
	fmov	%f0, %f1
	fmov	%f1, %f31
	ld	%g28, %g29, 0
	b	%g28
scan_pixel.3102:
	ld	%g8, %g29, -24
	ld	%g9, %g29, -20
	ld	%g10, %g29, -16
	ld	%g11, %g29, -12
	ld	%g12, %g29, -8
	ld	%g13, %g29, -4
	ld	%g12, %g12, 0
	jlt	%g3, %g12, jle_else.10137
	return
jle_else.10137:
	slli	%g12, %g3, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g12
	ld	%g12, %g6, 0
	ld	%g6, %g1, 4
	st	%g29, %g1, 0
	st	%g8, %g1, 4
	st	%g5, %g1, 8
	st	%g9, %g1, 12
	st	%g13, %g1, 16
	st	%g6, %g1, 20
	st	%g7, %g1, 24
	st	%g4, %g1, 28
	st	%g3, %g1, 32
	st	%g11, %g1, 36
	st	%g10, %g1, 40
	mov	%g3, %g12
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	p_rgb.2789
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mov	%g4, %g3
	ld	%g3, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	veccpy.2711
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 32
	ld	%g4, %g1, 28
	ld	%g5, %g1, 24
	ld	%g29, %g1, 36
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10139
	ld	%g3, %g1, 32
	slli	%g4, %g3, 2
	ld	%g5, %g1, 20
	st	%g5, %g1, 44
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 44
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g29, %g1, 16
	mov	%g3, %g4
	mov	%g4, %g6
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	jmp	jeq_cont.10140
jeq_else.10139:
	mvhi	%g8, 0
	mvlo	%g8, 0
	ld	%g3, %g1, 32
	ld	%g4, %g1, 28
	ld	%g5, %g1, 8
	ld	%g6, %g1, 20
	ld	%g7, %g1, 24
	ld	%g29, %g1, 12
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
jeq_cont.10140:
	ld	%g29, %g1, 4
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 32
	addi	%g3, %g3, 1
	ld	%g4, %g1, 28
	ld	%g5, %g1, 8
	ld	%g6, %g1, 20
	ld	%g7, %g1, 24
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
scan_line.3108:
	ld	%g8, %g29, -12
	ld	%g9, %g29, -8
	ld	%g10, %g29, -4
	ld	%g11, %g10, -4
	jlt	%g3, %g11, jle_else.10141
	return
jle_else.10141:
	ld	%g10, %g10, -4
	subi	%g10, %g10, 1
	st	%g29, %g1, 0
	st	%g7, %g1, 4
	st	%g6, %g1, 8
	st	%g5, %g1, 12
	st	%g4, %g1, 16
	st	%g3, %g1, 20
	st	%g8, %g1, 24
	jlt	%g3, %g10, jle_else.10143
	jmp	jle_cont.10144
jle_else.10143:
	addi	%g10, %g3, 1
	mov	%g5, %g7
	mov	%g4, %g10
	mov	%g3, %g6
	mov	%g29, %g9
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
jle_cont.10144:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 20
	ld	%g5, %g1, 16
	ld	%g6, %g1, 12
	ld	%g7, %g1, 8
	ld	%g29, %g1, 24
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 2
	ld	%g5, %g1, 4
	st	%g3, %g1, 28
	mov	%g3, %g5
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	add_mod5.2698
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g7, %g3
	ld	%g3, %g1, 28
	ld	%g4, %g1, 12
	ld	%g5, %g1, 8
	ld	%g6, %g1, 16
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
create_float5x3array.3114:
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g4, l.6407
	fld	%f0, %g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 5
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	st	%g3, %g4, -4
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	st	%g3, %g4, -8
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	st	%g3, %g4, -12
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	st	%g3, %g4, -16
	mov	%g3, %g4
	return
create_pixel.3116:
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g4, l.6407
	fld	%f0, %g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	st	%g3, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	create_float5x3array.3114
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 5
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 4
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 5
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 8
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	st	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	create_float5x3array.3114
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	create_float5x3array.3114
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 20
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_create_array
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	st	%g3, %g1, 24
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	create_float5x3array.3114
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g2
	addi	%g2, %g2, 32
	st	%g3, %g4, -28
	ld	%g3, %g1, 24
	st	%g3, %g4, -24
	ld	%g3, %g1, 20
	st	%g3, %g4, -20
	ld	%g3, %g1, 16
	st	%g3, %g4, -16
	ld	%g3, %g1, 12
	st	%g3, %g4, -12
	ld	%g3, %g1, 8
	st	%g3, %g4, -8
	ld	%g3, %g1, 4
	st	%g3, %g4, -4
	ld	%g3, %g1, 0
	st	%g3, %g4, 0
	mov	%g3, %g4
	return
init_line_elements.3118:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jlt	%g4, %g5, jle_else.10145
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	create_pixel.3116
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	slli	%g5, %g4, 2
	ld	%g6, %g1, 0
	st	%g6, %g1, 12
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 12
	subi	%g4, %g4, 1
	mov	%g3, %g6
	jmp	init_line_elements.3118
jle_else.10145:
	return
create_pixelline.3121:
	ld	%g3, %g29, -4
	ld	%g4, %g3, 0
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	create_pixel.3116
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mov	%g4, %g3
	ld	%g3, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 0
	ld	%g4, %g4, 0
	subi	%g4, %g4, 2
	jmp	init_line_elements.3118
tan.3123:
	fst	%f0, %g1, 0
	sin	%f0, %f0
	fld	%f1, %g1, 0
	fst	%f0, %g1, 4
	fmov	%f0, %f1
	cos	%f0, %f0
	fld	%f1, %g1, 4
	fdiv	%f0, %f1, %f0
	return
adjust_position.3125:
	fmul	%f0, %f0, %f0
	setL %g3, l.7258
	fld	%f2, %g3, 0
	fadd	%f0, %f0, %f2
	fst	%f1, %g1, 0
	fsqrt	%f0, %f0
	setL %g3, l.6468
	fld	%f1, %g3, 0
	fdiv	%f1, %f1, %f0
	fst	%f0, %g1, 4
	fmov	%f0, %f1
	atan	%f0, %f0
	fld	%f1, %g1, 0
	fmul	%f0, %f0, %f1
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	tan.3123
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f1, %g1, 4
	fmul	%f0, %f0, %f1
	return
calc_dirvec.3128:
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 5
	jlt	%g3, %g7, jle_else.10146
	st	%g5, %g1, 0
	st	%g6, %g1, 4
	st	%g4, %g1, 8
	fst	%f0, %g1, 12
	fst	%f1, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fsqr.2630
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 16
	fst	%f0, %g1, 20
	fmov	%f0, %f1
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fsqr.2630
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 20
	fadd	%f0, %f1, %f0
	setL %g3, l.6468
	fld	%f1, %g3, 0
	fadd	%f0, %f0, %f1
	fsqrt	%f0, %f0
	fld	%f1, %g1, 12
	fdiv	%f1, %f1, %f0
	fld	%f2, %g1, 16
	fdiv	%f2, %f2, %f0
	setL %g3, l.6468
	fld	%f3, %g3, 0
	fdiv	%f0, %f3, %f0
	ld	%g3, %g1, 8
	slli	%g3, %g3, 2
	ld	%g4, %g1, 4
	st	%g4, %g1, 28
	add	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 28
	ld	%g4, %g1, 0
	slli	%g5, %g4, 2
	st	%g3, %g1, 28
	add	%g3, %g3, %g5
	ld	%g5, %g3, 0
	ld	%g3, %g1, 28
	st	%g3, %g1, 24
	fst	%f0, %g1, 28
	fst	%f2, %g1, 32
	fst	%f1, %g1, 36
	mov	%g3, %g5
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	d_vec.2808
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f0, %g1, 36
	fld	%f1, %g1, 32
	fld	%f2, %g1, 28
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecset.2701
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 0
	addi	%g4, %g3, 40
	slli	%g4, %g4, 2
	ld	%g5, %g1, 24
	st	%g5, %g1, 44
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 44
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	d_vec.2808
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f0, %g1, 32
	st	%g3, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	fneg.2626
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fmov	%f2, %f0, 0
	fld	%f0, %g1, 36
	fld	%f1, %g1, 28
	ld	%g3, %g1, 40
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	vecset.2701
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 0
	addi	%g4, %g3, 80
	slli	%g4, %g4, 2
	ld	%g5, %g1, 24
	st	%g5, %g1, 44
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 44
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	d_vec.2808
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f0, %g1, 36
	st	%g3, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2626
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 32
	fst	%f0, %g1, 48
	fmov	%f0, %f1
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	fneg.2626
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fmov	%f2, %f0, 0
	fld	%f0, %g1, 28
	fld	%f1, %g1, 48
	ld	%g3, %g1, 44
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	vecset.2701
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 0
	addi	%g4, %g3, 1
	slli	%g4, %g4, 2
	ld	%g5, %g1, 24
	st	%g5, %g1, 52
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 52
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	d_vec.2808
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f0, %g1, 36
	st	%g3, %g1, 52
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fneg.2626
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 32
	fst	%f0, %g1, 56
	fmov	%f0, %f1
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	fneg.2626
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 28
	fst	%f0, %g1, 60
	fmov	%f0, %f1
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fneg.2626
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fmov	%f2, %f0, 0
	fld	%f0, %g1, 56
	fld	%f1, %g1, 60
	ld	%g3, %g1, 52
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	vecset.2701
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 0
	addi	%g4, %g3, 41
	slli	%g4, %g4, 2
	ld	%g5, %g1, 24
	st	%g5, %g1, 68
	add	%g5, %g5, %g4
	ld	%g4, %g5, 0
	ld	%g5, %g1, 68
	mov	%g3, %g4
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	d_vec.2808
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f0, %g1, 36
	st	%g3, %g1, 64
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	fneg.2626
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fld	%f1, %g1, 28
	fst	%f0, %g1, 68
	fmov	%f0, %f1
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fneg.2626
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 68
	fld	%f2, %g1, 32
	ld	%g3, %g1, 64
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	vecset.2701
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g3, %g1, 0
	addi	%g3, %g3, 81
	slli	%g3, %g3, 2
	ld	%g4, %g1, 24
	st	%g4, %g1, 76
	add	%g4, %g4, %g3
	ld	%g3, %g4, 0
	ld	%g4, %g1, 76
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	d_vec.2808
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f0, %g1, 28
	st	%g3, %g1, 72
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	fneg.2626
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fld	%f1, %g1, 36
	fld	%f2, %g1, 32
	ld	%g3, %g1, 72
	jmp	vecset.2701
jle_else.10146:
	fst	%f2, %g1, 76
	st	%g5, %g1, 0
	st	%g4, %g1, 8
	st	%g29, %g1, 80
	fst	%f3, %g1, 84
	st	%g3, %g1, 88
	fmov	%f0, %f1
	fmov	%f1, %f2
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	adjust_position.3125
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	ld	%g3, %g1, 88
	addi	%g3, %g3, 1
	fld	%f1, %g1, 84
	fst	%f0, %g1, 92
	st	%g3, %g1, 96
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	adjust_position.3125
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	fmov	%f1, %f0, 0
	fld	%f0, %g1, 92
	fld	%f2, %g1, 76
	fld	%f3, %g1, 84
	ld	%g3, %g1, 96
	ld	%g4, %g1, 8
	ld	%g5, %g1, 0
	ld	%g29, %g1, 80
	ld	%g28, %g29, 0
	b	%g28
calc_dirvecs.3136:
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g3, %g7, jle_else.10147
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	fst	%f0, %g1, 8
	st	%g5, %g1, 12
	st	%g4, %g1, 16
	st	%g6, %g1, 20
	float_of_int	%f0, %g3
	setL %g3, l.7474
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.7476
	fld	%f1, %g3, 0
	fsub	%f2, %f0, %f1
	mvhi	%g3, 0
	mvlo	%g3, 0
	setL %g4, l.6407
	fld	%f0, %g4, 0
	setL %g4, l.6407
	fld	%f1, %g4, 0
	fld	%f3, %g1, 8
	ld	%g4, %g1, 16
	ld	%g5, %g1, 12
	ld	%g29, %g1, 20
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 4
	float_of_int	%f0, %g3
	setL %g3, l.7474
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.7258
	fld	%f1, %g3, 0
	fadd	%f2, %f0, %f1
	mvhi	%g3, 0
	mvlo	%g3, 0
	setL %g4, l.6407
	fld	%f0, %g4, 0
	setL %g4, l.6407
	fld	%f1, %g4, 0
	ld	%g4, %g1, 12
	addi	%g5, %g4, 2
	fld	%f3, %g1, 8
	ld	%g6, %g1, 16
	ld	%g29, %g1, 20
	mov	%g4, %g6
	st	%g31, %g1, 28
	ld	%g28, %g29, 0
	subi	%g1, %g1, 32
	callR	%g28
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 1
	ld	%g5, %g1, 16
	st	%g3, %g1, 24
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	add_mod5.2698
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g3
	fld	%f0, %g1, 8
	ld	%g3, %g1, 24
	ld	%g5, %g1, 12
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10147:
	return
calc_dirvec_rows.3141:
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g3, %g7, jle_else.10149
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	st	%g5, %g1, 8
	st	%g4, %g1, 12
	st	%g6, %g1, 16
	float_of_int	%f0, %g3
	setL %g3, l.7474
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.7476
	fld	%f1, %g3, 0
	fsub	%f0, %f0, %f1
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 12
	ld	%g5, %g1, 8
	ld	%g29, %g1, 16
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 2
	ld	%g5, %g1, 12
	st	%g3, %g1, 20
	mov	%g3, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	add_mod5.2698
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g3
	ld	%g3, %g1, 8
	addi	%g5, %g3, 4
	ld	%g3, %g1, 20
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10149:
	return
create_dirvec.3145:
	ld	%g3, %g29, -4
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g4, %g3
	ld	%g3, %g1, 0
	ld	%g3, %g3, 0
	st	%g4, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 4
	st	%g3, %g4, 0
	mov	%g3, %g4
	return
create_dirvec_elements.3147:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g4, %g6, jle_else.10151
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	st	%g4, %g1, 8
	mov	%g29, %g5
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 8
	slli	%g5, %g4, 2
	ld	%g6, %g1, 4
	st	%g6, %g1, 12
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 12
	subi	%g4, %g4, 1
	ld	%g29, %g1, 0
	mov	%g3, %g6
	ld	%g28, %g29, 0
	b	%g28
jle_else.10151:
	return
create_dirvecs.3150:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g3, %g7, jle_else.10153
	mvhi	%g7, 0
	mvlo	%g7, 120
	st	%g29, %g1, 0
	st	%g5, %g1, 4
	st	%g4, %g1, 8
	st	%g3, %g1, 12
	st	%g7, %g1, 16
	mov	%g29, %g6
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g3
	ld	%g3, %g1, 16
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 12
	slli	%g5, %g4, 2
	ld	%g6, %g1, 8
	st	%g6, %g1, 20
	add	%g6, %g6, %g5
	st	%g3, %g6, 0
	ld	%g6, %g1, 20
	slli	%g3, %g4, 2
	st	%g6, %g1, 20
	add	%g6, %g6, %g3
	ld	%g3, %g6, 0
	ld	%g6, %g1, 20
	mvhi	%g5, 0
	mvlo	%g5, 118
	ld	%g29, %g1, 4
	mov	%g4, %g5
	st	%g31, %g1, 20
	ld	%g28, %g29, 0
	subi	%g1, %g1, 24
	callR	%g28
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 12
	subi	%g3, %g3, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10153:
	return
init_dirvec_constants.3152:
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g4, %g6, jle_else.10155
	slli	%g6, %g4, 2
	st	%g3, %g1, 4
	add	%g3, %g3, %g6
	ld	%g6, %g3, 0
	ld	%g3, %g1, 4
	st	%g3, %g1, 0
	st	%g29, %g1, 4
	st	%g4, %g1, 8
	mov	%g3, %g6
	mov	%g29, %g5
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 8
	subi	%g4, %g3, 1
	ld	%g3, %g1, 0
	ld	%g29, %g1, 4
	ld	%g28, %g29, 0
	b	%g28
jle_else.10155:
	return
init_vecset_constants.3155:
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 0
	jlt	%g3, %g6, jle_else.10157
	slli	%g6, %g3, 2
	st	%g5, %g1, 4
	add	%g5, %g5, %g6
	ld	%g5, %g5, 0
	mvhi	%g6, 0
	mvlo	%g6, 119
	st	%g29, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g5
	mov	%g29, %g4
	mov	%g4, %g6
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jle_else.10157:
	return
init_dirvecs.3157:
	ld	%g3, %g29, -12
	ld	%g4, %g29, -8
	ld	%g5, %g29, -4
	mvhi	%g6, 0
	mvlo	%g6, 4
	st	%g3, %g1, 0
	st	%g5, %g1, 4
	mov	%g3, %g6
	mov	%g29, %g4
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g3, 0
	mvlo	%g3, 9
	mvhi	%g4, 0
	mvlo	%g4, 0
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g29, %g1, 4
	st	%g31, %g1, 12
	ld	%g28, %g29, 0
	subi	%g1, %g1, 16
	callR	%g28
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
add_reflection.3159:
	ld	%g5, %g29, -12
	ld	%g6, %g29, -8
	ld	%g29, %g29, -4
	st	%g6, %g1, 0
	st	%g3, %g1, 4
	st	%g4, %g1, 8
	fst	%f0, %g1, 12
	st	%g5, %g1, 16
	fst	%f3, %g1, 20
	fst	%f2, %g1, 24
	fst	%f1, %g1, 28
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	st	%g3, %g1, 32
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	d_vec.2808
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f0, %g1, 28
	fld	%f1, %g1, 24
	fld	%f2, %g1, 20
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	vecset.2701
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	ld	%g29, %g1, 16
	st	%g31, %g1, 36
	ld	%g28, %g29, 0
	subi	%g1, %g1, 40
	callR	%g28
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g3, %g2
	addi	%g2, %g2, 16
	fld	%f0, %g1, 12
	fst	%f0, %g3, -8
	ld	%g4, %g1, 32
	st	%g4, %g3, -4
	ld	%g4, %g1, 8
	st	%g4, %g3, 0
	ld	%g4, %g1, 4
	slli	%g4, %g4, 2
	ld	%g5, %g1, 0
	st	%g5, %g1, 36
	add	%g5, %g5, %g4
	st	%g3, %g5, 0
	ld	%g5, %g1, 36
	return
setup_rect_reflection.3166:
	ld	%g5, %g29, -12
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	muli	%g3, %g3, 4
	ld	%g8, %g5, 0
	setL %g9, l.6468
	fld	%f0, %g9, 0
	st	%g5, %g1, 0
	st	%g8, %g1, 4
	st	%g7, %g1, 8
	st	%g3, %g1, 12
	st	%g6, %g1, 16
	fst	%f0, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_diffuse.2771
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 20
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 16
	fld	%f1, %g3, 0
	fst	%f0, %g1, 24
	fmov	%f0, %f1
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	fneg.2626
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 16
	fld	%f1, %g3, -4
	fst	%f0, %g1, 28
	fmov	%f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2626
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 16
	fld	%f1, %g3, -8
	fst	%f0, %g1, 32
	fmov	%f0, %f1
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	fneg.2626
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fmov	%f3, %f0, 0
	ld	%g3, %g1, 12
	addi	%g4, %g3, 1
	ld	%g5, %g1, 16
	fld	%f1, %g5, 0
	fld	%f0, %g1, 24
	fld	%f2, %g1, 32
	ld	%g6, %g1, 4
	ld	%g29, %g1, 8
	fst	%f3, %g1, 36
	mov	%g3, %g6
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 4
	addi	%g4, %g3, 1
	ld	%g5, %g1, 12
	addi	%g6, %g5, 2
	ld	%g7, %g1, 16
	fld	%f2, %g7, -4
	fld	%f0, %g1, 24
	fld	%f1, %g1, 28
	fld	%f3, %g1, 36
	ld	%g29, %g1, 8
	mov	%g3, %g4
	mov	%g4, %g6
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 4
	addi	%g4, %g3, 2
	ld	%g5, %g1, 12
	addi	%g5, %g5, 3
	ld	%g6, %g1, 16
	fld	%f3, %g6, -8
	fld	%f0, %g1, 24
	fld	%f1, %g1, 28
	fld	%f2, %g1, 32
	ld	%g29, %g1, 8
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 44
	ld	%g28, %g29, 0
	subi	%g1, %g1, 48
	callR	%g28
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 4
	addi	%g3, %g3, 3
	ld	%g4, %g1, 0
	st	%g3, %g4, 0
	return
setup_surface_reflection.3169:
	ld	%g5, %g29, -12
	ld	%g6, %g29, -8
	ld	%g7, %g29, -4
	muli	%g3, %g3, 4
	addi	%g3, %g3, 1
	ld	%g8, %g5, 0
	setL %g9, l.6468
	fld	%f0, %g9, 0
	st	%g5, %g1, 0
	st	%g3, %g1, 4
	st	%g8, %g1, 8
	st	%g7, %g1, 12
	st	%g6, %g1, 16
	st	%g4, %g1, 20
	fst	%f0, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	o_diffuse.2771
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 24
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 20
	fst	%f0, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	o_param_abc.2763
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g4, %g3
	ld	%g3, %g1, 16
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	veciprod.2722
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	setL %g3, l.6412
	fld	%f1, %g3, 0
	ld	%g3, %g1, 20
	fst	%f0, %g1, 32
	fst	%f1, %g1, 36
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	o_param_a.2757
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fld	%f1, %g1, 36
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 32
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 16
	fld	%f2, %g3, 0
	fsub	%f0, %f0, %f2
	setL %g4, l.6412
	fld	%f2, %g4, 0
	ld	%g4, %g1, 20
	fst	%f0, %g1, 40
	fst	%f2, %g1, 44
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	o_param_b.2759
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 44
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 32
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 16
	fld	%f2, %g3, -4
	fsub	%f0, %f0, %f2
	setL %g4, l.6412
	fld	%f2, %g4, 0
	ld	%g4, %g1, 20
	fst	%f0, %g1, 48
	fst	%f2, %g1, 52
	mov	%g3, %g4
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	o_param_c.2761
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fld	%f1, %g1, 52
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 32
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 16
	fld	%f1, %g3, -8
	fsub	%f3, %f0, %f1
	fld	%f0, %g1, 28
	fld	%f1, %g1, 40
	fld	%f2, %g1, 48
	ld	%g3, %g1, 8
	ld	%g4, %g1, 4
	ld	%g29, %g1, 12
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 8
	addi	%g3, %g3, 1
	ld	%g4, %g1, 0
	st	%g3, %g4, 0
	return
setup_reflections.3172:
	ld	%g4, %g29, -12
	ld	%g5, %g29, -8
	ld	%g6, %g29, -4
	mvhi	%g7, 0
	mvlo	%g7, 0
	jlt	%g3, %g7, jle_else.10162
	slli	%g7, %g3, 2
	st	%g6, %g1, 4
	add	%g6, %g6, %g7
	ld	%g6, %g6, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	st	%g5, %g1, 8
	st	%g6, %g1, 12
	mov	%g3, %g6
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_reflectiontype.2751
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.10163
	ld	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_diffuse.2771
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	setL %g3, l.6468
	fld	%f1, %g3, 0
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	fless.2610
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	jne	%g3, %g4, jeq_else.10164
	return
jeq_else.10164:
	ld	%g3, %g1, 12
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	o_form.2749
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 1
	jne	%g3, %g4, jeq_else.10166
	ld	%g3, %g1, 4
	ld	%g4, %g1, 12
	ld	%g29, %g1, 8
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10166:
	mvhi	%g4, 0
	mvlo	%g4, 2
	jne	%g3, %g4, jeq_else.10167
	ld	%g3, %g1, 4
	ld	%g4, %g1, 12
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
jeq_else.10167:
	return
jeq_else.10163:
	return
jle_else.10162:
	return
rt.3174:
	ld	%g5, %g29, -56
	ld	%g6, %g29, -52
	ld	%g7, %g29, -48
	ld	%g8, %g29, -44
	ld	%g9, %g29, -40
	ld	%g10, %g29, -36
	ld	%g11, %g29, -32
	ld	%g12, %g29, -28
	ld	%g13, %g29, -24
	ld	%g14, %g29, -20
	ld	%g15, %g29, -16
	ld	%g16, %g29, -12
	ld	%g17, %g29, -8
	ld	%g18, %g29, -4
	st	%g3, %g16, 0
	st	%g4, %g16, -4
	divi	%g16, %g3, 2
	st	%g16, %g17, 0
	divi	%g4, %g4, 2
	st	%g4, %g17, -4
	setL %g4, l.7541
	fld	%f0, %g4, 0
	st	%g9, %g1, 0
	st	%g11, %g1, 4
	st	%g6, %g1, 8
	st	%g12, %g1, 12
	st	%g7, %g1, 16
	st	%g14, %g1, 20
	st	%g13, %g1, 24
	st	%g15, %g1, 28
	st	%g5, %g1, 32
	st	%g10, %g1, 36
	st	%g18, %g1, 40
	st	%g8, %g1, 44
	fst	%f0, %g1, 48
	float_of_int	%f0, %g3
	fld	%f1, %g1, 48
	fdiv	%f0, %f1, %f0
	ld	%g3, %g1, 44
	fst	%f0, %g3, 0
	ld	%g29, %g1, 40
	st	%g31, %g1, 52
	ld	%g28, %g29, 0
	subi	%g1, %g1, 56
	callR	%g28
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g29, %g1, 40
	st	%g3, %g1, 52
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g29, %g1, 40
	st	%g3, %g1, 56
	st	%g31, %g1, 60
	ld	%g28, %g29, 0
	subi	%g1, %g1, 64
	callR	%g28
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g29, %g1, 36
	st	%g3, %g1, 60
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g29, %g1, 32
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g29, %g1, 28
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 24
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	d_vec.2808
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g4, %g1, 20
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	veccpy.2711
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 24
	ld	%g29, %g1, 16
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 12
	ld	%g3, %g3, 0
	subi	%g3, %g3, 1
	ld	%g29, %g1, 8
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g3, %g1, 56
	ld	%g29, %g1, 4
	st	%g31, %g1, 68
	ld	%g28, %g29, 0
	subi	%g1, %g1, 72
	callR	%g28
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g3, 0
	mvlo	%g3, 0
	mvhi	%g7, 0
	mvlo	%g7, 2
	ld	%g4, %g1, 52
	ld	%g5, %g1, 56
	ld	%g6, %g1, 60
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 0
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g4, %g2
	addi	%g2, %g2, 16
	setL %g5, read_int_token.2636
	st	%g5, %g4, 0
	st	%g3, %g4, -8
	ld	%g5, %g1, 0
	st	%g5, %g4, -4
	mov	%g6, %g2
	addi	%g2, %g2, 16
	setL %g7, read_int.2639
	st	%g7, %g6, 0
	st	%g4, %g6, -12
	st	%g3, %g6, -8
	st	%g5, %g6, -4
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g6, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 8
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 1
	st	%g3, %g1, 12
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 16
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g2
	addi	%g2, %g2, 16
	setL %g5, read_float_token1.2645
	st	%g5, %g4, 0
	st	%g3, %g4, -8
	ld	%g5, %g1, 8
	st	%g5, %g4, -4
	mov	%g6, %g2
	addi	%g2, %g2, 16
	setL %g7, read_float_token2.2648
	st	%g7, %g6, 0
	ld	%g7, %g1, 12
	st	%g7, %g6, -8
	ld	%g8, %g1, 16
	st	%g8, %g6, -4
	mov	%g9, %g2
	addi	%g2, %g2, 32
	setL %g10, read_float.2650
	st	%g10, %g9, 0
	st	%g6, %g9, -24
	st	%g4, %g9, -20
	st	%g3, %g9, -16
	st	%g5, %g9, -12
	st	%g7, %g9, -8
	st	%g8, %g9, -4
	mvhi	%g3, 0
	mvlo	%g3, 10
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g9, %g1, 20
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_create_array
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 24
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	min_caml_create_array
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g2
	addi	%g2, %g2, 16
	setL %g5, print_int_get_digits.2654
	st	%g5, %g4, 0
	st	%g3, %g4, -8
	ld	%g5, %g1, 24
	st	%g5, %g4, -4
	mov	%g6, %g2
	addi	%g2, %g2, 8
	setL %g7, print_int_print_digits.2656
	st	%g7, %g6, 0
	st	%g5, %g6, -4
	mov	%g5, %g2
	addi	%g2, %g2, 16
	setL %g7, print_int.2658
	st	%g7, %g5, 0
	st	%g3, %g5, -12
	st	%g6, %g5, -8
	st	%g4, %g5, -4
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g5, %g1, 28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_create_array
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 32
	mov	%g3, %g4
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_create_float_array
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 60
	mvhi	%g5, 0
	mvlo	%g5, 0
	mvhi	%g6, 0
	mvlo	%g6, 0
	mvhi	%g7, 0
	mvlo	%g7, 0
	mvhi	%g8, 0
	mvlo	%g8, 0
	mvhi	%g9, 0
	mvlo	%g9, 0
	mov	%g10, %g2
	addi	%g2, %g2, 48
	st	%g3, %g10, -40
	st	%g3, %g10, -36
	st	%g3, %g10, -32
	st	%g3, %g10, -28
	st	%g9, %g10, -24
	st	%g3, %g10, -20
	st	%g3, %g10, -16
	st	%g8, %g10, -12
	st	%g7, %g10, -8
	st	%g6, %g10, -4
	st	%g5, %g10, 0
	mov	%g3, %g10
	mov	%g28, %g4
	mov	%g4, %g3
	mov	%g3, %g28
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	min_caml_create_array
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 36
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 40
	mov	%g3, %g4
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	min_caml_create_float_array
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 44
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	min_caml_create_float_array
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 1
	setL %g5, l.7172
	fld	%f0, %g5, 0
	st	%g3, %g1, 48
	mov	%g3, %g4
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	min_caml_create_float_array
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 50
	mvhi	%g5, 0
	mvlo	%g5, 1
	mvhi	%g6, 65535
	mvlo	%g6, -1
	st	%g3, %g1, 52
	st	%g4, %g1, 56
	mov	%g4, %g6
	mov	%g3, %g5
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	min_caml_create_array
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g3
	ld	%g3, %g1, 56
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	min_caml_create_array
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 1
	ld	%g6, %g3, 0
	st	%g3, %g1, 60
	st	%g4, %g1, 64
	mov	%g4, %g6
	mov	%g3, %g5
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	min_caml_create_array
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mov	%g4, %g3
	ld	%g3, %g1, 64
	st	%g31, %g1, 68
	subi	%g1, %g1, 72
	call	min_caml_create_array
	addi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 1
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 68
	mov	%g3, %g4
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	min_caml_create_float_array
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 72
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 76
	subi	%g1, %g1, 80
	call	min_caml_create_array
	addi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 0
	mvlo	%g4, 1
	setL %g5, l.7070
	fld	%f0, %g5, 0
	st	%g3, %g1, 76
	mov	%g3, %g4
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	min_caml_create_float_array
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 80
	mov	%g3, %g4
	st	%g31, %g1, 84
	subi	%g1, %g1, 88
	call	min_caml_create_float_array
	addi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 84
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	min_caml_create_array
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 88
	mov	%g3, %g4
	st	%g31, %g1, 92
	subi	%g1, %g1, 96
	call	min_caml_create_float_array
	addi	%g1, %g1, 96
	ld	%g31, %g1, 92
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 92
	mov	%g3, %g4
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	min_caml_create_float_array
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 96
	mov	%g3, %g4
	st	%g31, %g1, 100
	subi	%g1, %g1, 104
	call	min_caml_create_float_array
	addi	%g1, %g1, 104
	ld	%g31, %g1, 100
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 100
	mov	%g3, %g4
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	min_caml_create_float_array
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	mvhi	%g4, 0
	mvlo	%g4, 2
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 104
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 108
	subi	%g1, %g1, 112
	call	min_caml_create_array
	addi	%g1, %g1, 112
	ld	%g31, %g1, 108
	mvhi	%g4, 0
	mvlo	%g4, 2
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 108
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	min_caml_create_array
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	mvhi	%g4, 0
	mvlo	%g4, 1
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 112
	mov	%g3, %g4
	st	%g31, %g1, 116
	subi	%g1, %g1, 120
	call	min_caml_create_float_array
	addi	%g1, %g1, 120
	ld	%g31, %g1, 116
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 116
	mov	%g3, %g4
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	min_caml_create_float_array
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 120
	mov	%g3, %g4
	st	%g31, %g1, 124
	subi	%g1, %g1, 128
	call	min_caml_create_float_array
	addi	%g1, %g1, 128
	ld	%g31, %g1, 124
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 124
	mov	%g3, %g4
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	min_caml_create_float_array
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 128
	mov	%g3, %g4
	st	%g31, %g1, 132
	subi	%g1, %g1, 136
	call	min_caml_create_float_array
	addi	%g1, %g1, 136
	ld	%g31, %g1, 132
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 132
	mov	%g3, %g4
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	min_caml_create_float_array
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 136
	mov	%g3, %g4
	st	%g31, %g1, 140
	subi	%g1, %g1, 144
	call	min_caml_create_float_array
	addi	%g1, %g1, 144
	ld	%g31, %g1, 140
	mvhi	%g4, 0
	mvlo	%g4, 0
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 140
	mov	%g3, %g4
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	min_caml_create_float_array
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 0
	st	%g4, %g1, 144
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	min_caml_create_array
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	mvhi	%g4, 0
	mvlo	%g4, 0
	mov	%g5, %g2
	addi	%g2, %g2, 8
	st	%g3, %g5, -4
	ld	%g3, %g1, 144
	st	%g3, %g5, 0
	mov	%g3, %g5
	mov	%g28, %g4
	mov	%g4, %g3
	mov	%g3, %g28
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	min_caml_create_array
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 5
	st	%g31, %g1, 148
	subi	%g1, %g1, 152
	call	min_caml_create_array
	addi	%g1, %g1, 152
	ld	%g31, %g1, 148
	mvhi	%g4, 0
	mvlo	%g4, 0
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 148
	mov	%g3, %g4
	st	%g31, %g1, 156
	subi	%g1, %g1, 160
	call	min_caml_create_float_array
	addi	%g1, %g1, 160
	ld	%g31, %g1, 156
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 152
	mov	%g3, %g4
	st	%g31, %g1, 156
	subi	%g1, %g1, 160
	call	min_caml_create_float_array
	addi	%g1, %g1, 160
	ld	%g31, %g1, 156
	mvhi	%g4, 0
	mvlo	%g4, 60
	ld	%g5, %g1, 152
	st	%g3, %g1, 156
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 164
	subi	%g1, %g1, 168
	call	min_caml_create_array
	addi	%g1, %g1, 168
	ld	%g31, %g1, 164
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 156
	st	%g3, %g4, 0
	mov	%g3, %g4
	mvhi	%g4, 0
	mvlo	%g4, 0
	setL %g5, l.6407
	fld	%f0, %g5, 0
	st	%g3, %g1, 160
	mov	%g3, %g4
	st	%g31, %g1, 164
	subi	%g1, %g1, 168
	call	min_caml_create_float_array
	addi	%g1, %g1, 168
	ld	%g31, %g1, 164
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 0
	st	%g4, %g1, 164
	st	%g31, %g1, 172
	subi	%g1, %g1, 176
	call	min_caml_create_array
	addi	%g1, %g1, 176
	ld	%g31, %g1, 172
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, -4
	ld	%g3, %g1, 164
	st	%g3, %g4, 0
	mov	%g3, %g4
	mvhi	%g4, 0
	mvlo	%g4, 180
	mvhi	%g5, 0
	mvlo	%g5, 0
	setL %g6, l.6407
	fld	%f0, %g6, 0
	mov	%g6, %g2
	addi	%g2, %g2, 16
	fst	%f0, %g6, -8
	st	%g3, %g6, -4
	st	%g5, %g6, 0
	mov	%g3, %g6
	mov	%g28, %g4
	mov	%g4, %g3
	mov	%g3, %g28
	st	%g31, %g1, 172
	subi	%g1, %g1, 176
	call	min_caml_create_array
	addi	%g1, %g1, 176
	ld	%g31, %g1, 172
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 168
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 172
	subi	%g1, %g1, 176
	call	min_caml_create_array
	addi	%g1, %g1, 176
	ld	%g31, %g1, 172
	mov	%g4, %g2
	addi	%g2, %g2, 32
	setL %g5, read_screen_settings.2820
	st	%g5, %g4, 0
	ld	%g5, %g1, 44
	st	%g5, %g4, -24
	ld	%g6, %g1, 136
	st	%g6, %g4, -20
	ld	%g7, %g1, 132
	st	%g7, %g4, -16
	ld	%g8, %g1, 128
	st	%g8, %g4, -12
	ld	%g9, %g1, 40
	st	%g9, %g4, -8
	ld	%g9, %g1, 20
	st	%g9, %g4, -4
	mov	%g10, %g2
	addi	%g2, %g2, 24
	setL %g11, read_light.2822
	st	%g11, %g10, 0
	ld	%g11, %g1, 4
	st	%g11, %g10, -16
	st	%g9, %g10, -12
	ld	%g12, %g1, 48
	st	%g12, %g10, -8
	ld	%g13, %g1, 52
	st	%g13, %g10, -4
	mov	%g14, %g2
	addi	%g2, %g2, 16
	setL %g15, read_nth_object.2827
	st	%g15, %g14, 0
	st	%g11, %g14, -12
	st	%g9, %g14, -8
	ld	%g9, %g1, 36
	st	%g9, %g14, -4
	mov	%g15, %g2
	addi	%g2, %g2, 16
	setL %g16, read_object.2829
	st	%g16, %g15, 0
	st	%g14, %g15, -8
	ld	%g14, %g1, 32
	st	%g14, %g15, -4
	mov	%g16, %g2
	addi	%g2, %g2, 8
	setL %g17, read_all_object.2831
	st	%g17, %g16, 0
	st	%g15, %g16, -4
	mov	%g15, %g2
	addi	%g2, %g2, 8
	setL %g17, read_net_item.2833
	st	%g17, %g15, 0
	st	%g11, %g15, -4
	mov	%g11, %g2
	addi	%g2, %g2, 8
	setL %g17, read_or_network.2835
	st	%g17, %g11, 0
	st	%g15, %g11, -4
	mov	%g17, %g2
	addi	%g2, %g2, 16
	setL %g18, read_and_network.2837
	st	%g18, %g17, 0
	st	%g15, %g17, -8
	ld	%g15, %g1, 60
	st	%g15, %g17, -4
	mov	%g18, %g2
	addi	%g2, %g2, 32
	setL %g19, read_parameter.2839
	st	%g19, %g18, 0
	st	%g4, %g18, -24
	st	%g11, %g18, -20
	st	%g10, %g18, -16
	st	%g17, %g18, -12
	st	%g16, %g18, -8
	ld	%g4, %g1, 68
	st	%g4, %g18, -4
	mov	%g10, %g2
	addi	%g2, %g2, 8
	setL %g11, solver_rect_surface.2841
	st	%g11, %g10, 0
	ld	%g11, %g1, 72
	st	%g11, %g10, -4
	mov	%g16, %g2
	addi	%g2, %g2, 8
	setL %g17, solver_rect.2850
	st	%g17, %g16, 0
	st	%g10, %g16, -4
	mov	%g10, %g2
	addi	%g2, %g2, 8
	setL %g17, solver_surface.2856
	st	%g17, %g10, 0
	st	%g11, %g10, -4
	mov	%g17, %g2
	addi	%g2, %g2, 8
	setL %g19, solver_second.2875
	st	%g19, %g17, 0
	st	%g11, %g17, -4
	mov	%g19, %g2
	addi	%g2, %g2, 24
	setL %g20, solver.2881
	st	%g20, %g19, 0
	st	%g10, %g19, -16
	st	%g17, %g19, -12
	st	%g16, %g19, -8
	st	%g9, %g19, -4
	mov	%g10, %g2
	addi	%g2, %g2, 8
	setL %g16, solver_rect_fast.2885
	st	%g16, %g10, 0
	st	%g11, %g10, -4
	mov	%g16, %g2
	addi	%g2, %g2, 8
	setL %g17, solver_surface_fast.2892
	st	%g17, %g16, 0
	st	%g11, %g16, -4
	mov	%g17, %g2
	addi	%g2, %g2, 8
	setL %g20, solver_second_fast.2898
	st	%g20, %g17, 0
	st	%g11, %g17, -4
	mov	%g20, %g2
	addi	%g2, %g2, 24
	setL %g21, solver_fast.2904
	st	%g21, %g20, 0
	st	%g16, %g20, -16
	st	%g17, %g20, -12
	st	%g10, %g20, -8
	st	%g9, %g20, -4
	mov	%g16, %g2
	addi	%g2, %g2, 8
	setL %g17, solver_surface_fast2.2908
	st	%g17, %g16, 0
	st	%g11, %g16, -4
	mov	%g17, %g2
	addi	%g2, %g2, 8
	setL %g21, solver_second_fast2.2915
	st	%g21, %g17, 0
	st	%g11, %g17, -4
	mov	%g21, %g2
	addi	%g2, %g2, 24
	setL %g22, solver_fast2.2922
	st	%g22, %g21, 0
	st	%g16, %g21, -16
	st	%g17, %g21, -12
	st	%g10, %g21, -8
	st	%g9, %g21, -4
	mov	%g10, %g2
	addi	%g2, %g2, 8
	setL %g16, iter_setup_dirvec_constants.2934
	st	%g16, %g10, 0
	st	%g9, %g10, -4
	mov	%g16, %g2
	addi	%g2, %g2, 16
	setL %g17, setup_dirvec_constants.2937
	st	%g17, %g16, 0
	st	%g14, %g16, -8
	st	%g10, %g16, -4
	mov	%g10, %g2
	addi	%g2, %g2, 8
	setL %g17, setup_startp_constants.2939
	st	%g17, %g10, 0
	st	%g9, %g10, -4
	mov	%g17, %g2
	addi	%g2, %g2, 16
	setL %g22, setup_startp.2942
	st	%g22, %g17, 0
	ld	%g22, %g1, 124
	st	%g22, %g17, -12
	st	%g10, %g17, -8
	st	%g14, %g17, -4
	mov	%g10, %g2
	addi	%g2, %g2, 8
	setL %g23, check_all_inside.2964
	st	%g23, %g10, 0
	st	%g9, %g10, -4
	mov	%g23, %g2
	addi	%g2, %g2, 32
	setL %g24, shadow_check_and_group.2970
	st	%g24, %g23, 0
	st	%g20, %g23, -28
	st	%g11, %g23, -24
	st	%g9, %g23, -20
	ld	%g24, %g1, 160
	st	%g24, %g23, -16
	st	%g12, %g23, -12
	ld	%g25, %g1, 84
	st	%g25, %g23, -8
	st	%g10, %g23, -4
	mov	%g26, %g2
	addi	%g2, %g2, 16
	setL %g27, shadow_check_one_or_group.2973
	st	%g27, %g26, 0
	st	%g23, %g26, -8
	st	%g15, %g26, -4
	mov	%g23, %g2
	addi	%g2, %g2, 24
	setL %g27, shadow_check_one_or_matrix.2976
	st	%g27, %g23, 0
	st	%g20, %g23, -20
	st	%g11, %g23, -16
	st	%g26, %g23, -12
	st	%g24, %g23, -8
	st	%g25, %g23, -4
	mov	%g20, %g2
	addi	%g2, %g2, 40
	setL %g26, solve_each_element.2979
	st	%g26, %g20, 0
	ld	%g26, %g1, 80
	st	%g26, %g20, -36
	ld	%g27, %g1, 120
	st	%g27, %g20, -32
	st	%g11, %g20, -28
	st	%g19, %g20, -24
	st	%g9, %g20, -20
	ld	%g28, %g1, 76
	st	%g28, %g20, -16
	st	%g25, %g20, -12
	ld	%g29, %g1, 88
	st	%g29, %g20, -8
	st	%g10, %g20, -4
	mov	%g24, %g2
	addi	%g2, %g2, 16
	st	%g18, %g1, 172
	setL %g18, solve_one_or_network.2983
	st	%g18, %g24, 0
	st	%g20, %g24, -8
	st	%g15, %g24, -4
	mov	%g18, %g2
	addi	%g2, %g2, 24
	setL %g20, trace_or_matrix.2987
	st	%g20, %g18, 0
	st	%g26, %g18, -20
	st	%g27, %g18, -16
	st	%g11, %g18, -12
	st	%g19, %g18, -8
	st	%g24, %g18, -4
	mov	%g19, %g2
	addi	%g2, %g2, 16
	setL %g20, judge_intersection.2991
	st	%g20, %g19, 0
	st	%g18, %g19, -12
	st	%g26, %g19, -8
	st	%g4, %g19, -4
	mov	%g18, %g2
	addi	%g2, %g2, 40
	setL %g20, solve_each_element_fast.2993
	st	%g20, %g18, 0
	st	%g26, %g18, -36
	st	%g22, %g18, -32
	st	%g21, %g18, -28
	st	%g11, %g18, -24
	st	%g9, %g18, -20
	st	%g28, %g18, -16
	st	%g25, %g18, -12
	st	%g29, %g18, -8
	st	%g10, %g18, -4
	mov	%g10, %g2
	addi	%g2, %g2, 16
	setL %g20, solve_one_or_network_fast.2997
	st	%g20, %g10, 0
	st	%g18, %g10, -8
	st	%g15, %g10, -4
	mov	%g15, %g2
	addi	%g2, %g2, 24
	setL %g18, trace_or_matrix_fast.3001
	st	%g18, %g15, 0
	st	%g26, %g15, -16
	st	%g21, %g15, -12
	st	%g11, %g15, -8
	st	%g10, %g15, -4
	mov	%g10, %g2
	addi	%g2, %g2, 16
	setL %g11, judge_intersection_fast.3005
	st	%g11, %g10, 0
	st	%g15, %g10, -12
	st	%g26, %g10, -8
	st	%g4, %g10, -4
	mov	%g11, %g2
	addi	%g2, %g2, 16
	setL %g15, get_nvector_rect.3007
	st	%g15, %g11, 0
	ld	%g15, %g1, 92
	st	%g15, %g11, -8
	st	%g28, %g11, -4
	mov	%g18, %g2
	addi	%g2, %g2, 8
	setL %g20, get_nvector_plane.3009
	st	%g20, %g18, 0
	st	%g15, %g18, -4
	mov	%g20, %g2
	addi	%g2, %g2, 16
	setL %g21, get_nvector_second.3011
	st	%g21, %g20, 0
	st	%g15, %g20, -8
	st	%g25, %g20, -4
	mov	%g21, %g2
	addi	%g2, %g2, 16
	setL %g22, get_nvector.3013
	st	%g22, %g21, 0
	st	%g20, %g21, -12
	st	%g11, %g21, -8
	st	%g18, %g21, -4
	mov	%g11, %g2
	addi	%g2, %g2, 8
	setL %g18, utexture.3016
	st	%g18, %g11, 0
	ld	%g18, %g1, 96
	st	%g18, %g11, -4
	mov	%g20, %g2
	addi	%g2, %g2, 16
	setL %g22, add_light.3019
	st	%g22, %g20, 0
	st	%g18, %g20, -8
	ld	%g22, %g1, 104
	st	%g22, %g20, -4
	mov	%g24, %g2
	addi	%g2, %g2, 40
	st	%g16, %g1, 176
	setL %g16, trace_reflections.3023
	st	%g16, %g24, 0
	st	%g23, %g24, -32
	ld	%g16, %g1, 168
	st	%g16, %g24, -28
	st	%g4, %g24, -24
	st	%g15, %g24, -20
	st	%g10, %g24, -16
	st	%g28, %g24, -12
	st	%g29, %g24, -8
	st	%g20, %g24, -4
	mov	%g16, %g2
	addi	%g2, %g2, 88
	setL %g14, trace_ray.3028
	st	%g14, %g16, 0
	st	%g11, %g16, -80
	st	%g24, %g16, -76
	st	%g26, %g16, -72
	st	%g18, %g16, -68
	st	%g27, %g16, -64
	st	%g23, %g16, -60
	st	%g17, %g16, -56
	st	%g22, %g16, -52
	st	%g4, %g16, -48
	st	%g9, %g16, -44
	st	%g15, %g16, -40
	st	%g3, %g16, -36
	st	%g12, %g16, -32
	st	%g19, %g16, -28
	st	%g28, %g16, -24
	st	%g25, %g16, -20
	st	%g29, %g16, -16
	st	%g21, %g16, -12
	st	%g13, %g16, -8
	st	%g20, %g16, -4
	mov	%g13, %g2
	addi	%g2, %g2, 56
	setL %g14, trace_diffuse_ray.3034
	st	%g14, %g13, 0
	st	%g11, %g13, -48
	st	%g18, %g13, -44
	st	%g23, %g13, -40
	st	%g4, %g13, -36
	st	%g9, %g13, -32
	st	%g15, %g13, -28
	st	%g12, %g13, -24
	st	%g10, %g13, -20
	st	%g25, %g13, -16
	st	%g29, %g13, -12
	st	%g21, %g13, -8
	ld	%g4, %g1, 100
	st	%g4, %g13, -4
	mov	%g10, %g2
	addi	%g2, %g2, 8
	setL %g11, iter_trace_diffuse_rays.3037
	st	%g11, %g10, 0
	st	%g13, %g10, -4
	mov	%g11, %g2
	addi	%g2, %g2, 16
	setL %g13, trace_diffuse_rays.3042
	st	%g13, %g11, 0
	st	%g17, %g11, -8
	st	%g10, %g11, -4
	mov	%g10, %g2
	addi	%g2, %g2, 16
	setL %g13, trace_diffuse_ray_80percent.3046
	st	%g13, %g10, 0
	st	%g11, %g10, -8
	ld	%g13, %g1, 148
	st	%g13, %g10, -4
	mov	%g14, %g2
	addi	%g2, %g2, 16
	setL %g15, calc_diffuse_using_1point.3050
	st	%g15, %g14, 0
	st	%g10, %g14, -12
	st	%g22, %g14, -8
	st	%g4, %g14, -4
	mov	%g10, %g2
	addi	%g2, %g2, 16
	setL %g15, calc_diffuse_using_5points.3053
	st	%g15, %g10, 0
	st	%g22, %g10, -8
	st	%g4, %g10, -4
	mov	%g15, %g2
	addi	%g2, %g2, 8
	setL %g17, do_without_neighbors.3059
	st	%g17, %g15, 0
	st	%g14, %g15, -4
	mov	%g14, %g2
	addi	%g2, %g2, 8
	setL %g17, neighbors_exist.3062
	st	%g17, %g14, 0
	ld	%g17, %g1, 108
	st	%g17, %g14, -4
	mov	%g18, %g2
	addi	%g2, %g2, 16
	setL %g19, try_exploit_neighbors.3075
	st	%g19, %g18, 0
	st	%g15, %g18, -8
	st	%g10, %g18, -4
	mov	%g10, %g2
	addi	%g2, %g2, 16
	setL %g19, write_ppm_header.3082
	st	%g19, %g10, 0
	ld	%g19, %g1, 28
	st	%g19, %g10, -8
	st	%g17, %g10, -4
	mov	%g20, %g2
	addi	%g2, %g2, 8
	setL %g21, write_rgb_element.3084
	st	%g21, %g20, 0
	st	%g19, %g20, -4
	mov	%g19, %g2
	addi	%g2, %g2, 16
	setL %g21, write_rgb.3086
	st	%g21, %g19, 0
	st	%g20, %g19, -8
	st	%g22, %g19, -4
	mov	%g20, %g2
	addi	%g2, %g2, 16
	setL %g21, pretrace_diffuse_rays.3088
	st	%g21, %g20, 0
	st	%g11, %g20, -12
	st	%g13, %g20, -8
	st	%g4, %g20, -4
	mov	%g4, %g2
	addi	%g2, %g2, 40
	setL %g11, pretrace_pixels.3091
	st	%g11, %g4, 0
	st	%g5, %g4, -36
	st	%g16, %g4, -32
	st	%g27, %g4, -28
	st	%g8, %g4, -24
	ld	%g5, %g1, 116
	st	%g5, %g4, -20
	st	%g22, %g4, -16
	ld	%g8, %g1, 140
	st	%g8, %g4, -12
	st	%g20, %g4, -8
	ld	%g8, %g1, 112
	st	%g8, %g4, -4
	mov	%g11, %g2
	addi	%g2, %g2, 32
	setL %g16, pretrace_line.3098
	st	%g16, %g11, 0
	st	%g6, %g11, -24
	st	%g7, %g11, -20
	st	%g5, %g11, -16
	st	%g4, %g11, -12
	st	%g17, %g11, -8
	st	%g8, %g11, -4
	mov	%g4, %g2
	addi	%g2, %g2, 32
	setL %g6, scan_pixel.3102
	st	%g6, %g4, 0
	st	%g19, %g4, -24
	st	%g18, %g4, -20
	st	%g22, %g4, -16
	st	%g14, %g4, -12
	st	%g17, %g4, -8
	st	%g15, %g4, -4
	mov	%g6, %g2
	addi	%g2, %g2, 16
	setL %g7, scan_line.3108
	st	%g7, %g6, 0
	st	%g4, %g6, -12
	st	%g11, %g6, -8
	st	%g17, %g6, -4
	mov	%g4, %g2
	addi	%g2, %g2, 8
	setL %g7, create_pixelline.3121
	st	%g7, %g4, 0
	st	%g17, %g4, -4
	mov	%g7, %g2
	addi	%g2, %g2, 8
	setL %g14, calc_dirvec.3128
	st	%g14, %g7, 0
	st	%g13, %g7, -4
	mov	%g14, %g2
	addi	%g2, %g2, 8
	setL %g15, calc_dirvecs.3136
	st	%g15, %g14, 0
	st	%g7, %g14, -4
	mov	%g7, %g2
	addi	%g2, %g2, 8
	setL %g15, calc_dirvec_rows.3141
	st	%g15, %g7, 0
	st	%g14, %g7, -4
	mov	%g14, %g2
	addi	%g2, %g2, 8
	setL %g15, create_dirvec.3145
	st	%g15, %g14, 0
	ld	%g15, %g1, 32
	st	%g15, %g14, -4
	mov	%g16, %g2
	addi	%g2, %g2, 8
	setL %g18, create_dirvec_elements.3147
	st	%g18, %g16, 0
	st	%g14, %g16, -4
	mov	%g18, %g2
	addi	%g2, %g2, 16
	setL %g19, create_dirvecs.3150
	st	%g19, %g18, 0
	st	%g13, %g18, -12
	st	%g16, %g18, -8
	st	%g14, %g18, -4
	mov	%g16, %g2
	addi	%g2, %g2, 8
	setL %g19, init_dirvec_constants.3152
	st	%g19, %g16, 0
	ld	%g19, %g1, 176
	st	%g19, %g16, -4
	mov	%g20, %g2
	addi	%g2, %g2, 16
	setL %g21, init_vecset_constants.3155
	st	%g21, %g20, 0
	st	%g16, %g20, -8
	st	%g13, %g20, -4
	mov	%g13, %g2
	addi	%g2, %g2, 16
	setL %g16, init_dirvecs.3157
	st	%g16, %g13, 0
	st	%g20, %g13, -12
	st	%g18, %g13, -8
	st	%g7, %g13, -4
	mov	%g7, %g2
	addi	%g2, %g2, 16
	setL %g16, add_reflection.3159
	st	%g16, %g7, 0
	st	%g19, %g7, -12
	ld	%g16, %g1, 168
	st	%g16, %g7, -8
	st	%g14, %g7, -4
	mov	%g14, %g2
	addi	%g2, %g2, 16
	setL %g16, setup_rect_reflection.3166
	st	%g16, %g14, 0
	st	%g3, %g14, -12
	st	%g12, %g14, -8
	st	%g7, %g14, -4
	mov	%g16, %g2
	addi	%g2, %g2, 16
	setL %g18, setup_surface_reflection.3169
	st	%g18, %g16, 0
	st	%g3, %g16, -12
	st	%g12, %g16, -8
	st	%g7, %g16, -4
	mov	%g3, %g2
	addi	%g2, %g2, 16
	setL %g7, setup_reflections.3172
	st	%g7, %g3, 0
	st	%g16, %g3, -12
	st	%g14, %g3, -8
	st	%g9, %g3, -4
	mov	%g29, %g2
	addi	%g2, %g2, 64
	setL %g7, rt.3174
	st	%g7, %g29, 0
	st	%g10, %g29, -56
	st	%g3, %g29, -52
	st	%g19, %g29, -48
	st	%g5, %g29, -44
	st	%g6, %g29, -40
	ld	%g3, %g1, 172
	st	%g3, %g29, -36
	st	%g11, %g29, -32
	st	%g15, %g29, -28
	ld	%g3, %g1, 160
	st	%g3, %g29, -24
	st	%g12, %g29, -20
	st	%g13, %g29, -16
	st	%g17, %g29, -12
	st	%g8, %g29, -8
	st	%g4, %g29, -4
	mvhi	%g3, 0
	mvlo	%g3, 128
	mvhi	%g4, 0
	mvlo	%g4, 128
	st	%g31, %g1, 180
	ld	%g28, %g29, 0
	subi	%g1, %g1, 184
	callR	%g28
	addi	%g1, %g1, 184
	ld	%g31, %g1, 180
	mvhi	%g0, 0
	mvlo	%g0, 0
	halt
