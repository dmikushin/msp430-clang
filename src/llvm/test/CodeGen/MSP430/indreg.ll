; RUN: llc < %s -march=msp430 | FileCheck %s
target datalayout = "e-p:16:16:16-i1:8:8-i8:8:8-i16:16:16-i32:16:32"
target triple = "msp430-generic-generic"

define i16 @bisrn(i16 %x, i16* %a) nounwind {
; CHECK-LABEL: bisrn:
; CHECK: bis @r13, r12
  %1 = load i16, i16* %a
  %2 = or i16 %1,%x
  ret i16 %2
}
define void @bismn(i16* %x, i16* %a) nounwind {
; CHECK-LABEL: bismn:
; CHECK: 	bis	@r13, @r12
  %1 = load i16, i16* %x
  %2 = load i16, i16* %a
  %3 = or i16 %1,%2
  store i16 %3, i16* %x, align 2
  ret void
}

define i16 @movrn(i16* %g, i16* %i) {
entry:
; CHECK-LABEL: movrn:
; CHECK: mov @r13, r12
  %0 = load i16, i16* %i, align 2
  ret i16 %0
}
define void @movmn(i16* %g, i16* %i) {
entry:
; CHECK-LABEL: movmn:
; CHECK: mov @r13, @r12
  %0 = load i16, i16* %i, align 2
  store i16 %0, i16* %g, align 2
  ret void
}

define i16 @addrn(i16 %x, i16* %a) nounwind {
; CHECK-LABEL: addrn:
; CHECK: add @r13, r12
  %1 = load i16, i16* %a
  %2 = add i16 %1,%x
  ret i16 %2
}
define void @addmn(i16* %x, i16* %a) nounwind {
; CHECK-LABEL: addmn:
; CHECK: add @r13, @r12
  %1 = load i16, i16* %x
  %2 = load i16, i16* %a
	%3 = add i16 %2, %1
	store i16 %3, i16* %x
	ret void
}

define i16 @andrn(i16 %x, i16* %a) nounwind {
; CHECK-LABEL: andrn:
; CHECK: and @r13, r12
  %1 = load i16, i16* %a
  %2 = and i16 %1,%x
  ret i16 %2
}
define void @andmn(i16* %x, i16* %a) nounwind {
; CHECK-LABEL: andmn:
; CHECK: and @r13, @r12
  %1 = load i16, i16* %x
  %2 = load i16, i16* %a
	%3 = and i16 %2, %1
	store i16 %3, i16* %x
	ret void
}

define i16 @xorrn(i16 %x, i16* %a) nounwind {
; CHECK-LABEL: xorrn:
; CHECK: xor @r13, r12
  %1 = load i16, i16* %a
  %2 = xor i16 %1,%x
  ret i16 %2
}
define void @xormn(i16* %x, i16* %a) nounwind {
; CHECK-LABEL: xormn:
; CHECK: xor @r13, @r12
  %1 = load i16, i16* %x
  %2 = load i16, i16* %a
	%3 = xor i16 %2, %1
	store i16 %3, i16* %x
	ret void
}

define void @cmpmn(i16* %g, i16* %i) {
entry:
; CHECK-LABEL: cmpmn:
; CHECK: cmp @r12, @r13
  %0 = load i16, i16* %g, align 2
  %1 = load i16, i16* %i, align 2
  %cmp = icmp sgt i16 %0, %1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i16 0, i16* %g, align 2
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define void @rra16n(i16* %i) {
entry:
; CHECK-LABEL: rra16n:
; CHECK: rra @r12
  %0 = load i16, i16* %i, align 2
  %shr = ashr i16 %0, 1
  store i16 %shr, i16* %i, align 2
  ret void
}

define void @sxt16n(i16* %x) {
entry:
; CHECK-LABEL: sxt16n:
; CHECK: sxt @r12
  %0 = bitcast i16* %x to i8*
  %1 = load i8, i8* %0, align 1
  %conv = sext i8 %1 to i16
  store i16 %conv, i16* %x, align 2
  ret void
}
