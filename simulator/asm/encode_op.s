	.file	"encode_op.c"
	.section	.rodata
.LC0:
	.string	"%s %%g%d"
.LC1:
	.string	"%s %s"
.LC2:
	.string	"%s %%g%d, %d"
.LC3:
	.string	"%s %%g%d, %s"
.LC4:
	.string	"%s %%g%d, %%g%d"
.LC5:
	.string	"%s %%g%d, %%g%d, %s"
.LC6:
	.string	"%s %%g%d, %%g%d, %d"
.LC7:
	.string	"%s %%g%d, %%g%d, %%g%d"
.LC8:
	.string	"%s %%f%d, %%f%d"
.LC9:
	.string	"%s %%g%d, %%f%d"
.LC10:
	.string	"%s %%f%d, %%g%d"
.LC11:
	.string	"%s %%f%d, %%f%d, %s"
.LC12:
	.string	"%s %%f%d, %%f%d, %%f%d"
.LC13:
	.string	"%s %%f%d, %%g%d, %d"
.LC14:
	.string	"%s %%f%d, %%g%d, %%g%d"
.LC15:
	.string	"mov"
.LC16:
	.string	"mvhi"
.LC17:
	.string	"mvlo"
.LC18:
	.string	"add"
.LC19:
	.string	"nor"
.LC20:
	.string	"sub"
.LC21:
	.string	"mul"
.LC22:
	.string	"div"
.LC23:
	.string	"addi"
.LC24:
	.string	"subi"
.LC25:
	.string	"muli"
.LC26:
	.string	"divi"
.LC27:
	.string	"input"
.LC28:
	.string	"output"
.LC29:
	.string	"and"
.LC30:
	.string	"or"
.LC31:
	.string	"not"
.LC32:
	.string	"sll"
.LC33:
	.string	"srl"
.LC34:
	.string	"slli"
.LC35:
	.string	"srli"
.LC36:
	.string	"b"
.LC37:
	.string	"jmp"
.LC38:
	.string	"jeq"
.LC39:
	.string	"jne"
.LC40:
	.string	"jlt"
.LC41:
	.string	"jle"
.LC42:
	.string	"call"
.LC43:
	.string	"callR"
.LC44:
	.string	"return"
.LC45:
	.string	"ld"
.LC46:
	.string	"ldi"
.LC47:
	.string	"ldlr"
.LC48:
	.string	"fld"
.LC49:
	.string	"st"
.LC50:
	.string	"sti"
.LC51:
	.string	"stlr"
.LC52:
	.string	"fst"
.LC53:
	.string	"fadd"
.LC54:
	.string	"fsub"
.LC55:
	.string	"fmul"
.LC56:
	.string	"fdiv"
.LC57:
	.string	"fsqrt"
.LC58:
	.string	"fabs"
.LC59:
	.string	"fmov"
.LC60:
	.string	"fneg"
.LC61:
	.string	"fldi"
.LC62:
	.string	"fsti"
.LC63:
	.string	"fjeq"
.LC64:
	.string	"fjlt"
.LC65:
	.string	"nop"
.LC66:
	.string	"halt"
.LC67:
	.string	"setL"
.LC68:
	.string	"padd"
.LC69:
	.string	"link"
.LC70:
	.string	"movlr"
.LC71:
	.string	"btmplr"
	.text
	.globl	encode_op
	.type	encode_op, @function
encode_op:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$704, %rsp
	movq	%rdi, -696(%rbp)
	movq	%rsi, -704(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$.LC0, -680(%rbp)
	movq	$.LC1, -672(%rbp)
	movq	$.LC2, -664(%rbp)
	movq	$.LC3, -656(%rbp)
	movq	$.LC4, -648(%rbp)
	movq	$.LC5, -640(%rbp)
	movq	$.LC6, -632(%rbp)
	movq	$.LC7, -624(%rbp)
	movq	$.LC8, -616(%rbp)
	movq	$.LC9, -608(%rbp)
	movq	$.LC10, -600(%rbp)
	movq	$.LC11, -592(%rbp)
	movq	$.LC12, -584(%rbp)
	movq	$.LC13, -576(%rbp)
	movq	$.LC14, -568(%rbp)
	movl	$0, -540(%rbp)
	movl	-540(%rbp), %eax
	movl	%eax, -536(%rbp)
	movl	-536(%rbp), %eax
	movl	%eax, -532(%rbp)
	movq	-696(%rbp), %rax
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
	movq	-704(%rbp), %rax
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-648(%rbp), %rsi
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L2
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	$0, %esi
	movl	%eax, %edi
	call	mov
	jmp	.L3
.L2:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC16, %eax
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
	jne	.L4
	movq	-704(%rbp), %rax
	leaq	-544(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-664(%rbp), %rsi
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L4
	movl	-544(%rbp), %eax
	movzwl	%ax, %edx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	mvhi
	jmp	.L3
.L4:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC17, %eax
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
	jne	.L5
	movq	-704(%rbp), %rax
	leaq	-544(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-664(%rbp), %rsi
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L5
	movl	-544(%rbp), %eax
	movzwl	%ax, %edx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	mvlo
	jmp	.L3
.L5:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC18, %eax
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
	jne	.L6
	movq	-704(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-624(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L6
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %esi
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	add
	jmp	.L3
.L6:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC19, %eax
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
	jne	.L7
	movq	-704(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-624(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L7
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %esi
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	nor
	jmp	.L3
.L7:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC20, %eax
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
	jne	.L8
	movq	-704(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-624(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L8
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %esi
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	sub
	jmp	.L3
.L8:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC21, %eax
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
	movq	-704(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-624(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L9
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %esi
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	mul
	jmp	.L3
.L9:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC22, %eax
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
	jne	.L10
	movq	-704(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-624(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L10
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %esi
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	_div
	jmp	.L3
.L10:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC23, %eax
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
	jne	.L11
	movq	-704(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-632(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L11
	movl	-544(%rbp), %eax
	movzwl	%ax, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %ecx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	addi
	jmp	.L3
.L11:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC24, %eax
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
	jne	.L12
	movq	-704(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-632(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L12
	movl	-544(%rbp), %eax
	movzwl	%ax, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %ecx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	subi
	jmp	.L3
.L12:
	movq	-696(%rbp), %rax
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
	jne	.L13
	movq	-704(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-632(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L13
	movl	-544(%rbp), %eax
	movzwl	%ax, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %ecx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	muli
	jmp	.L3
.L13:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC26, %eax
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
	jne	.L14
	movq	-704(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-632(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L14
	movl	-544(%rbp), %eax
	movzwl	%ax, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %ecx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	divi
	jmp	.L3
.L14:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC27, %eax
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
	jne	.L15
	movq	-704(%rbp), %rax
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-680(%rbp), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L15
	movl	-556(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edx
	movl	$0, %esi
	movl	$0, %edi
	call	input
	jmp	.L3
.L15:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC28, %eax
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
	jne	.L16
	movq	-704(%rbp), %rax
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-680(%rbp), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L16
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	output
	jmp	.L3
.L16:
	movq	-696(%rbp), %rax
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
	jne	.L17
	movq	-704(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-624(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L17
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %esi
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	_and
	jmp	.L3
.L17:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC30, %eax
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
	jne	.L18
	movq	-704(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-624(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L18
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %esi
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	_or
	jmp	.L3
.L18:
	movq	-696(%rbp), %rax
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
	jne	.L19
	movq	-704(%rbp), %rax
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-648(%rbp), %rsi
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L19
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	$0, %esi
	movl	%eax, %edi
	call	_not
	jmp	.L3
.L19:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC32, %eax
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
	jne	.L20
	movq	-704(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-624(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L20
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %esi
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	sll
	jmp	.L3
.L20:
	movq	-696(%rbp), %rax
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
	movq	-704(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-624(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L21
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %esi
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	srl
	jmp	.L3
.L21:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC34, %eax
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
	jne	.L22
	movq	-704(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-632(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L22
	movl	-544(%rbp), %eax
	movzwl	%ax, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %ecx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	slli
	jmp	.L3
.L22:
	movq	-696(%rbp), %rax
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
	jne	.L23
	movq	-704(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-632(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L23
	movl	-544(%rbp), %eax
	movzwl	%ax, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %ecx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	srli
	jmp	.L3
.L23:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC36, %eax
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
	jne	.L24
	movq	-704(%rbp), %rax
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-680(%rbp), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L24
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	b
	jmp	.L3
.L24:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC37, %eax
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
	jne	.L25
	movq	-704(%rbp), %rax
	leaq	-272(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-672(%rbp), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L25
	leaq	-272(%rbp), %rax
	movl	label_cnt(%rip), %edx
	mov	%edx, %edx
	salq	$8, %rdx
	addq	$label_name, %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	movl	%eax, %edx
	addl	$1, %eax
	movl	%eax, label_cnt(%rip)
	movl	%edx, %edi
	call	jmp
	jmp	.L3
.L25:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC38, %eax
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
	jne	.L26
	movq	-704(%rbp), %rax
	leaq	-272(%rbp), %r8
	leaq	-548(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-640(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L26
	leaq	-272(%rbp), %rax
	movl	label_cnt(%rip), %edx
	mov	%edx, %edx
	salq	$8, %rdx
	addq	$label_name, %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	movl	%eax, %edx
	movzwl	%dx, %edx
	addl	$1, %eax
	movl	%eax, label_cnt(%rip)
	movl	-548(%rbp), %eax
	movzbl	%al, %ecx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	jeq
	jmp	.L3
.L26:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC39, %eax
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
	jne	.L27
	movq	-704(%rbp), %rax
	leaq	-272(%rbp), %r8
	leaq	-548(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-640(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L27
	leaq	-272(%rbp), %rax
	movl	label_cnt(%rip), %edx
	mov	%edx, %edx
	salq	$8, %rdx
	addq	$label_name, %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	movl	%eax, %edx
	movzwl	%dx, %edx
	addl	$1, %eax
	movl	%eax, label_cnt(%rip)
	movl	-548(%rbp), %eax
	movzbl	%al, %ecx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	jne
	jmp	.L3
.L27:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC40, %eax
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
	jne	.L28
	movq	-704(%rbp), %rax
	leaq	-272(%rbp), %r8
	leaq	-548(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-640(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L28
	leaq	-272(%rbp), %rax
	movl	label_cnt(%rip), %edx
	mov	%edx, %edx
	salq	$8, %rdx
	addq	$label_name, %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	movl	%eax, %edx
	movzwl	%dx, %edx
	addl	$1, %eax
	movl	%eax, label_cnt(%rip)
	movl	-548(%rbp), %eax
	movzbl	%al, %ecx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	jlt
	jmp	.L3
.L28:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC41, %eax
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
	jne	.L29
	movq	-704(%rbp), %rax
	leaq	-272(%rbp), %r8
	leaq	-548(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-640(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L29
	leaq	-272(%rbp), %rax
	movl	label_cnt(%rip), %edx
	mov	%edx, %edx
	salq	$8, %rdx
	addq	$label_name, %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	movl	%eax, %edx
	movzwl	%dx, %edx
	addl	$1, %eax
	movl	%eax, label_cnt(%rip)
	movl	-548(%rbp), %eax
	movzbl	%al, %ecx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	jle
	jmp	.L3
.L29:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC42, %eax
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
	jne	.L30
	movq	-704(%rbp), %rax
	leaq	-272(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-672(%rbp), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L30
	leaq	-272(%rbp), %rax
	movl	label_cnt(%rip), %edx
	mov	%edx, %edx
	salq	$8, %rdx
	addq	$label_name, %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	movl	%eax, %edx
	addl	$1, %eax
	movl	%eax, label_cnt(%rip)
	movl	%edx, %edi
	call	call
	jmp	.L3
.L30:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC43, %eax
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
	jne	.L31
	movq	-704(%rbp), %rax
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-680(%rbp), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L31
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	callr
	jmp	.L3
.L31:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC44, %eax
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
	jne	.L32
	movl	$0, %edi
	call	_return
	jmp	.L3
.L32:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC45, %eax
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
	jne	.L33
	movq	-704(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-624(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L33
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %esi
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	ld
	jmp	.L3
.L33:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC46, %eax
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
	jne	.L34
	movq	-704(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-632(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L34
	movl	-544(%rbp), %eax
	movzwl	%ax, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %ecx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	ldi
	jmp	.L3
.L34:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC47, %eax
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
	jne	.L35
	movq	-704(%rbp), %rax
	leaq	-544(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-664(%rbp), %rsi
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L35
	movl	-544(%rbp), %eax
	movzwl	%ax, %edx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	ldlr
	jmp	.L3
.L35:
	movq	-696(%rbp), %rax
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
	jne	.L36
	movq	-704(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-568(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L36
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %esi
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	fld
	jmp	.L3
.L36:
	movq	-696(%rbp), %rax
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
	jne	.L37
	movq	-704(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-624(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L37
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %esi
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	st
	jmp	.L3
.L37:
	movq	-696(%rbp), %rax
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
	jne	.L38
	movq	-704(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-632(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L38
	movl	-544(%rbp), %eax
	movzwl	%ax, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %ecx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	sti
	jmp	.L3
.L38:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC51, %eax
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
	jne	.L39
	movq	-704(%rbp), %rax
	leaq	-544(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-664(%rbp), %rsi
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L39
	movl	-544(%rbp), %eax
	movzwl	%ax, %edx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	stlr
	jmp	.L3
.L39:
	movq	-696(%rbp), %rax
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
	jne	.L40
	movq	-704(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-568(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L40
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %esi
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	fst
	jmp	.L3
.L40:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC53, %eax
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
	jne	.L41
	movq	-704(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-584(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L41
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %esi
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	fadd
	jmp	.L3
.L41:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC54, %eax
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
	movq	-704(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-584(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L42
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %esi
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	fsub
	jmp	.L3
.L42:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC55, %eax
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
	jne	.L43
	movq	-704(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-584(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L43
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %esi
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	fmul
	jmp	.L3
.L43:
	movq	-696(%rbp), %rax
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
	jne	.L44
	movq	-704(%rbp), %rax
	leaq	-548(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-584(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L44
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %esi
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	fdiv
	jmp	.L3
.L44:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC57, %eax
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
	jne	.L45
	movq	-704(%rbp), %rax
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-616(%rbp), %rsi
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L45
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	$0, %esi
	movl	%eax, %edi
	call	fsqrt
	jmp	.L3
.L45:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC58, %eax
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
	jne	.L46
	movq	-704(%rbp), %rax
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-616(%rbp), %rsi
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L46
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	$0, %esi
	movl	%eax, %edi
	call	_fabs
	jmp	.L3
.L46:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC59, %eax
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
	jne	.L47
	movq	-704(%rbp), %rax
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-616(%rbp), %rsi
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L47
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	$0, %esi
	movl	%eax, %edi
	call	fmov
	jmp	.L3
.L47:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC60, %eax
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
	jne	.L48
	movq	-704(%rbp), %rax
	leaq	-552(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-616(%rbp), %rsi
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L48
	movl	-556(%rbp), %eax
	movzbl	%al, %edx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	$0, %ecx
	movl	$0, %esi
	movl	%eax, %edi
	call	fneg
	jmp	.L3
.L48:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC61, %eax
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
	jne	.L49
	movq	-704(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-576(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L49
	movl	-544(%rbp), %eax
	movzwl	%ax, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %ecx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	fldi
	jmp	.L3
.L49:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC62, %eax
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
	jne	.L50
	movq	-704(%rbp), %rax
	leaq	-544(%rbp), %r8
	leaq	-552(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-576(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L50
	movl	-544(%rbp), %eax
	movzwl	%ax, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %ecx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	fsti
	jmp	.L3
.L50:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC63, %eax
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
	jne	.L51
	movq	-704(%rbp), %rax
	leaq	-272(%rbp), %r8
	leaq	-548(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-592(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L51
	leaq	-272(%rbp), %rax
	movl	label_cnt(%rip), %edx
	mov	%edx, %edx
	salq	$8, %rdx
	addq	$label_name, %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	movl	%eax, %edx
	movzwl	%dx, %edx
	addl	$1, %eax
	movl	%eax, label_cnt(%rip)
	movl	-548(%rbp), %eax
	movzbl	%al, %ecx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	fjeq
	jmp	.L3
.L51:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC64, %eax
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
	jne	.L52
	movq	-704(%rbp), %rax
	leaq	-272(%rbp), %r8
	leaq	-548(%rbp), %rdi
	leaq	-552(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-592(%rbp), %rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L52
	leaq	-272(%rbp), %rax
	movl	label_cnt(%rip), %edx
	mov	%edx, %edx
	salq	$8, %rdx
	addq	$label_name, %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	movl	%eax, %edx
	movzwl	%dx, %edx
	addl	$1, %eax
	movl	%eax, label_cnt(%rip)
	movl	-548(%rbp), %eax
	movzbl	%al, %ecx
	movl	-552(%rbp), %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	fjlt
	jmp	.L3
.L52:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC65, %eax
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
	jne	.L53
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movl	$0, %edi
	call	nop
	jmp	.L3
.L53:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC66, %eax
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
	jne	.L54
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movl	$0, %edi
	call	halt
	jmp	.L3
.L54:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC67, %eax
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
	jne	.L55
	movq	-704(%rbp), %rax
	leaq	-272(%rbp), %rdi
	leaq	-556(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-656(%rbp), %rsi
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L55
	leaq	-272(%rbp), %rax
	movl	label_cnt(%rip), %edx
	mov	%edx, %edx
	salq	$8, %rdx
	addq	$label_name, %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	movl	%eax, %edx
	movzwl	%dx, %edx
	addl	$1, %eax
	movl	%eax, label_cnt(%rip)
	movl	-556(%rbp), %eax
	movzbl	%al, %eax
	movl	%eax, %esi
	movl	$0, %edi
	call	setl
	jmp	.L3
.L55:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC68, %eax
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
	jne	.L56
	movq	-704(%rbp), %rax
	leaq	-544(%rbp), %rdi
	leaq	-548(%rbp), %rcx
	leaq	-528(%rbp), %rdx
	movq	-664(%rbp), %rsi
	movq	%rdi, %r8
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L56
	movl	-544(%rbp), %eax
	movzwl	%ax, %edx
	movl	-548(%rbp), %eax
	movzbl	%al, %eax
	movl	%eax, %esi
	movl	$0, %edi
	call	padd
	jmp	.L3
.L56:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC69, %eax
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
	jne	.L57
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movl	$0, %edi
	call	link
	jmp	.L3
.L57:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC70, %eax
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
	jne	.L58
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movl	$0, %edi
	call	movlr
	jmp	.L3
.L58:
	movq	-696(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC71, %eax
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
	jne	.L59
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movl	$0, %edi
	call	btmplr
	jmp	.L3
.L59:
	movl	$-1, %eax
.L3:
	movq	-8(%rbp), %rsi
	xorq	%fs:40, %rsi
	je	.L60
	call	__stack_chk_fail
.L60:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	encode_op, .-encode_op
	.globl	mvhi
	.type	mvhi, @function
mvhi:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$1006632960, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	mvhi, .-mvhi
	.globl	mvlo
	.type	mvlo, @function
mvlo:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$469762048, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	mvlo, .-mvlo
	.globl	addi
	.type	addi, @function
addi:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$536870912, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	addi, .-addi
	.globl	subi
	.type	subi, @function
subi:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$1073741824, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	subi, .-subi
	.globl	muli
	.type	muli, @function
muli:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$1610612736, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	muli, .-muli
	.globl	divi
	.type	divi, @function
divi:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$-2147483648, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	divi, .-divi
	.globl	slli
	.type	slli, @function
slli:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$-1610612736, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	slli, .-slli
	.globl	srli
	.type	srli, @function
srli:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$-1476395008, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	srli, .-srli
	.globl	jmp
	.type	jmp, @function
jmp:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	orl	$134217728, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	jmp, .-jmp
	.globl	jeq
	.type	jeq, @function
jeq:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$671088640, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	jeq, .-jeq
	.globl	jne
	.type	jne, @function
jne:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$1207959552, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	jne, .-jne
	.globl	jlt
	.type	jlt, @function
jlt:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$1744830464, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	jlt, .-jlt
	.globl	jle
	.type	jle, @function
jle:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$-2013265920, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	jle, .-jle
	.globl	call
	.type	call, @function
call:
.LFB14:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	orl	$-1073741824, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	call, .-call
	.globl	_return
	.type	_return, @function
_return:
.LFB15:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	orl	$-536870912, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	_return, .-_return
	.globl	ldi
	.type	ldi, @function
ldi:
.LFB16:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$-1946157056, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	ldi, .-ldi
	.globl	sti
	.type	sti, @function
sti:
.LFB17:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$-1409286144, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	sti, .-sti
	.globl	ldlr
	.type	ldlr, @function
ldlr:
.LFB18:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$-872415232, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	ldlr, .-ldlr
	.globl	stlr
	.type	stlr, @function
stlr:
.LFB19:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$-335544320, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	stlr, .-stlr
	.globl	fldi
	.type	fldi, @function
fldi:
.LFB20:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$-1006632960, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE20:
	.size	fldi, .-fldi
	.globl	fsti
	.type	fsti, @function
fsti:
.LFB21:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$-469762048, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE21:
	.size	fsti, .-fsti
	.globl	fjeq
	.type	fjeq, @function
fjeq:
.LFB22:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$-939524096, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE22:
	.size	fjeq, .-fjeq
	.globl	fjlt
	.type	fjlt, @function
fjlt:
.LFB23:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$-402653184, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE23:
	.size	fjlt, .-fjlt
	.globl	setl
	.type	setl, @function
setl:
.LFB24:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$335544320, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE24:
	.size	setl, .-setl
	.globl	padd
	.type	padd, @function
padd:
.LFB25:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%esi, %ecx
	movl	%edx, %eax
	movb	%dil, -4(%rbp)
	movb	%cl, -8(%rbp)
	movw	%ax, -12(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzwl	-12(%rbp), %eax
	orl	%edx, %eax
	orl	$201326592, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE25:
	.size	padd, .-padd
	.globl	mov
	.type	mov, @function
mov:
.LFB26:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$32, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE26:
	.size	mov, .-mov
	.globl	_not
	.type	_not, @function
_not:
.LFB27:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$27, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE27:
	.size	_not, .-_not
	.globl	input
	.type	input, @function
input:
.LFB28:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$67108864, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE28:
	.size	input, .-input
	.globl	output
	.type	output, @function
output:
.LFB29:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$67108865, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE29:
	.size	output, .-output
	.globl	nop
	.type	nop, @function
nop:
.LFB30:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE30:
	.size	nop, .-nop
	.globl	sll
	.type	sll, @function
sll:
.LFB31:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE31:
	.size	sll, .-sll
	.globl	srl
	.type	srl, @function
srl:
.LFB32:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$2, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE32:
	.size	srl, .-srl
	.globl	b
	.type	b, @function
b:
.LFB33:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$8, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE33:
	.size	b, .-b
	.globl	btmplr
	.type	btmplr, @function
btmplr:
.LFB34:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$16, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE34:
	.size	btmplr, .-btmplr
	.globl	nor
	.type	nor, @function
nor:
.LFB35:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$27, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE35:
	.size	nor, .-nor
	.globl	add
	.type	add, @function
add:
.LFB36:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$32, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE36:
	.size	add, .-add
	.globl	sub
	.type	sub, @function
sub:
.LFB37:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$34, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE37:
	.size	sub, .-sub
	.globl	ld
	.type	ld, @function
ld:
.LFB38:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$35, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE38:
	.size	ld, .-ld
	.globl	st
	.type	st, @function
st:
.LFB39:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$43, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE39:
	.size	st, .-st
	.globl	fld
	.type	fld, @function
fld:
.LFB40:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$49, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE40:
	.size	fld, .-fld
	.globl	fst
	.type	fst, @function
fst:
.LFB41:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$57, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE41:
	.size	fst, .-fst
	.globl	movlr
	.type	movlr, @function
movlr:
.LFB42:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$51, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE42:
	.size	movlr, .-movlr
	.globl	mul
	.type	mul, @function
mul:
.LFB43:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$24, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE43:
	.size	mul, .-mul
	.globl	_div
	.type	_div, @function
_div:
.LFB44:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$26, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE44:
	.size	_div, .-_div
	.globl	_and
	.type	_and, @function
_and:
.LFB45:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$36, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE45:
	.size	_and, .-_and
	.globl	_or
	.type	_or, @function
_or:
.LFB46:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$37, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE46:
	.size	_or, .-_or
	.globl	halt
	.type	halt, @function
halt:
.LFB47:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$63, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE47:
	.size	halt, .-halt
	.globl	callr
	.type	callr, @function
callr:
.LFB48:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$48, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE48:
	.size	callr, .-callr
	.globl	link
	.type	link, @function
link:
.LFB49:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$59, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE49:
	.size	link, .-link
	.globl	fadd
	.type	fadd, @function
fadd:
.LFB50:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$1140850688, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE50:
	.size	fadd, .-fadd
	.globl	fsub
	.type	fsub, @function
fsub:
.LFB51:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$1140850689, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE51:
	.size	fsub, .-fsub
	.globl	fmul
	.type	fmul, @function
fmul:
.LFB52:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$1140850690, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE52:
	.size	fmul, .-fmul
	.globl	fdiv
	.type	fdiv, @function
fdiv:
.LFB53:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$1140850691, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE53:
	.size	fdiv, .-fdiv
	.globl	fsqrt
	.type	fsqrt, @function
fsqrt:
.LFB54:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$1140850692, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE54:
	.size	fsqrt, .-fsqrt
	.globl	_fabs
	.type	_fabs, @function
_fabs:
.LFB55:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$1140850693, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE55:
	.size	_fabs, .-_fabs
	.globl	fmov
	.type	fmov, @function
fmov:
.LFB56:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$1140850694, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE56:
	.size	fmov, .-fmov
	.globl	fneg
	.type	fneg, @function
fneg:
.LFB57:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%ecx, %eax
	movb	%dil, -4(%rbp)
	movb	%sil, -8(%rbp)
	movb	%dl, -12(%rbp)
	movb	%al, -16(%rbp)
	movzbl	-4(%rbp), %eax
	movl	%eax, %edx
	sall	$21, %edx
	movzbl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movzbl	-12(%rbp), %eax
	sall	$11, %eax
	orl	%eax, %edx
	movzbl	-16(%rbp), %eax
	sall	$6, %eax
	orl	%edx, %eax
	orl	$1140850695, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE57:
	.size	fneg, .-fneg
	.ident	"GCC: (Ubuntu/Linaro 4.6.1-9ubuntu3) 4.6.1"
	.section	.note.GNU-stack,"",@progbits
