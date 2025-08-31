if exists("current_compiler") && current_compiler != 'eslint'
    finish
endif
let current_compiler = "eslint"

if exists(":CompilerSet") != 2
    command! -nargs=* CompilerSet setlocal <args>
endif

let s:buf = expand('%')
if empty(s:buf)|finish|endif

let s:path = (isdirectory(s:buf) ? s:buf..';$HOME,' : '')..'.;$HOME,;$HOME,'
let s:is_package = !empty(findfile('package.json', s:path))
let s:is_pnpm = !empty(findfile('pnpm-lock.yaml', s:path))
let s:rcfile = findfile('.eslintrc.js', s:path)

let s:cmd = ''
if s:is_package && s:is_pnpm && executable('pnpm')
    let s:cmd  .= 'pnpm\ --silent\ dlx'
elseif s:is_package && executable('npx')
    let s:cmd  .= 'NPM_CONFIG_LOGLEVEL=silent\ npx'
endif

let rcfile = findfile('.eslintrc.js', s:path)
if rcfile != ''
    let project_root = fnamemodify(rcfile, ":h")
    let src_dir = project_root..'/src/'
    execute 'CompilerSet makeprg='.s:cmd.'\ eslint\ --config\ '.rcfile.'\ --format\ compact\ --ext\ .js,.jsx,.ts,.tsx\ '..src_dir
else
    execute 'CompilerSet makeprg='.s:cmd.'\ eslint\ --format\ compact\ $*'
endif
CompilerSet errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
