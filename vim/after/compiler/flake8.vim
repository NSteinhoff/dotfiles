" Vim Compiler File
" Compiler:     flake8
" Maintainer:   Niko Steinhoff <niko.steinhoff@gmail.com>
" Last Change:  Mon 25 May 2020 08:09:58 AM

let current_compiler = "flake8"

CompilerSet makeprg=flake8\ $*\ %
CompilerSet errorformat=
            \%f:%l:%c:\ %t%n\ %m,
            \%f:%l:%c:\ %t%.%n\ %m,
            \%f:%l:%c:\ %t%.%.%n\ %m,
