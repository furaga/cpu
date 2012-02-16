TB = testbench
#io_dev.o 
OBJS = top.o clk_gen.o core_c.o decode.o reg_dc.o \
	std_logic_1164_additional.o \
	exec.o reg_wb.o testbench.o mem_acc.o u232c.o \
	io_dev.o prom.o fetch.o clk_delay.o sram.o\
	fadd.o fmul.o fsqrt.o finv.o finv_table.o fsqrt_table.o
		
TMPL_DIR = ./tmpl

TARGET = $(TB)

IEEE = 'synopsys'
TIME = 100us
OPTION = -fexplicit
.SUFFIXES: .vhd .vcd .tmp

.PHONY: default wave vcd reload

default: push

push:
	make -sC tmpl
rel: reload
reload: clean vcd
wave: vcd
	gtkwave $(TB).vcd
vcd: $(OBJS) $(TB) $(TB).vcd
ise:
	make -C ../
	

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
