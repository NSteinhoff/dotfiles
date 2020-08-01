let b:repl = 'racket'
let b:interpreter = 'racket'
setlocal sw=2

set keywordprg=:ReplSend\ ,doc
nnoremap <buffer> <BS> :w <bar> ReplSend ,enter %<CR>
