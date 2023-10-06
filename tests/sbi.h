/*
 *	asbi: test kernel
 *	File: /tests/sbi.h
 *	This file is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

#ifndef __SBI_H_INC__
#define __SBI_H_INC__

typedef struct {
	long int error;
	long int value;
} Sbi_Return;

Sbi_Return sbi_call(long int foo, ...);

#define sbi_call0(eid, fid) \
	sbi_call(0, 0, 0, 0, 0, 0, fid, eid)
#define sbi_call1(eid, fid, a0) \
	sbi_call((long int)(a0), 0, 0, 0, 0, 0, fid, eid)
#define sbi_call2(eid, fid, a0, a1) \
	sbi_call((long int)(a0), a1, 0, 0, 0, 0, fid, eid)
#define sbi_call3(eid, fid, a0, a1, a2) \
	sbi_call((long int)a0, a1, a2, 0, 0, 0, fid, eid)

#endif	// __SBI_H_INC__
