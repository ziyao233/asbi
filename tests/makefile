#	asbi: test kernel
#	File: /tests/makefile
#	This file is distributed under MIT License.
#	Copyright (c) 2023 Yao Zi. All rights reserved.

CROSS_COMPILE	?= riscv-none-elf-
CCAS		:= $(CROSS_COMPILE)gcc
CC		:= $(CROSS_COMPILE)gcc
LD		:= $(CROSS_COMPILE)ld

CFLAGS		:= -march=rv64gc -mabi=lp64d -g -O0 -pedantic -Wextra	\
		   -nostdinc -nostdlib -mcmodel=medany -Wall -std=gnu99
CCASFLAGS	:= $(CFLAGS)
LDFLAGS		:= -T link.ld

OBJS		:= start.o main.o sbi.o

default: test.elf

test.elf: $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o test.elf

%.o: %.S
	$(CCAS) $< -c -o $@ $(CCASFLAGS)

clean:
	-rm $(OBJS)

distclean: clean
	-rm test.elf

test: test.elf
	qemu-system-riscv64 -kernel test.elf -machine virt	\
			    -nographic

debug: test.elf
	qemu-system-riscv64 -kernel test.elf -machine virt	\
			    -nographic -S -s
