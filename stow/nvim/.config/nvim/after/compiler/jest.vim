let current_compiler = "jest"

CompilerSet makeprg=npx\ jest\ --no-verbose\ --silent\ --no-coverage\ --ci\ --color=false\ $*
CompilerSet errorformat=%.%#\ (%f:%l:%c)
