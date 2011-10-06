	jmp	min_caml_start
fib.10:
	mov	%g3,%g4
	mov	%g4,%g5
	add %g5,%g3,%g4
	subi %g7,%g7,1
	jlt	%g0, %g7, fib.10
	return
min_caml_start:
	mvlo	%g7, 12
	addi	%g7,%g7,1
	mvlo	%g5, 1
	addi	%g1, %g1, 4
	call	fib.10
	subi	%g1, %g1, 4
	output	%g3
	halt
