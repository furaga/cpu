
;------------------------------------
; exit with 0
Exit:
		xor     edi, edi
		mov     eax, 60
		syscall

;------------------------------------
; print n characters in rax to stdout
;   rdx : no. of characters
;   destroyed : rax
PutCharN:
		push    rcx
		push    rsi
		push    rdi
		push    rax                 ; work buffer on stack
		xor		eax, eax
		inc     eax
		mov     edi, eax
		mov     rsi, rsp
		syscall
		pop     rax
		pop     rdi
		pop     rsi
		pop     rcx
		ret

;------------------------------------
; print 1 character to stdout
; rax : put char
PutChar:
		push    rdx
		xor     edx, edx
		inc     edx
		call    PutCharN
		pop     rdx
		ret


;------------------------------------
; new line
;   all registers are preserved.
NL:
		push    rax
		mov     al, 0xA
		call    PutChar
		pop     rax
		ret

;------------------------------------
; print binary number
;   rax : number
;   ecx : bit
PrintBin:
		push    rax
		push    rbx
		push    rcx
		push    rdx
		push    rsi
		push    rdi
		mov     rbx, rax
		mov     esi, 64
		mov     ecx, 32
		or      ecx, ecx
		jle     .exit
		cmp     ecx, esi
		jg      .toobig
		mov     edx, ecx
		sub     esi, ecx
		mov     ecx, esi
		shl     rbx, cl
		mov     ecx, edx
		jmp     short .loop
.toobig:
		mov     ecx, esi
.loop:
		mov     al, '0'
		shl     rbx, 1
		jnc     .print_zero
		inc     rax
.print_zero:
		call    PutChar
		loop    .loop
.exit:
		pop     rdi
		pop     rsi
		pop     rdx
		pop     rcx
		pop     rbx
		pop     rax
		call	NL
		ret

;------------------------------------
; print 8 digit hex number (rax)
;   rax : number
;   destroyed : edx
PrintHex8:
		mov    dl, 8
		jmp    short PrintHex

;------------------------------------
; print hex number
;   rax : number     edx : digit
PrintHex:
		push    rax
		push    rcx
		push    rbx
		xor     ecx, ecx
		mov     cl, dl
.loop1:     mov     bl, al
		and     bl, 0x0F
		shr     rax, 4
		or      bl, 0x30
		cmp     bl, 0x3A
		jb      .skip
		add     bl, 0x41 - 0x3A
.skip:
		push    rbx
		loop    .loop1
		mov     cl, dl
.loop2:     pop     rax
		call    PutChar
		loop    .loop2
		pop     rbx
		pop     rcx
		pop     rax
		call	NL
		ret


;------------------------------------
; input 1 character from stdin
; rax : get char
GetChar:
		push    rcx
		push    rdx
		push    rdi
		push    rsi
		push    rax
		xor		eax, eax
		mov     edi, eax
		mov     rsi, rsp
		mov     edx, edi
		inc     edx
		syscall
		pop     rax
		pop     rsi
		pop     rdi
		pop     rdx
		pop     rcx
		ret


	
;------------------------------------
; check the contents of registers for debug
; rax : address 
Chk:
		push	rax
		push	rbx
		push	rdx
		xor		ebx, ebx
.loop:
		mov		eax, [FR0 + ebx * 4]
		call	PrintHex8
		inc		ebx
		cmp		ebx, 32
		jne		.loop
		pop		rdx
		pop		rbx
		pop		rax
		ret
		
	
