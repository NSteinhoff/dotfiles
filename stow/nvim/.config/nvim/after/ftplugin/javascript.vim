" Execution
let b:interpreter = 'node -'
let b:repl = 'node'

let &l:include='\(^import\s\|^}\).*\sfrom\s\''\zs\.\/\(\w\|[/.-]\)\+\ze'
let &l:define='^\s*\(export\s\)\?\(function\|class\)\s\ze'

if exists(':DD')
    setlocal keywordprg=:DD
endif

let b:format_on_write = 0
