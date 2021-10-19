# Simple instruction

1. Clone repo
```sh
$ git clone https://github.com/MrZloHex/troubleshooting-stm32f1.git
```

2. Change working directory
```sh
$ cd troublshooting-stm32f1
```

3. Install all needful packages
```sh
$ ./install.sh
```

4. Run program for testing
```sh
$ ./test_stm32.sh [DEVICE ID]
```

5. Copy folder for trasmiting to us

# Results

In repo directory after running tests, will be created subdirectory `results` with one more directory with name `device_<ID>`, where `<ID>` is a number which you specifed by passing it at running tests.</br></br>
E.g.: running like this
`
$ /test-stm32.sh 34
`
would create directory with name `device_34`.
</br>


Directory `device_<ID>` will have next content:
```bash
.
├── board_info
├── flash.dump
├── last_state
│   ├── last_flash.dump
│   ├── last_sram.dump
│   └── statement
├── sram.dump
├── test_mem
│   ├── flash_gdb
│   └── test_sram.dump
└── test_output
```

## Purpose of file and directories

1. __board_info__ has main info about stm32 on your board like:
 - Chip ID
 - Volume of SRAM and its start address
 - Type of flash in stm32

2. __last_state__ it's a directory with statement of:
 - _flash_ of stm32 which is dumped to `last_flash.dump`
 - _sram_ of stm32 which is dumped to `last_sram.dump`
 - _registers_ of stm32 which values are dumped to `statement`

All this information is parsed from stm32 without rewriting and rebooting it. This can help to detect what happened with proccesor.



# Complex instruction
