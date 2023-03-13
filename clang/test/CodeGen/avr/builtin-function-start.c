// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --function-signature --check-globals
// RUN: %clang_cc1 -triple avr-- -emit-llvm -o - %s | FileCheck %s

//.
// CHECK: @e = global ptr addrspacecast (ptr addrspace(1) no_cfi @a to ptr), align 1
//.
// CHECK-LABEL: define {{[^@]+}}@a
// CHECK-SAME: () addrspace(1) #[[ATTR0:[0-9]+]] {
// CHECK-NEXT:  entry:
// CHECK-NEXT:    ret void
//
void a(void) {}
const void *e = __builtin_function_start(a);