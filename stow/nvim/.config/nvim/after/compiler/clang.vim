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
            \\ -Werror
            \\ -Wall
            \\ -Wextra
            \\ -Weverything
            \\ -pedantic
            \\ -Wno-declaration-after-statement
            \\ -Wno-strict-prototypes
            \\ -Wno-shadow
            \\ -Wno-padded
            \\ -Wno-implicit-fallthrough
            \\ -Wno-vla
            \\ -Wno-cast-qual
            \\ -Wno-unsafe-buffer-usage
            \\ -fsyntax-only
            \\ %
            \\ $*
