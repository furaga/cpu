
#ifndef _ASM_HEAD
#define _ASM_HEAD
#include "common.h"
#include <stdint.h>
#define ASM_LOG "asmlog"
#define LABEL_MAX (128 * 1024)
#define	LINE_MAX	512	// asm$B$N0l9T$ND9$5$N:GBgCM(B
#define DATA_NUM (1024 * 1024)
extern int output_type;

#define PROTO_R(name) \
	uint32_t name(uint8_t, uint8_t, uint8_t, uint8_t, uint8_t);
#define PROTO_I(name) \
	uint32_t name(uint8_t, uint8_t, uint16_t);
#define PROTO_J(name) \
	uint32_t name(uint32_t);

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

#define PROTO_F(name)\
	uint32_t name(uint8_t, uint8_t, uint8_t, uint8_t);

#define DEFINE_F(name, opcode, funct) \
	uint32_t name(uint8_t rs, uint8_t rt, uint8_t rd, uint8_t shaft) {\
		return (opcode << 26 | ((uint32_t)rs << 21) | ((uint32_t) rt << 16)\
				| ((uint32_t) rd << 11) | ((uint32_t) shaft << 6) |funct);\
	}

// define element access
#define DEF_ELE_ACC(name, shift, mask) \
	uint32_t name(uint32_t ir) {\
		return ((ir >> shift) & mask);\
	}

PROTO_I(mvhi);
PROTO_I(mvlo);
PROTO_I(addi);
PROTO_I(subi);
PROTO_I(muli);
PROTO_I(slli);
PROTO_I(srli);
PROTO_J(jmp);
PROTO_I(jeq);
PROTO_I(jne);
PROTO_I(jlt);
PROTO_I(jle);
PROTO_J(call);
PROTO_J(_return);
PROTO_I(ldi);
PROTO_I(sti);
PROTO_I(ldlr);
PROTO_I(stlr);

PROTO_I(fldi);
PROTO_I(fsti);
PROTO_I(setl);
PROTO_I(fjeq);
PROTO_I(fjlt);

PROTO_F(mov);
PROTO_F(_not);
PROTO_F(input);
PROTO_F(inputw);
PROTO_F(inputf);
PROTO_F(output);
PROTO_F(outputw);
PROTO_F(outputf);
PROTO_F(nop);
PROTO_F(sll);
PROTO_F(srl);
PROTO_F(b);
PROTO_F(btmplr);
PROTO_F(nor);
PROTO_F(add);
PROTO_F(sub);
PROTO_F(ld);
PROTO_F(st);
PROTO_F(fld);
PROTO_F(fst);
PROTO_F(movlr);
PROTO_F(mul);
PROTO_I(padd);
PROTO_F(_and);
PROTO_F(_or);
PROTO_F(halt);
PROTO_F(callr);

PROTO_F(fadd);
PROTO_F(fsub);
PROTO_F(fmul);
PROTO_F(fdiv);
PROTO_F(fsqrt);
PROTO_F(_fabs);
PROTO_F(fmov);
PROTO_F(fneg);

PROTO_I(link);
#endif
