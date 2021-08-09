setlocal keywordprg=:DevDocsFt

let &l:define = '^\s*\(abstract \|implicit \|protected \|sealed \|final \)*\(trait\|class\|case class\|object\|case object\|def\)'

setlocal path-=src/main/scala,src/test/scala

compiler bloop

command! Scalafmt !scalafmt %
command! MetalsLog execute '!tail -f ' . finddir('.metals', '.;') . '/metals.log'
