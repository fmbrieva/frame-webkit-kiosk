#!/usr/bin/env bash

############################################################################################
#                                                                                          #
# install_frame_webkit_kiosk.sh: Script para instalar frame-webkit-kiosk                   #
#                                                                                          #
#------------------------------------------------------------------------------------------#
#                                                                                          #
# Script para instalar quioscos Webkit mediante ubuntu-frame en Ubuntu Server              # 
#                                                                                          #
#  - WebKit port optimized for embedded devices (https://wpewebkit.org/)                   #
#  - wpe-webkit-mir-kiosk snap (https://gitlab.com/glancr/wpe-webkit-snap)                 #
#  - Ubuntu Server: https://ubuntu.com/download/server                                     #
#                                                                                          #
#                                                                                          #
#------------------------------------------------------------------------------------------#
#                                                                                          #
# Autor         : Felipe Muñoz Brieva - digitaliza.aapp@gmail.com                          #
#                                                                                          #
#------------------------------------------------------------------------------------------#
#                                                                                          #
# Modificaciones:                                                                          #
#                                                                                          #
# 20/05/2022      Versión inicial                                                          #
#   Felipe                                                                                 #
#                                                                                          #
############################################################################################

KIOSK_VERSION="00.36"
VAR_KIOSK="/root/frame-webkit-kiosk/var/kiosk"

SCRIPT_BOOT=$VAR_KIOSK"/service/kiosk_boot.sh"
SCRIPT_SHUTDOWN=$VAR_KIOSK"/service/kiosk_shutdown.sh"
SCRIPT_INSTALL_SNAP=$VAR_KIOSK"/install/install_snap_frame_webkit_kiosk.sh"

SERVICENAME_BOOT=kiosk_boot
SERVICENAME_SHUTDOWN=kiosk_shutdown

RC_LOCAL="/etc/rc.local"
LSB_KIOSK="/etc/lsb-release-frame-webkit-kiosk"
CERTIFICADOS="/Certificados"

# Actualizar sistema e instalar aplicaciones snap al ejecutar el script
instalar_snap="TRUE"

while getopts ":n" option; do
    case $option in
        n) # No instalar aplicaciones snap 
           instalar_snap="FALSE" 
           ;;
    esac
done

# Copiar scripts para el quiosco
cp -ax $VAR_KIOSK /var/.

. /var/kiosk/kiosk_config

. $FILE_KIOSK_LIB

set_kiosk_uninstalled

chmod +x $SCRIPT_BOOT
chmod +x $SCRIPT_SHUTDOWN

truncate -s 0 $FILE_KIOSK_URL

# Crear carpeta para cargar certificados *.crt
mkdir $CERTIFICADOS 
chmod 777 $CERTIFICADOS 

# Version frame-webkit-kiosk 
cat > $LSB_KIOSK <<EOF
KIOSK_ID=frame-webkit-kiosk
KIOSK_RELEASE=$KIOSK_VERSION
KIOSK_DESCRIPTION="Quiosco generico: ubuntu-frame con wpe-webkit-mir-kiosk"
EOF


# Ajustar inicio del sistema (/etc/rc.local)
cat > $RC_LOCAL <<EOF
#!/usr/bin/env bash

. /var/kiosk/kiosk_config

. \$FILE_KIOSK_LIB

snap set ubuntu-frame daemon=false

dhclient -r
dhclient

if grep -q "\$MODE_MENU" "\$CMDLINE"; then

   kiosk_menu

 elif grep -q "\$MODE_INSTALL" "\$CMDLINE"; then

   exit 0
   
 elif grep -q "\$MODE_CHG_URL" "\$CMDLINE"; then

   kiosk_chg_url

 elif grep -q "\$MODE_ADD_CRT" "\$CMDLINE"; then

   kiosk_add_crt

 elif grep -q "\$MODE_ADMIN" "\$CMDLINE"; then

   kiosk_admin

 else

   kiosk_menu

fi

exit 0
EOF

chmod +x $RC_LOCAL 

# Instalar servicios de arranque (kiosk_boot) y apagado (kiosk_shutdown)

# kiosk_boot: Servicio de arranque


cat > /etc/systemd/system/$SERVICENAME_BOOT.service <<EOF
[Service]
ExecStart=$SCRIPT_BOOT
[Install]
WantedBy=default.target
EOF

# kiosk_shutdown: Servicio de apagado 

cat > /etc/systemd/system/$SERVICENAME_SHUTDOWN.service <<EOF
[Unit]
Description=Kiosk shutdown script
DefaultDependencies=no
Conflicts=reboot.target
Before=poweroff.target halt.target shutdown.target reboot.target
Requires=poweroff.target

[Service]
Type=oneshot
ExecStart=$SCRIPT_SHUTDOWN
TimeoutStartSec=0
RemainAfterExit=yes

[Install]
WantedBy=halt.target reboot.target shutdown.target
EOF

# Cambiar shell de dash a bash
echo "dash dash/sh boolean false" | debconf-set-selections
dpkg-reconfigure -p critical dash

if [ $instalar_snap = "TRUE" ]; then
    echo "Instalar SNAP"
    $SCRIPT_INSTALL_SNAP   
  else
    clear
    echo -e " "
    echo -e " "
    echo -e " "
    echo -e " "
    echo -e "\t\t===================================================================="
    echo -e " "
    echo -e "\t\tQuiosco: frame-webkit-kiosk $KIOSK_VERSION"
    echo -e "\t\t----------------------------------"
    echo -e "\t\tSistema preparado para instalar el quiosco, si lo desea puede realizar"
    echo -e "\t\tajustes en el sistema y en el siguiente reinicio se finalizará la "
    echo -e "\t\tconfiguración."
    echo -e " "
    echo -e "\t\t===================================================================="
    echo -e " "
    echo -e " "
    echo -e " "
    echo -e " "
    echo -e " "

fi

echo "Instalación finalizada"

exit 0
