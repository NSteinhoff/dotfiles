" Vim compiler file
" Compiler:         Java
" Maintainer:       Niko Steinhoff <niko.steinhoff@gmail.com>
" Latest Revision:  Thu Sep  9 2021 10:19:00 AM

if exists('current_compiler')
    finish
endif

CompilerSet errorformat=%E%f:%l:\ error:\ %m,
               \%W%f:%l:\ warning:\ %m,
               \%-Z%p^,
               \%-C%.%#,
               \%-G%.%#

let current_compiler = "java"
set makeprg=make
