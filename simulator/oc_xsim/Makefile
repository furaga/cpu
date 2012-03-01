ASMH = common.h asm_fmt.h oc_geso.h
TARGET = geso
HOME_DIR = ../
include $(HOME_DIR)/Makefile.in
CC = gcc
CACHE = ../../cache

CFLAGS += -I $(HOME_DIR)/include/
CXXFLAGS += -I $(HOME_DIR)/include/
XSIM_FLAGS += -m
vpath %.h $(HOME_DIR)/include/
vpath %.inc inc/
RM_TARGET = ./bin/*.x ./obj/*.o ./x86asm/*.asm ./lst/*.lst xrt
AS = as

LIB_OBJ = inc/lib.o inc/math.o
ASM_TARGET = $(TEST_TARGET:%=$(COMPILER_DIR)/test/%.s)

geso: geso.o convert.o asm_fmt.o convert_op.o
geso.o: $(ASMH) convert.o
convert.o: $(ASMH) asm_fmt.o 
convert_op.o: $(ASMH)

xrt: $(MIN_RT:%=%.s) geso  $(LIB_OBJ) $(HOME_DIR:%=%/Makefile.in)
	./geso $(MIN_RT:%=%.s) $(XSIM_FLAGS) -o x86asm/min-rt.asm; \
	$(AS)  -a=lst/xrt.lst x86asm/min-rt.asm -o obj/min-rt.o; \
	ld obj/min-rt.o $(LIB_OBJ) -o xrt;

#./xrt < $$sld;
rt: xrt
	for name in $(RT_TARGET) ; do \
		sld=$(SLD_DIR)/$$name'.sld'; \
		sldbin=$(SLDBIN_DIR)/$$name'.sldbin'; \
		ppm=$(PPM_DIR)/$$name'.ppm'; \
		original=$(PPM_ANS)/$$name'.ppm'; \
		./xrt < $$sldbin > $$ppm; \
		$(EOG) \
	done 


	
TEST = $(TEST_TARGET)
$(TEST:%=bin/%.x): geso $(ASM_TARGET) $(LIB_OBJ) $(HOME_DIR:%=%/Makefile.in)
	for name in $(TEST) ; do \
		target=$(COMPILER_DIR)'/test/'$$name'.s'; \
		x86asm='x86asm/'$$name'.asm'; \
		lst='lst/'$$name'.lst'; \
		obj='obj/'$$name'.o'; \
		bin='bin/'$$name'.x'; \
		./geso $$target $(XSIM_FLAGS) -o $$x86asm;	\
		$(AS) -a=$$lst $$x86asm -o $$obj;	\
		ld $$obj $(LIB_OBJ) -o $$bin; \
	done 

sim: $(TEST:%=bin/%.x)
	for name in $(TEST) ; do \
		bin='bin/'$$name'.x'; \
		./$$bin; \
	done 
	
