if exists("b:current_syntax")
  finish
endif

syn match filefinder_query /^.*$/
highlight link filefinder_query String

syn match filefinder_separator /^---$/
highlight link filefinder_separator Comment

syn match filefinder_file /^\d\+:.*$/ contains=filefinder_key,filefinder_num
highlight link filefinder_file Constant

syn match filefinder_key /^\d:/ contained
highlight link filefinder_key Operator

syn match filefinder_num /^\d\{2,}:/ contained
highlight link filefinder_num Normal

let b:current_syntax = 'filefinder'
