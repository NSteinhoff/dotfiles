" Vim Compiler File
" Compiler:     cargo-test
" Maintainer:   Niko Steinhoff <niko.steinhoff@gmail.com>
" Last Change:  Sat 16 May 2020 10:53:53 AM

" Standard boilerplate {{{
if exists("current_compiler")
  finish
endif
let current_compiler = "cargo-test"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif
"}}}


CompilerSet makeprg=cargo\ test

CompilerSet errorformat=
    \test\ %f\ -\ %m\ (line\ %l)\ ...\ FAILED,
    \%-G%.%#,

" vim: foldmethod=marker
