  .text
  .globl _start
_start:
  ; set stack pointer to the last RAM word
  ; note a push is pre-decrement on msp430
  ; should be in sync with the linker script
  mov #__stack, r1
  call #main
  call #385
