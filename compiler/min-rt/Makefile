min-rt:
	cat lib_ml.ml globals.ml min-rt.ml > tmp.ml
	../min-caml.opt -inline 50 tmp
	#cat macro.s tmp.s lib_asm.s > min-rt.s
	cat tmp.s > min-rt.s
	rm tmp.ml tmp.s
