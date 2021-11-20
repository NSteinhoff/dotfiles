if exists("current_compiler") && current_compiler != 'eslint'
    finish
endif
let current_compiler = "eslint"

if exists(":CompilerSet") != 2
    command! -nargs=* CompilerSet setlocal <args>
endif

let buf = expand('%')

let path = (isdirectory(buf) ? buf..';$HOME,' : '')..'.;$HOME,;$HOME,'
let cmd = executable('eslint_d') ? 'eslint_d' : 'npx\ eslint'

let rcfile = findfile('.eslintrc.js', path)
if rcfile != ''
    let project_root = fnamemodify(rcfile, ":h")
    let src_dir = project_root..'/src/'
    execute 'CompilerSet makeprg='.cmd.'\ --config\ '.rcfile.'\ --format\ compact\ --ext\ .js,.jsx,.ts,.tsx\ '..src_dir
else
    execute 'CompilerSet makeprg='.cmd.'\ --format\ compact\ $*'
endif
CompilerSet errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
