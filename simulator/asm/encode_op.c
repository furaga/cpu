#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include "asm.h"
extern char label_name[LABEL_MAX][256];
extern uint32_t label_cnt;

uint32_t encode_op(char *opcode, char *op_data)
{
	int rd,rs,rt,imm,funct,shaft,target;
	char tmp[256];
	/*
	 * format
	 * g: general register
	 * i: immediate
	 * l: label
	 */
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

	char lname[256];
	shaft = funct = target = 0;
	//fprintf(stderr, "opcode:%s", opcode);
	//fflush(stderr);
	if(strcmp(opcode, "mov") == 0){
		if(sscanf(op_data, fgg, tmp, &rd, &rs) == 3)
		    return mov(rs,0,rd,0);
	}
	if(strcmp(opcode, "mvhi") == 0){
		if(sscanf(op_data, fgi, tmp, &rt, &imm) == 3)
		    return mvhi(0,rt,imm);
	}
	if(strcmp(opcode, "mvlo") == 0){
		if(sscanf(op_data, fgi, tmp, &rt, &imm) == 3)
		    return mvlo(0,rt,imm);
	}
	if(strcmp(opcode, "add") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return add(rs,rt,rd,0);
	}
	if(strcmp(opcode, "sub") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return sub(rs,rt,rd,0);
	}
	if(strcmp(opcode, "mul") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return mul(rs,rt,rd,0);
	}
	if(strcmp(opcode, "div") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return _div(rs,rt,rd,0);
	}
	if(strcmp(opcode, "addi") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4)
		    return addi(rs,rt,imm);
	}
	if(strcmp(opcode, "subi") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4)
		    return subi(rs,rt,imm);
	}
	if(strcmp(opcode, "muli") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4)
		    return muli(rs,rt,imm);
	}
	if(strcmp(opcode, "divi") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4)
		    return divi(rs,rt,imm);
	}
	if(strcmp(opcode, "input") == 0){
		if(sscanf(op_data, fg, tmp, &rd) == 2)
		    return input(0,0,rd,0);
	}
	if(strcmp(opcode, "output") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2)
		    return output(rs,0,0,0);
	}
	if(strcmp(opcode, "and") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return _and(rs,rt,rd,0);
	}
	if(strcmp(opcode, "or") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return _or(rs,rt,rd,0);
	}
	if(strcmp(opcode, "not") == 0){
		if(sscanf(op_data, fgg, tmp, &rd, &rs) == 3)
		    return _not(rs,0,rd,0);
	}
	if(strcmp(opcode, "sll") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return sll(rs,rt,rd,0);
	}
	if(strcmp(opcode, "srl") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return srl(rs,rt,rd,0);
	}
	if(strcmp(opcode, "slli") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4)
		    return slli(rs,rt,imm);
	}
	if(strcmp(opcode, "b") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2)
		    return b(rs,0,0,0);
	}
	if(strcmp(opcode, "jmp") == 0){
		if(sscanf(op_data, fl, tmp, lname) == 2) {
			strcpy(label_name[label_cnt],lname);
		    return jmp(label_cnt++);
		}
	}
	if(strcmp(opcode, "jeq") == 0){
		if(sscanf(op_data, fggl, tmp, &rs, &rt, lname) == 4) {
			strcpy(label_name[label_cnt],lname);
		    return jeq(rs,rt,label_cnt++);
		}
	}
	if(strcmp(opcode, "jne") == 0){
		if(sscanf(op_data, fggl, tmp, &rs, &rt, lname) == 4) {
			strcpy(label_name[label_cnt],lname);
		    return jne(rs,rt,label_cnt++);
		}
	}
	if(strcmp(opcode, "jlt") == 0){
		if(sscanf(op_data, fggl, tmp, &rs, &rt, lname) == 4) {
			strcpy(label_name[label_cnt],lname);
		    return jlt(rs,rt,label_cnt++);
		}
	}
	if(strcmp(opcode, "jle") == 0){
		if(sscanf(op_data, fggl, tmp, &rs, &rt, lname) == 4) {
			strcpy(label_name[label_cnt],lname);
		    return jle(rs,rt,label_cnt++);
		}
	}
	if(strcmp(opcode, "call") == 0){
		if(sscanf(op_data, fl, tmp, lname) == 2)  {
			strcpy(label_name[label_cnt],lname);
		    return call(label_cnt++);
		}
	}
	if(strcmp(opcode, "callR") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2)
		    return callr(rs,0,0,0);
	}
	if(strcmp(opcode, "return") == 0){
		    return _return(0);
	}
	if(strcmp(opcode, "ld") == 0){
		if(sscanf(op_data, fggi, tmp, &rs, &rt, &imm) == 4)
		    return ld(rs,rt,imm);
	}
	if(strcmp(opcode, "st") == 0){
		if(sscanf(op_data, fggi, tmp, &rs, &rt, &imm) == 4)
		    return st(rs,rt,imm);
	}
	if(strcmp(opcode, "fadd") == 0){
		if(sscanf(op_data, ffff, tmp, &rd, &rs, &rt) == 4)
		    return fadd(rs,rt,rd,0);
	}
	if(strcmp(opcode, "fsub") == 0){
		if(sscanf(op_data, ffff, tmp, &rd, &rs, &rt) == 4)
		    return fsub(rs,rt,rd,0);
	}
	if(strcmp(opcode, "fmul") == 0){
		if(sscanf(op_data, ffff, tmp, &rd, &rs, &rt) == 4)
		    return fmul(rs,rt,rd,0);
	}
	if(strcmp(opcode, "fdiv") == 0){
		if(sscanf(op_data, ffff, tmp, &rd, &rs, &rt) == 4)
		    return fdiv(rs,rt,rd,0);
	}
	if(strcmp(opcode, "fsqrt") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3)
		    return fsqrt(rs,0,rd,0);
	}
	if(strcmp(opcode, "fmov") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3)
		    return fmov(rs,0,rd,0);
	}
	if(strcmp(opcode, "fneg") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3)
		    return fneg(rs,0,rd,0);
	}
	if(strcmp(opcode, "fld") == 0){
		if(sscanf(op_data, ffgi, tmp, &rs, &rt, &imm) == 4)
		    return fld(rs,rt,imm);
	}
	if(strcmp(opcode, "fst") == 0){
		if(sscanf(op_data, ffgi, tmp, &rs, &rt, &imm) == 4)
		    return fst(rs,rt,imm);
	}
	if(strcmp(opcode, "fjeq") == 0){
		if(sscanf(op_data, fffl, tmp, &rs, &rt, lname) == 4) {
			strcpy(label_name[label_cnt],lname);
		    return fjeq(rs,rt,label_cnt++);
		}
	}
	if(strcmp(opcode, "fjlt") == 0){
		if(sscanf(op_data, fffl, tmp, &rs, &rt, lname) == 4) {
			strcpy(label_name[label_cnt],lname);
		    return fjlt(rs,rt,label_cnt++);
		}
	}
	if(strcmp(opcode, "nop") == 0){
		    return nop(0,0,0,0);
	}
	if(strcmp(opcode, "halt") == 0){
		    return halt(0,0,0,0);
	}
	if(strcmp(opcode, "setL") == 0){
		if(sscanf(op_data, fgl, tmp, &rd, lname) == 3) {
			strcpy(label_name[label_cnt],lname);
		    return setl(0,rd,label_cnt++);
		}
	}
	/*
	if(strcmp(opcode, "sqrt") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3)
		    return _sin(rs,0,rd,0,0);
	}
	*/
	if(strcmp(opcode, "sin") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3)
		    return _sin(rs,0,rd,0,0);
	}
	if(strcmp(opcode, "cos") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3)
		    return _cos(rs,0,rd,0,0);
	}
	if(strcmp(opcode, "atan") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3)
		    return _atan(rs,0,rd,0,0);
	}
	if(strcmp(opcode, "int_of_float") == 0){
		if(sscanf(op_data, fgf, tmp, &rd, &rs) == 3)
		    return _int_of_float(rs,0,rd,0,0);
	}
	if(strcmp(opcode, "float_of_int") == 0){
		if(sscanf(op_data, ffg, tmp, &rd, &rs) == 3)
		    return _float_of_int(rs,0,rd,0,0);
	}

	return -1;
}

DEFINE_I(mvhi, MVHI);
DEFINE_I(mvlo, MVLO);
DEFINE_I(addi,ADDI);
DEFINE_I(subi,SUBI);
DEFINE_I(muli,MULI);
DEFINE_I(divi,DIVI);
DEFINE_I(slli,SLLI);
DEFINE_J(jmp,JMP);
DEFINE_I(jeq,JEQ);
DEFINE_I(jne,JNE);
DEFINE_I(jlt,JLT);
DEFINE_I(jle,JLE);
DEFINE_J(call,CALL);
DEFINE_J(_return,RETURN);
DEFINE_I(ld,LD);
DEFINE_I(st,ST);
DEFINE_I(fld,FLD);
DEFINE_I(fst,FST);
DEFINE_I(fjeq,FJEQ);
DEFINE_I(fjlt,FJLT);
DEFINE_I(setl,SETL);

DEFINE_F(mov,SPECIAL,MOV_F);
DEFINE_F(_not,SPECIAL,NOT_F);
DEFINE_F(input,IO,INPUT_F);
DEFINE_F(output,IO,OUTPUT_F);
DEFINE_F(nop,SPECIAL,NOP_F);
DEFINE_F(sll,SPECIAL,SLL_F);
DEFINE_F(srl,SPECIAL,SRL_F);
DEFINE_F(b,SPECIAL,B_F);
DEFINE_F(add,SPECIAL,ADD_F);
DEFINE_F(sub,SPECIAL,SUB_F);
DEFINE_F(mul,SPECIAL,MUL_F);
DEFINE_F(_div,SPECIAL,DIV_F);
DEFINE_F(_and,SPECIAL,AND_F);
DEFINE_F(_or,SPECIAL,OR_F);
DEFINE_F(halt,SPECIAL,HALT_F);
DEFINE_F(callr,SPECIAL,CALLR_F);

DEFINE_F(fadd,FPI,FADD_F);
DEFINE_F(fsub,FPI,FSUB_F);
DEFINE_F(fmul,FPI,FMUL_F);
DEFINE_F(fdiv,FPI,FDIV_F);
DEFINE_F(fsqrt,FPI,FSQRT_F);
DEFINE_F(fmov,FPI,FMOV_F);
DEFINE_F(fneg,FPI,FNEG_F);

///////////////////////////////
DEFINE_R(_sin,SIN);
DEFINE_R(_cos,COS);
DEFINE_R(_atan,ATAN);
DEFINE_R(_sqrt,SQRT);
DEFINE_R(_int_of_float,I_OF_F);
DEFINE_R(_float_of_int,F_OF_I);
//////////////////////////////
