/*
 *	asbi
 *	File: /src/exception.S
 *	This file is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

	.global		exception_init
	.global		exception_handler

	.text
exception_init:
	la		t0,		.stack
	csrr		t1,		mhartid
	addi		t1,		t1,		16
	slli		t1,		t1,		8
	sub		t0,		t0,		t1
	csrw		mscratch,	t0

	la		t0,		exception_handler
	csrw		mtvec,		t0

	li		t0,		1 << 3
	csrw		mie,		t0

	csrr		t0,		mstatus
	li		t1,		1 << 3
	or		t0,		t0,		t1
	csrw		mstatus,	t0
	ret

do_ecall:
	la		s11,		ret_from_ecall
	li		t0,		0x4442434e
	beq		t0,		a7,		do_sbi_console
	j		ret_from_ecall

do_sbi_console:
	j		sbi_console

	.align		4
exception_handler:
	csrrw		sp,		mscratch,	sp
	addi		sp,		sp,		-256
	sd		ra,		0(sp)
	sd		gp,		8(sp)
	sd		tp,		16(sp)
	sd		t0,		24(sp)
	sd		t1,		32(sp)
	sd		t2,		40(sp)
	sd		s0,		48(sp)
	sd		s1,		56(sp)
	sd		a0,		64(sp)
	sd		a1,		72(sp)
	sd		a2,		80(sp)
	sd		a3,		88(sp)
	sd		a4,		96(sp)
	sd		a5,		104(sp)
	sd		a6,		112(sp)
	sd		a7,		120(sp)
	sd		s2,		128(sp)
	sd		s3,		136(sp)
	sd		s4,		144(sp)
	sd		s5,		152(sp)
	sd		s6,		160(sp)
	sd		s7,		168(sp)
	sd		s8,		176(sp)
	sd		s9,		184(sp)
	sd		s10,		192(sp)
	sd		s11,		200(sp)
	sd		t3,		208(sp)
	sd		t4,		216(sp)
	sd		t5,		224(sp)
	sd		t6,		232(sp)
	csrr		t0,		mepc
	sd		t0,		240(sp)

	csrr		t0,		mcause
	li		t1,		0x9
	beq		t0,		t1,		b_do_ecall

b_unhandled:
	la		a0,		.unhandledMsg
	call		log
	csrr		a0,		mcause
	call		log_numhex
	call		log_newline
.loop:
	wfi
	j		.loop
b_do_ecall:
	la		t0,		do_ecall
	jalr		t0

ret_from_exception:
	ld		a0,		64(sp)
	ld		a1,		72(sp)
ret_from_ecall:
	ld		t0,		240(sp)
	addi		t0,		t0,		4
	csrw		mepc,		t0
	ld		ra,		0(sp)
	ld		gp,		8(sp)
	ld		tp,		16(sp)
	ld		t0,		24(sp)
	ld		t1,		32(sp)
	ld		t2,		40(sp)
	ld		s0,		48(sp)
	ld		s1,		56(sp)
	ld		a2,		80(sp)
	ld		a3,		88(sp)
	ld		a4,		96(sp)
	ld		a5,		104(sp)
	ld		a6,		112(sp)
	ld		a7,		120(sp)
	ld		s2,		128(sp)
	ld		s3,		136(sp)
	ld		s4,		144(sp)
	ld		s5,		152(sp)
	ld		s6,		160(sp)
	ld		s7,		168(sp)
	ld		s8,		176(sp)
	ld		s9,		184(sp)
	ld		s10,		192(sp)
	ld		s11,		200(sp)
	ld		t3,		208(sp)
	ld		t4,		216(sp)
	ld		t5,		224(sp)
	ld		t6,		232(sp)
	addi		sp,		sp,		256
	csrrw		sp,		mscratch,	sp

	mret

	.data
.unhandledMsg:
	.asciz		"Unhandled exception, mcause="
