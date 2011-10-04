#include <stdio.h>
#include <stdint.h>
#include "setup.h"

void program(void);
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
int main(int argc, char **argv)
{ 
	uint32_t pc;	// Program Counter
	uint32_t ir;	// Instruction Register
	uint32_t lr; // Link Register
	uint32_t flag_eq;
	uint32_t i;

	program();

	pc = 0;
	flag_eq = 0;

	do{
		ir = rom[pc];
		printf("PC:%3d IR:0x%08x", pc, ir);
		for (i = 0; i < 5; i++) {
			// 5: register の表示する数
			printf(" REG%d:0x%03x", i, reg[i]);
		}
		putchar('\n');
		pc++;
		//getchar(); // 一時停止

		switch(opcode(ir)){
			case MOV: 
				_RD = _RS;
				break;
			case MVHI: 
				_RS = ((uint32_t) _IMM << 16) | (_RT & 0xffff);
				break;
			case MVLO: 
				_RS = (_RT & 0xffff0000) | _IMM;
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
			case J:
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
				lr = rom[pc];
				pc = _IMM;
				break;
			case RETURN:
				pc = lr;
				break;
			case LD:
				break;
			case ST:
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
				break;
			case FST:
				break;
			case NOP:
				break;


			default	:	break;
		}
	} while(opcode(ir) != HALT);

	printf("\n");
	printf("CPU Simulator Results\n");
	printf("ram[64] = %d\n", ram[64]);
	//getchar(); // 一時停止

	return 0;
} 

