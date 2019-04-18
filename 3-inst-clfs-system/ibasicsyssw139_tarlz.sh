# Instalador de tarlz

nombre="tarlz"
nombre_comp=$nombre-$1.tar.lz
nombre_comp2=$nombre-$1.tar
nombre_dir=$nombre-$1

#tarlz-0.15.tar.lz


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
if [ $# != 1 ]
then
	echo "uso ./nombre vesion"
	echo "nombre = nombre del programa"
	echo "version = x.y.z"
	echo "Solo admite lz"
	exit 1
fi

if [ $(id -u) -ne 0 ]
	then 
		echo -e "Ur not root bro"
		echo -e "Tines que ser root, tío"
	exit 1
fi

cd $DIR_FUENTES

echo "Comienza la descompresión..."
lzip -dk $nombre_comp || (echo "error descompresión"; exit 1)
tar -xf $nombre_comp2 || (echo "error descompresión"; exit 1)
rm -v $nombre_comp2
echo "... fin de la descompresión"

cd $nombre_dir

#----------------------CONFIGURE - MAKE - MAKE INSTALL------------------

echo -e "\nInstalacion de $nombre_dir " >> $FILE_BITACORA

./configure 			\
--prefix=/tools
registro_error $MSG_CONF

make
registro_error $MSG_MAKE

make install
registro_error "make install"

######------------------------------------------------------------------

cd ..
rm -rf $nombre_dir && echo "Borrado el directorio $nombre_dir"

#Registro de tiempos de ejecución
T_FINAL=$(date +"%T")
echo "$(date) $nombre <$MSG_TIME> $T_COMIENZO $T_FINAL" >> $FILE_BITACORA


