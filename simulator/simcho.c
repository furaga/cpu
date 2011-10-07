#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "sim.h"

#define SIMTARGET "SIMTarget"
#define BUF_SIZE 1024
#define FILE_MAX 32
#define FALSE_FLAG 0
#define ALL_FLAG 1
#define CLEAN_FLAG 2

int simulate(char*);
int main(int argc, char **argv, char **envp) {
	char *sfile[FILE_MAX] = {NULL};
	int i,fd,ret,cnt;
	int flag = ALL_FLAG;
	char buf[BUF_SIZE] = {0};
	char *ptr;
	const char *delim = " \t\n";

	for (i = 1, cnt = 0; i < argc; i++) {
		// option handler
		if (argv[i][0] == '-') {
			if (strcmp(argv[i], "-all") == 0) {
				flag = ALL_FLAG;
				break;
			}
		} else {
			flag = FALSE_FLAG;
			sfile[cnt++] = argv[i];
		}
	}

	if (flag == ALL_FLAG) {
		fd = open(SIMTARGET, O_RDONLY);
		ret = read(fd, buf, BUF_SIZE);
		close(fd);
		ptr = buf;
		cnt = 0;
		while ((sfile[cnt] = strtok(ptr, delim))) {
			if(ptr) ptr = NULL;
			cnt++;
		}
		printf("simulate %s\n", SIMTARGET);
	}

	for (i = 0; i < cnt; i++) {
		simulate(sfile[i]);
	}
	return 0;
}
