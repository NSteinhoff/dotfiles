if exists("current_compiler")
    finish
endif

runtime! compiler/tsc.vim

let current_compiler = "yarn"
CompilerSet makeprg=yarn\ compile:plain
