#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "setup.h"

#define ALL_FLAG 1
#define CLEAN_FLAG 2
#define BUF_SIZE 1024
#define FILE_MAX 128
#define ASMTARGET "ASMTarget"
int assemble(char*,char*);

int main(int argc, char **argv, char **envp) {
	char *sfile[FILE_MAX] = {NULL};
	char *dfile[FILE_MAX] = {NULL};
	char buf[BUF_SIZE] = {0};
	char *ptr;
	int i,asmcnt,fd,ret,len,pid;
	int flag = 0;
	const char *delim = " \t\n";
	char *rm_argv[FILE_MAX+2];

	if (argc < 2) {
		puts("usage: ./assemble [filename] [options]");
		puts("[option]:");
		puts("\t-o [binary filename] (default: 'o.out')");
		return 1;
	}

	for (i = 1; i < argc; i++) {
		// option handler
		if (argv[i][0] == '-') {
			if (argv[i][1] == 'o') {
				dfile[0] = argv[i+1];
				i++;
			} else if (strcmp(argv[i], "-all") == 0) {
				flag = ALL_FLAG;
				break;
			} else if (strcmp(argv[i], "-clean") == 0) {
				flag = CLEAN_FLAG;
				break;
			} else 
			{}
		} else {
			sfile[0] = argv[i];
		}
	}
	if (flag) {
	// set sfile, dfile ///////////////////////////////////////////////////
		fd = open(ASMTARGET, O_RDONLY);
		ret = read(fd, buf, BUF_SIZE);
		close(fd);
		ptr = buf;
		asmcnt = 0;
		while ((sfile[asmcnt] = strtok(ptr, delim))) {
			if(ptr) ptr = NULL;
			len = strlen(sfile[asmcnt])-2;
			dfile[asmcnt] = (char *) malloc(len);
			strncpy(dfile[asmcnt], sfile[asmcnt], strlen(sfile[asmcnt])-2);
			asmcnt++;
		}
	///////////////////////////////////////////////////////////////////////

		if (flag == ALL_FLAG) {
			for (i = 0; i < asmcnt; i++) {
				assemble(sfile[i], dfile[i]);
			}
		} else if (flag == CLEAN_FLAG) {
			if ((pid = fork()) == 0) {
				rm_argv[0] = "/bin/rm";
				rm_argv[1] = "-f";
				rm_argv[2] = "o.out";
				rm_argv[3] = "aslog";
				for (i = 0; i < asmcnt; i++) {
					rm_argv[i+4] = dfile[i];
				}
				execve("/bin/rm", rm_argv, envp);
				puts("Can't exec /bin/rm");
				return 1;
			} else {
				waitpid(pid, NULL, 0);
				puts("binary files are removed");
			}
		}
		for (i = 0; i < asmcnt; i++) {
			free(dfile[i]);
		}
		return 0;
	}

	assemble(sfile[0], dfile[0]);

	return 0;
}
