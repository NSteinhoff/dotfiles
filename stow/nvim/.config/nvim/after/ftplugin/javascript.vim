setlocal keywordprg=:Search\ devdocs\ javascript

" Execution
let b:interpreter = 'node --input-type=module -'
let b:repl = 'node'

" './some-file'
" '../some-file'
" '.../some-file'
let &l:include='\(^import\s\|^}\).*\sfrom\s\''\zs\.\+\/\(\w\|[/.-]\)\+\ze'
" ./some-file -> some-file
" ../some-file -> ../some-file
" .../some-file -> ../../some-file
let &l:includeexpr="substitute(substitute(v:fname, '\\./', '', ''), '\\.', '../', 'g')"
let &l:define='^\s*\(export\s\)\?\(async\s\)\?\(function\|class\|const\|let\|var\)\s\ze'

set omnifunc&
