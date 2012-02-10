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

	setL %g3, FLOAT_ONE
	fld %f4, %g3, %g0
	fmov %f5, %f4
	fsti %f4, %g1, 8
	fldi %f6, %g1, 8
	fadd %f3, %f3, %f3
	addi %g4, %g0, 48
	fneg %f6, %f6
	fjlt %f5, %f6, llll
	output %g4
llll:
	halt

