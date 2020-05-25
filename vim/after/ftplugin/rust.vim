let g:cargo_makeprg_params='check --all-targets'

compiler cargo

if executable('rustfmt')
    nnoremap <F6> :!rustfmt %<cr>
endif

if exists(':DD')
    setlocal keywordprg=:DD
endif
