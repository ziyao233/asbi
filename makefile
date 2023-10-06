#	asbi
#	File: /makefile
#	This file is distributed under MIT License.
#	Copyright (c) 2023 Yao Zi. All rights reserved.

ifeq (RELEASE, 1)
	ASFLAGS_DEBUG	:= -O2
else
	ASFLAGS_DEBUG	:= -g -O0
endif

CROSS_COMPILE	?= riscv-none-elf-
CCAS		:= $(CROSS_COMPILE)gcc
LD		:= $(CROSS_COMPILE)ld
OBJCOPY		:= $(CROSS_COMPILE)objcopy

BOARD		?= virt
BOARDP		= boards/$(BOARD)

O_JUMP_ADDR	?= 0x80200000
OPTIONS		:= -DO_JUMP_ADDR=$(O_JUMP_ADDR)

CCASFLAGS	:= $(ALFLAGS_DEBUG) -mcmodel=medany -march=rv64gc	\
		   -mabi=lp64d -g -nostdlib -nostdinc -I$(BOARDP)	\
		   $(OPTIONS)
LDFLAGS		:= -T $(BOARDP)/link.ld

SBI_BASE	:=
include src/makefile
SBI_BASE	+= $(addprefix src/,$(objs))
objs		:=

include $(BOARDP)/makefile
SBI_BASE	+= $(addprefix $(BOARDP)/,$(objs))
objs		:=

SBI_JUMP_O	:= $(BOARDP)/sbi_jump.o
SBI_JUMP	:= asbi-jump.elf
SBI_JUMP_BIN	:= asbi-jump.bin

default: build

build: $(SBI_JUMP_BIN)

$(SBI_JUMP_BIN): $(SBI_JUMP)
	$(OBJCOPY) -j .text -j .data -O binary $(SBI_JUMP) $(SBI_JUMP_BIN)

$(SBI_JUMP): $(SBI_BASE) $(SBI_JUMP_O)
	$(LD) $(LDFLAGS) $(SBI_BASE) $(SBI_JUMP_O) -o $(SBI_JUMP)

clean:
	-rm $(SBI_BASE) $(SBI_JUMP_O)

distclean: clean
	-rm $(SBI_JUMP) $(SBI_JUMP_BIN)

%.o: %.S
	$(CCAS) $< -c $(CCASFLAGS) -o $@

test: build buildtest
	qemu-system-riscv64 -machine virt -nographic			\
			    -bios $(SBI_JUMP_BIN) -kernel tests/test.elf

debug: build buildtest
	qemu-system-riscv64 -machine virt -nographic			\
			    -bios $(SBI_JUMP_BIN) -kernel tests/test.elf\
			    -S -s

buildtest:
	$(MAKE) -C tests
