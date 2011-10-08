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


ASMTARGET = test/float_test/test1.s
SIMTARGET = test/float_test/test1

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
	./asmcho $(ASMTARGET)
sim:
	./simcho $(SIMTARGET)

clean:
	rm -f *.o $(TARGET) $(SIMTARGET) aslog

