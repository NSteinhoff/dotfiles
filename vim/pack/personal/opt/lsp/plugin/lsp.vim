command! LspShowClients lua print(vim.inspect(vim.lsp.buf_get_clients()))

lua << EOF
vim.cmd('packadd nvim-lsp')
require'nvim_lsp'.metals.setup{}
require'nvim_lsp'.rls.setup{}
EOF

setlocal signcolumn=yes
setlocal omnifunc=v:lua.vim.lsp.omnifunc

function s:set_lsp_mappings()
    nnoremap <buffer> <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <buffer> <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <buffer> <silent> [<c-d> <cmd>lua vim.lsp.buf.definition()<CR>
    " nnoremap <buffer> <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <buffer> <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <buffer> <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <buffer> <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <buffer> <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
endfunction

augroup LSP
    autocmd!
    autocmd Filetype scala,rust call s:set_lsp_mappings()
augroup END
