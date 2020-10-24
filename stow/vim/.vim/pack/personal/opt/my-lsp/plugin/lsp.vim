function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    imap <silent> <buffer> <C-SPACE> <C-X><C-O>
    nmap <silent> <buffer> K <plug>(lsp-hover)
    nmap <silent> <buffer> gh <plug>(lsp-hover)
    nmap <silent> <buffer> gd <plug>(lsp-definition)
    nmap <silent> <buffer> gD <plug>(lsp-type-definition)
    nmap <silent> <buffer> gr <plug>(lsp-references)
    nmap <silent> <buffer> gi <plug>(lsp-implementation)
    nmap <silent> <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <silent> <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <silent> <buffer> <leader>rn <plug>(lsp-rename)
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_echo_delay = 200
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_float_delay = 2000
