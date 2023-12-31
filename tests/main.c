/*
 *	asbi: test kernel
 *	File: /tests/main.c
 *	This file is distirubted under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

#include"sbi.h"
#include"tests.h"

void
_putchar(int c)
{
	sbi_call1(0x4442434e, 2, c);
	return;
}

int
main(void)
{
	test_base();
	test_console();
	while (1) {
		asm volatile("wfi");
	}
}
