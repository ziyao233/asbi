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
