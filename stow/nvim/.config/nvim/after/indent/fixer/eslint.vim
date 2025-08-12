let s:buf = expand('%')
if empty(s:buf)|finish|endif

let s:path = (isdirectory(s:buf) ? s:buf..';$HOME,' : '')..'.;$HOME,;$HOME,'
let s:is_package = !empty(findfile('package.json', s:path))
let s:is_pnpm = !empty(findfile('pnpm-lock.yaml', s:path))
let s:rcfile = findfile('.eslintrc.js', s:path)

let s:cmd = ''
if s:is_package && s:is_pnpm && executable('pnpm')
    let s:cmd  .= 'pnpm --silent dlx '
elseif s:is_package && executable('npx')
    let s:cmd  .= 'NPM_CONFIG_LOGLEVEL=silent npx '
endif

let s:cmd  = (s:is_package && executable('npx') ? 'npx ' : '')
let s:cmd .= 'eslint'
let s:cmd .= !empty(s:rcfile) ? ' --config '.s:rcfile : ' --no-eslintrc'
let s:cmd .= ' --fix '
let s:cmd .= s:buf

let b:fixname = 'eslint'
let b:fixprgfunc = s:cmd
