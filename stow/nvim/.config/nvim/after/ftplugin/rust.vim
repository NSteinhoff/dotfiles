let g:cargo_makeprg_params='check --all-targets'

compiler cargo

setlocal formatoptions-=o

if executable('rustfmt')
    setlocal formatexpr=
    setlocal formatprg=rustfmt\ --emit=stdout
endif

if exists(':DD')
    setlocal keywordprg=:DD
endif

let b:format_on_write = 1
let b:make_on_write = 1
