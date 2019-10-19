" Vim plugin for diffing files against a chosen git ref.
" Last Change:      Sat 19 Oct 2019 08:24:00 CEST
" Maintainer:       Niko Steinhoff <niko.steinhoff@gmail.com>
" License:          This file is placed in the public domain.

command! DStatus call differ#status()

command! -complete=customlist,differ#list_refs -nargs=? DThis call differ#diff(<q-args>)
command! -complete=customlist,differ#list_refs -nargs=? -bang DPatch call differ#patch(<q-args>, "<bang>")
command! -complete=customlist,differ#list_refs -nargs=? -bang DRemote call differ#set_target(<q-args>, "<bang>")

nnoremap <leader>dt :DThis<cr>
nnoremap <leader>ds :DStatus<cr>
