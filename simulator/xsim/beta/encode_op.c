#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include "asm.h"
#include "reasm3.h"

const char *fg = "%s %%g%d";
const char *fl = "%s %s";
const char *fgi = "%s %%g%d, %d";
const char *fgl = "%s %%g%d, %s";
const char *fgg = "%s %%g%d, %%g%d";
const char *fggl = "%s %%g%d, %%g%d, %s";
const char *fggi = "%s %%g%d, %%g%d, %d";
const char *fggg = "%s %%g%d, %%g%d, %%g%d";
const char *ff = "%s %%f%d";
const char *fff = "%s %%f%d, %%f%d";
const char *fgf = "%s %%g%d, %%f%d";
const char *ffg = "%s %%f%d, %%g%d";
const char *fffl = "%s %%f%d, %%f%d, %s";
const char *ffff = "%s %%f%d, %%f%d, %%f%d";
const char *ffgi = "%s %%f%d, %%g%d, %d";

///static int aacnt[32];

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
				OP(movl),G(rs),GC(rd),NL;
			} else {
				OP(movl),G(rs),SC(%eax),NL;
				OP(movl),S(%eax),GC(rd),NL;
			}

		    return 0;
		}
	}
	if(strcmp(opcode, "mvhi") == 0){
		if(sscanf(op_data, fgi, tmp, &rt, &imm) == 3) {
			OP(andl),IM(0xffff), GC(rt),NL;
			OP(orl),IM((imm&0xffff)<<16),GC(rt),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "mvlo") == 0){
		if(sscanf(op_data, fgi, tmp, &rt, &imm) == 3) {
			OP(andl),IM(0xffff0000),GC(rt),NL;
			OP(orl),IM(imm&0xffff),GC(rt),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "add") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {

	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(addl),G(rt),GC(rs),NL;
			//} else if ((rd == rt) && (is_xreg(rd))) {
				//OP(addl),G(rs),GC(rd),NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(addl),G(rt),SC(%edx),NL;
				OP(movl),S(%edx),GC(rd),NL;
			}

		    return 0;
		}
	}
	if(strcmp(opcode, "sub") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {
	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(subl),G(rt),GC(rs),NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(subl),G(rt),SC(%edx),NL;
				OP(movl),S(%edx),GC(rd),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "mul") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {
	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(imull),G(rt),GC(rs),NL;
			//} else if ((rd == rt) && (is_xreg(rd))) {
				//OP(imull),G(rs),GC(rd),NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(imull),G(rt),SC(%edx),NL;
				OP(movl),S(%edx),GC(rd),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "div") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {
	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(divl),G(rt),GC(rs),NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(divl),G(rt),SC(%edx),NL;
				OP(movl),S(%edx),GC(rd),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "addi") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {

			if (rs == 0) {
				OP(movl),IM(imm),GC(rt),NL;
	 		} else if ((rt == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(addl),IM(imm),GC(rt), NL;
			} else if (is_xreg(rs) || is_xreg(rt)) {
				OP(movl),G(rs),GC(rt),NL;
				OP(addl),IM(imm),GC(rt), NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(addl),IM(imm),SC(%edx), NL;
				OP(movl),S(%edx),GC(rt),NL;
			}

		    return 0;
		}
	}
	if(strcmp(opcode, "subi") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {

	 		if ((rt == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(subl),IM(imm),GC(rt), NL;
			} else if (is_xreg(rs) || is_xreg(rt)) {
				OP(movl),G(rs),GC(rt),NL;
				OP(subl),IM(imm),GC(rt), NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(subl),IM(imm),SC(%edx), NL;
				OP(movl),S(%edx),GC(rt),NL;
			}

		    return 0;
		}
	}
	if(strcmp(opcode, "muli") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {
	 		if ((rt == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(imull),IM(imm),GC(rt), NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(imull),IM(imm),SC(%edx), NL;
				OP(movl),S(%edx),GC(rt),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "divi") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {
	 		if ((rt == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(divl),IM(imm),GC(rt), NL;
			} else if (is_xreg(rs) || is_xreg(rt)) {
				OP(movl),G(rs),GC(rt),NL;
				OP(divl),IM(imm),GC(rt), NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(divl),IM(imm),SC(%edx), NL;
				OP(movl),S(%edx),GC(rt),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "input") == 0){
		if(sscanf(op_data, fg, tmp, &rd) == 2) {
			OP(xorl),S(%eax),SC(%eax),NL;
			OP(call),S(InChar),NL;
			OP(movl),S(%eax),GC(rd),NL;
		    return 0;
		}
	}

	if(strcmp(opcode, "output") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2) {
			OP(movl),G(rs),SC(%eax),NL;
			OP(call),S(OutChar),NL;
		    return 0;
		}
	}

	if(strcmp(opcode, "outputH") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2) {
			OP(movl),G(rs),SC(%eax),NL;
			OP(call),S(PrintHex8),NL;
		    return 0;
		}
	}

	if(strcmp(opcode, "outputF") == 0){
		if(sscanf(op_data, ff, tmp, &rs) == 2) {
			OP(movl),F(rs),SC(%eax),NL;
			OP(call),S(PrintHex8),NL;
		    return 0;
		}
	}

	if(strcmp(opcode, "and") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {

	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(andl),G(rt),GC(rs),NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(andl),G(rt),SC(%edx),NL;
				OP(movl),S(%edx),GC(rd),NL;
			}

		    return 0;
		}
	}
	if(strcmp(opcode, "or") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {

	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(orl),G(rt),GC(rs),NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(orl),G(rt),SC(%edx),NL;
				OP(movl),S(%edx),GC(rd),NL;
			}

		    return 0;
		}
	}
	if(strcmp(opcode, "not") == 0){
		if(sscanf(op_data, fgg, tmp, &rd, &rs) == 3) {

			if (rd == rs) {
				OP(notl),G(rd),NL;
	 		} else if (is_xreg(rs) || is_xreg(rd)) {
				OP(movl),G(rs),GC(rd),NL;
				OP(notl),G(rd),NL;
			} else {
				OP(movl),G(rs),SC(%eax),NL;
				OP(notl),S(%eax),NL;
				OP(movl),S(%eax),GC(rd),NL;
			}

		    return 0;
		}
	}
	if(strcmp(opcode, "sll") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {

	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(shll),G(rt),GC(rs),NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(shll),G(rt),SC(%edx),NL;
				OP(movl),S(%edx),GC(rd),NL;
			}

		    return 0;
		}
	}
	if(strcmp(opcode, "srl") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {

	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(shrl),G(rt),GC(rs),NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(shrl),G(rt),SC(%edx),NL;
				OP(movl),S(%edx),GC(rd),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "slli") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {

	 		if ((rt == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(shll),IM(imm),GC(rt), NL;
			} else if (is_xreg(rs) || is_xreg(rt)) {
				OP(movl),G(rs),GC(rt),NL;
				OP(shll),IM(imm),GC(rt), NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(shll),IM(imm),SC(%edx), NL;
				OP(movl),S(%edx),GC(rt),NL;
			}

		    return 0;
		}
	}
	if(strcmp(opcode, "srli") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {

	 		if ((rt == rs) && (is_xreg(rs) || is_xreg(rt))) {
				OP(shrl),IM(imm),GC(rt), NL;
			} else if (is_xreg(rs) || is_xreg(rt)) {
				OP(movl),G(rs),GC(rt),NL;
				OP(shrl),IM(imm),GC(rt), NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(shrl),IM(imm),SC(%edx), NL;
				OP(movl),S(%edx),GC(rt),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "b") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2) {
			if (is_xreg(rs)) {
				OP(jmp *),GQ(rs),NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(jmp *),S(%rdx),NL;
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
			OP(movl),G(rs),SC(%edx),NL;
			OP(cmpl),G(rt),SC(%edx),NL;
			OP(je),L(lname),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "jne") == 0){
		if(sscanf(op_data, fggl, tmp, &rs, &rt, lname) == 4) { 
			if (is_xreg(rt) || is_xreg(rs)) {
				OP(cmpl),G(rt),GC(rs),NL;
				OP(jne),L(lname),NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(cmpl),G(rt),SC(%edx),NL;
				OP(jne),L(lname),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "jlt") == 0){
		if(sscanf(op_data, fggl, tmp, &rs, &rt, lname) == 4) { 
			
			if (is_xreg(rt) || is_xreg(rs)) {
				if (is_const(rs)) {
					OP(cmpl),G(rs),GC(rt),NL;
					OP(jg),L(lname),NL;
				} else {
					OP(cmpl),G(rt),GC(rs),NL;
					OP(jl),L(lname),NL;
				}
			} else {
				OP(movl),G(rs),SC(%eax),NL;
				OP(cmpl),G(rt),SC(%eax),NL;
				OP(jl),L(lname),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "jle") == 0){
		if(sscanf(op_data, fggl, tmp, &rs, &rt, lname) == 4) { 
			OP(movl),G(rs),SC(%eax),NL;
			OP(cmp),G(rt),SC(%eax),NL;
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
				OP(call *),GQ(rs),NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(call *),S(%rdx),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "return") == 0){
			OP(ret),NL;
		    return 0;
	}
	if(strcmp(opcode, "ld") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {

			if (is_xreg(rs) && is_xreg(rt)) {
				OP(movl),
				printf("-%d(",imm),G(rs),printf(")"),
				GC(rt),NL;
			} else if (is_xreg(rt)) {
				OP(movl),G(rs),SC(%edx),NL;
				OP(movl),ADR(%edx,imm),GC(rt),NL;
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(movl),ADR(%edx,imm),SC(%eax),NL;
				OP(movl),S(%eax),GC(rt),NL;
			}

		    return 0;
		}
	}
	if(strcmp(opcode, "st") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {

			if (is_xreg(rs) && is_xreg(rt)) {
				OP(movl),G(rt),
				printf(", -%d(",imm),G(rs),printf(")\n");
			} else if (is_xreg(rt)) {
				OP(movl),G(rs),SC(%eax),NL;
				OP(movl),G(rt),ADRC(%eax,imm),NL;
			} else {
				OP(movl),G(rs),SC(%eax),NL;
				OP(movl),G(rt),SC(%edx),NL;
				OP(movl),S(%edx),ADRC(%eax,imm),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "fadd") == 0){
		if(sscanf(op_data, ffff, tmp, &rd, &rs, &rt) == 4) {

	 		if ((rd == rs) && (is_xmm(rs))) {
				OP(addss),F(rt),FC(rs),NL;
			} else if ((rd == rt) && (is_xmm(rd))) {
				OP(addss),F(rs),FC(rd),NL;
			} else {
				OP(movss),F(rs),SC(%xmm15),NL;
				OP(addss),F(rt),SC(%xmm15),NL;
				OP(movss),S(%xmm15),FC(rd),NL;
			}

		    return 0;
		}
	}
	if(strcmp(opcode, "fsub") == 0){
		if(sscanf(op_data, ffff, tmp, &rd, &rs, &rt) == 4) {
	 		if ((rd == rs) && (is_xmm(rs))) {
				OP(subss),F(rt),FC(rs),NL;
			} else {
				OP(movss),F(rs),SC(%xmm15),NL;
				OP(subss),F(rt),SC(%xmm15),NL;
				OP(movss),S(%xmm15),FC(rd),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "fmul") == 0){
		if(sscanf(op_data, ffff, tmp, &rd, &rs, &rt) == 4) {
	 		if ((rd == rs) && (is_xmm(rs))) {
				OP(mulss),F(rt),FC(rs),NL;
			} else if ((rd == rt) && (is_xmm(rd))) {
				OP(mulss),F(rs),FC(rd),NL;
			} else {
				OP(movss),F(rs),SC(%xmm15),NL;
				OP(mulss),F(rt),SC(%xmm15),NL;
				OP(movss),S(%xmm15),FC(rd),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "fdiv") == 0){
		if(sscanf(op_data, ffff, tmp, &rd, &rs, &rt) == 4) {
	 		if ((rd == rs) && (is_xmm(rs))) {
				OP(divss),F(rt),FC(rs),NL;
				//OP(rcpss),F(rt),FC(rt),NL;
				//OP(mulss),F(rs),FC(rt),NL;
			} else {
				OP(movss),F(rs),SC(%xmm15),NL;
				OP(divss),F(rt),SC(%xmm15),NL;
				OP(movss),S(%xmm15),FC(rd),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "fsqrt") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3) {

	 		if (is_xreg(rd)) {
				OP(sqrtss),F(rs),FC(rd),NL;
			} else {
				OP(movss),F(rs),SC(%xmm15),NL;
				OP(sqrtss),S(%xmm15),SC(%xmm15),NL;
				OP(movss),S(%xmm15),FC(rd),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "fabs") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3) {
			OP(movss),F(rs),SC(%eax),NL;
			OP(andl),IM(0x7fffffff),SC(%eax),NL;
			OP(movss),S(%eax),FC(rd),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "fmov") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3) {
			if (is_xmm(rd)) {
				OP(movss),F(rs),FC(rd),NL;
			} else {
				if (is_xmm(rs)) {
					OP(movd),F(rs),SC(%eax),NL;
				} else {
					OP(movl),F(rs),SC(%eax),NL;
				}
				OP(movl),S(%eax),FC(rd),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "fneg") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3) {
			if (is_xmm(rs)) {
				OP(movd),F(rs),SC(%eax),NL;
			} else {
				OP(movl),F(rs),SC(%eax),NL;
			}
			OP(xorl),IM(1<<31),SC(%eax),NL;
			if (is_xmm(rd)) {
				OP(movd),S(%eax),FC(rd),NL;
			} else {
				OP(movl),S(%eax),FC(rd),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "fld") == 0){
		if(sscanf(op_data, ffgi, tmp, &rt, &rs, &imm) == 4) {
			if (is_xmm(rt)) {
				if (is_xreg(rs)) {
					OP(movss),
					printf("-%d(",imm),G(rs),printf(")"),
					FC(rt),NL;
				} else {
					OP(movl),G(rs),SC(%edx),NL;
					OP(movss),ADR(%edx,imm), FC(rt),NL;
				}
			} else {
				OP(movl),G(rs),SC(%edx),NL;
				OP(movl),ADR(%edx,imm), SC(%eax),NL;
				OP(movl),S(%eax),FC(rt),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "fst") == 0){
		if(sscanf(op_data, ffgi, tmp, &rt, &rs, &imm) == 4) {
			if (is_xmm(rt)) {
				if (is_xreg(rs)) {
					OP(movss),F(rt),
					printf(", -%d(",imm),G(rs),printf(")\n");
				} else {
					OP(movl),G(rs),SC(%eax),NL;
					OP(movss),F(rt),ADRC(%eax,imm),NL;
				}
			} else {
				OP(movl),F(rt),SC(%edx),NL;
				OP(movl),G(rs),SC(%eax),NL;
				OP(movl),S(%edx),ADRC(%eax,imm),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "fjeq") == 0){
		if(sscanf(op_data, fffl, tmp, &rs, &rt, lname) == 4) {
			if (is_xmm(rs) && is_xmm(rt)) {
				OP(comiss),F(rt),FC(rs),NL;
				OP(je),L(lname),NL;
			} else if (is_xmm(rs)) {
				OP(movss), F(rt),SC(%xmm15),NL;
				OP(comiss),S(%xmm15),FC(rs),NL;
				OP(je),L(lname),NL;
			} else if (is_xmm(rt)) {
				OP(movss), F(rs),SC(%xmm15),NL;
				OP(comiss),F(rt),SC(%xmm15),NL;
				OP(je),L(lname),NL;
			} else {
				OP(flds),F(rt),NL;
				OP(flds),F(rs),NL;
				OP(fcompp),NL;
				OP(fnstsw),S(%ax),NL;
				OP(sahf),NL;
				OP(je),L(lname),NL;
			}
		    return 0;
		}
	}
	if(strcmp(opcode, "fjlt") == 0){
		if(sscanf(op_data, fffl, tmp, &rs, &rt, lname) == 4) {

			if (is_xmm(rs) && is_xmm(rt)) {
				OP(comiss),F(rt),FC(rs),NL;
				OP(jb),L(lname),NL;
			} else if (is_xmm(rs)) {
				OP(movss), F(rt),SC(%xmm15),NL;
				OP(comiss),S(%xmm15),FC(rs),NL;
				OP(jb),L(lname),NL;
			} else if (is_xmm(rt)) {
				OP(movss), F(rs),SC(%xmm15),NL;
				OP(comiss),F(rt),SC(%xmm15),NL;
				OP(jb),L(lname),NL;
			} else {
				OP(flds),F(rt),NL;
				OP(flds),F(rs),NL;
				OP(fcompp),NL;
				OP(fnstsw),S(%ax),NL;
				OP(sahf),NL;
				OP(jb),L(lname),NL;
			}

		    return 0;
		}
	}
	if(strcmp(opcode, "nop") == 0){
		OP(nop),NL;
		return 0;
	}
	if(strcmp(opcode, "halt") == 0){
		if (count_flag) {
			OP(call),S(NewLine),NL;
			OP(movq),S((CNT)),SC(%rax),NL;
			OP(call),S(PrintHex16),NL;
			OP(call),S(NewLine),NL;
		}
		OP(call),S(Exit),NL;
		return 0;
	}
	if(strcmp(opcode, "setL") == 0){
		if(sscanf(op_data, fgl, tmp, &rd, lname) == 3) {
			OP(movl),printf("$%s",lname),GC(rd),NL;
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
		if (is_const(register_index)) {
			printf("%%eax");
			return ;
		}
	}
	switch (register_index) {
		case 0 : printf("$0"); break;
		case 28: printf("$1"); break;
		case 29: printf("$-1"); break;
		case 26:
				printf("%%r8%s", datalen1); break;
		case 1:
				printf("%%r9%s", datalen1); break;
		case 31:
				printf("%%r10%s", datalen1); break;
		case 3:
				printf("%%r11%s", datalen1); break;
		case 18:
				printf("%%r12%s", datalen1); break;
		case 4:
				printf("%%r13%s", datalen1); break;
		case 5:
				printf("%%r14%s", datalen1); break;
		case 19:
				printf("%%r15%s", datalen1); break;
		case 6:
				printf("%%%sbx", datalen2); break;
		case 10:
				printf("%%%scx", datalen2); break;
		case 12:
				printf("%%%ssi", datalen2); break;
		case 17:
				printf("%%%sdi", datalen2); break;
		case 11:
				printf("%%%sbp", datalen2); break;
		default :
				///aacnt[register_index]++;
				printf("(GR%d)", register_index); break;
	}
}

void print_fr(int register_index, int comma_flag) {
	if (comma_flag) {
		printf(", ");
	}
	switch (register_index) {
		case 0 : 
			printf("%%xmm0"); break;
		case 1 :
			printf("%%xmm1"); break;
		case 2 :
			printf("%%xmm2"); break;
		case 12 :
			printf("%%xmm3"); break;
		case 10 :
			printf("%%xmm4"); break;
		case 11 :
			printf("%%xmm5"); break;
		case 3 :
			printf("%%xmm6"); break;
		case 13 :
			printf("%%xmm7"); break;
		case 14 :
			printf("%%xmm8"); break;
		case 4 :
			printf("%%xmm9"); break;
		case 9 :
			printf("%%xmm10"); break;
		case 5 :
			printf("%%xmm11"); break;
		case 16 :
			printf("%%xmm12"); break;
		case 7 :
			printf("%%xmm13"); break;
		case 6 :
			printf("%%xmm14"); break;
		default :
			printf("(FR%d)", register_index); break;
	}
}

int is_const(int i) {
	return (i == 0 || i == 28 || i == 29);
}

int is_xreg(int i) {
	int j;
	const int num = 13;
	const int a[num] = {26,1,31,3,18,4,5,19,6,10,12,17,11};
	if (is_const(i)) {
		return 1;
	}
	for (j = 0; j < num; j++) {
		if (i == a[j]) {
			return 1;
		}
	}
	return 0;
}

int is_xmm(int i) {
	int j;
	const int num = 15;
	const int a[num] = {1,0,2,12,10,11,3,13,14,4,9,5,16,7,6};
	for (j = 0; j < num; j++) {
		if (i == a[j]) {
			return 1;
		}
	}
	return 0;
}
