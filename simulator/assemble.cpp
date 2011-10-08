#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <map>
#include <string>
#include <iostream>
#include <fstream>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "asm.h"

#define	LINE_MAX	2048	// asmの一行の長さの最大値
#define DATA_NUM 1024

using namespace std;

uint32_t call_opcode(char *, char *);
int	encoder(int, char*);

char	label_name[128][256];	
uint32_t label_cnt;
 
int	assemble(char *sfile) {
	char	buf[LINE_MAX];	
	uint32_t	output_data[DATA_NUM] = {0};	// 出力データの保存領域
	uint32_t	input_line_cnt;	// 入力側の行数をカウント
	uint32_t	output_line_cnt;	// 出力側の行数をカウント
	uint32_t	ir,err_cnt,label_line,heap_size,cnt;
	map<string, uint32_t> label_map;
	char	opcode[256];
	char *tmp = NULL;
	char *dfile;
	FILE	*fp;	// source file pointer
	int i,fd,ret,num,len;


	input_line_cnt = 0;
	output_line_cnt = 0;
	err_cnt = 0;
	label_cnt = 0;
	label_map.empty();
	heap_size = 0;


	// ソースファイルのopen
	fp = fopen(sfile, "r");
	if(fp == NULL){
		printf("ファイルが開けませんでした。\n");
		return -1;
	}
	len = strlen(sfile) - 2;
	dfile = (char*) malloc(len);
	strncpy(dfile, sfile, len);
	*(dfile+len) = 0;

	printf("assemble %s ==>\t", sfile);

	if (fgets(buf, LINE_MAX, fp) != NULL) {
		sscanf(buf, ".init_heap_size %d", &heap_size);
		output_data[output_line_cnt++] = heap_size;
	} else {
		printf("%d 行目の\n%sが解析できませんでした。\n", input_line_cnt + 1, buf);
		err_cnt++;
	}
	input_line_cnt++;

	cnt = 0;
	while ((cnt < heap_size) && (fgets(buf, LINE_MAX, fp) != NULL)) {
		// heap initialize
		if (strchr(buf, ':')) {
			// l.X: ------------------------ label
			tmp = strtok(buf,":");
			label_map.insert(map<string,uint32_t>::value_type(tmp, output_line_cnt*4));
		} else {
			// .xxxx 0xXXXXXXXX ------------------------- data
			sscanf(buf, "%s 0x%x", tmp, &num);
			output_data[output_line_cnt++] = num;
			cnt += 32;
		}
		input_line_cnt++;
	}

	while(fgets(buf, LINE_MAX, fp) != NULL){
		if(sscanf(buf, "%s", opcode) == 1){
 	 	 	if(strchr(buf,':')) {
 	 	 		// ラベル行の場合
 	 	 		if((tmp = strtok(opcode, ":"))) {
					label_map.insert(map<string,uint32_t>::value_type(tmp, output_line_cnt));
				} else {    // エラー処理
 	 	 		      printf("%d 行目の\n%sが解析できませんでした。\n", input_line_cnt + 1, buf);
 	 	 		      err_cnt++;
 	 	 		}
			}else if(opcode[0] == '.'){
			}else if(opcode[0] == '!'){
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
		printf("compile error(err_cnt:%d)\n", err_cnt);
		return -1;
	}else{

		// replace label_num with label_line
		for(i = 0; i < DATA_NUM; i++){
			switch ((output_data[i] & 0xfc000000) >> 26) {
				case JLT:
				case JNE:
				case JEQ:
					label_line = label_map[label_name[output_data[i] & 0xffff]];
					label_line -= i + 1;
					output_data[i] = (output_data[i] & 0xffff0000) | (label_line&0xffff);
					break;
				case CALL:
				case JMP:
					label_line = label_map[label_name[output_data[i] & 0x3ffffff]];
					output_data[i] = (output_data[i] & 0xfc000000) | label_line;
					break;
				case SETL:
					label_line = label_map[label_name[output_data[i] & 0xffff]];
					output_data[i] = addi(0, (output_data[i]&0x1f0000)>>16 ,label_line);
					break;
				default:
					break;
			}
		}

		fd = open(dfile, O_WRONLY | O_TRUNC | O_CREAT, S_IRUSR | S_IWUSR);
		num = DATA_NUM*4;
		while ((ret = write(fd, output_data, num)) > 0) {
			num -= ret;
		}
		close(fd);

		ofstream ofs(ASM_LOG);
		ofs << "DEPTH = 256;\nWIDTH = 32bit;\n"
			<< "ADDRESS_RADIX = DEC;\nDATA_RADIX = HEX;\n"
			<< "CONTENT\tBEGIN\n\n";

		map<string,uint32_t>::iterator itr;
		for(i = 0; i < DATA_NUM; i++){
			for(itr = label_map.begin(); itr != label_map.end(); itr++) {
				if (itr->second == (uint32_t)i) {
					ofs << itr->first << ":\n";
				}
			}
			if (output_data[i]) {
				ofs.width(4);
				ofs.fill(' ');
				ofs << dec << i <<": ";
				ofs.width(8);
				ofs.fill('0');
				ofs << hex << output_data[i] << endl;
			}
		}
		ofs.close();

		printf("%s\n", dfile);

		return 0;
	}
}
