let buf = expand('%')

if executable('npx') && !empty(buf)
    let path = (isdirectory(buf) ? buf..';$HOME,' : '')..'.;$HOME,;$HOME,'
    " let cmd = executable('eslint_d') ? 'eslint_d' : 'npx\ eslint'
    let cmd = 'npx\ eslint'
    let rcfile = findfile('.eslintrc.js', path)
    let eslint = cmd..(!empty(rcfile) ? ' --config '.rcfile : '')..' --fix '..buf
    let b:fixprg = eslint
endif
