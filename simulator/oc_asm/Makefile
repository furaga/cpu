# asm/Makefile
ASM = ./asmcho
TARGET = asmcho
ASMH = common.h oc_asm.h
HOME_DIR = ..
include ../Makefile.in
CC = gcc
LD = gcc

CFLAGS += -I ../include/
vpath %.h ../include/

ASM_TARGET = $(TEST_TARGET:%=$(COMPILER_DIR)/test/%)
asm:
	$(ASM) $(ASM_TARGET).s $(ASM_FLAGS) -o $(ASM_TARGET)
rt:
	$(ASM) $(MIN_RT).s -o $(MIN_RT)


UTIL = asm_util.o
asmcho: asmcho.o expand_mnemonic.o assemble.o label_hash_map.o encode_op.o $(UTIL) asm_fmt.o
asmcho.o: $(ASMH) expand_mnemonic.o assemble.o $(UTIL)
assemble.o: $(ASMH) label_hash_map.o encode_op.o $(UTIL) asm_fmt.o
expand_mnemonic.o: $(ASMH) $(UTIL)
encode_op.o: $(ASMH) $(UTIL)
label_hash_map.o: $(ASMH) $(UTIL)
