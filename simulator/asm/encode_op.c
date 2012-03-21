#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include "asm.h"
extern char label_name[LABEL_MAX][256];
extern uint32_t label_cnt;

int encode_op(char *opcode, char *op_data)
{
	int rd,rs,rt,imm,funct,shaft,target;
	char tmp[256];
	const char *fi = "%s %d";
	const char *fg = "%s %%g%d";
	const char *ff = "%s %%f%d";
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
	const char *ffgg = "%s %%f%d, %%g%d, %%g%d";
	char lname[256];

	shaft = funct = target = 0;

	if(strcmp(opcode, "mvhi") == 0){
		if(sscanf(op_data, fgi, tmp, &rs, &imm) == 3)
		    return mvhi(rs,0,imm);
	}
	if(strcmp(opcode, "mvlo") == 0){
		if(sscanf(op_data, fgi, tmp, &rs, &imm) == 3)
		    return mvlo(rs,0,imm);
	}
	if(strcmp(opcode, "add") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return add(rs,rt,rd,0);
	}
	if(strcmp(opcode, "nor") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return nor(rs,rt,rd,0);
	}
	if(strcmp(opcode, "sub") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return sub(rs,rt,rd,0);
	}
	if(strcmp(opcode, "mul") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return mul(rs,rt,rd,0);
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
	if(strcmp(opcode, "input") == 0){
		if(sscanf(op_data, fg, tmp, &rd) == 2)
		    return input(0,0,rd,0);
	}
	if(strcmp(opcode, "inputw") == 0){
		if(sscanf(op_data, fg, tmp, &rd) == 2)
		    return inputw(0,0,rd,0);
	}
	if(strcmp(opcode, "inputf") == 0){
		if(sscanf(op_data, ff, tmp, &rd) == 2)
		    return inputf(0,0,rd,0);
	}
	if(strcmp(opcode, "output") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2)
		    return output(rs,0,0,0);
	}
	if(strcmp(opcode, "outputw") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2)
		    return outputw(rs,0,0,0);
	}
	if(strcmp(opcode, "outputf") == 0){
		if(sscanf(op_data, ff, tmp, &rs) == 2)
		    return outputf(rs,0,0,0);
	}
	if(strcmp(opcode, "and") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return _and(rs,rt,rd,0);
	}
	if(strcmp(opcode, "or") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return _or(rs,rt,rd,0);
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
	if(strcmp(opcode, "srli") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4)
		    return srli(rs,rt,imm);
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
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return ld(rs,rt,rd,0);
	}
	if(strcmp(opcode, "ldi") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4)
		    return ldi(rs,rt,imm);
	}
	if(strcmp(opcode, "ldlr") == 0){
		if(sscanf(op_data, fgi, tmp, &rs, &imm) == 3)
		    return ldlr(rs,0,imm);
	}
	if(strcmp(opcode, "fld") == 0){
		if(sscanf(op_data, ffgg, tmp, &rd, &rs,&rt) == 4)
		    return fld(rs,rt,rd,0);
	}
	if(strcmp(opcode, "st") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return st(rs,rt,rd,0);
	}
	if(strcmp(opcode, "sti") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4)
		    return sti(rs,rt,imm);
	}
	if(strcmp(opcode, "stlr") == 0){
		if(sscanf(op_data, fgi, tmp, &rs, &imm) == 3)
		    return stlr(rs,0,imm);
	}
	if(strcmp(opcode, "fst") == 0){
		if(sscanf(op_data, ffgg, tmp, &rd, &rs,&rt) == 4)
		    return fst(rs,rt,rd,0);
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
	if(strcmp(opcode, "fabs") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3)
		    return _fabs(rs,0,rd,0);
	}
	if(strcmp(opcode, "fmov") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3)
		    return fmov(rs,0,rd,0);
	}
	if(strcmp(opcode, "fneg") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3)
		    return fneg(rs,0,rd,0);
	}
	if(strcmp(opcode, "fldi") == 0){
		if(sscanf(op_data, ffgi, tmp, &rt, &rs, &imm) == 4)
		    return fldi(rs,rt,imm);
	}
	if(strcmp(opcode, "fsti") == 0){
		if(sscanf(op_data, ffgi, tmp, &rt, &rs, &imm) == 4)
		    return fsti(rs,rt,imm);
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
	if(strcmp(opcode, "halt") == 0){
		    return halt(0,0,0,0);
	}
	if(strcmp(opcode, "setL") == 0){
		if(sscanf(op_data, fgl, tmp, &rd, lname) == 3) {
			strcpy(label_name[label_cnt],lname);
		    return setl(0,rd,label_cnt++);
		}
	}
	if(strcmp(opcode, "padd") == 0){
		if(sscanf(op_data, fgi, tmp, &rt, &imm) == 3) {
		    return padd(0,rt,imm);
		}
	}
	if(strcmp(opcode, "link") == 0){
		if(sscanf(op_data, fi, tmp, &imm) == 2) {
		    return link(0,0,imm);
		}
	}
	if(strcmp(opcode, "movlr") == 0){
		return movlr(0,0,0,0);
	}
	if(strcmp(opcode, "btmplr") == 0){
		return btmplr(0,0,0,0);
	}
	/*
	if(strcmp(opcode, "padd") == 0){
		if(sscanf(op_data, fgg, tmp, &rd, &rt) == 3) {
		    return padd(0,rt,d,0);
		}
	}
	*/

	return -1;
}

DEFINE_I(mvhi, MVHI);
DEFINE_I(mvlo, MVLO);
DEFINE_I(addi,ADDI);
DEFINE_I(subi,SUBI);
DEFINE_I(muli,MULI);
DEFINE_I(slli,SLLI);
DEFINE_I(srli,SRLI);
DEFINE_J(jmp,JMP);
DEFINE_I(jeq,JEQ);
DEFINE_I(jne,JNE);
DEFINE_I(jlt,JLT);
DEFINE_I(jle,JLE);
DEFINE_J(call,CALL);
DEFINE_J(_return,RETURN);
DEFINE_I(ldi,LDI);
DEFINE_I(sti,STI);
DEFINE_I(ldlr,LDLR);
DEFINE_I(stlr,STLR);
DEFINE_I(fldi,FLDI);
DEFINE_I(fsti,FSTI);
DEFINE_I(fjeq,FJEQ);
DEFINE_I(fjlt,FJLT);
DEFINE_I(setl,SETL);
DEFINE_I(padd,PADD);

DEFINE_F(input,IO,INPUT_F);
DEFINE_F(inputw,IO,INPUTW_F);
DEFINE_F(inputf,IO,INPUTF_F);
DEFINE_F(output,IO,OUTPUT_F);
DEFINE_F(outputw,IO,OUTPUTW_F);
DEFINE_F(outputf,IO,OUTPUTF_F);

DEFINE_F(sll,SPECIAL,SLL_F);
DEFINE_F(srl,SPECIAL,SRL_F);
DEFINE_F(b,SPECIAL,B_F);
DEFINE_F(btmplr,SPECIAL,BTMPLR_F);
DEFINE_F(nor,SPECIAL,NOR_F);
DEFINE_F(add,SPECIAL,ADD_F);
DEFINE_F(sub,SPECIAL,SUB_F);
DEFINE_F(ld,LD,0);
DEFINE_F(st,ST,0);
DEFINE_F(fld,SPECIAL,FLD_F);
DEFINE_F(fst,SPECIAL,FST_F);
DEFINE_F(movlr,SPECIAL,MOVLR_F);
DEFINE_F(mul,SPECIAL,MUL_F);
DEFINE_F(_and,SPECIAL,AND_F);
DEFINE_F(_or,SPECIAL,OR_F);
DEFINE_F(halt,SPECIAL,HALT_F);
DEFINE_F(callr,SPECIAL,CALLR_F);
DEFINE_I(link,LINK);

DEFINE_F(fadd,FPI,FADD_F);
DEFINE_F(fsub,FPI,FSUB_F);
DEFINE_F(fmul,FPI,FMUL_F);
DEFINE_F(fdiv,FPI,FDIV_F);
DEFINE_F(fsqrt,FPI,FSQRT_F);
DEFINE_F(_fabs,FPI,FABS_F);
DEFINE_F(fmov,FPI,FMOV_F);
DEFINE_F(fneg,FPI,FNEG_F);

