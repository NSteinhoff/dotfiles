if exists("b:current_syntax")
  finish
endif

syn match filefinder_query /^.*$/
highlight link filefinder_query String

syn match filefinder_separator /^---$/
highlight link filefinder_separator Comment

syn match filefinder_file /^\s*\d\+:.*$/ contains=filefinder_key,filefinder_num,filefinder_match
highlight link filefinder_file Constant

syn match filefinder_key /^\s*\d:/ contained
highlight link filefinder_key Operator

syn match filefinder_num /^\s*\d\{2,}:/ contained
highlight link filefinder_num Normal

highlight link filefinder_match Error

let b:current_syntax = 'filefinder'
