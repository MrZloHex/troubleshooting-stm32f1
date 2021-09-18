#!/bin/bash

######################
#  Made by MrZloHex  #
#     16.09.2021     #
######################

ID=0

load() {
	while [ 1 ]
	do
		echo >&6 -ne "."
		sleep 0.5
	done
}

compile() {
	echo >&6 -n "Building firmware"

	load &
	PID=$!

	make clean
	make
	BUILD_STATUS=$?
	
	kill $PID

	echo >&6
	if [ "$BUILD_STATUS" -eq 0 ]
	then
		echo >&6 "OK"
	else
		echo >&6 "FAILED TO BUILD"
		exit 255
	fi
}

write_board_info() {
	echo "Chip ID: $1" > ./device_$ID/board_info
	echo "SRAM: $2" >> ./device_$ID/board_info
	echo "FLASH: $3" >> ./device_$ID/board_info
}

check_for_board() {
	echo >&6 -n "Searching for STM32F1"
	load &
	LOAD_PID=$!

	st-util > ./device_$ID/trace 2>&1 &
	PID=$!
	sleep 10
	kill $PID
	
	echo >&6

	kill $LOAD_PID
	
	INFO=$(cat ./device_$ID/trace | grep RAM)
	if [ -z $INFO ]
	then
		echo >&6 "Can't find device"
		exit 255
	fi
	IFS=":"
	read -a SPLIT_INFO <<< "$INFO"
	INFO=${SPLIT_INFO[4]}
	echo >&6 $INFO
	
	IFS=","
	read -a MEM <<< "$INFO"
	RAM=${MEM[0]}
	FLASH=${MEM[1]}

	CHIP_ID=$(st-info --chipid)
	echo >&6 $CHIP_ID

	write_board_info $CHIP_ID $RAM $FLASH
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
	exec 6>&1 > /dev/null
	exec 2> /dev/null

	ID=$1
	mkdir "device_$ID"


	compile
	check_for_board
	#debug
	#copy_dumps
}

main "$@"
