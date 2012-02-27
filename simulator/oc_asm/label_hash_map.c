#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "oc_asm.h"

#define HASH_MAP_MAX (LINE_MAX*4)
static label_t label_hash_map[HASH_MAP_MAX];
static inline int is_blank(unsigned index) {
    return label_hash_map[index].len == 0;
}
static inline int same_label(label_t label, unsigned index) {
    return strcmp(label.name, label_hash_map[index].name) == 0;
}
static inline unsigned rehash(unsigned index) {
    return (index + 1)%HASH_MAP_MAX;
}

static unsigned hash_func(label_t label) {
    char *name = label.name;
    int len = label.len;
	int label_id;
	char *delim_ptr;
	char ch0,ch1,ch2,ch3;
	delim_ptr = strchr(name, '.');
	label_id = (delim_ptr==NULL) ? 1 : atoi(delim_ptr+1);
    ch0 = name[0];
	ch1 = name[len/2];
	ch2 = name[len-1];
	ch3 = 3;
    return (unsigned) (ch0*ch1*ch2*ch3+label_id)%HASH_MAP_MAX;
}

int hash_insert(label_t label) {
    unsigned index = hash_func(label);
	//static int rehash_cnt = 0;

    while (!is_blank(index)) {
    	if (same_label(label, index)) {
			// duplicate label
			return -1;
		}
		// collision rehash
		//warning("rehash cnt: %d index: %d label: %s\n", ++rehash_cnt, index, label.name);
		index = rehash(index);
    }

    strncpy(label_hash_map[index].name, label.name, label.len);
    label_hash_map[index].len = label.len;
    label_hash_map[index].line = label.line;

    return 0;
}

int hash_find(label_t label) {
    int index = hash_func(label);
    int i, find_flag = 0;
    for (i = 0; i < HASH_MAP_MAX; i++) {
    	if (same_label(label, index)) {
			find_flag = 1;
			break;
		}
    	index = rehash(index);
    }
    if (find_flag==0) {
		return -1;
    }
    return label_hash_map[index].line;
}

