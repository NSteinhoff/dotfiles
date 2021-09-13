let &l:include='^import\s*\zs\(\w\|[.]\)\+\ze;'
let &l:define='^\s*\(public\)\?class\s*\ze\i\+\s{'
let &l:path= 'src/' . ',' . &l:path

compiler java
