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

min_caml_start:
	mvhi	%g3, 0
	mvlo	%g3, 1
	slli	%g3, %g3, 1
	output	%g3
	mvhi	%g3, 0
	mvlo	%g3, 3
	slli	%g3, %g3, 1
	output	%g3
	mvhi	%g3, 65535
	mvlo	%g3, -4
	slli	%g3, %g3, 2
	output	%g3
	mvhi	%g3, 0
	mvlo	%g3, 5
	slli	%g3, %g3, 3
	output	%g3
	halt
