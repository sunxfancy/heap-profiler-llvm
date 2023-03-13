; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test lib call simplification of __memmove_chk calls with various values
; for dstlen and len.
;
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"

%struct.T1 = type { [100 x i32], [100 x i32], [1024 x i8] }
%struct.T2 = type { [100 x i32], [100 x i32], [1024 x i8] }
%struct.T3 = type { [100 x i32], [100 x i32], [2048 x i8] }

@t1 = common global %struct.T1 zeroinitializer
@t2 = common global %struct.T2 zeroinitializer
@t3 = common global %struct.T3 zeroinitializer

; Check cases where dstlen >= len.

define ptr @test_simplify1() {
; CHECK-LABEL: @test_simplify1(
; CHECK-NEXT:    call void @llvm.memmove.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(1824) @t1, ptr noundef nonnull align 4 dereferenceable(1824) @t2, i64 1824, i1 false)
; CHECK-NEXT:    ret ptr @t1
;

  %ret = call ptr @__memmove_chk(ptr @t1, ptr @t2, i64 1824, i64 1824)
  ret ptr %ret
}

define ptr @test_simplify2() {
; CHECK-LABEL: @test_simplify2(
; CHECK-NEXT:    call void @llvm.memmove.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(1824) @t1, ptr noundef nonnull align 4 dereferenceable(1824) @t3, i64 1824, i1 false)
; CHECK-NEXT:    ret ptr @t1
;

  %ret = call ptr @__memmove_chk(ptr @t1, ptr @t3, i64 1824, i64 2848)
  ret ptr %ret
}

define ptr @test_simplify3() {
; CHECK-LABEL: @test_simplify3(
; CHECK-NEXT:    tail call void @llvm.memmove.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(1824) @t1, ptr noundef nonnull align 4 dereferenceable(1824) @t2, i64 1824, i1 false)
; CHECK-NEXT:    ret ptr @t1
;

  %ret = tail call ptr @__memmove_chk(ptr @t1, ptr @t2, i64 1824, i64 1824)
  ret ptr %ret
}

; Check cases where dstlen < len.

define ptr @test_no_simplify1() {
; CHECK-LABEL: @test_no_simplify1(
; CHECK-NEXT:    [[RET:%.*]] = call ptr @__memmove_chk(ptr nonnull @t3, ptr nonnull @t1, i64 2848, i64 1824)
; CHECK-NEXT:    ret ptr [[RET]]
;

  %ret = call ptr @__memmove_chk(ptr @t3, ptr @t1, i64 2848, i64 1824)
  ret ptr %ret
}

define ptr @test_no_simplify2() {
; CHECK-LABEL: @test_no_simplify2(
; CHECK-NEXT:    [[RET:%.*]] = call ptr @__memmove_chk(ptr nonnull @t1, ptr nonnull @t2, i64 1024, i64 0)
; CHECK-NEXT:    ret ptr [[RET]]
;

  %ret = call ptr @__memmove_chk(ptr @t1, ptr @t2, i64 1024, i64 0)
  ret ptr %ret
}

define ptr @test_no_simplify3(ptr %dst, ptr %src, i64 %a, i64 %b) {
; CHECK-LABEL: @test_no_simplify3(
; CHECK-NEXT:    [[RET:%.*]] = musttail call ptr @__memmove_chk(ptr [[DST:%.*]], ptr [[SRC:%.*]], i64 1824, i64 1824)
; CHECK-NEXT:    ret ptr [[RET]]
;
  %ret = musttail call ptr @__memmove_chk(ptr %dst, ptr %src, i64 1824, i64 1824)
  ret ptr %ret
}

define ptr @test_no_incompatible_attr(ptr %mem, i32 %val, i32 %size) {
; CHECK-LABEL: @test_no_incompatible_attr(
; CHECK-NEXT:    call void @llvm.memmove.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(1824) @t1, ptr noundef nonnull align 4 dereferenceable(1824) @t2, i64 1824, i1 false)
; CHECK-NEXT:    ret ptr @t1
;

  %ret = call dereferenceable(1) ptr @__memmove_chk(ptr @t1, ptr @t2, i64 1824, i64 1824)
  ret ptr %ret
}

declare ptr @__memmove_chk(ptr, ptr, i64, i64)