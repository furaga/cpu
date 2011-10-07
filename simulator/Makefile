CC = g++
CXX = g++
LD = g++
CFLAGS = -Wall -O2 -I ./include/
CXXFLAGS = -Wall -O2 -I ./include/
LDFLAGS = -Wall -O2
TARGET = simulate occho 
#TARGET = simulate occho asm
SIMH = common.h sim.h
ASMH = common.h asm.h

vpath %.h ./include

all: $(TARGET)
simulate: simulate.o inst_map.o
occho: occho.o assemble.o call_opcode.o

simulate.o: $(SIMH) inst_map.o
inst_map.o: $(SIMH)

occho.o: $(ASMH) assemble.o
assemble.o: $(ASMH) call_opcode.o
call_opcode.o: $(ASMH)

asm:
	./occho -all
clean:
	./occho -clean
	rm -f *.o $(TARGET)  $(LOG) a.out

