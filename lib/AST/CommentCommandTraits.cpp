//===--- CommentCommandTraits.cpp - Comment command properties --*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "clang/AST/CommentCommandTraits.h"
#include "llvm/ADT/StringSwitch.h"

namespace clang {
namespace comments {

// TODO: tablegen

bool CommandTraits::isVerbatimBlockCommand(StringRef BeginName,
                                           StringRef &EndName) const {
  const char *Result = llvm::StringSwitch<const char *>(BeginName)
    .Case("code", "endcode")
    .Case("verbatim", "endverbatim")
    .Case("htmlonly", "endhtmlonly")
    .Case("latexonly", "endlatexonly")
    .Case("xmlonly", "endxmlonly")
    .Case("manonly", "endmanonly")
    .Case("rtfonly", "endrtfonly")

    .Case("dot", "enddot")
    .Case("msc", "endmsc")

    .Case("f$", "f$") // Inline LaTeX formula
    .Case("f[", "f]") // Displayed LaTeX formula
    .Case("f{", "f}") // LaTeX environment

    .Default(NULL);

  if (Result) {
    EndName = Result;
    return true;
  }

  for (VerbatimBlockCommandVector::const_iterator
           I = VerbatimBlockCommands.begin(),
           E = VerbatimBlockCommands.end();
       I != E; ++I)
    if (I->BeginName == BeginName) {
      EndName = I->EndName;
      return true;
    }

  return false;
}

bool CommandTraits::isVerbatimLineCommand(StringRef Name) const {
  bool Result = llvm::StringSwitch<bool>(Name)
  .Case("fn", true)
  .Case("var", true)
  .Case("property", true)
  .Case("typedef", true)

  .Case("overload", true)

  .Case("defgroup", true)
  .Case("ingroup", true)
  .Case("addtogroup", true)
  .Case("weakgroup", true)
  .Case("name", true)

  .Case("section", true)
  .Case("subsection", true)
  .Case("subsubsection", true)
  .Case("paragraph", true)

  .Case("mainpage", true)
  .Case("subpage", true)
  .Case("ref", true)

  .Default(false);

  if (Result)
    return true;

  for (VerbatimLineCommandVector::const_iterator
           I = VerbatimLineCommands.begin(),
           E = VerbatimLineCommands.end();
       I != E; ++I)
    if (I->Name == Name)
      return true;

  return false;
}

void CommandTraits::addVerbatimBlockCommand(StringRef BeginName,
                                            StringRef EndName) {
  VerbatimBlockCommand VBC;
  VBC.BeginName = BeginName;
  VBC.EndName = EndName;
  VerbatimBlockCommands.push_back(VBC);
}

void CommandTraits::addVerbatimLineCommand(StringRef Name) {
  VerbatimLineCommand VLC;
  VLC.Name = Name;
  VerbatimLineCommands.push_back(VLC);
}

} // end namespace comments
} // end namespace clang

