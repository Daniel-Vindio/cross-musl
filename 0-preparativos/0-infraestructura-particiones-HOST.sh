#!/bin/bash -e

# Creación de los directorios necesarios para la construcción del sistema

if [ $(id -u) -ne 0 ]
	then 
		echo -e "Ur not root bro"
		echo -e "Tines que ser root, tío"
	exit 1
fi

. ../0-var-general-rc

if [ -z "${CLFS}" ]; then
	echo "CLFS no está definida!"
	exit 1
fi

if [ -z "${particion}" ]; then
	echo "particion no está definida!"
	exit 1
fi

mkdir -vp ${CLFS}
mount -v -t ext4 ${particion} ${CLFS}

# Con esto se obtiene el último carácter, que es el nº de partición.
num_part=${particion#*dev/}

mkdir -vp ${CLFS}/{tools,cross-tools,sources}
chmod -v a+wt ${CLFS}/sources
chown -v ${USER_Build_machine} ${CLFS}/{tools,cross-tools,sources}

touch ${CLFS}/MONTADO-dev-${num_part}
chown -v ${USER_Build_machine} ${CLFS}/MONTADO-dev-${num_part}

touch ${CLFS}/VERSION-${vertoinstall}
chown -v ${USER_Build_machine} ${CLFS}/VERSION-${vertoinstall}

umount -v ${particion}
