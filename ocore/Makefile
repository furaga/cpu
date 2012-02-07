TB = testbench
OBJS = top.o clk_gen.o cpu.o fetch.o decode.o reg_dc.o 
OBJS += exec.o reg_wb.o testbench.o ram.o
TMPL_DIR = ./tmpl

TARGET = $(TB)

IEEE = 'synopsys'
TIME = 1000ns
OPTION = -fexplicit
.SUFFIXES: .vhd .vcd

.PHONY: all wave
all: $(OBJS) $(TB) $(TB).vcd
wave: $(OBJS) $(TB) $(TB).vcd
	gtkwave $(TB).vcd


$(TB).vcd: $(TB) $(OBJS)
	ghdl -r $(TB) --vcd=$@ --stop-time=$(TIME)
$(TB): 
	ghdl -e --ieee=$(IEEE) $(OPTION) $(TB)
.vhd.o:
	ghdl -a --ieee=$(IEEE) $(OPTION) $<

asm:
	make -sC $(TMPL_DIR) asm
sim:
	make -sC $(TMPL_DIR) sim

clean:
	rm -f *.o *.vcd *.cf $(TB)
