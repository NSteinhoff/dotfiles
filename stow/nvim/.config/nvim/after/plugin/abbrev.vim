" ------------------------------- Command Line --------------------------------
" Open man pages
cabbrev man Man

" ---------------------------------- Dates ------------------------------------
" Local date
iabbrev <expr> ddd strftime("%Y-%m-%d")
" Local date in human readable format
iabbrev <expr> ddh strftime("%d %B %Y")
" Local date in German format
iabbrev <expr> ddg strftime("%d.%m.%Y")
" Local date-time
iabbrev <expr> ddc strftime("%c")
" Long format
iabbrev <expr> ddl strftime("%a %b %e %Y %r")

" --------------------------------- Favicon -----------------------------------
" Favicon href
iabbrev "myfavicon" "https://gist.githubusercontent.com/NSteinhoff/9bc4844403ca3d1e2f9a3c698dfc1493/raw/069483f72ee493a4cb890c1c18de43666c1096e0/favicon.ico"

" vim:foldmethod=marker textwidth=0
