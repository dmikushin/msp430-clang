OUTPUT_ARCH(msp430)
ENTRY(_start)

/* From msp430f5257 */
MEMORY {
  RAM              : ORIGIN = 0x2400, LENGTH = 0x4000
  ROM (rx)         : ORIGIN = 0xA400, LENGTH = 0x5B80
}

SECTIONS {
  .rodata : { *(.rodata) } > ROM
  .text : { *(.text) } > ROM
  PROVIDE(__stack = ORIGIN(RAM) + LENGTH(RAM));
}
