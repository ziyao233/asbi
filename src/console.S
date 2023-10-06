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
	li		t0,		1	// SBI_DEBUG_CONSOLE_READ
	beq		t0,		a6,		read_bytes
	li		a0,		SBI_ERR_NOT_SUPPORTED
	jalr		s11

write_byte:
	call		board_console_putchar_sync
	mv		a0,		zero
	mv		a1,		zero
	jalr		s11

read_bytes:
	mv		s0,		a0
	mv		s1,		a1
	mv		s2,		a0
.doRead:
	beqz		s0,		.doneRead
	call		board_console_getchar_async
	srli		t0,		a0,		8
	bnez		t0,		.doneRead
	sb		a0,		0(s1)
	addi		s1,		s1,		1
	addi		s0,		s0,		-1
	j		.doRead
.doneRead:
	sub		a1,		s2,		s0
	mv		a0,		zero
	jalr		s11
