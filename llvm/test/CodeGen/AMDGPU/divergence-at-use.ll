; RUN: llc -march=amdgcn -mcpu=gfx900 -amdgpu-atomic-optimizations=true < %s | FileCheck %s
; RUN: llc -march=amdgcn -mcpu=gfx900 -amdgpu-atomic-optimizations=true < %s -use-gpu-divergence-analysis | FileCheck %s

@local = addrspace(3) global i32 undef

define amdgpu_kernel void @reducible() {
; CHECK-LABEL: reducible:
; CHECK-NOT: dpp
entry:
  %x = call i32 @llvm.amdgcn.workitem.id.x()
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %gep = getelementptr i32, ptr addrspace(3) @local, i32 %i
  %cond = icmp ult i32 %i, %x
  %i1 = add i32 %i, 1
  br i1 %cond, label %loop, label %exit
exit:
  %old = atomicrmw add ptr addrspace(3) %gep, i32 %x acq_rel
  ret void
}

declare i32 @llvm.amdgcn.workitem.id.x()
