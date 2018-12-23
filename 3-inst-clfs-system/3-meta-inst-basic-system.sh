#!/tools/bin/bash -e

echo -e "
############################################################\n\
#$0\n\
############################################################\n"

control_flujo () {
	echo "Continue? To exit press N"
	read CS
	if [ "$CS" == "N" ]
		then
			echo "exit"
			exit
	fi
}

cd /home

. 0-var-chroot-musl-rc
. versiones.sh

./2-4-creacion-directorios.sh
./2-5-creacion-config-files.sh


# ----Testsuite Tools built in /tools ----------------------------------
./ibasicsyssw1_tcl.sh		$VER_tcl 	gz
./ibasicsyssw2_expect.sh 	$VER_expect gz
./ibasicsyssw3_dejagnu.sh 	$VER_dejagnu gz
./ibasicsyssw4_perl.sh 		$VER_perl 	gz
./ibasicsyssw5_texinfo.sh 	$VER_texinfo xz
./ibasicsyssw6_m4.sh 		$VER_m4 	xz
./ibasicsyssw7_bison.sh 	$VER_bison 	xz

#-----Programas de apoyo -----------------------------------------------
./ibasicsyssw13_man-pages.sh 	$VER_man_pages 	xz
./ibasicsyssw30_zlib.sh 		$VER_zlib xz
./ibasicsyssw42_file.sh 		$VER_file gz
./ibasicsyssw50_readline.sh 	$VER_readline gz
./ibasicsyssw18_m4.sh 			$VER_m4 	xz
./ibasicsyssw52_bc.sh 			$VER_bc gz
./ibasicsyssw131_shadow.sh 		$VER_shadow xz

#------Kernel Headers --------------------------------------------------
./ibasicsyssw12_linux.sh 		$VER_linux 	xz


#-------Libc MUSL ------------------------------------------------------
./ibasicsyssw14_musl.sh 		$VER_musl	gz
#Adjusting the Toolchain and TESTS
./ibasicsyssw16_adjust.sh

#10.8.2. Internationalization
#10.8.3. Configuring Glibc excep time zone
#10.8.4. Configuring The Dynamic Loader 
#ibasicsyssw17_locales.sh
######### Problema, no hay programa localedef ya que es parte de Glib
######### y estamos instalando MUSL


#-------BINUTILS -------------------------------------------------------
./ibasicsyssw36_binutils.sh $VER_binutils gz


#------- GCC y programas de apoyo --------------------------------------
./ibasicsyssw19_gmp.sh		$VER_gmp	xz
./ibasicsyssw22_mpfr.sh 	$VER_mpfr 	xz
./ibasicsyssw24_mpc.sh 		$VER_mpc 	gz

./ibasicsyssw38_gcc.sh $VER_gcc gz
#Analizar quién es y qué hace exactamete este nuevo gcc

./ibasicsyssw39_gcctest.sh

###############-----------------########################################
###Pendiente de revisar en instalar
# Programs for package management: Graft and Qi
#./ibasicsyssw8_lzip.sh 		$VER_lzip 	gz
#./ibasicsyssw9_unzip.sh 	$VER_unzip 	gz
#./ibasicsyssw10_graft.sh 	$VER_graft 	gz
#./ibasicsyssw11_qi.sh 		$VER_qi


echo -e "
#############################################################\n\
#Aplicación en progreso. Faltan más aplicaciones que instalar\n\
#############################################################\n"




