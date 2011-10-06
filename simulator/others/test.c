#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>

int main() {
	int ret, i;
	unsigned rom[1024] = {0};
	int fd = open("binary", O_RDONLY);
	ret = read(fd, rom, 1024);
	close(fd);
	for (i = 0; i < ret; i++) {
		if(rom[i]) {
			printf("%d: %x\n", i,rom[i]);
		}
	}
}
