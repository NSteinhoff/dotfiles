if executable('black')
    setlocal formatexpr=
    setlocal formatprg=black\ -\ 2>/dev/null
endif
