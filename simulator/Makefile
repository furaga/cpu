CC = g++
CXX = g++
LD = g++
CPPFLAGS = -Wall -O2
LFLAGS = -Wall -O2
TARGET = simulate occho 
#TARGET = simulate occho asm

all: $(TARGET)
simulate: simulate.o inst_map.o
occho: occho.o assemble.o call_opcode.o ir.o
occho.o: setup.h
call_opcode: setup.h
simulate.o: setup.h
ir.o: setup.h
assemble.o: setup.h
inst_map.o: setup.h

asm:
	./occho -all
clean:
	./occho -clean
	rm -f *.o $(TARGET)  $(LOG) a.out
