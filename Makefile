# Environment setup: https://mongoose.ws/documentation/tutorials/tools/

CFLAGS  = -W -Wall -Wextra -Werror -Wundef -Wshadow -Wdouble-promotion
CFLAGS += -Wformat-truncation -fno-common -Wconversion -Wno-sign-conversion
CFLAGS += -g3 -Os -ffunction-sections -fdata-sections
CFLAGS += -Wno-cast-function-type
CFLAGS += -I. -Imongoose/ -Icmsis_core/ -Icmsis_h755/
CFLAGS += -mcpu=cortex-m7 -mthumb -mfloat-abi=hard -mfpu=fpv5-d16 $(CFLAGS_EXTRA)
LDFLAGS ?= -Tlink.ld -nostdlib -nostartfiles --specs nosys.specs -lc -lgcc -Wl,--gc-sections -Wl,-Map=$@.map

SOURCES = main.c hal.c $(wildcard mongoose/*.c)
SOURCES += cmsis_h755/startup_stm32h755xx.s

all build: ui-build ui-pack firmware.bin

ui-build:
	@echo "Building UI..."
	cd ui && yarn install && yarn build

ui-pack: ui-build
	@echo "Packing UI files into embedded filesystem..."
	cc -o pack tools/pack.c
	mkdir -p web_root
	cp -r ui/build/* web_root/
	find web_root -type f -exec gzip -9 {} \;
	find web_root -type f | xargs ./pack -s / > mongoose/packed_fs.c
	rm -f pack
	rm -rf web_root

firmware.bin: firmware.elf
	arm-none-eabi-objcopy -O binary $< $@
	arm-none-eabi-size --format=berkeley $<

firmware.elf: $(SOURCES) $(wildcard *.h) link.ld Makefile
	arm-none-eabi-gcc $(SOURCES) $(CFLAGS) $(LDFLAGS) -o $@

flash: firmware.bin
	STM32_Programmer_CLI -c port=swd -w $< 0x8000000 -hardRst

clean:
	rm -rf firmware.*
	rm -f pack
	rm -f mongoose/packed_fs.c
	rm -rf web_root
