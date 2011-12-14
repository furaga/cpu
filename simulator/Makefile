# Makefile


.PHONY: all asm clean sim fsim xsim frt rt xrt
MAKE_OPTION = -s
all:
	cd asm; make $(MAKE_OPTION)
	cd sim; make $(MAKE_OPTION)
	cd fpu; make $(MAKE_OPTION)
	cd xsim; make $(MAKE_OPTION)

asm:
	cd asm; make $(MAKE_OPTION) asm
sim:
	cd sim; make $(MAKE_OPTION) sim
xsim:
	cd xsim; make $(MAKE_OPTION) sim

rt:
	@cd asm; make $(MAKE_OPTION) rt
	@cd sim; make $(MAKE_OPTION) rt

xrt:
	@cd xsim; make $(MAKE_OPTION) rt

clean:
	cd asm; make $(MAKE_OPTION) clean
	cd sim; make $(MAKE_OPTION) clean
	cd fpu; make $(MAKE_OPTION) clean
	cd xsim; make $(MAKE_OPTION) clean

