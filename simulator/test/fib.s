.init_heap_size	0
	jmp	min_caml_start

!#####################################################################
! * ここからライブラリ関数
!#####################################################################

! * create_array
min_caml_create_array:
	slli %g3, %g3, 2
	add %g5, %g3, %g2
	mov %g3, %g2
CREATE_ARRAY_LOOP:
	jlt %g5, %g2, CREATE_ARRAY_END
	st %g4, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_ARRAY_LOOP
CREATE_ARRAY_END:
	return

! * create_float_array
min_caml_create_float_array:
	slli %g3, %g3, 2
	add %g4, %g3, %g2
	mov %g3, %g2
CREATE_FLOAT_ARRAY_LOOP:
	jlt %g4, %g2, CREATE_FLOAT_ARRAY_END
	fst %f0, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_FLOAT_ARRAY_LOOP
CREATE_FLOAT_ARRAY_END:
	return

!#####################################################################
! * ここまでライブラリ関数
!#####################################################################

fib.10:
	mvhi	%g4, 0
	mvlo	%g4, 1
	jlt	%g4, %g3, jle_else.24
	return
jle_else.24:
	subi	%g4, %g3, 1
	st	%g3, %g1, 0
	mov	%g3, %g4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	fib.10
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g4, %g1, 0
	subi	%g4, %g4, 2
	st	%g3, %g1, 4
	mov	%g3, %g4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	fib.10
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	add	%g3, %g4, %g3
	return
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 30
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	fib.10
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	halt
