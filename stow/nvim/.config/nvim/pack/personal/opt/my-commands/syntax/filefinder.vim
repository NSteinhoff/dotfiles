if exists("b:current_syntax")
  finish
endif

syn match filefinder_separator /^---$/
highlight link filefinder_separator Comment

let b:current_syntax = 'filefinder'
