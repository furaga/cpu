
#ifndef _COMMON_HEAD
#define _COMMON_HEAD
#define INST_NUM 64	// 6bit 63
#define REG_NUM 32
#define ROM_NUM (64 * 1024) // words(32bit)
#define RAM_NUM (256 * 1024)

////////////////////////////////////////////////////////////////////////
// SPECIAL funct
////////////////////////////////////////////////////////////////////////
#define SPECIAL 000
//ADD,SUB,MUL,DIV,SLL,SRL,B,CALLR,AND,OR,HALT
#define SLL_F 000
#define SRL_F 002
#define B_F 010
#define BTMPLR_F 020
#define MUL_F 030
#define NOR_F 033
#define ADD_F 040
#define SUB_F 042
#define MOVLR_F 063
#define AND_F 044
#define OR_F 045
#define PADD_F 050
#define CALLR_F 060
#define FLD_F 061
#define FST_F 071
#define HALT_F 077
////////////////////////////////////////////////////////////////////////
// I/O-Inst
////////////////////////////////////////////////////////////////////////
#define IO 001
//INPUT OUTPUT
#define INPUT_F 000
#define INPUTW_F 010
#define INPUTF_F 020
#define OUTPUT_F 001
#define OUTPUTW_F 011
#define OUTPUTF_F 021
////////////////////////////////////////////////////////////////////////
// FP-Inst funct
////////////////////////////////////////////////////////////////////////
#define FPI 021
//FADD FSUB FMUL FDIV FSQRT FMOV FNEG
#define FADD_F 000
#define FSUB_F 001
#define FMUL_F 002
#define FDIV_F 003
#define FSQRT_F 004
#define FABS_F 005
#define FMOV_F 006
#define FNEG_F 007
////////////////////////////////////////////////////////////////////////
// Others
////////////////////////////////////////////////////////////////////////
#define PADD 003
#define ADDI 010
#define SUBI 020
#define MULI 030
#define SLLI 050
#define CALL 060
#define RETURN 070
#define LD 023
#define ST 033
#define LDI 043
#define STI 053
#define LDLR 063
#define STLR 073
#define JMP 002
#define JEQ 012
#define JNE 022
#define JLT 032
#define JLE 042
#define SRLI 052
#define FJEQ 062
#define FJLT 072
#define MVLO 007
#define MVHI 017
#define FLDI 061
#define FSTI 071
#define LINK 075

#define SETL 077

#endif
