RENDER = mako-render
OCORE_DIR = ..
ISE_SPACE = ../../ise_space
VSIM_SPACE = ../../vsim_space
ASM = ./asmcho2_prom10
SIM = ./simcho3

OCORE_MODS = top u232c io_dev core_c clk_gen clk_delay fetch \
			 prom decode reg_dc exec mem_acc sram reg_wb testbench
			
ISE_MODS = ise_top ise_u232c ise_io_dev core_c clk_gen clk_delay fetch \
			decode reg_dc exec mem_acc reg_wb

TARGET = $(OCORE_MODS:%=%.vhd) $(ISE_MODS:%=%.vhd)
SIM_TARGET = ./test

.SUFFIXES: .s
.SUFFIXES: .vhd .tmp

.tmp.vhd:
	@echo '$< ==> $@'
	$(RENDER) $< > $@


.PHONY: all
all: $(TARGET)

ocore: .ocore.stamp
.ocore.stamp: $(OCORE_MODS:%=%.vhd)
	cp $? $(OCORE_DIR)/
	touch ocore.stamp
ise: $(ISE_MODS:%=%.vhd) $(SIM_TARGET).coe
	cp $? $(ISE_SPACE)/
vsim: $(OCORE_MODS:%=%.vhd)
	cp $? $(VSIM_SPACE)/

BASE = skeleton.tmp macro.tmp
CORE_C = decode reg_dc mem_acc clk_gen reg_wb exec core_c top \
	io_dev prom fetch clk_delay sram u232c

decode.vhd: decode.tmp decode_entity.tmp $(BASE)
fetch.vhd: fetch.tmp fetch_entity.tmp $(BASE)
prom.vhd: prom.tmp prom_entity.tmp $(BASE) test
reg_dc.vhd: reg_dc.tmp reg_dc_entity.tmp $(BASE)
reg_wb.vhd: reg_wb.tmp reg_wb_entity.tmp $(BASE)
mem_acc.vhd: mem_acc.tmp mem_acc_entity.tmp $(BASE)
ram.vhd: ram.tmp ram_entity.tmp $(BASE)
exec.vhd: exec.tmp fpu_entity.tmp exec_entity.tmp $(BASE)
clk_gen.vhd: clk_gen.tmp clk_gen_entity.tmp $(BASE)
clk_dly.vhd: clk_dly.tmp clk_dly_entity.tmp $(BASE)
core_c.vhd: core_c.tmp $(CORE_C:%=%_entity.tmp) $(BASE)
top.vhd: top.tmp skeleton_top.tmp $(BASE)
ise_top.vhd: ise_top.tmp skeleton_top.tmp $(BASE)
skeleton_top.tmp: top_entity.tmp io_dev_entity.tmp core_c_entity.tmp $(BASE)
testbench.vhd: testbench.tmp top_entity.tmp sram_entity.tmp $(BASE)
sram.vhd: sram.tmp sram_entity.tmp $(BASE)
u232c.vhd: u232c.tmp $(BASE)
ise_u232c.vhd: ise_u232c.tmp $(BASE)
skeleton_u232c.tmp: u232c_entity.tmp $(BASE)
io_dev.vhd: io_dev.tmp skeleton_io_dev.tmp $(BASE)
ise_io_dev.vhd: ise_io_dev.tmp skeleton_io_dev.tmp $(BASE)
skeleton_io_dev.tmp: contest_sld.txt u232c_entity.tmp io_dev_entity.tmp $(BASE)

.PHONY: asm
asm : $(SIM_TARGET).coe $(SIM_TARGET)

$(SIM_TARGET).coe: $(SIM_TARGET).s
	$(ASM) -coe $<
	mv $(SIM_TARGET) $(SIM_TARGET).coe
	$(ASM) -h $<

$(SIM_TARGET): $(SIM_TARGET).s
	$(ASM) -h $<

sim: $(SIM_TARGET)
	$(ASM) $<.s
	$(SIM) $(SIM_TARGET)
	rm $<

.PHONY: clean
clean:
	$(RM) *.vhd $(SIM_TARGET) $(SIM_TARGET).coe *.lst asmlog
