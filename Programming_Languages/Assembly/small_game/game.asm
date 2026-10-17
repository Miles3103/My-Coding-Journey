section .data
    msg_ask  db "Guess the number (1-9): ", 0
    msg_win  db 10, "YOU WIN!", 10, 0
    msg_lose db 10, "Wrong! Try again.", 10, 0
    secret   db '2'                   ; The secret number

section .bss
    guess resb 2                      ; Space for the user's guess

section .text
    global _start

_start:
    ; --- 1. ASK FOR GUESS ---
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, msg_ask
    mov rdx, 23         ; length of msg_ask
    syscall

    ; --- 2. GET USER INPUT ---
    mov rax, 0          ; sys_read
    mov rdi, 0          ; stdin
    mov rsi, guess
    mov rdx, 2
    syscall

    ; --- 3. COMPARE GUESS TO SECRET ---
    mov al, [guess]     ; Load user's character into AL register
    mov bl, [secret]    ; Load secret character into BL register
    cmp al, bl          ; Compare them
    je  win_game        ; If equal (JE), jump to win_game

    ; --- 4. WRONG GUESS LOGIC ---
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_lose
    mov rdx, 19
    syscall
    jmp _start          ; Jump back to the start to try again

win_game:
    ; --- 5. WIN LOGIC ---
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_win
    mov rdx, 10
    syscall

    ; --- 6. EXIT ---
    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall

