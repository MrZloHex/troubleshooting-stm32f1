#!/bin/bash

######################
#  Made by MrZloHex  #
#     16.09.2021     #
######################

PACKAGE_LIST_ARCH="python3 make git arm-none-eabi-gcc arm-none-eabi-gdb arm-none-eabi-binutils stlink openocd"
PACKAGE_LIST_FEDORA="python3 make git arm-none-eabi-gcc-cs arm-none-eabi-gdb-arm arm-none-eabi-binutils-cs stlink openocd"
PACKAGE_LIST_DEB=(python3 make git gcc-arm-none-eabi binutils-arm-none-eabi gdb-multiarch stlink-tools openocd)

get_distro_name() {
	DISTRO=$( cat /etc/os-release | tr [:upper:] [:lower:] | grep -Poi '(debian|ubuntu|red hat|centos|manjaro|fedora)' | uniq )
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
		*) echo "UNKNOWN PACKAGE MANAGER"
			   exit
			;;
	esac
}

install_on_ubuntu() {
	for package in ${PACKAGE_LIST_DEB[@]}
	do
		sudo $PACK_MAN install $package
	done
	sudo ln -s /usr/bin/gdb-multiarch /usr/bin/arm-none-eabi-gdb
}
	

install_packages() {
	case $PACK_MAN in
		"pacman") $(sudo $PACK_MAN -S $PACKAGE_LIST_ARCH)
			;;
		"dnf" | "yum" ) $(sudo $PACK_MAN copr enable sailer/axide)
			$(sudo $PACK_MAN install $PACKAGE_LIST_FEDORA)
			;;
		"apt") install_on_ubuntu
			;;
	esac
}

main() {
	get_distro_name
	detect_package_manager
	install_packages
}

main "$@"
