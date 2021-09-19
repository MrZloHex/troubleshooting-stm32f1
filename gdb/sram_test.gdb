target extended-remote :4242
load
b quit
c

info registers
dump memory test_sram.dump 0x20000000 0x20010000

quit