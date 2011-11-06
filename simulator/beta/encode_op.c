#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include "asm.h"
#include "reasm.h"

const char *fg = "%s %%g%d";
const char *fl = "%s %s";
const char *fgi = "%s %%g%d, %d";
const char *fgl = "%s %%g%d, %s";
const char *fgg = "%s %%g%d, %%g%d";
const char *fggl = "%s %%g%d, %%g%d, %s";
const char *fggi = "%s %%g%d, %%g%d, %d";
const char *fggg = "%s %%g%d, %%g%d, %%g%d";
const char *fff = "%s %%f%d, %%f%d";
const char *fgf = "%s %%g%d, %%f%d";
const char *ffg = "%s %%f%d, %%g%d";
const char *fffl = "%s %%f%d, %%f%d, %s";
const char *ffff = "%s %%f%d, %%f%d, %%f%d";
const char *ffgi = "%s %%f%d, %%g%d, %d";

static int aacnt[32];

int encode_op(char *opcode, char *op_data)
{
	int rd,rs,rt,imm,funct,shaft,target;
	char tmp[256];
	char lname[256];
	int i;
	shaft = funct = target = 0;

	if(strcmp(opcode, "mov") == 0){
		if(sscanf(op_data, fgg, tmp, &rd, &rs) == 3) {
	 		if (is_xreg(rs) || is_xreg(rd)) {
				OP(mov),G(rd),GC(rs),NL;
			} else {
				OP(mov),S(eax),GC(rs),NL;
				OP(mov),G(rd),SC(eax),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "mvhi") == 0){
		if(sscanf(op_data, fgi, tmp, &rt, &imm) == 3) {
			OP(and),G(rt),S(0xffff),NL;
			OP(or),G(rt),IM((imm&0xffff)<<16),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "mvlo") == 0){
		if(sscanf(op_data, fgi, tmp, &rt, &imm) == 3) {
			OP(and),G(rt),S(0xffff0000),NL;
			OP(or),G(rt),IM(imm&0xffff),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "add") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {
	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(add),G(rs),GC(rt),NL;
			} else {
				OP(mov),S(edx),GC(rs),NL;
				OP(add),S(edx),GC(rt),NL;
				OP(mov),G(rd),SC(edx),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "sub") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {
	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(sub),G(rs),GC(rt),NL;
			} else {
				OP(mov),S(edx),GC(rs),NL;
				OP(sub),S(edx),GC(rt),NL;
				OP(mov),G(rd),SC(edx),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "mul") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {
	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(imul),G(rs),GC(rt),NL;
			} else {
				OP(mov),S(edx),GC(rs),NL;
				OP(imul),S(edx),GC(rt),NL;
				OP(mov),G(rd),SC(edx),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "div") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {
	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(div),G(rs),GC(rt),NL;
			} else {
				OP(mov),S(edx),GC(rs),NL;
				OP(div),S(edx),GC(rt),NL;
				OP(mov),G(rd),SC(edx),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "addi") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {

	 		if ((rt == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(add),G(rt),IMDW(imm),NL;
			} else if (is_xreg(rs) || is_xreg(rt)) {
				OP(mov),G(rt),GC(rs),NL;
				OP(add),G(rt),IMDW(imm),NL;
			} else {
				OP(mov),S(edx),GC(rs),NL;
				OP(add),S(edx),IMDW(imm),NL;
				OP(mov),G(rt),SC(edx),NL;
			}

		    return 0;
		}
	}
	if(strcmp(opcode, "subi") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {
	 		if ((rt == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(sub),G(rt),IMDW(imm),NL;
			} else if (is_xreg(rs) || is_xreg(rt)) {
				OP(mov),G(rt),GC(rs),NL;
				OP(sub),G(rt),IMDW(imm),NL;
			} else {
				OP(mov),S(edx),GC(rs),NL;
				OP(sub),S(edx),IMDW(imm),NL;
				OP(mov),G(rt),SC(edx),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "muli") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {
	 		if ((rt == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(imul),G(rt),IMDW(imm),NL;
			} else {
				OP(mov),S(edx),GC(rs),NL;
				OP(imul),S(edx),IMDW(imm),NL;
				OP(mov),G(rt),SC(edx),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "divi") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {
	 		if ((rt == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(div),G(rt),IMDW(imm),NL;
			} else if (is_xreg(rs) || is_xreg(rt)) {
				OP(mov),G(rt),GC(rs),NL;
				OP(div),G(rt),IMDW(imm),NL;
			} else {
				OP(mov),S(edx),GC(rs),NL;
				OP(div),S(edx),IMDW(imm),NL;
				OP(mov),G(rt),SC(edx),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "input") == 0){
		if(sscanf(op_data, fg, tmp, &rd) == 2) {
			OP(xor),S(rax),SC(rax),NL;
			OP(call),S(InChar),NL;
			OP(mov),G(rd),SC(eax),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "output") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2) {
			OP(mov),S(eax),GC(rs),NL;
			OP(call),S(OutChar),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "and") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {

			OP(mov),S(edx),GC(rs),NL;
			OP(and),S(edx),GC(rt),NL;
			OP(mov),G(rd),SC(edx),NL;

		    return 0;
		}
	}
	if(strcmp(opcode, "or") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {

			OP(mov),S(edx),GC(rs),NL;
			OP(or),S(edx),GC(rt),NL;
			OP(mov),G(rd),SC(edx),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "not") == 0){
		if(sscanf(op_data, fgg, tmp, &rd, &rs) == 3) {
			if (rd == rs) {
				OP(not),G(rd),NL;
			} else if (is_xreg(rs) || is_xreg(rd)) {
				OP(mov),G(rd),GC(rs),NL;
				OP(not),G(rd),NL;
			} else {
				OP(mov),S(edx),GC(rs),NL;
				OP(not),S(edx),NL;
				OP(mov),G(rd),SC(edx),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "sll") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {
	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(shl),G(rs),GC(rt),NL;
			} else {
				OP(mov),S(edx),GC(rs),NL;
				OP(shl),S(edx),GC(rt),NL;
				OP(mov),G(rd),SC(edx),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "srl") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {
	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(shr),G(rs),GC(rt),NL;
			} else {
				OP(mov),S(edx),GC(rs),NL;
				OP(shr),S(edx),GC(rt),NL;
				OP(mov),G(rd),SC(edx),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "slli") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {

	 		if ((rt == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(shl),G(rt),IM(imm),NL;
			} else if (is_xreg(rs) || is_xreg(rt)) {
				OP(mov),G(rt),GC(rs),NL;
				OP(shl),DWORD, G(rt),IM(imm),NL;
			} else {
				OP(mov),S(edx),GC(rs),NL;
				OP(shl),S(edx),IM(imm),NL;
				OP(mov),G(rt),SC(edx),NL;
			}

		    return 0;
		}
	}
	if(strcmp(opcode, "srli") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {

	 		if ((rt == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(shr),G(rt),IM(imm),NL;
			} else if (is_xreg(rs) || is_xreg(rt)) {
				OP(mov),G(rt),GC(rs),NL;
				OP(shr),DWORD, G(rt),IM(imm),NL;
			} else {
				OP(mov),S(edx),GC(rs),NL;
				OP(shr),S(edx),IM(imm),NL;
				OP(mov),G(rt),SC(edx),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "b") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2) {
			if (is_xreg(rs)) {
				OP(jmp),GQ(rs),NL;
			} else {
				OP(mov),S(edx),GC(rs),NL;
				OP(jmp),S(rdx),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "jmp") == 0){
		if(sscanf(op_data, fl, tmp, lname) == 2) { 
			if (strcmp(lname, "min_caml_start") != 0) {
				OP(jmp),L(lname),NL;
				return 0;
			} else {
				return 0;
			}
		}
	}
	if(strcmp(opcode, "jeq") == 0){
		if(sscanf(op_data, fggl, tmp, &rs, &rt, lname) == 4) { 
			OP(mov),S(edx),GC(rs),NL;
			OP(cmp),S(edx),GC(rt),NL;
			OP(je),L(lname),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "jne") == 0){
		if(sscanf(op_data, fggl, tmp, &rs, &rt, lname) == 4) { 
			if (is_xreg(rt) || is_xreg(rs)) {
				OP(cmp),G(rs),GC(rt),NL;
				OP(jne),L(lname),NL;
			} else {
				OP(mov),S(edx),GC(rs),NL;
				OP(cmp),S(edx),GC(rt),NL;
				OP(jne),L(lname),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "jlt") == 0){
		if(sscanf(op_data, fggl, tmp, &rs, &rt, lname) == 4) { 
			
			if (is_xreg(rt) || is_xreg(rs)) {
				if (is_const(rs)) {
					OP(cmp),G(rt),GC(rs),NL;
					OP(jg),L(lname),NL;
				} else {
					OP(cmp),G(rs),GC(rt),NL;
					OP(jl),L(lname),NL;
				}
			} else {
				OP(mov),S(eax),GC(rs),NL;
				OP(cmp),S(eax),GC(rt),NL;
				OP(jl),L(lname),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "jle") == 0){
		if(sscanf(op_data, fggl, tmp, &rs, &rt, lname) == 4) { 
			OP(mov),S(eax),GC(rs),NL;
			OP(cmp),S(eax),GC(rt),NL;
			OP(jle),L(lname),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "call") == 0){
		if(sscanf(op_data, fl, tmp, lname) == 2)  { 
			OP(call),L(lname),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "callR") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2) {
			if (is_xreg(rs)) {
				OP(call),GQ(rs),NL;
			} else {
				OP(mov),S(edx),GC(rs),NL;
				OP(call),S(rdx),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "return") == 0){
			OP(ret),NL;
		    return 0;
	}
	if(strcmp(opcode, "ld") == 0){
		if(sscanf(op_data, fggi, tmp, &rs, &rt, &imm) == 4) {

			if (is_xreg(rs) && is_xreg(rt)) {
				OP(mov),G(rs),
				printf(", ["),G(rt),printf(" - %d]\n", imm);
			} else if (is_xreg(rs)) {
				OP(mov),S(edx),GC(rt),NL;
				OP(mov),G(rs),ADRC(edx,imm),NL;
			} else {
				OP(mov),S(edx),GC(rt),NL;
				OP(mov),S(eax),ADRC(edx,imm),NL;
				OP(mov),G(rs),SC(eax),NL;
			}

		    return 0;
		}
	}
	if(strcmp(opcode, "st") == 0){
		if(sscanf(op_data, fggi, tmp, &rs, &rt, &imm) == 4) {

			if (is_xreg(rs) && is_xreg(rt)) {
				OP(mov),
				printf("["),G(rt),printf(" - %d]", imm),
				GC(rs), NL;
			} else if (is_xreg(rs)) {
				OP(mov),S(eax),GC(rt),NL;
				OP(mov),ADR(eax,imm),GC(rs),NL;
			} else {
				OP(mov),S(edx),GC(rs),NL;
				OP(mov),S(eax),GC(rt),NL;
				OP(mov),ADR(eax,imm),SC(edx),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "fadd") == 0){
		if(sscanf(op_data, ffff, tmp, &rd, &rs, &rt) == 4) {
			OP(fld),F(rs),NL;
			OP(fadd),F(rt),NL;
			OP(fstp),F(rd),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "fsub") == 0){
		if(sscanf(op_data, ffff, tmp, &rd, &rs, &rt) == 4) {
			OP(fld),F(rs),NL;
			OP(fsub),F(rt),NL;
			OP(fstp),F(rd),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "fmul") == 0){
		if(sscanf(op_data, ffff, tmp, &rd, &rs, &rt) == 4) {
			OP(fld),F(rs),NL;
			OP(fmul),F(rt),NL;
			OP(fstp),F(rd),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "fdiv") == 0){
		if(sscanf(op_data, ffff, tmp, &rd, &rs, &rt) == 4) {
			OP(fld),F(rs),NL;
			OP(fdiv),F(rt),NL;
			OP(fstp),F(rd),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "fsqrt") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3) {
			OP(fld),F(rs),NL;
			OP(fsqrt),NL;
			OP(fstp),F(rd),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "fabs") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3) {
			OP(fld),F(rs),NL;
			OP(fabs),NL;
			OP(fstp),F(rd),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "fmov") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3) {
			OP(fld),F(rs),NL;
			OP(fstp),F(rd),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "fneg") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3) {
			OP(fld),F(rs),NL;
			OP(fchs),NL;
			OP(fstp),F(rd),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "fld") == 0){
		if(sscanf(op_data, ffgi, tmp, &rs, &rt, &imm) == 4) {
			OP(mov),S(edx),GC(rt),NL;
			OP(mov),S(eax),ADRC(edx,imm),NL;
			OP(mov),F(rs),SC(eax),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "fst") == 0){
		if(sscanf(op_data, ffgi, tmp, &rs, &rt, &imm) == 4) {
			OP(mov),S(edx),FC(rs),NL;
			OP(mov),S(eax),GC(rt),NL;
			OP(mov),ADR(eax,imm),SC(edx),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "fjeq") == 0){
		if(sscanf(op_data, fffl, tmp, &rs, &rt, lname) == 4) {
			OP(fld),F(rt),NL;
			OP(fld),F(rs),NL;
			OP(fcompp),NL;
			OP(fnstsw),S(ax),NL;
			OP(sahf),NL;
			OP(je),L(lname),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "fjlt") == 0){
		if(sscanf(op_data, fffl, tmp, &rs, &rt, lname) == 4) {
			OP(fld),F(rt),NL;
			OP(fld),F(rs),NL;
			OP(fcompp),NL;
			OP(fnstsw),S(ax),NL;
			OP(sahf),NL;
			OP(jb),L(lname),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "nop") == 0){
		OP(nop),NL;
		return 0;
	}
	if(strcmp(opcode, "halt") == 0){
		OP(call),S(Exit),NL;
		for (i = 0; i < 32; i++) {
			fprintf(stderr, "g%3d : %d\n", i, aacnt[i]);
		}
		return 0;
	}
	if(strcmp(opcode, "setL") == 0){
		if(sscanf(op_data, fgl, tmp, &rd, lname) == 3) {
			OP(mov),DWORD,G(rd),LC(lname),NL;
		    return 0;
		}
	}

	/*
	if(strcmp(opcode, "sqrt") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3)
		    return 0;
	}
	if(strcmp(opcode, "sin") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3) {
		    return 0;
		}
	}
	if(strcmp(opcode, "cos") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3) {
		    return 0;
		}
	}
	if(strcmp(opcode, "atan") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3) {
		    return 0;
		}
	}
	if(strcmp(opcode, "int_of_float") == 0){
		if(sscanf(op_data, fgf, tmp, &rd, &rs) == 3) {
		    return 0;
		}
	}
	if(strcmp(opcode, "float_of_int") == 0){
		if(sscanf(op_data, ffg, tmp, &rd, &rs) == 3) {
		    return 0;
		}
	}
	*/

	return -1;
}

void print_gr(int register_index, int comma_flag, int quad_flag) {
	char *datalen1 = (quad_flag) ? (char *)"" : (char *)"d";
	char *datalen2 = (quad_flag) ? (char *)"r" : (char *)"e";
	if (comma_flag) {
		printf(", ");
	} else {
		if (is_const(register_index)) {
			printf("eax");
			return ;
		}
	}
	switch (register_index) {
		case 0 : printf("dword 0"); break;
		case 28: printf("dword 1"); break;
		case 29: printf("dword -1"); break;
		case 1 :
		case 2 :
		case 3 :
		case 4 :
		case 5 :
				printf("r1%d%s", register_index, datalen1); break;
		case 6:
				printf("r10%s", datalen1); break;
		case 10:
				printf("%sbx", datalen2); break;
		case 11:
				printf("%scx", datalen2); break;
		case 12:
				printf("%ssi", datalen2); break;
		case 13:
				printf("%sdi", datalen2); break;
		case 15:
				printf("%sbp", datalen2); break;
		case 26:
				printf("r8%s", datalen1); break;
		case 27:
				printf("r9%s", datalen1); break;
		default :
				aacnt[register_index]++;
				printf("[GR%d]", register_index); break;
	}
}
int is_const(int i) {
	return (i == 0 || i == 28 || i == 29);
}
int is_xreg(int i) {
	return ((1 <= i && i <= 5) || i == 6 || (10<=i&&i<=13) ||
	i == 15 || i == 26 || i == 27 || is_const(i));
}
