
#ifndef _SIM_HEAD
#define _SIM_HEAD
#include "common.h"
#include <stdint.h>
extern uint32_t prom[ROM_NUM];
extern uint32_t ram[RAM_NUM];
extern int32_t reg[REG_NUM];
extern uint32_t freg[REG_NUM];
extern uint32_t pc;
//extern uint32_t ir;
extern int32_t lr;
extern uint64_t cnt;

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
extern const char *SFunctMap[INST_NUM];
extern const char *FFunctMap[INST_NUM];
extern const char *IOFunctMap[INST_NUM];

void analyse(uint32_t);
void print_analysis(FILE*);
extern FILE* err_fp;
#define warning(fmt, ...) \
	fprintf(err_fp, fmt, ##__VA_ARGS__)
#define warning_nl() warning("\n")

void _print_ir(uint32_t,FILE*);
#define print_ir(x) _print_ir(x, err_fp)

inline uint32_t eff_dig(int dig, uint32_t num);
inline uint32_t sra_eff(int rsw, int dig, uint32_t num);

#define fmthex "%08x"
#define fmtidx "%d"
#define fmtimm "imm=%d"
#define fmtlabel "label=%d"
#define fmtdec "%d"
#define fmtinst "%s "
#define print_fmt_i fmtinst
#define print_fmt_if fmtinst"f"fmtidx"="fmthex
#define print_fmt_ig fmtinst"g"fmtidx"="fmtdec
#define print_fmt_ii fmtinst""fmtimm
#define print_fmt_il fmtinst""fmtlabel
#define print_fmt_iff fmtinst"f"fmtidx"="fmthex", f"fmtidx"="fmthex
#define print_fmt_ifg fmtinst"f"fmtidx"="fmthex", g"fmtidx"="fmtdec
#define print_fmt_igf fmtinst"g"fmtidx"="fmtdec", f"fmtidx"="fmthex
#define print_fmt_igg fmtinst"g"fmtidx"="fmtdec", g"fmtidx"="fmtdec
#define print_fmt_igi fmtinst"g"fmtidx"="fmtdec", "fmtimm
#define print_fmt_igl fmtinst"g"fmtidx"="fmtdec", "fmtlabel
#define print_fmt_ifff \
fmtinst"f"fmtidx"="fmthex", f"fmtidx"="fmthex", f"fmtidx"="fmthex
#define print_fmt_iffl \
fmtinst"f"fmtidx"="fmthex", f"fmtidx"="fmthex", "fmtlabel
#define print_fmt_ifgg \
fmtinst"f"fmtidx"="fmthex", g"fmtidx"="fmtdec", g"fmtidx"="fmtdec
#define print_fmt_ifgi \
fmtinst"f"fmtidx"="fmthex", g"fmtidx"="fmtdec", "fmtimm
#define print_fmt_iggg \
fmtinst"g"fmtidx"="fmtdec", g"fmtidx"="fmtdec", g"fmtidx"="fmtdec
#define print_fmt_iggi \
fmtinst"g"fmtidx"="fmtdec", g"fmtidx"="fmtdec", "fmtimm
#define print_fmt_iggl \
fmtinst"g"fmtidx"="fmtdec", g"fmtidx"="fmtdec", "fmtlabel
extern FILE* log_fp;
#endif
