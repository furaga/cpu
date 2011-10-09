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

composed.22:
	ld	%g4, %g29, -8
	ld	%g29, %g29, -4
	st	%g4, %g1, 0
	st	%g31, %g1, 4
	ld	%g28, %g29, 0
	subi	%g1, %g1, 8
	callR	%g28
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	ld	%g29, %g1, 0
	ld	%g28, %g29, 0
	b	%g28
compose.7:
	mov	%g5, %g2
	addi	%g2, %g2, 16
	setL %g6, composed.22
	st	%g6, %g5, 0
	st	%g4, %g5, -8
	st	%g3, %g5, -4
	mov	%g3, %g5
	return
dbl.10:
	add	%g3, %g3, %g3
	return
inc.12:
	addi	%g3, %g3, 1
	return
dec.14:
	subi	%g3, %g3, 1
	return
min_caml_start:
	mov	%g3, %g2
	addi	%g2, %g2, 8
	setL %g4, dbl.10
	st	%g4, %g3, 0
	mov	%g4, %g2
	addi	%g2, %g2, 8
	setL %g5, inc.12
	st	%g5, %g4, 0
	mov	%g5, %g2
	addi	%g2, %g2, 8
	setL %g6, dec.14
	st	%g6, %g5, 0
	st	%g4, %g1, 0
	mov	%g4, %g5
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	compose.7
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g4, %g3
	ld	%g3, %g1, 0
	st	%g31, %g1, 4
	subi	%g1, %g1, 8
	call	compose.7
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	mov	%g29, %g3
	mvhi	%g3, 0
	mvlo	%g3, 123
	st	%g31, %g1, 4
	ld	%g28, %g29, 0
	subi	%g1, %g1, 8
	callR	%g28
	addi	%g1, %g1, 8
	ld	%g31, %g1, 4
	output	%g3
	halt
