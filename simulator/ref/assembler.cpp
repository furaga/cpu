#include "setup.h"

#include	<stdio.h>
#include	<string.h>
#define	IN_FILENAME	"./source.asm"	
#define	OUT_FILENAME	"./rom_init.mif"	
#define	LINE_MAX	2048	// asmの一行の長さの最大値
/* OP Codes */ 

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

int	call_opcode(char *, char *);
int	encoder(int, char*);
　
int	main()	
{
　　　　　　　
FILE	*fp;	
char	buf[LINE_MAX];	
int	output_data[256];	// 出力データの保存領域
int	input_line_cnt;	// 入力側の行数をカウント
int	output_line_cnt;	// 出力側の行数をカウント
int	ir;	
int	label[256];	// ラベル情報の保存領域
int	label_num;	
int	i;	
char	opcode[256];
char	output_tmpstr[16];
int	err_cnt;
　
// 初期化
input_line_cnt = 0;
output_line_cnt = 0;
err_cnt = 0;
// ラベル用変数の初期化
for(i = 0; i < 256; i++)
label[i] = 0;	// ラベル用変数の初期化
// 出力用変数の初期化
for(i = 0; i < 255; i++)
output_data[i] = 0;	 // NOPを入れる
output_data[255] = (HLT << 11);	 // HLTを入れる
// ソースファイルのopen
fp = fopen(IN_FILENAME, "r");
if(fp == NULL){
printf("ファイルが開けませんでした。\n");
return -1;
}
printf("%sを読み込み中。\n", IN_FILENAME);
// 読み込み開始
while(fgets(buf, LINE_MAX, fp) != NULL){
if(sscanf(buf, "%s", opcode) == 1){　　　　// opcodeの取得
　	　	　	// opcodeにより処理を分ける。
　	　	　	if(opcode[0] == ':'){
　	　	　		// : (ラベル番号) ラベル行の場合
　	　	　		if(sscanf(buf, ":%d", &label_num) == 1){
　	　	　		　　　　　　label[label_num] = output_line_cnt;　　　　// 現在の出力側行数を代入
　	　	　		}else{　　　　// エラー処理
　	　	　		　　　　　　printf("%d 行目の\n%sが解析できませんでした。\n", input_line_cnt + 1, buf);
　	　	　		　　　　　　err_cnt++;
　	　	　		}
}else if(opcode[0] ==　'-'){
　	　	　		// --　コメントなので何もしない
　	　	　	}else{
　	　	　		// 命令行
　	　	　		// opcodeごとに変換
　	　	　		ir = call_opcode(opcode, buf);
　	　	　		if(ir < 0){　　　　　　　　　　　　　// エラー処理
　	　	　		　　　　printf("%d 行目の\n%sが解析できませんでした。\n", input_line_cnt + 1, buf);
　	　	　		　　　　err_cnt++;
　	　	　		}else{
　	　	　		　　　　output_data[output_line_cnt] = ir;
　	　	　		　　　　output_line_cnt++;
　	　	　		}
}
}
input_line_cnt++;
}
fclose(fp);
if(err_cnt != 0){
// エラーがある場合は終了
printf("コンパイルができませんでした(エラー %d個)\n", err_cnt);
return -1;
}else{
// エラーがない場合は書き込み開始
// ラベル情報の置き換え
for(i = 0; i < 256; i++){
if((output_data[i] & 0x7800 ) == (JE << 11)){ 　　　　　//　JE命令の場合
　　　　label_num = (output_data[i] & 0x7FF);
　　　　output_data[i] = (JE << 11) | label[label_num]; 　//ラベル番号をアドレスに置き換える
}
if((output_data[i] & 0x7800 ) == (JMP << 11)){ 　　　　　//JMP命令の場合
　　　　label_num = (output_data[i] & 0x7FF);
　　　　output_data[i] = (JMP << 11) | label[label_num]; //ラベル番号をアドレスに置き換える
}
}	
//書き込みファイルをopen
fp = fopen(OUT_FILENAME, "w");
if(fp == NULL){
　　　　　printf("書き込みファイルが開けませんでした。\n");
　　　　　return -1;
}
//mifファイルを出力
fprintf(fp, "DEPTH = 256;\nWIDTH = 15;\n");
fprintf(fp, "ADDRESS_RADIX = HEX;\nDATA_RADIX = BIN;\n");
fprintf(fp, "CONTENT\n\tBEGIN\n");
fprintf(fp, "[00..7F]\t:\t000000000000;\n");
for(i = 0; i < 256; i++){
encoder(output_data[i], output_tmpstr);
if(i < 16){
　　　　　　fprintf(fp, "\t0%X\t:\t%s;-- %X \n", i, output_tmpstr, output_data[i]);
}else{
　　　　　　fprintf(fp, "\t%X\t:\t%s;-- %X \n", i, output_tmpstr, output_data[i]);
}
}
fprintf(fp, "END;\n\n");
fclose(fp);
printf("コンパイルは正常に終了しました。\n");
printf("%sに書き出しました。\n", OUT_FILENAME);
return 0;
}
}	
int call_opcode(char *opcode, char *op_data)
{
int 　ra, rb, data, addr, label_num;
char tmp_str[256];
// opcodeごとに変換
if(strcmp(opcode, "mov") == 0){
if(sscanf(op_data, "%s r%d r%d", tmp_str, &ra, &rb) == 3)
　　　　return (MOV << 11) | (ra << 8) | (rb << 5);
}
if(strcmp(opcode, "add") == 0){
if(sscanf(op_data, "%s r%d r%d", tmp_str, &ra, &rb) == 3)
　　　　return (ADD << 11) | (ra << 8) | (rb << 5);
}
if(strcmp(opcode, "sub") == 0){
if(sscanf(op_data, "%s r%d r%d", tmp_str, &ra, &rb) == 3)
　　　　return (SUB << 11) | (ra << 8) | (rb << 5);
}
if(strcmp(opcode, "and") == 0){
if(sscanf(op_data, "%s r%d r%d", tmp_str, &ra, &rb) == 3)
　　　　return (AND << 11) | (ra << 8) | (rb << 5);
}
if(strcmp(opcode, "or") == 0){
if(sscanf(op_data, "%s r%d r%d", tmp_str, &ra, &rb) == 3)
　　　　return (OR << 11) | (ra << 8) | (rb << 5);
}
if(strcmp(opcode, "sl") == 0){
if(sscanf(op_data, "%s r%d", tmp_str, &ra) == 2)
　　　　return (SL << 11) | (ra << 8);
}
if(strcmp(opcode, "sr") == 0){
if(sscanf(op_data, "%s r%d", tmp_str, &ra) == 2)
　　　　return (SR << 11) | (ra << 8);
}
if(strcmp(opcode, "sra") == 0){
if(sscanf(op_data, "%s r%d", tmp_str, &ra) == 2)
　　　　return (SRA << 11) | (ra << 8);
}
if(strcmp(opcode, "ldl") == 0){
if(sscanf(op_data, "%s r%d %d", tmp_str, &ra, &data) == 3)
　　　　return (LDL << 11) | (ra << 8) | data;
}
if(strcmp(opcode, "ldh") == 0){
if(sscanf(op_data, "%s r%d %d", tmp_str, &ra, &data) == 3)
　　　　return (LDH << 11) | (ra << 8) | data;
}
if(strcmp(opcode, "cmp") == 0){
if(sscanf(op_data, "%s r%d r%d", tmp_str, &ra, &rb) == 3)
　　　　return (CMP << 11) | (ra << 8) | (rb << 5);
}
if(strcmp(opcode, "je") == 0){
if(sscanf(op_data, "%s %d", tmp_str, &label_num) == 2)　　　　// 一時的にレベル番号を書き込む
　　　　return (JE << 11) | label_num;
}
if(strcmp(opcode, "jmp") == 0){
if(sscanf(op_data, "%s %d", tmp_str, &label_num) == 2)　　　　// 一時的にレベル番号を書き込む
　　　　return (JMP << 11) | label_num;
}
if(strcmp(opcode, "ld") == 0){
if(sscanf(op_data, "%s r%d %d", tmp_str, &ra, &addr) == 3)
　　　　return (LD << 11) | (ra << 8) | addr;
}
if(strcmp(opcode, "st") == 0){
if(sscanf(op_data, "%s r%d %d", tmp_str, &ra, &addr) == 3)
　　　　return (ST << 11) | (ra << 8) | addr;
}
if(strcmp(opcode, "hlt") == 0){
return (HLT << 11);
}
if(strcmp(opcode, "nop") == 0){
return 0;
}
return -1;
}
int encoder(int ir, char *str)　　　　// 数値の0.1を文字に直す
{
char tmp_str[16];
int 　i;
tmp_str[15] = '\0';
for(i = 14; i >= 0; i--){
if(ir & 1){
tmp_str[i] = '1';
}else{
tmp_str[i] = '0';
}
ir = ir >> 1;
}
strcpy(str, tmp_str);
return 0;
}

