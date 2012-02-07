RENDER = mako-render
TREE = ..

TARGET = decode.vhd
SIM_TARGET = ./test

.SUFFIXES: .vhd .tmp
.tmp.vhd:
	@echo '$< ==> $@'
	$(RENDER) $< > $@


all: $(TARGET)

BASE = skeleton.tmp macro.tmp
decode.vhd: decode.tmp decode_entity.tmp $(BASE)

.PHONY: push clean
push:
	cp 

out:

asm:
	./asmcho -h $(SIM_TARGET).s
sim:
	./asmcho $(SIM_TARGET).s
	./simcho $(SIM_TARGET)

clean:
	$(RM) *.vhd
