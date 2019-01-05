# Instalador de findutils
# MUSL.

#findutils-4.6.0.tar.gz

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

sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in
registro_error "sed"
#Con la versión de GNULIB que he usado, no hay tests/Makefile.in
#Seguramente sea mejor usar la versión normal, con lo que entonces
#esta instrucción puede tener sentido. Efectivamente.


#Parece que esto es necesario para Glibc. NO aplica
#sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c
#sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c
#echo "#define _IO_IN_BACKUP 0x100" >> gl/lib/stdio-impl.h

./configure \
--prefix=/usr \
--localstatedir=/var/lib/locate
registro_error $MSG_CONF

make
registro_error $MSG_MAKE

make install
registro_error $MSG_INST

mv -v /usr/bin/find /bin
registro_error "mv"

sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb
registro_error "sed"

#make check 2>&1 | tee $FILE_CHECKS

######------------------------------------------------------------------

cd ..
rm -rf $nombre_dir && echo "Borrado el directorio $nombre_dir"


#Registro de tiempos de ejecución
T_FINAL=$(date +"%T")
echo "$(date) $nombre <$MSG_TIME> $T_COMIENZO $T_FINAL" >> $FILE_BITACORA



