# Instalador de coreutils
# MUSL.

#coreutils-8.30.tar.xz

nombre=$(echo $0 | cut -d "." -f2 | cut -d "_" -f2)
nombre_comp=$nombre-$1.tar.$2
nombre_dir=$nombre-$1

T_COMIENZO=$(date +"%T")	#para calcular el tiempo de instalación

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


# $# es el nº de argumentos. Aquí se comprueba la sintaxis de la 
# aplicación
if [ $# != 2 ]
then
	echo "uso ./nombre vesion compresion"
	echo "nombre = nombre del programa"
	echo "version = x.y.z"
	echo "compresión = gz / xz etc"
	exit 1
fi

if [ $(id -u) -ne 0 ]
	then 
		echo -e "Ur not root bro"
		echo -e "Tines que ser root, tío"
	exit 1
fi

cd $DIR_FUENTES

if [ -e $nombre_comp ]
then
	echo "Comienza la descompresión ..."
else
	echo "no existe el archivo, o no tiene el formato .tar"
	echo "se abandona la instalación"
	exit 1
fi

case $2 in
	gz)
	tar -zxf $nombre_comp || (echo "error descompresión"; exit 1);;

	bz2)
	tar -jxf $nombre_comp || (echo "error descompresión"; exit 1);;

	xz)
	tar -xf $nombre_comp || (echo "error descompresión"; exit 1);;
	
	tgz)
	tar -xvzf $nombre_comp || (echo "error descompresión"; exit 1);;

	*)
	echo "uso ./$nombre x.y.z (gz/bz2/zx)"
	exit 1;;
esac	
echo "... fin de la descompresión"

cd $nombre_dir

#----------------------CONFIGURE - MAKE - MAKE INSTALL------------------

echo -e "\nInstalacion de $nombre_dir MUSL" >> $FILE_BITACORA

sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk
registro_error "sed"

autoreconf -fiv
registro_error "autoreconf"

#automake -f -v
#registro_error "automake"

FORCE_UNSAFE_CONFIGURE=1 \
./configure \
--prefix=/usr \
--enable-no-install-program=kill,uptime
registro_error $MSG_CONF

FORCE_UNSAFE_CONFIGURE=1 make
registro_error $MSG_MAKE

make install
registro_error $MSG_INST

mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
registro_error "1"
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
registro_error "3"
mv -v /usr/bin/chroot /usr/sbin
registro_error "4"
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
registro_error "5"
sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
registro_error "6"
mv -v /usr/bin/{head,sleep,nice} /bin
registro_error "7"
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
registro_error "2"

#----------pruebas------------------------
#make NON_ROOT_USERNAME=nobody check-root 2>&1 | tee $FILE_CHECKS
#echo "dummy:x:1000:nobody" >> /etc/group
#registro_error "dummy"
#chown -Rv nobody .
#registro_error "chown"
#su nobody -s /bin/bash -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
#sed -i '/dummy/d' /etc/group
#registro_error "sed"

######------------------------------------------------------------------

cd ..
rm -rf $nombre_dir && echo "Borrado el directorio $nombre_dir"

#Registro de tiempos de ejecución
T_FINAL=$(date +"%T")
echo "$(date) $nombre <$MSG_TIME> $T_COMIENZO $T_FINAL" >> $FILE_BITACORA



