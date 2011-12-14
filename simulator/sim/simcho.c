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
	int i, ret;

	if ((ret = print_init(argc,argv)) < 0) {
		puts("check print_state.c");
		return ret;
	}

	sa.sa_handler = segv_handler;
	if (sigaction(SIGSEGV, &sa, NULL) != 0) {
		perror("sigaction");
		return 1;
	}

	for (i = 1; i < argc; i++) {
		if (argv[i][0] != '-')
			simulate(argv[i]);
	}

	return 0;
}

void segv_handler(int n) {
	uint32_t ir = rom[pc];
	fprintf(stderr, "せぐふぉー@\n%llu.[%d] ir:%8X ", cnt,pc,ir);
	print_ir(ir, stderr);
	fprintf(stderr, "\n");
	kill(0,SIGINT);
}
