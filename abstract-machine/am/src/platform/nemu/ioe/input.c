#include <am.h>
#include <nemu.h>

#define KEYDOWN_MASK 0x8000

void __am_input_keybrd(AM_INPUT_KEYBRD_T *kbd) {
  int data = inl(KBD_ADDR);
 
  kbd->keydown = (data & KEYDOWN_MASK ? true : false);//判断按键是否按下，非0按下
  kbd->keycode = data & ~KEYDOWN_MASK;//获取通码，断码（低7位）
}
