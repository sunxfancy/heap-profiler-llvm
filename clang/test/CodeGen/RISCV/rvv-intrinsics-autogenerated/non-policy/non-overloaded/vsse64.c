// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +v -target-feature +zfh \
// RUN:   -target-feature +experimental-zvfh -disable-O0-optnone  \
// RUN:   -emit-llvm %s -o - | opt -S -passes=mem2reg | \
// RUN:   FileCheck --check-prefix=CHECK-RV64 %s

#include <riscv_vector.h>

// CHECK-RV64-LABEL: @test_vsse64_v_f64m1(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.nxv1f64.i64(<vscale x 1 x double> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_f64m1(double *base, ptrdiff_t bstride, vfloat64m1_t value, size_t vl) {
  return __riscv_vsse64_v_f64m1(base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_f64m2(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.nxv2f64.i64(<vscale x 2 x double> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_f64m2(double *base, ptrdiff_t bstride, vfloat64m2_t value, size_t vl) {
  return __riscv_vsse64_v_f64m2(base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_f64m4(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.nxv4f64.i64(<vscale x 4 x double> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_f64m4(double *base, ptrdiff_t bstride, vfloat64m4_t value, size_t vl) {
  return __riscv_vsse64_v_f64m4(base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_f64m8(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.nxv8f64.i64(<vscale x 8 x double> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_f64m8(double *base, ptrdiff_t bstride, vfloat64m8_t value, size_t vl) {
  return __riscv_vsse64_v_f64m8(base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_i64m1(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.nxv1i64.i64(<vscale x 1 x i64> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_i64m1(int64_t *base, ptrdiff_t bstride, vint64m1_t value, size_t vl) {
  return __riscv_vsse64_v_i64m1(base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_i64m2(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.nxv2i64.i64(<vscale x 2 x i64> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_i64m2(int64_t *base, ptrdiff_t bstride, vint64m2_t value, size_t vl) {
  return __riscv_vsse64_v_i64m2(base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_i64m4(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.nxv4i64.i64(<vscale x 4 x i64> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_i64m4(int64_t *base, ptrdiff_t bstride, vint64m4_t value, size_t vl) {
  return __riscv_vsse64_v_i64m4(base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_i64m8(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.nxv8i64.i64(<vscale x 8 x i64> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_i64m8(int64_t *base, ptrdiff_t bstride, vint64m8_t value, size_t vl) {
  return __riscv_vsse64_v_i64m8(base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_u64m1(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.nxv1i64.i64(<vscale x 1 x i64> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_u64m1(uint64_t *base, ptrdiff_t bstride, vuint64m1_t value, size_t vl) {
  return __riscv_vsse64_v_u64m1(base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_u64m2(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.nxv2i64.i64(<vscale x 2 x i64> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_u64m2(uint64_t *base, ptrdiff_t bstride, vuint64m2_t value, size_t vl) {
  return __riscv_vsse64_v_u64m2(base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_u64m4(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.nxv4i64.i64(<vscale x 4 x i64> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_u64m4(uint64_t *base, ptrdiff_t bstride, vuint64m4_t value, size_t vl) {
  return __riscv_vsse64_v_u64m4(base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_u64m8(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.nxv8i64.i64(<vscale x 8 x i64> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_u64m8(uint64_t *base, ptrdiff_t bstride, vuint64m8_t value, size_t vl) {
  return __riscv_vsse64_v_u64m8(base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_f64m1_m(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.mask.nxv1f64.i64(<vscale x 1 x double> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], <vscale x 1 x i1> [[MASK:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_f64m1_m(vbool64_t mask, double *base, ptrdiff_t bstride, vfloat64m1_t value, size_t vl) {
  return __riscv_vsse64_v_f64m1_m(mask, base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_f64m2_m(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.mask.nxv2f64.i64(<vscale x 2 x double> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], <vscale x 2 x i1> [[MASK:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_f64m2_m(vbool32_t mask, double *base, ptrdiff_t bstride, vfloat64m2_t value, size_t vl) {
  return __riscv_vsse64_v_f64m2_m(mask, base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_f64m4_m(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.mask.nxv4f64.i64(<vscale x 4 x double> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], <vscale x 4 x i1> [[MASK:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_f64m4_m(vbool16_t mask, double *base, ptrdiff_t bstride, vfloat64m4_t value, size_t vl) {
  return __riscv_vsse64_v_f64m4_m(mask, base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_f64m8_m(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.mask.nxv8f64.i64(<vscale x 8 x double> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], <vscale x 8 x i1> [[MASK:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_f64m8_m(vbool8_t mask, double *base, ptrdiff_t bstride, vfloat64m8_t value, size_t vl) {
  return __riscv_vsse64_v_f64m8_m(mask, base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_i64m1_m(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.mask.nxv1i64.i64(<vscale x 1 x i64> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], <vscale x 1 x i1> [[MASK:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_i64m1_m(vbool64_t mask, int64_t *base, ptrdiff_t bstride, vint64m1_t value, size_t vl) {
  return __riscv_vsse64_v_i64m1_m(mask, base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_i64m2_m(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.mask.nxv2i64.i64(<vscale x 2 x i64> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], <vscale x 2 x i1> [[MASK:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_i64m2_m(vbool32_t mask, int64_t *base, ptrdiff_t bstride, vint64m2_t value, size_t vl) {
  return __riscv_vsse64_v_i64m2_m(mask, base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_i64m4_m(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.mask.nxv4i64.i64(<vscale x 4 x i64> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], <vscale x 4 x i1> [[MASK:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_i64m4_m(vbool16_t mask, int64_t *base, ptrdiff_t bstride, vint64m4_t value, size_t vl) {
  return __riscv_vsse64_v_i64m4_m(mask, base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_i64m8_m(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.mask.nxv8i64.i64(<vscale x 8 x i64> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], <vscale x 8 x i1> [[MASK:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_i64m8_m(vbool8_t mask, int64_t *base, ptrdiff_t bstride, vint64m8_t value, size_t vl) {
  return __riscv_vsse64_v_i64m8_m(mask, base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_u64m1_m(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.mask.nxv1i64.i64(<vscale x 1 x i64> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], <vscale x 1 x i1> [[MASK:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_u64m1_m(vbool64_t mask, uint64_t *base, ptrdiff_t bstride, vuint64m1_t value, size_t vl) {
  return __riscv_vsse64_v_u64m1_m(mask, base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_u64m2_m(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.mask.nxv2i64.i64(<vscale x 2 x i64> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], <vscale x 2 x i1> [[MASK:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_u64m2_m(vbool32_t mask, uint64_t *base, ptrdiff_t bstride, vuint64m2_t value, size_t vl) {
  return __riscv_vsse64_v_u64m2_m(mask, base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_u64m4_m(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.mask.nxv4i64.i64(<vscale x 4 x i64> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], <vscale x 4 x i1> [[MASK:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_u64m4_m(vbool16_t mask, uint64_t *base, ptrdiff_t bstride, vuint64m4_t value, size_t vl) {
  return __riscv_vsse64_v_u64m4_m(mask, base, bstride, value, vl);
}

// CHECK-RV64-LABEL: @test_vsse64_v_u64m8_m(
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    call void @llvm.riscv.vsse.mask.nxv8i64.i64(<vscale x 8 x i64> [[VALUE:%.*]], ptr [[BASE:%.*]], i64 [[BSTRIDE:%.*]], <vscale x 8 x i1> [[MASK:%.*]], i64 [[VL:%.*]])
// CHECK-RV64-NEXT:    ret void
//
void test_vsse64_v_u64m8_m(vbool8_t mask, uint64_t *base, ptrdiff_t bstride, vuint64m8_t value, size_t vl) {
  return __riscv_vsse64_v_u64m8_m(mask, base, bstride, value, vl);
}
