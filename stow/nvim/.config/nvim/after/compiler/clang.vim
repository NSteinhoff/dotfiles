" Vim compiler file
" Compiler:         Clang Compiler
" Maintainer:       Niko Steinhoff <niko.steinhoff@pm.me>
" Latest Revision   Fri Apr 15 2022 09:33:56 AM

if exists('current_compiler') && current_compiler != 'clang'
    finish
endif

" Base this compiler on the 'GCC' compiler settings
runtime compiler/gcc.vim
let current_compiler = "clang"

CompilerSet makeprg=clang
            \\ -std=c17
            \\ -pedantic
            \\ -Wall
            \\ -Wextra
            \\ -Wconversion
            \\ -Wmissing-prototypes
            \\ -fsyntax-only
            \\ %
            \\ $*
