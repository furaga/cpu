TB = testbench
OBJS = top.o clk_gen.o cpu15e.o fetch.o decode.o reg_dc.o ram_dc.o
OBJS += exec.o reg_wb.o ram_wb.o testbench.o

TARGET = $(TB)
IEEE = 'synopsys'
TIME = 1000ns
OPTION = -fexplicit
.SUFFIXES: .vhd .vcd

all: $(OBJS) $(TB) $(TB).vcd
wave: $(OBJS) $(TB).vcd
	gtkwave $(TB).vcd


$(TB).vcd: $(TB) $(OBJS)
	ghdl -r $(TB) --vcd=$@ --stop-time=$(TIME)
$(TB): 
	ghdl -e --ieee=$(IEEE) $(OPTION) $(TB)
.vhd.o:
	ghdl -a --ieee=$(IEEE) $(OPTION) $<

clean:
	rm -f *.o *.vcd *.cf $(TB)
