setlocal keywordprg=:Mdn

" Execution
let b:interpreter = 'node -'
let b:repl = 'node'

" './some-file'
" '../some-file'
" '.../some-file'
let &l:include='\(^\(import\|export\)\s\|^}\).*\sfrom\s\''\zs\.\+\/\(\w\|[/.-]\)\+\ze'
" ./some-file -> some-file
" ../some-file -> ../some-file
" .../some-file -> ../../some-file
let &l:includeexpr="substitute(substitute(v:fname, '\\./', '', ''), '\\.', '../', 'g')"
let &l:define='^\s*\(export\s\)\?\(async\s\)\?\(function\|class\|const\|let\|var\)\s\ze'

execute 'compiler '..get(g:, &ft..'_compiler', 'tsc-js')

set omnifunc&
