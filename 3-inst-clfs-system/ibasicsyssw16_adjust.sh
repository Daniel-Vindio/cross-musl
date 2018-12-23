# 10.9. Adjusting the Toolchain


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

function registro_error2 () {
#Función para registrar errores y resultados en la bitaćora
if [ -z "$1" ]
then
	MOMENTO=$(date)
	echo $MSG_ERR
	echo "$MOMENTO Toolchain <$1> -> ERROR" >> $FILE_BITACORA
	exit 1
else
	MOMENTO=$(date)
	echo "$MOMENTO <$1> -> Conforme" >> $FILE_BITACORA
fi
}


if [ $(id -u) -ne 0 ]
	then 
		echo -e "Ur not root bro"
		echo -e "Tines que ser root, tío"
	exit 1
fi


#----------------------CONFIGURE - MAKE - MAKE INSTALL------------------
echo -e "\n10.9. Adjusting the Toolchain and TESTS" >> $FILE_BITACORA


#gcc -dumpspecs | \
#perl -p -e 's@/tools/lib/ld@/lib/ld@g;' \
#     -e 's@/tools/lib64/ld@/lib64/ld@g;' \
#     -e 's@\*startfile_prefix_spec:\n@$_/usr/lib/ @g;' > \
#     $(dirname $(gcc --print-libgcc-file-name))/specs
#registro_error "gcc -dumpspecs "


gcc -dumpspecs | sed -e 's@/tools@@g'                   \
    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
    `dirname $(gcc --print-libgcc-file-name)`/specs

echo 'int main(){}' > dummy.c
gcc dummy.c -v -Wl,--verbose &> /tmp/dum_test

readelf -l a.out | grep ': /lib'
grep -o '/usr/lib.*/crt[1in].*succeeded' /tmp/dum_test
grep -B4 '^ /tools/include' /tmp/dum_test
grep 'SEARCH.*/lib' /tmp/dum_test |sed 's|; |\n|g'
grep "/lib.*/libc.*" /tmp/dum_test
grep found /tmp/dum_test


rm -v dummy.c a.out /tmp/dum_test


