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

	char t[16];
	for (int i = 0; i < 5;) {
		Sbi_Return ret = sbi_call3(0x4442434e, 1, 15 - i, t + i, 0);
		i += ret.value;
	}
	for (int i = 0; i < 5; i++)
		_putchar(t[i]);
	while (1) {
		asm volatile("wfi");
	}
}
