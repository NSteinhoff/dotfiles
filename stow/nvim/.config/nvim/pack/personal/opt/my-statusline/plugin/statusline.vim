let stl  = '%w%y'
let stl .= ' %<%f%m%a'
let stl .= '%{status#yang()}'
" let stl .= '%{status#tree()}'
let stl .= '%='
let stl .= '%{status#dap()}'
let stl .= '%{status#stealth()}'
let stl .= '%='
let stl .= '%{status#err()}'
let stl .= '%{status#spell()}'
let stl .= '%{status#diff()}'
let stl .= '%{status#comp()}'
let stl .= '%*'
let stl .= '%{status#term()}'
let stl .= ' '
let stl .= '%l:%c | %p%%'
let &stl = stl

let &ruf = '%50(%=%<%m %t %l:%c %P %y%)'
