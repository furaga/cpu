#include <stdio.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <math.h>
#include "sim.h"


int32_t reg[REG_NUM];
uint32_t freg[REG_NUM];
uint32_t rom[ROM_NUM];
uint32_t ram[RAM_NUM];
uint32_t pc;
long long unsigned cnt;

// define fetch functions ////////////////////
DEF_ELE_GET(get_opcode, 26, 0x3f);		
DEF_ELE_GET(get_rsi, 21, 0x1f);
DEF_ELE_GET(get_rti, 16, 0x1f);
DEF_ELE_GET(get_rdi, 11, 0x1f);
DEF_ELE_GET(get_shamt, 6, 0x1f);
DEF_ELE_GET(get_funct, 0, 0x3f);
DEF_ELE_GET(get_target, 0, 0x3ffffff);
int32_t get_imm(uint32_t ir) {
	return (ir & (1 << 15)) ?
		   ((0xffff<<16) | (ir & 0xffff)):
		   (ir & 0xffff);
}

// rom の命令実行列(バイナリ)に従いシミュレートする
int simulate(char *sfile) {
	uint32_t ir, lr, heap_size;
	int fd,ret,i;

	fd = open(sfile, O_RDONLY);
	if (fd < 0) {
		fprintf(stderr, "%s: No such file\n", sfile);
		return 1;
	}
	ret = read(fd, rom, ROM_NUM*4);
	close(fd);

	lr = cnt = pc = 0;
	reg[1] = reg[31] = RAM_NUM;

	// ヒープ確保
	heap_size = rom[0]; 
	pc++;
	for (i = 0; heap_size > 0; i++,pc++) {
		ram[i] = rom[pc];
		reg[2] += 4;
		heap_size -= 32;
	}

	fprintf(stderr, "simulate %s\n", sfile);
	fflush(stderr);

	// 命令列を実行
	do{
		
		rom[1 << 30] = 1;;
		ir = rom[pc];
		print_state();
		statistics(stderr);
		cnt++;
		pc++;
		if (!(cnt % 100000000)) {
			fprintf(stderr, ".");
			fflush(stderr);
		}
		// 命令実行
		ret = operate(ir);
	} while(ret > 0);


	fprintf(stderr, "\nCPU Simulator Results\n");
	fprintf(stderr, "cnt:%llu\n", cnt);
	fflush(stderr);

	return 0;
} 
