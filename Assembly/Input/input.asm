section .data
    prompt db "Enter your name: "
    prompt_len equ $ - prompt
    greet  db "Hello, "
    greet_len equ $ - greet

section .bss
    buffer resb 64        ; Reserve 64 bytes for the input name

section .text
    global _start

_start:
    ; 1. PRINT THE PROMPT ("Enter your name: ")
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, prompt     ; address of prompt
    mov rdx, prompt_len ; length
    syscall

    ; 2. GET INPUT (Read from keyboard)
    mov rax, 0          ; sys_read (Function #0)
    mov rdi, 0          ; stdin (keyboard)
    mov rsi, buffer     ; where to store the typed text
    mov rdx, 64         ; maximum bytes to read
    syscall
    
    ; Save the number of bytes actually read (including the Enter key)
    push rax            

    ; 3. PRINT THE GREETING ("Hello, ")
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, greet      ; address of greeting
    mov rdx, greet_len  ; length
    syscall

    ; 4. PRINT THE NAME (What the user typed)
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, buffer     ; address of our buffer
    pop rdx             ; retrieve the number of bytes read earlier
    syscall

    ; 5. EXIT
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; exit code 0
    syscall

