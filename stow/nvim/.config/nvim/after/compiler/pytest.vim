" Vim Compiler File
" Compiler:     pytest
" Maintainer:   Niko Steinhoff <niko.steinhoff@gmail.com>
" Last Change:  Mon 25 May 2020 08:41:47 AM

let current_compiler = "pytest"

let s:cmd = 'pytest --tb=short -q $*'
" When we find a Pipfile we run mypy through pipenv.
if !empty(findfile('Pipfile', getcwd()))
    let s:cmd = 'pipenv run '.s:cmd
endif
exec 'CompilerSet makeprg=' . escape(s:cmd, ' ')
CompilerSet errorformat=
    \%-G%.%#FF%.%#,
    \%-G=%#\ FAILURES\ =%#,
    \%A_%#\ %m\ _%#,
    \%C%f:%l:%.%#,
    \%C>\ %#self%.%m,
    \%C>\ %#%m,
    \%ZE\ %#%m,
    \%-G%.%#seconds%.%#,
    \%-G%.%#
