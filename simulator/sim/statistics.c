#include <stdio.h>
#include "sim.h"

// 命令実行回数の計数
void statistics(FILE* fp) {
	static int count[INST_NUM][INST_NUM];
	const char *format = "%8s: %f %10d\n";
	uint32_t ir = rom[pc];
	uint8_t opcode, funct;
	int i,j;
	opcode = get_opcode(ir);
	funct = get_funct(ir);

	switch (opcode) {
		case SPECIAL:
		case IO:
		case FPI:
			count[opcode][funct]++;
			break;
		default:
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
							fprintf(fp, format, FunctMap[j], count[i][j]*1.0/cnt, count[i][j]);
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
	}

}
