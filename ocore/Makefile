TB = testbench
OBJS = top.o clk_gen.o cpu.o fetch.o decode.o reg_dc.o ram_dc.o
OBJS += exec.o reg_wb.o ram_wb.o testbench.o

TARGET = $(TB)
SIM_TARGET = test

IEEE = 'synopsys'
TIME = 1000ns
OPTION = -fexplicit
.SUFFIXES: .vhd .vcd
.PHONY: asm sim debug

all: $(OBJS) $(TB) $(TB).vcd
wave: $(OBJS) $(TB).vcd
	gtkwave $(TB).vcd


$(TB).vcd: $(TB) $(OBJS)
	ghdl -r $(TB) --vcd=$@ --stop-time=$(TIME)
$(TB): 
	ghdl -e --ieee=$(IEEE) $(OPTION) $(TB)
.vhd.o:
	ghdl -a --ieee=$(IEEE) $(OPTION) $<

asm:
	./asmcho -h $(SIM_TARGET).s
sim:
	./asmcho $(SIM_TARGET).s
	./simcho $(SIM_TARGET)

clean:
	rm -f *.o *.vcd *.cf $(TB)
