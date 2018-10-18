#include "nanolib.h"

void *memcpy(void *dest, const void *source, size_t n)
{
  char *dst = dest;
  const char *src = source;
  while (n--)
    *dst++ = *src++;
  return dest;
}

void *memset(void *s, int c, size_t n)
{
  char *dst = s;
  while (n--)
    *dst++ = c;
  return s;
}

int memcmp(const void *s1, const void *s2, size_t n)
{
  const uint8_t *p = s1;
  const uint8_t *q = s2;
  while (n--)
  {
    int diff = (int)*p - (int)*q;
    if (diff)
      return diff;
    p++;
    q++;
  }
  return 0;
}

void hexstr(uint8_t *data, char *str, size_t n)
{
  const char hex[] = "0123456789abcdef";
  while (n--)
  {
    uint8_t b = data[n];
    str[n * 2]     = hex[b >> 4];
    str[n * 2 + 1] = hex[b & 15];
  }
}

void hexdump(uint8_t *data, size_t n)
{
  char hex[n * 2];
  hexstr(data, hex, n);
  sys_write(2, hex, n * 2);
}

void putchar(int c)
{
  char ch = c;
  sys_write(2, &ch, 1);
}

int __lshrsi3(int a, int b)
{
  while (b--)
    a >>= 1;
  return a;
}

int __ashrsi3(int a, int b)
{
  if (!(a & 0x8000))
    return __lshrsi3(a, b);
  while (b--)
      a = 0x8000 | (a >> 1);
  return a;
}
