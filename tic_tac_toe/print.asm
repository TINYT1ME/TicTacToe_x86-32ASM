; x86-32bit linux assembly

;--------------------;
; print
; By: Daniel and Peter
; 2023-01
;--------------------;

;--------------------;
; Explanation:
; The code below is a
;   function that
;   prints to console
;
; The buffer is taken
;   from stack, as is
;   the buffer size
;--------------------;

;--------------------;
; Buffer at ebp+8
; Buffer len at ebp+12
;--------------------;

; Start to program at print label
global print

print:
    push    ebp            
    mov     ebp, esp        

    mov     eax, 4                          ; Input syscall
    mov     ebx, 1                          ; STDOUT
    mov     ecx, [ebp+8]
    mov     edx, [ebp+12]
    int     0x80                            ; Calling kernel, 32 bit version of syscall

    ; Return
    mov     esp, ebp        
    pop     ebp             
    ret
     
