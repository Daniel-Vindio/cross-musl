#!/bin/bash -e

echo -e "
############################################################\n\
#$0\n\
############################################################\n"

./itmpsysmusl16_gmp.sh 			$VER_gmp 		xz
./itmpsysmusl17_mpfr.sh 		$VER_mpfr 		xz
./itmpsysmusl18_mpc.sh 			$VER_mpc 		gz
./itmpsysmusl21_zlib.sh			$VER_zlib		xz
./itmpsysmusl22_binutils.sh		$VER_binutils 	gz
./itmpsysmusl23_gcc.sh 			$VER_gcc		gz
./itmpsysmusl24_ncurses.sh 		$VER_ncurses 	gz
./itmpsysmusl25_bash.sh 		$VER_bash		gz
./itmpsysmusl26_bzip2.sh 		$VER_bzip2 		gz
./itmpsysmusl27_check.sh 		$VER_check 		gz
./itmpsysmusl28_coreutils.sh 	$VER_coreutils	xz
./itmpsysmusl29_diffutils.sh 	$VER_diffutils 	xz
./itmpsysmusl30_file.sh 		$VER_file 		gz
./itmpsysmusl31_findutils.sh	$VER_findutils	gz
./itmpsysmusl32_gawk.sh 		$VER_gawk 		xz
./itmpsysmusl33_gettext.sh 		$VER_gettext 	xz
./itmpsysmusl34_grep.sh 		$VER_grep 		xz
./itmpsysmusl35_gzip.sh 		$VER_gzip	 	xz
./itmpsysmusl36_make.sh 		$VER_make 		bz2
./itmpsysmusl37_patch.sh 		$VER_patch 		xz
./itmpsysmusl38_sed.sh 			$VER_sed 		xz
./itmpsysmusl39_tar.sh 			$VER_tar 		xz
###./itmpsysmusl40_texinfo.sh 	$VER_texinfo 	xz	#Impossible to install now
./itmpsysmusl41_util-linux.sh	$VER_util_linux xz
###./itmpsysmusl42_vim.sh 		$VER_vim 		bz2	#Impossible to install now
./itmpsysmusl43_xz.sh 			$VER_xz 		xz


echo -e "
############################################################\n\
#$0\n\
############################################################\n"
echo -e "
#############################\n\
#  terminado con exito      #\n\
#  successfully finised     #\n\
#############################\n"
