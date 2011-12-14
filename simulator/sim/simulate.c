#include <stdio.h>
#include <stdint.h>
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

// rom の命令実行列(バイナリ)に従いシミュレートする
int simulate(char *sfile) {
	uint32_t ir, heap_size;
	int fd,ret,i;
	uint8_t opcode, funct;
	union {
		uint32_t i;
		float f;
	} a, b, ans;

	fd = open(sfile, O_RDONLY);
	if (fd < 0) {
		fprintf(stderr, "%s: No such file\n", sfile);
		return 1;
	}
	ret = read(fd, rom, ROM_NUM*4);
	close(fd);

	cnt = pc = 0;
	reg[1] = reg[31] = 4*(RAM_NUM-1);

	heap_size = rom[pc]; 
	pc++;
	for (i = 0; heap_size > 0; i++,pc++) {
		ram[reg[2]/4] = rom[pc];
		reg[2] += 4;
		heap_size -= 32;
	}

	fprintf(stderr, "simulate %s\n", sfile);
	fflush(stderr);

#ifdef STATS_M
	statistics(NULL,1);
#endif
	do{
		
		ir = rom[pc];
#ifdef STATS_M
		statistics(stderr,0);
#endif
#ifdef PRINT_M
		print_state();
#endif
		opcode = get_opcode(ir);
		funct = get_funct(ir);
		cnt++;
		pc++;
		if (!(cnt % 100000000)) {
			fprintf(stderr, ".");
			fflush(stderr);
		}
   
		switch(opcode){
			case LD:
				IF0_BREAK_S
				_GRT = ram[(_GRS - _IMM)/4];
				break;
			case ST:
				ram[(_GRS - _IMM)/4] = _GRT;
				break;
			case FLD:
				_FRT = ram[(_GRS - _IMM)/4];
				break;
			case JNE:
				if (_GRS != _GRT)
					pc += _IMM;
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
					pc += _IMM;
				} else {
				}
				break;
			case FST:
				ram[(_GRS - _IMM)/4] = _FRT;
				break;
			case SUBI:
				IF0_BREAK_T
				_GRT = _GRS - _IMM;
				break;
			case RETURN:
				pc = reg[30];
				reg[1] += 4;
				reg[30] = ram[reg[1]/4];
				break;
			case FJEQ:
				a.i = _FRS;
				b.i = _FRT;
				if (a.f == b.f) 
					pc += _IMM;
				break;
			case JLT:
				if (_GRS < _GRT) {
					pc += _IMM;
				} else {
				}
				break;
			case CALL:
				ram[reg[1]/4] = reg[30];
				reg[1] -= 4;
				reg[30] = pc;
				pc = get_target(ir);
				break;
			case SRLI:
				IF0_BREAK_T
				_GRT = _GRS >> _IMM;
				break;
			case JEQ:
				if (_GRS == _GRT)
					pc += _IMM;
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
			case SIN:
				a.i = _FRS;
				ans.f = sinf(a.f);
				_FRD = ans.i;
	//fprintf(stderr, "sin before:%f after:%f\n", a.f,ans.f);
				break;
			case COS:
				a.i = _FRS;
				ans.f = cosf(a.f);
				_FRD = ans.i;
	//fprintf(stderr, "cos before:%f after:%f\n", a.f,ans.f);
				break;
			case ATAN:
				a.i = _FRS;
				ans.f = atanf(a.f);
				_FRD = ans.i;
	//fprintf(stderr, "atan before:%f after:%f\n", a.f,ans.f);
				break;
			case I_OF_F:
				IF0_BREAK_D
				a.i = _FRS;
				_GRD = (int32_t) a.f;
	//fprintf(stderr, "ioff before:%X after:%f\n", _FRS, _GRD);
				break;
			case F_OF_I:
				a.f = (float) _GRS;
				_FRD = a.i;
	//fprintf(stderr, "fofi before:%X after:%f\n", _GRS, _FRD);
				break;
			case FPI:
				switch(funct) {
					case FMUL_F:
						a.i = _FRS;
						b.i = _FRT;
						ans.f = a.f * b.f;
						_FRD = ans.i;
						break;
					case FADD_F:
						a.i = _FRS;
						b.i = _FRT;
						ans.f = a.f + b.f;
						_FRD = ans.i;
						break;
					case FSUB_F:
						a.i = _FRS;
						b.i = _FRT;
						ans.f = a.f - b.f;
						_FRD = ans.i;
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
					case CALLR_F:
						ram[reg[1]/4] = reg[30];
						reg[1] -= 4;
						reg[30] = pc;
						pc = _GRS;
						break;
					case B_F:
						pc = _GRS;
						break;
					case SUB_F:
						IF0_BREAK_D
						_GRD = _GRS - _GRT;
						break;
					case MUL_F:
						IF0_BREAK_D
						_GRD = _GRS * _GRT;
						break;

					case DIV_F:
						IF0_BREAK_D
						_GRD = _GRS / _GRT;
						break;
					case AND_F:
						IF0_BREAK_D
						_GRD = _GRS & _GRT;
						break;
					case PADD_F:
						IF0_BREAK_D
						_GRD = pc+1 + _GRT;
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
						a.i = _GRS;
						putchar(_GRS);
						fflush(stdout);
						break;
					case INPUT_F:
						ret = scanf("%c", (char*)&_GRD);
						IF0_BREAK_D
						_GRD = _GRD & 0xff;
						break;
					}
				break;
			default	:	break;
		}

	} while(!((funct == HALT_F) && (opcode == SPECIAL)));


	fprintf(stderr, "\nCPU Simulator Results\n");
	fprintf(stderr, "cnt:%llu\n", cnt);
	fflush(stderr);

	return 0;
} 
