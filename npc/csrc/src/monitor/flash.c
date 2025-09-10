#include <common.h>
#include<stdio.h>
#include <isa.h>
#include <memory/paddr.h>

static const uint32_t flash_img[] = {
    0x100007b7,
    0x05900713 ,
    0x00e78023,
    0x05800713,
    0x00e78023,
    0x04a00713,
    0x00e78023,
    0x00a00713,
    0x00e78023,
    0x00000513,
    0x00008067,//ret
};


// void init_flash_mem(){
//   //  printf("right inst = %x\n",flash_img[0]);
//     memcpy(Flash_guest_to_host(0),flash_img,sizeof(flash_img));
// }