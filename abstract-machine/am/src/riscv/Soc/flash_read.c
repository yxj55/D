#include<Soc.h>
#include<klib.h>
void wait_end(){
    while ((inl(SPI_CTRL) & SPI_CTRL_GO))
    {
      /* code */
    }
    return;
  }
  uint32_t select(uint32_t n) {
    return (n >> 24) | (n << 24) | (((n >> 8) << 24) >>8) | ( ((n << 8) >> 24 )<<8 );
  }
 
uint32_t flash_read(uint32_t addr){

    outl((SPI_TX +0x4) ,addr);

    // outl((SPI_TX ) ,flash_write_data[0]);
    
    //printf("now SPI_CTRL = %x\n",inl(SPI_CTRL));
    outl(SPI_CTRL, inl(SPI_CTRL) | (SPI_CTRL_GO) );
    wait_end();
    return select(inl(SPI_RX));


}