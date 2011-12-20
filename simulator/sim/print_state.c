#include <stdio.h>
#include <string.h>
#include "sim.h"
enum Print_Flags {
ON,GC,REG,RAM,PRINT_FLAG_NUM
};

int __print_state(int init_flag, int argc, char **argv) {
	static FILE *fp = NULL;
	static int flag[PRINT_FLAG_NUM] = {0};
	static const char *break_points[INST_NUM];
	static int ram_s, ram_f, bpcnt = 0;
	int i,bp;

	if (init_flag) {
	// Initialize /////////////////////////////////////////
		for (i = 0; i < argc; i++) {
			if (argv[i][0] == '-') {
				if (strcmp(argv[i], "-g") == 0) {
					// -g	// getchar each print_state
					flag[ON] = flag[GC] = 1;
				} else if (strcmp(argv[i], "-reg")==0) {
					// -reg  // print all registers
					flag[ON] = flag[REG] = 1; 
				} else if (strcmp(argv[i], "-ram")==0) {
					// -ram 0 100  // print ram
					flag[ON] = flag[RAM] = 1; 
					if ((sscanf(argv[++i], "%d", &ram_s) != 1) ||
						(sscanf(argv[++i], "%d", &ram_f) != 1)) {
						puts("USAGE: -ram [start num] ([end_num])");
						return -1;
					}
				} else if (strcmp(argv[i], "-op")==0) {
					// -op ld jmp jeq [END]// break point
					flag[ON] = 1;
					i++;
					for (; i < argc;bpcnt++,i++) {
						break_points[bpcnt] = argv[i];
					}
				} else if (strcmp(argv[i], "-o")==0) {
					flag[ON] = 1;
					fp = fopen(argv[++i], "w");
				} else if (strcmp(argv[i], "-o1")==0) {
					flag[ON] = 1;
					fp = stdout;
				} else if (strcmp(argv[i], "-o2")==0) {
					flag[ON] = 1;
					fp = stderr;
				} else if (strcmp(argv[i], "-p")==0) {
					flag[ON] = 1;
				} else if (strcmp(argv[i], "-res")==0) {
					flag[ON] = 1;
					break_points[bpcnt++] = "halt";
				} else {
					fprintf(stderr, "useless option:%s\n",argv[i]);
				}
			}
		}
		if ((flag[ON] == 1) && (fp == NULL)) {
			fp = fopen(SIM_LOG, "w");
		}
	} else {


		if (flag[ON]) {
			if (bpcnt > 0) {
				for (i=0,bp=0; i < bpcnt; i++) {
					if (strcmp(break_points[i], InstMap[get_opcode(rom[pc])]) == 0)
						bp=1;
				}
				if (bp==0) 
					return 0;
			}

			
			fprintf(fp, "%6llu.[%4d] ", cnt,pc);
			print_ir(rom[pc],fp);

			if (flag[REG]) {
				for (i = 0; i < 32; i++) {
					fprintf(fp, "g%d:%x\n", i, reg[i]);
				}
				/*
				fprintf(fp, "g0:%X g1:%X g2:%X g3:%X g4:%X g5:%X g6:%X g7:%X\n",
							reg[0],reg[1],reg[2],reg[3],reg[4],reg[5],reg[6],reg[7]);
				fprintf(fp, "g8:%X g9:%X g10:%X g11:%X g12:%X g13:%X g14:%X g15:%X\n",
							reg[8],reg[9],reg[10],reg[11],reg[12],reg[13],reg[14],reg[15]);
				fprintf(fp, "g16:%X g17:%X g18:%X g19:%X g20:%X g21:%X g22:%X g23:%X\n",
							reg[16],reg[17],reg[18],reg[19],reg[20],reg[21],reg[22],reg[23]);
				fprintf(fp, "g24:%X g25:%X g26:%X g27:%X g28:%X g29:%X g30:%X g31:%X\n",
							reg[24],reg[25],reg[26],reg[27],reg[28],reg[29],reg[30],reg[31]);
				fflush(fp);
				fprintf(fp, "f0:%f f1:%f f2:%f f3:%f f4:%f f5:%f f6:%f f7:%f\n",
							(float)freg[0],(float)freg[1],(float)freg[2],(float)freg[3],(float)freg[4],(float)freg[5],(float)freg[6],(float)freg[7]);
				fprintf(fp, "f8:%f f9:%f f10:%f f11:%f f12:%f f13:%f f14:%f f15:%f\n",
							(float)freg[8],(float)freg[9],(float)freg[10],(float)freg[11],(float)freg[12],(float)freg[13],(float)freg[14],(float)freg[15]);
				fprintf(fp, "f16:%f f17:%f f18:%f f19:%f f20:%f f21:%f f22:%f f23:%f\n",
							(float)freg[16],(float)freg[17],(float)freg[18],(float)freg[19],(float)freg[20],(float)freg[21],(float)freg[22],(float)freg[23]);
				fprintf(fp, "f24:%f f25:%f f26:%f f27:%f f28:%f f29:%f f30:%f f31:%f\n",
							(float)freg[24],(float)freg[25],(float)freg[26],(float)freg[27],(float)freg[28],(float)freg[29],(float)freg[30],(float)freg[31]);
				fflush(fp);
				*/
			}
			if (flag[RAM]) {
				for (i = ram_s; i < ram_f; i++) {
					if (!((i-ram_s)%8))
						fprintf(fp, "\n");
					fprintf(fp, "ram%d:%X ", i,ram[i]);
				}
				fprintf(fp, "\n");
				fflush(fp);
			}
			if (flag[GC])
				getchar();
		}
	}

	return 0;
}
