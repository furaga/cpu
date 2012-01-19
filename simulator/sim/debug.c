#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sim.h>

#define SIZE 256

#define myerr(str) \
	fprintf(fp, "Error: %s\nCommand: %s", str, buf)

void debug_usage(void) {
	FILE *fp = stderr;
	fprintf(fp, "Commands:\n");
	fprintf(fp, "\t[Enter]: next step\n");
	fprintf(fp, "\ts: next step\n");
	fprintf(fp, "\t[Ctrl-D] : exit\n");
	fprintf(fp, "\tcnt X : X(int) cntをXまでスキップ\n");
	fprintf(fp, "\tout dfile : 出力先をdfileに変更\n");
	fprintf(fp, "\thelp : コマンドを確認\n");
	fprintf(fp, "\tlr : リンクレジスタ\n");
	fprintf(fp, "\tir : 命令の確認\n");
	fprintf(fp, "\tgX : X番目の汎用レジスタ\n");
	fprintf(fp, "\tfX : X番目のFRレジスタ\n");
	fprintf(fp, "\treg : 全汎用レジスタ\n");
	fprintf(fp, "\tfreg : 全FRレジスタ\n");
	fprintf(fp, "\tstack X : X(int) スタックの底からX個までの数を列挙\n");
	fprintf(fp, "\theap X : X(int) ヒープの上からX個までの数を列挙\n");
}

void debug(void) {
	char buf[SIZE];
	static char dfile[SIZE];
	int reg_num;
	int stack_num, heap_num;
	int i;
	uint32_t ir;
	long long unsigned target_cnt;
	static long long int count_down = 0;
	static FILE *fp = stderr;

	if (count_down > 0) {
		count_down--;
		return;
	}

	ir = rom[pc/4];
	fprintf(fp, "Next => ");
	print_ir(ir, fp);

	while (1) {
		if (fp == stderr) {
			fprintf(fp, "> ");
		}
		if (fgets(buf, SIZE, stdin) == NULL) { 
			fprintf(fp, "\n"); exit(0); 
		}

		if (sscanf(buf, "g %d", &reg_num) == 1) {
			if (0 <= reg_num && reg_num <= REG_NUM) {
				fprintf(fp, "g%d = 0x%08X\n", reg_num, reg[reg_num]);
			} else {
				myerr("Out of range");
			}
		}
		else if (sscanf(buf, "f %d", &reg_num) == 1) {
			if (0 <= reg_num && reg_num <= REG_NUM) {
				fprintf(fp, "f%d = 0x%08X\n", reg_num, freg[reg_num]);
			} else {
				myerr("Out of range");
			}
		}
		else if (strstr(buf, "freg")) {
			fprintf(fp, "Floating-point Number Registers\n");
			for (i = 0; i < REG_NUM; i++) {
				fprintf(fp, "%02d:0x%08X  ", i,freg[i]);
				if ((i%4)==3) {
					fprintf(fp, "\n");
				}
			}
		}
		else if (strstr(buf, "reg")) {
			fprintf(fp, "General Registers\n");
			for (i = 0; i < REG_NUM; i++) {
				fprintf(fp, "%02d:0x%08X  ", i, reg[i]);
				if ((i%4)==3) {
					fprintf(fp, "\n");
				}
			}
		}
		else if (sscanf(buf, "stack %d\n", &stack_num) == 1) {
			fprintf(fp, "Addr    : Record\n");
			for (i = 0; i < stack_num; i++) {
				fprintf(fp, "0x%06X: 0x%08X\n", 4*(RAM_NUM-1-i), ram[(RAM_NUM-1-i)]);
			}
		}
		else if (sscanf(buf, "heap %d\n", &heap_num) == 1) {
			fprintf(fp, "Addr    : Record\n");
			for (i = 0; i < heap_num; i++) {
				fprintf(fp, "0x%06X: 0x%08X\n", 4*i, ram[i]);
			}
		}
		else if (sscanf(buf, "cnt %llu", &target_cnt) == 1) {
			if (target_cnt > cnt) {
				fprintf(fp, "skip to count[%llu]\n", target_cnt);
				count_down = target_cnt - cnt - 1;
				break;
			} else {
				myerr("Target count is too small");
			}
		}
		else if (strstr(buf, "ir")) {
			fprintf(fp, "Next => ");
			print_ir(ir, fp);
		}
		else if (strstr(buf, "lr")) {
			fprintf(fp, "lr   : 0x%08X\n", lr);
			fprintf(fp, "tmplr: 0x%08X\n", tmplr);
		}
		else if (strcmp(buf, "help\n") == 0) {
			debug_usage();
		}
		else if (sscanf(buf, "out %s", dfile) == 1) {
			if ((fp = fopen(dfile, "w")) != NULL) {
				fprintf(stderr, "output to %s\n", dfile);
			} else {
				myerr("fopen");
				fp = stderr;
			}

		}
		else if (buf[0] == '\n') {
			break;
		}
		else if (strcmp("s\n", buf) == 0) {
			break;
		}
		else {
			myerr("Unknown command");
		}
	}
	fflush(fp);

}
