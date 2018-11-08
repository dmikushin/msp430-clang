; RUN: llvm-mc -triple msp430 -show-encoding < %s | FileCheck %s
; RUN: llvm-mc -filetype=obj -triple msp430 < %s | llvm-readobj -r \
; RUN:   | FileCheck -check-prefix=RELOC %s

         mov    disp+2(r8), r15
; CHECK: mov    disp+2(r8), r15 ; encoding: [0x1f,0x48,A,A]
; CHECK:                        ;   fixup A - offset: 2, value: disp+2, kind: fixup_16_byte
; RELOC: R_MSP430_16_BYTE disp 0x2

         mov    disp+2, r15
; CHECK: mov    disp+2, r15     ; encoding: [0x1f,0x40,A,A]
; CHECK:                        ;   fixup A - offset: 2, value: disp+2, kind: fixup_16_pcrel_byte
; RELOC: R_MSP430_16_PCREL_BYTE disp 0x2

         mov    &disp+2, r15
; CHECK: mov    &disp+2, r15    ; encoding: [0x1f,0x42,A,A]
; CHECK:                        ;   fixup A - offset: 2, value: disp+2, kind: fixup_16
; RELOC: R_MSP430_16_BYTE disp 0x2

         mov    disp, disp+2
; CHECK: mov    disp, disp+2    ; encoding: [0x90,0x40,A,A,B,B]
; CHECK:                        ;   fixup A - offset: 2, value: disp, kind: fixup_16_pcrel_byte
; CHECK:                        ;   fixup B - offset: 4, value: disp+2, kind: fixup_16_pcrel_byte
; RELOC: R_MSP430_16_PCREL_BYTE disp 0x0
; RELOC: R_MSP430_16_PCREL_BYTE disp 0x2

         jmp    foo
; CHECK: jmp    foo             ; encoding: [A,0b001111AA]
; CHECK:                        ;   fixup A - offset: 0, value: foo, kind: fixup_10_pcrel
; RELOC: R_MSP430_10_PCREL foo 0x0

.short  _ctype+2
; RELOC: R_MSP430_16_BYTE _ctype 0x2
