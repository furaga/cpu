
#ifndef _REASM_HEAD_
#define _REASM_HEAD_

#define NL putchar('\n')
#define OP(name) printf("\t%s\t\t", #name)
#define S(name) printf("%s", #name)
#define L(name) printf("%s", name)
#define LC(name) printf(", %s", name)
#define SC(name) printf(", %s", #name)
#define G(i) printf("[GR%d]", i)
#define GC(i) printf(", [GR%d]", i)
#define GA(a,b) printf("[GR%d - %d]", a,b)
#define GAC(a,b) printf(", [GR%d - %d]", a,b)
#define F(i) printf("dword [FR%d]", i)
#define FC(i) printf(", dword [FR%d]", i)
#define FA(a,b) printf("dword [FR%d - %d]", a,b)
#define FAC(a,b) printf(", dword [FR%d - %d]", a,b)
#define IM(i) printf(", %d", i)
#define ADR(a,b) printf("[%s - %d]", #a,b)
#define ADRC(a,b) printf(", [%s - %d]", #a,b)
#define WORD printf("word ")
#define DWORD printf("dword ")

#endif
