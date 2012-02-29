#include <stdio.h>
#include <string.h>
#include "oc_sim.h"

#define print_val(fmt, ...) \
	fprintf(fp, print_fmt_##fmt"\n", name, ##__VA_ARGS__)
#define unknown_ir() \
	fprintf(fp, "Unknown ir : opcode:%d  name:%s\n", opcode, name);


void _print_ir(uint32_t ir, FILE *fp) {
	uint8_t opcode,funct;
	const char *name;
	/*
	union {
		uint32_t i;
		float f;
	} a, b, c;
	*/
	
	fprintf(fp, "%4lx.[%4x] ", cnt, pc);

	opcode = get_opcode(ir);
	funct = get_funct(ir);
	switch (opcode) {
		case SPECIAL :
			name = SFunctMap[funct];
			break;
		case IO :
			name = IOFunctMap[funct];
			break;
		case FPI :
			name = FFunctMap[funct];
			break;
		default: 
			name = InstMap[opcode];
			break;
	}


	switch (opcode) {
		case SPECIAL :
			switch (funct) {
				case ADD_F : case SUB_F : case MUL_F : case NOR_F :
				case AND_F : case OR_F : case SLL_F : case SRL_F :
					print_val(iggg, get_rdi(ir), _GRD, get_rsi(ir), _GRS, get_rti(ir), _GRT);
					break;
				case CALLR_F : case B_F : 
					print_val(ig, get_rsi(ir), _GRS);
					break;
				case FLD_F : case FST_F :
					print_val(ifgg, get_rdi(ir), _GRD, get_rsi(ir), _GRS, get_rti(ir), _GRT);
					break;
				case HALT_F :
					print_val(i);
					break;
				default :
					unknown_ir();
					break;
			}
			break;
		case IO :
			switch (funct) {
				case INPUT_F :
					print_val(ig, get_rdi(ir), _GRD);
					break;
				case OUTPUT_F :
					print_val(ig, get_rsi(ir), _GRS);
					break;
				default :
					unknown_ir();
					break;
			}
			break;
		case FPI :
			switch (funct) {
				case FADD_F: case FSUB_F: case FMUL_F: case FDIV_F:
					print_val(ifff, get_rdi(ir), _FRD, get_rsi(ir), _FRS, get_rti(ir), _FRT);
					break;
				case FSQRT_F: case FABS_F: case FMOV_F: case FNEG_F:
					print_val(iff, get_rdi(ir), _FRD, get_rsi(ir), _FRS);
					break;
				default :
					unknown_ir();
					break;
			}
			break;
		case ADDI: case SUBI: case MULI: case SLLI:
		case SRLI: case LDI: case STI:
			print_val(iggi, get_rsi(ir), _GRS, get_rti(ir), _GRT, _IMM);
			break;
		case JMP: case CALL:
			print_val(il, get_target(ir));
			break;
		case MVLO: case MVHI:
			print_val(igi, get_rsi(ir), _GRS, _IMM);
			break;
		case JEQ: case JNE: case JLT: case JLE:
			print_val(iggl, get_rsi(ir), _GRS, get_rti(ir), _GRT, _IMM);
			break;
		case LD: case ST:
			print_val(iggg, get_rdi(ir), _GRD, get_rsi(ir), _GRS, get_rti(ir), _GRT);
			break;
		case RETURN :
			print_val(i);
			break;
		case FLDI: case FSTI:
			print_val(ifgi, get_rti(ir), _FRT, get_rsi(ir), _GRS, _IMM);
			break;
		case FJEQ: case FJLT:
			print_val(iffl, get_rsi(ir), _FRS, get_rti(ir), _GRT, _IMM);
			break;

		default :
			unknown_ir();
			break;
	}

}
#undef unknown_ir
#undef printf_val
#define BLANK "blank"
const char *InstMap[INST_NUM] = {
BLANK,   BLANK, "jmp", BLANK, BLANK, BLANK, BLANK, "mvlo",
"addi",  BLANK, "jeq", BLANK, BLANK, BLANK, BLANK, "mvhi",
"subi",  BLANK, "jne", "ld",  BLANK, BLANK, BLANK, BLANK,
"muli",  BLANK, "jlt", "st",  BLANK, BLANK, BLANK, BLANK,
BLANK,   BLANK, "jle", "ldi", BLANK, BLANK, BLANK, BLANK,
"slli",  BLANK, "srli","sti", BLANK, BLANK, BLANK, BLANK,
"call",  "fldi","fjeq",BLANK, BLANK, BLANK, BLANK, BLANK,
"return","fsti","fjlt",BLANK, BLANK, BLANK, BLANK, BLANK,
};
const char *SFunctMap[INST_NUM] = {
"sll",   BLANK, "srl", BLANK,   BLANK, BLANK, BLANK, BLANK,
"b",     BLANK, BLANK, BLANK,   BLANK, BLANK, BLANK, BLANK,
"btmplr",BLANK, BLANK, BLANK,   BLANK, BLANK, BLANK, BLANK,
"mul",   BLANK, BLANK, "nor",   BLANK, BLANK, BLANK, BLANK,
"add",   BLANK, "sub", BLANK,   "and", "or",  BLANK, BLANK,
BLANK,   BLANK, BLANK, BLANK,   BLANK, BLANK, BLANK, BLANK,
"callR", "fld", BLANK, "movlr", BLANK, BLANK, BLANK, BLANK,
BLANK,   "fst", BLANK, BLANK,   BLANK, BLANK, BLANK, "halt",
};
const char *FFunctMap[INST_NUM] = {
"fadd","fsub","fmul","fdiv","fsqrt","fabs","fmov","fneg",
};
const char *IOFunctMap[INST_NUM] = {
"input","output",
};
#undef BLANK
