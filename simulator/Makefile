CC = g++
CXX = g++
LD = g++
CFLAGS = -Wall -O2 -I ./include/
CXXFLAGS = -Wall -O2 -I ./include/
LDFLAGS = -Wall -O2
TARGET = simcho asmcho 
#TARGET = simulate asmcho asm
SIMH = common.h sim.h
ASMH = common.h asm.h

vpath %.h ./include

all: $(TARGET)
simcho: simcho.o simulate.o
asmcho: asmcho.o assemble.o call_opcode.o

simcho.o: $(SIMH) simulate.o
simulate.o: $(SIMH) 
inst_map.o: $(SIMH)

asmcho.o: $(ASMH) assemble.o
assemble.o: $(ASMH) call_opcode.o
call_opcode.o: $(ASMH)

asm:
	./asmcho -all

clean:
	./asmcho -clean
	rm -f *.o $(TARGET)

