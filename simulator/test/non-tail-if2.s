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
	fst %f0, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_FLOAT_ARRAY_LOOP
CREATE_FLOAT_ARRAY_END:
	return

!#####################################################################
! * ここまでライブラリ関数
!#####################################################################

f.13:
	mvhi	%g3, 0
	mvlo	%g3, 12345
	return
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 10
	mvhi	%g4, 0
	mvlo	%g4, 3
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 1
	mvlo	%g4, 2354
	ld	%g5, %g3, 0
	mvhi	%g6, 0
	mvlo	%g6, 3
	jne	%g5, %g6, jeq_else.35
	st	%g4, %g1, 0
	st	%g3, %g1, 4
	st	%g31, %g1, 12
	subi	%g1, %g1, 16
	call	f.13
	addi	%g1, %g1, 16
	ld	%g31, %g1, 12
	ld	%g4, %g1, 4
	ld	%g4, %g4, -4
	add	%g3, %g3, %g4
	ld	%g4, %g1, 0
	add	%g3, %g3, %g4
	jmp	jeq_cont.36
jeq_else.35:
	mvhi	%g3, 0
	mvlo	%g3, 7
jeq_cont.36:
	output	%g3
	halt
