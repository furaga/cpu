#include <stdio.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include "setup.h"


int32_t reg[REG_NUM];
//uint32_t reg[REG_NUM];
uint32_t freg[REG_NUM];
uint32_t rom[MEM_NUM + 1];
uint32_t ram[MEM_NUM + 1];
void IMapInit(void);
extern const char *InstMap[];
extern int InstTyMap[];

DEF_ELE_ACC(opcode, 26, 0x3f);
DEF_ELE_ACC(regs, 21, 0x1f);
DEF_ELE_ACC(regt, 16, 0x1f);
DEF_ELE_ACC(regd, 11, 0x1f);
DEF_ELE_ACC(shamt, 6, 0x1f);
DEF_ELE_ACC(funct, 0, 0x3f);
DEF_ELE_ACC(imm, 0, 0xffff);
DEF_ELE_ACC(target, 0, 0x3ffffff);

#define _RS reg[regs(ir)]
#define _RD reg[regd(ir)]
#define _RT reg[regt(ir)]
#define _IMM imm(ir)


// rom の命令実行列(バイナリ)に従いシミュレートする
int main(int argc, char **argv)
{ 
	using namespace std;
	uint32_t pc;	// Program Counter
	uint32_t ir;	// Instruction Register
	uint32_t lr; 	// Link Register
	uint32_t flag_eq;
	uint32_t cnt;
	uint32_t i;
	int fd;

	fd = open("binary", O_RDONLY);
	read(fd, rom, MEM_NUM*4);

	pc = 0;
	flag_eq = 0;
	lr = 0;
	cnt = 0;
	reg[1] = reg[31] = MEM_NUM;

	IMapInit();
	do{
		ir = rom[pc];
		cnt++;
		/*
		switch (InstTyMap[opcode(ir)]) {
			case 0:
				printf("%3d PC:%3d LR:0x%X\n%s\trs:GR%d rt:GR%d rd:GR%d shamt:%d funct:%d\n", 
						cnt++,pc,lr,InstMap[opcode(ir)],regs(ir),regt(ir),regd(ir),shamt(ir),funct(ir));
				break;
			case 1:
				printf("%3d PC:%3d LR:0x%X\n%s\trs:GR%d rt:GR%d imm:0x%X\n",
						cnt++,pc,lr,InstMap[opcode(ir)],regs(ir),regt(ir),imm(ir));
				break;
			case 2:
				printf("%3d PC:%3d LR:0x%X\n%s\ttarget:0x%X\n",
						cnt++,pc,lr,InstMap[opcode(ir)],target(ir));
				break;
			default: break;
		}
		for (i = 0; i < REG_NUM; i++) {
			if (reg[i] > 0) {
				printf(" GR%d:0x%X", i, reg[i]);
			}
		}
		putchar('\n');
		for (i = 0; i < MEM_NUM; i++) {
			if (ram[i] > 0) {
				printf(" RAM%d:0x%X", i, ram[i]);
			}
		}
		putchar('\n');
		putchar('\n');
		*/
		pc++;
int prev = reg[1];
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
				break;
			case OUTPUT:
				printf("cnt:%d output:%d\n", cnt, _RS);
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
//				reg[1] += 4;
				reg[1] -= 4;
				lr = pc;
				pc = _IMM;
//				printf("arg = %d ", reg[3]);
//				fflush(stdout);
				break;
			case RETURN:
				pc = lr;
//				reg[1] -= 4;
				reg[1] += 4;
				lr = ram[reg[1]];
				break;
			case LD:
//				_RS = ram[(_RT + _IMM)/4];
				_RS = ram[(_RT - _IMM)/4];
				break;
			case ST:
//				ram[(_RT + _IMM)/4] = _RS;
				ram[(_RT - _IMM)/4] = _RS;
				break;
			case FADD:
				_RD = _RS + _RT;
				break;
			case FSUB:
				_RD = _RS - _RT;
				break;
			case FMUL:
				_RD = _RS * _RT;
				break;
			case FDIV:
				_RD = _RS / _RT;
				break;
			case FLD:
				_RS = ram[(_RT - _IMM)/4];
				break;
			case FST:
				ram[(_RT - _IMM)/4] = _RS;
				break;
			case NOP:
				break;
			case HALT:
				break;
			default	:	break;
		}
		
//		if (prev != reg[1]) {
//			printf("pc=%d op=%s sp=%d reg[3] = %d reg[4] = %d\n", pc, InstMap[opcode(ir)], reg[1], reg[3], reg[4]);		fflush(stdout);
	//	}
		
		prev = reg[3];
	} while(opcode(ir) != HALT);

	putchar('\n');
	printf("CPU Simulator Results\n");

	return 0;
} 

