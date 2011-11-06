
#ifndef _REASM_HEAD_
#define _REASM_HEAD_

#define NL putchar('\n')
#define OP(name) printf("\t%s\t\t", #name)
#define S(name) printf("%s", #name)
#define L(name) printf("%s", name)
#define LC(name) printf(", %s", name)
#define SC(name) printf(", %s", #name)
//#define G(i) printf("[GR%d]", i)
//#define GC(i) printf(", [GR%d]", i)
#define G(i) print_gr(i, 0)
#define GC(i) print_gr(i, 1)
#define F(i) printf("dword [FR%d]", i)
#define FC(i) printf(", dword [FR%d]", i)
#define IM(i) printf(", %d", i)
#define IMDW(i) printf(", dword %d", i)
#define ADR(a,b) printf("[%s - %d]", #a,b)
#define ADRC(a,b) printf(", [%s - %d]", #a,b)
#define WORD printf("word ")
#define DWORD printf("dword ")

void print_gr(int,int);
int is_const(int);
int is_xreg(int);
#endif
