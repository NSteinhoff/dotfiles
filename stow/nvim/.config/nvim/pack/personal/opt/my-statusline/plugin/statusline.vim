let &stl  = '%w%y'
" let &stl .= '%#Normal#'
let &stl .= ' %<%f%m%a'
let &stl .= '%{status#yang()}'
" let &stl .= '%#Special#'
let &stl .= '%{status#tree()}'
let &stl .= '%='
" let &stl .=  '%#Normal#'
let &stl .= '%{status#err()}'
let &stl .= '%{status#spell()}'
let &stl .= '%{status#comp()}'
let &stl .= '%*'
let &stl .= '%{status#stealth()}'
let &stl .= '%{status#term()}'
let &stl .= ' '
let &stl .= '☰ %l:%c | %p%%'

set laststatus=2
