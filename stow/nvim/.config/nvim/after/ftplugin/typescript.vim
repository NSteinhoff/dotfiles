setlocal keywordprg=:Mdn

" Execution
let b:interpreter = 'ts-node'
let b:repl = 'ts-node'

" './some-file'
" '../some-file'
" '.../some-file'
let &l:include='\(^\(import\|export\)\s\|^}\).*\sfrom\s\''\zs\.\+\/\(\w\|[/.-]\)\+\ze'
" ./some-file -> some-file
" ../some-file -> ../some-file
" .../some-file -> ../../some-file
let &l:includeexpr="substitute(substitute(substitute(v:fname, '\\.\\(m\\?js\\|ts\\)$' , '', ''), '\\./', '', ''), '\\.', '../', 'g')"
let &l:define='^\s*\(export\s\)\?\(async\s\)\?\(function\|class\|interface\|type\|const\|let\|var\)\s\ze'

execute 'compiler '..get(g:, &ft..'_compiler', 'tsc')

iabbrev <buffer> exif export interface {}
" command -buffer Run !ts-node %

" Don't include files in node_modules in the buffer list
if fnamemodify(bufname(), ':p') =~ '.*/node_modules/.*'
    setlocal nobuflisted noswapfile
endif

nnoremap <buffer> gO <cmd>TagToc ! C p v<cr>
