#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "oc_asm.h"
enum out_fmt_t { OFMT_BIN, OFMT_STR_BIN, OFMT_STR_HEX, OFMT_COE, OFMT_EX_MNE };
static enum out_fmt_t output_type = OFMT_BIN;
enum dst_t { DST_FILE, DST_STDOUT, DST_STDERR, };
static enum dst_t dst_flag = DST_FILE;

FILE *err_fp;

static char *dfile = (char*) "ika.out";
static char *lst_file = (char*) "ika.lst";
static char *sfile;

static int sfd, dfd, lfd;
static int lst_flag, be_quiet;
static int output_line_min;
static uint32_t binary_data[LINE_MAX];
static char ex_mne_buf[LINE_MAX*COL_MAX];
static char asm_buf[LINE_MAX*COL_MAX];

static void print_usage(char*name);
static void configure(int argc, char** argv);
static void print_conf(void);
static void conf_sfile(int argc, char** argv);
static void conf_out_fmt(int argc, char** argv); 
static void open_files(void);
static void close_files(void);
static void output_file(char*buf, int size);
int expand_mnemonic(char *ex_mne_buf, char *asm_buf);
int assemble(uint32_t* binary_data, char*buf);
void asm_listing(int fd, uint32_t* binary_data, char*ex_mne_buf);

#define mywrite(buf, num) _mywrite(dfd, buf, num)
int main(int argc, char **argv) {
	int size;
	configure(argc, argv);
	open_files();
	print_conf();
	size = read(sfd, asm_buf, LINE_MAX*COL_MAX);
	if (size<0) { exit(1); }
	size = expand_mnemonic(ex_mne_buf, asm_buf);
	if (size<0) { exit(1); }
	if (output_type == OFMT_EX_MNE) {
		mywrite(ex_mne_buf, size);
	} else {
		size = assemble(binary_data, ex_mne_buf);
		if (size<0) { exit(1); }
		output_file((char*)binary_data, size*4);
	}
	if (lst_flag>0) {
		asm_listing(lfd, binary_data, ex_mne_buf); // reuse asm_buf
	}
	exit(0);
}

static void configure(int argc, char** argv) {
	err_fp = stderr;
	conf_sfile(argc, argv);
	conf_out_fmt(argc, argv);
}

static void conf_sfile(int argc, char** argv) {
	if (argc < 2) {
		print_usage(argv[0]);
		exit(1);
	}
	sfile = argv[1];
	if (sfile==NULL) {
		warning("Not Found: source file\n");
		exit(1);
	}

}
static void output_file(char*buf, int size) {
	int i;
	char linebuf[64];
	uint32_t *buf32 = (uint32_t*)buf;
	switch (output_type) {
		case OFMT_BIN :
			mywrite(buf, size);
			break;
		case OFMT_STR_BIN :
			linebuf[0] = linebuf[33] = '"';
			linebuf[34] = ',';
			linebuf[35] = '\n';
			for (i=0; i<size/4; i++) {
				set_bin(linebuf+1, buf32[i]);
				mywrite(linebuf, 36);
			}
			for (i=i; i<output_line_min; i++) {
				mywrite("\"00000000000000000000000000000000\",\n", 36);
			}
			break;
		case OFMT_STR_HEX :
			linebuf[0] = linebuf[9] = '"';
			linebuf[10] = ',';
			linebuf[11] = '\n';
			for (i=0; i<size/4; i++) {
				set_hex(linebuf+1, buf32[i]);
				mywrite(linebuf, 12);
			}
			for (i=i; i<output_line_min; i++) {
				mywrite("\"00000000\",\n", 12);
			}
			break;
		case OFMT_COE :
			mywrite("memory_initialization_radix=16;\n", 32);
			mywrite("memory_initialization_vector=\n", 30);
			linebuf[8] = ',';
			linebuf[9] = '\n';
			for (i=0; i<size/4; i++) {
				if (i == size/4-1) {
					linebuf[8]=';';
				}
				set_hex(linebuf, buf32[i]);
				mywrite(linebuf, 10);
			}
			break;
		case OFMT_EX_MNE :
		default :
			warning("Unexpected case @ output_file\n");
			break;
	}
}
static void close_files(void) {
	close(sfd); 
	if (dst_flag == DST_FILE) {
		close(dfd);
	}
	if (lst_flag > 0) {
		close(lfd);
	}
}
static void open_files(void) {

	sfd = open(sfile, O_RDONLY);
	if (sfd < 0) {
		warning("sfile @ open_files: %s\n", sfile);
		perror("open");
		exit(1);
	}
	switch (dst_flag) {
		case DST_STDOUT :
			dfd = 1;
			break;
		case DST_STDERR :
			dfd = 2;
			break;
		case DST_FILE :
		default :
			dfd = open(dfile, O_WRONLY | O_TRUNC | O_CREAT, S_IRUSR | S_IWUSR);
			if (dfd < 0) {
				warning("dfile @ open_files: %s\n", dfile);
				perror("open");
				exit(1);
			}
			break;
	}
	if (lst_flag > 0) {
		lfd = open(lst_file, O_WRONLY | O_TRUNC | O_CREAT, S_IRUSR | S_IWUSR);
		if (lfd < 0) {
			warning("lst_file @ open_files: %s\n", lst_file);
			perror("open");
			exit(1);
		}

	}
	if (be_quiet>0) {
		// now : err_fp = stderr 
		err_fp = fopen("/dev/null", "w");
		if (err_fp == NULL) {
			warning("err_fp @ open_files: /dev/null\n");
			perror("fopen");
			exit(1);
		};
	}
	atexit(close_files);
}

#define print_option(fmt, ...) \
	warning("\t"fmt"\n", ##__VA_ARGS__)
static void print_usage(char*name) {
	warning("\n");
	warning("USAGE\t: %s $file [$options]\n", name);
	warning("OPTIONS\t:\n");
	print_option("-o $dst_file\t: place output in file $dst_file");
	print_option("-l [$lst_file]\t: place list output in file $lst_file");
	print_option("-b $line_num\t: output binary string");
	print_option("-x $line_num\t: output hexadecimal string");
	print_option("-c $line_num\t: output coe format string");
	print_option("-h\t: print this usage information");
	print_option("-m\t: output code after expanding mnemonic");
	print_option("-q\t: don't print configure information");
	warning("\n");
}
#undef print_option

static void conf_out_fmt(int argc, char** argv) {
	int opt;
	while ((opt = getopt(argc, argv, "lmqcbhxo:")) != -1) {
		switch (opt) {
			case 'o' :
				if (atoi(optarg) == 1) {
					dst_flag = DST_STDOUT;
				} else if (atoi(optarg) == 2) {
					dst_flag = DST_STDERR;
				} else {
					dst_flag = DST_FILE;
					dfile = optarg;
				}
				break;
			case 'q' :
				be_quiet = 1;
				break;
			case 'l' :
				lst_flag = 1;
				if ((argc != optind) && (argv[optind][0] != '-')) {
					lst_file = argv[optind];
					optind++;
				}
				break;
			case 'm' :
				output_type = OFMT_EX_MNE;
				break;
			case 'b' :
				output_type = OFMT_STR_BIN;
				if ((argc != optind) && (argv[optind][0] != '-')) {
					output_line_min = atoi(argv[optind]);
					optind++;
				}
				break;
			case 'x' :
				output_type = OFMT_STR_HEX;
				if ((argc != optind) && (argv[optind][0] != '-')) {
					output_line_min = atoi(argv[optind]);
					optind++;
				}
				break;
			case 'c' :
				output_type = OFMT_COE;
				break;
			case ':' :
			case '?' :
			case 'h' :
			default :
				print_usage(argv[0]);
				exit(1);
				break;
		}
	}
}

#define print_val(fmt, ...) \
	warning("* "fmt"\n", ##__VA_ARGS__)
static void print_conf(void) {
	warning("\n");
	warning("######################## ASMCHO CONFIGURATION ########################\n\n");
	print_val("source\t: %s", sfile);
	switch (dst_flag) {
		case DST_STDOUT :
			print_val("destination\t: stdout");
			break;
		case DST_STDERR :
			print_val("destination\t: stderr");
			break;
		case DST_FILE :
		default:
			print_val("destination\t: %s", dfile);
			break;
	}
	if (lst_flag > 0) {
		print_val("list file\t: %s", lst_file);
	} else {
		print_val("list file\t: no output");
	}
	switch (output_type) {
		case OFMT_BIN :
			print_val("output_type\t: binary format (executable by simulator)");
			break;
		case OFMT_STR_BIN :
			print_val("output_type\t: binary string format");
			break;
		case OFMT_STR_HEX :
			print_val("output_type\t: hexadecimal string format");
			break;
		case OFMT_COE :
			print_val("output_type\t: coe format");
			break;
		case OFMT_EX_MNE :
			print_val("output_type\t: assembly after expand mnemonic");
			break;
		default :
			print_val("conf_out_fmt: unexpected output_type");
			exit(1);
			break;
	}
	print_val("output_line_min\t: %d", output_line_min);
	warning("\n######################################################################\n\n");
}
#undef print_val
