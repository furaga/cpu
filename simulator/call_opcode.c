#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include "asm.h"
extern char label_name[LABEL_MAX][256];
extern uint32_t label_cnt;

uint32_t call_opcode(char *opcode, char *op_data)
{
	int rd,rs,rt,imm,funct,shaft,target;
	char tmp[256];
	// format
	// g: general register
	// i: immediate
	// l: label
	const char *fg = "%s %%g%d";
	const char *fl = "%s %s";
	const char *fgi = "%s %%g%d, %d";
	const char *fgl = "%s %%g%d, %s";
	const char *fgg = "%s %%g%d, %%g%d";
	const char *fggl = "%s %%g%d, %%g%d, %s";
	const char *fggi = "%s %%g%d, %%g%d, %d";
	const char *fggg = "%s %%g%d, %%g%d, %%g%d";
	const char *fff = "%s %%f%d, %%f%d";
	const char *fffl = "%s %%f%d, %%f%d, %s";
	const char *ffff = "%s %%f%d, %%f%d, %%f%d";
	const char *ffgi = "%s %%f%d, %%g%d, %d";
	char lname[256];

	shaft = funct = target = 0;


	if(strcmp(opcode, "mov") == 0){
		if(sscanf(op_data, fgg, tmp, &rd, &rs) == 3)
		    return mov(rs,0,rd,0,0);
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
		    return add(rs,rt,rd,0,0);
	}
	if(strcmp(opcode, "sub") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return sub(rs,rt,rd,0,0);
	}
	if(strcmp(opcode, "mul") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return mul(rs,rt,rd,0,0);
	}
	if(strcmp(opcode, "div") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return div(rs,rt,rd,0,0);
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
		    return input(0,0,rd,0,0);
	}
	if(strcmp(opcode, "output") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2)
		    return output(rs,0,0,0,0);
	}
	if(strcmp(opcode, "and") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return _and(rs,rt,rd,0,0);
	}
	if(strcmp(opcode, "or") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return _or(rs,rt,rd,0,0);
	}
	if(strcmp(opcode, "not") == 0){
		if(sscanf(op_data, fgg, tmp, &rd, &rs) == 3)
		    return _not(rs,0,rd,0,0);
	}
	if(strcmp(opcode, "sll") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return sll(rs,rt,rd,0,0);
	}
	if(strcmp(opcode, "srl") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return srl(rs,rt,rd,0,0);
	}
	if(strcmp(opcode, "slli") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4)
		    return slli(rs,rt,imm);
	}
	if(strcmp(opcode, "b") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2)
		    return b(rs,0,0,0,0);
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
	if(strcmp(opcode, "call") == 0){
		if(sscanf(op_data, fl, tmp, lname) == 2)  {
			strcpy(label_name[label_cnt],lname);
		    return call(label_cnt++);
		}
	}
	if(strcmp(opcode, "callR") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2)
		    return callr(rs,0,0,0,0);
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
		    return fadd(rs,rt,rd,0,0);
	}
	if(strcmp(opcode, "fsub") == 0){
		if(sscanf(op_data, ffff, tmp, &rd, &rs, &rt) == 4)
		    return fsub(rs,rt,rd,0,0);
	}
	if(strcmp(opcode, "fmul") == 0){
		if(sscanf(op_data, ffff, tmp, &rd, &rs, &rt) == 4)
		    return fmul(rs,rt,rd,0,0);
	}
	if(strcmp(opcode, "fdiv") == 0){
		if(sscanf(op_data, ffff, tmp, &rd, &rs, &rt) == 4)
		    return fdiv(rs,rt,rd,0,0);
	}
	if(strcmp(opcode, "fmov") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3)
		    return fmov(rs,0,rd,0,0);
	}
	if(strcmp(opcode, "fneg") == 0){
		if(sscanf(op_data, fff, tmp, &rd, &rs) == 3)
		    return fneg(rs,0,rd,0,0);
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
		    return nop(0,0,0,0,0);
	}
	if(strcmp(opcode, "halt") == 0){
		    return halt(0,0,0,0,0);
	}
	if(strcmp(opcode, "setL") == 0){
		if(sscanf(op_data, fgl, tmp, &rd, lname) == 3) {
			strcpy(label_name[label_cnt],lname);
		    return setl(0,rd,label_cnt++);
		}
	}

	return -1;
}



#define DEFINE_R(name, opcode) \
	uint32_t name(uint8_t rs, uint8_t rt, uint8_t rd, uint8_t shaft, uint8_t funct) {\
		return (opcode << 26 | ((uint32_t)rs << 21) | ((uint32_t) rt << 16)\
				| ((uint32_t) rd << 11) | ((uint32_t) shaft << 6) |funct);\
	}
#define DEFINE_I(name, opcode) \
	uint32_t name(uint8_t rs, uint8_t rt, uint16_t imm) {\
		return (opcode << 26 | ((uint32_t)rs << 21) | ((uint32_t) rt << 16) | imm);\
	}
#define DEFINE_J(name, opcode) \
	uint32_t name(uint32_t target) {\
		return (opcode << 26 | target);\
	}

DEFINE_R(mov,MOV);
DEFINE_I(mvhi, MVHI);
DEFINE_I(mvlo, MVLO);
DEFINE_R(add,ADD);
DEFINE_R(sub,SUB);
DEFINE_R(mul,MUL);
DEFINE_R(div,DIV);
DEFINE_I(addi,ADDI);
DEFINE_I(subi,SUBI);
DEFINE_I(muli,MULI);
DEFINE_I(divi,DIVI);
DEFINE_R(input,INPUT);
DEFINE_R(output,OUTPUT);
DEFINE_R(_and,AND);
DEFINE_R(_or,OR);
DEFINE_R(_not,NOT);
DEFINE_R(sll,SLL);
DEFINE_R(srl,SRL);
DEFINE_I(slli,SLLI);
DEFINE_R(b,B);
DEFINE_J(jmp,JMP);
DEFINE_I(jeq,JEQ);
DEFINE_I(jne,JNE);
DEFINE_I(jlt,JLT);
DEFINE_J(call,CALL);
DEFINE_R(callr,CALLR);
DEFINE_J(_return,RETURN);
DEFINE_I(ld,LD);
DEFINE_I(st,ST);
DEFINE_R(fadd,FADD);
DEFINE_R(fsub,FSUB);
DEFINE_R(fmul,FMUL);
DEFINE_R(fdiv,FDIV);
DEFINE_R(fmov,FMOV);
DEFINE_R(fneg,FNEG);
DEFINE_I(fld,FLD);
DEFINE_I(fst,FST);
DEFINE_I(fjeq,FJEQ);
DEFINE_I(fjlt,FJLT);
DEFINE_R(nop,NOP);
DEFINE_R(halt,HALT);
DEFINE_I(setl,SETL);
///////////////////////////////
