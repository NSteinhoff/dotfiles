if exists("b:current_syntax")
  finish
endif

let b:current_syntax = 'livegrep'

syn match livegrep_separator /^---$/
highlight link livegrep_separator comment

syn match livegrep_fpath /^\zs[^:]*\ze:\d\+:\d\+:/
highlight link livegrep_fpath Constant
