#include "sim.h"
const char *InstMap[INST_NUM] = {
"    ",  "    ","jmp", "    ","    ","    ","sin", "mvlo",
"addi",  "    ","jeq", "    ","    ","    ","cos", "mvhi",
"subi",  "    ","jne", "    ","    ","    ","atan","    ",
"muli",  "    ","jlt", "    ","    ","    ","int_of_float","    ",
"divi",  "    ","jle", "ldi", "    ","    ","float_of_int","    ",
"slli",  "    ","srli","sti", "    ","    ","    ","    ",
"call",  "fld", "fjeq","ldlr","    ","    ","    ","    ",
"return","fst", "fjlt","stlr","special","io","fpi","others",
};
const char *InstTyMap[INST_NUM] = {
"    ","    ","fl",  "    ","    ","    ","else", "fgi",
"fggi","    ","fggl","    ","    ","    ","else", "fgi",
"fggi","    ","fggl","    ","    ","    ","else","    ",
"fggi","    ","fggl","    ","    ","    ","else","    ",
"fggi","    ","fggl","fggi","    ","    ","else","    ",
"fggi","    ","fggi","fggi","    ","    ","    ","    ",
"fl",  "ffgi","fffl","fgi", "    ","    ","    ","    ",
"f",   "ffgi","fffl","fgi", "special","io","fpi","others",
};
const char *SFunctMap[INST_NUM] = {
"sll",   "    ","srl", "    ", "    ","    ","    ", "   ",
"b",     "    ","    ","    ", "    ","    ","    ", "   ",
"btmplr","    ","    ","    ", "    ","    ","    ","    ",
"mul",   "    ","    ","nor",  "    ","    ","    ","    ",
"add",   "    ","sub", "ld",   "and", "or",  "    ","    ",
"",      "    ","    ","st",   "    ","    ","    ","    ",
"callR", "    ","    ","movlr","    ","    ","    ","    ",
"    ",  "    ","    ","link", "    ","    ","    ","halt",
};
const char *SFunctTyMap[INST_NUM] = {
"fggg","    ","fggg","    ","    ","    ","    ","   ",
"fg",  "    ","    ","    ","    ","    ","    ","   ",
"f",   "    ","    ","    ","    ","    ","    ","    ",
"fggg","    ","fggg","fggg","    ","    ","    ","    ",
"fggg","    ","fggg","fggg","fggg","fggg","    ","    ",
"",    "    ","    ","fggg","    ","    ","    ","    ",
"fg",  "    ","    ","f",   "    ","    ","    ","    ",
"    ","    ","    ","f",   "    ","    ","    ","f",
};
const char *FFunctMap[INST_NUM] = {
"fadd","fsub","fmul","fdiv","fsqrt","fabs","fmov","fneg",
};
const char *FFunctTyMap[INST_NUM] = {
"ffff","ffff","ffff","ffff","fff","fff","fff","fff",
};
const char *IOFunctMap[INST_NUM] = {
"input","output",
};
const char *IOFunctTyMap[INST_NUM] = {
"fg","fg",
};

