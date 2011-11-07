ASMH = common.h asm.h reasm2.h
include ../MakefileX.in
RM_TARGET = ./bin/* ./lst/* ./obj/* ./x86asm/* xrt
AS = as

LIB_OBJ = inc/lib.o
ASM_TARGET = $(TEST_TARGET:%=$(COMPILER_DIR)/test/%.s)

asmcho: asmcho.o assemble.o encode_op.o 
asmcho.o: $(ASMH) assemble.o
assemble.o: $(ASMH) encode_op.o
encode_op.o: $(ASMH)

xrt: $(MIN_RT:%=%.s) asmcho  $(LIB_OBJ)
	./asmcho $(MIN_RT:%=%.s) > x86asm/min-rt.asm; \
	$(AS)  x86asm/min-rt.asm -o obj/min-rt.o; \
	ld obj/min-rt.o $(LIB_OBJ) -o xrt

#(eog $$ppm &); 
rt: xrt
	for name in $(RT_TARGET) ; do \
		sld=$(PICT_DIR)'/sld/'$$name'.sld'; \
		ppm=$(PICT_DIR)'/ppm/'$$name'.ppm'; \
		original=$(PICT_DIR)'/ppm0/'$$name'.ppm'; \
		diff=$(DIFF_DIR)/$$name'.dif'; \
		./xrt < $$sld > $$ppm; \
		diff $$original $$ppm | cat > $$diff; \
		cat $$diff; \
		echo $$name; \
	done 


	
TEST = $(TEST_TARGET)
$(TEST:%=bin/%): asmcho $(ASM_TARGET) $(LIB_OBJ)
	for name in $(TEST) ; do \
		target=$(COMPILER_DIR)'/test/'$$name'.s'; \
		x86asm='x86asm/'$$name'.asm'; \
		lst='lst/'$$name'.lst'; \
		obj='obj/'$$name'.o'; \
		bin='bin/'$$name; \
		./asmcho $$target > $$x86asm;	\
		$(AS) $$x86asm -o $$obj;	\
		ld $$obj $(LIB_OBJ) -o $$bin; \
	done 

sim: $(TEST:%=bin/%)
	for name in $(TEST) ; do \
		bin='bin/'$$name; \
		./$$bin; \
	done 
	
