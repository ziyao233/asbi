/*
 *	asbi: test kernel
 *	File: /tests/test_console.c
 *	This file is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

#include"tests.h"
#include"sbi.h"

static void
test_write_byte(void)
{
	const char *msg = "The quick brown fox jumps over the lazy dog\n";
	for (const char *p = msg; *p; p++)
		sbi_call1(0x4442434e, 2, *p);
	return;
}

void
test_console(void)
{
	if (!sbi_probe(0x4442434e))
		return;
	test_write_byte();
	return;
}
