set tabstop=8
set shiftwidth=0
set softtabstop=-1

if executable('clang-format')
    setlocal formatexpr=
    let &formatprg = 'clang-format --assume-filename=file.c --style="{BasedOnStyle: llvm, IndentWidth: '..(&shiftwidth ? &shiftwidth : &tabstop)..'}"'
endif
