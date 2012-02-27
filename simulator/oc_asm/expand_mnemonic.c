#include <stdio.h>
#include <string.h>
#include "oc_asm.h"

static char asm_line[COL_MAX];
static char inst[COL_MAX];
static char tmpbuf[COL_MAX];

#define print_expanded(fmt, ...) \
	(dst_ptr += sprintf(dst_ptr, "\t" asm_fmt_##fmt "\n", ##__VA_ARGS__))
#define print_original(fmt, ...) \
	(dst_ptr += sprintf(dst_ptr, fmt, ##__VA_ARGS__))

static inline int _inst_is(char *inst, const char *str) {
	return strcmp(inst, str) == 0;
}
#define inst_is(str) _inst_is(inst, str)
#undef myscan
#define myscan(fmt, ...) \
	(sscanf(asm_line, asm_fmt_##fmt, tmpbuf, ##__VA_ARGS__) - 1)

int expand_mnemonic(char *ex_mne_buf, char *asm_buf) {
	int rd,rs;
	char* dst_ptr = ex_mne_buf;

    while (mygets(asm_line, asm_buf, COL_MAX) != NULL) {

    	if (sscanf(asm_line, "%s", inst) == 1) {

			if (inst_is("nop")) {
				print_expanded(iggi, "slli", 0,0,0);
			} else
			if (inst_is("mov")) {
				if (myscan(igg, &rd, &rs) == 2) {
					print_expanded(iggi, "addi", rd, rs, 0);
				}
			} else
			if (inst_is("not")) {
				if (myscan(igg, &rd, &rs) == 2) {
					print_expanded(iggg, "nor", rd, rs, rs);
				}
			} else
			if (inst_is("setL")) {
				if (myscan(igl, &rd, tmpbuf) == 2) {
					print_original(asm_fmt_igl, ".setL", rd, tmpbuf);
					print_original("\n");
				}
			} else {
				print_original("%s", asm_line);
			}
		} else {
			// empty line
			print_original("\n");
		}
    }
	return (int) (dst_ptr - ex_mne_buf);
}

