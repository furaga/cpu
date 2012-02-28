#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <fcntl.h>
#include <signal.h>
#include "oc_sim.h"

static void configure(int argc, char **argv);
static void register_segv_handler(void);
static void prom_set(int argc, char **argv);
int simulate(void);
static void print_elapsed_time(struct timeval, struct timeval);
FILE *err_fp;

int main(int argc, char **argv, char **envp) {
	struct timeval tv1,tv2;
	configure(argc, argv);
	register_segv_handler();
	prom_set(argc, argv);
	gettimeofday(&tv1, NULL);
	simulate();
	gettimeofday(&tv2, NULL);
	print_elapsed_time(tv1,tv2);
	warning("cnt\t: %lu\n", cnt);
	
	return 0;
}
static void print_elapsed_time(struct timeval tv1, struct timeval tv2) {
	int elapsed_sec = tv2.tv_sec - tv1.tv_sec;
	int elapsed_usec = tv2.tv_usec - tv1.tv_usec;
	if (elapsed_sec == 0) {
		warning("elapsed_time\t: %u [us]\n", elapsed_usec);
	} else {
		warning("elapsed_time\t: %lf [s]\n", (double)elapsed_sec + elapsed_usec*1e-6);
	}
}

static void configure(int argc, char **argv) {
	err_fp = stderr;
}
static void prom_set(int argc, char **argv) {
	int fd, ret;
	if (argc < 2) {
		warning("USAGE\t: %s $file\n", argv[0]);
		exit(1);
	}
	fd = open(argv[1], O_RDONLY);
	if (fd<0) {
		perror("open");
		exit(1);
	}
	ret = read(fd, prom, ROM_NUM*4);
	if (ret<0) {
		perror("read");
		exit(1);
	}
	close(fd);
}

void segv_handler(int);
static void register_segv_handler(void) {
	struct sigaction sa;
	sa.sa_handler = segv_handler;
	if (sigaction(SIGSEGV, &sa, NULL) != 0) {
		perror("sigaction");
		exit(1);
	}

}

void segv_handler(int n) {
	uint32_t ir = prom[pc/4 - 1];
	warning("せぐふぉー@%lu.[%x] ir:%08X ", cnt, pc, ir);
	print_ir(ir);
	warning("\n");
	exit(1);
}
