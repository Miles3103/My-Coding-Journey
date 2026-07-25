section .data
    dirname  db "info26", 0
    src_file db "me.txt", 0
    dst_file db "info26/me.txt", 0   ; The path inside the new folder
    
    msg_ok   db "File copied to info26/ successfully!", 10
    msg_ok_len equ $ - msg_ok

section .bss
    buffer   resb 1024               ; 1KB buffer to hold file content

section .text
    global _start

_start:
    ; --- 1. CREATE DIRECTORY ---
    mov rax, 83         ; sys_mkdir
    mov rdi, dirname
    mov rsi, 0o777
    syscall             ; (If it exists, rax will be negative, we can ignore for now)

    ; --- 2. OPEN SOURCE FILE (me.txt) ---
    mov rax, 2          ; sys_open
    mov rdi, src_file
    mov rsi, 0          ; O_RDONLY (Read only)
    syscall
    mov r12, rax        ; Save source file descriptor in R12

    ; --- 3. CREATE/OPEN DESTINATION (info26/me.txt) ---
    mov rax, 2          ; sys_open
    mov rdi, dst_file
    mov rsi, 65         ; O_WRONLY | O_CREAT (Write and create if not exists)
    mov rdx, 0o644      ; Permissions for the new file
    syscall
    mov r13, rax        ; Save destination file descriptor in R13

    ; --- 4. READ FROM SOURCE ---
    mov rax, 0          ; sys_read
    mov rdi, r12        ; from me.txt
    mov rsi, buffer
    mov rdx, 1024       ; read up to 1024 bytes
    syscall
    mov r14, rax        ; Save how many bytes were actually read in R14

    ; --- 5. WRITE TO DESTINATION ---
    mov rax, 1          ; sys_write
    mov rdi, r13        ; to info26/me.txt
    mov rsi, buffer
    mov rdx, r14        ; write exactly what we read
    syscall

    ; --- 6. CLOSE FILES ---
    mov rax, 3          ; sys_close
    mov rdi, r12
    syscall
    mov rax, 3
    mov rdi, r13
    syscall

    ; --- 7. SUCCESS MESSAGE & EXIT ---
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_ok
    mov rdx, msg_ok_len
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

