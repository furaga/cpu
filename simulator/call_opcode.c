#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include "setup.h"
extern char label_name[128][256];
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
	const char *fgg = "%s %%g%d, %%g%d";
	const char *fggl = "%s %%g%d, %%g%d, %s";
	const char *fggi = "%s %%g%d, %%g%d, %d";
	const char *fggg = "%s %%g%d, %%g%d, %%g%d";
	char lname[256];

	shaft = funct = target = 0;

	if(strcmp(opcode, "mov") == 0){
		if(sscanf(op_data, fgg, tmp, &rd, &rs) == 3)
		    return mov(rs,0,rd,0,0);
	} else
	if(strcmp(opcode, "mvhi") == 0){
		if(sscanf(op_data, fgi, tmp, &rt, &imm) == 3)
		    return mvhi(0,rt,imm);
	} else
	if(strcmp(opcode, "mvlo") == 0){
		if(sscanf(op_data, fgi, tmp, &rt, &imm) == 3)
		    return mvlo(0,rt,imm);
	} else
	if(strcmp(opcode, "jmp") == 0){
		if(sscanf(op_data, fl, tmp, lname) == 2)
			strcpy(label_name[label_cnt],lname);
		    return jmp(label_cnt++);
	} else
	if(strcmp(opcode, "jeq") == 0){
		if(sscanf(op_data, fggl, tmp, &rs, &rt, lname) == 4)
			strcpy(label_name[label_cnt],lname);
		    return jeq(rs,rt,label_cnt++);
	} else
	if(strcmp(opcode, "jne") == 0){
		if(sscanf(op_data, fggl, tmp, &rs, &rt, lname) == 4)
			strcpy(label_name[label_cnt],lname);
		    return jne(rs,rt,label_cnt++);
	} else
	if(strcmp(opcode, "jlt") == 0){
		if(sscanf(op_data, fggl, tmp, &rs, &rt, lname) == 4)
			strcpy(label_name[label_cnt],lname);
		    return jlt(rs,rt,label_cnt++);
	} else
	if(strcmp(opcode, "call") == 0){
		if(sscanf(op_data, fl, tmp, lname) == 2) 
			strcpy(label_name[label_cnt],lname);
		    return call(label_cnt++);
	} else
	if(strcmp(opcode, "return") == 0){
		    return _return(0);
	} else
	if(strcmp(opcode, "add") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return add(rs,rt,rd,shaft,funct);
	} else
	if(strcmp(opcode, "sub") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return sub(rs,rt,rd,shaft,funct);
	} else
	if(strcmp(opcode, "mul") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return mul(rs,rt,rd,shaft,funct);
	} else
	if(strcmp(opcode, "div") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return div(rs,rt,rd,shaft,funct);
	} else
	if(strcmp(opcode, "and") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return _and(rs,rt,rd,0,0);
	} else
	if(strcmp(opcode, "or") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return _or(rs,rt,rd,0,0);
	} else
	if(strcmp(opcode, "not") == 0){
		if(sscanf(op_data, fgg, tmp, &rd, &rs) == 3)
		    return _not(rs,0,rd,0,0);
	} else
	if(strcmp(opcode, "sll") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return sll(rs,rt,rd,0,0);
	} else
	if(strcmp(opcode, "srl") == 0){
		if(sscanf(op_data, fggg, tmp, &rd, &rs,&rt) == 4)
		    return srl(rs,rt,rd,0,0);
	} else
	if(strcmp(opcode, "slli") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4)
		    return slli(rs,rt,imm);
	} else
	if(strcmp(opcode, "addi") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4)
		    return addi(rs,rt,imm);
	} else
	if(strcmp(opcode, "subi") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4)
		    return subi(rs,rt,imm);
	} else
	if(strcmp(opcode, "muli") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4)
		    return muli(rs,rt,imm);
	} else
	if(strcmp(opcode, "divi") == 0){
		if(sscanf(op_data, fggi, tmp, &rt, &rs, &imm) == 4)
		    return divi(rs,rt,imm);
	} else
	if(strcmp(opcode, "st") == 0){
		if(sscanf(op_data, fggi, tmp, &rs, &rt, &imm) == 4)
		    return st(rs,rt,imm);
	} else
	if(strcmp(opcode, "ld") == 0){
		if(sscanf(op_data, fggi, tmp, &rs, &rt, &imm) == 4)
		    return ld(rs,rt,imm);
	} else
	if(strcmp(opcode, "halt") == 0){
		    return halt(0,0,0,0,0);
	} else
	if(strcmp(opcode, "nop") == 0){
		    return nop(0,0,0,0,0);
	} else
	if(strcmp(opcode, "output") == 0){
		if(sscanf(op_data, fg, tmp, &rs) == 2)
		    return output(rs,0,0,0,0);
	} else
	if(strcmp(opcode, "input") == 0){
		if(sscanf(op_data, fg, tmp, &rd) == 2)
		    return input(0,0,rd,0,0);
	} else
	{}

	return -1;
}


