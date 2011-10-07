.init_heap_size	96
l.39:	! 48.300300
	.long	0x42413381
l.37:	! 4.500000
	.long	0x40900000
l.35:	! -12.300000
	.long	0xc0c4ccc4
min_caml_start:
	setL %g3, l.35
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_abs_float
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_sqrt
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_cos
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_sin
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	setL %g3, l.37
	fld	%f1, %g3, 0
	fadd	%f0, %f0, %f1
	setL %g3, l.39
	fld	%f1, %g3, 0
	fsub	%f0, %f0, %f1
	mvhi	%g3, 15
	mvlo	%g3, 16960
	std	%f0, %g1, 0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_float_of_int
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	fld	%f1, %g1, 0
	fmul	%f0, %f1, %f0
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	min_caml_int_of_float
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	output	%g3
	halt
