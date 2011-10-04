#include <stdint.h>
// Instruction Set ////////////////////////////////////
enum InstSet {
ADD,SUB,MUL,DIV,ADDI,SUBI,MULI,DIVI,INPUT,OUTPUT,AND,OR,
NOT,SLL,SRL,JUMP,JEQ,CALL,RETURN,LD,ST,FADD,FSUB,FMUL,
FDIV,FLD,FST,NOP,HALT,
};

// Register ///////////////////////////////////////////
#define REG_NUM 32
enum Register {
REG0,REG1,REG2,REG3,REG4,REG5,REG6,REG7,
REG8,REG9,REG10,REG11,REG12,REG13,REG14,REG15,
REG16,REG17,REG18,REG19,REG20,REG21,REG22,REG23,
REG24,REG25,REG26,REG27,REG28,REG29,REG30,REG31
};
uint32_t reg[REG_NUM];

// Memory ////////////////////////////////////////////
#define MEM_NUM 256
uint32_t rom[MEM_NUM];
uint32_t ram[MEM_NUM];

// DEFINE Instrucion ////////////////////////////////
// USAGE 
// DEFINE_R(add, ADD)
////////////////////////////////////////////////////

#define DEFINE_R(name, opcode) \
	uint32_t name(uint8_t rs, uint8_t rt, uint8_t rd,uint8_t shamt, uint8_t funct) {\
		return (opcode << 26 | ((uint32_t)rs << 21) | ((uint32_t) rt << 16)\
				| ((uint32_t) rd << 11) | ((uint32_t) shamt << 6) | funct);\
	}
#define DEFINE_I(name, opcode) \
	uint32_t name(uint8_t rs, uint8_t rt, uint16_t imm) {\
		return (opcode << 26 | ((uint32_t)rs << 21) | ((uint32_t) rt << 16) | imm);\
	}
#define DEFINE_J(name, opcode) \
	uint32_t name(uint32_t target) {\
		return (opcode << 26 | target);\
	}

// define element access
#define DEF_ELE_ACC(name, shift, mask) \
	uint32_t name(uint32_t ir) {\
		return ((ir >> shift) & mask);\
	}

