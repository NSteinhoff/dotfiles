set tabstop=4
set shiftwidth=0
set softtabstop=-1

if executable('clang-format')
    let b:formatprg = 'clang-format --assume-filename=file.c --style="{BasedOnStyle: llvm, IndentWidth: '..(&shiftwidth ? &shiftwidth : &tabstop)..'}"'
endif
