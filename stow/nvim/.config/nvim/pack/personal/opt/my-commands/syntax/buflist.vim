if exists("b:current_syntax")
  finish
endif

syn match buflist_file /\d\+\s\+\S\+$/
highlight link buflist_file Constant

syn match buflist_current_file /\d\s#\S*\s\+\S\+$/
highlight link buflist_current_file Special

let b:current_syntax = 'buflist'
