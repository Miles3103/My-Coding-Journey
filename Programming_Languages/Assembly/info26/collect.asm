section .data
    dirname db "info26", 0          ; Name of the directory to create
    mode    dw 0777q                ; Permissions: read/write/execute for everyone

section .text
    global _start

_start:
    ; --- 1. CREATE DIRECTORY (sys_mkdir) ---
    mov rax, 83             ; syscall number for mkdir (83)
    mov rdi, dirname        ; address of the directory name
    mov rsi, 0777o          ; permissions (octal 777)
    syscall

    ; --- 2. LIST AND COPY FILES ---
    ; Note: Listing files requires 'sys_getdents64' (73), which returns 
    ; a complex structure of all files in the current folder. 
    ; You would then loop through them, check if they end in '.txt', 
    ; and use 'sys_open', 'sys_read', and 'sys_write' to copy content.

    ; --- 3. EXIT ---
    mov rax, 60             ; syscall for exit
    xor rdi, rdi            ; return code 0
    syscall

