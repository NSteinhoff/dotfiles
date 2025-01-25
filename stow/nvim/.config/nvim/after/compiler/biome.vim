if exists("current_compiler") && current_compiler != 'biome'
    finish
endif
let current_compiler = "biome"

if exists(":CompilerSet") != 2
    command! -nargs=* CompilerSet setlocal <args>
endif

let buf = expand('%')

let path = (isdirectory(buf) ? buf..';$HOME,' : '')..'.;$HOME,;$HOME,'
let cmd = 'npx\ biome'

execute 'CompilerSet makeprg=biome\ lint\ --colors=off\ --log-kind=compact\ $*'
CompilerSet errorformat=%f:%l:%c\ %m
