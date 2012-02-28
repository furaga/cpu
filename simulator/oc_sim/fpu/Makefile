TARGET = finv.o fsqrt.o fadd.o fmul.o
include ../Makefile.in
CC = gcc

all: $(TARGET)
CFLAGS += -I ../include/
CXXFLAGS += -I ../include/
vpath %.h ../include/
%.s:%.c
	$(CC) -S $(CFLAGS) $<

fpu: finv.o fsqrt.o

finv: sim.h finv.o
fsqrt: sim.h fsqrt.o
fadd: sim.h fadd.o
fmul: sim.h fmul.o
