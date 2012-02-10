TB = top_tb
OBJS =\
expo.o\
fpadder.o\
fpu.o\
rom.o\
rom_false.o\
rounding.o\
rshifter.o\
selector.o\
sign.o\
top.o\
top_tb.o

TARGET = $(TB)

IEEE = 'synopsys'
TIME = 10000ns
OPTION = -fexplicit
.SUFFIXES: .vhd .vcd .tmp

.PHONY: default wave vcd reload

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
	rm -f *.o *.vcd *.cf $(TB)
