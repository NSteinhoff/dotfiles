let &l:define = '^\s*\(abstract \|implicit \|protected \|sealed \|final \)*\(trait\|class\|case class\|object\|case object\|def\)'
setlocal path-=src/main/scala,src/test/scala
let &l:path = &path . ',' . join(finddir('src/main/scala', '**', -1), ',')
let &l:path = &path . ',' . join(finddir('src/test/scala', '**', -1), ',')
