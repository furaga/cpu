#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "asm.h"

int output_type = 0;
int assemble(char*);

int main(int argc, char **argv, char **envp) {
	int i;
	if (argc < 2) {
		puts("USAGE:./asmcho [filename] [options]:\n");
		return 1;
	}

	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "-b") == 0) {
			output_type = 1;
		} else if (strcmp(argv[i], "-h") == 0) {
			output_type = 2;
		}
	}

	for (i = 1; i < argc; i++) {
		if (argv[i][0] != '-') {
			assemble(argv[i]);
		}
	}

	return 0;
}
