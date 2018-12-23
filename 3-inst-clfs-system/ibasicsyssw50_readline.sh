# Instalador de readline
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

sed -i '/MV.*old/d' Makefile.in
registro_error "sed -i..."

sed -i '/{OLDSUFF}/c:' support/shlib-install
registro_error "sed -i..."

./configure \
--prefix=/usr \
--disable-static \
--docdir=/usr/share/doc/readline-$1
registro_error $MSG_CONF

make SHLIB_LIBS="-L/tools/lib -lncursesw"
registro_error $MSG_MAKE

make SHLIB_LIBS="-L/tools/lib -lncurses" install
registro_error $MSG_INST

mv -v /usr/lib/lib{readline,history}.so.* /lib
registro_error "Item 1"
chmod -v u+w /lib/lib{readline,history}.so.*
registro_error "Item 2"
ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
registro_error "Item 3"
ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so
registro_error "Item 4"

install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-$1
registro_error "install -v"

######------------------------------------------------------------------

cd ..
rm -rf $nombre_dir && echo "Borrado el directorio $nombre_dir"


#Registro de tiempos de ejecución
T_FINAL=$(date +"%T")
echo "$(date) $nombre <$MSG_TIME> $T_COMIENZO $T_FINAL" >> $FILE_BITACORA






