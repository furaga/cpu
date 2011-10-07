.init_heap_size	0
f.6:
	addi	%g3, %g3, 123
	return
g.8:
	ld	%g3, %g30, 4
	return
min_caml_start:
	mov	%g3, %g2
	addi	%g2, %g2, 8
	setL %g4, f.6
	st	%g4, %g3, 0
	mov	%g30, %g2
	addi	%g2, %g2, 8
	setL %g4, g.8
	st	%g4, %g30, 0
	st	%g3, %g30, 4
	mvhi	%g3, 0
	mvlo	%g3, 456
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	subi	%g1, %g1, 8
	call	%g29
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g30, %g3
	mvhi	%g3, 0
	mvlo	%g3, 789
	st	%g31, %g1, 4
	ld	%g29, %g30, 0
	subi	%g1, %g1, 8
	call	%g29
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	halt
