#include "sim.h"
#include <math.h>


int operate(uint32_t ir) {
	int ret;
	union {
		uint32_t i;
		float f;
	} a, b, ans;
	uint8_t opcode = get_opcode(ir);
	uint8_t funct = get_funct(ir);
	static unsigned reg_cnt[64];
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
	//				printf("fjlt : true\n");
					pc += _IMM;
				} else {
		//			printf("fjlt : false\n");
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
				reg[30] = ram[reg[1]];
				break;
			case FJEQ:
				a.i = _FRS;
				b.i = _FRT;
				if (a.f == b.f) 
					pc += _IMM;
				break;
			case JLT:
				if (_GRS < _GRT)
					pc += _IMM;
				break;
			case CALL:
				ram[reg[1]] = reg[30];
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
						a.i = _FRS;
						ans.f = sqrtf(a.f);
						_FRD = ans.i;
						break;
					case FDIV_F:
						a.i = _FRS;
						b.i = _FRT;
						ans.f = a.f / b.f;
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
						ram[reg[1]] = reg[30];
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
					default: break;
					}
				break;
			default	:	break;
		}


	return ((opcode == SPECIAL) && (funct == HALT_F)) 
			? 0:1;

}

