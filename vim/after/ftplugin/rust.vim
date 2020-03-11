let g:cargo_makeprg_params='check'

compiler cargo

nnoremap <buffer> <F6> :!rustfmt %<cr>
