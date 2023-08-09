setlocal noexpandtab
setlocal tabstop=8
setlocal shiftwidth=0

let indend_width = &shiftwidth ? &shiftwidth : &tabstop
let use_tab = &expandtab ? 'Never' : 'AlignWithSpaces'

" There is also a .clang-format with the same settings, but this allows
" changing the indentation settings on the fly.
let s:style = '"{'
let s:style.= 'BasedOnStyle: llvm'
let s:style.= ', UseTab: '..use_tab
let s:style.= ', TabWidth: '..&tabstop
let s:style.= ', IndentWidth: '..indend_width
let s:style.= ', ContinuationIndentWidth: '..indend_width
let s:style.= ', AlwaysBreakBeforeMultilineStrings: true'
let s:style.= ', BreakBeforeTernaryOperators: true'
let s:style.= ', IndentGotoLabels: true'
let s:style.= ', ReflowComments: false'
let s:style.= ', BreakStringLiterals: false'
let s:style.= ', AlignArrayOfStructures: Left'
" let s:style.= ', AlignAfterOpenBracket: AlwaysBreak'
let s:style.= ', AlignOperands: AlignAfterOperator'
let s:style.= ', AllowShortBlocksOnASingleLine: Never'
let s:style.= ', AllowShortFunctionsOnASingleLine: false'
let s:style.= ', AllowShortCaseLabelsOnASingleLine: true'
let s:style.= ', AllowShortIfStatementsOnASingleLine: Never'
let s:style.= ', AllowShortLoopsOnASingleLine: true'
let s:style.= ', AllowShortEnumsOnASingleLine: true'
let s:style.= '}"'

if executable('clang-format')
    let b:formatprg = 'clang-format --assume-filename=file.c --style='..s:style
endif
if executable('clang-tidy')
    let b:fixprg = 'clang-tidy --fix --format-style='..s:style..' '..expand('%')
endif
