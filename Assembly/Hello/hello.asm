section .data
    text db "Hello, Linux Assembly!", 10

section .text
    global _start

_start:
    mov rax, 1        ; sys_write system call
    mov rdi, 1        ; file descriptor (1 = stdout)
    mov rsi, text     ; address of string
    mov rdx, 23       ; length of string
    syscall           ; execute call

    mov rax, 60       ; sys_exit system call
    mov rdi, 0        ; exit code 0
    syscall           ; execute call
