#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

int printf(const char *fmt, ...) {
  panic("Not implemented");
}

int vsprintf(char *out, const char *fmt, va_list ap) {
  panic("Not implemented");
}

int sprintf(char *out, const char *fmt, ...) {
  va_list args;
  va_start(args,fmt);
  while(*fmt != '\0'){
    if(*fmt == '%'){
      fmt++;
      switch (*fmt)
      {
      case 'd':{
        int num=va_arg(args,int);
        if(num<0){//排除负数
          *out++='-';
          num =num *(-1);
        }
        int temp_num = num;//用于计算位数
        int len=0;
        do
        {
          temp_num=temp_num /10;
          len++;
        } while (temp_num);
        out=out + len-1;//由于之前赋值已经++了，要退回一位
        int len_temp = len;
        while(len_temp--){
          int num_re=num % 10;
          *out--=num_re + 48; //逐个变为字符数字
          num=num/10;
        }
      out = out + len +1;//将out指向下一位，便于赋值
        break;
      }
      case 's':{
      char *str=va_arg(args,char*);
      while(*str != '\0'){
        *out++=*str++;
      }
      break;
      }
      }
    }
    else {
      *out++=*fmt;
    }
    fmt++;
  }
  va_end(args);
  *out= '\0';
  return 1;
  //panic("Not implemented");
}

int snprintf(char *out, size_t n, const char *fmt, ...) {
  panic("Not implemented");
}

int vsnprintf(char *out, size_t n, const char *fmt, va_list ap) {
  panic("Not implemented");
}

#endif
