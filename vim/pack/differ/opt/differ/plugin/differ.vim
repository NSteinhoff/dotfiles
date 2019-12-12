" Vim plugin for diffing files against a chosen git ref.
" Last Change:      Sat 19 Oct 2019 08:24:00 CEST
" Maintainer:       Niko Steinhoff <niko.steinhoff@gmail.com>
" License:          This file is placed in the public domain.

command! DStatus call differ#status()
command! -nargs=? -bang DComment call differ#comment(<q-args>, "<bang>")
command! DShowComments call differ#show_comments()

command! DThis call differ#diff('')
command! -bang DPatch call differ#patch('', "<bang>")
command! -bang DRemote call differ#set_target("<bang>")

nnoremap <leader>dr :DRemote<cr>
nnoremap <leader>dR :DRemote!<cr>
nnoremap <leader>dt :DThis<cr>
nnoremap <leader>dp :DPatch<cr>
nnoremap <leader>dP :DPatch!<cr>
nnoremap <leader>ds :DStatus<cr>
nnoremap <leader>dc :DComment<cr>
nnoremap <leader>dC :DShowComments<cr>
