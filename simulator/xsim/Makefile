
#AS = nasm
AS = gas
.PHONY: sim rt clean

all:
	cd $(AS); make xrt
sim:
	cd $(AS); make sim
rt:
	cd $(AS); make rt
clean:
	cd nasm; make clean
	cd gas; make clean
