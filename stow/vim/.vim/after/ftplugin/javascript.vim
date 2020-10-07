" Execution
let b:interpreter = 'node -'
let b:repl = 'node'

if exists(':DD')
    setlocal keywordprg=:DD
endif
