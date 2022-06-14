setlocal keywordprg=:Search\ devdocs\ java

let &l:include='^import\s*\zs\(\w\|[.]\)\+\ze;'
let &l:define='^\s*\(public\)\?class\s*\ze\i\+\s{'
if &path !~ 'src/'
    let &l:path= 'src/' . ',' . &l:path
endif

compiler java
