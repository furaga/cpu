# sim/Makefile
TARGET = simcho
SIMH = common.h sim.h
include ../Makefile.in

CFLAGS += -I ../include/
CXXFLAGS += -I ../include/
vpath %.h ../include/
SIM_TARGET = $(TEST_TARGET:%=../../compiler/test/%)

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
	@for name in $(RT_TARGET) ; do \
		sld='../sld/'$$name'.sld'; \
		ppm='../ppm/'$$name'.ppm'; \
		original='../ppm0/'$$name'.ppm'; \
		diff='../diff/'$$name'.dif'; \
		./simcho $(MIN_RT) $(SIM_FLAGS) < $$sld > $$ppm; \
		diff $$original $$ppm | cat > $$diff; \
		cat $$diff; \
		(eog $$ppm &); \
	done 

