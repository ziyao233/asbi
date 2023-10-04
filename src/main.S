/*
 *	asbi
 *	/src/main.c
 *	This file is distributed under MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

 	.global		entry

	.text
entry:
	call		log_init
	la		a0,		asbiHelloLog
	call		log

.spin:
	wfi
	j		.spin

	.data
asbiHelloLog:
	.asciz		"asbi built on " __DATE__ " at " __TIME__ "\n"
