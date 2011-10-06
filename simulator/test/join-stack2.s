.init_heap_size	0
f.9:
	mvhi	%g3, 0
	mvlo	%g3, 123
	return
g.11:
	mvhi	%g3, 0
	mvlo	%g3, 456
	return
min_caml_start:
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	f.9
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g3, %g1, 0
	jlt	%g4, %g3, jle_else.23
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	g.11
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	add	%g3, %g3, %g4
	b	jle_cont.24
jle_else.23:
jle_cont.24:
	ld	%g4, %g1, 0
	add	%g3, %g3, %g4
	output	%g3
	halt
