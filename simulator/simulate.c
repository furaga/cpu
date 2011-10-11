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
void IMapInit(void);
extern const char *InstMap[];
extern int InstTyMap[];

// define fetch functions ////////////////////
DEF_ELE_ACC(opcode, 26, 0x3f);		
DEF_ELE_ACC(regs, 21, 0x1f);
DEF_ELE_ACC(regt, 16, 0x1f);
DEF_ELE_ACC(regd, 11, 0x1f);
DEF_ELE_ACC(shamt, 6, 0x1f);
DEF_ELE_ACC(funct, 0, 0x3f);
DEF_ELE_ACC(target, 0, 0x3ffffff);
int32_t imm(uint32_t ir) {
	return (ir & (1 << 15)) ?
		   (0xffff0000 | (ir & 0xffff)):
		   (ir & 0xffff);
}
//////////////////////////////////////////////
// register access ///////////////////////////
#define _GRS reg[regs(ir)]
#define _GRD reg[regd(ir)]
#define _GRT reg[regt(ir)]
#define _FRS freg[regs(ir)]
#define _FRD freg[regd(ir)]
#define _FRT freg[regt(ir)]
#define _IMM imm(ir)
//////////////////////////////////////////////

// rom の命令実行列(バイナリ)に従いシミュレートする
int simulate(char *sfile)
{ 
	uint32_t pc, ir, lr, flag_eq, cnt, heap_size;
	int fd,ret,i;
	union {
		uint32_t i;
		float f;
	} a, b, ans;

	fd = open(sfile, O_RDONLY);
	if (fd < 0) {
		printf("%s: No such file\n", sfile);
		return 1;
	}
	ret = read(fd, rom, ROM_NUM*4);
	close(fd);

	pc = 0;
	flag_eq = 0;
	lr = 0;
	cnt = 0;
	reg[1] = reg[31] = RAM_NUM;

	heap_size = rom[0]; 
	pc++;
	//reg[2] = 4;
	for (i = 0; heap_size > 0; i++,pc++) {
		ram[i] = rom[pc];
		reg[2] += 4;
		heap_size -= 32;
	}

	IMapInit();
	printf("simulate %s\n", sfile);
	do{
		
		//printf("pc %d\n", pc);
		ir = rom[pc];

		//printf("%d.[%d]%s : g%d=%d g%d=%d g%d=%d imm=%d\n", cnt, pc, InstMap[opcode(ir)], regs(ir), _GRS, regt(ir), _GRT, regd(ir), _GRD, _IMM);
		//fflush(stdout);

		cnt++;
		pc++;

		switch(opcode(ir)){
			case MOV: 
				_GRD = _GRS;
				break;
			case MVHI: 
				_GRT = ((uint32_t) _IMM << 16) | (_GRT & 0xffff);
				break;
			case MVLO: 
				_GRT = (_GRT & 0xffff0000) | _IMM;
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
				printf("\tcnt:%d output:(int dec)%d (char)%c (float)%f\n", cnt, _GRS, _GRS, a.f);
				fflush(stdout);
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
				pc = imm(ir);
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
				ans.f = sqrt(a.f);
				_FRD = ans.i;
				break;
			case FMOV:
				_FRD = _FRS;
				break;
			case FNEG:
				_FRD = (_FRS & 0x80000000) ?
								 (_FRS & 0x7fffffff) : // minus
								 (_FRS | 0x80000000) ; // plus
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
			default	:	break;
		}
	} while(opcode(ir) != HALT);

/*
	for (i = 0; i < 5; i++) {
		a.i = freg[i];
		printf("freg[%d]=%f\n", i, a.f);
	}
*/
	printf("CPU Simulator Results\n");

	return 0;
} 
