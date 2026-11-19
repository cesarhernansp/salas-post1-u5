; src/saludo.asm -- Programa 1: salida de texto en DOS
; Ensamble: nasm -f bin saludo.asm -o ../bin/saludo.com
;
; Programa en formato .COM: un solo segmento de 64 KB donde CS = DS = ES = SS.
; DOS carga el archivo en el desplazamiento 0100h del segmento.

org 0x100                       ; formato .COM: origen en CS:0100h

; En formato bin las secciones se emiten en el orden en que aparecen. El codigo
; va primero para que el punto de entrada (0100h) sea la primera instruccion.
section .text

inicio:
    ; Mostrar el mensaje con la funcion 09h de INT 21h
    mov ah, 09h                 ; funcion: imprimir cadena terminada en "$"
    mov dx, mensaje             ; DX = direccion de inicio de la cadena
    int 21h                     ; llamar al sistema operativo DOS

    ; Terminar el programa correctamente
    mov ax, 4C00h               ; funcion 4Ch: terminar; AL = 00h (codigo de salida)
    int 21h

section .data
    ; Las tres lineas forman una sola cadena; 0Dh,0Ah (CR+LF) separan las lineas
    ; y el "$" final indica a la funcion 09h donde termina el texto.
    mensaje db "Laboratorio 5 - DOSBox y Ensamblador", 0Dh, 0Ah
    nombre  db "Estudiante: Cesar Hernan Salas Penaranda", 0Dh, 0Ah
            db "Unidad 5 - Arquitectura de Computadores", 0Dh, 0Ah, "$"
