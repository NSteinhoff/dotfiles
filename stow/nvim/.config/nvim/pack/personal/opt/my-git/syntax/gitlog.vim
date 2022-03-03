if exists("b:current_syntax")
  finish
endif

syn match gitlog_revision /^[a-z0-9]\+\s/
highlight link gitlog_revision string

syn match gitlog_help /^Usage:\s.*$/
highlight link gitlog_help comment

let b:current_syntax = 'gitlog'
