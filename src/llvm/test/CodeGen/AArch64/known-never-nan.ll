; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64 < %s | FileCheck %s

; This should codegen to fmaxnm with no-signed-zeros.
define float @fmaxnm(i32 %i1, i32 %i2) #0 {
; CHECK-LABEL: fmaxnm:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ucvtf s0, w0
; CHECK-NEXT:    fmov s1, #11.00000000
; CHECK-NEXT:    ucvtf s2, w1
; CHECK-NEXT:    fmov s3, #17.00000000
; CHECK-NEXT:    fadd s0, s0, s1
; CHECK-NEXT:    fadd s1, s2, s3
; CHECK-NEXT:    fcmp s0, s1
; CHECK-NEXT:    fcsel s0, s0, s1, pl
; CHECK-NEXT:    ret
  %f1 = uitofp i32 %i1 to float
  %fadd1 = fadd float %f1, 11.0
  %f2 = uitofp i32 %i2 to float
  %fadd2 = fadd float %f2, 17.0
  %cmp = fcmp uge float %fadd1, %fadd2
  %val = select i1 %cmp, float %fadd1, float %fadd2
  ret float %val
}

; If f1 is 0, fmul is NaN because 0.0 * -INF = NaN
; Therefore, this is not fmaxnm.
define float @not_fmaxnm_maybe_nan(i32 %i1, i32 %i2) #0 {
; CHECK-LABEL: not_fmaxnm_maybe_nan:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI1_0
; CHECK-NEXT:    ldr s0, [x8, :lo12:.LCPI1_0]
; CHECK-NEXT:    ucvtf s1, w0
; CHECK-NEXT:    ucvtf s2, w1
; CHECK-NEXT:    fmov s3, #17.00000000
; CHECK-NEXT:    fmul s0, s1, s0
; CHECK-NEXT:    fadd s1, s2, s3
; CHECK-NEXT:    fcmp s0, s1
; CHECK-NEXT:    fcsel s0, s0, s1, pl
; CHECK-NEXT:    ret
  %f1 = uitofp i32 %i1 to float
  %fmul = fmul float %f1, 0xfff0000000000000 ; -INFINITY as 64-bit hex
  %f2 = uitofp i32 %i2 to float
  %fadd2 = fadd float %f2, 17.0
  %cmp = fcmp uge float %fmul, %fadd2
  %val = select i1 %cmp, float %fmul, float %fadd2
  ret float %val
}

attributes #0 = { "no-signed-zeros-fp-math"="true" }
