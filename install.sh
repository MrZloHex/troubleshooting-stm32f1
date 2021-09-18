#!/bin/bash

######################
#  Made by MrZloHex  #
#     16.09.2021     #
######################

PACKAGE_LIST=(python3 make git gcc-arm-none-eabi binutils-arm-none-eabi gdb-multiarch stlink-tools openocd)



install_packages() {
	for package in ${PACKAGE_LIST_DEB[@]}
	do
		sudo $PACK_MAN install $package
	done
	sudo ln -s /usr/bin/gdb-multiarch /usr/bin/arm-none-eabi-gdb
}


main() {
	install_packages
}

main "$@"
