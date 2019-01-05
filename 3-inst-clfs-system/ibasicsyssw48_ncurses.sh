# Instalador de ncurses
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

echo -e "\nInstalacion de $nombre_dir MUSL" >> $FILE_BITACORA

sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
registro_error "sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in"

./configure \
--prefix=/usr \
--mandir=/usr/share/man \
--with-shared \
--without-debug \
--without-normal \
--enable-pc-files \
--enable-widec
registro_error $MSG_CONF

make
registro_error "make"

make install
registro_error "make install"

mv -v /usr/lib/libncursesw.so.6* /lib
registro_error "mv -v /usr/lib/"

ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so
registro_error "ln -sfv ../"

for lib in ncurses form panel menu ; do
    rm -vf /usr/lib/lib${lib}.so
    registro_error "rm $lib"
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    registro_error "echo $lib"
    ln -sfv ${lib}w.pc /usr/lib/pkgconfig/${lib}.pc
    registro_error "ln -svf $lib"
done

rm -vf /usr/lib/libcursesw.so
registro_error "rm ..."

echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
registro_error "ech ..."

ln -sfv libncurses.so /usr/lib/libcurses.so
registro_error "ln -svf ..."

make distclean
./configure \
--prefix=/usr \
--with-shared \
--without-normal \
--without-debug \
--without-cxx-binding \
--with-abi-version=5
registro_error "./configure..."

make sources libs
registro_error "make..."

cp -av lib/lib*.so.5* /usr/lib
#registro_error "cp..."
#Se copian, pero da error por cuestión de no poder copiar "algo"
#relacionado con permisos

######------------------------------------------------------------------

cd ..
rm -rf $nombre_dir && echo "Borrado el directorio $nombre_dir"


#Registro de tiempos de ejecución
T_FINAL=$(date +"%T")
echo "$(date) $nombre <$MSG_TIME> $T_COMIENZO $T_FINAL" >> $FILE_BITACORA

