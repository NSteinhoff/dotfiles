let g:cargo_makeprg_params='check --all-targets'

compiler cargo

if executable('rustfmt')
    setlocal formatprg=rustfmt\ --emit=stdout
    let b:format_on_write = 1
endif

if exists(':DD')
    setlocal keywordprg=:DD
endif
