
#ifndef __GESO_HEAD__
#define __GESO_HEAD__
#include "asm_fmt.h"
extern int is_const(int);
extern int is_xreg(int);
extern int is_xmm(int);

extern int count_flag;
extern int mathlib_flag;
extern FILE *dfp;
#define warning(fmt, ...) \
	fprintf(stderr, fmt, ##__VA_ARGS__)
#define myprint(fmt, ...) \
	fprintf(dfp, fmt, ##__VA_ARGS__)
#define myputs(str) \
	fputs(str"\n", dfp)
void print_inc_line(void);
#endif
