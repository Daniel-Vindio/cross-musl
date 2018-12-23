# Instalador de gcc
# MUSL.

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

echo -e "\nInstalacion de $nombre_dir MUSL 3º" >> $FILE_BITACORA

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
    registro_error "sed -e '/m64="
  ;;
esac

rm -fr /usr/lib/gcc
registro_error "rm -f /usr/lib/gcc"

if [ -d "build" ] ; then
	rm -rv "build"
fi

mkdir build
registro_error "mkdir build"
cd build

ln -sfv /tools/bin/gcc /tools/bin/cc

SED=sed \
AR=ar \
../configure \
--prefix=/usr \
--host="x86_64-unknown-linux-musl" \
--enable-languages=c,c++ \
--disable-bootstrap \
--disable-multilib \
--disable-libmpx \
--disable-libsanitizer \
--with-system-zlib
registro_error $MSG_CONF

make
registro_error $MSG_MAKE

#ulimit -s 32768
#rm ../gcc/testsuite/g++.dg/pr83239.C
#chown -Rv nobody . 
#su nobody -s /bin/bash -c "PATH=$PATH make -k check"
#../contrib/test_summary >> $FILE_CHECKS

make install
registro_error $MSG_INST

ln -sfv ../usr/bin/cpp /lib
registro_error "ln -sv /usr/bin/cpp /lib"

ln -sfv gcc /usr/bin/cc
registro_error "ln -sv gcc /usr/bin/cc"

install -v -dm755 /usr/lib/bfd-plugins
registro_error "install -v -dm755..."

ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/$1/liblto_plugin.so /usr/lib/bfd-plugins/
registro_error "ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/$1/"

mkdir -pv /usr/share/gdb/auto-load/usr/lib
registro_error "mkdir -pv /usr/share/gdb/auto-load/usr/lib"

mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
registro_error "mv -v /usr/lib/*gdb.py /usr/share/gdb/----"

unlink /tools/bin/cc

######------------------------------------------------------------------

cd ../..
rm -rf $nombre_dir && echo "Borrado el directorio $nombre_dir"


#Registro de tiempos de ejecución
T_FINAL=$(date +"%T")
echo "$(date) $nombre <$MSG_TIME> $T_COMIENZO $T_FINAL" >> $FILE_BITACORA

