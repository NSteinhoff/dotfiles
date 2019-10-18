" Dockerfile linter


if exists("current_compiler")
    finish
endif
let current_compiler = "dockerfile"

if exists(":CompilerSet") != 2
    command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet errorformat=%f:%l\ %t%.%n\ %m
CompilerSet makeprg=hadolint\ %
