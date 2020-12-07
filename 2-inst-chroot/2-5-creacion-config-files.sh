#!/bin/bash -e

#8.8. Creating the passwd, group, and log Files 

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

#Desactivado temporalmemte. No detecta bien el ch-root
#proc_root=$(ls -id / | cut -d " " -f1)
#[ $proc_root == "2" ] && echo "Debe hacerse en chroot / must be chroot" \
#&& exit 1

cat > /etc/fstab <<EOF
# file-system mount-point type options dump fsck-order

${particion} / ext4 defaults 1 1
#/dev/sda2 swap swap pri=1 0 0
proc /proc proc nosuid,noexec,nodev 0 0
sysfs /sys sysfs nosuid,noexec,nodev 0 0
devpts /dev/pts devpts gid=5,mode=620 0 0
tmpfs /run tmpfs defaults 0 0
devtmpfs /dev devtmpfs mode=0755,nosuid 0 0
EOF
cat /etc/fstab

cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:/bin:/bin/false
daemon:x:2:6:/sbin:/bin/false
messagebus:x:27:27:D-Bus Message Daemon User:/dev/null:/bin/false
nobody:x:65534:65533:Unprivileged User:/dev/null:/bin/false
EOF
cat /etc/passwd
#control_flujo


cat > /etc/group << "EOF"
root:x:0:
bin:x:1:
sys:x:2:
kmem:x:3:
tty:x:5:
tape:x:4:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:27:
mail:x:30:
wheel:x:39:
nogroup:x:65533:
EOF
cat /etc/group
#control_flujo

cat > /etc/hostname << EOF
$hostname_TGT
EOF
echo /etc/hostname

touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

cat > /tools/etc/ld-musl-${CLFS_ARCH_m}.path << "EOF"
/tools/lib
/tools/lib64
/lib
/usr/lib
EOF
cat /tools/etc/ld-musl-${CLFS_ARCH_m}.path

cat > /etc/sysconfig/modules << "EOF"
#efivarfs
iptable_nat
ipt_MASQUERADE
nf_log_arp
nf_log_common
nf_log_ipv4
nf_log_ipv6
nf_nat
nf_nat_ftp
nf_nat_ipv4
nf_nat_irc
nf_nat_sip
#x86_pkg_temp_thermal
xt_addrtype
xt_LOG
xt_mark
xt_nat
EOF
cat /etc/sysconfig/modules

cat > /etc/shells << "EOF"
/bin/sh
/bin/bash
EOF
cat /etc/shells

cat > /etc/vimrc << "EOF"
let skip_defaults_vim=1
set nocompatible
set backspace=2
set mouse=
syntax on

if (&term == "xterm") || (&term == "putty")
set background=dark
endif

set spelllang=es,en
map <f12> :set spell!<cr>
"this is to activate/deactivate the spelling

set tw=75 et nowritebackup
EOF
cat /etc/vimrc

cat > /etc/inputrc << "EOF"
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line
EOF
cat /etc/inputrc

cat > /etc/sysconfig/udev_retry << EOF
#/etc/sysconfig/udev_retry
rtc
EOF
echo /etc/sysconfig/udev_retry

mkdir -pv /usr/etc
cat > /usr/etc/qirc << EOF
#
# qirc: Runtime configuration file for Qi.
#
# Qi looks for this file in:
#     1 - $HOME/.qirc
#     2 - ${sysconfdir}/qirc
#
# File syntax considerations:
#
# * Variables are declared as 'name=value'.
# * Declaration of values should only take one line, no line break.
# * Assignments like 'name=$var' are only interpreted as literal.
#
# Uncomment a variable to set a new value other than default.
# For more information, type: info qi 'the qirc file'

#### FIRST SECTION: package settings

# Package installation directory
#packagedir=/usr/pkgs

# Target directory where the links will be made
targetdir=/

# List of package names to be installed rather than being updated.
#
# It is suggested that such packages are only those limited in name,
# for e.g. incoming package names such as: "perl.tlz" instead of
# "perl-<version>-<arch>+<release>.tlz".  This to try to perform an
# atomic update instead of pruning the links through graft(1).
# 
#blacklist="perl graft tarlz plzip musl glibc"


#### SECOND SECTION: build settings

# C compiler flags
#QICFLAGS=-g0 -Os

# C++ compiler flags
#QICXXFLAGS=-g0 -Os

# Linker flags
#QILDFLAGS=-s

# Temporary directory for sources during compilation
#TMPDIR=/usr/src/qi/build

# Architecture name to use by default (autodetected)
#arch=

# Parallel jobs for the compiler
#jobs=1

# Output directory where the packages are written
outdir=$croothome_tgt/$carpeta8

# Working tree where archives, patches, and recipes are expected
#worktree=/usr/src/qi

# Where to find the sources (tarballs)
tardir=${fuentes_target}

# General network downloader
#netget=wget -c -w1 -t3 --no-check-certificate

# Network tool for the RSYNC protocol
#rsync=rsync -v -a -L -z -i --progress

# Arguments for 'configure'
configure_args=--prefix=/tools --libexecdir=/tools/libexec --bindir=/tools/bin --sbindir=/tools/sbin --sysconfdir=/tools/etc --localstatedir=/tools/var

# Prefixes for documentation
infodir=/tools/share/info
mandir=/tools/share/man
docdir=/tools/share/doc
EOF
echo /usr/etc/qirc

cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# End /etc/syslog.conf
EOF
echo /etc/syslog.conf

cat > /etc/issue << "EOF"


\e{bold} _     _                 _\e{reset}
\e{bold}| |__ (_)___  ___  _ __ | |_ ___\e{reset}
\e{bold}| '_ \\| / __|/ _ \\| '_ \\| __/ _ \\\e{reset}
\e{bold}| |_) | \\__ \\ (_) | | | | ||  __/\e{reset}
\e{bold}|_.__/|_|___/\\___/|_| |_|\\__\\___|\e{reset}

\e{bold}  From Cantabria to California!\e{reset}
                                 
Bisonte is the best Operating System out there right now!



EOF
echo /etc/issue

cat > /etc/profile << "EOF"

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin
export PATH

export LANG=es_ES.ISO-8859-15@euro
#export LANG=es_ES.UTF-8

alias ls='ls --color'

#Esto colorea el promt. Rojo para el root, verde para el resto de los usuarios.
NORMAL="\[\e[0m\]"
GREEN="\[\e[1;32m\]"
RED="\[\e[1;31m\]"

if [[ $EUID == 0 ]]; then
  PS1="$RED\u [ $NORMAL\W$RED ]# $NORMAL"
else
  PS1="$GREEN\u [ $NORMAL\W$GREEN ]$ $NORMAL"
fi

unset NORMAL GREEN RED

# Esto es para que funcione GPG con Mutt.
GPG_TTY=$(tty)
export GPG_TTY

TZ="Europe/Madrid"
export TZ

EOF
echo /etc/profile

cat > /etc/sysconfig/mouse << EOF
MDEVICE="/dev/input/mice"
PROTOCOL="imps2"
GPMOPTS=""
EOF
echo /etc/sysconfig/mouse

cat > /etc/resolv.conf << EOF
nameserver 62.81.16.213
nameserver 62.81.29.254
EOF
echo /etc/resolv.conf

cat > /etc/wpa_supplicant/wpa_supplicant-wlan0.conf << EOF
#Seguir instrucciones para crear el archivo con wpa_passphrase

EOF
echo /etc/wpa_supplicant/wpa_supplicant-wlan0.conf

cat > /etc/sysconfig/console << EOF
UNICODE="1"
KEYMAP="qwerty/es"
KEYMAP_CORRECTIONS="euro"
#LEGACY_CHARSET="ISO-8859-15"
FONT="lat0-16 -m 8859-15"
EOF
echo /etc/sysconfig/console

cat > /etc/sysconfig/ifconfig.ether<< EOF
ONBOOT=yes
IFACE=$IFACE_Target
SERVICE=ipv4-static
IP=$IP_Target
GATEWAY=$GATEWAY_Target
PREFIX=24
BROADCAST=192.168.1.255
EOF
echo /etc/sysconfig/ifconfig.ether
