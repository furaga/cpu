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
	jlt	%g28, %g9, jle_else.1674
	mov	%g3, %g5
	return
jle_else.1674:
	jlt	%g8, %g3, jle_else.1675
	jne	%g8, %g3, jeq_else.1676
	mov	%g3, %g7
	return
jeq_else.1676:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1677
	mov	%g3, %g5
	return
jle_else.1677:
	jlt	%g8, %g3, jle_else.1678
	jne	%g8, %g3, jeq_else.1679
	mov	%g3, %g6
	return
jeq_else.1679:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1680
	mov	%g3, %g5
	return
jle_else.1680:
	jlt	%g8, %g3, jle_else.1681
	jne	%g8, %g3, jeq_else.1682
	mov	%g3, %g7
	return
jeq_else.1682:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1683
	mov	%g3, %g5
	return
jle_else.1683:
	jlt	%g8, %g3, jle_else.1684
	jne	%g8, %g3, jeq_else.1685
	mov	%g3, %g6
	return
jeq_else.1685:
	jmp	div_binary_search.335
jle_else.1684:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.335
jle_else.1681:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1686
	mov	%g3, %g7
	return
jle_else.1686:
	jlt	%g8, %g3, jle_else.1687
	jne	%g8, %g3, jeq_else.1688
	mov	%g3, %g5
	return
jeq_else.1688:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.335
jle_else.1687:
	jmp	div_binary_search.335
jle_else.1678:
	add	%g5, %g6, %g7
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g7, %g6
	jlt	%g28, %g9, jle_else.1689
	mov	%g3, %g6
	return
jle_else.1689:
	jlt	%g8, %g3, jle_else.1690
	jne	%g8, %g3, jeq_else.1691
	mov	%g3, %g5
	return
jeq_else.1691:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.1692
	mov	%g3, %g6
	return
jle_else.1692:
	jlt	%g8, %g3, jle_else.1693
	jne	%g8, %g3, jeq_else.1694
	mov	%g3, %g7
	return
jeq_else.1694:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.335
jle_else.1693:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.335
jle_else.1690:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1695
	mov	%g3, %g5
	return
jle_else.1695:
	jlt	%g8, %g3, jle_else.1696
	jne	%g8, %g3, jeq_else.1697
	mov	%g3, %g6
	return
jeq_else.1697:
	jmp	div_binary_search.335
jle_else.1696:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.335
jle_else.1675:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1698
	mov	%g3, %g7
	return
jle_else.1698:
	jlt	%g8, %g3, jle_else.1699
	jne	%g8, %g3, jeq_else.1700
	mov	%g3, %g5
	return
jeq_else.1700:
	add	%g6, %g7, %g5
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g5, %g7
	jlt	%g28, %g9, jle_else.1701
	mov	%g3, %g7
	return
jle_else.1701:
	jlt	%g8, %g3, jle_else.1702
	jne	%g8, %g3, jeq_else.1703
	mov	%g3, %g6
	return
jeq_else.1703:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1704
	mov	%g3, %g7
	return
jle_else.1704:
	jlt	%g8, %g3, jle_else.1705
	jne	%g8, %g3, jeq_else.1706
	mov	%g3, %g5
	return
jeq_else.1706:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.335
jle_else.1705:
	jmp	div_binary_search.335
jle_else.1702:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.1707
	mov	%g3, %g6
	return
jle_else.1707:
	jlt	%g8, %g3, jle_else.1708
	jne	%g8, %g3, jeq_else.1709
	mov	%g3, %g7
	return
jeq_else.1709:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.335
jle_else.1708:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.335
jle_else.1699:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.1710
	mov	%g3, %g5
	return
jle_else.1710:
	jlt	%g8, %g3, jle_else.1711
	jne	%g8, %g3, jeq_else.1712
	mov	%g3, %g7
	return
jeq_else.1712:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.1713
	mov	%g3, %g5
	return
jle_else.1713:
	jlt	%g8, %g3, jle_else.1714
	jne	%g8, %g3, jeq_else.1715
	mov	%g3, %g6
	return
jeq_else.1715:
	jmp	div_binary_search.335
jle_else.1714:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.335
jle_else.1711:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.1716
	mov	%g3, %g7
	return
jle_else.1716:
	jlt	%g8, %g3, jle_else.1717
	jne	%g8, %g3, jeq_else.1718
	mov	%g3, %g5
	return
jeq_else.1718:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.335
jle_else.1717:
	jmp	div_binary_search.335
print_int.340:
	jlt	%g3, %g0, jge_else.1719
	mvhi	%g10, 1525
	mvlo	%g10, 57600
	jlt	%g10, %g3, jle_else.1720
	jne	%g10, %g3, jeq_else.1722
	addi	%g10, %g0, 1
	jmp	jeq_cont.1723
jeq_else.1722:
	addi	%g10, %g0, 0
jeq_cont.1723:
	jmp	jle_cont.1721
jle_else.1720:
	mvhi	%g10, 3051
	mvlo	%g10, 49664
	jlt	%g10, %g3, jle_else.1724
	jne	%g10, %g3, jeq_else.1726
	addi	%g10, %g0, 2
	jmp	jeq_cont.1727
jeq_else.1726:
	addi	%g10, %g0, 1
jeq_cont.1727:
	jmp	jle_cont.1725
jle_else.1724:
	addi	%g10, %g0, 2
jle_cont.1725:
jle_cont.1721:
	mvhi	%g11, 1525
	mvlo	%g11, 57600
	mul	%g11, %g10, %g11
	sub	%g3, %g3, %g11
	st	%g3, %g1, 0
	jlt	%g0, %g10, jle_else.1728
	addi	%g3, %g0, 0
	jmp	jle_cont.1729
jle_else.1728:
	addi	%g11, %g0, 48
	add	%g10, %g11, %g10
	output	%g10
	addi	%g3, %g0, 1
jle_cont.1729:
	mvhi	%g4, 152
	mvlo	%g4, 38528
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g10, %g0, 5
	mvhi	%g11, 762
	mvlo	%g11, 61568
	ld	%g12, %g1, 0
	st	%g3, %g1, 4
	jlt	%g11, %g12, jle_else.1730
	jne	%g11, %g12, jeq_else.1732
	addi	%g3, %g0, 5
	jmp	jeq_cont.1733
jeq_else.1732:
	addi	%g6, %g0, 2
	mvhi	%g11, 305
	mvlo	%g11, 11520
	jlt	%g11, %g12, jle_else.1734
	jne	%g11, %g12, jeq_else.1736
	addi	%g3, %g0, 2
	jmp	jeq_cont.1737
jeq_else.1736:
	addi	%g10, %g0, 1
	mvhi	%g11, 152
	mvlo	%g11, 38528
	jlt	%g11, %g12, jle_else.1738
	jne	%g11, %g12, jeq_else.1740
	addi	%g3, %g0, 1
	jmp	jeq_cont.1741
jeq_else.1740:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jeq_cont.1741:
	jmp	jle_cont.1739
jle_else.1738:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jle_cont.1739:
jeq_cont.1737:
	jmp	jle_cont.1735
jle_else.1734:
	addi	%g5, %g0, 3
	mvhi	%g11, 457
	mvlo	%g11, 50048
	jlt	%g11, %g12, jle_else.1742
	jne	%g11, %g12, jeq_else.1744
	addi	%g3, %g0, 3
	jmp	jeq_cont.1745
jeq_else.1744:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jeq_cont.1745:
	jmp	jle_cont.1743
jle_else.1742:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jle_cont.1743:
jle_cont.1735:
jeq_cont.1733:
	jmp	jle_cont.1731
jle_else.1730:
	addi	%g5, %g0, 7
	mvhi	%g11, 1068
	mvlo	%g11, 7552
	jlt	%g11, %g12, jle_else.1746
	jne	%g11, %g12, jeq_else.1748
	addi	%g3, %g0, 7
	jmp	jeq_cont.1749
jeq_else.1748:
	addi	%g6, %g0, 6
	mvhi	%g11, 915
	mvlo	%g11, 34560
	jlt	%g11, %g12, jle_else.1750
	jne	%g11, %g12, jeq_else.1752
	addi	%g3, %g0, 6
	jmp	jeq_cont.1753
jeq_else.1752:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jeq_cont.1753:
	jmp	jle_cont.1751
jle_else.1750:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jle_cont.1751:
jeq_cont.1749:
	jmp	jle_cont.1747
jle_else.1746:
	addi	%g10, %g0, 8
	mvhi	%g11, 1220
	mvlo	%g11, 46080
	jlt	%g11, %g12, jle_else.1754
	jne	%g11, %g12, jeq_else.1756
	addi	%g3, %g0, 8
	jmp	jeq_cont.1757
jeq_else.1756:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jeq_cont.1757:
	jmp	jle_cont.1755
jle_else.1754:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jle_cont.1755:
jle_cont.1747:
jle_cont.1731:
	mvhi	%g10, 152
	mvlo	%g10, 38528
	mul	%g10, %g3, %g10
	sub	%g10, %g12, %g10
	jlt	%g0, %g3, jle_else.1758
	ld	%g11, %g1, 4
	jne	%g11, %g0, jeq_else.1760
	addi	%g3, %g0, 0
	jmp	jeq_cont.1761
jeq_else.1760:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1761:
	jmp	jle_cont.1759
jle_else.1758:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1759:
	mvhi	%g4, 15
	mvlo	%g4, 16960
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 76
	mvlo	%g12, 19264
	st	%g3, %g1, 8
	jlt	%g12, %g10, jle_else.1762
	jne	%g12, %g10, jeq_else.1764
	addi	%g3, %g0, 5
	jmp	jeq_cont.1765
jeq_else.1764:
	addi	%g6, %g0, 2
	mvhi	%g12, 30
	mvlo	%g12, 33920
	jlt	%g12, %g10, jle_else.1766
	jne	%g12, %g10, jeq_else.1768
	addi	%g3, %g0, 2
	jmp	jeq_cont.1769
jeq_else.1768:
	addi	%g11, %g0, 1
	mvhi	%g12, 15
	mvlo	%g12, 16960
	jlt	%g12, %g10, jle_else.1770
	jne	%g12, %g10, jeq_else.1772
	addi	%g3, %g0, 1
	jmp	jeq_cont.1773
jeq_else.1772:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jeq_cont.1773:
	jmp	jle_cont.1771
jle_else.1770:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jle_cont.1771:
jeq_cont.1769:
	jmp	jle_cont.1767
jle_else.1766:
	addi	%g5, %g0, 3
	mvhi	%g12, 45
	mvlo	%g12, 50880
	jlt	%g12, %g10, jle_else.1774
	jne	%g12, %g10, jeq_else.1776
	addi	%g3, %g0, 3
	jmp	jeq_cont.1777
jeq_else.1776:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jeq_cont.1777:
	jmp	jle_cont.1775
jle_else.1774:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jle_cont.1775:
jle_cont.1767:
jeq_cont.1765:
	jmp	jle_cont.1763
jle_else.1762:
	addi	%g5, %g0, 7
	mvhi	%g12, 106
	mvlo	%g12, 53184
	jlt	%g12, %g10, jle_else.1778
	jne	%g12, %g10, jeq_else.1780
	addi	%g3, %g0, 7
	jmp	jeq_cont.1781
jeq_else.1780:
	addi	%g6, %g0, 6
	mvhi	%g12, 91
	mvlo	%g12, 36224
	jlt	%g12, %g10, jle_else.1782
	jne	%g12, %g10, jeq_else.1784
	addi	%g3, %g0, 6
	jmp	jeq_cont.1785
jeq_else.1784:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jeq_cont.1785:
	jmp	jle_cont.1783
jle_else.1782:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jle_cont.1783:
jeq_cont.1781:
	jmp	jle_cont.1779
jle_else.1778:
	addi	%g11, %g0, 8
	mvhi	%g12, 122
	mvlo	%g12, 4608
	jlt	%g12, %g10, jle_else.1786
	jne	%g12, %g10, jeq_else.1788
	addi	%g3, %g0, 8
	jmp	jeq_cont.1789
jeq_else.1788:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jeq_cont.1789:
	jmp	jle_cont.1787
jle_else.1786:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.335
	addi	%g1, %g1, 16
jle_cont.1787:
jle_cont.1779:
jle_cont.1763:
	mvhi	%g11, 15
	mvlo	%g11, 16960
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1790
	ld	%g11, %g1, 8
	jne	%g11, %g0, jeq_else.1792
	addi	%g3, %g0, 0
	jmp	jeq_cont.1793
jeq_else.1792:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1793:
	jmp	jle_cont.1791
jle_else.1790:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1791:
	mvhi	%g4, 1
	mvlo	%g4, 34464
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 7
	mvlo	%g12, 41248
	st	%g3, %g1, 12
	jlt	%g12, %g10, jle_else.1794
	jne	%g12, %g10, jeq_else.1796
	addi	%g3, %g0, 5
	jmp	jeq_cont.1797
jeq_else.1796:
	addi	%g6, %g0, 2
	mvhi	%g12, 3
	mvlo	%g12, 3392
	jlt	%g12, %g10, jle_else.1798
	jne	%g12, %g10, jeq_else.1800
	addi	%g3, %g0, 2
	jmp	jeq_cont.1801
jeq_else.1800:
	addi	%g11, %g0, 1
	mvhi	%g12, 1
	mvlo	%g12, 34464
	jlt	%g12, %g10, jle_else.1802
	jne	%g12, %g10, jeq_else.1804
	addi	%g3, %g0, 1
	jmp	jeq_cont.1805
jeq_else.1804:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jeq_cont.1805:
	jmp	jle_cont.1803
jle_else.1802:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jle_cont.1803:
jeq_cont.1801:
	jmp	jle_cont.1799
jle_else.1798:
	addi	%g5, %g0, 3
	mvhi	%g12, 4
	mvlo	%g12, 37856
	jlt	%g12, %g10, jle_else.1806
	jne	%g12, %g10, jeq_else.1808
	addi	%g3, %g0, 3
	jmp	jeq_cont.1809
jeq_else.1808:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jeq_cont.1809:
	jmp	jle_cont.1807
jle_else.1806:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jle_cont.1807:
jle_cont.1799:
jeq_cont.1797:
	jmp	jle_cont.1795
jle_else.1794:
	addi	%g5, %g0, 7
	mvhi	%g12, 10
	mvlo	%g12, 44640
	jlt	%g12, %g10, jle_else.1810
	jne	%g12, %g10, jeq_else.1812
	addi	%g3, %g0, 7
	jmp	jeq_cont.1813
jeq_else.1812:
	addi	%g6, %g0, 6
	mvhi	%g12, 9
	mvlo	%g12, 10176
	jlt	%g12, %g10, jle_else.1814
	jne	%g12, %g10, jeq_else.1816
	addi	%g3, %g0, 6
	jmp	jeq_cont.1817
jeq_else.1816:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jeq_cont.1817:
	jmp	jle_cont.1815
jle_else.1814:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jle_cont.1815:
jeq_cont.1813:
	jmp	jle_cont.1811
jle_else.1810:
	addi	%g11, %g0, 8
	mvhi	%g12, 12
	mvlo	%g12, 13568
	jlt	%g12, %g10, jle_else.1818
	jne	%g12, %g10, jeq_else.1820
	addi	%g3, %g0, 8
	jmp	jeq_cont.1821
jeq_else.1820:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jeq_cont.1821:
	jmp	jle_cont.1819
jle_else.1818:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jle_cont.1819:
jle_cont.1811:
jle_cont.1795:
	mvhi	%g11, 1
	mvlo	%g11, 34464
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1822
	ld	%g11, %g1, 12
	jne	%g11, %g0, jeq_else.1824
	addi	%g3, %g0, 0
	jmp	jeq_cont.1825
jeq_else.1824:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1825:
	jmp	jle_cont.1823
jle_else.1822:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1823:
	addi	%g4, %g0, 10000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 0
	mvlo	%g12, 50000
	st	%g3, %g1, 16
	jlt	%g12, %g10, jle_else.1826
	jne	%g12, %g10, jeq_else.1828
	addi	%g3, %g0, 5
	jmp	jeq_cont.1829
jeq_else.1828:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20000
	jlt	%g12, %g10, jle_else.1830
	jne	%g12, %g10, jeq_else.1832
	addi	%g3, %g0, 2
	jmp	jeq_cont.1833
jeq_else.1832:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10000
	jlt	%g12, %g10, jle_else.1834
	jne	%g12, %g10, jeq_else.1836
	addi	%g3, %g0, 1
	jmp	jeq_cont.1837
jeq_else.1836:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jeq_cont.1837:
	jmp	jle_cont.1835
jle_else.1834:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jle_cont.1835:
jeq_cont.1833:
	jmp	jle_cont.1831
jle_else.1830:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30000
	jlt	%g12, %g10, jle_else.1838
	jne	%g12, %g10, jeq_else.1840
	addi	%g3, %g0, 3
	jmp	jeq_cont.1841
jeq_else.1840:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jeq_cont.1841:
	jmp	jle_cont.1839
jle_else.1838:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jle_cont.1839:
jle_cont.1831:
jeq_cont.1829:
	jmp	jle_cont.1827
jle_else.1826:
	addi	%g5, %g0, 7
	mvhi	%g12, 1
	mvlo	%g12, 4464
	jlt	%g12, %g10, jle_else.1842
	jne	%g12, %g10, jeq_else.1844
	addi	%g3, %g0, 7
	jmp	jeq_cont.1845
jeq_else.1844:
	addi	%g6, %g0, 6
	mvhi	%g12, 0
	mvlo	%g12, 60000
	jlt	%g12, %g10, jle_else.1846
	jne	%g12, %g10, jeq_else.1848
	addi	%g3, %g0, 6
	jmp	jeq_cont.1849
jeq_else.1848:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jeq_cont.1849:
	jmp	jle_cont.1847
jle_else.1846:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jle_cont.1847:
jeq_cont.1845:
	jmp	jle_cont.1843
jle_else.1842:
	addi	%g11, %g0, 8
	mvhi	%g12, 1
	mvlo	%g12, 14464
	jlt	%g12, %g10, jle_else.1850
	jne	%g12, %g10, jeq_else.1852
	addi	%g3, %g0, 8
	jmp	jeq_cont.1853
jeq_else.1852:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jeq_cont.1853:
	jmp	jle_cont.1851
jle_else.1850:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.335
	addi	%g1, %g1, 24
jle_cont.1851:
jle_cont.1843:
jle_cont.1827:
	addi	%g11, %g0, 10000
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1854
	ld	%g11, %g1, 16
	jne	%g11, %g0, jeq_else.1856
	addi	%g3, %g0, 0
	jmp	jeq_cont.1857
jeq_else.1856:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1857:
	jmp	jle_cont.1855
jle_else.1854:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1855:
	addi	%g4, %g0, 1000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 5000
	st	%g3, %g1, 20
	jlt	%g12, %g10, jle_else.1858
	jne	%g12, %g10, jeq_else.1860
	addi	%g3, %g0, 5
	jmp	jeq_cont.1861
jeq_else.1860:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 2000
	jlt	%g12, %g10, jle_else.1862
	jne	%g12, %g10, jeq_else.1864
	addi	%g3, %g0, 2
	jmp	jeq_cont.1865
jeq_else.1864:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 1000
	jlt	%g12, %g10, jle_else.1866
	jne	%g12, %g10, jeq_else.1868
	addi	%g3, %g0, 1
	jmp	jeq_cont.1869
jeq_else.1868:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jeq_cont.1869:
	jmp	jle_cont.1867
jle_else.1866:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jle_cont.1867:
jeq_cont.1865:
	jmp	jle_cont.1863
jle_else.1862:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 3000
	jlt	%g12, %g10, jle_else.1870
	jne	%g12, %g10, jeq_else.1872
	addi	%g3, %g0, 3
	jmp	jeq_cont.1873
jeq_else.1872:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jeq_cont.1873:
	jmp	jle_cont.1871
jle_else.1870:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jle_cont.1871:
jle_cont.1863:
jeq_cont.1861:
	jmp	jle_cont.1859
jle_else.1858:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 7000
	jlt	%g12, %g10, jle_else.1874
	jne	%g12, %g10, jeq_else.1876
	addi	%g3, %g0, 7
	jmp	jeq_cont.1877
jeq_else.1876:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 6000
	jlt	%g12, %g10, jle_else.1878
	jne	%g12, %g10, jeq_else.1880
	addi	%g3, %g0, 6
	jmp	jeq_cont.1881
jeq_else.1880:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jeq_cont.1881:
	jmp	jle_cont.1879
jle_else.1878:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jle_cont.1879:
jeq_cont.1877:
	jmp	jle_cont.1875
jle_else.1874:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 8000
	jlt	%g12, %g10, jle_else.1882
	jne	%g12, %g10, jeq_else.1884
	addi	%g3, %g0, 8
	jmp	jeq_cont.1885
jeq_else.1884:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jeq_cont.1885:
	jmp	jle_cont.1883
jle_else.1882:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jle_cont.1883:
jle_cont.1875:
jle_cont.1859:
	muli	%g11, %g3, 1000
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1886
	ld	%g11, %g1, 20
	jne	%g11, %g0, jeq_else.1888
	addi	%g3, %g0, 0
	jmp	jeq_cont.1889
jeq_else.1888:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1889:
	jmp	jle_cont.1887
jle_else.1886:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1887:
	addi	%g4, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 500
	st	%g3, %g1, 24
	jlt	%g12, %g10, jle_else.1890
	jne	%g12, %g10, jeq_else.1892
	addi	%g3, %g0, 5
	jmp	jeq_cont.1893
jeq_else.1892:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 200
	jlt	%g12, %g10, jle_else.1894
	jne	%g12, %g10, jeq_else.1896
	addi	%g3, %g0, 2
	jmp	jeq_cont.1897
jeq_else.1896:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 100
	jlt	%g12, %g10, jle_else.1898
	jne	%g12, %g10, jeq_else.1900
	addi	%g3, %g0, 1
	jmp	jeq_cont.1901
jeq_else.1900:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jeq_cont.1901:
	jmp	jle_cont.1899
jle_else.1898:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jle_cont.1899:
jeq_cont.1897:
	jmp	jle_cont.1895
jle_else.1894:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 300
	jlt	%g12, %g10, jle_else.1902
	jne	%g12, %g10, jeq_else.1904
	addi	%g3, %g0, 3
	jmp	jeq_cont.1905
jeq_else.1904:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jeq_cont.1905:
	jmp	jle_cont.1903
jle_else.1902:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jle_cont.1903:
jle_cont.1895:
jeq_cont.1893:
	jmp	jle_cont.1891
jle_else.1890:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 700
	jlt	%g12, %g10, jle_else.1906
	jne	%g12, %g10, jeq_else.1908
	addi	%g3, %g0, 7
	jmp	jeq_cont.1909
jeq_else.1908:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 600
	jlt	%g12, %g10, jle_else.1910
	jne	%g12, %g10, jeq_else.1912
	addi	%g3, %g0, 6
	jmp	jeq_cont.1913
jeq_else.1912:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jeq_cont.1913:
	jmp	jle_cont.1911
jle_else.1910:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jle_cont.1911:
jeq_cont.1909:
	jmp	jle_cont.1907
jle_else.1906:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 800
	jlt	%g12, %g10, jle_else.1914
	jne	%g12, %g10, jeq_else.1916
	addi	%g3, %g0, 8
	jmp	jeq_cont.1917
jeq_else.1916:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jeq_cont.1917:
	jmp	jle_cont.1915
jle_else.1914:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.335
	addi	%g1, %g1, 32
jle_cont.1915:
jle_cont.1907:
jle_cont.1891:
	muli	%g11, %g3, 100
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1918
	ld	%g11, %g1, 24
	jne	%g11, %g0, jeq_else.1920
	addi	%g3, %g0, 0
	jmp	jeq_cont.1921
jeq_else.1920:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1921:
	jmp	jle_cont.1919
jle_else.1918:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1919:
	addi	%g4, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 50
	st	%g3, %g1, 28
	jlt	%g12, %g10, jle_else.1922
	jne	%g12, %g10, jeq_else.1924
	addi	%g3, %g0, 5
	jmp	jeq_cont.1925
jeq_else.1924:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20
	jlt	%g12, %g10, jle_else.1926
	jne	%g12, %g10, jeq_else.1928
	addi	%g3, %g0, 2
	jmp	jeq_cont.1929
jeq_else.1928:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10
	jlt	%g12, %g10, jle_else.1930
	jne	%g12, %g10, jeq_else.1932
	addi	%g3, %g0, 1
	jmp	jeq_cont.1933
jeq_else.1932:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.335
	addi	%g1, %g1, 40
jeq_cont.1933:
	jmp	jle_cont.1931
jle_else.1930:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.335
	addi	%g1, %g1, 40
jle_cont.1931:
jeq_cont.1929:
	jmp	jle_cont.1927
jle_else.1926:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30
	jlt	%g12, %g10, jle_else.1934
	jne	%g12, %g10, jeq_else.1936
	addi	%g3, %g0, 3
	jmp	jeq_cont.1937
jeq_else.1936:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.335
	addi	%g1, %g1, 40
jeq_cont.1937:
	jmp	jle_cont.1935
jle_else.1934:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.335
	addi	%g1, %g1, 40
jle_cont.1935:
jle_cont.1927:
jeq_cont.1925:
	jmp	jle_cont.1923
jle_else.1922:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 70
	jlt	%g12, %g10, jle_else.1938
	jne	%g12, %g10, jeq_else.1940
	addi	%g3, %g0, 7
	jmp	jeq_cont.1941
jeq_else.1940:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 60
	jlt	%g12, %g10, jle_else.1942
	jne	%g12, %g10, jeq_else.1944
	addi	%g3, %g0, 6
	jmp	jeq_cont.1945
jeq_else.1944:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.335
	addi	%g1, %g1, 40
jeq_cont.1945:
	jmp	jle_cont.1943
jle_else.1942:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.335
	addi	%g1, %g1, 40
jle_cont.1943:
jeq_cont.1941:
	jmp	jle_cont.1939
jle_else.1938:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 80
	jlt	%g12, %g10, jle_else.1946
	jne	%g12, %g10, jeq_else.1948
	addi	%g3, %g0, 8
	jmp	jeq_cont.1949
jeq_else.1948:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.335
	addi	%g1, %g1, 40
jeq_cont.1949:
	jmp	jle_cont.1947
jle_else.1946:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.335
	addi	%g1, %g1, 40
jle_cont.1947:
jle_cont.1939:
jle_cont.1923:
	muli	%g11, %g3, 10
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.1950
	ld	%g11, %g1, 28
	jne	%g11, %g0, jeq_else.1952
	addi	%g3, %g0, 0
	jmp	jeq_cont.1953
jeq_else.1952:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.1953:
	jmp	jle_cont.1951
jle_else.1950:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.1951:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g10
	output	%g3
	return
jge_else.1719:
	addi	%g10, %g0, 45
	st	%g3, %g1, 32
	output	%g10
	ld	%g3, %g1, 32
	sub	%g3, %g0, %g3
	jmp	print_int.340
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
	addi	%g3, %g0, 912
	subi	%g1, %g1, 8
	call	print_int.340
	addi	%g1, %g1, 8
	halt
