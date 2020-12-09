if exists("b:current_syntax")
  finish
endif

syn match gitlog_revision /^\S\+/
highlight link gitlog_revision string

let b:current_syntax = 'gitlog'
