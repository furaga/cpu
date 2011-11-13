	.file	"simulate.c"
	.comm	reg,128,32
	.comm	freg,128,32
	.comm	rom,16777216,32
	.comm	ram,16777216,32
	.comm	pc,4,4
	.comm	cnt,8,8
	.text
	.globl	get_opcode
	.type	get_opcode, @function
get_opcode:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	shrl	$26, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	get_opcode, .-get_opcode
	.globl	get_rsi
	.type	get_rsi, @function
get_rsi:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	shrl	$21, %eax
	andl	$31, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	get_rsi, .-get_rsi
	.globl	get_rti
	.type	get_rti, @function
get_rti:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	shrl	$16, %eax
	andl	$31, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	get_rti, .-get_rti
	.globl	get_rdi
	.type	get_rdi, @function
get_rdi:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	shrl	$11, %eax
	andl	$31, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	get_rdi, .-get_rdi
	.globl	get_shamt
	.type	get_shamt, @function
get_shamt:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	shrl	$6, %eax
	andl	$31, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	get_shamt, .-get_shamt
	.globl	get_funct
	.type	get_funct, @function
get_funct:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	andl	$63, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	get_funct, .-get_funct
	.globl	get_target
	.type	get_target, @function
get_target:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	andl	$67108863, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	get_target, .-get_target
	.globl	get_imm
	.type	get_imm, @function
get_imm:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	andl	$32768, %eax
	testl	%eax, %eax
	je	.L9
	movl	-4(%rbp), %eax
	orl	$-65536, %eax
	jmp	.L10
.L9:
	movl	-4(%rbp), %eax
	andl	$65535, %eax
.L10:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	get_imm, .-get_imm
	.section	.rodata
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
	.globl	simulate
	.type	simulate, @function
simulate:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$80, %rsp
	movq	%rdi, -88(%rbp)
	movq	-88(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	.cfi_offset 3, -32
	.cfi_offset 12, -24
	call	open
	movl	%eax, -32(%rbp)
	cmpl	$0, -32(%rbp)
	jns	.L12
	movl	$.LC0, %ecx
	movq	stderr(%rip), %rax
	movq	-88(%rbp), %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$1, %eax
	jmp	.L13
.L12:
	movl	-32(%rbp), %eax
	movl	$16777216, %edx
	movl	$rom, %esi
	movl	%eax, %edi
	call	read
	movl	%eax, -28(%rbp)
	movl	-32(%rbp), %eax
	movl	%eax, %edi
	call	close
	movl	$0, pc(%rip)
	movq	$0, cnt(%rip)
	movl	$4194304, reg+124(%rip)
	movl	reg+124(%rip), %eax
	movl	%eax, reg+4(%rip)
	movl	rom(%rip), %eax
	movl	%eax, -40(%rbp)
	movl	pc(%rip), %eax
	addl	$1, %eax
	movl	%eax, pc(%rip)
	movl	$0, -36(%rbp)
	jmp	.L14
.L15:
	movl	pc(%rip), %eax
	mov	%eax, %eax
	movl	rom(,%rax,4), %edx
	movl	-36(%rbp), %eax
	cltq
	movl	%edx, ram(,%rax,4)
	movl	reg+8(%rip), %eax
	addl	$4, %eax
	movl	%eax, reg+8(%rip)
	subl	$32, -40(%rbp)
	addl	$1, -36(%rbp)
	movl	pc(%rip), %eax
	addl	$1, %eax
	movl	%eax, pc(%rip)
.L14:
	cmpl	$0, -40(%rbp)
	jne	.L15
	movl	$.LC1, %ecx
	movq	stderr(%rip), %rax
	movq	-88(%rbp), %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	stderr(%rip), %rax
	movq	%rax, %rdi
	call	fflush
.L86:
	movl	pc(%rip), %eax
	mov	%eax, %eax
	movl	rom(,%rax,4), %eax
	movl	%eax, -24(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_opcode
	movb	%al, -18(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_funct
	movb	%al, -17(%rbp)
	movq	cnt(%rip), %rax
	addq	$1, %rax
	movq	%rax, cnt(%rip)
	movl	pc(%rip), %eax
	addl	$1, %eax
	movl	%eax, pc(%rip)
	movq	cnt(%rip), %rcx
	movabsq	$-6067343680855748867, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$26, %rax
	imulq	$100000000, %rax, %rax
	movq	%rcx, %rdx
	subq	%rax, %rdx
	movq	%rdx, %rax
	testq	%rax, %rax
	jne	.L16
	movq	stderr(%rip), %rax
	movq	%rax, %rsi
	movl	$46, %edi
	call	fputc
	movq	stderr(%rip), %rax
	movq	%rax, %rdi
	call	fflush
.L16:
	movzbl	-18(%rbp), %eax
	cmpl	$58, %eax
	ja	.L89
	mov	%eax, %eax
	movq	.L46(,%rax,8), %rax
	jmp	*%rax
	.section	.rodata
	.align 8
	.align 4
.L46:
	.quad	.L18
	.quad	.L19
	.quad	.L20
	.quad	.L89
	.quad	.L89
	.quad	.L89
	.quad	.L21
	.quad	.L22
	.quad	.L23
	.quad	.L89
	.quad	.L24
	.quad	.L89
	.quad	.L89
	.quad	.L89
	.quad	.L25
	.quad	.L26
	.quad	.L27
	.quad	.L28
	.quad	.L29
	.quad	.L89
	.quad	.L89
	.quad	.L89
	.quad	.L30
	.quad	.L89
	.quad	.L31
	.quad	.L89
	.quad	.L32
	.quad	.L89
	.quad	.L89
	.quad	.L89
	.quad	.L33
	.quad	.L89
	.quad	.L34
	.quad	.L89
	.quad	.L89
	.quad	.L35
	.quad	.L89
	.quad	.L89
	.quad	.L36
	.quad	.L89
	.quad	.L37
	.quad	.L89
	.quad	.L38
	.quad	.L39
	.quad	.L89
	.quad	.L89
	.quad	.L89
	.quad	.L89
	.quad	.L40
	.quad	.L41
	.quad	.L42
	.quad	.L89
	.quad	.L89
	.quad	.L89
	.quad	.L89
	.quad	.L89
	.quad	.L43
	.quad	.L44
	.quad	.L45
	.text
.L35:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	testl	%eax, %eax
	je	.L47
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	reg(,%rax,4), %r12d
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_imm
	movl	%r12d, %ecx
	subl	%eax, %ecx
	movl	%ecx, %eax
	leal	3(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$2, %eax
	cltq
	movl	ram(,%rax,4), %eax
	movl	%eax, %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L47
.L39:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	reg(,%rax,4), %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_imm
	movl	%ebx, %edx
	subl	%eax, %edx
	movl	%edx, %eax
	leal	3(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$2, %eax
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	movl	%eax, %edx
	movslq	%ebx, %rax
	movl	%edx, ram(,%rax,4)
	jmp	.L47
.L41:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	reg(,%rax,4), %r12d
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_imm
	movl	%r12d, %ecx
	subl	%eax, %ecx
	movl	%ecx, %eax
	leal	3(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$2, %eax
	cltq
	movl	ram(,%rax,4), %edx
	mov	%ebx, %eax
	movl	%edx, freg(,%rax,4)
	jmp	.L47
.L29:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	cmpl	%eax, %ebx
	je	.L90
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_imm
	movl	%eax, %edx
	movl	pc(%rip), %eax
	addl	%edx, %eax
	movl	%eax, pc(%rip)
	jmp	.L90
.L23:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	testl	%eax, %eax
	je	.L47
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %r12d
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_imm
	leal	(%r12,%rax), %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L47
.L37:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	testl	%eax, %eax
	je	.L47
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %r12d
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_imm
	movl	%r12d, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L47
.L20:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_target
	movl	%eax, pc(%rip)
	jmp	.L47
.L45:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, -80(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, -64(%rbp)
	movss	-80(%rbp), %xmm1
	movss	-64(%rbp), %xmm0
	ucomiss	%xmm1, %xmm0
	seta	%al
	testb	%al, %al
	je	.L91
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_imm
	movl	%eax, %edx
	movl	pc(%rip), %eax
	addl	%edx, %eax
	movl	%eax, pc(%rip)
	jmp	.L91
.L44:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	reg(,%rax,4), %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_imm
	movl	%ebx, %edx
	subl	%eax, %edx
	movl	%edx, %eax
	leal	3(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$2, %eax
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	freg(,%rax,4), %edx
	movslq	%ebx, %rax
	movl	%edx, ram(,%rax,4)
	jmp	.L47
.L27:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	testl	%eax, %eax
	je	.L47
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %r12d
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_imm
	movl	%r12d, %edx
	subl	%eax, %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L47
.L43:
	movl	reg+120(%rip), %eax
	movl	%eax, pc(%rip)
	movl	reg+4(%rip), %eax
	addl	$4, %eax
	movl	%eax, reg+4(%rip)
	movl	reg+4(%rip), %eax
	cltq
	movl	ram(,%rax,4), %eax
	movl	%eax, reg+120(%rip)
	jmp	.L47
.L42:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, -80(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, -64(%rbp)
	movss	-80(%rbp), %xmm0
	movss	-64(%rbp), %xmm1
	ucomiss	%xmm1, %xmm0
	jp	.L92
	ucomiss	%xmm1, %xmm0
	jne	.L88
.L87:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_imm
	movl	%eax, %edx
	movl	pc(%rip), %eax
	addl	%edx, %eax
	movl	%eax, pc(%rip)
	jmp	.L92
.L88:
	jmp	.L92
.L32:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	cmpl	%eax, %ebx
	jge	.L93
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_imm
	movl	%eax, %edx
	movl	pc(%rip), %eax
	addl	%edx, %eax
	movl	%eax, pc(%rip)
	jmp	.L93
.L40:
	movl	reg+4(%rip), %eax
	movl	reg+120(%rip), %edx
	cltq
	movl	%edx, ram(,%rax,4)
	movl	reg+4(%rip), %eax
	subl	$4, %eax
	movl	%eax, reg+4(%rip)
	movl	pc(%rip), %eax
	movl	%eax, reg+120(%rip)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_target
	movl	%eax, pc(%rip)
	jmp	.L47
.L38:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	testl	%eax, %eax
	je	.L47
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %r12d
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_imm
	movl	%r12d, %edx
	movl	%eax, %ecx
	sarl	%cl, %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L47
.L24:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	cmpl	%eax, %ebx
	jne	.L94
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_imm
	movl	%eax, %edx
	movl	pc(%rip), %eax
	addl	%edx, %eax
	movl	%eax, pc(%rip)
	jmp	.L94
.L31:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	testl	%eax, %eax
	je	.L47
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %r12d
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_imm
	movl	%r12d, %edx
	imull	%eax, %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L47
.L26:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	testl	%eax, %eax
	je	.L47
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_imm
	movl	%eax, %r12d
	sall	$16, %r12d
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	andl	$65535, %eax
	orl	%r12d, %eax
	movl	%eax, %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L47
.L22:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	testl	%eax, %eax
	je	.L47
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	movl	%eax, %r12d
	movw	$0, %r12w
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_imm
	andl	$65535, %eax
	movl	%r12d, %edx
	orl	%eax, %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L47
.L34:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	testl	%eax, %eax
	je	.L47
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %r12d
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_imm
	movl	%eax, -96(%rbp)
	movl	%r12d, %eax
	movl	%eax, %edx
	sarl	$31, %edx
	idivl	-96(%rbp)
	movl	%eax, %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L47
.L21:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, -80(%rbp)
	movss	-80(%rbp), %xmm0
	call	sinf
	movss	%xmm0, -48(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	-48(%rbp), %edx
	mov	%eax, %eax
	movl	%edx, freg(,%rax,4)
	jmp	.L47
.L25:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, -80(%rbp)
	movss	-80(%rbp), %xmm0
	call	cosf
	movss	%xmm0, -48(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	-48(%rbp), %edx
	mov	%eax, %eax
	movl	%edx, freg(,%rax,4)
	jmp	.L47
.L30:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, -80(%rbp)
	movss	-80(%rbp), %xmm0
	call	atanf
	movss	%xmm0, -48(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	-48(%rbp), %edx
	mov	%eax, %eax
	movl	%edx, freg(,%rax,4)
	jmp	.L47
.L33:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	testl	%eax, %eax
	je	.L47
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, -80(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movss	-80(%rbp), %xmm0
	cvttss2si	%xmm0, %edx
	mov	%eax, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L47
.L36:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	cvtsi2ss	%eax, %xmm0
	movss	%xmm0, -80(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	-80(%rbp), %edx
	mov	%eax, %eax
	movl	%edx, freg(,%rax,4)
	jmp	.L47
.L28:
	movzbl	-17(%rbp), %eax
	cmpl	$7, %eax
	ja	.L95
	mov	%eax, %eax
	movq	.L63(,%rax,8), %rax
	jmp	*%rax
	.section	.rodata
	.align 8
	.align 4
.L63:
	.quad	.L55
	.quad	.L56
	.quad	.L57
	.quad	.L58
	.quad	.L59
	.quad	.L60
	.quad	.L61
	.quad	.L62
	.text
.L57:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, -80(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, -64(%rbp)
	movss	-80(%rbp), %xmm1
	movss	-64(%rbp), %xmm0
	mulss	%xmm1, %xmm0
	movss	%xmm0, -48(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	-48(%rbp), %edx
	mov	%eax, %eax
	movl	%edx, freg(,%rax,4)
	jmp	.L64
.L55:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, -80(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, -64(%rbp)
	movss	-80(%rbp), %xmm1
	movss	-64(%rbp), %xmm0
	addss	%xmm1, %xmm0
	movss	%xmm0, -48(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	-48(%rbp), %edx
	mov	%eax, %eax
	movl	%edx, freg(,%rax,4)
	jmp	.L64
.L56:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, -80(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, -64(%rbp)
	movss	-80(%rbp), %xmm0
	movss	-64(%rbp), %xmm1
	subss	%xmm1, %xmm0
	movss	%xmm0, -48(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	-48(%rbp), %edx
	mov	%eax, %eax
	movl	%edx, freg(,%rax,4)
	jmp	.L64
.L60:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, %edx
	andl	$2147483647, %edx
	mov	%ebx, %eax
	movl	%edx, freg(,%rax,4)
	jmp	.L64
.L61:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	freg(,%rax,4), %edx
	mov	%ebx, %eax
	movl	%edx, freg(,%rax,4)
	jmp	.L64
.L62:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	testl	%eax, %eax
	jns	.L65
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	andl	$2147483647, %eax
	jmp	.L66
.L65:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	orl	$-2147483648, %eax
.L66:
	mov	%ebx, %edx
	movl	%eax, freg(,%rdx,4)
	jmp	.L64
.L59:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, -80(%rbp)
	movss	-80(%rbp), %xmm1
	sqrtss	%xmm1, %xmm0
	ucomiss	%xmm0, %xmm0
	jp	.L68
	ucomiss	%xmm0, %xmm0
	je	.L67
.L68:
	movaps	%xmm1, %xmm0
	call	sqrtf
.L67:
	movss	%xmm0, -92(%rbp)
	movl	-92(%rbp), %eax
	movl	%eax, -48(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	-48(%rbp), %edx
	mov	%eax, %eax
	movl	%edx, freg(,%rax,4)
	jmp	.L64
.L58:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, -80(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	freg(,%rax,4), %eax
	movl	%eax, -64(%rbp)
	movss	-80(%rbp), %xmm0
	movss	-64(%rbp), %xmm1
	divss	%xmm1, %xmm0
	movss	%xmm0, -48(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	-48(%rbp), %edx
	mov	%eax, %eax
	movl	%edx, freg(,%rax,4)
	jmp	.L64
.L95:
	nop
.L64:
	jmp	.L47
.L18:
	movzbl	-17(%rbp), %eax
	cmpl	$63, %eax
	ja	.L96
	mov	%eax, %eax
	movq	.L81(,%rax,8), %rax
	jmp	*%rax
	.section	.rodata
	.align 8
	.align 4
.L81:
	.quad	.L70
	.quad	.L96
	.quad	.L71
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L72
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L73
	.quad	.L96
	.quad	.L74
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L75
	.quad	.L96
	.quad	.L76
	.quad	.L96
	.quad	.L77
	.quad	.L78
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L79
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.quad	.L96
	.text
.L75:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	testl	%eax, %eax
	je	.L97
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %r12d
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	leal	(%r12,%rax), %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L82
.L79:
	movl	reg+4(%rip), %eax
	movl	reg+120(%rip), %edx
	cltq
	movl	%edx, ram(,%rax,4)
	movl	reg+4(%rip), %eax
	subl	$4, %eax
	movl	%eax, reg+4(%rip)
	movl	pc(%rip), %eax
	movl	%eax, reg+120(%rip)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	movl	%eax, pc(%rip)
	jmp	.L82
.L72:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	movl	%eax, pc(%rip)
	jmp	.L82
.L76:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	testl	%eax, %eax
	je	.L97
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %r12d
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	movl	%r12d, %edx
	subl	%eax, %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L82
.L73:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	testl	%eax, %eax
	je	.L97
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %r12d
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	movl	%r12d, %edx
	imull	%eax, %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L82
.L74:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	testl	%eax, %eax
	je	.L97
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %r12d
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	movl	%eax, -96(%rbp)
	movl	%r12d, %eax
	movl	%eax, %edx
	sarl	$31, %edx
	idivl	-96(%rbp)
	movl	%eax, %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L82
.L77:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	testl	%eax, %eax
	je	.L97
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %r12d
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	movl	%r12d, %edx
	andl	%eax, %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L82
.L78:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	testl	%eax, %eax
	je	.L97
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %r12d
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	movl	%r12d, %edx
	orl	%eax, %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L82
.L70:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	testl	%eax, %eax
	je	.L97
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %r12d
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	movl	%r12d, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L82
.L71:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	testl	%eax, %eax
	je	.L97
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %r12d
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rti
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	movl	%r12d, %edx
	movl	%eax, %ecx
	sarl	%cl, %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	jmp	.L82
.L96:
	nop
.L82:
	jmp	.L97
.L19:
	movzbl	-17(%rbp), %eax
	testl	%eax, %eax
	je	.L84
	cmpl	$1, %eax
	jne	.L83
.L85:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	movl	%eax, -80(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rsi
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	movl	%eax, %edi
	call	putchar
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush
	jmp	.L83
.L84:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	mov	%eax, %eax
	salq	$2, %rax
	leaq	reg(%rax), %rdx
	movl	$.LC2, %eax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_scanf
	movl	%eax, -28(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	testl	%eax, %eax
	je	.L98
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	movl	%eax, %ebx
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	get_rdi
	mov	%eax, %eax
	movl	reg(,%rax,4), %eax
	movzbl	%al, %edx
	mov	%ebx, %eax
	movl	%edx, reg(,%rax,4)
	nop
.L83:
	jmp	.L98
.L89:
	nop
	jmp	.L47
.L90:
	nop
	jmp	.L47
.L91:
	nop
	jmp	.L47
.L92:
	nop
	jmp	.L47
.L93:
	nop
	jmp	.L47
.L94:
	nop
	jmp	.L47
.L97:
	nop
	jmp	.L47
.L98:
	nop
.L47:
	cmpb	$63, -17(%rbp)
	jne	.L86
	cmpb	$0, -18(%rbp)
	jne	.L86
	movq	stderr(%rip), %rax
	movq	%rax, %rdx
	movl	$.LC3, %eax
	movq	%rdx, %rcx
	movl	$23, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	fwrite
	movq	cnt(%rip), %rdx
	movl	$.LC4, %ecx
	movq	stderr(%rip), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	stderr(%rip), %rax
	movq	%rax, %rdi
	call	fflush
	movl	$0, %eax
.L13:
	addq	$80, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	simulate, .-simulate
	.ident	"GCC: (Ubuntu/Linaro 4.6.1-9ubuntu3) 4.6.1"
	.section	.note.GNU-stack,"",@progbits
