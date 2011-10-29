	.file	"encode_op.c"
	.text
	.p2align 4,,15
.globl mvhi
	.type	mvhi, @function
mvhi:
.LFB45:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$1006632960, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE45:
	.size	mvhi, .-mvhi
	.p2align 4,,15
.globl mvlo
	.type	mvlo, @function
mvlo:
.LFB46:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$469762048, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE46:
	.size	mvlo, .-mvlo
	.p2align 4,,15
.globl addi
	.type	addi, @function
addi:
.LFB47:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$536870912, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE47:
	.size	addi, .-addi
	.p2align 4,,15
.globl subi
	.type	subi, @function
subi:
.LFB48:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$1073741824, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE48:
	.size	subi, .-subi
	.p2align 4,,15
.globl muli
	.type	muli, @function
muli:
.LFB49:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$1610612736, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE49:
	.size	muli, .-muli
	.p2align 4,,15
.globl divi
	.type	divi, @function
divi:
.LFB50:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$-2147483648, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE50:
	.size	divi, .-divi
	.p2align 4,,15
.globl slli
	.type	slli, @function
slli:
.LFB51:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$-1610612736, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE51:
	.size	slli, .-slli
	.p2align 4,,15
.globl srli
	.type	srli, @function
srli:
.LFB52:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$-1476395008, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE52:
	.size	srli, .-srli
	.p2align 4,,15
.globl jmp
	.type	jmp, @function
jmp:
.LFB53:
	.cfi_startproc
	movl	%edi, %eax
	orl	$134217728, %eax
	ret
	.cfi_endproc
.LFE53:
	.size	jmp, .-jmp
	.p2align 4,,15
.globl jeq
	.type	jeq, @function
jeq:
.LFB54:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$671088640, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE54:
	.size	jeq, .-jeq
	.p2align 4,,15
.globl jne
	.type	jne, @function
jne:
.LFB55:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$1207959552, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE55:
	.size	jne, .-jne
	.p2align 4,,15
.globl jlt
	.type	jlt, @function
jlt:
.LFB56:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$1744830464, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE56:
	.size	jlt, .-jlt
	.p2align 4,,15
.globl jle
	.type	jle, @function
jle:
.LFB57:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$-2013265920, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE57:
	.size	jle, .-jle
	.p2align 4,,15
.globl call
	.type	call, @function
call:
.LFB58:
	.cfi_startproc
	movl	%edi, %eax
	orl	$-1073741824, %eax
	ret
	.cfi_endproc
.LFE58:
	.size	call, .-call
	.p2align 4,,15
.globl _return
	.type	_return, @function
_return:
.LFB59:
	.cfi_startproc
	movl	%edi, %eax
	orl	$-536870912, %eax
	ret
	.cfi_endproc
.LFE59:
	.size	_return, .-_return
	.p2align 4,,15
.globl ld
	.type	ld, @function
ld:
.LFB60:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$-1946157056, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE60:
	.size	ld, .-ld
	.p2align 4,,15
.globl st
	.type	st, @function
st:
.LFB61:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$-1409286144, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE61:
	.size	st, .-st
	.p2align 4,,15
.globl fld
	.type	fld, @function
fld:
.LFB62:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$-1006632960, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE62:
	.size	fld, .-fld
	.p2align 4,,15
.globl fst
	.type	fst, @function
fst:
.LFB63:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$-469762048, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE63:
	.size	fst, .-fst
	.p2align 4,,15
.globl fjeq
	.type	fjeq, @function
fjeq:
.LFB64:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$-939524096, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE64:
	.size	fjeq, .-fjeq
	.p2align 4,,15
.globl fjlt
	.type	fjlt, @function
fjlt:
.LFB65:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$-402653184, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE65:
	.size	fjlt, .-fjlt
	.p2align 4,,15
.globl setl
	.type	setl, @function
setl:
.LFB66:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzwl	%dx, %edx
	sall	$21, %eax
	sall	$16, %esi
	orl	$335544320, %eax
	orl	%esi, %eax
	orl	%edx, %eax
	ret
	.cfi_endproc
.LFE66:
	.size	setl, .-setl
	.p2align 4,,15
.globl mov
	.type	mov, @function
mov:
.LFB67:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$32, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE67:
	.size	mov, .-mov
	.p2align 4,,15
.globl _not
	.type	_not, @function
_not:
.LFB68:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$27, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE68:
	.size	_not, .-_not
	.p2align 4,,15
.globl input
	.type	input, @function
input:
.LFB69:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$67108864, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE69:
	.size	input, .-input
	.p2align 4,,15
.globl output
	.type	output, @function
output:
.LFB70:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$67108865, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE70:
	.size	output, .-output
	.p2align 4,,15
.globl nop
	.type	nop, @function
nop:
.LFB71:
	.cfi_startproc
	movzbl	%sil, %eax
	movzbl	%dil, %edi
	movzbl	%dl, %edx
	sall	$16, %eax
	sall	$21, %edi
	sall	$11, %edx
	orl	%edi, %eax
	movzbl	%cl, %ecx
	orl	%edx, %eax
	sall	$6, %ecx
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE71:
	.size	nop, .-nop
	.p2align 4,,15
.globl sll
	.type	sll, @function
sll:
.LFB72:
	.cfi_startproc
	movzbl	%sil, %eax
	movzbl	%dil, %edi
	movzbl	%dl, %edx
	sall	$16, %eax
	sall	$21, %edi
	sall	$11, %edx
	orl	%edi, %eax
	movzbl	%cl, %ecx
	orl	%edx, %eax
	sall	$6, %ecx
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE72:
	.size	sll, .-sll
	.p2align 4,,15
.globl srl
	.type	srl, @function
srl:
.LFB73:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$2, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE73:
	.size	srl, .-srl
	.p2align 4,,15
.globl b
	.type	b, @function
b:
.LFB74:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$8, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE74:
	.size	b, .-b
	.p2align 4,,15
.globl add
	.type	add, @function
add:
.LFB75:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$32, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE75:
	.size	add, .-add
	.p2align 4,,15
.globl sub
	.type	sub, @function
sub:
.LFB76:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$34, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE76:
	.size	sub, .-sub
	.p2align 4,,15
.globl mul
	.type	mul, @function
mul:
.LFB77:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$24, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE77:
	.size	mul, .-mul
	.p2align 4,,15
.globl _div
	.type	_div, @function
_div:
.LFB78:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$26, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE78:
	.size	_div, .-_div
	.p2align 4,,15
.globl _and
	.type	_and, @function
_and:
.LFB79:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$36, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE79:
	.size	_and, .-_and
	.p2align 4,,15
.globl _or
	.type	_or, @function
_or:
.LFB80:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$37, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE80:
	.size	_or, .-_or
	.p2align 4,,15
.globl halt
	.type	halt, @function
halt:
.LFB81:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$63, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE81:
	.size	halt, .-halt
	.p2align 4,,15
.globl callr
	.type	callr, @function
callr:
.LFB82:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$48, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE82:
	.size	callr, .-callr
	.p2align 4,,15
.globl fadd
	.type	fadd, @function
fadd:
.LFB83:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$1140850688, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE83:
	.size	fadd, .-fadd
	.p2align 4,,15
.globl fsub
	.type	fsub, @function
fsub:
.LFB84:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$1140850689, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE84:
	.size	fsub, .-fsub
	.p2align 4,,15
.globl fmul
	.type	fmul, @function
fmul:
.LFB85:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$1140850690, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE85:
	.size	fmul, .-fmul
	.p2align 4,,15
.globl fdiv
	.type	fdiv, @function
fdiv:
.LFB86:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$1140850691, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE86:
	.size	fdiv, .-fdiv
	.p2align 4,,15
.globl fsqrt
	.type	fsqrt, @function
fsqrt:
.LFB87:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$1140850692, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE87:
	.size	fsqrt, .-fsqrt
	.p2align 4,,15
.globl _fabs
	.type	_fabs, @function
_fabs:
.LFB88:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$1140850693, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE88:
	.size	_fabs, .-_fabs
	.p2align 4,,15
.globl fmov
	.type	fmov, @function
fmov:
.LFB89:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$1140850694, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE89:
	.size	fmov, .-fmov
	.p2align 4,,15
.globl fneg
	.type	fneg, @function
fneg:
.LFB90:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$1140850695, %eax
	movzbl	%cl, %ecx
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	ret
	.cfi_endproc
.LFE90:
	.size	fneg, .-fneg
	.p2align 4,,15
.globl _sin
	.type	_sin, @function
_sin:
.LFB91:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$402653184, %eax
	movzbl	%cl, %ecx
	movzbl	%r8b, %r8d
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	orl	%r8d, %eax
	ret
	.cfi_endproc
.LFE91:
	.size	_sin, .-_sin
	.p2align 4,,15
.globl _cos
	.type	_cos, @function
_cos:
.LFB92:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$939524096, %eax
	movzbl	%cl, %ecx
	movzbl	%r8b, %r8d
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	orl	%r8d, %eax
	ret
	.cfi_endproc
.LFE92:
	.size	_cos, .-_cos
	.p2align 4,,15
.globl _atan
	.type	_atan, @function
_atan:
.LFB93:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$1476395008, %eax
	movzbl	%cl, %ecx
	movzbl	%r8b, %r8d
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	orl	%r8d, %eax
	ret
	.cfi_endproc
.LFE93:
	.size	_atan, .-_atan
	.p2align 4,,15
.globl _sqrt
	.type	_sqrt, @function
_sqrt:
.LFB94:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$-1207959552, %eax
	movzbl	%cl, %ecx
	movzbl	%r8b, %r8d
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	orl	%r8d, %eax
	ret
	.cfi_endproc
.LFE94:
	.size	_sqrt, .-_sqrt
	.p2align 4,,15
.globl _int_of_float
	.type	_int_of_float, @function
_int_of_float:
.LFB95:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$2013265920, %eax
	movzbl	%cl, %ecx
	movzbl	%r8b, %r8d
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	orl	%r8d, %eax
	ret
	.cfi_endproc
.LFE95:
	.size	_int_of_float, .-_int_of_float
	.p2align 4,,15
.globl _float_of_int
	.type	_float_of_int, @function
_float_of_int:
.LFB96:
	.cfi_startproc
	movzbl	%dil, %eax
	movzbl	%sil, %esi
	movzbl	%dl, %edx
	sall	$21, %eax
	sall	$16, %esi
	sall	$11, %edx
	orl	$-1744830464, %eax
	movzbl	%cl, %ecx
	movzbl	%r8b, %r8d
	orl	%esi, %eax
	sall	$6, %ecx
	orl	%edx, %eax
	orl	%ecx, %eax
	orl	%r8d, %eax
	ret
	.cfi_endproc
.LFE96:
	.size	_float_of_int, .-_float_of_int
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"mov"
.LC1:
	.string	"%s %%g%d, %%g%d"
.LC2:
	.string	"mvhi"
.LC3:
	.string	"%s %%g%d, %d"
.LC4:
	.string	"mvlo"
.LC5:
	.string	"add"
.LC6:
	.string	"%s %%g%d, %%g%d, %%g%d"
.LC7:
	.string	"sub"
.LC8:
	.string	"mul"
.LC9:
	.string	"div"
.LC10:
	.string	"addi"
.LC11:
	.string	"%s %%g%d, %%g%d, %d"
.LC12:
	.string	"subi"
.LC13:
	.string	"muli"
.LC14:
	.string	"divi"
.LC15:
	.string	"input"
.LC16:
	.string	"%s %%g%d"
.LC17:
	.string	"output"
.LC18:
	.string	"and"
.LC19:
	.string	"or"
.LC20:
	.string	"not"
.LC21:
	.string	"sll"
.LC22:
	.string	"srl"
.LC23:
	.string	"slli"
.LC24:
	.string	"srli"
.LC25:
	.string	"b"
.LC26:
	.string	"jmp"
.LC27:
	.string	"%s %s"
.LC28:
	.string	"jeq"
.LC29:
	.string	"%s %%g%d, %%g%d, %s"
.LC30:
	.string	"jne"
.LC31:
	.string	"jlt"
.LC32:
	.string	"jle"
.LC33:
	.string	"call"
.LC34:
	.string	"callR"
.LC35:
	.string	"return"
.LC36:
	.string	"ld"
.LC37:
	.string	"st"
.LC38:
	.string	"fadd"
.LC39:
	.string	"%s %%f%d, %%f%d, %%f%d"
.LC40:
	.string	"fsub"
.LC41:
	.string	"fmul"
.LC42:
	.string	"fdiv"
.LC43:
	.string	"fsqrt"
.LC44:
	.string	"%s %%f%d, %%f%d"
.LC45:
	.string	"fabs"
.LC46:
	.string	"fmov"
.LC47:
	.string	"fneg"
.LC48:
	.string	"fld"
.LC49:
	.string	"%s %%f%d, %%g%d, %d"
.LC50:
	.string	"fst"
.LC51:
	.string	"fjeq"
.LC52:
	.string	"%s %%f%d, %%f%d, %s"
.LC53:
	.string	"fjlt"
.LC54:
	.string	"nop"
.LC55:
	.string	"halt"
.LC56:
	.string	"setL"
.LC57:
	.string	"%s %%g%d, %s"
.LC58:
	.string	"sin"
.LC59:
	.string	"cos"
.LC60:
	.string	"atan"
.LC61:
	.string	"int_of_float"
.LC62:
	.string	"%s %%g%d, %%f%d"
.LC63:
	.string	"float_of_int"
.LC64:
	.string	"%s %%f%d, %%g%d"
	.text
	.p2align 4,,15
.globl encode_op
	.type	encode_op, @function
encode_op:
.LFB44:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	movq	%rsi, %rbp
	.cfi_offset 6, -24
	.cfi_offset 12, -16
	pushq	%rbx
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbx
	.cfi_offset 3, -32
	subq	$544, %rsp
	.cfi_def_cfa_offset 576
	movq	%fs:40, %rax
	movq	%rax, 536(%rsp)
	xorl	%eax, %eax
	movzbl	(%rdi), %eax
	cmpb	.LC0(%rip), %al
	jne	.L106
	movzbl	1(%rdi), %eax
	cmpb	.LC0+1(%rip), %al
	je	.L188
.L106:
	movl	$.LC2, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L189
.L108:
	movl	$.LC4, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L190
.L109:
	movzbl	(%rbx), %edx
	cmpb	.LC5(%rip), %dl
	jne	.L110
	movzbl	1(%rbx), %eax
	cmpb	.LC5+1(%rip), %al
	jne	.L110
	movzbl	2(%rbx), %eax
	cmpb	.LC5+2(%rip), %al
	jne	.L110
	movzbl	3(%rbx), %eax
	cmpb	.LC5+3(%rip), %al
	jne	.L110
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r9
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC6, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	je	.L111
	movzbl	(%rbx), %edx
.L110:
	movzbl	.LC7(%rip), %eax
	cmpb	%dl, %al
	je	.L191
	movl	%edx, %eax
.L113:
	movzbl	.LC8(%rip), %edx
	cmpb	%al, %dl
	jne	.L115
.L215:
	movzbl	1(%rbx), %eax
	cmpb	.LC8+1(%rip), %al
	jne	.L116
	movzbl	2(%rbx), %eax
	cmpb	.LC8+2(%rip), %al
	jne	.L116
	movzbl	3(%rbx), %eax
	cmpb	.LC8+3(%rip), %al
	jne	.L116
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r9
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC6, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	je	.L117
	movzbl	(%rbx), %edx
.L116:
	cmpb	%dl, .LC9(%rip)
	jne	.L118
	movzbl	1(%rbx), %eax
	cmpb	.LC9+1(%rip), %al
	je	.L192
.L118:
	movl	$.LC10, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L193
.L119:
	movl	$.LC12, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L194
.L120:
	movl	$.LC13, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L195
.L121:
	movl	$.LC14, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L196
.L122:
	movl	$.LC15, %edi
	movl	$6, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L197
.L123:
	movl	$.LC17, %edi
	movl	$7, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L198
.L124:
	movzbl	(%rbx), %edx
	cmpb	.LC18(%rip), %dl
	jne	.L125
	movzbl	1(%rbx), %eax
	cmpb	.LC18+1(%rip), %al
	jne	.L125
	movzbl	2(%rbx), %eax
	cmpb	.LC18+2(%rip), %al
	jne	.L125
	movzbl	3(%rbx), %eax
	cmpb	.LC18+3(%rip), %al
	jne	.L125
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r9
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC6, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	je	.L126
	movzbl	(%rbx), %edx
.L125:
	movzbl	.LC19(%rip), %eax
	cmpb	%dl, %al
	jne	.L127
	movzbl	1(%rbx), %edx
	cmpb	.LC19+1(%rip), %dl
	jne	.L128
	movzbl	2(%rbx), %edx
	cmpb	.LC19+2(%rip), %dl
	jne	.L128
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r9
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC6, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	je	.L129
	movzbl	(%rbx), %eax
.L128:
	movzbl	.LC20(%rip), %edx
	cmpb	%al, %dl
	jne	.L130
.L217:
	movzbl	1(%rbx), %eax
	cmpb	.LC20+1(%rip), %al
	jne	.L131
	movzbl	2(%rbx), %eax
	cmpb	.LC20+2(%rip), %al
	jne	.L131
	movzbl	3(%rbx), %eax
	cmpb	.LC20+3(%rip), %al
	jne	.L131
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC1, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	je	.L132
	movzbl	(%rbx), %edx
.L131:
	movzbl	.LC21(%rip), %eax
	cmpb	%dl, %al
	je	.L199
.L133:
	movl	%edx, %eax
.L134:
	cmpb	%al, .LC22(%rip)
	jne	.L136
	movzbl	1(%rbx), %eax
	cmpb	.LC22+1(%rip), %al
	jne	.L136
	movzbl	2(%rbx), %eax
	cmpb	.LC22+2(%rip), %al
	je	.L200
	.p2align 4,,10
	.p2align 3
.L136:
	movl	$.LC23, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L201
.L137:
	movl	$.LC24, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L202
.L138:
	movzbl	(%rbx), %edx
	cmpb	.LC25(%rip), %dl
	jne	.L139
	movzbl	1(%rbx), %eax
	cmpb	.LC25+1(%rip), %al
	jne	.L139
	leaq	8(%rsp), %rcx
	leaq	272(%rsp), %rdx
	xorl	%eax, %eax
	movl	$.LC16, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$2, %eax
	je	.L140
	movzbl	(%rbx), %edx
.L139:
	movzbl	.LC26(%rip), %eax
	cmpb	%dl, %al
	jne	.L141
	movzbl	1(%rbx), %edx
	cmpb	.LC26+1(%rip), %dl
	jne	.L142
	movzbl	2(%rbx), %edx
	cmpb	.LC26+2(%rip), %dl
	jne	.L142
	movzbl	3(%rbx), %edx
	cmpb	.LC26+3(%rip), %dl
	jne	.L142
	leaq	16(%rsp), %r12
	leaq	272(%rsp), %rdx
	xorl	%eax, %eax
	movl	$.LC27, %esi
	movq	%rbp, %rdi
	movq	%r12, %rcx
	call	__isoc99_sscanf
	cmpl	$2, %eax
	je	.L143
	movzbl	(%rbx), %eax
.L142:
	movzbl	.LC28(%rip), %edx
	cmpb	%al, %dl
	jne	.L144
.L226:
	movzbl	1(%rbx), %eax
	cmpb	.LC28+1(%rip), %al
	jne	.L145
	movzbl	2(%rbx), %eax
	cmpb	.LC28+2(%rip), %al
	jne	.L145
	movzbl	3(%rbx), %eax
	cmpb	.LC28+3(%rip), %al
	jne	.L145
	leaq	16(%rsp), %r12
	leaq	8(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC29, %esi
	movq	%r12, %r9
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	je	.L146
	movzbl	(%rbx), %edx
.L145:
	movzbl	.LC30(%rip), %eax
	cmpb	%dl, %al
	jne	.L147
.L227:
	movzbl	1(%rbx), %edx
	cmpb	.LC30+1(%rip), %dl
	jne	.L148
	movzbl	2(%rbx), %edx
	cmpb	.LC30+2(%rip), %dl
	jne	.L148
	movzbl	3(%rbx), %edx
	cmpb	.LC30+3(%rip), %dl
	jne	.L148
	leaq	16(%rsp), %r12
	leaq	8(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC29, %esi
	movq	%r12, %r9
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	je	.L149
	movzbl	(%rbx), %eax
.L148:
	movzbl	.LC31(%rip), %edx
	cmpb	%al, %dl
	jne	.L150
.L228:
	movzbl	1(%rbx), %eax
	cmpb	.LC31+1(%rip), %al
	jne	.L151
	movzbl	2(%rbx), %eax
	cmpb	.LC31+2(%rip), %al
	jne	.L151
	movzbl	3(%rbx), %eax
	cmpb	.LC31+3(%rip), %al
	jne	.L151
	leaq	16(%rsp), %r12
	leaq	8(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC29, %esi
	movq	%r12, %r9
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	je	.L152
	movzbl	(%rbx), %edx
.L151:
	cmpb	%dl, .LC32(%rip)
	jne	.L153
	movzbl	1(%rbx), %eax
	cmpb	.LC32+1(%rip), %al
	jne	.L153
	movzbl	2(%rbx), %eax
	cmpb	.LC32+2(%rip), %al
	je	.L203
	.p2align 4,,10
	.p2align 3
.L153:
	movl	$.LC33, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L204
.L154:
	movl	$.LC34, %edi
	movl	$6, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L205
.L155:
	movl	$7, %ecx
	movl	$.LC35, %edi
	movq	%rbx, %rsi
	repz cmpsb
	movl	$-536870912, %eax
	seta	%cl
	setb	%dl
	cmpb	%dl, %cl
	je	.L107
	movzbl	(%rbx), %eax
	cmpb	.LC36(%rip), %al
	jne	.L157
	movzbl	1(%rbx), %edx
	cmpb	.LC36+1(%rip), %dl
	jne	.L157
	movzbl	2(%rbx), %edx
	cmpb	.LC36+2(%rip), %dl
	jne	.L157
	leaq	8(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r8
	xorl	%eax, %eax
	movq	%rsp, %r9
	movl	$.LC11, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	je	.L158
	movzbl	(%rbx), %eax
.L157:
	cmpb	.LC37(%rip), %al
	jne	.L159
	movzbl	1(%rbx), %eax
	cmpb	.LC37+1(%rip), %al
	je	.L206
.L159:
	movl	$.LC38, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L207
.L160:
	movl	$.LC40, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L208
.L161:
	movl	$.LC41, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L209
.L162:
	movl	$.LC42, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L210
.L163:
	movl	$.LC43, %edi
	movl	$6, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L211
.L164:
	movl	$.LC45, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L212
.L165:
	movl	$.LC46, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L213
.L166:
	movl	$.LC47, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L214
.L167:
	movzbl	(%rbx), %eax
	cmpb	.LC48(%rip), %al
	jne	.L168
	movzbl	1(%rbx), %edx
	cmpb	.LC48+1(%rip), %dl
	jne	.L168
	movzbl	2(%rbx), %edx
	cmpb	.LC48+2(%rip), %dl
	jne	.L168
	movzbl	3(%rbx), %edx
	cmpb	.LC48+3(%rip), %dl
	jne	.L168
	leaq	8(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r8
	xorl	%eax, %eax
	movq	%rsp, %r9
	movl	$.LC49, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	je	.L169
	movzbl	(%rbx), %eax
.L168:
	cmpb	.LC50(%rip), %al
	jne	.L170
	movzbl	1(%rbx), %eax
	cmpb	.LC50+1(%rip), %al
	jne	.L170
	movzbl	2(%rbx), %eax
	cmpb	.LC50+2(%rip), %al
	jne	.L170
	movzbl	3(%rbx), %eax
	cmpb	.LC50+3(%rip), %al
	jne	.L170
	leaq	8(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r8
	xorl	%eax, %eax
	movq	%rsp, %r9
	movl	$.LC49, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L170
	movzwl	(%rsp), %eax
	orl	$-469762048, %eax
	jmp	.L186
	.p2align 4,,10
	.p2align 3
.L191:
	movzbl	1(%rbx), %edx
	cmpb	.LC7+1(%rip), %dl
	jne	.L113
	movzbl	2(%rbx), %edx
	cmpb	.LC7+2(%rip), %dl
	jne	.L113
	movzbl	3(%rbx), %edx
	cmpb	.LC7+3(%rip), %dl
	jne	.L113
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r9
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC6, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	je	.L114
	movzbl	(%rbx), %eax
	movzbl	.LC8(%rip), %edx
	cmpb	%al, %dl
	je	.L215
.L115:
	movl	%eax, %edx
	jmp	.L116
	.p2align 4,,10
	.p2align 3
.L188:
	movzbl	2(%rdi), %eax
	cmpb	.LC0+2(%rip), %al
	jne	.L106
	movzbl	3(%rdi), %eax
	cmpb	.LC0+3(%rip), %al
	jne	.L106
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC1, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L106
	movzbl	8(%rsp), %eax
	movzbl	12(%rsp), %edx
	sall	$21, %eax
	sall	$11, %edx
	orl	%edx, %eax
	orl	$32, %eax
	.p2align 4,,10
	.p2align 3
.L107:
	movq	536(%rsp), %rdx
	xorq	%fs:40, %rdx
	jne	.L216
	addq	$544, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	ret
	.p2align 4,,10
	.p2align 3
.L189:
	leaq	4(%rsp), %rcx
	leaq	272(%rsp), %rdx
	xorl	%eax, %eax
	movq	%rsp, %r8
	movl	$.LC3, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L108
	movzwl	(%rsp), %eax
	movzbl	4(%rsp), %edx
	orl	$1006632960, %eax
	sall	$16, %edx
	orl	%edx, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L190:
	leaq	4(%rsp), %rcx
	leaq	272(%rsp), %rdx
	xorl	%eax, %eax
	movq	%rsp, %r8
	movl	$.LC3, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L109
	movzwl	(%rsp), %eax
	movzbl	4(%rsp), %edx
	orl	$469762048, %eax
	sall	$16, %edx
	orl	%edx, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L127:
	movl	%edx, %eax
	movzbl	.LC20(%rip), %edx
	cmpb	%al, %dl
	je	.L217
.L130:
	movl	%eax, %edx
	movzbl	.LC21(%rip), %eax
	cmpb	%dl, %al
	jne	.L133
.L199:
	movzbl	1(%rbx), %edx
	cmpb	.LC21+1(%rip), %dl
	jne	.L134
	movzbl	2(%rbx), %edx
	cmpb	.LC21+2(%rip), %dl
	jne	.L134
	movzbl	3(%rbx), %edx
	cmpb	.LC21+3(%rip), %dl
	jne	.L134
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r9
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC6, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	je	.L135
	movzbl	(%rbx), %eax
	jmp	.L134
	.p2align 4,,10
	.p2align 3
.L192:
	movzbl	2(%rbx), %eax
	cmpb	.LC9+2(%rip), %al
	jne	.L118
	movzbl	3(%rbx), %eax
	cmpb	.LC9+3(%rip), %al
	jne	.L118
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r9
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC6, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L118
	movzbl	8(%rsp), %eax
	movzbl	4(%rsp), %edx
	sall	$21, %eax
	sall	$16, %edx
	orl	%edx, %eax
	movzbl	12(%rsp), %edx
	orl	$26, %eax
	sall	$11, %edx
	orl	%edx, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L170:
	movl	$.LC51, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L218
.L171:
	movl	$.LC53, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L219
.L172:
	movzbl	(%rbx), %edx
	cmpb	.LC54(%rip), %dl
	je	.L220
.L173:
	movl	$5, %ecx
	movq	%rbx, %rsi
	movl	$.LC55, %edi
	repz cmpsb
	movl	$63, %eax
	seta	%sil
	setb	%cl
	cmpb	%cl, %sil
	je	.L107
	movl	$.LC56, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L221
.L175:
	movzbl	.LC58(%rip), %eax
	cmpb	%dl, %al
	jne	.L177
	movzbl	1(%rbx), %edx
	cmpb	.LC58+1(%rip), %dl
	jne	.L178
	movzbl	2(%rbx), %edx
	cmpb	.LC58+2(%rip), %dl
	jne	.L178
	movzbl	3(%rbx), %edx
	cmpb	.LC58+3(%rip), %dl
	jne	.L178
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC44, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	je	.L179
	movzbl	(%rbx), %eax
.L178:
	cmpb	.LC59(%rip), %al
	jne	.L180
	movzbl	1(%rbx), %eax
	cmpb	.LC59+1(%rip), %al
	jne	.L180
	movzbl	2(%rbx), %eax
	cmpb	.LC59+2(%rip), %al
	jne	.L180
	movzbl	3(%rbx), %eax
	cmpb	.LC59+3(%rip), %al
	jne	.L180
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC44, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	je	.L222
.L180:
	movl	$.LC60, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L223
.L181:
	movl	$.LC61, %edi
	movl	$13, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L224
.L182:
	movl	$.LC63, %edi
	movl	$13, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L225
.L183:
	movl	$-1, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L193:
	leaq	4(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movq	%rsp, %r9
	movl	$.LC11, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L119
	movzwl	(%rsp), %eax
	orl	$536870912, %eax
	.p2align 4,,10
	.p2align 3
.L186:
	movzbl	8(%rsp), %edx
	sall	$21, %edx
	orl	%edx, %eax
	movzbl	4(%rsp), %edx
	sall	$16, %edx
	orl	%edx, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L194:
	leaq	4(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movq	%rsp, %r9
	movl	$.LC11, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L120
	movzwl	(%rsp), %eax
	orl	$1073741824, %eax
	jmp	.L186
	.p2align 4,,10
	.p2align 3
.L195:
	leaq	4(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movq	%rsp, %r9
	movl	$.LC11, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L121
	movzwl	(%rsp), %eax
	orl	$1610612736, %eax
	jmp	.L186
	.p2align 4,,10
	.p2align 3
.L196:
	leaq	4(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movq	%rsp, %r9
	movl	$.LC11, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L122
	movzwl	(%rsp), %eax
	orl	$-2147483648, %eax
	jmp	.L186
	.p2align 4,,10
	.p2align 3
.L197:
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	xorl	%eax, %eax
	movl	$.LC16, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L123
	movzbl	12(%rsp), %eax
	sall	$11, %eax
	orl	$67108864, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L141:
	movl	%edx, %eax
	movzbl	.LC28(%rip), %edx
	cmpb	%al, %dl
	je	.L226
.L144:
	movl	%eax, %edx
	movzbl	.LC30(%rip), %eax
	cmpb	%dl, %al
	je	.L227
.L147:
	movl	%edx, %eax
	movzbl	.LC31(%rip), %edx
	cmpb	%al, %dl
	je	.L228
.L150:
	movl	%eax, %edx
	jmp	.L151
	.p2align 4,,10
	.p2align 3
.L198:
	leaq	8(%rsp), %rcx
	leaq	272(%rsp), %rdx
	xorl	%eax, %eax
	movl	$.LC16, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L124
	movzbl	8(%rsp), %eax
	sall	$21, %eax
	orl	$67108865, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L201:
	leaq	4(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movq	%rsp, %r9
	movl	$.LC11, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L137
	movzwl	(%rsp), %eax
	orl	$-1610612736, %eax
	jmp	.L186
	.p2align 4,,10
	.p2align 3
.L202:
	leaq	4(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movq	%rsp, %r9
	movl	$.LC11, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L138
	movzwl	(%rsp), %eax
	orl	$-1476395008, %eax
	jmp	.L186
	.p2align 4,,10
	.p2align 3
.L204:
	leaq	16(%rsp), %r12
	leaq	272(%rsp), %rdx
	xorl	%eax, %eax
	movl	$.LC27, %esi
	movq	%rbp, %rdi
	movq	%r12, %rcx
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L154
	mov	label_cnt(%rip), %edi
	movq	%r12, %rsi
	salq	$8, %rdi
	addq	$label_name, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	leal	1(%rax), %edx
	orl	$-1073741824, %eax
	movl	%edx, label_cnt(%rip)
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L200:
	movzbl	3(%rbx), %eax
	cmpb	.LC22+3(%rip), %al
	jne	.L136
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r9
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC6, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L136
	movzbl	8(%rsp), %eax
	movzbl	4(%rsp), %edx
	sall	$21, %eax
	sall	$16, %edx
	orl	%edx, %eax
	movzbl	12(%rsp), %edx
	orl	$2, %eax
	sall	$11, %edx
	orl	%edx, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L206:
	movzbl	2(%rbx), %eax
	cmpb	.LC37+2(%rip), %al
	jne	.L159
	leaq	8(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r8
	xorl	%eax, %eax
	movq	%rsp, %r9
	movl	$.LC11, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L159
	movzwl	(%rsp), %eax
	orl	$-1409286144, %eax
	jmp	.L186
	.p2align 4,,10
	.p2align 3
.L220:
	movzbl	1(%rbx), %eax
	cmpb	.LC54+1(%rip), %al
	jne	.L173
	movzbl	2(%rbx), %eax
	cmpb	.LC54+2(%rip), %al
	jne	.L173
	movzbl	3(%rbx), %eax
	cmpb	.LC54+3(%rip), %al
	jne	.L173
	xorl	%eax, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L203:
	movzbl	3(%rbx), %eax
	cmpb	.LC32+3(%rip), %al
	jne	.L153
	leaq	16(%rsp), %r12
	leaq	8(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC29, %esi
	movq	%r12, %r9
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L153
	mov	label_cnt(%rip), %edi
	movq	%r12, %rsi
	salq	$8, %rdi
	addq	$label_name, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	leal	1(%rax), %edx
	movzwl	%ax, %eax
	orl	$-2013265920, %eax
	movl	%edx, label_cnt(%rip)
	jmp	.L186
	.p2align 4,,10
	.p2align 3
.L219:
	leaq	16(%rsp), %r12
	leaq	8(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC52, %esi
	movq	%r12, %r9
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L172
	mov	label_cnt(%rip), %edi
	movq	%r12, %rsi
	salq	$8, %rdi
	addq	$label_name, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	leal	1(%rax), %edx
	movzwl	%ax, %eax
	orl	$-402653184, %eax
	movl	%edx, label_cnt(%rip)
	jmp	.L186
	.p2align 4,,10
	.p2align 3
.L111:
	movzbl	8(%rsp), %eax
	movzbl	4(%rsp), %edx
	sall	$21, %eax
	sall	$16, %edx
	orl	%edx, %eax
	movzbl	12(%rsp), %edx
	orl	$32, %eax
	sall	$11, %edx
	orl	%edx, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L114:
	movzbl	8(%rsp), %eax
	movzbl	4(%rsp), %edx
	sall	$21, %eax
	sall	$16, %edx
	orl	%edx, %eax
	movzbl	12(%rsp), %edx
	orl	$34, %eax
	sall	$11, %edx
	orl	%edx, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L117:
	movzbl	8(%rsp), %eax
	movzbl	4(%rsp), %edx
	sall	$21, %eax
	sall	$16, %edx
	orl	%edx, %eax
	movzbl	12(%rsp), %edx
	orl	$24, %eax
	sall	$11, %edx
	orl	%edx, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L205:
	leaq	8(%rsp), %rcx
	leaq	272(%rsp), %rdx
	xorl	%eax, %eax
	movl	$.LC16, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L155
	movzbl	8(%rsp), %eax
	sall	$21, %eax
	orl	$48, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L207:
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r9
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC39, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L160
	movzbl	8(%rsp), %eax
	movzbl	4(%rsp), %edx
	sall	$21, %eax
	sall	$16, %edx
	orl	%edx, %eax
	movzbl	12(%rsp), %edx
	orl	$1140850688, %eax
	sall	$11, %edx
	orl	%edx, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L208:
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r9
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC39, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L161
	movzbl	8(%rsp), %eax
	movzbl	4(%rsp), %edx
	sall	$21, %eax
	sall	$16, %edx
	orl	%edx, %eax
	movzbl	12(%rsp), %edx
	orl	$1140850689, %eax
	sall	$11, %edx
	orl	%edx, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L209:
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r9
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC39, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L162
	movzbl	8(%rsp), %eax
	movzbl	4(%rsp), %edx
	sall	$21, %eax
	sall	$16, %edx
	orl	%edx, %eax
	movzbl	12(%rsp), %edx
	orl	$1140850690, %eax
	sall	$11, %edx
	orl	%edx, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L210:
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r9
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC39, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L163
	movzbl	8(%rsp), %eax
	movzbl	4(%rsp), %edx
	sall	$21, %eax
	sall	$16, %edx
	orl	%edx, %eax
	movzbl	12(%rsp), %edx
	orl	$1140850691, %eax
	sall	$11, %edx
	orl	%edx, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L211:
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC44, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L164
	movzbl	8(%rsp), %eax
	movzbl	12(%rsp), %edx
	sall	$21, %eax
	sall	$11, %edx
	orl	%edx, %eax
	orl	$1140850692, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L212:
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC44, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L165
	movzbl	8(%rsp), %eax
	movzbl	12(%rsp), %edx
	sall	$21, %eax
	sall	$11, %edx
	orl	%edx, %eax
	orl	$1140850693, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L126:
	movzbl	8(%rsp), %eax
	movzbl	4(%rsp), %edx
	sall	$21, %eax
	sall	$16, %edx
	orl	%edx, %eax
	movzbl	12(%rsp), %edx
	orl	$36, %eax
	sall	$11, %edx
	orl	%edx, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L213:
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC44, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L166
	movzbl	8(%rsp), %eax
	movzbl	12(%rsp), %edx
	sall	$21, %eax
	sall	$11, %edx
	orl	%edx, %eax
	orl	$1140850694, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L129:
	movzbl	8(%rsp), %eax
	movzbl	4(%rsp), %edx
	sall	$21, %eax
	sall	$16, %edx
	orl	%edx, %eax
	movzbl	12(%rsp), %edx
	orl	$37, %eax
	sall	$11, %edx
	orl	%edx, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L214:
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC44, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L167
	movzbl	8(%rsp), %eax
	movzbl	12(%rsp), %edx
	sall	$21, %eax
	sall	$11, %edx
	orl	%edx, %eax
	orl	$1140850695, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L132:
	movzbl	8(%rsp), %eax
	movzbl	12(%rsp), %edx
	sall	$21, %eax
	sall	$11, %edx
	orl	%edx, %eax
	orl	$27, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L135:
	movzbl	4(%rsp), %eax
	movzbl	8(%rsp), %edx
	sall	$16, %eax
	sall	$21, %edx
	orl	%edx, %eax
	movzbl	12(%rsp), %edx
	sall	$11, %edx
	orl	%edx, %eax
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L218:
	leaq	16(%rsp), %r12
	leaq	8(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	4(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC52, %esi
	movq	%r12, %r9
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$4, %eax
	jne	.L171
	mov	label_cnt(%rip), %edi
	movq	%r12, %rsi
	salq	$8, %rdi
	addq	$label_name, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	leal	1(%rax), %edx
	movzwl	%ax, %eax
	orl	$-939524096, %eax
	movl	%edx, label_cnt(%rip)
	jmp	.L186
.L140:
	movzbl	8(%rsp), %eax
	sall	$21, %eax
	orl	$8, %eax
	jmp	.L107
.L177:
	movl	%edx, %eax
	jmp	.L178
.L225:
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC64, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L183
	movzbl	8(%rsp), %eax
	movzbl	12(%rsp), %edx
	sall	$21, %eax
	sall	$11, %edx
	orl	%edx, %eax
	orl	$-1744830464, %eax
	jmp	.L107
.L158:
	movzwl	(%rsp), %eax
	orl	$-1946157056, %eax
	jmp	.L186
.L221:
	leaq	16(%rsp), %r12
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	xorl	%eax, %eax
	movl	$.LC57, %esi
	movq	%rbp, %rdi
	movq	%r12, %r8
	call	__isoc99_sscanf
	cmpl	$3, %eax
	je	.L176
	movzbl	(%rbx), %edx
	jmp	.L175
.L143:
	mov	label_cnt(%rip), %edi
	movq	%r12, %rsi
	salq	$8, %rdi
	addq	$label_name, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	leal	1(%rax), %edx
	orl	$134217728, %eax
	movl	%edx, label_cnt(%rip)
	jmp	.L107
.L146:
	mov	label_cnt(%rip), %edi
	movq	%r12, %rsi
	salq	$8, %rdi
	addq	$label_name, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	leal	1(%rax), %edx
	movzwl	%ax, %eax
	orl	$671088640, %eax
	movl	%edx, label_cnt(%rip)
	jmp	.L186
.L149:
	mov	label_cnt(%rip), %edi
	movq	%r12, %rsi
	salq	$8, %rdi
	addq	$label_name, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	leal	1(%rax), %edx
	movzwl	%ax, %eax
	orl	$1207959552, %eax
	movl	%edx, label_cnt(%rip)
	jmp	.L186
.L152:
	mov	label_cnt(%rip), %edi
	movq	%r12, %rsi
	salq	$8, %rdi
	addq	$label_name, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	leal	1(%rax), %edx
	movzwl	%ax, %eax
	orl	$1744830464, %eax
	movl	%edx, label_cnt(%rip)
	jmp	.L186
.L223:
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC44, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L181
	movzbl	8(%rsp), %eax
	movzbl	12(%rsp), %edx
	sall	$21, %eax
	sall	$11, %edx
	orl	%edx, %eax
	orl	$1476395008, %eax
	jmp	.L107
.L169:
	movzwl	(%rsp), %eax
	orl	$-1006632960, %eax
	jmp	.L186
.L224:
	leaq	12(%rsp), %rcx
	leaq	272(%rsp), %rdx
	leaq	8(%rsp), %r8
	xorl	%eax, %eax
	movl	$.LC62, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	jne	.L182
	movzbl	8(%rsp), %eax
	movzbl	12(%rsp), %edx
	sall	$21, %eax
	sall	$11, %edx
	orl	%edx, %eax
	orl	$2013265920, %eax
	jmp	.L107
.L179:
	movzbl	8(%rsp), %eax
	movzbl	12(%rsp), %edx
	sall	$21, %eax
	sall	$11, %edx
	orl	%edx, %eax
	orl	$402653184, %eax
	jmp	.L107
.L222:
	movzbl	8(%rsp), %eax
	movzbl	12(%rsp), %edx
	sall	$21, %eax
	sall	$11, %edx
	orl	%edx, %eax
	orl	$939524096, %eax
	jmp	.L107
.L216:
	call	__stack_chk_fail
.L176:
	mov	label_cnt(%rip), %edi
	movq	%r12, %rsi
	salq	$8, %rdi
	addq	$label_name, %rdi
	call	strcpy
	movl	label_cnt(%rip), %eax
	leal	1(%rax), %edx
	movzwl	%ax, %eax
	orl	$335544320, %eax
	movl	%edx, label_cnt(%rip)
	movzbl	12(%rsp), %edx
	sall	$16, %edx
	orl	%edx, %eax
	jmp	.L107
	.cfi_endproc
.LFE44:
	.size	encode_op, .-encode_op
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
