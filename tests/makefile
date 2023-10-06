#	asbi: test kernel
#	File: /tests/makefile
#	This file is distributed under MIT License.
#	Copyright (c) 2023 Yao Zi. All rights reserved.

CROSS_COMPILE	?= riscv-none-elf-
CCAS		:= $(CROSS_COMPILE)gcc
CC		:= $(CROSS_COMPILE)gcc
LD		:= $(CROSS_COMPILE)ld

CFLAGS		:= -march=rv64gc -mabi=lp64d -g -O0 -pedantic -Wextra	\
		   -nostdinc -nostdlib
CCASFLAGS	:= $(CFLAGS)
LDFLAGS		:= -T link.ld

OBJS		:= start.o

default: test.elf

test.elf: $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o test.elf

%.o: %.S
	$(CCAS) $< -c -o $@ $(CCASFLAGS)

clean:
	-rm $(OBJS)

distclean: clean
	-rm test.elf