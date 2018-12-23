# Instalador de mpfr


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

echo -e "\nInstalacion de $nombre_dir musl" >> $FILE_BITACORA

#CC="gcc -isystem /usr/include" \
#LDFLAGS="-Wl,-rpath-link,/usr/lib:/lib" \

./configure \
--prefix=/usr \
--disable-static \
--enable-thread-safe \
--docdir=/usr/share/doc/mpfr-$1
registro_error $MSG_CONF

#--libdir=/usr/lib \
#--docdir=/usr/share/doc/mpfr-$1 \
#--enable-thread-safe

make
registro_error $MSG_MAKE

make html
registro_error "make html"

#make check 2>&1 | tee $FILE_CHECKS

make install
registro_error $MSG_INST

make install-html
registro_error "make install-html"

######------------------------------------------------------------------

cd ..
rm -rf $nombre_dir && echo "Borrado el directorio $nombre_dir"


#Registro de tiempos de ejecución
T_FINAL=$(date +"%T")
echo "$(date) $nombre <$MSG_TIME> $T_COMIENZO $T_FINAL" >> $FILE_BITACORA

#errores en test
#libtool: link: gcc -isystem /usr/include -m32 -Wall -Wmissing-prototypes -Wpointer-arith -g -O2 -ffloat-store -Wl,-rpath-link -Wl,/usr/lib:/lib -m32 -o tzeta_ui tzeta_ui.o  -L../src/.libs ./.libs/libfrtests.a -lm -lquadmath ../src/.libs/libmpfr.so /usr/lib/libgmp.so -Wl,-rpath -Wl,/sources/mpfr-4.0.1/src/.libs
#/tools/lib64/gcc/x86_64-unknown-linux-gnu/7.3.0/../../../../x86_64-unknown-linux-gnu/bin/ld: skipping incompatible /tools/lib64/libquadmath.so when searching for -lquadmath
#/tools/lib64/gcc/x86_64-unknown-linux-gnu/7.3.0/../../../../x86_64-unknown-linux-gnu/bin/ld: skipping incompatible /tools/lib64/libquadmath.a when searching for -lquadmath
#make[2]: Leaving directory '/sources/mpfr-4.0.1/tests'






