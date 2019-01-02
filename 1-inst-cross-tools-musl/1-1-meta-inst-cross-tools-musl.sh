#!/bin/bash -e

#-----------------------------------------------------------------------
#Installation of the cross-tool required before building the temporary
#system
#Variables in variables-inst-cross-tools-multilib are required
#-----------------------------------------------------------------------

echo -e "
############################################################\n\
#$0\n\
############################################################\n"

./icrosstmusl1_file.sh 				$VER_file 	gz
./icrosstmusl47_flex.sh				$VER_flex	gz
./icrosstmusl2_linux.sh 			$VER_linux 	xz
./icrosstmusl3_m4.sh 				$VER_m4 	xz
./icrosstmusl4_ncurses.sh 			$VER_ncurses gz
./icrosstmusl5_pkg-config-lite.sh 	$VER_pkg 	gz
./icrosstmusl6_gmp.sh 				$VER_gmp 	xz
./icrosstmusl7_mpfr.sh 				$VER_mpfr 	xz
./icrosstmusl8_mpc.sh 				$VER_mpc 	gz
./icrosstmusl44_binutils.sh 		$VER_binutils gz
./icrosstmusl45_gcc.sh				$VER_gcc	gz
./icrosstmusl46_musl.sh				$VER_musl	gz

cp -v $srcinst1/icrosstmusl_limits.h $CLFS/tools/include/limits.h

./icrosstmusl47_gcc.sh				$VER_gcc	gz

echo -e "
############################################################\n\
#$0\n\
############################################################\n"
echo -e "
#############################\n\
#  terminado con exito      #\n\
#  successfully finised     #\n\
#############################\n"




