/* This file is a part of Automated Testbench Generator.
   2011 H.Tomari. This is a public domain software. */
#include "sim.h"
#include <unistd.h>
#define dump(x) fprintf(stderr, "%s: ", #x); to_bin(x);


void to_bin(uint32_t a);
	/* passed arg's: uint32_t i1,uint32_t i2 */
uint32_t _fadd(uint32_t i1, uint32_t i2) {
uint32_t s1 = i1 & (1 << 31);
uint32_t s2 = i2 & (1 << 31);
uint32_t s3;
uint32_t e1 = i1 & (0xff << 23);
uint32_t e2 = i2 & (0xff << 23);
uint32_t e3;
uint32_t c1 = ((i1 & 0x7fffff) | 0x800000);
uint32_t c2 = ((i2 & 0x7fffff) | 0x800000);
uint32_t c3;
uint32_t c3_tmp;
	int i, cnt;

/*符号*/
if ((s1 == (1 << 31) && s2 == (1 << 31)) || (s1 == (1 << 31) && (e1 > e2 || (e1 == e2 && c1 > c2))) || (s2 == (1 << 31) && (e1 < e2 || (e1 == e2 && c1 < c2))))
s3 = (1 << 31);
else
s3 = 0;

/*i1かi2が0の場合*/
if (e1 == 0) 
  {e3 = e2;
   c3 = c2;
  }
else if (e2 == 0)
  {e3 = e1;
   c3 = c1;
   }

else
{

/*桁揃え*/
if (e1 < e2)
 {e3 = e2;
  if (((e3 - e1) >> 23) < 24)
	c1 = (c1 >> ((e3 - e1) >> 23));
  else c1 = 0;
 }
else
 {e3 = e1;
  if (((e3 - e2) >> 23) < 24)
	c2 = (c2 >> ((e3 - e2) >> 23));
  else c2 = 0;
  }

/*足し算*/
if (s1 == s2) {
 c3 = c1 + c2;
}else if (c1 > c2) {
 c3 = c1 - c2;
} else {
 c3 = c2 - c1;
 }

/*仮数部の先頭を合わせる*/
	cnt = 0;
	for (i = 0; i < 25 ; i++){
		if (((1 << (24-i)) & c3) > 0) {
			break;
		}
		cnt++;
	}


	//e3 = ((e3 >> 23) + i - 23) << 23;
	if (cnt == 0) {
		 c3 >>= 1;
		 e3 += 0x00800000;
		 //fprintf(stderr,"a\n");
	} else if (cnt == 25) {
		 //fprintf(stderr,"b\n");
		c3 = 0;
		e3 = 0;
	} else {
		 //fprintf(stderr,"c\n");
		c3 <<= cnt-1;
		if ((e3 >> 23) > cnt-1) {
			e3 -= 0x00800000 *(cnt-1);
		} else {
			e3 = 0;
		}
	}
}

uint32_t f = c3 & 0x7fffff;



return s3 | e3 | f;
}
