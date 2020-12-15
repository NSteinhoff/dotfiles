if exists("current_compiler") && !(current_compiler == 'tsc')
  finish
endif

let rcfile = findfile('package.json', ".;$HOME,;$HOME")
if rcfile != ''
    let project_root = fnamemodify(rcfile, ":h")
    execute 'CompilerSet makeprg=yarn\ tsc\ --build\ '.project_root.'\ $*'
    CompilerSet errorformat^=
                \%-GDone%.%#,
                \%-G$\ %.%#,
                \%-Gyarn\ run%.%#,
                \%-Gerror\ Command\ failed%.%#,
                \%-Ginfo\ Visit%.%#,
endif
