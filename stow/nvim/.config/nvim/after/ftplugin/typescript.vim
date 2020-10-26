let &l:include='\(^import\s\|^}\).*\sfrom\s\''\.\/\zs\(\w\|[/.-]\)\+\ze'
let &l:define='^\s*\(export\s\)\?\(function\|class\|interface\|type\)\s\ze'
compiler typescript

if exists(':DD')
    setlocal keywordprg=:DD
endif
