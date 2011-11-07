.code64
.section .text
.global Exit
.global OutChar
.global PrintHex8
.global InChar

Exit:
	xorl	%edi, %edi
	movl	$60, %eax
	syscall

#------------------------------------
# print 1 character to stdout
# rax : put char
OutChar:
                pushq    %rdx
                xorl    %edx, %edx
                incl    %edx
                call    OutCharN
                popq    %rdx
                ret

#------------------------------------
# print n characters in rax to stdout
#   rdx : no. of characters
#   destroyed : rax
OutCharN:
                pushq    %rcx
                pushq    %rsi
                pushq    %rdi
                pushq    %rax                 # work buffer on stack
                xorl     %eax, %eax
                incl     %eax                 # 1:to stdout
                movl     %eax, %edi
                movq    %rsp, %rsi
				pushq	%r10
				pushq	%r11
                syscall
				popq	%r11
				popq	%r10
                popq    %rax
                popq    %rdi
                popq    %rsi
                popq    %rcx
                ret
#------------------------------------
# input 1 character from stdin
# rax : get char
InChar:
                pushq   %rcx
                pushq   %rdx
                pushq   %rdi
                pushq   %rsi
                pushq   %rax                 # work buffer on stack
                xorq     %rax, %rax
                xorq     %rdi, %rdi            # 0:from stdin
                movq     %rsp, %rsi            # into Input Buffer
                movl    %edi, %edx
                incl     %edx                 # 1 char
				pushq	%r10
				pushq	%r11
                syscall                     # call kernel
				popq	%r11
				popq	%r10
                popq    %rax                 # retrieve a char from buffer
                popq    %rsi
                popq    %rdi
                popq    %rdx
                popq    %rcx
                ret



#------------------------------------
# print hex number
#   rax : number     edx : digit
PrintHex:
                pushq    %rax
                pushq    %rcx
                pushq    %rbx
                xorl    %ecx, %ecx
                movb    %dl, %cl
    .loop1:     movb    %al, %bl
                andb     $0x0F, %bl
                shrq     $4, %rax
                orb      $0x30, %bl
                cmpb     $0x3A, %bl
                jb      .skip
                addb     $(0x41-0x3A), %bl
    .skip:
                pushq    %rbx
                loop    .loop1
                movb     %dl, %cl
    .loop2:     popq     %rax
                call    OutChar
                loop    .loop2
                popq     %rbx
                popq     %rcx
                popq     %rax
				call NewLine
                ret


#------------------------------------
# print 8 digit hex number (rax)
#   rax : number
#   destroyed : edx
PrintHex8:
                movb    $8, %dl
                jmp    PrintHex

NewLine:
                pushq    %rax
                movb     $0xA, %al
                call    OutChar
                popq     %rax
                ret
