" Vim Compiler File
" Compiler:     dockerfile
" Maintainer:   Niko Steinhoff <niko.steinhoff@gmail.com>
" Last Change:  Mon 25 May 2020 08:09:58 AM

let current_compiler = "dockerfile"

CompilerSet makeprg=hadolint\ %
CompilerSet errorformat=%f:%l\ %t%.%n\ %m
