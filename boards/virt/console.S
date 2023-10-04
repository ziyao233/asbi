/*
 *	asbi
 *	/boards/virt/console.S
 *	By MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */

#include<board/uart.h>
	.global		board_console_init
	.global		board_console_putchar_sync

	.text
/*
 *	Initialise UART0 (16550 UART)
 */
board_console_init:
	la		t0,		BOARD_UART0_BASE

	/*	Disable	interrupt	*/
	sb		zero,		BOARD_UART0_IER(t0)

	/*	Set baud rate		*/
	li		t1,		1 << 7
	sb		t1,		BOARD_UART0_LCR(t0)
	li		t1,		0x03
	sb		t1,		0(t0)
	sb		zero,		1(t0)		// 38.4Kbps

	/*	0801		*/
	li		t1,		0x03
	sb		t1,		BOARD_UART0_LCR(t0)

	/*	FIFO		*/
	li		t1,		0x07		// Enable and clear
	sb		t1,		BOARD_UART0_FCR(t0)

	/*	Enable	interrupts	*/
	li		t1,		0x03
	sb		t1,		BOARD_UART0_IER(t0)

	ret

/*
 *	Put a character to the UART
 *	a0:	Character
 */
board_console_putchar_sync:
	la		t0,		BOARD_UART0_BASE
.wait:
	lb		t1,		BOARD_UART0_LSR(t0)
	andi		t1,		t1,		BOARD_UART0_LSR_TX_IDLE
	beqz		t1,		.wait

	sb		a0,		BOARD_UART0_THR(t0)
	ret
