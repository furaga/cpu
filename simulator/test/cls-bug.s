.init_heap_size	0
	jmp	min_caml_start
f.6:
	addi	%g3, %g3, 123
	return
g.8:
	ld	%g3, %g29, -4
	return
min_caml_start:
	mov	%g3, %g2
	addi	%g2, %g2, 8
	setL %g4, f.6
	st	%g4, %g3, 0
	mov	%g29, %g2
	addi	%g2, %g2, 8
	setL %g4, g.8
	st	%g4, %g29, 0
	st	%g3, %g29, -4
	mvhi	%g3, 0
	mvlo	%g3, 456
	st	%g31, %g1, 4
	ld	%g28, %g29, 0
	subi	%g1, %g1, 8
	callR	%g28
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g29, %g3
	mvhi	%g3, 0
	mvlo	%g3, 789
	st	%g31, %g1, 4
	ld	%g28, %g29, 0
	subi	%g1, %g1, 8
	callR	%g28
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	halt
