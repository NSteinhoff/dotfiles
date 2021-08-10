if exists("current_compiler") && current_compiler != 'tsc'
    finish
endif

" let gitroot = finddir('.git', ".;$HOME,;$HOME")
" let rootrcfile = !empty(gitroot) ? findfile('tsconfig.json', fnamemodify(gitroot, ':p:h:h')) : ''
" let rcfile = empty(rootrcfile) ? findfile('tsconfig.json', ".;$HOME,;$HOME") : rootrcfile
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
