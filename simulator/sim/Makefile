# sim/Makefile
TARGET = simcho
SIMH = common.h sim.h
HOME_DIR = ../
include ../Makefile.in

CFLAGS += -I ../include/ $(DEBUG_MACRO)
CXXFLAGS += -I ../include/
vpath %.h ../include/
SIM_TARGET = $(TEST_TARGET:%=$(COMPILER_DIR)/test/%)

FPU_DIR = ../fpu
FPU =  $(FPU_DIR)/finv.o $(FPU_DIR)/fsqrt.o

simcho: simcho.o simulate.o print_ir.o print_state.o statistics.o imap.o  $(FPU) debug.o
simcho.o: $(SIMH) simulate.o imap.o print_ir.o debug.o
simulate.o: $(SIMH) print_state.o statistics.o $(FPU) ../Makefile.in
debug.o: $(SIMH) print_ir.o
print_state.o: $(SIMH) print_ir.o
print_ir.o: $(SIMH) imap.o
statistics.o: $(SIMH) imap.o
imap.o: $(SIMH)

sim:
	./simcho $(SIM_TARGET) $(SIM_FLAGS)
rt:
	@for name in $(RT_TARGET) ; do \
		sld=$(PICT_DIR)'/sld/'$$name'.sld'; \
		ppm=$(PICT_DIR)'/ppm/'$$name'.ppm'; \
		original=$(PICT_DIR)'/ppm0/'$$name'.ppm'; \
		diff=$(DIFF_DIR)/$$name'.dif'; \
		./simcho $(MIN_RT) $(SIM_FLAGS) < $$sld > $$ppm; \
		diff $$original $$ppm | cat > $$diff; \
		cat $$diff; \
		$(EOG) \
	done 

