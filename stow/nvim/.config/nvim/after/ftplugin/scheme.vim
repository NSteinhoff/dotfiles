let b:repl = 'racket'
let b:interpreter = 'racket'
setlocal sw=2

set keywordprg=:ReplSend\ ,doc
nnoremap <buffer> <bs> :w <bar> ReplSend ,enter %<cr>

if exists(':DD')
    setlocal keywordprg=:DD
endif
