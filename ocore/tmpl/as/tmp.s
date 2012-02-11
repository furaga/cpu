.init_heap_size	128
FLOAT_ZERO:		! 0.0
	.long 0x0
FLOAT_ONE:		! 1.0
	.long 0x3f800000
FLOAT_MONE:		! -1.0
	.long 0xbf800000
FLOAT_MAGICI:	! 8388608
	.long 0x40000000

	setL	%g3, FLOAT_ONE
	fld		%f0, %g3, %g0
	fld		%f1, %g3, %g0
	fadd	%f2, %f0, %f1
	fmul	%f0, %f2, %f2
	fmul	%f0, %f2, %f2
	halt
