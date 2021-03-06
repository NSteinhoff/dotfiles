" Vim compiler file
" Language:             Scala SBT (http://www.scala-sbt.org/)
" Maintainer:           Derek Wyatt
" URL:                  https://github.com/derekwyatt/vim-scala
" License:              Apache 2
" ----------------------------------------------------------------------------

let current_compiler = "sbt"

CompilerSet makeprg=sbt\ -Dsbt.log.noformat=true\ compile
CompilerSet errorformat=
      \%E\ %#[error]\ %f:%l:%c:\ %m,%C\ %#[error]\ %p^,%-C%.%#,%Z,
      \%W\ %#[warn]\ %f:%l:%c:\ %m,%C\ %#[warn]\ %p^,%-C%.%#,%Z,
      \%-G%.%#
