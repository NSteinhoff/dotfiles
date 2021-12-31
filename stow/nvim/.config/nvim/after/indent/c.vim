let s:style = '"{BasedOnStyle: llvm, IndentWidth: '..(&shiftwidth ? &shiftwidth : &tabstop)..'}"'

if executable('clang-format')
    let b:formatprg = 'clang-format --assume-filename=file.c --style='..s:style
endif
if executable('clang-tidy')
    let b:fixprg = 'clang-tidy --fix --format-style='..s:style..' '..expand('%')
endif
