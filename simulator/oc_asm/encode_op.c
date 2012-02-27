#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include "oc_asm.h"

static int rd,rs,rt,imm;
static char inst_name[COL_MAX];
static char label_name[COL_MAX];

#define test(x) asm_fmt_##x
#undef myscan
#define myscan(fmt, ...) \
	(sscanf(asm_line, asm_fmt_##fmt, inst_name, ##__VA_ARGS__) - 1)
static inline int _inst_is(char *inst, const char *str) {
	return strcmp(inst, str) == 0;
}
#define inst_is(str) _inst_is(inst, str)

#define mask_sll(dig,sw,x) shift_left_l(sw, eff_dig(dig, x))
#define set_opcode() mask_sll(6, 26, opcode)
#define set_rs() mask_sll(5, 21, rs)
#define set_rt() mask_sll(5, 16, rt)
#define set_rd() mask_sll(5, 11, rd)
#define set_shamt() mask_sll(5, 6, shamt)
#define set_funct() mask_sll(6, 0, funct)
#define set_imm() mask_sll(16, 0, imm)
#define set_target() mask_sll(26, 0, target)
static inline uint32_t _fmt_r(uint8_t opcode, uint8_t rs, uint8_t rt, uint8_t rd,
							uint8_t shamt, uint8_t funct) {
	return set_opcode() | set_rs() | set_rt() | set_rd() | set_shamt() | set_funct();
}
static inline uint32_t fmt_sp(uint8_t rs, uint8_t rt, uint8_t rd, uint8_t funct) {
	
	return _fmt_r(SPECIAL,rs,rt,rd,0,funct);
}
static inline uint32_t fmt_io(uint8_t rs, uint8_t rd, uint8_t funct) {
	return _fmt_r(IO,rs,0,rd,0,funct);
}
static inline uint32_t fmt_fpi(uint8_t rs, uint8_t rt, uint8_t rd, uint8_t funct) {
	return _fmt_r(FPI,rs,rt,rd,0,funct);
}
static inline uint32_t fmt_i(uint8_t opcode, uint8_t rs, uint8_t rt, uint16_t imm) {
	return set_opcode() | set_rs() | set_rt() | set_imm();
}
static inline uint32_t fmt_j(uint8_t opcode, uint32_t target) {
	return set_opcode() | set_target();
}
uint32_t encode_op(char *asm_line, char *inst)
{
	
// Special Instructions
	if (inst_is("add")) {
		if (myscan(iggg, &rd, &rs, &rt) == 3) {

			return fmt_sp(rs,rt,rd,ADD_F);
		}
	}
	if (inst_is("sub")) {
		if (myscan(iggg, &rd, &rs, &rt) == 3) {
			return fmt_sp(rs,rt,rd,SUB_F);
		}
	}
	if (inst_is("mul")) {
		if (myscan(iggg, &rd, &rs, &rt) == 3) {
			return fmt_sp(rs,rt,rd,MUL_F);
		}
	}
	if (inst_is("b")) {
		if (myscan(ig, &rs) == 1)
		    return fmt_sp(rs,0,0,B_F);
	}

	if (inst_is("callR")) {
		if (myscan(ig, &rs) == 2) {
			return fmt_sp(rs,0,0,CALLR_F);
		}
	}
	if (inst_is("fst")) {
		if (myscan(ifgg, &rd, &rs, &rt) == 3) {
			return fmt_sp(rs,rt,rd,FST_F);
		}
	}
	if (inst_is("fld")) {
		if (myscan(ifgg, &rd, &rs, &rt) == 3) {
			return fmt_sp(rs,rt,rd,FLD_F);
		}
	}
	if (inst_is("halt")) {
		    return fmt_sp(0,0,0,HALT_F);
	}
// I/O Instructions
	if (inst_is("input")) {
		if (myscan(ig, &rd) == 1) {
			return fmt_io(0,rd,INPUT_F);
		}
	}
	if (inst_is("output")) {
		if (myscan(ig, &rs) == 1) {
			return fmt_io(rs,0,OUTPUT_F);
		}
	}
// Floating-Point Instructions
	if (inst_is("fadd")) {
		if (myscan(ifff, &rd, &rs, &rt) == 3) {
			return fmt_fpi(rs,rt,rd,FADD_F);
		}
	}
	if (inst_is("fsub")) {
		if (myscan(ifff, &rd, &rs, &rt) == 3) {
			return fmt_fpi(rs,rt,rd,FSUB_F);
		}
	}
	if (inst_is("fmul")) {
		if (myscan(ifff, &rd, &rs, &rt) == 3) {
			return fmt_fpi(rs,rt,rd,FMUL_F);
		}
	}
	if (inst_is("fdiv")) {
		if (myscan(ifff, &rd, &rs, &rt) == 3) {
			return fmt_fpi(rs,rt,rd,FDIV_F);
		}
	}
	if (inst_is("fsqrt")) {
		if (myscan(iff, &rd, &rs) == 2) {
			return fmt_fpi(rs,0,rd,FSQRT_F);
		}
	}
	if (inst_is("fabs")) {
		if (myscan(iff, &rd, &rs) == 2) {
			return fmt_fpi(rs,0,rd,FABS_F);
		}
	}
	if (inst_is("fmov")) {
		if (myscan(iff, &rd, &rs) == 2) {
			return fmt_fpi(rs,0,rd,FMOV_F);
		}
	}
	if (inst_is("fneg")) {
		if (myscan(iff, &rd, &rs) == 2) {
			return fmt_fpi(rs,0,rd,FNEG_F);
		}
	}

// Other Instructions
	if (inst_is("mvlo")) {
		if (myscan(igi, &rs, &imm) == 2) {
		    return fmt_i(MVLO,rs,0,imm);
		}
	}
	if (inst_is("mvhi")) {
		if (myscan(igi, &rs, &imm) == 2) {
			return fmt_i(MVHI,rs,0,imm);
		}
	}
	if (inst_is("addi")) {
		if (myscan(iggi, &rt, &rs, &imm) == 3) {
		    return fmt_i(ADDI,rs,rt,imm);
		}
	}
	if (inst_is("subi")) {
		if (myscan(iggi, &rt, &rs, &imm) == 3) {
		    return fmt_i(SUBI,rs,rt,imm);
		}
	}
	if (inst_is("muli")) {
		if (myscan(iggi, &rt, &rs, &imm) == 3) {
		    return fmt_i(MULI,rs,rt,imm);
		}
	}
	if (inst_is("slli")) {
		if (myscan(iggi, &rt, &rs, &imm) == 3) {
		    return fmt_i(SLLI,rs,rt,imm);
		}
	}
	if (inst_is("srli")) {
		if (myscan(iggi, &rt, &rs, &imm) == 3) {
		    return fmt_i(SRLI,rs,rt,imm);
		}
	}
	if (inst_is("fjeq")) {
		if (myscan(iffl, &rs, &rt, label_name) == 3) {
			register_linst_rel(label_name);
			return fmt_i(FJEQ,rs,rt,0);
		}
	}
	if (inst_is("fjlt")) {
		if (myscan(iffl, &rs, &rt, label_name) == 3) {
			register_linst_rel(label_name);
			return fmt_i(FJLT,rs,rt,0);
		}
	}
	if (inst_is("call")) {
		if (myscan(il, label_name) == 1) {
			register_linst_abs(label_name);
		    return fmt_j(CALL,0);
		}
	}
	if (inst_is("return")) {
		    return fmt_j(RETURN,0);
	}
	if (inst_is("jeq")) {
		if (myscan(iggl, &rs, &rt, label_name) == 3) {
			register_linst_rel(label_name);
			return fmt_i(JEQ,rs,rt,0);
		}
	}
	if (inst_is("jne")) {
		if (myscan(iggl, &rs, &rt, label_name) == 3) {
			register_linst_rel(label_name);
			return fmt_i(JNE,rs,rt,0);
		}
	}
	if (inst_is("jlt")) {
		if (myscan(iggl, &rs, &rt, label_name) == 3) {
			register_linst_rel(label_name);
			return fmt_i(JLT,rs,rt,0);
		}
	}
	if (inst_is("jmp")) {
		if (myscan(il, label_name) == 1) {
			register_linst_abs(label_name);
			return fmt_j(JMP,0);
		}
	}
	if (inst_is("st")) {
		if (myscan(iggg, &rd, &rs, &rt) == 3) {
			return _fmt_r(ST,rs,rt,rd,0,0);
		}
	}
	if (inst_is("ld")) {
		if (myscan(iggg, &rd, &rs, &rt) == 3) {
			return _fmt_r(LD,rs,rt,rd,0,0);
		}
	}
	if (inst_is("sti")) {
		if (myscan(iggi, &rt, &rs, &imm) == 3) {
			return fmt_i(STI,rs,rt,imm);
		}
	}
	if (inst_is("fsti")) {
		if (myscan(ifgi, &rt, &rs, &imm) == 3) {
			return fmt_i(FSTI,rs,rt,imm);
		}
	}
	if (inst_is("ldi")) {
		if (myscan(iggi, &rt, &rs, &imm) == 3) {
			return fmt_i(LDI,rs,rt,imm);
		}
	}
	if (inst_is("fldi")) {
		if (myscan(ifgi, &rt, &rs, &imm) == 3) {
			return fmt_i(FLDI,rs,rt,imm);
		}
	}
	return 0xffffffff;
}
