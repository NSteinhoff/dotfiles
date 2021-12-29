let buf = expand('%')
if empty(buf)|finish|endif

let path = (isdirectory(buf) ? buf..';$HOME,' : '')..'.;$HOME,;$HOME,'
let ispackage = !empty(findfile('package.json', path))
let rcfile = findfile('.eslintrc.js', path)

let eslint = (ispackage && executable('npx') ? 'npx ' : '')
let eslint.= 'eslint'
let eslint.= !empty(rcfile) ? ' --config '.rcfile : ' --no-eslintrc'
let eslint.= ' --fix '
let eslint.= buf

let b:fixprg = eslint
