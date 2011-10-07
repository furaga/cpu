
#ifndef _SIM_HEAD
#define _SIM_HEAD
#include "common.h"
extern int32_t reg[];
extern uint32_t freg[];
extern uint32_t rom[];
extern uint32_t ram[];
#define DEF_ELE_ACC(name, shift, mask) \
	uint32_t name(uint32_t ir) {\
		return ((ir >> shift) & mask);\
	}
#endif
