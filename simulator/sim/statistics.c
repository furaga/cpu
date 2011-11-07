#include <stdio.h>
#include "sim.h"

// 命令実行回数の計数
int statistics(FILE* fp,int init) {
	static int count[INST_NUM][INST_NUM];
	const char *format = "%8s: %f %10d\n";
	uint32_t ir = rom[pc];
	uint8_t opcode, funct;
	int i,j;
	opcode = get_opcode(ir);
	funct = get_funct(ir);
	if (init) {
		for (i = 0; i < INST_NUM; i++) {
			for (j = 0; j < INST_NUM; j++) {
				count[i][j] = 0;
			}
		}
		return 0;
	}
	

	switch (opcode) {
		case SPECIAL: 
			count[074][0]++;count[opcode][funct]++;break;
		case IO: 
			count[075][0]++;count[opcode][funct]++;break;
		case FPI: 
			count[076][0]++;count[opcode][funct]++;break;
		default:
			count[077][0]++;
			count[opcode][0]++;
			break;
	}

	if ((opcode == SPECIAL) && (funct == HALT_F)) {
		fprintf(fp, "\n");

		for (i = 0; i < INST_NUM; i++) {
			switch (i) {
				case SPECIAL: 
				case IO: 
				case FPI:
					for (j = 0; j < INST_NUM; j++) {
						if (count[i][j] > 0) {
							fprintf(fp, format, FunctMap[i][j], count[i][j]*1.0/cnt, count[i][j]);
						}
					}
				break;
			default:
				if (count[i][0] > 0) {
					fprintf(fp, format, InstMap[i], count[i][0]*1.0/cnt, count[i][0]);
				}
				break;
			
			}
		}
		fprintf(fp, "\n");

		return 1;
	}
	return 0;
}
