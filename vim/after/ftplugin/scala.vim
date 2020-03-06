let &l:define = '^\s*\(abstract \|implicit \|protected \|sealed \|final \)*\(trait\|class\|case class\|object\|case object\|def\)'
setlocal path-=src/main/scala,src/test/scala

setlocal signcolumn=yes
setlocal omnifunc=v:lua.vim.lsp.omnifunc

nnoremap <buffer> <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <buffer> <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <buffer> <silent> [<c-d> <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <buffer> <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <buffer> <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <buffer> <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <buffer> <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <buffer> <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>

command! MetalsLog execute '!tail -f ' . finddir('.metals', '.;') . '/metals.log'
