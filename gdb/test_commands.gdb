target extended-remote :4242
load
break reset_reg
break start
break push_stack
break read_stack
break pop_stack
break loop

info registers
continue
info registers
continue
info registers
continue
info registers
continue
info registers
continue
info registers
continue
info registers
continue
info registers
continue
continue
continue
continue
info registers

dump memory sram.dump 0x20000000 0x20010000
dump memory flash.dump 0x08000000 0x08080000

quit
