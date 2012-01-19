

TARGET = as/fib
#ASM_FLAG = 
# -h or -b


.PHONY: asm sim debug

sim: $(TARGET)
	./simcho $<

lst: $(TARGET)
	./sim_with_list $<

$(TARGET): $(TARGET).s
	./asmcho $<

asm: $(TARGET).s
	./asmcho $<

debug: $(TARGET)
	./debug_sim $<
	
