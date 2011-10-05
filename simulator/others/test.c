#include <stdio.h>
#include "setup.h"
DEFINE_R(add, ADD)

int main() {
	printf("%x\n", add(0,0,0,0,0));

	return 0;
}
