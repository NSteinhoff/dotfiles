setlocal noexpandtab
setlocal shiftwidth=8

if executable('gofmt')
    let b:formatprg = 'gofmt'
endif
