if exists("b:current_syntax")
  finish
endif

let b:current_syntax = 'livegrep'

syn match livegrep_query /^.*$/
highlight link livegrep_query error

syn match livegrep_separator /^---$/
highlight link livegrep_separator comment

syn match livegrep_fpath /^[^:]\+:\(\d\+:\)\{1,2}.*$/ contains=livegrep_loc,livegrep_text
highlight link livegrep_fpath Constant

syn match livegrep_loc /:\(\d\+:\)\{1,2}/ contained
highlight link livegrep_loc comment

syn match livegrep_text /\(^[^:]\+:\(\d\+:\)\{1,2}\)\@<=.*$/ contained
highlight link livegrep_text normal
