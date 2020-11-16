let &l:include='\(^import\s\|^}\).*\sfrom\s\''\.\+\/\zs\(\w\|[/.-]\)\+\ze'
let &l:define='^\s*\(export\s\)\?\(async\s\)\?\(function\|class\|interface\|type\|const\|let\|var\)\s\ze'
compiler tsc

if exists(':DD')
    setlocal keywordprg=:DD
endif
