#include "sim.h"
#include <stdio.h>

#define dump(x) \
	fprintf(stderr, "%s: %08X\n", #x, x);

uint32_t _fmul(uint32_t i1, uint32_t i2) {
	/* passed arg's: uint32_t i1,uint32_t i2 */
  uint32_t s1 = i1 & (0x1 << 31);
  uint32_t s2 = i2 & (0x1 << 31);
  uint32_t s3;
  uint32_t e1 = (i1 >> 23) & 0xff;
  uint32_t e2 = (i2 >> 23) & 0xff;
  uint32_t e3;
  uint32_t c1 = ((i1 & 0x7fffff) | 0x800000);
  uint32_t c2 = ((i2 & 0x7fffff) | 0x800000);
  uint32_t c3;
  

/*??????*/
  if (s1 != s2)
    s3 = (0x1 << 31);
  else
    s3 = 0;
  
  
  /*?w????*/
  e3 = e1 + e2 - 127;
    
    
  /*??????*/
uint32_t c1l = c1 & 0x7ff;
uint32_t c2l = c2 & 0x7ff;
uint32_t c1h = c1 >> 11;
uint32_t c2h = c2 >> 11;
    c3 = c1h * c2h + ((c1h * c2l) >> 11) + ((c1l * c2h) >> 11) + 0;
	//dump(c1h*c2h);
	//dump(c1l*c2h);
	//dump(c1h*c2l);
	//dump(c3);

  
  /*???K??*/
if ((c3 & 0x2000000) == 0x2000000){
 e3 = e3 + 1;
 c3 = c3 >> 2;
}
else
 c3 = c3 >> 1;

 /*underflow, overflow*/
if ((e3 & 0x100) == 0x100)
  {e3 = 0;
   c3 = 0;
}

e3 = e3 << 23;


  uint32_t f = c3 & ~0x800000;
  //fprintf(stderr, "%08X * %08X = %08X", i1, i2, s3|e3|f);
  //getchar();
  
  return s3 | e3 | f;
}
