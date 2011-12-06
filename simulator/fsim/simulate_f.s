	.file	"simulate_f.c"
	.text
	.p2align 4,,15
	.globl	get_opcode
	.type	get_opcode, @function
get_opcode:
.LFB47:
	.cfi_startproc
	movl	%edi, %eax
	shrl	$26, %eax
	ret
	.cfi_endproc
.LFE47:
	.size	get_opcode, .-get_opcode
	.p2align 4,,15
	.globl	get_rsi
	.type	get_rsi, @function
get_rsi:
.LFB48:
	.cfi_startproc
	movl	%edi, %eax
	shrl	$21, %eax
	andl	$31, %eax
	ret
	.cfi_endproc
.LFE48:
	.size	get_rsi, .-get_rsi
	.p2align 4,,15
	.globl	get_rti
	.type	get_rti, @function
get_rti:
.LFB49:
	.cfi_startproc
	movl	%edi, %eax
	shrl	$16, %eax
	andl	$31, %eax
	ret
	.cfi_endproc
.LFE49:
	.size	get_rti, .-get_rti
	.p2align 4,,15
	.globl	get_rdi
	.type	get_rdi, @function
get_rdi:
.LFB50:
	.cfi_startproc
	movl	%edi, %eax
	shrl	$11, %eax
	andl	$31, %eax
	ret
	.cfi_endproc
.LFE50:
	.size	get_rdi, .-get_rdi
	.p2align 4,,15
	.globl	get_shamt
	.type	get_shamt, @function
get_shamt:
.LFB51:
	.cfi_startproc
	movl	%edi, %eax
	shrl	$6, %eax
	andl	$31, %eax
	ret
	.cfi_endproc
.LFE51:
	.size	get_shamt, .-get_shamt
	.p2align 4,,15
	.globl	get_funct
	.type	get_funct, @function
get_funct:
.LFB52:
	.cfi_startproc
	movl	%edi, %eax
	andl	$63, %eax
	ret
	.cfi_endproc
.LFE52:
	.size	get_funct, .-get_funct
	.p2align 4,,15
	.globl	get_target
	.type	get_target, @function
get_target:
.LFB53:
	.cfi_startproc
	movl	%edi, %eax
	andl	$67108863, %eax
	ret
	.cfi_endproc
.LFE53:
	.size	get_target, .-get_target
	.p2align 4,,15
	.globl	get_imm
	.type	get_imm, @function
get_imm:
.LFB54:
	.cfi_startproc
	movl	%edi, %eax
	movzwl	%di, %edx
	orl	$-65536, %eax
	andl	$32768, %edi
	cmove	%edx, %eax
	ret
	.cfi_endproc
.LFE54:
	.size	get_imm, .-get_imm
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%s: No such file\n"
.LC1:
	.string	"simulate %s\n"
.LC2:
	.string	"%c"
.LC3:
	.string	"\nCPU Simulator Results\n"
.LC4:
	.string	"cnt:%llu\n"
	.text
	.p2align 4,,15
	.globl	simulate
	.type	simulate, @function
simulate:
.LFB55:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	xorl	%esi, %esi
	xorl	%eax, %eax
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$16, %rsp
	.cfi_def_cfa_offset 64
	call	open
	testl	%eax, %eax
	movl	%eax, %ebx
	js	.L125
	movl	$16777216, %edx
	movl	$rom, %esi
	movl	%eax, %edi
	call	read
	movl	%ebx, %edi
	call	close
	movl	rom(%rip), %edx
	movq	$0, cnt(%rip)
	movl	$4194304, reg+124(%rip)
	movl	$4194304, reg+4(%rip)
	movl	$1, pc(%rip)
	testl	%edx, %edx
	je	.L14
	movl	reg+8(%rip), %ecx
	xorl	%eax, %eax
	movl	$2, %esi
	jmp	.L15
	.p2align 4,,10
	.p2align 3
.L111:
	movl	%edi, %esi
.L15:
	movl	rom+4(%rax), %edi
	addl	$4, %ecx
	movl	%edi, ram(%rax)
	addq	$4, %rax
	subl	$32, %edx
	leal	1(%rsi), %edi
	jne	.L111
	movl	%ecx, reg+8(%rip)
	movl	%esi, pc(%rip)
.L14:
	movq	stderr(%rip), %rdi
	movq	%rbp, %rcx
	movl	$.LC1, %edx
	movl	$1, %esi
	xorl	%eax, %eax
	movabsq	$-6067343680855748867, %r12
	call	__fprintf_chk
	movq	stderr(%rip), %rdi
	call	fflush
	.p2align 4,,10
	.p2align 3
.L116:
	movl	pc(%rip), %eax
	movq	cnt(%rip), %rcx
	mov	%eax, %edx
	addq	$1, %rcx
	addl	$1, %eax
	movl	rom(,%rdx,4), %r13d
	movl	%eax, pc(%rip)
	movq	%rcx, %rax
	movq	%rcx, cnt(%rip)
	movl	%r13d, %edx
	movl	%r13d, %ebx
	andl	$63, %edx
	shrl	$26, %ebx
	movl	%edx, %ebp
	mulq	%r12
	shrq	$26, %rdx
	imulq	$100000000, %rdx, %rdx
	cmpq	%rdx, %rcx
	je	.L126
.L17:
	cmpb	$58, %bl
	ja	.L18
	movzbl	%bl, %eax
	jmp	*.L47(,%rax,8)
	.section	.rodata
	.align 8
	.align 4
.L47:
	.quad	.L19
	.quad	.L20
	.quad	.L118
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L22
	.quad	.L23
	.quad	.L24
	.quad	.L18
	.quad	.L25
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L26
	.quad	.L27
	.quad	.L28
	.quad	.L29
	.quad	.L30
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L31
	.quad	.L18
	.quad	.L32
	.quad	.L18
	.quad	.L33
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L34
	.quad	.L18
	.quad	.L35
	.quad	.L18
	.quad	.L18
	.quad	.L36
	.quad	.L18
	.quad	.L18
	.quad	.L37
	.quad	.L18
	.quad	.L38
	.quad	.L18
	.quad	.L39
	.quad	.L40
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L41
	.quad	.L42
	.quad	.L43
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L44
	.quad	.L45
	.quad	.L46
	.text
.L98:
	movl	%r13d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L18
	mov	%eax, %edx
	movl	%r13d, %ecx
	movl	%r13d, %eax
	shrl	$21, %eax
	shrl	$16, %ecx
	andl	$31, %eax
	andl	$31, %ecx
	movl	reg(,%rcx,4), %ecx
	movl	reg(,%rax,4), %eax
	sarl	%cl, %eax
	movl	%eax, reg(,%rdx,4)
	.p2align 4,,10
	.p2align 3
.L18:
	testb	%bl, %bl
	jne	.L116
.L127:
	cmpb	$63, %bpl
	jne	.L116
	movq	stderr(%rip), %rcx
	movl	$23, %edx
	movl	$1, %esi
	movl	$.LC3, %edi
	call	fwrite
	movq	cnt(%rip), %rcx
	movq	stderr(%rip), %rdi
	movl	$.LC4, %edx
	movl	$1, %esi
	xorl	%eax, %eax
	call	__fprintf_chk
	movq	stderr(%rip), %rdi
	call	fflush
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L126:
	.cfi_restore_state
	movq	stderr(%rip), %rsi
	movl	$46, %edi
	call	fputc
	movq	stderr(%rip), %rdi
	call	fflush
	jmp	.L17
.L41:
	movl	reg+4(%rip), %eax
	movl	reg+120(%rip), %ecx
	movslq	%eax, %rdx
	subl	$4, %eax
	movl	%eax, reg+4(%rip)
	movl	pc(%rip), %eax
	movl	%ecx, ram(,%rdx,4)
	movl	%eax, reg+120(%rip)
.L118:
	andl	$67108863, %r13d
	testb	%bl, %bl
	movl	%r13d, pc(%rip)
	jne	.L116
	jmp	.L127
.L20:
	testb	%bpl, %bpl
	jne	.L128
	shrl	$11, %r13d
	xorl	%eax, %eax
	movl	$.LC2, %edi
	andl	$31, %r13d
	mov	%r13d, %r14d
	leaq	reg(,%r14,4), %rsi
	call	__isoc99_scanf
	testl	%r13d, %r13d
	je	.L18
	movzbl	reg(,%r14,4), %eax
	movl	%eax, reg(,%r14,4)
	jmp	.L116
.L19:
	cmpb	$48, %bpl
	ja	.L18
	movzbl	%bpl, %eax
	jmp	*.L107(,%rax,8)
	.section	.rodata
	.align 8
	.align 4
.L107:
	.quad	.L97
	.quad	.L18
	.quad	.L98
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L99
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L100
	.quad	.L18
	.quad	.L101
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L102
	.quad	.L18
	.quad	.L103
	.quad	.L18
	.quad	.L104
	.quad	.L105
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L18
	.quad	.L106
	.text
.L46:
	movl	%r13d, %edx
	movl	%r13d, %eax
	shrl	$16, %edx
	shrl	$21, %eax
	andl	$31, %edx
	andl	$31, %eax
	movss	freg(,%rdx,4), %xmm0
	ucomiss	freg(,%rax,4), %xmm0
	jbe	.L18
.L121:
	movl	%r13d, %eax
	movzwl	%r13w, %edx
	orl	$-65536, %eax
	andl	$32768, %r13d
	cmove	%edx, %eax
	addl	%eax, pc(%rip)
	testb	%bl, %bl
	jne	.L116
	jmp	.L127
.L45:
	movl	%r13d, %eax
	movl	%r13d, %edx
	movzwl	%r13w, %ecx
	shrl	$21, %eax
	orl	$-65536, %edx
	andl	$31, %eax
	testl	$32768, %r13d
	movl	reg(,%rax,4), %eax
	cmove	%ecx, %edx
	subl	%edx, %eax
	leal	3(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	shrl	$16, %r13d
	movq	%r13, %rdx
	sarl	$2, %eax
	andl	$31, %edx
	cltq
	testb	%bl, %bl
	movl	freg(,%rdx,4), %edx
	movl	%edx, ram(,%rax,4)
	jne	.L116
	jmp	.L127
.L44:
	movl	reg+120(%rip), %eax
	movl	%eax, pc(%rip)
	movl	reg+4(%rip), %eax
	addl	$4, %eax
	testb	%bl, %bl
	movl	%eax, reg+4(%rip)
	cltq
	movl	ram(,%rax,4), %eax
	movl	%eax, reg+120(%rip)
	jne	.L116
	jmp	.L127
.L43:
	movl	%r13d, %edx
	movl	%r13d, %eax
	shrl	$21, %edx
	shrl	$16, %eax
	andl	$31, %edx
	andl	$31, %eax
	movss	freg(,%rdx,4), %xmm0
	ucomiss	freg(,%rax,4), %xmm0
	jp	.L18
	jne	.L18
	jmp	.L121
.L42:
	movl	%r13d, %eax
	movl	%r13d, %ecx
	movl	%r13d, %edx
	shrl	$21, %eax
	shrl	$16, %ecx
	orl	$-65536, %edx
	andl	$31, %eax
	movzwl	%r13w, %esi
	andl	$32768, %r13d
	movl	reg(,%rax,4), %eax
	cmove	%esi, %edx
	andl	$31, %ecx
	subl	%edx, %eax
	leal	3(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$2, %eax
	testb	%bl, %bl
	cltq
	movl	ram(,%rax,4), %eax
	movl	%eax, freg(,%rcx,4)
	jne	.L116
	jmp	.L127
.L40:
	movl	%r13d, %eax
	movl	%r13d, %edx
	movzwl	%r13w, %ecx
	shrl	$21, %eax
	orl	$-65536, %edx
	andl	$31, %eax
	testl	$32768, %r13d
	movl	reg(,%rax,4), %eax
	cmove	%ecx, %edx
	subl	%edx, %eax
	leal	3(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	shrl	$16, %r13d
	movq	%r13, %rdx
	sarl	$2, %eax
	andl	$31, %edx
	cltq
	testb	%bl, %bl
	movl	reg(,%rdx,4), %edx
	movl	%edx, ram(,%rax,4)
	jne	.L116
	jmp	.L127
.L39:
	movl	%r13d, %edx
	shrl	$16, %edx
	andl	$31, %edx
	je	.L18
	movl	%r13d, %eax
	movl	%r13d, %ecx
	movzwl	%r13w, %esi
	shrl	$21, %eax
	orl	$-65536, %ecx
	mov	%edx, %edx
	andl	$31, %eax
	andl	$32768, %r13d
	movl	reg(,%rax,4), %eax
	cmove	%esi, %ecx
	sarl	%cl, %eax
	testb	%bl, %bl
	movl	%eax, reg(,%rdx,4)
	jne	.L116
	jmp	.L127
	.p2align 4,,10
	.p2align 3
.L38:
	movl	%r13d, %edx
	shrl	$16, %edx
	andl	$31, %edx
	je	.L18
	movl	%r13d, %eax
	movl	%r13d, %ecx
	movzwl	%r13w, %esi
	shrl	$21, %eax
	orl	$-65536, %ecx
	mov	%edx, %edx
	andl	$31, %eax
	andl	$32768, %r13d
	movl	reg(,%rax,4), %eax
	cmove	%esi, %ecx
	sall	%cl, %eax
	testb	%bl, %bl
	movl	%eax, reg(,%rdx,4)
	jne	.L116
	jmp	.L127
	.p2align 4,,10
	.p2align 3
.L37:
	movl	%r13d, %eax
	shrl	$21, %r13d
	shrl	$11, %eax
	movq	%r13, %rdx
	andl	$31, %eax
	andl	$31, %edx
	testb	%bl, %bl
	cvtsi2ss	reg(,%rdx,4), %xmm0
	movd	%xmm0, freg(,%rax,4)
	jne	.L116
	jmp	.L127
.L36:
	movl	%r13d, %eax
	shrl	$21, %eax
	andl	$31, %eax
	je	.L18
	mov	%eax, %eax
	movl	%r13d, %ecx
	movl	%r13d, %edx
	movl	reg(,%rax,4), %eax
	shrl	$16, %ecx
	orl	$-65536, %edx
	movzwl	%r13w, %esi
	andl	$32768, %r13d
	cmove	%esi, %edx
	andl	$31, %ecx
	subl	%edx, %eax
	leal	3(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$2, %eax
	testb	%bl, %bl
	cltq
	movl	ram(,%rax,4), %eax
	movl	%eax, reg(,%rcx,4)
	jne	.L116
	jmp	.L127
	.p2align 4,,10
	.p2align 3
.L35:
	movl	%r13d, %ecx
	shrl	$16, %ecx
	andl	$31, %ecx
	je	.L18
	movl	%r13d, %eax
	movl	%r13d, %esi
	movzwl	%r13w, %edx
	shrl	$21, %eax
	orl	$-65536, %esi
	mov	%ecx, %ecx
	andl	$31, %eax
	andl	$32768, %r13d
	movl	reg(,%rax,4), %eax
	cmove	%edx, %esi
	movl	%eax, %edx
	sarl	$31, %edx
	idivl	%esi
	testb	%bl, %bl
	movl	%eax, reg(,%rcx,4)
	jne	.L116
	jmp	.L127
	.p2align 4,,10
	.p2align 3
.L34:
	movl	%r13d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L18
	movl	%r13d, %edx
	mov	%eax, %eax
	shrl	$21, %edx
	andl	$31, %edx
	testb	%bl, %bl
	movss	freg(,%rdx,4), %xmm0
	cvttss2si	%xmm0, %edx
	movl	%edx, reg(,%rax,4)
	jne	.L116
	jmp	.L127
	.p2align 4,,10
	.p2align 3
.L33:
	movl	%r13d, %edx
	movl	%r13d, %eax
	shrl	$21, %edx
	shrl	$16, %eax
	andl	$31, %eax
	andl	$31, %edx
	movl	reg(,%rax,4), %ecx
	cmpl	%ecx, reg(,%rdx,4)
	jge	.L18
	jmp	.L121
.L32:
	movl	%r13d, %eax
	shrl	$16, %eax
	andl	$31, %eax
	je	.L18
	movl	%r13d, %ecx
	movl	%r13d, %edx
	movzwl	%r13w, %esi
	shrl	$21, %ecx
	orl	$-65536, %edx
	mov	%eax, %eax
	andl	$31, %ecx
	andl	$32768, %r13d
	cmove	%esi, %edx
	imull	reg(,%rcx,4), %edx
	testb	%bl, %bl
	movl	%edx, reg(,%rax,4)
	jne	.L116
	jmp	.L127
	.p2align 4,,10
	.p2align 3
.L31:
	movl	%r13d, %eax
	shrl	$21, %eax
	andl	$31, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, 8(%rsp)
	movss	8(%rsp), %xmm0
	call	atanf
.L122:
	shrl	$11, %r13d
	movss	%xmm0, 8(%rsp)
	movl	8(%rsp), %edx
	movq	%r13, %rax
	andl	$31, %eax
	testb	%bl, %bl
	movl	%edx, freg(,%rax,4)
	jne	.L116
	jmp	.L127
.L30:
	movl	%r13d, %edx
	movl	%r13d, %eax
	shrl	$21, %edx
	shrl	$16, %eax
	andl	$31, %eax
	andl	$31, %edx
	movl	reg(,%rax,4), %ecx
	cmpl	%ecx, reg(,%rdx,4)
	jne	.L121
	jmp	.L18
.L29:
	cmpb	$7, %bpl
	ja	.L18
	movzbl	%bpl, %eax
	.p2align 4,,3
	jmp	*.L92(,%rax,8)
	.section	.rodata
	.align 8
	.align 4
.L92:
	.quad	.L84
	.quad	.L85
	.quad	.L86
	.quad	.L87
	.quad	.L88
	.quad	.L89
	.quad	.L90
	.quad	.L91
	.text
.L28:
	movl	%r13d, %eax
	shrl	$16, %eax
	andl	$31, %eax
	je	.L18
	movl	%r13d, %edx
	movl	%r13d, %ecx
	movzwl	%r13w, %esi
	shrl	$21, %edx
	orl	$-65536, %ecx
	mov	%eax, %eax
	andl	$31, %edx
	andl	$32768, %r13d
	movl	reg(,%rdx,4), %edx
	cmove	%esi, %ecx
	subl	%ecx, %edx
	testb	%bl, %bl
	movl	%edx, reg(,%rax,4)
	jne	.L116
	jmp	.L127
	.p2align 4,,10
	.p2align 3
.L27:
	movl	%r13d, %eax
	shrl	$16, %eax
	andl	$31, %eax
	je	.L18
	mov	%eax, %eax
	testb	%bl, %bl
	movw	%r13w, reg+2(,%rax,4)
	jne	.L116
	jmp	.L127
	.p2align 4,,10
	.p2align 3
.L26:
	movl	%r13d, %eax
	shrl	$21, %eax
	andl	$31, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, 8(%rsp)
	movss	8(%rsp), %xmm0
	call	cosf
	jmp	.L122
.L25:
	movl	%r13d, %edx
	movl	%r13d, %eax
	shrl	$21, %edx
	shrl	$16, %eax
	andl	$31, %eax
	andl	$31, %edx
	movl	reg(,%rax,4), %ecx
	cmpl	%ecx, reg(,%rdx,4)
	je	.L121
	testb	%bl, %bl
	jne	.L116
	jmp	.L127
.L24:
	movl	%r13d, %eax
	shrl	$16, %eax
	movl	%eax, %edx
	andl	$31, %edx
	je	.L18
	movl	%r13d, %ecx
	movl	%r13d, %eax
	movzwl	%r13w, %esi
	shrl	$21, %ecx
	orl	$-65536, %eax
	mov	%edx, %edx
	andl	$31, %ecx
	andl	$32768, %r13d
	cmove	%esi, %eax
	addl	reg(,%rcx,4), %eax
	testb	%bl, %bl
	movl	%eax, reg(,%rdx,4)
	jne	.L116
	jmp	.L127
	.p2align 4,,10
	.p2align 3
.L23:
	movl	%r13d, %eax
	shrl	$16, %eax
	andl	$31, %eax
	je	.L18
	mov	%eax, %eax
	movzwl	%r13w, %r13d
	movl	reg(,%rax,4), %edx
	xorw	%dx, %dx
	orl	%edx, %r13d
	testb	%bl, %bl
	movl	%r13d, reg(,%rax,4)
	jne	.L116
	jmp	.L127
	.p2align 4,,10
	.p2align 3
.L22:
	movl	%r13d, %eax
	shrl	$21, %eax
	andl	$31, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, 8(%rsp)
	movss	8(%rsp), %xmm0
	call	sinf
	jmp	.L122
.L125:
	movq	stderr(%rip), %rdi
	movq	%rbp, %rcx
	movl	$.LC0, %edx
	movl	$1, %esi
	xorl	%eax, %eax
	call	__fprintf_chk
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	movl	$1, %eax
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L128:
	.cfi_restore_state
	cmpb	$1, %bpl
	jne	.L18
	movl	%r13d, %eax
	movq	stdout(%rip), %rsi
	shrl	$21, %eax
	andl	$31, %eax
	movl	reg(,%rax,4), %edi
	call	_IO_putc
	movq	stdout(%rip), %rdi
	call	fflush
	jmp	.L116
.L90:
	movl	%r13d, %eax
	shrl	$21, %eax
	andl	$31, %eax
	movl	freg(,%rax,4), %edx
	movl	%r13d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	movl	%edx, freg(,%rax,4)
	jmp	.L18
.L89:
	movl	%r13d, %eax
	movl	%r13d, %edx
	shrl	$21, %eax
	shrl	$11, %edx
	andl	$31, %eax
	andl	$31, %edx
	movl	freg(,%rax,4), %eax
	andl	$2147483647, %eax
	movl	%eax, freg(,%rdx,4)
	jmp	.L18
.L88:
	movl	%r13d, %eax
	shrl	$21, %eax
	andl	$31, %eax
	movl	freg(,%rax,4), %edi
	call	_fsqrt
	movl	%r13d, %edx
	shrl	$11, %edx
	andl	$31, %edx
	movl	%eax, freg(,%rdx,4)
	jmp	.L18
.L87:
	movl	%r13d, %eax
	shrl	$21, %eax
	andl	$31, %eax
	movss	freg(,%rax,4), %xmm0
	movl	%r13d, %eax
	shrl	$16, %eax
	movss	%xmm0, 12(%rsp)
	andl	$31, %eax
	movl	freg(,%rax,4), %edi
	call	_finv
	movl	%eax, 8(%rsp)
	movl	%r13d, %edx
	movss	8(%rsp), %xmm0
	shrl	$11, %edx
	mulss	12(%rsp), %xmm0
	andl	$31, %edx
	movd	%xmm0, freg(,%rdx,4)
	jmp	.L18
.L86:
	movl	%r13d, %ecx
	movl	%r13d, %edx
	movl	%r13d, %eax
	shrl	$16, %ecx
	shrl	$21, %edx
	shrl	$11, %eax
	andl	$31, %ecx
	andl	$31, %edx
	andl	$31, %eax
	movl	freg(,%rcx,4), %ecx
	movl	%ecx, 12(%rsp)
	movss	12(%rsp), %xmm0
	mulss	freg(,%rdx,4), %xmm0
	movd	%xmm0, freg(,%rax,4)
	jmp	.L116
.L85:
	movl	%r13d, %edx
	movl	%r13d, %eax
	shrl	$21, %edx
	shrl	$11, %eax
	andl	$31, %edx
	andl	$31, %eax
	movl	freg(,%rdx,4), %edx
	movl	%edx, 12(%rsp)
	movl	%r13d, %edx
	shrl	$16, %edx
	movss	12(%rsp), %xmm0
	andl	$31, %edx
	subss	freg(,%rdx,4), %xmm0
	movd	%xmm0, freg(,%rax,4)
	jmp	.L18
.L84:
	movl	%r13d, %ecx
	movl	%r13d, %edx
	movl	%r13d, %eax
	shrl	$16, %ecx
	shrl	$21, %edx
	shrl	$11, %eax
	andl	$31, %ecx
	andl	$31, %edx
	andl	$31, %eax
	movl	freg(,%rcx,4), %ecx
	movl	%ecx, 12(%rsp)
	movss	12(%rsp), %xmm0
	addss	freg(,%rdx,4), %xmm0
	movd	%xmm0, freg(,%rax,4)
	jmp	.L116
.L91:
	movl	%r13d, %eax
	movl	%r13d, %ecx
	shrl	$21, %eax
	shrl	$11, %ecx
	andl	$31, %eax
	movl	freg(,%rax,4), %edx
	movl	%edx, %eax
	movl	%edx, %esi
	andl	$2147483647, %eax
	orl	$-2147483648, %esi
	testl	%edx, %edx
	movq	%rcx, %rdx
	cmovns	%esi, %eax
	andl	$31, %edx
	movl	%eax, freg(,%rdx,4)
	jmp	.L18
.L106:
	movl	reg+4(%rip), %eax
	movl	reg+120(%rip), %ecx
	movslq	%eax, %rdx
	subl	$4, %eax
	movl	%eax, reg+4(%rip)
	movl	pc(%rip), %eax
	movl	%ecx, ram(,%rdx,4)
	movl	%eax, reg+120(%rip)
.L99:
	movl	%r13d, %eax
	shrl	$21, %eax
	andl	$31, %eax
	movl	reg(,%rax,4), %eax
	movl	%eax, pc(%rip)
	jmp	.L18
.L100:
	movl	%r13d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L18
	mov	%eax, %edx
	movl	%r13d, %ecx
	movl	%r13d, %eax
	shrl	$21, %eax
	shrl	$16, %ecx
	andl	$31, %eax
	andl	$31, %ecx
	movl	reg(,%rax,4), %eax
	imull	reg(,%rcx,4), %eax
	movl	%eax, reg(,%rdx,4)
	jmp	.L18
.L105:
	movl	%r13d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L18
	mov	%eax, %edx
	movl	%r13d, %ecx
	movl	%r13d, %eax
	shrl	$16, %eax
	shrl	$21, %ecx
	andl	$31, %eax
	andl	$31, %ecx
	movl	reg(,%rax,4), %eax
	orl	reg(,%rcx,4), %eax
	movl	%eax, reg(,%rdx,4)
	jmp	.L18
.L97:
	movl	%r13d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L18
	mov	%eax, %edx
	movl	%r13d, %ecx
	movl	%r13d, %eax
	shrl	$21, %eax
	shrl	$16, %ecx
	andl	$31, %eax
	andl	$31, %ecx
	movl	reg(,%rcx,4), %ecx
	movl	reg(,%rax,4), %eax
	sall	%cl, %eax
	movl	%eax, reg(,%rdx,4)
	jmp	.L18
.L104:
	movl	%r13d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L18
	mov	%eax, %edx
	movl	%r13d, %ecx
	movl	%r13d, %eax
	shrl	$16, %eax
	shrl	$21, %ecx
	andl	$31, %eax
	andl	$31, %ecx
	movl	reg(,%rax,4), %eax
	andl	reg(,%rcx,4), %eax
	movl	%eax, reg(,%rdx,4)
	jmp	.L18
.L103:
	movl	%r13d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L18
	mov	%eax, %edx
	movl	%r13d, %ecx
	movl	%r13d, %eax
	shrl	$21, %eax
	shrl	$16, %ecx
	andl	$31, %eax
	andl	$31, %ecx
	movl	reg(,%rax,4), %eax
	subl	reg(,%rcx,4), %eax
	movl	%eax, reg(,%rdx,4)
	jmp	.L18
.L102:
	movl	%r13d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L116
	mov	%eax, %edx
	movl	%r13d, %ecx
	movl	%r13d, %eax
	shrl	$21, %eax
	shrl	$16, %ecx
	andl	$31, %eax
	andl	$31, %ecx
	movl	reg(,%rax,4), %eax
	addl	reg(,%rcx,4), %eax
	movl	%eax, reg(,%rdx,4)
	jmp	.L116
.L101:
	movl	%r13d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L18
	mov	%eax, %ecx
	movl	%r13d, %eax
	movl	%r13d, %esi
	shrl	$21, %eax
	shrl	$16, %esi
	andl	$31, %eax
	andl	$31, %esi
	movl	reg(,%rax,4), %eax
	movl	%eax, %edx
	sarl	$31, %edx
	idivl	reg(,%rsi,4)
	movl	%eax, reg(,%rcx,4)
	jmp	.L18
	.cfi_endproc
.LFE55:
	.size	simulate, .-simulate
	.comm	cnt,8,8
	.comm	pc,4,4
	.comm	ram,16777216,32
	.comm	rom,16777216,32
	.comm	freg,128,32
	.comm	reg,128,32
	.ident	"GCC: (Ubuntu/Linaro 4.6.1-9ubuntu3) 4.6.1"
	.section	.note.GNU-stack,"",@progbits
