#include "sim.h"
const char *InstMap[INST_NUM];
const char *InstTyMap[INST_NUM];
const char *FunctMap[18][INST_NUM];
const char *FunctTyMap[18][INST_NUM];

void IMapInit(void) {
	FunctMap[SPECIAL][NOP_F] = "nop";
	FunctMap[SPECIAL][MOV_F] = "mov";
	InstMap[MVHI] = "mvhi";
	InstMap[MVLO] = "mvlo";

	InstMap[ADDI] = "addi";
	InstMap[SUBI] = "subi";
	InstMap[MULI] = "muli";
	InstMap[DIVI] = "divi";
	FunctMap[IO][INPUT_F] = "input";
	FunctMap[IO][OUTPUT_F] = "output";
	FunctMap[SPECIAL][NOT_F] = "not";
	InstMap[SLLI] = "slli";
	InstMap[SRLI] = "srli";
	InstMap[JMP] = "jmp";
	InstMap[JEQ] = "jeq";
	InstMap[JNE] = "jne";
	InstMap[JLT] = "jlt";
	InstMap[JLE] = "jle";
	InstMap[CALL] = "call";
	InstMap[RETURN] = "return";
	InstMap[LD] = "ld";
	InstMap[ST] = "st";
	FunctMap[FPI][FADD_F] = "fadd";
	FunctMap[FPI][FSUB_F] = "fsub";
	FunctMap[FPI][FMUL_F] = "fmul";
	FunctMap[FPI][FDIV_F] = "fdiv";
	FunctMap[FPI][FSQRT_F] = "fsqrt";
	FunctMap[FPI][FABS_F] = "fmov";
	FunctMap[FPI][FMOV_F] = "fmov";
	FunctMap[FPI][FNEG_F] = "fneg";
	InstMap[FJEQ] = "fjeq";
	InstMap[FJLT] = "fjlt";
	InstMap[FLD] = "fld";
	InstMap[FST] = "fst";

	FunctMap[SPECIAL][ADD_F] = "add";
	FunctMap[SPECIAL][SUB_F] = "sub";
	FunctMap[SPECIAL][MUL_F] = "mul";
	FunctMap[SPECIAL][DIV_F] = "div";
	FunctMap[SPECIAL][AND_F] = "and";
	FunctMap[SPECIAL][OR_F] = "or";
	FunctMap[SPECIAL][SLL_F] = "sll";
	FunctMap[SPECIAL][SRL_F] = "srl";
	FunctMap[SPECIAL][B_F] = "b";
	FunctMap[SPECIAL][CALLR_F] = "callR";
	FunctMap[SPECIAL][HALT_F] = "halt";

	InstMap[SIN] = "sin";
	InstMap[COS] = "cos";
	InstMap[ATAN] = "atan";
	InstMap[SQRT] = "sqrt";
	InstMap[I_OF_F] = "int_of_float";
	InstMap[F_OF_I] = "float_of_int";
	InstMap[074] = "special";
	InstMap[075] = "io";
	InstMap[076] = "fpi";
	InstMap[077] = "others";
// 0 = R, 1 = I, 2 = J;
	FunctTyMap[SPECIAL][NOP_F] = "f";		//
	FunctTyMap[SPECIAL][MOV_F] = "fgg";		//
	InstTyMap[MVHI] = "fgi";		//
	InstTyMap[MVLO] = "fgi";		//
	FunctTyMap[SPECIAL][ADD_F] = "fggg";		//
	FunctTyMap[SPECIAL][SUB_F] = "fggg";		//
	FunctTyMap[SPECIAL][MUL_F] = "fggg";		//
	FunctTyMap[SPECIAL][DIV_F] = "fggg";		//
	InstTyMap[ADDI] = "fggi";		//
	InstTyMap[SUBI] = "fggi";		//
	InstTyMap[MULI] = "fggi";		//
	InstTyMap[DIVI] = "fggi";		//
	FunctTyMap[IO][INPUT_F] = "fg";		//
	FunctTyMap[IO][OUTPUT_F] = "fg";		//
	FunctTyMap[SPECIAL][AND_F] = "fggg";		//
	FunctTyMap[SPECIAL][OR_F] = "fggg";		//
	FunctTyMap[SPECIAL][NOT_F] = "fgg";		//
	FunctTyMap[SPECIAL][SLL_F] = "fggg"; //
	FunctTyMap[SPECIAL][SRL_F] = "fggg"; //
	InstTyMap[SLLI] = "fggi";	//
	InstTyMap[SRLI] = "fggi";	//
	FunctTyMap[SPECIAL][B_F] = "fg";		//
	InstTyMap[JMP] = "fl";		//
	InstTyMap[JEQ] = "fggl";	//
	InstTyMap[JNE] = "fggl";	//
	InstTyMap[JLT] = "fggl";	//
	InstTyMap[JLE] = "fggl";	//
	InstTyMap[CALL] = "fl";		//
	FunctTyMap[SPECIAL][CALLR_F] = "fg";		//
	InstTyMap[RETURN] = "f";		//
	InstTyMap[LD] = "fggi";		//
	InstTyMap[ST] = "fggi";		//
	FunctTyMap[FPI][FADD_F] = "ffff"; //
	FunctTyMap[FPI][FSUB_F] = "ffff"; //
	FunctTyMap[FPI][FMUL_F] = "ffff"; //
	FunctTyMap[FPI][FDIV_F] = "ffff"; //
	FunctTyMap[FPI][FSQRT_F] = "fff";
	FunctTyMap[FPI][FABS_F] = "fff";	//
	FunctTyMap[FPI][FMOV_F] = "fff";	//
	FunctTyMap[FPI][FNEG_F] = "fff";	//
	InstTyMap[FJEQ] = "fffl";	//
	InstTyMap[FJLT] = "fffl";	//
	InstTyMap[FLD] = "ffgi";
	InstTyMap[FST] = "ffgi";
	FunctTyMap[SPECIAL][HALT_F] = "f";		//
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
