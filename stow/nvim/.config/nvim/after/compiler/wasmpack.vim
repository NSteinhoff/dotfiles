" Vim compiler file
" Compiler:         Cargo Compiler (extended)
" Maintainer:       Niko Steinhoff <niko.steinhoff@gmail.com>
" Latest Revision:  Mon 25 May 2020 08:31:47 AM

if exists('current_compiler')
    finish
endif
runtime compiler/cargo.vim
let current_compiler = "wasmpack"

CompilerSet makeprg=wasm-pack\ build
