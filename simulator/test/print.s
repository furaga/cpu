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
	jeq %g5, %g2, CREATE_ARRAY_END
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
	jeq %g4, %g2, CREATE_ARRAY_END
	fst %f0, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_FLOAT_ARRAY_LOOP
CREATE_FLOAT_ARRAY_END:
	return

!#####################################################################
! * ここまでライブラリ関数
!#####################################################################

min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 123
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_print_int
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 65535
	mvlo	%g3, -456
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_print_int
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g3, 0
	mvlo	%g3, 789
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_print_int
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	halt
