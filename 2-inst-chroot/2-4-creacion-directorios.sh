#!/tools/bin/bash -e
#OJO esto es porque en chroot bash no está en /bin todavía
#We need bash in tools, because in chroot bash has not been created yet.

#This script is used only once, when creating the file system directories
#Este script se usa solo una vez, al crear los directorios del sistema
# de archivos

control_flujo () {
	echo "Continue? To exit press N"
	read CS
	if [ "$CS" == "N" ]
		then
			echo "exit"
			exit
	fi
}

if [ $(id -u) -ne 0 ]; then 
	echo -e "Ur not root bro"
	echo -e "Tines que ser root, tío"
	exit 1
fi


#8.5. Creating Directories 
#Los directorios se crean desde chroot
# Directories are created from chroot
#6.5. Creating Directories 

proc_root=$(ls -id / | cut -d " " -f1)
[ $proc_root == "2" ] && echo "Debe hacerse en chroot / must be chroot" \
&& exit 1

mkdir -pv /{bin,boot,etc/{opt,sysconfig},lib/firmware,mnt,opt}
mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -v  /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -v  /usr/libexec
mkdir -pv /usr/{,local/}share/man/man{1..8}
#control_flujo

install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
install -dv /usr/lib/locale
#control_flujo

case $(uname -m) in
 x86_64) mkdir -v /lib64 ;;
esac

mkdir -v /var/{log,mail,spool}
mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}
ln -sv /run /var/run
ln -sv /run/lock /var/lock
#control_flujo

#-----8.6. Creating Essential Files and Symlinks 
#-----6.6. Creating Essential Files and Symlinks 

ln -sv /tools/bin/{bash,cat,dd,echo,file,ln,pwd,rm,stty} /bin
ln -sv /tools/bin/{env,install} /usr/bin
#control_flujo

ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib
ln -sv /tools/lib/libstdc++.{a,so{,.6}} /usr/lib
#control_flujo

for lib in blkid lzma mount uuid
do
    ln -sv /tools/lib/lib$lib.so* /usr/lib
done
#control_flujo

ln -svf /tools/include/blkid    /usr/include
ln -svf /tools/include/libmount /usr/include
ln -svf /tools/include/uuid     /usr/include
#control_flujo

install -vdm755 /usr/lib/pkgconfig

for pc in blkid mount uuid
do
    sed 's@tools@usr@g' /tools/lib/pkgconfig/${pc}.pc > /usr/lib/pkgconfig/${pc}.pc
done
#control_flujo

ln -sv bash /bin/sh
#control_flujo
