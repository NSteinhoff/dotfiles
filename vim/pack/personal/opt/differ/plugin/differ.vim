" Vim plugin for diffing files against a chosen git ref.
" Last Change:      Sat 19 Oct 2019 08:24:00 CEST
" Maintainer:       Niko Steinhoff <niko.steinhoff@gmail.com>
" License:          This file is placed in the public domain.

command! Dstatus call differ#status()
command! -nargs=? -bang Dcomment call differ#comment(<q-args>, "<bang>")
command! Dshowcomments call differ#show_comments()

command! Dthis call differ#diff('')
command! -bang Dpatch call differ#patch('', "<bang>")
command! -bang Dremote call differ#set_target("<bang>")
command! Dupdate call differ#update()
command! Dnext only <bar> next <bar> Dthis
command! Dprevious only <bar> previous <bar> Dthis

nnoremap <leader>dr :Dremote<cr>
nnoremap <leader>dR :Dremote!<cr>
nnoremap <leader>du :Dupdate<cr>
nnoremap <leader>dt :Dthis<cr>
nnoremap <leader>dp :Dpatch<cr>
nnoremap <leader>dP :Dpatch!<cr>
nnoremap <leader>ds :Dstatus<cr>
nnoremap <leader>dc :Dcomment<cr>
nnoremap <leader>dC :DshowComments<cr>
nnoremap <leader>]d :Dnext<cr>
nnoremap <leader>[d :Dprevious<cr>
