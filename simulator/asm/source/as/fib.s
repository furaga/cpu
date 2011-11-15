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
div_binary_search.335:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1853
	mov	%g3, %g5
	return
jle_else.1853:
	jlt	%g8, %g3, jle_else.1854
	jne	%g8, %g3, jeq_else.1855
	mov	%g3, %g7
	return
jeq_else.1855:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1856
	mov	%g3, %g5
	return
jle_else.1856:
	jlt	%g8, %g3, jle_else.1857
	jne	%g8, %g3, jeq_else.1858
	mov	%g3, %g6
	return
jeq_else.1858:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1859
	mov	%g3, %g5
	return
jle_else.1859:
	jlt	%g8, %g3, jle_else.1860
	jne	%g8, %g3, jeq_else.1861
	mov	%g3, %g7
	return
jeq_else.1861:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1862
	mov	%g3, %g5
	return
jle_else.1862:
	jlt	%g8, %g3, jle_else.1863
	jne	%g8, %g3, jeq_else.1864
	mov	%g3, %g6
	return
jeq_else.1864:
	jmp	div_binary_search.335
jle_else.1863:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.335
jle_else.1860:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1865
	mov	%g3, %g7
	return
jle_else.1865:
	jlt	%g8, %g3, jle_else.1866
	jne	%g8, %g3, jeq_else.1867
	mov	%g3, %g5
	return
jeq_else.1867:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.335
jle_else.1866:
	jmp	div_binary_search.335
jle_else.1857:
	add	%g5, %g6, %g7
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g7, %g6
	jlt	%g28, %g9, jle_else.1868
	mov	%g3, %g6
	return
jle_else.1868:
	jlt	%g8, %g3, jle_else.1869
	jne	%g8, %g3, jeq_else.1870
	mov	%g3, %g5
	return
jeq_else.1870:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.1871
	mov	%g3, %g6
	return
jle_else.1871:
	jlt	%g8, %g3, jle_else.1872
	jne	%g8, %g3, jeq_else.1873
	mov	%g3, %g7
	return
jeq_else.1873:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.335
jle_else.1872:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.335
jle_else.1869:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1874
	mov	%g3, %g5
	return
jle_else.1874:
	jlt	%g8, %g3, jle_else.1875
	jne	%g8, %g3, jeq_else.1876
	mov	%g3, %g6
	return
jeq_else.1876:
	jmp	div_binary_search.335
jle_else.1875:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.335
jle_else.1854:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1877
	mov	%g3, %g7
	return
jle_else.1877:
	jlt	%g8, %g3, jle_else.1878
	jne	%g8, %g3, jeq_else.1879
	mov	%g3, %g5
	return
jeq_else.1879:
	add	%g6, %g7, %g5
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g5, %g7
	jlt	%g28, %g9, jle_else.1880
	mov	%g3, %g7
	return
jle_else.1880:
	jlt	%g8, %g3, jle_else.1881
	jne	%g8, %g3, jeq_else.1882
	mov	%g3, %g6
	return
jeq_else.1882:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1883
	mov	%g3, %g7
	return
jle_else.1883:
	jlt	%g8, %g3, jle_else.1884
	jne	%g8, %g3, jeq_else.1885
	mov	%g3, %g5
	return
jeq_else.1885:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.335
jle_else.1884:
	jmp	div_binary_search.335
jle_else.1881:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.1886
	mov	%g3, %g6
	return
jle_else.1886:
	jlt	%g8, %g3, jle_else.1887
	jne	%g8, %g3, jeq_else.1888
	mov	%g3, %g7
	return
jeq_else.1888:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.335
jle_else.1887:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.335
jle_else.1878:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1889
	mov	%g3, %g5
	return
jle_else.1889:
	jlt	%g8, %g3, jle_else.1890
	jne	%g8, %g3, jeq_else.1891
	mov	%g3, %g7
	return
jeq_else.1891:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1892
	mov	%g3, %g5
	return
jle_else.1892:
	jlt	%g8, %g3, jle_else.1893
	jne	%g8, %g3, jeq_else.1894
	mov	%g3, %g6
	return
jeq_else.1894:
	jmp	div_binary_search.335
jle_else.1893:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.335
jle_else.1890:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1895
	mov	%g3, %g7
	return
jle_else.1895:
	jlt	%g8, %g3, jle_else.1896
	jne	%g8, %g3, jeq_else.1897
	mov	%g3, %g5
	return
jeq_else.1897:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.335
jle_else.1896:
	jmp	div_binary_search.335
print_int.340:
	jlt	%g3, %g0, jge_else.1898
	mvhi	%g10, 1525
	mvlo	%g10, 57600
	jlt	%g10, %g3, jle_else.1899
	jne	%g10, %g3, jeq_else.1901
	addi	%g10, %g0, 1
	jmp	jeq_cont.1902
jeq_else.1901:
	addi	%g10, %g0, 0
jeq_cont.1902:
	jmp	jle_cont.1900
jle_else.1899:
	mvhi	%g10, 3051
	mvlo	%g10, 49664
	jlt	%g10, %g3, jle_else.1903
	jne	%g10, %g3, jeq_else.1905
	addi	%g10, %g0, 2
	jmp	jeq_cont.1906
jeq_else.1905:
	addi	%g10, %g0, 1
jeq_cont.1906:
	jmp	jle_cont.1904
jle_else.1903:
	addi	%g10, %g0, 2
jle_cont.1904:
jle_cont.1900:
	mvhi	%g11, 1525
	mvlo	%g11, 57600
	mul	%g11, %g10, %g11
	sub	%g3, %g3, %g11
	st	%g3, %g1, 0
	jlt	%g0, %g10, jle_else.1907
	addi	%g3, %g0, 0
	jmp	jle_cont.1908
jle_else.1907:
	addi	%g11, %g0, 48
	add	%g10, %g11, %g10
	output	%g10
	addi	%g3, %g0, 1
jle_cont.1908:
	mvhi	%g4, 152
	mvlo	%g4, 38528
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g10, %g0, 5
	mvhi	%g11, 762
	mvlo	%g11, 61568
	ld	%g12, %g1, 0
	st	%g3, %g1, 4
	jlt	%g11, %g12, jle_else.1909
	jne	%g11, %g12, jeq_else.1911
	addi	%g3, %g0, 5
	jmp	jeq_cont.1912
jeq_else.1911:
	addi	%g6, %g0, 2
	mvhi	%g11, 305
	mvlo	%g11, 11520
	jlt	%g11, %g12, jle_else.1913
	jne	%g11, %g12, jeq_else.1915
	addi	%g3, %g0, 2
	jmp	jeq_cont.1916
jeq_else.1915:
	addi	%g10, %g0, 1
	mvhi	%g11, 152
	mvlo	%g11, 38528
	jlt	%g11, %g12, jle_else.1917
	jne	%g11, %g12, jeq_else.1919
	addi	%g3, %g0, 1
	jmp	jeq_cont.1920
jeq_else.1919:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jeq_cont.1920:
	jmp	jle_cont.1918
jle_else.1917:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jle_cont.1918:
jeq_cont.1916:
	jmp	jle_cont.1914
jle_else.1913:
	addi	%g5, %g0, 3
	mvhi	%g11, 457
	mvlo	%g11, 50048
	jlt	%g11, %g12, jle_else.1921
	jne	%g11, %g12, jeq_else.1923
	addi	%g3, %g0, 3
	jmp	jeq_cont.1924
jeq_else.1923:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jeq_cont.1924:
	jmp	jle_cont.1922
jle_else.1921:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jle_cont.1922:
jle_cont.1914:
jeq_cont.1912:
	jmp	jle_cont.1910
jle_else.1909:
	addi	%g5, %g0, 7
	mvhi	%g11, 1068
	mvlo	%g11, 7552
	jlt	%g11, %g12, jle_else.1925
	jne	%g11, %g12, jeq_else.1927
	addi	%g3, %g0, 7
	jmp	jeq_cont.1928
jeq_else.1927:
	addi	%g6, %g0, 6
	mvhi	%g11, 915
	mvlo	%g11, 34560
	jlt	%g11, %g12, jle_else.1929
	jne	%g11, %g12, jeq_else.1931
	addi	%g3, %g0, 6
	jmp	jeq_cont.1932
jeq_else.1931:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jeq_cont.1932:
	jmp	jle_cont.1930
jle_else.1929:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jle_cont.1930:
jeq_cont.1928:
	jmp	jle_cont.1926
jle_else.1925:
	addi	%g10, %g0, 8
	mvhi	%g11, 1220
	mvlo	%g11, 46080
	jlt	%g11, %g12, jle_else.1933
	jne	%g11, %g12, jeq_else.1935
	addi	%g3, %g0, 8
	jmp	jeq_cont.1936
jeq_else.1935:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jeq_cont.1936:
	jmp	jle_cont.1934
jle_else.1933:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jle_cont.1934:
jle_cont.1926:
jle_cont.1910:
	mvhi	%g10, 152
	mvlo	%g10, 38528
	mul	%g10, %g3, %g10
	sub	%g10, %g12, %g10
	jlt	%g0, %g3, jle_else.1937
	ld	%g11, %g1, 4
	jne	%g11, %g0, jeq_else.1939
	addi	%g3, %g0, 0
	jmp	jeq_cont.1940
jeq_else.1939:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1940:
	jmp	jle_cont.1938
jle_else.1937:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1938:
	mvhi	%g4, 15
	mvlo	%g4, 16960
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 76
	mvlo	%g12, 19264
	st	%g3, %g1, 8
	jlt	%g12, %g10, jle_else.1941
	jne	%g12, %g10, jeq_else.1943
	addi	%g3, %g0, 5
	jmp	jeq_cont.1944
jeq_else.1943:
	addi	%g6, %g0, 2
	mvhi	%g12, 30
	mvlo	%g12, 33920
	jlt	%g12, %g10, jle_else.1945
	jne	%g12, %g10, jeq_else.1947
	addi	%g3, %g0, 2
	jmp	jeq_cont.1948
jeq_else.1947:
	addi	%g11, %g0, 1
	mvhi	%g12, 15
	mvlo	%g12, 16960
	jlt	%g12, %g10, jle_else.1949
	jne	%g12, %g10, jeq_else.1951
	addi	%g3, %g0, 1
	jmp	jeq_cont.1952
jeq_else.1951:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jeq_cont.1952:
	jmp	jle_cont.1950
jle_else.1949:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jle_cont.1950:
jeq_cont.1948:
	jmp	jle_cont.1946
jle_else.1945:
	addi	%g5, %g0, 3
	mvhi	%g12, 45
	mvlo	%g12, 50880
	jlt	%g12, %g10, jle_else.1953
	jne	%g12, %g10, jeq_else.1955
	addi	%g3, %g0, 3
	jmp	jeq_cont.1956
jeq_else.1955:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jeq_cont.1956:
	jmp	jle_cont.1954
jle_else.1953:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jle_cont.1954:
jle_cont.1946:
jeq_cont.1944:
	jmp	jle_cont.1942
jle_else.1941:
	addi	%g5, %g0, 7
	mvhi	%g12, 106
	mvlo	%g12, 53184
	jlt	%g12, %g10, jle_else.1957
	jne	%g12, %g10, jeq_else.1959
	addi	%g3, %g0, 7
	jmp	jeq_cont.1960
jeq_else.1959:
	addi	%g6, %g0, 6
	mvhi	%g12, 91
	mvlo	%g12, 36224
	jlt	%g12, %g10, jle_else.1961
	jne	%g12, %g10, jeq_else.1963
	addi	%g3, %g0, 6
	jmp	jeq_cont.1964
jeq_else.1963:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jeq_cont.1964:
	jmp	jle_cont.1962
jle_else.1961:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jle_cont.1962:
jeq_cont.1960:
	jmp	jle_cont.1958
jle_else.1957:
	addi	%g11, %g0, 8
	mvhi	%g12, 122
	mvlo	%g12, 4608
	jlt	%g12, %g10, jle_else.1965
	jne	%g12, %g10, jeq_else.1967
	addi	%g3, %g0, 8
	jmp	jeq_cont.1968
jeq_else.1967:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jeq_cont.1968:
	jmp	jle_cont.1966
jle_else.1965:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jle_cont.1966:
jle_cont.1958:
jle_cont.1942:
	mvhi	%g11, 15
	mvlo	%g11, 16960
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1969
	ld	%g11, %g1, 8
	jne	%g11, %g0, jeq_else.1971
	addi	%g3, %g0, 0
	jmp	jeq_cont.1972
jeq_else.1971:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1972:
	jmp	jle_cont.1970
jle_else.1969:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1970:
	mvhi	%g4, 1
	mvlo	%g4, 34464
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 7
	mvlo	%g12, 41248
	st	%g3, %g1, 12
	jlt	%g12, %g10, jle_else.1973
	jne	%g12, %g10, jeq_else.1975
	addi	%g3, %g0, 5
	jmp	jeq_cont.1976
jeq_else.1975:
	addi	%g6, %g0, 2
	mvhi	%g12, 3
	mvlo	%g12, 3392
	jlt	%g12, %g10, jle_else.1977
	jne	%g12, %g10, jeq_else.1979
	addi	%g3, %g0, 2
	jmp	jeq_cont.1980
jeq_else.1979:
	addi	%g11, %g0, 1
	mvhi	%g12, 1
	mvlo	%g12, 34464
	jlt	%g12, %g10, jle_else.1981
	jne	%g12, %g10, jeq_else.1983
	addi	%g3, %g0, 1
	jmp	jeq_cont.1984
jeq_else.1983:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jeq_cont.1984:
	jmp	jle_cont.1982
jle_else.1981:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jle_cont.1982:
jeq_cont.1980:
	jmp	jle_cont.1978
jle_else.1977:
	addi	%g5, %g0, 3
	mvhi	%g12, 4
	mvlo	%g12, 37856
	jlt	%g12, %g10, jle_else.1985
	jne	%g12, %g10, jeq_else.1987
	addi	%g3, %g0, 3
	jmp	jeq_cont.1988
jeq_else.1987:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jeq_cont.1988:
	jmp	jle_cont.1986
jle_else.1985:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jle_cont.1986:
jle_cont.1978:
jeq_cont.1976:
	jmp	jle_cont.1974
jle_else.1973:
	addi	%g5, %g0, 7
	mvhi	%g12, 10
	mvlo	%g12, 44640
	jlt	%g12, %g10, jle_else.1989
	jne	%g12, %g10, jeq_else.1991
	addi	%g3, %g0, 7
	jmp	jeq_cont.1992
jeq_else.1991:
	addi	%g6, %g0, 6
	mvhi	%g12, 9
	mvlo	%g12, 10176
	jlt	%g12, %g10, jle_else.1993
	jne	%g12, %g10, jeq_else.1995
	addi	%g3, %g0, 6
	jmp	jeq_cont.1996
jeq_else.1995:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jeq_cont.1996:
	jmp	jle_cont.1994
jle_else.1993:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jle_cont.1994:
jeq_cont.1992:
	jmp	jle_cont.1990
jle_else.1989:
	addi	%g11, %g0, 8
	mvhi	%g12, 12
	mvlo	%g12, 13568
	jlt	%g12, %g10, jle_else.1997
	jne	%g12, %g10, jeq_else.1999
	addi	%g3, %g0, 8
	jmp	jeq_cont.2000
jeq_else.1999:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jeq_cont.2000:
	jmp	jle_cont.1998
jle_else.1997:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jle_cont.1998:
jle_cont.1990:
jle_cont.1974:
	mvhi	%g11, 1
	mvlo	%g11, 34464
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2001
	ld	%g11, %g1, 12
	jne	%g11, %g0, jeq_else.2003
	addi	%g3, %g0, 0
	jmp	jeq_cont.2004
jeq_else.2003:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2004:
	jmp	jle_cont.2002
jle_else.2001:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2002:
	addi	%g4, %g0, 10000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 0
	mvlo	%g12, 50000
	st	%g3, %g1, 16
	jlt	%g12, %g10, jle_else.2005
	jne	%g12, %g10, jeq_else.2007
	addi	%g3, %g0, 5
	jmp	jeq_cont.2008
jeq_else.2007:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20000
	jlt	%g12, %g10, jle_else.2009
	jne	%g12, %g10, jeq_else.2011
	addi	%g3, %g0, 2
	jmp	jeq_cont.2012
jeq_else.2011:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10000
	jlt	%g12, %g10, jle_else.2013
	jne	%g12, %g10, jeq_else.2015
	addi	%g3, %g0, 1
	jmp	jeq_cont.2016
jeq_else.2015:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jeq_cont.2016:
	jmp	jle_cont.2014
jle_else.2013:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jle_cont.2014:
jeq_cont.2012:
	jmp	jle_cont.2010
jle_else.2009:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30000
	jlt	%g12, %g10, jle_else.2017
	jne	%g12, %g10, jeq_else.2019
	addi	%g3, %g0, 3
	jmp	jeq_cont.2020
jeq_else.2019:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jeq_cont.2020:
	jmp	jle_cont.2018
jle_else.2017:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jle_cont.2018:
jle_cont.2010:
jeq_cont.2008:
	jmp	jle_cont.2006
jle_else.2005:
	addi	%g5, %g0, 7
	mvhi	%g12, 1
	mvlo	%g12, 4464
	jlt	%g12, %g10, jle_else.2021
	jne	%g12, %g10, jeq_else.2023
	addi	%g3, %g0, 7
	jmp	jeq_cont.2024
jeq_else.2023:
	addi	%g6, %g0, 6
	mvhi	%g12, 0
	mvlo	%g12, 60000
	jlt	%g12, %g10, jle_else.2025
	jne	%g12, %g10, jeq_else.2027
	addi	%g3, %g0, 6
	jmp	jeq_cont.2028
jeq_else.2027:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jeq_cont.2028:
	jmp	jle_cont.2026
jle_else.2025:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jle_cont.2026:
jeq_cont.2024:
	jmp	jle_cont.2022
jle_else.2021:
	addi	%g11, %g0, 8
	mvhi	%g12, 1
	mvlo	%g12, 14464
	jlt	%g12, %g10, jle_else.2029
	jne	%g12, %g10, jeq_else.2031
	addi	%g3, %g0, 8
	jmp	jeq_cont.2032
jeq_else.2031:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jeq_cont.2032:
	jmp	jle_cont.2030
jle_else.2029:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jle_cont.2030:
jle_cont.2022:
jle_cont.2006:
	addi	%g11, %g0, 10000
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2033
	ld	%g11, %g1, 16
	jne	%g11, %g0, jeq_else.2035
	addi	%g3, %g0, 0
	jmp	jeq_cont.2036
jeq_else.2035:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2036:
	jmp	jle_cont.2034
jle_else.2033:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2034:
	addi	%g4, %g0, 1000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 5000
	st	%g3, %g1, 20
	jlt	%g12, %g10, jle_else.2037
	jne	%g12, %g10, jeq_else.2039
	addi	%g3, %g0, 5
	jmp	jeq_cont.2040
jeq_else.2039:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 2000
	jlt	%g12, %g10, jle_else.2041
	jne	%g12, %g10, jeq_else.2043
	addi	%g3, %g0, 2
	jmp	jeq_cont.2044
jeq_else.2043:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 1000
	jlt	%g12, %g10, jle_else.2045
	jne	%g12, %g10, jeq_else.2047
	addi	%g3, %g0, 1
	jmp	jeq_cont.2048
jeq_else.2047:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jeq_cont.2048:
	jmp	jle_cont.2046
jle_else.2045:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jle_cont.2046:
jeq_cont.2044:
	jmp	jle_cont.2042
jle_else.2041:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 3000
	jlt	%g12, %g10, jle_else.2049
	jne	%g12, %g10, jeq_else.2051
	addi	%g3, %g0, 3
	jmp	jeq_cont.2052
jeq_else.2051:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jeq_cont.2052:
	jmp	jle_cont.2050
jle_else.2049:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jle_cont.2050:
jle_cont.2042:
jeq_cont.2040:
	jmp	jle_cont.2038
jle_else.2037:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 7000
	jlt	%g12, %g10, jle_else.2053
	jne	%g12, %g10, jeq_else.2055
	addi	%g3, %g0, 7
	jmp	jeq_cont.2056
jeq_else.2055:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 6000
	jlt	%g12, %g10, jle_else.2057
	jne	%g12, %g10, jeq_else.2059
	addi	%g3, %g0, 6
	jmp	jeq_cont.2060
jeq_else.2059:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jeq_cont.2060:
	jmp	jle_cont.2058
jle_else.2057:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jle_cont.2058:
jeq_cont.2056:
	jmp	jle_cont.2054
jle_else.2053:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 8000
	jlt	%g12, %g10, jle_else.2061
	jne	%g12, %g10, jeq_else.2063
	addi	%g3, %g0, 8
	jmp	jeq_cont.2064
jeq_else.2063:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jeq_cont.2064:
	jmp	jle_cont.2062
jle_else.2061:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jle_cont.2062:
jle_cont.2054:
jle_cont.2038:
	muli	%g11, %g3, 1000
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2065
	ld	%g11, %g1, 20
	jne	%g11, %g0, jeq_else.2067
	addi	%g3, %g0, 0
	jmp	jeq_cont.2068
jeq_else.2067:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2068:
	jmp	jle_cont.2066
jle_else.2065:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2066:
	addi	%g4, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 500
	st	%g3, %g1, 24
	jlt	%g12, %g10, jle_else.2069
	jne	%g12, %g10, jeq_else.2071
	addi	%g3, %g0, 5
	jmp	jeq_cont.2072
jeq_else.2071:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 200
	jlt	%g12, %g10, jle_else.2073
	jne	%g12, %g10, jeq_else.2075
	addi	%g3, %g0, 2
	jmp	jeq_cont.2076
jeq_else.2075:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 100
	jlt	%g12, %g10, jle_else.2077
	jne	%g12, %g10, jeq_else.2079
	addi	%g3, %g0, 1
	jmp	jeq_cont.2080
jeq_else.2079:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jeq_cont.2080:
	jmp	jle_cont.2078
jle_else.2077:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jle_cont.2078:
jeq_cont.2076:
	jmp	jle_cont.2074
jle_else.2073:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 300
	jlt	%g12, %g10, jle_else.2081
	jne	%g12, %g10, jeq_else.2083
	addi	%g3, %g0, 3
	jmp	jeq_cont.2084
jeq_else.2083:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jeq_cont.2084:
	jmp	jle_cont.2082
jle_else.2081:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jle_cont.2082:
jle_cont.2074:
jeq_cont.2072:
	jmp	jle_cont.2070
jle_else.2069:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 700
	jlt	%g12, %g10, jle_else.2085
	jne	%g12, %g10, jeq_else.2087
	addi	%g3, %g0, 7
	jmp	jeq_cont.2088
jeq_else.2087:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 600
	jlt	%g12, %g10, jle_else.2089
	jne	%g12, %g10, jeq_else.2091
	addi	%g3, %g0, 6
	jmp	jeq_cont.2092
jeq_else.2091:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jeq_cont.2092:
	jmp	jle_cont.2090
jle_else.2089:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jle_cont.2090:
jeq_cont.2088:
	jmp	jle_cont.2086
jle_else.2085:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 800
	jlt	%g12, %g10, jle_else.2093
	jne	%g12, %g10, jeq_else.2095
	addi	%g3, %g0, 8
	jmp	jeq_cont.2096
jeq_else.2095:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jeq_cont.2096:
	jmp	jle_cont.2094
jle_else.2093:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jle_cont.2094:
jle_cont.2086:
jle_cont.2070:
	muli	%g11, %g3, 100
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2097
	ld	%g11, %g1, 24
	jne	%g11, %g0, jeq_else.2099
	addi	%g3, %g0, 0
	jmp	jeq_cont.2100
jeq_else.2099:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2100:
	jmp	jle_cont.2098
jle_else.2097:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2098:
	addi	%g4, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 50
	st	%g3, %g1, 28
	jlt	%g12, %g10, jle_else.2101
	jne	%g12, %g10, jeq_else.2103
	addi	%g3, %g0, 5
	jmp	jeq_cont.2104
jeq_else.2103:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20
	jlt	%g12, %g10, jle_else.2105
	jne	%g12, %g10, jeq_else.2107
	addi	%g3, %g0, 2
	jmp	jeq_cont.2108
jeq_else.2107:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10
	jlt	%g12, %g10, jle_else.2109
	jne	%g12, %g10, jeq_else.2111
	addi	%g3, %g0, 1
	jmp	jeq_cont.2112
jeq_else.2111:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.335
	addi	%g1, %g1, 40
jeq_cont.2112:
	jmp	jle_cont.2110
jle_else.2109:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.335
	addi	%g1, %g1, 40
jle_cont.2110:
jeq_cont.2108:
	jmp	jle_cont.2106
jle_else.2105:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30
	jlt	%g12, %g10, jle_else.2113
	jne	%g12, %g10, jeq_else.2115
	addi	%g3, %g0, 3
	jmp	jeq_cont.2116
jeq_else.2115:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.335
	addi	%g1, %g1, 40
jeq_cont.2116:
	jmp	jle_cont.2114
jle_else.2113:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.335
	addi	%g1, %g1, 40
jle_cont.2114:
jle_cont.2106:
jeq_cont.2104:
	jmp	jle_cont.2102
jle_else.2101:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 70
	jlt	%g12, %g10, jle_else.2117
	jne	%g12, %g10, jeq_else.2119
	addi	%g3, %g0, 7
	jmp	jeq_cont.2120
jeq_else.2119:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 60
	jlt	%g12, %g10, jle_else.2121
	jne	%g12, %g10, jeq_else.2123
	addi	%g3, %g0, 6
	jmp	jeq_cont.2124
jeq_else.2123:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.335
	addi	%g1, %g1, 40
jeq_cont.2124:
	jmp	jle_cont.2122
jle_else.2121:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.335
	addi	%g1, %g1, 40
jle_cont.2122:
jeq_cont.2120:
	jmp	jle_cont.2118
jle_else.2117:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 80
	jlt	%g12, %g10, jle_else.2125
	jne	%g12, %g10, jeq_else.2127
	addi	%g3, %g0, 8
	jmp	jeq_cont.2128
jeq_else.2127:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.335
	addi	%g1, %g1, 40
jeq_cont.2128:
	jmp	jle_cont.2126
jle_else.2125:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.335
	addi	%g1, %g1, 40
jle_cont.2126:
jle_cont.2118:
jle_cont.2102:
	muli	%g11, %g3, 10
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2129
	ld	%g11, %g1, 28
	jne	%g11, %g0, jeq_else.2131
	addi	%g3, %g0, 0
	jmp	jeq_cont.2132
jeq_else.2131:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2132:
	jmp	jle_cont.2130
jle_else.2129:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2130:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g10
	output	%g3
	return
jge_else.1898:
	addi	%g10, %g0, 45
	st	%g3, %g1, 32
	output	%g10
	ld	%g3, %g1, 32
	sub	%g3, %g0, %g3
	jmp	print_int.340
fib.342:
	jlt	%g28, %g3, jle_else.2133
	return
jle_else.2133:
	subi	%g4, %g3, 1
	st	%g3, %g1, 0
	jlt	%g28, %g4, jle_else.2134
	mov	%g3, %g4
	jmp	jle_cont.2135
jle_else.2134:
	subi	%g5, %g4, 1
	st	%g4, %g1, 4
	jlt	%g28, %g5, jle_else.2136
	mov	%g3, %g5
	jmp	jle_cont.2137
jle_else.2136:
	subi	%g6, %g5, 1
	st	%g5, %g1, 8
	jlt	%g28, %g6, jle_else.2138
	mov	%g3, %g6
	jmp	jle_cont.2139
jle_else.2138:
	subi	%g7, %g6, 1
	st	%g6, %g1, 12
	mov	%g3, %g7
	subi	%g1, %g1, 24
	call	fib.342
	addi	%g1, %g1, 24
	ld	%g4, %g1, 12
	subi	%g4, %g4, 2
	st	%g3, %g1, 16
	mov	%g3, %g4
	subi	%g1, %g1, 24
	call	fib.342
	addi	%g1, %g1, 24
	ld	%g4, %g1, 16
	add	%g3, %g4, %g3
jle_cont.2139:
	ld	%g4, %g1, 8
	subi	%g4, %g4, 2
	st	%g3, %g1, 20
	jlt	%g28, %g4, jle_else.2140
	mov	%g3, %g4
	jmp	jle_cont.2141
jle_else.2140:
	subi	%g5, %g4, 1
	st	%g4, %g1, 24
	mov	%g3, %g5
	subi	%g1, %g1, 32
	call	fib.342
	addi	%g1, %g1, 32
	ld	%g4, %g1, 24
	subi	%g4, %g4, 2
	st	%g3, %g1, 28
	mov	%g3, %g4
	subi	%g1, %g1, 40
	call	fib.342
	addi	%g1, %g1, 40
	ld	%g4, %g1, 28
	add	%g3, %g4, %g3
jle_cont.2141:
	ld	%g4, %g1, 20
	add	%g3, %g4, %g3
jle_cont.2137:
	ld	%g4, %g1, 4
	subi	%g4, %g4, 2
	st	%g3, %g1, 32
	jlt	%g28, %g4, jle_else.2142
	mov	%g3, %g4
	jmp	jle_cont.2143
jle_else.2142:
	subi	%g5, %g4, 1
	st	%g4, %g1, 36
	jlt	%g28, %g5, jle_else.2144
	mov	%g3, %g5
	jmp	jle_cont.2145
jle_else.2144:
	subi	%g6, %g5, 1
	st	%g5, %g1, 40
	mov	%g3, %g6
	subi	%g1, %g1, 48
	call	fib.342
	addi	%g1, %g1, 48
	ld	%g4, %g1, 40
	subi	%g4, %g4, 2
	st	%g3, %g1, 44
	mov	%g3, %g4
	subi	%g1, %g1, 56
	call	fib.342
	addi	%g1, %g1, 56
	ld	%g4, %g1, 44
	add	%g3, %g4, %g3
jle_cont.2145:
	ld	%g4, %g1, 36
	subi	%g4, %g4, 2
	st	%g3, %g1, 48
	jlt	%g28, %g4, jle_else.2146
	mov	%g3, %g4
	jmp	jle_cont.2147
jle_else.2146:
	subi	%g5, %g4, 1
	st	%g4, %g1, 52
	mov	%g3, %g5
	subi	%g1, %g1, 64
	call	fib.342
	addi	%g1, %g1, 64
	ld	%g4, %g1, 52
	subi	%g4, %g4, 2
	st	%g3, %g1, 56
	mov	%g3, %g4
	subi	%g1, %g1, 64
	call	fib.342
	addi	%g1, %g1, 64
	ld	%g4, %g1, 56
	add	%g3, %g4, %g3
jle_cont.2147:
	ld	%g4, %g1, 48
	add	%g3, %g4, %g3
jle_cont.2143:
	ld	%g4, %g1, 32
	add	%g3, %g4, %g3
jle_cont.2135:
	ld	%g4, %g1, 0
	subi	%g4, %g4, 2
	st	%g3, %g1, 60
	jlt	%g28, %g4, jle_else.2148
	mov	%g3, %g4
	jmp	jle_cont.2149
jle_else.2148:
	subi	%g5, %g4, 1
	st	%g4, %g1, 64
	jlt	%g28, %g5, jle_else.2150
	mov	%g3, %g5
	jmp	jle_cont.2151
jle_else.2150:
	subi	%g6, %g5, 1
	st	%g5, %g1, 68
	jlt	%g28, %g6, jle_else.2152
	mov	%g3, %g6
	jmp	jle_cont.2153
jle_else.2152:
	subi	%g7, %g6, 1
	st	%g6, %g1, 72
	mov	%g3, %g7
	subi	%g1, %g1, 80
	call	fib.342
	addi	%g1, %g1, 80
	ld	%g4, %g1, 72
	subi	%g4, %g4, 2
	st	%g3, %g1, 76
	mov	%g3, %g4
	subi	%g1, %g1, 88
	call	fib.342
	addi	%g1, %g1, 88
	ld	%g4, %g1, 76
	add	%g3, %g4, %g3
jle_cont.2153:
	ld	%g4, %g1, 68
	subi	%g4, %g4, 2
	st	%g3, %g1, 80
	jlt	%g28, %g4, jle_else.2154
	mov	%g3, %g4
	jmp	jle_cont.2155
jle_else.2154:
	subi	%g5, %g4, 1
	st	%g4, %g1, 84
	mov	%g3, %g5
	subi	%g1, %g1, 96
	call	fib.342
	addi	%g1, %g1, 96
	ld	%g4, %g1, 84
	subi	%g4, %g4, 2
	st	%g3, %g1, 88
	mov	%g3, %g4
	subi	%g1, %g1, 96
	call	fib.342
	addi	%g1, %g1, 96
	ld	%g4, %g1, 88
	add	%g3, %g4, %g3
jle_cont.2155:
	ld	%g4, %g1, 80
	add	%g3, %g4, %g3
jle_cont.2151:
	ld	%g4, %g1, 64
	subi	%g4, %g4, 2
	st	%g3, %g1, 92
	jlt	%g28, %g4, jle_else.2156
	mov	%g3, %g4
	jmp	jle_cont.2157
jle_else.2156:
	subi	%g5, %g4, 1
	st	%g4, %g1, 96
	jlt	%g28, %g5, jle_else.2158
	mov	%g3, %g5
	jmp	jle_cont.2159
jle_else.2158:
	subi	%g6, %g5, 1
	st	%g5, %g1, 100
	mov	%g3, %g6
	subi	%g1, %g1, 112
	call	fib.342
	addi	%g1, %g1, 112
	ld	%g4, %g1, 100
	subi	%g4, %g4, 2
	st	%g3, %g1, 104
	mov	%g3, %g4
	subi	%g1, %g1, 112
	call	fib.342
	addi	%g1, %g1, 112
	ld	%g4, %g1, 104
	add	%g3, %g4, %g3
jle_cont.2159:
	ld	%g4, %g1, 96
	subi	%g4, %g4, 2
	st	%g3, %g1, 108
	jlt	%g28, %g4, jle_else.2160
	mov	%g3, %g4
	jmp	jle_cont.2161
jle_else.2160:
	subi	%g5, %g4, 1
	st	%g4, %g1, 112
	mov	%g3, %g5
	subi	%g1, %g1, 120
	call	fib.342
	addi	%g1, %g1, 120
	ld	%g4, %g1, 112
	subi	%g4, %g4, 2
	st	%g3, %g1, 116
	mov	%g3, %g4
	subi	%g1, %g1, 128
	call	fib.342
	addi	%g1, %g1, 128
	ld	%g4, %g1, 116
	add	%g3, %g4, %g3
jle_cont.2161:
	ld	%g4, %g1, 108
	add	%g3, %g4, %g3
jle_cont.2157:
	ld	%g4, %g1, 92
	add	%g3, %g4, %g3
jle_cont.2149:
	ld	%g4, %g1, 60
	add	%g3, %g4, %g3
	return
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
	addi	%g3, %g0, 27
	subi	%g1, %g1, 8
	call	fib.342
	addi	%g1, %g1, 8
	addi	%g10, %g0, 26
	st	%g3, %g1, 0
	mov	%g3, %g10
	subi	%g1, %g1, 8
	call	fib.342
	addi	%g1, %g1, 8
	ld	%g10, %g1, 0
	add	%g10, %g10, %g3
	addi	%g11, %g0, 25
	st	%g3, %g1, 4
	mov	%g3, %g11
	subi	%g1, %g1, 16
	call	fib.342
	addi	%g1, %g1, 16
	ld	%g11, %g1, 4
	add	%g11, %g11, %g3
	add	%g10, %g10, %g11
	addi	%g12, %g0, 24
	st	%g3, %g1, 8
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	fib.342
	addi	%g1, %g1, 16
	ld	%g13, %g1, 8
	add	%g3, %g13, %g3
	add	%g3, %g11, %g3
	add	%g3, %g10, %g3
	subi	%g1, %g1, 16
	call	print_int.340
	addi	%g1, %g1, 16
	halt
