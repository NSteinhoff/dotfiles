if exists("current_compiler") && current_compiler != 'tsgo'
    finish
endif
let current_compiler = "tsgo"

CompilerSet errorformat=
            \%f\ %#(%l\\,%c):\ %trror\ TS%n:\ %m,
            \%trror\ TS%n:\ %m,
            \%-G%.%#

let gitroot = finddir('.git', ".;$HOME,;$HOME")
let rootrcfile = !empty(gitroot) ? findfile('tsconfig.json', fnamemodify(gitroot, ':p:h:h')) : ''
let rcfile = empty(rootrcfile) ? findfile('tsconfig.json', ".;$HOME,;$HOME") : rootrcfile
" let rcfile = findfile('tsconfig.json', ".;$HOME,;$HOME")

if rcfile == ''
    CompilerSet makeprg=tsgo\ --noEmit\ $*\ %
    finish
endif

let project_root = fnamemodify(rcfile, ":h")
execute 'CompilerSet makeprg=tsgo\ --build\ '.rcfile.'\ $*'
