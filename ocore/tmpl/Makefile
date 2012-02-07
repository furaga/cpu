RENDER = mako-render
TREE = ..

TARGET = decode.vhd fetch.vhd reg_dc.vhd ram.vhd
TARGET += clk_gen.vhd reg_wb.vhd exec.vhd cpu.vhd
SIM_TARGET = ./test

.SUFFIXES: .vhd .tmp
.tmp.vhd:
	@echo '$< ==> $@'
	$(RENDER) $< > $@


all: $(TARGET)

BASE = skeleton.tmp macro.tmp
ENTITIES = decode_entity.tmp fetch_entity.tmp reg_dc_entity.tmp
ENTITIES += reg_wb_entity.tmp ram_entity.tmp exec_entity.tmp
ENTITIES += clk_gen_entity.tmp cpu_entity.tmp
decode.vhd: decode.tmp decode_entity.tmp $(BASE)
fetch.vhd: fetch.tmp fetch_entity.tmp $(BASE) asm
reg_dc.vhd: reg_dc.tmp reg_dc_entity.tmp $(BASE)
reg_wb.vhd: reg_wb.tmp reg_wb_entity.tmp $(BASE)
ram.vhd: ram.tmp ram_entity.tmp $(BASE)
exec.vhd: exec.tmp exec_entity.tmp $(BASE)
clk_gen.vhd: clk_gen.tmp clk_gen_entity.tmp $(BASE)
cpu.vhd: cpu.tmp $(ENTITIES) $(BASE)

.PHONY: push clean
push:
	cp decode.vhd $(TREE)/decode.vhd
	cp fetch.vhd $(TREE)/fetch.vhd
	cp reg_dc.vhd $(TREE)/reg_dc.vhd
	cp reg_wb.vhd $(TREE)/reg_wb.vhd
	cp ram.vhd $(TREE)/ram.vhd
	cp cpu.vhd $(TREE)/cpu.vhd
	cp exec.vhd $(TREE)/exec.vhd
	cp clk_gen.vhd $(TREE)/clk_gen.vhd

out:

ASM = ./asmcho2
asm:
	$(ASM) -h $(SIM_TARGET).s
sim:
	$(ASM) $(SIM_TARGET).s
	./simcho $(SIM_TARGET)

clean:
	$(RM) *.vhd
