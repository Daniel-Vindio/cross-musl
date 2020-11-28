#!/bin/bash

# Vale tanto para el HOST como para el TARGET
# Simple script to list version numbers of critical development tools

export LC_ALL=C

bash --version | head -n1 | cut -d" " -f2-4
MYSH=$(readlink -f /bin/sh)
echo "/bin/sh -> $MYSH"
echo $MYSH | grep -q bash || echo "ERROR: /bin/sh does not point to bash"
unset MYSH

echo -n "Binutils: "; ld --version | head -n1 | cut -d" " -f3-
bison --version | head -n1

if [ -h /usr/bin/yacc ]; then
  echo "/usr/bin/yacc -> `readlink -f /usr/bin/yacc`";
elif [ -x /usr/bin/yacc ]; then
  echo yacc is `/usr/bin/yacc --version | head -n1`
else
  echo "yacc not found" 
fi

bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-
echo -n "Coreutils: "; chown --version | head -n1 | cut -d")" -f2
diff --version | head -n1
find --version | head -n1
gawk --version | head -n1

if [ -h /usr/bin/awk ]; then
  echo "/usr/bin/awk -> `readlink -f /usr/bin/awk`";
elif [ -x /usr/bin/awk ]; then
  echo awk is `/usr/bin/awk --version | head -n1`
else 
  echo "awk not found" 
fi

gcc --version | head -n1
g++ --version | head -n1
ldd --version | head -n1 | cut -d" " -f2-  # glibc version
grep --version | head -n1
gzip --version | head -n1
cat /proc/version
m4 --version | head -n1
make --version | head -n1
patch --version | head -n1
echo Perl `perl -V:version`
python3 --version
sed --version | head -n1
tar --version | head -n1
makeinfo --version | head -n1  # texinfo version
xz --version | head -n1
help2man --version | head -n1
lzip --version | head -n1

flex --version

if [ -h /usr/bin/lex ]; then
  echo "/usr/bin/lex -> `readlink -f /usr/bin/lex`";
elif [ -x /usr/bin/lex ]; then
  echo lex is `/usr/bin/lex --version | head -n1`
else 
  echo "lex not found" 
fi

file --version | head -n1
lzip --version | head -n1
unzip -v | head -n1
file /usr/include/lzlib.h
tarlz -V | head -n1

libtoolize --version | head -n1
automake --version | head -n1
autoconf --version | head -n1

echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ]
  then echo "g++ compilation OK";
  else echo "g++ compilation failed"; fi
rm -f dummy.c dummy

# For static compilation of RUNIT
diet -v

# Para instalación de PERL hace falta comunicación ssh
#  sudo apt install openssh-client openssh-server
dpkg -l openssh-server
dpkg -l openssh-client
