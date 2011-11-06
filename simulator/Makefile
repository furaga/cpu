# Makefile


.PHONY: all asm clean sim fsim xsim frt rt xrt

all:
	cd asm; make
	cd sim; make
	cd fsim; make
	cd xsim; make

asm:
	cd asm; make asm
sim:
	cd sim; make sim
fsim:
	cd fsim; make sim
xsim:
	cd xsim; make sim

rt:
	@cd asm; make rt
	@cd sim; make rt

frt:
	@cd asm; make rt
	@cd fsim; make rt

xrt:
	@cd xsim; make rt

clean:
	cd asm; make clean
	cd sim; make clean
	cd fsim; make clean
	cd xsim; make clean

