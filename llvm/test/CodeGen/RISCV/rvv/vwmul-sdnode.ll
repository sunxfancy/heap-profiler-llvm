; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+v -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+v -verify-machineinstrs < %s | FileCheck %s

define <vscale x 1 x i64> @vwmul_vv_nxv1i64(<vscale x 1 x i32> %va, <vscale x 1 x i32> %vb) {
; CHECK-LABEL: vwmul_vv_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, mf2, ta, ma
; CHECK-NEXT:    vwmul.vv v10, v8, v9
; CHECK-NEXT:    vmv1r.v v8, v10
; CHECK-NEXT:    ret
  %vc = sext <vscale x 1 x i32> %va to <vscale x 1 x i64>
  %vd = sext <vscale x 1 x i32> %vb to <vscale x 1 x i64>
  %ve = mul <vscale x 1 x i64> %vc, %vd
  ret <vscale x 1 x i64> %ve
}

define <vscale x 1 x i64> @vwmulu_vv_nxv1i64(<vscale x 1 x i32> %va, <vscale x 1 x i32> %vb) {
; CHECK-LABEL: vwmulu_vv_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, mf2, ta, ma
; CHECK-NEXT:    vwmulu.vv v10, v8, v9
; CHECK-NEXT:    vmv1r.v v8, v10
; CHECK-NEXT:    ret
  %vc = zext <vscale x 1 x i32> %va to <vscale x 1 x i64>
  %vd = zext <vscale x 1 x i32> %vb to <vscale x 1 x i64>
  %ve = mul <vscale x 1 x i64> %vc, %vd
  ret <vscale x 1 x i64> %ve
}

define <vscale x 1 x i64> @vwmulsu_vv_nxv1i64(<vscale x 1 x i32> %va, <vscale x 1 x i32> %vb) {
; CHECK-LABEL: vwmulsu_vv_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, mf2, ta, ma
; CHECK-NEXT:    vwmulsu.vv v10, v8, v9
; CHECK-NEXT:    vmv1r.v v8, v10
; CHECK-NEXT:    ret
  %vc = sext <vscale x 1 x i32> %va to <vscale x 1 x i64>
  %vd = zext <vscale x 1 x i32> %vb to <vscale x 1 x i64>
  %ve = mul <vscale x 1 x i64> %vc, %vd
  ret <vscale x 1 x i64> %ve
}

define <vscale x 1 x i64> @vwmul_vx_nxv1i64(<vscale x 1 x i32> %va, i32 %b) {
; CHECK-LABEL: vwmul_vx_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, mf2, ta, ma
; CHECK-NEXT:    vwmul.vx v9, v8, a0
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 1 x i32> %head, <vscale x 1 x i32> undef, <vscale x 1 x i32> zeroinitializer
  %vc = sext <vscale x 1 x i32> %va to <vscale x 1 x i64>
  %vd = sext <vscale x 1 x i32> %splat to <vscale x 1 x i64>
  %ve = mul <vscale x 1 x i64> %vc, %vd
  ret <vscale x 1 x i64> %ve
}

define <vscale x 1 x i64> @vwmulu_vx_nxv1i64(<vscale x 1 x i32> %va, i32 %b) {
; CHECK-LABEL: vwmulu_vx_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, mf2, ta, ma
; CHECK-NEXT:    vwmulu.vx v9, v8, a0
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 1 x i32> %head, <vscale x 1 x i32> undef, <vscale x 1 x i32> zeroinitializer
  %vc = zext <vscale x 1 x i32> %va to <vscale x 1 x i64>
  %vd = zext <vscale x 1 x i32> %splat to <vscale x 1 x i64>
  %ve = mul <vscale x 1 x i64> %vc, %vd
  ret <vscale x 1 x i64> %ve
}

define <vscale x 1 x i64> @vwmulsu_vx_nxv1i64(<vscale x 1 x i32> %va, i32 %b) {
; CHECK-LABEL: vwmulsu_vx_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, mf2, ta, ma
; CHECK-NEXT:    vwmulsu.vx v9, v8, a0
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 1 x i32> %head, <vscale x 1 x i32> undef, <vscale x 1 x i32> zeroinitializer
  %vc = sext <vscale x 1 x i32> %va to <vscale x 1 x i64>
  %vd = zext <vscale x 1 x i32> %splat to <vscale x 1 x i64>
  %ve = mul <vscale x 1 x i64> %vc, %vd
  ret <vscale x 1 x i64> %ve
}

define <vscale x 2 x i64> @vwmul_vv_nxv2i64(<vscale x 2 x i32> %va, <vscale x 2 x i32> %vb) {
; CHECK-LABEL: vwmul_vv_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m1, ta, ma
; CHECK-NEXT:    vwmul.vv v10, v8, v9
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %vc = sext <vscale x 2 x i32> %va to <vscale x 2 x i64>
  %vd = sext <vscale x 2 x i32> %vb to <vscale x 2 x i64>
  %ve = mul <vscale x 2 x i64> %vc, %vd
  ret <vscale x 2 x i64> %ve
}

define <vscale x 2 x i64> @vwmulu_vv_nxv2i64(<vscale x 2 x i32> %va, <vscale x 2 x i32> %vb) {
; CHECK-LABEL: vwmulu_vv_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m1, ta, ma
; CHECK-NEXT:    vwmulu.vv v10, v8, v9
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %vc = zext <vscale x 2 x i32> %va to <vscale x 2 x i64>
  %vd = zext <vscale x 2 x i32> %vb to <vscale x 2 x i64>
  %ve = mul <vscale x 2 x i64> %vc, %vd
  ret <vscale x 2 x i64> %ve
}

define <vscale x 2 x i64> @vwmulsu_vv_nxv2i64(<vscale x 2 x i32> %va, <vscale x 2 x i32> %vb) {
; CHECK-LABEL: vwmulsu_vv_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m1, ta, ma
; CHECK-NEXT:    vwmulsu.vv v10, v8, v9
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %vc = sext <vscale x 2 x i32> %va to <vscale x 2 x i64>
  %vd = zext <vscale x 2 x i32> %vb to <vscale x 2 x i64>
  %ve = mul <vscale x 2 x i64> %vc, %vd
  ret <vscale x 2 x i64> %ve
}

define <vscale x 2 x i64> @vwmul_vx_nxv2i64(<vscale x 2 x i32> %va, i32 %b) {
; CHECK-LABEL: vwmul_vx_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m1, ta, ma
; CHECK-NEXT:    vwmul.vx v10, v8, a0
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 2 x i32> %head, <vscale x 2 x i32> undef, <vscale x 2 x i32> zeroinitializer
  %vc = sext <vscale x 2 x i32> %va to <vscale x 2 x i64>
  %vd = sext <vscale x 2 x i32> %splat to <vscale x 2 x i64>
  %ve = mul <vscale x 2 x i64> %vc, %vd
  ret <vscale x 2 x i64> %ve
}

define <vscale x 2 x i64> @vwmulu_vx_nxv2i64(<vscale x 2 x i32> %va, i32 %b) {
; CHECK-LABEL: vwmulu_vx_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m1, ta, ma
; CHECK-NEXT:    vwmulu.vx v10, v8, a0
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 2 x i32> %head, <vscale x 2 x i32> undef, <vscale x 2 x i32> zeroinitializer
  %vc = zext <vscale x 2 x i32> %va to <vscale x 2 x i64>
  %vd = zext <vscale x 2 x i32> %splat to <vscale x 2 x i64>
  %ve = mul <vscale x 2 x i64> %vc, %vd
  ret <vscale x 2 x i64> %ve
}

define <vscale x 2 x i64> @vwmulsu_vx_nxv2i64(<vscale x 2 x i32> %va, i32 %b) {
; CHECK-LABEL: vwmulsu_vx_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m1, ta, ma
; CHECK-NEXT:    vwmulsu.vx v10, v8, a0
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 2 x i32> %head, <vscale x 2 x i32> undef, <vscale x 2 x i32> zeroinitializer
  %vc = sext <vscale x 2 x i32> %va to <vscale x 2 x i64>
  %vd = zext <vscale x 2 x i32> %splat to <vscale x 2 x i64>
  %ve = mul <vscale x 2 x i64> %vc, %vd
  ret <vscale x 2 x i64> %ve
}

define <vscale x 4 x i64> @vwmul_vv_nxv4i64(<vscale x 4 x i32> %va, <vscale x 4 x i32> %vb) {
; CHECK-LABEL: vwmul_vv_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m2, ta, ma
; CHECK-NEXT:    vwmul.vv v12, v8, v10
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %vc = sext <vscale x 4 x i32> %va to <vscale x 4 x i64>
  %vd = sext <vscale x 4 x i32> %vb to <vscale x 4 x i64>
  %ve = mul <vscale x 4 x i64> %vc, %vd
  ret <vscale x 4 x i64> %ve
}

define <vscale x 4 x i64> @vwmulu_vv_nxv4i64(<vscale x 4 x i32> %va, <vscale x 4 x i32> %vb) {
; CHECK-LABEL: vwmulu_vv_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m2, ta, ma
; CHECK-NEXT:    vwmulu.vv v12, v8, v10
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %vc = zext <vscale x 4 x i32> %va to <vscale x 4 x i64>
  %vd = zext <vscale x 4 x i32> %vb to <vscale x 4 x i64>
  %ve = mul <vscale x 4 x i64> %vc, %vd
  ret <vscale x 4 x i64> %ve
}

define <vscale x 4 x i64> @vwmulsu_vv_nxv4i64(<vscale x 4 x i32> %va, <vscale x 4 x i32> %vb) {
; CHECK-LABEL: vwmulsu_vv_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m2, ta, ma
; CHECK-NEXT:    vwmulsu.vv v12, v8, v10
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %vc = sext <vscale x 4 x i32> %va to <vscale x 4 x i64>
  %vd = zext <vscale x 4 x i32> %vb to <vscale x 4 x i64>
  %ve = mul <vscale x 4 x i64> %vc, %vd
  ret <vscale x 4 x i64> %ve
}

define <vscale x 4 x i64> @vwmul_vx_nxv4i64(<vscale x 4 x i32> %va, i32 %b) {
; CHECK-LABEL: vwmul_vx_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m2, ta, ma
; CHECK-NEXT:    vwmul.vx v12, v8, a0
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 4 x i32> %head, <vscale x 4 x i32> undef, <vscale x 4 x i32> zeroinitializer
  %vc = sext <vscale x 4 x i32> %va to <vscale x 4 x i64>
  %vd = sext <vscale x 4 x i32> %splat to <vscale x 4 x i64>
  %ve = mul <vscale x 4 x i64> %vc, %vd
  ret <vscale x 4 x i64> %ve
}

define <vscale x 4 x i64> @vwmulu_vx_nxv4i64(<vscale x 4 x i32> %va, i32 %b) {
; CHECK-LABEL: vwmulu_vx_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m2, ta, ma
; CHECK-NEXT:    vwmulu.vx v12, v8, a0
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 4 x i32> %head, <vscale x 4 x i32> undef, <vscale x 4 x i32> zeroinitializer
  %vc = zext <vscale x 4 x i32> %va to <vscale x 4 x i64>
  %vd = zext <vscale x 4 x i32> %splat to <vscale x 4 x i64>
  %ve = mul <vscale x 4 x i64> %vc, %vd
  ret <vscale x 4 x i64> %ve
}

define <vscale x 4 x i64> @vwmulsu_vx_nxv4i64(<vscale x 4 x i32> %va, i32 %b) {
; CHECK-LABEL: vwmulsu_vx_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m2, ta, ma
; CHECK-NEXT:    vwmulsu.vx v12, v8, a0
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 4 x i32> %head, <vscale x 4 x i32> undef, <vscale x 4 x i32> zeroinitializer
  %vc = sext <vscale x 4 x i32> %va to <vscale x 4 x i64>
  %vd = zext <vscale x 4 x i32> %splat to <vscale x 4 x i64>
  %ve = mul <vscale x 4 x i64> %vc, %vd
  ret <vscale x 4 x i64> %ve
}

define <vscale x 8 x i64> @vwmul_vv_nxv8i64(<vscale x 8 x i32> %va, <vscale x 8 x i32> %vb) {
; CHECK-LABEL: vwmul_vv_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m4, ta, ma
; CHECK-NEXT:    vwmul.vv v16, v8, v12
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %vc = sext <vscale x 8 x i32> %va to <vscale x 8 x i64>
  %vd = sext <vscale x 8 x i32> %vb to <vscale x 8 x i64>
  %ve = mul <vscale x 8 x i64> %vc, %vd
  ret <vscale x 8 x i64> %ve
}

define <vscale x 8 x i64> @vwmulu_vv_nxv8i64(<vscale x 8 x i32> %va, <vscale x 8 x i32> %vb) {
; CHECK-LABEL: vwmulu_vv_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m4, ta, ma
; CHECK-NEXT:    vwmulu.vv v16, v8, v12
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %vc = zext <vscale x 8 x i32> %va to <vscale x 8 x i64>
  %vd = zext <vscale x 8 x i32> %vb to <vscale x 8 x i64>
  %ve = mul <vscale x 8 x i64> %vc, %vd
  ret <vscale x 8 x i64> %ve
}

define <vscale x 8 x i64> @vwmulsu_vv_nxv8i64(<vscale x 8 x i32> %va, <vscale x 8 x i32> %vb) {
; CHECK-LABEL: vwmulsu_vv_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m4, ta, ma
; CHECK-NEXT:    vwmulsu.vv v16, v8, v12
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %vc = sext <vscale x 8 x i32> %va to <vscale x 8 x i64>
  %vd = zext <vscale x 8 x i32> %vb to <vscale x 8 x i64>
  %ve = mul <vscale x 8 x i64> %vc, %vd
  ret <vscale x 8 x i64> %ve
}

define <vscale x 8 x i64> @vwmul_vx_nxv8i64(<vscale x 8 x i32> %va, i32 %b) {
; CHECK-LABEL: vwmul_vx_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m4, ta, ma
; CHECK-NEXT:    vwmul.vx v16, v8, a0
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 8 x i32> %head, <vscale x 8 x i32> undef, <vscale x 8 x i32> zeroinitializer
  %vc = sext <vscale x 8 x i32> %va to <vscale x 8 x i64>
  %vd = sext <vscale x 8 x i32> %splat to <vscale x 8 x i64>
  %ve = mul <vscale x 8 x i64> %vc, %vd
  ret <vscale x 8 x i64> %ve
}

define <vscale x 8 x i64> @vwmulu_vx_nxv8i64(<vscale x 8 x i32> %va, i32 %b) {
; CHECK-LABEL: vwmulu_vx_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m4, ta, ma
; CHECK-NEXT:    vwmulu.vx v16, v8, a0
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 8 x i32> %head, <vscale x 8 x i32> undef, <vscale x 8 x i32> zeroinitializer
  %vc = zext <vscale x 8 x i32> %va to <vscale x 8 x i64>
  %vd = zext <vscale x 8 x i32> %splat to <vscale x 8 x i64>
  %ve = mul <vscale x 8 x i64> %vc, %vd
  ret <vscale x 8 x i64> %ve
}

define <vscale x 8 x i64> @vwmulsu_vx_nxv8i64(<vscale x 8 x i32> %va, i32 %b) {
; CHECK-LABEL: vwmulsu_vx_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m4, ta, ma
; CHECK-NEXT:    vwmulsu.vx v16, v8, a0
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 8 x i32> %head, <vscale x 8 x i32> undef, <vscale x 8 x i32> zeroinitializer
  %vc = sext <vscale x 8 x i32> %va to <vscale x 8 x i64>
  %vd = zext <vscale x 8 x i32> %splat to <vscale x 8 x i64>
  %ve = mul <vscale x 8 x i64> %vc, %vd
  ret <vscale x 8 x i64> %ve
}