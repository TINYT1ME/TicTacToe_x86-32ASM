; x86-32bit linux assembly

;---------------------;
; modify_board
; By: Daniel and Peter
; 2023-01
;---------------------;

;---------------------;
; Explanation:
; The code below
;   modifies the game
;   board
;
; If any error occurs
;   it will set dl to 1
;   which is telling print_board.asm
;   that it returned with an error
;
; The program works by
;   checking if the
;   board sport it " "
;   if it is it will
;   change it to the
;   current user symbol
;   If it isnt, it goes
;   to the change_colour
;   label
;---------------------;

;---------------------;
; Address of things in
;   stack:
; +8    - Input buffer
; +12   - Player symbol
; +16   - First row
; +20   - Second row
; +24   - Third row
;---------------------;

; Start to program at modify_board label
global modify_board

; For linker
extern print

section .data
    ; ANSI codes for changing colour and reseting colour
    red_text            db `\033[1A\33[2K\r\x1b[6;30;41m\033[1;97m`
    red_text_len        equ $-red_text
    normal_text         db `\033[1A\33[2K\r\x1b[0m`
    normal_text_len     equ $-normal_text

    ; Clear line(ANSI code)
    clear_line          db `\033[1A\33[2K\r`
    clear_line_len      equ $-clear_line

section .text
modify_board:
    push    ebp            
    mov     ebp, esp

    mov     eax, [ebp+8]                    ; STDIN(what the user inputed)

    ; Current player
    mov     ebx, [ebp+12]
    mov     ebx, [ebx]

    ; Making sure space between row and coloum(input)
    cmp     byte [eax+1], byte " "
    jne     change_colour 

    ; Making sure input length is valid
    cmp     byte [eax+3], byte `\n`
    jne     change_colour

    ; Checks which row user chose
    ; If not between 1-3, will jump
    ;   to change_colour
    cmp     byte [eax], byte "1"
    jne     check_row2
    mov     ecx, [ebp+16]
    jmp     check_col

check_row2:
    cmp     byte [eax], byte "2"
    jne     check_row3
    mov     ecx, [ebp+20]
    jmp     check_col

check_row3:
    cmp     byte [eax], byte "3"
    jne     change_colour
    mov     ecx, [ebp+24]
    jmp     check_col


; Checks which column user chose
; If not between 1-3, will jump
;   to change_colour
check_col:
    cmp     byte [eax+2], byte "1"
    jne     check_col2
    cmp     byte [ecx], byte " "
    jne     change_colour
    mov     [ecx], bl
    jmp     reset_colour

check_col2:
    cmp     byte [eax+2], byte "2"
    jne     check_col3
    cmp     byte [ecx+1], byte " "
    jne     change_colour
    mov     [ecx+1], bl
    jmp     reset_colour

check_col3:
    cmp     byte [eax+2], byte "3"
    jne     change_colour
    cmp     byte [ecx+2], byte " "
    jne     change_colour
    mov     [ecx+2], bl
    jmp     reset_colour


; Change colour to red bg and white fg
;   when error occurs
change_colour:
    push    red_text_len
    push    red_text
    call    print
    pop     eax
    pop     eax
    jmp     return_error

; Reset colour when input valid
reset_colour:
    push    normal_text_len
    push    normal_text
    call    print
    pop     eax
    pop     eax
    jmp     return_success


; Rest of code is setting return value
;   and ret
return_error:
    mov     dl, 1
    jmp     return

return_success:
    mov     dl, 0
    jmp     return

return:
    ; return with return value stored in dl
    mov     esp, ebp        
    pop     ebp             
    ret 
