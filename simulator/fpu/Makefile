TARGET = finv.o fsqrt.o finv.s fsqrt.s
include ../Makefile.in
all: $(TARGET)
CFLAGS += -I ../include/
CXXFLAGS += -I ../include/
vpath %.h ../include/
%.s:%.c
	$(CC) -S $(CFLAGS) $<

fpu: finv.o fsqrt.o

finv: sim.h finv.o
fsqrt: sim.h fsqrt.o
