/*
 *	asbi: test kernel
 *	File: /tests/test_base.c
 *	This file is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

#include"tests.h"
#include"sbi.h"
#include"output.h"

#define item(desc, fid) printf(desc ":\t0x%lx\n", sbi_call0(0x10, fid).value)

void
test_base(void)
{
	item("SBI Specification Version", 0);
	item("SBI Implementation ID\t", 1);
	item("SBI Implementation Version", 2);
	item("SBI Machine Vendor ID\t", 4);
	item("SBI Machine Architecture ID", 5);
	item("SBI Machine Implementation ID", 6);
	return;
}
