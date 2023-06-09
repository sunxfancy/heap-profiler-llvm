//===-- TestMatchers.cpp ----------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "FPMatcher.h"

#include "src/__support/FPUtil/FPBits.h"

#include "test/UnitTest/StringUtils.h"

#include <sstream>
#include <string>

namespace __llvm_libc {
namespace fputil {
namespace testing {

template <typename ValType, typename StreamType>
cpp::enable_if_t<cpp::is_floating_point_v<ValType>, void>
describeValue(const char *label, ValType value, StreamType &stream) {
  stream << label;

  FPBits<ValType> bits(value);
  if (bits.is_nan()) {
    stream << "(NaN)";
  } else if (bits.is_inf()) {
    if (bits.get_sign())
      stream << "(-Infinity)";
    else
      stream << "(+Infinity)";
  } else {
    constexpr int exponentWidthInHex =
        (fputil::ExponentWidth<ValType>::VALUE - 1) / 4 + 1;
    constexpr int mantissaWidthInHex =
        (fputil::MantissaWidth<ValType>::VALUE - 1) / 4 + 1;
    constexpr int bitsWidthInHex =
        sizeof(typename fputil::FPBits<ValType>::UIntType) * 2;

    stream << "0x"
           << int_to_hex<typename fputil::FPBits<ValType>::UIntType>(
                  bits.uintval(), bitsWidthInHex)
           << ", (S | E | M) = (" << (bits.get_sign() ? '1' : '0') << " | 0x"
           << int_to_hex<uint16_t>(bits.get_unbiased_exponent(),
                                   exponentWidthInHex)
           << " | 0x"
           << int_to_hex<typename fputil::FPBits<ValType>::UIntType>(
                  bits.get_mantissa(), mantissaWidthInHex)
           << ")";
  }

  stream << '\n';
}

template void describeValue<float>(const char *, float,
                                   testutils::StreamWrapper &);
template void describeValue<double>(const char *, double,
                                    testutils::StreamWrapper &);
template void describeValue<long double>(const char *, long double,
                                         testutils::StreamWrapper &);

template void describeValue<float>(const char *, float, std::stringstream &);
template void describeValue<double>(const char *, double, std::stringstream &);
template void describeValue<long double>(const char *, long double,
                                         std::stringstream &);

} // namespace testing
} // namespace fputil
} // namespace __llvm_libc
