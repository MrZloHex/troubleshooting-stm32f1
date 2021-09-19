#!/bin/bash

######################
#  Made by MrZloHex  #
#     16.09.2021     #
######################

ID=0

OK='\033[0;32m'
ERR='\033[0;31m'
NOR='\033[0m'

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

	if [ "$BUILD_STATUS" -eq 0 ]
	then
		echo >&6 -e "\t\t\t\t\t\t${OK}OK${NOR}"
	else
		echo >&6 -e "\t\t\t\t\t${ERR}ERROR${NOR}"
		echo >&6 "FAILED TO BUILD"
		exit 255
	fi
}

write_board_info() {
	echo "Chip ID: $1" > ./results/device_$ID/board_info
	echo "SRAM: $2" >> ./results/device_$ID/board_info
	echo "FLASH: $3" >> ./results/device_$ID/board_info
}

check_for_board() {
	echo >&6 -n "Connecting to STM32F1"
	load &
	LOAD_PID=$!

	st-util > trace 2>&1 &
	PID=$!
	sleep 5
	kill $PID

	kill $LOAD_PID
	
	INFO=$(cat trace | grep RAM)
	rm trace
	if [ -z $INFO ]
	then
		echo >&6 -e "\t\t\t\t\t${ERR}ERROR${NOR}"
		echo >&6 "Can't find device"
		exit 255
	fi
	IFS=":"
	read -a SPLIT_INFO <<< "$INFO"
	INFO=${SPLIT_INFO[4]}
	
	IFS=","
	read -a MEM <<< "$INFO"
	RAM=$(echo ${MEM[0]} | sed -re 's/^.{1}//; s/KiB.*/KiB/')
	FLASH=$(echo ${MEM[1]} | sed -re 's/^.{1}//; s/KiB.*/KiB/')

	CHIP_ID=$(st-info --chipid)

	write_board_info $CHIP_ID $RAM $FLASH

	echo >&6 -e "\t\t\t\t\t${OK}OK${NOR}"
}

get_last_statement() {
	echo >&6 -n "Collecting last statement"

	load &
	LOAD_PID=$!

	st-util &
	STLINK_PID=$!

	arm-none-eabi-gdb --command=gdb/last_state.gdb > ./results/device_$ID/last_state/statement
	GDB=$?

	kill $LOAD_PID
	if [ $GDB -ne 0 ]
	then
		echo >&6 -e "\t\t\t\t\t${ERR}ERROR${NOR}"
		echo >&6 "Failed to get last statement"
		exit 255
	fi

	mv last_flash.dump ./results/device_$ID/last_state/
	FL=$?
	mv last_sram.dump ./results/device_$ID/last_state/
	SR=$?

	sleep 1

	kill $PID
	if [ $FL -ne 0 ] && [ $SR -ne 0 ]
	then
		echo >&6 -e "\t\t\t\t\t${ERR}ERROR${NOR}"
		echo >&6 "Failed to collect data"
		exit 255
	fi

	echo >&6 -e "\t\t\t${OK}OK${NOR}"

	kill $STLINK_PID
}

debug() {
	echo >&6 -n "Setting ST-LINK server"
	
	load &
	LOAD_PID=$!

	st-util &
	STLINK_PID=$!

	sleep 2
	kill $LOAD_PID
	echo >&6 -e "\t\t\t\t\t${OK}OK${NOR}"


	echo >&6 -n "Testing device"

	load &
	LOAD_PID=$!

	arm-none-eabi-gdb --command=gdb/test_commands.gdb main.elf > ./results/device_$ID/test_output
	GDB=$?

	kill $LOAD_PID
	if [ $GDB -ne 0 ]
	then
		echo >&6 -e "\t\t\t\t\t${ERR}ERROR${NOR}"
		echo >&6 "Failed to debug device"
		exit 255
	fi
	
	
	echo >&6 -e "\t\t\t\t${OK}OK${NOR}"

	kill $STLINK_PID
}

copy_dumps() {
	echo >&6 -n "Collecting debug info"

	load &
	PID=$!

	mv flash.dump ./results/device_$ID/
	FL=$?
	mv sram.dump ./results/device_$ID/
	SR=$?

	sleep 1

	kill $PID
	if [ $FL -ne 0 ] && [ $SR -ne 0 ]
	then
		echo >&6 -e "\t\t\t\t\t${ERR}ERROR${NOR}"
		echo >&6 "Info unavailable"
		exit 255
	fi

	echo >&6 -e "\t\t\t\t\t${OK}OK${NOR}"
}

main() {
	exec 6>&1 > /dev/null
	exec 2> /dev/null

	ID=$1
	mkdir "./results/device_$ID"
	mkdir "./results/device_$ID/last_state"


	compile
	check_for_board
	get_last_statement
	debug
	copy_dumps

	exit 0
}

main "$@"
