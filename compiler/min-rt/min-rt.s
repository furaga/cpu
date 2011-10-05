.init_heap_size	1216
l.16059:	! 1.570796
	.long	0x3fc90fda
l.16057:	! 6.283185
	.long	0x40c90fda
l.16055:	! 3.141593
	.long	0x40490fda
l.15993:	! 128.000000
	.long	0x43000000
l.15760:	! 0.900000
	.long	0x3f66665e
l.15758:	! 0.200000
	.long	0x3e4cccc4
l.15212:	! 150.000000
	.long	0x43160000
l.15188:	! -150.000000
	.long	0xc2960000
l.15113:	! 0.100000
	.long	0x3dccccc4
l.15057:	! -2.000000
	.long	0xc0000000
l.15042:	! 0.003906
	.long	0x3b800000
l.14936:	! 20.000000
	.long	0x41a00000
l.14934:	! 0.050000
	.long	0x3d4cccc4
l.14924:	! 0.250000
	.long	0x3e800000
l.14914:	! 10.000000
	.long	0x41200000
l.14907:	! 0.300000
	.long	0x3e999999
l.14905:	! 255.000000
	.long	0x437f0000
l.14899:	! 0.150000
	.long	0x3e199999
l.14888:	! 3.141593
	.long	0x40490fda
l.14886:	! 30.000000
	.long	0x41f00000
l.14883:	! 15.000000
	.long	0x41700000
l.14881:	! 0.000100
	.long	0x38d1b70f
l.14824:	! 100000000.000000
	.long	0x4cbebc20
l.14806:	! 1000000000.000000
	.long	0x4e6e6b28
l.14646:	! -0.100000
	.long	0xbd4cccc4
l.14610:	! 0.010000
	.long	0x3c23d70a
l.14608:	! -0.200000
	.long	0xbdccccc4
l.14165:	! -200.000000
	.long	0xc2c80000
l.14162:	! 200.000000
	.long	0x43480000
l.14155:	! 0.017453
	.long	0x3c8efa2d
l.14131:	! -1.000000
	.long	0xbf800000
l.14106:	! 3.000000
	.long	0x40400000
l.14068:	! 2.000000
	.long	0x40000000
l.14053:	! 1.000000
	.long	0x3f800000
l.14015:	! -0.607253
	.long	0xbe9b74e5
l.14009:	! 0.607253
	.long	0x3f1b74e5
l.14007:	! 0.000000
	.long	0x40000000
l.13995:	! 0.500000
	.long	0x3f000000
cordic_rec.6623:
	ld	%g4, %g30, 16
	fld	%f4, %g30, 8
	bne	%g3, %g4, beq_else.21567
	fmov	%f0, %f1
	return
beq_else.21567:
	fbg	%f4, %f2, fble_else.21568
	addi	%g5, %g3, 1
	fmul	%f5, %f3, %f1
	fadd	%f5, %f0, %f5
	fmul	%f0, %f3, %f0
	fsub	%f0, %f1, %f0
	setL %g6, min_caml_atan_table
	slli	%g3, %g3, 3
	fld	%f1, %g6, %g3
	fsub	%f1, %f2, %f1
	setL %g3, l.13995
	fld	%f2, %g3, 0
	fmul	%f2, %f3, %f2
	bne	%g5, %g4, beq_else.21569
	return
beq_else.21569:
	fbg	%f4, %f1, fble_else.21570
	addi	%g3, %g5, 1
	fmul	%f3, %f2, %f0
	fadd	%f3, %f5, %f3
	fmul	%f4, %f2, %f5
	fsub	%f0, %f0, %f4
	setL %g4, min_caml_atan_table
	slli	%g5, %g5, 3
	fld	%f4, %g4, %g5
	fsub	%f1, %f1, %f4
	setL %g4, l.13995
	fld	%f4, %g4, 0
	fmul	%f2, %f2, %f4
	fmov	%f31, %f3
	fmov	%f3, %f2
	fmov	%f2, %f1
	fmov	%f1, %f0
	fmov	%f0, %f31
	ld	%g30, 0, %g29
	b	%g29
fble_else.21570:
	addi	%g3, %g5, 1
	fmul	%f3, %f2, %f0
	fsub	%f3, %f5, %f3
	fmul	%f4, %f2, %f5
	fadd	%f0, %f0, %f4
	setL %g4, min_caml_atan_table
	slli	%g5, %g5, 3
	fld	%f4, %g4, %g5
	fadd	%f1, %f1, %f4
	setL %g4, l.13995
	fld	%f4, %g4, 0
	fmul	%f2, %f2, %f4
	fmov	%f31, %f3
	fmov	%f3, %f2
	fmov	%f2, %f1
	fmov	%f1, %f0
	fmov	%f0, %f31
	ld	%g30, 0, %g29
	b	%g29
fble_else.21568:
	addi	%g5, %g3, 1
	fmul	%f5, %f3, %f1
	fsub	%f5, %f0, %f5
	fmul	%f0, %f3, %f0
	fadd	%f0, %f1, %f0
	setL %g6, min_caml_atan_table
	slli	%g3, %g3, 3
	fld	%f1, %g6, %g3
	fadd	%f1, %f2, %f1
	setL %g3, l.13995
	fld	%f2, %g3, 0
	fmul	%f2, %f3, %f2
	bne	%g5, %g4, beq_else.21571
	return
beq_else.21571:
	fbg	%f4, %f1, fble_else.21572
	addi	%g3, %g5, 1
	fmul	%f3, %f2, %f0
	fadd	%f3, %f5, %f3
	fmul	%f4, %f2, %f5
	fsub	%f0, %f0, %f4
	setL %g4, min_caml_atan_table
	slli	%g5, %g5, 3
	fld	%f4, %g4, %g5
	fsub	%f1, %f1, %f4
	setL %g4, l.13995
	fld	%f4, %g4, 0
	fmul	%f2, %f2, %f4
	fmov	%f31, %f3
	fmov	%f3, %f2
	fmov	%f2, %f1
	fmov	%f1, %f0
	fmov	%f0, %f31
	ld	%g30, 0, %g29
	b	%g29
fble_else.21572:
	addi	%g3, %g5, 1
	fmul	%f3, %f2, %f0
	fsub	%f3, %f5, %f3
	fmul	%f4, %f2, %f5
	fadd	%f0, %f0, %f4
	setL %g4, min_caml_atan_table
	slli	%g5, %g5, 3
	fld	%f4, %g4, %g5
	fadd	%f1, %f1, %f4
	setL %g4, l.13995
	fld	%f4, %g4, 0
	fmul	%f2, %f2, %f4
	fmov	%f31, %f3
	fmov	%f3, %f2
	fmov	%f2, %f1
	fmov	%f1, %f0
	fmov	%f0, %f31
	ld	%g30, 0, %g29
	b	%g29
cordic_sin.2737:
	ld	%g3, %g30, 4
	mov	%g30, %g2
	addi	%g2, %g2, 24
	setL %g4, cordic_rec.6623
	st	%g4, %g30, 0
	st	%g3, %g30, 16
	fst	%f0, %g30, 8
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fbg	%f0, %f1, fble_else.21573
	mvhi	%g3, 0
	mvlo	%g3, 1
	setL %g4, l.14009
	fld	%f0, %g4, 0
	setL %g4, l.14015
	fld	%f2, %g4, 0
	setL %g4, min_caml_atan_table
	fld	%f3, %g4, 0
	fsub	%f1, %f1, %f3
	setL %g4, l.13995
	fld	%f3, %g4, 0
	fmov	%f31, %f2
	fmov	%f2, %f1
	fmov	%f1, %f31
	ld	%g30, 0, %g29
	b	%g29
fble_else.21573:
	mvhi	%g3, 0
	mvlo	%g3, 1
	setL %g4, l.14009
	fld	%f0, %g4, 0
	setL %g4, l.14009
	fld	%f2, %g4, 0
	setL %g4, min_caml_atan_table
	fld	%f3, %g4, 0
	fadd	%f1, %f1, %f3
	setL %g4, l.13995
	fld	%f3, %g4, 0
	fmov	%f31, %f2
	fmov	%f2, %f1
	fmov	%f1, %f31
	ld	%g30, 0, %g29
	b	%g29
cordic_rec.6591:
	ld	%g4, %g30, 16
	fld	%f4, %g30, 8
	bne	%g3, %g4, beq_else.21574
	return
beq_else.21574:
	fbg	%f4, %f2, fble_else.21575
	addi	%g5, %g3, 1
	fmul	%f5, %f3, %f1
	fadd	%f5, %f0, %f5
	fmul	%f0, %f3, %f0
	fsub	%f0, %f1, %f0
	setL %g6, min_caml_atan_table
	slli	%g3, %g3, 3
	fld	%f1, %g6, %g3
	fsub	%f1, %f2, %f1
	setL %g3, l.13995
	fld	%f2, %g3, 0
	fmul	%f2, %f3, %f2
	bne	%g5, %g4, beq_else.21576
	fmov	%f0, %f5
	return
beq_else.21576:
	fbg	%f4, %f1, fble_else.21577
	addi	%g3, %g5, 1
	fmul	%f3, %f2, %f0
	fadd	%f3, %f5, %f3
	fmul	%f4, %f2, %f5
	fsub	%f0, %f0, %f4
	setL %g4, min_caml_atan_table
	slli	%g5, %g5, 3
	fld	%f4, %g4, %g5
	fsub	%f1, %f1, %f4
	setL %g4, l.13995
	fld	%f4, %g4, 0
	fmul	%f2, %f2, %f4
	fmov	%f31, %f3
	fmov	%f3, %f2
	fmov	%f2, %f1
	fmov	%f1, %f0
	fmov	%f0, %f31
	ld	%g30, 0, %g29
	b	%g29
fble_else.21577:
	addi	%g3, %g5, 1
	fmul	%f3, %f2, %f0
	fsub	%f3, %f5, %f3
	fmul	%f4, %f2, %f5
	fadd	%f0, %f0, %f4
	setL %g4, min_caml_atan_table
	slli	%g5, %g5, 3
	fld	%f4, %g4, %g5
	fadd	%f1, %f1, %f4
	setL %g4, l.13995
	fld	%f4, %g4, 0
	fmul	%f2, %f2, %f4
	fmov	%f31, %f3
	fmov	%f3, %f2
	fmov	%f2, %f1
	fmov	%f1, %f0
	fmov	%f0, %f31
	ld	%g30, 0, %g29
	b	%g29
fble_else.21575:
	addi	%g5, %g3, 1
	fmul	%f5, %f3, %f1
	fsub	%f5, %f0, %f5
	fmul	%f0, %f3, %f0
	fadd	%f0, %f1, %f0
	setL %g6, min_caml_atan_table
	slli	%g3, %g3, 3
	fld	%f1, %g6, %g3
	fadd	%f1, %f2, %f1
	setL %g3, l.13995
	fld	%f2, %g3, 0
	fmul	%f2, %f3, %f2
	bne	%g5, %g4, beq_else.21578
	fmov	%f0, %f5
	return
beq_else.21578:
	fbg	%f4, %f1, fble_else.21579
	addi	%g3, %g5, 1
	fmul	%f3, %f2, %f0
	fadd	%f3, %f5, %f3
	fmul	%f4, %f2, %f5
	fsub	%f0, %f0, %f4
	setL %g4, min_caml_atan_table
	slli	%g5, %g5, 3
	fld	%f4, %g4, %g5
	fsub	%f1, %f1, %f4
	setL %g4, l.13995
	fld	%f4, %g4, 0
	fmul	%f2, %f2, %f4
	fmov	%f31, %f3
	fmov	%f3, %f2
	fmov	%f2, %f1
	fmov	%f1, %f0
	fmov	%f0, %f31
	ld	%g30, 0, %g29
	b	%g29
fble_else.21579:
	addi	%g3, %g5, 1
	fmul	%f3, %f2, %f0
	fsub	%f3, %f5, %f3
	fmul	%f4, %f2, %f5
	fadd	%f0, %f0, %f4
	setL %g4, min_caml_atan_table
	slli	%g5, %g5, 3
	fld	%f4, %g4, %g5
	fadd	%f1, %f1, %f4
	setL %g4, l.13995
	fld	%f4, %g4, 0
	fmul	%f2, %f2, %f4
	fmov	%f31, %f3
	fmov	%f3, %f2
	fmov	%f2, %f1
	fmov	%f1, %f0
	fmov	%f0, %f31
	ld	%g30, 0, %g29
	b	%g29
cordic_cos.2739:
	ld	%g3, %g30, 4
	mov	%g30, %g2
	addi	%g2, %g2, 24
	setL %g4, cordic_rec.6591
	st	%g4, %g30, 0
	st	%g3, %g30, 16
	fst	%f0, %g30, 8
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fbg	%f0, %f1, fble_else.21580
	mvhi	%g3, 0
	mvlo	%g3, 1
	setL %g4, l.14009
	fld	%f0, %g4, 0
	setL %g4, l.14015
	fld	%f2, %g4, 0
	setL %g4, min_caml_atan_table
	fld	%f3, %g4, 0
	fsub	%f1, %f1, %f3
	setL %g4, l.13995
	fld	%f3, %g4, 0
	fmov	%f31, %f2
	fmov	%f2, %f1
	fmov	%f1, %f31
	ld	%g30, 0, %g29
	b	%g29
fble_else.21580:
	mvhi	%g3, 0
	mvlo	%g3, 1
	setL %g4, l.14009
	fld	%f0, %g4, 0
	setL %g4, l.14009
	fld	%f2, %g4, 0
	setL %g4, min_caml_atan_table
	fld	%f3, %g4, 0
	fadd	%f1, %f1, %f3
	setL %g4, l.13995
	fld	%f3, %g4, 0
	fmov	%f31, %f2
	fmov	%f2, %f1
	fmov	%f1, %f31
	ld	%g30, 0, %g29
	b	%g29
cordic_rec.6558:
	ld	%g4, %g30, 4
	bne	%g3, %g4, beq_else.21581
	fmov	%f0, %f2
	return
beq_else.21581:
	setL %g4, l.14007
	fld	%f4, %g4, 0
	fbg	%f1, %f4, fble_else.21582
	addi	%g4, %g3, 1
	fmul	%f4, %f3, %f1
	fsub	%f4, %f0, %f4
	fmul	%f0, %f3, %f0
	fadd	%f1, %f1, %f0
	setL %g5, min_caml_atan_table
	slli	%g3, %g3, 3
	fld	%f0, %g5, %g3
	fsub	%f2, %f2, %f0
	setL %g3, l.13995
	fld	%f0, %g3, 0
	fmul	%f3, %f3, %f0
	mov	%g3, %g4
	fmov	%f0, %f4
	ld	%g30, 0, %g29
	b	%g29
fble_else.21582:
	addi	%g4, %g3, 1
	fmul	%f4, %f3, %f1
	fadd	%f4, %f0, %f4
	fmul	%f0, %f3, %f0
	fsub	%f1, %f1, %f0
	setL %g5, min_caml_atan_table
	slli	%g3, %g3, 3
	fld	%f0, %g5, %g3
	fadd	%f2, %f2, %f0
	setL %g3, l.13995
	fld	%f0, %g3, 0
	fmul	%f3, %f3, %f0
	mov	%g3, %g4
	fmov	%f0, %f4
	ld	%g30, 0, %g29
	b	%g29
cordic_atan.2741:
	ld	%g3, %g30, 4
	mov	%g30, %g2
	addi	%g2, %g2, 8
	setL %g4, cordic_rec.6558
	st	%g4, %g30, 0
	st	%g3, %g30, 4
	mvhi	%g3, 0
	mvlo	%g3, 0
	setL %g4, l.14053
	fld	%f1, %g4, 0
	setL %g4, l.14007
	fld	%f2, %g4, 0
	setL %g4, l.14053
	fld	%f3, %g4, 0
	fmov	%f31, %f1
	fmov	%f1, %f0
	fmov	%f0, %f31
	ld	%g30, 0, %g29
	b	%g29
sin.2743:
	fld	%f1, %g30, 24
	fld	%f2, %g30, 16
	fld	%f3, %g30, 8
	ld	%g3, %g30, 4
	setL %g4, l.14007
	fld	%f4, %g4, 0
	fbg	%f4, %f0, fble_else.21583
	fbg	%f1, %f0, fble_else.21584
	fbg	%f3, %f0, fble_else.21585
	fbg	%f2, %f0, fble_else.21586
	fsub	%f0, %f0, %f2
	setL %g4, l.14007
	fld	%f4, %g4, 0
	fbg	%f4, %f0, fble_else.21587
	fbg	%f1, %f0, fble_else.21588
	fbg	%f3, %f0, fble_else.21589
	fbg	%f2, %f0, fble_else.21590
	fsub	%f0, %f0, %f2
	ld	%g30, 0, %g29
	b	%g29
fble_else.21590:
	fsub	%f0, %f2, %f0
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	addi	%g1, %g1, 8
	call	%g29
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fneg	%f0, %f0
	return
fble_else.21589:
	fsub	%f0, %f3, %f0
	mov	%g30, %g3
	ld	%g30, 0, %g29
	b	%g29
fble_else.21588:
	mov	%g30, %g3
	ld	%g30, 0, %g29
	b	%g29
fble_else.21587:
	fneg	%f0, %f0
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	addi	%g1, %g1, 8
	call	%g29
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fneg	%f0, %f0
	return
fble_else.21586:
	fsub	%f0, %f2, %f0
	setL %g4, l.14007
	fld	%f4, %g4, 0
	fblt	%f0, %f4, fble_else.21591
	fneg	%f0, %f0
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	addi	%g1, %g1, 8
	call	%g29
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fneg	%f0, %f0
	b	fble_cont.21592
fble_else.21591:
	fblt	%f0, %f1, fble_else.21593
	mov	%g30, %g3
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	addi	%g1, %g1, 8
	call	%g29
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	b	fble_cont.21594
fble_else.21593:
	fblt	%f0, %f3, fble_else.21595
	fsub	%f0, %f3, %f0
	mov	%g30, %g3
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	addi	%g1, %g1, 8
	call	%g29
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	b	fble_cont.21596
fble_else.21595:
	fblt	%f0, %f2, fble_else.21597
	fsub	%f0, %f2, %f0
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	addi	%g1, %g1, 8
	call	%g29
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fneg	%f0, %f0
	b	fble_cont.21598
fble_else.21597:
	fsub	%f0, %f0, %f2
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	addi	%g1, %g1, 8
	call	%g29
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
fble_cont.21598:
fble_cont.21596:
fble_cont.21594:
fble_cont.21592:
	fneg	%f0, %f0
	return
fble_else.21585:
	fsub	%f0, %f3, %f0
	mov	%g30, %g3
	ld	%g30, 0, %g29
	b	%g29
fble_else.21584:
	mov	%g30, %g3
	ld	%g30, 0, %g29
	b	%g29
fble_else.21583:
	fneg	%f0, %f0
	setL %g4, l.14007
	fld	%f4, %g4, 0
	fblt	%f0, %f4, fble_else.21599
	fneg	%f0, %f0
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	addi	%g1, %g1, 8
	call	%g29
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fneg	%f0, %f0
	b	fble_cont.21600
fble_else.21599:
	fblt	%f0, %f1, fble_else.21601
	mov	%g30, %g3
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	addi	%g1, %g1, 8
	call	%g29
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	b	fble_cont.21602
fble_else.21601:
	fblt	%f0, %f3, fble_else.21603
	fsub	%f0, %f3, %f0
	mov	%g30, %g3
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	addi	%g1, %g1, 8
	call	%g29
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	b	fble_cont.21604
fble_else.21603:
	fblt	%f0, %f2, fble_else.21605
	fsub	%f0, %f2, %f0
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	addi	%g1, %g1, 8
	call	%g29
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fneg	%f0, %f0
	b	fble_cont.21606
fble_else.21605:
	fsub	%f0, %f0, %f2
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	addi	%g1, %g1, 8
	call	%g29
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
fble_cont.21606:
fble_cont.21604:
fble_cont.21602:
fble_cont.21600:
	fneg	%f0, %f0
	return
cos.2745:
	fld	%f1, %g30, 24
	fld	%f2, %g30, 16
	fld	%f3, %g30, 8
	ld	%g3, %g30, 4
	setL %g4, l.14007
	fld	%f4, %g4, 0
	fbg	%f4, %f0, fble_else.21607
	fbg	%f1, %f0, fble_else.21608
	fbg	%f3, %f0, fble_else.21609
	fbg	%f2, %f0, fble_else.21610
	fsub	%f0, %f0, %f2
	setL %g4, l.14007
	fld	%f4, %g4, 0
	fbg	%f4, %f0, fble_else.21611
	fbg	%f1, %f0, fble_else.21612
	fbg	%f3, %f0, fble_else.21613
	fbg	%f2, %f0, fble_else.21614
	fsub	%f0, %f0, %f2
	ld	%g30, 0, %g29
	b	%g29
fble_else.21614:
	fsub	%f0, %f2, %f0
	ld	%g30, 0, %g29
	b	%g29
fble_else.21613:
	fsub	%f0, %f3, %f0
	mov	%g30, %g3
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	addi	%g1, %g1, 8
	call	%g29
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fneg	%f0, %f0
	return
fble_else.21612:
	mov	%g30, %g3
	ld	%g30, 0, %g29
	b	%g29
fble_else.21611:
	fneg	%f0, %f0
	ld	%g30, 0, %g29
	b	%g29
fble_else.21610:
	fsub	%f0, %f2, %f0
	setL %g4, l.14007
	fld	%f4, %g4, 0
	fbg	%f4, %f0, fble_else.21615
	fbg	%f1, %f0, fble_else.21616
	fbg	%f3, %f0, fble_else.21617
	fbg	%f2, %f0, fble_else.21618
	fsub	%f0, %f0, %f2
	ld	%g30, 0, %g29
	b	%g29
fble_else.21618:
	fsub	%f0, %f2, %f0
	ld	%g30, 0, %g29
	b	%g29
fble_else.21617:
	fsub	%f0, %f3, %f0
	mov	%g30, %g3
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	addi	%g1, %g1, 8
	call	%g29
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fneg	%f0, %f0
	return
fble_else.21616:
	mov	%g30, %g3
	ld	%g30, 0, %g29
	b	%g29
fble_else.21615:
	fneg	%f0, %f0
	ld	%g30, 0, %g29
	b	%g29
fble_else.21609:
	fsub	%f0, %f3, %f0
	mov	%g30, %g3
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	addi	%g1, %g1, 8
	call	%g29
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fneg	%f0, %f0
	return
fble_else.21608:
	mov	%g30, %g3
	ld	%g30, 0, %g29
	b	%g29
fble_else.21607:
	fneg	%f0, %f0
	setL %g4, l.14007
	fld	%f4, %g4, 0
	fbg	%f4, %f0, fble_else.21619
	fbg	%f1, %f0, fble_else.21620
	fbg	%f3, %f0, fble_else.21621
	fbg	%f2, %f0, fble_else.21622
	fsub	%f0, %f0, %f2
	ld	%g30, 0, %g29
	b	%g29
fble_else.21622:
	fsub	%f0, %f2, %f0
	ld	%g30, 0, %g29
	b	%g29
fble_else.21621:
	fsub	%f0, %f3, %f0
	mov	%g30, %g3
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	addi	%g1, %g1, 8
	call	%g29
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	fneg	%f0, %f0
	return
fble_else.21620:
	mov	%g30, %g3
	ld	%g30, 0, %g29
	b	%g29
fble_else.21619:
	fneg	%f0, %f0
	ld	%g30, 0, %g29
	b	%g29
get_sqrt_init_rec.6532.10574:
	mvhi	%g4, 0
	mvlo	%g4, 49
	bne	%g3, %g4, beq_else.21623
	setL %g4, min_caml_rsqrt_table
	slli	%g3, %g3, 3
	fld	%f0, %g4, %g3
	return
beq_else.21623:
	setL %g4, l.14068
	fld	%f1, %g4, 0
	fbg	%f1, %f0, fble_else.21624
	setL %g4, l.14068
	fld	%f1, %g4, 0
	fdiv	%f0, %f0, %f1
	addi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 49
	bne	%g3, %g4, beq_else.21625
	setL %g4, min_caml_rsqrt_table
	slli	%g3, %g3, 3
	fld	%f0, %g4, %g3
	return
beq_else.21625:
	setL %g4, l.14068
	fld	%f1, %g4, 0
	fbg	%f1, %f0, fble_else.21626
	setL %g4, l.14068
	fld	%f1, %g4, 0
	fdiv	%f0, %f0, %f1
	addi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 49
	bne	%g3, %g4, beq_else.21627
	setL %g4, min_caml_rsqrt_table
	slli	%g3, %g3, 3
	fld	%f0, %g4, %g3
	return
beq_else.21627:
	setL %g4, l.14068
	fld	%f1, %g4, 0
	fbg	%f1, %f0, fble_else.21628
	setL %g4, l.14068
	fld	%f1, %g4, 0
	fdiv	%f0, %f0, %f1
	addi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 49
	bne	%g3, %g4, beq_else.21629
	setL %g4, min_caml_rsqrt_table
	slli	%g3, %g3, 3
	fld	%f0, %g4, %g3
	return
beq_else.21629:
	setL %g4, l.14068
	fld	%f1, %g4, 0
	fbg	%f1, %f0, fble_else.21630
	setL %g4, l.14068
	fld	%f1, %g4, 0
	fdiv	%f0, %f0, %f1
	addi	%g3, %g3, 1
	jmp	get_sqrt_init_rec.6532.10574
fble_else.21630:
	setL %g4, min_caml_rsqrt_table
	slli	%g3, %g3, 3
	fld	%f0, %g4, %g3
	return
fble_else.21628:
	setL %g4, min_caml_rsqrt_table
	slli	%g3, %g3, 3
	fld	%f0, %g4, %g3
	return
fble_else.21626:
	setL %g4, min_caml_rsqrt_table
	slli	%g3, %g3, 3
	fld	%f0, %g4, %g3
	return
fble_else.21624:
	setL %g4, min_caml_rsqrt_table
	slli	%g3, %g3, 3
	fld	%f0, %g4, %g3
	return
sqrt.2751:
	setL %g3, l.14053
	fld	%f1, %g3, 0
	fbg	%f1, %f0, fble_else.21631
	setL %g3, l.14068
	fld	%f1, %g3, 0
	std	%f0, %g1, 0
	fblt	%f0, %f1, fble_else.21632
	setL %g3, min_caml_rsqrt_table
	fld	%f0, %g3, 0
	b	fble_cont.21633
fble_else.21632:
	setL %g3, l.14068
	fld	%f1, %g3, 0
	fdiv	%f1, %f0, %f1
	setL %g3, l.14068
	fld	%f2, %g3, 0
	fblt	%f1, %f2, fble_else.21634
	setL %g3, min_caml_rsqrt_table
	fld	%f0, %g3, 8
	b	fble_cont.21635
fble_else.21634:
	setL %g3, l.14068
	fld	%f2, %g3, 0
	fdiv	%f1, %f1, %f2
	setL %g3, l.14068
	fld	%f2, %g3, 0
	fblt	%f1, %f2, fble_else.21636
	setL %g3, min_caml_rsqrt_table
	fld	%f0, %g3, 16
	b	fble_cont.21637
fble_else.21636:
	setL %g3, l.14068
	fld	%f2, %g3, 0
	fdiv	%f1, %f1, %f2
	mvhi	%g3, 0
	mvlo	%g3, 3
	fmov	%f0, %f1
	st	%g31, %g1, 12
	addi	%g1, %g1, 16
	call	get_sqrt_init_rec.6532.10574
	subi	%g1, %g1, 16
	ld	%g31, %g1, 12
fble_cont.21637:
fble_cont.21635:
fble_cont.21633:
	setL %g3, l.13995
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	setL %g3, l.14106
	fld	%f2, %g3, 0
	fld	%f3, %g1, 0
	fmul	%f4, %f3, %f0
	fmul	%f0, %f4, %f0
	fsub	%f0, %f2, %f0
	fmul	%f0, %f1, %f0
	setL %g3, l.13995
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	setL %g3, l.14106
	fld	%f2, %g3, 0
	fmul	%f4, %f3, %f0
	fmul	%f0, %f4, %f0
	fsub	%f0, %f2, %f0
	fmul	%f0, %f1, %f0
	setL %g3, l.13995
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	setL %g3, l.14106
	fld	%f2, %g3, 0
	fmul	%f4, %f3, %f0
	fmul	%f0, %f4, %f0
	fsub	%f0, %f2, %f0
	fmul	%f0, %f1, %f0
	setL %g3, l.13995
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	setL %g3, l.14106
	fld	%f2, %g3, 0
	fmul	%f4, %f3, %f0
	fmul	%f0, %f4, %f0
	fsub	%f0, %f2, %f0
	fmul	%f0, %f1, %f0
	setL %g3, l.13995
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	setL %g3, l.14106
	fld	%f2, %g3, 0
	fmul	%f4, %f3, %f0
	fmul	%f0, %f4, %f0
	fsub	%f0, %f2, %f0
	fmul	%f0, %f1, %f0
	setL %g3, l.13995
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	setL %g3, l.14106
	fld	%f2, %g3, 0
	fmul	%f4, %f3, %f0
	fmul	%f0, %f4, %f0
	fsub	%f0, %f2, %f0
	fmul	%f0, %f1, %f0
	setL %g3, l.13995
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	setL %g3, l.14106
	fld	%f2, %g3, 0
	fmul	%f4, %f3, %f0
	fmul	%f0, %f4, %f0
	fsub	%f0, %f2, %f0
	fmul	%f0, %f1, %f0
	setL %g3, l.13995
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	setL %g3, l.14106
	fld	%f2, %g3, 0
	fmul	%f4, %f3, %f0
	fmul	%f0, %f4, %f0
	fsub	%f0, %f2, %f0
	fmul	%f0, %f1, %f0
	setL %g3, l.13995
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	setL %g3, l.14106
	fld	%f2, %g3, 0
	fmul	%f4, %f3, %f0
	fmul	%f0, %f4, %f0
	fsub	%f0, %f2, %f0
	fmul	%f0, %f1, %f0
	setL %g3, l.13995
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	setL %g3, l.14106
	fld	%f2, %g3, 0
	fmul	%f4, %f3, %f0
	fmul	%f0, %f4, %f0
	fsub	%f0, %f2, %f0
	fmul	%f0, %f1, %f0
	fmul	%f0, %f0, %f3
	return
fble_else.21631:
	setL %g3, l.13995
	fld	%f1, %g3, 0
	fdiv	%f2, %f0, %f0
	fadd	%f2, %f0, %f2
	fmul	%f1, %f1, %f2
	setL %g3, l.13995
	fld	%f2, %g3, 0
	fdiv	%f3, %f0, %f1
	fadd	%f1, %f1, %f3
	fmul	%f1, %f2, %f1
	setL %g3, l.13995
	fld	%f2, %g3, 0
	fdiv	%f3, %f0, %f1
	fadd	%f1, %f1, %f3
	fmul	%f1, %f2, %f1
	setL %g3, l.13995
	fld	%f2, %g3, 0
	fdiv	%f3, %f0, %f1
	fadd	%f1, %f1, %f3
	fmul	%f1, %f2, %f1
	setL %g3, l.13995
	fld	%f2, %g3, 0
	fdiv	%f3, %f0, %f1
	fadd	%f1, %f1, %f3
	fmul	%f1, %f2, %f1
	setL %g3, l.13995
	fld	%f2, %g3, 0
	fdiv	%f3, %f0, %f1
	fadd	%f1, %f1, %f3
	fmul	%f1, %f2, %f1
	setL %g3, l.13995
	fld	%f2, %g3, 0
	fdiv	%f3, %f0, %f1
	fadd	%f1, %f1, %f3
	fmul	%f1, %f2, %f1
	setL %g3, l.13995
	fld	%f2, %g3, 0
	fdiv	%f3, %f0, %f1
	fadd	%f1, %f1, %f3
	fmul	%f1, %f2, %f1
	setL %g3, l.13995
	fld	%f2, %g3, 0
	fdiv	%f3, %f0, %f1
	fadd	%f1, %f1, %f3
	fmul	%f1, %f2, %f1
	setL %g3, l.13995
	fld	%f2, %g3, 0
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f1, %f0
	fmul	%f0, %f2, %f0
	return
vecunit_sgn.2816:
	fld	%f0, %g3, 0
	fmul	%f0, %f0, %f0
	fld	%f1, %g3, 8
	fmul	%f1, %f1, %f1
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, 16
	fmul	%f1, %f1, %f1
	fadd	%f0, %f0, %f1
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	st	%g31, %g1, 12
	addi	%g1, %g1, 16
	call	sqrt.2751
	subi	%g1, %g1, 16
	ld	%g31, %g1, 12
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fbne	%f0, %f1, fbe_else.21638
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fbe_cont.21639
fbe_else.21638:
	mvhi	%g3, 0
	mvlo	%g3, 0
fbe_cont.21639:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.21640
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 4
	bne	%g4, %g3, beq_else.21642
	setL %g3, l.14053
	fld	%f1, %g3, 0
	fdiv	%f0, %f1, %f0
	b	beq_cont.21643
beq_else.21642:
	setL %g3, l.14131
	fld	%f1, %g3, 0
	fdiv	%f0, %f1, %f0
beq_cont.21643:
	b	beq_cont.21641
beq_else.21640:
	setL %g3, l.14053
	fld	%f0, %g3, 0
beq_cont.21641:
	ld	%g3, %g1, 0
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	fst	%f1, %g3, 0
	fld	%f1, %g3, 8
	fmul	%f1, %f1, %f0
	fst	%f1, %g3, 8
	fld	%f1, %g3, 16
	fmul	%f0, %f1, %f0
	fst	%f0, %g3, 16
	return
vecaccumv.2840:
	fld	%f0, %g3, 0
	fld	%f1, %g4, 0
	fld	%f2, %g5, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, 0
	fld	%f0, %g3, 8
	fld	%f1, %g4, 8
	fld	%f2, %g5, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, 8
	fld	%f0, %g3, 16
	fld	%f1, %g4, 16
	fld	%f2, %g5, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g3, 16
	return
read_screen_settings.2917:
	ld	%g3, %g30, 60
	ld	%g4, %g30, 56
	ld	%g5, %g30, 52
	ld	%g6, %g30, 48
	ld	%g7, %g30, 44
	ld	%g8, %g30, 40
	fld	%f0, %g30, 32
	fld	%f1, %g30, 24
	fld	%f2, %g30, 16
	ld	%g9, %g30, 12
	ld	%g10, %g30, 8
	ld	%g11, %g30, 4
	st	%g3, %g1, 0
	st	%g6, %g1, 4
	st	%g7, %g1, 8
	st	%g5, %g1, 12
	st	%g10, %g1, 16
	st	%g4, %g1, 20
	st	%g11, %g1, 24
	st	%g9, %g1, 28
	std	%f1, %g1, 32
	std	%f2, %g1, 40
	std	%f0, %g1, 48
	st	%g8, %g1, 56
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	min_caml_read_float
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 56
	fst	%f0, %g3, 0
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	min_caml_read_float
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 56
	fst	%f0, %g3, 8
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	min_caml_read_float
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 56
	fst	%f0, %g3, 16
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	min_caml_read_float
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	setL %g3, l.14155
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.14007
	fld	%f1, %g3, 0
	std	%f0, %g1, 64
	fblt	%f0, %f1, fble_else.21647
	fneg	%f1, %f0
	ld	%g30, %g1, 28
	fmov	%f0, %f1
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	b	fble_cont.21648
fble_else.21647:
	fld	%f1, %g1, 48
	fblt	%f0, %f1, fble_else.21649
	ld	%g30, %g1, 24
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	b	fble_cont.21650
fble_else.21649:
	fld	%f2, %g1, 40
	fblt	%f0, %f2, fble_else.21651
	fsub	%f3, %f2, %f0
	ld	%g30, %g1, 24
	fmov	%f0, %f3
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fneg	%f0, %f0
	b	fble_cont.21652
fble_else.21651:
	fld	%f3, %g1, 32
	fblt	%f0, %f3, fble_else.21653
	fsub	%f4, %f3, %f0
	ld	%g30, %g1, 28
	fmov	%f0, %f4
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	b	fble_cont.21654
fble_else.21653:
	fsub	%f4, %f0, %f3
	ld	%g30, %g1, 28
	fmov	%f0, %f4
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
fble_cont.21654:
fble_cont.21652:
fble_cont.21650:
fble_cont.21648:
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fld	%f2, %g1, 64
	std	%f0, %g1, 72
	fblt	%f2, %f1, fble_else.21655
	fneg	%f1, %f2
	ld	%g30, %g1, 20
	fmov	%f0, %f1
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fneg	%f0, %f0
	b	fble_cont.21656
fble_else.21655:
	fld	%f1, %g1, 48
	fblt	%f2, %f1, fble_else.21657
	ld	%g30, %g1, 16
	fmov	%f0, %f2
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	b	fble_cont.21658
fble_else.21657:
	fld	%f3, %g1, 40
	fblt	%f2, %f3, fble_else.21659
	fsub	%f2, %f3, %f2
	ld	%g30, %g1, 16
	fmov	%f0, %f2
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	b	fble_cont.21660
fble_else.21659:
	fld	%f4, %g1, 32
	fblt	%f2, %f4, fble_else.21661
	fsub	%f2, %f4, %f2
	ld	%g30, %g1, 20
	fmov	%f0, %f2
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fneg	%f0, %f0
	b	fble_cont.21662
fble_else.21661:
	fsub	%f2, %f2, %f4
	ld	%g30, %g1, 20
	fmov	%f0, %f2
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
fble_cont.21662:
fble_cont.21660:
fble_cont.21658:
fble_cont.21656:
	std	%f0, %g1, 80
	st	%g31, %g1, 92
	addi	%g1, %g1, 96
	call	min_caml_read_float
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
	setL %g3, l.14155
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.14007
	fld	%f1, %g3, 0
	std	%f0, %g1, 88
	fblt	%f0, %f1, fble_else.21663
	fneg	%f1, %f0
	ld	%g30, %g1, 28
	fmov	%f0, %f1
	st	%g31, %g1, 100
	ld	%g29, %g30, 0
	addi	%g1, %g1, 104
	call	%g29
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	b	fble_cont.21664
fble_else.21663:
	fld	%f1, %g1, 48
	fblt	%f0, %f1, fble_else.21665
	ld	%g30, %g1, 24
	st	%g31, %g1, 100
	ld	%g29, %g30, 0
	addi	%g1, %g1, 104
	call	%g29
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	b	fble_cont.21666
fble_else.21665:
	fld	%f2, %g1, 40
	fblt	%f0, %f2, fble_else.21667
	fsub	%f3, %f2, %f0
	ld	%g30, %g1, 24
	fmov	%f0, %f3
	st	%g31, %g1, 100
	ld	%g29, %g30, 0
	addi	%g1, %g1, 104
	call	%g29
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	fneg	%f0, %f0
	b	fble_cont.21668
fble_else.21667:
	fld	%f3, %g1, 32
	fblt	%f0, %f3, fble_else.21669
	fsub	%f4, %f3, %f0
	ld	%g30, %g1, 28
	fmov	%f0, %f4
	st	%g31, %g1, 100
	ld	%g29, %g30, 0
	addi	%g1, %g1, 104
	call	%g29
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	b	fble_cont.21670
fble_else.21669:
	fsub	%f4, %f0, %f3
	ld	%g30, %g1, 28
	fmov	%f0, %f4
	st	%g31, %g1, 100
	ld	%g29, %g30, 0
	addi	%g1, %g1, 104
	call	%g29
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
fble_cont.21670:
fble_cont.21668:
fble_cont.21666:
fble_cont.21664:
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fld	%f2, %g1, 88
	std	%f0, %g1, 96
	fblt	%f2, %f1, fble_else.21671
	fneg	%f1, %f2
	ld	%g30, %g1, 20
	fmov	%f0, %f1
	st	%g31, %g1, 108
	ld	%g29, %g30, 0
	addi	%g1, %g1, 112
	call	%g29
	subi	%g1, %g1, 112
	ld	%g31, %g1, 108
	fneg	%f0, %f0
	b	fble_cont.21672
fble_else.21671:
	fld	%f1, %g1, 48
	fblt	%f2, %f1, fble_else.21673
	ld	%g30, %g1, 16
	fmov	%f0, %f2
	st	%g31, %g1, 108
	ld	%g29, %g30, 0
	addi	%g1, %g1, 112
	call	%g29
	subi	%g1, %g1, 112
	ld	%g31, %g1, 108
	b	fble_cont.21674
fble_else.21673:
	fld	%f1, %g1, 40
	fblt	%f2, %f1, fble_else.21675
	fsub	%f1, %f1, %f2
	ld	%g30, %g1, 16
	fmov	%f0, %f1
	st	%g31, %g1, 108
	ld	%g29, %g30, 0
	addi	%g1, %g1, 112
	call	%g29
	subi	%g1, %g1, 112
	ld	%g31, %g1, 108
	b	fble_cont.21676
fble_else.21675:
	fld	%f1, %g1, 32
	fblt	%f2, %f1, fble_else.21677
	fsub	%f1, %f1, %f2
	ld	%g30, %g1, 20
	fmov	%f0, %f1
	st	%g31, %g1, 108
	ld	%g29, %g30, 0
	addi	%g1, %g1, 112
	call	%g29
	subi	%g1, %g1, 112
	ld	%g31, %g1, 108
	fneg	%f0, %f0
	b	fble_cont.21678
fble_else.21677:
	fsub	%f1, %f2, %f1
	ld	%g30, %g1, 20
	fmov	%f0, %f1
	st	%g31, %g1, 108
	ld	%g29, %g30, 0
	addi	%g1, %g1, 112
	call	%g29
	subi	%g1, %g1, 112
	ld	%g31, %g1, 108
fble_cont.21678:
fble_cont.21676:
fble_cont.21674:
fble_cont.21672:
	fld	%f1, %g1, 72
	fmul	%f2, %f1, %f0
	setL %g3, l.14162
	fld	%f3, %g3, 0
	fmul	%f2, %f2, %f3
	ld	%g3, %g1, 12
	fst	%f2, %g3, 0
	setL %g4, l.14165
	fld	%f2, %g4, 0
	fld	%f3, %g1, 80
	fmul	%f2, %f3, %f2
	fst	%f2, %g3, 8
	fld	%f2, %g1, 96
	fmul	%f4, %f1, %f2
	setL %g4, l.14162
	fld	%f5, %g4, 0
	fmul	%f4, %f4, %f5
	fst	%f4, %g3, 16
	ld	%g4, %g1, 8
	fst	%f2, %g4, 0
	setL %g5, l.14007
	fld	%f4, %g5, 0
	fst	%f4, %g4, 8
	fneg	%f4, %f0
	fst	%f4, %g4, 16
	fneg	%f4, %f3
	fmul	%f0, %f4, %f0
	ld	%g4, %g1, 4
	fst	%f0, %g4, 0
	fneg	%f0, %f1
	fst	%f0, %g4, 8
	fneg	%f0, %f3
	fmul	%f0, %f0, %f2
	fst	%f0, %g4, 16
	ld	%g4, %g1, 56
	fld	%f0, %g4, 0
	fld	%f1, %g3, 0
	fsub	%f0, %f0, %f1
	ld	%g5, %g1, 0
	fst	%f0, %g5, 0
	fld	%f0, %g4, 8
	fld	%f1, %g3, 8
	fsub	%f0, %f0, %f1
	fst	%f0, %g5, 8
	fld	%f0, %g4, 16
	fld	%f1, %g3, 16
	fsub	%f0, %f0, %f1
	fst	%f0, %g5, 16
	return
read_light.2919:
	ld	%g3, %g30, 48
	fld	%f0, %g30, 40
	fld	%f1, %g30, 32
	fld	%f2, %g30, 24
	ld	%g4, %g30, 20
	ld	%g5, %g30, 16
	ld	%g6, %g30, 12
	ld	%g7, %g30, 8
	ld	%g8, %g30, 4
	st	%g8, %g1, 0
	st	%g7, %g1, 4
	st	%g5, %g1, 8
	st	%g4, %g1, 12
	st	%g6, %g1, 16
	st	%g3, %g1, 20
	std	%f1, %g1, 24
	std	%f2, %g1, 32
	std	%f0, %g1, 40
	input	%g3
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_read_float
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	setL %g3, l.14155
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.14007
	fld	%f1, %g3, 0
	std	%f0, %g1, 48
	fblt	%f0, %f1, fble_else.21680
	fneg	%f1, %f0
	ld	%g30, %g1, 20
	fmov	%f0, %f1
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fneg	%f0, %f0
	b	fble_cont.21681
fble_else.21680:
	fld	%f1, %g1, 40
	fblt	%f0, %f1, fble_else.21682
	ld	%g30, %g1, 16
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	b	fble_cont.21683
fble_else.21682:
	fld	%f2, %g1, 32
	fblt	%f0, %f2, fble_else.21684
	fsub	%f3, %f2, %f0
	ld	%g30, %g1, 16
	fmov	%f0, %f3
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	b	fble_cont.21685
fble_else.21684:
	fld	%f3, %g1, 24
	fblt	%f0, %f3, fble_else.21686
	fsub	%f4, %f3, %f0
	ld	%g30, %g1, 20
	fmov	%f0, %f4
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	fneg	%f0, %f0
	b	fble_cont.21687
fble_else.21686:
	fsub	%f4, %f0, %f3
	ld	%g30, %g1, 20
	fmov	%f0, %f4
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
fble_cont.21687:
fble_cont.21685:
fble_cont.21683:
fble_cont.21681:
	fneg	%f0, %f0
	ld	%g3, %g1, 12
	fst	%f0, %g3, 8
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	min_caml_read_float
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	setL %g3, l.14155
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fld	%f2, %g1, 48
	std	%f0, %g1, 56
	fblt	%f2, %f1, fble_else.21688
	fneg	%f1, %f2
	ld	%g30, %g1, 8
	fmov	%f0, %f1
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	b	fble_cont.21689
fble_else.21688:
	fld	%f1, %g1, 40
	fblt	%f2, %f1, fble_else.21690
	ld	%g30, %g1, 4
	fmov	%f0, %f2
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	b	fble_cont.21691
fble_else.21690:
	fld	%f3, %g1, 32
	fblt	%f2, %f3, fble_else.21692
	fsub	%f2, %f3, %f2
	ld	%g30, %g1, 4
	fmov	%f0, %f2
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fneg	%f0, %f0
	b	fble_cont.21693
fble_else.21692:
	fld	%f4, %g1, 24
	fblt	%f2, %f4, fble_else.21694
	fsub	%f2, %f4, %f2
	ld	%g30, %g1, 8
	fmov	%f0, %f2
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	b	fble_cont.21695
fble_else.21694:
	fsub	%f2, %f2, %f4
	ld	%g30, %g1, 8
	fmov	%f0, %f2
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
fble_cont.21695:
fble_cont.21693:
fble_cont.21691:
fble_cont.21689:
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fld	%f2, %g1, 56
	std	%f0, %g1, 64
	fblt	%f2, %f1, fble_else.21696
	fneg	%f1, %f2
	ld	%g30, %g1, 20
	fmov	%f0, %f1
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fneg	%f0, %f0
	b	fble_cont.21697
fble_else.21696:
	fld	%f1, %g1, 40
	fblt	%f2, %f1, fble_else.21698
	ld	%g30, %g1, 16
	fmov	%f0, %f2
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	b	fble_cont.21699
fble_else.21698:
	fld	%f3, %g1, 32
	fblt	%f2, %f3, fble_else.21700
	fsub	%f4, %f3, %f2
	ld	%g30, %g1, 16
	fmov	%f0, %f4
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	b	fble_cont.21701
fble_else.21700:
	fld	%f4, %g1, 24
	fblt	%f2, %f4, fble_else.21702
	fsub	%f5, %f4, %f2
	ld	%g30, %g1, 20
	fmov	%f0, %f5
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fneg	%f0, %f0
	b	fble_cont.21703
fble_else.21702:
	fsub	%f5, %f2, %f4
	ld	%g30, %g1, 20
	fmov	%f0, %f5
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
fble_cont.21703:
fble_cont.21701:
fble_cont.21699:
fble_cont.21697:
	fld	%f1, %g1, 64
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 12
	fst	%f0, %g3, 0
	setL %g4, l.14007
	fld	%f0, %g4, 0
	fld	%f2, %g1, 56
	fblt	%f2, %f0, fble_else.21704
	fneg	%f0, %f2
	ld	%g30, %g1, 8
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	b	fble_cont.21705
fble_else.21704:
	fld	%f0, %g1, 40
	fblt	%f2, %f0, fble_else.21706
	ld	%g30, %g1, 4
	fmov	%f0, %f2
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	b	fble_cont.21707
fble_else.21706:
	fld	%f0, %g1, 32
	fblt	%f2, %f0, fble_else.21708
	fsub	%f0, %f0, %f2
	ld	%g30, %g1, 4
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fneg	%f0, %f0
	b	fble_cont.21709
fble_else.21708:
	fld	%f0, %g1, 24
	fblt	%f2, %f0, fble_else.21710
	fsub	%f0, %f0, %f2
	ld	%g30, %g1, 8
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	b	fble_cont.21711
fble_else.21710:
	fsub	%f0, %f2, %f0
	ld	%g30, %g1, 8
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
fble_cont.21711:
fble_cont.21709:
fble_cont.21707:
fble_cont.21705:
	fld	%f1, %g1, 64
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 12
	fst	%f0, %g3, 16
	st	%g31, %g1, 76
	addi	%g1, %g1, 80
	call	min_caml_read_float
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	return
rotate_quadratic_matrix.2921:
	ld	%g5, %g30, 40
	fld	%f0, %g30, 32
	fld	%f1, %g30, 24
	fld	%f2, %g30, 16
	ld	%g6, %g30, 12
	ld	%g7, %g30, 8
	ld	%g30, %g30, 4
	fld	%f3, %g4, 0
	setL %g8, l.14007
	fld	%f4, %g8, 0
	st	%g3, %g1, 0
	st	%g30, %g1, 4
	st	%g6, %g1, 8
	st	%g7, %g1, 12
	st	%g5, %g1, 16
	std	%f1, %g1, 24
	std	%f2, %g1, 32
	std	%f0, %g1, 40
	st	%g4, %g1, 48
	fblt	%f3, %f4, fble_else.21714
	fneg	%f3, %f3
	mov	%g30, %g6
	fmov	%f0, %f3
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	b	fble_cont.21715
fble_else.21714:
	fblt	%f3, %f0, fble_else.21716
	fmov	%f0, %f3
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	b	fble_cont.21717
fble_else.21716:
	fblt	%f3, %f2, fble_else.21718
	fsub	%f3, %f2, %f3
	fmov	%f0, %f3
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fneg	%f0, %f0
	b	fble_cont.21719
fble_else.21718:
	fblt	%f3, %f1, fble_else.21720
	fsub	%f3, %f1, %f3
	mov	%g30, %g6
	fmov	%f0, %f3
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	b	fble_cont.21721
fble_else.21720:
	fsub	%f3, %f3, %f1
	mov	%g30, %g6
	fmov	%f0, %f3
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
fble_cont.21721:
fble_cont.21719:
fble_cont.21717:
fble_cont.21715:
	ld	%g3, %g1, 48
	fld	%f1, %g3, 0
	setL %g4, l.14007
	fld	%f2, %g4, 0
	std	%f0, %g1, 56
	fblt	%f1, %f2, fble_else.21723
	fneg	%f1, %f1
	ld	%g30, %g1, 16
	fmov	%f0, %f1
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fneg	%f0, %f0
	b	fble_cont.21724
fble_else.21723:
	fld	%f2, %g1, 40
	fblt	%f1, %f2, fble_else.21725
	ld	%g30, %g1, 12
	fmov	%f0, %f1
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	b	fble_cont.21726
fble_else.21725:
	fld	%f3, %g1, 32
	fblt	%f1, %f3, fble_else.21727
	fsub	%f1, %f3, %f1
	ld	%g30, %g1, 12
	fmov	%f0, %f1
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	b	fble_cont.21728
fble_else.21727:
	fld	%f4, %g1, 24
	fblt	%f1, %f4, fble_else.21729
	fsub	%f1, %f4, %f1
	ld	%g30, %g1, 16
	fmov	%f0, %f1
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	fneg	%f0, %f0
	b	fble_cont.21730
fble_else.21729:
	fsub	%f1, %f1, %f4
	ld	%g30, %g1, 16
	fmov	%f0, %f1
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
fble_cont.21730:
fble_cont.21728:
fble_cont.21726:
fble_cont.21724:
	ld	%g3, %g1, 48
	fld	%f1, %g3, 8
	setL %g4, l.14007
	fld	%f2, %g4, 0
	std	%f0, %g1, 64
	fblt	%f1, %f2, fble_else.21731
	fneg	%f1, %f1
	ld	%g30, %g1, 8
	fmov	%f0, %f1
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	b	fble_cont.21732
fble_else.21731:
	fld	%f2, %g1, 40
	fblt	%f1, %f2, fble_else.21733
	ld	%g30, %g1, 4
	fmov	%f0, %f1
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	b	fble_cont.21734
fble_else.21733:
	fld	%f3, %g1, 32
	fblt	%f1, %f3, fble_else.21735
	fsub	%f1, %f3, %f1
	ld	%g30, %g1, 4
	fmov	%f0, %f1
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	fneg	%f0, %f0
	b	fble_cont.21736
fble_else.21735:
	fld	%f4, %g1, 24
	fblt	%f1, %f4, fble_else.21737
	fsub	%f1, %f4, %f1
	ld	%g30, %g1, 8
	fmov	%f0, %f1
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	b	fble_cont.21738
fble_else.21737:
	fsub	%f1, %f1, %f4
	ld	%g30, %g1, 8
	fmov	%f0, %f1
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
fble_cont.21738:
fble_cont.21736:
fble_cont.21734:
fble_cont.21732:
	ld	%g3, %g1, 48
	fld	%f1, %g3, 8
	setL %g4, l.14007
	fld	%f2, %g4, 0
	std	%f0, %g1, 72
	fblt	%f1, %f2, fble_else.21739
	fneg	%f1, %f1
	ld	%g30, %g1, 16
	fmov	%f0, %f1
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fneg	%f0, %f0
	b	fble_cont.21740
fble_else.21739:
	fld	%f2, %g1, 40
	fblt	%f1, %f2, fble_else.21741
	ld	%g30, %g1, 12
	fmov	%f0, %f1
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	b	fble_cont.21742
fble_else.21741:
	fld	%f3, %g1, 32
	fblt	%f1, %f3, fble_else.21743
	fsub	%f1, %f3, %f1
	ld	%g30, %g1, 12
	fmov	%f0, %f1
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	b	fble_cont.21744
fble_else.21743:
	fld	%f4, %g1, 24
	fblt	%f1, %f4, fble_else.21745
	fsub	%f1, %f4, %f1
	ld	%g30, %g1, 16
	fmov	%f0, %f1
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fneg	%f0, %f0
	b	fble_cont.21746
fble_else.21745:
	fsub	%f1, %f1, %f4
	ld	%g30, %g1, 16
	fmov	%f0, %f1
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
fble_cont.21746:
fble_cont.21744:
fble_cont.21742:
fble_cont.21740:
	ld	%g3, %g1, 48
	fld	%f1, %g3, 16
	setL %g4, l.14007
	fld	%f2, %g4, 0
	std	%f0, %g1, 80
	fblt	%f1, %f2, fble_else.21747
	fneg	%f1, %f1
	ld	%g30, %g1, 8
	fmov	%f0, %f1
	st	%g31, %g1, 92
	ld	%g29, %g30, 0
	addi	%g1, %g1, 96
	call	%g29
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
	b	fble_cont.21748
fble_else.21747:
	fld	%f2, %g1, 40
	fblt	%f1, %f2, fble_else.21749
	ld	%g30, %g1, 4
	fmov	%f0, %f1
	st	%g31, %g1, 92
	ld	%g29, %g30, 0
	addi	%g1, %g1, 96
	call	%g29
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
	b	fble_cont.21750
fble_else.21749:
	fld	%f3, %g1, 32
	fblt	%f1, %f3, fble_else.21751
	fsub	%f1, %f3, %f1
	ld	%g30, %g1, 4
	fmov	%f0, %f1
	st	%g31, %g1, 92
	ld	%g29, %g30, 0
	addi	%g1, %g1, 96
	call	%g29
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
	fneg	%f0, %f0
	b	fble_cont.21752
fble_else.21751:
	fld	%f4, %g1, 24
	fblt	%f1, %f4, fble_else.21753
	fsub	%f1, %f4, %f1
	ld	%g30, %g1, 8
	fmov	%f0, %f1
	st	%g31, %g1, 92
	ld	%g29, %g30, 0
	addi	%g1, %g1, 96
	call	%g29
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
	b	fble_cont.21754
fble_else.21753:
	fsub	%f1, %f1, %f4
	ld	%g30, %g1, 8
	fmov	%f0, %f1
	st	%g31, %g1, 92
	ld	%g29, %g30, 0
	addi	%g1, %g1, 96
	call	%g29
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
fble_cont.21754:
fble_cont.21752:
fble_cont.21750:
fble_cont.21748:
	ld	%g3, %g1, 48
	fld	%f1, %g3, 16
	setL %g4, l.14007
	fld	%f2, %g4, 0
	std	%f0, %g1, 88
	fblt	%f1, %f2, fble_else.21755
	fneg	%f1, %f1
	ld	%g30, %g1, 16
	fmov	%f0, %f1
	st	%g31, %g1, 100
	ld	%g29, %g30, 0
	addi	%g1, %g1, 104
	call	%g29
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	fneg	%f0, %f0
	b	fble_cont.21756
fble_else.21755:
	fld	%f2, %g1, 40
	fblt	%f1, %f2, fble_else.21757
	ld	%g30, %g1, 12
	fmov	%f0, %f1
	st	%g31, %g1, 100
	ld	%g29, %g30, 0
	addi	%g1, %g1, 104
	call	%g29
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	b	fble_cont.21758
fble_else.21757:
	fld	%f2, %g1, 32
	fblt	%f1, %f2, fble_else.21759
	fsub	%f1, %f2, %f1
	ld	%g30, %g1, 12
	fmov	%f0, %f1
	st	%g31, %g1, 100
	ld	%g29, %g30, 0
	addi	%g1, %g1, 104
	call	%g29
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	b	fble_cont.21760
fble_else.21759:
	fld	%f2, %g1, 24
	fblt	%f1, %f2, fble_else.21761
	fsub	%f1, %f2, %f1
	ld	%g30, %g1, 16
	fmov	%f0, %f1
	st	%g31, %g1, 100
	ld	%g29, %g30, 0
	addi	%g1, %g1, 104
	call	%g29
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	fneg	%f0, %f0
	b	fble_cont.21762
fble_else.21761:
	fsub	%f1, %f1, %f2
	ld	%g30, %g1, 16
	fmov	%f0, %f1
	st	%g31, %g1, 100
	ld	%g29, %g30, 0
	addi	%g1, %g1, 104
	call	%g29
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
fble_cont.21762:
fble_cont.21760:
fble_cont.21758:
fble_cont.21756:
	fld	%f1, %g1, 88
	fld	%f2, %g1, 72
	fmul	%f3, %f2, %f1
	fld	%f4, %g1, 80
	fld	%f5, %g1, 64
	fmul	%f6, %f5, %f4
	fmul	%f6, %f6, %f1
	fld	%f7, %g1, 56
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
	fneg	%f1, %f4
	fmul	%f4, %f5, %f2
	fmul	%f2, %f7, %f2
	ld	%g3, %g1, 0
	fld	%f5, %g3, 0
	fld	%f7, %g3, 8
	fld	%f11, %g3, 16
	fmul	%f12, %f3, %f3
	fmul	%f12, %f5, %f12
	fmul	%f13, %f9, %f9
	fmul	%f13, %f7, %f13
	fadd	%f12, %f12, %f13
	fmul	%f13, %f1, %f1
	fmul	%f13, %f11, %f13
	fadd	%f12, %f12, %f13
	fst	%f12, %g3, 0
	fmul	%f12, %f6, %f6
	fmul	%f12, %f5, %f12
	fmul	%f13, %f10, %f10
	fmul	%f13, %f7, %f13
	fadd	%f12, %f12, %f13
	fmul	%f13, %f4, %f4
	fmul	%f13, %f11, %f13
	fadd	%f12, %f12, %f13
	fst	%f12, %g3, 8
	fmul	%f12, %f8, %f8
	fmul	%f12, %f5, %f12
	fmul	%f13, %f0, %f0
	fmul	%f13, %f7, %f13
	fadd	%f12, %f12, %f13
	fmul	%f13, %f2, %f2
	fmul	%f13, %f11, %f13
	fadd	%f12, %f12, %f13
	fst	%f12, %g3, 16
	setL %g3, l.14068
	fld	%f12, %g3, 0
	fmul	%f13, %f5, %f6
	fmul	%f13, %f13, %f8
	fmul	%f14, %f7, %f10
	fmul	%f14, %f14, %f0
	fadd	%f13, %f13, %f14
	fmul	%f14, %f11, %f4
	fmul	%f14, %f14, %f2
	fadd	%f13, %f13, %f14
	fmul	%f12, %f12, %f13
	ld	%g3, %g1, 48
	fst	%f12, %g3, 0
	setL %g4, l.14068
	fld	%f12, %g4, 0
	fmul	%f13, %f5, %f3
	fmul	%f8, %f13, %f8
	fmul	%f13, %f7, %f9
	fmul	%f0, %f13, %f0
	fadd	%f0, %f8, %f0
	fmul	%f8, %f11, %f1
	fmul	%f2, %f8, %f2
	fadd	%f0, %f0, %f2
	fmul	%f0, %f12, %f0
	fst	%f0, %g3, 8
	setL %g4, l.14068
	fld	%f0, %g4, 0
	fmul	%f2, %f5, %f3
	fmul	%f2, %f2, %f6
	fmul	%f3, %f7, %f9
	fmul	%f3, %f3, %f10
	fadd	%f2, %f2, %f3
	fmul	%f1, %f11, %f1
	fmul	%f1, %f1, %f4
	fadd	%f1, %f2, %f1
	fmul	%f0, %f0, %f1
	fst	%f0, %g3, 16
	return
read_nth_object.2924:
	ld	%g4, %g30, 8
	ld	%g5, %g30, 4
	st	%g4, %g1, 0
	st	%g5, %g1, 4
	st	%g3, %g1, 8
	input	%g3
	mvhi	%g4, 65535
	mvlo	%g4, -1
	bne	%g3, %g4, beq_else.21764
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.21764:
	st	%g3, %g1, 12
	input	%g3
	st	%g3, %g1, 16
	input	%g3
	st	%g3, %g1, 20
	input	%g3
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	min_caml_create_float_array
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	st	%g3, %g1, 28
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_read_float
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	fst	%f0, %g3, 0
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_read_float
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	fst	%f0, %g3, 8
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_read_float
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	fst	%f0, %g3, 16
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	mov	%g3, %g4
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_create_float_array
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	st	%g3, %g1, 32
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_read_float
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	fst	%f0, %g3, 0
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_read_float
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	fst	%f0, %g3, 8
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_read_float
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	fst	%f0, %g3, 16
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_read_float
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fblt	%f0, %f1, fble_else.21765
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.21766
fble_else.21765:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.21766:
	mvhi	%g4, 0
	mvlo	%g4, 2
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 36
	mov	%g3, %g4
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	min_caml_create_float_array
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	st	%g3, %g1, 40
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	min_caml_read_float
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 40
	fst	%f0, %g3, 0
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	min_caml_read_float
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 40
	fst	%f0, %g3, 8
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	mov	%g3, %g4
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	min_caml_create_float_array
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	st	%g3, %g1, 44
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_read_float
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 44
	fst	%f0, %g3, 0
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_read_float
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 44
	fst	%f0, %g3, 8
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_read_float
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 44
	fst	%f0, %g3, 16
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	mov	%g3, %g4
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_create_float_array
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g5, %g1, 24
	bne	%g5, %g4, beq_else.21767
	b	beq_cont.21768
beq_else.21767:
	st	%g3, %g1, 48
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_read_float
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	setL %g3, l.14155
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 48
	fst	%f0, %g3, 0
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_read_float
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	setL %g3, l.14155
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 48
	fst	%f0, %g3, 8
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_read_float
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	setL %g3, l.14155
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 48
	fst	%f0, %g3, 16
beq_cont.21768:
	mvhi	%g4, 0
	mvlo	%g4, 2
	ld	%g5, %g1, 16
	bne	%g5, %g4, beq_else.21769
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	beq_cont.21770
beq_else.21769:
	ld	%g4, %g1, 36
beq_cont.21770:
	mvhi	%g6, 0
	mvlo	%g6, 4
	setL %g7, l.14007
	fld	%f0, %g7, 0
	st	%g4, %g1, 52
	st	%g3, %g1, 48
	mov	%g3, %g6
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	min_caml_create_float_array
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g2
	addi	%g2, %g2, 48
	st	%g3, %g4, 40
	ld	%g3, %g1, 48
	st	%g3, %g4, 36
	ld	%g5, %g1, 44
	st	%g5, %g4, 32
	ld	%g5, %g1, 40
	st	%g5, %g4, 28
	ld	%g5, %g1, 52
	st	%g5, %g4, 24
	ld	%g5, %g1, 32
	st	%g5, %g4, 20
	ld	%g5, %g1, 28
	st	%g5, %g4, 16
	ld	%g6, %g1, 24
	st	%g6, %g4, 12
	ld	%g7, %g1, 20
	st	%g7, %g4, 8
	ld	%g7, %g1, 16
	st	%g7, %g4, 4
	ld	%g8, %g1, 12
	st	%g8, %g4, 0
	ld	%g8, %g1, 8
	slli	%g8, %g8, 2
	ld	%g9, %g1, 4
	st	%g4, %g9, %g8
	mvhi	%g4, 0
	mvlo	%g4, 3
	bne	%g7, %g4, beq_else.21771
	fld	%f0, %g5, 0
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fbne	%f0, %f1, fbe_else.21773
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fbe_cont.21774
fbe_else.21773:
	mvhi	%g4, 0
	mvlo	%g4, 0
fbe_cont.21774:
	mvhi	%g7, 0
	mvlo	%g7, 0
	bne	%g4, %g7, beq_else.21775
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fbne	%f0, %f1, fbe_else.21777
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fbe_cont.21778
fbe_else.21777:
	mvhi	%g4, 0
	mvlo	%g4, 0
fbe_cont.21778:
	mvhi	%g7, 0
	mvlo	%g7, 0
	bne	%g4, %g7, beq_else.21779
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f1, %f0, fble_else.21781
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.21782
fble_else.21781:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.21782:
	mvhi	%g7, 0
	mvlo	%g7, 0
	bne	%g4, %g7, beq_else.21783
	setL %g4, l.14131
	fld	%f1, %g4, 0
	b	beq_cont.21784
beq_else.21783:
	setL %g4, l.14053
	fld	%f1, %g4, 0
beq_cont.21784:
	b	beq_cont.21780
beq_else.21779:
	setL %g4, l.14007
	fld	%f1, %g4, 0
beq_cont.21780:
	fmul	%f0, %f0, %f0
	fdiv	%f0, %f1, %f0
	b	beq_cont.21776
beq_else.21775:
	setL %g4, l.14007
	fld	%f0, %g4, 0
beq_cont.21776:
	fst	%f0, %g5, 0
	fld	%f0, %g5, 8
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fbne	%f0, %f1, fbe_else.21785
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fbe_cont.21786
fbe_else.21785:
	mvhi	%g4, 0
	mvlo	%g4, 0
fbe_cont.21786:
	mvhi	%g7, 0
	mvlo	%g7, 0
	bne	%g4, %g7, beq_else.21787
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fbne	%f0, %f1, fbe_else.21789
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fbe_cont.21790
fbe_else.21789:
	mvhi	%g4, 0
	mvlo	%g4, 0
fbe_cont.21790:
	mvhi	%g7, 0
	mvlo	%g7, 0
	bne	%g4, %g7, beq_else.21791
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f1, %f0, fble_else.21793
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.21794
fble_else.21793:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.21794:
	mvhi	%g7, 0
	mvlo	%g7, 0
	bne	%g4, %g7, beq_else.21795
	setL %g4, l.14131
	fld	%f1, %g4, 0
	b	beq_cont.21796
beq_else.21795:
	setL %g4, l.14053
	fld	%f1, %g4, 0
beq_cont.21796:
	b	beq_cont.21792
beq_else.21791:
	setL %g4, l.14007
	fld	%f1, %g4, 0
beq_cont.21792:
	fmul	%f0, %f0, %f0
	fdiv	%f0, %f1, %f0
	b	beq_cont.21788
beq_else.21787:
	setL %g4, l.14007
	fld	%f0, %g4, 0
beq_cont.21788:
	fst	%f0, %g5, 8
	fld	%f0, %g5, 16
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fbne	%f0, %f1, fbe_else.21797
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fbe_cont.21798
fbe_else.21797:
	mvhi	%g4, 0
	mvlo	%g4, 0
fbe_cont.21798:
	mvhi	%g7, 0
	mvlo	%g7, 0
	bne	%g4, %g7, beq_else.21799
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fbne	%f0, %f1, fbe_else.21801
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fbe_cont.21802
fbe_else.21801:
	mvhi	%g4, 0
	mvlo	%g4, 0
fbe_cont.21802:
	mvhi	%g7, 0
	mvlo	%g7, 0
	bne	%g4, %g7, beq_else.21803
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f1, %f0, fble_else.21805
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.21806
fble_else.21805:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.21806:
	mvhi	%g7, 0
	mvlo	%g7, 0
	bne	%g4, %g7, beq_else.21807
	setL %g4, l.14131
	fld	%f1, %g4, 0
	b	beq_cont.21808
beq_else.21807:
	setL %g4, l.14053
	fld	%f1, %g4, 0
beq_cont.21808:
	b	beq_cont.21804
beq_else.21803:
	setL %g4, l.14007
	fld	%f1, %g4, 0
beq_cont.21804:
	fmul	%f0, %f0, %f0
	fdiv	%f0, %f1, %f0
	b	beq_cont.21800
beq_else.21799:
	setL %g4, l.14007
	fld	%f0, %g4, 0
beq_cont.21800:
	fst	%f0, %g5, 16
	b	beq_cont.21772
beq_else.21771:
	mvhi	%g4, 0
	mvlo	%g4, 2
	bne	%g7, %g4, beq_else.21809
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g7, %g1, 36
	bne	%g7, %g4, beq_else.21811
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	beq_cont.21812
beq_else.21811:
	mvhi	%g4, 0
	mvlo	%g4, 0
beq_cont.21812:
	mov	%g3, %g5
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	vecunit_sgn.2816
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	b	beq_cont.21810
beq_else.21809:
beq_cont.21810:
beq_cont.21772:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 24
	bne	%g4, %g3, beq_else.21813
	b	beq_cont.21814
beq_else.21813:
	ld	%g3, %g1, 28
	ld	%g4, %g1, 48
	ld	%g30, %g1, 0
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
beq_cont.21814:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
read_object.2926:
	ld	%g4, %g30, 8
	ld	%g5, %g30, 4
	mvhi	%g6, 0
	mvlo	%g6, 60
	blt	%g3, %g6, ble_else.21815
	return
ble_else.21815:
	st	%g30, %g1, 0
	st	%g4, %g1, 4
	st	%g5, %g1, 8
	st	%g3, %g1, 12
	mov	%g30, %g4
	st	%g31, %g1, 20
	ld	%g29, %g30, 0
	addi	%g1, %g1, 24
	call	%g29
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.21817
	ld	%g3, %g1, 8
	ld	%g4, %g1, 12
	st	%g4, %g3, 0
	return
beq_else.21817:
	ld	%g3, %g1, 12
	addi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 60
	blt	%g3, %g4, ble_else.21819
	return
ble_else.21819:
	ld	%g30, %g1, 4
	st	%g3, %g1, 16
	st	%g31, %g1, 20
	ld	%g29, %g30, 0
	addi	%g1, %g1, 24
	call	%g29
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.21821
	ld	%g3, %g1, 8
	ld	%g4, %g1, 16
	st	%g4, %g3, 0
	return
beq_else.21821:
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 60
	blt	%g3, %g4, ble_else.21823
	return
ble_else.21823:
	ld	%g30, %g1, 4
	st	%g3, %g1, 20
	st	%g31, %g1, 28
	ld	%g29, %g30, 0
	addi	%g1, %g1, 32
	call	%g29
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.21825
	ld	%g3, %g1, 8
	ld	%g4, %g1, 20
	st	%g4, %g3, 0
	return
beq_else.21825:
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 60
	blt	%g3, %g4, ble_else.21827
	return
ble_else.21827:
	ld	%g30, %g1, 4
	st	%g3, %g1, 24
	st	%g31, %g1, 28
	ld	%g29, %g30, 0
	addi	%g1, %g1, 32
	call	%g29
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.21829
	ld	%g3, %g1, 8
	ld	%g4, %g1, 24
	st	%g4, %g3, 0
	return
beq_else.21829:
	ld	%g3, %g1, 24
	addi	%g3, %g3, 1
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
read_net_item.2930:
	st	%g3, %g1, 0
	input	%g3
	mvhi	%g4, 65535
	mvlo	%g4, -1
	bne	%g3, %g4, beq_else.21831
	ld	%g3, %g1, 0
	addi	%g3, %g3, 1
	mvhi	%g4, 65535
	mvlo	%g4, -1
	jmp	min_caml_create_array
beq_else.21831:
	ld	%g4, %g1, 0
	addi	%g5, %g4, 1
	st	%g3, %g1, 4
	st	%g5, %g1, 8
	input	%g3
	mvhi	%g4, 65535
	mvlo	%g4, -1
	bne	%g3, %g4, beq_else.21832
	ld	%g3, %g1, 8
	addi	%g3, %g3, 1
	mvhi	%g4, 65535
	mvlo	%g4, -1
	st	%g31, %g1, 12
	addi	%g1, %g1, 16
	call	min_caml_create_array
	subi	%g1, %g1, 16
	ld	%g31, %g1, 12
	b	beq_cont.21833
beq_else.21832:
	ld	%g4, %g1, 8
	addi	%g5, %g4, 1
	st	%g3, %g1, 12
	st	%g5, %g1, 16
	input	%g3
	mvhi	%g4, 65535
	mvlo	%g4, -1
	bne	%g3, %g4, beq_else.21834
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	mvhi	%g4, 65535
	mvlo	%g4, -1
	st	%g31, %g1, 20
	addi	%g1, %g1, 24
	call	min_caml_create_array
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	b	beq_cont.21835
beq_else.21834:
	ld	%g4, %g1, 16
	addi	%g5, %g4, 1
	st	%g3, %g1, 20
	st	%g5, %g1, 24
	input	%g3
	mvhi	%g4, 65535
	mvlo	%g4, -1
	bne	%g3, %g4, beq_else.21836
	ld	%g3, %g1, 24
	addi	%g3, %g3, 1
	mvhi	%g4, 65535
	mvlo	%g4, -1
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	min_caml_create_array
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	b	beq_cont.21837
beq_else.21836:
	ld	%g4, %g1, 24
	addi	%g5, %g4, 1
	st	%g3, %g1, 28
	mov	%g3, %g5
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	read_net_item.2930
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 24
	slli	%g4, %g4, 2
	ld	%g5, %g1, 28
	st	%g5, %g3, %g4
beq_cont.21837:
	ld	%g4, %g1, 16
	slli	%g4, %g4, 2
	ld	%g5, %g1, 20
	st	%g5, %g3, %g4
beq_cont.21835:
	ld	%g4, %g1, 8
	slli	%g4, %g4, 2
	ld	%g5, %g1, 12
	st	%g5, %g3, %g4
beq_cont.21833:
	ld	%g4, %g1, 0
	slli	%g4, %g4, 2
	ld	%g5, %g1, 4
	st	%g5, %g3, %g4
	return
read_or_network.2932:
	st	%g3, %g1, 0
	input	%g3
	mvhi	%g4, 65535
	mvlo	%g4, -1
	bne	%g3, %g4, beq_else.21838
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 65535
	mvlo	%g4, -1
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_create_array
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g4, %g3
	b	beq_cont.21839
beq_else.21838:
	st	%g3, %g1, 4
	input	%g3
	mvhi	%g4, 65535
	mvlo	%g4, -1
	bne	%g3, %g4, beq_else.21840
	mvhi	%g3, 0
	mvlo	%g3, 2
	mvhi	%g4, 65535
	mvlo	%g4, -1
	st	%g31, %g1, 12
	addi	%g1, %g1, 16
	call	min_caml_create_array
	subi	%g1, %g1, 16
	ld	%g31, %g1, 12
	b	beq_cont.21841
beq_else.21840:
	st	%g3, %g1, 8
	input	%g3
	mvhi	%g4, 65535
	mvlo	%g4, -1
	bne	%g3, %g4, beq_else.21842
	mvhi	%g3, 0
	mvlo	%g3, 3
	mvhi	%g4, 65535
	mvlo	%g4, -1
	st	%g31, %g1, 12
	addi	%g1, %g1, 16
	call	min_caml_create_array
	subi	%g1, %g1, 16
	ld	%g31, %g1, 12
	b	beq_cont.21843
beq_else.21842:
	mvhi	%g4, 0
	mvlo	%g4, 3
	st	%g3, %g1, 12
	mov	%g3, %g4
	st	%g31, %g1, 20
	addi	%g1, %g1, 24
	call	read_net_item.2930
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 12
	st	%g4, %g3, 8
beq_cont.21843:
	ld	%g4, %g1, 8
	st	%g4, %g3, 4
beq_cont.21841:
	ld	%g4, %g1, 4
	st	%g4, %g3, 0
	mov	%g4, %g3
beq_cont.21839:
	ld	%g3, %g4, 0
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g3, %g5, beq_else.21844
	ld	%g3, %g1, 0
	addi	%g3, %g3, 1
	jmp	min_caml_create_array
beq_else.21844:
	ld	%g3, %g1, 0
	addi	%g5, %g3, 1
	st	%g4, %g1, 16
	st	%g5, %g1, 20
	input	%g3
	mvhi	%g4, 65535
	mvlo	%g4, -1
	bne	%g3, %g4, beq_else.21845
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 65535
	mvlo	%g4, -1
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	min_caml_create_array
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g3
	b	beq_cont.21846
beq_else.21845:
	st	%g3, %g1, 24
	input	%g3
	mvhi	%g4, 65535
	mvlo	%g4, -1
	bne	%g3, %g4, beq_else.21847
	mvhi	%g3, 0
	mvlo	%g3, 2
	mvhi	%g4, 65535
	mvlo	%g4, -1
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	min_caml_create_array
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	b	beq_cont.21848
beq_else.21847:
	mvhi	%g4, 0
	mvlo	%g4, 2
	st	%g3, %g1, 28
	mov	%g3, %g4
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	read_net_item.2930
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 28
	st	%g4, %g3, 4
beq_cont.21848:
	ld	%g4, %g1, 24
	st	%g4, %g3, 0
	mov	%g4, %g3
beq_cont.21846:
	ld	%g3, %g4, 0
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g3, %g5, beq_else.21849
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_create_array
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	b	beq_cont.21850
beq_else.21849:
	ld	%g3, %g1, 20
	addi	%g5, %g3, 1
	st	%g4, %g1, 32
	mov	%g3, %g5
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	read_or_network.2932
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 20
	slli	%g4, %g4, 2
	ld	%g5, %g1, 32
	st	%g5, %g3, %g4
beq_cont.21850:
	ld	%g4, %g1, 0
	slli	%g4, %g4, 2
	ld	%g5, %g1, 16
	st	%g5, %g3, %g4
	return
read_and_network.2934:
	ld	%g4, %g30, 4
	st	%g30, %g1, 0
	st	%g4, %g1, 4
	st	%g3, %g1, 8
	input	%g3
	mvhi	%g4, 65535
	mvlo	%g4, -1
	bne	%g3, %g4, beq_else.21851
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 65535
	mvlo	%g4, -1
	st	%g31, %g1, 12
	addi	%g1, %g1, 16
	call	min_caml_create_array
	subi	%g1, %g1, 16
	ld	%g31, %g1, 12
	b	beq_cont.21852
beq_else.21851:
	st	%g3, %g1, 12
	input	%g3
	mvhi	%g4, 65535
	mvlo	%g4, -1
	bne	%g3, %g4, beq_else.21853
	mvhi	%g3, 0
	mvlo	%g3, 2
	mvhi	%g4, 65535
	mvlo	%g4, -1
	st	%g31, %g1, 20
	addi	%g1, %g1, 24
	call	min_caml_create_array
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	b	beq_cont.21854
beq_else.21853:
	st	%g3, %g1, 16
	input	%g3
	mvhi	%g4, 65535
	mvlo	%g4, -1
	bne	%g3, %g4, beq_else.21855
	mvhi	%g3, 0
	mvlo	%g3, 3
	mvhi	%g4, 65535
	mvlo	%g4, -1
	st	%g31, %g1, 20
	addi	%g1, %g1, 24
	call	min_caml_create_array
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	b	beq_cont.21856
beq_else.21855:
	mvhi	%g4, 0
	mvlo	%g4, 3
	st	%g3, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	read_net_item.2930
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 20
	st	%g4, %g3, 8
beq_cont.21856:
	ld	%g4, %g1, 16
	st	%g4, %g3, 4
beq_cont.21854:
	ld	%g4, %g1, 12
	st	%g4, %g3, 0
beq_cont.21852:
	ld	%g4, %g3, 0
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.21857
	return
beq_else.21857:
	ld	%g4, %g1, 8
	slli	%g5, %g4, 2
	ld	%g6, %g1, 4
	st	%g3, %g6, %g5
	addi	%g3, %g4, 1
	st	%g3, %g1, 24
	input	%g3
	mvhi	%g4, 65535
	mvlo	%g4, -1
	bne	%g3, %g4, beq_else.21859
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 65535
	mvlo	%g4, -1
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	min_caml_create_array
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	b	beq_cont.21860
beq_else.21859:
	st	%g3, %g1, 28
	input	%g3
	mvhi	%g4, 65535
	mvlo	%g4, -1
	bne	%g3, %g4, beq_else.21861
	mvhi	%g3, 0
	mvlo	%g3, 2
	mvhi	%g4, 65535
	mvlo	%g4, -1
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_create_array
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	b	beq_cont.21862
beq_else.21861:
	mvhi	%g4, 0
	mvlo	%g4, 2
	st	%g3, %g1, 32
	mov	%g3, %g4
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	read_net_item.2930
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g4, %g1, 32
	st	%g4, %g3, 4
beq_cont.21862:
	ld	%g4, %g1, 28
	st	%g4, %g3, 0
beq_cont.21860:
	ld	%g4, %g3, 0
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.21863
	return
beq_else.21863:
	ld	%g4, %g1, 24
	slli	%g5, %g4, 2
	ld	%g6, %g1, 4
	st	%g3, %g6, %g5
	addi	%g3, %g4, 1
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
solver_rect_surface.2938:
	ld	%g8, %g30, 4
	slli	%g9, %g5, 3
	fld	%f3, %g4, %g9
	setL %g9, l.14007
	fld	%f4, %g9, 0
	fbne	%f3, %f4, fbe_else.21865
	mvhi	%g9, 0
	mvlo	%g9, 1
	b	fbe_cont.21866
fbe_else.21865:
	mvhi	%g9, 0
	mvlo	%g9, 0
fbe_cont.21866:
	mvhi	%g10, 0
	mvlo	%g10, 0
	bne	%g9, %g10, beq_else.21867
	ld	%g9, %g3, 16
	ld	%g3, %g3, 24
	slli	%g10, %g5, 3
	fld	%f3, %g4, %g10
	setL %g10, l.14007
	fld	%f4, %g10, 0
	fblt	%f3, %f4, fble_else.21868
	mvhi	%g10, 0
	mvlo	%g10, 1
	b	fble_cont.21869
fble_else.21868:
	mvhi	%g10, 0
	mvlo	%g10, 0
fble_cont.21869:
	mvhi	%g11, 0
	mvlo	%g11, 0
	bne	%g3, %g11, beq_else.21870
	mov	%g3, %g10
	b	beq_cont.21871
beq_else.21870:
	mvhi	%g3, 0
	mvlo	%g3, 0
	bne	%g10, %g3, beq_else.21872
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	beq_cont.21873
beq_else.21872:
	mvhi	%g3, 0
	mvlo	%g3, 0
beq_cont.21873:
beq_cont.21871:
	slli	%g10, %g5, 3
	fld	%f3, %g9, %g10
	mvhi	%g10, 0
	mvlo	%g10, 0
	bne	%g3, %g10, beq_else.21874
	fneg	%f3, %f3
	b	beq_cont.21875
beq_else.21874:
beq_cont.21875:
	fsub	%f0, %f3, %f0
	slli	%g3, %g5, 3
	fld	%f3, %g4, %g3
	fdiv	%f0, %f0, %f3
	slli	%g3, %g6, 3
	fld	%f3, %g4, %g3
	fmul	%f3, %f0, %f3
	fadd	%f1, %f3, %f1
	setL %g3, l.14007
	fld	%f3, %g3, 0
	fblt	%f1, %f3, fble_else.21876
	fneg	%f1, %f1
	b	fble_cont.21877
fble_else.21876:
fble_cont.21877:
	slli	%g3, %g6, 3
	fld	%f3, %g9, %g3
	fblt	%f1, %f3, fble_else.21878
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.21879
fble_else.21878:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.21879:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g3, %g5, beq_else.21880
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.21880:
	slli	%g3, %g7, 3
	fld	%f1, %g4, %g3
	fmul	%f1, %f0, %f1
	fadd	%f1, %f1, %f2
	setL %g3, l.14007
	fld	%f2, %g3, 0
	fblt	%f1, %f2, fble_else.21881
	fneg	%f1, %f1
	b	fble_cont.21882
fble_else.21881:
fble_cont.21882:
	slli	%g3, %g7, 3
	fld	%f2, %g9, %g3
	fblt	%f1, %f2, fble_else.21883
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.21884
fble_else.21883:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.21884:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.21885
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.21885:
	fst	%f0, %g8, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
beq_else.21867:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
solver_surface.2953:
	ld	%g5, %g30, 4
	ld	%g3, %g3, 16
	fld	%f3, %g4, 0
	fld	%f4, %g3, 0
	fmul	%f3, %f3, %f4
	fld	%f4, %g4, 8
	fld	%f5, %g3, 8
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	fld	%f4, %g4, 16
	fld	%f5, %g3, 16
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	setL %g4, l.14007
	fld	%f4, %g4, 0
	fblt	%f4, %f3, fble_else.21886
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.21887
fble_else.21886:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.21887:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g4, %g6, beq_else.21888
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.21888:
	fld	%f4, %g3, 0
	fmul	%f0, %f4, %f0
	fld	%f4, %g3, 8
	fmul	%f1, %f4, %f1
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fneg	%f0, %f0
	fdiv	%f0, %f0, %f3
	fst	%f0, %g5, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
quadratic.2959:
	fmul	%f3, %f0, %f0
	ld	%g4, %g3, 16
	fld	%f4, %g4, 0
	fmul	%f3, %f3, %f4
	fmul	%f4, %f1, %f1
	ld	%g4, %g3, 16
	fld	%f5, %g4, 8
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	fmul	%f4, %f2, %f2
	ld	%g4, %g3, 16
	fld	%f5, %g4, 16
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	ld	%g4, %g3, 12
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.21889
	fmov	%f0, %f3
	return
beq_else.21889:
	fmul	%f4, %f1, %f2
	ld	%g4, %g3, 36
	fld	%f5, %g4, 0
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	fmul	%f2, %f2, %f0
	ld	%g4, %g3, 36
	fld	%f4, %g4, 8
	fmul	%f2, %f2, %f4
	fadd	%f2, %f3, %f2
	fmul	%f0, %f0, %f1
	ld	%g3, %g3, 36
	fld	%f1, %g3, 16
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	return
bilinear.2964:
	fmul	%f6, %f0, %f3
	ld	%g4, %g3, 16
	fld	%f7, %g4, 0
	fmul	%f6, %f6, %f7
	fmul	%f7, %f1, %f4
	ld	%g4, %g3, 16
	fld	%f8, %g4, 8
	fmul	%f7, %f7, %f8
	fadd	%f6, %f6, %f7
	fmul	%f7, %f2, %f5
	ld	%g4, %g3, 16
	fld	%f8, %g4, 16
	fmul	%f7, %f7, %f8
	fadd	%f6, %f6, %f7
	ld	%g4, %g3, 12
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.21890
	fmov	%f0, %f6
	return
beq_else.21890:
	fmul	%f7, %f2, %f4
	fmul	%f8, %f1, %f5
	fadd	%f7, %f7, %f8
	ld	%g4, %g3, 36
	fld	%f8, %g4, 0
	fmul	%f7, %f7, %f8
	fmul	%f5, %f0, %f5
	fmul	%f2, %f2, %f3
	fadd	%f2, %f5, %f2
	ld	%g4, %g3, 36
	fld	%f5, %g4, 8
	fmul	%f2, %f2, %f5
	fadd	%f2, %f7, %f2
	fmul	%f0, %f0, %f4
	fmul	%f1, %f1, %f3
	fadd	%f0, %f0, %f1
	ld	%g3, %g3, 36
	fld	%f1, %g3, 16
	fmul	%f0, %f0, %f1
	fadd	%f0, %f2, %f0
	setL %g3, l.14068
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f6, %f0
	return
solver_second.2972:
	ld	%g5, %g30, 4
	fld	%f3, %g4, 0
	fld	%f4, %g4, 8
	fld	%f5, %g4, 16
	st	%g5, %g1, 0
	std	%f2, %g1, 8
	std	%f1, %g1, 16
	std	%f0, %g1, 24
	st	%g3, %g1, 32
	st	%g4, %g1, 36
	fmov	%f2, %f5
	fmov	%f1, %f4
	fmov	%f0, %f3
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	quadratic.2959
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fbne	%f0, %f1, fbe_else.21892
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fbe_cont.21893
fbe_else.21892:
	mvhi	%g3, 0
	mvlo	%g3, 0
fbe_cont.21893:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.21894
	ld	%g3, %g1, 36
	fld	%f1, %g3, 0
	fld	%f2, %g3, 8
	fld	%f3, %g3, 16
	fld	%f4, %g1, 24
	fld	%f5, %g1, 16
	fld	%f6, %g1, 8
	ld	%g3, %g1, 32
	std	%f0, %g1, 40
	fmov	%f0, %f1
	fmov	%f1, %f2
	fmov	%f2, %f3
	fmov	%f3, %f4
	fmov	%f4, %f5
	fmov	%f5, %f6
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	bilinear.2964
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 24
	fld	%f2, %g1, 16
	fld	%f3, %g1, 8
	ld	%g3, %g1, 32
	std	%f0, %g1, 48
	fmov	%f0, %f1
	fmov	%f1, %f2
	fmov	%f2, %f3
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	quadratic.2959
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 32
	ld	%g4, %g3, 4
	mvhi	%g5, 0
	mvlo	%g5, 3
	bne	%g4, %g5, beq_else.21895
	setL %g4, l.14053
	fld	%f1, %g4, 0
	fsub	%f0, %f0, %f1
	b	beq_cont.21896
beq_else.21895:
beq_cont.21896:
	fld	%f1, %g1, 48
	fmul	%f2, %f1, %f1
	fld	%f3, %g1, 40
	fmul	%f0, %f3, %f0
	fsub	%f0, %f2, %f0
	setL %g4, l.14007
	fld	%f2, %g4, 0
	fblt	%f2, %f0, fble_else.21897
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.21898
fble_else.21897:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.21898:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.21899
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.21899:
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	sqrt.2751
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 32
	ld	%g3, %g3, 24
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.21900
	fneg	%f0, %f0
	b	beq_cont.21901
beq_else.21900:
beq_cont.21901:
	fld	%f1, %g1, 48
	fsub	%f0, %f0, %f1
	fld	%f1, %g1, 40
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
beq_else.21894:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
solver.2978:
	ld	%g6, %g30, 16
	ld	%g7, %g30, 12
	ld	%g8, %g30, 8
	ld	%g9, %g30, 4
	slli	%g3, %g3, 2
	ld	%g3, %g9, %g3
	fld	%f0, %g5, 0
	ld	%g9, %g3, 20
	fld	%f1, %g9, 0
	fsub	%f0, %f0, %f1
	fld	%f1, %g5, 8
	ld	%g9, %g3, 20
	fld	%f2, %g9, 8
	fsub	%f1, %f1, %f2
	fld	%f2, %g5, 16
	ld	%g5, %g3, 20
	fld	%f3, %g5, 16
	fsub	%f2, %f2, %f3
	ld	%g5, %g3, 4
	mvhi	%g9, 0
	mvlo	%g9, 1
	bne	%g5, %g9, beq_else.21902
	mvhi	%g5, 0
	mvlo	%g5, 0
	mvhi	%g6, 0
	mvlo	%g6, 1
	mvhi	%g8, 0
	mvlo	%g8, 2
	std	%f0, %g1, 0
	std	%f2, %g1, 8
	std	%f1, %g1, 16
	st	%g4, %g1, 24
	st	%g3, %g1, 28
	st	%g7, %g1, 32
	mov	%g30, %g7
	mov	%g7, %g8
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.21903
	mvhi	%g5, 0
	mvlo	%g5, 1
	mvhi	%g6, 0
	mvlo	%g6, 2
	mvhi	%g7, 0
	mvlo	%g7, 0
	fld	%f0, %g1, 16
	fld	%f1, %g1, 8
	fld	%f2, %g1, 0
	ld	%g3, %g1, 28
	ld	%g4, %g1, 24
	ld	%g30, %g1, 32
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.21904
	mvhi	%g5, 0
	mvlo	%g5, 2
	mvhi	%g6, 0
	mvlo	%g6, 0
	mvhi	%g7, 0
	mvlo	%g7, 1
	fld	%f0, %g1, 8
	fld	%f1, %g1, 0
	fld	%f2, %g1, 16
	ld	%g3, %g1, 28
	ld	%g4, %g1, 24
	ld	%g30, %g1, 32
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.21905
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.21905:
	mvhi	%g3, 0
	mvlo	%g3, 3
	return
beq_else.21904:
	mvhi	%g3, 0
	mvlo	%g3, 2
	return
beq_else.21903:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
beq_else.21902:
	mvhi	%g7, 0
	mvlo	%g7, 2
	bne	%g5, %g7, beq_else.21906
	ld	%g3, %g3, 16
	fld	%f3, %g4, 0
	fld	%f4, %g3, 0
	fmul	%f3, %f3, %f4
	fld	%f4, %g4, 8
	fld	%f5, %g3, 8
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	fld	%f4, %g4, 16
	fld	%f5, %g3, 16
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	setL %g4, l.14007
	fld	%f4, %g4, 0
	fblt	%f4, %f3, fble_else.21907
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.21908
fble_else.21907:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.21908:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.21909
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.21909:
	fld	%f4, %g3, 0
	fmul	%f0, %f4, %f0
	fld	%f4, %g3, 8
	fmul	%f1, %f4, %f1
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fneg	%f0, %f0
	fdiv	%f0, %f0, %f3
	fst	%f0, %g8, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
beq_else.21906:
	mov	%g30, %g6
	ld	%g30, 0, %g29
	b	%g29
solver_rect_fast.2982:
	ld	%g6, %g30, 4
	fld	%f3, %g5, 0
	fsub	%f3, %f3, %f0
	fld	%f4, %g5, 8
	fmul	%f3, %f3, %f4
	fld	%f4, %g4, 8
	fmul	%f4, %f3, %f4
	fadd	%f4, %f4, %f1
	setL %g7, l.14007
	fld	%f5, %g7, 0
	fblt	%f4, %f5, fble_else.21910
	fneg	%f4, %f4
	b	fble_cont.21911
fble_else.21910:
fble_cont.21911:
	ld	%g7, %g3, 16
	fld	%f5, %g7, 8
	fblt	%f4, %f5, fble_else.21912
	mvhi	%g7, 0
	mvlo	%g7, 1
	b	fble_cont.21913
fble_else.21912:
	mvhi	%g7, 0
	mvlo	%g7, 0
fble_cont.21913:
	mvhi	%g8, 0
	mvlo	%g8, 0
	bne	%g7, %g8, beq_else.21914
	mvhi	%g7, 0
	mvlo	%g7, 0
	b	beq_cont.21915
beq_else.21914:
	fld	%f4, %g4, 16
	fmul	%f4, %f3, %f4
	fadd	%f4, %f4, %f2
	setL %g7, l.14007
	fld	%f5, %g7, 0
	fblt	%f4, %f5, fble_else.21916
	fneg	%f4, %f4
	b	fble_cont.21917
fble_else.21916:
fble_cont.21917:
	ld	%g7, %g3, 16
	fld	%f5, %g7, 16
	fblt	%f4, %f5, fble_else.21918
	mvhi	%g7, 0
	mvlo	%g7, 1
	b	fble_cont.21919
fble_else.21918:
	mvhi	%g7, 0
	mvlo	%g7, 0
fble_cont.21919:
	mvhi	%g8, 0
	mvlo	%g8, 0
	bne	%g7, %g8, beq_else.21920
	mvhi	%g7, 0
	mvlo	%g7, 0
	b	beq_cont.21921
beq_else.21920:
	fld	%f4, %g5, 8
	setL %g7, l.14007
	fld	%f5, %g7, 0
	fbne	%f4, %f5, fbe_else.21922
	mvhi	%g7, 0
	mvlo	%g7, 1
	b	fbe_cont.21923
fbe_else.21922:
	mvhi	%g7, 0
	mvlo	%g7, 0
fbe_cont.21923:
	mvhi	%g8, 0
	mvlo	%g8, 0
	bne	%g7, %g8, beq_else.21924
	mvhi	%g7, 0
	mvlo	%g7, 1
	b	beq_cont.21925
beq_else.21924:
	mvhi	%g7, 0
	mvlo	%g7, 0
beq_cont.21925:
beq_cont.21921:
beq_cont.21915:
	mvhi	%g8, 0
	mvlo	%g8, 0
	bne	%g7, %g8, beq_else.21926
	fld	%f3, %g5, 16
	fsub	%f3, %f3, %f1
	fld	%f4, %g5, 24
	fmul	%f3, %f3, %f4
	fld	%f4, %g4, 0
	fmul	%f4, %f3, %f4
	fadd	%f4, %f4, %f0
	setL %g7, l.14007
	fld	%f5, %g7, 0
	fblt	%f4, %f5, fble_else.21927
	fneg	%f4, %f4
	b	fble_cont.21928
fble_else.21927:
fble_cont.21928:
	ld	%g7, %g3, 16
	fld	%f5, %g7, 0
	fblt	%f4, %f5, fble_else.21929
	mvhi	%g7, 0
	mvlo	%g7, 1
	b	fble_cont.21930
fble_else.21929:
	mvhi	%g7, 0
	mvlo	%g7, 0
fble_cont.21930:
	mvhi	%g8, 0
	mvlo	%g8, 0
	bne	%g7, %g8, beq_else.21931
	mvhi	%g7, 0
	mvlo	%g7, 0
	b	beq_cont.21932
beq_else.21931:
	fld	%f4, %g4, 16
	fmul	%f4, %f3, %f4
	fadd	%f4, %f4, %f2
	setL %g7, l.14007
	fld	%f5, %g7, 0
	fblt	%f4, %f5, fble_else.21933
	fneg	%f4, %f4
	b	fble_cont.21934
fble_else.21933:
fble_cont.21934:
	ld	%g7, %g3, 16
	fld	%f5, %g7, 16
	fblt	%f4, %f5, fble_else.21935
	mvhi	%g7, 0
	mvlo	%g7, 1
	b	fble_cont.21936
fble_else.21935:
	mvhi	%g7, 0
	mvlo	%g7, 0
fble_cont.21936:
	mvhi	%g8, 0
	mvlo	%g8, 0
	bne	%g7, %g8, beq_else.21937
	mvhi	%g7, 0
	mvlo	%g7, 0
	b	beq_cont.21938
beq_else.21937:
	fld	%f4, %g5, 24
	setL %g7, l.14007
	fld	%f5, %g7, 0
	fbne	%f4, %f5, fbe_else.21939
	mvhi	%g7, 0
	mvlo	%g7, 1
	b	fbe_cont.21940
fbe_else.21939:
	mvhi	%g7, 0
	mvlo	%g7, 0
fbe_cont.21940:
	mvhi	%g8, 0
	mvlo	%g8, 0
	bne	%g7, %g8, beq_else.21941
	mvhi	%g7, 0
	mvlo	%g7, 1
	b	beq_cont.21942
beq_else.21941:
	mvhi	%g7, 0
	mvlo	%g7, 0
beq_cont.21942:
beq_cont.21938:
beq_cont.21932:
	mvhi	%g8, 0
	mvlo	%g8, 0
	bne	%g7, %g8, beq_else.21943
	fld	%f3, %g5, 32
	fsub	%f2, %f3, %f2
	fld	%f3, %g5, 40
	fmul	%f2, %f2, %f3
	fld	%f3, %g4, 0
	fmul	%f3, %f2, %f3
	fadd	%f0, %f3, %f0
	setL %g7, l.14007
	fld	%f3, %g7, 0
	fblt	%f0, %f3, fble_else.21944
	fneg	%f0, %f0
	b	fble_cont.21945
fble_else.21944:
fble_cont.21945:
	ld	%g7, %g3, 16
	fld	%f3, %g7, 0
	fblt	%f0, %f3, fble_else.21946
	mvhi	%g7, 0
	mvlo	%g7, 1
	b	fble_cont.21947
fble_else.21946:
	mvhi	%g7, 0
	mvlo	%g7, 0
fble_cont.21947:
	mvhi	%g8, 0
	mvlo	%g8, 0
	bne	%g7, %g8, beq_else.21948
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.21949
beq_else.21948:
	fld	%f0, %g4, 8
	fmul	%f0, %f2, %f0
	fadd	%f0, %f0, %f1
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.21950
	fneg	%f0, %f0
	b	fble_cont.21951
fble_else.21950:
fble_cont.21951:
	ld	%g3, %g3, 16
	fld	%f1, %g3, 8
	fblt	%f0, %f1, fble_else.21952
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.21953
fble_else.21952:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.21953:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.21954
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.21955
beq_else.21954:
	fld	%f0, %g5, 40
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fbne	%f0, %f1, fbe_else.21956
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fbe_cont.21957
fbe_else.21956:
	mvhi	%g3, 0
	mvlo	%g3, 0
fbe_cont.21957:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.21958
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	beq_cont.21959
beq_else.21958:
	mvhi	%g3, 0
	mvlo	%g3, 0
beq_cont.21959:
beq_cont.21955:
beq_cont.21949:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.21960
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.21960:
	fst	%f2, %g6, 0
	mvhi	%g3, 0
	mvlo	%g3, 3
	return
beq_else.21943:
	fst	%f3, %g6, 0
	mvhi	%g3, 0
	mvlo	%g3, 2
	return
beq_else.21926:
	fst	%f3, %g6, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
solver_second_fast.2995:
	ld	%g5, %g30, 4
	fld	%f3, %g4, 0
	setL %g6, l.14007
	fld	%f4, %g6, 0
	fbne	%f3, %f4, fbe_else.21961
	mvhi	%g6, 0
	mvlo	%g6, 1
	b	fbe_cont.21962
fbe_else.21961:
	mvhi	%g6, 0
	mvlo	%g6, 0
fbe_cont.21962:
	mvhi	%g7, 0
	mvlo	%g7, 0
	bne	%g6, %g7, beq_else.21963
	fld	%f4, %g4, 8
	fmul	%f4, %f4, %f0
	fld	%f5, %g4, 16
	fmul	%f5, %f5, %f1
	fadd	%f4, %f4, %f5
	fld	%f5, %g4, 24
	fmul	%f5, %f5, %f2
	fadd	%f4, %f4, %f5
	st	%g5, %g1, 0
	st	%g4, %g1, 4
	std	%f3, %g1, 8
	std	%f4, %g1, 16
	st	%g3, %g1, 24
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	quadratic.2959
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 24
	ld	%g4, %g3, 4
	mvhi	%g5, 0
	mvlo	%g5, 3
	bne	%g4, %g5, beq_else.21964
	setL %g4, l.14053
	fld	%f1, %g4, 0
	fsub	%f0, %f0, %f1
	b	beq_cont.21965
beq_else.21964:
beq_cont.21965:
	fld	%f1, %g1, 16
	fmul	%f2, %f1, %f1
	fld	%f3, %g1, 8
	fmul	%f0, %f3, %f0
	fsub	%f0, %f2, %f0
	setL %g4, l.14007
	fld	%f2, %g4, 0
	fblt	%f2, %f0, fble_else.21966
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.21967
fble_else.21966:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.21967:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.21968
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.21968:
	ld	%g3, %g3, 24
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.21969
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	sqrt.2751
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 16
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, 32
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	b	beq_cont.21970
beq_else.21969:
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	sqrt.2751
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	fld	%f1, %g1, 16
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, 32
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
beq_cont.21970:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
beq_else.21963:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
solver_second_fast2.3012:
	ld	%g6, %g30, 4
	fld	%f3, %g4, 0
	setL %g7, l.14007
	fld	%f4, %g7, 0
	fbne	%f3, %f4, fbe_else.21971
	mvhi	%g7, 0
	mvlo	%g7, 1
	b	fbe_cont.21972
fbe_else.21971:
	mvhi	%g7, 0
	mvlo	%g7, 0
fbe_cont.21972:
	mvhi	%g8, 0
	mvlo	%g8, 0
	bne	%g7, %g8, beq_else.21973
	fld	%f4, %g4, 8
	fmul	%f0, %f4, %f0
	fld	%f4, %g4, 16
	fmul	%f1, %f4, %f1
	fadd	%f0, %f0, %f1
	fld	%f1, %g4, 24
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g5, 24
	fmul	%f2, %f0, %f0
	fmul	%f1, %f3, %f1
	fsub	%f1, %f2, %f1
	setL %g5, l.14007
	fld	%f2, %g5, 0
	fblt	%f2, %f1, fble_else.21974
	mvhi	%g5, 0
	mvlo	%g5, 1
	b	fble_cont.21975
fble_else.21974:
	mvhi	%g5, 0
	mvlo	%g5, 0
fble_cont.21975:
	mvhi	%g7, 0
	mvlo	%g7, 0
	bne	%g5, %g7, beq_else.21976
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.21976:
	ld	%g3, %g3, 24
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g3, %g5, beq_else.21977
	st	%g6, %g1, 0
	st	%g4, %g1, 4
	std	%f0, %g1, 8
	fmov	%f0, %f1
	st	%g31, %g1, 20
	addi	%g1, %g1, 24
	call	sqrt.2751
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 8
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, 32
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
	b	beq_cont.21978
beq_else.21977:
	st	%g6, %g1, 0
	st	%g4, %g1, 4
	std	%f0, %g1, 8
	fmov	%f0, %f1
	st	%g31, %g1, 20
	addi	%g1, %g1, 24
	call	sqrt.2751
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 8
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 4
	fld	%f1, %g3, 32
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 0
beq_cont.21978:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
beq_else.21973:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
solver_fast2.3019:
	ld	%g5, %g30, 16
	ld	%g6, %g30, 12
	ld	%g7, %g30, 8
	ld	%g8, %g30, 4
	slli	%g9, %g3, 2
	ld	%g8, %g8, %g9
	ld	%g9, %g8, 40
	fld	%f0, %g9, 0
	fld	%f1, %g9, 8
	fld	%f2, %g9, 16
	ld	%g10, %g4, 4
	slli	%g3, %g3, 2
	ld	%g3, %g10, %g3
	ld	%g10, %g8, 4
	mvhi	%g11, 0
	mvlo	%g11, 1
	bne	%g10, %g11, beq_else.21979
	ld	%g4, %g4, 0
	mov	%g5, %g3
	mov	%g30, %g6
	mov	%g3, %g8
	ld	%g30, 0, %g29
	b	%g29
beq_else.21979:
	mvhi	%g4, 0
	mvlo	%g4, 2
	bne	%g10, %g4, beq_else.21980
	fld	%f0, %g3, 0
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.21981
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.21982
fble_else.21981:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.21982:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.21983
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.21983:
	fld	%f0, %g3, 0
	fld	%f1, %g9, 24
	fmul	%f0, %f0, %f1
	fst	%f0, %g7, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
beq_else.21980:
	mov	%g4, %g3
	mov	%g30, %g5
	mov	%g5, %g9
	mov	%g3, %g8
	ld	%g30, 0, %g29
	b	%g29
setup_rect_table.3022:
	mvhi	%g5, 0
	mvlo	%g5, 6
	setL %g6, l.14007
	fld	%f0, %g6, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 12
	addi	%g1, %g1, 16
	call	min_caml_create_float_array
	subi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	fld	%f0, %g4, 0
	setL %g5, l.14007
	fld	%f1, %g5, 0
	fbne	%f0, %f1, fbe_else.21984
	mvhi	%g5, 0
	mvlo	%g5, 1
	b	fbe_cont.21985
fbe_else.21984:
	mvhi	%g5, 0
	mvlo	%g5, 0
fbe_cont.21985:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g5, %g6, beq_else.21986
	ld	%g5, %g1, 0
	ld	%g6, %g5, 24
	fld	%f0, %g4, 0
	setL %g7, l.14007
	fld	%f1, %g7, 0
	fblt	%f0, %f1, fble_else.21988
	mvhi	%g7, 0
	mvlo	%g7, 1
	b	fble_cont.21989
fble_else.21988:
	mvhi	%g7, 0
	mvlo	%g7, 0
fble_cont.21989:
	mvhi	%g8, 0
	mvlo	%g8, 0
	bne	%g6, %g8, beq_else.21990
	mov	%g6, %g7
	b	beq_cont.21991
beq_else.21990:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g7, %g6, beq_else.21992
	mvhi	%g6, 0
	mvlo	%g6, 1
	b	beq_cont.21993
beq_else.21992:
	mvhi	%g6, 0
	mvlo	%g6, 0
beq_cont.21993:
beq_cont.21991:
	ld	%g7, %g5, 16
	fld	%f0, %g7, 0
	mvhi	%g7, 0
	mvlo	%g7, 0
	bne	%g6, %g7, beq_else.21994
	fneg	%f0, %f0
	b	beq_cont.21995
beq_else.21994:
beq_cont.21995:
	fst	%f0, %g3, 0
	setL %g6, l.14053
	fld	%f0, %g6, 0
	fld	%f1, %g4, 0
	fdiv	%f0, %f0, %f1
	fst	%f0, %g3, 8
	b	beq_cont.21987
beq_else.21986:
	setL %g5, l.14007
	fld	%f0, %g5, 0
	fst	%f0, %g3, 8
beq_cont.21987:
	fld	%f0, %g4, 8
	setL %g5, l.14007
	fld	%f1, %g5, 0
	fbne	%f0, %f1, fbe_else.21996
	mvhi	%g5, 0
	mvlo	%g5, 1
	b	fbe_cont.21997
fbe_else.21996:
	mvhi	%g5, 0
	mvlo	%g5, 0
fbe_cont.21997:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g5, %g6, beq_else.21998
	ld	%g5, %g1, 0
	ld	%g6, %g5, 24
	fld	%f0, %g4, 8
	setL %g7, l.14007
	fld	%f1, %g7, 0
	fblt	%f0, %f1, fble_else.22000
	mvhi	%g7, 0
	mvlo	%g7, 1
	b	fble_cont.22001
fble_else.22000:
	mvhi	%g7, 0
	mvlo	%g7, 0
fble_cont.22001:
	mvhi	%g8, 0
	mvlo	%g8, 0
	bne	%g6, %g8, beq_else.22002
	mov	%g6, %g7
	b	beq_cont.22003
beq_else.22002:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g7, %g6, beq_else.22004
	mvhi	%g6, 0
	mvlo	%g6, 1
	b	beq_cont.22005
beq_else.22004:
	mvhi	%g6, 0
	mvlo	%g6, 0
beq_cont.22005:
beq_cont.22003:
	ld	%g7, %g5, 16
	fld	%f0, %g7, 8
	mvhi	%g7, 0
	mvlo	%g7, 0
	bne	%g6, %g7, beq_else.22006
	fneg	%f0, %f0
	b	beq_cont.22007
beq_else.22006:
beq_cont.22007:
	fst	%f0, %g3, 16
	setL %g6, l.14053
	fld	%f0, %g6, 0
	fld	%f1, %g4, 8
	fdiv	%f0, %f0, %f1
	fst	%f0, %g3, 24
	b	beq_cont.21999
beq_else.21998:
	setL %g5, l.14007
	fld	%f0, %g5, 0
	fst	%f0, %g3, 24
beq_cont.21999:
	fld	%f0, %g4, 16
	setL %g5, l.14007
	fld	%f1, %g5, 0
	fbne	%f0, %f1, fbe_else.22008
	mvhi	%g5, 0
	mvlo	%g5, 1
	b	fbe_cont.22009
fbe_else.22008:
	mvhi	%g5, 0
	mvlo	%g5, 0
fbe_cont.22009:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g5, %g6, beq_else.22010
	ld	%g5, %g1, 0
	ld	%g6, %g5, 24
	fld	%f0, %g4, 16
	setL %g7, l.14007
	fld	%f1, %g7, 0
	fblt	%f0, %f1, fble_else.22012
	mvhi	%g7, 0
	mvlo	%g7, 1
	b	fble_cont.22013
fble_else.22012:
	mvhi	%g7, 0
	mvlo	%g7, 0
fble_cont.22013:
	mvhi	%g8, 0
	mvlo	%g8, 0
	bne	%g6, %g8, beq_else.22014
	mov	%g6, %g7
	b	beq_cont.22015
beq_else.22014:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g7, %g6, beq_else.22016
	mvhi	%g6, 0
	mvlo	%g6, 1
	b	beq_cont.22017
beq_else.22016:
	mvhi	%g6, 0
	mvlo	%g6, 0
beq_cont.22017:
beq_cont.22015:
	ld	%g5, %g5, 16
	fld	%f0, %g5, 16
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g6, %g5, beq_else.22018
	fneg	%f0, %f0
	b	beq_cont.22019
beq_else.22018:
beq_cont.22019:
	fst	%f0, %g3, 32
	setL %g5, l.14053
	fld	%f0, %g5, 0
	fld	%f1, %g4, 16
	fdiv	%f0, %f0, %f1
	fst	%f0, %g3, 40
	b	beq_cont.22011
beq_else.22010:
	setL %g4, l.14007
	fld	%f0, %g4, 0
	fst	%f0, %g3, 40
beq_cont.22011:
	return
setup_surface_table.3025:
	mvhi	%g5, 0
	mvlo	%g5, 4
	setL %g6, l.14007
	fld	%f0, %g6, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 12
	addi	%g1, %g1, 16
	call	min_caml_create_float_array
	subi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	fld	%f0, %g4, 0
	ld	%g5, %g1, 0
	ld	%g6, %g5, 16
	fld	%f1, %g6, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g4, 8
	ld	%g6, %g5, 16
	fld	%f2, %g6, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g4, 16
	ld	%g4, %g5, 16
	fld	%f2, %g4, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f1, %f0, fble_else.22020
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22021
fble_else.22020:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22021:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g4, %g6, beq_else.22022
	setL %g4, l.14007
	fld	%f0, %g4, 0
	fst	%f0, %g3, 0
	b	beq_cont.22023
beq_else.22022:
	setL %g4, l.14131
	fld	%f1, %g4, 0
	fdiv	%f1, %f1, %f0
	fst	%f1, %g3, 0
	ld	%g4, %g5, 16
	fld	%f1, %g4, 0
	fdiv	%f1, %f1, %f0
	fneg	%f1, %f1
	fst	%f1, %g3, 8
	ld	%g4, %g5, 16
	fld	%f1, %g4, 8
	fdiv	%f1, %f1, %f0
	fneg	%f1, %f1
	fst	%f1, %g3, 16
	ld	%g4, %g5, 16
	fld	%f1, %g4, 16
	fdiv	%f0, %f1, %f0
	fneg	%f0, %f0
	fst	%f0, %g3, 24
beq_cont.22023:
	return
setup_second_table.3028:
	mvhi	%g5, 0
	mvlo	%g5, 5
	setL %g6, l.14007
	fld	%f0, %g6, 0
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 12
	addi	%g1, %g1, 16
	call	min_caml_create_float_array
	subi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	fld	%f0, %g4, 0
	fld	%f1, %g4, 8
	fld	%f2, %g4, 16
	ld	%g5, %g1, 0
	st	%g3, %g1, 8
	mov	%g3, %g5
	st	%g31, %g1, 12
	addi	%g1, %g1, 16
	call	quadratic.2959
	subi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	fld	%f1, %g3, 0
	ld	%g4, %g1, 0
	ld	%g5, %g4, 16
	fld	%f2, %g5, 0
	fmul	%f1, %f1, %f2
	fneg	%f1, %f1
	fld	%f2, %g3, 8
	ld	%g5, %g4, 16
	fld	%f3, %g5, 8
	fmul	%f2, %f2, %f3
	fneg	%f2, %f2
	fld	%f3, %g3, 16
	ld	%g5, %g4, 16
	fld	%f4, %g5, 16
	fmul	%f3, %f3, %f4
	fneg	%f3, %f3
	ld	%g5, %g1, 8
	fst	%f0, %g5, 0
	ld	%g6, %g4, 12
	mvhi	%g7, 0
	mvlo	%g7, 0
	bne	%g6, %g7, beq_else.22024
	fst	%f1, %g5, 8
	fst	%f2, %g5, 16
	fst	%f3, %g5, 24
	b	beq_cont.22025
beq_else.22024:
	fld	%f4, %g3, 16
	ld	%g6, %g4, 36
	fld	%f5, %g6, 8
	fmul	%f4, %f4, %f5
	fld	%f5, %g3, 8
	ld	%g6, %g4, 36
	fld	%f6, %g6, 16
	fmul	%f5, %f5, %f6
	fadd	%f4, %f4, %f5
	setL %g6, l.14068
	fld	%f5, %g6, 0
	fdiv	%f4, %f4, %f5
	fsub	%f1, %f1, %f4
	fst	%f1, %g5, 8
	fld	%f1, %g3, 16
	ld	%g6, %g4, 36
	fld	%f4, %g6, 0
	fmul	%f1, %f1, %f4
	fld	%f4, %g3, 0
	ld	%g6, %g4, 36
	fld	%f5, %g6, 16
	fmul	%f4, %f4, %f5
	fadd	%f1, %f1, %f4
	setL %g6, l.14068
	fld	%f4, %g6, 0
	fdiv	%f1, %f1, %f4
	fsub	%f1, %f2, %f1
	fst	%f1, %g5, 16
	fld	%f1, %g3, 8
	ld	%g6, %g4, 36
	fld	%f2, %g6, 0
	fmul	%f1, %f1, %f2
	fld	%f2, %g3, 0
	ld	%g3, %g4, 36
	fld	%f4, %g3, 8
	fmul	%f2, %f2, %f4
	fadd	%f1, %f1, %f2
	setL %g3, l.14068
	fld	%f2, %g3, 0
	fdiv	%f1, %f1, %f2
	fsub	%f1, %f3, %f1
	fst	%f1, %g5, 24
beq_cont.22025:
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fbne	%f0, %f1, fbe_else.22026
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fbe_cont.22027
fbe_else.22026:
	mvhi	%g3, 0
	mvlo	%g3, 0
fbe_cont.22027:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22028
	setL %g3, l.14053
	fld	%f1, %g3, 0
	fdiv	%f0, %f1, %f0
	fst	%f0, %g5, 32
	b	beq_cont.22029
beq_else.22028:
beq_cont.22029:
	mov	%g3, %g5
	return
iter_setup_dirvec_constants.3031:
	ld	%g5, %g30, 4
	mvhi	%g6, 0
	mvlo	%g6, 0
	blt	%g4, %g6, ble_else.22030
	slli	%g6, %g4, 2
	ld	%g6, %g5, %g6
	ld	%g7, %g3, 4
	ld	%g8, %g3, 0
	ld	%g9, %g6, 4
	mvhi	%g10, 0
	mvlo	%g10, 1
	st	%g30, %g1, 0
	st	%g3, %g1, 4
	st	%g5, %g1, 8
	bne	%g9, %g10, beq_else.22031
	st	%g7, %g1, 12
	st	%g4, %g1, 16
	mov	%g4, %g6
	mov	%g3, %g8
	st	%g31, %g1, 20
	addi	%g1, %g1, 24
	call	setup_rect_table.3022
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 16
	slli	%g5, %g4, 2
	ld	%g6, %g1, 12
	st	%g3, %g6, %g5
	b	beq_cont.22032
beq_else.22031:
	mvhi	%g10, 0
	mvlo	%g10, 2
	bne	%g9, %g10, beq_else.22033
	st	%g7, %g1, 12
	st	%g4, %g1, 16
	mov	%g4, %g6
	mov	%g3, %g8
	st	%g31, %g1, 20
	addi	%g1, %g1, 24
	call	setup_surface_table.3025
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 16
	slli	%g5, %g4, 2
	ld	%g6, %g1, 12
	st	%g3, %g6, %g5
	b	beq_cont.22034
beq_else.22033:
	st	%g7, %g1, 12
	st	%g4, %g1, 16
	mov	%g4, %g6
	mov	%g3, %g8
	st	%g31, %g1, 20
	addi	%g1, %g1, 24
	call	setup_second_table.3028
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g4, %g1, 16
	slli	%g5, %g4, 2
	ld	%g6, %g1, 12
	st	%g3, %g6, %g5
beq_cont.22034:
beq_cont.22032:
	subi	%g3, %g4, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22035
	slli	%g4, %g3, 2
	ld	%g5, %g1, 8
	ld	%g4, %g5, %g4
	ld	%g5, %g1, 4
	ld	%g6, %g5, 4
	ld	%g7, %g5, 0
	ld	%g8, %g4, 4
	mvhi	%g9, 0
	mvlo	%g9, 1
	bne	%g8, %g9, beq_else.22036
	st	%g6, %g1, 20
	st	%g3, %g1, 24
	mov	%g3, %g7
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	setup_rect_table.3022
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 24
	slli	%g5, %g4, 2
	ld	%g6, %g1, 20
	st	%g3, %g6, %g5
	b	beq_cont.22037
beq_else.22036:
	mvhi	%g9, 0
	mvlo	%g9, 2
	bne	%g8, %g9, beq_else.22038
	st	%g6, %g1, 20
	st	%g3, %g1, 24
	mov	%g3, %g7
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	setup_surface_table.3025
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 24
	slli	%g5, %g4, 2
	ld	%g6, %g1, 20
	st	%g3, %g6, %g5
	b	beq_cont.22039
beq_else.22038:
	st	%g6, %g1, 20
	st	%g3, %g1, 24
	mov	%g3, %g7
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	setup_second_table.3028
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 24
	slli	%g5, %g4, 2
	ld	%g6, %g1, 20
	st	%g3, %g6, %g5
beq_cont.22039:
beq_cont.22037:
	subi	%g4, %g4, 1
	ld	%g3, %g1, 4
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
ble_else.22035:
	return
ble_else.22030:
	return
setup_startp_constants.3036:
	ld	%g5, %g30, 4
	mvhi	%g6, 0
	mvlo	%g6, 0
	blt	%g4, %g6, ble_else.22042
	slli	%g6, %g4, 2
	ld	%g5, %g5, %g6
	ld	%g6, %g5, 40
	ld	%g7, %g5, 4
	fld	%f0, %g3, 0
	ld	%g8, %g5, 20
	fld	%f1, %g8, 0
	fsub	%f0, %f0, %f1
	fst	%f0, %g6, 0
	fld	%f0, %g3, 8
	ld	%g8, %g5, 20
	fld	%f1, %g8, 8
	fsub	%f0, %f0, %f1
	fst	%f0, %g6, 8
	fld	%f0, %g3, 16
	ld	%g8, %g5, 20
	fld	%f1, %g8, 16
	fsub	%f0, %f0, %f1
	fst	%f0, %g6, 16
	mvhi	%g8, 0
	mvlo	%g8, 2
	st	%g3, %g1, 0
	st	%g30, %g1, 4
	st	%g4, %g1, 8
	bne	%g7, %g8, beq_else.22043
	ld	%g5, %g5, 16
	fld	%f0, %g6, 0
	fld	%f1, %g6, 8
	fld	%f2, %g6, 16
	fld	%f3, %g5, 0
	fmul	%f0, %f3, %f0
	fld	%f3, %g5, 8
	fmul	%f1, %f3, %f1
	fadd	%f0, %f0, %f1
	fld	%f1, %g5, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g6, 24
	b	beq_cont.22044
beq_else.22043:
	mvhi	%g8, 0
	mvlo	%g8, 2
	blt	%g8, %g7, ble_else.22045
	b	ble_cont.22046
ble_else.22045:
	fld	%f0, %g6, 0
	fld	%f1, %g6, 8
	fld	%f2, %g6, 16
	st	%g6, %g1, 12
	st	%g7, %g1, 16
	mov	%g3, %g5
	st	%g31, %g1, 20
	addi	%g1, %g1, 24
	call	quadratic.2959
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g3, 0
	mvlo	%g3, 3
	ld	%g4, %g1, 16
	bne	%g4, %g3, beq_else.22047
	setL %g3, l.14053
	fld	%f1, %g3, 0
	fsub	%f0, %f0, %f1
	b	beq_cont.22048
beq_else.22047:
beq_cont.22048:
	ld	%g3, %g1, 12
	fst	%f0, %g3, 24
ble_cont.22046:
beq_cont.22044:
	ld	%g3, %g1, 8
	subi	%g4, %g3, 1
	ld	%g3, %g1, 0
	ld	%g30, %g1, 4
	ld	%g30, 0, %g29
	b	%g29
ble_else.22042:
	return
is_rect_outside.3041:
	setL %g4, l.14007
	fld	%f3, %g4, 0
	fblt	%f0, %f3, fble_else.22050
	fneg	%f0, %f0
	b	fble_cont.22051
fble_else.22050:
fble_cont.22051:
	ld	%g4, %g3, 16
	fld	%f3, %g4, 0
	fblt	%f0, %f3, fble_else.22052
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22053
fble_else.22052:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22053:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.22054
	mvhi	%g4, 0
	mvlo	%g4, 0
	b	beq_cont.22055
beq_else.22054:
	setL %g4, l.14007
	fld	%f0, %g4, 0
	fblt	%f1, %f0, fble_else.22056
	fneg	%f0, %f1
	b	fble_cont.22057
fble_else.22056:
	fmov	%f0, %f1
fble_cont.22057:
	ld	%g4, %g3, 16
	fld	%f1, %g4, 8
	fblt	%f0, %f1, fble_else.22058
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22059
fble_else.22058:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22059:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.22060
	mvhi	%g4, 0
	mvlo	%g4, 0
	b	beq_cont.22061
beq_else.22060:
	setL %g4, l.14007
	fld	%f0, %g4, 0
	fblt	%f2, %f0, fble_else.22062
	fneg	%f0, %f2
	b	fble_cont.22063
fble_else.22062:
	fmov	%f0, %f2
fble_cont.22063:
	ld	%g4, %g3, 16
	fld	%f1, %g4, 16
	fblt	%f0, %f1, fble_else.22064
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22065
fble_else.22064:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22065:
beq_cont.22061:
beq_cont.22055:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.22066
	ld	%g3, %g3, 24
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22067
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
beq_else.22067:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.22066:
	ld	%g3, %g3, 24
	return
is_outside.3056:
	ld	%g4, %g3, 20
	fld	%f3, %g4, 0
	fsub	%f0, %f0, %f3
	ld	%g4, %g3, 20
	fld	%f3, %g4, 8
	fsub	%f1, %f1, %f3
	ld	%g4, %g3, 20
	fld	%f3, %g4, 16
	fsub	%f2, %f2, %f3
	ld	%g4, %g3, 4
	mvhi	%g5, 0
	mvlo	%g5, 1
	bne	%g4, %g5, beq_else.22068
	setL %g4, l.14007
	fld	%f3, %g4, 0
	fblt	%f0, %f3, fble_else.22069
	fneg	%f0, %f0
	b	fble_cont.22070
fble_else.22069:
fble_cont.22070:
	ld	%g4, %g3, 16
	fld	%f3, %g4, 0
	fblt	%f0, %f3, fble_else.22071
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22072
fble_else.22071:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22072:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.22073
	mvhi	%g4, 0
	mvlo	%g4, 0
	b	beq_cont.22074
beq_else.22073:
	setL %g4, l.14007
	fld	%f0, %g4, 0
	fblt	%f1, %f0, fble_else.22075
	fneg	%f0, %f1
	b	fble_cont.22076
fble_else.22075:
	fmov	%f0, %f1
fble_cont.22076:
	ld	%g4, %g3, 16
	fld	%f1, %g4, 8
	fblt	%f0, %f1, fble_else.22077
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22078
fble_else.22077:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22078:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.22079
	mvhi	%g4, 0
	mvlo	%g4, 0
	b	beq_cont.22080
beq_else.22079:
	setL %g4, l.14007
	fld	%f0, %g4, 0
	fblt	%f2, %f0, fble_else.22081
	fneg	%f0, %f2
	b	fble_cont.22082
fble_else.22081:
	fmov	%f0, %f2
fble_cont.22082:
	ld	%g4, %g3, 16
	fld	%f1, %g4, 16
	fblt	%f0, %f1, fble_else.22083
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22084
fble_else.22083:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22084:
beq_cont.22080:
beq_cont.22074:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.22085
	ld	%g3, %g3, 24
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22086
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
beq_else.22086:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.22085:
	ld	%g3, %g3, 24
	return
beq_else.22068:
	mvhi	%g5, 0
	mvlo	%g5, 2
	bne	%g4, %g5, beq_else.22087
	ld	%g4, %g3, 16
	fld	%f3, %g4, 0
	fmul	%f0, %f3, %f0
	fld	%f3, %g4, 8
	fmul	%f1, %f3, %f1
	fadd	%f0, %f0, %f1
	fld	%f1, %g4, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	ld	%g3, %g3, 24
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.22088
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22089
fble_else.22088:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22089:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g3, %g5, beq_else.22090
	mov	%g3, %g4
	b	beq_cont.22091
beq_else.22090:
	mvhi	%g3, 0
	mvlo	%g3, 0
	bne	%g4, %g3, beq_else.22092
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	beq_cont.22093
beq_else.22092:
	mvhi	%g3, 0
	mvlo	%g3, 0
beq_cont.22093:
beq_cont.22091:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22094
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
beq_else.22094:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.22087:
	st	%g3, %g1, 0
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	quadratic.2959
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g3, %g1, 0
	ld	%g4, %g3, 4
	mvhi	%g5, 0
	mvlo	%g5, 3
	bne	%g4, %g5, beq_else.22095
	setL %g4, l.14053
	fld	%f1, %g4, 0
	fsub	%f0, %f0, %f1
	b	beq_cont.22096
beq_else.22095:
beq_cont.22096:
	ld	%g3, %g3, 24
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.22097
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22098
fble_else.22097:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22098:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g3, %g5, beq_else.22099
	mov	%g3, %g4
	b	beq_cont.22100
beq_else.22099:
	mvhi	%g3, 0
	mvlo	%g3, 0
	bne	%g4, %g3, beq_else.22101
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	beq_cont.22102
beq_else.22101:
	mvhi	%g3, 0
	mvlo	%g3, 0
beq_cont.22102:
beq_cont.22100:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22103
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
beq_else.22103:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
check_all_inside.3061:
	ld	%g5, %g30, 4
	slli	%g6, %g3, 2
	ld	%g6, %g4, %g6
	mvhi	%g7, 65535
	mvlo	%g7, -1
	bne	%g6, %g7, beq_else.22104
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
beq_else.22104:
	slli	%g6, %g6, 2
	ld	%g6, %g5, %g6
	ld	%g7, %g6, 20
	fld	%f3, %g7, 0
	fsub	%f3, %f0, %f3
	ld	%g7, %g6, 20
	fld	%f4, %g7, 8
	fsub	%f4, %f1, %f4
	ld	%g7, %g6, 20
	fld	%f5, %g7, 16
	fsub	%f5, %f2, %f5
	ld	%g7, %g6, 4
	mvhi	%g8, 0
	mvlo	%g8, 1
	st	%g30, %g1, 0
	std	%f2, %g1, 8
	std	%f1, %g1, 16
	std	%f0, %g1, 24
	st	%g5, %g1, 32
	st	%g4, %g1, 36
	st	%g3, %g1, 40
	bne	%g7, %g8, beq_else.22106
	mov	%g3, %g6
	fmov	%f2, %f5
	fmov	%f1, %f4
	fmov	%f0, %f3
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	is_rect_outside.3041
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	b	beq_cont.22107
beq_else.22106:
	mvhi	%g8, 0
	mvlo	%g8, 2
	bne	%g7, %g8, beq_else.22108
	ld	%g7, %g6, 16
	fld	%f6, %g7, 0
	fmul	%f3, %f6, %f3
	fld	%f6, %g7, 8
	fmul	%f4, %f6, %f4
	fadd	%f3, %f3, %f4
	fld	%f4, %g7, 16
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	ld	%g6, %g6, 24
	setL %g7, l.14007
	fld	%f4, %g7, 0
	fblt	%f3, %f4, fble_else.22110
	mvhi	%g7, 0
	mvlo	%g7, 1
	b	fble_cont.22111
fble_else.22110:
	mvhi	%g7, 0
	mvlo	%g7, 0
fble_cont.22111:
	mvhi	%g8, 0
	mvlo	%g8, 0
	bne	%g6, %g8, beq_else.22112
	mov	%g6, %g7
	b	beq_cont.22113
beq_else.22112:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g7, %g6, beq_else.22114
	mvhi	%g6, 0
	mvlo	%g6, 1
	b	beq_cont.22115
beq_else.22114:
	mvhi	%g6, 0
	mvlo	%g6, 0
beq_cont.22115:
beq_cont.22113:
	mvhi	%g7, 0
	mvlo	%g7, 0
	bne	%g6, %g7, beq_else.22116
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	beq_cont.22117
beq_else.22116:
	mvhi	%g3, 0
	mvlo	%g3, 0
beq_cont.22117:
	b	beq_cont.22109
beq_else.22108:
	st	%g6, %g1, 44
	mov	%g3, %g6
	fmov	%f2, %f5
	fmov	%f1, %f4
	fmov	%f0, %f3
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	quadratic.2959
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 44
	ld	%g4, %g3, 4
	mvhi	%g5, 0
	mvlo	%g5, 3
	bne	%g4, %g5, beq_else.22118
	setL %g4, l.14053
	fld	%f1, %g4, 0
	fsub	%f0, %f0, %f1
	b	beq_cont.22119
beq_else.22118:
beq_cont.22119:
	ld	%g3, %g3, 24
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.22120
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22121
fble_else.22120:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22121:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g3, %g5, beq_else.22122
	mov	%g3, %g4
	b	beq_cont.22123
beq_else.22122:
	mvhi	%g3, 0
	mvlo	%g3, 0
	bne	%g4, %g3, beq_else.22124
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	beq_cont.22125
beq_else.22124:
	mvhi	%g3, 0
	mvlo	%g3, 0
beq_cont.22125:
beq_cont.22123:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22126
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	beq_cont.22127
beq_else.22126:
	mvhi	%g3, 0
	mvlo	%g3, 0
beq_cont.22127:
beq_cont.22109:
beq_cont.22107:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22128
	ld	%g3, %g1, 40
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 36
	ld	%g4, %g5, %g4
	mvhi	%g6, 65535
	mvlo	%g6, -1
	bne	%g4, %g6, beq_else.22129
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
beq_else.22129:
	slli	%g4, %g4, 2
	ld	%g6, %g1, 32
	ld	%g4, %g6, %g4
	fld	%f0, %g1, 24
	fld	%f1, %g1, 16
	fld	%f2, %g1, 8
	st	%g3, %g1, 48
	mov	%g3, %g4
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	is_outside.3056
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22130
	ld	%g3, %g1, 48
	addi	%g3, %g3, 1
	fld	%f0, %g1, 24
	fld	%f1, %g1, 16
	fld	%f2, %g1, 8
	ld	%g4, %g1, 36
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
beq_else.22130:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.22128:
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
shadow_check_and_group.3067:
	ld	%g5, %g30, 36
	ld	%g6, %g30, 32
	ld	%g7, %g30, 28
	ld	%g8, %g30, 24
	ld	%g9, %g30, 20
	ld	%g10, %g30, 16
	ld	%g11, %g30, 12
	ld	%g12, %g30, 8
	ld	%g13, %g30, 4
	slli	%g14, %g3, 2
	ld	%g14, %g4, %g14
	mvhi	%g15, 65535
	mvlo	%g15, -1
	bne	%g14, %g15, beq_else.22131
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.22131:
	slli	%g14, %g3, 2
	ld	%g14, %g4, %g14
	slli	%g15, %g14, 2
	ld	%g15, %g9, %g15
	fld	%f0, %g11, 0
	ld	%g16, %g15, 20
	fld	%f1, %g16, 0
	fsub	%f0, %f0, %f1
	fld	%f1, %g11, 8
	ld	%g16, %g15, 20
	fld	%f2, %g16, 8
	fsub	%f1, %f1, %f2
	fld	%f2, %g11, 16
	ld	%g16, %g15, 20
	fld	%f3, %g16, 16
	fsub	%f2, %f2, %f3
	slli	%g16, %g14, 2
	ld	%g12, %g12, %g16
	ld	%g16, %g15, 4
	mvhi	%g17, 0
	mvlo	%g17, 1
	st	%g13, %g1, 0
	st	%g11, %g1, 4
	st	%g10, %g1, 8
	st	%g4, %g1, 12
	st	%g30, %g1, 16
	st	%g3, %g1, 20
	st	%g9, %g1, 24
	st	%g14, %g1, 28
	st	%g8, %g1, 32
	bne	%g16, %g17, beq_else.22132
	mov	%g4, %g5
	mov	%g3, %g15
	mov	%g30, %g7
	mov	%g5, %g12
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	b	beq_cont.22133
beq_else.22132:
	mvhi	%g5, 0
	mvlo	%g5, 2
	bne	%g16, %g5, beq_else.22134
	fld	%f3, %g12, 0
	setL %g5, l.14007
	fld	%f4, %g5, 0
	fblt	%f3, %f4, fble_else.22136
	mvhi	%g5, 0
	mvlo	%g5, 1
	b	fble_cont.22137
fble_else.22136:
	mvhi	%g5, 0
	mvlo	%g5, 0
fble_cont.22137:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g5, %g6, beq_else.22138
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22139
beq_else.22138:
	fld	%f3, %g12, 8
	fmul	%f0, %f3, %f0
	fld	%f3, %g12, 16
	fmul	%f1, %f3, %f1
	fadd	%f0, %f0, %f1
	fld	%f1, %g12, 24
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g8, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
beq_cont.22139:
	b	beq_cont.22135
beq_else.22134:
	mov	%g4, %g12
	mov	%g3, %g15
	mov	%g30, %g6
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
beq_cont.22135:
beq_cont.22133:
	ld	%g4, %g1, 32
	fld	%f0, %g4, 0
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22140
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22141
beq_else.22140:
	setL %g3, l.14608
	fld	%f1, %g3, 0
	fblt	%f0, %f1, fble_else.22142
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22143
fble_else.22142:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22143:
beq_cont.22141:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22144
	ld	%g3, %g1, 28
	slli	%g3, %g3, 2
	ld	%g4, %g1, 24
	ld	%g3, %g4, %g3
	ld	%g3, %g3, 24
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22145
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.22145:
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	ld	%g4, %g1, 12
	ld	%g30, %g1, 16
	ld	%g30, 0, %g29
	b	%g29
beq_else.22144:
	setL %g3, l.14610
	fld	%f1, %g3, 0
	fadd	%f0, %f0, %f1
	ld	%g3, %g1, 8
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	ld	%g4, %g1, 4
	fld	%f2, %g4, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g3, 8
	fmul	%f2, %f2, %f0
	fld	%f3, %g4, 8
	fadd	%f2, %f2, %f3
	fld	%f3, %g3, 16
	fmul	%f0, %f3, %f0
	fld	%f3, %g4, 16
	fadd	%f0, %f0, %f3
	ld	%g4, %g1, 12
	ld	%g3, %g4, 0
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g3, %g5, beq_else.22146
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	beq_cont.22147
beq_else.22146:
	slli	%g3, %g3, 2
	ld	%g5, %g1, 24
	ld	%g3, %g5, %g3
	std	%f0, %g1, 40
	std	%f2, %g1, 48
	std	%f1, %g1, 56
	fmov	%f31, %f2
	fmov	%f2, %f0
	fmov	%f0, %f1
	fmov	%f1, %f31
	st	%g31, %g1, 68
	addi	%g1, %g1, 72
	call	is_outside.3056
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22149
	mvhi	%g3, 0
	mvlo	%g3, 1
	fld	%f0, %g1, 56
	fld	%f1, %g1, 48
	fld	%f2, %g1, 40
	ld	%g4, %g1, 12
	ld	%g30, %g1, 0
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	b	beq_cont.22150
beq_else.22149:
	mvhi	%g3, 0
	mvlo	%g3, 0
beq_cont.22150:
beq_cont.22147:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22151
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	ld	%g4, %g1, 12
	ld	%g30, %g1, 16
	ld	%g30, 0, %g29
	b	%g29
beq_else.22151:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
shadow_check_one_or_group.3070:
	ld	%g5, %g30, 8
	ld	%g6, %g30, 4
	slli	%g7, %g3, 2
	ld	%g7, %g4, %g7
	mvhi	%g8, 65535
	mvlo	%g8, -1
	bne	%g7, %g8, beq_else.22152
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.22152:
	slli	%g7, %g7, 2
	ld	%g7, %g6, %g7
	mvhi	%g8, 0
	mvlo	%g8, 0
	st	%g30, %g1, 0
	st	%g5, %g1, 4
	st	%g6, %g1, 8
	st	%g4, %g1, 12
	st	%g3, %g1, 16
	mov	%g4, %g7
	mov	%g3, %g8
	mov	%g30, %g5
	st	%g31, %g1, 20
	ld	%g29, %g30, 0
	addi	%g1, %g1, 24
	call	%g29
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22153
	ld	%g3, %g1, 16
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 12
	ld	%g4, %g5, %g4
	mvhi	%g6, 65535
	mvlo	%g6, -1
	bne	%g4, %g6, beq_else.22154
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.22154:
	slli	%g4, %g4, 2
	ld	%g6, %g1, 8
	ld	%g4, %g6, %g4
	mvhi	%g7, 0
	mvlo	%g7, 0
	ld	%g30, %g1, 4
	st	%g3, %g1, 20
	mov	%g3, %g7
	st	%g31, %g1, 28
	ld	%g29, %g30, 0
	addi	%g1, %g1, 32
	call	%g29
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22155
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 12
	ld	%g4, %g5, %g4
	mvhi	%g6, 65535
	mvlo	%g6, -1
	bne	%g4, %g6, beq_else.22156
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.22156:
	slli	%g4, %g4, 2
	ld	%g6, %g1, 8
	ld	%g4, %g6, %g4
	mvhi	%g7, 0
	mvlo	%g7, 0
	ld	%g30, %g1, 4
	st	%g3, %g1, 24
	mov	%g3, %g7
	st	%g31, %g1, 28
	ld	%g29, %g30, 0
	addi	%g1, %g1, 32
	call	%g29
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22157
	ld	%g3, %g1, 24
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 12
	ld	%g4, %g5, %g4
	mvhi	%g6, 65535
	mvlo	%g6, -1
	bne	%g4, %g6, beq_else.22158
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.22158:
	slli	%g4, %g4, 2
	ld	%g6, %g1, 8
	ld	%g4, %g6, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g30, %g1, 4
	st	%g3, %g1, 28
	mov	%g3, %g6
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22159
	ld	%g3, %g1, 28
	addi	%g3, %g3, 1
	ld	%g4, %g1, 12
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
beq_else.22159:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
beq_else.22157:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
beq_else.22155:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
beq_else.22153:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
shadow_check_one_or_matrix.3073:
	ld	%g5, %g30, 40
	ld	%g6, %g30, 36
	ld	%g7, %g30, 32
	ld	%g8, %g30, 28
	ld	%g9, %g30, 24
	ld	%g10, %g30, 20
	ld	%g11, %g30, 16
	ld	%g12, %g30, 12
	ld	%g13, %g30, 8
	ld	%g14, %g30, 4
	slli	%g15, %g3, 2
	ld	%g15, %g4, %g15
	ld	%g16, %g15, 0
	mvhi	%g17, 65535
	mvlo	%g17, -1
	bne	%g16, %g17, beq_else.22160
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.22160:
	mvhi	%g17, 0
	mvlo	%g17, 99
	st	%g9, %g1, 0
	st	%g10, %g1, 4
	st	%g14, %g1, 8
	st	%g15, %g1, 12
	st	%g4, %g1, 16
	st	%g30, %g1, 20
	st	%g3, %g1, 24
	bne	%g16, %g17, beq_else.22161
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	beq_cont.22162
beq_else.22161:
	slli	%g17, %g16, 2
	ld	%g11, %g11, %g17
	fld	%f0, %g12, 0
	ld	%g17, %g11, 20
	fld	%f1, %g17, 0
	fsub	%f0, %f0, %f1
	fld	%f1, %g12, 8
	ld	%g17, %g11, 20
	fld	%f2, %g17, 8
	fsub	%f1, %f1, %f2
	fld	%f2, %g12, 16
	ld	%g12, %g11, 20
	fld	%f3, %g12, 16
	fsub	%f2, %f2, %f3
	slli	%g12, %g16, 2
	ld	%g12, %g13, %g12
	ld	%g13, %g11, 4
	mvhi	%g16, 0
	mvlo	%g16, 1
	st	%g8, %g1, 28
	bne	%g13, %g16, beq_else.22163
	mov	%g4, %g5
	mov	%g3, %g11
	mov	%g30, %g7
	mov	%g5, %g12
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	b	beq_cont.22164
beq_else.22163:
	mvhi	%g5, 0
	mvlo	%g5, 2
	bne	%g13, %g5, beq_else.22165
	fld	%f3, %g12, 0
	setL %g5, l.14007
	fld	%f4, %g5, 0
	fblt	%f3, %f4, fble_else.22167
	mvhi	%g5, 0
	mvlo	%g5, 1
	b	fble_cont.22168
fble_else.22167:
	mvhi	%g5, 0
	mvlo	%g5, 0
fble_cont.22168:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g5, %g6, beq_else.22169
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22170
beq_else.22169:
	fld	%f3, %g12, 8
	fmul	%f0, %f3, %f0
	fld	%f3, %g12, 16
	fmul	%f1, %f3, %f1
	fadd	%f0, %f0, %f1
	fld	%f1, %g12, 24
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fst	%f0, %g8, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
beq_cont.22170:
	b	beq_cont.22166
beq_else.22165:
	mov	%g4, %g12
	mov	%g3, %g11
	mov	%g30, %g6
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
beq_cont.22166:
beq_cont.22164:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22171
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22172
beq_else.22171:
	ld	%g3, %g1, 28
	fld	%f0, %g3, 0
	setL %g3, l.14646
	fld	%f1, %g3, 0
	fblt	%f0, %f1, fble_else.22173
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22174
fble_else.22173:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22174:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22175
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22176
beq_else.22175:
	ld	%g3, %g1, 12
	ld	%g4, %g3, 4
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22177
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22178
beq_else.22177:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 8
	ld	%g4, %g5, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g30, %g1, 4
	mov	%g3, %g6
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22179
	ld	%g3, %g1, 12
	ld	%g4, %g3, 8
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22181
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22182
beq_else.22181:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 8
	ld	%g4, %g5, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g30, %g1, 4
	mov	%g3, %g6
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22183
	ld	%g3, %g1, 12
	ld	%g4, %g3, 12
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22185
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22186
beq_else.22185:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 8
	ld	%g4, %g5, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g30, %g1, 4
	mov	%g3, %g6
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22187
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 12
	ld	%g30, %g1, 0
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	b	beq_cont.22188
beq_else.22187:
	mvhi	%g3, 0
	mvlo	%g3, 1
beq_cont.22188:
beq_cont.22186:
	b	beq_cont.22184
beq_else.22183:
	mvhi	%g3, 0
	mvlo	%g3, 1
beq_cont.22184:
beq_cont.22182:
	b	beq_cont.22180
beq_else.22179:
	mvhi	%g3, 0
	mvlo	%g3, 1
beq_cont.22180:
beq_cont.22178:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22189
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22190
beq_else.22189:
	mvhi	%g3, 0
	mvlo	%g3, 1
beq_cont.22190:
beq_cont.22176:
beq_cont.22172:
beq_cont.22162:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22191
	ld	%g3, %g1, 24
	addi	%g3, %g3, 1
	ld	%g4, %g1, 16
	ld	%g30, %g1, 20
	ld	%g30, 0, %g29
	b	%g29
beq_else.22191:
	ld	%g3, %g1, 12
	ld	%g4, %g3, 4
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22192
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22193
beq_else.22192:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 8
	ld	%g4, %g5, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g30, %g1, 4
	mov	%g3, %g6
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22194
	ld	%g3, %g1, 12
	ld	%g4, %g3, 8
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22196
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22197
beq_else.22196:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 8
	ld	%g4, %g5, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g30, %g1, 4
	mov	%g3, %g6
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22198
	ld	%g3, %g1, 12
	ld	%g4, %g3, 12
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22200
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22201
beq_else.22200:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 8
	ld	%g4, %g5, %g4
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g30, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22202
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 12
	ld	%g30, %g1, 0
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	b	beq_cont.22203
beq_else.22202:
	mvhi	%g3, 0
	mvlo	%g3, 1
beq_cont.22203:
beq_cont.22201:
	b	beq_cont.22199
beq_else.22198:
	mvhi	%g3, 0
	mvlo	%g3, 1
beq_cont.22199:
beq_cont.22197:
	b	beq_cont.22195
beq_else.22194:
	mvhi	%g3, 0
	mvlo	%g3, 1
beq_cont.22195:
beq_cont.22193:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22204
	ld	%g3, %g1, 24
	addi	%g3, %g3, 1
	ld	%g4, %g1, 16
	ld	%g30, %g1, 20
	ld	%g30, 0, %g29
	b	%g29
beq_else.22204:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
solve_each_element.3076:
	ld	%g6, %g30, 44
	ld	%g7, %g30, 40
	ld	%g8, %g30, 36
	ld	%g9, %g30, 32
	ld	%g10, %g30, 28
	ld	%g11, %g30, 24
	ld	%g12, %g30, 20
	ld	%g13, %g30, 16
	ld	%g14, %g30, 12
	ld	%g15, %g30, 8
	ld	%g16, %g30, 4
	slli	%g17, %g3, 2
	ld	%g17, %g4, %g17
	mvhi	%g18, 65535
	mvlo	%g18, -1
	bne	%g17, %g18, beq_else.22205
	return
beq_else.22205:
	slli	%g18, %g17, 2
	ld	%g18, %g12, %g18
	fld	%f0, %g7, 0
	ld	%g19, %g18, 20
	fld	%f1, %g19, 0
	fsub	%f0, %f0, %f1
	fld	%f1, %g7, 8
	ld	%g19, %g18, 20
	fld	%f2, %g19, 8
	fsub	%f1, %f1, %f2
	fld	%f2, %g7, 16
	ld	%g19, %g18, 20
	fld	%f3, %g19, 16
	fsub	%f2, %f2, %f3
	ld	%g19, %g18, 4
	mvhi	%g20, 0
	mvlo	%g20, 1
	st	%g13, %g1, 0
	st	%g15, %g1, 4
	st	%g14, %g1, 8
	st	%g16, %g1, 12
	st	%g7, %g1, 16
	st	%g6, %g1, 20
	st	%g11, %g1, 24
	st	%g5, %g1, 28
	st	%g4, %g1, 32
	st	%g30, %g1, 36
	st	%g3, %g1, 40
	st	%g12, %g1, 44
	st	%g17, %g1, 48
	bne	%g19, %g20, beq_else.22207
	mvhi	%g8, 0
	mvlo	%g8, 0
	mvhi	%g9, 0
	mvlo	%g9, 1
	mvhi	%g19, 0
	mvlo	%g19, 2
	std	%f0, %g1, 56
	std	%f2, %g1, 64
	std	%f1, %g1, 72
	st	%g18, %g1, 80
	st	%g10, %g1, 84
	mov	%g7, %g19
	mov	%g6, %g9
	mov	%g4, %g5
	mov	%g3, %g18
	mov	%g30, %g10
	mov	%g5, %g8
	st	%g31, %g1, 92
	ld	%g29, %g30, 0
	addi	%g1, %g1, 96
	call	%g29
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22210
	mvhi	%g5, 0
	mvlo	%g5, 1
	mvhi	%g6, 0
	mvlo	%g6, 2
	mvhi	%g7, 0
	mvlo	%g7, 0
	fld	%f0, %g1, 72
	fld	%f1, %g1, 64
	fld	%f2, %g1, 56
	ld	%g3, %g1, 80
	ld	%g4, %g1, 28
	ld	%g30, %g1, 84
	st	%g31, %g1, 92
	ld	%g29, %g30, 0
	addi	%g1, %g1, 96
	call	%g29
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22212
	mvhi	%g5, 0
	mvlo	%g5, 2
	mvhi	%g6, 0
	mvlo	%g6, 0
	mvhi	%g7, 0
	mvlo	%g7, 1
	fld	%f0, %g1, 64
	fld	%f1, %g1, 56
	fld	%f2, %g1, 72
	ld	%g3, %g1, 80
	ld	%g4, %g1, 28
	ld	%g30, %g1, 84
	st	%g31, %g1, 92
	ld	%g29, %g30, 0
	addi	%g1, %g1, 96
	call	%g29
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22214
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22215
beq_else.22214:
	mvhi	%g3, 0
	mvlo	%g3, 3
beq_cont.22215:
	b	beq_cont.22213
beq_else.22212:
	mvhi	%g3, 0
	mvlo	%g3, 2
beq_cont.22213:
	b	beq_cont.22211
beq_else.22210:
	mvhi	%g3, 0
	mvlo	%g3, 1
beq_cont.22211:
	b	beq_cont.22208
beq_else.22207:
	mvhi	%g10, 0
	mvlo	%g10, 2
	bne	%g19, %g10, beq_else.22216
	mov	%g4, %g5
	mov	%g3, %g18
	mov	%g30, %g8
	st	%g31, %g1, 92
	ld	%g29, %g30, 0
	addi	%g1, %g1, 96
	call	%g29
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
	b	beq_cont.22217
beq_else.22216:
	mov	%g4, %g5
	mov	%g3, %g18
	mov	%g30, %g9
	st	%g31, %g1, 92
	ld	%g29, %g30, 0
	addi	%g1, %g1, 96
	call	%g29
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
beq_cont.22217:
beq_cont.22208:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22218
	ld	%g3, %g1, 48
	slli	%g3, %g3, 2
	ld	%g4, %g1, 44
	ld	%g3, %g4, %g3
	ld	%g3, %g3, 24
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22219
	return
beq_else.22219:
	ld	%g3, %g1, 40
	addi	%g3, %g3, 1
	ld	%g4, %g1, 32
	ld	%g5, %g1, 28
	ld	%g30, %g1, 36
	ld	%g30, 0, %g29
	b	%g29
beq_else.22218:
	ld	%g4, %g1, 24
	fld	%f0, %g4, 0
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f1, %f0, fble_else.22221
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22222
fble_else.22221:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22222:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.22223
	b	beq_cont.22224
beq_else.22223:
	ld	%g4, %g1, 20
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.22225
	mvhi	%g5, 0
	mvlo	%g5, 1
	b	fble_cont.22226
fble_else.22225:
	mvhi	%g5, 0
	mvlo	%g5, 0
fble_cont.22226:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g5, %g6, beq_else.22227
	b	beq_cont.22228
beq_else.22227:
	setL %g5, l.14610
	fld	%f1, %g5, 0
	fadd	%f0, %f0, %f1
	ld	%g5, %g1, 28
	fld	%f1, %g5, 0
	fmul	%f1, %f1, %f0
	ld	%g6, %g1, 16
	fld	%f2, %g6, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g5, 8
	fmul	%f2, %f2, %f0
	fld	%f3, %g6, 8
	fadd	%f2, %f2, %f3
	fld	%f3, %g5, 16
	fmul	%f3, %f3, %f0
	fld	%f4, %g6, 16
	fadd	%f3, %f3, %f4
	ld	%g6, %g1, 32
	ld	%g7, %g6, 0
	mvhi	%g8, 65535
	mvlo	%g8, -1
	st	%g3, %g1, 88
	std	%f3, %g1, 96
	std	%f2, %g1, 104
	std	%f1, %g1, 112
	std	%f0, %g1, 120
	bne	%g7, %g8, beq_else.22230
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	beq_cont.22231
beq_else.22230:
	slli	%g7, %g7, 2
	ld	%g8, %g1, 44
	ld	%g7, %g8, %g7
	mov	%g3, %g7
	fmov	%f0, %f1
	fmov	%f1, %f2
	fmov	%f2, %f3
	st	%g31, %g1, 132
	addi	%g1, %g1, 136
	call	is_outside.3056
	subi	%g1, %g1, 136
	ld	%g31, %g1, 132
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22232
	mvhi	%g3, 0
	mvlo	%g3, 1
	fld	%f0, %g1, 112
	fld	%f1, %g1, 104
	fld	%f2, %g1, 96
	ld	%g4, %g1, 32
	ld	%g30, %g1, 12
	st	%g31, %g1, 132
	ld	%g29, %g30, 0
	addi	%g1, %g1, 136
	call	%g29
	subi	%g1, %g1, 136
	ld	%g31, %g1, 132
	b	beq_cont.22233
beq_else.22232:
	mvhi	%g3, 0
	mvlo	%g3, 0
beq_cont.22233:
beq_cont.22231:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22234
	b	beq_cont.22235
beq_else.22234:
	ld	%g3, %g1, 20
	fld	%f0, %g1, 120
	fst	%f0, %g3, 0
	ld	%g3, %g1, 8
	fld	%f0, %g1, 112
	fst	%f0, %g3, 0
	fld	%f0, %g1, 104
	fst	%f0, %g3, 8
	fld	%f0, %g1, 96
	fst	%f0, %g3, 16
	ld	%g3, %g1, 4
	ld	%g4, %g1, 48
	st	%g4, %g3, 0
	ld	%g3, %g1, 0
	ld	%g4, %g1, 88
	st	%g4, %g3, 0
beq_cont.22235:
beq_cont.22228:
beq_cont.22224:
	ld	%g3, %g1, 40
	addi	%g3, %g3, 1
	ld	%g4, %g1, 32
	ld	%g5, %g1, 28
	ld	%g30, %g1, 36
	ld	%g30, 0, %g29
	b	%g29
solve_one_or_network.3080:
	ld	%g6, %g30, 8
	ld	%g7, %g30, 4
	slli	%g8, %g3, 2
	ld	%g8, %g4, %g8
	mvhi	%g9, 65535
	mvlo	%g9, -1
	bne	%g8, %g9, beq_else.22236
	return
beq_else.22236:
	slli	%g8, %g8, 2
	ld	%g8, %g7, %g8
	mvhi	%g9, 0
	mvlo	%g9, 0
	st	%g30, %g1, 0
	st	%g5, %g1, 4
	st	%g6, %g1, 8
	st	%g7, %g1, 12
	st	%g4, %g1, 16
	st	%g3, %g1, 20
	mov	%g4, %g8
	mov	%g3, %g9
	mov	%g30, %g6
	st	%g31, %g1, 28
	ld	%g29, %g30, 0
	addi	%g1, %g1, 32
	call	%g29
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	ld	%g4, %g5, %g4
	mvhi	%g6, 65535
	mvlo	%g6, -1
	bne	%g4, %g6, beq_else.22238
	return
beq_else.22238:
	slli	%g4, %g4, 2
	ld	%g6, %g1, 12
	ld	%g4, %g6, %g4
	mvhi	%g7, 0
	mvlo	%g7, 0
	ld	%g8, %g1, 4
	ld	%g30, %g1, 8
	st	%g3, %g1, 24
	mov	%g5, %g8
	mov	%g3, %g7
	st	%g31, %g1, 28
	ld	%g29, %g30, 0
	addi	%g1, %g1, 32
	call	%g29
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 24
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	ld	%g4, %g5, %g4
	mvhi	%g6, 65535
	mvlo	%g6, -1
	bne	%g4, %g6, beq_else.22240
	return
beq_else.22240:
	slli	%g4, %g4, 2
	ld	%g6, %g1, 12
	ld	%g4, %g6, %g4
	mvhi	%g7, 0
	mvlo	%g7, 0
	ld	%g8, %g1, 4
	ld	%g30, %g1, 8
	st	%g3, %g1, 28
	mov	%g5, %g8
	mov	%g3, %g7
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	ld	%g4, %g5, %g4
	mvhi	%g6, 65535
	mvlo	%g6, -1
	bne	%g4, %g6, beq_else.22242
	return
beq_else.22242:
	slli	%g4, %g4, 2
	ld	%g6, %g1, 12
	ld	%g4, %g6, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g7, %g1, 4
	ld	%g30, %g1, 8
	st	%g3, %g1, 32
	mov	%g5, %g7
	mov	%g3, %g6
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	addi	%g3, %g3, 1
	ld	%g4, %g1, 16
	ld	%g5, %g1, 4
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
trace_or_matrix.3084:
	ld	%g6, %g30, 44
	ld	%g7, %g30, 40
	ld	%g8, %g30, 36
	ld	%g9, %g30, 32
	ld	%g10, %g30, 28
	ld	%g11, %g30, 24
	ld	%g12, %g30, 20
	ld	%g13, %g30, 16
	ld	%g14, %g30, 12
	ld	%g15, %g30, 8
	ld	%g16, %g30, 4
	slli	%g17, %g3, 2
	ld	%g17, %g4, %g17
	ld	%g18, %g17, 0
	mvhi	%g19, 65535
	mvlo	%g19, -1
	bne	%g18, %g19, beq_else.22244
	return
beq_else.22244:
	mvhi	%g19, 0
	mvlo	%g19, 99
	st	%g30, %g1, 0
	st	%g6, %g1, 4
	st	%g11, %g1, 8
	st	%g7, %g1, 12
	st	%g12, %g1, 16
	st	%g13, %g1, 20
	st	%g5, %g1, 24
	st	%g14, %g1, 28
	st	%g16, %g1, 32
	st	%g4, %g1, 36
	st	%g3, %g1, 40
	bne	%g18, %g19, beq_else.22246
	ld	%g8, %g17, 4
	mvhi	%g9, 65535
	mvlo	%g9, -1
	bne	%g8, %g9, beq_else.22248
	b	beq_cont.22249
beq_else.22248:
	slli	%g8, %g8, 2
	ld	%g8, %g16, %g8
	mvhi	%g9, 0
	mvlo	%g9, 0
	st	%g17, %g1, 44
	mov	%g4, %g8
	mov	%g3, %g9
	mov	%g30, %g14
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 44
	ld	%g4, %g3, 8
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22250
	b	beq_cont.22251
beq_else.22250:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 32
	ld	%g4, %g5, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g7, %g1, 24
	ld	%g30, %g1, 28
	mov	%g5, %g7
	mov	%g3, %g6
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 44
	ld	%g4, %g3, 12
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22252
	b	beq_cont.22253
beq_else.22252:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 32
	ld	%g4, %g5, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g7, %g1, 24
	ld	%g30, %g1, 28
	mov	%g5, %g7
	mov	%g3, %g6
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 44
	ld	%g5, %g1, 24
	ld	%g30, %g1, 20
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
beq_cont.22253:
beq_cont.22251:
beq_cont.22249:
	b	beq_cont.22247
beq_else.22246:
	slli	%g18, %g18, 2
	ld	%g15, %g15, %g18
	fld	%f0, %g7, 0
	ld	%g18, %g15, 20
	fld	%f1, %g18, 0
	fsub	%f0, %f0, %f1
	fld	%f1, %g7, 8
	ld	%g18, %g15, 20
	fld	%f2, %g18, 8
	fsub	%f1, %f1, %f2
	fld	%f2, %g7, 16
	ld	%g18, %g15, 20
	fld	%f3, %g18, 16
	fsub	%f2, %f2, %f3
	ld	%g18, %g15, 4
	mvhi	%g19, 0
	mvlo	%g19, 1
	st	%g17, %g1, 44
	bne	%g18, %g19, beq_else.22254
	mvhi	%g8, 0
	mvlo	%g8, 0
	mvhi	%g9, 0
	mvlo	%g9, 1
	mvhi	%g18, 0
	mvlo	%g18, 2
	std	%f0, %g1, 48
	std	%f2, %g1, 56
	std	%f1, %g1, 64
	st	%g15, %g1, 72
	st	%g10, %g1, 76
	mov	%g7, %g18
	mov	%g6, %g9
	mov	%g4, %g5
	mov	%g3, %g15
	mov	%g30, %g10
	mov	%g5, %g8
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22256
	mvhi	%g5, 0
	mvlo	%g5, 1
	mvhi	%g6, 0
	mvlo	%g6, 2
	mvhi	%g7, 0
	mvlo	%g7, 0
	fld	%f0, %g1, 64
	fld	%f1, %g1, 56
	fld	%f2, %g1, 48
	ld	%g3, %g1, 72
	ld	%g4, %g1, 24
	ld	%g30, %g1, 76
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22258
	mvhi	%g5, 0
	mvlo	%g5, 2
	mvhi	%g6, 0
	mvlo	%g6, 0
	mvhi	%g7, 0
	mvlo	%g7, 1
	fld	%f0, %g1, 56
	fld	%f1, %g1, 48
	fld	%f2, %g1, 64
	ld	%g3, %g1, 72
	ld	%g4, %g1, 24
	ld	%g30, %g1, 76
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22260
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22261
beq_else.22260:
	mvhi	%g3, 0
	mvlo	%g3, 3
beq_cont.22261:
	b	beq_cont.22259
beq_else.22258:
	mvhi	%g3, 0
	mvlo	%g3, 2
beq_cont.22259:
	b	beq_cont.22257
beq_else.22256:
	mvhi	%g3, 0
	mvlo	%g3, 1
beq_cont.22257:
	b	beq_cont.22255
beq_else.22254:
	mvhi	%g10, 0
	mvlo	%g10, 2
	bne	%g18, %g10, beq_else.22262
	mov	%g4, %g5
	mov	%g3, %g15
	mov	%g30, %g8
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	b	beq_cont.22263
beq_else.22262:
	mov	%g4, %g5
	mov	%g3, %g15
	mov	%g30, %g9
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
beq_cont.22263:
beq_cont.22255:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22264
	b	beq_cont.22265
beq_else.22264:
	ld	%g3, %g1, 8
	fld	%f0, %g3, 0
	ld	%g4, %g1, 4
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.22266
	mvhi	%g5, 0
	mvlo	%g5, 1
	b	fble_cont.22267
fble_else.22266:
	mvhi	%g5, 0
	mvlo	%g5, 0
fble_cont.22267:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g5, %g6, beq_else.22268
	b	beq_cont.22269
beq_else.22268:
	ld	%g5, %g1, 44
	ld	%g6, %g5, 4
	mvhi	%g7, 65535
	mvlo	%g7, -1
	bne	%g6, %g7, beq_else.22270
	b	beq_cont.22271
beq_else.22270:
	slli	%g6, %g6, 2
	ld	%g7, %g1, 32
	ld	%g6, %g7, %g6
	mvhi	%g8, 0
	mvlo	%g8, 0
	ld	%g9, %g1, 24
	ld	%g30, %g1, 28
	mov	%g5, %g9
	mov	%g4, %g6
	mov	%g3, %g8
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	ld	%g3, %g1, 44
	ld	%g4, %g3, 8
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22272
	b	beq_cont.22273
beq_else.22272:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 32
	ld	%g4, %g5, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g7, %g1, 24
	ld	%g30, %g1, 28
	mov	%g5, %g7
	mov	%g3, %g6
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	ld	%g3, %g1, 44
	ld	%g4, %g3, 12
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22274
	b	beq_cont.22275
beq_else.22274:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 32
	ld	%g4, %g5, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g7, %g1, 24
	ld	%g30, %g1, 28
	mov	%g5, %g7
	mov	%g3, %g6
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 44
	ld	%g5, %g1, 24
	ld	%g30, %g1, 20
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
beq_cont.22275:
beq_cont.22273:
beq_cont.22271:
beq_cont.22269:
beq_cont.22265:
beq_cont.22247:
	ld	%g3, %g1, 40
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 36
	ld	%g4, %g5, %g4
	ld	%g6, %g4, 0
	mvhi	%g7, 65535
	mvlo	%g7, -1
	bne	%g6, %g7, beq_else.22276
	return
beq_else.22276:
	mvhi	%g7, 0
	mvlo	%g7, 99
	st	%g3, %g1, 80
	bne	%g6, %g7, beq_else.22278
	ld	%g6, %g4, 4
	mvhi	%g7, 65535
	mvlo	%g7, -1
	bne	%g6, %g7, beq_else.22280
	b	beq_cont.22281
beq_else.22280:
	slli	%g6, %g6, 2
	ld	%g7, %g1, 32
	ld	%g6, %g7, %g6
	mvhi	%g8, 0
	mvlo	%g8, 0
	ld	%g9, %g1, 24
	ld	%g30, %g1, 28
	st	%g4, %g1, 84
	mov	%g5, %g9
	mov	%g4, %g6
	mov	%g3, %g8
	st	%g31, %g1, 92
	ld	%g29, %g30, 0
	addi	%g1, %g1, 96
	call	%g29
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
	ld	%g3, %g1, 84
	ld	%g4, %g3, 8
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22282
	b	beq_cont.22283
beq_else.22282:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 32
	ld	%g4, %g5, %g4
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g6, %g1, 24
	ld	%g30, %g1, 28
	mov	%g3, %g5
	mov	%g5, %g6
	st	%g31, %g1, 92
	ld	%g29, %g30, 0
	addi	%g1, %g1, 96
	call	%g29
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
	mvhi	%g3, 0
	mvlo	%g3, 3
	ld	%g4, %g1, 84
	ld	%g5, %g1, 24
	ld	%g30, %g1, 20
	st	%g31, %g1, 92
	ld	%g29, %g30, 0
	addi	%g1, %g1, 96
	call	%g29
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
beq_cont.22283:
beq_cont.22281:
	b	beq_cont.22279
beq_else.22278:
	ld	%g7, %g1, 24
	ld	%g8, %g1, 12
	ld	%g30, %g1, 16
	st	%g4, %g1, 84
	mov	%g5, %g8
	mov	%g4, %g7
	mov	%g3, %g6
	st	%g31, %g1, 92
	ld	%g29, %g30, 0
	addi	%g1, %g1, 96
	call	%g29
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22284
	b	beq_cont.22285
beq_else.22284:
	ld	%g3, %g1, 8
	fld	%f0, %g3, 0
	ld	%g3, %g1, 4
	fld	%f1, %g3, 0
	fblt	%f0, %f1, fble_else.22286
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22287
fble_else.22286:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22287:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22288
	b	beq_cont.22289
beq_else.22288:
	ld	%g3, %g1, 84
	ld	%g4, %g3, 4
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22290
	b	beq_cont.22291
beq_else.22290:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 32
	ld	%g4, %g5, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g7, %g1, 24
	ld	%g30, %g1, 28
	mov	%g5, %g7
	mov	%g3, %g6
	st	%g31, %g1, 92
	ld	%g29, %g30, 0
	addi	%g1, %g1, 96
	call	%g29
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
	ld	%g3, %g1, 84
	ld	%g4, %g3, 8
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22292
	b	beq_cont.22293
beq_else.22292:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 32
	ld	%g4, %g5, %g4
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g6, %g1, 24
	ld	%g30, %g1, 28
	mov	%g3, %g5
	mov	%g5, %g6
	st	%g31, %g1, 92
	ld	%g29, %g30, 0
	addi	%g1, %g1, 96
	call	%g29
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
	mvhi	%g3, 0
	mvlo	%g3, 3
	ld	%g4, %g1, 84
	ld	%g5, %g1, 24
	ld	%g30, %g1, 20
	st	%g31, %g1, 92
	ld	%g29, %g30, 0
	addi	%g1, %g1, 96
	call	%g29
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
beq_cont.22293:
beq_cont.22291:
beq_cont.22289:
beq_cont.22285:
beq_cont.22279:
	ld	%g3, %g1, 80
	addi	%g3, %g3, 1
	ld	%g4, %g1, 36
	ld	%g5, %g1, 24
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
solve_each_element_fast.3090:
	ld	%g6, %g30, 40
	ld	%g7, %g30, 36
	ld	%g8, %g30, 32
	ld	%g9, %g30, 28
	ld	%g10, %g30, 24
	ld	%g11, %g30, 20
	ld	%g12, %g30, 16
	ld	%g13, %g30, 12
	ld	%g14, %g30, 8
	ld	%g15, %g30, 4
	ld	%g16, %g5, 0
	slli	%g17, %g3, 2
	ld	%g17, %g4, %g17
	mvhi	%g18, 65535
	mvlo	%g18, -1
	bne	%g17, %g18, beq_else.22294
	return
beq_else.22294:
	slli	%g18, %g17, 2
	ld	%g18, %g11, %g18
	ld	%g19, %g18, 40
	fld	%f0, %g19, 0
	fld	%f1, %g19, 8
	fld	%f2, %g19, 16
	ld	%g20, %g5, 4
	slli	%g21, %g17, 2
	ld	%g20, %g20, %g21
	ld	%g21, %g18, 4
	mvhi	%g22, 0
	mvlo	%g22, 1
	st	%g12, %g1, 0
	st	%g14, %g1, 4
	st	%g13, %g1, 8
	st	%g15, %g1, 12
	st	%g7, %g1, 16
	st	%g16, %g1, 20
	st	%g6, %g1, 24
	st	%g10, %g1, 28
	st	%g5, %g1, 32
	st	%g4, %g1, 36
	st	%g30, %g1, 40
	st	%g3, %g1, 44
	st	%g11, %g1, 48
	st	%g17, %g1, 52
	bne	%g21, %g22, beq_else.22296
	ld	%g8, %g5, 0
	mov	%g5, %g20
	mov	%g4, %g8
	mov	%g3, %g18
	mov	%g30, %g9
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	b	beq_cont.22297
beq_else.22296:
	mvhi	%g9, 0
	mvlo	%g9, 2
	bne	%g21, %g9, beq_else.22298
	fld	%f0, %g20, 0
	setL %g8, l.14007
	fld	%f1, %g8, 0
	fblt	%f0, %f1, fble_else.22300
	mvhi	%g8, 0
	mvlo	%g8, 1
	b	fble_cont.22301
fble_else.22300:
	mvhi	%g8, 0
	mvlo	%g8, 0
fble_cont.22301:
	mvhi	%g9, 0
	mvlo	%g9, 0
	bne	%g8, %g9, beq_else.22302
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22303
beq_else.22302:
	fld	%f0, %g20, 0
	fld	%f1, %g19, 24
	fmul	%f0, %f0, %f1
	fst	%f0, %g10, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
beq_cont.22303:
	b	beq_cont.22299
beq_else.22298:
	mov	%g5, %g19
	mov	%g4, %g20
	mov	%g3, %g18
	mov	%g30, %g8
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
beq_cont.22299:
beq_cont.22297:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22304
	ld	%g3, %g1, 52
	slli	%g3, %g3, 2
	ld	%g4, %g1, 48
	ld	%g3, %g4, %g3
	ld	%g3, %g3, 24
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22305
	return
beq_else.22305:
	ld	%g3, %g1, 44
	addi	%g3, %g3, 1
	ld	%g4, %g1, 36
	ld	%g5, %g1, 32
	ld	%g30, %g1, 40
	ld	%g30, 0, %g29
	b	%g29
beq_else.22304:
	ld	%g4, %g1, 28
	fld	%f0, %g4, 0
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f1, %f0, fble_else.22307
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22308
fble_else.22307:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22308:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.22309
	b	beq_cont.22310
beq_else.22309:
	ld	%g4, %g1, 24
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.22311
	mvhi	%g5, 0
	mvlo	%g5, 1
	b	fble_cont.22312
fble_else.22311:
	mvhi	%g5, 0
	mvlo	%g5, 0
fble_cont.22312:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g5, %g6, beq_else.22313
	b	beq_cont.22314
beq_else.22313:
	setL %g5, l.14610
	fld	%f1, %g5, 0
	fadd	%f0, %f0, %f1
	ld	%g5, %g1, 20
	fld	%f1, %g5, 0
	fmul	%f1, %f1, %f0
	ld	%g6, %g1, 16
	fld	%f2, %g6, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g5, 8
	fmul	%f2, %f2, %f0
	fld	%f3, %g6, 8
	fadd	%f2, %f2, %f3
	fld	%f3, %g5, 16
	fmul	%f3, %f3, %f0
	fld	%f4, %g6, 16
	fadd	%f3, %f3, %f4
	ld	%g5, %g1, 36
	ld	%g6, %g5, 0
	mvhi	%g7, 65535
	mvlo	%g7, -1
	st	%g3, %g1, 56
	std	%f3, %g1, 64
	std	%f2, %g1, 72
	std	%f1, %g1, 80
	std	%f0, %g1, 88
	bne	%g6, %g7, beq_else.22316
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	beq_cont.22317
beq_else.22316:
	slli	%g6, %g6, 2
	ld	%g7, %g1, 48
	ld	%g6, %g7, %g6
	mov	%g3, %g6
	fmov	%f0, %f1
	fmov	%f1, %f2
	fmov	%f2, %f3
	st	%g31, %g1, 100
	addi	%g1, %g1, 104
	call	is_outside.3056
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22318
	mvhi	%g3, 0
	mvlo	%g3, 1
	fld	%f0, %g1, 80
	fld	%f1, %g1, 72
	fld	%f2, %g1, 64
	ld	%g4, %g1, 36
	ld	%g30, %g1, 12
	st	%g31, %g1, 100
	ld	%g29, %g30, 0
	addi	%g1, %g1, 104
	call	%g29
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	b	beq_cont.22319
beq_else.22318:
	mvhi	%g3, 0
	mvlo	%g3, 0
beq_cont.22319:
beq_cont.22317:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22320
	b	beq_cont.22321
beq_else.22320:
	ld	%g3, %g1, 24
	fld	%f0, %g1, 88
	fst	%f0, %g3, 0
	ld	%g3, %g1, 8
	fld	%f0, %g1, 80
	fst	%f0, %g3, 0
	fld	%f0, %g1, 72
	fst	%f0, %g3, 8
	fld	%f0, %g1, 64
	fst	%f0, %g3, 16
	ld	%g3, %g1, 4
	ld	%g4, %g1, 52
	st	%g4, %g3, 0
	ld	%g3, %g1, 0
	ld	%g4, %g1, 56
	st	%g4, %g3, 0
beq_cont.22321:
beq_cont.22314:
beq_cont.22310:
	ld	%g3, %g1, 44
	addi	%g3, %g3, 1
	ld	%g4, %g1, 36
	ld	%g5, %g1, 32
	ld	%g30, %g1, 40
	ld	%g30, 0, %g29
	b	%g29
solve_one_or_network_fast.3094:
	ld	%g6, %g30, 8
	ld	%g7, %g30, 4
	slli	%g8, %g3, 2
	ld	%g8, %g4, %g8
	mvhi	%g9, 65535
	mvlo	%g9, -1
	bne	%g8, %g9, beq_else.22322
	return
beq_else.22322:
	slli	%g8, %g8, 2
	ld	%g8, %g7, %g8
	mvhi	%g9, 0
	mvlo	%g9, 0
	st	%g30, %g1, 0
	st	%g5, %g1, 4
	st	%g6, %g1, 8
	st	%g7, %g1, 12
	st	%g4, %g1, 16
	st	%g3, %g1, 20
	mov	%g4, %g8
	mov	%g3, %g9
	mov	%g30, %g6
	st	%g31, %g1, 28
	ld	%g29, %g30, 0
	addi	%g1, %g1, 32
	call	%g29
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 20
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	ld	%g4, %g5, %g4
	mvhi	%g6, 65535
	mvlo	%g6, -1
	bne	%g4, %g6, beq_else.22324
	return
beq_else.22324:
	slli	%g4, %g4, 2
	ld	%g6, %g1, 12
	ld	%g4, %g6, %g4
	mvhi	%g7, 0
	mvlo	%g7, 0
	ld	%g8, %g1, 4
	ld	%g30, %g1, 8
	st	%g3, %g1, 24
	mov	%g5, %g8
	mov	%g3, %g7
	st	%g31, %g1, 28
	ld	%g29, %g30, 0
	addi	%g1, %g1, 32
	call	%g29
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 24
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	ld	%g4, %g5, %g4
	mvhi	%g6, 65535
	mvlo	%g6, -1
	bne	%g4, %g6, beq_else.22326
	return
beq_else.22326:
	slli	%g4, %g4, 2
	ld	%g6, %g1, 12
	ld	%g4, %g6, %g4
	mvhi	%g7, 0
	mvlo	%g7, 0
	ld	%g8, %g1, 4
	ld	%g30, %g1, 8
	st	%g3, %g1, 28
	mov	%g5, %g8
	mov	%g3, %g7
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	ld	%g4, %g5, %g4
	mvhi	%g6, 65535
	mvlo	%g6, -1
	bne	%g4, %g6, beq_else.22328
	return
beq_else.22328:
	slli	%g4, %g4, 2
	ld	%g6, %g1, 12
	ld	%g4, %g6, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g7, %g1, 4
	ld	%g30, %g1, 8
	st	%g3, %g1, 32
	mov	%g5, %g7
	mov	%g3, %g6
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 32
	addi	%g3, %g3, 1
	ld	%g4, %g1, 16
	ld	%g5, %g1, 4
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
trace_or_matrix_fast.3098:
	ld	%g6, %g30, 36
	ld	%g7, %g30, 32
	ld	%g8, %g30, 28
	ld	%g9, %g30, 24
	ld	%g10, %g30, 20
	ld	%g11, %g30, 16
	ld	%g12, %g30, 12
	ld	%g13, %g30, 8
	ld	%g14, %g30, 4
	slli	%g15, %g3, 2
	ld	%g15, %g4, %g15
	ld	%g16, %g15, 0
	mvhi	%g17, 65535
	mvlo	%g17, -1
	bne	%g16, %g17, beq_else.22330
	return
beq_else.22330:
	mvhi	%g17, 0
	mvlo	%g17, 99
	st	%g30, %g1, 0
	st	%g6, %g1, 4
	st	%g10, %g1, 8
	st	%g9, %g1, 12
	st	%g11, %g1, 16
	st	%g5, %g1, 20
	st	%g12, %g1, 24
	st	%g14, %g1, 28
	st	%g4, %g1, 32
	st	%g3, %g1, 36
	bne	%g16, %g17, beq_else.22332
	ld	%g7, %g15, 4
	mvhi	%g8, 65535
	mvlo	%g8, -1
	bne	%g7, %g8, beq_else.22334
	b	beq_cont.22335
beq_else.22334:
	slli	%g7, %g7, 2
	ld	%g7, %g14, %g7
	mvhi	%g8, 0
	mvlo	%g8, 0
	st	%g15, %g1, 40
	mov	%g4, %g7
	mov	%g3, %g8
	mov	%g30, %g12
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 40
	ld	%g4, %g3, 8
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22336
	b	beq_cont.22337
beq_else.22336:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 28
	ld	%g4, %g5, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g7, %g1, 20
	ld	%g30, %g1, 24
	mov	%g5, %g7
	mov	%g3, %g6
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 40
	ld	%g4, %g3, 12
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22338
	b	beq_cont.22339
beq_else.22338:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 28
	ld	%g4, %g5, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g7, %g1, 20
	ld	%g30, %g1, 24
	mov	%g5, %g7
	mov	%g3, %g6
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 40
	ld	%g5, %g1, 20
	ld	%g30, %g1, 16
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
beq_cont.22339:
beq_cont.22337:
beq_cont.22335:
	b	beq_cont.22333
beq_else.22332:
	slli	%g17, %g16, 2
	ld	%g13, %g13, %g17
	ld	%g17, %g13, 40
	fld	%f0, %g17, 0
	fld	%f1, %g17, 8
	fld	%f2, %g17, 16
	ld	%g18, %g5, 4
	slli	%g16, %g16, 2
	ld	%g16, %g18, %g16
	ld	%g18, %g13, 4
	mvhi	%g19, 0
	mvlo	%g19, 1
	st	%g15, %g1, 40
	bne	%g18, %g19, beq_else.22340
	ld	%g7, %g5, 0
	mov	%g5, %g16
	mov	%g4, %g7
	mov	%g3, %g13
	mov	%g30, %g8
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	b	beq_cont.22341
beq_else.22340:
	mvhi	%g8, 0
	mvlo	%g8, 2
	bne	%g18, %g8, beq_else.22342
	fld	%f0, %g16, 0
	setL %g7, l.14007
	fld	%f1, %g7, 0
	fblt	%f0, %f1, fble_else.22344
	mvhi	%g7, 0
	mvlo	%g7, 1
	b	fble_cont.22345
fble_else.22344:
	mvhi	%g7, 0
	mvlo	%g7, 0
fble_cont.22345:
	mvhi	%g8, 0
	mvlo	%g8, 0
	bne	%g7, %g8, beq_else.22346
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22347
beq_else.22346:
	fld	%f0, %g16, 0
	fld	%f1, %g17, 24
	fmul	%f0, %f0, %f1
	fst	%f0, %g10, 0
	mvhi	%g3, 0
	mvlo	%g3, 1
beq_cont.22347:
	b	beq_cont.22343
beq_else.22342:
	mov	%g5, %g17
	mov	%g4, %g16
	mov	%g3, %g13
	mov	%g30, %g7
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
beq_cont.22343:
beq_cont.22341:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22348
	b	beq_cont.22349
beq_else.22348:
	ld	%g3, %g1, 8
	fld	%f0, %g3, 0
	ld	%g4, %g1, 4
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.22350
	mvhi	%g5, 0
	mvlo	%g5, 1
	b	fble_cont.22351
fble_else.22350:
	mvhi	%g5, 0
	mvlo	%g5, 0
fble_cont.22351:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g5, %g6, beq_else.22352
	b	beq_cont.22353
beq_else.22352:
	ld	%g5, %g1, 40
	ld	%g6, %g5, 4
	mvhi	%g7, 65535
	mvlo	%g7, -1
	bne	%g6, %g7, beq_else.22354
	b	beq_cont.22355
beq_else.22354:
	slli	%g6, %g6, 2
	ld	%g7, %g1, 28
	ld	%g6, %g7, %g6
	mvhi	%g8, 0
	mvlo	%g8, 0
	ld	%g9, %g1, 20
	ld	%g30, %g1, 24
	mov	%g5, %g9
	mov	%g4, %g6
	mov	%g3, %g8
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 40
	ld	%g4, %g3, 8
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22356
	b	beq_cont.22357
beq_else.22356:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 28
	ld	%g4, %g5, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g7, %g1, 20
	ld	%g30, %g1, 24
	mov	%g5, %g7
	mov	%g3, %g6
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 40
	ld	%g4, %g3, 12
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22358
	b	beq_cont.22359
beq_else.22358:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 28
	ld	%g4, %g5, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g7, %g1, 20
	ld	%g30, %g1, 24
	mov	%g5, %g7
	mov	%g3, %g6
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 40
	ld	%g5, %g1, 20
	ld	%g30, %g1, 16
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
beq_cont.22359:
beq_cont.22357:
beq_cont.22355:
beq_cont.22353:
beq_cont.22349:
beq_cont.22333:
	ld	%g3, %g1, 36
	addi	%g3, %g3, 1
	slli	%g4, %g3, 2
	ld	%g5, %g1, 32
	ld	%g4, %g5, %g4
	ld	%g6, %g4, 0
	mvhi	%g7, 65535
	mvlo	%g7, -1
	bne	%g6, %g7, beq_else.22360
	return
beq_else.22360:
	mvhi	%g7, 0
	mvlo	%g7, 99
	st	%g3, %g1, 44
	bne	%g6, %g7, beq_else.22362
	ld	%g6, %g4, 4
	mvhi	%g7, 65535
	mvlo	%g7, -1
	bne	%g6, %g7, beq_else.22364
	b	beq_cont.22365
beq_else.22364:
	slli	%g6, %g6, 2
	ld	%g7, %g1, 28
	ld	%g6, %g7, %g6
	mvhi	%g8, 0
	mvlo	%g8, 0
	ld	%g9, %g1, 20
	ld	%g30, %g1, 24
	st	%g4, %g1, 48
	mov	%g5, %g9
	mov	%g4, %g6
	mov	%g3, %g8
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 48
	ld	%g4, %g3, 8
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22366
	b	beq_cont.22367
beq_else.22366:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 28
	ld	%g4, %g5, %g4
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g6, %g1, 20
	ld	%g30, %g1, 24
	mov	%g3, %g5
	mov	%g5, %g6
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g3, 0
	mvlo	%g3, 3
	ld	%g4, %g1, 48
	ld	%g5, %g1, 20
	ld	%g30, %g1, 16
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
beq_cont.22367:
beq_cont.22365:
	b	beq_cont.22363
beq_else.22362:
	ld	%g7, %g1, 20
	ld	%g30, %g1, 12
	st	%g4, %g1, 48
	mov	%g4, %g7
	mov	%g3, %g6
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22368
	b	beq_cont.22369
beq_else.22368:
	ld	%g3, %g1, 8
	fld	%f0, %g3, 0
	ld	%g3, %g1, 4
	fld	%f1, %g3, 0
	fblt	%f0, %f1, fble_else.22370
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22371
fble_else.22370:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22371:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22372
	b	beq_cont.22373
beq_else.22372:
	ld	%g3, %g1, 48
	ld	%g4, %g3, 4
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22374
	b	beq_cont.22375
beq_else.22374:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 28
	ld	%g4, %g5, %g4
	mvhi	%g6, 0
	mvlo	%g6, 0
	ld	%g7, %g1, 20
	ld	%g30, %g1, 24
	mov	%g5, %g7
	mov	%g3, %g6
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 48
	ld	%g4, %g3, 8
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22376
	b	beq_cont.22377
beq_else.22376:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 28
	ld	%g4, %g5, %g4
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g6, %g1, 20
	ld	%g30, %g1, 24
	mov	%g3, %g5
	mov	%g5, %g6
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g3, 0
	mvlo	%g3, 3
	ld	%g4, %g1, 48
	ld	%g5, %g1, 20
	ld	%g30, %g1, 16
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
beq_cont.22377:
beq_cont.22375:
beq_cont.22373:
beq_cont.22369:
beq_cont.22363:
	ld	%g3, %g1, 44
	addi	%g3, %g3, 1
	ld	%g4, %g1, 32
	ld	%g5, %g1, 20
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
judge_intersection_fast.3102:
	ld	%g4, %g30, 32
	ld	%g5, %g30, 28
	ld	%g6, %g30, 24
	ld	%g7, %g30, 20
	ld	%g8, %g30, 16
	ld	%g9, %g30, 12
	ld	%g10, %g30, 8
	ld	%g11, %g30, 4
	setL %g12, l.14806
	fld	%f0, %g12, 0
	fst	%f0, %g5, 0
	ld	%g10, %g10, 0
	ld	%g12, %g10, 0
	ld	%g13, %g12, 0
	mvhi	%g14, 65535
	mvlo	%g14, -1
	st	%g5, %g1, 0
	bne	%g13, %g14, beq_else.22378
	b	beq_cont.22379
beq_else.22378:
	mvhi	%g14, 0
	mvlo	%g14, 99
	st	%g3, %g1, 4
	st	%g10, %g1, 8
	st	%g4, %g1, 12
	bne	%g13, %g14, beq_else.22380
	ld	%g6, %g12, 4
	mvhi	%g7, 65535
	mvlo	%g7, -1
	bne	%g6, %g7, beq_else.22382
	b	beq_cont.22383
beq_else.22382:
	slli	%g6, %g6, 2
	ld	%g6, %g11, %g6
	mvhi	%g7, 0
	mvlo	%g7, 0
	st	%g8, %g1, 16
	st	%g9, %g1, 20
	st	%g11, %g1, 24
	st	%g12, %g1, 28
	mov	%g5, %g3
	mov	%g4, %g6
	mov	%g30, %g9
	mov	%g3, %g7
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	ld	%g4, %g3, 8
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22384
	b	beq_cont.22385
beq_else.22384:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 24
	ld	%g4, %g5, %g4
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g6, %g1, 4
	ld	%g30, %g1, 20
	mov	%g3, %g5
	mov	%g5, %g6
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g3, 0
	mvlo	%g3, 3
	ld	%g4, %g1, 28
	ld	%g5, %g1, 4
	ld	%g30, %g1, 16
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
beq_cont.22385:
beq_cont.22383:
	b	beq_cont.22381
beq_else.22380:
	st	%g8, %g1, 16
	st	%g9, %g1, 20
	st	%g11, %g1, 24
	st	%g12, %g1, 28
	st	%g7, %g1, 32
	mov	%g4, %g3
	mov	%g30, %g6
	mov	%g3, %g13
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22386
	b	beq_cont.22387
beq_else.22386:
	ld	%g3, %g1, 32
	fld	%f0, %g3, 0
	ld	%g3, %g1, 0
	fld	%f1, %g3, 0
	fblt	%f0, %f1, fble_else.22388
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22389
fble_else.22388:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22389:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.22390
	b	beq_cont.22391
beq_else.22390:
	ld	%g4, %g1, 28
	ld	%g5, %g4, 4
	mvhi	%g6, 65535
	mvlo	%g6, -1
	bne	%g5, %g6, beq_else.22392
	b	beq_cont.22393
beq_else.22392:
	slli	%g5, %g5, 2
	ld	%g6, %g1, 24
	ld	%g5, %g6, %g5
	mvhi	%g7, 0
	mvlo	%g7, 0
	ld	%g8, %g1, 4
	ld	%g30, %g1, 20
	mov	%g4, %g5
	mov	%g3, %g7
	mov	%g5, %g8
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 28
	ld	%g4, %g3, 8
	mvhi	%g5, 65535
	mvlo	%g5, -1
	bne	%g4, %g5, beq_else.22394
	b	beq_cont.22395
beq_else.22394:
	slli	%g4, %g4, 2
	ld	%g5, %g1, 24
	ld	%g4, %g5, %g4
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g6, %g1, 4
	ld	%g30, %g1, 20
	mov	%g3, %g5
	mov	%g5, %g6
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g3, 0
	mvlo	%g3, 3
	ld	%g4, %g1, 28
	ld	%g5, %g1, 4
	ld	%g30, %g1, 16
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
beq_cont.22395:
beq_cont.22393:
beq_cont.22391:
beq_cont.22387:
beq_cont.22381:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 8
	ld	%g5, %g1, 4
	ld	%g30, %g1, 12
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
beq_cont.22379:
	ld	%g3, %g1, 0
	fld	%f0, %g3, 0
	setL %g3, l.14646
	fld	%f1, %g3, 0
	fblt	%f1, %f0, fble_else.22396
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22397
fble_else.22396:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22397:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22398
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
beq_else.22398:
	setL %g3, l.14824
	fld	%f1, %g3, 0
	fbg	%f1, %f0, fble_else.22399
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
fble_else.22399:
	mvhi	%g3, 0
	mvlo	%g3, 1
	return
get_nvector_second.3108:
	ld	%g4, %g30, 8
	ld	%g5, %g30, 4
	fld	%f0, %g5, 0
	ld	%g6, %g3, 20
	fld	%f1, %g6, 0
	fsub	%f0, %f0, %f1
	fld	%f1, %g5, 8
	ld	%g6, %g3, 20
	fld	%f2, %g6, 8
	fsub	%f1, %f1, %f2
	fld	%f2, %g5, 16
	ld	%g5, %g3, 20
	fld	%f3, %g5, 16
	fsub	%f2, %f2, %f3
	ld	%g5, %g3, 16
	fld	%f3, %g5, 0
	fmul	%f3, %f0, %f3
	ld	%g5, %g3, 16
	fld	%f4, %g5, 8
	fmul	%f4, %f1, %f4
	ld	%g5, %g3, 16
	fld	%f5, %g5, 16
	fmul	%f5, %f2, %f5
	ld	%g5, %g3, 12
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g5, %g6, beq_else.22400
	fst	%f3, %g4, 0
	fst	%f4, %g4, 8
	fst	%f5, %g4, 16
	b	beq_cont.22401
beq_else.22400:
	ld	%g5, %g3, 36
	fld	%f6, %g5, 16
	fmul	%f6, %f1, %f6
	ld	%g5, %g3, 36
	fld	%f7, %g5, 8
	fmul	%f7, %f2, %f7
	fadd	%f6, %f6, %f7
	setL %g5, l.14068
	fld	%f7, %g5, 0
	fdiv	%f6, %f6, %f7
	fadd	%f3, %f3, %f6
	fst	%f3, %g4, 0
	ld	%g5, %g3, 36
	fld	%f3, %g5, 16
	fmul	%f3, %f0, %f3
	ld	%g5, %g3, 36
	fld	%f6, %g5, 0
	fmul	%f2, %f2, %f6
	fadd	%f2, %f3, %f2
	setL %g5, l.14068
	fld	%f3, %g5, 0
	fdiv	%f2, %f2, %f3
	fadd	%f2, %f4, %f2
	fst	%f2, %g4, 8
	ld	%g5, %g3, 36
	fld	%f2, %g5, 8
	fmul	%f0, %f0, %f2
	ld	%g5, %g3, 36
	fld	%f2, %g5, 0
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	setL %g5, l.14068
	fld	%f1, %g5, 0
	fdiv	%f0, %f0, %f1
	fadd	%f0, %f5, %f0
	fst	%f0, %g4, 16
beq_cont.22401:
	ld	%g3, %g3, 24
	mov	%g29, %g4
	mov	%g4, %g3
	mov	%g3, %g29
	jmp	vecunit_sgn.2816
get_nvector.3110:
	ld	%g5, %g30, 12
	ld	%g6, %g30, 8
	ld	%g30, %g30, 4
	ld	%g7, %g3, 4
	mvhi	%g8, 0
	mvlo	%g8, 1
	bne	%g7, %g8, beq_else.22402
	ld	%g3, %g6, 0
	setL %g6, l.14007
	fld	%f0, %g6, 0
	fst	%f0, %g5, 0
	fst	%f0, %g5, 8
	fst	%f0, %g5, 16
	subi	%g6, %g3, 1
	subi	%g3, %g3, 1
	slli	%g3, %g3, 3
	fld	%f0, %g4, %g3
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fbne	%f0, %f1, fbe_else.22403
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fbe_cont.22404
fbe_else.22403:
	mvhi	%g3, 0
	mvlo	%g3, 0
fbe_cont.22404:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22405
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fblt	%f1, %f0, fble_else.22407
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22408
fble_else.22407:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22408:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22409
	setL %g3, l.14131
	fld	%f0, %g3, 0
	b	beq_cont.22410
beq_else.22409:
	setL %g3, l.14053
	fld	%f0, %g3, 0
beq_cont.22410:
	b	beq_cont.22406
beq_else.22405:
	setL %g3, l.14007
	fld	%f0, %g3, 0
beq_cont.22406:
	fneg	%f0, %f0
	slli	%g3, %g6, 3
	fst	%f0, %g5, %g3
	return
beq_else.22402:
	mvhi	%g4, 0
	mvlo	%g4, 2
	bne	%g7, %g4, beq_else.22412
	ld	%g4, %g3, 16
	fld	%f0, %g4, 0
	fneg	%f0, %f0
	fst	%f0, %g5, 0
	ld	%g4, %g3, 16
	fld	%f0, %g4, 8
	fneg	%f0, %f0
	fst	%f0, %g5, 8
	ld	%g3, %g3, 16
	fld	%f0, %g3, 16
	fneg	%f0, %f0
	fst	%f0, %g5, 16
	return
beq_else.22412:
	ld	%g30, 0, %g29
	b	%g29
utexture.3113:
	ld	%g5, %g30, 52
	ld	%g6, %g30, 48
	fld	%f0, %g30, 40
	fld	%f1, %g30, 32
	fld	%f2, %g30, 24
	ld	%g7, %g30, 16
	ld	%g8, %g30, 12
	ld	%g9, %g30, 8
	ld	%g10, %g30, 4
	ld	%g11, %g3, 0
	ld	%g12, %g3, 32
	fld	%f3, %g12, 0
	fst	%f3, %g5, 0
	ld	%g12, %g3, 32
	fld	%f3, %g12, 8
	fst	%f3, %g5, 8
	ld	%g12, %g3, 32
	fld	%f3, %g12, 16
	fst	%f3, %g5, 16
	mvhi	%g12, 0
	mvlo	%g12, 1
	bne	%g11, %g12, beq_else.22414
	fld	%f0, %g4, 0
	ld	%g6, %g3, 20
	fld	%f1, %g6, 0
	fsub	%f0, %f0, %f1
	setL %g6, l.14934
	fld	%f1, %g6, 0
	fmul	%f1, %f0, %f1
	st	%g5, %g1, 0
	st	%g3, %g1, 4
	st	%g4, %g1, 8
	std	%f0, %g1, 16
	fmov	%f0, %f1
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	min_caml_floor
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	setL %g3, l.14936
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 16
	fsub	%f0, %f1, %f0
	setL %g3, l.14914
	fld	%f1, %g3, 0
	fblt	%f0, %f1, fble_else.22416
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22417
fble_else.22416:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22417:
	ld	%g4, %g1, 8
	fld	%f0, %g4, 16
	ld	%g4, %g1, 4
	ld	%g4, %g4, 20
	fld	%f1, %g4, 16
	fsub	%f0, %f0, %f1
	setL %g4, l.14934
	fld	%f1, %g4, 0
	fmul	%f1, %f0, %f1
	st	%g3, %g1, 24
	std	%f0, %g1, 32
	fmov	%f0, %f1
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	min_caml_floor
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	setL %g3, l.14936
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 32
	fsub	%f0, %f1, %f0
	setL %g3, l.14914
	fld	%f1, %g3, 0
	fblt	%f0, %f1, fble_else.22419
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22420
fble_else.22419:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22420:
	mvhi	%g4, 0
	mvlo	%g4, 0
	ld	%g5, %g1, 24
	bne	%g5, %g4, beq_else.22421
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22423
	setL %g3, l.14905
	fld	%f0, %g3, 0
	b	beq_cont.22424
beq_else.22423:
	setL %g3, l.14007
	fld	%f0, %g3, 0
beq_cont.22424:
	b	beq_cont.22422
beq_else.22421:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22425
	setL %g3, l.14007
	fld	%f0, %g3, 0
	b	beq_cont.22426
beq_else.22425:
	setL %g3, l.14905
	fld	%f0, %g3, 0
beq_cont.22426:
beq_cont.22422:
	ld	%g3, %g1, 0
	fst	%f0, %g3, 8
	return
beq_else.22414:
	mvhi	%g12, 0
	mvlo	%g12, 2
	bne	%g11, %g12, beq_else.22428
	fld	%f3, %g4, 8
	setL %g3, l.14924
	fld	%f4, %g3, 0
	fmul	%f3, %f3, %f4
	setL %g3, l.14007
	fld	%f4, %g3, 0
	st	%g5, %g1, 0
	fblt	%f3, %f4, fble_else.22429
	fneg	%f0, %f3
	mov	%g30, %g6
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fneg	%f0, %f0
	b	fble_cont.22430
fble_else.22429:
	fblt	%f3, %f0, fble_else.22431
	mov	%g30, %g8
	fmov	%f0, %f3
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	b	fble_cont.22432
fble_else.22431:
	fblt	%f3, %f2, fble_else.22433
	fsub	%f0, %f2, %f3
	mov	%g30, %g8
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	b	fble_cont.22434
fble_else.22433:
	fblt	%f3, %f1, fble_else.22435
	fsub	%f0, %f1, %f3
	mov	%g30, %g6
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	fneg	%f0, %f0
	b	fble_cont.22436
fble_else.22435:
	fsub	%f0, %f3, %f1
	mov	%g30, %g6
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
fble_cont.22436:
fble_cont.22434:
fble_cont.22432:
fble_cont.22430:
	fmul	%f0, %f0, %f0
	setL %g3, l.14905
	fld	%f1, %g3, 0
	fmul	%f1, %f1, %f0
	ld	%g3, %g1, 0
	fst	%f1, %g3, 0
	setL %g4, l.14905
	fld	%f1, %g4, 0
	setL %g4, l.14053
	fld	%f2, %g4, 0
	fsub	%f0, %f2, %f0
	fmul	%f0, %f1, %f0
	fst	%f0, %g3, 8
	return
beq_else.22428:
	mvhi	%g6, 0
	mvlo	%g6, 3
	bne	%g11, %g6, beq_else.22438
	fld	%f3, %g4, 0
	ld	%g6, %g3, 20
	fld	%f4, %g6, 0
	fsub	%f3, %f3, %f4
	fld	%f4, %g4, 16
	ld	%g3, %g3, 20
	fld	%f5, %g3, 16
	fsub	%f4, %f4, %f5
	fmul	%f3, %f3, %f3
	fmul	%f4, %f4, %f4
	fadd	%f3, %f3, %f4
	st	%g5, %g1, 0
	st	%g9, %g1, 40
	st	%g7, %g1, 44
	std	%f1, %g1, 48
	std	%f2, %g1, 56
	std	%f0, %g1, 64
	fmov	%f0, %f3
	st	%g31, %g1, 76
	addi	%g1, %g1, 80
	call	sqrt.2751
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	setL %g3, l.14914
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	std	%f0, %g1, 72
	st	%g31, %g1, 84
	addi	%g1, %g1, 88
	call	min_caml_floor
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fld	%f1, %g1, 72
	fsub	%f0, %f1, %f0
	setL %g3, l.14888
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fblt	%f0, %f1, fble_else.22439
	fneg	%f0, %f0
	ld	%g30, %g1, 44
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	b	fble_cont.22440
fble_else.22439:
	fld	%f1, %g1, 64
	fblt	%f0, %f1, fble_else.22441
	ld	%g30, %g1, 40
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	b	fble_cont.22442
fble_else.22441:
	fld	%f1, %g1, 56
	fblt	%f0, %f1, fble_else.22443
	fsub	%f0, %f1, %f0
	ld	%g30, %g1, 40
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	fneg	%f0, %f0
	b	fble_cont.22444
fble_else.22443:
	fld	%f1, %g1, 48
	fblt	%f0, %f1, fble_else.22445
	fsub	%f0, %f1, %f0
	ld	%g30, %g1, 44
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	b	fble_cont.22446
fble_else.22445:
	fsub	%f0, %f0, %f1
	ld	%g30, %g1, 44
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
fble_cont.22446:
fble_cont.22444:
fble_cont.22442:
fble_cont.22440:
	fmul	%f0, %f0, %f0
	setL %g3, l.14905
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f1, %g3, 8
	setL %g4, l.14053
	fld	%f1, %g4, 0
	fsub	%f0, %f1, %f0
	setL %g4, l.14905
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fst	%f0, %g3, 16
	return
beq_else.22438:
	mvhi	%g6, 0
	mvlo	%g6, 4
	bne	%g11, %g6, beq_else.22448
	fld	%f0, %g4, 0
	ld	%g6, %g3, 20
	fld	%f1, %g6, 0
	fsub	%f0, %f0, %f1
	ld	%g6, %g3, 16
	fld	%f1, %g6, 0
	st	%g5, %g1, 0
	st	%g10, %g1, 80
	st	%g3, %g1, 4
	st	%g4, %g1, 8
	std	%f0, %g1, 88
	fmov	%f0, %f1
	st	%g31, %g1, 100
	addi	%g1, %g1, 104
	call	sqrt.2751
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	fld	%f1, %g1, 88
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fld	%f1, %g3, 16
	ld	%g4, %g1, 4
	ld	%g5, %g4, 20
	fld	%f2, %g5, 16
	fsub	%f1, %f1, %f2
	ld	%g5, %g4, 16
	fld	%f2, %g5, 16
	std	%f0, %g1, 96
	std	%f1, %g1, 104
	fmov	%f0, %f2
	st	%g31, %g1, 116
	addi	%g1, %g1, 120
	call	sqrt.2751
	subi	%g1, %g1, 120
	ld	%g31, %g1, 116
	fld	%f1, %g1, 104
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 96
	fmul	%f2, %f1, %f1
	fmul	%f3, %f0, %f0
	fadd	%f2, %f2, %f3
	setL %g3, l.14007
	fld	%f3, %g3, 0
	fblt	%f1, %f3, fble_else.22450
	fneg	%f3, %f1
	b	fble_cont.22451
fble_else.22450:
	fmov	%f3, %f1
fble_cont.22451:
	setL %g3, l.14881
	fld	%f4, %g3, 0
	fblt	%f3, %f4, fble_else.22452
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22453
fble_else.22452:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22453:
	mvhi	%g4, 0
	mvlo	%g4, 0
	std	%f2, %g1, 112
	bne	%g3, %g4, beq_else.22454
	fdiv	%f0, %f0, %f1
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fblt	%f0, %f1, fble_else.22456
	fneg	%f0, %f0
	b	fble_cont.22457
fble_else.22456:
fble_cont.22457:
	ld	%g30, %g1, 80
	st	%g31, %g1, 124
	ld	%g29, %g30, 0
	addi	%g1, %g1, 128
	call	%g29
	subi	%g1, %g1, 128
	ld	%g31, %g1, 124
	setL %g3, l.14886
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.14888
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	b	beq_cont.22455
beq_else.22454:
	setL %g3, l.14883
	fld	%f0, %g3, 0
beq_cont.22455:
	std	%f0, %g1, 120
	st	%g31, %g1, 132
	addi	%g1, %g1, 136
	call	min_caml_floor
	subi	%g1, %g1, 136
	ld	%g31, %g1, 132
	fld	%f1, %g1, 120
	fsub	%f0, %f1, %f0
	ld	%g3, %g1, 8
	fld	%f1, %g3, 8
	ld	%g3, %g1, 4
	ld	%g4, %g3, 20
	fld	%f2, %g4, 8
	fsub	%f1, %f1, %f2
	ld	%g3, %g3, 16
	fld	%f2, %g3, 8
	std	%f0, %g1, 128
	std	%f1, %g1, 136
	fmov	%f0, %f2
	st	%g31, %g1, 148
	addi	%g1, %g1, 152
	call	sqrt.2751
	subi	%g1, %g1, 152
	ld	%g31, %g1, 148
	fld	%f1, %g1, 136
	fmul	%f0, %f1, %f0
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fld	%f2, %g1, 112
	fblt	%f2, %f1, fble_else.22458
	fneg	%f1, %f2
	b	fble_cont.22459
fble_else.22458:
	fmov	%f1, %f2
fble_cont.22459:
	setL %g3, l.14881
	fld	%f3, %g3, 0
	fblt	%f1, %f3, fble_else.22460
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22461
fble_else.22460:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22461:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22462
	fdiv	%f0, %f0, %f2
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fblt	%f0, %f1, fble_else.22464
	fneg	%f0, %f0
	b	fble_cont.22465
fble_else.22464:
fble_cont.22465:
	ld	%g30, %g1, 80
	st	%g31, %g1, 148
	ld	%g29, %g30, 0
	addi	%g1, %g1, 152
	call	%g29
	subi	%g1, %g1, 152
	ld	%g31, %g1, 148
	setL %g3, l.14886
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.14888
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	b	beq_cont.22463
beq_else.22462:
	setL %g3, l.14883
	fld	%f0, %g3, 0
beq_cont.22463:
	std	%f0, %g1, 144
	st	%g31, %g1, 156
	addi	%g1, %g1, 160
	call	min_caml_floor
	subi	%g1, %g1, 160
	ld	%g31, %g1, 156
	fld	%f1, %g1, 144
	fsub	%f0, %f1, %f0
	setL %g3, l.14899
	fld	%f1, %g3, 0
	setL %g3, l.13995
	fld	%f2, %g3, 0
	fld	%f3, %g1, 128
	fsub	%f2, %f2, %f3
	fmul	%f2, %f2, %f2
	fsub	%f1, %f1, %f2
	setL %g3, l.13995
	fld	%f2, %g3, 0
	fsub	%f0, %f2, %f0
	fmul	%f0, %f0, %f0
	fsub	%f0, %f1, %f0
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fblt	%f0, %f1, fble_else.22466
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22467
fble_else.22466:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22467:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22468
	b	beq_cont.22469
beq_else.22468:
	setL %g3, l.14007
	fld	%f0, %g3, 0
beq_cont.22469:
	setL %g3, l.14905
	fld	%f1, %g3, 0
	fmul	%f0, %f1, %f0
	setL %g3, l.14907
	fld	%f1, %g3, 0
	fdiv	%f0, %f0, %f1
	ld	%g3, %g1, 0
	fst	%f0, %g3, 16
	return
beq_else.22448:
	return
trace_reflections.3120:
	ld	%g5, %g30, 40
	ld	%g6, %g30, 36
	ld	%g7, %g30, 32
	ld	%g8, %g30, 28
	ld	%g9, %g30, 24
	ld	%g10, %g30, 20
	ld	%g11, %g30, 16
	ld	%g12, %g30, 12
	ld	%g13, %g30, 8
	ld	%g14, %g30, 4
	mvhi	%g15, 0
	mvlo	%g15, 0
	blt	%g3, %g15, ble_else.22472
	slli	%g15, %g3, 2
	ld	%g10, %g10, %g15
	ld	%g15, %g10, 4
	setL %g16, l.14806
	fld	%f2, %g16, 0
	fst	%f2, %g6, 0
	mvhi	%g16, 0
	mvlo	%g16, 0
	ld	%g17, %g11, 0
	st	%g30, %g1, 0
	st	%g3, %g1, 4
	std	%f1, %g1, 8
	st	%g7, %g1, 16
	st	%g9, %g1, 20
	st	%g4, %g1, 24
	std	%f0, %g1, 32
	st	%g12, %g1, 40
	st	%g15, %g1, 44
	st	%g8, %g1, 48
	st	%g11, %g1, 52
	st	%g10, %g1, 56
	st	%g13, %g1, 60
	st	%g14, %g1, 64
	st	%g6, %g1, 68
	mov	%g4, %g17
	mov	%g3, %g16
	mov	%g30, %g5
	mov	%g5, %g15
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g3, %g1, 68
	fld	%f0, %g3, 0
	setL %g3, l.14646
	fld	%f1, %g3, 0
	fblt	%f1, %f0, fble_else.22474
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22475
fble_else.22474:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22475:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22476
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22477
beq_else.22476:
	setL %g3, l.14824
	fld	%f1, %g3, 0
	fblt	%f0, %f1, fble_else.22478
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22479
fble_else.22478:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22479:
beq_cont.22477:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22480
	b	beq_cont.22481
beq_else.22480:
	ld	%g3, %g1, 64
	ld	%g3, %g3, 0
	slli	%g3, %g3, 2
	ld	%g4, %g1, 60
	ld	%g4, %g4, 0
	add	%g3, %g3, %g4
	ld	%g4, %g1, 56
	ld	%g5, %g4, 0
	bne	%g3, %g5, beq_else.22482
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g5, %g1, 52
	ld	%g5, %g5, 0
	ld	%g30, %g1, 48
	mov	%g4, %g5
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22484
	ld	%g3, %g1, 44
	ld	%g4, %g3, 0
	ld	%g5, %g1, 40
	fld	%f0, %g5, 0
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g5, 8
	fld	%f2, %g4, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g5, 16
	fld	%f2, %g4, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	ld	%g4, %g1, 56
	fld	%f1, %g4, 8
	fld	%f2, %g1, 32
	fmul	%f3, %f1, %f2
	fmul	%f0, %f3, %f0
	ld	%g3, %g3, 0
	ld	%g4, %g1, 24
	fld	%f3, %g4, 0
	fld	%f4, %g3, 0
	fmul	%f3, %f3, %f4
	fld	%f4, %g4, 8
	fld	%f5, %g3, 8
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	fld	%f4, %g4, 16
	fld	%f5, %g3, 16
	fmul	%f4, %f4, %f5
	fadd	%f3, %f3, %f4
	fmul	%f1, %f1, %f3
	setL %g3, l.14007
	fld	%f3, %g3, 0
	fblt	%f3, %f0, fble_else.22486
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22487
fble_else.22486:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22487:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g3, %g5, beq_else.22488
	b	beq_cont.22489
beq_else.22488:
	ld	%g3, %g1, 20
	fld	%f3, %g3, 0
	ld	%g5, %g1, 16
	fld	%f4, %g5, 0
	fmul	%f4, %f0, %f4
	fadd	%f3, %f3, %f4
	fst	%f3, %g3, 0
	fld	%f3, %g3, 8
	fld	%f4, %g5, 8
	fmul	%f4, %f0, %f4
	fadd	%f3, %f3, %f4
	fst	%f3, %g3, 8
	fld	%f3, %g3, 16
	fld	%f4, %g5, 16
	fmul	%f0, %f0, %f4
	fadd	%f0, %f3, %f0
	fst	%f0, %g3, 16
beq_cont.22489:
	setL %g3, l.14007
	fld	%f0, %g3, 0
	fblt	%f0, %f1, fble_else.22490
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22491
fble_else.22490:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22491:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g3, %g5, beq_else.22492
	b	beq_cont.22493
beq_else.22492:
	fmul	%f0, %f1, %f1
	fmul	%f0, %f0, %f0
	fld	%f1, %g1, 8
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 20
	fld	%f3, %g3, 0
	fadd	%f3, %f3, %f0
	fst	%f3, %g3, 0
	fld	%f3, %g3, 8
	fadd	%f3, %f3, %f0
	fst	%f3, %g3, 8
	fld	%f3, %g3, 16
	fadd	%f0, %f3, %f0
	fst	%f0, %g3, 16
beq_cont.22493:
	b	beq_cont.22485
beq_else.22484:
beq_cont.22485:
	b	beq_cont.22483
beq_else.22482:
beq_cont.22483:
beq_cont.22481:
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	fld	%f0, %g1, 32
	fld	%f1, %g1, 8
	ld	%g4, %g1, 24
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
ble_else.22472:
	return
trace_ray.3125:
	ld	%g6, %g30, 84
	ld	%g7, %g30, 80
	ld	%g8, %g30, 76
	ld	%g9, %g30, 72
	ld	%g10, %g30, 68
	ld	%g11, %g30, 64
	ld	%g12, %g30, 60
	ld	%g13, %g30, 56
	ld	%g14, %g30, 52
	ld	%g15, %g30, 48
	ld	%g16, %g30, 44
	ld	%g17, %g30, 40
	ld	%g18, %g30, 36
	ld	%g19, %g30, 32
	ld	%g20, %g30, 28
	ld	%g21, %g30, 24
	ld	%g22, %g30, 20
	ld	%g23, %g30, 16
	ld	%g24, %g30, 12
	ld	%g25, %g30, 8
	ld	%g26, %g30, 4
	mvhi	%g27, 0
	mvlo	%g27, 4
	blt	%g27, %g3, ble_else.22495
	ld	%g27, %g5, 8
	setL %g28, l.14806
	fld	%f2, %g28, 0
	fst	%f2, %g9, 0
	mvhi	%g28, 0
	mvlo	%g28, 0
	ld	%g29, %g16, 0
	st	%g30, %g1, 0
	std	%f1, %g1, 8
	st	%g7, %g1, 16
	st	%g19, %g1, 20
	st	%g14, %g1, 24
	st	%g20, %g1, 28
	st	%g11, %g1, 32
	st	%g13, %g1, 36
	st	%g16, %g1, 40
	st	%g10, %g1, 44
	st	%g5, %g1, 48
	st	%g6, %g1, 52
	st	%g12, %g1, 56
	st	%g23, %g1, 60
	st	%g25, %g1, 64
	st	%g18, %g1, 68
	st	%g22, %g1, 72
	st	%g17, %g1, 76
	st	%g24, %g1, 80
	st	%g15, %g1, 84
	st	%g26, %g1, 88
	std	%f0, %g1, 96
	st	%g21, %g1, 104
	st	%g4, %g1, 108
	st	%g27, %g1, 112
	st	%g3, %g1, 116
	st	%g9, %g1, 120
	mov	%g5, %g4
	mov	%g3, %g28
	mov	%g30, %g8
	mov	%g4, %g29
	st	%g31, %g1, 124
	ld	%g29, %g30, 0
	addi	%g1, %g1, 128
	call	%g29
	subi	%g1, %g1, 128
	ld	%g31, %g1, 124
	ld	%g3, %g1, 120
	fld	%f0, %g3, 0
	setL %g4, l.14646
	fld	%f1, %g4, 0
	fblt	%f1, %f0, fble_else.22498
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22499
fble_else.22498:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22499:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.22500
	mvhi	%g4, 0
	mvlo	%g4, 0
	b	beq_cont.22501
beq_else.22500:
	setL %g4, l.14824
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.22502
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22503
fble_else.22502:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22503:
beq_cont.22501:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.22504
	mvhi	%g3, 65535
	mvlo	%g3, -1
	ld	%g4, %g1, 116
	slli	%g5, %g4, 2
	ld	%g6, %g1, 112
	st	%g3, %g6, %g5
	mvhi	%g3, 0
	mvlo	%g3, 0
	bne	%g4, %g3, beq_else.22505
	return
beq_else.22505:
	ld	%g3, %g1, 108
	fld	%f0, %g3, 0
	ld	%g4, %g1, 104
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g3, 8
	fld	%f2, %g4, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, 16
	fld	%f2, %g4, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fneg	%f0, %f0
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fblt	%f1, %f0, fble_else.22507
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22508
fble_else.22507:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22508:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22509
	return
beq_else.22509:
	fmul	%f1, %f0, %f0
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 96
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 88
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 84
	fld	%f1, %g3, 0
	fadd	%f1, %f1, %f0
	fst	%f1, %g3, 0
	fld	%f1, %g3, 8
	fadd	%f1, %f1, %f0
	fst	%f1, %g3, 8
	fld	%f1, %g3, 16
	fadd	%f0, %f1, %f0
	fst	%f0, %g3, 16
	return
beq_else.22504:
	ld	%g4, %g1, 80
	ld	%g4, %g4, 0
	slli	%g5, %g4, 2
	ld	%g6, %g1, 76
	ld	%g5, %g6, %g5
	ld	%g6, %g5, 8
	ld	%g7, %g5, 28
	fld	%f0, %g7, 0
	fld	%f1, %g1, 96
	fmul	%f0, %f0, %f1
	ld	%g7, %g5, 4
	mvhi	%g8, 0
	mvlo	%g8, 1
	st	%g6, %g1, 124
	std	%f0, %g1, 128
	st	%g4, %g1, 136
	st	%g5, %g1, 140
	bne	%g7, %g8, beq_else.22512
	ld	%g7, %g1, 72
	ld	%g8, %g7, 0
	setL %g9, l.14007
	fld	%f2, %g9, 0
	ld	%g9, %g1, 68
	fst	%f2, %g9, 0
	fst	%f2, %g9, 8
	fst	%f2, %g9, 16
	subi	%g10, %g8, 1
	subi	%g8, %g8, 1
	slli	%g8, %g8, 3
	ld	%g11, %g1, 108
	fld	%f2, %g11, %g8
	setL %g8, l.14007
	fld	%f3, %g8, 0
	fbne	%f2, %f3, fbe_else.22514
	mvhi	%g8, 0
	mvlo	%g8, 1
	b	fbe_cont.22515
fbe_else.22514:
	mvhi	%g8, 0
	mvlo	%g8, 0
fbe_cont.22515:
	mvhi	%g12, 0
	mvlo	%g12, 0
	bne	%g8, %g12, beq_else.22516
	setL %g8, l.14007
	fld	%f3, %g8, 0
	fblt	%f3, %f2, fble_else.22518
	mvhi	%g8, 0
	mvlo	%g8, 1
	b	fble_cont.22519
fble_else.22518:
	mvhi	%g8, 0
	mvlo	%g8, 0
fble_cont.22519:
	mvhi	%g12, 0
	mvlo	%g12, 0
	bne	%g8, %g12, beq_else.22520
	setL %g8, l.14131
	fld	%f2, %g8, 0
	b	beq_cont.22521
beq_else.22520:
	setL %g8, l.14053
	fld	%f2, %g8, 0
beq_cont.22521:
	b	beq_cont.22517
beq_else.22516:
	setL %g8, l.14007
	fld	%f2, %g8, 0
beq_cont.22517:
	fneg	%f2, %f2
	slli	%g8, %g10, 3
	fst	%f2, %g9, %g8
	b	beq_cont.22513
beq_else.22512:
	mvhi	%g8, 0
	mvlo	%g8, 2
	bne	%g7, %g8, beq_else.22522
	ld	%g7, %g5, 16
	fld	%f2, %g7, 0
	fneg	%f2, %f2
	ld	%g7, %g1, 68
	fst	%f2, %g7, 0
	ld	%g8, %g5, 16
	fld	%f2, %g8, 8
	fneg	%f2, %f2
	fst	%f2, %g7, 8
	ld	%g8, %g5, 16
	fld	%f2, %g8, 16
	fneg	%f2, %f2
	fst	%f2, %g7, 16
	b	beq_cont.22523
beq_else.22522:
	ld	%g30, %g1, 64
	mov	%g3, %g5
	st	%g31, %g1, 148
	ld	%g29, %g30, 0
	addi	%g1, %g1, 152
	call	%g29
	subi	%g1, %g1, 152
	ld	%g31, %g1, 148
beq_cont.22523:
beq_cont.22513:
	ld	%g4, %g1, 60
	fld	%f0, %g4, 0
	ld	%g3, %g1, 56
	fst	%f0, %g3, 0
	fld	%f0, %g4, 8
	fst	%f0, %g3, 8
	fld	%f0, %g4, 16
	fst	%f0, %g3, 16
	ld	%g3, %g1, 140
	ld	%g30, %g1, 52
	st	%g31, %g1, 148
	ld	%g29, %g30, 0
	addi	%g1, %g1, 152
	call	%g29
	subi	%g1, %g1, 152
	ld	%g31, %g1, 148
	ld	%g3, %g1, 136
	slli	%g3, %g3, 2
	ld	%g4, %g1, 72
	ld	%g4, %g4, 0
	add	%g3, %g3, %g4
	ld	%g4, %g1, 116
	slli	%g5, %g4, 2
	ld	%g6, %g1, 112
	st	%g3, %g6, %g5
	ld	%g3, %g1, 48
	ld	%g5, %g3, 4
	slli	%g7, %g4, 2
	ld	%g5, %g5, %g7
	ld	%g7, %g1, 60
	fld	%f0, %g7, 0
	fst	%f0, %g5, 0
	fld	%f0, %g7, 8
	fst	%f0, %g5, 8
	fld	%f0, %g7, 16
	fst	%f0, %g5, 16
	ld	%g5, %g3, 12
	ld	%g8, %g1, 140
	ld	%g9, %g8, 28
	fld	%f0, %g9, 0
	setL %g9, l.13995
	fld	%f1, %g9, 0
	fblt	%f0, %f1, fble_else.22524
	mvhi	%g9, 0
	mvlo	%g9, 1
	b	fble_cont.22525
fble_else.22524:
	mvhi	%g9, 0
	mvlo	%g9, 0
fble_cont.22525:
	mvhi	%g10, 0
	mvlo	%g10, 0
	bne	%g9, %g10, beq_else.22526
	mvhi	%g9, 0
	mvlo	%g9, 1
	slli	%g10, %g4, 2
	st	%g9, %g5, %g10
	ld	%g5, %g3, 16
	slli	%g9, %g4, 2
	ld	%g9, %g5, %g9
	ld	%g10, %g1, 44
	fld	%f0, %g10, 0
	fst	%f0, %g9, 0
	fld	%f0, %g10, 8
	fst	%f0, %g9, 8
	fld	%f0, %g10, 16
	fst	%f0, %g9, 16
	slli	%g9, %g4, 2
	ld	%g5, %g5, %g9
	setL %g9, l.15042
	fld	%f0, %g9, 0
	fld	%f1, %g1, 128
	fmul	%f0, %f0, %f1
	fld	%f2, %g5, 0
	fmul	%f2, %f2, %f0
	fst	%f2, %g5, 0
	fld	%f2, %g5, 8
	fmul	%f2, %f2, %f0
	fst	%f2, %g5, 8
	fld	%f2, %g5, 16
	fmul	%f0, %f2, %f0
	fst	%f0, %g5, 16
	ld	%g5, %g3, 28
	slli	%g9, %g4, 2
	ld	%g5, %g5, %g9
	ld	%g9, %g1, 68
	fld	%f0, %g9, 0
	fst	%f0, %g5, 0
	fld	%f0, %g9, 8
	fst	%f0, %g5, 8
	fld	%f0, %g9, 16
	fst	%f0, %g5, 16
	b	beq_cont.22527
beq_else.22526:
	mvhi	%g9, 0
	mvlo	%g9, 0
	slli	%g10, %g4, 2
	st	%g9, %g5, %g10
beq_cont.22527:
	setL %g5, l.15057
	fld	%f0, %g5, 0
	ld	%g5, %g1, 108
	fld	%f1, %g5, 0
	ld	%g9, %g1, 68
	fld	%f2, %g9, 0
	fmul	%f1, %f1, %f2
	fld	%f2, %g5, 8
	fld	%f3, %g9, 8
	fmul	%f2, %f2, %f3
	fadd	%f1, %f1, %f2
	fld	%f2, %g5, 16
	fld	%f3, %g9, 16
	fmul	%f2, %f2, %f3
	fadd	%f1, %f1, %f2
	fmul	%f0, %f0, %f1
	fld	%f1, %g5, 0
	fld	%f2, %g9, 0
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g5, 0
	fld	%f1, %g5, 8
	fld	%f2, %g9, 8
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g5, 8
	fld	%f1, %g5, 16
	fld	%f2, %g9, 16
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fst	%f0, %g5, 16
	ld	%g10, %g8, 28
	fld	%f0, %g10, 8
	fld	%f1, %g1, 96
	fmul	%f0, %f1, %f0
	mvhi	%g10, 0
	mvlo	%g10, 0
	ld	%g11, %g1, 40
	ld	%g11, %g11, 0
	ld	%g30, %g1, 36
	std	%f0, %g1, 144
	mov	%g4, %g11
	mov	%g3, %g10
	st	%g31, %g1, 156
	ld	%g29, %g30, 0
	addi	%g1, %g1, 160
	call	%g29
	subi	%g1, %g1, 160
	ld	%g31, %g1, 156
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22528
	ld	%g3, %g1, 68
	fld	%f0, %g3, 0
	ld	%g4, %g1, 104
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g3, 8
	fld	%f2, %g4, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, 16
	fld	%f2, %g4, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fneg	%f0, %f0
	fld	%f1, %g1, 128
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 108
	fld	%f2, %g3, 0
	fld	%f3, %g4, 0
	fmul	%f2, %f2, %f3
	fld	%f3, %g3, 8
	fld	%f4, %g4, 8
	fmul	%f3, %f3, %f4
	fadd	%f2, %f2, %f3
	fld	%f3, %g3, 16
	fld	%f4, %g4, 16
	fmul	%f3, %f3, %f4
	fadd	%f2, %f2, %f3
	fneg	%f2, %f2
	setL %g4, l.14007
	fld	%f3, %g4, 0
	fblt	%f3, %f0, fble_else.22530
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22531
fble_else.22530:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22531:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.22532
	b	beq_cont.22533
beq_else.22532:
	ld	%g4, %g1, 84
	fld	%f3, %g4, 0
	ld	%g5, %g1, 44
	fld	%f4, %g5, 0
	fmul	%f4, %f0, %f4
	fadd	%f3, %f3, %f4
	fst	%f3, %g4, 0
	fld	%f3, %g4, 8
	fld	%f4, %g5, 8
	fmul	%f4, %f0, %f4
	fadd	%f3, %f3, %f4
	fst	%f3, %g4, 8
	fld	%f3, %g4, 16
	fld	%f4, %g5, 16
	fmul	%f0, %f0, %f4
	fadd	%f0, %f3, %f0
	fst	%f0, %g4, 16
beq_cont.22533:
	setL %g4, l.14007
	fld	%f0, %g4, 0
	fblt	%f0, %f2, fble_else.22534
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22535
fble_else.22534:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22535:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.22536
	b	beq_cont.22537
beq_else.22536:
	fmul	%f0, %f2, %f2
	fmul	%f0, %f0, %f0
	fld	%f2, %g1, 144
	fmul	%f0, %f0, %f2
	ld	%g4, %g1, 84
	fld	%f3, %g4, 0
	fadd	%f3, %f3, %f0
	fst	%f3, %g4, 0
	fld	%f3, %g4, 8
	fadd	%f3, %f3, %f0
	fst	%f3, %g4, 8
	fld	%f3, %g4, 16
	fadd	%f0, %f3, %f0
	fst	%f0, %g4, 16
beq_cont.22537:
	b	beq_cont.22529
beq_else.22528:
beq_cont.22529:
	ld	%g3, %g1, 60
	fld	%f0, %g3, 0
	ld	%g4, %g1, 32
	fst	%f0, %g4, 0
	fld	%f0, %g3, 8
	fst	%f0, %g4, 8
	fld	%f0, %g3, 16
	fst	%f0, %g4, 16
	ld	%g4, %g1, 28
	ld	%g4, %g4, 0
	subi	%g4, %g4, 1
	ld	%g30, %g1, 24
	st	%g31, %g1, 156
	ld	%g29, %g30, 0
	addi	%g1, %g1, 160
	call	%g29
	subi	%g1, %g1, 160
	ld	%g31, %g1, 156
	ld	%g3, %g1, 20
	ld	%g3, %g3, 0
	subi	%g3, %g3, 1
	fld	%f0, %g1, 128
	fld	%f1, %g1, 144
	ld	%g4, %g1, 108
	ld	%g30, %g1, 16
	st	%g31, %g1, 156
	ld	%g29, %g30, 0
	addi	%g1, %g1, 160
	call	%g29
	subi	%g1, %g1, 160
	ld	%g31, %g1, 156
	setL %g3, l.15113
	fld	%f0, %g3, 0
	fld	%f1, %g1, 96
	fblt	%f0, %f1, fble_else.22538
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22539
fble_else.22538:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22539:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22540
	return
beq_else.22540:
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 116
	blt	%g4, %g3, ble_else.22542
	b	ble_cont.22543
ble_else.22542:
	addi	%g3, %g4, 1
	mvhi	%g5, 65535
	mvlo	%g5, -1
	slli	%g3, %g3, 2
	ld	%g6, %g1, 112
	st	%g5, %g6, %g3
ble_cont.22543:
	mvhi	%g3, 0
	mvlo	%g3, 2
	ld	%g5, %g1, 124
	bne	%g5, %g3, beq_else.22544
	setL %g3, l.14053
	fld	%f0, %g3, 0
	ld	%g3, %g1, 140
	ld	%g3, %g3, 28
	fld	%f2, %g3, 0
	fsub	%f0, %f0, %f2
	fmul	%f0, %f1, %f0
	addi	%g3, %g4, 1
	ld	%g4, %g1, 120
	fld	%f1, %g4, 0
	fld	%f2, %g1, 8
	fadd	%f1, %f2, %f1
	ld	%g4, %g1, 108
	ld	%g5, %g1, 48
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
beq_else.22544:
	return
ble_else.22495:
	return
trace_diffuse_ray.3131:
	ld	%g4, %g30, 56
	ld	%g5, %g30, 52
	ld	%g6, %g30, 48
	ld	%g7, %g30, 44
	ld	%g8, %g30, 40
	ld	%g9, %g30, 36
	ld	%g10, %g30, 32
	ld	%g11, %g30, 28
	ld	%g12, %g30, 24
	ld	%g13, %g30, 20
	ld	%g14, %g30, 16
	ld	%g15, %g30, 12
	ld	%g16, %g30, 8
	ld	%g17, %g30, 4
	setL %g18, l.14806
	fld	%f1, %g18, 0
	fst	%f1, %g6, 0
	mvhi	%g18, 0
	mvlo	%g18, 0
	ld	%g19, %g9, 0
	st	%g7, %g1, 0
	st	%g17, %g1, 4
	std	%f0, %g1, 8
	st	%g12, %g1, 16
	st	%g8, %g1, 20
	st	%g9, %g1, 24
	st	%g14, %g1, 28
	st	%g4, %g1, 32
	st	%g16, %g1, 36
	st	%g11, %g1, 40
	st	%g13, %g1, 44
	st	%g3, %g1, 48
	st	%g10, %g1, 52
	st	%g15, %g1, 56
	st	%g6, %g1, 60
	mov	%g4, %g19
	mov	%g30, %g5
	mov	%g5, %g3
	mov	%g3, %g18
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 60
	fld	%f0, %g3, 0
	setL %g3, l.14646
	fld	%f1, %g3, 0
	fblt	%f1, %f0, fble_else.22547
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22548
fble_else.22547:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22548:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22549
	mvhi	%g3, 0
	mvlo	%g3, 0
	b	beq_cont.22550
beq_else.22549:
	setL %g3, l.14824
	fld	%f1, %g3, 0
	fblt	%f0, %f1, fble_else.22551
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22552
fble_else.22551:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22552:
beq_cont.22550:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22553
	return
beq_else.22553:
	ld	%g3, %g1, 56
	ld	%g3, %g3, 0
	slli	%g3, %g3, 2
	ld	%g4, %g1, 52
	ld	%g3, %g4, %g3
	ld	%g4, %g1, 48
	ld	%g4, %g4, 0
	ld	%g5, %g3, 4
	mvhi	%g6, 0
	mvlo	%g6, 1
	st	%g3, %g1, 64
	bne	%g5, %g6, beq_else.22555
	ld	%g5, %g1, 44
	ld	%g5, %g5, 0
	setL %g6, l.14007
	fld	%f0, %g6, 0
	ld	%g6, %g1, 40
	fst	%f0, %g6, 0
	fst	%f0, %g6, 8
	fst	%f0, %g6, 16
	subi	%g7, %g5, 1
	subi	%g5, %g5, 1
	slli	%g5, %g5, 3
	fld	%f0, %g4, %g5
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fbne	%f0, %f1, fbe_else.22557
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fbe_cont.22558
fbe_else.22557:
	mvhi	%g4, 0
	mvlo	%g4, 0
fbe_cont.22558:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.22559
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f1, %f0, fble_else.22561
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22562
fble_else.22561:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22562:
	mvhi	%g5, 0
	mvlo	%g5, 0
	bne	%g4, %g5, beq_else.22563
	setL %g4, l.14131
	fld	%f0, %g4, 0
	b	beq_cont.22564
beq_else.22563:
	setL %g4, l.14053
	fld	%f0, %g4, 0
beq_cont.22564:
	b	beq_cont.22560
beq_else.22559:
	setL %g4, l.14007
	fld	%f0, %g4, 0
beq_cont.22560:
	fneg	%f0, %f0
	slli	%g4, %g7, 3
	fst	%f0, %g6, %g4
	b	beq_cont.22556
beq_else.22555:
	mvhi	%g4, 0
	mvlo	%g4, 2
	bne	%g5, %g4, beq_else.22565
	ld	%g4, %g3, 16
	fld	%f0, %g4, 0
	fneg	%f0, %f0
	ld	%g4, %g1, 40
	fst	%f0, %g4, 0
	ld	%g5, %g3, 16
	fld	%f0, %g5, 8
	fneg	%f0, %f0
	fst	%f0, %g4, 8
	ld	%g5, %g3, 16
	fld	%f0, %g5, 16
	fneg	%f0, %f0
	fst	%f0, %g4, 16
	b	beq_cont.22566
beq_else.22565:
	ld	%g30, %g1, 36
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
beq_cont.22566:
beq_cont.22556:
	ld	%g3, %g1, 64
	ld	%g4, %g1, 28
	ld	%g30, %g1, 32
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 24
	ld	%g4, %g4, 0
	ld	%g30, %g1, 20
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22567
	ld	%g3, %g1, 40
	fld	%f0, %g3, 0
	ld	%g4, %g1, 16
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g3, 8
	fld	%f2, %g4, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, 16
	fld	%f2, %g4, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fneg	%f0, %f0
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fblt	%f1, %f0, fble_else.22568
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22569
fble_else.22568:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22569:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22570
	setL %g3, l.14007
	fld	%f0, %g3, 0
	b	beq_cont.22571
beq_else.22570:
beq_cont.22571:
	fld	%f1, %g1, 8
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 64
	ld	%g3, %g3, 28
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 4
	fld	%f1, %g3, 0
	ld	%g4, %g1, 0
	fld	%f2, %g4, 0
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g3, 0
	fld	%f1, %g3, 8
	fld	%f2, %g4, 8
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g3, 8
	fld	%f1, %g3, 16
	fld	%f2, %g4, 16
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fst	%f0, %g3, 16
	return
beq_else.22567:
	return
iter_trace_diffuse_rays.3134:
	ld	%g7, %g30, 52
	ld	%g8, %g30, 48
	ld	%g9, %g30, 44
	ld	%g10, %g30, 40
	ld	%g11, %g30, 36
	ld	%g12, %g30, 32
	ld	%g13, %g30, 28
	ld	%g14, %g30, 24
	ld	%g15, %g30, 20
	ld	%g16, %g30, 16
	ld	%g17, %g30, 12
	ld	%g18, %g30, 8
	ld	%g19, %g30, 4
	mvhi	%g20, 0
	mvlo	%g20, 0
	blt	%g6, %g20, ble_else.22574
	slli	%g20, %g6, 2
	ld	%g20, %g3, %g20
	ld	%g20, %g20, 0
	fld	%f0, %g20, 0
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g20, 8
	fld	%f2, %g4, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g20, 16
	fld	%f2, %g4, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	setL %g20, l.14007
	fld	%f1, %g20, 0
	fblt	%f0, %f1, fble_else.22575
	mvhi	%g20, 0
	mvlo	%g20, 1
	b	fble_cont.22576
fble_else.22575:
	mvhi	%g20, 0
	mvlo	%g20, 0
fble_cont.22576:
	mvhi	%g21, 0
	mvlo	%g21, 0
	st	%g5, %g1, 0
	st	%g30, %g1, 4
	st	%g8, %g1, 8
	st	%g4, %g1, 12
	st	%g3, %g1, 16
	st	%g6, %g1, 20
	bne	%g20, %g21, beq_else.22577
	slli	%g20, %g6, 2
	ld	%g20, %g3, %g20
	setL %g21, l.15212
	fld	%f1, %g21, 0
	fdiv	%f0, %f0, %f1
	st	%g9, %g1, 24
	st	%g19, %g1, 28
	std	%f0, %g1, 32
	st	%g14, %g1, 40
	st	%g13, %g1, 44
	st	%g10, %g1, 48
	st	%g11, %g1, 52
	st	%g16, %g1, 56
	st	%g7, %g1, 60
	st	%g18, %g1, 64
	st	%g20, %g1, 68
	st	%g12, %g1, 72
	st	%g17, %g1, 76
	mov	%g3, %g20
	mov	%g30, %g15
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22579
	b	beq_cont.22580
beq_else.22579:
	ld	%g3, %g1, 76
	ld	%g3, %g3, 0
	slli	%g3, %g3, 2
	ld	%g4, %g1, 72
	ld	%g3, %g4, %g3
	ld	%g4, %g1, 68
	ld	%g4, %g4, 0
	ld	%g30, %g1, 64
	st	%g3, %g1, 80
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	ld	%g3, %g1, 80
	ld	%g4, %g1, 56
	ld	%g30, %g1, 60
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 52
	ld	%g4, %g4, 0
	ld	%g30, %g1, 48
	st	%g31, %g1, 84
	ld	%g29, %g30, 0
	addi	%g1, %g1, 88
	call	%g29
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22581
	ld	%g3, %g1, 44
	fld	%f0, %g3, 0
	ld	%g4, %g1, 40
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g3, 8
	fld	%f2, %g4, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, 16
	fld	%f2, %g4, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fneg	%f0, %f0
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fblt	%f1, %f0, fble_else.22583
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22584
fble_else.22583:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22584:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22585
	setL %g3, l.14007
	fld	%f0, %g3, 0
	b	beq_cont.22586
beq_else.22585:
beq_cont.22586:
	fld	%f1, %g1, 32
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 80
	ld	%g3, %g3, 28
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 28
	fld	%f1, %g3, 0
	ld	%g4, %g1, 24
	fld	%f2, %g4, 0
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g3, 0
	fld	%f1, %g3, 8
	fld	%f2, %g4, 8
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g3, 8
	fld	%f1, %g3, 16
	fld	%f2, %g4, 16
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fst	%f0, %g3, 16
	b	beq_cont.22582
beq_else.22581:
beq_cont.22582:
beq_cont.22580:
	b	beq_cont.22578
beq_else.22577:
	addi	%g20, %g6, 1
	slli	%g20, %g20, 2
	ld	%g20, %g3, %g20
	setL %g21, l.15188
	fld	%f1, %g21, 0
	fdiv	%f0, %f0, %f1
	st	%g9, %g1, 24
	st	%g19, %g1, 28
	std	%f0, %g1, 88
	st	%g14, %g1, 40
	st	%g13, %g1, 44
	st	%g10, %g1, 48
	st	%g11, %g1, 52
	st	%g16, %g1, 56
	st	%g7, %g1, 60
	st	%g18, %g1, 64
	st	%g20, %g1, 96
	st	%g12, %g1, 72
	st	%g17, %g1, 76
	mov	%g3, %g20
	mov	%g30, %g15
	st	%g31, %g1, 100
	ld	%g29, %g30, 0
	addi	%g1, %g1, 104
	call	%g29
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22588
	b	beq_cont.22589
beq_else.22588:
	ld	%g3, %g1, 76
	ld	%g3, %g3, 0
	slli	%g3, %g3, 2
	ld	%g4, %g1, 72
	ld	%g3, %g4, %g3
	ld	%g4, %g1, 96
	ld	%g4, %g4, 0
	ld	%g30, %g1, 64
	st	%g3, %g1, 100
	st	%g31, %g1, 108
	ld	%g29, %g30, 0
	addi	%g1, %g1, 112
	call	%g29
	subi	%g1, %g1, 112
	ld	%g31, %g1, 108
	ld	%g3, %g1, 100
	ld	%g4, %g1, 56
	ld	%g30, %g1, 60
	st	%g31, %g1, 108
	ld	%g29, %g30, 0
	addi	%g1, %g1, 112
	call	%g29
	subi	%g1, %g1, 112
	ld	%g31, %g1, 108
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 52
	ld	%g4, %g4, 0
	ld	%g30, %g1, 48
	st	%g31, %g1, 108
	ld	%g29, %g30, 0
	addi	%g1, %g1, 112
	call	%g29
	subi	%g1, %g1, 112
	ld	%g31, %g1, 108
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22590
	ld	%g3, %g1, 44
	fld	%f0, %g3, 0
	ld	%g4, %g1, 40
	fld	%f1, %g4, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g3, 8
	fld	%f2, %g4, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g3, 16
	fld	%f2, %g4, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fneg	%f0, %f0
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fblt	%f1, %f0, fble_else.22592
	mvhi	%g3, 0
	mvlo	%g3, 1
	b	fble_cont.22593
fble_else.22592:
	mvhi	%g3, 0
	mvlo	%g3, 0
fble_cont.22593:
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22594
	setL %g3, l.14007
	fld	%f0, %g3, 0
	b	beq_cont.22595
beq_else.22594:
beq_cont.22595:
	fld	%f1, %g1, 88
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 100
	ld	%g3, %g3, 28
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 28
	fld	%f1, %g3, 0
	ld	%g4, %g1, 24
	fld	%f2, %g4, 0
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g3, 0
	fld	%f1, %g3, 8
	fld	%f2, %g4, 8
	fmul	%f2, %f0, %f2
	fadd	%f1, %f1, %f2
	fst	%f1, %g3, 8
	fld	%f1, %g3, 16
	fld	%f2, %g4, 16
	fmul	%f0, %f0, %f2
	fadd	%f0, %f1, %f0
	fst	%f0, %g3, 16
	b	beq_cont.22591
beq_else.22590:
beq_cont.22591:
beq_cont.22589:
beq_cont.22578:
	ld	%g3, %g1, 20
	subi	%g3, %g3, 2
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22596
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	ld	%g4, %g5, %g4
	ld	%g4, %g4, 0
	fld	%f0, %g4, 0
	ld	%g6, %g1, 12
	fld	%f1, %g6, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g4, 8
	fld	%f2, %g6, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g4, 16
	fld	%f2, %g6, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.22597
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22598
fble_else.22597:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22598:
	mvhi	%g7, 0
	mvlo	%g7, 0
	st	%g3, %g1, 104
	bne	%g4, %g7, beq_else.22599
	slli	%g4, %g3, 2
	ld	%g4, %g5, %g4
	setL %g7, l.15212
	fld	%f1, %g7, 0
	fdiv	%f0, %f0, %f1
	ld	%g30, %g1, 8
	mov	%g3, %g4
	st	%g31, %g1, 108
	ld	%g29, %g30, 0
	addi	%g1, %g1, 112
	call	%g29
	subi	%g1, %g1, 112
	ld	%g31, %g1, 108
	b	beq_cont.22600
beq_else.22599:
	addi	%g4, %g3, 1
	slli	%g4, %g4, 2
	ld	%g4, %g5, %g4
	setL %g7, l.15188
	fld	%f1, %g7, 0
	fdiv	%f0, %f0, %f1
	ld	%g30, %g1, 8
	mov	%g3, %g4
	st	%g31, %g1, 108
	ld	%g29, %g30, 0
	addi	%g1, %g1, 112
	call	%g29
	subi	%g1, %g1, 112
	ld	%g31, %g1, 108
beq_cont.22600:
	ld	%g3, %g1, 104
	subi	%g6, %g3, 2
	ld	%g3, %g1, 16
	ld	%g4, %g1, 12
	ld	%g5, %g1, 0
	ld	%g30, %g1, 4
	ld	%g30, 0, %g29
	b	%g29
ble_else.22596:
	return
ble_else.22574:
	return
trace_diffuse_ray_80percent.3143:
	ld	%g6, %g30, 20
	ld	%g7, %g30, 16
	ld	%g8, %g30, 12
	ld	%g9, %g30, 8
	ld	%g10, %g30, 4
	mvhi	%g11, 0
	mvlo	%g11, 0
	st	%g4, %g1, 0
	st	%g9, %g1, 4
	st	%g7, %g1, 8
	st	%g8, %g1, 12
	st	%g6, %g1, 16
	st	%g5, %g1, 20
	st	%g10, %g1, 24
	st	%g3, %g1, 28
	bne	%g3, %g11, beq_else.22603
	b	beq_cont.22604
beq_else.22603:
	ld	%g11, %g10, 0
	fld	%f0, %g5, 0
	fst	%f0, %g6, 0
	fld	%f0, %g5, 8
	fst	%f0, %g6, 8
	fld	%f0, %g5, 16
	fst	%f0, %g6, 16
	ld	%g12, %g8, 0
	subi	%g12, %g12, 1
	st	%g11, %g1, 32
	mov	%g4, %g12
	mov	%g3, %g5
	mov	%g30, %g7
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mvhi	%g6, 0
	mvlo	%g6, 118
	ld	%g3, %g1, 32
	ld	%g4, %g1, 0
	ld	%g5, %g1, 20
	ld	%g30, %g1, 4
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
beq_cont.22604:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 28
	bne	%g4, %g3, beq_else.22605
	b	beq_cont.22606
beq_else.22605:
	ld	%g3, %g1, 24
	ld	%g5, %g3, 4
	ld	%g6, %g1, 20
	fld	%f0, %g6, 0
	ld	%g7, %g1, 16
	fst	%f0, %g7, 0
	fld	%f0, %g6, 8
	fst	%f0, %g7, 8
	fld	%f0, %g6, 16
	fst	%f0, %g7, 16
	ld	%g8, %g1, 12
	ld	%g9, %g8, 0
	subi	%g9, %g9, 1
	ld	%g30, %g1, 8
	st	%g5, %g1, 36
	mov	%g4, %g9
	mov	%g3, %g6
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g6, 0
	mvlo	%g6, 118
	ld	%g3, %g1, 36
	ld	%g4, %g1, 0
	ld	%g5, %g1, 20
	ld	%g30, %g1, 4
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
beq_cont.22606:
	mvhi	%g3, 0
	mvlo	%g3, 2
	ld	%g4, %g1, 28
	bne	%g4, %g3, beq_else.22607
	b	beq_cont.22608
beq_else.22607:
	ld	%g3, %g1, 24
	ld	%g5, %g3, 8
	ld	%g6, %g1, 20
	fld	%f0, %g6, 0
	ld	%g7, %g1, 16
	fst	%f0, %g7, 0
	fld	%f0, %g6, 8
	fst	%f0, %g7, 8
	fld	%f0, %g6, 16
	fst	%f0, %g7, 16
	ld	%g8, %g1, 12
	ld	%g9, %g8, 0
	subi	%g9, %g9, 1
	ld	%g30, %g1, 8
	st	%g5, %g1, 40
	mov	%g4, %g9
	mov	%g3, %g6
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g6, 0
	mvlo	%g6, 118
	ld	%g3, %g1, 40
	ld	%g4, %g1, 0
	ld	%g5, %g1, 20
	ld	%g30, %g1, 4
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
beq_cont.22608:
	mvhi	%g3, 0
	mvlo	%g3, 3
	ld	%g4, %g1, 28
	bne	%g4, %g3, beq_else.22609
	b	beq_cont.22610
beq_else.22609:
	ld	%g3, %g1, 24
	ld	%g5, %g3, 12
	ld	%g6, %g1, 20
	fld	%f0, %g6, 0
	ld	%g7, %g1, 16
	fst	%f0, %g7, 0
	fld	%f0, %g6, 8
	fst	%f0, %g7, 8
	fld	%f0, %g6, 16
	fst	%f0, %g7, 16
	ld	%g8, %g1, 12
	ld	%g9, %g8, 0
	subi	%g9, %g9, 1
	ld	%g30, %g1, 8
	st	%g5, %g1, 44
	mov	%g4, %g9
	mov	%g3, %g6
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g6, 0
	mvlo	%g6, 118
	ld	%g3, %g1, 44
	ld	%g4, %g1, 0
	ld	%g5, %g1, 20
	ld	%g30, %g1, 4
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
beq_cont.22610:
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 28
	bne	%g4, %g3, beq_else.22611
	return
beq_else.22611:
	ld	%g3, %g1, 24
	ld	%g3, %g3, 16
	ld	%g4, %g1, 20
	fld	%f0, %g4, 0
	ld	%g5, %g1, 16
	fst	%f0, %g5, 0
	fld	%f0, %g4, 8
	fst	%f0, %g5, 8
	fld	%f0, %g4, 16
	fst	%f0, %g5, 16
	ld	%g5, %g1, 12
	ld	%g5, %g5, 0
	subi	%g5, %g5, 1
	ld	%g30, %g1, 8
	st	%g3, %g1, 48
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g6, 0
	mvlo	%g6, 118
	ld	%g3, %g1, 48
	ld	%g4, %g1, 0
	ld	%g5, %g1, 20
	ld	%g30, %g1, 4
	ld	%g30, 0, %g29
	b	%g29
calc_diffuse_using_1point.3147:
	ld	%g5, %g30, 32
	ld	%g6, %g30, 28
	ld	%g7, %g30, 24
	ld	%g8, %g30, 20
	ld	%g9, %g30, 16
	ld	%g10, %g30, 12
	ld	%g11, %g30, 8
	ld	%g12, %g30, 4
	ld	%g13, %g3, 20
	ld	%g14, %g3, 28
	ld	%g15, %g3, 4
	ld	%g16, %g3, 16
	slli	%g17, %g4, 2
	ld	%g13, %g13, %g17
	fld	%f0, %g13, 0
	fst	%f0, %g12, 0
	fld	%f0, %g13, 8
	fst	%f0, %g12, 8
	fld	%f0, %g13, 16
	fst	%f0, %g12, 16
	ld	%g3, %g3, 24
	ld	%g3, %g3, 0
	slli	%g13, %g4, 2
	ld	%g13, %g14, %g13
	slli	%g14, %g4, 2
	ld	%g14, %g15, %g14
	mvhi	%g15, 0
	mvlo	%g15, 0
	st	%g12, %g1, 0
	st	%g8, %g1, 4
	st	%g16, %g1, 8
	st	%g4, %g1, 12
	st	%g10, %g1, 16
	st	%g5, %g1, 20
	st	%g13, %g1, 24
	st	%g7, %g1, 28
	st	%g9, %g1, 32
	st	%g6, %g1, 36
	st	%g14, %g1, 40
	st	%g11, %g1, 44
	st	%g3, %g1, 48
	bne	%g3, %g15, beq_else.22613
	b	beq_cont.22614
beq_else.22613:
	ld	%g15, %g11, 0
	fld	%f0, %g14, 0
	fst	%f0, %g6, 0
	fld	%f0, %g14, 8
	fst	%f0, %g6, 8
	fld	%f0, %g14, 16
	fst	%f0, %g6, 16
	ld	%g17, %g9, 0
	subi	%g17, %g17, 1
	st	%g15, %g1, 52
	mov	%g4, %g17
	mov	%g3, %g14
	mov	%g30, %g7
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 52
	ld	%g4, %g3, 472
	ld	%g4, %g4, 0
	fld	%f0, %g4, 0
	ld	%g5, %g1, 24
	fld	%f1, %g5, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g4, 8
	fld	%f2, %g5, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g4, 16
	fld	%f2, %g5, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.22615
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22616
fble_else.22615:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22616:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g4, %g6, beq_else.22617
	ld	%g4, %g3, 472
	setL %g6, l.15212
	fld	%f1, %g6, 0
	fdiv	%f0, %f0, %f1
	ld	%g30, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	b	beq_cont.22618
beq_else.22617:
	ld	%g4, %g3, 476
	setL %g6, l.15188
	fld	%f1, %g6, 0
	fdiv	%f0, %f0, %f1
	ld	%g30, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
beq_cont.22618:
	mvhi	%g6, 0
	mvlo	%g6, 116
	ld	%g3, %g1, 52
	ld	%g4, %g1, 24
	ld	%g5, %g1, 40
	ld	%g30, %g1, 16
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
beq_cont.22614:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 48
	bne	%g4, %g3, beq_else.22619
	b	beq_cont.22620
beq_else.22619:
	ld	%g3, %g1, 44
	ld	%g5, %g3, 4
	ld	%g6, %g1, 40
	fld	%f0, %g6, 0
	ld	%g7, %g1, 36
	fst	%f0, %g7, 0
	fld	%f0, %g6, 8
	fst	%f0, %g7, 8
	fld	%f0, %g6, 16
	fst	%f0, %g7, 16
	ld	%g8, %g1, 32
	ld	%g9, %g8, 0
	subi	%g9, %g9, 1
	ld	%g30, %g1, 28
	st	%g5, %g1, 56
	mov	%g4, %g9
	mov	%g3, %g6
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 56
	ld	%g4, %g3, 472
	ld	%g4, %g4, 0
	fld	%f0, %g4, 0
	ld	%g5, %g1, 24
	fld	%f1, %g5, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g4, 8
	fld	%f2, %g5, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g4, 16
	fld	%f2, %g5, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.22621
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22622
fble_else.22621:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22622:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g4, %g6, beq_else.22623
	ld	%g4, %g3, 472
	setL %g6, l.15212
	fld	%f1, %g6, 0
	fdiv	%f0, %f0, %f1
	ld	%g30, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	b	beq_cont.22624
beq_else.22623:
	ld	%g4, %g3, 476
	setL %g6, l.15188
	fld	%f1, %g6, 0
	fdiv	%f0, %f0, %f1
	ld	%g30, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
beq_cont.22624:
	mvhi	%g6, 0
	mvlo	%g6, 116
	ld	%g3, %g1, 56
	ld	%g4, %g1, 24
	ld	%g5, %g1, 40
	ld	%g30, %g1, 16
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
beq_cont.22620:
	mvhi	%g3, 0
	mvlo	%g3, 2
	ld	%g4, %g1, 48
	bne	%g4, %g3, beq_else.22625
	b	beq_cont.22626
beq_else.22625:
	ld	%g3, %g1, 44
	ld	%g5, %g3, 8
	ld	%g6, %g1, 40
	fld	%f0, %g6, 0
	ld	%g7, %g1, 36
	fst	%f0, %g7, 0
	fld	%f0, %g6, 8
	fst	%f0, %g7, 8
	fld	%f0, %g6, 16
	fst	%f0, %g7, 16
	ld	%g8, %g1, 32
	ld	%g9, %g8, 0
	subi	%g9, %g9, 1
	ld	%g30, %g1, 28
	st	%g5, %g1, 60
	mov	%g4, %g9
	mov	%g3, %g6
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 60
	ld	%g4, %g3, 472
	ld	%g4, %g4, 0
	fld	%f0, %g4, 0
	ld	%g5, %g1, 24
	fld	%f1, %g5, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g4, 8
	fld	%f2, %g5, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g4, 16
	fld	%f2, %g5, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.22627
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22628
fble_else.22627:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22628:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g4, %g6, beq_else.22629
	ld	%g4, %g3, 472
	setL %g6, l.15212
	fld	%f1, %g6, 0
	fdiv	%f0, %f0, %f1
	ld	%g30, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	b	beq_cont.22630
beq_else.22629:
	ld	%g4, %g3, 476
	setL %g6, l.15188
	fld	%f1, %g6, 0
	fdiv	%f0, %f0, %f1
	ld	%g30, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
beq_cont.22630:
	mvhi	%g6, 0
	mvlo	%g6, 116
	ld	%g3, %g1, 60
	ld	%g4, %g1, 24
	ld	%g5, %g1, 40
	ld	%g30, %g1, 16
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
beq_cont.22626:
	mvhi	%g3, 0
	mvlo	%g3, 3
	ld	%g4, %g1, 48
	bne	%g4, %g3, beq_else.22631
	b	beq_cont.22632
beq_else.22631:
	ld	%g3, %g1, 44
	ld	%g5, %g3, 12
	ld	%g6, %g1, 40
	fld	%f0, %g6, 0
	ld	%g7, %g1, 36
	fst	%f0, %g7, 0
	fld	%f0, %g6, 8
	fst	%f0, %g7, 8
	fld	%f0, %g6, 16
	fst	%f0, %g7, 16
	ld	%g8, %g1, 32
	ld	%g9, %g8, 0
	subi	%g9, %g9, 1
	ld	%g30, %g1, 28
	st	%g5, %g1, 64
	mov	%g4, %g9
	mov	%g3, %g6
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 64
	ld	%g4, %g3, 472
	ld	%g4, %g4, 0
	fld	%f0, %g4, 0
	ld	%g5, %g1, 24
	fld	%f1, %g5, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g4, 8
	fld	%f2, %g5, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g4, 16
	fld	%f2, %g5, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.22633
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22634
fble_else.22633:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22634:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g4, %g6, beq_else.22635
	ld	%g4, %g3, 472
	setL %g6, l.15212
	fld	%f1, %g6, 0
	fdiv	%f0, %f0, %f1
	ld	%g30, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	b	beq_cont.22636
beq_else.22635:
	ld	%g4, %g3, 476
	setL %g6, l.15188
	fld	%f1, %g6, 0
	fdiv	%f0, %f0, %f1
	ld	%g30, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
beq_cont.22636:
	mvhi	%g6, 0
	mvlo	%g6, 116
	ld	%g3, %g1, 64
	ld	%g4, %g1, 24
	ld	%g5, %g1, 40
	ld	%g30, %g1, 16
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
beq_cont.22632:
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 48
	bne	%g4, %g3, beq_else.22637
	b	beq_cont.22638
beq_else.22637:
	ld	%g3, %g1, 44
	ld	%g3, %g3, 16
	ld	%g4, %g1, 40
	fld	%f0, %g4, 0
	ld	%g5, %g1, 36
	fst	%f0, %g5, 0
	fld	%f0, %g4, 8
	fst	%f0, %g5, 8
	fld	%f0, %g4, 16
	fst	%f0, %g5, 16
	ld	%g5, %g1, 32
	ld	%g5, %g5, 0
	subi	%g5, %g5, 1
	ld	%g30, %g1, 28
	st	%g3, %g1, 68
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g3, %g1, 68
	ld	%g4, %g3, 472
	ld	%g4, %g4, 0
	fld	%f0, %g4, 0
	ld	%g5, %g1, 24
	fld	%f1, %g5, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g4, 8
	fld	%f2, %g5, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g4, 16
	fld	%f2, %g5, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.22639
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22640
fble_else.22639:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22640:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g4, %g6, beq_else.22641
	ld	%g4, %g3, 472
	setL %g6, l.15212
	fld	%f1, %g6, 0
	fdiv	%f0, %f0, %f1
	ld	%g30, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	b	beq_cont.22642
beq_else.22641:
	ld	%g4, %g3, 476
	setL %g6, l.15188
	fld	%f1, %g6, 0
	fdiv	%f0, %f0, %f1
	ld	%g30, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
beq_cont.22642:
	mvhi	%g6, 0
	mvlo	%g6, 116
	ld	%g3, %g1, 68
	ld	%g4, %g1, 24
	ld	%g5, %g1, 40
	ld	%g30, %g1, 16
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
beq_cont.22638:
	ld	%g3, %g1, 12
	slli	%g3, %g3, 2
	ld	%g4, %g1, 8
	ld	%g4, %g4, %g3
	ld	%g3, %g1, 4
	ld	%g5, %g1, 0
	jmp	vecaccumv.2840
calc_diffuse_using_5points.3150:
	ld	%g8, %g30, 8
	ld	%g9, %g30, 4
	slli	%g10, %g3, 2
	ld	%g4, %g4, %g10
	ld	%g4, %g4, 20
	subi	%g10, %g3, 1
	slli	%g10, %g10, 2
	ld	%g10, %g5, %g10
	ld	%g10, %g10, 20
	slli	%g11, %g3, 2
	ld	%g11, %g5, %g11
	ld	%g11, %g11, 20
	addi	%g12, %g3, 1
	slli	%g12, %g12, 2
	ld	%g12, %g5, %g12
	ld	%g12, %g12, 20
	slli	%g13, %g3, 2
	ld	%g6, %g6, %g13
	ld	%g6, %g6, 20
	slli	%g13, %g7, 2
	ld	%g4, %g4, %g13
	fld	%f0, %g4, 0
	fst	%f0, %g9, 0
	fld	%f0, %g4, 8
	fst	%f0, %g9, 8
	fld	%f0, %g4, 16
	fst	%f0, %g9, 16
	slli	%g4, %g7, 2
	ld	%g4, %g10, %g4
	fld	%f0, %g9, 0
	fld	%f1, %g4, 0
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, 0
	fld	%f0, %g9, 8
	fld	%f1, %g4, 8
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, 8
	fld	%f0, %g9, 16
	fld	%f1, %g4, 16
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, 16
	slli	%g4, %g7, 2
	ld	%g4, %g11, %g4
	fld	%f0, %g9, 0
	fld	%f1, %g4, 0
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, 0
	fld	%f0, %g9, 8
	fld	%f1, %g4, 8
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, 8
	fld	%f0, %g9, 16
	fld	%f1, %g4, 16
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, 16
	slli	%g4, %g7, 2
	ld	%g4, %g12, %g4
	fld	%f0, %g9, 0
	fld	%f1, %g4, 0
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, 0
	fld	%f0, %g9, 8
	fld	%f1, %g4, 8
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, 8
	fld	%f0, %g9, 16
	fld	%f1, %g4, 16
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, 16
	slli	%g4, %g7, 2
	ld	%g4, %g6, %g4
	fld	%f0, %g9, 0
	fld	%f1, %g4, 0
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, 0
	fld	%f0, %g9, 8
	fld	%f1, %g4, 8
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, 8
	fld	%f0, %g9, 16
	fld	%f1, %g4, 16
	fadd	%f0, %f0, %f1
	fst	%f0, %g9, 16
	slli	%g3, %g3, 2
	ld	%g3, %g5, %g3
	ld	%g3, %g3, 16
	slli	%g4, %g7, 2
	ld	%g4, %g3, %g4
	mov	%g5, %g9
	mov	%g3, %g8
	jmp	vecaccumv.2840
do_without_neighbors.3156:
	ld	%g5, %g30, 16
	ld	%g6, %g30, 12
	ld	%g7, %g30, 8
	ld	%g8, %g30, 4
	mvhi	%g9, 0
	mvlo	%g9, 4
	blt	%g9, %g4, ble_else.22643
	ld	%g9, %g3, 8
	mvhi	%g10, 0
	mvlo	%g10, 0
	slli	%g11, %g4, 2
	ld	%g9, %g9, %g11
	blt	%g9, %g10, ble_else.22644
	ld	%g9, %g3, 12
	slli	%g10, %g4, 2
	ld	%g9, %g9, %g10
	mvhi	%g10, 0
	mvlo	%g10, 0
	st	%g30, %g1, 0
	st	%g8, %g1, 4
	st	%g3, %g1, 8
	st	%g4, %g1, 12
	bne	%g9, %g10, beq_else.22645
	b	beq_cont.22646
beq_else.22645:
	ld	%g9, %g3, 20
	ld	%g10, %g3, 28
	ld	%g11, %g3, 4
	ld	%g12, %g3, 16
	slli	%g13, %g4, 2
	ld	%g9, %g9, %g13
	fld	%f0, %g9, 0
	fst	%f0, %g7, 0
	fld	%f0, %g9, 8
	fst	%f0, %g7, 8
	fld	%f0, %g9, 16
	fst	%f0, %g7, 16
	ld	%g9, %g3, 24
	ld	%g9, %g9, 0
	slli	%g13, %g4, 2
	ld	%g10, %g10, %g13
	slli	%g13, %g4, 2
	ld	%g11, %g11, %g13
	st	%g7, %g1, 16
	st	%g6, %g1, 20
	st	%g12, %g1, 24
	mov	%g4, %g10
	mov	%g3, %g9
	mov	%g30, %g5
	mov	%g5, %g11
	st	%g31, %g1, 28
	ld	%g29, %g30, 0
	addi	%g1, %g1, 32
	call	%g29
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 12
	slli	%g4, %g3, 2
	ld	%g5, %g1, 24
	ld	%g4, %g5, %g4
	ld	%g5, %g1, 20
	ld	%g6, %g1, 16
	mov	%g3, %g5
	mov	%g5, %g6
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	vecaccumv.2840
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
beq_cont.22646:
	ld	%g3, %g1, 12
	addi	%g4, %g3, 1
	mvhi	%g3, 0
	mvlo	%g3, 4
	blt	%g3, %g4, ble_else.22647
	ld	%g3, %g1, 8
	ld	%g5, %g3, 8
	mvhi	%g6, 0
	mvlo	%g6, 0
	slli	%g7, %g4, 2
	ld	%g5, %g5, %g7
	blt	%g5, %g6, ble_else.22648
	ld	%g5, %g3, 12
	slli	%g6, %g4, 2
	ld	%g5, %g5, %g6
	mvhi	%g6, 0
	mvlo	%g6, 0
	st	%g4, %g1, 28
	bne	%g5, %g6, beq_else.22649
	b	beq_cont.22650
beq_else.22649:
	ld	%g30, %g1, 4
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
beq_cont.22650:
	ld	%g3, %g1, 28
	addi	%g4, %g3, 1
	ld	%g3, %g1, 8
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
ble_else.22648:
	return
ble_else.22647:
	return
ble_else.22644:
	return
ble_else.22643:
	return
try_exploit_neighbors.3172:
	ld	%g9, %g30, 12
	ld	%g10, %g30, 8
	ld	%g11, %g30, 4
	slli	%g12, %g3, 2
	ld	%g12, %g6, %g12
	mvhi	%g13, 0
	mvlo	%g13, 4
	blt	%g13, %g8, ble_else.22655
	mvhi	%g13, 0
	mvlo	%g13, 0
	ld	%g14, %g12, 8
	slli	%g15, %g8, 2
	ld	%g14, %g14, %g15
	blt	%g14, %g13, ble_else.22656
	slli	%g13, %g3, 2
	ld	%g13, %g6, %g13
	ld	%g13, %g13, 8
	slli	%g14, %g8, 2
	ld	%g13, %g13, %g14
	slli	%g14, %g3, 2
	ld	%g14, %g5, %g14
	ld	%g14, %g14, 8
	slli	%g15, %g8, 2
	ld	%g14, %g14, %g15
	bne	%g14, %g13, beq_else.22657
	slli	%g14, %g3, 2
	ld	%g14, %g7, %g14
	ld	%g14, %g14, 8
	slli	%g15, %g8, 2
	ld	%g14, %g14, %g15
	bne	%g14, %g13, beq_else.22659
	subi	%g14, %g3, 1
	slli	%g14, %g14, 2
	ld	%g14, %g6, %g14
	ld	%g14, %g14, 8
	slli	%g15, %g8, 2
	ld	%g14, %g14, %g15
	bne	%g14, %g13, beq_else.22661
	addi	%g14, %g3, 1
	slli	%g14, %g14, 2
	ld	%g14, %g6, %g14
	ld	%g14, %g14, 8
	slli	%g15, %g8, 2
	ld	%g14, %g14, %g15
	bne	%g14, %g13, beq_else.22663
	mvhi	%g13, 0
	mvlo	%g13, 1
	b	beq_cont.22664
beq_else.22663:
	mvhi	%g13, 0
	mvlo	%g13, 0
beq_cont.22664:
	b	beq_cont.22662
beq_else.22661:
	mvhi	%g13, 0
	mvlo	%g13, 0
beq_cont.22662:
	b	beq_cont.22660
beq_else.22659:
	mvhi	%g13, 0
	mvlo	%g13, 0
beq_cont.22660:
	b	beq_cont.22658
beq_else.22657:
	mvhi	%g13, 0
	mvlo	%g13, 0
beq_cont.22658:
	mvhi	%g14, 0
	mvlo	%g14, 0
	bne	%g13, %g14, beq_else.22665
	slli	%g3, %g3, 2
	ld	%g3, %g6, %g3
	mvhi	%g4, 0
	mvlo	%g4, 4
	blt	%g4, %g8, ble_else.22666
	ld	%g4, %g3, 8
	mvhi	%g5, 0
	mvlo	%g5, 0
	slli	%g6, %g8, 2
	ld	%g4, %g4, %g6
	blt	%g4, %g5, ble_else.22667
	ld	%g4, %g3, 12
	slli	%g5, %g8, 2
	ld	%g4, %g4, %g5
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 0
	st	%g9, %g1, 4
	st	%g8, %g1, 8
	bne	%g4, %g5, beq_else.22668
	b	beq_cont.22669
beq_else.22668:
	mov	%g4, %g8
	mov	%g30, %g11
	st	%g31, %g1, 12
	ld	%g29, %g30, 0
	addi	%g1, %g1, 16
	call	%g29
	subi	%g1, %g1, 16
	ld	%g31, %g1, 12
beq_cont.22669:
	ld	%g3, %g1, 8
	addi	%g4, %g3, 1
	ld	%g3, %g1, 0
	ld	%g30, %g1, 4
	ld	%g30, 0, %g29
	b	%g29
ble_else.22667:
	return
ble_else.22666:
	return
beq_else.22665:
	ld	%g11, %g12, 12
	slli	%g12, %g8, 2
	ld	%g11, %g11, %g12
	mvhi	%g12, 0
	mvlo	%g12, 0
	st	%g4, %g1, 12
	st	%g30, %g1, 16
	st	%g10, %g1, 20
	st	%g9, %g1, 4
	st	%g7, %g1, 24
	st	%g5, %g1, 28
	st	%g6, %g1, 32
	st	%g3, %g1, 36
	st	%g8, %g1, 8
	bne	%g11, %g12, beq_else.22672
	b	beq_cont.22673
beq_else.22672:
	mov	%g4, %g5
	mov	%g30, %g10
	mov	%g5, %g6
	mov	%g6, %g7
	mov	%g7, %g8
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
beq_cont.22673:
	ld	%g3, %g1, 8
	addi	%g4, %g3, 1
	ld	%g3, %g1, 36
	slli	%g5, %g3, 2
	ld	%g6, %g1, 32
	ld	%g5, %g6, %g5
	mvhi	%g7, 0
	mvlo	%g7, 4
	blt	%g7, %g4, ble_else.22674
	mvhi	%g7, 0
	mvlo	%g7, 0
	ld	%g8, %g5, 8
	slli	%g9, %g4, 2
	ld	%g8, %g8, %g9
	blt	%g8, %g7, ble_else.22675
	slli	%g7, %g3, 2
	ld	%g7, %g6, %g7
	ld	%g7, %g7, 8
	slli	%g8, %g4, 2
	ld	%g7, %g7, %g8
	slli	%g8, %g3, 2
	ld	%g9, %g1, 28
	ld	%g8, %g9, %g8
	ld	%g8, %g8, 8
	slli	%g10, %g4, 2
	ld	%g8, %g8, %g10
	bne	%g8, %g7, beq_else.22676
	slli	%g8, %g3, 2
	ld	%g10, %g1, 24
	ld	%g8, %g10, %g8
	ld	%g8, %g8, 8
	slli	%g11, %g4, 2
	ld	%g8, %g8, %g11
	bne	%g8, %g7, beq_else.22678
	subi	%g8, %g3, 1
	slli	%g8, %g8, 2
	ld	%g8, %g6, %g8
	ld	%g8, %g8, 8
	slli	%g11, %g4, 2
	ld	%g8, %g8, %g11
	bne	%g8, %g7, beq_else.22680
	addi	%g8, %g3, 1
	slli	%g8, %g8, 2
	ld	%g8, %g6, %g8
	ld	%g8, %g8, 8
	slli	%g11, %g4, 2
	ld	%g8, %g8, %g11
	bne	%g8, %g7, beq_else.22682
	mvhi	%g7, 0
	mvlo	%g7, 1
	b	beq_cont.22683
beq_else.22682:
	mvhi	%g7, 0
	mvlo	%g7, 0
beq_cont.22683:
	b	beq_cont.22681
beq_else.22680:
	mvhi	%g7, 0
	mvlo	%g7, 0
beq_cont.22681:
	b	beq_cont.22679
beq_else.22678:
	mvhi	%g7, 0
	mvlo	%g7, 0
beq_cont.22679:
	b	beq_cont.22677
beq_else.22676:
	mvhi	%g7, 0
	mvlo	%g7, 0
beq_cont.22677:
	mvhi	%g8, 0
	mvlo	%g8, 0
	bne	%g7, %g8, beq_else.22684
	slli	%g3, %g3, 2
	ld	%g3, %g6, %g3
	ld	%g30, %g1, 4
	ld	%g30, 0, %g29
	b	%g29
beq_else.22684:
	ld	%g5, %g5, 12
	slli	%g7, %g4, 2
	ld	%g5, %g5, %g7
	mvhi	%g7, 0
	mvlo	%g7, 0
	st	%g4, %g1, 40
	bne	%g5, %g7, beq_else.22685
	b	beq_cont.22686
beq_else.22685:
	ld	%g5, %g1, 24
	ld	%g30, %g1, 20
	mov	%g7, %g4
	mov	%g4, %g9
	mov	%g29, %g6
	mov	%g6, %g5
	mov	%g5, %g29
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
beq_cont.22686:
	ld	%g3, %g1, 40
	addi	%g8, %g3, 1
	ld	%g3, %g1, 36
	ld	%g4, %g1, 12
	ld	%g5, %g1, 28
	ld	%g6, %g1, 32
	ld	%g7, %g1, 24
	ld	%g30, %g1, 16
	ld	%g30, 0, %g29
	b	%g29
ble_else.22675:
	return
ble_else.22674:
	return
ble_else.22656:
	return
ble_else.22655:
	return
write_ppm_header.3179:
	mvhi	%g3, 0
	mvlo	%g3, 80
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_write
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 54
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_write
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 10
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_write
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 49
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_write
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 50
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_write
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 56
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_write
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 32
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_write
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 49
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_write
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 50
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_write
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 56
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_write
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 32
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_write
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 50
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_write
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 53
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_write
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 53
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_write
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 10
	jmp	min_caml_write
write_rgb.3183:
	ld	%g3, %g30, 4
	fld	%f0, %g3, 0
	st	%g3, %g1, 0
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_int_of_float
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 255
	blt	%g4, %g3, ble_else.22691
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22693
	b	ble_cont.22694
ble_else.22693:
	mvhi	%g3, 0
	mvlo	%g3, 0
ble_cont.22694:
	b	ble_cont.22692
ble_else.22691:
	mvhi	%g3, 0
	mvlo	%g3, 255
ble_cont.22692:
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_write
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g3, %g1, 0
	fld	%f0, %g3, 8
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_int_of_float
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 255
	blt	%g4, %g3, ble_else.22695
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22697
	b	ble_cont.22698
ble_else.22697:
	mvhi	%g3, 0
	mvlo	%g3, 0
ble_cont.22698:
	b	ble_cont.22696
ble_else.22695:
	mvhi	%g3, 0
	mvlo	%g3, 255
ble_cont.22696:
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_write
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g3, %g1, 0
	fld	%f0, %g3, 16
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_int_of_float
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 255
	blt	%g4, %g3, ble_else.22699
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22701
	b	ble_cont.22702
ble_else.22701:
	mvhi	%g3, 0
	mvlo	%g3, 0
ble_cont.22702:
	b	ble_cont.22700
ble_else.22699:
	mvhi	%g3, 0
	mvlo	%g3, 255
ble_cont.22700:
	jmp	min_caml_write
pretrace_diffuse_rays.3185:
	ld	%g5, %g30, 28
	ld	%g6, %g30, 24
	ld	%g7, %g30, 20
	ld	%g8, %g30, 16
	ld	%g9, %g30, 12
	ld	%g10, %g30, 8
	ld	%g11, %g30, 4
	mvhi	%g12, 0
	mvlo	%g12, 4
	blt	%g12, %g4, ble_else.22703
	ld	%g12, %g3, 8
	slli	%g13, %g4, 2
	ld	%g12, %g12, %g13
	mvhi	%g13, 0
	mvlo	%g13, 0
	blt	%g12, %g13, ble_else.22704
	ld	%g12, %g3, 12
	slli	%g13, %g4, 2
	ld	%g12, %g12, %g13
	mvhi	%g13, 0
	mvlo	%g13, 0
	st	%g30, %g1, 0
	st	%g9, %g1, 4
	st	%g5, %g1, 8
	st	%g7, %g1, 12
	st	%g8, %g1, 16
	st	%g6, %g1, 20
	st	%g10, %g1, 24
	st	%g11, %g1, 28
	st	%g4, %g1, 32
	bne	%g12, %g13, beq_else.22705
	b	beq_cont.22706
beq_else.22705:
	ld	%g12, %g3, 24
	ld	%g12, %g12, 0
	setL %g13, l.14007
	fld	%f0, %g13, 0
	fst	%f0, %g11, 0
	fst	%f0, %g11, 8
	fst	%f0, %g11, 16
	ld	%g13, %g3, 28
	ld	%g14, %g3, 4
	slli	%g12, %g12, 2
	ld	%g12, %g10, %g12
	slli	%g15, %g4, 2
	ld	%g13, %g13, %g15
	slli	%g15, %g4, 2
	ld	%g14, %g14, %g15
	fld	%f0, %g14, 0
	fst	%f0, %g6, 0
	fld	%f0, %g14, 8
	fst	%f0, %g6, 8
	fld	%f0, %g14, 16
	fst	%f0, %g6, 16
	ld	%g15, %g8, 0
	subi	%g15, %g15, 1
	st	%g3, %g1, 36
	st	%g14, %g1, 40
	st	%g13, %g1, 44
	st	%g12, %g1, 48
	mov	%g4, %g15
	mov	%g3, %g14
	mov	%g30, %g7
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g6, 0
	mvlo	%g6, 118
	ld	%g3, %g1, 48
	ld	%g4, %g1, 44
	ld	%g5, %g1, 40
	ld	%g30, %g1, 4
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 36
	ld	%g4, %g3, 20
	ld	%g5, %g1, 32
	slli	%g6, %g5, 2
	ld	%g4, %g4, %g6
	ld	%g6, %g1, 28
	fld	%f0, %g6, 0
	fst	%f0, %g4, 0
	fld	%f0, %g6, 8
	fst	%f0, %g4, 8
	fld	%f0, %g6, 16
	fst	%f0, %g4, 16
beq_cont.22706:
	ld	%g4, %g1, 32
	addi	%g4, %g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 4
	blt	%g5, %g4, ble_else.22707
	ld	%g5, %g3, 8
	slli	%g6, %g4, 2
	ld	%g5, %g5, %g6
	mvhi	%g6, 0
	mvlo	%g6, 0
	blt	%g5, %g6, ble_else.22708
	ld	%g5, %g3, 12
	slli	%g6, %g4, 2
	ld	%g5, %g5, %g6
	mvhi	%g6, 0
	mvlo	%g6, 0
	st	%g4, %g1, 52
	bne	%g5, %g6, beq_else.22709
	b	beq_cont.22710
beq_else.22709:
	ld	%g5, %g3, 24
	ld	%g5, %g5, 0
	setL %g6, l.14007
	fld	%f0, %g6, 0
	ld	%g6, %g1, 28
	fst	%f0, %g6, 0
	fst	%f0, %g6, 8
	fst	%f0, %g6, 16
	ld	%g7, %g3, 28
	ld	%g8, %g3, 4
	slli	%g5, %g5, 2
	ld	%g9, %g1, 24
	ld	%g5, %g9, %g5
	slli	%g9, %g4, 2
	ld	%g7, %g7, %g9
	slli	%g9, %g4, 2
	ld	%g8, %g8, %g9
	fld	%f0, %g8, 0
	ld	%g9, %g1, 20
	fst	%f0, %g9, 0
	fld	%f0, %g8, 8
	fst	%f0, %g9, 8
	fld	%f0, %g8, 16
	fst	%f0, %g9, 16
	ld	%g9, %g1, 16
	ld	%g9, %g9, 0
	subi	%g9, %g9, 1
	ld	%g30, %g1, 12
	st	%g3, %g1, 36
	st	%g8, %g1, 56
	st	%g7, %g1, 60
	st	%g5, %g1, 64
	mov	%g4, %g9
	mov	%g3, %g8
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 64
	ld	%g4, %g3, 472
	ld	%g4, %g4, 0
	fld	%f0, %g4, 0
	ld	%g5, %g1, 60
	fld	%f1, %g5, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g4, 8
	fld	%f2, %g5, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g4, 16
	fld	%f2, %g5, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.22711
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22712
fble_else.22711:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22712:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g4, %g6, beq_else.22713
	ld	%g4, %g3, 472
	setL %g6, l.15212
	fld	%f1, %g6, 0
	fdiv	%f0, %f0, %f1
	ld	%g30, %g1, 8
	mov	%g3, %g4
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	b	beq_cont.22714
beq_else.22713:
	ld	%g4, %g3, 476
	setL %g6, l.15188
	fld	%f1, %g6, 0
	fdiv	%f0, %f0, %f1
	ld	%g30, %g1, 8
	mov	%g3, %g4
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
beq_cont.22714:
	mvhi	%g6, 0
	mvlo	%g6, 116
	ld	%g3, %g1, 64
	ld	%g4, %g1, 60
	ld	%g5, %g1, 56
	ld	%g30, %g1, 4
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 36
	ld	%g4, %g3, 20
	ld	%g5, %g1, 52
	slli	%g6, %g5, 2
	ld	%g4, %g4, %g6
	ld	%g6, %g1, 28
	fld	%f0, %g6, 0
	fst	%f0, %g4, 0
	fld	%f0, %g6, 8
	fst	%f0, %g4, 8
	fld	%f0, %g6, 16
	fst	%f0, %g4, 16
beq_cont.22710:
	ld	%g4, %g1, 52
	addi	%g4, %g4, 1
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
ble_else.22708:
	return
ble_else.22707:
	return
ble_else.22704:
	return
ble_else.22703:
	return
pretrace_pixels.3188:
	ld	%g6, %g30, 64
	ld	%g7, %g30, 60
	ld	%g8, %g30, 56
	ld	%g9, %g30, 52
	ld	%g10, %g30, 48
	ld	%g11, %g30, 44
	ld	%g12, %g30, 40
	ld	%g13, %g30, 36
	ld	%g14, %g30, 32
	ld	%g15, %g30, 28
	ld	%g16, %g30, 24
	ld	%g17, %g30, 20
	ld	%g18, %g30, 16
	ld	%g19, %g30, 12
	ld	%g20, %g30, 8
	ld	%g21, %g30, 4
	mvhi	%g22, 0
	mvlo	%g22, 0
	blt	%g4, %g22, ble_else.22719
	fld	%f3, %g13, 0
	ld	%g13, %g19, 0
	sub	%g13, %g4, %g13
	st	%g30, %g1, 0
	st	%g16, %g1, 4
	st	%g18, %g1, 8
	st	%g8, %g1, 12
	st	%g11, %g1, 16
	st	%g17, %g1, 20
	st	%g9, %g1, 24
	st	%g20, %g1, 28
	st	%g21, %g1, 32
	st	%g5, %g1, 36
	st	%g7, %g1, 40
	st	%g3, %g1, 44
	st	%g4, %g1, 48
	st	%g10, %g1, 52
	st	%g6, %g1, 56
	st	%g14, %g1, 60
	std	%f2, %g1, 64
	std	%f1, %g1, 72
	st	%g15, %g1, 80
	std	%f0, %g1, 88
	st	%g12, %g1, 96
	std	%f3, %g1, 104
	mov	%g3, %g13
	st	%g31, %g1, 116
	addi	%g1, %g1, 120
	call	min_caml_float_of_int
	subi	%g1, %g1, 120
	ld	%g31, %g1, 116
	fld	%f1, %g1, 104
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 96
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	fld	%f2, %g1, 88
	fadd	%f1, %f1, %f2
	ld	%g4, %g1, 80
	fst	%f1, %g4, 0
	fld	%f1, %g3, 8
	fmul	%f1, %f0, %f1
	fld	%f3, %g1, 72
	fadd	%f1, %f1, %f3
	fst	%f1, %g4, 8
	fld	%f1, %g3, 16
	fmul	%f0, %f0, %f1
	fld	%f1, %g1, 64
	fadd	%f0, %f0, %f1
	fst	%f0, %g4, 16
	mvhi	%g3, 0
	mvlo	%g3, 0
	mov	%g29, %g4
	mov	%g4, %g3
	mov	%g3, %g29
	st	%g31, %g1, 116
	addi	%g1, %g1, 120
	call	vecunit_sgn.2816
	subi	%g1, %g1, 120
	ld	%g31, %g1, 116
	setL %g3, l.14007
	fld	%f0, %g3, 0
	ld	%g3, %g1, 60
	fst	%f0, %g3, 0
	fst	%f0, %g3, 8
	fst	%f0, %g3, 16
	ld	%g4, %g1, 56
	fld	%f0, %g4, 0
	ld	%g5, %g1, 52
	fst	%f0, %g5, 0
	fld	%f0, %g4, 8
	fst	%f0, %g5, 8
	fld	%f0, %g4, 16
	fst	%f0, %g5, 16
	mvhi	%g4, 0
	mvlo	%g4, 0
	setL %g5, l.14053
	fld	%f0, %g5, 0
	ld	%g5, %g1, 48
	slli	%g6, %g5, 2
	ld	%g7, %g1, 44
	ld	%g6, %g7, %g6
	setL %g8, l.14007
	fld	%f1, %g8, 0
	ld	%g8, %g1, 80
	ld	%g30, %g1, 40
	mov	%g5, %g6
	mov	%g3, %g4
	mov	%g4, %g8
	st	%g31, %g1, 116
	ld	%g29, %g30, 0
	addi	%g1, %g1, 120
	call	%g29
	subi	%g1, %g1, 120
	ld	%g31, %g1, 116
	ld	%g3, %g1, 48
	slli	%g4, %g3, 2
	ld	%g5, %g1, 44
	ld	%g4, %g5, %g4
	ld	%g4, %g4, 0
	ld	%g6, %g1, 60
	fld	%f0, %g6, 0
	fst	%f0, %g4, 0
	fld	%f0, %g6, 8
	fst	%f0, %g4, 8
	fld	%f0, %g6, 16
	fst	%f0, %g4, 16
	slli	%g4, %g3, 2
	ld	%g4, %g5, %g4
	ld	%g4, %g4, 24
	ld	%g6, %g1, 36
	st	%g6, %g4, 0
	slli	%g4, %g3, 2
	ld	%g4, %g5, %g4
	ld	%g7, %g4, 8
	ld	%g7, %g7, 0
	mvhi	%g8, 0
	mvlo	%g8, 0
	blt	%g7, %g8, ble_else.22722
	ld	%g7, %g4, 12
	ld	%g7, %g7, 0
	mvhi	%g8, 0
	mvlo	%g8, 0
	st	%g4, %g1, 112
	bne	%g7, %g8, beq_else.22724
	b	beq_cont.22725
beq_else.22724:
	ld	%g7, %g4, 24
	ld	%g7, %g7, 0
	setL %g8, l.14007
	fld	%f0, %g8, 0
	ld	%g8, %g1, 32
	fst	%f0, %g8, 0
	fst	%f0, %g8, 8
	fst	%f0, %g8, 16
	ld	%g9, %g4, 28
	ld	%g10, %g4, 4
	slli	%g7, %g7, 2
	ld	%g11, %g1, 28
	ld	%g7, %g11, %g7
	ld	%g9, %g9, 0
	ld	%g10, %g10, 0
	fld	%f0, %g10, 0
	ld	%g11, %g1, 24
	fst	%f0, %g11, 0
	fld	%f0, %g10, 8
	fst	%f0, %g11, 8
	fld	%f0, %g10, 16
	fst	%f0, %g11, 16
	ld	%g11, %g1, 20
	ld	%g11, %g11, 0
	subi	%g11, %g11, 1
	ld	%g30, %g1, 16
	st	%g10, %g1, 116
	st	%g9, %g1, 120
	st	%g7, %g1, 124
	mov	%g4, %g11
	mov	%g3, %g10
	st	%g31, %g1, 132
	ld	%g29, %g30, 0
	addi	%g1, %g1, 136
	call	%g29
	subi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g3, %g1, 124
	ld	%g4, %g3, 472
	ld	%g4, %g4, 0
	fld	%f0, %g4, 0
	ld	%g5, %g1, 120
	fld	%f1, %g5, 0
	fmul	%f0, %f0, %f1
	fld	%f1, %g4, 8
	fld	%f2, %g5, 8
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	fld	%f1, %g4, 16
	fld	%f2, %g5, 16
	fmul	%f1, %f1, %f2
	fadd	%f0, %f0, %f1
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fblt	%f0, %f1, fble_else.22726
	mvhi	%g4, 0
	mvlo	%g4, 1
	b	fble_cont.22727
fble_else.22726:
	mvhi	%g4, 0
	mvlo	%g4, 0
fble_cont.22727:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g4, %g6, beq_else.22728
	ld	%g4, %g3, 472
	setL %g6, l.15212
	fld	%f1, %g6, 0
	fdiv	%f0, %f0, %f1
	ld	%g30, %g1, 12
	mov	%g3, %g4
	st	%g31, %g1, 132
	ld	%g29, %g30, 0
	addi	%g1, %g1, 136
	call	%g29
	subi	%g1, %g1, 136
	ld	%g31, %g1, 132
	b	beq_cont.22729
beq_else.22728:
	ld	%g4, %g3, 476
	setL %g6, l.15188
	fld	%f1, %g6, 0
	fdiv	%f0, %f0, %f1
	ld	%g30, %g1, 12
	mov	%g3, %g4
	st	%g31, %g1, 132
	ld	%g29, %g30, 0
	addi	%g1, %g1, 136
	call	%g29
	subi	%g1, %g1, 136
	ld	%g31, %g1, 132
beq_cont.22729:
	mvhi	%g6, 0
	mvlo	%g6, 116
	ld	%g3, %g1, 124
	ld	%g4, %g1, 120
	ld	%g5, %g1, 116
	ld	%g30, %g1, 8
	st	%g31, %g1, 132
	ld	%g29, %g30, 0
	addi	%g1, %g1, 136
	call	%g29
	subi	%g1, %g1, 136
	ld	%g31, %g1, 132
	ld	%g3, %g1, 112
	ld	%g4, %g3, 20
	ld	%g4, %g4, 0
	ld	%g5, %g1, 32
	fld	%f0, %g5, 0
	fst	%f0, %g4, 0
	fld	%f0, %g5, 8
	fst	%f0, %g4, 8
	fld	%f0, %g5, 16
	fst	%f0, %g4, 16
beq_cont.22725:
	mvhi	%g4, 0
	mvlo	%g4, 1
	ld	%g3, %g1, 112
	ld	%g30, %g1, 4
	st	%g31, %g1, 132
	ld	%g29, %g30, 0
	addi	%g1, %g1, 136
	call	%g29
	subi	%g1, %g1, 136
	ld	%g31, %g1, 132
	b	ble_cont.22723
ble_else.22722:
ble_cont.22723:
	ld	%g3, %g1, 48
	subi	%g4, %g3, 1
	ld	%g3, %g1, 36
	addi	%g3, %g3, 1
	mvhi	%g5, 0
	mvlo	%g5, 5
	blt	%g3, %g5, ble_else.22730
	subi	%g5, %g3, 5
	b	ble_cont.22731
ble_else.22730:
	mov	%g5, %g3
ble_cont.22731:
	fld	%f0, %g1, 88
	fld	%f1, %g1, 72
	fld	%f2, %g1, 64
	ld	%g3, %g1, 44
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
ble_else.22719:
	return
pretrace_line.3195:
	ld	%g6, %g30, 24
	ld	%g7, %g30, 20
	ld	%g8, %g30, 16
	ld	%g9, %g30, 12
	ld	%g10, %g30, 8
	ld	%g11, %g30, 4
	fld	%f0, %g8, 0
	ld	%g8, %g11, 4
	sub	%g4, %g4, %g8
	st	%g5, %g1, 0
	st	%g3, %g1, 4
	st	%g9, %g1, 8
	st	%g10, %g1, 12
	st	%g6, %g1, 16
	st	%g7, %g1, 20
	std	%f0, %g1, 24
	mov	%g3, %g4
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_float_of_int
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 20
	fld	%f1, %g3, 0
	fmul	%f1, %f0, %f1
	ld	%g4, %g1, 16
	fld	%f2, %g4, 0
	fadd	%f1, %f1, %f2
	fld	%f2, %g3, 8
	fmul	%f2, %f0, %f2
	fld	%f3, %g4, 8
	fadd	%f2, %f2, %f3
	fld	%f3, %g3, 16
	fmul	%f0, %f0, %f3
	fld	%f3, %g4, 16
	fadd	%f0, %f0, %f3
	ld	%g3, %g1, 12
	ld	%g3, %g3, 0
	subi	%g4, %g3, 1
	ld	%g3, %g1, 4
	ld	%g5, %g1, 0
	ld	%g30, %g1, 8
	fmov	%f31, %f2
	fmov	%f2, %f0
	fmov	%f0, %f1
	fmov	%f1, %f31
	ld	%g30, 0, %g29
	b	%g29
scan_pixel.3199:
	ld	%g8, %g30, 28
	ld	%g9, %g30, 24
	ld	%g10, %g30, 20
	ld	%g11, %g30, 16
	ld	%g12, %g30, 12
	ld	%g13, %g30, 8
	ld	%g14, %g30, 4
	ld	%g15, %g11, 0
	blt	%g3, %g15, ble_else.22733
	return
ble_else.22733:
	slli	%g15, %g3, 2
	ld	%g15, %g6, %g15
	ld	%g15, %g15, 0
	fld	%f0, %g15, 0
	fst	%f0, %g10, 0
	fld	%f0, %g15, 8
	fst	%f0, %g10, 8
	fld	%f0, %g15, 16
	fst	%f0, %g10, 16
	ld	%g15, %g11, 4
	addi	%g16, %g4, 1
	blt	%g16, %g15, ble_else.22735
	mvhi	%g15, 0
	mvlo	%g15, 0
	b	ble_cont.22736
ble_else.22735:
	mvhi	%g15, 0
	mvlo	%g15, 0
	blt	%g15, %g4, ble_else.22737
	mvhi	%g15, 0
	mvlo	%g15, 0
	b	ble_cont.22738
ble_else.22737:
	ld	%g15, %g11, 0
	addi	%g16, %g3, 1
	blt	%g16, %g15, ble_else.22739
	mvhi	%g15, 0
	mvlo	%g15, 0
	b	ble_cont.22740
ble_else.22739:
	mvhi	%g15, 0
	mvlo	%g15, 0
	blt	%g15, %g3, ble_else.22741
	mvhi	%g15, 0
	mvlo	%g15, 0
	b	ble_cont.22742
ble_else.22741:
	mvhi	%g15, 0
	mvlo	%g15, 1
ble_cont.22742:
ble_cont.22740:
ble_cont.22738:
ble_cont.22736:
	mvhi	%g16, 0
	mvlo	%g16, 0
	st	%g30, %g1, 0
	st	%g8, %g1, 4
	st	%g7, %g1, 8
	st	%g5, %g1, 12
	st	%g9, %g1, 16
	st	%g12, %g1, 20
	st	%g4, %g1, 24
	st	%g6, %g1, 28
	st	%g11, %g1, 32
	st	%g3, %g1, 36
	st	%g10, %g1, 40
	bne	%g15, %g16, beq_else.22743
	slli	%g13, %g3, 2
	ld	%g13, %g6, %g13
	mvhi	%g15, 0
	mvlo	%g15, 0
	ld	%g16, %g13, 8
	mvhi	%g17, 0
	mvlo	%g17, 0
	ld	%g16, %g16, 0
	blt	%g16, %g17, ble_else.22745
	ld	%g16, %g13, 12
	ld	%g16, %g16, 0
	mvhi	%g17, 0
	mvlo	%g17, 0
	st	%g13, %g1, 44
	bne	%g16, %g17, beq_else.22747
	b	beq_cont.22748
beq_else.22747:
	mov	%g4, %g15
	mov	%g3, %g13
	mov	%g30, %g14
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
beq_cont.22748:
	mvhi	%g4, 0
	mvlo	%g4, 1
	ld	%g3, %g1, 44
	ld	%g30, %g1, 20
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	b	ble_cont.22746
ble_else.22745:
ble_cont.22746:
	b	beq_cont.22744
beq_else.22743:
	mvhi	%g14, 0
	mvlo	%g14, 0
	slli	%g15, %g3, 2
	ld	%g15, %g6, %g15
	mvhi	%g16, 0
	mvlo	%g16, 0
	ld	%g17, %g15, 8
	ld	%g17, %g17, 0
	blt	%g17, %g16, ble_else.22749
	slli	%g16, %g3, 2
	ld	%g16, %g6, %g16
	ld	%g16, %g16, 8
	ld	%g16, %g16, 0
	slli	%g17, %g3, 2
	ld	%g17, %g5, %g17
	ld	%g17, %g17, 8
	ld	%g17, %g17, 0
	bne	%g17, %g16, beq_else.22751
	slli	%g17, %g3, 2
	ld	%g17, %g7, %g17
	ld	%g17, %g17, 8
	ld	%g17, %g17, 0
	bne	%g17, %g16, beq_else.22753
	subi	%g17, %g3, 1
	slli	%g17, %g17, 2
	ld	%g17, %g6, %g17
	ld	%g17, %g17, 8
	ld	%g17, %g17, 0
	bne	%g17, %g16, beq_else.22755
	addi	%g17, %g3, 1
	slli	%g17, %g17, 2
	ld	%g17, %g6, %g17
	ld	%g17, %g17, 8
	ld	%g17, %g17, 0
	bne	%g17, %g16, beq_else.22757
	mvhi	%g16, 0
	mvlo	%g16, 1
	b	beq_cont.22758
beq_else.22757:
	mvhi	%g16, 0
	mvlo	%g16, 0
beq_cont.22758:
	b	beq_cont.22756
beq_else.22755:
	mvhi	%g16, 0
	mvlo	%g16, 0
beq_cont.22756:
	b	beq_cont.22754
beq_else.22753:
	mvhi	%g16, 0
	mvlo	%g16, 0
beq_cont.22754:
	b	beq_cont.22752
beq_else.22751:
	mvhi	%g16, 0
	mvlo	%g16, 0
beq_cont.22752:
	mvhi	%g17, 0
	mvlo	%g17, 0
	bne	%g16, %g17, beq_else.22759
	slli	%g13, %g3, 2
	ld	%g13, %g6, %g13
	mov	%g4, %g14
	mov	%g3, %g13
	mov	%g30, %g12
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	b	beq_cont.22760
beq_else.22759:
	ld	%g15, %g15, 12
	ld	%g15, %g15, 0
	mvhi	%g16, 0
	mvlo	%g16, 0
	bne	%g15, %g16, beq_else.22761
	b	beq_cont.22762
beq_else.22761:
	mov	%g4, %g5
	mov	%g30, %g13
	mov	%g5, %g6
	mov	%g6, %g7
	mov	%g7, %g14
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
beq_cont.22762:
	mvhi	%g8, 0
	mvlo	%g8, 1
	ld	%g3, %g1, 36
	ld	%g4, %g1, 24
	ld	%g5, %g1, 12
	ld	%g6, %g1, 28
	ld	%g7, %g1, 8
	ld	%g30, %g1, 16
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
beq_cont.22760:
	b	ble_cont.22750
ble_else.22749:
ble_cont.22750:
beq_cont.22744:
	ld	%g3, %g1, 40
	fld	%f0, %g3, 0
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_int_of_float
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 255
	blt	%g4, %g3, ble_else.22763
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22765
	b	ble_cont.22766
ble_else.22765:
	mvhi	%g3, 0
	mvlo	%g3, 0
ble_cont.22766:
	b	ble_cont.22764
ble_else.22763:
	mvhi	%g3, 0
	mvlo	%g3, 255
ble_cont.22764:
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_write
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 40
	fld	%f0, %g3, 8
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_int_of_float
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 255
	blt	%g4, %g3, ble_else.22767
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22769
	b	ble_cont.22770
ble_else.22769:
	mvhi	%g3, 0
	mvlo	%g3, 0
ble_cont.22770:
	b	ble_cont.22768
ble_else.22767:
	mvhi	%g3, 0
	mvlo	%g3, 255
ble_cont.22768:
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_write
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 40
	fld	%f0, %g3, 16
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_int_of_float
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 255
	blt	%g4, %g3, ble_else.22771
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22773
	b	ble_cont.22774
ble_else.22773:
	mvhi	%g3, 0
	mvlo	%g3, 0
ble_cont.22774:
	b	ble_cont.22772
ble_else.22771:
	mvhi	%g3, 0
	mvlo	%g3, 255
ble_cont.22772:
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_write
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 36
	addi	%g3, %g3, 1
	ld	%g4, %g1, 32
	ld	%g5, %g4, 0
	blt	%g3, %g5, ble_else.22775
	return
ble_else.22775:
	slli	%g5, %g3, 2
	ld	%g6, %g1, 28
	ld	%g5, %g6, %g5
	ld	%g5, %g5, 0
	fld	%f0, %g5, 0
	ld	%g7, %g1, 40
	fst	%f0, %g7, 0
	fld	%f0, %g5, 8
	fst	%f0, %g7, 8
	fld	%f0, %g5, 16
	fst	%f0, %g7, 16
	ld	%g5, %g4, 4
	ld	%g7, %g1, 24
	addi	%g8, %g7, 1
	blt	%g8, %g5, ble_else.22777
	mvhi	%g4, 0
	mvlo	%g4, 0
	b	ble_cont.22778
ble_else.22777:
	mvhi	%g5, 0
	mvlo	%g5, 0
	blt	%g5, %g7, ble_else.22779
	mvhi	%g4, 0
	mvlo	%g4, 0
	b	ble_cont.22780
ble_else.22779:
	ld	%g4, %g4, 0
	addi	%g5, %g3, 1
	blt	%g5, %g4, ble_else.22781
	mvhi	%g4, 0
	mvlo	%g4, 0
	b	ble_cont.22782
ble_else.22781:
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g4, %g3, ble_else.22783
	mvhi	%g4, 0
	mvlo	%g4, 0
	b	ble_cont.22784
ble_else.22783:
	mvhi	%g4, 0
	mvlo	%g4, 1
ble_cont.22784:
ble_cont.22782:
ble_cont.22780:
ble_cont.22778:
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 48
	bne	%g4, %g5, beq_else.22785
	slli	%g4, %g3, 2
	ld	%g4, %g6, %g4
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g30, %g1, 20
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	b	beq_cont.22786
beq_else.22785:
	mvhi	%g8, 0
	mvlo	%g8, 0
	ld	%g5, %g1, 12
	ld	%g4, %g1, 8
	ld	%g30, %g1, 16
	mov	%g29, %g7
	mov	%g7, %g4
	mov	%g4, %g29
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
beq_cont.22786:
	ld	%g30, %g1, 4
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	ld	%g3, %g1, 48
	addi	%g3, %g3, 1
	ld	%g4, %g1, 24
	ld	%g5, %g1, 12
	ld	%g6, %g1, 28
	ld	%g7, %g1, 8
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
scan_line.3205:
	ld	%g8, %g30, 28
	ld	%g9, %g30, 24
	ld	%g10, %g30, 20
	ld	%g11, %g30, 16
	ld	%g12, %g30, 12
	ld	%g13, %g30, 8
	ld	%g14, %g30, 4
	ld	%g15, %g13, 4
	blt	%g3, %g15, ble_else.22787
	return
ble_else.22787:
	ld	%g15, %g13, 4
	subi	%g15, %g15, 1
	st	%g30, %g1, 0
	st	%g12, %g1, 4
	st	%g7, %g1, 8
	st	%g10, %g1, 12
	st	%g8, %g1, 16
	st	%g6, %g1, 20
	st	%g4, %g1, 24
	st	%g9, %g1, 28
	st	%g14, %g1, 32
	st	%g3, %g1, 36
	st	%g11, %g1, 40
	st	%g5, %g1, 44
	st	%g13, %g1, 48
	blt	%g3, %g15, ble_else.22789
	b	ble_cont.22790
ble_else.22789:
	addi	%g15, %g3, 1
	mov	%g5, %g7
	mov	%g4, %g15
	mov	%g3, %g6
	mov	%g30, %g12
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
ble_cont.22790:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 48
	ld	%g5, %g4, 0
	blt	%g3, %g5, ble_else.22791
	b	ble_cont.22792
ble_else.22791:
	ld	%g6, %g1, 44
	ld	%g5, %g6, 0
	ld	%g5, %g5, 0
	fld	%f0, %g5, 0
	ld	%g7, %g1, 40
	fst	%f0, %g7, 0
	fld	%f0, %g5, 8
	fst	%f0, %g7, 8
	fld	%f0, %g5, 16
	fst	%f0, %g7, 16
	ld	%g5, %g4, 4
	ld	%g7, %g1, 36
	addi	%g8, %g7, 1
	blt	%g8, %g5, ble_else.22793
	mvhi	%g5, 0
	mvlo	%g5, 0
	b	ble_cont.22794
ble_else.22793:
	mvhi	%g5, 0
	mvlo	%g5, 0
	blt	%g5, %g7, ble_else.22795
	mvhi	%g5, 0
	mvlo	%g5, 0
	b	ble_cont.22796
ble_else.22795:
	ld	%g5, %g4, 0
	mvhi	%g8, 0
	mvlo	%g8, 1
	blt	%g8, %g5, ble_else.22797
	mvhi	%g5, 0
	mvlo	%g5, 0
	b	ble_cont.22798
ble_else.22797:
	mvhi	%g5, 0
	mvlo	%g5, 0
ble_cont.22798:
ble_cont.22796:
ble_cont.22794:
	mvhi	%g8, 0
	mvlo	%g8, 0
	bne	%g5, %g8, beq_else.22799
	ld	%g3, %g6, 0
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g30, %g1, 32
	mov	%g4, %g5
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	b	beq_cont.22800
beq_else.22799:
	mvhi	%g8, 0
	mvlo	%g8, 0
	ld	%g5, %g1, 24
	ld	%g9, %g1, 20
	ld	%g30, %g1, 28
	mov	%g4, %g7
	mov	%g7, %g9
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
beq_cont.22800:
	ld	%g30, %g1, 16
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g4, %g1, 36
	ld	%g5, %g1, 24
	ld	%g6, %g1, 44
	ld	%g7, %g1, 20
	ld	%g30, %g1, 12
	st	%g31, %g1, 52
	ld	%g29, %g30, 0
	addi	%g1, %g1, 56
	call	%g29
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
ble_cont.22792:
	ld	%g3, %g1, 36
	addi	%g4, %g3, 1
	ld	%g3, %g1, 8
	addi	%g3, %g3, 2
	mvhi	%g5, 0
	mvlo	%g5, 5
	blt	%g3, %g5, ble_else.22801
	subi	%g5, %g3, 5
	b	ble_cont.22802
ble_else.22801:
	mov	%g5, %g3
ble_cont.22802:
	ld	%g3, %g1, 48
	ld	%g6, %g3, 4
	blt	%g4, %g6, ble_else.22803
	return
ble_else.22803:
	ld	%g3, %g3, 4
	subi	%g3, %g3, 1
	st	%g5, %g1, 52
	st	%g4, %g1, 56
	blt	%g4, %g3, ble_else.22805
	b	ble_cont.22806
ble_else.22805:
	addi	%g3, %g4, 1
	ld	%g6, %g1, 24
	ld	%g30, %g1, 4
	mov	%g4, %g3
	mov	%g3, %g6
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
ble_cont.22806:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 56
	ld	%g5, %g1, 44
	ld	%g6, %g1, 20
	ld	%g7, %g1, 24
	ld	%g30, %g1, 12
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 56
	addi	%g3, %g3, 1
	ld	%g4, %g1, 52
	addi	%g4, %g4, 2
	mvhi	%g5, 0
	mvlo	%g5, 5
	blt	%g4, %g5, ble_else.22807
	subi	%g7, %g4, 5
	b	ble_cont.22808
ble_else.22807:
	mov	%g7, %g4
ble_cont.22808:
	ld	%g4, %g1, 20
	ld	%g5, %g1, 24
	ld	%g6, %g1, 44
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
create_float5x3array.3211:
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g4, l.14007
	fld	%f0, %g4, 0
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_create_float_array
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 5
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_create_array
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_create_float_array
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	st	%g3, %g4, 4
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_create_float_array
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	st	%g3, %g4, 8
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_create_float_array
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	st	%g3, %g4, 12
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g31, %g1, 4
	addi	%g1, %g1, 8
	call	min_caml_create_float_array
	subi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	st	%g3, %g4, 16
	mov	%g3, %g4
	return
init_line_elements.3215:
	mvhi	%g5, 0
	mvlo	%g5, 0
	blt	%g4, %g5, ble_else.22809
	mvhi	%g5, 0
	mvlo	%g5, 3
	setL %g6, l.14007
	fld	%f0, %g6, 0
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	mov	%g3, %g5
	st	%g31, %g1, 12
	addi	%g1, %g1, 16
	call	min_caml_create_float_array
	subi	%g1, %g1, 16
	ld	%g31, %g1, 12
	st	%g3, %g1, 8
	st	%g31, %g1, 12
	addi	%g1, %g1, 16
	call	create_float5x3array.3211
	subi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 0
	mvlo	%g4, 5
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 12
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 20
	addi	%g1, %g1, 24
	call	min_caml_create_array
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 0
	mvlo	%g4, 5
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 16
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 20
	addi	%g1, %g1, 24
	call	min_caml_create_array
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	st	%g3, %g1, 20
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	create_float5x3array.3211
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	st	%g3, %g1, 24
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	create_float5x3array.3211
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 28
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_create_array
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	st	%g3, %g1, 32
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	create_float5x3array.3211
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g4, %g2
	addi	%g2, %g2, 32
	st	%g3, %g4, 28
	ld	%g3, %g1, 32
	st	%g3, %g4, 24
	ld	%g3, %g1, 28
	st	%g3, %g4, 20
	ld	%g3, %g1, 24
	st	%g3, %g4, 16
	ld	%g3, %g1, 20
	st	%g3, %g4, 12
	ld	%g3, %g1, 16
	st	%g3, %g4, 8
	ld	%g3, %g1, 12
	st	%g3, %g4, 4
	ld	%g3, %g1, 8
	st	%g3, %g4, 0
	mov	%g3, %g4
	ld	%g4, %g1, 4
	slli	%g5, %g4, 2
	ld	%g6, %g1, 0
	st	%g3, %g6, %g5
	subi	%g3, %g4, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22810
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 36
	mov	%g3, %g4
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	min_caml_create_float_array
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	st	%g3, %g1, 40
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	create_float5x3array.3211
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 5
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 44
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_create_array
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 5
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 48
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_create_array
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	st	%g3, %g1, 52
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	create_float5x3array.3211
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	st	%g3, %g1, 56
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	create_float5x3array.3211
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 60
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 68
	addi	%g1, %g1, 72
	call	min_caml_create_array
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	st	%g3, %g1, 64
	st	%g31, %g1, 68
	addi	%g1, %g1, 72
	call	create_float5x3array.3211
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mov	%g4, %g2
	addi	%g2, %g2, 32
	st	%g3, %g4, 28
	ld	%g3, %g1, 64
	st	%g3, %g4, 24
	ld	%g3, %g1, 60
	st	%g3, %g4, 20
	ld	%g3, %g1, 56
	st	%g3, %g4, 16
	ld	%g3, %g1, 52
	st	%g3, %g4, 12
	ld	%g3, %g1, 48
	st	%g3, %g4, 8
	ld	%g3, %g1, 44
	st	%g3, %g4, 4
	ld	%g3, %g1, 40
	st	%g3, %g4, 0
	mov	%g3, %g4
	ld	%g4, %g1, 36
	slli	%g5, %g4, 2
	ld	%g6, %g1, 0
	st	%g3, %g6, %g5
	subi	%g4, %g4, 1
	mov	%g3, %g6
	jmp	init_line_elements.3215
ble_else.22810:
	mov	%g3, %g6
	return
ble_else.22809:
	return
calc_dirvec.3225:
	ld	%g6, %g30, 48
	fld	%f4, %g30, 40
	fld	%f5, %g30, 32
	fld	%f6, %g30, 24
	ld	%g7, %g30, 20
	ld	%g8, %g30, 16
	ld	%g9, %g30, 12
	ld	%g10, %g30, 8
	ld	%g11, %g30, 4
	mvhi	%g12, 0
	mvlo	%g12, 5
	blt	%g3, %g12, ble_else.22811
	fmul	%f2, %f0, %f0
	fmul	%f3, %f1, %f1
	fadd	%f2, %f2, %f3
	setL %g3, l.14053
	fld	%f3, %g3, 0
	fadd	%f2, %f2, %f3
	st	%g5, %g1, 0
	st	%g7, %g1, 4
	st	%g4, %g1, 8
	std	%f1, %g1, 16
	std	%f0, %g1, 24
	fmov	%f0, %f2
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	sqrt.2751
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 24
	fdiv	%f1, %f1, %f0
	fld	%f2, %g1, 16
	fdiv	%f2, %f2, %f0
	setL %g3, l.14053
	fld	%f3, %g3, 0
	fdiv	%f0, %f3, %f0
	ld	%g3, %g1, 8
	slli	%g3, %g3, 2
	ld	%g4, %g1, 4
	ld	%g3, %g4, %g3
	ld	%g4, %g1, 0
	slli	%g5, %g4, 2
	ld	%g5, %g3, %g5
	ld	%g5, %g5, 0
	fst	%f1, %g5, 0
	fst	%f2, %g5, 8
	fst	%f0, %g5, 16
	addi	%g5, %g4, 40
	slli	%g5, %g5, 2
	ld	%g5, %g3, %g5
	ld	%g5, %g5, 0
	fneg	%f3, %f2
	fst	%f1, %g5, 0
	fst	%f0, %g5, 8
	fst	%f3, %g5, 16
	addi	%g5, %g4, 80
	slli	%g5, %g5, 2
	ld	%g5, %g3, %g5
	ld	%g5, %g5, 0
	fneg	%f3, %f1
	fneg	%f4, %f2
	fst	%f0, %g5, 0
	fst	%f3, %g5, 8
	fst	%f4, %g5, 16
	addi	%g5, %g4, 1
	slli	%g5, %g5, 2
	ld	%g5, %g3, %g5
	ld	%g5, %g5, 0
	fneg	%f3, %f1
	fneg	%f4, %f2
	fneg	%f5, %f0
	fst	%f3, %g5, 0
	fst	%f4, %g5, 8
	fst	%f5, %g5, 16
	addi	%g5, %g4, 41
	slli	%g5, %g5, 2
	ld	%g5, %g3, %g5
	ld	%g5, %g5, 0
	fneg	%f3, %f1
	fneg	%f4, %f0
	fst	%f3, %g5, 0
	fst	%f4, %g5, 8
	fst	%f2, %g5, 16
	addi	%g4, %g4, 81
	slli	%g4, %g4, 2
	ld	%g3, %g3, %g4
	ld	%g3, %g3, 0
	fneg	%f0, %f0
	fst	%f0, %g3, 0
	fst	%f1, %g3, 8
	fst	%f2, %g3, 16
	return
ble_else.22811:
	fmul	%f0, %f1, %f1
	setL %g7, l.15113
	fld	%f1, %g7, 0
	fadd	%f0, %f0, %f1
	st	%g5, %g1, 0
	st	%g4, %g1, 8
	st	%g30, %g1, 32
	std	%f3, %g1, 40
	st	%g3, %g1, 48
	st	%g10, %g1, 52
	st	%g8, %g1, 56
	st	%g9, %g1, 60
	st	%g6, %g1, 64
	std	%f5, %g1, 72
	std	%f6, %g1, 80
	std	%f4, %g1, 88
	std	%f2, %g1, 96
	st	%g11, %g1, 104
	st	%g31, %g1, 108
	addi	%g1, %g1, 112
	call	sqrt.2751
	subi	%g1, %g1, 112
	ld	%g31, %g1, 108
	setL %g3, l.14053
	fld	%f1, %g3, 0
	fdiv	%f1, %f1, %f0
	ld	%g30, %g1, 104
	std	%f0, %g1, 112
	fmov	%f0, %f1
	st	%g31, %g1, 124
	ld	%g29, %g30, 0
	addi	%g1, %g1, 128
	call	%g29
	subi	%g1, %g1, 128
	ld	%g31, %g1, 124
	fld	%f1, %g1, 96
	fmul	%f0, %f0, %f1
	setL %g3, l.14007
	fld	%f2, %g3, 0
	std	%f0, %g1, 120
	fblt	%f0, %f2, fble_else.22817
	fneg	%f2, %f0
	ld	%g30, %g1, 64
	fmov	%f0, %f2
	st	%g31, %g1, 132
	ld	%g29, %g30, 0
	addi	%g1, %g1, 136
	call	%g29
	subi	%g1, %g1, 136
	ld	%g31, %g1, 132
	fneg	%f0, %f0
	b	fble_cont.22818
fble_else.22817:
	fld	%f2, %g1, 88
	fblt	%f0, %f2, fble_else.22819
	ld	%g30, %g1, 60
	st	%g31, %g1, 132
	ld	%g29, %g30, 0
	addi	%g1, %g1, 136
	call	%g29
	subi	%g1, %g1, 136
	ld	%g31, %g1, 132
	b	fble_cont.22820
fble_else.22819:
	fld	%f3, %g1, 80
	fblt	%f0, %f3, fble_else.22821
	fsub	%f4, %f3, %f0
	ld	%g30, %g1, 60
	fmov	%f0, %f4
	st	%g31, %g1, 132
	ld	%g29, %g30, 0
	addi	%g1, %g1, 136
	call	%g29
	subi	%g1, %g1, 136
	ld	%g31, %g1, 132
	b	fble_cont.22822
fble_else.22821:
	fld	%f4, %g1, 72
	fblt	%f0, %f4, fble_else.22823
	fsub	%f5, %f4, %f0
	ld	%g30, %g1, 64
	fmov	%f0, %f5
	st	%g31, %g1, 132
	ld	%g29, %g30, 0
	addi	%g1, %g1, 136
	call	%g29
	subi	%g1, %g1, 136
	ld	%g31, %g1, 132
	fneg	%f0, %f0
	b	fble_cont.22824
fble_else.22823:
	fsub	%f5, %f0, %f4
	ld	%g30, %g1, 64
	fmov	%f0, %f5
	st	%g31, %g1, 132
	ld	%g29, %g30, 0
	addi	%g1, %g1, 136
	call	%g29
	subi	%g1, %g1, 136
	ld	%g31, %g1, 132
fble_cont.22824:
fble_cont.22822:
fble_cont.22820:
fble_cont.22818:
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fld	%f2, %g1, 120
	std	%f0, %g1, 128
	fblt	%f2, %f1, fble_else.22825
	fneg	%f1, %f2
	ld	%g30, %g1, 56
	fmov	%f0, %f1
	st	%g31, %g1, 140
	ld	%g29, %g30, 0
	addi	%g1, %g1, 144
	call	%g29
	subi	%g1, %g1, 144
	ld	%g31, %g1, 140
	b	fble_cont.22826
fble_else.22825:
	fld	%f1, %g1, 88
	fblt	%f2, %f1, fble_else.22827
	ld	%g30, %g1, 52
	fmov	%f0, %f2
	st	%g31, %g1, 140
	ld	%g29, %g30, 0
	addi	%g1, %g1, 144
	call	%g29
	subi	%g1, %g1, 144
	ld	%g31, %g1, 140
	b	fble_cont.22828
fble_else.22827:
	fld	%f3, %g1, 80
	fblt	%f2, %f3, fble_else.22829
	fsub	%f2, %f3, %f2
	ld	%g30, %g1, 52
	fmov	%f0, %f2
	st	%g31, %g1, 140
	ld	%g29, %g30, 0
	addi	%g1, %g1, 144
	call	%g29
	subi	%g1, %g1, 144
	ld	%g31, %g1, 140
	fneg	%f0, %f0
	b	fble_cont.22830
fble_else.22829:
	fld	%f4, %g1, 72
	fblt	%f2, %f4, fble_else.22831
	fsub	%f2, %f4, %f2
	ld	%g30, %g1, 56
	fmov	%f0, %f2
	st	%g31, %g1, 140
	ld	%g29, %g30, 0
	addi	%g1, %g1, 144
	call	%g29
	subi	%g1, %g1, 144
	ld	%g31, %g1, 140
	b	fble_cont.22832
fble_else.22831:
	fsub	%f2, %f2, %f4
	ld	%g30, %g1, 56
	fmov	%f0, %f2
	st	%g31, %g1, 140
	ld	%g29, %g30, 0
	addi	%g1, %g1, 144
	call	%g29
	subi	%g1, %g1, 144
	ld	%g31, %g1, 140
fble_cont.22832:
fble_cont.22830:
fble_cont.22828:
fble_cont.22826:
	fld	%f1, %g1, 128
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 112
	fmul	%f0, %f0, %f1
	ld	%g3, %g1, 48
	addi	%g3, %g3, 1
	fmul	%f1, %f0, %f0
	setL %g4, l.15113
	fld	%f2, %g4, 0
	fadd	%f1, %f1, %f2
	std	%f0, %g1, 136
	st	%g3, %g1, 144
	fmov	%f0, %f1
	st	%g31, %g1, 148
	addi	%g1, %g1, 152
	call	sqrt.2751
	subi	%g1, %g1, 152
	ld	%g31, %g1, 148
	setL %g3, l.14053
	fld	%f1, %g3, 0
	fdiv	%f1, %f1, %f0
	ld	%g30, %g1, 104
	std	%f0, %g1, 152
	fmov	%f0, %f1
	st	%g31, %g1, 164
	ld	%g29, %g30, 0
	addi	%g1, %g1, 168
	call	%g29
	subi	%g1, %g1, 168
	ld	%g31, %g1, 164
	fld	%f1, %g1, 40
	fmul	%f0, %f0, %f1
	setL %g3, l.14007
	fld	%f2, %g3, 0
	std	%f0, %g1, 160
	fblt	%f0, %f2, fble_else.22834
	fneg	%f2, %f0
	ld	%g30, %g1, 64
	fmov	%f0, %f2
	st	%g31, %g1, 172
	ld	%g29, %g30, 0
	addi	%g1, %g1, 176
	call	%g29
	subi	%g1, %g1, 176
	ld	%g31, %g1, 172
	fneg	%f0, %f0
	b	fble_cont.22835
fble_else.22834:
	fld	%f2, %g1, 88
	fblt	%f0, %f2, fble_else.22836
	ld	%g30, %g1, 60
	st	%g31, %g1, 172
	ld	%g29, %g30, 0
	addi	%g1, %g1, 176
	call	%g29
	subi	%g1, %g1, 176
	ld	%g31, %g1, 172
	b	fble_cont.22837
fble_else.22836:
	fld	%f3, %g1, 80
	fblt	%f0, %f3, fble_else.22838
	fsub	%f4, %f3, %f0
	ld	%g30, %g1, 60
	fmov	%f0, %f4
	st	%g31, %g1, 172
	ld	%g29, %g30, 0
	addi	%g1, %g1, 176
	call	%g29
	subi	%g1, %g1, 176
	ld	%g31, %g1, 172
	b	fble_cont.22839
fble_else.22838:
	fld	%f4, %g1, 72
	fblt	%f0, %f4, fble_else.22840
	fsub	%f5, %f4, %f0
	ld	%g30, %g1, 64
	fmov	%f0, %f5
	st	%g31, %g1, 172
	ld	%g29, %g30, 0
	addi	%g1, %g1, 176
	call	%g29
	subi	%g1, %g1, 176
	ld	%g31, %g1, 172
	fneg	%f0, %f0
	b	fble_cont.22841
fble_else.22840:
	fsub	%f5, %f0, %f4
	ld	%g30, %g1, 64
	fmov	%f0, %f5
	st	%g31, %g1, 172
	ld	%g29, %g30, 0
	addi	%g1, %g1, 176
	call	%g29
	subi	%g1, %g1, 176
	ld	%g31, %g1, 172
fble_cont.22841:
fble_cont.22839:
fble_cont.22837:
fble_cont.22835:
	setL %g3, l.14007
	fld	%f1, %g3, 0
	fld	%f2, %g1, 160
	std	%f0, %g1, 168
	fblt	%f2, %f1, fble_else.22842
	fneg	%f1, %f2
	ld	%g30, %g1, 56
	fmov	%f0, %f1
	st	%g31, %g1, 180
	ld	%g29, %g30, 0
	addi	%g1, %g1, 184
	call	%g29
	subi	%g1, %g1, 184
	ld	%g31, %g1, 180
	b	fble_cont.22843
fble_else.22842:
	fld	%f1, %g1, 88
	fblt	%f2, %f1, fble_else.22844
	ld	%g30, %g1, 52
	fmov	%f0, %f2
	st	%g31, %g1, 180
	ld	%g29, %g30, 0
	addi	%g1, %g1, 184
	call	%g29
	subi	%g1, %g1, 184
	ld	%g31, %g1, 180
	b	fble_cont.22845
fble_else.22844:
	fld	%f1, %g1, 80
	fblt	%f2, %f1, fble_else.22846
	fsub	%f1, %f1, %f2
	ld	%g30, %g1, 52
	fmov	%f0, %f1
	st	%g31, %g1, 180
	ld	%g29, %g30, 0
	addi	%g1, %g1, 184
	call	%g29
	subi	%g1, %g1, 184
	ld	%g31, %g1, 180
	fneg	%f0, %f0
	b	fble_cont.22847
fble_else.22846:
	fld	%f1, %g1, 72
	fblt	%f2, %f1, fble_else.22848
	fsub	%f1, %f1, %f2
	ld	%g30, %g1, 56
	fmov	%f0, %f1
	st	%g31, %g1, 180
	ld	%g29, %g30, 0
	addi	%g1, %g1, 184
	call	%g29
	subi	%g1, %g1, 184
	ld	%g31, %g1, 180
	b	fble_cont.22849
fble_else.22848:
	fsub	%f1, %f2, %f1
	ld	%g30, %g1, 56
	fmov	%f0, %f1
	st	%g31, %g1, 180
	ld	%g29, %g30, 0
	addi	%g1, %g1, 184
	call	%g29
	subi	%g1, %g1, 184
	ld	%g31, %g1, 180
fble_cont.22849:
fble_cont.22847:
fble_cont.22845:
fble_cont.22843:
	fld	%f1, %g1, 168
	fdiv	%f0, %f1, %f0
	fld	%f1, %g1, 152
	fmul	%f1, %f0, %f1
	fld	%f0, %g1, 136
	fld	%f2, %g1, 96
	fld	%f3, %g1, 40
	ld	%g3, %g1, 144
	ld	%g4, %g1, 8
	ld	%g5, %g1, 0
	ld	%g30, %g1, 32
	ld	%g30, 0, %g29
	b	%g29
calc_dirvecs.3233:
	ld	%g6, %g30, 4
	mvhi	%g7, 0
	mvlo	%g7, 0
	blt	%g3, %g7, ble_else.22850
	st	%g30, %g1, 0
	st	%g3, %g1, 4
	std	%f0, %g1, 8
	st	%g5, %g1, 16
	st	%g4, %g1, 20
	st	%g6, %g1, 24
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	min_caml_float_of_int
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	setL %g3, l.15758
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.15760
	fld	%f1, %g3, 0
	fsub	%f2, %f0, %f1
	mvhi	%g3, 0
	mvlo	%g3, 0
	setL %g4, l.14007
	fld	%f0, %g4, 0
	setL %g4, l.14007
	fld	%f1, %g4, 0
	fld	%f3, %g1, 8
	ld	%g4, %g1, 20
	ld	%g5, %g1, 16
	ld	%g30, %g1, 24
	st	%g31, %g1, 28
	ld	%g29, %g30, 0
	addi	%g1, %g1, 32
	call	%g29
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 4
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	min_caml_float_of_int
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	setL %g3, l.15758
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.15113
	fld	%f1, %g3, 0
	fadd	%f2, %f0, %f1
	mvhi	%g3, 0
	mvlo	%g3, 0
	setL %g4, l.14007
	fld	%f0, %g4, 0
	setL %g4, l.14007
	fld	%f1, %g4, 0
	ld	%g4, %g1, 16
	addi	%g5, %g4, 2
	fld	%f3, %g1, 8
	ld	%g6, %g1, 20
	ld	%g30, %g1, 24
	mov	%g4, %g6
	st	%g31, %g1, 28
	ld	%g29, %g30, 0
	addi	%g1, %g1, 32
	call	%g29
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	ld	%g4, %g1, 20
	addi	%g4, %g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 5
	blt	%g4, %g5, ble_else.22851
	subi	%g4, %g4, 5
	b	ble_cont.22852
ble_else.22851:
ble_cont.22852:
	fld	%f0, %g1, 8
	ld	%g5, %g1, 16
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
ble_else.22850:
	return
calc_dirvec_rows.3238:
	ld	%g6, %g30, 4
	mvhi	%g7, 0
	mvlo	%g7, 0
	blt	%g3, %g7, ble_else.22854
	st	%g30, %g1, 0
	st	%g3, %g1, 4
	st	%g5, %g1, 8
	st	%g4, %g1, 12
	st	%g6, %g1, 16
	st	%g31, %g1, 20
	addi	%g1, %g1, 24
	call	min_caml_float_of_int
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	setL %g3, l.15758
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.15760
	fld	%f1, %g3, 0
	fsub	%f0, %f0, %f1
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 12
	ld	%g5, %g1, 8
	ld	%g30, %g1, 16
	st	%g31, %g1, 20
	ld	%g29, %g30, 0
	addi	%g1, %g1, 24
	call	%g29
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	ld	%g3, %g1, 4
	subi	%g3, %g3, 1
	ld	%g4, %g1, 12
	addi	%g4, %g4, 2
	mvhi	%g5, 0
	mvlo	%g5, 5
	blt	%g4, %g5, ble_else.22855
	subi	%g4, %g4, 5
	b	ble_cont.22856
ble_else.22855:
ble_cont.22856:
	ld	%g5, %g1, 8
	addi	%g5, %g5, 4
	mvhi	%g6, 0
	mvlo	%g6, 0
	blt	%g3, %g6, ble_else.22857
	st	%g3, %g1, 20
	st	%g5, %g1, 24
	st	%g4, %g1, 28
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_float_of_int
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	setL %g3, l.15758
	fld	%f1, %g3, 0
	fmul	%f0, %f0, %f1
	setL %g3, l.15760
	fld	%f1, %g3, 0
	fsub	%f0, %f0, %f1
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g4, %g1, 28
	ld	%g5, %g1, 24
	ld	%g30, %g1, 16
	st	%g31, %g1, 36
	ld	%g29, %g30, 0
	addi	%g1, %g1, 40
	call	%g29
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	ld	%g3, %g1, 20
	subi	%g3, %g3, 1
	ld	%g4, %g1, 28
	addi	%g4, %g4, 2
	mvhi	%g5, 0
	mvlo	%g5, 5
	blt	%g4, %g5, ble_else.22858
	subi	%g4, %g4, 5
	b	ble_cont.22859
ble_else.22858:
ble_cont.22859:
	ld	%g5, %g1, 24
	addi	%g5, %g5, 4
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
ble_else.22857:
	return
ble_else.22854:
	return
create_dirvec_elements.3244:
	ld	%g5, %g30, 4
	mvhi	%g6, 0
	mvlo	%g6, 0
	blt	%g4, %g6, ble_else.22862
	mvhi	%g6, 0
	mvlo	%g6, 3
	setL %g7, l.14007
	fld	%f0, %g7, 0
	st	%g30, %g1, 0
	st	%g3, %g1, 4
	st	%g4, %g1, 8
	st	%g5, %g1, 12
	mov	%g3, %g6
	st	%g31, %g1, 20
	addi	%g1, %g1, 24
	call	min_caml_create_float_array
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g3
	ld	%g3, %g1, 12
	ld	%g5, %g3, 0
	st	%g4, %g1, 16
	mov	%g3, %g5
	st	%g31, %g1, 20
	addi	%g1, %g1, 24
	call	min_caml_create_array
	subi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, 4
	ld	%g3, %g1, 16
	st	%g3, %g4, 0
	mov	%g3, %g4
	ld	%g4, %g1, 8
	slli	%g5, %g4, 2
	ld	%g6, %g1, 4
	st	%g3, %g6, %g5
	subi	%g3, %g4, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22863
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 20
	mov	%g3, %g4
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	min_caml_create_float_array
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g3
	ld	%g3, %g1, 12
	ld	%g5, %g3, 0
	st	%g4, %g1, 24
	mov	%g3, %g5
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	min_caml_create_array
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, 4
	ld	%g3, %g1, 24
	st	%g3, %g4, 0
	mov	%g3, %g4
	ld	%g4, %g1, 20
	slli	%g5, %g4, 2
	ld	%g6, %g1, 4
	st	%g3, %g6, %g5
	subi	%g3, %g4, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22864
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 28
	mov	%g3, %g4
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_create_float_array
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g4, %g3
	ld	%g3, %g1, 12
	ld	%g5, %g3, 0
	st	%g4, %g1, 32
	mov	%g3, %g5
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_create_array
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, 4
	ld	%g3, %g1, 32
	st	%g3, %g4, 0
	mov	%g3, %g4
	ld	%g4, %g1, 28
	slli	%g5, %g4, 2
	ld	%g6, %g1, 4
	st	%g3, %g6, %g5
	subi	%g3, %g4, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22865
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 36
	mov	%g3, %g4
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	min_caml_create_float_array
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mov	%g4, %g3
	ld	%g3, %g1, 12
	ld	%g3, %g3, 0
	st	%g4, %g1, 40
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	min_caml_create_array
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, 4
	ld	%g3, %g1, 40
	st	%g3, %g4, 0
	mov	%g3, %g4
	ld	%g4, %g1, 36
	slli	%g5, %g4, 2
	ld	%g6, %g1, 4
	st	%g3, %g6, %g5
	subi	%g4, %g4, 1
	ld	%g30, %g1, 0
	mov	%g3, %g6
	ld	%g30, 0, %g29
	b	%g29
ble_else.22865:
	return
ble_else.22864:
	return
ble_else.22863:
	return
ble_else.22862:
	return
create_dirvecs.3247:
	ld	%g4, %g30, 12
	ld	%g5, %g30, 8
	ld	%g6, %g30, 4
	mvhi	%g7, 0
	mvlo	%g7, 0
	blt	%g3, %g7, ble_else.22870
	mvhi	%g7, 0
	mvlo	%g7, 120
	mvhi	%g8, 0
	mvlo	%g8, 3
	setL %g9, l.14007
	fld	%f0, %g9, 0
	st	%g30, %g1, 0
	st	%g6, %g1, 4
	st	%g5, %g1, 8
	st	%g3, %g1, 12
	st	%g7, %g1, 16
	st	%g4, %g1, 20
	mov	%g3, %g8
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	min_caml_create_float_array
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g3
	ld	%g3, %g1, 20
	ld	%g5, %g3, 0
	st	%g4, %g1, 24
	mov	%g3, %g5
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	min_caml_create_array
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, 4
	ld	%g3, %g1, 24
	st	%g3, %g4, 0
	ld	%g3, %g1, 16
	st	%g31, %g1, 28
	addi	%g1, %g1, 32
	call	min_caml_create_array
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g4, %g1, 12
	slli	%g5, %g4, 2
	ld	%g6, %g1, 8
	st	%g3, %g6, %g5
	slli	%g3, %g4, 2
	ld	%g3, %g6, %g3
	mvhi	%g5, 0
	mvlo	%g5, 3
	setL %g7, l.14007
	fld	%f0, %g7, 0
	st	%g3, %g1, 28
	mov	%g3, %g5
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_create_float_array
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g4, %g3
	ld	%g3, %g1, 20
	ld	%g5, %g3, 0
	st	%g4, %g1, 32
	mov	%g3, %g5
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_create_array
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, 4
	ld	%g3, %g1, 32
	st	%g3, %g4, 0
	mov	%g3, %g4
	ld	%g4, %g1, 28
	st	%g3, %g4, 472
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g31, %g1, 36
	addi	%g1, %g1, 40
	call	min_caml_create_float_array
	subi	%g1, %g1, 40
	ld	%g31, %g1, 36
	mov	%g4, %g3
	ld	%g3, %g1, 20
	ld	%g5, %g3, 0
	st	%g4, %g1, 36
	mov	%g3, %g5
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	min_caml_create_array
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, 4
	ld	%g3, %g1, 36
	st	%g3, %g4, 0
	mov	%g3, %g4
	ld	%g4, %g1, 28
	st	%g3, %g4, 468
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	min_caml_create_float_array
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mov	%g4, %g3
	ld	%g3, %g1, 20
	ld	%g5, %g3, 0
	st	%g4, %g1, 40
	mov	%g3, %g5
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	min_caml_create_array
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, 4
	ld	%g3, %g1, 40
	st	%g3, %g4, 0
	mov	%g3, %g4
	ld	%g4, %g1, 28
	st	%g3, %g4, 464
	mvhi	%g3, 0
	mvlo	%g3, 115
	ld	%g30, %g1, 4
	mov	%g29, %g4
	mov	%g4, %g3
	mov	%g3, %g29
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 12
	subi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22871
	mvhi	%g4, 0
	mvlo	%g4, 120
	mvhi	%g5, 0
	mvlo	%g5, 3
	setL %g6, l.14007
	fld	%f0, %g6, 0
	st	%g3, %g1, 44
	st	%g4, %g1, 48
	mov	%g3, %g5
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_create_float_array
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mov	%g4, %g3
	ld	%g3, %g1, 20
	ld	%g5, %g3, 0
	st	%g4, %g1, 52
	mov	%g3, %g5
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	min_caml_create_array
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, 4
	ld	%g3, %g1, 52
	st	%g3, %g4, 0
	ld	%g3, %g1, 48
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	min_caml_create_array
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g4, %g1, 44
	slli	%g5, %g4, 2
	ld	%g6, %g1, 8
	st	%g3, %g6, %g5
	slli	%g3, %g4, 2
	ld	%g3, %g6, %g3
	mvhi	%g5, 0
	mvlo	%g5, 3
	setL %g6, l.14007
	fld	%f0, %g6, 0
	st	%g3, %g1, 56
	mov	%g3, %g5
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	min_caml_create_float_array
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g3
	ld	%g3, %g1, 20
	ld	%g5, %g3, 0
	st	%g4, %g1, 60
	mov	%g3, %g5
	st	%g31, %g1, 68
	addi	%g1, %g1, 72
	call	min_caml_create_array
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, 4
	ld	%g3, %g1, 60
	st	%g3, %g4, 0
	mov	%g3, %g4
	ld	%g4, %g1, 56
	st	%g3, %g4, 472
	mvhi	%g3, 0
	mvlo	%g3, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g31, %g1, 68
	addi	%g1, %g1, 72
	call	min_caml_create_float_array
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mov	%g4, %g3
	ld	%g3, %g1, 20
	ld	%g3, %g3, 0
	st	%g4, %g1, 64
	st	%g31, %g1, 68
	addi	%g1, %g1, 72
	call	min_caml_create_array
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, 4
	ld	%g3, %g1, 64
	st	%g3, %g4, 0
	mov	%g3, %g4
	ld	%g4, %g1, 56
	st	%g3, %g4, 468
	mvhi	%g3, 0
	mvlo	%g3, 116
	ld	%g30, %g1, 4
	mov	%g29, %g4
	mov	%g4, %g3
	mov	%g3, %g29
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 44
	subi	%g3, %g3, 1
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
ble_else.22871:
	return
ble_else.22870:
	return
init_dirvec_constants.3249:
	ld	%g5, %g30, 12
	ld	%g6, %g30, 8
	ld	%g7, %g30, 4
	mvhi	%g8, 0
	mvlo	%g8, 0
	blt	%g4, %g8, ble_else.22874
	slli	%g8, %g4, 2
	ld	%g8, %g3, %g8
	ld	%g9, %g6, 0
	subi	%g9, %g9, 1
	st	%g30, %g1, 0
	st	%g7, %g1, 4
	st	%g5, %g1, 8
	st	%g6, %g1, 12
	st	%g3, %g1, 16
	st	%g4, %g1, 20
	mov	%g4, %g9
	mov	%g3, %g8
	mov	%g30, %g7
	st	%g31, %g1, 28
	ld	%g29, %g30, 0
	addi	%g1, %g1, 32
	call	%g29
	subi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 20
	subi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22875
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	ld	%g4, %g5, %g4
	ld	%g6, %g1, 12
	ld	%g7, %g6, 0
	subi	%g7, %g7, 1
	mvhi	%g8, 0
	mvlo	%g8, 0
	st	%g3, %g1, 24
	blt	%g7, %g8, ble_else.22876
	slli	%g8, %g7, 2
	ld	%g9, %g1, 8
	ld	%g8, %g9, %g8
	ld	%g10, %g4, 4
	ld	%g11, %g4, 0
	ld	%g12, %g8, 4
	mvhi	%g13, 0
	mvlo	%g13, 1
	st	%g4, %g1, 28
	bne	%g12, %g13, beq_else.22878
	st	%g10, %g1, 32
	st	%g7, %g1, 36
	mov	%g4, %g8
	mov	%g3, %g11
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	setup_rect_table.3022
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 36
	slli	%g5, %g4, 2
	ld	%g6, %g1, 32
	st	%g3, %g6, %g5
	b	beq_cont.22879
beq_else.22878:
	mvhi	%g13, 0
	mvlo	%g13, 2
	bne	%g12, %g13, beq_else.22880
	st	%g10, %g1, 32
	st	%g7, %g1, 36
	mov	%g4, %g8
	mov	%g3, %g11
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	setup_surface_table.3025
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 36
	slli	%g5, %g4, 2
	ld	%g6, %g1, 32
	st	%g3, %g6, %g5
	b	beq_cont.22881
beq_else.22880:
	st	%g10, %g1, 32
	st	%g7, %g1, 36
	mov	%g4, %g8
	mov	%g3, %g11
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	setup_second_table.3028
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 36
	slli	%g5, %g4, 2
	ld	%g6, %g1, 32
	st	%g3, %g6, %g5
beq_cont.22881:
beq_cont.22879:
	subi	%g4, %g4, 1
	ld	%g3, %g1, 28
	ld	%g30, %g1, 4
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	b	ble_cont.22877
ble_else.22876:
ble_cont.22877:
	ld	%g3, %g1, 24
	subi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22882
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	ld	%g4, %g5, %g4
	ld	%g6, %g1, 12
	ld	%g7, %g6, 0
	subi	%g7, %g7, 1
	ld	%g30, %g1, 4
	st	%g3, %g1, 40
	mov	%g3, %g4
	mov	%g4, %g7
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 40
	subi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22883
	slli	%g4, %g3, 2
	ld	%g5, %g1, 16
	ld	%g4, %g5, %g4
	ld	%g6, %g1, 12
	ld	%g6, %g6, 0
	subi	%g6, %g6, 1
	mvhi	%g7, 0
	mvlo	%g7, 0
	st	%g3, %g1, 44
	blt	%g6, %g7, ble_else.22884
	slli	%g7, %g6, 2
	ld	%g8, %g1, 8
	ld	%g7, %g8, %g7
	ld	%g8, %g4, 4
	ld	%g9, %g4, 0
	ld	%g10, %g7, 4
	mvhi	%g11, 0
	mvlo	%g11, 1
	st	%g4, %g1, 48
	bne	%g10, %g11, beq_else.22886
	st	%g8, %g1, 52
	st	%g6, %g1, 56
	mov	%g4, %g7
	mov	%g3, %g9
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	setup_rect_table.3022
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g4, %g1, 56
	slli	%g5, %g4, 2
	ld	%g6, %g1, 52
	st	%g3, %g6, %g5
	b	beq_cont.22887
beq_else.22886:
	mvhi	%g11, 0
	mvlo	%g11, 2
	bne	%g10, %g11, beq_else.22888
	st	%g8, %g1, 52
	st	%g6, %g1, 56
	mov	%g4, %g7
	mov	%g3, %g9
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	setup_surface_table.3025
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g4, %g1, 56
	slli	%g5, %g4, 2
	ld	%g6, %g1, 52
	st	%g3, %g6, %g5
	b	beq_cont.22889
beq_else.22888:
	st	%g8, %g1, 52
	st	%g6, %g1, 56
	mov	%g4, %g7
	mov	%g3, %g9
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	setup_second_table.3028
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g4, %g1, 56
	slli	%g5, %g4, 2
	ld	%g6, %g1, 52
	st	%g3, %g6, %g5
beq_cont.22889:
beq_cont.22887:
	subi	%g4, %g4, 1
	ld	%g3, %g1, 48
	ld	%g30, %g1, 4
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	b	ble_cont.22885
ble_else.22884:
ble_cont.22885:
	ld	%g3, %g1, 44
	subi	%g4, %g3, 1
	ld	%g3, %g1, 16
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
ble_else.22883:
	return
ble_else.22882:
	return
ble_else.22875:
	return
ble_else.22874:
	return
init_vecset_constants.3252:
	ld	%g4, %g30, 20
	ld	%g5, %g30, 16
	ld	%g6, %g30, 12
	ld	%g7, %g30, 8
	ld	%g8, %g30, 4
	mvhi	%g9, 0
	mvlo	%g9, 0
	blt	%g3, %g9, ble_else.22894
	slli	%g9, %g3, 2
	ld	%g9, %g8, %g9
	ld	%g10, %g9, 476
	ld	%g11, %g5, 0
	subi	%g11, %g11, 1
	mvhi	%g12, 0
	mvlo	%g12, 0
	st	%g30, %g1, 0
	st	%g8, %g1, 4
	st	%g3, %g1, 8
	st	%g7, %g1, 12
	st	%g4, %g1, 16
	st	%g6, %g1, 20
	st	%g5, %g1, 24
	st	%g9, %g1, 28
	blt	%g11, %g12, ble_else.22895
	slli	%g12, %g11, 2
	ld	%g12, %g4, %g12
	ld	%g13, %g10, 4
	ld	%g14, %g10, 0
	ld	%g15, %g12, 4
	mvhi	%g16, 0
	mvlo	%g16, 1
	st	%g10, %g1, 32
	bne	%g15, %g16, beq_else.22897
	st	%g13, %g1, 36
	st	%g11, %g1, 40
	mov	%g4, %g12
	mov	%g3, %g14
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	setup_rect_table.3022
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 40
	slli	%g5, %g4, 2
	ld	%g6, %g1, 36
	st	%g3, %g6, %g5
	b	beq_cont.22898
beq_else.22897:
	mvhi	%g16, 0
	mvlo	%g16, 2
	bne	%g15, %g16, beq_else.22899
	st	%g13, %g1, 36
	st	%g11, %g1, 40
	mov	%g4, %g12
	mov	%g3, %g14
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	setup_surface_table.3025
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 40
	slli	%g5, %g4, 2
	ld	%g6, %g1, 36
	st	%g3, %g6, %g5
	b	beq_cont.22900
beq_else.22899:
	st	%g13, %g1, 36
	st	%g11, %g1, 40
	mov	%g4, %g12
	mov	%g3, %g14
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	setup_second_table.3028
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g4, %g1, 40
	slli	%g5, %g4, 2
	ld	%g6, %g1, 36
	st	%g3, %g6, %g5
beq_cont.22900:
beq_cont.22898:
	subi	%g4, %g4, 1
	ld	%g3, %g1, 32
	ld	%g30, %g1, 20
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	b	ble_cont.22896
ble_else.22895:
ble_cont.22896:
	ld	%g3, %g1, 28
	ld	%g4, %g3, 472
	ld	%g5, %g1, 24
	ld	%g6, %g5, 0
	subi	%g6, %g6, 1
	ld	%g30, %g1, 20
	mov	%g3, %g4
	mov	%g4, %g6
	st	%g31, %g1, 44
	ld	%g29, %g30, 0
	addi	%g1, %g1, 48
	call	%g29
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 28
	ld	%g4, %g3, 468
	ld	%g5, %g1, 24
	ld	%g6, %g5, 0
	subi	%g6, %g6, 1
	mvhi	%g7, 0
	mvlo	%g7, 0
	blt	%g6, %g7, ble_else.22901
	slli	%g7, %g6, 2
	ld	%g8, %g1, 16
	ld	%g7, %g8, %g7
	ld	%g9, %g4, 4
	ld	%g10, %g4, 0
	ld	%g11, %g7, 4
	mvhi	%g12, 0
	mvlo	%g12, 1
	st	%g4, %g1, 44
	bne	%g11, %g12, beq_else.22903
	st	%g9, %g1, 48
	st	%g6, %g1, 52
	mov	%g4, %g7
	mov	%g3, %g10
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	setup_rect_table.3022
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g4, %g1, 52
	slli	%g5, %g4, 2
	ld	%g6, %g1, 48
	st	%g3, %g6, %g5
	b	beq_cont.22904
beq_else.22903:
	mvhi	%g12, 0
	mvlo	%g12, 2
	bne	%g11, %g12, beq_else.22905
	st	%g9, %g1, 48
	st	%g6, %g1, 52
	mov	%g4, %g7
	mov	%g3, %g10
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	setup_surface_table.3025
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g4, %g1, 52
	slli	%g5, %g4, 2
	ld	%g6, %g1, 48
	st	%g3, %g6, %g5
	b	beq_cont.22906
beq_else.22905:
	st	%g9, %g1, 48
	st	%g6, %g1, 52
	mov	%g4, %g7
	mov	%g3, %g10
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	setup_second_table.3028
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g4, %g1, 52
	slli	%g5, %g4, 2
	ld	%g6, %g1, 48
	st	%g3, %g6, %g5
beq_cont.22906:
beq_cont.22904:
	subi	%g4, %g4, 1
	ld	%g3, %g1, 44
	ld	%g30, %g1, 20
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	b	ble_cont.22902
ble_else.22901:
ble_cont.22902:
	mvhi	%g4, 0
	mvlo	%g4, 116
	ld	%g3, %g1, 28
	ld	%g30, %g1, 12
	st	%g31, %g1, 60
	ld	%g29, %g30, 0
	addi	%g1, %g1, 64
	call	%g29
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	ld	%g3, %g1, 8
	subi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22907
	slli	%g4, %g3, 2
	ld	%g5, %g1, 4
	ld	%g4, %g5, %g4
	ld	%g6, %g4, 476
	ld	%g7, %g1, 24
	ld	%g8, %g7, 0
	subi	%g8, %g8, 1
	ld	%g30, %g1, 20
	st	%g3, %g1, 56
	st	%g4, %g1, 60
	mov	%g4, %g8
	mov	%g3, %g6
	st	%g31, %g1, 68
	ld	%g29, %g30, 0
	addi	%g1, %g1, 72
	call	%g29
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	ld	%g3, %g1, 60
	ld	%g4, %g3, 472
	ld	%g5, %g1, 24
	ld	%g6, %g5, 0
	subi	%g6, %g6, 1
	mvhi	%g7, 0
	mvlo	%g7, 0
	blt	%g6, %g7, ble_else.22908
	slli	%g7, %g6, 2
	ld	%g8, %g1, 16
	ld	%g7, %g8, %g7
	ld	%g9, %g4, 4
	ld	%g10, %g4, 0
	ld	%g11, %g7, 4
	mvhi	%g12, 0
	mvlo	%g12, 1
	st	%g4, %g1, 64
	bne	%g11, %g12, beq_else.22910
	st	%g9, %g1, 68
	st	%g6, %g1, 72
	mov	%g4, %g7
	mov	%g3, %g10
	st	%g31, %g1, 76
	addi	%g1, %g1, 80
	call	setup_rect_table.3022
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g4, %g1, 72
	slli	%g5, %g4, 2
	ld	%g6, %g1, 68
	st	%g3, %g6, %g5
	b	beq_cont.22911
beq_else.22910:
	mvhi	%g12, 0
	mvlo	%g12, 2
	bne	%g11, %g12, beq_else.22912
	st	%g9, %g1, 68
	st	%g6, %g1, 72
	mov	%g4, %g7
	mov	%g3, %g10
	st	%g31, %g1, 76
	addi	%g1, %g1, 80
	call	setup_surface_table.3025
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g4, %g1, 72
	slli	%g5, %g4, 2
	ld	%g6, %g1, 68
	st	%g3, %g6, %g5
	b	beq_cont.22913
beq_else.22912:
	st	%g9, %g1, 68
	st	%g6, %g1, 72
	mov	%g4, %g7
	mov	%g3, %g10
	st	%g31, %g1, 76
	addi	%g1, %g1, 80
	call	setup_second_table.3028
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g4, %g1, 72
	slli	%g5, %g4, 2
	ld	%g6, %g1, 68
	st	%g3, %g6, %g5
beq_cont.22913:
beq_cont.22911:
	subi	%g4, %g4, 1
	ld	%g3, %g1, 64
	ld	%g30, %g1, 20
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	b	ble_cont.22909
ble_else.22908:
ble_cont.22909:
	mvhi	%g4, 0
	mvlo	%g4, 117
	ld	%g3, %g1, 60
	ld	%g30, %g1, 12
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g3, %g1, 56
	subi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22914
	slli	%g4, %g3, 2
	ld	%g5, %g1, 4
	ld	%g4, %g5, %g4
	ld	%g6, %g4, 476
	ld	%g7, %g1, 24
	ld	%g7, %g7, 0
	subi	%g7, %g7, 1
	mvhi	%g8, 0
	mvlo	%g8, 0
	st	%g3, %g1, 76
	st	%g4, %g1, 80
	blt	%g7, %g8, ble_else.22915
	slli	%g8, %g7, 2
	ld	%g9, %g1, 16
	ld	%g8, %g9, %g8
	ld	%g9, %g6, 4
	ld	%g10, %g6, 0
	ld	%g11, %g8, 4
	mvhi	%g12, 0
	mvlo	%g12, 1
	st	%g6, %g1, 84
	bne	%g11, %g12, beq_else.22917
	st	%g9, %g1, 88
	st	%g7, %g1, 92
	mov	%g4, %g8
	mov	%g3, %g10
	st	%g31, %g1, 100
	addi	%g1, %g1, 104
	call	setup_rect_table.3022
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	ld	%g6, %g1, 88
	st	%g3, %g6, %g5
	b	beq_cont.22918
beq_else.22917:
	mvhi	%g12, 0
	mvlo	%g12, 2
	bne	%g11, %g12, beq_else.22919
	st	%g9, %g1, 88
	st	%g7, %g1, 92
	mov	%g4, %g8
	mov	%g3, %g10
	st	%g31, %g1, 100
	addi	%g1, %g1, 104
	call	setup_surface_table.3025
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	ld	%g6, %g1, 88
	st	%g3, %g6, %g5
	b	beq_cont.22920
beq_else.22919:
	st	%g9, %g1, 88
	st	%g7, %g1, 92
	mov	%g4, %g8
	mov	%g3, %g10
	st	%g31, %g1, 100
	addi	%g1, %g1, 104
	call	setup_second_table.3028
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	ld	%g4, %g1, 92
	slli	%g5, %g4, 2
	ld	%g6, %g1, 88
	st	%g3, %g6, %g5
beq_cont.22920:
beq_cont.22918:
	subi	%g4, %g4, 1
	ld	%g3, %g1, 84
	ld	%g30, %g1, 20
	st	%g31, %g1, 100
	ld	%g29, %g30, 0
	addi	%g1, %g1, 104
	call	%g29
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	b	ble_cont.22916
ble_else.22915:
ble_cont.22916:
	mvhi	%g4, 0
	mvlo	%g4, 118
	ld	%g3, %g1, 80
	ld	%g30, %g1, 12
	st	%g31, %g1, 100
	ld	%g29, %g30, 0
	addi	%g1, %g1, 104
	call	%g29
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	ld	%g3, %g1, 76
	subi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22921
	slli	%g4, %g3, 2
	ld	%g5, %g1, 4
	ld	%g4, %g5, %g4
	mvhi	%g5, 0
	mvlo	%g5, 119
	ld	%g30, %g1, 12
	st	%g3, %g1, 96
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 100
	ld	%g29, %g30, 0
	addi	%g1, %g1, 104
	call	%g29
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	ld	%g3, %g1, 96
	subi	%g3, %g3, 1
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
ble_else.22921:
	return
ble_else.22914:
	return
ble_else.22907:
	return
ble_else.22894:
	return
setup_rect_reflection.3263:
	ld	%g5, %g30, 24
	ld	%g6, %g30, 20
	ld	%g7, %g30, 16
	ld	%g8, %g30, 12
	ld	%g9, %g30, 8
	ld	%g10, %g30, 4
	slli	%g3, %g3, 2
	ld	%g11, %g7, 0
	setL %g12, l.14053
	fld	%f0, %g12, 0
	ld	%g4, %g4, 28
	fld	%f1, %g4, 0
	fsub	%f0, %f0, %f1
	fld	%f1, %g9, 0
	fneg	%f1, %f1
	fld	%f2, %g9, 8
	fneg	%f2, %f2
	fld	%f3, %g9, 16
	fneg	%f3, %f3
	addi	%g4, %g3, 1
	fld	%f4, %g9, 0
	mvhi	%g12, 0
	mvlo	%g12, 3
	setL %g13, l.14007
	fld	%f5, %g13, 0
	st	%g7, %g1, 0
	std	%f1, %g1, 8
	st	%g9, %g1, 16
	st	%g3, %g1, 20
	st	%g5, %g1, 24
	st	%g11, %g1, 28
	st	%g4, %g1, 32
	std	%f0, %g1, 40
	st	%g10, %g1, 48
	st	%g6, %g1, 52
	std	%f3, %g1, 56
	std	%f2, %g1, 64
	std	%f4, %g1, 72
	st	%g8, %g1, 80
	mov	%g3, %g12
	fmov	%f0, %f5
	st	%g31, %g1, 84
	addi	%g1, %g1, 88
	call	min_caml_create_float_array
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mov	%g4, %g3
	ld	%g3, %g1, 80
	ld	%g5, %g3, 0
	st	%g4, %g1, 84
	mov	%g3, %g5
	st	%g31, %g1, 92
	addi	%g1, %g1, 96
	call	min_caml_create_array
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, 4
	ld	%g5, %g1, 84
	st	%g5, %g4, 0
	fld	%f0, %g1, 72
	fst	%f0, %g5, 0
	fld	%f0, %g1, 64
	fst	%f0, %g5, 8
	fld	%f1, %g1, 56
	fst	%f1, %g5, 16
	ld	%g6, %g1, 80
	ld	%g7, %g6, 0
	subi	%g7, %g7, 1
	mvhi	%g8, 0
	mvlo	%g8, 0
	st	%g4, %g1, 88
	blt	%g7, %g8, ble_else.22928
	slli	%g8, %g7, 2
	ld	%g9, %g1, 52
	ld	%g8, %g9, %g8
	ld	%g10, %g8, 4
	mvhi	%g11, 0
	mvlo	%g11, 1
	bne	%g10, %g11, beq_else.22930
	st	%g3, %g1, 92
	st	%g7, %g1, 96
	mov	%g4, %g8
	mov	%g3, %g5
	st	%g31, %g1, 100
	addi	%g1, %g1, 104
	call	setup_rect_table.3022
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	ld	%g4, %g1, 96
	slli	%g5, %g4, 2
	ld	%g6, %g1, 92
	st	%g3, %g6, %g5
	b	beq_cont.22931
beq_else.22930:
	mvhi	%g11, 0
	mvlo	%g11, 2
	bne	%g10, %g11, beq_else.22932
	st	%g3, %g1, 92
	st	%g7, %g1, 96
	mov	%g4, %g8
	mov	%g3, %g5
	st	%g31, %g1, 100
	addi	%g1, %g1, 104
	call	setup_surface_table.3025
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	ld	%g4, %g1, 96
	slli	%g5, %g4, 2
	ld	%g6, %g1, 92
	st	%g3, %g6, %g5
	b	beq_cont.22933
beq_else.22932:
	st	%g3, %g1, 92
	st	%g7, %g1, 96
	mov	%g4, %g8
	mov	%g3, %g5
	st	%g31, %g1, 100
	addi	%g1, %g1, 104
	call	setup_second_table.3028
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	ld	%g4, %g1, 96
	slli	%g5, %g4, 2
	ld	%g6, %g1, 92
	st	%g3, %g6, %g5
beq_cont.22933:
beq_cont.22931:
	subi	%g4, %g4, 1
	ld	%g3, %g1, 88
	ld	%g30, %g1, 48
	st	%g31, %g1, 100
	ld	%g29, %g30, 0
	addi	%g1, %g1, 104
	call	%g29
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	b	ble_cont.22929
ble_else.22928:
ble_cont.22929:
	mov	%g3, %g2
	addi	%g2, %g2, 16
	fld	%f0, %g1, 40
	fst	%f0, %g3, 8
	ld	%g4, %g1, 88
	st	%g4, %g3, 4
	ld	%g4, %g1, 32
	st	%g4, %g3, 0
	ld	%g4, %g1, 28
	slli	%g5, %g4, 2
	ld	%g6, %g1, 24
	st	%g3, %g6, %g5
	addi	%g3, %g4, 1
	ld	%g5, %g1, 20
	addi	%g7, %g5, 2
	ld	%g8, %g1, 16
	fld	%f1, %g8, 8
	mvhi	%g9, 0
	mvlo	%g9, 3
	setL %g10, l.14007
	fld	%f2, %g10, 0
	st	%g3, %g1, 100
	st	%g7, %g1, 104
	std	%f1, %g1, 112
	mov	%g3, %g9
	fmov	%f0, %f2
	st	%g31, %g1, 124
	addi	%g1, %g1, 128
	call	min_caml_create_float_array
	subi	%g1, %g1, 128
	ld	%g31, %g1, 124
	mov	%g4, %g3
	ld	%g3, %g1, 80
	ld	%g5, %g3, 0
	st	%g4, %g1, 120
	mov	%g3, %g5
	st	%g31, %g1, 124
	addi	%g1, %g1, 128
	call	min_caml_create_array
	subi	%g1, %g1, 128
	ld	%g31, %g1, 124
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, 4
	ld	%g5, %g1, 120
	st	%g5, %g4, 0
	fld	%f0, %g1, 8
	fst	%f0, %g5, 0
	fld	%f1, %g1, 112
	fst	%f1, %g5, 8
	fld	%f1, %g1, 56
	fst	%f1, %g5, 16
	ld	%g6, %g1, 80
	ld	%g7, %g6, 0
	subi	%g7, %g7, 1
	mvhi	%g8, 0
	mvlo	%g8, 0
	st	%g4, %g1, 124
	blt	%g7, %g8, ble_else.22935
	slli	%g8, %g7, 2
	ld	%g9, %g1, 52
	ld	%g8, %g9, %g8
	ld	%g10, %g8, 4
	mvhi	%g11, 0
	mvlo	%g11, 1
	bne	%g10, %g11, beq_else.22937
	st	%g3, %g1, 128
	st	%g7, %g1, 132
	mov	%g4, %g8
	mov	%g3, %g5
	st	%g31, %g1, 140
	addi	%g1, %g1, 144
	call	setup_rect_table.3022
	subi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g4, %g1, 132
	slli	%g5, %g4, 2
	ld	%g6, %g1, 128
	st	%g3, %g6, %g5
	b	beq_cont.22938
beq_else.22937:
	mvhi	%g11, 0
	mvlo	%g11, 2
	bne	%g10, %g11, beq_else.22939
	st	%g3, %g1, 128
	st	%g7, %g1, 132
	mov	%g4, %g8
	mov	%g3, %g5
	st	%g31, %g1, 140
	addi	%g1, %g1, 144
	call	setup_surface_table.3025
	subi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g4, %g1, 132
	slli	%g5, %g4, 2
	ld	%g6, %g1, 128
	st	%g3, %g6, %g5
	b	beq_cont.22940
beq_else.22939:
	st	%g3, %g1, 128
	st	%g7, %g1, 132
	mov	%g4, %g8
	mov	%g3, %g5
	st	%g31, %g1, 140
	addi	%g1, %g1, 144
	call	setup_second_table.3028
	subi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g4, %g1, 132
	slli	%g5, %g4, 2
	ld	%g6, %g1, 128
	st	%g3, %g6, %g5
beq_cont.22940:
beq_cont.22938:
	subi	%g4, %g4, 1
	ld	%g3, %g1, 124
	ld	%g30, %g1, 48
	st	%g31, %g1, 140
	ld	%g29, %g30, 0
	addi	%g1, %g1, 144
	call	%g29
	subi	%g1, %g1, 144
	ld	%g31, %g1, 140
	b	ble_cont.22936
ble_else.22935:
ble_cont.22936:
	mov	%g3, %g2
	addi	%g2, %g2, 16
	fld	%f0, %g1, 40
	fst	%f0, %g3, 8
	ld	%g4, %g1, 124
	st	%g4, %g3, 4
	ld	%g4, %g1, 104
	st	%g4, %g3, 0
	ld	%g4, %g1, 100
	slli	%g4, %g4, 2
	ld	%g5, %g1, 24
	st	%g3, %g5, %g4
	ld	%g3, %g1, 28
	addi	%g4, %g3, 2
	ld	%g6, %g1, 20
	addi	%g6, %g6, 3
	ld	%g7, %g1, 16
	fld	%f1, %g7, 16
	mvhi	%g7, 0
	mvlo	%g7, 3
	setL %g8, l.14007
	fld	%f2, %g8, 0
	st	%g4, %g1, 136
	st	%g6, %g1, 140
	std	%f1, %g1, 144
	mov	%g3, %g7
	fmov	%f0, %f2
	st	%g31, %g1, 156
	addi	%g1, %g1, 160
	call	min_caml_create_float_array
	subi	%g1, %g1, 160
	ld	%g31, %g1, 156
	mov	%g4, %g3
	ld	%g3, %g1, 80
	ld	%g5, %g3, 0
	st	%g4, %g1, 152
	mov	%g3, %g5
	st	%g31, %g1, 156
	addi	%g1, %g1, 160
	call	min_caml_create_array
	subi	%g1, %g1, 160
	ld	%g31, %g1, 156
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, 4
	ld	%g5, %g1, 152
	st	%g5, %g4, 0
	fld	%f0, %g1, 8
	fst	%f0, %g5, 0
	fld	%f0, %g1, 64
	fst	%f0, %g5, 8
	fld	%f0, %g1, 144
	fst	%f0, %g5, 16
	ld	%g6, %g1, 80
	ld	%g6, %g6, 0
	subi	%g6, %g6, 1
	mvhi	%g7, 0
	mvlo	%g7, 0
	st	%g4, %g1, 156
	blt	%g6, %g7, ble_else.22941
	slli	%g7, %g6, 2
	ld	%g8, %g1, 52
	ld	%g7, %g8, %g7
	ld	%g8, %g7, 4
	mvhi	%g9, 0
	mvlo	%g9, 1
	bne	%g8, %g9, beq_else.22943
	st	%g3, %g1, 160
	st	%g6, %g1, 164
	mov	%g4, %g7
	mov	%g3, %g5
	st	%g31, %g1, 172
	addi	%g1, %g1, 176
	call	setup_rect_table.3022
	subi	%g1, %g1, 176
	ld	%g31, %g1, 172
	ld	%g4, %g1, 164
	slli	%g5, %g4, 2
	ld	%g6, %g1, 160
	st	%g3, %g6, %g5
	b	beq_cont.22944
beq_else.22943:
	mvhi	%g9, 0
	mvlo	%g9, 2
	bne	%g8, %g9, beq_else.22945
	st	%g3, %g1, 160
	st	%g6, %g1, 164
	mov	%g4, %g7
	mov	%g3, %g5
	st	%g31, %g1, 172
	addi	%g1, %g1, 176
	call	setup_surface_table.3025
	subi	%g1, %g1, 176
	ld	%g31, %g1, 172
	ld	%g4, %g1, 164
	slli	%g5, %g4, 2
	ld	%g6, %g1, 160
	st	%g3, %g6, %g5
	b	beq_cont.22946
beq_else.22945:
	st	%g3, %g1, 160
	st	%g6, %g1, 164
	mov	%g4, %g7
	mov	%g3, %g5
	st	%g31, %g1, 172
	addi	%g1, %g1, 176
	call	setup_second_table.3028
	subi	%g1, %g1, 176
	ld	%g31, %g1, 172
	ld	%g4, %g1, 164
	slli	%g5, %g4, 2
	ld	%g6, %g1, 160
	st	%g3, %g6, %g5
beq_cont.22946:
beq_cont.22944:
	subi	%g4, %g4, 1
	ld	%g3, %g1, 156
	ld	%g30, %g1, 48
	st	%g31, %g1, 172
	ld	%g29, %g30, 0
	addi	%g1, %g1, 176
	call	%g29
	subi	%g1, %g1, 176
	ld	%g31, %g1, 172
	b	ble_cont.22942
ble_else.22941:
ble_cont.22942:
	mov	%g3, %g2
	addi	%g2, %g2, 16
	fld	%f0, %g1, 40
	fst	%f0, %g3, 8
	ld	%g4, %g1, 156
	st	%g4, %g3, 4
	ld	%g4, %g1, 140
	st	%g4, %g3, 0
	ld	%g4, %g1, 136
	slli	%g4, %g4, 2
	ld	%g5, %g1, 24
	st	%g3, %g5, %g4
	ld	%g3, %g1, 28
	addi	%g3, %g3, 3
	ld	%g4, %g1, 0
	st	%g3, %g4, 0
	return
setup_surface_reflection.3266:
	ld	%g5, %g30, 24
	ld	%g6, %g30, 20
	ld	%g7, %g30, 16
	ld	%g8, %g30, 12
	ld	%g9, %g30, 8
	ld	%g10, %g30, 4
	slli	%g3, %g3, 2
	addi	%g3, %g3, 1
	ld	%g11, %g7, 0
	setL %g12, l.14053
	fld	%f0, %g12, 0
	ld	%g12, %g4, 28
	fld	%f1, %g12, 0
	fsub	%f0, %f0, %f1
	ld	%g12, %g4, 16
	fld	%f1, %g9, 0
	fld	%f2, %g12, 0
	fmul	%f1, %f1, %f2
	fld	%f2, %g9, 8
	fld	%f3, %g12, 8
	fmul	%f2, %f2, %f3
	fadd	%f1, %f1, %f2
	fld	%f2, %g9, 16
	fld	%f3, %g12, 16
	fmul	%f2, %f2, %f3
	fadd	%f1, %f1, %f2
	setL %g12, l.14068
	fld	%f2, %g12, 0
	ld	%g12, %g4, 16
	fld	%f3, %g12, 0
	fmul	%f2, %f2, %f3
	fmul	%f2, %f2, %f1
	fld	%f3, %g9, 0
	fsub	%f2, %f2, %f3
	setL %g12, l.14068
	fld	%f3, %g12, 0
	ld	%g12, %g4, 16
	fld	%f4, %g12, 8
	fmul	%f3, %f3, %f4
	fmul	%f3, %f3, %f1
	fld	%f4, %g9, 8
	fsub	%f3, %f3, %f4
	setL %g12, l.14068
	fld	%f4, %g12, 0
	ld	%g4, %g4, 16
	fld	%f5, %g4, 16
	fmul	%f4, %f4, %f5
	fmul	%f1, %f4, %f1
	fld	%f4, %g9, 16
	fsub	%f1, %f1, %f4
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g9, l.14007
	fld	%f4, %g9, 0
	st	%g7, %g1, 0
	st	%g5, %g1, 4
	st	%g11, %g1, 8
	st	%g3, %g1, 12
	std	%f0, %g1, 16
	st	%g10, %g1, 24
	st	%g6, %g1, 28
	std	%f1, %g1, 32
	std	%f3, %g1, 40
	std	%f2, %g1, 48
	st	%g8, %g1, 56
	mov	%g3, %g4
	fmov	%f0, %f4
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	min_caml_create_float_array
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mov	%g4, %g3
	ld	%g3, %g1, 56
	ld	%g5, %g3, 0
	st	%g4, %g1, 60
	mov	%g3, %g5
	st	%g31, %g1, 68
	addi	%g1, %g1, 72
	call	min_caml_create_array
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, 4
	ld	%g5, %g1, 60
	st	%g5, %g4, 0
	fld	%f0, %g1, 48
	fst	%f0, %g5, 0
	fld	%f0, %g1, 40
	fst	%f0, %g5, 8
	fld	%f0, %g1, 32
	fst	%f0, %g5, 16
	ld	%g6, %g1, 56
	ld	%g6, %g6, 0
	subi	%g6, %g6, 1
	mvhi	%g7, 0
	mvlo	%g7, 0
	st	%g4, %g1, 64
	blt	%g6, %g7, ble_else.22948
	slli	%g7, %g6, 2
	ld	%g8, %g1, 28
	ld	%g7, %g8, %g7
	ld	%g8, %g7, 4
	mvhi	%g9, 0
	mvlo	%g9, 1
	bne	%g8, %g9, beq_else.22950
	st	%g3, %g1, 68
	st	%g6, %g1, 72
	mov	%g4, %g7
	mov	%g3, %g5
	st	%g31, %g1, 76
	addi	%g1, %g1, 80
	call	setup_rect_table.3022
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g4, %g1, 72
	slli	%g5, %g4, 2
	ld	%g6, %g1, 68
	st	%g3, %g6, %g5
	b	beq_cont.22951
beq_else.22950:
	mvhi	%g9, 0
	mvlo	%g9, 2
	bne	%g8, %g9, beq_else.22952
	st	%g3, %g1, 68
	st	%g6, %g1, 72
	mov	%g4, %g7
	mov	%g3, %g5
	st	%g31, %g1, 76
	addi	%g1, %g1, 80
	call	setup_surface_table.3025
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g4, %g1, 72
	slli	%g5, %g4, 2
	ld	%g6, %g1, 68
	st	%g3, %g6, %g5
	b	beq_cont.22953
beq_else.22952:
	st	%g3, %g1, 68
	st	%g6, %g1, 72
	mov	%g4, %g7
	mov	%g3, %g5
	st	%g31, %g1, 76
	addi	%g1, %g1, 80
	call	setup_second_table.3028
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	ld	%g4, %g1, 72
	slli	%g5, %g4, 2
	ld	%g6, %g1, 68
	st	%g3, %g6, %g5
beq_cont.22953:
beq_cont.22951:
	subi	%g4, %g4, 1
	ld	%g3, %g1, 64
	ld	%g30, %g1, 24
	st	%g31, %g1, 76
	ld	%g29, %g30, 0
	addi	%g1, %g1, 80
	call	%g29
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	b	ble_cont.22949
ble_else.22948:
ble_cont.22949:
	mov	%g3, %g2
	addi	%g2, %g2, 16
	fld	%f0, %g1, 16
	fst	%f0, %g3, 8
	ld	%g4, %g1, 64
	st	%g4, %g3, 4
	ld	%g4, %g1, 12
	st	%g4, %g3, 0
	ld	%g4, %g1, 8
	slli	%g5, %g4, 2
	ld	%g6, %g1, 4
	st	%g3, %g6, %g5
	addi	%g3, %g4, 1
	ld	%g4, %g1, 0
	st	%g3, %g4, 0
	return
rt.3271:
	ld	%g5, %g30, 100
	ld	%g6, %g30, 96
	ld	%g7, %g30, 92
	ld	%g8, %g30, 88
	ld	%g9, %g30, 84
	ld	%g10, %g30, 80
	ld	%g11, %g30, 76
	ld	%g12, %g30, 72
	ld	%g13, %g30, 68
	ld	%g14, %g30, 64
	ld	%g15, %g30, 60
	ld	%g16, %g30, 56
	ld	%g17, %g30, 52
	ld	%g18, %g30, 48
	ld	%g19, %g30, 44
	ld	%g20, %g30, 40
	ld	%g21, %g30, 36
	ld	%g22, %g30, 32
	ld	%g23, %g30, 28
	ld	%g24, %g30, 24
	ld	%g25, %g30, 20
	ld	%g26, %g30, 16
	ld	%g27, %g30, 12
	ld	%g28, %g30, 8
	ld	%g29, %g30, 4
	st	%g3, %g25, 0
	st	%g4, %g25, 4
	slli	%g30, %g3, -1
	st	%g30, %g26, 0
	slli	%g4, %g4, -1
	st	%g4, %g26, 4
	setL %g4, l.15993
	fld	%f0, %g4, 0
	st	%g10, %g1, 0
	st	%g8, %g1, 4
	st	%g16, %g1, 8
	st	%g6, %g1, 12
	st	%g7, %g1, 16
	st	%g20, %g1, 20
	st	%g5, %g1, 24
	st	%g21, %g1, 28
	st	%g23, %g1, 32
	st	%g24, %g1, 36
	st	%g22, %g1, 40
	st	%g18, %g1, 44
	st	%g27, %g1, 48
	st	%g29, %g1, 52
	st	%g28, %g1, 56
	st	%g17, %g1, 60
	st	%g15, %g1, 64
	st	%g12, %g1, 68
	st	%g19, %g1, 72
	st	%g13, %g1, 76
	st	%g14, %g1, 80
	st	%g11, %g1, 84
	st	%g25, %g1, 88
	st	%g9, %g1, 92
	std	%f0, %g1, 96
	st	%g31, %g1, 108
	addi	%g1, %g1, 112
	call	min_caml_float_of_int
	subi	%g1, %g1, 112
	ld	%g31, %g1, 108
	fld	%f1, %g1, 96
	fdiv	%f0, %f1, %f0
	ld	%g3, %g1, 92
	fst	%f0, %g3, 0
	ld	%g3, %g1, 88
	ld	%g4, %g3, 0
	mvhi	%g5, 0
	mvlo	%g5, 3
	setL %g6, l.14007
	fld	%f0, %g6, 0
	st	%g4, %g1, 104
	mov	%g3, %g5
	st	%g31, %g1, 108
	addi	%g1, %g1, 112
	call	min_caml_create_float_array
	subi	%g1, %g1, 112
	ld	%g31, %g1, 108
	st	%g3, %g1, 108
	st	%g31, %g1, 116
	addi	%g1, %g1, 120
	call	create_float5x3array.3211
	subi	%g1, %g1, 120
	ld	%g31, %g1, 116
	mvhi	%g4, 0
	mvlo	%g4, 5
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 112
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 116
	addi	%g1, %g1, 120
	call	min_caml_create_array
	subi	%g1, %g1, 120
	ld	%g31, %g1, 116
	mvhi	%g4, 0
	mvlo	%g4, 5
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 116
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 124
	addi	%g1, %g1, 128
	call	min_caml_create_array
	subi	%g1, %g1, 128
	ld	%g31, %g1, 124
	st	%g3, %g1, 120
	st	%g31, %g1, 124
	addi	%g1, %g1, 128
	call	create_float5x3array.3211
	subi	%g1, %g1, 128
	ld	%g31, %g1, 124
	st	%g3, %g1, 124
	st	%g31, %g1, 132
	addi	%g1, %g1, 136
	call	create_float5x3array.3211
	subi	%g1, %g1, 136
	ld	%g31, %g1, 132
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 128
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 132
	addi	%g1, %g1, 136
	call	min_caml_create_array
	subi	%g1, %g1, 136
	ld	%g31, %g1, 132
	st	%g3, %g1, 132
	st	%g31, %g1, 140
	addi	%g1, %g1, 144
	call	create_float5x3array.3211
	subi	%g1, %g1, 144
	ld	%g31, %g1, 140
	mov	%g4, %g2
	addi	%g2, %g2, 32
	st	%g3, %g4, 28
	ld	%g3, %g1, 132
	st	%g3, %g4, 24
	ld	%g3, %g1, 128
	st	%g3, %g4, 20
	ld	%g3, %g1, 124
	st	%g3, %g4, 16
	ld	%g3, %g1, 120
	st	%g3, %g4, 12
	ld	%g3, %g1, 116
	st	%g3, %g4, 8
	ld	%g3, %g1, 112
	st	%g3, %g4, 4
	ld	%g3, %g1, 108
	st	%g3, %g4, 0
	ld	%g3, %g1, 104
	st	%g31, %g1, 140
	addi	%g1, %g1, 144
	call	min_caml_create_array
	subi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g4, %g1, 88
	ld	%g5, %g4, 0
	subi	%g5, %g5, 2
	mov	%g4, %g5
	st	%g31, %g1, 140
	addi	%g1, %g1, 144
	call	init_line_elements.3215
	subi	%g1, %g1, 144
	ld	%g31, %g1, 140
	ld	%g4, %g1, 88
	ld	%g5, %g4, 0
	mvhi	%g6, 0
	mvlo	%g6, 3
	setL %g7, l.14007
	fld	%f0, %g7, 0
	st	%g3, %g1, 136
	st	%g5, %g1, 140
	mov	%g3, %g6
	st	%g31, %g1, 148
	addi	%g1, %g1, 152
	call	min_caml_create_float_array
	subi	%g1, %g1, 152
	ld	%g31, %g1, 148
	st	%g3, %g1, 144
	st	%g31, %g1, 148
	addi	%g1, %g1, 152
	call	create_float5x3array.3211
	subi	%g1, %g1, 152
	ld	%g31, %g1, 148
	mvhi	%g4, 0
	mvlo	%g4, 5
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 148
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 156
	addi	%g1, %g1, 160
	call	min_caml_create_array
	subi	%g1, %g1, 160
	ld	%g31, %g1, 156
	mvhi	%g4, 0
	mvlo	%g4, 5
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 152
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 156
	addi	%g1, %g1, 160
	call	min_caml_create_array
	subi	%g1, %g1, 160
	ld	%g31, %g1, 156
	st	%g3, %g1, 156
	st	%g31, %g1, 164
	addi	%g1, %g1, 168
	call	create_float5x3array.3211
	subi	%g1, %g1, 168
	ld	%g31, %g1, 164
	st	%g3, %g1, 160
	st	%g31, %g1, 164
	addi	%g1, %g1, 168
	call	create_float5x3array.3211
	subi	%g1, %g1, 168
	ld	%g31, %g1, 164
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 164
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 172
	addi	%g1, %g1, 176
	call	min_caml_create_array
	subi	%g1, %g1, 176
	ld	%g31, %g1, 172
	st	%g3, %g1, 168
	st	%g31, %g1, 172
	addi	%g1, %g1, 176
	call	create_float5x3array.3211
	subi	%g1, %g1, 176
	ld	%g31, %g1, 172
	mov	%g4, %g2
	addi	%g2, %g2, 32
	st	%g3, %g4, 28
	ld	%g3, %g1, 168
	st	%g3, %g4, 24
	ld	%g3, %g1, 164
	st	%g3, %g4, 20
	ld	%g3, %g1, 160
	st	%g3, %g4, 16
	ld	%g3, %g1, 156
	st	%g3, %g4, 12
	ld	%g3, %g1, 152
	st	%g3, %g4, 8
	ld	%g3, %g1, 148
	st	%g3, %g4, 4
	ld	%g3, %g1, 144
	st	%g3, %g4, 0
	ld	%g3, %g1, 140
	st	%g31, %g1, 172
	addi	%g1, %g1, 176
	call	min_caml_create_array
	subi	%g1, %g1, 176
	ld	%g31, %g1, 172
	ld	%g4, %g1, 88
	ld	%g5, %g4, 0
	subi	%g5, %g5, 2
	mov	%g4, %g5
	st	%g31, %g1, 172
	addi	%g1, %g1, 176
	call	init_line_elements.3215
	subi	%g1, %g1, 176
	ld	%g31, %g1, 172
	ld	%g4, %g1, 88
	ld	%g5, %g4, 0
	mvhi	%g6, 0
	mvlo	%g6, 3
	setL %g7, l.14007
	fld	%f0, %g7, 0
	st	%g3, %g1, 172
	st	%g5, %g1, 176
	mov	%g3, %g6
	st	%g31, %g1, 180
	addi	%g1, %g1, 184
	call	min_caml_create_float_array
	subi	%g1, %g1, 184
	ld	%g31, %g1, 180
	st	%g3, %g1, 180
	st	%g31, %g1, 188
	addi	%g1, %g1, 192
	call	create_float5x3array.3211
	subi	%g1, %g1, 192
	ld	%g31, %g1, 188
	mvhi	%g4, 0
	mvlo	%g4, 5
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 184
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 188
	addi	%g1, %g1, 192
	call	min_caml_create_array
	subi	%g1, %g1, 192
	ld	%g31, %g1, 188
	mvhi	%g4, 0
	mvlo	%g4, 5
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 188
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 196
	addi	%g1, %g1, 200
	call	min_caml_create_array
	subi	%g1, %g1, 200
	ld	%g31, %g1, 196
	st	%g3, %g1, 192
	st	%g31, %g1, 196
	addi	%g1, %g1, 200
	call	create_float5x3array.3211
	subi	%g1, %g1, 200
	ld	%g31, %g1, 196
	st	%g3, %g1, 196
	st	%g31, %g1, 204
	addi	%g1, %g1, 208
	call	create_float5x3array.3211
	subi	%g1, %g1, 208
	ld	%g31, %g1, 204
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 200
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 204
	addi	%g1, %g1, 208
	call	min_caml_create_array
	subi	%g1, %g1, 208
	ld	%g31, %g1, 204
	st	%g3, %g1, 204
	st	%g31, %g1, 212
	addi	%g1, %g1, 216
	call	create_float5x3array.3211
	subi	%g1, %g1, 216
	ld	%g31, %g1, 212
	mov	%g4, %g2
	addi	%g2, %g2, 32
	st	%g3, %g4, 28
	ld	%g3, %g1, 204
	st	%g3, %g4, 24
	ld	%g3, %g1, 200
	st	%g3, %g4, 20
	ld	%g3, %g1, 196
	st	%g3, %g4, 16
	ld	%g3, %g1, 192
	st	%g3, %g4, 12
	ld	%g3, %g1, 188
	st	%g3, %g4, 8
	ld	%g3, %g1, 184
	st	%g3, %g4, 4
	ld	%g3, %g1, 180
	st	%g3, %g4, 0
	ld	%g3, %g1, 176
	st	%g31, %g1, 212
	addi	%g1, %g1, 216
	call	min_caml_create_array
	subi	%g1, %g1, 216
	ld	%g31, %g1, 212
	ld	%g4, %g1, 88
	ld	%g5, %g4, 0
	subi	%g5, %g5, 2
	mov	%g4, %g5
	st	%g31, %g1, 212
	addi	%g1, %g1, 216
	call	init_line_elements.3215
	subi	%g1, %g1, 216
	ld	%g31, %g1, 212
	ld	%g30, %g1, 84
	st	%g3, %g1, 208
	st	%g31, %g1, 212
	ld	%g29, %g30, 0
	addi	%g1, %g1, 216
	call	%g29
	subi	%g1, %g1, 216
	ld	%g31, %g1, 212
	ld	%g30, %g1, 80
	st	%g31, %g1, 212
	ld	%g29, %g30, 0
	addi	%g1, %g1, 216
	call	%g29
	subi	%g1, %g1, 216
	ld	%g31, %g1, 212
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g30, %g1, 76
	st	%g3, %g1, 212
	st	%g31, %g1, 220
	ld	%g29, %g30, 0
	addi	%g1, %g1, 224
	call	%g29
	subi	%g1, %g1, 224
	ld	%g31, %g1, 220
	mvhi	%g4, 0
	mvlo	%g4, 0
	bne	%g3, %g4, beq_else.22955
	ld	%g3, %g1, 72
	ld	%g4, %g1, 212
	st	%g4, %g3, 0
	b	beq_cont.22956
beq_else.22955:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g30, %g1, 68
	st	%g31, %g1, 220
	ld	%g29, %g30, 0
	addi	%g1, %g1, 224
	call	%g29
	subi	%g1, %g1, 224
	ld	%g31, %g1, 220
beq_cont.22956:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g30, %g1, 64
	st	%g31, %g1, 220
	ld	%g29, %g30, 0
	addi	%g1, %g1, 224
	call	%g29
	subi	%g1, %g1, 224
	ld	%g31, %g1, 220
	mvhi	%g3, 0
	mvlo	%g3, 0
	st	%g31, %g1, 220
	addi	%g1, %g1, 224
	call	read_or_network.2932
	subi	%g1, %g1, 224
	ld	%g31, %g1, 220
	ld	%g4, %g1, 60
	st	%g3, %g4, 0
	st	%g31, %g1, 220
	addi	%g1, %g1, 224
	call	write_ppm_header.3179
	subi	%g1, %g1, 224
	ld	%g31, %g1, 220
	mvhi	%g3, 0
	mvlo	%g3, 4
	ld	%g30, %g1, 56
	st	%g31, %g1, 220
	ld	%g29, %g30, 0
	addi	%g1, %g1, 224
	call	%g29
	subi	%g1, %g1, 224
	ld	%g31, %g1, 220
	mvhi	%g3, 0
	mvlo	%g3, 9
	mvhi	%g4, 0
	mvlo	%g4, 0
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g30, %g1, 52
	st	%g31, %g1, 220
	ld	%g29, %g30, 0
	addi	%g1, %g1, 224
	call	%g29
	subi	%g1, %g1, 224
	ld	%g31, %g1, 220
	ld	%g3, %g1, 48
	ld	%g4, %g3, 16
	ld	%g5, %g4, 476
	ld	%g6, %g1, 72
	ld	%g7, %g6, 0
	subi	%g7, %g7, 1
	mvhi	%g8, 0
	mvlo	%g8, 0
	st	%g4, %g1, 216
	blt	%g7, %g8, ble_else.22957
	slli	%g8, %g7, 2
	ld	%g9, %g1, 44
	ld	%g8, %g9, %g8
	ld	%g10, %g5, 4
	ld	%g11, %g5, 0
	ld	%g12, %g8, 4
	mvhi	%g13, 0
	mvlo	%g13, 1
	st	%g5, %g1, 220
	bne	%g12, %g13, beq_else.22959
	st	%g10, %g1, 224
	st	%g7, %g1, 228
	mov	%g4, %g8
	mov	%g3, %g11
	st	%g31, %g1, 236
	addi	%g1, %g1, 240
	call	setup_rect_table.3022
	subi	%g1, %g1, 240
	ld	%g31, %g1, 236
	ld	%g4, %g1, 228
	slli	%g5, %g4, 2
	ld	%g6, %g1, 224
	st	%g3, %g6, %g5
	b	beq_cont.22960
beq_else.22959:
	mvhi	%g13, 0
	mvlo	%g13, 2
	bne	%g12, %g13, beq_else.22961
	st	%g10, %g1, 224
	st	%g7, %g1, 228
	mov	%g4, %g8
	mov	%g3, %g11
	st	%g31, %g1, 236
	addi	%g1, %g1, 240
	call	setup_surface_table.3025
	subi	%g1, %g1, 240
	ld	%g31, %g1, 236
	ld	%g4, %g1, 228
	slli	%g5, %g4, 2
	ld	%g6, %g1, 224
	st	%g3, %g6, %g5
	b	beq_cont.22962
beq_else.22961:
	st	%g10, %g1, 224
	st	%g7, %g1, 228
	mov	%g4, %g8
	mov	%g3, %g11
	st	%g31, %g1, 236
	addi	%g1, %g1, 240
	call	setup_second_table.3028
	subi	%g1, %g1, 240
	ld	%g31, %g1, 236
	ld	%g4, %g1, 228
	slli	%g5, %g4, 2
	ld	%g6, %g1, 224
	st	%g3, %g6, %g5
beq_cont.22962:
beq_cont.22960:
	subi	%g4, %g4, 1
	ld	%g3, %g1, 220
	ld	%g30, %g1, 40
	st	%g31, %g1, 236
	ld	%g29, %g30, 0
	addi	%g1, %g1, 240
	call	%g29
	subi	%g1, %g1, 240
	ld	%g31, %g1, 236
	b	ble_cont.22958
ble_else.22957:
ble_cont.22958:
	mvhi	%g4, 0
	mvlo	%g4, 118
	ld	%g3, %g1, 216
	ld	%g30, %g1, 36
	st	%g31, %g1, 236
	ld	%g29, %g30, 0
	addi	%g1, %g1, 240
	call	%g29
	subi	%g1, %g1, 240
	ld	%g31, %g1, 236
	ld	%g3, %g1, 48
	ld	%g3, %g3, 12
	mvhi	%g4, 0
	mvlo	%g4, 119
	ld	%g30, %g1, 36
	st	%g31, %g1, 236
	ld	%g29, %g30, 0
	addi	%g1, %g1, 240
	call	%g29
	subi	%g1, %g1, 240
	ld	%g31, %g1, 236
	mvhi	%g3, 0
	mvlo	%g3, 2
	ld	%g30, %g1, 32
	st	%g31, %g1, 236
	ld	%g29, %g30, 0
	addi	%g1, %g1, 240
	call	%g29
	subi	%g1, %g1, 240
	ld	%g31, %g1, 236
	ld	%g3, %g1, 28
	fld	%f0, %g3, 0
	ld	%g4, %g1, 24
	fst	%f0, %g4, 0
	fld	%f0, %g3, 8
	fst	%f0, %g4, 8
	fld	%f0, %g3, 16
	fst	%f0, %g4, 16
	ld	%g3, %g1, 72
	ld	%g4, %g3, 0
	subi	%g4, %g4, 1
	ld	%g5, %g1, 20
	ld	%g30, %g1, 40
	mov	%g3, %g5
	st	%g31, %g1, 236
	ld	%g29, %g30, 0
	addi	%g1, %g1, 240
	call	%g29
	subi	%g1, %g1, 240
	ld	%g31, %g1, 236
	ld	%g3, %g1, 72
	ld	%g3, %g3, 0
	subi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 0
	blt	%g3, %g4, ble_else.22963
	slli	%g4, %g3, 2
	ld	%g5, %g1, 44
	ld	%g4, %g5, %g4
	ld	%g5, %g4, 8
	mvhi	%g6, 0
	mvlo	%g6, 2
	bne	%g5, %g6, beq_else.22965
	ld	%g5, %g4, 28
	fld	%f0, %g5, 0
	setL %g5, l.14053
	fld	%f1, %g5, 0
	fblt	%f0, %f1, fble_else.22967
	mvhi	%g5, 0
	mvlo	%g5, 1
	b	fble_cont.22968
fble_else.22967:
	mvhi	%g5, 0
	mvlo	%g5, 0
fble_cont.22968:
	mvhi	%g6, 0
	mvlo	%g6, 0
	bne	%g5, %g6, beq_else.22969
	b	beq_cont.22970
beq_else.22969:
	ld	%g5, %g4, 4
	mvhi	%g6, 0
	mvlo	%g6, 1
	bne	%g5, %g6, beq_else.22971
	ld	%g30, %g1, 16
	st	%g31, %g1, 236
	ld	%g29, %g30, 0
	addi	%g1, %g1, 240
	call	%g29
	subi	%g1, %g1, 240
	ld	%g31, %g1, 236
	b	beq_cont.22972
beq_else.22971:
	mvhi	%g6, 0
	mvlo	%g6, 2
	bne	%g5, %g6, beq_else.22973
	ld	%g30, %g1, 12
	st	%g31, %g1, 236
	ld	%g29, %g30, 0
	addi	%g1, %g1, 240
	call	%g29
	subi	%g1, %g1, 240
	ld	%g31, %g1, 236
	b	beq_cont.22974
beq_else.22973:
beq_cont.22974:
beq_cont.22972:
beq_cont.22970:
	b	beq_cont.22966
beq_else.22965:
beq_cont.22966:
	b	ble_cont.22964
ble_else.22963:
ble_cont.22964:
	mvhi	%g4, 0
	mvlo	%g4, 0
	mvhi	%g5, 0
	mvlo	%g5, 0
	ld	%g3, %g1, 172
	ld	%g30, %g1, 8
	st	%g31, %g1, 236
	ld	%g29, %g30, 0
	addi	%g1, %g1, 240
	call	%g29
	subi	%g1, %g1, 240
	ld	%g31, %g1, 236
	mvhi	%g4, 0
	mvlo	%g4, 0
	mvhi	%g5, 0
	mvlo	%g5, 2
	ld	%g3, %g1, 88
	ld	%g6, %g3, 4
	blt	%g4, %g6, ble_else.22975
	return
ble_else.22975:
	ld	%g3, %g3, 4
	subi	%g3, %g3, 1
	st	%g4, %g1, 232
	blt	%g4, %g3, ble_else.22977
	b	ble_cont.22978
ble_else.22977:
	mvhi	%g3, 0
	mvlo	%g3, 1
	ld	%g6, %g1, 208
	ld	%g30, %g1, 8
	mov	%g4, %g3
	mov	%g3, %g6
	st	%g31, %g1, 236
	ld	%g29, %g30, 0
	addi	%g1, %g1, 240
	call	%g29
	subi	%g1, %g1, 240
	ld	%g31, %g1, 236
ble_cont.22978:
	mvhi	%g3, 0
	mvlo	%g3, 0
	ld	%g4, %g1, 232
	ld	%g5, %g1, 136
	ld	%g6, %g1, 172
	ld	%g7, %g1, 208
	ld	%g30, %g1, 4
	st	%g31, %g1, 236
	ld	%g29, %g30, 0
	addi	%g1, %g1, 240
	call	%g29
	subi	%g1, %g1, 240
	ld	%g31, %g1, 236
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g7, 0
	mvlo	%g7, 4
	ld	%g4, %g1, 172
	ld	%g5, %g1, 208
	ld	%g6, %g1, 136
	ld	%g30, %g1, 0
	ld	%g30, 0, %g29
	b	%g29
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 25
	setL %g4, l.16055
	fld	%f0, %g4, 0
	setL %g4, l.16057
	fld	%f1, %g4, 0
	setL %g4, l.16059
	fld	%f2, %g4, 0
	mov	%g4, %g2
	addi	%g2, %g2, 8
	setL %g5, cordic_sin.2737
	st	%g5, %g4, 0
	st	%g3, %g4, 4
	mov	%g5, %g2
	addi	%g2, %g2, 8
	setL %g6, cordic_cos.2739
	st	%g6, %g5, 0
	st	%g3, %g5, 4
	mov	%g6, %g2
	addi	%g2, %g2, 8
	setL %g7, cordic_atan.2741
	st	%g7, %g6, 0
	st	%g3, %g6, 4
	mov	%g3, %g2
	addi	%g2, %g2, 32
	setL %g7, sin.2743
	st	%g7, %g3, 0
	fst	%f2, %g3, 24
	fst	%f1, %g3, 16
	fst	%f0, %g3, 8
	st	%g4, %g3, 4
	mov	%g7, %g2
	addi	%g2, %g2, 32
	setL %g8, cos.2745
	st	%g8, %g7, 0
	fst	%f2, %g7, 24
	fst	%f1, %g7, 16
	fst	%f0, %g7, 8
	st	%g5, %g7, 4
	mvhi	%g8, 0
	mvlo	%g8, 1
	mvhi	%g9, 0
	mvlo	%g9, 0
	st	%g6, %g1, 0
	st	%g5, %g1, 4
	st	%g4, %g1, 8
	st	%g7, %g1, 12
	std	%f0, %g1, 16
	std	%f1, %g1, 24
	std	%f2, %g1, 32
	st	%g3, %g1, 40
	mov	%g4, %g9
	mov	%g3, %g8
	st	%g31, %g1, 44
	addi	%g1, %g1, 48
	call	min_caml_create_array
	subi	%g1, %g1, 48
	ld	%g31, %g1, 44
	mvhi	%g4, 0
	mvlo	%g4, 0
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 44
	mov	%g3, %g4
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_create_float_array
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
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
	st	%g3, %g10, 40
	st	%g3, %g10, 36
	st	%g3, %g10, 32
	st	%g3, %g10, 28
	st	%g9, %g10, 24
	st	%g3, %g10, 20
	st	%g3, %g10, 16
	st	%g8, %g10, 12
	st	%g7, %g10, 8
	st	%g6, %g10, 4
	st	%g5, %g10, 0
	mov	%g3, %g10
	mov	%g29, %g4
	mov	%g4, %g3
	mov	%g3, %g29
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_create_array
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 48
	mov	%g3, %g4
	st	%g31, %g1, 52
	addi	%g1, %g1, 56
	call	min_caml_create_float_array
	subi	%g1, %g1, 56
	ld	%g31, %g1, 52
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 52
	mov	%g3, %g4
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	min_caml_create_float_array
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 56
	mov	%g3, %g4
	st	%g31, %g1, 60
	addi	%g1, %g1, 64
	call	min_caml_create_float_array
	subi	%g1, %g1, 64
	ld	%g31, %g1, 60
	mvhi	%g4, 0
	mvlo	%g4, 1
	setL %g5, l.14905
	fld	%f0, %g5, 0
	st	%g3, %g1, 60
	mov	%g3, %g4
	st	%g31, %g1, 68
	addi	%g1, %g1, 72
	call	min_caml_create_float_array
	subi	%g1, %g1, 72
	ld	%g31, %g1, 68
	mvhi	%g4, 0
	mvlo	%g4, 50
	mvhi	%g5, 0
	mvlo	%g5, 1
	mvhi	%g6, 65535
	mvlo	%g6, -1
	st	%g3, %g1, 64
	st	%g4, %g1, 68
	mov	%g4, %g6
	mov	%g3, %g5
	st	%g31, %g1, 76
	addi	%g1, %g1, 80
	call	min_caml_create_array
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mov	%g4, %g3
	ld	%g3, %g1, 68
	st	%g31, %g1, 76
	addi	%g1, %g1, 80
	call	min_caml_create_array
	subi	%g1, %g1, 80
	ld	%g31, %g1, 76
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 1
	ld	%g6, %g3, 0
	st	%g3, %g1, 72
	st	%g4, %g1, 76
	mov	%g4, %g6
	mov	%g3, %g5
	st	%g31, %g1, 84
	addi	%g1, %g1, 88
	call	min_caml_create_array
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mov	%g4, %g3
	ld	%g3, %g1, 76
	st	%g31, %g1, 84
	addi	%g1, %g1, 88
	call	min_caml_create_array
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g4, 0
	mvlo	%g4, 1
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 80
	mov	%g3, %g4
	st	%g31, %g1, 84
	addi	%g1, %g1, 88
	call	min_caml_create_float_array
	subi	%g1, %g1, 88
	ld	%g31, %g1, 84
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 84
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 92
	addi	%g1, %g1, 96
	call	min_caml_create_array
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
	mvhi	%g4, 0
	mvlo	%g4, 1
	setL %g5, l.14806
	fld	%f0, %g5, 0
	st	%g3, %g1, 88
	mov	%g3, %g4
	st	%g31, %g1, 92
	addi	%g1, %g1, 96
	call	min_caml_create_float_array
	subi	%g1, %g1, 96
	ld	%g31, %g1, 92
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 92
	mov	%g3, %g4
	st	%g31, %g1, 100
	addi	%g1, %g1, 104
	call	min_caml_create_float_array
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 96
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 100
	addi	%g1, %g1, 104
	call	min_caml_create_array
	subi	%g1, %g1, 104
	ld	%g31, %g1, 100
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 100
	mov	%g3, %g4
	st	%g31, %g1, 108
	addi	%g1, %g1, 112
	call	min_caml_create_float_array
	subi	%g1, %g1, 112
	ld	%g31, %g1, 108
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 104
	mov	%g3, %g4
	st	%g31, %g1, 108
	addi	%g1, %g1, 112
	call	min_caml_create_float_array
	subi	%g1, %g1, 112
	ld	%g31, %g1, 108
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 108
	mov	%g3, %g4
	st	%g31, %g1, 116
	addi	%g1, %g1, 120
	call	min_caml_create_float_array
	subi	%g1, %g1, 120
	ld	%g31, %g1, 116
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 112
	mov	%g3, %g4
	st	%g31, %g1, 116
	addi	%g1, %g1, 120
	call	min_caml_create_float_array
	subi	%g1, %g1, 120
	ld	%g31, %g1, 116
	mvhi	%g4, 0
	mvlo	%g4, 2
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 116
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 124
	addi	%g1, %g1, 128
	call	min_caml_create_array
	subi	%g1, %g1, 128
	ld	%g31, %g1, 124
	mvhi	%g4, 0
	mvlo	%g4, 2
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 120
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 124
	addi	%g1, %g1, 128
	call	min_caml_create_array
	subi	%g1, %g1, 128
	ld	%g31, %g1, 124
	mvhi	%g4, 0
	mvlo	%g4, 1
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 124
	mov	%g3, %g4
	st	%g31, %g1, 132
	addi	%g1, %g1, 136
	call	min_caml_create_float_array
	subi	%g1, %g1, 136
	ld	%g31, %g1, 132
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 128
	mov	%g3, %g4
	st	%g31, %g1, 132
	addi	%g1, %g1, 136
	call	min_caml_create_float_array
	subi	%g1, %g1, 136
	ld	%g31, %g1, 132
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 132
	mov	%g3, %g4
	st	%g31, %g1, 140
	addi	%g1, %g1, 144
	call	min_caml_create_float_array
	subi	%g1, %g1, 144
	ld	%g31, %g1, 140
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 136
	mov	%g3, %g4
	st	%g31, %g1, 140
	addi	%g1, %g1, 144
	call	min_caml_create_float_array
	subi	%g1, %g1, 144
	ld	%g31, %g1, 140
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 140
	mov	%g3, %g4
	st	%g31, %g1, 148
	addi	%g1, %g1, 152
	call	min_caml_create_float_array
	subi	%g1, %g1, 152
	ld	%g31, %g1, 148
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 144
	mov	%g3, %g4
	st	%g31, %g1, 148
	addi	%g1, %g1, 152
	call	min_caml_create_float_array
	subi	%g1, %g1, 152
	ld	%g31, %g1, 148
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 148
	mov	%g3, %g4
	st	%g31, %g1, 156
	addi	%g1, %g1, 160
	call	min_caml_create_float_array
	subi	%g1, %g1, 160
	ld	%g31, %g1, 156
	mvhi	%g4, 0
	mvlo	%g4, 0
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 152
	mov	%g3, %g4
	st	%g31, %g1, 156
	addi	%g1, %g1, 160
	call	min_caml_create_float_array
	subi	%g1, %g1, 160
	ld	%g31, %g1, 156
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 0
	st	%g4, %g1, 156
	st	%g31, %g1, 164
	addi	%g1, %g1, 168
	call	min_caml_create_array
	subi	%g1, %g1, 168
	ld	%g31, %g1, 164
	mvhi	%g4, 0
	mvlo	%g4, 0
	mov	%g5, %g2
	addi	%g2, %g2, 8
	st	%g3, %g5, 4
	ld	%g3, %g1, 156
	st	%g3, %g5, 0
	mov	%g3, %g5
	mov	%g29, %g4
	mov	%g4, %g3
	mov	%g3, %g29
	st	%g31, %g1, 164
	addi	%g1, %g1, 168
	call	min_caml_create_array
	subi	%g1, %g1, 168
	ld	%g31, %g1, 164
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 5
	st	%g31, %g1, 164
	addi	%g1, %g1, 168
	call	min_caml_create_array
	subi	%g1, %g1, 168
	ld	%g31, %g1, 164
	mvhi	%g4, 0
	mvlo	%g4, 0
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 160
	mov	%g3, %g4
	st	%g31, %g1, 164
	addi	%g1, %g1, 168
	call	min_caml_create_float_array
	subi	%g1, %g1, 168
	ld	%g31, %g1, 164
	mvhi	%g4, 0
	mvlo	%g4, 3
	setL %g5, l.14007
	fld	%f0, %g5, 0
	st	%g3, %g1, 164
	mov	%g3, %g4
	st	%g31, %g1, 172
	addi	%g1, %g1, 176
	call	min_caml_create_float_array
	subi	%g1, %g1, 176
	ld	%g31, %g1, 172
	mvhi	%g4, 0
	mvlo	%g4, 60
	ld	%g5, %g1, 164
	st	%g3, %g1, 168
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 172
	addi	%g1, %g1, 176
	call	min_caml_create_array
	subi	%g1, %g1, 176
	ld	%g31, %g1, 172
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, 4
	ld	%g5, %g1, 168
	st	%g5, %g4, 0
	mvhi	%g6, 0
	mvlo	%g6, 0
	setL %g7, l.14007
	fld	%f0, %g7, 0
	st	%g4, %g1, 172
	st	%g3, %g1, 176
	mov	%g3, %g6
	st	%g31, %g1, 180
	addi	%g1, %g1, 184
	call	min_caml_create_float_array
	subi	%g1, %g1, 184
	ld	%g31, %g1, 180
	mov	%g4, %g3
	mvhi	%g3, 0
	mvlo	%g3, 0
	st	%g4, %g1, 180
	st	%g31, %g1, 188
	addi	%g1, %g1, 192
	call	min_caml_create_array
	subi	%g1, %g1, 192
	ld	%g31, %g1, 188
	mov	%g4, %g2
	addi	%g2, %g2, 8
	st	%g3, %g4, 4
	ld	%g3, %g1, 180
	st	%g3, %g4, 0
	mov	%g3, %g4
	mvhi	%g4, 0
	mvlo	%g4, 180
	mvhi	%g5, 0
	mvlo	%g5, 0
	setL %g6, l.14007
	fld	%f0, %g6, 0
	mov	%g6, %g2
	addi	%g2, %g2, 16
	fst	%f0, %g6, 8
	st	%g3, %g6, 4
	st	%g5, %g6, 0
	mov	%g3, %g6
	mov	%g29, %g4
	mov	%g4, %g3
	mov	%g3, %g29
	st	%g31, %g1, 188
	addi	%g1, %g1, 192
	call	min_caml_create_array
	subi	%g1, %g1, 192
	ld	%g31, %g1, 188
	mvhi	%g4, 0
	mvlo	%g4, 1
	mvhi	%g5, 0
	mvlo	%g5, 0
	st	%g3, %g1, 184
	mov	%g3, %g4
	mov	%g4, %g5
	st	%g31, %g1, 188
	addi	%g1, %g1, 192
	call	min_caml_create_array
	subi	%g1, %g1, 192
	ld	%g31, %g1, 188
	mov	%g4, %g2
	addi	%g2, %g2, 64
	setL %g5, read_screen_settings.2917
	st	%g5, %g4, 0
	ld	%g5, %g1, 56
	st	%g5, %g4, 60
	ld	%g6, %g1, 40
	st	%g6, %g4, 56
	ld	%g7, %g1, 148
	st	%g7, %g4, 52
	ld	%g8, %g1, 144
	st	%g8, %g4, 48
	ld	%g9, %g1, 140
	st	%g9, %g4, 44
	ld	%g10, %g1, 52
	st	%g10, %g4, 40
	fld	%f0, %g1, 32
	fst	%f0, %g4, 32
	fld	%f1, %g1, 24
	fst	%f1, %g4, 24
	fld	%f2, %g1, 16
	fst	%f2, %g4, 16
	ld	%g10, %g1, 12
	st	%g10, %g4, 12
	ld	%g11, %g1, 8
	st	%g11, %g4, 8
	ld	%g12, %g1, 4
	st	%g12, %g4, 4
	mov	%g13, %g2
	addi	%g2, %g2, 56
	setL %g14, read_light.2919
	st	%g14, %g13, 0
	st	%g6, %g13, 48
	fst	%f0, %g13, 40
	fst	%f1, %g13, 32
	fst	%f2, %g13, 24
	ld	%g14, %g1, 60
	st	%g14, %g13, 20
	st	%g10, %g13, 16
	st	%g11, %g13, 12
	st	%g12, %g13, 8
	ld	%g15, %g1, 64
	st	%g15, %g13, 4
	mov	%g16, %g2
	addi	%g2, %g2, 48
	setL %g17, rotate_quadratic_matrix.2921
	st	%g17, %g16, 0
	st	%g6, %g16, 40
	fst	%f0, %g16, 32
	fst	%f1, %g16, 24
	fst	%f2, %g16, 16
	st	%g10, %g16, 12
	st	%g11, %g16, 8
	st	%g12, %g16, 4
	mov	%g17, %g2
	addi	%g2, %g2, 16
	setL %g18, read_nth_object.2924
	st	%g18, %g17, 0
	st	%g16, %g17, 8
	ld	%g16, %g1, 48
	st	%g16, %g17, 4
	mov	%g18, %g2
	addi	%g2, %g2, 16
	setL %g19, read_object.2926
	st	%g19, %g18, 0
	st	%g17, %g18, 8
	ld	%g19, %g1, 44
	st	%g19, %g18, 4
	mov	%g20, %g2
	addi	%g2, %g2, 8
	setL %g21, read_and_network.2934
	st	%g21, %g20, 0
	ld	%g21, %g1, 72
	st	%g21, %g20, 4
	mov	%g22, %g2
	addi	%g2, %g2, 8
	setL %g23, solver_rect_surface.2938
	st	%g23, %g22, 0
	ld	%g23, %g1, 84
	st	%g23, %g22, 4
	mov	%g24, %g2
	addi	%g2, %g2, 8
	setL %g25, solver_surface.2953
	st	%g25, %g24, 0
	st	%g23, %g24, 4
	mov	%g25, %g2
	addi	%g2, %g2, 8
	setL %g26, solver_second.2972
	st	%g26, %g25, 0
	st	%g23, %g25, 4
	mov	%g26, %g2
	addi	%g2, %g2, 24
	setL %g27, solver.2978
	st	%g27, %g26, 0
	st	%g25, %g26, 16
	st	%g22, %g26, 12
	st	%g23, %g26, 8
	st	%g16, %g26, 4
	mov	%g27, %g2
	addi	%g2, %g2, 8
	setL %g28, solver_rect_fast.2982
	st	%g28, %g27, 0
	st	%g23, %g27, 4
	mov	%g28, %g2
	addi	%g2, %g2, 8
	setL %g29, solver_second_fast.2995
	st	%g29, %g28, 0
	st	%g23, %g28, 4
	mov	%g29, %g2
	addi	%g2, %g2, 8
	setL %g30, solver_second_fast2.3012
	st	%g30, %g29, 0
	st	%g23, %g29, 4
	mov	%g30, %g2
	addi	%g2, %g2, 24
	st	%g20, %g1, 188
	setL %g20, solver_fast2.3019
	st	%g20, %g30, 0
	st	%g29, %g30, 16
	st	%g27, %g30, 12
	st	%g23, %g30, 8
	st	%g16, %g30, 4
	mov	%g20, %g2
	addi	%g2, %g2, 8
	st	%g13, %g1, 192
	setL %g13, iter_setup_dirvec_constants.3031
	st	%g13, %g20, 0
	st	%g16, %g20, 4
	mov	%g13, %g2
	addi	%g2, %g2, 8
	st	%g17, %g1, 196
	setL %g17, setup_startp_constants.3036
	st	%g17, %g13, 0
	st	%g16, %g13, 4
	mov	%g17, %g2
	addi	%g2, %g2, 8
	st	%g18, %g1, 200
	setL %g18, check_all_inside.3061
	st	%g18, %g17, 0
	st	%g16, %g17, 4
	mov	%g18, %g2
	addi	%g2, %g2, 40
	st	%g4, %g1, 204
	setL %g4, shadow_check_and_group.3067
	st	%g4, %g18, 0
	ld	%g4, %g1, 168
	st	%g4, %g18, 36
	st	%g28, %g18, 32
	st	%g27, %g18, 28
	st	%g23, %g18, 24
	st	%g16, %g18, 20
	st	%g14, %g18, 16
	st	%g20, %g1, 208
	ld	%g20, %g1, 96
	st	%g20, %g18, 12
	ld	%g8, %g1, 176
	st	%g8, %g18, 8
	st	%g17, %g18, 4
	mov	%g7, %g2
	addi	%g2, %g2, 16
	setL %g9, shadow_check_one_or_group.3070
	st	%g9, %g7, 0
	st	%g18, %g7, 8
	st	%g21, %g7, 4
	mov	%g9, %g2
	addi	%g2, %g2, 48
	setL %g5, shadow_check_one_or_matrix.3073
	st	%g5, %g9, 0
	st	%g4, %g9, 40
	st	%g28, %g9, 36
	st	%g27, %g9, 32
	st	%g23, %g9, 28
	st	%g7, %g9, 24
	st	%g18, %g9, 20
	st	%g16, %g9, 16
	st	%g20, %g9, 12
	st	%g8, %g9, 8
	st	%g21, %g9, 4
	mov	%g5, %g2
	addi	%g2, %g2, 48
	setL %g7, solve_each_element.3076
	st	%g7, %g5, 0
	ld	%g7, %g1, 92
	st	%g7, %g5, 44
	ld	%g8, %g1, 132
	st	%g8, %g5, 40
	st	%g24, %g5, 36
	st	%g25, %g5, 32
	st	%g22, %g5, 28
	st	%g23, %g5, 24
	st	%g16, %g5, 20
	ld	%g18, %g1, 88
	st	%g18, %g5, 16
	st	%g20, %g5, 12
	ld	%g28, %g1, 100
	st	%g28, %g5, 8
	st	%g17, %g5, 4
	mov	%g4, %g2
	addi	%g2, %g2, 16
	setL %g15, solve_one_or_network.3080
	st	%g15, %g4, 0
	st	%g5, %g4, 8
	st	%g21, %g4, 4
	mov	%g15, %g2
	addi	%g2, %g2, 48
	setL %g14, trace_or_matrix.3084
	st	%g14, %g15, 0
	st	%g7, %g15, 44
	st	%g8, %g15, 40
	st	%g24, %g15, 36
	st	%g25, %g15, 32
	st	%g22, %g15, 28
	st	%g23, %g15, 24
	st	%g26, %g15, 20
	st	%g4, %g15, 16
	st	%g5, %g15, 12
	st	%g16, %g15, 8
	st	%g21, %g15, 4
	mov	%g4, %g2
	addi	%g2, %g2, 48
	setL %g5, solve_each_element_fast.3090
	st	%g5, %g4, 0
	st	%g7, %g4, 40
	ld	%g5, %g1, 136
	st	%g5, %g4, 36
	st	%g29, %g4, 32
	st	%g27, %g4, 28
	st	%g23, %g4, 24
	st	%g16, %g4, 20
	st	%g18, %g4, 16
	st	%g20, %g4, 12
	st	%g28, %g4, 8
	st	%g17, %g4, 4
	mov	%g14, %g2
	addi	%g2, %g2, 16
	setL %g17, solve_one_or_network_fast.3094
	st	%g17, %g14, 0
	st	%g4, %g14, 8
	st	%g21, %g14, 4
	mov	%g17, %g2
	addi	%g2, %g2, 40
	setL %g22, trace_or_matrix_fast.3098
	st	%g22, %g17, 0
	st	%g7, %g17, 36
	st	%g29, %g17, 32
	st	%g27, %g17, 28
	st	%g30, %g17, 24
	st	%g23, %g17, 20
	st	%g14, %g17, 16
	st	%g4, %g17, 12
	st	%g16, %g17, 8
	st	%g21, %g17, 4
	mov	%g22, %g2
	addi	%g2, %g2, 40
	setL %g24, judge_intersection_fast.3102
	st	%g24, %g22, 0
	st	%g17, %g22, 32
	st	%g7, %g22, 28
	st	%g30, %g22, 24
	st	%g23, %g22, 20
	st	%g14, %g22, 16
	st	%g4, %g22, 12
	ld	%g4, %g1, 80
	st	%g4, %g22, 8
	st	%g21, %g22, 4
	mov	%g14, %g2
	addi	%g2, %g2, 16
	setL %g21, get_nvector_second.3108
	st	%g21, %g14, 0
	ld	%g21, %g1, 104
	st	%g21, %g14, 8
	st	%g20, %g14, 4
	mov	%g23, %g2
	addi	%g2, %g2, 16
	setL %g24, get_nvector.3110
	st	%g24, %g23, 0
	st	%g21, %g23, 12
	st	%g18, %g23, 8
	st	%g14, %g23, 4
	mov	%g24, %g2
	addi	%g2, %g2, 56
	setL %g25, utexture.3113
	st	%g25, %g24, 0
	ld	%g25, %g1, 108
	st	%g25, %g24, 52
	st	%g6, %g24, 48
	fst	%f0, %g24, 40
	fst	%f1, %g24, 32
	fst	%f2, %g24, 24
	st	%g10, %g24, 16
	st	%g11, %g24, 12
	st	%g12, %g24, 8
	ld	%g26, %g1, 0
	st	%g26, %g24, 4
	mov	%g27, %g2
	addi	%g2, %g2, 48
	setL %g29, trace_reflections.3120
	st	%g29, %g27, 0
	st	%g17, %g27, 40
	st	%g7, %g27, 36
	st	%g25, %g27, 32
	st	%g9, %g27, 28
	ld	%g29, %g1, 116
	st	%g29, %g27, 24
	ld	%g30, %g1, 184
	st	%g30, %g27, 20
	st	%g4, %g27, 16
	st	%g21, %g27, 12
	st	%g18, %g27, 8
	st	%g28, %g27, 4
	mov	%g30, %g2
	addi	%g2, %g2, 88
	setL %g26, trace_ray.3125
	st	%g26, %g30, 0
	st	%g24, %g30, 84
	st	%g27, %g30, 80
	st	%g15, %g30, 76
	st	%g7, %g30, 72
	st	%g25, %g30, 68
	st	%g5, %g30, 64
	st	%g8, %g30, 60
	st	%g9, %g30, 56
	st	%g13, %g30, 52
	st	%g29, %g30, 48
	st	%g4, %g30, 44
	st	%g16, %g30, 40
	st	%g21, %g30, 36
	st	%g3, %g30, 32
	st	%g19, %g30, 28
	ld	%g15, %g1, 60
	st	%g15, %g30, 24
	st	%g18, %g30, 20
	st	%g20, %g30, 16
	st	%g28, %g30, 12
	st	%g14, %g30, 8
	ld	%g26, %g1, 64
	st	%g26, %g30, 4
	mov	%g26, %g2
	addi	%g2, %g2, 64
	setL %g27, trace_diffuse_ray.3131
	st	%g27, %g26, 0
	st	%g24, %g26, 56
	st	%g17, %g26, 52
	st	%g7, %g26, 48
	st	%g25, %g26, 44
	st	%g9, %g26, 40
	st	%g4, %g26, 36
	st	%g16, %g26, 32
	st	%g21, %g26, 28
	st	%g15, %g26, 24
	st	%g18, %g26, 20
	st	%g20, %g26, 16
	st	%g28, %g26, 12
	st	%g14, %g26, 8
	ld	%g7, %g1, 112
	st	%g7, %g26, 4
	mov	%g14, %g2
	addi	%g2, %g2, 56
	setL %g17, iter_trace_diffuse_rays.3134
	st	%g17, %g14, 0
	st	%g24, %g14, 52
	st	%g26, %g14, 48
	st	%g25, %g14, 44
	st	%g9, %g14, 40
	st	%g4, %g14, 36
	st	%g16, %g14, 32
	st	%g21, %g14, 28
	st	%g15, %g14, 24
	st	%g22, %g14, 20
	st	%g20, %g14, 16
	st	%g28, %g14, 12
	st	%g23, %g14, 8
	st	%g7, %g14, 4
	mov	%g9, %g2
	addi	%g2, %g2, 24
	setL %g17, trace_diffuse_ray_80percent.3143
	st	%g17, %g9, 0
	st	%g5, %g9, 20
	st	%g13, %g9, 16
	st	%g19, %g9, 12
	st	%g14, %g9, 8
	ld	%g17, %g1, 160
	st	%g17, %g9, 4
	mov	%g18, %g2
	addi	%g2, %g2, 40
	setL %g20, calc_diffuse_using_1point.3147
	st	%g20, %g18, 0
	st	%g26, %g18, 32
	st	%g5, %g18, 28
	st	%g13, %g18, 24
	st	%g29, %g18, 20
	st	%g19, %g18, 16
	st	%g14, %g18, 12
	st	%g17, %g18, 8
	st	%g7, %g18, 4
	mov	%g20, %g2
	addi	%g2, %g2, 16
	setL %g21, calc_diffuse_using_5points.3150
	st	%g21, %g20, 0
	st	%g29, %g20, 8
	st	%g7, %g20, 4
	mov	%g21, %g2
	addi	%g2, %g2, 24
	setL %g22, do_without_neighbors.3156
	st	%g22, %g21, 0
	st	%g9, %g21, 16
	st	%g29, %g21, 12
	st	%g7, %g21, 8
	st	%g18, %g21, 4
	mov	%g9, %g2
	addi	%g2, %g2, 16
	setL %g22, try_exploit_neighbors.3172
	st	%g22, %g9, 0
	st	%g21, %g9, 12
	st	%g20, %g9, 8
	st	%g18, %g9, 4
	mov	%g22, %g2
	addi	%g2, %g2, 8
	setL %g23, write_rgb.3183
	st	%g23, %g22, 0
	st	%g29, %g22, 4
	mov	%g23, %g2
	addi	%g2, %g2, 32
	setL %g24, pretrace_diffuse_rays.3185
	st	%g24, %g23, 0
	st	%g26, %g23, 28
	st	%g5, %g23, 24
	st	%g13, %g23, 20
	st	%g19, %g23, 16
	st	%g14, %g23, 12
	st	%g17, %g23, 8
	st	%g7, %g23, 4
	mov	%g24, %g2
	addi	%g2, %g2, 72
	setL %g25, pretrace_pixels.3188
	st	%g25, %g24, 0
	ld	%g25, %g1, 56
	st	%g25, %g24, 64
	st	%g30, %g24, 60
	st	%g26, %g24, 56
	st	%g5, %g24, 52
	st	%g8, %g24, 48
	st	%g13, %g24, 44
	ld	%g5, %g1, 140
	st	%g5, %g24, 40
	ld	%g5, %g1, 128
	st	%g5, %g24, 36
	st	%g29, %g24, 32
	ld	%g8, %g1, 152
	st	%g8, %g24, 28
	st	%g23, %g24, 24
	st	%g19, %g24, 20
	st	%g14, %g24, 16
	ld	%g8, %g1, 124
	st	%g8, %g24, 12
	st	%g17, %g24, 8
	st	%g7, %g24, 4
	mov	%g7, %g2
	addi	%g2, %g2, 32
	setL %g13, pretrace_line.3195
	st	%g13, %g7, 0
	ld	%g13, %g1, 148
	st	%g13, %g7, 24
	ld	%g13, %g1, 144
	st	%g13, %g7, 20
	st	%g5, %g7, 16
	st	%g24, %g7, 12
	ld	%g13, %g1, 120
	st	%g13, %g7, 8
	st	%g8, %g7, 4
	mov	%g14, %g2
	addi	%g2, %g2, 32
	setL %g23, scan_pixel.3199
	st	%g23, %g14, 0
	st	%g22, %g14, 28
	st	%g9, %g14, 24
	st	%g29, %g14, 20
	st	%g13, %g14, 16
	st	%g21, %g14, 12
	st	%g20, %g14, 8
	st	%g18, %g14, 4
	mov	%g18, %g2
	addi	%g2, %g2, 32
	setL %g20, scan_line.3205
	st	%g20, %g18, 0
	st	%g22, %g18, 28
	st	%g9, %g18, 24
	st	%g14, %g18, 20
	st	%g29, %g18, 16
	st	%g7, %g18, 12
	st	%g13, %g18, 8
	st	%g21, %g18, 4
	mov	%g9, %g2
	addi	%g2, %g2, 56
	setL %g20, calc_dirvec.3225
	st	%g20, %g9, 0
	st	%g6, %g9, 48
	fst	%f0, %g9, 40
	fst	%f1, %g9, 32
	fst	%f2, %g9, 24
	st	%g17, %g9, 20
	st	%g10, %g9, 16
	st	%g11, %g9, 12
	st	%g12, %g9, 8
	ld	%g6, %g1, 0
	st	%g6, %g9, 4
	mov	%g6, %g2
	addi	%g2, %g2, 8
	setL %g10, calc_dirvecs.3233
	st	%g10, %g6, 0
	st	%g9, %g6, 4
	mov	%g9, %g2
	addi	%g2, %g2, 8
	setL %g10, calc_dirvec_rows.3238
	st	%g10, %g9, 0
	st	%g6, %g9, 4
	mov	%g6, %g2
	addi	%g2, %g2, 8
	setL %g10, create_dirvec_elements.3244
	st	%g10, %g6, 0
	st	%g19, %g6, 4
	mov	%g10, %g2
	addi	%g2, %g2, 16
	setL %g11, create_dirvecs.3247
	st	%g11, %g10, 0
	st	%g19, %g10, 12
	st	%g17, %g10, 8
	st	%g6, %g10, 4
	mov	%g6, %g2
	addi	%g2, %g2, 16
	setL %g11, init_dirvec_constants.3249
	st	%g11, %g6, 0
	st	%g16, %g6, 12
	st	%g19, %g6, 8
	ld	%g11, %g1, 208
	st	%g11, %g6, 4
	mov	%g12, %g2
	addi	%g2, %g2, 24
	setL %g20, init_vecset_constants.3252
	st	%g20, %g12, 0
	st	%g16, %g12, 20
	st	%g19, %g12, 16
	st	%g11, %g12, 12
	st	%g6, %g12, 8
	st	%g17, %g12, 4
	mov	%g20, %g2
	addi	%g2, %g2, 32
	setL %g21, setup_rect_reflection.3263
	st	%g21, %g20, 0
	ld	%g21, %g1, 184
	st	%g21, %g20, 24
	st	%g16, %g20, 20
	st	%g3, %g20, 16
	st	%g19, %g20, 12
	st	%g15, %g20, 8
	st	%g11, %g20, 4
	mov	%g22, %g2
	addi	%g2, %g2, 32
	setL %g23, setup_surface_reflection.3266
	st	%g23, %g22, 0
	st	%g21, %g22, 24
	st	%g16, %g22, 20
	st	%g3, %g22, 16
	st	%g19, %g22, 12
	st	%g15, %g22, 8
	st	%g11, %g22, 4
	mov	%g30, %g2
	addi	%g2, %g2, 104
	setL %g3, rt.3271
	st	%g3, %g30, 0
	ld	%g3, %g1, 168
	st	%g3, %g30, 100
	st	%g22, %g30, 96
	st	%g20, %g30, 92
	st	%g14, %g30, 88
	st	%g5, %g30, 84
	st	%g18, %g30, 80
	ld	%g3, %g1, 204
	st	%g3, %g30, 76
	ld	%g3, %g1, 200
	st	%g3, %g30, 72
	ld	%g3, %g1, 196
	st	%g3, %g30, 68
	ld	%g3, %g1, 192
	st	%g3, %g30, 64
	ld	%g3, %g1, 188
	st	%g3, %g30, 60
	st	%g7, %g30, 56
	st	%g4, %g30, 52
	st	%g16, %g30, 48
	st	%g19, %g30, 44
	ld	%g3, %g1, 172
	st	%g3, %g30, 40
	st	%g15, %g30, 36
	st	%g11, %g30, 32
	st	%g12, %g30, 28
	st	%g6, %g30, 24
	st	%g13, %g30, 20
	st	%g8, %g30, 16
	st	%g17, %g30, 12
	st	%g10, %g30, 8
	st	%g9, %g30, 4
	mvhi	%g3, 0
	mvlo	%g3, 128
	mvhi	%g4, 0
	mvlo	%g4, 128
	st	%g31, %g1, 212
	ld	%g29, %g30, 0
	addi	%g1, %g1, 216
	call	%g29
	subi	%g1, %g1, 216
	ld	%g31, %g1, 212
	mvhi	%g0, 0
	mvlo	%g0, 0
	halt
