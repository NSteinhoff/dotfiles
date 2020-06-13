let g:cargo_makeprg_params='check --all-targets'

compiler cargo

if executable('rustfmt')
    setlocal formatexpr=
    setlocal formatprg=rustfmt\ --emit=stdout
endif

if exists(':DD')
    setlocal keywordprg=:DD
endif
