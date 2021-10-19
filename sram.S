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
    LDR  r0, =_estack
	MOV  sp, r0
	LDR r1, =0xDEADBEAF
    LDR r2, =0x20000000
    LDR r3, =0x2001000F
    loop:
	PUSH {r1}
        CMP r2, sp
        BEQ quit
        B loop
    quit:
        B quit
.size reset_handler, .-reset_handler
