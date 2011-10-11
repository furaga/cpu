
#ifndef _ASM_HEAD
#define _ASM_HEAD
#include "common.h"
// DEFINE Instrucion ////////////////////////////////
// USAGE 
// DEFINE_R(add, ADD)
// PROTO_R(add, ADD)
////////////////////////////////////////////////////
#define ASM_LOG "aslog"
#define LABEL_MAX (4 * 1024)

#define PROTO_R(name, opcode) \
	uint32_t name(uint8_t, uint8_t, uint8_t, uint8_t, uint8_t);
#define PROTO_I(name, opcode) \
	uint32_t name(uint8_t, uint8_t, uint16_t);
#define PROTO_J(name, opcode) \
	uint32_t name(uint32_t);

// define element access
#define DEF_ELE_ACC(name, shift, mask) \
	uint32_t name(uint32_t ir) {\
		return ((ir >> shift) & mask);\
	}

PROTO_R(nop,NOP);				//
PROTO_R(mov,MOV);				//
PROTO_I(mvhi, MVHI);				//
PROTO_I(mvlo, MVLO);				//
PROTO_R(add,ADD);				//
PROTO_R(sub,SUB);				//
PROTO_R(mul,MUL);				//
PROTO_R(div,DIV);				//
PROTO_I(addi,ADDI);				//
PROTO_I(subi,SUBI);				//
PROTO_I(muli,MULI);				//
PROTO_I(divi,DIVI);				//
PROTO_R(input,INPUT);				//
PROTO_R(output,OUTPUT);				//
PROTO_R(_and,AND);				//
PROTO_R(_or,OR);				//
PROTO_R(_not,NOT);				//
PROTO_R(sll,SLL);				//
PROTO_I(slli,SLLI);				//
PROTO_R(srl,SRL);				//
PROTO_R(b,B);
PROTO_J(jmp,JMP);				//
PROTO_I(jeq,JEQ);				//
PROTO_I(jne,JNE);			//
PROTO_I(jlt,JLT);				//
PROTO_J(call,CALL);				//
PROTO_J(_return,RETURN);				//
PROTO_I(ld,LD);				//
PROTO_I(st,ST);				//
PROTO_R(fadd,FADD);
PROTO_R(fsub,FSUB);
PROTO_R(fmul,FMUL);
PROTO_R(fdiv,FDIV);
PROTO_I(fld,FLD);
PROTO_I(fst,FST);
PROTO_R(halt,HALT);				//
////////////////////////////////////
PROTO_I(setl,SETL);				//
PROTO_R(fmov,FMOV);
PROTO_R(fneg,FNEG);
PROTO_I(fjeq,FJEQ);
PROTO_I(fjlt,FJLT);
PROTO_R(callr,CALLR);




#endif
