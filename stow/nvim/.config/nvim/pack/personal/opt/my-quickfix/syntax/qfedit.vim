if exists("b:current_syntax")
  finish
endif

syn match qfedit_fpath /^[^:]\+:\(\d\+:\)\{1,2}.*$/ contains=qfedit_loc,qfedit_text
highlight link qfedit_fpath Constant

syn match qfedit_loc /:\(\d\+:\)\{1,2}/ contained
highlight link qfedit_loc Comment

syn match qfedit_text /\(^[^:]\+:\(\d\+:\)\{1,2}\)\@<=.*$/ contained
highlight link qfedit_text Normal

let b:current_syntax = 'qfedit'
