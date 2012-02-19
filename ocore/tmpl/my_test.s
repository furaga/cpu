.init_heap_size	384
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
l.1027:	! 12.000000
	.long	0x41400000
l.1022:	! 11.000000
	.long	0x41300000
l.1017:	! 10.000000
	.long	0x41200000
l.1012:	! 9.000000
	.long	0x41100000
l.1007:	! 8.000000
	.long	0x41000000
l.1002:	! 7.000000
	.long	0x40e00000

	sti 	%g2, %g31, 44
	call	func
	ldi		%g2, %g31, 44
	output %g2
	halt

func:
	input %g3
	output %g3
	return
