CC = g++
LD = g++
CFLAGS = -Wall -O2
LFLAGS = -Wall -O2
TARGET = simulate


all: $(TARGET)
simulate: simulate.o program.o
simulate.o: setup.h
program.o: setup.h
test: test.o setup.h

clean:
	rm -f *.o $(TARGET)
