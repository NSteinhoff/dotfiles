" Vim Compiler File
" Compiler:     mypy
" Maintainer:   Niko Steinhoff <niko.steinhoff@gmail.com>
" Last Change:  Mon 25 May 2020 08:36:45 AM

let current_compiler = "mypy"

let s:cmd = 'mypy --no-error-summary $* %'
" When we find a Pipfile we run mypy through pipenv.
if !empty(findfile('Pipfile', getcwd()))
    let s:cmd = 'pipenv run '.s:cmd
endif
exec 'CompilerSet makeprg=' . escape(s:cmd, ' ')
CompilerSet errorformat=%f:%l:\ %m
