setlocal noexpandtab
setlocal tabstop=8
setlocal shiftwidth=8

let s:style = '"{BasedOnStyle: llvm, UseTab: ForContinuationAndIndentation, IndentWidth: '..(&shiftwidth ? &shiftwidth : &tabstop)..', ContinuationIndentWidth: '..(&shiftwidth ? &shiftwidth : &tabstop)..'}"'

if executable('clang-format')
    let b:formatprg = 'clang-format --assume-filename=file.c --style='..s:style
endif
if executable('clang-tidy')
    let b:fixprg = 'clang-tidy --fix --format-style='..s:style..' '..expand('%')
endif
