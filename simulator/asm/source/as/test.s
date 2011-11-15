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

loop:
	b %g3

min_caml_start:
	mvhi %g5, 48
	srli %g5, %g5, 16
	output %g5
	mvlo %g6, 54
	addi %g2, %g2, 32
	st %g5, %g2, 4
	st %g6, %g2, -4
	ld %g3, %g2, 4
	ld %g4, %g2, -4
	output %g3
	output %g4
	halt
