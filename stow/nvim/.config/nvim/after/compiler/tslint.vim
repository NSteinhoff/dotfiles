if exists("current_compiler")
  finish
endif
let current_compiler = "tslint"

if exists(":CompilerSet") != 2
  command! -nargs=* CompilerSet setlocal <args>
endif

let rcfile = findfile('tsconfig.json', ".;$HOME")
if rcfile != ''
    let project_root = fnamemodify(rcfile, ":h")
    execute 'CompilerSet makeprg=npx\ tslint\ --project\ '.project_root.'\ $*'
else
    CompilerSet makeprg=npx\ tslint\ %\ $*'
endif
CompilerSet errorformat=%A%f:%l:%c,%ZERROR:\ %l:%c\ %m,%-G%.%#

command -buffer FixFile :make --fix %
