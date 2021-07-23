let b:repl = 'racket'
let b:interpreter = 'racket'
setlocal sw=2

if exists(':DD')
    setlocal keywordprg=:DD
endif
