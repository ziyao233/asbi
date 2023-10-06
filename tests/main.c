/*
 *	asbi: test kernel
 *	File: /tests/main.c
 *	This file is distirubted under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

#include"sbi.h"

void
_putchar(int c)
{
	sbi_call1(0x4442434e, 2, c);
	return;
}

int
main(void)
{
	const char *msg = "The quick brown fox jumps over the lazy dog.\n";
	for (const char *p = msg; *p; p++)
		_putchar(*p);
	while (1) {
		asm volatile("wfi");
	}
}
