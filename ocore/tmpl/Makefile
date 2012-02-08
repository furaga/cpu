RENDER = mako-render
OCORE_DIR = ..

MODULES = decode fetch reg_dc ram clk_gen reg_wb exec core_c top \
	io_dev

TARGET = $(MODULES:%=%.vhd)
SIM_TARGET = ./test

.SUFFIXES: .vhd .tmp
.tmp.vhd:
	@echo '$< ==> $@'
	$(RENDER) $< > $@
	cp $@ $(OCORE_DIR)/


.PHONY: all
all: $(TARGET)

BASE = skeleton.tmp macro.tmp
ENTITIES = $(MODULES:%=%_entity.tmp)

decode.vhd: decode.tmp decode_entity.tmp $(BASE)
fetch.vhd: fetch.tmp fetch_entity.tmp $(BASE) asm
reg_dc.vhd: reg_dc.tmp reg_dc_entity.tmp $(BASE)
reg_wb.vhd: reg_wb.tmp reg_wb_entity.tmp $(BASE)
ram.vhd: ram.tmp ram_entity.tmp $(BASE)
exec.vhd: exec.tmp exec_entity.tmp $(BASE)
clk_gen.vhd: clk_gen.tmp clk_gen_entity.tmp $(BASE)
core_c.vhd: core_c.tmp $(ENTITIES) $(BASE)
top.vhd: top.tmp top_entity.tmp core_c_entity.tmp io_dev_entity.tmp $(BASE)
io_dev.vhd: io_dev.tmp io_dev_entity.tmp $(BASE)

ASM = ./asmcho3
SIM = ./simcho2
asm:
	$(ASM) -h $(SIM_TARGET).s
sim:
	$(ASM) $(SIM_TARGET).s
	$(SIM) $(SIM_TARGET)

.PHONY: clean
clean:
	$(RM) *.vhd
