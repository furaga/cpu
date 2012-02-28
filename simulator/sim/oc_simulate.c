#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <assert.h>
#include <math.h>
#include "sim.h"

int32_t reg[REG_NUM];
uint32_t freg[REG_NUM];
uint32_t rom[ROM_NUM];
uint32_t ram[RAM_NUM];
uint32_t pc;
int32_t lr, tmplr;
long long unsigned cnt;
void to_bin(uint32_t);
#define dump(x) fprintf(stderr, "%s: ", #x); to_bin(x);
#define SIGN(x) (((x)&0x80000000)>>31)
#define ELSE(x) ((x)&0x7fffffff)

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
	} a, b, out, ans;
	uint32_t sendbuf_count = 0;
	uint32_t max_sendbuf_count = 0;
	int fjlt_flag, fjlt_ans;
	char c;
#ifdef LST_FLAG
	FILE *lst_fp;
	char lst_name[1024];
#endif
	//uint32_t g1_min = 4*RAM_NUM, g2_max = 0;

	fd = open(sfile, O_RDONLY);
	if (fd < 0) {
		fprintf(stderr, "%s: No such file\n", sfile);
		return 1;
	}
	ret = read(fd, rom, ROM_NUM*4);
	close(fd);

	lr = tmplr = cnt = pc = 0;
	reg[1] = reg[31] = 4*(RAM_NUM-1);
	fprintf(stderr, "%d\n", reg[1]);
	reg[2] = 0;

	heap_size = rom[0];
	pc++;
	for (i = 0; heap_size > 0; i++,pc++) {
		ram[reg[2]/4] = rom[pc];
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
		
		if (reg[1] < 0 || reg[2] < 0)  {
			break;
		}

		//if (!(cnt % 13750)) {
		if (!(cnt % 1611)) {
		//if (!(cnt % 20625)) {
			if (sendbuf_count >0) {
				sendbuf_count--;
			}
		}

		ir = rom[pc];
		cnt++;
#ifdef LST_FLAG
		print_ir(ir, lst_fp);
#endif

#ifdef STATS_FLAG
		statistics(stderr,0);
#endif

#ifdef DEBUG_FLAG
		debug();
#endif

		opcode = get_opcode(ir);
		funct = get_funct(ir);
		pc++;
		if (!(cnt % 100000000)) {
			fprintf(stderr, ".");
			fflush(stderr);
		}
   
		switch(opcode){
			case LD:
				_GRD = ram[((_GRS + _GRT)/4)];
				break;
			case ST:
				ram[((_GRS + _GRT)/4)] = _GRD;
				break;
			case LDI:
				IF0_BREAK_S
				_GRT = ram[((_GRS - _IMM)/4)];
				break;
			case STI:
				ram[((_GRS - _IMM)/4)] = _GRT;
				break;
			case FLDI:
				_FRT = ram[((_GRS - _IMM)/4)];
				break;
			case JNE:
				if (_GRS != _GRT) {
#ifdef CHECK_BRANCH
					printf("t");
#endif
					pc += _IMM - 1;
				} else {
#ifdef CHECK_BRANCH
					printf("f");
#endif
				}
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
				if (((SIGN(a.i))==1) && ((SIGN(b.i))==0)) {
#ifdef CHECK_BRANCH
					printf("t");
#endif
					fjlt_flag = 1;
					pc += _IMM - 1;
				} else if (SIGN(a.i)==0 && SIGN(b.i)==1) {
#ifdef CHECK_BRANCH
					printf("f");
#endif
					fjlt_flag = 0;
					pc = pc;
				} else if (SIGN(a.i)==0 && SIGN(b.i)==0) {
					if (ELSE(a.i) < ELSE(b.i)) {
#ifdef CHECK_BRANCH
					printf("t");
#endif
						fjlt_flag = 1;
						pc += _IMM - 1;
					} else {
#ifdef CHECK_BRANCH
					printf("f");
#endif
						fjlt_flag = 0;
							pc = pc;
					}
				} else {
					if (ELSE(a.i) > ELSE(b.i)) {
#ifdef CHECK_BRANCH
					printf("t");
#endif
						fjlt_flag = 1;
						pc += _IMM - 1;
					} else {
#ifdef CHECK_BRANCH
					printf("f");
#endif
					fjlt_flag = 0;
							pc = pc;
					}
				}
				if (a.f < b.f) {
					//pc += _IMM - 1;
					fjlt_ans = 1;
				} else {
					fjlt_ans = 0;
				}
				if (fjlt_flag != fjlt_ans) {
					fprintf(stderr, "ans: %d, flag %d\n", fjlt_ans, fjlt_flag);
					fprintf(stderr, "a: %f, b: %f\n", a.f, b.f);
					fprintf(stderr, "sa: %d, sb: %d\n", SIGN(a.i), SIGN(b.i));
					dump(a.i);
					dump(b.i);
				}
				break;
			case FSTI:
				ram[((_GRS - _IMM)/4)] = _FRT;
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
				if (a.f == b.f)  {
#ifdef CHECK_BRANCH
					printf("t");
#endif
					pc += _IMM - 1;
				} else {
#ifdef CHECK_BRANCH
					printf("f");
#endif
				}
				break;
			case JLT:
				if (_GRS < _GRT) {
#ifdef CHECK_BRANCH
					printf("t");
#endif
					pc += _IMM - 1;
				} else {
#ifdef CHECK_BRANCH
					printf("f");
#endif
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
				if (_GRS == _GRT) {
#ifdef CHECK_BRANCH
					printf("t");
#endif
					pc += _IMM - 1;
				} else {
#ifdef CHECK_BRANCH
					printf("f");
#endif
				}
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
			case DIVI:
				IF0_BREAK_T
				_GRT = _GRS / _IMM;
				break;
			case FPI:
				switch(funct) {
					case FMUL_F:
						_FRD = _fmul(_FRS, _FRT);
						break;
					case FDIV_F:
						a.i = _finv(_FRT);
						_FRD = _fmul(_FRS, a.i);
						break;
					case FADD_F:
						a.i = _FRS;
						b.i = _FRT;
						out.i = _fadd(_FRS, _FRT);
						_FRD = out.i;

						break;
					case FSUB_F:
						a.i = _FRS;
						b.i = (_FRT >> 31) ? (_FRT & 0x7fffffff) : (_FRT | 0x80000000);
						out.i = _fadd(_FRS, b.i);
						_FRD = out.i;
						
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
						putchar(_GRS&0xff);
						fflush(stdout);
						sendbuf_count++;
						max_sendbuf_count = (max_sendbuf_count > sendbuf_count) ?
								max_sendbuf_count : sendbuf_count;
						break;
					case INPUT_F:
						//ret = scanf("0x%02x", (char*)&c);
						//if (ret==0) { fprintf(stderr,"input error\n"); }
						c = getchar();
						//fprintf(stderr, " debug input: 0x%08X\n", c);
						IF0_BREAK_D
						_GRD = c & 0xff;
						break;
					default: break;

					}
				break;
			default	:	break;
		}

	} while(!((funct == HALT_F) && (opcode == SPECIAL)));
	fprintf(stderr, "max_sendbuf: %d\n", max_sendbuf_count);

#ifdef LST_FLAG
	fclose(lst_fp);
#endif
	fprintf(stderr, "\nCPU Simulator Results\n");
	fprintf(stderr, "cnt:%llu\n", cnt);
	fflush(stderr);

	return 0;
} 
