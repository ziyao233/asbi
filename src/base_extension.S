/*
 *	asbi
 *	File: /src/base_extension.S
 *	This file is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

#include<sbi.h>

#include<asbi.h>

	.global		sbi_base_extension

sbi_base_extension:
	li		t0,		3
	beq		t0,		a6,		sbi_probe_extension
	mv		a0,		zero
	beqz		a6,		sbi_spec_ver
	li		t0,		1
	beq		t0,		a6,		sbi_impl_id
	li		t0,		2
	beq		t0,		a6,		sbi_impl_ver
	li		t0,		4
	beq		t0,		a6,		m_vendor_id
	li		t0,		5
	beq		t0,		a6,		m_arch_id
	li		t0,		6
	beq		t0,		a6,		m_impl_id
	li		a0,		SBI_ERR_NOT_SUPPORTED
	jalr		s11

sbi_spec_ver:
	li		a1,		ASBI_SPEC_VER
	jalr		s11
sbi_impl_id:
	li		a1,		ASBI_IMPL_ID
	jalr		s11
sbi_impl_ver:
	li		a1,		ASBI_IMPL_VER
	jalr		s11
m_vendor_id:
	csrr		a1,		mvendorid
	jalr		s11
m_arch_id:
	csrr		a1,		marchid
	jalr		s11
m_impl_id:
	csrr		a1,		mimpid
	jalr		s11

	/*	Byte 1 + Byte 2 and use the least 6bits as index	*/
sbi_probe_extension:
	srli		t0,		a0,		8
	andi		t0,		t0,		0xff
	srli		t1,		a0,		16
	andi		t1,		t1,		0xff
	add		t0,		t0,		t1

	andi		t0,		t0,		0x3f
	slli		t0,		t0,		2

	la		t1,		extFilter
	add		t0,		t0,		t1
	lw		t0,		0(t0)

	beq		t0,		a0,		.supported
	mv		a1,		zero
	j		.endProbe
.supported:
	li		a1,		1
.endProbe:
	mv		a0,		zero
	jalr		s11

	.align		4
extFilter:
	.long		0x10			// Base Extension, 0
	.skip		4 * 4
	.long		0x4442434e		// Debug Console Extension, 0x05
	.skip		4 * 58
