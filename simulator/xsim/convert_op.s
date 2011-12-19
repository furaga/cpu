	.file	"convert_op.c"
	.globl	fg
	.section	.rodata
.LC0:
	.string	"%s %%g%d"
	.data
	.align 8
	.type	fg, @object
	.size	fg, 8
fg:
	.quad	.LC0
	.globl	fl
	.section	.rodata
.LC1:
	.string	"%s %s"
	.data
	.align 8
	.type	fl, @object
	.size	fl, 8
fl:
	.quad	.LC1
	.globl	fgi
	.section	.rodata
.LC2:
	.string	"%s %%g%d, %d"
	.data
	.align 8
	.type	fgi, @object
	.size	fgi, 8
fgi:
	.quad	.LC2
	.globl	fgl
	.section	.rodata
.LC3:
	.string	"%s %%g%d, %s"
	.data
	.align 8
	.type	fgl, @object
	.size	fgl, 8
fgl:
	.quad	.LC3
	.globl	fgg
	.section	.rodata
.LC4:
	.string	"%s %%g%d, %%g%d"
	.data
	.align 8
	.type	fgg, @object
	.size	fgg, 8
fgg:
	.quad	.LC4
	.globl	fggl
	.section	.rodata
.LC5:
	.string	"%s %%g%d, %%g%d, %s"
	.data
	.align 8
	.type	fggl, @object
	.size	fggl, 8
fggl:
	.quad	.LC5
	.globl	fggi
	.section	.rodata
.LC6:
	.string	"%s %%g%d, %%g%d, %d"
	.data
	.align 8
	.type	fggi, @object
	.size	fggi, 8
fggi:
	.quad	.LC6
	.globl	fggg
	.section	.rodata
.LC7:
	.string	"%s %%g%d, %%g%d, %%g%d"
	.data
	.align 8
	.type	fggg, @object
	.size	fggg, 8
fggg:
	.quad	.LC7
	.globl	ff
	.section	.rodata
.LC8:
	.string	"%s %%f%d"
	.data
	.align 8
	.type	ff, @object
	.size	ff, 8
ff:
	.quad	.LC8
	.globl	fff
	.section	.rodata
.LC9:
	.string	"%s %%f%d, %%f%d"
	.data
	.align 8
	.type	fff, @object
	.size	fff, 8
fff:
	.quad	.LC9
	.globl	fgf
	.section	.rodata
.LC10:
	.string	"%s %%g%d, %%f%d"
	.data
	.align 8
	.type	fgf, @object
	.size	fgf, 8
fgf:
	.quad	.LC10
	.globl	ffg
	.section	.rodata
.LC11:
	.string	"%s %%f%d, %%g%d"
	.data
	.align 8
	.type	ffg, @object
	.size	ffg, 8
ffg:
	.quad	.LC11
	.globl	fffl
	.section	.rodata
.LC12:
	.string	"%s %%f%d, %%f%d, %s"
	.data
	.align 8
	.type	fffl, @object
	.size	fffl, 8
fffl:
	.quad	.LC12
	.globl	ffff
	.section	.rodata
.LC13:
	.string	"%s %%f%d, %%f%d, %%f%d"
	.data
	.align 8
	.type	ffff, @object
	.size	ffff, 8
ffff:
	.quad	.LC13
	.globl	ffgi
	.section	.rodata
.LC14:
	.string	"%s %%f%d, %%g%d, %d"
	.data
	.align 8
	.type	ffgi, @object
	.size	ffgi, 8
ffgi:
	.quad	.LC14
	.section	.rodata
.LC15:
	.string	"mov"
.LC16:
	.string	"\t%s\t\t"
.LC17:
	.string	"movl"
.LC18:
	.string	", %s"
.LC19:
	.string	"%eax"
.LC20:
	.string	"%s"
.LC21:
	.string	"mvhi"
.LC22:
	.string	"andl"
.LC23:
	.string	"$%d"
.LC24:
	.string	"orl"
.LC25:
	.string	"mvlo"
.LC26:
	.string	"add"
.LC27:
	.string	"addl"
.LC28:
	.string	"%edx"
.LC29:
	.string	"sub"
.LC30:
	.string	"subl"
.LC31:
	.string	"mul"
.LC32:
	.string	"imull"
.LC33:
	.string	"div"
.LC34:
	.string	"divl"
.LC35:
	.string	"addi"
.LC36:
	.string	"subi"
.LC37:
	.string	"muli"
.LC38:
	.string	"divi"
.LC39:
	.string	"input"
.LC40:
	.string	"xorl"
.LC41:
	.string	"call"
.LC42:
	.string	"InChar"
.LC43:
	.string	"output"
.LC44:
	.string	"OutChar"
.LC45:
	.string	"outputH"
.LC46:
	.string	"PrintHex8"
.LC47:
	.string	"outputF"
.LC48:
	.string	"and"
.LC49:
	.string	"or"
.LC50:
	.string	"not"
.LC51:
	.string	"notl"
.LC52:
	.string	"sll"
.LC53:
	.string	"shll"
.LC54:
	.string	"srl"
.LC55:
	.string	"shrl"
.LC56:
	.string	"slli"
.LC57:
	.string	"srli"
.LC58:
	.string	"b"
.LC59:
	.string	"jmp *"
.LC60:
	.string	"%rdx"
.LC61:
	.string	"jmp"
.LC62:
	.string	"min_caml_start"
.LC63:
	.string	"jeq"
.LC64:
	.string	"cmpl"
.LC65:
	.string	"je"
.LC66:
	.string	"jne"
.LC67:
	.string	"jlt"
.LC68:
	.string	"jg"
.LC69:
	.string	"jl"
.LC70:
	.string	"jle"
.LC71:
	.string	"cmp"
.LC72:
	.string	"callR"
.LC73:
	.string	"call *"
.LC74:
	.string	"return"
.LC75:
	.string	"ret"
.LC76:
	.string	"ldi"
.LC77:
	.string	"-%d("
.LC78:
	.string	"-%d(%s)"
.LC79:
	.string	"ld"
.LC80:
	.string	"%ebx"
.LC81:
	.string	"%%eax(GR1)"
.LC82:
	.string	"st"
.LC83:
	.string	", %%eax("
.LC84:
	.string	", %%eax"
.LC85:
	.string	"sti"
.LC86:
	.string	", -%d("
.LC87:
	.string	")"
.LC88:
	.string	", -%d(%s)"
.LC89:
	.string	"fadd"
.LC90:
	.string	"addss"
.LC91:
	.string	"movss"
.LC92:
	.string	"%xmm15"
.LC93:
	.string	"fsub"
.LC94:
	.string	"subss"
.LC95:
	.string	"fmul"
.LC96:
	.string	"mulss"
.LC97:
	.string	"fdiv"
.LC98:
	.string	"movd"
.LC99:
	.string	"FInv"
.LC100:
	.string	"divss"
.LC101:
	.string	"fsqrt"
.LC102:
	.string	"FSqrt"
.LC103:
	.string	"sqrtss"
.LC104:
	.string	"fabs"
.LC105:
	.string	"fmov"
.LC106:
	.string	"fneg"
.LC107:
	.string	"fld"
.LC108:
	.string	"fst"
.LC109:
	.string	"fjeq"
.LC110:
	.string	"comiss"
.LC111:
	.string	"flds"
.LC112:
	.string	"fcompp"
.LC113:
	.string	"fnstsw"
.LC114:
	.string	"%ax"
.LC115:
	.string	"sahf"
.LC116:
	.string	"fjlt"
.LC117:
	.string	"jb"
.LC118:
	.string	"nop"
.LC119:
	.string	"halt"
.LC120:
	.string	"NewLine"
.LC121:
	.string	"movq"
.LC122:
	.string	"(CNT)"
.LC123:
	.string	"%rax"
.LC124:
	.string	"PrintHex16"
.LC125:
	.string	"Exit"
.LC126:
	.string	"setL"
.LC127:
	.string	"$%s"
	.text
	.globl	convert_op
	.type	convert_op, @function
convert_op:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$576, %rsp
	movq	%rdi, -568(%rbp)
	movq	%rsi, -576(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -540(%rbp)
	movl	-540(%rbp), %eax
	movl	%eax, -536(%rbp)
	movl	-536(%rbp), %eax
	movl	%eax, -532(%rbp)
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC15, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L2
	movq	fgg(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L2
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L3
	movl	-556(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L4
.L3:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L5
.L4:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L5:
	movl	$0, %eax
	jmp	.L6
.L2:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC21, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L7
	movq	fgi(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-544(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L7
	movl	$.LC16, %eax
	movl	$.LC22, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC23, %eax
	movl	$65535, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC24, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %eax
	movl	%eax, %edx
	sall	$16, %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	jmp	.L6
.L7:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC25, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L8
	movq	fgi(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-544(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L8
	movl	$.LC16, %eax
	movl	$.LC22, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC23, %eax
	movl	$-65536, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC24, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %eax
	movzwl	%ax, %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	jmp	.L6
.L8:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC26, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L9
	movq	fggg(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L9
	movl	-556(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L10
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L11
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L10
.L11:
	movl	$.LC16, %eax
	movl	$.LC27, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L12
.L10:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC27, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L12:
	movl	$0, %eax
	jmp	.L6
.L9:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC29, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L13
	movq	fggg(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L13
	movl	-556(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L14
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L15
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L14
.L15:
	movl	$.LC16, %eax
	movl	$.LC30, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L16
.L14:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC30, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L16:
	movl	$0, %eax
	jmp	.L6
.L13:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC31, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L17
	movq	fggg(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L17
	movl	-556(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L18
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L19
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L18
.L19:
	movl	$.LC16, %eax
	movl	$.LC32, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L20
.L18:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC32, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L20:
	movl	$0, %eax
	jmp	.L6
.L17:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC33, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L21
	movq	fggg(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L21
	movl	-556(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L22
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L23
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L22
.L23:
	movl	$.LC16, %eax
	movl	$.LC34, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L24
.L22:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC34, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L24:
	movl	$0, %eax
	jmp	.L6
.L21:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC35, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L25
	movq	fggi(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L25
	movl	-552(%rbp), %eax
	testl	%eax, %eax
	jne	.L26
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L27
.L26:
	movl	-548(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L28
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L29
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L28
.L29:
	movl	$.LC16, %eax
	movl	$.LC27, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L27
.L28:
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L30
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L31
.L30:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC27, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L27
.L31:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC27, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L27:
	movl	$0, %eax
	jmp	.L6
.L25:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC36, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L32
	movq	fggi(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L32
	movl	-548(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L33
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L34
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L33
.L34:
	movl	$.LC16, %eax
	movl	$.LC30, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L35
.L33:
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L36
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L37
.L36:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC30, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L35
.L37:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC30, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L35:
	movl	$0, %eax
	jmp	.L6
.L32:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC37, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L38
	movq	fggi(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L38
	movl	-548(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L39
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L40
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L39
.L40:
	movl	$.LC16, %eax
	movl	$.LC32, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L41
.L39:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC32, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L41:
	movl	$0, %eax
	jmp	.L6
.L38:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC38, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L42
	movq	fggi(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L42
	movl	-548(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L43
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L44
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L43
.L44:
	movl	$.LC16, %eax
	movl	$.LC34, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L45
.L43:
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L46
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L47
.L46:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC34, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L45
.L47:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC34, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L45:
	movl	$0, %eax
	jmp	.L6
.L42:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC39, %eax
	movl	$6, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L48
	movq	fg(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L48
	movl	$.LC16, %eax
	movl	$.LC40, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC41, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC42, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	jmp	.L6
.L48:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC43, %eax
	movl	$7, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L49
	movq	fg(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L49
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC41, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC44, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	jmp	.L6
.L49:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC45, %eax
	movl	$8, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L50
	movq	fg(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L50
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC41, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC46, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	jmp	.L6
.L50:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC47, %eax
	movl	$8, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L51
	movq	ff(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L51
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC41, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC46, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	jmp	.L6
.L51:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC48, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L52
	movq	fggg(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L52
	movl	-556(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L53
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L54
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L53
.L54:
	movl	$.LC16, %eax
	movl	$.LC22, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L55
.L53:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC22, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L55:
	movl	$0, %eax
	jmp	.L6
.L52:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC49, %eax
	movl	$3, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L56
	movq	fggg(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L56
	movl	-556(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L57
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L58
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L57
.L58:
	movl	$.LC16, %eax
	movl	$.LC24, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L59
.L57:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC24, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L59:
	movl	$0, %eax
	jmp	.L6
.L56:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC50, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L60
	movq	fgg(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L60
	movl	-556(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L61
	movl	$.LC16, %eax
	movl	$.LC51, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L62
.L61:
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L63
	movl	-556(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L64
.L63:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC51, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L62
.L64:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC51, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L62:
	movl	$0, %eax
	jmp	.L6
.L60:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC52, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L65
	movq	fggg(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L65
	movl	-556(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L66
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L67
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L66
.L67:
	movl	$.LC16, %eax
	movl	$.LC53, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L68
.L66:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC53, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L68:
	movl	$0, %eax
	jmp	.L6
.L65:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC54, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L69
	movq	fggg(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L69
	movl	-556(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L70
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L71
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L70
.L71:
	movl	$.LC16, %eax
	movl	$.LC55, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L72
.L70:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC55, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L72:
	movl	$0, %eax
	jmp	.L6
.L69:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC56, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L73
	movq	fggi(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L73
	movl	-548(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L74
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L75
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L74
.L75:
	movl	$.LC16, %eax
	movl	$.LC53, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L76
.L74:
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L77
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L78
.L77:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC53, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L76
.L78:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC53, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L76:
	movl	$0, %eax
	jmp	.L6
.L73:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC57, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L79
	movq	fggi(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L79
	movl	-548(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L80
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L81
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L80
.L81:
	movl	$.LC16, %eax
	movl	$.LC55, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L82
.L80:
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L83
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L84
.L83:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC55, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L82
.L84:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC55, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC23, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L82:
	movl	$0, %eax
	jmp	.L6
.L79:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC58, %eax
	movl	$2, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L85
	movq	fg(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L85
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L86
	movl	$.LC16, %eax
	movl	$.LC59, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$1, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L87
.L86:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC59, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC60, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
.L87:
	movl	$0, %eax
	jmp	.L6
.L85:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC61, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L88
	movq	fl(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-272(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L88
	leaq	-272(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC62, %eax
	movl	$15, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	je	.L89
	movl	$.LC16, %eax
	movl	$.LC61, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	jmp	.L6
.L89:
	movl	$0, %eax
	jmp	.L6
.L88:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC63, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L90
	movq	fggl(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-272(%rbp), %r8
	leaq	-548(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L90
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC64, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC65, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	jmp	.L6
.L90:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC66, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L91
	movq	fggl(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-272(%rbp), %r8
	leaq	-548(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L91
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L92
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L93
.L92:
	movl	$.LC16, %eax
	movl	$.LC64, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC66, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	jmp	.L94
.L93:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC64, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC66, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
.L94:
	movl	$0, %eax
	jmp	.L6
.L91:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC67, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L95
	movq	fggl(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-272(%rbp), %r8
	leaq	-548(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L95
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	jne	.L96
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L97
.L96:
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_const
	testl	%eax, %eax
	je	.L98
	movl	$.LC16, %eax
	movl	$.LC64, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC68, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	jmp	.L100
.L98:
	movl	$.LC16, %eax
	movl	$.LC64, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC69, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	jmp	.L100
.L97:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC64, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC69, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
.L100:
	movl	$0, %eax
	jmp	.L6
.L95:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC70, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L101
	movq	fggl(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-272(%rbp), %r8
	leaq	-548(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L101
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC71, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC70, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	jmp	.L6
.L101:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC41, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L102
	movq	fl(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-272(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L102
	movl	$.LC16, %eax
	movl	$.LC41, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	jmp	.L6
.L102:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC72, %eax
	movl	$6, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L103
	movq	fg(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L103
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L104
	movl	$.LC16, %eax
	movl	$.LC73, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$1, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L105
.L104:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC73, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC60, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
.L105:
	movl	$0, %eax
	jmp	.L6
.L103:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC74, %eax
	movl	$7, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L106
	movl	$.LC16, %eax
	movl	$.LC75, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	jmp	.L6
.L106:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC76, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L107
	movq	fggi(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L107
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L108
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L108
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC77, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$41, %edi
	call	putchar
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L109
.L108:
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L110
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %ecx
	movl	$.LC78, %eax
	movl	$.LC28, %edx
	movl	%ecx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	jmp	.L109
.L110:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %ecx
	movl	$.LC78, %eax
	movl	$.LC28, %edx
	movl	%ecx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L109:
	movl	$0, %eax
	jmp	.L6
.L107:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC79, %eax
	movl	$3, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L111
	movq	fggg(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L111
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC80, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC81, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	jmp	.L6
.L111:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC82, %eax
	movl	$3, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L112
	movq	fggg(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L112
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC80, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L113
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC80, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC83, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$41, %edi
	call	putchar
	movl	$10, %edi
	call	putchar
	jmp	.L114
.L113:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC80, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC84, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
.L114:
	movl	$0, %eax
	jmp	.L6
.L112:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC85, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L115
	movq	fggi(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L115
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L116
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L116
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-544(%rbp), %edx
	movl	$.LC86, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC87, %edi
	call	puts
	jmp	.L117
.L116:
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L118
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	-544(%rbp), %ecx
	movl	$.LC88, %eax
	movl	$.LC19, %edx
	movl	%ecx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	jmp	.L117
.L118:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %ecx
	movl	$.LC88, %eax
	movl	$.LC19, %edx
	movl	%ecx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
.L117:
	movl	$0, %eax
	jmp	.L6
.L115:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC89, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L119
	movq	ffff(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L119
	movl	-556(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L120
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L120
	movl	$.LC16, %eax
	movl	$.LC90, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	-552(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	jmp	.L121
.L120:
	movl	-556(%rbp), %edx
	movl	-548(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L122
	movl	-556(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L122
	movl	$.LC16, %eax
	movl	$.LC90, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	-556(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	jmp	.L121
.L122:
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC90, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
.L121:
	movl	$0, %eax
	jmp	.L6
.L119:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC93, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L123
	movq	ffff(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L123
	movl	-556(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L124
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L124
	movl	$.LC16, %eax
	movl	$.LC94, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	-552(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	jmp	.L125
.L124:
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC94, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
.L125:
	movl	$0, %eax
	jmp	.L6
.L123:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC95, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L126
	movq	ffff(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L126
	movl	-556(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L127
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L127
	movl	$.LC16, %eax
	movl	$.LC96, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	-552(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	jmp	.L128
.L127:
	movl	-556(%rbp), %edx
	movl	-548(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L129
	movl	-556(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L129
	movl	$.LC16, %eax
	movl	$.LC96, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	-556(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	jmp	.L128
.L129:
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC96, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
.L128:
	movl	$0, %eax
	jmp	.L6
.L126:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC97, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L130
	movq	ffff(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L130
	movl	mathlib_flag(%rip), %eax
	testl	%eax, %eax
	je	.L131
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L132
	movl	$.LC16, %eax
	movl	$.LC98, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	jmp	.L133
.L132:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
.L133:
	movl	$.LC16, %eax
	movl	$.LC41, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC99, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC98, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC96, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	jmp	.L134
.L131:
	movl	-556(%rbp), %edx
	movl	-552(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L135
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L135
	movl	$.LC16, %eax
	movl	$.LC100, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	-552(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	jmp	.L134
.L135:
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC100, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
.L134:
	movl	$0, %eax
	jmp	.L6
.L130:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC101, %eax
	movl	$6, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L136
	movq	fff(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L136
	movl	mathlib_flag(%rip), %eax
	testl	%eax, %eax
	je	.L137
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L138
	movl	$.LC16, %eax
	movl	$.LC98, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	jmp	.L139
.L138:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
.L139:
	movl	$.LC16, %eax
	movl	$.LC41, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC102, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	-556(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L140
	movl	$.LC16, %eax
	movl	$.LC98, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	jmp	.L141
.L140:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	jmp	.L141
.L137:
	movl	-556(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L142
	movl	$.LC16, %eax
	movl	$.LC103, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	-556(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	jmp	.L141
.L142:
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC103, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
.L141:
	movl	$0, %eax
	jmp	.L6
.L136:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC104, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L143
	movq	fff(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L143
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC22, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC23, %eax
	movl	$2147483647, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	jmp	.L6
.L143:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC105, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L144
	movq	fff(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L144
	movl	-556(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L145
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	-556(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	jmp	.L146
.L145:
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L147
	movl	$.LC16, %eax
	movl	$.LC98, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	jmp	.L148
.L147:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
.L148:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
.L146:
	movl	$0, %eax
	jmp	.L6
.L144:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC106, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L149
	movq	fff(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L149
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L150
	movl	$.LC16, %eax
	movl	$.LC98, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	jmp	.L151
.L150:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
.L151:
	movl	$.LC16, %eax
	movl	$.LC40, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC23, %eax
	movl	$-2147483648, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	-556(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L152
	movl	$.LC16, %eax
	movl	$.LC98, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	jmp	.L153
.L152:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
.L153:
	movl	$0, %eax
	jmp	.L6
.L149:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC107, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L154
	movq	ffgi(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L154
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L155
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L156
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %edx
	movl	$.LC77, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$41, %edi
	call	putchar
	movl	-548(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	jmp	.L157
.L156:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %ecx
	movl	$.LC78, %eax
	movl	$.LC28, %edx
	movl	%ecx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	jmp	.L157
.L155:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %ecx
	movl	$.LC78, %eax
	movl	$.LC28, %edx
	movl	%ecx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
.L157:
	movl	$0, %eax
	jmp	.L6
.L154:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC108, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L158
	movq	ffgi(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L158
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L159
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xreg
	testl	%eax, %eax
	je	.L160
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	-544(%rbp), %edx
	movl	$.LC86, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC87, %edi
	call	puts
	jmp	.L161
.L160:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	-544(%rbp), %ecx
	movl	$.LC88, %eax
	movl	$.LC19, %edx
	movl	%ecx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	jmp	.L161
.L159:
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$.LC18, %eax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-544(%rbp), %ecx
	movl	$.LC88, %eax
	movl	$.LC19, %edx
	movl	%ecx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
.L161:
	movl	$0, %eax
	jmp	.L6
.L158:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC109, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L162
	movq	fffl(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-272(%rbp), %r8
	leaq	-548(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L162
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L163
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L163
	movl	$.LC16, %eax
	movl	$.LC110, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	-552(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC65, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	jmp	.L164
.L163:
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L165
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC110, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC65, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	jmp	.L164
.L165:
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L166
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC110, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC65, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	jmp	.L164
.L166:
	movl	$.LC16, %eax
	movl	$.LC111, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC111, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC112, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC113, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC114, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC115, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC65, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
.L164:
	movl	$0, %eax
	jmp	.L6
.L162:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC116, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L167
	movq	fffl(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-272(%rbp), %r8
	leaq	-548(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L167
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L168
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L168
	movl	$.LC16, %eax
	movl	$.LC110, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	-552(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC117, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	jmp	.L169
.L168:
	movl	-552(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L170
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC110, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC117, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	jmp	.L169
.L170:
	movl	-548(%rbp), %eax
	movl	%eax, %edi
	call	is_xmm
	testl	%eax, %eax
	je	.L171
	movl	$.LC16, %eax
	movl	$.LC91, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC110, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$.LC18, %eax
	movl	$.LC92, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC117, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	jmp	.L169
.L171:
	movl	$.LC16, %eax
	movl	$.LC111, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-548(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC111, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-552(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	print_fr
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC112, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC113, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC114, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC115, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC117, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
.L169:
	movl	$0, %eax
	jmp	.L6
.L167:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC118, %eax
	movl	$4, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L172
	movl	$.LC16, %eax
	movl	$.LC118, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	jmp	.L6
.L172:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC119, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L173
	movl	count_flag(%rip), %eax
	testl	%eax, %eax
	je	.L174
	movl	$.LC16, %eax
	movl	$.LC41, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC120, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC121, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC122, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC18, %eax
	movl	$.LC123, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC41, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC124, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$.LC16, %eax
	movl	$.LC41, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC120, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
.L174:
	movl	$.LC16, %eax
	movl	$.LC41, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC20, %eax
	movl	$.LC125, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	jmp	.L6
.L173:
	movq	-568(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC126, %eax
	movl	$5, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L175
	movq	fgl(%rip), %rsi
	movq	-576(%rbp), %rax
	leaq	-272(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L175
	movl	$.LC16, %eax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC127, %eax
	leaq	-272(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-556(%rbp), %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	print_gr
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	jmp	.L6
.L175:
	movl	$-1, %eax
.L6:
	movq	-8(%rbp), %rsi
	xorq	%fs:40, %rsi
	je	.L176
	call	__stack_chk_fail
.L176:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	convert_op, .-convert_op
	.section	.rodata
.LC128:
	.string	""
.LC129:
	.string	"d"
.LC130:
	.string	"r"
.LC131:
	.string	"e"
.LC132:
	.string	", "
.LC133:
	.string	"%%eax"
.LC134:
	.string	"$0"
.LC135:
	.string	"$1"
.LC136:
	.string	"$-1"
.LC137:
	.string	"%%r8%s"
.LC138:
	.string	"%%r9%s"
.LC139:
	.string	"%%r10%s"
.LC140:
	.string	"%%r11%s"
.LC141:
	.string	"%%r12%s"
.LC142:
	.string	"%%r13%s"
.LC143:
	.string	"%%r14%s"
.LC144:
	.string	"%%r15%s"
.LC145:
	.string	"%%%sbx"
.LC146:
	.string	"%%%scx"
.LC147:
	.string	"%%%ssi"
.LC148:
	.string	"%%%sdi"
.LC149:
	.string	"%%%sbp"
.LC150:
	.string	"(GR%d)"
	.text
	.globl	print_gr
	.type	print_gr, @function
print_gr:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	%esi, -24(%rbp)
	movl	%edx, -28(%rbp)
	cmpl	$0, -28(%rbp)
	je	.L178
	movl	$.LC128, %eax
	jmp	.L179
.L178:
	movl	$.LC129, %eax
.L179:
	movq	%rax, -16(%rbp)
	cmpl	$0, -28(%rbp)
	je	.L180
	movl	$.LC130, %eax
	jmp	.L181
.L180:
	movl	$.LC131, %eax
.L181:
	movq	%rax, -8(%rbp)
	cmpl	$0, -24(%rbp)
	je	.L182
	movl	$.LC132, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	is_const
	testl	%eax, %eax
	je	.L182
	movl	$.LC133, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L177
.L182:
	cmpl	$31, -20(%rbp)
	ja	.L184
	mov	-20(%rbp), %eax
	movq	.L201(,%rax,8), %rax
	jmp	*%rax
	.section	.rodata
	.align 8
	.align 4
.L201:
	.quad	.L185
	.quad	.L186
	.quad	.L187
	.quad	.L188
	.quad	.L189
	.quad	.L190
	.quad	.L191
	.quad	.L192
	.quad	.L193
	.quad	.L194
	.quad	.L195
	.quad	.L196
	.quad	.L184
	.quad	.L184
	.quad	.L184
	.quad	.L184
	.quad	.L184
	.quad	.L184
	.quad	.L184
	.quad	.L184
	.quad	.L184
	.quad	.L184
	.quad	.L184
	.quad	.L184
	.quad	.L184
	.quad	.L184
	.quad	.L197
	.quad	.L184
	.quad	.L198
	.quad	.L199
	.quad	.L184
	.quad	.L200
	.text
.L185:
	movl	$.LC134, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L177
.L198:
	movl	$.LC135, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L177
.L199:
	movl	$.LC136, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L177
.L197:
	movl	$.LC137, %eax
	movq	-16(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L177
.L186:
	movl	$.LC138, %eax
	movq	-16(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L177
.L200:
	movl	$.LC139, %eax
	movq	-16(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L177
.L188:
	movl	$.LC140, %eax
	movq	-16(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L177
.L187:
	movl	$.LC141, %eax
	movq	-16(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L177
.L189:
	movl	$.LC142, %eax
	movq	-16(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L177
.L190:
	movl	$.LC143, %eax
	movq	-16(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L177
.L194:
	movl	$.LC144, %eax
	movq	-16(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L177
.L191:
	movl	$.LC145, %eax
	movq	-8(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L177
.L195:
	movl	$.LC146, %eax
	movq	-8(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L177
.L196:
	movl	$.LC147, %eax
	movq	-8(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L177
.L192:
	movl	$.LC148, %eax
	movq	-8(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L177
.L193:
	movl	$.LC149, %eax
	movq	-8(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L177
.L184:
	movl	$.LC150, %eax
	movl	-20(%rbp), %edx
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	nop
.L177:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	print_gr, .-print_gr
	.section	.rodata
.LC151:
	.string	"%%xmm0"
.LC152:
	.string	"%%xmm1"
.LC153:
	.string	"%%xmm2"
.LC154:
	.string	"%%xmm3"
.LC155:
	.string	"%%xmm4"
.LC156:
	.string	"%%xmm5"
.LC157:
	.string	"%%xmm6"
.LC158:
	.string	"%%xmm7"
.LC159:
	.string	"%%xmm8"
.LC160:
	.string	"%%xmm9"
.LC161:
	.string	"%%xmm10"
.LC162:
	.string	"%%xmm11"
.LC163:
	.string	"%%xmm12"
.LC164:
	.string	"%%xmm13"
.LC165:
	.string	"%%xmm14"
.LC166:
	.string	"(FR%d)"
	.text
	.globl	print_fr
	.type	print_fr, @function
print_fr:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	cmpl	$0, -8(%rbp)
	je	.L203
	movl	$.LC132, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
.L203:
	cmpl	$31, -4(%rbp)
	ja	.L204
	mov	-4(%rbp), %eax
	movq	.L220(,%rax,8), %rax
	jmp	*%rax
	.section	.rodata
	.align 8
	.align 4
.L220:
	.quad	.L205
	.quad	.L206
	.quad	.L207
	.quad	.L208
	.quad	.L209
	.quad	.L210
	.quad	.L211
	.quad	.L212
	.quad	.L213
	.quad	.L214
	.quad	.L204
	.quad	.L204
	.quad	.L215
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L216
	.quad	.L204
	.quad	.L217
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L218
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L219
	.text
.L205:
	movl	$.LC151, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L202
.L206:
	movl	$.LC152, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L202
.L207:
	movl	$.LC153, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L202
.L215:
	movl	$.LC154, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L202
.L213:
	movl	$.LC155, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L202
.L217:
	movl	$.LC156, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L202
.L208:
	movl	$.LC157, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L202
.L218:
	movl	$.LC158, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L202
.L219:
	movl	$.LC159, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L202
.L209:
	movl	$.LC160, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L202
.L214:
	movl	$.LC161, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L202
.L210:
	movl	$.LC162, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L202
.L216:
	movl	$.LC163, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L202
.L212:
	movl	$.LC164, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L202
.L211:
	movl	$.LC165, %eax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L202
.L204:
	movl	$.LC166, %eax
	movl	-4(%rbp), %edx
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	nop
.L202:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	print_fr, .-print_fr
	.globl	is_const
	.type	is_const, @function
is_const:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	cmpl	$0, -4(%rbp)
	je	.L223
	cmpl	$28, -4(%rbp)
	je	.L223
	cmpl	$29, -4(%rbp)
	jne	.L224
.L223:
	movl	$1, %eax
	jmp	.L225
.L224:
	movl	$0, %eax
.L225:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	is_const, .-is_const
	.globl	is_xreg
	.type	is_xreg, @function
is_xreg:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$72, %rsp
	movl	%edi, -68(%rbp)
	movl	$3, -64(%rbp)
	movl	$1, -60(%rbp)
	movl	$26, -56(%rbp)
	movl	$7, -52(%rbp)
	movl	$31, -48(%rbp)
	movl	$6, -44(%rbp)
	movl	$9, -40(%rbp)
	movl	$4, -36(%rbp)
	movl	$5, -32(%rbp)
	movl	$10, -28(%rbp)
	movl	$2, -24(%rbp)
	movl	$11, -20(%rbp)
	movl	$8, -16(%rbp)
	movl	-68(%rbp), %eax
	movl	%eax, %edi
	call	is_const
	testl	%eax, %eax
	je	.L227
	movl	$1, %eax
	jmp	.L228
.L227:
	movl	$0, -4(%rbp)
	jmp	.L229
.L231:
	movl	-4(%rbp), %eax
	cltq
	movl	-64(%rbp,%rax,4), %eax
	cmpl	-68(%rbp), %eax
	jne	.L230
	movl	$1, %eax
	jmp	.L228
.L230:
	addl	$1, -4(%rbp)
.L229:
	cmpl	$12, -4(%rbp)
	jle	.L231
	movl	$0, %eax
.L228:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	is_xreg, .-is_xreg
	.globl	is_xmm
	.type	is_xmm, @function
is_xmm:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -68(%rbp)
	movl	$0, -64(%rbp)
	movl	$1, -60(%rbp)
	movl	$3, -56(%rbp)
	movl	$6, -52(%rbp)
	movl	$2, -48(%rbp)
	movl	$7, -44(%rbp)
	movl	$5, -40(%rbp)
	movl	$4, -36(%rbp)
	movl	$8, -32(%rbp)
	movl	$12, -28(%rbp)
	movl	$18, -24(%rbp)
	movl	$22, -20(%rbp)
	movl	$31, -16(%rbp)
	movl	$9, -12(%rbp)
	movl	$16, -8(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L233
.L236:
	movl	-4(%rbp), %eax
	cltq
	movl	-64(%rbp,%rax,4), %eax
	cmpl	-68(%rbp), %eax
	jne	.L234
	movl	$1, %eax
	jmp	.L235
.L234:
	addl	$1, -4(%rbp)
.L233:
	cmpl	$14, -4(%rbp)
	jle	.L236
	movl	$0, %eax
.L235:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	is_xmm, .-is_xmm
	.ident	"GCC: (Ubuntu/Linaro 4.6.1-9ubuntu3) 4.6.1"
	.section	.note.GNU-stack,"",@progbits
