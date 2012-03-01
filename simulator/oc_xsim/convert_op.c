#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include "oc_geso.h"

static char *gr_label(int,int,int);
static char *fr_label(int);
#define grl(idx) gr_label(idx, 0, 0)
#define grlq(idx) gr_label(idx, 0, 1)
#define grldst(idx) gr_label(idx, 1, 0)
#define frl(idx) fr_label(idx)


#define print_line(inst, fmt, ...) \
	myprint("\t"#inst"\t\t"fmt"\n", ##__VA_ARGS__)
#define myscan(fmt, ...) \
	(sscanf(asm_line, asm_fmt_##fmt, tmp, ##__VA_ARGS__) - 1)
#define COMMA ", "
#define GR "%s"
#define GRc "%s"COMMA
#define FR "%s"
#define FRc "%s"COMMA
#define IMM "$%d"
#define IMMc "$%d"COMMA
#define FTMP "%%xmm15"
#define FTMPc "%%xmm15"COMMA
#define TMP "%%eax"
#define TMPc "%%eax"COMMA
#define TMP1 "%%edx"
#define TMP1c "%%edx"COMMA
#define LABEL "%s"
#define LABELc "%s"COMMA
#define ADDR(x) "-%d("x")"
#define ADDRc(x) "-%d("x")"COMMA
static inline int _inst_is(char *inst, const char *str) {
	return strcmp(inst, str) == 0;
}
#define inst_is(str) _inst_is(term0, str)
int convert_op(char *asm_line, char *term0)
{
	static int rd,rs,rt,imm;
	static char tmp[256];
	static char lname[256];

	if (inst_is("mov")) {
		if (myscan(igg, &rd, &rs) == 2) {
	 		if (is_xreg(rs) || is_xreg(rd)) {
				print_line(movl, GRc GR, grl(rs), grldst(rd));
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(movl, TMPc GR, grldst(rd));
			}

		    return 0;
		}
	}
	if (inst_is("mvhi")) {
		if (myscan(igi, &rs, &imm) == 2) {
			print_line(andl, IMMc GR, 0xffff, grldst(rs));
			print_line(orl, IMMc GR, ((imm&0xffff)<<16), grldst(rs));
		    return 0;
		}
	}
	if(inst_is("mvlo")) {
		if(myscan(igi, &rs, &imm) == 2) {
			print_line(andl, IMMc GR, 0xffff0000, grldst(rs));
			print_line(orl, IMMc GR, (imm&0xffff), grldst(rs));
		    return 0;
		}
	}
	if(inst_is("add")) {
		if (myscan(iggg, &rd, &rs, &rt) == 3) {
	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				print_line(addl, GRc GR, grl(rt), grldst(rs));
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(addl, GRc TMP, grl(rt));
				print_line(movl, TMPc GR, grldst(rd));
			}

		    return 0;
		}
	}
	if(inst_is("sub")) {
		if (myscan(iggg, &rd, &rs, &rt) == 3) {
	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				print_line(subl, GRc GR, grl(rt), grldst(rs));
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(subl, GRc TMP, grl(rt));
				print_line(movl, TMPc GR, grldst(rd));
			}

		    return 0;
		}
	}
	if(inst_is("mul")) {
		if (myscan(iggg, &rd, &rs, &rt) == 3) {
	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				print_line(imull, GRc GR, grl(rt), grldst(rs));
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(imull, GRc TMP, grl(rt));
				print_line(movl, TMPc GR, grldst(rd));
			}

		    return 0;
		}
	}

	if(inst_is("addi")) {
		if (myscan(iggi, &rt, &rs, &imm) == 3) {
			if (rs == 0) {
				print_line(movl, IMMc GR, imm, grldst(rt));
	 		} else if ((rt == rs) && (is_xreg(rs) || is_xreg(rt))) {
				print_line(addl, IMMc GR, imm, grldst(rt));
			} else if (is_xreg(rs) || is_xreg(rt)) {
				print_line(movl, GRc GR, grl(rs), grldst(rt));
				print_line(addl, IMMc GR, imm, grldst(rt));
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(addl, IMMc TMP, imm);
				print_line(movl, TMPc GR, grldst(rt));
			}

		    return 0;
		}
	}
	if(inst_is("subi")) {
		if (myscan(iggi, &rt, &rs, &imm) == 3) {

	 		if ((rt == rs) && (is_xreg(rs) || is_xreg(rt))) {
				print_line(subl, IMMc GR, imm, grldst(rt));
			} else if (is_xreg(rs) || is_xreg(rt)) {
				print_line(movl, GRc GR, grl(rs), grldst(rt));
				print_line(subl, IMMc GR, imm, grldst(rt));
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(subl, IMMc TMP, imm);
				print_line(movl, TMPc GR, grldst(rt));
			}

		    return 0;
		}
	}
	if(inst_is("muli")) {
		if (myscan(iggi, &rt, &rs, &imm) == 3) {
	 		if ((rt == rs) && (is_xreg(rs) || is_xreg(rt))) {
				print_line(imull, IMMc GR, imm, grldst(rt));
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(imull, IMMc TMP, imm);
				print_line(movl, TMPc GR, grldst(rt));
			}
		    return 0;
		}
	}
	if (inst_is("input")) {
		if (myscan(ig, &rd) == 1) {
			print_line(xorl, TMPc TMP);
			print_line(call, LABEL, "InChar");
			print_line(movl, TMPc GR, grldst(rd));

		    return 0;
		}
	}
	if (inst_is("output")) {
		if (myscan(ig, &rs) == 1) {
			print_line(movl, GRc LABEL, grl(rs), "%eax");
			print_line(call, LABEL, "OutChar");
			return 0;
		}
	}
	if (inst_is("outputH")) {
		if (myscan(ig, &rs) == 1) {
			print_line(movl, GRc LABEL, grl(rs), "%eax");
			print_line(call, LABEL, "PrintHex8");
		    return 0;
		}
	}

	if (inst_is("outputF")) {
		if (myscan(if, &rs) == 1) {
			print_line(movl, FRc LABEL, frl(rs), "%eax");
			print_line(call, LABEL, "PrintHex8");
		    return 0;
		}
	}

	if (inst_is("and")) {
		if (myscan(iggg, &rd, &rs, &rt) == 3) {
	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				print_line(andl, GRc GR, grl(rt), grldst(rs));
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(andl, GRc TMP, grl(rt));
				print_line(movl, TMPc GR, grldst(rd));
			}

		    return 0;
		}
	}

	if (inst_is("or")) {
		if (myscan(iggg, &rd, &rs, &rt) == 3) {
	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				print_line(orl, GRc GR, grl(rt), grldst(rs));
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(orl, GRc TMP, grl(rt));
				print_line(movl, TMPc GR, grldst(rd));
			}

		    return 0;
		}
	}
	if (inst_is("not")) {
		if (myscan(igg, &rd, &rs) == 2) {

			if (rd == rs) {
				print_line(notl, GR, grl(rd));
	 		} else if (is_xreg(rs) || is_xreg(rd)) {
				print_line(movl, GRc GR, grl(rs), grldst(rd));
				print_line(notl, GR, grl(rd));
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(notl, TMP);
				print_line(movl, TMPc GR, grldst(rd));
			}

		    return 0;
		}
	}
	if(inst_is("sll")) {
		if (myscan(iggg, &rd, &rs, &rt) == 3) {
	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				print_line(shll, GRc GR, grl(rt), grldst(rs));
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(shll, GRc TMP, grl(rt));
				print_line(movl, TMPc GR, grldst(rd));
			}

		    return 0;
		}
	}
	if(inst_is("srl")) {
		if (myscan(iggg, &rd, &rs, &rt) == 3) {
	 		if ((rd == rs) && (is_xreg(rs) || is_xreg(rt))) {
				print_line(shrl, GRc GR, grl(rt), grldst(rs));
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(shrl, GRc TMP, grl(rt));
				print_line(movl, TMPc GR, grldst(rd));
			}

		    return 0;
		}
	}

	if(inst_is("slli")) {
		if (myscan(iggi, &rt, &rs, &imm) == 3) {

	 		if ((rt == rs) && (is_xreg(rs) || is_xreg(rt))) {
				print_line(shll, IMMc GR, imm, grldst(rt));
			} else if (is_xreg(rs) || is_xreg(rt)) {
				print_line(movl, GRc GR, grl(rs), grldst(rt));
				print_line(shll, IMMc GR, imm, grldst(rt));
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(shll, IMMc TMP, imm);
				print_line(movl, TMPc GR, grldst(rt));
			}

		    return 0;
		}
	}
	if(inst_is("srli")) {
		if (myscan(iggi, &rt, &rs, &imm) == 3) {

	 		if ((rt == rs) && (is_xreg(rs) || is_xreg(rt))) {
				print_line(shrl, IMMc GR, imm, grldst(rt));
			} else if (is_xreg(rs) || is_xreg(rt)) {
				print_line(movl, GRc GR, grl(rs), grldst(rt));
				print_line(shrl, IMMc GR, imm, grldst(rt));
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(shrl, IMMc TMP, imm);
				print_line(movl, TMPc GR, grldst(rt));
			}

		    return 0;
		}
	}
	if (inst_is("b")) {
		if (myscan(ig, &rs) == 1) {
			if (is_xreg(rs)) {
				print_line(jmp *, GR, grlq(rs));
			} else {
				print_line(movl, GRc LABEL, grl(rs), "%edx");
				print_line(jmp *, LABEL, "%rdx");
			}
		    return 0;
		}
	}
	if (inst_is("jmp")) {
		if (myscan(il, lname) == 1) {

			if (strcmp(lname, "min_caml_start") == 0) {
				return 0;
			} else {
				print_line(jmp, LABEL, lname);
				return 0;
			}
		}
	}
	if (inst_is("jeq")) {
		if (myscan(iggl, &rs, &rt, lname) == 3) {
			print_line(movl, GRc TMP, grl(rs));
			print_line(cmpl, GRc TMP, grl(rt));
			print_line(je, LABEL, lname);
		    return 0;
		}
	}
	if (inst_is("jne")) {
		if (myscan(iggl, &rs, &rt, lname) == 3) {
			if (is_xreg(rt) || is_xreg(rs)) {
				print_line(cmpl, GRc GR, grl(rt), grldst(rs));
				print_line(jne, LABEL, lname);
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(cmpl, GRc TMP, grl(rt));
				print_line(jne, LABEL, lname);
			}
		    return 0;
		}
	}
	if (inst_is("jlt")) {
		if (myscan(iggl, &rs, &rt, lname) == 3) {
			
			if (is_xreg(rt) || is_xreg(rs)) {
				if (is_const(rs)) {
					print_line(cmpl, GRc GR, grl(rs), grldst(rt));
					print_line(jg, LABEL, lname);
				} else {
					print_line(cmpl, GRc GR, grl(rt), grldst(rs));
					print_line(jl, LABEL, lname);
				}
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(cmpl, GRc TMP, grl(rt));
				print_line(jl, LABEL, lname);
			}
		    return 0;
		}
	}
	if (inst_is("jle")) {
		if (myscan(iggl, &rs, &rt, lname) == 3) {
			print_line(movl, GRc TMP, grl(rs));
			print_line(cmpl, GRc TMP, grl(rt));
			print_line(jle, LABEL, lname);
		    return 0;
		}
	}
	if (inst_is("call")) {
		if (myscan(il, lname) == 1) {
			print_line(call, LABEL, lname);
			return 0;
		}
	}

	if (inst_is("callR")) {
		if (myscan(ig, &rs) == 1) {
			if (is_xreg(rs)) {
				print_line(call *, GR, grlq(rs));
			} else {
				print_line(movl, GRc LABEL, grl(rs), "%edx");
				print_line(call *, LABEL, "%rdx");
			}
		    return 0;
		}
	}
	if (inst_is("return")) {
		print_line(ret, "");
		return 0;
	}

	if (inst_is("ldi")) {
		if (myscan(iggi, &rt, &rs, &imm) == 3) {

			if (is_xreg(rs) && is_xreg(rt)) {
				print_line(movl, ADDRc(GR) GR, imm, grl(rs), grldst(rt));
			} else if (is_xreg(rt)) {
				print_line(movl, GRc TMP, grl(rs));
				print_line(movl, ADDRc(TMP) GR, imm, grldst(rt));
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(movl, ADDRc(TMP) TMP1, imm);
				print_line(movl, TMP1c GR, grldst(rt));
			}

		    return 0;
		}
	}

	if (inst_is("ld")) {
		if (myscan(iggg, &rd, &rs, &rt)==3) {
			print_line(movl, GRc TMP1, grl(rs));
			print_line(movl, GRc TMP, grl(rt));
			print_line(movl, "0("TMPc TMP1c"1), " TMP);
			print_line(movl, TMPc GR, grldst(rd));

		    return 0;
		}
	}
	if (inst_is("st")) {
		if (myscan(iggg, &rd, &rs, &rt)==3) {
			print_line(push, LABEL, "%rbx");
			print_line(movl, GRc TMP1, grl(rs));
			print_line(movl, GRc TMP, grl(rt));
			print_line(movl, GRc LABEL, grl(rd), "%ebx");
			print_line(movl, LABELc "0("TMPc TMP1c"1)", "%ebx");
			print_line(pop, LABEL, "%rbx");
		    return 0;
		}
	}

	if (inst_is("sti")) {
		if (myscan(iggi, &rt, &rs, &imm)==3) {

			if (is_xreg(rs) && is_xreg(rt)) {
				print_line(movl, GRc ADDR(GR), grl(rt), imm, grl(rs));
			} else if (is_xreg(rt)) {
				print_line(movl, GRc TMP, grl(rs));
				print_line(movl, GRc ADDR(TMP), grl(rt), imm);
			} else {
				print_line(movl, GRc TMP, grl(rs));
				print_line(movl, GRc TMP1, grl(rt));
				print_line(movl, TMP1c ADDR(TMP), imm);
			}
		    return 0;
		}
	}
	if(inst_is("fadd")) {
		if (myscan(ifff, &rd, &rs, &rt) == 3) {

	 		if ((rd == rs) && (is_xmm(rs))) {
				print_line(addss, FRc FR, frl(rt), frl(rs));
			} else if ((rd == rt) && (is_xmm(rd))) {
				print_line(addss, FRc FR, frl(rs), frl(rd));
			} else {
				print_line(movss, FRc FTMP, frl(rs));
				print_line(addss, FRc FTMP, frl(rt));
				print_line(movss, FTMPc FR, frl(rd));
			}

		    return 0;
		}
	}
	if(inst_is("fsub")) {
		if (myscan(ifff, &rd, &rs, &rt) == 3) {
	 		if ((rd == rs) && (is_xmm(rs))) {
				print_line(subss, FRc FR, frl(rt), frl(rs));
			} else {
				print_line(movss, FRc FTMP, frl(rs));
				print_line(subss, FRc FTMP, frl(rt));
				print_line(movss, FTMPc FR, frl(rd));
			}
		    return 0;
		}
	}
	if(inst_is("fmul")) {
		if (myscan(ifff, &rd, &rs, &rt) == 3) {

	 		if ((rd == rs) && (is_xmm(rs))) {
				print_line(mulss, FRc FR, frl(rt), frl(rs));
			} else if ((rd == rt) && (is_xmm(rd))) {
				print_line(mulss, FRc FR, frl(rs), frl(rd));
			} else {
				print_line(movss, FRc FTMP, frl(rs));
				print_line(mulss, FRc FTMP, frl(rt));
				print_line(movss, FTMPc FR, frl(rd));
			}

		    return 0;
		}
	}

	if(inst_is("fdiv")) {
		if (myscan(ifff, &rd, &rs, &rt) == 3) {
			if (mathlib_flag) {
				if (is_xmm(rt)) {
					print_line(movd, FRc TMP, frl(rt));
				} else {
					print_line(movl, FRc TMP, frl(rt));
				}
				print_line(call, LABEL, "FInv");
				print_line(movd, TMPc FTMP);
				print_line(mulss, FRc FTMP, frl(rs));
				print_line(movss, FTMPc FR, frl(rd));

			} else {
				if ((rd == rs) && (is_xmm(rs))) {
					print_line(divss, FRc FR, frl(rt), frl(rs));
				} else {
					print_line(movss, FRc FTMP, frl(rs));
					print_line(divss, FRc FTMP, frl(rt));
					print_line(movss, FTMPc FR, frl(rd));

				}
			}


		    return 0;
		}
	}
	if(inst_is("fsqrt")) {
		if (myscan(iff, &rd, &rs) == 2) {
			if (mathlib_flag) {
				if (is_xmm(rs)) {
					print_line(movd, FRc TMP, frl(rs));
				} else {
					print_line(movl, FRc TMP, frl(rs));
				}
				print_line(call, LABEL, "FSqrt");
				if (is_xmm(rd)) {
					print_line(movd, TMPc FR, frl(rd));
				} else {
					print_line(movl, TMPc FR, frl(rd));
				}

			} else {
				if (is_xmm(rd)) {
					print_line(sqrtss, FRc FR, frl(rs), frl(rd));
				} else {
					print_line(movss, FRc FTMP, frl(rs));
					print_line(sqrtss, FTMPc FTMP);
					print_line(movss, FTMPc FRc, frl(rd));
				}
			}
		    return 0;
		}
	}
	if(inst_is("fabs")) {
		if (myscan(iff, &rd, &rs) == 2) {
			print_line(movss, FRc TMP, frl(rs));
			print_line(andl, IMMc TMP, 0x7fffffff);
			print_line(movss, TMPc FRc, frl(rd));
		    return 0;
		}
	}
	if(inst_is("fmov")) {
		if (myscan(iff, &rd, &rs) == 2) {
			if (is_xmm(rd)) {
				print_line(movss, FRc FR, frl(rs), frl(rd));
			} else {
				if (is_xmm(rs)) {
					print_line(movd, FRc TMP, frl(rs));
				} else {
					print_line(movl, FRc TMP, frl(rs));
				}
				print_line(movl, TMPc FR, frl(rd));
			}
		    return 0;
		}
	}
	if(inst_is("fneg")) {
		if (myscan(iff, &rd, &rs) == 2) {
			if (is_xmm(rs)) {
				print_line(movd, FRc TMP, frl(rs));
			} else {
				print_line(movl, FRc TMP, frl(rs));
			}
			print_line(xorl, IMMc TMP, 0x80000000);
			if (is_xmm(rd)) {
				print_line(movd, TMPc FR, frl(rd));
			} else {
				print_line(movl, TMPc FR, frl(rd));
			}
		    return 0;
		}
	}

	if(inst_is("fld")) {
		if (myscan(ifgg, &rd, &rs, &rt) == 3) {
			print_line(movl, GRc TMP1, grl(rs));
			print_line(movl, GRc TMP, grl(rt));
			print_line(movl, "0("TMPc TMP1c"1), "TMP);
			if (is_xmm(rd)) {
				print_line(movd, TMPc FR, frl(rd));
			} else {
				print_line(movl, TMPc FR, frl(rd));
			}
		    return 0;
		}
	}
	if(inst_is("fst")) {
		if (myscan(ifgg, &rd, &rs, &rt) == 3) {
			print_line(push, LABEL, "%rbx");
			print_line(movl, GRc TMP1, grl(rt));
			print_line(movl, GRc TMP, grl(rs));
			if (is_xmm(rd)) {
				print_line(movd, FRc LABEL, frl(rd), "%ebx");
			} else {
				print_line(movl, FRc LABEL, frl(rd), "%ebx");
			}
			print_line(movl, LABELc "0("TMPc TMP1c "1)", "%ebx");
			print_line(pop, LABEL, "%rbx");
		    return 0;
		}
	}
	if (inst_is("fldi")) {
		if (myscan(ifgi, &rt, &rs, &imm) == 3) {
			if (is_xmm(rt)) {
				if (is_xreg(rs)) {
					print_line(movss, ADDRc(GR) FR, imm, grl(rs), frl(rt));
				} else {
					print_line(movl, GRc TMP, grl(rs));
					print_line(movss, ADDRc(TMP) FR, imm, frl(rt));
				}
			} else {
				print_line(movl, GRc TMP1, grl(rs));
				print_line(movl, ADDRc(TMP1) TMP, imm);
				print_line(movl, TMPc FR, frl(rt));
			}
		    return 0;
		}
	}
	if (inst_is("fsti")) {
		if (myscan(ifgi, &rt, &rs, &imm) == 3) {
			if (is_xmm(rt)) {
				if (is_xreg(rs)) {
					print_line(movss, FRc ADDR(GR), frl(rt), imm, grl(rs));
				} else {
					print_line(movl, GRc TMP, grl(rs));
					print_line(movss, FRc ADDR(TMP), frl(rt), imm);
				}
			} else {
				print_line(movl, FRc TMP1, frl(rt));
				print_line(movl, GRc TMP, grl(rs));
				print_line(movl, TMP1c ADDR(TMP), imm);
			}
		    return 0;
		}
	}
	if (inst_is("fjeq")) {
		if (myscan(iffl, &rs, &rt, lname) == 3) {
			if (is_xmm(rs) && is_xmm(rt)) {
				print_line(comiss, FRc FR, frl(rt), frl(rs));
				print_line(je, LABEL, lname);
			} else if (is_xmm(rs)) {
				print_line(movss, FRc FTMP, frl(rt));
				print_line(comiss, FTMPc FR, frl(rs));
				print_line(je, LABEL, lname);
			} else if (is_xmm(rt)) {
				print_line(movss, FRc FTMP, frl(rs));
				print_line(comiss, FTMPc FR, frl(rt));
				print_line(je, LABEL, lname);
			} else {
				print_line(flds, FR, frl(rt));
				print_line(flds, FR, frl(rs));
				print_line(fcompp, "");
				print_line(fnstsw, LABEL, "%ax");
				print_line(sahf, "");
				print_line(je, LABEL, lname);
			}
		    return 0;
		}
	}

	if (inst_is("fjlt")) {
		if (myscan(iffl, &rs, &rt, lname) == 3) {
			if (is_xmm(rs) && is_xmm(rt)) {
				print_line(comiss, FRc FR, frl(rt), frl(rs));
				print_line(jb, LABEL, lname);
			} else if (is_xmm(rs)) {
				print_line(movss, FRc FTMP, frl(rt));
				print_line(comiss, FTMPc FR, frl(rs));
				print_line(jb, LABEL, lname);
			} else if (is_xmm(rt)) {
				print_line(movss, FRc FTMP, frl(rs));
				print_line(comiss, FRc FTMP, frl(rt));
				print_line(jb, LABEL, lname);
			} else {
				print_line(flds, FR, frl(rt));
				print_line(flds, FR, frl(rs));
				print_line(fcompp, "");
				print_line(fnstsw, LABEL, "%ax");
				print_line(sahf, "");
				print_line(jb, LABEL, lname);
			}

		    return 0;
		}
	}
	if(inst_is("nop")){
		print_line(nop, "");
		return 0;
	}
	if(inst_is("halt")){
		if (count_flag) {
			print_line(call, LABEL, "NewLine");
			print_line(movq, LABELc LABEL, "(CNT)", "%rax");
			print_line(call, LABEL, "PrintHex16");
			print_line(call, LABEL, "NewLine");
		}
		print_line(call, LABEL, "Exit");
		return 0;
	}
	if(inst_is("setL")){
		if (myscan(igl, &rd, lname) == 2) {
			print_line(movl, "$%s, "GR, lname, grl(rd));
		    return 0;
		}
	}
	return -1;
}

int is_const(int i) {
	return (i == 0 || i == 28 || i == 29);
}

#define XREG_NUM 13
int is_xreg(int i) {
	int j;
	const int a[XREG_NUM] = {3,1,26,7,31,6,9,4,5,10, 2,11,8};
	if (is_const(i)) {
		return 1;
	}
	for (j = 0; j < XREG_NUM; j++) {
		if (i == a[j]) {
			return 1;
		}
	}
	return 0;
}

#define XMM_NUM 15
int is_xmm(int i) {
	int j;
	const int a[XMM_NUM] = {0,1,3,6,2,7,5,4,8, 12,18,22,31,9,16};
	for (j = 0; j < XMM_NUM; j++) {
		if (i == a[j]) {
			return 1;
		}
	}
	return 0;
}

#define set_label(fmt, ...) \
	sprintf(label[label_idx], fmt, ##__VA_ARGS__)
static char *gr_label(int register_index, int dst_flag, int quad_flag) {
	static char label[3][16];
	static int label_idx = 0;
	char *datalen1 = (quad_flag) ? (char *)"" : (char *)"d";
	char *datalen2 = (quad_flag) ? (char *)"r" : (char *)"e";
	label_idx = (label_idx+1)%3;
	if (dst_flag && is_const(register_index)) {
		set_label("%%eax");

	} else {
		switch (register_index) {
			case 0 : set_label("$0"); break;
			case 28: set_label("$1"); break;
			case 29: set_label("$-1"); break;
			case 26:
					set_label("%%r8%s", datalen1); break;
			case 1:
					set_label("%%r9%s", datalen1); break;
			case 31:
					set_label("%%r10%s", datalen1); break;
			case 3:
					set_label("%%r11%s", datalen1); break;
			case 2:
					set_label("%%r12%s", datalen1); break;
			case 4:
					set_label("%%r13%s", datalen1); break;
			case 5:
					set_label("%%r14%s", datalen1); break;
			case 9:
					set_label("%%r15%s", datalen1); break;
			case 6:
					set_label("%%%sbx", datalen2); break;
			case 10:
					set_label("%%%scx", datalen2); break;
			case 11:
					set_label("%%%ssi", datalen2); break;
			case  7:
					set_label("%%%sdi", datalen2); break;
			case 8:
					set_label("%%%sbp", datalen2); break;
			default :
					set_label("(GR%d)", register_index); break;
		}
	}
	return label[label_idx];
}

static char *fr_label(int register_index) {
	static char label[3][16];
	static int label_idx = 0;
	label_idx = (label_idx+1)%3;
	switch (register_index) {
		case 0 : set_label("%%xmm0"); break;
		case 1 : set_label("%%xmm1"); break;
		case 2 : set_label("%%xmm2"); break;
		case 12 : set_label("%%xmm3"); break;
		case 8 : set_label("%%xmm4"); break;
		case 18 : set_label("%%xmm5"); break;
		case 3 : set_label("%%xmm6"); break;
		case 22 : set_label("%%xmm7"); break;
		case 31 : set_label("%%xmm8"); break;
		case 4 : set_label("%%xmm9"); break;
		case 9 : set_label("%%xmm10"); break;
		case 5 : set_label("%%xmm11"); break;
		case 16 : set_label("%%xmm12"); break;
		case 7 : set_label("%%xmm13"); break;
		case 6 : set_label("%%xmm14"); break;
		default : set_label("(FR%d)", register_index); break;
	}
	return label[label_idx];
}

void print_inc_line(void) {
	print_line(incq, LABEL, "(CNT)");
}

#undef set_label


