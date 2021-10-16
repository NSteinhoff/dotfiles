source <sfile>:h/keywordprg/mdn.vim

" Execution
let b:interpreter = 'ts-node'
let b:repl = 'ts-node'

" './some-file'
" '../some-file'
" '.../some-file'
let &l:include='\(^import\s\|^}\).*\sfrom\s\''\zs\.\+\/\(\w\|[/.-]\)\+\ze'
" ./some-file -> some-file
" ../some-file -> ../some-file
" .../some-file -> ../../some-file
let &l:includeexpr="substitute(substitute(v:fname, '\\./', '', ''), '\\.', '../', 'g')"

let &l:define='^\s*\(export\s\)\?\(async\s\)\?\(function\|class\|interface\|type\|const\|let\|var\)\s\ze'

execute 'compiler '..get(g:, &ft..'_compiler', 'tsc')

iabbrev <buffer> exif export interface {}
command -buffer Run !ts-node %

if fnamemodify(bufname(), ':p') =~ '.*/node_modules/.*'|
    setlocal nobuflisted noswapfile
endif
