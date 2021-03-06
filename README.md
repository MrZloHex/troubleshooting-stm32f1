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

## Order of tests

 1. Dumping last statement without any changing of state of stm32
 2. Main test with checking operability of:
   - Main node of instruction execution
   - Writting/reading in/from `sram`
   - Work this ALU and _stack_ operations
 3. Checking all `sram` addresses for broken segments

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

3. __test_output__ has debug information after running main test, so firstly check this, if it is like is needful - all is ok with stm32.</br>
Last dump of registers should be like that and no other way:
```
r0             0x8000008           134217736
r1             0xbeafdead          3199196845
r2             0x4608bf00          1174978304
r3             0x5                 5
r4             0x0                 0
r5             0x0                 0
r6             0x0                 0
r7             0xdeadbeef          3735928559
r8             0x0                 0
r9             0x0                 0
r10            0x0                 0
r11            0x0                 0
r12            0x0                 0
sp             0x20010000          0x20010000
lr             0x0                 0
pc             0x800006a           0x800006a <reset_handler+98>
```
For a full see [this](#test-output)

4. __flash.dump__ and __sram.dump__ is memory dumps after main test. You can check to check if it all like it should be (opcodes in `flash` and state of stack in `sram`)

# Complex instruction

## Test Output


