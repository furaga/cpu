#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <math.h>
#include "sim.h"


int32_t reg[REG_NUM];
uint32_t freg[REG_NUM];
uint32_t rom[ROM_NUM];
uint32_t ram[RAM_NUM];
uint32_t pc;
uint32_t lr, tmplr;
long long unsigned cnt;

// define fetch functions ////////////////////
DEF_ELE_GET(get_opcode, 26, 0x3f);		
DEF_ELE_GET(get_rsi, 21, 0x1f);
DEF_ELE_GET(get_rti, 16, 0x1f);
DEF_ELE_GET(get_rdi, 11, 0x1f);
DEF_ELE_GET(get_shamt, 6, 0x1f);
DEF_ELE_GET(get_funct, 0, 0x3f);
DEF_ELE_GET(get_target, 0, 0x3ffffff);
int32_t get_imm(uint32_t ir) {
	return (ir & (1 << 15)) ?
		   ((0xffff<<16) | (ir & 0xffff)):
		   (ir & 0xffff);
}

int simulate(char *sfile) {
	uint32_t ir, heap_size;
	int fd,ret,i;
	uint8_t opcode, funct;
	union {
		uint32_t i;
		float f;
	} a, b, ans;
#ifdef LST_FLAG
	FILE *lst_fp;
	char lst_name[1024];
#endif
	uint32_t g1_min = RAM_NUM, g2_max = 0;

	fd = open(sfile, O_RDONLY);
	if (fd < 0) {
		fprintf(stderr, "%s: No such file\n", sfile);
		return 1;
	}
	ret = read(fd, rom, ROM_NUM*4);
	close(fd);

	lr = tmplr = cnt = pc = 0;
	reg[1] = reg[31] = 4*(RAM_NUM-1);
	reg[2] = 0;

	heap_size = rom[0];
	pc+=4;
	for (i = 0; heap_size > 0; i++,pc+=4) {
		ram[reg[2]/4] = rom[pc/4];
		reg[2] += 4;
		heap_size -= 4;
	}

#ifdef LST_FLAG
	#undef DEBUG_FLAG
	sprintf(lst_name, "%s.lst", sfile);
	fprintf(stderr, "output %s\n", lst_name);
	lst_fp = fopen(lst_name, "w");
	fprintf(lst_fp, "#### %s\n\n", lst_name);
#endif

#ifdef DEBUG_FLAG
	fprintf(stderr, "debugging %s\n", sfile);
	debug_usage();
	fprintf(stderr, "\n[Debug start]\n");
#else
	fprintf(stderr, "simulate %s\n", sfile);
	fflush(stderr);
#endif

#ifdef STATS_FLAG
	statistics(NULL,1);
#endif
	do{
		
		g1_min = (g1_min < reg[1]) ? g1_min : reg[1];
		g2_max = (g2_max > reg[2]) ? g2_max : reg[2];

		ir = rom[pc/4];
		cnt++;
#ifdef LST_FLAG
		print_ir(ir, lst_fp);
#endif

#ifdef STATS_FLAG
		statistics(stderr,0);
		fprintf(stderr, "why");
#endif
		fprintf(stderr, "why");

#ifdef DEBUG_FLAG
		debug();
#endif

		opcode = get_opcode(ir);
		funct = get_funct(ir);
		pc+=4;
		if (!(cnt % 100000000)) {
			fprintf(stderr, ".");
			fflush(stderr);
		}
   
		switch(opcode){
			case LINK:
				lr = (pc-4) + _IMM;
				break;
			case LD:
				_GRD = ram[(_GRS + _GRT)/4];
				break;
			case ST:
				ram[(_GRS + _GRT)/4] = _GRD;
				break;

			case LDI:
				IF0_BREAK_S
				_GRT = ram[(_GRS - _IMM)/4];
				break;

			case STI:
				ram[(_GRS - _IMM)/4] = _GRT;
				break;
			case FSTI:
				ram[(_GRS - _IMM)/4] = _FRT;
				break;
			case LDLR:
				lr = ram[(_GRS - _IMM)/4];
				break;
			case STLR:
				ram[(_GRS - _IMM)/4] = lr;
				break;

			case FLDI:
				_FRT = ram[(_GRS - _IMM)/4];
				break;

			case JNE:
				if (_GRS != _GRT)
					pc += _IMM - 4;
				break;
			case ADDI:
				IF0_BREAK_T
				_GRT = _GRS + _IMM;
				break;
			case SLLI:
				IF0_BREAK_T
				_GRT = _GRS << _IMM;
				break;
			case JMP:
				pc = get_target(ir);
				break;
			case FJLT:
				a.i = _FRS;
				b.i = _FRT;
				if (a.f < b.f) {
					pc += _IMM - 4;
				} else {
				}
				break;
			case SUBI:
				IF0_BREAK_T
				_GRT = _GRS - _IMM;
				break;
			case RETURN:
				pc = lr;
				reg[1] += 4;
				lr = ram[reg[1]/4];
				break;
			case FJEQ:
				a.i = _FRS;
				b.i = _FRT;
				if (a.f == b.f) 
					pc += _IMM - 4;
				break;
			case JLT:
				if (_GRS < _GRT) {
					pc += _IMM - 4;
				} else {
				}
				break;
			case CALL:
				ram[reg[1]/4] = lr;
				reg[1] -= 4;
				lr = pc;
				pc = get_target(ir);
				break;
			case SRLI:
				IF0_BREAK_T
				_GRT = _GRS >> _IMM;
				break;
			case JEQ:
				if (_GRS == _GRT)
					pc += _IMM - 4;
				break;
			case MULI:
				IF0_BREAK_T
				_GRT = _GRS * _IMM;
				break;

			case MVHI: 
				IF0_BREAK_S
				_GRS = ((uint32_t) _IMM << 16) | (_GRS & 0xffff);
				break;
			case MVLO: 
				IF0_BREAK_S
				_GRS = (_GRS & (0xffff<<16)) | (_IMM & 0xffff);
				break;
			//case PADD:
				//IF0_BREAK_T
				//_GRT = (pc - 4) + _IMM;
				//lr = (pc  + 4);
				//break;
			case DIVI:
				IF0_BREAK_T
				_GRT = _GRS / _IMM;
				break;
			case FPI:
				switch(funct) {
					case FMUL_F:
						a.i = _FRS;
						b.i = _FRT;
						ans.f = a.f * b.f;
						_FRD = ans.i;
					/*
						_FRD = _fmul(_FRS, _FRT);
					*/
						break;
					case FADD_F:
						a.i = _FRS;
						b.i = _FRT;
						ans.f = a.f + b.f;
						_FRD = ans.i;
						_FRD = _fadd(_FRS, _FRT);
						break;
					case FSUB_F:
						a.i = _FRS;
						b.i = _FRT;
						ans.f = a.f - b.f;
						_FRD = ans.i;
						_FRD = _fadd(_FRS, 
							(_FRT & (0x1 << 31)) ?
										 (_FRT & 0x7fffffff) :
										 (_FRT | (0x1 << 31)));
						break;
					case FABS_F:
						_FRD = 0x7fffffff & _FRS;
						break;
					case FMOV_F:
						_FRD = _FRS;
						break;
					case FNEG_F:
						_FRD = (_FRS & (0x1 << 31)) ?
										 (_FRS & 0x7fffffff) : // minus
										 (_FRS | (0x1 << 31)) ; // plus
						break;
					case FSQRT_F:
						_FRD = _fsqrt(_FRS);
						break;
					case FDIV_F:
						a.i = _FRS;
						b.i = _FRT;
						b.i = _finv(b.i);
						ans.f = a.f * b.f;
						_FRD = ans.i;
						/*
						_FRD = _fmul(a.i, b.i);
						*/
						break;
					default: break;

				}
				break;

			case SPECIAL:
				switch(funct) {
					case ADD_F: 
						IF0_BREAK_D
						_GRD = _GRS + _GRT;
						break;
					case NOR_F: 
						IF0_BREAK_D
						_GRD = ~(_GRS | _GRT);
						break;
					case CALLR_F:
						ram[reg[1]/4] = lr;
						reg[1] -= 4;
						lr = pc;
						pc = _GRS;
						break;
					case B_F:
						pc = _GRS;
						break;
					case MOVLR_F:
						tmplr = lr;
						break;
					case BTMPLR_F:
						pc = tmplr;
						break;
					case FLD_F:
						_FRD = ram[(_GRS + _GRT)/4];
						break;
					case FST_F:
						ram[(_GRS + _GRT)/4] = _FRD;
						break;
					case SUB_F:
						IF0_BREAK_D
						_GRD = _GRS - _GRT;
						break;
					case MUL_F:
						IF0_BREAK_D
						_GRD = _GRS * _GRT;
						break;

					//case DIV_F:
						//IF0_BREAK_D
						//_GRD = _GRS / _GRT;
						//break;
					case AND_F:
						IF0_BREAK_D
						_GRD = _GRS & _GRT;
						break;
					//case PADD_F:
						//IF0_BREAK_D
						//_GRD = pc + 4 + _GRT;
						//break;
					case OR_F:
						IF0_BREAK_D
						_GRD = _GRS | _GRT;
						break;
					case SLL_F:
						IF0_BREAK_D
						_GRD = _GRS << _GRT;
						break;
					case SRL_F:
						IF0_BREAK_D
						_GRD = _GRS >> _GRT;
						break;
					case HALT_F:
						break;
					default: break;		
				}
				break;
			case IO:
				switch(funct) {
					case OUTPUT_F:
						if (_GRS >> 8) {
							fprintf(stderr,"errrrrrrrrrrr\n");
						}
						//fprintf(stderr, "%10d\n", cnt);
						putchar(_GRS&0xff);
						fflush(stdout);
						break;
					case INPUT_F:
						ret = scanf("%c", (char*)&_GRD);
						//fprintf(stderr, "%d,", ret);
						IF0_BREAK_D
						_GRD = _GRD & 0xff;
						break;
					}
				break;
			default	:	break;
		}

	} while(!((funct == HALT_F) && (opcode == SPECIAL)));


#ifdef LST_FLAG
	fclose(lst_fp);
#endif
	fprintf(stderr, "\nCPU Simulator Results\n");
	fprintf(stderr, "cnt:%llu\n", cnt);
	fprintf(stderr, "g1_min: %u(dec)\n", g1_min);
	fprintf(stderr, "g2_max: %u(dec)\n", g2_max);
	fflush(stderr);

	return 0;
} 
