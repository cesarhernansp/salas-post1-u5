# salas-post1-u5

## Descripción

Laboratorio de la Unidad 5 de Arquitectura de Computadores (post-contenido): emulación con DOSBox (Parte 1) y virtualización con VirtualBox (Parte 2) en un único repositorio.

- **Estudiante:** Cesar Hernan Salas Peñaranda (cuenta de GitHub `cesarhernansp`)
- **Parte 1:** entorno DOSBox con NASM, tres programas en ensamblador (`saludo.com`, `entrada.com`, `ciclos.com`), verificación con DEBUG y comparación del parámetro `cycles`.
- **Parte 2:** máquina virtual Alpine Linux en VirtualBox, modos de red, snapshots, reasignación de recursos, comparación de discos y exportación OVA.

## Entorno de trabajo (Parte 1)

| Componente | Versión / detalle |
|---|---|
| Sistema anfitrión | Windows 11 Home, 16 GB de RAM |
| Emulador | DOSBox 0.74-3 |
| Depurador | `DEBUG.EXE` incluido en DOSBox-X 2026.10.01 (`Z:\DOS\DEBUG.EXE`), porque DOSBox 0.74-3 no trae DEBUG |
| Ensamblador | NASM 3.02 para DOS (`nasm.exe`, requiere un host DPMI: `cwsdpmi.exe`) |
| Editor | VS Code / editor de texto plano; archivos `.asm` en ASCII sin BOM |
| Control de versiones | Git en el anfitrión |

`nasm.exe` y `cwsdpmi.exe` se copian a la raíz del proyecto para que DOSBox los vea como `C:\`, pero no se versionan en el repositorio (son binarios de terceros).
