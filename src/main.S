/*
 *	asbi
 *	/src/main.c
 *	This file is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

 	.global		entry

	.macro		dolog	log

	la		a0,		\log
	call		log

	.endm

	.text
entry:
	call		log_init
	dolog		asbiHelloLog

	call		fw_info

	dolog		setupPMA
	csrw		pmpcfg0,		0x0f
	li		t0,			0x3fffffffffffff
	csrw		pmpaddr0,		t0

	dolog		setupException
	call		exception_init

	dolog		sbiWorkDone
.spin:
	wfi
	j		.spin

	.data
asbiHelloLog:
	.asciz		"asbi built on " __DATE__ " at " __TIME__ "\n"
setupPMA:
	.asciz		"Setting up PMA entries\n"
setupException:
	.asciz		"Setting up interrupt handler\n"
sbiWorkDone:
	.asciz		"Done. Jumping to next-level bootloader\n"
