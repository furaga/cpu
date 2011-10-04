#include <stdio.h>
//#include <stdlib.h>
#include <stdint.h>
#include "setup.h"
// setup.h >> reg[],rom[],ram[]
void program(void);
DEFINE_R(add,ADD);
DEFINE_R(sub,SUB);
DEFINE_R(mul,MUL);
DEFINE_R(div,DIV);
DEFINE_R(halt,HALT);
DEF_ELE_ACC(opcode, 26, 0x3f);
DEF_ELE_ACC(regs, 21, 0x1f);
DEF_ELE_ACC(regt, 16, 0x1f);
DEF_ELE_ACC(regd, 11, 0x1f);
DEF_ELE_ACC(shamt, 6, 0x1f);
DEF_ELE_ACC(funct, 0, 0x3f);
DEF_ELE_ACC(imm, 0, 0xffff);
DEF_ELE_ACC(target, 0, 0x3ffffff);

int main(int argc, char **argv)
{ 
	uint32_t pc;	// Program Counter
	uint32_t ir;	// Instruction Register
	uint32_t flag_eq;

	program();

	pc = 0;
	flag_eq = 0;

	do{
		ir = rom[pc];
		printf("PC:%3d IR:%4x REG0:%3d REG1:%3d REG2:%3d REG3:%3d\n"
				,pc, ir, reg[0], reg[1], reg[2], reg[3]);
		pc++;
		// 　getchar();

		switch(opcode(ir)){
			case ADD: 
				reg[regd(ir)] = reg[regs(ir)] + reg[regt(ir)];
				break;

			default	:	break;
		}
	} while(opcode(ir) != HALT);

	// Output (Memory Mapped I/O)

	printf("\n");
	printf("CPU Simulator Results\n");
	printf("ram[64] = %d\n", ram[64]);
	getchar();

	return 0;
} 

void program(void)
{

rom[0]	=	add(REG2, REG1, REG3,0,0);	// Reg2 <- Reg2 + Reg1
rom[1]	=	halt(0,0,0,0,0);
}

