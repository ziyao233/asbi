/*
 *	asbi: test kernel
 *	File: /src/sbi.S
 *	This file is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

	.global sbi_call
	.text

sbi_call:
 	ecall
	ret
