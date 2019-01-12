#!/bin/bash -e

echo -e "
############################################################\n\
#  Montador de particiones  y Symlinks    -----------------#\n\
############################################################\n"

if [ $(id -u) -ne 0 ]
	then 
		echo -e "Ur not root bro"
		echo -e "Tines que ser root, tío"
	exit 1
fi

. 0-var-general-rc

mount -v -t ext4 ${particion} ${CLFS}
#mount -v -t ext4 ${particionsrc} ${CLFS}/sources

ln -svf ${CLFS}/tools /
ln -svf ${CLFS}/cross-tools /
