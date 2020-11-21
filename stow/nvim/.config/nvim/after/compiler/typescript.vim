if exists("current_compiler")
  finish
endif
let current_compiler = "typescript"

if exists(":CompilerSet") != 2
  command! -nargs=* CompilerSet setlocal <args>
endif

let rcfile = findfile('tsconfig.json', ",.;$HOME")

if rcfile != ''
    let project_root = fnamemodify(rcfile, ":h")
    execute 'CompilerSet makeprg=npx\ tsc\ --build\ '.project_root.'\ $*'
else
    CompilerSet makeprg=npx\ tsc\ --build\ $*
endif
CompilerSet errorformat=%+A\ %#%f\ %#(%l\\\,%c):\ %m,%C%m
