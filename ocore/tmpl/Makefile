RENDER = mako-render
OCORE_DIR = ..

MODULES = decode reg_dc mem_acc clk_gen reg_wb exec core_c top \
	io_dev prom fetch clk_delay sram

TARGET = $(MODULES:%=%.vhd) testbench.vhd
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
prom.vhd: prom.tmp prom_entity.tmp $(BASE) asm
reg_dc.vhd: reg_dc.tmp reg_dc_entity.tmp $(BASE)
reg_wb.vhd: reg_wb.tmp reg_wb_entity.tmp $(BASE)
mem_acc.vhd: mem_acc.tmp mem_acc_entity.tmp $(BASE)
ram.vhd: ram.tmp ram_entity.tmp $(BASE)
exec.vhd: exec.tmp fpu_entity.tmp exec_entity.tmp $(BASE)
clk_gen.vhd: clk_gen.tmp clk_gen_entity.tmp $(BASE)
clk_dly.vhd: clk_dly.tmp clk_dly_entity.tmp $(BASE)
core_c.vhd: core_c.tmp $(ENTITIES) $(BASE)
top.vhd: top.tmp top_entity.tmp core_c_entity.tmp io_dev_entity.tmp $(BASE)
io_dev.vhd: io_dev.tmp io_dev_entity.tmp $(BASE)
io_dev_word.vhd: io_dev_word.tmp io_dev_entity.tmp $(BASE)
testbench.vhd: testbench.tmp top_entity.tmp sram_entity.tmp $(BASE)
sram.vhd: sram.tmp sram_entity.tmp $(BASE)

ASM = ./asmcho
SIM = ./simcho
ISE_SPACE = ../../ise_space
asm:
	$(ASM) -coe $(SIM_TARGET).s
	cp $(SIM_TARGET) $(ISE_SPACE)/$(SIM_TARGET).coe
	$(ASM) -h $(SIM_TARGET).s

sim:
	$(ASM) $(SIM_TARGET).s
	$(SIM) $(SIM_TARGET)

.PHONY: clean
clean:
	$(RM) *.vhd
