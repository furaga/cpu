#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "asm.h"

#define ASMTARGET "ASMTarget"
#define BUF_SIZE 1024
#define FILE_MAX 32
#define FALSE_FLAG 0
#define ALL_FLAG 1
#define CLEAN_FLAG 2
int assemble(char*,char*);

int main(int argc, char **argv, char **envp) {
	char *sfile[FILE_MAX] = {NULL};
	char *dfile[FILE_MAX] = {NULL};
	char buf[BUF_SIZE] = {0};
	char *ptr;
	int i,asmcnt,fd,ret,len,pid;
	int flag = 0;
	const char *delim = " \t\n";

	if (argc < 2) {
		puts("USAGE:");
		puts("\t./occho [filename] [options]:\n");
		puts("OPTIONS:");
		puts("\t-o [filename]");
		puts("\t\tplace output in file $filename");
		puts("\t-all");
		puts("\t\tthe files listed in ASTarget are assembled");
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
			printf("assenble %s\n", ASMTARGET);
			for (i = 0; i < asmcnt; i++) {
				assemble(sfile[i], dfile[i]);
			}
		} else if (flag == CLEAN_FLAG) {
			if ((pid = fork()) == 0) {
				argv[0] = (char*)"/bin/rm";
				argv[1] = (char*)"-f";
				argv[2] = (char*)ASM_LOG;
				argv[3] = (char*)DEFAULT_BIN;
				for (i = 0; i < asmcnt; i++) {
					argv[i+4] = dfile[i];
				}
				argv[i+4] = NULL;
				execve("/bin/rm", argv, envp);
				puts("Can't exec /bin/rm");
				return 1;
			} else {
				waitpid(pid, NULL, 0);
				printf("/bin/rm -f %s %s",ASM_LOG,DEFAULT_BIN);
				for (i = 0; i < asmcnt; i++) {
					printf(" %s", dfile[i]);
				}

				putchar('\n');
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
