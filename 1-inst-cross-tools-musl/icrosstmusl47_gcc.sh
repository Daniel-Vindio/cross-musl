# Instalador de gcc Segunda Pasada (MUSL)

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
	echo ""
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

echo -e "\nInstalacion de $nombre_dir Pasada 2 (MUSL x-comp)" >> $FILE_BITACORA

patch -Np1 -i ../gcc-$1.patch
registro_error "patch -Np1 -i ../"

cd $DIR_FUENTES/$nombre_dir/libstdc++-v3/config/os
mv -v gnu-linux gnu-linux.old
ln -svf generic gnu-linux
registro_error "ln -svf generic gnu-linux"
cd $DIR_FUENTES/$nombre_dir

for file in \
 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
      -e 's@/usr@/tools@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
  registro_error "creado $file.orig"
done

##A ver si esto resulve el asunto de limits.h e los sigueintes pasos
##cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
##  `dirname $(${CLFS_TARGET}-gcc -print-libgcc-file-name)`/include-fixed/limits.h
##registro_error "cat gcc/limitx.h"
#cat gcc/limitx.h gcc/glimits.h gcc/limity.h > /tools/include/limits.h este no va bien

#Este funciona.
#cat gcc/glimits.h > /tools/include/limits.h
#pero lo saco fuera a 1-1

if [ -d "build" ] ; then
	rm -rv "build"
fi

mkdir -v build
registro_error "mkdir -v build"
cd build

AR=ar LDFLAGS="-Wl,-rpath,/cross-tools/lib" \
../configure \
--prefix=/cross-tools \
--build=${CLFS_HOST} \
--target=${CLFS_TARGET} \
--host=${CLFS_HOST} \
--with-sysroot=${CLFS} \
--with-local-prefix=/tools \
--with-native-system-header-dir=/tools/include \
--with-mpc=/cross-tools \
--with-mpfr=/cross-tools \
--with-gmp=/cross-tools \
--with-system-zlib \
--enable-languages=c,c++ \
--disable-nls \
--disable-static \
--disable-multilib \
--disable-libsanitizer \
--disable-libmpx
registro_error $MSG_CONF

#--disable-libsanitizer
#Parece que no causa problemas
#El oficial también lo desactiva
#--disable-libmpx
#ver https://gcc.gnu.org/bugzilla/show_bug.cgi?id=72815

#Opciones para analizar errores. Ya no hacen falta
#--disable-libgomp \
#--disable-libstdcxx

###-opcion propuesta en la wiki oficial
##../configure \
##--prefix=/cross-tools \
##--build=${CLFS_HOST} \
##--target=${CLFS_TARGET} \
##--host=${CLFS_HOST} \
##--with-sysroot=${CLFS} \
##--with-mpc=/cross-tools \
##--with-mpfr=/cross-tools \
##--with-gmp=/cross-tools \
##--enable-languages=c,c++ \
##--disable-libmudflap \
##--disable-libsanitizer \
##--disable-nls \
##--disable-multilib \
##--with-multilib-list=
##registro_error $MSG_CONF

make AS_FOR_TARGET="${CLFS_TARGET}-as" LD_FOR_TARGET="${CLFS_TARGET}-ld"
registro_error $MSG_MAKE

#no funciona porque no está instalado Dejagnu
#make check 2>&1 | tee $FILE_CHECKS

make install
registro_error $MSG_INST

######------------------------------------------------------------------

cd ../..
rm -rf $nombre_dir && echo "Borrado el directorio $nombre_dir"


#Registro de tiempos de ejecución
T_FINAL=$(date +"%T")
echo "$(date) $nombre <$MSG_TIME> $T_COMIENZO $T_FINAL" >> $FILE_BITACORA

###eror en 
#https://www.linuxquestions.org/questions/linux-from-scratch-13/gcc-musl-build-fails-4175610920/
#https://github.com/richfelker/musl-cross-make

#bmpx/mpxrt/mpxrt.c:54:
#../../../../libmpx/mpxrt/mpxrt.c: In function 'read_mpx_status_sig':
#../../../../libmpx/mpxrt/mpxrt.h:52:42: error: invalid application of 'sizeof' to incomplete type 'struct _libc_fpstate'
# #define XSAVE_OFFSET_IN_FPMEM    sizeof (struct _libc_fpstate)
#                                          ^~~~~~
#../../../../libmpx/mpxrt/mpxrt.c:132:58: note: in expansion of macro 'XSAVE_OFFSET_IN_FPMEM'
#   uint8_t *regs = (uint8_t *)uctxt->uc_mcontext.fpregs + XSAVE_OFFSET_IN_FPMEM;
#                                                          ^~~~~~~~~~~~~~~~~~~~~
#Makefile:390: recipe for target 'libmpx_la-mpxrt.lo' failed
#make[4]: *** [libmpx_la-mpxrt.lo] Error 1
#make[4]: Leaving directory '/mnt/clfs_MUSL/sources/gcc-8.2.0/build/i686-unknown-linux-musl/libmpx/mpxrt'
#Makefile:412: recipe for target 'all-recursive' failed
#make[3]: *** [all-recursive] Error 1
#make[3]: Leaving directory '/mnt/clfs_MUSL/sources/gcc-8.2.0/build/i686-unknown-linux-musl/libmpx'
#Makefile:303: recipe for target 'all' failed
#make[2]: *** [all] Error 2
#make[2]: Leaving directory '/mnt/clfs_MUSL/sources/gcc-8.2.0/build/i686-unknown-linux-musl/libmpx'
#Makefile:11231: recipe for target 'all-target-libmpx' failed
#make[1]: *** [all-target-libmpx] Error 2


#https://gcc.gnu.org/bugzilla/show_bug.cgi?id=72815
#Bug reconocido.
#¿Solución?
#Simplemente porponen no compilar libmpx.

