if exists("b:current_syntax")
  finish
endif

setl conceallevel=2 concealcursor=nv

syn match buflist_file /\d\+\s\+\zs\S\+$/
highlight link buflist_file Normal

syn match buflist_arg /\d\s!#\?+\?\S*\s\+\zs\S\+$/
highlight link buflist_arg Normal

syn match buflist_current_file /\d\s!\?#+\?\S*\s\+\zs\S\+$/
highlight link buflist_current_file Statement

syn match buflist_modified_file /\d\s!\?#\?+\S*\s\+\zs\S\+$/
highlight link buflist_modified_file Todo

execute 'syn match buflist_cwd =^\(\d\|\s\|#\|+\|!\)\+\zs'..getcwd()..'\ze.*$= conceal cchar=.'

let b:current_syntax = 'buflist'
