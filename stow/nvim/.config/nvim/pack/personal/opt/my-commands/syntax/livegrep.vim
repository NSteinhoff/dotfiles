if exists("b:current_syntax")
  finish
endif

syn match livegrep_query /^.*$/
highlight link livegrep_query String

syn match livegrep_separator /^---$/
highlight link livegrep_separator Comment

syn match livegrep_fpath /^[^:]\+:\(\d\+:\)\{1,2}.*$/ contains=livegrep_loc,livegrep_text
highlight link livegrep_fpath Constant

syn match livegrep_loc /:\(\d\+:\)\{1,2}/ contained
highlight link livegrep_loc Comment

syn match livegrep_text /\(^[^:]\+:\(\d\+:\)\{1,2}\)\@<=.*$/ contained contains=livegrep_match
highlight link livegrep_text Normal

highlight link livegrep_match Error

let b:current_syntax = 'livegrep'
