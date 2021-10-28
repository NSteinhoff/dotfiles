if exists("current_compiler") && current_compiler != 'eslint'
    finish
endif
let current_compiler = "eslint"

if exists(":CompilerSet") != 2
    command! -nargs=* CompilerSet setlocal <args>
endif

let buf = expand('%')

let path = (isdirectory(buf) ? buf..';$HOME,' : '')..'.;$HOME,;$HOME,'

let rcfile = findfile('.eslintrc.js', path)
if rcfile != ''
    let project_root = fnamemodify(rcfile, ":h")
    let src_dir = project_root..'/src/'
    execute 'CompilerSet makeprg=npx\ eslint\ --config\ '.rcfile.'\ --format\ compact\ --ext\ .tsx,.ts\ '.src_dir.'\ $*'
else
    CompilerSet makeprg=npx\ eslint\ --format\ compact\ %\ $*'
endif
CompilerSet errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
