.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.global vtable
.global reset_handler


// Vector table
.type vtable, %object
vtable:
    .word _estack
    .word reset_handler
.size vtable, .-vtable



.type reset_handler, %function
reset_handler:
    // Set stack pointer
    LDR  r0, =_estack
    MOV  sp, r0

    LDR  r7, =0xDEADBEEF
    MOV r0, #0
    loop:
        ADD r0, #1
        B loop

.size reset_handler, .-reset_handler