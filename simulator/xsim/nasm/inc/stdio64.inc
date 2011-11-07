;---------------------------------------------------------------------
; file          : stdio64.inc
; created       : 2010/06/08
; assembler     : nasm 2.07
; description   : standerd input/output version 1.0
;
;Copyright (C) 2010 Jun Mizutani <mizutani.jun@nifty.ne.jp>
;---------------------------------------------------------------------

%ifndef __STDIO64_INC
%define __STDIO64_INC

%ifndef __SYSCALL64_INC
%endif
global Exit:function
global OutChar:function
global PrintHex8:function
global InChar:function

%assign SYS_read                    0
%assign SYS_write                   1
%assign SYS_open                    2
%assign SYS_close                   3
%assign SYS_stat                    4
%assign SYS_fstat                   5
%assign SYS_lstat                   6
%assign SYS_poll                    7
%assign SYS_lseek                   8
%assign SYS_mmap                    9
%assign SYS_mprotect                10
%assign SYS_munmap                  11
%assign SYS_brk                     12
%assign SYS_rt_sigaction            13
%assign SYS_rt_sigprocmask          14
%assign SYS_rt_sigreturn            15
%assign SYS_ioctl                   16
%assign SYS_pread64                 17
%assign SYS_pwrite64                18
%assign SYS_readv                   19
%assign SYS_writev                  20
%assign SYS_access                  21
%assign SYS_pipe                    22
%assign SYS_select                  23
%assign SYS_sched_yield             24
%assign SYS_mremap                  25
%assign SYS_msync                   26
%assign SYS_mincore                 27
%assign SYS_madvise                 28
%assign SYS_shmget                  29
%assign SYS_shmat                   30
%assign SYS_shmctl                  31
%assign SYS_dup                     32
%assign SYS_dup2                    33
%assign SYS_pause                   34
%assign SYS_nanosleep               35
%assign SYS_getitimer               36
%assign SYS_alarm                   37
%assign SYS_setitimer               38
%assign SYS_getpid                  39
%assign SYS_sendfile                40
%assign SYS_socket                  41
%assign SYS_connect                 42
%assign SYS_accept                  43
%assign SYS_sendto                  44
%assign SYS_recvfrom                45
%assign SYS_sendmsg                 46
%assign SYS_recvmsg                 47
%assign SYS_shutdown                48
%assign SYS_bind                    49
%assign SYS_listen                  50
%assign SYS_getsockname             51
%assign SYS_getpeername             52
%assign SYS_socketpair              53
%assign SYS_setsockopt              54
%assign SYS_getsockopt              55
%assign SYS_clone                   56
%assign SYS_fork                    57
%assign SYS_vfork                   58
%assign SYS_execve                  59
%assign SYS_exit                    60
%assign SYS_wait4                   61
%assign SYS_kill                    62
%assign SYS_uname                   63
%assign SYS_semget                  64
%assign SYS_semop                   65
%assign SYS_semctl                  66
%assign SYS_shmdt                   67
%assign SYS_msgget                  68
%assign SYS_msgsnd                  69
%assign SYS_msgrcv                  70
%assign SYS_msgctl                  71
%assign SYS_fcntl                   72
%assign SYS_flock                   73
%assign SYS_fsync                   74
%assign SYS_fdatasync               75
%assign SYS_truncate                76
%assign SYS_ftruncate               77
%assign SYS_getdents                78
%assign SYS_getcwd                  79
%assign SYS_chdir                   80
%assign SYS_fchdir                  81
%assign SYS_rename                  82
%assign SYS_mkdir                   83
%assign SYS_rmdir                   84
%assign SYS_creat                   85
%assign SYS_link                    86
%assign SYS_unlink                  87
%assign SYS_symlink                 88
%assign SYS_readlink                89
%assign SYS_chmod                   90
%assign SYS_fchmod                  91
%assign SYS_chown                   92
%assign SYS_fchown                  93
%assign SYS_lchown                  94
%assign SYS_umask                   95
%assign SYS_gettimeofday            96
%assign SYS_getrlimit               97
%assign SYS_getrusage               98
%assign SYS_sysinfo                 99
%assign SYS_times                   100
%assign SYS_ptrace                  101
%assign SYS_getuid                  102
%assign SYS_syslog                  103
%assign SYS_getgid                  104
%assign SYS_setuid                  105
%assign SYS_setgid                  106
%assign SYS_geteuid                 107
%assign SYS_getegid                 108
%assign SYS_setpgid                 109
%assign SYS_getppid                 110
%assign SYS_getpgrp                 111
%assign SYS_setsid                  112
%assign SYS_setreuid                113
%assign SYS_setregid                114
%assign SYS_getgroups               115
%assign SYS_setgroups               116
%assign SYS_setresuid               117
%assign SYS_getresuid               118
%assign SYS_setresgid               119
%assign SYS_getresgid               120
%assign SYS_getpgid                 121
%assign SYS_setfsuid                122
%assign SYS_setfsgid                123
%assign SYS_getsid                  124
%assign SYS_capget                  125
%assign SYS_capset                  126
%assign SYS_rt_sigpending           127
%assign SYS_rt_sigtimedwait         128
%assign SYS_rt_sigqueueinfo         129
%assign SYS_rt_sigsuspend           130
%assign SYS_sigaltstack             131
%assign SYS_utime                   132
%assign SYS_mknod                   133
%assign SYS_uselib                  134
%assign SYS_personality             135
%assign SYS_ustat                   136
%assign SYS_statfs                  137
%assign SYS_fstatfs                 138
%assign SYS_sysfs                   139
%assign SYS_getpriority             140
%assign SYS_setpriority             141
%assign SYS_sched_setparam          142
%assign SYS_sched_getparam          143
%assign SYS_sched_setscheduler      144
%assign SYS_sched_getscheduler      145
%assign SYS_sched_get_priority_max  146
%assign SYS_sched_get_priority_min  147
%assign SYS_sched_rr_get_interval   148
%assign SYS_mlock                   149
%assign SYS_munlock                 150
%assign SYS_mlockall                151
%assign SYS_munlockall              152
%assign SYS_vhangup                 153
%assign SYS_modify_ldt              154
%assign SYS_pivot_root              155
%assign SYS__sysctl                 156
%assign SYS_prctl                   157
%assign SYS_arch_prctl              158
%assign SYS_adjtimex                159
%assign SYS_setrlimit               160
%assign SYS_chroot                  161
%assign SYS_sync                    162
%assign SYS_acct                    163
%assign SYS_settimeofday            164
%assign SYS_mount                   165
%assign SYS_umount2                 166
%assign SYS_swapon                  167
%assign SYS_swapoff                 168
%assign SYS_reboot                  169
%assign SYS_sethostname             170
%assign SYS_setdomainname           171
%assign SYS_iopl                    172
%assign SYS_ioperm                  173
%assign SYS_create_module           174
%assign SYS_init_module             175
%assign SYS_delete_module           176
%assign SYS_get_kernel_syms         177
%assign SYS_query_module            178
%assign SYS_quotactl                179
%assign SYS_nfsservctl              180
%assign SYS_getpmsg                 181
%assign SYS_putpmsg                 182
%assign SYS_afs_syscall             183
%assign SYS_tuxcall                 184
%assign SYS_security                185
%assign SYS_gettid                  186
%assign SYS_readahead               187
%assign SYS_setxattr                188
%assign SYS_lsetxattr               189
%assign SYS_fsetxattr               190
%assign SYS_getxattr                191
%assign SYS_lgetxattr               192
%assign SYS_fgetxattr               193
%assign SYS_listxattr               194
%assign SYS_llistxattr              195
%assign SYS_flistxattr              196
%assign SYS_removexattr             197
%assign SYS_lremovexattr            198
%assign SYS_fremovexattr            199
%assign SYS_tkill                   200
%assign SYS_time                    201
%assign SYS_futex                   202
%assign SYS_sched_setaffinity       203
%assign SYS_sched_getaffinity       204
%assign SYS_set_thread_area         205
%assign SYS_io_setup                206
%assign SYS_io_destroy              207
%assign SYS_io_getevents            208
%assign SYS_io_submit               209
%assign SYS_io_cancel               210
%assign SYS_get_thread_area         211
%assign SYS_lookup_dcookie          212
%assign SYS_epoll_create            213
%assign SYS_epoll_ctl_old           214
%assign SYS_epoll_wait_old          215
%assign SYS_remap_file_pages        216
%assign SYS_getdents64              217
%assign SYS_set_tid_address         218
%assign SYS_restart_syscall         219
%assign SYS_semtimedop              220
%assign SYS_fadvise64               221
%assign SYS_timer_create            222
%assign SYS_timer_settime           223
%assign SYS_timer_gettime           224
%assign SYS_timer_getoverrun        225
%assign SYS_timer_delete            226
%assign SYS_clock_settime           227
%assign SYS_clock_gettime           228
%assign SYS_clock_getres            229
%assign SYS_clock_nanosleep         230
%assign SYS_exit_group              231
%assign SYS_epoll_wait              232
%assign SYS_epoll_ctl               233
%assign SYS_tgkill                  234
%assign SYS_utimes                  235
%assign SYS_vserver                 236
%assign SYS_mbind                   237
%assign SYS_set_mempolicy           238
%assign SYS_get_mempolicy           239
%assign SYS_mq_open                 240
%assign SYS_mq_unlink               241
%assign SYS_mq_timedsend            242
%assign SYS_mq_timedreceive         243
%assign SYS_mq_notify               244
%assign SYS_mq_getsetattr           245
%assign SYS_kexec_load              246
%assign SYS_waitid                  247
%assign SYS_add_key                 248
%assign SYS_request_key             249
%assign SYS_keyctl                  250
%assign SYS_ioprio_set              251
%assign SYS_ioprio_get              252
%assign SYS_inotify_init            253
%assign SYS_inotify_add_watch       254
%assign SYS_inotify_rm_watch        255
%assign SYS_migrate_pages           256
%assign SYS_openat                  257
%assign SYS_mkdirat                 258
%assign SYS_mknodat                 259
%assign SYS_fchownat                260
%assign SYS_futimesat               261
%assign SYS_newfstatat              262
%assign SYS_unlinkat                263
%assign SYS_renameat                264
%assign SYS_linkat                  265
%assign SYS_symlinkat               266
%assign SYS_readlinkat              267
%assign SYS_fchmodat                268
%assign SYS_faccessat               269
%assign SYS_pselect6                270
%assign SYS_ppoll                   271
%assign SYS_unshare                 272
%assign SYS_set_robust_list         273
%assign SYS_get_robust_list         274
%assign SYS_splice                  275
%assign SYS_tee                     276
%assign SYS_sync_file_range         277
%assign SYS_vmsplice                278
%assign SYS_move_pages              279
%assign SYS_utimensat               280
%assign SYS_epoll_pwait             281
%assign SYS_signalfd                282
%assign SYS_timerfd_create          283
%assign SYS_eventfd                 284
%assign SYS_fallocate               285
%assign SYS_timerfd_settime         286
%assign SYS_timerfd_gettime         287
%assign SYS_accept4                 288
%assign SYS_signalfd4               289
%assign SYS_eventfd2                290
%assign SYS_epoll_create1           291
%assign SYS_dup3                    292
%assign SYS_pipe2                   293
%assign SYS_inotify_init1           294

;------------------------------------
; exit with 0
Exit:
                xor     edi, edi            ; exit with code 0
                mov     eax, SYS_exit
                syscall

;------------------------------------
; exit with ebx
ExitN:
               mov      rdi, rax            ; exit with code ebx
               mov      eax, SYS_exit
               syscall

;------------------------------------
; print string to stdout
; rax : buffer top address
; rdx : no of char to output
OutString:
                push    rcx
                push    rsi
                push    rdi
                mov     rsi, rax
    .out        mov     eax, SYS_write
                xor     edi, edi            ; 0 extends to 64bit
                inc     edi                 ; to stdout
				push	r10
				push	r11
                syscall
				pop		r11
				pop		r10
                pop     rdi
                pop     rsi
                pop     rcx
                ret

;------------------------------------
; print pascal string to stdout
; rbx : buffer top address
OutPString:
                push    rax
                push    rcx
                push    rsi
                push    rdi
                push    rdx
                xor     edx, edx
                mov     dl, [rbx]
                mov     rsi, rbx
                inc     rsi
                jmp     short  OutAsciiZ.out

;------------------------------------
; print asciiz string
; rax : pointer to string
OutAsciiZ:
                push    rax
                push    rcx
                push    rsi
                push    rdi
                push    rdx
                push    rax
                call    StrLen
                mov     rdx, rax            ; set length
                pop     rsi                 ; set address (rax-->ecx)
    .out        mov     eax, SYS_write
                xor     edi, edi            ; 0 extends to 64bit
                inc     edi                 ; to stdout
				push	r10
				push	r11
                syscall
				pop		r11
				pop		r10
                pop     rdx
                pop     rdi
                pop     rsi
                pop     rcx
                pop     rax
                ret

;------------------------------------
; get length of asciiz string
; rax : top address
; rax : return length
StrLen:
                push    rbx
                push    rcx
                xor     ecx, ecx
    .next       mov     bl, [rax+rcx]
                inc     rcx
                cmp     bl, 0
                jnz     short .next
                dec     rcx
                mov     rax, rcx
                pop     rcx
                pop     rbx
                ret

                push    rcx
                push    rdi
                mov     rdi, rax
                push    rax
                xor     eax, eax
                xor     ecx, ecx
                dec     rcx
         repne  scasb
                pop     rcx
                sub     rdi, rcx
                mov     rax, rdi
                dec     rax
                pop     rdi
                pop     rcx
                ret

;------------------------------------
; print 4 characters in rax to stdout
;   destroyed : rax
OutChar4:
                push    rcx
                mov     ch, 0x04
                mov     cl, 0x08
    .loop:      and     al, 0x7F            ; 7bit only
                test    al, al
                jz      .dot
                cmp     al, 0x20
                jae     .output
    .dot:       mov     al, '.'
    .output:    call    OutChar
                shr     rax, cl
                dec     ch
                jnz     .loop
                pop     rcx
                ret

;------------------------------------
; print 1 character to stdout
; rax : put char
OutChar:
                push    rdx
                xor     edx, edx
                inc     edx
                call    OutCharN
                pop     rdx
                ret

;------------------------------------
; print 4 characters in rax to stdout
;   destroyed : rax
OutChar4B:
                push    rdx
                xor     edx, edx
                mov     dl, 4
                bswap   rax
                call    OutCharN
                pop     rdx
                ret

;------------------------------------
; print 4 characters in rax to stdout
;   destroyed : rax
OutChar8B:
                push    rdx
                xor     edx, edx
                mov     dl, 8
                bswap   rax
                call    OutCharN
                pop     rdx
                ret

;------------------------------------
; print n characters in rax to stdout
;   rdx : no. of characters
;   destroyed : rax
OutCharN:
                push    rcx
                push    rsi
                push    rdi
                push    rax                 ; work buffer on stack
                mov     eax, SYS_write
                xor     edi, edi
                inc     edi                 ; 1:to stdout
                mov     rsi, rsp
				push	r10
				push	r11
                syscall
				pop		r11
				pop		r10
                pop     rax
                pop     rdi
                pop     rsi
                pop     rcx
                ret

;------------------------------------
; new line
;   all registers are preserved.
NewLine:
                push    rax
                mov     al, 0AH
                call    OutChar
                pop     rax
                ret

;------------------------------------
; Backspace
;   destroyed : al
BackSpace:
               mov    al, 0x08
               call   OutChar
               mov    al, ' '
               call   OutChar
               mov    al, 0x08
               call   OutChar
               ret

;------------------------------------
; print binary number
;   rax : number
;   ecx : bit
PrintBinary:
                push    rax
                push    rbx
                push    rcx
                push    rdx
                push    rsi
                push    rdi
                mov     rbx, rax
                mov     esi, 64
                or      ecx, ecx        ; ecx > 0 ?
                jle     .exit           ; no ecx<=0
                cmp     ecx, esi
                jg      .toobig
                mov     edx, ecx        ; extract lower bits
                sub     esi, ecx        ; 64
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
                call    OutChar
                loop    .loop
    .exit:
                pop     rdi
                pop     rsi
                pop     rdx
                pop     rcx
                pop     rbx
                pop     rax
                ret

;------------------------------------
; print ecx digit octal number
;   rax : number
;   ecx : digit
PrintOctal:
                push    rax
                push    rcx
                push    rbx
                push    rdx
                or      ecx, ecx
                je      .exit
                mov     edx, ecx            ; 桁数カウンタ
    .push:      mov     rbx, rax
                and     ebx, byte 7
                shr     rax, 3
                push    rbx                 ; 剰余(下位桁)をPUSH
                loop    .push
                mov     ecx, edx            ; 桁数カウンタ
    .pop:       pop     rax                 ; 上位桁から POP
                add     al, '0'             ; 文字コードに変更
                call    OutChar             ; 出力
                loop    .pop
    .exit:
                pop     rdx
                pop     rbx
                pop     rcx
                pop     rax
                ret

;------------------------------------
; print 2 digit hex number (lower 8 bit of rax)
;   rax : number
;   destroyed : edx
PrintHex2:
                mov     dl, 2
                jmp     short PrintHex

;------------------------------------
; print 4 digit hex number (lower 16 bit of rax)
;   rax : number
;   destroyed : edx
PrintHex4:
                mov    dl, 4
                jmp    short PrintHex

;------------------------------------
; print 8 digit hex number (rax)
;   rax : number
;   destroyed : edx
PrintHex8:
                mov    dl, 8
                jmp    short PrintHex

;------------------------------------
; print 16 digit hex number (rax)
;   rax : number
;   destroyed : edx
PrintHex16:
                mov    dl, 16

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
                add     bl, 0x41 - 0x3A     ; A-F
    .skip:
                push    rbx
                loop    .loop1
                mov     cl, dl
    .loop2:     pop     rax
                call    OutChar
                loop    .loop2
                pop     rbx
                pop     rcx
                pop     rax
			   call NewLine
                ret

;------------------------------------
; Output Unsigned Number to stdout
; rax : number
PrintLeftU:
                push    rax
                push    rbx
                push    rcx
                push    rdx
                push    rdi
                push    rbp
                xor     ecx, ecx            ; 桁数カウンタ
                xor     edi, edi            ; 正を仮定
                jmp     short PrintLeft.positive

;------------------------------------
; Output Number to stdout
; rax : number
PrintLeft:
                push    rax
                push    rbx
                push    rcx
                push    rdx
                push    rdi
                push    rbp
                xor     ecx, ecx            ; 桁数カウンタ
                xor     edi, edi            ; 正を仮定
                test    rax, rax
                jns     .positive
                inc     edi                 ; 負に設定
                neg     rax
    .positive:  mov     ebx, 10
    .PL1:       xor     edx, edx            ; 上位桁を 0 に
                div     rbx                 ; 10 で除算
                push    rdx                 ; 剰余(下位桁)をPUSH
                inc     ecx                 ; 桁数更新
                test    rax, rax            ; 終了か?
                jnz     .PL1
    .PL2:       test    edi, edi
                je      .pos
                mov     al, '-'             ; 文字コードに変更
                call    OutChar             ; 出力
    .pos:       pop     rax                 ; 上位桁から POP
                add     al, '0'             ; 文字コードに変更
                call    OutChar             ; 出力
                loop    .pos
                pop     rbp
                pop     rdi
                pop     rdx
                pop     rcx
                pop     rbx
                pop     rax
                ret

;------------------------------------
; Output Number to stdout
; ecx:column
; rax:number
PrintRight:
                push    rax
                push    rbx
                push    rcx
                push    rdx
                push    rdi
                push    rbp
                mov     ebp, ' '
    .pr0:
                push    rsi
                mov     esi, ecx            ; 表示桁数を esi に
                xor     ecx, ecx            ; 桁数カウンタ
                xor     edi, edi            ; 正を仮定
                test    rax, rax
                jns     .positive
                dec     esi
                inc     edi                 ; 負を設定
                neg     rax
    .positive:
                mov     ebx, 10
    .pr1:       xor     edx, edx            ; 上位桁を 0 に
                div     rbx                 ; 10 で除算
                push    rdx                 ; 剰余(下位桁)をPUSH
                inc     ecx                 ; 桁数更新
                test    rax, rax            ; 終了か?
                jnz     .pr1
                sub     esi, ecx            ; esi にスペース数
                jbe     .done               ; 表示桁数を超える
                xchg    esi, ecx            ; ecx にスペース数
    .space:     mov     eax, ebp            ; スペースか 0
                call    OutChar             ; スペース出力
                loop    .space
                xchg    esi, ecx            ; ecx に表示桁数
    .done:
                test    edi, edi
                je      .pos
                mov     al, '-'             ; 文字コードに変更
                call    OutChar             ; 出力
    .pos:       pop     rax                 ; 上位桁から POP
                add     al, '0'             ; 文字コードに変更
                call    OutChar             ; 出力
                loop    .pos
                pop     rsi
                pop     rbp
                pop     rdi
                pop     rdx
                pop     rcx
                pop     rbx
                pop     rax
                ret
                jmp     short PrintLeft.PL2

;------------------------------------
; Output Number to stdout
; ecx:column
; rax:number
PrintRight0:
                push    rax
                push    rbx
                push    rcx
                push    rdx
                push    rdi
                push    rbp
                mov     ebp, '0'
                jmp     short PrintRightU.pr0

;------------------------------------
; Output Unsigned Number to stdout
; ecx:column
; rax:number
PrintRightU:
                push    rax
                push    rbx
                push    rcx
                push    rdx
                push    rdi
                push    rbp
                mov     ebp, ' '
    .pr0:
                push    rsi
                mov     esi, ecx            ; 表示桁数を esi に
                xor     ecx, ecx            ; 桁数カウンタ
                xor     edi, edi            ; 正を仮定
                jmp     short PrintRight.positive


;------------------------------------
; input 1 character from stdin
; rax : get char
InChar:
                push    rcx
                push    rdx
                push    rdi
                push    rsi
                push    rax                 ; work buffer on stack
                mov     eax, SYS_read
                xor     edi, edi            ; 0:from stdin
                mov     rsi, rsp            ; into Input Buffer
                mov     edx, edi
                inc     edx                 ; 1 char
				push	r10
				push	r11
                syscall                     ; call kernel
				pop		r11
				pop		r10
                pop     rax                 ; retrieve a char from buffer
                pop     rsi
                pop     rdi
                pop     rdx
                pop     rcx
                ret

;------------------------------------
; Input Line
; rax : BufferSize
; rbx : Buffer Address
; return       rax : no. of char
;
InputLine0:
               push   rdi
               push   rcx
               push   rdx
               mov    rdx, rax
               mov    rdi, rbx       ; Input Buffer
               xor    ecx, ecx
   .in_char:
               call   InChar
               cmp    al, 0x08       ; BS ?
               jnz    .in_char2
               test   ecx, ecx
               jz     .in_char2
               call   BackSpace      ; backspace
               dec    ecx
               jmp    short .in_char
   .in_char2:
               cmp    al, 0x0A       ; enter ?
               jz     .in_exit

   .in_printable:
               call   OutChar
               mov    [rdi + rcx], al
               inc    ecx
               cmp    ecx, edx       ;
               jae    .in_toolong
               jmp    short .in_char
   .in_toolong:
               dec    ecx
               call   BackSpace
               jmp    short .in_char

   .in_exit:
               mov    dword [rdi + rcx], 0
               inc    ecx
               call   NewLine
               mov    eax, ecx
               pop    rdx
               pop    rcx
               pop    rdi
               ret

%endif
