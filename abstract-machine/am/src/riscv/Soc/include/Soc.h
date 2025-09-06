#ifndef Soc_H__
#define Soc_H__

#include ISA_H


#define SPI_TX 0x10001000L
#define SPI_RX 0x10001000L

#define SPI_BASE 0x10001000
#define SPI_DIV  SPI_BASE + 0x14
#define SPI_CTRL SPI_BASE + 0x10
#define SPI_SS   SPI_BASE + 0x18

#define SPI_CTRL_GO               (1<<8)
#define SPI_CTRL_CHAR_LEN_Flash   (1 << 6)
#define SPI_CTRL_LSB              (1<<11)//1000 0000 0000
#define SPI_CTRL_RX               (1<<9) //下降沿收
#define SPI_CTRL_TX               (1<<10)
#define SPI_CTRL_ASS              (1<<13)

#define SPI_CTRL_CHAR_LEN_Bitrev   0x10


#endif