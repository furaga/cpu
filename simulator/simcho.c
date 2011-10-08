#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "sim.h"

int simulate(char*);
int main(int argc, char **argv, char **envp) {
	int i;
	if (argc < 2) {
		puts("USAGE:./simcho [filename] [options]:\n");
		return 1;
	}
	for (i = 1; i < argc; i++) {
		simulate(argv[i]);
	}

	return 0;
}
