
#ifndef _COMMON_HEAD
#define _COMMON_HEAD
#include <stdint.h>
#define INST_NUM 64	// 6bit 63
#define REG_NUM 32
#define ROM_NUM (4 * 1024 * 1024)
#define RAM_NUM (4 * 1024 * 1024)

///////////////////////////////////////
// SPECIAL funct //////////////////////
///////////////////////////////////////
#define SPECIAL 000
//ADD,SUB,MUL,DIV,SLL,SRL,B,CALLR,AND,OR,HALT
#define SLL_F 000
#define SRL_F 002
#define B_F 010
#define MUL_F 030
#define DIV_F 032	////////////////////////
#define NOR_F 033
#define ADD_F 040
#define SUB_F 042
#define AND_F 044
#define OR_F 045
#define CALLR_F 060
#define HALT_F 077
//////////////////////////////////////
// I/O-Inst ///////////////////////
//////////////////////////////////////
#define IO 001
//INPUT OUTPUT
#define INPUT_F 000
#define OUTPUT_F 001
///////////////////////////////////////
// FP-Inst funct //////////////////////
///////////////////////////////////////
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
///////////////////////////////////////
// Others /////////////////////////////
///////////////////////////////////////
#define ADDI 010
#define SUBI 020
#define MULI 030
#define DIVI 040	////////////////////////
#define SLLI 050
#define CALL 060
#define RETURN 070
#define LD 043
#define ST 053
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
#define FLD 061
#define FST 071
//////////////////////////////////////
// Pseudo-Inst ///////////////////////
//////////////////////////////////////
#define SETL 005
#define NOP_F 000	// SLL_F
#define MOV_F 040	// ADD_F
#define NOT_F 033	// NOR_F
//////////////////////////////////////
// Library ///////////////////////////
//////////////////////////////////////
#define SIN 006
#define COS 016
#define ATAN 026
#define I_OF_F 036
#define F_OF_I 046
#define SQRT 056
#endif
