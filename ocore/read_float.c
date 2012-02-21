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
	int i,nread,fd,cnt;
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

/*
	if (c != 0xaa) {
		printf("buf[0]:0x%02x != 0xaa\n", c);
		exit(1);
	} else {
		printf("0xaa received\n");
	}
*/

	cnt = 0;
	for (i=0; i<nread; i++) {
		c = buf[i];

		if (cnt >= 3) {
			a.i |= c << (cnt*8);
			cnt++;
			printf("%f  0x%08X\n", a.f, a.i);
			a.i = 0;
			cnt = 0;
		} else {
			a.i |= c << (cnt*8);
			cnt++;
		}
    }


	return 0;
}
