#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <map>
#include <string>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "setup.h"

#define IN_FILENAME "others/fib.s"
#define OUT_FILENAME "output"
#define	LINE_MAX	2048	// asmの一行の長さの最大値
#define DATA_NUM 256

uint32_t call_opcode(char *, char *);
int	encoder(int, char*);
using namespace std;
map<string, uint32_t> label_map;
char	label_name[128][256];	
uint32_t label_cnt;
 
int	main() {
    using namespace std; 
	FILE	*fp;	
	char	buf[LINE_MAX];	
	uint32_t	output_data[DATA_NUM];	// 出力データの保存領域
	uint32_t	input_line_cnt;	// 入力側の行数をカウント
	uint32_t	output_line_cnt;	// 出力側の行数をカウント
	uint32_t	ir;	
	uint32_t	i;	
	char	opcode[256];
	char	output_tmpstr[16];
	uint32_t	err_cnt;
	uint32_t	label_num;
	char *tmp;
	int fd,ret, num;

	input_line_cnt = 0;
	output_line_cnt = 0;
	err_cnt = 0;
	label_cnt = 0;
	label_num = 0;

	for(i = 0; i < DATA_NUM; i++)
		output_data[i] = 0;	 // NOP
	output_data[DATA_NUM-1] = (HALT << 26);	 // HALT

	// ソースファイルのopen
	fp = fopen(IN_FILENAME, "r");
	if(fp == NULL){
		printf("ファイルが開けませんでした。\n");
		return -1;
	}

	printf("%sを読み込み中。\n", IN_FILENAME);

	while(fgets(buf, LINE_MAX, fp) != NULL){
		if(sscanf(buf, "%s", opcode) == 1){
 	 	 	if(strchr(buf,':')) {
 	 	 		// : (ラベル番号) ラベル行の場合
 	 	 		if((tmp = strtok(opcode,":"))){
					label_map.insert(map<string,uint32_t>::value_type(tmp, output_line_cnt));
 	 	 		}else{    // エラー処理
 	 	 		      printf("%d 行目の\n%sが解析できませんでした。\n", input_line_cnt + 1, buf);
 	 	 		      err_cnt++;
 	 	 		}
			}else if(opcode[0] == '#'){
 	 	 		// -- コメントなので何もしない
 	 	 	}else{
 	 	 		// 命令行
 	 	 		ir = call_opcode(opcode, buf);
 	 	 		if(ir < 0){             // エラー処理
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

		for(i = 0; i < DATA_NUM; i++){
			if((output_data[i] & 0xfc000000 ) == (JLT << 26)){
				label_num = label_map[label_name[(output_data[i] & 0x7FF)]];
				label_num -= i+1;
				output_data[i] = (output_data[i] & 0xffff0000) | label_num;
			}
			if((output_data[i] & 0xfc000000 ) == (CALL << 26)){
				label_num = label_map[label_name[(output_data[i] & 0x7FF)]];
				output_data[i] = (CALL << 26) | label_num;
			}
		}

		//書き込みファイルをopen
		fp = fopen(OUT_FILENAME, "w");
		if(fp == NULL){
			 printf("書き込みファイルが開けませんでした。\n");
			 return -1;
		}

		//mifファイルを出力
		/*
		fprintf(fp, "DEPTH = 256;\nWIDTH = 15;\n");
		fprintf(fp, "ADDRESS_RADIX = HEX;\nDATA_RADIX = BIN;\n");
		fprintf(fp, "CONTENT\n\tBEGIN\n");
		fprintf(fp, "[00..7F]\t:\t000000000000;\n");
		*/

		
		fd = open("binary", O_WRONLY | O_TRUNC | O_CREAT);

		num = DATA_NUM;
		while ((ret = write(fd, output_data, num)) > 0) {
			num -= ret;
		}
		close(fd);

		for(i = 0; i < DATA_NUM; i++){
			fprintf(fp, "%4d: %08X \n", i, output_data[i]);
		}
		fprintf(fp, "END;\n\n");

		fclose(fp);
		printf("コンパイルは正常に終了しました。\n");
		printf("%sに書き出しました。\n", OUT_FILENAME);
		printf("%sに書き出しました。\n", "binary");
		return 0;
	}
}

uint32_t call_opcode(char *opcode, char *op_data)
{
    using namespace std; 
	int rd,rs,rt,imm,funct,shaft,target;
	char tmp[256];
	const char *format1 = "%s %%g%d, %d";
	const char *format2 = "%s %%g%d, %%g%d";
	const char *format3 = "%s %%g%d, %%g%d, %s";
	const char *format4 = "%s";
	const char *format5 = "%s %%g%d, %%g%d, %d";
	const char *format6 = "%s %%g%d, [%%g%d + %d]";
	const char *format7 = "%s %s";
	const char *format8 = "%s %%g%d, %%g%d, %%g%d";
	char lname[256];

	shaft = funct = target = 0;

	if(strcmp(opcode, "mov") == 0){
		if(sscanf(op_data, format2, tmp, &rd, &rs) == 3)
		    return mov(rs,0,rd,shaft,funct);
	} else
	if(strcmp(opcode, "mvhi") == 0){
		if(sscanf(op_data, format1, tmp, &rt, &imm) == 3)
		    return mvhi(rs,rt,imm);
	} else
	if(strcmp(opcode, "mvlo") == 0){
		if(sscanf(op_data, format1, tmp, &rt, &imm) == 3)
		    return mvlo(rs,rt,imm);
	} else
	if(strcmp(opcode, "jlt") == 0){
		if(sscanf(op_data, format3, tmp, &rs, &rt, lname) == 4)
			strcpy(label_name[label_cnt],lname);
		    return jlt(rs,rt,label_cnt++);
	} else
	if(strcmp(opcode, "return") == 0){
		if(sscanf(op_data, format4, tmp) == 1) 
		    return _return(target);
	} else
	if(strcmp(opcode, "add") == 0){
		if(sscanf(op_data, format8, tmp, &rd, &rs,&rt) == 4)
		    return mov(rs,rt,rd,shaft,funct);
	} else
	if(strcmp(opcode, "addi") == 0){
		if(sscanf(op_data, format5, tmp, &rt, &rs, &imm) == 4)
		    return addi(rs,rt,imm);
	} else
	if(strcmp(opcode, "subi") == 0){
		if(sscanf(op_data, format5, tmp, &rt, &rs, &imm) == 4)
		    return subi(rs,rt,imm);
	} else
	if(strcmp(opcode, "st") == 0){
		if(sscanf(op_data, format6, tmp, &rs, &rt, &imm) == 4)
		    return st(rs,rt,imm);
	} else
	if(strcmp(opcode, "call") == 0){
		if(sscanf(op_data, format7, tmp, lname) == 2) 
			strcpy(label_name[label_cnt],lname);
		    return call(label_cnt++);
	} else
	if(strcmp(opcode, "ld") == 0){
		if(sscanf(op_data, format6, tmp, &rs, &rt, &imm) == 4)
		    return ld(rs,rt,imm);
	} else
	{}

	return -1;
}
