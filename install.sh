#!/bin/bash

######################
#  Made by MrZloHex  #
#     16.09.2021     #
######################

PACKAGE_LIST_ARCH="python3 make git arm-none-eabi-gcc arm-none-eabi-gdb arm-none-eabi-binutils stlink openocd"
PACKAGE_LIST_FEDORA="python3 make git arm-none-eabi-gcc-cs arm-none-eabi-gdb-arm arm-none-eabi-binutils-cs stlink openocd"

get_distro_name() {
	DISTRO=$( cat /etc/*-release | tr [:upper:] [:lower:] | grep -Poi '(debian|ubuntu|red hat|centos|manjaro|fedora)' | uniq )
	if [ -z $DISTRO ]; then
   		DISTRO='unknown'
	fi
}

detect_package_manager() {
	case $DISTRO in
		"manjaro") PACK_MAN="pacman"
			;;
		"debian") PACK_MAN="apt"
			;;
		"ubuntu") PACK_MAN="apt"
			;;
		"centos") PACK_MAN="yum"
			;;
		"fedora") PACK_MAN="dnf"
			;;
		"opensuse") PACK_MAN="zypper"
			;;
		"unknown") echo "UNKNOWN PACKAGE MANAGER"
			   exit
			;;
	esac
}

install_packages() {
	case $PACK_MAN in
		"pacman") $(sudo $PACK_MAN -S $PACKAGE_LIST_ARCH)
			;;
		"dnf") $(sudo $PACK_MAN copr enable sailer/axide)
			$(sudo $PACK_MAN install $PACKAGE_LIST_FEDORA)
			;;

	esac
}

main() {
	get_distro_name
	detect_package_manager
	install_packages
}

main "$@"
