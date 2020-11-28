#!/bin/bash -e

# Variables internas
# ==================
me=$0

# Variables sobre Usuario
# =======================
# Necesario para establecer los permisos de los directorios.
# ¿Quién usa USER_Build_machine? Lo dejo en las generales...
USER_Build_machine="daniel"
USER_Target="daniel"


# Variables para particiones y puntos de montaje
#===============================================

# En el HOST=BUILD=TARGET
# ----------------
particion="/dev/sda8"
particionsrc="/dev/sda6"
CLFS="/mnt/clfs_MUSL"

# Estructura de carpetas y direcciones
# ====================================
# Nombres de la estructura de carpetas para todas las máquinas
carpeta1="1-inst-cross-tools-musl"
carpeta2="2-inst-chroot"
carpeta3="3-inst-clfs-system"
carpeta4="4-config-files"
carpeta5="5-runit"
carpeta6="6-kernel"
carpeta7="7-recipes"
carpeta8="8-qipkgs"
carpeta_ver="versiones"
carpeta_reg="registros"

# Carpetas del HOST=BUILD
# -----------------------
# **** OJO ****
# Si se descomenta alguna dirección aquí es necesario ampliarlo en el OEM
# sin olvidar el correspondiente export.

srcdir=$(pwd)
srcinst1="$srcdir/$carpeta1"
srcinst2="$srcdir/$carpeta2"
srcinst3="$srcdir/$carpeta3"
srcinst4="$srcdir/$carpeta4"
srcinst5="$srcdir/$carpeta5"
srcinst6="$srcdir/$carpeta6"
srcinst7="$srcdir/$carpeta7"
srcinst8="$srcdir/$carpeta8"
dirversiones="$srcdir/$carpeta_ver"

# Homes
# En el chroot. NO CAMBIAR
croothome_tgt="/home"
# Antes de entrar en chroot
croothome_hst="${CLFS}${croothome_tgt}"

# Fuentes (tarballs) del HOST
fuentes_host="$CLFS/sources"

# Archivos de registros de control de la instalación
bitacora_host="$srcdir/$carpeta_reg/reg_instal_hst.log"
touch $bitacora_host
chmod 0666 $bitacora_host

# Carpetas del TARGET
# -------------------
# Esta es la ubicación para cosas que deben hacerse antes de entrar
# en el chroot. La usa 0-0-2-super.
# Las carpetas se crean directamente en el EOF usando los nombres 
# normalizados y el nocroothome

#- Después de entrar en chroot
bitacora_chroot="reg_instal_chroot-tgt.log"

# Fuentes (tarballs) del TARGET
# Estas fuentes se colocan dentro de la estructura de directorios
# del chroot. Por eso se da una dirección absoluta /usr/src. Para acceder
# a esas fuentes hay que montar la dirección correspondiente (en ese caso
# hay que poner a fuentes_target el prefijo adecuado, o desde el chroot
# y ahí solo es /usr/src...
fuentes_target="/usr/src/sources"

# Nombres de los archivos de variables
#=====================================
var_gen="0-var-general-rc"
var_12="0-var-inst-tmp-sys-musl-rc"
var_220="0-var-chroot-musl-rc"

# Texto de los mensajes
#======================

# Texto de aviso de no editar los archivos de variables
# -----------------------------------------------------
Mnotedit_en="
#********************************************************
# Do not edit this file
# It's been automatically generated by $me
#********************************************************"

# Texto para los mensajes de los instaladores
# --------------------------------------------
MSG_CONF="Configure"
MSG_MAKE="Make"
MSG_CHK="Check"
MSG_INST="Make_install"
MSG_ERR="Se ha producido un error"
MSG_TIME="Tiempo de instalación"


# Variables de compilación
# ========================

# Versión instalada
# -----------------
vertoinstall="6"

# PATH para la compilación cruzada
path_cross="/cross-tools/bin:/bin:/usr/bin"

# Tripletas de las aquitecturas
# -----------------------------
# (Este también lo usa musl para el ld)
CLFS_ARCH_m="x86_64"
# Este lo usa el kernel
CLFS_ARCH_k="x86"
CLFS_HOST="x86_64-cross-linux-gnu"
CLFS_TARGET="${CLFS_ARCH_m}-unknown-linux-musl"

PKG_CONFIG_PATH="/usr/lib/pkgconfig"

# Velocidad de compilación. Se recomienda 1 para pruebas sin prisas.
MAKEFLAGS="-j 1"

# Variables de compilación cruzada para los instaladores de 1-2
# **** NO EDITAR ****
CC="${CLFS_TARGET}-gcc"
CXX="${CLFS_TARGET}-g++"
AR="${CLFS_TARGET}-ar"
AS="${CLFS_TARGET}-as"
RANLIB="${CLFS_TARGET}-ranlib"
LD="${CLFS_TARGET}-ld"
STRIP="${CLFS_TARGET}-strip"


cat > ${srcdir}/${var_gen} << EOF
${Mnotedit_en}

echo -e "\n--> Sourcing ${var_gen}\n"

set +h
umask 022

LC_ALL=POSIX
export LC_ALL

unset CFLAGS CXXFLAGS

PATH=$path_cross
export PATH

unset CFLAGS CXXFLAGS

vertoinstall=$vertoinstall
export vertoinstall

MSG_CONF="$MSG_CONF"
MSG_MAKE="$MSG_MAKE"
MSG_CHK="$MSG_CHK"
MSG_INST="$MSG_INST"
MSG_ERR="$MSG_ERR"
MSG_TIME="$MSG_TIME"
export MSG_CONF MSG_MAKE MSG_CHK MSG_INST MSG_ERR MSG_TIME

CLFS_HOST=$CLFS_HOST
CLFS_TARGET=$CLFS_TARGET
CLFS_ARCH_m=$CLFS_ARCH_m
CLFS_ARCH_k=$CLFS_ARCH_k
export CLFS_HOST CLFS_TARGET CLFS_ARCH_m CLFS_ARCH_k

MAKEFLAGS='$MAKEFLAGS'
export MAKEFLAGS

particion=$particion
particionsrc=$particionsrc
CLFS=$CLFS
export CLFS particion particionsrc

var_gen=$var_gen
var_12=$var_12
var_220=$var_220
export var_gen var_12 var_220

carpeta1=$carpeta1
carpeta2=$carpeta2
carpeta3=$carpeta3
carpeta4=$carpeta4
carpeta5=$carpeta5
carpeta6=$carpeta6
carpeta7=$carpeta7
carpeta8=$carpeta8
carpeta_ver=$carpeta_ver
carpeta_reg=$carpeta_reg
export carpeta1 carpeta2 carpeta3 carpeta4 carpeta5 carpeta6 carpeta7
export carpeta8
export carpeta_ver carpeta_reg

srcdir=$srcdir
srcinst1=$srcinst1
srcinst2=$srcinst2
srcinst3=$srcinst3
srcinst4=$srcinst4
srcinst5=$srcinst5
srcinst6=$srcinst6
srcinst7=$srcinst7
srcinst8=$srcinst8
dirversiones=$dirversiones
croothome_hst=$croothome_hst
export srcdir srcinst1 srcinst2 srcinst3 srcinst4 srcinst5 srcinst6
export srcinst7 srcinst8
export dirversiones croothome_hst

DIR_FUENTES=$fuentes_host
export DIR_FUENTES

FILE_BITACORA=$bitacora_host
export FILE_BITACORA

USER_Build_machine=$USER_Build_machine
export USER_Build_machine

EOF

cat > ${srcdir}/${var_12} << EOF
${Mnotedit_en}

echo -e "\n--> Sourcing ${var_12}"

echo -e "--> ***Usar SOLO despues de haber acabado con 1-1***\n"

CC=$CC
CXX=$CXX
AR=$AR
AS=$AS
RANLIB=$RANLIB
LD=$LD
STRIP=$STRIP
export CC CXX AR AS RANLIB LD STRIP

EOF

cat > ${srcdir}/${var_220} << EOF
${Mnotedit_en}

echo -e "\n--> Sourcing ${var_220}\n"

# Variables para acciones realizadas dentro del chroot.

set +h

var_220=$var_220
export var_220

croothome_tgt=$croothome_tgt
srcinst4="$croothome_tgt/$carpeta4"
srcinst5="$croothome_tgt/$carpeta5"
srcinst6="$croothome_tgt/$carpeta6"
srcinst7="$croothome_tgt/$carpeta7"
srcinst8="$croothome_tgt/$carpeta8"
export croothome_tgt srcinst4 srcinst5 srcinst6 srcinst7 srcinst8

DIR_FUENTES=${fuentes_target}
export DIR_FUENTES

FILE_BITACORA=${croothome_tgt}/${carpeta_reg}/${bitacora_chroot}
export FILE_BITACORA

MAKEFLAGS='$MAKEFLAGS'
export MAKEFLAGS

PKG_CONFIG_PATH=$PKG_CONFIG_PATH
exportPKG_CONFIG_PATH

MSG_CONF="$MSG_CONF"
MSG_MAKE="$MSG_MAKE"
MSG_CHK="$MSG_CHK"
MSG_INST="$MSG_INST"
MSG_ERR="$MSG_ERR"
MSG_TIME="$MSG_TIME"
export MSG_CONF MSG_MAKE MSG_CHK MSG_INST MSG_ERR MSG_TIME

EOF
