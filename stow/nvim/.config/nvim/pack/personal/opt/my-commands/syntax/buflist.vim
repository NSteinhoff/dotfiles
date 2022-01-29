if exists("b:current_syntax")
  finish
endif

setl conceallevel=2 concealcursor=nv

syn match buflist_banner ="\s.*$=
highlight link buflist_banner Comment

execute 'syn match buflist_cwd =^\(\d\|\s\|#\|+\|!\)\+\zs'..getcwd()..'\ze.*$= conceal cchar=.'

let b:current_syntax = 'buflist'
