min-rt:
	cat lib_ml.ml globals.ml min-rt.ml > tmp.ml
	../min-caml tmp
	#cat macro.s tmp.s lib_asm.s > min-rt.s
	javac Merge.java
	java Merge min-rt.s lib_asm.s tmp.s
	rm tmp.ml tmp.s
