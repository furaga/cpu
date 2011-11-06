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
#include "reasm.h"

#define	LINE_MAX	2048	// asmの一行の長さの最大値

int encode_op(char *, char *);
 
int	assemble(char *sfile) {
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

	puts("bits	64");
	puts("section .text");
	puts("global _start:");
	puts("%define DEBUG");
	puts("%include \"debug64.inc\"");
	puts("%include \"stdio64.inc\"");


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
				hbuf_tail += sprintf(hbuf_tail, "	dd	0x%x\n", num);
				cnt += 32;
			}
		}
		input_line_cnt++;
	}
	hbuf_tail[0] = 0;

	while(fgets(buf, LINE_MAX, fp) != NULL){
		if(sscanf(buf, "%s", opcode) == 1){
 	 	 	if(strchr(buf,':')) {
				printf("%s",buf);
 	 	 		// ラベル行の場合
			}else if(opcode[0] == '.'){
			}else if(opcode[0] == '!'){
 	 	 		// -- コメントなので何もしない
 	 	 	}else{
 	 	 		// 命令行
 	 	 		if (encode_op(opcode, buf) < 0) {
					fprintf(stderr,"While Reassembling %s,\n", sfile);
					fprintf(stderr,"Unknown operation L.%d\n", input_line_cnt);
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
	puts("	mov		dword [GR1], BOTTOM");
	puts("	mov		dword [GR2], TOP");
	puts("	mov		dword [GR31], BOTTOM");
	puts("	xor		r8, r8");
	puts("	xor		r9, r9");
	puts("	xor		r10, r10");
	puts("	xor		r11, r11");
	puts("	xor		r12, r12");
	puts("	xor		r13, r13");
	puts("	xor		r14, r14");
	puts("	xor		r15, r15");
	puts("	mov		r11d, dword [GR1]");
	puts("	mov		r12d, dword [GR2]");
	puts("	call	min_caml_start\n");

	puts("section .data");
	printf("%s\n", heap_buf);
	for (i = 0; i < 32; i++) {
		printf("GR%d: dd 0\n", i);
	}
	for (i = 0; i < 32; i++) {
		printf("FR%d: dd 0\n", i);
	}
	puts("section .bss");
	puts("TOP:");
	printf("RAM: resd %u\n", (unsigned)1<<25);
	puts("BOTTOM:");



	

	return 0;

}
