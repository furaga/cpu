.init_heap_size	192
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
div_binary_search.332:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.2383
	mov	%g3, %g5
	return
jle_else.2383:
	jlt	%g8, %g3, jle_else.2384
	jne	%g8, %g3, jeq_else.2385
	mov	%g3, %g7
	return
jeq_else.2385:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.2386
	mov	%g3, %g5
	return
jle_else.2386:
	jlt	%g8, %g3, jle_else.2387
	jne	%g8, %g3, jeq_else.2388
	mov	%g3, %g6
	return
jeq_else.2388:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.2389
	mov	%g3, %g5
	return
jle_else.2389:
	jlt	%g8, %g3, jle_else.2390
	jne	%g8, %g3, jeq_else.2391
	mov	%g3, %g7
	return
jeq_else.2391:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.2392
	mov	%g3, %g5
	return
jle_else.2392:
	jlt	%g8, %g3, jle_else.2393
	jne	%g8, %g3, jeq_else.2394
	mov	%g3, %g6
	return
jeq_else.2394:
	jmp	div_binary_search.332
jle_else.2393:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.332
jle_else.2390:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.2395
	mov	%g3, %g7
	return
jle_else.2395:
	jlt	%g8, %g3, jle_else.2396
	jne	%g8, %g3, jeq_else.2397
	mov	%g3, %g5
	return
jeq_else.2397:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.332
jle_else.2396:
	jmp	div_binary_search.332
jle_else.2387:
	add	%g5, %g6, %g7
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g7, %g6
	jlt	%g28, %g9, jle_else.2398
	mov	%g3, %g6
	return
jle_else.2398:
	jlt	%g8, %g3, jle_else.2399
	jne	%g8, %g3, jeq_else.2400
	mov	%g3, %g5
	return
jeq_else.2400:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.2401
	mov	%g3, %g6
	return
jle_else.2401:
	jlt	%g8, %g3, jle_else.2402
	jne	%g8, %g3, jeq_else.2403
	mov	%g3, %g7
	return
jeq_else.2403:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.332
jle_else.2402:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.332
jle_else.2399:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.2404
	mov	%g3, %g5
	return
jle_else.2404:
	jlt	%g8, %g3, jle_else.2405
	jne	%g8, %g3, jeq_else.2406
	mov	%g3, %g6
	return
jeq_else.2406:
	jmp	div_binary_search.332
jle_else.2405:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.332
jle_else.2384:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.2407
	mov	%g3, %g7
	return
jle_else.2407:
	jlt	%g8, %g3, jle_else.2408
	jne	%g8, %g3, jeq_else.2409
	mov	%g3, %g5
	return
jeq_else.2409:
	add	%g6, %g7, %g5
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g5, %g7
	jlt	%g28, %g9, jle_else.2410
	mov	%g3, %g7
	return
jle_else.2410:
	jlt	%g8, %g3, jle_else.2411
	jne	%g8, %g3, jeq_else.2412
	mov	%g3, %g6
	return
jeq_else.2412:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.2413
	mov	%g3, %g7
	return
jle_else.2413:
	jlt	%g8, %g3, jle_else.2414
	jne	%g8, %g3, jeq_else.2415
	mov	%g3, %g5
	return
jeq_else.2415:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.332
jle_else.2414:
	jmp	div_binary_search.332
jle_else.2411:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.2416
	mov	%g3, %g6
	return
jle_else.2416:
	jlt	%g8, %g3, jle_else.2417
	jne	%g8, %g3, jeq_else.2418
	mov	%g3, %g7
	return
jeq_else.2418:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.332
jle_else.2417:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.332
jle_else.2408:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.2419
	mov	%g3, %g5
	return
jle_else.2419:
	jlt	%g8, %g3, jle_else.2420
	jne	%g8, %g3, jeq_else.2421
	mov	%g3, %g7
	return
jeq_else.2421:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.2422
	mov	%g3, %g5
	return
jle_else.2422:
	jlt	%g8, %g3, jle_else.2423
	jne	%g8, %g3, jeq_else.2424
	mov	%g3, %g6
	return
jeq_else.2424:
	jmp	div_binary_search.332
jle_else.2423:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.332
jle_else.2420:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.2425
	mov	%g3, %g7
	return
jle_else.2425:
	jlt	%g8, %g3, jle_else.2426
	jne	%g8, %g3, jeq_else.2427
	mov	%g3, %g5
	return
jeq_else.2427:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.332
jle_else.2426:
	jmp	div_binary_search.332
print_int.337:
	jlt	%g3, %g0, jge_else.2428
	mvhi	%g10, 1525
	mvlo	%g10, 57600
	jlt	%g10, %g3, jle_else.2429
	jne	%g10, %g3, jeq_else.2431
	addi	%g10, %g0, 1
	jmp	jeq_cont.2432
jeq_else.2431:
	addi	%g10, %g0, 0
jeq_cont.2432:
	jmp	jle_cont.2430
jle_else.2429:
	mvhi	%g10, 3051
	mvlo	%g10, 49664
	jlt	%g10, %g3, jle_else.2433
	jne	%g10, %g3, jeq_else.2435
	addi	%g10, %g0, 2
	jmp	jeq_cont.2436
jeq_else.2435:
	addi	%g10, %g0, 1
jeq_cont.2436:
	jmp	jle_cont.2434
jle_else.2433:
	addi	%g10, %g0, 2
jle_cont.2434:
jle_cont.2430:
	mvhi	%g11, 1525
	mvlo	%g11, 57600
	mul	%g11, %g10, %g11
	sub	%g3, %g3, %g11
	st	%g3, %g1, 0
	jlt	%g0, %g10, jle_else.2437
	addi	%g3, %g0, 0
	jmp	jle_cont.2438
jle_else.2437:
	addi	%g11, %g0, 48
	add	%g10, %g11, %g10
	output	%g10
	addi	%g3, %g0, 1
jle_cont.2438:
	mvhi	%g4, 152
	mvlo	%g4, 38528
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g10, %g0, 5
	mvhi	%g11, 762
	mvlo	%g11, 61568
	ld	%g12, %g1, 0
	st	%g3, %g1, 4
	jlt	%g11, %g12, jle_else.2439
	jne	%g11, %g12, jeq_else.2441
	addi	%g3, %g0, 5
	jmp	jeq_cont.2442
jeq_else.2441:
	addi	%g6, %g0, 2
	mvhi	%g11, 305
	mvlo	%g11, 11520
	jlt	%g11, %g12, jle_else.2443
	jne	%g11, %g12, jeq_else.2445
	addi	%g3, %g0, 2
	jmp	jeq_cont.2446
jeq_else.2445:
	addi	%g10, %g0, 1
	mvhi	%g11, 152
	mvlo	%g11, 38528
	jlt	%g11, %g12, jle_else.2447
	jne	%g11, %g12, jeq_else.2449
	addi	%g3, %g0, 1
	jmp	jeq_cont.2450
jeq_else.2449:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.332
	addi	%g1, %g1, 16
jeq_cont.2450:
	jmp	jle_cont.2448
jle_else.2447:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.332
	addi	%g1, %g1, 16
jle_cont.2448:
jeq_cont.2446:
	jmp	jle_cont.2444
jle_else.2443:
	addi	%g5, %g0, 3
	mvhi	%g11, 457
	mvlo	%g11, 50048
	jlt	%g11, %g12, jle_else.2451
	jne	%g11, %g12, jeq_else.2453
	addi	%g3, %g0, 3
	jmp	jeq_cont.2454
jeq_else.2453:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.332
	addi	%g1, %g1, 16
jeq_cont.2454:
	jmp	jle_cont.2452
jle_else.2451:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.332
	addi	%g1, %g1, 16
jle_cont.2452:
jle_cont.2444:
jeq_cont.2442:
	jmp	jle_cont.2440
jle_else.2439:
	addi	%g5, %g0, 7
	mvhi	%g11, 1068
	mvlo	%g11, 7552
	jlt	%g11, %g12, jle_else.2455
	jne	%g11, %g12, jeq_else.2457
	addi	%g3, %g0, 7
	jmp	jeq_cont.2458
jeq_else.2457:
	addi	%g6, %g0, 6
	mvhi	%g11, 915
	mvlo	%g11, 34560
	jlt	%g11, %g12, jle_else.2459
	jne	%g11, %g12, jeq_else.2461
	addi	%g3, %g0, 6
	jmp	jeq_cont.2462
jeq_else.2461:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.332
	addi	%g1, %g1, 16
jeq_cont.2462:
	jmp	jle_cont.2460
jle_else.2459:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.332
	addi	%g1, %g1, 16
jle_cont.2460:
jeq_cont.2458:
	jmp	jle_cont.2456
jle_else.2455:
	addi	%g10, %g0, 8
	mvhi	%g11, 1220
	mvlo	%g11, 46080
	jlt	%g11, %g12, jle_else.2463
	jne	%g11, %g12, jeq_else.2465
	addi	%g3, %g0, 8
	jmp	jeq_cont.2466
jeq_else.2465:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.332
	addi	%g1, %g1, 16
jeq_cont.2466:
	jmp	jle_cont.2464
jle_else.2463:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.332
	addi	%g1, %g1, 16
jle_cont.2464:
jle_cont.2456:
jle_cont.2440:
	mvhi	%g10, 152
	mvlo	%g10, 38528
	mul	%g10, %g3, %g10
	sub	%g10, %g12, %g10
	jlt	%g0, %g3, jle_else.2467
	ld	%g11, %g1, 4
	jne	%g11, %g0, jeq_else.2469
	addi	%g3, %g0, 0
	jmp	jeq_cont.2470
jeq_else.2469:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2470:
	jmp	jle_cont.2468
jle_else.2467:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2468:
	mvhi	%g4, 15
	mvlo	%g4, 16960
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 76
	mvlo	%g12, 19264
	st	%g3, %g1, 8
	jlt	%g12, %g10, jle_else.2471
	jne	%g12, %g10, jeq_else.2473
	addi	%g3, %g0, 5
	jmp	jeq_cont.2474
jeq_else.2473:
	addi	%g6, %g0, 2
	mvhi	%g12, 30
	mvlo	%g12, 33920
	jlt	%g12, %g10, jle_else.2475
	jne	%g12, %g10, jeq_else.2477
	addi	%g3, %g0, 2
	jmp	jeq_cont.2478
jeq_else.2477:
	addi	%g11, %g0, 1
	mvhi	%g12, 15
	mvlo	%g12, 16960
	jlt	%g12, %g10, jle_else.2479
	jne	%g12, %g10, jeq_else.2481
	addi	%g3, %g0, 1
	jmp	jeq_cont.2482
jeq_else.2481:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.332
	addi	%g1, %g1, 16
jeq_cont.2482:
	jmp	jle_cont.2480
jle_else.2479:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.332
	addi	%g1, %g1, 16
jle_cont.2480:
jeq_cont.2478:
	jmp	jle_cont.2476
jle_else.2475:
	addi	%g5, %g0, 3
	mvhi	%g12, 45
	mvlo	%g12, 50880
	jlt	%g12, %g10, jle_else.2483
	jne	%g12, %g10, jeq_else.2485
	addi	%g3, %g0, 3
	jmp	jeq_cont.2486
jeq_else.2485:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.332
	addi	%g1, %g1, 16
jeq_cont.2486:
	jmp	jle_cont.2484
jle_else.2483:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.332
	addi	%g1, %g1, 16
jle_cont.2484:
jle_cont.2476:
jeq_cont.2474:
	jmp	jle_cont.2472
jle_else.2471:
	addi	%g5, %g0, 7
	mvhi	%g12, 106
	mvlo	%g12, 53184
	jlt	%g12, %g10, jle_else.2487
	jne	%g12, %g10, jeq_else.2489
	addi	%g3, %g0, 7
	jmp	jeq_cont.2490
jeq_else.2489:
	addi	%g6, %g0, 6
	mvhi	%g12, 91
	mvlo	%g12, 36224
	jlt	%g12, %g10, jle_else.2491
	jne	%g12, %g10, jeq_else.2493
	addi	%g3, %g0, 6
	jmp	jeq_cont.2494
jeq_else.2493:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.332
	addi	%g1, %g1, 16
jeq_cont.2494:
	jmp	jle_cont.2492
jle_else.2491:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.332
	addi	%g1, %g1, 16
jle_cont.2492:
jeq_cont.2490:
	jmp	jle_cont.2488
jle_else.2487:
	addi	%g11, %g0, 8
	mvhi	%g12, 122
	mvlo	%g12, 4608
	jlt	%g12, %g10, jle_else.2495
	jne	%g12, %g10, jeq_else.2497
	addi	%g3, %g0, 8
	jmp	jeq_cont.2498
jeq_else.2497:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.332
	addi	%g1, %g1, 16
jeq_cont.2498:
	jmp	jle_cont.2496
jle_else.2495:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.332
	addi	%g1, %g1, 16
jle_cont.2496:
jle_cont.2488:
jle_cont.2472:
	mvhi	%g11, 15
	mvlo	%g11, 16960
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2499
	ld	%g11, %g1, 8
	jne	%g11, %g0, jeq_else.2501
	addi	%g3, %g0, 0
	jmp	jeq_cont.2502
jeq_else.2501:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2502:
	jmp	jle_cont.2500
jle_else.2499:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2500:
	mvhi	%g4, 1
	mvlo	%g4, 34464
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 7
	mvlo	%g12, 41248
	st	%g3, %g1, 12
	jlt	%g12, %g10, jle_else.2503
	jne	%g12, %g10, jeq_else.2505
	addi	%g3, %g0, 5
	jmp	jeq_cont.2506
jeq_else.2505:
	addi	%g6, %g0, 2
	mvhi	%g12, 3
	mvlo	%g12, 3392
	jlt	%g12, %g10, jle_else.2507
	jne	%g12, %g10, jeq_else.2509
	addi	%g3, %g0, 2
	jmp	jeq_cont.2510
jeq_else.2509:
	addi	%g11, %g0, 1
	mvhi	%g12, 1
	mvlo	%g12, 34464
	jlt	%g12, %g10, jle_else.2511
	jne	%g12, %g10, jeq_else.2513
	addi	%g3, %g0, 1
	jmp	jeq_cont.2514
jeq_else.2513:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.332
	addi	%g1, %g1, 24
jeq_cont.2514:
	jmp	jle_cont.2512
jle_else.2511:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.332
	addi	%g1, %g1, 24
jle_cont.2512:
jeq_cont.2510:
	jmp	jle_cont.2508
jle_else.2507:
	addi	%g5, %g0, 3
	mvhi	%g12, 4
	mvlo	%g12, 37856
	jlt	%g12, %g10, jle_else.2515
	jne	%g12, %g10, jeq_else.2517
	addi	%g3, %g0, 3
	jmp	jeq_cont.2518
jeq_else.2517:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.332
	addi	%g1, %g1, 24
jeq_cont.2518:
	jmp	jle_cont.2516
jle_else.2515:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.332
	addi	%g1, %g1, 24
jle_cont.2516:
jle_cont.2508:
jeq_cont.2506:
	jmp	jle_cont.2504
jle_else.2503:
	addi	%g5, %g0, 7
	mvhi	%g12, 10
	mvlo	%g12, 44640
	jlt	%g12, %g10, jle_else.2519
	jne	%g12, %g10, jeq_else.2521
	addi	%g3, %g0, 7
	jmp	jeq_cont.2522
jeq_else.2521:
	addi	%g6, %g0, 6
	mvhi	%g12, 9
	mvlo	%g12, 10176
	jlt	%g12, %g10, jle_else.2523
	jne	%g12, %g10, jeq_else.2525
	addi	%g3, %g0, 6
	jmp	jeq_cont.2526
jeq_else.2525:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.332
	addi	%g1, %g1, 24
jeq_cont.2526:
	jmp	jle_cont.2524
jle_else.2523:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.332
	addi	%g1, %g1, 24
jle_cont.2524:
jeq_cont.2522:
	jmp	jle_cont.2520
jle_else.2519:
	addi	%g11, %g0, 8
	mvhi	%g12, 12
	mvlo	%g12, 13568
	jlt	%g12, %g10, jle_else.2527
	jne	%g12, %g10, jeq_else.2529
	addi	%g3, %g0, 8
	jmp	jeq_cont.2530
jeq_else.2529:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.332
	addi	%g1, %g1, 24
jeq_cont.2530:
	jmp	jle_cont.2528
jle_else.2527:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.332
	addi	%g1, %g1, 24
jle_cont.2528:
jle_cont.2520:
jle_cont.2504:
	mvhi	%g11, 1
	mvlo	%g11, 34464
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2531
	ld	%g11, %g1, 12
	jne	%g11, %g0, jeq_else.2533
	addi	%g3, %g0, 0
	jmp	jeq_cont.2534
jeq_else.2533:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2534:
	jmp	jle_cont.2532
jle_else.2531:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2532:
	addi	%g4, %g0, 10000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 0
	mvlo	%g12, 50000
	st	%g3, %g1, 16
	jlt	%g12, %g10, jle_else.2535
	jne	%g12, %g10, jeq_else.2537
	addi	%g3, %g0, 5
	jmp	jeq_cont.2538
jeq_else.2537:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20000
	jlt	%g12, %g10, jle_else.2539
	jne	%g12, %g10, jeq_else.2541
	addi	%g3, %g0, 2
	jmp	jeq_cont.2542
jeq_else.2541:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10000
	jlt	%g12, %g10, jle_else.2543
	jne	%g12, %g10, jeq_else.2545
	addi	%g3, %g0, 1
	jmp	jeq_cont.2546
jeq_else.2545:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.332
	addi	%g1, %g1, 24
jeq_cont.2546:
	jmp	jle_cont.2544
jle_else.2543:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.332
	addi	%g1, %g1, 24
jle_cont.2544:
jeq_cont.2542:
	jmp	jle_cont.2540
jle_else.2539:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30000
	jlt	%g12, %g10, jle_else.2547
	jne	%g12, %g10, jeq_else.2549
	addi	%g3, %g0, 3
	jmp	jeq_cont.2550
jeq_else.2549:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.332
	addi	%g1, %g1, 24
jeq_cont.2550:
	jmp	jle_cont.2548
jle_else.2547:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.332
	addi	%g1, %g1, 24
jle_cont.2548:
jle_cont.2540:
jeq_cont.2538:
	jmp	jle_cont.2536
jle_else.2535:
	addi	%g5, %g0, 7
	mvhi	%g12, 1
	mvlo	%g12, 4464
	jlt	%g12, %g10, jle_else.2551
	jne	%g12, %g10, jeq_else.2553
	addi	%g3, %g0, 7
	jmp	jeq_cont.2554
jeq_else.2553:
	addi	%g6, %g0, 6
	mvhi	%g12, 0
	mvlo	%g12, 60000
	jlt	%g12, %g10, jle_else.2555
	jne	%g12, %g10, jeq_else.2557
	addi	%g3, %g0, 6
	jmp	jeq_cont.2558
jeq_else.2557:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.332
	addi	%g1, %g1, 24
jeq_cont.2558:
	jmp	jle_cont.2556
jle_else.2555:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.332
	addi	%g1, %g1, 24
jle_cont.2556:
jeq_cont.2554:
	jmp	jle_cont.2552
jle_else.2551:
	addi	%g11, %g0, 8
	mvhi	%g12, 1
	mvlo	%g12, 14464
	jlt	%g12, %g10, jle_else.2559
	jne	%g12, %g10, jeq_else.2561
	addi	%g3, %g0, 8
	jmp	jeq_cont.2562
jeq_else.2561:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.332
	addi	%g1, %g1, 24
jeq_cont.2562:
	jmp	jle_cont.2560
jle_else.2559:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.332
	addi	%g1, %g1, 24
jle_cont.2560:
jle_cont.2552:
jle_cont.2536:
	addi	%g11, %g0, 10000
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2563
	ld	%g11, %g1, 16
	jne	%g11, %g0, jeq_else.2565
	addi	%g3, %g0, 0
	jmp	jeq_cont.2566
jeq_else.2565:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2566:
	jmp	jle_cont.2564
jle_else.2563:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2564:
	addi	%g4, %g0, 1000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 5000
	st	%g3, %g1, 20
	jlt	%g12, %g10, jle_else.2567
	jne	%g12, %g10, jeq_else.2569
	addi	%g3, %g0, 5
	jmp	jeq_cont.2570
jeq_else.2569:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 2000
	jlt	%g12, %g10, jle_else.2571
	jne	%g12, %g10, jeq_else.2573
	addi	%g3, %g0, 2
	jmp	jeq_cont.2574
jeq_else.2573:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 1000
	jlt	%g12, %g10, jle_else.2575
	jne	%g12, %g10, jeq_else.2577
	addi	%g3, %g0, 1
	jmp	jeq_cont.2578
jeq_else.2577:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.332
	addi	%g1, %g1, 32
jeq_cont.2578:
	jmp	jle_cont.2576
jle_else.2575:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.332
	addi	%g1, %g1, 32
jle_cont.2576:
jeq_cont.2574:
	jmp	jle_cont.2572
jle_else.2571:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 3000
	jlt	%g12, %g10, jle_else.2579
	jne	%g12, %g10, jeq_else.2581
	addi	%g3, %g0, 3
	jmp	jeq_cont.2582
jeq_else.2581:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.332
	addi	%g1, %g1, 32
jeq_cont.2582:
	jmp	jle_cont.2580
jle_else.2579:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.332
	addi	%g1, %g1, 32
jle_cont.2580:
jle_cont.2572:
jeq_cont.2570:
	jmp	jle_cont.2568
jle_else.2567:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 7000
	jlt	%g12, %g10, jle_else.2583
	jne	%g12, %g10, jeq_else.2585
	addi	%g3, %g0, 7
	jmp	jeq_cont.2586
jeq_else.2585:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 6000
	jlt	%g12, %g10, jle_else.2587
	jne	%g12, %g10, jeq_else.2589
	addi	%g3, %g0, 6
	jmp	jeq_cont.2590
jeq_else.2589:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.332
	addi	%g1, %g1, 32
jeq_cont.2590:
	jmp	jle_cont.2588
jle_else.2587:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.332
	addi	%g1, %g1, 32
jle_cont.2588:
jeq_cont.2586:
	jmp	jle_cont.2584
jle_else.2583:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 8000
	jlt	%g12, %g10, jle_else.2591
	jne	%g12, %g10, jeq_else.2593
	addi	%g3, %g0, 8
	jmp	jeq_cont.2594
jeq_else.2593:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.332
	addi	%g1, %g1, 32
jeq_cont.2594:
	jmp	jle_cont.2592
jle_else.2591:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.332
	addi	%g1, %g1, 32
jle_cont.2592:
jle_cont.2584:
jle_cont.2568:
	muli	%g11, %g3, 1000
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2595
	ld	%g11, %g1, 20
	jne	%g11, %g0, jeq_else.2597
	addi	%g3, %g0, 0
	jmp	jeq_cont.2598
jeq_else.2597:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2598:
	jmp	jle_cont.2596
jle_else.2595:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2596:
	addi	%g4, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 500
	st	%g3, %g1, 24
	jlt	%g12, %g10, jle_else.2599
	jne	%g12, %g10, jeq_else.2601
	addi	%g3, %g0, 5
	jmp	jeq_cont.2602
jeq_else.2601:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 200
	jlt	%g12, %g10, jle_else.2603
	jne	%g12, %g10, jeq_else.2605
	addi	%g3, %g0, 2
	jmp	jeq_cont.2606
jeq_else.2605:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 100
	jlt	%g12, %g10, jle_else.2607
	jne	%g12, %g10, jeq_else.2609
	addi	%g3, %g0, 1
	jmp	jeq_cont.2610
jeq_else.2609:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.332
	addi	%g1, %g1, 32
jeq_cont.2610:
	jmp	jle_cont.2608
jle_else.2607:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.332
	addi	%g1, %g1, 32
jle_cont.2608:
jeq_cont.2606:
	jmp	jle_cont.2604
jle_else.2603:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 300
	jlt	%g12, %g10, jle_else.2611
	jne	%g12, %g10, jeq_else.2613
	addi	%g3, %g0, 3
	jmp	jeq_cont.2614
jeq_else.2613:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.332
	addi	%g1, %g1, 32
jeq_cont.2614:
	jmp	jle_cont.2612
jle_else.2611:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.332
	addi	%g1, %g1, 32
jle_cont.2612:
jle_cont.2604:
jeq_cont.2602:
	jmp	jle_cont.2600
jle_else.2599:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 700
	jlt	%g12, %g10, jle_else.2615
	jne	%g12, %g10, jeq_else.2617
	addi	%g3, %g0, 7
	jmp	jeq_cont.2618
jeq_else.2617:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 600
	jlt	%g12, %g10, jle_else.2619
	jne	%g12, %g10, jeq_else.2621
	addi	%g3, %g0, 6
	jmp	jeq_cont.2622
jeq_else.2621:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.332
	addi	%g1, %g1, 32
jeq_cont.2622:
	jmp	jle_cont.2620
jle_else.2619:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.332
	addi	%g1, %g1, 32
jle_cont.2620:
jeq_cont.2618:
	jmp	jle_cont.2616
jle_else.2615:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 800
	jlt	%g12, %g10, jle_else.2623
	jne	%g12, %g10, jeq_else.2625
	addi	%g3, %g0, 8
	jmp	jeq_cont.2626
jeq_else.2625:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.332
	addi	%g1, %g1, 32
jeq_cont.2626:
	jmp	jle_cont.2624
jle_else.2623:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.332
	addi	%g1, %g1, 32
jle_cont.2624:
jle_cont.2616:
jle_cont.2600:
	muli	%g11, %g3, 100
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2627
	ld	%g11, %g1, 24
	jne	%g11, %g0, jeq_else.2629
	addi	%g3, %g0, 0
	jmp	jeq_cont.2630
jeq_else.2629:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2630:
	jmp	jle_cont.2628
jle_else.2627:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2628:
	addi	%g4, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 50
	st	%g3, %g1, 28
	jlt	%g12, %g10, jle_else.2631
	jne	%g12, %g10, jeq_else.2633
	addi	%g3, %g0, 5
	jmp	jeq_cont.2634
jeq_else.2633:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20
	jlt	%g12, %g10, jle_else.2635
	jne	%g12, %g10, jeq_else.2637
	addi	%g3, %g0, 2
	jmp	jeq_cont.2638
jeq_else.2637:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10
	jlt	%g12, %g10, jle_else.2639
	jne	%g12, %g10, jeq_else.2641
	addi	%g3, %g0, 1
	jmp	jeq_cont.2642
jeq_else.2641:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.332
	addi	%g1, %g1, 40
jeq_cont.2642:
	jmp	jle_cont.2640
jle_else.2639:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.332
	addi	%g1, %g1, 40
jle_cont.2640:
jeq_cont.2638:
	jmp	jle_cont.2636
jle_else.2635:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30
	jlt	%g12, %g10, jle_else.2643
	jne	%g12, %g10, jeq_else.2645
	addi	%g3, %g0, 3
	jmp	jeq_cont.2646
jeq_else.2645:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.332
	addi	%g1, %g1, 40
jeq_cont.2646:
	jmp	jle_cont.2644
jle_else.2643:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.332
	addi	%g1, %g1, 40
jle_cont.2644:
jle_cont.2636:
jeq_cont.2634:
	jmp	jle_cont.2632
jle_else.2631:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 70
	jlt	%g12, %g10, jle_else.2647
	jne	%g12, %g10, jeq_else.2649
	addi	%g3, %g0, 7
	jmp	jeq_cont.2650
jeq_else.2649:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 60
	jlt	%g12, %g10, jle_else.2651
	jne	%g12, %g10, jeq_else.2653
	addi	%g3, %g0, 6
	jmp	jeq_cont.2654
jeq_else.2653:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.332
	addi	%g1, %g1, 40
jeq_cont.2654:
	jmp	jle_cont.2652
jle_else.2651:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.332
	addi	%g1, %g1, 40
jle_cont.2652:
jeq_cont.2650:
	jmp	jle_cont.2648
jle_else.2647:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 80
	jlt	%g12, %g10, jle_else.2655
	jne	%g12, %g10, jeq_else.2657
	addi	%g3, %g0, 8
	jmp	jeq_cont.2658
jeq_else.2657:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.332
	addi	%g1, %g1, 40
jeq_cont.2658:
	jmp	jle_cont.2656
jle_else.2655:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.332
	addi	%g1, %g1, 40
jle_cont.2656:
jle_cont.2648:
jle_cont.2632:
	muli	%g11, %g3, 10
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2659
	ld	%g11, %g1, 28
	jne	%g11, %g0, jeq_else.2661
	addi	%g3, %g0, 0
	jmp	jeq_cont.2662
jeq_else.2661:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2662:
	jmp	jle_cont.2660
jle_else.2659:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2660:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g10
	output	%g3
	return
jge_else.2428:
	addi	%g10, %g0, 45
	st	%g3, %g1, 32
	output	%g10
	ld	%g3, %g1, 32
	sub	%g3, %g0, %g3
	jmp	print_int.337
sum.339:
	jlt	%g0, %g3, jle_else.2663
	addi	%g3, %g0, 0
	return
jle_else.2663:
	subi	%g4, %g3, 1
	st	%g3, %g1, 0
	jlt	%g0, %g4, jle_else.2664
	addi	%g3, %g0, 0
	jmp	jle_cont.2665
jle_else.2664:
	subi	%g5, %g4, 1
	st	%g4, %g1, 4
	jlt	%g0, %g5, jle_else.2666
	addi	%g3, %g0, 0
	jmp	jle_cont.2667
jle_else.2666:
	subi	%g6, %g5, 1
	st	%g5, %g1, 8
	jlt	%g0, %g6, jle_else.2668
	addi	%g3, %g0, 0
	jmp	jle_cont.2669
jle_else.2668:
	subi	%g7, %g6, 1
	st	%g6, %g1, 12
	jlt	%g0, %g7, jle_else.2670
	addi	%g3, %g0, 0
	jmp	jle_cont.2671
jle_else.2670:
	subi	%g8, %g7, 1
	st	%g7, %g1, 16
	jlt	%g0, %g8, jle_else.2672
	addi	%g3, %g0, 0
	jmp	jle_cont.2673
jle_else.2672:
	subi	%g9, %g8, 1
	st	%g8, %g1, 20
	jlt	%g0, %g9, jle_else.2674
	addi	%g3, %g0, 0
	jmp	jle_cont.2675
jle_else.2674:
	subi	%g10, %g9, 1
	st	%g9, %g1, 24
	jlt	%g0, %g10, jle_else.2676
	addi	%g3, %g0, 0
	jmp	jle_cont.2677
jle_else.2676:
	subi	%g11, %g10, 1
	st	%g10, %g1, 28
	jlt	%g0, %g11, jle_else.2678
	addi	%g3, %g0, 0
	jmp	jle_cont.2679
jle_else.2678:
	subi	%g12, %g11, 1
	st	%g11, %g1, 32
	jlt	%g0, %g12, jle_else.2680
	addi	%g3, %g0, 0
	jmp	jle_cont.2681
jle_else.2680:
	subi	%g13, %g12, 1
	st	%g12, %g1, 36
	jlt	%g0, %g13, jle_else.2682
	addi	%g3, %g0, 0
	jmp	jle_cont.2683
jle_else.2682:
	subi	%g14, %g13, 1
	st	%g13, %g1, 40
	jlt	%g0, %g14, jle_else.2684
	addi	%g3, %g0, 0
	jmp	jle_cont.2685
jle_else.2684:
	subi	%g15, %g14, 1
	st	%g14, %g1, 44
	jlt	%g0, %g15, jle_else.2686
	addi	%g3, %g0, 0
	jmp	jle_cont.2687
jle_else.2686:
	subi	%g16, %g15, 1
	st	%g15, %g1, 48
	jlt	%g0, %g16, jle_else.2688
	addi	%g3, %g0, 0
	jmp	jle_cont.2689
jle_else.2688:
	subi	%g17, %g16, 1
	st	%g16, %g1, 52
	jlt	%g0, %g17, jle_else.2690
	addi	%g3, %g0, 0
	jmp	jle_cont.2691
jle_else.2690:
	subi	%g18, %g17, 1
	st	%g17, %g1, 56
	jlt	%g0, %g18, jle_else.2692
	addi	%g3, %g0, 0
	jmp	jle_cont.2693
jle_else.2692:
	subi	%g19, %g18, 1
	st	%g18, %g1, 60
	jlt	%g0, %g19, jle_else.2694
	addi	%g3, %g0, 0
	jmp	jle_cont.2695
jle_else.2694:
	subi	%g20, %g19, 1
	st	%g19, %g1, 64
	jlt	%g0, %g20, jle_else.2696
	addi	%g3, %g0, 0
	jmp	jle_cont.2697
jle_else.2696:
	subi	%g21, %g20, 1
	st	%g20, %g1, 68
	jlt	%g0, %g21, jle_else.2698
	addi	%g3, %g0, 0
	jmp	jle_cont.2699
jle_else.2698:
	subi	%g22, %g21, 1
	st	%g21, %g1, 72
	jlt	%g0, %g22, jle_else.2700
	addi	%g3, %g0, 0
	jmp	jle_cont.2701
jle_else.2700:
	subi	%g23, %g22, 1
	st	%g22, %g1, 76
	jlt	%g0, %g23, jle_else.2702
	addi	%g3, %g0, 0
	jmp	jle_cont.2703
jle_else.2702:
	subi	%g24, %g23, 1
	st	%g23, %g1, 80
	jlt	%g0, %g24, jle_else.2704
	addi	%g3, %g0, 0
	jmp	jle_cont.2705
jle_else.2704:
	subi	%g25, %g24, 1
	st	%g24, %g1, 84
	jlt	%g0, %g25, jle_else.2706
	addi	%g3, %g0, 0
	jmp	jle_cont.2707
jle_else.2706:
	subi	%g26, %g25, 1
	st	%g25, %g1, 88
	jlt	%g0, %g26, jle_else.2708
	addi	%g3, %g0, 0
	jmp	jle_cont.2709
jle_else.2708:
	subi	%g27, %g26, 1
	st	%g26, %g1, 92
	jlt	%g0, %g27, jle_else.2710
	addi	%g3, %g0, 0
	jmp	jle_cont.2711
jle_else.2710:
	subi	%g3, %g27, 1
	st	%g27, %g1, 96
	jlt	%g0, %g3, jle_else.2712
	addi	%g3, %g0, 0
	jmp	jle_cont.2713
jle_else.2712:
	subi	%g4, %g3, 1
	st	%g3, %g1, 100
	jlt	%g0, %g4, jle_else.2714
	addi	%g3, %g0, 0
	jmp	jle_cont.2715
jle_else.2714:
	subi	%g5, %g4, 1
	st	%g4, %g1, 104
	jlt	%g0, %g5, jle_else.2716
	addi	%g3, %g0, 0
	jmp	jle_cont.2717
jle_else.2716:
	subi	%g6, %g5, 1
	st	%g5, %g1, 108
	jlt	%g0, %g6, jle_else.2718
	addi	%g3, %g0, 0
	jmp	jle_cont.2719
jle_else.2718:
	subi	%g7, %g6, 1
	st	%g6, %g1, 112
	jlt	%g0, %g7, jle_else.2720
	addi	%g3, %g0, 0
	jmp	jle_cont.2721
jle_else.2720:
	subi	%g8, %g7, 1
	st	%g7, %g1, 116
	jlt	%g0, %g8, jle_else.2722
	addi	%g3, %g0, 0
	jmp	jle_cont.2723
jle_else.2722:
	subi	%g9, %g8, 1
	st	%g8, %g1, 120
	jlt	%g0, %g9, jle_else.2724
	addi	%g3, %g0, 0
	jmp	jle_cont.2725
jle_else.2724:
	subi	%g10, %g9, 1
	st	%g9, %g1, 124
	mov	%g3, %g10
	subi	%g1, %g1, 136
	call	sum.339
	addi	%g1, %g1, 136
	ld	%g4, %g1, 124
	add	%g3, %g3, %g4
jle_cont.2725:
	ld	%g4, %g1, 120
	add	%g3, %g3, %g4
jle_cont.2723:
	ld	%g4, %g1, 116
	add	%g3, %g3, %g4
jle_cont.2721:
	ld	%g4, %g1, 112
	add	%g3, %g3, %g4
jle_cont.2719:
	ld	%g4, %g1, 108
	add	%g3, %g3, %g4
jle_cont.2717:
	ld	%g4, %g1, 104
	add	%g3, %g3, %g4
jle_cont.2715:
	ld	%g4, %g1, 100
	add	%g3, %g3, %g4
jle_cont.2713:
	ld	%g4, %g1, 96
	add	%g3, %g3, %g4
jle_cont.2711:
	ld	%g4, %g1, 92
	add	%g3, %g3, %g4
jle_cont.2709:
	ld	%g4, %g1, 88
	add	%g3, %g3, %g4
jle_cont.2707:
	ld	%g4, %g1, 84
	add	%g3, %g3, %g4
jle_cont.2705:
	ld	%g4, %g1, 80
	add	%g3, %g3, %g4
jle_cont.2703:
	ld	%g4, %g1, 76
	add	%g3, %g3, %g4
jle_cont.2701:
	ld	%g4, %g1, 72
	add	%g3, %g3, %g4
jle_cont.2699:
	ld	%g4, %g1, 68
	add	%g3, %g3, %g4
jle_cont.2697:
	ld	%g4, %g1, 64
	add	%g3, %g3, %g4
jle_cont.2695:
	ld	%g4, %g1, 60
	add	%g3, %g3, %g4
jle_cont.2693:
	ld	%g4, %g1, 56
	add	%g3, %g3, %g4
jle_cont.2691:
	ld	%g4, %g1, 52
	add	%g3, %g3, %g4
jle_cont.2689:
	ld	%g4, %g1, 48
	add	%g3, %g3, %g4
jle_cont.2687:
	ld	%g4, %g1, 44
	add	%g3, %g3, %g4
jle_cont.2685:
	ld	%g4, %g1, 40
	add	%g3, %g3, %g4
jle_cont.2683:
	ld	%g4, %g1, 36
	add	%g3, %g3, %g4
jle_cont.2681:
	ld	%g4, %g1, 32
	add	%g3, %g3, %g4
jle_cont.2679:
	ld	%g4, %g1, 28
	add	%g3, %g3, %g4
jle_cont.2677:
	ld	%g4, %g1, 24
	add	%g3, %g3, %g4
jle_cont.2675:
	ld	%g4, %g1, 20
	add	%g3, %g3, %g4
jle_cont.2673:
	ld	%g4, %g1, 16
	add	%g3, %g3, %g4
jle_cont.2671:
	ld	%g4, %g1, 12
	add	%g3, %g3, %g4
jle_cont.2669:
	ld	%g4, %g1, 8
	add	%g3, %g3, %g4
jle_cont.2667:
	ld	%g4, %g1, 4
	add	%g3, %g3, %g4
jle_cont.2665:
	ld	%g4, %g1, 0
	add	%g3, %g3, %g4
	return
min_caml_start:
	addi	%g28, %g0, 1
	addi	%g29, %g0, -1
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
	addi	%g3, %g0, 10000
	addi	%g4, %g0, 9999
	addi	%g5, %g0, 9998
	addi	%g6, %g0, 9997
	addi	%g7, %g0, 9996
	addi	%g8, %g0, 9995
	addi	%g9, %g0, 9994
	addi	%g10, %g0, 9993
	addi	%g11, %g0, 9992
	addi	%g12, %g0, 9991
	addi	%g13, %g0, 9990
	addi	%g14, %g0, 9989
	addi	%g15, %g0, 9988
	addi	%g16, %g0, 9987
	addi	%g17, %g0, 9986
	addi	%g18, %g0, 9985
	addi	%g19, %g0, 9984
	addi	%g20, %g0, 9983
	addi	%g21, %g0, 9982
	addi	%g22, %g0, 9981
	addi	%g23, %g0, 9980
	addi	%g24, %g0, 9979
	addi	%g25, %g0, 9978
	addi	%g26, %g0, 9977
	addi	%g27, %g0, 9976
	st	%g3, %g1, 0
	addi	%g3, %g0, 9975
	st	%g4, %g1, 4
	addi	%g4, %g0, 9974
	st	%g5, %g1, 8
	addi	%g5, %g0, 9973
	st	%g6, %g1, 12
	addi	%g6, %g0, 9972
	st	%g7, %g1, 16
	addi	%g7, %g0, 9971
	st	%g8, %g1, 20
	addi	%g8, %g0, 9970
	st	%g9, %g1, 24
	addi	%g9, %g0, 9969
	st	%g10, %g1, 28
	st	%g11, %g1, 32
	st	%g12, %g1, 36
	st	%g13, %g1, 40
	st	%g14, %g1, 44
	st	%g15, %g1, 48
	st	%g16, %g1, 52
	st	%g17, %g1, 56
	st	%g18, %g1, 60
	st	%g19, %g1, 64
	st	%g20, %g1, 68
	st	%g21, %g1, 72
	st	%g22, %g1, 76
	st	%g23, %g1, 80
	st	%g24, %g1, 84
	st	%g25, %g1, 88
	st	%g26, %g1, 92
	st	%g27, %g1, 96
	st	%g3, %g1, 100
	st	%g4, %g1, 104
	st	%g5, %g1, 108
	st	%g6, %g1, 112
	st	%g7, %g1, 116
	st	%g8, %g1, 120
	mov	%g3, %g9
	subi	%g1, %g1, 128
	call	sum.339
	addi	%g1, %g1, 128
	ld	%g13, %g1, 120
	add	%g3, %g3, %g13
	ld	%g13, %g1, 116
	add	%g3, %g3, %g13
	ld	%g13, %g1, 112
	add	%g3, %g3, %g13
	ld	%g13, %g1, 108
	add	%g3, %g3, %g13
	ld	%g13, %g1, 104
	add	%g3, %g3, %g13
	ld	%g13, %g1, 100
	add	%g3, %g3, %g13
	ld	%g13, %g1, 96
	add	%g3, %g3, %g13
	ld	%g13, %g1, 92
	add	%g3, %g3, %g13
	ld	%g13, %g1, 88
	add	%g3, %g3, %g13
	ld	%g13, %g1, 84
	add	%g3, %g3, %g13
	ld	%g13, %g1, 80
	add	%g3, %g3, %g13
	ld	%g13, %g1, 76
	add	%g3, %g3, %g13
	ld	%g13, %g1, 72
	add	%g3, %g3, %g13
	ld	%g13, %g1, 68
	add	%g3, %g3, %g13
	ld	%g13, %g1, 64
	add	%g3, %g3, %g13
	ld	%g13, %g1, 60
	add	%g3, %g3, %g13
	ld	%g13, %g1, 56
	add	%g3, %g3, %g13
	ld	%g13, %g1, 52
	add	%g3, %g3, %g13
	ld	%g13, %g1, 48
	add	%g3, %g3, %g13
	ld	%g13, %g1, 44
	add	%g3, %g3, %g13
	ld	%g13, %g1, 40
	add	%g3, %g3, %g13
	ld	%g13, %g1, 36
	add	%g3, %g3, %g13
	ld	%g13, %g1, 32
	add	%g3, %g3, %g13
	ld	%g13, %g1, 28
	add	%g3, %g3, %g13
	ld	%g13, %g1, 24
	add	%g3, %g3, %g13
	ld	%g13, %g1, 20
	add	%g3, %g3, %g13
	ld	%g13, %g1, 16
	add	%g3, %g3, %g13
	ld	%g13, %g1, 12
	add	%g3, %g3, %g13
	ld	%g13, %g1, 8
	add	%g3, %g3, %g13
	ld	%g13, %g1, 4
	add	%g3, %g3, %g13
	ld	%g13, %g1, 0
	add	%g3, %g3, %g13
	subi	%g1, %g1, 128
	call	print_int.337
	addi	%g1, %g1, 128
	halt
