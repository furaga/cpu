#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>
#include "asm.h"
#include "geso.h"


int convert_op(char *, char *);
 
int	convert(char *sfile) {
	char	buf[LINE_MAX], opcode[256], heap_buf[(1<<20)];	
	uint32_t	heap_size,cnt,input_line_cnt,i;
	char *hbuf_tail,*tmp = NULL;
	FILE	*fp;
	int num;

	heap_size = 0;
	input_line_cnt = 1;
	hbuf_tail = heap_buf;

	fp = fopen(sfile, "r");
	if(fp == NULL){
		fprintf(stderr,"ファイルが開けませんでした。\n");
		kill(0,SIGINT);
	}

	puts(".code64");
	puts(".section .text");
	puts(".global _start");


	if (fgets(buf, LINE_MAX, fp) != NULL) {
		sscanf(buf, ".init_heap_size %d", &heap_size);
	}
	input_line_cnt++;

	cnt = 0;

	while ((cnt < heap_size) && (fgets(buf, LINE_MAX, fp) != NULL)) {
		if (sscanf(buf, "%s", opcode) == 1) {
			// heap initialize
			if (strchr(buf, ':')) {
				tmp = strtok(buf,":");
				hbuf_tail += sprintf(hbuf_tail, "%s:",tmp);
			} else {
				sscanf(buf, "%s 0x%x", tmp, &num);
				hbuf_tail += sprintf(hbuf_tail, "	.long	0x%x\n", num);
				cnt += 32;
			}
		}
		input_line_cnt++;
	}
	hbuf_tail[0] = 0;

	while(fgets(buf, LINE_MAX, fp) != NULL){
		if(sscanf(buf, "%s", opcode) == 1){
 	 	 	if(strchr(buf,':')) {
				puts(".align 16");
				printf("%s",buf);
 	 	 		// ラベル行の場合
			}else if(opcode[0] == '.'){
			}else if(opcode[0] == '!'){
 	 	 		// -- コメントなので何もしない
 	 	 	}else{
 	 	 		// 命令行
				if (count_flag) {
					OP(incq), S((CNT)), NL;
				}
				fflush(stdout);
 	 	 		if (convert_op(opcode, buf) < 0) {
					fprintf(stderr,"While Converting %s,\n", sfile);
					fprintf(stderr,"Unknown operation Line %d\n", input_line_cnt);
					fprintf(stderr,"%s", buf);
					kill(0,SIGINT);
				}
			}
		}
		fflush(stdout);
		input_line_cnt++;
	}

	fclose(fp);


	// Register Init ////////////////////

	puts("\n_start:");
	puts("	xorq	%rbx, %rbx");
	puts("	xorq	%rcx, %rcx");
	puts("	xorq	%rsi, %rsi");
	puts("	xorq	%rdi, %rdi");
	puts("	xorq	%rbp, %rbp");
	puts("	xorq	%r8, %r8");
	puts("	xorq	%r9, %r9");
	puts("	xorq	%r10, %r10");
	puts("	xorq	%r11, %r11");
	puts("	xorq	%r12, %r12");
	puts("	xorq	%r13, %r13");
	puts("	xorq	%r14, %r14");
	puts("	xorq	%r15, %r15");
	puts("	movl	$BOTTOM, %r9d");
	//puts("	movl	$TOP, (GR2)");
	puts("	movl	$TOP, %r12d");
	puts("	movl	$BOTTOM, %r10d");
	puts("	call	min_caml_start\n");

	puts(".section .data");
	puts(".align 16");
	printf("%s\n", heap_buf);
	for (i = 0; i < 32; i++) {
		if (!is_xreg(i)) {
			printf("GR%d: .long 0\n", i);
		}
	}
	for (i = 0; i < 32; i++) {
		if (!is_xmm(i)) {
			printf("FR%d: .long 0\n", i);
		}
	}
	puts("TMP: .long 0");
	puts("CNT: .quad 0");
	printf("FNEG: .quad 0x%d\n", 1<<31);
	puts(".section .bss");
	puts(".lcomm TOP, 0");
	printf(".lcomm RAM, %u\n", (unsigned)1<<25);
	puts(".lcomm BOTTOM, 64");



	

	return 0;

}
