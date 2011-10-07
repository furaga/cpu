.init_heap_size	0
odd.21:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jlt	%g4, %g3, jle_else.36
	mvhi	%g4, 0
	mvlo	%g4, 0
	jlt	%g3, %g4, jle_else.37
	mvhi	%g3, 0
	mvlo	%g3, 456
	return
jle_else.37:
	addi	%g3, %g3, 1
	jmp	even.17
jle_else.36:
	subi	%g3, %g3, 1
	jmp	even.17
even.17:
	mvhi	%g4, 0
	mvlo	%g4, 0
	jlt	%g4, %g3, jle_else.38
	mvhi	%g4, 0
	mvlo	%g4, 0
	jlt	%g3, %g4, jle_else.39
	mvhi	%g3, 0
	mvlo	%g3, 123
	return
jle_else.39:
	addi	%g3, %g3, 1
	jmp	odd.21
jle_else.38:
	subi	%g3, %g3, 1
	jmp	odd.21
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 789
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	even.17
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	halt
