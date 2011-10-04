#include "setup.h"

DEFINE_R(mov,MOV);
DEFINE_I(mvhi, MVHI);
DEFINE_I(mvlo, MVLO);
DEFINE_R(add,ADD);
DEFINE_R(sub,SUB);
DEFINE_R(mul,MUL);
DEFINE_R(div,DIV);
DEFINE_I(addi,ADDI);
DEFINE_I(subi,SUBI);
DEFINE_I(muli,MULI);
DEFINE_I(divi,DIVI);
DEFINE_R(input,INPUT);
DEFINE_R(output,OUTPUT);
DEFINE_R(_and,AND);
DEFINE_R(_or,OR);
DEFINE_R(_not,NOT);
DEFINE_R(sll,SLL);
DEFINE_R(srl,SRL);
DEFINE_J(jump,J);
DEFINE_I(jeq,JEQ);
DEFINE_I(jne,JNE);
DEFINE_I(jlt,JLT);
DEFINE_J(call,CALL);
DEFINE_J(_return,RETURN);
DEFINE_R(ld,LD);
DEFINE_R(st,ST);
DEFINE_R(fadd,FADD);
DEFINE_R(fsub,FSUB);
DEFINE_R(fmul,FMUL);
DEFINE_R(fdiv,FDIV);
DEFINE_R(fld,FLD);
DEFINE_R(fst,FST);
DEFINE_R(nop,NOP);
DEFINE_R(halt,HALT);

void program(void)
{
	int i;
	rom[0] = addi(REG1,REG1,1);
	for (i = 1; i < 30; i++) {
		rom[i++]	=	add(REG0,REG1,REG2,0,0);
		rom[i++]	=	mov(REG1,0,REG0,0,0);
		rom[i]		=	mov(REG2,0,REG1,0,0);
	}
	rom[i] = halt(0,0,0,0,0);
}
