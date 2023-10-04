	.global		_start

	.section	.text.start
_start:
	csrr		t0,		mhartid
	bnez		t0,		.halt
	la		sp,		.stack
	j		entry

	/*
	 *	We do not support HSM extension now, so let other harts spin.
	 */
.halt:
	wfi
	j		.halt

	.bss
.stack:
	.skip		4096
