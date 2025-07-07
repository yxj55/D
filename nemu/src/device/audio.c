/***************************************************************************************
* Copyright (c) 2014-2024 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <common.h>
#include <device/map.h>
#include <SDL2/SDL.h>

enum {
  reg_freq,
  reg_channels,
  reg_samples,
  reg_sbuf_size,
  reg_init,
  reg_count,
  nr_reg
};

static uint32_t sbuf_pos = 0;

static uint8_t *sbuf = NULL;
static uint32_t *audio_base = NULL;

void SDL_audio_play(void *userdata, uint8_t *stream, int len){
  SDL_memset(stream,0,len);
  uint32_t count = audio_base[reg_count];
  if(count < len) len = count;
  uint32_t sbuf_size = audio_base[reg_sbuf_size];
  //跨越缓冲区末尾
  if((sbuf_pos + len) > sbuf_size){
    SDL_MixAudio(stream,sbuf + sbuf_pos,sbuf_size - sbuf_pos,SDL_MIX_MAXVOLUME);//从当前位置到末尾
    SDL_MixAudio(stream + (sbuf_size - sbuf_pos),sbuf ,len - (sbuf_size - sbuf_pos),SDL_MIX_MAXVOLUME);//从头到目标位置
  }
  else {
    SDL_MixAudio(stream,sbuf + sbuf_pos,len,SDL_MIX_MAXVOLUME);//正常写入
  }
  sbuf_pos = (sbuf_pos + len) % sbuf_size;//环形缓冲区计算位置
  audio_base[reg_count] -=len;
}


void init_sound(){
  SDL_AudioSpec s = {};
  s.freq = audio_base[reg_freq];
  s.format = AUDIO_S16SYS;
  s.channels = audio_base[reg_channels];
  s.samples = audio_base[reg_samples];
  s.callback = SDL_audio_play;
  s.userdata = NULL;

    SDL_Init(SDL_INIT_AUDIO);
    SDL_OpenAudio(&s, NULL);
    SDL_PauseAudio(0);
  
}

static void audio_io_handler(uint32_t offset, int len, bool is_write) {
  if(audio_base[reg_init] == 1){
    init_sound();
    audio_base[reg_init]=0;
  }
}

void init_audio() {
  uint32_t space_size = sizeof(uint32_t) * nr_reg;
  audio_base = (uint32_t *)new_space(space_size);
#ifdef CONFIG_HAS_PORT_IO
  add_pio_map ("audio", CONFIG_AUDIO_CTL_PORT, audio_base, space_size, audio_io_handler);
#else
  add_mmio_map("audio", CONFIG_AUDIO_CTL_MMIO, audio_base, space_size, audio_io_handler);
#endif
  audio_base[reg_sbuf_size] = CONFIG_SB_SIZE;    
  sbuf = (uint8_t *)new_space(CONFIG_SB_SIZE);
  add_mmio_map("audio-sbuf", CONFIG_SB_ADDR, sbuf, CONFIG_SB_SIZE, NULL);
}
