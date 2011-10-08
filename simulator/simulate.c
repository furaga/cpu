#include <stdio.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
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
#define _RS reg[regs(ir)]
#define _RD reg[regd(ir)]
#define _RT reg[regt(ir)]
#define _IMM imm(ir)

// rom $B$NL?Na<B9TNs(B($B%P%$%J%j(B)$B$K=>$$%7%_%e%l!<%H$9$k(B
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
	for (i = 1; heap_size > 0; i++,pc++) {
		ram[i] = rom[pc];
		heap_size -= 32;
	}

	printf("simulate %s\n", sfile);
	do{
		ir = rom[pc];

		cnt++;
		pc++;

		switch(opcode(ir)){
			case MOV: 
				_RD = _RS;
				break;
			case MVHI: 
				_RT = ((uint32_t) _IMM << 16) | (_RT & 0xffff);
				break;
			case MVLO: 
				_RT = (_RT & 0xffff0000) | _IMM;
				break;
			case ADD: 
				_RD = _RS + _RT;
				break;
			case SUB:
				_RD = _RS - _RT;
				break;
			case MUL:
				_RD = _RS * _RT;
				break;
			case DIV:
				_RD = _RS / _RT;
				break;
			case ADDI:
				_RT = _RS + _IMM;
				break;
			case SUBI:
				_RT = _RS - _IMM;
				break;
			case MULI:
				_RT = _RS * _IMM;
				break;
			case DIVI:
				_RT = _RS / _IMM;
				break;
			case INPUT:
				///////////////////////////////////////
				ret = scanf("%c", &_RD);
				_RD = _RD & 0xff;
				break;
			case OUTPUT:
				printf("cnt:%d output:(int dec)%d (char)%c\n", cnt, _RS, _RS);
				break;
			case AND:
				_RD = _RS & _RT;
				break;
			case OR:
				_RD = _RS | _RT;
				break;
			case NOT:
				_RD = ~_RS;
				break;
			case SLL:
				_RD = _RS << _RT;
				break;
			case SRL:
				_RD = _RS >> _RT;
				break;
			case SLLI:
				_RT = _RS << _IMM;
				break;
			case B:
				pc = _RS;
				break;
			case JMP:
				pc = imm(ir);
				break;
			case JEQ:
				if (_RS == _RT)
					pc += _IMM;
				break;
			case JNE:
				if (_RS != _RT)
					pc += _IMM;
				break;
			case JLT:
				if (_RS < _RT)
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
				pc = _RS;
				break;
			case RETURN:
				pc = lr;
				reg[1] += 4;
				lr = ram[reg[1]];
				break;
			case LD:
				_RS = ram[(_RT - _IMM)/4];
				break;
			case ST:
				ram[(_RT - _IMM)/4] = _RS;
				break;
			case FLD:
				freg[regs(ir)] = ram[(_RT - _IMM)/4];
				//printf("fld:%d\n", (_RT - _IMM)/4);
				break;
			case FST:
				ram[(_RT - _IMM)/4] = freg[regs(ir)];
				break;
			case FADD:
				a.i = freg[regs(ir)];
				b.i = freg[regt(ir)];
				ans.f = a.f + b.f;
				_RD = ans.i;
				break;
			case FSUB:
				a.i = freg[regs(ir)];
				b.i = freg[regt(ir)];
				ans.f = a.f - b.f;
				_RD = ans.i;
				break;
			case FMUL:
				a.i = freg[regs(ir)];
				b.i = freg[regt(ir)];
				ans.f = a.f * b.f;
				_RD = ans.i;
				break;
			case FDIV:
				a.i = freg[regs(ir)];
				b.i = freg[regt(ir)];
				ans.f = a.f / b.f;
				_RD = ans.i;
				break;
			case FMOV:
				freg[regd(ir)] = freg[regs(ir)];
				break;
			case FNEG:
				freg[regd(ir)] = (freg[regs(ir)] & 0x80000000) ?
								 (freg[regs(ir)] & 0x7fffffff) : // minus
								 (freg[regs(ir)] | 0x80000000) ; // plus
				break;
			case FJEQ:
				a.i = freg[regs(ir)];
				b.i = freg[regt(ir)];
				printf("debug:a:%f b:%f\n", a.f, b.f);
				printf("DEBUG:a:%x b:%x\n", a.i, b.i);
				if (a.f == b.f) 
					pc += _IMM;
				break;
			case FJLT:
				a.i = freg[regs(ir)];
				b.i = freg[regt(ir)];
				printf("debug:a:%f b:%f\n", a.f, b.f);
				printf("DEBUG:a:%x b:%x\n\n", a.i, b.i);
				if (a.f < b.f) {
					pc += _IMM;
				}
				break;
			case NOP:
				break;
			case HALT:
				break;
			default	:	break;
		}
	} while(opcode(ir) != HALT);

	printf("CPU Simulator Results\n");

	return 0;
} 
