#!/bin/sh

for i in `seq 0 16`; do
	grep xmm$i x86asm/min-rt.asm | wc 
done
for i in `seq 9 32`; do
	grep FR$i x86asm/min-rt.asm | wc 
done
