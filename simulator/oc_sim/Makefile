# sim/Makefile
SIM = ./simcho
TARGET = simcho
SIMH = common.h oc_sim.h
HOME_DIR = ..
include ../Makefile.in
CC = gcc
CACHE = ../../cache
CFLAGS += -I ../include/ $(SIM_MACRO)
vpath %.h ../include/
SIM_TARGET = $(TEST_TARGET:%=$(COMPILER_DIR)/test/%)

FPU_DIR = ./fpu
FPU_ = finv fsqrt fadd fmul
FPU =  $(FPU_:%=$(FPU_DIR)/%.o)


FLAGS = ../Makefile.sim
UTIL = sim_util.o 
simcho: simcho.o simulate.o print_ir.o analyse.o $(FPU) $(UTIL)
simcho.o: $(SIMH) simulate.o print_ir.o $(UTIL) $(FLAGS)
simulate.o: $(SIMH) analyse.o $(FPU)  $(UTIL) $(FLAGS)
analyse.o: $(SIMH) $(UTIL)
print_ir.o: $(SIMH) $(UTIL)
sim_util.o: $(SIMH)

sim:
	$(SIM) $(SIM_TARGET) $(SIM_FLAGS)
rt:
	@for name in $(RT_TARGET) ; do \
		sld=$(SLD_DIR)/$$name'.sld'; \
		sldbin=$(SLDBIN_DIR)/$$name'.sldbin'; \
		ppm=$(PPM_DIR)/$$name'.ppm'; \
		original=$(PPM_ANS)/$$name'.ppm'; \
		$(SIM) $(MIN_RT) $(SIM_FLAGS) < $$sldbin > $$ppm; \
		$(EOG) \
	done 

RM_TARGET = $(FPU) *.log
