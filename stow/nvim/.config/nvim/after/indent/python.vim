if executable('black')
    let b:formatprg='black -l 80 - 2>/dev/null'
endif
