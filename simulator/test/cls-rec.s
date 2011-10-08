.init_heap_size	0
	jmp	min_caml_start
f.8:
	ld	%g4, %g29, -4
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.21
	mvhi	%g3, 0
	mvlo	%g3, 0
	return
jeq_else.21:
	subi	%g3, %g3, 1
	st	%g4, %g1, 0
	st	%g31, %g1, 4
	ld	%g28, %g29, 0
	subi	%g1, %g1, 8
	callR	%g28
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	add	%g3, %g4, %g3
	return
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 10
	mov	%g29, %g2
	addi	%g2, %g2, 8
	setL %g4, f.8
	st	%g4, %g29, 0
	st	%g3, %g29, -4
	mvhi	%g3, 0
	mvlo	%g3, 123
	st	%g31, %g1, 4
	ld	%g28, %g29, 0
	subi	%g1, %g1, 8
	callR	%g28
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	halt
