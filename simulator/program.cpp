#include "setup.h"
#include <unistd.h>
#include <stdio.h>

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
DEFINE_J(jump,JMP);
DEFINE_I(jeq,JEQ);
DEFINE_I(jne,JNE);
DEFINE_I(jlt,JLT);
DEFINE_J(call,CALL);
DEFINE_J(_return,RETURN);
DEFINE_I(ld,LD);
DEFINE_I(st,ST);
DEFINE_R(fadd,FADD);
DEFINE_R(fsub,FSUB);
DEFINE_R(fmul,FMUL);
DEFINE_R(fdiv,FDIV);
DEFINE_R(fld,FLD);
DEFINE_R(fst,FST);
DEFINE_R(nop,NOP);
DEFINE_R(halt,HALT);

// rom$B$KL?Na<B9TNs$r=q$-9~$`(B
void program(uint32_t *rom, int fd) {
	int ret, i;
	ret = read(fd, rom, MEM_NUM);
}
