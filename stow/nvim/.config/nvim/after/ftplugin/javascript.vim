source <sfile>:h/keywordprg/mdn.vim

" Execution
let b:interpreter = 'node -'
let b:repl = 'node'

let &l:include='\(^import\s\|^}\).*\sfrom\s\''\zs\.\/\(\w\|[/.-]\)\+\ze'
let &l:define='^\s*\(export\s\)\?\(function\|class\)\s\ze'

set omnifunc&

let b:alt = ftutils#javascript#get_alt(expand('%'))
command -buffer A execute 'edit '..b:alt
