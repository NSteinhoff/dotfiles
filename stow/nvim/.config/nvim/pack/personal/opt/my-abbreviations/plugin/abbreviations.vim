" --- Dates{{{
" Last modification date of the current file
iabbrev <expr> ddf strftime("%Y %b %d", getftime(expand('%')))"
iabbrev <expr> ddF strftime("%c", getftime(expand('%')))"

" Local date-time
iabbrev <expr> ddc strftime("%c")

" Local date
iabbrev <expr> ddd strftime("%Y-%m-%d")
" Local date in human readable format
iabbrev <expr> ddh strftime("%Y %b %d")
"}}}

" vim:foldmethod=marker textwidth=0
