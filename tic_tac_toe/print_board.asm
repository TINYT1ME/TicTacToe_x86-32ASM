; x86-32bit linux assembly

;------------------------;
; print_board
; By: Daniel and Peter
; 2023-01
;------------------------;

;------------------------;
; Explanation:
; The code below prints
;   the board to console
;
; It reads each row of
;   board from the stack
;
; Each row is accesed by
;   edp+(4+(4*n))
;   n being the number
;   of row
;
;   ebp being the stack
;   pointer
;------------------------;

; Start to program at print_board label
global print_board

; For linker
extern print

section .data
    ; All constants
    column_separator    db "|"
    row_separator       db `-------\n`
    row_separator_len   equ $-row_separator
    new_line            db `\n`
    new_line_len        equ $-new_line
    move_up             db `\x1b[7A`
    move_up_len         equ $-move_up
    clear_line          db `\x1b[1A\n\n`
    clear_line_len      equ $-clear_line

section .text
print_board:
    ; Clear current line
    push    clear_line_len
    push    clear_line
    call    print
    pop edx
    pop edx

    ; Move up cursor
    push    move_up_len
    push    move_up
    call    print
    pop edx
    pop edx

    ; Newline
    push    new_line_len
    push    new_line
    call    print
    pop edx
    pop edx

    push    ebp            
    mov     ebp, esp   

    ; First row
    mov     eax, [ebp+8]
    push    eax
    call    display_row
    pop     eax

    ; Show row split
    push    row_separator_len
    push    row_separator
    call    print
    pop     edx
    pop     edx

    ; Second row
    mov     eax, [ebp+12]
    push    eax
    call    display_row
    pop     eax

    ; Show row split
    push    row_separator_len
    push    row_separator
    call    print
    pop     edx
    pop     edx

    ; Third row
    mov     eax, [ebp+16]
    push    eax
    call    display_row
    pop     eax
    
    ; Return
    mov     esp, ebp        
    pop     ebp             
    ret 

display_row:
    ; Display row
    push    ebp            
    mov     ebp, esp

    push    byte 1

    ; This prints the pipe symbol for the board
    push    column_separator
    call    print
    pop     edx

    ; Print 1st value in row
    mov     eax, [ebp+8]
    push    eax
    call    print
    pop     edx

    push    column_separator
    call    print
    pop     edx

    ; Print 2nd value in row
    mov     eax, [ebp+8]
    add     eax, 1
    push    eax
    call    print
    pop     edx

    push    column_separator
    call    print
    pop     edx

    ; Print 3rd value in row
    mov     eax, [ebp+8]
    add     eax, 2
    push    eax
    call    print
    pop     edx

    push    column_separator
    call    print
    pop     edx

    ; Newline
    push    new_line
    call    print
    pop     edx
    pop     edx

    
    ; Return
    mov     esp, ebp        
    pop     ebp             
    ret
    
