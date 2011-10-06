	jmp	min_caml_start
fib.10:
	mvlo	%g4, 1
	jlt	%g4, %g3, ble_else.24
	return
ble_else.24:
	subi	%g4, %g3, 1
	st	%g3, %g1, 0
	mov	%g3, %g4
	addi	%g1, %g1, 8
	call	fib.10 		
	subi	%g1, %g1, 8
	ld	%g4, %g1, 0
	subi	%g4, %g4, 2
	st	%g3, %g1, 4
	mov	%g3, %g4
	addi	%g1, %g1, 16
	call	fib.10
	subi	%g1, %g1, 16
	ld	%g4, %g1, 4
	add	%g3, %g4, %g3
	return
min_caml_start:
	mvlo	%g3, 7
	addi	%g1, %g1, 8
	call	fib.10
	subi	%g1, %g1, 8
	output	%g3
	halt
