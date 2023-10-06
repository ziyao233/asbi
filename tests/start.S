/*
 *	asbi: test kernel
 *	File: /tests/start.S
 *	This file is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */
	.global	_start

	.section	.text.start
_start:

	la		t0,		__bss_start
	la		t1,		__bss_end
.clear_bss:
	sd		zero,		0(t0)
	addi		t0,		t0,		8
	bne		t0,		t1,		.clear_bss

	la		sp,		cStack

	j		main

	.bss
	.skip		4096
cStack:
