
#ifndef _SIM_HEAD
#define _SIM_HEAD
#include "common.h"
#include <stdio.h>
#define SIM_LOG "simlog"
extern int32_t reg[REG_NUM];
extern uint32_t freg[REG_NUM];
extern uint32_t rom[ROM_NUM];
extern uint32_t ram[RAM_NUM];
extern uint32_t pc;
extern uint32_t lr, tmplr;
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
void print_ir(uint32_t,FILE*);
#define print_state() __print_state(0,0,NULL)
#define print_init(argc,argv) __print_state(1,argc,argv)

void debug(void);
void debug_usage(void);

#define IF0_BREAK_S	if (get_rsi(ir) == 0) { break; }
#define IF0_BREAK_T	if (get_rti(ir) == 0) { break; }
#define IF0_BREAK_D	if (get_rdi(ir) == 0) { break; }
extern const char *InstMap[INST_NUM];
extern const char *InstTyMap[INST_NUM];
extern const char *SFunctMap[INST_NUM];
extern const char *SFunctTyMap[INST_NUM];
extern const char *FFunctMap[INST_NUM];
extern const char *FFunctTyMap[INST_NUM];
extern const char *IOFunctMap[INST_NUM];
extern const char *IOFunctTyMap[INST_NUM];
int statistics(FILE*, int);
int operate(uint32_t);
int op_stat(char);

uint32_t _finv(uint32_t);
uint32_t _fsqrt(uint32_t);

#endif
