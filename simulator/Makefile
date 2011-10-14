CC = g++
CXX = g++
LD = g++
CFLAGS = -Wall -O2 -funroll-loops -I ./include/
CXXFLAGS = -Wall -O2 -funroll-loops -I ./include/
LDFLAGS = -Wall -O2 -lm
TARGET = simcho asmcho
SIMH = common.h sim.h
ASMH = common.h asm.h
vpath %.h ./include

#SIM_FLAGS = -o2 -res -reg -ram 100 200 -op 
#TEST_TARGET = float_test/test1 float_test/test2 float_test/test3
#TEST_TARGET = mylib_test/input_test
TEST_TARGET = min-rt/min-rt
#TEST_TARGET = fib

ASM_TARGET = $(TEST_TARGET:%=test/%.s)
SIM_TARGET = $(TEST_TARGET:%=test/%)


all: $(TARGET)
simcho: simcho.o simulate.o decode_ir.o print_state.o
asmcho: asmcho.o assemble.o encode_op.o

############################
## simulation
############################
simcho.o: $(SIMH) simulate.o
simulate.o: $(SIMH) print_state.o
print_state.o: $(SIMH) decode_ir.o
decode_ir.o: $(SIMH)


############################
## assembly
############################
asmcho.o: $(ASMH) assemble.o
assemble.o: $(ASMH) encode_op.o
encode_op.o: $(ASMH)

asm:
	./asmcho $(ASM_TARGET)
sim:
	./simcho $(SIM_TARGET) $(SIM_FLAGS)

clean:
	rm -f *.o $(TARGET) $(SIM_TARGET) asmlog simlog

