#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>

void *mygets(char *dst, char *src, int n) {
	static char *src_cache = NULL;
	static char *src_ptr = NULL;
	char *ret;
	if (src_cache != src) {
		src_cache = src;
		src_ptr = src;
	}
	if (src_cache == NULL || src_ptr == NULL) { return NULL; }
	ret = memccpy(dst, src_ptr, '\n', n);
	if (ret == NULL) { 
	    src_ptr = src;
	    return NULL; 
	}
	*ret = '\0';
	src_ptr += (int) (ret - dst);
	return dst;
}

inline uint32_t eff_dig(unsigned dig, uint32_t num) {
	uint32_t mask = (1U << dig) - 1;
	return num & mask;
}
inline uint32_t shift_left_l(unsigned shiftwidth, uint32_t num) {
	return num << shiftwidth;
}
inline uint32_t shift_right_a(unsigned shiftwidth, uint32_t num) {
	return num >> shiftwidth;
}


#define N 32
void set_bin(char *buf, uint32_t num) {
	int i;
	const char *alpha = "01";
	for (i = 0; i < N; i++) {
		buf[N-i-1] = alpha[num&1];
		num >>= 1;
	}
}
#undef N
#define N 8
int set_hex(char *buf, uint32_t num) {
	int i, dig;
	int ret_dig = 1;
	const char *alpha = "0123456789abcdef";

	for (i = 0; i < N; i++) {
		dig = eff_dig(4, num);
		buf[N-i-1] = alpha[dig];
		num>>=4;
		if (alpha[dig]!='0') {
			ret_dig = i+1;
		}
	}
	return ret_dig;
}
#undef N

void _mywrite(int fd, char *buf, int num) {
	int nwrite;
	while ((nwrite = write(fd, buf, num))>0) {
		num -= nwrite;
	}
}

