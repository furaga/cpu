#include "sim.h"
const char *InstMap[INST_NUM];
const char *InstTyMap[INST_NUM];
const char *FunctMap[INST_NUM];
const char *FunctTyMap[INST_NUM];

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
