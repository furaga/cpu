#include <stdio.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include "setup.h"


int32_t reg[REG_NUM];
uint32_t freg[REG_NUM];
uint32_t rom[MEM_NUM];
uint32_t ram[MEM_NUM];
void IMapInit(void);
extern const char *InstMap[];
extern int InstTyMap[];

DEF_ELE_ACC(opcode, 26, 0x3f);
DEF_ELE_ACC(regs, 21, 0x1f);
DEF_ELE_ACC(regt, 16, 0x1f);
DEF_ELE_ACC(regd, 11, 0x1f);
DEF_ELE_ACC(shamt, 6, 0x1f);
DEF_ELE_ACC(funct, 0, 0x3f);
DEF_ELE_ACC(imm, 0, 0xffff);
DEF_ELE_ACC(target, 0, 0x3ffffff);

#define _RS reg[regs(ir)]
#define _RD reg[regd(ir)]
#define _RT reg[regt(ir)]
#define _IMM imm(ir)


// rom の命令実行列(バイナリ)に従いシミュレートする
int main(int argc, char **argv)
{ 
	using namespace std;
	uint32_t pc, ir, lr, flag_eq, cnt, heap_size;
	int fd,ret,i;
	char *sfile = "o.out";

	if (argc >= 2) {
		sfile = argv[1];
	}

	fd = open(sfile, O_RDONLY);
	if (fd < 0) {
		printf("%s: No such file\n", sfile);
		return 1;
	}
	ret = read(fd, rom, MEM_NUM*4);

	pc = 0;
	flag_eq = 0;
	lr = 0;
	cnt = 0;
	reg[1] = reg[31] = MEM_NUM;

	puts("heap allocate");
	heap_size = rom[0]; 
	pc++;
	for (i = 0; heap_size > 0; i++,pc++) {
		ram[i] = rom[pc];
		heap_size -= 32;
	}

	printf("simulate %s\n", sfile);
	do{
		ir = rom[pc];

		cnt++;
		pc++;
		switch(opcode(ir)){
			case MOV: 
				_RD = _RS;
				break;
			case MVHI: 
				_RT = ((uint32_t) _IMM << 16) | (_RT & 0xffff);
				break;
			case MVLO: 
				_RT = (_RT & 0xffff0000) | _IMM;
				break;
			case ADD: 
				_RD = _RS + _RT;
				break;
			case SUB:
				_RD = _RS - _RT;
				break;
			case MUL:
				_RD = _RS * _RT;
				break;
			case DIV:
				_RD = _RS / _RT;
				break;
			case ADDI:
				_RT = _RS + _IMM;
				break;
			case SUBI:
				_RT = _RS - _IMM;
				break;
			case MULI:
				_RT = _RS * _IMM;
				break;
			case DIVI:
				_RT = _RS / _IMM;
				break;
			case INPUT:
				break;
			case OUTPUT:
				printf("cnt:%d output:%d\n", cnt, _RS);
				break;
			case AND:
				_RD = _RS & _RT;
				break;
			case OR:
				_RD = _RS | _RT;
				break;
			case NOT:
				_RD = ~_RS;
				break;
			case SLL:
				_RD = _RS << _RT;
				break;
			case SRL:
				_RD = _RS >> _RT;
				break;
			case SLLI:
				_RT = _RS << _IMM;
				break;
			case B:
				pc = _RS;
				break;
			case JMP:
				pc = imm(ir);
				break;
			case JEQ:
				if (_RS == _RT)
					pc += _IMM;
				break;
			case JNE:
				if (_RS != _RT)
					pc += _IMM;
				break;
			case JLT:
				if (_RS < _RT)
					pc += (short int)_IMM;
				break;
			case CALL:
				ram[reg[1]] = lr;
				reg[1] -= 4;
				lr = pc;
				pc = _IMM;
				break;
			case RETURN:
				pc = lr;
				reg[1] += 4;
				lr = ram[reg[1]];
				break;
			case FLD:
				freg[regs(ir)] = ram[(_RT - _IMM)/4];
				break;
			case FST:
				ram[(_RT - _IMM)/4] = freg[regs(ir)];
				break;
			case LD:
				_RS = ram[(_RT - _IMM)/4];
				break;
			case ST:
				ram[(_RT - _IMM)/4] = _RS;
				break;
			case FADD:
				_RD = _RS + _RT;
				break;
			case FSUB:
				_RD = _RS - _RT;
				break;
			case FMUL:
				_RD = _RS * _RT;
				break;
			case FDIV:
				_RD = _RS / _RT;
				break;
			case NOP:
				break;
			case HALT:
				break;
			default	:	break;
		}
	} while(opcode(ir) != HALT);

	printf("\nCPU Simulator Results\n");

	return 0;
} 
