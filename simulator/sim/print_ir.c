#include <stdio.h>
#include <string.h>
#include "sim.h"

// print instruction register ////////////////////
void print_ir(uint32_t ir, FILE *fp) {
	static const char *f = "%s\n";
	static const char *fi = "%s\t8\n";
	static const char *fg = "%s\tg%d=%d\n";
	static const char *fl = "%s\t%x\n";
	static const char *fgi = "%s\tg%d=%d %d\n";
	static const char *fgg = "%s\tg%d=%d g%d=%d\n";
	static const char *fggg = "%s\tg%d=%d g%d=%d g%d=%d\n";
	static const char *fggi = "%s\tg%d=%d g%d=%d %d\n";
	static const char *fggl = "%s\tg%d=%d g%d=%d %x\n";
	static const char *fff = "%s\tf%d=%f f%d=%f\n";
	static const char *fffl = "%s\tf%d=%f f%d=%f %x\n";
	static const char *ffff = "%s\tf%d=%f f%d=%f f%d=%f\n";
	static const char *ffgi = "%s\tf%d=%f g%d=%f %d\n";
	uint32_t opcode,funct;
	const char *name,*type,*f_type,*f_name;
	
	fprintf(fp, "%6llu.[%4x] ", cnt, pc);

	opcode = get_opcode(ir);
	funct = get_funct(ir);
	name = InstMap[opcode];
	type = InstTyMap[opcode];
	switch (opcode) {
		case 0 :
			f_type = SFunctTyMap[funct];
			f_name = SFunctMap[funct];
			break;
		case 1 :
			f_type = IOFunctTyMap[funct];
			f_name = IOFunctMap[funct];
			break;
		case 17:
			f_type = FFunctTyMap[funct];
			f_name = FFunctMap[funct];
			break;
		default: break;
	}

	if (opcode == 0) {
		if (strcmp(f_type, "fggg") == 0) {
			// add,sub,mul,div,and,or, sll, srl
			fprintf(fp, fggg, f_name, get_rdi(ir), _GRD, get_rsi(ir), _GRS, get_rti(ir), _GRT);
		}else 
		if (strcmp(f_type, "fgg") == 0) {
			// padd
			fprintf(fp, fgg, f_name, get_rdi(ir), _GRD, get_rti(ir), _GRT);
		} else 
		if (strcmp(f_type, "fg") == 0) {
			// b, callR 
			fprintf(fp, fg, f_name, get_rsi(ir), _GRS);
		} else 
		if (strcmp(f_type, "f") == 0) {
			// halt
			fprintf(fp, f, f_name);
		} else {
			fprintf(fp, "Undefined SPECIAL ir\n");
		}
	} else 
	if (opcode == 1) {
		if (strcmp(f_type, "fg") == 0) {
			fprintf(fp, fg, f_name, get_rdi(ir), _GRD);
		} else{
			fprintf(fp, "Undefined I/O ir\n");
		}
	} else
	if (opcode == 17) {
		if (strcmp(f_type, "fff") == 0) {
			// fmov fneg fsqrt
			fprintf(fp, fff, f_name, get_rdi(ir), _FRD, get_rsi(ir), _FRS);
		}else 
		if (strcmp(f_type, "ffff") == 0) {
			// fadd fsub fmul fdiv
			fprintf(fp, ffff, f_name, get_rdi(ir), _FRD, get_rsi(ir), _FRS, get_rti(ir), _FRT);
		} else {
			fprintf(fp, "Undefined FPI IR\n");
		}
	} else 
	if (strcmp(type, "f") == 0) {
		// nop, halt, return 3
		fprintf(fp, f, name);
	} else 
	if (strcmp(type, "fi") == 0) {
		fprintf(fp, fi, name);
	} else 
	if (strcmp(type, "fg") == 0) {
		// input, output, b, callR 4
		if (strcmp(name, "input") == 0) {
			fprintf(fp, fg, name, get_rdi(ir), _GRD);
		} else {
			fprintf(fp, fg, name, get_rsi(ir), _GRS);
		}
	} else 
	if (strcmp(type, "fl") == 0) {
		// jump, call 2
		fprintf(fp, fl, name, get_target(ir));
	} else
	if (strcmp(type, "fgi") == 0) {
		// mvhi, mvlo
		fprintf(fp, fgi, name, get_rsi(ir), _GRS, _IMM);
	}else 
	if (strcmp(type, "fgg") == 0) {
		// mov, not
		fprintf(fp, fgg, name, get_rdi(ir), _GRD, get_rsi(ir), _GRS);
	}else 
	if (strcmp(type, "fggg") == 0) {
		// add,sub,mul,div,and,or, sll, srl
		fprintf(fp, fggg, name, get_rdi(ir), _GRD, get_rsi(ir), _GRS, get_rti(ir), _GRT);
	}else 
	if (strcmp(type, "fggi") == 0) {
		
		// addi,subi,muli,divi,slli,st,ld
		if ((strcmp(name, "ldi") == 0) ||
			(strcmp(name, "sti") == 0)) {
			fprintf(fp, fggi, name, get_rsi(ir), _GRS, get_rti(ir), _GRT, _IMM);
		} else {
			fprintf(fp, fggi, name, get_rsi(ir), _GRS, get_rti(ir), _GRT, _IMM);
		}
	}else 
	if (strcmp(type, "fggl") == 0) {
		// jeq, jne, jlt, jle
		fprintf(fp, fggl, name, get_rsi(ir), _GRS, get_rti(ir), _GRT, _IMM);
	}else 
	if (strcmp(type, "fff") == 0) {
		// fmov fneg fsqrt
		fprintf(fp, fff, name, get_rdi(ir), _FRD, get_rsi(ir), _FRS);
	}else 
	if (strcmp(type, "fffl") == 0) {
		// fjeq, fjlt
		fprintf(fp, fffl, name, get_rsi(ir), _FRS, get_rti(ir), _FRT, _IMM);
	}else 
	if (strcmp(type, "ffff") == 0) {
		// fadd fsub fmul fdiv
		fprintf(fp, ffff, name, get_rdi(ir), _FRD, get_rsi(ir), _FRS, get_rti(ir), _FRT);
	}else 
	if (strcmp(type, "ffgi") == 0) {
		// fld fst
		fprintf(fp, ffgi, name, get_rsi(ir), _FRS, get_rdi(ir), _GRT, _IMM);
	}else{
		fprintf(fp, "Undefined ir\n");
	}
	fflush(fp);
}
