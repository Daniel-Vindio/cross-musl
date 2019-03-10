program="openssl"
version="$VER_openssl"
release="1"
#arch=""

tarname=${program}-${version}.tar.gz

description="

The OpenSSL package contains management tools and libraries relating to 
cryptography. These are useful for providing cryptographic functions to 
other packages, such as OpenSSH, email applications and web browsers 
(for accessing HTTPS sites).
---
"


build() {

unpack "${tardir}/$tarname"
cd "$srcdir"

echo -e "\nCreación paquete Qi $program \n$(date)" >> $FILE_BITACORA

./config \
--prefix=/usr \
--openssldir=/etc/ssl \
--libdir=/lib \
shared \
zlib-dynamic \
no-async

make

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile

make MANSUFFIX=ssl DESTDIR=${destdir} install
}











