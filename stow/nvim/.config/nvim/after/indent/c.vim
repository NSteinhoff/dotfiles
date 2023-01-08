setlocal noexpandtab
setlocal tabstop=8
setlocal shiftwidth=8

" There is also a .clang-format with the same settings, but this allows
" changing the indentation settings on the fly.
let s:style = '"{'
let s:style.= 'BasedOnStyle: llvm'
let s:style.= ', UseTab: '..(&expandtab ? 'Never' : 'ForContinuationAndIndentation')
let s:style.= ', IndentWidth: '..(&shiftwidth ? &shiftwidth : &tabstop)
let s:style.= ', ContinuationIndentWidth: '..(&shiftwidth ? &shiftwidth : &tabstop)
let s:style.= ', AllowShortIfStatementsOnASingleLine: WithoutElse'
let s:style.= ', AllowShortCaseLabelsOnASingleLine: true'
let s:style.= ', AllowShortLoopsOnASingleLine: true'
let s:style.= ', AllowShortBlocksOnASingleLine: Never'
let s:style.= ', AlignOperands: AlignAfterOperator'
let s:style.= '}"'

if executable('clang-format')
    let b:formatprg = 'clang-format --assume-filename=file.c --style='..s:style
endif
if executable('clang-tidy')
    let b:fixprg = 'clang-tidy --fix --format-style='..s:style..' '..expand('%')
endif
