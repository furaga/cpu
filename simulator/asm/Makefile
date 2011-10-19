# asm/Makefile
TARGET = asmcho
ASMH = common.h asm.h
include ../Makefile.in

CFLAGS += -I ../include/
CXXFLAGS += -I ../include/
vpath %.h ../include/
ASM_TARGET = $(TEST_TARGET:%=../../compiler/test/%.s)

asmcho: asmcho.o assemble.o encode_op.o
asmcho.o: $(ASMH) assemble.o
assemble.o: $(ASMH) encode_op.o
encode_op.o: $(ASMH)

asm:
	./asmcho $(ASM_TARGET)
rt:
	./asmcho $(MIN_RT:%=%.s)

