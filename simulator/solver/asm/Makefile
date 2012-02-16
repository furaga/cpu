# asm/Makefile
ASM = ./ocore_asmcho
TARGET = asmcho ocore_asmcho
ASMH = common.h asm.h
HOME_DIR = ..
include ../Makefile.in

CFLAGS += -I ../include/
CXXFLAGS += -I ../include/
vpath %.h ../include/
ASM_TARGET = $(TEST_TARGET:%=$(COMPILER_DIR)/test/%.s)
#ASM_TARGET = $(TEST_TARGET:%=source/as/%.s)
#ASM_FLAGS += -h

asmcho: asmcho.o assemble.o encode_op.o mnemonic.o
asmcho.o: $(ASMH) assemble.o
assemble.o: $(ASMH) encode_op.o mnemonic.o
encode_op.o: $(ASMH)
mnemonic.o: $(ASMH)

asm:
	$(ASM) $(ASM_FLAGS) $(ASM_TARGET)
rt:
	$(ASM) $(MIN_RT:%=%.s)

