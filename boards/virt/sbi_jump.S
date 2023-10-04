	.global		_start
	.global		fw_info

	.section	.text.start
_start:
	csrr		t0,		mhartid
	bnez		t0,		.halt
	la		sp,		.stack
	j		entry

	/*
	 *	We do not support HSM extension now, so let other harts spin.
	 */
	.text
.halt:
	wfi
	j		.halt

fw_info:
	la		a0,		fwInfo
	call		log
	li		a0,		O_JUMP_ADDR
	call		log_numhex
	ret
fwInfo:	.asciz		"JUMP firmware, target address "

	.bss
.stack:
	.skip		4096
