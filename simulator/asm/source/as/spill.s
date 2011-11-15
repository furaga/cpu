.init_heap_size	192
FLOAT_ZERO:		! 0.0
	.long 0x0
FLOAT_ONE:		! 1.0
	.long 0x3f800000
FLOAT_MONE:		! -1.0
	.long 0xbf800000
FLOAT_MAGICI:	! 8388608
	.long 0x800000
FLOAT_MAGICF:	! 8388608.0
	.long 0x4b000000
FLOAT_MAGICFHX:	! 1258291200
	.long 0x4b000000
	jmp	min_caml_start

!#####################################################################
!
! 		↓　ここから lib_asm.s
!
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
	
! * floor		%f0 + MAGICF - MAGICF
min_caml_floor:
	fmov %f1, %f0
	! %f4 = 0.0
	setL %g3, FLOAT_ZERO
	fld %f4, %g3, 0
	fjlt %f4, %f0, FLOOR_POSITIVE	! if (%f4 <= %f0) goto FLOOR_PISITIVE
	fjeq %f4, %f0, FLOOR_POSITIVE
FLOOR_NEGATIVE:
	fneg %f0, %f0
	setL %g3, FLOAT_MAGICF
	! %f2 = FLOAT_MAGICF
	fld %f2, %g3, 0
	fjlt %f0, %f2, FLOOR_NEGATIVE_MAIN
	fjeq %f0, %f2, FLOOR_NEGATIVE_MAIN
	fneg %f0, %f0
	return
FLOOR_NEGATIVE_MAIN:
	fadd %f0, %f0, %f2
	fsub %f0, %f0, %f2
	fneg %f1, %f1
	fjlt %f1, %f0, FLOOR_RET2
	fjeq %f1, %f0, FLOOR_RET2
	fadd %f0, %f0, %f2
	! %f3 = 1.0
	setL %g3, FLOAT_ONE
	fld %f3, %g3, 0
	fadd %f0, %f0, %f3
	fsub %f0, %f0, %f2
	fneg %f0, %f0
	return
FLOOR_POSITIVE:
	setL %g3, FLOAT_MAGICF
	fld %f2, %g3, 0
	fjlt %f0, %f2, FLOOR_POSITIVE_MAIN
	fjeq %f0, %f2, FLOOR_POSITIVE_MAIN
	return
FLOOR_POSITIVE_MAIN:
	fmov %f1, %f0
	fadd %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g4, %g1, 0
	fsub %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g4, %g1, 0
	fjlt %f0, %f1, FLOOR_RET
	fjeq %f0, %f1, FLOOR_RET
	setL %g3, FLOAT_ONE
	fld %f3, %g3, 0
	fsub %f0, %f0, %f3
FLOOR_RET:
	return
FLOOR_RET2:
	fneg %f0, %f0
	return
	
min_caml_ceil:
	fneg %f0, %f0
	call min_caml_floor
	fneg %f0, %f0
	return

! * float_of_int
min_caml_float_of_int:
	jlt %g0, %g3, ITOF_MAIN		! if (%g0 <= %g3) goto ITOF_MAIN
	jeq %g0, %g3, ITOF_MAIN
	sub %g3, %g0, %g3
	call ITOF_MAIN
	fneg %f0, %f0
	return
ITOF_MAIN:

	! %f1 <= FLOAT_MAGICF
	! %g4 <= FLOAT_MAGICFHX
	! %g5 <= FLOAT_MAGICI

	setL %g5, FLOAT_MAGICF
	fld %f1, %g5, 0
	setL %g5, FLOAT_MAGICFHX
	ld %g4, %g5, 0
	setL %g5, FLOAT_MAGICI
	ld %g5, %g5, 0
	jlt %g5, %g3, ITOF_BIG
	jeq %g5, %g3, ITOF_BIG
	add %g3, %g3, %g4
	st %g3, %g1, 0
	fld %f0, %g1, 0
	fsub %f0, %f0, %f1
	return
ITOF_BIG:
	setL %g4, FLOAT_ZERO
	fld %f2, %g4, 0
ITOF_LOOP:
	sub %g3, %g3, %g5
	fadd %f2, %f2, %f1
	jlt %g5, %g3, ITOF_LOOP
	jeq %g5, %g3, ITOF_LOOP
	add %g3, %g3, %g4
	st %g3, %g1, 0
	fld %f0, %g1, 0
	fsub %f0, %f0, %f1
	fadd %f0, %f0, %f2
	return

! * int_of_float
min_caml_int_of_float:
	! %f1 <= 0.0
	setL %g3, FLOAT_ZERO
	fld %f1, %g3, 0
	fjlt %f1, %f0, FTOI_MAIN			! if (0.0 <= %f0) goto FTOI_MAIN
	fjeq %f1, %f0, FTOI_MAIN
	fneg %f0, %f0
	call FTOI_MAIN
	sub %g3, %g0, %g3
	return
FTOI_MAIN:
	call min_caml_floor
	! %f2 <= FLOAT_MAGICF
	! %g4 <= FLOAT_MAGICFHX
	setL %g4, FLOAT_MAGICF
	fld %f2, %g4, 0
	setL %g4, FLOAT_MAGICFHX
	ld %g4, %g4, 0
	fjlt %f2, %f0, FTOI_BIG		! if (MAGICF <= %f0) goto FTOI_BIG
	fjeq %f2, %f0, FTOI_BIG
	fadd %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g3, %g1, 0
	sub %g3, %g3, %g4
	return
FTOI_BIG:
	setL %g5, FLOAT_MAGICI
	ld %g5, %g5, 0
	mov %g3, %g0
FTOI_LOOP:
	fsub %f0, %f0, %f2
	add %g3, %g3, %g5
	fjlt %f2, %f0, FTOI_LOOP
	fjeq %f2, %f0, FTOI_LOOP
	fadd %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g5, %g1, 0
	sub %g5, %g5, %g4
	add %g3, %g5, %g3
	return
	
! * truncate
min_caml_truncate:
	jmp min_caml_int_of_float


!#####################################################################
!
! 		↑　ここまで lib_asm.s
!
!#####################################################################
div_binary_search.369:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1852
	mov	%g3, %g5
	return
jle_else.1852:
	jlt	%g8, %g3, jle_else.1853
	jne	%g8, %g3, jeq_else.1854
	mov	%g3, %g7
	return
jeq_else.1854:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1855
	mov	%g3, %g5
	return
jle_else.1855:
	jlt	%g8, %g3, jle_else.1856
	jne	%g8, %g3, jeq_else.1857
	mov	%g3, %g6
	return
jeq_else.1857:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1858
	mov	%g3, %g5
	return
jle_else.1858:
	jlt	%g8, %g3, jle_else.1859
	jne	%g8, %g3, jeq_else.1860
	mov	%g3, %g7
	return
jeq_else.1860:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1861
	mov	%g3, %g5
	return
jle_else.1861:
	jlt	%g8, %g3, jle_else.1862
	jne	%g8, %g3, jeq_else.1863
	mov	%g3, %g6
	return
jeq_else.1863:
	jmp	div_binary_search.369
jle_else.1862:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.369
jle_else.1859:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1864
	mov	%g3, %g7
	return
jle_else.1864:
	jlt	%g8, %g3, jle_else.1865
	jne	%g8, %g3, jeq_else.1866
	mov	%g3, %g5
	return
jeq_else.1866:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.369
jle_else.1865:
	jmp	div_binary_search.369
jle_else.1856:
	add	%g5, %g6, %g7
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g7, %g6
	jlt	%g28, %g9, jle_else.1867
	mov	%g3, %g6
	return
jle_else.1867:
	jlt	%g8, %g3, jle_else.1868
	jne	%g8, %g3, jeq_else.1869
	mov	%g3, %g5
	return
jeq_else.1869:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.1870
	mov	%g3, %g6
	return
jle_else.1870:
	jlt	%g8, %g3, jle_else.1871
	jne	%g8, %g3, jeq_else.1872
	mov	%g3, %g7
	return
jeq_else.1872:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.369
jle_else.1871:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.369
jle_else.1868:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1873
	mov	%g3, %g5
	return
jle_else.1873:
	jlt	%g8, %g3, jle_else.1874
	jne	%g8, %g3, jeq_else.1875
	mov	%g3, %g6
	return
jeq_else.1875:
	jmp	div_binary_search.369
jle_else.1874:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.369
jle_else.1853:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1876
	mov	%g3, %g7
	return
jle_else.1876:
	jlt	%g8, %g3, jle_else.1877
	jne	%g8, %g3, jeq_else.1878
	mov	%g3, %g5
	return
jeq_else.1878:
	add	%g6, %g7, %g5
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g5, %g7
	jlt	%g28, %g9, jle_else.1879
	mov	%g3, %g7
	return
jle_else.1879:
	jlt	%g8, %g3, jle_else.1880
	jne	%g8, %g3, jeq_else.1881
	mov	%g3, %g6
	return
jeq_else.1881:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1882
	mov	%g3, %g7
	return
jle_else.1882:
	jlt	%g8, %g3, jle_else.1883
	jne	%g8, %g3, jeq_else.1884
	mov	%g3, %g5
	return
jeq_else.1884:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.369
jle_else.1883:
	jmp	div_binary_search.369
jle_else.1880:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.1885
	mov	%g3, %g6
	return
jle_else.1885:
	jlt	%g8, %g3, jle_else.1886
	jne	%g8, %g3, jeq_else.1887
	mov	%g3, %g7
	return
jeq_else.1887:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.369
jle_else.1886:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.369
jle_else.1877:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1888
	mov	%g3, %g5
	return
jle_else.1888:
	jlt	%g8, %g3, jle_else.1889
	jne	%g8, %g3, jeq_else.1890
	mov	%g3, %g7
	return
jeq_else.1890:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1891
	mov	%g3, %g5
	return
jle_else.1891:
	jlt	%g8, %g3, jle_else.1892
	jne	%g8, %g3, jeq_else.1893
	mov	%g3, %g6
	return
jeq_else.1893:
	jmp	div_binary_search.369
jle_else.1892:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.369
jle_else.1889:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1894
	mov	%g3, %g7
	return
jle_else.1894:
	jlt	%g8, %g3, jle_else.1895
	jne	%g8, %g3, jeq_else.1896
	mov	%g3, %g5
	return
jeq_else.1896:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.369
jle_else.1895:
	jmp	div_binary_search.369
print_int.374:
	jlt	%g3, %g0, jge_else.1897
	mvhi	%g10, 1525
	mvlo	%g10, 57600
	jlt	%g10, %g3, jle_else.1898
	jne	%g10, %g3, jeq_else.1900
	addi	%g10, %g0, 1
	jmp	jeq_cont.1901
jeq_else.1900:
	addi	%g10, %g0, 0
jeq_cont.1901:
	jmp	jle_cont.1899
jle_else.1898:
	mvhi	%g10, 3051
	mvlo	%g10, 49664
	jlt	%g10, %g3, jle_else.1902
	jne	%g10, %g3, jeq_else.1904
	addi	%g10, %g0, 2
	jmp	jeq_cont.1905
jeq_else.1904:
	addi	%g10, %g0, 1
jeq_cont.1905:
	jmp	jle_cont.1903
jle_else.1902:
	addi	%g10, %g0, 2
jle_cont.1903:
jle_cont.1899:
	mvhi	%g11, 1525
	mvlo	%g11, 57600
	mul	%g11, %g10, %g11
	sub	%g3, %g3, %g11
	st	%g3, %g1, 0
	jlt	%g0, %g10, jle_else.1906
	addi	%g3, %g0, 0
	jmp	jle_cont.1907
jle_else.1906:
	addi	%g11, %g0, 48
	add	%g10, %g11, %g10
	output	%g10
	addi	%g3, %g0, 1
jle_cont.1907:
	mvhi	%g4, 152
	mvlo	%g4, 38528
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g10, %g0, 5
	mvhi	%g11, 762
	mvlo	%g11, 61568
	ld	%g12, %g1, 0
	st	%g3, %g1, 4
	jlt	%g11, %g12, jle_else.1908
	jne	%g11, %g12, jeq_else.1910
	addi	%g3, %g0, 5
	jmp	jeq_cont.1911
jeq_else.1910:
	addi	%g6, %g0, 2
	mvhi	%g11, 305
	mvlo	%g11, 11520
	jlt	%g11, %g12, jle_else.1912
	jne	%g11, %g12, jeq_else.1914
	addi	%g3, %g0, 2
	jmp	jeq_cont.1915
jeq_else.1914:
	addi	%g10, %g0, 1
	mvhi	%g11, 152
	mvlo	%g11, 38528
	jlt	%g11, %g12, jle_else.1916
	jne	%g11, %g12, jeq_else.1918
	addi	%g3, %g0, 1
	jmp	jeq_cont.1919
jeq_else.1918:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.369
	addi	%g1, %g1, 16
jeq_cont.1919:
	jmp	jle_cont.1917
jle_else.1916:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.369
	addi	%g1, %g1, 16
jle_cont.1917:
jeq_cont.1915:
	jmp	jle_cont.1913
jle_else.1912:
	addi	%g5, %g0, 3
	mvhi	%g11, 457
	mvlo	%g11, 50048
	jlt	%g11, %g12, jle_else.1920
	jne	%g11, %g12, jeq_else.1922
	addi	%g3, %g0, 3
	jmp	jeq_cont.1923
jeq_else.1922:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.369
	addi	%g1, %g1, 16
jeq_cont.1923:
	jmp	jle_cont.1921
jle_else.1920:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.369
	addi	%g1, %g1, 16
jle_cont.1921:
jle_cont.1913:
jeq_cont.1911:
	jmp	jle_cont.1909
jle_else.1908:
	addi	%g5, %g0, 7
	mvhi	%g11, 1068
	mvlo	%g11, 7552
	jlt	%g11, %g12, jle_else.1924
	jne	%g11, %g12, jeq_else.1926
	addi	%g3, %g0, 7
	jmp	jeq_cont.1927
jeq_else.1926:
	addi	%g6, %g0, 6
	mvhi	%g11, 915
	mvlo	%g11, 34560
	jlt	%g11, %g12, jle_else.1928
	jne	%g11, %g12, jeq_else.1930
	addi	%g3, %g0, 6
	jmp	jeq_cont.1931
jeq_else.1930:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.369
	addi	%g1, %g1, 16
jeq_cont.1931:
	jmp	jle_cont.1929
jle_else.1928:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.369
	addi	%g1, %g1, 16
jle_cont.1929:
jeq_cont.1927:
	jmp	jle_cont.1925
jle_else.1924:
	addi	%g10, %g0, 8
	mvhi	%g11, 1220
	mvlo	%g11, 46080
	jlt	%g11, %g12, jle_else.1932
	jne	%g11, %g12, jeq_else.1934
	addi	%g3, %g0, 8
	jmp	jeq_cont.1935
jeq_else.1934:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.369
	addi	%g1, %g1, 16
jeq_cont.1935:
	jmp	jle_cont.1933
jle_else.1932:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.369
	addi	%g1, %g1, 16
jle_cont.1933:
jle_cont.1925:
jle_cont.1909:
	mvhi	%g10, 152
	mvlo	%g10, 38528
	mul	%g10, %g3, %g10
	sub	%g10, %g12, %g10
	jlt	%g0, %g3, jle_else.1936
	ld	%g11, %g1, 4
	jne	%g11, %g0, jeq_else.1938
	addi	%g3, %g0, 0
	jmp	jeq_cont.1939
jeq_else.1938:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1939:
	jmp	jle_cont.1937
jle_else.1936:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1937:
	mvhi	%g4, 15
	mvlo	%g4, 16960
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 76
	mvlo	%g12, 19264
	st	%g3, %g1, 8
	jlt	%g12, %g10, jle_else.1940
	jne	%g12, %g10, jeq_else.1942
	addi	%g3, %g0, 5
	jmp	jeq_cont.1943
jeq_else.1942:
	addi	%g6, %g0, 2
	mvhi	%g12, 30
	mvlo	%g12, 33920
	jlt	%g12, %g10, jle_else.1944
	jne	%g12, %g10, jeq_else.1946
	addi	%g3, %g0, 2
	jmp	jeq_cont.1947
jeq_else.1946:
	addi	%g11, %g0, 1
	mvhi	%g12, 15
	mvlo	%g12, 16960
	jlt	%g12, %g10, jle_else.1948
	jne	%g12, %g10, jeq_else.1950
	addi	%g3, %g0, 1
	jmp	jeq_cont.1951
jeq_else.1950:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.369
	addi	%g1, %g1, 16
jeq_cont.1951:
	jmp	jle_cont.1949
jle_else.1948:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.369
	addi	%g1, %g1, 16
jle_cont.1949:
jeq_cont.1947:
	jmp	jle_cont.1945
jle_else.1944:
	addi	%g5, %g0, 3
	mvhi	%g12, 45
	mvlo	%g12, 50880
	jlt	%g12, %g10, jle_else.1952
	jne	%g12, %g10, jeq_else.1954
	addi	%g3, %g0, 3
	jmp	jeq_cont.1955
jeq_else.1954:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.369
	addi	%g1, %g1, 16
jeq_cont.1955:
	jmp	jle_cont.1953
jle_else.1952:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.369
	addi	%g1, %g1, 16
jle_cont.1953:
jle_cont.1945:
jeq_cont.1943:
	jmp	jle_cont.1941
jle_else.1940:
	addi	%g5, %g0, 7
	mvhi	%g12, 106
	mvlo	%g12, 53184
	jlt	%g12, %g10, jle_else.1956
	jne	%g12, %g10, jeq_else.1958
	addi	%g3, %g0, 7
	jmp	jeq_cont.1959
jeq_else.1958:
	addi	%g6, %g0, 6
	mvhi	%g12, 91
	mvlo	%g12, 36224
	jlt	%g12, %g10, jle_else.1960
	jne	%g12, %g10, jeq_else.1962
	addi	%g3, %g0, 6
	jmp	jeq_cont.1963
jeq_else.1962:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.369
	addi	%g1, %g1, 16
jeq_cont.1963:
	jmp	jle_cont.1961
jle_else.1960:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.369
	addi	%g1, %g1, 16
jle_cont.1961:
jeq_cont.1959:
	jmp	jle_cont.1957
jle_else.1956:
	addi	%g11, %g0, 8
	mvhi	%g12, 122
	mvlo	%g12, 4608
	jlt	%g12, %g10, jle_else.1964
	jne	%g12, %g10, jeq_else.1966
	addi	%g3, %g0, 8
	jmp	jeq_cont.1967
jeq_else.1966:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.369
	addi	%g1, %g1, 16
jeq_cont.1967:
	jmp	jle_cont.1965
jle_else.1964:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.369
	addi	%g1, %g1, 16
jle_cont.1965:
jle_cont.1957:
jle_cont.1941:
	mvhi	%g11, 15
	mvlo	%g11, 16960
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1968
	ld	%g11, %g1, 8
	jne	%g11, %g0, jeq_else.1970
	addi	%g3, %g0, 0
	jmp	jeq_cont.1971
jeq_else.1970:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1971:
	jmp	jle_cont.1969
jle_else.1968:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1969:
	mvhi	%g4, 1
	mvlo	%g4, 34464
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 7
	mvlo	%g12, 41248
	st	%g3, %g1, 12
	jlt	%g12, %g10, jle_else.1972
	jne	%g12, %g10, jeq_else.1974
	addi	%g3, %g0, 5
	jmp	jeq_cont.1975
jeq_else.1974:
	addi	%g6, %g0, 2
	mvhi	%g12, 3
	mvlo	%g12, 3392
	jlt	%g12, %g10, jle_else.1976
	jne	%g12, %g10, jeq_else.1978
	addi	%g3, %g0, 2
	jmp	jeq_cont.1979
jeq_else.1978:
	addi	%g11, %g0, 1
	mvhi	%g12, 1
	mvlo	%g12, 34464
	jlt	%g12, %g10, jle_else.1980
	jne	%g12, %g10, jeq_else.1982
	addi	%g3, %g0, 1
	jmp	jeq_cont.1983
jeq_else.1982:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.369
	addi	%g1, %g1, 24
jeq_cont.1983:
	jmp	jle_cont.1981
jle_else.1980:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.369
	addi	%g1, %g1, 24
jle_cont.1981:
jeq_cont.1979:
	jmp	jle_cont.1977
jle_else.1976:
	addi	%g5, %g0, 3
	mvhi	%g12, 4
	mvlo	%g12, 37856
	jlt	%g12, %g10, jle_else.1984
	jne	%g12, %g10, jeq_else.1986
	addi	%g3, %g0, 3
	jmp	jeq_cont.1987
jeq_else.1986:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.369
	addi	%g1, %g1, 24
jeq_cont.1987:
	jmp	jle_cont.1985
jle_else.1984:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.369
	addi	%g1, %g1, 24
jle_cont.1985:
jle_cont.1977:
jeq_cont.1975:
	jmp	jle_cont.1973
jle_else.1972:
	addi	%g5, %g0, 7
	mvhi	%g12, 10
	mvlo	%g12, 44640
	jlt	%g12, %g10, jle_else.1988
	jne	%g12, %g10, jeq_else.1990
	addi	%g3, %g0, 7
	jmp	jeq_cont.1991
jeq_else.1990:
	addi	%g6, %g0, 6
	mvhi	%g12, 9
	mvlo	%g12, 10176
	jlt	%g12, %g10, jle_else.1992
	jne	%g12, %g10, jeq_else.1994
	addi	%g3, %g0, 6
	jmp	jeq_cont.1995
jeq_else.1994:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.369
	addi	%g1, %g1, 24
jeq_cont.1995:
	jmp	jle_cont.1993
jle_else.1992:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.369
	addi	%g1, %g1, 24
jle_cont.1993:
jeq_cont.1991:
	jmp	jle_cont.1989
jle_else.1988:
	addi	%g11, %g0, 8
	mvhi	%g12, 12
	mvlo	%g12, 13568
	jlt	%g12, %g10, jle_else.1996
	jne	%g12, %g10, jeq_else.1998
	addi	%g3, %g0, 8
	jmp	jeq_cont.1999
jeq_else.1998:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.369
	addi	%g1, %g1, 24
jeq_cont.1999:
	jmp	jle_cont.1997
jle_else.1996:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.369
	addi	%g1, %g1, 24
jle_cont.1997:
jle_cont.1989:
jle_cont.1973:
	mvhi	%g11, 1
	mvlo	%g11, 34464
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2000
	ld	%g11, %g1, 12
	jne	%g11, %g0, jeq_else.2002
	addi	%g3, %g0, 0
	jmp	jeq_cont.2003
jeq_else.2002:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2003:
	jmp	jle_cont.2001
jle_else.2000:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2001:
	addi	%g4, %g0, 10000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 0
	mvlo	%g12, 50000
	st	%g3, %g1, 16
	jlt	%g12, %g10, jle_else.2004
	jne	%g12, %g10, jeq_else.2006
	addi	%g3, %g0, 5
	jmp	jeq_cont.2007
jeq_else.2006:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20000
	jlt	%g12, %g10, jle_else.2008
	jne	%g12, %g10, jeq_else.2010
	addi	%g3, %g0, 2
	jmp	jeq_cont.2011
jeq_else.2010:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10000
	jlt	%g12, %g10, jle_else.2012
	jne	%g12, %g10, jeq_else.2014
	addi	%g3, %g0, 1
	jmp	jeq_cont.2015
jeq_else.2014:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.369
	addi	%g1, %g1, 24
jeq_cont.2015:
	jmp	jle_cont.2013
jle_else.2012:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.369
	addi	%g1, %g1, 24
jle_cont.2013:
jeq_cont.2011:
	jmp	jle_cont.2009
jle_else.2008:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30000
	jlt	%g12, %g10, jle_else.2016
	jne	%g12, %g10, jeq_else.2018
	addi	%g3, %g0, 3
	jmp	jeq_cont.2019
jeq_else.2018:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.369
	addi	%g1, %g1, 24
jeq_cont.2019:
	jmp	jle_cont.2017
jle_else.2016:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.369
	addi	%g1, %g1, 24
jle_cont.2017:
jle_cont.2009:
jeq_cont.2007:
	jmp	jle_cont.2005
jle_else.2004:
	addi	%g5, %g0, 7
	mvhi	%g12, 1
	mvlo	%g12, 4464
	jlt	%g12, %g10, jle_else.2020
	jne	%g12, %g10, jeq_else.2022
	addi	%g3, %g0, 7
	jmp	jeq_cont.2023
jeq_else.2022:
	addi	%g6, %g0, 6
	mvhi	%g12, 0
	mvlo	%g12, 60000
	jlt	%g12, %g10, jle_else.2024
	jne	%g12, %g10, jeq_else.2026
	addi	%g3, %g0, 6
	jmp	jeq_cont.2027
jeq_else.2026:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.369
	addi	%g1, %g1, 24
jeq_cont.2027:
	jmp	jle_cont.2025
jle_else.2024:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.369
	addi	%g1, %g1, 24
jle_cont.2025:
jeq_cont.2023:
	jmp	jle_cont.2021
jle_else.2020:
	addi	%g11, %g0, 8
	mvhi	%g12, 1
	mvlo	%g12, 14464
	jlt	%g12, %g10, jle_else.2028
	jne	%g12, %g10, jeq_else.2030
	addi	%g3, %g0, 8
	jmp	jeq_cont.2031
jeq_else.2030:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.369
	addi	%g1, %g1, 24
jeq_cont.2031:
	jmp	jle_cont.2029
jle_else.2028:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.369
	addi	%g1, %g1, 24
jle_cont.2029:
jle_cont.2021:
jle_cont.2005:
	addi	%g11, %g0, 10000
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2032
	ld	%g11, %g1, 16
	jne	%g11, %g0, jeq_else.2034
	addi	%g3, %g0, 0
	jmp	jeq_cont.2035
jeq_else.2034:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2035:
	jmp	jle_cont.2033
jle_else.2032:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2033:
	addi	%g4, %g0, 1000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 5000
	st	%g3, %g1, 20
	jlt	%g12, %g10, jle_else.2036
	jne	%g12, %g10, jeq_else.2038
	addi	%g3, %g0, 5
	jmp	jeq_cont.2039
jeq_else.2038:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 2000
	jlt	%g12, %g10, jle_else.2040
	jne	%g12, %g10, jeq_else.2042
	addi	%g3, %g0, 2
	jmp	jeq_cont.2043
jeq_else.2042:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 1000
	jlt	%g12, %g10, jle_else.2044
	jne	%g12, %g10, jeq_else.2046
	addi	%g3, %g0, 1
	jmp	jeq_cont.2047
jeq_else.2046:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.369
	addi	%g1, %g1, 32
jeq_cont.2047:
	jmp	jle_cont.2045
jle_else.2044:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.369
	addi	%g1, %g1, 32
jle_cont.2045:
jeq_cont.2043:
	jmp	jle_cont.2041
jle_else.2040:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 3000
	jlt	%g12, %g10, jle_else.2048
	jne	%g12, %g10, jeq_else.2050
	addi	%g3, %g0, 3
	jmp	jeq_cont.2051
jeq_else.2050:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.369
	addi	%g1, %g1, 32
jeq_cont.2051:
	jmp	jle_cont.2049
jle_else.2048:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.369
	addi	%g1, %g1, 32
jle_cont.2049:
jle_cont.2041:
jeq_cont.2039:
	jmp	jle_cont.2037
jle_else.2036:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 7000
	jlt	%g12, %g10, jle_else.2052
	jne	%g12, %g10, jeq_else.2054
	addi	%g3, %g0, 7
	jmp	jeq_cont.2055
jeq_else.2054:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 6000
	jlt	%g12, %g10, jle_else.2056
	jne	%g12, %g10, jeq_else.2058
	addi	%g3, %g0, 6
	jmp	jeq_cont.2059
jeq_else.2058:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.369
	addi	%g1, %g1, 32
jeq_cont.2059:
	jmp	jle_cont.2057
jle_else.2056:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.369
	addi	%g1, %g1, 32
jle_cont.2057:
jeq_cont.2055:
	jmp	jle_cont.2053
jle_else.2052:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 8000
	jlt	%g12, %g10, jle_else.2060
	jne	%g12, %g10, jeq_else.2062
	addi	%g3, %g0, 8
	jmp	jeq_cont.2063
jeq_else.2062:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.369
	addi	%g1, %g1, 32
jeq_cont.2063:
	jmp	jle_cont.2061
jle_else.2060:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.369
	addi	%g1, %g1, 32
jle_cont.2061:
jle_cont.2053:
jle_cont.2037:
	muli	%g11, %g3, 1000
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2064
	ld	%g11, %g1, 20
	jne	%g11, %g0, jeq_else.2066
	addi	%g3, %g0, 0
	jmp	jeq_cont.2067
jeq_else.2066:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2067:
	jmp	jle_cont.2065
jle_else.2064:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2065:
	addi	%g4, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 500
	st	%g3, %g1, 24
	jlt	%g12, %g10, jle_else.2068
	jne	%g12, %g10, jeq_else.2070
	addi	%g3, %g0, 5
	jmp	jeq_cont.2071
jeq_else.2070:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 200
	jlt	%g12, %g10, jle_else.2072
	jne	%g12, %g10, jeq_else.2074
	addi	%g3, %g0, 2
	jmp	jeq_cont.2075
jeq_else.2074:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 100
	jlt	%g12, %g10, jle_else.2076
	jne	%g12, %g10, jeq_else.2078
	addi	%g3, %g0, 1
	jmp	jeq_cont.2079
jeq_else.2078:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.369
	addi	%g1, %g1, 32
jeq_cont.2079:
	jmp	jle_cont.2077
jle_else.2076:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.369
	addi	%g1, %g1, 32
jle_cont.2077:
jeq_cont.2075:
	jmp	jle_cont.2073
jle_else.2072:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 300
	jlt	%g12, %g10, jle_else.2080
	jne	%g12, %g10, jeq_else.2082
	addi	%g3, %g0, 3
	jmp	jeq_cont.2083
jeq_else.2082:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.369
	addi	%g1, %g1, 32
jeq_cont.2083:
	jmp	jle_cont.2081
jle_else.2080:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.369
	addi	%g1, %g1, 32
jle_cont.2081:
jle_cont.2073:
jeq_cont.2071:
	jmp	jle_cont.2069
jle_else.2068:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 700
	jlt	%g12, %g10, jle_else.2084
	jne	%g12, %g10, jeq_else.2086
	addi	%g3, %g0, 7
	jmp	jeq_cont.2087
jeq_else.2086:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 600
	jlt	%g12, %g10, jle_else.2088
	jne	%g12, %g10, jeq_else.2090
	addi	%g3, %g0, 6
	jmp	jeq_cont.2091
jeq_else.2090:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.369
	addi	%g1, %g1, 32
jeq_cont.2091:
	jmp	jle_cont.2089
jle_else.2088:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.369
	addi	%g1, %g1, 32
jle_cont.2089:
jeq_cont.2087:
	jmp	jle_cont.2085
jle_else.2084:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 800
	jlt	%g12, %g10, jle_else.2092
	jne	%g12, %g10, jeq_else.2094
	addi	%g3, %g0, 8
	jmp	jeq_cont.2095
jeq_else.2094:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.369
	addi	%g1, %g1, 32
jeq_cont.2095:
	jmp	jle_cont.2093
jle_else.2092:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.369
	addi	%g1, %g1, 32
jle_cont.2093:
jle_cont.2085:
jle_cont.2069:
	muli	%g11, %g3, 100
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2096
	ld	%g11, %g1, 24
	jne	%g11, %g0, jeq_else.2098
	addi	%g3, %g0, 0
	jmp	jeq_cont.2099
jeq_else.2098:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2099:
	jmp	jle_cont.2097
jle_else.2096:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2097:
	addi	%g4, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 50
	st	%g3, %g1, 28
	jlt	%g12, %g10, jle_else.2100
	jne	%g12, %g10, jeq_else.2102
	addi	%g3, %g0, 5
	jmp	jeq_cont.2103
jeq_else.2102:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20
	jlt	%g12, %g10, jle_else.2104
	jne	%g12, %g10, jeq_else.2106
	addi	%g3, %g0, 2
	jmp	jeq_cont.2107
jeq_else.2106:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10
	jlt	%g12, %g10, jle_else.2108
	jne	%g12, %g10, jeq_else.2110
	addi	%g3, %g0, 1
	jmp	jeq_cont.2111
jeq_else.2110:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.369
	addi	%g1, %g1, 40
jeq_cont.2111:
	jmp	jle_cont.2109
jle_else.2108:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.369
	addi	%g1, %g1, 40
jle_cont.2109:
jeq_cont.2107:
	jmp	jle_cont.2105
jle_else.2104:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30
	jlt	%g12, %g10, jle_else.2112
	jne	%g12, %g10, jeq_else.2114
	addi	%g3, %g0, 3
	jmp	jeq_cont.2115
jeq_else.2114:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.369
	addi	%g1, %g1, 40
jeq_cont.2115:
	jmp	jle_cont.2113
jle_else.2112:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.369
	addi	%g1, %g1, 40
jle_cont.2113:
jle_cont.2105:
jeq_cont.2103:
	jmp	jle_cont.2101
jle_else.2100:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 70
	jlt	%g12, %g10, jle_else.2116
	jne	%g12, %g10, jeq_else.2118
	addi	%g3, %g0, 7
	jmp	jeq_cont.2119
jeq_else.2118:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 60
	jlt	%g12, %g10, jle_else.2120
	jne	%g12, %g10, jeq_else.2122
	addi	%g3, %g0, 6
	jmp	jeq_cont.2123
jeq_else.2122:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.369
	addi	%g1, %g1, 40
jeq_cont.2123:
	jmp	jle_cont.2121
jle_else.2120:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.369
	addi	%g1, %g1, 40
jle_cont.2121:
jeq_cont.2119:
	jmp	jle_cont.2117
jle_else.2116:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 80
	jlt	%g12, %g10, jle_else.2124
	jne	%g12, %g10, jeq_else.2126
	addi	%g3, %g0, 8
	jmp	jeq_cont.2127
jeq_else.2126:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.369
	addi	%g1, %g1, 40
jeq_cont.2127:
	jmp	jle_cont.2125
jle_else.2124:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.369
	addi	%g1, %g1, 40
jle_cont.2125:
jle_cont.2117:
jle_cont.2101:
	muli	%g11, %g3, 10
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2128
	ld	%g11, %g1, 28
	jne	%g11, %g0, jeq_else.2130
	addi	%g3, %g0, 0
	jmp	jeq_cont.2131
jeq_else.2130:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2131:
	jmp	jle_cont.2129
jle_else.2128:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2129:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g10
	output	%g3
	return
jge_else.1897:
	addi	%g10, %g0, 45
	st	%g3, %g1, 32
	output	%g10
	ld	%g3, %g1, 32
	sub	%g3, %g0, %g3
	jmp	print_int.374
min_caml_start:
	addi	%g28, %g0, 1
	addi	%g29, %g0, -1
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	addi	%g3, %g0, 1
	addi	%g4, %g0, 1
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	addi	%g3, %g0, -431
	subi	%g1, %g1, 8
	call	print_int.374
	addi	%g1, %g1, 8
	halt
