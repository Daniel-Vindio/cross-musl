# Instalador de RUNIT
#

#runit-2.1.2.tar
#Ojo en este caso $2 es solo tar

nombre="runit"
nombre_comp=$nombre-$1.$2
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

#----------------------CONFIGURE - MAKE - MAKE INSTALL------------------

echo -e "\nInstalacion de $nombre_dir en MUSL" >> $FILE_BITACORA

mkdir -v -p /package
chmod -v 1755 /package
cd /package
cp -v $DIR_FUENTES/${nombre_comp} .
gunzip ${nombre_comp}
tar -xpf ${nombre_comp}
rm -v ${nombre_comp}
[ -d admin ] && echo "Fuente instalada"
registro_error "Fuente instalada"

# Instalación
cd admin/${nombre_dir}
package/install
registro_error "package/install"

package/install-man
registro_error "package/install-man"



######------------------------------------------------------------------

#cd ..
#rm -rf $nombre_dir && echo "Borrado el directorio $nombre_dir"

#Registro de tiempos de ejecución
T_FINAL=$(date +"%T")
echo "$(date) $nombre <$MSG_TIME> $T_COMIENZO $T_FINAL" >> $FILE_BITACORA






