.init_heap_size	0
	jmp	min_caml_start

!#####################################################################
! * ここからライブラリ関数
!#####################################################################

! * create_array
min_caml_create_array:
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
	add %g4, %g3, %g2
	mov %g3, %g2
CREATE_FLOAT_ARRAY_LOOP:
	jlt %g4, %g2, CREATE_FLOAT_ARRAY_END
	st %f0, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_FLOAT_ARRAY_LOOP
CREATE_FLOAT_ARRAY_END:
	return

!#####################################################################
! * ここまでライブラリ関数
!#####################################################################

gcd.7:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jne	%g3, %g5, jeq_else.17
	mov	%g3, %g4
	return
jeq_else.17:
	jlt	%g4, %g3, jle_else.18
	sub	%g4, %g4, %g3
	jmp	gcd.7
jle_else.18:
	sub	%g3, %g3, %g4
	mov	%g28, %g4
	mov	%g4, %g3
	mov	%g3, %g28
	jmp	gcd.7
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 21600
	mvhi	%g4, 5
	mvlo	%g4, 9820
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	gcd.7
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	halt
