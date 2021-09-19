target extended-remote :4242

info registers
dump memory last_flash.dump 0x08000000 0x08080000
dump memory last_sram.dump 0x20000000 0x20010000

quit