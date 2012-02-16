.init_heap_size 32
FLOAT_ONE:
	.long 0x3f800000
	
start:
	mvlo %g3, 48
	output %g3

	subi	%g1, %g1, 32
	addi %g28, %g0, 1
	addi %g29, %g0, -1
	addi %g15, %g0, 54
	sti %g15, %g31, 4
	
!!!! call NewLine
	stlr %g1, 0
	subi %g1, %g1, 4
	link 8
	jmp NewLine

!1
	mvlo %g3, 98
	srli %g3, %g3, 1
	output %g3
!!!! call NewLine
	stlr %g1, 0
	subi %g1, %g1, 4
	link 8
	jmp NewLine

!2
	mvlo %g3, 25
	slli %g3, %g3, 1
	output %g3
!!!! call NewLine
	stlr %g1, 0
	subi %g1, %g1, 4
	link 8
	jmp NewLine

!3
	mvhi %g3, 51
	srli %g3, %g3, 16
	output %g3
!!!! call NewLine
	stlr %g1, 0
	subi %g1, %g1, 4
	link 8
	jmp NewLine

	srli %g3, %g29, 1 ! 0xffffffff
	mvhi %g3, 0		  ! 0x0000ffff
	srli %g3, %g3, 12 ! 0x0000000f
	mvlo %g4, 3
	mul %g3, %g3, %g4 ! 45
	mvlo %g4, 7
	add %g3, %g3, %g4  ! 52
	output %g3
!!!! call NewLine
	stlr %g1, 0
	subi %g1, %g1, 4
	link 8
	jmp NewLine


	ldi %g3, %g31, 4
	sub %g3, %g3, %g28
	output %g3
!!!! call NewLine
	stlr %g1, 0
	subi %g1, %g1, 4
	link 8
	jmp NewLine

	addi %g3, %g0, 48
	addi %g6, %g0, 54
	addi %g7, %g0, 55
	addi %g8, %g0, 56
	addi %g9, %g0, 48

	jeq %g3, %g9, Ltrue6
	output %g3
Ltrue6:
	output %g6

	jlt %g29, %g28, Ltrue7
	output %g3
Ltrue7:
	output %g7

	add %g4, %g0, %g29
	mvhi %g4, 0
	jne %g4, %g29, Ltrue8
	output %g3
Ltrue8:
	output %g8
	
!!!! call NewLine
	stlr %g1, 0
	subi %g1, %g1, 4
	link 8
	jmp NewLine

	halt

! jeq jne jlt output mvhi slli mvlo srli subi stlr 
!link jmp btmplr addi ldlr movlr halt
NewLine:
	mvlo %g10, 10
	output %g10
	movlr
	addi %g1, %g1, 4
	ldlr %g1, 0
	btmplr
