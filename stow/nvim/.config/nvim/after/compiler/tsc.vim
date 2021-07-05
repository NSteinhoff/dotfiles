if exists("current_compiler") && current_compiler != 'tsc'
    finish
endif

let rcfile = findfile('tsconfig.json', ".;$HOME,;$HOME")
if rcfile == ''
    finish
endif

let project_root = fnamemodify(rcfile, ":h")
execute 'CompilerSet makeprg=npx\ tsc\ --project\ '.project_root.'\ $*'
CompilerSet errorformat^=
            \%-GDone%.%#,
            \%-G$\ %.%#,
            \%-Gyarn\ run%.%#,
            \%-Gerror\ Command\ failed%.%#,
            \%-Ginfo\ Visit%.%#,
