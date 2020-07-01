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

let s:projects = systemlist('bloop projects')

let s:has_root = 0
for p in s:projects
    if p == 'root'
        let s:has_root = 1
        break
    endif
endfor

if s:has_root
    let s:options = 'root'
else
    call map(s:projects, '"-p " . v:val')
    let s:options = join(s:projects)
endif

let s:command = 'bloop compile --no-color --reporter=scalac --cascade ' . s:options
exec 'CompilerSet makeprg=' . escape(s:command, ' ')

CompilerSet errorformat=
    \%E[E]\ %f:%l:%c:\ %m,%Z%.%#p^,%-G%.%#,
    \%W[W]\ %f:%l:%c:\ %m,%Z%.%#p^,%-G%.%#

let &cpo = s:cpo_save
unlet s:cpo_save
