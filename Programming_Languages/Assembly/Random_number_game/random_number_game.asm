section .data
    msg_ask  db "Guess the number (1-9): ", 0
    msg_win  db 10, "YOU WIN!", 10, 0
    msg_lose db 10, "Wrong! Try again.", 10, 0

section .bss
    guess  resb 2
    secret resb 1        ; We will store the generated number here

section .text
    global _start

_start:
    ; --- 0. GENERATE RANDOM NUMBER ---
    mov rax, 318        ; sys_getrandom (Linux x64)
    mov rdi, secret     ; address to store the random byte
    mov rsi, 1          ; number of bytes to get
    mov rdx, 0          ; flags
    syscall

    ; Convert the random byte to ASCII '1'-'9'
    movzx ax, byte [secret] ; Move the random byte into AX
    mov bl, 9               ; We want a range of 9 (0-8)
    div bl                  ; Divide AX by 9. Remainder is in AH.
    add ah, '1'             ; Convert remainder (0-8) to ASCII ('1'-'9')
    mov [secret], ah        ; Store the ASCII result back in secret

game_loop:
    ; --- 1. ASK FOR GUESS ---
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_ask
    mov rdx, 23
    syscall

    ; --- 2. GET USER INPUT ---
    mov rax, 0
    mov rdi, 0
    mov rsi, guess
    mov rdx, 2
    syscall

    ; --- 3. COMPARE GUESS TO SECRET ---
    mov al, [guess]
    mov bl, [secret]
    cmp al, bl
    je  win_game

    ; --- 4. WRONG GUESS LOGIC ---
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_lose
    mov rdx, 19
    syscall
    jmp game_loop       ; Loop back without generating a new number

win_game:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_win
    mov rdx, 10
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

