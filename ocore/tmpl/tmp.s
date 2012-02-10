.init_heap_size	224
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
l.667:	! 16826400.000000
	.long	0x4b806010


	setL	%g3, l.667
	fldi	%f0, %g3, 0
	setL	%g3, FLOAT_MAGICF
	fldi	%f1, %g3, 0
	fadd	%f2, %f0, %f1
	halt
