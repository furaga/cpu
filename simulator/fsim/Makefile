# sim/Makefile
TARGET = simcho
SIMH = common.h sim.h
HOME_DIR = ../
include ../Makefile.in

CFLAGS += -I ../include/
CXXFLAGS += -I ../include/
vpath %.h ../include/
SIM_TARGET = $(TEST_TARGET:%=../../compiler/test/%)

FPU_DIR = ../fpu
FPU =  $(FPU_DIR)/finv.o $(FPU_DIR)/fsqrt.o

SIMULATOR = simulate_f.o $(FPU) 
#SIMULATOR = simulate.o
simcho: $(SIMULATOR) simcho.o
simcho.o: $(SIMH) $(SIMULATOR)
simulate.o: $(SIMH) 
simulate_f.o: $(SIMH) $(FPU)

sim:
	./simcho $(SIM_TARGET) $(SIM_FLAGS)
rt:
	@for name in $(RT_TARGET) ; do \
		sld='../pict/sld/'$$name'.sld'; \
		ppm='../pict/ppm/'$$name'.ppm'; \
		original='../pict/ppm0/'$$name'.ppm'; \
		diff='../diff/'$$name'.dif'; \
		./simcho $(MIN_RT) $(SIM_FLAGS) < $$sld > $$ppm; \
		diff $$original $$ppm | cat > $$diff; \
		cat $$diff; \
		$(EOG) \
	done 

