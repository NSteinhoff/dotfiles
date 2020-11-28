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
    execute 'CompilerSet makeprg=yarn\ tsc\ --build\ '.project_root.'\ $*'
else
    CompilerSet makeprg=yarn\ tsc\ --build\ $*
endif
CompilerSet errorformat=
            \%-GDone%.%#,
            \%-G$\ %.%#,
            \%-Gyarn\ run%.%#,
            \%-Gerror\ Command\ failed%.%#,
            \%-Ginfo\ Visit%.%#,
            \%+A\ %#%f\ %#(%l\\,%c):\ %m,
            \%C\ %#%m,
