#!/usr/bin/env bash
# VBoxManage_commands.sh -- Parte 2 (VirtualBox): comandos ejecutados en el laboratorio
#
# Registro de los comandos usados, en el orden del laboratorio. Se ejecutaron
# desde la consola de Windows con VBoxManage 7.2.22; se escriben aqui con la
# sintaxis de bash (Git Bash). Los pasos que escriben dentro de la VM se indican
# como comentarios "# [VM]".
#
# Los archivos .ova y el disco fijo .vdi NO se versionan por su tamano.

VBM="/c/Program Files/Oracle/VirtualBox/VBoxManage.exe"
BASE='C:\Users\Cesar\VMs-lab5'                 # carpeta de la VM, fuera del repositorio
ISO='C:\Users\Cesar\Downloads\POST UNIDAD 5 ARQUITECTURA\alpine-standard-3.24.4-x86_64.iso'
VM="Lab5-Alpine"

# ---------------------------------------------------------------------------
# Paso 1: creacion de la VM (1 CPU, 1024 MB, NAT, disco VDI dinamico de 10 GB)
# ---------------------------------------------------------------------------
"$VBM" createvm --name "$VM" --ostype "Linux_64" --basefolder "$BASE" --register
"$VBM" modifyvm "$VM" --memory 1024 --vram 16 --cpus 1 --nic1 nat \
    --graphicscontroller vmsvga --boot1 dvd --boot2 disk --boot3 none --boot4 none
"$VBM" createmedium disk --filename "$BASE\\$VM\\$VM.vdi" --size 10240 --format VDI
"$VBM" storagectl "$VM" --name "SATA" --add sata
"$VBM" storageattach "$VM" --storagectl "SATA" --port 0 --device 0 \
    --type hdd --medium "$BASE\\$VM\\$VM.vdi"
"$VBM" storagectl "$VM" --name "IDE" --add ide
"$VBM" storageattach "$VM" --storagectl "IDE" --port 0 --device 0 \
    --type dvddrive --medium "$ISO"

# ---------------------------------------------------------------------------
# Paso 2: instalacion de Alpine Linux (sin interfaz grafica del Manager)
# ---------------------------------------------------------------------------
"$VBM" startvm "$VM" --type headless
# El teclado de la VM se controla con:
#   VBoxManage controlvm "$VM" keyboardputstring "<texto>"
#   VBoxManage controlvm "$VM" keyboardputscancode 1c 9c        # Enter
# y la pantalla se captura con:
#   VBoxManage controlvm "$VM" screenshotpng <archivo.png>
# [VM] root  ->  setup-alpine  (us/us, lab5-vm, eth0 dhcp, America/Bogota, chrony,
#      mirror 1, sin usuario, openssh, disco sda en modo sys)
# [VM] poweroff
"$VBM" storageattach "$VM" --storagectl "IDE" --port 0 --device 0 --medium emptydrive
"$VBM" startvm "$VM" --type headless
# [VM] ip addr show eth0 ; ping -c 3 8.8.8.8

# ---------------------------------------------------------------------------
# Paso 3: modos de red (se apaga la VM antes de cada cambio)
# ---------------------------------------------------------------------------
"$VBM" controlvm "$VM" acpipowerbutton            # apagado ordenado del huesped
# Modo 1: NAT (configuracion inicial): IP 10.0.2.15, puerta de enlace 10.0.2.2
# Modo 2: Host-Only (adaptador existente, 192.168.56.1)
"$VBM" list hostonlyifs
"$VBM" modifyvm "$VM" --nic1 hostonly --hostonlyadapter1 "VirtualBox Host-Only Ethernet Adapter"
# Modo 3: Bridge sobre el adaptador Wi-Fi del anfitrion
"$VBM" list bridgedifs
"$VBM" modifyvm "$VM" --nic1 bridged --bridgeadapter1 "Intel(R) Wi-Fi 6E AX211 160MHz"
# Se vuelve a NAT, el modo recomendado para esta VM
"$VBM" modifyvm "$VM" --nic1 nat

# ---------------------------------------------------------------------------
# Paso 4: snapshots (con la VM encendida; sin --live, porque con el hipervisor de
# Windows activo el snapshot en vivo no converge y la VM quedo bloqueada)
# ---------------------------------------------------------------------------
"$VBM" snapshot "$VM" take "snap_base" \
    --description "Alpine Linux 3.24.4 recien instalado, sin modificaciones"
# [VM] apk update ; apk add curl wget nano htop
"$VBM" snapshot "$VM" take "snap_con_herramientas" \
    --description "Alpine con curl, wget, nano y htop instalados"
"$VBM" snapshot "$VM" list
"$VBM" controlvm "$VM" poweroff
"$VBM" snapshot "$VM" restore "snap_base"
"$VBM" startvm "$VM" --type headless
# [VM] apk info -e curl ; which curl     (sin salida: curl ya no esta instalado)
