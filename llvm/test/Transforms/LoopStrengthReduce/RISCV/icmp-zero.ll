; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loop-reduce -S | FileCheck %s

target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n64-S128"
target triple = "riscv64"


define void @icmp_zero(i64 %N, ptr %p) {
; CHECK-LABEL: @icmp_zero(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi i64 [ [[LSR_IV_NEXT:%.*]], [[VECTOR_BODY]] ], [ [[N:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    store i64 0, ptr [[P:%.*]], align 8
; CHECK-NEXT:    [[LSR_IV_NEXT]] = add i64 [[LSR_IV]], -2
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq i64 [[LSR_IV_NEXT]], 0
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT:%.*]], label [[VECTOR_BODY]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %vector.body

vector.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %vector.body ]
  store i64 0, ptr %p
  %iv.next = add i64 %iv, 2
  %done = icmp eq i64 %iv.next, %N
  br i1 %done, label %exit, label %vector.body

exit:
  ret void
}

define void @icmp_zero_urem_nonzero_con(i64 %N, ptr %p) {
; CHECK-LABEL: @icmp_zero_urem_nonzero_con(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[N:%.*]], 16
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi i64 [ [[LSR_IV_NEXT:%.*]], [[VECTOR_BODY]] ], [ [[UREM]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    store i64 0, ptr [[P:%.*]], align 8
; CHECK-NEXT:    [[LSR_IV_NEXT]] = add i64 [[LSR_IV]], -2
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq i64 [[LSR_IV_NEXT]], 0
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT:%.*]], label [[VECTOR_BODY]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %urem = urem i64 %N, 16
  br label %vector.body

vector.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %vector.body ]
  store i64 0, ptr %p
  %iv.next = add i64 %iv, 2
  %done = icmp eq i64 %iv.next, %urem
  br i1 %done, label %exit, label %vector.body

exit:
  ret void
}

define void @icmp_zero_urem_invariant(i64 %N, i64 %M, ptr %p) {
; CHECK-LABEL: @icmp_zero_urem_invariant(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[N:%.*]], [[M:%.*]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi i64 [ [[LSR_IV_NEXT:%.*]], [[VECTOR_BODY]] ], [ [[UREM]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    store i64 0, ptr [[P:%.*]], align 8
; CHECK-NEXT:    [[LSR_IV_NEXT]] = add i64 [[LSR_IV]], -2
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq i64 [[LSR_IV_NEXT]], 0
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT:%.*]], label [[VECTOR_BODY]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %urem = urem i64 %N, %M
  br label %vector.body

vector.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %vector.body ]
  store i64 0, ptr %p
  %iv.next = add i64 %iv, 2
  %done = icmp eq i64 %iv.next, %urem
  br i1 %done, label %exit, label %vector.body

exit:
  ret void
}

; We have to be careful here as SCEV can only compute a subtraction from
; two pointers with the same base.  If we hide %end inside a unknown, we
; can no longer compute the subtract.
define void @icmp_zero_urem_invariant_ptr(i64 %N, i64 %M, ptr %p) {
; CHECK-LABEL: @icmp_zero_urem_invariant_ptr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[N:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[END:%.*]] = getelementptr i64, ptr [[P:%.*]], i64 [[UREM]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[IV:%.*]] = phi ptr [ [[P]], [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    store i64 0, ptr [[P]], align 8
; CHECK-NEXT:    [[IV_NEXT]] = getelementptr i64, ptr [[IV]], i64 1
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq ptr [[IV_NEXT]], [[END]]
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT:%.*]], label [[VECTOR_BODY]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %urem = urem i64 %N, %M
  %end = getelementptr i64, ptr %p, i64 %urem
  br label %vector.body

vector.body:
  %iv = phi ptr [ %p, %entry ], [ %iv.next, %vector.body ]
  store i64 0, ptr %p
  %iv.next = getelementptr i64, ptr %iv, i64 1
  %done = icmp eq ptr %iv.next, %end
  br i1 %done, label %exit, label %vector.body

exit:
  ret void
}

; Negative test - We can not hoist because we don't know value of %M.
define void @icmp_zero_urem_nohoist(i64 %N, i64 %M, ptr %p) {
; CHECK-LABEL: @icmp_zero_urem_nohoist(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    store i64 0, ptr [[P:%.*]], align 8
; CHECK-NEXT:    [[IV_NEXT]] = add i64 [[IV]], 2
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[N:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq i64 [[IV_NEXT]], [[UREM]]
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT:%.*]], label [[VECTOR_BODY]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %vector.body

vector.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %vector.body ]
  store i64 0, ptr %p
  %iv.next = add i64 %iv, 2
  %urem = urem i64 %N, %M
  %done = icmp eq i64 %iv.next, %urem
  br i1 %done, label %exit, label %vector.body

exit:
  ret void
}

define void @icmp_zero_urem_nonzero(i64 %N, i64 %M, ptr %p) {
; CHECK-LABEL: @icmp_zero_urem_nonzero(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[NONZERO:%.*]] = add nuw i64 [[M:%.*]], 1
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[N:%.*]], [[NONZERO]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi i64 [ [[LSR_IV_NEXT:%.*]], [[VECTOR_BODY]] ], [ [[UREM]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    store i64 0, ptr [[P:%.*]], align 8
; CHECK-NEXT:    [[LSR_IV_NEXT]] = add i64 [[LSR_IV]], -2
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq i64 [[LSR_IV_NEXT]], 0
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT:%.*]], label [[VECTOR_BODY]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %nonzero = add nuw i64 %M, 1
  %urem = urem i64 %N, %nonzero
  br label %vector.body

vector.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %vector.body ]
  store i64 0, ptr %p
  %iv.next = add i64 %iv, 2
  %done = icmp eq i64 %iv.next, %urem
  br i1 %done, label %exit, label %vector.body

exit:
  ret void
}

define void @icmp_zero_urem_vscale(i64 %N, ptr %p) {
; CHECK-LABEL: @icmp_zero_urem_vscale(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VSCALE:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[N:%.*]], [[VSCALE]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi i64 [ [[LSR_IV_NEXT:%.*]], [[VECTOR_BODY]] ], [ [[UREM]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    store i64 0, ptr [[P:%.*]], align 8
; CHECK-NEXT:    [[LSR_IV_NEXT]] = add i64 [[LSR_IV]], -2
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq i64 [[LSR_IV_NEXT]], 0
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT:%.*]], label [[VECTOR_BODY]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %vscale = call i64 @llvm.vscale.i64()
  %urem = urem i64 %N, %vscale
  br label %vector.body

vector.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %vector.body ]
  store i64 0, ptr %p
  %iv.next = add i64 %iv, 2
  %done = icmp eq i64 %iv.next, %urem
  br i1 %done, label %exit, label %vector.body

exit:
  ret void
}

define void @icmp_zero_urem_vscale_mul8(i64 %N, ptr %p) {
; CHECK-LABEL: @icmp_zero_urem_vscale_mul8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VSCALE:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[MUL:%.*]] = mul nuw nsw i64 [[VSCALE]], 8
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[N:%.*]], [[MUL]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi i64 [ [[LSR_IV_NEXT:%.*]], [[VECTOR_BODY]] ], [ [[UREM]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    store i64 0, ptr [[P:%.*]], align 8
; CHECK-NEXT:    [[LSR_IV_NEXT]] = add i64 [[LSR_IV]], -2
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq i64 [[LSR_IV_NEXT]], 0
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT:%.*]], label [[VECTOR_BODY]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %vscale = call i64 @llvm.vscale.i64()
  %mul = mul nuw nsw i64 %vscale, 8
  %urem = urem i64 %N, %mul
  br label %vector.body

vector.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %vector.body ]
  store i64 0, ptr %p
  %iv.next = add i64 %iv, 2
  %done = icmp eq i64 %iv.next, %urem
  br i1 %done, label %exit, label %vector.body

exit:
  ret void
}


define void @icmp_zero_urem_vscale_mul64(i64 %N, ptr %p) {
; CHECK-LABEL: @icmp_zero_urem_vscale_mul64(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VSCALE:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[MUL:%.*]] = mul nuw nsw i64 [[VSCALE]], 64
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[N:%.*]], [[MUL]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi i64 [ [[LSR_IV_NEXT:%.*]], [[VECTOR_BODY]] ], [ [[UREM]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    store i64 0, ptr [[P:%.*]], align 8
; CHECK-NEXT:    [[LSR_IV_NEXT]] = add i64 [[LSR_IV]], -2
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq i64 [[LSR_IV_NEXT]], 0
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT:%.*]], label [[VECTOR_BODY]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %vscale = call i64 @llvm.vscale.i64()
  %mul = mul nuw nsw i64 %vscale, 64
  %urem = urem i64 %N, %mul
  br label %vector.body

vector.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %vector.body ]
  store i64 0, ptr %p
  %iv.next = add i64 %iv, 2
  %done = icmp eq i64 %iv.next, %urem
  br i1 %done, label %exit, label %vector.body

exit:
  ret void
}

define void @icmp_zero_urem_vscale_shl3(i64 %N, ptr %p) {
; CHECK-LABEL: @icmp_zero_urem_vscale_shl3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VSCALE:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[SHL:%.*]] = shl i64 [[VSCALE]], 3
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[N:%.*]], [[SHL]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi i64 [ [[LSR_IV_NEXT:%.*]], [[VECTOR_BODY]] ], [ [[UREM]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    store i64 0, ptr [[P:%.*]], align 8
; CHECK-NEXT:    [[LSR_IV_NEXT]] = add i64 [[LSR_IV]], -2
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq i64 [[LSR_IV_NEXT]], 0
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT:%.*]], label [[VECTOR_BODY]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %vscale = call i64 @llvm.vscale.i64()
  %shl = shl i64 %vscale, 3
  %urem = urem i64 %N, %shl
  br label %vector.body

vector.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %vector.body ]
  store i64 0, ptr %p
  %iv.next = add i64 %iv, 2
  %done = icmp eq i64 %iv.next, %urem
  br i1 %done, label %exit, label %vector.body

exit:
  ret void
}

define void @icmp_zero_urem_vscale_shl6(i64 %N, ptr %p) {
; CHECK-LABEL: @icmp_zero_urem_vscale_shl6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VSCALE:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[SHL:%.*]] = shl i64 [[VSCALE]], 6
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[N:%.*]], [[SHL]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi i64 [ [[LSR_IV_NEXT:%.*]], [[VECTOR_BODY]] ], [ [[UREM]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    store i64 0, ptr [[P:%.*]], align 8
; CHECK-NEXT:    [[LSR_IV_NEXT]] = add i64 [[LSR_IV]], -2
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq i64 [[LSR_IV_NEXT]], 0
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT:%.*]], label [[VECTOR_BODY]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %vscale = call i64 @llvm.vscale.i64()
  %shl = shl i64 %vscale, 6
  %urem = urem i64 %N, %shl
  br label %vector.body

vector.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %vector.body ]
  store i64 0, ptr %p
  %iv.next = add i64 %iv, 2
  %done = icmp eq i64 %iv.next, %urem
  br i1 %done, label %exit, label %vector.body

exit:
  ret void
}

; Loop invariant does not neccessarily mean dominating the loop.  Forming
; an ICmpZero from this example would be illegal even though the operands
; to the compare are loop invariant.
define void @loop_invariant_definition(i64 %arg) {
; CHECK-LABEL: @loop_invariant_definition(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[T1:%.*]]
; CHECK:       t1:
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi i64 [ [[LSR_IV_NEXT:%.*]], [[T1]] ], [ -1, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT]] = add nsw i64 [[LSR_IV]], 1
; CHECK-NEXT:    br i1 true, label [[T4:%.*]], label [[T1]]
; CHECK:       t4:
; CHECK-NEXT:    [[T5:%.*]] = trunc i64 [[LSR_IV_NEXT]] to i32
; CHECK-NEXT:    [[T6:%.*]] = add i32 [[T5]], 1
; CHECK-NEXT:    [[T7:%.*]] = icmp eq i32 [[T5]], [[T6]]
; CHECK-NEXT:    ret void
;
entry:
  br label %t1

t1:                                                ; preds = %1, %0
  %t2 = phi i64 [ %t3, %t1 ], [ 0, %entry ]
  %t3 = add nuw i64 %t2, 1
  br i1 true, label %t4, label %t1

t4:                                                ; preds = %1
  %t5 = trunc i64 %t2 to i32
  %t6 = add i32 %t5, 1
  %t7 = icmp eq i32 %t5, %t6
  ret void
}

declare i64 @llvm.vscale.i64()