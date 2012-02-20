

! use f15, g15
debug_print:
	fsti %f15, %g1, 4
	ldi	%g15, %g1, 4
	output %g15
	srli	%g15, %g15, 8
	output %g15
	srli	%g15, %g15, 8
	output %g15
	srli	%g15, %g15, 8
	output %g15
	addi	%g15, %g0, 10
	output %g15
	return
	
