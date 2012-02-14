/* This file is a part of Automated Testbench Generator.
   2011 H.Tomari. This is a public domain software. */
#include "gentest.h"
#include <stdio.h>

GT_UUT(adder) {
	/* passed arg's: uint32_t i1,uint32_t i2 */
uint32_t s1 = i1 & (1 << 31);
uint32_t s2 = i2 & (1 << 31);
uint32_t s3;
uint32_t e1 = i1 & (0xff << 23);
uint32_t e2 = i2 & (0xff << 23);
uint32_t e3;
uint32_t c1 = ((i1 & 0x7fffff) | 0x800000) << 3; /*3bitはガード、ラウンド、スティッキー*/
uint32_t c2 = ((i2 & 0x7fffff) | 0x800000) << 3;
uint32_t c3;

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

/*桁揃え stickyは1か2いずれかしか立たない。*/
if (e1 < e2)
 {e3 = e2;
  if (((e3 - e1) >> 23) < 27){
	int i;
	for (i = ((e3 - e1) >> 23); i >= 0 ; i--){
	 if (((1 << i) & c1) != 0)
	  break;
	}
	c1 = (c1 >> ((e3 - e1) >> 23));
	if (i != 0){
		if ((c1 & 0x1) == 0)
                      c1 = c1 + 1;
        }
  }
  else c1 = 1;
}

else
 {e3 = e1;
  if (((e3 - e2) >> 23) < 27){
	int i;
	for (i = ((e3 - e2) >> 23); i >= 0 ; i--){
	 if (((1 << i) & c2) != 0)
	  break;
	}
	c2 = (c2 >> ((e3 - e2) >> 23));
	if (i != 0){
		if ((c2 & 0x1) == 0)
                      c2 = c2 + 1;
        }
  }
  else c2 = 1;
}

/*足し算(符号が異なるときは引き算)を実行*/
if (s1 == s2){
 c3 = c1 + c2;
}
else if (c1 > c2)
 c3 = c1 - c2;
else
 c3 = c2 - c1;



/*正規化と丸め*/


/*hiddenと繰り上がりを考えた25bitの最初の1を探す*/
int i;
for (i = 24; i >= 0 ; i--){
 if (((1 << i) & (c3 >> 3)) != 0)
  break;
}


e3 = ((e3 >> 23) + i - 23) << 23;
if (i != 24)
 c3 = c3 << (23 - i);
else
 c3 = c3 >> 1 | (c3 & 0x1);


if ((c3 & 0x4) == 0x4 && ((c3 & 0x2) == 0x2 || (c3 & 0x1) == 0x1))
	c3 = c3 + 8;
else if (((c3 & 0x4) == 0x4) && ((c3 & 0x8) == 0x8))
	c3 = c3 + 8;


c3 = c3 >> 3;

}

uint32_t f = c3 & ~0x800000;

return s3 | e3 | f;
}
