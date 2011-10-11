.init_heap_size	1344
l.382:	! 8388608.000000
	.long	0x4b000000
l.380:	! -2.000000
	.long	0xc0000000
l.378:	! -1.900000
	.long	0xbff33333
l.376:	! -1.800000
	.long	0xbfe6665e
l.374:	! -1.700000
	.long	0xbfd99999
l.372:	! -1.600000
	.long	0xbfccccc4
l.370:	! -1.500000
	.long	0xbfc00000
l.368:	! -1.400000
	.long	0xbfb33333
l.366:	! -1.300000
	.long	0xbfa6665e
l.364:	! -1.200000
	.long	0xbf999999
l.362:	! -1.100000
	.long	0xbf8cccc4
l.360:	! -1.000000
	.long	0xbf800000
l.358:	! -0.900000
	.long	0xbf66665e
l.356:	! -0.800000
	.long	0xbf4cccc4
l.354:	! -0.700000
	.long	0xbf333333
l.352:	! -0.600000
	.long	0xbf199999
l.350:	! -0.500000
	.long	0xbf000000
l.348:	! -0.400000
	.long	0xbeccccc4
l.346:	! -0.300000
	.long	0xbe999999
l.344:	! -0.200000
	.long	0xbe4cccc4
l.342:	! -0.100000
	.long	0xbdccccc4
l.339:	! 2.000000
	.long	0x40000000
l.337:	! 1.900000
	.long	0x3ff33333
l.335:	! 1.800000
	.long	0x3fe6665e
l.333:	! 1.700000
	.long	0x3fd99999
l.331:	! 1.600000
	.long	0x3fccccc4
l.329:	! 1.500000
	.long	0x3fc00000
l.327:	! 1.400000
	.long	0x3fb33333
l.325:	! 1.300000
	.long	0x3fa6665e
l.323:	! 1.200000
	.long	0x3f999999
l.321:	! 1.100000
	.long	0x3f8cccc4
l.319:	! 1.000000
	.long	0x3f800000
l.317:	! 0.900000
	.long	0x3f66665e
l.315:	! 0.800000
	.long	0x3f4cccc4
l.313:	! 0.700000
	.long	0x3f333333
l.311:	! 0.600000
	.long	0x3f199999
l.309:	! 0.500000
	.long	0x3f000000
l.307:	! 0.400000
	.long	0x3eccccc4
l.305:	! 0.300000
	.long	0x3e999999
l.303:	! 0.200000
	.long	0x3e4cccc4
l.301:	! 0.100000
	.long	0x3dccccc4
l.299:	! 0.000000
	.long	0x0
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
	setL %g3, l.299
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.301
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.303
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.305
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.307
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.309
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.311
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.313
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.315
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.317
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.319
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.321
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.323
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.325
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.327
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.329
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.331
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.333
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.335
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.337
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.339
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.299
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.342
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.344
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.346
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.348
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.350
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.352
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.354
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.356
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.358
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.360
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.362
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.364
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.366
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.368
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.370
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.372
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.374
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.376
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.378
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.380
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	setL %g3, l.382
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_floor
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fst	%f0, %g1, 4
	st	%g3, %g1, 8
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 8
	halt
