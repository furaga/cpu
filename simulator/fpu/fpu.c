#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

uint32_t _finv(uint32_t);
uint32_t _fsqrt(uint32_t);

int main() {
	union {
		float f;
		uint32_t i;
	} a,b,c;
	int i;

	c.f = 1000000.0;
	a.f = 1.0005;
	for (i = 0; i < 10000000; i++) {
		//c.f = c.f / a.f;
		b.i = _finv(a.i);
		c.f = c.f * b.f;
	}
	printf("%.30f\n", c.f);
	
	return 0;
}
