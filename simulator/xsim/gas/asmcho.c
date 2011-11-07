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
int main(int argc, char **argv, char **envp) {
	int i;
	if (argc < 2) {
		puts("USAGE:./asmcho [filename] [options]:\n");
		return 1;
	}
	for (i = 1; i < argc; i++) {
		assemble(argv[i]);
	}

	return 0;
}
