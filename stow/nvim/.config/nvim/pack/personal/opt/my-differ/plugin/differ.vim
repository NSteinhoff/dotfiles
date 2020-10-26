" Vim plugin for diffing files against a chosen git ref.
" Last Change:      Mon 08 Jun 2020 08:57:26 AM
" Maintainer:       Niko Steinhoff <niko.steinhoff@gmail.com>
" License:          This file is placed in the public domain.

command! Dstatus call differ#status()
command! -bang Dremote call differ#set_target("<bang>")

command! -nargs=? -bang Dcomment call differ#comment(<q-args>, "<bang>")
command! -bang Dshowcomments call differ#show_comments("<bang>" == '!')

command! Dthis call differ#diff('')
command! -bang Dpatch call differ#patch('', "<bang>")

command! Dupdate call differ#update()
command! Dnext next <bar> only <bar> Dthis
command! Dprevious  previous <bar> only <bar> Dthis
