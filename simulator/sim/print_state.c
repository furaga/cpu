#include <stdio.h>
#include <string.h>
#include "sim.h"
enum Print_Flags {
ON,GC,REG,RAM,PRINT_FLAG_NUM
};
void decode_ir(uint32_t,FILE*);
void IMapInit(void);
const char *InstMap[INST_NUM];
const char *InstTyMap[INST_NUM];
const char *FunctMap[INST_NUM];
const char *FunctTyMap[INST_NUM];

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
		if (fp == NULL)
			fp = fopen(SIM_LOG, "w");
		IMapInit();
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
			decode_ir(rom[pc],fp);

			if (flag[REG]) {
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

void IMapInit(void) {
	FunctMap[NOP_F] = "nop";
	FunctMap[MOV_F] = "mov";
	InstMap[MVHI] = "mvhi";
	InstMap[MVLO] = "mvlo";

	InstMap[ADDI] = "addi";
	InstMap[SUBI] = "subi";
	InstMap[MULI] = "muli";
	InstMap[DIVI] = "divi";
	FunctMap[INPUT_F] = "input";
	FunctMap[OUTPUT_F] = "output";
	FunctMap[NOT_F] = "not";
	InstMap[SLLI] = "slli";
	InstMap[JMP] = "jmp";
	InstMap[JEQ] = "jeq";
	InstMap[JNE] = "jne";
	InstMap[JLT] = "jlt";
	InstMap[JLE] = "jle";
	InstMap[CALL] = "call";
	InstMap[RETURN] = "return";
	InstMap[LD] = "ld";
	InstMap[ST] = "st";
	FunctMap[FADD_F] = "fadd";
	FunctMap[FSUB_F] = "fsub";
	FunctMap[FMUL_F] = "fmul";
	FunctMap[FDIV_F] = "fdiv";
	FunctMap[FSQRT_F] = "fsqrt";
	FunctMap[FMOV_F] = "fmov";
	FunctMap[FNEG_F] = "fneg";
	InstMap[FJEQ] = "fjeq";
	InstMap[FJLT] = "fjlt";
	InstMap[FLD] = "fld";
	InstMap[FST] = "fst";

	FunctMap[ADD_F] = "add";
	FunctMap[SUB_F] = "sub";
	FunctMap[MUL_F] = "mul";
	FunctMap[DIV_F] = "div";
	FunctMap[AND_F] = "and";
	FunctMap[OR_F] = "or";
	FunctMap[SLL_F] = "sll";
	FunctMap[SRL_F] = "srl";
	FunctMap[B_F] = "b";
	FunctMap[CALLR_F] = "callR";
	FunctMap[HALT_F] = "halt";

	InstMap[SIN] = "sin";
	InstMap[COS] = "cos";
	InstMap[ATAN] = "atan";
	InstMap[SQRT] = "sqrt";
	InstMap[I_OF_F] = "int_of_float";
	InstMap[F_OF_I] = "float_of_int";
// 0 = R, 1 = I, 2 = J;
	FunctTyMap[NOP_F] = "f";		//
	FunctTyMap[MOV_F] = "fgg";		//
	InstTyMap[MVHI] = "fgi";		//
	InstTyMap[MVLO] = "fgi";		//
	FunctTyMap[ADD_F] = "fggg";		//
	FunctTyMap[SUB_F] = "fggg";		//
	FunctTyMap[MUL_F] = "fggg";		//
	FunctTyMap[DIV_F] = "fggg";		//
	InstTyMap[ADDI] = "fggi";		//
	InstTyMap[SUBI] = "fggi";		//
	InstTyMap[MULI] = "fggi";		//
	InstTyMap[DIVI] = "fggi";		//
	FunctTyMap[INPUT_F] = "fg";		//
	FunctTyMap[OUTPUT_F] = "fg";		//
	FunctTyMap[AND_F] = "fggg";		//
	FunctTyMap[OR_F] = "fggg";		//
	FunctTyMap[NOT_F] = "fgg";		//
	FunctTyMap[SLL_F] = "fggg"; //
	FunctTyMap[SRL_F] = "fggg"; //
	InstTyMap[SLLI] = "fggi";	//
	FunctTyMap[B_F] = "fg";		//
	InstTyMap[JMP] = "fl";		//
	InstTyMap[JEQ] = "fggl";	//
	InstTyMap[JNE] = "fggl";	//
	InstTyMap[JLT] = "fggl";	//
	InstTyMap[JLE] = "fggl";	//
	InstTyMap[CALL] = "fl";		//
	FunctTyMap[CALLR_F] = "fg";		//
	InstTyMap[RETURN] = "f";		//
	InstTyMap[LD] = "fggi";		//
	InstTyMap[ST] = "fggi";		//
	FunctTyMap[FADD_F] = "ffff"; //
	FunctTyMap[FSUB_F] = "ffff"; //
	FunctTyMap[FMUL_F] = "ffff"; //
	FunctTyMap[FDIV_F] = "ffff"; //
	FunctTyMap[FSQRT_F] = "fff";
	FunctTyMap[FMOV_F] = "fff";	//
	FunctTyMap[FNEG_F] = "fff";	//
	InstTyMap[FJEQ] = "fffl";	//
	InstTyMap[FJLT] = "fffl";	//
	InstTyMap[FLD] = "ffgi";
	InstTyMap[FST] = "ffgi";
	FunctTyMap[HALT_F] = "f";		//
	InstTyMap[SPECIAL] = "special";
	InstTyMap[FPI] = "fpi";
	InstTyMap[IO] = "io";

	InstTyMap[SIN] = "else";
	InstTyMap[COS] = "else";
	InstTyMap[ATAN] = "else";
	InstTyMap[SQRT] = "else";
	InstTyMap[I_OF_F] = "else";
	InstTyMap[F_OF_I] = "else";
}
