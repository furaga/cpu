
#ifndef _SIM_HEAD
#define _SIM_HEAD
#include "common.h"
#include <stdio.h>
#include <stdint.h>
extern uint32_t prom[ROM_NUM];
extern uint32_t ram[RAM_NUM];
extern int32_t reg[REG_NUM];
extern uint32_t freg[REG_NUM];
extern uint32_t pc;
extern uint32_t ir;
extern int32_t lr;
extern uint64_t cnt;

extern inline int32_t get_imm(uint32_t);

#define get_opcode(ir) ((uint32_t)(((ir)>>26)&0x3f))
#define get_rsi(ir) ((uint32_t)(((ir)>>21)&0x1f))
#define get_rti(ir) ((uint32_t)(((ir)>>16)&0x1f))
#define get_rdi(ir) ((uint32_t)(((ir)>>11)&0x1f))
#define get_shamt(ir) ((uint32_t)(((ir)>>6)&0x1f))
#define get_funct(ir) ((uint32_t)((ir)&0x3f))
#define get_target(ir) ((uint32_t)((ir)&0x3ffffff))
#define get_imm(ir) \
	((int32_t) (ir&(1<<15)) ? ((0xffff<<16)|(ir&0xffff)):\
	(ir&0xffff))

////////////////////////////////////////////////////////////////////////
// register access
////////////////////////////////////////////////////////////////////////
#define _GRS reg[get_rsi(ir)]
#define _GRT reg[get_rti(ir)]
#define _GRD reg[get_rdi(ir)]
#define _FRS freg[get_rsi(ir)]
#define _FRT freg[get_rti(ir)]
#define _FRD freg[get_rdi(ir)]
#define _IMM get_imm(ir)
////////////////////////////////////////////////////////////////////////


extern const char *InstMap[INST_NUM];
extern const char *InstTyMap[INST_NUM];
extern const char *SFunctMap[INST_NUM];
extern const char *SFunctTyMap[INST_NUM];
extern const char *FFunctMap[INST_NUM];
extern const char *FFunctTyMap[INST_NUM];
extern const char *IOFunctMap[INST_NUM];
extern const char *IOFunctTyMap[INST_NUM];

int statistics(FILE*, int);
extern FILE* err_fp;
#define warning(fmt, ...) \
	fprintf(err_fp, fmt, ##__VA_ARGS__)
void _print_ir(uint32_t,FILE*);
#define print_ir(x) _print_ir(x, err_fp)

inline uint32_t eff_dig(int dig, uint32_t num);
inline uint32_t sra_eff(int rsw, int dig, uint32_t num);
#endif
