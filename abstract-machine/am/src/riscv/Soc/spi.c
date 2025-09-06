#include <Soc.h>

void set_spi_div_reg(uint16_t divisor){

    outw(SPI_DIV,divisor);
  }

void SPI_Flash_init(){
    set_spi_div_reg(2);
    outw(SPI_SS,1);
    outl(SPI_CTRL, SPI_CTRL_ASS  | SPI_CTRL_TX | SPI_CTRL_CHAR_LEN_Flash);
    
}
void SPI_Bitrev_init(){
    set_spi_div_reg(3);
    outl(SPI_CTRL,SPI_CTRL_CHAR_LEN_Bitrev | SPI_CTRL_RX |SPI_CTRL_ASS);
    outw(SPI_SS,0x80);
}
