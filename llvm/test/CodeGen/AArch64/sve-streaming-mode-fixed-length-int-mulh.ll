; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -force-streaming-compatible-sve < %s | FileCheck %s

; This test only tests the legal types for a given vector width, as mulh nodes
; do not get generated for non-legal types.

target triple = "aarch64-unknown-linux-gnu"

;
; SMULH
;

define <4 x i8> @smulh_v4i8(<4 x i8> %op1, <4 x i8> %op2) #0 {
; CHECK-LABEL: smulh_v4i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.h, vl4
; CHECK-NEXT:    sxtb z0.h, p0/m, z0.h
; CHECK-NEXT:    sxtb z1.h, p0/m, z1.h
; CHECK-NEXT:    mul z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    lsr z0.h, z0.h, #4
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %insert = insertelement <4 x i16> undef, i16 4, i64 0
  %splat = shufflevector <4 x i16> %insert, <4 x i16> undef, <4 x i32> zeroinitializer
  %1 = sext <4 x i8> %op1 to <4 x i16>
  %2 = sext <4 x i8> %op2 to <4 x i16>
  %mul = mul <4 x i16> %1, %2
  %shr = lshr <4 x i16> %mul, <i16 4, i16 4, i16 4, i16 4>
  %res = trunc <4 x i16> %shr to <4 x i8>
  ret <4 x i8> %res
}

define <8 x i8> @smulh_v8i8(<8 x i8> %op1, <8 x i8> %op2) #0 {
; CHECK-LABEL: smulh_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.b, vl8
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    smulh z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %insert = insertelement <8 x i16> undef, i16 8, i64 0
  %splat = shufflevector <8 x i16> %insert, <8 x i16> undef, <8 x i32> zeroinitializer
  %1 = sext <8 x i8> %op1 to <8 x i16>
  %2 = sext <8 x i8> %op2 to <8 x i16>
  %mul = mul <8 x i16> %1, %2
  %shr = lshr <8 x i16> %mul, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %res = trunc <8 x i16> %shr to <8 x i8>
  ret <8 x i8> %res
}

define <16 x i8> @smulh_v16i8(<16 x i8> %op1, <16 x i8> %op2) #0 {
; CHECK-LABEL: smulh_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    ptrue p0.b, vl16
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    smulh z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %1 = sext <16 x i8> %op1 to <16 x i16>
  %2 = sext <16 x i8> %op2 to <16 x i16>
  %mul = mul <16 x i16> %1, %2
  %shr = lshr <16 x i16> %mul, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %res = trunc <16 x i16> %shr to <16 x i8>
  ret <16 x i8> %res
}

define void @smulh_v32i8(ptr %a, ptr %b) #0 {
; CHECK-LABEL: smulh_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q1, q0, [x0]
; CHECK-NEXT:    ptrue p0.h, vl8
; CHECK-NEXT:    sunpklo z4.h, z1.b
; CHECK-NEXT:    ext z1.b, z1.b, z1.b, #8
; CHECK-NEXT:    sunpklo z1.h, z1.b
; CHECK-NEXT:    ldp q3, q2, [x1]
; CHECK-NEXT:    sunpklo z5.h, z0.b
; CHECK-NEXT:    ext z0.b, z0.b, z0.b, #8
; CHECK-NEXT:    sunpklo z0.h, z0.b
; CHECK-NEXT:    sunpklo z6.h, z3.b
; CHECK-NEXT:    ext z3.b, z3.b, z3.b, #8
; CHECK-NEXT:    sunpklo z3.h, z3.b
; CHECK-NEXT:    sunpklo z7.h, z2.b
; CHECK-NEXT:    ext z2.b, z2.b, z2.b, #8
; CHECK-NEXT:    sunpklo z2.h, z2.b
; CHECK-NEXT:    mul z1.h, p0/m, z1.h, z3.h
; CHECK-NEXT:    mul z0.h, p0/m, z0.h, z2.h
; CHECK-NEXT:    movprfx z2, z5
; CHECK-NEXT:    mul z2.h, p0/m, z2.h, z7.h
; CHECK-NEXT:    movprfx z3, z4
; CHECK-NEXT:    mul z3.h, p0/m, z3.h, z6.h
; CHECK-NEXT:    lsr z1.h, z1.h, #8
; CHECK-NEXT:    lsr z3.h, z3.h, #8
; CHECK-NEXT:    lsr z2.h, z2.h, #8
; CHECK-NEXT:    lsr z0.h, z0.h, #8
; CHECK-NEXT:    ptrue p0.b, vl8
; CHECK-NEXT:    uzp1 z0.b, z0.b, z0.b
; CHECK-NEXT:    uzp1 z1.b, z1.b, z1.b
; CHECK-NEXT:    uzp1 z3.b, z3.b, z3.b
; CHECK-NEXT:    uzp1 z2.b, z2.b, z2.b
; CHECK-NEXT:    splice z3.b, p0, z3.b, z1.b
; CHECK-NEXT:    splice z2.b, p0, z2.b, z0.b
; CHECK-NEXT:    stp q3, q2, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i8>, ptr %a
  %op2 = load <32 x i8>, ptr %b
  %1 = sext <32 x i8> %op1 to <32 x i16>
  %2 = sext <32 x i8> %op2 to <32 x i16>
  %mul = mul <32 x i16> %1, %2
  %shr = lshr <32 x i16> %mul, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %res = trunc <32 x i16> %shr to <32 x i8>
  store <32 x i8> %res, ptr %a
  ret void
}

define <2 x i16> @smulh_v2i16(<2 x i16> %op1, <2 x i16> %op2) #0 {
; CHECK-LABEL: smulh_v2i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.s, vl2
; CHECK-NEXT:    sxth z0.s, p0/m, z0.s
; CHECK-NEXT:    sxth z1.s, p0/m, z1.s
; CHECK-NEXT:    mul z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    lsr z0.s, z0.s, #16
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %1 = sext <2 x i16> %op1 to <2 x i32>
  %2 = sext <2 x i16> %op2 to <2 x i32>
  %mul = mul <2 x i32> %1, %2
  %shr = lshr <2 x i32> %mul, <i32 16, i32 16>
  %res = trunc <2 x i32> %shr to <2 x i16>
  ret <2 x i16> %res
}

define <4 x i16> @smulh_v4i16(<4 x i16> %op1, <4 x i16> %op2) #0 {
; CHECK-LABEL: smulh_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.h, vl4
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    smulh z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %1 = sext <4 x i16> %op1 to <4 x i32>
  %2 = sext <4 x i16> %op2 to <4 x i32>
  %mul = mul <4 x i32> %1, %2
  %shr = lshr <4 x i32> %mul, <i32 16, i32 16, i32 16, i32 16>
  %res = trunc <4 x i32> %shr to <4 x i16>
  ret <4 x i16> %res
}

define <8 x i16> @smulh_v8i16(<8 x i16> %op1, <8 x i16> %op2) #0 {
; CHECK-LABEL: smulh_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    ptrue p0.h, vl8
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    smulh z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %1 = sext <8 x i16> %op1 to <8 x i32>
  %2 = sext <8 x i16> %op2 to <8 x i32>
  %mul = mul <8 x i32> %1, %2
  %shr = lshr <8 x i32> %mul, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %res = trunc <8 x i32> %shr to <8 x i16>
  ret <8 x i16> %res
}

define void @smulh_v16i16(ptr %a, ptr %b) #0 {
; CHECK-LABEL: smulh_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    ptrue p0.h, vl4
; CHECK-NEXT:    mov z5.d, z0.d
; CHECK-NEXT:    ext z5.b, z5.b, z5.b, #8
; CHECK-NEXT:    ldp q2, q3, [x1]
; CHECK-NEXT:    mov z4.d, z1.d
; CHECK-NEXT:    ext z4.b, z4.b, z4.b, #8
; CHECK-NEXT:    mov z6.d, z2.d
; CHECK-NEXT:    smulh z0.h, p0/m, z0.h, z2.h
; CHECK-NEXT:    ext z6.b, z6.b, z6.b, #8
; CHECK-NEXT:    mov z2.d, z3.d
; CHECK-NEXT:    smulh z1.h, p0/m, z1.h, z3.h
; CHECK-NEXT:    ext z2.b, z2.b, z3.b, #8
; CHECK-NEXT:    movprfx z3, z5
; CHECK-NEXT:    smulh z3.h, p0/m, z3.h, z6.h
; CHECK-NEXT:    smulh z2.h, p0/m, z2.h, z4.h
; CHECK-NEXT:    splice z0.h, p0, z0.h, z3.h
; CHECK-NEXT:    splice z1.h, p0, z1.h, z2.h
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i16>, ptr %a
  %op2 = load <16 x i16>, ptr %b
  %1 = sext <16 x i16> %op1 to <16 x i32>
  %2 = sext <16 x i16> %op2 to <16 x i32>
  %mul = mul <16 x i32> %1, %2
  %shr = lshr <16 x i32> %mul, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %res = trunc <16 x i32> %shr to <16 x i16>
  store <16 x i16> %res, ptr %a
  ret void
}

define <2 x i32> @smulh_v2i32(<2 x i32> %op1, <2 x i32> %op2) #0 {
; CHECK-LABEL: smulh_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.s, vl2
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    smulh z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %1 = sext <2 x i32> %op1 to <2 x i64>
  %2 = sext <2 x i32> %op2 to <2 x i64>
  %mul = mul <2 x i64> %1, %2
  %shr = lshr <2 x i64> %mul, <i64 32, i64 32>
  %res = trunc <2 x i64> %shr to <2 x i32>
  ret <2 x i32> %res
}

define <4 x i32> @smulh_v4i32(<4 x i32> %op1, <4 x i32> %op2) #0 {
; CHECK-LABEL: smulh_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    ptrue p0.s, vl4
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    smulh z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %1 = sext <4 x i32> %op1 to <4 x i64>
  %2 = sext <4 x i32> %op2 to <4 x i64>
  %mul = mul <4 x i64> %1, %2
  %shr = lshr <4 x i64> %mul, <i64 32, i64 32, i64 32, i64 32>
  %res = trunc <4 x i64> %shr to <4 x i32>
  ret <4 x i32> %res
}

define void @smulh_v8i32(ptr %a, ptr %b) #0 {
; CHECK-LABEL: smulh_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    ptrue p0.s, vl2
; CHECK-NEXT:    mov z5.d, z0.d
; CHECK-NEXT:    ext z5.b, z5.b, z5.b, #8
; CHECK-NEXT:    ldp q2, q3, [x1]
; CHECK-NEXT:    mov z4.d, z1.d
; CHECK-NEXT:    ext z4.b, z4.b, z4.b, #8
; CHECK-NEXT:    mov z6.d, z2.d
; CHECK-NEXT:    smulh z0.s, p0/m, z0.s, z2.s
; CHECK-NEXT:    ext z6.b, z6.b, z6.b, #8
; CHECK-NEXT:    mov z2.d, z3.d
; CHECK-NEXT:    smulh z1.s, p0/m, z1.s, z3.s
; CHECK-NEXT:    ext z2.b, z2.b, z3.b, #8
; CHECK-NEXT:    movprfx z3, z5
; CHECK-NEXT:    smulh z3.s, p0/m, z3.s, z6.s
; CHECK-NEXT:    smulh z2.s, p0/m, z2.s, z4.s
; CHECK-NEXT:    splice z0.s, p0, z0.s, z3.s
; CHECK-NEXT:    splice z1.s, p0, z1.s, z2.s
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i32>, ptr %a
  %op2 = load <8 x i32>, ptr %b
  %1 = sext <8 x i32> %op1 to <8 x i64>
  %2 = sext <8 x i32> %op2 to <8 x i64>
  %mul = mul <8 x i64> %1, %2
  %shr = lshr <8 x i64> %mul,  <i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32>
  %res = trunc <8 x i64> %shr to <8 x i32>
  store <8 x i32> %res, ptr %a
  ret void
}

define <1 x i64> @smulh_v1i64(<1 x i64> %op1, <1 x i64> %op2) #0 {
; CHECK-LABEL: smulh_v1i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.d, vl1
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    smulh z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %insert = insertelement <1 x i128> undef, i128 64, i128 0
  %splat = shufflevector <1 x i128> %insert, <1 x i128> undef, <1 x i32> zeroinitializer
  %1 = sext <1 x i64> %op1 to <1 x i128>
  %2 = sext <1 x i64> %op2 to <1 x i128>
  %mul = mul <1 x i128> %1, %2
  %shr = lshr <1 x i128> %mul, %splat
  %res = trunc <1 x i128> %shr to <1 x i64>
  ret <1 x i64> %res
}

define <2 x i64> @smulh_v2i64(<2 x i64> %op1, <2 x i64> %op2) #0 {
; CHECK-LABEL: smulh_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    ptrue p0.d, vl2
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    smulh z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %1 = sext <2 x i64> %op1 to <2 x i128>
  %2 = sext <2 x i64> %op2 to <2 x i128>
  %mul = mul <2 x i128> %1, %2
  %shr = lshr <2 x i128> %mul, <i128 64, i128 64>
  %res = trunc <2 x i128> %shr to <2 x i64>
  ret <2 x i64> %res
}

define void @smulh_v4i64(ptr %a, ptr %b) #0 {
; CHECK-LABEL: smulh_v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    ptrue p0.d, vl1
; CHECK-NEXT:    fmov x9, d0
; CHECK-NEXT:    ldp q2, q3, [x1]
; CHECK-NEXT:    mov z4.d, z1.d[1]
; CHECK-NEXT:    fmov x8, d1
; CHECK-NEXT:    mov z1.d, z0.d[1]
; CHECK-NEXT:    fmov x13, d4
; CHECK-NEXT:    fmov x10, d1
; CHECK-NEXT:    mov z0.d, z2.d[1]
; CHECK-NEXT:    fmov x12, d2
; CHECK-NEXT:    fmov x11, d0
; CHECK-NEXT:    mov z0.d, z3.d[1]
; CHECK-NEXT:    fmov x14, d0
; CHECK-NEXT:    smulh x9, x9, x12
; CHECK-NEXT:    smulh x10, x10, x11
; CHECK-NEXT:    fmov x11, d3
; CHECK-NEXT:    smulh x12, x13, x14
; CHECK-NEXT:    smulh x8, x8, x11
; CHECK-NEXT:    fmov d0, x9
; CHECK-NEXT:    fmov d1, x10
; CHECK-NEXT:    fmov d3, x12
; CHECK-NEXT:    fmov d2, x8
; CHECK-NEXT:    splice z0.d, p0, z0.d, z1.d
; CHECK-NEXT:    splice z2.d, p0, z2.d, z3.d
; CHECK-NEXT:    stp q0, q2, [x0]
; CHECK-NEXT:    ret
  %op1 = load <4 x i64>, ptr %a
  %op2 = load <4 x i64>, ptr %b
  %1 = sext <4 x i64> %op1 to <4 x i128>
  %2 = sext <4 x i64> %op2 to <4 x i128>
  %mul = mul <4 x i128> %1, %2
  %shr = lshr <4 x i128> %mul, <i128 64, i128 64, i128 64, i128 64>
  %res = trunc <4 x i128> %shr to <4 x i64>
  store <4 x i64> %res, ptr %a
  ret void
}

;
; UMULH
;

define <4 x i8> @umulh_v4i8(<4 x i8> %op1, <4 x i8> %op2) #0 {
; CHECK-LABEL: umulh_v4i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.h, vl4
; CHECK-NEXT:    and z0.h, z0.h, #0xff
; CHECK-NEXT:    and z1.h, z1.h, #0xff
; CHECK-NEXT:    mul z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    lsr z0.h, z0.h, #4
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %1 = zext <4 x i8> %op1 to <4 x i16>
  %2 = zext <4 x i8> %op2 to <4 x i16>
  %mul = mul <4 x i16> %1, %2
  %shr = lshr <4 x i16> %mul, <i16 4, i16 4, i16 4, i16 4>
  %res = trunc <4 x i16> %shr to <4 x i8>
  ret <4 x i8> %res
}

define <8 x i8> @umulh_v8i8(<8 x i8> %op1, <8 x i8> %op2) #0 {
; CHECK-LABEL: umulh_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.b, vl8
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    umulh z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %1 = zext <8 x i8> %op1 to <8 x i16>
  %2 = zext <8 x i8> %op2 to <8 x i16>
  %mul = mul <8 x i16> %1, %2
  %shr = lshr <8 x i16> %mul, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %res = trunc <8 x i16> %shr to <8 x i8>
  ret <8 x i8> %res
}

define <16 x i8> @umulh_v16i8(<16 x i8> %op1, <16 x i8> %op2) #0 {
; CHECK-LABEL: umulh_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    ptrue p0.b, vl16
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    umulh z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %1 = zext <16 x i8> %op1 to <16 x i16>
  %2 = zext <16 x i8> %op2 to <16 x i16>
  %mul = mul <16 x i16> %1, %2
  %shr = lshr <16 x i16> %mul, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %res = trunc <16 x i16> %shr to <16 x i8>
  ret <16 x i8> %res
}

define void @umulh_v32i8(ptr %a, ptr %b) #0 {
; CHECK-LABEL: umulh_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q1, q0, [x0]
; CHECK-NEXT:    ptrue p0.h, vl8
; CHECK-NEXT:    uunpklo z4.h, z1.b
; CHECK-NEXT:    ext z1.b, z1.b, z1.b, #8
; CHECK-NEXT:    uunpklo z1.h, z1.b
; CHECK-NEXT:    ldp q3, q2, [x1]
; CHECK-NEXT:    uunpklo z5.h, z0.b
; CHECK-NEXT:    ext z0.b, z0.b, z0.b, #8
; CHECK-NEXT:    uunpklo z0.h, z0.b
; CHECK-NEXT:    uunpklo z6.h, z3.b
; CHECK-NEXT:    ext z3.b, z3.b, z3.b, #8
; CHECK-NEXT:    uunpklo z3.h, z3.b
; CHECK-NEXT:    uunpklo z7.h, z2.b
; CHECK-NEXT:    ext z2.b, z2.b, z2.b, #8
; CHECK-NEXT:    uunpklo z2.h, z2.b
; CHECK-NEXT:    mul z1.h, p0/m, z1.h, z3.h
; CHECK-NEXT:    mul z0.h, p0/m, z0.h, z2.h
; CHECK-NEXT:    movprfx z2, z5
; CHECK-NEXT:    mul z2.h, p0/m, z2.h, z7.h
; CHECK-NEXT:    movprfx z3, z4
; CHECK-NEXT:    mul z3.h, p0/m, z3.h, z6.h
; CHECK-NEXT:    lsr z1.h, z1.h, #8
; CHECK-NEXT:    lsr z3.h, z3.h, #8
; CHECK-NEXT:    lsr z2.h, z2.h, #8
; CHECK-NEXT:    lsr z0.h, z0.h, #8
; CHECK-NEXT:    ptrue p0.b, vl8
; CHECK-NEXT:    uzp1 z0.b, z0.b, z0.b
; CHECK-NEXT:    uzp1 z1.b, z1.b, z1.b
; CHECK-NEXT:    uzp1 z3.b, z3.b, z3.b
; CHECK-NEXT:    uzp1 z2.b, z2.b, z2.b
; CHECK-NEXT:    splice z3.b, p0, z3.b, z1.b
; CHECK-NEXT:    splice z2.b, p0, z2.b, z0.b
; CHECK-NEXT:    stp q3, q2, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i8>, ptr %a
  %op2 = load <32 x i8>, ptr %b
  %1 = zext <32 x i8> %op1 to <32 x i16>
  %2 = zext <32 x i8> %op2 to <32 x i16>
  %mul = mul <32 x i16> %1, %2
  %shr = lshr <32 x i16> %mul, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %res = trunc <32 x i16> %shr to <32 x i8>
  store <32 x i8> %res, ptr %a
  ret void
}

define <2 x i16> @umulh_v2i16(<2 x i16> %op1, <2 x i16> %op2) #0 {
; CHECK-LABEL: umulh_v2i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.s, vl2
; CHECK-NEXT:    and z0.s, z0.s, #0xffff
; CHECK-NEXT:    and z1.s, z1.s, #0xffff
; CHECK-NEXT:    mul z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    lsr z0.s, z0.s, #16
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %1 = zext <2 x i16> %op1 to <2 x i32>
  %2 = zext <2 x i16> %op2 to <2 x i32>
  %mul = mul <2 x i32> %1, %2
  %shr = lshr <2 x i32> %mul, <i32 16, i32 16>
  %res = trunc <2 x i32> %shr to <2 x i16>
  ret <2 x i16> %res
}

define <4 x i16> @umulh_v4i16(<4 x i16> %op1, <4 x i16> %op2) #0 {
; CHECK-LABEL: umulh_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.h, vl4
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    umulh z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %1 = zext <4 x i16> %op1 to <4 x i32>
  %2 = zext <4 x i16> %op2 to <4 x i32>
  %mul = mul <4 x i32> %1, %2
  %shr = lshr <4 x i32> %mul, <i32 16, i32 16, i32 16, i32 16>
  %res = trunc <4 x i32> %shr to <4 x i16>
  ret <4 x i16> %res
}

define <8 x i16> @umulh_v8i16(<8 x i16> %op1, <8 x i16> %op2) #0 {
; CHECK-LABEL: umulh_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    ptrue p0.h, vl8
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    umulh z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %1 = zext <8 x i16> %op1 to <8 x i32>
  %2 = zext <8 x i16> %op2 to <8 x i32>
  %mul = mul <8 x i32> %1, %2
  %shr = lshr <8 x i32> %mul, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %res = trunc <8 x i32> %shr to <8 x i16>
  ret <8 x i16> %res
}

define void @umulh_v16i16(ptr %a, ptr %b) #0 {
; CHECK-LABEL: umulh_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    ptrue p0.h, vl4
; CHECK-NEXT:    mov z5.d, z0.d
; CHECK-NEXT:    ext z5.b, z5.b, z5.b, #8
; CHECK-NEXT:    ldp q2, q3, [x1]
; CHECK-NEXT:    mov z4.d, z1.d
; CHECK-NEXT:    ext z4.b, z4.b, z4.b, #8
; CHECK-NEXT:    mov z6.d, z2.d
; CHECK-NEXT:    umulh z0.h, p0/m, z0.h, z2.h
; CHECK-NEXT:    ext z6.b, z6.b, z6.b, #8
; CHECK-NEXT:    mov z2.d, z3.d
; CHECK-NEXT:    umulh z1.h, p0/m, z1.h, z3.h
; CHECK-NEXT:    ext z2.b, z2.b, z3.b, #8
; CHECK-NEXT:    movprfx z3, z5
; CHECK-NEXT:    umulh z3.h, p0/m, z3.h, z6.h
; CHECK-NEXT:    umulh z2.h, p0/m, z2.h, z4.h
; CHECK-NEXT:    splice z0.h, p0, z0.h, z3.h
; CHECK-NEXT:    splice z1.h, p0, z1.h, z2.h
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i16>, ptr %a
  %op2 = load <16 x i16>, ptr %b
  %1 = zext <16 x i16> %op1 to <16 x i32>
  %2 = zext <16 x i16> %op2 to <16 x i32>
  %mul = mul <16 x i32> %1, %2
  %shr = lshr <16 x i32> %mul, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %res = trunc <16 x i32> %shr to <16 x i16>
  store <16 x i16> %res, ptr %a
  ret void
}

define <2 x i32> @umulh_v2i32(<2 x i32> %op1, <2 x i32> %op2) #0 {
; CHECK-LABEL: umulh_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.s, vl2
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    umulh z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %1 = zext <2 x i32> %op1 to <2 x i64>
  %2 = zext <2 x i32> %op2 to <2 x i64>
  %mul = mul <2 x i64> %1, %2
  %shr = lshr <2 x i64> %mul, <i64 32, i64 32>
  %res = trunc <2 x i64> %shr to <2 x i32>
  ret <2 x i32> %res
}

define <4 x i32> @umulh_v4i32(<4 x i32> %op1, <4 x i32> %op2) #0 {
; CHECK-LABEL: umulh_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    ptrue p0.s, vl4
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    umulh z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %1 = zext <4 x i32> %op1 to <4 x i64>
  %2 = zext <4 x i32> %op2 to <4 x i64>
  %mul = mul <4 x i64> %1, %2
  %shr = lshr <4 x i64> %mul, <i64 32, i64 32, i64 32, i64 32>
  %res = trunc <4 x i64> %shr to <4 x i32>
  ret <4 x i32> %res
}

define void @umulh_v8i32(ptr %a, ptr %b) #0 {
; CHECK-LABEL: umulh_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    ptrue p0.s, vl2
; CHECK-NEXT:    mov z5.d, z0.d
; CHECK-NEXT:    ext z5.b, z5.b, z5.b, #8
; CHECK-NEXT:    ldp q2, q3, [x1]
; CHECK-NEXT:    mov z4.d, z1.d
; CHECK-NEXT:    ext z4.b, z4.b, z4.b, #8
; CHECK-NEXT:    mov z6.d, z2.d
; CHECK-NEXT:    umulh z0.s, p0/m, z0.s, z2.s
; CHECK-NEXT:    ext z6.b, z6.b, z6.b, #8
; CHECK-NEXT:    mov z2.d, z3.d
; CHECK-NEXT:    umulh z1.s, p0/m, z1.s, z3.s
; CHECK-NEXT:    ext z2.b, z2.b, z3.b, #8
; CHECK-NEXT:    movprfx z3, z5
; CHECK-NEXT:    umulh z3.s, p0/m, z3.s, z6.s
; CHECK-NEXT:    umulh z2.s, p0/m, z2.s, z4.s
; CHECK-NEXT:    splice z0.s, p0, z0.s, z3.s
; CHECK-NEXT:    splice z1.s, p0, z1.s, z2.s
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i32>, ptr %a
  %op2 = load <8 x i32>, ptr %b
  %insert = insertelement <8 x i64> undef, i64 32, i64 0
  %splat = shufflevector <8 x i64> %insert, <8 x i64> undef, <8 x i32> zeroinitializer
  %1 = zext <8 x i32> %op1 to <8 x i64>
  %2 = zext <8 x i32> %op2 to <8 x i64>
  %mul = mul <8 x i64> %1, %2
  %shr = lshr <8 x i64> %mul, <i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32>
  %res = trunc <8 x i64> %shr to <8 x i32>
  store <8 x i32> %res, ptr %a
  ret void
}

define <1 x i64> @umulh_v1i64(<1 x i64> %op1, <1 x i64> %op2) #0 {
; CHECK-LABEL: umulh_v1i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.d, vl1
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    umulh z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %1 = zext <1 x i64> %op1 to <1 x i128>
  %2 = zext <1 x i64> %op2 to <1 x i128>
  %mul = mul <1 x i128> %1, %2
  %shr = lshr <1 x i128> %mul, <i128 64>
  %res = trunc <1 x i128> %shr to <1 x i64>
  ret <1 x i64> %res
}

define <2 x i64> @umulh_v2i64(<2 x i64> %op1, <2 x i64> %op2) #0 {
; CHECK-LABEL: umulh_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    ptrue p0.d, vl2
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    umulh z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %1 = zext <2 x i64> %op1 to <2 x i128>
  %2 = zext <2 x i64> %op2 to <2 x i128>
  %mul = mul <2 x i128> %1, %2
  %shr = lshr <2 x i128> %mul, <i128 64, i128 64>
  %res = trunc <2 x i128> %shr to <2 x i64>
  ret <2 x i64> %res
}

define void @umulh_v4i64(ptr %a, ptr %b) #0 {
; CHECK-LABEL: umulh_v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    ptrue p0.d, vl1
; CHECK-NEXT:    fmov x9, d0
; CHECK-NEXT:    ldp q2, q3, [x1]
; CHECK-NEXT:    mov z4.d, z1.d[1]
; CHECK-NEXT:    fmov x8, d1
; CHECK-NEXT:    mov z1.d, z0.d[1]
; CHECK-NEXT:    fmov x13, d4
; CHECK-NEXT:    fmov x10, d1
; CHECK-NEXT:    mov z0.d, z2.d[1]
; CHECK-NEXT:    fmov x12, d2
; CHECK-NEXT:    fmov x11, d0
; CHECK-NEXT:    mov z0.d, z3.d[1]
; CHECK-NEXT:    fmov x14, d0
; CHECK-NEXT:    umulh x9, x9, x12
; CHECK-NEXT:    umulh x10, x10, x11
; CHECK-NEXT:    fmov x11, d3
; CHECK-NEXT:    umulh x12, x13, x14
; CHECK-NEXT:    umulh x8, x8, x11
; CHECK-NEXT:    fmov d0, x9
; CHECK-NEXT:    fmov d1, x10
; CHECK-NEXT:    fmov d3, x12
; CHECK-NEXT:    fmov d2, x8
; CHECK-NEXT:    splice z0.d, p0, z0.d, z1.d
; CHECK-NEXT:    splice z2.d, p0, z2.d, z3.d
; CHECK-NEXT:    stp q0, q2, [x0]
; CHECK-NEXT:    ret
  %op1 = load <4 x i64>, ptr %a
  %op2 = load <4 x i64>, ptr %b
  %1 = zext <4 x i64> %op1 to <4 x i128>
  %2 = zext <4 x i64> %op2 to <4 x i128>
  %mul = mul <4 x i128> %1, %2
  %shr = lshr <4 x i128> %mul, <i128 64, i128 64, i128 64, i128 64>
  %res = trunc <4 x i128> %shr to <4 x i64>
  store <4 x i64> %res, ptr %a
  ret void
}

attributes #0 = { "target-features"="+sve" }
