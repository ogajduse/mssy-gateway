# Name: Makefile
# Author: <insert your name here>
# Copyright: <insert your copyright message here>
# License: <insert your license reference here>

# DEVICE ....... The AVR device you compile for
# CLOCK ........ Target AVR clock rate in Hertz
# OBJECTS ...... The object files created from your source files. This list is
#                usually the same as the list of source files with suffix ".o".
# PROGRAMMER ... Options to avrdude which define the hardware you use for
#                uploading to the AVR and the interface where this hardware
#                is connected.
# FUSES ........ Parameters for avrdude to flash the fuses appropriately.

DEVICE     = atmega256rfr2
CLOCK      = 8000000
PROGRAMMER = -c xplainedpro -P usb
OBJECTS    = src/main.o \
src/common/command_context.o \
src/common/uart.o \
$(STACK_PATH)/hal/atmega256rfr2/src/hal.o \
$(STACK_PATH)/hal/atmega256rfr2/src/halTimer.o \
$(STACK_PATH)/phy/atmegarfr2/src/phy.o \
$(STACK_PATH)/nwk/src/nwk.o \
$(STACK_PATH)/nwk/src/nwkDataReq.o \
$(STACK_PATH)/nwk/src/nwkSecurity.o \
$(STACK_PATH)/nwk/src/nwkFrame.o \
$(STACK_PATH)/nwk/src/nwkGroup.o \
$(STACK_PATH)/nwk/src/nwkRoute.o \
$(STACK_PATH)/nwk/src/nwkRouteDiscovery.o \
$(STACK_PATH)/nwk/src/nwkRx.o \
$(STACK_PATH)/nwk/src/nwkTx.o \
$(STACK_PATH)/sys/src/sys.o \
$(STACK_PATH)/sys/src/sysTimer.o \
$(STACK_PATH)/sys/src/sysEncrypt.o

INCLUDES = -Isrc/common/ \
-I$(STACK_PATH)/hal/atmega256rfr2/inc \
-I$(STACK_PATH)/phy/atmegarfr2/inc \
-I$(STACK_PATH)/nwk/inc \
-I$(STACK_PATH)/sys/inc \
-I$(STACK_PATH)/hal/drivers/atmega256rfr2

FUSES      = -U lfuse:w:0xc2:m -U hfuse:w:0x95:m -U efuse:w:0xfe:m


######################################################################
######################################################################

# Tune the lines below only if you know what you are doing:

AVRDUDE = avrdude $(PROGRAMMER) -p $(DEVICE)
COMPILE = avr-gcc $(INCLUDES) -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE) \
-DPHY_ATMEGARFR2 -DHAL_ATMEGA256RFR2 -DPLATFORM_XPLAINED_PRO_ATMEGA256RFR2

# symbolic targets:
all:	main.hex

.c.o:
	$(COMPILE) -c $< -o $@

.S.o:
	$(COMPILE) -x assembler-with-cpp -c $< -o $@
# "-x assembler-with-cpp" should not be necessary since this is the default
# file type for the .S (with capital S) extension. However, upper case
# characters are not always preserved on Windows. To ensure WinAVR
# compatibility define the file type manually.

.c.s:
	$(COMPILE) -S $< -o $@

flash:	all
	$(AVRDUDE) -U flash:w:main.hex:i

fuse:
	$(AVRDUDE) $(FUSES)

install: flash fuse

# if you use a bootloader, change the command below appropriately:
load: all
	bootloadHID main.hex

clean:
	rm -f main.hex main.elf $(OBJECTS)

# file targets:
main.elf: $(OBJECTS)
	$(COMPILE) -o main.elf $(OBJECTS)

main.hex: main.elf
	rm -f main.hex
	avr-objcopy -j .text -j .data -O ihex main.elf main.hex
# If you have an EEPROM section, you must also create a hex file for the
# EEPROM and add it to the "flash" target.

# Targets for code debugging and analysis:
disasm:	main.elf
	avr-objdump -d main.elf

cpp:
	$(COMPILE) -E main.c
