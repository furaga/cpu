# asm/Makefile
TARGET = asmcho
ASMH = common.h asm.h reasm.h
include ../Makefile.in
RM_TARGET = ./bin/* ./lst/* ./obj/* ./x86asm/* xrt
ASM = nasm

CFLAGS += -I ../include/
CXXFLAGS += -I ../include/
NASMFLAGS = -f elf64 -I inc/
LIB_INC = debug64.inc stdio64.inc syscall64.inc
LIB_OBJ = inc/stdio64.o
vpath %.h ../include/
vpath %.inc inc/
ASM_TARGET = $(TEST_TARGET:%=$(COMPILER_DIR)/test/%.s)

asmcho: asmcho.o assemble.o encode_op.o 
asmcho.o: $(ASMH) assemble.o
assemble.o: $(ASMH) encode_op.o
encode_op.o: $(ASMH)


xrt: $(MIN_RT:%=%.s) asmcho  $(LIB_INC)
	./asmcho $(MIN_RT:%=%.s) > x86asm/min-rt.asm; \
	nasm $(NASMFLAGS) x86asm/min-rt.asm -l lst/min-rt.lst -o obj/min-rt.o; \
	ld obj/min-rt.o $(LIB_OBJ) -o xrt

rt: xrt
	for name in $(RT_TARGET) ; do \
		sld='../pict/sld/'$$name'.sld'; \
		ppm='../pict/ppm/'$$name'.ppm'; \
		original='../pict/ppm0/'$$name'.ppm'; \
		diff='../diff/'$$name'.dif'; \
		./xrt < $$sld > $$ppm; \
		diff $$original $$ppm | cat > $$diff; \
		cat $$diff; \
		(eog $$ppm &); \
	done 


	


TEST = $(TEST_TARGET)
$(TEST:%=bin/%): asmcho $(ASM_TARGET) $(LIB_INC)
	for name in $(TEST) ; do \
		target='../../compiler/test/'$$name'.s'; \
		x86asm='x86asm/'$$name'.asm'; \
		lst='lst/'$$name'.lst'; \
		obj='obj/'$$name'.o'; \
		bin='bin/'$$name; \
		./asmcho $$target > $$x86asm;	\
		nasm $(NASMFLAGS) $$x86asm -l $$lst -o $$obj;	\
		ld $$obj $(LIB_OBJ) -o $$bin; \
	done 

sim: $(TEST:%=bin/%)
	for name in $(TEST) ; do \
		bin='bin/'$$name; \
		./$$bin; \
	done 
	
