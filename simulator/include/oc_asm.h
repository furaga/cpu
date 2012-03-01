
#ifndef _ASM_HEAD
#define _ASM_HEAD
#include "common.h"
#include <stdint.h>
#include "asm_fmt.h"

extern FILE* err_fp;
#define warning(fmt, ...) \
	fprintf(err_fp, fmt, ##__VA_ARGS__)
extern void *mygets(char *dst, char *src, int n);

typedef struct label_t {
	char name[COL_MAX];
	int len;
	int line;
} label_t;
extern int hash_insert(label_t label);
extern int hash_find(label_t label);
extern uint32_t encode_op(char *asm_line, char *inst);
extern inline uint32_t eff_dig(unsigned dig, uint32_t num);
extern inline uint32_t shift_left_l(unsigned shiftwidth, uint32_t num);
extern inline uint32_t shift_right_a(unsigned shiftwidth, uint32_t num);
extern void register_linst_rel(char*);
extern void register_linst_abs(char*);
extern void set_bin(char *buf, uint32_t num);
extern int set_hex(char *buf, uint32_t num);

void _mywrite(int fd, char *buf, int num);
#endif
