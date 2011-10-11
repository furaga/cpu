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

ack.15:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jlt	%g5, %g3, jle_else.34
	addi	%g3, %g4, 1
	return
jle_else.34:
	mvhi	%g5, 0
	mvlo	%g5, 0
	jlt	%g5, %g4, jle_else.35
	subi	%g3, %g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 1
	jmp	ack.15
jle_else.35:
	subi	%g5, %g3, 1
	subi	%g4, %g4, 1
	st	%g5, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	ack.15
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g4, %g3
	ld	%g3, %g1, 0
	jmp	ack.15
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 3
	mvhi	%g4, 0
	mvlo	%g4, 10
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	ack.15
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	halt
