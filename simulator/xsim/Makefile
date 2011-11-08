
#AS = nasm
#AS = gas
AS = beta
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
	cd beta; make clean
