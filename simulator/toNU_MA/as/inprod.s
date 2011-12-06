.init_heap_size	224
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
l.1503:	! 32000000.000000
	.long	0x4bf42400
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
div_binary_search.349:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1764
	mov	%g3, %g5
	return
jle_else.1764:
	jlt	%g8, %g3, jle_else.1765
	jne	%g8, %g3, jeq_else.1766
	mov	%g3, %g7
	return
jeq_else.1766:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1767
	mov	%g3, %g5
	return
jle_else.1767:
	jlt	%g8, %g3, jle_else.1768
	jne	%g8, %g3, jeq_else.1769
	mov	%g3, %g6
	return
jeq_else.1769:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1770
	mov	%g3, %g5
	return
jle_else.1770:
	jlt	%g8, %g3, jle_else.1771
	jne	%g8, %g3, jeq_else.1772
	mov	%g3, %g7
	return
jeq_else.1772:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1773
	mov	%g3, %g5
	return
jle_else.1773:
	jlt	%g8, %g3, jle_else.1774
	jne	%g8, %g3, jeq_else.1775
	mov	%g3, %g6
	return
jeq_else.1775:
	jmp	div_binary_search.349
jle_else.1774:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.349
jle_else.1771:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1776
	mov	%g3, %g7
	return
jle_else.1776:
	jlt	%g8, %g3, jle_else.1777
	jne	%g8, %g3, jeq_else.1778
	mov	%g3, %g5
	return
jeq_else.1778:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.349
jle_else.1777:
	jmp	div_binary_search.349
jle_else.1768:
	add	%g5, %g6, %g7
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g7, %g6
	jlt	%g28, %g9, jle_else.1779
	mov	%g3, %g6
	return
jle_else.1779:
	jlt	%g8, %g3, jle_else.1780
	jne	%g8, %g3, jeq_else.1781
	mov	%g3, %g5
	return
jeq_else.1781:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.1782
	mov	%g3, %g6
	return
jle_else.1782:
	jlt	%g8, %g3, jle_else.1783
	jne	%g8, %g3, jeq_else.1784
	mov	%g3, %g7
	return
jeq_else.1784:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.349
jle_else.1783:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.349
jle_else.1780:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1785
	mov	%g3, %g5
	return
jle_else.1785:
	jlt	%g8, %g3, jle_else.1786
	jne	%g8, %g3, jeq_else.1787
	mov	%g3, %g6
	return
jeq_else.1787:
	jmp	div_binary_search.349
jle_else.1786:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.349
jle_else.1765:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1788
	mov	%g3, %g7
	return
jle_else.1788:
	jlt	%g8, %g3, jle_else.1789
	jne	%g8, %g3, jeq_else.1790
	mov	%g3, %g5
	return
jeq_else.1790:
	add	%g6, %g7, %g5
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g5, %g7
	jlt	%g28, %g9, jle_else.1791
	mov	%g3, %g7
	return
jle_else.1791:
	jlt	%g8, %g3, jle_else.1792
	jne	%g8, %g3, jeq_else.1793
	mov	%g3, %g6
	return
jeq_else.1793:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1794
	mov	%g3, %g7
	return
jle_else.1794:
	jlt	%g8, %g3, jle_else.1795
	jne	%g8, %g3, jeq_else.1796
	mov	%g3, %g5
	return
jeq_else.1796:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.349
jle_else.1795:
	jmp	div_binary_search.349
jle_else.1792:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.1797
	mov	%g3, %g6
	return
jle_else.1797:
	jlt	%g8, %g3, jle_else.1798
	jne	%g8, %g3, jeq_else.1799
	mov	%g3, %g7
	return
jeq_else.1799:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.349
jle_else.1798:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.349
jle_else.1789:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1800
	mov	%g3, %g5
	return
jle_else.1800:
	jlt	%g8, %g3, jle_else.1801
	jne	%g8, %g3, jeq_else.1802
	mov	%g3, %g7
	return
jeq_else.1802:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1803
	mov	%g3, %g5
	return
jle_else.1803:
	jlt	%g8, %g3, jle_else.1804
	jne	%g8, %g3, jeq_else.1805
	mov	%g3, %g6
	return
jeq_else.1805:
	jmp	div_binary_search.349
jle_else.1804:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.349
jle_else.1801:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1806
	mov	%g3, %g7
	return
jle_else.1806:
	jlt	%g8, %g3, jle_else.1807
	jne	%g8, %g3, jeq_else.1808
	mov	%g3, %g5
	return
jeq_else.1808:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.349
jle_else.1807:
	jmp	div_binary_search.349
print_int.354:
	jlt	%g3, %g0, jge_else.1809
	mvhi	%g10, 1525
	mvlo	%g10, 57600
	jlt	%g10, %g3, jle_else.1810
	jne	%g10, %g3, jeq_else.1812
	addi	%g10, %g0, 1
	jmp	jeq_cont.1813
jeq_else.1812:
	addi	%g10, %g0, 0
jeq_cont.1813:
	jmp	jle_cont.1811
jle_else.1810:
	mvhi	%g10, 3051
	mvlo	%g10, 49664
	jlt	%g10, %g3, jle_else.1814
	jne	%g10, %g3, jeq_else.1816
	addi	%g10, %g0, 2
	jmp	jeq_cont.1817
jeq_else.1816:
	addi	%g10, %g0, 1
jeq_cont.1817:
	jmp	jle_cont.1815
jle_else.1814:
	addi	%g10, %g0, 2
jle_cont.1815:
jle_cont.1811:
	mvhi	%g11, 1525
	mvlo	%g11, 57600
	mul	%g11, %g10, %g11
	sub	%g3, %g3, %g11
	st	%g3, %g1, 0
	jlt	%g0, %g10, jle_else.1818
	addi	%g3, %g0, 0
	jmp	jle_cont.1819
jle_else.1818:
	addi	%g11, %g0, 48
	add	%g10, %g11, %g10
	output	%g10
	addi	%g3, %g0, 1
jle_cont.1819:
	mvhi	%g4, 152
	mvlo	%g4, 38528
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g10, %g0, 5
	mvhi	%g11, 762
	mvlo	%g11, 61568
	ld	%g12, %g1, 0
	st	%g3, %g1, 4
	jlt	%g11, %g12, jle_else.1820
	jne	%g11, %g12, jeq_else.1822
	addi	%g3, %g0, 5
	jmp	jeq_cont.1823
jeq_else.1822:
	addi	%g6, %g0, 2
	mvhi	%g11, 305
	mvlo	%g11, 11520
	jlt	%g11, %g12, jle_else.1824
	jne	%g11, %g12, jeq_else.1826
	addi	%g3, %g0, 2
	jmp	jeq_cont.1827
jeq_else.1826:
	addi	%g10, %g0, 1
	mvhi	%g11, 152
	mvlo	%g11, 38528
	jlt	%g11, %g12, jle_else.1828
	jne	%g11, %g12, jeq_else.1830
	addi	%g3, %g0, 1
	jmp	jeq_cont.1831
jeq_else.1830:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.349
	addi	%g1, %g1, 16
jeq_cont.1831:
	jmp	jle_cont.1829
jle_else.1828:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.349
	addi	%g1, %g1, 16
jle_cont.1829:
jeq_cont.1827:
	jmp	jle_cont.1825
jle_else.1824:
	addi	%g5, %g0, 3
	mvhi	%g11, 457
	mvlo	%g11, 50048
	jlt	%g11, %g12, jle_else.1832
	jne	%g11, %g12, jeq_else.1834
	addi	%g3, %g0, 3
	jmp	jeq_cont.1835
jeq_else.1834:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.349
	addi	%g1, %g1, 16
jeq_cont.1835:
	jmp	jle_cont.1833
jle_else.1832:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.349
	addi	%g1, %g1, 16
jle_cont.1833:
jle_cont.1825:
jeq_cont.1823:
	jmp	jle_cont.1821
jle_else.1820:
	addi	%g5, %g0, 7
	mvhi	%g11, 1068
	mvlo	%g11, 7552
	jlt	%g11, %g12, jle_else.1836
	jne	%g11, %g12, jeq_else.1838
	addi	%g3, %g0, 7
	jmp	jeq_cont.1839
jeq_else.1838:
	addi	%g6, %g0, 6
	mvhi	%g11, 915
	mvlo	%g11, 34560
	jlt	%g11, %g12, jle_else.1840
	jne	%g11, %g12, jeq_else.1842
	addi	%g3, %g0, 6
	jmp	jeq_cont.1843
jeq_else.1842:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.349
	addi	%g1, %g1, 16
jeq_cont.1843:
	jmp	jle_cont.1841
jle_else.1840:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.349
	addi	%g1, %g1, 16
jle_cont.1841:
jeq_cont.1839:
	jmp	jle_cont.1837
jle_else.1836:
	addi	%g10, %g0, 8
	mvhi	%g11, 1220
	mvlo	%g11, 46080
	jlt	%g11, %g12, jle_else.1844
	jne	%g11, %g12, jeq_else.1846
	addi	%g3, %g0, 8
	jmp	jeq_cont.1847
jeq_else.1846:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.349
	addi	%g1, %g1, 16
jeq_cont.1847:
	jmp	jle_cont.1845
jle_else.1844:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.349
	addi	%g1, %g1, 16
jle_cont.1845:
jle_cont.1837:
jle_cont.1821:
	mvhi	%g10, 152
	mvlo	%g10, 38528
	mul	%g10, %g3, %g10
	sub	%g10, %g12, %g10
	jlt	%g0, %g3, jle_else.1848
	ld	%g11, %g1, 4
	jne	%g11, %g0, jeq_else.1850
	addi	%g3, %g0, 0
	jmp	jeq_cont.1851
jeq_else.1850:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1851:
	jmp	jle_cont.1849
jle_else.1848:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1849:
	mvhi	%g4, 15
	mvlo	%g4, 16960
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 76
	mvlo	%g12, 19264
	st	%g3, %g1, 8
	jlt	%g12, %g10, jle_else.1852
	jne	%g12, %g10, jeq_else.1854
	addi	%g3, %g0, 5
	jmp	jeq_cont.1855
jeq_else.1854:
	addi	%g6, %g0, 2
	mvhi	%g12, 30
	mvlo	%g12, 33920
	jlt	%g12, %g10, jle_else.1856
	jne	%g12, %g10, jeq_else.1858
	addi	%g3, %g0, 2
	jmp	jeq_cont.1859
jeq_else.1858:
	addi	%g11, %g0, 1
	mvhi	%g12, 15
	mvlo	%g12, 16960
	jlt	%g12, %g10, jle_else.1860
	jne	%g12, %g10, jeq_else.1862
	addi	%g3, %g0, 1
	jmp	jeq_cont.1863
jeq_else.1862:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.349
	addi	%g1, %g1, 16
jeq_cont.1863:
	jmp	jle_cont.1861
jle_else.1860:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.349
	addi	%g1, %g1, 16
jle_cont.1861:
jeq_cont.1859:
	jmp	jle_cont.1857
jle_else.1856:
	addi	%g5, %g0, 3
	mvhi	%g12, 45
	mvlo	%g12, 50880
	jlt	%g12, %g10, jle_else.1864
	jne	%g12, %g10, jeq_else.1866
	addi	%g3, %g0, 3
	jmp	jeq_cont.1867
jeq_else.1866:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.349
	addi	%g1, %g1, 16
jeq_cont.1867:
	jmp	jle_cont.1865
jle_else.1864:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.349
	addi	%g1, %g1, 16
jle_cont.1865:
jle_cont.1857:
jeq_cont.1855:
	jmp	jle_cont.1853
jle_else.1852:
	addi	%g5, %g0, 7
	mvhi	%g12, 106
	mvlo	%g12, 53184
	jlt	%g12, %g10, jle_else.1868
	jne	%g12, %g10, jeq_else.1870
	addi	%g3, %g0, 7
	jmp	jeq_cont.1871
jeq_else.1870:
	addi	%g6, %g0, 6
	mvhi	%g12, 91
	mvlo	%g12, 36224
	jlt	%g12, %g10, jle_else.1872
	jne	%g12, %g10, jeq_else.1874
	addi	%g3, %g0, 6
	jmp	jeq_cont.1875
jeq_else.1874:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.349
	addi	%g1, %g1, 16
jeq_cont.1875:
	jmp	jle_cont.1873
jle_else.1872:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.349
	addi	%g1, %g1, 16
jle_cont.1873:
jeq_cont.1871:
	jmp	jle_cont.1869
jle_else.1868:
	addi	%g11, %g0, 8
	mvhi	%g12, 122
	mvlo	%g12, 4608
	jlt	%g12, %g10, jle_else.1876
	jne	%g12, %g10, jeq_else.1878
	addi	%g3, %g0, 8
	jmp	jeq_cont.1879
jeq_else.1878:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.349
	addi	%g1, %g1, 16
jeq_cont.1879:
	jmp	jle_cont.1877
jle_else.1876:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.349
	addi	%g1, %g1, 16
jle_cont.1877:
jle_cont.1869:
jle_cont.1853:
	mvhi	%g11, 15
	mvlo	%g11, 16960
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1880
	ld	%g11, %g1, 8
	jne	%g11, %g0, jeq_else.1882
	addi	%g3, %g0, 0
	jmp	jeq_cont.1883
jeq_else.1882:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1883:
	jmp	jle_cont.1881
jle_else.1880:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1881:
	mvhi	%g4, 1
	mvlo	%g4, 34464
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 7
	mvlo	%g12, 41248
	st	%g3, %g1, 12
	jlt	%g12, %g10, jle_else.1884
	jne	%g12, %g10, jeq_else.1886
	addi	%g3, %g0, 5
	jmp	jeq_cont.1887
jeq_else.1886:
	addi	%g6, %g0, 2
	mvhi	%g12, 3
	mvlo	%g12, 3392
	jlt	%g12, %g10, jle_else.1888
	jne	%g12, %g10, jeq_else.1890
	addi	%g3, %g0, 2
	jmp	jeq_cont.1891
jeq_else.1890:
	addi	%g11, %g0, 1
	mvhi	%g12, 1
	mvlo	%g12, 34464
	jlt	%g12, %g10, jle_else.1892
	jne	%g12, %g10, jeq_else.1894
	addi	%g3, %g0, 1
	jmp	jeq_cont.1895
jeq_else.1894:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.349
	addi	%g1, %g1, 24
jeq_cont.1895:
	jmp	jle_cont.1893
jle_else.1892:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.349
	addi	%g1, %g1, 24
jle_cont.1893:
jeq_cont.1891:
	jmp	jle_cont.1889
jle_else.1888:
	addi	%g5, %g0, 3
	mvhi	%g12, 4
	mvlo	%g12, 37856
	jlt	%g12, %g10, jle_else.1896
	jne	%g12, %g10, jeq_else.1898
	addi	%g3, %g0, 3
	jmp	jeq_cont.1899
jeq_else.1898:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.349
	addi	%g1, %g1, 24
jeq_cont.1899:
	jmp	jle_cont.1897
jle_else.1896:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.349
	addi	%g1, %g1, 24
jle_cont.1897:
jle_cont.1889:
jeq_cont.1887:
	jmp	jle_cont.1885
jle_else.1884:
	addi	%g5, %g0, 7
	mvhi	%g12, 10
	mvlo	%g12, 44640
	jlt	%g12, %g10, jle_else.1900
	jne	%g12, %g10, jeq_else.1902
	addi	%g3, %g0, 7
	jmp	jeq_cont.1903
jeq_else.1902:
	addi	%g6, %g0, 6
	mvhi	%g12, 9
	mvlo	%g12, 10176
	jlt	%g12, %g10, jle_else.1904
	jne	%g12, %g10, jeq_else.1906
	addi	%g3, %g0, 6
	jmp	jeq_cont.1907
jeq_else.1906:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.349
	addi	%g1, %g1, 24
jeq_cont.1907:
	jmp	jle_cont.1905
jle_else.1904:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.349
	addi	%g1, %g1, 24
jle_cont.1905:
jeq_cont.1903:
	jmp	jle_cont.1901
jle_else.1900:
	addi	%g11, %g0, 8
	mvhi	%g12, 12
	mvlo	%g12, 13568
	jlt	%g12, %g10, jle_else.1908
	jne	%g12, %g10, jeq_else.1910
	addi	%g3, %g0, 8
	jmp	jeq_cont.1911
jeq_else.1910:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.349
	addi	%g1, %g1, 24
jeq_cont.1911:
	jmp	jle_cont.1909
jle_else.1908:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.349
	addi	%g1, %g1, 24
jle_cont.1909:
jle_cont.1901:
jle_cont.1885:
	mvhi	%g11, 1
	mvlo	%g11, 34464
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1912
	ld	%g11, %g1, 12
	jne	%g11, %g0, jeq_else.1914
	addi	%g3, %g0, 0
	jmp	jeq_cont.1915
jeq_else.1914:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1915:
	jmp	jle_cont.1913
jle_else.1912:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1913:
	addi	%g4, %g0, 10000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 0
	mvlo	%g12, 50000
	st	%g3, %g1, 16
	jlt	%g12, %g10, jle_else.1916
	jne	%g12, %g10, jeq_else.1918
	addi	%g3, %g0, 5
	jmp	jeq_cont.1919
jeq_else.1918:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20000
	jlt	%g12, %g10, jle_else.1920
	jne	%g12, %g10, jeq_else.1922
	addi	%g3, %g0, 2
	jmp	jeq_cont.1923
jeq_else.1922:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10000
	jlt	%g12, %g10, jle_else.1924
	jne	%g12, %g10, jeq_else.1926
	addi	%g3, %g0, 1
	jmp	jeq_cont.1927
jeq_else.1926:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.349
	addi	%g1, %g1, 24
jeq_cont.1927:
	jmp	jle_cont.1925
jle_else.1924:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.349
	addi	%g1, %g1, 24
jle_cont.1925:
jeq_cont.1923:
	jmp	jle_cont.1921
jle_else.1920:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30000
	jlt	%g12, %g10, jle_else.1928
	jne	%g12, %g10, jeq_else.1930
	addi	%g3, %g0, 3
	jmp	jeq_cont.1931
jeq_else.1930:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.349
	addi	%g1, %g1, 24
jeq_cont.1931:
	jmp	jle_cont.1929
jle_else.1928:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.349
	addi	%g1, %g1, 24
jle_cont.1929:
jle_cont.1921:
jeq_cont.1919:
	jmp	jle_cont.1917
jle_else.1916:
	addi	%g5, %g0, 7
	mvhi	%g12, 1
	mvlo	%g12, 4464
	jlt	%g12, %g10, jle_else.1932
	jne	%g12, %g10, jeq_else.1934
	addi	%g3, %g0, 7
	jmp	jeq_cont.1935
jeq_else.1934:
	addi	%g6, %g0, 6
	mvhi	%g12, 0
	mvlo	%g12, 60000
	jlt	%g12, %g10, jle_else.1936
	jne	%g12, %g10, jeq_else.1938
	addi	%g3, %g0, 6
	jmp	jeq_cont.1939
jeq_else.1938:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.349
	addi	%g1, %g1, 24
jeq_cont.1939:
	jmp	jle_cont.1937
jle_else.1936:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.349
	addi	%g1, %g1, 24
jle_cont.1937:
jeq_cont.1935:
	jmp	jle_cont.1933
jle_else.1932:
	addi	%g11, %g0, 8
	mvhi	%g12, 1
	mvlo	%g12, 14464
	jlt	%g12, %g10, jle_else.1940
	jne	%g12, %g10, jeq_else.1942
	addi	%g3, %g0, 8
	jmp	jeq_cont.1943
jeq_else.1942:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.349
	addi	%g1, %g1, 24
jeq_cont.1943:
	jmp	jle_cont.1941
jle_else.1940:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.349
	addi	%g1, %g1, 24
jle_cont.1941:
jle_cont.1933:
jle_cont.1917:
	addi	%g11, %g0, 10000
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1944
	ld	%g11, %g1, 16
	jne	%g11, %g0, jeq_else.1946
	addi	%g3, %g0, 0
	jmp	jeq_cont.1947
jeq_else.1946:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1947:
	jmp	jle_cont.1945
jle_else.1944:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1945:
	addi	%g4, %g0, 1000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 5000
	st	%g3, %g1, 20
	jlt	%g12, %g10, jle_else.1948
	jne	%g12, %g10, jeq_else.1950
	addi	%g3, %g0, 5
	jmp	jeq_cont.1951
jeq_else.1950:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 2000
	jlt	%g12, %g10, jle_else.1952
	jne	%g12, %g10, jeq_else.1954
	addi	%g3, %g0, 2
	jmp	jeq_cont.1955
jeq_else.1954:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 1000
	jlt	%g12, %g10, jle_else.1956
	jne	%g12, %g10, jeq_else.1958
	addi	%g3, %g0, 1
	jmp	jeq_cont.1959
jeq_else.1958:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.349
	addi	%g1, %g1, 32
jeq_cont.1959:
	jmp	jle_cont.1957
jle_else.1956:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.349
	addi	%g1, %g1, 32
jle_cont.1957:
jeq_cont.1955:
	jmp	jle_cont.1953
jle_else.1952:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 3000
	jlt	%g12, %g10, jle_else.1960
	jne	%g12, %g10, jeq_else.1962
	addi	%g3, %g0, 3
	jmp	jeq_cont.1963
jeq_else.1962:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.349
	addi	%g1, %g1, 32
jeq_cont.1963:
	jmp	jle_cont.1961
jle_else.1960:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.349
	addi	%g1, %g1, 32
jle_cont.1961:
jle_cont.1953:
jeq_cont.1951:
	jmp	jle_cont.1949
jle_else.1948:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 7000
	jlt	%g12, %g10, jle_else.1964
	jne	%g12, %g10, jeq_else.1966
	addi	%g3, %g0, 7
	jmp	jeq_cont.1967
jeq_else.1966:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 6000
	jlt	%g12, %g10, jle_else.1968
	jne	%g12, %g10, jeq_else.1970
	addi	%g3, %g0, 6
	jmp	jeq_cont.1971
jeq_else.1970:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.349
	addi	%g1, %g1, 32
jeq_cont.1971:
	jmp	jle_cont.1969
jle_else.1968:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.349
	addi	%g1, %g1, 32
jle_cont.1969:
jeq_cont.1967:
	jmp	jle_cont.1965
jle_else.1964:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 8000
	jlt	%g12, %g10, jle_else.1972
	jne	%g12, %g10, jeq_else.1974
	addi	%g3, %g0, 8
	jmp	jeq_cont.1975
jeq_else.1974:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.349
	addi	%g1, %g1, 32
jeq_cont.1975:
	jmp	jle_cont.1973
jle_else.1972:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.349
	addi	%g1, %g1, 32
jle_cont.1973:
jle_cont.1965:
jle_cont.1949:
	muli	%g11, %g3, 1000
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1976
	ld	%g11, %g1, 20
	jne	%g11, %g0, jeq_else.1978
	addi	%g3, %g0, 0
	jmp	jeq_cont.1979
jeq_else.1978:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1979:
	jmp	jle_cont.1977
jle_else.1976:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1977:
	addi	%g4, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 500
	st	%g3, %g1, 24
	jlt	%g12, %g10, jle_else.1980
	jne	%g12, %g10, jeq_else.1982
	addi	%g3, %g0, 5
	jmp	jeq_cont.1983
jeq_else.1982:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 200
	jlt	%g12, %g10, jle_else.1984
	jne	%g12, %g10, jeq_else.1986
	addi	%g3, %g0, 2
	jmp	jeq_cont.1987
jeq_else.1986:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 100
	jlt	%g12, %g10, jle_else.1988
	jne	%g12, %g10, jeq_else.1990
	addi	%g3, %g0, 1
	jmp	jeq_cont.1991
jeq_else.1990:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.349
	addi	%g1, %g1, 32
jeq_cont.1991:
	jmp	jle_cont.1989
jle_else.1988:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.349
	addi	%g1, %g1, 32
jle_cont.1989:
jeq_cont.1987:
	jmp	jle_cont.1985
jle_else.1984:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 300
	jlt	%g12, %g10, jle_else.1992
	jne	%g12, %g10, jeq_else.1994
	addi	%g3, %g0, 3
	jmp	jeq_cont.1995
jeq_else.1994:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.349
	addi	%g1, %g1, 32
jeq_cont.1995:
	jmp	jle_cont.1993
jle_else.1992:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.349
	addi	%g1, %g1, 32
jle_cont.1993:
jle_cont.1985:
jeq_cont.1983:
	jmp	jle_cont.1981
jle_else.1980:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 700
	jlt	%g12, %g10, jle_else.1996
	jne	%g12, %g10, jeq_else.1998
	addi	%g3, %g0, 7
	jmp	jeq_cont.1999
jeq_else.1998:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 600
	jlt	%g12, %g10, jle_else.2000
	jne	%g12, %g10, jeq_else.2002
	addi	%g3, %g0, 6
	jmp	jeq_cont.2003
jeq_else.2002:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.349
	addi	%g1, %g1, 32
jeq_cont.2003:
	jmp	jle_cont.2001
jle_else.2000:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.349
	addi	%g1, %g1, 32
jle_cont.2001:
jeq_cont.1999:
	jmp	jle_cont.1997
jle_else.1996:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 800
	jlt	%g12, %g10, jle_else.2004
	jne	%g12, %g10, jeq_else.2006
	addi	%g3, %g0, 8
	jmp	jeq_cont.2007
jeq_else.2006:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.349
	addi	%g1, %g1, 32
jeq_cont.2007:
	jmp	jle_cont.2005
jle_else.2004:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.349
	addi	%g1, %g1, 32
jle_cont.2005:
jle_cont.1997:
jle_cont.1981:
	muli	%g11, %g3, 100
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2008
	ld	%g11, %g1, 24
	jne	%g11, %g0, jeq_else.2010
	addi	%g3, %g0, 0
	jmp	jeq_cont.2011
jeq_else.2010:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2011:
	jmp	jle_cont.2009
jle_else.2008:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2009:
	addi	%g4, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 50
	st	%g3, %g1, 28
	jlt	%g12, %g10, jle_else.2012
	jne	%g12, %g10, jeq_else.2014
	addi	%g3, %g0, 5
	jmp	jeq_cont.2015
jeq_else.2014:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20
	jlt	%g12, %g10, jle_else.2016
	jne	%g12, %g10, jeq_else.2018
	addi	%g3, %g0, 2
	jmp	jeq_cont.2019
jeq_else.2018:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10
	jlt	%g12, %g10, jle_else.2020
	jne	%g12, %g10, jeq_else.2022
	addi	%g3, %g0, 1
	jmp	jeq_cont.2023
jeq_else.2022:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.349
	addi	%g1, %g1, 40
jeq_cont.2023:
	jmp	jle_cont.2021
jle_else.2020:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.349
	addi	%g1, %g1, 40
jle_cont.2021:
jeq_cont.2019:
	jmp	jle_cont.2017
jle_else.2016:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30
	jlt	%g12, %g10, jle_else.2024
	jne	%g12, %g10, jeq_else.2026
	addi	%g3, %g0, 3
	jmp	jeq_cont.2027
jeq_else.2026:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.349
	addi	%g1, %g1, 40
jeq_cont.2027:
	jmp	jle_cont.2025
jle_else.2024:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.349
	addi	%g1, %g1, 40
jle_cont.2025:
jle_cont.2017:
jeq_cont.2015:
	jmp	jle_cont.2013
jle_else.2012:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 70
	jlt	%g12, %g10, jle_else.2028
	jne	%g12, %g10, jeq_else.2030
	addi	%g3, %g0, 7
	jmp	jeq_cont.2031
jeq_else.2030:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 60
	jlt	%g12, %g10, jle_else.2032
	jne	%g12, %g10, jeq_else.2034
	addi	%g3, %g0, 6
	jmp	jeq_cont.2035
jeq_else.2034:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.349
	addi	%g1, %g1, 40
jeq_cont.2035:
	jmp	jle_cont.2033
jle_else.2032:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.349
	addi	%g1, %g1, 40
jle_cont.2033:
jeq_cont.2031:
	jmp	jle_cont.2029
jle_else.2028:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 80
	jlt	%g12, %g10, jle_else.2036
	jne	%g12, %g10, jeq_else.2038
	addi	%g3, %g0, 8
	jmp	jeq_cont.2039
jeq_else.2038:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.349
	addi	%g1, %g1, 40
jeq_cont.2039:
	jmp	jle_cont.2037
jle_else.2036:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.349
	addi	%g1, %g1, 40
jle_cont.2037:
jle_cont.2029:
jle_cont.2013:
	muli	%g11, %g3, 10
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2040
	ld	%g11, %g1, 28
	jne	%g11, %g0, jeq_else.2042
	addi	%g3, %g0, 0
	jmp	jeq_cont.2043
jeq_else.2042:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2043:
	jmp	jle_cont.2041
jle_else.2040:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2041:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g10
	output	%g3
	return
jge_else.1809:
	addi	%g10, %g0, 45
	st	%g3, %g1, 32
	output	%g10
	ld	%g3, %g1, 32
	sub	%g3, %g0, %g3
	jmp	print_int.354
min_caml_start:
	addi	%g28, %g0, 1
	addi	%g29, %g0, -1
	setL %g26, l.1503
	fld	%f16, %g26, 0
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
	mov	%g10, %g3
	fmov	%f0, %f16
	subi	%g1, %g1, 8
	call	min_caml_truncate
	addi	%g1, %g1, 8
	subi	%g1, %g1, 8
	call	print_int.354
	addi	%g1, %g1, 8
	halt
