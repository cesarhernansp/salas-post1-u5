; src/entrada.asm -- Programa 2: leer un caracter del teclado y mostrar su eco
; Ensamble: nasm -f bin entrada.asm -o ../bin/entrada.com
;
; Lee un caracter con la funcion 07h (sin eco automatico), lo muestra con la
; funcion 02h y despues imprime su codigo ASCII en hexadecimal (dos digitos).

org 0x100                       ; formato .COM

section .text

inicio:
    ; Mostrar el prompt con la funcion 09h
    mov ah, 09h
    mov dx, prompt
    int 21h

    ; Leer un caracter del teclado (sin eco automatico)
    mov ah, 07h                 ; funcion 07h: leer caracter sin eco
    int 21h                     ; AL = codigo ASCII del caracter leido
    mov bl, al                  ; guardar el caracter en BL (AL se reutiliza abajo)

    ; Mostrar el caracter leido
    mov ah, 09h
    mov dx, msg_ok
    int 21h
    mov ah, 02h                 ; funcion 02h: mostrar el caracter contenido en DL
    mov dl, bl
    int 21h

    ; Mostrar el codigo ASCII en hexadecimal
    mov ah, 09h
    mov dx, msg_cod
    int 21h

    ; Separar los nibbles alto y bajo del codigo ASCII
    mov al, bl
    shr al, 4                   ; nibble alto -> AL
    call print_hex_nibble
    mov al, bl
    and al, 0Fh                 ; nibble bajo -> AL
    call print_hex_nibble

    ; Nueva linea y terminar
    mov ah, 09h
    mov dx, nl
    int 21h
    mov ax, 4C00h
    int 21h

; Subrutina: imprime el nibble contenido en AL (0-15) como digito hexadecimal
print_hex_nibble:
    cmp al, 9
    jle .digito                 ; 0-9: solo se suma 30h
    add al, 7                   ; A-F: desplazamiento extra para llegar a 41h
.digito:
    add al, 30h                 ; convertir a ASCII (0 = 30h, A = 41h)
    mov ah, 02h
    mov dl, al
    int 21h
    ret

section .data
    prompt  db "Ingrese una letra (se mostrara su codigo ASCII): $"
    msg_ok  db 0Dh, 0Ah, "Caracter recibido: $"
    msg_cod db 0Dh, 0Ah, "Codigo ASCII (hex): $"
    nl      db 0Dh, 0Ah, "$"
