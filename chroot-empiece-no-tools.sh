#!/bin/bash

echo -e "
############################################################\n\
#$0\n\
############################################################\n"

#Chapter 8. If You Are Going to Chroot 

#Este pequeño script es para recordar y automatizar el arranque del
#chroot. Se supone que ya se ha instalado todo el sw básico y se han
#creado todos los archivos del filesystem y los symlinks necesarios.

#Además, este se empleará cuando se hay terminado de contruir el sistema
#básico de sofware, y ya no sea necesario utilizará /tools.
# LFS 6.80. Cleaning Up

#=== This script is useful to enter the chroot for manteinance, ongoing
#developments etc.

#This little script is to remember and automate the start of the
#chroot. It is assumed that all the basic sw has already been installed and
#created all the files in the filesystem and the necessary symlinks

#In addition, this will be used when you have finished building the basic 
#software system, and it is no longer necessary to use / tools. 
#LFS 6.80. Cleaning Up

#Abrir consola GUI y ser root
#Open Gui console and be root.

if [ $(id -u) -ne 0 ]
	then 
		echo -e "Ur not root bro"
		echo -e "Tines que ser root, tío"
	exit 1
fi

. 0-var-general-rc
cd ${srcinst2}
#Aquí es donde están los empieces
#This is the path to the "starting" scripts
echo "Ya estoy en ${srcinst2}"

#Se monta el file system
#Mounting file system
./2-2-empiece-mount-filesys.sh
echo "Montado el file system"

#Se entra en chroot
#Entering chroot
./2-3-3-empiece-chroot-no-tools.sh
