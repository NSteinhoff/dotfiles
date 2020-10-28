" -- require and make globally available as 'my_lsp'
lua my_lsp = require('lsp')

function s:set_lsp_mappings()
    setlocal signcolumn=yes
    setlocal omnifunc=v:lua.vim.lsp.omnifunc

    nnoremap <buffer> <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <buffer> <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <buffer> <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <buffer> <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <buffer> <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <buffer> <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <buffer> <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
endfunction

augroup LSP
    autocmd!
    autocmd Filetype scala,rust,typescript* call s:set_lsp_mappings()
augroup END

command! LspShowClients lua my_lsp.print_clients()
