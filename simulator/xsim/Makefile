ASMH = common.h asm.h reasm3.h
TARGET = geso
HOME_DIR = ../
include $(HOME_DIR)/Makefile.in
CFLAGS += -I $(HOME_DIR)/include/
CXXFLAGS += -I $(HOME_DIR)/include/
XSIM_FLAGS += -lm
vpath %.h $(HOME_DIR)/include/
vpath %.inc inc/
RM_TARGET = ./bin/*.x ./obj/*.o ./x86asm/*.asm ./lst/*.lst xrt
AS = as

LIB_OBJ = inc/lib.o inc/math.o
ASM_TARGET = $(TEST_TARGET:%=$(COMPILER_DIR)/test/%.s)

geso: geso.o convert.o convert_op.o 
geso.o: $(ASMH) convert.o
convert.o: $(ASMH) convert_op.o
convert_op.o: $(ASMH)

xrt: $(MIN_RT:%=%.s) geso  $(LIB_OBJ) $(HOME_DIR:%=%/Makefile.in)
	./geso $(XSIM_FLAGS) $(MIN_RT:%=%.s) > x86asm/min-rt.asm; \
	$(AS)  -a=lst/xrt.lst x86asm/min-rt.asm -o obj/min-rt.o; \
	ld obj/min-rt.o $(LIB_OBJ) -o xrt;

#./xrt < $$sld;
rt: xrt
	for name in $(RT_TARGET) ; do \
		echo $$name; \
		sld=$(PICT_DIR)'/sld/'$$name'.sld'; \
		ppm=$(PICT_DIR)'/ppm/'$$name'.ppm'; \
		original=$(PICT_DIR)'/ppm0/'$$name'.ppm'; \
		diff=$(DIFF_DIR)/$$name'.dif'; \
		./xrt < $$sld > $$ppm; \
		diff $$original $$ppm | cat > $$diff; \
		cat $$diff; \
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
		./geso $(XSIM_FLAGS) $$target > $$x86asm;	\
		$(AS) -a=$$lst $$x86asm -o $$obj;	\
		ld $$obj $(LIB_OBJ) -o $$bin; \
	done 

sim: $(TEST:%=bin/%.x)
	for name in $(TEST) ; do \
		bin='bin/'$$name'.x'; \
		./$$bin; \
	done 
	
