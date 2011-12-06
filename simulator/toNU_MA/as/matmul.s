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
l.3027:	! 12.000000
	.long	0x41400000
l.3022:	! 11.000000
	.long	0x41300000
l.3017:	! 10.000000
	.long	0x41200000
l.3012:	! 9.000000
	.long	0x41100000
l.3007:	! 8.000000
	.long	0x41000000
l.3002:	! 7.000000
	.long	0x40e00000
l.2997:	! 6.000000
	.long	0x40c00000
l.2992:	! 5.000000
	.long	0x40a00000
l.2987:	! 4.000000
	.long	0x40800000
l.2982:	! 3.000000
	.long	0x40400000
l.2974:	! 1.000000
	.long	0x3f800000
l.2963:	! 0.000000
	.long	0x0
l.2961:	! 2.000000
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
	jlt	%g28, %g9, jle_else.3399
	mov	%g3, %g5
	return
jle_else.3399:
	jlt	%g8, %g3, jle_else.3400
	jne	%g8, %g3, jeq_else.3401
	mov	%g3, %g7
	return
jeq_else.3401:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.3402
	mov	%g3, %g5
	return
jle_else.3402:
	jlt	%g8, %g3, jle_else.3403
	jne	%g8, %g3, jeq_else.3404
	mov	%g3, %g6
	return
jeq_else.3404:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.3405
	mov	%g3, %g5
	return
jle_else.3405:
	jlt	%g8, %g3, jle_else.3406
	jne	%g8, %g3, jeq_else.3407
	mov	%g3, %g7
	return
jeq_else.3407:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.3408
	mov	%g3, %g5
	return
jle_else.3408:
	jlt	%g8, %g3, jle_else.3409
	jne	%g8, %g3, jeq_else.3410
	mov	%g3, %g6
	return
jeq_else.3410:
	jmp	div_binary_search.462
jle_else.3409:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.462
jle_else.3406:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.3411
	mov	%g3, %g7
	return
jle_else.3411:
	jlt	%g8, %g3, jle_else.3412
	jne	%g8, %g3, jeq_else.3413
	mov	%g3, %g5
	return
jeq_else.3413:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.462
jle_else.3412:
	jmp	div_binary_search.462
jle_else.3403:
	add	%g5, %g6, %g7
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g7, %g6
	jlt	%g28, %g9, jle_else.3414
	mov	%g3, %g6
	return
jle_else.3414:
	jlt	%g8, %g3, jle_else.3415
	jne	%g8, %g3, jeq_else.3416
	mov	%g3, %g5
	return
jeq_else.3416:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.3417
	mov	%g3, %g6
	return
jle_else.3417:
	jlt	%g8, %g3, jle_else.3418
	jne	%g8, %g3, jeq_else.3419
	mov	%g3, %g7
	return
jeq_else.3419:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.462
jle_else.3418:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.462
jle_else.3415:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.3420
	mov	%g3, %g5
	return
jle_else.3420:
	jlt	%g8, %g3, jle_else.3421
	jne	%g8, %g3, jeq_else.3422
	mov	%g3, %g6
	return
jeq_else.3422:
	jmp	div_binary_search.462
jle_else.3421:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.462
jle_else.3400:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.3423
	mov	%g3, %g7
	return
jle_else.3423:
	jlt	%g8, %g3, jle_else.3424
	jne	%g8, %g3, jeq_else.3425
	mov	%g3, %g5
	return
jeq_else.3425:
	add	%g6, %g7, %g5
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g5, %g7
	jlt	%g28, %g9, jle_else.3426
	mov	%g3, %g7
	return
jle_else.3426:
	jlt	%g8, %g3, jle_else.3427
	jne	%g8, %g3, jeq_else.3428
	mov	%g3, %g6
	return
jeq_else.3428:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.3429
	mov	%g3, %g7
	return
jle_else.3429:
	jlt	%g8, %g3, jle_else.3430
	jne	%g8, %g3, jeq_else.3431
	mov	%g3, %g5
	return
jeq_else.3431:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.462
jle_else.3430:
	jmp	div_binary_search.462
jle_else.3427:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.3432
	mov	%g3, %g6
	return
jle_else.3432:
	jlt	%g8, %g3, jle_else.3433
	jne	%g8, %g3, jeq_else.3434
	mov	%g3, %g7
	return
jeq_else.3434:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.462
jle_else.3433:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.462
jle_else.3424:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.3435
	mov	%g3, %g5
	return
jle_else.3435:
	jlt	%g8, %g3, jle_else.3436
	jne	%g8, %g3, jeq_else.3437
	mov	%g3, %g7
	return
jeq_else.3437:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.3438
	mov	%g3, %g5
	return
jle_else.3438:
	jlt	%g8, %g3, jle_else.3439
	jne	%g8, %g3, jeq_else.3440
	mov	%g3, %g6
	return
jeq_else.3440:
	jmp	div_binary_search.462
jle_else.3439:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.462
jle_else.3436:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.3441
	mov	%g3, %g7
	return
jle_else.3441:
	jlt	%g8, %g3, jle_else.3442
	jne	%g8, %g3, jeq_else.3443
	mov	%g3, %g5
	return
jeq_else.3443:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.462
jle_else.3442:
	jmp	div_binary_search.462
print_int.467:
	jlt	%g3, %g0, jge_else.3444
	mvhi	%g10, 1525
	mvlo	%g10, 57600
	jlt	%g10, %g3, jle_else.3445
	jne	%g10, %g3, jeq_else.3447
	addi	%g10, %g0, 1
	jmp	jeq_cont.3448
jeq_else.3447:
	addi	%g10, %g0, 0
jeq_cont.3448:
	jmp	jle_cont.3446
jle_else.3445:
	mvhi	%g10, 3051
	mvlo	%g10, 49664
	jlt	%g10, %g3, jle_else.3449
	jne	%g10, %g3, jeq_else.3451
	addi	%g10, %g0, 2
	jmp	jeq_cont.3452
jeq_else.3451:
	addi	%g10, %g0, 1
jeq_cont.3452:
	jmp	jle_cont.3450
jle_else.3449:
	addi	%g10, %g0, 2
jle_cont.3450:
jle_cont.3446:
	mvhi	%g11, 1525
	mvlo	%g11, 57600
	mul	%g11, %g10, %g11
	sub	%g3, %g3, %g11
	st	%g3, %g1, 0
	jlt	%g0, %g10, jle_else.3453
	addi	%g3, %g0, 0
	jmp	jle_cont.3454
jle_else.3453:
	addi	%g11, %g0, 48
	add	%g10, %g11, %g10
	output	%g10
	addi	%g3, %g0, 1
jle_cont.3454:
	mvhi	%g4, 152
	mvlo	%g4, 38528
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g10, %g0, 5
	mvhi	%g11, 762
	mvlo	%g11, 61568
	ld	%g12, %g1, 0
	st	%g3, %g1, 4
	jlt	%g11, %g12, jle_else.3455
	jne	%g11, %g12, jeq_else.3457
	addi	%g3, %g0, 5
	jmp	jeq_cont.3458
jeq_else.3457:
	addi	%g6, %g0, 2
	mvhi	%g11, 305
	mvlo	%g11, 11520
	jlt	%g11, %g12, jle_else.3459
	jne	%g11, %g12, jeq_else.3461
	addi	%g3, %g0, 2
	jmp	jeq_cont.3462
jeq_else.3461:
	addi	%g10, %g0, 1
	mvhi	%g11, 152
	mvlo	%g11, 38528
	jlt	%g11, %g12, jle_else.3463
	jne	%g11, %g12, jeq_else.3465
	addi	%g3, %g0, 1
	jmp	jeq_cont.3466
jeq_else.3465:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jeq_cont.3466:
	jmp	jle_cont.3464
jle_else.3463:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jle_cont.3464:
jeq_cont.3462:
	jmp	jle_cont.3460
jle_else.3459:
	addi	%g5, %g0, 3
	mvhi	%g11, 457
	mvlo	%g11, 50048
	jlt	%g11, %g12, jle_else.3467
	jne	%g11, %g12, jeq_else.3469
	addi	%g3, %g0, 3
	jmp	jeq_cont.3470
jeq_else.3469:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jeq_cont.3470:
	jmp	jle_cont.3468
jle_else.3467:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jle_cont.3468:
jle_cont.3460:
jeq_cont.3458:
	jmp	jle_cont.3456
jle_else.3455:
	addi	%g5, %g0, 7
	mvhi	%g11, 1068
	mvlo	%g11, 7552
	jlt	%g11, %g12, jle_else.3471
	jne	%g11, %g12, jeq_else.3473
	addi	%g3, %g0, 7
	jmp	jeq_cont.3474
jeq_else.3473:
	addi	%g6, %g0, 6
	mvhi	%g11, 915
	mvlo	%g11, 34560
	jlt	%g11, %g12, jle_else.3475
	jne	%g11, %g12, jeq_else.3477
	addi	%g3, %g0, 6
	jmp	jeq_cont.3478
jeq_else.3477:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jeq_cont.3478:
	jmp	jle_cont.3476
jle_else.3475:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jle_cont.3476:
jeq_cont.3474:
	jmp	jle_cont.3472
jle_else.3471:
	addi	%g10, %g0, 8
	mvhi	%g11, 1220
	mvlo	%g11, 46080
	jlt	%g11, %g12, jle_else.3479
	jne	%g11, %g12, jeq_else.3481
	addi	%g3, %g0, 8
	jmp	jeq_cont.3482
jeq_else.3481:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jeq_cont.3482:
	jmp	jle_cont.3480
jle_else.3479:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jle_cont.3480:
jle_cont.3472:
jle_cont.3456:
	mvhi	%g10, 152
	mvlo	%g10, 38528
	mul	%g10, %g3, %g10
	sub	%g10, %g12, %g10
	jlt	%g0, %g3, jle_else.3483
	ld	%g11, %g1, 4
	jne	%g11, %g0, jeq_else.3485
	addi	%g3, %g0, 0
	jmp	jeq_cont.3486
jeq_else.3485:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.3486:
	jmp	jle_cont.3484
jle_else.3483:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.3484:
	mvhi	%g4, 15
	mvlo	%g4, 16960
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 76
	mvlo	%g12, 19264
	st	%g3, %g1, 8
	jlt	%g12, %g10, jle_else.3487
	jne	%g12, %g10, jeq_else.3489
	addi	%g3, %g0, 5
	jmp	jeq_cont.3490
jeq_else.3489:
	addi	%g6, %g0, 2
	mvhi	%g12, 30
	mvlo	%g12, 33920
	jlt	%g12, %g10, jle_else.3491
	jne	%g12, %g10, jeq_else.3493
	addi	%g3, %g0, 2
	jmp	jeq_cont.3494
jeq_else.3493:
	addi	%g11, %g0, 1
	mvhi	%g12, 15
	mvlo	%g12, 16960
	jlt	%g12, %g10, jle_else.3495
	jne	%g12, %g10, jeq_else.3497
	addi	%g3, %g0, 1
	jmp	jeq_cont.3498
jeq_else.3497:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jeq_cont.3498:
	jmp	jle_cont.3496
jle_else.3495:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jle_cont.3496:
jeq_cont.3494:
	jmp	jle_cont.3492
jle_else.3491:
	addi	%g5, %g0, 3
	mvhi	%g12, 45
	mvlo	%g12, 50880
	jlt	%g12, %g10, jle_else.3499
	jne	%g12, %g10, jeq_else.3501
	addi	%g3, %g0, 3
	jmp	jeq_cont.3502
jeq_else.3501:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jeq_cont.3502:
	jmp	jle_cont.3500
jle_else.3499:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jle_cont.3500:
jle_cont.3492:
jeq_cont.3490:
	jmp	jle_cont.3488
jle_else.3487:
	addi	%g5, %g0, 7
	mvhi	%g12, 106
	mvlo	%g12, 53184
	jlt	%g12, %g10, jle_else.3503
	jne	%g12, %g10, jeq_else.3505
	addi	%g3, %g0, 7
	jmp	jeq_cont.3506
jeq_else.3505:
	addi	%g6, %g0, 6
	mvhi	%g12, 91
	mvlo	%g12, 36224
	jlt	%g12, %g10, jle_else.3507
	jne	%g12, %g10, jeq_else.3509
	addi	%g3, %g0, 6
	jmp	jeq_cont.3510
jeq_else.3509:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jeq_cont.3510:
	jmp	jle_cont.3508
jle_else.3507:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jle_cont.3508:
jeq_cont.3506:
	jmp	jle_cont.3504
jle_else.3503:
	addi	%g11, %g0, 8
	mvhi	%g12, 122
	mvlo	%g12, 4608
	jlt	%g12, %g10, jle_else.3511
	jne	%g12, %g10, jeq_else.3513
	addi	%g3, %g0, 8
	jmp	jeq_cont.3514
jeq_else.3513:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jeq_cont.3514:
	jmp	jle_cont.3512
jle_else.3511:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.462
	addi	%g1, %g1, 16
jle_cont.3512:
jle_cont.3504:
jle_cont.3488:
	mvhi	%g11, 15
	mvlo	%g11, 16960
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.3515
	ld	%g11, %g1, 8
	jne	%g11, %g0, jeq_else.3517
	addi	%g3, %g0, 0
	jmp	jeq_cont.3518
jeq_else.3517:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.3518:
	jmp	jle_cont.3516
jle_else.3515:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.3516:
	mvhi	%g4, 1
	mvlo	%g4, 34464
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 7
	mvlo	%g12, 41248
	st	%g3, %g1, 12
	jlt	%g12, %g10, jle_else.3519
	jne	%g12, %g10, jeq_else.3521
	addi	%g3, %g0, 5
	jmp	jeq_cont.3522
jeq_else.3521:
	addi	%g6, %g0, 2
	mvhi	%g12, 3
	mvlo	%g12, 3392
	jlt	%g12, %g10, jle_else.3523
	jne	%g12, %g10, jeq_else.3525
	addi	%g3, %g0, 2
	jmp	jeq_cont.3526
jeq_else.3525:
	addi	%g11, %g0, 1
	mvhi	%g12, 1
	mvlo	%g12, 34464
	jlt	%g12, %g10, jle_else.3527
	jne	%g12, %g10, jeq_else.3529
	addi	%g3, %g0, 1
	jmp	jeq_cont.3530
jeq_else.3529:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jeq_cont.3530:
	jmp	jle_cont.3528
jle_else.3527:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jle_cont.3528:
jeq_cont.3526:
	jmp	jle_cont.3524
jle_else.3523:
	addi	%g5, %g0, 3
	mvhi	%g12, 4
	mvlo	%g12, 37856
	jlt	%g12, %g10, jle_else.3531
	jne	%g12, %g10, jeq_else.3533
	addi	%g3, %g0, 3
	jmp	jeq_cont.3534
jeq_else.3533:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jeq_cont.3534:
	jmp	jle_cont.3532
jle_else.3531:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jle_cont.3532:
jle_cont.3524:
jeq_cont.3522:
	jmp	jle_cont.3520
jle_else.3519:
	addi	%g5, %g0, 7
	mvhi	%g12, 10
	mvlo	%g12, 44640
	jlt	%g12, %g10, jle_else.3535
	jne	%g12, %g10, jeq_else.3537
	addi	%g3, %g0, 7
	jmp	jeq_cont.3538
jeq_else.3537:
	addi	%g6, %g0, 6
	mvhi	%g12, 9
	mvlo	%g12, 10176
	jlt	%g12, %g10, jle_else.3539
	jne	%g12, %g10, jeq_else.3541
	addi	%g3, %g0, 6
	jmp	jeq_cont.3542
jeq_else.3541:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jeq_cont.3542:
	jmp	jle_cont.3540
jle_else.3539:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jle_cont.3540:
jeq_cont.3538:
	jmp	jle_cont.3536
jle_else.3535:
	addi	%g11, %g0, 8
	mvhi	%g12, 12
	mvlo	%g12, 13568
	jlt	%g12, %g10, jle_else.3543
	jne	%g12, %g10, jeq_else.3545
	addi	%g3, %g0, 8
	jmp	jeq_cont.3546
jeq_else.3545:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jeq_cont.3546:
	jmp	jle_cont.3544
jle_else.3543:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jle_cont.3544:
jle_cont.3536:
jle_cont.3520:
	mvhi	%g11, 1
	mvlo	%g11, 34464
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.3547
	ld	%g11, %g1, 12
	jne	%g11, %g0, jeq_else.3549
	addi	%g3, %g0, 0
	jmp	jeq_cont.3550
jeq_else.3549:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.3550:
	jmp	jle_cont.3548
jle_else.3547:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.3548:
	addi	%g4, %g0, 10000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 0
	mvlo	%g12, 50000
	st	%g3, %g1, 16
	jlt	%g12, %g10, jle_else.3551
	jne	%g12, %g10, jeq_else.3553
	addi	%g3, %g0, 5
	jmp	jeq_cont.3554
jeq_else.3553:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20000
	jlt	%g12, %g10, jle_else.3555
	jne	%g12, %g10, jeq_else.3557
	addi	%g3, %g0, 2
	jmp	jeq_cont.3558
jeq_else.3557:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10000
	jlt	%g12, %g10, jle_else.3559
	jne	%g12, %g10, jeq_else.3561
	addi	%g3, %g0, 1
	jmp	jeq_cont.3562
jeq_else.3561:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jeq_cont.3562:
	jmp	jle_cont.3560
jle_else.3559:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jle_cont.3560:
jeq_cont.3558:
	jmp	jle_cont.3556
jle_else.3555:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30000
	jlt	%g12, %g10, jle_else.3563
	jne	%g12, %g10, jeq_else.3565
	addi	%g3, %g0, 3
	jmp	jeq_cont.3566
jeq_else.3565:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jeq_cont.3566:
	jmp	jle_cont.3564
jle_else.3563:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jle_cont.3564:
jle_cont.3556:
jeq_cont.3554:
	jmp	jle_cont.3552
jle_else.3551:
	addi	%g5, %g0, 7
	mvhi	%g12, 1
	mvlo	%g12, 4464
	jlt	%g12, %g10, jle_else.3567
	jne	%g12, %g10, jeq_else.3569
	addi	%g3, %g0, 7
	jmp	jeq_cont.3570
jeq_else.3569:
	addi	%g6, %g0, 6
	mvhi	%g12, 0
	mvlo	%g12, 60000
	jlt	%g12, %g10, jle_else.3571
	jne	%g12, %g10, jeq_else.3573
	addi	%g3, %g0, 6
	jmp	jeq_cont.3574
jeq_else.3573:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jeq_cont.3574:
	jmp	jle_cont.3572
jle_else.3571:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jle_cont.3572:
jeq_cont.3570:
	jmp	jle_cont.3568
jle_else.3567:
	addi	%g11, %g0, 8
	mvhi	%g12, 1
	mvlo	%g12, 14464
	jlt	%g12, %g10, jle_else.3575
	jne	%g12, %g10, jeq_else.3577
	addi	%g3, %g0, 8
	jmp	jeq_cont.3578
jeq_else.3577:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jeq_cont.3578:
	jmp	jle_cont.3576
jle_else.3575:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.462
	addi	%g1, %g1, 24
jle_cont.3576:
jle_cont.3568:
jle_cont.3552:
	addi	%g11, %g0, 10000
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.3579
	ld	%g11, %g1, 16
	jne	%g11, %g0, jeq_else.3581
	addi	%g3, %g0, 0
	jmp	jeq_cont.3582
jeq_else.3581:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.3582:
	jmp	jle_cont.3580
jle_else.3579:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.3580:
	addi	%g4, %g0, 1000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 5000
	st	%g3, %g1, 20
	jlt	%g12, %g10, jle_else.3583
	jne	%g12, %g10, jeq_else.3585
	addi	%g3, %g0, 5
	jmp	jeq_cont.3586
jeq_else.3585:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 2000
	jlt	%g12, %g10, jle_else.3587
	jne	%g12, %g10, jeq_else.3589
	addi	%g3, %g0, 2
	jmp	jeq_cont.3590
jeq_else.3589:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 1000
	jlt	%g12, %g10, jle_else.3591
	jne	%g12, %g10, jeq_else.3593
	addi	%g3, %g0, 1
	jmp	jeq_cont.3594
jeq_else.3593:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jeq_cont.3594:
	jmp	jle_cont.3592
jle_else.3591:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jle_cont.3592:
jeq_cont.3590:
	jmp	jle_cont.3588
jle_else.3587:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 3000
	jlt	%g12, %g10, jle_else.3595
	jne	%g12, %g10, jeq_else.3597
	addi	%g3, %g0, 3
	jmp	jeq_cont.3598
jeq_else.3597:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jeq_cont.3598:
	jmp	jle_cont.3596
jle_else.3595:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jle_cont.3596:
jle_cont.3588:
jeq_cont.3586:
	jmp	jle_cont.3584
jle_else.3583:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 7000
	jlt	%g12, %g10, jle_else.3599
	jne	%g12, %g10, jeq_else.3601
	addi	%g3, %g0, 7
	jmp	jeq_cont.3602
jeq_else.3601:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 6000
	jlt	%g12, %g10, jle_else.3603
	jne	%g12, %g10, jeq_else.3605
	addi	%g3, %g0, 6
	jmp	jeq_cont.3606
jeq_else.3605:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jeq_cont.3606:
	jmp	jle_cont.3604
jle_else.3603:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jle_cont.3604:
jeq_cont.3602:
	jmp	jle_cont.3600
jle_else.3599:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 8000
	jlt	%g12, %g10, jle_else.3607
	jne	%g12, %g10, jeq_else.3609
	addi	%g3, %g0, 8
	jmp	jeq_cont.3610
jeq_else.3609:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jeq_cont.3610:
	jmp	jle_cont.3608
jle_else.3607:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jle_cont.3608:
jle_cont.3600:
jle_cont.3584:
	muli	%g11, %g3, 1000
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.3611
	ld	%g11, %g1, 20
	jne	%g11, %g0, jeq_else.3613
	addi	%g3, %g0, 0
	jmp	jeq_cont.3614
jeq_else.3613:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.3614:
	jmp	jle_cont.3612
jle_else.3611:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.3612:
	addi	%g4, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 500
	st	%g3, %g1, 24
	jlt	%g12, %g10, jle_else.3615
	jne	%g12, %g10, jeq_else.3617
	addi	%g3, %g0, 5
	jmp	jeq_cont.3618
jeq_else.3617:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 200
	jlt	%g12, %g10, jle_else.3619
	jne	%g12, %g10, jeq_else.3621
	addi	%g3, %g0, 2
	jmp	jeq_cont.3622
jeq_else.3621:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 100
	jlt	%g12, %g10, jle_else.3623
	jne	%g12, %g10, jeq_else.3625
	addi	%g3, %g0, 1
	jmp	jeq_cont.3626
jeq_else.3625:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jeq_cont.3626:
	jmp	jle_cont.3624
jle_else.3623:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jle_cont.3624:
jeq_cont.3622:
	jmp	jle_cont.3620
jle_else.3619:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 300
	jlt	%g12, %g10, jle_else.3627
	jne	%g12, %g10, jeq_else.3629
	addi	%g3, %g0, 3
	jmp	jeq_cont.3630
jeq_else.3629:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jeq_cont.3630:
	jmp	jle_cont.3628
jle_else.3627:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jle_cont.3628:
jle_cont.3620:
jeq_cont.3618:
	jmp	jle_cont.3616
jle_else.3615:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 700
	jlt	%g12, %g10, jle_else.3631
	jne	%g12, %g10, jeq_else.3633
	addi	%g3, %g0, 7
	jmp	jeq_cont.3634
jeq_else.3633:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 600
	jlt	%g12, %g10, jle_else.3635
	jne	%g12, %g10, jeq_else.3637
	addi	%g3, %g0, 6
	jmp	jeq_cont.3638
jeq_else.3637:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jeq_cont.3638:
	jmp	jle_cont.3636
jle_else.3635:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jle_cont.3636:
jeq_cont.3634:
	jmp	jle_cont.3632
jle_else.3631:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 800
	jlt	%g12, %g10, jle_else.3639
	jne	%g12, %g10, jeq_else.3641
	addi	%g3, %g0, 8
	jmp	jeq_cont.3642
jeq_else.3641:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jeq_cont.3642:
	jmp	jle_cont.3640
jle_else.3639:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.462
	addi	%g1, %g1, 32
jle_cont.3640:
jle_cont.3632:
jle_cont.3616:
	muli	%g11, %g3, 100
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.3643
	ld	%g11, %g1, 24
	jne	%g11, %g0, jeq_else.3645
	addi	%g3, %g0, 0
	jmp	jeq_cont.3646
jeq_else.3645:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.3646:
	jmp	jle_cont.3644
jle_else.3643:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.3644:
	addi	%g4, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 50
	st	%g3, %g1, 28
	jlt	%g12, %g10, jle_else.3647
	jne	%g12, %g10, jeq_else.3649
	addi	%g3, %g0, 5
	jmp	jeq_cont.3650
jeq_else.3649:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20
	jlt	%g12, %g10, jle_else.3651
	jne	%g12, %g10, jeq_else.3653
	addi	%g3, %g0, 2
	jmp	jeq_cont.3654
jeq_else.3653:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10
	jlt	%g12, %g10, jle_else.3655
	jne	%g12, %g10, jeq_else.3657
	addi	%g3, %g0, 1
	jmp	jeq_cont.3658
jeq_else.3657:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.462
	addi	%g1, %g1, 40
jeq_cont.3658:
	jmp	jle_cont.3656
jle_else.3655:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.462
	addi	%g1, %g1, 40
jle_cont.3656:
jeq_cont.3654:
	jmp	jle_cont.3652
jle_else.3651:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30
	jlt	%g12, %g10, jle_else.3659
	jne	%g12, %g10, jeq_else.3661
	addi	%g3, %g0, 3
	jmp	jeq_cont.3662
jeq_else.3661:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.462
	addi	%g1, %g1, 40
jeq_cont.3662:
	jmp	jle_cont.3660
jle_else.3659:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.462
	addi	%g1, %g1, 40
jle_cont.3660:
jle_cont.3652:
jeq_cont.3650:
	jmp	jle_cont.3648
jle_else.3647:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 70
	jlt	%g12, %g10, jle_else.3663
	jne	%g12, %g10, jeq_else.3665
	addi	%g3, %g0, 7
	jmp	jeq_cont.3666
jeq_else.3665:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 60
	jlt	%g12, %g10, jle_else.3667
	jne	%g12, %g10, jeq_else.3669
	addi	%g3, %g0, 6
	jmp	jeq_cont.3670
jeq_else.3669:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.462
	addi	%g1, %g1, 40
jeq_cont.3670:
	jmp	jle_cont.3668
jle_else.3667:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.462
	addi	%g1, %g1, 40
jle_cont.3668:
jeq_cont.3666:
	jmp	jle_cont.3664
jle_else.3663:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 80
	jlt	%g12, %g10, jle_else.3671
	jne	%g12, %g10, jeq_else.3673
	addi	%g3, %g0, 8
	jmp	jeq_cont.3674
jeq_else.3673:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.462
	addi	%g1, %g1, 40
jeq_cont.3674:
	jmp	jle_cont.3672
jle_else.3671:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.462
	addi	%g1, %g1, 40
jle_cont.3672:
jle_cont.3664:
jle_cont.3648:
	muli	%g11, %g3, 10
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.3675
	ld	%g11, %g1, 28
	jne	%g11, %g0, jeq_else.3677
	addi	%g3, %g0, 0
	jmp	jeq_cont.3678
jeq_else.3677:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.3678:
	jmp	jle_cont.3676
jle_else.3675:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.3676:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g10
	output	%g3
	return
jge_else.3444:
	addi	%g10, %g0, 45
	st	%g3, %g1, 32
	output	%g10
	ld	%g3, %g1, 32
	sub	%g3, %g0, %g3
	jmp	print_int.467
loop1.597.1556:
	ld	%g4, %g27, -12
	ld	%g5, %g27, -8
	ld	%g6, %g27, -4
	jlt	%g3, %g0, jge_else.3679
	slli	%g7, %g3, 2
	add	%g26, %g6, %g7
	ld	%g7, %g26, 0
	fld	%f0, %g7, -4
	slli	%g8, %g3, 2
	add	%g26, %g4, %g8
	ld	%g8, %g26, 0
	fld	%f1, %g8, -8
	ld	%g8, %g5, -8
	fld	%f2, %g8, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g7, -4
	slli	%g7, %g3, 2
	add	%g26, %g6, %g7
	ld	%g7, %g26, 0
	fld	%f0, %g7, -4
	slli	%g8, %g3, 2
	add	%g26, %g4, %g8
	ld	%g8, %g26, 0
	fld	%f1, %g8, -4
	ld	%g8, %g5, -4
	fld	%f2, %g8, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g7, -4
	slli	%g7, %g3, 2
	add	%g26, %g6, %g7
	ld	%g7, %g26, 0
	fld	%f0, %g7, -4
	slli	%g8, %g3, 2
	add	%g26, %g4, %g8
	ld	%g8, %g26, 0
	fld	%f1, %g8, 0
	ld	%g8, %g5, 0
	fld	%f2, %g8, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g7, -4
	slli	%g7, %g3, 2
	add	%g26, %g6, %g7
	ld	%g7, %g26, 0
	fld	%f0, %g7, 0
	slli	%g8, %g3, 2
	add	%g26, %g4, %g8
	ld	%g8, %g26, 0
	fld	%f1, %g8, -8
	ld	%g8, %g5, -8
	fld	%f2, %g8, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g7, 0
	slli	%g7, %g3, 2
	add	%g26, %g6, %g7
	ld	%g7, %g26, 0
	fld	%f0, %g7, 0
	slli	%g8, %g3, 2
	add	%g26, %g4, %g8
	ld	%g8, %g26, 0
	fld	%f1, %g8, -4
	ld	%g8, %g5, -4
	fld	%f2, %g8, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g7, 0
	slli	%g7, %g3, 2
	add	%g26, %g6, %g7
	ld	%g7, %g26, 0
	fld	%f0, %g7, 0
	slli	%g8, %g3, 2
	add	%g26, %g4, %g8
	ld	%g8, %g26, 0
	fld	%f1, %g8, 0
	ld	%g8, %g5, 0
	fld	%f2, %g8, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g7, 0
	subi	%g3, %g3, 1
	jlt	%g3, %g0, jge_else.3680
	slli	%g7, %g3, 2
	add	%g26, %g6, %g7
	ld	%g7, %g26, 0
	fld	%f0, %g7, -4
	slli	%g8, %g3, 2
	add	%g26, %g4, %g8
	ld	%g8, %g26, 0
	fld	%f1, %g8, -8
	ld	%g8, %g5, -8
	fld	%f2, %g8, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g7, -4
	slli	%g7, %g3, 2
	add	%g26, %g6, %g7
	ld	%g7, %g26, 0
	fld	%f0, %g7, -4
	slli	%g8, %g3, 2
	add	%g26, %g4, %g8
	ld	%g8, %g26, 0
	fld	%f1, %g8, -4
	ld	%g8, %g5, -4
	fld	%f2, %g8, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g7, -4
	slli	%g7, %g3, 2
	add	%g26, %g6, %g7
	ld	%g7, %g26, 0
	fld	%f0, %g7, -4
	slli	%g8, %g3, 2
	add	%g26, %g4, %g8
	ld	%g8, %g26, 0
	fld	%f1, %g8, 0
	ld	%g8, %g5, 0
	fld	%f2, %g8, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g7, -4
	slli	%g7, %g3, 2
	add	%g26, %g6, %g7
	ld	%g7, %g26, 0
	fld	%f0, %g7, 0
	slli	%g8, %g3, 2
	add	%g26, %g4, %g8
	ld	%g8, %g26, 0
	fld	%f1, %g8, -8
	ld	%g8, %g5, -8
	fld	%f2, %g8, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g7, 0
	slli	%g7, %g3, 2
	add	%g26, %g6, %g7
	ld	%g7, %g26, 0
	fld	%f0, %g7, 0
	slli	%g8, %g3, 2
	add	%g26, %g4, %g8
	ld	%g8, %g26, 0
	fld	%f1, %g8, -4
	ld	%g8, %g5, -4
	fld	%f2, %g8, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g7, 0
	slli	%g7, %g3, 2
	add	%g26, %g6, %g7
	ld	%g6, %g26, 0
	fld	%f0, %g6, 0
	slli	%g7, %g3, 2
	add	%g26, %g4, %g7
	ld	%g4, %g26, 0
	fld	%f1, %g4, 0
	ld	%g4, %g5, 0
	fld	%f2, %g4, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g6, 0
	subi	%g3, %g3, 1
	ld	%g26, %g27, 0
	b	%g26
jge_else.3680:
	return
jge_else.3679:
	return
min_caml_start:
	addi	%g28, %g0, 1
	addi	%g29, %g0, -1
	setL %g26, l.3027
	fld	%f16, %g26, 0
	setL %g26, l.3022
	fld	%f17, %g26, 0
	setL %g26, l.3017
	fld	%f18, %g26, 0
	setL %g26, l.3012
	fld	%f19, %g26, 0
	setL %g26, l.3007
	fld	%f20, %g26, 0
	setL %g26, l.3002
	fld	%f21, %g26, 0
	setL %g26, l.2997
	fld	%f22, %g26, 0
	setL %g26, l.2992
	fld	%f23, %g26, 0
	setL %g26, l.2987
	fld	%f24, %g26, 0
	setL %g26, l.2982
	fld	%f25, %g26, 0
	setL %g26, l.2974
	fld	%f26, %g26, 0
	setL %g26, l.2963
	fld	%f27, %g26, 0
	setL %g26, l.2961
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
	fmov	%f0, %f26
	fst	%f0, %g3, 0
	ld	%g3, %g11, 0
	fld	%f0, %g1, 0
	fst	%f0, %g3, -4
	ld	%g3, %g11, 0
	fmov	%f0, %f25
	fst	%f0, %g3, -8
	ld	%g3, %g11, -4
	fmov	%f0, %f24
	fst	%f0, %g3, 0
	ld	%g3, %g11, -4
	fmov	%f0, %f23
	fst	%f0, %g3, -4
	ld	%g3, %g11, -4
	fmov	%f0, %f22
	fst	%f0, %g3, -8
	ld	%g3, %g13, 0
	fmov	%f0, %f21
	fst	%f0, %g3, 0
	ld	%g3, %g13, 0
	fmov	%f0, %f20
	fst	%f0, %g3, -4
	ld	%g3, %g13, -4
	fmov	%f0, %f19
	fst	%f0, %g3, 0
	ld	%g3, %g13, -4
	fmov	%f0, %f18
	fst	%f0, %g3, -4
	ld	%g3, %g13, -8
	fmov	%f0, %f17
	fst	%f0, %g3, 0
	ld	%g3, %g13, -8
	fmov	%f0, %f16
	fst	%f0, %g3, -4
	mov	%g27, %g2
	addi	%g2, %g2, 16
	setL %g3, loop1.597.1556
	st	%g3, %g27, 0
	st	%g11, %g27, -12
	st	%g13, %g27, -8
	st	%g12, %g27, -4
	ld	%g3, %g12, -4
	fld	%f0, %g3, -4
	ld	%g4, %g11, -4
	fld	%f1, %g4, -8
	ld	%g4, %g13, -8
	fld	%f2, %g4, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, -4
	ld	%g3, %g12, -4
	fld	%f0, %g3, -4
	ld	%g4, %g11, -4
	fld	%f1, %g4, -4
	ld	%g4, %g13, -4
	fld	%f2, %g4, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, -4
	ld	%g3, %g12, -4
	fld	%f0, %g3, -4
	ld	%g4, %g11, -4
	fld	%f1, %g4, 0
	ld	%g4, %g13, 0
	fld	%f2, %g4, -4
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, -4
	ld	%g3, %g12, -4
	fld	%f0, %g3, 0
	ld	%g4, %g11, -4
	fld	%f1, %g4, -8
	ld	%g4, %g13, -8
	fld	%f2, %g4, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, 0
	ld	%g3, %g12, -4
	fld	%f0, %g3, 0
	ld	%g4, %g11, -4
	fld	%f1, %g4, -4
	ld	%g4, %g13, -4
	fld	%f2, %g4, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, 0
	ld	%g3, %g12, -4
	fld	%f0, %g3, 0
	ld	%g4, %g11, -4
	fld	%f1, %g4, 0
	ld	%g4, %g13, 0
	fld	%f2, %g4, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, 0
	addi	%g3, %g0, 0
	ld	%g26, %g27, 0
	subi	%g1, %g1, 32
	callR	%g26
	addi	%g1, %g1, 32
	ld	%g10, %g1, 24
	ld	%g11, %g10, 0
	fld	%f0, %g11, 0
	subi	%g1, %g1, 32
	call	min_caml_truncate
	addi	%g1, %g1, 32
	subi	%g1, %g1, 32
	call	print_int.467
	addi	%g1, %g1, 32
	st	%g3, %g1, 32
	addi	%g3, %g0, 10
	output	%g3
	ld	%g3, %g1, 32
	ld	%g10, %g1, 24
	ld	%g11, %g10, 0
	fld	%f0, %g11, -4
	subi	%g1, %g1, 32
	call	min_caml_truncate
	addi	%g1, %g1, 32
	subi	%g1, %g1, 32
	call	print_int.467
	addi	%g1, %g1, 32
	st	%g3, %g1, 32
	addi	%g3, %g0, 10
	output	%g3
	ld	%g3, %g1, 32
	ld	%g10, %g1, 24
	ld	%g11, %g10, -4
	fld	%f0, %g11, 0
	subi	%g1, %g1, 32
	call	min_caml_truncate
	addi	%g1, %g1, 32
	subi	%g1, %g1, 32
	call	print_int.467
	addi	%g1, %g1, 32
	st	%g3, %g1, 32
	addi	%g3, %g0, 10
	output	%g3
	ld	%g3, %g1, 32
	ld	%g10, %g1, 24
	ld	%g10, %g10, -4
	fld	%f0, %g10, -4
	subi	%g1, %g1, 32
	call	min_caml_truncate
	addi	%g1, %g1, 32
	subi	%g1, %g1, 32
	call	print_int.467
	addi	%g1, %g1, 32
	st	%g3, %g1, 32
	addi	%g3, %g0, 10
	output	%g3
	ld	%g3, %g1, 32
	halt
