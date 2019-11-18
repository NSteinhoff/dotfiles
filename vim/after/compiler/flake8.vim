" Vim Compiler File
" Compiler:     flake8
" Maintainer:   Niko Steinhoff <niko.steinhoff@gmail.com>
" Last Change:  Thu 17 Oct 2019 09:31:16 CEST

" Standard Boilerplate {{{
if exists("current_compiler")
  finish
endif

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif
let current_compiler = "flake8"
"}}}

" Search the working directory for a pipfile.
"
" We want to run mypy from within the project environment
" when we're in a project that used pipenv to manage its
" virtualenv.
"
" When we find a Pipfile we run mypy through pipenv.
let s:pipfile = findfile('Pipfile', getcwd())
if !empty(s:pipfile)
    let s:pipenv = 'pipenv run '
else
    let s:pipenv = ''
endif

let s:command = s:pipenv.'flake8 $*'

exec 'CompilerSet makeprg=' . escape(s:command, ' ')

CompilerSet errorformat=%f:%l:%c:\ %t%n\ %m

" vim: foldmethod=marker
