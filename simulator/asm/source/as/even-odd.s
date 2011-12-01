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
div_binary_search.337:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1814
	mov	%g3, %g5
	return
jle_else.1814:
	jlt	%g8, %g3, jle_else.1815
	jne	%g8, %g3, jeq_else.1816
	mov	%g3, %g7
	return
jeq_else.1816:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1817
	mov	%g3, %g5
	return
jle_else.1817:
	jlt	%g8, %g3, jle_else.1818
	jne	%g8, %g3, jeq_else.1819
	mov	%g3, %g6
	return
jeq_else.1819:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1820
	mov	%g3, %g5
	return
jle_else.1820:
	jlt	%g8, %g3, jle_else.1821
	jne	%g8, %g3, jeq_else.1822
	mov	%g3, %g7
	return
jeq_else.1822:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1823
	mov	%g3, %g5
	return
jle_else.1823:
	jlt	%g8, %g3, jle_else.1824
	jne	%g8, %g3, jeq_else.1825
	mov	%g3, %g6
	return
jeq_else.1825:
	jmp	div_binary_search.337
jle_else.1824:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.337
jle_else.1821:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1826
	mov	%g3, %g7
	return
jle_else.1826:
	jlt	%g8, %g3, jle_else.1827
	jne	%g8, %g3, jeq_else.1828
	mov	%g3, %g5
	return
jeq_else.1828:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.337
jle_else.1827:
	jmp	div_binary_search.337
jle_else.1818:
	add	%g5, %g6, %g7
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g7, %g6
	jlt	%g28, %g9, jle_else.1829
	mov	%g3, %g6
	return
jle_else.1829:
	jlt	%g8, %g3, jle_else.1830
	jne	%g8, %g3, jeq_else.1831
	mov	%g3, %g5
	return
jeq_else.1831:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.1832
	mov	%g3, %g6
	return
jle_else.1832:
	jlt	%g8, %g3, jle_else.1833
	jne	%g8, %g3, jeq_else.1834
	mov	%g3, %g7
	return
jeq_else.1834:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.337
jle_else.1833:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.337
jle_else.1830:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1835
	mov	%g3, %g5
	return
jle_else.1835:
	jlt	%g8, %g3, jle_else.1836
	jne	%g8, %g3, jeq_else.1837
	mov	%g3, %g6
	return
jeq_else.1837:
	jmp	div_binary_search.337
jle_else.1836:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.337
jle_else.1815:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1838
	mov	%g3, %g7
	return
jle_else.1838:
	jlt	%g8, %g3, jle_else.1839
	jne	%g8, %g3, jeq_else.1840
	mov	%g3, %g5
	return
jeq_else.1840:
	add	%g6, %g7, %g5
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g5, %g7
	jlt	%g28, %g9, jle_else.1841
	mov	%g3, %g7
	return
jle_else.1841:
	jlt	%g8, %g3, jle_else.1842
	jne	%g8, %g3, jeq_else.1843
	mov	%g3, %g6
	return
jeq_else.1843:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1844
	mov	%g3, %g7
	return
jle_else.1844:
	jlt	%g8, %g3, jle_else.1845
	jne	%g8, %g3, jeq_else.1846
	mov	%g3, %g5
	return
jeq_else.1846:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.337
jle_else.1845:
	jmp	div_binary_search.337
jle_else.1842:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.1847
	mov	%g3, %g6
	return
jle_else.1847:
	jlt	%g8, %g3, jle_else.1848
	jne	%g8, %g3, jeq_else.1849
	mov	%g3, %g7
	return
jeq_else.1849:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.337
jle_else.1848:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.337
jle_else.1839:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1850
	mov	%g3, %g5
	return
jle_else.1850:
	jlt	%g8, %g3, jle_else.1851
	jne	%g8, %g3, jeq_else.1852
	mov	%g3, %g7
	return
jeq_else.1852:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1853
	mov	%g3, %g5
	return
jle_else.1853:
	jlt	%g8, %g3, jle_else.1854
	jne	%g8, %g3, jeq_else.1855
	mov	%g3, %g6
	return
jeq_else.1855:
	jmp	div_binary_search.337
jle_else.1854:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.337
jle_else.1851:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1856
	mov	%g3, %g7
	return
jle_else.1856:
	jlt	%g8, %g3, jle_else.1857
	jne	%g8, %g3, jeq_else.1858
	mov	%g3, %g5
	return
jeq_else.1858:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.337
jle_else.1857:
	jmp	div_binary_search.337
print_int.342:
	jlt	%g3, %g0, jge_else.1859
	mvhi	%g10, 1525
	mvlo	%g10, 57600
	jlt	%g10, %g3, jle_else.1860
	jne	%g10, %g3, jeq_else.1862
	addi	%g10, %g0, 1
	jmp	jeq_cont.1863
jeq_else.1862:
	addi	%g10, %g0, 0
jeq_cont.1863:
	jmp	jle_cont.1861
jle_else.1860:
	mvhi	%g10, 3051
	mvlo	%g10, 49664
	jlt	%g10, %g3, jle_else.1864
	jne	%g10, %g3, jeq_else.1866
	addi	%g10, %g0, 2
	jmp	jeq_cont.1867
jeq_else.1866:
	addi	%g10, %g0, 1
jeq_cont.1867:
	jmp	jle_cont.1865
jle_else.1864:
	addi	%g10, %g0, 2
jle_cont.1865:
jle_cont.1861:
	mvhi	%g11, 1525
	mvlo	%g11, 57600
	mul	%g11, %g10, %g11
	sub	%g3, %g3, %g11
	st	%g3, %g1, 0
	jlt	%g0, %g10, jle_else.1868
	addi	%g3, %g0, 0
	jmp	jle_cont.1869
jle_else.1868:
	addi	%g11, %g0, 48
	add	%g10, %g11, %g10
	output	%g10
	addi	%g3, %g0, 1
jle_cont.1869:
	mvhi	%g4, 152
	mvlo	%g4, 38528
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g10, %g0, 5
	mvhi	%g11, 762
	mvlo	%g11, 61568
	ld	%g12, %g1, 0
	st	%g3, %g1, 4
	jlt	%g11, %g12, jle_else.1870
	jne	%g11, %g12, jeq_else.1872
	addi	%g3, %g0, 5
	jmp	jeq_cont.1873
jeq_else.1872:
	addi	%g6, %g0, 2
	mvhi	%g11, 305
	mvlo	%g11, 11520
	jlt	%g11, %g12, jle_else.1874
	jne	%g11, %g12, jeq_else.1876
	addi	%g3, %g0, 2
	jmp	jeq_cont.1877
jeq_else.1876:
	addi	%g10, %g0, 1
	mvhi	%g11, 152
	mvlo	%g11, 38528
	jlt	%g11, %g12, jle_else.1878
	jne	%g11, %g12, jeq_else.1880
	addi	%g3, %g0, 1
	jmp	jeq_cont.1881
jeq_else.1880:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.337
	addi	%g1, %g1, 16
jeq_cont.1881:
	jmp	jle_cont.1879
jle_else.1878:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.337
	addi	%g1, %g1, 16
jle_cont.1879:
jeq_cont.1877:
	jmp	jle_cont.1875
jle_else.1874:
	addi	%g5, %g0, 3
	mvhi	%g11, 457
	mvlo	%g11, 50048
	jlt	%g11, %g12, jle_else.1882
	jne	%g11, %g12, jeq_else.1884
	addi	%g3, %g0, 3
	jmp	jeq_cont.1885
jeq_else.1884:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.337
	addi	%g1, %g1, 16
jeq_cont.1885:
	jmp	jle_cont.1883
jle_else.1882:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.337
	addi	%g1, %g1, 16
jle_cont.1883:
jle_cont.1875:
jeq_cont.1873:
	jmp	jle_cont.1871
jle_else.1870:
	addi	%g5, %g0, 7
	mvhi	%g11, 1068
	mvlo	%g11, 7552
	jlt	%g11, %g12, jle_else.1886
	jne	%g11, %g12, jeq_else.1888
	addi	%g3, %g0, 7
	jmp	jeq_cont.1889
jeq_else.1888:
	addi	%g6, %g0, 6
	mvhi	%g11, 915
	mvlo	%g11, 34560
	jlt	%g11, %g12, jle_else.1890
	jne	%g11, %g12, jeq_else.1892
	addi	%g3, %g0, 6
	jmp	jeq_cont.1893
jeq_else.1892:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.337
	addi	%g1, %g1, 16
jeq_cont.1893:
	jmp	jle_cont.1891
jle_else.1890:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.337
	addi	%g1, %g1, 16
jle_cont.1891:
jeq_cont.1889:
	jmp	jle_cont.1887
jle_else.1886:
	addi	%g10, %g0, 8
	mvhi	%g11, 1220
	mvlo	%g11, 46080
	jlt	%g11, %g12, jle_else.1894
	jne	%g11, %g12, jeq_else.1896
	addi	%g3, %g0, 8
	jmp	jeq_cont.1897
jeq_else.1896:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.337
	addi	%g1, %g1, 16
jeq_cont.1897:
	jmp	jle_cont.1895
jle_else.1894:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.337
	addi	%g1, %g1, 16
jle_cont.1895:
jle_cont.1887:
jle_cont.1871:
	mvhi	%g10, 152
	mvlo	%g10, 38528
	mul	%g10, %g3, %g10
	sub	%g10, %g12, %g10
	jlt	%g0, %g3, jle_else.1898
	ld	%g11, %g1, 4
	jne	%g11, %g0, jeq_else.1900
	addi	%g3, %g0, 0
	jmp	jeq_cont.1901
jeq_else.1900:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1901:
	jmp	jle_cont.1899
jle_else.1898:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1899:
	mvhi	%g4, 15
	mvlo	%g4, 16960
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 76
	mvlo	%g12, 19264
	st	%g3, %g1, 8
	jlt	%g12, %g10, jle_else.1902
	jne	%g12, %g10, jeq_else.1904
	addi	%g3, %g0, 5
	jmp	jeq_cont.1905
jeq_else.1904:
	addi	%g6, %g0, 2
	mvhi	%g12, 30
	mvlo	%g12, 33920
	jlt	%g12, %g10, jle_else.1906
	jne	%g12, %g10, jeq_else.1908
	addi	%g3, %g0, 2
	jmp	jeq_cont.1909
jeq_else.1908:
	addi	%g11, %g0, 1
	mvhi	%g12, 15
	mvlo	%g12, 16960
	jlt	%g12, %g10, jle_else.1910
	jne	%g12, %g10, jeq_else.1912
	addi	%g3, %g0, 1
	jmp	jeq_cont.1913
jeq_else.1912:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.337
	addi	%g1, %g1, 16
jeq_cont.1913:
	jmp	jle_cont.1911
jle_else.1910:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.337
	addi	%g1, %g1, 16
jle_cont.1911:
jeq_cont.1909:
	jmp	jle_cont.1907
jle_else.1906:
	addi	%g5, %g0, 3
	mvhi	%g12, 45
	mvlo	%g12, 50880
	jlt	%g12, %g10, jle_else.1914
	jne	%g12, %g10, jeq_else.1916
	addi	%g3, %g0, 3
	jmp	jeq_cont.1917
jeq_else.1916:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.337
	addi	%g1, %g1, 16
jeq_cont.1917:
	jmp	jle_cont.1915
jle_else.1914:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.337
	addi	%g1, %g1, 16
jle_cont.1915:
jle_cont.1907:
jeq_cont.1905:
	jmp	jle_cont.1903
jle_else.1902:
	addi	%g5, %g0, 7
	mvhi	%g12, 106
	mvlo	%g12, 53184
	jlt	%g12, %g10, jle_else.1918
	jne	%g12, %g10, jeq_else.1920
	addi	%g3, %g0, 7
	jmp	jeq_cont.1921
jeq_else.1920:
	addi	%g6, %g0, 6
	mvhi	%g12, 91
	mvlo	%g12, 36224
	jlt	%g12, %g10, jle_else.1922
	jne	%g12, %g10, jeq_else.1924
	addi	%g3, %g0, 6
	jmp	jeq_cont.1925
jeq_else.1924:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.337
	addi	%g1, %g1, 16
jeq_cont.1925:
	jmp	jle_cont.1923
jle_else.1922:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.337
	addi	%g1, %g1, 16
jle_cont.1923:
jeq_cont.1921:
	jmp	jle_cont.1919
jle_else.1918:
	addi	%g11, %g0, 8
	mvhi	%g12, 122
	mvlo	%g12, 4608
	jlt	%g12, %g10, jle_else.1926
	jne	%g12, %g10, jeq_else.1928
	addi	%g3, %g0, 8
	jmp	jeq_cont.1929
jeq_else.1928:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.337
	addi	%g1, %g1, 16
jeq_cont.1929:
	jmp	jle_cont.1927
jle_else.1926:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.337
	addi	%g1, %g1, 16
jle_cont.1927:
jle_cont.1919:
jle_cont.1903:
	mvhi	%g11, 15
	mvlo	%g11, 16960
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1930
	ld	%g11, %g1, 8
	jne	%g11, %g0, jeq_else.1932
	addi	%g3, %g0, 0
	jmp	jeq_cont.1933
jeq_else.1932:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1933:
	jmp	jle_cont.1931
jle_else.1930:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1931:
	mvhi	%g4, 1
	mvlo	%g4, 34464
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 7
	mvlo	%g12, 41248
	st	%g3, %g1, 12
	jlt	%g12, %g10, jle_else.1934
	jne	%g12, %g10, jeq_else.1936
	addi	%g3, %g0, 5
	jmp	jeq_cont.1937
jeq_else.1936:
	addi	%g6, %g0, 2
	mvhi	%g12, 3
	mvlo	%g12, 3392
	jlt	%g12, %g10, jle_else.1938
	jne	%g12, %g10, jeq_else.1940
	addi	%g3, %g0, 2
	jmp	jeq_cont.1941
jeq_else.1940:
	addi	%g11, %g0, 1
	mvhi	%g12, 1
	mvlo	%g12, 34464
	jlt	%g12, %g10, jle_else.1942
	jne	%g12, %g10, jeq_else.1944
	addi	%g3, %g0, 1
	jmp	jeq_cont.1945
jeq_else.1944:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.337
	addi	%g1, %g1, 24
jeq_cont.1945:
	jmp	jle_cont.1943
jle_else.1942:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.337
	addi	%g1, %g1, 24
jle_cont.1943:
jeq_cont.1941:
	jmp	jle_cont.1939
jle_else.1938:
	addi	%g5, %g0, 3
	mvhi	%g12, 4
	mvlo	%g12, 37856
	jlt	%g12, %g10, jle_else.1946
	jne	%g12, %g10, jeq_else.1948
	addi	%g3, %g0, 3
	jmp	jeq_cont.1949
jeq_else.1948:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.337
	addi	%g1, %g1, 24
jeq_cont.1949:
	jmp	jle_cont.1947
jle_else.1946:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.337
	addi	%g1, %g1, 24
jle_cont.1947:
jle_cont.1939:
jeq_cont.1937:
	jmp	jle_cont.1935
jle_else.1934:
	addi	%g5, %g0, 7
	mvhi	%g12, 10
	mvlo	%g12, 44640
	jlt	%g12, %g10, jle_else.1950
	jne	%g12, %g10, jeq_else.1952
	addi	%g3, %g0, 7
	jmp	jeq_cont.1953
jeq_else.1952:
	addi	%g6, %g0, 6
	mvhi	%g12, 9
	mvlo	%g12, 10176
	jlt	%g12, %g10, jle_else.1954
	jne	%g12, %g10, jeq_else.1956
	addi	%g3, %g0, 6
	jmp	jeq_cont.1957
jeq_else.1956:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.337
	addi	%g1, %g1, 24
jeq_cont.1957:
	jmp	jle_cont.1955
jle_else.1954:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.337
	addi	%g1, %g1, 24
jle_cont.1955:
jeq_cont.1953:
	jmp	jle_cont.1951
jle_else.1950:
	addi	%g11, %g0, 8
	mvhi	%g12, 12
	mvlo	%g12, 13568
	jlt	%g12, %g10, jle_else.1958
	jne	%g12, %g10, jeq_else.1960
	addi	%g3, %g0, 8
	jmp	jeq_cont.1961
jeq_else.1960:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.337
	addi	%g1, %g1, 24
jeq_cont.1961:
	jmp	jle_cont.1959
jle_else.1958:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.337
	addi	%g1, %g1, 24
jle_cont.1959:
jle_cont.1951:
jle_cont.1935:
	mvhi	%g11, 1
	mvlo	%g11, 34464
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1962
	ld	%g11, %g1, 12
	jne	%g11, %g0, jeq_else.1964
	addi	%g3, %g0, 0
	jmp	jeq_cont.1965
jeq_else.1964:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1965:
	jmp	jle_cont.1963
jle_else.1962:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1963:
	addi	%g4, %g0, 10000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 0
	mvlo	%g12, 50000
	st	%g3, %g1, 16
	jlt	%g12, %g10, jle_else.1966
	jne	%g12, %g10, jeq_else.1968
	addi	%g3, %g0, 5
	jmp	jeq_cont.1969
jeq_else.1968:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20000
	jlt	%g12, %g10, jle_else.1970
	jne	%g12, %g10, jeq_else.1972
	addi	%g3, %g0, 2
	jmp	jeq_cont.1973
jeq_else.1972:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10000
	jlt	%g12, %g10, jle_else.1974
	jne	%g12, %g10, jeq_else.1976
	addi	%g3, %g0, 1
	jmp	jeq_cont.1977
jeq_else.1976:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.337
	addi	%g1, %g1, 24
jeq_cont.1977:
	jmp	jle_cont.1975
jle_else.1974:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.337
	addi	%g1, %g1, 24
jle_cont.1975:
jeq_cont.1973:
	jmp	jle_cont.1971
jle_else.1970:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30000
	jlt	%g12, %g10, jle_else.1978
	jne	%g12, %g10, jeq_else.1980
	addi	%g3, %g0, 3
	jmp	jeq_cont.1981
jeq_else.1980:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.337
	addi	%g1, %g1, 24
jeq_cont.1981:
	jmp	jle_cont.1979
jle_else.1978:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.337
	addi	%g1, %g1, 24
jle_cont.1979:
jle_cont.1971:
jeq_cont.1969:
	jmp	jle_cont.1967
jle_else.1966:
	addi	%g5, %g0, 7
	mvhi	%g12, 1
	mvlo	%g12, 4464
	jlt	%g12, %g10, jle_else.1982
	jne	%g12, %g10, jeq_else.1984
	addi	%g3, %g0, 7
	jmp	jeq_cont.1985
jeq_else.1984:
	addi	%g6, %g0, 6
	mvhi	%g12, 0
	mvlo	%g12, 60000
	jlt	%g12, %g10, jle_else.1986
	jne	%g12, %g10, jeq_else.1988
	addi	%g3, %g0, 6
	jmp	jeq_cont.1989
jeq_else.1988:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.337
	addi	%g1, %g1, 24
jeq_cont.1989:
	jmp	jle_cont.1987
jle_else.1986:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.337
	addi	%g1, %g1, 24
jle_cont.1987:
jeq_cont.1985:
	jmp	jle_cont.1983
jle_else.1982:
	addi	%g11, %g0, 8
	mvhi	%g12, 1
	mvlo	%g12, 14464
	jlt	%g12, %g10, jle_else.1990
	jne	%g12, %g10, jeq_else.1992
	addi	%g3, %g0, 8
	jmp	jeq_cont.1993
jeq_else.1992:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.337
	addi	%g1, %g1, 24
jeq_cont.1993:
	jmp	jle_cont.1991
jle_else.1990:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.337
	addi	%g1, %g1, 24
jle_cont.1991:
jle_cont.1983:
jle_cont.1967:
	addi	%g11, %g0, 10000
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1994
	ld	%g11, %g1, 16
	jne	%g11, %g0, jeq_else.1996
	addi	%g3, %g0, 0
	jmp	jeq_cont.1997
jeq_else.1996:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1997:
	jmp	jle_cont.1995
jle_else.1994:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1995:
	addi	%g4, %g0, 1000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 5000
	st	%g3, %g1, 20
	jlt	%g12, %g10, jle_else.1998
	jne	%g12, %g10, jeq_else.2000
	addi	%g3, %g0, 5
	jmp	jeq_cont.2001
jeq_else.2000:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 2000
	jlt	%g12, %g10, jle_else.2002
	jne	%g12, %g10, jeq_else.2004
	addi	%g3, %g0, 2
	jmp	jeq_cont.2005
jeq_else.2004:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 1000
	jlt	%g12, %g10, jle_else.2006
	jne	%g12, %g10, jeq_else.2008
	addi	%g3, %g0, 1
	jmp	jeq_cont.2009
jeq_else.2008:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.337
	addi	%g1, %g1, 32
jeq_cont.2009:
	jmp	jle_cont.2007
jle_else.2006:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.337
	addi	%g1, %g1, 32
jle_cont.2007:
jeq_cont.2005:
	jmp	jle_cont.2003
jle_else.2002:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 3000
	jlt	%g12, %g10, jle_else.2010
	jne	%g12, %g10, jeq_else.2012
	addi	%g3, %g0, 3
	jmp	jeq_cont.2013
jeq_else.2012:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.337
	addi	%g1, %g1, 32
jeq_cont.2013:
	jmp	jle_cont.2011
jle_else.2010:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.337
	addi	%g1, %g1, 32
jle_cont.2011:
jle_cont.2003:
jeq_cont.2001:
	jmp	jle_cont.1999
jle_else.1998:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 7000
	jlt	%g12, %g10, jle_else.2014
	jne	%g12, %g10, jeq_else.2016
	addi	%g3, %g0, 7
	jmp	jeq_cont.2017
jeq_else.2016:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 6000
	jlt	%g12, %g10, jle_else.2018
	jne	%g12, %g10, jeq_else.2020
	addi	%g3, %g0, 6
	jmp	jeq_cont.2021
jeq_else.2020:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.337
	addi	%g1, %g1, 32
jeq_cont.2021:
	jmp	jle_cont.2019
jle_else.2018:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.337
	addi	%g1, %g1, 32
jle_cont.2019:
jeq_cont.2017:
	jmp	jle_cont.2015
jle_else.2014:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 8000
	jlt	%g12, %g10, jle_else.2022
	jne	%g12, %g10, jeq_else.2024
	addi	%g3, %g0, 8
	jmp	jeq_cont.2025
jeq_else.2024:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.337
	addi	%g1, %g1, 32
jeq_cont.2025:
	jmp	jle_cont.2023
jle_else.2022:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.337
	addi	%g1, %g1, 32
jle_cont.2023:
jle_cont.2015:
jle_cont.1999:
	muli	%g11, %g3, 1000
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2026
	ld	%g11, %g1, 20
	jne	%g11, %g0, jeq_else.2028
	addi	%g3, %g0, 0
	jmp	jeq_cont.2029
jeq_else.2028:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2029:
	jmp	jle_cont.2027
jle_else.2026:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2027:
	addi	%g4, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 500
	st	%g3, %g1, 24
	jlt	%g12, %g10, jle_else.2030
	jne	%g12, %g10, jeq_else.2032
	addi	%g3, %g0, 5
	jmp	jeq_cont.2033
jeq_else.2032:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 200
	jlt	%g12, %g10, jle_else.2034
	jne	%g12, %g10, jeq_else.2036
	addi	%g3, %g0, 2
	jmp	jeq_cont.2037
jeq_else.2036:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 100
	jlt	%g12, %g10, jle_else.2038
	jne	%g12, %g10, jeq_else.2040
	addi	%g3, %g0, 1
	jmp	jeq_cont.2041
jeq_else.2040:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.337
	addi	%g1, %g1, 32
jeq_cont.2041:
	jmp	jle_cont.2039
jle_else.2038:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.337
	addi	%g1, %g1, 32
jle_cont.2039:
jeq_cont.2037:
	jmp	jle_cont.2035
jle_else.2034:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 300
	jlt	%g12, %g10, jle_else.2042
	jne	%g12, %g10, jeq_else.2044
	addi	%g3, %g0, 3
	jmp	jeq_cont.2045
jeq_else.2044:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.337
	addi	%g1, %g1, 32
jeq_cont.2045:
	jmp	jle_cont.2043
jle_else.2042:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.337
	addi	%g1, %g1, 32
jle_cont.2043:
jle_cont.2035:
jeq_cont.2033:
	jmp	jle_cont.2031
jle_else.2030:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 700
	jlt	%g12, %g10, jle_else.2046
	jne	%g12, %g10, jeq_else.2048
	addi	%g3, %g0, 7
	jmp	jeq_cont.2049
jeq_else.2048:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 600
	jlt	%g12, %g10, jle_else.2050
	jne	%g12, %g10, jeq_else.2052
	addi	%g3, %g0, 6
	jmp	jeq_cont.2053
jeq_else.2052:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.337
	addi	%g1, %g1, 32
jeq_cont.2053:
	jmp	jle_cont.2051
jle_else.2050:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.337
	addi	%g1, %g1, 32
jle_cont.2051:
jeq_cont.2049:
	jmp	jle_cont.2047
jle_else.2046:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 800
	jlt	%g12, %g10, jle_else.2054
	jne	%g12, %g10, jeq_else.2056
	addi	%g3, %g0, 8
	jmp	jeq_cont.2057
jeq_else.2056:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.337
	addi	%g1, %g1, 32
jeq_cont.2057:
	jmp	jle_cont.2055
jle_else.2054:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.337
	addi	%g1, %g1, 32
jle_cont.2055:
jle_cont.2047:
jle_cont.2031:
	muli	%g11, %g3, 100
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2058
	ld	%g11, %g1, 24
	jne	%g11, %g0, jeq_else.2060
	addi	%g3, %g0, 0
	jmp	jeq_cont.2061
jeq_else.2060:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2061:
	jmp	jle_cont.2059
jle_else.2058:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2059:
	addi	%g4, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 50
	st	%g3, %g1, 28
	jlt	%g12, %g10, jle_else.2062
	jne	%g12, %g10, jeq_else.2064
	addi	%g3, %g0, 5
	jmp	jeq_cont.2065
jeq_else.2064:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20
	jlt	%g12, %g10, jle_else.2066
	jne	%g12, %g10, jeq_else.2068
	addi	%g3, %g0, 2
	jmp	jeq_cont.2069
jeq_else.2068:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10
	jlt	%g12, %g10, jle_else.2070
	jne	%g12, %g10, jeq_else.2072
	addi	%g3, %g0, 1
	jmp	jeq_cont.2073
jeq_else.2072:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.337
	addi	%g1, %g1, 40
jeq_cont.2073:
	jmp	jle_cont.2071
jle_else.2070:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.337
	addi	%g1, %g1, 40
jle_cont.2071:
jeq_cont.2069:
	jmp	jle_cont.2067
jle_else.2066:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30
	jlt	%g12, %g10, jle_else.2074
	jne	%g12, %g10, jeq_else.2076
	addi	%g3, %g0, 3
	jmp	jeq_cont.2077
jeq_else.2076:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.337
	addi	%g1, %g1, 40
jeq_cont.2077:
	jmp	jle_cont.2075
jle_else.2074:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.337
	addi	%g1, %g1, 40
jle_cont.2075:
jle_cont.2067:
jeq_cont.2065:
	jmp	jle_cont.2063
jle_else.2062:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 70
	jlt	%g12, %g10, jle_else.2078
	jne	%g12, %g10, jeq_else.2080
	addi	%g3, %g0, 7
	jmp	jeq_cont.2081
jeq_else.2080:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 60
	jlt	%g12, %g10, jle_else.2082
	jne	%g12, %g10, jeq_else.2084
	addi	%g3, %g0, 6
	jmp	jeq_cont.2085
jeq_else.2084:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.337
	addi	%g1, %g1, 40
jeq_cont.2085:
	jmp	jle_cont.2083
jle_else.2082:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.337
	addi	%g1, %g1, 40
jle_cont.2083:
jeq_cont.2081:
	jmp	jle_cont.2079
jle_else.2078:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 80
	jlt	%g12, %g10, jle_else.2086
	jne	%g12, %g10, jeq_else.2088
	addi	%g3, %g0, 8
	jmp	jeq_cont.2089
jeq_else.2088:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.337
	addi	%g1, %g1, 40
jeq_cont.2089:
	jmp	jle_cont.2087
jle_else.2086:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.337
	addi	%g1, %g1, 40
jle_cont.2087:
jle_cont.2079:
jle_cont.2063:
	muli	%g11, %g3, 10
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2090
	ld	%g11, %g1, 28
	jne	%g11, %g0, jeq_else.2092
	addi	%g3, %g0, 0
	jmp	jeq_cont.2093
jeq_else.2092:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2093:
	jmp	jle_cont.2091
jle_else.2090:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2091:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g10
	output	%g3
	return
jge_else.1859:
	addi	%g10, %g0, 45
	st	%g3, %g1, 32
	output	%g10
	ld	%g3, %g1, 32
	sub	%g3, %g0, %g3
	jmp	print_int.342
even.346:
	jlt	%g0, %g3, jle_else.2094
	jlt	%g3, %g0, jge_else.2095
	addi	%g3, %g0, 123
	return
jge_else.2095:
	addi	%g3, %g3, 1
	jlt	%g0, %g3, jle_else.2096
	jlt	%g3, %g0, jge_else.2097
	addi	%g3, %g0, 456
	return
jge_else.2097:
	addi	%g3, %g3, 1
	jlt	%g0, %g3, jle_else.2098
	jlt	%g3, %g0, jge_else.2099
	addi	%g3, %g0, 123
	return
jge_else.2099:
	addi	%g3, %g3, 1
	jlt	%g0, %g3, jle_else.2100
	jlt	%g3, %g0, jge_else.2101
	addi	%g3, %g0, 456
	return
jge_else.2101:
	addi	%g3, %g3, 1
	jmp	even.346
jle_else.2100:
	subi	%g3, %g3, 1
	jmp	even.346
jle_else.2098:
	subi	%g3, %g3, 1
	jlt	%g0, %g3, jle_else.2102
	jlt	%g3, %g0, jge_else.2103
	addi	%g3, %g0, 456
	return
jge_else.2103:
	addi	%g3, %g3, 1
	jmp	even.346
jle_else.2102:
	subi	%g3, %g3, 1
	jmp	even.346
jle_else.2096:
	subi	%g3, %g3, 1
	jlt	%g0, %g3, jle_else.2104
	jlt	%g3, %g0, jge_else.2105
	addi	%g3, %g0, 123
	return
jge_else.2105:
	addi	%g3, %g3, 1
	jlt	%g0, %g3, jle_else.2106
	jlt	%g3, %g0, jge_else.2107
	addi	%g3, %g0, 456
	return
jge_else.2107:
	addi	%g3, %g3, 1
	jmp	even.346
jle_else.2106:
	subi	%g3, %g3, 1
	jmp	even.346
jle_else.2104:
	subi	%g3, %g3, 1
	jlt	%g0, %g3, jle_else.2108
	jlt	%g3, %g0, jge_else.2109
	addi	%g3, %g0, 456
	return
jge_else.2109:
	addi	%g3, %g3, 1
	jmp	even.346
jle_else.2108:
	subi	%g3, %g3, 1
	jmp	even.346
jle_else.2094:
	subi	%g3, %g3, 1
	jlt	%g0, %g3, jle_else.2110
	jlt	%g3, %g0, jge_else.2111
	addi	%g3, %g0, 456
	return
jge_else.2111:
	addi	%g3, %g3, 1
	jlt	%g0, %g3, jle_else.2112
	jlt	%g3, %g0, jge_else.2113
	addi	%g3, %g0, 123
	return
jge_else.2113:
	addi	%g3, %g3, 1
	jlt	%g0, %g3, jle_else.2114
	jlt	%g3, %g0, jge_else.2115
	addi	%g3, %g0, 456
	return
jge_else.2115:
	addi	%g3, %g3, 1
	jmp	even.346
jle_else.2114:
	subi	%g3, %g3, 1
	jmp	even.346
jle_else.2112:
	subi	%g3, %g3, 1
	jlt	%g0, %g3, jle_else.2116
	jlt	%g3, %g0, jge_else.2117
	addi	%g3, %g0, 456
	return
jge_else.2117:
	addi	%g3, %g3, 1
	jmp	even.346
jle_else.2116:
	subi	%g3, %g3, 1
	jmp	even.346
jle_else.2110:
	subi	%g3, %g3, 1
	jlt	%g0, %g3, jle_else.2118
	jlt	%g3, %g0, jge_else.2119
	addi	%g3, %g0, 123
	return
jge_else.2119:
	addi	%g3, %g3, 1
	jlt	%g0, %g3, jle_else.2120
	jlt	%g3, %g0, jge_else.2121
	addi	%g3, %g0, 456
	return
jge_else.2121:
	addi	%g3, %g3, 1
	jmp	even.346
jle_else.2120:
	subi	%g3, %g3, 1
	jmp	even.346
jle_else.2118:
	subi	%g3, %g3, 1
	jlt	%g0, %g3, jle_else.2122
	jlt	%g3, %g0, jge_else.2123
	addi	%g3, %g0, 456
	return
jge_else.2123:
	addi	%g3, %g3, 1
	jmp	even.346
jle_else.2122:
	subi	%g3, %g3, 1
	jmp	even.346
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
	addi	%g3, %g0, 787
	subi	%g1, %g1, 8
	call	even.346
	addi	%g1, %g1, 8
	subi	%g1, %g1, 8
	call	print_int.342
	addi	%g1, %g1, 8
	halt
