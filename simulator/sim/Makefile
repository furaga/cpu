# sim/Makefile
TARGET = simcho
SIMH = common.h sim.h
include ../Makefile.in

CFLAGS += -I ../include/
CXXFLAGS += -I ../include/
vpath %.h ../include/
SIM_TARGET = $(TEST_TARGET:%=../../compiler/test/%)
SLD = $(RT_TARGET:%=../sld/%.sld)
PPM = $(RT_TARGET:%=../ppm/%.ppm)

simcho: simcho.o simulate.o decode_ir.o print_state.o statistics.o imap.o operate.o
simcho.o: $(SIMH) simulate.o imap.o decode_ir.o
simulate.o: $(SIMH) print_state.o statistics.o operate.o
operateo.o: $(SIMH)
print_state.o: $(SIMH) decode_ir.o
decode_ir.o: $(SIMH)
statistics.o: $(SIMH)
imap.o: $(SIMH)

sim:
	./simcho $(SIM_TARGET) $(SIM_FLAGS)
rt:
	@./simcho $(MIN_RT) $(SIM_FLAGS) < $(SLD) > $(PPM)
	eog $(PPM) &
