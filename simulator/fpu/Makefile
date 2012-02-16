TARGET = finv.o fsqrt.o finv.s fsqrt.s uutadder.o uutfmul.o uutadder2.o \
		myfadd.o fadd.o
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
uutadder: sim.h uutadder.o
uutadder2: sim.h uutadder2.o
uutfmul: sim.h uutfmul.o
