/*
 *	asbi
 *	/boards/virt/board/uart.h
 *	By MIT License.
 *	Copyright (c) 2023 Yao Zi. All rights reserved.
 */


#ifndef __BOARD_UART_H_INC__
#define __BOARD_UART_H_INC__

#define BOARD_UART_NR			1
#define BOARD_UART0_BASE		0x10000000
#define BOARD_UART0_THR			0
#define BOARD_UART0_IER			0x1
#define BOARD_UART0_FCR			0x2
#define BOARD_UART0_ISR			0x2
#define BOARD_UART0_LCR			0x3
#define BOARD_UART0_LSR			0x5
#define BOARD_UART0_LSR_RX_READY	0x1
#define BOARD_UART0_LSR_TX_IDLE		0x40

#endif
