if executable('rustfmt')
    let b:formatprg='rustfmt --emit=stdout'
endif
