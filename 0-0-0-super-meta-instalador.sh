#!/bin/bash -e

#Full automation.
#This script is only to face a complete updating of the system, from zero.
#For example, when a new version of gcc, glibc or even the kernel. 


#Abrir consola GUI y ser root
#Open Gui console and be root.

if [ $(id -u) -ne 0 ]
	then 
		echo -e "Ur not root bro"
		echo -e "Tines que ser root, tío"
	exit 1
fi

echo "======================================================="
echo "Did you exec env -i HOME=\$HOME TERM=\$TERM /bin/bash ?"
echo "If you did, type SI to continue"
echo "If not, press any key to exit"
echo "======================================================="
read CS
if [ "$CS" != "SI" ]
	then
		echo "exit"
		exit
fi

#====== STAGE 1 ========================================================
. 0-var-general-rc
. $dirversiones/versiones-${vertoinstall}.sh

./0-monta-sym.sh

# Cross-Compiled Linux From Scratch
# Version 3.0.0-SYSVINIT-x86_64-Multilib
# III. Make the Cross-Compile Tools
# 5. Constructing Cross-Compile Tools

#If building on x86_64, this ensures the sanity of the toolchain
case $(uname -m) in
  x86_64) mkdir -pv /tools/lib && ln -sfv /tools/lib /tools/lib64 ;;
esac

cd $srcinst1
./1-1-meta-inst-cross-tools-musl.sh

# IV. Building the Basic Tools
# 6. Constructing a Temporary System
. $srcdir/0-var-inst-tmp-sys-musl-rc
./1-2-meta-inst-tmp-sys-musl.sh

cd $srcinst2
./2-1-creacion-file-system.sh
./2-2-empiece-mount-filesys.sh

#Ahora hay que llevarse cosas al chroot.
#Some stuff (files of variables and instalators mainly) has to be copied
#within the chroot environment.

mkdir -v $croothome_hst
chmod -v 777 $croothome_hst

cp -pv $srcdir/0-var-chroot-musl-rc $croothome_hst
cp -pv $srcinst2/2-4-creacion-directorios.sh $croothome_hst
cp -pv $srcinst2/2-5-creacion-config-files.sh $croothome_hst

cp -pv $srcinst3/* $croothome_hst
cp -pv $dirversiones/versiones-${vertoinstall}.sh $croothome_hst

cp -pvR $srcinst4 $croothome_hst
cp -pvR $srcinst5 $croothome_hst
cp -pvR $srcinst6 $croothome_hst
cp -pvR $srcinst7 $croothome_hst
# No se copia 8, ya que los paquetes se generarán en el propio sistema
# a partir de las recetas de 7.
mkdir -v $croothome_hst/$carpeta8
chmod -v 777 $croothome_hst/$carpeta8

touch $croothome_hst/reg_instal.log
touch $croothome_hst/test.log

#====== STAGE 2 ========================================================
#Para instalación automática
./2-3-1-empiece-chroot.sh

#En esta fase de debugging mejor empezar con:
#./2-3-2-empiece-chroot.sh

