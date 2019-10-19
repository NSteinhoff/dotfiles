" Vim plugin for diffing files against a chosen git ref.
" Last Change:      2019 Sep 06
" Maintainer:       Niko Steinhoff <niko.steinhoff@gmail.com>
" License:          This file is placed in the public domain.

command! -complete=customlist,differ#list_refs -nargs=? Diff call differ#diff(<q-args>)
command! -complete=customlist,differ#list_refs -nargs=? Patch call differ#patch(<q-args>)
command! -complete=customlist,differ#list_refs -nargs=? PatchAll call differ#patch_all(<q-args>)
command! -complete=customlist,differ#list_refs -nargs=? DiffTarget call differ#set_target(<q-args>)
command! DiffStatus call differ#status()
