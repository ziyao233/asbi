/*
 *	asbi
 *	/src/log.S
 *	This file is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

#include<board/uart.h>

	.global		log
	.global		log_init
	.global		log_numhex
	.global		log_num
	.global		log_newline
	.global		printk_tab

	.text

/*
 *	Print a character to UART
 *	a0:	Character in ASCII
 *	PROMISE: a0 is NOT changed
 */
.putchar:
	j		board_console_putchar_sync

log_init:
	j		board_console_init

/*
 *	Print a string to UART
 *	a0:	Pointer to the string
 */
log:
	add		sp,		sp,		-16
	sd		s0,		0(sp)
	sd		ra,		8(sp)
	mv		s0,		a0

.put:
	lb		a0,		0(s0)
	call		.putchar
	addi		s0,		s0,		1
	bnez		a0,		.put

	ld		s0,		0(sp)
	ld		ra,		8(sp)
	add		sp,		sp,		16
	ret

log_numhex:
	add		sp,		sp,		-32
	sd		ra,		0(sp)
	sd		s0,		8(sp)
	sd		s1,		16(sp)
	/*
	 *	s0 is the number, and s1 is the counter
	 */
	mv		s0,		a0

	li		a0,		'0'
	call		.putchar
	li		a0,		'x'
	call		.putchar

	mv		s1,		zero

.put_4bit:
	li		t0,		0xf000000000000000
	and		t0,		s0,		t0
	srli		t0,		t0,		60
	// Highest 4bits are in t0

	/*
	 *	t1 = (t0 > 10 ? 1 : 0) * (-39) + t0 + 87
	 *	For digits less than 10, 87 - 39 = 48 ('0')
	 *	For those more than 10, 87 + 10 = 97 ('a')
	 */
	slti		t1,		t0,		10
	li		t2,		-39
	mul		t1,		t1,		t2
	add		a0,		t0,		t1
	add		a0,		a0,		87
	call		.putchar

	add		s1,		s1,		4
	li		t0,		64
	slli		s0,		s0,		4
	bne		s1,		t0,		.put_4bit

	ld		ra,		0(sp)
	ld		s0,		8(sp)
	ld		s1,		16(sp)
	ld		s2,		24(sp)
	add		sp,		sp,		32
	ret

log_num:
	addi		sp,		sp,		-48
	sd		ra,		0(sp)
	sd		s0,		8(sp)
	sd		s1,		16(sp)
	sd		s2,		24(sp)
	sd		s3,		32(sp)

/*
	bnez		a0,		.prepare
	li		a0,		'0'
	call		.putchar
	ld		ra,		0(sp)
	ret
 */

.prepare:
	mv		s0,		a0		// Orignal number
	li		s1,		10
	mv		s2,		s1
.count_prefix:
	divu		t0,		s0,		s1
	beqz		t0,		.fix_divisor
	mul		s1,		s1,		s2
	j		.count_prefix

.fix_divisor:
	div		s1,		s1,		s2

.put_digit:
	divu		a0,		s0,		s1
	remu		s0,		s0,		s1
	addi		a0,		a0,		48
	call		.putchar
	divu		s1,		s1,		s2
	bnez		s1,		.put_digit

	ld		ra,		0(sp)
	ld		s0,		8(sp)
	ld		s1,		16(sp)
	ld		s2,		24(sp)
	ld		s3,		32(sp)
	addi		sp,		sp,		48
	ret

log_newline:
	li		a0,		'\n'
	j		.putchar

log_tab:
	li		a0,		'\t'
	j		.putchar
