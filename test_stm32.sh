#!/bin/bash

######################
#  Made by MrZloHex  #
#     16.09.2021     #
######################

ID=0

make_elf() {
	make clean
	make
}

startup_stlink() {
	st-util
}

debug() {
	startup_stlink &
	STLINK_PID=$!

	arm-none-eabi-gdb --command=gdb.commands main.elf > ./device_$ID/test_output
	
	kill STLINK_PID
}

copy_dumps() {
	mv flash.dump ./device_$ID/
	mv sram.dump ./device_$ID/
}

main() {
	make_elf
	ID=$1
	mkdir "device_$ID"
	debug
	copy_dumps
}

main "$@"
