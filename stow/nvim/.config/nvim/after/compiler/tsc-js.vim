if exists("current_compiler")
  finish
endif
let current_compiler = "tsc-js"

" CompilerSet makeprg=npx\ tsc

CompilerSet makeprg=tsc
CompilerSet errorformat=%f\ %#(%l\\,%c):\ %trror\ TS%n:\ %m,
		       \%trror\ TS%n:\ %m,
		       \%-G%.%#

CompilerSet errorformat^=
            \%-GDone%.%#,
            \%-G$\ %.%#,
            \%-Gyarn\ run%.%#,
            \%-Gerror\ Command\ failed%.%#,
            \%-Ginfo\ Visit%.%#,

let gitroot = finddir('.git', ".;$HOME,;$HOME")
let rootrcfile = !empty(gitroot) ? findfile('jsconfig.json', fnamemodify(gitroot, ':p:h:h')) : ''
let rcfile = empty(rootrcfile) ? findfile('jsconfig.json', ".;$HOME,;$HOME") : rootrcfile

if rcfile == ''
    CompilerSet makeprg=npx\ tsc\ --strict\ --checkJs\ --noEmit\ --lib\ esnext,dom\ --target\ esnext\ --module\ esnext\ $*\ %
    finish
endif

let project_root = fnamemodify(rcfile, ":h")
execute 'CompilerSet makeprg=npx\ tsc\ --build\ '.rcfile.'\ $*'
