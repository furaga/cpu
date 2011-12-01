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
div_binary_search.333:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1855
	mov	%g3, %g5
	return
jle_else.1855:
	jlt	%g8, %g3, jle_else.1856
	jne	%g8, %g3, jeq_else.1857
	mov	%g3, %g7
	return
jeq_else.1857:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1858
	mov	%g3, %g5
	return
jle_else.1858:
	jlt	%g8, %g3, jle_else.1859
	jne	%g8, %g3, jeq_else.1860
	mov	%g3, %g6
	return
jeq_else.1860:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1861
	mov	%g3, %g5
	return
jle_else.1861:
	jlt	%g8, %g3, jle_else.1862
	jne	%g8, %g3, jeq_else.1863
	mov	%g3, %g7
	return
jeq_else.1863:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1864
	mov	%g3, %g5
	return
jle_else.1864:
	jlt	%g8, %g3, jle_else.1865
	jne	%g8, %g3, jeq_else.1866
	mov	%g3, %g6
	return
jeq_else.1866:
	jmp	div_binary_search.333
jle_else.1865:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.333
jle_else.1862:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1867
	mov	%g3, %g7
	return
jle_else.1867:
	jlt	%g8, %g3, jle_else.1868
	jne	%g8, %g3, jeq_else.1869
	mov	%g3, %g5
	return
jeq_else.1869:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.333
jle_else.1868:
	jmp	div_binary_search.333
jle_else.1859:
	add	%g5, %g6, %g7
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g7, %g6
	jlt	%g28, %g9, jle_else.1870
	mov	%g3, %g6
	return
jle_else.1870:
	jlt	%g8, %g3, jle_else.1871
	jne	%g8, %g3, jeq_else.1872
	mov	%g3, %g5
	return
jeq_else.1872:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.1873
	mov	%g3, %g6
	return
jle_else.1873:
	jlt	%g8, %g3, jle_else.1874
	jne	%g8, %g3, jeq_else.1875
	mov	%g3, %g7
	return
jeq_else.1875:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.333
jle_else.1874:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.333
jle_else.1871:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1876
	mov	%g3, %g5
	return
jle_else.1876:
	jlt	%g8, %g3, jle_else.1877
	jne	%g8, %g3, jeq_else.1878
	mov	%g3, %g6
	return
jeq_else.1878:
	jmp	div_binary_search.333
jle_else.1877:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.333
jle_else.1856:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1879
	mov	%g3, %g7
	return
jle_else.1879:
	jlt	%g8, %g3, jle_else.1880
	jne	%g8, %g3, jeq_else.1881
	mov	%g3, %g5
	return
jeq_else.1881:
	add	%g6, %g7, %g5
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g5, %g7
	jlt	%g28, %g9, jle_else.1882
	mov	%g3, %g7
	return
jle_else.1882:
	jlt	%g8, %g3, jle_else.1883
	jne	%g8, %g3, jeq_else.1884
	mov	%g3, %g6
	return
jeq_else.1884:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1885
	mov	%g3, %g7
	return
jle_else.1885:
	jlt	%g8, %g3, jle_else.1886
	jne	%g8, %g3, jeq_else.1887
	mov	%g3, %g5
	return
jeq_else.1887:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.333
jle_else.1886:
	jmp	div_binary_search.333
jle_else.1883:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.1888
	mov	%g3, %g6
	return
jle_else.1888:
	jlt	%g8, %g3, jle_else.1889
	jne	%g8, %g3, jeq_else.1890
	mov	%g3, %g7
	return
jeq_else.1890:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.333
jle_else.1889:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.333
jle_else.1880:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1891
	mov	%g3, %g5
	return
jle_else.1891:
	jlt	%g8, %g3, jle_else.1892
	jne	%g8, %g3, jeq_else.1893
	mov	%g3, %g7
	return
jeq_else.1893:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1894
	mov	%g3, %g5
	return
jle_else.1894:
	jlt	%g8, %g3, jle_else.1895
	jne	%g8, %g3, jeq_else.1896
	mov	%g3, %g6
	return
jeq_else.1896:
	jmp	div_binary_search.333
jle_else.1895:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.333
jle_else.1892:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1897
	mov	%g3, %g7
	return
jle_else.1897:
	jlt	%g8, %g3, jle_else.1898
	jne	%g8, %g3, jeq_else.1899
	mov	%g3, %g5
	return
jeq_else.1899:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.333
jle_else.1898:
	jmp	div_binary_search.333
print_int.338:
	jlt	%g3, %g0, jge_else.1900
	mvhi	%g10, 1525
	mvlo	%g10, 57600
	jlt	%g10, %g3, jle_else.1901
	jne	%g10, %g3, jeq_else.1903
	addi	%g10, %g0, 1
	jmp	jeq_cont.1904
jeq_else.1903:
	addi	%g10, %g0, 0
jeq_cont.1904:
	jmp	jle_cont.1902
jle_else.1901:
	mvhi	%g10, 3051
	mvlo	%g10, 49664
	jlt	%g10, %g3, jle_else.1905
	jne	%g10, %g3, jeq_else.1907
	addi	%g10, %g0, 2
	jmp	jeq_cont.1908
jeq_else.1907:
	addi	%g10, %g0, 1
jeq_cont.1908:
	jmp	jle_cont.1906
jle_else.1905:
	addi	%g10, %g0, 2
jle_cont.1906:
jle_cont.1902:
	mvhi	%g11, 1525
	mvlo	%g11, 57600
	mul	%g11, %g10, %g11
	sub	%g3, %g3, %g11
	st	%g3, %g1, 0
	jlt	%g0, %g10, jle_else.1909
	addi	%g3, %g0, 0
	jmp	jle_cont.1910
jle_else.1909:
	addi	%g11, %g0, 48
	add	%g10, %g11, %g10
	output	%g10
	addi	%g3, %g0, 1
jle_cont.1910:
	mvhi	%g4, 152
	mvlo	%g4, 38528
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g10, %g0, 5
	mvhi	%g11, 762
	mvlo	%g11, 61568
	ld	%g12, %g1, 0
	st	%g3, %g1, 4
	jlt	%g11, %g12, jle_else.1911
	jne	%g11, %g12, jeq_else.1913
	addi	%g3, %g0, 5
	jmp	jeq_cont.1914
jeq_else.1913:
	addi	%g6, %g0, 2
	mvhi	%g11, 305
	mvlo	%g11, 11520
	jlt	%g11, %g12, jle_else.1915
	jne	%g11, %g12, jeq_else.1917
	addi	%g3, %g0, 2
	jmp	jeq_cont.1918
jeq_else.1917:
	addi	%g10, %g0, 1
	mvhi	%g11, 152
	mvlo	%g11, 38528
	jlt	%g11, %g12, jle_else.1919
	jne	%g11, %g12, jeq_else.1921
	addi	%g3, %g0, 1
	jmp	jeq_cont.1922
jeq_else.1921:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.333
	addi	%g1, %g1, 16
jeq_cont.1922:
	jmp	jle_cont.1920
jle_else.1919:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.333
	addi	%g1, %g1, 16
jle_cont.1920:
jeq_cont.1918:
	jmp	jle_cont.1916
jle_else.1915:
	addi	%g5, %g0, 3
	mvhi	%g11, 457
	mvlo	%g11, 50048
	jlt	%g11, %g12, jle_else.1923
	jne	%g11, %g12, jeq_else.1925
	addi	%g3, %g0, 3
	jmp	jeq_cont.1926
jeq_else.1925:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.333
	addi	%g1, %g1, 16
jeq_cont.1926:
	jmp	jle_cont.1924
jle_else.1923:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.333
	addi	%g1, %g1, 16
jle_cont.1924:
jle_cont.1916:
jeq_cont.1914:
	jmp	jle_cont.1912
jle_else.1911:
	addi	%g5, %g0, 7
	mvhi	%g11, 1068
	mvlo	%g11, 7552
	jlt	%g11, %g12, jle_else.1927
	jne	%g11, %g12, jeq_else.1929
	addi	%g3, %g0, 7
	jmp	jeq_cont.1930
jeq_else.1929:
	addi	%g6, %g0, 6
	mvhi	%g11, 915
	mvlo	%g11, 34560
	jlt	%g11, %g12, jle_else.1931
	jne	%g11, %g12, jeq_else.1933
	addi	%g3, %g0, 6
	jmp	jeq_cont.1934
jeq_else.1933:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.333
	addi	%g1, %g1, 16
jeq_cont.1934:
	jmp	jle_cont.1932
jle_else.1931:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.333
	addi	%g1, %g1, 16
jle_cont.1932:
jeq_cont.1930:
	jmp	jle_cont.1928
jle_else.1927:
	addi	%g10, %g0, 8
	mvhi	%g11, 1220
	mvlo	%g11, 46080
	jlt	%g11, %g12, jle_else.1935
	jne	%g11, %g12, jeq_else.1937
	addi	%g3, %g0, 8
	jmp	jeq_cont.1938
jeq_else.1937:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.333
	addi	%g1, %g1, 16
jeq_cont.1938:
	jmp	jle_cont.1936
jle_else.1935:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.333
	addi	%g1, %g1, 16
jle_cont.1936:
jle_cont.1928:
jle_cont.1912:
	mvhi	%g10, 152
	mvlo	%g10, 38528
	mul	%g10, %g3, %g10
	sub	%g10, %g12, %g10
	jlt	%g0, %g3, jle_else.1939
	ld	%g11, %g1, 4
	jne	%g11, %g0, jeq_else.1941
	addi	%g3, %g0, 0
	jmp	jeq_cont.1942
jeq_else.1941:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1942:
	jmp	jle_cont.1940
jle_else.1939:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1940:
	mvhi	%g4, 15
	mvlo	%g4, 16960
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 76
	mvlo	%g12, 19264
	st	%g3, %g1, 8
	jlt	%g12, %g10, jle_else.1943
	jne	%g12, %g10, jeq_else.1945
	addi	%g3, %g0, 5
	jmp	jeq_cont.1946
jeq_else.1945:
	addi	%g6, %g0, 2
	mvhi	%g12, 30
	mvlo	%g12, 33920
	jlt	%g12, %g10, jle_else.1947
	jne	%g12, %g10, jeq_else.1949
	addi	%g3, %g0, 2
	jmp	jeq_cont.1950
jeq_else.1949:
	addi	%g11, %g0, 1
	mvhi	%g12, 15
	mvlo	%g12, 16960
	jlt	%g12, %g10, jle_else.1951
	jne	%g12, %g10, jeq_else.1953
	addi	%g3, %g0, 1
	jmp	jeq_cont.1954
jeq_else.1953:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.333
	addi	%g1, %g1, 16
jeq_cont.1954:
	jmp	jle_cont.1952
jle_else.1951:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.333
	addi	%g1, %g1, 16
jle_cont.1952:
jeq_cont.1950:
	jmp	jle_cont.1948
jle_else.1947:
	addi	%g5, %g0, 3
	mvhi	%g12, 45
	mvlo	%g12, 50880
	jlt	%g12, %g10, jle_else.1955
	jne	%g12, %g10, jeq_else.1957
	addi	%g3, %g0, 3
	jmp	jeq_cont.1958
jeq_else.1957:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.333
	addi	%g1, %g1, 16
jeq_cont.1958:
	jmp	jle_cont.1956
jle_else.1955:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.333
	addi	%g1, %g1, 16
jle_cont.1956:
jle_cont.1948:
jeq_cont.1946:
	jmp	jle_cont.1944
jle_else.1943:
	addi	%g5, %g0, 7
	mvhi	%g12, 106
	mvlo	%g12, 53184
	jlt	%g12, %g10, jle_else.1959
	jne	%g12, %g10, jeq_else.1961
	addi	%g3, %g0, 7
	jmp	jeq_cont.1962
jeq_else.1961:
	addi	%g6, %g0, 6
	mvhi	%g12, 91
	mvlo	%g12, 36224
	jlt	%g12, %g10, jle_else.1963
	jne	%g12, %g10, jeq_else.1965
	addi	%g3, %g0, 6
	jmp	jeq_cont.1966
jeq_else.1965:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.333
	addi	%g1, %g1, 16
jeq_cont.1966:
	jmp	jle_cont.1964
jle_else.1963:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.333
	addi	%g1, %g1, 16
jle_cont.1964:
jeq_cont.1962:
	jmp	jle_cont.1960
jle_else.1959:
	addi	%g11, %g0, 8
	mvhi	%g12, 122
	mvlo	%g12, 4608
	jlt	%g12, %g10, jle_else.1967
	jne	%g12, %g10, jeq_else.1969
	addi	%g3, %g0, 8
	jmp	jeq_cont.1970
jeq_else.1969:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.333
	addi	%g1, %g1, 16
jeq_cont.1970:
	jmp	jle_cont.1968
jle_else.1967:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.333
	addi	%g1, %g1, 16
jle_cont.1968:
jle_cont.1960:
jle_cont.1944:
	mvhi	%g11, 15
	mvlo	%g11, 16960
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1971
	ld	%g11, %g1, 8
	jne	%g11, %g0, jeq_else.1973
	addi	%g3, %g0, 0
	jmp	jeq_cont.1974
jeq_else.1973:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1974:
	jmp	jle_cont.1972
jle_else.1971:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1972:
	mvhi	%g4, 1
	mvlo	%g4, 34464
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 7
	mvlo	%g12, 41248
	st	%g3, %g1, 12
	jlt	%g12, %g10, jle_else.1975
	jne	%g12, %g10, jeq_else.1977
	addi	%g3, %g0, 5
	jmp	jeq_cont.1978
jeq_else.1977:
	addi	%g6, %g0, 2
	mvhi	%g12, 3
	mvlo	%g12, 3392
	jlt	%g12, %g10, jle_else.1979
	jne	%g12, %g10, jeq_else.1981
	addi	%g3, %g0, 2
	jmp	jeq_cont.1982
jeq_else.1981:
	addi	%g11, %g0, 1
	mvhi	%g12, 1
	mvlo	%g12, 34464
	jlt	%g12, %g10, jle_else.1983
	jne	%g12, %g10, jeq_else.1985
	addi	%g3, %g0, 1
	jmp	jeq_cont.1986
jeq_else.1985:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.333
	addi	%g1, %g1, 24
jeq_cont.1986:
	jmp	jle_cont.1984
jle_else.1983:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.333
	addi	%g1, %g1, 24
jle_cont.1984:
jeq_cont.1982:
	jmp	jle_cont.1980
jle_else.1979:
	addi	%g5, %g0, 3
	mvhi	%g12, 4
	mvlo	%g12, 37856
	jlt	%g12, %g10, jle_else.1987
	jne	%g12, %g10, jeq_else.1989
	addi	%g3, %g0, 3
	jmp	jeq_cont.1990
jeq_else.1989:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.333
	addi	%g1, %g1, 24
jeq_cont.1990:
	jmp	jle_cont.1988
jle_else.1987:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.333
	addi	%g1, %g1, 24
jle_cont.1988:
jle_cont.1980:
jeq_cont.1978:
	jmp	jle_cont.1976
jle_else.1975:
	addi	%g5, %g0, 7
	mvhi	%g12, 10
	mvlo	%g12, 44640
	jlt	%g12, %g10, jle_else.1991
	jne	%g12, %g10, jeq_else.1993
	addi	%g3, %g0, 7
	jmp	jeq_cont.1994
jeq_else.1993:
	addi	%g6, %g0, 6
	mvhi	%g12, 9
	mvlo	%g12, 10176
	jlt	%g12, %g10, jle_else.1995
	jne	%g12, %g10, jeq_else.1997
	addi	%g3, %g0, 6
	jmp	jeq_cont.1998
jeq_else.1997:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.333
	addi	%g1, %g1, 24
jeq_cont.1998:
	jmp	jle_cont.1996
jle_else.1995:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.333
	addi	%g1, %g1, 24
jle_cont.1996:
jeq_cont.1994:
	jmp	jle_cont.1992
jle_else.1991:
	addi	%g11, %g0, 8
	mvhi	%g12, 12
	mvlo	%g12, 13568
	jlt	%g12, %g10, jle_else.1999
	jne	%g12, %g10, jeq_else.2001
	addi	%g3, %g0, 8
	jmp	jeq_cont.2002
jeq_else.2001:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.333
	addi	%g1, %g1, 24
jeq_cont.2002:
	jmp	jle_cont.2000
jle_else.1999:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.333
	addi	%g1, %g1, 24
jle_cont.2000:
jle_cont.1992:
jle_cont.1976:
	mvhi	%g11, 1
	mvlo	%g11, 34464
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2003
	ld	%g11, %g1, 12
	jne	%g11, %g0, jeq_else.2005
	addi	%g3, %g0, 0
	jmp	jeq_cont.2006
jeq_else.2005:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2006:
	jmp	jle_cont.2004
jle_else.2003:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2004:
	addi	%g4, %g0, 10000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 0
	mvlo	%g12, 50000
	st	%g3, %g1, 16
	jlt	%g12, %g10, jle_else.2007
	jne	%g12, %g10, jeq_else.2009
	addi	%g3, %g0, 5
	jmp	jeq_cont.2010
jeq_else.2009:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20000
	jlt	%g12, %g10, jle_else.2011
	jne	%g12, %g10, jeq_else.2013
	addi	%g3, %g0, 2
	jmp	jeq_cont.2014
jeq_else.2013:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10000
	jlt	%g12, %g10, jle_else.2015
	jne	%g12, %g10, jeq_else.2017
	addi	%g3, %g0, 1
	jmp	jeq_cont.2018
jeq_else.2017:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.333
	addi	%g1, %g1, 24
jeq_cont.2018:
	jmp	jle_cont.2016
jle_else.2015:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.333
	addi	%g1, %g1, 24
jle_cont.2016:
jeq_cont.2014:
	jmp	jle_cont.2012
jle_else.2011:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30000
	jlt	%g12, %g10, jle_else.2019
	jne	%g12, %g10, jeq_else.2021
	addi	%g3, %g0, 3
	jmp	jeq_cont.2022
jeq_else.2021:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.333
	addi	%g1, %g1, 24
jeq_cont.2022:
	jmp	jle_cont.2020
jle_else.2019:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.333
	addi	%g1, %g1, 24
jle_cont.2020:
jle_cont.2012:
jeq_cont.2010:
	jmp	jle_cont.2008
jle_else.2007:
	addi	%g5, %g0, 7
	mvhi	%g12, 1
	mvlo	%g12, 4464
	jlt	%g12, %g10, jle_else.2023
	jne	%g12, %g10, jeq_else.2025
	addi	%g3, %g0, 7
	jmp	jeq_cont.2026
jeq_else.2025:
	addi	%g6, %g0, 6
	mvhi	%g12, 0
	mvlo	%g12, 60000
	jlt	%g12, %g10, jle_else.2027
	jne	%g12, %g10, jeq_else.2029
	addi	%g3, %g0, 6
	jmp	jeq_cont.2030
jeq_else.2029:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.333
	addi	%g1, %g1, 24
jeq_cont.2030:
	jmp	jle_cont.2028
jle_else.2027:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.333
	addi	%g1, %g1, 24
jle_cont.2028:
jeq_cont.2026:
	jmp	jle_cont.2024
jle_else.2023:
	addi	%g11, %g0, 8
	mvhi	%g12, 1
	mvlo	%g12, 14464
	jlt	%g12, %g10, jle_else.2031
	jne	%g12, %g10, jeq_else.2033
	addi	%g3, %g0, 8
	jmp	jeq_cont.2034
jeq_else.2033:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.333
	addi	%g1, %g1, 24
jeq_cont.2034:
	jmp	jle_cont.2032
jle_else.2031:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.333
	addi	%g1, %g1, 24
jle_cont.2032:
jle_cont.2024:
jle_cont.2008:
	addi	%g11, %g0, 10000
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2035
	ld	%g11, %g1, 16
	jne	%g11, %g0, jeq_else.2037
	addi	%g3, %g0, 0
	jmp	jeq_cont.2038
jeq_else.2037:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2038:
	jmp	jle_cont.2036
jle_else.2035:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2036:
	addi	%g4, %g0, 1000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 5000
	st	%g3, %g1, 20
	jlt	%g12, %g10, jle_else.2039
	jne	%g12, %g10, jeq_else.2041
	addi	%g3, %g0, 5
	jmp	jeq_cont.2042
jeq_else.2041:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 2000
	jlt	%g12, %g10, jle_else.2043
	jne	%g12, %g10, jeq_else.2045
	addi	%g3, %g0, 2
	jmp	jeq_cont.2046
jeq_else.2045:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 1000
	jlt	%g12, %g10, jle_else.2047
	jne	%g12, %g10, jeq_else.2049
	addi	%g3, %g0, 1
	jmp	jeq_cont.2050
jeq_else.2049:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.333
	addi	%g1, %g1, 32
jeq_cont.2050:
	jmp	jle_cont.2048
jle_else.2047:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.333
	addi	%g1, %g1, 32
jle_cont.2048:
jeq_cont.2046:
	jmp	jle_cont.2044
jle_else.2043:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 3000
	jlt	%g12, %g10, jle_else.2051
	jne	%g12, %g10, jeq_else.2053
	addi	%g3, %g0, 3
	jmp	jeq_cont.2054
jeq_else.2053:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.333
	addi	%g1, %g1, 32
jeq_cont.2054:
	jmp	jle_cont.2052
jle_else.2051:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.333
	addi	%g1, %g1, 32
jle_cont.2052:
jle_cont.2044:
jeq_cont.2042:
	jmp	jle_cont.2040
jle_else.2039:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 7000
	jlt	%g12, %g10, jle_else.2055
	jne	%g12, %g10, jeq_else.2057
	addi	%g3, %g0, 7
	jmp	jeq_cont.2058
jeq_else.2057:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 6000
	jlt	%g12, %g10, jle_else.2059
	jne	%g12, %g10, jeq_else.2061
	addi	%g3, %g0, 6
	jmp	jeq_cont.2062
jeq_else.2061:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.333
	addi	%g1, %g1, 32
jeq_cont.2062:
	jmp	jle_cont.2060
jle_else.2059:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.333
	addi	%g1, %g1, 32
jle_cont.2060:
jeq_cont.2058:
	jmp	jle_cont.2056
jle_else.2055:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 8000
	jlt	%g12, %g10, jle_else.2063
	jne	%g12, %g10, jeq_else.2065
	addi	%g3, %g0, 8
	jmp	jeq_cont.2066
jeq_else.2065:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.333
	addi	%g1, %g1, 32
jeq_cont.2066:
	jmp	jle_cont.2064
jle_else.2063:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.333
	addi	%g1, %g1, 32
jle_cont.2064:
jle_cont.2056:
jle_cont.2040:
	muli	%g11, %g3, 1000
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2067
	ld	%g11, %g1, 20
	jne	%g11, %g0, jeq_else.2069
	addi	%g3, %g0, 0
	jmp	jeq_cont.2070
jeq_else.2069:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2070:
	jmp	jle_cont.2068
jle_else.2067:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2068:
	addi	%g4, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 500
	st	%g3, %g1, 24
	jlt	%g12, %g10, jle_else.2071
	jne	%g12, %g10, jeq_else.2073
	addi	%g3, %g0, 5
	jmp	jeq_cont.2074
jeq_else.2073:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 200
	jlt	%g12, %g10, jle_else.2075
	jne	%g12, %g10, jeq_else.2077
	addi	%g3, %g0, 2
	jmp	jeq_cont.2078
jeq_else.2077:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 100
	jlt	%g12, %g10, jle_else.2079
	jne	%g12, %g10, jeq_else.2081
	addi	%g3, %g0, 1
	jmp	jeq_cont.2082
jeq_else.2081:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.333
	addi	%g1, %g1, 32
jeq_cont.2082:
	jmp	jle_cont.2080
jle_else.2079:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.333
	addi	%g1, %g1, 32
jle_cont.2080:
jeq_cont.2078:
	jmp	jle_cont.2076
jle_else.2075:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 300
	jlt	%g12, %g10, jle_else.2083
	jne	%g12, %g10, jeq_else.2085
	addi	%g3, %g0, 3
	jmp	jeq_cont.2086
jeq_else.2085:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.333
	addi	%g1, %g1, 32
jeq_cont.2086:
	jmp	jle_cont.2084
jle_else.2083:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.333
	addi	%g1, %g1, 32
jle_cont.2084:
jle_cont.2076:
jeq_cont.2074:
	jmp	jle_cont.2072
jle_else.2071:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 700
	jlt	%g12, %g10, jle_else.2087
	jne	%g12, %g10, jeq_else.2089
	addi	%g3, %g0, 7
	jmp	jeq_cont.2090
jeq_else.2089:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 600
	jlt	%g12, %g10, jle_else.2091
	jne	%g12, %g10, jeq_else.2093
	addi	%g3, %g0, 6
	jmp	jeq_cont.2094
jeq_else.2093:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.333
	addi	%g1, %g1, 32
jeq_cont.2094:
	jmp	jle_cont.2092
jle_else.2091:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.333
	addi	%g1, %g1, 32
jle_cont.2092:
jeq_cont.2090:
	jmp	jle_cont.2088
jle_else.2087:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 800
	jlt	%g12, %g10, jle_else.2095
	jne	%g12, %g10, jeq_else.2097
	addi	%g3, %g0, 8
	jmp	jeq_cont.2098
jeq_else.2097:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.333
	addi	%g1, %g1, 32
jeq_cont.2098:
	jmp	jle_cont.2096
jle_else.2095:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.333
	addi	%g1, %g1, 32
jle_cont.2096:
jle_cont.2088:
jle_cont.2072:
	muli	%g11, %g3, 100
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2099
	ld	%g11, %g1, 24
	jne	%g11, %g0, jeq_else.2101
	addi	%g3, %g0, 0
	jmp	jeq_cont.2102
jeq_else.2101:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2102:
	jmp	jle_cont.2100
jle_else.2099:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2100:
	addi	%g4, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 50
	st	%g3, %g1, 28
	jlt	%g12, %g10, jle_else.2103
	jne	%g12, %g10, jeq_else.2105
	addi	%g3, %g0, 5
	jmp	jeq_cont.2106
jeq_else.2105:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20
	jlt	%g12, %g10, jle_else.2107
	jne	%g12, %g10, jeq_else.2109
	addi	%g3, %g0, 2
	jmp	jeq_cont.2110
jeq_else.2109:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10
	jlt	%g12, %g10, jle_else.2111
	jne	%g12, %g10, jeq_else.2113
	addi	%g3, %g0, 1
	jmp	jeq_cont.2114
jeq_else.2113:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.333
	addi	%g1, %g1, 40
jeq_cont.2114:
	jmp	jle_cont.2112
jle_else.2111:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.333
	addi	%g1, %g1, 40
jle_cont.2112:
jeq_cont.2110:
	jmp	jle_cont.2108
jle_else.2107:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30
	jlt	%g12, %g10, jle_else.2115
	jne	%g12, %g10, jeq_else.2117
	addi	%g3, %g0, 3
	jmp	jeq_cont.2118
jeq_else.2117:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.333
	addi	%g1, %g1, 40
jeq_cont.2118:
	jmp	jle_cont.2116
jle_else.2115:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.333
	addi	%g1, %g1, 40
jle_cont.2116:
jle_cont.2108:
jeq_cont.2106:
	jmp	jle_cont.2104
jle_else.2103:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 70
	jlt	%g12, %g10, jle_else.2119
	jne	%g12, %g10, jeq_else.2121
	addi	%g3, %g0, 7
	jmp	jeq_cont.2122
jeq_else.2121:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 60
	jlt	%g12, %g10, jle_else.2123
	jne	%g12, %g10, jeq_else.2125
	addi	%g3, %g0, 6
	jmp	jeq_cont.2126
jeq_else.2125:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.333
	addi	%g1, %g1, 40
jeq_cont.2126:
	jmp	jle_cont.2124
jle_else.2123:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.333
	addi	%g1, %g1, 40
jle_cont.2124:
jeq_cont.2122:
	jmp	jle_cont.2120
jle_else.2119:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 80
	jlt	%g12, %g10, jle_else.2127
	jne	%g12, %g10, jeq_else.2129
	addi	%g3, %g0, 8
	jmp	jeq_cont.2130
jeq_else.2129:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.333
	addi	%g1, %g1, 40
jeq_cont.2130:
	jmp	jle_cont.2128
jle_else.2127:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.333
	addi	%g1, %g1, 40
jle_cont.2128:
jle_cont.2120:
jle_cont.2104:
	muli	%g11, %g3, 10
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2131
	ld	%g11, %g1, 28
	jne	%g11, %g0, jeq_else.2133
	addi	%g3, %g0, 0
	jmp	jeq_cont.2134
jeq_else.2133:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2134:
	jmp	jle_cont.2132
jle_else.2131:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2132:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g10
	output	%g3
	return
jge_else.1900:
	addi	%g10, %g0, 45
	st	%g3, %g1, 32
	output	%g10
	ld	%g3, %g1, 32
	sub	%g3, %g0, %g3
	jmp	print_int.338
sum.340:
	jlt	%g0, %g4, jle_else.2135
	return
jle_else.2135:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2136
	return
jle_else.2136:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2137
	return
jle_else.2137:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2138
	return
jle_else.2138:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2139
	return
jle_else.2139:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2140
	return
jle_else.2140:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2141
	return
jle_else.2141:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2142
	return
jle_else.2142:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2143
	return
jle_else.2143:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2144
	return
jle_else.2144:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2145
	return
jle_else.2145:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2146
	return
jle_else.2146:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2147
	return
jle_else.2147:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2148
	return
jle_else.2148:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2149
	return
jle_else.2149:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2150
	return
jle_else.2150:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2151
	return
jle_else.2151:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2152
	return
jle_else.2152:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2153
	return
jle_else.2153:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2154
	return
jle_else.2154:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2155
	return
jle_else.2155:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2156
	return
jle_else.2156:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2157
	return
jle_else.2157:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2158
	return
jle_else.2158:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2159
	return
jle_else.2159:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2160
	return
jle_else.2160:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2161
	return
jle_else.2161:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2162
	return
jle_else.2162:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2163
	return
jle_else.2163:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2164
	return
jle_else.2164:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2165
	return
jle_else.2165:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jlt	%g0, %g4, jle_else.2166
	return
jle_else.2166:
	add	%g3, %g3, %g4
	subi	%g4, %g4, 1
	jmp	sum.340
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
	mvhi	%g3, 4
	mvlo	%g3, 47391
	addi	%g4, %g0, 9969
	subi	%g1, %g1, 8
	call	sum.340
	addi	%g1, %g1, 8
	subi	%g1, %g1, 8
	call	print_int.338
	addi	%g1, %g1, 8
	halt
