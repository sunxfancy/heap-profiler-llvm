//===-- Single-precision log(x) function ----------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "src/math/logf.h"
#include "common_constants.h" // Lookup table for (1/f) and log(f)
#include "src/__support/FPUtil/FEnvImpl.h"
#include "src/__support/FPUtil/FPBits.h"
#include "src/__support/FPUtil/PolyEval.h"
#include "src/__support/FPUtil/except_value_utils.h"
#include "src/__support/FPUtil/multiply_add.h"
#include "src/__support/common.h"
#include "src/__support/macros/optimization.h" // LIBC_UNLIKELY
#include "src/__support/macros/properties/cpu_features.h"

// This is an algorithm for log(x) in single precision which is correctly
// rounded for all rounding modes, based on the implementation of log(x) from
// the RLIBM project at:
// https://people.cs.rutgers.edu/~sn349/rlibm

// Step 1 - Range reduction:
//   For x = 2^m * 1.mant, log(x) = m * log(2) + log(1.m)
//   If x is denormal, we normalize it by multiplying x by 2^23 and subtracting
//   m by 23.

// Step 2 - Another range reduction:
//   To compute log(1.mant), let f be the highest 8 bits including the hidden
// bit, and d be the difference (1.mant - f), i.e. the remaining 16 bits of the
// mantissa. Then we have the following approximation formula:
//   log(1.mant) = log(f) + log(1.mant / f)
//               = log(f) + log(1 + d/f)
//               ~ log(f) + P(d/f)
// since d/f is sufficiently small.
//   log(f) and 1/f are then stored in two 2^7 = 128 entries look-up tables.

// Step 3 - Polynomial approximation:
//   To compute P(d/f), we use a single degree-5 polynomial in double precision
// which provides correct rounding for all but few exception values.
//   For more detail about how this polynomial is obtained, please refer to the
// paper:
//   Lim, J. and Nagarakatte, S., "One Polynomial Approximation to Produce
// Correctly Rounded Results of an Elementary Function for Multiple
// Representations and Rounding Modes", Proceedings of the 49th ACM SIGPLAN
// Symposium on Principles of Programming Languages (POPL-2022), Philadelphia,
// USA, January 16-22, 2022.
// https://people.cs.rutgers.edu/~sn349/papers/rlibmall-popl-2022.pdf

namespace __llvm_libc {

LLVM_LIBC_FUNCTION(float, logf, (float x)) {
  constexpr double LOG_2 = 0x1.62e42fefa39efp-1;
  using FPBits = typename fputil::FPBits<float>;
  FPBits xbits(x);
  uint32_t x_u = xbits.uintval();

  using fputil::round_result_slightly_down;
  using fputil::round_result_slightly_up;

  switch (x_u) {
  case 0x3f800001U: // x = 0x1.000002p+0f
    return round_result_slightly_up(0x1.fffffep-24f);
  case 0x41178febU: // x = 0x1.2f1fd6p+3f
    return round_result_slightly_up(0x1.1fcbcep+1f);
  case 0x4c5d65a5U: // x = 0x1.bacb4ap+25f
    return round_result_slightly_down(0x1.1e0696p+4f);
  case 0x500ffb03U: // x = 0x1.1ff606p+33f
    return round_result_slightly_up(0x1.6fdd34p+4f);
  case 0x5cd69e88U: // x = 0x1.ad3d1p+58f
    return round_result_slightly_up(0x1.45c146p+5f);
  case 0x65d890d3U: // x = 0x1.b121a6p+76f
    return round_result_slightly_down(0x1.a9a3f2p+5f);
  case 0x6f31a8ecU: // x = 0x1.6351d8p+95f
    return round_result_slightly_down(0x1.08b512p+6f);
  case 0x7a17f30aU: // x = 0x1.2fe614p+117f
    return round_result_slightly_up(0x1.451436p+6f);
#ifndef LIBC_TARGET_CPU_HAS_FMA
  case 0x1b7679ffU: // x = 0x1.ecf3fep-73f
    return round_result_slightly_up(-0x1.8f8e5ap+5f);
  case 0x1e88452dU: // x = 0x1.108a5ap-66f
    return round_result_slightly_up(-0x1.6d7b18p+5f);
  case 0x5ee8984eU: // x = 0x1.d1309cp+62f;
    return round_result_slightly_up(0x1.5c9442p+5f);
  case 0x665e7ca6U: // x = 0x1.bcf94cp+77f
    return round_result_slightly_up(0x1.af66cp+5f);
  case 0x79e7ec37U: // x = 0x1.cfd86ep+116f
    return round_result_slightly_up(0x1.43ff6ep+6f);
#endif // LIBC_TARGET_CPU_HAS_FMA
  }

  int m = -FPBits::EXPONENT_BIAS;

  if (LIBC_UNLIKELY(x_u < FPBits::MIN_NORMAL || x_u > FPBits::MAX_NORMAL)) {
    if (xbits.is_zero()) {
      // Return -inf and raise FE_DIVBYZERO
      fputil::set_errno_if_required(ERANGE);
      fputil::raise_except_if_required(FE_DIVBYZERO);
      return static_cast<float>(FPBits::neg_inf());
    }
    if (xbits.get_sign() && !xbits.is_nan()) {
      // Return NaN and raise FE_INVALID
      fputil::set_errno_if_required(EDOM);
      fputil::raise_except_if_required(FE_INVALID);
      return FPBits::build_quiet_nan(0);
    }
    if (xbits.is_inf_or_nan()) {
      return x;
    }
    // Normalize denormal inputs.
    xbits.set_val(xbits.get_val() * 0x1.0p23f);
    m -= 23;
  }

  m += xbits.get_unbiased_exponent();
  int f_index = xbits.get_mantissa() >> 16;
  // Set bits to 1.m
  xbits.set_unbiased_exponent(0x7F);

  FPBits f = xbits;
  f.bits &= ~0x0000'FFFF;

  double d = static_cast<float>(xbits) - static_cast<float>(f);
  d *= ONE_OVER_F[f_index];

  double extra_factor =
      fputil::multiply_add(static_cast<double>(m), LOG_2, LOG_F[f_index]);

  double r = __llvm_libc::fputil::polyeval(
      d, extra_factor, 0x1.fffffffffffacp-1, -0x1.fffffffef9cb2p-2,
      0x1.5555513bc679ap-2, -0x1.fff4805ea441p-3, 0x1.930180dbde91ap-3);

  return static_cast<float>(r);
}

} // namespace __llvm_libc
