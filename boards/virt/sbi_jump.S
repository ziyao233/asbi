	.global		_start

_start:
	csrr		t0,		mhartid
	bnez		t0,		.halt
.halt:
	wfi
	j		.halt
