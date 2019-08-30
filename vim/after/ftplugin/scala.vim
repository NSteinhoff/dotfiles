let &l:define = '^\s*\(abstract \|implicit \|protected \|sealed \|final \)*\(trait\|class\|case class\|object\|case object\|def\)'
let &l:path = ','
let &l:path .= ',' . join(finddir('src/main/scala', '**', -1), ',')
let &l:path .= ',' . join(finddir('src/test/scala', '**', -1), ',')
