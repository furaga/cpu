TARGET = test2
#ASM_FLAG = -b
# -h or -b


.PHONY: asm sim debug

sim: $(TARGET)
	./simcho $<

lst: $(TARGET)
	./sim_with_list $<

$(TARGET): $(TARGET).s
	./asmcho $(ASM_FLAG) $<

asm: $(TARGET).s
	./asmcho $(ASM_FLAG) $<

debug: $(TARGET)
	./debug_sim $<
	
