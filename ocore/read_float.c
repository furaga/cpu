#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <string.h>

#define SIZE 32768
int main(int argc, char** argv) {
	unsigned char c;
	union {
		unsigned int i;
		float f;
	} a;
	a.i = 0;
	int i,nread,fd;
	char buf[SIZE];
	if (argc < 2) {
		puts("USAGE: ./read_float [filename]");
		exit(1);
	}

	fd = open(argv[1], O_RDONLY);
	if (fd<0) {
		perror("open");
		exit(1);
	}
	nread = read(fd, buf, SIZE);
	if (nread<0) {
		perror("read");
		exit(1);
	}

	if (buf[0] != 0xaa) {
		printf("buf[0]:%d != 0xaa\n", buf[0]);
		exit(1);
	}
	for(i=1;i < nread;i++) {
		if (buf[i] == '\n') {
			a.i = buf[i-1] << 24| 
				  buf[i-2] << 16|
				  buf[i-3] << 8|
				  buf[i-4];
			
			printf("%f  0x%08X\n", a.f, a.i);
			a.i = 0;
		} 
	}


	return 0;
}
