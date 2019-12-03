" Vim compiler file
" Language:             Scala Bloop (https://scalacenter.github.io/bloop/)
" Maintainer:           Niko Steinhoff
" URL:                  https://github.com/nsteinhoff/dotfiles
" License:              MIT
" ----------------------------------------------------------------------------

if exists('current_compiler')
  finish
endif
let current_compiler = 'bloop'

if exists(':CompilerSet') != 2          " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=bloop\ compile\ --no-color\ --reporter=scalac\ --cascade\ root

CompilerSet errorformat=
    \%E[E]\ %f:%l:%c:\ %m,%Z%.%#p^,%-G%.%#,
    \%W[W]\ %f:%l:%c:\ %m,%Z%.%#p^,%-G%.%#

let &cpo = s:cpo_save
unlet s:cpo_save
