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
l.3093:	! 12.000000
	.long	0x41400000
l.3088:	! 11.000000
	.long	0x41300000
l.3083:	! 10.000000
	.long	0x41200000
l.3078:	! 9.000000
	.long	0x41100000
l.3073:	! 8.000000
	.long	0x41000000
l.3068:	! 7.000000
	.long	0x40e00000
l.3063:	! 6.000000
	.long	0x40c00000
l.3058:	! 5.000000
	.long	0x40a00000
l.3053:	! 4.000000
	.long	0x40800000
l.3048:	! 3.000000
	.long	0x40400000
l.3040:	! 1.000000
	.long	0x3f800000
l.3029:	! 0.000000
	.long	0x0
l.3027:	! 2.000000
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
div_binary_search.462:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.3483
	mov	%g3, %g5
	return
jle_else.3483:
	jlt	%g8, %g3, jle_else.3484
	jne	%g8, %g3, jeq_else.3485
	mov	%g3, %g7
	return
jeq_else.3485:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.3486
	mov	%g3, %g5
	return
jle_else.3486:
	jlt	%g8, %g3, jle_else.3487
	jne	%g8, %g3, jeq_else.3488
	mov	%g3, %g6
	return
jeq_else.3488:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.3489
	mov	%g3, %g5
	return
jle_else.3489:
	jlt	%g8, %g3, jle_else.3490
	jne	%g8, %g3, jeq_else.3491
	mov	%g3, %g7
	return
jeq_else.3491:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.3492
	mov	%g3, %g5
	return
jle_else.3492:
	jlt	%g8, %g3, jle_else.3493
	jne	%g8, %g3, jeq_else.3494
	mov	%g3, %g6
	return
jeq_else.3494:
	jmp	div_binary_search.462
jle_else.3493:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.462
jle_else.3490:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.3495
	mov	%g3, %g7
	return
jle_else.3495:
	jlt	%g8, %g3, jle_else.3496
	jne	%g8, %g3, jeq_else.3497
	mov	%g3, %g5
	return
jeq_else.3497:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.462
jle_else.3496:
	jmp	div_binary_search.462
jle_else.3487:
	add	%g5, %g6, %g7
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g7, %g6
	jlt	%g28, %g9, jle_else.3498
	mov	%g3, %g6
	return
jle_else.3498:
	jlt	%g8, %g3, jle_else.3499
	jne	%g8, %g3, jeq_else.3500
	mov	%g3, %g5
	return
jeq_else.3500:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.3501
	mov	%g3, %g6
	return
jle_else.3501:
	jlt	%g8, %g3, jle_else.3502
	jne	%g8, %g3, jeq_else.3503
	mov	%g3, %g7
	return
jeq_else.3503:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.462
jle_else.3502:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.462
jle_else.3499:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.3504
	mov	%g3, %g5
	return
jle_else.3504:
	jlt	%g8, %g3, jle_else.3505
	jne	%g8, %g3, jeq_else.3506
	mov	%g3, %g6
	return
jeq_else.3506:
	jmp	div_binary_search.462
jle_else.3505:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.462
jle_else.3484:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.3507
	mov	%g3, %g7
	return
jle_else.3507:
	jlt	%g8, %g3, jle_else.3508
	jne	%g8, %g3, jeq_else.3509
	mov	%g3, %g5
	return
jeq_else.3509:
	add	%g6, %g7, %g5
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g5, %g7
	jlt	%g28, %g9, jle_else.3510
	mov	%g3, %g7
	return
jle_else.3510:
	jlt	%g8, %g3, jle_else.3511
	jne	%g8, %g3, jeq_else.3512
	mov	%g3, %g6
	return
jeq_else.3512:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.3513
	mov	%g3, %g7
	return
jle_else.3513:
	jlt	%g8, %g3, jle_else.3514
	jne	%g8, %g3, jeq_else.3515
	mov	%g3, %g5
	return
jeq_else.3515:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.462
jle_else.3514:
	jmp	div_binary_search.462
jle_else.3511:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.3516
	mov	%g3, %g6
	return
jle_else.3516:
	jlt	%g8, %g3, jle_else.3517
	jne	%g8, %g3, jeq_else.3518
	mov	%g3, %g7
	return
jeq_else.3518:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.462
jle_else.3517:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.462
jle_else.3508:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.3519
	mov	%g3, %g5
	return
jle_else.3519:
	jlt	%g8, %g3, jle_else.3520
	jne	%g8, %g3, jeq_else.3521
	mov	%g3, %g7
	return
jeq_else.3521:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.3522
	mov	%g3, %g5
	return
jle_else.3522:
	jlt	%g8, %g3, jle_else.3523
	jne	%g8, %g3, jeq_else.3524
	mov	%g3, %g6
	return
jeq_else.3524:
	jmp	div_binary_search.462
jle_else.3523:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.462
jle_else.3520:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.3525
	mov	%g3, %g7
	return
jle_else.3525:
	jlt	%g8, %g3, jle_else.3526
	jne	%g8, %g3, jeq_else.3527
	mov	%g3, %g5
	return
jeq_else.3527:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.462
jle_else.3526:
	jmp	div_binary_search.462
print_int.467:
	jlt	%g3, %g0, jge_else.3528
	mvhi	%g10, 1525
	mvlo	%g10, 57600
	jlt	%g10, %g3, jle_else.3529
	jne	%g10, %g3, jeq_else.3531
	addi	%g10, %g0, 1
	jmp	jeq_cont.3532
jeq_else.3531:
	addi	%g10, %g0, 0
jeq_cont.3532:
	jmp	jle_cont.3530
jle_else.3529:
	mvhi	%g10, 3051
	mvlo	%g10, 49664
	jlt	%g10, %g3, jle_else.3533
	jne	%g10, %g3, jeq_else.3535
	addi	%g10, %g0, 2
	jmp	jeq_cont.3536
jeq_else.3535:
	addi	%g10, %g0, 1
jeq_cont.3536:
	jmp	jle_cont.3534
jle_else.3533:
	addi	%g10, %g0, 2
jle_cont.3534:
jle_cont.3530:
	mvhi	%g11, 1525
	mvlo	%g11, 57600
	mul	%g11, %g10, %g11
	sub	%g3, %g3, %g11
	st	%g3, %g1, 0
	jlt	%g0, %g10, jle_else.3537
	addi	%g3, %g0, 0
	jmp	jle_cont.3538
jle_else.3537:
	addi	%g11, %g0, 48
	add	%g10, %g11, %g10
	output	%g10
	addi	%g3, %g0, 1
jle_cont.3538:
	mvhi	%g4, 152
	mvlo	%g4, 38528
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g10, %g0, 5
	mvhi	%g11, 762
	mvlo	%g11, 61568
	ld	%g12, %g1, 0
	st	%g3, %g1, 4
	jlt	%g11, %g12, jle_else.3539
	jne	%g11, %g12, jeq_else.3541
	addi	%g3, %g0, 5
	jmp	jeq_cont.3542
jeq_else.3541:
	addi	%g6, %g0, 2
	mvhi	%g11, 305
	mvlo	%g11, 11520
	jlt	%g11, %g12, jle_else.3543
	jne	%g11, %g12, jeq_else.3545
	addi	%g3, %g0, 2
	jmp	jeq_cont.3546
jeq_else.3545:
	addi	%g10, %g0, 1
	mvhi	%g11, 152
	mvlo	%g11, 38528
	jlt	%g11, %g12, jle_else.3547
	jne	%g11, %g12, jeq_else.3549
	addi	%g3, %g0, 1
	jmp	jeq_cont.3550
jeq_else.3549:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jeq_cont.3550:
	jmp	jle_cont.3548
jle_else.3547:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jle_cont.3548:
jeq_cont.3546:
	jmp	jle_cont.3544
jle_else.3543:
	addi	%g5, %g0, 3
	mvhi	%g11, 457
	mvlo	%g11, 50048
	jlt	%g11, %g12, jle_else.3551
	jne	%g11, %g12, jeq_else.3553
	addi	%g3, %g0, 3
	jmp	jeq_cont.3554
jeq_else.3553:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jeq_cont.3554:
	jmp	jle_cont.3552
jle_else.3551:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jle_cont.3552:
jle_cont.3544:
jeq_cont.3542:
	jmp	jle_cont.3540
jle_else.3539:
	addi	%g5, %g0, 7
	mvhi	%g11, 1068
	mvlo	%g11, 7552
	jlt	%g11, %g12, jle_else.3555
	jne	%g11, %g12, jeq_else.3557
	addi	%g3, %g0, 7
	jmp	jeq_cont.3558
jeq_else.3557:
	addi	%g6, %g0, 6
	mvhi	%g11, 915
	mvlo	%g11, 34560
	jlt	%g11, %g12, jle_else.3559
	jne	%g11, %g12, jeq_else.3561
	addi	%g3, %g0, 6
	jmp	jeq_cont.3562
jeq_else.3561:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jeq_cont.3562:
	jmp	jle_cont.3560
jle_else.3559:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jle_cont.3560:
jeq_cont.3558:
	jmp	jle_cont.3556
jle_else.3555:
	addi	%g10, %g0, 8
	mvhi	%g11, 1220
	mvlo	%g11, 46080
	jlt	%g11, %g12, jle_else.3563
	jne	%g11, %g12, jeq_else.3565
	addi	%g3, %g0, 8
	jmp	jeq_cont.3566
jeq_else.3565:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jeq_cont.3566:
	jmp	jle_cont.3564
jle_else.3563:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jle_cont.3564:
jle_cont.3556:
jle_cont.3540:
	mvhi	%g10, 152
	mvlo	%g10, 38528
	mul	%g10, %g3, %g10
	sub	%g10, %g12, %g10
	jlt	%g0, %g3, jle_else.3567
	ld	%g11, %g1, 4
	jne	%g11, %g0, jeq_else.3569
	addi	%g3, %g0, 0
	jmp	jeq_cont.3570
jeq_else.3569:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.3570:
	jmp	jle_cont.3568
jle_else.3567:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.3568:
	mvhi	%g4, 15
	mvlo	%g4, 16960
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 76
	mvlo	%g12, 19264
	st	%g3, %g1, 8
	jlt	%g12, %g10, jle_else.3571
	jne	%g12, %g10, jeq_else.3573
	addi	%g3, %g0, 5
	jmp	jeq_cont.3574
jeq_else.3573:
	addi	%g6, %g0, 2
	mvhi	%g12, 30
	mvlo	%g12, 33920
	jlt	%g12, %g10, jle_else.3575
	jne	%g12, %g10, jeq_else.3577
	addi	%g3, %g0, 2
	jmp	jeq_cont.3578
jeq_else.3577:
	addi	%g11, %g0, 1
	mvhi	%g12, 15
	mvlo	%g12, 16960
	jlt	%g12, %g10, jle_else.3579
	jne	%g12, %g10, jeq_else.3581
	addi	%g3, %g0, 1
	jmp	jeq_cont.3582
jeq_else.3581:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jeq_cont.3582:
	jmp	jle_cont.3580
jle_else.3579:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jle_cont.3580:
jeq_cont.3578:
	jmp	jle_cont.3576
jle_else.3575:
	addi	%g5, %g0, 3
	mvhi	%g12, 45
	mvlo	%g12, 50880
	jlt	%g12, %g10, jle_else.3583
	jne	%g12, %g10, jeq_else.3585
	addi	%g3, %g0, 3
	jmp	jeq_cont.3586
jeq_else.3585:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jeq_cont.3586:
	jmp	jle_cont.3584
jle_else.3583:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jle_cont.3584:
jle_cont.3576:
jeq_cont.3574:
	jmp	jle_cont.3572
jle_else.3571:
	addi	%g5, %g0, 7
	mvhi	%g12, 106
	mvlo	%g12, 53184
	jlt	%g12, %g10, jle_else.3587
	jne	%g12, %g10, jeq_else.3589
	addi	%g3, %g0, 7
	jmp	jeq_cont.3590
jeq_else.3589:
	addi	%g6, %g0, 6
	mvhi	%g12, 91
	mvlo	%g12, 36224
	jlt	%g12, %g10, jle_else.3591
	jne	%g12, %g10, jeq_else.3593
	addi	%g3, %g0, 6
	jmp	jeq_cont.3594
jeq_else.3593:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jeq_cont.3594:
	jmp	jle_cont.3592
jle_else.3591:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jle_cont.3592:
jeq_cont.3590:
	jmp	jle_cont.3588
jle_else.3587:
	addi	%g11, %g0, 8
	mvhi	%g12, 122
	mvlo	%g12, 4608
	jlt	%g12, %g10, jle_else.3595
	jne	%g12, %g10, jeq_else.3597
	addi	%g3, %g0, 8
	jmp	jeq_cont.3598
jeq_else.3597:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jeq_cont.3598:
	jmp	jle_cont.3596
jle_else.3595:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jle_cont.3596:
jle_cont.3588:
jle_cont.3572:
	mvhi	%g11, 15
	mvlo	%g11, 16960
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.3599
	ld	%g11, %g1, 8
	jne	%g11, %g0, jeq_else.3601
	addi	%g3, %g0, 0
	jmp	jeq_cont.3602
jeq_else.3601:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.3602:
	jmp	jle_cont.3600
jle_else.3599:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.3600:
	mvhi	%g4, 1
	mvlo	%g4, 34464
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 7
	mvlo	%g12, 41248
	st	%g3, %g1, 12
	jlt	%g12, %g10, jle_else.3603
	jne	%g12, %g10, jeq_else.3605
	addi	%g3, %g0, 5
	jmp	jeq_cont.3606
jeq_else.3605:
	addi	%g6, %g0, 2
	mvhi	%g12, 3
	mvlo	%g12, 3392
	jlt	%g12, %g10, jle_else.3607
	jne	%g12, %g10, jeq_else.3609
	addi	%g3, %g0, 2
	jmp	jeq_cont.3610
jeq_else.3609:
	addi	%g11, %g0, 1
	mvhi	%g12, 1
	mvlo	%g12, 34464
	jlt	%g12, %g10, jle_else.3611
	jne	%g12, %g10, jeq_else.3613
	addi	%g3, %g0, 1
	jmp	jeq_cont.3614
jeq_else.3613:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jeq_cont.3614:
	jmp	jle_cont.3612
jle_else.3611:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jle_cont.3612:
jeq_cont.3610:
	jmp	jle_cont.3608
jle_else.3607:
	addi	%g5, %g0, 3
	mvhi	%g12, 4
	mvlo	%g12, 37856
	jlt	%g12, %g10, jle_else.3615
	jne	%g12, %g10, jeq_else.3617
	addi	%g3, %g0, 3
	jmp	jeq_cont.3618
jeq_else.3617:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jeq_cont.3618:
	jmp	jle_cont.3616
jle_else.3615:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jle_cont.3616:
jle_cont.3608:
jeq_cont.3606:
	jmp	jle_cont.3604
jle_else.3603:
	addi	%g5, %g0, 7
	mvhi	%g12, 10
	mvlo	%g12, 44640
	jlt	%g12, %g10, jle_else.3619
	jne	%g12, %g10, jeq_else.3621
	addi	%g3, %g0, 7
	jmp	jeq_cont.3622
jeq_else.3621:
	addi	%g6, %g0, 6
	mvhi	%g12, 9
	mvlo	%g12, 10176
	jlt	%g12, %g10, jle_else.3623
	jne	%g12, %g10, jeq_else.3625
	addi	%g3, %g0, 6
	jmp	jeq_cont.3626
jeq_else.3625:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jeq_cont.3626:
	jmp	jle_cont.3624
jle_else.3623:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jle_cont.3624:
jeq_cont.3622:
	jmp	jle_cont.3620
jle_else.3619:
	addi	%g11, %g0, 8
	mvhi	%g12, 12
	mvlo	%g12, 13568
	jlt	%g12, %g10, jle_else.3627
	jne	%g12, %g10, jeq_else.3629
	addi	%g3, %g0, 8
	jmp	jeq_cont.3630
jeq_else.3629:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jeq_cont.3630:
	jmp	jle_cont.3628
jle_else.3627:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jle_cont.3628:
jle_cont.3620:
jle_cont.3604:
	mvhi	%g11, 1
	mvlo	%g11, 34464
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.3631
	ld	%g11, %g1, 12
	jne	%g11, %g0, jeq_else.3633
	addi	%g3, %g0, 0
	jmp	jeq_cont.3634
jeq_else.3633:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.3634:
	jmp	jle_cont.3632
jle_else.3631:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.3632:
	addi	%g4, %g0, 10000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 0
	mvlo	%g12, 50000
	st	%g3, %g1, 16
	jlt	%g12, %g10, jle_else.3635
	jne	%g12, %g10, jeq_else.3637
	addi	%g3, %g0, 5
	jmp	jeq_cont.3638
jeq_else.3637:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20000
	jlt	%g12, %g10, jle_else.3639
	jne	%g12, %g10, jeq_else.3641
	addi	%g3, %g0, 2
	jmp	jeq_cont.3642
jeq_else.3641:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10000
	jlt	%g12, %g10, jle_else.3643
	jne	%g12, %g10, jeq_else.3645
	addi	%g3, %g0, 1
	jmp	jeq_cont.3646
jeq_else.3645:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jeq_cont.3646:
	jmp	jle_cont.3644
jle_else.3643:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jle_cont.3644:
jeq_cont.3642:
	jmp	jle_cont.3640
jle_else.3639:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30000
	jlt	%g12, %g10, jle_else.3647
	jne	%g12, %g10, jeq_else.3649
	addi	%g3, %g0, 3
	jmp	jeq_cont.3650
jeq_else.3649:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jeq_cont.3650:
	jmp	jle_cont.3648
jle_else.3647:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jle_cont.3648:
jle_cont.3640:
jeq_cont.3638:
	jmp	jle_cont.3636
jle_else.3635:
	addi	%g5, %g0, 7
	mvhi	%g12, 1
	mvlo	%g12, 4464
	jlt	%g12, %g10, jle_else.3651
	jne	%g12, %g10, jeq_else.3653
	addi	%g3, %g0, 7
	jmp	jeq_cont.3654
jeq_else.3653:
	addi	%g6, %g0, 6
	mvhi	%g12, 0
	mvlo	%g12, 60000
	jlt	%g12, %g10, jle_else.3655
	jne	%g12, %g10, jeq_else.3657
	addi	%g3, %g0, 6
	jmp	jeq_cont.3658
jeq_else.3657:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jeq_cont.3658:
	jmp	jle_cont.3656
jle_else.3655:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jle_cont.3656:
jeq_cont.3654:
	jmp	jle_cont.3652
jle_else.3651:
	addi	%g11, %g0, 8
	mvhi	%g12, 1
	mvlo	%g12, 14464
	jlt	%g12, %g10, jle_else.3659
	jne	%g12, %g10, jeq_else.3661
	addi	%g3, %g0, 8
	jmp	jeq_cont.3662
jeq_else.3661:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jeq_cont.3662:
	jmp	jle_cont.3660
jle_else.3659:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jle_cont.3660:
jle_cont.3652:
jle_cont.3636:
	addi	%g11, %g0, 10000
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.3663
	ld	%g11, %g1, 16
	jne	%g11, %g0, jeq_else.3665
	addi	%g3, %g0, 0
	jmp	jeq_cont.3666
jeq_else.3665:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.3666:
	jmp	jle_cont.3664
jle_else.3663:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.3664:
	addi	%g4, %g0, 1000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 5000
	st	%g3, %g1, 20
	jlt	%g12, %g10, jle_else.3667
	jne	%g12, %g10, jeq_else.3669
	addi	%g3, %g0, 5
	jmp	jeq_cont.3670
jeq_else.3669:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 2000
	jlt	%g12, %g10, jle_else.3671
	jne	%g12, %g10, jeq_else.3673
	addi	%g3, %g0, 2
	jmp	jeq_cont.3674
jeq_else.3673:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 1000
	jlt	%g12, %g10, jle_else.3675
	jne	%g12, %g10, jeq_else.3677
	addi	%g3, %g0, 1
	jmp	jeq_cont.3678
jeq_else.3677:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jeq_cont.3678:
	jmp	jle_cont.3676
jle_else.3675:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jle_cont.3676:
jeq_cont.3674:
	jmp	jle_cont.3672
jle_else.3671:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 3000
	jlt	%g12, %g10, jle_else.3679
	jne	%g12, %g10, jeq_else.3681
	addi	%g3, %g0, 3
	jmp	jeq_cont.3682
jeq_else.3681:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jeq_cont.3682:
	jmp	jle_cont.3680
jle_else.3679:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jle_cont.3680:
jle_cont.3672:
jeq_cont.3670:
	jmp	jle_cont.3668
jle_else.3667:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 7000
	jlt	%g12, %g10, jle_else.3683
	jne	%g12, %g10, jeq_else.3685
	addi	%g3, %g0, 7
	jmp	jeq_cont.3686
jeq_else.3685:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 6000
	jlt	%g12, %g10, jle_else.3687
	jne	%g12, %g10, jeq_else.3689
	addi	%g3, %g0, 6
	jmp	jeq_cont.3690
jeq_else.3689:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jeq_cont.3690:
	jmp	jle_cont.3688
jle_else.3687:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jle_cont.3688:
jeq_cont.3686:
	jmp	jle_cont.3684
jle_else.3683:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 8000
	jlt	%g12, %g10, jle_else.3691
	jne	%g12, %g10, jeq_else.3693
	addi	%g3, %g0, 8
	jmp	jeq_cont.3694
jeq_else.3693:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jeq_cont.3694:
	jmp	jle_cont.3692
jle_else.3691:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jle_cont.3692:
jle_cont.3684:
jle_cont.3668:
	muli	%g11, %g3, 1000
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.3695
	ld	%g11, %g1, 20
	jne	%g11, %g0, jeq_else.3697
	addi	%g3, %g0, 0
	jmp	jeq_cont.3698
jeq_else.3697:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.3698:
	jmp	jle_cont.3696
jle_else.3695:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.3696:
	addi	%g4, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 500
	st	%g3, %g1, 24
	jlt	%g12, %g10, jle_else.3699
	jne	%g12, %g10, jeq_else.3701
	addi	%g3, %g0, 5
	jmp	jeq_cont.3702
jeq_else.3701:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 200
	jlt	%g12, %g10, jle_else.3703
	jne	%g12, %g10, jeq_else.3705
	addi	%g3, %g0, 2
	jmp	jeq_cont.3706
jeq_else.3705:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 100
	jlt	%g12, %g10, jle_else.3707
	jne	%g12, %g10, jeq_else.3709
	addi	%g3, %g0, 1
	jmp	jeq_cont.3710
jeq_else.3709:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jeq_cont.3710:
	jmp	jle_cont.3708
jle_else.3707:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jle_cont.3708:
jeq_cont.3706:
	jmp	jle_cont.3704
jle_else.3703:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 300
	jlt	%g12, %g10, jle_else.3711
	jne	%g12, %g10, jeq_else.3713
	addi	%g3, %g0, 3
	jmp	jeq_cont.3714
jeq_else.3713:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jeq_cont.3714:
	jmp	jle_cont.3712
jle_else.3711:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jle_cont.3712:
jle_cont.3704:
jeq_cont.3702:
	jmp	jle_cont.3700
jle_else.3699:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 700
	jlt	%g12, %g10, jle_else.3715
	jne	%g12, %g10, jeq_else.3717
	addi	%g3, %g0, 7
	jmp	jeq_cont.3718
jeq_else.3717:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 600
	jlt	%g12, %g10, jle_else.3719
	jne	%g12, %g10, jeq_else.3721
	addi	%g3, %g0, 6
	jmp	jeq_cont.3722
jeq_else.3721:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jeq_cont.3722:
	jmp	jle_cont.3720
jle_else.3719:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jle_cont.3720:
jeq_cont.3718:
	jmp	jle_cont.3716
jle_else.3715:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 800
	jlt	%g12, %g10, jle_else.3723
	jne	%g12, %g10, jeq_else.3725
	addi	%g3, %g0, 8
	jmp	jeq_cont.3726
jeq_else.3725:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jeq_cont.3726:
	jmp	jle_cont.3724
jle_else.3723:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jle_cont.3724:
jle_cont.3716:
jle_cont.3700:
	muli	%g11, %g3, 100
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.3727
	ld	%g11, %g1, 24
	jne	%g11, %g0, jeq_else.3729
	addi	%g3, %g0, 0
	jmp	jeq_cont.3730
jeq_else.3729:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.3730:
	jmp	jle_cont.3728
jle_else.3727:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.3728:
	addi	%g4, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 50
	st	%g3, %g1, 28
	jlt	%g12, %g10, jle_else.3731
	jne	%g12, %g10, jeq_else.3733
	addi	%g3, %g0, 5
	jmp	jeq_cont.3734
jeq_else.3733:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20
	jlt	%g12, %g10, jle_else.3735
	jne	%g12, %g10, jeq_else.3737
	addi	%g3, %g0, 2
	jmp	jeq_cont.3738
jeq_else.3737:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10
	jlt	%g12, %g10, jle_else.3739
	jne	%g12, %g10, jeq_else.3741
	addi	%g3, %g0, 1
	jmp	jeq_cont.3742
jeq_else.3741:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.462
	addi	%g1, %g1, 40
jeq_cont.3742:
	jmp	jle_cont.3740
jle_else.3739:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.462
	addi	%g1, %g1, 40
jle_cont.3740:
jeq_cont.3738:
	jmp	jle_cont.3736
jle_else.3735:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30
	jlt	%g12, %g10, jle_else.3743
	jne	%g12, %g10, jeq_else.3745
	addi	%g3, %g0, 3
	jmp	jeq_cont.3746
jeq_else.3745:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.462
	addi	%g1, %g1, 40
jeq_cont.3746:
	jmp	jle_cont.3744
jle_else.3743:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.462
	addi	%g1, %g1, 40
jle_cont.3744:
jle_cont.3736:
jeq_cont.3734:
	jmp	jle_cont.3732
jle_else.3731:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 70
	jlt	%g12, %g10, jle_else.3747
	jne	%g12, %g10, jeq_else.3749
	addi	%g3, %g0, 7
	jmp	jeq_cont.3750
jeq_else.3749:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 60
	jlt	%g12, %g10, jle_else.3751
	jne	%g12, %g10, jeq_else.3753
	addi	%g3, %g0, 6
	jmp	jeq_cont.3754
jeq_else.3753:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.462
	addi	%g1, %g1, 40
jeq_cont.3754:
	jmp	jle_cont.3752
jle_else.3751:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.462
	addi	%g1, %g1, 40
jle_cont.3752:
jeq_cont.3750:
	jmp	jle_cont.3748
jle_else.3747:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 80
	jlt	%g12, %g10, jle_else.3755
	jne	%g12, %g10, jeq_else.3757
	addi	%g3, %g0, 8
	jmp	jeq_cont.3758
jeq_else.3757:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.462
	addi	%g1, %g1, 40
jeq_cont.3758:
	jmp	jle_cont.3756
jle_else.3755:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.462
	addi	%g1, %g1, 40
jle_cont.3756:
jle_cont.3748:
jle_cont.3732:
	muli	%g11, %g3, 10
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.3759
	ld	%g11, %g1, 28
	jne	%g11, %g0, jeq_else.3761
	addi	%g3, %g0, 0
	jmp	jeq_cont.3762
jeq_else.3761:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.3762:
	jmp	jle_cont.3760
jle_else.3759:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.3760:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g10
	output	%g3
	return
jge_else.3528:
	addi	%g10, %g0, 45
	st	%g3, %g1, 32
	output	%g10
	ld	%g3, %g1, 32
	sub	%g3, %g0, %g3
	jmp	print_int.467
loop3.469:
	jlt	%g4, %g0, jge_else.3763
	slli	%g9, %g3, 2
	add	%g26, %g8, %g9
	ld	%g9, %g26, 0
	slli	%g10, %g5, 2
	add	%g26, %g9, %g10
	fld	%f0, %g26, 0
	slli	%g10, %g3, 2
	add	%g26, %g6, %g10
	ld	%g10, %g26, 0
	slli	%g11, %g4, 2
	add	%g26, %g10, %g11
	fld	%f1, %g26, 0
	slli	%g10, %g4, 2
	add	%g26, %g7, %g10
	ld	%g10, %g26, 0
	slli	%g11, %g5, 2
	add	%g26, %g10, %g11
	fld	%f2, %g26, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	slli	%g10, %g5, 2
	add	%g26, %g9, %g10
	fst	%f0, %g26, 0
	subi	%g4, %g4, 1
	jlt	%g4, %g0, jge_else.3764
	slli	%g9, %g3, 2
	add	%g26, %g8, %g9
	ld	%g9, %g26, 0
	slli	%g10, %g5, 2
	add	%g26, %g9, %g10
	fld	%f0, %g26, 0
	slli	%g10, %g3, 2
	add	%g26, %g6, %g10
	ld	%g10, %g26, 0
	slli	%g11, %g4, 2
	add	%g26, %g10, %g11
	fld	%f1, %g26, 0
	slli	%g10, %g4, 2
	add	%g26, %g7, %g10
	ld	%g10, %g26, 0
	slli	%g11, %g5, 2
	add	%g26, %g10, %g11
	fld	%f2, %g26, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	slli	%g10, %g5, 2
	add	%g26, %g9, %g10
	fst	%f0, %g26, 0
	subi	%g4, %g4, 1
	jlt	%g4, %g0, jge_else.3765
	slli	%g9, %g3, 2
	add	%g26, %g8, %g9
	ld	%g9, %g26, 0
	slli	%g10, %g5, 2
	add	%g26, %g9, %g10
	fld	%f0, %g26, 0
	slli	%g10, %g3, 2
	add	%g26, %g6, %g10
	ld	%g10, %g26, 0
	slli	%g11, %g4, 2
	add	%g26, %g10, %g11
	fld	%f1, %g26, 0
	slli	%g10, %g4, 2
	add	%g26, %g7, %g10
	ld	%g10, %g26, 0
	slli	%g11, %g5, 2
	add	%g26, %g10, %g11
	fld	%f2, %g26, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	slli	%g10, %g5, 2
	add	%g26, %g9, %g10
	fst	%f0, %g26, 0
	subi	%g4, %g4, 1
	jlt	%g4, %g0, jge_else.3766
	slli	%g9, %g3, 2
	add	%g26, %g8, %g9
	ld	%g9, %g26, 0
	slli	%g10, %g5, 2
	add	%g26, %g9, %g10
	fld	%f0, %g26, 0
	slli	%g10, %g3, 2
	add	%g26, %g6, %g10
	ld	%g10, %g26, 0
	slli	%g11, %g4, 2
	add	%g26, %g10, %g11
	fld	%f1, %g26, 0
	slli	%g10, %g4, 2
	add	%g26, %g7, %g10
	ld	%g10, %g26, 0
	slli	%g11, %g5, 2
	add	%g26, %g10, %g11
	fld	%f2, %g26, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	slli	%g10, %g5, 2
	add	%g26, %g9, %g10
	fst	%f0, %g26, 0
	subi	%g4, %g4, 1
	jlt	%g4, %g0, jge_else.3767
	slli	%g9, %g3, 2
	add	%g26, %g8, %g9
	ld	%g9, %g26, 0
	slli	%g10, %g5, 2
	add	%g26, %g9, %g10
	fld	%f0, %g26, 0
	slli	%g10, %g3, 2
	add	%g26, %g6, %g10
	ld	%g10, %g26, 0
	slli	%g11, %g4, 2
	add	%g26, %g10, %g11
	fld	%f1, %g26, 0
	slli	%g10, %g4, 2
	add	%g26, %g7, %g10
	ld	%g10, %g26, 0
	slli	%g11, %g5, 2
	add	%g26, %g10, %g11
	fld	%f2, %g26, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	slli	%g10, %g5, 2
	add	%g26, %g9, %g10
	fst	%f0, %g26, 0
	subi	%g4, %g4, 1
	jlt	%g4, %g0, jge_else.3768
	slli	%g9, %g3, 2
	add	%g26, %g8, %g9
	ld	%g9, %g26, 0
	slli	%g10, %g5, 2
	add	%g26, %g9, %g10
	fld	%f0, %g26, 0
	slli	%g10, %g3, 2
	add	%g26, %g6, %g10
	ld	%g10, %g26, 0
	slli	%g11, %g4, 2
	add	%g26, %g10, %g11
	fld	%f1, %g26, 0
	slli	%g10, %g4, 2
	add	%g26, %g7, %g10
	ld	%g10, %g26, 0
	slli	%g11, %g5, 2
	add	%g26, %g10, %g11
	fld	%f2, %g26, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	slli	%g10, %g5, 2
	add	%g26, %g9, %g10
	fst	%f0, %g26, 0
	subi	%g4, %g4, 1
	jlt	%g4, %g0, jge_else.3769
	slli	%g9, %g3, 2
	add	%g26, %g8, %g9
	ld	%g9, %g26, 0
	slli	%g10, %g5, 2
	add	%g26, %g9, %g10
	fld	%f0, %g26, 0
	slli	%g10, %g3, 2
	add	%g26, %g6, %g10
	ld	%g10, %g26, 0
	slli	%g11, %g4, 2
	add	%g26, %g10, %g11
	fld	%f1, %g26, 0
	slli	%g10, %g4, 2
	add	%g26, %g7, %g10
	ld	%g10, %g26, 0
	slli	%g11, %g5, 2
	add	%g26, %g10, %g11
	fld	%f2, %g26, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	slli	%g10, %g5, 2
	add	%g26, %g9, %g10
	fst	%f0, %g26, 0
	subi	%g4, %g4, 1
	jlt	%g4, %g0, jge_else.3770
	slli	%g9, %g3, 2
	add	%g26, %g8, %g9
	ld	%g9, %g26, 0
	slli	%g10, %g5, 2
	add	%g26, %g9, %g10
	fld	%f0, %g26, 0
	slli	%g10, %g3, 2
	add	%g26, %g6, %g10
	ld	%g10, %g26, 0
	slli	%g11, %g4, 2
	add	%g26, %g10, %g11
	fld	%f1, %g26, 0
	slli	%g10, %g4, 2
	add	%g26, %g7, %g10
	ld	%g10, %g26, 0
	slli	%g11, %g5, 2
	add	%g26, %g10, %g11
	fld	%f2, %g26, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	slli	%g10, %g5, 2
	add	%g26, %g9, %g10
	fst	%f0, %g26, 0
	subi	%g4, %g4, 1
	jmp	loop3.469
jge_else.3770:
	return
jge_else.3769:
	return
jge_else.3768:
	return
jge_else.3767:
	return
jge_else.3766:
	return
jge_else.3765:
	return
jge_else.3764:
	return
jge_else.3763:
	return
loop2.476:
	jlt	%g5, %g0, jge_else.3779
	subi	%g12, %g4, 1
	st	%g4, %g1, 0
	jlt	%g12, %g0, jge_else.3780
	slli	%g13, %g3, 2
	add	%g26, %g8, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g5, 2
	add	%g26, %g13, %g14
	fld	%f10, %g26, 0
	slli	%g14, %g3, 2
	add	%g26, %g6, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g12, 2
	add	%g26, %g14, %g15
	fld	%f11, %g26, 0
	slli	%g14, %g12, 2
	add	%g26, %g7, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g5, 2
	add	%g26, %g14, %g15
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g14, %g5, 2
	add	%g26, %g13, %g14
	fst	%f10, %g26, 0
	subi	%g13, %g12, 1
	jlt	%g13, %g0, jge_else.3782
	slli	%g14, %g3, 2
	add	%g26, %g8, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g5, 2
	add	%g26, %g14, %g15
	fld	%f10, %g26, 0
	slli	%g15, %g3, 2
	add	%g26, %g6, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g13, 2
	add	%g26, %g15, %g16
	fld	%f11, %g26, 0
	slli	%g15, %g13, 2
	add	%g26, %g7, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g5, 2
	add	%g26, %g15, %g16
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g15, %g5, 2
	add	%g26, %g14, %g15
	fst	%f10, %g26, 0
	subi	%g13, %g13, 1
	jlt	%g13, %g0, jge_else.3784
	slli	%g14, %g3, 2
	add	%g26, %g8, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g5, 2
	add	%g26, %g14, %g15
	fld	%f10, %g26, 0
	slli	%g15, %g3, 2
	add	%g26, %g6, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g13, 2
	add	%g26, %g15, %g16
	fld	%f11, %g26, 0
	slli	%g15, %g13, 2
	add	%g26, %g7, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g5, 2
	add	%g26, %g15, %g16
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g15, %g5, 2
	add	%g26, %g14, %g15
	fst	%f10, %g26, 0
	subi	%g13, %g13, 1
	jlt	%g13, %g0, jge_else.3786
	slli	%g14, %g3, 2
	add	%g26, %g8, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g5, 2
	add	%g26, %g14, %g15
	fld	%f10, %g26, 0
	slli	%g15, %g3, 2
	add	%g26, %g6, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g13, 2
	add	%g26, %g15, %g16
	fld	%f11, %g26, 0
	slli	%g15, %g13, 2
	add	%g26, %g7, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g5, 2
	add	%g26, %g15, %g16
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g15, %g5, 2
	add	%g26, %g14, %g15
	fst	%f10, %g26, 0
	subi	%g13, %g13, 1
	jlt	%g13, %g0, jge_else.3788
	slli	%g14, %g3, 2
	add	%g26, %g8, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g5, 2
	add	%g26, %g14, %g15
	fld	%f10, %g26, 0
	slli	%g15, %g3, 2
	add	%g26, %g6, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g13, 2
	add	%g26, %g15, %g16
	fld	%f11, %g26, 0
	slli	%g15, %g13, 2
	add	%g26, %g7, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g5, 2
	add	%g26, %g15, %g16
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g15, %g5, 2
	add	%g26, %g14, %g15
	fst	%f10, %g26, 0
	subi	%g13, %g13, 1
	jlt	%g13, %g0, jge_else.3790
	slli	%g14, %g3, 2
	add	%g26, %g8, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g5, 2
	add	%g26, %g14, %g15
	fld	%f10, %g26, 0
	slli	%g15, %g3, 2
	add	%g26, %g6, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g13, 2
	add	%g26, %g15, %g16
	fld	%f11, %g26, 0
	slli	%g15, %g13, 2
	add	%g26, %g7, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g5, 2
	add	%g26, %g15, %g16
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g15, %g5, 2
	add	%g26, %g14, %g15
	fst	%f10, %g26, 0
	subi	%g13, %g13, 1
	jlt	%g13, %g0, jge_else.3792
	slli	%g14, %g3, 2
	add	%g26, %g8, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g5, 2
	add	%g26, %g14, %g15
	fld	%f10, %g26, 0
	slli	%g15, %g3, 2
	add	%g26, %g6, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g13, 2
	add	%g26, %g15, %g16
	fld	%f11, %g26, 0
	slli	%g15, %g13, 2
	add	%g26, %g7, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g5, 2
	add	%g26, %g15, %g16
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g15, %g5, 2
	add	%g26, %g14, %g15
	fst	%f10, %g26, 0
	subi	%g13, %g13, 1
	jlt	%g13, %g0, jge_else.3794
	slli	%g14, %g3, 2
	add	%g26, %g8, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g5, 2
	add	%g26, %g14, %g15
	fld	%f10, %g26, 0
	slli	%g15, %g3, 2
	add	%g26, %g6, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g13, 2
	add	%g26, %g15, %g16
	fld	%f11, %g26, 0
	slli	%g15, %g13, 2
	add	%g26, %g7, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g5, 2
	add	%g26, %g15, %g16
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g15, %g5, 2
	add	%g26, %g14, %g15
	fst	%f10, %g26, 0
	subi	%g13, %g13, 1
	mov	%g4, %g13
	subi	%g1, %g1, 8
	call	loop3.469
	addi	%g1, %g1, 8
	jmp	jge_cont.3795
jge_else.3794:
jge_cont.3795:
	jmp	jge_cont.3793
jge_else.3792:
jge_cont.3793:
	jmp	jge_cont.3791
jge_else.3790:
jge_cont.3791:
	jmp	jge_cont.3789
jge_else.3788:
jge_cont.3789:
	jmp	jge_cont.3787
jge_else.3786:
jge_cont.3787:
	jmp	jge_cont.3785
jge_else.3784:
jge_cont.3785:
	jmp	jge_cont.3783
jge_else.3782:
jge_cont.3783:
	jmp	jge_cont.3781
jge_else.3780:
jge_cont.3781:
	subi	%g4, %g5, 1
	jlt	%g4, %g0, jge_else.3796
	st	%g4, %g1, 4
	jlt	%g12, %g0, jge_else.3797
	slli	%g5, %g3, 2
	add	%g26, %g8, %g5
	ld	%g5, %g26, 0
	slli	%g13, %g4, 2
	add	%g26, %g5, %g13
	fld	%f10, %g26, 0
	slli	%g13, %g3, 2
	add	%g26, %g6, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g12, 2
	add	%g26, %g13, %g14
	fld	%f11, %g26, 0
	slli	%g13, %g12, 2
	add	%g26, %g7, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g13, %g4, 2
	add	%g26, %g5, %g13
	fst	%f10, %g26, 0
	subi	%g5, %g12, 1
	jlt	%g5, %g0, jge_else.3799
	slli	%g12, %g3, 2
	add	%g26, %g8, %g12
	ld	%g12, %g26, 0
	slli	%g13, %g4, 2
	add	%g26, %g12, %g13
	fld	%f10, %g26, 0
	slli	%g13, %g3, 2
	add	%g26, %g6, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g5, 2
	add	%g26, %g13, %g14
	fld	%f11, %g26, 0
	slli	%g13, %g5, 2
	add	%g26, %g7, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g13, %g4, 2
	add	%g26, %g12, %g13
	fst	%f10, %g26, 0
	subi	%g5, %g5, 1
	jlt	%g5, %g0, jge_else.3801
	slli	%g12, %g3, 2
	add	%g26, %g8, %g12
	ld	%g12, %g26, 0
	slli	%g13, %g4, 2
	add	%g26, %g12, %g13
	fld	%f10, %g26, 0
	slli	%g13, %g3, 2
	add	%g26, %g6, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g5, 2
	add	%g26, %g13, %g14
	fld	%f11, %g26, 0
	slli	%g13, %g5, 2
	add	%g26, %g7, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g13, %g4, 2
	add	%g26, %g12, %g13
	fst	%f10, %g26, 0
	subi	%g5, %g5, 1
	jlt	%g5, %g0, jge_else.3803
	slli	%g12, %g3, 2
	add	%g26, %g8, %g12
	ld	%g12, %g26, 0
	slli	%g13, %g4, 2
	add	%g26, %g12, %g13
	fld	%f10, %g26, 0
	slli	%g13, %g3, 2
	add	%g26, %g6, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g5, 2
	add	%g26, %g13, %g14
	fld	%f11, %g26, 0
	slli	%g13, %g5, 2
	add	%g26, %g7, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g13, %g4, 2
	add	%g26, %g12, %g13
	fst	%f10, %g26, 0
	subi	%g5, %g5, 1
	jlt	%g5, %g0, jge_else.3805
	slli	%g12, %g3, 2
	add	%g26, %g8, %g12
	ld	%g12, %g26, 0
	slli	%g13, %g4, 2
	add	%g26, %g12, %g13
	fld	%f10, %g26, 0
	slli	%g13, %g3, 2
	add	%g26, %g6, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g5, 2
	add	%g26, %g13, %g14
	fld	%f11, %g26, 0
	slli	%g13, %g5, 2
	add	%g26, %g7, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g13, %g4, 2
	add	%g26, %g12, %g13
	fst	%f10, %g26, 0
	subi	%g5, %g5, 1
	jlt	%g5, %g0, jge_else.3807
	slli	%g12, %g3, 2
	add	%g26, %g8, %g12
	ld	%g12, %g26, 0
	slli	%g13, %g4, 2
	add	%g26, %g12, %g13
	fld	%f10, %g26, 0
	slli	%g13, %g3, 2
	add	%g26, %g6, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g5, 2
	add	%g26, %g13, %g14
	fld	%f11, %g26, 0
	slli	%g13, %g5, 2
	add	%g26, %g7, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g13, %g4, 2
	add	%g26, %g12, %g13
	fst	%f10, %g26, 0
	subi	%g5, %g5, 1
	jlt	%g5, %g0, jge_else.3809
	slli	%g12, %g3, 2
	add	%g26, %g8, %g12
	ld	%g12, %g26, 0
	slli	%g13, %g4, 2
	add	%g26, %g12, %g13
	fld	%f10, %g26, 0
	slli	%g13, %g3, 2
	add	%g26, %g6, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g5, 2
	add	%g26, %g13, %g14
	fld	%f11, %g26, 0
	slli	%g13, %g5, 2
	add	%g26, %g7, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g13, %g4, 2
	add	%g26, %g12, %g13
	fst	%f10, %g26, 0
	subi	%g5, %g5, 1
	mov	%g26, %g5
	mov	%g5, %g4
	mov	%g4, %g26
	subi	%g1, %g1, 16
	call	loop3.469
	addi	%g1, %g1, 16
	jmp	jge_cont.3810
jge_else.3809:
jge_cont.3810:
	jmp	jge_cont.3808
jge_else.3807:
jge_cont.3808:
	jmp	jge_cont.3806
jge_else.3805:
jge_cont.3806:
	jmp	jge_cont.3804
jge_else.3803:
jge_cont.3804:
	jmp	jge_cont.3802
jge_else.3801:
jge_cont.3802:
	jmp	jge_cont.3800
jge_else.3799:
jge_cont.3800:
	jmp	jge_cont.3798
jge_else.3797:
jge_cont.3798:
	ld	%g4, %g1, 4
	subi	%g4, %g4, 1
	ld	%g5, %g1, 0
	mov	%g26, %g5
	mov	%g5, %g4
	mov	%g4, %g26
	jmp	loop2.476
jge_else.3796:
	return
jge_else.3779:
	return
loop1.483:
	jlt	%g3, %g0, jge_else.3813
	subi	%g12, %g5, 1
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	st	%g12, %g1, 8
	jlt	%g12, %g0, jge_else.3814
	subi	%g13, %g4, 1
	jlt	%g13, %g0, jge_else.3816
	slli	%g14, %g3, 2
	add	%g26, %g8, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g12, 2
	add	%g26, %g14, %g15
	fld	%f10, %g26, 0
	slli	%g15, %g3, 2
	add	%g26, %g6, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g13, 2
	add	%g26, %g15, %g16
	fld	%f11, %g26, 0
	slli	%g15, %g13, 2
	add	%g26, %g7, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g12, 2
	add	%g26, %g15, %g16
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g15, %g12, 2
	add	%g26, %g14, %g15
	fst	%f10, %g26, 0
	subi	%g14, %g13, 1
	jlt	%g14, %g0, jge_else.3818
	slli	%g15, %g3, 2
	add	%g26, %g8, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g12, 2
	add	%g26, %g15, %g16
	fld	%f10, %g26, 0
	slli	%g16, %g3, 2
	add	%g26, %g6, %g16
	ld	%g16, %g26, 0
	slli	%g17, %g14, 2
	add	%g26, %g16, %g17
	fld	%f11, %g26, 0
	slli	%g16, %g14, 2
	add	%g26, %g7, %g16
	ld	%g16, %g26, 0
	slli	%g17, %g12, 2
	add	%g26, %g16, %g17
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g16, %g12, 2
	add	%g26, %g15, %g16
	fst	%f10, %g26, 0
	subi	%g14, %g14, 1
	jlt	%g14, %g0, jge_else.3820
	slli	%g15, %g3, 2
	add	%g26, %g8, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g12, 2
	add	%g26, %g15, %g16
	fld	%f10, %g26, 0
	slli	%g16, %g3, 2
	add	%g26, %g6, %g16
	ld	%g16, %g26, 0
	slli	%g17, %g14, 2
	add	%g26, %g16, %g17
	fld	%f11, %g26, 0
	slli	%g16, %g14, 2
	add	%g26, %g7, %g16
	ld	%g16, %g26, 0
	slli	%g17, %g12, 2
	add	%g26, %g16, %g17
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g16, %g12, 2
	add	%g26, %g15, %g16
	fst	%f10, %g26, 0
	subi	%g14, %g14, 1
	jlt	%g14, %g0, jge_else.3822
	slli	%g15, %g3, 2
	add	%g26, %g8, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g12, 2
	add	%g26, %g15, %g16
	fld	%f10, %g26, 0
	slli	%g16, %g3, 2
	add	%g26, %g6, %g16
	ld	%g16, %g26, 0
	slli	%g17, %g14, 2
	add	%g26, %g16, %g17
	fld	%f11, %g26, 0
	slli	%g16, %g14, 2
	add	%g26, %g7, %g16
	ld	%g16, %g26, 0
	slli	%g17, %g12, 2
	add	%g26, %g16, %g17
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g16, %g12, 2
	add	%g26, %g15, %g16
	fst	%f10, %g26, 0
	subi	%g14, %g14, 1
	jlt	%g14, %g0, jge_else.3824
	slli	%g15, %g3, 2
	add	%g26, %g8, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g12, 2
	add	%g26, %g15, %g16
	fld	%f10, %g26, 0
	slli	%g16, %g3, 2
	add	%g26, %g6, %g16
	ld	%g16, %g26, 0
	slli	%g17, %g14, 2
	add	%g26, %g16, %g17
	fld	%f11, %g26, 0
	slli	%g16, %g14, 2
	add	%g26, %g7, %g16
	ld	%g16, %g26, 0
	slli	%g17, %g12, 2
	add	%g26, %g16, %g17
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g16, %g12, 2
	add	%g26, %g15, %g16
	fst	%f10, %g26, 0
	subi	%g14, %g14, 1
	jlt	%g14, %g0, jge_else.3826
	slli	%g15, %g3, 2
	add	%g26, %g8, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g12, 2
	add	%g26, %g15, %g16
	fld	%f10, %g26, 0
	slli	%g16, %g3, 2
	add	%g26, %g6, %g16
	ld	%g16, %g26, 0
	slli	%g17, %g14, 2
	add	%g26, %g16, %g17
	fld	%f11, %g26, 0
	slli	%g16, %g14, 2
	add	%g26, %g7, %g16
	ld	%g16, %g26, 0
	slli	%g17, %g12, 2
	add	%g26, %g16, %g17
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g16, %g12, 2
	add	%g26, %g15, %g16
	fst	%f10, %g26, 0
	subi	%g14, %g14, 1
	jlt	%g14, %g0, jge_else.3828
	slli	%g15, %g3, 2
	add	%g26, %g8, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g12, 2
	add	%g26, %g15, %g16
	fld	%f10, %g26, 0
	slli	%g16, %g3, 2
	add	%g26, %g6, %g16
	ld	%g16, %g26, 0
	slli	%g17, %g14, 2
	add	%g26, %g16, %g17
	fld	%f11, %g26, 0
	slli	%g16, %g14, 2
	add	%g26, %g7, %g16
	ld	%g16, %g26, 0
	slli	%g17, %g12, 2
	add	%g26, %g16, %g17
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g16, %g12, 2
	add	%g26, %g15, %g16
	fst	%f10, %g26, 0
	subi	%g14, %g14, 1
	jlt	%g14, %g0, jge_else.3830
	slli	%g15, %g3, 2
	add	%g26, %g8, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g12, 2
	add	%g26, %g15, %g16
	fld	%f10, %g26, 0
	slli	%g16, %g3, 2
	add	%g26, %g6, %g16
	ld	%g16, %g26, 0
	slli	%g17, %g14, 2
	add	%g26, %g16, %g17
	fld	%f11, %g26, 0
	slli	%g16, %g14, 2
	add	%g26, %g7, %g16
	ld	%g16, %g26, 0
	slli	%g17, %g12, 2
	add	%g26, %g16, %g17
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g16, %g12, 2
	add	%g26, %g15, %g16
	fst	%f10, %g26, 0
	subi	%g14, %g14, 1
	mov	%g5, %g12
	mov	%g4, %g14
	subi	%g1, %g1, 16
	call	loop3.469
	addi	%g1, %g1, 16
	jmp	jge_cont.3831
jge_else.3830:
jge_cont.3831:
	jmp	jge_cont.3829
jge_else.3828:
jge_cont.3829:
	jmp	jge_cont.3827
jge_else.3826:
jge_cont.3827:
	jmp	jge_cont.3825
jge_else.3824:
jge_cont.3825:
	jmp	jge_cont.3823
jge_else.3822:
jge_cont.3823:
	jmp	jge_cont.3821
jge_else.3820:
jge_cont.3821:
	jmp	jge_cont.3819
jge_else.3818:
jge_cont.3819:
	jmp	jge_cont.3817
jge_else.3816:
jge_cont.3817:
	subi	%g4, %g12, 1
	jlt	%g4, %g0, jge_else.3832
	st	%g4, %g1, 12
	jlt	%g13, %g0, jge_else.3834
	slli	%g14, %g3, 2
	add	%g26, %g8, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fld	%f10, %g26, 0
	slli	%g15, %g3, 2
	add	%g26, %g6, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g13, 2
	add	%g26, %g15, %g16
	fld	%f11, %g26, 0
	slli	%g15, %g13, 2
	add	%g26, %g7, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g4, 2
	add	%g26, %g15, %g16
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fst	%f10, %g26, 0
	subi	%g13, %g13, 1
	jlt	%g13, %g0, jge_else.3836
	slli	%g14, %g3, 2
	add	%g26, %g8, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fld	%f10, %g26, 0
	slli	%g15, %g3, 2
	add	%g26, %g6, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g13, 2
	add	%g26, %g15, %g16
	fld	%f11, %g26, 0
	slli	%g15, %g13, 2
	add	%g26, %g7, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g4, 2
	add	%g26, %g15, %g16
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fst	%f10, %g26, 0
	subi	%g13, %g13, 1
	jlt	%g13, %g0, jge_else.3838
	slli	%g14, %g3, 2
	add	%g26, %g8, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fld	%f10, %g26, 0
	slli	%g15, %g3, 2
	add	%g26, %g6, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g13, 2
	add	%g26, %g15, %g16
	fld	%f11, %g26, 0
	slli	%g15, %g13, 2
	add	%g26, %g7, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g4, 2
	add	%g26, %g15, %g16
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fst	%f10, %g26, 0
	subi	%g13, %g13, 1
	jlt	%g13, %g0, jge_else.3840
	slli	%g14, %g3, 2
	add	%g26, %g8, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fld	%f10, %g26, 0
	slli	%g15, %g3, 2
	add	%g26, %g6, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g13, 2
	add	%g26, %g15, %g16
	fld	%f11, %g26, 0
	slli	%g15, %g13, 2
	add	%g26, %g7, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g4, 2
	add	%g26, %g15, %g16
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fst	%f10, %g26, 0
	subi	%g13, %g13, 1
	jlt	%g13, %g0, jge_else.3842
	slli	%g14, %g3, 2
	add	%g26, %g8, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fld	%f10, %g26, 0
	slli	%g15, %g3, 2
	add	%g26, %g6, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g13, 2
	add	%g26, %g15, %g16
	fld	%f11, %g26, 0
	slli	%g15, %g13, 2
	add	%g26, %g7, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g4, 2
	add	%g26, %g15, %g16
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fst	%f10, %g26, 0
	subi	%g13, %g13, 1
	jlt	%g13, %g0, jge_else.3844
	slli	%g14, %g3, 2
	add	%g26, %g8, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fld	%f10, %g26, 0
	slli	%g15, %g3, 2
	add	%g26, %g6, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g13, 2
	add	%g26, %g15, %g16
	fld	%f11, %g26, 0
	slli	%g15, %g13, 2
	add	%g26, %g7, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g4, 2
	add	%g26, %g15, %g16
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fst	%f10, %g26, 0
	subi	%g13, %g13, 1
	jlt	%g13, %g0, jge_else.3846
	slli	%g14, %g3, 2
	add	%g26, %g8, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fld	%f10, %g26, 0
	slli	%g15, %g3, 2
	add	%g26, %g6, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g13, 2
	add	%g26, %g15, %g16
	fld	%f11, %g26, 0
	slli	%g15, %g13, 2
	add	%g26, %g7, %g15
	ld	%g15, %g26, 0
	slli	%g16, %g4, 2
	add	%g26, %g15, %g16
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fst	%f10, %g26, 0
	subi	%g13, %g13, 1
	mov	%g5, %g4
	mov	%g4, %g13
	subi	%g1, %g1, 24
	call	loop3.469
	addi	%g1, %g1, 24
	jmp	jge_cont.3847
jge_else.3846:
jge_cont.3847:
	jmp	jge_cont.3845
jge_else.3844:
jge_cont.3845:
	jmp	jge_cont.3843
jge_else.3842:
jge_cont.3843:
	jmp	jge_cont.3841
jge_else.3840:
jge_cont.3841:
	jmp	jge_cont.3839
jge_else.3838:
jge_cont.3839:
	jmp	jge_cont.3837
jge_else.3836:
jge_cont.3837:
	jmp	jge_cont.3835
jge_else.3834:
jge_cont.3835:
	ld	%g4, %g1, 12
	subi	%g4, %g4, 1
	ld	%g17, %g1, 4
	mov	%g5, %g4
	mov	%g4, %g17
	subi	%g1, %g1, 24
	call	loop2.476
	addi	%g1, %g1, 24
	jmp	jge_cont.3833
jge_else.3832:
jge_cont.3833:
	jmp	jge_cont.3815
jge_else.3814:
jge_cont.3815:
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.3848
	ld	%g4, %g1, 8
	jlt	%g4, %g0, jge_else.3849
	ld	%g5, %g1, 4
	subi	%g12, %g5, 1
	jlt	%g12, %g0, jge_else.3851
	slli	%g13, %g3, 2
	add	%g26, %g8, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fld	%f10, %g26, 0
	slli	%g14, %g3, 2
	add	%g26, %g6, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g12, 2
	add	%g26, %g14, %g15
	fld	%f11, %g26, 0
	slli	%g14, %g12, 2
	add	%g26, %g7, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fst	%f10, %g26, 0
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.3853
	slli	%g13, %g3, 2
	add	%g26, %g8, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fld	%f10, %g26, 0
	slli	%g14, %g3, 2
	add	%g26, %g6, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g12, 2
	add	%g26, %g14, %g15
	fld	%f11, %g26, 0
	slli	%g14, %g12, 2
	add	%g26, %g7, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fst	%f10, %g26, 0
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.3855
	slli	%g13, %g3, 2
	add	%g26, %g8, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fld	%f10, %g26, 0
	slli	%g14, %g3, 2
	add	%g26, %g6, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g12, 2
	add	%g26, %g14, %g15
	fld	%f11, %g26, 0
	slli	%g14, %g12, 2
	add	%g26, %g7, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fst	%f10, %g26, 0
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.3857
	slli	%g13, %g3, 2
	add	%g26, %g8, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fld	%f10, %g26, 0
	slli	%g14, %g3, 2
	add	%g26, %g6, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g12, 2
	add	%g26, %g14, %g15
	fld	%f11, %g26, 0
	slli	%g14, %g12, 2
	add	%g26, %g7, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fst	%f10, %g26, 0
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.3859
	slli	%g13, %g3, 2
	add	%g26, %g8, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fld	%f10, %g26, 0
	slli	%g14, %g3, 2
	add	%g26, %g6, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g12, 2
	add	%g26, %g14, %g15
	fld	%f11, %g26, 0
	slli	%g14, %g12, 2
	add	%g26, %g7, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fst	%f10, %g26, 0
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.3861
	slli	%g13, %g3, 2
	add	%g26, %g8, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fld	%f10, %g26, 0
	slli	%g14, %g3, 2
	add	%g26, %g6, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g12, 2
	add	%g26, %g14, %g15
	fld	%f11, %g26, 0
	slli	%g14, %g12, 2
	add	%g26, %g7, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fst	%f10, %g26, 0
	subi	%g12, %g12, 1
	jlt	%g12, %g0, jge_else.3863
	slli	%g13, %g3, 2
	add	%g26, %g8, %g13
	ld	%g13, %g26, 0
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fld	%f10, %g26, 0
	slli	%g14, %g3, 2
	add	%g26, %g6, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g12, 2
	add	%g26, %g14, %g15
	fld	%f11, %g26, 0
	slli	%g14, %g12, 2
	add	%g26, %g7, %g14
	ld	%g14, %g26, 0
	slli	%g15, %g4, 2
	add	%g26, %g14, %g15
	fld	%f12, %g26, 0
	fmul	%f11, %f11, %f12
	fadd	%f10, %f10, %f11
	slli	%g14, %g4, 2
	add	%g26, %g13, %g14
	fst	%f10, %g26, 0
	subi	%g12, %g12, 1
	mov	%g5, %g4
	mov	%g4, %g12
	subi	%g1, %g1, 24
	call	loop3.469
	addi	%g1, %g1, 24
	jmp	jge_cont.3864
jge_else.3863:
jge_cont.3864:
	jmp	jge_cont.3862
jge_else.3861:
jge_cont.3862:
	jmp	jge_cont.3860
jge_else.3859:
jge_cont.3860:
	jmp	jge_cont.3858
jge_else.3857:
jge_cont.3858:
	jmp	jge_cont.3856
jge_else.3855:
jge_cont.3856:
	jmp	jge_cont.3854
jge_else.3853:
jge_cont.3854:
	jmp	jge_cont.3852
jge_else.3851:
jge_cont.3852:
	ld	%g4, %g1, 8
	subi	%g4, %g4, 1
	mov	%g26, %g5
	mov	%g5, %g4
	mov	%g4, %g26
	subi	%g1, %g1, 24
	call	loop2.476
	addi	%g1, %g1, 24
	jmp	jge_cont.3850
jge_else.3849:
jge_cont.3850:
	subi	%g3, %g3, 1
	ld	%g4, %g1, 4
	ld	%g5, %g1, 0
	jmp	loop1.483
jge_else.3848:
	return
jge_else.3813:
	return
min_caml_start:
	addi	%g28, %g0, 1
	addi	%g29, %g0, -1
	setL %g26, l.3093
	fld	%f16, %g26, 0
	setL %g26, l.3088
	fld	%f17, %g26, 0
	setL %g26, l.3083
	fld	%f18, %g26, 0
	setL %g26, l.3078
	fld	%f19, %g26, 0
	setL %g26, l.3073
	fld	%f20, %g26, 0
	setL %g26, l.3068
	fld	%f21, %g26, 0
	setL %g26, l.3063
	fld	%f22, %g26, 0
	setL %g26, l.3058
	fld	%f23, %g26, 0
	setL %g26, l.3053
	fld	%f24, %g26, 0
	setL %g26, l.3048
	fld	%f25, %g26, 0
	setL %g26, l.3040
	fld	%f26, %g26, 0
	setL %g26, l.3029
	fld	%f27, %g26, 0
	setL %g26, l.3027
	fld	%f28, %g26, 0
	fmov	%f0, %f28
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	addi	%g3, %g0, 1
	addi	%g4, %g0, 1
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	addi	%g3, %g0, 0
	fmov	%f1, %f27
	fst	%f0, %g1, 0
	fmov	%f0, %f1
	subi	%g1, %g1, 8
	call	min_caml_create_float_array
	addi	%g1, %g1, 8
	addi	%g4, %g0, 2
	addi	%g10, %g0, 3
	st	%g3, %g1, 4
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 16
	call	min_caml_create_array
	addi	%g1, %g1, 16
	st	%g3, %g1, 8
	mov	%g3, %g10
	fmov	%f0, %f1
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	ld	%g11, %g1, 8
	st	%g3, %g11, -4
	mov	%g3, %g10
	fmov	%f0, %f1
	subi	%g1, %g1, 16
	call	min_caml_create_float_array
	addi	%g1, %g1, 16
	st	%g3, %g11, 0
	addi	%g3, %g0, 3
	addi	%g4, %g0, 2
	ld	%g10, %g1, 4
	st	%g4, %g1, 12
	mov	%g4, %g10
	subi	%g1, %g1, 24
	call	min_caml_create_array
	addi	%g1, %g1, 24
	ld	%g12, %g1, 12
	st	%g3, %g1, 16
	mov	%g3, %g12
	fmov	%f0, %f1
	subi	%g1, %g1, 24
	call	min_caml_create_float_array
	addi	%g1, %g1, 24
	ld	%g13, %g1, 16
	st	%g3, %g13, -8
	mov	%g3, %g12
	fmov	%f0, %f1
	subi	%g1, %g1, 24
	call	min_caml_create_float_array
	addi	%g1, %g1, 24
	st	%g3, %g13, -4
	mov	%g3, %g12
	fmov	%f0, %f1
	subi	%g1, %g1, 24
	call	min_caml_create_float_array
	addi	%g1, %g1, 24
	st	%g3, %g13, 0
	addi	%g3, %g0, 2
	addi	%g4, %g0, 2
	st	%g4, %g1, 20
	mov	%g4, %g10
	subi	%g1, %g1, 32
	call	min_caml_create_array
	addi	%g1, %g1, 32
	ld	%g10, %g1, 20
	st	%g3, %g1, 24
	mov	%g3, %g10
	fmov	%f0, %f1
	subi	%g1, %g1, 32
	call	min_caml_create_float_array
	addi	%g1, %g1, 32
	ld	%g12, %g1, 24
	st	%g3, %g12, -4
	mov	%g3, %g10
	fmov	%f0, %f1
	subi	%g1, %g1, 32
	call	min_caml_create_float_array
	addi	%g1, %g1, 32
	st	%g3, %g12, 0
	ld	%g3, %g11, 0
	fmov	%f13, %f26
	fst	%f13, %g3, 0
	ld	%g3, %g11, 0
	fld	%f13, %g1, 0
	fst	%f13, %g3, -4
	ld	%g3, %g11, 0
	fmov	%f13, %f25
	fst	%f13, %g3, -8
	ld	%g3, %g11, -4
	fmov	%f13, %f24
	fst	%f13, %g3, 0
	ld	%g3, %g11, -4
	fmov	%f13, %f23
	fst	%f13, %g3, -4
	ld	%g3, %g11, -4
	fmov	%f13, %f22
	fst	%f13, %g3, -8
	ld	%g3, %g13, 0
	fmov	%f13, %f21
	fst	%f13, %g3, 0
	ld	%g3, %g13, 0
	fmov	%f13, %f20
	fst	%f13, %g3, -4
	ld	%g3, %g13, -4
	fmov	%f13, %f19
	fst	%f13, %g3, 0
	ld	%g3, %g13, -4
	fmov	%f13, %f18
	fst	%f13, %g3, -4
	ld	%g3, %g13, -8
	fmov	%f13, %f17
	fst	%f13, %g3, 0
	ld	%g3, %g13, -8
	fmov	%f13, %f16
	fst	%f13, %g3, -4
	addi	%g3, %g0, 3
	addi	%g4, %g0, 2
	addi	%g5, %g0, 1
	ld	%g6, %g12, -4
	fld	%f13, %g6, -4
	ld	%g7, %g11, -4
	fld	%f14, %g7, -8
	ld	%g7, %g13, -8
	fld	%f15, %g7, -4
	fmul	%f14, %f14, %f15
	fadd	%f13, %f13, %f14
	fst	%f13, %g6, -4
	ld	%g6, %g12, -4
	fld	%f13, %g6, -4
	ld	%g7, %g11, -4
	fld	%f14, %g7, -4
	ld	%g7, %g13, -4
	fld	%f15, %g7, -4
	fmul	%f14, %f14, %f15
	fadd	%f13, %f13, %f14
	fst	%f13, %g6, -4
	ld	%g6, %g12, -4
	fld	%f13, %g6, -4
	ld	%g7, %g11, -4
	fld	%f14, %g7, 0
	ld	%g7, %g13, 0
	fld	%f15, %g7, -4
	fmul	%f14, %f14, %f15
	fadd	%f13, %f13, %f14
	fst	%f13, %g6, -4
	addi	%g6, %g0, 0
	st	%g4, %g1, 28
	mov	%g8, %g12
	mov	%g7, %g13
	mov	%g4, %g3
	mov	%g3, %g5
	mov	%g5, %g6
	mov	%g6, %g11
	subi	%g1, %g1, 40
	call	loop2.476
	addi	%g1, %g1, 40
	addi	%g4, %g0, 0
	ld	%g5, %g1, 28
	ld	%g6, %g1, 8
	ld	%g7, %g1, 16
	ld	%g8, %g1, 24
	mov	%g26, %g4
	mov	%g4, %g3
	mov	%g3, %g26
	subi	%g1, %g1, 40
	call	loop1.483
	addi	%g1, %g1, 40
	ld	%g10, %g8, 0
	fld	%f0, %g10, 0
	subi	%g1, %g1, 40
	call	min_caml_truncate
	addi	%g1, %g1, 40
	subi	%g1, %g1, 40
	call	print_int.467
	addi	%g1, %g1, 40
	st	%g3, %g1, 40
	addi	%g3, %g0, 10
	output	%g3
	ld	%g3, %g1, 40
	ld	%g10, %g1, 24
	ld	%g11, %g10, 0
	fld	%f0, %g11, -4
	subi	%g1, %g1, 40
	call	min_caml_truncate
	addi	%g1, %g1, 40
	subi	%g1, %g1, 40
	call	print_int.467
	addi	%g1, %g1, 40
	st	%g3, %g1, 40
	addi	%g3, %g0, 10
	output	%g3
	ld	%g3, %g1, 40
	ld	%g10, %g1, 24
	ld	%g11, %g10, -4
	fld	%f0, %g11, 0
	subi	%g1, %g1, 40
	call	min_caml_truncate
	addi	%g1, %g1, 40
	subi	%g1, %g1, 40
	call	print_int.467
	addi	%g1, %g1, 40
	st	%g3, %g1, 40
	addi	%g3, %g0, 10
	output	%g3
	ld	%g3, %g1, 40
	ld	%g10, %g1, 24
	ld	%g10, %g10, -4
	fld	%f0, %g10, -4
	subi	%g1, %g1, 40
	call	min_caml_truncate
	addi	%g1, %g1, 40
	subi	%g1, %g1, 40
	call	print_int.467
	addi	%g1, %g1, 40
	st	%g3, %g1, 40
	addi	%g3, %g0, 10
	output	%g3
	ld	%g3, %g1, 40
	halt
