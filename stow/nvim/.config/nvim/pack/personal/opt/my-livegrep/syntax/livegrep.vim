if exists("b:current_syntax") || 1
  finish
endif

syn match livegrep_separator /^---$/
highlight link livegrep_separator Comment

let b:current_syntax = 'livegrep'
