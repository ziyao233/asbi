/*
 *	asbi: test kernel
 *	File: /tests/output.h
 *	This file is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

#ifndef __OUTOUT_H_INC__
#define __OUTPUT_H_INC__

int printf_(const char *fmt, ...);
#define printf printf_

#endif	// __OUTPUT_H_INC__
