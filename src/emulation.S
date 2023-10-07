/*
 *	asbi
 *	File: /src/emulation.S
 *	This file is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

	.global		do_emulation

do_emulation:
	csrr		t0,		mepc
	lw		t0,		0(t0)
	andi		t1,		t0,		0x7f

	li		t2,		0x73		// CSRXX: 0b1110011
	beq		t1,		t2,		emulate_csrxx

true_exception:
	j		exception_not_handled

emulate_csrxx:
	srli		t1,		t0,		12
	andi		t1,		t1,		0x7	// 3 bits
	beqz		t1,		true_exception

	srli		t2,		t0,		20
	li		t3,		0xfff
	and		t2,		t2,		t3

	srli		t3,		t0,		7 - 3	// (>> 7) * 8
	andi		t3,		t3,		0xf8	// 5bits
	add		t3,		t3,		sp

	srli		t4,		t0,		15
	andi		t4,		t4,		0x1f	// 5bits

	/*
	 *	t0:	The instruction
	 *	t1:	func3
	 *	t2:	CSR
	 *	t3:	address of dst
	 *	t4:	uimm5/src1
	 */

	li		t5,		0xc01			// time
	beq		t2,		t5,		emulate_csrxx_time

	j		true_exception

/*
 *	XXX: Only rdtime is supported.
 */
emulate_csrxx_time:
	li		t5,		0x2		// func3 of csrrs
	bne		t1,		t5,		true_exception

	rdtime		t5
	sd		t5,		0(t3)

	jalr		s11
