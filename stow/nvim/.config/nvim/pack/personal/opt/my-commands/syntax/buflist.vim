if exists("b:current_syntax")
  finish
endif

syn match buflist_file /\d\+\s\+\zs\S\+$/
highlight link buflist_file Constant

syn match buflist_arg /\d\s!#\?+\?\S*\s\+\zs\S\+$/
highlight link buflist_arg Type

syn match buflist_current_file /\d\s!\?#+\?\S*\s\+\zs\S\+$/
highlight link buflist_current_file Statement

syn match buflist_modified_file /\d\s!\?#\?+\S*\s\+\zs\S\+$/
highlight link buflist_modified_file Todo


let b:current_syntax = 'buflist'
