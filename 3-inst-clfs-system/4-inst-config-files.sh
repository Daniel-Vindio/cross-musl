#!/bin/bash -e

echo -e "
############################################################\n\
#$0\n\
############################################################\n"

function registro_error () {
#Función para registrar errores y resultados en la bitaćora
if [ $? -ne 0 ]
then
	MOMENTO=$(date)
	echo $MSG_ERR
	echo "$MOMENTO $nombre <$1> -> ERROR" >> $FILE_BITACORA
	exit 1
else
	MOMENTO=$(date)
	echo "$MOMENTO $nombre <$1> -> Conforme" >> $FILE_BITACORA
fi
}

if [ $(id -u) -ne 0 ]; then 
	echo -e "Ur not root bro"
	echo -e "Tines que ser root, tío"
	exit 1
fi

# Últimamente no funciona esto...
#proc_root=$(ls -id / | cut -d " " -f1)
#[ $proc_root == "2" ] && echo "Debe hacerse en chroot / must be chroot" \
#&& exit 1

#Debe instalarse desde chroot, y debe existir /home y /boot, si no que
# abandonde.
cd /home

. 0-var-chroot-musl-rc
. versiones.sh

#echo "========================================================="
#echo "Se trata de archivos de configuración ¿quieres parar para"
#echo "y ajustarlos? fstab y la partición ... por ejemplo"
#echo "Teclea SI para parar"
#echo "Cualquier tecla para continuar sin cambiarlos"
#echo "======================================================="
#read CS
#if [ "$CS" = "SI" ]
#	then
#		echo "exit"
#		exit
#fi

echo -e "\nInstalacion de ARCHIVOS DE CONFIGURACIÓN" >> $FILE_BITACORA

cd ${srcinst4}

#Se entiende que a estas alturas, si estás en chroot, debe existir /etc
#Si no existe Sysconfig, lo crea.
if [ ! -d "/etc/sysconfig" ]; then
	mkdir -vp /etc/sysconfig
fi

# clock. No lo instalo. Se ajusta en /etc/runit/1
# mouse. No lo instalo. Va con el pripio servicio de runit
configfiles1="console createfiles ifconfig.enp1s8 \
ifconfig.wlp0s29f7u6 modules rc.site udev_retry \
wpa_supplicant-wlp0s29f7u6.conf syslog.conf vimrc"
for i in ${configfiles1}; do
	install -v -m0644 ${i} -t /etc/sysconfig
	registro_error "${i} ok"
done

configfiles2="hostname resolv.conf inputrc profile shells"
for i in ${configfiles2}; do
	install -v -m0644 ${i} -t /etc
	registro_error "${i} ok"
done

if [ ! -f "/etc/hosts" ]; then
	echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
	registro_error "etc/hosts ok"
fi

install -v -m0644 fstab -t /etc
registro_error "fstab"

if [ ! -d "/etc/modprobe.d" ]; then
	mkdir -vp /etc/modprobe.d
fi
install -v -m755 usb.conf -t /etc/modprobe.d
registro_error "usb.conf"


# No vale para GRUB2
#if [ ! -d "/boot/grub" ]; then
#	mkdir -vp /boot/grub
#fi
#install -v -m0644 grub.cfg -t /boot/grub
#registro_error "/boot/grub"


echo -e "
#############################################################\n\
# Instalados los éxito los archivos de configuración         \n\
#############################################################\n"




