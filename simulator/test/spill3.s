.init_heap_size	0
	jmp	min_caml_start
f.56:
	addi	%g4, %g3, 1
	addi	%g5, %g4, 1
	addi	%g6, %g5, 1
	addi	%g7, %g6, 1
	addi	%g8, %g7, 1
	addi	%g9, %g8, 1
	addi	%g10, %g9, 1
	addi	%g11, %g10, 1
	addi	%g12, %g11, 1
	addi	%g13, %g12, 1
	addi	%g14, %g13, 1
	addi	%g15, %g14, 1
	addi	%g16, %g15, 1
	addi	%g17, %g16, 1
	addi	%g18, %g17, 1
	addi	%g19, %g18, 1
	addi	%g20, %g19, 1
	addi	%g21, %g20, 1
	add	%g22, %g21, %g4
	add	%g23, %g22, %g5
	add	%g24, %g23, %g6
	add	%g25, %g24, %g7
	add	%g26, %g25, %g8
	add	%g27, %g26, %g9
	add	%g28, %g27, %g10
	add	%g29, %g28, %g11
	add	%g30, %g29, %g12
	st	%g30, %g1, 0
	add	%g30, %g30, %g13
	st	%g30, %g1, 4
	add	%g30, %g30, %g14
	st	%g30, %g1, 8
	add	%g30, %g30, %g15
	st	%g30, %g1, 12
	add	%g30, %g30, %g16
	st	%g30, %g1, 16
	add	%g30, %g30, %g17
	st	%g30, %g1, 20
	add	%g30, %g30, %g18
	st	%g30, %g1, 24
	add	%g30, %g30, %g19
	st	%g30, %g1, 28
	add	%g30, %g30, %g20
	st	%g3, %g1, 32
	add	%g3, %g30, %g3
	add	%g4, %g4, %g5
	add	%g4, %g4, %g6
	add	%g4, %g4, %g7
	add	%g4, %g4, %g8
	add	%g4, %g4, %g9
	add	%g4, %g4, %g10
	add	%g4, %g4, %g11
	add	%g4, %g4, %g12
	add	%g4, %g4, %g13
	add	%g4, %g4, %g14
	add	%g4, %g4, %g15
	add	%g4, %g4, %g16
	add	%g4, %g4, %g17
	add	%g4, %g4, %g18
	add	%g4, %g4, %g19
	add	%g4, %g4, %g20
	add	%g4, %g4, %g21
	add	%g4, %g4, %g22
	add	%g4, %g4, %g23
	add	%g4, %g4, %g24
	add	%g4, %g4, %g25
	add	%g4, %g4, %g26
	add	%g4, %g4, %g27
	add	%g4, %g4, %g28
	add	%g4, %g4, %g29
	ld	%g5, %g1, 0
	add	%g4, %g4, %g5
	ld	%g5, %g1, 4
	add	%g4, %g4, %g5
	ld	%g5, %g1, 8
	add	%g4, %g4, %g5
	ld	%g5, %g1, 12
	add	%g4, %g4, %g5
	ld	%g5, %g1, 16
	add	%g4, %g4, %g5
	ld	%g5, %g1, 20
	add	%g4, %g4, %g5
	ld	%g5, %g1, 24
	add	%g4, %g4, %g5
	ld	%g5, %g1, 28
	add	%g4, %g4, %g5
	add	%g4, %g4, %g30
	add	%g3, %g4, %g3
	ld	%g4, %g1, 32
	add	%g3, %g3, %g4
	return
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	f.56
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	halt
