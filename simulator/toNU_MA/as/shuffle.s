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
div_binary_search.338:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1701
	mov	%g3, %g5
	return
jle_else.1701:
	jlt	%g8, %g3, jle_else.1702
	jne	%g8, %g3, jeq_else.1703
	mov	%g3, %g7
	return
jeq_else.1703:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1704
	mov	%g3, %g5
	return
jle_else.1704:
	jlt	%g8, %g3, jle_else.1705
	jne	%g8, %g3, jeq_else.1706
	mov	%g3, %g6
	return
jeq_else.1706:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1707
	mov	%g3, %g5
	return
jle_else.1707:
	jlt	%g8, %g3, jle_else.1708
	jne	%g8, %g3, jeq_else.1709
	mov	%g3, %g7
	return
jeq_else.1709:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1710
	mov	%g3, %g5
	return
jle_else.1710:
	jlt	%g8, %g3, jle_else.1711
	jne	%g8, %g3, jeq_else.1712
	mov	%g3, %g6
	return
jeq_else.1712:
	jmp	div_binary_search.338
jle_else.1711:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.338
jle_else.1708:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1713
	mov	%g3, %g7
	return
jle_else.1713:
	jlt	%g8, %g3, jle_else.1714
	jne	%g8, %g3, jeq_else.1715
	mov	%g3, %g5
	return
jeq_else.1715:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.338
jle_else.1714:
	jmp	div_binary_search.338
jle_else.1705:
	add	%g5, %g6, %g7
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g7, %g6
	jlt	%g28, %g9, jle_else.1716
	mov	%g3, %g6
	return
jle_else.1716:
	jlt	%g8, %g3, jle_else.1717
	jne	%g8, %g3, jeq_else.1718
	mov	%g3, %g5
	return
jeq_else.1718:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.1719
	mov	%g3, %g6
	return
jle_else.1719:
	jlt	%g8, %g3, jle_else.1720
	jne	%g8, %g3, jeq_else.1721
	mov	%g3, %g7
	return
jeq_else.1721:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.338
jle_else.1720:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.338
jle_else.1717:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1722
	mov	%g3, %g5
	return
jle_else.1722:
	jlt	%g8, %g3, jle_else.1723
	jne	%g8, %g3, jeq_else.1724
	mov	%g3, %g6
	return
jeq_else.1724:
	jmp	div_binary_search.338
jle_else.1723:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.338
jle_else.1702:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1725
	mov	%g3, %g7
	return
jle_else.1725:
	jlt	%g8, %g3, jle_else.1726
	jne	%g8, %g3, jeq_else.1727
	mov	%g3, %g5
	return
jeq_else.1727:
	add	%g6, %g7, %g5
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g5, %g7
	jlt	%g28, %g9, jle_else.1728
	mov	%g3, %g7
	return
jle_else.1728:
	jlt	%g8, %g3, jle_else.1729
	jne	%g8, %g3, jeq_else.1730
	mov	%g3, %g6
	return
jeq_else.1730:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1731
	mov	%g3, %g7
	return
jle_else.1731:
	jlt	%g8, %g3, jle_else.1732
	jne	%g8, %g3, jeq_else.1733
	mov	%g3, %g5
	return
jeq_else.1733:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.338
jle_else.1732:
	jmp	div_binary_search.338
jle_else.1729:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.1734
	mov	%g3, %g6
	return
jle_else.1734:
	jlt	%g8, %g3, jle_else.1735
	jne	%g8, %g3, jeq_else.1736
	mov	%g3, %g7
	return
jeq_else.1736:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.338
jle_else.1735:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.338
jle_else.1726:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1737
	mov	%g3, %g5
	return
jle_else.1737:
	jlt	%g8, %g3, jle_else.1738
	jne	%g8, %g3, jeq_else.1739
	mov	%g3, %g7
	return
jeq_else.1739:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1740
	mov	%g3, %g5
	return
jle_else.1740:
	jlt	%g8, %g3, jle_else.1741
	jne	%g8, %g3, jeq_else.1742
	mov	%g3, %g6
	return
jeq_else.1742:
	jmp	div_binary_search.338
jle_else.1741:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.338
jle_else.1738:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1743
	mov	%g3, %g7
	return
jle_else.1743:
	jlt	%g8, %g3, jle_else.1744
	jne	%g8, %g3, jeq_else.1745
	mov	%g3, %g5
	return
jeq_else.1745:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.338
jle_else.1744:
	jmp	div_binary_search.338
print_int.343:
	jlt	%g3, %g0, jge_else.1746
	mvhi	%g10, 1525
	mvlo	%g10, 57600
	jlt	%g10, %g3, jle_else.1747
	jne	%g10, %g3, jeq_else.1749
	addi	%g10, %g0, 1
	jmp	jeq_cont.1750
jeq_else.1749:
	addi	%g10, %g0, 0
jeq_cont.1750:
	jmp	jle_cont.1748
jle_else.1747:
	mvhi	%g10, 3051
	mvlo	%g10, 49664
	jlt	%g10, %g3, jle_else.1751
	jne	%g10, %g3, jeq_else.1753
	addi	%g10, %g0, 2
	jmp	jeq_cont.1754
jeq_else.1753:
	addi	%g10, %g0, 1
jeq_cont.1754:
	jmp	jle_cont.1752
jle_else.1751:
	addi	%g10, %g0, 2
jle_cont.1752:
jle_cont.1748:
	mvhi	%g11, 1525
	mvlo	%g11, 57600
	mul	%g11, %g10, %g11
	sub	%g3, %g3, %g11
	st	%g3, %g1, 0
	jlt	%g0, %g10, jle_else.1755
	addi	%g3, %g0, 0
	jmp	jle_cont.1756
jle_else.1755:
	addi	%g11, %g0, 48
	add	%g10, %g11, %g10
	output	%g10
	addi	%g3, %g0, 1
jle_cont.1756:
	mvhi	%g4, 152
	mvlo	%g4, 38528
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g10, %g0, 5
	mvhi	%g11, 762
	mvlo	%g11, 61568
	ld	%g12, %g1, 0
	st	%g3, %g1, 4
	jlt	%g11, %g12, jle_else.1757
	jne	%g11, %g12, jeq_else.1759
	addi	%g3, %g0, 5
	jmp	jeq_cont.1760
jeq_else.1759:
	addi	%g6, %g0, 2
	mvhi	%g11, 305
	mvlo	%g11, 11520
	jlt	%g11, %g12, jle_else.1761
	jne	%g11, %g12, jeq_else.1763
	addi	%g3, %g0, 2
	jmp	jeq_cont.1764
jeq_else.1763:
	addi	%g10, %g0, 1
	mvhi	%g11, 152
	mvlo	%g11, 38528
	jlt	%g11, %g12, jle_else.1765
	jne	%g11, %g12, jeq_else.1767
	addi	%g3, %g0, 1
	jmp	jeq_cont.1768
jeq_else.1767:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.338
	addi	%g1, %g1, 16
jeq_cont.1768:
	jmp	jle_cont.1766
jle_else.1765:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.338
	addi	%g1, %g1, 16
jle_cont.1766:
jeq_cont.1764:
	jmp	jle_cont.1762
jle_else.1761:
	addi	%g5, %g0, 3
	mvhi	%g11, 457
	mvlo	%g11, 50048
	jlt	%g11, %g12, jle_else.1769
	jne	%g11, %g12, jeq_else.1771
	addi	%g3, %g0, 3
	jmp	jeq_cont.1772
jeq_else.1771:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.338
	addi	%g1, %g1, 16
jeq_cont.1772:
	jmp	jle_cont.1770
jle_else.1769:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.338
	addi	%g1, %g1, 16
jle_cont.1770:
jle_cont.1762:
jeq_cont.1760:
	jmp	jle_cont.1758
jle_else.1757:
	addi	%g5, %g0, 7
	mvhi	%g11, 1068
	mvlo	%g11, 7552
	jlt	%g11, %g12, jle_else.1773
	jne	%g11, %g12, jeq_else.1775
	addi	%g3, %g0, 7
	jmp	jeq_cont.1776
jeq_else.1775:
	addi	%g6, %g0, 6
	mvhi	%g11, 915
	mvlo	%g11, 34560
	jlt	%g11, %g12, jle_else.1777
	jne	%g11, %g12, jeq_else.1779
	addi	%g3, %g0, 6
	jmp	jeq_cont.1780
jeq_else.1779:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.338
	addi	%g1, %g1, 16
jeq_cont.1780:
	jmp	jle_cont.1778
jle_else.1777:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.338
	addi	%g1, %g1, 16
jle_cont.1778:
jeq_cont.1776:
	jmp	jle_cont.1774
jle_else.1773:
	addi	%g10, %g0, 8
	mvhi	%g11, 1220
	mvlo	%g11, 46080
	jlt	%g11, %g12, jle_else.1781
	jne	%g11, %g12, jeq_else.1783
	addi	%g3, %g0, 8
	jmp	jeq_cont.1784
jeq_else.1783:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.338
	addi	%g1, %g1, 16
jeq_cont.1784:
	jmp	jle_cont.1782
jle_else.1781:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.338
	addi	%g1, %g1, 16
jle_cont.1782:
jle_cont.1774:
jle_cont.1758:
	mvhi	%g10, 152
	mvlo	%g10, 38528
	mul	%g10, %g3, %g10
	sub	%g10, %g12, %g10
	jlt	%g0, %g3, jle_else.1785
	ld	%g11, %g1, 4
	jne	%g11, %g0, jeq_else.1787
	addi	%g3, %g0, 0
	jmp	jeq_cont.1788
jeq_else.1787:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1788:
	jmp	jle_cont.1786
jle_else.1785:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1786:
	mvhi	%g4, 15
	mvlo	%g4, 16960
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 76
	mvlo	%g12, 19264
	st	%g3, %g1, 8
	jlt	%g12, %g10, jle_else.1789
	jne	%g12, %g10, jeq_else.1791
	addi	%g3, %g0, 5
	jmp	jeq_cont.1792
jeq_else.1791:
	addi	%g6, %g0, 2
	mvhi	%g12, 30
	mvlo	%g12, 33920
	jlt	%g12, %g10, jle_else.1793
	jne	%g12, %g10, jeq_else.1795
	addi	%g3, %g0, 2
	jmp	jeq_cont.1796
jeq_else.1795:
	addi	%g11, %g0, 1
	mvhi	%g12, 15
	mvlo	%g12, 16960
	jlt	%g12, %g10, jle_else.1797
	jne	%g12, %g10, jeq_else.1799
	addi	%g3, %g0, 1
	jmp	jeq_cont.1800
jeq_else.1799:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.338
	addi	%g1, %g1, 16
jeq_cont.1800:
	jmp	jle_cont.1798
jle_else.1797:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.338
	addi	%g1, %g1, 16
jle_cont.1798:
jeq_cont.1796:
	jmp	jle_cont.1794
jle_else.1793:
	addi	%g5, %g0, 3
	mvhi	%g12, 45
	mvlo	%g12, 50880
	jlt	%g12, %g10, jle_else.1801
	jne	%g12, %g10, jeq_else.1803
	addi	%g3, %g0, 3
	jmp	jeq_cont.1804
jeq_else.1803:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.338
	addi	%g1, %g1, 16
jeq_cont.1804:
	jmp	jle_cont.1802
jle_else.1801:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.338
	addi	%g1, %g1, 16
jle_cont.1802:
jle_cont.1794:
jeq_cont.1792:
	jmp	jle_cont.1790
jle_else.1789:
	addi	%g5, %g0, 7
	mvhi	%g12, 106
	mvlo	%g12, 53184
	jlt	%g12, %g10, jle_else.1805
	jne	%g12, %g10, jeq_else.1807
	addi	%g3, %g0, 7
	jmp	jeq_cont.1808
jeq_else.1807:
	addi	%g6, %g0, 6
	mvhi	%g12, 91
	mvlo	%g12, 36224
	jlt	%g12, %g10, jle_else.1809
	jne	%g12, %g10, jeq_else.1811
	addi	%g3, %g0, 6
	jmp	jeq_cont.1812
jeq_else.1811:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.338
	addi	%g1, %g1, 16
jeq_cont.1812:
	jmp	jle_cont.1810
jle_else.1809:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.338
	addi	%g1, %g1, 16
jle_cont.1810:
jeq_cont.1808:
	jmp	jle_cont.1806
jle_else.1805:
	addi	%g11, %g0, 8
	mvhi	%g12, 122
	mvlo	%g12, 4608
	jlt	%g12, %g10, jle_else.1813
	jne	%g12, %g10, jeq_else.1815
	addi	%g3, %g0, 8
	jmp	jeq_cont.1816
jeq_else.1815:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.338
	addi	%g1, %g1, 16
jeq_cont.1816:
	jmp	jle_cont.1814
jle_else.1813:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.338
	addi	%g1, %g1, 16
jle_cont.1814:
jle_cont.1806:
jle_cont.1790:
	mvhi	%g11, 15
	mvlo	%g11, 16960
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1817
	ld	%g11, %g1, 8
	jne	%g11, %g0, jeq_else.1819
	addi	%g3, %g0, 0
	jmp	jeq_cont.1820
jeq_else.1819:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1820:
	jmp	jle_cont.1818
jle_else.1817:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1818:
	mvhi	%g4, 1
	mvlo	%g4, 34464
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 7
	mvlo	%g12, 41248
	st	%g3, %g1, 12
	jlt	%g12, %g10, jle_else.1821
	jne	%g12, %g10, jeq_else.1823
	addi	%g3, %g0, 5
	jmp	jeq_cont.1824
jeq_else.1823:
	addi	%g6, %g0, 2
	mvhi	%g12, 3
	mvlo	%g12, 3392
	jlt	%g12, %g10, jle_else.1825
	jne	%g12, %g10, jeq_else.1827
	addi	%g3, %g0, 2
	jmp	jeq_cont.1828
jeq_else.1827:
	addi	%g11, %g0, 1
	mvhi	%g12, 1
	mvlo	%g12, 34464
	jlt	%g12, %g10, jle_else.1829
	jne	%g12, %g10, jeq_else.1831
	addi	%g3, %g0, 1
	jmp	jeq_cont.1832
jeq_else.1831:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.338
	addi	%g1, %g1, 24
jeq_cont.1832:
	jmp	jle_cont.1830
jle_else.1829:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.338
	addi	%g1, %g1, 24
jle_cont.1830:
jeq_cont.1828:
	jmp	jle_cont.1826
jle_else.1825:
	addi	%g5, %g0, 3
	mvhi	%g12, 4
	mvlo	%g12, 37856
	jlt	%g12, %g10, jle_else.1833
	jne	%g12, %g10, jeq_else.1835
	addi	%g3, %g0, 3
	jmp	jeq_cont.1836
jeq_else.1835:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.338
	addi	%g1, %g1, 24
jeq_cont.1836:
	jmp	jle_cont.1834
jle_else.1833:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.338
	addi	%g1, %g1, 24
jle_cont.1834:
jle_cont.1826:
jeq_cont.1824:
	jmp	jle_cont.1822
jle_else.1821:
	addi	%g5, %g0, 7
	mvhi	%g12, 10
	mvlo	%g12, 44640
	jlt	%g12, %g10, jle_else.1837
	jne	%g12, %g10, jeq_else.1839
	addi	%g3, %g0, 7
	jmp	jeq_cont.1840
jeq_else.1839:
	addi	%g6, %g0, 6
	mvhi	%g12, 9
	mvlo	%g12, 10176
	jlt	%g12, %g10, jle_else.1841
	jne	%g12, %g10, jeq_else.1843
	addi	%g3, %g0, 6
	jmp	jeq_cont.1844
jeq_else.1843:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.338
	addi	%g1, %g1, 24
jeq_cont.1844:
	jmp	jle_cont.1842
jle_else.1841:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.338
	addi	%g1, %g1, 24
jle_cont.1842:
jeq_cont.1840:
	jmp	jle_cont.1838
jle_else.1837:
	addi	%g11, %g0, 8
	mvhi	%g12, 12
	mvlo	%g12, 13568
	jlt	%g12, %g10, jle_else.1845
	jne	%g12, %g10, jeq_else.1847
	addi	%g3, %g0, 8
	jmp	jeq_cont.1848
jeq_else.1847:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.338
	addi	%g1, %g1, 24
jeq_cont.1848:
	jmp	jle_cont.1846
jle_else.1845:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.338
	addi	%g1, %g1, 24
jle_cont.1846:
jle_cont.1838:
jle_cont.1822:
	mvhi	%g11, 1
	mvlo	%g11, 34464
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1849
	ld	%g11, %g1, 12
	jne	%g11, %g0, jeq_else.1851
	addi	%g3, %g0, 0
	jmp	jeq_cont.1852
jeq_else.1851:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1852:
	jmp	jle_cont.1850
jle_else.1849:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1850:
	addi	%g4, %g0, 10000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 0
	mvlo	%g12, 50000
	st	%g3, %g1, 16
	jlt	%g12, %g10, jle_else.1853
	jne	%g12, %g10, jeq_else.1855
	addi	%g3, %g0, 5
	jmp	jeq_cont.1856
jeq_else.1855:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20000
	jlt	%g12, %g10, jle_else.1857
	jne	%g12, %g10, jeq_else.1859
	addi	%g3, %g0, 2
	jmp	jeq_cont.1860
jeq_else.1859:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10000
	jlt	%g12, %g10, jle_else.1861
	jne	%g12, %g10, jeq_else.1863
	addi	%g3, %g0, 1
	jmp	jeq_cont.1864
jeq_else.1863:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.338
	addi	%g1, %g1, 24
jeq_cont.1864:
	jmp	jle_cont.1862
jle_else.1861:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.338
	addi	%g1, %g1, 24
jle_cont.1862:
jeq_cont.1860:
	jmp	jle_cont.1858
jle_else.1857:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30000
	jlt	%g12, %g10, jle_else.1865
	jne	%g12, %g10, jeq_else.1867
	addi	%g3, %g0, 3
	jmp	jeq_cont.1868
jeq_else.1867:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.338
	addi	%g1, %g1, 24
jeq_cont.1868:
	jmp	jle_cont.1866
jle_else.1865:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.338
	addi	%g1, %g1, 24
jle_cont.1866:
jle_cont.1858:
jeq_cont.1856:
	jmp	jle_cont.1854
jle_else.1853:
	addi	%g5, %g0, 7
	mvhi	%g12, 1
	mvlo	%g12, 4464
	jlt	%g12, %g10, jle_else.1869
	jne	%g12, %g10, jeq_else.1871
	addi	%g3, %g0, 7
	jmp	jeq_cont.1872
jeq_else.1871:
	addi	%g6, %g0, 6
	mvhi	%g12, 0
	mvlo	%g12, 60000
	jlt	%g12, %g10, jle_else.1873
	jne	%g12, %g10, jeq_else.1875
	addi	%g3, %g0, 6
	jmp	jeq_cont.1876
jeq_else.1875:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.338
	addi	%g1, %g1, 24
jeq_cont.1876:
	jmp	jle_cont.1874
jle_else.1873:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.338
	addi	%g1, %g1, 24
jle_cont.1874:
jeq_cont.1872:
	jmp	jle_cont.1870
jle_else.1869:
	addi	%g11, %g0, 8
	mvhi	%g12, 1
	mvlo	%g12, 14464
	jlt	%g12, %g10, jle_else.1877
	jne	%g12, %g10, jeq_else.1879
	addi	%g3, %g0, 8
	jmp	jeq_cont.1880
jeq_else.1879:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.338
	addi	%g1, %g1, 24
jeq_cont.1880:
	jmp	jle_cont.1878
jle_else.1877:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.338
	addi	%g1, %g1, 24
jle_cont.1878:
jle_cont.1870:
jle_cont.1854:
	addi	%g11, %g0, 10000
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1881
	ld	%g11, %g1, 16
	jne	%g11, %g0, jeq_else.1883
	addi	%g3, %g0, 0
	jmp	jeq_cont.1884
jeq_else.1883:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1884:
	jmp	jle_cont.1882
jle_else.1881:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1882:
	addi	%g4, %g0, 1000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 5000
	st	%g3, %g1, 20
	jlt	%g12, %g10, jle_else.1885
	jne	%g12, %g10, jeq_else.1887
	addi	%g3, %g0, 5
	jmp	jeq_cont.1888
jeq_else.1887:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 2000
	jlt	%g12, %g10, jle_else.1889
	jne	%g12, %g10, jeq_else.1891
	addi	%g3, %g0, 2
	jmp	jeq_cont.1892
jeq_else.1891:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 1000
	jlt	%g12, %g10, jle_else.1893
	jne	%g12, %g10, jeq_else.1895
	addi	%g3, %g0, 1
	jmp	jeq_cont.1896
jeq_else.1895:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.338
	addi	%g1, %g1, 32
jeq_cont.1896:
	jmp	jle_cont.1894
jle_else.1893:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.338
	addi	%g1, %g1, 32
jle_cont.1894:
jeq_cont.1892:
	jmp	jle_cont.1890
jle_else.1889:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 3000
	jlt	%g12, %g10, jle_else.1897
	jne	%g12, %g10, jeq_else.1899
	addi	%g3, %g0, 3
	jmp	jeq_cont.1900
jeq_else.1899:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.338
	addi	%g1, %g1, 32
jeq_cont.1900:
	jmp	jle_cont.1898
jle_else.1897:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.338
	addi	%g1, %g1, 32
jle_cont.1898:
jle_cont.1890:
jeq_cont.1888:
	jmp	jle_cont.1886
jle_else.1885:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 7000
	jlt	%g12, %g10, jle_else.1901
	jne	%g12, %g10, jeq_else.1903
	addi	%g3, %g0, 7
	jmp	jeq_cont.1904
jeq_else.1903:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 6000
	jlt	%g12, %g10, jle_else.1905
	jne	%g12, %g10, jeq_else.1907
	addi	%g3, %g0, 6
	jmp	jeq_cont.1908
jeq_else.1907:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.338
	addi	%g1, %g1, 32
jeq_cont.1908:
	jmp	jle_cont.1906
jle_else.1905:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.338
	addi	%g1, %g1, 32
jle_cont.1906:
jeq_cont.1904:
	jmp	jle_cont.1902
jle_else.1901:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 8000
	jlt	%g12, %g10, jle_else.1909
	jne	%g12, %g10, jeq_else.1911
	addi	%g3, %g0, 8
	jmp	jeq_cont.1912
jeq_else.1911:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.338
	addi	%g1, %g1, 32
jeq_cont.1912:
	jmp	jle_cont.1910
jle_else.1909:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.338
	addi	%g1, %g1, 32
jle_cont.1910:
jle_cont.1902:
jle_cont.1886:
	muli	%g11, %g3, 1000
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1913
	ld	%g11, %g1, 20
	jne	%g11, %g0, jeq_else.1915
	addi	%g3, %g0, 0
	jmp	jeq_cont.1916
jeq_else.1915:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1916:
	jmp	jle_cont.1914
jle_else.1913:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1914:
	addi	%g4, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 500
	st	%g3, %g1, 24
	jlt	%g12, %g10, jle_else.1917
	jne	%g12, %g10, jeq_else.1919
	addi	%g3, %g0, 5
	jmp	jeq_cont.1920
jeq_else.1919:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 200
	jlt	%g12, %g10, jle_else.1921
	jne	%g12, %g10, jeq_else.1923
	addi	%g3, %g0, 2
	jmp	jeq_cont.1924
jeq_else.1923:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 100
	jlt	%g12, %g10, jle_else.1925
	jne	%g12, %g10, jeq_else.1927
	addi	%g3, %g0, 1
	jmp	jeq_cont.1928
jeq_else.1927:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.338
	addi	%g1, %g1, 32
jeq_cont.1928:
	jmp	jle_cont.1926
jle_else.1925:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.338
	addi	%g1, %g1, 32
jle_cont.1926:
jeq_cont.1924:
	jmp	jle_cont.1922
jle_else.1921:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 300
	jlt	%g12, %g10, jle_else.1929
	jne	%g12, %g10, jeq_else.1931
	addi	%g3, %g0, 3
	jmp	jeq_cont.1932
jeq_else.1931:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.338
	addi	%g1, %g1, 32
jeq_cont.1932:
	jmp	jle_cont.1930
jle_else.1929:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.338
	addi	%g1, %g1, 32
jle_cont.1930:
jle_cont.1922:
jeq_cont.1920:
	jmp	jle_cont.1918
jle_else.1917:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 700
	jlt	%g12, %g10, jle_else.1933
	jne	%g12, %g10, jeq_else.1935
	addi	%g3, %g0, 7
	jmp	jeq_cont.1936
jeq_else.1935:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 600
	jlt	%g12, %g10, jle_else.1937
	jne	%g12, %g10, jeq_else.1939
	addi	%g3, %g0, 6
	jmp	jeq_cont.1940
jeq_else.1939:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.338
	addi	%g1, %g1, 32
jeq_cont.1940:
	jmp	jle_cont.1938
jle_else.1937:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.338
	addi	%g1, %g1, 32
jle_cont.1938:
jeq_cont.1936:
	jmp	jle_cont.1934
jle_else.1933:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 800
	jlt	%g12, %g10, jle_else.1941
	jne	%g12, %g10, jeq_else.1943
	addi	%g3, %g0, 8
	jmp	jeq_cont.1944
jeq_else.1943:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.338
	addi	%g1, %g1, 32
jeq_cont.1944:
	jmp	jle_cont.1942
jle_else.1941:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.338
	addi	%g1, %g1, 32
jle_cont.1942:
jle_cont.1934:
jle_cont.1918:
	muli	%g11, %g3, 100
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1945
	ld	%g11, %g1, 24
	jne	%g11, %g0, jeq_else.1947
	addi	%g3, %g0, 0
	jmp	jeq_cont.1948
jeq_else.1947:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1948:
	jmp	jle_cont.1946
jle_else.1945:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1946:
	addi	%g4, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 50
	st	%g3, %g1, 28
	jlt	%g12, %g10, jle_else.1949
	jne	%g12, %g10, jeq_else.1951
	addi	%g3, %g0, 5
	jmp	jeq_cont.1952
jeq_else.1951:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20
	jlt	%g12, %g10, jle_else.1953
	jne	%g12, %g10, jeq_else.1955
	addi	%g3, %g0, 2
	jmp	jeq_cont.1956
jeq_else.1955:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10
	jlt	%g12, %g10, jle_else.1957
	jne	%g12, %g10, jeq_else.1959
	addi	%g3, %g0, 1
	jmp	jeq_cont.1960
jeq_else.1959:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.338
	addi	%g1, %g1, 40
jeq_cont.1960:
	jmp	jle_cont.1958
jle_else.1957:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.338
	addi	%g1, %g1, 40
jle_cont.1958:
jeq_cont.1956:
	jmp	jle_cont.1954
jle_else.1953:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30
	jlt	%g12, %g10, jle_else.1961
	jne	%g12, %g10, jeq_else.1963
	addi	%g3, %g0, 3
	jmp	jeq_cont.1964
jeq_else.1963:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.338
	addi	%g1, %g1, 40
jeq_cont.1964:
	jmp	jle_cont.1962
jle_else.1961:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.338
	addi	%g1, %g1, 40
jle_cont.1962:
jle_cont.1954:
jeq_cont.1952:
	jmp	jle_cont.1950
jle_else.1949:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 70
	jlt	%g12, %g10, jle_else.1965
	jne	%g12, %g10, jeq_else.1967
	addi	%g3, %g0, 7
	jmp	jeq_cont.1968
jeq_else.1967:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 60
	jlt	%g12, %g10, jle_else.1969
	jne	%g12, %g10, jeq_else.1971
	addi	%g3, %g0, 6
	jmp	jeq_cont.1972
jeq_else.1971:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.338
	addi	%g1, %g1, 40
jeq_cont.1972:
	jmp	jle_cont.1970
jle_else.1969:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.338
	addi	%g1, %g1, 40
jle_cont.1970:
jeq_cont.1968:
	jmp	jle_cont.1966
jle_else.1965:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 80
	jlt	%g12, %g10, jle_else.1973
	jne	%g12, %g10, jeq_else.1975
	addi	%g3, %g0, 8
	jmp	jeq_cont.1976
jeq_else.1975:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.338
	addi	%g1, %g1, 40
jeq_cont.1976:
	jmp	jle_cont.1974
jle_else.1973:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.338
	addi	%g1, %g1, 40
jle_cont.1974:
jle_cont.1966:
jle_cont.1950:
	muli	%g11, %g3, 10
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1977
	ld	%g11, %g1, 28
	jne	%g11, %g0, jeq_else.1979
	addi	%g3, %g0, 0
	jmp	jeq_cont.1980
jeq_else.1979:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1980:
	jmp	jle_cont.1978
jle_else.1977:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1978:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g10
	output	%g3
	return
jge_else.1746:
	addi	%g10, %g0, 45
	st	%g3, %g1, 32
	output	%g10
	ld	%g3, %g1, 32
	sub	%g3, %g0, %g3
	jmp	print_int.343
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
	addi	%g3, %g0, 1
	addi	%g13, %g0, 2
	addi	%g14, %g0, 3
	addi	%g15, %g0, 4
	addi	%g16, %g0, 5
	addi	%g17, %g0, 6
	st	%g3, %g1, 0
	mov	%g3, %g13
	subi	%g1, %g1, 8
	call	print_int.343
	addi	%g1, %g1, 8
	ld	%g3, %g1, 0
	subi	%g1, %g1, 8
	call	print_int.343
	addi	%g1, %g1, 8
	mov	%g3, %g15
	subi	%g1, %g1, 8
	call	print_int.343
	addi	%g1, %g1, 8
	mov	%g3, %g16
	subi	%g1, %g1, 8
	call	print_int.343
	addi	%g1, %g1, 8
	mov	%g3, %g17
	subi	%g1, %g1, 8
	call	print_int.343
	addi	%g1, %g1, 8
	mov	%g3, %g14
	subi	%g1, %g1, 8
	call	print_int.343
	addi	%g1, %g1, 8
	halt
