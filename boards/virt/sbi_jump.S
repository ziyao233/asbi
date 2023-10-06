	.global		_start
	.global		fw_info
	.global		.stack

	.section	.text.start
_start:
	csrr		t0,		mhartid
	bnez		t0,		.halt
	la		sp,		.stack

	la		t0,		__bss_start
	la		t1,		__bss_end
.clear:
	sd		zero,		0(t0)
	addi		t0,		t0,		8
	bne		t0,		t1,		.clear

	j		entry

	/*
	 *	We do not support HSM extension now, so let other harts spin.
	 */
	.text
.halt:
	wfi
	j		.halt

fw_info:
	addi		sp,		sp,		-8
	sd		ra,		0(sp)
	la		a0,		fwInfo
	call		log
	li		a0,		O_JUMP_ADDR
	call		log_numhex
	call		log_newline
	ld		ra,		0(sp)
	addi		sp,		sp,		8
	ret
fwInfo:	.asciz		"JUMP firmware, target address "

	.bss
	.skip		4096
.stack:
