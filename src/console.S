/*
 *	asbi
 *	File: /src/console.S
 *	This is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi, All rights reserved.
 */

#include<sbi.h>

	.global	sbi_console

sbi_console:
	li		t0,		2	// SBI_DEBUG_CONSOLE_WRITE_BYTE
	beq		t0,		a6,		write_byte
	li		a0,		SBI_ERR_NOT_SUPPORTED
	jalr		s11

write_byte:
	call		board_console_putchar_sync
	mv		a0,		zero
	mv		a1,		zero
	jalr		s11
