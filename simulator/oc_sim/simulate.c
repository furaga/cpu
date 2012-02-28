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
#include "oc_sim.h"

uint32_t prom[ROM_NUM];
uint32_t ram[RAM_NUM];
int32_t reg[REG_NUM];
uint32_t freg[REG_NUM];
uint32_t pc;
uint32_t ir;
int32_t lr;
uint64_t cnt;

extern uint32_t _finv(uint32_t);
extern uint32_t _fsqrt(uint32_t);
extern uint32_t _fadd(uint32_t, uint32_t);
extern uint32_t _fmul(uint32_t, uint32_t);
static inline void init(void) {
// register init
	reg[1] = 4*(RAM_NUM-1);
	reg[2] = prom[0];

// heap init
	for (pc = 1; pc*4 <= reg[2]; pc++) {
		ram[pc-1] = prom[pc];
	}
}

static inline int exec(uint32_t ir);

int simulate(void) {
	init();
	do{
		reg[0] = 0;
		ir = prom[pc];
		cnt++;
		pc++;
		if (!(cnt % 100000000)) { warning("."); }
	} while (exec(ir)==0);
	warning("\n");
	return 0;
} 


static inline int exec(uint32_t ir) {
	uint8_t opcode, funct;
	union {
		uint32_t i;
		float f;
	} a, b, out;
	char c;
	opcode = get_opcode(ir);
	funct = get_funct(ir);

	switch(opcode){
		case SPECIAL:
			switch(funct) {
				case ADD_F: 
					_GRD = _GRS + _GRT;
					break;
				case NOR_F: 
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
					_GRD = _GRS - _GRT;
					break;
				case MUL_F:
					_GRD = _GRS * _GRT;
					break;
				case AND_F:
					_GRD = _GRS & _GRT;
					break;
				case OR_F:
					_GRD = _GRS | _GRT;
					break;
				case SLL_F:
					_GRD = _GRS << _GRT;
					break;
				case SRL_F:
					_GRD = _GRS >> _GRT;
					break;
				case HALT_F:
					return 1;
					break;
				default: break;		
			}
			break;

		case IO:
			switch(funct) {
				case OUTPUT_F:
					putchar(_GRS&0xff);
					fflush(stdout);
					break;
				case INPUT_F:
					c = getchar();
					_GRD = c & 0xff;
					break;
				default: break;

			}
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


		case LD:
			_GRD = ram[((_GRS + _GRT)/4)];
			break;
		case ST:
			ram[((_GRS + _GRT)/4)] = _GRD;
			break;
		case LDI:
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
				pc += _IMM - 1;
			} else {
			}
			break;
		case ADDI:
			_GRT = _GRS + _IMM;
			break;
		case SUBI:
			_GRT = _GRS - _IMM;
			break;
		case MULI:
			_GRT = _GRS * _IMM;
			break;
		case SLLI:
			_GRT = _GRS << _IMM;
			break;
		case SRLI:
			_GRT = _GRS >> _IMM;
			break;
		case JMP:
			pc = get_target(ir);
			break;
		case FJLT:
			a.i = _FRS;
			b.i = _FRT;
#define SIGN(x) eff_dig(1,(x)>>31)
			if (((SIGN(a.i))==1) && ((SIGN(b.i))==0)) {
				pc += _IMM - 1;
			} else if (SIGN(a.i)==0 && SIGN(b.i)==1) {
				pc = pc;
			} else if (SIGN(a.i)==0 && SIGN(b.i)==0) {
#undef SIGN
				if (eff_dig(31,a.i) < eff_dig(31,b.i)) {
					pc += _IMM - 1;
				} else {
						pc = pc;
				}
			} else {
				if (eff_dig(31,a.i) > eff_dig(31,b.i)) {
					pc += _IMM - 1;
				} else {
						pc = pc;
				}
			}
			break;
		case FSTI:
			ram[((_GRS - _IMM)/4)] = _FRT;
			break;
		case FJEQ:
			a.i = _FRS;
			b.i = _FRT;
			if (a.f == b.f)  {
				pc += _IMM - 1;
			} else {
			}
			break;
		case JLT:
			if (_GRS < _GRT) {
				pc += _IMM - 1;
			} else {
			}
			break;
		case CALL:
			ram[reg[1]/4] = lr;
			reg[1] -= 4;
			lr = pc;
			pc = get_target(ir);
			break;
		case RETURN:
			pc = lr;
			reg[1] += 4;
			lr = ram[reg[1]/4];
			break;
		case JEQ:
			if (_GRS == _GRT) {
				pc += _IMM - 1;
			} else {
			}
			break;

		case MVHI: 
			_GRS = ((uint32_t) _IMM << 16) | (_GRS & 0xffff);
			break;
		case MVLO: 
			_GRS = (_GRS & (0xffff<<16)) | (_IMM & 0xffff);
			break;
		default	:	break;
	}

	return 0;
}
