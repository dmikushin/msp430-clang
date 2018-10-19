//===--- MSP430.cpp - MSP430 Helpers for Tools ------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "MSP430.h"
#include "CommonArgs.h"
#include "Gnu.h"
#include "InputInfo.h"
#include "clang/Driver/Compilation.h"
#include "clang/Driver/Multilib.h"
#include "clang/Driver/Options.h"
#include "llvm/Option/ArgList.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Path.h"

using namespace clang::driver;
using namespace clang::driver::toolchains;
using namespace clang::driver::tools;
using namespace clang;
using namespace llvm::opt;

static bool isSupportedMCU(const StringRef MCU) {
  return llvm::StringSwitch<bool>(MCU)
#define MSP430_MCU(NAME) .Case(NAME, true)
#include "clang/Basic/MSP430Target.def"
      .Default(false);
}

void msp430::getMSP430TargetFeatures(const Driver &D, const ArgList &Args,
                                     std::vector<StringRef> &Features) {
  const Arg *MCUArg = Args.getLastArg(options::OPT_mmcu_EQ);
  if (MCUArg && !isSupportedMCU(MCUArg->getValue())) {
    D.Diag(diag::err_drv_msp430_unknown_mcu) << MCUArg->getValue();
    return;
  }
}

/// MSP430 Toolchain
MSP430ToolChain::MSP430ToolChain(const Driver &D, const llvm::Triple &Triple,
                                 const ArgList &Args)
    : Generic_ELF(D, Triple, Args) {

  GCCInstallation.init(Triple, Args);
  if (GCCInstallation.isValid()) {
    StringRef MultilibSuf = GCCInstallation.getMultilib().gccSuffix();
    getFilePaths().push_back((computeSysRoot() + "/lib" + MultilibSuf).str());
    getFilePaths().push_back(
        (GCCInstallation.getInstallPath() + MultilibSuf).str());
    getProgramPaths().push_back(
        (GCCInstallation.getParentLibPath() + "/../bin").str());
  }
}

Tool *MSP430ToolChain::buildLinker() const {
  return new tools::msp430::Linker(*this);
}

void MSP430ToolChain::AddClangSystemIncludeArgs(const ArgList &DriverArgs,
                                                ArgStringList &CC1Args) const {
  if (DriverArgs.hasArg(options::OPT_nostdinc))
    return;

  if (!DriverArgs.hasArg(options::OPT_nostdlibinc)) {
    SmallString<128> Dir(computeSysRoot());
    llvm::sys::path::append(Dir, "include");
    addSystemInclude(DriverArgs, CC1Args, Dir.str());
  }
}

void MSP430ToolChain::addClangTargetOptions(const ArgList &DriverArgs,
                                            ArgStringList &CC1Args,
                                            Action::OffloadKind) const {
  const auto *MCUArg = DriverArgs.getLastArg(options::OPT_mmcu_EQ);
  if (!MCUArg)
    return;

  const StringRef MCU = MCUArg->getValue();
  if (MCU.startswith("msp430i")) {
    // 'i' should be in lower case as it's defined in TI MSP430-GCC headers
    CC1Args.push_back(DriverArgs.MakeArgString(
        "-D__MSP430i" + MCU.drop_front(7).upper() + "__"));
  } else {
    CC1Args.push_back(DriverArgs.MakeArgString("-D__" + MCU.upper() + "__"));
  }
}

std::string MSP430ToolChain::computeSysRoot() const {
  if (!getDriver().SysRoot.empty())
    return getDriver().SysRoot;

  if (!GCCInstallation.isValid())
    return std::string();

  StringRef LibDir = GCCInstallation.getParentLibPath();
  StringRef TripleStr = GCCInstallation.getTriple().str();
  std::string SysRootDir = LibDir.str() + "/../" + TripleStr.str();

  if (!llvm::sys::fs::exists(SysRootDir))
    return std::string();

  return SysRootDir;
}


void msp430::Linker::ConstructJob(Compilation &C, const JobAction &JA,
                                  const InputInfo &Output,
                                  const InputInfoList &Inputs,
                                  const ArgList &Args,
                                  const char *LinkingOutput) const {
  const ToolChain &ToolChain = getToolChain();
  const Driver &D = ToolChain.getDriver();
  std::string Linker = ToolChain.GetProgramPath(getShortName());
  ArgStringList CmdArgs;

  if (!D.SysRoot.empty())
    CmdArgs.push_back(Args.MakeArgString("--sysroot=" + D.SysRoot));

  Args.AddAllArgs(CmdArgs, options::OPT_L);
  ToolChain.AddFilePathLibArgs(Args, CmdArgs);

  if (!Args.hasArg(options::OPT_T)) {
    if (const Arg *MCUArg = Args.getLastArg(options::OPT_mmcu_EQ))
      CmdArgs.push_back(
          Args.MakeArgString("-T" + StringRef(MCUArg->getValue()) + ".ld"));
  } else {
    Args.AddAllArgs(CmdArgs, options::OPT_T);
  }

  if (!Args.hasArg(options::OPT_nostdlib, options::OPT_nostartfiles)) {
    CmdArgs.push_back(Args.MakeArgString(ToolChain.GetFilePath("crt0.o")));
    CmdArgs.push_back(Args.MakeArgString(ToolChain.GetFilePath("crtbegin.o")));
  }

  AddLinkerInputs(getToolChain(), Inputs, Args, CmdArgs, JA);

  CmdArgs.push_back("--start-group");
  CmdArgs.push_back("-lgcc");
  if (!Args.hasArg(options::OPT_nostdlib, options::OPT_nodefaultlibs)) {
    CmdArgs.push_back("-lc");
    CmdArgs.push_back("-lcrt");
    CmdArgs.push_back("-lnosys");
  }
  CmdArgs.push_back("--end-group");

  if (!Args.hasArg(options::OPT_nostdlib, options::OPT_nostartfiles)) {
    CmdArgs.push_back(Args.MakeArgString(ToolChain.GetFilePath("crtend.o")));
    CmdArgs.push_back(Args.MakeArgString(ToolChain.GetFilePath("crtn.o")));
  }
  CmdArgs.push_back("-o");
  CmdArgs.push_back(Output.getFilename());
  C.addCommand(llvm::make_unique<Command>(JA, *this, Args.MakeArgString(Linker),
                                          CmdArgs, Inputs));
}