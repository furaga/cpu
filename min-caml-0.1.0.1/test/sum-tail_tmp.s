.section	".rodata"
.align	8
.section	".text"
sum.8:
	cmp	%i3, 0
	bg	ble_else.19
	nop
	retl
	nop
ble_else.19:
	add	%i2, %i3, %i2
	sub	%i3, 1, %i3
	b	sum.8
	nop
.global	min_caml_start
min_caml_start:
	save	%sp, -112, %sp
	set	0, %i2
	set	10000, %i3
	st	%o7, [%i0 + 4]
	call	sum.8
	add	%i0, 8, %i0	! delay slot
	sub	%i0, 8, %i0
	ld	[%i0 + 4], %o7
	st	%o7, [%i0 + 4]
	call	min_caml_print_int
	add	%i0, 8, %i0	! delay slot
	sub	%i0, 8, %i0
	ld	[%i0 + 4], %o7
	ret
	restore
