CC = gcc
LD = gcc
CFLAGS = -Wall -O2
TARGET = simulate


all: $(TARGET)
simulate: simulate.o
simulate.o: setup.h
test: test.o setup.h

clean:
	rm -f *.o $(TARGET)
