if executable('rustfmt')
    let b:formatprg='rustfmt --emit=stdout --edition=2024'
endif
