
######################
#  Made by MrZloHex  #
#     16.09.2021     #
######################

TARGET = main

LD_SCRIPT = stm32f1.ld
MCU_SPEC  = cortex-m3

CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy
OD = arm-none-eabi-objdump
OS = arm-none-eabi-size

AS_FLAGS = -c -O0 -mcpu=$(MCU_SPEC) -mthumb -Wall -g

LSCRIPT = ./$(LD_SCRIPT)
L_FLAGS = -mcpu=$(MCU_SPEC) -mthumb -Wall -nostdlib -lgcc -T$(LSCRIPT)

SCR_FOL = ./src/

AS_SRC = main.S

OBJS = $(AS_SRC:.S=.o)

.PHONY: all
all: $(TARGET).bin

%.o: %.S
	$(CC) -x assembler-with-cpp $(AS_FLAGS) $< -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) $(INCLUDE) $< -o $@

$(TARGET).elf: $(OBJS)
	$(CC) $^ $(L_FLAGS) -o $@

$(TARGET).bin: $(TARGET).elf
	$(OC) -S -O binary $< $@
	$(OS) $<


.PHONY: clean
clean:
	rm -f $(OBJS)
	rm -f $(TARGET).elf

