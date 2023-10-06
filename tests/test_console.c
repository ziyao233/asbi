/*
 *	asbi: test kernel
 *	File: /tests/test_console.c
 *	This file is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

#include<stddef.h>

#include"tests.h"
#include"sbi.h"
#include"tools.h"

static void
test_write_byte(void)
{
	const char *msg = "The quick brown fox jumps over the lazy dog\n";
	for (const char *p = msg; *p; p++)
		sbi_call1(0x4442434e, 2, *p);
	return;
}

static void
test_write_bytes(void)
{
	const char *msg = "I can eat glass. It doesn't hurt me.\n";
	size_t len = strlen(msg);
	for (unsigned int i = 0; i < len;) {
		Sbi_Return ret = sbi_call3(0x4442434e, 0,
					   len - i, msg + i, 0);
		i += ret.value;
	}
	return;
}

void
test_console(void)
{
	if (!sbi_probe(0x4442434e))
		return;
	test_write_byte();
	test_write_bytes();
	return;
}
