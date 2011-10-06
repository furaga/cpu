.init_heap_size	224
l.79:	! 6.000000
	.long	0x40c00000
l.77:	! 5.000000
	.long	0x40a00000
l.75:	! 4.000000
	.long	0x40800000
l.69:	! 3.000000
	.long	0x40400000
l.67:	! 2.000000
	.long	0x40000000
l.65:	! 1.000000
	.long	0x3f800000
l.63:	! 1000000.000000
	.long	0x49742400
getx.23:
	fld	%f0, %g3, 0
	return
gety.25:
	fld	%f0, %g3, 8
	return
getz.27:
	fld	%f0, %g3, 16
	return
inprod.29:
	st	%g3, %g1, 0
	st	%g4, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	getx.23
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g3, %g1, 4
	std	%f0, %g1, 8
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	getx.23
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	fld	%f1, %g1, 8
	fmul	%f0, %f1, %f0
	ld	%g3, %g1, 0
	std	%f0, %g1, 16
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	gety.25
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	ld	%g3, %g1, 4
	std	%f0, %g1, 24
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	gety.25
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	fld	%f1, %g1, 24
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 16
	fadd	%f0, %f1, %f0
	ld	%g3, %g1, 0
	std	%f0, %g1, 32
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	getz.27
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	ld	%g3, %g1, 4
	std	%f0, %g1, 40
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	getz.27
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	fld	%f1, %g1, 40
	fmul	%f0, %f1, %f0
	fld	%f1, %g1, 32
	fadd	%f0, %f1, %f0
	return
min_caml_start:
	setL %g3, l.63
	fld	%f0, %g3, 0
	setL %g3, l.65
	fld	%f1, %g3, 0
	setL %g3, l.67
	fld	%f2, %g3, 0
	setL %g3, l.69
	fld	%f3, %g3, 0
	mov	%g3, %g2
	addi	%g2, %g2, 24
	fst	%f3, %g3, 16
	fst	%f2, %g3, 8
	fst	%f1, %g3, 0
	setL %g4, l.75
	fld	%f1, %g4, 0
	setL %g4, l.77
	fld	%f2, %g4, 0
	setL %g4, l.79
	fld	%f3, %g4, 0
	mov	%g4, %g2
	addi	%g2, %g2, 24
	fst	%f3, %g4, 16
	fst	%f2, %g4, 8
	fst	%f1, %g4, 0
	std	%f0, %g1, 0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	inprod.29
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f1, %g1, 0
	fmul	%f0, %f1, %f0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_truncate
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	output	%g3
	halt
