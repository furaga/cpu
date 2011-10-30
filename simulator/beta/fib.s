.init_heap_size	192
FLOAT_ZERO:		! 0.0
	.long 0x0
FLOAT_ONE:		! 1.0
	.long 0x3f800000
FLOAT_MONE:		! -1.0
	.long 0xbf800000
FLOAT_MAGICI:	! 8388608
	.long 0x800000
FLOAT_MAGICF:	! 8388608.0
	.long 0x4b000000
FLOAT_MAGICFHX:	! 1258291200
	.long 0x4b000000
	jmp	min_caml_start

div_binary_search.335:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.729
	mov	%g3, %g5
	return
jle_else.729:
	jlt	%g8, %g3, jle_else.730
	jne	%g8, %g3, jeq_else.731
	mov	%g3, %g7
	return
jeq_else.731:
	mov	%g6, %g7
	jmp	div_binary_search.335
jle_else.730:
	mov	%g5, %g7
	jmp	div_binary_search.335
print_int.340:
	jlt	%g3, %g0, jge_else.732
	mvhi	%g4, 1525
	mvlo	%g4, 57600
	addi	%g5, %g0, 0
	addi	%g6, %g0, 3
	st	%g3, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	div_binary_search.335
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 1525
	mvlo	%g4, 57600
	mul	%g4, %g3, %g4
	ld	%g5, %g1, 0
	sub	%g4, %g5, %g4
	st	%g4, %g1, 4
	jlt	%g0, %g3, jle_else.733
	addi	%g3, %g0, 0
	jmp	jle_cont.734
jle_else.733:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.734:
	mvhi	%g4, 152
	mvlo	%g4, 38528
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ld	%g7, %g1, 4
	st	%g3, %g1, 8
	mov	%g3, %g7
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	mvhi	%g4, 152
	mvlo	%g4, 38528
	mul	%g4, %g3, %g4
	ld	%g5, %g1, 4
	sub	%g4, %g5, %g4
	st	%g4, %g1, 12
	jlt	%g0, %g3, jle_else.735
	ld	%g5, %g1, 8
	jne	%g5, %g0, jeq_else.737
	addi	%g3, %g0, 0
	jmp	jeq_cont.738
jeq_else.737:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.738:
	jmp	jle_cont.736
jle_else.735:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.736:
	mvhi	%g4, 15
	mvlo	%g4, 16960
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ld	%g7, %g1, 12
	st	%g3, %g1, 16
	mov	%g3, %g7
	st	%g31, %g1, 20
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
	ld	%g31, %g1, 20
	mvhi	%g4, 15
	mvlo	%g4, 16960
	mul	%g4, %g3, %g4
	ld	%g5, %g1, 12
	sub	%g4, %g5, %g4
	st	%g4, %g1, 20
	jlt	%g0, %g3, jle_else.739
	ld	%g5, %g1, 16
	jne	%g5, %g0, jeq_else.741
	addi	%g3, %g0, 0
	jmp	jeq_cont.742
jeq_else.741:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.742:
	jmp	jle_cont.740
jle_else.739:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.740:
	mvhi	%g4, 1
	mvlo	%g4, 34464
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ld	%g7, %g1, 20
	st	%g3, %g1, 24
	mov	%g3, %g7
	st	%g31, %g1, 28
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
	ld	%g31, %g1, 28
	mvhi	%g4, 1
	mvlo	%g4, 34464
	mul	%g4, %g3, %g4
	ld	%g5, %g1, 20
	sub	%g4, %g5, %g4
	st	%g4, %g1, 28
	jlt	%g0, %g3, jle_else.743
	ld	%g5, %g1, 24
	jne	%g5, %g0, jeq_else.745
	addi	%g3, %g0, 0
	jmp	jeq_cont.746
jeq_else.745:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.746:
	jmp	jle_cont.744
jle_else.743:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.744:
	addi	%g4, %g0, 10000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ld	%g7, %g1, 28
	st	%g3, %g1, 32
	mov	%g3, %g7
	st	%g31, %g1, 36
	subi	%g1, %g1, 40
	call	div_binary_search.335
	addi	%g1, %g1, 40
	ld	%g31, %g1, 36
	addi	%g4, %g0, 10000
	mul	%g4, %g3, %g4
	ld	%g5, %g1, 28
	sub	%g4, %g5, %g4
	st	%g4, %g1, 36
	jlt	%g0, %g3, jle_else.747
	ld	%g5, %g1, 32
	jne	%g5, %g0, jeq_else.749
	addi	%g3, %g0, 0
	jmp	jeq_cont.750
jeq_else.749:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.750:
	jmp	jle_cont.748
jle_else.747:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.748:
	addi	%g4, %g0, 1000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ld	%g7, %g1, 36
	st	%g3, %g1, 40
	mov	%g3, %g7
	st	%g31, %g1, 44
	subi	%g1, %g1, 48
	call	div_binary_search.335
	addi	%g1, %g1, 48
	ld	%g31, %g1, 44
	muli	%g4, %g3, 1000
	ld	%g5, %g1, 36
	sub	%g4, %g5, %g4
	st	%g4, %g1, 44
	jlt	%g0, %g3, jle_else.751
	ld	%g5, %g1, 40
	jne	%g5, %g0, jeq_else.753
	addi	%g3, %g0, 0
	jmp	jeq_cont.754
jeq_else.753:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.754:
	jmp	jle_cont.752
jle_else.751:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.752:
	addi	%g4, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ld	%g7, %g1, 44
	st	%g3, %g1, 48
	mov	%g3, %g7
	st	%g31, %g1, 52
	subi	%g1, %g1, 56
	call	div_binary_search.335
	addi	%g1, %g1, 56
	ld	%g31, %g1, 52
	muli	%g4, %g3, 100
	ld	%g5, %g1, 44
	sub	%g4, %g5, %g4
	st	%g4, %g1, 52
	jlt	%g0, %g3, jle_else.755
	ld	%g5, %g1, 48
	jne	%g5, %g0, jeq_else.757
	addi	%g3, %g0, 0
	jmp	jeq_cont.758
jeq_else.757:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.758:
	jmp	jle_cont.756
jle_else.755:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.756:
	addi	%g4, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	ld	%g7, %g1, 52
	st	%g3, %g1, 56
	mov	%g3, %g7
	st	%g31, %g1, 60
	subi	%g1, %g1, 64
	call	div_binary_search.335
	addi	%g1, %g1, 64
	ld	%g31, %g1, 60
	muli	%g4, %g3, 10
	ld	%g5, %g1, 52
	sub	%g4, %g5, %g4
	st	%g4, %g1, 60
	jlt	%g0, %g3, jle_else.759
	ld	%g5, %g1, 56
	jne	%g5, %g0, jeq_else.761
	addi	%g3, %g0, 0
	jmp	jeq_cont.762
jeq_else.761:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.762:
	jmp	jle_cont.760
jle_else.759:
	addi	%g5, %g0, 48
	add	%g3, %g5, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.760:
	addi	%g3, %g0, 48
	ld	%g4, %g1, 60
	add	%g3, %g3, %g4
	output	%g3
	return
jge_else.732:
	addi	%g4, %g0, 45
	st	%g3, %g1, 0
	output	%g4
	ld	%g3, %g1, 0
	sub	%g3, %g0, %g3
	jmp	print_int.340
fib.342:
	jlt	%g28, %g3, jle_else.763
	return
jle_else.763:
	subi	%g4, %g3, 1
	st	%g3, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	fib.342
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	subi	%g4, %g4, 2
	st	%g3, %g1, 4
	mov	%g3, %g4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fib.342
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	add	%g3, %g4, %g3
	return
min_caml_start:
	addi	%g28, %g0, 1
	addi	%g29, %g0, -1
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	addi	%g3, %g0, 1
	addi	%g4, %g0, 1
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	addi	%g3, %g0, 30
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	fib.342
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	print_int.340
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	halt
