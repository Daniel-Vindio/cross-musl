# Este script sirve para almacenar todas las variables de versión, las 
# cuales son compartidas por varios instaladores. De esta froma se 
# centraliza su control, lo que facilita la actualización continua de 
# las versiones.

# This script is used to store all the version variables, which are 
# shared by several installers. This control is centralized in order to 
# make easier the continuous updating of the versions.

#============== HISTÓRICO DE CAMBIOS ===================================
#Version actualizada en marzo / abril 2019
#11/04/2019 Se añade musl-1.1.22
# Mayo 2019: lzlib tarlz
#Con esta versión de finales de mayo 2019 empiezo el sistema de versiones
# 31/05/019 ---> Versión 0
# 09/05/2019 --> Versión 1
# 21/07/2019 --> Versión 2
# 23/11/2019 --> Versión 3
# 31/12/2019 --> Versión 4
# 22/02/2020 --> Versión 5 (por nuevo musl, binutils, gmp)
# 14/03/2020 --> Version 5 (sí, 5. actualizo IPRpute2)
# 20/03/2020 --> Version 5 (sí, 5. actualizo kmod)
# 03/04/2020 --> Version 5 (sí, 5. actualizo kbd)
# 10/04/2020 --> Version 6 (gcc y coreutils)
# 05/04/2020 --> Version 6 (añado ntp)
# 01/05/2020 --> Version 6 (añado fakehwclock)
# 02/05/2020 --> Version 6 (añado tzdb)
# 24/05/2020 --> Version 6 (añado wpa_supplicant libnl, actualizo openssl readline)

# Important warning regarding the correct assigment of the version
# values to the variables.
echo -e "
--> Sourcing $BASH_SOURCE
--> Remember: Do not try ./versiones.sh, 'export' won't work!.  
--> Use instead, source versiones-x.sh"

if [ "$0" != "$BASH_SOURCE" ]
then
	echo -e "--> Ok, vale. It seems you've used '. versiones-${vertoinstall}.sh'"
else
	echo -e "
=======================================================
 I told you. With ./versiones-x.sh, 'export' won't work!.  
 Use instead source '. versiones-x.sh'	EXIT.			   
======================================================="
	exit
fi
	


paquetes="PRUEBA binutils bash bison bzip2 check cloog coreutils dejagnu \
diffutils expect file findutils gawk gcc gettext glibc gmp graft grep \
gzip isl linux lzip m4 make man_pages mpc mpfr ncurses patch perl pkg \
qi sed tar tcl texinfo unzip util_linux vim xz zlib flex readline bc \
attr acl libcap shadow psmisc iana libtool gdbm gperf expat inetutils \
xmlparser intltool autoconf automake kmod elfutils libelf tcc libffi \
openssl Python ninja meson procps e2fsprogs groff grub less iproute2 \
kbd libpipeline sysklogd sysvinit eudev man_db dietlibc runit gpm \
help2man musl libuargp libressl lzlib tarlz moe tree ntp fakehwclock \
tzdb wpa_supplicant libnl"

VER_PRUEBA="prueba_ok"

#VER_binutils="2.30"
#VER_binutils="2.31.1"
#VER_binutils="2.31.1.dev010119"
#VER_binutils="2.32"
#VER_binutils="2.34"
VER_binutils="2.35.1"

#VER_file="5.32"
#VER_file="5.34"
#VER_file="5.35"
VER_file="5.36"
#VER_file="5.38"

#VER_gcc="7.3.0"
#VER_gcc="8.1.0"
#VER_gcc="8.2.0"
#VER_gcc="8.3.0"
#VER_gcc="9.1.0"
#VER_gcc="9.2.0"
#VER_gcc="9.3.0"
VER_gcc="10.2.0"

#VER_glibc="2.27"
#VER_glibc="2.28"
#VER_glibc="2.29"

#VER_gmp="6.0.0"
#VER_gmp="6.1.2"
VER_gmp="6.2.0"

#VER_linux="4.16"
#VER_linux="4.17"
#VER_linux="4.18.16"
#VER_linux="5.0"
#VER_linux="5.5.5"
VER_linux="5.6"


VER_m4="1.4.18"

#VER_mpc="1.0.2"
#VER_mpc="1.1.0"
VER_mpc="1.2.1"

#VER_mpfr="3.1.2"
#VER_mpfr="4.0.1"
#VER_mpfr="4.0.2"
VER_mpfr="4.1.0"

#VER_ncurses="6.1"
VER_ncurses="6.2"

VER_cloog="0.18.4"
VER_isl="0.18"

#VER_pkg="0.28-1"		#pkg-config-lite. En instalador bien
VER_pkg="0.29.2"

#VER_bash="4.4.18"
VER_bash="5.0"

VER_bzip2="1.0.6"
#VER_bzip2="1.0.8"

#VER_coreutils="8.29"
#VER_coreutils="8.30"
##VER_coreutils="8.31"
VER_coreutils="8.32"

#VER_check="0.12.0"
VER_check="0.14.0"

#VER_diffutils="3.6"
VER_diffutils="3.7"

#VER_findutils="4.6.0"
VER_findutils="4.7.0"

#VER_gawk="4.2.0"
#VER_gawk="4.2.1"
VER_gawk="5.0.1"

#VER_gettext="0.19.8.1"
#VER_gettext="0.20.1"
VER_gettext="0.21"

#VER_grep="3.1"
#VER_grep="3.4"
VER_grep="3.6"

#VER_gzip="1.9"
VER_gzip="1.10"

#VER_make="4.2.1"
VER_make="4.3"

VER_patch="2.7.6"

#VER_sed="4.4"
VER_sed="4.8"

#VER_tar="1.30"
VER_tar="1.32"

#VER_util_linux="2.31.1"	#util-linux En instalador bien
VER_util_linux="2.35"

VER_vim="8.0"

#VER_xz="5.2.3"
VER_xz="5.2.4"

VER_zlib="1.2.11"
VER_tcl="8.6.8"
VER_expect="5.45.4"		#expect5.45.4 Si guion
VER_dejagnu="1.6.1"

#VER_perl="5.26.1"
VER_perl="5.30.1"

#VER_texinfo="6.5"
#VER_texinfo="6.6"
VER_texinfo="6.7"

#VER_bison="3.0.4"
#VER_bison="3.3.2"
#VER_bison="3.4.1"
#VER_bison="3.4.2"
VER_bison="3.7.4"

#VER_lzip="1.20"
VER_lzip="1.21"

VER_unzip="60" 			#unzip60 sin guion
VER_graft="2.16"

#VER_qi="1.0-rc24"
VER_qi="1.3"

VER_man_pages="4.15" 	#man-pages En instalador bien

#VER_flex="2.6.4"
VER_flex="2.6.4.dev020119"

#VER_readline="7.0"
VER_readline="8.0"

VER_bc="1.07.1"
VER_attr="2.4.48"
VER_acl="2.2.53"
VER_libcap="2.25"

#VER_shadow="4.6"
#VER_shadow="4.8"
VER_shadow="4.8.1"


VER_psmisc="23.1"
VER_iana="2.30"			#iana-etc en el instalador
VER_libtool="2.4.6"
VER_gdbm="1.15"
VER_gperf="3.1"
VER_expat="2.2.5"
VER_inetutils="1.9.4"
VER_xmlparser="2.44"
VER_intltool="0.51.0"
VER_autoconf="2.69"

#VER_automake="1.15.1"
VER_automake="1.16.2"

#VER_kmod="25"
VER_kmod="27"

#VER_elfutils="0.170"
VER_elfutils="0.174"

VER_libelf=${VER_elfutils}
VER_tcc="0.9.27"
VER_libffi="3.2.1"

#VER_openssl="1.1.0g"
VER_openssl="1.1.1g"

VER_Python="3.6.4"
VER_ninja="1.8.2"
VER_meson="0.44.0"

#VER_procps="3.3.12"
VER_procps="3.3.16"

#VER_e2fsprogs="1.43.9"
#VER_e2fsprogs="1.45.4"
VER_e2fsprogs="1.45.5"

VER_groff="1.22.3"

#VER_grub="2.02"
VER_grub="2.04"

#VER_less="530"
VER_less="563"

#VER_iproute2="4.15.0"
VER_iproute2="5.5.0"

#VER_kbd="2.0.4"
VER_kbd="2.2.0"

VER_libpipeline="1.5.0"
VER_sysklogd="1.5.1"

#VER_sysvinit="2.88dsf"
VER_sysvinit="2.96"

#VER_eudev="3.2.5"
VER_eudev="3.2.9"

VER_man_db="2.8.1"

#VER_dietlibc="0.33"
VER_dietlibc="0.34"

VER_runit="2.1.2"
VER_gpm="1.20.7"

#VER_help2man="1.47.8"
#VER_help2man="1.47.10"
#VER_help2man="1.47.11"
VER_help2man="1.47.16"

#VER_musl="1.1.20"
#VER_musl="1.1.20.dev010119"
#VER_musl="1.1.21"
#VER_musl="1.1.22"
#VER_musl="1.1.23"
#VER_musl="1.1.24"
VER_musl="1.2.0"

VER_libuargp="dev070119"
VER_libressl="2.8.3"
VER_lzlib="1.11"

#VER_tarlz="0.15"
VER_tarlz="0.16"

VER_moe="1.10"
VER_tree="1.8.0"

VER_ntp="4.2.8p14"

VER_fakehwclock="1.0"

VER_tzdb="2020a"

VER_wpa_supplicant="2.9"

VER_libnl="3.5.0"


for i in $paquetes; do
	export VER_$i
done

echo -e "--> Test = $VER_PRUEBA. Should be 'prueba_ok'\n"

#https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
# if "$0" == "$BASH_SOURCE" then the file has been sourced, othewise 
# it was excuted with ./
# $_ could've been used instead $BASH_SOURCE... I don't it see clear.
