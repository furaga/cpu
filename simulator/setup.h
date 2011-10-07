#ifndef _SIM_SETUP
#define _SIM_SETUP

#include <stdint.h>
// Instruction Set ////////////////////////////////////
#define InstNum 42
enum InstSet {
NOP,MOV,MVHI,MVLO,ADD,SUB,MUL,DIV,ADDI,SUBI,MULI,DIVI,INPUT,OUTPUT,AND,OR,NOT,SLL,SLLI,SRL,B,JMP,JEQ,JNE,JLT,JLE,CALL,RETURN,LD,ST,FADD,FSUB,FMUL,FDIV,FMOV,FNEG,FBEQ,FBLT,FLD,FST,HALT,SETL,
};

// Register ///////////////////////////////////////////
#define REG_NUM 32
extern int32_t reg[];
extern uint32_t freg[];


// Memory ////////////////////////////////////////////
#define MEM_NUM (2 * 1024 * 1024)
extern uint32_t rom[];
extern uint32_t ram[];

// DEFINE Instrucion ////////////////////////////////
// USAGE 
// DEFINE_R(add, ADD)
// opcodeInit() is necessary
////////////////////////////////////////////////////
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
PROTO_R(srl,SRL);				//
PROTO_I(slli,SLLI);				//
PROTO_J(jmp,JMP);				//
PROTO_I(jeq,JEQ);
PROTO_I(jne,JNE);
PROTO_I(jlt,JLT);				//
PROTO_J(call,CALL);				//
PROTO_J(_return,RETURN);				//
PROTO_I(ld,LD);				//
PROTO_I(st,ST);				//
PROTO_R(fadd,FADD);
PROTO_R(fsub,FSUB);
PROTO_R(fmul,FMUL);
PROTO_R(fdiv,FDIV);
PROTO_R(fld,FLD);
PROTO_R(fst,FST);
PROTO_R(nop,NOP);				//
PROTO_R(halt,HALT);				//
#endif
