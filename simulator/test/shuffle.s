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

foo.12:
	st	%g8, %g1, 0
	st	%g7, %g1, 4
	st	%g6, %g1, 8
	st	%g5, %g1, 12
	st	%g4, %g1, 16
	output	%g3
	ld	%g3, %g1, 16
	output	%g3
	ld	%g3, %g1, 12
	output	%g3
	ld	%g3, %g1, 8
	output	%g3
	ld	%g3, %g1, 4
	output	%g3
	ld	%g3, %g1, 0
	output	%g3
	return
bar.19:
	mov	%g28, %g8
	mov	%g8, %g5
	mov	%g5, %g6
	mov	%g6, %g7
	mov	%g7, %g28
	mov	%g28, %g4
	mov	%g4, %g3
	mov	%g3, %g28
	jmp	foo.12
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 2
	mvhi	%g5, 0
	mvlo	%g5, 3
	mvhi	%g6, 0
	mvlo	%g6, 4
	mvhi	%g7, 0
	mvlo	%g7, 5
	mvhi	%g8, 0
	mvlo	%g8, 6
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	bar.19
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	halt
