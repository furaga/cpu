

TARGET = as/fib
#ASM_FLAG = 
# -h or -b


.PHONY: asm sim debug

sim: $(TARGET)
	./simcho $<

$(TARGET): $(TARGET).s
	./asmcho $<

asm: $(TARGET).s
	./asmcho $<

debug: $(TARGET)
	./debug_sim $<
	
