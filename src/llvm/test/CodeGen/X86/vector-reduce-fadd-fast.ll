; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=ALL --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=ALL --check-prefix=SSE --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512bw | FileCheck %s --check-prefix=ALL --check-prefix=AVX512 --check-prefix=AVX512BW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512bw,+avx512vl | FileCheck %s --check-prefix=ALL --check-prefix=AVX512 --check-prefix=AVX512VL

;
; vXf32 (accum)
;

define float @test_v2f32(float %a0, <2 x float> %a1) {
; SSE2-LABEL: test_v2f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1],xmm1[2,3]
; SSE2-NEXT:    addps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v2f32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movaps %xmm1, %xmm0
; SSE41-NEXT:    haddps %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v2f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm1, %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v2f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vhaddps %xmm1, %xmm1, %xmm0
; AVX512-NEXT:    retq
  %1 = call fast float @llvm.experimental.vector.reduce.fadd.f32.f32.v2f32(float %a0, <2 x float> %a1)
  ret float %1
}

define float @test_v4f32(float %a0, <4 x float> %a1) {
; SSE2-LABEL: test_v4f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps %xmm1, %xmm2
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm2 = xmm2[1],xmm1[1]
; SSE2-NEXT:    addps %xmm1, %xmm2
; SSE2-NEXT:    movaps %xmm2, %xmm0
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1],xmm2[2,3]
; SSE2-NEXT:    addps %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v4f32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movaps %xmm1, %xmm0
; SSE41-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; SSE41-NEXT:    addps %xmm1, %xmm0
; SSE41-NEXT:    haddps %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilpd {{.*#+}} xmm0 = xmm1[1,0]
; AVX-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v4f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpermilpd {{.*#+}} xmm0 = xmm1[1,0]
; AVX512-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; AVX512-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = call fast float @llvm.experimental.vector.reduce.fadd.f32.f32.v4f32(float %a0, <4 x float> %a1)
  ret float %1
}

define float @test_v8f32(float %a0, <8 x float> %a1) {
; SSE2-LABEL: test_v8f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addps %xmm2, %xmm1
; SSE2-NEXT:    movaps %xmm1, %xmm2
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm2 = xmm2[1],xmm1[1]
; SSE2-NEXT:    addps %xmm1, %xmm2
; SSE2-NEXT:    movaps %xmm2, %xmm0
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1],xmm2[2,3]
; SSE2-NEXT:    addps %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v8f32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    addps %xmm2, %xmm1
; SSE41-NEXT:    movaps %xmm1, %xmm0
; SSE41-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; SSE41-NEXT:    addps %xmm1, %xmm0
; SSE41-NEXT:    haddps %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm1, %xmm0
; AVX-NEXT:    vaddps %ymm0, %ymm1, %ymm0
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vhaddps %ymm0, %ymm0, %ymm0
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v8f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextractf128 $1, %ymm1, %xmm0
; AVX512-NEXT:    vaddps %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vhaddps %ymm0, %ymm0, %ymm0
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call fast float @llvm.experimental.vector.reduce.fadd.f32.f32.v8f32(float %a0, <8 x float> %a1)
  ret float %1
}

define float @test_v16f32(float %a0, <16 x float> %a1) {
; SSE2-LABEL: test_v16f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addps %xmm4, %xmm2
; SSE2-NEXT:    addps %xmm3, %xmm1
; SSE2-NEXT:    addps %xmm2, %xmm1
; SSE2-NEXT:    movaps %xmm1, %xmm2
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm2 = xmm2[1],xmm1[1]
; SSE2-NEXT:    addps %xmm1, %xmm2
; SSE2-NEXT:    movaps %xmm2, %xmm0
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1],xmm2[2,3]
; SSE2-NEXT:    addps %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v16f32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    addps %xmm4, %xmm2
; SSE41-NEXT:    addps %xmm3, %xmm1
; SSE41-NEXT:    addps %xmm2, %xmm1
; SSE41-NEXT:    movaps %xmm1, %xmm0
; SSE41-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; SSE41-NEXT:    addps %xmm1, %xmm0
; SSE41-NEXT:    haddps %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v16f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddps %ymm2, %ymm1, %ymm0
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vhaddps %ymm0, %ymm0, %ymm0
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v16f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextractf64x4 $1, %zmm1, %ymm0
; AVX512-NEXT:    vaddps %zmm0, %zmm1, %zmm0
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vaddps %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vaddps %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX512-NEXT:    vaddps %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call fast float @llvm.experimental.vector.reduce.fadd.f32.f32.v16f32(float %a0, <16 x float> %a1)
  ret float %1
}

;
; vXf32 (zero)
;

define float @test_v2f32_zero(<2 x float> %a0) {
; SSE2-LABEL: test_v2f32_zero:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[1,1],xmm0[2,3]
; SSE2-NEXT:    addps %xmm0, %xmm1
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v2f32_zero:
; SSE41:       # %bb.0:
; SSE41-NEXT:    haddps %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v2f32_zero:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v2f32_zero:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = call fast float @llvm.experimental.vector.reduce.fadd.f32.f32.v2f32(float 0.0, <2 x float> %a0)
  ret float %1
}

define float @test_v4f32_zero(<4 x float> %a0) {
; SSE2-LABEL: test_v4f32_zero:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    addps %xmm0, %xmm1
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1],xmm1[2,3]
; SSE2-NEXT:    addps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v4f32_zero:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movaps %xmm0, %xmm1
; SSE41-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE41-NEXT:    addps %xmm0, %xmm1
; SSE41-NEXT:    haddps %xmm1, %xmm1
; SSE41-NEXT:    movaps %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v4f32_zero:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v4f32_zero:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = call fast float @llvm.experimental.vector.reduce.fadd.f32.f32.v4f32(float 0.0, <4 x float> %a0)
  ret float %1
}

define float @test_v8f32_zero(<8 x float> %a0) {
; SSE2-LABEL: test_v8f32_zero:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addps %xmm1, %xmm0
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    addps %xmm0, %xmm1
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1],xmm1[2,3]
; SSE2-NEXT:    addps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v8f32_zero:
; SSE41:       # %bb.0:
; SSE41-NEXT:    addps %xmm1, %xmm0
; SSE41-NEXT:    movaps %xmm0, %xmm1
; SSE41-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE41-NEXT:    addps %xmm0, %xmm1
; SSE41-NEXT:    haddps %xmm1, %xmm1
; SSE41-NEXT:    movaps %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v8f32_zero:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vhaddps %ymm0, %ymm0, %ymm0
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v8f32_zero:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vhaddps %ymm0, %ymm0, %ymm0
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call fast float @llvm.experimental.vector.reduce.fadd.f32.f32.v8f32(float 0.0, <8 x float> %a0)
  ret float %1
}

define float @test_v16f32_zero(<16 x float> %a0) {
; SSE2-LABEL: test_v16f32_zero:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addps %xmm3, %xmm1
; SSE2-NEXT:    addps %xmm2, %xmm0
; SSE2-NEXT:    addps %xmm1, %xmm0
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    addps %xmm0, %xmm1
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1],xmm1[2,3]
; SSE2-NEXT:    addps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v16f32_zero:
; SSE41:       # %bb.0:
; SSE41-NEXT:    addps %xmm3, %xmm1
; SSE41-NEXT:    addps %xmm2, %xmm0
; SSE41-NEXT:    addps %xmm1, %xmm0
; SSE41-NEXT:    movaps %xmm0, %xmm1
; SSE41-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE41-NEXT:    addps %xmm0, %xmm1
; SSE41-NEXT:    haddps %xmm1, %xmm1
; SSE41-NEXT:    movaps %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v16f32_zero:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vhaddps %ymm0, %ymm0, %ymm0
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v16f32_zero:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextractf64x4 $1, %zmm0, %ymm1
; AVX512-NEXT:    vaddps %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vaddps %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vaddps %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX512-NEXT:    vaddps %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call fast float @llvm.experimental.vector.reduce.fadd.f32.f32.v16f32(float 0.0, <16 x float> %a0)
  ret float %1
}

;
; vXf32 (undef)
;

define float @test_v2f32_undef(<2 x float> %a0) {
; SSE2-LABEL: test_v2f32_undef:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[1,1],xmm0[2,3]
; SSE2-NEXT:    addps %xmm0, %xmm1
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v2f32_undef:
; SSE41:       # %bb.0:
; SSE41-NEXT:    haddps %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v2f32_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v2f32_undef:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = call fast float @llvm.experimental.vector.reduce.fadd.f32.f32.v2f32(float undef, <2 x float> %a0)
  ret float %1
}

define float @test_v4f32_undef(<4 x float> %a0) {
; SSE2-LABEL: test_v4f32_undef:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    addps %xmm0, %xmm1
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1],xmm1[2,3]
; SSE2-NEXT:    addps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v4f32_undef:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movaps %xmm0, %xmm1
; SSE41-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE41-NEXT:    addps %xmm0, %xmm1
; SSE41-NEXT:    haddps %xmm1, %xmm1
; SSE41-NEXT:    movaps %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v4f32_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v4f32_undef:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = call fast float @llvm.experimental.vector.reduce.fadd.f32.f32.v4f32(float undef, <4 x float> %a0)
  ret float %1
}

define float @test_v8f32_undef(<8 x float> %a0) {
; SSE2-LABEL: test_v8f32_undef:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addps %xmm1, %xmm0
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    addps %xmm0, %xmm1
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1],xmm1[2,3]
; SSE2-NEXT:    addps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v8f32_undef:
; SSE41:       # %bb.0:
; SSE41-NEXT:    addps %xmm1, %xmm0
; SSE41-NEXT:    movaps %xmm0, %xmm1
; SSE41-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE41-NEXT:    addps %xmm0, %xmm1
; SSE41-NEXT:    haddps %xmm1, %xmm1
; SSE41-NEXT:    movaps %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v8f32_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vhaddps %ymm0, %ymm0, %ymm0
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v8f32_undef:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vhaddps %ymm0, %ymm0, %ymm0
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call fast float @llvm.experimental.vector.reduce.fadd.f32.f32.v8f32(float undef, <8 x float> %a0)
  ret float %1
}

define float @test_v16f32_undef(<16 x float> %a0) {
; SSE2-LABEL: test_v16f32_undef:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addps %xmm3, %xmm1
; SSE2-NEXT:    addps %xmm2, %xmm0
; SSE2-NEXT:    addps %xmm1, %xmm0
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    addps %xmm0, %xmm1
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1],xmm1[2,3]
; SSE2-NEXT:    addps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v16f32_undef:
; SSE41:       # %bb.0:
; SSE41-NEXT:    addps %xmm3, %xmm1
; SSE41-NEXT:    addps %xmm2, %xmm0
; SSE41-NEXT:    addps %xmm1, %xmm0
; SSE41-NEXT:    movaps %xmm0, %xmm1
; SSE41-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE41-NEXT:    addps %xmm0, %xmm1
; SSE41-NEXT:    haddps %xmm1, %xmm1
; SSE41-NEXT:    movaps %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v16f32_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vhaddps %ymm0, %ymm0, %ymm0
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v16f32_undef:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextractf64x4 $1, %zmm0, %ymm1
; AVX512-NEXT:    vaddps %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vaddps %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vaddps %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX512-NEXT:    vaddps %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call fast float @llvm.experimental.vector.reduce.fadd.f32.f32.v16f32(float undef, <16 x float> %a0)
  ret float %1
}

;
; vXf64 (accum)
;

define double @test_v2f64(double %a0, <2 x double> %a1) {
; SSE2-LABEL: test_v2f64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; SSE2-NEXT:    addpd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v2f64:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movapd %xmm1, %xmm0
; SSE41-NEXT:    haddpd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddpd %xmm1, %xmm1, %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v2f64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vhaddpd %xmm1, %xmm1, %xmm0
; AVX512-NEXT:    retq
  %1 = call fast double @llvm.experimental.vector.reduce.fadd.f64.f64.v2f64(double %a0, <2 x double> %a1)
  ret double %1
}

define double @test_v4f64(double %a0, <4 x double> %a1) {
; SSE2-LABEL: test_v4f64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addpd %xmm2, %xmm1
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; SSE2-NEXT:    addpd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v4f64:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movapd %xmm1, %xmm0
; SSE41-NEXT:    addpd %xmm2, %xmm0
; SSE41-NEXT:    haddpd %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm1, %xmm0
; AVX-NEXT:    vaddpd %ymm0, %ymm1, %ymm0
; AVX-NEXT:    vhaddpd %ymm0, %ymm0, %ymm0
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v4f64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextractf128 $1, %ymm1, %xmm0
; AVX512-NEXT:    vaddpd %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    vhaddpd %ymm0, %ymm0, %ymm0
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call fast double @llvm.experimental.vector.reduce.fadd.f64.f64.v4f64(double %a0, <4 x double> %a1)
  ret double %1
}

define double @test_v8f64(double %a0, <8 x double> %a1) {
; SSE2-LABEL: test_v8f64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addpd %xmm4, %xmm2
; SSE2-NEXT:    addpd %xmm3, %xmm1
; SSE2-NEXT:    addpd %xmm2, %xmm1
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; SSE2-NEXT:    addpd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v8f64:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movapd %xmm1, %xmm0
; SSE41-NEXT:    addpd %xmm4, %xmm2
; SSE41-NEXT:    addpd %xmm3, %xmm0
; SSE41-NEXT:    addpd %xmm2, %xmm0
; SSE41-NEXT:    haddpd %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v8f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddpd %ymm2, %ymm1, %ymm0
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vhaddpd %ymm0, %ymm0, %ymm0
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v8f64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextractf64x4 $1, %zmm1, %ymm0
; AVX512-NEXT:    vaddpd %zmm0, %zmm1, %zmm0
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call fast double @llvm.experimental.vector.reduce.fadd.f64.f64.v8f64(double %a0, <8 x double> %a1)
  ret double %1
}

define double @test_v16f64(double %a0, <16 x double> %a1) {
; SSE2-LABEL: test_v16f64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addpd %xmm6, %xmm2
; SSE2-NEXT:    addpd %xmm7, %xmm3
; SSE2-NEXT:    addpd %xmm5, %xmm1
; SSE2-NEXT:    addpd %xmm3, %xmm1
; SSE2-NEXT:    addpd {{[0-9]+}}(%rsp), %xmm4
; SSE2-NEXT:    addpd %xmm2, %xmm4
; SSE2-NEXT:    addpd %xmm1, %xmm4
; SSE2-NEXT:    movapd %xmm4, %xmm0
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm4[1]
; SSE2-NEXT:    addpd %xmm4, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v16f64:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movapd %xmm4, %xmm0
; SSE41-NEXT:    addpd %xmm6, %xmm2
; SSE41-NEXT:    addpd %xmm7, %xmm3
; SSE41-NEXT:    addpd %xmm5, %xmm1
; SSE41-NEXT:    addpd %xmm3, %xmm1
; SSE41-NEXT:    addpd {{[0-9]+}}(%rsp), %xmm0
; SSE41-NEXT:    addpd %xmm2, %xmm0
; SSE41-NEXT:    addpd %xmm1, %xmm0
; SSE41-NEXT:    haddpd %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v16f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddpd %ymm4, %ymm2, %ymm0
; AVX-NEXT:    vaddpd %ymm3, %ymm1, %ymm1
; AVX-NEXT:    vaddpd %ymm0, %ymm1, %ymm0
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vhaddpd %ymm0, %ymm0, %ymm0
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v16f64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vaddpd %zmm2, %zmm1, %zmm0
; AVX512-NEXT:    vextractf64x4 $1, %zmm0, %ymm1
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call fast double @llvm.experimental.vector.reduce.fadd.f64.f64.v16f64(double %a0, <16 x double> %a1)
  ret double %1
}

;
; vXf64 (zero)
;

define double @test_v2f64_zero(<2 x double> %a0) {
; SSE2-LABEL: test_v2f64_zero:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movapd %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    addpd %xmm0, %xmm1
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v2f64_zero:
; SSE41:       # %bb.0:
; SSE41-NEXT:    haddpd %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v2f64_zero:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddpd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v2f64_zero:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vhaddpd %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = call fast double @llvm.experimental.vector.reduce.fadd.f64.f64.v2f64(double 0.0, <2 x double> %a0)
  ret double %1
}

define double @test_v4f64_zero(<4 x double> %a0) {
; SSE2-LABEL: test_v4f64_zero:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addpd %xmm1, %xmm0
; SSE2-NEXT:    movapd %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    addpd %xmm0, %xmm1
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v4f64_zero:
; SSE41:       # %bb.0:
; SSE41-NEXT:    addpd %xmm1, %xmm0
; SSE41-NEXT:    haddpd %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v4f64_zero:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vhaddpd %ymm0, %ymm0, %ymm0
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v4f64_zero:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vhaddpd %ymm0, %ymm0, %ymm0
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call fast double @llvm.experimental.vector.reduce.fadd.f64.f64.v4f64(double 0.0, <4 x double> %a0)
  ret double %1
}

define double @test_v8f64_zero(<8 x double> %a0) {
; SSE2-LABEL: test_v8f64_zero:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addpd %xmm3, %xmm1
; SSE2-NEXT:    addpd %xmm2, %xmm0
; SSE2-NEXT:    addpd %xmm1, %xmm0
; SSE2-NEXT:    movapd %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    addpd %xmm0, %xmm1
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v8f64_zero:
; SSE41:       # %bb.0:
; SSE41-NEXT:    addpd %xmm3, %xmm1
; SSE41-NEXT:    addpd %xmm2, %xmm0
; SSE41-NEXT:    addpd %xmm1, %xmm0
; SSE41-NEXT:    haddpd %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v8f64_zero:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vhaddpd %ymm0, %ymm0, %ymm0
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v8f64_zero:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextractf64x4 $1, %zmm0, %ymm1
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call fast double @llvm.experimental.vector.reduce.fadd.f64.f64.v8f64(double 0.0, <8 x double> %a0)
  ret double %1
}

define double @test_v16f64_zero(<16 x double> %a0) {
; SSE2-LABEL: test_v16f64_zero:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addpd %xmm6, %xmm2
; SSE2-NEXT:    addpd %xmm4, %xmm0
; SSE2-NEXT:    addpd %xmm2, %xmm0
; SSE2-NEXT:    addpd %xmm7, %xmm3
; SSE2-NEXT:    addpd %xmm5, %xmm1
; SSE2-NEXT:    addpd %xmm3, %xmm1
; SSE2-NEXT:    addpd %xmm0, %xmm1
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; SSE2-NEXT:    addpd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v16f64_zero:
; SSE41:       # %bb.0:
; SSE41-NEXT:    addpd %xmm6, %xmm2
; SSE41-NEXT:    addpd %xmm4, %xmm0
; SSE41-NEXT:    addpd %xmm2, %xmm0
; SSE41-NEXT:    addpd %xmm7, %xmm3
; SSE41-NEXT:    addpd %xmm5, %xmm1
; SSE41-NEXT:    addpd %xmm3, %xmm1
; SSE41-NEXT:    addpd %xmm0, %xmm1
; SSE41-NEXT:    haddpd %xmm1, %xmm1
; SSE41-NEXT:    movapd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v16f64_zero:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddpd %ymm3, %ymm1, %ymm1
; AVX-NEXT:    vaddpd %ymm2, %ymm0, %ymm0
; AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vhaddpd %ymm0, %ymm0, %ymm0
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v16f64_zero:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vextractf64x4 $1, %zmm0, %ymm1
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call fast double @llvm.experimental.vector.reduce.fadd.f64.f64.v16f64(double 0.0, <16 x double> %a0)
  ret double %1
}

;
; vXf64 (undef)
;

define double @test_v2f64_undef(<2 x double> %a0) {
; SSE2-LABEL: test_v2f64_undef:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movapd %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    addpd %xmm0, %xmm1
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v2f64_undef:
; SSE41:       # %bb.0:
; SSE41-NEXT:    haddpd %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v2f64_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddpd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v2f64_undef:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vhaddpd %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = call fast double @llvm.experimental.vector.reduce.fadd.f64.f64.v2f64(double undef, <2 x double> %a0)
  ret double %1
}

define double @test_v4f64_undef(<4 x double> %a0) {
; SSE2-LABEL: test_v4f64_undef:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addpd %xmm1, %xmm0
; SSE2-NEXT:    movapd %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    addpd %xmm0, %xmm1
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v4f64_undef:
; SSE41:       # %bb.0:
; SSE41-NEXT:    addpd %xmm1, %xmm0
; SSE41-NEXT:    haddpd %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v4f64_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vhaddpd %ymm0, %ymm0, %ymm0
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v4f64_undef:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vhaddpd %ymm0, %ymm0, %ymm0
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call fast double @llvm.experimental.vector.reduce.fadd.f64.f64.v4f64(double undef, <4 x double> %a0)
  ret double %1
}

define double @test_v8f64_undef(<8 x double> %a0) {
; SSE2-LABEL: test_v8f64_undef:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addpd %xmm3, %xmm1
; SSE2-NEXT:    addpd %xmm2, %xmm0
; SSE2-NEXT:    addpd %xmm1, %xmm0
; SSE2-NEXT:    movapd %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    addpd %xmm0, %xmm1
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v8f64_undef:
; SSE41:       # %bb.0:
; SSE41-NEXT:    addpd %xmm3, %xmm1
; SSE41-NEXT:    addpd %xmm2, %xmm0
; SSE41-NEXT:    addpd %xmm1, %xmm0
; SSE41-NEXT:    haddpd %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v8f64_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vhaddpd %ymm0, %ymm0, %ymm0
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v8f64_undef:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextractf64x4 $1, %zmm0, %ymm1
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call fast double @llvm.experimental.vector.reduce.fadd.f64.f64.v8f64(double undef, <8 x double> %a0)
  ret double %1
}

define double @test_v16f64_undef(<16 x double> %a0) {
; SSE2-LABEL: test_v16f64_undef:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addpd %xmm6, %xmm2
; SSE2-NEXT:    addpd %xmm4, %xmm0
; SSE2-NEXT:    addpd %xmm2, %xmm0
; SSE2-NEXT:    addpd %xmm7, %xmm3
; SSE2-NEXT:    addpd %xmm5, %xmm1
; SSE2-NEXT:    addpd %xmm3, %xmm1
; SSE2-NEXT:    addpd %xmm0, %xmm1
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; SSE2-NEXT:    addpd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v16f64_undef:
; SSE41:       # %bb.0:
; SSE41-NEXT:    addpd %xmm6, %xmm2
; SSE41-NEXT:    addpd %xmm4, %xmm0
; SSE41-NEXT:    addpd %xmm2, %xmm0
; SSE41-NEXT:    addpd %xmm7, %xmm3
; SSE41-NEXT:    addpd %xmm5, %xmm1
; SSE41-NEXT:    addpd %xmm3, %xmm1
; SSE41-NEXT:    addpd %xmm0, %xmm1
; SSE41-NEXT:    haddpd %xmm1, %xmm1
; SSE41-NEXT:    movapd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v16f64_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddpd %ymm3, %ymm1, %ymm1
; AVX-NEXT:    vaddpd %ymm2, %ymm0, %ymm0
; AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vhaddpd %ymm0, %ymm0, %ymm0
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v16f64_undef:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vextractf64x4 $1, %zmm0, %ymm1
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call fast double @llvm.experimental.vector.reduce.fadd.f64.f64.v16f64(double undef, <16 x double> %a0)
  ret double %1
}

declare float @llvm.experimental.vector.reduce.fadd.f32.f32.v2f32(float, <2 x float>)
declare float @llvm.experimental.vector.reduce.fadd.f32.f32.v4f32(float, <4 x float>)
declare float @llvm.experimental.vector.reduce.fadd.f32.f32.v8f32(float, <8 x float>)
declare float @llvm.experimental.vector.reduce.fadd.f32.f32.v16f32(float, <16 x float>)

declare double @llvm.experimental.vector.reduce.fadd.f64.f64.v2f64(double, <2 x double>)
declare double @llvm.experimental.vector.reduce.fadd.f64.f64.v4f64(double, <4 x double>)
declare double @llvm.experimental.vector.reduce.fadd.f64.f64.v8f64(double, <8 x double>)
declare double @llvm.experimental.vector.reduce.fadd.f64.f64.v16f64(double, <16 x double>)
