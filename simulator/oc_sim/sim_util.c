

#include <unistd.h>
#include <stdint.h>

void to_bin(uint32_t a) {
	int i,n = 34;
	char buf[34];
	buf[33] = '\0';
	buf[32] = '\n';
	for (i = 0; i < 32; i++) {
		buf[31-i] = (a&1)+'0';
		a>>=1;
	}
	while (n -= write(2, buf, n));
}
inline uint32_t eff_dig(int dig, uint32_t num) {
	uint32_t mask = (1U << dig) - 1;
	return num & mask;
}
inline uint32_t sra_eff(int rsw, int dig, uint32_t num) {
	uint32_t mask = (1U << dig) - 1;
	return (num>>rsw) & mask;
}
inline uint32_t masked_num(unsigned mask, uint32_t num) {
	return num & mask;
}
