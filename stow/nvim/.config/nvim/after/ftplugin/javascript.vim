setlocal keywordprg=:Search\ devdocs\ javascript

" Execution
let b:interpreter = 'node --input-type=module -'
let b:repl = 'node'

let &l:include='\(^import\s\|^}\).*\sfrom\s\''\zs\.\/\(\w\|[/.-]\)\+\ze'
let &l:define='^\s*\(export\s\)\?\(function\|class\)\s\ze'

set omnifunc&

let b:yang = ftutils#javascript#get_alt(expand('%'))
