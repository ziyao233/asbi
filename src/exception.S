/*
 *	asbi
 *	File: /src/exception.S
 *	This file is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

	.global		exception_init
	.global		exception_handler
	.global		exception_not_handled

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
	li		t0,		0x10
	beq		t0,		a7,		do_sbi_base
	j		ret_from_ecall

do_sbi_console:
	j		sbi_console
do_sbi_base:
	j		sbi_base_extension

	.align		4
exception_handler:
	csrrw		sp,		mscratch,	sp
	addi		sp,		sp,		-256
	sd		zero,		0(sp)
	sd		ra,		8(sp)
	sd		gp,		16(sp)
	sd		tp,		24(sp)
	sd		t0,		32(sp)
	sd		t1,		40(sp)
	sd		t2,		48(sp)
	sd		s0,		56(sp)
	sd		s1,		64(sp)
	sd		a0,		72(sp)
	sd		a1,		80(sp)
	sd		a2,		88(sp)
	sd		a3,		96(sp)
	sd		a4,		104(sp)
	sd		a5,		112(sp)
	sd		a6,		120(sp)
	sd		a7,		128(sp)
	sd		s2,		136(sp)
	sd		s3,		144(sp)
	sd		s4,		152(sp)
	sd		s5,		160(sp)
	sd		s6,		168(sp)
	sd		s7,		176(sp)
	sd		s8,		184(sp)
	sd		s9,		192(sp)
	sd		s10,		200(sp)
	sd		s11,		208(sp)
	sd		t3,		216(sp)
	sd		t4,		224(sp)
	sd		t5,		232(sp)
	sd		t6,		240(sp)
	csrr		t0,		mepc
	sd		t0,		248(sp)

	csrr		t0,		mcause
	li		t1,		0x9
	beq		t0,		t1,		b_do_ecall

	li		t1,		0x2
	beq		t0,		t1,		b_do_emulation

b_unhandled:
exception_not_handled:
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

b_do_emulation:
	la		t0,		do_emulation
	la		s11,		ret_from_emulation
	jalr		t0
ret_from_emulation:
	ld		t0,		248(sp)
	addi		t0,		t0,		4
	sd		t0,		248(sp)
ret_from_exception:
	ld		a0,		72(sp)
	ld		a1,		80(sp)
ret_from_ecall:
	ld		t0,		248(sp)
	addi		t0,		t0,		4
	csrw		mepc,		t0
	ld		ra,		8(sp)
	ld		gp,		16(sp)
	ld		tp,		24(sp)
	ld		t0,		32(sp)
	ld		t1,		40(sp)
	ld		t2,		48(sp)
	ld		s0,		56(sp)
	ld		s1,		64(sp)
	ld		a2,		88(sp)
	ld		a3,		96(sp)
	ld		a4,		104(sp)
	ld		a5,		112(sp)
	ld		a6,		120(sp)
	ld		a7,		128(sp)
	ld		s2,		136(sp)
	ld		s3,		144(sp)
	ld		s4,		152(sp)
	ld		s5,		160(sp)
	ld		s6,		168(sp)
	ld		s7,		176(sp)
	ld		s8,		184(sp)
	ld		s9,		192(sp)
	ld		s10,		200(sp)
	ld		s11,		208(sp)
	ld		t3,		216(sp)
	ld		t4,		224(sp)
	ld		t5,		232(sp)
	ld		t6,		240(sp)
	addi		sp,		sp,		256
	csrrw		sp,		mscratch,	sp

	mret

	.data
.unhandledMsg:
	.asciz		"Unhandled exception, mcause="
