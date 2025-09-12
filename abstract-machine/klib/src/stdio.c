#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

int printf(const char *fmt, ...) {
  va_list args;
  va_start(args,fmt);
  char out[2048];
  vsprintf(out,fmt,args);
   va_end(args);
  for(int i=0;out[i]!='\0';i++){
    putch(out[i]);
  }
   putch('\0');
   return 1;
}
void int_to_hex(char *buffer, unsigned int num, int single) {
    const char *digits = single ? "0123456789ABCDEF" : "0123456789abcdef";
    char temp[32];  // 临时存储逆序的十六进制字符
    int i = 0;

    // 处理 num=0 的特殊情况
    if (num == 0) {
        buffer[0] = '0';
        buffer[1] = '\0';
        return;
    }

    // 从低位到高位提取十六进制位
    while (num > 0) {
        temp[i++] = digits[num % 16];
        num /= 16;
    }

    // 逆序写入缓冲区
    for (int j = 0; j < i; j++) {
        buffer[j] = temp[i - j - 1];
    }
    buffer[i] = '\0';
}
int vsprintf(char *out, const char *fmt, va_list ap) {
   char *start = out;
 while(*fmt != '\0'){
    if(*fmt == '%'){
      fmt++;
      switch (*fmt)
      {
      case 'd':{
        int num=va_arg(ap,int);
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
      char *str=va_arg(ap,char*);
      while(*str != '\0'){
        *out++=*str++;
      }
      break;
      }
      case 'c':
        int ch = va_arg(ap, int);
       *out++ = (unsigned char)ch;
        break;
      case 'x':
       unsigned int x_num = va_arg(ap,unsigned int);
       int_to_hex(out,x_num,0);//0小写1大写
       *out += strlen(out);
       break;
      case 'X':
       unsigned int X_num = va_arg(ap,unsigned int);
       int_to_hex(out,X_num,1);//0小写1大写
       *out += strlen(out);
       break;
      }
    }
    else {
      *out++=*fmt;
    }
    fmt++;
  }
  *out = '\0';
  return out - start;
}

int sprintf(char *out, const char *fmt, ...) {
  char *start = out;
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
      case 'c':
        int ch = va_arg(args, int);
        *out++=(unsigned char)ch;
        break;
      }
    }
    else {
      *out++=*fmt;
    }
    fmt++;
  }
  va_end(args);
  *out= '\0';
  return out - start;
  //panic("Not implemented");
}

int snprintf(char *out, size_t n, const char *fmt, ...) {
  panic("Not implemented");
}

int vsnprintf(char *out, size_t n, const char *fmt, va_list ap) {
  panic("Not implemented");
}

#endif
