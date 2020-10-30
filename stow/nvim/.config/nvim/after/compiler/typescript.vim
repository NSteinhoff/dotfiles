if exists("current_compiler")
  finish
endif
let current_compiler = "typescript"

if exists(":CompilerSet") != 2
  command! -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=tsc\ --noEmit\ $*
CompilerSet errorformat=%+A\ %#%f\ %#(%l\\\,%c):\ %m,%C%m
