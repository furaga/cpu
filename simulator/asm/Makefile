# asm/Makefile
TARGET = asmcho
ASMH = common.h asm.h
HOME_DIR = ..
include ../Makefile.in

CFLAGS += -I ../include/
CXXFLAGS += -I ../include/
vpath %.h ../include/
ASM_TARGET = $(TEST_TARGET:%=$(COMPILER_DIR)/test/%.s)
#ASM_TARGET = $(TEST_TARGET:%=source/as/%.s)

asmcho: asmcho.o assemble.o encode_op.o mnemonic.o
asmcho.o: $(ASMH) assemble.o
assemble.o: $(ASMH) encode_op.o mnemonic.o
encode_op.o: $(ASMH)
mnemonic.o: $(ASMH)

asm:
	./asmcho $(ASM_FLAGS) $(ASM_TARGET)
rt:
	./asmcho $(MIN_RT:%=%.s)

