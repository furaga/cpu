.init_heap_size	32
l.5:	! 3.140000
	.long	0x4048f5c2
f.2:
	jmp	min_caml_print_float
min_caml_start:
	setL %g3, l.5
	fld	%f0, %g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	f.2
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	halt
