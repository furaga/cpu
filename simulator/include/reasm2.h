
#ifndef _REASM_HEAD_
#define _REASM_HEAD_

#define NL putchar('\n')
#define OP(name) printf("\t%s\t\t", #name)
#define S(name) printf("%s", #name)
#define SC(name) printf(", %s", #name)
#define L(name) printf("%s", name)
#define LC(name) printf(", %s", name)
//#define G(i) printf("[GR%d]", i)
//#define GC(i) printf(", [GR%d]", i)
#define G(i) print_gr(i, 0, 0)
#define GC(i) print_gr(i, 1, 0)
#define GQ(i) print_gr(i, 0, 1)
#define F(i) printf("(FR%d)", i)
#define FC(i) printf(", (FR%d)", i)
#define IM(i) printf("$%d", i)
#define IMDW(i) printf("$%d", i)
#define ADR(a,b) printf("-%d(%s)", b, #a)
#define ADRC(a,b) printf(", -%d(%s)",b, #a)
#define WORD printf("word ")
#define DWORD printf("dword ")

void print_gr(int,int,int);
int is_const(int);
int is_xreg(int);
extern int count_flag;
#endif
