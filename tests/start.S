/*
 *	asbi: test kernel
 *	File: /tests/start.S
 *	This file is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */
	.global	_start

	.section	.text.start
_start:
	ecall
.spin:
	wfi
	j	.spin
