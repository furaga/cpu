.init_heap_size	0
f.10:
	mvhi	%g3, 0
	mvlo	%g3, 123
	return
g.12:
	mvhi	%g3, 0
	mvlo	%g3, 456
	return
h.14:
	mvhi	%g3, 0
	mvlo	%g3, 789
	return
min_caml_start:
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	f.10
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 0
	mvlo	%g4, 0
	st	%g3, %g1, 0
	jlt	%g4, %g3, jle_else.27
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	g.12
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	b	jle_cont.28
jle_else.27:
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	h.14
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
jle_cont.28:
	ld	%g4, %g1, 0
	add	%g3, %g3, %g4
	output	%g3
	halt
