
#ifndef _SIM_HEAD
#define _SIM_HEAD
#include "common.h"
#define SIM_LOG "simlog"
extern int32_t reg[REG_NUM];
extern uint32_t freg[REG_NUM];
extern uint32_t rom[ROM_NUM];
extern uint32_t ram[RAM_NUM];
extern uint32_t pc;
extern long long unsigned cnt;
#define PRT_ELE_GET(name) \
	uint32_t name(uint32_t);
#define DEF_ELE_GET(name, shift, mask) \
	uint32_t name(uint32_t ir) {\
		return ((ir >> shift) & mask);\
	}
PRT_ELE_GET(get_opcode);
PRT_ELE_GET(get_rsi);
PRT_ELE_GET(get_rti);
PRT_ELE_GET(get_rdi);
PRT_ELE_GET(get_shamt);
PRT_ELE_GET(get_funct);
PRT_ELE_GET(get_target);
int32_t get_imm(uint32_t);

//////////////////////////////////////////////
// register access ///////////////////////////
//////////////////////////////////////////////
#define _GRS reg[get_rsi(ir)]
#define _GRT reg[get_rti(ir)]
#define _GRD reg[get_rdi(ir)]
#define _FRS freg[get_rsi(ir)]
#define _FRT freg[get_rti(ir)]
#define _FRD freg[get_rdi(ir)]
#define _IMM get_imm(ir)
//////////////////////////////////////////////

int __print_state(int,int,char**);
#define print_state() __print_state(0,0,NULL)
#define print_init(argk,argv) __print_state(1,argc,argv)

#define IF0_BREAK_S	if (get_rsi(ir) == 0) { break; }
#define IF0_BREAK_T	if (get_rti(ir) == 0) { break; }
#define IF0_BREAK_D	if (get_rdi(ir) == 0) { break; }

#endif
