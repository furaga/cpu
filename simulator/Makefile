CC = g++
LD = g++
CFLAGS = -Wall -O2
LFLAGS = -Wall -O2
TARGET = simulate assemble
LOG = log binary output

all: $(TARGET)
simulate: simulate.o program.o iset.o
assemble: assemble.o program.o
simulate.o: setup.h
program.o: setup.h
assemble.o: setup.h

clean:
	rm -f *.o $(TARGET)  $(LOG) a.out
