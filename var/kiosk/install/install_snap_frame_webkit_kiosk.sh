#!/usr/bin/env bash

. /var/kiosk/kiosk_config

. $FILE_KIOSK_LIB

get_kiosk_installed

if [ "$kiosk_installed" = "FALSE" ]; then

    SERVICENAME_BOOT=kiosk_boot
    SERVICENAME_SHUTDOWN=kiosk_shutdown

    # Actualizar sistema e instalar sistema grafico
    apt update
    apt upgrade -y

    apt install openbox xinit xterm x11-xserver-utils yad mlocate plymouth-themes git -y

    #apt install openbox xinit xterm x11-xserver-utils yad mlocate plymouth-themes -y

    systemctl enable $SERVICENAME_BOOT
    systemctl enable $SERVICENAME_SHUTDOWN

    # Instalar wpe-webkit-mir-kiosk en ubuntu-frame
    snap install ubuntu-frame
    snap install wpe-webkit-mir-kiosk
    snap set ubuntu-frame daemon=true
    snap connect wpe-webkit-mir-kiosk:wayland
    snap set ubuntu-frame daemon=false

    set_kiosk_installed

    reboot
    
fi

