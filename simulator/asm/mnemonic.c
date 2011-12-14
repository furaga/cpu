#include <stdio.h>
#include <string.h>
#include "asm.h"
char tmp[256];
char lname[256];
int rd,rs,rt,imm,funct,shaft,target;
int mnemonic(char *opcode, char buf[][LINE_MAX]) {
	const char *fl = "%s %s";
	const char *fg = "%s %%g%d";
	const char *fgg = "%s %%g%d, %%g%d";
	if (strcmp(opcode, "call") == 0) {
		if(sscanf(buf[0], fl, tmp, lname) == 2)  {
			sprintf(buf[0], "\tst\t%%g30, %%g1, 0\n");
			sprintf(buf[1], "\tsubi\t%%g1, %%g1, 4\n");
			sprintf(buf[2], "\tpadd\t%%g30, %%g0\n");
			sprintf(buf[3], "\tjmp\t%s\n", lname);
		}
		return 4;
	} else 
	if (strcmp(opcode, "callR") == 0) {
		if(sscanf(buf[0], fg, tmp, &rs) == 2)  {
			sprintf(buf[0], "\tst\t%%g30, %%g1, 0\n");
			sprintf(buf[1], "\tsubi\t%%g1, %%g1, 4\n");
			sprintf(buf[2], "\tpadd\t%%g30, %%g0\n");
			sprintf(buf[3], "\tb\t%%g%d\n", rs);
		}
		return 4;
	} else
	if (strcmp(opcode, "nop") == 0) {
		sprintf(buf[0], "\tslli\t%%g0, %%g0, 0");
		return 1;
	} else
	if (strcmp(opcode, "mov") == 0) {
		if(sscanf(buf[0], fgg, tmp, &rd, &rs) == 3) {
			sprintf(buf[0], "\taddi\t%%g%d, %%g%d, 0", rd, rs);
		}
		return 1;
	} else
	{}
	/*
	if (strcmp(opcode, "return") == 0) {
			sprintf(buf[0], "\tst\t%%g30, %%g1, 0\n");
			sprintf(buf[1], "\tsubi\t%%g1, %%g1, 4\n");
			sprintf(buf[2], "\tpadd\t%%g30, %%g0\n");
			sprintf(buf[3], "\tb\t%%g%d\n", rs);
		return 4;
	}
	*/
	return 1;
}


