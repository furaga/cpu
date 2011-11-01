# asm/Makefile
TARGET = asmcho
ASMH = common.h asm.h reasm.h
include ../Makefile.in
RM_TARGET = ./bin/* ./lst/* ./obj/* ./x86asm/*.asm xrt

CFLAGS += -I ../include/
CXXFLAGS += -I ../include/
vpath %.h ../include/
ASM_TARGET = $(TEST_TARGET:%=../../compiler/test/%.s)

asmcho: asmcho.o assemble.o encode_op.o 
asmcho.o: $(ASMH) assemble.o
assemble.o: $(ASMH) encode_op.o
encode_op.o: $(ASMH)

xrt: $(MIN_RT:%=%.s) asmcho x86asm/lib.inc
	./asmcho $(MIN_RT:%=%.s) > x86asm/min-rt.asm; \
	nasm -f elf64 x86asm/min-rt.asm -l lst/min-rt.lst -o obj/min-rt.o; \
	ld obj/min-rt.o -o xrt

rt: xrt
	for name in $(RT_TARGET) ; do \
		sld='../pict/sld/'$$name'.sld'; \
		ppm='../pict/ppm/'$$name'.ppm'; \
		original='../pict/ppm0/'$$name'.ppm'; \
		diff='../diff/'$$name'.dif'; \
		./xrt < $$sld ;\
	done 

#> $$ppm; \
#diff $$original $$ppm | cat > $$diff; \
#cat $$diff; \
#(eog $$ppm &); \
	


TEST = $(TEST_TARGET)
$(TEST:%=bin/%): asmcho x86asm/lib.inc
	for name in $(TEST) ; do \
		target='../../compiler/test/'$$name'.s'; \
		x86asm='x86asm/'$$name'.asm'; \
		lst='lst/'$$name'.lst'; \
		obj='obj/'$$name'.o'; \
		bin='bin/'$$name; \
		./asmcho $$target > $$x86asm;	\
		nasm -f elf64 $$x86asm -l $$lst -o $$obj;	\
		ld $$obj -o $$bin; \
	done 

sim: $(TEST:%=bin/%)
	for name in $(TEST) ; do \
		bin='bin/'$$name; \
		./$$bin; \
	done 
	
