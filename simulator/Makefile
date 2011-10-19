# Makefile


.PHONY: all asm sim clean

all:
	cd asm; make
	cd sim; make
	cd simple_sim; make

asm:
	cd asm; make asm
sim:
	cd sim; make sim
simple_sim:
	cd simple_sim; make sim

rt:
	@cd asm; make rt
	@cd sim; make rt

simple_rt:
	@cd asm; make rt
	@cd simple_sim; make rt


clean:
	cd asm; make clean
	cd sim; make clean
	cd simple_sim; make clean

