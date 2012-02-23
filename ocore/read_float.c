#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <string.h>

#include <unistd.h>
#include <stdint.h>

#define N 8
void to_bin8(uint32_t a) {
	int i,n = N;
	char buf[N];
	for (i = 0; i < N; i++) {
		buf[N-i-1] = (a&1)+'0';
		a>>=1;
	}
	while (n -= write(1, buf, n));
}

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
		to_bin8(c&0xff);
		printf("  %3d(dec) 0x%02x %c\n", c&0xff, c&0xff, c&0xff);
		fflush(stdout);


/*
		if (cnt >= 3) {
			a.i |= c << (cnt*8);
			cnt++;
			printf("%c  0x%08X\n", a.f, a.i);
			a.i = 0;
			cnt = 0;
		} else {
			a.i |= c << (cnt*8);
			cnt++;
		}
 */
    }


	return 0;
}
