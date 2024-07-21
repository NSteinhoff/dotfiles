" Vim compiler file
" Compiler:         Clang Compiler
" Maintainer:       Niko Steinhoff <niko.steinhoff@pm.me>
" Latest Revision   Fri Apr 15 2022 09:33:56 AM

if exists('current_compiler') && current_compiler != 'clang'
    finish
endif

" Base this compiler on the 'GCC' compiler settings
runtime compiler/gcc.vim

let s:cmd  = 'clang'
let s:cmd .= ' -std=c17 -pedantic'
let s:cmd .= ' -Wall -Wextra'
let s:cmd .= ' -Wconversion'
let s:cmd .= ' -Wmissing-prototypes'
let s:cmd .= ' -Wsign-conversion'
let s:cmd .= ' -Wconversion'
let s:cmd .= ' -fsyntax-only'
let s:cmd .= ' '..get(b:, 'cflagsadd', '')
let s:cmd .= ' % $*'

let current_compiler = "clang"
execute 'CompilerSet makeprg='..escape(s:cmd, ' ')
