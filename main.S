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
	NOP
	MOV r0, r1
	NOP
	reset_reg:
		MOV r0, #0
		MOV r1, #0
		MOV r2, #0
		MOV r3, #0
		MOV r4, #0
		MOV r5, #0
		MOV r6, #0
		MOV r7, #0
		MOV r8, #0
		MOV r9, #0
		MOV r10, #0
		MOV r11, #0
		MOV r12, #0
		MOV r13, r0
		MOV r14, r0
		MSR APSR, r0
		MSR EPSR, r0
		MSR IPSR, r0
	start:
	// Set stack pointer
		LDR  r0, =_estack
		MOV  sp, r0
		LDR r1, =0xBEAFDEAD
		LDR r0, =0x08000008
	
	push_stack:
		PUSH {r1}
		MOV r1, #10
	read_stack:
		LDR r2, [r0]
	pop_stack:
		POP {r1}

	LDR  r7, =0xDEADBEEF
	MOV r3, #0
	loop:
		ADD r3, #1
		MRS r10, EPSR
		MRS r11, IPSR
		MRS r12, APSR
		B loop

.size reset_handler, .-reset_handler
