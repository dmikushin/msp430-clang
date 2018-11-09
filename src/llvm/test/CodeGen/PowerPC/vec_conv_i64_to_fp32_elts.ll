; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     -mcpu=pwr8 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-P8
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-P9
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-BE

define i64 @test2elt(<2 x i64> %a) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    xxlor vs1, v2, v2
; CHECK-P8-NEXT:    xscvuxdsp f1, f1
; CHECK-P8-NEXT:    xscvuxdsp f0, f0
; CHECK-P8-NEXT:    xscvdpspn vs1, f1
; CHECK-P8-NEXT:    xscvdpspn vs0, f0
; CHECK-P8-NEXT:    xxsldwi v3, vs1, vs1, 1
; CHECK-P8-NEXT:    xxsldwi v2, vs0, vs0, 1
; CHECK-P8-NEXT:    vmrglw v2, v3, v2
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    mfvsrd r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xxswapd vs0, v2
; CHECK-P9-NEXT:    xxlor vs1, v2, v2
; CHECK-P9-NEXT:    xscvuxdsp f1, f1
; CHECK-P9-NEXT:    xscvuxdsp f0, f0
; CHECK-P9-NEXT:    xscvdpspn vs1, f1
; CHECK-P9-NEXT:    xscvdpspn vs0, f0
; CHECK-P9-NEXT:    xxsldwi v3, vs1, vs1, 1
; CHECK-P9-NEXT:    xxsldwi v2, vs0, vs0, 1
; CHECK-P9-NEXT:    vmrglw v2, v3, v2
; CHECK-P9-NEXT:    mfvsrld r3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xxswapd vs0, v2
; CHECK-BE-NEXT:    xxlor vs1, v2, v2
; CHECK-BE-NEXT:    xscvuxdsp f1, f1
; CHECK-BE-NEXT:    xscvuxdsp f0, f0
; CHECK-BE-NEXT:    xscvdpspn v2, f1
; CHECK-BE-NEXT:    xscvdpspn v3, f0
; CHECK-BE-NEXT:    vmrghw v2, v2, v3
; CHECK-BE-NEXT:    mfvsrd r3, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = uitofp <2 x i64> %a to <2 x float>
  %1 = bitcast <2 x float> %0 to i64
  ret i64 %1
}

define <4 x float> @test4elt(<4 x i64>* nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    lxvd2x vs1, 0, r3
; CHECK-P8-NEXT:    lxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    xxswapd vs3, vs1
; CHECK-P8-NEXT:    xscvuxdsp f1, f1
; CHECK-P8-NEXT:    xxswapd vs2, vs0
; CHECK-P8-NEXT:    xscvuxdsp f0, f0
; CHECK-P8-NEXT:    xscvuxdsp f3, f3
; CHECK-P8-NEXT:    xscvuxdsp f2, f2
; CHECK-P8-NEXT:    xxmrghd vs0, vs0, vs1
; CHECK-P8-NEXT:    xxmrghd vs1, vs2, vs3
; CHECK-P8-NEXT:    xvcvdpsp v2, vs0
; CHECK-P8-NEXT:    xvcvdpsp v3, vs1
; CHECK-P8-NEXT:    vmrgew v2, v3, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs0, 16(r3)
; CHECK-P9-NEXT:    lxv vs1, 0(r3)
; CHECK-P9-NEXT:    xxswapd vs2, vs1
; CHECK-P9-NEXT:    xxswapd vs3, vs0
; CHECK-P9-NEXT:    xscvuxdsp f1, f1
; CHECK-P9-NEXT:    xscvuxdsp f0, f0
; CHECK-P9-NEXT:    xscvuxdsp f2, f2
; CHECK-P9-NEXT:    xscvuxdsp f3, f3
; CHECK-P9-NEXT:    xxmrghd vs0, vs0, vs1
; CHECK-P9-NEXT:    xxmrghd vs2, vs3, vs2
; CHECK-P9-NEXT:    xvcvdpsp v3, vs0
; CHECK-P9-NEXT:    xvcvdpsp v2, vs2
; CHECK-P9-NEXT:    vmrgew v2, v3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    xxswapd vs2, vs1
; CHECK-BE-NEXT:    xxswapd vs3, vs0
; CHECK-BE-NEXT:    xscvuxdsp f1, f1
; CHECK-BE-NEXT:    xscvuxdsp f0, f0
; CHECK-BE-NEXT:    xscvuxdsp f2, f2
; CHECK-BE-NEXT:    xscvuxdsp f3, f3
; CHECK-BE-NEXT:    xxmrghd vs0, vs0, vs1
; CHECK-BE-NEXT:    xxmrghd vs1, vs3, vs2
; CHECK-BE-NEXT:    xvcvdpsp v2, vs0
; CHECK-BE-NEXT:    xvcvdpsp v3, vs1
; CHECK-BE-NEXT:    vmrgew v2, v2, v3
; CHECK-BE-NEXT:    blr
entry:
  %a = load <4 x i64>, <4 x i64>* %0, align 32
  %1 = uitofp <4 x i64> %a to <4 x float>
  ret <4 x float> %1
}

define void @test8elt(<8 x float>* noalias nocapture sret %agg.result, <8 x i64>* nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test8elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    li r6, 48
; CHECK-P8-NEXT:    lxvd2x vs3, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r5
; CHECK-P8-NEXT:    xxswapd vs7, vs3
; CHECK-P8-NEXT:    xscvuxdsp f3, f3
; CHECK-P8-NEXT:    xxswapd vs4, vs0
; CHECK-P8-NEXT:    xscvuxdsp f0, f0
; CHECK-P8-NEXT:    xxswapd vs5, vs1
; CHECK-P8-NEXT:    xscvuxdsp f1, f1
; CHECK-P8-NEXT:    xxswapd vs6, vs2
; CHECK-P8-NEXT:    xscvuxdsp f2, f2
; CHECK-P8-NEXT:    xscvuxdsp f4, f4
; CHECK-P8-NEXT:    xscvuxdsp f5, f5
; CHECK-P8-NEXT:    xscvuxdsp f6, f6
; CHECK-P8-NEXT:    xscvuxdsp f7, f7
; CHECK-P8-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P8-NEXT:    xxmrghd vs1, vs2, vs3
; CHECK-P8-NEXT:    xxmrghd vs2, vs5, vs4
; CHECK-P8-NEXT:    xvcvdpsp v2, vs0
; CHECK-P8-NEXT:    xvcvdpsp v3, vs1
; CHECK-P8-NEXT:    xxmrghd vs0, vs6, vs7
; CHECK-P8-NEXT:    xvcvdpsp v4, vs2
; CHECK-P8-NEXT:    xvcvdpsp v5, vs0
; CHECK-P8-NEXT:    vmrgew v2, v4, v2
; CHECK-P8-NEXT:    vmrgew v3, v5, v3
; CHECK-P8-NEXT:    stvx v2, r3, r5
; CHECK-P8-NEXT:    stvx v3, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs0, 48(r4)
; CHECK-P9-NEXT:    lxv vs1, 32(r4)
; CHECK-P9-NEXT:    lxv vs2, 16(r4)
; CHECK-P9-NEXT:    lxv vs3, 0(r4)
; CHECK-P9-NEXT:    xxswapd vs4, vs3
; CHECK-P9-NEXT:    xxswapd vs5, vs2
; CHECK-P9-NEXT:    xxswapd vs6, vs1
; CHECK-P9-NEXT:    xxswapd vs7, vs0
; CHECK-P9-NEXT:    xscvuxdsp f3, f3
; CHECK-P9-NEXT:    xscvuxdsp f2, f2
; CHECK-P9-NEXT:    xscvuxdsp f1, f1
; CHECK-P9-NEXT:    xscvuxdsp f0, f0
; CHECK-P9-NEXT:    xscvuxdsp f4, f4
; CHECK-P9-NEXT:    xscvuxdsp f5, f5
; CHECK-P9-NEXT:    xscvuxdsp f6, f6
; CHECK-P9-NEXT:    xscvuxdsp f7, f7
; CHECK-P9-NEXT:    xxmrghd vs2, vs2, vs3
; CHECK-P9-NEXT:    xxmrghd vs0, vs0, vs1
; CHECK-P9-NEXT:    xxmrghd vs4, vs5, vs4
; CHECK-P9-NEXT:    xxmrghd vs3, vs7, vs6
; CHECK-P9-NEXT:    xvcvdpsp v3, vs2
; CHECK-P9-NEXT:    xvcvdpsp v5, vs0
; CHECK-P9-NEXT:    xvcvdpsp v2, vs4
; CHECK-P9-NEXT:    xvcvdpsp v4, vs3
; CHECK-P9-NEXT:    vmrgew v2, v3, v2
; CHECK-P9-NEXT:    vmrgew v3, v5, v4
; CHECK-P9-NEXT:    stxv v3, 16(r3)
; CHECK-P9-NEXT:    stxv v2, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs0, 32(r4)
; CHECK-BE-NEXT:    lxv vs1, 48(r4)
; CHECK-BE-NEXT:    lxv vs2, 0(r4)
; CHECK-BE-NEXT:    lxv vs3, 16(r4)
; CHECK-BE-NEXT:    xxswapd vs4, vs3
; CHECK-BE-NEXT:    xxswapd vs5, vs2
; CHECK-BE-NEXT:    xxswapd vs6, vs1
; CHECK-BE-NEXT:    xxswapd vs7, vs0
; CHECK-BE-NEXT:    xscvuxdsp f3, f3
; CHECK-BE-NEXT:    xscvuxdsp f2, f2
; CHECK-BE-NEXT:    xscvuxdsp f1, f1
; CHECK-BE-NEXT:    xscvuxdsp f0, f0
; CHECK-BE-NEXT:    xscvuxdsp f4, f4
; CHECK-BE-NEXT:    xscvuxdsp f5, f5
; CHECK-BE-NEXT:    xscvuxdsp f6, f6
; CHECK-BE-NEXT:    xscvuxdsp f7, f7
; CHECK-BE-NEXT:    xxmrghd vs2, vs2, vs3
; CHECK-BE-NEXT:    xxmrghd vs0, vs0, vs1
; CHECK-BE-NEXT:    xxmrghd vs3, vs5, vs4
; CHECK-BE-NEXT:    xxmrghd vs1, vs7, vs6
; CHECK-BE-NEXT:    xvcvdpsp v2, vs2
; CHECK-BE-NEXT:    xvcvdpsp v4, vs0
; CHECK-BE-NEXT:    xvcvdpsp v3, vs3
; CHECK-BE-NEXT:    xvcvdpsp v5, vs1
; CHECK-BE-NEXT:    vmrgew v2, v2, v3
; CHECK-BE-NEXT:    vmrgew v3, v4, v5
; CHECK-BE-NEXT:    stxv v3, 16(r3)
; CHECK-BE-NEXT:    stxv v2, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <8 x i64>, <8 x i64>* %0, align 64
  %1 = uitofp <8 x i64> %a to <8 x float>
  store <8 x float> %1, <8 x float>* %agg.result, align 32
  ret void
}

define void @test16elt(<16 x float>* noalias nocapture sret %agg.result, <16 x i64>* nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test16elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r7, 64
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    li r6, 48
; CHECK-P8-NEXT:    lxvd2x vs11, 0, r4
; CHECK-P8-NEXT:    stfd f30, -16(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    lxvd2x vs8, r4, r7
; CHECK-P8-NEXT:    li r7, 80
; CHECK-P8-NEXT:    lxvd2x vs6, r4, r5
; CHECK-P8-NEXT:    stfd f31, -8(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    lxvd2x vs7, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r7
; CHECK-P8-NEXT:    li r7, 96
; CHECK-P8-NEXT:    lxvd2x vs3, r4, r7
; CHECK-P8-NEXT:    li r7, 112
; CHECK-P8-NEXT:    xscvuxdsp f30, f11
; CHECK-P8-NEXT:    xxswapd vs11, vs11
; CHECK-P8-NEXT:    lxvd2x vs4, r4, r7
; CHECK-P8-NEXT:    li r7, 16
; CHECK-P8-NEXT:    xscvuxdsp f0, f6
; CHECK-P8-NEXT:    xxswapd vs6, vs6
; CHECK-P8-NEXT:    xscvuxdsp f1, f7
; CHECK-P8-NEXT:    lxvd2x vs9, r4, r7
; CHECK-P8-NEXT:    xxswapd vs7, vs7
; CHECK-P8-NEXT:    xscvuxdsp f5, f8
; CHECK-P8-NEXT:    xxswapd vs8, vs8
; CHECK-P8-NEXT:    xscvuxdsp f10, f2
; CHECK-P8-NEXT:    xxswapd vs2, vs2
; CHECK-P8-NEXT:    xscvuxdsp f12, f3
; CHECK-P8-NEXT:    xxswapd vs3, vs3
; CHECK-P8-NEXT:    xscvuxdsp f13, f4
; CHECK-P8-NEXT:    xxswapd vs4, vs4
; CHECK-P8-NEXT:    xscvuxdsp f31, f9
; CHECK-P8-NEXT:    xxswapd vs9, vs9
; CHECK-P8-NEXT:    xscvuxdsp f6, f6
; CHECK-P8-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P8-NEXT:    xscvuxdsp f7, f7
; CHECK-P8-NEXT:    xscvuxdsp f8, f8
; CHECK-P8-NEXT:    xxmrghd vs5, vs10, vs5
; CHECK-P8-NEXT:    xscvuxdsp f2, f2
; CHECK-P8-NEXT:    xscvuxdsp f3, f3
; CHECK-P8-NEXT:    xxmrghd vs10, vs13, vs12
; CHECK-P8-NEXT:    xscvuxdsp f4, f4
; CHECK-P8-NEXT:    xscvuxdsp f1, f9
; CHECK-P8-NEXT:    xscvuxdsp f9, f11
; CHECK-P8-NEXT:    xxmrghd vs11, vs31, vs30
; CHECK-P8-NEXT:    lfd f31, -8(r1) # 8-byte Folded Reload
; CHECK-P8-NEXT:    lfd f30, -16(r1) # 8-byte Folded Reload
; CHECK-P8-NEXT:    xvcvdpsp v2, vs0
; CHECK-P8-NEXT:    xxmrghd vs0, vs7, vs6
; CHECK-P8-NEXT:    xxmrghd vs2, vs2, vs8
; CHECK-P8-NEXT:    xvcvdpsp v3, vs5
; CHECK-P8-NEXT:    xvcvdpsp v4, vs10
; CHECK-P8-NEXT:    xxmrghd vs3, vs4, vs3
; CHECK-P8-NEXT:    xvcvdpsp v5, vs11
; CHECK-P8-NEXT:    xvcvdpsp v0, vs0
; CHECK-P8-NEXT:    xxmrghd vs1, vs1, vs9
; CHECK-P8-NEXT:    xvcvdpsp v1, vs2
; CHECK-P8-NEXT:    xvcvdpsp v6, vs3
; CHECK-P8-NEXT:    xvcvdpsp v7, vs1
; CHECK-P8-NEXT:    vmrgew v2, v0, v2
; CHECK-P8-NEXT:    vmrgew v3, v1, v3
; CHECK-P8-NEXT:    vmrgew v4, v6, v4
; CHECK-P8-NEXT:    vmrgew v5, v7, v5
; CHECK-P8-NEXT:    stvx v2, r3, r7
; CHECK-P8-NEXT:    stvx v3, r3, r5
; CHECK-P8-NEXT:    stvx v4, r3, r6
; CHECK-P8-NEXT:    stvx v5, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs4, 48(r4)
; CHECK-P9-NEXT:    lxv vs5, 32(r4)
; CHECK-P9-NEXT:    lxv vs6, 16(r4)
; CHECK-P9-NEXT:    lxv vs7, 0(r4)
; CHECK-P9-NEXT:    lxv vs8, 112(r4)
; CHECK-P9-NEXT:    lxv vs9, 96(r4)
; CHECK-P9-NEXT:    lxv vs10, 80(r4)
; CHECK-P9-NEXT:    lxv vs11, 64(r4)
; CHECK-P9-NEXT:    stfd f30, -16(r1) # 8-byte Folded Spill
; CHECK-P9-NEXT:    stfd f31, -8(r1) # 8-byte Folded Spill
; CHECK-P9-NEXT:    xxswapd vs0, vs7
; CHECK-P9-NEXT:    xxswapd vs1, vs6
; CHECK-P9-NEXT:    xxswapd vs2, vs5
; CHECK-P9-NEXT:    xxswapd vs3, vs4
; CHECK-P9-NEXT:    xxswapd vs12, vs11
; CHECK-P9-NEXT:    xxswapd vs13, vs10
; CHECK-P9-NEXT:    xxswapd vs31, vs9
; CHECK-P9-NEXT:    xxswapd vs30, vs8
; CHECK-P9-NEXT:    xscvuxdsp f7, f7
; CHECK-P9-NEXT:    xscvuxdsp f6, f6
; CHECK-P9-NEXT:    xscvuxdsp f5, f5
; CHECK-P9-NEXT:    xscvuxdsp f4, f4
; CHECK-P9-NEXT:    xscvuxdsp f11, f11
; CHECK-P9-NEXT:    xscvuxdsp f10, f10
; CHECK-P9-NEXT:    xscvuxdsp f9, f9
; CHECK-P9-NEXT:    xscvuxdsp f8, f8
; CHECK-P9-NEXT:    xscvuxdsp f0, f0
; CHECK-P9-NEXT:    xscvuxdsp f1, f1
; CHECK-P9-NEXT:    xscvuxdsp f2, f2
; CHECK-P9-NEXT:    xscvuxdsp f3, f3
; CHECK-P9-NEXT:    xscvuxdsp f12, f12
; CHECK-P9-NEXT:    xscvuxdsp f13, f13
; CHECK-P9-NEXT:    xscvuxdsp f31, f31
; CHECK-P9-NEXT:    xscvuxdsp f30, f30
; CHECK-P9-NEXT:    xxmrghd vs6, vs6, vs7
; CHECK-P9-NEXT:    xxmrghd vs4, vs4, vs5
; CHECK-P9-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P9-NEXT:    xxmrghd vs1, vs3, vs2
; CHECK-P9-NEXT:    xxmrghd vs2, vs10, vs11
; CHECK-P9-NEXT:    xxmrghd vs3, vs8, vs9
; CHECK-P9-NEXT:    xxmrghd vs5, vs13, vs12
; CHECK-P9-NEXT:    xxmrghd vs7, vs30, vs31
; CHECK-P9-NEXT:    lfd f31, -8(r1) # 8-byte Folded Reload
; CHECK-P9-NEXT:    lfd f30, -16(r1) # 8-byte Folded Reload
; CHECK-P9-NEXT:    xvcvdpsp v2, vs6
; CHECK-P9-NEXT:    xvcvdpsp v3, vs4
; CHECK-P9-NEXT:    xvcvdpsp v4, vs0
; CHECK-P9-NEXT:    xvcvdpsp v5, vs1
; CHECK-P9-NEXT:    xvcvdpsp v0, vs5
; CHECK-P9-NEXT:    xvcvdpsp v1, vs2
; CHECK-P9-NEXT:    xvcvdpsp v6, vs7
; CHECK-P9-NEXT:    xvcvdpsp v7, vs3
; CHECK-P9-NEXT:    vmrgew v2, v2, v4
; CHECK-P9-NEXT:    vmrgew v3, v3, v5
; CHECK-P9-NEXT:    vmrgew v4, v1, v0
; CHECK-P9-NEXT:    vmrgew v5, v7, v6
; CHECK-P9-NEXT:    stxv v4, 32(r3)
; CHECK-P9-NEXT:    stxv v3, 16(r3)
; CHECK-P9-NEXT:    stxv v2, 0(r3)
; CHECK-P9-NEXT:    stxv v5, 48(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs2, 32(r4)
; CHECK-BE-NEXT:    lxv vs3, 48(r4)
; CHECK-BE-NEXT:    lxv vs4, 0(r4)
; CHECK-BE-NEXT:    lxv vs5, 16(r4)
; CHECK-BE-NEXT:    lxv vs6, 96(r4)
; CHECK-BE-NEXT:    lxv vs7, 112(r4)
; CHECK-BE-NEXT:    lxv vs8, 64(r4)
; CHECK-BE-NEXT:    lxv vs9, 80(r4)
; CHECK-BE-NEXT:    stfd f30, -16(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stfd f31, -8(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    xxswapd vs0, vs5
; CHECK-BE-NEXT:    xxswapd vs1, vs4
; CHECK-BE-NEXT:    xxswapd vs10, vs3
; CHECK-BE-NEXT:    xxswapd vs11, vs2
; CHECK-BE-NEXT:    xxswapd vs12, vs9
; CHECK-BE-NEXT:    xxswapd vs13, vs8
; CHECK-BE-NEXT:    xxswapd vs31, vs7
; CHECK-BE-NEXT:    xxswapd vs30, vs6
; CHECK-BE-NEXT:    xscvuxdsp f5, f5
; CHECK-BE-NEXT:    xscvuxdsp f4, f4
; CHECK-BE-NEXT:    xscvuxdsp f3, f3
; CHECK-BE-NEXT:    xscvuxdsp f2, f2
; CHECK-BE-NEXT:    xscvuxdsp f9, f9
; CHECK-BE-NEXT:    xscvuxdsp f8, f8
; CHECK-BE-NEXT:    xscvuxdsp f7, f7
; CHECK-BE-NEXT:    xscvuxdsp f6, f6
; CHECK-BE-NEXT:    xscvuxdsp f0, f0
; CHECK-BE-NEXT:    xscvuxdsp f1, f1
; CHECK-BE-NEXT:    xscvuxdsp f10, f10
; CHECK-BE-NEXT:    xscvuxdsp f11, f11
; CHECK-BE-NEXT:    xscvuxdsp f12, f12
; CHECK-BE-NEXT:    xscvuxdsp f13, f13
; CHECK-BE-NEXT:    xscvuxdsp f31, f31
; CHECK-BE-NEXT:    xscvuxdsp f30, f30
; CHECK-BE-NEXT:    xxmrghd vs4, vs4, vs5
; CHECK-BE-NEXT:    xxmrghd vs2, vs2, vs3
; CHECK-BE-NEXT:    xxmrghd vs3, vs8, vs9
; CHECK-BE-NEXT:    xxmrghd vs5, vs6, vs7
; CHECK-BE-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-BE-NEXT:    xxmrghd vs1, vs11, vs10
; CHECK-BE-NEXT:    xxmrghd vs6, vs13, vs12
; CHECK-BE-NEXT:    xxmrghd vs7, vs30, vs31
; CHECK-BE-NEXT:    lfd f31, -8(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f30, -16(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    xvcvdpsp v2, vs4
; CHECK-BE-NEXT:    xvcvdpsp v3, vs2
; CHECK-BE-NEXT:    xvcvdpsp v0, vs3
; CHECK-BE-NEXT:    xvcvdpsp v6, vs5
; CHECK-BE-NEXT:    xvcvdpsp v4, vs0
; CHECK-BE-NEXT:    xvcvdpsp v5, vs1
; CHECK-BE-NEXT:    xvcvdpsp v1, vs6
; CHECK-BE-NEXT:    xvcvdpsp v7, vs7
; CHECK-BE-NEXT:    vmrgew v2, v2, v4
; CHECK-BE-NEXT:    vmrgew v3, v3, v5
; CHECK-BE-NEXT:    vmrgew v4, v0, v1
; CHECK-BE-NEXT:    vmrgew v5, v6, v7
; CHECK-BE-NEXT:    stxv v5, 48(r3)
; CHECK-BE-NEXT:    stxv v4, 32(r3)
; CHECK-BE-NEXT:    stxv v3, 16(r3)
; CHECK-BE-NEXT:    stxv v2, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x i64>, <16 x i64>* %0, align 128
  %1 = uitofp <16 x i64> %a to <16 x float>
  store <16 x float> %1, <16 x float>* %agg.result, align 64
  ret void
}

define i64 @test2elt_signed(<2 x i64> %a) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    xxlor vs1, v2, v2
; CHECK-P8-NEXT:    xscvsxdsp f1, f1
; CHECK-P8-NEXT:    xscvsxdsp f0, f0
; CHECK-P8-NEXT:    xscvdpspn vs1, f1
; CHECK-P8-NEXT:    xscvdpspn vs0, f0
; CHECK-P8-NEXT:    xxsldwi v3, vs1, vs1, 1
; CHECK-P8-NEXT:    xxsldwi v2, vs0, vs0, 1
; CHECK-P8-NEXT:    vmrglw v2, v3, v2
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    mfvsrd r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xxswapd vs0, v2
; CHECK-P9-NEXT:    xxlor vs1, v2, v2
; CHECK-P9-NEXT:    xscvsxdsp f1, f1
; CHECK-P9-NEXT:    xscvsxdsp f0, f0
; CHECK-P9-NEXT:    xscvdpspn vs1, f1
; CHECK-P9-NEXT:    xscvdpspn vs0, f0
; CHECK-P9-NEXT:    xxsldwi v3, vs1, vs1, 1
; CHECK-P9-NEXT:    xxsldwi v2, vs0, vs0, 1
; CHECK-P9-NEXT:    vmrglw v2, v3, v2
; CHECK-P9-NEXT:    mfvsrld r3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xxswapd vs0, v2
; CHECK-BE-NEXT:    xxlor vs1, v2, v2
; CHECK-BE-NEXT:    xscvsxdsp f1, f1
; CHECK-BE-NEXT:    xscvsxdsp f0, f0
; CHECK-BE-NEXT:    xscvdpspn v2, f1
; CHECK-BE-NEXT:    xscvdpspn v3, f0
; CHECK-BE-NEXT:    vmrghw v2, v2, v3
; CHECK-BE-NEXT:    mfvsrd r3, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = sitofp <2 x i64> %a to <2 x float>
  %1 = bitcast <2 x float> %0 to i64
  ret i64 %1
}

define <4 x float> @test4elt_signed(<4 x i64>* nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    lxvd2x vs1, 0, r3
; CHECK-P8-NEXT:    lxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    xxswapd vs3, vs1
; CHECK-P8-NEXT:    xscvsxdsp f1, f1
; CHECK-P8-NEXT:    xxswapd vs2, vs0
; CHECK-P8-NEXT:    xscvsxdsp f0, f0
; CHECK-P8-NEXT:    xscvsxdsp f3, f3
; CHECK-P8-NEXT:    xscvsxdsp f2, f2
; CHECK-P8-NEXT:    xxmrghd vs0, vs0, vs1
; CHECK-P8-NEXT:    xxmrghd vs1, vs2, vs3
; CHECK-P8-NEXT:    xvcvdpsp v2, vs0
; CHECK-P8-NEXT:    xvcvdpsp v3, vs1
; CHECK-P8-NEXT:    vmrgew v2, v3, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs0, 16(r3)
; CHECK-P9-NEXT:    lxv vs1, 0(r3)
; CHECK-P9-NEXT:    xxswapd vs2, vs1
; CHECK-P9-NEXT:    xxswapd vs3, vs0
; CHECK-P9-NEXT:    xscvsxdsp f1, f1
; CHECK-P9-NEXT:    xscvsxdsp f0, f0
; CHECK-P9-NEXT:    xscvsxdsp f2, f2
; CHECK-P9-NEXT:    xscvsxdsp f3, f3
; CHECK-P9-NEXT:    xxmrghd vs0, vs0, vs1
; CHECK-P9-NEXT:    xxmrghd vs2, vs3, vs2
; CHECK-P9-NEXT:    xvcvdpsp v3, vs0
; CHECK-P9-NEXT:    xvcvdpsp v2, vs2
; CHECK-P9-NEXT:    vmrgew v2, v3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    xxswapd vs2, vs1
; CHECK-BE-NEXT:    xxswapd vs3, vs0
; CHECK-BE-NEXT:    xscvsxdsp f1, f1
; CHECK-BE-NEXT:    xscvsxdsp f0, f0
; CHECK-BE-NEXT:    xscvsxdsp f2, f2
; CHECK-BE-NEXT:    xscvsxdsp f3, f3
; CHECK-BE-NEXT:    xxmrghd vs0, vs0, vs1
; CHECK-BE-NEXT:    xxmrghd vs1, vs3, vs2
; CHECK-BE-NEXT:    xvcvdpsp v2, vs0
; CHECK-BE-NEXT:    xvcvdpsp v3, vs1
; CHECK-BE-NEXT:    vmrgew v2, v2, v3
; CHECK-BE-NEXT:    blr
entry:
  %a = load <4 x i64>, <4 x i64>* %0, align 32
  %1 = sitofp <4 x i64> %a to <4 x float>
  ret <4 x float> %1
}

define void @test8elt_signed(<8 x float>* noalias nocapture sret %agg.result, <8 x i64>* nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test8elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    li r6, 48
; CHECK-P8-NEXT:    lxvd2x vs3, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r5
; CHECK-P8-NEXT:    xxswapd vs7, vs3
; CHECK-P8-NEXT:    xscvsxdsp f3, f3
; CHECK-P8-NEXT:    xxswapd vs4, vs0
; CHECK-P8-NEXT:    xscvsxdsp f0, f0
; CHECK-P8-NEXT:    xxswapd vs5, vs1
; CHECK-P8-NEXT:    xscvsxdsp f1, f1
; CHECK-P8-NEXT:    xxswapd vs6, vs2
; CHECK-P8-NEXT:    xscvsxdsp f2, f2
; CHECK-P8-NEXT:    xscvsxdsp f4, f4
; CHECK-P8-NEXT:    xscvsxdsp f5, f5
; CHECK-P8-NEXT:    xscvsxdsp f6, f6
; CHECK-P8-NEXT:    xscvsxdsp f7, f7
; CHECK-P8-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P8-NEXT:    xxmrghd vs1, vs2, vs3
; CHECK-P8-NEXT:    xxmrghd vs2, vs5, vs4
; CHECK-P8-NEXT:    xvcvdpsp v2, vs0
; CHECK-P8-NEXT:    xvcvdpsp v3, vs1
; CHECK-P8-NEXT:    xxmrghd vs0, vs6, vs7
; CHECK-P8-NEXT:    xvcvdpsp v4, vs2
; CHECK-P8-NEXT:    xvcvdpsp v5, vs0
; CHECK-P8-NEXT:    vmrgew v2, v4, v2
; CHECK-P8-NEXT:    vmrgew v3, v5, v3
; CHECK-P8-NEXT:    stvx v2, r3, r5
; CHECK-P8-NEXT:    stvx v3, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs0, 48(r4)
; CHECK-P9-NEXT:    lxv vs1, 32(r4)
; CHECK-P9-NEXT:    lxv vs2, 16(r4)
; CHECK-P9-NEXT:    lxv vs3, 0(r4)
; CHECK-P9-NEXT:    xxswapd vs4, vs3
; CHECK-P9-NEXT:    xxswapd vs5, vs2
; CHECK-P9-NEXT:    xxswapd vs6, vs1
; CHECK-P9-NEXT:    xxswapd vs7, vs0
; CHECK-P9-NEXT:    xscvsxdsp f3, f3
; CHECK-P9-NEXT:    xscvsxdsp f2, f2
; CHECK-P9-NEXT:    xscvsxdsp f1, f1
; CHECK-P9-NEXT:    xscvsxdsp f0, f0
; CHECK-P9-NEXT:    xscvsxdsp f4, f4
; CHECK-P9-NEXT:    xscvsxdsp f5, f5
; CHECK-P9-NEXT:    xscvsxdsp f6, f6
; CHECK-P9-NEXT:    xscvsxdsp f7, f7
; CHECK-P9-NEXT:    xxmrghd vs2, vs2, vs3
; CHECK-P9-NEXT:    xxmrghd vs0, vs0, vs1
; CHECK-P9-NEXT:    xxmrghd vs4, vs5, vs4
; CHECK-P9-NEXT:    xxmrghd vs3, vs7, vs6
; CHECK-P9-NEXT:    xvcvdpsp v3, vs2
; CHECK-P9-NEXT:    xvcvdpsp v5, vs0
; CHECK-P9-NEXT:    xvcvdpsp v2, vs4
; CHECK-P9-NEXT:    xvcvdpsp v4, vs3
; CHECK-P9-NEXT:    vmrgew v2, v3, v2
; CHECK-P9-NEXT:    vmrgew v3, v5, v4
; CHECK-P9-NEXT:    stxv v3, 16(r3)
; CHECK-P9-NEXT:    stxv v2, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs0, 32(r4)
; CHECK-BE-NEXT:    lxv vs1, 48(r4)
; CHECK-BE-NEXT:    lxv vs2, 0(r4)
; CHECK-BE-NEXT:    lxv vs3, 16(r4)
; CHECK-BE-NEXT:    xxswapd vs4, vs3
; CHECK-BE-NEXT:    xxswapd vs5, vs2
; CHECK-BE-NEXT:    xxswapd vs6, vs1
; CHECK-BE-NEXT:    xxswapd vs7, vs0
; CHECK-BE-NEXT:    xscvsxdsp f3, f3
; CHECK-BE-NEXT:    xscvsxdsp f2, f2
; CHECK-BE-NEXT:    xscvsxdsp f1, f1
; CHECK-BE-NEXT:    xscvsxdsp f0, f0
; CHECK-BE-NEXT:    xscvsxdsp f4, f4
; CHECK-BE-NEXT:    xscvsxdsp f5, f5
; CHECK-BE-NEXT:    xscvsxdsp f6, f6
; CHECK-BE-NEXT:    xscvsxdsp f7, f7
; CHECK-BE-NEXT:    xxmrghd vs2, vs2, vs3
; CHECK-BE-NEXT:    xxmrghd vs0, vs0, vs1
; CHECK-BE-NEXT:    xxmrghd vs3, vs5, vs4
; CHECK-BE-NEXT:    xxmrghd vs1, vs7, vs6
; CHECK-BE-NEXT:    xvcvdpsp v2, vs2
; CHECK-BE-NEXT:    xvcvdpsp v4, vs0
; CHECK-BE-NEXT:    xvcvdpsp v3, vs3
; CHECK-BE-NEXT:    xvcvdpsp v5, vs1
; CHECK-BE-NEXT:    vmrgew v2, v2, v3
; CHECK-BE-NEXT:    vmrgew v3, v4, v5
; CHECK-BE-NEXT:    stxv v3, 16(r3)
; CHECK-BE-NEXT:    stxv v2, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <8 x i64>, <8 x i64>* %0, align 64
  %1 = sitofp <8 x i64> %a to <8 x float>
  store <8 x float> %1, <8 x float>* %agg.result, align 32
  ret void
}

define void @test16elt_signed(<16 x float>* noalias nocapture sret %agg.result, <16 x i64>* nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test16elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r7, 64
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    li r6, 48
; CHECK-P8-NEXT:    lxvd2x vs11, 0, r4
; CHECK-P8-NEXT:    stfd f30, -16(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    lxvd2x vs8, r4, r7
; CHECK-P8-NEXT:    li r7, 80
; CHECK-P8-NEXT:    lxvd2x vs6, r4, r5
; CHECK-P8-NEXT:    stfd f31, -8(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    lxvd2x vs7, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r7
; CHECK-P8-NEXT:    li r7, 96
; CHECK-P8-NEXT:    lxvd2x vs3, r4, r7
; CHECK-P8-NEXT:    li r7, 112
; CHECK-P8-NEXT:    xscvsxdsp f30, f11
; CHECK-P8-NEXT:    xxswapd vs11, vs11
; CHECK-P8-NEXT:    lxvd2x vs4, r4, r7
; CHECK-P8-NEXT:    li r7, 16
; CHECK-P8-NEXT:    xscvsxdsp f0, f6
; CHECK-P8-NEXT:    xxswapd vs6, vs6
; CHECK-P8-NEXT:    xscvsxdsp f1, f7
; CHECK-P8-NEXT:    lxvd2x vs9, r4, r7
; CHECK-P8-NEXT:    xxswapd vs7, vs7
; CHECK-P8-NEXT:    xscvsxdsp f5, f8
; CHECK-P8-NEXT:    xxswapd vs8, vs8
; CHECK-P8-NEXT:    xscvsxdsp f10, f2
; CHECK-P8-NEXT:    xxswapd vs2, vs2
; CHECK-P8-NEXT:    xscvsxdsp f12, f3
; CHECK-P8-NEXT:    xxswapd vs3, vs3
; CHECK-P8-NEXT:    xscvsxdsp f13, f4
; CHECK-P8-NEXT:    xxswapd vs4, vs4
; CHECK-P8-NEXT:    xscvsxdsp f31, f9
; CHECK-P8-NEXT:    xxswapd vs9, vs9
; CHECK-P8-NEXT:    xscvsxdsp f6, f6
; CHECK-P8-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P8-NEXT:    xscvsxdsp f7, f7
; CHECK-P8-NEXT:    xscvsxdsp f8, f8
; CHECK-P8-NEXT:    xxmrghd vs5, vs10, vs5
; CHECK-P8-NEXT:    xscvsxdsp f2, f2
; CHECK-P8-NEXT:    xscvsxdsp f3, f3
; CHECK-P8-NEXT:    xxmrghd vs10, vs13, vs12
; CHECK-P8-NEXT:    xscvsxdsp f4, f4
; CHECK-P8-NEXT:    xscvsxdsp f1, f9
; CHECK-P8-NEXT:    xscvsxdsp f9, f11
; CHECK-P8-NEXT:    xxmrghd vs11, vs31, vs30
; CHECK-P8-NEXT:    lfd f31, -8(r1) # 8-byte Folded Reload
; CHECK-P8-NEXT:    lfd f30, -16(r1) # 8-byte Folded Reload
; CHECK-P8-NEXT:    xvcvdpsp v2, vs0
; CHECK-P8-NEXT:    xxmrghd vs0, vs7, vs6
; CHECK-P8-NEXT:    xxmrghd vs2, vs2, vs8
; CHECK-P8-NEXT:    xvcvdpsp v3, vs5
; CHECK-P8-NEXT:    xvcvdpsp v4, vs10
; CHECK-P8-NEXT:    xxmrghd vs3, vs4, vs3
; CHECK-P8-NEXT:    xvcvdpsp v5, vs11
; CHECK-P8-NEXT:    xvcvdpsp v0, vs0
; CHECK-P8-NEXT:    xxmrghd vs1, vs1, vs9
; CHECK-P8-NEXT:    xvcvdpsp v1, vs2
; CHECK-P8-NEXT:    xvcvdpsp v6, vs3
; CHECK-P8-NEXT:    xvcvdpsp v7, vs1
; CHECK-P8-NEXT:    vmrgew v2, v0, v2
; CHECK-P8-NEXT:    vmrgew v3, v1, v3
; CHECK-P8-NEXT:    vmrgew v4, v6, v4
; CHECK-P8-NEXT:    vmrgew v5, v7, v5
; CHECK-P8-NEXT:    stvx v2, r3, r7
; CHECK-P8-NEXT:    stvx v3, r3, r5
; CHECK-P8-NEXT:    stvx v4, r3, r6
; CHECK-P8-NEXT:    stvx v5, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs4, 48(r4)
; CHECK-P9-NEXT:    lxv vs5, 32(r4)
; CHECK-P9-NEXT:    lxv vs6, 16(r4)
; CHECK-P9-NEXT:    lxv vs7, 0(r4)
; CHECK-P9-NEXT:    lxv vs8, 112(r4)
; CHECK-P9-NEXT:    lxv vs9, 96(r4)
; CHECK-P9-NEXT:    lxv vs10, 80(r4)
; CHECK-P9-NEXT:    lxv vs11, 64(r4)
; CHECK-P9-NEXT:    stfd f30, -16(r1) # 8-byte Folded Spill
; CHECK-P9-NEXT:    stfd f31, -8(r1) # 8-byte Folded Spill
; CHECK-P9-NEXT:    xxswapd vs0, vs7
; CHECK-P9-NEXT:    xxswapd vs1, vs6
; CHECK-P9-NEXT:    xxswapd vs2, vs5
; CHECK-P9-NEXT:    xxswapd vs3, vs4
; CHECK-P9-NEXT:    xxswapd vs12, vs11
; CHECK-P9-NEXT:    xxswapd vs13, vs10
; CHECK-P9-NEXT:    xxswapd vs31, vs9
; CHECK-P9-NEXT:    xxswapd vs30, vs8
; CHECK-P9-NEXT:    xscvsxdsp f7, f7
; CHECK-P9-NEXT:    xscvsxdsp f6, f6
; CHECK-P9-NEXT:    xscvsxdsp f5, f5
; CHECK-P9-NEXT:    xscvsxdsp f4, f4
; CHECK-P9-NEXT:    xscvsxdsp f11, f11
; CHECK-P9-NEXT:    xscvsxdsp f10, f10
; CHECK-P9-NEXT:    xscvsxdsp f9, f9
; CHECK-P9-NEXT:    xscvsxdsp f8, f8
; CHECK-P9-NEXT:    xscvsxdsp f0, f0
; CHECK-P9-NEXT:    xscvsxdsp f1, f1
; CHECK-P9-NEXT:    xscvsxdsp f2, f2
; CHECK-P9-NEXT:    xscvsxdsp f3, f3
; CHECK-P9-NEXT:    xscvsxdsp f12, f12
; CHECK-P9-NEXT:    xscvsxdsp f13, f13
; CHECK-P9-NEXT:    xscvsxdsp f31, f31
; CHECK-P9-NEXT:    xscvsxdsp f30, f30
; CHECK-P9-NEXT:    xxmrghd vs6, vs6, vs7
; CHECK-P9-NEXT:    xxmrghd vs4, vs4, vs5
; CHECK-P9-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P9-NEXT:    xxmrghd vs1, vs3, vs2
; CHECK-P9-NEXT:    xxmrghd vs2, vs10, vs11
; CHECK-P9-NEXT:    xxmrghd vs3, vs8, vs9
; CHECK-P9-NEXT:    xxmrghd vs5, vs13, vs12
; CHECK-P9-NEXT:    xxmrghd vs7, vs30, vs31
; CHECK-P9-NEXT:    lfd f31, -8(r1) # 8-byte Folded Reload
; CHECK-P9-NEXT:    lfd f30, -16(r1) # 8-byte Folded Reload
; CHECK-P9-NEXT:    xvcvdpsp v2, vs6
; CHECK-P9-NEXT:    xvcvdpsp v3, vs4
; CHECK-P9-NEXT:    xvcvdpsp v4, vs0
; CHECK-P9-NEXT:    xvcvdpsp v5, vs1
; CHECK-P9-NEXT:    xvcvdpsp v0, vs5
; CHECK-P9-NEXT:    xvcvdpsp v1, vs2
; CHECK-P9-NEXT:    xvcvdpsp v6, vs7
; CHECK-P9-NEXT:    xvcvdpsp v7, vs3
; CHECK-P9-NEXT:    vmrgew v2, v2, v4
; CHECK-P9-NEXT:    vmrgew v3, v3, v5
; CHECK-P9-NEXT:    vmrgew v4, v1, v0
; CHECK-P9-NEXT:    vmrgew v5, v7, v6
; CHECK-P9-NEXT:    stxv v4, 32(r3)
; CHECK-P9-NEXT:    stxv v3, 16(r3)
; CHECK-P9-NEXT:    stxv v2, 0(r3)
; CHECK-P9-NEXT:    stxv v5, 48(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs2, 32(r4)
; CHECK-BE-NEXT:    lxv vs3, 48(r4)
; CHECK-BE-NEXT:    lxv vs4, 0(r4)
; CHECK-BE-NEXT:    lxv vs5, 16(r4)
; CHECK-BE-NEXT:    lxv vs6, 96(r4)
; CHECK-BE-NEXT:    lxv vs7, 112(r4)
; CHECK-BE-NEXT:    lxv vs8, 64(r4)
; CHECK-BE-NEXT:    lxv vs9, 80(r4)
; CHECK-BE-NEXT:    stfd f30, -16(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stfd f31, -8(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    xxswapd vs0, vs5
; CHECK-BE-NEXT:    xxswapd vs1, vs4
; CHECK-BE-NEXT:    xxswapd vs10, vs3
; CHECK-BE-NEXT:    xxswapd vs11, vs2
; CHECK-BE-NEXT:    xxswapd vs12, vs9
; CHECK-BE-NEXT:    xxswapd vs13, vs8
; CHECK-BE-NEXT:    xxswapd vs31, vs7
; CHECK-BE-NEXT:    xxswapd vs30, vs6
; CHECK-BE-NEXT:    xscvsxdsp f5, f5
; CHECK-BE-NEXT:    xscvsxdsp f4, f4
; CHECK-BE-NEXT:    xscvsxdsp f3, f3
; CHECK-BE-NEXT:    xscvsxdsp f2, f2
; CHECK-BE-NEXT:    xscvsxdsp f9, f9
; CHECK-BE-NEXT:    xscvsxdsp f8, f8
; CHECK-BE-NEXT:    xscvsxdsp f7, f7
; CHECK-BE-NEXT:    xscvsxdsp f6, f6
; CHECK-BE-NEXT:    xscvsxdsp f0, f0
; CHECK-BE-NEXT:    xscvsxdsp f1, f1
; CHECK-BE-NEXT:    xscvsxdsp f10, f10
; CHECK-BE-NEXT:    xscvsxdsp f11, f11
; CHECK-BE-NEXT:    xscvsxdsp f12, f12
; CHECK-BE-NEXT:    xscvsxdsp f13, f13
; CHECK-BE-NEXT:    xscvsxdsp f31, f31
; CHECK-BE-NEXT:    xscvsxdsp f30, f30
; CHECK-BE-NEXT:    xxmrghd vs4, vs4, vs5
; CHECK-BE-NEXT:    xxmrghd vs2, vs2, vs3
; CHECK-BE-NEXT:    xxmrghd vs3, vs8, vs9
; CHECK-BE-NEXT:    xxmrghd vs5, vs6, vs7
; CHECK-BE-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-BE-NEXT:    xxmrghd vs1, vs11, vs10
; CHECK-BE-NEXT:    xxmrghd vs6, vs13, vs12
; CHECK-BE-NEXT:    xxmrghd vs7, vs30, vs31
; CHECK-BE-NEXT:    lfd f31, -8(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f30, -16(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    xvcvdpsp v2, vs4
; CHECK-BE-NEXT:    xvcvdpsp v3, vs2
; CHECK-BE-NEXT:    xvcvdpsp v0, vs3
; CHECK-BE-NEXT:    xvcvdpsp v6, vs5
; CHECK-BE-NEXT:    xvcvdpsp v4, vs0
; CHECK-BE-NEXT:    xvcvdpsp v5, vs1
; CHECK-BE-NEXT:    xvcvdpsp v1, vs6
; CHECK-BE-NEXT:    xvcvdpsp v7, vs7
; CHECK-BE-NEXT:    vmrgew v2, v2, v4
; CHECK-BE-NEXT:    vmrgew v3, v3, v5
; CHECK-BE-NEXT:    vmrgew v4, v0, v1
; CHECK-BE-NEXT:    vmrgew v5, v6, v7
; CHECK-BE-NEXT:    stxv v5, 48(r3)
; CHECK-BE-NEXT:    stxv v4, 32(r3)
; CHECK-BE-NEXT:    stxv v3, 16(r3)
; CHECK-BE-NEXT:    stxv v2, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x i64>, <16 x i64>* %0, align 128
  %1 = sitofp <16 x i64> %a to <16 x float>
  store <16 x float> %1, <16 x float>* %agg.result, align 64
  ret void
}