#include "simulate.h"

#define	MOV	0
#define	ADD	1
#define	SUB	2
#define	AND	3
#define	OR	4
#define	SL	5
#define	SR	6
#define	SRA	7
#define	LDL	8
#define	LDH	9
#define	CMP	10
#define	JE	11
#define	JMP	12
#define	LD	13
#define	ST	14
#define	HLT	15

/* Registers */

#define	REG0	0
#define	REG1	1
#define	REG2	2
#define	REG3	3
#define	REG4	4
#define	REG5	5
#define	REG6	6
#define	REG7	7

short	reg[8];
unsigned short	rom[256];
unsigned short	ram[256];
　	
void	program(void);
　	
unsigned short	mov(unsigned char ra, unsigned char rb);
unsigned short	add(unsigned char ra, unsigned char rb);
unsigned short	sub(unsigned char ra, unsigned char rb);
unsigned short	and(unsigned char ra, unsigned char rb);
unsigned short	or(unsigned char ra, unsigned char rb);
unsigned short	sl(unsigned char ra);
unsigned short	sr(unsigned char ra);
unsigned short	sra(unsigned char ra);
unsigned short	ldl(unsigned char ra, unsigned char data);
unsigned short	ldh(unsigned char ra, unsigned char data);
unsigned short	cmp(unsigned char ra, unsigned char rb);
unsigned short	je(unsigned char addr);
unsigned short	jmp(unsigned char addr);
unsigned short	ld(unsigned char ra, unsigned char addr);
unsigned short	st(unsigned char ra, unsigned char addr);
unsigned short	hlt(void);
unsigned short	opcode(unsigned short ir);
unsigned short	nRegA(unsigned short ir);
unsigned short	nRegB(unsigned short ir);
unsigned short	op_data(unsigned short ir);
unsigned short	op_addr(unsigned short ir);
void main( void )
{ 
// Registers and Flag

unsigned short	pc;	// Program Counter
unsigned short	ir;	// Instruction Register
unsigned short	flag_eq;	// Flag for Compare

// Programming

program();

// Boot of Processor

pc = 0;
flag_eq = 0;
do{
ir = rom[pc];
printf("PC:%3d IR:%4x REG0:%3d REG1:%3d REG2:%3d REG3:%3d\n"
　　　　　　, pc, ir, reg[0], reg[1], reg[2], reg[3]);
pc++;
// 　getchar();
// Decode and Execute

　　　　　　　switch(opcode(ir)){

case MOV
　	:
　	reg[nRegA(ir)] = reg[nRegB(ir)];
break;
case ADD
　	:

reg[nRegA(ir)] = reg[nRegA(ir)] + reg[nRegB(ir)];
break;
case SUB
　	:

reg[nRegA(ir)] = reg[nRegA(ir)] - reg[nRegB(ir)];
break;
case AND
　	:
　	reg[nRegA(ir)] = reg[nRegA(ir)] & reg[nRegB(ir)];
break;
case OR
　	:
　	reg[nRegA(ir)] = reg[nRegA(ir)] | reg[nRegB(ir)];
break;
case SL
　	:
　	reg[nRegA(ir)] = reg[nRegA(ir)] << 1;
break;
case SR
　	:
　	reg[nRegA(ir)] = reg[nRegA(ir)] >> 1;
break;
case SRA
　	:
　	reg[nRegA(ir)] = (reg[nRegA(ir)] & 0x8000) | (reg[nRegA(ir)] >> 1);
break;
case LDL
　	:
　	reg[nRegA(ir)] = (reg[nRegA(ir)] & 0xff00) | (op_data(ir) & 0x00ff);
break;
case LDH
　	:
　	reg[nRegA(ir)] = (op_data(ir) << 8) | (reg[nRegA(ir)] & 0x00ff);
break;
case CMP
　
　	:
　
　	if(reg[nRegA(ir)] == reg[nRegB(ir)]) flag_eq = 1;
else flag_eq = 0;
break;
case JE
　	:
　	if(flag_eq == 1) pc = op_addr(ir);
break;
case JMP
　	:
　	pc = op_addr(ir);
break;
case LD

:
　	reg[nRegA(ir)] = ram[op_addr(ir)];
break;
case ST
　	:
　	ram[op_addr(ir)] = reg[nRegA(ir)];
break;
default	:	break;
}
}while(opcode(ir) != HLT);
// Output (Memory Mapped I/O)

printf("\n");
printf("CPU Simulator Results\n");
printf("ram[64] = %d\n", ram[64]);
getchar();
} 


// Data of Program ROM
// Exam1: 1 + 2 + ... + 10 = 55

void program(void)
{

rom[0]	=	ldl(REG0, 0);	// Reg0 <- 0
rom[1]	=	ldl(REG1, 1);	// Reg1 <- 1
rom[2]	=	ldl(REG2, 0);	// Reg2 <- 0
rom[3]	=	ldl(REG3, 10);	// Reg3 <- 10
rom[4]	=	add(REG2, REG1);	// Reg2 <- Reg2 + Reg1
rom[5]	=	add(REG0, REG2);	// Reg0 <- Reg0 + Reg2
rom[6]	=	cmp(REG2, REG3);	// Reg2 と Reg3(10)　の比較
rom[7]	=	je(9);	// 一致したら9番地にjump
rom[8]	=	jmp(4);	// 4番地にjump
rom[9]	=	st(REG0, 64);	// OUT(64) <- Reg0
rom[10]	=	hlt();	// hlt
}

unsigned short mov( unsigned char ra , unsigned char rb )
{
　　　return (MOV << 11) | (( unsigned short )ra << 8) | (( unsigned short )rb << 5); 
}

unsigned short add( unsigned char ra, unsigned char rb)
{
　　　return (ADD << 11) | (( unsigned short )ra << 8) | (( unsigned short )rb << 5); 
}

unsigned short sub( unsigned char ra, unsigned char rb)
{
　　　return (SUB << 11) | (( unsigned short )ra << 8) | (( unsigned short) rb << 5);
}

unsigned short and( unsigned char ra, unsigned char rb)
{
　　　return (AND << 11) | (( unsigned short )ra << 8) | (( unsigned short )rb << 5);
}

unsigned short or( unsigned char ra, unsigned char rb)
{
　　　return (OR << 11) | (( unsigned short )ra << 8) | (( unsigned short )rb << 5);
}

unsigned short sl( unsigned char ra)
{
　　　return (SL << 11) | (( unsigned short )ra << 8);
}

unsigned short sr( unsigned char ra)
{
　　　return (SR << 11) | (( unsigned short )ra << 8);
}

unsigned short sra( unsigned char ra)
{
　　　return (SRA << 11) | (( unsigned short )ra << 8);
}

unsigned short ldl( unsigned char ra, unsigned char data)
{
　　　return (LDL << 11) | (( unsigned short )ra << 8) | ( unsigned short )data;
}

unsigned short ldh( unsigned char ra, unsigned char data)
{
　　　return (LDH << 11) | (( unsigned short )ra << 8) | ( unsigned short )data;
}

unsigned short cmp(unsigned char ra, unsigned char rb)
{
　　　return (CMP << 11) | (( unsigned short )ra << 8) | (( unsigned short )rb << 5); }

unsigned short je( unsigned char addr)
{
　　　return (JE << 11) | ( unsigned short )addr;
}

unsigned short jmp( unsigned char addr)
{
　　　return (JMP << 11) | ( unsigned short )addr;
}

unsigned short ld( unsigned char ra, unsigned char addr)
{
　　　return (LD << 11) | (( unsigned short )ra << 8) | ( unsigned short )addr; 
}

unsigned short st( unsigned char ra, unsigned char addr)
{
　　　return (ST << 11) | (( unsigned short )ra << 8) | ( unsigned short )addr; 
}

unsigned short hlt( void )
{
　　　return ( unsigned short )(HLT << 11);
}

unsigned short opcode( unsigned short ir)
{
　　　return (ir >> 11); 
} 

unsigned short nRegA( unsigned short ir)
{
　　　return ((ir >> 8) & 0x0007); 
}

unsigned short nRegB( unsigned short ir)
{
　　　return ((ir >> 5) & 0x0007); 
}

unsigned short op_data( unsigned short ir)
{
　　　return (ir & 0x00ff); 
}

unsigned short op_addr( unsigned short ir)
{
　　　return (ir & 0x00ff);
} 


