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

int encode_op(char *opcode, char *op_data)
{
	int rd,rs,rt,imm,funct,shaft,target;
	char tmp[256];

	char lname[256];
	shaft = funct = target = 0;
	if(strcmp(opcode, "mov") == 0){
		if(sscanf(op_data, fgg, tmp, &rd, &rs) == 3) {
			OP(mov),S(r14d),GC(rs),NL;
			OP(mov),G(rd),SC(r14d),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "mvhi") == 0){
		if(sscanf(op_data, fgi, tmp, &rt, &imm) == 3) {
			OP(mov),S(r14w),IM(imm&0xffff),NL;
			OP(mov),GA(rt,-2),SC(r14w),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "mvlo") == 0){
		if(sscanf(op_data, fgi, tmp, &rt, &imm) == 3) {
			OP(mov),S(r14w),IM(imm&0xffff),NL;
			OP(mov),G(rt),SC(r14w),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "add") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {
			OP(mov),S(r15d),GC(rs),NL;
			OP(mov),S(r14d),GC(rt),NL;
			OP(add),S(r15d),SC(r14d),NL;
			OP(mov),G(rd),SC(r15d),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "sub") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {
			OP(mov),S(r15d),GC(rs),NL;
			OP(mov),S(r14d),GC(rt),NL;
			OP(sub),S(r15d),SC(r14d),NL;
			OP(mov),G(rd),SC(r15d),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "mul") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {
			OP(mov),S(eax),GC(rs),NL;
			OP(mov),S(r15d),GC(rt),NL;
			OP(imul),S(r15d),NL;
			OP(mov),G(rd),SC(eax),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "div") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {
			OP(mov),S(r15d),GC(rs),NL;
			OP(mov),S(r14d),GC(rt),NL;
			OP(div),S(r15d),SC(r14d),NL;
			OP(mov),G(rd),SC(r15d),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "addi") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {
			OP(mov),S(r15d),GC(rs),NL;
			OP(add),S(r15d),IM(imm),NL;
			OP(mov),G(rt),SC(r15d),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "subi") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {
			OP(mov),S(r15d),GC(rs),NL;
			OP(sub),S(r15d),IM(imm),NL;
			OP(mov),G(rt),SC(r15d),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "muli") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {
			OP(mov),S(r15d),GC(rs),NL;
			OP(imul),S(r15d),IM(imm),NL;
			OP(mov),G(rt),SC(r15d),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "divi") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {
			OP(mov),S(r15d),GC(rs),NL;
			OP(div),S(r15d),IM(imm),NL;
			OP(mov),G(rt),SC(r15d),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "input") == 0){
		if(sscanf(op_data, fg, tmp, &rd) == 2) {
			OP(call),S(GetChar),NL;
			OP(mov),G(rd),SC(eax),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "output") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2) {
			OP(mov),S(eax),GC(rs),NL;
			OP(call),S(PutChar),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "PrintBin") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2) {
			OP(mov),S(eax),GC(rs),NL;
			OP(call),S(PrintBin),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "PrintHex") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2) {
			OP(mov),S(eax),GC(rs),NL;
			OP(call),S(PrintHex8),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "Chk") == 0){
		OP(call),S(Chk),NL;
		return 0;
	}
	if(strcmp(opcode, "and") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {
			OP(mov),S(r15d),GC(rs),NL;
			OP(mov),S(r14d),GC(rt),NL;
			OP(and),S(r15d),SC(r14d),NL;
			OP(mov),G(rd),SC(r15d),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "or") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {
			OP(mov),S(r15d),GC(rs),NL;
			OP(mov),S(r14d),GC(rt),NL;
			OP(or),S(r15d),SC(r14d),NL;
			OP(mov),G(rd),SC(r15d),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "not") == 0){
		if(sscanf(op_data, fgg, tmp, &rd, &rs) == 3) {
			OP(mov),S(r15d),GC(rs),NL;
			OP(not),S(r15d),NL;
			OP(mov),G(rd),SC(r15d),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "sll") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {
			OP(mov),S(r15d),GC(rs),NL;
			OP(mov),S(r14d),GC(rt),NL;
			OP(shl),S(r15d),SC(r14d),NL;
			OP(mov),G(rd),SC(r15d),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "srl") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4) {
			OP(mov),S(r15d),GC(rs),NL;
			OP(mov),S(r14d),GC(rt),NL;
			OP(shr),S(r15d),SC(r14d),NL;
			OP(mov),G(rd),SC(r15d),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "slli") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {
			OP(mov),S(r15d),GC(rs),NL;
			OP(shl),S(r15d),IM(imm),NL;
			OP(mov),G(rt),SC(r15d),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "srli") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4) {
			OP(mov),S(r15d),GC(rs),NL;
			OP(shr),S(r15d),IM(imm),NL;
			OP(mov),G(rt),SC(r15d),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "b") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2) {
			OP(xor),S(r15),SC(r15),NL;
			OP(mov),S(r15d),GC(rs),NL;
			OP(jmp),S(r15),NL;
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
			OP(mov),S(r15d),GC(rs),NL;
			OP(cmp),S(r15d),GC(rt),NL;
			OP(je),L(lname),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "jne") == 0){
		if(sscanf(op_data, fggl, tmp, &rs, &rt, lname) == 4) { 
			OP(mov),S(r15d),GC(rs),NL;
			OP(cmp),S(r15d),GC(rt),NL;
			OP(jne),L(lname),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "jlt") == 0){
		if(sscanf(op_data, fggl, tmp, &rs, &rt, lname) == 4) { 
			OP(mov),S(r14d),GC(rs),NL;
			OP(cmp),S(r14d),GC(rt),NL;
			OP(jl),L(lname),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "jle") == 0){
		if(sscanf(op_data, fggl, tmp, &rs, &rt, lname) == 4) { 
			OP(mov),S(r14d),GC(rs),NL;
			OP(cmp),S(r14d),GC(rt),NL;
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
			OP(xor),S(r15),SC(r15),NL;
			OP(mov),S(r15d),GC(rs),NL;
			OP(call),S(r15),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "return") == 0){
			OP(ret),NL;
		    return 0;
	}
	if(strcmp(opcode, "ld") == 0){
		if(sscanf(op_data, fggi, tmp, &rs, &rt, &imm) == 4) {

			OP(mov),S(r15d),GC(rt),NL;
			OP(mov),S(r14d),ADRC(r15d,imm),NL;
			OP(mov),G(rs),SC(r14d),NL;
			
		    return 0;
		}
	}
	if(strcmp(opcode, "st") == 0){
		if(sscanf(op_data, fggi, tmp, &rs, &rt, &imm) == 4) {

			OP(mov),S(r15d),GC(rs),NL;
			OP(mov),S(r14d),GC(rt),NL;
			OP(mov),ADR(r14d,imm),SC(r15d),NL;

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
			OP(mov),S(r15d),GC(rt),NL;
			OP(mov),S(r14d),ADRC(r15d,imm),NL;
			OP(mov),F(rs),SC(r14d),NL;
		    return 0;
		}
	}
	if(strcmp(opcode, "fst") == 0){
		if(sscanf(op_data, ffgi, tmp, &rs, &rt, &imm) == 4) {
			OP(mov),S(r15d),FC(rs),NL;
			OP(mov),S(r14d),GC(rt),NL;
			OP(mov),ADR(r14d,imm),SC(r15d),NL;
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
			//OP(call),S(PrintBin),NL;
			/////////////////////////////
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
			//OP(call),S(PrintBin),NL;
			/////////////////////////////
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
	*/
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

	return -1;
}
