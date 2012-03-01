# Makefile

.PHONY: all asm clean sim fsim xsim frt rt xrt
MAKE_OPTION = -s

ASM = oc_asm
SIM = oc_sim
XSIM = oc_xsim
all:
	cd $(ASM); make $(MAKE_OPTION)
	cd $(SIM); make $(MAKE_OPTION)
	cd $(XSIM); make $(MAKE_OPTION)

asm:
	cd $(ASM); make $(MAKE_OPTION) asm
sim:
	cd $(SIM); make $(MAKE_OPTION) sim
xsim:
	cd $(XSIM); make $(MAKE_OPTION) sim

rt:
	@cd $(ASM); make $(MAKE_OPTION) rt
	@cd $(SIM); make $(MAKE_OPTION) rt

xrt:
	@cd $(XSIM); make $(MAKE_OPTION) rt

clean:
	cd asm; make $(MAKE_OPTION) clean
	cd oc_asm; make $(MAKE_OPTION) clean
	cd sim; make $(MAKE_OPTION) clean
	cd oc_sim; make $(MAKE_OPTION) clean
	cd xsim; make $(MAKE_OPTION) clean
	cd oc_xsim; make $(MAKE_OPTION) clean

