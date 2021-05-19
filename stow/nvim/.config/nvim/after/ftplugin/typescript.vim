" './some-file'
" '../some-file'
" '.../some-file'
let &l:include='\(^import\s\|^}\).*\sfrom\s\''\zs\.\+\/\(\w\|[/.-]\)\+\ze'
" ./some-file -> some-file
" ../some-file -> ../some-file
" .../some-file -> ../../some-file
let &l:includeexpr="substitute(substitute(v:fname, '\\./', '', ''), '\\.', '../', 'g')"

let &l:define='^\s*\(export\s\)\?\(async\s\)\?\(function\|class\|interface\|type\|const\|let\|var\)\s\ze'

" if expand('%:t') =~ 'test.ts$'
"     compiler jest
" else
"     compiler tsc
" endif
compiler tsc

if exists(':DD')
    setlocal keywordprg=:DD
endif

let b:format_on_write = 0
let b:make_on_write = 0

iabbrev <buffer> exif export interface {}
