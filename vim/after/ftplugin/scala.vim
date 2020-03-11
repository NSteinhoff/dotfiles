let &l:define = '^\s*\(abstract \|implicit \|protected \|sealed \|final \)*\(trait\|class\|case class\|object\|case object\|def\)'

setlocal path-=src/main/scala,src/test/scala

compiler bloop

command! LspLog execute '!tail -f ' . finddir('.metals', '.;') . '/metals.log'

nnoremap <buffer> <F6> :!scalafmt %<cr>
