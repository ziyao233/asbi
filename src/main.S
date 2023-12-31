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
	la		t0,		fdtAddr
	sd		a1,		0(t0)

	call		log_init
	dolog		asbiHelloLog

	call		fw_info

	dolog		setupPMA
	csrw		pmpcfg0,	0x0f
	li		t0,		0x3fffffffffffff
	csrw		pmpaddr0,	t0

	dolog		setupException
	call		exception_init

	dolog		sbiWorkDone

	csrr		t0,		mstatus
	li		t1,		~(3 << 11)
	and		t0,		t0,		t1
	li		t1,		1 << 11
	or		t0,		t0,		t1
	csrw		mstatus,	t0
	li		t0,		O_JUMP_ADDR
	csrw		mepc,		t0

	csrr		a0,		mhartid
	la		t0,		fdtAddr
	ld		a1,		0(t0)

	mret

	.data
asbiHelloLog:
	.asciz		"asbi built on " __DATE__ " at " __TIME__ "\n"
setupPMA:
	.asciz		"Setting up PMA entries\n"
setupException:
	.asciz		"Setting up interrupt handler\n"
sbiWorkDone:
	.asciz		"Done. Jumping to next-level bootloader/firmware\n"
fdtAddr:
	.quad		0
