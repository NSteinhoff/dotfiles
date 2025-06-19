let l:buf = expand('%')
if empty(l:buf)|finish|endif

let l:path = (isdirectory(l:buf) ? l:buf..';$HOME,' : '')..'.;$HOME,;$HOME,'
let l:is_package = !empty(findfile('package.json', l:path))
let l:is_pnpm = !empty(findfile('pnpm-lock.yaml', l:path))
let l:rcfile = findfile('.eslintrc.js', l:path)

let l:cmd = ''
if l:is_package && l:is_pnpm && executable('pnpm')
    let l:cmd  .= 'pnpm --silent dlx '
elseif l:is_package && executable('npx')
    let l:cmd  .= 'npx '
endif

let l:cmd  = (l:is_package && executable('npx') ? 'npx ' : '')
let l:cmd .= 'eslint'
let l:cmd .= !empty(l:rcfile) ? ' --config '.l:rcfile : ' --no-eslintrc'
let l:cmd .= ' --fix '
let l:cmd .= l:buf

let b:fixprg = l:cmd
