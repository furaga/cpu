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
	const char *fggi = "%s %%g%d, %%g%d, %d";
	const char *ffgi = "%s %%f%d, %%g%d, %d";
	const char *fggg = "%s %%g%d, %%g%d, %%g%d";
	if (strcmp(opcode, "call") == 0) {
		if(sscanf(buf[0], fl, tmp, lname) == 2)  {
			sprintf(buf[0], "\tstlr\t%%g1, 0\n");
			sprintf(buf[1], "\tsubi\t%%g1, %%g1, 4\n");
			sprintf(buf[2], "\tlink\n");
			sprintf(buf[3], "\tjmp\t%s\n", lname);
		}
		return 4;
	} else 
	if (strcmp(opcode, "callR") == 0) {
		if(sscanf(buf[0], fg, tmp, &rs) == 2)  {
			sprintf(buf[0], "\tstlr\t%%g1, 0\n");
			sprintf(buf[1], "\tsubi\t%%g1, %%g1, 4\n");
			sprintf(buf[2], "\tlink\n");
			sprintf(buf[3], "\tb\t%%g%d\n", rs);
		}
		return 4;
	} else
	if (strcmp(opcode, "return") == 0) {
		sprintf(buf[0], "\tmovlr\n");
		sprintf(buf[1], "\taddi\t%%g1, %%g1, 4\n");
		sprintf(buf[2], "\tldlr\t%%g1, 0\n");
		sprintf(buf[3], "\tbtmplr\n");
		return 4;
	} else
	if (strcmp(opcode, "nop") == 0) {
		sprintf(buf[0], "\tslli\t%%g0, %%g0, 0\n");
		return 1;
	} else
	if (strcmp(opcode, "mov") == 0) {
		if(sscanf(buf[0], fgg, tmp, &rd, &rs) == 3) {
			sprintf(buf[0], "\taddi\t%%g%d, %%g%d, 0\n", rd, rs);
		}
		return 1;
	} else
	if (strcmp(opcode, "not") == 0) {
		if(sscanf(buf[0], fgg, tmp, &rd, &rs) == 3) {
			sprintf(buf[0], "\tnor\t%%g%d, %%g%d, %%g%d\n", rd, rs, rs);
		}
		return 1;
	} else

/*
	if (strcmp(opcode, "fld") == 0) {
		if(sscanf(buf[0], ffgi, tmp, &rt, &rs, &imm) == 4) {
			sprintf(buf[0], "\tfldi\t%%f%d, %%g%d, %d\n", rt, rs, imm);
		}
		return 1;
	} else
	if (strcmp(opcode, "fst") == 0) {
		if(sscanf(buf[0], ffgi, tmp, &rt, &rs, &imm) == 4) {
			sprintf(buf[0], "\tfsti\t%%f%d, %%g%d, %d\n", rt, rs, imm);
		}
		return 1;
	} else
	*/
	{}
	return 1;
}


