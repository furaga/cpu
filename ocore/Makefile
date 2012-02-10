TB = testbench
OBJS = top.o clk_gen.o core_c.o fetch.o decode.o reg_dc.o \
	exec.o reg_wb.o testbench.o ram.o u232c.o io_dev.o \
	fadd.o fmul.o fsqrt.o finv.o finv_table.o fsqrt_table.o
		
TMPL_DIR = ./tmpl

TARGET = $(TB)

IEEE = 'synopsys'
TIME = 10000ns
OPTION = -fexplicit
.SUFFIXES: .vhd .vcd .tmp

.PHONY: default wave vcd reload

default: push rel

push:
	make -sC tmpl
rel: reload
reload: clean vcd
wave: vcd
	gtkwave $(TB).vcd
vcd: $(OBJS) $(TB) $(TB).vcd
	

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
	rm -f *.s *.o *.vcd *.cf $(TB)
