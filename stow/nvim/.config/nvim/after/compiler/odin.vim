if exists('current_compiler')
  finish
endif
let current_compiler = 'odin'

CompilerSet makeprg=odin\ check\ .
CompilerSet errorformat=%f(%l:%c)\ %m
