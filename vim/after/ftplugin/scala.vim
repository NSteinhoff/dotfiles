" Configure vim-scala to use the preferred scala-doc indenation
" style for docstrings.
let g:scala_scaladoc_indent = 1

let &l:define = '^\s*\(abstract \|implicit \|protected \|sealed \|final \)*\(trait\|class\|case class\|object\|case object\|def\)'
let &l:path = ','

let s:src_dir = finddir('src', expand('%').';')
let &l:path .= ',' . s:src_dir . '/main/scala'
let &l:path .= ',' . s:src_dir . '/test/scala'
