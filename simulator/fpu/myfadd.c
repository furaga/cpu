#include "sim.h"
#include <stdio.h>
#include <stdlib.h>

#define SIGN ((uint32_t) 0x80000000)
#define EXPO ((uint32_t) 0x7f800000)
#define FRAC ((uint32_t) 0x007fffff)
#define HIDD ((uint32_t) 0x00800000)
#define CAR ((uint32_t) 0x08000000)
#define BOR ((uint32_t) 0x04000000)


uint32_t _fadd(uint32_t i1, uint32_t i2) {
	uint32_t dif, sticky = 0;
	uint32_t ret,so,s1,s2,eo,e1,e2,fo,f1,f2;
	uint32_t *frp;
	static int i = 0;
	s1 = i1 & SIGN; s2 = i2 & SIGN;
	e1 = i1 & EXPO; e2 = i2 & EXPO;
	f1 = (i1 & FRAC) | HIDD; f2 = (i2 & FRAC) | HIDD;
	f1 <<= 3; f2 <<= 3;

	// exp compare ---------------------
	eo = (e1 > e2) ? (so = s1, frp = &f2, e1) 
								 : (so = s2, frp = &f1, e2);
	dif = abs(e1 - e2) >> 23;
	dif = (dif > 31) ? 31 : dif;
	sticky = (*frp ^ ((*frp >> dif) << dif)) ? 1 : 0;
	*frp >>= dif;
	*frp |= sticky;
	// ---------------------------------
		
	if (s1 == s2) {
		// add
		fo = f1 + f2;
		if (fo & CAR) {
			eo += HIDD;
			sticky |= fo & 1;
			fo >>= 1;
			fo |= sticky;
		}

	} else {
		// sub
		if (e1 == e2) 
			so = (f1 > f2) ? s1 : s2;

			fo = abs(f1 - f2);
		while ((fo!=0)&&(!(fo&BOR))) {
			eo -= HIDD;
			fo <<= 1;
		}
	}

	// rounding --------------------
	switch (fo & 15) {
		case 5:
		case 6:
		case 7:
		case 12:
		case 13:
		case 14:
	  case 15: fo += 8; break;
		default: break;
	}
	// -----------------------------

	fo >>= 3;
	fo &= FRAC;
	ret = so | eo | fo;
	return ret;
}
