program="binutils"
version="$VER_binutils"
release="1"
#arch=""

tarname=${program}-${version}.tar.gz

description="

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
---
"


build() {

unpack "${tardir}/$tarname"
cd "$srcdir"

echo -e "\nCreación paquete Qi $program \n$(date)" >> $FILE_BITACORA


make DESTDIR=${destdir} install
}











