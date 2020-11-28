if exists("current_compiler")
  finish
endif
let current_compiler = "jest"

CompilerSet makeprg=yarn\ jest\ --no-verbose\ --silent\ --no-coverage\ --only-changed\ $*
CompilerSet errorformat=%.%#\ (%f:%l:%c)
