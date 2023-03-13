; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=slp-vectorizer -S -mtriple=x86_64-unknown-linux -mattr=+avx2 -pass-remarks-output=%t | FileCheck %s
; RUN: FileCheck %s --input-file=%t --check-prefix=YAML

; YAML: --- !Passed
; YAML: Pass:            slp-vectorizer
; YAML: Name:            VectorizedList
; YAML: Function:        multi_uses
; YAML: Args:
; YAML:  - String:          'SLP vectorized with cost '
; YAML:  - Cost:            '-1'
; YAML:  - String:          ' and with tree size '
; YAML:  - TreeSize:        '3'

define float @multi_uses(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @multi_uses(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <2 x float> [[Y:%.*]], <2 x float> poison, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP2:%.*]] = fmul <2 x float> [[X:%.*]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <2 x float> [[TMP2]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <2 x float> [[TMP2]], i32 1
; CHECK-NEXT:    [[ADD:%.*]] = fadd float [[TMP3]], [[TMP4]]
; CHECK-NEXT:    ret float [[ADD]]
;
  %x0 = extractelement <2 x float> %x, i32 0
  %x1 = extractelement <2 x float> %x, i32 1
  %y1 = extractelement <2 x float> %y, i32 1
  %x0x0 = fmul float %x0, %y1
  %x1x1 = fmul float %x1, %y1
  %add = fadd float %x0x0, %x1x1
  ret float %add
}