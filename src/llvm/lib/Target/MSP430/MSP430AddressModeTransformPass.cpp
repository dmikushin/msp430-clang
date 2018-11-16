//===-- MSP430AddressModeTransformPass.cpp - MSP430 optimization pass  ----===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// The pass implements indexed (with 0 displacement) to indirect register
// addressing modes transformation.
//
//===----------------------------------------------------------------------===//

#include "MSP430.h"
#include "MSP430InstrInfo.h"
#include "MSP430Subtarget.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/Target/TargetMachine.h"

using namespace llvm;

#define DEBUG_TYPE "msp430-addr-mode-transform"

namespace {
class MSP430AddrModeTransform : public MachineFunctionPass {
public:
  static char ID;
  MSP430AddrModeTransform() : MachineFunctionPass(ID) {}

  bool runOnMachineFunction(MachineFunction &MF) override;

  StringRef getPassName() const override {
    return "MSP430 indexed to indirect register addressing mode transformation";
  }
};
char MSP430AddrModeTransform::ID = 0;
}

FunctionPass *llvm::createMSP430AddrModeTransformPass() {
  return new MSP430AddrModeTransform();
}

static unsigned getSrcDispIdx(const MachineInstr &MI) {
  switch (MI.getOpcode()) {
  case MSP430::RRA8m:
  case MSP430::RRA16m:
  case MSP430::CALLm:
  case MSP430::SEXT16m:
  case MSP430::SWPB16m:
    return 1; // Single operand instructions
  case MSP430::MOV8rm:
  case MSP430::MOV16rm:
  case MSP430::CMP8rm:
  case MSP430::CMP16rm:
    return 2; // Special case binary operands instructions
              // $r12 = MOV16rm $r13, 0 :: (load 2 from %ir.i)
  default:
    return 3; // Common case binary operands instructions
  }
}

static llvm::Optional<unsigned> getIndRegInstForm(const MachineInstr &MI) {
  switch (MI.getOpcode()) {
#define CASE_BINOP(Name) \
  case MSP430::Name##8rm  : return MSP430::Name##8rn;  \
  case MSP430::Name##16rm : return MSP430::Name##16rn; \
  case MSP430::Name##8mm  : return MSP430::Name##8mn;  \
  case MSP430::Name##16mm : return MSP430::Name##16mn;

  CASE_BINOP(MOV)
  CASE_BINOP(ADD)
  CASE_BINOP(AND)
  CASE_BINOP(BIS)
  CASE_BINOP(BIC)
  CASE_BINOP(XOR)
  CASE_BINOP(SUB)
  CASE_BINOP(CMP)

#undef CASE_BINOP
#define CASE_SINGLOP(Name, Bits) \
  case MSP430::Name##Bits##m : return MSP430::Name##Bits##n;

  CASE_SINGLOP(RRA, 8)
  CASE_SINGLOP(RRA, 16)
// TODO: RRC8m, RRC16m and CALLm aren't generated
//  CASE_SINGLOP(RRC, 8)
//  CASE_SINGLOP(RRC, 16)
//  CASE_SINGLOP(CALL, )
  CASE_SINGLOP(SEXT, 16)
  CASE_SINGLOP(SWPB, 16)

#undef CASE_SINGLEOP

  default:
    return None;
  }
}

static MachineInstr *tryTransformToIndReg(MachineInstr &MI,
                                          unsigned IndRegOpc,
                                          const TargetInstrInfo *TII) {
  unsigned SrcDispIdx = getSrcDispIdx(MI);
  auto &SrcDispOp = MI.getOperand(SrcDispIdx);

  if (!SrcDispOp.isImm() || SrcDispOp.getImm() != 0)
    return nullptr; // Transform is valid only for 0(rn) case

  auto NewMI =
      BuildMI(*MI.getParent(), MI, MI.getDebugLoc(), TII->get(IndRegOpc));

  for (const auto &MO : MI.operands()) {
    if (MI.getOperandNo(&MO) == SrcDispIdx)
      continue; // Skip displacement for src operand
    NewMI.add(MO);
  }
  return NewMI;
}

bool MSP430AddrModeTransform::runOnMachineFunction(MachineFunction &MF) {
  const TargetInstrInfo *TII = MF.getSubtarget().getInstrInfo();
  bool MadeChange = false;

  for (auto MBB = MF.begin(), E = MF.end(); MBB != E; ++MBB) {
    for (auto MI = MBB->begin(), EE = MBB->end(); MI != EE; ++MI) {

      if (Optional<unsigned> IndRegOpc = getIndRegInstForm(*MI)) {
        if (auto *NewMI = tryTransformToIndReg(*MI, *IndRegOpc, TII)) {
          MachineInstr *OldMI = &*MI;
          MI = NewMI;
          OldMI->eraseFromParent();
          MadeChange |= true;
        }
      }
    }
  }
  return MadeChange;
}
