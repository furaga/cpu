CC = g++
CXX = g++
LD = g++
CFLAGS = -Wall -O2 -I ./include/
CXXFLAGS = -Wall -O2 -I ./include/
LDFLAGS = -Wall -O2
TARGET = simcho asmcho 
SIMH = common.h sim.h
ASMH = common.h asm.h
vpath %.h ./include

TEST_TARGET = float_test/test1 float_test/test2 float_test/test3

ASM_TARGET = $(TEST_TARGET:%=test/%.s)
SIM_TARGET = $(TEST_TARGET:%=test/%)


all: $(TARGET)
simcho: simcho.o simulate.o inst_map.o
asmcho: asmcho.o assemble.o call_opcode.o

############################
## simulation
############################
simcho.o: $(SIMH) simulate.o
simulate.o: $(SIMH) 
inst_map.o: $(SIMH)

############################
## assembly
############################
asmcho.o: $(ASMH) assemble.o
assemble.o: $(ASMH) call_opcode.o
call_opcode.o: $(ASMH)

asm:
	./asmcho $(ASM_TARGET)
sim:
	./simcho $(SIM_TARGET)

clean:
	rm -f *.o $(TARGET) $(SIM_TARGET) aslog

