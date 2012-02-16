#include "sim.h"
const char *InstMap[INST_NUM] = {
"    ",  "    ","jmp", "    ","    ","    ","sin", "mvlo",
"addi",  "    ","jeq", "    ","    ","    ","cos", "mvhi",
"subi",  "    ","jne", "ld",  "    ","    ","atan","    ",
"muli",  "    ","jlt", "st",  "    ","    ","int_of_float","    ",
"divi",  "    ","jle", "ldi", "    ","    ","float_of_int","    ",
"slli",  "    ","srli","sti", "    ","    ","    ","    ",
"call",  "fldi", "fjeq","ldlr","    ","io","    ","    ",
"return","fsti", "fjlt","stlr","special","link","fpi","others",
};
const char *InstTyMap[INST_NUM] = {
"    ","    ","fl",  "    ","    ","    ","else", "fgi",
"fggi","    ","fggl","    ","    ","    ","else", "fgi",
"fggi","    ","fggl","fggg","    ","    ","else","    ",
"fggi","    ","fggl","fggg","    ","    ","else","    ",
"fggi","    ","fggl","fggi","    ","    ","else","    ",
"fggi","    ","fggi","fggi","    ","    ","    ","    ",
"fl",  "ffgi","fffl","fgi", "    ","io","    ","    ",
"f",   "ffgi","fffl","fgi", "special","fi","fpi","others",
};
const char *SFunctMap[INST_NUM] = {
"sll",   "    ","srl", "    ", "    ","    ","    ", "   ",
"b",     "    ","    ","    ", "    ","    ","    ", "   ",
"btmplr","    ","    ","    ", "    ","    ","    ","    ",
"mul",   "    ","    ","nor",  "    ","    ","    ","    ",
"add",   "    ","sub", "",   "and", "or",  "    ","    ",
"",      "    ","    ","",   "    ","    ","    ","    ",
"callR", "fld","","movlr","    ","    ","    ","    ",
"    ",  "fst","","", "    ","    ","    ","halt",
};
const char *SFunctTyMap[INST_NUM] = {
"fggg","    ","fggg","    ","    ","    ","    ","   ",
"fg",  "    ","    ","    ","    ","    ","    ","   ",
"f",   "    ","    ","    ","    ","    ","    ","    ",
"fggg","    ","fggg","fggg","    ","    ","    ","    ",
"fggg","    ","fggg","","fggg","fggg","    ","    ",
"",    "    ","    ","","    ","    ","    ","    ",
"fg",  "ffgg","    ","f",   "    ","    ","    ","    ",
"    ","ffgg","    ","",   "    ","    ","    ","f",
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

