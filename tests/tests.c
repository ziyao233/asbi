/*
 *	asbi
 *	File: /tests/tests.c
 *	This file is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

#include"sbi.h"
#include"tests.h"
#include"output.h"

int
sbi_probe(long int eid)
{
	Sbi_Return ret = sbi_call1(0x10, 3, eid);
	if (ret.value) {
		printf("SBI Extension 0x%lx is available :)\n", eid);
	} else {
		printf("SBI Extension 0x%lx is NOT available :(\n", eid);
	}
	return ret.value;
}
