# Makefile


.PHONY: all asm sim clean fsim frt rt

all:
	cd asm; make
	cd sim; make
	cd fsim; make

asm:
	cd asm; make asm
sim:
	cd sim; make sim
fsim:
	cd fsim; make sim

rt:
	@cd asm; make rt
	@cd sim; make rt

frt:
	@cd asm; make rt
	@cd fsim; make rt

clean:
	cd asm; make clean
	cd sim; make clean
	cd fsim; make clean

