//===-- RISCVBaseInfo.cpp - Top level definitions for RISCV MC ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains small standalone enum definitions for the RISCV target
// useful for the compiler back-end and the MC libraries.
//
//===----------------------------------------------------------------------===//

#include "RISCVBaseInfo.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/RISCVISAInfo.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/TargetParser.h"
#include "llvm/TargetParser/Triple.h"

namespace llvm {

extern const SubtargetFeatureKV RISCVFeatureKV[RISCV::NumSubtargetFeatures];

namespace RISCVSysReg {
#define GET_SysRegsList_IMPL
#include "RISCVGenSearchableTables.inc"
} // namespace RISCVSysReg

namespace RISCVInsnOpcode {
#define GET_RISCVOpcodesList_IMPL
#include "RISCVGenSearchableTables.inc"
} // namespace RISCVInsnOpcode

namespace RISCVABI {
ABI computeTargetABI(const Triple &TT, FeatureBitset FeatureBits,
                     StringRef ABIName) {
  auto TargetABI = getTargetABI(ABIName);
  bool IsRV64 = TT.isArch64Bit();
  bool IsRV32E = FeatureBits[RISCV::FeatureRV32E];

  if (!ABIName.empty() && TargetABI == ABI_Unknown) {
    errs()
        << "'" << ABIName
        << "' is not a recognized ABI for this target (ignoring target-abi)\n";
  } else if (ABIName.startswith("ilp32") && IsRV64) {
    errs() << "32-bit ABIs are not supported for 64-bit targets (ignoring "
              "target-abi)\n";
    TargetABI = ABI_Unknown;
  } else if (ABIName.startswith("lp64") && !IsRV64) {
    errs() << "64-bit ABIs are not supported for 32-bit targets (ignoring "
              "target-abi)\n";
    TargetABI = ABI_Unknown;
  } else if (IsRV32E && TargetABI != ABI_ILP32E && TargetABI != ABI_Unknown) {
    // TODO: move this checking to RISCVTargetLowering and RISCVAsmParser
    errs()
        << "Only the ilp32e ABI is supported for RV32E (ignoring target-abi)\n";
    TargetABI = ABI_Unknown;
  }

  if (TargetABI != ABI_Unknown)
    return TargetABI;

  // If no explicit ABI is given, try to compute the default ABI.
  auto ISAInfo = RISCVFeatures::parseFeatureBits(IsRV64, FeatureBits);
  if (!ISAInfo)
    report_fatal_error(ISAInfo.takeError());
  return getTargetABI((*ISAInfo)->computeDefaultABI());
}

ABI getTargetABI(StringRef ABIName) {
  auto TargetABI = StringSwitch<ABI>(ABIName)
                       .Case("ilp32", ABI_ILP32)
                       .Case("ilp32f", ABI_ILP32F)
                       .Case("ilp32d", ABI_ILP32D)
                       .Case("ilp32e", ABI_ILP32E)
                       .Case("lp64", ABI_LP64)
                       .Case("lp64f", ABI_LP64F)
                       .Case("lp64d", ABI_LP64D)
                       .Default(ABI_Unknown);
  return TargetABI;
}

// To avoid the BP value clobbered by a function call, we need to choose a
// callee saved register to save the value. RV32E only has X8 and X9 as callee
// saved registers and X8 will be used as fp. So we choose X9 as bp.
MCRegister getBPReg() { return RISCV::X9; }

// Returns the register holding shadow call stack pointer.
MCRegister getSCSPReg() { return RISCV::X18; }

} // namespace RISCVABI

namespace RISCVFeatures {

void validate(const Triple &TT, const FeatureBitset &FeatureBits) {
  if (TT.isArch64Bit() && !FeatureBits[RISCV::Feature64Bit])
    report_fatal_error("RV64 target requires an RV64 CPU");
  if (!TT.isArch64Bit() && !FeatureBits[RISCV::Feature32Bit])
    report_fatal_error("RV32 target requires an RV32 CPU");
  if (TT.isArch64Bit() && FeatureBits[RISCV::FeatureRV32E])
    report_fatal_error("RV32E can't be enabled for an RV64 target");
  if (FeatureBits[RISCV::Feature32Bit] &&
      FeatureBits[RISCV::Feature64Bit])
    report_fatal_error("RV32 and RV64 can't be combined");
}

llvm::Expected<std::unique_ptr<RISCVISAInfo>>
parseFeatureBits(bool IsRV64, const FeatureBitset &FeatureBits) {
  unsigned XLen = IsRV64 ? 64 : 32;
  std::vector<std::string> FeatureVector;
  // Convert FeatureBitset to FeatureVector.
  for (auto Feature : RISCVFeatureKV) {
    if (FeatureBits[Feature.Value] &&
        llvm::RISCVISAInfo::isSupportedExtensionFeature(Feature.Key))
      FeatureVector.push_back(std::string("+") + Feature.Key);
  }
  return llvm::RISCVISAInfo::parseFeatures(XLen, FeatureVector);
}

} // namespace RISCVFeatures

// Encode VTYPE into the binary format used by the the VSETVLI instruction which
// is used by our MC layer representation.
//
// Bits | Name       | Description
// -----+------------+------------------------------------------------
// 7    | vma        | Vector mask agnostic
// 6    | vta        | Vector tail agnostic
// 5:3  | vsew[2:0]  | Standard element width (SEW) setting
// 2:0  | vlmul[2:0] | Vector register group multiplier (LMUL) setting
unsigned RISCVVType::encodeVTYPE(RISCVII::VLMUL VLMUL, unsigned SEW,
                                 bool TailAgnostic, bool MaskAgnostic) {
  assert(isValidSEW(SEW) && "Invalid SEW");
  unsigned VLMULBits = static_cast<unsigned>(VLMUL);
  unsigned VSEWBits = encodeSEW(SEW);
  unsigned VTypeI = (VSEWBits << 3) | (VLMULBits & 0x7);
  if (TailAgnostic)
    VTypeI |= 0x40;
  if (MaskAgnostic)
    VTypeI |= 0x80;

  return VTypeI;
}

std::pair<unsigned, bool> RISCVVType::decodeVLMUL(RISCVII::VLMUL VLMUL) {
  switch (VLMUL) {
  default:
    llvm_unreachable("Unexpected LMUL value!");
  case RISCVII::VLMUL::LMUL_1:
  case RISCVII::VLMUL::LMUL_2:
  case RISCVII::VLMUL::LMUL_4:
  case RISCVII::VLMUL::LMUL_8:
    return std::make_pair(1 << static_cast<unsigned>(VLMUL), false);
  case RISCVII::VLMUL::LMUL_F2:
  case RISCVII::VLMUL::LMUL_F4:
  case RISCVII::VLMUL::LMUL_F8:
    return std::make_pair(1 << (8 - static_cast<unsigned>(VLMUL)), true);
  }
}

void RISCVVType::printVType(unsigned VType, raw_ostream &OS) {
  unsigned Sew = getSEW(VType);
  OS << "e" << Sew;

  unsigned LMul;
  bool Fractional;
  std::tie(LMul, Fractional) = decodeVLMUL(getVLMUL(VType));

  if (Fractional)
    OS << ", mf";
  else
    OS << ", m";
  OS << LMul;

  if (isTailAgnostic(VType))
    OS << ", ta";
  else
    OS << ", tu";

  if (isMaskAgnostic(VType))
    OS << ", ma";
  else
    OS << ", mu";
}

unsigned RISCVVType::getSEWLMULRatio(unsigned SEW, RISCVII::VLMUL VLMul) {
  unsigned LMul;
  bool Fractional;
  std::tie(LMul, Fractional) = decodeVLMUL(VLMul);

  // Convert LMul to a fixed point value with 3 fractional bits.
  LMul = Fractional ? (8 / LMul) : (LMul * 8);

  assert(SEW >= 8 && "Unexpected SEW value");
  return (SEW * 8) / LMul;
}

// Include the auto-generated portion of the compress emitter.
#define GEN_UNCOMPRESS_INSTR
#define GEN_COMPRESS_INSTR
#include "RISCVGenCompressInstEmitter.inc"

bool RISCVRVC::compress(MCInst &OutInst, const MCInst &MI,
                        const MCSubtargetInfo &STI) {
  return compressInst(OutInst, MI, STI);
}

bool RISCVRVC::uncompress(MCInst &OutInst, const MCInst &MI,
                          const MCSubtargetInfo &STI) {
  return uncompressInst(OutInst, MI, STI);
}

// Lookup table for fli.h for entries 1-31. Entry 0(-1.0) is handled separately.
// NOTE: The exponent for entry 1 is larger than entry 2 and 3 because they
// are denormals.
static constexpr std::pair<uint8_t, uint8_t> LoadFP16ImmArr[] = {
    {0b00001, 0b00}, {0b00000, 0b01}, {0b00000, 0b10}, {0b00111, 0b00},
    {0b01000, 0b00}, {0b01011, 0b00}, {0b01100, 0b00}, {0b01101, 0b00},
    {0b01101, 0b01}, {0b01101, 0b10}, {0b01101, 0b11}, {0b01110, 0b00},
    {0b01110, 0b01}, {0b01110, 0b10}, {0b01110, 0b11}, {0b01111, 0b00},
    {0b01111, 0b01}, {0b01111, 0b10}, {0b01111, 0b11}, {0b10000, 0b00},
    {0b10000, 0b01}, {0b10000, 0b10}, {0b10001, 0b00}, {0b10010, 0b00},
    {0b10011, 0b00}, {0b10110, 0b00}, {0b10111, 0b00}, {0b11110, 0b00},
    {0b11111, 0b00}, {0b11111, 0b00}, {0b11111, 0b10},
};

// Lookup table for fli.s for entries 1-31.
static constexpr std::pair<uint8_t, uint8_t> LoadFP32ImmArr[] = {
    {0b00000001, 0b00}, {0b01101111, 0b00}, {0b01110000, 0b00},
    {0b01110111, 0b00}, {0b01111000, 0b00}, {0b01111011, 0b00},
    {0b01111100, 0b00}, {0b01111101, 0b00}, {0b01111101, 0b01},
    {0b01111101, 0b10}, {0b01111101, 0b11}, {0b01111110, 0b00},
    {0b01111110, 0b01}, {0b01111110, 0b10}, {0b01111110, 0b11},
    {0b01111111, 0b00}, {0b01111111, 0b01}, {0b01111111, 0b10},
    {0b01111111, 0b11}, {0b10000000, 0b00}, {0b10000000, 0b01},
    {0b10000000, 0b10}, {0b10000001, 0b00}, {0b10000010, 0b00},
    {0b10000011, 0b00}, {0b10000110, 0b00}, {0b10000111, 0b00},
    {0b10001110, 0b00}, {0b10001111, 0b00}, {0b11111111, 0b00},
    {0b11111111, 0b10},
};

// Lookup table for fli.d for entries 1-31.
static constexpr std::pair<uint16_t, uint8_t> LoadFP64ImmArr[] = {
    {0b00000000001, 0b00}, {0b01111101111, 0b00}, {0b01111110000, 0b00},
    {0b01111110111, 0b00}, {0b01111111000, 0b00}, {0b01111111011, 0b00},
    {0b01111111100, 0b00}, {0b01111111101, 0b00}, {0b01111111101, 0b01},
    {0b01111111101, 0b10}, {0b01111111101, 0b11}, {0b01111111110, 0b00},
    {0b01111111110, 0b01}, {0b01111111110, 0b10}, {0b01111111110, 0b11},
    {0b01111111111, 0b00}, {0b01111111111, 0b01}, {0b01111111111, 0b10},
    {0b01111111111, 0b11}, {0b10000000000, 0b00}, {0b10000000000, 0b01},
    {0b10000000000, 0b10}, {0b10000000001, 0b00}, {0b10000000010, 0b00},
    {0b10000000011, 0b00}, {0b10000000110, 0b00}, {0b10000000111, 0b00},
    {0b10000001110, 0b00}, {0b10000001111, 0b00}, {0b11111111111, 0b00},
    {0b11111111111, 0b10},
};

int RISCVLoadFPImm::getLoadFP16Imm(const APFloat &FPImm) {
  assert(&FPImm.getSemantics() == &APFloat::IEEEhalf());

  APInt Imm = FPImm.bitcastToAPInt();

  if (Imm.extractBitsAsZExtValue(8, 0) != 0)
    return -1;

  bool Sign = Imm.extractBitsAsZExtValue(1, 15);
  uint8_t Mantissa = Imm.extractBitsAsZExtValue(2, 8);
  uint8_t Exp = Imm.extractBitsAsZExtValue(5, 10);

  // The array isn't sorted so we must use std::find unlike fp32 and fp64.
  auto EMI = llvm::find(LoadFP16ImmArr, std::make_pair(Exp, Mantissa));
  if (EMI == std::end(LoadFP16ImmArr))
    return -1;

  // Table doesn't have entry 0.
  int Entry = std::distance(std::begin(LoadFP16ImmArr), EMI) + 1;

  // The only legal negative value is -1.0(entry 0). 1.0 is entry 16.
  if (Sign) {
    if (Entry == 16)
      return 0;
    return false;
  }

  // Entry 29 and 30 are both infinity, but 30 is the real infinity.
  if (Entry == 29)
    ++Entry;

  return Entry;
}

int RISCVLoadFPImm::getLoadFP32Imm(const APFloat &FPImm) {
  assert(&FPImm.getSemantics() == &APFloat::IEEEsingle());

  APInt Imm = FPImm.bitcastToAPInt();

  if (Imm.extractBitsAsZExtValue(21, 0) != 0)
    return -1;

  bool Sign = Imm.extractBitsAsZExtValue(1, 31);
  uint8_t Mantissa = Imm.extractBitsAsZExtValue(2, 21);
  uint8_t Exp = Imm.extractBitsAsZExtValue(8, 23);

  auto EMI = llvm::lower_bound(LoadFP32ImmArr, std::make_pair(Exp, Mantissa));
  if (EMI == std::end(LoadFP32ImmArr) || EMI->first != Exp ||
      EMI->second != Mantissa)
    return -1;

  // Table doesn't have entry 0.
  int Entry = std::distance(std::begin(LoadFP32ImmArr), EMI) + 1;

  // The only legal negative value is -1.0(entry 0). 1.0 is entry 16.
  if (Sign) {
    if (Entry == 16)
      return 0;
    return false;
  }

  return Entry;
}

int RISCVLoadFPImm::getLoadFP64Imm(const APFloat &FPImm) {
  assert(&FPImm.getSemantics() == &APFloat::IEEEdouble());

  APInt Imm = FPImm.bitcastToAPInt();

  if (Imm.extractBitsAsZExtValue(50, 0) != 0)
    return -1;

  bool Sign = Imm.extractBitsAsZExtValue(1, 63);
  uint8_t Mantissa = Imm.extractBitsAsZExtValue(2, 50);
  uint16_t Exp = Imm.extractBitsAsZExtValue(11, 52);

  auto EMI = llvm::lower_bound(LoadFP64ImmArr, std::make_pair(Exp, Mantissa));
  if (EMI == std::end(LoadFP64ImmArr) || EMI->first != Exp ||
      EMI->second != Mantissa)
    return -1;

  // Table doesn't have entry 0.
  int Entry = std::distance(std::begin(LoadFP64ImmArr), EMI) + 1;

  // The only legal negative value is -1.0(entry 0). 1.0 is entry 16.
  if (Sign) {
    if (Entry == 16)
      return 0;
    return false;
  }

  return Entry;
}

float RISCVLoadFPImm::getFPImm(unsigned Imm) {
  assert(Imm != 1 && Imm != 30 && Imm != 31 && "Unsupported immediate");

  // Entry 0 is -1.0, the only negative value. Entry 16 is 1.0.
  uint32_t Sign = 0;
  if (Imm == 0) {
    Sign = 0b1;
    Imm = 16;
  }

  uint32_t Exp = LoadFP32ImmArr[Imm - 1].first;
  uint32_t Mantissa = LoadFP32ImmArr[Imm - 1].second;

  uint32_t I = Sign << 31 | Exp << 23 | Mantissa << 21;
  return bit_cast<float>(I);
}

} // namespace llvm