let g:cargo_makeprg_params='check --all-targets'

compiler cargo

nnoremap <buffer> <F6> :!rustfmt %<cr>
nnoremap <buffer> <F9> :!cargo test<cr>
