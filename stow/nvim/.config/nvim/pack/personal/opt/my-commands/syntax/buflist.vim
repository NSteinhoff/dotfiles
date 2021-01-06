if exists("b:current_syntax")
  finish
endif

syn match buflist_file /^.*$/
highlight link buflist_file Constant

let b:current_syntax = 'buflist'
