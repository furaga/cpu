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
uint32_t cnt;

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
	uint32_t ir, lr, heap_size;
	int fd,ret,i;
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

	lr = cnt = pc = 0;
	reg[1] = reg[31] = RAM_NUM;

	heap_size = rom[0]; 
	pc++;
	for (i = 0; heap_size > 0; i++,pc++) {
		ram[i] = rom[pc];
		reg[2] += 4;
		heap_size -= 32;
	}

	fprintf(stderr, "simulate %s\n", sfile);
	fflush(stderr);
	do{
		
		ir = rom[pc];
		print_state();
		cnt++;
		pc++;

		switch(get_opcode(ir)){
			case MOV: 
				_GRD = _GRS;
				break;
			case MVHI: 
				_GRT = ((uint32_t) _IMM << 16) | (_GRT & 0xffff);
				break;
			case MVLO: 
				_GRT = (_GRT & (0xffff<<16)) | _IMM;
				break;
			case ADD: 
				_GRD = _GRS + _GRT;
				break;
			case SUB:
				_GRD = _GRS - _GRT;
				break;
			case MUL:
				_GRD = _GRS * _GRT;
				break;
			case DIV:
				_GRD = _GRS / _GRT;
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
			case DIVI:
				_GRT = _GRS / _IMM;
				break;
			case INPUT:
				///////////////////////////////////////
				ret = scanf("%c", (char*)&_GRD);
				_GRD = _GRD & 0xff;
				break;
			case OUTPUT:
				a.i = _GRS;
				putchar(_GRS);
				fflush(stdout);
				//fprintf(stderr, "\tcnt:%d output:(int dec)%d (char)%c (float)%f\n", cnt, _GRS, _GRS, a.f);
				break;
			case AND:
				_GRD = _GRS & _GRT;
				break;
			case OR:
				_GRD = _GRS | _GRT;
				break;
			case NOT:
				_GRD = ~_GRS;
				break;
			case SLL:
				_GRD = _GRS << _GRT;
				break;
			case SRL:
				_GRD = _GRS >> _GRT;
				break;
			case SLLI:
				_GRT = _GRS << _IMM;
				break;
			case B:
				pc = _GRS;
				break;
			case JMP:
				pc = get_imm(ir);
				break;
			case JEQ:
				if (_GRS == _GRT)
					pc += _IMM;
				break;
			case JNE:
				if (_GRS != _GRT)
					pc += _IMM;
				break;
			case JLT:
				if (_GRS < _GRT)
					pc += _IMM;
				break;
			case CALL:
				ram[reg[1]] = lr;
				reg[1] -= 4;
				lr = pc;
				pc = _IMM;
				break;
			case CALLR:
				ram[reg[1]] = lr;
				reg[1] -= 4;
				lr = pc;
				pc = _GRS;
				
				/*
				for (i = 0; i < 50; i++) {
					a.i = freg[i];
					printf("ram[%d]=%d\n", i, ram[i]);
				}
				*/
				break;
			case RETURN:
				pc = lr;
				reg[1] += 4;
				lr = ram[reg[1]];
				break;
			case LD:
				_GRS = ram[(_GRT - _IMM)/4];
				break;
			case ST:
				ram[(_GRT - _IMM)/4] = _GRS;
				break;
			case FLD:
				_FRS = ram[(_GRT - _IMM)/4];
				break;
			case FST:
				ram[(_GRT - _IMM)/4] = _FRS;
				break;
			case FADD:
				a.i = _FRS;
				b.i = _FRT;
				ans.f = a.f + b.f;
				_FRD = ans.i;
				break;
			case FSUB:
				a.i = _FRS;
				b.i = _FRT;
				ans.f = a.f - b.f;
				_FRD = ans.i;
				break;
			case FMUL:
				a.i = _FRS;
				b.i = _FRT;
				ans.f = a.f * b.f;
				_FRD = ans.i;
				break;
			case FDIV:
				a.i = _FRS;
				b.i = _FRT;
				ans.f = a.f / b.f;
				_FRD = ans.i;
				break;
			case FSQRT:
				a.i = _FRS;
				ans.f = sqrtf(a.f);
				_FRD = ans.i;
				break;
			case FMOV:
				_FRD = _FRS;
				break;
			case FNEG:
				_FRD = (_FRS & (0x1 << 31)) ?
								 (_FRS & 0x7fffffff) : // minus
								 (_FRS | (0x1 << 31)) ; // plus
				break;
			case FJEQ:
				a.i = _FRS;
				b.i = _FRT;
				if (a.f == b.f) 
					pc += _IMM;
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
			case NOP:
				break;
			case HALT:
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
				a.i = _FRS;
				_GRD = (int32_t) a.f;
	//fprintf(stderr, "ioff before:%X after:%f\n", _FRS, _GRD);
				break;
			case F_OF_I:
				a.f = (float) _GRS;
				_FRD = a.i;
	//fprintf(stderr, "fofi before:%X after:%f\n", _GRS, _FRD);
				break;
			default	:	break;
		}
	} while(get_opcode(ir) != HALT);


	fprintf(stderr, "CPU Simulator Results\n");
	fflush(stderr);

	return 0;
} 
