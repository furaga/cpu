# sim/Makefile
SIM = ./oc_simcho
# simcho
TARGET = oc_simcho
SIMH = common.h sim.h
HOME_DIR = ../
include ../Makefile.in

CFLAGS += -I ../include/ $(DEBUG_MACRO)
CXXFLAGS += -I ../include/
vpath %.h ../include/
SIM_TARGET = $(TEST_TARGET:%=$(COMPILER_DIR)/test/%)

FPU_DIR = ./fpu
FPU =  $(FPU_DIR)/finv.o $(FPU_DIR)/fsqrt.o $(FPU_DIR)/fadd.o $(FPU_DIR)/fmul.o

simcho: simcho.o simulate.o print_ir.o print_state.o statistics.o imap.o  $(FPU) debug.o
simcho.o: $(SIMH) simulate.o imap.o print_ir.o debug.o
simulate.o: $(SIMH) print_state.o statistics.o $(FPU) 
#../Makefile.in
debug.o: $(SIMH) print_ir.o
print_state.o: $(SIMH) print_ir.o
print_ir.o: $(SIMH) imap.o
statistics.o: $(SIMH) imap.o
imap.o: $(SIMH)

oc_simcho: oc_simcho.o oc_simulate.o oc_print_ir.o print_state.o oc_statistics.o imap.o  $(FPU) oc_debug.o to_bin.o
oc_simcho.o: $(SIMH) oc_simulate.o imap.o oc_print_ir.o debug.o
oc_simulate.o: $(SIMH) print_state.o oc_statistics.o $(FPU) ../Makefile.in
oc_statistics.o: $(SIMH) imap.o
oc_print_ir.o: $(SIMH) imap.o
oc_debug.o: $(SIMH) oc_print_ir.o

sim:
	$(SIM) $(SIM_TARGET) $(SIM_FLAGS)
rt:
	@for name in $(RT_TARGET) ; do \
		sld=$(PICT_DIR)'/sld/'$$name'.sld'; \
		sldbin=$(PICT_DIR)'/sldbin/'$$name'.bin'; \
		ppm=$(PICT_DIR)'/ppm/'$$name'.ppm'; \
		original=$(PICT_DIR)'/ppm0/'$$name'.ppm'; \
		diff=$(DIFF_DIR)/$$name'.dif'; \
		$(SIM) $(MIN_RT) $(SIM_FLAGS) < $$sldbin > $$ppm; \
	done 

RM_TARGET += $(FPU)
