#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

uint32_t _finv(uint32_t);
uint32_t _fsqrt(uint32_t);

int main() {
	union {
		float f;
		uint32_t i;
	} a,b,c,d;

	a.i = 0x44604260;
	b.i = 0x44604148;


	printf("%23.20lf\n", a.f);
	printf("%23.20lf\n", b.f);
	
	return 0;
}
