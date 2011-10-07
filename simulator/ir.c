#include "setup.h"

#define DEFINE_R(name, opcode) \
	uint32_t name(uint8_t rs, uint8_t rt, uint8_t rd, uint8_t shaft, uint8_t funct) {\
		return (opcode << 26 | ((uint32_t)rs << 21) | ((uint32_t) rt << 16)\
				| ((uint32_t) rd << 11) | ((uint32_t) shaft << 6) |funct);\
	}
#define DEFINE_I(name, opcode) \
	uint32_t name(uint8_t rs, uint8_t rt, uint16_t imm) {\
		return (opcode << 26 | ((uint32_t)rs << 21) | ((uint32_t) rt << 16) | imm);\
	}
#define DEFINE_J(name, opcode) \
	uint32_t name(uint32_t target) {\
		return (opcode << 26 | target);\
	}

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
DEFINE_I(slli,SLLI);
DEFINE_J(jmp,JMP);
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
