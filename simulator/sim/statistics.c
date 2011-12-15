#include <stdio.h>
#include "sim.h"

// 命令実行回数の計数
int statistics(FILE* fp,int init) {
	static unsigned count[INST_NUM][INST_NUM];
	static unsigned reg_cnt[2][REG_NUM];
	const char *format = "%8s: %f %10d\n";
	uint32_t ir = rom[pc];
	uint8_t opcode, funct;
	int i,j;
	opcode = get_opcode(ir);
	funct = get_funct(ir);

	if (init) {
		for (i = 0; i < INST_NUM; i++) {
			reg_cnt[0][i] = 0;
			reg_cnt[1][i] = 0;
			for (j = 0; j < INST_NUM; j++) {
				count[i][j] = 0;
			}
		}
		return 0;
	}
	
	switch (opcode) {
		case FPI:
			count[076][0]++;
			count[opcode][funct]++;
			switch(funct) {
				case FMUL_F:
					reg_cnt[1][get_rsi(ir)]++;
					reg_cnt[1][get_rti(ir)]++;
					reg_cnt[1][get_rdi(ir)]++;
					break;
				case FADD_F:
					reg_cnt[1][get_rsi(ir)]++;
					reg_cnt[1][get_rti(ir)]++;
					reg_cnt[1][get_rdi(ir)]++;
					break;
				case FSUB_F:
					reg_cnt[1][get_rsi(ir)]++;
					reg_cnt[1][get_rti(ir)]++;
					reg_cnt[1][get_rdi(ir)]++;
					break;
				case FABS_F:
					reg_cnt[1][get_rsi(ir)]++;
					reg_cnt[1][get_rdi(ir)]++;
					break;
				case FMOV_F:
					reg_cnt[1][get_rsi(ir)]++;
					reg_cnt[1][get_rdi(ir)]++;
					break;
				case FNEG_F:
					reg_cnt[1][get_rsi(ir)]++;
					reg_cnt[1][get_rdi(ir)]++;
					break;
				case FSQRT_F:
					reg_cnt[1][get_rsi(ir)]++;
					reg_cnt[1][get_rdi(ir)]++;
					break;
				case FDIV_F:
					reg_cnt[1][get_rsi(ir)]++;
					reg_cnt[1][get_rti(ir)]++;
					reg_cnt[1][get_rdi(ir)]++;
					break;
				default: break;
			}
			break;
		case SPECIAL:
			count[074][0]++;
			count[opcode][funct]++;
			switch(funct) {
				case ADD_F: 
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					reg_cnt[0][get_rdi(ir)]++;
					break;
				case CALLR_F:
					reg_cnt[0][get_rsi(ir)]++;
					break;
				case B_F:
					reg_cnt[0][get_rsi(ir)]++;
					break;
				case SUB_F:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					reg_cnt[0][get_rdi(ir)]++;
					break;
				case MUL_F:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					reg_cnt[0][get_rdi(ir)]++;
					break;
				case DIV_F:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					reg_cnt[0][get_rdi(ir)]++;
					break;
				case AND_F:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					reg_cnt[0][get_rdi(ir)]++;
					break;
				case OR_F:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					reg_cnt[0][get_rdi(ir)]++;
					break;
				case SLL_F:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					reg_cnt[0][get_rdi(ir)]++;
					break;
				case SRL_F:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					reg_cnt[0][get_rdi(ir)]++;
					break;
				case HALT_F:
		for (i = 0; i < REG_NUM; i++) {
			fprintf(fp,"gr%2d: %10d\n", i,reg_cnt[0][i]);
		}
		for (i = 0; i < REG_NUM; i++) {
			fprintf(fp,"fr%2d: %10d\n", i,reg_cnt[1][i]);
		}
					break;
				default: break;		
			}
			break;
		case IO:
			count[076][0]++;
			count[opcode][funct]++;
			switch(funct) {
				case OUTPUT_F:
					reg_cnt[0][get_rsi(ir)]++;
					break;
				case INPUT_F:
					reg_cnt[0][get_rdi(ir)]++;
					break;
				default: break;
				}
			break;
		default	:	
			count[077][0]++;
			count[opcode][0]++;
			switch(opcode){
				case LD:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					break;
				case ST:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					break;
				case FLD:
					reg_cnt[1][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					break;
				case JNE:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					break;
				case ADDI:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					break;
				case SLLI:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					break;
				case JMP:
					break;
				case FJLT:
					reg_cnt[1][get_rsi(ir)]++;
					reg_cnt[1][get_rti(ir)]++;
					break;
				case FST:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[1][get_rti(ir)]++;
					break;
				case SUBI:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					break;
				case RETURN:
					break;
				case FJEQ:
					reg_cnt[1][get_rsi(ir)]++;
					reg_cnt[1][get_rti(ir)]++;
					break;
				case JLT:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					break;
				case CALL:
					break;
				case SRLI:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					break;
				case JEQ:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					break;
				case MULI:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					break;
				case MVHI: 
					reg_cnt[0][get_rti(ir)]++;
					break;
				case MVLO: 
					reg_cnt[0][get_rti(ir)]++;
					break;
				case DIVI:
					reg_cnt[0][get_rsi(ir)]++;
					reg_cnt[0][get_rti(ir)]++;
					break;
				case SIN:
					//a.i = _FRS;
					//ans.f = sinf(a.f);
					//_FRD = ans.i;
		//fprintf(stderr, "sin before:%f after:%f\n", a.f,ans.f);
					break;
				case COS:
					//a.i = _FRS;
					//ans.f = cosf(a.f);
					//_FRD = ans.i;
		//fprintf(stderr, "cos before:%f after:%f\n", a.f,ans.f);
					break;
				case ATAN:
					//a.i = _FRS;
					//ans.f = atanf(a.f);
					//_FRD = ans.i;
		//fprintf(stderr, "atan before:%f after:%f\n", a.f,ans.f);
					break;
				case I_OF_F:
					//IF0_BREAK_D
					//a.i = _FRS;
					//_GRD = (int32_t) a.f;
		//fprintf(stderr, "ioff before:%X after:%f\n", _FRS, _GRD);
					break;
				case F_OF_I:
					//a.f = (float) _GRS;
					//_FRD = a.i;
		//fprintf(stderr, "fofi before:%X after:%f\n", _GRS, _FRD);
					break;
				default: break;
			}
		break;
	}



	if ((opcode == SPECIAL) && (funct == HALT_F)) {
		fprintf(fp, "\n");

		for (i = 0; i < INST_NUM; i++) {
			switch (i) {
				case SPECIAL: 
					for (j = 0; j < INST_NUM; j++) {
						if (count[i][j] > 0) {
							fprintf(fp, format, SFunctMap[j], count[i][j]*1.0/cnt, count[i][j]);
						}
					}
					break;
				case IO: 
					for (j = 0; j < INST_NUM; j++) {
						if (count[i][j] > 0) {
							fprintf(fp, format, IOFunctMap[j], count[i][j]*1.0/cnt, count[i][j]);
						}
					}
					break;
				case FPI:
					for (j = 0; j < INST_NUM; j++) {
						if (count[i][j] > 0) {
							fprintf(fp, format, FFunctMap[j], count[i][j]*1.0/cnt, count[i][j]);
						}
					}
					break;
			default:
				if (count[i][0] > 0) {
					fprintf(fp, format, InstMap[i], count[i][0]*1.0/cnt, count[i][0]);
				}
				break;
			
			}
		}
		fprintf(fp, "\n");

		return 1;
	}
	return 0;
}
