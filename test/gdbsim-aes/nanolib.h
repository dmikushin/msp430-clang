#ifndef NANOLIB_H
#define NANOLIB_H

#define int16_t int
#define int32_t long int

#define size_t unsigned int

#define uint8_t unsigned char
#define uint16_t unsigned int
#define uint32_t unsigned long int
#define uint64_t unsigned long long int

#define uintptr_t unsigned int

#define O_RDONLY   0x0000
#define O_WRONLY   0x0001
#define O_RDWR     0x0002
#define O_ACCMODE  0x0003
#define O_CREAT    0x0100
#define O_EXCL     0x0200
#define O_NOCTTY   0x0400
#define O_TRUNC    0x0800
#define O_APPEND   0x1000
#define O_NONBLOCK 0x2000

#define sys_dump() ((void (*) (void))0x0160)()

#define sys_exit(status) ((int (*) (int))0x0181)(status)
/* three zero arguments are here just to match gdb-sim calling convention: flags should be on stack */
#define sys_open(pathname, flags) ((int (*) (char *, int, int, int, int))0x0182)(pathname, 0, 0, 0, flags)
#define sys_close(fd) ((int (*) (int))0x0183)(fd)
#define sys_read(fd, buf, count) ((int (*) (int, void *, int))0x0184)(fd, buf, count)
#define sys_write(fd, buf, count) ((int (*) (int, void *, int))0x0185)(fd, buf, count)

void *memcpy(void *, const void *, size_t);
void *memset(void *, int, size_t);
int memcmp(const void *, const void *, size_t);

void hexstr(uint8_t *, char *, size_t);
void hexdump(uint8_t *, size_t);
void putchar(int);

int __lshrsi3(int, int);
int __ashrsi3(int, int);

#endif
