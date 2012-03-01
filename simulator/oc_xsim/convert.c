#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include "oc_geso.h"


static int input_line_cnt;
static int err_cnt;
static char asm_line[COL_MAX];
static char term0[COL_MAX];
static char heap_buf[LINE_MAX*COL_MAX];

int convert_op(char *, char *);
void set_heap_buf(char *orig);
void *mygets(char *dst, char *src, int n);
static void prefix(void);
static void register_init(void);
static void text_section(char *);
static void data_section(void);
static void bss_section(void);
 
#define myerr(fmt, ...) \
	warning("Error %d Line %d : "fmt"\n", ++err_cnt, input_line_cnt, ##__VA_ARGS__)
void convert(char *orig_buf) {

	set_heap_buf(orig_buf);

	prefix();
	myputs(".code64");
	text_section(orig_buf);
	data_section();
	bss_section();

}
static void prefix(void) {
myprint(
"########################################################################\n\
## GESO ---- ASM CONVERTER\n\
## Author: Tomoyuki Saito(aocchoda@gmail.com)\n\
########################################################################\n\n");
}
static void text_section(char *orig_buf) {
	myputs(".section .text");
	myputs(".global _start");
	while (mygets(asm_line, orig_buf, COL_MAX) != NULL) {
		if (set_term0(asm_line, term0) == 1) {
			if (is_comment(asm_line, term0)) {
				// blank(comment)
			} else if (is_directive(asm_line, term0)) {
			} else if (is_label(asm_line, term0)) {
				myprint(".align 16\n");
				myprint("%s", asm_line);
			} else {
				if (count_flag) {
					print_inc_line();
				}
				if (convert_op(asm_line, term0) < 0) {
					myerr("unknown operation. line %d\n", input_line_cnt);
					warning("%s\n", asm_line);
				}
			}
		} else {
			// blank(empty line)
		}
		input_line_cnt++;
	}
	register_init();

}

static void register_init(void) {
	myputs("\n_start:");
	myputs("	xorq	%rbx, %rbx");
	myputs("	xorq	%rcx, %rcx");
	myputs("	xorq	%rsi, %rsi");
	myputs("	xorq	%rdi, %rdi");
	myputs("	xorq	%rbp, %rbp");
	myputs("	xorq	%r8, %r8");
	myputs("	xorq	%r9, %r9");
	myputs("	xorq	%r10, %r10");
	myputs("	xorq	%r11, %r11");
	myputs("	xorq	%r12, %r12");
	myputs("	xorq	%r13, %r13");
	myputs("	xorq	%r14, %r14");
	myputs("	xorq	%r15, %r15");
	myputs("	movl	$BOTTOM, %r9d");
	myputs("	movl	$TOP, %r12d");
	myputs("	movl	$BOTTOM, %r10d");
	myputs("	call	min_caml_start\n");
}

static void data_section(void) {
	int i;
	myputs(".section .data");
	myputs(".align 16");
	myprint("%s\n", heap_buf);
	for (i = 0; i < 32; i++) {
		if (!is_xreg(i)) {
			myprint("GR%d: .long 0\n", i);
		}
	}
	for (i = 0; i < 32; i++) {
		if (!is_xmm(i)) {
			myprint("FR%d: .long 0\n", i);
		}
	}
	myputs("TMP: .long 0");
	myputs("CNT: .quad 0");
	myprint("FNEG: .quad 0x%d\n", 1<<31);

}

static void bss_section(void) {
	myputs(".section .bss");
	myputs(".lcomm TOP, 0");
	myprint(".lcomm RAM, %u\n", 1U<<25);
	myputs(".lcomm BOTTOM, 64");
}



	

void *mygets(char *dst, char *src, int n) {
	static char *src_cache = NULL;
	static char *src_ptr = NULL;
	char *ret;
	if (src_cache != src) {
		src_cache = src;
		src_ptr = src;
	}
	if (src_cache == NULL || src_ptr == NULL) { return NULL; }
	ret = (char*)memccpy(dst, src_ptr, '\n', n);
	if (ret == NULL) { 
	    src_ptr = src;
	    return NULL; 
	}
	*ret = '\0';
	src_ptr += (int) (ret - dst);
	return dst;
}

void set_heap_buf(char*orig) {
	int heap_size, num;
	char *ptr=NULL,
		 *hbuf_tail=heap_buf;
	
	if (mygets(asm_line, orig, COL_MAX) != NULL) {
		sscanf(asm_line, ".init_heap_size %d", &heap_size);
	} else {
		myerr("init heap @ convert_heap");
	}
	input_line_cnt++;
	while ((input_line_cnt-1)*32/2 < heap_size) {
		if (mygets(asm_line, orig, COL_MAX) != NULL) {
			if (strchr(asm_line, ':') != NULL) {
				ptr = strtok(asm_line,":");
				hbuf_tail += sprintf(hbuf_tail, "%s:", ptr);
			} else {
				sscanf(asm_line, "%s 0x%x", term0, &num);
				hbuf_tail += sprintf(hbuf_tail, "	.long	0x%x\n", num);
			}
		} else {
			myerr("init heap");
		}
		input_line_cnt++;
	}
	*hbuf_tail = '\0';
}
#undef myprint

