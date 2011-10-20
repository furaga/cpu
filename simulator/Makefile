# Makefile


.PHONY: all asm sim clean simple_sim

all:
	cd asm; make
	cd sim; make

asm:
	cd asm; make asm
sim:
	cd sim; make sim

rt:
	@cd asm; make rt
	@cd sim; make rt

clean:
	cd asm; make clean
	cd sim; make clean

