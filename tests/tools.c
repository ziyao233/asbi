/*
 *	asbi: test kernel
 *	File: /tests/tools.c
 *	This file is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

#include<stddef.h>

#include"tools.h"

size_t
strlen(const char *s)
{
	size_t l = 0;
	while (*s++)
		l++;
	return l;
}
