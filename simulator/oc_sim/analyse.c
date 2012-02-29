#include <stdio.h>
#include "oc_sim.h"

static unsigned count[INST_NUM][INST_NUM];
static unsigned fr_cnt[REG_NUM];
static unsigned gr_cnt[REG_NUM];
static unsigned err_cnt;
void analyse(uint32_t ir) {
	uint8_t opcode, funct;
	opcode = get_opcode(ir);
	funct = get_funct(ir);

	switch (opcode) {
		case FPI:
			count[FPI][funct]++;
			switch(funct) {
				case FADD_F: case FSUB_F: case FMUL_F: case FDIV_F:
					fr_cnt[get_rsi(ir)]++;
					fr_cnt[get_rti(ir)]++;
					fr_cnt[get_rdi(ir)]++;
					break;
				case FSQRT_F: case FABS_F: case FMOV_F: case FNEG_F:
					fr_cnt[get_rsi(ir)]++;
					fr_cnt[get_rdi(ir)]++;
					break;
				default: 
					err_cnt++;
					break;
			}
			break;
		case SPECIAL:
			count[SPECIAL][funct]++;
			switch(funct) {
				case ADD_F : case SUB_F : case MUL_F : case NOR_F :
				case AND_F : case OR_F : case SLL_F : case SRL_F :
					gr_cnt[get_rsi(ir)]++;
					gr_cnt[get_rti(ir)]++;
					gr_cnt[get_rdi(ir)]++;
					break;
				case CALLR_F : case B_F : 
					gr_cnt[get_rsi(ir)]++;
					break;
				case FLD_F : case FST_F :
					gr_cnt[get_rsi(ir)]++;
					gr_cnt[get_rti(ir)]++;
					break;
				case HALT_F :
					break;
				default:
					err_cnt++;
					break;
			}
			break;
		case IO:
			count[IO][funct]++;
			switch(funct) {
				case OUTPUT_F:
					gr_cnt[get_rsi(ir)]++;
					break;
				case INPUT_F:
					gr_cnt[get_rdi(ir)]++;
					break;
				default: 
					err_cnt++;
					break;
				}
			break;
		default	:	
			count[opcode][0]++;
			switch(opcode){
				case ADDI: case SUBI: case MULI: case SLLI:
				case SRLI: case LDI: case STI:
					gr_cnt[get_rsi(ir)]++;
					gr_cnt[get_rti(ir)]++;
					break;
				case JMP: case CALL:
					break;
				case MVLO: case MVHI:
					gr_cnt[get_rsi(ir)]++;
					break;
				case JEQ: case JNE: case JLT: case JLE:
					gr_cnt[get_rsi(ir)]++;
					gr_cnt[get_rti(ir)]++;
					break;
				case LD: case ST:
					gr_cnt[get_rsi(ir)]++;
					gr_cnt[get_rti(ir)]++;
					gr_cnt[get_rdi(ir)]++;
					break;
				case RETURN :
					break;
				case FLDI: case FSTI:
					gr_cnt[get_rsi(ir)]++;
					fr_cnt[get_rti(ir)]++;
					break;
				case FJEQ: case FJLT:
					fr_cnt[get_rsi(ir)]++;
					fr_cnt[get_rti(ir)]++;
					break;
				default: 
					err_cnt++;
					break;
			}
			break;
	}
}
#define print_inst(...) \
	fprintf(fp, "%8s: %f %% %10d\n", ##__VA_ARGS__)
#define print_gr(...) \
	fprintf(fp, "%6s%02d: %10d\n", "g", ##__VA_ARGS__)
#define print_fr(...) \
	fprintf(fp, "%6s%02d: %10d\n", "f", ##__VA_ARGS__)
void print_analysis(FILE* fp) {
	int i,j;

	fprintf(fp, "\nanalyse_err_cnt: %d\n\n", err_cnt);
	for (i = 0; i < INST_NUM; i++) {
		switch (i) {
			case SPECIAL: 
				for (j = 0; j < INST_NUM; j++) {
					if (count[i][j] > 0) {
						print_inst(SFunctMap[j], count[i][j]*1.0/cnt, count[i][j]);
					}
				}
				break;
			case IO: 
				for (j = 0; j < INST_NUM; j++) {
					if (count[i][j] > 0) {
						print_inst(IOFunctMap[j], count[i][j]*1.0/cnt, count[i][j]);
					}
				}
				break;
			case FPI:
				for (j = 0; j < INST_NUM; j++) {
					if (count[i][j] > 0) {
						print_inst(FFunctMap[j], count[i][j]*1.0/cnt, count[i][j]);
					}
				}
				break;
		default:
			if (count[i][0] > 0) {
				print_inst(InstMap[i], count[i][0]*1.0/cnt, count[i][0]);
			}
			break;
		}
	}
	fprintf(fp, "\n");
	for (i = 0; i < REG_NUM; i++) {
		print_gr(i, gr_cnt[i]);
	}
	fprintf(fp, "\n");
	for (i = 0; i < REG_NUM; i++) {
		print_fr(i, fr_cnt[i]);
	}


}
#undef myprint
#undef print_gr
#undef print_fr
