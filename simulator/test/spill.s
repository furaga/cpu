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

f.43:
	add	%g7, %g3, %g4
	add	%g8, %g3, %g5
	add	%g9, %g3, %g6
	add	%g10, %g4, %g5
	add	%g11, %g4, %g6
	add	%g12, %g5, %g6
	add	%g13, %g7, %g8
	add	%g14, %g7, %g9
	add	%g15, %g7, %g10
	add	%g16, %g7, %g11
	add	%g17, %g7, %g12
	add	%g18, %g8, %g9
	add	%g19, %g8, %g10
	add	%g20, %g8, %g11
	add	%g21, %g8, %g12
	add	%g22, %g9, %g10
	add	%g23, %g9, %g11
	add	%g24, %g9, %g12
	add	%g25, %g10, %g11
	add	%g26, %g10, %g12
	add	%g27, %g11, %g12
	add	%g28, %g13, %g14
	add	%g29, %g13, %g15
	st	%g29, %g1, 0
	add	%g29, %g13, %g16
	st	%g29, %g1, 4
	add	%g29, %g13, %g17
	st	%g29, %g1, 8
	add	%g29, %g13, %g18
	st	%g29, %g1, 12
	add	%g29, %g13, %g19
	st	%g29, %g1, 16
	add	%g29, %g13, %g20
	st	%g29, %g1, 20
	add	%g29, %g13, %g21
	st	%g29, %g1, 24
	add	%g29, %g13, %g22
	st	%g29, %g1, 28
	add	%g29, %g13, %g23
	st	%g29, %g1, 32
	add	%g29, %g13, %g24
	st	%g29, %g1, 36
	add	%g29, %g13, %g25
	st	%g29, %g1, 40
	add	%g29, %g13, %g26
	st	%g29, %g1, 44
	add	%g29, %g13, %g27
	add	%g3, %g3, %g4
	add	%g3, %g3, %g5
	add	%g3, %g3, %g6
	add	%g3, %g3, %g7
	add	%g3, %g3, %g8
	add	%g3, %g3, %g9
	add	%g3, %g3, %g10
	add	%g3, %g3, %g11
	add	%g3, %g3, %g12
	add	%g3, %g3, %g13
	add	%g3, %g3, %g14
	add	%g3, %g3, %g15
	add	%g3, %g3, %g16
	add	%g3, %g3, %g17
	add	%g3, %g3, %g18
	add	%g3, %g3, %g19
	add	%g3, %g3, %g20
	add	%g3, %g3, %g21
	add	%g3, %g3, %g22
	add	%g3, %g3, %g23
	add	%g3, %g3, %g24
	add	%g3, %g3, %g25
	add	%g3, %g3, %g26
	add	%g3, %g3, %g27
	add	%g3, %g3, %g28
	ld	%g4, %g1, 0
	add	%g3, %g3, %g4
	ld	%g4, %g1, 4
	add	%g3, %g3, %g4
	ld	%g4, %g1, 8
	add	%g3, %g3, %g4
	ld	%g4, %g1, 12
	add	%g3, %g3, %g4
	ld	%g4, %g1, 16
	add	%g3, %g3, %g4
	ld	%g4, %g1, 20
	add	%g3, %g3, %g4
	ld	%g4, %g1, 24
	add	%g3, %g3, %g4
	ld	%g4, %g1, 28
	add	%g3, %g3, %g4
	ld	%g4, %g1, 32
	add	%g3, %g3, %g4
	ld	%g4, %g1, 36
	add	%g3, %g3, %g4
	ld	%g4, %g1, 40
	add	%g3, %g3, %g4
	ld	%g4, %g1, 44
	add	%g3, %g3, %g4
	add	%g3, %g3, %g29
	muli	%g3, %g3, -1
	return
min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 1
	mvhi	%g4, 0
	mvlo	%g4, 2
	mvhi	%g5, 0
	mvlo	%g5, 3
	mvhi	%g6, 0
	mvlo	%g6, 4
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	f.43
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	halt
