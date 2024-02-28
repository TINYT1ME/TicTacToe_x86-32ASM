; x86-32bit linux assembly

;----------------------;
; main
; By: Daniel and Peter
; 2023-01
;----------------------;

;----------------------;
; Explanation:
; The code below brings
;   all files together
;   
; It also has the logic
;   of the game
;   including the
;   algorithm to find
;   winner
;----------------------;

; Start to program at _start label
global _start

; For linker
extern modify_board
extern input
extern print
extern print_board

section .bss
    ; User input variable
    stdin           resb 70 
    stdin_len    equ $-stdin

section .data
    ; Clear screen ANSI code
    clear_screen                db `\033[2J\033[H`
    clear_screen_len            equ $-clear_screen

    ; Introduction message with explanation
    ; The 7 newlines at the end are because
    ;   when printing board it goes up lines
    ;   to print
    explanation_message         db `How to play:\n\tO will always start\n\tEnter row and then column\n\t(seperated by a space)\n\tEx. 1 1\n\n\tWhen input is invalid, prompt will turn red and same user will be reprompted to enter spot\n\tInput q to exit\n\n\n\n\n\n\n`  
    explananation_message_len  equ $-explanation_message

    ; Prompts
    o_prompt                db "O's turn: "
    o_prompt_len         equ $-o_prompt
    x_prompt                db "X's turn: "
    x_prompt_len         equ $-x_prompt
    invalid_input           db `\x1b[6;30;41m`
    invalid_input_len       equ $-invalid_input
    normal_input            db `\x1b[0m`
    normal_input_len        equ $-normal_input
    
    ; Winner messages
    o_win_message           db `\nO WINS!!!!\n\n`
    o_win_message_len    equ $-o_win_message
    x_win_message           db `\nX WINS!!!!\n\n`
    x_win_message_len    equ $-x_win_message

    ; Tie message
    tie_message             db `\nCats game\n\n`
    tie_message_len      equ $-tie_message

    ; Current player
    player_symbol           db "O"
    player_symbol_len    equ $-player_symbol

    ; Board
    row1                    db "    "
    row2                    db "    "
    row3                    db "    "
    col_diag_tmp            db "    "

    ; Counter for amount of inputs
    counter                 db 0 

section .text
_start:
    ; Clear screen at beginning
    push    clear_screen_len
    push    clear_screen
    call    print
    pop     eax
    pop     eax

    push    explananation_message_len
    push    explanation_message
    call    print
    pop     eax
    pop     eax

loop:
    ; Print Board to console
    push    row3
    push    row2
    push    row1
    call    print_board
    pop     eax
    pop     eax
    pop     eax

    cmp     [player_symbol], byte "X"
    je      x_input

o_input:
    ; Printing o input prompt
    push    o_prompt_len
    push    o_prompt
    call    print
    pop     eax
    pop     eax
    jmp     get_input

x_input:
    ; Printing x input prompt
    push    x_prompt_len
    push    x_prompt
    call    print
    pop     eax
    pop     eax

get_input:
    ; Calling input function
    push    stdin_len
    push    stdin
    call    input
    pop     eax
    pop     eax

    cmp     [stdin], byte "q"
    je      exit_success
    jmp     call_modify_board

call_modify_board:
    ; Call modify_board with player symbol
    ;   and player input
    push    row3
    push    row2
    push    row1
    push    player_symbol
    push    stdin
    call    modify_board
    pop     eax
    pop     eax
    pop     eax
    pop     eax
    pop     eax

    ; If there was an error, make player enter input again
    cmp     dl, 0x00
    jne     loop

change_turn:
    ; Check whoes turn it is
    mov     al, byte [counter]
    add     eax, 1
    mov     byte [counter], al
    cmp     [player_symbol], byte "X"
    je      change_turn_to_o

change_turn_to_x:
    ; Change symbol to X
    mov     [player_symbol], byte "X"
    jmp     check_winner

change_turn_to_o:
    ; Change symbol to X
    mov     [player_symbol], byte "O"

check_winner:
    ; If clock is < 5 than loop
    ;   no point of checking winner
    ;   as 5 is minimum inputs required
    ;   for a winner to be had
    cmp     al, 5
    jl      loop

    ; Comparing each row for all x's
    ;   to check if X has a straight row
    ;   win
    cmp     dword [row1], dword "XXX "
    je      x_win
    cmp     dword [row2], dword "XXX "
    je      x_win
    cmp     dword [row3], dword "XXX "
    je      x_win

    ; Comparing each row for all o's
    ;   to check if Y has a straight row
    ;   win
    cmp     dword [row1], dword "OOO "
    je      o_win
    cmp     dword [row2], dword "OOO "
    je      o_win
    cmp     dword [row3], dword "OOO "
    je      o_win

    ; Checking first column for win
    ; |
    ; |
    ; |
    mov     al, byte [row1]
    mov     [col_diag_tmp], al
    mov     al, byte [row2]
    mov     [col_diag_tmp+1], al
    mov     al, byte [row3]
    mov     [col_diag_tmp+2], al
    cmp     dword [col_diag_tmp], dword "XXX "
    je      x_win
    cmp     dword [col_diag_tmp], dword "OOO "
    je      o_win

    ; Checking middle column for win
    ;  |
    ;  |
    ;  |
    mov     al, byte [row1+1]
    mov     [col_diag_tmp], al
    mov     al, byte [row2+1]
    mov     [col_diag_tmp+1], al
    mov     al, byte [row3+1]
    mov     [col_diag_tmp+2], al
    cmp     dword [col_diag_tmp], dword "XXX "
    je      x_win
    cmp     dword [col_diag_tmp], dword "OOO "
    je      o_win

    ; Checking last column for win
    ;   |
    ;   |
    ;   |
    mov     al, byte [row1+2]
    mov     [col_diag_tmp], al
    mov     al, byte [row2+2]
    mov     [col_diag_tmp+1], al
    mov     al, byte [row3+2]
    mov     [col_diag_tmp+2], al
    cmp     dword [col_diag_tmp], dword "XXX "
    je      x_win
    cmp     dword [col_diag_tmp], dword "OOO "
    je      o_win

    ; Checking diagonal, left to right
    ; \
    ;  \
    ;   \
    mov     al, byte [row1]
    mov     [col_diag_tmp], al
    mov     al, byte [row2+1]
    mov     [col_diag_tmp+1], al
    mov     al, byte [row3+2]
    mov     [col_diag_tmp+2], al
    cmp     dword [col_diag_tmp], dword "XXX "
    je      x_win
    cmp     dword [col_diag_tmp], dword "OOO "
    je      o_win

    ; Checking diagonal, left to right
    ;   /
    ;  /
    ; /
    mov     al, byte [row1+2]
    mov     [col_diag_tmp], al
    mov     al, byte [row2+1]
    mov     [col_diag_tmp+1], al
    mov     al, byte [row3]
    mov     [col_diag_tmp+2], al
    cmp     dword [col_diag_tmp], dword "XXX "
    je      x_win
    cmp     dword [col_diag_tmp], dword "OOO "
    je      o_win

    ; Checking if tie
    cmp     [row1], byte " "
    je      loop
    cmp     [row1+1], byte " "
    je      loop
    cmp     [row1+2], byte " "
    je      loop
    cmp     [row2], byte " "
    je      loop
    cmp     [row2+1], byte " "
    je      loop
    cmp     [row2+2], byte " "
    je      loop
    cmp     [row3], byte " "
    je      loop
    cmp     [row3+1], byte " "
    je      loop
    cmp     [row3+2], byte " "
    je      loop

tie:
    ; Priting board and tie message
    push    row3
    push    row2
    push    row1
    call    print_board
    pop     eax
    pop     eax
    pop     eax
    push    tie_message_len
    push    tie_message
    call    print
    pop     eax
    pop     eax
    call    exit_success

x_win:
    ; Printing board and x win message
    push    row3
    push    row2
    push    row1
    call    print_board
    pop     eax
    pop     eax
    pop     eax
    push    x_win_message_len
    push    x_win_message
    call    print
    pop     eax
    pop     eax
    call    exit_success

o_win:
    ; Printing board and o win message
    push    row3
    push    row2
    push    row1
    call    print_board
    pop     eax
    pop     eax
    pop     eax
    push    o_win_message_len
    push    o_win_message
    call    print
    pop     eax
    pop     eax
    call    exit_success

exit_success:
    ; Calling exit with 0 as return value
    ;   0 = success
    mov     eax, 1
    mov     ebx, 0
    int     0x80
