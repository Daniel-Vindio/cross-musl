# Instalador de RUNIT
#

#runit-2.1.2.tar
# No está previsto que cambie. No uso sistema de control de versiones

nombre="runit"
nombre_comp=${nombre}-2.1.2.tar
nombre_dir=${nombre}-2.1.2

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

if [ $(id -u) -ne 0 ]
	then 
		echo -e "Ur not root bro"
		echo -e "Tines que ser root, tío"
	exit 1
fi

#----------------------CONFIGURE - MAKE - MAKE INSTALL------------------

echo -e "\nInstalacion de $nombre_dir en MUSL" >> $FILE_BITACORA

. 0-var-chroot-musl-rc

# Instalación de las fuentes
mkdir -v -p /package
chmod -v 1755 /package
cd /package
cp -v $DIR_FUENTES/${nombre_comp}.gz .
gunzip ${nombre_comp}
tar -xpf ${nombre_comp}
rm -v ${nombre_comp}
[ -d admin ] && echo "Fuente instalada"
registro_error "Fuente instalada"

# Instalación de los programas del sistema
cd admin/${nombre_dir}
package/install
registro_error "package/install"

package/install-man
registro_error "package/install-man"

# Step 1: The three stages
mkdir -pv /etc/runit
cp -pv ${srcinst5}/[123] /etc/runit/
registro_error "${srcinst5}/[123]"

cp -pv ${srcinst5}/ctrlaltdel /etc/runit/
registro_error "${srcinst5}/ctrlaltdel"

# Servicios
mkdir -pv /etc/sv/
mkdir -pv /service/

servicios="getty-1 getty-3 klogd localnet randomseed ratonpad syslogd"
for i in $servicios; do
	cp -pvR ${srcinst5}/sv/$i /etc/sv/$i
	registro_error "copia $i"
	ln -svf /etc/sv/$i /service/
	registro_error "Symlink $i"
done

# Step 2: The runit programs
cp -vp /package/admin/runit/command/runit* /sbin/

# Step 3: The getties
# ya están en el paso anterior

# Step 4: Reboot into runit for testing
# No aplica

# Step 5: Service migration
# Ya está en Servicios

# Step 6: Replace /sbin/init
ln -svf runit-init /sbin/init

##------------------------------------------------------------------

#Registro de tiempos de ejecución
T_FINAL=$(date +"%T")
echo "$(date) $nombre <$MSG_TIME> $T_COMIENZO $T_FINAL" >> $FILE_BITACORA






