let current_compiler = "jest"

CompilerSet makeprg=npx\ jest\ --no-verbose\ --silent\ --no-coverage\ --ci\ --no-color\ $*
CompilerSet errorformat=%.%#\ (%f:%l:%c)
