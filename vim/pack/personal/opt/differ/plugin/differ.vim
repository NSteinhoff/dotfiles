" Vim plugin for diffing files against a chosen git ref.
" Last Change:      Sat 19 Oct 2019 08:24:00 CEST
" Maintainer:       Niko Steinhoff <niko.steinhoff@gmail.com>
" License:          This file is placed in the public domain.

command! Dstatus call differ#status()

command! -nargs=? -bang Dcomment call differ#comment(<q-args>, "<bang>")
command! -bang Dshowcomments call differ#show_comments("<bang>" == '!')

command! Dthis call differ#diff('')
command! -bang Dpatch call differ#patch('', "<bang>")
command! -bang Dremote call differ#set_target("<bang>")
command! Dupdate call differ#update()
command! Dnext only <bar> next <bar> Dthis
command! Dprevious only <bar> previous <bar> Dthis
