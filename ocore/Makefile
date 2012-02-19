TB = testbench
FPU = fadd fmul fsqrt finv 
FPU_SIM = $(FPU) finv_table fsqrt_table
OBJS = top.o clk_gen.o core_c.o decode.o reg_dc.o \
	std_logic_1164_additional.o \
	exec.o reg_wb.o testbench.o mem_acc.o u232c.o \
	io_dev.o prom.o fetch.o clk_delay.o sram.o\
	$(FPU_SIM:%=%.o)
ISE_VHDL = $(FPU) std_logic_1164_additional 
VSIM_VHDL = $(FPU_SIM) std_logic_1164_additional 
ISE_SPACE = ../ise_space
VSIM_SPACE = ../vsim_space
CC = gcc
CFLAGS = -Wall -O2
		
TMPL_DIR = ./tmpl

TIME = 100us

.SUFFIXES: .vhd .vcd .tmp
.PHONY: default wave vcd reload

default: ocore read_float

ocore :
	make -C tmpl ocore
ise :
	make -sC tmpl ise
	cp $(ISE_VHDL:%=%.vhd) $(ISE_SPACE)
vsim :
	make -sC tmpl vsim
	cp $(VSIM_VHDL:%=%.vhd) $(VSIM_SPACE)

wave:
	gtkwave -o $(TB).vcd
vcd : $(TB).vcd

TARGET = $(TB)
IEEE = 'synopsys'
OPTION = -fexplicit
$(TB).vcd: $(TB)
	ghdl -r $(TB) --vcd=$@ --stop-time=$(TIME)
$(TB): $(OBJS)
	ghdl -e --ieee=$(IEEE) $(OPTION) $(TB)
.vhd.o:
	ghdl -a --ieee=$(IEEE) $(OPTION) $<

asm:
	make -sC $(TMPL_DIR) asm
sim:
	make -sC $(TMPL_DIR) sim

clean:
	rm -f *.s *.o *.vcd *.cf $(TB)
