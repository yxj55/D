#include <klib.h>
#include <klib-macros.h>
#include <stdint.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

size_t strlen(const char *s) {
  size_t i=0;
  for(i=0;*s!='\0';i++,s++){}//检查到'\0'时停止循环
  return i;
  //panic("Not implemented");
}

char *strcpy(char *dst, const char *src) {
  char *ret = dst; //获取dst字符串的首位置
  while((*dst++=*src++)!=0);//赋值'\0'结束循环，指向dst末尾
  return ret;//返回首位置
  //panic("Not implemented");
}

char *strncpy(char *dst, const char *src, size_t n) {
  char *d = dst;
  while (n-- > 0 && (*d++ = *src++) != '\0') {}  // 同时检查 n 和 '\0'
  return dst;
  //panic("Not implemented");
}

char *strcat(char *dst, const char *src) {
    char *d = dst;
    while (*d++);//指向'\0'
    d--;
    while((*d++=*src++)!=0);
    return dst;
  //panic("Not implemented");
}

int strcmp(const char *s1, const char *s2) {
  while(*s1 != '\0' && *s2 != '\0'){
    if(*s1 > *s2){
      return 1;
    }
    else if (*s1 < *s2){
      return -1;
    }
      s1++;
      s2++;
  }
if (*s1 == '\0' && *s2 != '\0') {
    return -1;
}
else if (*s1 != '\0' && *s2 == '\0') {
    return 1;
}
  return 0;
  //panic("Not implemented");
}

int strncmp(const char *s1, const char *s2, size_t n) {
  for (size_t i = 0; i < n; i++) {
      if (*s1 != *s2) {
        return (*s1 < *s2) ? -1 : 1;  
     }
      if (*s1 == '\0') { // 如果遇到 '\0'，提前结束
        return 0;
    }
        s1++;
        s2++;
}
return 0; // 前 n 个字符完全相同
  //panic("Not implemented");
}

void *memset(void *s, int c, size_t n) {
  char *d = (char *)s;
  for(size_t i = 0;i < n;i++){
    *d++=(unsigned char)c;
  }
  return s;
  //panic("Not implemented");
}
//memmove要考虑内存重叠
void *memmove(void *dst, const void *src, size_t n) {
  char *d = (char *) dst;
 const char *s = (const char *) src;
 if(s >= d){
  while(n--){
    *d++=*s++;
  }
 }
 //d在s前 从后向前覆盖
 else {
  d += n-1;
  s += n-1;
  while(n--){
    *d--=*s--;
  }
 }
  return dst;
 // panic("Not implemented");
}

void *memcpy(void *out, const void *in, size_t n) {
  char * o =(char *)out;
  const char * i=(const char*)in;
  while(n--){
    *o++=*i++;
  }
  return out;
  //panic("Not implemented");
}

int memcmp(const void *s1, const void *s2, size_t n) {
  const char * d1=(const char *)s1;
  const char * d2=(const char *)s2;
for (size_t i = 0; i < n; i++) {
      if (*d1 != *d2) {
        return (*d1 < *d2) ? -1 : 1;  
     }
      if (*d1 == '\0') { // 如果遇到 '\0'，提前结束
        return 0;
    }
        d1++;
        d2++;
}
return 0; // 前 n 个字符完全相同
  //panic("Not implemented");
}

#endif
