
#include "sim.h"

#define SIGN 0x80000000
#define EXPO 0x7f800000
#define FRAC 0x007fffff

#define dump(x) \
	fprintf(stderr, "%s: %08X\n", #x, x);
uint32_t _fadd(uint32_t i1, uint32_t i2) {
	/* passed arg's: uint32_t i1,uint32_t i2 */
	uint32_t s1 = i1 & SIGN;
	uint32_t s2 = i2 & SIGN;
	uint32_t s3;
	uint32_t e1 = i1 & EXPO;
	uint32_t e2 = i2 & EXPO;
	uint32_t e3;
	uint32_t c1 = (i1 & FRAC) | 0x800000;
	uint32_t c2 = (i2 & FRAC) | 0x800000;
	uint32_t c3;

	/*符号*/
	if ((s1 == SIGN && s2 == SIGN) 
	|| (s1 == SIGN && (i1&(~SIGN) > i2&(~SIGN))) 
	|| (s1 == SIGN && (i2&(~SIGN) > i1&(~SIGN)))) {
		s3 = SIGN;
	} else {
		s3 = 0;
	}

	/*i1かi2が0の場合*/
	if (e1 == 0) {
		e3 = e2; c3 = c2;
	} else if (e2 == 0) {
		e3 = e1; c3 = c1;
    } else {

		/*桁揃え*/
		if (e1 < e2) {
		  e3 = e2;
		  if (((e3 - e1) >> 23) < 24) {
			c1 >>= (e3 - e1) >> 23;
		  } else { c1 = 0;}
		 } else {
		 	e3 = e1;
		  if (((e3 - e2) >> 23) < 24) {
			c2 >>= (e3 - e2) >> 23;
		  } else { 
		  	c2 = 0;
		  }
		  }

		/*足し算*/
		if (s1 == s2) {
		 c3 = c1 + c2;
		} else if (c1 > c2) {
		 c3 = c1 - c2;
		} else {
		 c3 = c2 - c1;
		}

		/*仮数部の先頭を合わせる*/
		int i;
		for (i = 24; i >= 0 ; i--){
			if ((1U << i) & c3)
			break;
		}

		e3 = ((e3 >> 23) + i - 23) << 23;
		if (i != 24) {
			c3 = c3 << (23 - i);
		} else if ((i == 0) && ((1 & c3) == 0)) {
			c3 = 0; e3 = 0; 
		} else  {
			c3 = c3 >> 1;
		}

	}

	uint32_t f = c3 & ~0x800000;

	return s3 | e3 | f;
}
