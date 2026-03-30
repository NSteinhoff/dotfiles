if exists("current_compiler") && current_compiler != 'biome'
    finish
endif
let current_compiler = "biome"

if exists(":CompilerSet") != 2
    command! -nargs=* CompilerSet setlocal <args>
endif

execute 'CompilerSet makeprg=npx\ biome\ check\ --colors=off\ --log-kind=compact\ --error-on-warnings\ $*'
CompilerSet errorformat=%f:%l:%c\ %m
