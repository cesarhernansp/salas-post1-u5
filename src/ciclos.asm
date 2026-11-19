; src/ciclos.asm -- Programa 3: medir el tiempo real de un bucle de trabajo fijo
; Ensamble: nasm -f bin ciclos.asm -o ../bin/ciclos.com
;
; Lee la hora con la funcion 2Ch de INT 21h antes y despues de un bucle cuyo
; numero de iteraciones esta fijo en el codigo. Como el codigo no cambia, la
; diferencia entre ambas horas depende solo de cuantas instrucciones por
; segundo emula DOSBox, es decir, del valor "cycles" de dosbox.conf.

org 0x100                       ; formato .COM

; Iteraciones del bucle externo. El interno hace 65535 vueltas. Con cycles=8000
; el bucle completo dura unos segundos, lo bastante para medirlo en centesimas.
ITER_EXT EQU 250

section .text

inicio:
    mov ah, 09h
    mov dx, msg_medir
    int 21h

    ; Leer la hora inicial: CH = horas, CL = minutos, DH = segundos, DL = centesimas
    mov ah, 2Ch
    int 21h
    mov [hora1], ch
    mov [min1], cl
    mov [seg1], dh
    mov [cc1], dl

    ; Bucle de trabajo fijo: su duracion REAL depende del valor "cycles" de
    ; dosbox.conf, no del codigo.
    mov cx, ITER_EXT            ; bucle externo
trabajo_ext:
    push cx
    mov cx, 0FFFFh              ; bucle interno: 65535 iteraciones
trabajo_int:
    inc ax                      ; operacion aritmetica trivial (sin efecto util)
    loop trabajo_int
    pop cx
    loop trabajo_ext

    ; Leer la hora final
    mov ah, 2Ch
    int 21h
    mov [hora2], ch
    mov [min2], cl
    mov [seg2], dh
    mov [cc2], dl

    ; Imprimir la hora inicial
    mov ah, 09h
    mov dx, msg_hini
    int 21h
    mov al, [hora1]
    call print_dec2
    call print_sep
    mov al, [min1]
    call print_dec2
    call print_sep
    mov al, [seg1]
    call print_dec2
    call print_sep
    mov al, [cc1]
    call print_dec2

    ; Imprimir la hora final
    mov ah, 09h
    mov dx, msg_hfin
    int 21h
    mov al, [hora2]
    call print_dec2
    call print_sep
    mov al, [min2]
    call print_dec2
    call print_sep
    mov al, [seg2]
    call print_dec2
    call print_sep
    mov al, [cc2]
    call print_dec2

    mov ah, 09h
    mov dx, msg_fin
    int 21h

    mov ax, 4C00h
    int 21h

; Subrutina: imprime el separador ":"
print_sep:
    mov ah, 09h
    mov dx, sep
    int 21h
    ret

; Subrutina: imprime AL (0-99) como dos digitos decimales ASCII usando AAM
print_dec2:
    aam                         ; AH = AL / 10 (decena), AL = AL % 10 (unidad)
    xchg ah, al                 ; AL = decena, AH = unidad
    push ax                     ; conservar la unidad en AH
    add al, 30h
    mov dl, al
    mov ah, 02h
    int 21h                     ; imprime la decena
    pop ax
    mov al, ah                  ; AL = unidad
    add al, 30h
    mov dl, al
    mov ah, 02h
    int 21h                     ; imprime la unidad
    ret

section .data
    msg_medir db "Midiendo bucle de trabajo fijo...", 0Dh, 0Ah, "$"
    msg_hini  db "Hora inicial (hh:mm:ss:cc): $"
    msg_hfin  db 0Dh, 0Ah, "Hora final   (hh:mm:ss:cc): $"
    msg_fin   db 0Dh, 0Ah, "Medicion completa. Compare el campo cc (centesimas).", 0Dh, 0Ah, "$"
    sep       db ":$"

section .bss
    ; Marcas de tiempo leidas con la funcion 2Ch
    hora1 resb 1
    min1  resb 1
    seg1  resb 1
    cc1   resb 1
    hora2 resb 1
    min2  resb 1
    seg2  resb 1
    cc2   resb 1
