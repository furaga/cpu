#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "asm.h"

int assemble(char*);
int count_flag;
int mathlib_flag;
int main(int argc, char **argv, char **envp) {
	int i;
	if (argc < 2) {
		puts("USAGE:./asmcho [filename] [options]:\n");
		return 1;
	}
	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "-cnt") == 0) {
			count_flag = 1;
		}
		if (strcmp(argv[i], "-lm") == 0) {
			mathlib_flag = 1;
		}
	}
	for (i = 1; i < argc; i++) {
		if (argv[i][0] != '-') {
			assemble(argv[i]);
		}
	}

	return 0;
}
