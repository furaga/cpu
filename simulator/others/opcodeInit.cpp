#include <map>
#include <string>
#include <stdint.h>
#include "setup.h"

using namespace std;
map<string, uint32_t> opcode;

void opcodeInit(void) {
	opcode.insert(map<string,uint32_t>::value_type("mvhi", MVHI));
	opcode.insert(map<string,uint32_t>::value_type("mvlo", MVLO));
	opcode.insert(map<string,uint32_t>::value_type("add", ADD));
	opcode.insert(map<string,uint32_t>::value_type("sub", SUB));
	opcode.insert(map<string,uint32_t>::value_type("mul", MUL));
	opcode.insert(map<string,uint32_t>::value_type("div", DIV));
	opcode.insert(map<string,uint32_t>::value_type("addi", ADDI));
	opcode.insert(map<string,uint32_t>::value_type("subi", SUBI));
	opcode.insert(map<string,uint32_t>::value_type("muli", MULI));
	opcode.insert(map<string,uint32_t>::value_type("divi", DIVI));
	opcode.insert(map<string,uint32_t>::value_type("input", INPUT));
	opcode.insert(map<string,uint32_t>::value_type("output", OUTPUT));
	opcode.insert(map<string,uint32_t>::value_type("and", AND));
	opcode.insert(map<string,uint32_t>::value_type("or", OR));
	opcode.insert(map<string,uint32_t>::value_type("not", NOT));
	opcode.insert(map<string,uint32_t>::value_type("sll", SLL));
	opcode.insert(map<string,uint32_t>::value_type("slli", SLLI));
	opcode.insert(map<string,uint32_t>::value_type("srl", SRL));
	opcode.insert(map<string,uint32_t>::value_type("b", B));
	opcode.insert(map<string,uint32_t>::value_type("jmp", JMP));
	opcode.insert(map<string,uint32_t>::value_type("jeq", JEQ));
	opcode.insert(map<string,uint32_t>::value_type("jne", JNE));
	opcode.insert(map<string,uint32_t>::value_type("jlt", JLT));
	opcode.insert(map<string,uint32_t>::value_type("jle", JLE));
	opcode.insert(map<string,uint32_t>::value_type("call", CALL));
	opcode.insert(map<string,uint32_t>::value_type("return", RETURN));
	opcode.insert(map<string,uint32_t>::value_type("ld", LD));
	opcode.insert(map<string,uint32_t>::value_type("st", ST));
	opcode.insert(map<string,uint32_t>::value_type("fadd", FADD));
	opcode.insert(map<string,uint32_t>::value_type("fsub", FSUB));
	opcode.insert(map<string,uint32_t>::value_type("fmul", FMUL));
	opcode.insert(map<string,uint32_t>::value_type("fdiv", FDIV));
	opcode.insert(map<string,uint32_t>::value_type("fmov", FMOV));
	opcode.insert(map<string,uint32_t>::value_type("fneg", FNEG));
	opcode.insert(map<string,uint32_t>::value_type("fbeq", FBEQ));
	opcode.insert(map<string,uint32_t>::value_type("fblt", FBLT));
	opcode.insert(map<string,uint32_t>::value_type("fld", FLD));
	opcode.insert(map<string,uint32_t>::value_type("fst", FST));
	opcode.insert(map<string,uint32_t>::value_type("nop", NOP));
	opcode.insert(map<string,uint32_t>::value_type("halt", HALT));
	opcode.insert(map<string,uint32_t>::value_type("setl", SETL));
}
