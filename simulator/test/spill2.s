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

f.26:
	mvhi	%g3, 0
	mvlo	%g3, 12345
	return
g.28:
	addi	%g3, %g3, 1
	return
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 10
	mvhi	%g4, 0
	mvlo	%g4, 1
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	st	%g3, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	f.26
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mvhi	%g4, 1
	mvlo	%g4, 2354
	ld	%g5, %g1, 0
	ld	%g6, %g5, 0
	add	%g7, %g6, %g6
	add	%g8, %g7, %g7
	add	%g9, %g8, %g8
	add	%g10, %g9, %g9
	add	%g11, %g10, %g10
	add	%g12, %g11, %g11
	add	%g13, %g12, %g12
	add	%g14, %g13, %g13
	add	%g15, %g14, %g14
	add	%g16, %g15, %g15
	add	%g17, %g16, %g16
	add	%g18, %g17, %g17
	add	%g19, %g18, %g18
	add	%g20, %g19, %g19
	add	%g21, %g20, %g20
	ld	%g5, %g5, -4
	mvhi	%g22, 0
	mvlo	%g22, 0
	jne	%g5, %g22, jeq_else.79
	mov	%g3, %g4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	g.28
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	jmp	jeq_cont.80
jeq_else.79:
	add	%g4, %g6, %g7
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
	add	%g3, %g4, %g3
jeq_cont.80:
	output	%g3
	halt
