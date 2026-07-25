org 100h                ; نقطة البداية لملفات .COM في DOS

section .data
    filename db "INFO26.TXT", 0       ; اسم الملف
    content  db "Hello from Assembly!" ; النص المراد كتابته
    content_len equ $ - content        ; حساب طول النص تلقائياً

section .text
start:
    ; --- 1. إنشاء الملف (Create File) ---
    mov ah, 3Ch         ; وظيفة الإنشاء
    mov cx, 0           ; ملف عادي (Normal)
    mov dx, filename    ; اسم الملف
    int 21h             ; نداء DOS
    jc error            ; قفز في حال وجود خطأ (Carry Flag)
    
    mov bx, ax          ; حفظ رقم الملف (File Handle) في BX للاستخدام اللاحق

    ; --- 2. الكتابة في الملف (Write to File) ---
    mov ah, 40h         ; وظيفة الكتابة
    ; سجل BX يحتوي بالفعل على رقم الملف من الخطوة السابقة
    mov cx, content_len ; عدد البايتات (طول النص)
    mov dx, content     ; عنوان النص
    int 21h             ; نداء DOS
    jc error

    ; --- 3. إغلاق الملف (Close File) ---
    mov ah, 3Eh         ; وظيفة الإغلاق
    ; سجل BX لا يزال يحتوي على رقم الملف
    int 21h

    ; --- 4. الخروج بنجاح ---
    mov ax, 4C00h
    int 21h

error:
    ; الخروج مع رمز خطأ إذا فشلت أي عملية
    mov ax, 4C01h
    int 21h

