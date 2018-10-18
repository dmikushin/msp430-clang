//===- MSP430.cpp ---------------------------------------------------------===//
//
//                             The LLVM Linker
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "InputFiles.h"
#include "Symbols.h"
#include "Target.h"
#include "lld/Common/ErrorHandler.h"
#include "llvm/Object/ELF.h"
#include "llvm/Support/Endian.h"

using namespace llvm;
using namespace llvm::object;
using namespace llvm::support::endian;
using namespace llvm::ELF;
using namespace lld;
using namespace lld::elf;

namespace {
class MSP430 final : public TargetInfo {
public:
  RelExpr getRelExpr(RelType Type, const Symbol &S,
                     const uint8_t *Loc) const override;
  void relocateOne(uint8_t *Loc, RelType Type, uint64_t Val) const override;
};
} // namespace

RelExpr MSP430::getRelExpr(RelType Type, const Symbol &S,
                           const uint8_t *Loc) const {
  return R_ABS;
}

void MSP430::relocateOne(uint8_t *Loc, RelType Type, uint64_t Val) const {
  switch (Type) {
  case R_MSP430_16_BYTE:
    write16le(Loc, read16le(Loc) | Val);
    break;
  default:
    error(getErrorLocation(Loc) + "unrecognized reloc " + toString(Type));
  }
}

TargetInfo *elf::getMSP430TargetInfo() {
  static MSP430 Target;
  return &Target;
}
