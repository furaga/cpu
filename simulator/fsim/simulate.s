	.file	"simulate.c"
	.text
	.p2align 4,,15
.globl get_opcode
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
.globl get_rsi
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
.globl get_rti
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
.globl get_rdi
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
.globl get_shamt
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
.globl get_funct
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
.globl get_target
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
.globl get_imm
	.type	get_imm, @function
get_imm:
.LFB54:
	.cfi_startproc
	movl	%edi, %eax
	movzwl	%di,%edx
	orl	$-65536, %eax
	testw	%di, %di
	cmovns	%edx, %eax
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
	.string	"."
.LC3:
	.string	"%c"
.LC4:
	.string	"\nCPU Simulator Results\n"
.LC5:
	.string	"cnt:%llu\n"
	.text
	.p2align 4,,15
.globl simulate
	.type	simulate, @function
simulate:
.LFB55:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	xorl	%esi, %esi
	xorl	%eax, %eax
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r13
	.cfi_def_cfa_offset 32
	pushq	%r12
	.cfi_def_cfa_offset 40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbp
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	.cfi_offset 3, -56
	call	open
	testl	%eax, %eax
	movl	%eax, %ebx
	js	.L131
	movl	$16777216, %edx
	movl	$rom, %esi
	movl	%eax, %edi
	call	read
	movl	%ebx, %edi
	call	close
	movl	rom(%rip), %eax
	movq	$0, cnt(%rip)
	movl	$4194304, reg+124(%rip)
	movl	$4194304, reg+4(%rip)
	movl	$1, pc(%rip)
	testl	%eax, %eax
	je	.L22
	movl	reg+8(%rip), %esi
	movl	$rom+4, %ebx
	movl	$ram, %ecx
	movl	$2, %edx
	.p2align 4,,10
	.p2align 3
.L23:
	movl	(%rbx), %edi
	addl	$4, %esi
	addq	$4, %rbx
	movl	%edi, (%rcx)
	addq	$4, %rcx
	movl	%edx, %edi
	addl	$1, %edx
	subl	$32, %eax
	jne	.L23
	movl	%esi, reg+8(%rip)
	movl	%edi, pc(%rip)
.L22:
	movq	stderr(%rip), %rdi
	movq	%rbp, %rcx
	movl	$.LC1, %edx
	movl	$1, %esi
	xorl	%eax, %eax
	xorl	%r13d, %r13d
	movabsq	$-6067343680855748867, %r12
	call	__fprintf_chk
	movq	stderr(%rip), %rdi
	call	fflush
	.p2align 4,,10
	.p2align 3
.L122:
	movl	pc(%rip), %eax
	movq	cnt(%rip), %rcx
	mov	%eax, %edx
	addq	$1, %rcx
	addl	$1, %eax
	movl	rom(,%rdx,4), %r14d
	movl	%eax, pc(%rip)
	movq	%rcx, %rax
	movq	%rcx, cnt(%rip)
	movl	%r14d, %edx
	movl	%r14d, %ebx
	andl	$63, %edx
	shrl	$26, %ebx
	movl	%edx, %ebp
	mulq	%r12
	shrq	$26, %rdx
	imulq	$100000000, %rdx, %rdx
	cmpq	%rdx, %rcx
	je	.L132
.L24:
	cmpb	$58, %bl
	ja	.L25
	movzbl	%bl, %eax
	jmp	*.L54(,%rax,8)
	.section	.rodata
	.align 8
	.align 4
.L54:
	.quad	.L26
	.quad	.L27
	.quad	.L126
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L29
	.quad	.L30
	.quad	.L31
	.quad	.L25
	.quad	.L32
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L33
	.quad	.L34
	.quad	.L35
	.quad	.L36
	.quad	.L37
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L38
	.quad	.L25
	.quad	.L39
	.quad	.L25
	.quad	.L40
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L41
	.quad	.L25
	.quad	.L42
	.quad	.L25
	.quad	.L25
	.quad	.L43
	.quad	.L25
	.quad	.L25
	.quad	.L44
	.quad	.L25
	.quad	.L45
	.quad	.L25
	.quad	.L46
	.quad	.L47
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L48
	.quad	.L49
	.quad	.L50
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L51
	.quad	.L52
	.quad	.L53
	.text
.L95:
	movl	%r14d, %eax
	shrl	$21, %eax
	andl	$31, %eax
	movss	freg(,%rax,4), %xmm1
	sqrtss	%xmm1, %xmm0
	ucomiss	%xmm0, %xmm0
	jp	.L124
	je	.L102
.L124:
	movaps	%xmm1, %xmm0
	call	sqrtf
.L102:
	movl	%r14d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	movd	%xmm0, freg(,%rax,4)
	.p2align 4,,10
	.p2align 3
.L25:
	testb	%bl, %bl
	jne	.L122
.L133:
	cmpb	$63, %bpl
	jne	.L122
	movq	stderr(%rip), %rdi
	movl	$.LC4, %edx
	movl	$1, %esi
	xorl	%eax, %eax
	call	__fprintf_chk
	movq	cnt(%rip), %rcx
	movq	stderr(%rip), %rdi
	movl	$.LC5, %edx
	movl	$1, %esi
	xorl	%eax, %eax
	call	__fprintf_chk
	movq	stderr(%rip), %rdi
	call	fflush
	addq	$40, %rsp
	xorl	%eax, %eax
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
	.p2align 3
.L132:
	movq	stderr(%rip), %rdi
	movl	$.LC2, %edx
	movl	$1, %esi
	xorl	%eax, %eax
	call	__fprintf_chk
	movq	stderr(%rip), %rdi
	call	fflush
	jmp	.L24
.L48:
	movl	reg+4(%rip), %eax
	movslq	%eax,%rdx
	subl	$4, %eax
	movl	%r13d, ram(,%rdx,4)
	movl	pc(%rip), %r13d
	movl	%eax, reg+4(%rip)
.L126:
	andl	$67108863, %r14d
	testb	%bl, %bl
	movl	%r14d, pc(%rip)
	jne	.L122
	jmp	.L133
.L27:
	testb	%bpl, %bpl
	jne	.L134
	shrl	$11, %r14d
	xorl	%eax, %eax
	movl	$.LC3, %edi
	andl	$31, %r14d
	mov	%r14d, %r15d
	leaq	reg(,%r15,4), %rsi
	call	__isoc99_scanf
	testl	%r14d, %r14d
	je	.L25
	movl	reg(,%r15,4), %eax
	andl	$255, %eax
	movl	%eax, reg(,%r15,4)
	jmp	.L122
.L26:
	cmpb	$48, %bpl
	ja	.L25
	movzbl	%bpl, %eax
	jmp	*.L113(,%rax,8)
	.section	.rodata
	.align 8
	.align 4
.L113:
	.quad	.L103
	.quad	.L25
	.quad	.L104
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L105
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L106
	.quad	.L25
	.quad	.L107
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L108
	.quad	.L25
	.quad	.L109
	.quad	.L25
	.quad	.L110
	.quad	.L111
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L25
	.quad	.L112
	.text
.L53:
	movl	%r14d, %edx
	movl	%r14d, %eax
	shrl	$16, %edx
	shrl	$21, %eax
	andl	$31, %edx
	andl	$31, %eax
	movss	freg(,%rdx,4), %xmm0
	ucomiss	freg(,%rax,4), %xmm0
	jbe	.L25
.L128:
	movl	%r14d, %eax
	movzwl	%r14w,%edx
	orl	$-65536, %eax
	testw	%r14w, %r14w
	cmovns	%edx, %eax
	addl	%eax, pc(%rip)
	testb	%bl, %bl
	jne	.L122
	jmp	.L133
.L52:
	movl	%r14d, %eax
	movl	%r14d, %edx
	movzwl	%r14w,%ecx
	shrl	$16, %eax
	orl	$-65536, %edx
	andl	$31, %eax
	testw	%r14w, %r14w
	movl	reg(,%rax,4), %eax
	cmovns	%ecx, %edx
	subl	%edx, %eax
	leal	3(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	shrl	$21, %r14d
	movq	%r14, %rdx
	sarl	$2, %eax
	andl	$31, %edx
	cltq
	testb	%bl, %bl
	movl	freg(,%rdx,4), %edx
	movl	%edx, ram(,%rax,4)
	jne	.L122
	jmp	.L133
.L51:
	movl	reg+4(%rip), %eax
	movl	%r13d, pc(%rip)
	addl	$4, %eax
	testb	%bl, %bl
	movl	%eax, reg+4(%rip)
	cltq
	movl	ram(,%rax,4), %r13d
	jne	.L122
	jmp	.L133
.L50:
	movl	%r14d, %edx
	movl	%r14d, %eax
	shrl	$21, %edx
	shrl	$16, %eax
	andl	$31, %edx
	andl	$31, %eax
	movss	freg(,%rdx,4), %xmm0
	ucomiss	freg(,%rax,4), %xmm0
	jne	.L25
	jnp	.L128
	jmp	.L25
	.p2align 4,,10
	.p2align 3
.L49:
	movl	%r14d, %eax
	movl	%r14d, %edx
	movzwl	%r14w,%ecx
	shrl	$16, %eax
	orl	$-65536, %edx
	andl	$31, %eax
	testw	%r14w, %r14w
	movl	reg(,%rax,4), %eax
	cmovns	%ecx, %edx
	shrl	$21, %r14d
	movq	%r14, %rcx
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
	jne	.L122
	jmp	.L133
.L47:
	movl	%r14d, %eax
	movl	%r14d, %edx
	movzwl	%r14w,%ecx
	shrl	$16, %eax
	orl	$-65536, %edx
	andl	$31, %eax
	testw	%r14w, %r14w
	movl	reg(,%rax,4), %eax
	cmovns	%ecx, %edx
	subl	%edx, %eax
	leal	3(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	shrl	$21, %r14d
	movq	%r14, %rdx
	sarl	$2, %eax
	andl	$31, %edx
	cltq
	testb	%bl, %bl
	movl	reg(,%rdx,4), %edx
	movl	%edx, ram(,%rax,4)
	jne	.L122
	jmp	.L133
.L46:
	movl	%r14d, %edx
	shrl	$16, %edx
	andl	$31, %edx
	je	.L25
	movl	%r14d, %eax
	movl	%r14d, %ecx
	movzwl	%r14w,%esi
	shrl	$21, %eax
	orl	$-65536, %ecx
	mov	%edx, %edx
	andl	$31, %eax
	testw	%r14w, %r14w
	movl	reg(,%rax,4), %eax
	cmovns	%esi, %ecx
	sarl	%cl, %eax
	testb	%bl, %bl
	movl	%eax, reg(,%rdx,4)
	jne	.L122
	jmp	.L133
	.p2align 4,,10
	.p2align 3
.L45:
	movl	%r14d, %edx
	shrl	$16, %edx
	andl	$31, %edx
	je	.L25
	movl	%r14d, %eax
	movl	%r14d, %ecx
	movzwl	%r14w,%esi
	shrl	$21, %eax
	orl	$-65536, %ecx
	mov	%edx, %edx
	andl	$31, %eax
	testw	%r14w, %r14w
	movl	reg(,%rax,4), %eax
	cmovns	%esi, %ecx
	sall	%cl, %eax
	testb	%bl, %bl
	movl	%eax, reg(,%rdx,4)
	jne	.L122
	jmp	.L133
	.p2align 4,,10
	.p2align 3
.L44:
	movl	%r14d, %eax
	shrl	$21, %r14d
	shrl	$11, %eax
	movq	%r14, %rdx
	andl	$31, %eax
	andl	$31, %edx
	testb	%bl, %bl
	cvtsi2ss	reg(,%rdx,4), %xmm0
	movd	%xmm0, freg(,%rax,4)
	jne	.L122
	jmp	.L133
.L43:
	movl	%r14d, %eax
	shrl	$21, %eax
	movl	%eax, %ecx
	andl	$31, %ecx
	je	.L25
	movl	%r14d, %eax
	movl	%r14d, %edx
	movzwl	%r14w,%esi
	shrl	$16, %eax
	orl	$-65536, %edx
	mov	%ecx, %ecx
	andl	$31, %eax
	testw	%r14w, %r14w
	movl	reg(,%rax,4), %eax
	cmovns	%esi, %edx
	subl	%edx, %eax
	leal	3(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$2, %eax
	testb	%bl, %bl
	cltq
	movl	ram(,%rax,4), %eax
	movl	%eax, reg(,%rcx,4)
	jne	.L122
	jmp	.L133
	.p2align 4,,10
	.p2align 3
.L42:
	movl	%r14d, %ecx
	shrl	$16, %ecx
	andl	$31, %ecx
	je	.L25
	movl	%r14d, %eax
	movl	%r14d, %esi
	mov	%ecx, %ecx
	shrl	$21, %eax
	orl	$-65536, %esi
	andl	$31, %eax
	movl	reg(,%rax,4), %edx
	movzwl	%r14w,%eax
	testw	%r14w, %r14w
	cmovns	%eax, %esi
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	%esi
	testb	%bl, %bl
	movl	%eax, reg(,%rcx,4)
	jne	.L122
	jmp	.L133
	.p2align 4,,10
	.p2align 3
.L41:
	movl	%r14d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L25
	movl	%r14d, %edx
	mov	%eax, %eax
	shrl	$21, %edx
	andl	$31, %edx
	testb	%bl, %bl
	movss	freg(,%rdx,4), %xmm0
	cvttss2si	%xmm0, %edx
	movl	%edx, reg(,%rax,4)
	jne	.L122
	jmp	.L133
	.p2align 4,,10
	.p2align 3
.L40:
	movl	%r14d, %edx
	movl	%r14d, %eax
	shrl	$21, %edx
	shrl	$16, %eax
	andl	$31, %edx
	andl	$31, %eax
	movl	reg(,%rdx,4), %edx
	cmpl	reg(,%rax,4), %edx
	jge	.L25
	jmp	.L128
.L39:
	movl	%r14d, %eax
	shrl	$16, %eax
	movl	%eax, %edx
	andl	$31, %edx
	je	.L25
	movl	%r14d, %ecx
	movl	%r14d, %eax
	movzwl	%r14w,%esi
	shrl	$21, %ecx
	orl	$-65536, %eax
	mov	%edx, %edx
	andl	$31, %ecx
	testw	%r14w, %r14w
	cmovns	%esi, %eax
	imull	reg(,%rcx,4), %eax
	testb	%bl, %bl
	movl	%eax, reg(,%rdx,4)
	jne	.L122
	jmp	.L133
	.p2align 4,,10
	.p2align 3
.L38:
	movl	%r14d, %eax
	shrl	$21, %eax
	andl	$31, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, 12(%rsp)
	movss	12(%rsp), %xmm0
	call	atanf
.L129:
	shrl	$11, %r14d
	movss	%xmm0, 12(%rsp)
	movl	12(%rsp), %edx
	movq	%r14, %rax
	andl	$31, %eax
	testb	%bl, %bl
	movl	%edx, freg(,%rax,4)
	jne	.L122
	jmp	.L133
.L37:
	movl	%r14d, %edx
	movl	%r14d, %eax
	shrl	$21, %edx
	shrl	$16, %eax
	andl	$31, %edx
	andl	$31, %eax
	movl	reg(,%rdx,4), %edx
	cmpl	reg(,%rax,4), %edx
	jne	.L128
	jmp	.L25
.L36:
	cmpb	$7, %bpl
	ja	.L25
	movzbl	%bpl, %eax
	.p2align 4,,7
	.p2align 3
	jmp	*.L98(,%rax,8)
	.section	.rodata
	.align 8
	.align 4
.L98:
	.quad	.L91
	.quad	.L92
	.quad	.L93
	.quad	.L94
	.quad	.L95
	.quad	.L25
	.quad	.L96
	.quad	.L97
	.text
.L35:
	movl	%r14d, %eax
	shrl	$16, %eax
	andl	$31, %eax
	je	.L25
	movl	%r14d, %edx
	movl	%r14d, %ecx
	movzwl	%r14w,%esi
	shrl	$21, %edx
	orl	$-65536, %ecx
	mov	%eax, %eax
	andl	$31, %edx
	testw	%r14w, %r14w
	movl	reg(,%rdx,4), %edx
	cmovns	%esi, %ecx
	subl	%ecx, %edx
	testb	%bl, %bl
	movl	%edx, reg(,%rax,4)
	jne	.L122
	jmp	.L133
	.p2align 4,,10
	.p2align 3
.L34:
	movl	%r14d, %eax
	shrl	$16, %eax
	andl	$31, %eax
	je	.L25
	movl	%r14d, %edx
	movzwl	%r14w,%ecx
	mov	%eax, %eax
	orl	$-65536, %edx
	testw	%r14w, %r14w
	cmovns	%ecx, %edx
	testb	%bl, %bl
	movw	%dx, reg+2(,%rax,4)
	jne	.L122
	jmp	.L133
	.p2align 4,,10
	.p2align 3
.L33:
	movl	%r14d, %eax
	shrl	$21, %eax
	andl	$31, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, 12(%rsp)
	movss	12(%rsp), %xmm0
	call	cosf
	jmp	.L129
.L32:
	movl	%r14d, %edx
	movl	%r14d, %eax
	shrl	$21, %edx
	shrl	$16, %eax
	andl	$31, %edx
	andl	$31, %eax
	movl	reg(,%rdx,4), %edx
	cmpl	reg(,%rax,4), %edx
	jne	.L25
	testw	%r14w, %r14w
	js	.L135
	andl	$65535, %r14d
.L82:
	addl	%r14d, pc(%rip)
	jmp	.L25
.L31:
	movl	%r14d, %eax
	shrl	$16, %eax
	movl	%eax, %edx
	andl	$31, %edx
	je	.L25
	movl	%r14d, %ecx
	movl	%r14d, %eax
	movzwl	%r14w,%esi
	shrl	$21, %ecx
	orl	$-65536, %eax
	mov	%edx, %edx
	andl	$31, %ecx
	testw	%r14w, %r14w
	cmovns	%esi, %eax
	addl	reg(,%rcx,4), %eax
	testb	%bl, %bl
	movl	%eax, reg(,%rdx,4)
	jne	.L122
	jmp	.L133
	.p2align 4,,10
	.p2align 3
.L30:
	movl	%r14d, %eax
	shrl	$16, %eax
	andl	$31, %eax
	je	.L25
	mov	%eax, %edx
	movl	%r14d, %eax
	movzwl	%r14w,%esi
	movl	reg(,%rdx,4), %ecx
	orl	$-65536, %eax
	testw	%r14w, %r14w
	cmovns	%esi, %eax
	xorw	%cx, %cx
	orl	%ecx, %eax
	testb	%bl, %bl
	movl	%eax, reg(,%rdx,4)
	jne	.L122
	jmp	.L133
	.p2align 4,,10
	.p2align 3
.L29:
	movl	%r14d, %eax
	shrl	$21, %eax
	andl	$31, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, 12(%rsp)
	movss	12(%rsp), %xmm0
	call	sinf
	jmp	.L129
.L131:
	movq	stderr(%rip), %rdi
	movq	%rbp, %rcx
	movl	$.LC0, %edx
	movl	$1, %esi
	xorl	%eax, %eax
	call	__fprintf_chk
	addq	$40, %rsp
	movl	$1, %eax
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L134:
	cmpb	$1, %bpl
	jne	.L25
	movl	%r14d, %eax
	movq	stdout(%rip), %rsi
	shrl	$21, %eax
	andl	$31, %eax
	movl	reg(,%rax,4), %edi
	call	_IO_putc
	movq	stdout(%rip), %rdi
	call	fflush
	jmp	.L122
.L135:
	orl	$-65536, %r14d
	jmp	.L82
.L92:
	movl	%r14d, %edx
	movl	%r14d, %eax
	shrl	$21, %edx
	shrl	$11, %eax
	andl	$31, %edx
	andl	$31, %eax
	movl	freg(,%rdx,4), %edx
	movl	%edx, 28(%rsp)
	movl	%r14d, %edx
	shrl	$16, %edx
	movss	28(%rsp), %xmm0
	andl	$31, %edx
	subss	freg(,%rdx,4), %xmm0
	movd	%xmm0, freg(,%rax,4)
	jmp	.L25
.L91:
	movl	%r14d, %ecx
	movl	%r14d, %edx
	movl	%r14d, %eax
	shrl	$16, %ecx
	shrl	$21, %edx
	shrl	$11, %eax
	andl	$31, %ecx
	andl	$31, %edx
	andl	$31, %eax
	movl	freg(,%rcx,4), %ecx
	movl	%ecx, 28(%rsp)
	movss	28(%rsp), %xmm0
	addss	freg(,%rdx,4), %xmm0
	movd	%xmm0, freg(,%rax,4)
	jmp	.L122
.L96:
	movl	%r14d, %edx
	movl	%r14d, %eax
	shrl	$21, %edx
	shrl	$11, %eax
	andl	$31, %edx
	andl	$31, %eax
	movl	freg(,%rdx,4), %edx
	movl	%edx, freg(,%rax,4)
	jmp	.L25
.L94:
	movl	%r14d, %edx
	movl	%r14d, %eax
	shrl	$21, %edx
	shrl	$11, %eax
	andl	$31, %edx
	andl	$31, %eax
	movl	freg(,%rdx,4), %edx
	movl	%edx, 28(%rsp)
	movl	%r14d, %edx
	shrl	$16, %edx
	movss	28(%rsp), %xmm0
	andl	$31, %edx
	divss	freg(,%rdx,4), %xmm0
	movd	%xmm0, freg(,%rax,4)
	jmp	.L25
.L93:
	movl	%r14d, %ecx
	movl	%r14d, %edx
	movl	%r14d, %eax
	shrl	$16, %ecx
	shrl	$21, %edx
	shrl	$11, %eax
	andl	$31, %ecx
	andl	$31, %edx
	andl	$31, %eax
	movl	freg(,%rcx,4), %ecx
	movl	%ecx, 28(%rsp)
	movss	28(%rsp), %xmm0
	mulss	freg(,%rdx,4), %xmm0
	movd	%xmm0, freg(,%rax,4)
	jmp	.L122
.L97:
	movl	%r14d, %eax
	shrl	$21, %eax
	andl	$31, %eax
	movl	freg(,%rax,4), %eax
	testl	%eax, %eax
	js	.L136
	orl	$-2147483648, %eax
.L101:
	movl	%r14d, %edx
	shrl	$11, %edx
	andl	$31, %edx
	movl	%eax, freg(,%rdx,4)
	jmp	.L25
.L112:
	movl	reg+4(%rip), %eax
	movslq	%eax,%rdx
	subl	$4, %eax
	movl	%r13d, ram(,%rdx,4)
	movl	pc(%rip), %r13d
	movl	%eax, reg+4(%rip)
.L105:
	movl	%r14d, %eax
	shrl	$21, %eax
	andl	$31, %eax
	movl	reg(,%rax,4), %eax
	movl	%eax, pc(%rip)
	jmp	.L25
.L111:
	movl	%r14d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L25
	mov	%eax, %edx
	movl	%r14d, %ecx
	movl	%r14d, %eax
	shrl	$16, %eax
	shrl	$21, %ecx
	andl	$31, %eax
	andl	$31, %ecx
	movl	reg(,%rax,4), %eax
	orl	reg(,%rcx,4), %eax
	movl	%eax, reg(,%rdx,4)
	jmp	.L25
.L110:
	movl	%r14d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L25
	mov	%eax, %edx
	movl	%r14d, %ecx
	movl	%r14d, %eax
	shrl	$16, %eax
	shrl	$21, %ecx
	andl	$31, %eax
	andl	$31, %ecx
	movl	reg(,%rax,4), %eax
	andl	reg(,%rcx,4), %eax
	movl	%eax, reg(,%rdx,4)
	jmp	.L25
.L109:
	movl	%r14d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L25
	mov	%eax, %edx
	movl	%r14d, %ecx
	movl	%r14d, %eax
	shrl	$21, %eax
	shrl	$16, %ecx
	andl	$31, %eax
	andl	$31, %ecx
	movl	reg(,%rax,4), %eax
	subl	reg(,%rcx,4), %eax
	movl	%eax, reg(,%rdx,4)
	jmp	.L25
.L108:
	movl	%r14d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L122
	mov	%eax, %edx
	movl	%r14d, %ecx
	movl	%r14d, %eax
	shrl	$16, %eax
	shrl	$21, %ecx
	andl	$31, %eax
	andl	$31, %ecx
	movl	reg(,%rax,4), %eax
	addl	reg(,%rcx,4), %eax
	movl	%eax, reg(,%rdx,4)
	jmp	.L122
.L107:
	movl	%r14d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L25
	mov	%eax, %ecx
	movl	%r14d, %eax
	movl	%r14d, %esi
	shrl	$21, %eax
	shrl	$16, %esi
	andl	$31, %eax
	andl	$31, %esi
	movl	reg(,%rax,4), %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	reg(,%rsi,4)
	movl	%eax, reg(,%rcx,4)
	jmp	.L25
.L106:
	movl	%r14d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L25
	mov	%eax, %edx
	movl	%r14d, %ecx
	movl	%r14d, %eax
	shrl	$16, %eax
	shrl	$21, %ecx
	andl	$31, %eax
	andl	$31, %ecx
	movl	reg(,%rax,4), %eax
	imull	reg(,%rcx,4), %eax
	movl	%eax, reg(,%rdx,4)
	jmp	.L25
.L103:
	movl	%r14d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L25
	mov	%eax, %edx
	movl	%r14d, %ecx
	movl	%r14d, %eax
	shrl	$21, %eax
	shrl	$16, %ecx
	andl	$31, %eax
	andl	$31, %ecx
	movl	reg(,%rcx,4), %ecx
	movl	reg(,%rax,4), %eax
	sall	%cl, %eax
	movl	%eax, reg(,%rdx,4)
	jmp	.L25
.L104:
	movl	%r14d, %eax
	shrl	$11, %eax
	andl	$31, %eax
	je	.L25
	mov	%eax, %edx
	movl	%r14d, %ecx
	movl	%r14d, %eax
	shrl	$21, %eax
	shrl	$16, %ecx
	andl	$31, %eax
	andl	$31, %ecx
	movl	reg(,%rcx,4), %ecx
	movl	reg(,%rax,4), %eax
	sarl	%cl, %eax
	movl	%eax, reg(,%rdx,4)
	jmp	.L25
.L136:
	andl	$2147483647, %eax
	jmp	.L101
	.cfi_endproc
.LFE55:
	.size	simulate, .-simulate
	.comm	reg,128,32
	.comm	freg,128,32
	.comm	rom,16777216,32
	.comm	ram,16777216,32
	.comm	pc,4,4
	.comm	cnt,8,8
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
