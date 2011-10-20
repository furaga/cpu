#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>
#include "sim.h"

struct sigaction sa;
int simulate(char*);
void segv_handler(int);

int main(int argc, char **argv, char **envp) {
	int i;

	for (i = 1; i < argc; i++) {
		if (argv[i][0] != '-')
			simulate(argv[i]);
	}

	return 0;
}

