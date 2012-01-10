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


using namespace std;
void hex2bin(uint32_t,FILE*);
int encode_op(char *, char *);
int mnemonic(char *, char [][LINE_MAX]);

char	label_name[LABEL_MAX][256];	
uint32_t label_cnt;
 
int	assemble(char *sfile) {
	char	extbuf[16][LINE_MAX];	
	char	*buf = extbuf[0];
	uint32_t	output_data[DATA_NUM] = {0};	// 出力データの保存領域
	uint32_t	i, input_line_cnt, output_line_cnt;	// 入出力側の行数をカウント
	uint32_t	ir,err_cnt,label_line,heap_size,cnt;
	map<string, uint32_t> label_map;
	map<string, uint32_t> heap_label;
	char	opcode[256];
	char *tmp = NULL;
	char *dfile;
	FILE	*fp;	// source file pointer
	int j,fd,ret,num,len;


	input_line_cnt = 0;
	output_line_cnt = 0;
	err_cnt = 0;
	label_cnt = 0;
	label_map.empty();
	heap_label.empty();
	heap_size = 0;


	// ソースファイルのopen
	fp = fopen(sfile, "r");
	if(fp == NULL){
		printf("ファイルが開けませんでした。\n");
		return -1;
	}

	printf("assemble %s ==>\t", sfile);

	if (fgets(buf, LINE_MAX, fp) != NULL) {
		sscanf(buf, ".init_heap_size %d", &heap_size);
		output_data[output_line_cnt++] = heap_size / 8;
	} else {
		printf("%d 行目の\n%sが解析できませんでした。\n", input_line_cnt + 1, buf);
		err_cnt++;
	}
	input_line_cnt++;

	cnt = 0;
	while ((cnt < heap_size) && (fgets(buf, LINE_MAX, fp) != NULL)) {
		if (sscanf(buf, "%s", opcode) == 1) {
			// heap initialize
			if (strchr(buf, ':')) {
				// l.X: ------------------------ label
				tmp = strtok(buf,":");
				label_map.insert(map<string,uint32_t>::value_type(tmp, (output_line_cnt-1)*4));
				heap_label.insert(map<string,uint32_t>::value_type(tmp, output_line_cnt*4));
			} else {
				// .xxxx 0xXXXXXXXX ------------------------- data
				sscanf(buf, "%s 0x%x", tmp, &num);
				output_data[output_line_cnt++] = num;
				cnt += 32;
			}
		}
		input_line_cnt++;
	}

	while(fgets(buf, LINE_MAX, fp) != NULL){
		if(sscanf(buf, "%s", opcode) == 1){
 	 	 	if(strchr(buf,':')) {
 	 	 		// ラベル行の場合
 	 	 		if((tmp = strtok(opcode, ":"))) {
					label_map.insert(map<string,uint32_t>::value_type(tmp, output_line_cnt*4));
				} else {    // エラー処理
 	 	 		    printf("%d 行目の\n%sが解析できませんでした。\n", input_line_cnt + 1, buf);
 	 	 		    err_cnt++;
 	 	 		}
			}else if(opcode[0] == '.'){
			}else if(opcode[0] == '!'){ // -- コメントなので何もしない
 	 	 	}else{
 	 	 		// 命令行
				num = mnemonic(opcode, extbuf);
				for (j = 0; j < num; j++) {
					sscanf(extbuf[j], "%s", opcode);
					ir = encode_op(opcode, extbuf[j]);
					if(ir < 0){             // エラー処理
						printf("%d 行目の\n%sが解析できませんでした。\n", input_line_cnt + 1, buf);
						err_cnt++;
					}else{
						output_data[output_line_cnt] = ir;
						output_line_cnt++;
					}
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
			for(i = heap_size/32+1; i < DATA_NUM; i++){
				switch ((output_data[i] & 0xfc000000) >> 26) {
					case JLT:
					case JNE:
					case JEQ:
					case FJLT:
					case FJEQ:
						label_line = label_map[label_name[output_data[i] & 0xffff]];
						label_line -= 4*i;
						output_data[i] = (output_data[i] & 0xffff0000) | (label_line&0xffff);
						break;
					case CALL:
					case JMP:
						label_line = label_map[label_name[output_data[i] & 0x3ffffff]];
						output_data[i] = (output_data[i] & 0xfc000000) | label_line;
						break;
					case SETL:
						label_line = label_map[label_name[output_data[i] & 0xffff]];
						output_data[i] = addi(0, (output_data[i]>>16)&0x1f ,label_line);
						break;
					default:
						break;
				}
			}

		len = strlen(sfile) - 2;
		dfile = (char*) malloc(len+1);
		strncpy(dfile, sfile, len);

		dfile[len] = 0;

		fd = open(dfile, O_WRONLY | O_TRUNC | O_CREAT, S_IRUSR | S_IWUSR);

		if (output_type == 0) {
			num = output_line_cnt*4;
			while ((ret = write(fd, output_data, num)) > 0) {
				num -= ret;
			}
			close(fd);
		} else {

			fp = fdopen(fd, "w");
			if (output_type == 1) {

				for (i = 0; i < output_line_cnt; i++) {
					fprintf(fp, "\"");
					hex2bin(output_data[i],fp);
					fprintf(fp, "\",\n");
				}

			} else if (output_type == 2) {

				for (i = 0; i < output_line_cnt; i++) {
					fprintf(fp, "x\"%08X\",\n", output_data[i]);
				}
			}

			fflush(fp);
			close(fd); fclose(fp);
		}

		ofstream ofs(ASM_LOG);
		ofs << "DEPTH = 256;\nWIDTH = 32bit;\n"
			<< "ADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\n"
			<< "CONTENT\tBEGIN\n\n";
		
		map<string,uint32_t>::iterator itr;
		for(i = 0; i < output_line_cnt; i++) {
			for(itr = heap_label.begin(); itr != heap_label.end(); itr++) {
				if (itr->second == (uint32_t)i*4) {
					ofs << itr->first << ":\n";
				}
			}

			for(itr = label_map.begin(); itr != label_map.end(); itr++) {
				if ((itr->second == (uint32_t)i*4) &&
					(heap_label.count(itr->first) <= 0)) {
					ofs << itr->first << ":\n";
				}
			}

			ofs.width(4);
			ofs.fill(' ');
			ofs << hex << i*4 <<": ";
			ofs.width(8);
			ofs.fill('0');
			ofs << hex << output_data[i] << endl;

		}
		ofs.close();

		printf("%s\n", dfile);

		return 0;
	}
}

void hex2bin(uint32_t a, FILE *fp) {
	int i, n;
	uint32_t msb = 0x80000000;
	for (i = 0; i < 32; i++) {
		n = ((a & msb) == msb) ? 1 : 0;
		fprintf(fp,"%d", n);
		//if (i == 0) {
			//fprintf(fp," ");
		//}
		//if (i == 8) {
			//fprintf(fp," ");
		//}
		a <<= 1;
	}
}


