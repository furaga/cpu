	.file	"simcho.c"
	.comm	sa,152,32
	.section	.rodata
.LC0:
	.string	"check print_state.c"
.LC1:
	.string	"sigaction"
	.text
.globl main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	call	IMapInit
	movq	-32(%rbp), %rdx
	movl	-20(%rbp), %eax
	movl	%eax, %esi
	movl	$1, %edi
	call	__print_state
	movl	%eax, -8(%rbp)
	cmpl	$0, -8(%rbp)
	jns	.L2
	movl	$.LC0, %edi
	call	puts
	movl	-8(%rbp), %eax
	jmp	.L3
.L2:
	movq	$segv_handler, sa(%rip)
	movl	$sa, %eax
	movl	$0, %edx
	movq	%rax, %rsi
	movl	$11, %edi
	call	sigaction
	testl	%eax, %eax
	je	.L4
	movl	$.LC1, %edi
	call	perror
	movl	$1, %eax
	jmp	.L3
.L4:
	movl	$1, -4(%rbp)
	jmp	.L5
.L7:
	movl	-4(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	-32(%rbp), %rax
	movq	(%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$45, %al
	je	.L6
	movl	-4(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	simulate
.L6:
	addl	$1, -4(%rbp)
.L5:
	movl	-4(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L7
	movl	$0, %eax
.L3:
	leave
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC2:
	.string	"\033$B$;$0$U$)!<\033(B@\n%llu.[%d] ir:%8X "
	.text
.globl segv_handler
	.type	segv_handler, @function
segv_handler:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	movl	%edi, -36(%rbp)
	movl	pc(%rip), %eax
	mov	%eax, %eax
	movl	rom(,%rax,4), %eax
	movl	%eax, -20(%rbp)
	movl	pc(%rip), %ecx
	movq	cnt(%rip), %rdx
	movl	$.LC2, %ebx
	.cfi_offset 3, -24
	movq	stderr(%rip), %rax
	movl	-20(%rbp), %esi
	movl	%esi, %r8d
	movq	%rbx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	stderr(%rip), %rdx
	movl	-20(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	decode_ir
	movq	stderr(%rip), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	fputc
	movl	$2, %esi
	movl	$0, %edi
	call	kill
	addq	$40, %rsp
	popq	%rbx
	leave
	ret
	.cfi_endproc
.LFE1:
	.size	segv_handler, .-segv_handler
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
